<%
'CHANGE LOG
'SSR 8/7/2013 - Created Discount

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%
'======================================
'City of Novi

'Buy 15 get 1 Free Discount

'Purchase 15 or more tickets
'Receive 1 ticket at 100% discount
'(Requires 16 tickets in the shopping cart)

'1 discounted ticket per order
'Discount available for both online and offline orders
'Discounted ticket assigned a  $0 service fee
'No change to service fees on non-discounted tickets
'======================================

'Initialize Variables

DIM MultiEvent
DIM Qty

Qty = CInt(Clean(Request("Qty")))

If 	Clean(Request("MultiEvent")) <> "" Then
	MultiEvent = Clean(Request("MultiEvent"))
Else
	MultiEvent = FALSE
End If

'--------------------------------------

	If AllowDiscount = "Y" Then 'It's okay to apply to this order.

		'Count number of tickets on the order 
		If MultiEvent Then
			SQLTicketCount = "SELECT COUNT(*) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.OrderNumber = Seat.OrderNumber AND OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent')" & AllowedSectionSQL & AllowedSeatTypeSQL
		Else
			SQLTicketCount = "SELECT COUNT(*) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.OrderNumber = Seat.OrderNumber AND OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Seat.EventCode = " & EventCode & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent')" & AllowedSectionSQL & AllowedSeatTypeSQL
		End If
		Set rsTicketCount = OBJdbConnection.Execute(SQLTicketCount)
		TicketCount = rsTicketCount("TicketCount")
		rsTicketCount.Close
		Set rsTicketCount = nothing
			
		'Count number of discounted tickets
		If MultiEvent Then
			SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS AppliedCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber &""
		Else
			SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS AppliedCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber &""
		End If
		Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
		AppliedCount = rsDiscCount("AppliedCount")
		rsDiscCount.Close
		Set rsDiscCount = nothing
				
			'Apply the discount	
			If Int(AppliedCount) < Fix( TicketCount / (Fix(Qty)+1)) Then 

				If Clean(Request("Percentage")) <> "" Then
					NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Clean(Request("Percentage")))/100), 2)
				ElseIf Clean(Request("FixedPrice")) <> "" Then
					NewPrice = Round(CDbl(Clean(Request("FixedPrice"))),2)
				ElseIf Clean(Request("DiscountAmount")) <> "" Then
					NewPrice = Clean(Request("Price")) - Round(CDbl(Clean(Request("DiscountAmount"))),2)
				End If

				DiscountAmount = Round(Clean(Request("Price")),2) - NewPrice

				If Price > NewPrice Then
					AppliedFlag = "Y"
				End If	 
			
				If Request("NewSurcharge") <> "" Then
					Surcharge = NewSurcharge
				ElseIf Request("CalcServiceFee") <> "N" Then
					Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
				End If

			End If
		
	End If	

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>