<%

'CHANGE LOG - Inception
'SSR (8/30/2011)
'Custom Survey

%>

<!--#include virtual="GlobalInclude.asp"-->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="/include/managementinclude.asp"-->

<%

'============================================================

Page = "Management"
ReportFileName = "ClassRegistrationReport.asp"
SurveyReportNumber = "676"
ReportTitle = "Attendee Report<BR>Survey No 676"

'============================================================

'Adventure Theater Attendee Report

'CSS Survey Variables

    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "FFFFFF"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "000000"
    TableDataBGColor = "E9E9E9"

'============================================================

'Request the form name and process requested action

If Clean(Request("FormName")) = "ReportCriteria" Then
	Call DisplayReport(Request("ReportEventCode"))

ElseIf Clean(Request("FormName")) = "Continue" Then
    Call Continue

Else
    Call SurveyForm
End If


'==========================================================
	
Sub SurveyForm

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
	width: 100%;
	top: 10px;
	line-height: 12px;
	margin-top:  10px;
}
#rounded-corner thead th.category
{
	padding-top: 5px;
    padding-bottom: 5px;
    padding-left: 10px;
    padding-right: 10px;
	font-size: 12px;
	font-weight: 600;
	text-align: center;
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
	text-align: center;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-left
{
	padding-left: 10px;
	padding-right: 10px;
	padding-top: 10px;
	padding-bottom: 10px;
	text-align: left;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-right
{
	padding-left: 10px;
	padding-right: 10px;
	padding-top: 10px;
	padding-bottom: 10px;
    text-align: right;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
</style>
</head>

<body>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<form action="<%= SurveyFileName %>" method="post" name="Survey">
<input type="hidden" name="FormName" value="ReportCriteria">

<H3><%=ReportTitle%></H3></FONT>
	
<% EventListDaysDefault = 30 %>

<fieldset style="width: 600px;" class="reportCriteriaField">

<legend class="reportCriteriaFieldTitle">Event Selection</legend>

<%
   
'Get all events for Organization

'REE 6/30/3 - Added OrganizationOption ReportArchiveDays
'If there's an entry use it.  Otherwise use -31
SQLArchiveDays = "SELECT OptionValue FROM OrganizationOptions (NOLOCK) WHERE OrganizationNumber = " & Session("OrganizationNumber") & " AND OptionName = 'ReportArchiveDays'"
Set rsArchiveDays = OBJdbConnection.Execute(SQLArchiveDays)

If Not rsArchiveDays.EOF Then
	ArchiveDays = rsArchiveDays("OptionValue")
Else
	ArchiveDays = 31
End If

rsArchiveDays.Close
Set rsArchiveDays = nothing

%>

<table id="rounded-corner" summary="surveypage" border="0">
<thead>
    <tr>
	    <th scope="col" class="category-left">&nbsp;</th>
	    <th scope="col" class="category">&nbsp;</th>
	    <th scope="col" class="category">Date/Time</th>
	    <th scope="col" class="category">Production</th>
	    <th scope="col" class="category">Attendee Count</th>
	    <th scope="col" class="category-right">&nbsp;</th>
    </tr>        
</thead>
<tbody>

<%

SQLEvents = "SELECT Event.EventCode, Act, Venue, EventDate, SurveyNumber FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE EventDate > GETDATE()-" & ArchiveDays & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND Event.SurveyNumber = " & SurveyReportNumber & " ORDER BY EventDate, Act"
Set rsEvents = OBJdbConnection.Execute(SQLEvents)

Do Until rsEvents.EOF

    SQLTicketsSold = "SELECT Count(OrderLine.LineNumber) as Count FROM Seat (NOLOCK) INNER JOIN Section (NOLOCK) ON Seat.SectionCode = Section.SectionCode AND Seat.EventCode = Section.EventCode INNER JOIN SeatStatus (NOLOCK) ON Seat.StatusCode = SeatStatus.StatusCode LEFT JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent', 'SubSeat') INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode AND OrganizationVenue.OrganizationNumber = OrganizationAct.OrganizationNumber LEFT JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber LEFT JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode LEFT JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber WHERE Seat.EventCode = " & rsEvents("EventCode") & "  AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND Seat.StatusCode = 'S' "
    Set rsTicketsSold = OBJdbConnection.Execute(SQLTicketsSold)

%>

    <TR>
        <TD class="data">&nbsp;</TD>
        <TD class="data"><INPUT TYPE="radio" NAME="ReportEventCode" VALUE=<%=rsEvents("EventCode")%>></TD>
        <TD class="data" NOWRAP><%=DateAndTimeFormat(rsEvents("EventDate"))%></TD>
        <TD class="data-left"><%=rsEvents("Act")%></TD>
        <TD class="data" NOWRAP><%=rsTicketsSold("Count")%></TD>
        <TD class="data" NOWRAP>&nbsp;</TD>
    </TR>
    <tr>
       <TD class="data">&nbsp;</TD>
      <TD class="data" colspan="4"><hr /></TD>
      <TD class="data">&nbsp;</TD>
    </tr>

<%	

    rsTicketsSold.Close
    Set rsTicketsSold = nothing

rsEvents.MoveNext	
Loop

rsEvents.Close
Set rsEvents = nothing

%>
    
</fieldset><br /><br />

<tr>
    <td class="footer-left">&nbsp;</td>
    <td class="footer" colspan="4">&nbsp;</td>
    <td class="footer-right">&nbsp;</td>
</tr>
<tr>
    <td >&nbsp;</td>
    <td align="center" colspan="4"><br /><br /><INPUT TYPE="submit" VALUE="Continue"></FORM></td>
    <td >&nbsp;</td>
</tr>
</tbody>
</table>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>
</htmlL>

<%

End Sub

'======================================
Sub DisplayReport(ReportEventCode)


Dim Question(17)
Question(1) = "First Name"	
Question(2) = "Last Name"	
Question(3) = "Gender"	
Question(4) = "Date of Birth"	
Question(5) = "Age"	
Question(6) = "Grade"
Question(7) = "School"	
Question(8) = "Parent/Guardian Name"	
Question(9) = "Emergency Contact Name"	
Question(10) = "Emergency Contact Phone Number"
Question(11) = "Who where you referred by?"
Question(12) = "Physician Name"
Question(13) = "Physician Phone"
Question(14) = "Date of last Tetanus Shot"
Question(15) = "Medical Concerns"
Question(16) = "Waiver"

Response.Buffer = False
Excel = Clean(Request("ExcelOutput"))

If Excel = "Y" Then

	Response.ContentType = "application/vnd.ms-excel"

End If

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & ReportTitle & "</TITLE>" & vbCrLf

%>

<style type="text/css">
    
body
{
font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
line-height: 1 em;
font-size: 65%;
}
#report-table
{
font-size: 80%;
text-align: left;
border-collapse: collapse;
width: 70%;
top: 10px;
line-height: 15px;
margin-top:  10px;
}
#report-table th
{
white-space:nowrap;
padding-right: 50px;
}
#report-table td
{
white-space:nowrap;
}
</style>
<%


If Excel <> "Y" Then

    Response.Write "<LINK REL=""stylesheet"" TYPE=""text/css"" HREF=""/CSS/Report.css"">" & vbCrLf
    
End If

Response.Write "</HEAD>" & vbCrLf
Response.Write "<BODY>" & vbCrLf

If Excel <> "Y" Then
%>
<!--#INCLUDE VIRTUAL="TopNavInclude.asp" -->
<%
 End If

SQLSeat = "SELECT DISTINCT Seat.EventCode, Seat.ItemNumber, Section, Seat.Row, Seat.Seat,  OrderLine.OrderNumber, OrderLine.LineNumber, Seat.ItemNumber, Section, Row, Seat, SeatStatus.Status, OrderType, OrderLine.SeatTypeCode, SeatType, Price, OrderLine.Discount, OrderDate, OrderHeader.CustomerNumber, Customer.FirstName AS FirstName, Customer.LastName AS LastName,OrganizationCustomerClass.Class,"
SQLSeat = SQLSeat & "(SELECT SeatStatus.Status) as OrderStatus," 
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'Answer1') as Answer1,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'Answer2') as Answer2,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'Answer3') as Answer3,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'Answer4') as Answer4,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'Answer5') as Answer5,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'Answer6') as Answer6,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'Answer7') as Answer7,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'Answer8') as Answer8,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'Answer9') as Answer9,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'Answer10') as Answer10,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'Answer11') as Answer11,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'Answer12') as Answer12,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'Answer13') as Answer13,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'Answer14') as Answer14,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'Answer15') as Answer15,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'Answer16') as Answer16"

SQLSeat = SQLSeat & "FROM Seat (NOLOCK) INNER JOIN Section (NOLOCK) ON Seat.SectionCode = Section.SectionCode AND Seat.EventCode = Section.EventCode INNER JOIN SeatStatus (NOLOCK) ON Seat.StatusCode = SeatStatus.StatusCode LEFT JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode AND OrganizationVenue.OrganizationNumber = OrganizationAct.OrganizationNumber LEFT JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber LEFT JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode LEFT JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber LEFT JOIN CustomerClass (NOLOCK) ON OrderHeader.CustomerNumber = CustomerClass.CustomerNumber LEFT JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber LEFT JOIN OrganizationCustomerClass (NOLOCK) ON CustomerClass.ClassNumber = OrganizationCustomerClass.ClassNumber AND OrganizationVenue.OrganizationNumber = OrganizationCustomerClass.OrganizationNumber LEFT JOIN OrderLineDetail (NOLOCK) ON OrderHeader.OrderNumber  = OrderLineDetail.OrderNumber WHERE Seat.EventCode = " & ReportEventCode & " AND OrganizationVenue.OrganizationNumber = 1641 AND OrganizationAct.OrganizationNumber = 1641 AND SeatStatus.Status IN ('Sold') ORDER BY OrderDate"
Set rsSeat = OBJdbConnection.Execute(SQLSeat)

If Not rsSeat.EOF Then

%>

<table id="report-table" border="1">
<thead>
    <tr>
	    <%  For i = 1 to 16	%>   
	    <th scope="col">&nbsp;<B><%=Answer&i%></B></th>	    
	    <% Next %>
    </tr>        
</thead>
<tbody>

<%

Call DBOpen(OBJdbConnection2)

'set your counter to 0
lc = 0
		
Do Until rsSeat.EOF

 lc = lc + 1
 
'set background color to nothing 
vBGColor = "#ffffff"

If lc mod 2 = 1 then vBGColor = "#f2fff2"

Response.Write "<tr>" & vbCrLf

For i = 1 to 16	

Select Case i

Case Else

Response.Write "<td>" & rsSeat("Answer&i") & "</td>" & vbCrLf
  
Next

Response.Write "</tr>" & vbCrLf
   

rsSeat.MoveNext

Loop    
    Response.Write "</TR>" & vbCrLf
    Response.Write "</TABLE>" & vbCrLf
Else
    Response.Write "No Seats Found.<BR>" & vbCrLf
End If

rsSeat.Close
Set rsSeat = nothing

%>

</FONT>
</CENTER>

<%
If Excel <> "Y" Then
%>
	<!--#include virtual="FooterInclude.asp"-->
<%
End If
%>

</BODY>
</HTML>

<%

End Sub

%>
