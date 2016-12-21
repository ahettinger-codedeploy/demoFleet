<%

'CHANGE LOG
'SSR 06/13/2011 - Custom Discount Code Created. 
'SSR 05/12/2014 - Updated to prevent subseats from being discounted.


%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'==================================================

'Augusta Amusements

'Custom Build-Your-Own. 
'When discount code “Discount” is entered, the following discount is provided:

'3-4 productions 10% off
'5-6 productions 15% off
'7-8 productions 20% off
'9+ productions 25% off


'Eligible ActCodes / EventCodes
'ActCodes: 101209,101212,101224,101225,101242,101518,101665,101666,101671,101672,101699,101773,102218,102373,102374,103408
'Event Codes: 632413, 632417, 632425, 639465, 632426, 632439, 639339, 639341, 639355, 643805, 637519, 639356, 640069, 644277, 649662, 644275
'Offline/Online: Both
'Service Fees: Recalculate service fees
'Additional Tickets: N/A
'Automatic/Code Entry: Discount Code Entry Required
'Expiration: No Expiration
'Restrictions: N/A

'==================================================

MinSeriesCount = 3

SeriesDiscount3 = 10
SeriesDiscount5 = 15
SeriesDiscount7 = 20
SeriesDiscount9 = 25

ActCodeList = "101209,101212,101224,101225,101242,101518,101665,101666,101671,101672,101699,101773,102218,102373,102374,103408"

'--------------------------------------------------

If AllowDiscount = "Y" Then
	
        'Determine the number of acts with matching ticket types.
        SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') GROUP BY Event.ActCode) AS ActCount"
        Set rsActCount = OBJdbConnection.Execute(SQLActCount)
        ActCount = rsActCount("ActCount")
        rsActCount.Close
        Set rsActCount = nothing
		
		ErrorLog("ActCount : " & ActCount  & "")
		ErrorLog("MinSeriesCount : " & MinSeriesCount  & "")

    If ActCount => MinSeriesCount Then                
                
            If ActCount => 9 Then
                SeriesPercentage = SeriesDiscount9
			ElseIf ActCount => 7 Then
                SeriesPercentage = SeriesDiscount7
            ElseIf ActCount => 5 Then
                SeriesPercentage = SeriesDiscount5
            ElseIf ActCount => 3 Then
                SeriesPercentage = SeriesDiscount3
            End If
			
			ErrorLog("SeriesPercentage : " & SeriesPercentage  & "")

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