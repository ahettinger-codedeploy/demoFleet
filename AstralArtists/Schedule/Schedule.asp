<!--#INCLUDE virtual="/PrivateLabelInclude.asp" -->
<!--#INCLUDE VIRTUAL="/GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="/dbOpenInclude.asp"-->
<%
Page = "Schedule"
%>

<!--#INCLUDE VIRTUAL="/PageTopInclude.asp" -->

<TITLE><%= Title %></TITLE>
</HEAD>
<%= strBody %>


<!--#INCLUDE virtual="/TopNavInclude.asp" -->

<BR>

<%
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
If Request("OrganizationNumber") <> "" Then SQLWhere = SQLWhere & " AND OrganizationAct.OrganizationNumber = '" & Clean(Request("OrganizationNumber")) & "' AND OrganizationVenue.OrganizationNumber = '" & Clean(Request("OrganizationNumber")) & "'"
If Request("ActCode") <> "" Then SQLWhere = SQLWhere & " AND Event.ActCode IN (" & Clean(Request("ActCode")) & ")"
If Request("VenueCode") <> "" Then SQLWhere = SQLWhere & " AND Venue.VenueCode IN( " & Clean(Request("VenueCode")) & ")"
If Request("EventCode") <> "" Then SQLWhere = SQLWhere & " AND Event.EventCode IN (" & Clean(Request("EventCode")) & ")"
If Request("Category") <> "" Then SQLWhere = SQLWhere & " AND Category.Category IN (" & Clean(Request("Category")) & ")"
'REE 10/11/3 - Commented out Venue specific criteria.  This is controlled by OrgVenue

'REE 7/6/2 - Added Join to OrganizationAct and OrganizationVenue.  Added DISTINCT parameter.
'REE 4/26/3 - Added Act.Act to the Sort Criteria after EventDate
'JAI 8/6/3 - Added ability to sort by Act first, then event date
Select Case Request("SortOrder")
Case "Act"
	SQLQuery = "SELECT DISTINCT EventDate, EventCode, Act, City, State, Venue From Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Category (NOLOCK) ON Act.CategoryCode = Category.CategoryCode INNER JOIN SubCategory (NOLOCK) ON Act.SubCategoryCode = SubCategory.SubCategoryCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode " & SQLWhere & "AND Event.OnSale = 1 AND Event.SaleStartDate <= '" & Now() &  "' ORDER BY Act.Act, Event.EventDate"
'REE 12/15/6 - Added Venue, Act sort	
Case "VenueAct"
	SQLQuery = "SELECT DISTINCT EventDate, EventCode, Act, City, State, Venue From Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Category (NOLOCK) ON Act.CategoryCode = Category.CategoryCode INNER JOIN SubCategory (NOLOCK) ON Act.SubCategoryCode = SubCategory.SubCategoryCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode " & SQLWhere & "AND Event.OnSale = 1 AND Event.SaleStartDate <= '" & Now() &  "' ORDER BY Venue.Venue, Act.Act, Event.EventDate"
'REE 01/22/7 - Added Venue, EventDate, Act sort	
Case "VenueEventDate"
	SQLQuery = "SELECT DISTINCT EventDate, EventCode, Act, City, State, Venue From Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Category (NOLOCK) ON Act.CategoryCode = Category.CategoryCode INNER JOIN SubCategory (NOLOCK) ON Act.SubCategoryCode = SubCategory.SubCategoryCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode " & SQLWhere & "AND Event.OnSale = 1 AND Event.SaleStartDate <= '" & Now() &  "' ORDER BY Venue.Venue, Event.EventDate, Act.Act"
Case Else
	SQLQuery = "SELECT DISTINCT EventDate, EventCode, Act, City, State, Venue From Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Category (NOLOCK) ON Act.CategoryCode = Category.CategoryCode INNER JOIN SubCategory (NOLOCK) ON Act.SubCategoryCode = SubCategory.SubCategoryCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode " & SQLWhere & "AND Event.OnSale = 1 AND Event.SaleStartDate <= '" & Now() &  "' ORDER BY Event.EventDate, Act.Act"
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

	Do While Not rsEvents.EOF
	  strDate = FormatDateTime(rsEvents("EventDate"),vbShortDate)
	  Select Case Weekday(rsEvents("EventDate"))
		Case 1
			strWeekDay = "Sun."
		Case 2
			strWeekDay = "Mon."
		Case 3
			strWeekDay = "Tue."
		Case 4
			strWeekDay = "Wed."
		Case 5
			strWeekDay = "Thu."
		Case 6
			strWeekDay = "Fri."
		Case 7
			strWeekDay = "Sat."
	  End Select
	  
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
		Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD>&nbsp;&nbsp;</TD><TD ALIGN=left NOWRAP><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1>" & DisplayDate & "</FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=/Event.asp?Event=" & rsEvents("EventCode") & "><B>" & rsEvents("Act") & ActSuffix & "</B></A></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1>" & rsEvents("Venue") & "<BR>" & rsEvents("City") & ", " & rsEvents("State") & "</FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=/Event.asp?Event=" & rsEvents("EventCode") & ">Click here to buy</A>&nbsp;</FONT></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=8 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=8 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
	  Else
		Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=6 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD>&nbsp;&nbsp;</TD><TD ALIGN=left NOWRAP><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1>" & DisplayDate & "</FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=/Event.asp?Event=" & rsEvents("EventCode") & "><B>" & rsEvents("Act") & ActSuffix & "</B></A></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=/Event.asp?Event=" & rsEvents("EventCode") & ">Click here to buy</A>&nbsp;</FONT></TD></TR>" & vbCrLf
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

%>

</CENTER>

<!--#INCLUDE virtual="/FooterInclude.asp"-->

</body>
</html>

<%

'REE 3/22/6 - Added Campaign Tracking
If Request("CampaignNumber") <> "" Then

	Session("CampaignNumber") = Clean(Request("CampaignNumber"))

	'Check for existing CampaignLog entry for this Campaign and Customer
	SQLCampaignExist = "SELECT CampaignLogNumber FROM CampaignLog (NOLOCK) WHERE CampaignNumber = " & Clean(Request("CampaignNumber")) & " AND CustomerNumber = " & Clean(Request("CustomerNumber")) & " ORDER BY DateOpened DESC"
	Set rsCampaignExist = OBJdbConnection.Execute(SQLCampaignExist)

	If Not rsCampaignExist.EOF Then 'Update existing record.
	
		SQLUpdateCampaignLog = "UPDATE CampaignLog WITH (ROWLOCK) SET ClickThroughDate = GETDATE() WHERE CampaignLogNumber = " & rsCampaignExist("CampaignLogNumber")
		Set rsUpdateCampaignLog = OBJdbConnection.Execute(SQLUpdateCampaignLog)
		
	Else 'Add Campaign Log Entry
	
		SQLAddCampaignLog = "INSERT CampaignLog(CampaignNumber, CustomerNumber, ClickThroughDate) VALUES(" & Clean(Request("CampaignNumber")) & ", " & Clean(Request("CustomerNumber")) & ", GETDATE())"
		Set rsAddCampaignLog = OBJdbConnection.Execute(SQLAddCampaignLog)
		
	End If
	
	rsCampaignExist.Close
	Set rsCampaignExist = nothing
	
End If

'JAI 4/12/5 - Close OBJdbConnection
Call DBClose(OBJdbConnection)
%>

