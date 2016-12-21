<%

'CHANGE LOG

'SSR - 05/27/15 - Created custom discount script
'SSR - 08/18/15 - Updated discount to allow 2 different gala/special events

'============================================================

'E & M Theatrical
'2015 Season Pass 
'Past Event Discount


'Required Events
'-----------------------------------
'If patron buys 1 ticket to the season Pass event, they are entitled 
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

DIM SpecialEvent(1)
SpecialEvent(0) = 759063
SpecialEvent(1) = 762269

DIM SpecialEventList
SpecialEventList = Join(SpecialEvent,",")	

DIM SeriesPercentage
SeriesPercentage = 100

DIM NbrRegular
NbrRegular = 0

DIM NbrSpecial
NbrSpecial = 0

DIM NewPrice
NewPrice = 0

DIM NewShipFee
NewShipFee = 0

'---------------------------------------------------------

If AllowDiscount = "Y" Then 

	'ErrorLog("AllowDiscount : " & AllowDiscount  & "")
	
	'Loop through all purchased ticket types for Flex Pass event

	SQLMemberCurrent = "SELECT OrderLine.SeatTypeCode FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE (Event.EventCode IN (" & SubscriptionEvent & ")  AND OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.StatusCode = 'R') OR (Event.EventCode IN (" & SubscriptionEvent & ") AND OrderHeader.CustomerNumber = " & CustomerNumber & " AND OrderLine.StatusCode = 'S' AND GetDate() < (DateAdd(Day, 365, OrderHeader.OrderDate)))"
	Set rsMemberCurrent = OBJdbConnection.Execute(SQLMemberCurrent)

		If Not rsMemberCurrent.EOF Then

			Do While Not rsMemberCurrent.EOF
	   
				Select Case rsMemberCurrent("SeatTypeCode")

				Case 66946 '8 Ticket Pass
							NbrRegular	= NbrRegular	+ 8
							NbrSpecial =  NbrSpecial	+ 2
							
				Case 66947 '12 Ticket Pass
							NbrRegular	= NbrRegular	+ 12
							NbrSpecial =  NbrSpecial	+ 2
							
				Case 66948 '16 Ticket Pass
							NbrRegular	= NbrRegular	+ 16
							NbrSpecial =  NbrSpecial	+ 2
							
				Case 66949 '32 Ticket Pass
							NbrRegular	= NbrRegular	+ 32
							NbrSpecial =  NbrSpecial	+ 2

				End Select
				 
			rsMemberCurrent.MoveNext	
			Loop
				
		End If
		
	rsMemberCurrent.Close
	Set rsMemberCurrent = nothing
	
	'ErrorLog("Total RegularTickets : " & NbrRegular  & "")
	'ErrorLog("Total SpecialTickets : " & NbrSpecial  & "")
	
	'Count the number of tickets already discounted for special events
	SQLApplied = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE (CustomerNumber = " & CustomerNumber & " AND Seat.EventCode IN (" & SpecialEventList & ") AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.StatusCode = 'S') OR (OrderLine.OrderNumber = " & OrderNumber & " AND Seat.EventCode IN (" & SpecialEventList & ") AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.StatusCode = 'R' AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent'))"
	Set rsApplied = OBJdbConnection.Execute(SQLApplied)	
		GalaAppliedCount = rsApplied("TicketCount")		
	rsApplied.Close
	Set rsApplied = nothing
	
	'Count the number of tickets already discounted for regular events
	SQLApplied = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE (CustomerNumber = " & CustomerNumber & " AND Seat.EventCode NOT IN (" & SpecialEventList & ") AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.StatusCode = 'S') OR (OrderLine.OrderNumber = " & OrderNumber & " AND Seat.EventCode NOT IN (" & SpecialEventList & ") AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.StatusCode = 'R' AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent'))"
	Set rsApplied = OBJdbConnection.Execute(SQLApplied)	
		RegAppliedCount = rsApplied("TicketCount")		
	rsApplied.Close
	Set rsApplied = nothing
	
	'ErrorLog("Applied Special: " & GalaAppliedCount  & "")
	'ErrorLog("Applied Regular : " & RegAppliedCount  & "")
	
	'---------------------------------------------------------
	
	'Apply discounts to regular tickets
	If NbrRegular > 0 Then 

		If EventCode <>  759063  AND EventCode <> 762269 Then
		
			'ErrorLog("EventCode NOT 759063 or 762269: " & EventCode & "")
	
				If RegAppliedCount < NbrRegular Then	
				
					'ErrorLog("RegAppliedCount  " & RegAppliedCount  & " less than NbrRegular " & NbrRegular & " Then DISCOUNT!")				
					NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(SeriesPercentage)/100), 2)	
					DiscountAmount = Round(Clean(Request("Price")),2) - NewPrice
					Surcharge = 0
					AppliedFlag = "Y"
				Else
					'ErrorLog("RegAppliedCount  " & RegAppliedCount  & " greater than NbrRegular " & NbrRegular & " Then no discount")	
				
				End If
								
		End If
			
	End If
	
	'---------------------------------------------------------
	
	'Apply discounts to gala tickets
	If NbrSpecial > 0 Then 

		If EventCode =  759063  OR EventCode = 762269 Then

			If GalaAppliedCount < NbrSpecial Then	
			
				NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(SeriesPercentage)/100), 2)	
				DiscountAmount = Round(Clean(Request("Price")),2) - NewPrice
				Surcharge = 0
				AppliedFlag = "Y"
				
			End If
		
		End If
											
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