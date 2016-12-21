<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'===========================================

'Dance Palace Community Center
'2 Tier Percentage Discount by Act Count

'3586	Led Kaapana
'82208	George Winston Benefit Concert and Dinner
'83069	Geoff Hoyle in "Geezer"
'83366	Impossible Bird
'83367	Kronos Quartet
'83369	Craicmore Celtic Yuletide
'83370	John McCutcheon
'83371	Peppino D'Agostino & David Tannebaum
'83373	Golden Bough Celtic St. Paddy's Day Concert
'83374	Janis Ian
'83375	SF Opera Ensemble

'7 Act Series 
'Series Percentage: 15%

'4 Act Series 
'Series Percentage: 10%

'Automatic Discount

'Service Fees: Pass no fees on to patron if purchasing subscription.

'===============================

ActCodeList = "82208, 83069, 83366, 83367, 83369, 83370, 83371, 3586, 83373, 83374, 83375" 

SeriesCount01 = 7
SeriesPercentage01 = 15 

SeriesCount02 = 4
SeriesPercentage02 = 10

NewSurcharge = 0

'===============================

If AllowDiscount = "Y" Then 'It's okay to apply to this order.

    'Determine number of valid productions on the order
    SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") GROUP BY Event.ActCode) AS ActCount"
    Set rsActCount = OBJdbConnection.Execute(SQLActCount)	
    ActCount = rsActCount("ActCount")	
    rsActCount.Close
    Set rsActCount = nothing
 
    If ActCount => SeriesCount02 Then    

        'Get the least number of tickets for allowed ActCodes
        SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumSubs FROM (SELECT ActCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") GROUP BY Event.ActCode) AS TicketCount"
        Set rsMinTicketCount = OBJdbConnection.Execute(SQLMinTicketCount)		
        NbrSubscriptions = rsMinTicketCount("NumSubs")		
        rsMinTicketCount.Close
        Set rsMinTicketCount = nothing    	
    		
        'Get Act Code
        SQLAct = "SELECT ActCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
        Set rsAct = OBJdbConnection.Execute(SQLAct)		
        ActCode = rsAct("ActCode")		
        rsAct.Close
        Set rsAct = nothing

        'Determine number of existing seats which have discount applied for this act and seat type code
        SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ActCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
        Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)		
        AppliedCount = rsDiscCount("LineCount")		
        rsDiscCount.Close
        Set rsDiscCount = nothing
        
        If AppliedCount < NbrSubscriptions Then
        
        
            If ActCount => SeriesCount01 Then
	            Percentage = SeriesPercentage01
	        ElseIf ActCount => SeriesCount02 Then
		        Percentage = SeriesPercentage02
	        End If            
		        
		    NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Percentage)/100), 2) 
		            		            
            If Price > NewPrice Then
                DiscountAmount = Clean(Request("Price")) - NewPrice
				Surcharge = NewSurcharge
                AppliedFlag = "Y"
            End If
                                  
	    End If
    		
    End If

End If

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>