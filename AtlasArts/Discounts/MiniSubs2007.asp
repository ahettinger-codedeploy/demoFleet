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


'Count # of seats for THE PIRATES OF PENZANCE
SQLAct1Count = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = 17786"
ERRORLOG("SQLAct1Count")
Set rsAct1Count = OBJdbConnection.Execute(SQLAct1Count)
NoPirateAct = Int(rsAct1Count("LineCount")/4)
rsAct1Count.Close
Set rsAct1Count = nothing

'Count # of seats for THE CONDENSED MIKADO '08
SQLAct2Count = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = 17826"
Set rsAct2Count = OBJdbConnection.Execute(SQLAct2Count)
NoCondAct = Int(rsAct2Count("LineCount")/4)
rsAct2Count.Close
Set rsAct2Count = nothing

'Count # of seats for MAN OF LA MANCHA
SQLAct3Count = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = 17825"
Set rsAct3Count = OBJdbConnection.Execute(SQLAct3Count)
NoManAct = Int(rsAct3Count("LineCount")/4)
rsAct3Count.Close
Set rsAct3Count = nothing

'Count Acts on this order
'And Total No Tix
ActCount = 0
TotalNoTix = 0
If NoPirateAct >= 1 Then
	ActCount = ActCount + 1
	TotalNoTix = TotalNoTix + NoPirateAct
End If
If NoCondAct >= 1 Then
	ActCount = ActCount + 1
	TotalNoTix = TotalNoTix + NoCondAct
End If
If NoManAct >= 1 Then
	ActCount = ActCount + 1
	TotalNoTix = TotalNoTix + NoManAct
End If


'Check if there is a possible subscription 
If ActCount > 2 Then

	'Find number of subscriptions by selecting event with lowest # of tickets but greater than zero.
	If NoPirateAct > 0 Then
		NbrSubscriptions = NoPirateAct
	End If
	
	If NoCondAct > 0 And NoCondAct < NbrSubscriptions Then
		NbrSubscriptions = NoCondAct
	End If
	
	If NoManAct > 0 And NoManAct < NbrSubscriptions Then
		NbrSubscriptions = NoManAct
	End If



	'Get Act Code
	SQLAct = "SELECT ActCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
	Set rsAct = OBJdbConnection.Execute(SQLAct)

	'Count # of existing seats which have discount applied for this act and seat type code
	SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & rsAct("ActCode") & " AND DiscountTypeNumber = " & DiscountTypeNumber
	Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)

	'If the # of discounts at this price for these events < the total possible, discount price
	If rsDiscCount("LineCount") < (NbrSubscriptions * 4) Then
		
	 
		If ActCount = 2 Then 'if two Act
			
			NewPrice = 13.75
			
		Else If ActCount = 3 Then 'if three Act and four tix for each acts
			Select Case ActCode
				Case 17786
					NewPrice = 14.16
				Case 17826
					NewPrice = 14.16
				Case 17825
					NewPrice = 14.17
			End Select
			NewPrice = 14.16
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

						

'rsAct4Count.Close
'Set rsAct4Count = nothing

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