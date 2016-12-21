<%

'CHANGE LOG
'JAI 06/01/12 - New per ticket discount script.  Combination of Amount, Percentage, and Fixed Price discounts.

'SSR 01/06/15 -	'Updated discount script.
				'Added expiration date check
				'Use the original order date not the current date to determine if a discount has expired.
				'This allows re-opened orders to receive the correct discount should they be re-opened after the discount expiration date

'SSR 04/03/15 - 'Updated discount script.
				'Added option to pass a new delivery surcharge, aka per order processing fee, aka ship fee 
				'Parameter: &NewShipFee=0

'SSR 04/28/15 - Extended this discount to allow a maximumn total of per ticket fees.

'SSR 06/29/15 - 'Updated discount script for San Diego Junior Theater
				'Added option to pass a per order discount.  
				'The discount amount is divided between the tickets on the order.
				'Example: $10 per order discount
				'Parameter: &SeriesDiscount=10
				'To limit the number of tickets to be discounted use:
				'Optional Parameter:  &Multiple=3
				
'SSR 07/01/15 - 'Updated to restrict the discount to the subfixed events only

'SSR 07/16/15 - 'Updated to allow discount to be applied to subscription and non-subscription events.

'SSR 09/08/15 - 'Updated discount script for TheaterZone-FL
				'Added option to change the ShipCode for the discounted ticket.
				'Parameter: &NewShipCode=4
				
'SSR 01/05/16 - 'Updated script for City of Cleremount
				'Ticket price includes ticket fees. They only want to discount the face value of the ticket before fees are added.
				'They will update the Fax Order Surcharge with the fee amount.  
				'This discount will take take that fee amount, deduct that amount from the ticket price, process the discount, and then add the fee amount back
				'Example.  $15.00 ticket (includes $5.00 fees) with 10% discount results in a $14.00 ticket with $1.00 discount


%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'---------------------------------------------

'Order Type where the fee amount will be listed
DIM OrderType
OrderType = 3

'---------------------------------------------

	If Request("ExpirationDate") <> "" Then

		ExpirationDate = Request("ExpirationDate")

		SQLDateCheck = "SELECT OrderHeader.OrderDate FROM OrderHeader (NOLOCK) WHERE OrderHeader.OrderNumber = " & OrderNumber & ""
		Set rsDateCheck = OBJdbConnection.Execute(SQLDateCheck)
		OriginalDate = rsDateCheck("OrderDate")
		rsDateCheck.Close
		Set rsDateCheck = nothing

		If CDate(OriginalDate) < CDate(ExpirationDate) Then  
			AllowDiscount = "Y"
		Else
			AllowDiscount = "N"
		End If
		
	End If

'---------------------------------------------

	If AllowDiscount = "Y" Then 'It's okay to apply to this order.
	
		Call ProcessDiscount
		Call ProcessSurcharge
		Call ProcessShipFee		
	
	End If	

	Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
	Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
	Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
	Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

'---------------------------------------------
	
	Sub ProcessDiscount
	
		'Process discount by percentage
		'-------------------------------------
		If Clean(Request("Percentage")) <> "" Then
					
			NewPrice = Round((CDbl(Clean(Request("Price"))) - fnTicketSurcharge) * (1-CDbl(Clean(Request("Percentage")))/100),2 ) + fnTicketSurcharge
			
		'Process discount set fixed price
		'-------------------------------------
		ElseIf Clean(Request("FixedPrice")) <> "" Then
		
			NewPrice = Round(CDbl(Clean(Request("FixedPrice"))),2)
		
		'Process discount by amount
		'-------------------------------------		
		ElseIf Clean(Request("DiscountAmount")) <> "" Then
		
			NewPrice = Round(CDbl(Clean(Request("Price"))),2) - round(CDbl(Clean(Request("DiscountAmount"))),2)
		
		
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

	Public Function fnTicketSurcharge

		DIM strResults
		strResults = 0

		If OrderType = "" Then
			OrderType = OrderTypeNumber
		End If
				
		'ErrorLog("OrderType: " & OrderType & "")
		'ErrorLog("EventCode: " & EventCode & "")
		'ErrorLog("SectionCode: " & SectionCode & "")
		'ErrorLog("SeatTypeCode: " & SeatTypeCode & "")
		
			SQLSearch = "SELECT Price.PhoneOrderSurcharge, Price.FaxOrderSurcharge, Price.MailOrderSurcharge, Price.BoxOfficeSurcharge, Price.Surcharge FROM Price (NOLOCK) WHERE Price.EventCode = " & EventCode & " AND Price.SectionCode = '" & SectionCode & "' AND Price.SeatTypeCode = " & SeatTypeCode & ""
			Set rsSearch = OBJdbConnection.Execute(SQLSearch) 
			
				If Not rsSearch.EOF Then
																	
					Select Case OrderType
						Case 1
							strResults = rsSearch("Surcharge")
						Case 2
							strResults = rsSearch("PhoneOrderSurcharge")
						Case 3
							strResults = rsSearch("FaxOrderSurcharge")
						Case 4
							strResults = rsSearch("MailOrderSurcharge")
						Case 7
							strResults = rsSearch("BoxOfficeSurcharge")
						Case Else
							strResults = 0
					End Select
					
					'ErrorLog("strResults: " & strResults & "")
					
				End If
			
			rsSearch.Close
			Set rsSearch = Nothing 
					
		fnTicketSurcharge = strResults
		
	End Function

'---------------------------------------------

%>