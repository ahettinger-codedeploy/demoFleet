<%

'CHANGE LOG - Inception
'SSR  (6/13/2011)
'Custom Discount Code Created. 

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'==================================================

'Flex sub based on number of acts and ticket types:
'Buy any 3 of ActCode 83839,83841,83671,83668,83670,83674 AND 1 of ActCode 83840, series price SeatTypeCode 1, 3678 = Series(3_1 = 38.25 
'Buy any 4 of ActCode 83839,83841,83671,83668,83670,83674 AND 1 of ActCode 83840, series price SeatTypeCode 1, 3678 = Series(4_1 = 48.45 
'Buy any 5 of ActCode 83839,83841,83671,83668,83670,83674 AND 1 of ActCode 83840, series price SeatTypeCode 1, 3678 = Series(5_1 = 58.65
'Buy any 6 of ActCode 83839,83841,83671,83668,83670,83674 AND 1 of ActCode 83840, series price SeatTypeCode 1, 3678 = Series(6_1 = 68.85
'Buy any 7 of ActCode 83839,83841,83671,83668,83670,83674 AND 1 of ActCode 83840, series price SeatTypeCode 1, 3678 = Series(7_1 = 79.05'

'Buy any 3 of ActCode 83839,83841,83671,83668,83670,83674 AND 1 of ActCode 83840, series price SeatTypeCode 3, 3682 = Series(3_3 = 29.75
'Buy any 4 of ActCode 83839,83841,83671,83668,83670,83674 AND 1 of ActCode 83840, series price SeatTypeCode 3, 3682 = Series(4_3 = 38.25
'Buy any 5 of ActCode 83839,83841,83671,83668,83670,83674 AND 1 of ActCode 83840, series price SeatTypeCode 3, 3682 = Series(5_3 = 46.75
'Buy any 6 of ActCode 83839,83841,83671,83668,83670,83674 AND 1 of ActCode 83840, series price SeatTypeCode 3, 3682 = Series(6_3 = 55.25
'Buy any 7 of ActCode 83839,83841,83671,83668,83670,83674 AND 1 of ActCode 83840, series price SeatTypeCode 3, 3682 = Series(7_3 = 63.75

'Buy any 3 of ActCode 83839,83841,83671,83668,83670,83674 AND 1 of ActCode 83840, series price SeatTypeCode 6, 3681 = Series(3_6 = 17.85
'Buy any 4 of ActCode 83839,83841,83671,83668,83670,83674 AND 1 of ActCode 83840, series price SeatTypeCode 6, 3681 = Series(4_6 = 22.95
'Buy any 5 of ActCode 83839,83841,83671,83668,83670,83674 AND 1 of ActCode 83840, series price SeatTypeCode 6, 3681 = Series(5_6 = 28.05
'Buy any 6 of ActCode 83839,83841,83671,83668,83670,83674 AND 1 of ActCode 83840, series price SeatTypeCode 6, 3681 = Series(6_6 = 33.15
'Buy any 7 of ActCode 83839,83841,83671,83668,83670,83674 AND 1 of ActCode 83840, series price SeatTypeCode 6, 3681 = Series(7_6 = 38.25
'Discount should be given automatically.
'Online and offline.
'Do not recalc service fees.

'==================================================

ActCodeList = "83839,83841,83671,83668,83670,83674"
BonusActCodeList = 83840

MinSeriesCount = 3

BonusMinCount = 1

Dim Series (7,6)

Series(3,1) = 38.25 
Series(4,1) = 48.45 
Series(5,1) = 58.65
Series(6,1) = 68.85
Series(7,1) = 79.05

Series(3,3) = 29.75
Series(4,3) = 38.25
Series(5,3) = 46.75
Series(6,3) = 55.25
Series(7,3) = 63.75

Series(3,6) = 17.85
Series(4,6) = 22.95
Series(5,6) = 28.05
Series(6,6) = 33.15
Series(7,6) = 38.25

'-----------------------------------------------

If AllowDiscount = "Y" Then
	
        'Count the number of season acts with matching ticket types.
        SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND OrderLine.SeatTypeCode = " & SeatTypeCode & " GROUP BY Event.ActCode) AS ActCount"
        Set rsActCount = OBJdbConnection.Execute(SQLActCount)
			ActCount = rsActCount("ActCount")
        rsActCount.Close
        Set rsActCount = nothing

    If ActCount => MinSeriesCount Then   

        'Count the number of season acts with matching ticket types.
        SQLBonusActCount = "SELECT COUNT(ActCode) AS BonusActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & BonusActCodeList & ") AND OrderLine.SeatTypeCode = " & SeatTypeCode & " GROUP BY Event.ActCode) AS BonusActCount"
        Set rsBonusActCount = OBJdbConnection.Execute(SQLBonusActCount)
        BonusActCount = rsBonusActCount("BonusActCount")
        rsBonusActCount.Close
        Set rsBonusActCount = nothing
		
		ErrorLog("BonusActCount  " & BonusActCount & "")

	    If ActCount => BonusMinCount Then   
        
			MyPrice = Series(CInt(ActCount),CInt(SeatTypeCode)) 

			ErrorLog("MyPrice  " & MyPrice & "")

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
			
			Remainder = Count MOD SeriesCount				        

				If Remainder = SeriesCount - 1 Then 
					NewPrice = SeriesPrice - ((SeriesCount - 1) * Round(SeriesPrice/SeriesCount, 2))
				Else
					NewPrice = Round(SeriesPrice/SeriesCount, 2)
				End If
					
				DiscountAmount =  Clean(Request("Price")) - NewPrice
				
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