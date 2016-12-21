<!--#INCLUDE VIRTUAL="dbOpenInclude.asp" -->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<%

Server.ScriptTimeout = 3600

OrderExpirationDate = "12/31/2010"
SurveyNumber = 66

Surcharge = 0
ShipFee = 7
OrderNumber = 0
ShipCode = 18

SQLTickets = "SELECT * FROM BudParkConversion WHERE OrderNumber IS NULL ORDER BY OldCustomerNumber"
Response.Write SQLTickets & "<BR><BR>"
Set rsTickets = OBJdbConnection.Execute(SQLTickets)


Do Until rsTickets.EOF

	RecordNumber = rsTickets("RecordNumber")

	If rsTickets("OldCustomerNumber") <> OldCustomerNumber Then 'It's a new order
	

		If OrderNumber <> 0 Then 'Update the totals for the last order
		
			'Calculate Order Totals and Update OrderHeader for the LastOrderNumber
			SQLOrderLineTotals = "SELECT SUM(Price) AS Subtotal, SUM(Surcharge) AS Surcharge, SUM(Discount) AS DiscountAmount FROM OrderLine (ROWLOCK) WHERE OrderNumber = " & OrderNumber
			Response.Write SQLOrderLineTotals & "<BR><BR>"
			Set rsOrderLineTotals = OBJdbConnection.Execute(SQLOrderLineTotals)
				

			'Update the OrderHeader
			SQLUpdateTotals = "UPDATE OrderHeader WITH (ROWLOCK) SET Subtotal = " & rsOrderLineTotals("Subtotal") & ", OrderSurcharge = " & rsOrderLineTotals("Surcharge") & ", ShipFee = " & ShipFee & ", Discount = " & rsOrderLineTotals("DiscountAmount") & ", Total = " & (rsOrderLineTotals("Subtotal") + rsOrderLineTotals("Surcharge") +  ShipFee) - rsOrderLineTotals("DiscountAmount") & " WHERE OrderNumber = " & OrderNumber
			Response.Write SQLUpdateTotals & "<BR><BR>"
			Set rsUpdateTotals = OBJdbConnection.Execute(SQLUpdateTotals)
			
'			If OrderCount > 50 Then Exit Do
			
		End If

		OldCustomerNumber = rsTickets("OldCustomerNumber")

		FirstName = Clean(Left(rsTickets("FirstName"),30))
		MiddleInitial = NULL
		LastName = Clean(Left(rsTickets("LastName"),30))
		Address1 = Clean(Left(rsTickets("Address1"),50))
		Address2 = NULL
		City = Clean(Left(rsTickets("City"),50))
		State = Clean(Left(rsTickets("State"),30))
		PostalCode = Clean(Left(rsTickets("PostalCode"),20))
		Country = "Canada"
		DayPhone = Clean(Left(rsTickets("Phone"),20))
		NightPhone = Clean(Left(rsTickets("Phone"),20))
		EMailAddress = Clean(Left(rsTickets("EMailAddress"), 50))
		OptIn = 1

		If IsNull(rsTickets("CustomerNumber")) Then 'Add the customer record
	
			Set spInsertCustomer = Server.Createobject("Adodb.Command")
			Set spInsertCustomer.ActiveConnection = OBJdbConnection
			spInsertCustomer.Commandtype = 4 ' Value for Stored Procedure
			spInsertCustomer.Commandtext = "spInsertCustomer"
			spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("CustomerNumber", 3, 4) 'As Integer and ParamReturnValue
			spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("FirstName", 200, 1, 30, FirstName)'As Varchar and Input
			spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("MiddleInitial", 200, 1, 1, MiddleInitial) 'As Varchar and Input
			spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("LastName", 200, 1, 30, LastName) 'As Varchar and Input
			spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("Address1", 200, 1, 50, Address1) 'As Varchar and Input
			spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("Address2", 200, 1, 50, Address2) 'As Varchar and Input
			spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("City", 200, 1, 50, City) 'As Varchar and Input
			spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("State", 200, 1, 30, State) 'As Varchar and Input
			spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("PostalCode", 200, 1, 20, PostalCode) 'As Varchar and Input
			spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("Country", 200, 1, 30, Country) 'As Varchar and Input
			spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("DayPhone", 200, 1, 20, DayPhone) 'As Varchar and Input
			spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("NightPhone", 200, 1, 20, NightPhone) 'As Varchar and Input
			spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("EMailAddress", 200, 1, 50, EMailAddress) 'As Varchar and Input
			spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("UserID", 200, 1, 50, EMailAddress) 'As Varchar and Input
			spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("Password", 200, 1, 10, "BUDPARKADD") 'As Varchar and Input
			spInsertCustomer.Parameters.Append spInsertCustomer.CreateParameter("OptIn", 11, 1, , OptIn) 'As Boolean and Input
			spInsertCustomer.Execute

			CustomerNumber = spInsertCustomer.Parameters("CustomerNumber")

			If CustomerNumber = 0 Then
				Response.Write "Customer " & OldCustomerNumber & " Not Added.<BR>" & vbCrLf
			Else 
				'Add The Survey Info
				SQLSurvey = "INSERT SurveyAnswers(SurveyNumber, AnswerNumber, CustomerNumber, SurveyDate, Answer) VALUES(" & SurveyNumber & ", 1, " & CustomerNumber & ", '" & Now() & "', '" & OldCustomerNumber & "')"
				Set rsSurvey = OBJdbConnection.Execute(SQLSurvey)
					
				'Add The CustomerNumber
				SQLUpdateOldCustomer = "UPDATE BudParkConversion SET CustomerNumber = " & CustomerNumber & " WHERE OldCustomerNumber = '" & OldCustomerNumber & "'"
				Response.Write SQLUpdateOldCustomer & "<BR><BR>" & vbCrLf
				Set rsUpdateOldCustomer = OBJdbConnection.Execute(SQLUpdateOldCustomer)
			End If
			
		Else 'Get the Customer Number
		
			CustomerNumber = rsTickets("CustomerNumber")

		End If
		
		'Add the OrderHeader
		Set spInsertOrderHeader = Server.Createobject("Adodb.Command")
		Set spInsertorderHeader.ActiveConnection = OBJdbConnection
		spInsertOrderHeader.Commandtype = 4 ' Value for Stored Procedure
		spInsertOrderHeader.Commandtext = "spInsertOrderHeader"
		spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("OrderNumber", 3, 4) 'As Integer and ParamReturnValue
		spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("CustomerNumber", 3, 1, , CustomerNumber) 'As Integer and Input
		spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("OrderTypeNumber", 3, 1, , 7) 'As Integer and Input.  7 is Box Office.
		spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("UserNumber", 3, 1, , 1) 'As Integer and Input
		spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("OrderExpirationDate", 7, 1, , OrderExpirationDate) 'As Date and Input
		spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("IPAddress", 200, 1, 15, "BUD PARK ADD") 'As Varchar and Input
		spInsertOrderHeader.Execute

		OrderNumber = spInsertOrderHeader.Parameters("OrderNumber")
		OrderCount = OrderCount + 1
		LineNumber = 1

	End If
	
	Select Case rsTickets("EventCode")
	
		Case 20336 'Weekend Pass
		
			'Get ItemNumber
			SQLItemNumber = "SELECT ItemNumber FROM Seat (NOLOCK) WHERE EventCode = " & rsTickets("EventCode") & " AND SectionCode = '" & rsTickets("SectionCode") & "' AND Row = '" & rsTickets("Row") & "' AND Seat = '" & rsTickets("Seat") & "' AND StatusCode IN ('A', 'H')"
			Response.Write SQLItemNumber & "<BR><BR>"
			Set rsItemNumber = OBJdbConnection.Execute(SQLItemNumber)

			If Not rsItemNumber.EOF Then
			
				ItemNumber = rsItemNumber("ItemNumber")

				Set spSectionReserveSeatsSubFixedEvent = Server.Createobject("Adodb.Command")
				Set spSectionReserveSeatsSubFixedEvent.ActiveConnection = OBJdbConnection
				spSectionReserveSeatsSubFixedEvent.Commandtype = 4 ' Value for Stored Procedure
				spSectionReserveSeatsSubFixedEvent.Commandtext = "spSectionReserveSeatsSubFixedEvent"
				spSectionReserveSeatsSubFixedEvent.Parameters.Append spSectionReserveSeatsSubFixedEvent.CreateParameter("ReturnCode", 3, 4) 'As Integer and ParamReturnValue
				spSectionReserveSeatsSubFixedEvent.Parameters.Append spSectionReserveSeatsSubFixedEvent.CreateParameter("EventCode", 3, 1, , rsTickets("EventCode")) 'As Integer and Input
				spSectionReserveSeatsSubFixedEvent.Parameters.Append spSectionReserveSeatsSubFixedEvent.CreateParameter("OrderNumber", 3, 1, , OrderNumber) 'As Integer and Input
				spSectionReserveSeatsSubFixedEvent.Parameters.Append spSectionReserveSeatsSubFixedEvent.CreateParameter("OrderTypeNumber", 3, 1, , 7) 'As Integer and Input
				spSectionReserveSeatsSubFixedEvent.Parameters.Append spSectionReserveSeatsSubFixedEvent.CreateParameter("CommaDelimiter", 200, 1, 1, ",") 'As Varchar and Input
				spSectionReserveSeatsSubFixedEvent.Parameters.Append spSectionReserveSeatsSubFixedEvent.CreateParameter("ItemNumber", 200, 1, 5000, ItemNumber) 'As Varchar and Input
				spSectionReserveSeatsSubFixedEvent.Parameters.Append spSectionReserveSeatsSubFixedEvent.CreateParameter("SellHold", 200, 1, 1, "Y") 'As Varchar and Input

				spSectionReserveSeatsSubFixedEvent.Execute

				ReturnCode = spSectionReserveSeatsSubFixedEvent.Parameters("ReturnCode")
				
				Response.Write "EventCode = " & rsTickets("EventCode") & " | OldOrderNumber = " & rsTickets("OldCustomerNumber") & " | NewOrderNumber = " & OrderNumber & " | ItemNumber = " & rsItemNumber("ItemNumber") & "<BR>"
				
				If ReturnCode = 0 Then 'It was successful
				
					'Update the Shipping Info, Price, SeatType and ShipType in OrderLine

					'REE 7/27/2 - Modified to incorporate discounts
					'Initialize Price and Surcharge
					Price = 0
				
					'Get the price and surcharge
					SQLPrice = "SELECT Price FROM Price WHERE EventCode = " & rsTickets("EventCode") & " AND SectionCode = '" & rsTickets("SectionCode") & " ' AND SeatTypeCode = " & rsTickets("SeatTypeCode")
					Response.Write SQLPrice & "<BR><BR>" & vbCrLf
					Set rsPrice = OBJdbConnection.Execute(SQLPrice)
					
					If Not rsPrice.EOF Then

						Price = rsPrice("Price")
						Surcharge = 0
						DiscountAmount = 0
						DiscountTypeNumber = 0
					
						'REE 8/10/3 - Modified to select OrderLine by LineNumber instead of Item and ItemType
						SQLUpdateOrderLine = "UPDATE OrderLine WITH (ROWLOCK) SET Price = " & Price & ", Surcharge = " & Surcharge & ", SeatTypeCode = " & rsTickets("SeatTypeCode") & ", Discount = 0, DiscountTypeNumber = 0, ShipCode = " & ShipCode & ", ShipFirstName = '" & FirstName & "', ShipLastName = '" & LastName & "', ShipAddress1 = '" & Address1 & "', ShipAddress2 = '" & Address2 & "', ShipCity = '" & City & "', ShipState = '" & State & "', ShipPostalCode = '" & PostalCode & "', ShipCountry = '" & Country & "' WHERE OrderNumber = " & OrderNumber & " AND LineNumber = " & LineNumber
						Response.Write SQLUpdateOrderLine & "<BR><BR>"
						Set rsUpdateOrderLine = OBJdbConnection.Execute(SQLUpdateOrderLine)

						'REE 8/10/3 - Added Update to Child Lines - Price and Surcharge are added as individual tickets and discounts are applied to mark down to zero
						'Get the original price
						SQLChildPrice = "SELECT Price.Price, Price.Surcharge, OrderLine.LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber LEFT JOIN Price (NOLOCK) ON Seat.EventCode = Price.EventCode AND Seat.SectionCode = Price.SectionCode AND Price.SeatTypeCode = " & rsTickets("SeatTypeCode") & " WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.ParentLineNumber = " & LineNumber
						Response.Write SQLChildPrice & "<BR><BR>" & vbCrLf
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
							SQLUpdateChildLine = "UPDATE OrderLine WITH (ROWLOCK) SET Price = " & ChildPrice & ", Surcharge = " & ChildSurcharge & ", SeatTypeCode = " & rsTickets("SeatTypeCode") & ", Discount = " & ChildDiscountAmount & ", DiscountTypeNumber = " & ChildDiscountTypeNumber & ", ShipCode = " & ShipCode & ", ShipFirstName = '" & FirstName & "', ShipLastName = '" & LastName & "', ShipAddress1 = '" & Address1 & "', ShipAddress2 = '" & Address2 & "', ShipCity = '" & City & "', ShipState = '" & State & "', ShipPostalCode = '" & PostalCode & "', ShipCountry = '" & Country & "' WHERE OrderNumber = " & OrderNumber & " AND LineNumber = " & rsChildPrice("LineNumber")
							Response.Write SQLUpdateChildLine & "<BR><BR>" & vbCrLf
							Set rsUpdateChildLine = OBJdbConnection.Execute(SQLUpdateChildLine)
							
							LineNumber = LineNumber + 1
								
							rsChildPrice.MoveNext
						Loop
							
						rsChildPrice.Close
						Set rsChildPrice = nothing

						rsPrice.Close
						Set rsPrice = nothing
					
						Call RecordAdded(RecordNumber, OrderNumber)
						LineNumber = LineNumber + 1
						TicketCount = TicketCount + 1
					Else
					
						Call RecordFailed(RecordNumber, OrderNumber, "VIP Event - No Price Record")
						FailedCount = FailedCount + 1

					End If 
	
				Else

					Call RecordFailed(RecordNumber, OrderNumber, "VIP Event - Stored Procedure Failed")
					FailedCount = FailedCount + 1

				End If
				
			Else
			
				Call RecordFailed(RecordNumber, OrderNumber, "Unavailable Seat - VIP")
				FailedCount = FailedCount + 1
				
			End If
			
		Case 20334, 20335, 20756 'Saturday Reserved, Sunday, and Motorhome
		
			'Get ItemNumber
			SQLItemNumber = "SELECT ItemNumber FROM Seat (NOLOCK) WHERE EventCode = " & rsTickets("EventCode") & " AND SectionCode = '" & rsTickets("SectionCode") & "' AND Row = '" & rsTickets("Row") & "' AND Seat = '" & rsTickets("Seat") & "' AND StatusCode IN ('A', 'H')"
			Response.Write SQLItemNumber & "<BR><BR>"
			Set rsItemNumber = OBJdbConnection.Execute(SQLItemNumber)
			
			If Not rsItemNumber.EOF Then
			
				ItemNumber = rsItemNumber("ItemNumber")

				Set spSectionReserveSeats = Server.Createobject("Adodb.Command")
				Set spSectionReserveSeats.ActiveConnection = OBJdbConnection
				spSectionReserveSeats.Commandtype = 4 ' Value for Stored Procedure
				spSectionReserveSeats.Commandtext = "spSectionReserveSeats"
				spSectionReserveSeats.Parameters.Append spSectionReserveSeats.CreateParameter("ReturnCode", 3, 4) 'As Integer and ParamReturnValue
				spSectionReserveSeats.Parameters.Append spSectionReserveSeats.CreateParameter("RowsUpdated", 3, 2) 'As Integer and Output
				spSectionReserveSeats.Parameters.Append spSectionReserveSeats.CreateParameter("EventCode", 3, 1, , rsTickets("EventCode")) 'As Integer and Input
				spSectionReserveSeats.Parameters.Append spSectionReserveSeats.CreateParameter("OrderNumber", 3, 1, , OrderNumber) 'As Integer and Input
				spSectionReserveSeats.Parameters.Append spSectionReserveSeats.CreateParameter("AcceptAvailable", 200, 1, 1, "N") 'As Varchar and Input
				spSectionReserveSeats.Parameters.Append spSectionReserveSeats.CreateParameter("CommaDelimiter", 200, 1, 1, ",") 'As Varchar and Input
				spSectionReserveSeats.Parameters.Append spSectionReserveSeats.CreateParameter("ItemNumber", 200, 1, 5000, ItemNumber) 'As Varchar and Input
				spSectionReserveSeats.Parameters.Append spSectionReserveSeats.CreateParameter("SellHold", 200, 1, 1, "Y") 'As Varchar and Input
	
				spSectionReserveSeats.Execute

				ReturnCode = spSectionReserveSeats.Parameters("ReturnCode")
				RowsUpdated = spSectionReserveSeats.Parameters("RowsUpdated")
				
				If ReturnCode = 0 Then
				
					Price = 0
				
					'Get the Price
					SQLPrice = "SELECT Price FROM Price WHERE EventCode = " & rsTickets("EventCode") & " AND SectionCode = '" & rsTickets("SectionCode") & " ' AND SeatTypeCode = " & rsTickets("SeatTypeCode")
					Response.Write SQLPrice & "<BR><BR>" & vbCrLf
					Set rsPrice = OBJdbConnection.Execute(SQLPrice)
					
					If Not rsPrice.EOF Then
					
						Price = rsPrice("Price")
						Surcharge = 0
						DiscountAmount = 0
						DiscountTypeNumber = 0

						'REE 8/10/3 - Modified to select OrderLine by LineNumber instead of Item and ItemType
						SQLUpdateOrderLine = "UPDATE OrderLine WITH (ROWLOCK) SET Price = " & Price & ", Surcharge = " & Surcharge & ", SeatTypeCode = " & rsTickets("SeatTypeCode") & ", Discount = 0, DiscountTypeNumber = 0, ShipCode = " & ShipCode & ", ShipFirstName = '" & FirstName & "', ShipLastName = '" & LastName & "', ShipAddress1 = '" & Address1 & "', ShipAddress2 = '" & Address2 & "', ShipCity = '" & City & "', ShipState = '" & State & "', ShipPostalCode = '" & PostalCode & "', ShipCountry = '" & Country & "' WHERE OrderNumber = " & OrderNumber & " AND LineNumber = " & LineNumber
						Response.Write SQLUpdateOrderLine & "<BR><BR>"
						Set rsUpdateOrderLine = OBJdbConnection.Execute(SQLUpdateOrderLine)

						Call RecordAdded(RecordNumber, OrderNumber)
						LineNumber = LineNumber + 1
						TicketCount = TicketCount + 1
						
					Else

						Call RecordFailed(RecordNumber, OrderNumber, "Reserved Event - No Price Record")
						FailedCount = FailedCount + 1
						
					End If
					
				Else

					Call RecordFailed(RecordNumber, OrderNumber, "Reserved Event Stored Procedure Failed")
					FailedCount = FailedCount + 1

				End If
				
			Else
			
				Call RecordFailed(RecordNumber, OrderNumber, "Unavailable Seat")
				FailedCount = FailedCount + 1
			
			End If

		
		Case Else 'GA
		
			Set spEventReserveSeats = Server.Createobject("Adodb.Command")
			Set spEventReserveSeats.ActiveConnection = OBJdbConnection
			spEventReserveSeats.Commandtype = 4 ' Value for Stored Procedure
			spEventReserveSeats.Commandtext = "spEventReserveSeats"
			spEventReserveSeats.Parameters.Append spEventReserveSeats.CreateParameter("ReturnCode", 3, 4) 'As Integer and ParamReturnValue
			spEventReserveSeats.Parameters.Append spEventReserveSeats.CreateParameter("EventCode", 3, 1, , rsTickets("EventCode")) 'As Integer and Input
			spEventReserveSeats.Parameters.Append spEventReserveSeats.CreateParameter("OrderNumber", 3, 1, , OrderNumber) 'As Integer and Input
			spEventReserveSeats.Parameters.Append spEventReserveSeats.CreateParameter("SeatCount", 3, 1, , 1) 'As Integer and Input
			spEventReserveSeats.Parameters.Append spEventReserveSeats.CreateParameter("SectionCode", 200, 1, 5, rsTickets("SectionCode")) 'As Varchar and Input with Section Code for General Admission events.
			spEventReserveSeats.Execute
			
			Response.Write "Event Code = " & rsTickets("EventCode") & "<BR><BR>"
			Response.Write "Order Number = " & OrderNumber & "<BR><BR>"
			Response.Write "SectionCode = " & rsTickets("SectionCode") & "<BR><BR>"

			ReturnCode = spEventReserveSeats.Parameters("ReturnCode")

			Response.Write "ReturnCode = " & ReturnCode & "<BR><BR>"
			

			
			If ReturnCode = 0 Then
			
				Price = 0

				'Get the Price
				SQLPrice = "SELECT Price FROM Price WHERE EventCode = " & rsTickets("EventCode") & " AND SectionCode = '" & rsTickets("SectionCode") & " ' AND SeatTypeCode = " & rsTickets("SeatTypeCode")
				Response.Write SQLPrice & "<BR><BR>" & vbCrLf
				Set rsPrice = OBJdbConnection.Execute(SQLPrice)
					
				If Not rsPrice.EOF Then
				
					Price = rsPrice("Price")
					Surcharge = 0
					DiscountAmount = 0
					DiscountTypeNumber = 0
					
					'REE 8/10/3 - Modified to select OrderLine by LineNumber instead of Item and ItemType
					SQLUpdateOrderLine = "UPDATE OrderLine WITH (ROWLOCK) SET Price = " & Price & ", Surcharge = " & Surcharge & ", SeatTypeCode = " & rsTickets("SeatTypeCode") & ", Discount = 0, DiscountTypeNumber = 0, ShipCode = " & ShipCode & ", ShipFirstName = '" & FirstName & "', ShipLastName = '" & LastName & "', ShipAddress1 = '" & Address1 & "', ShipAddress2 = '" & Address2 & "', ShipCity = '" & City & "', ShipState = '" & State & "', ShipPostalCode = '" & PostalCode & "', ShipCountry = '" & Country & "' WHERE OrderNumber = " & OrderNumber & " AND LineNumber = " & LineNumber
					Response.Write SQLUpdateOrderLine & "<BR><BR>"
					Set rsUpdateOrderLine = OBJdbConnection.Execute(SQLUpdateOrderLine)

					Call RecordAdded(RecordNumber, OrderNumber)
					LineNumber = LineNumber + 1
					TicketCount = TicketCount + 1
						
				Else

					Call RecordFailed(RecordNumber, OrderNumber, "GA Event - No Price Record")
					FailedCount = FailedCount + 1
						
				End If
				
			Else

				Call RecordFailed(RecordNumber, OrderNumber, "GA Event - Stored Procedure Failed")
				FailedCount = FailedCount + 1

			End If
	
	End Select
	
	rsTickets.MoveNext		
		
Loop

'Update the last order totals

'Calculate Order Totals and Update OrderHeader for the LastOrderNumber
SQLOrderLineTotals = "SELECT SUM(Price) AS Subtotal, SUM(Surcharge) AS Surcharge, SUM(Discount) AS DiscountAmount FROM OrderLine (ROWLOCK) WHERE OrderNumber = " & OrderNumber
Response.Write SQLOrderLineTotals & "<BR><BR>"
Set rsOrderLineTotals = OBJdbConnection.Execute(SQLOrderLineTotals)
				

'Update the OrderHeader
SQLUpdateTotals = "UPDATE OrderHeader WITH (ROWLOCK) SET Subtotal = " & rsOrderLineTotals("Subtotal") & ", OrderSurcharge = " & rsOrderLineTotals("Surcharge") & ", ShipFee = " & ShipFee & ", Discount = " & rsOrderLineTotals("DiscountAmount") & ", Total = " & (rsOrderLineTotals("Subtotal") + rsOrderLineTotals("Surcharge") +  ShipFee) - rsOrderLineTotals("DiscountAmount") & " WHERE OrderNumber = " & OrderNumber
Response.Write SQLUpdateTotals & "<BR><BR>"
Set rsUpdateTotals = OBJdbConnection.Execute(SQLUpdateTotals)


Response.Write "Orders Added = " & OrderCount & "<BR>" & vbCrLf
Response.Write "Tickets Added = " & TicketCount & "<BR>" & vbCrLf
Response.Write "Failed Count = " & FailedCount & "<BR>" & vbCrLf

			
Sub RecordAdded(RecordNumber, OrderNumber)

'Update record with OrderNumber		
SQLUpdateOrderNumber = "UPDATE BudParkConversion SET OrderNumber = " & OrderNumber & " WHERE RecordNumber = " & RecordNumber
Response.Write SQLUpdateOrderNumber & "<BR><BR>" & vbCrLf
Set rsUpdateOrderNumber = OBJdbConnection.Execute(SQLUpdateOrderNumber)

End Sub 'RecordAdded

Sub RecordFailed(RecordNumber, OrderNumber, Message)

Response.Write "Failed - OrderNumber = " & OrderNumber & " | RecordNumber = " & RecordNumber & " | Message = " & Message & "<BR>" & vbCrLf

End Sub 'RecordFailed

		

%>