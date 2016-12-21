<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->

<%

'Initialize Variables
Price = Clean(Request("Price"))
NewPrice = Price
DiscountAmount = 0
Surcharge = Clean(Request("Surcharge"))
AppliedFlag = "N"
OrderNumber = Clean(Request("OrderNumber"))
SeatTypeCode = Clean(Request("SeatTypeCode"))
EventCode = Clean(Request("EventCode"))
DiscountTypeNumber = Clean(Request("DiscountTypeNumber"))

'Initialize Discount Variables
AlphaSeatType = 6 'Student Ticket
AlphaCount = 10

BetaSeatType = 564 'General Admission Ticket
BetaCount = 2
BetaDisc = 50


'Determine # of Alpha Tickets on order
SQLCount = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ItemType = 'Seat' AND EventCode = " & EventCode & " AND OrderLine.SeatTypeCode IN (" & AlphaSeatType & " )"
Set rsCount = OBJdbConnection.Execute(SQLCount)
nbrTickets = rsCount("TicketCount")
rsCount.Close
Set rsCount = nothing


If NbrTickets >= AlphaCount Then 'Need to have at least one ticket on order

		'Count # of existing Beta seats which have discount applied.
		SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber  & " AND OrderLine.SeatTypeCode IN (" & BetaSeatType & ")"
		Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)

		If Fix(rsDiscCount("LineCount")) < (Fix(NbrTickets)/ AlphaCount) * BetaCount And SeatTypeCode = 564 Then 'Apply the discount
			NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(BetaDisc)/100), 2)
			DiscountAmount = Price - NewPrice
			Surcharge = 0
			AppliedFlag = "Y"
		End If
		
		rsDiscCount.Close
		Set rsDiscCount = nothing

End If


					
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>