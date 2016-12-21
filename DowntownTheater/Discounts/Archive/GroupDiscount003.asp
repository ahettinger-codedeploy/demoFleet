<%
'CHANGE LOG

'SSR 09/30/2013 - Updated Group Discount Code to bring it up to date with other generic discount scripts

'SSR 04/13/13 	- Updated generic Group Discount Code. By default only tickets to same event are counted towards discount.
				'Added new parameter to allow ticket count across multiple events: 
				'Parameter: &AllowMultiEvent=Y
				
'SSR 09/19/14	- Updated generic Group Discount Code. By default only 1 price tier for group discounts.
				'Update allows multiple tiers based on quantity of tickets. Requires 2 parameters:
				'Parameter: &Qty=5,10,15
				'Parameter: &Percentage=10,20,30 (this parameter be Percentage, FixedPrice or DiscountAmount)
				

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'---------------------------------------------------------

DIM GroupCount

DIM varIndex
varIndex = "Qty"
	

AllowMultiEvent = "N"
If Clean(Request("AllowMultiEvent")) = "Y" Then
	SQLMultiEvent = ""
Else
	SQLMultiEvent = " AND Seat.EventCode = " & Clean(Request("EventCode")) & ""
End If

'---------------------------------------------------------

	If AllowDiscount = "Y" Then 
	'It's okay to continue with this order.

        SQLEventCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Clean(Request("OrderNumber")) & " AND Seat.EventCode = " & Clean(Request("EventCode"))
        Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)

			If Not rsEventCount.EOF Then
			
				GroupCount = rsEventCount("SeatCount")
			
				If rsEventCount("SeatCount") >= 3 Then 'Apply the discount
					
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
		NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(getDisc("Percentage"))/100), 2)
		
	ElseIf Clean(Request("FixedPrice")) <> "" Then
		'FixedPrice Discount
		NewPrice = round(CDbl(getDisc("FixedPrice")),2)
		
	Else
		'Discount Amount
		NewPrice = round(CDbl(Clean(Request("Price"))),2) - round(CDbl(getDisc("DiscountAmount")),2)
		
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

	If AppliedFlag = "Y" Then
	
		If Request("NewShipFee") <> "" Then
			NewShipFee = Clean(Request("NewShipFee"))
			SQLUpdateShipFee = "UPDATE OrderHeader SET ShipFee = " & NewShipFee & " WHERE OrderHeader.OrderNumber = " & OrderNumber & " "
			Set rsUpdateShipFee  = OBJdbConnection.Execute(SQLUpdateShipFee)
		End If
		
		
		If Request("NewSurcharge") <> "" Then
			Surcharge = NewSurcharge
		ElseIf Request("CalcServiceFee") <> "N" Then
			Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
		End If
		
	End If
		
End Sub		

'---------------------------------------------

Public Function getDisc(varDisc)

	DIM IndexList
	IndexList = Request.QueryString(varIndex)

	DIM DiscList
	DiscList = Request.QueryString(varDisc)

	
	If instr(IndexList,",") <> 0 AND instr(DiscList,",") <> 0 Then
	
		'Multiple Discount Price Tiers Found
	
		'List of price tiers by quantity
		DIM IndexArr 
		IndexArr = split(IndexList,",")
		
		'List of price tiers by discount amount
		DIM DiscArr	
		DiscArr = split(DiscList,",")
		
		'1st column: quantity
		DIM IndexCol 
		IndexCol = 0
		
		'2nd column: discount
		DIM DiscCol 
		DiscCol = 1
		
		'Number of price tiers
		DIM rowCount 
		rowCount = uBound(IndexArr)

		'adjust discount table with correct row count
		reDIM arrayTble(rowCount) 

		'Populate each row in discount table with quantity / discount information
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
			If GroupCount >= row(i)(IndexCol) Then
				OrderDiscount = row(i)(DiscCol)	
			End If
		Next
		
		If OrderDiscount = "" Then
			OrderDiscount = 0
		End If

	Else
	
		'Single Discount Price Tier Found
		OrderDiscount = DiscList
	
	End If
	
	getDisc = OrderDiscount
	
End Function

'---------------------------------------------

%>