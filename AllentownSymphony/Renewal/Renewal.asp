<!--#INCLUDE VIRTUAL="dbOpenInclude.asp" -->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<%

Server.ScriptTimeout = 3600

'The following lines must be manually modified before running this program,
'Select a date according to the client, either near the beginning of the season or after the season is complete.
OrderExpirationDate = "7/30/2009 9:00 PM"

'Previous year's season event code
OldEventCode = 142610 'ASO 2008 - Sun
'This year's event code
EventCode = 197713 'ASO 2009 - Sun

'Text which is placed in the IP Address field for identification purposes.
RenewDescription = Left("ASO 2009 - Sub", 15)

'Use the following if you want to begin with a certain order #.  Otherwise, begin with 0.  This is useful if you need to rerun this program partially.
BeginOrderNumber = 0
'BeginOrderNumber = 0

Surcharge = 0
ShipCode = 1
ShipFee = 5
OrderTypeNumber = 3 '7 is Box Office, 5 is Comp, 3 is Fax
OrderNumber = 999999

'Force all tickets to Adult ticket type.
SeatTypeCode = 1

SQLTickets = "SELECT Seat.OrderNumber, Seat.SectionCode, Seat.Row, Seat.Seat, OrderLine.SeatTypeCode, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipCountry, OrderLine.ShipPostalCode, OrderHeader.CustomerNumber, OrderHeader.OrderTypeNumber FROM Seat (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN OrderHeader (NOLOCK) ON Seat.OrderNumber = OrderHeader.OrderNumber WHERE Seat.EventCode = " & OldEventCode & " AND Seat.StatusCode = 'S' AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') AND OrderHeader.OrderNumber >= " & BeginOrderNumber & " ORDER BY Seat.OrderNumber"
Response.Write SQLTickets & "<BR>"
Set rsTickets = OBJdbConnection.Execute(SQLTickets)


Do Until rsTickets.EOF

	OldOrderNumber = rsTickets("OrderNumber")
	
	'JAI 3/16/9 - Use existing Comp or Box Office order type
	'This is special for the postseason game
	OrderTypeNumber = CInt(rsTickets("OrderTypeNumber"))
	If OrderTypeNumber <> 5 Then
	    OrderTypeNumber = 7
	End If

	If OldOrderNumber <> LastOldOrderNumber Then 'It's a new order.

		If OrderNumber <> 999999 And ReturnCode = 0 Then
			
			'Calculate Order Totals and Update OrderHeader for the LastOrderNumber
			SQLOrderLineTotals = "SELECT SUM(Price) AS Subtotal, SUM(Surcharge) AS Surcharge, SUM(Discount) AS DiscountAmount FROM OrderLine (ROWLOCK) WHERE OrderNumber = " & OrderNumber
			Response.Write SQLOrderLineTotals & "<BR>"
			Set rsOrderLineTotals = OBJdbConnection.Execute(SQLOrderLineTotals)
			

			'Update the OrderHeader
			SQLUpdateTotals = "UPDATE OrderHeader WITH (ROWLOCK) SET Subtotal = " & rsOrderLineTotals("Subtotal") & ", OrderSurcharge = " & rsOrderLineTotals("Surcharge") & ", ShipFee = " & ShipFee & ", Discount = " & rsOrderLineTotals("DiscountAmount") & ", Total = " & (rsOrderLineTotals("Subtotal") + rsOrderLineTotals("Surcharge") +  ShipFee) - rsOrderLineTotals("DiscountAmount") & " WHERE OrderNumber = " & OrderNumber
			Response.Write SQLUpdateTotals & "<BR>"
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
		spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("OrderTypeNumber", 3, 1, , OrderTypeNumber) 'As Integer and Input. 
		spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("UserNumber", 3, 1, , 1) 'As Integer and Input
		spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("OrderExpirationDate", 7, 1, , OrderExpirationDate) 'As Date and Input
		spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("IPAddress", 200, 1, 15, RenewDescription) 'As Varchar and Input
		spInsertOrderHeader.Execute

		OrderNumber = spInsertOrderHeader.Parameters("OrderNumber")
		LineNumber = 1
		
		Response.Write "Old Order Number = " & OldOrderNumber & "<BR>"
		Response.Write "Return Code = " & ReturnCode & "<BR>"
		
	End If
	
	'Find the matching seat with status 'H' or 'A'
	SQLSeat = "SELECT ItemNumber FROM Seat (NOLOCK) WHERE EventCode = " & EventCode & " AND SectionCode = '" & rsTickets("SectionCode") & "' AND Row = '" & rsTickets("Row") & "' AND Seat = '" & rsTickets("Seat") & "' AND StatusCode IN ('A', 'H')"
	Response.Write SQLSeat & "<BR>"
	Set rsSeat = OBJdbConnection.Execute(SQLSeat)
	
	If Not rsSeat.EOF Then
	
		Set spSectionReserveSeatsSubFixedEvent = Server.Createobject("Adodb.Command")
		Set spSectionReserveSeatsSubFixedEvent.ActiveConnection = OBJdbConnection
		spSectionReserveSeatsSubFixedEvent.Commandtype = 4 ' Value for Stored Procedure
		spSectionReserveSeatsSubFixedEvent.Commandtext = "spSectionReserveSeatsSubFixedEvent"
		spSectionReserveSeatsSubFixedEvent.Parameters.Append spSectionReserveSeatsSubFixedEvent.CreateParameter("ReturnCode", 3, 4) 'As Integer and ParamReturnValue
		spSectionReserveSeatsSubFixedEvent.Parameters.Append spSectionReserveSeatsSubFixedEvent.CreateParameter("EventCode", 3, 1, , EventCode) 'As Integer and Input
		spSectionReserveSeatsSubFixedEvent.Parameters.Append spSectionReserveSeatsSubFixedEvent.CreateParameter("OrderNumber", 3, 1, , OrderNumber) 'As Integer and Input
		spSectionReserveSeatsSubFixedEvent.Parameters.Append spSectionReserveSeatsSubFixedEvent.CreateParameter("OrderTypeNumber", 3, 1, , OrderTypeNumber) 'As Integer and Input
		spSectionReserveSeatsSubFixedEvent.Parameters.Append spSectionReserveSeatsSubFixedEvent.CreateParameter("CommaDelimiter", 200, 1, 1, ",") 'As Varchar and Input
		spSectionReserveSeatsSubFixedEvent.Parameters.Append spSectionReserveSeatsSubFixedEvent.CreateParameter("ItemNumber", 200, 1, 5000, rsSeat("ItemNumber")) 'As Varchar and Input
		spSectionReserveSeatsSubFixedEvent.Parameters.Append spSectionReserveSeatsSubFixedEvent.CreateParameter("SellHold", 200, 1, 1, "Y") 'As Varchar and Input

		spSectionReserveSeatsSubFixedEvent.Execute

		ReturnCode = spSectionReserveSeatsSubFixedEvent.Parameters("ReturnCode")
		
		Response.Write "EventCode = " & EventCode & " | OldOrderNumber = " & OldOrderNumber & " | NewOrderNumber = " & OrderNumber & " | ItemNumber = " & rsSeat("ItemNumber") & "<BR>"
		
		If ReturnCode = 0 Then 'It was successful
		
			'Update the Shipping Info, Price, SeatType and ShipType in OrderLine

			'REE 7/27/2 - Modified to incorporate discounts
			'Initialize Price and Surcharge
			Price = 0
		
			'Get the price and surcharge
			'REE 8/10/3 - Added Subscription to Selection and Added ItemType
			SQLPrice = "SELECT Price.Price, Seat.EventCode, LineNumber, OrderLine.ItemType FROM Seat (NOLOCK) INNER JOIN Price (NOLOCK) ON Seat.EventCode = Price.EventCode AND Seat.SectionCode = Price.SectionCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber WHERE Seat.ItemNumber = " & rsSeat("ItemNumber") & " AND Price.SeatTypeCode = " & SeatTypeCode & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent')"
			Set rsPrice = OBJdbConnection.Execute(SQLPrice)

            If Not rsPrice.EOF Then
                If OrderTypeNumber = 5 Then 'Comp
			        Price = rsPrice("Price")
			        DiscountAmount = Price
			        DiscountTypeNumber = 1
                Else
			        Price = rsPrice("Price")
			        DiscountAmount = 0
			        DiscountTypeNumber = 0
                End If

			    'REE 8/10/3 - Modified to select OrderLine by LineNumber instead of Item and ItemType
			    SQLUpdateOrderLine = "UPDATE OrderLine WITH (ROWLOCK) SET Price = " & Price & ", Surcharge = " & Surcharge & ", SeatTypeCode = " & SeatTypeCode & ", Discount = 0, DiscountTypeNumber = 0, ShipCode = " & ShipCode & ", ShipFirstName = '" & Clean(rsTickets("ShipFirstName")) & "', ShipLastName = '" & Clean(rsTickets("ShipLastName")) & "', ShipAddress1 = '" & Clean(rsTickets("ShipAddress1")) & "', ShipAddress2 = '" & Clean(rsTickets("ShipAddress2")) & "', ShipCity = '" & Clean(rsTIckets("ShipCity")) & "', ShipState = '" & Clean(rsTickets("ShipState")) & "', ShipPostalCode = '" & Clean(rsTickets("ShipPostalCode")) & "', ShipCountry = '" & Clean(rsTickets("ShipCountry")) & "' WHERE OrderNumber = " & OrderNumber & " AND LineNumber = " & rsPrice("LineNumber")
			    Response.Write SQLUpdateOrderLine & "<BR>"
			    Set rsUpdateOrderLine = OBJdbConnection.Execute(SQLUpdateOrderLine)

			    'REE 8/10/3 - Added Update to Child Lines - Price and Surcharge are added as individual tickets and discounts are applied to mark down to zero
			    If rsPrice("ItemType") = "SubFixedEvent" Then
				    'Get the original price
				    SQLChildPrice = "SELECT Price.Price, Price.Surcharge, OrderLine.LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber LEFT JOIN Price (NOLOCK) ON Seat.EventCode = Price.EventCode AND Seat.SectionCode = Price.SectionCode AND Price.SeatTypeCode = " & SeatTypeCode & " WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.ParentLineNumber = " & rsPrice("LineNumber")
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
					    SQLUpdateChildLine = "UPDATE OrderLine WITH (ROWLOCK) SET Price = " & ChildPrice & ", Surcharge = " & ChildSurcharge & ", SeatTypeCode = " & SeatTypeCode & ", Discount = " & ChildDiscountAmount & ", DiscountTypeNumber = " & ChildDiscountTypeNumber & ", ShipCode = 1, ShipFirstName = '" & Clean(rsTickets("ShipFirstName")) & "', ShipLastName = '" & Clean(rsTickets("ShipLastName")) & "', ShipAddress1 = '" & Clean(rsTickets("ShipAddress1")) & "', ShipAddress2 = '" & Clean(rsTickets("ShipAddress2")) & "', ShipCity = '" & Clean(rsTickets("ShipCity")) & "', ShipState = '" & Clean(rsTickets("ShipState")) & "', ShipPostalCode = '" & Clean(rsTickets("ShipPostalCode")) & "', ShipCountry = '" & Clean(rsTickets("ShipCountry")) & "' WHERE OrderNumber = " & OrderNumber & " AND LineNumber = " & rsChildPrice("LineNumber")
					    Set rsUpdateChildLine = OBJdbConnection.Execute(SQLUpdateChildLine)
    					
					    rsChildPrice.MoveNext
				    Loop
    				
				    rsChildPrice.Close
				    Set rsChildPrice = nothing
    			
			    End If
    			
			    rsPrice.Close
			    Set rsPrice = nothing
    			
			    LineNumber = LineNumber + 1
    			TicketCount = TicketCount + 1
			
            Else 'No Price found
        		Response.Write "---Import Failed (Price) - OldOrderNumber = " & OldOrderNumber & " | NewOrderNumber = " & OrderNumber & " | Import Failed - CustomerNumber = " & rsTickets("CustomerNumber") & " | SectionCode = " & rsTickets("SectionCode") & " | Row = " & rsTickets("Row") & " | Seat = " & rsTickets("Seat") & "<BR>" & vbCrLf
    			FailedCount = FailedCount + 1
        		ReturnCode = 999
    		End If   
    			
		Else 'It failed
			
			Response.Write "---Import Failed (Child)  - OldOrderNumber = " & OldOrderNumber & " | NewOrderNumber = " & OrderNumber & " | Import Failed - CustomerNumber = " & rsTickets("CustomerNumber") & " | Section = " & rsTickets("SectionCode") & " | Row = " & rsTickets("Row") & " | Seat = " & rsTickets("Seat") & " | Return Code = " & ReturnCode & "<BR>" & vbCrLf
			FailedCount = FailedCount + 1
			
		End If

	Else

		Response.Write "---Import Failed (Parent) - OldOrderNumber = " & OldOrderNumber & " | NewOrderNumber = " & OrderNumber & " | Import Failed - CustomerNumber = " & rsTickets("CustomerNumber") & " | SectionCode = " & rsTickets("SectionCode") & " | Row = " & rsTickets("Row") & " | Seat = " & rsTickets("Seat") & "<BR>" & vbCrLf
		FailedCount = FailedCount + 1
		ReturnCode = 999

	End If
	
	rsTickets.MoveNext
	
Loop

'Update Last Order Totals
If OrderNumber <> 999999 And ReturnCode = 0 Then

	'Calculate Order Totals and Update OrderHeader for the LastOrderNumber
	SQLOrderLineTotals = "SELECT SUM(Price) AS Subtotal, SUM(Surcharge) AS Surcharge, SUM(Discount) AS DiscountAmount FROM OrderLine (ROWLOCK) WHERE OrderNumber = " & OrderNumber
	Response.Write SQLOrderLineTotals & "<BR>"
	Set rsOrderLineTotals = OBJdbConnection.Execute(SQLOrderLineTotals)
				

	'Update the OrderHeader
	SQLUpdateTotals = "UPDATE OrderHeader WITH (ROWLOCK) SET Subtotal = " & rsOrderLineTotals("Subtotal") & ", OrderSurcharge = " & rsOrderLineTotals("Surcharge") & ", ShipFee = " & ShipFee & ", Discount = " & rsOrderLineTotals("DiscountAmount") & ", Total = " & (rsOrderLineTotals("Subtotal") + rsOrderLineTotals("Surcharge") +  ShipFee) - rsOrderLineTotals("DiscountAmount") & " WHERE OrderNumber = " & OrderNumber
	Response.Write SQLUpdateTotals & "<BR>"
	Set rsUpdateTotals = OBJdbConnection.Execute(SQLUpdateTotals)

End If

		
Response.Write "Orders Added = " & OrderCount & "<BR>" & vbCrLf
Response.Write "Tickets Added = " & TicketCount & "<BR>" & vbCrLf
Response.Write "Failed Count = " & FailedCount & "<BR>" & vbCrLf

%>