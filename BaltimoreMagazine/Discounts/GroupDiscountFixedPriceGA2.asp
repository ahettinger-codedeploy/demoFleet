<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->

<%

'Baltimore Magazine
'First 2 General Admission tickets receive 50% discount. Price is $37.50 per ticket
'All remaining General Admission tickets receive a 20% discount. Price is $60.00 per ticket
'No discount on VIP tickets.


'Initialize Variables
DiscountTypeNumber = Clean(Request("DiscountTypeNumber"))
EventCode = Clean(Request("EventCode"))
OrderNumber = Clean(Request("OrderNumber"))
Price = Clean(Request("Price"))
Surcharge = Clean(Request("Surcharge"))
AppliedFlag = "N"
SeatTypeCode = Clean(Request("SeatTypeCode"))

'Initialize Discount Parameters
QtyToDisc = 2 'Number of tickets to discount at 50%
DiscSeat = 564 'Ticket Type


If SeatTypeCode = 564 Then

'Determine number of tickets on order per event
SQLEventCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Seat.EventCode = " &  EventCode & " "
Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)
nbrTickets = rsEventCount("SeatCount")
rsEventCount.Close
Set rsEventCount = nothing

'Determine if there are enough tickets to qualify for the discount
If nbrTickets > QtyToDisc Then 

			'Determine number of tickets per event on this order which have been given a discounted price
			SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.SeatTypeCode = " & DiscSeat & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " "
			Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
										
			'Determine if this ticket receives a discount							
			If (rsDiscCount("LineCount")/ NbrTickets) < (QtyToDisc / NbrTickets) Then 
				NewPrice = 37.50
			Else
				NewPrice = 60
			End If
						
			rsDiscCount.Close
			Set rsDiscCount = nothing
						
			DiscountAmount = Price - NewPrice
			
			'Determine if the per ticket fee should be changed.
			If Request("CalcServiceFee") <> "N" Then
				 Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, Clean(Request("EventCode")), Clean(Request("ItemType")))
			End If
				
			AppliedFlag = "Y"
							
End If

End If
					
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>