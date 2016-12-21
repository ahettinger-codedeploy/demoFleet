<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'Moffly Publications (6/4/2010)
'==================================
'Buy X Get Y Discount Fixed Price Discount

'Buy 4 tickets Get 1 ticket free  (5 tickets in the shopping cart)
'Buy 5 tickets Get 2 tickets free (7 tickets in the shopping cart)

'Per my discussion with Silvia on 6/5/2010:
'Discount is not calculated on sum total of X, not multiples of X
'Example: 7 tickets get 2 free, 14 tickets get 2 free.



SQLCount = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.Price >= " & Price & " AND OrderLine.Price > 0 AND EventCode = " & EventCode
Set rsCount = OBJdbConnection.Execute(SQLCount)
nbrTickets = rsCount("TicketCount")
rsCount.Close
Set rsCount = nothing

If NbrTickets => 7 Then
    QtyFree = 2
ElseIf NbrTickets => 5 Then
    QtyFree = 1
End If

If NbrTickets => QtyToBuy Then

	    'Count # of existing seats which have discount applied.
        SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber 
	    Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
	
	    If rsDiscCount("LineCount") < QtyFree Then 'Apply the discount
		    NewPrice = 0
		    DiscountAmount = Price - NewPrice
		    Surcharge = 0
		    AppliedFlag = "Y"
	    End If
	    
	    rsDiscCount.Close
	    Set rsDiscCount = nothing        

End If

					
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>