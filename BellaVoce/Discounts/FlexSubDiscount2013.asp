<%

'CHANGE LOG - Inception
'SLM  7/16/2012 - Custom Discount Code Created for 2012

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'==================================================

'Bella Voce (
'Season Subscription 2013

'Buy 1 ticket to any 3 Acts and get 10% Off
'Buy 1 ticket to any 4 Acts and get 15% Off
'Buy 1 ticket to any 5 Acts and get 20% Off

'ActCode    Act
'92963 	 Bella Voce Consort 2014
'92960 	 Curse Upon Iron 2013
'92961 	 Handel’s Messiah 2013
'92962 	 Holiday Delights 2013
'92964 	 Spring Renaissance 2014

'Automatic Discount
'No recalc

MinSeriesCount = 3

SeriesDiscount3 = 10
SeriesDiscount4 = 15
SeriesDiscount5 = 20

ActCodeList = "92963,92960,92961,92962,92964"

'==================================================

If AllowDiscount = "Y" Then
	
        'Determine the number of acts with matching ticket types.
        SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND OrderLine.SeatTypeCode = " & SeatTypeCode & " GROUP BY Event.ActCode) AS ActCount"
        Set rsActCount = OBJdbConnection.Execute(SQLActCount)
        ActCount = rsActCount("ActCount")
        rsActCount.Close
        Set rsActCount = nothing

    If ActCount => MinSeriesCount Then                
                
            If ActCount => 5 Then
                SeriesPercentage = SeriesDiscount5
            ElseIf ActCount => 4 Then
                SeriesPercentage = SeriesDiscount4
            ElseIf ActCount => 3 Then
                SeriesPercentage = SeriesDiscount3
            End If

            'Determine how many sets of matching act code / ticket type  are on the order
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

            'Determine the number of tickets which have been discounted
            SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ActCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
            Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)			
            AppliedCount = rsDiscCount("LineCount")        		
            rsDiscCount.Close
            Set rsDiscCount = nothing	

            'Should the number of possible discounts be less then the total possible go ahead and discount this ticket
            If AppliedCount < NbrSubscriptions Then	  

                NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(SeriesPercentage)/100), 2)


                If Price > NewPrice Then
                    DiscountAmount = Clean(Request("Price")) - NewPrice
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