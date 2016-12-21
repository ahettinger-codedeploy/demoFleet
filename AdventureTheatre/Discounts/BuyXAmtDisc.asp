<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'Adventure Theatre (7/19/2010)
'=============================
'$5.00 off each ticket
'Must have 2 tickets to any event on the order 
'Maximum of 2 tickets discounted per order
'Discount can only be used once per customer.
'GARDEN10 code needs to be entered in order to receive discount.
'Online and offline.
'Do not re-calculate per ticket fees.

'Excluded from discount: Adventure Theatre Flex Pass 2010-2011 Season & Voucher 


'Discount Parameters
DiscountAmount = 5
QtyToDisc = 2

'Determine number of tickets on order per event
SQLEventCount = "SELECT COUNT(Seat.ItemNumber) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " "
Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)
nbrTickets = rsEventCount("SeatCount")
rsEventCount.Close
Set rsEventCount = nothing

'Determine if there are enough tickets to qualify for the discount
If nbrTickets >= QtyToDisc Then 

    'Determine number of tickets per event on this order which have been given a discounted price
    SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " "
    Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
    							
    'Determine if this ticket receives a discount							
    If (rsDiscCount("LineCount")/ NbrTickets) < (QtyToDisc / NbrTickets) Then 

        If Clean(Request("Price")) > 0 Then			
        NewPrice = (Price - DiscountAmount)			
        AppliedFlag = "Y"
        End If

        If NewPrice < 0 Then
            NewPrice = 0
        End If
   							
        rsDiscCount.Close
        Set rsDiscCount = nothing

        If Request("CalcServiceFee") <> "N" Then
	         Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, Clean(Request("EventCode")), Clean(Request("ItemType")))
        End If
        
    End If
							
End If


					
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>