<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->

<%

'Canton Symphony 9/10/09
'Buy 1 Adult ticket, receive $20 off another Adult ticket
'Maximum 1 discounted Adult ticket per order

'Initialize Variables
Price = Clean(Request("Price"))
NewPrice = Price
DiscountAmount = 0
Surcharge = Clean(Request("Surcharge"))
OrderNumber = Clean(Request("OrderNumber"))
DiscountTypeNumber = Clean(Request("DiscountTypeNumber"))
SeatTypeCode = Clean(Request("SeatTypeCode"))
AppliedFlag = "N"

'Discount Variables
AmountOff = 20
QtyToBuy = 1
MaxDiscountsPerOrder = 1


'Count number of tickets on the order which are equal value
SQLCount = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN DiscountEvents (NOLOCK) ON Seat.EventCode = DiscountEvents.EventCode AND DiscountEvents.DiscountTypeNumber = "& DiscountTypeNumber & " WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ItemType = 'Seat' AND OrderLine.Price >= " & Price & " AND OrderLine.Price > 0"
Set rsCount = OBJdbConnection.Execute(SQLCount)
nbrTickets = rsCount("TicketCount")
rsCount.Close
Set rsCount = nothing

If NbrTickets > 1 Then 

	SQLMaxCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber 
	Set rsMaxCount = OBJdbConnection.Execute(SQLMaxCount)
	MaxTicketCount = rsMaxCount("LineCount")
	rsMaxCount.Close
	Set rsMaxCount = nothing
	
	If MaxTicketCount < MaxDiscountsPerOrder Then

					
			SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber 
			Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)	
									
			'Apply the discount
			If rsDiscCount("LineCount") < Fix(nbrTickets / (Fix(QtyToBuy)+1)) Then 
										
						If Clean(Request("Price")) > 0 Then
												
								Select Case SeatTypeCode
									Case 1 'Adult
										NewPrice = Price - 20
										AppliedFlag = "Y"
									Case 31 'Senior
										NewPrice = Price
									Case 6 'Student
										NewPrice = Price
								End Select
								        							
						End If

						If NewPrice < 0 Then
							NewPrice = 0
						End If

						DiscountAmount = Price - NewPrice
									
			End If
									
			rsDiscCount.Close
			Set rsDiscCount = nothing					
				
	End If		

End If
					
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>