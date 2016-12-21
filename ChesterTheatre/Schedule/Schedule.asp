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

SpecialEventsList = "334515,334516,334517,334518" 

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

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<meta http-equiv="content-type" content="text/html;charset=ISO-8859-1">
<meta http-equiv="content-style-type" content="text/css">
<meta name="verify-v1" content="LN72U9rimAIJGIxgfODYO8sbtPBk37O7g3uTUZ3dlfg=">

<TITLE>Chester Theatre - Ticket Sales</TITLE>

<style type="text/css">
#rounded-corner
{
	font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
	font-size: 12px;
	margin: 45px;
	width: 600px;
	text-align: center;
	border-collapse: collapse;
}
#rounded-corner th
{
	padding: 8px;
	font-weight: bold;
	font-size: 13px;
	color: <%=TableCategoryFontColor%>;
	background: <%=TableCategoryBGColor%>;
}
#rounded-corner thead th.rounded-header-left
{
	background: <%=TableCategoryBGColor%> url('/Clients/ChesterTheatre/Images/corner_nw.gif') left -1px no-repeat;
}
#rounded-corner thead th.rounded-header-right
{
	background: <%=TableCategoryBGColor%> url('/Clients/ChesterTheatre/Images/corner_ne.gif') right -1px no-repeat;
}
#rounded-corner td.data
{
	padding: 8px;
	background: <%=TableDataBGColor%>;
	border-top: 1px solid <%=TableCategoryBGColor%>;
	font-size: 10px;
	color: <%=TableDataFontColor%>;
} 
#rounded-corner td.rounded-foot
{
	background: <%=TableCategoryBGColor%>
}
#rounded-corner td.rounded-foot-left
{
	background: <%=TableCategoryBGColor%> url('/Clients/ChesterTheatre/Images/corner_sw.gif') left bottom no-repeat;
}
#rounded-corner td.rounded-foot-right
{
	background: <%=TableCategoryBGColor%> url('/Clients/ChesterTheatre/Images/corner_se.gif') right bottom no-repeat;
}
#rounded-corner tbody tr:hover td.hovercolor
{
	background: #22262d;
}
#rounded-corner td.footer-bottom
{
	background: #000000;
	border-width:0px;
    border-style:solid;
    border-color: transparent;
    border-collapse:collapse;
    text-align: right;
}
#rounded-corner td.data a:link 
{
color: <%=TableCategoryBGColor%>;
font-weight: lighter;
font-size: 10px;
text-decoration: none;
}
#rounded-corner td.data a:visited 
{
color: <%=TableCategoryBgColor%>;
font-weight: normal;
font-size: 10px;
text-decoration: none;
} 
#rounded-corner td.data a:hover 
{
color: <%=TableCategoryBgColor%>;
font-weight: normal;
font-size: 10px;
text-decoration: none;
} 
#rounded-corner td.data a:active 
{
color: <%=TableCategoryBgColor%>;
font-weight: normal;
font-size: 10px;
text-decoration: none;
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


'==============================================
'Special Events Listing
'==============================================

SQLWhere = "WHERE Event.EventDate >= '" & FormatDateTime(Now(), vbShortDate) & "'"

If IsDate(Clean(Request("StartDate"))) Then
	SQLWhere = SQLWhere & " AND Event.EventDate >= '" & CDate(Clean(Request("StartDate"))) & "'"
End If
If IsDate(Clean(Request("EndDate"))) Then
	SQLWhere = SQLWhere & " AND Event.EventDate < '" & CDate(Clean(Request("EndDate"))) + 1 & "'"
End If

If Request("OrganizationNumber") <> "" Then SQLWhere = SQLWhere & " AND OrganizationAct.OrganizationNumber = '" & Clean(Request("OrganizationNumber")) & "' AND OrganizationVenue.OrganizationNumber = '" & Clean(Request("OrganizationNumber")) & "'"

SQLQuery = "SELECT DISTINCT EventDate, EventCode, Act, City, State, Venue From Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Category (NOLOCK) ON Act.CategoryCode = Category.CategoryCode INNER JOIN SubCategory (NOLOCK) ON Act.SubCategoryCode = SubCategory.SubCategoryCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode " & SQLWhere & " AND Event.OnSale = 1 AND Event.SaleStartDate <= '" & Now() &  "' AND (Event.EventType <> 'SubFixedEvent' OR Event.EventType IS NULL) AND Event.EventCode IN (" & SpecialEventsList &  ") ORDER BY Event.EventDate, Act.Act"

Set rsEvents = OBJdbConnection.Execute(SQLQuery)
	  
If Not rsEvents.EOF Then

    %>
    <H3>Season Subscriptions</H3>
    <table id="rounded-corner" summary="specialevents">
    <thead>
	    <tr>
            <th scope="col" class="rounded-header-left" align="left">Event</th>
            <th scope="col">Venue/Location</th>
            <th scope="col" class="rounded-header-right">Tickets</th>
        </tr>
    </thead>  	
   	
    <%

	Call DBOpen(OBJdbConnection2)

	Do Until rsEvents.EOF  
	  
    'Check for Available Seats
    SQLSeatCheck = "SELECT Count(ItemNumber) as LineCount FROM Seat (NOLOCK) WHERE EventCode = " & rsEvents("EventCode") & " AND StatusCode = 'A'"
    Set rsSeatCheck = OBJdbConnection.Execute(SQLSeatCheck)

    If rsSeatCheck("LineCount") > 0 Then			
        BuyTickets = "<A HREF=""/Event.asp?Event=" & rsEvents("EventCode") & """><B>Buy Tickets</B></A>"
        SeatStatusClass = "Available"
    Else
        BuyTickets =  "Sold Out"
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
            <td class="data hovercolor" align="left"><%= EventInfo %></td>
            <td class="data hovercolor"><%=rsEvents("Venue")%><BR><%=rsEvents("City")%>, <%=rsEvents("State")%></td>
            <td class="data hovercolor"><%=BuyTickets%></td>
      </tr>
	  <%
	  Events="Y"
	  rsEvents.MoveNext

	Loop

	Call DBClose(OBJdbConnection2)

%>
    	<tr>
        	<td class="rounded-foot-left"></td>
        	<td class="rounded-foot">&nbsp;</td>
        	<td class="rounded-foot-right">&nbsp;</td>
        </tr>
       </table>
       

<%
Else
%>
	    	   <CENTER>&nbsp;</CENTER>
<%	
End If

rsEvents.Close
Set rsEvents = nothing


'==============================================
'Regular Events Listing
'==============================================

SQLWhere = "WHERE Event.EventDate >= '" & FormatDateTime(Now(), vbShortDate) & "'"

If IsDate(Clean(Request("StartDate"))) Then
	SQLWhere = SQLWhere & " AND Event.EventDate >= '" & CDate(Clean(Request("StartDate"))) & "'"
End If
If IsDate(Clean(Request("EndDate"))) Then
	SQLWhere = SQLWhere & " AND Event.EventDate < '" & CDate(Clean(Request("EndDate"))) + 1 & "'"
End If

If Request("OrganizationNumber") <> "" Then SQLWhere = SQLWhere & " AND OrganizationAct.OrganizationNumber = '" & Clean(Request("OrganizationNumber")) & "' AND OrganizationVenue.OrganizationNumber = '" & Clean(Request("OrganizationNumber")) & "'"

SQLQuery = "SELECT DISTINCT EventDate, EventCode, Act, City, State, Venue From Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Category (NOLOCK) ON Act.CategoryCode = Category.CategoryCode INNER JOIN SubCategory (NOLOCK) ON Act.SubCategoryCode = SubCategory.SubCategoryCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode " & SQLWhere & " AND Event.OnSale = 1 AND Event.SaleStartDate <= '" & Now() &  "' AND (Event.EventType <> 'SubFixedEvent' OR Event.EventType IS NULL) AND Event.EventCode NOT IN (" & SpecialEventsList &  ") ORDER BY Event.EventDate, Act.Act"

Set rsEvents = OBJdbConnection.Execute(SQLQuery)
	  
If Not rsEvents.EOF Then
    
    If ScheduleTitle <> "" Then
    %>
    <H3><%=ScheduleTitle%></H3>
    <%
    Else
    %>
    <H3>Schedule</H3>
    <%
    End If
    %>
    <table id="rounded-corner" summary="schedulepage">
    <thead>
	    <tr>
	        <th scope="col" class="rounded-header-left">Date/Time</th>
            <th scope="col" align="left">Event</th>
            <th scope="col">Venue/Location</th>
            <th scope="col" class="rounded-header-right">Tickets</th>
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
        BuyTickets = "<A HREF=""/Event.asp?Event=" & rsEvents("EventCode") & """><B>Buy Tickets</B></A>"
        SeatStatusClass = "Available"
    Else
        BuyTickets =  "Sold Out"
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
	        <td class="data hovercolor"><%=DisplayDate%></td>
            <td class="data hovercolor" align="left"><%= EventInfo %></td>
            <td class="data hovercolor"><%=rsEvents("Venue")%><BR><%=rsEvents("City")%>, <%=rsEvents("State")%></td>
            <td class="data hovercolor"><%=BuyTickets%></td>
      </tr>
	  <%
	  Events="Y"
	  rsEvents.MoveNext

	Loop

	Call DBClose(OBJdbConnection2)

%>
    	<tr>
        	<td class="rounded-foot-left"></td>
        	<td class="rounded-foot" colspan="2">&nbsp;</td>
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
