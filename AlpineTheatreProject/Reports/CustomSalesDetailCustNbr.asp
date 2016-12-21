<!--#include virtual="GlobalInclude.asp"-->
<!--#include virtual="dbOpenInclude.asp"-->
<%
Page = "ManagementReport"
SecurityFunction = "CustomSalesDetailCustNbr"
ReportFileName = "CustomSalesDetailCustNbr.asp"
ReportTitle = "Alpine Theater Project<bR>Custom Sales Detail Report (with Customer Number)"
'set the flag to include the TooltipInclude.html file
TooltipIncludeFlag = "Y"
ColumnCount = 32

If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then Response.Redirect("/Management/Default.asp")

If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then Response.Redirect("/Management/Default.asp")

If SecurityCheck(SecurityFunction) = False Then Response.Redirect("/Management/Default.asp")

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
<%
    'See if Organization has donations/memberships
    SQLDonation = "SELECT ItemNumber FROM Donation (NOLOCK) WHERE OrganizationNumber = " & Session("OrganizationNumber")
    Set rsDonation = OBJdbConnection.Execute(SQLDonation)
    
    If Not rsDonation.EOF Then
%>
<fieldset style="width: 600px;" class="reportCriteriaField">
    <legend class="reportCriteriaFieldTitle">Donation Selection</legend>	
    	<!--#INCLUDE VIRTUAL="/Include/DonationSelectionInclude.asp" -->
</fieldset><br />    	
<%
    End If
    
    rsDonation.Close
    Set rsDonation = nothing

    'Order Processing Fee Option
    Response.Write "<TABLE CELLPADDING=""3"" BORDER=""1"" WIDTH=""600"">" & vbCrLf
    Response.Write "<TR CLASS=""SectionHeading""><TD ALIGN=""center"" COLSPAN=""2"">Order Processing Fees</TD></TR>" & vbCrLf
    If Request("OrderProcessingFees") = "Y" Then
        OrderFeesStatus = " checked=checked"
    Else
        OrderFeesStatus = ""
    End If
    Response.Write "<TR CLASS=""Detail""><TD ALIGN=""center"" WIDTH=""22""><INPUT TYPE=""checkbox"" NAME=""OrderProcessingFees"" VALUE=""Y""" & OrderFeesStatus & "></TD><TD align=left>Include Order Processing Fees</TD></TR>" & vbCrLf
    Response.Write "</TABLE>" & vbCrLf
%>

<br />

<input type="checkbox" name="NewCustomer" value="Y" />&nbsp;&nbsp;New Customer Only<br />
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

'REE 5/28/5 - Added ability to output to Excel
Excel = Clean(Request("ExcelOutput"))
If Excel = "Y" Then
	Response.ContentType = "application/vnd.ms-excel"
End If

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & ReportTitle & "</TITLE>" & vbCrLf

If Excel <> "Y" Then

    Response.Write "<LINK REL=""stylesheet"" TYPE=""text/css"" HREF=""/CSS/Report.css"">" & vbCrLf

%>

    <SCRIPT LANGUAGE="JavaScript">    

    <!-- Hide code from non-js browsers

    function hideColumn(colnum) {

    var table = document.getElementById('Report');
    var rows = table.getElementsByTagName('TR');
    var cols = table.getElementsByTagName('TD');

    for (var row=0; row<rows.length;row++) {
	    var cells = rows[row].getElementsByTagName('TD')
	    cells[colnum-1].style.display='none';
	    document.getElementById('RightArrowCol' + colnum).style.visibility = "visible";
	    }
    }

    function hideColumn2(colnum) {

    var table = document.getElementById('Report');
    var i = 0;
    var rows = table.getElementsByTagName('TR');
    //var cols = table.getElementsByTagName('TD');

    for (i = 0; i < colnum.length; i++) {
    alert('Colnum = ' + colnum);
    //alert('ClassName = ' + document.getElementById(colnum).className);
    //alert('Length ColNum = ' + eval(colnum + '.length'));
    alert('Column Name Length = ' + colnum.length);
    //	if (table.getElementById(colnum).className == colnum){
    //		document.getElementById(colnum).style.display='none'; // This one works
    alert('Col = ' + colnum + '_' + i);
		    document.getElementById(colnum + '_' + i).style.display='none';
    //		table.colnum.style.display='none';
    //		document.getElementById(colnum).style.visibility = "hidden";
    //		document.getElementById('RightArrowCol' + colnum).style.visibility = "visible";
    //		}
	    }
    }


    function showColumn(colnum) {

    var table = document.getElementById('Report');
    var rows = table.getElementsByTagName('TR');

    for (var row=0; row<rows.length;row++) {
	    var cells = rows[row].getElementsByTagName('TD')
	    cells[colnum-1].style.display='block';	
	    document.getElementById('RightArrowCol' + colnum).style.visibility = 'hidden';
	    }
    }

    // end hiding -->
    </SCRIPT>
<%

End If

Response.Write "</HEAD>" & vbCrLf
Response.Write "<BODY>" & vbCrLf

If Excel <> "Y" Then
%>
<!--#INCLUDE VIRTUAL="TopNavInclude.asp" -->
<%
End If

Response.Write "<H3>" & ReportTitle & "</H3>" & vbCrLf

ReportStartDate = CDate(Request("TransactionStartDate"))
ReportEndDate = CDate(Request("TransactionEndDate"))

Response.Write "<B>Transactions From " & ReportStartDate & " through " & ReportEndDate & "</B><BR><BR>" & vbCrLf

Response.Write "<TABLE CELLPADDING=""3"" BORDER=""0"" ID=""Report"">" & vbCrLf

If Request("EventCode") <> "" Then

	Response.Write "<TR CLASS=""SectionHeading""><TD COLSPAN=""" & ColumnCount & """>Ticket Sales</TD></TR>" & vbCrLf
	
	
	If ReportStartDate <> "" Then
		SQLWhere = " AND vOrderLine.StatusDate >= '" & ReportStartDate & "' "
	End If
	If ReportEndDate <> "" Then
		SQLWhere = SQLWhere & " AND vOrderLine.StatusDate < '" & ReportEndDate + 1 & "' "
	End If
	
	If Request("ActCode") <> "" Then
		SQLWhere = SQLWhere & " AND ActCode IN ("
		ActArray = Split(Request("ActCode"), ",")
		For Each ActCode In ActArray
			SQLWhere = SQLWhere & CleanNumeric(ActCode) & ","
		Next
		SQLWhere = Left(SQLWhere, Len(SQLWhere) - 1) 'Trim last comma
		SQLWhere = SQLWhere & ")"
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

	If Request("SeatTypeCode") <> "" Then
		SQLWhere = SQLWhere & " AND vOrderLine.SeatTypeCode IN ("
		SeatTypeArray = Split(Request("SeatTypeCode"), ",")
		For Each SeatTypeCode In SeatTypeArray
			SQLWhere = SQLWhere & CleanNumeric(SeatTypeCode) & ","
		Next
		SQLWhere = Left(SQLWhere, Len(SQLWhere) - 1) 'Trim last comma
		SQLWhere = SQLWhere & ")"
	End If

	If Request("OrderTypeNumber") <> "" Then
		SQLWhere = SQLWhere & " AND OrderHeader.OrderTypeNumber IN ("
		OrderTypeArray = Split(Request("OrderTypeNumber"), ",")
		For Each OrderTypeNumber In OrderTypeArray
			SQLWhere = SQLWhere & CleanNumeric(OrderTypeNumber) & ","
		Next
		SQLWhere = Left(SQLWhere, Len(SQLWhere) - 1) 'Trim last comma
		SQLWhere = SQLWhere & ")"
	End If
	
	If Request("NewCustomer") = "Y" Then
	    SQLWhere = SQLWhere & " AND Customer.DateEntered >= '" & ReportStartDate & "' AND Customer.DateEntered < '" & ReportEndDate + 1 & "'"
	End If

    'REE 4/2/9 - Added Tender Type
    'REE 10/17/9 - Modified to use SQL Views
	'SQLOrderLine = "SELECT OrderLineData.OrderNumber, Status, LineNumber, ItemNumber, CustomerNumber, BillingFirstName, BillingLastName, ShipFirstName, ShipLastName, ShipAddress1, ShipAddress2, ShipCity, ShipState, ShipPostalCode, ShipCountry, DayPhone, NightPhone, Country, EMailAddress, ActCode, Act, EventCode, EventDate, SectionCode, Section, Row, Seat, StatusCode, OrderDate, TransDate, OrderTypeNumber, OrderType, SeatTypeCode, SeatType, Price, Discount, Surcharge AS ServiceFees, ItemType, ISNULL(TenderType, 'None') AS TenderType, UserFirstName, UserLastName, DiscountCode FROM (" 
	'SQLOrderLine = SQLOrderLine & "SELECT OrderLine.OrderNumber, 'Sold' AS Status, OrderLine.ItemNumber, OrderLine.LineNumber, Customer.CustomerNumber, Customer.FirstName AS BillingFirstName, Customer.LastName AS BillingLastName, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry, Customer.DayPhone, Customer.NightPhone, Customer.Country, Customer.EMailAddress, Act.ActCode, Act.Act, Event.EventCode, Event.EventDate, Seat.SectionCode, Section.Section, Seat.Row, Seat.Seat, OrderLine.StatusCode AS StatusCode, OrderHeader.OrderDate, OrderLine.StatusDate AS TransDate, OrderHeader.OrderTypeNumber, OrderType.OrderType, OrderLine.SeatTypeCode, SeatType.SeatType, OrderLine.Price, OrderLine.Discount, OrderLine.Surcharge AS Surcharge, OrganizationVenue.OrganizationNumber AS VenueOrg, OrganizationAct.OrganizationNumber AS ActOrg, OrderLine.ItemType, Users.FirstName AS UserFirstName, Users.LastName AS UserLastName, DiscountType.DiscountCode AS DiscountCode FROM OrderLine (NOLOCK) LEFT JOIN DiscountType (NOLOCK) ON OrderLine.DiscountTypeNumber = DiscountType.DiscountTypeNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber LEFT JOIN Users (NOLOCK) ON OrderHeader.UserNumber = Users.UserNumber INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode "
	'SQLOrderLine = SQLOrderLine & "UNION SELECT RefundOrderLine.OrderNumber, 'Cancelled' AS Status, RefundOrderLine.ItemNumber, RefundOrderLine.LineNumber, Customer.CustomerNumber, Customer.FirstName AS BillingFirstName, Customer.LastName AS BillingLastName, RefundOrderLine.ShipFirstName, RefundOrderLine.ShipLastName, RefundOrderLine.ShipAddress1, RefundOrderLine.ShipAddress2, RefundOrderLine.ShipCity, RefundOrderLine.ShipState, RefundOrderLine.ShipPostalCode, RefundOrderLine.ShipCountry, Customer.DayPhone, Customer.NightPhone, Customer.Country, Customer.EMailAddress, Act.ActCode, Act.Act, Event.EventCode, Event.EventDate, Seat.SectionCode, Section.Section, Seat.Row, Seat.Seat, RefundOrderLine.OrderLineStatusCode AS StatusCode, OrderHeader.OrderDate, RefundOrderLine.OrderLineStatusDate AS TransDate, OrderHeader.OrderTypeNumber, OrderType.OrderType, RefundOrderLine.SeatTypeCode, SeatType.SeatType, RefundOrderLine.Price, RefundOrderLine.Discount, RefundOrderLine.Surcharge AS Surcharge, OrganizationVenue.OrganizationNumber AS VenueOrg, OrganizationAct.OrganizationNumber AS ActOrg, RefundOrderLine.ItemType, Users.FirstName AS UserFirstName, Users.LastName AS UserLastName, DiscountType.DiscountCode AS DiscountCode FROM RefundOrderLine (NOLOCK) LEFT JOIN DiscountType (NOLOCK) ON RefundOrderLine.DiscountTypeNumber = DiscountType.DiscountTypeNumber INNER JOIN Seat (NOLOCK) ON RefundOrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN OrderHeader (NOLOCK) ON RefundOrderLine.OrderNumber = OrderHeader.OrderNumber LEFT JOIN Users (NOLOCK) ON OrderHeader.UserNumber = Users.UserNumber INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN SeatType (NOLOCK) ON RefundOrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode "
	'SQLOrderLine = SQLOrderLine & "UNION SELECT RefundOrderLine.OrderNumber, 'Cancelled' AS Status, RefundOrderLine.ItemNumber, RefundOrderLine.LineNumber, Customer.CustomerNumber, Customer.FirstName AS BillingFirstName, Customer.LastName AS BillingLastName, RefundOrderLine.ShipFirstName, RefundOrderLine.ShipLastName, RefundOrderLine.ShipAddress1, RefundOrderLine.ShipAddress2, RefundOrderLine.ShipCity, RefundOrderLine.ShipState, RefundOrderLine.ShipPostalCode, RefundOrderLine.ShipCountry, Customer.DayPhone, Customer.NightPhone, Customer.Country, Customer.EMailAddress, Act.ActCode, Act.Act, Event.EventCode, Event.EventDate, Seat.SectionCode, Section.Section, Seat.Row, Seat.Seat, RefundOrderLine.OrderLineStatusCode AS StatusCode, OrderHeader.OrderDate, RefundOrderLine.RefundDate AS TransDate, OrderHeader.OrderTypeNumber, OrderType.OrderType, RefundOrderLine.SeatTypeCode, SeatType.SeatType, RefundOrderLine.Price * - 1 AS Price, RefundOrderLine.Discount * - 1 AS Discount, RefundOrderLine.Surcharge * -1 AS Surcharge, OrganizationVenue.OrganizationNumber AS VenueOrg, OrganizationAct.OrganizationNumber AS ActOrg, RefundOrderLine.ItemType, Users.FirstName AS UserFirstName, Users.LastName AS UserLastName, DiscountType.DiscountCode AS DiscountCode FROM RefundOrderLine (NOLOCK) LEFT JOIN DiscountType (NOLOCK) ON RefundOrderLine.DiscountTypeNumber = DiscountType.DiscountTypeNumber INNER JOIN Seat (NOLOCK) ON RefundOrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN OrderHeader (NOLOCK) ON RefundOrderLine.OrderNumber = OrderHeader.OrderNumber LEFT JOIN Users (NOLOCK) ON OrderHeader.UserNumber = Users.UserNumber INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN SeatType (NOLOCK) ON RefundOrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode "
	'SQLOrderLine = SQLOrderLine & ") AS OrderLineData LEFT JOIN vOrderTenderType ON OrderLineData.OrderNumber = vOrderTenderType.OrderNumber WHERE StatusCode = 'S' AND ItemType IN ('Seat', 'SubFixedEvent', 'SubSeat') AND VenueOrg = " & Session("OrganizationNumber") & " AND ActOrg = " & Session("OrganizationNumber") & " " & SQLWHERE & " ORDER BY OrderLineData.OrderNumber, LineNumber, OrderDate"
	
    SQLOrderLine = "SELECT vOrderLine.OrderNumber, vOrderLine.TransType AS Status, vOrderLine.LineNumber, vOrderLine.ItemNumber, Customer.CustomerNumber, Customer.FirstName AS BillingFirstName, Customer.LastName AS BillingLastName, vOrderLine.ShipFirstName, vOrderLine.ShipLastName, vOrderLine.ShipAddress1, vOrderLine.ShipAddress2, vOrderLine.ShipCity, vOrderLine.ShipState, vOrderLine.ShipPostalCode, vOrderLine.ShipCountry, Customer.DayPhone, Customer.NightPhone, Customer.Country, Customer.EMailAddress, Act.ActCode, Act.Act, Event.EventCode, Event.EventDate, Section.SectionCode, Section.Section, Seat.Row, Seat.Seat, vOrderLine.StatusCode, OrderHeader.OrderDate, vOrderLine.StatusDate AS TransDate, OrderHeader.OrderTypeNumber, OrderType.OrderType, SeatType.SeatTypeCode, SeatType.SeatType, vOrderLine.Price, vOrderLine.Discount, vOrderLine.Surcharge AS ServiceFees, vOrderLine.ItemType, ISNULL(vOrderTenderType.TenderType, 'None') AS TenderType, Users.FirstName AS UserFirstName, Users.LastName AS UserLastName, DiscountType.DiscountCode, vOrderLine.ItemCount FROM vOrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON vOrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber INNER JOIN Seat (NOLOCK) ON vOrderLine.ItemNumber = Seat.ItemNumber INNER JOIN vOrgEvent (NOLOCK) ON Seat.EventCode = vOrgEvent.EventCode INNER JOIN SeatType (NOLOCK) ON vOrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN ItemType (NOLOCK) ON vOrderLine.ItemType = ItemType.SubCategory LEFT JOIN vOrderTenderType (NOLOCK) ON OrderHeader.OrderNumber = vOrderTenderType.OrderNumber INNER JOIN Event (NOLOCK) ON vOrgEvent.EventCode = Event.EventCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode LEFT JOIN Users (NOLOCK) ON OrderHeader.UserNumber = Users.UserNumber LEFT JOIN DiscountType ON vOrderLine.DiscountTypeNumber = DiscountType.DiscountTypeNumber "
    SQLOrderLine = SQLOrderLine & " WHERE vOrgEvent.OrganizationNumber = " & Session("OrganizationNumber") & " AND ItemType.Category = 'Seat' AND vOrderLine.StatusCode = 'S' " & SQLWHERE & " ORDER BY OrderHeader.OrderNumber, vOrderLine.LineNumber, OrderHeader.OrderDate"
	
	Set rsOrderLine = OBJdbConnection.Execute(SQLOrderLine)
		
	FirstRecord = "Y"
	
	If Not rsOrderLine.EOF Then

        ColumnHeading = "<TR CLASS=""ColumnHeading"">"
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Order&nbsp;Number</TD>" 'Column 1
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Customer&nbsp;Number</TD>" 'Column 1
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Billing Name</TD>" 'Column 1
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Order&nbsp;Date</TD>" 'Column 2
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Transaction&nbsp;Date</TD>" 'Column 3
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Order&nbsp;Status</TD>" 'Column 4
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">First&nbsp;Name</TD>" 'Column 5
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Last&nbsp;Name</TD>" 'Column 5
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Ship Address 1</TD>" 'Column 6
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Ship Address 2</TD>" 'Column 7
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Ship City</TD>" 'Column 8
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Ship State</TD>" 'Column 9
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Ship Postal Code</TD>" 'Column 10
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Ship Country</TD>" 'Column 11
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Daytime Phone</TD>" 'Column 12
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Evening Phone</TD>" 'Column 13
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Email Address</TD>" 'Column 14
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Order Type</TD>" 'Column 15
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">User Name</TD>" 'Column 16
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Production</TD>" 'Column 17
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Event&nbsp;Date/Time</TD>" 'Column 18
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Section</TD>" 'Column 19
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Row</TD>" 'Column 20
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Seat</TD>" 'Column 21
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Subscription/Ticket</TD>" 'Column 22
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Ticket Type</TD>" 'Column 23
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Discount Code</TD>" 'Column 24
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Tender Method</TD>" 'Column 25
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Price</TD>" 'Column 26
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Discount</TD>" 'Column 27
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Service Fees</TD>" 'Column 28
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Amount</TD>" 'Column 29
		ColumnHeading = ColumnHeading & "</TR>"
		Response.Write ColumnHeading & vbCrLf
		
		FirstRecord = "N"

	End If	

	Do Until rsOrderLine.EOF
        
        RecordCount = RecordCount + 1
		PageBuffer = PageBuffer + 1
		
		If PageBuffer >=100 Then	
			Response.Flush
			PageBuffer = 0
		End If
		
		'Added column SubscriptionTicket
		Select Case rsOrderLine("ItemType")
		    Case "SubFixedEvent"
		        SubTicketType = "Subscription"
		    Case "SubSeat"
		        SubTicketType = "Subscription Ticket"
		    Case "Seat"
		        SubTicketType = "Single Ticket"
		End Select

		LineAmountTotal = (rsOrderLine("Price") - rsOrderLine("Discount") + rsOrderLine("ServiceFees")) * rsOrderLine("ItemCount")
		
		If rsOrderLine("Status") = "S" Then	
			Detail = "<TR CLASS=""Detail"">"
		Else
			Detail = "<TR CLASS=""DetailCancelled"">"
		End If
		If Excel <> "Y" Then
			Detail = Detail & "<TD NOWRAP ALIGN=""right""><A HREF=""/Reports/OrderDetails.asp?OrderNumber=" & rsOrderLine("OrderNumber") & """ TITLE=""Click here to go to Order Details for Order #" & rsOrderLine("OrderNumber") & """ onmouseover=""ttDelay=setTimeout('eventTooltip(\'/Include/OrderInfoInclude.asp?OrderNumber=" & rsOrderLine("OrderNumber") & "\', this)', 200);"" onmouseout=""clearTimeout(ttDelay);hideTooltip();"">" & rsOrderLine("OrderNumber") & "</A></TD>" 'Column 1
    		Detail = Detail & "<TD NOWRAP><A HREF=""/Reports/CustomerDetails.asp?CustomerNumber=" & rsOrderLine("CustomerNumber") & """ TITLE=""Click here to go to Customer Details for " & rsOrderLine("BillingFirstName") & " " & rsOrderLine("BillingLastName") & """ onmouseover=""ttDelay=setTimeout('eventTooltip(\'/Include/AttendeeInfoInclude.asp?OrderNumber=" & rsOrderLine("OrderNumber") & "\', this)', 200);"" onmouseout=""clearTimeout(ttDelay);hideTooltip();"">" & rsOrderLine("CustomerNumber") & "</A></TD>" 'Column 5
		Else
			Detail = Detail & "<TD NOWRAP ALIGN=""right"">" & rsOrderLine("OrderNumber") & "</TD>" 'Column 1
		    Detail = Detail & "<TD NOWRAP>" & rsOrderLine("CustomerNumber") & "</TD>" 'Column 2
		End If
		Detail = Detail & "<TD NOWRAP>" & rsOrderLine("BillingFirstName") & " " & rsOrderLine("BillingLastName") & "</TD>" 'Column 3
		Detail = Detail & "<TD NOWRAP>" & DateAndTimeFormat(rsOrderLine("OrderDate")) & "</TD>" 'Column 2
		Detail = Detail & "<TD NOWRAP>" & DateAndTimeFormat(rsOrderLine("TransDate")) & "</TD>" 'Column 3
		
		If rsOrderLine("Status") = "R" Then
		    Status = "Cancelled"
        Else
            Status = "Sold"
        End If
            		    
		Detail = Detail & "<TD NOWRAP>" & Status & "</TD>" 'Column 4
		
		Detail = Detail & "<TD NOWRAP>" & rsOrderLine("ShipFirstName") & "</TD>" 'Column 5
		Detail = Detail & "<TD NOWRAP>" & rsOrderLine("ShipLastName") & "</TD>" 'Column 5
        Detail = Detail & "<TD NOWRAP>" & rsOrderLine("ShipAddress1") & "</TD>" 'Column 6
        Detail = Detail & "<TD NOWRAP>" & rsOrderLine("ShipAddress2") & "</TD>" 'Column 7
        Detail = Detail & "<TD NOWRAP>" & rsOrderLine("ShipCity") & "</TD>" 'Column 8
        Detail = Detail & "<TD NOWRAP>" & rsOrderLine("ShipState") & "</TD>" 'Column 9
        Detail = Detail & "<TD NOWRAP>" & rsOrderLine("ShipPostalCode") & "</TD>" 'Column 10
        Detail = Detail & "<TD NOWRAP>" & rsOrderLine("ShipCountry") & "</TD>" 'Column 11
        Detail = Detail & "<TD NOWRAP>" & FormatPhone(rsOrderLine("DayPhone"),rsOrderLine("Country")) & "</TD>" 'Column 12
        Detail = Detail & "<TD NOWRAP>" & FormatPhone(rsOrderLine("NightPhone"),rsOrderLine("Country")) & "</TD>" 'Column 13
        Detail = Detail & "<TD NOWRAP>" & rsOrderLine("EMailAddress") & "</TD>" 'Column 14
		Detail = Detail & "<TD NOWRAP>" & rsOrderLine("OrderType") & "</TD>" 'Column 15
		Detail = Detail & "<TD NOWRAP>" & rsOrderLine("UserFirstName") & " " & rsOrderLine("UserLastName") & "</TD>" 'Column 15
		Detail = Detail & "<TD NOWRAP>" & rsOrderLine("Act") & "</TD>" 'Column 16
		Detail = Detail & "<TD NOWRAP>" & FormatDateTime(rsOrderLine("EventDate")) & "</TD>" 'Column 17
		Detail = Detail & "<TD NOWRAP>" & rsOrderLine("Section") & "</TD>" 'Column 18
		Detail = Detail & "<TD NOWRAP ALIGN=""center"">" & rsOrderLine("Row") & "&nbsp;</TD>" 'Column 19
		Detail = Detail & "<TD NOWRAP ALIGN=""center"">" & rsOrderLine("Seat") & "</TD>" 'Column 20
		Detail = Detail & "<TD NOWRAP ALIGN=""center"">" & SubTicketType & "</TD>" 'Column 21
		Detail = Detail & "<TD NOWRAP ALIGN=""center"">" & rsOrderLine("SeatType") & "</TD>" 'Column 22
		Detail = Detail & "<TD NOWRAP ALIGN=""center"">" & rsOrderLine("DiscountCode") & "</TD>" 'Column 22
		Detail = Detail & "<TD NOWRAP ALIGN=""right"">" & rsOrderLine("TenderType") & "</TD>" 'Column 23
		Detail = Detail & "<TD NOWRAP ALIGN=""right"">" & FormatCurrency(rsOrderLine("Price"), 2) & "</TD>" 'Column 24
		Detail = Detail & "<TD NOWRAP ALIGN=""right"">" & FormatCurrency(rsOrderLine("Discount"), 2) & "</TD>" 'Column 25
		Detail = Detail & "<TD NOWRAP ALIGN=""right"">" & FormatCurrency(rsOrderLine("ServiceFees"), 2) & "</TD>" 'Column 26
		Detail = Detail & "<TD NOWRAP ALIGN=""right"">" & FormatCurrency(LineAmountTotal, 2) & "</TD>" 'Column 27
		Detail = Detail & "</TR>"
		Response.Write Detail & vbCrLf
        

		'If rsOrderLine("Status") <> "R" Then
		'	SubtotalTicketCount = SubtotalTicketCount + 1
		'End If

        SubtotalTicketCount = SubtotalTicketCount + rsOrderLine("ItemCount")

		SubtotalPrice = SubtotalPrice + rsOrderLine("Price") * rsOrderLine("ItemCount")
		SubtotalDiscount = SubtotalDiscount + rsOrderLine("Discount") * rsOrderLine("ItemCount")
		SubtotalServiceFees = SubtotalServiceFees + rsOrderLine("ServiceFees") * rsOrderLine("ItemCount")
		SubtotalTotal = SubtotalTotal + LineAmountTotal

		rsOrderLine.MoveNext	

	Loop
	
	rsOrderLine.Close
	Set rsOrderLine = nothing

	If FirstRecord <> "Y" Then
	
        RecordCount = RecordCount + 1
	
		'Print last subtotal
		SubtotalData = "<TR CLASS=""ColumnHeading"">"
		SubtotalData = SubtotalData & "<TD>Total</TD>" 'Column 1
		SubtotalData = SubtotalData & "<TD ALIGN=""right"">Sold Count:</TD>" 'Column 2
		SubtotalData = SubtotalData & "<TD colspan=26>" & FormatNumber(SubtotalTicketCount,0) & "</TD>" 'Column 3
		SubtotalData = SubtotalData & "<TD ALIGN=""right"">" & FormatCurrency(SubtotalPrice, 2) & "</TD>" 'Column 22
		SubtotalData = SubtotalData & "<TD ALIGN=""right"">" & FormatCurrency(SubtotalDiscount, 2) & "</TD>" 'Column 23
		SubtotalData = SubtotalData & "<TD ALIGN=""right"">" & FormatCurrency(SubtotalServiceFees, 2) & "</TD>" 'Column 24
		SubtotalData = SubtotalData & "<TD ALIGN=""right"">" & FormatCurrency(SubtotalTotal, 2) & "</TD>" 'Column 25
		SubtotalData = SubtotalData & "</TR>"
		Response.Write SubtotalData & vbCrLf

		TotalItemCount = TotalItemCount + SubtotalTicketCount
		TotalPrice = TotalPrice + SubtotalPrice
		TotalDiscount = TotalDiscount + SubtotalDiscount
		TotalServiceFees = TotalServiceFees + SubtotalServiceFees
		GrandTotal = TotalPrice - TotalDiscount + TotalServiceFees


		
	Else
		
		Response.Write "<TR CLASS=""Detail""><TD COLSPAN=""" & ColumnCount & """><B>There are no ticket sales to report for specified criteria.</B></TD></TR>" & vbCrLf
			
	End If

'	Response.Write "<TR BGCOLOR=""#FFFFFF""><TD COLSPAN=""" & ColumnCount & """>&nbsp;</TD></TR>" & vbCrLf

End If

'=========== DONATIONS/MEMBERSHIPS ===============

If Request("DonationItemNumber") <> "" Then 'There were donation/memberships selected.

	Response.Write "<TR CLASS=""SectionHeading""><TD COLSPAN=""" & ColumnCount & """>Donations/Memberships</TD></TR>" & vbCrLf

	For Each ItemNumber In Request("DonationItemNumber")
		DonationList = DonationList & CleanNumeric(ItemNumber) & ","
	Next
	'Trim last comma
	DonationList = Left(DonationList, Len(DonationList) - 1)
	
	SQLWhere = ""
	If Request("NewCustomer") = "Y" Then
	    SQLWhere = " AND Customer.DateEntered >= '" & ReportStartDate & "' AND Customer.DateEntered < '" & ReportEndDate + 1 & "'"
	End If

    'REE 4/2/9 - Added Tender Type
	SQLOrderLine = "SELECT DonationData.OrderNumber, OrderDate, 'Sold' AS Status, CustomerNumber, FirstName, LastName, Address1, Address2, City, State, PostalCode, Country, BillingFirstName, BillingLastName, DaytimePhone, EveningPhone, CustCountry, EMailAddr, OrderType, Description, Amount, Year(OrderDate) AS OrderYear, MONTH(OrderDate) AS OrderMonth, DAY(OrderDate) AS OrderDay, TransDate, SUM(DonationCount) AS SumDonationCount, SUM(SumPrice) AS SumPrice, SUM(SumDiscount) AS SumDiscount, SUM(SumServiceFees) AS SumServiceFees, ISNULL(TenderType, 'None') AS TenderType, UserFirstName, UserLastName FROM (" 
	SQLOrderLine = SQLOrderLine & "SELECT DISTINCT Donation.Description, Donation.Amount, OrderLine.ItemNumber, OrderHeader.OrderDate, OrderLine.StatusDate AS TransDate, OrderLine.OrderNumber, 'Sold' AS Status, OrderHeader.CustomerNumber, OrderLine.ShipFirstName AS FirstName, OrderLine.ShipLastName AS LastName, OrderLine.ShipAddress1 AS Address1, OrderLine.ShipAddress2 AS Address2, OrderLine.ShipCity AS City, OrderLine.ShipState AS State, OrderLine.ShipPostalCode AS PostalCode, OrderLine.ShipCountry AS Country, Customer.FirstName AS BillingFirstName, Customer.LastName AS BillingLastName, Customer.DayPhone AS DaytimePhone, Customer.NightPhone AS EveningPhone, Customer.Country AS CustCountry, Customer.EMailAddress AS EMailAddr, OrderType, COUNT(LineNumber) as DonationCount, SUM(OrderLine.Price) AS SumPrice, SUM(OrderLine.Discount) AS SumDiscount, SUM(OrderLine.Surcharge) AS SumServiceFees, Users.FirstName AS UserFirstName, Users.LastName AS UserLastName FROM OrderHeader (NOLOCK) LEFT JOIN Users (NOLOCK) ON OrderHeader.UserNumber = Users.UserNumber INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber" & SQLWhere & " INNER JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber INNER JOIN Donation (NOLOCK) ON OrderLine.ItemNumber = Donation.ItemNumber WHERE OrderLine.ItemNumber IN (" & DonationList & ") AND OrderLine.ItemType = 'Donation' AND (Donation.OrganizationNumber = " & Session("OrganizationNumber") & " OR Donation.RemittalOrganizationNumber = " & Session("OrganizationNumber") & ") AND OrderLine.StatusDate >= '" & ReportStartDate & "' AND OrderLine.StatusDate < '" & ReportEndDate + 1 & "' GROUP BY Donation.Description, Donation.Amount, OrderLine.ItemNumber, OrderHeader.OrderDate, OrderLine.StatusDate, OrderLine.OrderNumber, OrderHeader.CustomerNumber, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry, Customer.FirstName, Customer.LastName, Customer.DayPhone, Customer.NightPhone, Customer.Country, Customer.EMailAddress, OrderType, Users.FirstName, Users.LastName "
	SQLOrderLine = SQLOrderLine & "UNION SELECT DISTINCT Donation.Description, Donation.Amount, RefundOrderLine.ItemNumber, OrderHeader.OrderDate, RefundOrderLine.OrderLineStatusDate AS TransDate, RefundOrderLine.OrderNumber, 'Sold' AS Status, OrderHeader.CustomerNumber, RefundOrderLine.ShipFirstName AS FirstName, RefundOrderLine.ShipLastName AS LastName, RefundOrderLine.ShipAddress1 AS Address1, RefundOrderLine.ShipAddress2 AS Address2, RefundOrderLine.ShipCity AS City, RefundOrderLine.ShipState AS State, RefundOrderLine.ShipPostalCode AS PostalCode, RefundOrderLine.ShipCountry AS Country, Customer.FirstName AS BillingFirstName, Customer.LastName AS BillingLastName, Customer.DayPhone AS DaytimePhone, Customer.NightPhone AS EveningPhone, Customer.Country AS CustCountry, Customer.EMailAddress AS EMailAddr, OrderType, COUNT(LineNumber) as DonationCount, SUM(RefundOrderLine.Price) AS SumPrice, SUM(RefundOrderLine.Discount) AS SumDiscount, SUM(RefundOrderLine.Surcharge) AS SumServiceFees, Users.FirstName AS UserFirstName, Users.LastName AS UserLastName FROM OrderHeader (NOLOCK) LEFT JOIN Users (NOLOCK) ON OrderHeader.UserNumber = Users.UserNumber INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber" & SQLWhere & " INNER JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber INNER JOIN RefundOrderLine (NOLOCK) ON OrderHeader.OrderNumber = RefundOrderLine.OrderNumber INNER JOIN Donation (NOLOCK) ON RefundOrderLine.ItemNumber = Donation.ItemNumber WHERE RefundOrderLine.ItemNumber IN (" & DonationList & ") AND RefundOrderLine.ItemType = 'Donation' AND (Donation.OrganizationNumber = " & Session("OrganizationNumber") & " OR Donation.RemittalOrganizationNumber = " & Session("OrganizationNumber") & ") AND RefundOrderLine.OrderLineStatusDate >= '" & ReportStartDate & "' AND RefundOrderLine.OrderLineStatusDate < '" & ReportEndDate + 1 & "' GROUP BY Donation.Description, Donation.Amount, RefundOrderLine.ItemNumber, OrderHeader.OrderDate, RefundOrderLine.OrderLineStatusDate, RefundOrderLine.OrderNumber, OrderHeader.CustomerNumber, RefundOrderLine.ShipFirstName, RefundOrderLine.ShipLastName, RefundOrderLine.ShipAddress1, RefundOrderLine.ShipAddress2, RefundOrderLine.ShipCity, RefundOrderLine.ShipState, RefundOrderLine.ShipPostalCode, RefundOrderLine.ShipCountry, Customer.FirstName, Customer.LastName, Customer.DayPhone, Customer.NightPhone, Customer.Country, Customer.EMailAddress, OrderType, Users.FirstName, Users.LastName "
	SQLOrderLine = SQLOrderLine & "UNION SELECT DISTINCT Donation.Description, Donation.Amount, RefundOrderLine.ItemNumber, OrderHeader.OrderDate, RefundOrderLine.RefundDate AS TransDate, RefundOrderLine.OrderNumber, 'Sold' AS Status, OrderHeader.CustomerNumber, RefundOrderLine.ShipFirstName AS FirstName, RefundOrderLine.ShipLastName AS LastName, RefundOrderLine.ShipAddress1 AS Address1, RefundOrderLine.ShipAddress2 AS Address2, RefundOrderLine.ShipCity AS City, RefundOrderLine.ShipState AS State, RefundOrderLine.ShipPostalCode AS PostalCode, RefundOrderLine.ShipCountry AS Country, Customer.FirstName AS BillingFirstName, Customer.LastName AS BillingLastName, Customer.DayPhone AS DaytimePhone, Customer.NightPhone AS EveningPhone, Customer.Country AS CustCountry, Customer.EMailAddress AS EMailAddr, OrderType, COUNT(LineNumber) * - 1 as DonationCount, SUM(RefundOrderLine.Price) * -1 AS SumPrice, SUM(RefundOrderLine.Discount) * -1 AS SumDiscount, SUM(RefundOrderLine.Surcharge) * -1 AS SumServiceFees, Users.FirstName AS UserFirstName, Users.LastName AS UserLastName FROM OrderHeader (NOLOCK) LEFT JOIN Users (NOLOCK) ON OrderHeader.UserNumber = Users.UserNumber INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber" & SQLWhere & " INNER JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber INNER JOIN RefundOrderLine (NOLOCK) ON OrderHeader.OrderNumber = RefundOrderLine.OrderNumber INNER JOIN Donation (NOLOCK) ON RefundOrderLine.ItemNumber = Donation.ItemNumber WHERE RefundOrderLine.ItemNumber IN (" & DonationList & ") AND RefundOrderLine.ItemType = 'Donation' AND (Donation.OrganizationNumber = " & Session("OrganizationNumber") & " OR Donation.RemittalOrganizationNumber = " & Session("OrganizationNumber") & ") AND RefundOrderLine.RefundDate >= '" & ReportStartDate & "' AND RefundOrderLine.RefundDate < '" & ReportEndDate + 1 & "' GROUP BY Donation.Description, Donation.Amount, RefundOrderLine.ItemNumber, OrderHeader.OrderDate, RefundOrderLine.RefundDate, RefundOrderLine.OrderNumber, OrderHeader.CustomerNumber, RefundOrderLine.ShipFirstName, RefundOrderLine.ShipLastName, RefundOrderLine.ShipAddress1, RefundOrderLine.ShipAddress2, RefundOrderLine.ShipCity, RefundOrderLine.ShipState, RefundOrderLine.ShipPostalCode, RefundOrderLine.ShipCountry, Customer.FirstName, Customer.LastName, Customer.DayPhone, Customer.NightPhone, Customer.Country, Customer.EMailAddress, OrderType, Users.FirstName, Users.LastName "
	SQLOrderLine = SQLOrderLine & ") AS DonationData LEFT JOIN vOrderTenderType ON DonationData.OrderNumber = vOrderTenderType.OrderNumber GROUP BY ItemNumber, DonationData.OrderNumber, OrderDate, TransDate, Status, CustomerNumber, FirstName, LastName, Address1, Address2, City, State, PostalCode, Country, BillingFirstName, BillingLastName, DaytimePhone, EveningPhone, CustCountry, EMailAddr, OrderType, Description, Amount, YEAR(OrderDate), MONTH(OrderDate), DAY(OrderDate), vOrderTenderType.TenderType, UserFirstName, UserLastName ORDER BY Description, YEAR(OrderDate), MONTH(OrderDate), DAY(OrderDate)"
	Set rsOrderLine = OBJdbConnection.Execute(SQLOrderLine)
		
	If Not rsOrderLine.EOF Then
		ColumnHeading = "<TR CLASS=""ColumnHeading"">"
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Order&nbsp;Number&nbsp;</TD>" 'Column 1
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Customer Number</TD>" 'Column 2
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Billing Name</TD>" 'Column 2
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Order&nbsp;Date</TD>" 'Column 2
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Transaction&nbsp;Date</TD>" 'Column 2
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Order&nbsp;Status</TD>" 'Column 3
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">First&nbsp;Name</TD>" 'Column 4
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Last&nbsp;Name</TD>" 'Column 4
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Address 1</TD>" 'Column 5
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Address 2</TD>" 'Column 6
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">City</TD>" 'Column 7
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">State</TD>" 'Column 8
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Postal Code</TD>" 'Column 9
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Country</TD>" 'Column 10
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Daytime Phone</TD>" 'Column 11
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Evening Phone</TD>" 'Column 12
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Email Address</TD>" 'Column 13
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Order&nbsp;Type</TD>" 'Column 14
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">User Name</TD>" 'Column 14
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"" colspan=""8"">Description</TD>" 'Column 15-20
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Tender Method</TD>" 'Column 21
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Face Value</TD>" 'Column 22
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Discount</TD>" 'Column 23
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Service Fees</TD>" 'Column 24
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Total</TD>" 'Column 25
		ColumnHeading = ColumnHeading & "</TR>"
		Response.Write ColumnHeading & vbCrLf
	End If
	
	FirstRecord = "Y"

	Do Until rsOrderLine.EOF
		
		FirstRecord = "N"

		If rsOrderLine("Amount") = 0 Then
			Price = "ANY"
		Else
			Price = FormatCurrency(rsOrderLine("Amount"), 2)
		End If
			
		Detail = "<TR CLASS=""Detail"">"
		
		If Excel <> "Y" Then
		    Detail = Detail & "<TD NOWRAP ALIGN=""right""><A HREF=""/Reports/OrderDetails.asp?OrderNumber=" & rsOrderLine("OrderNumber") & """ TITLE=""Click here to go to Order Details for Order #" & rsOrderLine("OrderNumber") & """ onmouseover=""ttDelay=setTimeout('eventTooltip(\'/Include/OrderInfoInclude.asp?OrderNumber=" & rsOrderLine("OrderNumber") & "\', this)', 200);"" onmouseout=""clearTimeout(ttDelay);hideTooltip();"">" & rsOrderLine("OrderNumber") & "</A></TD>" 'Column 1
		    Detail = Detail & "<TD NOWRAP><A HREF=""/Reports/CustomerDetails.asp?CustomerNumber=" & rsOrderLine("CustomerNumber") & """ TITLE=""Click here to go to Customer Details for " & rsOrderLine("FirstName") & " " & rsOrderLine("LastName") & """ onmouseover=""ttDelay=setTimeout('eventTooltip(\'/Include/CustomerInfoInclude.asp?CustomerNumber=" & rsOrderLine("CustomerNumber") & "\', this)', 200);"" onmouseout=""clearTimeout(ttDelay);hideTooltip();"">" & rsOrderLine("CustomerNumber") & "</A></TD>" 'Column 4
	    Else
		    Detail = Detail & "<TD NOWRAP ALIGN=""right"">" & rsOrderLine("OrderNumber") & "</TD>" 'Column 1
	        Detail = Detail & "<TD NOWRAP>" & rsOrderLine("CustomerNumber") & "</TD>" 'Column 2
	    End If
	    
	    Detail = Detail & "<TD NOWRAP>" & rsOrderLine("BillingFirstName") & " " & rsOrderLine("BillingLastName") & "</TD>" 'Column 2
	    Detail = Detail & "<TD NOWRAP>" & DateAndTimeFormat(rsOrderLine("OrderDate")) & "</TD>" 'Column 2
	    Detail = Detail & "<TD NOWRAP>" & DateAndTimeFormat(rsOrderLine("TransDate")) & "</TD>" 'Column 2
	    Detail = Detail & "<TD NOWRAP>" & rsOrderLine("Status") & "</TD>" 'Column 3
	    
	    Detail = Detail & "<TD NOWRAP>" & rsOrderLine("FirstName") & "</TD>" 'Column 4
		Detail = Detail & "<TD NOWRAP>" & rsOrderLine("LastName") & "</TD>" 'Column 4
	    Detail = Detail & "<TD NOWRAP>" & rsOrderLine("Address1") & "</TD>" 'Column 5
        Detail = Detail & "<TD NOWRAP>" & rsOrderLine("Address2") & "</TD>" 'Column 6
        Detail = Detail & "<TD NOWRAP>" & rsOrderLine("City") & "</TD>" 'Column 7
        Detail = Detail & "<TD NOWRAP>" & rsOrderLine("State") & "</TD>" 'Column 8
        Detail = Detail & "<TD NOWRAP>" & rsOrderLine("PostalCode") & "</TD>" 'Column 9
        Detail = Detail & "<TD NOWRAP>" & rsOrderLine("Country") & "</TD>" 'Column 10
        Detail = Detail & "<TD NOWRAP>" & FormatPhone(rsOrderLine("DaytimePhone"),rsOrderLine("CustCountry")) & "</TD>" 'Column 11
        Detail = Detail & "<TD NOWRAP>" & FormatPhone(rsOrderLine("EveningPhone"),rsOrderLine("CustCountry")) & "</TD>" 'Column 12
        Detail = Detail & "<TD NOWRAP>" & rsOrderLine("EMailAddr") & "</TD>" 'Column 13
	    Detail = Detail & "<TD NOWRAP>" & rsOrderLine("OrderType") & "</TD>" 'Column 14
	    Detail = Detail & "<TD NOWRAP>" & rsOrderLine("UserFirstName") & " " & rsOrderLine("UserLastName") & "</TD>" 'Column 14
		Detail = Detail & "<TD colspan=8 NOWRAP>" & rsOrderLine("Description") & "</TD>" 'Column 15-20
		Detail = Detail & "<TD ALIGN=right>" & rsOrderLine("TenderType") & "</TD>" 'Column 21
		Detail = Detail & "<TD ALIGN=right>" & FormatCurrency(rsOrderLine("Amount"), 2) & "</TD>" 'Column 22
		Detail = Detail & "<TD ALIGN=right>" & FormatCurrency(rsOrderLine("SumDiscount"), 2) & "</TD>" 'Column 23
		Detail = Detail & "<TD ALIGN=right>" & FormatCurrency(rsOrderLine("SumServiceFees"), 2) & "</TD>" 'Column 24
		Detail = Detail & "<TD ALIGN=right>" & FormatCurrency(rsOrderLine("SumPrice")- rsOrderLine("SumDiscount") + rsOrderLine("SumServiceFees"), 2) & "</TD>" 'Column 25
		Detail = Detail & "</TR>"
		Response.Write Detail & vbCrLf

		SubtotalDonationCount = SubtotalDonationCount + rsOrderLine("SumDonationCount")
		SubtotalDonationPrice = SubtotalDonationPrice + rsOrderLine("SumPrice")
		SubtotalDonationDiscount = SubtotalDonationDiscount + rsOrderLine("SumDiscount")
		SubtotalDonationServiceFees = SubtotalDonationServiceFees + rsOrderLine("SumServiceFees")
		DonationAmountSubtotal = DonationAmountSubtotal + rsOrderLine("SumPrice")- rsOrderLine("SumDiscount") + rsOrderLine("SumServiceFees")

		rsOrderLine.MoveNext	

	Loop
	
	rsOrderLine.Close
	Set rsOrderLine = nothing

	If FirstRecord <> "Y" Then 

		'Print last subtotal
		SubtotalData = "<TR CLASS=""ColumnHeading"">"
		SubtotalData = SubtotalData & "<TD>Total</TD>" 
		SubtotalData = SubtotalData & "<TD ALIGN=right>Sold Count:</TD>"
		SubtotalData = SubtotalData & "<TD colspan=26>" & FormatNumber(SubtotalDonationCount,0) & "</TD>"
		'SubtotalData = SubtotalData & "<TD colspan=19>&nbsp;</TD>" 
		SubtotalData = SubtotalData & "<TD ALIGN=right>" & FormatCurrency(SubtotalDonationPrice, 2) & "</TD>" 
		SubtotalData = SubtotalData & "<TD ALIGN=right>" & FormatCurrency(SubtotalDonationDiscount, 2) & "</TD>" 
		SubtotalData = SubtotalData & "<TD ALIGN=right>" & FormatCurrency(SubtotalDonationServiceFees, 2) & "</TD>" 
		SubtotalData = SubtotalData & "<TD ALIGN=right>" & FormatCurrency(DonationAmountSubtotal, 2) & "</TD>" 
		SubtotalData = SubtotalData & "</TR>"
		Response.Write SubtotalData & vbCrLf

		TotalItemCount = TotalItemCount + SubtotalDonationCount
		TotalPrice = TotalPrice + SubtotalDonationPrice
		TotalDiscount = TotalDiscount + SubtotalDonationDiscount
		TotalServiceFees = TotalServiceFees + SubtotalDonationServiceFees
		GrandTotal = GrandTotal + DonationAmountSubtotal
		
	Else
		
		Response.Write "<TR CLASS=""Detail""><TD COLSPAN=""" & ColumnCount & """><B>There are no donation/membership sales to report for specified criteria.</B></TD></TR>" & vbCrLf
			
	End If

	'Response.Write "<TR BGCOLOR=""#FFFFFF""><TD COLSPAN=""" & ColumnCount & """>&nbsp;</TD></TR>" & vbCrLf
	
End If

'=========== ORDER PROCESSING FEES ===============

If Request("OrderProcessingFees") = "Y" Then 'There were Order Processing Fees selected.

	Response.Write "<TR CLASS=""SectionHeading""><TD COLSPAN=""" & ColumnCount & """>Order Processing Fees</TD></TR>" & vbCrLf

	'SQLOrderLine = "SELECT COUNT(OrderHeader.OrderNumber) AS OrderCount, SUM(OrderHeader.ShipFee) AS OrderFees FROM OrderHeader (NOLOCK) WHERE OrderNumber IN (" 
	'SQLOrderLine = SQLOrderLine & "SELECT OrderLine.OrderNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE OrderLine.ItemType IN ('Seat', 'SubFixedEvent', 'SubSeat') AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " GROUP BY OrderLine.OrderNumber "
	'SQLOrderLine = SQLOrderLine & "UNION SELECT OrderLine.OrderNumber FROM OrderLine (NOLOCK) INNER JOIN Donation (NOLOCK) ON OrderLine.ItemNumber = Donation.ItemNumber WHERE OrderLine.ItemType = 'Donation' AND (Donation.OrganizationNumber = " & Session("OrganizationNumber") & " OR Donation.RemittalOrganizationNumber = " & Session("OrganizationNumber") & ") GROUP BY OrderLine.OrderNumber "
	'SQLOrderLine = SQLOrderLine & ") AND OrderHeader.OrderDate > '" & ReportStartDate & "' AND OrderHeader.OrderDate <= '" & ReportEndDate + 1 & "' AND OrderHeader.StatusCode = 'S' AND OrderHeader.ShipFee <> 0"
	
	SQLWhere = ""
	If Request("NewCustomer") = "Y" Then
	    SQLWhere = " AND Customer.DateEntered >= '" & ReportStartDate & "' AND Customer.DateEntered < '" & ReportEndDate + 1 & "'"
	End If
	
    'REE 4/2/9 - Added Tender Type
	SQLOrderLine = "SELECT OrderHeader.OrderNumber, OrderHeader.OrderDate, 'Sold' AS Status, Customer.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, Customer.DayPhone, Customer.NightPhone, Customer.EMailAddress, OrderType.OrderType, OrderHeader.ShipFee AS OrderFees, ISNULL(TenderType, 'None') AS TenderType, Users.FirstName AS UserFirstName, Users.LastName AS UserLastName FROM OrderHeader (NOLOCK) LEFT JOIN Users (NOLOCK) ON OrderHeader.UserNumber = Users.UserNumber INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber" & SQLWhere & " INNER JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber INNER JOIN vOrderTenderType ON OrderHeader.OrderNumber = vOrderTenderType.OrderNumber WHERE OrderHeader.OrderNumber IN (" 
	SQLOrderLine = SQLOrderLine & "SELECT OrderLine.OrderNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE OrderLine.ItemType IN ('Seat', 'SubFixedEvent', 'SubSeat') AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " GROUP BY OrderLine.OrderNumber "
	SQLOrderLine = SQLOrderLine & "UNION SELECT OrderLine.OrderNumber FROM OrderLine (NOLOCK) INNER JOIN Donation (NOLOCK) ON OrderLine.ItemNumber = Donation.ItemNumber WHERE OrderLine.ItemType = 'Donation' AND (Donation.OrganizationNumber = " & Session("OrganizationNumber") & " OR Donation.RemittalOrganizationNumber = " & Session("OrganizationNumber") & ") GROUP BY OrderLine.OrderNumber "
	SQLOrderLine = SQLOrderLine & ") AND OrderHeader.OrderDate > '" & ReportStartDate & "' AND OrderHeader.OrderDate <= '" & ReportEndDate + 1 & "' AND OrderHeader.StatusCode = 'S' AND OrderHeader.ShipFee <> 0"
	
	Set rsOrderLine = OBJdbConnection.Execute(SQLOrderLine)
		
	If Not rsOrderLine.EOF Then
		ColumnHeading = "<TR CLASS=""ColumnHeading"">"
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=center>Order Number</TD>" 
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=center>Customer Number</TD>" 
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=center>Billing Name</TD>"
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=center>Order Date</TD>" 
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=center colspan=2>Order Status</TD>" 
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=center>First Name</TD>"
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=center>Last Name</TD>"
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Address 1</TD>" 'Column 5
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Address 2</TD>" 'Column 6
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">City</TD>" 'Column 7
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">State</TD>" 'Column 8
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Postal Code</TD>" 'Column 9
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Country</TD>" 'Column 10
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Daytime Phone</TD>" 'Column 11
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Evening Phone</TD>" 'Column 12
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Email Address</TD>" 'Column 13 
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">Order Type</TD>"
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=""center"">User Name</TD>"
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=center COLSPAN=""8"">&nbsp;</TD>" 
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=center>Tender Method</TD>" 
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=center COLSPAN=""2"">&nbsp;</TD>" 
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=center>Service Fees</TD>" 
		ColumnHeading = ColumnHeading & "<TD NOWRAP ALIGN=center>Total</TD>" 
		ColumnHeading = ColumnHeading & "</TR>"
		Response.Write ColumnHeading & vbCrLf
		
		Do Until rsOrderLine.EOF
		    Detail = "<TR CLASS=""Detail"">"
		    
		    If Excel <> "Y" Then
			    Detail = Detail & "<TD NOWRAP ALIGN=""right""><A HREF=""/Reports/OrderDetails.asp?OrderNumber=" & rsOrderLine("OrderNumber") & """ TITLE=""Click here to go to Order Details for Order #" & rsOrderLine("OrderNumber") & """ onmouseover=""ttDelay=setTimeout('eventTooltip(\'/Include/OrderInfoInclude.asp?OrderNumber=" & rsOrderLine("OrderNumber") & "\', this)', 200);"" onmouseout=""clearTimeout(ttDelay);hideTooltip();"">" & rsOrderLine("OrderNumber") & "</A></TD>" 'Column 1
    		    Detail = Detail & "<TD NOWRAP><A HREF=""/Reports/CustomerDetails.asp?CustomerNumber=" & rsOrderLine("CustomerNumber") & """ TITLE=""Click here to go to Customer Details for " & rsOrderLine("FirstName") & " " & rsOrderLine("LastName") & """ onmouseover=""ttDelay=setTimeout('eventTooltip(\'/Include/CustomerInfoInclude.asp?CustomerNumber=" & rsOrderLine("CustomerNumber") & "\', this)', 200);"" onmouseout=""clearTimeout(ttDelay);hideTooltip();"">" & rsOrderLine("CustomerNumber") & "</A></TD>" 'Column 4
		    Else
			    Detail = Detail & "<TD NOWRAP ALIGN=""right"">" & rsOrderLine("OrderNumber") & "</TD>" 'Column 1
		        Detail = Detail & "<TD NOWRAP>" & rsOrderLine("CustomerNumber") & "</TD>" 'Column 2
		    End If
		    
		    Detail = Detail & "<TD NOWRAP>" & rsOrderLine("FirstName") & " " & rsOrderLine("LastName") & "</TD>" 'Column 2
		    Detail = Detail & "<TD NOWRAP>" & DateAndTimeFormat(rsOrderLine("OrderDate")) & "</TD>" 'Column 2
		    Detail = Detail & "<TD NOWRAP colspan=2>" & rsOrderLine("Status") & "</TD>" 'Column 3
		    
		    Detail = Detail & "<TD NOWRAP>" & rsOrderLine("FirstName") & "</TD>" 'Column 4
    		Detail = Detail & "<TD NOWRAP>" & rsOrderLine("LastName") & "</TD>" 'Column 4
		    Detail = Detail & "<TD NOWRAP>" & rsOrderLine("Address1") & "</TD>" 'Column 5
            Detail = Detail & "<TD NOWRAP>" & rsOrderLine("Address2") & "</TD>" 'Column 6
            Detail = Detail & "<TD NOWRAP>" & rsOrderLine("City") & "</TD>" 'Column 7
            Detail = Detail & "<TD NOWRAP>" & rsOrderLine("State") & "</TD>" 'Column 8
            Detail = Detail & "<TD NOWRAP>" & rsOrderLine("PostalCode") & "</TD>" 'Column 9
            Detail = Detail & "<TD NOWRAP>" & rsOrderLine("Country") & "</TD>" 'Column 10
            Detail = Detail & "<TD NOWRAP>" & FormatPhone(rsOrderLine("DayPhone"),rsOrderLine("Country")) & "</TD>" 'Column 11
            Detail = Detail & "<TD NOWRAP>" & FormatPhone(rsOrderLine("NightPhone"),rsOrderLine("Country")) & "</TD>" 'Column 12
            Detail = Detail & "<TD NOWRAP>" & rsOrderLine("EMailAddress") & "</TD>" 'Column 13
		    Detail = Detail & "<TD NOWRAP>" & rsOrderLine("OrderType") & "</TD>" 'Column 14
		    Detail = Detail & "<TD NOWRAP>" & rsOrderLine("UserFirstName") & " " & rsOrderLine("UserLastName") & "</TD>" 'Column 14
		    Detail = Detail & "<TD COLSPAN=""8"">&nbsp;</TD>" 'Column 16 - 23
		    Detail = Detail & "<TD ALIGN=right>" & rsOrderLine("TenderType") & "</TD>" 'Column 15
		    Detail = Detail & "<TD COLSPAN=""2"">&nbsp;</TD>" 'Column 16 - 23
		    Detail = Detail & "<TD ALIGN=right>" & FormatCurrency(rsOrderLine("OrderFees"), 2) & "</TD>" 'Column 24
		    Detail = Detail & "<TD ALIGN=right>" & FormatCurrency(rsOrderLine("OrderFees"), 2) & "</TD>" 'Column 25
		    Detail = Detail & "</TR>"
		    Response.Write Detail & vbCrLf

		    SubtotalOrderCount = SubtotalOrderCount + 1
		    SubtotalOrderFees = SubtotalOrderFees + rsOrderLine("OrderFees")
		    rsOrderLine.MoveNext	
	    Loop
	    
	    'Print last subtotal
		SubtotalData = "<TR CLASS=""ColumnHeading"">"
		SubtotalData = SubtotalData & "<TD>Total</TD>" 
		SubtotalData = SubtotalData & "<TD ALIGN=right>Sold Count:</TD>" 
		SubtotalData = SubtotalData & "<TD colspan=28>" & FormatNumber(SubtotalOrderCount,0) & "</TD>" 
		'SubtotalData = SubtotalData & "<TD colspan=20>&nbsp;</TD>" 
		SubtotalData = SubtotalData & "<TD ALIGN=right>" & FormatCurrency(SubtotalOrderFees, 2) & "</TD>" 
		SubtotalData = SubtotalData & "<TD ALIGN=right>" & FormatCurrency(SubtotalOrderFees, 2) & "</TD>" 
		SubtotalData = SubtotalData & "</TR>"
		Response.Write SubtotalData & vbCrLf

		TotalItemCount = TotalItemCount + SubtotalOrderCount
		TotalServiceFees = TotalServiceFees + SubtotalOrderFees
		GrandTotal = GrandTotal + SubtotalOrderFees
	Else
	    Response.Write "<TR CLASS=""Detail""><TD COLSPAN=""" & ColumnCount & """><B>There are no order processing fees to report for specified criteria.</B></TD></TR>" & vbCrLf
	End If

	rsOrderLine.Close
	Set rsOrderLine = nothing
End If

'============= GRANDTOTALS ================

'Response.Write "<TR CLASS=""SectionHeading""><TD COLSPAN=""" & ColumnCount & """>Grandtotal</TD></TR>" & vbCrLf

'ColumnHeading = "<TR CLASS=""ColumnHeading"">"
'ColumnHeading = ColumnHeading & "<TD>Grandtotal</TD>" 'Column 1
'ColumnHeading = ColumnHeading & "<TD ALIGN=center>Quantity</TD>" 'Column 2
'ColumnHeading = ColumnHeading & "<TD ALIGN=center>Face Value</TD>" 'Column 3
'ColumnHeading = ColumnHeading & "<TD ALIGN=center>Discount</TD>" 'Column 4
'ColumnHeading = ColumnHeading & "<TD ALIGN=center>Total Fees</TD>" 'Column 5
'ColumnHeading = ColumnHeading & "<TD ALIGN=center>Total</TD>" 'Column 6
'ColumnHeading = ColumnHeading & "</TR>"
'Response.Write ColumnHeading & vbCrLf

Detail = "<TR CLASS=""SectionHeading"">"
Detail = Detail & "<TD style=""text-align:left"" NOWRAP>GRAND TOTALS</TD>" 'Column 1
Detail = Detail & "<TD style=""text-align:right"">Total Sold Count:</TD>" 'Column 2
Detail = Detail & "<TD style=""text-align:left"" colspan=26>" & FormatNumber(TotalItemCount,0) & "</TD>" 'Column 3
'Detail = Detail & "<TD colspan=19>&nbsp;</TD>" 'Column 4
Detail = Detail & "<TD style=""text-align:right"">" & FormatCurrency(TotalPrice, 2) & "</TD>" 'Column 12
Detail = Detail & "<TD style=""text-align:right"">" & FormatCurrency(TotalDiscount, 2) & "</TD>" 'Column 13
Detail = Detail & "<TD style=""text-align:right"">" & FormatCurrency(TotalServiceFees, 2) & "</TD>" 'Column 14
Detail = Detail & "<TD style=""text-align:right"">" & FormatCurrency(Grandtotal, 2) & "</TD>" 'Column 15
Detail = Detail & "</TR>"
Response.Write Detail & vbCrLf
		
'=================== PAGE FOOTER ============================

Response.Write "</TABLE>" & vbCrLf

If Excel <> "Y" Then
%>
	<!--#INCLUDE VIRTUAL="FooterInclude.asp"-->
<%
End If

Response.Write "</BODY>" & vbCrLf
Response.Write "</HTML>" & vbCrLf

End Sub 'Display Report

%>