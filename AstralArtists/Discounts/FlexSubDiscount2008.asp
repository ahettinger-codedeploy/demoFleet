<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%
'Initialize Variables
Price = Clean(Request("Price"))
Surcharge = Clean(Request("Surcharge"))

SeriesCount = 4 'Number of Productions in the this Season Subscription
ActCodeList = "26947,26948,26949,26950,26951,26952,26953,26954" 'ActCodes of Productions which can be included in Season Subscription.


If AllowDiscount = "Y" Then 'It's okay to apply to this order.

'Get new surcharge (if needed for discount)
	NewSurcharge = CDbl(Clean(Request("NewSurcharge")))

'Get the section color (if needed for discount)
	SQLColor = "SELECT Color FROM Section(NOLOCK) WHERE EventCode = " & EventCode & " AND SectionCode = '" & SectionCode & "'"
	Set rsColor = OBJdbConnection.Execute(SQLColor)
	
	Color = UCase(rsColor("Color"))
	
	rsColor.Close
	Set rsColor = nothing
	

'Get the weekday (if needed for discount)
	SQLEventDate = "SELECT EventDate FROM Event (NOLOCK) WHERE EventCode = " & EventCode
	Set rsEventDate = OBJdbConnection.Execute(SQLEventDate)
		
	If Not rsEventDate.EOF Then
		EventWeekday = UCase(CStr(WeekdayName(Weekday(rsEventDate("EventDate")))))
	End If
	
	rsEventDate.Close
	Set rsEventDate = nothing
	

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
					'NewPrice = round(CDbl(Clean(Request("Price"))) * (85/100), 2)
				
				'Fixed Price
					'NewPrice = 24.25
				
				'Fixed Amount Discount
					'NewPrice = Clean(Request("Price")) - 15
				
				'Fixed Price by Ticket Type
					Select Case SeatTypeCode 
						Case 564 'General Admission
							NewPrice = 15
			      Case 31 'Senior
							NewPrice = 12.50	
						Case 1337 'Student
					    NewPrice = Price							
					End Select
	        
				'Fixed Price by Weekday
					'Select Case EventWeekday 
						'Case "FRIDAY", "SATURDAY"
							'NewPrice = 34
						'Case "TUESDAY", "WEDNESDAY", "THURSDAY"
							'NewPrice = 32
						'Case "SUNDAY"
							'NewPrice = 30	
	        'End Select
	        
		End If	
											
	End If

	If Price > NewPrice Then
		DiscountAmount = Clean(Request("Price")) - NewPrice
		AppliedFlag = "Y"
	End If

	If Request("NewSurcharge") <> "" Then
					Surcharge = NewSurcharge
	Else
		If Request("CalcServiceFee") <> "N" Then
			Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
		End If
	End If
	
End If	

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>