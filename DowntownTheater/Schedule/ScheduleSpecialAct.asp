<!--#INCLUDE virtual="PrivateLabelInclude.asp" -->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->

<%

TooltipIncludeFlag = "Y"
Page = "Schedule"

'===============================================
'Special Events Listing

SpecialEventCount = 1

Dim SpecialEventsTitle(1)
Dim SpecialEventSubTitle(1)
Dim SpecialActList(1)

ScheduleTitle = "Buy Tickets"

SpecialEventsTitle(1) = "Annie Get Your Gun"
SpecialEventSubTitle(1) = ""
SpecialActList(1)= "54885"  

NoEventsMessage = "There are no events on sale at this time.  Please check back again."

SpecialEventsOnSale = 0

'===============================================


%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<TITLE><%= Title %></TITLE>
</HEAD>
<%= strBody %>

<!--#INCLUDE virtual="TopNavInclude.asp" -->
<BR />
<FONT FACE="<%= FontFace%>" COLOR="<%=HeadingFontColor%>" SIZE="5"><B><%=ScheduleTitle%></B></FONT>
<BR /><Br />
<%


'===================================
'SPECIAL EVENTS


For i = 1 To SpecialEventCount

        SQLWhere = "WHERE Event.EventDate >= '" & FormatDateTime(Now(), vbShortDate) & "'"

        If IsDate(Clean(Request("StartDate"))) Then
	        SQLWhere = SQLWhere & " AND Event.EventDate >= '" & CDate(Clean(Request("StartDate"))) & "'"
        End If
        If IsDate(Clean(Request("EndDate"))) Then
	        SQLWhere = SQLWhere & " AND Event.EventDate < '" & CDate(Clean(Request("EndDate"))) + 1 & "'"
        End If

        If Request("OrganizationNumber") <> "" Then SQLWhere = SQLWhere & " AND OrganizationAct.OrganizationNumber = '" & Clean(Request("OrganizationNumber")) & "' AND OrganizationVenue.OrganizationNumber = '" & Clean(Request("OrganizationNumber")) & "'"

        SQLQuery = "SELECT DISTINCT EventDate, EventCode, Act, City, State, Venue From Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Category (NOLOCK) ON Act.CategoryCode = Category.CategoryCode INNER JOIN SubCategory (NOLOCK) ON Act.SubCategoryCode = SubCategory.SubCategoryCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode " & SQLWhere & " AND Event.OnSale = 1 AND Event.SaleStartDate <= '" & Now() &  "' AND (Event.EventType <> 'SubFixedEvent' OR Event.EventType IS NULL) AND Event.ActCode IN (" & SpecialActList(i) & ") ORDER BY Event.EventDate, Act.Act"

        Set rsEvents = OBJdbConnection.Execute(SQLQuery)

        If Not rsEvents.EOF Then

        SpecialEventsOnSale = SpecialEventsOnSale + 1

        %>
        <FONT FACE="<%= FontFace%>" COLOR="<%=HeadingFontColor%>"><B><%=SpecialEventsTitle(i)%></B></FONT><Br />
        <FONT FACE="<%= FontFace%>" COLOR="<%=HeadingFontColor%>"><%=SpecialEventSubTitle(i)%></FONT><BR>
        <%

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

	        Response.Write "</TABLE><br>" & vbCrLf

        End If
        rsEvents.Close
        Set rsEvents = Nothing
        
 Next
        

	  

		




%>

</CENTER>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>
</html>
<%
OBJdbConnection.Close
Set OBJdbConnection = nothing
%>

