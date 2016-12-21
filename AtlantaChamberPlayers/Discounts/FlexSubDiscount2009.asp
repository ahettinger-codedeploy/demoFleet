<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%
' 2009-2010 Atlanta Chamber Players Subscriber Package
' Subscription must have at least 1 ticket to 3 different productions
' Discount has three price tiers with uneven discount amounts
SeriesCount = 3 'Min number of productions required 
Price3 = 50 '3 Production Series Price is $50
Price4 = 65 '4 Production Series Price is $65
Price5 = 75 '5 Production Series Price is $75

' Valid productions for this discount are:
ActCodeList = "31642,31641,41492,41496,41505" 'ActCodes which can be included in subscription.
'214134 (ActCode = 31642) Sunday 10/4/2009 3:00 PM 	  Chamber Music Concert - Chamber Music in Art Spaces 
'214268 (ActCode = 31641) Sunday 11/15/2009 3:00 PM   Chamber Music Concert - Chamber Music in Sacred Spaces
'214555 (ActCode = 41492) Tuesday 1/26/2010 7:30 PM   Chamber Music at the Tavern
'214559 (ActCode = 41496) Sunday 2/28/2010 3:00 PM 	  Chamber Music at Spivey Hall
'214567 (ActCode = 41505) Wednesday 4/28/2010 8:00 PM Chamber Music at the Tavern 2

'Initialize Variables
Price = Clean(Request("Price"))
EventCode = Clean(Request("EventCode"))
SeatTypeCode = Clean(Request("SeatTypeCode"))
AllowedSeatTypeList = ""
If AllowedSeatTypeCode <> "" Then
    AllowedSeatTypeList = " AND OrderLine.SeatTypeCode IN (0" & AllowedSeatTypeCode & "0)"
End If

If AllowDiscount = "Y" Then 'It's okay to apply to this order.

	'Determine the number of acts on the order which are part of this subscription.
	SQLActCount = "SELECT COUNT(DISTINCT Event.ActCode) AS ActCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ")" &  AllowedSeatTypeList & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
	Set rsActCount = OBJdbConnection.Execute(SQLActCount)	
	ActCount = rsActCount("ActCount")	
	rsActCount.Close
	Set rsActCount = nothing

	If ActCount >= SeriesCount Then

		'Get the fewest number of tickets for any applicable ActCode
		SQLMinTicketCount = "SELECT ActCode, COUNT(*) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ")" &  AllowedSeatTypeList & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode ORDER BY COUNT(*)"
		Set rsMinTicketCount = OBJdbConnection.Execute(SQLMinTicketCount)		
		NbrSubscriptions = rsMinTicketCount("TicketCount")		
		rsMinTicketCount.Close
		Set rsMinTicketCount = nothing
		
		'Get Act Code
		SQLAct = "SELECT ActCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
		Set rsAct = OBJdbConnection.Execute(SQLAct)		
		ActCode = rsAct("ActCode")		
		rsAct.Close
		Set rsAct = nothing

		'Determine the number of existing seats which have discount applied for this act
		SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ActCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
		Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)		
		AppliedCount = rsDiscCount("LineCount")		
		rsDiscCount.Close
		Set rsDiscCount = nothing

		'If the # of discounts for this act < the total # of subscriptions, discount the ticket
		If AppliedCount < NbrSubscriptions Then		  
		
			'Season Subscription Discount
			Select Case ActCount				
				Case 3
				    SeriesPrice = Price3
				    SeriesCount = 3
				Case 4
				    SeriesPrice = Price4
				    SeriesCount = 4
				Case 5
				    SeriesPrice = Price5
				    SeriesCount = 5
			End Select

			'Count number of tickets which have been given a discount
			SQLCount = "SELECT COUNT(OrderLine.ItemNumber) AS AppliedCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND DiscountTypeNumber = " & DiscountTypeNumber
			Set rsCount = OBJdbConnection.Execute(SQLCount)
			Count = rsCount("AppliedCount")
			rsCount.Close
			Set rsCount = nothing     
						
			'Calculates the per ticket discount
			Remainder = Count MOD SeriesCount
			If Remainder = SeriesCount - 1 Then 
			    NewPrice = SeriesPrice - ((SeriesCount - 1) * Round(SeriesPrice/SeriesCount, 2))
			Else
				  NewPrice = Round(SeriesPrice/SeriesCount, 2)
			End If
					
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