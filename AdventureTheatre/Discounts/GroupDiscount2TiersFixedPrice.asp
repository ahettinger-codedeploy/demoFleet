<%

'CHANGE LOG - Inception
'SLM 5/21/2011
'Discount Created 

%>

<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%



'==================================================
'Discount Variables

'This discount counts tickets across all events, regardless of production or event date

'1st Price Tier
'4 tickets
Series3Count = 4
Series3Disc = 18

'2nd Price Tier
'8 tickets 
Series4Count = 8
Series4Disc = 16

SeriesDiscountCode = "58222"

'==================================================

If AllowDiscount = "Y" Then

    'Determine the total number of tickets in order. 
    
    SQLEventCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Clean(Request("OrderNumber")) & "" 
    Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)
    
    
    If rsEventCount("SeatCount") >= Series1Count Then
    
        '4th Price Tier
	    If rsEventCount("SeatCount") = Series4Count Then 
		    NewPrice = Series4Disc
    	End If
    		
	    '3rd Price Tier
	    If rsEventCount("SeatCount") = Series3Count And rsEventCount("SeatCount") <= (Series4Count - 1) Then 
            NewPrice = Series3Disc
    	End If
    		
  		
        'Count # of existing seats which have discount applied.
        SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber 
        Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)

                        
            If Price > NewPrice Then
                DiscountAmount = Clean(Request("Price")) - NewPrice
                AppliedFlag = "Y"	
            End If
            
            If Request("CalcServiceFee") <> "N" Then
		    Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, Clean(Request("EventCode")), Clean(Request("ItemType")))
		    End If
    		
		    
    		
	    rsDiscCount.Close
	    Set rsDiscCount = nothing

    End If				
    	
    rsEventCount.Close
    Set rsEventCount = nothing
    
End If

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>