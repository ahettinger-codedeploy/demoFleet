<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'==================================================
'Aston Magna (1/21/2011)

'2011 Season Subscription 
'Fixed Ticket Price

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

If AllowDiscount = "Y" Then 'It's okay to apply to this order.

        'Count # of Acts on the order.
        SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND OrderLine.SeatTypeCode = " & SeatTypeCode & " GROUP BY Event.ActCode) AS ActCount"
        Set rsActCount = OBJdbConnection.Execute(SQLActCount)
        ActCount = rsActCount("ActCount")
        rsActCount.Close
        Set rsActCount = nothing

        If ActCount => SeriesCount Then

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

                If rsDiscCount("LineCount") < NbrSubscriptions Then	        

                        'Determine that ticket is within the series count, if so, apply the discount price
                        If Int(rsDiscCount("LineCount") / SeriesCount) < Int(ActCount / SeriesCount) Then 
                        
                                NewPrice = SeriesPrice   
                                                                             
                                'Determine that the discounted price is less than the full ticket price                
                                If Price > NewPrice Then
                                    DiscountAmount = Clean(Request("Price")) - NewPrice
                                    AppliedFlag = "Y"
                                End If 
                                
                                If Request("NewSurcharge") <> "" Then
                                    Surcharge = NewSurcharge	
                                ElseIf Request("CalcServiceFee") <> "N" Then
                                    Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))				
                                End If 

                        End If
                		
                rsDiscCount.Close
                Set rsDiscCount = nothing 

                End If

        End If
 
End If
                
        Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
        Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
        Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
        Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf
        
        %>