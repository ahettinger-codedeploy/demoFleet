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

SpecialEventsTitle(1) = "Macho Like Me"
SpecialEventSubTitle(1) = ""
SpecialActList(1)= "54885"  

NoEventsMessage = "There are no events on sale at this time.  Please check back again."

SpecialEventsOnSale = 0

'===============================================

%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<TITLE><%= Title %></TITLE>

<style type="text/css">
      
table#tix {
 font-size: xx-small;
 font-family: Arial, Helvetica, verdana sans-serif;
 background-color:#fff;
 border-collapse: collapse;
 width: 70%;
}
thead th {
 border-right: 1px solid #fff;
 color:#fff;
 text-align: left;
 padding:2px;
 text-transform:uppercase;
 height:25px;
 background-color: #a3c159;
 font-weight: normal;
}
tfoot {
 color:#1ba6b2;
 padding:2px;
 text-transform:uppercase;
 font-size:1.2em; 
 font-weigth: bold;
 margin-top:6px;
 border-top: 6px solid #e9f7f6;
}
tbody tr {
 background-color:#fff;
 border-bottom: 10px solid #f0f0f0;
}
tbody td {
 color:#414141;
 padding: 5px;
 text-align: left;
}
tbody th {
 text-align:left;
 padding:0px;
}
tbody td a, tbody th a {
 color:#6C8C37;
 text-decoration: none;
 text-align: left;
 font-weight: normal; 
 background: transparent url(http://www.nghorta.com/csstg/links_yellow.gif) no-repeat 0% 50%;
 padding-left:0px;
}
tbody td a:hover, tbody th a:hover 
{
 text-align: left;
 color:#009193;
 text-decoration: none;
}
</style>

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
        
        <table id="tix" summary="schedule page">
        <caption>&nbsp;</caption>
        <thead>        
        <%
         If IncludeVenueLocation Then
        %>        
        <tr>
		    <th scope="col">Date/Time</th>
		    <th scope="col">Event</th>
		    <th scope="col">Venue/Location</th>
		    <th scope="col">Buy Tickets</th>		
	    </tr>	
	    </thead>
        <tfoot>
            <tr>
                <th scope="row">&nbsp;</th>
                <td colspan="4">&nbsp;</td>
            </tr>
        </tfoot>
	    <tbody>    
         <%
        Else
         %>         
        <tr>
		<th scope="col">Date/Time</th>
		<th scope="col">Event</th>
		<th scope="col">Buy Tickets</th>		
	    </tr>	
	    </thead>
	    <tbody>      
         <%
        End If 
        	
	    Do While Not rsEvents.EOF
        	
            strDate = FormatDateTime(rsEvents("EventDate"),vbShortDate)
            strWeekDay = WeekdayName(Weekday(rsEvents("EventDate")), True) & "."
            strTime = Left(FormatDateTime(rsEvents("EventDate"),vbLongTime),Len(FormatDateTime(rsEvents("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsEvents("EventDate"),vbLongTime),3)
              
            'ActSuffix
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
        %>
        <tr >
            <th scope="row"><%= DisplayDate%></th>
            <td><A HREF=/Event.asp?Event=<%= rsEvents("EventCode") %> id="A1""EventLink_<%= rsEvents("EventCode") %>" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode=<%= rsEvents("EventCode") %>\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();"><B><%= rsEvents("Act") & ActSuffix %></B></A></td>
            <td><%= rsEvents("Venue")%><br /><%=rsEvents("City")%>, <%=rsEvents("State")%></td>
            <td><A HREF=/Event.asp?Event=<%= rsEvents("EventCode") %> id="A1""TixInfoLink_<%= rsEvents("EventCode") %>" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode=<%= rsEvents("EventCode") %>\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();">Buy Tickets</A></td>
        </tr>

        <%
        Else
        %>
        <tr >
            <th scope="row"><%= DisplayDate%></th>
            <td><A HREF=/Event.asp?Event=<%= rsEvents("EventCode") %> id="A1" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode=<%= rsEvents("EventCode") %>\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();"><B><%= rsEvents("Act") & ActSuffix %></B></A></td>
            <td><A HREF=/Event.asp?Event=<%= rsEvents("EventCode") %> id="A2" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode=<%= rsEvents("EventCode") %>\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();">Buy Tickets</A></td>
        </tr>
        <%

	    End If	
	    events="Y"
	    rsEvents.MoveNext
	    Loop 
	    
        %>
	    </table><br>
        <%
        
        End If
        rsEvents.Close
        Set rsEvents = Nothing
        
 Next

%>

</center>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>
</html>

<%
OBJdbConnection.Close
Set OBJdbConnection = nothing
%>

