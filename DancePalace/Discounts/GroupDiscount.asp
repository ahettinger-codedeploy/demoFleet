<%

'CHANGE LOG - Inception
'SSR (8/31/2011)
'Custom Discount

%>

<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'===============================================

'Dance Palace Community Center (8/31/2011)
'Group Discount

'Silvia’s client
'Custom discount
'Buy 1 or more ticket
'4-6 Events = 10%
'7+ Events = 15%

'Contact
'Dan Mankin
'Dance Palace Community Center
'Executive Director
'PO Box  217
'Point Reyes Station, CA. 94956
'415-663-1075 fax: 415-663-1475
'Shipping address: 503 B St. Point Reyes Station, CA. 94956

'===============================================

'1st Price Tier
'4 to 6 tickets at 10% off total
Series1Count = 4
Series1Disc = 10

'2nd Price Tier
'7 and up tickets at 15% off total
Series2Count = 7
Series2Disc = 15

'===============================================

If AllowDiscount = "Y" Then

    'Determine the total number of tickets in order. 
    'This discount counts tickets across all events, regardless of production or event date

    SQLEventCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Clean(Request("OrderNumber"))
    Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)

    If rsEventCount("SeatCount") >= Series1Count Then
      		
    		
	    '2nd Price Tier	
	    If rsEventCount("SeatCount") >= Series2Count Then 
            SeriesPercentage = Series2Disc
	    End If
	    
	    '1st Price Tier	
	    If rsEventCount("SeatCount") >= Series1Count And rsEventCount("SeatCount") <= (Series2Count - 1) Then 
            SeriesPercentage = Series1Disc
	    End If
    		
        'Count # of existing seats which have discount applied.
        SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber 
        Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)

            NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(SeriesPercentage)/100), 2) 
            
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