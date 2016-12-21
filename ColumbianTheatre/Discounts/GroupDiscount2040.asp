<%
'CHANGE LOG

'SSR 04/30/13	'Created extended group discount based on the generic discount code already in use.

				

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'==========================================================

'Columbian Theatre - Group Multiple Discount

'2 Tier Multiples Discount by Discount Amount

'Purchase minimum of 40 tickets

'Ticket Count	'Discount	
'------------------------------------------------------			
'20+  			$2.00 discount amount	
'40+ 			$2.00 Off 38 tickets
'40+ 			100%  Off 2 tickets

'==========================================================

'Discount Parameters

DIM GroupCount(1)
GroupCount(0) = 20
GroupCount(1) = 40

DIM GroupMultiple
GroupMultiple = 40

DIM GroupPrice(1)
GroupPrice(0) = 0 '$0.00
GroupPrice(1) = 2 '$2.00

DIM TicketCount

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
				TicketCount = rsEventCount("SeatCount")
			End If
		rsEventCount.Close
		Set rsEventCount = nothing
			
		If cInt(TicketCount) >= GroupCount(0)  And cInt(TicketCount) <= (GroupCount(1) - 1) Then 		
			Call ProcessDiscountAmount
		 ElseIf cInt(TicketCount) >= GroupCount(1) Then 
			Call ProcessDiscountMultiple	
		End If
			
		Call ProcessSurcharge	
		
	End If

	Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
	Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
	Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
	Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf
	
'---------------------------------------------

Sub ProcessDiscountAmount

	NewPrice = round(CDbl(Clean(Request("Price"))),2) - round(CDbl(GroupPrice(1)),2)
	
	Call ApplyDiscount
		
End Sub


Sub ProcessDiscountMultiple

	SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber 
	Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
		
		If rsDiscCount("LineCount") < Fix(TicketCount) / Fix(GroupMultiple) Then 'Apply the discount		
			NewPrice = GroupPrice(0)
		Else
			NewPrice = round(CDbl(Clean(Request("Price"))),2) - round(CDbl(GroupPrice(1)),2)
		End If	
		
	rsDiscCount.Close
	Set rsDiscCount = nothing
	
	Call ApplyDiscount

End Sub


Sub ApplyDiscount

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

%>