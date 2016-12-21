<!--#INCLUDE virtual="PrivateLabelInclude.asp" -->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->

<%

TooltipIncludeFlag = "Y"
Page = "Schedule"

'============================================================
'Subscription Events Module

'-----------------------------------
'SEASON SUBSCRIPTION LISTING

SubscriptionEventsTitle = "2010-2011 Season"
SubscriptionVenueLocation = True
'-----------------------------------


'============================================================

'CSS Survey Variables

If Session("UserNumber")<> "" Then
    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "FFFFFF"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "000000"
    TableDataBGColor = "E9E9E9"
End If

'LastHex = box color
'FirstHex = background color

If Session("UserNumber")<> "" Then
    NECorner="/clients/tix/images/image.asp?FirstHex=efebe3&LastHex=008400&Src=TopLeftCorner16.txt"
    NWCorner="/clients/tix/images/image.asp?FirstHex=efebe3&LastHex=008400&Src=TopRightCorner16.txt"
    SWCorner="/clients/tix/images/image.asp?FirstHex=f3f1ed&LastHex=E9E9E9&Src=BottomLeftCorner16.txt"
    SECorner="/clients/tix/images/image.asp?FirstHex=f3f1ed&LastHex=E9E9E9&Src=BottomRightCorner16.txt"
Else
    NECorner="/clients/tix/images/image.asp?FirstHex=efebe3&LastHex=565f68&Src=TopLeftCorner16.txt"
    NWCorner="/clients/tix/images/image.asp?FirstHex=efebe3&LastHex=565f68&Src=TopRightCorner16.txt"
    SWCorner="/clients/tix/images/image.asp?FirstHex=efebe3&LastHex=ded6c8&Src=BottomLeftCorner16.txt"
    SECorner="/clients/tix/images/image.asp?FirstHex=efebe3&LastHex=ded6c8&Src=BottomRightCorner16.txt"
End If

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
	width: 700px;
	text-align: left;
	border-collapse: collapse;
}
#rounded-corner thead th.category
{
	padding-top: 10px;
    padding-bottom: 10px;
    padding-left: 0px;
    padding-right: 1px;
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
	padding-left: 5px;
	padding-right: 5px;
	padding-top: 5px;
	padding-bottom: 5px;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-left
{
	padding-left: 5px;
	padding-right: 5px;
	padding-top: 5px;
	padding-bottom: 5px;
	text-align: left;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-right
{
	padding-left: 5px;
	padding-right: 5px;
	padding-top: 5px;
	padding-bottom: 5px;
    text-align: right;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner hr 
{
   border: 0;
   width: 100%;
   height: 1px;
   color: #565f68;
   background-color: #565f68;
 }
 /* link */
#rounded-corner a:link 
{
text-decoration: none;
color: #<%=TableCategoryBGColor%>;
font-size: 11px;
font-weight: 400;
} 
 /* visited link */
#rounded-corner a:visited
{
text-decoration: none;
color: #<%=TableCategoryBGColor%>;
font-size: 11px;
font-weight: 400;
} 
/* mouse over link */
#rounded-corner a:hover
{
text-decoration: none;
color:#<%=TableCategoryBGColor%>;
font-size: 11px;
font-weight: 400;
} 
/* selected link */
#rounded-corner a:active
{
text-decoration: none;
color: #<%=TableCategoryBGColor%>;
font-size: 11px;
font-weight: 400;
} 
</style>

</HEAD>

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
SubscriptionEventsList = ""

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

	SubscriptionEventsOnSale = "Y"
	
	If SubscriptionVenueLocation  Then
        %>                
        <br />
        <H3><%= SubscriptionEventsTitle %></H3>
        <br />  
        <table id="rounded-corner" summary="subscription header">
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
        <br />
        <H3><%= SubscriptionEventsTitle %></H3>
        <br />   
        <table id="rounded-corner" summary="subscription header">
        <thead>
        <tr>
            <th scope="col" class="category-left">&nbsp;</th>
            <th scope="col" class="category" colspan="2">Subscription Package</th>
            <th scope="col" class="category">Tickets</th>
            <th scope="col" class="category-right">&nbsp;</th>
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
            <td class="data-left">&nbsp;</td>
            <td class="data-left"><A HREF=/Event.asp?Event="<%= rsEvents("EventCode") %>" id="EventLink_"<%= rsEvents("EventCode") %>"" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode="<%= rsEvents("EventCode") %>"\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();"><%= rsEvents("Act") & ActSuffix %></td>
            
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
            
            <td class="data-left"><A HREF=/Event.asp?Event="<%= rsEvents("EventCode") %>" id="TixInfoLink_"<%= rsEvents("EventCode") %>"" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode="<%= rsEvents("EventCode") %>"\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();">Tix & Info</A></td>
            <td class="data-left">&nbsp;</td>
        </tr>
        <tr>
            <td class="data-left" colspan="6"><hr /></td>
        </tr>            
      <%
	Else
	  %>
        <tr>
            <td class="data-left">&nbsp;</td>
            <td class="data-left" colspan="2"><A HREF=/Event.asp?Event="<%= rsEvents("EventCode") %>" id="A1"<%= rsEvents("EventCode") %>"" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode="<%= rsEvents("EventCode") %>"\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();"><%= rsEvents("Act") & ActSuffix %></td>            
            <td class="data-left"><A HREF=/Event.asp?Event="<%= rsEvents("EventCode") %>" id="A2"<%= rsEvents("EventCode") %>"" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode="<%= rsEvents("EventCode") %>"\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();">Tix & Info</A></td>
            <td class="data-left">&nbsp;</td>
        </tr>
        <tr>
            <td class="data-left" colspan="6"><hr /></td>
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


'End of Season Subscriptions

'============================================================

ErrorLog("SubscriptionEventList " & SubscriptionEventList & "")

'============================================================

'OFF SALE MESSAGE

If SubscriptionEventsOnSale = "N"  Then 'There weren't any subscription events on sale.  

	SQLNoEventsMessage = "SELECT OptionValue AS NoEventsMessage FROM VenueOptions (NOLOCK) WHERE VenueCode = " & iVenueCode & " AND OptionName = 'NoEventsMessage'"
	Set rsNoEventsMessage = OBJdbConnection.Execute(SQLNoEventsMessage)
	  
	If Not rsNoEventsMessage.EOF Then 'Use the Message in Venue Options
		NoEventsMessage = rsNoEventsMessage("NoEventsMessage")
	Else
		NoEventsMessage = "There are no one events on sale at this time. Please check back again."
	End If

	rsNoEventsMessage.Close
	Set rsNoEventsMessage = nothing
	
    %>
    <table>    
    <tr>
        <td> There are no one events on sale at this time. Please check back again </td>
    </tr> 
    </table>   
    <%
	  	
End If

'============================================================

%>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>

</html>




