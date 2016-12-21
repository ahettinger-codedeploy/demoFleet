<%

'CHANGE LOG

'SSR 11/12/24	'Created extended family pack discount: Buy X Adult Ticket Get Y Child Tickets based on the generic Buy X Get Y discount code already in use.
				'5 Required Parameters:  
				'(1) Adult ticket types:  &AdultSeatType=54126,65545&
				'(2) Adult tickets to purchase: &AdultQty=1
				'(3) Child ticket types: &ChildSeatType=54146
				'(4) Child tickets to discount: &ChildQty=1
				'(5) Discount type (Percentage, Discount Amount, Fixed Price) 
		
%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'---------------------------------------------------------

'Initialize Discount Variables

DIM AdultSeatType
AdultSeatType = Clean(Request("AdultSeatType"))

DIM AdultQty
AdultQty = Clean(Request("AdultQty"))

DIM ChildSeatType
ChildSeatType = Clean(Request("ChildSeatType"))

DIM ChildQty
ChildQty = Clean(Request("ChildQty"))

DIM TicketCount 

'---------------------------------------------------------

	If AllowDiscount = "Y" Then 'It's okay to apply to this order type and Seat Type.

		'Determine # of Adult Tickets on order
		SQLCount = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ItemType = 'Seat' AND EventCode = " & EventCode & " AND OrderLine.SeatTypeCode IN (" & AdultSeatType & " )"
		Set rsCount = OBJdbConnection.Execute(SQLCount)
			TicketCount = rsCount("TicketCount")
		rsCount.Close
		Set rsCount = nothing
		
		If cInt(TicketCount) >= cInt(AdultQty) Then 'Need to have at least one ticket on order
			Call ProcessDiscount
			Call ProcessSurcharge
		End If

	End If
					
	Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
	Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
	Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
	Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

'---------------------------------------------------------

Sub ProcessDiscount

	'Count # of existing Child seats which have discount applied.
	SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber  & " AND OrderLine.SeatTypeCode IN (" & ChildSeatType & ")"
	Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
		
		'If cInt(rsDiscCount("LineCount")) < (cInt(TicketCount) * ChildQty) And (InStr(ChildSeatType, SeatTypeCode) <> 0) Then 'Apply the discount
		If cInt(rsDiscCount("LineCount")) < (cInt(TicketCount) * ChildQty) And SeatTypeCode = "54146" Then 'Apply the discount
		
			If Clean(Request("Percentage")) <> "" Then
				NewPrice = round(Price * (1-CDbl(Clean(Request("Percentage")))/100), 2)
			ElseIf Clean(Request("FixedPrice")) <> "" Then
				NewPrice = Round(CDbl(Clean(Request("FixedPrice"))),2)
			ElseIf Clean(Request("DiscountAmount")) <> "" Then
				NewPrice = Price - Round(CDbl(Clean(Request("DiscountAmount"))),2)
			End If
	
			If NewPrice < Price Then
				If NewPrice < 0 Then
					NewPrice = 0
				End If
				DiscountAmount = Round(Clean(Request("Price")),2) - NewPrice
				AppliedFlag = "Y"
			End If
			
		End If
	
	rsDiscCount.Close
	Set rsDiscCount = nothing

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

%>