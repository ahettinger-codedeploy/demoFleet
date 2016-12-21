<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<%

'2 Event Discount.  
'If Event1 and Event2 are both purchased, a discount is given
'If Event3 and Event4 are both purchased, a discount is given


'Initialize Variables
Price = Clean(Request("Price"))
NewPrice = Price
DiscountAmount = 0
Surcharge = Clean(Request("Surcharge"))
AppliedFlag = "N"
OrderNumber = Clean(Request("OrderNumber"))
EventCode = Clean(Request("EventCode"))
DiscountTypeNumber = Clean(Request("DiscountTypeNumber"))
SectionCode = Clean(Request("SectionCode"))


'REE 8/10/4 - Added Offline/Online Order Type Check
OrderTypeFlag = "Y"
If Clean(Request("OfflineOnly")) = "Y" And Clean(Request("OrderTypeNumber")) = 1 Then
	OrderTypeFlag = "N"
End If
If Clean(Request("OnlineOnly")) = "Y" And Clean(Request("OrderTypeNumber")) <> 1 Then
	OrderTypeFlag = "N"
End If

If OrderTypeFlag = "Y" Then 'It's okay to apply to this order type.

	'Count # of seats for each Event
	SQLEvent1Count = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = 195739"
	Set rsEvent1Count = OBJdbConnection.Execute(SQLEvent1Count)
	
	SQLEvent2Count = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = 195741"
	Set rsEvent2Count = OBJdbConnection.Execute(SQLEvent2Count)
	
	SQLEvent3Count = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = 195743"
	Set rsEvent3Count = OBJdbConnection.Execute(SQLEvent3Count)
	
	SQLEvent4Count = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = 195744"
	Set rsEvent4Count = OBJdbConnection.Execute(SQLEvent4Count)


	'Check if there is a possible subscription
	If rsEvent1Count("LineCount") >= 1 And rsEvent2Count("LineCount") >= 1 Then

				'Find number of subscriptions by selecting event with lowest # of tickets at this price 
				NbrSubscriptions = Min(Array(rsEvent1Count("LineCount"),rsEvent2Count("LineCount")))			
		
				'Count # of existing seats which have discount applied for this act and seat type code
				SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND DiscountTypeNumber = " & DiscountTypeNumber
				Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)

				'If the # of discounts at this price for these events < the total possible, discount price
				If rsDiscCount("LineCount") < NbrSubscriptions Then
					
					'Fixed Amount Discount by Ticket Price
					
					Select Case EventCode
						Case 195739
							NewPrice = 7.5
						Case 195741
							NewPrice = 7.5
	        End Select


				End If
												
				rsDiscCount.Close
				Set rsDiscCount = nothing

	End If
	
	If rsEvent3Count("LineCount") >= 1 And rsEvent4Count("LineCount") >= 1 Then

			'Find number of subscriptions by selecting event with lowest # of tickets at this price 
			NbrSubscriptions = Min(Array(rsEvent3Count("LineCount"),rsEvent4Count("LineCount")))			
		
			'Count # of existing seats which have discount applied for this act and seat type code
			SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND DiscountTypeNumber = " & DiscountTypeNumber
			Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)

			'If the # of discounts at this price for these events < the total possible, discount price
			If rsDiscCount("LineCount") < NbrSubscriptions Then
					
				'Fixed Amount Discount by Ticket Price


	
					Select Case EventCode
						Case 195743
							NewPrice = 7.5
						Case 195744
							NewPrice = 7.5
	        End Select


	        
			End If
												
			rsDiscCount.Close
			Set rsDiscCount = nothing

End If

							
	rsEvent1Count.Close
	Set rsEvent1Count = nothing
	rsEvent2Count.Close
	Set rsEvent2Count = nothing
	rsEvent3Count.Close
	Set rsEvent1Count = nothing
	rsEvent4Count.Close
	Set rsEvent2Count = nothing
	
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