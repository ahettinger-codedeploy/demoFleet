<%


'CHANGE LOG

'SSR  02/23/16 - Created custom discount script
'SSR  02/24/16 - Updated with tracking code to allow counting of acts for Series A and Series B
'SSR  03/01/16 - Updated to fix issue when both Series A and Series B are purchased on the same order.


%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'============================================================

'Chester Theatre Company 
'2016 Subscription Series Discount - Past Event Discount Type

'Patrons who purchase 1 ticket to a season subscription event
'are entitled to a specific number of discounted tickets to the 
'acts that make up that series

'SEASON SUBCRIPTION EVENTS

'Event Code		Act Name			Discount						
'----------		---------------		-------------------------------------------		
'847647 		2016 Season			1 discounted ticket to each of the series acts
'847645 		2016 Flex Pass		6 discounted tickets to any series act

'SERIES ACTS

'Act Code		Act Name					
'----------		---------------
'125403			My Jane
'125653			Oh God
'125654			Sister Play
'125655			The Mountaintop


'Eligible Ticket Type
'--------------------
'Discount available for all ticket types


'Eligible Price Tier/Section
'--------------------
'Discount available in all sections / price tiers


'Offline/Online
'--------------------
'Discount available for both online and offline orders


'Service Fees
'--------------------
'New Surcharge: $0.00 per ticket


'Automatic/Code Entry
'--------------------
'Automatic Discount: code entry not required


'Discount Code
'--------------------
'2016sub


'Expiration
'--------------------
'No expiration


'Additional Discounts
'--------------------
'Purchase of additional season subscriptions 
'will add to the number of discounted tickets.


'Discount Restrictions
'--------------------
'Season subscription events  must be purchased either:
'- within the last 365 days
'- on the same order as series acts

'===============================================

'Variables

DIM NbrSubA 
DIM NbrSubB

'customer number
DIM CustomerNumber
CustomerNumber = fnCustomerNumber

'subscription events
DIM SubscriptionA 
DIM SubscriptionB 
SubscriptionA		= 	847647
SubscriptionB		=	847645

'placeholder discount codes used to
'track the number of discounted tickets for each series
DIM DiscountCodeA
DIM DiscountCodeB
DiscountCodeA		=	123342
DiscountCodeB		=	123341

'list of valid acts for each series
DIM ActSubA
DIM ActSubB
ActSubA 			= 	"125403,125653,125654,125655"
ActSubB 			= 	"125403,125653,125654,125655"

'number of discounted tickets
DIM SeriesCountA	
DIM SeriesCountB	
SeriesCountA		= 	1
SeriesCountB		= 	6

'series discount
DIM SeriesPercentage
SeriesPercentage	= 	100

DIM Count


'---------------------------------------------------------

If CustomerNumber = 1 OR CustomerNumber = "" Then
	AllowDiscount = "N"
End If

'---------------------------------------------------------

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
	
	'Errorlog("NbrSubA : " & NbrSubA & "")
	'Errorlog("NbrSubB : " & NbrSubB & "")
	
'---------------------------------------------------------
	
	
	'Determine the act code
	SQLAct = "SELECT Event.ActCode, Act.Act, Event.EventDate FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode WHERE EventCode = " & EventCode & ""
	Set rsAct = OBJdbConnection.Execute(SQLAct)
		ActCode = rsAct("ActCode")
		Act = rsAct("Act")
		EventDate = rsAct("EventDate")
	rsAct.Close
	Set rsAct = nothing
	
	SQLTrackingCode = "SELECT TrackingCode FROM OrderLine (NOLOCK) WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.LineNumber =  " & LineNumber & ""
	Set rsTrackingCode = OBJdbConnection.Execute(SQLTrackingCode)	
		TrackingCode = rsTrackingCode("TrackingCode")		
	rsTrackingCode.Close
	Set rsTrackingCode = nothing
	
	'Errorlog("TrackingCode : " & TrackingCode & "")

	
'---------------------------------------------------------
	
	'Subscription A - 1 discounted ticket per act per series
	
	If NbrSubA > 0 Then 
	
		If fnFindAct(ActCode,ActSubA) Then 
	
			'Count the number of tickets per act already discounted for this series
			SQLApplied = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE (CustomerNumber = " & CustomerNumber & " AND ActCode = " & ActCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.TrackingCode = " & DiscountCodeA & " AND OrderLine.StatusCode = 'S') OR (OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ActCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & "  AND OrderLine.TrackingCode = " & DiscountCodeA & " AND OrderLine.StatusCode = 'R')"
			Set rsApplied = OBJdbConnection.Execute(SQLApplied)	
				AppliedActCount = rsApplied("TicketCount")	

				SQLTrackingCode = "SELECT (OrderLine.LineNumber) FROM OrderLine (NOLOCK) WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.LineNumber =  " & LineNumber & " AND OrderLine.TrackingCode <> " & DiscountCodeA & ""
				Set rsTrackingCode = OBJdbConnection.Execute(SQLTrackingCode)
							
					If AppliedActCount < NbrSubA Then
			
						NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(SeriesPercentage)/100), 2)	
						
						AppliedFlag = "Y"
						
						SQLUpdateDiscountCode = "UPDATE OrderLine SET TrackingCode = " & DiscountCodeA & " WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.LineNumber =  " & LineNumber & " AND OrderLine.DiscountTypeNumber <> " & DiscountTypeNumber & ""
						Set rsUpdateDiscountCode  = OBJdbConnection.Execute(SQLUpdateDiscountCode)	
						
						Errorlog(":: SubA - Act: " & ActCode & " AppliedActCount " & rsApplied("TicketCount") & " DiscountCode " & DiscountCodeA & " Line Number: " & LineNumber & "")	
						
					End If
					
				rsTrackingCode.Close
				Set rsTrackingCode = nothing
	
			rsApplied.Close
			Set rsApplied = nothing
			
		End If
											
	End If
	
'---------------------------------------------------------
	
	'Subscription B - 6 discounted tickets per series

	If NbrSubB > 0 Then 
	
		If fnFindAct(ActCode,ActSubB) Then 
	
			'Count the number of tickets per act already discounted for this series
			SQLApplied = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE (CustomerNumber = " & CustomerNumber & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.TrackingCode = " & DiscountCodeB & " AND OrderLine.StatusCode = 'S') OR (OrderLine.OrderNumber = " & OrderNumber & " AND DiscountTypeNumber = " & DiscountTypeNumber & "  AND OrderLine.TrackingCode = " & DiscountCodeB & " AND OrderLine.StatusCode = 'R')"
			Set rsApplied = OBJdbConnection.Execute(SQLApplied)	
				AppliedCount = rsApplied("TicketCount")	

				SQLTrackingCode = "SELECT (OrderLine.LineNumber) FROM OrderLine (NOLOCK) WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.LineNumber =  " & LineNumber & " AND OrderLine.TrackingCode <> " & DiscountCodeB & ""
				Set rsTrackingCode = OBJdbConnection.Execute(SQLTrackingCode)
							
					If AppliedCount < NbrSubB Then

						Errorlog(":: SubB - Act: " & ActCode & " AppliedCount " & rsApplied("TicketCount") & " DiscountCode " & DiscountCodeB & " Line Number: " & LineNumber & "")				
					
						NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(SeriesPercentage)/100), 2)	
						
						AppliedFlag = "Y"
						
						SQLUpdateDiscountCode = "UPDATE OrderLine SET TrackingCode = " & DiscountCodeB & " WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.LineNumber =  " & LineNumber & " AND OrderLine.DiscountTypeNumber <> " & DiscountTypeNumber & ""
						Set rsUpdateDiscountCode  = OBJdbConnection.Execute(SQLUpdateDiscountCode)	
						


					End If
					
				rsTrackingCode.Close
				Set rsTrackingCode = nothing
	
			rsApplied.Close
			Set rsApplied = nothing
			
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

Public Function fnFindAct(strAct,strActList)

	'this function requires the current actcode and a string of actcodes passed to it.
	'it then returns a Boolean value that indicates whether the current actcode was found within the string

	fnFindAct = False

	arrActs = Split(strActList,",")

	For i=0 To Ubound(arrActs)
		If Trim(arrActs(i)) = Trim(strAct) Then
			fnFindAct = True
			Exit Function      
		End If 
	Next

End Function
	
'---------------------------------------------------------

%>