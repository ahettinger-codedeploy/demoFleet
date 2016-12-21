<%

'CHANGE LOG - Inception
'SSR 8/23/2011
'Custom Schedule Page

%>

<!--#INCLUDE virtual="PrivateLabelInclude.asp" -->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->

<%

'============================================================

Page = "Schedule"
TooltipIncludeFlag = "Y"

'============================================================

'Duke City Repertory Theatre (8/23/2011)
'Special Events + Act Selection (with PreSale) Schedule Page

'Special Events Listing #1 
'---------------------------
'397495   Single Subscription Package  
'397496   3 for $48 Flex Package 
'397499   2 for $32 Flex Package  
'397507   Senior/Military Subscription Package  
'397508   Student Subscription Package  
'397515   DCRT Duet Subscription Package 


SpecialEventCount = 1

Dim SpecialEventsTitle(1)
Dim SpecialEventSubTitle(1)
Dim SpecialEventsList(1)
Dim SpecialEventsOnSale(1)

SpecialEventsTitle(1) = "Season Subscription Packages"
SpecialEventSubTitle(1) = "2011-2012 Season"
SpecialEventsList(1)= "397495,397496,397499,397507,397508,397515" 
SpecialEventsOnSale(1) = "N"


'Act Listing  
'---------------------------
ActSelectionTitle = "Act Selection"
ActSelectionSubTitle = "2011-2012 Season" 
ActSelectionOnSale = "N"

'============================================================

'CSS Survey Variables

If Session("UserNumber")<> "" Then
    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "FFFFFF"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "000000"
    TableDataBGColor = "E9E9E9"
    'LastHex = box color
    'FirstHex = background color
    NECorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=008400&Src=TopLeftCorner16.txt"
    NWCorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=008400&Src=TopRightCorner16.txt"
    SWCorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=E9E9E9&Src=BottomLeftCorner16.txt"
    SECorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=E9E9E9&Src=BottomRightCorner16.txt"
Else
    'LastHex = box color
    'FirstHex = background color
    NECorner="/clients/tix/images/image.asp?FirstHex=231F20&LastHex=DC7926&Src=TopLeftCorner16.txt"
    NWCorner="/clients/tix/images/image.asp?FirstHex=231F20&LastHex=DC7926&Src=TopRightCorner16.txt"
    SWCorner="/clients/tix/images/image.asp?FirstHex=231F20&LastHex=F1F1F1&Src=BottomLeftCorner16.txt"
    SECorner="/clients/tix/images/image.asp?FirstHex=231F20&LastHex=F1F1F1&Src=BottomRightCorner16.txt"
End If

'============================================================

%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<TITLE><%= Title %></TITLE>

<%= strBody %>

<style type="text/css">
    
body
{
    font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
}
#rounded-corner
{
	font-size: 11px;
    font-weight: 400;
	width: 80%;
	text-align: left;
	border-collapse: collapse;
}
#rounded-corner thead th.category
{
    padding-top: 10px;
    padding-left: 10px;
	font-size: 15px;
	font-weight: 600;
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

    background: <%=TableDataBGColor%> url('<%=SWCorner%>') left bottom  no-repeat;
}
#rounded-corner td.footer-right
{
    background: <%=TableDataBGColor%> url('<%=SECorner%>') right bottom  no-repeat;
}
#rounded-corner td.data
{
    text-align: center;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-left
{
    padding-left: 10px;
    text-align: left;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-right
{
    padding-left: 10px;
    padding-right: 10px;
    text-align: left;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}

</style>

</head>

<%= strBody %>

<!--#INCLUDE virtual="TopNavInclude.asp" -->

<%

'============================================================

'Pre-Sale Code Check

QueryString = Request.ServerVariables("QUERY_STRING") 
If QueryString <> "" Then
	QueryString = "?" & QueryString
End If

'Determine that MemberID was sent, check validity and login if appropriate
If Clean(Request("MemberID")) <> "" Then
	MemberID = Clean(Request("MemberID"))
	MemberPassword = Clean(Request("MemberPassword"))
	SQLLogin = "SELECT MemberID, MemberPassword, MemberType FROM Members (NOLOCK) WHERE OrganizationNumber = '" & CleanNumeric(Request("OrganizationNumber")) & "' AND MemberID = '" & MemberID & "' AND MemberPassword = '" & MemberID & "'"
	Set rsLogin = OBJdbConnection.Execute(SQLLogin)
	If Not rsLogin.EOF Then
		Session("MemberID") = rsLogin("MemberID")
		Session("MemberType") = rsLogin("MemberType")
		Session("MemberOrganizationNumber") = CleanNumeric(Request("OrganizationNumber"))
	Else
		Message = "Invalid Code"
	End If
	rsLogin.Close
	Set rsLogin = nothing
End If		

If Clean(Request("FormName")) <> "" Then 
	FormName = Clean(Request("FormName"))
End If

If FormName = "Logout" Then
    Session.Contents.Remove("MemberID")
    Session.Contents.Remove("MemberType")
    Session.Contents.Remove("MemberOrganizationNumber")
    Call DBClose(OBJdbConnection)
    Response.Redirect("SpecialEventActSelection.asp" & QueryString)
End If

If Session("MemberOrganizationNumber") <> "" Then
    OrganizationString = "&OrganizationNumber=" & Session("MemberOrganizationNumber")
End If

PreSaleActive = FALSE

SQLPreSale = "SELECT Event.EventCode From Event (NOLOCK) INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode LEFT JOIN MemberSaleStartDate (NOLOCK) ON Event.EventCode = MemberSaleStartDate.EventCode WHERE Event.OnSale = 1 AND OrganizationAct.OrganizationNumber = '" & CleanNumeric(Request("OrganizationNumber")) & "' AND OrganizationVenue.OrganizationNumber = '" & CleanNumeric(Request("OrganizationNumber")) & "' AND MemberSaleStartDate.OrganizationNumber = '" & CleanNumeric(Request("OrganizationNumber")) & "' AND IsNull(MemberSaleStartDate.MemberSaleEndDate, DATEADD(DAY, 1, GETDATE())) > '" & Now() & "' AND SaleStartDate > '" & Now() & "'"
Set rsPreSale = OBJdbConnection.Execute(SQLPreSale)
If Not rsPreSale.EOF Then 'There are active pre-sale events, so display pre-sale box if not logged in
    PreSaleActive = TRUE
End If
rsPreSale.Close
Set rsPreSale = Nothing

If PreSaleActive = TRUE Then

        If Session("MemberID") = "" Then 'No member logged in


        %>
                <table id="rounded-corner" summary="presale">
                <thead>
                <tr>
                    <th scope="col" class="category-left">&nbsp;</th>
                    <th scope="col" class="category">Pre-Sales<FONT FACE=" & FontFace & " COLOR=RED SIZE=1><B><%=Message%>&nbsp;&nbsp;&nbsp;</B></FONT></th>
                    <th scope="col" class="category-right">&nbsp;</th>
                </tr>       
                </thead>
                <tbody>
                <tr>
                    <td class="data" colspan="3">
                    <FORM ACTION=SpecialEventActSelection.asp<%=QueryString%> METHOD="post" id=form1 name=form1>Enter Pre-Sale Code (optional):&nbsp;<INPUT TYPE="text" NAME="MemberID" SIZE="10">&nbsp;&nbsp;<INPUT TYPE="submit" class="formbutton" VALUE="Enter"></
                    </td> 
                </tr>
                <tr>
                    <td class="data" colspan="3">
                    Upon entering a valid pre-sale code, the pre-sale events will appear below.<br />  
                    </td>
                </tr>
                <tr>
                    <td class="footer-left">&nbsp;</td>
                    <td class="footer">&nbsp;</td>
                    <td class="footer-right">&nbsp;</td>
                </tr> 
                </table>
        <%
            
        Else 'Member currently logged in


        %>
                <table id="rounded-corner" summary="presale">
                <thead>
                <tr>
                    <th scope="col" class="category-left">&nbsp;</th>
                    <th scope="col" class="category">Pre-Sales</th>
                    <th scope="col" class="category-right">&nbsp;</th>
                </tr>       
                </thead>
                <tbody>
                <tr>
                    <td class="data" colspan="3">
                    <FORM ACTION=SpecialEventActSelection.asp<%=QueryString%> METHOD="post" Name=Logout><INPUT TYPE=hidden NAME=FormName VALUE=Logout>
                    </td> 
                </tr>
                <tr>
                    <td class="data" colspan="3">
                    You are currently logged in as Member ID: <B><%=Session("MemberID")%></B><BR>Appropriate pre-sale events will appear below.<BR>
                    <BR><INPUT TYPE="submit" class="formbutton" VALUE="Logout">           
                    </td>
                </tr>
                <tr>
                    <td class="footer-left">&nbsp;</td>
                    <td class="footer">&nbsp;</td>
                    <td class="footer-right">&nbsp;</td>
                </tr> 
                </table>
        <%
            
        End If

End If

'============================================================

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

        SQLQuery = "SELECT DISTINCT EventDate, EventCode, Act, City, State, Venue From Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Category (NOLOCK) ON Act.CategoryCode = Category.CategoryCode INNER JOIN SubCategory (NOLOCK) ON Act.SubCategoryCode = SubCategory.SubCategoryCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode " & SQLWhere & " AND Event.OnSale = 1 AND Event.SaleStartDate <= '" & Now() &  "' AND (Event.EventType <> 'SubFixedEvent' OR Event.EventType IS NULL) AND Event.EventCode IN (" & SpecialEventsList(i) & ") ORDER BY Event.EventDate, Act.Act"

        Set rsEvents = OBJdbConnection.Execute(SQLQuery)

        If Not rsEvents.EOF Then

        SpecialEventsOnSale(i) = "Y"

        %>                
        <br />   
        <br />   
        <table id="rounded-corner" summary="special events">
        <thead>
        <tr>
            <th scope="col" class="category-left">&nbsp;</th>
            <th scope="col" class="category">Season Subscription Options</th>
            <th scope="col" class="category">Venue/Location</th>
            <th scope="col" class="category">Tickets</th>
            <th scope="col" class="category-right">&nbsp;</th>
        </tr>        
        </thead>
        <tbody>                
        <%        	
        Do While Not rsEvents.EOF
    	
            strDate = FormatDateTime(rsEvents("EventDate"),vbShortDate)
            strWeekDay = WeekdayName(Weekday(rsEvents("EventDate")), True) & "."
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
            
            %>
            
             <!-- Data -->
             
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
                    <%= rsEvents("Venue") %><BR>
                    <%= rsEvents("City") %>&nbsp;<%= rsEvents("State") %>
                    </td>
                <% End If %>  
                
                <td class="data-left"><A HREF=/Event.asp?Event="<%= rsEvents("EventCode") %>" id="TixInfoLink_"<%= rsEvents("EventCode") %>"" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode="<%= rsEvents("EventCode") %>"\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();">Tix & Info</A>&nbsp;</td>
                <td class="data-left">&nbsp;</td>
            </tr>
            <tr>
                <td class="data-left" colspan="6"><hr /></td>
            </tr>            
            <%
	
	        Events="Y"
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
            Set rsEvents = Nothing
        
 Next
        

'============================================================

'EVENTS BY ACT - Determine if any other events can be listed

SQLWhere = " WHERE Event.EventDate >= '" & FormatDateTime(Now(), vbShortDate) & "'"

'REE 8/26/3 - Added new Start and End Date Criteria.  This allows dates to be passed in URL.
If IsDate(Clean(Request("StartDate"))) Then
	SQLWhere = SQLWhere & " AND Event.EventDate >= '" & CDate(Clean(Request("StartDate"))) & "'"
End If
If IsDate(Clean(Request("EndDate"))) Then
	SQLWhere = SQLWhere & " AND Event.EventDate < '" & CDate(Clean(Request("EndDate"))) + 1 & "'"
End If

'Exclude the Special Events from this list
SQLWhere = SQLWhere & " AND Event.EventCode NOT IN (" & SpecialEventsList(1)& ")"

If Request("OrganizationNumber") <> "" Then SQLWhere = SQLWhere & " AND OrganizationAct.OrganizationNumber IN (" & CleanNumList(Request("OrganizationNumber")) & ") AND OrganizationVenue.OrganizationNumber IN (" & CleanNumList(Request("OrganizationNumber")) & ")"

If Request("ActCode") <> "" Then SQLWhere = SQLWhere & " AND Event.ActCode = " & CleanNumeric(Request("ActCode"))
If Request("VenueCode") <> "" Then SQLWhere = SQLWhere & " AND Venue.VenueCode = " & CleanNumeric(Request("VenueCode"))
If Request("EventCode") <> "" Then SQLWhere = SQLWhere & " AND Event.EventCode = " & CleanNumeric(Request("EventCode"))

Call DBOpen(OBJdbConnection2)
Call DBOpen(OBJdbConnection3)

SQLQuery = "SELECT Act.ActCode, Act.Act, Event.EventDate, Event.EventCode FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Category (NOLOCK) ON Act.CategoryCode = Category.CategoryCode INNER JOIN SubCategory (NOLOCK) ON Act.SubCategoryCode = SubCategory.SubCategoryCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode LEFT JOIN MemberSaleStartDate (NOLOCK) ON Event.EventCode = MemberSaleStartDate.EventCode " & SQLWhere & " AND Event.OnSale = 1 AND (MemberSaleStartDate.OrganizationNumber = '" & CleanNumeric(Request("OrganizationNumber")) & "' AND MemberSaleStartDate.MemberType = '" & Session("MemberType") & "' AND MemberSaleStartDate.MemberSaleStartDate <= '" & Now() & "' AND IsNull(MemberSaleStartDate.MemberSaleEndDate, DATEADD(DAY, 1, GETDATE())) > '" & Now() & "' OR Event.SaleStartDate <= '" & Now() &  "')"
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
'REE 12/15/6 - Added Venue, Act sort	
Case Else
	SQLQuery = SQLQuery & " ORDER BY Act.Act, Act.ActCode, Event.EventDate"
End Select
Set rsEvents = OBJdbConnection.Execute(SQLQuery)

If Not rsEvents.EOF Then

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
			Set rsDates = OBJdbConnection2.Execute(SQLDates)
			
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
                    <td  class="data-left">&nbsp;</th>
                    <td  class="data-left"><A HREF=<%= Link & OrganizationString %> id="ProductionInfoLink_<%= rsEvents("ActCode") %>" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/ProductionInfo.asp?ActCode=<%= rsEvents("ActCode") %>\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();"><%= rsEvents("Act") %></A></th>
                    <td  class="data-left"><%= MonthName(Month(rsDates("StartDate")), true) %> <%= Day(rsDates("StartDate")) %> ~ <%= MonthName(Month(rsDates("EndDate")), true) %> <%= Day(rsDates("EndDate")) %><br /><br /></th>
                    <td  class="data-left"><A HREF=<%= Link & OrganizationString %> id="TixInfoLink_<%= rsEvents("ActCode") %>" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/ProductionInfo.asp?ActCode=<%= rsEvents("ActCode") %>\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();">Tix & Info</A></th>
                    <td  class="data-left">&nbsp;</th>
                </tr> 
                <tr>
                    <td class="data-left" colspan="6"><hr /></td>
                </tr> 
                
                <% 				
				
				Else
				
				    Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD>&nbsp;&nbsp;</TD><TD><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=""" & Link & OrganizationString & "&Tooltip=N"">" & rsEvents("Act") & "</A></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left NOWRAP><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1>" & MonthName(Month(rsDates("StartDate")), true) & " " & Day(rsDates("StartDate")) & " ~ " & MonthName(Month(rsDates("EndDate")), true) & " " & Day(rsDates("EndDate")) & "</FONT></TD><TD>&nbsp;&nbsp;</TD><TD>&nbsp;&nbsp;</TD><TD><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=""" & Link & OrganizationString & "&Tooltip=N"">Tix & Info</A></FONT></TD></TR>" & vbCrLf
				
				End If
				
			Else 'Display Date
			
				DisplayDate = ""

				'REE 12/10/3 - Modified to look at EventOptions for Date & Time Display Options
				SQLDateSuppress = "SELECT OptionValue AS DateSuppress FROM EventOptions (NOLOCK) WHERE EventCode = " & rsEvents("EventCode") & " AND OptionName = 'DateSuppress' AND OptionValue = 'Y'"
				Set rsDateSuppress = OBJdbConnection3.Execute(SQLDateSuppress)
				If rsDateSuppress.EOF Then
					DisplayDate = MonthName(Month(CDate(rsDates("StartDate")))) & " " & Day(rsDates("StartDate")) & ", " & Year(rsDates("StartDate"))
				End If
				rsDateSuppress.Close
				Set rsDateSuppress = nothing

			    'REE 5/17/10 - Added Flag to Suppress Tooltip
			    
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

Call DBClose(OBJdbConnection3)
Call DBClose(OBJdbConnection2)

OBJdbConnection.Close
Set OBJdbConnection = nothing

Response.Write "<BR><BR>" & vbCrLf

'===================================

'Off Sale Message

If SpecialEventsOnSale(1) = "N" AND ActSelectionOnSale = "N" Then 'There weren't any events on sale.  Display no events message.

	'REE 7/4/3 - Added VenueOption for No Events On Sale Message
	SQLNoEventsMessage = "SELECT OptionValue AS NoEventsMessage FROM VenueOptions (NOLOCK) WHERE VenueCode = " & iVenueCode & " AND OptionName = 'NoEventsMessage'"
	Set rsNoEventsMessage = OBJdbConnection.Execute(SQLNoEventsMessage)
	  
	If Not rsNoEventsMessage.EOF Then 'Use the Message in Venue Options
		NoEventsMessage = rsNoEventsMessage("NoEventsMessage")
	Else
		NoEventsMessage = "There are no one events on sale at this time.  Please check back again."
	End If

	rsNoEventsMessage.Close
	Set rsNoEventsMessage = nothing
	  
	Response.Write "<FONT FACE=" & FontFace & " COLOR=" & FontColor & " SIZE=2><BR>" & NoEventsMessage & "</FONT>"
	
End If



%>

</CENTER>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>
</html>


