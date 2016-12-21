<%

'CHANGE LOG

'SLM (11/13/2012) - Added additional production to discount
'SSR (9/19/2012) - Discount code update. Revised act counts. Changed from Series Price to Series Discount as Series Price caused ticket price to go up
'SSR  (9/15/2012) - Custom Discount Code Created. 

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'==================================================

'Academy Theater of Music
'5 Tier Season Subscription by Series Price by Act Count with Bonus Act

'Flex sub based on number of acts and ticket types:
'Buy any 2 of ActCode 83839,83841,83671,83668,83670,83674,83838 AND 1 of ActCode 83840 with SeatTypeCode 1  = 38.25 Series Price
'Buy any 3 of ActCode 83839,83841,83671,83668,83670,83674,83838 AND 1 of ActCode 83840 with SeatTypeCode 1  = 48.45 Series Price
'Buy any 4 of ActCode 83839,83841,83671,83668,83670,83674,83838 AND 1 of ActCode 83840 with SeatTypeCode 1  = 58.65 Series Price
'Buy any 5 of ActCode 83839,83841,83671,83668,83670,83674,83838 AND 1 of ActCode 83840 with SeatTypeCode 1  = 68.85 Series Price
'Buy any 6 of ActCode 83839,83841,83671,83668,83670,83674,83838 AND 1 of ActCode 83840 with SeatTypeCode 1  = 79.05 Series Price

'Buy any 2 of ActCode 83839,83841,83671,83668,83670,83674,83838 AND 1 of ActCode 83840 with SeatTypeCode 3  = 29.75 Series Price
'Buy any 3 of ActCode 83839,83841,83671,83668,83670,83674,83838 AND 1 of ActCode 83840 with SeatTypeCode 3  = 38.25 Series Price
'Buy any 4 of ActCode 83839,83841,83671,83668,83670,83674,83838 AND 1 of ActCode 83840 with SeatTypeCode 3  = 46.75 Series Price
'Buy any 5 of ActCode 83839,83841,83671,83668,83670,83674,83838 AND 1 of ActCode 83840 with SeatTypeCode 3  = 55.25 Series Price
'Buy any 6 of ActCode 83839,83841,83671,83668,83670,83674,83838 AND 1 of ActCode 83840 with SeatTypeCode 3  = 63.75 Series Price

'Buy any 2 of ActCode 83839,83841,83671,83668,83670,83674,83838 AND 1 of ActCode 83840 with SeatTypeCode 6  = 17.85 Series Price
'Buy any 3 of ActCode 83839,83841,83671,83668,83670,83674,83838 AND 1 of ActCode 83840 with SeatTypeCode 6  = 22.95 Series Price
'Buy any 4 of ActCode 83839,83841,83671,83668,83670,83674,83838 AND 1 of ActCode 83840 with SeatTypeCode 6  = 28.05 Series Price
'Buy any 5 of ActCode 83839,83841,83671,83668,83670,83674,83838 AND 1 of ActCode 83840 with SeatTypeCode 6  = 33.15 Series Price
'Buy any 6 of ActCode 83839,83841,83671,83668,83670,83674,83838 AND 1 of ActCode 83840 with SeatTypeCode 6  = 38.25 Series Price
'Discount should be given automatically.
'Online and offline.
'Do not recalc service fees.

'==================================================

ActCodeList = "83839,83841,83671,83668,83670,83674,83838"
BonusActCodeList = 83840

MinSeriesCount = 2

BonusMinCount = 1

'Series (Act Count, Seat Type Code)

Dim Series (6,6)

Series(2,1) = 38.25 
Series(3,1) = 48.45 
Series(4,1) = 58.65
Series(5,1) = 68.85
Series(6,1) = 79.05

Series(2,3) = 29.75
Series(3,3) = 38.25
Series(4,3) = 46.75
Series(5,3) = 55.25
Series(6,3) = 63.75

Series(2,6) = 17.85
Series(3,6) = 22.95
Series(4,6) = 28.05
Series(5,6) = 33.15
Series(6,6) = 38.25

'-----------------------------------------------

If SeatTypeCode = 1 OR SeatTypeCode = 3 Or SeatTypeCode = 6 Then
	
        'Count the number of season acts with matching ticket types.
        SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND OrderLine.SeatTypeCode = " & SeatTypeCode & " GROUP BY Event.ActCode) AS ActCount"
        Set rsActCount = OBJdbConnection.Execute(SQLActCount)
			ActCount = rsActCount("ActCount")
        rsActCount.Close
        Set rsActCount = nothing
		
		'ErrorLog("ActCount   " & ActCount  & "")

    If ActCount => MinSeriesCount Then   

        'Count the number of season acts with matching ticket types.
        SQLBonusActCount = "SELECT COUNT(ActCode) AS BonusActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & BonusActCodeList & ") AND OrderLine.SeatTypeCode = " & SeatTypeCode & " GROUP BY Event.ActCode) AS BonusActCount"
        Set rsBonusActCount = OBJdbConnection.Execute(SQLBonusActCount)
        BonusActCount = rsBonusActCount("BonusActCount")
        rsBonusActCount.Close
        Set rsBonusActCount = nothing
		
		'ErrorLog("BonusActCount  " & BonusActCount & "")

	    If ActCount => BonusMinCount Then   
        
			MyPrice = Series(CInt(ActCount),CInt(SeatTypeCode)) 

			'ErrorLog("MyPrice  " & MyPrice & "")

            'Determine how many sets of matching act code / ticket type  are on the order
            SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumSubs FROM (SELECT ActCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ", " & BonusActCodeList & ") GROUP BY Event.ActCode) AS TicketCount"
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

			
			'Count number of tickets which have been given a discount
			SQLCount = "SELECT COUNT(OrderLine.LineNumber) AS AppliedCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.OrderNumber = " & OrderNumber & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')" 
			Set rsCount = OBJdbConnection.Execute(SQLCount)
			Count = rsCount("AppliedCount")
			rsCount.Close
			Set rsCount = nothing
			
			SeriesCount = ActCount + NbrSubscriptions
			
			SeriesPrice = Series(CInt(ActCount),CInt(SeatTypeCode)) 
			
			Select Case SeatTypeCode
				Case 1
					BonusPrice = 21
					ActPrice = 12
				Case 3
					BonusPrice = 15
					ActPrice = 10
				Case 6
					BonusPrice = 9
					ActPrice = 6
			End Select
					
			
			SeriesFullPrice = (ActCount * ActPrice) + (NbrSubscriptions * BonusPrice)
			
			SeriesDiscount = SeriesFullPrice - SeriesPrice
			
			'ErrorLog("SeriesPrice  " & SeriesPrice & "")
			
			'ErrorLog("SeriesFullPrice  " & SeriesFullPrice & "")
			
			'ErrorLog("SeriesDiscount  " & SeriesDiscount & "")
			
			Remainder = Count MOD SeriesCount				        

				If Remainder = SeriesCount - 1 Then 
					DiscountAmount = SeriesDiscount - ((SeriesCount - 1) * Round(SeriesDiscount/SeriesCount, 2))
				Else
					DiscountAmount = Round(SeriesDiscount/SeriesCount, 2)
				End If
					
				NewPrice =  Clean(Request("Price")) - DiscountAmount
				
				Surcharge = 0
										
				AppliedFlag = "Y"
			
		End If
        
    End If

End If

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>