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

'Count # of seats for Beauty
SQLBeautyCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = 4213 AND Price = " & Price
Set rsBeautyCount = OBJdbConnection.Execute(SQLBeautyCount)

'Count # of seats for Whorehouse
SQLWhorehouseCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = 4215 AND Price = " & Price
Set rsWhorehouseCount = OBJdbConnection.Execute(SQLWhorehouseCount)

'Count # of seats for Eden
SQLEdenCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = 4214 AND Price = " & Price
Set rsEdenCount = OBJdbConnection.Execute(SQLEdenCount)

'Check if there is a possible subscription
If rsBeautyCount("LineCount") >= 1 And rsWhorehouseCount("LineCount") >= 1 And rsEdenCount("LineCount") >= 1 Then

	'Find number of subscriptions by selecting event with lowest # of tickets at this price 
	NbrSubscriptions = Min(Array(rsBeautyCount("LineCount"),rsWhorehouseCount("LineCount"),rsEdenCount("LineCount")))
								
	'Get Act Code
	SQLAct = "SELECT ActCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
	Set rsAct = OBJdbConnection.Execute(SQLAct)

	'Count # of existing seats which have discount applied for this act and price
	SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & rsAct("ActCode") & " AND DiscountTypeNumber = " & DiscountTypeNumber  & " AND Price = " & Price
	Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)

	'If the # of discounts at this price for these events < the total possible, discount price
	If rsDiscCount("LineCount") < NbrSubscriptions Then
		DiscountAmount = 1
		If Surcharge > 1.83 Then
			Surcharge = 1.83
		End If
	End If
									
	rsDiscCount.Close
	Set rsDiscCount = nothing
	rsAct.Close
	Set rsAct = nothing
End If
						
rsBeautyCount.Close
Set rsBeautyCount = nothing
rsWhorehouseCount.Close
Set rsWhorehouseCount = nothing
rsEdenCount.Close
Set rsEdenCount = nothing

If DiscountAmount > 0 Then
	NewPrice = Price - DiscountAmount
	AppliedFlag = "Y"
End If
	
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>