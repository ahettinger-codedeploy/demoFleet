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
'	Session.Abandon
'	Response.Redirect("/Default.asp")
End If

If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then 
'	Session.Abandon
'	Response.Redirect("Default.asp")
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

'Get the Info to Print
'REE 4/6/2 - Modified to use OrganizationAct in selection criteria
'REE 8/1/5 - Added OrderNumbers for 2 orders.
SQLOrderLine = SQLOrderLine & SQLWhere & ") AND OrderLine.StatusCode = 'R' AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent')" & LetterRange & " ORDER BY OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.OrderNumber, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry, OrderLine.ShipCode, Seat.EventCode, Seat.SectionCode, RowSort, SeatSort DESC"
Set rsOrderLine = OBJdbConnection.Execute(SQLOrderLine)
		
Do Until rsOrderLine.EOF ' Or LetterCount >= 1

	If rsOrderLine("OrderNumber") <> LastOrderNumber Then 'It's different.  Print it.
		If TicketCount > 0 Then 'It's not the first one, print the footer.
		
			Response.Write "<TR><TD WIDTH=""30"">&nbsp;</TD><TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf			
			If LastShipFee <> 0 And LastOrderTypeNumber <> 5 Then
				Response.Write "<TR><TD WIDTH=""30"">&nbsp;</TD><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=Calibri,Charcoal,Arial>Processing Fee</TD><TD ALIGN=""right""><FONT FACE=Calibri,Charcoal,Arial>" & FormatCurrency(LastShipFee,2) & "</TD></TR>" & vbCrLf
				Response.Write "<TR><TD WIDTH=""30"">&nbsp;</TD><TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf
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

			Response.Write "<TR><TD WIDTH=""30"">&nbsp;</TD><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=Calibri,Charcoal,Arial>Total Order</TD><TD ALIGN=""right""><FONT FACE=Calibri,Charcoal,Arial>" & FormatCurrency(LastTotal,2) & "</TD></TR>" & vbCrLf
			If LastTender <> 0 Then
				Response.Write "<TR><TD WIDTH=""30"">&nbsp;</TD><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=Calibri,Charcoal,Arial>Less Payments</TD><TD ALIGN=""right""><FONT FACE=Calibri,Charcoal,Arial>" & FormatCurrency(LastTender,2) & "</TD></TR>" & vbCrLf
				Response.Write "<TR><TD WIDTH=""30"">&nbsp;</TD><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=Calibri,Charcoal,Arial>Balance Due</TD><TD ALIGN=""right""><FONT FACE=Calibri,Charcoal,Arial>" & FormatCurrency(LastTotal - LastTender,2) & "</TD></TR>" & vbCrLf
			End If

			Response.Write "</TABLE>" & vbCrLf
			Response.Write "</CENTER>" & vbCrLf
			%>
			<!--#INCLUDE FILE="RenewalLetterFooterInclude.asp"-->
			<%		

			Response.Write "<div>&nbsp;</div>" & vbCrLf
			
			LetterCount = LetterCount + 1
			
		End If
				
		SQLCustInfo = "SELECT Customer.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry FROM OrderHeader (NOLOCK) INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber WHERE OrderHeader.OrderNumber = " & rsOrderLine("OrderNumber") & " AND OrderLine.LineNumber = " & rsOrderLine("LineNumber")
		Set rsCustInfo = OBJdbConnection.Execute(SQLCustInfo)

		If Not rsCustInfo.EOF Then

			SQLItemNumber = "SELECT TOP 1 ItemNumber FROM OrderLine (NOLOCK) WHERE OrderNumber = " & rsOrderLine("OrderNumber") & " ORDER BY ItemNumber"
			Set rsItemNumber = OBJdbConnection.Execute(SQLItemNumber)
			RenewalCode = rsCustInfo("CustomerNumber") & rsItemNumber("ItemNumber")
			rsItemNumber.Close
			Set rsItemNumber = nothing
			
			%>
			<!--#INCLUDE FILE="RenewalLetterHeaderInclude.asp"-->
			<%		

			Response.Write "<CENTER><TABLE WIDTH=750><TR><TD WIDTH=""50"">&nbsp;</TD><TD WIDTH=""400""><FONT FACE=Calibri,Charcoal,Arial><B>Shipping Information</B></TD><TD WIDTH=""300""><FONT FACE=Calibri,Charcoal,Arial><B>Billing Information</B></TD></TR>"
			Response.Write "<TR><TD>&nbsp;</TD><TD><FONT FACE=Calibri,Charcoal,Arial>" & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & "<BR>" & rsCustInfo("ShipAddress1") & "<BR>" & vbCrLf
			If rsCustInfo("ShipAddress2") <> "" Then
				Response.Write rsCustInfo("ShipAddress2") & "<BR>" & vbCrLf
			End If
			Response.Write rsCustInfo("ShipCity") & ", " & rsCustInfo("ShipState") & " " & rsCustInfo("ShipPostalCode") & "</TD><TD><FONT FACE=Calibri,Charcoal,Arial>" & rsCustInfo("FirstName") & " " & rsCustInfo("LastName") & "<BR>" & rsCustInfo("Address1") & "<BR>" & vbCrLf
			If rsCustInfo("Address2")<> "" Then
				Response.Write rsCustInfo("Address2") & "<BR>" & vbCrLf
			End If
			Response.Write rsCustInfo("City") & ", " & rsCustInfo("State") & " " & rsCustInfo("PostalCode") & "</TD></TR></TABLE><BR>" & vbCrLf
			Response.Write "<CENTER>" & vbCrLf
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
		Response.Write "<TABLE WIDTH=""750""><TR><TD WIDTH=""30"">&nbsp;</TD><TD><FONT FACE=Calibri,Charcoal,Arial><B>" & rsOrderLine("Act") & " at " & rsOrderLine("Venue")
		
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

		Response.Write "</B><BR>Delivery Method: " & rsOrderLine("ShipType") & "</TD></TR></TABLE>" & vbCrLf

		'Calculate Number of Columns
		SQLNumColumns = "SELECT SUM(OrderLine.Surcharge) AS ServiceFee, SUM(OrderLine.Discount) AS Discount FROM OrderLine WHERE OrderNumber = " & rsOrderLine("OrderNumber") & " AND ItemType IN ('Seat', 'SubFixedEvent')"
		Set rsNumColumns = OBJdbConnection.Execute(SQLNumColumns)

		NumColumns = 6
		ColumnHeading = "<TABLE WIDTH=""750"" BORDER=""0""><TR><TD WIDTH=""30"">&nbsp;</TD><TD><FONT FACE=Calibri,Charcoal,Arial><B><U>Section</U></B></TD><TD ALIGN=center><FONT FACE=Calibri,Charcoal,Arial><B><U>Row</U></B></TD><TD ALIGN=center><FONT FACE=Calibri,Charcoal,Arial><B><U>Seat</U></B></TD><TD><FONT FACE=Calibri,Charcoal,Arial><B><U>Type</U></B></TD><TD ALIGN=right><FONT FACE=Calibri,Charcoal,Arial><B><U>Price</U></B></TD>"

		FacilityCharge = 0
		If FacilityCharge <> 0 Then
			NumColumns = NumColumns + 1
			ColumnHeading = ColumnHeading + "<TD ALIGN=right><FONT FACE=Calibri,Charcoal,Arial><B><U>Facility Charge</U></B></TD>"
			ColFacilityCharge = "Y"
		End If
		If rsNumColumns("ServiceFee") <> 0 Then
			NumColumns = NumColumns + 1
			ColumnHeading = ColumnHeading + "<TD ALIGN=right><FONT FACE=Calibri,Charcoal,Arial><B><U>Service Fee</U></B></TD>"
			ColServiceFee = "Y"
		End If
		If rsNumColumns("Discount") <> 0 Then
			NumColumns = NumColumns + 1
			ColumnHeading = ColumnHeading + "<TD ALIGN=right><FONT FACE=Calibri,Charcoal,Arial><B><U>Discount</U></B></TD>"
			ColDiscount = "Y"
		End If

		rsNumColumns.Close
		Set rsNumColumns = nothing

		ColumnHeading = ColumnHeading + "<TD ALIGN=right><FONT FACE=Calibri,Charcoal,Arial><B><U>Amount</U></B></TD></TR>" & vbCrLf
		
		Response.Write ColumnHeading

		LastEventCode = rsOrderLine("EventCode")
	End If
			
	'Print the detail
	'Add the OrderNumber and LineNumber to the Form
	LineDetail = "<TR><TD WIDTH=""30"">&nbsp;</TD><TD><FONT FACE=Calibri,Charcoal,Arial>" & rsOrderLine("Section") & "</TD><TD ALIGN=center><FONT FACE=Calibri,Charcoal,Arial>" & rsOrderLine("Row") & "</TD><TD ALIGN=center><FONT FACE=Calibri,Charcoal,Arial>" & rsOrderLine("Seat") & "</TD><TD><FONT FACE=Calibri,Charcoal,Arial>" & rsOrderLine("SeatType") & "</TD><TD ALIGN=right><FONT FACE=Calibri,Charcoal,Arial>" & FormatCurrency(rsOrderLine("Price"),2) & "</TD>"
	
	If ColFacilityCharge = "Y" Then
		LineDetail = LineDetail & "<TD ALIGN=right><FONT FACE=Calibri,Charcoal,Arial>" & FormatCurrency(FacilityCharge,2) & "</TD>"
	End If
	If ColServiceFee = "Y" Then
		LineDetail = LineDetail & "<TD ALIGN=right><FONT FACE=Calibri,Charcoal,Arial>" & FormatCurrency(rsOrderLine("Surcharge"),2) & "</TD>"
	End If
	If ColDiscount = "Y" Then
		LineDetail = LineDetail & "<TD ALIGN=right><FONT FACE=Calibri,Charcoal,Arial>" & FormatCurrency(rsOrderLine("Discount"),2) & "</TD>"
	End If
	
	LineDetail = LineDetail & "<TD ALIGN=right><FONT FACE=Calibri,Charcoal,Arial>" & FormatCurrency(rsOrderLine("Price")+FacilityFee+rsOrderLine("Surcharge")-rsOrderLine("Discount"),2) & "</TD></TR>" & vbCrLf
	
	Response.Write LineDetail

	LastOrderNumber = rsOrderLine("OrderNumber")
	
	rsOrderLine.MoveNext
		
Loop	
	
If TicketCount > 0 Then	'Print the last footer

	Response.Write "<TR><TD WIDTH=""30"">&nbsp;</TD><TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf			
	If LastShipFee <> 0 And LastOrderTypeNumber <> 5 Then
		Response.Write "<TR><TD WIDTH=""30"">&nbsp;</TD><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=Calibri,Charcoal,Arial>Processing Fee</TD><TD ALIGN=""right""><FONT FACE=Calibri,Charcoal,Arial>" & FormatCurrency(LastShipFee,2) & "</TD></TR>" & vbCrLf
		Response.Write "<TR><TD WIDTH=""30"">&nbsp;</TD><TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf
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

	Response.Write "<TR><TD WIDTH=""30"">&nbsp;</TD><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=Calibri,Charcoal,Arial>Total Order</TD><TD ALIGN=""right""><FONT FACE=Calibri,Charcoal,Arial>" & FormatCurrency(LastTotal,2) & "</TD></TR>" & vbCrLf
	If LastTender <> 0 Then
		Response.Write "<TR><TD WIDTH=""30"">&nbsp;</TD><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=Calibri,Charcoal,Arial>Less Payments</TD><TD ALIGN=""right""><FONT FACE=Calibri,Charcoal,Arial>" & FormatCurrency(LastTender,2) & "</TD></TR>" & vbCrLf
		Response.Write "<TR><TD WIDTH=""30"">&nbsp;</TD><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=Calibri,Charcoal,Arial>Balance Due</TD><TD ALIGN=""right""><FONT FACE=Calibri,Charcoal,Arial>" & FormatCurrency(LastTotal - LastTender,2) & "</TD></TR>" & vbCrLf
	End If


	Response.Write "</TABLE>" & vbCrLf
	Response.Write "</CENTER>" & vbCrLf
	%>
	<!--#INCLUDE FILE="RenewalLetterFooterInclude.asp"-->
	<%		


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