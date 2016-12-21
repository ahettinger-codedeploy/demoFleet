<!--#include virtual="GlobalInclude.asp"-->
<!--#include virtual="dbOpenInclude.asp"-->
<%
Page = "SalesDailyReport"
'SecurityFunction = "SalesDailyReportEventSelection"
ReportFileName = "ZipCodeReport.asp"
ReportTitle = "Zip Code Report"

If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then Response.Redirect("/Management/Default.asp")

If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then Response.Redirect("/Management/Default.asp")

'If SecurityCheck(SecurityFunction) = False Then Response.Redirect("/Management/Default.asp")

If Request("btnSubmit") = "Submit" Then
    Call ReportOutput
Else
    Call ReportCriteria
End If        

Sub ReportCriteria
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
    <title><%= ReportTitle %></title>
    <link href="/CSS/Report.css" rel="stylesheet" type="text/css" />
</head>
<body>


<!--#include virtual="TopNavInclude.asp" -->

<div class="pageTitle"><%= ReportTitle %></div>

<form name="ReportCriteria" action="<%= ReportFileName %>" method="post">

<%
fldTitle = "Transaction Date Range"
fldStartDate = "TransactionStartDate"
fldEndDate = "TransactionEndDate"
StartDateDefault = FormatDateTime(Now(), vbShortDate)
EndDateDefault = FormatDateTime(Now(), vbShortDate)
%>

<!--#INCLUDE VIRTUAL="Include/DateRangeSelectionInclude.asp"-->

<p></p>
<%
EventListDaysDefault = 30
%>
<fieldset style="width: 600px;" class="reportCriteriaField">
    <legend class="reportCriteriaFieldTitle">Event Selection</legend>

    <!--#INCLUDE VIRTUAL="/Include/EventListDayInclude.asp" -->

    <!--#INCLUDE VIRTUAL="/Include/EventSelectionInclude.asp" -->
</fieldset>

<br />

<input type="checkbox" name="ExcelOutput" value="Y"<% If Request("ExcelOutput") = "Y" Then %> checked="checked"<% End If %>>&nbsp;&nbsp;Output To Excel<br /><br />

<input type="submit" value="Submit" name="btnSubmit" onclick="return validateForm();" />

</form>

<script language="javascript" type="text/javascript">
function validateForm() {
    formObj = document.ReportCriteria;
    <%= jsValidateForm %>
}
</script>

<!--#include virtual="FooterInclude.asp"-->


</body>
</html>
<%

End Sub 'ReportCriteria

'=======================

Sub ReportOutput

'REE 12/9/7 - Added Output to Excel
Excel = Clean(Request("ExcelOutput"))

If Excel = "Y" Then

	Response.ContentType = "application/vnd.ms-excel"

End If
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
    <title><%= ReportTitle %></title>
    <link href="/CSS/Report.css" rel="stylesheet" type="text/css" />
</head>
<body>

<%
If Excel <> "Y" Then
%>
	<!--#include virtual="TopNavInclude.asp" -->
    <div class="pageTitle"><%= ReportTitle %></div>
<%
End If

SQLOrganization = "SELECT Organization FROM Organization (NOLOCK) WHERE OrganizationNumber = " & Session("OrganizationNumber")
Set rsOrganization = OBJdbConnection.Execute(SQLOrganization)
Organization = rsOrganization("Organization")
rsOrganization.Close
Set rsOrganization = nothing

ReportStartDate = CDate(Request("TransactionStartDate"))
ReportEndDate = CDate(Request("TransactionEndDate"))

Response.Write "<FONT FACE='verdana,arial,helvetica' SIZE=2><B>" & Organization & "</B></FONT><BR>" & vbCrLf
Response.Write "<FONT FACE='verdana,arial,helvetica' SIZE=2><B> Total Sales From " & ReportStartDate & " Through " &  ReportEndDate & "</B></FONT><BR><BR>" & vbCrLf

If ReportStartDate <> "" Then
	SQLWhere = " AND OrderLine.StatusDate >= '" & ReportStartDate & "' "
End If
If ReportEndDate <> "" Then
	SQLWhere = SQLWhere & " AND OrderLine.StatusDate < '" & ReportEndDate + 1 & "' "
End If

If Request("EventCode") <> "" Then
	SQLWhere = SQLWhere & " AND Event.EventCode IN ("
	EventArray = Split(Request("EventCode"), ",")
	For Each EventCode In EventArray
		SQLWhere = SQLWhere & CleanNumeric(EventCode) & ","
	Next
	SQLWhere = Left(SQLWhere, Len(SQLWhere) - 1) 'Trim last comma
	SQLWhere = SQLWhere & ")"
End If

SQLOrderLine = "SELECT PostalCode.City, PostalCode.State, PostalCode.PostalCode, COUNT(*) AS TicketCount, SUM(OrderLine.Price) AS SumPrice, SUM(OrderLine.Discount) AS SumDiscount, SUM(OrderLine.Surcharge) AS SumServiceFees FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN vOrgEvent (NOLOCK) ON Seat.EventCode = vOrgEvent.EventCode INNER JOIN ItemType (NOLOCK) ON OrderLine.ItemType = ItemType.SubCategory INNER JOIN Event (NOLOCK) ON vOrgEvent.EventCode = Event.EventCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode LEFT JOIN PostalCode (NOLOCK) ON SUBSTRING(OrderLine.ShipPostalCode,1,5) = PostalCode.PostalCode"
SQLOrderLine = SQLOrderLine & " WHERE vOrgEvent.OrganizationNumber = " & Session("OrganizationNumber") & " AND ItemType.Category = 'Seat' AND OrderLine.StatusCode = 'S' " & SQLWHERE & " GROUP BY PostalCode.PostalCode, PostalCode.City, PostalCode.State ORDER BY PostalCode.State, PostalCode.City, PostalCode.PostalCode"
Set rsOrderLine = OBJdbConnection.Execute(SQLOrderLine)
	
If Not rsOrderLine.EOF Then

    Response.Write "<TABLE CELLPADDING=""3"" BORDER=""0"">" & vbCrLf
    Response.Write "<TR CLASS=""SectionHeading""><TD COLSPAN=8>Ticket Sales</TD></TR>" & vbCrLf

    ColumnHeading = "<TR CLASS=""ColumnHeading"">"
	ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">City</TD>" 'Column 1
	ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">State</TD>" 'Column 2
	ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Zip Code</TD>" 'Column 3
	ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Total Tickets</TD>" 'Column 4
	ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Total Face Value</TD>" 'Column 5
	ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Total Discounts</TD>" 'Column 5
	ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Total Service Fees</TD>" 'Column 6
	ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Net Total</TD>" 'Column 7
	ColumnHeading = ColumnHeading & "</TR>"
	Response.Write ColumnHeading & vbCrLf
	
    Do Until rsOrderLine.EOF
        
        Detail = "<TR CLASS=""Detail"">"
	    Detail = Detail & "<TD NOWRAP>" & rsOrderLine("City") & "</TD>" 'Column 8
        Detail = Detail & "<TD NOWRAP>" & rsOrderLine("State") & "</TD>" 'Column 9
        Detail = Detail & "<TD NOWRAP>" & rsOrderLine("PostalCode") & "</TD>" 'Column 10
        Detail = Detail & "<TD NOWRAP>" & rsOrderLine("TicketCount") & "</TD>" 'Column 10
        Detail = Detail & "<TD NOWRAP ALIGN=""right"">" & FormatCurrency(rsOrderLine("SumPrice"), 2) & "</TD>" 'Column 24
	    Detail = Detail & "<TD NOWRAP ALIGN=""right"">" & FormatCurrency(rsOrderLine("SumDiscount"), 2) & "</TD>" 'Column 25
	    Detail = Detail & "<TD NOWRAP ALIGN=""right"">" & FormatCurrency(rsOrderLine("SumServiceFees"), 2) & "</TD>" 'Column 26
	    Detail = Detail & "<TD NOWRAP ALIGN=""right"">" & FormatCurrency(rsOrderLine("SumPrice") - rsOrderLine("SumDiscount"), 2) & "</TD>" 'Column 27
	    Detail = Detail & "</TR>"
	    Response.Write Detail & vbCrLf

	    SubtotalTicketCount = SubtotalTicketCount + rsOrderLine("TicketCount")
	    SubtotalPrice = SubtotalPrice + rsOrderLine("SumPrice")
	    SubtotalDiscount = SubtotalDiscount + rsOrderLine("SumDiscount")
	    SubtotalServiceFees = SubtotalServiceFees + rsOrderLine("SumServiceFees")
	    SubtotalTotal = SubtotalTotal + (rsOrderLine("SumPrice") - rsOrderLine("SumDiscount"))

	    rsOrderLine.MoveNext	

    Loop
    
    'Print last subtotal
	SubtotalData = "<TR CLASS=""ColumnHeading"">"
	SubtotalData = SubtotalData & "<TD>Total</TD>" 'Column 1
	SubtotalData = SubtotalData & "<TD ALIGN=""right"" colspan=2>Sold Count:</TD>" 'Column 2
	SubtotalData = SubtotalData & "<TD>" & FormatNumber(SubtotalTicketCount,0) & "</TD>" 'Column 3
	SubtotalData = SubtotalData & "<TD ALIGN=""right"">" & FormatCurrency(SubtotalPrice, 2) & "</TD>" 'Column 22
	SubtotalData = SubtotalData & "<TD ALIGN=""right"">" & FormatCurrency(SubtotalDiscount, 2) & "</TD>" 'Column 23
	SubtotalData = SubtotalData & "<TD ALIGN=""right"">" & FormatCurrency(SubtotalServiceFees, 2) & "</TD>" 'Column 24
	SubtotalData = SubtotalData & "<TD ALIGN=""right"">" & FormatCurrency(SubtotalTotal, 2) & "</TD>" 'Column 25
	SubtotalData = SubtotalData & "</TR>"
	Response.Write SubtotalData & vbCrLf
	
	Response.Write "</TABLE>" & vbCrLf

Else
	
	Response.Write "<B>There are no ticket sales to report for specified criteria.</B>" & vbCrLf
		
End If

rsOrderLine.Close
Set rsOrderLine = nothing

If Excel <> "Y" Then
%>
	<!--#include virtual="FooterInclude.asp"-->
<%
End If
%>

</body>
</html>
<%
End Sub 'ReportOutput
%>
