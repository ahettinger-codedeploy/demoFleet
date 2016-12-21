<%
'CHANGE LOG

'SSR 04/30/13	'Created extended group discount script based on the default generic group discount script already in use.

'SSR 09/13/13 	'Updated. By default only tickets to same event were counted towards discount.
                  'Added new parameter to allow ticket count across multiple events: 
                  'Parameter: &AllowMultiEvent=Y
				
'SSR 09/19/14	'Updated. By default only 1 price tier for group discounts.
                  'Updated to allow different discounts based on group quantity. Requires 2 parameters:
                  'Parameter: &Qty=5,10,15
                  'Parameter: &Percentage=10,20,30 (this parameter be Percentage, FixedPrice or DiscountAmount)
				
'SSR 11/03/14	'Updated. By default all ticket types are counted towards discount but only the AllowedSeatTypeCode tickets are discounted. 
			'Updated to allow the AllowedSeatTypeCode parameter to be applied to both ticket count and ticket's discounted.
				

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

DIM varIndex
varIndex = "Qty"

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

	If Clean(Request("Percentage")) <> "" Then
		'Percentage Discount
		NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(fnDiscPrice("Percentage"))/100), 2)
            
	ElseIf Clean(Request("FixedPrice")) <> "" Then
		'FixedPrice Discount
		NewPrice = round(CDbl(fnDiscPrice("FixedPrice")),2)
            
	Else
		ErrorLog("Process Discount Amount")
		'Discount Amount
		NewPrice = round(CDbl(Clean(Request("Price"))),2) - round(CDbl(fnDiscPrice("DiscountAmount")),2)
		ErrorLog("NewPrice: " & NewPrice & "")
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

		'SeriesSurcharge, NewSurcharge, ReCalcSurcharge, 

		If Clean(Request("SeriesSurcharge")) <> "" Then
		
			SeriesSurcharge = Round(CDbl(Clean(Request("SeriesSurcharge"))),2)
			
			'Count # of applied tickets on this order
			SQLCount = "SELECT COUNT(*) AS AppliedCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND DiscountTypeNumber = " & DiscountTypeNumber
			Set rsCount = OBJdbConnection.Execute(SQLCount)
			TotalAppliedCount = rsCount("AppliedCount")
			rsCount.Close
			Set rsCount = nothing
		
			'MOD function to determine the last ticket to complete the subscription discount (i.e. fourth ticket in the FlexPass-4, or eighth ticket in a FlexPass-8, etc.).  
			Remainder = TotalAppliedCount MOD SeriesCount

			' Calculates the total of all discounted ticket prices already given to figure out the discounted ticket price to be assign to this ticket.
			If Remainder = SeriesCount - 1 Then 
				Surcharge = SeriesSurcharge - ((SeriesCount - 1) * Round(SeriesSurcharge / SeriesCount, 2))
			Else
				'Standard rounding on all other tickets.
				Surcharge = Round(SeriesSurcharge/SeriesCount, 2)
			End If

		ElseIf Request("NewSurcharge") <> "" Then
			Surcharge = Request("NewSurcharge")
			
		ElseIf Request("CalcServiceFee") <> "N" Then
			Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
			
		End If
		
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
				ErrorLog("Group Count more than Ticket Count")
				OrderDiscount = cInt(row(i)(DiscCol))	
			Else
				ErrorLog("Group Count less than Ticket Count")
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