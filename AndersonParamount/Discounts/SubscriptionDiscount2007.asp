<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

SeriesCount = 4 'Number of Productions in the Subscription
ActCodeList = "17426,17427,17967,17968,17969,17970" 'ActCodes of Productions to include.


If AllowDiscount = "Y" Then 'It's okay to apply to this order.

	'Get the color for this section
	SQLColor = "SELECT Color FROM Section(NOLOCK) WHERE EventCode = " & EventCode & " AND SectionCode = '" & SectionCode & "'"
	Set rsColor = OBJdbConnection.Execute(SQLColor)
	
	Color = UCase(rsColor("Color"))
	
	rsColor.Close
	Set rsColor = nothing
	


	'Count # of Acts on the order.  Exclude Gift Certificates.
'	SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND Section.Color = '" & Color & "' AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') AND OrderLine.SeatTypeCode = " & SeatTypeCode & " GROUP BY Event.ActCode) AS ActCount"
	'REE 6/12/6 - Modified to exclude Seat Type and price tier criteria.  Joslyn asked to allow different seat types and price tiers.
	SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS ActCount"
	Set rsActCount = OBJdbConnection.Execute(SQLActCount)
	
	ActCount = rsActCount("ActCount")
	
	rsActCount.Close
	Set rsActCount = nothing
	
	If ActCount >= SeriesCount Then

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

		'If the # of discounts at this price for these events < the total possible, discount price
		If AppliedCount < NbrSubscriptions Then
			
			'Enter Pricing Rules Here.
				NewPrice = CDbl(Clean(Request("Price"))) - 2

'			Surcharge = y
			
		End If
		
		'Jungle Book 
		If ActCode = 9172 Then 'It's a Jungle Book ticket.
			'Count Jungle Book tickets with discounts
'			SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = 9172 AND Section.Color = '" & Color & "' AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') AND OrderLine.SeatTypeCode = " & SeatTypeCode
			'REE 6/12/6 - Removed SeatType and Price Tier criteria
'			SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = 9172 AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
'			Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
			
'			JBAppliedCount = rsDiscCount("LineCount")
		
'			rsDiscCount.Close
'			Set rsDiscCount = nothing

			'If the # of discounts at this price for these events < the total possible, discount price
'			If JBAppliedCount < NbrSubscriptions Then 'Apply discount to Jungle Book ticket
			'REE 6/12/6 - Changed to allow any number of Jungle Book discounts providing there is at least one subscription
			If NbrSubscriptions >= 1 Then 'Apply discount to Jungle Book ticket			
				Select Case SeatTypeCode
					Case 1, 27
						NewPrice = Price - 2
					Case 139
						NewPrice = Price - 1
				End Select
				
			End If
			
		End If
										
	End If

	If Price > NewPrice Then
		DiscountAmount = Price - NewPrice
		AppliedFlag = "Y"
	End If
	
End If	

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>