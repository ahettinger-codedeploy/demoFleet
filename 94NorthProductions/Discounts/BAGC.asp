<%

'CHANGE LOG

'SSR 11/12/14	'Created extended family pack discount: Buy X Adult Ticket Get Y Child Tickets based on the generic Buy X Get Y discount code already in use.
				'5 Required Parameters:  
				'(1) Adult ticket types:  &AdultSeatType=54126,65545&
				'(2) Adult tickets to purchase: &AdultQty=1
				'(3) Child ticket types: &ChildSeatType=54146
				'(4) Child tickets to discount: &ChildQty=1
				'(5) Discount type (Percentage, Discount Amount, Fixed Price) 
				
'SSR 06/19/15	'Updated to fix issue of passing multiple child seat type codes.
		
%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'---------------------------------------------------------

'Initialize Discount Variables

DIM AdultSeatList
AdultSeatList = Clean(Request("AdultSeatType"))

DIM AdultQty
AdultQty = Clean(Request("AdultQty"))

DIM ChildSeatList
ChildSeatList = Clean(Request("ChildSeatType"))

DIM ChildQty
ChildQty = Clean(Request("ChildQty"))

DIM AdultTicketCount

'---------------------------------------------------------

	If AllowDiscount = "Y" Then 'It's okay to apply to this order type and Seat Type.

		'Determine number of Adult Tickets on order
		SQLCount = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ItemType = 'Seat' AND EventCode = " & EventCode & " AND OrderLine.SeatTypeCode IN (" & AdultSeatList & " )"
		Set rsCount = OBJdbConnection.Execute(SQLCount)
			AdultTicketCount = rsCount("TicketCount")
		rsCount.Close
		Set rsCount = nothing
		
		'ErrorLog("AdultTicketCount: " & AdultTicketCount & "")
				
		If cInt(AdultTicketCount) >= cInt(AdultQty) Then 'Need to have at least one ticket on order
		
			'ErrorLog("AdultQty: " & AdultQty & "")

			'Determine number of Child tickets on the order
			SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS AppliedCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber  & " AND OrderLine.SeatTypeCode IN (" & ChildSeatList & ")"
			Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
			
				'ErrorLog("ChildTicketCount : " & rsDiscCount("AppliedCount") & "")
			
				If Fix(rsDiscCount("AppliedCount")) < (Fix(AdultTicketCount) * ChildQty) Then 'Apply the discount
				
					If fnFindSeatCode(SeatTypeCode,ChildSeatList) Then
						Call ProcessDiscount
						Call ProcessSurcharge
					End If
   
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
	'Single Price Tier

	If Clean(Request("Percentage")) <> "" Then
		'Percentage Discount
		NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Clean(Request("Percentage")))/100), 2)
		
	ElseIf Clean(Request("FixedPrice")) <> "" Then
		'FixedPrice Discount
		NewPrice = round(CDbl(Clean(Request("FixedPrice"))),2)
		
	ElseIf Clean(Request("DiscountAmount")) <> "" Then
		'Amount Discount
		NewPrice = round(CDbl(Clean(Request("Price"))),2) - round(CDbl(Clean(Request("DiscountAmount"))),2)
	
	ElseIf Clean(Request("SeriesPrice")) <> "" Then
		'Series Price
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

	Else
	
		NewPrice = round(CDbl(Clean(Request("Price"))))
	
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

'---------------------------------------------------------

Public Function fnFindSeatCode(strItem,strList)

	'this function requires a single item and an array of items.
	'it then returns a Boolean value that indicates whether the specified item was found in the array

	fnFindSeatCode = False

	tempString = strList

	'create an array of the seat codes
	tempArray = Split(tempString,",")	
  
	For i=0 To Ubound(tempArray)
		If Trim(tempArray(i)) = Trim(strItem) Then
			fnFindSeatCode = True
			Exit Function      
		End IF 
	Next
  
End Function

'---------------------------------------------------------

%>