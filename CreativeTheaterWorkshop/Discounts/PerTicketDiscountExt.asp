<%

'CHANGE LOG
'JAI 06/01/12 - 	New per ticket discount script.  Combination of Amount, Percentage, and Fixed Price discounts.
'			Discount Definition - Required/Optional Parameters
'			Required
'			1) Percentage, DiscountAmount, or FixedPrice - To define the amount to discount
'			Optional
'			4) All fields in DiscountScriptInclude

'SSR 06/03/15	Updated to allow re-opened orders with expired discounts to calculate correctly.

'SSR 07/05/14	Updated to allow a per order surcharge to be passed.

'SSR 10/01/14	Updated to allow a new delivery surcharge to be passed.

'SSR 04/03/15	Updated to allow discounting the per ticket service fee.

'SSR 04/28/15	Updated to allow setting a maximumn cap on the total of per ticket fees.

'SSR 06/29/15	Updated to allow a per order discount
'			The discount amount is divided between all the tickets on the order.
'
'			Parameter: &SeriesDiscount=10
'			Optional Parameter:  &Multiple=3 (limit number of tickets)
'				
'SSR 07/01/15	Updated to restrict the discount to the subfixed events only

'SSR 07/16/15	Updated to allow discount to be applied to subscription and non-subscription events.

'SSR 04/28/16 -   Updated to allow discount by ticket type
		     'Example: DiscountAmount=2,4,6&AllowedSeatTypeCode=1,23,1314

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'---------------------------------------------

	'Discount Variables
	DIM NewPrice
	DIM DiscountAmount
	DIM Surcharge

'---------------------------------------------

	If AllowDiscount = "Y" Then 'It's okay to apply to this order.
	
		Call ProcessTicketDiscount
		
		If DiscountAmount <> "" Then
		
			Call ProcessTicketSurcharge
			Call ProcessDeliverySurcharge	
			
			AppliedFlag = "Y"
			
		End If
	
	End If	

	Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
	Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
	Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
	Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

'---------------------------------------------

	Sub ProcessTicketDiscount

			'Percentage Discount
			'-------------------------------------
			If Clean(Request("Percentage")) <> "" Then

				NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(fnDiscPrice("Percentage"))/100), 2)
				
			'Fixed Price
			'-------------------------------------
			ElseIf Clean(Request("FixedPrice")) <> "" Then

				NewPrice = round(CDbl(fnDiscPrice("FixedPrice")),2)
				
			'Discount Amount
			'-------------------------------------
			ElseIf Clean(Request("DiscountAmount")) <> "" Then

				NewPrice = round(CDbl(Clean(Request("Price"))),2) - round(CDbl(fnDiscPrice("DiscountAmount")),2)
			
			'Series Price
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
			
				'MOD function to determine the last ticket to complete the subscription discount (i.e. fourth ticket in the FlexPass-4, or eighth ticket in a FlexPass-8, etc.).  
				Remainder = TotalAppliedCount MOD SeriesCount

				'Calculates the total of all discounted ticket prices already given to figure out the discounted ticket price to be assign to this ticket.
				If Remainder = SeriesCount - 1 Then 
					NewPrice = SeriesPrice - ((SeriesCount - 1) * Round(SeriesPrice / SeriesCount, 2))
				Else
				'Standard rounding on all other tickets.
					NewPrice = Round(SeriesPrice/SeriesCount, 2)
				End If

			'Series Discount
			'-------------------------------------		
			ElseIf Clean(Request("SeriesDiscount")) <> "" Then

				SeriesDiscount = round(CDbl(Clean(Request("SeriesDiscount"))),2)
				Price = round(CDbl(Clean(Request("Price"))),2)
				
				'Series Count (if "Multiple" is left blank - discount applied to all tickets)
				SQLCount = "SELECT COUNT(*) AS SeriesCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND OrderLine.ItemType IN ('SubFixedEvent','Seat')"
				Set rsCount = OBJdbConnection.Execute(SQLCount)
					SeriesCount = rsCount("SeriesCount")
				rsCount.Close
				Set rsCount = nothing

				'Count # of applied tickets on this order
				SQLCount = "SELECT COUNT(*) AS AppliedCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('SubFixedEvent','Seat')"
				Set rsCount = OBJdbConnection.Execute(SQLCount)
					TotalAppliedCount = rsCount("AppliedCount")
				rsCount.Close
				Set rsCount = nothing
			
				'MOD function to determine the last ticket to complete the subscription discount (i.e. fourth ticket in the FlexPass-4, or eighth ticket in a FlexPass-8, etc.).  
				Remainder = TotalAppliedCount MOD SeriesCount

				'Calculates the total of all discounted ticket prices already given to figure out the discounted ticket price to be assign to this ticket.
				If Remainder = SeriesCount - 1 Then 
					DiscountAmount = SeriesDiscount - ((SeriesCount - 1) * Round(SeriesDiscount / SeriesCount, 2))
					NewPrice = Price - DiscountAmount
				Else
				'Standard rounding on all other tickets.
					DiscountAmount = Round(SeriesDiscount / SeriesCount, 2)
					NewPrice = Price - DiscountAmount
				End If

			End If
			
			
			If NewPrice < Price Then
			
				If NewPrice < 0 Then
					NewPrice = 0
				End If
				
				DiscountAmount = Round(Clean(Request("Price")),2) - NewPrice
				
				AppliedFlag = "Y"
				
			End If

	End Sub

'---------------------------------------------

	Sub ProcessTicketSurcharge
	
			'Recalculate existing surcharge
			'-------------------------------------
			If Clean(Request("CalcServiceFee")) <> "N" Then
				Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
	
		
			'Apply new surcharge - by amount
			'-------------------------------------
			ElseIf Clean(Request("NewSurcharge")) <> "" Then
				Surcharge = Request("NewSurcharge")
				
				
			'Apply new surcharge - by percentage
			'-------------------------------------
			ElseIf Clean(Request("NewSurchargePercentage")) <> "" Then
				Surcharge = round(((NewPrice)*((Request("NewSurchargePercentage"))/100)),2)

				
			'Apply new surcharge - per order
			'-------------------------------------
			ElseIf Clean(Request("NewSurchargeOrder")) <> "" Then
			
				OrderSurcharge = Round(CDbl(Clean(Request("NewSurchargeOrder"))),2)

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

				
			'Discount the existing surcharge - by percentage
			'---------------------------------------
			ElseIf Clean(Request("DiscSurchargePercentage")) <> "" Then
				Surcharge = round(CDbl(fnTicketSurcharge) * (1-CDbl(Clean(Request("DiscSurchargePercentage")))/100), 2)
				
				
			'Discount the existing surcharge - by amount
			'-------------------------------------
			ElseIf Clean(Request("DiscSurcharge")) <> "" Then				
				Surcharge = round(CDbl(fnTicketSurcharge) * (round(CDbl(Request("DiscSurcharge")))/100), 2)
			
			
			'Set maximum surcharge - per order
			'-------------------------------------			
			ElseIf Clean(Request("MaxSurcharge")) <> "" Then
			
				'Surcharge Maximum Order Amount
				
				MaxSurcharge = Round(CDbl(Clean(Request("MaxSurcharge"))),2)
				
				'Count # of applied tickets on this order
				SQLCount = "SELECT COUNT(*) AS AppliedCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND DiscountTypeNumber = " & DiscountTypeNumber
				Set rsCount = OBJdbConnection.Execute(SQLCount)
				TotalAppliedCount = rsCount("AppliedCount")
				rsCount.Close
				Set rsCount = nothing
				
				'Count # of applied tickets on this order
				SQLCount = "SELECT COUNT(*) AS SeriesCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & OrderNumber & ""
				Set rsCount = OBJdbConnection.Execute(SQLCount)
				SeriesCount = rsCount("SeriesCount")
				rsCount.Close
				Set rsCount = nothing
			
				'MOD function to determine the last ticket to complete the subscription discount (i.e. fourth ticket in the FlexPass-4, or eighth ticket in a FlexPass-8, etc.).  
				Remainder = TotalAppliedCount MOD SeriesCount

				' Calculates the total of all discounted ticket prices already given to figure out the discounted ticket price to be assign to this ticket.
				If Remainder = SeriesCount - 1 Then 
					Surcharge = MaxSurcharge - ((SeriesCount - 1) * Round(MaxSurcharge / SeriesCount, 2))
				Else
					'Standard rounding on all other tickets.
					Surcharge = Round(MaxSurcharge/SeriesCount, 2)
				End If
		
		End If
			
	End Sub

'---------------------------------------------

	Sub ProcessDeliverySurcharge

		'Process a new order delivery fee

		If Clean(Request("NewShipFee")) <> "" Then

			ShipFee = Round(CDbl(CleanNumeric(Request("NewShipFee"))),2)
			
			SQLUpdateShipFee = "UPDATE OrderHeader SET ShipFee = " & ShipFee & " WHERE OrderHeader.OrderNumber = " & OrderNumber & " "
			Set rsUpdateShipFee  = OBJdbConnection.Execute(SQLUpdateShipFee)	
			
		End If

	End Sub

'---------------------------------------------

	Public Function fnTicketSurcharge

		DIM strResults
		
		SQLSearch = "SELECT Price.PhoneOrderSurcharge, Price.FaxOrderSurcharge, Price.MailOrderSurcharge, Price.BoxOfficeSurcharge, Price.Surcharge FROM Price (NOLOCK) WHERE Price.EventCode = " & EventCode & " AND Price.SectionCode = '" & SectionCode & "' AND Price.SeatTypeCode = " & SeatTypeCode & ""
		Set rsSearch = OBJdbConnection.Execute(SQLSearch) 
		
			If Not rsSearch.EOF Then
												
				Select Case OrderTypeNumber
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
				
				If Surcharge > 0 Then
					strResults = Surcharge
				Else
					strResults = 0
				End If

			End If
		
		rsSearch.Close
		Set rsSearch = Nothing 
		
		fnTicketSurcharge = strResults
		
	End Function

'---------------------------------------------

PUBLIC FUNCTION fnDiscPrice(strDiscType)

	SeriesDiscount = Request.QueryString(strDiscType)	'
	
	DIM strSeatList
	strSeatList  = trimComma(AllowedSeatTypeCode)
	
	DIM strDiscList
	strDiscList = SeriesDiscount
	
	DIM strDiscount
	
	If instr(strSeatList,",") <> 0 AND instr(strDiscList,",") <> 0 Then
	
		DIM SeatArr
		SeatArr = split(strSeatList,",")
		
		DIM DiscArr
		DiscArr = split(strDiscList,",")
		
		DIM SeatCol
		SeatCol = 0
		
		DIM DiscCol
		DiscCol = 1

		reDIM arrNodes(1,uBound(SeatArr))
		
		For i = 0 to ubound(SeatArr)
			arrNodes(SeatCol,i) = SeatArr(i)
			arrNodes(DiscCol,i) = DiscArr(i)
		Next

		Call SortArry(arrNodes,1)
	
		For i = 0 to UBound(arrNodes,2)
			If SeatTypeCode = arrNodes(SeatCol,i) Then
				strDiscount = arrNodes(DiscCol,i)
			End If
		Next
		
	Else
	
		strDiscount = strDiscList
	
	End If
	
	fnDiscPrice = strDiscount
	
END FUNCTION

'---------------------------------------------

PUBLIC FUNCTION SortArry(byRef arrNodes,sortBy)

	'This function takes a 2 dimensional array and returns it sorted from highest to lowest

	DIM c, d, e, smallestValue, smallestIndex, tempValue
	
	For c = 0 To uBound( arrNodes, 2 ) - 1	
		smallestValue = CLNG( "0" & arrNodes( sortBy, c ))
		smallestIndex = c
		For d = c + 1 To uBound( arrNodes, 2 )
			if CLNG("0" & arrNodes( sortBy, d )) < smallestValue   Then
				smallestValue = CLNG( "0" & arrNodes( sortBy, d ))
				smallestIndex = d
			End if
		Next
		if smallestIndex <> c Then 'swap
			For e = 0 To uBound( arrNodes, 1 )
				tempValue = arrNodes( e, smallestIndex )
				arrNodes( e, smallestIndex ) = arrNodes( e, c )
				arrNodes( e, c ) = tempValue 
			Next
		End if
	Next

END FUNCTION

'---------------------------------------------

PUBLIC FUNCTION trimComma(strText)

	'This function trims any commas from the start and end of the string submitted

	If Right(strText, 1) = "," Then
	strText = Left(strText, Len(strText) - 1)  
	End If

	If Left(strText, 1) = "," Then 
	strText = Right(strText, Len(strText) - 1)  
	End If

	trimComma = strText

END FUNCTION 

'---------------------------------------------

%>