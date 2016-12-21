<!--#INCLUDE VIRTUAL="dbOpenInclude.asp" -->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<%

Server.ScriptTimeout = 3600

'The following lines must be manually modified before running this program,
Public Function LookupNewEventCode(OldEventCode)

Select Case OldEventCode
	Case 37601 'Previous event
		LookupNewEventCode = 74953
	Case 37602 'Previous event
		LookupNewEventCode = 74951
	Case 37603 'Previous event
		LookupNewEventCode = 74952
	Case 37604 'Previous event
		LookupNewEventCode = 74576
End Select

End Function

OldEventCodeList = "37601, 37602, 37603, 37604"

'Select a date according to the client, either near the beginning of the season or after the season is complete.
OrderExpirationDate = "12/15/2006"
'Previous year's season event code
'OldEventCode = 20336 'Bud Park Weekend Pass 2005
'This year's season event code
'EventCode = 37604 'Bud Park Weekend Pass 2005
'Text which is placed in the IP Address field for identification purposes.
RenewDescription = Left("BUDPARK 2007", 15)

Surcharge = 0
ShipCode = 18
ShipFee = 7
OrderNumber = 999999

SQLTickets = "SELECT Seat.OrderNumber, Seat.EventCode, Seat.SectionCode, Seat.Row, Seat.Seat, OrderLine.SeatTypeCode, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipCountry, OrderLine.ShipPostalCode, OrderHeader.CustomerNumber, OrderHeader.OrderTypeNumber FROM Seat (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN OrderHeader (NOLOCK) ON Seat.OrderNumber = OrderHeader.OrderNumber WHERE Seat.EventCode IN (" & OldEventCodeList & ") AND Seat.StatusCode = 'S' AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') AND OrderHeader.OrderTypeNumber <> 5 ORDER BY Seat.OrderNumber"
Response.Write SQLTickets & "<BR><BR>"
Set rsTickets = OBJdbConnection.Execute(SQLTickets)


Do Until rsTickets.EOF OR OrderCount = 1

	OldOrderNumber = rsTickets("OrderNumber")

	If OldOrderNumber <> LastOldOrderNumber Then 'It's a new order.

		If OrderNumber <> 999999 And ReturnCode = 0 Then
			
			'Calculate Order Totals and Update OrderHeader for the LastOrderNumber
			SQLOrderLineTotals = "SELECT SUM(Price) AS Subtotal, SUM(Surcharge) AS Surcharge, SUM(Discount) AS DiscountAmount FROM OrderLine (ROWLOCK) WHERE OrderNumber = " & OrderNumber
			Response.Write SQLOrderLineTotals & "<BR><BR>"
			Set rsOrderLineTotals = OBJdbConnection.Execute(SQLOrderLineTotals)
			

			'Update the OrderHeader
			SQLUpdateTotals = "UPDATE OrderHeader WITH (ROWLOCK) SET Subtotal = " & rsOrderLineTotals("Subtotal") & ", OrderSurcharge = " & rsOrderLineTotals("Surcharge") & ", ShipFee = " & ShipFee & ", Discount = " & rsOrderLineTotals("DiscountAmount") & ", Total = " & (rsOrderLineTotals("Subtotal") + rsOrderLineTotals("Surcharge") +  ShipFee) - rsOrderLineTotals("DiscountAmount") & " WHERE OrderNumber = " & OrderNumber
			Response.Write SQLUpdateTotals & "<BR><BR>"
			Set rsUpdateTotals = OBJdbConnection.Execute(SQLUpdateTotals)

		End If

		LastOldOrderNumber = OldOrderNumber
		OrderCount = OrderCount + 1
		
		'Add the OrderHeader
		Set spInsertOrderHeader = Server.Createobject("Adodb.Command")
		Set spInsertorderHeader.ActiveConnection = OBJdbConnection
		spInsertOrderHeader.Commandtype = 4 ' Value for Stored Procedure
		spInsertOrderHeader.Commandtext = "spInsertOrderHeader"
		spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("OrderNumber", 3, 4) 'As Integer and ParamReturnValue
		spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("CustomerNumber", 3, 1, , rsTickets("CustomerNumber")) 'As Integer and Input
		spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("OrderTypeNumber", 3, 1, , 7) 'As Integer and Input.  7 is Box Office.
		spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("UserNumber", 3, 1, , 1) 'As Integer and Input
		spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("OrderExpirationDate", 7, 1, , OrderExpirationDate) 'As Date and Input
		spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("IPAddress", 200, 1, 15, RenewDescription) 'As Varchar and Input
		spInsertOrderHeader.Execute

		OrderNumber = spInsertOrderHeader.Parameters("OrderNumber")
		LineNumber = 1
		
		Response.Write "Old Order Number = " & OldOrderNumber & "<BR><BR>"
		Response.Write "Return Code = " & ReturnCode & "<BR><BR>"
		AddedOrderNumber = AddedOrderNumber & OrderNumber & "<BR><BR>" & vbCrLf
		
	End If
	
	NewEventCode = 0
		
	'Translate EventCodes
	NewEventCode = LookupNewEventCode(rsTickets("EventCode"))
	
	'Determine if the new Event is a subscription and/or reserved
	SQLEventType = "SELECT Map, EventType FROM Event (NOLOCK) WHERE EventCode = " & rsTickets("EventCode")
	Set rsEventType = OBJdbConnection.Execute(SQLEventType)
	
	If LCase(rsEventType("Map")) <> "general" Then
		Reserved = "Y"
	Else
		Reserved = "N"
	End If

	If LCase(rsEventType("EventType")) = "subfixedevent" Then
		Subscription = "Y"
	Else
		Subscription = "N"
	End If
	
	rsEventType.Close
	Set rsEventType = nothing
	
	
	'Determine the appropriate Stored Procedure and add the tickets
	If Reserved = "Y" Then 
	
		'Find the matching seat with status 'H' or 'A'
		ItemNumber = 0
		SQLSeat = "SELECT ItemNumber FROM Seat (NOLOCK) WHERE EventCode = " & NewEventCode & " AND SectionCode = '" & rsTickets("SectionCode") & "' AND Row = '" & rsTickets("Row") & "' AND Seat = '" & rsTickets("Seat") & "' AND StatusCode IN ('A', 'H')"
		Response.Write SQLSeat & "<BR><BR>"
		ErrorLog(SQLSeat)
		Set rsSeat = OBJdbConnection.Execute(SQLSeat)
		
		ItemNumber = rsSeat("ItemNumber")
		
		rsSeat.Close
		Set rsSeat = nothing
		
		If Subscription = "Y" Then 'Reserved Subscription
	
			Set spSectionReserveSeatsSubFixedEvent = Server.Createobject("Adodb.Command")
			Set spSectionReserveSeatsSubFixedEvent.ActiveConnection = OBJdbConnection
			spSectionReserveSeatsSubFixedEvent.Commandtype = 4 ' Value for Stored Procedure
			spSectionReserveSeatsSubFixedEvent.Commandtext = "spSectionReserveSeatsSubFixedEvent"
			spSectionReserveSeatsSubFixedEvent.Parameters.Append spSectionReserveSeatsSubFixedEvent.CreateParameter("ReturnCode", 3, 4) 'As Integer and ParamReturnValue
			spSectionReserveSeatsSubFixedEvent.Parameters.Append spSectionReserveSeatsSubFixedEvent.CreateParameter("EventCode", 3, 1, , NewEventCode) 'As Integer and Input
			spSectionReserveSeatsSubFixedEvent.Parameters.Append spSectionReserveSeatsSubFixedEvent.CreateParameter("OrderNumber", 3, 1, , OrderNumber) 'As Integer and Input
			spSectionReserveSeatsSubFixedEvent.Parameters.Append spSectionReserveSeatsSubFixedEvent.CreateParameter("OrderTypeNumber", 3, 1, , 7) 'As Integer and Input
			spSectionReserveSeatsSubFixedEvent.Parameters.Append spSectionReserveSeatsSubFixedEvent.CreateParameter("CommaDelimiter", 200, 1, 1, ",") 'As Varchar and Input
			spSectionReserveSeatsSubFixedEvent.Parameters.Append spSectionReserveSeatsSubFixedEvent.CreateParameter("ItemNumber", 200, 1, 5000, ItemNumber) 'As Varchar and Input
			spSectionReserveSeatsSubFixedEvent.Parameters.Append spSectionReserveSeatsSubFixedEvent.CreateParameter("SellHold", 200, 1, 1, "Y") 'As Varchar and Input

			spSectionReserveSeatsSubFixedEvent.Execute

			ReturnCode = spSectionReserveSeatsSubFixedEvent.Parameters("ReturnCode")
		
		Else 'Reserved non-Subscription

			Set spSectionReserveSeats = Server.Createobject("Adodb.Command")
			Set spSectionReserveSeats.ActiveConnection = OBJdbConnection
			spSectionReserveSeats.Commandtype = 4 ' Value for Stored Procedure
			spSectionReserveSeats.Commandtext = "spSectionReserveSeats"
			spSectionReserveSeats.Parameters.Append spSectionReserveSeats.CreateParameter("ReturnCode", 3, 4) 'As Integer and ParamReturnValue
			spSectionReserveSeats.Parameters.Append spSectionReserveSeats.CreateParameter("RowsUpdated", 3, 2) 'As Integer and Output
			spSectionReserveSeats.Parameters.Append spSectionReserveSeats.CreateParameter("EventCode", 3, 1, , NewEventCode) 'As Integer and Input
			spSectionReserveSeats.Parameters.Append spSectionReserveSeats.CreateParameter("OrderNumber", 3, 1, , OrderNumber) 'As Integer and Input
			spSectionReserveSeats.Parameters.Append spSectionReserveSeats.CreateParameter("AcceptAvailable", 200, 1, 1, "N") 'As Varchar and Input
			spSectionReserveSeats.Parameters.Append spSectionReserveSeats.CreateParameter("CommaDelimiter", 200, 1, 1, ",") 'As Varchar and Input
			spSectionReserveSeats.Parameters.Append spSectionReserveSeats.CreateParameter("ItemNumber", 200, 1, 5000, ItemNumber) 'As Varchar and Input
			spSectionReserveSeats.Parameters.Append spSectionReserveSeats.CreateParameter("SellHold", 200, 1, 1, "Y") 'As Varchar and Input

			spSectionReserveSeats.Execute

			ReturnCode = spSectionReserveSeats.Parameters("ReturnCode")
		
		End If
		
	Else 'It's GA
	
		If Subscription = "Y" Then  'GA Subscription

			Set spEventReserveSeatsSubFixedEvent = Server.Createobject("Adodb.Command")
			Set spEventReserveSeatsSubFixedEvent.ActiveConnection = OBJdbConnection
			spEventReserveSeatsSubFixedEvent.Commandtype = 4 ' Value for Stored Procedure
			spEventReserveSeatsSubFixedEvent.Commandtext = "spEventReserveSeatsSubFixedEvent"
			spEventReserveSeatsSubFixedEvent.Parameters.Append spEventReserveSeatsSubFixedEvent.CreateParameter("ReturnCode", 3, 4) 'As Integer and ParamReturnValue
			spEventReserveSeatsSubFixedEvent.Parameters.Append spEventReserveSeatsSubFixedEvent.CreateParameter("EventCode", 3, 1, , NewEventCode) 'As Integer and Input
			spEventReserveSeatsSubFixedEvent.Parameters.Append spEventReserveSeatsSubFixedEvent.CreateParameter("OrderNumber", 3, 1, , OrderNumber) 'As Integer and Input
			spEventReserveSeatsSubFixedEvent.Parameters.Append spEventReserveSeatsSubFixedEvent.CreateParameter("SeatCount", 3, 1, , 1) 'As Integer and Input
			spEventReserveSeatsSubFixedEvent.Parameters.Append spEventReserveSeatsSubFixedEvent.CreateParameter("SectionCode", 200, 1, 5, rsTickets("SectionCode")) 'As Varchar and Input with Section Code for General Admission events.
			spEventReserveSeatsSubFixedEvent.Execute
			
			ReturnCode = spEventReserveSeatsSubFixedEvent.Parameters("ReturnCode")
		
		Else 'GA non-Subscription

			Set spEventReserveSeats = Server.Createobject("Adodb.Command")
			Set spEventReserveSeats.ActiveConnection = OBJdbConnection
			spEventReserveSeats.Commandtype = 4 ' Value for Stored Procedure
			spEventReserveSeats.Commandtext = "spEventReserveSeats"
			spEventReserveSeats.Parameters.Append spEventReserveSeats.CreateParameter("ReturnCode", 3, 4) 'As Integer and ParamReturnValue
			spEventReserveSeats.Parameters.Append spEventReserveSeats.CreateParameter("EventCode", 3, 1, , NewEventCode) 'As Integer and Input
			spEventReserveSeats.Parameters.Append spEventReserveSeats.CreateParameter("OrderNumber", 3, 1, , OrderNumber) 'As Integer and Input
			spEventReserveSeats.Parameters.Append spEventReserveSeats.CreateParameter("SeatCount", 3, 1, , 1) 'As Integer and Input
			spEventReserveSeats.Parameters.Append spEventReserveSeats.CreateParameter("SectionCode", 200, 1, 5, rsTickets("SectionCode")) 'As Varchar and Input with Section Code for General Admission events.
			spEventReserveSeats.Execute

			ReturnCode = spEventReserveSeats.Parameters("ReturnCode")
		
		End If
			
	End If
		
	Response.Write "EventCode = " & NewEventCode & " | OldOrderNumber = " & OldOrderNumber & " | NewOrderNumber = " & OrderNumber & "<BR><BR>"
		
	If ReturnCode = 0 Then 'It was successful
		
		'Update the Price, SeatType, ShipTypeCode, and Shipping Info in OrderLine
		
		'Initialize Price
		Price = 0
		
		'Get the price
		SQLPrice = "SELECT Price.Price FROM Price (NOLOCK) WHERE EventCode = " & NewEventCode & " AND SectionCode = '" & rsTickets("SectionCode") & "' AND SeatTypeCode = " & rsTickets("SeatTypeCode")
		Set rsPrice = OBJdbConnection.Execute(SQLPrice) 

'		SQLPrice = "SELECT Price.Price, Seat.EventCode, LineNumber, OrderLine.ItemType FROM Seat (NOLOCK) INNER JOIN Price (NOLOCK) ON Seat.EventCode = Price.EventCode AND Seat.SectionCode = Price.SectionCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber WHERE Seat.ItemNumber = " & rsSeat("ItemNumber") & " AND Price.SeatTypeCode = " & rsTickets("SeatTypeCode") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent')"
'		Set rsPrice = OBJdbConnection.Execute(SQLPrice)

		Price = rsPrice("Price")
'			Surcharge = 0
		DiscountAmount = 0
		DiscountTypeNumber = 0
		
		rsPrice.Close
		Set rsPrice = nothing
		
		'Get the last line number for Seat and SubFixedEvent
		LineNumber = 0
		SQLLastLine = "SELECT Max(LineNumber) AS LastLineNumber FROM OrderLine (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND ItemType IN ('Seat', 'SubFixedEvent')"
		Set rsLastLine = OBJdbConnection.Execute(SQLLastLine)
		
		LineNumber = rsLastLine("LastLineNumber")
		
		rsLastLine.Close
		Set rsLastLine = nothing
			
		'REE 8/10/3 - Modified to select OrderLine by LineNumber instead of Item and ItemType
		SQLUpdateOrderLine = "UPDATE OrderLine WITH (ROWLOCK) SET Price = " & Price & ", Surcharge = " & Surcharge & ", SeatTypeCode = " & rsTickets("SeatTypeCode") & ", Discount = 0, DiscountTypeNumber = 0, ShipCode = " & ShipCode & ", ShipFirstName = '" & Clean(rsTickets("ShipFirstName")) & "', ShipLastName = '" & Clean(rsTickets("ShipLastName")) & "', ShipAddress1 = '" & Clean(rsTickets("ShipAddress1")) & "', ShipAddress2 = '" & Clean(rsTickets("ShipAddress2")) & "', ShipCity = '" & Clean(rsTIckets("ShipCity")) & "', ShipState = '" & Clean(rsTickets("ShipState")) & "', ShipPostalCode = '" & Clean(rsTickets("ShipPostalCode")) & "', ShipCountry = '" & Clean(rsTickets("ShipCountry")) & "' WHERE OrderNumber = " & OrderNumber & " AND LineNumber = " & LineNumber
		Response.Write SQLUpdateOrderLine & "<BR><BR>"
		Set rsUpdateOrderLine = OBJdbConnection.Execute(SQLUpdateOrderLine)

		If Subscription = "Y" Then 'Update the Child Lines.  Price and Surcharge are added as individual tickets and discounts are applied to mark down to zero
			'Get the original price
			SQLChildPrice = "SELECT Price.Price, Price.Surcharge, OrderLine.LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber LEFT JOIN Price (NOLOCK) ON Seat.EventCode = Price.EventCode AND Seat.SectionCode = Price.SectionCode AND Price.SeatTypeCode = " & rsTickets("SeatTypeCode") & " WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.ParentLineNumber = " & LineNumber
			Set rsChildPrice = OBJdbConnection.Execute(SQLChildPrice)
				
			Do Until rsChildPrice.EOF
				If Not IsNull(rsChildPrice("Price")) Then
					ChildPrice = rsChildPrice("Price")
				Else
					ChildPrice = 0
				End If
				ChildSurcharge = 0
				ChildDiscountAmount = ChildPrice + ChildSurcharge
				ChildDiscountTypeNumber = 37
				SQLUpdateChildLine = "UPDATE OrderLine WITH (ROWLOCK) SET Price = " & ChildPrice & ", Surcharge = " & ChildSurcharge & ", SeatTypeCode = " & rsTickets("SeatTypeCode") & ", Discount = " & ChildDiscountAmount & ", DiscountTypeNumber = " & ChildDiscountTypeNumber & ", ShipCode = 1, ShipFirstName = '" & Clean(rsTickets("ShipFirstName")) & "', ShipLastName = '" & Clean(rsTickets("ShipLastName")) & "', ShipAddress1 = '" & Clean(rsTickets("ShipAddress1")) & "', ShipAddress2 = '" & Clean(rsTickets("ShipAddress2")) & "', ShipCity = '" & Clean(rsTickets("ShipCity")) & "', ShipState = '" & Clean(rsTickets("ShipState")) & "', ShipPostalCode = '" & Clean(rsTickets("ShipPostalCode")) & "', ShipCountry = '" & Clean(rsTickets("ShipCountry")) & "' WHERE OrderNumber = " & OrderNumber & " AND LineNumber = " & rsChildPrice("LineNumber")
				Set rsUpdateChildLine = OBJdbConnection.Execute(SQLUpdateChildLine)
					
				rsChildPrice.MoveNext
			Loop
				
			rsChildPrice.Close
			Set rsChildPrice = nothing
			
		End If
			
		LineNumber = LineNumber + 1
		TicketCount = TicketCount + 1
			
	Else 'It failed
			
		Response.Write "Import Failed - CustomerNumber = " & rsTickets("CustomerNumber") & " | Section = " & rsTickets("Section") & " | Row = " & rsTickets("Row") & " | Seat = " & rsTickets("Seat") & "<BR><BR>" & vbCrLf
			
		FailedCount = FailedCount + 1
			
		Response.Write "Return Code = " & ReturnCode & "<BR><BR>"
			
		Exit Do
			
	End If

	rsTickets.MoveNext
	
Loop

'Update Last Order Totals
If OrderNumber <> 999999 And ReturnCode = 0 Then

	'Calculate Order Totals and Update OrderHeader for the LastOrderNumber
	SQLOrderLineTotals = "SELECT SUM(Price) AS Subtotal, SUM(Surcharge) AS Surcharge, SUM(Discount) AS DiscountAmount FROM OrderLine (ROWLOCK) WHERE OrderNumber = " & OrderNumber
	Set rsOrderLineTotals = OBJdbConnection.Execute(SQLOrderLineTotals)
				

	'Update the OrderHeader
	SQLUpdateTotals = "UPDATE OrderHeader WITH (ROWLOCK) SET Subtotal = " & rsOrderLineTotals("Subtotal") & ", OrderSurcharge = " & rsOrderLineTotals("Surcharge") & ", ShipFee = " & ShipFee & ", Discount = " & rsOrderLineTotals("DiscountAmount") & ", Total = " & (rsOrderLineTotals("Subtotal") + rsOrderLineTotals("Surcharge") +  ShipFee) - rsOrderLineTotals("DiscountAmount") & " WHERE OrderNumber = " & OrderNumber
	Set rsUpdateTotals = OBJdbConnection.Execute(SQLUpdateTotals)

End If

Response.Write AddedOrderNumber & "<BR><BR>" & vbCrLf
		
Response.Write "Orders Added = " & OrderCount & "<BR><BR>" & vbCrLf
Response.Write "Tickets Added = " & TicketCount & "<BR><BR>" & vbCrLf
Response.Write "Failed Count = " & FailedCount & "<BR><BR>" & vbCrLf

%>