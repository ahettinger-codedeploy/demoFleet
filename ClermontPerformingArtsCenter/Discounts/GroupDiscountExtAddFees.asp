<%
'CHANGE LOG

'SSR 04/30/13	'Created extended group discount based on the generic discount code already in use.

'SSR 09/13/13 	'Updated. By default only tickets to same event were counted towards discount.
				'Added new parameter to allow ticket count across multiple events: 
				'Parameter: &AllowMultiEvent=Y
				
'SSR 09/19/14	'Updated. By default only 1 price tier for group discounts.
				'Updated to allow different discounts based on group quantity. Requires 2 parameters:
				'Parameter: &Qty=5,10,15
				'Parameter: &Percentage=10,20,30 (this parameter be Percentage, FixedPrice or DiscountAmount)
				
'SSR 11/03/14	'Updated. By default the AllowedSeatTypeCode parameter is only applied to the tickets being discounted. 
				'Updated to allow the AllowedSeatTypeCode parameter to be applied to both ticket count and ticket's discounted.
				
'SSR 07/29/15 - 'Updated to pass combined per ticket surcharge fees. Tix Fees + New Surcharge + Percentage Surcharge (based on discounted ticket price)

'SSR 08/14/15 - 'Updated to allow discounting tickets by multiple quantities in addition to discounting tickets by multiple group count. 
				'Example:  10-24 tickets at 15% off, 25-49 tickets at 20% off, 50+ tickets at 25% off, plus every 15th ticket at 100% off
				'Parameter: &Qty=10,25,50&Percentage=15,20,25&Multiple=15
				
'SSR 09/14/15 - 'Updated discount. AddSurchargePercentage is no longer rounded.
				

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'---------------------------------------------------------
'Multi Group Option

DIM GroupCount
GroupCount = 0

DIM AppliedCount
AppliedCount = 0

DIM Surcharge
If Clean(Request("NewSurcharge")) <> "" Then
	Surcharge = Clean(Request("NewSurcharge")) 
End If

DIM varIndex
varIndex = "Qty"

'---------------------------------------------------------

DIM Multiple

If Clean(Request("Multiple")) <> "" Then
	Multiple = Clean(Request("Multiple"))
End If


'---------------------------------------------------------

'Multi Event Option
	
AllowMultiEvent = "N"

If Clean(Request("AllowMultiEvent")) = "Y" Then
	SQLMultiEvent = ""
Else
	SQLMultiEvent = " AND Seat.EventCode = " & Clean(Request("EventCode")) & ""
End If

'---------------------------------------------------------

'Allowed Seat Type Option

If Clean(Request("AllowedSeatTypeCode")) <> "" Then
	SQLSeatType = "AND OrderLine.SeatTypeCode IN (" & Request("AllowedSeatTypeCode") & ")"
End If

'---------------------------------------------------------

	If AllowDiscount = "Y" Then 
	
		SQLEventCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & SQLMultiEvent & SQLSeatType & ""
		Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)

			If Not rsEventCount.EOF Then
			
				GroupCount = rsEventCount("SeatCount")
						
				If cInt(GroupCount) >= CInt(fnMinQty) Then	

					Call ProcessDiscount
					Call ProcessSurcharge	
					
					
				End If
				
			End If
			
		rsEventCount.Close
		Set rsEventCount = nothing
		
	End If

	Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
	Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
	Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
	Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf
	
'---------------------------------------------

Sub ProcessDiscount

		'Percentage Discount
		If Clean(Request("Percentage")) <> "" Then
			NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(fnDiscPrice("Percentage"))/100), 2)
		
		'FixedPrice Discount
		ElseIf Clean(Request("FixedPrice")) <> "" Then
			NewPrice = round(CDbl(fnDiscPrice("FixedPrice")),2)
		
		'Discount Amount
		Else
			NewPrice = round(CDbl(Clean(Request("Price"))),2) - round(CDbl(fnDiscPrice("DiscountAmount")),2)

		End If

		If Multiple <> "" Then
		
			'Count the number of seats which have been discounted
			SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
			Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)		
			AppliedCount = rsDiscCount("LineCount")		
			rsDiscCount.Close
			Set rsDiscCount = nothing

			Remainder = (AppliedCount + 1) MOD Multiple
						
			If Remainder = 0 Then
			
				NewPrice = 0
				Surcharge = 0
				
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

	Sub ProcessSurcharge
			
		If AppliedFlag = "Y" Then
		
			'Recalculate Tix Service Fees
			If Request("CalcServiceFee") = "Y" Then
				TixFee = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
			Else
				TixFee = Surcharge
			End If
			
			'Add New Surcharge Fee
			If Surcharge <> "" Then
				NewSurcharge = Surcharge
			Else
				NewSurcharge = 0
			End If
						
			'Add New Surcharge Percentage
			If Clean(Request("AddSurchargePercentage")) <> "" Then
				AddSurchargePercentage = Clean(Request("AddSurchargePercentage"))
				AddSurcharge = NewPrice * (AddSurchargePercentage/100)	
			Else
				AddSurcharge = 0
			End If
								
			Surcharge = TixFee + NewSurcharge + AddSurcharge

		End If
			
	End Sub

'---------------------------------------------

Public Function fnDiscPrice(varDisc)

DIM OrderDiscount
OrderDiscount = 0

DIM IndexList
IndexList = Request.QueryString(varIndex)

DIM DiscList
DiscList = Request.QueryString(varDisc)

	
	If instr(IndexList,",") <> 0 AND instr(DiscList,",") <> 0 Then
	
	'Multiple Price Tiers Found
	
		'List of group ticket counts
		DIM IndexArr 
		IndexArr = split(IndexList,",")
		
		'List of discounts amounts
		DIM DiscArr	
		DiscArr = split(DiscList,",")
		
		'Column 1: ticket count
		DIM IndexCol 
		IndexCol = 0
		
		'Column 2: discount amount
		DIM DiscCol 
		DiscCol = 1
		
		'Row #: number of price tiers
		DIM rowCount 
		rowCount = uBound(IndexArr)

		'Re-size discount table with correct row count
		reDIM arrayTble(rowCount) 

		'Populate each row in the discount table with quantity / discount information
		For i = 0 to rowCount
			arrayTble(i) = array(CDbl(IndexArr(i)),CDbl(DiscArr(i)))
		Next
		
		'Sort the rows in discount table from lowest to highest
		For col1 = UBound(arrayTble) - 1 To 0 Step -1
			For col2 = 0 To col1
				If arrayTble(col2)(0) > arrayTble(col2+1)(0) Then
					swap = arrayTble(col2)
					arrayTble(col2) = arrayTble(col2+1)
					arrayTble(col2+1) = swap
				End If
			Next
		Next
		
		'use discount table to determine correct discount for this order
		For i = 0 To rowCount
			row = arrayTble
			If cInt(GroupCount) >= cInt(row(i)(IndexCol)) Then
				'ErrorLog("Group Count more than Ticket Count")
				OrderDiscount = cInt(row(i)(DiscCol))	
			Else
				'ErrorLog("Group Count less than Ticket Count")
			End If
		Next

	Else
	
	'Single Price Tier Found
		
		If cInt(GroupCount) >=  cInt(IndexList) Then
			OrderDiscount = DiscList	
		End If
			
	End If

	fnDiscPrice = OrderDiscount


End Function

'---------------------------------------------

Function fnMinQty

	DIM IndexList
	IndexList = Request.QueryString(varIndex)

	DIM IndexArr 
	IndexArr = split(IndexList,",")
	
	DIM minNumber
	
	minNumber = IndexArr(0)

	For i = 1 to ubound(IndexArr)
		If minNumber > IndexArr(i) Then
			minNumber = IndexArr(i)
		End If
	Next
	
	fnMinQty = minNumber
	
End Function

'---------------------------------------------

%>