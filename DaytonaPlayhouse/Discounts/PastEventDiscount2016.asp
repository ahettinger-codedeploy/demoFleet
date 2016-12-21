<%

'CHANGE LOG
'SSR 02/16/2016 - Created discount

'============================================================

'Daytona Playhouse
'2016 Subscription - Past Event Discount

'2016-17 SERIES

'If patron buys 1 ticket to this season subscription event:

'Event Code		Event Name
'-----------------------
'846794			Subscription Package Flex - 2016-17

'they are entitled to 6 discounted tickets to any event of the following acts:

'Act Code		Act Name
'-----------------------
'125182			NOISES OFF
'125184			SIDE EFFECTS
'125186			THE ACTRESS
'125187			THE ADDAMS FAMILY
'125354			THE KIDS LEFT. THE DOG DIED. NOW WHAT?
'125355			THE LAST ROMANCE



'RENAISSANCE SERIES

'If patron buys 1 ticket to this season subscription event:
 
'Event Code		Event Name
'-----------------------
'846795			Subscription Package Flex - Renaissance

'they are entitled to 3 discounted tickets to any event of the following acts:

'Act Code		Act Name
'-----------------------
'125183			REX'S EXES
'125185			SQUABBLES
'125356			SWEET CHARITY



'BOTH SERIES

'If patron buys 1 ticket to this season subscription event:
 
'Event Code		Event Name
'-----------------------
'846793			Subscription Package Flex - Both

'they are entitled to 6 discounted tickets to any event of the following acts:

'Act Code		Act Name
'-----------------------
'125182			NOISES OFF
'125184			SIDE EFFECTS
'125186			THE ACTRESS
'125187			THE ADDAMS FAMILY
'125354			THE KIDS LEFT. THE DOG DIED. NOW WHAT?
'125355			THE LAST ROMANCE

'and they are also entitled to 3 discounted tickets to any event of the following acts:

'Act Code		Act Name
'-----------------------
'125183			REX'S EXES
'125185			SQUABBLES
'125356			SWEET CHARITY



'Eligible Ticket Type
'--------------------
'Discount applied to all ticket types


'Eligible Price Tier/Section
'---------------------------
'Discount applied to all sections / price tiers


'Offline/Online
'-------------
'Discount applied to both online and offline orders


'Service Fees
'-------------
'Discounted tickets will have a surcharge of $0.00 per ticket


'Automatic/Code Entry
'---------------------
'Automatic Discount: code entry not required


'Discount Code
'--------------
'2016sub


'Expiration
'----------
'No expiration


'Discount Limits
'---------------
'Discount will be applied to all eligible tickets
'on each order

'Purchase of multiple subscriptions will increase the number  of 
'discounted tickets


%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'ErrorLog(":: Discount Error Message")

'---------------------------------------------------------

'Discount Variables

DIM CustomerNumber
CustomerNumber = fnCustomerNumber
'ErrorLog(":: Customer Number: " & CustomerNumber & "")

'Subscription Event Codes
DIM SubscriptionA 
DIM SubscriptionB 
DIM SubscriptionC

SubscriptionA		=	846980 	'6 ticket Season Subscription
SubscriptionB		= 	846982 	'3 ticket Season Subscription
SubscriptionC		= 	846981 	'9 ticket Season Subscription


'Subscription Series Act Codes
DIM ActSubA
DIM ActSubB

ActSubA 			= 	"125182,125184,125186,125187,125354,125355"
ActSubB				= 	"125183,125185,125356"


'Subscription Series Act Count
DIM SeriesCountA 
DIM SeriesCountB

SeriesCountA		= 6
SeriesCountB		= 3


'Number of Subscriptions
DIM NbrSubA 
DIM NbrSubB

NbrSubA				= 	0
NbrSubB				= 	0


'Subscription Series Discount
DIM SeriesPercentage
SeriesPercentage	= 	100

'---------------------------------------------------------

	If AllowDiscount = "Y" Then 'It's okay to apply to this order.
	
		'Determine how the subscription events which have been purchased (either in the past 365 days or on this order)
		'Calculate the number of discounted tickets allowed
		SQLMemberCurrent = "SELECT Event.EventCode, Orderline.ItemNumber FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE (Event.EventCode IN (" & SubscriptionA & "," & SubscriptionB & "," & SubscriptionC & ")  AND OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.StatusCode = 'R') OR (Event.EventCode IN (" & SubscriptionA & "," & SubscriptionB & "," & SubscriptionC & ") AND OrderHeader.CustomerNumber = " & CustomerNumber & " AND OrderLine.StatusCode = 'S' AND GetDate() < (DateAdd(Day, 365, OrderHeader.OrderDate)))"
		Set rsMemberCurrent = OBJdbConnection.Execute(SQLMemberCurrent)

			If Not rsMemberCurrent.EOF Then

				Do While Not rsMemberCurrent.EOF
		   
					Select Case rsMemberCurrent("EventCode")
					
						Case	SubscriptionA
								NbrSubA 			= NbrSubA 		+ SeriesCountA

						Case	SubscriptionB
								NbrSubB				= NbrSubB 		+ SeriesCountB
								
						Case	SubscriptionC
								NbrSubA 			= NbrSubA 		+ SeriesCountA
								NbrSubB				= NbrSubB 		+ SeriesCountB
						
					End Select
					 
				rsMemberCurrent.MoveNext	
				Loop
					
			End If
			
		rsMemberCurrent.Close
		Set rsMemberCurrent = nothing	
		
		'ErrorLog(":: NbrSubA: " & NbrSubA & "")
		'ErrorLog(":: NbrSubB: " & NbrSubB & "")
		
		'If a subscription was found, process the discount
		If NbrSubA > 0 OR NbrSubB > 0 Then
		
			Call ProcessDiscount
			Call ProcessSurcharge
			
		End If
		

	End If	

	Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
	Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
	Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
	Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

'---------------------------------------------------------

	Sub ProcessDiscount
	
		'Determine the current act code
		SQLAct = "SELECT Event.ActCode, Act.Act, Event.EventDate FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode WHERE EventCode = " & EventCode & ""
		Set rsAct = OBJdbConnection.Execute(SQLAct)
		ActCode = rsAct("ActCode")
		Act = rsAct("Act")
		EventDate = rsAct("EventDate")
		rsAct.Close
		Set rsAct = nothing

		''ErrorLog(":: Act: " & Act & "")
		
		'Process discounts for this series
		If NbrSubA > 0 Then 
		
			'Count the number of tickets already discounted for this series
			SQLApplied = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE (CustomerNumber = " & CustomerNumber & " AND ActCode IN (" & ActSubA & ") AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.StatusCode = 'S') OR (OrderLine.OrderNumber = " & OrderNumber & " AND ActCode IN (" & ActSubA & ") AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.StatusCode = 'R')"
			Set rsApplied = OBJdbConnection.Execute(SQLApplied)	
			AppliedCountA = rsApplied("TicketCount")		
			rsApplied.Close
			Set rsApplied = nothing
	
			'Determine if current act code belongs to this series
			'Determine if there are discounts available 
			If fnFindAct(ActCode,ActSubA) Then
				'ErrorLog(":: SubA Act Found " & Act & "")	
				If AppliedCountA < NbrSubA Then				
					NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(SeriesPercentage)/100), 2)	
					DiscountAmount = Round(Clean(Request("Price")),2) - NewPrice
					AppliedFlag = "Y"
				End If				
			End If
											
		End If
		
		'Process discounts for this series
		If NbrSubB > 0 Then 
		
			'Count the number of tickets already discounted for this series
			SQLApplied = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE (CustomerNumber = " & CustomerNumber & " AND ActCode IN (" & ActSubB & ") AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.StatusCode = 'S') OR (OrderLine.OrderNumber = " & OrderNumber & " AND ActCode IN (" & ActSubB & ") AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.StatusCode = 'R')"
			Set rsApplied = OBJdbConnection.Execute(SQLApplied)	
			AppliedCountB = rsApplied("TicketCount")		
			rsApplied.Close
			Set rsApplied = nothing
	
			'Determine if current act code belongs to this series
			'Determine if there are discounts available
			If fnFindAct(ActCode,ActSubB) Then
				'ErrorLog(":: SubB Act Found " & Act & "")	
				If AppliedCountB < NbrSubB Then				
					NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(SeriesPercentage)/100), 2)	
					DiscountAmount = Round(Clean(Request("Price")),2) - NewPrice
					AppliedFlag = "Y"
				End If				
			End If
											
		End If
		
		
	End Sub

'---------------------------------------------------------

	Sub ProcessSurcharge

		If AppliedFlag = "Y" Then

			If NewSurcharge <> "" Then
				Surcharge = NewSurcharge
			ElseIf Request("CalcServiceFee") <> "N" Then
				Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
			End If
			
		End If
			
	End Sub
	
'---------------------------------------------------------

	Public Function fnCustomerNumber

		'this function returns the customer number attached to this order

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

		'this function requires an actcode and a list of actcodes passed to it.
		'it then returns a Boolean value that indicates whether the specified actcode was found

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