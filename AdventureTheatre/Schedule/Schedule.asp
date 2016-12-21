<!--#INCLUDE virtual="PrivateLabelInclude.asp" -->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->

<%
'set the flag to include the TooltipInclude.html file
TooltipIncludeFlag = "Y"
Page = "Schedule"

QueryString = Request.ServerVariables("QUERY_STRING") 
If QueryString <> "" Then
	QueryString = "?" & QueryString
End If

'If MemberID was sent, check validity and login if appropriate
If Clean(Request("MemberID")) <> "" Then
	MemberID = Clean(Request("MemberID"))
	MemberPassword = Clean(Request("MemberPassword"))
	SQLLogin = "SELECT MemberID, MemberPassword, MemberType FROM Members (NOLOCK) WHERE OrganizationNumber = '" & CleanNumeric(Request("OrganizationNumber")) & "' AND MemberID = '" & MemberID & "' AND MemberPassword = '" & MemberID & "'"
	Set rsLogin = OBJdbConnection.Execute(SQLLogin)
	
	If Not rsLogin.EOF Then
		Session("MemberID") = rsLogin("MemberID")
		Session("MemberType") = rsLogin("MemberType")
		Session("MemberOrganizationNumber") = CleanNumeric(Request("OrganizationNumber"))
	Else
		Message = "Invalid Code"
	End If
	
	rsLogin.Close
	Set rsLogin = nothing
	
End If		

If Clean(Request("FormName")) <> "" Then 
	FormName = Clean(Request("FormName"))
End If

If FormName = "Logout" Then
    Session.Contents.Remove("MemberID")
    Session.Contents.Remove("MemberType")
    Session.Contents.Remove("MemberOrganizationNumber")
    Call DBClose(OBJdbConnection)
    Response.Redirect("/Clients/AdventureTheatre/Schedule/Schedule.asp" & QueryString)
End If

'REE 6/19/9 - Added Dynamic Page Title
'REE 10/23/9 - Modified to use dynamic title only when no PL Title exists.
'REE 1/16/10 - Added CleanNumerics throughout
If Request("OrganizationNumber")<> "" And Title = "" Then
    SQLOrg = "SELECT Organization FROM Organization (NOLOCK) WHERE OrganizationNumber = " & CleanNumeric(Request("OrganizationNumber"))
    Set rsOrg = OBJdbConnection.Execute(SQLOrg)
    
    Title = rsOrg("Organization") & " Ticket Sales"
    
    rsOrg.Close
    Set rsOrg = nothing
End If    
%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<TITLE><%= Title %></TITLE>
</HEAD>
<%= strBody %>


<!--#INCLUDE virtual="TopNavInclude.asp" -->

<BR>

<%
'JAI 6/17/8 - Added Pre-Sale login box if organization has an active pre-sale event
'JAI 9/28/8 - Changed to display pre-sale box for upcoming pre-sale events also.
'JAI 10/29/8 - Changed to remove pre-sale box if all pre-sale events are also on sale to the public
PreSaleActive = FALSE
SQLPreSale = "SELECT Event.EventCode From Event (NOLOCK) INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode LEFT JOIN MemberSaleStartDate (NOLOCK) ON Event.EventCode = MemberSaleStartDate.EventCode WHERE Event.OnSale = 1 AND OrganizationAct.OrganizationNumber = '" & CleanNumeric(Request("OrganizationNumber")) & "' AND OrganizationVenue.OrganizationNumber = '" & CleanNumeric(Request("OrganizationNumber")) & "' AND MemberSaleStartDate.OrganizationNumber = '" & CleanNumeric(Request("OrganizationNumber")) & "' AND IsNull(MemberSaleStartDate.MemberSaleEndDate, DATEADD(DAY, 1, GETDATE())) > '" & Now() & "' AND SaleStartDate > '" & Now() & "'"
Set rsPreSale = OBJdbConnection.Execute(SQLPreSale)
If Not rsPreSale.EOF Then 'There are active pre-sale events, so display pre-sale box if not logged in
    PreSaleActive = TRUE
End If
rsPreSale.Close
Set rsPreSale = Nothing



'JAI 2/9/3 - Added Venue Option to Customize Event Schedule Title
If ScheduleTitle <> "" Then
	Response.Write "<FONT FACE=" & FontFace & " COLOR=" & HeadingFontColor & "><H3>" & ScheduleTitle & "</H3></FONT>" & vbCrLf
Else
	'REE 6/5/3 - Modified from default of "Event Schedule" to "Schedule"
	Response.Write "<FONT FACE=" & FontFace & " COLOR=" & HeadingFontColor & "><H3>Schedule</H3></FONT>" & vbCrLf
End If

SQLWhere = "WHERE Event.EventDate >= '" & FormatDateTime(Now(), vbShortDate) & "'"

'REE 8/26/3 - Added new Start and End Date Criteria.  This allows dates to be passed in URL.
If IsDate(Clean(Request("StartDate"))) Then
	SQLWhere = SQLWhere & " AND Event.EventDate >= '" & CDate(Clean(Request("StartDate"))) & "'"
End If
If IsDate(Clean(Request("EndDate"))) Then
	SQLWhere = SQLWhere & " AND Event.EventDate < '" & CDate(Clean(Request("EndDate"))) + 1 & "'"
End If

'REE 4/9/2 - Added criteria for ActCode
'REE 7/6/2 - Added criteria for Organization
If Request("OrganizationNumber") <> "" Then SQLWhere = SQLWhere & " AND OrganizationAct.OrganizationNumber = '" & CleanNumeric(Request("OrganizationNumber")) & "' AND OrganizationVenue.OrganizationNumber = '" & CleanNumeric(Request("OrganizationNumber")) & "'"

'REE 7/13/9 - Added CleanNumList function
If Request("ActCode") <> "" Then SQLWhere = SQLWhere & " AND Event.ActCode IN (" & CleanNumList(Request("ActCode")) & ")"
If Request("VenueCode") <> "" Then SQLWhere = SQLWhere & " AND Venue.VenueCode IN( " & CleanNumList(Request("VenueCode")) & ")"
If Request("EventCode") <> "" Then SQLWhere = SQLWhere & " AND Event.EventCode IN (" & CleanNumList(Request("EventCode")) & ")"

'REE 7/13/9 - Added logic to insure categories passed to script are existing categories to prevent potential SQL injection.
If Request("Category") <> "" Then
    Dim arrCategory(50)
    SQLCategory = "SELECT Category FROM Category (NOLOCK) ORDER BY Category"
    Set rsCategory = OBJdbConnection.Execute(SQLCategory)
    
    Do Until rsCategory.EOF
        arrCategory(CatCount) = UCase(rsCategory("Category"))
        CatCount = CatCount + 1    
        rsCategory.MoveNext
    Loop
    
    rsCategory.Close
    Set rsCategory = nothing
    
    RequestArray = Split(Request("Category"), ",")
    
    Dim CatList
    For Each RequestCategory In RequestArray
        For Each DBCategory In arrCategory
            If UCase(RequestCategory) = DBCategory Then
                CatList = CatList & "'" & Clean(RequestCategory) & "',"
            End If
        Next
    Next
    CatList = Left(CatList, Len(CatList) - 1) 'Trim last comma
    
    SQLWhere = SQLWhere & " AND Category.Category IN (" & CatList & ")"
End If    

'REE 10/11/3 - Commented out Venue specific criteria.  This is controlled by OrgVenue

'REE 7/6/2 - Added Join to OrganizationAct and OrganizationVenue.  Added DISTINCT parameter.
'REE 4/26/3 - Added Act.Act to the Sort Criteria after EventDate
'JAI 8/6/3 - Added ability to sort by Act first, then event date
'JAI 7/15/9 - Added ability to display all Active events, regardless of OnSale Date
If UCase(Request("DisplayAll")) = "Y" Then
    DisplayEvents = "1 = 1"    
Else
    DisplayEvents = "Event.SaleStartDate <= '" & Now() & "'"
End If    
SQLQuery = "SELECT DISTINCT EventDate, Event.EventCode, Act, City, State, Venue, Category, SubCategory From Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Category (NOLOCK) ON Act.CategoryCode = Category.CategoryCode INNER JOIN SubCategory (NOLOCK) ON Act.SubCategoryCode = SubCategory.SubCategoryCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode LEFT JOIN MemberSaleStartDate (NOLOCK) ON Event.EventCode = MemberSaleStartDate.EventCode " & SQLWhere & " AND Event.OnSale = 1 AND (MemberSaleStartDate.OrganizationNumber = '" & CleanNumeric(Request("OrganizationNumber")) & "' AND MemberSaleStartDate.MemberType = '" & Session("MemberType") & "' AND MemberSaleStartDate.MemberSaleStartDate <= '" & Now() & "' AND IsNull(MemberSaleStartDate.MemberSaleEndDate, DATEADD(DAY, 1, GETDATE())) > '" & Now() & "' OR " & DisplayEvents & ")"
Select Case UCase(Request("SortOrder"))
Case "ACT"
	SQLQuery = SQLQuery & " ORDER BY Act.Act, Event.EventDate"
Case "CATEGORY"
	SQLQuery = SQLQuery & " ORDER BY Category, Event.EventDate"
Case "SUBCATEGORY"
	SQLQuery = SQLQuery & " ORDER BY SubCategory, Event.EventDate"
'REE 12/15/6 - Added Venue, Act sort	
Case "VENUEACT"
	SQLQuery = SQLQuery & " ORDER BY Venue.Venue, Act.Act, Event.EventDate"
'REE 01/22/7 - Added Venue, EventDate, Act sort	
Case "VENUEEVENTDATE"
	SQLQuery = SQLQuery & " ORDER BY Venue.Venue, Event.EventDate, Act.Act"
Case Else
	SQLQuery = SQLQuery & " ORDER BY Event.EventDate, Act.Act"
End Select
Set rsEvents = OBJdbConnection.Execute(SQLQuery)

'JAI 4/12/5 - Open OBJdbConnection2 for Loop reads.
Call DBOpen(OBJdbConnection2)
	  
If Not rsEvents.EOF Then
	Response.Write "<TABLE CELLSPACING=""0"" CELLPADDING=""0"" WIDTH=""90%"" BORDER=""0"">" & vbCrLf
	If IncludeVenueLocation Then
		Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=8 HEIGHT=2><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>Date/Time</B></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>Event</B></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>Venue/Location</B></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>Tickets</B></FONT></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=8 HEIGHT=2><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=8 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=8 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
	Else
		Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=6 HEIGHT=2><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>Date/Time</B></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>Event</B></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>Tickets</B></FONT></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=6 HEIGHT=2><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=6 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=6 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
	End If

	'JAI 3/26/10 - Added VenueOption to display Sold Out Message
	SQLScheduleSoldOutFlag = "SELECT OptionValue AS ScheduleSoldOutFlag FROM VenueOptions (NOLOCK) WHERE VenueCode = " & iVenueCode & " AND OptionName = 'ScheduleSoldOutFlag' AND OptionValue = 'Y'"
	Set rsScheduleSoldOutFlag = OBJdbConnection2.Execute(SQLScheduleSoldOutFlag)
	If Not rsScheduleSoldOutFlag.EOF Then 'Set the Sold Out Flag for any events which do not have available tickets
		ScheduleSoldOutFlag = True
	End If
	rsScheduleSoldOutFlag.Close
	Set rsScheduleSoldOutFlag = nothing

	Do While Not rsEvents.EOF
        strDate = FormatDateTime(rsEvents("EventDate"),vbShortDate)
        'REE 11/27/8 - Modified to use WeekdayName function
        strWeekDay = WeekdayName(Weekday(rsEvents("EventDate")), True) & "."
        strTime = Left(FormatDateTime(rsEvents("EventDate"),vbLongTime),Len(FormatDateTime(rsEvents("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsEvents("EventDate"),vbLongTime),3)

        'REE 5/14/3 - Added ActSuffix
        SQLActSuffix = "SELECT OptionValue AS ActSuffix FROM EventOptions (NOLOCK) WHERE EventCode = " & rsEvents("EventCode") & " AND OptionName = 'ActSuffix'"
        Set rsActSuffix = OBJdbConnection2.Execute(SQLActSuffix)
        If Not rsActSuffix.EOF Then 'Use it
            ActSuffix = " - " & rsActSuffix("ActSuffix")
        Else
            ActSuffix = ""
        End If
        rsActSuffix.Close
        Set rsActSuffix = nothing

	    'REE 8/6/4 - Check for sold out
        If ScheduleSoldOutFlag Then
	        SQLSoldOut = "SELECT TOP 1 ItemNumber FROM Seat (NOLOCK) WHERE EventCode = " & rsEvents("EventCode") & " AND StatusCode = 'A'"
	        Set rsSoldOut = OBJdbConnection2.Execute(SQLSoldOut)
	        If rsSoldOut.EOF Then 'It's sold out.  Append Sold Out to ActSuffix.
	          ActSuffix = ActSuffix & " - SOLD OUT"
	        End If
	        rsSoldOut.Close
	        Set rsSoldOut = nothing
        End If
        	    
	    DisplayDate = ""

	    'REE 12/10/3 - Modified to look at EventOptions for Date & Time Display Options
	    SQLDateSuppress = "SELECT OptionValue AS DateSuppress FROM EventOptions (NOLOCK) WHERE EventCode = " & rsEvents("EventCode") & " AND OptionName = 'DateSuppress' AND OptionValue = 'Y'"
	    Set rsDateSuppress = OBJdbConnection2.Execute(SQLDateSuppress)
	    If rsDateSuppress.EOF Then
		    DisplayDate = DisplayDate & strWeekDay & "&nbsp;" & strDate
	    End If
	    rsDateSuppress.Close
	    Set rsDateSuppress = nothing

	    SQLTimeSuppress = "SELECT OptionValue AS TimeSuppress FROM EventOptions (NOLOCK) WHERE EventCode = " & rsEvents("EventCode") & " AND OptionName = 'TimeSuppress' AND OptionValue = 'Y'"
	    Set rsTimeSuppress = OBJdbConnection2.Execute(SQLTimeSuppress)
	    If rsTimeSuppress.EOF Then
		    DisplayDate = DisplayDate & "<BR>at " & strTime
	    End If
	    rsTimeSuppress.Close
	    Set rsTimeSuppress = nothing

        If IncludeVenueLocation Then
            Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=8 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
            'REE 5/17/10 - Added Flag to Suppress Tooltip
            If Not UCase(Request("Tooltip")) = "N" Then
                Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD>&nbsp;&nbsp;</TD><TD ALIGN=left NOWRAP><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1>" & DisplayDate & "</FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=Event.asp?Event=" & rsEvents("EventCode") & " id=""EventLink_" & rsEvents("EventCode") & """ onmouseover=""ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode=" & rsEvents("EventCode") & "\', this)', 200);"" onmouseout=""clearTimeout(ttDelay);hideTooltip();""><B>" & rsEvents("Act") & ActSuffix & "</B></A></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1>" & rsEvents("Venue") & "<BR>" & rsEvents("City") & ", " & rsEvents("State") & "</FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=Event.asp?Event=" & rsEvents("EventCode") & " id=""TixInfoLink_" & rsEvents("EventCode") & """ onmouseover=""ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode=" & rsEvents("EventCode") & "\', this)', 200);"" onmouseout=""clearTimeout(ttDelay);hideTooltip();"">Tix & Info</A>&nbsp;</FONT></TD></TR>" & vbCrLf
            Else
                Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD>&nbsp;&nbsp;</TD><TD ALIGN=left NOWRAP><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1>" & DisplayDate & "</FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=""Event.asp?Event=" & rsEvents("EventCode") & """><B>" & rsEvents("Act") & ActSuffix & "</B></A></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1>" & rsEvents("Venue") & "<BR>" & rsEvents("City") & ", " & rsEvents("State") & "</FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=""Event.asp?Event=" & rsEvents("EventCode") & """>Tix & Info</A>&nbsp;</FONT></TD></TR>" & vbCrLf
            End If
            Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=8 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
            Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=8 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
        Else
            Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=6 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
            'REE 5/17/10 - Added Flag to Suppress Tooltip
            If Not UCase(Request("Tooltip")) = "N" Then
                Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD>&nbsp;&nbsp;</TD><TD ALIGN=left NOWRAP><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1>" & DisplayDate & "</FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=Event.asp?Event=" & rsEvents("EventCode") & " id=""EventLink_" & rsEvents("EventCode") & """ onmouseover=""ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode=" & rsEvents("EventCode") & "\', this)', 200);"" onmouseout=""clearTimeout(ttDelay);hideTooltip();""><B>" & rsEvents("Act") & ActSuffix & "</B></A></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=Event.asp?Event=" & rsEvents("EventCode") & " id=""TixInfoLink_" & rsEvents("EventCode") & """ onmouseover=""ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode=" & rsEvents("EventCode") & "\', this)', 200);"" onmouseout=""clearTimeout(ttDelay);hideTooltip();"">Tix & Info</A>&nbsp;</FONT></TD></TR>" & vbCrLf
            Else
                Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD>&nbsp;&nbsp;</TD><TD ALIGN=left NOWRAP><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1>" & DisplayDate & "</FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=""Event.asp?Event=" & rsEvents("EventCode") & """><B>" & rsEvents("Act") & ActSuffix & "</B></A></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=""Event.asp?Event=" & rsEvents("EventCode") & """>Tix & Info</A>&nbsp;</FONT></TD></TR>" & vbCrLf
            End If                
            Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=6 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
            Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=6 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
        End If	
        events="Y"
        rsEvents.MoveNext
	Loop 

	Response.Write "</TABLE>" & vbCrLf

Else

	'REE 7/4/3 - Added VenueOption for No Events On Sale Message
	SQLNoEventsMessage = "SELECT OptionValue AS NoEventsMessage FROM VenueOptions (NOLOCK) WHERE VenueCode = " & iVenueCode & " AND OptionName = 'NoEventsMessage'"
	Set rsNoEventsMessage = OBJdbConnection2.Execute(SQLNoEventsMessage)
	  
	If Not rsNoEventsMessage.EOF Then 'Use the Message in Venue Options
		NoEventsMessage = rsNoEventsMessage("NoEventsMessage")
	Else
		NoEventsMessage = "There are no events on sale at this time.  Please check back again."
	End If
	
	rsNoEventsMessage.Close
	Set rsNoEventsMessage = nothing
	  
	Response.Write "<FONT FACE=" & FontFace & " COLOR=" & FontColor & " SIZE=2><BR>" & NoEventsMessage & "</FONT>"

End If

'JAI 4/12/5 - Close OBJdbConnection2
Call DBClose(OBJdbConnection2)

rsEvents.Close
Set rsEvents = Nothing
Response.Write "<BR><BR>" & vbCrLf

If Session("MemberID") = "" Then 'No member logged in
    If PreSaleActive Then 'Pre-sale event exists and is active, so display login box
        Response.Write "<TABLE CELLSPACING=""0"" CELLPADDING=""5"" HEIGHT=10 BORDER=""3"" BGCOLOR=""#FFFF99"" BORDERCOLOR=""#8E68AD"" BORDERCOLORLIGHT=""#8E68AD"" BORDERCOLORDARK=""#392748""><TR>" & vbCrLf 
        Response.Write "<TD ALIGN=""center""><FORM ACTION=/Clients/AdventureTheatre/Schedule/Schedule.asp" & QueryString & " METHOD=""post"" id=form1 name=form1><TABLE CELLPADDING=3 CELLSPACING=3 BORDER=0><TR><TD ALIGN=""right""><FONT FACE=" & FontFace & " COLOR=" & FontColor & " SIZE=2>Enter Pre-Sale Code (optional):&nbsp;<INPUT TYPE=""text"" NAME=""MemberID"" SIZE=""10""></FONT>"
        If Message <> "" Then
	        Response.Write "<BR><FONT FACE=" & FontFace & " COLOR=RED SIZE=1><B>" & Message & "&nbsp;&nbsp;&nbsp;</B></FONT>"
        End If
        Response.Write "</TD><TD ALIGN=""left"" VALIGN=""top""><INPUT TYPE=""submit"" VALUE=""Enter""></TD></TR>" & vbCrLf
        Response.Write "<TR><TD ALIGN=""center"" COLSPAN=""2""><FONT FACE=" & FontFace & " COLOR=" & FontColor & " SIZE=1>Upon entering a valid pre-sale code, the pre-sale events will appear above.<BR>This is not a discount code</FONT></TD></TR>" & vbCrLf
        Response.Write "</TABLE></TD></TR></TABLE></FORM>" & vbCrLf
    End If    
Else 'Member currently logged in
    Response.Write "<FORM ACTION=Schedule.asp" & QueryString & " METHOD=""post"" Name=Logout><INPUT TYPE=hidden NAME=FormName VALUE=Logout>"
    Response.Write "<TABLE CELLSPACING=""0"" CELLPADDING=""5"" HEIGHT=10 BORDER=""3"" BGCOLOR=""#FFFF99"" BORDERCOLOR=""#8E68AD"" BORDERCOLORLIGHT=""#8E68AD"" BORDERCOLORDARK=""#392748""><TR>" & vbCrLf
    Response.Write "<TD ALIGN=""center"" VALIGN=""top""><FONT FACE=" & FontFace & " COLOR=" & FontColor & " SIZE=1>You are currently logged in as Member ID: <B>" & Session("MemberID") & "</B><BR>Appropriate pre-sale events will appear above.<BR><BR><INPUT TYPE=""submit"" VALUE=""Logout""></FONT></TD></TR>" & vbCrLf
    Response.Write "</TABLE></FORM>" & vbCrLf
End If

%>


</CENTER>
<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>
</html>

<%

'REE 3/22/6 - Added Campaign Tracking
If Request("CampaignNumber") <> "" Then

	Session("CampaignNumber") = CleanNumeric(Request("CampaignNumber"))

    If Session("CustomerNumber") = "" Then
	    If Request("CustomerNumber") = "" Then
	        CustomerNumber = 1
        Else
            CustomerNumber = CleanNumeric(Request("CustomerNumber"))
        End If        	    
    Else
        CustomerNumber = Session("CustomerNumber")
    End If    

	'Check for existing CampaignLog entry for this Campaign and Customer
	SQLCampaignExist = "SELECT CampaignLogNumber FROM CampaignLog (NOLOCK) WHERE CampaignNumber = " & CleanNumeric(Request("CampaignNumber")) & " AND CustomerNumber = " & CustomerNumber & " ORDER BY DateOpened DESC"
	Set rsCampaignExist = OBJdbConnection.Execute(SQLCampaignExist)

	If Not rsCampaignExist.EOF Then 'Update existing record.
	
		SQLUpdateCampaignLog = "UPDATE CampaignLog WITH (ROWLOCK) SET ClickThroughDate = GETDATE() WHERE CampaignLogNumber = " & rsCampaignExist("CampaignLogNumber")
		Set rsUpdateCampaignLog = OBJdbConnection.Execute(SQLUpdateCampaignLog)
		
	Else 'Add Campaign Log Entry
	
		SQLAddCampaignLog = "INSERT CampaignLog(CampaignNumber, CustomerNumber, ClickThroughDate) VALUES(" & CleanNumeric(Request("CampaignNumber")) & ", " & CustomerNumber & ", GETDATE())"
		Set rsAddCampaignLog = OBJdbConnection.Execute(SQLAddCampaignLog)
		
	End If
	
	rsCampaignExist.Close
	Set rsCampaignExist = nothing
	
End If

'JAI 4/12/5 - Close OBJdbConnection
Call DBClose(OBJdbConnection)
%>

