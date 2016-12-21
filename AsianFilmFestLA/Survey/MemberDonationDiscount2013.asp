<%

'CHANGE LOG - Inception
'SSR 4/06/2011
'TTT 4/03/2012 - Revised for 2012 Member Donations
'TTT 4/17/2012 - Excluded VIP tix count from past discounted tix and only to those attached to the right DiscountTypeNumber
'TTT 4/27/2012 - Applied COMP/Fixed discount to VIP Tickets to Opening Night and accounted two discounted tickets per subscription event ticket
'JAI 5/03/2012 - Added Expiration Date for Internet orders.
'SSR 3/01/2013 - Revised for 2013 Festival
'SSR 3/14/2013 - Updated/Added Membership Benefits
'SSR 4/01/2013 - Updated discount pricing and exp date

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->

<%

'-----------------------------------------------------------------

Page = "Survey"
SurveyNumber = 1433
SurveyFileName = "MemberDonationDiscount2013.asp"

'Survey variables

If Session("UserNumber")<> "" Then
    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "FFFFFF"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "000000"
    TableDataBGColor = "E9E9E9"
    ClientFolder= "Tix"
Else
    ClientFolder = "asianfilmfestla"
End If

'============================================================

'Visual Communiations - Asian Film Festival

'2013 Membership Based Ticket Discount

'The purchase of a valid membership/donation level entitles the patron to a set number of discounted tickets for specific events
'Membership/Donation levels are available for both internet and box office orders
'Only membership/donations entered after 2/26/2013 qualify patrons for ticket discounts.
 
'Ticket discounts are available for both internet and box office orders
'Ticket discounts are calculated automatically on the final payment page
'Ticket fees are not re-calcuated on discounted tickets
'Ticket discounts expire after 4/16/13



'Donation Levels / Amounts

'#		Desc		Amount
'-----  ----------  ------------
'4105	SUPPORTER	 60.00
'4106	FRIEND		 60.00
'4107	FILMMAKER	 100.0000	
'4108	SPONSOR		 250.0000						
'4109	PATRON		 500.0000						
'4110	BENEFACTOR	1000.0000						
'4111	DIRECTOR	2500.0000
'4140	VIP			Open
'4141	GUEST		Open  
'4142	DONATION	Open
 
  
'2013 Ticket Discounts by Donation Level 
 
'Supporter
'------------
'unlimited number of discounted tickets to any event

'Friend
'------------
'unlimited number of discounted tickets to any event
'2 free tickets (not valid for Opening, Opening VIP & Closing  events)


'Filmmaker
'------------
'unlimited number of discounted tickets to any event
'4 free tickets (not valid for Opening, Opening VIP & Closing  events)


'Sponsor
'------------
'unlimited number of discounted tickets to any event
'6 free tickets (not valid for Opening, Opening VIP & Closing  events)
'2 free tickets to Opening event  ( Event 541594 or 541593 )


'Patron
'------------
'unlimited number of discounted tickets to any event
'8 free tickets (not valid for Opening, Opening VIP & Closing  events)
'2 free tickets to Opening event ( Event 541594 or 541593 )
'2 free tickets to Closing event ( Event 541595 )


'Benefactor
'------------
'unlimited number of discounted tickets to any event
'10 free tickets (not valid for Opening, Opening VIP & Closing  events)
'2 free tickets to Opening VIP event ( Event 541592 )
'2 free tickets to Closing event( Event 541595 )


'Director
'------------
'unlimited number of discounted tickets


'VIP All-Access Pass
'----------------------
'unlimited number of discounted tickets to any event
'1 free ticket to each event (not valid for Opening events)
'1 free ticket to Opening VIP event 
'1 free ticket to the Closing event


'Festival Guest
'----------------------
'unlimited number of discounted tickets to any event
'1 free ticket to each event (15 ticket limit, not valid for Opening VIP)
'1 free ticket to Opening event (Event 541594 or 541593)
'1 free ticket to Closing event (Event 541595)


'Donation
'----------------------
'None


'Member Discounts:
'-------------------

'Valid Ticket type: 
'General Admission (Ticket Type 564) 

'Discount for Regular Screenings
	'Regular Price:	$13.00 
		'New Price:	$11.00

'Discount for Panels
	'Regular Price: $15.00 
		'New Price:	$12.00

'Discount for Opening Night VIP
	'Regular Price: $100.00 
		'New Price:	$75.00

'Discount for Opening Night
	'Regualr Price: $50.00
		'New Price: $45.00

'Discount for Closing Night
	'Regular Price: $40.00
		'New Price: $35.00

							
'============================================================

OnlineExpirationDate = CDate("4/16/13")

'2013 Member Discount
DiscountTypeNumber = 78243 

'Membership Levels 
ItemNumberList = "4105,4106,4107,4108,4109,4110,4111,4140,4141,4142"

'Closing Night Events
CloseEventList = "541595"

'Opening Night Events
OpenEventList = "541593,541594"

'Opening VIP Night Events
OpenVIPList = "541592"

'Panels
PanelList = "545789,545791,545794,546868,545806,545807"


'-----------------------------------------------------------------


'Survey Start. 
'Check to see if Order Number exists.
'Skip Survey if Comp Order
'Request the form name and process requested action

If Session("OrderNumber") = "" Then

	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
    Else
		Response.Redirect("/Management/Default.asp")
	End If
	
Else

	If Session("UserNumber") = "" Then
        Page = "Survey"
	Else
	    Page = "Management"
	End If
	
End If

If Session("OrderTypeNumber") = 5 Then
	Call Continue
End If


Select Case Clean(Request("FormName"))
    Case "Continue"
        Call Continue
    Case Else
        If Session("OrderTypeNumber") = 1 And Now() > OnlineExpirationDate Then
            Call Continue
        Else
            Call MemberCheck
        End If
 End Select
 

OBJdbConnection.Close
Set OBJdbConnection = nothing

'-----------------------------------------------------------------

Sub MemberCheck

DonationFound = False

'ErrorLog("ItemNumberList "&ItemNumberList&" ")

'ErrorLog("CustomerNumber "& CleanNumeric(Session("CustomerNumber")) &" ")

'Check for donations in current order
SQLMemberCurrent = "SELECT OrderLine.ItemNumber FROM OrderLine (NOLOCK) WHERE OrderLine.ItemNumber IN (" & ItemNumberList & ") AND OrderLine.OrderNumber = " & CleanNumeric(Session("OrderNumber"))
Set rsMemberCurrent = OBJdbConnection.Execute(SQLMemberCurrent)
If Not rsMemberCurrent.EOF Then 'it is in order
    DonationFound = True
End If
rsMemberCurrent.Close
Set rsMemberCurrent = nothing


'Check for donations in past orders
SQLMemberPrevious = "SELECT OrderLine.ItemNumber FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE CustomerNumber = " & CleanNumeric(Session("CustomerNumber")) & " AND OrderLine.ItemNumber IN (" & ItemNumberList & ") AND OrderHeader.StatusCode = 'S' ORDER BY OrderLine.ItemNumber"
Set rsMemberPrevious = OBJdbConnection.Execute(SQLMemberPrevious)
If Not rsMemberPrevious.EOF Then
    DonationFound = True
End If
rsMemberPrevious.Close
Set rsMemberPrevious = nothing

''ErrorLog("DonationFound "&DonationFound&" ")

If DonationFound Then 
	Call ApplyFree
Else
	Call Continue
End If

End Sub 'MemberCheck

'-----------------------------------------------------------------

Sub ApplyFree	

	Dim ItemNo, FreeTicketCount, AllowedTicketCount, AppliedTicketCount, AvailableTicketCount

	ItemNo 					= "" 
	FreeTicketCount 		= 0
	AllowedTicketCount 		= 0    'Total number of free tickets allowed
	AllowedSingleCount 		= 0    'Total number of free single tickets allowed
	AllowedActCount	 		= 0    'Total number of free tickets allowed per production
	AppliedTicketCount 		= 0    'Number of free tickets already given
	AvailableTicketCount 	= 0    'Number of free tickets available for this order

	'Remove other discounts from this order
	SQLDiscLine = "SELECT LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.ItemType IN ('Seat','SubFixedEvent') ORDER BY LineNumber"
	Set rsDiscLine = OBJdbConnection.Execute(SQLDiscLine)

	If Not rsDiscLine.EOF Then
		Do While Not rsDiscLine.EOF
		
			SQLClearDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = 0, DiscountTypeNumber = 0 WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsDiscLine("LineNumber")
			Set rsClearDiscount = OBJdbConnection.Execute(SQLClearDiscount)
			
		rsDiscLine.movenext
		Loop
	End If

	rsDiscLine.Close
	Set rsDiscLine = Nothing  


	Count = 0
	OpeningCount = 0
	OpeningVIPCount = 0
	ClosingCount = 0
	SingleCount = 0
	UnlimitedCount = 0

	SQLFreeTickets  = "SELECT OrderLine.ItemNumber FROM OrderHeader (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber WHERE (OrderLine.ItemNumber IN (" & ItemNumberList & ")) AND (CustomerNumber = " & Session("CustomerNumber") & " AND OrderHeader.StatusCode = 'S' OR OrderHeader.OrderNumber = " & Session("OrderNumber") & ") ORDER BY LineNumber"
	Set rsFreeTickets   = OBJdbConnection.Execute(SQLFreeTickets)

	If Not rsFreeTickets.EOF Then
		Do While Not rsFreeTickets.EOF
				   
			Select Case rsFreeTickets("ItemNumber")
			Case 4105	'SUPPORTER
				Count = 0
			Case 4106	'FRIEND
				Count = 2 
			Case 4107	'FILMMAKER
				Count = 4
			Case 4108	'SPONSOR
				Count = 6
				OpeningCount = 2
			Case 4109	'PATRON
				Count = 8
				OpeningCount = 2
				ClosingCount = 2 
			Case 4110	'BENEFACTOR
				Count = 10 
				OpeningVIPCount = 2 
				ClosingCount = 2 
			Case 4111	'DIRECTOR
				Count = 0
			Case 4140	'VIP ALL ACCESS PASS
				ActCount = 1
				OpeningVIPCount = 1
				ClosingCount = 1
			Case 4141 'FESTIVAL GUEST
				SingleCount = 1
				OpeningCount = 1
				ClosingCount = 1 
			End Select
			 
			AllowedTicketCount = AllowedTicketCount + Count   
			AllowedActCount = AllowedActCount + ActCount  
			AllowedSingleCount = AllowedSingleCount + SingleCount  
			
			CustomerOpeningCount = CustomerOpeningCount + OpeningCount
			CustomerOpeningVIPCount = CustomerOpeningVIPCount + OpeningVIPCount
			CustomerClosingCount = CustomerClosingCount + ClosingCount

			ItemNo = rsFreeTickets("ItemNumber")
			rsFreeTickets.movenext
			
		Loop
			
	End If

	rsFreeTickets.Close
	Set rsFreeTickets = Nothing  

	''ErrorLog(" AllowedTicketCount "&AllowedTicketCount&" ")

	'Determine number of free regular tickets already given
	SQLApplied = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderHeader.CustomerNumber = " & Session("CustomerNumber") & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.StatusCode = 'S' AND OrderLine.ItemType IN ('Seat', 'SubSeat') AND Seat.EventCode NOT IN (" & CloseEventList & "," & OpenEventList & "," & OpenVIPList & ") AND Seat.EventCode IN (SELECT EventCode FROM DiscountEvents (NOLOCK) WHERE DiscountTypeNumber = " & DiscountTypeNumber & ")"
	Set rsApplied = OBJdbConnection.Execute(SQLApplied)
	AppliedTicketCount = rsApplied("TicketCount")
	rsApplied.Close
	Set rsApplied = nothing

	''ErrorLog(" AppliedTicketCount "&AppliedTicketCount&" ")
		
	'Determine number of free tickets left
	AvailableTicketCount = (AllowedTicketCount - AppliedTicketCount)

	''ErrorLog(" AvailableTicketCount "&AvailableTicketCount&" ")


	If CInt(AvailableTicketCount) > 0 Then 'it is okay to give free tickets 

		SQLLineNo = "SELECT TOP(" & AvailableTicketCount & ") LineNumber, OrderLine.ItemType FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN EVENT (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.ItemType IN ('Seat','SubFixedEvent') AND Event.EventCode NOT IN (" & CloseEventList & "," & OpenEventList & "," & OpenVIPList & ") ORDER BY OrderLine.Price DESC"
		Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)
		If Not rsLineNo.EOF Then
			Do While Not rsLineNo.EOF And AvailableTicketCount > 0
				SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = Price, DiscountTypeNumber = " & DiscountTypeNumber & ", Surcharge = 0  WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber")
				Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
				FreeTicketCount = FreeTicketCount+ 1
				AvailableTicketCount = AvailableTicketCount - 1
				rsLineNo.movenext
			Loop
		End If
		rsLineNo.Close
		Set rsLineNo = Nothing 
				
	End If
  
  
  
If CustomerOpeningVIPCount > 0 Then
    Call ApplyOpenVIPFree(CustomerOpeningVIPCount)
End If

  
If CustomerOpeningCount > 0 Then
    Call ApplyOpenFree(CustomerOpeningCount)
End If


If CustomerClosingCount > 0 Then
    Call ApplyCloseFree(CustomerClosingCount)
End If


If AllowedSingleCount > 0 Then
    Call ApplySingleFree(AllowedSingleCount)
End If


If AllowedActCount > 0 Then
    Call ApplyActFree(AllowedActCount)
End If


Call ApplyDiscount(FreeTicketCount)


Call Continue


End Sub 'ApplyDiscount

'-----------------------------------------------------------------

Sub ApplyOpenVIPFree(CustomerOpeningVIPCount)

			EventList 	= 	OpenVIPList			'List of Opening Night VIP Events
  AllowedTicketCount 	= 	CustomerOpeningVIPCount    	'Total number of tickets allowed
  AppliedTicketCount 	= 	0           				'Number of tickets already discounted
AvailableTicketCount 	= 	0           				'Number of tickets available for discounting


'Determine number of tickets already discounted
SQLApplied = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderHeader.CustomerNumber = " & Session("CustomerNumber") & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.StatusCode = 'S' AND Seat.EventCode IN (" & EventList & ")"
Set rsApplied = OBJdbConnection.Execute(SQLApplied)
AppliedTicketCount= rsApplied("TicketCount")
rsApplied.Close
Set rsApplied = nothing


'Determine number of tickets left
AvailableTicketCount = (AllowedTicketCount - AppliedTicketCount)
               

'Process ticket discounts			   
If CInt(AvailableTicketCount) > 0 Then 

    SQLLineNo = "SELECT TOP(" & AvailableTicketCount & ") LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN EVENT (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Seat.EventCode IN (" & EventList & ") ORDER BY OrderLine.Price DESC"
    Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)
    If Not rsLineNo.EOF Then
        Do While Not rsLineNo.EOF
            SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = Price, DiscountTypeNumber = " & DiscountTypeNumber & ", Surcharge = 0  WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber")
            Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
            FreeTicketCount = FreeTicketCount+ 1
            rsLineNo.movenext
        Loop
    End If
    rsLineNo.Close
    Set rsLineNo = Nothing 
    
End If


End Sub 'ApplyCloseFree

'-----------------------------------------------------------------

Sub ApplyOpenFree(CustomerOpeningCount)


			EventList 	= 	OpenEventList	'List of Closing Night Events
  AllowedTicketCount 	= 	CustomerOpeningCount    	'Total number of tickets allowed
  AppliedTicketCount 	= 	0           	'Number of tickets already discounted
AvailableTicketCount 	= 	0           	'Number of tickets available for discounting


'Determine number of tickets already discounted
SQLApplied = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderHeader.CustomerNumber = " & Session("CustomerNumber") & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.StatusCode = 'S' AND Seat.EventCode IN (" & EventList & ")"
Set rsApplied = OBJdbConnection.Execute(SQLApplied)
AppliedTicketCount= rsApplied("TicketCount")
rsApplied.Close
Set rsApplied = nothing


'Determine number of tickets left
AvailableTicketCount = (AllowedTicketCount - AppliedTicketCount)
  
  
'Process ticket discounts			   
If CInt(AvailableTicketCount) > 0 Then 'it is okay to give free tickets 

    SQLLineNo = "SELECT TOP(" & AvailableTicketCount & ") LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN EVENT (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Seat.EventCode IN (" & EventList & ") ORDER BY OrderLine.Price DESC"
    Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)
    If Not rsLineNo.EOF Then
        Do While Not rsLineNo.EOF
            SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = Price, DiscountTypeNumber = " & DiscountTypeNumber & ", Surcharge = 0  WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber")
            Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
            FreeTicketCount = FreeTicketCount+ 1
            rsLineNo.movenext
        Loop
    End If
    rsLineNo.Close
    Set rsLineNo = Nothing 
    
End If


End Sub 'ApplyCloseFree

'-----------------------------------------------------------------

Sub ApplyCloseFree(CustomerClosingCount)


			EventList 	= 	CloseEventList			'List of Closing Night Events
  AllowedTicketCount 	= 	CustomerClosingCount   	'Total number of tickets allowed
  AppliedTicketCount 	= 	0           			'Number of tickets already discounted
AvailableTicketCount 	= 	0           			'Number of tickets available for discounting


'Determine number of tickets already discounted
SQLApplied = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderHeader.CustomerNumber = " & Session("CustomerNumber") & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.StatusCode = 'S' AND Seat.EventCode IN (" & EventList & ")"
Set rsApplied = OBJdbConnection.Execute(SQLApplied)
AppliedTicketCount= rsApplied("TicketCount")
rsApplied.Close
Set rsApplied = nothing


'Process ticket discounts		
AvailableTicketCount = (AllowedTicketCount - AppliedTicketCount)
               
			   
'Process ticket discounts				   
If CInt(AvailableTicketCount) > 0 Then 'it is okay to give free tickets 

    SQLLineNo = "SELECT TOP(" & AvailableTicketCount & ") LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN EVENT (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Seat.EventCode IN (" & EventList & ") ORDER BY OrderLine.Price DESC"
    Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)
    If Not rsLineNo.EOF Then
        Do While Not rsLineNo.EOF
            SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = Price, DiscountTypeNumber = " & DiscountTypeNumber & ", Surcharge = 0  WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber")
            Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
            FreeTicketCount = FreeTicketCount+ 1
            rsLineNo.movenext
        Loop
    End If
    rsLineNo.Close
    Set rsLineNo = Nothing 
    
End If


End Sub 'ApplyCloseFree

'-----------------------------------------------------------------

Sub ApplyActFree(ActCount)

'Patron is given 1 free ticket per act per order

DiscountPercentage = 1

SQLActCode = "SELECT Event.ActCode FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.SeatTypeCode IN (564) AND OrderLine.DiscountTypeNumber = 0 AND Event.EventCode NOT IN (" & OpenEventList & ") GROUP BY Event.ActCode ORDER BY Event.ActCode"
Set rsActCode = OBJdbConnection.Execute(SQLActCode)

If Not rsActCode.EOF Then
	Do While Not rsActCode.EOF
	
		SQLLineNo = "SELECT TOP(" & ActCount & ") LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN EVENT (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND ActCode = " & rsActCode("ActCode") & " ORDER BY LineNumber DESC"
		Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)
		
		If Not rsLineNo.EOF Then
			Do While Not rsLineNo.EOF
				SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = Price, DiscountTypeNumber = " & DiscountTypeNumber & ", Surcharge = 0  WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber")
				Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
				rsLineNo.movenext
			Loop
		End If    
		
		rsLineNo.Close
		Set rsLineNo = Nothing

	rsActCode.movenext
	Loop
End If	
rsActCode.Close
Set rsActCode = nothing


End Sub 'ApplySubscriptionDiscount

'-----------------------------------------------------------------

Sub ApplySingleFree(SingleCount)

'Patron is given 1 free ticket per act per order - maximum of 15 tickets

Dim DiscountPercentage, TotalSingleCount, AvailableSingleCount , AppliedSingleCount 

TotalSingleCount = (SingleCount * 15)
AppliedSingleCount = 0
DiscountPercentage = 1

SQLActCode = "SELECT Event.ActCode FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.SeatTypeCode IN (564) AND OrderLine.DiscountTypeNumber = 0 AND Event.EventCode NOT IN (" & OpenVIPList & ") GROUP BY Event.ActCode ORDER BY Event.ActCode"
Set rsActCode = OBJdbConnection.Execute(SQLActCode)

If Not rsActCode.EOF Then
	Do While Not rsActCode.EOF
	
		'Determine number of tickets left
		AvailableSingleCount = (TotalSingleCount - AppliedSingleCount)
		  
		'Process ticket discounts			   
		If CInt(AvailableSingleCount) > 0 Then 'it is okay to give free tickets 
	
			SQLLineNo = "SELECT TOP(" & SingleCount & ") LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN EVENT (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND ActCode = " & rsActCode("ActCode") & " ORDER BY LineNumber DESC"
			Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)
			
				If Not rsLineNo.EOF Then
					Do While Not rsLineNo.EOF
						SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = Price, DiscountTypeNumber = " & DiscountTypeNumber & ", Surcharge = 0  WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber")
						Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
						AppliedSingleCount = AppliedSingleCount + 1
						rsLineNo.movenext
					Loop
				End If    
			
			rsLineNo.Close
			Set rsLineNo = Nothing
			
		End If

	rsActCode.movenext
	Loop
End If	

rsActCode.Close
Set rsActCode = nothing


End Sub 'ApplySubscriptionDiscount

'-----------------------------------------------------------------

Sub ApplyDiscount(FreeTicketCount)

DiscountTicketCount = 0

'Apply ticket discounts according to ticket price
SQLLineNo = "SELECT OrderLine.LineNumber, OrderLine.Price FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.DiscountTypeNumber = 0 AND OrderLine.SeatTypeCode IN (564) ORDER BY LineNumber"
Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)

If Not rsLineNo.EOF Then
    Do While Not rsLineNo.EOF

			If rsLineNo("Price") = 13 Then
				DiscountAmount = 2
			ElseIf rsLineNo("Price") = 15 Then
				DiscountAmount = 3
			ElseIf rsLineNo("Price") = 40 Then
				DiscountAmount = 5
			ElseIf rsLineNo("Price") = 45 Then
				DiscountAmount = 5
			ElseIf rsLineNo("Price") = 50 Then
				DiscountAmount = 5
			ElseIf rsLineNo("Price") = 100 Then
				DiscountAmount = 25
			End If
			
			'ErrorLog("DiscountAmount "&DiscountAmount&" ")
                
            SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = " & DiscountAmount & ", DiscountTypeNumber = " & DiscountTypeNumber & " WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber") & " "
            Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
            DiscountApplied = "Y"
            DiscountTicketCount = DiscountTicketCount + 1
                     
    rsLineNo.movenext
    Loop
End If

rsLineNo.Close
Set rsLineNo = Nothing  


End Sub 'ApplyDiscount

'-----------------------------------------------------------------

Sub Continue
				
Session("SurveyComplete") = Session("OrderNumber")
If Session("UserNumber") = "" Then
	Response.Redirect("/Ship.asp")
Else
	Response.Redirect("/Management/AdvanceShip.asp")
End If		

End Sub 'Continue

'-----------------------------------------------------------------

%>