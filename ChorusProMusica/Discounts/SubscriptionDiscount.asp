<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<%

'Initialize Variables
Price = CDbl(Clean(Request("Price")))
NewPrice = Price
DiscountAmount = 0
Surcharge = Clean(Request("Surcharge"))
AppliedFlag = "N"
OrderNumber = Clean(Request("OrderNumber"))
EventCode = Clean(Request("EventCode"))
DiscountTypeNumber = Clean(Request("DiscountTypeNumber"))
SectionCode = Clean(Request("SectionCode"))
SeatTypeCode = Clean(Request("SeatTypeCode"))
OrderTypeNumber = CInt(Clean(Request("OrderTypeNumber")))


'Count # of seats for Respighi
SQLAct1Count = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = 6966"
Set rsAct1Count = OBJdbConnection.Execute(SQLAct1Count)

'Count # of seats for Family
SQLAct2Count = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = 6967"
Set rsAct2Count = OBJdbConnection.Execute(SQLAct2Count)

'Count # of seats for Bruckner
SQLAct3Count = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = 6964"
Set rsAct3Count = OBJdbConnection.Execute(SQLAct3Count)

'Count # of seats for Verdi
SQLAct4Count = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = 6965"
Set rsAct4Count = OBJdbConnection.Execute(SQLAct4Count)


'Count Acts on this order
ActCount = 0
If rsAct1Count("LineCount") >= 1 Then
	ActCount = ActCount + 1
End If
If rsAct2Count("LineCount") >= 1 Then
	ActCount = ActCount + 1
End If
If rsAct3Count("LineCount") >= 1 Then
	ActCount = ActCount + 1
End If
If rsAct4Count("LineCount") >= 1 Then
	ActCount = ActCount + 1
End If

'Check if there is a possible subscription
If ActCount > 1 Then

	'Find number of subscriptions by selecting event with lowest # of tickets but greater than zero.
	If rsAct1Count("LineCount") > 0 Then
		NbrSubscriptions = rsAct1Count("LineCount")
	End If
	
	If rsAct2Count("LineCount") > 0 And rsAct2Count("LineCount") < NbrSubscriptions Then
		NbrSubscriptions = rsAct2Count("LineCount")
	End If
	
	If rsAct3Count("LineCount") > 0 And rsAct3Count("LineCount") < NbrSubscriptions Then
		NbrSubscriptions = rsAct3Count("LineCount")
	End If

	If rsAct4Count("LineCount") > 0 And rsAct4Count("LineCount") < NbrSubscriptions Then
		NbrSubscriptions = rsAct4Count("LineCount")
	End If

	'Get Act Code
	SQLAct = "SELECT ActCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
	Set rsAct = OBJdbConnection.Execute(SQLAct)

	'Count # of existing seats which have discount applied for this act and seat type code
	SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & rsAct("ActCode") & " AND DiscountTypeNumber = " & DiscountTypeNumber
	Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)

	'If the # of discounts at this price for these events < the total possible, discount price
	If rsDiscCount("LineCount") < NbrSubscriptions Then
	
		If ActCount = 2 Then '10% Discount
			NewPrice = Round(Price * .9, 2)
		ElseIf ActCount > 2 Then
			NewPrice = Round(Price * .85, 2)
		End If

		If Request("NewSurcharge") <> "" Then
			Surcharge = NewSurcharge
		Else
			If Request("CalcServiceFee") <> "N" Then
				Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), OrderTypeNumber, NewPrice, EventCode, Clean(Request("ItemType")))
			End If
		End If
		
	End If

	rsDiscCount.Close
	Set rsDiscCount = nothing
	rsAct.Close
	Set rsAct = nothing
	
End If

						
rsAct1Count.Close
Set rsAct1Count = nothing
rsAct2Count.Close
Set rsAct2Count = nothing
rsAct3Count.Close
Set rsAct3Count = nothing
rsAct4Count.Close
Set rsAct4Count = nothing

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