<!--#INCLUDE virtual="PrivateLabelInclude.asp" -->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->

<%

TooltipIncludeFlag = "Y"
Page = "Schedule"

'===============================================
'Event List by Date with Special Events on Top


'set the flag to include the TooltipInclude.html file
TooltipIncludeFlag = "Y"
Page = "Schedule"


'Moved Session OrderTypeNumber to Top of Script
If Session("OrderTypeNumber") = "" Then
	Session("OrderTypeNumber") = 1
End If

'Added OrderTypeNumber variable to top of script.
OrderTypeNumber = 1


'=================================================

If Session("UserNumber")<> "" Then
TableCategoryBGColor = "#008400"
TableCategoryFontColor = "FFFFFF"
TableColumnHeadingBGColor = "99CC99"
TableColumnHeadingFontColor = "000000"
TableDataBGColor = "E9E9E9"
ClientFolder= "Tix"
Else
ClientFolder = "ChesterTheatre"
End If

'=================================================


%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->


<TITLE>Chester Theatre - Ticket Sales</TITLE>

<style type="text/css">
body
{
line-height: 1.6em;
}
#rounded-corner
{
	font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
	font-size: 12px;
	margin: 45px;
	width: 500px;
	text-align: center;
	border-collapse: collapse;
}
#rounded-corner thead th.rounded-left
{
	background: <%=TableCategoryBGColor%> url('/Clients/<%=ClientFolder%>/Images/corner_nw.gif') left -1px no-repeat;
	text-align: right;
}
#rounded-corner thead th.rounded-right
{
	background: <%=TableCategoryBGColor%> url('/Clients/<%=ClientFolder%>/Images/corner_ne.gif') right -1px no-repeat;
    text-align: left;
}
#rounded-corner th.category
{
	padding: 8px;
	font-weight: strong;
	font-size: 12px;
	color: <%=TableCategoryFontColor%>;
	background: <%=TableCategoryBgColor%>;
}
#rounded-corner td.data
{
	padding: 8px;
	font-weight: normal;
	font-size: 12px;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
	border-top: 1px solid;
	border-color: <%=TableCategoryBgColor%>;
}
#rounded-corner td.header
{
text-align: right;
}
#rounded-corner td.data a:link 
{
color: <%=TableCategoryBgColor%>;
font-weight: normal;
font-size: 12px;
} 
#rounded-corner td.data a:visited 
{
color: <%=TableCategoryBgColor%>;
font-weight: normal;
font-size: 12px;
} 
#rounded-corner td.data a:hover 
{
color: <%=TableColumnBgColor%>;
font-weight: normal;
font-size: 12px;
} 
#rounded-corner td.data a:active 
{
color: <%=TableCategoryBgColor%>;
font-weight: normal;
font-size: 12px;
} 
</style>

</head>

<%
If Message = "" Then
	Response.Write "<BODY BGCOLOR=#FFFFFF leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0>" & vbCrLf
Else
	Response.Write "<BODY BGCOLOR=#FFFFFF onLoad=" & CHR(34) & "alert('" & Message & "');" & CHR(34) & " leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0>" & vbCrLf
End If
%>

<CENTER>

<!--#INCLUDE VIRTUAL="TopNavInclude.asp"-->

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
	SQLQuery = "SELECT DISTINCT EventDate, EventCode, Act, City, State, Venue, Map From Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Category (NOLOCK) ON Act.CategoryCode = Category.CategoryCode INNER JOIN SubCategory (NOLOCK) ON Act.SubCategoryCode = SubCategory.SubCategoryCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode " & SQLWhere & "AND Event.OnSale = 1 AND Event.SaleStartDate <= '" & Now() &  "' ORDER BY Act.Act, Event.EventDate"
'REE 12/15/6 - Added Venue, Act sort	
Case "VenueAct"
	SQLQuery = "SELECT DISTINCT EventDate, EventCode, Act, City, State, Venue, Map From Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Category (NOLOCK) ON Act.CategoryCode = Category.CategoryCode INNER JOIN SubCategory (NOLOCK) ON Act.SubCategoryCode = SubCategory.SubCategoryCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode " & SQLWhere & "AND Event.OnSale = 1 AND Event.SaleStartDate <= '" & Now() &  "' ORDER BY Venue.Venue, Act.Act, Event.EventDate"
'REE 01/22/7 - Added Venue, EventDate, Act sort	
Case "VenueEventDate"
	SQLQuery = "SELECT DISTINCT EventDate, EventCode, Act, City, State, Venue, Map From Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Category (NOLOCK) ON Act.CategoryCode = Category.CategoryCode INNER JOIN SubCategory (NOLOCK) ON Act.SubCategoryCode = SubCategory.SubCategoryCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode " & SQLWhere & "AND Event.OnSale = 1 AND Event.SaleStartDate <= '" & Now() &  "' ORDER BY Venue.Venue, Event.EventDate, Act.Act"
Case Else
	SQLQuery = "SELECT DISTINCT EventDate, EventCode, Act, City, State, Venue, Map From Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Category (NOLOCK) ON Act.CategoryCode = Category.CategoryCode INNER JOIN SubCategory (NOLOCK) ON Act.SubCategoryCode = SubCategory.SubCategoryCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode " & SQLWhere & "AND Event.OnSale = 1 AND Event.SaleStartDate <= '" & Now() &  "' ORDER BY Event.EventDate, Act.Act"
End Select
Set rsEvents = OBJdbConnection.Execute(SQLQuery)

'JAI 4/12/5 - Open OBJdbConnection2 for Loop reads.
Call DBOpen(OBJdbConnection2)
	  
If Not rsEvents.EOF Then

    %>
    <table id="rounded-corner" summary="schedulepage">
    <thead>
	    <tr>
    	    <th scope="col" class="rounded-left category">Date/Time</th>
            <th scope="col" class="category">Event</th>
            <th scope="col" class="category">Venue/Location</th>
            <th scope="col" class="rounded-right category">Tickets</th>
        </tr>
    </thead>   	
   	
    <%


	Call DBOpen(OBJdbConnection2)

	Do Until rsEvents.EOF

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
	  
	  
    'Check for Available Seats
    SQLSeatCheck = "SELECT Count(ItemNumber) as LineCount FROM Seat (NOLOCK) WHERE EventCode = " & rsEvents("EventCode") & " AND StatusCode = 'A'"
    Set rsSeatCheck = OBJdbConnection.Execute(SQLSeatCheck)

    If rsSeatCheck("LineCount") > 0 Then			
        AvailableSeats =  rsSeatCheck("LineCount")
        SeatStatusClass = "Available"
    Else
        AvailableSeats =  "Sold Out"
        SeatStatusClass = "Unavailable"
    End If
    		  
    rsSeatCheck.Close
    Set rsSeatCheck = nothing 	  
	  
        'ActSuffix
        SQLActSuffix = "SELECT OptionValue AS ActSuffix FROM EventOptions (NOLOCK) WHERE EventCode = " & rsEvents("EventCode") & " AND OptionName = 'ActSuffix'"
        Set rsActSuffix = OBJdbConnection2.Execute(SQLActSuffix)
        If Not rsActSuffix.EOF Then 'Use it
        ActSuffix = " - " & rsActSuffix("ActSuffix")
        Else
        ActSuffix = ""
        End If
        rsActSuffix.Close
        Set rsActSuffix = nothing

        'Date 
        
        DisplayDate = ""
        
        SQLDateSuppress = "SELECT OptionValue AS DateSuppress FROM EventOptions (NOLOCK) WHERE EventCode = " & rsEvents("EventCode") & " AND OptionName = 'DateSuppress' AND OptionValue = 'Y'"
        Set rsDateSuppress = OBJdbConnection2.Execute(SQLDateSuppress)
        If rsDateSuppress.EOF Then
            DisplayDate = DisplayDate & strWeekDay & "&nbsp;" & strDate
        End If
        rsDateSuppress.Close
        Set rsDateSuppress = nothing
        
        'Time

        SQLTimeSuppress = "SELECT OptionValue AS TimeSuppress FROM EventOptions (NOLOCK) WHERE EventCode = " & rsEvents("EventCode") & " AND OptionName = 'TimeSuppress' AND OptionValue = 'Y'"
        Set rsTimeSuppress = OBJdbConnection2.Execute(SQLTimeSuppress)
        If rsTimeSuppress.EOF Then
            DisplayDate = DisplayDate & "<BR>at " & strTime
        End If
        rsTimeSuppress.Close
        Set rsTimeSuppress = nothing 

        'Set Event Information with Available Status
        If SeatStatusClass = "Available" Then
        		
            If Not UCase(Request("Tooltip")) = "N" Then
                 EventInfo = "<A HREF=""/Event.asp?Event=" & rsEvents("EventCode") & """ onmouseover=""ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode=" & rsEvents("EventCode") & "\', this)', 200);"" onmouseout=""clearTimeout(ttDelay);hideTooltip();""><B>" & rsEvents("Act") & ActSuffix & "</B></A>"
            Else
                EventInfo = "<A HREF=""/Event.asp?Event=" & rsEvents("EventCode") & """><B>" & rsEvents("Act") & ActSuffix & "</B></A>"
            End If 
            
        Else
             EventInfo = "<B>" & rsEvents("Act") & " " & ActSuffix & "</B>"
        End If    
      

	    %>
	    <tr>
        	<td class="<%=seatstatusclass%> hovercolor data"><%=DisplayDate%></td>
            <td class="<%=seatstatusclass%> hovercolor data"><%= EventInfo %></td>
            <td class="<%=seatstatusclass%> hovercolor data"><%=rsEvents("Venue")%><BR><%=rsEvents("City")%>, <%=rsEvents("State")%></td>
            <td class="<%=seatstatusclass%> hovercolor data"><%=AvailableSeats%></td>
       </tr>
	  <%
	  events="Y"
	  rsEvents.MoveNext

	Loop

	Call DBClose(OBJdbConnection2)

%>
    	<tr>
        	<td colspan="4" class="rounded-foot-left"></td>
        	<td class="rounded-foot-right">&nbsp;</td>
        </tr>
       </table>
       

<%
Else
%>
	    <CENTER>There are no events on sale at this time.</CENTER>
<%	
End If

rsEvents.Close
Set rsEvents = nothing

%>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>
</html>

<%
OBJdbConnection.Close
Set OBJdbConnection = nothing
%>
