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


'Count # of seats for Otempo
SQLOtempoCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = 6026"
Set rsOtempoCount = OBJdbConnection.Execute(SQLOtempoCount)

'Count # of seats for Christmas
SQLChristmasCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = 6027"
Set rsChristmasCount = OBJdbConnection.Execute(SQLChristmasCount)

'Count # of seats for Etoile
SQLEtoileCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = 6028"
Set rsEtoileCount = OBJdbConnection.Execute(SQLEtoileCount)

'Check if there is a possible subscription
If rsOtempoCount("LineCount") >= 1 And rsChristmasCount("LineCount") >= 1 And rsEtoileCount("LineCount") >= 1 Then

	'Find number of subscriptions by selecting event with lowest # of tickets at this price 
	NbrSubscriptions = Min(Array(rsOtempoCount("LineCount"),rsChristmasCount("LineCount"),rsEtoileCount("LineCount")))
								
	'Get Act Code
	SQLAct = "SELECT ActCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
	Set rsAct = OBJdbConnection.Execute(SQLAct)

	'Count # of existing seats which have discount applied for this act and seat type code
	SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & rsAct("ActCode") & " AND DiscountTypeNumber = " & DiscountTypeNumber
	Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)

	'If the # of discounts at this price for these events < the total possible, discount price
	If rsDiscCount("LineCount") < NbrSubscriptions Then
		
		NewPrice = round(CDbl(Price * .9), 2)
	End If
									
	rsDiscCount.Close
	Set rsDiscCount = nothing
	rsAct.Close
	Set rsAct = nothing
End If

						
rsOtempoCount.Close
Set rsOtempoCount = nothing
rsChristmasCount.Close
Set rsChristmasCount = nothing
rsEtoileCount.Close
Set rsEtoileCount = nothing

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