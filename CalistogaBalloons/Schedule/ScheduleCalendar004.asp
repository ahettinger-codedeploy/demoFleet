<!--#INCLUDE virtual="PrivateLabelInclude.asp" -->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->

<%

'set the flag to include the TooltipInclude.html file
TooltipIncludeFlag = "Y"

'============================================================

'SPECIAL EVENTS LIST
'Display these special events apart from the other events
'When this option is active, the special events are not displayed in the event or act lists

SpecialEventDisplay = True
SpecialEventVenueLocation = True
SpecialEventDateDisplay = False

SpecialEventTitle = "Gift Certificates"
SpecialEventList = "430218"


'============================================================

If IsNumeric(CleanNumeric(Request("OrganizationNumber"))) AND Request("OrganizationNumber") <> "" Then
    OrgNum = CleanNumeric(Request("OrganizationNumber"))
Else
    OrgNum = 0
End If

'TTT 2/26/10 - filtered schedule page with ActCodes
ActCodeList = ""
If Request("ActCode") <> "" Then       
    ActCodeList = CleanNumList(Request("ActCode"))
End If

FirstEventDate = Now()
'Get the first Event that is on sale and passed current date/time
SQLEvents = "SELECT TOP(1) EventDate FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE OrganizationVenue.OrganizationNumber = " & OrgNum & " AND OrganizationAct.OrganizationNumber = " & OrgNum & " AND Event.EventDate > GETDATE() AND Event.SaleStartDate <= '" & Now() & "' AND OnSale = 1"
If ActCodeList <> "" Then
    SQLEvents = SQLEvents & " AND Event.ActCode IN (" & ActCodeList & ")"
End If
SQLEvents = SQLEvents & " ORDER BY EventDate"
Set rsEvents = OBJdbConnection.Execute(SQLEvents)
If Not rsEvents.EOF Then
    FirstEventDate = CDate(rsEvents("EventDate"))
End If
rsEvents.Close
Set rsEvents = Nothing

If IsNumeric(Request("CalendarMonth")) And Request("CalendarMonth") <> "" Then
    CalendarMonth = CleanNumeric(Request("CalendarMonth"))
Else
    CalendarMonth = Month(FirstEventDate)
End If
If IsNumeric(Request("CalendarYear")) And Request("CalendarYear") <> ""  Then        
    CalendarYear = CleanNumeric(Request("CalendarYear"))
Else    
    CalendarYear = Year(FirstEventDate)
End If
CampaignNumberLink = ""
If IsNumeric(Request("CampaignNumber")) And Request("CampaignNumber") <> ""  Then        
    CampaignNumberLink = "&CampaignNumber=" & CleanNumeric(Request("CampaignNumber"))
End If

If Request("FormName") = "dateselection" Then
    Call CopyEvent
Else
    Call DateSelectionForm
End If


Sub DateSelectionForm
'REE 6/19/9 - Added Dynamic Page Title
'REE 10/23/9 - Modified to use dynamic title only when no PL Title exists.
'REE 1/16/10 - Added CleanNumerics throughout
If Request("OrganizationNumber")<> "" And Title = "" Then
    SQLOrg = "SELECT Organization FROM Organization (NOLOCK) WHERE OrganizationNumber = " & CleanNumeric(Request("OrganizationNumber"))
    Set rsOrg = OBJdbConnection.Execute(SQLOrg)
    
    Title = rsOrg("Organization") & " Ticket Sales"
    
    rsOrg.Close
    Set rsOrg = nothing
End If

%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<TITLE><%= Title %></TITLE>


<style type="text/css">
    body
{
    font-family: Arial,'DejaVu Sans','Liberation Sans',Freesans,sans-serif;
    line-height: 1 em;
}
a.buybutton {
     background: transparent url('/client/CalistogaBalloons/schedule/images/bg_button_a.gif') no-repeat scroll top right;
     color: #444;
     display: block;
     float: left;
     font: normal 12px arial, sans-serif;
     height: 24px;
     margin-right: 6px;
     padding-right: 18px; /* sliding doors padding */
     text-decoration: none;
 }
a.buybutton span {
     background: transparent url('/client/CalistogaBalloons/schedule/images/bg_button_span.gif') no-repeat;
     display: block;
     line-height: 14px;
     padding: 5px 0 5px 18px;
 }
a.buybutton:hover {
     background-position: bottom right;
     color: #000;
     outline: none; /* hide dotted outline in Firefox */
 }
a.buybutton:hover span {
     background-position: bottom left;
     padding: 6px 0 4px 18px; /* push text down 1px */
 } 
#rounded-corner
{
	text-align: left;
	border-collapse: collapse;
}
#rounded-corner table
{
    border-left: 1px solid #999;
    border-spacing: 0px;
    font-family:Arial,'DejaVu Sans','Liberation Sans',Freesans,sans-serif;
}
#rounded-corner thead th.category
{
	font-weight:bold; 
	text-align:center; 
	padding:5px; 
	border-bottom:1px solid #999; 
	border-top:1px solid #999; 
	border-right:1px solid #999; 
	color: <%=TableCategoryFontColor%>; 
	background:<%=TableCategoryBGColor%>; 
}
#rounded-corner td.footer
{
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-left
{
	text-align:center; 
	padding:5px; 
	border-bottom:1px solid #999; 
	border-top:1px solid #999; 
	border-right:1px solid #999; 
	border-left:1px solid #999; 
	color: #000000;; 
	background:<%=TableDataBGColor%>;
	
	font-size:11px;
	position:relative;
	vertical-align: top;
	line-height: 15px; /* This determins the space that will  space out the events on the calendar */
	
}
 /* link */
#rounded-corner a:link 
{
	color: #000000;  
	text-decoration: none; 
} 
 /* visited link */
#rounded-corner a:visited
{
text-decoration: none;
color: #<%=TableCategoryBGColor%>;
font-size: 12px;
} 
/* mouse over link */
#rounded-corner a:hover
{
	background-color: <%=TableDataBGColor%>;
	color: <%=TableCategoryBGColor%>;
	text-decoration: none; 
} 
/* selected link */
#rounded-corner a:active
{
text-decoration: none;
color: #<%=TableCategoryBGColor%>;
font-size: 12px;
} 
div.hr 
{ 
width: 100%; 
height: .1px; 
background: <%=BGColor%>;
} 
/* Settings for the calendar nav menu */
table.calendar-control { 
	width: 100%;
	border-spacing: 0px;
	text-align: center; 
	font-family:Arial,'DejaVu Sans','Liberation Sans',Freesans,sans-serif;

}
td.calendar-control {
	color: <%=TableDataFontColor%>;
}
td.calendar-control a {
	color: <%=TableDataFontColor%>;
	text-decoration: none; 
}
td.calendar-control a:hover 
{
	background-color: #ffffff;
	color: <%=TableCategoryBGColor%>;
	text-decoration: none; 
}

/* calendar */
/* no table width means the table will cover the size of the div or page  */
table.calendar 
{ 
    border-left: 1px solid #999;
    border-spacing: 0px;
    font-family:Arial,'DejaVu Sans','Liberation Sans',Freesans,sans-serif;
}
tr.calendar-row {  
}
td.calendar-day, td.calendar-weekend-day, td.calendar-current-day { 
	height:100px; 
	font-size:11px;
	position:relative;
	vertical-align: top;
	line-height: 15px; /* This determins the space that will  space out the events on the calendar */
}
* html div.calendar-day, div.calendar-weekend-day, div.calendar-current-day { 
	height:100px; 
}
/* This alters the headings (the days of the week) Change the colour and background for those here */
td.calendar-day-head 
{ 
	font-weight:bold; 
	text-align:center; 
	width:120px; 
	padding:5px; 
	border-bottom:1px solid #999; 
	border-top:1px solid #999; 
	border-right:1px solid #999; 
	color: <%=TableCategoryFontColor%>; 
	background:<%=TableCategoryBGColor%>; 
}
/* Change these colours to alter the respective portion of the calendar */
td.calendar-day	{ 
	background-color: <%=TableDataBGColor%>;
}
td.calendar-weekend-day	{ 
	background-color: <%=BGColor%>;
}
td.calendar-current-day	{ 
	background-color: <%=BGColor%>; 
}
/* These colours are for the mouse over effects on the calendar */
td.calendar-day:hover { 
	background:#ECEFF5; 
}
td.calendar-weekend-day:hover {
	background:#D7DADF;
}
td.calendar-current-day:hover { 
	background:#E5E7ED; 
}
/* background colour of the blank dates */
td.calendar-day-np { 
	background: <%=BGColor%>;
	min-height:100px; 
		/* color block opacity */
    filter:alpha(opacity=25);
    moz-opacity:0.25;
    html-opacity: 0.25;
    opacity: 0.25;
}
* html div.calendar-day-np 
{ 

	height:100px; 
	border-bottom:1px solid #FF0000; 
	border-top:1px solid #FF0000; 
	border-right:1px solid #FF0000; 
}
/* This alters the number dates of the calendar */
div.calendar-day-current
{
	position: relative;
	padding:5px; 
	color: #e2e2e2;  
	
    /* This creates the color square around the date */
	background-color: <%=TableCategoryBGColor%>;

	font-weight:bold; 
	float:right; 
	margin:-5px -5px 0 0; 
	width:20px; 
	text-align:right;
	line-height: normal; 
}
/* This alters the number dates of the calendar */
div.calendar-day-number 
{
	position: relative;
	padding:5px; 
	color: <%=TableCategoryBGColor%>;  
	
    /* This creates the color square around the date */
	background-color: #e2e2e2;

	font-weight:bold; 
	float:right; 
	margin:-5px -5px 0 0; 
	width:20px; 
	text-align:right;
	line-height: normal; 
}
/* This alters the text section for events on the calendar. */
div.calendar-text {
	color: #000000; 
	text-align:left;
}
div.calendar-text a {
	color: #000000;  
	text-decoration: none; 
}
div.calendar-text a:hover 
{
	background-color: <%=TableDataBGColor%>;
	color: <%=TableCategoryBGColor%>;
	text-decoration: none; 
}
/* shared */
td.calendar-day,td.calendar-current-day, td.calendar-weekend-day, td.calendar-day-np { 
	width:120px; 
	padding:5px; 
	border-bottom:1px solid <%=BGColor%>; 
	border-right:1px solid <%=BGColor%>; 
}
</style>

</HEAD>

<%= strBody %>

<!--#include virtual="TopNavInclude.asp"-->

<%

'============================================================

'SPECIAL EVENT LISTING

If SpecialEventDisplay Then

    SQLWhere = "WHERE Event.EventDate >= '" & FormatDateTime(Now(), vbShortDate) & "'"

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

    If Request("Category") <> "" Then SQLWhere = SQLWhere & " AND Category.Category IN (" & Clean(Request("Category")) & ")"


    'Display only the Special Events from this list
    '-----------------------------------------------
    SQLWhere = SQLWhere & " AND Event.EventCode IN (" & SpecialEventList & ")"       

    Select Case Request("SortOrder")
    Case "Act"
	    SQLEvents = "SELECT DISTINCT EventDate, EventCode, Act, City, State, Venue, Map From Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Category (NOLOCK) ON Act.CategoryCode = Category.CategoryCode INNER JOIN SubCategory (NOLOCK) ON Act.SubCategoryCode = SubCategory.SubCategoryCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode " & SQLWhere & "AND Event.OnSale = 1 AND Event.SaleStartDate <= '" & Now() &  "' ORDER BY Act.Act, Event.EventDate"
    Case "VenueAct"
	    SQLEvents = "SELECT DISTINCT EventDate, EventCode, Act, City, State, Venue, Map From Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Category (NOLOCK) ON Act.CategoryCode = Category.CategoryCode INNER JOIN SubCategory (NOLOCK) ON Act.SubCategoryCode = SubCategory.SubCategoryCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode " & SQLWhere & "AND Event.OnSale = 1 AND Event.SaleStartDate <= '" & Now() &  "' ORDER BY Venue.Venue, Act.Act, Event.EventDate"
    Case "VenueEventDate"
	    SQLEvents = "SELECT DISTINCT EventDate, EventCode, Act, City, State, Venue, Map From Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Category (NOLOCK) ON Act.CategoryCode = Category.CategoryCode INNER JOIN SubCategory (NOLOCK) ON Act.SubCategoryCode = SubCategory.SubCategoryCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode " & SQLWhere & "AND Event.OnSale = 1 AND Event.SaleStartDate <= '" & Now() &  "' ORDER BY Venue.Venue, Event.EventDate, Act.Act"
    Case Else
	    SQLEvents = "SELECT DISTINCT EventDate, EventCode, Act, City, State, Venue, Map From Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Category (NOLOCK) ON Act.CategoryCode = Category.CategoryCode INNER JOIN SubCategory (NOLOCK) ON Act.SubCategoryCode = SubCategory.SubCategoryCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode " & SQLWhere & "AND Event.OnSale = 1 AND Event.SaleStartDate <= '" & Now() &  "' ORDER BY Event.EventDate, Act.Act"
    End Select
    
    Set rsEvents = OBJdbConnection.Execute(SQLEvents)
	  
	If Not rsEvents.EOF Then

	    EventsOnSale = "True"
	
	    If SpecialEventsVenueLocation Then	
	    
	        If SpecialEventDateDisplay Then
	        
     %>             
                              
                <H3><%= SpecialEventTitle %></H3> 
                <table id="rounded-corner"  summary="special events header">
                <thead>
                <tr>
                    <% ColNbr = 6 %>
                    <% FootColNbr = 4 %>
                    <th scope="col" class="calendar-day-head">&nbsp;</th>
                    <th scope="col" class="calendar-day-head ">Date</th>
                    <th scope="col" class="calendar-day-head ">Event</th>
                    <th scope="col" class="calendar-day-head ">Venue</th>
                    <th scope="col" class="calendar-day-head ">Tickets</th>
                    <th scope="col" class="calendar-day-head ">&nbsp;</th>
                </tr>        
                </thead>
                <tbody> 
                               
                <% 
                
            Else 
            
                %>  
                              
                <H3><%= SpecialEventTitle %></H3> 
                <table id="rounded-corner"  summary="special events header">
                <thead>
                <tr>
                    <% ColNbr = 5 %>
                    <% FootColNbr = 3 %>
                    <th scope="col" class="category">&nbsp;</th>
                    <th scope="col" class="category">Event</th>
                    <th scope="col" class="category">Venue</th>
                    <th scope="col" class="category">Tickets</th>
                    <th scope="col" class="category">&nbsp;</th>
                </tr>        
                </thead>
                <tbody> 
                               
                <%    
                
            End If    
	    Else
	    
	        If SpecialEventDateDisplay Then	        
                %>                
                <H3><%= SpecialEventTitle %></H3>  
                <table id="rounded-corner" summary="special events header">
                <thead>
                <tr>
                    <% ColNbr = 5 %>
                    <% FootColNbr = 3 %>
                    <th scope="col" class="category">&nbsp;</th>
                    <th scope="col" class="category">Date</th>
                    <th scope="col" class="category">Event</th>
                    <th scope="col" class="category">Tickets</th>
                    <th scope="col" class="category">&nbsp;</th>
                </tr>        
                </thead>
                <tbody>                
                <%             
            Else            
                %>                
                <H3><%= SpecialEventTitle %></H3>  
                <table id="rounded-corner" summary="special events header">
                <thead>
                <tr class="calendar-row">
                    <% ColNbr = 5 %>
                    <% FootColNbr = 3 %>
                    <th scope="col" class="category">Event</th>
                    <th scope="col" class="category">Venue</th>
                    <th scope="col" class="category">Tickets</th>
                </tr>        
                </thead>
                <tbody>                
                <% 
            End If
            
            
	    End If
	
	Do While Not rsEvents.EOF
	
        strDate = FormatDateTime(rsEvents("EventDate"),vbShortDate)
        strWeekDay = WeekdayName(Weekday(rsEvents("EventDate")), True) & "."
        strTime = Left(FormatDateTime(rsEvents("EventDate"),vbLongTime),Len(FormatDateTime(rsEvents("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsEvents("EventDate"),vbLongTime),3)


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
		
	    If SpecialEventVenueLocation  Then
	    
	        If SpecialEventDateDisplay Then
	              %>
	                <tr>
	                    <td  class="data-left">&nbsp;</td>
	        	        <td  class="data-left"><%= DisplayDate %></td>
	                    <td  class="data-left"><A HREF=/Event.asp?Event="<%= rsEvents("EventCode") %>"  id="EventLink_<%= rsEvents("EventCode")%>" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode=<%= rsEvents("EventCode") %>\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();"><B><%= rsEvents("Act") & ActSuffix %></B></A></td>
        	            
	                    <% If rsEvents("City") <> "" Then %>                
                            <td class="data-left"><%= rsEvents("Venue") %><BR><%= rsEvents("City") %>,&nbsp;<%= rsEvents("State")%></td>
                        <% Else %>  
                            <td class="data-left"><%= rsEvents("Venue") %></td><% End If %>     	            
        	              
	                    <td class="data-left"><A HREF=/Event.asp?Event="<%= rsEvents("EventCode") %>" id="A1"<%= rsEvents("EventCode")%>" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode="<%= rsEvents("EventCode") %>"\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();">buy3</A></td>
                        <td  class="data-left">&nbsp;</td>
                    </tr> 
                    <tr>
                        <td colspan="<%= ColNbr %>"><div class="hr">&nbsp;</div></td>
                    </tr>            
                  <%
            Else
            	  %>
	                <tr>
	                    <td  class="data-left"><A HREF=/Event.asp?Event="<%= rsEvents("EventCode") %>"  id="A5" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode=<%= rsEvents("EventCode") %>\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();"><B><%= rsEvents("Act") & ActSuffix %></B></A></td>
        	            
	                    <% If rsEvents("City") <> "" Then %>                
                            <td class="data-left"><%= rsEvents("Venue") %><BR><%= rsEvents("City") %>,&nbsp;<%= rsEvents("State")%></td>
                        <% Else %>  
                            <td class="data-left"><%= rsEvents("Venue") %></td><% End If %>     	            
        	              
	                    <td class="data-left"><A class="buybutton" HREF=/Event.asp?Event="<%= rsEvents("EventCode") %>"><span class="buybutton">Buy2</span></A></td>
                    </tr> 
                    <tr>
                        <td colspan="<%= ColNbr %>" ><div class="hr">&nbsp;</div></td>
                    </tr>            
                  <%
            End If
	    Else
            %>
            <tr>
                <td  class="data-left">&nbsp;</td>
                <td  class="data-left"><%= DisplayDate %></td>
                <td  class="data-left"><A HREF=/Event.asp?Event=<%= rsEvents("EventCode") %> id="A2" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode=<%= rsEvents("EventCode") %>\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();"><B><%= rsEvents("Act") & ActSuffix %></B></A></td>   	                 
                <td class="data-left"><A class="buybutton" HREF=/Event.asp?Event="<%= rsEvents("EventCode") %>" id="A1"<%= rsEvents("EventCode") %>" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode="<%= rsEvents("EventCode") %>"\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();"><span class="buybutton">Buy</span></A></td>
                <td  class="data-left">&nbsp;</td>
            </tr> 
            <tr>
                <td colspan="<%= ColNbr %>"><div class="hr">&nbsp;</div></td>
            </tr>            
            <%
          
	    End If
	  	
	    rsEvents.MoveNext
	    Loop 

	    %>
        </table>
        <br /><br />    
	    <%
	
	    End If
	
rsEvents.Close
Set rsEvents = Nothing

End If


'============================================================

'EVENT CALENDAR

%>

<TABLE cellpadding="0" cellspacing="0" border="0">
  <tr>
 <td><a class="buybutton" href="#"><span class="buybutton">Buy Ticket</span></a></td> 
 
<%

ColCount = 3

StartDate = CalendarMonth & "/1/" & CalendarYear

For i = 0 to 0
    If i Mod ColCount = 0 Then
        Response.Write "</tr><tr>"
    End If
    Response.Write "<td>" & Calendar(FormatDateTime(DateAdd("m", i, StartDate), vbShortDate)) & "</td>"
Next
%>

  </tr>
</table>

</CENTER>
<BR>
<!--#INCLUDE VIRTUAL="FooterInclude.asp"-->

</BODY>
</HTML>

<%
End Sub 'Date Selection Form

'================

function calendar(CurrentDate)

	Today = Date
	if isnull(CurrentDate) then
		CurrentDate = Today
	end if                   
		
     CurrentDate = DateValue(CurrentDate)                           
     CurrentMonth = month(CurrentDate)    
     CurrentYear = year(CurrentDate)                           
     
     month_names = Array("January", _
                         "February", _
                         "March", _
                         "April", _
                         "May", _
                         "June", _
                         "July", _
                         "August", _
                         "September", _
                         "October", _
                         "November", _
                         "December")                                      
              
     this_month = datevalue(CurrentMonth & "/1/" & CurrentYear)                           
     next_month = datevalue(dateadd("m", 1, CurrentMonth &  "/1/" & CurrentYear))
     
     'Find out when this month starts and ends.         
     first_week_day = weekday(this_month) - 1                  
     
     days_in_this_month = datediff("d", this_month, next_month)                  
     
     'Previous/Next Nav Control
     '-------------------------                 
     calendar_html = "<table class=""calendar-control"" border=""0"">"
     
     If ScheduleTitle <> "" Then 
        CalendarTitle = ScheduleTitle
    Else
        CalendarTitle = "Event Calendar"
    End If
    
    calendar_html = calendar_html & _
                     "<tr><td align=""left"" width=""15%""></td><td align=""center""><h3>" & CalendarTitle & "</h3></td><td align=""right"" width=""15%""></td></tr>"      
    
    If CurrentMonth - 1 = 0 Then
        PreviousMonth = 12
        PreviousYear = CurrentYear - 1
    Else
        PreviousMonth = CurrentMonth - 1
        PreviousYear = CurrentYear
    End If
    
    If CurrentMonth + 1 > 12 Then
        NextMonth = 1
        NextYear = CurrentYear + 1
    Else
        NextMonth = CurrentMonth + 1
        NextYear = CurrentYear
    End If        
            
    PreviousLink = "ScheduleCalendar.asp?OrganizationNumber=" & OrgNum
    
    If ActCodeList <> "" Then
        PreviousLink = PreviousLink & "&ActCode=" & ActCodeList
    End If
    
    PreviousLink = PreviousLink & "&CalendarMonth=" & PreviousMonth & "&CalendarYear=" & PreviousYear & CampaignNumberLink 
    
    NextLink = "ScheduleCalendar.asp?OrganizationNumber=" & OrgNum
    
    If ActCodeList <> "" Then
        NextLink = NextLink & "&ActCode=" & ActCodeList
    End If
    
    NextLink = NextLink & "&CalendarMonth=" & NextMonth & "&CalendarYear=" & NextYear & CampaignNumberLink 
     
     calendar_html = calendar_html & _
                     "<tr><td class=""calendar-control"" align=""left""><a href=""" & PreviousLink & """><< Previous Month</a></td><td align=""center""><B>" & _
                     month_names(CurrentMonth - 1) & " " & CurrentYear & "</B></td><td class=""calendar-control"" align=""right""><a href=""" & NextLink & """>Next Month >></a></td></tr>"
                       
     calendar_html = calendar_html & "</tr>" & vbCrLf
     calendar_html = calendar_html & "</table>" & vbCrLf
     
     'Calendar - Days Of Week Header
     '------------------------------
     calendar_html = calendar_html & "<table class=""calendar"">" & vbCrLf 
      
     calendar_html = calendar_html & "<tr class=""calendar-row"">" & vbCrLf 
     
     for wdnum = 1 To 7
        calendar_html = calendar_html & "<td class=""calendar-day-head"">" & WeekdayName(wdnum, true) & "</td>"
     next
                    
     calendar_html = calendar_html & "</tr>" & vbCrLf
     
     'Calendar - Blank Days
     '------------------------------
       
     calendar_html = calendar_html & "<tr class=""calendar-row"">"
     
     'Fill the first week of the month with the appropriate number of blanks.       
     for week_day = 0 to first_week_day - 1            
         calendar_html = calendar_html & "<td class=""calendar-day-np""></td>"   
         daycount = daycount + 1
     next
        
     week_day = first_week_day
     for day_counter = 1 to days_in_this_month           
        daycount = daycount + 1
         week_day = week_day mod 7
        
         if week_day = 0 then
            calendar_html = calendar_html & "</tr>" & vbCrLf
            calendar_html = calendar_html & "<tr class=""calendar-row"">" & vbCrLf
         end if
    
        CalendarDate = CDate(CalendarMonth & "/" & day_counter & "/" & CalendarYear)
        
		If CalendarDate < Today Then
			DayDisplay = "<div class=""calendar-day-number"">" & day_counter & "</div>"
		ElseIf CalendarDate = Today Then
			DayDisplay = "<div class=""calendar-day-current"">" & day_counter & "</div>"
		Else 'CalendarDate > Today 
			DayDisplay = "<div class=""calendar-day-number"">" & day_counter & "</div>"
		End If
		
        calendar_html = calendar_html & "<td class=""calendar-day"">" & DayDisplay & ""                                
                                        
        SQLEvent = "SELECT Act.ActCode, Act.Act, Event.EventCode, Event.EventDate FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode AND OrganizationAct.OrganizationNumber = OrganizationVenue.OrganizationNumber WHERE OrganizationVenue.OrganizationNumber = " & OrgNum & " AND Event.EventDate >= '" & CalendarDate & "' AND Event.EventDate < '" & CalendarDate + 1 & "' AND Event.SaleStartDate <= '" & Now() & "' AND OnSale = 1"
        
        If ActCodeList <> "" Then
            SQLEvent = SQLEvent & " AND Event.ActCode IN (" & ActCodeList & ")"
        End If
        
        SQLEvent = SQLEvent & " ORDER BY Act.Act, Act.ActCode, Event.EventCode"
        
        Set rsEvent = OBJdbConnection.Execute(SQLEvent)
        ActCd = -1
        
        calendar_html = calendar_html & "<br><br><div class=""calendar-text"">"
        
        Do Until rsEvent.EOF
            If ActCd <> rsEvent("ActCode") Then
                SameAct = 1
                EventCd = rsEvent("EventCode")
                ActCd = rsEvent("ActCode")
                ActNm = rsEvent("Act")
            Else
                SameAct = SameAct + 1
            End If
            
            'calendar_html = calendar_html & CalendarDate
            rsEvent.MoveNext
            
            If Not rsEvent.EOF Then
                If ActCd <> rsEvent("ActCode") Then
                    If SameAct > 1 Then
                        If CalendarDate >= Date() Then 
                            calendar_html = calendar_html & "<a href=""/Schedule.asp?ActCode=" & ActCd & "&StartDate=" & CalendarDate & "&EndDate=" & CalendarDate & CampaignNumberLink & """ onmouseover=""ttDelay=setTimeout('eventTooltip(\'/AJAX/ProductionInfo.asp?ActCode=" & ActCd & "\', this)', 200);"" onmouseout=""clearTimeout(ttDelay);hideTooltip();"">" & ActNm & "</a><br><br>"
                        End If
                    Else
                        If CalendarDate >= Date() Then
                            calendar_html = calendar_html & "<a href=""/Event.asp?Event=" & EventCd & CampaignNumberLink & """ onmouseover=""ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode=" & EventCd & "\', this)', 200);"" onmouseout=""clearTimeout(ttDelay);hideTooltip();"">" & ActNm & "</a><br><br>"
                         End If
                    End If
                End If
            Else
                If SameAct > 1 Then
                    If CalendarDate >= Date() Then 
                        calendar_html = calendar_html & "<a href=""/Schedule.asp?ActCode=" & ActCd & "&StartDate=" & CalendarDate & "&EndDate=" & CalendarDate & CampaignNumberLink & """ onmouseover=""ttDelay=setTimeout('eventTooltip(\'/AJAX/ProductionInfo.asp?ActCode=" & ActCd & "\', this)', 200);"" onmouseout=""clearTimeout(ttDelay);hideTooltip();"">" & ActNm & "</a><br><br>"
                    End If
                Else
                    If CalendarDate >= Date() Then
                        calendar_html = calendar_html & "<a href=""/Event.asp?Event=" & EventCd & CampaignNumberLink & """ onmouseover=""ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode=" & EventCd & "\', this)', 200);"" onmouseout=""clearTimeout(ttDelay);hideTooltip();"">" & ActNm & "</a><br><br>"
                   End If
                End If    
            End If
        Loop
        
        rsEvent.Close
        Set rsEvent = nothing
        
        calendar_html = calendar_html & "</div>"
        calendar_html = calendar_html & "</td>"
            
         week_day = week_day + 1
     next
     
     for ree = 0 to 6 - week_day
        calendar_html = calendar_html & "<td class=""calendar-day-np""> &nbsp;</td>"
     next
        
     calendar_html = calendar_html & "</tr>" & vbCrLf
     calendar_html = calendar_html & "</table>"
               
     Calendar = calendar_html
end function
%>
