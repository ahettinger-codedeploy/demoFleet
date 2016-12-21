<%

'CHANGE LOG - Inception
'SSR 6/1/2011
'Custom Discount Code Created.
'Standard BOGO only allows restriction of offer ticket
'This code allows restriction of required ticket.

%>

<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'========================================

'Anderson Paramount (6/1/2011)

'Buy 1 Adult And Get 1 Child Free 
'Offline Use Only


'Initialize Variables
NewPrice = Clean(Request("Price"))
Price = Clean(Request("Price"))
Surcharge = Clean(Request("Surcharge"))
OrderNumber = Clean(Request("OrderNumber"))
EventCode = Clean(Request("EventCode"))
DiscountTypeNumber = Clean(Request("DiscountTypeNumber"))
SeatTypeCode = Clean(Request("SeatTypeCode"))
AppliedFlag = "N"

Percentage = 10

RequiredSeatList = "16"  'Adult, Senior, Military
RequiredPaid = 1

OfferSeatType = "24" 'Student (with Current ID)
OfferFree = 1

'========================================

'Discount is valid for Offline use only

If SeatTypeCode = 24 Then

        'Determine the number of Required Tickets on order
        SQLCount = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ItemType = 'Seat' AND EventCode = " & EventCode & " AND OrderLine.SeatTypeCode IN (" & RequiredSeatList & " )"
        Set rsCount = OBJdbConnection.Execute(SQLCount)
        nbrTickets = rsCount("TicketCount")
        rsCount.Close
        Set rsCount = nothing


        If NbrTickets >= RequiredPaid Then 'Need to have at least one ticket on order

		        'Count the number of existing Offer seats which have had discount applied.
		        SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber  & " AND OrderLine.SeatTypeCode = " & OfferSeatType & ""
		        Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)

		        If Fix(rsDiscCount("LineCount")) < (Fix(NbrTickets) * OfferFree) And SeatTypeCode = OfferSeatType  Then 'Apply the discount
			        NewPrice = 0
			        DiscountAmount = Price - NewPrice
			        AppliedFlag = "Y"
		        End If
        		
		        rsDiscCount.Close
		        Set rsDiscCount = nothing

        End If

End If

If SeatTypeCode = 16 Then

SQLEventCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Clean(Request("OrderNumber")) & " AND Seat.EventCode = " & Clean(Request("EventCode"))
Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)

If Not rsEventCount.EOF Then
		
		If rsEventCount("SeatCount") => 10  Then	
		
				If SeatTypeCode = 16 Then
				
					NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Percentage)/100), 2)
					DiscountAmount = Clean(Request("Price")) - NewPrice
					AppliedFlag = "Y" 
				
				End If
			
		End If
                			
End If
						
rsEventCount.Close
Set rsEventCount = nothing

End If
					
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>