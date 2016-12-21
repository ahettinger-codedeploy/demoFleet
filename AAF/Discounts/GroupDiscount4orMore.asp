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
SeatTypeCode = CInt(Clean(Request("SeatTypeCode")))
EventCode = Clean(Request("EventCode"))
DiscountTypeNumber = Clean(Request("DiscountTypeNumber"))


'Count # of tickets on this order
	SQLCount = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN DiscountEvents (NOLOCK) ON Seat.EventCode = DiscountEvents.EventCode AND DiscountEvents.DiscountTypeNumber = "& DiscountTypeNumber & " WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ItemType = 'Seat'"
	Set rsCount = OBJdbConnection.Execute(SQLCount)
	nbrTickets = rsCount("TicketCount")
	rsCount.Close
	Set rsCount = nothing

'Determine discount based on ticket #	
If NbrTickets >= 4 Then 
			Select Case Price
				Case 55 'Adult
					NewPrice = 50
					DiscountAmount = Clean(Request("Price")) - NewPrice
				Case 47.50 'Senior
					NewPrice = 45
					DiscountAmount = Clean(Request("Price")) - NewPrice
				Case 42.50 'Individual
					NewPrice = 40
					DiscountAmount = Clean(Request("Price")) - NewPrice				
			End Select
AppliedFlag = "Y"
End If

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>