<!--#INCLUDE virtual="PrivateLabelInclude.asp" -->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->


<%
'set the flag to include the TooltipInclude.html file
TooltipIncludeFlag = "Y"
Page = "Schedule"

'Set subscription events to exclude from main list
SubscriptionEvents = "171935,171936,171937,171938,171939,171940,171941,171942"
%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<TITLE><%= Title %></TITLE>
<%= strBody %>


<!--#INCLUDE virtual="TopNavInclude.asp" -->

<BR>

<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>"><H3>Event Listing</H3></FONT>


<%

SQLWhere = " WHERE Event.EventDate >= '" & FormatDateTime(Now(), vbShortDate) & "'"

'REE 8/26/3 - Added new Start and End Date Criteria.  This allows dates to be passed in URL.
If IsDate(Clean(Request("StartDate"))) Then
	SQLWhere = SQLWhere & " AND Event.EventDate >= '" & CDate(Clean(Request("StartDate"))) & "'"
End If
If IsDate(Clean(Request("EndDate"))) Then
	SQLWhere = SQLWhere & " AND Event.EventDate < '" & CDate(Clean(Request("EndDate"))) + 1 & "'"
End If

If Request("OrganizationNumber") <> "" Then SQLWhere = SQLWhere & " AND OrganizationAct.OrganizationNumber IN (" & Clean(Request("OrganizationNumber")) & ") AND OrganizationVenue.OrganizationNumber IN (" & Clean(Request("OrganizationNumber")) & ")"
If Request("ActCode") <> "" Then SQLWhere = SQLWhere & " AND Event.ActCode = " & Clean(Request("ActCode"))
If Request("VenueCode") <> "" Then SQLWhere = SQLWhere & " AND Venue.VenueCode = " & Clean(Request("VenueCode"))
If Request("EventCode") <> "" Then SQLWhere = SQLWhere & " AND Event.EventCode = " & Clean(Request("EventCode"))

Call DBOpen(OBJdbConnection2)
Call DBOpen(OBJdbConnection3)

'REE 10/22/3 - Added ActCode to Sort.  Same Act Names with different ActCodes (different venues) were displaying multiple times each when having overlapping dates.	
SQLQuery = "SELECT Act.ActCode, Act.Act, Event.EventCode FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode " & SQLWhere & " AND Event.EventCode NOT IN (" &  SubscriptionEvents & ") AND Event.OnSale = 1 AND Event.SaleStartDate <= '" & Now() &  "' ORDER BY YEAR(Event.EventDate), MONTH(Event.EventDate), Act.ActCode"
Set rsEvents = OBJdbConnection.Execute(SQLQuery)

If Not rsEvents.EOF Then
	Response.Write "<TABLE CELLSPACING=0 CELLPADDING=0 WIDTH=""95%"" BORDER=0>" & vbCrLf
	Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=7 HEIGHT=2><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
	Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>Event</B></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>Date(s)</B></FONT></TD><TD>&nbsp;&nbsp;</TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>Tickets</B></FONT></TD></TR>" & vbCrLf
	Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=7 HEIGHT=2><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
	Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
	Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=7 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf

	Do While Not rsEvents.EOF
		
		'If it's a new event, display it.
		If LastActCode <> rsEvents("ActCode") Then
		
			'Get the Start and End Dates
			SQLDates = "SELECT COUNT(EventCode) AS EventCount, MIN(EventDate) AS StartDate, MAX(EventDate) AS EndDate FROM Event (NOLOCK) WHERE ActCode = " & rsEvents("ActCode") & "AND Event.EventDate >= '" & FormatDateTime(Now(), vbShortDate) & "' AND Event.OnSale = 1 AND Event.SaleStartDate <= '" & Now() &  "'"
			Set rsDates = OBJdbConnection2.Execute(SQLDates)
			
			'Add code to go to Event.asp if there is a single event for this act.
			If rsDates("EventCount") > 1 Then
				Link = "/Schedule.asp?ActCode=" & rsEvents("ActCode")
			Else
				Link = "/Event.asp?Event=" & rsEvents("EventCode")
			End If
			
			Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
			If rsDates("StartDate") <> rsDates("EndDate") Then 'Display date range
				Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD>&nbsp;&nbsp;</TD><TD><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=" & Link & " id=""ProductionInfoLink_" & rsEvents("ActCode") & """ onmouseover=""ttDelay=setTimeout('eventTooltip(\'/AJAX/ProductionInfo.asp?ActCode=" & rsEvents("ActCode") & "\', this)', 200);"" onmouseout=""clearTimeout(ttDelay);hideTooltip();"">" & rsEvents("Act") & "</A></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left NOWRAP><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1>" & MonthName(Month(rsDates("StartDate")), true) & " " & Day(rsDates("StartDate")) & " ~ " & MonthName(Month(rsDates("EndDate")), true) & " " & Day(rsDates("EndDate")) & "</FONT></TD><TD>&nbsp;&nbsp;</TD><TD>&nbsp;&nbsp;</TD><TD><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=" & Link & " id=""TixInfoLink_" & rsEvents("ActCode") & """ onmouseover=""ttDelay=setTimeout('eventTooltip(\'/AJAX/ProductionInfo.asp?ActCode=" & rsEvents("ActCode") & "\', this)', 200);"" onmouseout=""clearTimeout(ttDelay);hideTooltip();"">Tix & Info</A></FONT></TD></TR>" & vbCrLf
			Else 'Display Date
				DisplayDate = ""

				'REE 12/10/3 - Modified to look at EventOptions for Date & Time Display Options
				SQLDateSuppress = "SELECT OptionValue AS DateSuppress FROM EventOptions (NOLOCK) WHERE EventCode = " & rsEvents("EventCode") & " AND OptionName = 'DateSuppress' AND OptionValue = 'Y'"
				Set rsDateSuppress = OBJdbConnection3.Execute(SQLDateSuppress)
				If rsDateSuppress.EOF Then
					DisplayDate = MonthName(Month(CDate(rsDates("StartDate")))) & " " & Day(rsDates("StartDate")) & ", " & Year(rsDates("StartDate"))
				End If
				rsDateSuppress.Close
				Set rsDateSuppress = nothing

				Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD>&nbsp;&nbsp;</TD><TD><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=" & Link & " id=""ProductionInfoLink_" & rsEvents("ActCode") & """ onmouseover=""ttDelay=setTimeout('eventTooltip(\'/AJAX/ProductionInfo.asp?ActCode=" & rsEvents("ActCode") & "\', this)', 200);"" onmouseout=""clearTimeout(ttDelay);hideTooltip();"">" & rsEvents("Act") & "</A></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left NOWRAP><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1>" & DisplayDate & "</FONT></TD><TD>&nbsp;&nbsp;</TD><TD>&nbsp;&nbsp;</TD><TD><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=" & Link & " id=""TixInfoLink_" & rsEvents("ActCode") & """ onmouseover=""ttDelay=setTimeout('eventTooltip(\'/AJAX/ProductionInfo.asp?ActCode=" & rsEvents("ActCode") & "\', this)', 200);"" onmouseout=""clearTimeout(ttDelay);hideTooltip();"">Tix & Info</A></FONT></TD></TR>" & vbCrLf
			End If
			
			Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
			Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=7 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
			LastActCode = rsEvents("ActCode")
			events="Y"
			EventCount = 0

			rsDates.Close
			Set rsDates = nothing

		End If
		rsEvents.MoveNext
	Loop 
	
	Response.Write "</TABLE>"

'Season Subscriptions
   
Response.Write "<TABLE CELLSPACING=0 CELLPADDING=0 WIDTH=""95%"" BORDER=0>" & vbCrLf  
  
Response.Write "<TR ><TD ALIGN=CENTER COLSPAN=7></TD></TR>"
Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=7 HEIGHT=2><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf    	
Response.Write "<TR ><TD ALIGN=CENTER COLSPAN=7><BR><H3>Season Subscriptions</H3></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>Event</B></FONT></TD><TD>&nbsp;&nbsp;</TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=CENTER><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>Tickets</B></FONT></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=7 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf

Link = "/Event.asp?Event=171935"

             
Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD>&nbsp;&nbsp;</TD><TD><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=" & Link & ">2009 Playhouse Series Season Ticket - First Friday</A></FONT></TD><TD>&nbsp;&nbsp;</TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=CENTER><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=" & Link & ">Tix & Info</A></FONT></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=7 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf

Link = "/Event.asp?Event=171936"

             
Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD>&nbsp;&nbsp;</TD><TD><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=" & Link & ">2009 Playhouse Series Season Ticket - First Saturday</A></FONT></TD><TD>&nbsp;&nbsp;</TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=CENTER><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=" & Link & ">Tix & Info</A></FONT></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=7 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf

Link = "/Event.asp?Event=171937"

             
Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD>&nbsp;&nbsp;</TD><TD><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=" & Link & ">2009 Playhouse Series Season Ticket - First Sunday</A></FONT></TD><TD>&nbsp;&nbsp;</TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=CENTER><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=" & Link & ">Tix & Info</A></FONT></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=7 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf

Link = "/Event.asp?Event=171938"

             
Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD>&nbsp;&nbsp;</TD><TD><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=" & Link & ">2009 Playhouse Series Season Ticket - Second Friday</A></FONT></TD><TD>&nbsp;&nbsp;</TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=CENTER><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=" & Link & ">Tix & Info</A></FONT></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=7 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf

Link = "/Event.asp?Event=171939"

             
Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD>&nbsp;&nbsp;</TD><TD><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=" & Link & ">2009 Playhouse Series Season Ticket - Second Saturday</A></FONT></TD><TD>&nbsp;&nbsp;</TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=CENTER><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=" & Link & ">Tix & Info</A></FONT></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=7 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf

Link = "/Event.asp?Event=171940"

             
Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD>&nbsp;&nbsp;</TD><TD><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=" & Link & ">2009 Playhouse Series Season Ticket - Second Sunday</A></FONT></TD><TD>&nbsp;&nbsp;</TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=CENTER><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=" & Link & ">Tix & Info</A></FONT></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=7 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf

Link = "/Event.asp?Event=171941"

             
Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD>&nbsp;&nbsp;</TD><TD><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=" & Link & ">2009 Playhouse Series Season Ticket - Third Friday</A></FONT></TD><TD>&nbsp;&nbsp;</TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=CENTER><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=" & Link & ">Tix & Info</A></FONT></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=7 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf

Link = "/Event.asp?Event=171942"

             
Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD>&nbsp;&nbsp;</TD><TD><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=" & Link & ">2009 Playhouse Series Season Ticket - Third Saturday</A></FONT></TD><TD>&nbsp;&nbsp;</TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=CENTER><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=" & Link & ">Tix & Info</A></FONT></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=7 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf

Response.Write "</TABLE>"
	
	

Else

  Response.Write "<FONT FACE=" & FontFace & " COLOR=" & FontColor & " SIZE=2><BR>There are no events on sale at this time.  Please check back again.</FONT>"

End If

rsEvents.Close
Set rsEvents = nothing

Call DBClose(OBJdbConnection3)
Call DBClose(OBJdbConnection2)

OBJdbConnection.Close
Set OBJdbConnection = nothing

Response.Write "<BR><BR>" & vbCrLf

%>

</CENTER>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>
</html>
