<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%
' 2009 Season Subscription for Mason Street Warehouse
' Subscription must have at least 1 Adult ticket to 3 different productions
' 3 different prices based on the series: Weekend, Weekday, Sun Matinee
' Bump down (or up) ticket price to match series ticket price for the series
' Example: If they buy 1 Friday and 2 Sun Matinee, they get the Friday series price on all three tickets


'Initialize Variables
Price = Clean(Request("Price"))
EventCode = Clean(Request("EventCode"))
SeatTypeCode = Clean(Request("SeatTypeCode"))

'Discount Variables
SeriesCount = 7 'Min number of productions required
SeatTypeList = 1 'SeatTypes which can be included in subscription. 
ActCodeList = "50468,50457,50472,50460,50464,50475,50350,50466,50458,50469,50462,50463,50473,50347" 'ActCodes which can be included in subscription.
WeekendPriceA = 180 'Friday/Saturday Series Price
WeekendPriceB = 145 'Friday/Saturday Series Price
WeekdayPriceA = 140 'Preview Friday and Thursday Series Price
WeekdayPriceB = 105 'Preview Friday and Thursday Series Price
SundayPriceA = 170 'Sunday Series Price
SundayPriceB = 135 'Sunday Series Price
MusicalPriceA = 110 'Musicals Series Price
MusicalPriceB = 90 'Musicals Series Price


If AllowDiscount = "Y" Then 'It's okay to apply to this order.

'Count # of seats for Friday and Saturday performances
	SQLWeekendACount = "SELECT COUNT(DATEPART(WEEKDAY, Event.Eventdate)) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.ActCode NOT IN (50466,50458,50469,50462,50463,50473,50347) And (DATEPART(WEEKDAY, Event.Eventdate)) IN (6,7)"
	Set rsWeekendACount = OBJdbConnection.Execute(SQLWeekendACount)
	
'Count # of seats for Friday and Saturday performances
	SQLWeekendBCount = "SELECT COUNT(DATEPART(WEEKDAY, Event.Eventdate)) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.ActCode NOT IN (50466,50458,50469,50462,50463,50473,50347) And (DATEPART(WEEKDAY, Event.Eventdate)) IN (6,7)"
	Set rsWeekendBCount = OBJdbConnection.Execute(SQLWeekendBCount)
	
'Count # of seats for Preview Friday and Thursday Eve performances
	SQLWeekdayACount = "SELECT COUNT(DATEPART(WEEKDAY, Event.Eventdate)) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode IN (265286,265302,269519,269520,269521,269522,267847,267934,267848,267936,269523,269524,267849,267937) And (DATEPART(WEEKDAY, Event.Eventdate)) IN (5,6) AND (Event.EventDate - CAST(FLOOR(CAST(Event.EventDate AS FLOAT)) AS DATETIME) > '02:00 PM')"
	Set rsWeekdayACount = OBJdbConnection.Execute(SQLWeekdayACount)

'Count # of seats for Preview Friday and Thursday Eve performances
	SQLWeekdayBCount = "SELECT COUNT(DATEPART(WEEKDAY, Event.Eventdate)) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode IN (265286,265302,269519,269520,269521,269522,267847,267934,267848,267936,269523,269524,267849,267937) And (DATEPART(WEEKDAY, Event.Eventdate)) IN (5,6) AND (Event.EventDate - CAST(FLOOR(CAST(Event.EventDate AS FLOAT)) AS DATETIME) > '02:00 PM')"
	Set rsWeekdayBCount = OBJdbConnection.Execute(SQLWeekdayBCount)
		
'Count # of seats for Sunday Matinee
	SQLSundayCountA = "SELECT COUNT(DATEPART(WEEKDAY, Event.Eventdate)) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " And (DATEPART(WEEKDAY, Event.Eventdate)) IN (1) AND (Event.EventDate - CAST(FLOOR(CAST(Event.EventDate AS FLOAT)) AS DATETIME) < '07:00 PM')"
	Set rsSundayCountA = OBJdbConnection.Execute(SQLSundayACount)

'Count # of seats for Sunday Matinee
	SQLSundayCountB = "SELECT COUNT(DATEPART(WEEKDAY, Event.Eventdate)) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " And (DATEPART(WEEKDAY, Event.Eventdate)) IN (1) AND (Event.EventDate - CAST(FLOOR(CAST(Event.EventDate AS FLOAT)) AS DATETIME) < '07:00 PM')"
	Set rsSundayCountB = OBJdbConnection.Execute(SQLSundayBCount)

'Count # of seats for Friday and Saturday performances
	SQLMusicalACount = "SELECT COUNT(DATEPART(WEEKDAY, Event.Eventdate)) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (50350,50475,50465,50468) And (DATEPART(WEEKDAY, Event.Eventdate)) IN (1,2,3,4,5,6,7)"
	Set rsMusicalACount = OBJdbConnection.Execute(SQLMusicalACount)
	
'Count # of seats for Friday and Saturday performances
	SQLMusicalBCount = "SELECT COUNT(DATEPART(WEEKDAY, Event.Eventdate)) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (50350,50475,50465,50468) And (DATEPART(WEEKDAY, Event.Eventdate)) IN (1,2,3,4,5,6,7)"
	Set rsMusicalBCount = OBJdbConnection.Execute(SQLMusicalBCount)
			
	
' Determine subscription type
	If rsWeekendACount("LineCount") >= 1 Then 
	    SeriesName = "WeekendA" 'Subscription is Friday,Saturday Pricing
	    SeriesPrice = WeekendPriceA
	ElseIf rsWeekendBCount("LineCount") >= 1 Then 
	    SeriesName = "WeekendB" 'Subscription is Friday,Saturday Pricing
	    SeriesPrice = WeekendPriceB

    ElseIf rsWeekdayACount("LineCount") >= 1 Then 
        SeriesName = "WeekdayA" 'Subscription is Preview Friday or Thur Eve Pricing
        SeriesPrice = WeekdayPriceA
    ElseIf rsWeekdayBCount("LineCount") >= 1 Then 
        SeriesName = "WeekdayB" 'Subscription is Preview Friday or Thur Eve Pricing
        SeriesPrice = WeekdayPriceB
        
	ElseIf rsSundayACount("LineCount") >= 1 Then 
				SeriesName = "SundayA" 'Subscription is Sunday Mat Pricing
				SeriesPrice = SundayPriceA
	ElseIf rsSundayBCount("LineCount") >= 1 Then 
				SeriesName = "SundayB" 'Subscription is Sunday Mat Pricing
				SeriesPrice = SundayPriceB
				
	ElseIf rsMusicalACount("LineCount") >= 1 Then 
				SeriesName = "MusicalA" 'Subscription is All Day Musical Pricing - Non Preview or Gala
				SeriesPrice = MusicalPriceA
	ElseIf rsMusicalBCount("LineCount") >= 1 Then 
				SeriesName = "MusicalB" 'Subscription is All Day Musical Pricing - Non Preview or Gala
				SeriesPrice = MusicalPriceB
							
	End If	
	
	
	rsWeekendACount.Close
	Set rsWeekendACount = nothing
	rsWeekendBCount.Close
	Set rsWeekendBCount = nothing
	rsWeekdayACount.Close
	Set rsWeekdayACount = nothing
	rsWeekdayBCount.Close
	Set rsWeekdayBCount = nothing
	rsSundayACount.Close
	Set rsSundayACount = nothing
	rsSundayBCount.Close
	Set rsSundayBCount = nothing
	rsMusicalACount.Close
	Set rsMusicalACount = nothing
	rsMusicalBCount.Close
	Set rsMusicalBCount = nothing

'Count # of Acts on the order.
	SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND OrderLine.SeatTypeCode IN (" & SeatTypeList & ") AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS ActCount"
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
		
		'Count number of tickets which have been given a discount
		SQLCount = "SELECT COUNT(OrderLine.ItemNumber) AS AppliedCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND DiscountTypeNumber = " & DiscountTypeNumber
		Set rsCount = OBJdbConnection.Execute(SQLCount)
		Count = rsCount("AppliedCount")
		rsCount.Close
		Set rsCount = nothing  
	      
				'Season Subscription Discount
				Select Case SeatTypeCode
				
						Case 1' Adult
								'Calculates the per ticket discount
								Remainder = Count MOD SeriesCount
								If Remainder = SeriesCount - 1 Then 
								    NewPrice = SeriesPrice - ((SeriesCount - 1) * Round(SeriesPrice/SeriesCount, 2))
								Else
									  NewPrice = Round(SeriesPrice/SeriesCount, 2)
								End If
												
						Case 27 ' Senior
							NewPrice = Price
											
						Case 24 ' Student
							NewPrice = Price
											
				End Select
									     
		End If	
											
	End If
	

	If Price > NewPrice Then
		DiscountAmount = Clean(Request("Price")) - NewPrice
		AppliedFlag = "Y"
	End If
	

End If

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>