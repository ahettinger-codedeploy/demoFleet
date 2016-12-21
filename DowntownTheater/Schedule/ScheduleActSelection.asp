<!--#INCLUDE virtual="PrivateLabelInclude.asp" -->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->

<%

TooltipIncludeFlag = "Y"
Page = "Schedule"

'============================================================

'-----------------------------------

'Act Selection Variables

ActSelection = "Y"
ActSelectionTitle = "Act Selection"
ActSortOrder = "ACTDATE"

'Sort Order Choices
'Act - Order by Act Name
'ActDate - Order by Act Date
'Category - Order by Category
'SubCategory - Order by SubCategory
'SubCatDate - Order by SubCategory And Date

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

'ACT SELECTION - EVENT LIST

ActSelectionOnSale = "N"

If ActSelection = "Y" Then

SQLWhere = " WHERE Event.EventDate >= '" & FormatDateTime(Now(), vbShortDate) & "'"

If IsDate(Clean(Request("StartDate"))) Then
	SQLWhere = SQLWhere & " AND Event.EventDate >= '" & CDate(Clean(Request("StartDate"))) & "'"
End If

If IsDate(Clean(Request("EndDate"))) Then
	SQLWhere = SQLWhere & " AND Event.EventDate < '" & CDate(Clean(Request("EndDate"))) + 1 & "'"
End If

'Exclude the Special Events from this list
'SQLWhere = SQLWhere & " AND Event.EventCode NOT IN (" & SpecialEventsList(1)& ")"

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

	ActSelectionOnSale = "Y"

%>
        <br />
        <br />              
        <table id="rounded-corner" summary="act listing">
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
                
                %>
		        
		        <tr>
                    <td  class="data-left">&nbsp;</th>
                    <td  class="data-left"><A HREF=<%= Link & OrganizationString %> id="ProductionInfoLink_<%= rsEvents("ActCode") %>" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/ProductionInfo.asp?ActCode=<%= rsEvents("ActCode") %>\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();"><%= rsEvents("Act") %></A></td>
                    <td  class="data-left"><%= MonthName(Month(rsDates("StartDate")), true) %> <%= Day(rsDates("StartDate")) %> ~ <%= MonthName(Month(rsDates("EndDate")), true) %> <%= Day(rsDates("EndDate")) %></th>
                    <td  class="data-left"><A HREF=<%= Link & OrganizationString %> id="TixInfoLink_<%= rsEvents("ActCode") %>" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/ProductionInfo.asp?ActCode=<%= rsEvents("ActCode") %>\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();">Tix & Info</A></td>
                    <td  class="data-left">&nbsp;</th>
                </tr> 
                <tr>
                    <td colspan="5"><hr /></td>
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
                    <td  class="data-left"><A HREF=<%= Link & OrganizationString %> id="A1" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/ProductionInfo.asp?ActCode=<%= rsEvents("ActCode") %>\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();"><%= rsEvents("Act") %></A></td>
                    <td  class="data-left"><%= MonthName(Month(rsDates("StartDate")), true) %> <%= Day(rsDates("StartDate")) %></td>
                    <td  class="data-left"><A HREF=<%= Link & OrganizationString %> id="A2" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/ProductionInfo.asp?ActCode=<%= rsEvents("ActCode") %>\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();">Tix & Info</A></td>
                    <td  class="data-left">&nbsp;</td>
                </tr> 
                <tr>
                    <td colspan="5"><hr /></td>
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
    
    <%

End If

rsEvents.Close
Set rsEvents = nothing

OBJdbConnection.Close
Set OBJdbConnection = nothing

End If

'============================================================

'OFF SALE MESSAGE

If ActSelectionOnSale = "N"  Then 'There weren't any events on sale.  

		NoEventsMessage = "There are no one events on sale at this time. Please check back again."
		
    %>
    
    <table>    
    <tr>
        <td> There are no events on sale at this time. Please check back again </td>
    </tr> 
    </table>  
     
    <%
	  	
End If

'============================================================

%>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>

</html>


