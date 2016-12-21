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
MaxDiscountsPerOrder = CInt(Clean(Request("MaxDiscountsPerOrder")))


'REE 10/19/5 - Added Maximum Order Usage
MaxDiscountsPerOrderOK = "Y"
If MaxDiscountsPerOrder <> 0 Then
	SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber 
	Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
	TicketCount = rsDiscCount("LineCount")
	rsDiscCount.Close
	Set rsDiscCount = nothing
	If TicketCount >= MaxDiscountsPerOrder Then
		MaxDiscountsPerOrderOK = "N"
	End If
End If



'SSR 4/04/5 - Added Offline/Online Order Type Check
OrderTypeFlag = "Y"
If Clean(Request("OfflineOnly")) = "Y" And Clean(Request("OrderTypeNumber")) = 1 Then
	OrderTypeFlag = "N"
End If
If Clean(Request("OnlineOnly")) = "Y" And Clean(Request("OrderTypeNumber")) <> 1 Then
	OrderTypeFlag = "N"
End If

If OrderTypeFlag = "Y" And MaxDiscountsPerOrderOK = "Y" Then 'It's okay to apply to this order type and seat type.


'Determine # of Adult Tickets on order
SQLCount = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ItemType = 'Seat' AND EventCode = " & EventCode & " AND OrderLine.SeatTypeCode IN (1008)"
Set rsCount = OBJdbConnection.Execute(SQLCount)
nbrTickets = rsCount("TicketCount")
rsCount.Close
Set rsCount = nothing

	If NbrTickets >= 1 Then 'Need to have at least one ticket on order

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

			'Count # of existing Child seats which have discount applied.
			SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber  & " AND OrderLine.SeatTypeCode = 1055"
			Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)

			'REE 10/14/4 - Get lowest price of non-applied OrderLines.
			SQLMinPrice = "SELECT MIN(OrderLine.Price) AS MinPrice FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber <> " & DiscountTypeNumber  & " AND OrderLine.Price > 0"
			Set rsMinPrice = OBJdbConnection.Execute(SQLMinPrice)
		
			MinPrice = rsMinPrice("MinPrice")
		
			rsMinPrice.Close
			Set rsMinPrice = nothing
		
			If Fix(rsDiscCount("LineCount")) < Fix(NbrTickets) And SeatTypeCode = 1011 Then 'Apply the discount
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
					
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>