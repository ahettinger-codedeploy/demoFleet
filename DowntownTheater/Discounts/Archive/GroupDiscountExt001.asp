<%
'CHANGE LOG

'JAI 6/1/12 - New per ticket discount script.  Combination of Amount, Percentage, and Fixed Price discounts.

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

	If AllowDiscount = "Y" Then 
	
		'It's okay to continue with this order.

		SQLEventCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Clean(Request("OrderNumber")) & " AND Seat.EventCode = " & Clean(Request("EventCode")) & SQLAllowedSectionList
		Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)

			If Not rsEventCount.EOF Then
			
				GroupCount = rsEventCount("SeatCount")
				MinQty = CInt(Clean(Request("Qty")))
			
				If GroupCount >= MinQuantity Then 
				
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
	IndexList = GetVarValue(strURL,varIndex)

	DIM DiscList
	DiscList = GetVarValue(strURL,varDisc) 
	
	If instr(IndexList,",") <> 0 AND instr(DiscList,",") <> 0 Then
	
	'Multiple Price Tiers Found
	
		DIM IndexArr 'List of Price Break Points
		IndexArr = split(IndexList,",")
		
		DIM DiscArr	'List of Discounts
		DiscArr = split(DiscList,",")
		
		DIM IndexCol '1st column: price tier
		IndexCol = 0
		
		DIM DiscCol '2nd column: discount
		DiscCol = 1
		
		DIM rowCount 'Number of price tiers
		rowCount = uBound(IndexArr)
		
		'Update discount grid to hold every price tier
		reDIM arrayTble(rowCount) 
		
		'Populate each row in grid with price tier / discount information
		For i = 0 to rowCount
			arrayTble(i) = array(CDbl(IndexArr(i)),CDbl(DiscArr(i)))
		Next
		
		'Sort the discount grid from lowest to highest
		For COL1 = UBound(arrayTble) - 1 To 0 Step -1
			For COL2 = 0 To COL1
				If arrayTble(COL2)(0) > arrayTble(COL2+1)(0) Then
					swap = arrayTble(COL2)
					arrayTble(COL2) = arrayTble(COL2+1)
					arrayTble(COL2+1) = swap
				End If
			Next
		Next
				
		'Get the correct discount for this price tier
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
	
	'Single Discount Tier Found
	OrderDiscount = DiscList
	
	End If

	getDiscountPrice = OrderDiscount
	
End Function

'---------------------------------------------


%>