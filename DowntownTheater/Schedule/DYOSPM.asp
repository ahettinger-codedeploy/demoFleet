<%

'CHANGE LOG - Update for Sioux Empire Community Theatre
'SSR (3/7/2012)
'Added Pre-sale code programming
'Added tool-top option
'changed event listing from H3 to a css formated div

'CHANGE LOG - Update
'SSR (2/28/2012)
'Updated css template page  - Rogue Theater

'CHANGE LOG - Update
'SSR (2/27/2012)
'added CSS reset  - Rogue Theater

'CHANGE LOG - Update
'SSR (2/22/2012)
'fixed error 500 issues - Rogue Theater

'CHANGE LOG - Update
'SSR (11/07/2011)
'Updated - Rogue Theater

'CHANGE LOG - Update
'SSR (10/06/2011)
'Updated - Rogue Theater

'CHANGE LOG - Inception
'SSR (9/07/2011)
'Custom Design Your Own Schedule Page - Rogue Theater

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->

<%

Page = "Schedule"

'============================================================

'TOOLTIP
'Display the tooltip
'When this option is active, the event details will display in a popup
'Default is "Y"

TooltipIncludeFlag = "Y"

'-----------------------------------

'SEASON SUBSCRIPTIONS
'Display the subscription events
'When this option is active the subscription events are not displayed in "Event Listing" or "Act Selection Listing"
'Default is False

SubscriptionsDisplay = False
SubscriptionVenueLocation = False
SubscriptionEventsTitle = "Season Tickets"

'-----------------------------------

'EVENT LISTING
'Display the individual events
'Listed in date order
'Default is True

EventDisplay = True
EventVenueLocation = True
EventTitle = "Individual Tickets"

'-----------------------------------

'ACT SELECTION LISTING
'Display the events by grouping in act name first
'List can be sorted by act name or by act date
'Default is False

ActSelectionDisplay = True
ActSelectionTitle = ""
ActSelectionSubTitle = "2011-2012 Seasons" 
ActSort = "ActDate"

'-----------------------------------

'SPECIAL EVENTS LIST
'Display these special events apart from the other events
'When this option is active, the special events are not displayed in "Event Listing" or "Act Selection Listing"
'Default is False

SpecialEventDisplay = False
SpecialEventVenueLocation = True
SpecialEventDateDisplay = False

SpecialEventTitle = "Season Supscription Options"
SpecialEventSubTitle = "2011-2012 Seasons"
SpecialEventList= "366511,366513,366537,366510,367066,378313,367063,367065,367064,367067,364333"  

'-----------------------------------

'DONATION / MEMBERSHIP
'Display the donation page after all the other events
'Default is False

DonationDisplay = False
DonationEventsTitle = "Donation / Membership"

'-----------------------------------

'OFFSALE MESSAGE
'If there are no events on sale display off sale message
'Default is True

OffSaleMessage = True

'===============================================

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
    NECorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=008400&Src=TopLeftCorner16.txt"
    NWCorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=008400&Src=TopRightCorner16.txt"
    SWCorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=E9E9E9&Src=BottomLeftCorner16.txt"
    SECorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=E9E9E9&Src=BottomRightCorner16.txt"
Else
    NECorner="/clients/tix/images/image.asp?FirstHex=e7e7d7&LastHex=641414&Src=TopLeftCorner16.txt"
    NWCorner="/clients/tix/images/image.asp?FirstHex=e7e7d7&LastHex=641414&Src=TopRightCorner16.txt"
    SWCorner="/clients/tix/images/image.asp?FirstHex=e7e7d7&LastHex=f1f1f1&Src=BottomLeftCorner16.txt"
    SECorner="/clients/tix/images/image.asp?FirstHex=e7e7d7&LastHex=f1f1f1&Src=BottomRightCorner16.txt"
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
/* ----------------------------
CSS Reset
---------------------------- */
html, body, div, span, applet, object, iframe,
h1, h2, h3, h4, h5, h6, p, blockquote, pre,
a, abbr, acronym, address, big, cite, code,
del, dfn, em, img, ins, kbd, q, s, samp,
small, strike, strong, sub, sup, tt, var,
b, u, i, center,
dl, dt, dd, ol, ul, li,
fieldset, form, label, legend,
table, caption, tbody, tfoot, thead, tr, th, td,
article, aside, canvas, details, embed, 
figure, figcaption, footer, header, hgroup, 
menu, nav, output, ruby, section, summary,
time, mark, audio, video {
margin: 0;
padding: 0;
border: 0;
font-size: 100%;
font: inherit;
vertical-align: baseline;
}
/* HTML5 display-role reset for older browsers */
article, aside, details, figcaption, figure, 
footer, header, hgroup, menu, nav, section {
	display: block;
}
body {
	line-height: 1;
}
ol, ul {
	list-style: none;
}
blockquote, q {
	quotes: none;
}
blockquote:before, blockquote:after,
q:before, q:after {
	content: '';
	content: none;
}
table {
	border-collapse: collapse;
	border-spacing: 0;
}
</style>

<style type="text/css">
    
/* ----------------------------
CSS Parameters
---------------------------- */

<style type="text/css">
body
{
    font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
    line-height: 1 em;
}
.title
{
	font-size: 20px;
    font-weight: 550;
	width: 130%;
	text-align: center;
	padding-top: 20px;
	padding-bottom: 5px;
	border: 0px dotted green;
}
#rounded-corner
{
	font-size: 11px;
    font-weight: 400;
	width: 130%;
	text-align: left;
	border-collapse: collapse;
}
#rounded-corner div
{
	font-size: 11px;
    font-weight: 400;
	width: 130%;
	text-align: left;
	border: 2px dotted black;
}
/* upper between corners */
#rounded-corner thead th.category
{
	padding-top: 10px;
    padding-bottom: 10px;
    padding-left: 0px;
    padding-right: 0px;
	font-size: 15px;
	font-weight: 670;
	text-align: left;
	color: <%=TableCategoryFontColor%>;
	background: <%=TableCategoryBGColor%>;
}
/* upper left corner */
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
/* lower between corners */
#rounded-corner td.footer
{
	background: <%=TableDataBGColor%>;
}
/* lower left corner */
#rounded-corner td.footer-left
{
    background: <%=TableDataBGColor%> url('<%=SWCorner%>') left bottom no-repeat;
}
#rounded-corner td.footer-right
{
	background: <%=TableDataBGColor%> url('<%=SECorner%>') right bottom no-repeat;
}
/* main body */
#rounded-corner td.data
{
	padding-top: 4px;
    padding-bottom: 2px;
    padding-left: 2px;
    padding-right: 2px;
    font-size: 11px;
    font-weight: 400;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
	text-align: center;
}
#rounded-corner td.data-left
{
	padding-top: 10px;
    padding-bottom: 0px;
    padding-left: 2px;
    padding-right: 20px;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
	text-align: left;
}
/* horizontal rule */
#rounded-corner hr 
{
    height:1px;
    width: 100%;
    background:#<%=TableCategoryBGColor%>;
    margin: 0px 0px 0px 0px;  
}
/* link */
#rounded-corner a:
{
text-decoration: none;
color: #<%=TableCategoryBGColor%>;
font-size: 11px;
font-weight: 400;
} 
/* unvisited link */
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
/* submitt button*/
.formbutton
{
cursor: pointer;
border: outset 1px #ccc;
background: #e1e1e1;
color: #666;
font-weight: bold;
padding: 1px 10px;
} 
hr 
{
 /* color for IE */   
  color:#010101;
 /* color for FireFox */ 
  background-color:#010101;
  height:1px;
  border:none;

}
H5
{
font-size: 20px;
font-weight: 600px;
color: <%=TableCategoryBGColor%>;
padding-top: 20px;
padding-bottom: 10px;
margin-top: 0px;
}
</style>


</head>

<%=strBody %>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<BR />
<div class="title"><%=ScheduleTitle%></div>
<BR />
<BR />
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

If Session("MemberID") = "" Then 'No member logged in


%>

        <table id="rounded-corner" summary="presale">
        <thead>
        <tr>
            <th scope="col" class="category-left">&nbsp;</th>
            <th scope="col" class="category">Pre-Sales<FONT FACE=" & FontFace & " COLOR=RED SIZE=1><B><%=Message%></B></FONT></th>
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

'============================================================

'SEASON SUBSCRIPTIONS

If SubscriptionsDisplay Then

    SubscriptionEventsOnSale = "False"

    SQLWhere = "WHERE Event.EventDate >= '" & FormatDateTime(Now(), vbShortDate) & "'"

    If IsDate(Clean(Request("StartDate"))) Then
	    SQLWhere = SQLWhere & " AND Event.EventDate >= '" & CDate(Clean(Request("StartDate"))) & "'"
    End If

    If IsDate(Clean(Request("EndDate"))) Then
	    SQLWhere = SQLWhere & " AND Event.EventDate < '" & CDate(Clean(Request("EndDate"))) + 1 & "'"
    End If

    If Request("OrganizationNumber") <> "" Then SQLWhere = SQLWhere & " AND OrganizationAct.OrganizationNumber = '" & Clean(Request("OrganizationNumber")) & "' AND OrganizationVenue.OrganizationNumber = '" & Clean(Request("OrganizationNumber")) & "'"


    SQLEvents = "SELECT DISTINCT EventDate, EventCode, Act, City, State, Venue From Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Category (NOLOCK) ON Act.CategoryCode = Category.CategoryCode INNER JOIN SubCategory (NOLOCK) ON Act.SubCategoryCode = SubCategory.SubCategoryCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode " & SQLWhere & "AND Event.OnSale = 1 AND Event.SaleStartDate <= '" & Now() &  "' AND Event.EventType = 'SubFixedEvent' ORDER BY Event.EventDate, Act.Act"
    Set rsEvents = OBJdbConnection.Execute(SQLEvents)

    If Not rsEvents.EOF Then

        SubscriptionEventsOnSale = "True"

	
        'Header column names
        '-------------------
	    If SubscriptionVenueLocation  Then
            %>                
            <div class="title"><%= SubscriptionEventsTitle %></div> 
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
            <div class="title"><%= SubscriptionEventsTitle %></div>  
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
	
	    'Generate list of subscription eventcodes to exclude in ind event listing
	    '-----------------------------------------------------------------------
	    SubscriptionEventList = SubscriptionEventList &  rsEvents("EventCode") & ","  
	
        strDate = FormatDateTime(rsEvents("EventDate"),vbShortDate)
        strWeekDay = WeekdayName(Weekday(rsEvents("EventDate")), True) & "."
        strTime = Left(FormatDateTime(rsEvents("EventDate"),vbLongTime),Len(FormatDateTime(rsEvents("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsEvents("EventDate"),vbLongTime),3)


        'Determine if event has an act suffix
        '------------------------------------
        SQLActSuffix = "SELECT OptionValue AS ActSuffix FROM EventOptions (NOLOCK) WHERE EventCode = " & rsEvents("EventCode") & " AND OptionName = 'ActSuffix'"
        Set rsActSuffix = OBJdbConnection.Execute(SQLActSuffix)

            If Not rsActSuffix.EOF Then 'Use it
            ActSuffix = " - " & rsActSuffix("ActSuffix")
            Else
            ActSuffix = ""
            End If

        rsActSuffix.Close
        Set rsActSuffix = nothing


        'Determine if event has date suppress
        '------------------------------------

        DisplayDate = ""

        SQLDateSuppress = "SELECT OptionValue AS DateSuppress FROM EventOptions (NOLOCK) WHERE EventCode = " & rsEvents("EventCode") & " AND OptionName = 'DateSuppress' AND OptionValue = 'Y'"
        Set rsDateSuppress = OBJdbConnection.Execute(SQLDateSuppress)
        If rsDateSuppress.EOF Then
	        DisplayDate = DisplayDate & strWeekDay & "&nbsp;" & strDate
        End If
        rsDateSuppress.Close
        Set rsDateSuppress = nothing


        'Determine if event has time suppress
        '------------------------------------

        SQLTimeSuppress = "SELECT OptionValue AS TimeSuppress FROM EventOptions (NOLOCK) WHERE EventCode = " & rsEvents("EventCode") & " AND OptionName = 'TimeSuppress' AND OptionValue = 'Y'"
        Set rsTimeSuppress = OBJdbConnection.Execute(SQLTimeSuppress)
        If rsTimeSuppress.EOF Then
	        DisplayDate = DisplayDate & "<BR>at " & strTime
        End If
        rsTimeSuppress.Close
        Set rsTimeSuppress = nothing
        

	    'Display the subscription events
        '--------------------------------

        If SubscriptionVenueLocation  Then
	        %>
            <tr>
                <td class="data-left"><A HREF=/Event.asp?Event="<%= rsEvents("EventCode") %>" id="EventLink_"<%= rsEvents("EventCode") %>" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode="<%= rsEvents("EventCode") %>"\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();"><%= rsEvents("Act") & ActSuffix %></td>
            
                    <% If rsEvents("City") <> "" Then %>                
                        <td class="data">
                        <%= rsEvents("Venue") %><BR>
                        <%= rsEvents("City") %>,&nbsp;<%= rsEvents("State") %>
                        </td>
                    <% Else %>  
                        <td class="data">
                        <%= rsEvents("Venue") %>
                        </td>
                    <% End If %>  
            
                <td class="data" colspan="3"><A class="data" HREF=/Event.asp?Event="<%= rsEvents("EventCode") %>" id="TixInfoLink_"<%= rsEvents("EventCode") %>" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode="<%= rsEvents("EventCode") %>"\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();">Tix & Info</A></td>
            </tr>
            <tr>
                <td class="data" colspan="5"><hr></td>
            </tr>            
            <%
        Else
	        %>
            <tr>
                <td class="data-left">&nbsp;</td>
                <td class="data" colspan="2"><A HREF=/Event.asp?Event="<%= rsEvents("EventCode") %>" id="EventLink_"<%= rsEvents("EventCode") %>" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode="<%= rsEvents("EventCode") %>"\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();"><%= rsEvents("Act") & ActSuffix %></td>            
                <td class="data" colspan="2"><A HREF=/Event.asp?Event="<%= rsEvents("EventCode") %>" id="TixInfoLink_"<%= rsEvents("EventCode") %>" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode="<%= rsEvents("EventCode") %>"\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();">Tix & Info</A></td>
            </tr>
            <tr>
                <td class="data" colspan="5"><hr></td>
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
	<%
	
    End If

    'Finalize the Subscription Event List
    '-------------------------------------
    If Right(SubscriptionEventList,1) = "," Then
        X = Len(SubscriptionEventList)
        SubscriptionEventList = Left(SubscriptionEventList,(X-1))
    End If

     rsEvents.Close
    Set rsEvents = nothing


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
        If SubscriptionEventList <> "" Then
            SQLWhere = SQLWhere & " AND Event.EventCode NOT IN (" & SubscriptionEventList & ")"
        End If
    End If


    'Exclude the Special Events from this list
    '-----------------------------------------------
    If SpecialEventDisplay Then
        If SpecialEventList <> "" Then
            SQLWhere = SQLWhere & " AND Event.EventCode NOT IN (" & SpecialEventList & ")"
        End If
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
        <div class="title"><%= EventTitle %></div> 
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
        <H5<%= EventTitle %></div>  
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
	            <td  class="data-left"><A HREF=/Event.asp?Event=<%= rsEvents("EventCode") %> id="EventLink_<%= rsEvents("EventCode") %>" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode=<%= rsEvents("EventCode") %>\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();"><%= rsEvents("Act") & ActSuffix %></A></td>
	            
	            <% If rsEvents("City") <> "" Then %>                
                    <td class="data-left"><%= rsEvents("Venue") %><BR><%= rsEvents("City") %>,&nbsp;<%= rsEvents("State") %></td>
                <% Else %>  
                    <td class="data-left"><%= rsEvents("Venue") %></td><% End If %>     	            
	              
	            <td class="data-left"><A HREF=/Event.asp?Event="<%= rsEvents("EventCode") %>" id="TixInfoLink_"<%= rsEvents("EventCode") %>" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode="<%= rsEvents("EventCode") %>"\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();">Tix & Info</A></td>
                <td class="data-right">&nbsp;</td>
            </tr> 
            <tr>
                <td class="data-left" colspan="<%= ColNbr %>"><hr></td>
            </tr>            
          <%
	    Else
	      %>
	        <tr>
	            <td class="data-left">&nbsp;</td>
	        	<td class="data-left"><%= DisplayDate %></td>
	            <td class="data-left"><A HREF=/Event.asp?Event=<%= rsEvents("EventCode") %> id="EventLink_<%= rsEvents("EventCode") %>" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode=<%= rsEvents("EventCode") %>\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();"><%= rsEvents("Act") & ActSuffix %></A></td>   	                 
	            <td class="data-left"><A HREF=/Event.asp?Event="<%= rsEvents("EventCode") %>" id="TixInfoLink_"<%= rsEvents("EventCode") %>" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode="<%= rsEvents("EventCode") %>"\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();">Tix & Info</A></td>
                <td class="data-right">&nbsp;</td>
            </tr> 
            <tr>
                <td class="data-left" colspan="<%= ColNbr %>"><hr></td>
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
	    <%
	
	
rsEvents.Close
Set rsEvents = Nothing

End If

'======================================

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
	
	 If SpecialEventVenueLocation Then	
	    
	        If SpecialEventDateDisplay Then

	            'Show Venue / Show Date 
                %>            
                <div class="title"><%= SpecialEventTitle %></div> 
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
            
                'Show Venue / No Date 
                %>                
                <div class="title"><%= SpecialEventTitle %></div> 
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
            
                'No Venue / Show Date
                %>               
                <div class="title"><%= SpecialEventTitle %></div> 
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
            
                'No Venue / No Date
                %>            
                <div class="title"><%= SpecialEventTitle %></div> 
                <table id="rounded-corner" summary="special events header">
                <thead>
                <tr>
                    <% ColNbr = 4 %>
                    <% FootColNbr = 2 %>
                    <th scope="col" class="category-left">&nbsp;</th>
                    <th scope="col" class="category">Event</th>
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
	    
	            'Show Venue / Show Date
                If SpecialEventDateDisplay Then
	                  %>
	                    <tr>
	                        <td  class="data">&nbsp;</td>
	        	            <td  class="data"><%= DisplayDate %></td>
	                        <td  class="data"><A HREF=/Event.asp?Event="<%= rsEvents("EventCode") %>"  id="EventLink_<%= rsEvents("EventCode")%>" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode=<%= rsEvents("EventCode") %>\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();"><%= rsEvents("Act") & ActSuffix %></A></td>
        	            
	                        <% If rsEvents("City") <> "" Then %>                
                                <td class="data"><%= rsEvents("Venue") %><BR><%= rsEvents("City") %>,&nbsp;<%= rsEvents("State")%></td>
                            <% Else %>  
                                <td class="data"><%= rsEvents("Venue") %></td><% End If %>     	            
        	              
	                        <td class="data"><A HREF=/Event.asp?Event="<%= rsEvents("EventCode") %>" id="A1"<%= rsEvents("EventCode")%>" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode="<%= rsEvents("EventCode") %>"\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();">Tix & Info</A></td>
                            <td  class="data">&nbsp;</td>
                        </tr> 
                        <tr>
                            <td class="data" colspan="<%= ColNbr %>"><hr /></td>
                        </tr>            
                      <%
                
               'Show Venue / No Date
                Else
            	      %>
	                    <tr>
	                        <td  class="data">&nbsp;</td>
	                        <td  class="data-left"><A HREF=/Event.asp?Event="<%= rsEvents("EventCode") %>"  id="A5" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode=<%= rsEvents("EventCode") %>\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();"><%= rsEvents("Act") & ActSuffix %></A></td>
        	            
	                        <% If rsEvents("City") <> "" Then %>                
                                <td class="data-left"><%= rsEvents("Venue") %><BR><%= rsEvents("City") %>,&nbsp;<%= rsEvents("State")%></td>
                            <% Else %>  
                                <td class="data"><%= rsEvents("Venue") %></td><% End If %>     	            
        	              
	                        <td class="data-left"><A HREF=/Event.asp?Event="<%= rsEvents("EventCode") %>" id="A6"<%= rsEvents("EventCode")%>" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode="<%= rsEvents("EventCode") %>"\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();">Tix & Info</A></td>
                            <td  class="data">&nbsp;</td>
                        </tr> 
                        <tr>
                            <td class="data" colspan="<%= ColNbr %>" ><hr /></td>
                        </tr>            
                      <%
                End If
	    Else

	            'No Venue / Show Date
                If SpecialEventDateDisplay Then
	                  %>
	                    <tr>
	                        <td  class="data-left">&nbsp;</td>
	        	            <td  class="data"><%= DisplayDate %></td>
	                        <td  class="data"><A HREF=/Event.asp?Event="<%= rsEvents("EventCode") %>"  id="EventLink_<%= rsEvents("EventCode")%>" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode=<%= rsEvents("EventCode") %>\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();"><%= rsEvents("Act") & ActSuffix %></A></td>
	                        <td class="data"><A HREF=/Event.asp?Event="<%= rsEvents("EventCode") %>" id="A1"<%= rsEvents("EventCode")%>" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode="<%= rsEvents("EventCode") %>"\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();">Tix & Info</A></td>
                            <td  class="data-right">&nbsp;</td>
                        </tr> 
                        <tr>
                            <td class="data" colspan="<%= ColNbr %>"><hr /></td>
                        </tr>            
                      <%
                
                'No Venue / No Date
                Else
            	      %>
	                    <tr>
	                        <td  class="data-left">&nbsp;</td>
	                        <td  class="data"><A HREF=/Event.asp?Event="<%= rsEvents("EventCode") %>"  id="A5" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode=<%= rsEvents("EventCode") %>\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();"><%= rsEvents("Act") & ActSuffix %></A></td>
	                        <td class="data"><A HREF=/Event.asp?Event="<%= rsEvents("EventCode") %>" id="A6"<%= rsEvents("EventCode")%>" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode="<%= rsEvents("EventCode") %>"\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();">Tix & Info</A></td>
                            <td  class="data-right">&nbsp;</td>
                        </tr> 
                        <tr>
                            <td class="data" colspan="<%= ColNbr %>" ><hr /></td>
                        </tr>            
                      <%
                End If




          
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
	    <%
	
	    End If
	
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
    If SubscriptionEventList <> "" Then
        SQLWhere = SQLWhere & " AND Event.EventCode NOT IN (" & SubscriptionEventList & ")"
    End If
End If


'Exclude the Special Events from this list
'-----------------------------------------------
If SpecialEventDisplay Then
    If SpecialEventList <> "" Then
        SQLWhere = SQLWhere & " AND Event.EventCode NOT IN (" & SpecialEventList & ")"
    End If
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
        <div class="title"><%= ActSelectionTitle %></div> 

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
                    <td  class="data">&nbsp;</th>
                    <td  class="data-left"><A HREF=<%= Link & OrganizationString %> id="ProductionInfoLink_<%= rsEvents("ActCode") %>" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/ProductionInfo.asp?ActCode=<%= rsEvents("ActCode") %>\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();"><%= rsEvents("Act") %></A></td>
                    <td  class="data-left"><%= MonthName(Month(rsDates("StartDate")), true) %>&nbsp;&nbsp;<%= Day(rsDates("StartDate")) %>&nbsp;&#151;&nbsp;<%= MonthName(Month(rsDates("EndDate")), true) %>&nbsp;<%= Day(rsDates("EndDate")) %></th>
                    <td  class="data-left"><A HREF=<%= Link & OrganizationString %> id="TixInfoLink_<%= rsEvents("ActCode") %>" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/ProductionInfo.asp?ActCode=<%= rsEvents("ActCode") %>\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();">Tix & Info</A></td>
                    <td  class="data">&nbsp;</th>
                </tr> 
                <tr>
                    <td class="data" colspan="5"><hr></td>
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
		        
		        <tr>
                    <td  class="data">&nbsp;</td>
                    <td  class="data-left"><A HREF=<%= Link & OrganizationString %> id="A3" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/ProductionInfo.asp?ActCode=<%= rsEvents("ActCode") %>\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();"><%= rsEvents("Act") %></A></td>
                    <td  class="data-left"><%= MonthName(Month(rsDates("StartDate")), true) %> <%= Day(rsDates("StartDate")) %></td>
                    <td  class="data-left"><A HREF=<%= Link & OrganizationString %> id="A4" onmouseover="ttDelay=setTimeout('eventTooltip(\'/AJAX/ProductionInfo.asp?ActCode=<%= rsEvents("ActCode") %>\', this)', 200);" onmouseout="clearTimeout(ttDelay);hideTooltip();">Tix & Info</A></td>
                    <td  class="data">&nbsp;</td>
                </tr> 
                <tr>
                    <td class="data" colspan="5"><hr></td>
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
    <br />
    <%

End If

rsEvents.Close
Set rsEvents = nothing

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
            <div class="title"><%=DonationEventsTitle%></div> 
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
                <td class="data-left">&nbsp;</td>
                <td class="data"><a href="/donation.asp?organizationnumber=<%=DonationOrganizationNumber%>"><%=DonationOrganizationName%>&nbsp;Donation/Membership</a></td>
                 <td class="data"><a href="/donation.asp?organizationnumber=<%=DonationOrganizationNumber%>">Info</a></td>
                <td class="data-right">&nbsp;</td>
            </tr> 
            <tr>
                <td class="data-left" colspan="4"><hr></td>
            </tr> 
            <tbody>  
            <tr>
                <td class="footer-left">&nbsp;</td>
                <td  class="footer" colspan="2">&nbsp;</td>
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




