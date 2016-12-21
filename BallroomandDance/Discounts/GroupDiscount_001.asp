<%
'CHANGE LOG
'SSR 10/09/2012 - removed errorlogs

'SSR 10/08/2012 - custom discount code created

%>

<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'Initialize Variables
Price = Clean(Request("Price"))
NewPrice = Price
DiscountAmount = 0
Surcharge = Clean(Request("Surcharge"))
AppliedFlag = "N"
NewSurcharge = CDbl(Clean(Request("NewSurcharge")))
EventCode = Clean(Request("EventCode"))


SeriesCount = 10
SeriesPercentage = 10


'==================================================

'Illinois Youth Dance Theatre, Inc. (4004) 
'Group Discount 

'Please create group discount that is per order based and not per event based.  
'So, if a ticket buyer has 10+ tickets in their order, and those 10+ tickets are spread out over multiple events, the discount should still be applied. 
'This new discount should replace what they’ve set up, which is DiscountTypeNumber=74442
'Contact
'Gail Marshall
'gail@ballroomanddance.com

'==================================================

'Counts total number of tickets in order. This discount looks at tickets in any combination, regardless of production.

SQLEventCount = "SELECT COUNT(OrderLine.LineNumber) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') INNER JOIN DiscountEvents (NOLOCK) ON Seat.EventCode = DiscountEvents.EventCode AND DiscountEvents.DiscountTypeNumber = "& DiscountTypeNumber & " WHERE OrderLine.OrderNumber = " & OrderNumber & ""
Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)

	If Not rsEventCount.EOF Then
			
		If rsEventCount("SeatCount") >= SeriesCount Then 
			Percentage = SeriesPercentage
		End If
		
		'Count # of existing seats which have discount applied.
        SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber 
        Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)

            NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Percentage)/100), 2) 
            
            If Price > NewPrice Then
                DiscountAmount = Clean(Request("Price")) - NewPrice
                AppliedFlag = "Y"	
            End If
                		
	    rsDiscCount.Close
	    Set rsDiscCount = nothing
		
		
    End If				
    	
rsEventCount.Close
Set rsEventCount = nothing
    


Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>