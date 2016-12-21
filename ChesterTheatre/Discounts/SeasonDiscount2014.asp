<%

'CHANGE LOG
'SSR 2/19/2014 - Created New TIX2 Past Event Discount

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'===============================================

'Chester Theatre Company 
'2014 Season Subscription

'Past Event Discount
'When patron buys a ticket to either of the three subscription events,
'they will receive 1 discounted ticket to each of the 4 productions
 
'EventCode		Name				Valid Days					Quantity						
'----------		----------------------------------------------------------		
'631798 	 	2014 Flex Pass		Any Day						6 tickets in any combination
'631849 	 	2014 Weekday  		Wednesday/Thursday/Friday	1 ticket to each production
'631851 	 	2014 Weekend 		Saturdays/Sundays			1 ticket to each production


'ActCode    Production
'-------	----------
'101071		Madagascar
'101072		Annapurna
'101073		A Number


'Discount Amount
'--------------------------- 
'Discount: 	  100% off
'Service Fee: $0.00

'Restrictions
'--------------------------- 
'Automatic discount
'Applied to online orders only
'Valid for all ticket types
'Valid for all sections/price tiers
'Does not expire


'==================================================

	MemberEvent1 = 631849
	SeriesCount1 = 1
	
	MemberEvent2 = 631851
	SeriesCount2 = 1
	
	MemberEvent3 = 631798
	SeriesCount3 = 6

	
	DIM AppliedCount1
	DIM AllowedCount1
	DIM AvailableCount1
	
	AppliedCount1 = 0
	AllowedCount1 = 0
	AvailableCount1 = 0
	
	'ErrorLog Use
	'TimeStamp = Now()

	If AllowDiscount = "Y" Then 'It's okay to apply to this order.
		
		'-----------------------------------------------------------
						
		'Get the customer number
		SQLMemberNumber= "SELECT CustomerNumber FROM OrderHeader (NOLOCK) WHERE OrderHeader.OrderNumber = " & OrderNumber & ""
		Set rsMemberNumber = OBJdbConnection.Execute(SQLMemberNumber)
			If Not rsMemberNumber.EOF Then
				CustomerFound = True
				CustomerNbr = rsMemberNumber("CustomerNumber")
			End If
		rsMemberNumber.Close
		Set rsMemberNumber = nothing
		

		'------------------------------------------------------------

		'Determine if the patron has purchased member event 1
		SQLMemberBefore = "SELECT OrderLine.LineNumber FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE CustomerNumber = " & CustomerNbr & " AND EventCode = " & MemberEvent1 & ""
		Set rsMemberBefore = OBJdbConnection.Execute(SQLMemberBefore)
			If Not rsMemberBefore.EOF Then
				MemberEvent1Found = True
			End If   
		rsMemberBefore.Close
		Set rsMemberBefore = nothing
		
		'ERRORLOG("MemberEvent1: "&MemberEvent1&" "&MemberEvent1Found&"")
		
		
		'Determine if the patron has purchased member event 2
		SQLMemberBefore = "SELECT OrderLine.LineNumber FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE CustomerNumber = " & CustomerNbr & " AND EventCode = " & MemberEvent2 & ""
		Set rsMemberBefore = OBJdbConnection.Execute(SQLMemberBefore)
			If Not rsMemberBefore.EOF Then
				MemberEvent2Found = True
			End If   
		rsMemberBefore.Close
		Set rsMemberBefore = nothing
		
		'ERRORLOG("MemberEvent2: "&MemberEvent2&" "&MemberEvent2Found&"")
		
		'Determine if the patron has purchased member event 3
		SQLMemberBefore = "SELECT OrderLine.LineNumber FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE CustomerNumber = " & CustomerNbr & " AND EventCode = " & MemberEvent3 & ""
		Set rsMemberBefore = OBJdbConnection.Execute(SQLMemberBefore)
			If Not rsMemberBefore.EOF Then
				MemberEvent3Found = True
			End If   
		rsMemberBefore.Close
		Set rsMemberBefore = nothing
		
		'ERRORLOG("MemberEvent3: "&MemberEvent3&" "&MemberEvent3Found&"")
		
		
		'------------------------------------------------------------
				
		'Get Act Code
		SQLAct = "SELECT ActCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
		Set rsAct = OBJdbConnection.Execute(SQLAct)
		ActCode = rsAct("ActCode")
		rsAct.Close
		Set rsAct = nothing
	
		'ErrorLog("ActCode: " & ActCode & "")
		
		'Get Event Day Of Week
		'Days of the Week, 1 = Sunday, 2 = Monday, 3 = Tuesday, 4 = Wednesday, 5 = Thursday, 6 = Friday, 7 = Saturday 
		SQLEventDate = "SELECT EventDate FROM Event (NOLOCK) WHERE EventCode = " & EventCode
		Set rsEventDate = OBJdbConnection.Execute(SQLEventDate)			
		ThisDate = WeekDay(rsEventDate("EventDate"))
		rsEventDate.Close
		Set rsEventDate = nothing
	
		 'ErrorLog("ThisDate: " & ThisDate & "")
		
		
		'------------------------------------------------------------
				
			If MemberEvent1Found Then 
				
				
				If ThisDate <> 7 And ThisDate <> 1 Then
				
					'Determine the number of membership tickets purchased
					SQLMemberTickets = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE CustomerNumber = " & CustomerNbr & " AND EventCode = " & MemberEvent1 & ""
					Set rsMemberTickets = OBJdbConnection.Execute(SQLMemberTickets)
						If Not rsMemberTickets.EOF Then
							AllowedCount1 = rsMemberTickets("TicketCount") * SeriesCount1
						End If
					rsMemberTickets.Close
					Set rsMemberTickets = nothing
					
					'ERRORLOG("Number of Memberships Bought: "&AllowedCount&"")
							
					'Determine the number of discounted tickets already given
					SQLApplied = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE CustomerNumber = " & CustomerNbr & " AND ActCode = " & ActCode & " AND (DATEPART(WEEKDAY, Event.Eventdate)) IN (4,5,6) AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & "AND OrderLine.StatusCode = 'S'"
					Set rsApplied = OBJdbConnection.Execute(SQLApplied)		
					
					AppliedCount1 = rsApplied("TicketCount")		
					
					rsApplied.Close
					Set rsApplied = nothing 
					
					'ErrorLog Use
					'Select Case ActCode
					'Case 101071
						'Act = "Madagascar"
					'Case 101072
						'Act = "Annapurna"
					'Case 101073
						'Act = "A Number"
					'End Select
					
					AvailableCount1 = (AllowedCount1 - AppliedCount1)
					
					'ERRORLOG(" "&TimeStamp&" Weekday: "&Act&" Allowed:" & AllowedCount1 & " Applied:" & AppliedCount1 & " Available:  " & AvailableCount1 & "")

					
					
					If AvailableCount1 < 0 Then
						AvailableCount1 = 0
					End If					

	
							
					If AvailableCount1 <> 0 Then 
																			
						'Determine number of tickets on this order which have been discounted
						SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ActCode & " AND (DATEPART(WEEKDAY, Event.Eventdate)) IN (4,5,6) AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') "
						Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)	
						
							If rsDiscCount("LineCount") < AvailableCount1 Then
												 
								NewPrice = 0
								Surcharge = 0
								DiscountAmount = Price - NewPrice
								AppliedFlag = "Y"

							End If
					
						rsDiscCount.Close
						Set rsDiscCount = nothing

					End If
					
						
				End If
									
			End If
			
			
		'------------------------------------------------------------
						
			If MemberEvent2Found Then 
				
				
				If ThisDate <> 4 And ThisDate <> 5 And ThisDate <> 6 Then
				
					'Determine the number of membership tickets purchased
					SQLMemberTickets = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE CustomerNumber = " & CustomerNbr & " AND EventCode = " & MemberEvent2 & ""
					Set rsMemberTickets = OBJdbConnection.Execute(SQLMemberTickets)
						If Not rsMemberTickets.EOF Then
							AllowedCount2 = rsMemberTickets("TicketCount") * SeriesCount2
						End If
					rsMemberTickets.Close
					Set rsMemberTickets = nothing
					
					'ERRORLOG("Number of Member 2s Bought: "&AllowedCount2&"")
							
					'Determine the number of discounted tickets already given
					SQLApplied = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE CustomerNumber = " & CustomerNbr & " AND ActCode = " & ActCode & " AND (DATEPART(WEEKDAY, Event.Eventdate)) IN (1,7) AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & "AND OrderLine.StatusCode = 'S'"
					Set rsApplied = OBJdbConnection.Execute(SQLApplied)		
					
					AppliedCount2 = rsApplied("TicketCount")		
					
					rsApplied.Close
					Set rsApplied = nothing 
					
					
					'Select Case ActCode
					'Case 101071
						'Act = "Madagascar"
					'Case 101072
						'Act = "Annapurna"
					'Case 101073
						'Act = "A Number"
					'End Select
					
					AvailableCount2 = (AllowedCount2 - AppliedCount2)
					
					'ERRORLOG(" "&TimeStamp&" Number of Purchased Weekend Tickets to "&Act&": " & AppliedCount2 & " Available:  " & AvailableCount2 & "")

					
					
					If AvailableCount2 < 0 Then
						AvailableCount2 = 0
					End If					

	
							
					If AvailableCount2 <> 0 Then 
																			
						'Determine number of tickets on this order which have been discounted
						SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ActCode & " AND (DATEPART(WEEKDAY, Event.Eventdate)) IN (1,7) AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') "
						Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)	
						
							If rsDiscCount("LineCount") < AvailableCount2 Then
												 
								NewPrice = 0
								Surcharge = 0
								DiscountAmount = Price - NewPrice
								AppliedFlag = "Y"

							End If
					
						rsDiscCount.Close
						Set rsDiscCount = nothing

					End If
					
						
				End If
									
			End If
			
			
		'------------------------------------------------------------
		
			If MemberEvent3Found Then 
								
					'Determine the number of membership tickets purchased
					SQLMemberTickets = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE CustomerNumber = " & CustomerNbr & " AND EventCode = " & MemberEvent3 & ""
					Set rsMemberTickets = OBJdbConnection.Execute(SQLMemberTickets)
						If Not rsMemberTickets.EOF Then
							AllowedCount3 = rsMemberTickets("TicketCount") * SeriesCount3
						End If
					rsMemberTickets.Close
					Set rsMemberTickets = nothing
					
					'ERRORLOG("Number of Member 3s Bought: "&AllowedCount3&"")
							
					'Determine the number of discounted tickets already given
					SQLApplied = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE CustomerNumber = " & CustomerNbr & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & "AND OrderLine.StatusCode = 'S'"
					Set rsApplied = OBJdbConnection.Execute(SQLApplied)		
					
					AppliedCount3 = rsApplied("TicketCount")		
					
					rsApplied.Close
					Set rsApplied = nothing 
					
					
					AvailableCount3 = (AllowedCount3 - AppliedCount3)
					
					'ERRORLOG(" "&TimeStamp&" Number of Purchased Tickets to: " & AppliedCount3 & " Available:  " & AvailableCount3 & "")

					
					
					If AvailableCount3 < 0 Then
						AvailableCount3 = 0
					End If					

	
							
					If AvailableCount3 <> 0 Then 
																			
						'Determine number of tickets on this order which have been discounted
						SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') "
						Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)	
						
							If rsDiscCount("LineCount") < AvailableCount3 Then
												 
								NewPrice = 0
								Surcharge = 0
								DiscountAmount = Price - NewPrice
								AppliedFlag = "Y"

							End If
					
						rsDiscCount.Close
						Set rsDiscCount = nothing

					End If
					
														
			End If
			
		'------------------------------------------------------------
			
		
			
	End If
	
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf



%>
