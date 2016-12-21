<%

'CHANGE LOG - Inception
'SSR 12/20/2011
'Custom Code 

%>

<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->
<%

'===============================================

'Anderson Paramount (12/20/2011)

'Buy 1 Adult And Get 1 Child Free 
'Box Office Use Only

'===============================================

RequiredSeatList = "1"  'Adult, Senior, Military

RequiredPaid = 1

OfferSeatType = "5" 'Child (12 & under) 

OfferFree = 1

ValidOrderType = "1"

'===============================================


If AllowDiscount = "Y" Then 'It's okay to apply to this order.

If Clean(Request("OrderTypeNumber")) <> ValidOrderType  Then 

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
			            NewSurcharge = 0
			            DiscountAmount = Price - NewPrice
			            AppliedFlag = "Y"
		            End If
        		
		        rsDiscCount.Close
		        Set rsDiscCount = nothing
		        
                If NewSurcharge <> "" Then
                    Surcharge = NewSurcharge
                Else
                    If Request("CalcServiceFee") <> "N" Then
                        Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, Clean(Request("EventCode")), Clean(Request("ItemType")))
                    End If
                End If

        End If
        
 End If

End If
					
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf


%>

