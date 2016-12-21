<%
'CHANGE LOG - Inception
'SSR 3/22/2011
'Buy X Adult Get Y Child Free Discount Created

%>

<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->

<%

'========================================================

'Calvary Temple Church (11/26/2012)

'Buy 1 Adult Get 4 Child Discounted

'SilviaTIX: can you please make a quick update for me?
'sergiotix: sure..
'SilviaTIX: the family pack discount for calvary temple...
'SilviaTIX: needs to be updated with the new ticket types that have been added to that event
'sergiotix: sure thing..
'SilviaTIX: /calvarytemple/discounts/FamilyPackDiscount.asp
'SilviaTIX: new adult ticket type list = 7249, 7251
'SilviaTIX: new child ticket type list = 7408, 7406
'SilviaTIX: please make that discount update as soon as you are able

'Valid Adult Ticket Types
'General Adult (7251)
'Premium Adult (7249)

'Valid Child Ticket Types	
'General Child (7406)
'Premium Child (7408)	

'-------------------------------------------------------

'Calvary Temple Church (10/05/2012)

'Buy 1 Adult Get 4 Child Discounted

'We need a custom discount for Calvary Temple Church

'Parameters

'Buy at least one full priced Adult ticket, get up to 4 Child tickets at 50% off

'Eligible ActCodes / EventCodes: 'Event Code: 512590
'Offline/Online: Online and Offline
'Service Fees: Do not re-calculate service fees
'Additional Tickets: Maximum of 4 discounted child tickets per order
'Automatic/Code Entry: Discount should be applied automatically
'Expiration: No expiration
'Restrictions: n/a

'Contact: Nia Jusuf
'nia@calvarytemple.org

'Client Description
'We have special price for Saturday, Dec. 8
'ALL child ticket is 50% off, max. 4 tickets with one full price adult.

'-------------------------------------------------------

'Valid Adult Ticket Types
'General Adult (7251)
'Premium Adult (7249)

'Valid Child Ticket Types
'General Senior/Child (7252)
'Premium Senior/Child (7250)

'========================================================
'Initialize Variables

Price = Clean(Request("Price"))
NewPrice = Price
DiscountAmount = 0
Surcharge = Clean(Request("Surcharge"))
AppliedFlag = "N"
OrderNumber = Clean(Request("OrderNumber"))
SeatTypeCode = Clean(Request("SeatTypeCode"))
EventCode = Clean(Request("EventCode"))
DiscountTypeNumber = Clean(Request("DiscountTypeNumber"))

'========================================================
'Discount Variables

AdultSeatList 	= "7251,7249"		'Valid Adult Ticket Types
ChildSeatList 	= "7406,7408"		'Valid Child Ticket Types

AdultMin 		= 1		'Minimum number of required Adult Tickets
ChildMax 		= 4		'Maximum number of discounted Child Tickets

Percentage 		= 50	'Percentage Discount for Child Tickets	



'========================================================

'Determine # of Adult Tickets on order
SQLCount = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ItemType = 'Seat' AND EventCode = " & EventCode & " AND OrderLine.SeatTypeCode IN (" & AdultSeatList & " )"
Set rsCount = OBJdbConnection.Execute(SQLCount)
NbrTickets = rsCount("TicketCount")
rsCount.Close
Set rsCount = nothing

If NbrTickets >= AdultMin Then 

	'Determine number of existing Child seats which have had discount applied.
	SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber  & " AND OrderLine.SeatTypeCode IN (" & ChildSeatList & ")"
	Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)

		If Fix(rsDiscCount("LineCount")) < (Fix(NbrTickets) * ChildMax) Then 'Apply the discount
		
			Select Case SeatTypeCode
				Case 7406,7408
					NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Percentage)/100), 2)     		            
					If Price > NewPrice Then
						DiscountAmount = Clean(Request("Price")) - NewPrice
						AppliedFlag = "Y"
					End If 
			End Select
		
		End If

	rsDiscCount.Close
	Set rsDiscCount = nothing

End If

					
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>