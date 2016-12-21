<%


'CHANGE LOG

'SSR  03/30/15 - Created custom discount script
'SSR  04/02/15 - Updated discounts script
'SSR  06/01/15 - Updated to allow discount on child events when the subscription event has not yet been purchased, but is the shopping cart along with the child events.
'SSR  06/22/15 - Updated to allow FlexPass and Regular Subscription on same order

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'============================================================

'ErrorLog("discount start ver 130")

'Chester Theatre Company 
'2015 Season Subscription

'REQUIRED EVENTS

'EventCode		Name				Quantity						
'----------		---------------		-------------------------------------------		
'743506 		2015 Season			1 discounted ticket  - per production
'743505 		2015 Flex Pass		6 discounted tickets - in any combination

'patrons who buy 1 ticket to the 2015 season event, are entitled 
'to 1 discounted ticket to each of the series acts at 100% off.

'patrons who buy 1 ticket to the 2105 Flex Pass, are entitled 
'to 6 discounted tickets in any combination at 100% off.

'Season Productions
'--------------------------- 
'ACT CODE	ACT NAME
'113194		Halcyon Days
'113195		Memory House
'113196		Blink
'113197		The Gospel According to Thomas Jefferson


'Eligible Ticket Type
'--------------------
'Discount available for all ticket types


'Eligible Price Tier/Section
'---------------------------
'Discount available in all sections / price tiers


'Offline/Online
'-------------
'Discount available for both online and offline orders


'Service Fees
'-------------
'New Surcharge: $0.00 per ticket


'Automatic/Code Entry
'---------------------
'Automatic Discount: code entry not required


'Discount Code
'--------------
'2015sub


'Expiration
'----------
'No expiration


'Discount Limits
'---------------
'Unlimited discounts

'===============================================

'Variables

DIM CustomerNumber

CustomerNumber = fnCustomerNumber
'ErrorLog("CustomerNumber: " & CustomerNumber & "")

DIM SubscriptionA 
DIM SubscriptionB 

SubscriptionA		= 	743506 	'2015 Regular Season - 1 ticket per production
SubscriptionB		=	743505 	'2015 Flex Pass - 6 tickets total


DIM ActSubA(3)
DIM ActSubB(3)

ActSubA(0) 			= 	113194  'Halcyon Days	
ActSubA(1) 			= 	113195	'Memory House
ActSubA(2) 			= 	113196	'Blink
ActSubA(3) 			= 	113197	'The Gospel According to Thomas Jefferson

ActSubB(0) 			= 	113194  'Halcyon Days	
ActSubB(1) 			= 	113195	'Memory House
ActSubB(2) 			= 	113196	'Blink
ActSubB(3) 			= 	113197	'The Gospel According to Thomas Jefferson

DIM NbrSubA 
DIM NbrSubB

NbrSubA				= 	0
NbrSubB				= 	0

DIM SeriesCountA	
DIM SeriesCountB	
	
SeriesCountA	= 	1
SeriesCountB	= 	6

DIM SeriesPercentage

SeriesPercentage	= 	100

'---------------------------------------------------------

If CustomerNumber = 1 OR CustomerNumber = "" Then
	AllowDiscount = "N"
End If



If AllowDiscount = "Y" Then 'It's okay to apply to this order.

	'Determine how many of the subscription events have been purchased
	SQLMemberCurrent = "SELECT Event.EventCode, Orderline.ItemNumber FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE (Event.EventCode IN (" & SubscriptionA & "," & SubscriptionB & ")  AND OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.StatusCode = 'R') OR (Event.EventCode IN (" & SubscriptionA & "," & SubscriptionB & ") AND OrderHeader.CustomerNumber = " & CustomerNumber & " AND OrderLine.StatusCode = 'S' AND GetDate() < (DateAdd(Day, 365, OrderHeader.OrderDate)))"
	Set rsMemberCurrent = OBJdbConnection.Execute(SQLMemberCurrent)

		If Not rsMemberCurrent.EOF Then

			Do While Not rsMemberCurrent.EOF
	   
				Select Case rsMemberCurrent("EventCode")
				
					'Regular Season Subscription
					Case	SubscriptionA	'1 ticket per production
							NbrSubA 			= NbrSubA 		+ SeriesCountA

					'Flex Season Subscription
					Case	SubscriptionB 	'6 tickets
							NbrSubB				= NbrSubB 		+ SeriesCountB
					
				End Select
				 
			rsMemberCurrent.MoveNext	
			Loop
				
		End If
		
	rsMemberCurrent.Close
	Set rsMemberCurrent = nothing
	
	'ErrorLog("NbrSubA: " & NbrSubA & "")
	'ErrorLog("NbrSubB: " & NbrSubB & "")
	'---------------------------------------------------------
	
	'determine the act code
	SQLAct = "SELECT Event.ActCode, Act.Act, Event.EventDate FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode WHERE EventCode = " & EventCode & ""
	Set rsAct = OBJdbConnection.Execute(SQLAct)
		ActCode = rsAct("ActCode")
		Act = rsAct("Act")
		EventDate = rsAct("EventDate")
	rsAct.Close
	Set rsAct = nothing
	
	
	'ErrorLog("Act: " & Act & "")
	
	'Count the number of discounted tickets for this act code
	SQLApplied = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE (CustomerNumber = " & CustomerNumber & " AND ActCode = " & ActCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.StatusCode = 'S') OR (OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ActCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.StatusCode = 'R')"
	Set rsApplied = OBJdbConnection.Execute(SQLApplied)	
		AppliedActCount = rsApplied("TicketCount")		
	rsApplied.Close
	Set rsApplied = nothing
	
	'ErrorLog("AppliedActCount: " & AppliedActCount & "")
	
	'Count the number of discounted tickets
	SQLApplied = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE (CustomerNumber = " & CustomerNumber & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.StatusCode = 'S') OR (OrderLine.OrderNumber = " & OrderNumber & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.StatusCode = 'R')"
	Set rsApplied = OBJdbConnection.Execute(SQLApplied)	
		AppliedCount = rsApplied("TicketCount")		
	rsApplied.Close
	Set rsApplied = nothing
	
	'ErrorLog("AppliedCount: " & AppliedCount & "")
	
	'---------------------------------------------------------
	
	'2015 Regular Season - 1 ticket per production
	If NbrSubA > 0 Then 
	
				'ErrorLog("NbrSub A more than 0")
				'ErrorLog("NbrSubA: " & NbrSubA & "")
				'ErrorLog("AppliedActCount: " & AppliedActCount & "")
					
				If fnFindAct(ActCode,ActSubA) Then 
					'ErrorLog("Act: " & ActCode & " qualifies")
					If AppliedActCount < NbrSubA Then				
						NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(SeriesPercentage)/100), 2)	
						AppliedFlag = "Y"
					End If
				Else
				
				'ErrorLog("Act: " & ActCode & " no go")
				
				End If
											
	End If
	
	'---------------------------------------------------------

	If NbrSubB > 0 Then 
	
			'ErrorLog("NbrSub B more than 0")
			'ErrorLog("Act: " & ActCode & " qualifies")
			'ErrorLog("AppliedCount: " & AppliedCount & "")

				If AppliedCount < NbrSubB Then				
					NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(SeriesPercentage)/100), 2)	
					AppliedFlag = "Y"
				End If

											
	End If
	
	'---------------------------------------------------------
		
	If AppliedFlag = "Y" Then
	
		If NewPrice < 0 Then
			NewPrice = 0
		End If
	
		DiscountAmount = Round(Clean(Request("Price")),2) - NewPrice
		
		Surcharge = 0
			
	End If


End If
	
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

'---------------------------------------------------------

Public Function fnCustomerNumber

	'this function returns the patrons customer number

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

Public Function fnFindAct(strAct,arrActs)

	'this function requires an actcode and an array of actcodes passed to it.
	'it then returns a Boolean value that indicates whether the specified actcode was found

  fnFindAct = False
  
  For i=0 To Ubound(arrActs)
     If Trim(arrActs(i)) = Trim(strAct) Then
        fnFindAct = True
        Exit Function      
     End IF 
  Next
  
End Function

'---------------------------------------------------------

%>