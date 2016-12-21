<%

'CHANGE LOG - Inception
'SSR 09/12/11 Custom Discount Code
'SSR 09/02/14 - Updated Discount Code

%>

<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'========================================================

'Anderson Symphony Orchestra
'Family Pack Discount

'SilviaTIX: omg!
'SilviaTIX: dana stone is killing me
'SilviaTIX: killing me
'sergiotix: Anderson Symphony?
'SilviaTIX: yes
'sergiotix: what is she asking for?
'SilviaTIX: she sent in a discount code request
'SilviaTIX: i asked follow-up questions...one week ago!
'SilviaTIX: just got the answers today
'SilviaTIX: and, of course, she wants it available for tomorrow
'SilviaTIX: she copied you on the initial email
'sergiotix: want me to knock it out real quick?
'SilviaTIX: it seems simple, but let me take a quick look
'sergiotix: is it a subscription?
'SilviaTIX: free student with paid adult, plus the adult ticket gets 20% off
'sergiotix: omg
'SilviaTIX: what?
'sergiotix: super easy
'SilviaTIX: okay...let me write it up


'Client would like  a discount that does the following:
'1 Free Student Ticket (any section) with the Purchase of 1 Adult Ticket (any section)
'AND we’d like the adult tickets in the order to be 20% off.
'Code Name: ForKids
'Active after October 2 and through March 2013.
'Attach to Halloween 10/27 ASO, Christmas 12/8 ASO, Legend Rituals and Folklore 2/9 ASO
'Do not recalc the fees

'-------------------------------------------------------------

'Discount Parameters

AdultSeatList = "1,27"
AdultPaid = 1

ChildSeatType = "6"
ChildFree = 1
ChildPercentage = 100

AppliedFlag = "N"


'=================================================================

	'Determine number of Adult Tickets 
	SQLCount = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ItemType = 'Seat' AND EventCode = " & EventCode & " AND OrderLine.SeatTypeCode IN (" & AdultSeatList & " )"
	Set rsCount = OBJdbConnection.Execute(SQLCount)
	NbrTickets = rsCount("TicketCount")
	rsCount.Close
	Set rsCount = nothing

	If NbrTickets >= AdultPaid Then 'Need to have at least one ticket on order

			'Determine number of Child tickets which have been discounted
			SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber  & " AND OrderLine.SeatTypeCode IN (" & ChildSeatType & ")"
			Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)

			If Fix(rsDiscCount("LineCount")) < (Fix(NbrTickets) * ChildFree) Then 'Apply the discount
			
				Select Case SeatTypeCode
					Case ChildSeatType
					NewPrice = 0
				End Select
		   
		   Else
		   
				Select Case SeatTypeCode
					Case ChildSeatType
					NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(ChildPercentage)/100), 2)
				End Select
				
		   End If
		   
			
			If Price > NewPrice Then
				DiscountAmount = Clean(Request("Price")) - NewPrice
				AppliedFlag = "Y"
			End If
				
				
			If Request("NewSurcharge") <> "" Then
				Surcharge = NewSurcharge
			Else
				If Request("CalcServiceFee") <> "N" Then
					Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, Clean(Request("EventCode")), Clean(Request("ItemType")))
				End If
			End If
			
			
		   rsDiscCount.Close
		   Set rsDiscCount = nothing

	End If

					
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>