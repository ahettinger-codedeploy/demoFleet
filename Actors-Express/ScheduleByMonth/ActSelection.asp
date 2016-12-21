<!--#INCLUDE virtual="PrivateLabelInclude.asp" -->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<%
Page = "Schedule"
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

'REE 10/22/3 - Added ActCode to Sort.  Same Act Names with different ActCodes (different venues) were displaying multiple times each when having overlapping dates.	
SQLQuery = "SELECT Act.ActCode, Act.Act, Event.EventDate, Event.EventCode FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode " & SQLWhere & " AND Event.OnSale = 1 AND Event.SaleStartDate <= '" & Now() &  "' ORDER BY Act.Act, Act.ActCode, Event.EventDate"
Set rsEvents = OBJdbConnection.Execute(SQLQuery)

If Not rsEvents.EOF Then
	Response.Write "<TABLE CELLSPACING=0 CELLPADDING=0 WIDTH=""95%"" BORDER=0>" & vbCrLf
	Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=7 HEIGHT=2><IMG HEIGHT=1 SRC=""/PrivateLabel/Skirball/images/clear.gif""></TD></TR>" & vbCrLf
	Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>Event</B></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>Month</B></FONT></TD><TD>&nbsp;&nbsp;</TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>Tickets</B></FONT></TD></TR>" & vbCrLf
	Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=7 HEIGHT=2><IMG HEIGHT=1 SRC=""/PrivateLabel/Skirball/images/clear.gif""></TD></TR>" & vbCrLf
	Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=1><IMG HEIGHT=1 SRC=""/PrivateLabel/Skirball/images/clear.gif""></TD></TR>" & vbCrLf
	Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=7 HEIGHT=1><IMG HEIGHT=1 SRC=""/PrivateLabel/Skirball/images/clear.gif""></TD></TR>" & vbCrLf

	Do While Not rsEvents.EOF
		
		'If it's a new event, display it.
		If LastActCode <> rsEvents("ActCode") Then
		
			'Get the Start and End Dates
			'EM 06/04/07 modified to get the month name, and month number is used to sort it
			SQLDates = "SELECT COUNT(EventCode) AS EventCount, DATENAME ( mm,EventDate ) AS MonthName, MONTH(EventDate) FROM Event (NOLOCK) WHERE ActCode = " & rsEvents("ActCode") & "AND Event.EventDate >= '" & FormatDateTime(Now(), vbShortDate) & "' AND Event.OnSale = 1 AND Event.SaleStartDate <= '" & Now() &  "' GROUP BY MONTH(EventDate), DATENAME ( mm ,EventDate ) ORDER BY MONTH(EventDate), DATENAME ( mm ,EventDate ) ASC "
			Set rsDates = OBJdbConnection.Execute(SQLDates)
			Do While Not rsDates.EOF
			    'Add code to go to Event.asp if there is a single event for this act...someday.
			    If rsDates("EventCount") > 1 Then
				    Link = "Schedule.asp?ActCode=" & rsEvents("ActCode")&"&MonthName="& (rsDates("MonthName"))
			    Else
				    Link = "http://www.tix.com/Event.asp?Event=" & rsEvents("EventCode")
			    End If
    			
			    Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=6><IMG HEIGHT=1 SRC=""/PrivateLabel/Skirball/images/clear.gif""></TD></TR>" & vbCrLf
				Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD>&nbsp;&nbsp;</TD><TD><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=" & Link & ">" & rsEvents("Act") & "</A></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left NOWRAP><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1>" &  (rsDates("MonthName"))  & "</FONT></TD><TD>&nbsp;&nbsp;</TD><TD>&nbsp;&nbsp;</TD><TD><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=" & Link & ">Tix & Info</A></FONT></TD></TR>" & vbCrLf
    			Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=6><IMG HEIGHT=1 SRC=""/PrivateLabel/Skirball/images/clear.gif""></TD></TR>" & vbCrLf
			    Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=7 HEIGHT=1><IMG HEIGHT=1 SRC=""/PrivateLabel/Skirball/images/clear.gif""></TD></TR>" & vbCrLf
			    rsDates.MoveNext
	        Loop 
			
			LastActCode = rsEvents("ActCode")
			events="Y"
			EventCount = 0
            
			rsDates.Close
			Set rsDates = nothing

		End If
		rsEvents.MoveNext
	Loop 

	Response.Write "</TABLE>"

Else

  Response.Write "<FONT FACE=" & FontFace & " COLOR=" & FontColor & " SIZE=2><BR>There are no events on sale at this time.  Please check back again.</FONT>"

End If

rsEvents.Close
Set rsEvents = nothing

OBJdbConnection.Close
Set OBJdbConnection = nothing

Response.Write "<BR><BR>" & vbCrLf

%>

</CENTER>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>
</html>
