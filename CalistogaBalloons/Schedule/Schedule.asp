<!--#INCLUDE virtual="PrivateLabelInclude.asp" -->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->

<%

TooltipIncludeFlag = "Y"
Page = "Schedule"

'============================================================

'SEASON SUBSCRIPTIONS

'Display the subscription events in a seperate listing

SubscriptionsDisplay = False
SubscriptionVenueLocation = False
SubscriptionEventsTitle = "Season Tickets"
SubscriptionEventList = "404719,405215,404140"

'-----------------------------------

'FEATURED EVENTS LIST

'Display the events which have date/time suppressed in a seperate listing
'Similar to Special Events, except the system automatically displays these events

FeaturedEventDisplay = False
FeaturedEventVenueLocation = True
FeaturedEventTitle = "FEATURED EVENTS LIST"

'-----------------------------------

'SPECIAL EVENTS LIST

'Display these events in their own seperate listing(s)
'When this option is active, the special events are not displayed in the event or act lists
'Special events must be manuually added to the list below

SpecialEventDisplay = False
SpecialEventVenueLocation = True
SpecialEventDateDisplay = False
SpecialEventTitle = "Special Events Schedule"
SpecialEventList = "00000,00000,00000"


'-----------------------------------

'EVENT LISTING

'Display the events in date order

EventDisplay = False
EventVenueLocation = True
EventTitle = "Event Listing"

'-----------------------------------

'SUBCATEGORY EVENT LISTING

'Display the events in date order
'Grouped in seperate listings by subcategory

SubCategoryDisplay = True



'DONATION / MEMBERSHIP
'Display listing for the donation/membership page

DonationDisplay = False
DonationEventsTitle = "Contributions"

'-----------------------------------

'ACT SELECTION LISTING

'Display the events by grouping together by act name
'List can be sorted by act name or by act date

ActSelectionDisplay = False
ActSelectionTitle = "Individual Tickets"
ActSort = "ActDate"

'-----------------------------------

OffSaleMessage = "N"


'============================================================

If DocType <> "" Then
	Response.Write DocType
Else
	Response.Write "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
End If

%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<html>
<head>

<title>TIX.com</title>

<style type="text/css">
    
body
{
    font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
    line-height: 1 em;
}
#rounded-corner
{
	font-size: 11px;
    font-weight: 400;
	text-align: left;
	border-collapse: collapse;
	width: 50%;
	top: 10px;
	line-height: 12px;
	margin-top:  -16px;
}
#rounded-corner thead th.category
{
	padding-top: 10px;
    padding-bottom: 10px;
    padding-left: 0px;
    padding-right: 0px;
	font-size: 15px;
	font-weight: 600px;
	text-align: left;
	color: <%=TableCategoryFontColor%>;
	background: <%=TableCategoryBGColor%>;
}
#rounded-corner thead th.category-left
{
	background: <%=TableCategoryBGColor%> url('<%=NECorner%>') left -1px no-repeat;
	text-align: right;
}
#rounded-corner thead th.category-right
{
	background: <%=TableCategoryBGColor%> url('<%=NWCorner%>') right -1px no-repeat;
    text-align: left;
}
#rounded-corner td.footer
{
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.footer-left
{
    background: <%=TableDataBGColor%> url('<%=SWCorner%>') left bottom no-repeat;
}
#rounded-corner td.footer-right
{
	background: <%=TableDataBGColor%> url('<%=SECorner%>') right bottom no-repeat;
}
#rounded-corner td.data
{
	padding-left: 0px;
	padding-right: 0px;
	padding-top: 5px;
	padding-bottom: 5px;
	font-size: 10px;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-left
{
	padding-left: 0px;
	padding-right: 0px;
	padding-top: 5px;
	padding-bottom: 5px;
	text-align: left;
	font-size: 10px;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-right
{
	padding-left: 0px;
	padding-right: 0px;
	padding-top: 5px;
	padding-bottom: 5px;
    text-align: right;
    font-size: 10px;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
 /* link */
#rounded-corner a:link 
{
text-decoration: none;
color: #<%=TableCategoryBGColor%>;
font-size: 10px;
font-weight: 400;
} 
 /* visited link */
#rounded-corner a:visited
{
text-decoration: none;
color: #<%=TableCategoryBGColor%>;
font-size: 10px;
font-weight: 300;
} 
/* mouse over link */
#rounded-corner a:hover
{
text-decoration: none;
color:#<%=TableCategoryBGColor%>;
font-size: 10px;
font-weight: 300;
} 
/* selected link */
#rounded-corner a:active
{
text-decoration: none;
color: #<%=TableCategoryBGColor%>;
font-size: 10px;
font-weight: 300;
} 
div.hr 
{ 
width: 100%; 
height: .25px; 
background: #<%=TableColumnHeadingBGColor%>; 
} 
#menu2 
{
  padding:0; 
  margin:0 auto; 
  list-style-type:none;
  float:left;
  position:relative; 
  left:50%;
}
#menu2 li 
{
  float:left; position:relative; right:50%;
}
#menu2 a 
{
  width:auto;
  display:block;
  padding:4px 16px;
  color:<%=TableCategoryFontColor%>; 
  background:<%=TableCategoryBGColor%>; 
  border:1px solid #fff; 
  text-decoration:none;
  font-size: 15px;
    font-weight: 600;
}
#menu2 a:hover 
{
  color:<%=TableDataFontColor%>;
  background:<%=TableDataBGColor%>;
  font-size: 15px;
  font-weight: 600;
}

</style>

</head>

<%=strBody %>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<BR />
<FONT FACE="<%= FontFace%>" COLOR="<%=HeadingFontColor%>" SIZE="5"><B><%=ScheduleTitle%></B></FONT>
<BR />
<BR />
<%


'============================================================

'SEASON SUBSCRIPTIONS

SubscriptionEventsOnSale = "N"
SubscriptionEventsList = "404719,405215,404140"
SubscriptionEventList = "404719,405215,404140"

If SubscriptionsDisplay Then

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

SQLEvents = "SELECT DISTINCT EventDate, EventCode, Act, City, State, Venue From Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Category (NOLOCK) ON Act.CategoryCode = Category.CategoryCode INNER JOIN SubCategory (NOLOCK) ON Act.SubCategoryCode = SubCategory.SubCategoryCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode " & SQLWhere & "AND Event.OnSale = 1 AND Event.SaleStartDate <= '" & Now() &  "' AND Event.EventType = 'SubFixedEvent' ORDER BY Event.EventDate, Act.Act"
Set rsEvents = OBJdbConnection.Execute(SQLEvents)

If Not rsEvents.EOF Then

	EventsOnSale = "True"
	
	If SubscriptionVenueLocation  Then
        %>                
        <H3><%= SubscriptionEventsTitle %></H3> 
        <table id="rounded-corner" summary="subscription header" cellpadding="0" cellspacing="0" border="1">
        <thead>
        <tr>
            <th scope="col" class="category-left">&nbsp;</th>
            <th scope="col" class="category">Subscription Package</th>
            <th scope="col" class="category">Venue</th>
            <th scope="col" class="category">Tickets</th>
            <th scope="col" class="category-right">&nbsp;</th>
        </tr>        
        </thead>
        <tbody>                
        <% 
	Else
        %>                
        <H3><%= SubscriptionEventsTitle %></H3>  
        <table id="rounded-corner" summary="subscription header">
        <thead>
        <tr>
            <th scope="col" class="category-left">&nbsp;</th>
            <th scope="col" class="category" colspan="2">Subscription Package</th>
            <th scope="col" class="category">Tickets</th>
            <th scope="col" class="category-right">&nbsp;</th>
            <th scope="col" class="category-left">&nbsp;</th>
        </tr>        
        </thead>
        <tbody>                
        <% 
	End If
	
	
	Do While Not rsEvents.EOF
	
	    'Create list of subscription event for later use as an excluded list
	    '-----------------------------------------------------------------------
	    SubscriptionEventList = SubscriptionEventList &  rsEvents("EventCode") & ","  
	
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
        

	
	If SubscriptionVenueLocation  Then
	  %>
        <tr>
            <td class="data-left"><A HREF=/Event.asp?Event="<%= rsEvents("EventCode") %>" id="EventLink_"<%= rsEvents("EventCode") %>" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode="<%= rsEvents("EventCode") %>"\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();"><B><%= rsEvents("Act") & ActSuffix %></B></td>
            
            <% If rsEvents("City") <> "" Then %>                
                <td class="data-left">
                <%= rsEvents("Venue") %><BR>
                <%= rsEvents("City") %>,&nbsp;<%= rsEvents("State") %>
                </td>
            <% Else %>  
                <td class="data-left">
                <%= rsEvents("Venue") %>
                </td>
            <% End If %>  
            
            <td class="data-left" colspan="3"><A HREF=/Event.asp?Event="<%= rsEvents("EventCode") %>" id="TixInfoLink_"<%= rsEvents("EventCode") %>" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode="<%= rsEvents("EventCode") %>"\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();">Tix & Info</A></td>
        </tr>
        <tr>
            <td class="data-left" colspan="5"><div class="hr">&nbsp;</div></td>
        </tr>            
      <%
	Else
	  %>
        <tr>
            <td class="data-left">&nbsp;</td>
            <td class="data-left" colspan="2"><A HREF=/Event.asp?Event="<%= rsEvents("EventCode") %>" id="EventLink_"<%= rsEvents("EventCode") %>" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode="<%= rsEvents("EventCode") %>"\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();"><B><%= rsEvents("Act") & ActSuffix %></B></td>            
            <td class="data-left"><A HREF=/Event.asp?Event="<%= rsEvents("EventCode") %>" id="TixInfoLink_"<%= rsEvents("EventCode") %>" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode="<%= rsEvents("EventCode") %>"\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();">Tix & Info</A></td>
        </tr>
        <tr>
            <td class="data-left" colspan="5"><div class="hr">&nbsp;</div></td>
        </tr>            
      <%
	End If
	  	
	rsEvents.MoveNext
	Loop 
	
	%>
	        
        <tr>
            <td class="footer-left">&nbsp;</td>
            <td class="footer" colspan="3">&nbsp;</td>
            <td class="footer-right">&nbsp;</td>
        </tr> 
        </table>
        <br />    
	<%
	
End If

rsEvents.Close
Set rsEvents = nothing

'Finalize the Subscription Event List
'-------------------------------------
If Right(SubscriptionEventList,1) = "," Then
    X = Len(SubscriptionEventList)
    SubscriptionEventList = Left(SubscriptionEventList,(X-1))
End If


End If


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
                <table id="rounded-corner" summary="special events header">
                <thead>
                <tr>
                    <% ColNbr = 6 %>
                    <% FootColNbr = 4 %>
                    <th scope="col" class="category-left">&nbsp;</th>
                    <th scope="col" class="category">Date</th>
                    <th scope="col" class="category">Event</th>
                    <th scope="col" class="category">Venue</th>
                    <th scope="col" class="category">Tickets</th>
                    <th scope="col" class="category-right">&nbsp;</th>
                </tr>        
                </thead>
                <tbody> 
                               
                <% 
                
            Else 
            
                %>  
                              
                <H3><%= SpecialEventTitle %></H3> 
                <table id="rounded-corner" summary="special events header">
                <thead>
                <tr>
                    <% ColNbr = 5 %>
                    <% FootColNbr = 3 %>
                    <th scope="col" class="category-left">&nbsp;</th>
                    <th scope="col" class="category">Event</th>
                    <th scope="col" class="category">Venue</th>
                    <th scope="col" class="category">Tickets</th>
                    <th scope="col" class="category-right">&nbsp;</th>
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
                    <th scope="col" class="category-left">&nbsp;</th>
                    <th scope="col" class="category">Date</th>
                    <th scope="col" class="category">Event</th>
                    <th scope="col" class="category">Tickets</th>
                    <th scope="col" class="category-right">&nbsp;</th>
                </tr>        
                </thead>
                <tbody>                
                <%             
            Else            
                %>                
                <H3><%= SpecialEventTitle %></H3>  
                <table id="rounded-corner" summary="special events header">
                <thead>
                <tr>
                    <% ColNbr = 5 %>
                    <% FootColNbr = 3 %>
                    <th scope="col" class="category-left">&nbsp;</th>
                    <th scope="col" class="category">Event</th>
                    <th scope="col" class="category">Venue</th>
                    <th scope="col" class="category">Tickets</th>
                    <th scope="col" class="category-right">&nbsp;</th>
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
        	              
	                    <td class="data-left"><A HREF=/Event.asp?Event="<%= rsEvents("EventCode") %>" id="A1"<%= rsEvents("EventCode")%>" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode="<%= rsEvents("EventCode") %>"\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();">Tix & Info</A></td>
                        <td  class="data-left">&nbsp;</td>
                    </tr> 
                    <tr>
                        <td colspan="<%= ColNbr %>"><div class="hr">&nbsp;</div></td>
                    </tr>            
                  <%
            Else
            	  %>
	                <tr>
	                    <td  class="data-left">&nbsp;</td>
	                    <td  class="data-left"><A HREF=/Event.asp?Event="<%= rsEvents("EventCode") %>"  id="A5" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode=<%= rsEvents("EventCode") %>\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();"><B><%= rsEvents("Act") & ActSuffix %></B></A></td>
        	            
	                    <% If rsEvents("City") <> "" Then %>                
                            <td class="data-left"><%= rsEvents("Venue") %><BR><%= rsEvents("City") %>,&nbsp;<%= rsEvents("State")%></td>
                        <% Else %>  
                            <td class="data-left"><%= rsEvents("Venue") %></td><% End If %>     	            
        	              
	                    <td class="data-left"><A HREF=/Event.asp?Event="<%= rsEvents("EventCode") %>" id="A6"<%= rsEvents("EventCode")%>" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode="<%= rsEvents("EventCode") %>"\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();">Tix & Info</A></td>
                        <td  class="data-left">&nbsp;</td>
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
                <td class="data-left"><A HREF=/Event.asp?Event="<%= rsEvents("EventCode") %>" id="A1"<%= rsEvents("EventCode") %>" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode="<%= rsEvents("EventCode") %>"\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();">Tix & Info</A></td>
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
        <tr>
            <td class="footer-left">&nbsp;</td>
            <td class="footer" colspan="<%= FootColNbr %>">&nbsp;</td>
            <td class="footer-right">&nbsp;</td>
        </tr> 
        </table>
        <br /><br />    
	    <%
	
	    End If
	
rsEvents.Close
Set rsEvents = Nothing

End If


'============================================================

'EVENT LISTING

EventOnSale = "Y"

If EventDisplay Then

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
    
    
    'Exclude the Season Subscriptions from this list
    '-----------------------------------------------
    If SubscriptionsDisplay Then
        SQLWhere = SQLWhere & " AND Event.EventCode NOT IN (" & SubscriptionEventList & ")"
    End If


    'Exclude the Special Events from this list
    '-----------------------------------------------
    If SpecialEventDisplay Then
       SQLWhere = SQLWhere & " AND Event.EventCode NOT IN (" & SpecialEventList & ")"
    End If   
       

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
    
    If EventVenueLocation Then	
	%>  
                          
        <H3><%= EventTitle %></H3> 
        <table id="rounded-corner" summary="special events header">
        <thead>
        <tr>
            <% ColNbr = 6 %>
            <% FootColNbr = 4 %>
            <th scope="col" class="category-left">&nbsp;</th>
            <th scope="col" class="category">Date</th>
            <th scope="col" class="category">Event</th>
            <th scope="col" class="category">Venue</th>
            <th scope="col" class="category">Tickets</th>
            <th scope="col" class="category-right">&nbsp;</th>
        </tr>        
        </thead>
        <tbody>                
        <%
	Else
        %>                
        <H3><%= EventTitle %></H3>  
        <table id="rounded-corner" summary="events header">
        <thead>
        <tr>
            <% ColNbr = 5 %>
            <% FootColNbr = 3 %>
            <th scope="col" class="category-left">&nbsp;</th>
            <th scope="col" class="category">Date</th>
            <th scope="col" class="category">Event</th>
            <th scope="col" class="category">Tickets</th>
            <th scope="col" class="category-right">&nbsp;</th>
        </tr>        
        </thead>
        <tbody>                
        <% 
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
		
	    If EventVenueLocation  Then
	      %>
	        <tr>
	            <td class="data-left">&nbsp;</td>
	        	<td  class="data-left"><%= DisplayDate %></td>
	            <td  class="data-left"><A HREF=/Event.asp?Event=<%= rsEvents("EventCode") %> id="EventLink_<%= rsEvents("EventCode") %>" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode=<%= rsEvents("EventCode") %>\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();"><B><%= rsEvents("Act") & ActSuffix %></B></A></td>
	            
	            <% If rsEvents("City") <> "" Then %>                
                    <td class="data-left"><%= rsEvents("Venue") %><BR><%= rsEvents("City") %>,&nbsp;<%= rsEvents("State") %></td>
                <% Else %>  
                    <td class="data-left"><%= rsEvents("Venue") %></td><% End If %>     	            
	              
	            <td class="data-left"><A HREF=/Event.asp?Event="<%= rsEvents("EventCode") %>" id="TixInfoLink_"<%= rsEvents("EventCode") %>" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode="<%= rsEvents("EventCode") %>"\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();">Tix & Info</A></td>
                <td class="data-right">&nbsp;</td>
            </tr> 
            <tr>
                <td colspan="<%= ColNbr %>"><div class="hr">&nbsp;</div></td>
            </tr>            
          <%
	    Else
	      %>
	        <tr>
	            <td class="data-left">&nbsp;</td>
	        	<td class="data-left"><%= DisplayDate %></td>
	            <td class="data-left"><A HREF=/Event.asp?Event=<%= rsEvents("EventCode") %> id="EventLink_<%= rsEvents("EventCode") %>" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode=<%= rsEvents("EventCode") %>\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();"><B><%= rsEvents("Act") & ActSuffix %></B></A></td>   	                 
	            <td class="data-left"><A HREF=/Event.asp?Event="<%= rsEvents("EventCode") %>" id="TixInfoLink_"<%= rsEvents("EventCode") %>" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode="<%= rsEvents("EventCode") %>"\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();">Tix & Info</A></td>
                <td class="data-right">&nbsp;</td>
            </tr> 
            <tr>
                <td colspan="<%= ColNbr %>"><div class="hr">&nbsp;</div></td>
            </tr>            
          <%
	    End If
	  	
	    rsEvents.MoveNext
	    Loop 
	
	    %>
	        
        <tr>
            <td class="footer-left">&nbsp;</td>
            <td class="footer" colspan="<%= FootColNbr %>">&nbsp;</td>
            <td class="footer-right">&nbsp;</td>
        </tr> 
        </table>
        <br /><br />    
	    <%
	
	
rsEvents.Close
Set rsEvents = Nothing

End If


'======================================

'ACT SELECTION - EVENT LIST

ActSelectionOnSale = "N"

If ActSelectionDisplay Then

SQLWhere = " WHERE Event.EventDate >= '" & FormatDateTime(Now(), vbShortDate) & "'"

If IsDate(Clean(Request("StartDate"))) Then
	SQLWhere = SQLWhere & " AND Event.EventDate >= '" & CDate(Clean(Request("StartDate"))) & "'"
End If

If IsDate(Clean(Request("EndDate"))) Then
	SQLWhere = SQLWhere & " AND Event.EventDate < '" & CDate(Clean(Request("EndDate"))) + 1 & "'"
End If

'Exclude the Season Subscriptions from this list
'-----------------------------------------------
If SubscriptionsDisplay Then
    SQLWhere = SQLWhere & " AND Event.EventCode NOT IN (" & SubscriptionEventList & ")"
End If


'Exclude the Special Events from this list
'-----------------------------------------------
If SpecialEventDisplay Then
    SQLWhere = SQLWhere & " AND Event.EventCode NOT IN (" & SpecialEventList & ")"
End If



If Request("OrganizationNumber") <> "" Then SQLWhere = SQLWhere & " AND OrganizationAct.OrganizationNumber IN (" & CleanNumList(Request("OrganizationNumber")) & ") AND OrganizationVenue.OrganizationNumber IN (" & CleanNumList(Request("OrganizationNumber")) & ")"

If Request("ActCode") <> "" Then SQLWhere = SQLWhere & " AND Event.ActCode = " & CleanNumeric(Request("ActCode"))

If Request("VenueCode") <> "" Then SQLWhere = SQLWhere & " AND Venue.VenueCode = " & CleanNumeric(Request("VenueCode"))

If Request("EventCode") <> "" Then SQLWhere = SQLWhere & " AND Event.EventCode = " & CleanNumeric(Request("EventCode"))

SQLEvents = "SELECT Act.ActCode, Act.Act, Event.EventDate, Event.EventCode FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Category (NOLOCK) ON Act.CategoryCode = Category.CategoryCode INNER JOIN SubCategory (NOLOCK) ON Act.SubCategoryCode = SubCategory.SubCategoryCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode LEFT JOIN MemberSaleStartDate (NOLOCK) ON Event.EventCode = MemberSaleStartDate.EventCode " & SQLWhere & " AND Event.OnSale = 1 AND (MemberSaleStartDate.OrganizationNumber = '" & CleanNumeric(Request("OrganizationNumber")) & "' AND MemberSaleStartDate.MemberType = '" & Session("MemberType") & "' AND MemberSaleStartDate.MemberSaleStartDate <= '" & Now() & "' AND IsNull(MemberSaleStartDate.MemberSaleEndDate, DATEADD(DAY, 1, GETDATE())) > '" & Now() & "' OR Event.SaleStartDate <= '" & Now() &  "')"

Select Case ActSortOrder
Case "ACT"
	SQLQuery = SQLQuery & " ORDER BY Act.Act, Event.EventDate"
Case "CATEGORY"
	SQLQuery = SQLQuery & " ORDER BY Category, Act.Act, Event.EventDate"
Case "SUBCATEGORY"
	SQLQuery = SQLQuery & " ORDER BY SubCategory, Act.Act, Event.EventDate"
Case "SUBCATDATE"
	SQLQuery = SQLQuery & " ORDER BY SubCategory, Event.EventDate"
Case "ACTDATE"
	SQLQuery = SQLQuery & " ORDER BY Event.EventDate"
Case Else
	SQLQuery = SQLQuery & " ORDER BY Act.Act, Act.ActCode, Event.EventDate"
End Select

Set rsEvents = OBJdbConnection.Execute(SQLEvents)

If Not rsEvents.EOF Then

    EventsOnSale = "True"

%>
        <Br />
        <Br />
        <H3><%= ActSelectionTitle %></H3> 
        <table id="rounded-corner" summary="act selection header">
        <thead>
        <tr>
            <th scope="col" class="category-left">&nbsp;</th>
            <th scope="col" class="category">Production</th>
            <th scope="col" class="category">Dates</th>
            <th scope="col" class="category">Tickets</th>
            <th scope="col" class="category-right">&nbsp;</th>
        </tr>        
        </thead>
        <tbody> 

<%


	Do While Not rsEvents.EOF
				
		If LastActCode <> rsEvents("ActCode") Then
		
			'Get the Start and End Dates
			SQLDates = "SELECT COUNT(Event.EventCode) AS EventCount, MIN(EventDate) AS StartDate, MAX(EventDate) AS EndDate FROM Event (NOLOCK) LEFT JOIN MemberSaleStartDate (NOLOCK) ON Event.EventCode = MemberSaleStartDate.EventCode WHERE ActCode = " & rsEvents("ActCode") & " AND Event.EventDate >= '" & FormatDateTime(Now(), vbShortDate) & "' AND Event.OnSale = 1 AND (MemberSaleStartDate.OrganizationNumber = '" & CleanNumeric(Request("OrganizationNumber")) & "' AND MemberSaleStartDate.MemberType = '" & Session("MemberType") & "' AND MemberSaleStartDate.MemberSaleStartDate <= '" & Now() & "' AND IsNull(MemberSaleStartDate.MemberSaleEndDate, DATEADD(DAY, 1, GETDATE())) > '" & Now() & "' OR Event.SaleStartDate <= '" & Now() &  "')"
			Set rsDates = OBJdbConnection.Execute(SQLDates)
			
			'Add code to go to Event.asp if there is a single event for this act.
			If rsDates("EventCount") > 1 Then
				Link = "/Schedule.asp?ActCode=" & rsEvents("ActCode")
			Else
				Link = "/Event.asp?Event=" & rsEvents("EventCode")
			End If
						
			If rsDates("StartDate") <> rsDates("EndDate") Then 'Display date range
                
                %>
		        
		        <tr>
                    <td  class="data-left">&nbsp;</th>
                    <td  class="data-left"><B><A HREF=<%= Link & OrganizationString %> id="ProductionInfoLink_<%= rsEvents("ActCode") %>" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/ProductionInfo.asp?ActCode=<%= rsEvents("ActCode") %>\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();"><%= rsEvents("Act") %></A></B></td>
                    <td  class="data-left"><br /><%= MonthName(Month(rsDates("StartDate")), true) %>&nbsp;&nbsp;<%= Day(rsDates("StartDate")) %>&nbsp;&#151;&nbsp;<%= MonthName(Month(rsDates("EndDate")), true) %>&nbsp;<%= Day(rsDates("EndDate")) %><br /><br /></th>
                    <td  class="data-left"><A HREF=<%= Link & OrganizationString %> id="TixInfoLink_<%= rsEvents("ActCode") %>" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/ProductionInfo.asp?ActCode=<%= rsEvents("ActCode") %>\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();">Tix & Info</A></td>
                    <td  class="data-left">&nbsp;</th>
                </tr> 
                <tr>
                    <td colspan="5"><div class="hr">&nbsp;</div></td>
                </tr> 
                
                <% 				
				
			Else 'Display Date
			
				DisplayDate = ""

				SQLDateSuppress = "SELECT OptionValue AS DateSuppress FROM EventOptions (NOLOCK) WHERE EventCode = " & rsEvents("EventCode") & " AND OptionName = 'DateSuppress' AND OptionValue = 'Y'"
				Set rsDateSuppress = OBJdbConnection.Execute(SQLDateSuppress)
				
				If rsDateSuppress.EOF Then
					DisplayDate = MonthName(Month(CDate(rsDates("StartDate")))) & " " & Day(rsDates("StartDate")) & ", " & Year(rsDates("StartDate"))
				End If
				
				rsDateSuppress.Close
				Set rsDateSuppress = nothing
				
				%>
		        
		        <tr BGCOLOR=<%= TableDataBGColor %>>
                    <td  class="data-left">&nbsp;</td>
                    <td  class="data-left"><A HREF=<%= Link & OrganizationString %> id="A3" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/ProductionInfo.asp?ActCode=<%= rsEvents("ActCode") %>\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();"><%= rsEvents("Act") %></A></td>
                    <td  class="data-left"><br /><%= MonthName(Month(rsDates("StartDate")), true) %> <%= Day(rsDates("StartDate")) %><br /><br /></td>
                    <td  class="data-left"><A HREF=<%= Link & OrganizationString %> id="A4" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/ProductionInfo.asp?ActCode=<%= rsEvents("ActCode") %>\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();">Tix & Info</A></td>
                    <td  class="data-left">&nbsp;</td>
                </tr> 
                <tr>
                    <td colspan="5"><div class="hr">&nbsp;</div></td>
                </tr> 				
				
				<%
			    
			End If
			
			LastActCode = rsEvents("ActCode")
			
			EventCount = 0

			rsDates.Close
			Set rsDates = nothing

		End If
		rsEvents.MoveNext
	Loop 
	
    %>
    
    <tr>
        <td class="footer-left">&nbsp;</td>
        <td  class="footer">&nbsp;</td>
        <td class="footer">&nbsp;</td>
        <td  class="footer">&nbsp;</td>
        <td class="footer-right">&nbsp;</td>
    </tr> 
    </table>
    <br /><br />
    <%

End If

rsEvents.Close
Set rsEvents = nothing

End If

'===================================

'SUBCATEGORY EVENT LISTING

If SubCategoryDisplay Then

If ScheduleTitle <> "" Then
	Response.Write "<H3>" & ScheduleTitle & "</H3>" & vbCrLf
Else
	Response.Write "<H3>Schedule</H3>" & vbCrLf
End If

SQLWhere = "AND Event.EventDate >= '" & FormatDateTime(Now(), vbShortDate) & "'"

If IsDate(Clean(Request("StartDate"))) Then
	SQLWhere = SQLWhere & " AND Event.EventDate >= '" & CDate(Clean(Request("StartDate"))) & "'"
End If

If IsDate(Clean(Request("EndDate"))) Then
	SQLWhere = SQLWhere & " AND Event.EventDate < '" & CDate(Clean(Request("EndDate"))) + 1 & "'"
End If


Select Case Request("SortOrder")
Case "Act"
	SQLQuery = "SELECT DISTINCT EventDate, EventCode, Act, City, State, Venue From Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Category (NOLOCK) ON Act.CategoryCode = Category.CategoryCode INNER JOIN SubCategory (NOLOCK) ON Act.SubCategoryCode = SubCategory.SubCategoryCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode " & SQLWhere & "AND Event.OnSale = 1 AND Event.SaleStartDate <= '" & Now() &  "' ORDER BY Act.Act, Event.EventDate"
Case Else
	SQLQuery = "SELECT DISTINCT EventDate, EventCode, Act, City, State, Venue From Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Category (NOLOCK) ON Act.CategoryCode = Category.CategoryCode INNER JOIN SubCategory (NOLOCK) ON Act.SubCategoryCode = SubCategory.SubCategoryCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode " & SQLWhere & "AND Event.OnSale = 1 AND Event.SaleStartDate <= '" & Now() &  "' ORDER BY Event.EventDate, Act.Act"
End Select
Set rsEvents = OBJdbConnection.Execute(SQLQuery)


Call DBOpen(OBJdbConnection2)
	  
If Request("OrganizationNumber") <> "" Then SQLWhere = SQLWhere & " AND OrganizationAct.OrganizationNumber = '" & Clean(Request("OrganizationNumber")) & "' AND OrganizationVenue.OrganizationNumber = '" & Clean(Request("OrganizationNumber")) & "'"
If Request("ActCode") <> "" Then SQLWhere = SQLWhere & " AND Act.ActCode IN (" & Clean(Request("ActCode")) & ")" 
If Request("VenueCode") <> "" Then SQLWhere = SQLWhere & " AND Venue.VenueCode IN( " & Clean(Request("VenueCode")) & ")" 
If Request("EventCode") <> "" Then SQLWhere = SQLWhere & " AND Event.EventCode IN (" & Clean(Request("EventCode")) & ")"

'All future events - SubCategory Listings
SQLSubCategories = "SELECT DISTINCT SubCategory.SubCategoryCode, SubCategory FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN SubCategory (NOLOCK) ON Act.SubCategoryCode = SubCategory.SubCategoryCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE EventDate >= '" & EventStart & "' AND OnSale = 1 AND Event.SaleStartDate <= '" & Now() &  "'"
SQLSubCategories = SQLSubCategories & SQLWhere & " ORDER BY SubCategory.SubCategory, SubCategory.SubCategoryCode"
Set rsSubCategories = OBJdbConnection.Execute(SQLSubCategories)

If Not rsSubCategories.EOF Then

    Response.Write "<div class=""container"">" & vbCrLf
    Response.Write "<ul id=""menu2"">" & vbCrLf
	    Do Until rsSubCategories.EOF
		    Response.Write "<li><A HREF=""#" & rsSubCategories("SubCategory") & """>" & rsSubCategories("SubCategory") & "</a></li>" & vbCrLf
		    rsSubCategories.MoveNext
	    Loop	
    Response.Write "</ul>" & vbCrLf
    Response.Write "</div><Br><br>" & vbCrLf
	
End If

'Do not change the following line without changing the appropriate GetRows array
'All future events
SQLEvents = "SELECT EventDate, Act, SubCategory.SubcategoryCode, SubCategory, Event.EventCode, City, State, Venue FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN SubCategory (NOLOCK) ON Act.SubCategoryCode = SubCategory.SubCategoryCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE EventDate >= '" & EventStart & "' AND OnSale = 1 AND Event.SaleStartDate <= '" & Now() &  "'"
SQLEvents = SQLEvents & SQLWhere & " ORDER BY SubCategory.SubCategory, SubCategory.SubCategoryCode, EventDate"
Set rsEvents = OBJdbConnection.Execute(SQLEvents)

If Not rsEvents.EOF Then
    
	LastSubCategoryCode = rsEvents("SubCategoryCode")
'	Response.Write "<A NAME=""" & rsEvents("SubCategory") & """></A>" & vbCrLf
	Response.Write "<TABLE CELLSPACING=0 CELLPADDING=0 WIDTH=90% BORDER=0>" & vbCrLf
	Response.Write "<TR><TD HEIGHT=1><A NAME=""" & rsEvents("SubCategory") & """></A></TD></TR>" & vbCrLf
	If IncludeVenueLocation Then
		Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=8 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>Date/Time</B></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>" & rsEvents("SubCategory") & "</B></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>Venue/Location</B></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>Tickets</B></FONT></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=8 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=8 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=8 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
	Else
		Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=6 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>Date/Time</B></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>" & rsEvents("SubCategory") & "</B></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>Tickets</B></FONT></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=6 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=6 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=6 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
	End If


	CellBGColor = "#FFFFFF"

	Do Until rsEvents.EOF

		If rsEvents("SubCategoryCode") <> LastSubCategoryCode Then
			LastSubCategoryCode = rsEvents("SubCategoryCode")
		'	Response.Write "<A NAME=""" & rsEvents("SubCategory") & """></A>" & vbCrLf
			Response.Write "<TR><TD HEIGHT=1><A NAME=""" & rsEvents("SubCategory") & """></A><BR></TD></TR>" & vbCrLf
			If IncludeVenueLocation Then
				Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=8 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
				Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>Date/Time</B></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>" & rsEvents("SubCategory") & "</B></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>Venue/Location</B></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>Tickets</B></FONT></TD></TR>" & vbCrLf
				Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=8 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
				Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=8 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
				Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=8 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
			Else
				Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=6 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
				Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>Date/Time</B></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>" & rsEvents("SubCategory") & "</B></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>Tickets</B></FONT></TD></TR>" & vbCrLf
				Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=6 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
				Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=6 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
				Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=6 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
			End If
		End If		
		
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
		Set rsDateSuppress = OBJdbConnection2.Execute(SQLDateSuppress)
		If rsDateSuppress.EOF Then
			DisplayDate = DisplayDate & strWeekDay & "&nbsp;" & strDate
		End If
		rsDateSuppress.Close
		Set rsDateSuppress = nothing

		SQLTimeSuppress = "SELECT OptionValue AS TimeSuppress FROM EventOptions (NOLOCK) WHERE EventCode = " & rsEvents("EventCode") & " AND OptionName = 'TimeSuppress' AND OptionValue = 'Y'"
		Set rsTimeSuppress = OBJdbConnection2.Execute(SQLTimeSuppress)
		If rsTimeSuppress.EOF Then
			DisplayDate = DisplayDate & "<BR>at " & strTime
		End If
		rsTimeSuppress.Close
		Set rsTimeSuppress = nothing

	  If IncludeVenueLocation Then
			Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=8 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
			Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD>&nbsp;&nbsp;</TD><TD ALIGN=left NOWRAP><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1>" & DisplayDate & "</FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=/Event.asp?Event=" & rsEvents("EventCode") & "><B>" & rsEvents("Act") & ActSuffix & "</B></A></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1>" & rsEvents("Venue") & "<BR>" & rsEvents("City") & ", " & rsEvents("State") & "</FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=/Event.asp?Event=" & rsEvents("EventCode") & ">Tix & Info</A>&nbsp;</FONT></TD></TR>" & vbCrLf
			Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=8 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
			Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=8 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
	  Else
			Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=6 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
			Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD>&nbsp;&nbsp;</TD><TD ALIGN=left NOWRAP><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1>" & DisplayDate & "</FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=/Event.asp?Event=" & rsEvents("EventCode") & "><B>" & rsEvents("Act") & ActSuffix & "</B></A></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=/Event.asp?Event=" & rsEvents("EventCode") & ">Tix & Info</A>&nbsp;</FONT></TD></TR>" & vbCrLf
			Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=6 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
			Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=6 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
	  End If	

		If CellBGColor = "#FFFFFF" Then 
			CellBGColor = "#EEEEEE"
		Else
			CellBGColor = "#FFFFFF"
		End If

		rsEvents.MoveNext
	Loop
	Response.Write "</TABLE></CENTER><BR>" & vbCrLf


Else

	'REE 7/4/3 - Added VenueOption for No Events On Sale Message
	SQLNoEventsMessage = "SELECT OptionValue AS NoEventsMessage FROM VenueOptions (NOLOCK) WHERE VenueCode = " & iVenueCode & " AND OptionName = 'NoEventsMessage'"
	Set rsNoEventsMessage = OBJdbConnection2.Execute(SQLNoEventsMessage)
	  
	If Not rsNoEventsMessage.EOF Then 'Use the Message in Venue Options
		NoEventsMessage = rsNoEventsMessage("NoEventsMessage")
	Else
		NoEventsMessage = "There are no events on sale at this time.  Please check back again."
	End If
	
	rsNoEventsMessage.Close
	Set rsNoEventsMessage = nothing
	  
	Response.Write "<FONT FACE=" & FontFace & " COLOR=" & FontColor & " SIZE=2><BR>" & NoEventsMessage & "</FONT>"

End If

Call DBClose(OBJdbConnection2)

rsEvents.Close
Set rsEvents = Nothing
Response.Write "<BR><BR>" & vbCrLf


End If

'===================================

'DONATION EVENT LISTING

If DonationDisplay Then

SQLDonateOrganization = "SELECT Organization AS OrganizationName, OrganizationNumber FROM Organization (NOLOCK) WHERE Organization.OrganizationNumber = '" & CleanNumeric(Request("OrganizationNumber")) & "'"
Set rsDonateOrganization = OBJdbConnection.Execute(SQLDonateOrganization)
DonationOrganizationName = rsDonateOrganization("OrganizationName")
DonationOrganizationNumber = rsDonateOrganization("OrganizationNumber")
rsDonateOrganization.Close
Set rsDonateOrganization = nothing


SQLEvents = "SELECT DISTINCT ItemNumber From Donation (NOLOCK) WHERE Donation.OrganizationNumber = " & DonationOrganizationNumber & ""
Set rsEvents = OBJdbConnection.Execute(SQLEvents)
	  
If Not rsEvents.EOF Then

	    EventsOnSale = "True"

%>
              
            <Br />
            <Br />
            <H3><%=DonationEventsTitle%></H3> 
            <table id="rounded-corner" summary="donation events header">
            <thead>
            <tr>
                <th scope="col" class="category-left">&nbsp;</th>
                <th scope="col" class="category">Contributions</th>
                <th scope="col" class="category">Info</th>
                <th scope="col" class="category-right">&nbsp;</th>
            </tr>
            </thread> 
            <tr>
                <td scope="col" class="data-left">&nbsp;</td>
                <td scope="col" class="data"><br /><a href="/donation.asp?organizationnumber=<%=DonationOrganizationNumber%>"><%=DonationOrganizationName%>&nbsp;Donation/Membership</a><br /><br /></td>
                 <td scope="col" class="data"><a href="/donation.asp?organizationnumber=<%=DonationOrganizationNumber%>">Info</a></td>
                <td scope="col" class="data-right">&nbsp;</td>
            </tr> 
            <tr>
                <td colspan="5"><div class="hr">&nbsp;</div></td>
            </tr> 
            <tbody>  
            <tr>
                <td class="footer-left">&nbsp;</td>
                <td  class="footer">&nbsp;</td>
                <td class="footer-right">&nbsp;</td>
            </tr> 
            </table>
            
<%

End If

rsEvents.Close
Set rsEvents = nothing
 
End If     
  

%>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>

</html>




