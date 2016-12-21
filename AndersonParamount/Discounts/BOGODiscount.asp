<%
'SSR 1/29/2013
'Changed the child seat type child/student seat type from 659 Child/Student to 5 Child(12 & Under)

'SSR 5/15/2012
'Changed the child seat type child/student seat type

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

Online = 1

RequiredSeatList = "1"  'Adult, Senior, Military
RequiredPaid = 1

OfferSeatType = "5" 'Child (12 & under)

OfferFree = 1

'========================================

'Discount is valid for offline orders only
If Clean(Request("OrderTypeNumber")) <> Online Then 

        'Determine the number of Required Tickets on order
        SQLCount = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ItemType = 'Seat' AND EventCode = " & EventCode & " AND OrderLine.SeatTypeCode IN (" & RequiredSeatList & " )"
        Set rsCount = OBJdbConnection.Execute(SQLCount)
        nbrTickets = rsCount("TicketCount")
        rsCount.Close
        Set rsCount = nothing

        'Determine that the required number of paid tickets are on the order
        If NbrTickets >= RequiredPaid Then 
        
		        'Count the number of existing Offer seats which have had the discount applied.
		        SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber  & " AND OrderLine.SeatTypeCode = " & OfferSeatType & ""
		        Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
		        
                'Apply the discount
		        If Fix(rsDiscCount("LineCount")) < (Fix(NbrTickets) * OfferFree) And SeatTypeCode = OfferSeatType  Then 
			        
			        NewPrice = 0			        
			        DiscountAmount = Clean(Request("Price")) - NewPrice			        			        
                    Surcharge = 0			        
			        AppliedFlag = "Y"
			        
		        End If
        		
		        rsDiscCount.Close
		        Set rsDiscCount = nothing

        End If

End If
					
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>