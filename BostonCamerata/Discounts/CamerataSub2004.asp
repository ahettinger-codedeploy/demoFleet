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
DiscountTypeNumber = Clean(Request("DiscountTypeNumber"))


'Count # of seats for Johnny
SQLJohnnyCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = 2866"
Set rsJohnnyCount = OBJdbConnection.Execute(SQLJohnnyCount)

'Count # of seats for Christmas
SQLChristmasCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = 2836"
Set rsChristmasCount = OBJdbConnection.Execute(SQLChristmasCount)

'Count # of seats for NewBritain
SQLNewBritainCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = 2837"
Set rsNewBritainCount = OBJdbConnection.Execute(SQLNewBritainCount)

'Check if there is a possible subscription
If rsJohnnyCount("LineCount") >= 1 And rsChristmasCount("LineCount") >= 1 And rsNewBritainCount("LineCount") >= 1 Then

	'Find number of subscriptions by selecting event with lowest # of tickets at this price 
	NbrSubscriptions = Min(Array(rsJohnnyCount("LineCount"),rsChristmasCount("LineCount"),rsNewBritainCount("LineCount")))
								
	'Get Act Code
	SQLAct = "SELECT ActCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
	Set rsAct = OBJdbConnection.Execute(SQLAct)

	'Count # of existing seats which have discount applied for this act and seat type code
	SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & rsAct("ActCode") & " AND DiscountTypeNumber = " & DiscountTypeNumber
	Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)

	'If the # of discounts at this price for these events < the total possible, discount price
	If rsDiscCount("LineCount") < NbrSubscriptions Then
		
		Select Case Price
		Case 48
			NewPrice = 43
		Case 42
			NewPrice = 40
		Case 41
			NewPrice = 37
		Case 33
			NewPrice = 29
		Case 32
			NewPrice = 30
		Case 22
			NewPrice = 20
		End Select
	End If
									
	rsDiscCount.Close
	Set rsDiscCount = nothing
	rsAct.Close
	Set rsAct = nothing
End If

						
rsJohnnyCount.Close
Set rsJohnnyCount = nothing
rsChristmasCount.Close
Set rsChristmasCount = nothing
rsNewBritainCount.Close
Set rsNewBritainCount = nothing

If Price > NewPrice Then
	DiscountAmount = Price - NewPrice
	AppliedFlag = "Y"
Else
	NewPrice = Price
End If
	
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>