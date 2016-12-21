<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'==================================================
'Aston Magna (1/21/2011)

'2011 Season Subscription 
'Fixed Ticket Price by ActCount and VenueCode

'Subscription to two Aston Magna Concerts of your choice at The Daniel Arts Center at Simon’s Rock College.
'Subscriptions to two concerts are $65.00

'Productions
'Bach and Son (59541)
'Divertimenti: Mozart and J.N. Hummel (59542)
'England, Be Glad (59539)
'The Italian Madrigal and its legacy (59544)

SeriesPrice = 32.50
SeriesCount = 2 
ActCodeList = "54444,59539,59541,59542"

'==================================================

'Determine that it's okay to apply discounts.
If AllowDiscount = "Y" Then 

        'Determine the number of acts with matching ticket types.
        SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND OrderLine.SeatTypeCode = " & SeatTypeCode & " GROUP BY Event.ActCode) AS ActCount"
        Set rsActCount = OBJdbConnection.Execute(SQLActCount)
        ActCount = rsActCount("ActCount")
        rsActCount.Close
        Set rsActCount = nothing

                If ActCount => SeriesCount Then

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

                        'Give the discount only if the full price is not $0.                
                        If Clean(Request("Price")) > 0 Then

                                'Give the discount only if the discounted price is less then the full price.
                                If Clean(Request("Price")) > SeriesPrice Then

                                    Select Case SeatTypeCode 
                                        Case 1 
                                        NewPrice = SeriesPrice
                                    End Select			    

                                    DiscountAmount = Clean(Request("Price")) - NewPrice

                                            If NewPrice < 0 Then
                                                NewPrice = 0
                                            End If

                                    AppliedFlag = "Y"

                                End If

                        End If
                        
                End If
            
        End If
	    
End If
                
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf
        
        %>