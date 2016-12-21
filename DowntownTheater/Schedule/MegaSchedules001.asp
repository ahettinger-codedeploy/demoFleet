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

SubscriptionEventsTitle = "Subscription Events Here"
SubscriptionEventsOnSale = "N"
SubscriptionEventsList = ""
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
    NECorner="/clients/tix/images/image.asp?FirstHex=010101&LastHex=cf3d18&Src=TopLeftCorner16.txt"
    NWCorner="/clients/tix/images/image.asp?FirstHex=010101&LastHex=cf3d18&Src=TopRightCorner16.txt"
    SWCorner="/clients/tix/images/image.asp?FirstHex=010101&LastHex=290305&Src=BottomLeftCorner16.txt"
    SECorner="/clients/tix/images/image.asp?FirstHex=010101&LastHex=290305&Src=BottomRightCorner16.txt"
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

SQLQuery = "SELECT DISTINCT EventDate, EventCode, Act, City, State, Venue From Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Category (NOLOCK) ON Act.CategoryCode = Category.CategoryCode INNER JOIN SubCategory (NOLOCK) ON Act.SubCategoryCode = SubCategory.SubCategoryCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode " & SQLWhere & "AND Event.OnSale = 1 AND Event.SaleStartDate <= '" & Now() &  "' AND Event.EventType = 'SubFixedEvent' ORDER BY Event.EventDate, Act.Act"

Set rsEvents = OBJdbConnection.Execute(SQLQuery)

If Not rsEvents.EOF Then

	SubscriptionEventsOnSale = "Y"
	
	If IncludeVenueLocation Then
        %>                
        <br />
        <H3><%= SubscriptionEventsTitle %></H3>
        <br />  
        <table id="rounded-corner" summary="special events">
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
        <br />   
        <table id="rounded-corner" summary="special events">
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

	  If IncludeVenueLocation Then
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
            <td class="data-left"><A HREF=/Event.asp?Event="<%= rsEvents("EventCode") %>" id="A1"<%= rsEvents("EventCode") %>"" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode="<%= rsEvents("EventCode") %>"\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();"><%= rsEvents("Act") & ActSuffix %></td>
            
            <% If rsEvents("City") <> "" Then %>                
                <td class="data-left">
                <%= rsEvents("Venue") %><BR>
                <%= rsEvents("City") %>,&nbsp;<%= rsEvents("State") %>
                </td>
            <% Else %>  
                <td class="data-left">
                <%= rsEvents("Venue") %><BR>
                <%= rsEvents("City") %>&nbsp;<%= rsEvents("State") %>
                </td>
            <% End If %>  
            
            <td class="data-left"><pre><A HREF=/Event.asp?Event="<%= rsEvents("EventCode") %>" id="A2"<%= rsEvents("EventCode") %>"" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode="<%= rsEvents("EventCode") %>"\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();">Tix & Info</A></pre></td>
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

'ACT EVENT LISTING

EventsOnSale = "N"

SQLWhere = " WHERE Event.EventDate >= '" & FormatDateTime(Now(), vbShortDate) & "'"

If IsDate(Clean(Request("StartDate"))) Then
	SQLWhere = SQLWhere & " AND Event.EventDate >= '" & CDate(Clean(Request("StartDate"))) & "'"
End If

If IsDate(Clean(Request("EndDate"))) Then
	SQLWhere = SQLWhere & " AND Event.EventDate < '" & CDate(Clean(Request("EndDate"))) + 1 & "'"
End If


If Request("OrganizationNumber") <> "" Then SQLWhere = SQLWhere & " AND OrganizationAct.OrganizationNumber IN (" & CleanNumList(Request("OrganizationNumber")) & ") AND OrganizationVenue.OrganizationNumber IN (" & CleanNumList(Request("OrganizationNumber")) & ")"

If Request("ActCode") <> "" Then SQLWhere = SQLWhere & " AND Event.ActCode = " & CleanNumeric(Request("ActCode"))

If Request("VenueCode") <> "" Then SQLWhere = SQLWhere & " AND Venue.VenueCode = " & CleanNumeric(Request("VenueCode"))

If Request("EventCode") <> "" Then SQLWhere = SQLWhere & " AND Event.EventCode = " & CleanNumeric(Request("EventCode"))


SQLEvents = "SELECT Act.ActCode, Act.Act, Event.EventDate, Event.EventCode FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Category (NOLOCK) ON Act.CategoryCode = Category.CategoryCode INNER JOIN SubCategory (NOLOCK) ON Act.SubCategoryCode = SubCategory.SubCategoryCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode LEFT JOIN MemberSaleStartDate (NOLOCK) ON Event.EventCode = MemberSaleStartDate.EventCode " & SQLWhere & " AND Event.OnSale = 1 AND (MemberSaleStartDate.OrganizationNumber = '" & CleanNumeric(Request("OrganizationNumber")) & "' AND MemberSaleStartDate.MemberType = '" & Session("MemberType") & "' AND MemberSaleStartDate.MemberSaleStartDate <= '" & Now() & "' AND IsNull(MemberSaleStartDate.MemberSaleEndDate, DATEADD(DAY, 1, GETDATE())) > '" & Now() & "' OR Event.SaleStartDate <= '" & Now() &  "')"

Select Case UCase(Request("SortOrder"))
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

Set rsEvents = OBJdbConnection.Execute(SQLQuery)

If Not rsEvents.EOF Then

	EventsOnSale = "Y"
	
        %>                
        <br />
        <H3><%= ActEventsTitle %></H3>
        <br />  
        <table id="rounded-corner" summary="actlisting">
        <thead>
        <tr>
            <th scope="col" class="category-left">&nbsp;</th>
            <th scope="col" class="category">Production</th>
            <th scope="col" class="category">Event Dates</th>
            <th scope="col" class="category">Venue</th>
            <th scope="col" class="category">Tickets</th>
            <th scope="col" class="category-right">&nbsp;</th>
        </tr>        
        </thead>
        <tbody>                
        <% 

	Do While Not rsEvents.EOF
		
		'If it's a new event, display it.
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

               If Not UCase(Request("Tooltip")) = "N" Then
                             
                %>		        
		        <tr>
                    <td  class="data-left">&nbsp;</td>
                    <td  class="data-left"><A HREF=<%= Link & OrganizationString %> id="ProductionInfoLink_<%= rsEvents("ActCode") %>" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/ProductionInfo.asp?ActCode=<%= rsEvents("ActCode") %>\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();"><%= rsEvents("Act") %></A></td>
                    <td  class="data-left"><%= MonthName(Month(rsDates("StartDate")), true) %> <%= Day(rsDates("StartDate")) %> ~ <%= MonthName(Month(rsDates("EndDate")), true) %> <%= Day(rsDates("EndDate")) %><br /><br /></td>
                    
                        <% If rsEvents("City") <> "" Then %>                
                            <td class="data-left">
                            <%= rsEvents("Venue") %><BR>
                            <%= rsEvents("City") %>,&nbsp;<%= rsEvents("State") %>
                            </td>
                        <% Else %>  
                            <td class="data-left">
                            <%= rsEvents("Venue") %><BR>
                            <%= rsEvents("City") %>&nbsp;<%= rsEvents("State") %>
                            </td>
                        <% End If %> 
                    
                    <td  class="data-left"><A HREF=<%= Link & OrganizationString %> id="TixInfoLink_<%= rsEvents("ActCode") %>" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/ProductionInfo.asp?ActCode=<%= rsEvents("ActCode") %>\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();">Tix & Info</A></td>
                    <td  class="data-left">&nbsp;</th>
                </tr> 
                <tr>
                    <td colspan="5"><hr /></td>
                </tr> 
                <% 				

			End If
				
			Else 'Display Single Date
			
				DisplayDate = ""

				SQLDateSuppress = "SELECT OptionValue AS DateSuppress FROM EventOptions (NOLOCK) WHERE EventCode = " & rsEvents("EventCode") & " AND OptionName = 'DateSuppress' AND OptionValue = 'Y'"
				Set rsDateSuppress = OBJdbConnection.Execute(SQLDateSuppress)
				
				If rsDateSuppress.EOF Then
					DisplayDate = MonthName(Month(CDate(rsDates("StartDate")))) & " " & Day(rsDates("StartDate")) & ", " & Year(rsDates("StartDate"))
				End If
				
				rsDateSuppress.Close
				Set rsDateSuppress = nothing
			    
                If Not UCase(Request("Tooltip")) = "N" Then
                
				    Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD>&nbsp;&nbsp;</TD><TD><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=" & Link & OrganizationString & " id=""ProductionInfoLink_" & rsEvents("ActCode") & """ onmouseover=""ttDelay=setTimeout('eventTooltip(\'/AJAX/ProductionInfo.asp?ActCode=" & rsEvents("ActCode") & "\', this)', 200);"" onmouseout=""clearTimeout(ttDelay);hideTooltip();"">" & rsEvents("Act") & "</A></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left NOWRAP><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1>" & DisplayDate & "</FONT></TD><TD>&nbsp;&nbsp;</TD><TD>&nbsp;&nbsp;</TD><TD><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=" & Link & OrganizationString & " id=""TixInfoLink_" & rsEvents("ActCode") & """ onmouseover=""ttDelay=setTimeout('eventTooltip(\'/AJAX/ProductionInfo.asp?ActCode=" & rsEvents("ActCode") & "\', this)', 200);"" onmouseout=""clearTimeout(ttDelay);hideTooltip();"">Tix & Info</A></FONT></TD></TR>" & vbCrLf
                
                Else
				
				    Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD>&nbsp;&nbsp;</TD><TD><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=""" & Link & OrganizationString & "&Tooltip=N"">" & rsEvents("Act") & "</A></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left NOWRAP><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1>" & DisplayDate & "</FONT></TD><TD>&nbsp;&nbsp;</TD><TD>&nbsp;&nbsp;</TD><TD><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=""" & Link & OrganizationString & "&Tooltip=N"">Tix & Info</A></FONT></TD></TR>" & vbCrLf
                
                End If
                				    
			End If
			
			LastActCode = rsEvents("ActCode")
			events="Y"
			EventCount = 0

			rsDates.Close
			Set rsDates = nothing

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
    
    <%

End If

rsEvents.Close
Set rsEvents = nothing


'============================================================

'Off Sale Message

If SubscriptionEventsOnSale = "N"  Then 'There weren't any events on sale.  Display no events message.

	'SQLNoEventsMessage = "SELECT OptionValue AS NoEventsMessage FROM VenueOptions (NOLOCK) WHERE VenueCode = " & iVenueCode & " AND OptionName = 'NoEventsMessage'"
	'Set rsNoEventsMessage = OBJdbConnection.Execute(SQLNoEventsMessage)
	  
	'If Not rsNoEventsMessage.EOF Then 'Use the Message in Venue Options
	'	NoEventsMessage = rsNoEventsMessage("NoEventsMessage")
	'Else
	'	NoEventsMessage = "There are no one events on sale at this time. Please check back again."
	'End If

	'rsNoEventsMessage.Close
	'Set rsNoEventsMessage = nothing
	
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

<%


