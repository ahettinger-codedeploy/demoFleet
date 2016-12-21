<%

'CHANGE LOG
'SSR - 02/19/16 - Created discount script
'SSR - 02/22/16 - Added Exp date


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

'VALID EVENTS
'VIP Opening Night: 			844779
'Opening Night: 				843591
'Centerpiece Presentation: 		843588
'Closing Night: 				843877
'Regular Events				All Others
'Excluded Events:				840008

'Benefits Start:  			02/19/2016
'Benefits Expire: 			04/15/2016

'Additional ticket discounts: 
'Purchasing additional memberships will increase the number of discounted tickets allowed.

'Supporter
'------------
'All Events:    Unlimited general admission tickets discounted down to the membership price
 
'Friend
'------------
'Regular Events: 2 general admission tickets discounted by 100%
'All Events:     Unlimited general admission tickets discounted down to the membership price
 
 
'Filmmaker
'------------
'Regular Events: 4 general admission tickets discounted by 100%
'All Events:     Unlimited general admission tickets discounted down to the membership price
 
 
'Sponsor
'------------
'Regular Events: 6 general admission tickets discounted by 100%
'Opening Night:  2 general admission tickets discounted by 100%
'All Events:     Unlimited general admission tickets discounted down to the membership price
 
  
'Patron
'------------
'Regular Events: 8 general admission tickets discounted by 100%
'Opening Night:  2 general admission tickets discounted by 100%
'Closing Night:  2 general admission tickets discounted by 100%
'All Events:     Unlimited general admission tickets discounted down to the membership price
 
 
'Benefactor
'------------
'Regular Events:    10 general admission tickets discounted by 100%
'Opening VIP Night: 2 general admission tickets discounted by 100%
'Closing Night:     2 general admission tickets discounted by 100%
'All Events:        Unlimited general admission tickets discounted down to the membership price
 
 
'VIP All-Access Pass
'------------
'All Events:        1 general admission ticket discounted  to 100% for each event (except Regular Opening Night Event)


'Festival Guest
'------------
'Regular Events:	15 general admission tickets discounted by 100%. Maximum 1 ticket per event.
'Opening Night:  	1  general admission ticket  discounted by 100% for this event.
'Closing Night:  	1  general admission ticket  discounted by 100% for this event.

					
'============================================================

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%


'Date when membership benefits expire
DIM ExpirationDate
ExpirationDate = "04/15/2016"

DIM RequiredSeatType
RequiredSeatType = "42850" 'General Admission 

DIM MemberSeatCode 
MemberSeatCode  = "42843" 'Membership (w/ ID)

DIM VIPEvent 
VIPEvent  = "844779" 'VIP Opening Night

DIM OpenEvent
OpenEvent = "843591" 'Opening Night

DIM CloseEvent
CloseEvent = "843818" 'Closing Night

DIM CenterEvent
CenterEvent = "843588" 'Centerpiece Presentation

'Membership Item Numbers
'FESTIVAL GUEST, VIP ALL ACCESS PASS, BENEFACTOR, PATRON, SPONSOR, FILMMAKER, FRIEND, SUPPORTER
DIM ItemNumberList 
ItemNumberList = "5248,5247,5245,5243,5241,5240,5239,5238" 

DIM CustomerNumber

DIM AddDisc
AddDisc	= FALSE

'Determines if this membership level
'get the lower member pricing on GA tickets
'default is no
DIM MemberDisc
MemberDisc = FALSE

'Determines the number of
'free regular tickets allowed
DIM RegularCount
RegularCount 	= 0

'Determines the number of
'free regular tickets allowed
'1 ticket per event
DIM Regular1Count
Regular1Count 	= 0

'Determines the number of
'free VIP Opening Night tickets allowed
DIM VIPCount 
VIPCount  		= 0

'Determines the number of
'free Opening Night tickets allowed
DIM OpenCount
OpenCount 		= 0

'Determines the number of
'free Closing Night tickets allowed
DIM CloseCount 
CloseCount  	= 0

'Determines the number of
'free Center Night tickets allowed
DIM CenterCount 
CenterCount   	= 0


DIM SeriesPercentage
SeriesPercentage	= 	100

'---------------------------------------------------------

	'Determine Customer Number

	CustomerNumber = fnCustomerNumber

	If CustomerNumber = 1 Then
		AllowDiscount = "N"
	End If

'---------------------------------------------------------

	'Expiration Date Check
	'Determine the original date of the order
	'this allows re-opened orders to receive the correct discount
	'if re-opened after the original discount expiration date
	'Expiration Date Format: 08/16/2010 OR 08/16/2010 15:00:00

	SQLDateCheck = "SELECT OrderHeader.OrderDate FROM OrderHeader (NOLOCK) WHERE OrderHeader.OrderNumber = " & OrderNumber & ""
	Set rsDateCheck = OBJdbConnection.Execute(SQLDateCheck)
		OriginalDate = rsDateCheck("OrderDate")
	rsDateCheck.Close
	Set rsDateCheck = nothing

	If CDate(OriginalDate) < CDate(ExpirationDate) Then  
		AllowDiscount = "Y"
	Else
		AllowDiscount = "N"
	End If
		
'---------------------------------------------------------

If AllowDiscount = "Y" Then 'It's okay to apply to this order.

	'ErrorLog("CustomerNumber: " & CustomerNumber & "")

	SQLMemberCurrent = "SELECT OrderLine.ItemNumber FROM OrderLine WITH (NOLOCK) INNER JOIN OrderHeader WITH (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE OrderLine.ItemNumber IN (" & ItemNumberList & ") AND ((OrderHeader.OrderNumber <> " & OrderNumber & " AND OrderLine.StatusCode = 'S' AND OrderHeader.CustomerNumber = " & CustomerNumber & ") OR OrderHeader.OrderNumber = " & OrderNumber & ")"
	Set rsMemberCurrent = OBJdbConnection.Execute(SQLMemberCurrent)

		If Not rsMemberCurrent.EOF Then

			Do While Not rsMemberCurrent.EOF
	   
				Select Case rsMemberCurrent("ItemNumber")

				'SUPPORTER
				Case 5238
					'ErrorLog("SUPPORTER")
					AddDisc		= TRUE
					MemberDisc		= TRUE
					
				'FRIEND
				Case 5239	
					'ErrorLog("FRIEND")
					RegularCount 	= RegularCount 	+ 2 
					AddDisc			= TRUE
					MemberDisc		= TRUE
					
				'FILMMAKER
				Case 5240
					'ErrorLog("FILMMAKER")				
					RegularCount 	= RegularCount 	+ 4
					AddDisc			= TRUE
					MemberDisc		= TRUE
					
				'SPONSOR
				Case 5241	
					'ErrorLog("SPONSOR")
					RegularCount 	= RegularCount 	+ 6
					OpenCount 		= OpenCount 	+ 2
					AddDisc			= TRUE
					MemberDisc		= TRUE
					
				'PATRON
				Case 5243	
					'ErrorLog("PATRON")
					RegularCount 	= RegularCount 	+ 8
					OpenCount 		= OpenCount 	+ 2
					CloseCount 		= CloseCount 	+ 2
					AddDisc			= TRUE
					MemberDisc		= TRUE
				
				'BENEFACTOR
				Case 5245	
					'ErrorLog("BENEFACTOR")
					RegularCount 	= RegularCount 	+ 10 
					VIPCount 		= VIPCount		+ 2 
					CloseCount 		= CloseCount 	+ 2 
					AddDisc			= TRUE
					MemberDisc		= TRUE
					
				'VIP ALL-ACCESS
				Case 5247
					'ErrorLog("VIP ALL-ACCESS")
					Regular1Count 	= Regular1Count + 1 
					VIPCount 		= VIPCount		+ 1
					CloseCount 		= CloseCount 	+ 1 
					AddDisc			= TRUE
					MemberDisc		= TRUE
					
				'FESTIVAL GUEST
				Case 5248	
					'ErrorLog("FESTIVAL GUEST")
					RegularCount	= RegularCount 	+ 15
					Regular1Count 	= Regular1Count   + 1 
					OpenCount 		= OpenCount 	+ 1
					CloseCount 		= CloseCount 	+ 1
					CenterCount 	= CenterCount 	+ 1
					AddDisc			= TRUE
					MaxDisc			= TRUE
					MemberDisc		= TRUE
					
				End Select
				 
			rsMemberCurrent.MoveNext	
			Loop
				
		End If
		
	rsMemberCurrent.Close
	Set rsMemberCurrent = nothing
	
	'ErrorLog("Regular1Count: " & Regular1Count & "")
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
	
		''ErrorLog("AddDisc True? process reg disc" & AddDisc & "")
			
		SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader WITH (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderHeader.CustomerNumber = " & CustomerNumber & " AND Seat.EventCode NOT IN (" & VIPEvent & "," & OpenEvent & "," & CloseEvent &"," & CenterEvent &") AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.Price=OrderLine.Discount"
		Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
			
			If NOT rsDiscCount.EOF	Then
							
				If EventCode <> VIPEvent AND EventCode <> OpenEvent AND EventCode <> CloseEvent AND EventCode <> CenterEvent Then
				
					If Int(rsDiscCount("LineCount")) < Int(RegularCount) Then 
							'ErrorLog("RegularCount less then 0?: " & RegularCount & "")
							NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(SeriesPercentage)/100), 2)	
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
	
	If Regular1Count > 0 Then
	
		DIM DiscAllowed
		DiscAllowed = TRUE
	
		SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader WITH (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderHeader.CustomerNumber = " & CustomerNumber & " AND Seat.EventCode NOT IN (" & VIPEvent & "," & OpenEvent & "," & CloseEvent &") AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.Price=OrderLine.Discount"
		Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
			TotalDisc = rsDiscCount("LineCount")
		rsDiscCount.Close
		Set rsDiscCount = nothing
		
		If MaxDisc Then
			''ErrorLog("MaxDisc: " & MaxDisc & "")
			If TotalDisc < 15 Then
				DiscAllowed = TRUE
				''ErrorLog("TotalDisc: " & TotalDisc & " less than 15 - Allowed? " & DiscAllowed & "")
			Else
				DiscAllowed = FALSE
				''ErrorLog("TotalDisc: " & TotalDisc & " greater than 15 - Allowed? " & DiscAllowed & "")
			End If
		End If
		
		If DiscAllowed Then
	
			SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader WITH (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderHeader.CustomerNumber = " & CustomerNumber & " AND Seat.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.Price=OrderLine.Discount"
			Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
				
				If NOT rsDiscCount.EOF	Then
								
					If EventCode <> VIPEvent AND EventCode <> OpenEvent AND EventCode <> CloseEvent AND EventCode <> CenterEvent Then
					
						If Int(rsDiscCount("LineCount")) < Int(Regular1Count) Then 
								NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(SeriesPercentage)/100), 2)	
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
						NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(SeriesPercentage)/100), 2)	
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
						NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(SeriesPercentage)/100), 2)	
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
						NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(SeriesPercentage)/100), 2)	
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
		'ErrorLog("MemberPrice: " & 	strResults & "")
	rsMemberPrice.Close
	Set rsMemberPrice = nothing
	
	fnMemberPrice = strResults 
	

End Function

'---------------------------------------------------------

%>