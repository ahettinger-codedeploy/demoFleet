<%


'CHANGE LOG

'SSR  03/30/15 - Created custom discount script
'SSR  04/02/15 - Updated discounts script
'SSR  06/01/15 - Updated to allow discount on child events when the subscription event has not yet been purchased, but is the shopping cart along with the child events.

'============================================================

'Flagler Playhouse

'2015-2016 Full Season Subscription
'2015-2016 Half Season Subscription


'Required Events
'---------------
'If patron buys 1 ticket to a season subscription event, they are entitled 
'to 1 discounted ticket to each of the season acts at 100% off.

'EventCode  Name 
'771098 	 2015 Full Season Subscription
'771099 	 2015 Half Season Subscription


'Eligible Acts
'---------------
'ACT CODE	ACT NAME
'104401		Funny Comedy
'54785		Serious Drama
'54885		Broadway Musical
'54887		Shakespeare Play





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
'2016sub


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

ErrorLog("Discount Start 309")

'Variables

DIM CustomerNumber

CustomerNumber = fnCustomerNumber

DIM SubscriptionA 
DIM SubscriptionB 

SubscriptionA		=	771098 	 '2015 Full Season Subscription
SubscriptionB		= 	771099 	 '2015 Half Season Subscription

DIM ActSubA(3)
DIM ActSubB(1)

ActSubA(0) 			= 	104401		'Funny Comedy
ActSubA(1) 			= 	54785		'Serious Drama
ActSubA(2) 			= 	54885		'Broadway Musical
ActSubA(3) 			= 	54887		'Shakespeare Play 	

ActSubB(0) 			= 	54785		'Serious Drama
ActSubB(1) 			= 	54887		'Shakespeare Play 	

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
	SQLMemberCurrent = "SELECT Event.EventCode, Orderline.ItemNumber FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE (Event.EventCode IN (" & SubscriptionA & "," & SubscriptionB & ")  AND OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.StatusCode = 'R') OR (Event.EventCode IN (" & SubscriptionA & "," & SubscriptionB & ") AND OrderHeader.CustomerNumber = " & CustomerNumber & " AND OrderLine.StatusCode = 'S' AND GetDate() < (DateAdd(Day, 365, OrderHeader.OrderDate)))"
	Set rsMemberCurrent = OBJdbConnection.Execute(SQLMemberCurrent)

		If Not rsMemberCurrent.EOF Then

			Do While Not rsMemberCurrent.EOF
	   
				Select Case rsMemberCurrent("EventCode")
				
					'Full Subscription
					Case	SubscriptionA
							NbrSubA 			= NbrSubA 		+ 1
							NbrSubB				= NbrSubB 		+ 1

					'Half Subscription
					Case	SubscriptionB
							NbrSubB				= NbrSubB 		+ 1
					
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
	
	
	ErrorLog("Act: " & Act & "")
	
	'Count the number of discounted tickets for this act code
	SQLApplied = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE (CustomerNumber = " & CustomerNumber & " AND ActCode = " & ActCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.StatusCode = 'S') OR (OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ActCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.StatusCode = 'R')"
	Set rsApplied = OBJdbConnection.Execute(SQLApplied)	
		AppliedCount = rsApplied("TicketCount")		
	rsApplied.Close
	Set rsApplied = nothing
	
	'ErrorLog("AppliedCount: " & AppliedCount & "")
	
	'---------------------------------------------------------

	If NbrSubA > 0 Then 
	
	ErrorLog("NbrSubA: " & NbrSubA & "")
	
			If fnFindAct(ActCode,ActSubA) Then 
				ErrorLog("act found")
			
				If AppliedCount < NbrSubA Then	
					ErrorLog("AppliedCount: " & AppliedCount& "")
					NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(SeriesPercentage)/100), 2)	
					AppliedFlag = "Y"
				End If
			End If
											
	End If
	
	'---------------------------------------------------------

	If NbrSubB > 0 Then 
			
			If fnFindAct(ActCode,ActSubB) Then 
				If AppliedCount < NbrSubB Then				
					NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(SeriesPercentage)/100), 2)	
					AppliedFlag = "Y"
				End If
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