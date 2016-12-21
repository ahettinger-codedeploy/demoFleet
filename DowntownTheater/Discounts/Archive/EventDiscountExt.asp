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


	MemberEvent1 = 743517 
	SeriesCount1 = 6
	
	MemberEvent2 = 743550
	SeriesCount2 = 3

	DIM AppliedCount1
	DIM AllowedCount1
	DIM AvailableCount1
	
	DIM AppliedCount2
	DIM AllowedCount2
	DIM AvailableCount2
	
	AppliedCount1 = 0
	AllowedCount1 = 0
	AvailableCount1 = 0
	
	
	AppliedCount2 = 0
	AllowedCount2 = 0
	AvailableCount2 = 0
	
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
		
		ERRORLOG("CustomerFound : "&CustomerFound &"")
	
		'------------------------------------------------------------

		'Determine if the patron has purchased member event 1
		SQLMemberBefore = "SELECT OrderLine.LineNumber FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE CustomerNumber = " & CustomerNbr & " AND EventCode = " & MemberEvent1 & ""
		Set rsMemberBefore = OBJdbConnection.Execute(SQLMemberBefore)
			If Not rsMemberBefore.EOF Then
				MemberEvent1Found = True
			End If   
		rsMemberBefore.Close
		Set rsMemberBefore = nothing
		
		ERRORLOG("MemberEvent1: "&MemberEvent1&" "&MemberEvent1Found&"")

		'------------------------------------------------------------
		
		'Determine if the patron has purchased member event 2
		SQLMemberBefore = "SELECT OrderLine.LineNumber FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE CustomerNumber = " & CustomerNbr & " AND EventCode = " & MemberEvent2 & ""
		Set rsMemberBefore = OBJdbConnection.Execute(SQLMemberBefore)
			If Not rsMemberBefore.EOF Then
				MemberEvent2Found = True
			End If   
		rsMemberBefore.Close
		Set rsMemberBefore = nothing
		
		ERRORLOG("MemberEvent2: "&MemberEvent2&" "&MemberEvent2Found&"")

		'------------------------------------------------------------
				
		'Get Act Code
		SQLAct = "SELECT Act, ActCode FROM Event (NOLOCK) INNER JOIN ACT(NOLOCK) WHERE EventCode = " & EventCode
		Set rsAct = OBJdbConnection.Execute(SQLAct)
		ActCode = rsAct("ActCode")
		thisAct = rsAct("Act")
		rsAct.Close
		Set rsAct = nothing
	
		'------------------------------------------------------------
				
			If MemberEvent1Found Then 
			
					ERRORLOG("MemberEvent1 Found")
				

					'Determine the number of membership tickets purchased
					SQLMemberTickets = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE CustomerNumber = " & CustomerNbr & " AND EventCode = " & MemberEvent1 & ""
					Set rsMemberTickets = OBJdbConnection.Execute(SQLMemberTickets)
						If Not rsMemberTickets.EOF Then
							AllowedCount1 = rsMemberTickets("TicketCount") * SeriesCount1
							SubscriptionCount = rsMemberTickets("TicketCount") 
						End If
					rsMemberTickets.Close
					Set rsMemberTickets = nothing
					
					ERRORLOG("Number of Subscriptions Purchased: "& SubscriptionCount &"")
					ERRORLOG("Total Number of Discounts Allowed: "& AllowedCount1  &"")
							
					'Determine the number of discounted tickets already given
					SQLApplied = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE CustomerNumber = " & CustomerNbr & " AND ActCode = " & ActCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & "AND OrderLine.StatusCode = 'S'"
					Set rsApplied = OBJdbConnection.Execute(SQLApplied)		
						AppliedCount1 = rsApplied("TicketCount")		
					rsApplied.Close
					Set rsApplied = nothing 
					
					ERRORLOG("Number of tickets discounted: "&AppliedCount1&"")
					
					AvailableCount1 = (AllowedCount1 - AppliedCount1)
					
					ERRORLOG(" "&Act&" Allowed:" & AllowedCount1 & " Applied:" & AppliedCount1 & " Available:  " & AvailableCount1 & "")

			
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
					

									
			Else
			
				ERRORLOG("MemberEvent1 Not Found")
			
			End If
			
			
		'------------------------------------------------------------
	
	End If
	
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf



%>
