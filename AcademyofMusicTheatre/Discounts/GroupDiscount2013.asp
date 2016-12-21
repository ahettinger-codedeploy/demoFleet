<%
'CHANGE LOG
'SSR 10/1/2013 - Created Discount
'SSR 10/4/2013 - Update

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%
'======================================

'Academy of Music Theatre 10/4/2013
'Updated to exclude $0 tickets from being counted towards series

'Academy of Music Theatre 10/2/2013

'Group Discount in Multiples with Series Price

'Groups of 3 to 6 tickets

'Pricing
' 3 tickets = $20 Ticket Price
' 4 tickets = $15 Ticket Price
' 5 tickets = $12 Ticket Price
' 6 tickets = $10 Ticket Price

'Discount does not change service fees
'Discount available for both online and offline orders
'Valid for any ticket types
'Tickets must be from same event
'Full Price must be higher than New Price
'No discount on additional tickets
'--------------------------------------

'Initialize Variables

SeriesMin = 3
SeriesMax = 6

'--------------------------------------

If AllowDiscount = "Y" Then 'It's okay to apply to this order.

	'Count tickets on order
	SQLTicketCount = "SELECT COUNT(*) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.OrderNumber = Seat.OrderNumber AND OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Seat.EventCode = " & EventCode & " AND OrderLine.Price <> 0 AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent')" & AllowedSectionSQL & AllowedSeatTypeSQL
	Set rsTicketCount = OBJdbConnection.Execute(SQLTicketCount)
    TicketCount = rsTicketCount("TicketCount")
    rsTicketCount.Close
	Set rsTicketCount = nothing
	
	If TicketCount >= SeriesMin Then
		
		'Count # of existing seats for this event which have discount applied
		SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS AppliedCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber &""
		Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
		AppliedCount = rsDiscCount("AppliedCount")
		rsDiscCount.Close
		Set rsDiscCount = nothing
		
			Multiple = TicketCount
		
			If  Multiple > SeriesMax Then
				Multiple = SeriesMax
			End If
		
			'ErrorLog("AppliedCount "&AppliedCount&"")
		
			'ErrorLog("TicketCount "&TicketCount&"")

			If Int(AppliedCount / Multiple) < Int(TicketCount / Multiple) Then 'Apply the discount to this item
		
				Select Case Multiple
					Case 3
						NewPrice = 20
					Case 4
						NewPrice = 15
					Case 5
						NewPrice = 12
					Case 6
						NewPrice = 10
				End Select
									
				If Price > NewPrice Then
												
					DiscountAmount = Round(Clean(Request("Price")),2) - NewPrice
					
					AppliedFlag = "Y"
					
				End If	 
			
				If Request("NewSurcharge") <> "" Then
					Surcharge = NewSurcharge
				ElseIf Request("CalcServiceFee") <> "N" Then
					Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
				End If

			End If
			
	End If
	
End If	

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>