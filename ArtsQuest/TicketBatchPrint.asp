<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp"-->
<!--#INCLUDE VIRTUAL="NoCacheInclude.asp"-->
<!--#INCLUDE VIRTUAL="TicketPrintInclude.asp"-->
<%	
'REE 3/2/4 - Removed ActiveX and Eltron Code.

Server.ScriptTimeout = 1200 '20 Minutes

'REE 4/15/2 - Increased Session Timeout to 60 minutes to reduce Print validation timeout issues.
Session.Timeout = 60

Page = "TicketBatchPrint"

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
<TITLE>www.TIX.com - Batch Ticket Printing</TITLE>
</HEAD>
<BODY BGCOLOR="#FFFFFF">

<CENTER>

<!--#INCLUDE VIRTUAL="TopNavInclude.asp"-->
<BR>

<BR>

<FONT FACE="verdana,arial,helvetica" COLOR="#008400"><H3>Batch Ticket Printing</H3></FONT>


<%

If Session("OrganizationNumber") = 1 Then
	 TixFulfillment = " AND Owner = 1 AND TixFulfillment = 1 "
	 ColumnWidth = 6
Else
	TixFulfillment = " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") 
	 ColumnWidth = 5
End If

'REE 6/3/4 - Modified to use EventOptions for Ticket Format
'REE 6/3/4 - Added SubSeat
'JAI 10/21/5 Modified/Consolidated Selection Queries
SQLTickets = "SELECT COUNT(OrderLine.ItemNumber) AS TicketCount, Act.Act, EventDate, Event.EventCode, Organization, Venue, Orderline.ShipCode, ShipType FROM Event (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine WITH (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Shipping (NOLOCK) ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN EventOptions (NOLOCK) ON Event.EventCode = EventOptions.EventCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization (NOLOCK) ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode AND OrganizationVenue.OrganizationNumber = OrganizationAct.OrganizationNumber WHERE EventDate > GETDATE()- 1 " & TixFulfillment & " AND OrderLine.StatusCode = 'S' AND OrderLine.PrintDate IS NULL AND EventOptions.OptionName = 'TicketFormatNumber' AND EventOptions.OptionValue IS NOT NULL AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent', 'SubSeat') GROUP BY ShipType, OrderLine.ShipCode, Event.EventCode, EventDate, Act.Act, Organization, Venue.Venue ORDER BY ShipType, OrderLine.ShipCode, EventDate"
Set rsTickets = OBJdbConnection.Execute(SQLTickets)
	
'REE 4/6/2 - Modified to check for events.
If Not rsTickets.EOF Then 'There are some events.  List them
	Response.Write "<FORM ACTION=""TicketBatchPrint.asp"" METHOD=""post""><INPUT TYPE=""hidden"" NAME=""FormName"" VALUE=""PrintMenu"">" & vbCrLf

	ShipCode = rsTickets("ShipCode")
	Response.Write "<TABLE CELLPADDING=""3""><TR BGCOLOR=""#008400""><TD ALIGN=""left"" COLSPAN=" & ColumnWidth & "><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>" & rsTickets("ShipType") & "</B></FONT></TD></TR>" & vbCrLf
	Response.Write "<TR BGCOLOR=""#666666""><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Print</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Event</B></FONT></TD>"
	If Session("OrganizationNumber") = 1 Then
		Response.Write "<TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Organization</B></FONT></TD>"
	End If
	Response.Write "<TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Venue</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Date/Time</B></FONT></TD><TD ALIGN=""center"" NOWRAP><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B># Unprinted</B></FONT></TD></TR>" & vbCrLf

	'Display Event and UnPrinted Ticket Quantities
	Do Until rsTickets.EOF
		If rsTickets("ShipCode") <> ShipCode Then
			ShipCode = rsTickets("ShipCode")
			Response.Write "<TR BGCOLOR=""#FFFFFF""><TD COLSPAN=""5"">&nbsp;</TD></TR>" & vbCrLf
			Response.Write "<TR BGCOLOR=""#008400""><TD ALIGN=""left"" COLSPAN=" & ColumnWidth & "><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>" & rsTickets("ShipType") & "</B></FONT></TD></TR>" & vbCrLf
			Response.Write "<TR BGCOLOR=""666666""><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Print</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Event</B></FONT></TD>"
			If Session("OrganizationNumber") = 1 Then
				Response.Write "<TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Organization</B></FONT></TD>"
			End If
			Response.Write "<TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Venue</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Date/Time</B></FONT></TD><TD ALIGN=""center"" NOWRAP><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B># Unprinted</B></FONT></TD></TR>" & vbCrLf
		End If
		ShipPad = "0000" & rsTickets("ShipCode")
		ShipPad = right(ShipPad,4)
		CheckboxValue = ShipPad & rsTickets("EventCode")

		Response.Write "<TR BGCOLOR=""DDDDDD""><TD ALIGN=""center""><INPUT TYPE=""checkbox"" NAME=""ShipEvent"" VALUE=" & CheckboxValue & "></FONT></TD><TD><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">" & rsTickets("Act") & "</FONT></TD>"
		If Session("OrganizationNumber") = 1 Then
			Response.Write "<TD><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">" & rsTickets("Organization") & "</FONT></TD>"
		End If
		Response.Write "<TD><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">" & rsTickets("Venue") & "</FONT></TD><TD ALIGN=""center"" NOWRAP><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">" & DateAndTimeFormat(rsTickets("EventDate")) & "</FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">" & rsTickets("TicketCount") & "</FONT></TD></TR>" & vbCrLf

		rsTickets.MoveNext
	Loop
			
	Response.Write "</TABLE><BR>" & vbCrLf
	'Display Buttons to Print
	Response.Write "<FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">Select Events to print and click 'Print' below.</FONT><BR><BR>" & vbCrLf
	Response.Write "<INPUT TYPE=""submit"" VALUE=""Print""></FORM>" & vbCrLf
Else 'There aren't any matching events
	Response.Write "<BR><BR><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">There are no events to be printed.</FONT><BR><BR>" & vbCrLf
End If
rsTickets.Close
Set rsTickets = nothing
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
<TITLE>www.TIX.com - Batch Ticket Printing</TITLE>
<SCRIPT LANGUAGE="JavaScript">
<!-- Begin
	function PrintTickets(){
		window.print();
		TicketPrintForm.submit();
		}

//  End -->
</SCRIPT>
</HEAD>
<BODY onLoad="PrintTickets()">

		<%
		
		'REE 5/3/5 - Added Code for Ticket Print Logging
		'JAI 10/24/7 - Changed to Stored Procedure
	    Set spInsertTicketPrintBatch = Server.Createobject("Adodb.Command")
	    Set spInsertTicketPrintBatch.ActiveConnection = OBJdbConnection
	    spInsertTicketPrintBatch.Commandtype = 4 ' Value for Stored Procedure
	    spInsertTicketPrintBatch.Commandtext = "spInsertTicketPrintBatch"
	    spInsertTicketPrintBatch.Parameters.Append spInsertTicketPrintBatch.CreateParameter("BatchNumber", 3, 4) 'As Integer and ParamReturnValue
	    spInsertTicketPrintBatch.Parameters.Append spInsertTicketPrintBatch.CreateParameter("BatchDate", 7, 1, , Now()) 'As Date and Input
	    spInsertTicketPrintBatch.Parameters.Append spInsertTicketPrintBatch.CreateParameter("UserNumber", 3, 1, , Session("UserNumber")) 'As Integer and Input
	    spInsertTicketPrintBatch.Parameters.Append spInsertTicketPrintBatch.CreateParameter("BatchType", 200, 1, 50, "Ticket Batch Print") 'As Varchar and Input
	    spInsertTicketPrintBatch.Execute
	    BatchNumber = spInsertTicketPrintBatch.Parameters("BatchNumber")

		'REE 10/9/4 - Added Code for Windows Format
		SQLWindowsFormat = "SELECT OptionValue FROM OrganizationOptions (NOLOCK) WHERE OrganizationNumber = " & Session("OrganizationNumber") & " AND OptionName = 'TicketFormatWindows' AND OptionValue = 'Y'"
		Set rsWindowsFormat = OBJdbConnection.Execute(SQLWindowsFormat)
		
		If Not rsWindowsFormat.EOF Then
			WindowsFormat = "Y"
		Else
			WindowsFormat = "N"
		End If
		
		rsWindowsFormat.Close
		Set rsWindowsFormat = nothing
		
		If WindowsFormat <> "Y" Then 'It's FGL.  Use table and PRE.
			Response.Write "<CENTER>" & vbCrLf
			Response.Write "<TABLE WIDTH=""600"">" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD><FONT SIZE=""1"" COLOR=""#FFFFFF"">" & vbCrLf
			Response.Write "<PRE>" & vbCrLf
		Else 'It's a Windows Format
			Response.Write "<STYLE>" & vbCrLf
			Response.Write "div {page-break-before: always}" & vbCrLf
			Response.Write "</STYLE>" & vbCrLf
		End If

		Response.Write "<FORM ACTION=""TicketBatchPrint.asp"" METHOD=""post"" NAME=""TicketPrintForm""><INPUT TYPE=""hidden"" NAME=""FormName"" VALUE=""PrintEvent"">" & vbCrLf

		'REE 3/2/4 - Added OrganizationOption for code between tickets
		SQLTicketBreak = "SELECT OptionValue FROM OrganizationOptions (NOLOCK) WHERE OrganizationNumber = " & Session("OrganizationNumber") & " AND OptionName = 'TicketBreak'"
		Set rsTicketBreak = OBJdbConnection.Execute(SQLTicketBreak)
		If rsTicketBreak.EOF Then 'Feed
			TicketBreak = "&lt;q&gt;"
		Else 'Use database value
			TicketBreak = rsTicketBreak("OptionValue")
		End If
		
		rsTicketBreak.Close
		Set rsTicketBreak = nothing
		
		'REE 3/2/4 - Added OrganizationOption for code between orders
		SQLTicketOrderBreak = "SELECT OptionValue FROM OrganizationOptions (NOLOCK) WHERE OrganizationNumber = " & Session("OrganizationNumber") & " AND OptionName = 'TicketOrderBreak'"
		Set rsTicketOrderBreak = OBJdbConnection.Execute(SQLTicketOrderBreak)
		If rsTicketOrderBreak.EOF Then 'Feed and Cut
			TicketOrderBreak = "&lt;p&gt;"
		Else 'Use database value
			TicketOrderBreak = rsTicketOrderBreak("OptionValue")
		End If
		
		rsTicketOrderBreak.Close
		Set rsTicketOrderBreak = nothing

		'Build the Query to select each of the selected events
		'REE 4/6/2 - Modified to use OrganizationAct in selection criteria
		SQLTickets = "SELECT OrderLine.OrderNumber, OrderLine.LineNumber, OrderLine.ShipCode, PrintFormat.Format, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipCountry, OrderLine.ShipPostalCode, OrderLine.Price, OrderLine.Discount AS LineDiscount, OrderLine.Surcharge, OrderLine.ItemType, OrderHeader.Subtotal, OrderHeader.ShipFee, OrderHeader.OrderSurcharge, OrderHeader.Total, OrderHeader.Discount AS OrderDiscount, OrderHeader.OrderDate, OrderHeader.OrderTypeNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.Country, Customer.PostalCode, Seat.ItemNumber, Seat.Row, Seat.Seat, Section.SectionCode, Section.Section, Event.EventCode, Event.EventDate, Act.Act, Act.ShortAct, Act.Comments AS ActComments, Act.Producer, Event.Comments AS EventComments, Venue.Venue, Venue.Address_1 AS VenueAddress1, Venue.Address_2 AS VenueAddress2, Venue.City AS VenueCity, Venue.State AS VenueState, Venue.ZIP_Code AS VenueZIPCode, Venue.Country AS VenueCountry, SeatType.SeatType, Shipping.ShipType, OrderType.OrderType FROM OrderLine WITH (NOLOCK) INNER JOIN OrderHeader WITH (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer WITH (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event WITH (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act WITH (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue WITH (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN EventOptions (NOLOCK) ON Event.EventCode = EventOptions.EventCode INNER JOIN PrintFormat (NOLOCK) ON EventOptions.OptionValue = PrintFormat.FormatNumber INNER JOIN Shipping WITH (NOLOCK) ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN SeatType WITH (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN Section WITH (NOLOCK) ON Seat.SectionCode = Section.SectionCode AND Seat.EventCode = Section.EventCode INNER JOIN OrderType WITH (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber"
		For Each Item In Request("ShipEvent") 'Loop for each Event requested
			EventNumber = EventNumber + 1
			If SQLWhere = "" Then 
				SQLWhere = " WHERE ((Event.EventCode = " & right(Request("ShipEvent")(EventNumber),len(Request("ShipEvent")(EventNumber))-4) & " AND OrderLine.ShipCode = " & left(Request("ShipEvent")(EventNumber),4) & ") "
			Else
				SQLWhere = SQLWhere & "OR (Event.EventCode = " & right(Request("ShipEvent")(EventNumber),len(Request("ShipEvent")(EventNumber))-4) & "AND OrderLine.ShipCode = " & left(Request("ShipEvent")(EventNumber),4) & ") "
			End If
		Next

		'Get the Info to Print
		'REE 4/6/2 - Modified to use OrganizationAct in selection criteria
		SQLTickets = SQLTickets & SQLWhere & ") AND OrderLine.StatusCode = 'S' AND OrderLine.PrintDate IS NULL AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')  AND EventOptions.OptionName = 'TicketFormatNumber' ORDER BY OrderLine.OrderNumber, OrderLine.ShipCode, EventDate, Seat.SectionCode, RowSort, SeatSort DESC"
		Set rsTickets = OBJdbConnection.Execute(SQLTickets)
				
		Call DBOpen(OBJdbConnection2)
		Call DBOpen(OBJdbConnection3)

		LastOrderNumber = 0
		NumberOfOrders = 0
		
		Do Until rsTickets.EOF

			If LastOrderNumber <> rsTickets("OrderNumber") OR LastShipCode <> rsTickets("ShipCode") Then
				'It's not the first order.  Feed or Cut the tickets
				If NumberOfOrders > 0 Then 
					Response.Write TicketOrderBreak & vbCrLf
				End If
				
				If NumberOfOrders >=100 Then 
					Exit Do
				End If
							
				'Get the Printing Formats for this Organization
				SQLAddressFormat = "SELECT TOP 1 OrderLine.OrderNumber, OrderLine.ShipCode, PrintFormat.Format, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipCountry, OrderLine.ShipPostalCode, OrderLine.Price, OrderLine.Discount AS LineDiscount, OrderLine.Surcharge, OrderLine.ItemType, OrderHeader.Subtotal, OrderHeader.ShipFee, OrderHeader.OrderSurcharge, OrderHeader.Total, OrderHeader.Discount AS OrderDiscount, OrderHeader.OrderDate, OrderHeader.OrderTypeNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.Country, Customer.PostalCode, Seat.ItemNumber, Seat.Row, Seat.Seat, Event.EventCode, Event.EventDate, Shipping.ShipType, OrderType.OrderType FROM OrderLine WITH (NOLOCK) INNER JOIN OrderHeader WITH (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer WITH (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event WITH (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN Organization (NOLOCK) ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber INNER JOIN PrintFormat (NOLOCK) ON Organization.AddressPrintFormat = PrintFormat.FormatNumber INNER JOIN Shipping WITH (NOLOCK) ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN OrderType WITH (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber WHERE Event.EventCode = " & rsTickets("EventCode") & " AND Owner = 1 AND OrderLine.ShipCode = " & rsTickets("ShipCode") & " AND OrderHeader.OrderNumber = " & rsTickets("OrderNumber")
				Set rsAddressFormat = OBJdbConnection2.Execute(SQLAddressFormat)

				If Not rsAddressFormat.EOF Then 'There's an address format.  Print the address ticket
					SQLOrderSub = "SELECT COUNT(LineNumber) AS TicketCount From OrderLine (NOLOCK) WHERE OrderNumber = " & rsTickets("OrderNumber") & " AND StatusCode = 'S' AND ItemType IN ('SubFixedEvent', 'Seat')"
					Set rsOrderSub = OBJdbConnection3.Execute(SQLOrderSub)
					TicketCountSub = rsOrderSub("TicketCount")
					rsOrderSub.Close
					Set rsOrderSub = nothing
					SQLOrderInd = "SELECT COUNT(LineNumber) AS TicketCount From OrderLine (NOLOCK) WHERE OrderNumber = " & rsTickets("OrderNumber") & " AND StatusCode = 'S' AND ItemType IN ('SubFixedEvent', 'Seat')"
					Set rsOrderInd = OBJdbConnection3.Execute(SQLOrderInd)
					TicketCountInd = rsOrderInd("TicketCount")
					rsOrderInd.Close
					Set rsOrderInd = nothing
					Response.Write FormatTicket(rsAddressFormat("OrderNumber"), rsAddressFormat("Format"), rsAddressFormat("ShipFirstName"), rsAddressFormat("ShipLastName"), rsAddressFormat("ShipAddress1"), rsAddressFormat("ShipAddress2"), rsAddressFormat("ShipCity"), rsAddressFormat("ShipState"), rsAddressFormat("ShipCountry"), rsAddressFormat("ShipPostalCode"), rsAddressFormat("Price"), rsAddressFormat("LineDiscount"), rsAddressFormat("Surcharge"), rsAddressFormat("ItemType"), rsAddressFormat("Subtotal"), rsAddressFormat("ShipFee"), rsAddressFormat("OrderSurcharge"), rsAddressFormat("Total"), rsAddressFormat("OrderDiscount"), rsAddressFormat("OrderDate"), rsAddressFormat("OrderTypeNumber"), rsAddressFormat("FirstName"), rsAddressFormat("LastName"), rsAddressFormat("Address1"), rsAddressFormat("Address2"), rsAddressFormat("City"), rsAddressFormat("State"), rsAddressFormat("Country"), rsAddressFormat("PostalCode"), rsAddressFormat("ItemNumber"), rsAddressFormat("Row"), rsAddressFormat("Seat"), "", "", rsAddressFormat("EventCode"), rsAddressFormat("EventDate"), "", "", "", "", "", "", "", "", "", "", "", "", "", rsAddressFormat("ShipType"), rsAddressFormat("OrderType"), TicketCountSub, TicketCountInd) & TicketBreak & vbCrLf
				End If
				rsAddressFormat.Close
				Set rsAddressFormat = nothing

				NumberOfOrders = NumberOfOrders + 1
				LastOrderNumber = rsTickets("OrderNumber")
				LastShipCode = rsTickets("ShipCode")
					
			Else 'Feed
				Response.Write TicketBreak & vbCrLf
			End If
						
			'Add the OrderNumber and LineNumber to the Form
			Response.Write "<INPUT TYPE=""hidden"" NAME=""OrderNumber"" VALUE=" & rsTickets("OrderNumber") & "><INPUT TYPE=""hidden"" NAME=""LineNumber"" VALUE=" & rsTickets("LineNumber") & ">" & vbCrLf
			'Print the ticket			
			Response.Write FormatTicket(rsTickets("OrderNumber"), rsTickets("Format"), rsTickets("ShipFirstName"), rsTickets("ShipLastName"), rsTickets("ShipAddress1"), rsTickets("ShipAddress2"), rsTickets("ShipCity"), rsTickets("ShipState"), rsTickets("ShipCountry"), rsTickets("ShipPostalCode"), rsTickets("Price"), rsTickets("LineDiscount"), rsTickets("Surcharge"), rsTickets("ItemType"), rsTickets("Subtotal"), rsTickets("ShipFee"), rsTickets("OrderSurcharge"), rsTickets("Total"), rsTickets("OrderDiscount"), rsTickets("OrderDate"), rsTickets("OrderTypeNumber"), rsTickets("FirstName"), rsTickets("LastName"), rsTickets("Address1"), rsTickets("Address2"), rsTickets("City"), rsTickets("State"), rsTickets("Country"), rsTickets("PostalCode"), rsTickets("ItemNumber"), rsTickets("Row"), rsTickets("Seat"), rsTickets("SectionCode"), rsTickets("Section"), rsTickets("EventCode"), rsTickets("EventDate"), rsTickets("Act"), rsTickets("ShortAct"), rsTickets("ActComments"), rsTickets("Producer"), rsTickets("EventComments"), rsTickets("Venue"), rsTickets("VenueAddress1"), rsTickets("VenueAddress2"), rsTickets("VenueCity"), rsTickets("VenueState"), rsTickets("VenueZIPCode"), rsTickets("VenueCountry"), rsTickets("SeatType"), rsTickets("ShipType"), rsTickets("OrderType"), 1, 1)

			'REE 5/3/5 - Added Ticket Print Logging
			SQLTicketLog = "INSERT TicketPrintLog(BatchNumber, OrderNumber, ItemNumber, PrintDate, UserNumber) VALUES(" & BatchNumber & ", " & rsTickets("OrderNumber") & ", " & rsTickets("ItemNumber") & ", GETDATE(), " & Session("UserNumber") & ")"
			Set rsTicketLog = OBJdbConnection2.Execute(SQLTicketLog)

			TicketCount = TicketCount + 1

'			JAI 10/24/5 - Commented out printing of Child Tickets until we can get this to work seamlessly.  It was printing both series from parent and individual tickets if both selected, causing duplicates.
'			'JAI 4/21/4 - Print Child Tickets
'			If rsTickets("ItemType") = "SubFixedEvent" Then
'				SQLChildTickets = "SELECT OrderLine.OrderNumber, OrderLine.LineNumber, PrintFormat.Format, OrderLine.ItemNumber FROM OrderLine WITH (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event WITH (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN EventOptions (NOLOCK) ON Event.EventCode = EventOptions.EventCode INNER JOIN PrintFormat (NOLOCK) ON EventOptions.OptionValue = PrintFormat.FormatNumber WHERE OrderLine.OrderNumber = " & rsTickets("OrderNumber") & " AND OrderLine.ParentLineNumber = " & rsTickets("LineNumber") & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderLine.ItemType = 'SubSeat' AND EventOptions.OptionName = 'TicketFormatNumber' ORDER BY LineNumber"
'				Set rsChildTickets = OBJdbConnection2.Execute(SQLChildTickets)
'				Do Until rsChildTickets.EOF
'					Response.Write TicketBreak & vbCrLf
'					'Add the OrderNumber and LineNumber to the Form
'					Response.Write "<INPUT TYPE=""hidden"" NAME=""OrderNumber"" VALUE=" & rsChildTickets("OrderNumber") & "><INPUT TYPE=""hidden"" NAME=""LineNumber"" VALUE=" & rsChildTickets("LineNumber") & ">" & vbCrLf
'					'Print the ticket			
'					Response.Write FormatTicket(rsChildTickets("OrderNumber"), rsChildTickets("Format"))
'
'					'REE 5/3/5 - Added Ticket Print Logging
'					SQLTicketLog = "INSERT TicketPrintLog(BatchNumber, OrderNumber, ItemNumber, PrintDate, UserNumber) VALUES(" & BatchNumber & ", " & rsChildTickets("OrderNumber") & ", " & rsChildTickets("ItemNumber") & ", GETDATE(), " & Session("UserNumber") & ")"
'					Set rsTicketLog = OBJdbConnection3.Execute(SQLTicketLog)
'					
'					TicketCount = TicketCount + 1
'					rsChildTickets.MoveNext
'				Loop
'				rsChildTickets.Close
'				Set rsChildTickets = nothing
'			End If
									
			rsTickets.MoveNext

		Loop	
		
		Call DBClose(OBJdbConnection3)
		Call DBClose(OBJdbConnection2)
			
		rsTickets.Close
		Set rsTickets = nothing
		
		'REE - Added If statement to exclude last TicketOrderBreak for WindowsFormat
		If WindowsFormat <> "Y" Then 'Cut off the last ticket
			Response.Write TicketOrderBreak & vbCrLf
		End If

		Response.Write "</FORM>"

		'REE 10/9/4 - Added Code for Windows Format
		If WindowsFormat <> "Y" Then 'It's FGL. Close table and PRE.
			Response.Write "</PRE>" & vbCrLf
			Response.Write "</FONT>" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf
			Response.Write "</CENTER>" & vbCrLf
		End If

		%>
</BODY>
</HTML>

<%

End Sub 'PrintEvent

'----------------------------

Sub DisplayTickets

%>
<HTML>
<HEAD>
<TITLE>www.TIX.com - Batch Ticket Printing</TITLE>
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

<FORM ACTION="TicketBatchPrint.asp" METHOD="post" NAME="OKPrint"><INPUT TYPE="hidden" NAME="FormName" VALUE="OKPrint">
<TABLE CELLPADDING="5">
<%

'Get Each Order Number from the previous form
SQLWhere = ""
For Each Item In Request("OrderNumber")
	'This sets the position of the Request("OrderNumber") and Request("LineNumber") arrays
	ArrayPos = ArrayPos + 1
	OrderNumber = Request("OrderNumber")(ArrayPos)
	LineNumber = Request("LineNumber")(ArrayPos)

	If SQLWhere = "" Then 
		SQLWhere = " WHERE ((OrderLine.OrderNumber = " & Request("OrderNumber")(ArrayPos) & " AND OrderLine.LineNumber = " & Request("LineNumber")(ArrayPos) & ")"
	Else
		SQLWhere = SQLWhere & " OR (OrderLine.OrderNumber = " & Request("OrderNumber")(ArrayPos) & " AND OrderLine.LineNumber = " & Request("LineNumber")(ArrayPos) & ")"
	End If
Next
SQLWhere = SQLWhere & ")"

'Get Ticket Header Info
'	SQLTicketHeader = "SELECT * FROM OrderLine INNER JOIN Seat ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode WHERE OrderLine.OrderNumber = " & OrderNumber & " ORDER BY OrderLine.OrderNumber, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry, OrderLine.ShipCode"
'REE 4/6/2 - Modified to use OrganizationAct in selection criteria
If Request("OrderNumber") <> "" Then
	SQLTicket = "SELECT OrderLine.OrderNumber, OrderLine.ShipCode, OrderLine.ItemNumber, ShipFirstName,  ShipLastName, ShipAddress1, ShipAddress2, ShipCity, ShipState, ShipPostalCode, OrderLine.LineNumber, Act.Act, Venue.Venue, Event.EventDate, Seat.SectionCode, Seat.Row, Seat.Seat, SeatType.SeatType, OrderLine.Price FROM OrderLine WITH (NOLOCK) INNER JOIN OrderHeader WITH (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event WITH (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Shipping (NOLOCK) ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode " & SQLWhere & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent', 'SubSeat') ORDER BY OrderLine.OrderNumber, Seat.EventCode, Seat.SectionCode, RowSort, SeatSort DESC"
	Set rsTicket = OBJdbConnection.Execute(SQLTicket)

	Do Until rsTicket.EOF
		If LastOrderNumber <> rsTicket("OrderNumber") OR LastShipCode <> rsTicket("ShipCode") Then 'It's different.  Print it.
			Response.Write "<TR><TD COLSPAN=""9"">&nbsp;</TD></TR>" & vbCrLf	
			Response.Write "<TR BGCOLOR=""#008400""><TD COLSPAN=""9""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Order Number: " & rsTicket("OrderNumber") & " " & rsTicket("ShipFirstName") & " " & rsTicket("ShipLastName") & " " & rsTicket("ShipAddress1") & " " & rsTicket("ShipAddress2") & " " & rsTicket("ShipCity") & ", " & rsTicket("ShipState") & " " & rsTicket("ShipPostalCode") & "</B></FONT></TD></TR>" & vbCrLf
			Response.Write "<TR BGCOLOR=""#666666""><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Ticket #</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Event</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Venue</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Date/Time</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Section</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Row</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Seat</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Seat Type</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Price</B></FONT></TD></TR>" & vbCrLf
			LastOrderNumber = rsTicket("OrderNumber")
			LastShipCode = rsTicket("ShipCode")
		End If
			
		'Print the Ticket Detail
		Response.Write "<TR BGCOLOR=""#DDDDDD""><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2""><INPUT TYPE=""hidden"" NAME=""OrderNumber"" VALUE=" & rsTicket("OrderNumber") & "><INPUT TYPE=""hidden"" NAME=""LineNumber"" VALUE=" & rsTicket("LineNumber") & ">" & rsTicket("ItemNumber") & "</FONT></TD><TD><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsTicket("Act") & "</FONT></TD><TD><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsTicket("Venue") & "</FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsTicket("EventDate") & "</FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsTicket("SectionCode") & "</FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsTicket("Row") & "</FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsTicket("Seat") & "</FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsTicket("SeatType") & "</FONT></TD><TD ALIGN=""right""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & FormatNumber(rsTicket("Price"),2) & "</FONT></TD></TR>" & vbCrLf

		rsTicket.MoveNext
			
	Loop
	rsTicket.Close
	Set rsTicket = nothing
End If		

Response.Write "</TABLE><BR>" & vbCrLf
'Set Focus to Ticket Printing Menu Button
'Find Tickets based on Print Date, Organization, etc.
'List Tickets
'Display Button to return to Ticket Printing Menu
Response.Write "<FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">Did the tickets print properly?</FONT><BR>" & vbCrLf
Response.Write "<TABLE CELLPADDING=""10""><TR><TD><INPUT TYPE=""submit"" VALUE=""Yes"" NAME=""Button""></FORM></TD><TD><FORM ACTION=""TicketBatchPrint.asp"" METHOD=""post"" NAME=""NoPrint""><INPUT TYPE=""hidden"" NAME=""FormName"" VALUE=""NoPrint""><INPUT TYPE=""submit"" VALUE=""No""></FORM></TD></TR></TABLE>" & vbCrLf

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

'Loop Throught The Order Lines from DisplayTickets Sub
For Each Item In Request("OrderNumber")
	
	'This sets the position of the Request("OrderNumber") and Request("LineNumber") arrays
	ArrayPos = ArrayPos + 1
	OrderNumber = Request("OrderNumber")(ArrayPos)
	LineNumber = Request("LineNumber")(ArrayPos)

	'REE 8/24/3 - Modified to update lines with ParentLineNumber = LineNumber for Subscriptions.	
	SQLUpdatePrintDate = "UPDATE OrderLine WITH (ROWLOCK) SET PrintDate = '" & PrintDate & "' WHERE OrderNumber = " & OrderNumber & " AND (LineNumber = " & LineNumber & " OR ParentLineNumber = " & LineNumber & ")"
	Set rsUpdatePrintDate = OBJdbConnection.Execute(SQLUpdatePrintDate)
	
	'REE 4/26/5 - Added Security Log
	SecurityLog("Ticket Batch Print - Order #" & OrderNumber & " Line Number #" & LineNumber)

Next

Call PrintMenu

End Sub 'UpdatePrintDate

%>