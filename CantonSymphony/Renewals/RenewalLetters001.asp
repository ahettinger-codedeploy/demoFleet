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
End If

If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then 
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
<TITLE>www.TIX.com - Subscription Renewal Letters</TITLE>
</HEAD>
<BODY BGCOLOR="#FFFFFF">

<CENTER>

<!--#INCLUDE VIRTUAL="TopNavInclude.asp"-->
<BR>

<BR>

<FONT FACE="verdana,arial,helvetica" COLOR="#008400"><H3>Subscription Renewal Printing</H3></FONT>


<%

'Get Matching Events
'REE 4/6/2 - Modified to include OrganizationAct selection criteria
'REE 2/25/3 - Removed TicketFormat from criteria.
SQLEvents = "SELECT Event.EventCode FROM Event (NOLOCK) INNER JOIN Venue ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber WHERE Organization.OrganizationNumber = " & Session("OrganizationNumber") & " AND EventDate > GETDATE() ORDER BY EventDate"
Set rsEvents = OBJdbConnection.Execute(SQLEvents)

EventList = ""
If Not rsEvents.EOF Then
	EventList = "("
	Do Until rsEvents.EOF
		EventList = EventList & rsEvents("EventCode") & "," 
		rsEvents.MoveNext
	Loop
	EventList = Left(EventList,len(EventList)-1) & ")"
End If

If EventList <> "" Then
	'REE 2/25/3 - Removed TicketFormat from criteria.
	SQLTickets = "SELECT COUNT(OrderLine.ItemNumber) AS TicketCount, Act.Act, EventDate, Event.EventCode, Venue FROM Event (NOLOCK) INNER JOIN Seat ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Shipping ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN Act ON Event.ActCode = Act.ActCode INNER JOIN Venue ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber INNER JOIN OrganizationAct ON Event.ActCode = OrganizationAct.ActCode WHERE Event.EventCode IN " & EventList & " AND EventDate > GETDATE() AND OrderLine.StatusCode = 'R' AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') GROUP BY Event.EventCode, EventDate, Act.Act, Venue.Venue ORDER BY EventDate, Act.Act"
	Set rsTickets = OBJdbConnection.Execute(SQLTickets)
	
	'REE 4/6/2 - Modified to check for events.
	If Not rsTickets.EOF Then 'There are some events.  List them
		Response.Write "<FORM ACTION=""RenewalLetters.asp"" METHOD=""post""><INPUT TYPE=""hidden"" NAME=""FormName"" VALUE=""PrintMenu"">" & vbCrLf
		Response.Write "<INPUT TYPE=""hidden"" NAME=""start"" VALUE=""" & Clean(Request("Start")) & """><INPUT TYPE=""hidden"" NAME=""end"" VALUE=""" & Clean(Request("End")) & """>" & vbCrLf
		Response.Write "<TABLE CELLPADDING=""3"">" & vbCrLf
		Response.Write "<TR BGCOLOR=""#666666""><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Print</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Subscription</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Venue</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Date/Time</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Quantity</B></FONT></TD></TR>" & vbCrLf

		'Display Event and UnPrinted Ticket Quantities
		Do Until rsTickets.EOF

			Response.Write "<TR BGCOLOR=""DDDDDD""><TD ALIGN=""center""><INPUT TYPE=""checkbox"" NAME=""EventCode"" VALUE=" & rsTickets("EventCode") & "></FONT></TD><TD><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">" & rsTickets("Act") & "</FONT></TD><TD><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">" & rsTickets("Venue") & "</FONT></TD><TD ALIGN=""center"" NOWRAP><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">" & DateAndTimeFormat(rsTickets("EventDate")) & "</FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">" & rsTickets("TicketCount") & "</FONT></TD></TR>" & vbCrLf

			rsTickets.MoveNext

		Loop
			
		Response.Write "</TABLE><BR>" & vbCrLf
		'Display Buttons to Print
		Response.Write "<FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">Select Events to print and click 'Print' below.</FONT><BR><BR>" & vbCrLf
		Response.Write "<INPUT TYPE=""submit"" VALUE=""Print""></FORM>" & vbCrLf
	Else 'There aren't any matching events
		Response.Write "<BR><BR><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">There are no events to be printed.</FONT><BR><BR>" & vbCrLf
	End If
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

Sub PrintLetters

'Server.ScriptTimeout = 600

%>

<HTML>
<HEAD>
<TITLE>www.TIX.com - Subscription Renewal Letters</TITLE>
<SCRIPT LANGUAGE="JavaScript">
<!-- Begin
	function PrintLetters(){
		window.print(); 
		}

//  End -->
</SCRIPT>
</HEAD>
<BODY onLoad="PrintLetters()" LEFTMARGIN="0" RIGHTMARGIN="0" TOPMARGIN="0" MARGINHEIGHT="0" MARGINWIDTH="0">

<STYLE>	
	div {page-break-before: always}
</STYLE>

<FONT COLOR="#000000">
<%

'Build the Query to select each of the selected events
'REE 7/7/3 - Removed EventShip from Query.
SQLOrderLine = "SELECT OrderHeader.OrderTypeNumber, OrderHeader.OrderSurcharge, OrderHeader.ShipFee, OrderHeader.Total, OrderLine.OrderNumber, OrderLine.LineNumber, OrderLine.ItemNumber, OrderLine.Price, OrderLine.Surcharge, OrderLine.Discount, OrderLine.ShipCode, Event.EventCode, Event.EventDate, Event.Map, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, PostalCode, Customer.DayPhone, Customer.NightPhone, Customer.EMailAddress, Shipping.ShipType, Act.Act, Venue.Venue, SeatType.SeatType, Seat.Row, Seat.Seat, Seat.SectionCode, Section.Section FROM OrderLine INNER JOIN OrderHeader ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN Seat ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event ON Seat.EventCode = Event.EventCode INNER JOIN Section ON Seat.SectionCode = Section.SectionCode AND Event.EventCode = Section.EventCode INNER JOIN Act ON Event.ActCode = Act.ActCode INNER JOIN Venue ON Event.VenueCode = Venue.VenueCode INNER JOIN SeatType ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN Shipping ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct ON Event.ActCode = OrganizationAct.ActCode "
SQLWhere = SQLWhere & " WHERE Event.EventCode IN (" & Clean(Request("EventCode"))

'REE 4/6/2 - Modified to use OrganizationAct in selection criteria
'REE 8/1/5 - Added OrderNumbers for 2 orders.
SQLOrderLine = SQLOrderLine & SQLWhere & ") AND OrderLine.StatusCode = 'R' AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent')" & LetterRange & " ORDER BY OrderLine.ShipLastName, OrderLine.ShipFirstName, OrderLine.OrderNumber, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry, OrderLine.ShipCode, Seat.EventCode, Seat.SectionCode, RowSort, SeatSort DESC"
Set rsOrderLine = OBJdbConnection.Execute(SQLOrderLine)
		
Do Until rsOrderLine.EOF ' Or LetterCount >= 1

	If rsOrderLine("OrderNumber") <> LastOrderNumber Then 'It's different.  Print it.
		If TicketCount > 0 Then 'It's not the first one, print the footer.
		
			Response.Write "<TR><TD WIDTH=""20"">&nbsp;</TD><TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf			
			If LastShipFee <> 0 And LastOrderTypeNumber <> 5 Then
				Response.Write "<TR><TD WIDTH=""20"">&nbsp;</TD><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT SIZE=3>Processing Fee</FONT></TD><TD ALIGN=""right""><FONT SIZE=3>" & FormatCurrency(LastShipFee,2) & "</FONT></TD></TR>" & vbCrLf
				Response.Write "<TR><TD WIDTH=""20"">&nbsp;</TD><TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf
			End If

			SQLTender = "SELECT SUM(Tender.Amount) AS TenderAmount FROM Tender (NOLOCK) WHERE Tender.OrderNumber = " & LastOrderNumber
			Set rsTender = OBJdbConnection.Execute(SQLTender)
		
			If IsNull(rsTender("TenderAmount")) Then
				LastTender = 0
			Else
				LastTender = rsTender("TenderAmount")
			End If
		
			rsTender.Close
			Set rsTender = nothing	

			Response.Write "<TR><TD WIDTH=""20"">&nbsp;</TD><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT SIZE=3>Total Order</FONT></TD><TD ALIGN=""right""><FONT SIZE=3>" & FormatCurrency(LastTotal,2) & "</FONT></TD></TR>" & vbCrLf
			If LastTender <> 0 Then
				Response.Write "<TR><TD WIDTH=""20"">&nbsp;</TD><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT SIZE=3>Less Payments</FONT></TD><TD ALIGN=""right""><FONT SIZE=3>" & FormatCurrency(LastTender,2) & "</FONT></TD></TR>" & vbCrLf
				Response.Write "<TR><TD WIDTH=""20"">&nbsp;</TD><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT SIZE=3>Balance Due</FONT></TD><TD ALIGN=""right""><FONT SIZE=3>" & FormatCurrency(LastTotal - LastTender,2) & "</FONT></TD></TR>" & vbCrLf
			End If
			Response.Write "</TABLE>" & vbCrLf
			Response.Write "<BR>" & vbCrLf

            Response.Write "<table border=""0"" width=""700""><tbody><tr><td><FONT SIZE=3>" & vbCrLf
            Response.Write "<B><I>Optional for mail-in orders</I></B> - Add your 2009-2010 Performance Partners Contribution<br><BR>" & vbCrLf
            Response.Write "GIVING CIRCLES:<BR>___Friends’ ($50+);   ___Musicians’ ($100+);  ___Principal Musicians’ ($250+);  ___President’s ($500+);<br><BR>" & vbCrLf
            Response.Write "CONDUCTOR'S CIRCLE:<BR>___Silver ($1,000+),  ___Gold ($2,500+), ___Platinum ($5,000+)<br><BR>" & vbCrLf
            Response.Write "<B>Make checks payable to - Canton Symphony Orchestra</B>, or<br><BR>" & vbCrLf
            Response.Write "I prefer to pay by:  [  ] MasterCard   [  ] Visa   [  ] American Express   [  ] Discover<BR>" & vbCrLf
            Response.Write "</FONT></TD></TR></TBODY></TABLE>" & vbCrLf
            Response.Write "<table border=""0"" width=""700""><tbody>" & vbCrLf
            Response.Write "<tr><td><FONT SIZE=3>___ ___ ___ ___ - ___ ___ ___ ___ - ___ ___ ___ ___ - ___ ___ ___ ___&nbsp;&nbsp;&nbsp;<BR>(Card Number)</FONT></TD>" & vbCrLf
            Response.Write "<td><FONT SIZE=3>_______________<br>(CVV2)</FONT></TD>" & vbCrLf
            Response.Write "</TR></TBODY></TABLE>" & vbCrLf
            Response.Write "<table border=""0"" width=""700""><tbody>" & vbCrLf
            Response.Write "<tr><td>______________&nbsp;&nbsp;&nbsp;<br>(Expiration Date)</FONT></TD>" & vbCrLf
            Response.Write "<td><FONT SIZE=3>_______________________________&nbsp;&nbsp;&nbsp;<BR>(Print Name as it appears on card)</FONT></TD>" & vbCrLf
            Response.Write "<td><FONT SIZE=3>_______________________________&nbsp;&nbsp;&nbsp;<br>(Signature)</FONT></TD>" & vbCrLf
            Response.Write "</TR></TBODY></TABLE><BR>" & vbCrLf
            Response.Write "<table border=""0"" width=""700""><tbody>" & vbCrLf
            Response.Write "<tr VALIGN=TOP><td><FONT SIZE=3>MAIL TO:&nbsp;&nbsp;&nbsp;</FONT></TD>" & vbCrLf
            Response.Write "<td><FONT SIZE=3>Ticket Manager<BR>Canton Symphony Orchestra&nbsp;&nbsp;&nbsp;<BR>1001 Market Ave N<BR>Canton, OH  44702</FONT></TD>" & vbCrLf
            Response.Write "<td><FONT SIZE=3>Ticket Office Number: 330-452-2094<BR>Fax Number: 330-452-4429</FONT></TD>" & vbCrLf
            Response.Write "</TR></TBODY></TABLE></CENTER>" & vbCrLf

			Response.Write "<div>&nbsp;</div>" & vbCrLf
			
			LetterCount = LetterCount + 1
		End If
				
		SQLCustInfo = "SELECT Customer.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry FROM OrderHeader (NOLOCK) INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber WHERE OrderHeader.OrderNumber = " & rsOrderLine("OrderNumber") & " AND OrderLine.LineNumber = " & rsOrderLine("LineNumber")
		Set rsCustInfo = OBJdbConnection.Execute(SQLCustInfo)

		If Not rsCustInfo.EOF Then
%>
<!--#INCLUDE FILE="RenewalLetterInclude.asp"-->
<%		

			Response.Write "<BR><BR><BR><BR><BR><BR><BR>"
			Response.Write "<CENTER><TABLE WIDTH=700><TR><TD WIDTH=""50"">&nbsp;</TD><TD WIDTH=""400""><FONT SIZE=3><B>Shipping Information</B></FONT></TD><TD WIDTH=""300""><FONT SIZE=3><B>Billing Information</B></FONT></TD></TR>"
			Response.Write "<TR><TD>&nbsp;</TD><TD><FONT SIZE=3>" & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & "<BR>" & rsCustInfo("ShipAddress1") & "<BR>" & vbCrLf
			If rsCustInfo("ShipAddress2") <> "" Then
				Response.Write rsCustInfo("ShipAddress2") & "<BR>" & vbCrLf
			End If
			Response.Write rsCustInfo("ShipCity") & ", " & rsCustInfo("ShipState") & " " & rsCustInfo("ShipPostalCode") & "</TD><TD><FONT SIZE=3>" & rsCustInfo("FirstName") & " " & rsCustInfo("LastName") & "<BR>" & rsCustInfo("Address1") & "<BR>" & vbCrLf
			If rsCustInfo("Address2")<> "" Then
				Response.Write rsCustInfo("Address2") & "<BR>" & vbCrLf
			End If
			Response.Write rsCustInfo("City") & ", " & rsCustInfo("State") & " " & rsCustInfo("PostalCode") & "</FONT></TD></TR></TABLE><BR>" & vbCrLf
			Response.Write "<HR><BR>" & vbCrLf
			Response.Write "<TABLE CELLPADDING=""3"" WIDTH=""700""><TR><TD><FONT SIZE=3><B>Order Number:&nbsp;" & rsOrderLine("OrderNumber") & "</B><BR></FONT></TD></TR>" & vbCrLf

			SQLItemNumber = "SELECT ItemNumber FROM OrderLine (NOLOCK) WHERE OrderNumber = " & rsOrderLine("OrderNumber") & " ORDER BY ItemNumber"
			Set rsItemNumber = OBJdbConnection.Execute(SQLItemNumber)
			
			RenewalCode = rsCustInfo("CustomerNumber") & rsItemNumber("ItemNumber")
			
			rsItemNumber.Close
			Set rsItemNumber = nothing
			
			Response.Write "<TR><TD><FONT SIZE=3><B>Renewal Code:&nbsp;" & RenewalCode & "</B><BR></FONT></TD></TR></TABLE><BR>" & vbCrLf

		Else

			ErrorLog("Invoice Format - Order Number = " & Clean(Request("OrderNumber")) & " | Line Number = " & Clean(Request("LineNumber")))

		End If

		rsCustInfo.Close
		Set rsCustInfo = nothing

		LastEventCode = 0
		LastOrderNumber = rsOrderLine("OrderNumber")
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
	If LastEventCode <> rsOrderLine("EventCode") Or LastOrderNumber <> rsOrderLine("OrderNumber") Then
		Response.Write "<TABLE WIDTH=""700""><TR><TD WIDTH=""20"">&nbsp;</TD><TD><FONT SIZE=3><B>" & rsOrderLine("Act") & " at " & rsOrderLine("Venue")
		
		'REE 6/5/6 - Modified to look at EventOptions for Date & Time Display Options
		SQLDateSuppress = "SELECT OptionValue AS DateSuppress FROM EventOptions (NOLOCK) WHERE EventCode = " & rsOrderLine("EventCode") & " AND OptionName = 'DateSuppress' AND OptionValue = 'Y'"
		Set rsDateSuppress = OBJdbConnection.Execute(SQLDateSuppress)
		If rsDateSuppress.EOF Then
			Response.Write " on " & FormatDateTime(rsOrderLine("EventDate"),vbShortDate)
		End If
		rsDateSuppress.Close
		Set rsDateSuppress = nothing

		SQLTimeSuppress = "SELECT OptionValue AS TimeSuppress FROM EventOptions (NOLOCK) WHERE EventCode = " & rsOrderLine("EventCode") & " AND OptionName = 'TimeSuppress' AND OptionValue = 'Y'"
		Set rsTimeSuppress = OBJdbConnection.Execute(SQLTimeSuppress)
		If rsTimeSuppress.EOF Then
			Response.Write " at " & Left(FormatDateTime(rsOrderLine("EventDate"),vbLongTime),Len(FormatDateTime(rsOrderLine("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsOrderLine("EventDate"),vbLongTime),3)
		End If
		rsTimeSuppress.Close
		Set rsTimeSuppress = nothing

		Response.Write "</B><BR>Delivery Method: " & rsOrderLine("ShipType") & "</FONT></TD></TR></TABLE>" & vbCrLf

		'Calculate Number of Columns
		SQLNumColumns = "SELECT SUM(OrderLine.Surcharge) AS ServiceFee, SUM(OrderLine.Discount) AS Discount FROM OrderLine WHERE OrderNumber = " & rsOrderLine("OrderNumber") & " AND ItemType IN ('Seat', 'SubFixedEvent')"
		Set rsNumColumns = OBJdbConnection.Execute(SQLNumColumns)

		NumColumns = 6
		ColumnHeading = "<TABLE WIDTH=""700"" BORDER=""0""><TR><TD WIDTH=""20"">&nbsp;</TD><TD><FONT SIZE=3><B><U>Section</U></B></FONT></TD><TD ALIGN=center><FONT SIZE=3><B><U>Row</U></B></FONT></TD><TD ALIGN=center><FONT SIZE=3><B><U>Seat</U></B></FONT></TD><TD><FONT SIZE=3><B><U>Type</U></B></FONT></TD><TD ALIGN=right><FONT SIZE=3><B><U>Price</U></B></FONT></TD>"

		ColFacilityCharge = "N"
		ColServiceFee = "N"
		ColDiscount = "N"
		FacilityCharge = 0
		If FacilityCharge <> 0 Then
			NumColumns = NumColumns + 1
			ColumnHeading = ColumnHeading + "<TD ALIGN=right><FONT SIZE=3><B><U>Facility Charge</U></B></FONT></TD>"
			ColFacilityCharge = "Y"
		End If
		If rsNumColumns("ServiceFee") <> 0 Then
			NumColumns = NumColumns + 1
			ColumnHeading = ColumnHeading + "<TD ALIGN=right><FONT SIZE=3><B><U>Service Fee</U></B></FONT></TD>"
			ColServiceFee = "Y"
		End If
		If rsNumColumns("Discount") <> 0 Then
			NumColumns = NumColumns + 1
			ColumnHeading = ColumnHeading + "<TD ALIGN=right><FONT SIZE=3><B><U>Discount</U></B></FONT></TD>"
			ColDiscount = "Y"
		End If

		rsNumColumns.Close
		Set rsNumColumns = nothing

		ColumnHeading = ColumnHeading + "<TD ALIGN=right><FONT SIZE=3><B><U>Amount</U></B></TD></FONT></TR>" & vbCrLf
		
		Response.Write ColumnHeading

		LastEventCode = rsOrderLine("EventCode")
	End If
			
	'Print the detail
	'Add the OrderNumber and LineNumber to the Form
	LineDetail = "<TR><TD WIDTH=""20"">&nbsp;</TD><TD><FONT SIZE=3>" & rsOrderLine("Section") & "</FONT></TD><TD ALIGN=center><FONT SIZE=3>" & rsOrderLine("Row") & "</FONT></TD><TD ALIGN=center><FONT SIZE=3>" & rsOrderLine("Seat") & "</FONT></TD><TD><FONT SIZE=3>" & rsOrderLine("SeatType") & "</FONT></TD><TD ALIGN=right><FONT SIZE=3>" & FormatCurrency(rsOrderLine("Price"),2) & "</FONT></TD>"
	
	If ColFacilityCharge = "Y" Then
		LineDetail = LineDetail & "<TD ALIGN=right><FONT SIZE=3>" & FormatCurrency(FacilityCharge,2) & "</FONT></TD>"
	End If
	If ColServiceFee = "Y" Then
		LineDetail = LineDetail & "<TD ALIGN=right><FONT SIZE=3>" & FormatCurrency(rsOrderLine("Surcharge"),2) & "</FONT></TD>"
	End If
	If ColDiscount = "Y" Then
		LineDetail = LineDetail & "<TD ALIGN=right><FONT SIZE=3>" & FormatCurrency(rsOrderLine("Discount"),2) & "</FONT></TD>"
	End If
	
	LineDetail = LineDetail & "<TD ALIGN=right><FONT SIZE=3>" & FormatCurrency(rsOrderLine("Price")+FacilityFee+rsOrderLine("Surcharge")-rsOrderLine("Discount"),2) & "</FONT></TD></TR>" & vbCrLf
	
	Response.Write LineDetail

	LastOrderNumber = rsOrderLine("OrderNumber")
	
	rsOrderLine.MoveNext
		
Loop	
	
If TicketCount > 0 Then	'Print the last footer

	Response.Write "<TR><TD WIDTH=""20"">&nbsp;</TD><TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf			
	If LastShipFee <> 0 And LastOrderTypeNumber <> 5 Then
		Response.Write "<TR><TD WIDTH=""20"">&nbsp;</TD><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT SIZE=3>Processing Fee</FONT></TD><TD ALIGN=""right""><FONT SIZE=3>" & FormatCurrency(LastShipFee,2) & "</FONT></TD></TR>" & vbCrLf
		Response.Write "<TR><TD WIDTH=""20"">&nbsp;</TD><TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf
	End If

	SQLTender = "SELECT SUM(Tender.Amount) AS TenderAmount FROM Tender (NOLOCK) WHERE Tender.OrderNumber = " & LastOrderNumber
	Set rsTender = OBJdbConnection.Execute(SQLTender)
		
	If IsNull(rsTender("TenderAmount")) Then
		LastTender = 0
	Else
		LastTender = rsTender("TenderAmount")
		Response.Write SQLTender & "<BR>"
	End If
		
	rsTender.Close
	Set rsTender = nothing	

	Response.Write "<TR><TD WIDTH=""20"">&nbsp;</TD><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT SIZE=3>Total Order</FONT></TD><TD ALIGN=""right""><FONT SIZE=3>" & FormatCurrency(LastTotal,2) & "</FONT></TD></TR>" & vbCrLf
	If LastTender <> 0 Then
		Response.Write "<TR><TD WIDTH=""20"">&nbsp;</TD><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT SIZE=3>Less Payments</FONT></TD><TD ALIGN=""right""><FONT SIZE=3>" & FormatCurrency(LastTender,2) & "</FONT></TD></TR>" & vbCrLf
		Response.Write "<TR><TD WIDTH=""20"">&nbsp;</TD><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT SIZE=3>Balance Due</FONT></TD><TD ALIGN=""right""><FONT SIZE=3>" & FormatCurrency(LastTotal - LastTender,2) & "</FONT></TD></TR>" & vbCrLf
	End If
	Response.Write "</TABLE>" & vbCrLf
	Response.Write "<BR>" & vbCrLf

    Response.Write "<table border=""0"" width=""700""><tbody><tr><td><FONT SIZE=3>" & vbCrLf
    Response.Write "<B><I>Optional for mail-in orders</I></B> - Add your 2009-2010 Performance Partners Contribution<br><BR>" & vbCrLf
    Response.Write "GIVING CIRCLES:<BR>___Friends’ ($50+);   ___Musicians’ ($100+);  ___Principal Musicians’ ($250+);  ___President’s ($500+);<br><BR>" & vbCrLf
    Response.Write "CONDUCTOR'S CIRCLE:<BR>___Silver ($1,000+),  ___Gold ($2,500+), ___Platinum ($5,000+)<br><BR>" & vbCrLf
    Response.Write "<B>Make checks payable to - Canton Symphony Orchestra</B>, or<br><BR>" & vbCrLf
    Response.Write "I prefer to pay by:  [  ] MasterCard   [  ] Visa   [  ] American Express   [  ] Discover<BR>" & vbCrLf
    Response.Write "</FONT></TD></TR></TBODY></TABLE>" & vbCrLf
    Response.Write "<table border=""0"" width=""700""><tbody>" & vbCrLf
    Response.Write "<tr><td><FONT SIZE=3>___ ___ ___ ___ - ___ ___ ___ ___ - ___ ___ ___ ___ - ___ ___ ___ ___&nbsp;&nbsp;&nbsp;<BR>(Card Number)</FONT></TD>" & vbCrLf
    Response.Write "<td><FONT SIZE=3>_______________<br>(CVV2)</FONT></TD>" & vbCrLf
    Response.Write "</TR></TBODY></TABLE>" & vbCrLf
    Response.Write "<table border=""0"" width=""700""><tbody>" & vbCrLf
    Response.Write "<tr><td>______________&nbsp;&nbsp;&nbsp;<br>(Expiration Date)</FONT></TD>" & vbCrLf
    Response.Write "<td><FONT SIZE=3>_______________________________&nbsp;&nbsp;&nbsp;<BR>(Print Name as it appears on card)</FONT></TD>" & vbCrLf
    Response.Write "<td><FONT SIZE=3>_______________________________&nbsp;&nbsp;&nbsp;<br>(Signature)</FONT></TD>" & vbCrLf
    Response.Write "</TR></TBODY></TABLE><BR>" & vbCrLf
    Response.Write "<table border=""0"" width=""700""><tbody>" & vbCrLf
    Response.Write "<tr><td><FONT SIZE=3>MAIL TO:&nbsp;&nbsp;&nbsp;</FONT></TD>" & vbCrLf
    Response.Write "<td><FONT SIZE=3>Ticket Manager<BR>Canton Symphony Orchestra&nbsp;&nbsp;&nbsp;<BR>1001 Market Ave N<BR>Canton, OH  44702</FONT></TD>" & vbCrLf
    Response.Write "<td><FONT SIZE=3>Ticket Office Number: 330-452-2094<BR>Fax Number: 330-452-4429</FONT></TD>" & vbCrLf
    Response.Write "</TR></TBODY></TABLE></CENTER>" & vbCrLf

End If


rsOrderLine.Close
Set rsOrderLine = nothing

%>
</FONT>
</BODY>
</HTML>

<%

End Sub 'PrintLetters

%>