<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%
'Initialize Variables
Price = Clean(Request("Price"))
ActCodeList = "27772,27983,28199,27985,28207,27990,28208,28824,28825,28822,28823" 'ActCodes of Productions which can be included in Season Subscription.


If AllowDiscount = "Y" Then 'It's okay to apply to this order.

'Count # of Acts on the order.
	SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS ActCount"
	Set rsActCount = OBJdbConnection.Execute(SQLActCount)
	
	ActCount = rsActCount("ActCount")

	rsActCount.Close
	Set rsActCount = nothing
	
  If ActCount = 6 Then
		SubscriptionType = "6SHOW"
		End If
		
If ActCount => 5 Then
		SubscriptionType = "5SHOW"
		End If
		
If ActCount => 4 Then
		SubscriptionType = "4SHOW"
		End If
		
If ActCount => 3 Then
		SubscriptionType = "3SHOW"
End If
	

		'Get the least number of tickets for any applicable ActCode
		SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumSubs FROM (SELECT ActCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS TicketCount"
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
		SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ActCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
		Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
		
		AppliedCount = rsDiscCount("LineCount")
		
		rsDiscCount.Close
		Set rsDiscCount = nothing

    '3SHOW Discount Pricing Rules
		If SubscriptionType = "3SHOW" Then

			'If the # of discounts at this price for these events < the total possible, discount price
			
				If Int(AppliedCount / 3) < NbrSubscriptions Then		   
							Select Case SeatTypeCode 
										Case 1 'Adult
											NewPrice = 14.33
										Case 5 'Child
											NewPrice = 11.33	
							End Select
							
				Else				   
							Select Case SeatTypeCode 
										Case 1 'Adult
											NewPrice = 14.34
										Case 5 'Child
											NewPrice = 11.34	
							End Select
  			End If
				
		End If
		
		
		'4SHOW Discount Pricing Rules
		If SubscriptionType = "4SHOW" Then

			'If the # of discounts at this price for these events < the total possible, discount price
				If AppliedCount < NbrSubscriptions Then		   
							Select Case SeatTypeCode 
										Case 1 'Adult
											NewPrice = 13.75
										Case 5 'Child
											NewPrice = 11.00				
							End Select
  			End If
				
		End If	
		
		
    'PICK5 Discount Pricing Rules
		If SubscriptionType = "5SHOW" Then

			'If the # of discounts at this price for these events < the total possible, discount price
				If AppliedCount < NbrSubscriptions Then		   
							Select Case SeatTypeCode 
										Case 1 'Adult
											NewPrice = 13.20
										Case 5 'Child
											NewPrice = 10.60						
							End Select
  			End If
				
		End If		
		
		
		'6SHOW Discount Pricing Rules
		If SubscriptionType = "6SHOW" Then
		
				If Int(AppliedCount / 6) < NbrSubscriptions Then		   
							Select Case SeatTypeCode 
										Case 1 'Adult
											NewPrice = 12
										Case 5 'Child
											NewPrice = 9.66
							
				Else				   
							Select Case SeatTypeCode 
										Case 1 'Adult
											NewPrice = 12
										Case 5 'Child
											NewPrice = 9.67	
							End Select
  			End If
				
		End If		
		
											
	If Price > NewPrice Then
		DiscountAmount = Clean(Request("Price")) - NewPrice
		AppliedFlag = "Y"
	End If
	
'End If	

End If

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>