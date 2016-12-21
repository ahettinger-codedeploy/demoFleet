<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp"-->
<!--#INCLUDE VIRTUAL="TicketPrintInclude.asp"-->
<!--#INCLUDE VIRTUAL="NoCacheInclude.asp"-->
<%

Server.ScriptTimeout = 600

'REE 4/15/2 - Increased Session Timeout to 30 minutes to reduce Print validation timeout issues.
Session.Timeout = 60

Page = "TicketInvoicePrintBarberShop"

'Make sure the correct Session variables are in place.  If not clear the variables and go to the menu.
If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then 
	Session.Abandon
	Response.Redirect("Default.asp")
End If

If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then 
	Session.Abandon
	Response.Redirect("Default.asp")
End If

'Decide which subroutine to route to
Select Case Request("FormName")
	Case "PrintMenu"
		Call PrintEvent
	Case "PrintEvent"
		Call DisplayTickets
	Case "OKPrint"
		Call UpdatePrintDate
	Case Else
		Call PrintMenu
End Select

'----------------------------------

Sub PrintMenu

%>
<HTML>
<HEAD>
<TITLE>www.TIX.com - Ticket Invoice Printing</TITLE>
</HEAD>
<BODY BGCOLOR="#FFFFFF">

<CENTER>

<!--#INCLUDE VIRTUAL="TopNavInclude.asp"-->
<BR>

<BR>

<FONT FACE="verdana,arial,helvetica" COLOR="#008400"><H3>Ticket Invoice Printing</H3></FONT>


<%

'Get Matching Events
'REE 4/6/2 - Modified to include OrganizationAct selection criteria
'REE 2/25/3 - Removed TicketFormat from criteria.
'REE 12/9/6 - Removed EventList to resolve Stack Space problem.  Modified to separate queries for Tix and others.
If Session("OrganizationNumber") <> 1 Then 
	SQLTickets = "SELECT COUNT(OrderLine.ItemNumber) AS TicketCount, Act.Act, EventDate, Event.EventCode, Venue, Orderline.ShipCode, ShipType FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Shipping (NOLOCK) ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN Organization (NOLOCK) ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber AND OrganizationAct.OrganizationNumber = Organization.OrganizationNumber WHERE EventDate > GETDATE()-31 AND OrderLine.StatusCode = 'S' AND OrderLine.PrintDate IS NULL AND Organization.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') GROUP BY ShipType, OrderLine.ShipCode, Event.EventCode, EventDate, Act.Act, Venue.Venue ORDER BY ShipType, OrderLine.ShipCode, EventDate"
Else
	'REE 4/6/7 - Added SQL Timeout Extension
	OBJdbConnection.CommandTimeout = 180 '3 Minutes
	'REE 4/6/7 - Modified to join Org on OrgVenue and OrgAct to prevent inflated ticket counts.
	SQLTickets = "SELECT COUNT(OrderLine.ItemNumber) AS TicketCount, Act.Act, EventDate, Event.EventCode, Venue, Orderline.ShipCode, ShipType FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Shipping (NOLOCK) ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN Organization (NOLOCK) ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber AND OrganizationAct.OrganizationNumber = Organization.OrganizationNumber WHERE EventDate > GETDATE()-1 AND OrganizationVenue.Owner = 1 AND Organization.TixFulfillment = 1 AND OrderLine.ShipCode <> 13 AND OrderLine.StatusCode = 'S' AND OrderLine.PrintDate IS NULL AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') GROUP BY ShipType, OrderLine.ShipCode, Event.EventCode, EventDate, Act.Act, Venue.Venue ORDER BY ShipType, OrderLine.ShipCode, EventDate"
End If	
Set rsTickets = OBJdbConnection.Execute(SQLTickets)
	
'REE 4/6/2 - Modified to check for events.
If Not rsTickets.EOF Then 'There are some events.  List them
	Response.Write "<FORM ACTION=""TicketInvoicePrintBarberShop.asp"" METHOD=""post""><INPUT TYPE=""hidden"" NAME=""FormName"" VALUE=""PrintMenu"">" & vbCrLf

	ShipCode = rsTickets("ShipCode")
	Response.Write "<TABLE CELLPADDING=""3""><TR BGCOLOR=""#008400""><TD ALIGN=""left"" COLSPAN=""5""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>" & rsTickets("ShipType") & "</B></FONT></TD></TR>" & vbCrLf
	Response.Write "<TR BGCOLOR=""#666666""><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Print</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Event</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Venue</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Date/Time</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>UnPrinted Tickets</B></FONT></TD></TR>" & vbCrLf

	'Display Event and UnPrinted Ticket Quantities
	Do Until rsTickets.EOF
		If rsTickets("ShipCode") <> ShipCode Then
			ShipCode = rsTickets("ShipCode")
			Response.Write "<TR BGCOLOR=""#FFFFFF""><TD COLSPAN=""5"">&nbsp;</TD></TR>" & vbCrLf
			Response.Write "<TR BGCOLOR=""#008400""><TD ALIGN=""left"" COLSPAN=""5""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>" & rsTickets("ShipType") & "</B></FONT></TD></TR>" & vbCrLf
			Response.Write "<TR BGCOLOR=""666666""><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Print</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Event</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Venue</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Date/Time</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>UnPrinted Tickets</B></FONT></TD></TR>" & vbCrLf
		End If
		ShipPad = "0000" & rsTickets("ShipCode")
		ShipPad = right(ShipPad,4)
		CheckboxValue = ShipPad & rsTickets("EventCode")

		Response.Write "<TR BGCOLOR=""DDDDDD""><TD ALIGN=""center""><INPUT TYPE=""checkbox"" NAME=""ShipEvent"" VALUE=" & CheckboxValue & "></FONT></TD><TD><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">" & rsTickets("Act") & "</FONT></TD><TD><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">" & rsTickets("Venue") & "</FONT></TD><TD ALIGN=""center"" NOWRAP><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">" & DateAndTimeFormat(rsTickets("EventDate")) & "</FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">" & rsTickets("TicketCount") & "</FONT></TD></TR>" & vbCrLf

		rsTickets.MoveNext
	Loop
			
	Response.Write "</TABLE><BR>" & vbCrLf
	'Display Buttons to Print
	Response.Write "<FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">Select Events to print and click 'Print' below.</FONT><BR><BR>" & vbCrLf
	Response.Write "<INPUT TYPE=""submit"" VALUE=""Print""></FORM>" & vbCrLf
Else 'There aren't any matching events
	Response.Write "<BR><BR><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">There are no events to be printed.</FONT><BR><BR>" & vbCrLf
End If
%>

</CENTER>

<!--#INCLUDE VIRTUAL="FooterInclude.asp"-->

</BODY>
</HTML>

<%

End Sub 'PrintMenu

'---------------------------------

Sub PrintEvent

'Server.ScriptTimeout = 600

'Set the Print Date and Time
PrintDate = Now()

%>

<HTML>
<HEAD>
<TITLE>www.TIX.com - Invoice Ticket Printing</TITLE>
<SCRIPT LANGUAGE="JavaScript">
<!-- Begin
	function PrintInvoices(){
		window.print(); 
		TicketPrintForm.submit();
		}

//  End -->
</SCRIPT>
</HEAD>
<BODY onLoad="PrintInvoices()" LEFTMARGIN="0" RIGHTMARGIN="0" TOPMARGIN="0" MARGINHEIGHT="0" MARGINWIDTH="0">

<STYLE>	
	div {page-break-before: always}
</STYLE>

<FONT COLOR="#000000">
<%

'REE 5/3/5 - Added Code for Invoice Print Logging
'JAI 10/24/7 - Changed to Stored Procedure
Set spInsertInvoicePrintBatch = Server.Createobject("Adodb.Command")
Set spInsertInvoicePrintBatch.ActiveConnection = OBJdbConnection
spInsertInvoicePrintBatch.Commandtype = 4 ' Value for Stored Procedure
spInsertInvoicePrintBatch.Commandtext = "spInsertInvoicePrintBatch"
spInsertInvoicePrintBatch.Parameters.Append spInsertInvoicePrintBatch.CreateParameter("BatchNumber", 3, 4) 'As Integer and ParamReturnValue
spInsertInvoicePrintBatch.Parameters.Append spInsertInvoicePrintBatch.CreateParameter("BatchDate", 7, 1, , Now()) 'As Date and Input
spInsertInvoicePrintBatch.Parameters.Append spInsertInvoicePrintBatch.CreateParameter("UserNumber", 3, 1, , Session("UserNumber")) 'As Integer and Input
spInsertInvoicePrintBatch.Parameters.Append spInsertInvoicePrintBatch.CreateParameter("BatchType", 200, 1, 50, "Invoice Batch Print") 'As Varchar and Input
spInsertInvoicePrintBatch.Execute
BatchNumber = spInsertInvoicePrintBatch.Parameters("BatchNumber")

Response.Write "<FORM ACTION=""TicketInvoicePrintBarberShop.asp"" METHOD=""post"" NAME=""TicketPrintForm""><INPUT TYPE=""hidden"" NAME=""FormName"" VALUE=""PrintEvent"">" & vbCrLf
'Build the Query to select each of the selected events
'REE 7/7/3 - Removed EventShip from Query.
SQLOrderLine = "SELECT OrderHeader.OrderTypeNumber, OrderHeader.OrderSurcharge, OrderHeader.ShipFee, OrderHeader.Total, OrderLine.OrderNumber, OrderLine.LineNumber, OrderLine.ItemNumber, OrderLine.Price, OrderLine.Surcharge, OrderLine.Discount, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry, OrderLine.ShipCode, Event.EventCode, Event.EventDate, Event.Map, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, PostalCode, Customer.DayPhone, Customer.NightPhone, Customer.EMailAddress, Shipping.ShipType, Act.Act, Venue.Venue, SeatType.SeatType, Seat.Row, Seat.Seat, Seat.SectionCode, Section.Section FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.SectionCode = Section.SectionCode AND Event.EventCode = Section.EventCode INNER JOIN Act ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN Shipping (NOLOCK) ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode "
For Each Item In Request("ShipEvent") 'Loop for each Event requested
	EventNumber = EventNumber + 1
	If SQLWhere = "" Then 
		SQLWhere = " WHERE ((Event.EventCode = " & right(Request("ShipEvent")(EventNumber),len(Request("ShipEvent")(EventNumber))-4) & "AND OrderLine.ShipCode = " & left(Request("ShipEvent")(EventNumber),4) & ") "
	Else
		SQLWhere = SQLWhere & "OR (Event.EventCode = " & right(Request("ShipEvent")(EventNumber),len(Request("ShipEvent")(EventNumber))-4) & "AND OrderLine.ShipCode = " & left(Request("ShipEvent")(EventNumber),4) & ") "
	End If
Next

'Get the Info to Print
'REE 4/6/2 - Modified to use OrganizationAct in selection criteria
SQLOrderLine = SQLOrderLine & SQLWhere & ") AND OrderLine.StatusCode = 'S' AND OrderLine.PrintDate IS NULL AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') ORDER BY OrderLine.OrderNumber, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry, OrderLine.ShipCode, Seat.EventCode, Seat.SectionCode, RowSort, SeatSort DESC"
Set rsOrderLine = OBJdbConnection.Execute(SQLOrderLine)

Call DBOpen(OBJdbConnection2)
		
Do Until rsOrderLine.EOF
   
	'Check to see if we've printed an address label exactly like this already
	NewAddress = rsOrderLine("OrderNumber") & rsOrderLine("ShipFirstName") & rsOrderLine("ShipLastName") & rsOrderLine("ShipAddress1") & rsOrderLine("ShipAddress2") & rsOrderLine("ShipCity") & rsOrderLine("ShipState") & rsOrderLine("ShipPostalCode") & rsOrderLine("ShipCountry") & rsOrderLine("ShipCode")
	If NewAddress <> LastAddress Then 'It's different.  Print it.
		If TicketCount > 0 Then 'It's not the first one, print the footer.
		
			'REE 11/2/2 - Added Donation Display
			SQLDonation = "SELECT Donation.Description, OrderLine.Price, OrderLine.LineNumber FROM OrderLine (NOLOCK) INNER JOIN Donation (NOLOCK) ON OrderLine.ItemNumber = Donation.ItemNumber WHERE OrderLine.OrderNumber = " & LastOrderNumber & " AND OrderLine.ItemType = 'Donation' ORDER BY OrderLine.LineNumber"
			Set rsDonation = OBJdbConnection2.Execute(SQLDonation)
			
			If Not rsDonation.EOF Then 'There's a donation.  Display the column headings.
			    Response.Write "<table WIDTH=""100%"" border=0>"
		        Response.Write "<TR><TD COLSPAN=" & NumColumns & "><HR></TD></TR>" & vbCrLf
		        Response.Write "<TR><TD COLSPAN=" & NumColumns - 1 & "><B><U>Donation/Membership</U></B></TD><TD ALIGN=""right""><B><U>Amount</U></B></TD></TR>" & vbCrLf
						
		    Do Until rsDonation.EOF
			    Response.Write "<TR><TD COLSPAN=" & NumColumns - 1 & ">" & rsDonation("Description") & "</TD><TD ALIGN=""right"">" & FormatCurrency(rsDonation("Price"),2) & "</TD></TR>" & vbCrLf
			    rsDonation.MoveNext
		    Loop
            Response.Write "</table>"
	End If
				
			rsDonation.Close
			Set rsDonation = nothing

			Response.Write "<table WIDTH=""100%"" border=0><tr><TD>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf
'			If LastOrderSurcharge <> 0 Then
'				Response.Write "<TR><TD ALIGN=""right"">Service Fee</TD><TD ALIGN=""right"">" & FormatCurrency(LastOrderSurcharge,2) & "</TD></TR>" & vbCrLf
'			End If
			If LastShipFee <> 0 And LastOrderTypeNumber <> 5 Then
				Response.Write "<TR><TD ALIGN=""right"" width=""50%"">Processing Fee</TD><TD ALIGN=""right"">" & FormatCurrency(LastShipFee,2) & "</TD></TR>" & vbCrLf
				Response.Write "<TR><TD width=""50%"">&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf
			End If
'			If LastDiscount <> 0 Then
'				Response.Write "<TR><TD ALIGN=""right"">Discount</TD><TD ALIGN=""right"">-" & FormatCurrency(LastDiscount,2) & "</TD></TR>" & vbCrLf
'			End If
			Response.Write "<TR><TD ALIGN=""right"" width=""50%"">Total</TD><TD ALIGN=""right"" >" & FormatCurrency(LastTotal,2) & "</TD></TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf
			Response.Write "</CENTER>" & vbCrLf
			Response.Write "<div></div>" & vbCrLf
			
			'REE 4/10/7 - Added Response.Flush to prevent response buffer from filling up.
			BufferCount = BufferCount + 1
			If BufferCount >= 100 Then
				Response.Flush
				BufferCount = 0
			End If
			
		End If
				
		SQLOrganization = "SELECT OrganizationNumber FROM Event (NOLOCK) INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Venue.VenueCode = OrganizationVenue.VenueCode WHERE EventCode = " & rsOrderLine("EventCode") & " AND Owner = 1"
		Set rsOrganization = OBJdbConnection2.Execute(SQLOrganization)
		OrganizationNumber = rsOrganization("OrganizationNumber")
		rsOrganization.Close
		Set rsOrganization = nothing
		
%>
		<!--#INCLUDE VIRTUAL="TicketInvoicePrintInclude.asp"-->
<%		

		SQLTender = "SELECT SUM(Tender.Amount) AS CCAmount FROM Tender (NOLOCK) INNER JOIN TenderType (NOLOCK) ON Tender.TenderNumber = TenderType.TenderNumber WHERE Tender.OrderNumber = " & rsOrderLine("OrderNumber") & " AND TenderType.TenderMethod = 'Credit Card'"
		Set rsTender = OBJdbConnection2.Execute(SQLTender)

		If rsTender("CCAmount") > 0 AND OrganizationNumber <> 9 Then 'Get the Merchant Account.  Don't print cc info if it's Bethlehem.
		
			'REE 9/21/6 - Added use of OBJdbConnection3 and extended use of OBJdbConnection2.  Modified to use Organization and Merchant Account variables and close recordsets when possible.
			Call DBOpen(OBJdbConnection3)
			
			SQLOrganization = "SELECT Organization, MerchantAccountNumber FROM Organization (NOLOCK) WHERE OrganizationNumber = " & OrganizationNumber
			Set rsOrganization = OBJdbConnection3.Execute(SQLOrganization)
			
			Organization = rsOrganization("Organization")
			MerchantAccountNumber = rsOrganization("MerchantAccountNumber")
			
			rsOrganization.Close
			Set rsOrganization = nothing
		
			SQLOrganizationTix = "SELECT MerchantAccountNumber FROM Organization (NOLOCK) WHERE OrganizationNumber = 1"
			Set rsOrganizationTix = OBJdbConnection3.Execute(SQLOrganizationTix)
			
			TixMerchantAccountNumber = rsOrganizationTix("MerchantAccountNumber")
			
			rsOrganizationTix.Close
			Set rsOrganizationTix = nothing

			If MerchantAccountNumber = TixMerchantAccountNumber Then 'It's Tix's Merchant Account
				Response.Write "Please Note:  Your credit card statement will reflect a charge from www.TIX.com in the amount of " & FormatCurrency(rsTender("CCAmount"),2) & "." & vbCrLf
			Else
				'REE 9/21/6 - Added CCBillingName option.  Added use of OBJdbConnection2 and OBJdbConnection3
				SQLCCBilling = "SELECT OptionValue AS CCBilling FROM OrganizationOptions (NOLOCK) WHERE OrganizationNumber = " & OrganizationNumber & " AND OptionName = 'CreditCardBillingName'"
				Set rsCCBilling = OBJdbConnection3.Execute(SQLCCBilling)
				If Not rsCCBilling.EOF Then
					CCBillingName = rsCCBilling("CCBilling")
				Else
					CCBillingName = Organization
				End If
				rsCCBilling.Close
				Set rsCCBilling = nothing

				Response.Write "Please Note:  Your credit card statement will reflect a charge from " & CCBillingName & " in the amount of " & FormatCurrency(rsTender("CCAmount"),2) & "." & vbCrLf

			End If
					
		End If
		
		Response.Write "</TD></TR></TABLE>" & vbCrLf	

		Response.Write "<HR><TABLE CELLPADDING=""3"" WIDTH=""100%"" border=0><TR><TD><B>Order Number:&nbsp;" & rsOrderLine("OrderNumber") & "</B><BR></TD></TR></TABLE>" & vbCrLf
				
		LastAddress = NewAddress
'		LastOrderNumber = rsOrderLine("OrderNumber")
		LastOrderTypeNumber = rsOrderLine("OrderTypeNumber")
				
		'Update the Footer Totals
		LastOrderSurcharge = rsOrderLine("OrderSurcharge")
		LastShipType = rsOrderLine("ShipType")
		LastShipFee = rsOrderLine("ShipFee")
		LastDiscount = rsOrderLine("Discount")
		LastTotal = rsOrderLine("Total")

		TicketCount = TicketCount + 1

	End If

	'Print Event Info and Column Headings if this is a new Event
'	Response.Write "LastEventCode - " & LastEventCode & " | "
'	Response.Write "EventCode - " & rsOrderLine("EventCode") & "<BR>"
	If LastEventCode <> rsOrderLine("EventCode") Or LastOrderNumber <> rsOrderLine("OrderNumber") Then
        Response.Write "<TABLE WIDTH=""100%"" border=0><TR><TD>___________<BR><B>" & rsOrderLine("Act") & " at " & rsOrderLine("Venue")
    		
	    'REE 6/5/6 - Modified to look at EventOptions for Date & Time Display Options
        SQLDateSuppress = "SELECT OptionValue AS DateSuppress FROM EventOptions (NOLOCK) WHERE EventCode = " & rsOrderLine("EventCode") & " AND OptionName = 'DateSuppress' AND OptionValue = 'Y'"
        Set rsDateSuppress = OBJdbConnection2.Execute(SQLDateSuppress)
        If rsDateSuppress.EOF Then
            Response.Write " on " & FormatDateTime(rsOrderLine("EventDate"),vbShortDate)
        End If
        rsDateSuppress.Close
        Set rsDateSuppress = nothing

        SQLTimeSuppress = "SELECT OptionValue AS TimeSuppress FROM EventOptions (NOLOCK) WHERE EventCode = " & rsOrderLine("EventCode") & " AND OptionName = 'TimeSuppress' AND OptionValue = 'Y'"
        Set rsTimeSuppress = OBJdbConnection2.Execute(SQLTimeSuppress)
        If rsTimeSuppress.EOF Then
            Response.Write " at " & Left(FormatDateTime(rsOrderLine("EventDate"),vbLongTime),Len(FormatDateTime(rsOrderLine("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsOrderLine("EventDate"),vbLongTime),3)
        End If
        rsTimeSuppress.Close
        Set rsTimeSuppress = nothing

        Response.Write "</B><BR>Delivery Method: " & rsOrderLine("ShipType") & "</TD></TR></TABLE>" & vbCrLf
        'Calculate Number of Columns
		SQLNumColumns = "SELECT SUM(OrderLine.Surcharge) AS ServiceFee, SUM(OrderLine.Discount) AS Discount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & rsOrderLine("OrderNumber") & " AND ItemType IN ('Seat', 'SubFixedEvent')"
		Set rsNumColumns = OBJdbConnection2.Execute(SQLNumColumns)

        
		NumColumns = 6
		ColFacilityCharge = "N"
		ColServiceFee = "N"
		ColDiscount = "N"
		ColumnHeading = "<TABLE WIDTH=""100%"" border=0><TR><TD width=189><B><U>Section</U></B></TD><TD ALIGN=center><B><U>Row</U></B></TD><TD ALIGN=center><B><U>Seat</U></B></TD><TD><B><U>Type</U></B></TD><TD ALIGN=right><B><U>Price</U></B></TD>"
        GAHeading = ""
		FacilityCharge = 0
		If FacilityCharge <> 0 Then
		    NumColumns = NumColumns + 1
			ColumnHeading = ColumnHeading + "<TD ALIGN=right><B><U>Facility Charge</U></B></TD>"
			GAHeading = "<TD ALIGN=right nowrap><B><U>Facility Charge</U></B></TD>"
		    ColFacilityCharge = "Y"
		End If		
		If rsNumColumns("Discount") <> 0 Then
		    NumColumns = NumColumns + 1
		    ColumnHeading = ColumnHeading + "<TD ALIGN=right><B><U>Discount</U></B></TD>"
		    GAHeading = GAHeading + "<TD ALIGN=right nowrap><B><U>Discount</U></B></TD>"
		    ColDiscount = "Y"
		 End If
        If rsNumColumns("ServiceFee") <> 0 Then
		    NumColumns = NumColumns + 1
		    ColumnHeading = ColumnHeading + "<TD ALIGN=right><B><U>Service Fee</U></B></TD>"
		    GAHeading = GAHeading + "<TD ALIGN=right nowrap><B><U>Service Fee</U></B></TD>"
		    ColServiceFee = "Y"
		End If
		 rsNumColumns.Close
		 Set rsNumColumns = nothing

		 ColumnHeading = ColumnHeading + "<TD ALIGN=right><B><U>Amount</U></B></TD></TR>" & vbCrLf
		    
    	
        'EM 05/04/07 Modified to exclude the heading when there is  a General Admission ticket
        If (rsOrderLine("Section") <> "General Admission" And rsOrderLine("Seat") <> "GA") then	
            Response.Write ColumnHeading
        End IF 'Exclude GA
        
		 
			
        'Print the detail
        'Add the OrderNumber and LineNumber to the Form
        LineDetail = "<TR><TD><INPUT TYPE=""hidden"" NAME=""OrderNumber"" VALUE=" & rsOrderLine("OrderNumber") & "><INPUT TYPE=""hidden"" NAME=""LineNumber"" VALUE=" & rsOrderLine("LineNumber") & ">"
	
	
        'EM 05/04/07 Modified to exclude General Admission individual lines 
        If (rsOrderLine("Section") = "General Admission" And rsOrderLine("Seat") = "GA")  then
	        LineDetail = ""
	    
            'EM 05/04/07 - Print Totals and Line Detail for the General Admission seats
	        SQLGeneralAdmission = "SELECT count (Seat.Seat) as SeatCount, OrderLine.OrderNumber, SeatType.SeatType, Section.Section, OrderLine.Price, OrderLine.Discount, OrderLine.Surcharge,OrderLine.ShipCode, Event.EventCode, Shipping.ShipType, Act.Act, Venue.Venue, Event.EventDate FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK)ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.SectionCode = Section.SectionCode AND Event.EventCode = Section.EventCode INNER JOIN Act ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN Shipping (NOLOCK) ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode "
            SQLGeneralAdmission = SQLGeneralAdmission & SQLWhere &  ") AND OrderLine.StatusCode = 'S' AND OrderLine.PrintDate IS NULL AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & "AND  Event.EventCode = "& rsOrderLine("EventCode")&" AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') AND Seat.SectionCode ='GA' AND OrderLine.OrderNumber = " & rsOrderLine("OrderNumber") & "  GROUP BY OrderLine.OrderNumber,OrderLine.ShipCode, Event.EventCode, Shipping.ShipType, Act.Act, Venue.Venue, Event.EventDate, Section.Section ,SeatType.SeatType, OrderLine.Price, OrderLine.Discount, OrderLine.Surcharge  " 
            Set rsGeneralAdmission = OBJdbConnection.Execute(SQLGeneralAdmission)
            
            If Not rsGeneralAdmission.EOF then 'There are General Admission Tickets
                 
                If LastEventCode <> rsOrderLine("EventCode") Or LastOrderNumber <> rsOrderLine("OrderNumber") Then
                    Response.Write "<TR><TD COLSPAN=" & NumColumns & "><table WIDTH=""100%"" border=0><tr><td nowrap><B><U>Section</U></B></TD><TD><B><U>Type</U></B></TD><TD ALIGN=center nowrap><B><U># of Seats</U></B></TD><TD nowrap ALIGN=""right""><B><U>Price</U></B></TD>"& GAHeading &"<TD nowrap ALIGN=""right""><B><U>Amount</U></B></TD></TR>" & vbCrLf
                    Do until rsGeneralAdmission.EOF
		                GAFeesColumn = ""
		                If ColFacilityCharge = "Y" Then
		                    GAFeesColumn =  "<TD ALIGN=right>" & FormatCurrency(FacilityCharge,2) & "</TD>"
	                    End If
	                    If ColServiceFee = "Y" Then
		                    GAFeesColumn = GAFeesColumn & "<TD ALIGN=right>" & FormatCurrency(((rsGeneralAdmission("Surcharge"))* (rsGeneralAdmission("SeatCount"))),2) & "</TD>"
	                    End If
	                    If ColDiscount = "Y" Then
		                    GAFeesColumn = GAFeesColumn & "<TD ALIGN=right>" & FormatCurrency(((rsGeneralAdmission("Discount"))* (rsGeneralAdmission("SeatCount"))),2) & "</TD>"
	                    End If                        	    
		                Response.Write "<TR><TD nowrap >" & rsGeneralAdmission("Section") & "</TD><TD  nowrap>" & rsGeneralAdmission("SeatType") & "</TD><TD ALIGN=""center""  nowrap>" & rsGeneralAdmission("SeatCount") & "</TD><TD ALIGN=right nowrap>" & FormatCurrency(rsGeneralAdmission("Price"),2) & "</TD>" & GAFeesColumn & "<TD ALIGN=right nowrap>" & FormatCurrency(((rsGeneralAdmission("Price"))* (rsGeneralAdmission("SeatCount")))+FacilityFee+rsGeneralAdmission("Surcharge")-rsGeneralAdmission("Discount"),2) & "</TD></TR>" & vbCrLf
			            rsGeneralAdmission.MoveNext
		            Loop
		        End if
                Response.Write "</table></TD></TR>"
	        End If
	        rsGeneralAdmission.Close
	        Set rsGeneralAdmission = nothing
      
	    Else
	        LineDetail = LineDetail & "<TR><TD width=189>" & rsOrderLine("Section") & "</TD><TD ALIGN=center>" & rsOrderLine("Row") & "</TD><TD ALIGN=center>" & rsOrderLine("Seat") & "</TD><TD>" & rsOrderLine("SeatType") & "</TD><TD ALIGN=right>" & FormatCurrency(rsOrderLine("Price"),2) & "</TD>"
        	
	        If ColFacilityCharge = "Y" Then
		        LineDetail = LineDetail & "<TD ALIGN=right  nowrap>" & FormatCurrency(FacilityCharge,2) & "</TD>"
	        End If
	        If ColServiceFee = "Y" Then
		        LineDetail = LineDetail & "<TD ALIGN=right  nowrap>" & FormatCurrency(rsOrderLine("Surcharge"),2) & "</TD>"
	        End If
	        If ColDiscount = "Y" Then
		        LineDetail = LineDetail & "<TD ALIGN=right nowrap>" & FormatCurrency(rsOrderLine("Discount"),2) & "</TD>"
	        End If
        	
	    LineDetail = LineDetail & "<TD ALIGN=right>" & FormatCurrency(rsOrderLine("Price")+FacilityFee+rsOrderLine("Surcharge")-rsOrderLine("Discount"),2) & "</TD></TR>" & vbCrLf
	    End If 'Exclude GA
	
	LastEventCode = rsOrderLine("EventCode")	
	Response.Write LineDetail	
	End If
	
	
	
	'REE 5/4/5 - Added Invoice Print Logging
	SQLInvoiceLog = "INSERT InvoicePrintLog(BatchNumber, OrderNumber, ItemNumber, PrintDate, UserNumber) VALUES(" & BatchNumber & ", " & rsOrderLine("OrderNumber") & ", " & rsOrderLine("ItemNumber") & ", GETDATE(), " & Session("UserNumber") & ")"
	Set rsInvoiceLog = OBJdbConnection2.Execute(SQLInvoiceLog)

	LastOrderNumber = rsOrderLine("OrderNumber")	
	rsOrderLine.MoveNext		
Loop	

Call DBClose(OBJdbConnection2)	
If TicketCount > 0 Then	'Print the last footer      
    
	'REE 11/2/2 - Added Donation Display
	SQLDonation = "SELECT Donation.Description, OrderLine.Price, OrderLine.LineNumber FROM OrderLine (NOLOCK) INNER JOIN Donation (NOLOCK) ON OrderLine.ItemNumber = Donation.ItemNumber WHERE OrderLine.OrderNumber = " & LastOrderNumber & " AND OrderLine.ItemType = 'Donation' ORDER BY OrderLine.LineNumber"
	Set rsDonation = OBJdbConnection.Execute(SQLDonation)
					
	If Not rsDonation.EOF Then 'There's a donation.  Display the column headings.
	    Response.Write "<table WIDTH=""100%"" border=0>"
		Response.Write "<TR><TD COLSPAN=" & NumColumns & "><HR></TD></TR>" & vbCrLf
		Response.Write "<TR><TD COLSPAN=" & NumColumns & "><table WIDTH=""100%"" border=0><tr><TD COLSPAN=" & NumColumns - 1 & "><B><U>Donation/Membership</U></B></TD><TD ALIGN=""right""><B><U>Amount</U></B></TD></TR>" & vbCrLf
						
		Do Until rsDonation.EOF
			Response.Write "<TR><TD COLSPAN=" & NumColumns - 1 & ">" & rsDonation("Description") & "</TD><TD ALIGN=""right"">" & FormatCurrency(rsDonation("Price"),2) & "</TD></TR>" & vbCrLf
			rsDonation.MoveNext
		Loop
        Response.Write "</table>"
	End If
					
	rsDonation.Close
	Set rsDonation = nothing

	Response.Write "<table WIDTH=""100%"" border=0><tr><TD>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf
'	If LastOrderSurcharge <> 0 Then
'		Response.Write "<TR><TD ALIGN=""right"">Service Fee</TD><TD ALIGN=""right"">" & FormatCurrency(LastOrderSurcharge,2) & "</TD></TR>" & vbCrLf
'	End If
	If LastShipFee <> 0 And LastOrderTypeNumber <> 5 Then
		Response.Write "<TR><TD ALIGN=""right"" width=""50%"">Processing Fee</TD><TD ALIGN=""right"">" & FormatCurrency(LastShipFee,2) & "</TD></TR>" & vbCrLf
		Response.Write "<TR><TD width=""50%"">&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf
	End If
'	If LastDiscount <> 0 Then
'		Response.Write "<TR><TD ALIGN=""right"">Discount</TD><TD ALIGN=""right"">-" & FormatCurrency(LastDiscount,2) & "</TD></TR>" & vbCrLf
'	End If
	
	Response.Write "<TR><TD ALIGN=""right"" width=""50%"">Total</TD><TD ALIGN=""right"">" & FormatCurrency(LastTotal,2) & "</TD></TR>" & vbCrLf
	Response.Write "</TABLE>" & vbCrLf
	Response.Write "</CENTER>" & vbCrLf
End If

'REE 10/28/3 - Check Org Options for Mac User.  If Mac User, the window does not automatically print.  Display a 'Continue' button to get to the next page.
SQLMac = "SELECT OptionValue AS MacUser FROM OrganizationOptions (NOLOCK) WHERE OrganizationNumber = " & Session("OrganizationNumber") & " AND OptionName = 'MacUser' AND OptionValue = 'Y'"
Set rsMac = OBJdbConnection.Execute(SQLMac)

If Not rsMac.EOF Then 'Display the button.
	Response.Write "<div></div>" & vbCrLf
	Response.Write "<BR><BR><HR><BR><BR><CENTER>Print the Invoices using the Browser Print function then click on the 'Continue' button below.<BR><BR>" & vbCrLf
	Response.Write "<INPUT TYPE=""submit"" VALUE=""Continue""></CENTER><BR><BR><BR>" & vbCrLf
End If

rsMac.Close
Set rsMac = nothing


Response.Write "</FORM>"

rsOrderLine.Close
Set rsOrderLine = nothing

%>
</FONT>
</BODY>
</HTML>

<%

End Sub 'PrintEvent

'----------------------------

Sub DisplayTickets

%>
<HTML>
<HEAD>
<TITLE>www.TIX.com - Ticket Invoice Printing</TITLE>
<SCRIPT LANGUAGE="JavaScript">    

<!-- Hide code from non-js browsers
	function loadForm() {
		formObj = document.OKPrint;
		formObj.Button.focus();
	}
// end hiding -->
</SCRIPT>

</HEAD>
<BODY onLoad="loadForm()">
<CENTER>

<!--#INCLUDE VIRTUAL="TopNavInclude.asp"-->

<FORM ACTION="TicketInvoicePrintBarberShop.asp" METHOD="post" NAME="OKPrint"><INPUT TYPE="hidden" NAME="FormName" VALUE="OKPrint">
<TABLE CELLPADDING="5">
<%

'Get Each Order Number from the previous form
For Each Item In Request("OrderNumber")
	
	'This sets the position of the Request("OrderNumber") and Request("LineNumber") arrays
	ArrayPos = ArrayPos + 1
	OrderNumber = Request("OrderNumber")(ArrayPos)
	LineNumber = Request("LineNumber")(ArrayPos)

	'Get Ticket Header Info
'	SQLTicketHeader = "SELECT * FROM OrderLine INNER JOIN Seat ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode WHERE OrderLine.OrderNumber = " & OrderNumber & " ORDER BY OrderLine.OrderNumber, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry, OrderLine.ShipCode"
	'REE 4/6/2 - Modified to include OrganizationAct selection criteria
	SQLOrderLine = "SELECT * FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Shipping (NOLOCK) ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.LineNumber = " & LineNumber & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') ORDER BY Seat.EventCode, Seat.SectionCode, RowSort, SeatSort DESC"
	Set rsOrderLine = OBJdbConnection.Execute(SQLOrderLine)

	Do Until rsOrderLine.EOF
		'Check to see if we've printed a header exactly like this already
		NewAddress = rsOrderLine("OrderNumber") & rsOrderLine("ShipFirstName") & rsOrderLine("ShipLastName") & rsOrderLine("ShipAddress1") & rsOrderLine("ShipAddress2") & rsOrderLine("ShipCity") & rsOrderLine("ShipState") & rsOrderLine("ShipPostalCode") & rsOrderLine("ShipCountry") & rsOrderLine("ShipCode")
		If NewAddress <> LastAddress Then 'It's different.  Print it.
			Response.Write "<TR><TD COLSPAN=""9"">&nbsp;</TD></TR>" & vbCrLf	
			Response.Write "<TR BGCOLOR=""#008400""><TD COLSPAN=""9""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2"">Order Number: " & rsOrderLine("OrderNumber") & " " & rsOrderLine("ShipFirstName") & " " & rsOrderLine("ShipLastName") & " " & rsOrderLine("ShipAddress1") & " " & rsOrderLine("ShipAddress2") & " " & rsOrderLine("ShipCity") & ", " & rsOrderLine("ShipState") & " " & rsOrderLine("ShipPostalCode") & "</FONT></TD></TR>" & vbCrLf
			Response.Write "<TR BGCOLOR=""#99CC99""><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">Ticket #</FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">Event</FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">Venue</FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">Date/Time</FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">Section</FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">Row</FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">Seat</FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">Seat Type</FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">Price</FONT></TD></TR>" & vbCrLf
			LastAddress = NewAddress

			'REE 4/10/7 - Added Response.Flush to prevent response buffer from filling up.
			BufferCount = BufferCount + 1
			If BufferCount >= 100 Then
				Response.Flush
				BufferCount = 0
			End If
			
		End If
		
		'Get the Ticket Detail	
	'	SQLTicketDetail = "SELECT * FROM OrderLine INNER JOIN OrderHeader ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN Seat ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event ON Seat.EventCode = Event.EventCode INNER JOIN Act ON Event.ActCode = Act.ActCode INNER JOIN Venue ON Event.VenueCode = Venue.VenueCode INNER JOIN Shipping ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN SeatType ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN Section ON Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & rsOrderLineHeader("OrderNumber") & " AND OrderLine.LineNumber = " & rsOrderLineHeader("LineNumber") & " AND Organization.OrganizationNumber = " & OrganizationNumber
	'	Set rsTicketDetail = OBJdbConnection.Execute(SQLTicketDetail)

	
		'Print the Ticket Detail
'		Do Until rsTicketDetail.EOF
			Response.Write "<TR BGCOLOR=""#DDDDDD""><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2""><INPUT TYPE=""hidden"" NAME=""OrderNumber"" VALUE=" & rsOrderLine("OrderNumber") & "><INPUT TYPE=""hidden"" NAME=""LineNumber"" VALUE=" & rsOrderLine("LineNumber") & ">" & rsOrderLine("ItemNumber") & "</FONT></TD><TD><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsOrderLine("Act") & "</FONT></TD><TD><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsOrderLine("Venue") & "</FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsOrderLine("EventDate") & "</FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsOrderLine("SectionCode") & "</FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsOrderLine("Row") & "</FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsOrderLine("Seat") & "</FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsOrderLine("SeatType") & "</FONT></TD><TD ALIGN=""right""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & FormatNumber(rsOrderLine("Price"),2) & "</FONT></TD></TR>" & vbCrLf
'			rsTicketDetail.MoveNext
'		Loop
		rsOrderLine.MoveNext
		
	Loop
		
Next

Response.Write "</TABLE><BR>" & vbCrLf
'Set Focus to Ticket Printing Menu Button
'Find Tickets based on Print Date, Organization, etc.
'List Tickets
'Display Button to return to Ticket Printing Menu
Response.Write "<FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">Did the invoices print properly?</FONT><BR>" & vbCrLf
Response.Write "<TABLE CELLPADDING=""10""><TR><TD><INPUT TYPE=""submit"" VALUE=""Yes"" NAME=""Button""></FORM></TD><TD><FORM ACTION=""TicketInvoicePrintBarberShop.asp"" METHOD=""post"" NAME=""NoPrint""><INPUT TYPE=""hidden"" NAME=""FormName"" VALUE=""NoPrint""><INPUT TYPE=""submit"" VALUE=""No""></FORM></TD></TR></TABLE>" & vbCrLf

%>

</CENTER>

<!--#INCLUDE VIRTUAL="FooterInclude.asp"-->

</BODY>
</HTML>

<%

End Sub 'DisplayTickets

'------------------------------

Sub UpdatePrintDate

'Set Print Date
PrintDate = Now()

'Loop Through The Order Lines from DisplayTickets Sub
For Each Item In Request("OrderNumber")
	
	'This sets the position of the Request("OrderNumber") and Request("LineNumber") arrays
	ArrayPos = ArrayPos + 1
	OrderNumber = Request("OrderNumber")(ArrayPos)
	LineNumber = Request("LineNumber")(ArrayPos)

	'REE 8/24/3 - Modified to update lines with LineNumber as ParentLineNumber (Child Lines).	
	SQLUpdatePrintDate = "UPDATE OrderLine WITH (ROWLOCK) SET PrintDate = '" & PrintDate & "' WHERE OrderNumber = " & OrderNumber & " AND (LineNumber = " & LineNumber & " OR ParentLineNumber = " & LineNumber & ")"
	Set rsUpdatePrintDate = OBJdbConnection.Execute(SQLUpdatePrintDate)

	'REE 4/26/5 - Added Security Log
	SecurityLog("Ticket Invoice Print - Order #" & OrderNumber & " Line Number #" & LineNumber)
	
Next

Call PrintMenu

End Sub 'UpdatePrintDate
%>