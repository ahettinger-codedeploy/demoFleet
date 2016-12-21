<!--#INCLUDE virtual="PrivateLabelInclude.asp" -->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->



<%
Page = "ActbyMonthSelection"
%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<TITLE><%= Title %></TITLE>
<%= strBody %>


<!--#INCLUDE virtual="TopNavInclude.asp" -->

<%

Call DBOpen(OBJdbConnection2)
Call DBOpen(OBJdbConnection3)


'LIST SPECIAL EVENTS
'====================

'Events which are listed at the top of the schedule page
SpecialActs = "35046,35047,35048,48419,48420,53664,53744,53743,55275,76850,82205,48420,91810"

SQLWhere = "WHERE Event.EventDate >= '" & FormatDateTime(Now(), vbShortDate) & "'"

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

SQLQuery = "SELECT DATENAME(yyyy,EventDate) AS YearName, DATENAME ( mm,EventDate ) AS MonthName, MONTH(Event.EventDate) as MonthNumber, Act.ActCode, Act.Act,  Event.EventCode FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode " & SQLWhere & " AND Act.ActCode IN (" & SpecialActs & ") AND Event.OnSale = 1 AND Event.SaleStartDate <= '" & Now() &  "' ORDER BY YEAR(Event.EventDate), MONTH(Event.EventDate),Act.Act"

Set rsEvents = OBJdbConnection2.Execute(SQLQuery)

Response.Write "<div align=""center"">" & vbCrLf
Response.Write "<FONT FACE=" & FontFace & " COLOR=" & HeadingFontColor & " SIZE=3>Schedule of Events</FONT>" & vbCrLf
Response.Write "</div>" & vbCrLf

Response.Write "<TABLE CELLSPACING=0 CELLPADDING=0 WIDTH=""95%"" BORDER=0>" & vbCrLf   
Response.Write "<TR ><TD ALIGN=CENTER COLSPAN=7></TD></TR>"
Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=7 HEIGHT=2><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf    	
Response.Write "<TR ><TD ALIGN=CENTER COLSPAN=7><BR><FONT FACE=" & FontFace & " COLOR=#000000 SIZE=3>Special Packages</FONT><BR></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>Event</B></FONT></TD><TD>&nbsp;&nbsp;</TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=CENTER><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>Tickets</B></FONT></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=7 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf

IF not rsEvents.EOF Then

    Do While Not rsEvents.EOF   
            
        If  LastActCode <> rsEvents("ActCode") Then
		            
					Link = "SchedulebyMonth.asp?ActCode=" & rsEvents("ActCode")&"&MonthName="& rsEvents("MonthName")
					                
					Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
					Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=" & Link & ">" & rsEvents("Act") & "</A></FONT></TD><TD>&nbsp;&nbsp;</TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=CENTER><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=" & Link & ">View<BR>Schedule</A></FONT></TD></TR>" & vbCrLf
    			Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
					Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=7 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
					               
					LastActCode = rsEvents("ActCode")   
				
			  End If
			  
			rsEvents.MoveNext
		
	Loop 

Else

      Response.Write "<FONT FACE=" & FontFace & " COLOR=" & FontColor & " SIZE=2><BR>There are no special packages on sale at this time.  Please check back again.</FONT>"

End If

Response.Write "</TABLE>"
rsEvents.Close
Set rsEvents = nothing

OBJdbConnection2.Close
Set OBJdbConnection2 = nothing

Response.Write "<BR><BR>" & vbCrLf




'LIST REGULAR EVENTS
'===================

SQLWhere = "WHERE Event.EventDate >= '" & FormatDateTime(Now(), vbShortDate) & "'"

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

SQLQuery = "SELECT DATENAME(yyyy,EventDate) AS YearName, DATENAME ( mm,EventDate ) AS MonthName, MONTH(Event.EventDate) as MonthNumber, Act.ActCode, Act.Act,  Event.EventCode FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode " & SQLWhere & " AND Act.ActCode NOT IN (" & SpecialActs & ") AND Event.OnSale = 1 AND Event.SaleStartDate <= '" & Now() &  "' ORDER BY YEAR(Event.EventDate), MONTH(Event.EventDate),Act.Act"

Set rsEvents = OBJdbConnection3.Execute(SQLQuery)

Response.Write "<TABLE CELLSPACING=0 CELLPADDING=0 WIDTH=""95%"" BORDER=0>" & vbCrLf   
Response.Write "<TR ><TD ALIGN=CENTER COLSPAN=7></TD></TR>"
Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=7 HEIGHT=2><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf    	
Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=7 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf

IF not rsEvents.EOF Then

    Do While Not rsEvents.EOF   

		If LastMonth <> rsEvents("MonthNumber") Then
		    Response.Write "<TR ><TD ALIGN=CENTER COLSPAN=7><BR></TD></TR>"
	        Response.Write "<TR ><TD ALIGN=CENTER COLSPAN=7><BR><FONT FACE=" & FontFace & " COLOR=#000000 SIZE=3>" & rsEvents("MonthName") &" "& rsEvents("YearName")&  "<FONT FACE=" & FontFace & " COLOR=#000000 SIZE=3><BR></TD></TR>" & vbCrLf
	        Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>Event</B></FONT></TD><TD>&nbsp;&nbsp;</TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=CENTER><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>Tickets</B></FONT></TD></TR>" & vbCrLf
	        Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
	        Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=7 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
	            
	        LastMonth = rsEvents("MonthNumber")
	        LastActCode = 0
	        
    End IF
            
        If  LastActCode <> rsEvents("ActCode") Then
		            
					Link = "SchedulebyMonth.asp?ActCode=" & rsEvents("ActCode")&"&MonthName="& rsEvents("MonthName")
					                
					Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
					Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=" & Link & ">" & rsEvents("Act") & "</A></FONT></TD><TD>&nbsp;&nbsp;</TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=CENTER><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=" & Link & ">View<BR>Schedule</A></FONT></TD></TR>" & vbCrLf
    			Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
					Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=7 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
					               
					LastActCode = rsEvents("ActCode")   
				
			  End If
			  
			rsEvents.MoveNext
		
	Loop 

Else

      Response.Write "<FONT FACE=" & FontFace & " COLOR=" & FontColor & " SIZE=2><BR>There are no events on sale at this time.  Please check back again.</FONT>"

End If

Response.Write "</TABLE>"
rsEvents.Close
Set rsEvents = nothing

OBJdbConnection3.Close
Set OBJdbConnection3 = nothing

Response.Write "<BR><BR>" & vbCrLf

%>

</CENTER>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>
