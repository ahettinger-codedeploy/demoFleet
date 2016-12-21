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


'Count # of tickets on this order
	SQLCount = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN DiscountEvents (NOLOCK) ON Seat.EventCode = DiscountEvents.EventCode AND DiscountEvents.DiscountTypeNumber = "& DiscountTypeNumber & " WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ItemType = 'Seat' AND OrderLine.Price >= " & Price & " AND OrderLine.Price > 0"
	Set rsCount = OBJdbConnection.Execute(SQLCount)
	nbrTickets = rsCount("TicketCount")
	rsCount.Close
	Set rsCount = nothing


'Count # of tickets which have had discount applied.
	SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber 
	Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
	

'Determine discount based on ticket #	
If NbrTickets >= 6 Then 
			Select Case SeatTypeCode
				Case 1 'Adult
					NewPrice = round(Price * .90, 2)
					DiscountAmount = Clean(Request("Price")) - NewPrice
				Case 3 'Senior
					NewPrice = round(Price * .90, 2)
					DiscountAmount = Clean(Request("Price")) - NewPrice
				Case 16 'Individual
					NewPrice = round(Price * .90, 2)
					DiscountAmount = Clean(Request("Price")) - NewPrice
				Case 417 'Child
					NewPrice = round(Price * .90, 2)
					DiscountAmount = Clean(Request("Price")) - NewPrice
				Case 24 'Student
					NewPrice = round(Price * .90, 2)
					DiscountAmount = Clean(Request("Price")) - NewPrice					
			End Select
AppliedFlag = "Y"
End If

		
rsDiscCount.Close
Set rsDiscCount = nothing

					
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>