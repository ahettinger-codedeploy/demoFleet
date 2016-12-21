
<%

'CHANGE LOG
'SSR 8/7/2012 -Custom Discount Code

%>

<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'==================================================

'Clinton County Chamber of Commerce
'Group Discount

'Groups of 6 or more Adult tickets should be discounted a total of $65 per order.
'Example: 6 Adult x $45 face value = $270 - $65 discount = $205
'Example: 10 Adult x $45 face value = $450 - $65 discount = $450


'==================================================

'Initialize Variables
DiscountTypeNumber = Clean(Request("DiscountTypeNumber"))
EventCode = Clean(Request("EventCode"))
OrderNumber = Clean(Request("OrderNumber"))
Price = Clean(Request("Price"))
Surcharge = Clean(Request("Surcharge"))
AppliedFlag = "N"


'Initialize Discount Parameters

SeriesCount = 6 
GroupDiscount = 65
ReqSeatCode = 1

'==================================================

If AllowDiscount = "Y" Then 'It's okay to apply to this order.

    'Determine number of required tickets on order
    SQLEventCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Orderline.SeatTypeCode = " & ReqSeatCode & " AND Seat.EventCode = " &  EventCode & " "
    Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)
    nbrTickets = rsEventCount("SeatCount")
    rsEventCount.Close
    Set rsEventCount = nothing

    'Determine if there are enough tickets to qualify for the discount
    If nbrTickets => SeriesCount Then 

        'Determine number of tickets per event on this order which have been given a discounted price
        SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.SeatTypeCode = " & ReqSeatCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " "
        Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)

        If rsDiscCount("LineCount") < SeriesCount Then	
					
	        'Count number of tickets which have been given a discount
            SQLCount = "SELECT COUNT(OrderLine.ItemNumber) AS AppliedCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND OrderLine.SeatTypeCode = " & ReqSeatCode & " AND DiscountTypeNumber = " & DiscountTypeNumber
            Set rsCount = OBJdbConnection.Execute(SQLCount)
            Count = rsCount("AppliedCount")
            rsCount.Close
            Set rsCount = nothing  						
					
	        Remainder = Count MOD SeriesCount				        
				        
            If Remainder = SeriesCount - 1 Then 
                DiscountAmount = GroupDiscount - ((SeriesCount - 1) * Round(GroupDiscount/SeriesCount, 2))
            Else
                DiscountAmount = Round(GroupDiscount/SeriesCount, 2)
            End If
			
            NewPrice = Clean(Request("Price")) - DiscountAmount	

            If NewPrice < 0 Then
                NewPrice = 0
            End If
    		    
            If Price > NewPrice Then
                AppliedFlag = "Y"
            End If	 

            Surcharge = 0

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