<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'Duke City Rep (8/18/2010)
'===========================
'Couple Subscription Discount 

'Buy two season subscriptions for $120.00
'Discount only given on pairs
'No change to service fees
'Attached to all the subscription evnets
'Discount code required

'Discount Variables
CouplePrice = 120

'===========================

SQLEventCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.ItemType = 'SubFixedEvent' AND OrderLine.OrderNumber = " & OrderNumber & " AND Seat.EventCode = " & EventCode & " "
Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)

If Not rsEventCount.EOF Then

        If rsEventCount("SeatCount") >= 2 Then
        	
                SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.ItemType = 'SubFixedEvent' AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber 
                Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)

                If Int(rsDiscCount("LineCount") / 2) < Int(rsEventCount("SeatCount") / 2) Then 	
                        NewPrice = (CouplePrice/2)
                        If Price > NewPrice Then
                            DiscountAmount = Clean(Request("Price")) - NewPrice
                            AppliedFlag = "Y"
                        Else
                            NewPrice = Price
                        End If  
                End If	
        		
        End If
	
End If
				
rsEventCount.Close
Set rsEventCount = nothing


Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>

