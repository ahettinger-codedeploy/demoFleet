<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp"-->
<!--#INCLUDE VIRTUAL="TicketPrintInclude.asp"-->
<!--#INCLUDE VIRTUAL="NoCacheInclude.asp"-->
<%

Server.ScriptTimeout = 3600

Response.Buffer = false

'REE 4/15/2 - Increased Session Timeout to 30 minutes to reduce Print validation timeout issues.
Session.Timeout = 60

Page = "ManagementMenu"

'Make sure the correct Session variables are in place.  If not clear the variables and go to the menu.
If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then 
	Session.Abandon
	Response.Redirect("/Default.asp")
End If

If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then 
	Session.Abandon
	Response.Redirect("Default.asp")
End If

'Decide which subroutine to route to
Select Case Request("FormName")
	Case "PrintMenu"
		Call PrintLetters
	Case Else
		Call PrintMenu
End Select

'----------------------------------

Sub PrintMenu

%>
<HTML>
<HEAD>
<TITLE>Tix - Subscription Renewal Letters</TITLE>
<script language="Javascript">
function validateForm() {
    formObj = document.OrderNumberSearch;
    if (formObj.OrderNumber.value == "") {
        alert("Please enter a valid order number");
        formObj.OrderNumber.focus();
        return false;
    }
}
</script>
</HEAD>
<BODY BGCOLOR="#FFFFFF">

<CENTER>

<!--#INCLUDE VIRTUAL="TopNavInclude.asp"-->
<BR>
<BR>

<FONT FACE="verdana,arial,helvetica" COLOR="#008400"><H3>Subscription Renewal Printing</H3></FONT>

<TABLE>
	<TR valign=MIDDLE><FORM ACTION="RenewalLettersByOrder.asp" METHOD="post" NAME="OrderNumberSearch" onSubmit="return validateForm()"><input type="hidden" name="FormName" value="PrintMenu" />
		<TD ALIGN="RIGHT" VALIGN=MIDDLE><FONT FACE="verdana,arial,helvetica" COLOR="#000000" SIZE="2"><B>Enter Order Number: </B></FONT></TD>
		<TD><INPUT TYPE="text" NAME="OrderNumber" SIZE="20" MAXLENGTH="20"></TD>
		<TD><INPUT TYPE="submit" VALUE="Lookup"></TD></FORM>
	</TR>
</TABLE>

</CENTER>

<!--#INCLUDE VIRTUAL="FooterInclude.asp"-->

</BODY>
</HTML>

<%

End Sub 'PrintMenu

'---------------------------------

Sub PrintLetters

'Server.ScriptTimeout = 600

%>

<HTML>
<HEAD>
<TITLE>Tix - Subscription Renewal Letters</TITLE>
</HEAD>
<BODY LEFTMARGIN="0" RIGHTMARGIN="0" TOPMARGIN="0" MARGINHEIGHT="0" MARGINWIDTH="0">

<STYLE>	

	.InvoiceTitle
	{
	    font-family: Arial, Tahoma, Verdana;
	    font-size: large;
	    font-weight: bold;
	    color: Black;
	    text-align: center;
	}

	.InvoiceSubTitle
	{
	    font-family: Arial, Tahoma, Verdana;
	    font-size: medium;
	    font-weight: bold;
	    color: Black;
	    text-align: center;
	}
	
	.InvoiceColumnHeading 
	{
	    font-family: Arial, Tahoma, Verdana;
	    font-size: x-small;
	    font-weight: bold;
	    text-decoration: underline;
	    color: Black;
	}
		.InvoiceDetail 
	{
	    font-family: Arial, Tahoma, Verdana;
	    font-size: x-small;
	    color: Black;
	}
	
	    
</STYLE>


<CENTER>
<%

Call DBOpen(OBJdbConnection2)
OrdersFound = True
SQLOrders = "SELECT OrderHeader.OrderNumber, Customer.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, OrderHeader.Subtotal, OrderHeader.Total, OrderHeader.OrderSurcharge, OrderHeader.ShipFee, OrderHeader.Discount, ISNULL(Tender.TenderAmount, 0) AS TenderAmount FROM OrderHeader (NOLOCK) INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber LEFT JOIN (SELECT OrderNumber, SUM(Tender.Amount) AS TenderAmount FROM Tender (NOLOCK) GROUP BY Tender.OrderNumber) AS Tender ON OrderHeader.OrderNumber = Tender.OrderNumber WHERE OrderHeader.OrderNumber IN (SELECT OrderLine.OrderNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN vOrgEvent (NOLOCK) ON Seat.EventCode = vOrgEvent.EventCode WHERE vOrgEvent.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderLine.OrderNumber = " & CleanNumeric(Request("OrderNumber")) & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent'))  ORDER BY Customer.LastName, Customer.FirstName, OrderHeader.OrderNumber"
Set rsOrders = OBJdbConnection.Execute(SQLOrders)
If Not rsOrders.EOF Then
    Do Until rsOrders.EOF

        OrderCount = OrderCount + 1

        OrderNumber = rsOrders("OrderNumber")
        CustomerNumber = rsOrders("CustomerNumber")
        
        'Title
        Response.Write "<TABLE WIDTH=""750"">"
        Response.Write "<TR CLASS=""InvoiceTitle""><TD ALIGN=""center"">TOYOTA GRAND PRIX OF LONG BEACH</TD></TR>"
        Response.Write "<TR CLASS=""InvoiceTitle""><TD ALIGN=""center"">2012 TICKET RENEWAL</TD></TR>"
        Response.Write "<TR CLASS=""InvoiceSubTitle""><TD ALIGN=""center"">April 13 - 15, 2012</TD></TR></TABLE>" & vbCrLf

        'Renewal Code
	    SQLItemNumber = "SELECT MIN(ItemNumber) AS MinItemNum FROM OrderLine (NOLOCK) WHERE OrderNumber = " & OrderNumber & " GROUP BY ItemNumber"
	    Set rsItemNumber = OBJdbConnection2.Execute(SQLItemNumber)
	    'RenewalCode = CustomerNumber & rsItemNumber("MinItemNum")
	    RenewalCode = CustomerNumber * 3
	    rsItemNumber.Close
	    Set rsItemNumber = nothing 

        'Customer Shipping Information
	    Response.Write "<TABLE WIDTH=750 BORDER=""0"" CLASS=""InvoiceDetail""><TR><TD WIDTH=""50"">&nbsp;</TD><TD WIDTH=""350"" VALIGN=""bottom"">" & rsOrders("FirstName") & " " & rsOrders("LastName") & "<BR>" & rsOrders("Address1") & "<BR>" & vbCrLf
	    If rsOrders("Address2") <> "" Then
		    Response.Write rsOrders("Address2") & "<BR>" & vbCrLf
	    End If
	    Response.Write rsOrders("City") & ", " & rsOrders("State") & " " & rsOrders("PostalCode") & "<BR>" & rsOrders("Country") & "<BR></TD><TD WIDTH=""300"" ALIGN=""right"" VALIGN=""bottom""><img src=""/Clients/GPLB/Images/2012_TGPLB_Logo.jpg"" height=""146""></TD></TR></TABLE><BR>" & vbCrLf
        
        'SQLEvent = "SELECT Event.EventCode, Act.ShortAct, Venue.Venue, Event.EventDate, Shipping.ShipType FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Shipping (NOLOCK) ON OrderLine.ShipCode = Shipping.ShipCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode IN (" & Clean(Request("EventCode")) & ") AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') GROUP BY Event.EventCode, Act.Act, Venue.Venue, Event.EventDate, Shipping.ShipType ORDER BY Event.EventDate, Event.EventCode"
        'rsEvent = OBJdbConnection2.Execute(SQLEvent)
        
        'EventCode = rsEvent("EventCode")
        'ShortAct = rsEvent("ShortAct")
        'Venue = rsEvent("Venue")
        'EventDate = rsEvent("EventDate")
        'ShipType = rsEvent("ShipType")
        
        'rsEvent.Close
        'Set rsEvent = nothing
        
        
        Response.Write "<TABLE WIDTH=""750"" BORDER=""0"">"
        Response.Write "<TR CLASS=""InvoiceSubTitle""><TD COLSPAN=""8"" ALIGN=""center"">Renewal Due Date September 23rd, 2011</TD></TR>" & vbCrLf
        Response.Write "<TR CLASS=""InvoiceDetail""><TD COLSPAN=""8""><B>Order Number: " & OrderNumber & "<BR>Online Renewal Code: " & RenewalCode & "</B><BR><BR></TD></TR>" & vbCrLf
        Response.Write "<TR CLASS=""InvoiceColumnHeading"">"
        Response.Write "<TD>Ticket Package</TD>"
        Response.Write "<TD>Grandstand</TD>"
        Response.Write "<TD ALIGN=""center"">Row</TD>"
        Response.Write "<TD ALIGN=""center"">Seat(s)</TD>"
        Response.Write "<TD ALIGN=""center"">Type</TD>"
        Response.Write "<TD ALIGN=""center"">Quantity</TD>"
        Response.Write "<TD ALIGN=""right"">Price</TD>"
        Response.Write "<TD ALIGN=""right"">Amount</TD>"
        Response.Write "</TR>"    
        
        SeatCount = 0
        
        'Get Numeric Seat Numbers    
        SQLSeat = "SELECT Act.ShortAct, Section.Section, Seat.Row, MIN(CAST(Seat.Seat AS int)) AS MinSeat, MAX(CAST(Seat.Seat AS int)) AS MaxSeat, SeatType.SeatType, OrderLine.Price, OrderLine.Discount, COUNT(*) AS SeatQty, SUM(Price) AS Amount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode INNER JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') AND ISNUMERIC(Seat.Seat) = 1 GROUP BY Act.ShortAct, Section.Section, Seat.Row, SeatType.SeatType, OrderLine.Price, OrderLine.Discount ORDER BY Act.ShortAct, Section.Section, Seat.Row, MIN(CAST(Seat.Seat AS int))"
        Set rsSeat = OBJdbConnection2.Execute(SQLSeat)
        
        Do Until rsSeat.EOF
            Response.Write "<TR CLASS=""InvoiceDetail"">"
            Response.Write "<TD>" & rsSeat("ShortAct") & "</TD>"
            Response.Write "<TD>" & rsSeat("Section") & "</TD>"
            Response.Write "<TD ALIGN=""center"">" & rsSeat("Row") & "</TD>"
            If rsSeat("MinSeat") <> rsSeat("MaxSeat") Then
                Response.Write "<TD ALIGN=""center"">" & rsSeat("MinSeat") & " - " & rsSeat("MaxSeat") & "</TD>"
            Else
                Response.Write "<TD ALIGN=""center"">" & rsSeat("MinSeat") & "</TD>"
            End If            
            Response.Write "<TD ALIGN=""center"">" & rsSeat("SeatType") & "</TD>"
            Response.Write "<TD ALIGN=""center"">" & rsSeat("SeatQty") & "</TD>"
            Response.Write "<TD ALIGN=""right"">" & FormatCurrency(rsSeat("Price") - rsSeat("Discount"), 2) & "</TD>"
            Response.Write "<TD ALIGN=""right"">" & FormatCurrency(rsSeat("Amount"), 2) & "</TD>"
            Response.Write "</TR>"
            
            SeatCount = SeatCount + 1

            rsSeat.MoveNext
        Loop        

        rsSeat.Close
        Set rsSeat = nothing
        
        'Get Non-Numeric Seat Numbers
        SQLSeat = "SELECT Act.ShortAct, Section.Section, Seat.Row, Seat.Seat, SeatType.SeatType, OrderLine.Price, OrderLine.Discount, COUNT(*) AS SeatQty, SUM(Price) AS Amount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode INNER JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') AND ISNUMERIC(Seat.Seat) <> 1 GROUP BY Act.ShortAct, Section.Section, Seat.Row, Seat.Seat, SeatType.SeatType, OrderLine.Price, OrderLine.Discount ORDER BY Act.ShortAct, Section.Section, Seat.Row, Seat.Seat"
        Set rsSeat = OBJdbConnection2.Execute(SQLSeat)

        Do Until rsSeat.EOF

            Response.Write "<TR CLASS=""InvoiceDetail"">"
            Response.Write "<TD>" & rsSeat("ShortAct") & "</TD>"
            Response.Write "<TD>" & rsSeat("Section") & "</TD>"
            Response.Write "<TD ALIGN=""center"">" & rsSeat("Row") & "</TD>"
            Response.Write "<TD ALIGN=""center"">" & rsSeat("Seat") & "</TD>"
            Response.Write "<TD ALIGN=""center"">" & rsSeat("SeatType") & "</TD>"
            Response.Write "<TD ALIGN=""center"">" & rsSeat("SeatQty") & "</TD>"
            Response.Write "<TD ALIGN=""right"">" & FormatCurrency(rsSeat("Price") - rsSeat("Discount"), 2) & "</TD>"
            Response.Write "<TD ALIGN=""right"">" & FormatCurrency(rsSeat("Amount"), 2) & "</TD>"
            Response.Write "</TR>"

            SeatCount = SeatCount + 1
                
            rsSeat.MoveNext
        Loop        

        rsSeat.Close
        Set rsSeat = nothing

        'Invoice Total Section
        Response.Write "<TR CLASS=""InvoiceDetail""><TD COLSPAN=""7"">&nbsp;</TD><TD ALIGN=""right""><HR /></TR>"
        Response.Write "<TR CLASS=""InvoiceDetail""><TD COLSPAN=""7"" ALIGN=""right"">Subtotal</TD><TD ALIGN=""right"">" & FormatCurrency(rsOrders("Subtotal"), 2) & "</TD></TR>"
        'If rsOrders("Discount") > 0 Then
        '    Response.Write "<TR CLASS=""InvoiceDetail""><TD COLSPAN=""7"" ALIGN=""right"">Discount</TD><TD ALIGN=""right"">" & FormatCurrency(rsOrders("Discount") * - 1, 2) & "</TD></TR>"
        'End If
        If rsOrders("OrderSurcharge") + rsOrders("ShipFee") > 0 Then
            Response.Write "<TR CLASS=""InvoiceDetail""><TD COLSPAN=""7"" ALIGN=""right"">Service Charge</TD><TD ALIGN=""right"">" & FormatCurrency(rsOrders("OrderSurcharge") + rsOrders("ShipFee"), 2) & "</TD></TR>"
        End If
        If rsOrders("TenderAmount") > 0 Then
            Response.Write "<TR CLASS=""InvoiceDetail""><TD COLSPAN=""7"" ALIGN=""right"">Payments</TD><TD ALIGN=""right"">" & FormatCurrency(rsOrders("TenderAmount") * - 1, 2) & "</TD></TR>"
        End If
        Response.Write "<TR CLASS=""InvoiceDetail""><TD COLSPAN=""7"">&nbsp;</TD><TD ALIGN=""right""><HR /></TR>"
        Response.Write "<TR CLASS=""InvoiceDetail""><TD COLSPAN=""7"" ALIGN=""right"">TOTAL DUE</TD><TD ALIGN=""right"">" & FormatCurrency(rsOrders("Total") - rsOrders("TenderAmount"), 2) & "</TD></TR>"

        Response.Write "</TABLE>"
        
        For LineSpace = 1 To 15 - SeatCount
            Response.Write "<BR>"
        Next

        'Payment Method Section
        Response.Write "<TABLE WIDTH=""750"" BORDER=""0"">"
	    Response.Write "<TR><TD>[&nbsp;&nbsp;] My check is enclosed (make payable to Chamber Music Society of Detroit)<BR>[&nbsp;&nbsp;] I prefer to pay by:&nbsp;&nbsp;[&nbsp;&nbsp;] MasterCard&nbsp;&nbsp;&nbsp;[&nbsp;&nbsp;] Visa&nbsp;&nbsp;&nbsp;[&nbsp;&nbsp;] American Express</TD></TR></TABLE>" & vbCrLf
	    Response.Write "<TR CLASS=""InvoiceDetail""><TD><TD><BR>_____________________________________________________</TD><TD>____________</TD></TR>" & vbCrLf
	    Response.Write "<TR CLASS=""InvoiceDetail""><TD>(CVV2 (3-4 digit code))</TD></TR>" & vbCrLf
	    Response.Write "<TR CLASS=""InvoiceDetail""><TD>_________________&nbsp;&nbsp;</TD><TD>___________________________________&nbsp;&nbsp;</TD><TD>___________________________________</TD></TR>" & vbCrLf
	    Response.Write "<TR CLASS=""InvoiceDetail""><TD>(Name as it appears on card)</TD><TD>(Signature)</TD></TR>" & vbCrLf
	    Response.Write "<TR CLASS=""InvoiceDetail""><TD ALIGN=""center"">SEND TO:<BR>Chamber Music Society of Detroit<BR>31731 Northwestern Highway<BR>Suite 259-W<BR>Farmington Hills, MI 48334<BR><I>Phone Number: (248) 855-6070<BR>Fax Number: (248) 737-9981</I></TD></TR>" & vbCrLf

	    Response.Write "</TABLE>"    

        rsOrders.MoveNext
    Loop
Else
    OrdersFound = False
    Response.Write "<BR>Order Number <B>" & Request("OrderNumber") & "</B> cannot be found."
End If
rsOrders.Close
Set rsOrders = Nothing

If OrdersFound Then
%>
<SCRIPT LANGUAGE="JavaScript">
window.print();
</SCRIPT>
<% End If %>
</CENTER>

</BODY>
</HTML>

<%

End Sub 'PrintLetters

%>