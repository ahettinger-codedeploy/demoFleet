<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'===========================================
'Woodbridge Township (1/17/2011)

'2011 Flex Season Subscription
'Percentage Discount by Act Count with Series Surcharge

'ActCode    Production
'52204      with every brilliant hue
'52206      upon the wind your music floats
'52207      from wild spring air

'3 Act Series 
'Series Percentage: 20%
'Series Surcharge: $1.50

'2 Act Series 
'Series Percentage: 20%
'Series Surcharge: $1.50

'Automatic Discount
'Service Fees are not Recalculated

'===============================

ActCodeList = "52204,52206,52207" 

SeriesCount01 = 3
SeriesPercentage01 = 20 
SeriesSurcharge01 = 1.50

SeriesCount02 = 2
SeriesPercentage02 = 20
SeriesSurcharge02 = 1.50

'===============================

If AllowDiscount = "Y" Then 'It's okay to apply to this order.

    'Determine number of valid productions on the order
    SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") GROUP BY Event.ActCode) AS ActCount"
    Set rsActCount = OBJdbConnection.Execute(SQLActCount)	
    ActCount = rsActCount("ActCount")	
    rsActCount.Close
    Set rsActCount = nothing
    
    ErrorLog("ActCount " & ActCount& "")

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
        
        		
		        Select Case ActCount 
			        Case SeriesCount01
			            Percentage = SeriesPercentage01
			            SeriesCount = SeriesCount01
			            SeriesSurcharge = SeriesSurcharge01
			            
			        Case SeriesCount02
			            Percentage = SeriesPercentage02
			            SeriesCount = SeriesCount02
			            SeriesSurcharge = SeriesSurcharge02
			            
		        End Select	
        	
		        'Divide between tickets if there is an uneven discount amount
        		
                 Select Case SeatTypeCode
                    Case 1                    
		                NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Percentage)/100), 2)     		            
		                If Price > NewPrice Then
	                        DiscountAmount = Clean(Request("Price")) - NewPrice
	                        Surcharge = (SeriesSurcharge / SeriesCount)
	                        AppliedFlag = "Y"
	                    End If                  
                 End Select    	    

	    End If
    		
    End If

End If

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>