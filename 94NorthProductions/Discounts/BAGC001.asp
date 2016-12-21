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
				

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'---------------------------------------------------------

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
	
		SQLCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & SQLMultiEvent & SQLSeatType & ""
		Set rsCount = OBJdbConnection.Execute(SQLCount)
			NbrTickets = rsCount("SeatCount")
		rsCount.Close
		Set rsCount = nothing
		
		If NbrTickets > 1 Then
			Call ProcessDiscount
			Call ProcessSurcharge
		End If
			
	End If

	Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
	Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
	Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
	Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf
	
'---------------------------------------------

Sub ProcessDiscount

		SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount  FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & SQLMultiEvent & SQLSeatType & ""
		Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
			QtyApplied = rsDiscCount("LineCount")
		rsDiscCount.Close
		Set rsDiscCount = nothing
    	
        TotalDiscounted = 0
		
        QtyRemainder = NbrTickets Mod (QtyToBuy + QtyDiscounted)
		
        If NbrTickets >= QtyToBuy + QtyDiscounted Then
            If QtyRemainder > QtyToBuy Then
    	        TotalDiscounted = Fix((NbrTickets - (QtyToBuy + QtyDiscounted)) / (QtyToBuy + QtyDiscounted)) * QtyDiscounted + (QtyRemainder - QtyToBuy) + QtyDiscounted
            Else
    	        TotalDiscounted = Fix((NbrTickets - (QtyToBuy + QtyDiscounted)) / (QtyToBuy + QtyDiscounted)) * QtyDiscounted + QtyDiscounted
            End If
        Else 
            If NbrTickets > QtyToBuy Then
                TotalDiscounted = QtyRemainder - QtyToBuy
            End If
        End If

	    If QtyApplied < TotalDiscounted Then 'Apply the discount
		
	        If Clean(Request("Percentage")) <> "" Then
		        NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Clean(Request("Percentage")))/100), 2)
	        ElseIf Clean(Request("FixedPrice")) <> "" Then
		        NewPrice = Round(CDbl(Clean(Request("FixedPrice"))),2)
	        Else
		        NewPrice = Round(CDbl(Clean(Request("Price"))),2) - Round(CDbl(Clean(Request("DiscountAmount"))),2)
	        End If	
			
            If NewPrice < 0 Then
                NewPrice = 0
				DiscountAmount = Price - NewPrice
				AppliedFlag = "Y"
			End If
			
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

'Create price tier table listing the discount amount for each ticket quantity

DIM OrderDiscount
OrderDiscount = 0

DIM IndexList
IndexList = Request.QueryString(varIndex)

DIM DiscList
DiscList = Request.QueryString(varDisc)

	
	If instr(IndexList,",") <> 0 AND instr(DiscList,",") <> 0 Then
	
	'Multiple price tiers found
	
		'List of required ticket quantities
		DIM IndexArr 
		IndexArr = split(IndexList,",")
		
		'List of discounts
		DIM DiscArr	
		DiscArr = split(DiscList,",")
		
		'Column 1: ticket quantity
		DIM IndexCol 
		IndexCol = 0
		
		'Column 2: discount
		DIM DiscCol 
		DiscCol = 1
		
		'Row #: number of price tiers
		DIM rowCount 
		rowCount = uBound(IndexArr)

		'Re-size discount table with correct row count
		reDIM arrayTble(rowCount) 

		'Populate each row in the discount table with  ticket quantity = discount information
		For i = 0 to rowCount
			arrayTble(i) = array(CDbl(IndexArr(i)),CDbl(DiscArr(i)))
		Next
		
		'Sort the rows from lowest to highest
		For col1 = UBound(arrayTble) - 1 To 0 Step -1
			For col2 = 0 To col1
				If arrayTble(col2)(0) > arrayTble(col2+1)(0) Then
					swap = arrayTble(col2)
					arrayTble(col2) = arrayTble(col2+1)
					arrayTble(col2+1) = swap
				End If
			Next
		Next
		
		'compare the ticket quantity in this order to find the correct discount
		For i = 0 To rowCount
			row = arrayTble
			If cInt(GroupCount) >= cInt(row(i)(IndexCol)) Then
				OrderDiscount = cInt(row(i)(DiscCol))	
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