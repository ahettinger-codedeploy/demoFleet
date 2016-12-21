<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'Adventure Theatre (6/16/2010)
'=============================
'4 Tier Group Discount - by Amount

'10-19 tickets purchased: $1.00 off
'20-49 tickets purchased: $2.00 off
'50-99 tickets purchased: $3.00 off
'100+ tickets purchased: $4.00 off


'New Service fee of.50 per ticket

AppliedFlag = "N"
NewSurcharge = .50

If AllowDiscount = "Y" Then 'It's okay to apply to this order.

	SQLEventCount = "SELECT COUNT(Seat.EventCode) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & CleanNumeric(Request("OrderNumber")) & " AND Seat.EventCode = " & CleanNumeric(Request("EventCode")) & " "
	    Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)
        TicketCount = rsEventCount("TicketCount")    
        rsEventCount.Close
    Set rsEventCount = nothing
    
    
    If Ticketcount >= 10 Then      
    
        If TicketCount >= 10 And TicketCount <= 19 Then
            NewPrice = Price - 1.00            
        ElseIf TicketCount >= 20 And TicketCount <= 49 Then
            NewPrice = Price - 2.00            
        ElseIf TicketCount >= 50 And TicketCount <= 99 Then
            NewPrice = Price - 3.00            
        ElseIf TicketCount >= 100 Then
            NewPrice = Price - 4.00            
        End If


	    If Price > NewPrice Then
		    DiscountAmount = Price - NewPrice
		End If
	    
		Surcharge = NewSurcharge
		
		AppliedFlag = "Y"
		
	End If
	
End If	

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>