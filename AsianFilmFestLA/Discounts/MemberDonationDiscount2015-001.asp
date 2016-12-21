<%

'Visual Communiations - Asian Film Festival

'Discount Type: 2015 Donation Item Based Ticket Discount

'Description: The purchase of a valid membership/donation level entitles the patron to a set number of discounted tickets for specific events

'Available Internet: YES 

'Available Box Office: YES 

'Valid Ticket Type: Discounts are only applied to General Addmission tickets (SeatTypeCode #42850)

'Valid Events:

'Opening VIP Night Events: 		#640651
'Opening Night Events: 			#640652, #640653
'Closing Night Event: 			#640654
'Regular Events					All Other Event Codes

'Start Date/Time: 	Now 
'End Date/Time: 	April 17 

'Addtional ticket discounts: 
'Purchasing additional menberships will increase the number of discounted tickets allowed.

'Discounted tickets allowed (by ItemNumber - Membership Type)

'#4874 - 2015 Supporter
'------------
'Regular Events: Unlimited General Admision tickets discounted down to the same price as the Membership Ticket for the event

'4875 - 2015 Friend
'------------
'Regular Events: Unlimited General Admision tickets discounted down to the same price as the Membership Ticket for the event
'Regular Events: 2 General Admision tickets discounted  to 100% per event.

'4876 - 2015 Filmmaker
'------------
'Regular Events: Unlimited General Admision tickets discounted down to the same price as the Membership Ticket for the event
'Regular Events: 4 General Admision tickets discounted  to 100% per event.

'4877 - 2015 Sponsor
'------------
'Regular Events: Unlimited General Admision tickets discounted down to the same price as the Membership Ticket for the event
'Regular Events: 6 General Admision tickets discounted  to 100% per event.
'Opening Night: 2 General Admision tickets discounted  to 100% for this event.


'4878 - 2015 Patron
'------------
'Regular Events: Unlimited General Admision tickets discounted down to the same price as the Membership Ticket for the event
'Regular Events: 8 General Admision tickets discounted  to 100% per event.
'Opening Night: 2 General Admision tickets discounted  to 100% for this event.
'Closing Night: 2 General Admision tickets discounted  to 100% for this event.


'4879 - 2015 Benefactor
'------------
'Regular Events: Unlimited General Admision tickets discounted down to the same price as the Membership Ticket for the event
'Regular Events: 8 General Admision tickets discounted  to 100% per event.
'Opening VIP Night: 2 General Admision tickets discounted  to 100% for this event.
'Closing Night: 2 General Admision tickets discounted  to 100% for this event.

					
'============================================================

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%


DIM CustomerNumber
CustomerNumber = fnCustomerNumber

DIM RequiredSeatType
RequiredSeatType = "42850"

DIM MemberSeatCode 
MemberSeatCode  = "42843"

DIM VIPEvent 
VIPEvent  = "731756"

DIM OpenEvent
OpenEvent = "731757"

DIM CloseEvent
CloseEvent = "731758"

ItemNumberList = "4874,4875,4876,4877,4878,4879"

DIM RegularCount
DIM OpenCount
DIM CloseCount 
DIM VIPCount 

'---------------------------------------------------------

If AllowDiscount = "Y" Then 'It's okay to apply to this order.

	'ErrorLog("CustomerNumber: " & CustomerNumber & "")

	SQLMemberCurrent = "SELECT OrderLine.ItemNumber FROM OrderLine WITH (NOLOCK) INNER JOIN OrderHeader WITH (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE OrderLine.ItemNumber IN (" & ItemNumberList & ") AND ((OrderHeader.OrderNumber <> " & OrderNumber & " AND OrderLine.StatusCode = 'S' AND OrderHeader.CustomerNumber = " & CustomerNumber & ") OR OrderHeader.OrderNumber = " & OrderNumber & ")"
	Set rsMemberCurrent = OBJdbConnection.Execute(SQLMemberCurrent)

		If Not rsMemberCurrent.EOF Then

			Do While Not rsMemberCurrent.EOF
	   
				Select Case rsMemberCurrent("ItemNumber")
				'SUPPORTER
				Case 4874
					RegularCount	= RegularCount 	+ 0
				'FRIEND
				Case 4875	
					RegularCount 	= RegularCount 	+ 2 
				'FILMMAKER
				Case 4876	
					RegularCount 	= RegularCount 	+ 4
				'SPONSOR
				Case 4877	
					RegularCount 	= RegularCount 	+ 6
					OpenCount 		= OpenCount 	+ 2
				'PATRON
				Case 4878	
					RegularCount 	= RegularCount 	+ 8
					OpenCount 		= OpenCount 	+ 2
					CloseCount 		= CloseCount 	+ 2 
				'BENEFACTOR
				Case 4879	
					RegularCount 	= RegularCount 	+ 10 
					VIPCount 		= VIPCount		+ 2 
					CloseCount 		= CloseCount 	+ 2 
				End Select
				 
			rsMemberCurrent.MoveNext	
			Loop
				
		End If
		
	rsMemberCurrent.Close
	Set rsMemberCurrent = nothing

	'ErrorLog("RegularCount : " & RegularCount & "")
	'ErrorLog("OpenCount : " & OpenCount & "")
	'ErrorLog("CloseCount : " & CloseCount & "")
	'ErrorLog("VIPCount : " & VIPCount & "")


	'---------------------------------------------------------
	'Process Free Regular Event Tickets

	If RegularCount > 0 Then
	
		SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader WITH (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderHeader.CustomerNumber = " & CustomerNumber & " AND Seat.EventCode NOT IN (" & VIPEvent & "," & OpenEvent & "," & CloseEvent &") AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.Price=OrderLine.Discount"
		Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
			
			If NOT rsDiscCount.EOF	Then
							
				If EventCode <> VIPEvent AND EventCode <> OpenEvent AND EventCode <> CloseEvent Then

					If Int(rsDiscCount("LineCount")) < Int(RegularCount) Then 
						NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Clean(Request("Percentage")))/100), 2)
					Else
						NewPrice = fnMemberPrice
					End If	
					
				End If
				
			End If
			
		rsDiscCount.Close
		Set rsDiscCount = nothing

	End If
	
	'---------------------------------------------------------

	'Process Free Opening Event Tickets

	If OpenCount > 0 Then

		SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader WITH (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderHeader.CustomerNumber = " & CustomerNumber & " AND Seat.EventCode = " & OpenEvent & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.Price=OrderLine.Discount"
		Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
			
			If NOT rsDiscCount.EOF	Then
		
				If EventCode = OpenEvent Then

					If Int(rsDiscCount("LineCount")) < Int(OpenCount) Then 
						NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Clean(Request("Percentage")))/100), 2)
					End If
				
				End If
				
			End If

		rsDiscCount.Close
		Set rsDiscCount = nothing

	End If
	
	'---------------------------------------------------------

	'Process Free Closing Tickets

	If CloseCount > 0 Then

		SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader WITH (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderHeader.CustomerNumber = " & CustomerNumber & " AND Seat.EventCode = " & CloseEvent & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.Price=OrderLine.Discount"
		Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
			
			If NOT rsDiscCount.EOF	Then
		
				If EventCode = CloseEvent Then

					If Int(rsDiscCount("LineCount")) < Int(CloseCount) Then 
						NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Clean(Request("Percentage")))/100), 2)
					End If
				
				End If
				
			End If

		rsDiscCount.Close
		Set rsDiscCount = nothing

	End If
	
	'---------------------------------------------------------
	
	'Process Free Open VIP Tickets

	If VIPCount > 0 Then

		SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader WITH (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderHeader.CustomerNumber = " & CustomerNumber & " AND Seat.EventCode = " & VIPEvent & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.Price=OrderLine.Discount"
		Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
			
			If NOT rsDiscCount.EOF	Then
		
				If EventCode = VIPEvent Then

					If Int(rsDiscCount("LineCount")) < Int(CloseCount) Then 
						NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Clean(Request("Percentage")))/100), 2)
					End If
				
				End If
				
			End If

		rsDiscCount.Close
		Set rsDiscCount = nothing

	End If
	
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