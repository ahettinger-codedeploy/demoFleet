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

<BR>
<div align=center>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE=3>Schedule of Events</FONT>
</div>

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
'EM 06/04/07 modified to get the month name and month number
'GM 08/28/07 Modified to get Year - and Order by Year, Month, act
SQLQuery = "SELECT DATENAME(yyyy,EventDate) AS YearName, DATENAME ( mm,EventDate ) AS MonthName, MONTH(Event.EventDate) as MonthNumber, Act.ActCode, Act.Act,  Event.EventCode FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode " & SQLWhere & " AND Event.OnSale = 1 AND Event.EventCode <> 176976 AND Event.EventCode <> 176977 AND Event.EventCode <> 176980 AND Event.SaleStartDate <= '" & Now() &  "' ORDER BY YEAR(Event.EventDate), MONTH(Event.EventDate),Act.Act"
Set rsEvents = OBJdbConnection.Execute(SQLQuery)


Response.Write "<TABLE CELLSPACING=0 CELLPADDING=0 WIDTH=""95%"" BORDER=0>" & vbCrLf

'Top of List Events   
    
Response.Write "<TR ><TD ALIGN=CENTER COLSPAN=7></TD></TR>"
Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=7 HEIGHT=2><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf    	
Response.Write "<TR ><TD ALIGN=CENTER COLSPAN=7><BR><FONT FACE=" & FontFace & " COLOR=#000000 SIZE=3>Season Tickets</FONT><BR></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>Event</B></FONT></TD><TD>&nbsp;&nbsp;</TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=CENTER><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>Tickets</B></FONT></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=7 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf

'2009 Theme Buffet & Theatre Season Ticket 
  
Link = "/Event.asp?Event=176977"

             
Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD>&nbsp;&nbsp;</TD><TD><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=" & Link & ">2009 Theme Buffet &amp; Theatre Season Ticket </A></FONT></TD><TD>&nbsp;&nbsp;</TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=CENTER><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=" & Link & ">View<BR>Schedule</A></FONT></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=7 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
 	

'2009 Season Tickets  
  
Link = "/Event.asp?Event=176976"

             
Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD>&nbsp;&nbsp;</TD><TD><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=" & Link & ">2009 Season Tickets</A></FONT></TD><TD>&nbsp;&nbsp;</TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=CENTER><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=" & Link & ">View<BR>Schedule</A></FONT></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=7 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
 	

'2009 Threshers Dinner &amp; Theatre Season Ticket  
  
Link = "/Event.asp?Event=176980"

             
Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD>&nbsp;&nbsp;</TD><TD><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=" & Link & ">2009 Threshers Dinner & Theatre Season Ticket</A></FONT></TD><TD>&nbsp;&nbsp;</TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=CENTER><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=" & Link & ">View<BR>Schedule</A></FONT></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=7 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
			                      

IF not rsEvents.EOF Then
    Do While Not rsEvents.EOF    
    
            		
	    'If it's a new event, display it.
		
		    'EM 06/05/07 If it's a new month, display it
		IF LastMonth <> rsEvents("MonthNumber") Then
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
			Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD>&nbsp;&nbsp;</TD><TD><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=" & Link & ">" & rsEvents("Act") & "</A></FONT></TD><TD>&nbsp;&nbsp;</TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=CENTER><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=" & Link & ">View<BR>Schedule</A></FONT></TD></TR>" & vbCrLf
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

OBJdbConnection.Close
Set OBJdbConnection = nothing

Response.Write "<BR><BR>" & vbCrLf

%>

</CENTER>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>
</html>
