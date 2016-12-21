<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->

<%

'Allentown Symphony (4/27/2010)
'2010 Season Subscription Add On Event Discount

'Patron must either purchase  

'1 ticket to: Allentown Symphony 2010-2011 Season Subscription: Saturday 
'OR
'1 ticket to: Allentown Symphony 2010-2011 Season Subscription: Sunday

'To qualify for the following discount:

'1 $20.00 discounted ticket to: Pops Concert I: Bravo Broadway! 

'AND/OR

'1 $20.00 discounted ticket to: Pops Concert II: Classical Mystery Tour 


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
EventCodeList = "260533,260535" 
EventPaid = 1

BonusCodeList = "260543,260544"
BonusPrice = 20

'Determine number of Main event tickets on order
SQLCount = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND EventCode IN (" & EventCodeList & ")"
Set rsCount = OBJdbConnection.Execute(SQLCount)
nbrTickets = rsCount("TicketCount")
rsCount.Close
Set rsCount = nothing

If NbrTickets >= EventPaid Then 'Need to have at least one ticket on order

'Pops Concert I
'================

	'Determine number of bonus event tickets which have discount applied.
	SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber  & " AND Event.EventCode = 260543"
	Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
	
	'Select the lowest price ticket from the bonus events
	SQLMinPrice = "SELECT MIN(OrderLine.Price) AS MinPrice FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode IN (260543) AND OrderLine.DiscountTypeNumber <> " & DiscountTypeNumber  & " AND OrderLine.Price > 20"
    Set rsMinPrice = OBJdbConnection.Execute(SQLMinPrice)
	MinPrice = rsMinPrice("MinPrice")
	rsMinPrice.Close
	Set rsMinPrice = nothing


	If Fix(rsDiscCount("LineCount")) < (NbrTickets) And CDbl(Price) = MinPrice Then 'Apply the discount
	
	        Select Case EventCode 
			        Case 260543 'Show Only 	
			        NewPrice = 20
			        DiscountAmount = Price - NewPrice
			        AppliedFlag = "Y"
	        End Select
			
			
    End If
		
		rsDiscCount.Close
		Set rsDiscCount = nothing
		
		
'Pops Concert II
'================

	'Determine number of bonus event tickets which have discount applied.
	SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber  & " AND Event.EventCode = 260544"
	Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
	
	'Select the lowest price ticket from the bonus events
	SQLMinPrice = "SELECT MIN(OrderLine.Price) AS MinPrice FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode IN (260544) AND OrderLine.DiscountTypeNumber <> " & DiscountTypeNumber  & " AND OrderLine.Price > 20"
    Set rsMinPrice = OBJdbConnection.Execute(SQLMinPrice)
	MinPrice = rsMinPrice("MinPrice")
	rsMinPrice.Close
	Set rsMinPrice = nothing


	If Fix(rsDiscCount("LineCount")) < (NbrTickets) And CDbl(Price) = MinPrice Then 'Apply the discount
	
	        Select Case EventCode 
			        Case 260544 'Show Only 	
			        NewPrice = 20
			        DiscountAmount = Price - NewPrice
			        AppliedFlag = "Y"
	        End Select
			
			
    End If
		
		rsDiscCount.Close
		Set rsDiscCount = nothing

End If


					
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>