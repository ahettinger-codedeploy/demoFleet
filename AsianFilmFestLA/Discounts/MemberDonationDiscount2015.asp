<%

'CHANGE LOG
'SSR - 02/20/15 - Created discount script
'SSR - 03/05/15 - Updated discount to allow membership discount on all events.
'SSR - 03/10/15 - Updated discount to allow 100% off discount on general admission and membership tickets
'SSR - 03/18/15 - Updated discount to include 2 new additional donation levels
'SSR - 03/23/15 - Updated discount to allow max out Festival Guest at 1 ticket per event, max of 15 tickets total.
'SSR - 04/02/15 - Updated discount to allow "Supporter" level membership price discounts
'SSR - 04/06/15 - Updated discount to allow membership price discounts at all levels

'============================================

'Visual Communiations - Asian Film Festival

'Discount Type: Membership Based Ticket Discount

'Description: The purchase of a membership entitles the patron to discounted tickets for specific events

'Available Internet: 	YES 

'Available Box Office: 	YES 

'Valid Ticket Types:
'#42850 – General Admission
'#42843 - Member (ID Required)

'The  general admission ticket is the only ticket which will be discounted.
'The member ticket will be used to determine the membership discount applied to the general admission tickets.

'Valid Events
'Opening VIP Night Events:        #640651
'Opening Night Events:            #640652, #640653
'Closing Night Event:             #640654
'Regular Events:                  All other event codes

'Start Date: Now 
'End Date:    April 17 

'Additional ticket discounts: 
'Purchasing additional memberships will increase the number of discounted tickets allowed.


'2015 Supporter
'------------
'All Events:    Unlimited General Admission tickets discounted down to the same price as the Membership Ticket for the event
 
 
'2015 Friend
'------------
'Regular Events: 2 General Admission tickets discounted  to 100%
'All Events:     Unlimited General Admission tickets discounted down to the same price as the Membership Ticket for the event
 
 
'2015 Filmmaker
'------------
'Regular Events: 4 General Admission tickets discounted  to 100%
'All Events:     Unlimited General Admission tickets discounted down to the same price as the Membership Ticket for the event
 
 
'2015 Sponsor
'------------
'Regular Events: 6 General Admission tickets discounted  to 100%
'Opening Night:  2 General Admission tickets discounted  to 100% for this event.
'All Events:     Unlimited General Admission tickets discounted down to the same price as the Membership Ticket for the event
 
  
'2015 Patron
'------------
'Regular Events: 8 General Admission tickets discounted  to 100%
'Opening Night:  2 General Admission tickets discounted  to 100% for this event.
'Closing Night:  2 General Admission tickets discounted  to 100% for this event.
'All Events:     Unlimited General Admission tickets discounted down to the same price as the Membership Ticket for the event
 
 
'2015 Benefactor
'------------
'Regular Events:    10 General Admission tickets discounted  to 100%
'Opening VIP Night: 2 General  Admission tickets discounted  to 100% for this event.
'Closing Night:     2 General  Admission tickets discounted  to 100% for this event.
'All Events:        Unlimited  General Admission tickets discounted down to the same price as the Membership Ticket for the event
 
 
'2015 Supporter
'------------
'All Events:    Unlimited General Admission tickets discounted down to the same price as the Membership Ticket for the event


'2015 Friend
'------------
'Regular Events: 2 General Admission tickets discounted  to 100%
'All Events:     Unlimited General Admission tickets discounted down to the same price as the Membership Ticket for the event


'2015 Filmmaker
'------------
'Regular Events: 4 General Admission tickets discounted  to 100%
'All Events:     Unlimited General Admission tickets discounted down to the same price as the Membership Ticket for the event


'2015 Sponsor
'------------
'Regular Events: 6 General Admission tickets discounted  to 100%
'Opening Night:  2 General Admission tickets discounted  to 100% for this event.
'All Events:     Unlimited General Admission tickets discounted down to the same price as the Membership Ticket for the event


'2015 Patron
'------------
'Regular Events: 8 General Admission tickets discounted  to 100%
'Opening Night:  2 General Admission tickets discounted  to 100% for this event.
'Closing Night:  2 General Admission tickets discounted  to 100% for this event.
'All Events:     Unlimited General Admission tickets discounted down to the same price as the Membership Ticket for the event


'2015 Benefactor
'------------
'Regular Events:    10 General Admission tickets discounted  to 100%
'Opening VIP Night: 2 General  Admission tickets discounted  to 100% for this event.
'Closing Night:     2 General  Admission tickets discounted  to 100% for this event.
'All Events:        Unlimited  General Admission tickets discounted down to the same price as the Membership Ticket for the event


'2015 VIP All-Access Pass
'------------
'Regular Events:	Unlimited General Admission ticket discounted  to 100% per event. Maximum 1 ticket per event.
'Opening VIP: 		1 General Admission ticket discounted  to 100% for this event.
'Closing Night:  	1 General Admission ticket discounted  to 100% for this event.
'All Events:        Unlimited  General Admission tickets discounted down to the same price as the Membership Ticket for the event


'2015 Festival Guest
'------------
'Regular Events:	15 General Admission ticket discounted  to 100% per event. Maximum 1 ticket per event.
'Opening Night:  	1 General Admission ticket discounted   to 100% for this event.
'Closing Night:  	1 General Admission ticket discounted   to 100% for this event.
'All Events:        Unlimited  General Admission tickets discounted down to the same price as the Membership Ticket for the event

					
'============================================================

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%


DIM RequiredSeatType
RequiredSeatType = "42850" 'General Admission 

DIM MemberSeatCode 
MemberSeatCode  = "42843" 'Membership (w/ ID)

DIM VIPEvent 
VIPEvent  = "731756" 'VIP Opening Night

DIM OpenEvent
OpenEvent = "731757" 'Opening Night

DIM CloseEvent
CloseEvent = "731758" 'Closing Night

DIM WeekEvent
WeekEvent = "745608" 'C3 Weekend Pass

DIM ItemNumberList 'Donation Item Numbers
ItemNumberList = "4874,4875,4876,4877,4878,4879,4924,4925" 'SUPPORTER, FRIEND, FILMMAKER, SPONSOR, PATRON, BENEFACTOR, VIP ALL-ACCESS, FESTIVAL GUEST

DIM CustomerNumber
CustomerNumber = fnCustomerNumber

If CustomerNumber = 1 Then
AllowDiscount = "N"
End If

DIM AddDisc
AddDisc	= FALSE

DIM MemberDisc
MemberDisc = FALSE

DIM RegularCount
DIM SingleCount
DIM VIPCount 
DIM OpenCount
DIM CloseCount 

RegularCount 	= 0
SingleCount 	= 0
VIPCount  		= 0
OpenCount 		= 0
CloseCount  	= 0


'---------------------------------------------------------

If AllowDiscount = "Y" Then 'It's okay to apply to this order.

	'ErrorLog("CustomerNumber: " & CustomerNumber & "")

	SQLMemberCurrent = "SELECT OrderLine.ItemNumber FROM OrderLine WITH (NOLOCK) INNER JOIN OrderHeader WITH (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE OrderLine.ItemNumber IN (" & ItemNumberList & ") AND ((OrderHeader.OrderNumber <> " & OrderNumber & " AND OrderLine.StatusCode = 'S' AND OrderHeader.CustomerNumber = " & CustomerNumber & ") OR OrderHeader.OrderNumber = " & OrderNumber & ")"
	Set rsMemberCurrent = OBJdbConnection.Execute(SQLMemberCurrent)

		If Not rsMemberCurrent.EOF Then

			Do While Not rsMemberCurrent.EOF
	   
				Select Case rsMemberCurrent("ItemNumber")
				'VIP ALL-ACCESS
				Case 4924
					'ErrorLog("VIP ALL-ACCESS")
					SingleCount 	= SingleCount 	+ 1 
					VIPCount 		= VIPCount		+ 1
					CloseCount 		= CloseCount 	+ 1 
					AddDisc			= TRUE
					MemberDisc		= TRUE
				'FESTIVAL GUEST
				Case 4925	
					'ErrorLog("FESTIVAL GUEST")
					SingleCount 	= SingleCount 	+ 1 
					OpenCount 		= OpenCount 	+ 1
					CloseCount 		= CloseCount 	+ 1
					AddDisc			= TRUE
					MaxDisc			= TRUE
					MemberDisc		= TRUE
				'SUPPORTER
				Case 4874
					'ErrorLog("SUPPORTER")
					RegularCount	= RegularCount 	+ 0
					NoCount 		= NoCount 		+ 1 
					AddDisc			= TRUE
					MemberDisc		= TRUE
				'FRIEND
				Case 4875	
					'ErrorLog("FRIEND")
					RegularCount 	= RegularCount 	+ 2 
					AddDisc			= TRUE
					MemberDisc		= TRUE
				'FILMMAKER
				Case 4876
					'ErrorLog("FILMMAKER")				
					RegularCount 	= RegularCount 	+ 4
					AddDisc			= TRUE
					MemberDisc		= TRUE
				'SPONSOR
				Case 4877	
					'ErrorLog("SPONSOR")
					RegularCount 	= RegularCount 	+ 6
					OpenCount 		= OpenCount 	+ 2
					AddDisc			= TRUE
					MemberDisc		= TRUE
				'PATRON
				Case 4878	
					'ErrorLog("PATRON")
					RegularCount 	= RegularCount 	+ 8
					OpenCount 		= OpenCount 	+ 2
					CloseCount 		= CloseCount 	+ 2
					AddDisc			= TRUE
					MemberDisc		= TRUE
				'BENEFACTOR
				Case 4879	
					'ErrorLog("BENEFACTOR")
					RegularCount 	= RegularCount 	+ 10 
					VIPCount 		= VIPCount		+ 2 
					CloseCount 		= CloseCount 	+ 2 
					AddDisc			= TRUE
					MemberDisc		= TRUE
				End Select
				 
			rsMemberCurrent.MoveNext	
			Loop
				
		End If
		
	rsMemberCurrent.Close
	Set rsMemberCurrent = nothing
	
	'ErrorLog("SingleCount: " & SingleCount & "")
	'ErrorLog("RegularCount: " & RegularCount & "")
	'ErrorLog("VIPCount: " & VIPCount  & "")
	'ErrorLog("CloseCount: " & CloseCount  & "")
	'ErrorLog("OpenCount: " & OpenCount  & "")
	'ErrorLog("AddDisc: " & AddDisc & "")
	'ErrorLog("MemberDisc: " & MemberDisc & "")

	'---------------------------------------------------------
	
	'Give MemberPrice Discount
	
	If MemberDisc Then

		NewPrice = fnMemberPrice

	End If

	'---------------------------------------------------------
	
	'Process Free and Discounted Regular Event Tickets (unlimited discounted tickets per event)
	
	If RegularCount > 0 Then
	
		'ErrorLog("AddDisc True? process reg disc" & AddDisc & "")
			
		SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader WITH (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderHeader.CustomerNumber = " & CustomerNumber & " AND Seat.EventCode NOT IN (" & VIPEvent & "," & OpenEvent & "," & CloseEvent &") AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.Price=OrderLine.Discount"
		Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
			
			If NOT rsDiscCount.EOF	Then
							
				If EventCode <> VIPEvent AND EventCode <> OpenEvent AND EventCode <> CloseEvent AND EventCode <> WeekEvent Then
				
					If Int(rsDiscCount("LineCount")) < Int(RegularCount) Then 
							'ErrorLog("RegularCount less then 0?: " & RegularCount & "")
							NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Clean(Request("Percentage")))/100), 2)
					Else
						If AddDisc Then
							'ErrorLog("Is AddDisc True? give memberprice " & AddDisc & "")
							NewPrice = fnMemberPrice
						End If
					End If	
					
				End If
				
			End If
			
		rsDiscCount.Close
		Set rsDiscCount = nothing
			
	End If
	
	'---------------------------------------------------------
	
	'Process Free and Discounted Regular Event Tickets (1 discounted ticket per event)
	
	If SingleCount > 0 Then
	
		DIM DiscAllowed
		DiscAllowed = TRUE
	
		SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader WITH (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderHeader.CustomerNumber = " & CustomerNumber & " AND Seat.EventCode NOT IN (" & VIPEvent & "," & OpenEvent & "," & CloseEvent &") AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.Price=OrderLine.Discount"
		Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
			TotalDisc = rsDiscCount("LineCount")
		rsDiscCount.Close
		Set rsDiscCount = nothing
		
		If MaxDisc Then
			'ErrorLog("MaxDisc: " & MaxDisc & "")
			If TotalDisc < 15 Then
				DiscAllowed = TRUE
				'ErrorLog("TotalDisc: " & TotalDisc & " less than 15 - Allowed? " & DiscAllowed & "")
			Else
				DiscAllowed = FALSE
				'ErrorLog("TotalDisc: " & TotalDisc & " greater than 15 - Allowed? " & DiscAllowed & "")
			End If
		End If
		
		If DiscAllowed Then
	
			SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader WITH (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderHeader.CustomerNumber = " & CustomerNumber & " AND Seat.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.Price=OrderLine.Discount"
			Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
				
				If NOT rsDiscCount.EOF	Then
								
					If EventCode <> VIPEvent AND EventCode <> OpenEvent AND EventCode <> CloseEvent AND EventCode <> WeekEvent Then
					
						If Int(rsDiscCount("LineCount")) < Int(SingleCount) Then 
								NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Clean(Request("Percentage")))/100), 2)
						Else
								NewPrice = fnMemberPrice
						End If
						
					End If
					
				End If
				
			rsDiscCount.Close
			Set rsDiscCount = nothing
			
		End If
		
	End If
	
	'---------------------------------------------------------

	'Process Free and Discounted Opening Event Tickets
	
	If OpenCount > 0 Then

		SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader WITH (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderHeader.CustomerNumber = " & CustomerNumber & " AND Seat.EventCode = " & OpenEvent & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.Price=OrderLine.Discount"
		Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
			
			If NOT rsDiscCount.EOF	Then
		
				If EventCode = OpenEvent Then

					If Int(rsDiscCount("LineCount")) < Int(OpenCount) Then 
						NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Clean(Request("Percentage")))/100), 2)
					Else
						If AddDisc Then
							NewPrice = fnMemberPrice
						End If
					End If	
				
				End If
				
			End If

		rsDiscCount.Close
		Set rsDiscCount = nothing
		
	End If
	
	'---------------------------------------------------------

	'Process Free and Discounted Closing Tickets
	
	If CloseCount > 0 Then

		SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader WITH (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderHeader.CustomerNumber = " & CustomerNumber & " AND Seat.EventCode = " & CloseEvent & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.Price=OrderLine.Discount"
		Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
			
			If NOT rsDiscCount.EOF	Then
		
				If EventCode = CloseEvent Then

					If Int(rsDiscCount("LineCount")) < Int(CloseCount) Then 
						NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Clean(Request("Percentage")))/100), 2)
					Else
						If AddDisc Then
							NewPrice = fnMemberPrice
						End If
					End If	
				
				End If
				
			End If

		rsDiscCount.Close
		Set rsDiscCount = nothing
		
	End If
	
	'---------------------------------------------------------
	
	'Process Free and Discounted VIP Tickets

		SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader WITH (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderHeader.CustomerNumber = " & CustomerNumber & " AND Seat.EventCode = " & VIPEvent & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.Price=OrderLine.Discount"
		Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
			
			If NOT rsDiscCount.EOF	Then
		
				If EventCode = VIPEvent Then

					If Int(rsDiscCount("LineCount")) < Int(VIPCount) Then 
						NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Clean(Request("Percentage")))/100), 2)
					Else
						If AddDisc Then
							NewPrice = fnMemberPrice
						End If
					End If	
				
				End If
				
			End If

		rsDiscCount.Close
		Set rsDiscCount = nothing

	'---------------------------------------------------------
		
	If Price > NewPrice Then
	
		If NewPrice < 0 Then
			NewPrice = 0
		End If
	
		DiscountAmount = Round(Clean(Request("Price")),2) - NewPrice
		
		If NewPrice = 0 Then
			Surcharge = 0
		ElseIf Request("CalcServiceFee") <> "N" Then
			Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
		End If
		
		AppliedFlag = "Y"
	
	End If


End If
	
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

'---------------------------------------------------------

Public Function fnCustomerNumber

	DIM strResults

	If Request("CustomerNumber") = "" Then 
		SQLOrderCustomer = "SELECT CustomerNumber FROM OrderHeader (NOLOCK) WHERE OrderNumber = " & OrderNumber
		Set rsOrderCustomer = OBJdbConnection.Execute(SQLOrderCustomer)
			If Not rsOrderCustomer.EOF Then
				strResults = rsOrderCustomer("CustomerNumber")
			End If
		rsOrderCustomer.Close
		Set rsOrderCustomer = nothing
	Else
		strResults = CleanNumeric(Request("CustomerNumber"))
	End If
	
	fnCustomerNumber = strResults

End Function

'---------------------------------------------------------

Public Function fnMemberPrice

	DIM strResults

	SQLMemberPrice = "SELECT Price FROM Price(NOLOCK) WHERE Price.EventCode = " & EventCode & " AND Price.SeatTypeCode = " & MemberSeatCode & ""
	Set rsMemberPrice  = OBJdbConnection.Execute(SQLMemberPrice )
		strResults = rsMemberPrice("Price")
		ErrorLog("MemberPrice: " & 	strResults & "")
	rsMemberPrice.Close
	Set rsMemberPrice = nothing
	
	fnMemberPrice = strResults 
	

End Function

'---------------------------------------------------------

%>