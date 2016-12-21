<%


'CHANGE LOG

'SSR  10/26/15 - Created custom discount script

'============================================================

'CK PRODUCTIONS

'2015 Past Event Discount

'Required Events
'---------------
'If patron buys 1 ticket to a subscription event, they are entitled 
'to a specific number of discounted tickets to each of the productions that make up a series.

'2015 Past Event Discount

'Subscription Events
'===========================
'Event		Event					Main Series	Children Series
'Code		Name					Tickets		Tickets
'795165 	Single Season Pass	 	1 			1
'795166		Couples Season Pass	 	2			2 
'795167		Family of 4 Pass	 	4			4 
'795168		Family of 6 Pass		6			6
'795169		Main Stage Pass			1			0
'795170		Children's Theatre Pass	0			1 


'Main Stage Series
'===========================
'Act Code	Act Name
'121176		Annie
'121355		Clybourne Park
'121356		In The Heights
'121178		Lost in Yonkers
'121357		The Wedding Singer


'Children Series
'===========================
'Act Code	Act Name
'121177		Experience the Magic
'121359		James & The Giant Peach
'121361		Junie B. Jones
'121360		Shrek
'121358		Wizard of Oz


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


%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%


'---------------------------------------------------------
'Variables

DIM CustomerNumber
CustomerNumber = fnCustomerNumber

DIM SubscriptionList
SubscriptionList = "795165,795166,795167,795168,795169,795170"

DIM ActSubA(4)
DIM ActSubB(4)

'Main Stage Season
ActSubA(0) 			= 	121176 'Annie
ActSubA(1) 			= 	121355 'Clybourne Park
ActSubA(2) 			= 	121356 'In The Heights
ActSubA(3) 			= 	121178 'Lost in Yonkers
ActSubA(4) 			= 	121357 'The Wedding Singer
	
'Children's Theatre Season
ActSubB(0) 			= 	121177 'Experience the Magic
ActSubB(1) 			= 	121359 'James & The Giant Peach
ActSubB(2) 			= 	121361 'Junie B. Jones
ActSubB(3) 			= 	121360 'Shrek
ActSubB(4) 			= 	121358 'Wizard of Oz

DIM NbrSubA 
DIM NbrSubB

NbrSubA				= 	0
NbrSubB				= 	0

DIM SeriesPercentage
SeriesPercentage	= 	100

'---------------------------------------------------------

If CustomerNumber = 1 OR CustomerNumber = "" Then
	AllowDiscount = "N"
End If

If AllowDiscount = "Y" Then 'It's okay to apply to this order.

	'Determine how many of the subscription events have been purchased
	SQLMemberCurrent = "SELECT Event.EventCode, Orderline.ItemNumber FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE (Event.EventCode IN (" & SubscriptionList & ")  AND OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.StatusCode = 'R') OR (Event.EventCode IN (" & SubscriptionList & ") AND OrderHeader.CustomerNumber = " & CustomerNumber & " AND OrderLine.StatusCode = 'S' AND GetDate() < (DateAdd(Day, 365, OrderHeader.OrderDate)))"
	Set rsMemberCurrent = OBJdbConnection.Execute(SQLMemberCurrent)

		If Not rsMemberCurrent.EOF Then

			Do While Not rsMemberCurrent.EOF
	   
				Select Case rsMemberCurrent("EventCode")
				
					Case 795165 '2015 Single Season Pass
						NbrSubA 			= NbrSubA 		+ 1
						NbrSubB				= NbrSubB 		+ 1

					Case 795166 '2015 Couples Season Pass
						NbrSubA 			= NbrSubA 		+ 2
						NbrSubB				= NbrSubB 		+ 2 

					Case 795167 '2015 Family of 4 Pass
						NbrSubA 			= NbrSubA 		+ 4
						NbrSubB				= NbrSubB 		+ 4 

					Case 795168 '2015 Family of 6 Pass
						NbrSubA 			= NbrSubA 		+ 6
						NbrSubB				= NbrSubB 		+ 6 

					Case 795169 '2015 Main Stage Season Pass
						NbrSubA 			= NbrSubA 		+ 1
						NbrSubB				= NbrSubB 		+ 0 

					Case 795170 '2015 Children's Theatre Season Pass
						NbrSubA 			= NbrSubA 		+ 0
						NbrSubB				= NbrSubB 		+ 1 

				End Select
				 
			rsMemberCurrent.MoveNext	
			Loop
				
		End If
		
	rsMemberCurrent.Close
	Set rsMemberCurrent = nothing
		
	'---------------------------------------------------------
	
	'Determine the act code
	SQLAct = "SELECT Event.ActCode, Act.Act, Event.EventDate FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode WHERE EventCode = " & EventCode & ""
	Set rsAct = OBJdbConnection.Execute(SQLAct)
		ActCode = rsAct("ActCode")
		Act = rsAct("Act")
		EventDate = rsAct("EventDate")
	rsAct.Close
	Set rsAct = nothing
	
	
	'Count the number of discounted tickets for this act code
	SQLApplied = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE (CustomerNumber = " & CustomerNumber & " AND ActCode = " & ActCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.StatusCode = 'S') OR (OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ActCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.StatusCode = 'R')"
	Set rsApplied = OBJdbConnection.Execute(SQLApplied)	
		AppliedCount = rsApplied("TicketCount")		
	rsApplied.Close
	Set rsApplied = nothing
	
	'---------------------------------------------------------

	'Determine if there are any Series A subscriptions
	
	If NbrSubA > 0 Then 
			
			'Determine if this act code belongs to Series A
			'then decide if discounts can still be applied
			
			If fnFindAct(ActCode,ActSubA) Then 
				If AppliedCount < NbrSubA Then				
					NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(SeriesPercentage)/100), 2)	
					AppliedFlag = "Y"
				End If
			End If
											
	End If
	
	'---------------------------------------------------------
	
	'Determine if there are any Series B subscriptions

	If NbrSubB > 0 Then 
	
			'Determine if this act code belongs to Series B
			'then decide if discounts can still be applied
			
			If fnFindAct(ActCode,ActSubB) Then 
				If AppliedCount < NbrSubB Then				
					NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(SeriesPercentage)/100), 2)	
					AppliedFlag = "Y"
				End If
			End If
											
	End If
	
	'---------------------------------------------------------
	
	'Apply the discount
		
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

	'This function will return the ticket buyer customer number

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

  'This function needs to have an actcode and an array of actcodes passed to it.
  'it checks to see if the actcode can be found in the array
  'it returns a Boolean value as the result to indicate whether the specific actcode was found

  fnFindAct = False
  
  For i=0 To Ubound(arrActs)
     If Trim(arrActs(i)) = Trim(strAct) Then
        fnFindAct = True
        Exit Function      
     End If 
  Next
  
End Function

'---------------------------------------------------------

%>