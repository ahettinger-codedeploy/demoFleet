<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%
'Initialize Variables
Price = Clean(Request("Price"))
ActCode = Clean(Request("ActCode"))
EventCode = Clean(Request("EventCode"))

SeriesCount = 2 'Number of Productions in the this Season Subscription
ActCodePkgA = "25281,25282,25350" 'ActCodes which are required to receive discount
ActCodeList = "25281,25282,25350,25345,25268,25353,25279" 'ActCodes which are can be included in season subscription.

If AllowDiscount = "Y" Then 'It's okay to apply to this order.

	'Get the color for this section (if needed for discount)
	SQLColor = "SELECT Color FROM Section(NOLOCK) WHERE EventCode = " & EventCode & " AND SectionCode = '" & SectionCode & "'"
	Set rsColor = OBJdbConnection.Execute(SQLColor)
	
	Color = UCase(rsColor("Color"))
	
	rsColor.Close
	Set rsColor = nothing
	
	
'Verify that they have purchased Film A
	SQLActCountA = "SELECT COUNT(ActCode) AS ActCountA FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodePkgA & ") AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS ActCountA"
	Set rsActCountA = OBJdbConnection.Execute(SQLActCountA)
	
	ActCountA = rsActCountA("ActCountA")
	
	rsActCountA.Close
	Set rsActCountA = nothing
	
If ActCountA >= 1 Then

'Count # of Acts on the order.
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
			
			 'Enter Season Ticket pricing rules here.
			 
				'Percentage Discount
					'NewPrice = round(CDbl(Clean(Request("Price"))) * (50/100), 2)
				
				'Fixed Price
					NewPrice = 5
				
				'Fixed Amount Discount
					'NewPrice = Clean(Request("Price")) - 15
				
				'Fixed Amount Discount by Ticket Price
					'Select Case Price 
						'Case 32 'Adult
							'NewPrice = 25
			      'Case 27 'Senior
							'NewPrice = 20	
						'Case 0 'Student/Free
					    'NewPrice = 0							
	        'End Select
	        
											
	End If

	If Price > NewPrice Then
		DiscountAmount = Clean(Request("Price")) - NewPrice
		AppliedFlag = "Y"
	End If
	
End If

End If

End If

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>