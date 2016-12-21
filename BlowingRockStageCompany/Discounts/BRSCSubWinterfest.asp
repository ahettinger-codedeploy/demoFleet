<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<%

'Initialize Variables
Price = Clean(Request("Price"))
NewPrice = Price
DiscountAmount = 0
Surcharge = Clean(Request("Surcharge"))
AppliedFlag = "N"
OrderNumber = Clean(Request("OrderNumber"))
EventCode = Clean(Request("EventCode"))
SeatTypeCode = Clean(Request("SeatTypeCode"))
DiscountTypeNumber = Clean(Request("DiscountTypeNumber"))

If SeatTypeCode = 16 Then

	'Count # of seats for Wright
	SQLWrightCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = 3246 AND SeatTypeCode = 16"
	Set rsWrightCount = OBJdbConnection.Execute(SQLWrightCount)

	'Count # of seats for Latitide
	SQLLatitideCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = 3244 AND SeatTypeCode = 16"
	Set rsLatitideCount = OBJdbConnection.Execute(SQLLatitideCount)

	'Count # of seats for Mill
	SQLMillCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = 3245 AND SeatTypeCode = 16"
	Set rsMillCount = OBJdbConnection.Execute(SQLMillCount)

	'Check if there is a possible subscription
	If rsWrightCount("LineCount") >= 1 And rsLatitideCount("LineCount") >= 1 And rsMillCount("LineCount") >= 1 Then

		'Find number of subscriptions by selecting event with lowest # of tickets at this price 
		NbrSubscriptions = Min(Array(rsWrightCount("LineCount"),rsLatitideCount("LineCount"),rsMillCount("LineCount")))
									
		'Count # of existing seats which have discount applied for this event and Individual Seat
		SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND DiscountTypeNumber = " & DiscountTypeNumber
		Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)

		'If the # of discounts at this price for these events < the total possible, discount price
		If rsDiscCount("LineCount") < NbrSubscriptions Then
			NewPrice = Price - 1			
		End If
										
		rsDiscCount.Close
		Set rsDiscCount = nothing
	End If

							
	rsWrightCount.Close
	Set rsWrightCount = nothing
	rsLatitideCount.Close
	Set rsLatitideCount = nothing
	rsMillCount.Close
	Set rsMillCount = nothing

	If Price > NewPrice Then
		DiscountAmount = Price - NewPrice
		AppliedFlag = "Y"
	Else
		NewPrice = Price
	End If

End If
	
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>