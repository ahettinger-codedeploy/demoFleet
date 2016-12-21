<%

'CHANGE LOG
'SSR - 11/07/2014 - Updated Adult ticket type to Adult Preferred ticket type

%>

<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

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
AdultSeatType = "65545"
AdultPaid = 1
ChildSeatType = "54146"
ChildFree = 1
MaxDiscounts = 53

'Maximum Per Event

If MaxDiscounts <> 0 Then

	SQLDiscCount = "SELECT COUNT(*) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' WHERE Seat.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber 
	Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
		TicketCount = rsDiscCount("LineCount")
	rsDiscCount.Close
	Set rsDiscCount = nothing
	
	If TicketCount >= CInt(MaxDiscounts) Then
		AllowDiscount = "N"
	End If
	
End If

If AllowDiscount = "Y" Then 'It's okay to apply to this order type and Seat Type.


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

			If cInt(rsDiscCount("LineCount")) < (cInt(NbrTickets) * ChildFree) And SeatTypeCode = "54146" Then 'Apply the discount
				NewPrice = 0
				DiscountAmount = Price - NewPrice
				Surcharge = 0
				AppliedFlag = "Y"
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