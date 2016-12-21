<%

'CHANGE LOG - Inception
'SSR 3/12/2014 - Updated for 2014 Festival

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->

<%

'-----------------------------------------------------------------

Page = "Survey"
SurveyNumber = 1646
SurveyFileName = "MemberDonationDiscount2014.asp"

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

'Discount Type: 2014 Membership Based Ticket Discount

'Description: The purchase of a valid membership/donation level entitles the patron to a set number of discounted tickets for specific events

'Available Internet: YES 

'Available Box Office: YES 

'Valid Ticket Type: Discounts are valid for all ticket types

'Valid Events: regular ticket discounts are valid to any event, 
'in any combination (excluding Opening Night, Closing Night and VIP events)
'Opening VIP Night Events: 		#640651
'Opening Night Events: 			#640652, #640653
'Closing Night Event: 			#640654
'Regular Events					All Other Event Codes

'Start Date/Time: Now 

'End Date/Time: Does Not Expire 

'Addtional ticket discounts: purchasing additional menberships will increase number of discounted tickets allowed.

'Discounted tickets allowed (by membership type)

'4609 - 2014 Supporter
'------------
'No Discounts

'4610 - 2014 Friend
'------------
'2 free regular screening tickets

'4611 - 2014 Filmmaker
'------------
'4 free regular screening tickets

'4612 - 2014 Sponsor
'------------
'6 free regular screening tickets
'2 free tickets to Opening Night

'4613 - 2014 Patron
'------------
'8 free regular screening tickets
'2 free tickets to Opening Night
'2 free tickets to Closing Night

'4614 - 2014 Benefactor
'------------
'10 free regular screening tickets
'2 free VIP Opening Night
'2 free tickets to Closing Night

					
'============================================================

'2014 Member Discount
DiscountTypeNumber = 92302

'Membership Levels 
ItemNumberList = "4609,4610,4611,4612,4613,4614"

'Closing Night Events
CloseEventList = "640654"

'Opening Night Events
OpenEventList = "640652,40653"

'Opening VIP Night Events
OpenVIPList = "640651"

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
			Case 4609	'SUPPORTER
				Count = 0
			Case 4610	'FRIEND
				Count = 2 
			Case 4611	'FILMMAKER
				Count = 4
			Case 4612	'SPONSOR
				Count = 6
				OpeningCount = 2
			Case 4613	'PATRON
				Count = 8
				OpeningCount = 2
				ClosingCount = 2 
			Case 4614	'BENEFACTOR
				Count = 10 
				OpeningVIPCount = 2 
				ClosingCount = 2 
			End Select
			 
			AllowedTicketCount = AllowedTicketCount + Count   
 			
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