<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'==================================================
' Aaron Radatz (10/21/2010)

'Buy one Adult ticket to act code #55854 
'And get two free kids tickets.
'They must buy additional adult tickets to get addition free ticket.

AdultSeatType = 566
AdultPaid = 1

ChildSeatType = 567
ChildFree = 2

'==================================================
' Buy 1 Adult (Sale Price) Get 2 Child (Sale Price) Free

'Determine # of Adult Tickets on order
SQLCount = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ItemType = 'Seat' AND EventCode = " & EventCode & " AND OrderLine.SeatTypeCode IN (" & AdultSeatType & " )"
Set rsCount = OBJdbConnection.Execute(SQLCount)
nbrTickets = rsCount("TicketCount")
rsCount.Close
Set rsCount = nothing


If NbrTickets >= AdultPaid Then 'Need to have at least one ticket on order

		'Count # of existing Child seats which have discount applied.
		SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber  & " AND OrderLine.SeatTypeCode IN (" & ChildSeatType & ")"
		Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)

		If Fix(rsDiscCount("LineCount")) < (Fix(NbrTickets) * ChildFree) And SeatTypeCode = 567 Then 'Apply the discount
			NewPrice = 0
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