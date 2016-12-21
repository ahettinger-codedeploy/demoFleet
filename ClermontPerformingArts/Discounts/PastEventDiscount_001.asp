<%

'CHANGE LOG

'SSR - 05/27/15 - Created custom discount script

'============================================================

'E & M Theatrical
'2015 Season Subscription 
'Past Event Discount


'Required Events
'-----------------------------------
'If patron buys 1 ticket to the season subscription event, they are entitled 
'to specific number of regular tickets (based on ticket type) at 100% off and 2 gala tickets at 100% off

'Ticket Type	Ticket Count

'66946			Flex Pass - 08 tickets + 2 gala tickets  
'66947			Flex Pass - 12 tickets + 2 gala tickets 	
'66948			Flex Pass - 16 tickets + 2 gala tickets 
'66949			Flex Pass - 32 tickets + 2 gala tickets 


'Eligible Ticket Type
'-----------------------------------
'Discount available for all ticket types


'Eligible Price Tier/Section
'-----------------------------------
'Discount available in all sections / price tiers


'Offline/Online
'-----------------------------------
'Discount available for both online and offline orders


'Service Fees
'-----------------------------------
'New Per Ticket Surcharge: $0.00 per ticket
'New Per Order Delivery Surcharge: $0.00 per order


'Automatic/Code Entry
'-----------------------------------
'Automatic Discount: code entry not required


'Discount Code
'-----------------------------------
'2015sub


'Expiration
'-----------------------------------
'No expiration


'Discount Limits
'-----------------------------------
'Unlimited discounts

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

DIM CustomerNumber
CustomerNumber = fnCustomerNumber

If CustomerNumber = 1 OR CustomerNumber = "" Then
	AllowDiscount = "N"
End If

DIM SubscriptionEvent
SubscriptionEvent = 764478

DIM NbrSubs
NbrSubs = 0

DIM GalaAct
GalaAct = 115656

DIM NbrGala
NbrGala = 0

DIM SeriesPercentage
SeriesPercentage = 100

DIM NewPrice
NewPrice = 0

DIM NewShipFee
NewShipFee = 0

'---------------------------------------------------------

If AllowDiscount = "Y" Then 

	ErrorLog("AllowDiscount : " & AllowDiscount  & "")
	
	'Loop through all purchased ticket types for subscription event

	SQLMemberCurrent = "SELECT OrderLine.SeatTypeCode FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE (Event.EventCode IN (" & SubscriptionEvent & ")  AND OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.StatusCode = 'R') OR (Event.EventCode IN (" & SubscriptionEvent & ") AND OrderHeader.CustomerNumber = " & CustomerNumber & " AND OrderLine.StatusCode = 'S' AND GetDate() < (DateAdd(Day, 365, OrderHeader.OrderDate)))"
	Set rsMemberCurrent = OBJdbConnection.Execute(SQLMemberCurrent)

		If Not rsMemberCurrent.EOF Then

			Do While Not rsMemberCurrent.EOF
	   
				Select Case rsMemberCurrent("SeatTypeCode")

				Case 66946 '8 Ticket Subscription
							NbrSubs	= NbrSubs	+ 8
							NbrGala = NbrGala	+ 2
				Case 66947 '12 Ticket Subscription
							NbrSubs	= NbrSubs	+ 12
							NbrGala = NbrGala	+ 2
				Case 66948 '16 Ticket Subscription
							NbrSubs	= NbrSubs	+ 16
							NbrGala = NbrGala	+ 2
				Case 66949 '32 Ticket Subscription
							NbrSubs	= NbrSubs	+ 32
							NbrGala = NbrGala	+ 2

				End Select
				 
			rsMemberCurrent.MoveNext	
			Loop
				
		End If
		
	rsMemberCurrent.Close
	Set rsMemberCurrent = nothing

	'Get the act code
	SQLAct = "SELECT Event.ActCode, Act.Act, Event.EventDate FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode WHERE EventCode = " & EventCode & ""
	Set rsAct = OBJdbConnection.Execute(SQLAct)
		ActCode = rsAct("ActCode")
		Act = rsAct("Act")
	rsAct.Close
	Set rsAct = nothing
	
	'Count the number of tickets already discounted for gala act
	SQLApplied = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE (CustomerNumber = " & CustomerNumber & " AND ActCode = " & GalaAct & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.StatusCode = 'S') OR (OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & GalaAct & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.StatusCode = 'R' AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent'))"
	Set rsApplied = OBJdbConnection.Execute(SQLApplied)	
		GalaAppliedCount = rsApplied("TicketCount")		
	rsApplied.Close
	Set rsApplied = nothing

	'Count the number of tickets already discounted for all other acts
	SQLApplied = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE (CustomerNumber = " & CustomerNumber & " AND ActCode <> " & GalaAct & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.StatusCode = 'S') OR (OrderLine.OrderNumber = " & OrderNumber & " AND ActCode <> " & GalaAct & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.StatusCode = 'R' AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent'))"
	Set rsApplied = OBJdbConnection.Execute(SQLApplied)	
		RegAppliedCount = rsApplied("TicketCount")		
	rsApplied.Close
	Set rsApplied = nothing

	'---------------------------------------------------------
	
	'Apply discounts to regular tickets
	If NbrSubs > 0 Then 
	
		If ActCode <> GalaAct Then
			
			If NbrSubs > 0 Then 
			
				If RegAppliedCount < NbrSubs Then						
					NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(SeriesPercentage)/100), 2)	
					DiscountAmount = Round(Clean(Request("Price")),2) - NewPrice
					Surcharge = 0
					AppliedFlag = "Y"
				End If
				
			End If
				
		End If
			
	End If
	
	'---------------------------------------------------------
	
	'Apply discounts to gala tickets
	If NbrGala > 0 Then 

		If ActCode = GalaAct Then
			
			If NbrGala > 0 Then 
			
				If GalaAppliedCount < NbrGala Then						
					NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(SeriesPercentage)/100), 2)	
					DiscountAmount = Round(Clean(Request("Price")),2) - NewPrice
					Surcharge = 0
					AppliedFlag = "Y"
				End If
				
			End If
				
		End If
											
	End If
	
	'---------------------------------------------------------
	
	'Apply discount to the order delivery surcharge
	If AppliedFlag = "Y" Then
	
		SQLUpdateShipFee = "UPDATE OrderHeader SET ShipFee = " & NewShipFee & " WHERE OrderHeader.OrderNumber = " & OrderNumber & ""
		Set rsUpdateShipFee  = OBJdbConnection.Execute(SQLUpdateShipFee)	
		
	End If
		
	'---------------------------------------------------------

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

%>