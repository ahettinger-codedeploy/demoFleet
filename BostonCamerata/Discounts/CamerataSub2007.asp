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


'Count # of seats for Renaissance
SQLRenaissanceCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = 19447"
Set rsRenaissanceCount = OBJdbConnection.Execute(SQLRenaissanceCount)

'Count # of seats for Tristan
SQLTristanCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = 19448"
Set rsTristanCount = OBJdbConnection.Execute(SQLTristanCount)

'Count # of seats for AllaTurca
SQLAllaTurcaCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = 19449"
Set rsAllaTurcaCount = OBJdbConnection.Execute(SQLAllaTurcaCount)

'Check if there is a possible subscription
If rsRenaissanceCount("LineCount") >= 1 And rsTristanCount("LineCount") >= 1 And rsAllaTurcaCount("LineCount") >= 1 Then

	'Find number of subscriptions by selecting event with lowest # of tickets at this price 
	NbrSubscriptions = Min(Array(rsRenaissanceCount("LineCount"),rsTristanCount("LineCount"),rsAllaTurcaCount("LineCount")))
								
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

						
rsRenaissanceCount.Close
Set rsRenaissanceCount = nothing
rsTristanCount.Close
Set rsTristanCount = nothing
rsAllaTurcaCount.Close
Set rsAllaTurcaCount = nothing

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