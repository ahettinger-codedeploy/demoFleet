<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<%

SeriesCount = 2
ActCodeList = "0000, 0000" 'Exceptions for (Gift Certificates)

'Initialize Variables
Price = Clean(Request("Price"))
NewPrice = Price
DiscountAmount = 0
Surcharge = Clean(Request("Surcharge"))
AppliedFlag = "N"
OrderNumber = Clean(Request("OrderNumber"))
EventCode = Clean(Request("EventCode"))
DiscountTypeNumber = Clean(Request("DiscountTypeNumber"))
SeatTypeCode = Clean(Request("SeatTypeCode"))


'REE 8/10/4 - Added Offline/Online Order Type Check
OrderTypeFlag = "Y"
If Clean(Request("OfflineOnly")) = "Y" And Clean(Request("OrderTypeNumber")) = 1 Then
	OrderTypeFlag = "N"
End If

If Clean(Request("OnlineOnly")) = "Y" And Clean(Request("OrderTypeNumber")) <> 1 Then
	OrderTypeFlag = "N"
End If
	
If OrderTypeFlag = "Y" Then 'It's okay to apply to this order type.

	'Count # of Acts on the order.  Exclude Gift Certificates.
	SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode NOT IN (" & ActCodeList & ") GROUP BY Event.ActCode) AS ActCount"
	Set rsActCount = OBJdbConnection.Execute(SQLActCount)
	
	ActCount = rsActCount("ActCount")

	rsActCount.Close
	Set rsActCount = nothing
	
	If ActCount >= SeriesCount Then

		'Get the least number of tickets for any applicable ActCode
		SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumSubs FROM (SELECT ActCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode NOT IN (" & ActCodeList & ") GROUP BY Event.ActCode) AS TicketCount"
		Set rsMinTicketCount = OBJdbConnection.Execute(SQLMinTicketCount)
		
		NbrSubscriptions = rsMinTicketCount("NumSubs")
		
		rsMinTicketCount.Close
		Set rsMinTicketCount = nothing
		
		'Get Act Code
		SQLAct = "SELECT ActCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
		Set rsAct = OBJdbConnection.Execute(SQLAct)
		
		ActCode = rsAct("ActCode")
		
		rsAct.Close
		Set rsAct = nothing

		'Count # of existing seats which have discount applied for this act and seat type code
		SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ActCode & " AND DiscountTypeNumber = " & DiscountTypeNumber
		Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
		
		AppliedCount = rsDiscCount("LineCount")
		
		rsDiscCount.Close
		Set rsDiscCount = nothing

			'If the # of discounts at this price for these events < the total possible, discount price
		If AppliedCount < NbrSubscriptions Then
			
			Select Case Actcode
			Case 19849
				Select Case SeatTypeCode
					Case 1
					NewPrice = 20
					Case 1119
				 NewPrice = 25
			  End Select
			End Select
		End If
										
	End If

	
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