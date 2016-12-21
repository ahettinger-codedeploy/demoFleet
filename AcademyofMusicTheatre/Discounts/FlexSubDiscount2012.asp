<%

'CHANGE LOG - Inception
'SSR  (12/14/2011)
'Custom Discount Code Created. 

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%


'====================================================================

'Academy Theater of Music

'6 Package Subscription with percentage discounting by event count

'-OR-

'5 Tier Season Subscription with series pricing by act count
'-Plus-
'Bonus Act Discount with Season Subscription Purchase

'Note: The package discount takes precedence, over the season subscription discount.
'If the criteria for the package discount is not met, the system will then apply the series discount.

'--------------------
'Package Subscrption
'--------------------

'Requires the purchase of 1 ticket to each of the events which makes up the package
'Ticket types must match
'Avail Online and offline.
'No change to service fees.

'(1) MANDEN DIATA: The Lion King of Mandingue
'	 Act Code: 83671
'	 Event Code: 506199,506200,506201 (3)

'(2) The Most Fabulous Story Ever Told By Paul Rudnick
'	 Act Code: 83674	 
'	 Event Code: 506211,506212,506213 (3)

'(3) Matter over Mind: The 15th Year Anniversary Celebration of Catalyst, PVPA’s Renowned Student Dance Company
'	 Act Code: 83838	 
'	 Event Code: 506462,506463 (2)

'(4) THE 25TH ANNUAL PUTNAM COUNTY SPELLING BEE
'	 Act Code: 83840	 
'	 Event Code: 506216,506217,506218,506219 (4)

'(5) “A Hot Time in the City” Spring Showcase
'	 Act Code: 83841	 
'	 Event Code: 506220,506221 (2)

'(6) William Shakespeare’s “The Tempest” 
'	 Act Code: 87807	 
'	 Event Code: 506196,506197,506202 (3)


'Discount: 25% off each ticket


'-------------------
'Season Subscription
'-------------------

'Requires the purchase of 1 ticket to each of the acts which make up the subscription
'Automatic
'Ticket types must match
'Avail Online and offline.



'No change to service fees.


'ActCode	ActName
'83668		Holiday Jubilee
'83670		The Tempest
'83671		MANDEN DIATA: The Lion King of Mandingue
'83674		The Most Fabulous Story Ever Told
'83838		Matter over Mind
'83839	 	Dance for Kids!
'83841	 	A Hot Time in the City

'BONUS

'ActCode	ActName
'83840		THE 25TH ANNUAL PUTNAM COUNTY SPELLING BEE


'SeatCode	SeatType
'1			Adult
'3			Senior
'6			Student
'3678		Adult cc
'3681		Student cc
'3682		Senior cc

'Note: For purposes of this season subscription discount, AdultCC, StudentCC and SeniorCC are considered the exact same SeatType as Adult, Student and Senior 


'Discount:

'Buy any 2 of ActCode 83839,83841,83671,83668,83670,83674,83838 AND 1 of Bonus ActCode 83840 with SeatTypeCode 1  = 38.25 Series Price
'Buy any 3 of ActCode 83839,83841,83671,83668,83670,83674,83838 AND 1 of Bonus ActCode 83840 with SeatTypeCode 1  = 48.45 Series Price
'Buy any 4 of ActCode 83839,83841,83671,83668,83670,83674,83838 AND 1 of Bonus ActCode 83840 with SeatTypeCode 1  = 58.65 Series Price
'Buy any 5 of ActCode 83839,83841,83671,83668,83670,83674,83838 AND 1 of Bonus ActCode 83840 with SeatTypeCode 1  = 68.85 Series Price
'Buy any 6 of ActCode 83839,83841,83671,83668,83670,83674,83838 AND 1 of Bonus ActCode 83840 with SeatTypeCode 1  = 79.05 Series Price

'Buy any 2 of ActCode 83839,83841,83671,83668,83670,83674,83838 AND 1 of Bonus ActCode 83840 with SeatTypeCode 3  = 29.75 Series Price
'Buy any 3 of ActCode 83839,83841,83671,83668,83670,83674,83838 AND 1 of Bonus ActCode 83840 with SeatTypeCode 3  = 38.25 Series Price
'Buy any 4 of ActCode 83839,83841,83671,83668,83670,83674,83838 AND 1 of Bonus ActCode 83840 with SeatTypeCode 3  = 46.75 Series Price
'Buy any 5 of ActCode 83839,83841,83671,83668,83670,83674,83838 AND 1 of Bonus ActCode 83840 with SeatTypeCode 3  = 55.25 Series Price
'Buy any 6 of ActCode 83839,83841,83671,83668,83670,83674,83838 AND 1 of Bonus ActCode 83840 with SeatTypeCode 3  = 63.75 Series Price

'Buy any 2 of ActCode 83839,83841,83671,83668,83670,83674,83838 AND 1 of Bonus ActCode 83840 with SeatTypeCode 6  = 17.85 Series Price
'Buy any 3 of ActCode 83839,83841,83671,83668,83670,83674,83838 AND 1 of Bonus ActCode 83840 with SeatTypeCode 6  = 22.95 Series Price
'Buy any 4 of ActCode 83839,83841,83671,83668,83670,83674,83838 AND 1 of Bonus ActCode 83840 with SeatTypeCode 6  = 28.05 Series Price
'Buy any 5 of ActCode 83839,83841,83671,83668,83670,83674,83838 AND 1 of Bonus ActCode 83840 with SeatTypeCode 6  = 33.15 Series Price
'Buy any 6 of ActCode 83839,83841,83671,83668,83670,83674,83838 AND 1 of Bonus ActCode 83840 with SeatTypeCode 6  = 38.25 Series Price




'====================================================================

PackageDiscount = False

Percentage = 25

ActCodeList = "83839,83841,83671,83668,83670,83674,83838"
BonusActCodeList = 83840

MinSeriesCount = 2

BonusMinCount = 1

'Series (Act Count, Seat Type Code)

Dim Series (6,6)

Series(2,1) = 38.25 
Series(3,1) = 48.45 
Series(4,1) = 58.65
Series(5,1) = 68.85
Series(6,1) = 79.05

Series(2,3) = 29.75
Series(3,3) = 38.25
Series(4,3) = 46.75
Series(5,3) = 55.25
Series(6,3) = 63.75

Series(2,6) = 17.85
Series(3,6) = 22.95
Series(4,6) = 28.05
Series(5,6) = 33.15
Series(6,6) = 38.25

'--------------------------------------------------------------------

'Determine if there are package discounts on the order

'The Lion King of Mandingue
SQLEventCount1 = "SELECT COUNT(EventCode) AS EventCount1 FROM (SELECT Event.EventCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.EventCode IN (506196,506197,506202) AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') AND OrderLine.SeatTypeCode = " & Clean(Request("SeatTypeCode")) & " GROUP BY Event.EventCode) AS EventCount1"
Set rsEventCount1 = OBJdbConnection.Execute(SQLEventCount1)	
EventCount1 = rsEventCount1("EventCount1")	
rsEventCount1.Close
Set rsEventCount1 = nothing

If EventCount1 >= 3 Then
PackageDiscount = True
End If

'Determine the number of events on this order.
SQLEventCount2 = "SELECT COUNT(EventCode) AS EventCount2 FROM (SELECT Event.EventCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.EventCode IN (506220,506221) AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') AND OrderLine.SeatTypeCode = " & Clean(Request("SeatTypeCode")) & " GROUP BY Event.EventCode) AS EventCount2"
Set rsEventCount2 = OBJdbConnection.Execute(SQLEventCount2)	
EventCount2 = rsEventCount2("EventCount2")	
rsEventCount2.Close
Set rsEventCount2 = nothing

If EventCount2 >= 3 Then
PackageDiscount = True
End If

'Determine the number of events on this order.
SQLEventCount3 = "SELECT COUNT(EventCode) AS EventCount3 FROM (SELECT Event.EventCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.EventCode IN (506216,506217,506218,506219) AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') AND OrderLine.SeatTypeCode = " & Clean(Request("SeatTypeCode")) & " GROUP BY Event.EventCode) AS EventCount3"
Set rsEventCount3 = OBJdbConnection.Execute(SQLEventCount3)	
EventCount3 = rsEventCount3("EventCount3")	
rsEventCount3.Close
Set rsEventCount3 = nothing

If EventCount3 >= 2 Then
PackageDiscount = True
End If

'Determine the number of events on this order.
SQLEventCount4 = "SELECT COUNT(EventCode) AS EventCount4 FROM (SELECT Event.EventCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.EventCode IN (506462,506463) AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') AND OrderLine.SeatTypeCode = " & Clean(Request("SeatTypeCode")) & " GROUP BY Event.EventCode) AS EventCount4"
Set rsEventCount4 = OBJdbConnection.Execute(SQLEventCount4)	
EventCount4 = rsEventCount4("EventCount4")	
rsEventCount4.Close
Set rsEventCount4 = nothing

If EventCount4 >= 4 Then
PackageDiscount = True
End If

'Determine the number of events on this order.
SQLEventCount5 = "SELECT COUNT(EventCode) AS EventCount5 FROM (SELECT Event.EventCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.EventCode IN (506211,506212,506213 ) AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') AND OrderLine.SeatTypeCode = " & Clean(Request("SeatTypeCode")) & " GROUP BY Event.EventCode) AS EventCount5"
Set rsEventCount5 = OBJdbConnection.Execute(SQLEventCount5)	
EventCount5 = rsEventCount5("EventCount5")	
rsEventCount5.Close
Set rsEventCount5 = nothing

If EventCount5 >= 2 Then
PackageDiscount = True
End If

'Determine the number of events on this order.
SQLEventCount6 = "SELECT COUNT(EventCode) AS EventCount6 FROM (SELECT Event.EventCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.EventCode IN (506199,506200,506201) AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') AND OrderLine.SeatTypeCode = " & Clean(Request("SeatTypeCode")) & " GROUP BY Event.EventCode) AS EventCount6"
Set rsEventCount6 = OBJdbConnection.Execute(SQLEventCount6)	
EventCount6 = rsEventCount6("EventCount6")	
rsEventCount6.Close
Set rsEventCount6 = nothing

If EventCount6 >= 3 Then
PackageDiscount = True
End If


'--------------------------------------------------------------------

'Package Discount

If PackageDiscount = True Then

'Get Act Code
SQLAct = "SELECT ActCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
Set rsAct = OBJdbConnection.Execute(SQLAct)		
ActCode = rsAct("ActCode")		
rsAct.Close
Set rsAct = nothing

If ActCode = 83671 Then

		'Determine the number of events on this order.
		SQLEventCount = "SELECT COUNT(EventCode) AS EventCount FROM (SELECT Event.EventCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.EventCode IN (506199,506200,506201) AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') AND OrderLine.SeatTypeCode = " & Clean(Request("SeatTypeCode")) & " GROUP BY Event.EventCode) AS EventCount"
		Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)	
		EventCount = rsEventCount("EventCount")	
		rsEventCount.Close
		Set rsEventCount = nothing
				
        If EventCount >= 3 Then
		
			'Determine the number of possible packages on this order
			SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumPacks FROM (SELECT Event.EventCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.EventCode IN (506199,506200,506201) AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.EventCode) AS TicketCount"
			Set rsMinTicketCount = OBJdbConnection.Execute(SQLMinTicketCount)		
			Nbrpackages = rsMinTicketCount("NumPacks")		
			rsMinTicketCount.Close
			Set rsMinTicketCount = nothing

			'Get the EventCode
			SQLEvent = "SELECT EventCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
			Set rsEvent = OBJdbConnection.Execute(SQLEvent)		
			EventCode = rsEvent("EventCode")		
			rsEvent.Close
			Set rsEvent = nothing

			'Count the number of seats which have been discounted
			SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
			Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)		
			AppliedCount = rsDiscCount("LineCount")		
			rsDiscCount.Close
			Set rsDiscCount = nothing

			'If the number of discounted seats at this price for these events is less then the total possible, apply discount

			If AppliedCount < Nbrpackages Then	
				
				
				Select Case ActCode
					Case 83671
				
						NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Percentage)/100), 2)
							
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
						
				End Select
														
				End If         
                            
        End If
		
End If



If ActCode = 83674 Then

		'Determine the number of events on this order.
		SQLEventCount = "SELECT COUNT(EventCode) AS EventCount FROM (SELECT Event.EventCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.EventCode IN (506211,506212,506213 ) AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') AND OrderLine.SeatTypeCode = " & Clean(Request("SeatTypeCode")) & " GROUP BY Event.EventCode) AS EventCount"
		Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)	
		EventCount = rsEventCount("EventCount")	
		rsEventCount.Close
		Set rsEventCount = nothing
				
        If EventCount >= 3 Then

			'Determine the number of possible packages on this order
			SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumPacks FROM (SELECT Event.EventCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.EventCode IN (506211,506212,506213 ) AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.EventCode) AS TicketCount"
			Set rsMinTicketCount = OBJdbConnection.Execute(SQLMinTicketCount)		
			Nbrpackages = rsMinTicketCount("NumPacks")		
			rsMinTicketCount.Close
			Set rsMinTicketCount = nothing

			'Get the EventCode
			SQLEvent = "SELECT EventCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
			Set rsEvent = OBJdbConnection.Execute(SQLEvent)		
			EventCode = rsEvent("EventCode")		
			rsEvent.Close
			Set rsEvent = nothing

			'Count the number of seats which have been discounted
			SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
			Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)		
			AppliedCount = rsDiscCount("LineCount")		
			rsDiscCount.Close
			Set rsDiscCount = nothing

			'If the number of discounted seats at this price for these events is less then the total possible, apply discount

			If AppliedCount < Nbrpackages Then	
				
				
				Select Case ActCode
					Case 83674
				
						NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Percentage)/100), 2)
							
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
						
				End Select
														
				End If         
                            
        End If
		
End If

If ActCode = 83838 Then


		'Determine the number of events on this order.
		SQLEventCount = "SELECT COUNT(EventCode) AS EventCount FROM (SELECT Event.EventCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.EventCode IN (506462,506463) AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') AND OrderLine.SeatTypeCode = " & Clean(Request("SeatTypeCode")) & " GROUP BY Event.EventCode) AS EventCount"
		Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)	
		EventCount = rsEventCount("EventCount")	
		rsEventCount.Close
		Set rsEventCount = nothing
				
        If EventCount >= 2 Then

			'Determine the number of possible packages on this order
			SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumPacks FROM (SELECT Event.EventCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.EventCode IN (506462,506463) AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.EventCode) AS TicketCount"
			Set rsMinTicketCount = OBJdbConnection.Execute(SQLMinTicketCount)		
			Nbrpackages = rsMinTicketCount("NumPacks")		
			rsMinTicketCount.Close
			Set rsMinTicketCount = nothing

			'Get the EventCode
			SQLEvent = "SELECT EventCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
			Set rsEvent = OBJdbConnection.Execute(SQLEvent)		
			EventCode = rsEvent("EventCode")		
			rsEvent.Close
			Set rsEvent = nothing

			'Count the number of seats which have been discounted
			SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
			Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)		
			AppliedCount = rsDiscCount("LineCount")		
			rsDiscCount.Close
			Set rsDiscCount = nothing

			'If the number of discounted seats at this price for these events is less then the total possible, apply discount

			If AppliedCount < Nbrpackages Then	
				
				
				Select Case ActCode
					Case 83838
				
						NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Percentage)/100), 2)
							
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
						
				End Select
														
				End If         
                            
        End If
		
End If

If ActCode = 83840 Then

		'Determine the number of events on this order.
		SQLEventCount = "SELECT COUNT(EventCode) AS EventCount FROM (SELECT Event.EventCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.EventCode IN (506216,506217,506218,506219) AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') AND OrderLine.SeatTypeCode = " & Clean(Request("SeatTypeCode")) & " GROUP BY Event.EventCode) AS EventCount"
		Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)	
		EventCount = rsEventCount("EventCount")	
		rsEventCount.Close
		Set rsEventCount = nothing
				
        If EventCount >= 4 Then

			'Determine the number of possible packages on this order
			SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumPacks FROM (SELECT Event.EventCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.EventCode IN (506216,506217,506218,506219) AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.EventCode) AS TicketCount"
			Set rsMinTicketCount = OBJdbConnection.Execute(SQLMinTicketCount)		
			Nbrpackages = rsMinTicketCount("NumPacks")		
			rsMinTicketCount.Close
			Set rsMinTicketCount = nothing

			'Get the EventCode
			SQLEvent = "SELECT EventCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
			Set rsEvent = OBJdbConnection.Execute(SQLEvent)		
			EventCode = rsEvent("EventCode")		
			rsEvent.Close
			Set rsEvent = nothing

			'Count the number of seats which have been discounted
			SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
			Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)		
			AppliedCount = rsDiscCount("LineCount")		
			rsDiscCount.Close
			Set rsDiscCount = nothing

			'If the number of discounted seats at this price for these events is less then the total possible, apply discount

			If AppliedCount < Nbrpackages Then	
				
				
				Select Case ActCode
					Case 83840
				
						NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Percentage)/100), 2)
							
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
						
				End Select
														
				End If         
                            
        End If
		
End If

If ActCode = 83841 Then



		'Determine the number of events on this order.
		SQLEventCount = "SELECT COUNT(EventCode) AS EventCount FROM (SELECT Event.EventCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.EventCode IN (506220,506221) AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') AND OrderLine.SeatTypeCode = " & Clean(Request("SeatTypeCode")) & " GROUP BY Event.EventCode) AS EventCount"
		Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)	
		EventCount = rsEventCount("EventCount")	
		rsEventCount.Close
		Set rsEventCount = nothing
				
        If EventCount >= 2 Then

			'Determine the number of possible packages on this order
			SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumPacks FROM (SELECT Event.EventCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.EventCode IN (506220,506221) AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.EventCode) AS TicketCount"
			Set rsMinTicketCount = OBJdbConnection.Execute(SQLMinTicketCount)		
			Nbrpackages = rsMinTicketCount("NumPacks")		
			rsMinTicketCount.Close
			Set rsMinTicketCount = nothing

			'Get the EventCode
			SQLEvent = "SELECT EventCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
			Set rsEvent = OBJdbConnection.Execute(SQLEvent)		
			EventCode = rsEvent("EventCode")		
			rsEvent.Close
			Set rsEvent = nothing

			'Count the number of seats which have been discounted
			SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
			Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)		
			AppliedCount = rsDiscCount("LineCount")		
			rsDiscCount.Close
			Set rsDiscCount = nothing

			'If the number of discounted seats at this price for these events is less then the total possible, apply discount

			If AppliedCount < Nbrpackages Then	
				
				
				Select Case ActCode
					Case 83841
				
						NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Percentage)/100), 2)
							
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
						
				End Select
														
				End If         
                            
        End If
		
End If

If ActCode = 87807 Then

		'Determine the number of events on this order.
		SQLEventCount = "SELECT COUNT(EventCode) AS EventCount FROM (SELECT Event.EventCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.EventCode IN (506196,506197,506202) AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') AND OrderLine.SeatTypeCode = " & Clean(Request("SeatTypeCode")) & " GROUP BY Event.EventCode) AS EventCount"
		Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)	
		EventCount = rsEventCount("EventCount")	
		rsEventCount.Close
		Set rsEventCount = nothing
				
        If EventCount >= 3 Then

			'Determine the number of possible packages on this order
			SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumPacks FROM (SELECT Event.EventCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.EventCode IN (506196,506197,506202) AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.EventCode) AS TicketCount"
			Set rsMinTicketCount = OBJdbConnection.Execute(SQLMinTicketCount)		
			Nbrpackages = rsMinTicketCount("NumPacks")		
			rsMinTicketCount.Close
			Set rsMinTicketCount = nothing

			'Get the EventCode
			SQLEvent = "SELECT EventCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
			Set rsEvent = OBJdbConnection.Execute(SQLEvent)		
			EventCode = rsEvent("EventCode")		
			rsEvent.Close
			Set rsEvent = nothing

			'Count the number of seats which have been discounted
			SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
			Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)		
			AppliedCount = rsDiscCount("LineCount")		
			rsDiscCount.Close
			Set rsDiscCount = nothing

			'If the number of discounted seats at this price for these events is less then the total possible, apply discount

			If AppliedCount < Nbrpackages Then	
				

				Select Case ActCode
					Case 87807
				
						NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Percentage)/100), 2)
							
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
						
				End Select
														
				End If         
                            
        End If
		
End If


End If

'------------------------------------------

'Season Subscription Discount

If PackageDiscount = False Then


	Select Case SeatTypeCode
		Case 3678 
			ThisSeatTypeCode = 1
		Case 3682 
			ThisSeatTypeCode = 3
		Case 3681 
			ThisSeatTypeCode = 6
		Case Else
			ThisSeatTypeCode = SeatTypeCode
	End Select


	If ThisSeatTypeCode = 1 OR ThisSeatTypeCode = 3  OR ThisSeatTypeCode = 6 Then
		
			'Count the number of season acts with matching ticket types.
			SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND OrderLine.SeatTypeCode = " & SeatTypeCode & " GROUP BY Event.ActCode) AS ActCount"
			Set rsActCount = OBJdbConnection.Execute(SQLActCount)
				ActCount = rsActCount("ActCount")
			rsActCount.Close
			Set rsActCount = nothing
			
			'ErrorLog("ActCount   " & ActCount  & "")

		If ActCount => MinSeriesCount Then   

			'Count the number of season acts with matching ticket types.
			SQLBonusActCount = "SELECT COUNT(ActCode) AS BonusActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & BonusActCodeList & ") AND OrderLine.SeatTypeCode = " & SeatTypeCode & " GROUP BY Event.ActCode) AS BonusActCount"
			Set rsBonusActCount = OBJdbConnection.Execute(SQLBonusActCount)
			BonusActCount = rsBonusActCount("BonusActCount")
			rsBonusActCount.Close
			Set rsBonusActCount = nothing
			
			'ErrorLog("BonusActCount  " & BonusActCount & "")

			If ActCount => BonusMinCount Then   
					
				MyPrice = Series(CInt(ActCount),CInt(ThisSeatTypeCode)) 

				'ErrorLog("MyPrice  " & MyPrice & "")

				'Determine how many sets of matching act code / ticket type  are on the order
				SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumSubs FROM (SELECT ActCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ", " & BonusActCodeList & ") GROUP BY Event.ActCode) AS TicketCount"
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

				'Determine the number of tickets which have been discounted
				SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ActCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
				Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)			
				AppliedCount = rsDiscCount("LineCount")        		
				rsDiscCount.Close
				Set rsDiscCount = nothing	

				
				'Count number of tickets which have been given a discount
				SQLCount = "SELECT COUNT(OrderLine.LineNumber) AS AppliedCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.OrderNumber = " & OrderNumber & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')" 
				Set rsCount = OBJdbConnection.Execute(SQLCount)
				Count = rsCount("AppliedCount")
				rsCount.Close
				Set rsCount = nothing
				
				SeriesCount = ActCount + NbrSubscriptions
				
				SeriesPrice = Series(CInt(ActCount),CInt(ThisSeatTypeCode)) 
				
				Select Case ThisSeatTypeCode
					Case 1
						BonusPrice = 21
						ActPrice = 12
					Case 3
						BonusPrice = 15
						ActPrice = 10
					Case 6
						BonusPrice = 9
						ActPrice = 6
				End Select
						
				SeriesFullPrice = (ActCount * ActPrice) + (NbrSubscriptions * BonusPrice)
				
				SeriesDiscount = SeriesFullPrice - SeriesPrice
							
				Remainder = Count MOD SeriesCount				        

					If Remainder = SeriesCount - 1 Then 
						DiscountAmount = SeriesDiscount - ((SeriesCount - 1) * Round(SeriesDiscount/SeriesCount, 2))
					Else
						DiscountAmount = Round(SeriesDiscount/SeriesCount, 2)
					End If
						
					NewPrice =  Clean(Request("Price")) - DiscountAmount
					
					Surcharge = 0
											
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