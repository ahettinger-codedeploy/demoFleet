<%

'CHANGE LOG

'SSR 09/15/15	'Created BuyXGetY discount where X and Y are eventcodes. Based on the generic BuyXGetY discount script.

				'5 Required Parameters:  
				'(1) Required Event Code:  &RequiredEvent=
				'(2) Number of required event tickets: &RequiredQty=
				'(3) Offer Event Code: &OfferEvent=
				'(4) Number of offer event tickets: &OfferQty=1
				'(5) Discount type (Percentage, Discount Amount, Fixed Price) 
		
%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'---------------------------------------------------------

'Initialize Discount Variables

DIM RequiredEvent
RequiredEvent = Clean(Request("RequiredEvent"))

DIM RequiredQty
RequiredQty = Clean(Request("RequiredQty"))

DIM OfferEvent
OfferEvent = Clean(Request("OfferEvent"))

DIM OfferQty
OfferQty = Clean(Request("OfferQty"))

DIM TicketCount 
TicketCount = 0


'---------------------------------------------------------

	If AllowDiscount = "Y" Then 'It's okay to apply to this order type and Seat Type.

		'Determine # of required event tickets 
		SQLCount = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ItemType = 'Seat' AND EventCode IN (" & RequiredEventCode & ")"
		Set rsCount = OBJdbConnection.Execute(SQLCount)
			TicketCount = rsCount("TicketCount")
		rsCount.Close
		Set rsCount = nothing
		

		If cInt(TicketCount) >= cInt(RequiredQty) Then 'Need to have at least one ticket on order
		
			'Count # of offer event tickets which have discount applied.
			SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber  & " AND Event.EventCode IN (" & OfferEvent & ")"
			Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)

				'Select the lowest price ticket from the offer event
				SQLMinPrice = "SELECT MIN(OrderLine.Price) AS MinPrice FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode IN (" & OfferEvent & ") AND OrderLine.DiscountTypeNumber <> " & DiscountTypeNumber  & " AND OrderLine.Price > 0"
				Set rsMinPrice = OBJdbConnection.Execute(SQLMinPrice)
				MinPrice = rsMinPrice("MinPrice")
				rsMinPrice.Close
				Set rsMinPrice = nothing
			
				If Fix(rsDiscCount("LineCount")) < (Fix(TicketCount) * OfferQty) And CDbl(Price) = MinPrice Then 'Apply the discount
					Call ProcessDiscount
					Call ProcessSurcharge
				End If
			
			rsDiscCount.Close
			Set rsDiscCount = nothing

		End If
		
		
	End If
					
	Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
	Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
	Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
	Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

'---------------------------------------------------------
	
	Sub ProcessDiscount

		'Process discount by percentage
		'-------------------------------------
		If Clean(Request("Percentage")) <> "" Then
		
			NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Clean(Request("Percentage")))/100), 2)
			
		'Process discount set fixed price
		'-------------------------------------
		ElseIf Clean(Request("FixedPrice")) <> "" Then
		
			NewPrice = round(CDbl(Clean(Request("FixedPrice"))),2)
		
		'Process discount by amount
		'-------------------------------------		
		ElseIf Clean(Request("DiscountAmount")) <> "" Then
		
			NewPrice = round(CDbl(Clean(Request("Price"))),2) - round(CDbl(Clean(Request("DiscountAmount"))),2)
		
		
		'Process discount by series price
		'Takes the total series price and divides it amoung the tickets
		'-------------------------------------		
		ElseIf Clean(Request("SeriesPrice")) <> "" Then

			SeriesPrice = round(CDbl(Clean(Request("SeriesPrice"))),2)
			
			'Series Count
			SeriesCount = Clean(Request("Multiple"))
			
			'Count # of applied tickets on this order
			SQLCount = "SELECT COUNT(*) AS AppliedCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND DiscountTypeNumber = " & DiscountTypeNumber
			Set rsCount = OBJdbConnection.Execute(SQLCount)
				TotalAppliedCount = rsCount("AppliedCount")
			rsCount.Close
			Set rsCount = nothing
		
			'MOD function to determine the last ticket
			Remainder = TotalAppliedCount MOD SeriesCount

			'Calculates the discount to be assign to last ticket.
			If Remainder = SeriesCount - 1 Then 
				NewPrice = SeriesPrice - ((SeriesCount - 1) * Round(SeriesPrice / SeriesCount, 2))
			Else
			'Standard rounding on all other tickets.
				NewPrice = Round(SeriesPrice/SeriesCount, 2)
			End If

		'Process series discount
		'Takes the total discount allowed and divides it amoung the tickets
		'-------------------------------------		
		ElseIf Clean(Request("SeriesDiscount")) <> "" Then

			SeriesDiscount = round(CDbl(Clean(Request("SeriesDiscount"))),2)
			Price = round(CDbl(Clean(Request("Price"))),2)
			
			'Series Count (if "Multiple" is left blank - discount applied to all tickets)
			If Clean(Request("Multiple")) <> "" Then
				SeriesCount = Clean(Request("Multiple"))
			Else
				SQLCount = "SELECT COUNT(*) AS SeriesCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND OrderLine.ItemType IN ('SubFixedEvent','Seat')"
				Set rsCount = OBJdbConnection.Execute(SQLCount)
					SeriesCount = rsCount("SeriesCount")
				rsCount.Close
				Set rsCount = nothing
			
			End If
			
			'Count # of applied tickets on this order
			SQLCount = "SELECT COUNT(*) AS AppliedCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('SubFixedEvent')"
			Set rsCount = OBJdbConnection.Execute(SQLCount)
				TotalAppliedCount = rsCount("AppliedCount")
			rsCount.Close
			Set rsCount = nothing
		
			'MOD function to determine the last ticket
			Remainder = TotalAppliedCount MOD SeriesCount

			'Calculates the discount to be assign to last ticket.
			If Remainder = SeriesCount - 1 Then 
				DiscountAmount = SeriesDiscount - ((SeriesCount - 1) * Round(SeriesDiscount / SeriesCount, 2))
				NewPrice = Price - DiscountAmount
			Else
			'Standard rounding on all other tickets.
				DiscountAmount = Round(SeriesDiscount / SeriesCount, 2)
				NewPrice = Price - DiscountAmount
			End If

		Else
		
			NewPrice = round(CDbl(Clean(Request("Price"))))
		
		End If

		
		If NewPrice < 0 Then
			NewPrice = 0
		End If
		
		DiscountAmount = Round(Clean(Request("Price")),2) - NewPrice
		
		If NewSurcharge <> "" Then
			Surcharge = NewSurcharge
		ElseIf Request("CalcServiceFee") <> "N" Then
			Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
		End If

		AppliedFlag = "Y"
	
	End Sub

'---------------------------------------------

	Sub ProcessSurcharge

		'Process per ticket service fees

		If AppliedFlag = "Y" Then
			
			'Apply new surcharge
			'-------------------------------------
			If Clean(Request("NewSurcharge")) <> "" Then
			
				Surcharge = Request("NewSurcharge")
					
			'Recalculate the surcharge
			'-------------------------------------
			ElseIf Request("CalcServiceFee") <> "N" Then
				
				Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))			

			'Apply order surcharge
			'-------------------------------------
			ElseIf Clean(Request("OrderSurcharge")) <> "" Then
				
				OrderSurcharge = Round(CDbl(Clean(Request("OrderSurcharge"))),2)

				SQLCount = "SELECT COUNT(*) AS SeriesCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & OrderNumber & ""
				Set rsCount = OBJdbConnection.Execute(SQLCount)
				SeriesCount = rsCount("SeriesCount")
				rsCount.Close
				Set rsCount = nothing
				
				SQLCount = "SELECT COUNT(*) AS AppliedCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND DiscountTypeNumber = " & DiscountTypeNumber
				Set rsCount = OBJdbConnection.Execute(SQLCount)
				TotalAppliedCount = rsCount("AppliedCount")
				rsCount.Close
				Set rsCount = nothing
			
				Remainder = TotalAppliedCount MOD SeriesCount

				If Remainder = SeriesCount - 1 Then 
					Surcharge = OrderSurcharge - ((SeriesCount - 1) * Round(OrderSurcharge / SeriesCount, 2))
				Else
					Surcharge = Round(OrderSurcharge/SeriesCount, 2)
				End If
				
			End If
			
		End If

	End Sub	

'---------------------------------------------

	Sub ProcessShipFee

		If AppliedFlag = "Y" Then
		
			'Apply New Ship Type
			If Clean(Request("NewShipCode")) <> "" Then
			
				NewShipCode = Clean(Request("NewShipCode"))
			
				SQLUpdate = "UPDATE OrderLine SET ShipCode = " & NewShipCode & " WHERE OrderLine.OrderNumber = " & OrderNumber & "" 
				Set rsUpdate  = OBJdbConnection.Execute(SQLUpdate)
				
			End If

			'Apply New Ship Fee
			If Clean(Request("NewShipFee")) <> "" Then
			
				NewShipFee = Clean(Request("NewShipFee"))
				
				SQLUpdate = "UPDATE OrderHeader SET ShipFee = " & NewShipFee & " WHERE OrderHeader.OrderNumber = " & OrderNumber & " "
				Set rsUpdate  = OBJdbConnection.Execute(SQLUpdate)
				
			End If

		End If
			
	End Sub	

'---------------------------------------------

%>