<%

'CHANGE LOG - Inception

'SSR 5/12/2011 - Custom schedule page to display subscriptions
'SSR 2/10/2012 - Updated schedule page with 2012 subscriptions
'SSR 4/14/2013 - Updated schedule page with 2013 subscriptions.
'SSR 4/18/2014 - Updated schedule page with 2014 subscriptions.

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'==================================================================

Page = "Schedule"
TooltipIncludeFlag = "Y"
OrgNumber = 2964

'=============================================================
'Tannery Pond 
'Schedule Subscription Schedule Page

'Event Listing
'---------------
'Link to First Floor Events Schedule page
'Link to Second Floor Events Schedule page
'Fixed Subscriptions
'Individual Events

'=============================================================

SubscriptionTitle = "2014 Season Subscriptions"
SingleEventTitle = "Single Performance Tickets"

Dim SeriesName(2)
SeriesName(1) = "4 Event Subscription Series 2014 (First Floor)"
SeriesName(2) = "4 Event Subscription Series 2014 (Second Floor)"

Dim SeriesLink(2)
SeriesLink(1) = "/Clients/TanneryPondConcerts/Schedule/ScheduleFlexSubscriptionsFirst.asp?OrganizationNumber=2964"  
SeriesLink(2) = "/Clients/TanneryPondConcerts/Schedule/ScheduleFlexSubscriptionsSecond.asp?OrganizationNumber=2964"   

'=============================================================

'REE 1/6/9 - Updated to use AJAX EventInfo on schedule items.
%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<TITLE><%= Title %></TITLE>
</HEAD>
<%= strBody %>


<!--#INCLUDE virtual="TopNavInclude.asp" -->

<BR>
<BR>

<%

'FLEX SUBSCRIPTIONS
'===================================
  
%>

<TABLE CELLSPACING="0" CELLPADDING="0" WIDTH="90%" BORDER="0">
    <tr><td colspan="7" align="center"><FONT FACE="<%=FontFace%>" COLOR="<%=HeadingFontColor%>"><h3><%=SubscriptionTitle%></h3></td></tr>
	<TR BGCOLOR="<%=TableCategoryBGColor%>">
	    <TD COLSPAN="7" HEIGHT="2"><IMG HEIGHT="1" SRC="/images/clear.gif" ALT=""></TD>
	</TR>
	<TR BGCOLOR="<%=TableCategoryBGColor%>">
	    <TD>&nbsp;&nbsp;</TD>
	    <TD>&nbsp;&nbsp;</TD>
	    <TD ALIGN="left"><FONT FACE="<%=FontFace%>" COLOR="<%=TableCategoryFontColor%>" SIZE="2"><B>series name</B></FONT></TD>
	    <TD>&nbsp;&nbsp;</TD>
	    <TD ALIGN="left"><FONT FACE="<%=FontFace%>" COLOR="<%=TableCategoryFontColor%>" SIZE="2"><B>&nbsp;</B></FONT></TD>
	    <TD>&nbsp;&nbsp;</TD>
	    <TD ALIGN="left"><FONT FACE="<%=FontFace%>" COLOR="<%=TableCategoryFontColor%>" SIZE="2"><B>tickets</B></FONT></TD>
	</TR>
	<TR BGCOLOR="<%=TableCategoryBGColor%>">
	    <TD COLSPAN="7" HEIGHT="2"><IMG HEIGHT="1" SRC="/images/clear.gif" ALT=""></TD>
    </TR>
	<TR BGCOLOR="<%=TableDataBGColor%>">
	    <TD COLSPAN="7" HEIGHT="1"><IMG HEIGHT="1" SRC="/images/clear.gif" ALT=""></TD>
    </TR>
	<TR BGCOLOR="8821">
	    <TD COLSPAN="7" HEIGHT="1"><IMG HEIGHT="1" SRC="/images/clear.gif" ALT=""></TD>
	</TR>
	
<%

'First Subscription Series        
Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD>&nbsp;&nbsp;</TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=" & SeriesLink(1) & "><B>" & SeriesName(1) & "</B></A></FONT></TD><TD>&nbsp;&nbsp;</TD><TD><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1>&nbsp;<br>&nbsp;</FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=Left><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=" & SeriesLink(1) & ">Tix & Info</A></FONT></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=7 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf

'Second Subscription Series            
Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD>&nbsp;&nbsp;</TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=" & SeriesLink(2)& "><B>" & SeriesName(2) & "</B></A></FONT></TD><TD>&nbsp;&nbsp;</TD><TD><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1>&nbsp;</FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=Left><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=" & SeriesLink(2) & ">Tix & Info</A></FONT></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=7 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf


EventsOnSale = "N"

SQLWhere = "WHERE Event.EventDate >= '" & FormatDateTime(Now(), vbShortDate) & "'"

'REE 8/26/3 - Added new Start and End Date Criteria.  This allows dates to be passed in URL.
If IsDate(Clean(Request("StartDate"))) Then
	SQLWhere = SQLWhere & " AND Event.EventDate >= '" & CDate(Clean(Request("StartDate"))) & "'"
End If

If IsDate(Clean(Request("EndDate"))) Then
	SQLWhere = SQLWhere & " AND Event.EventDate < '" & CDate(Clean(Request("EndDate"))) + 1 & "'"
End If


If Request("OrganizationNumber") <> "" Then SQLWhere = SQLWhere & " AND OrganizationAct.OrganizationNumber = '" & Clean(Request("OrganizationNumber")) & "' AND OrganizationVenue.OrganizationNumber = '" & Clean(Request("OrganizationNumber")) & "'"
If Request("ActCode") <> "" Then SQLWhere = SQLWhere & " AND Event.ActCode IN (" & Clean(Request("ActCode")) & ")"
If Request("VenueCode") <> "" Then SQLWhere = SQLWhere & " AND Venue.VenueCode IN( " & Clean(Request("VenueCode")) & ")"
If Request("EventCode") <> "" Then SQLWhere = SQLWhere & " AND Event.EventCode IN (" & Clean(Request("EventCode")) & ")"


'FIXED  SUBSCRIPTIONS
'===================================

Select Case Request("SortOrder")
Case "Act"
	SQLQuery = "SELECT DISTINCT EventDate, EventCode, Act, City, State, Venue From Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Category (NOLOCK) ON Act.CategoryCode = Category.CategoryCode INNER JOIN SubCategory (NOLOCK) ON Act.SubCategoryCode = SubCategory.SubCategoryCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode " & SQLWhere & "AND Event.OnSale = 1 AND Event.SaleStartDate <= '" & Now() &  "' AND Event.EventType = 'SubFixedEvent' ORDER BY Act.Act, Event.EventDate"
Case Else
	SQLQuery = "SELECT DISTINCT EventDate, EventCode, Act, City, State, Venue From Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Category (NOLOCK) ON Act.CategoryCode = Category.CategoryCode INNER JOIN SubCategory (NOLOCK) ON Act.SubCategoryCode = SubCategory.SubCategoryCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode " & SQLWhere & "AND Event.OnSale = 1 AND Event.SaleStartDate <= '" & Now() &  "' AND Event.EventType = 'SubFixedEvent' ORDER BY Event.EventDate, Act.Act"
End Select
Set rsEvents = OBJdbConnection.Execute(SQLQuery)

If Not rsEvents.EOF Then

	EventsOnSale = "Y"	
	
	    'Response.Write "<TABLE CELLSPACING=""0"" CELLPADDING=""0"" WIDTH=""90%"" BORDER=""0"">" & vbCrLf
	    'Response.Write "<TR><TD COLSPAN=7 HEIGHT=2 ALIGN=""CENTER""><FONT FACE=" & FontFace & " COLOR=""#fe0002"" ><H3>" & SubscriptionTitle & "</H3></FONT></TD></TR>" & vbCrLf
		'Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=7 HEIGHT=2><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
		'Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD>&nbsp;&nbsp;</TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>subscription name</B></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>venue/location</B></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>tickets</B></FONT></TD></TR>" & vbCrLf
		'Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=7 HEIGHT=2><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
		'Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
		'Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=7 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
	
	Do While Not rsEvents.EOF
	
	  strDate = FormatDateTime(rsEvents("EventDate"),vbShortDate)
	  'REE 11/27/8 - Modified to use WeekdayName function
	  strWeekDay = WeekdayName(Weekday(rsEvents("EventDate")), True) & "."
	  strTime = Left(FormatDateTime(rsEvents("EventDate"),vbLongTime),Len(FormatDateTime(rsEvents("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsEvents("EventDate"),vbLongTime),3)
	  
	  'REE 5/14/3 - Added ActSuffix
	  SQLActSuffix = "SELECT OptionValue AS ActSuffix FROM EventOptions (NOLOCK) WHERE EventCode = " & rsEvents("EventCode") & " AND OptionName = 'ActSuffix'"
	  Set rsActSuffix = OBJdbConnection.Execute(SQLActSuffix)
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
		Set rsDateSuppress = OBJdbConnection.Execute(SQLDateSuppress)
		If rsDateSuppress.EOF Then
			DisplayDate = DisplayDate & strWeekDay & "&nbsp;" & strDate
		End If
		rsDateSuppress.Close
		Set rsDateSuppress = nothing

		SQLTimeSuppress = "SELECT OptionValue AS TimeSuppress FROM EventOptions (NOLOCK) WHERE EventCode = " & rsEvents("EventCode") & " AND OptionName = 'TimeSuppress' AND OptionValue = 'Y'"
		Set rsTimeSuppress = OBJdbConnection.Execute(SQLTimeSuppress)
		If rsTimeSuppress.EOF Then
			DisplayDate = DisplayDate & "<BR>at " & strTime
		End If
		rsTimeSuppress.Close
		Set rsTimeSuppress = nothing	

		Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD>&nbsp;&nbsp;</TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=/Event.asp?Event=" & rsEvents("EventCode") & " id=""SubLink_" & rsEvents("EventCode") & """ onmouseover=""ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode=" & rsEvents("EventCode") & "\', this)', 200);"" onmouseout=""clearTimeout(ttDelay);hideTooltip();""><B>" & rsEvents("Act") & ActSuffix & "</B></A></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=/Event.asp?Event=" & rsEvents("EventCode") & " id=""SubTILink_" & rsEvents("EventCode") & """ onmouseover=""ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode=" & rsEvents("EventCode") & "\', this)', 200);"" onmouseout=""clearTimeout(ttDelay);hideTooltip();"">Tix & Info</A>&nbsp;</FONT></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=7 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
	
	  events="Y"
	  rsEvents.MoveNext
	Loop 
	
	Response.Write "</TABLE><BR><BR>" & vbCrLf

End If


'INDIVIDUAL EVENTS
'===================================

Select Case Request("SortOrder")
Case "Act"
	SQLQuery = "SELECT DISTINCT EventDate, EventCode, Act, City, State, Venue From Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Category (NOLOCK) ON Act.CategoryCode = Category.CategoryCode INNER JOIN SubCategory (NOLOCK) ON Act.SubCategoryCode = SubCategory.SubCategoryCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode " & SQLWhere & "AND Event.OnSale = 1 AND Event.SaleStartDate <= '" & Now() &  "' AND (Event.EventType <> 'SubFixedEvent' OR Event.EventType IS NULL) ORDER BY Act.Act, Event.EventDate"
Case Else
	SQLQuery = "SELECT DISTINCT EventDate, EventCode, Act, City, State, Venue From Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Category (NOLOCK) ON Act.CategoryCode = Category.CategoryCode INNER JOIN SubCategory (NOLOCK) ON Act.SubCategoryCode = SubCategory.SubCategoryCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode " & SQLWhere & "AND Event.OnSale = 1 AND Event.SaleStartDate <= '" & Now() &  "' AND (Event.EventType <> 'SubFixedEvent' OR Event.EventType IS NULL) ORDER BY Event.EventDate, Act.Act"
End Select
Set rsEvents = OBJdbConnection.Execute(SQLQuery)

If Not rsEvents.EOF Then
		
		%>
        <TABLE CELLSPACING="0" CELLPADDING="0" WIDTH="90%" BORDER="0">
        <tr><td colspan="7" align="center"><FONT FACE="<%=FontFace%>" COLOR="<%=HeadingFontColor%>"><h3><%=SingleEventTitle%></h3></td></tr>
		<%
		Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=8 HEIGHT=2><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>date/time</B></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>event name</B></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>venue/location</B></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>tickets</B></FONT></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=8 HEIGHT=2><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=8 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=8 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf

	Do While Not rsEvents.EOF
	  strDate = FormatDateTime(rsEvents("EventDate"),vbShortDate)
	  'REE 11/27/8 - Modified to use WeekdayName function
	  strWeekDay = WeekdayName(Weekday(rsEvents("EventDate")), True) & "."
	  strTime = Left(FormatDateTime(rsEvents("EventDate"),vbLongTime),Len(FormatDateTime(rsEvents("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsEvents("EventDate"),vbLongTime),3)
	  
	  'REE 5/14/3 - Added ActSuffix
	  SQLActSuffix = "SELECT OptionValue AS ActSuffix FROM EventOptions (NOLOCK) WHERE EventCode = " & rsEvents("EventCode") & " AND OptionName = 'ActSuffix'"
	  Set rsActSuffix = OBJdbConnection.Execute(SQLActSuffix)
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
		Set rsDateSuppress = OBJdbConnection.Execute(SQLDateSuppress)
		If rsDateSuppress.EOF Then
			DisplayDate = DisplayDate & strWeekDay & "&nbsp;" & strDate
		End If
		rsDateSuppress.Close
		Set rsDateSuppress = nothing

		SQLTimeSuppress = "SELECT OptionValue AS TimeSuppress FROM EventOptions (NOLOCK) WHERE EventCode = " & rsEvents("EventCode") & " AND OptionName = 'TimeSuppress' AND OptionValue = 'Y'"
		Set rsTimeSuppress = OBJdbConnection.Execute(SQLTimeSuppress)
		If rsTimeSuppress.EOF Then
			DisplayDate = DisplayDate & "<BR>at " & strTime
		End If
		rsTimeSuppress.Close
		Set rsTimeSuppress = nothing

	  If IncludeVenueLocation Then
		Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=8 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD>&nbsp;&nbsp;</TD><TD ALIGN=left NOWRAP><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1>" & DisplayDate & "</FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=/Event.asp?Event=" & rsEvents("EventCode") & " id=""EventLink_" & rsEvents("EventCode") & """ onmouseover=""ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode=" & rsEvents("EventCode") & "\', this)', 200);"" onmouseout=""clearTimeout(ttDelay);hideTooltip();""><B>" & rsEvents("Act") & ActSuffix & "</B></A></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1>" & rsEvents("Venue") & "<BR>" & rsEvents("City") & ", " & rsEvents("State") & "</FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=/Event.asp?Event=" & rsEvents("EventCode") & " id=""TixInfoLink_" & rsEvents("EventCode") & """ onmouseover=""ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode=" & rsEvents("EventCode") & "\', this)', 200);"" onmouseout=""clearTimeout(ttDelay);hideTooltip();"">Tix & Info</A>&nbsp;</FONT></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=8 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=8 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
	  Else
		Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=6 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD>&nbsp;&nbsp;</TD><TD ALIGN=left NOWRAP><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1>" & DisplayDate & "</FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=/Event.asp?Event=" & rsEvents("EventCode") & " id=""EventLink_" & rsEvents("EventCode") & """ onmouseover=""ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode=" & rsEvents("EventCode") & "\', this)', 200);"" onmouseout=""clearTimeout(ttDelay);hideTooltip();""><B>" & rsEvents("Act") & ActSuffix & "</B></A></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=/Event.asp?Event=" & rsEvents("EventCode") & " id=""TixInfoLink_" & rsEvents("EventCode") & """ onmouseover=""ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode=" & rsEvents("EventCode") & "\', this)', 200);"" onmouseout=""clearTimeout(ttDelay);hideTooltip();"">Tix & Info</A>&nbsp;</FONT></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=6 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=6 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
	  End If	
	  events="Y"
	  rsEvents.MoveNext
	Loop 

	Response.Write "</TABLE>" & vbCrLf

Else

	If EventsOnSale = "N" Then 'There weren't any subscriptions on sale either.  Display no events message.

		'REE 7/4/3 - Added VenueOption for No Events On Sale Message
		SQLNoEventsMessage = "SELECT OptionValue AS NoEventsMessage FROM VenueOptions (NOLOCK) WHERE VenueCode = " & iVenueCode & " AND OptionName = 'NoEventsMessage'"
		Set rsNoEventsMessage = OBJdbConnection.Execute(SQLNoEventsMessage)
		  
		If Not rsNoEventsMessage.EOF Then 'Use the Message in Venue Options
			NoEventsMessage = rsNoEventsMessage("NoEventsMessage")
		Else
			NoEventsMessage = "There are no events on sale at this time.  Please check back again."
		End If
	
		rsNoEventsMessage.Close
		Set rsNoEventsMessage = nothing
		  
		Response.Write "<FONT FACE=" & FontFace & " COLOR=" & FontColor & " SIZE=2><BR>" & NoEventsMessage & "</FONT>"
		
	End If

End If
rsEvents.Close
Set rsEvents = Nothing
Response.Write "<BR><BR>" & vbCrLf

%>

</CENTER>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>
</html>
<%
OBJdbConnection.Close
Set OBJdbConnection = nothing
%>

