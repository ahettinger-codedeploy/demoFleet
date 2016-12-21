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
OrganizationNumber = Clean(Request("OrganizationNumber"))
QtyToBuy = Clean(Request("QtyToBuy"))

'SSR 4/04/5 - Added Offline/Online Order Type Check
OrderTypeFlag = "Y"
If Clean(Request("OfflineOnly")) = "Y" And Clean(Request("OrderTypeNumber")) = 1 Then
	OrderTypeFlag = "N"
End If
If Clean(Request("OnlineOnly")) = "Y" And Clean(Request("OrderTypeNumber")) <> 1 Then
	OrderTypeFlag = "N"
End If

If OrderTypeFlag = "Y" Then 'It's okay to apply to this order type.

	'Determine # of Tickets on order for two specific shows of Surviving David (9/3/4 & 9/4/4).
	If Clean(Request("AllEvents")) = "Y" Then
		SQLCount = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN DiscountEvents (NOLOCK) ON Seat.EventCode = DiscountEvents.EventCode AND DiscountEvents.DiscountTypeNumber = "& DiscountTypeNumber & " WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ItemType = 'Seat'"
	Else
		SQLCount = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ItemType = 'Seat' AND EventCode = " & EventCode
	End If
	Set rsCount = OBJdbConnection.Execute(SQLCount)
	nbrTickets = rsCount("TicketCount")
	rsCount.Close
	Set rsCount = nothing

	If NbrTickets > 1 Then 'Need to have more than one ticket on order

		'REE 8/6/4 - Added Expiration Date Functionality
		If Clean(Request("ExpirationDate")) <> "" Then 'The discount has an expiration date
			ExpirationDate = CDate(Clean(Request("ExpirationDate")))
		Else 'There is no expiration.  Add one to the current date so that it does not expire.
			ExpirationDate = DateAdd("d", 1, Now())
		End If

		'REE 8/21/4 - Added Start Date Functionality
		If Clean(Request("StartDate")) <> "" Then 'The discount has a start date
			StartDate = CDate(Clean(Request("StartDate")))
		Else 'There is no start date.  Subtract one from the current date so that it's valid now.
			StartDate = DateAdd("d", -1, Now())
		End If

		If Now() > StartDate And Now() < ExpirationDate Then

			'Count # of existing seats which have discount applied.
			If Clean(Request("AllEvents")) = "Y" Then
				SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber 
			Else
				SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber 
			End If
			Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
		
			'REE 10/14/4 - Get lowest price of non-applied OrderLines.
			If Clean(Request("AllEvents")) = "Y" Then
				SQLMinPrice = "SELECT MIN(OrderLine.Price) AS MinPrice FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.DiscountTypeNumber <> " & DiscountTypeNumber  & " AND OrderLine.Price > 0"
			Else
				SQLMinPrice = "SELECT MIN(OrderLine.Price) AS MinPrice FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber <> " & DiscountTypeNumber  & " AND OrderLine.Price > 0"
			End If
			Set rsMinPrice = OBJdbConnection.Execute(SQLMinPrice)
		
			MinPrice = rsMinPrice("MinPrice")
		
			rsMinPrice.Close
			Set rsMinPrice = nothing
		
			If rsDiscCount("LineCount") < Fix(NbrTickets / (Fix(QtyToBuy)+1)) And CDbl(Price) = MinPrice Then 'Apply the discount
				NewPrice = 0
				DiscountAmount = Price - NewPrice
				Surcharge = 0
				AppliedFlag = "Y"
			End If
			rsDiscCount.Close
			Set rsDiscCount = nothing

		End If
	End If
End If

'Remove all service fees				
SQLRemoveFee = "UPDATE OrderLine WITH (ROWLOCK) SET Surcharge = 0 WHERE OrderNumber = " & OrderNumber
Set rsRemoveFee = OBJdbConnection.Execute(SQLRemoveFee)
				
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>