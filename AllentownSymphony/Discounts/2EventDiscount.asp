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
EventCodeList = "197712,197713"
EventPaid = 1
BonusCodeList = "197183,197184,197185,197186,197187"
BonusFree = 1


'Determine # of paid event tickets on order
SQLCount = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND EventCode IN (" & EventCodeList & ")"
Set rsCount = OBJdbConnection.Execute(SQLCount)
nbrTickets = rsCount("TicketCount")
rsCount.Close
Set rsCount = nothing


If NbrTickets >= EventPaid Then 'Need to have at least one ticket on order

	'Count # of bonus event tickets which have discount applied.
	SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber  & " AND Event.EventCode IN (" & BonusCodeList & ")"
	Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
		
	SQLMinPrice = "SELECT MIN(OrderLine.Price) AS MinPrice FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode IN (" & BonusCodeList & ") AND OrderLine.DiscountTypeNumber <> " & DiscountTypeNumber  & " AND OrderLine.Price > 0"
  Set rsMinPrice = OBJdbConnection.Execute(SQLMinPrice)
	MinPrice = rsMinPrice("MinPrice")
	rsMinPrice.Close
	Set rsMinPrice = nothing


	If Fix(rsDiscCount("LineCount")) < (Fix(NbrTickets) * BonusFree) And CDbl(Price) = MinPrice Then 'Apply the discount
	
			NewPrice = 0
			DiscountAmount = Price - NewPrice
			Surcharge = 0
			AppliedFlag = "Y"
		Else
			NewPrice = Price
		End If
		
		rsDiscCount.Close
		Set rsDiscCount = nothing

End If


					
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>