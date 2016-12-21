<%

'CHANGE LOG - Inception
'SSR  (3/12/2012)
'Custom Discount Code Created. 

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'====================================================================

'Alpine Theatre Project
'2012 Season Subscription

'DISCOUNT NAME: 2012Subscription

'DISCOUNT 1 (25% off):
'If at least 1 ticket is purchased to:
'Act #74823	Master Class
'Act #74824	Little Shop of Horrors
'Act #75208	Hedwig and the Angry Inch
'And in Tier 1 (Blue)

'DISCOUNT 2 (20% off)
'If at least 1 ticket is purchased to:
'Act #74823	Master Class
'Act #74824	Little Shop of Horrors
'Act #75208	Hedwig and the Angry Inch
'And in Tier 2 (Yellow)

'DISCOUNT 3 (10% off)
'If at least 1 ticket is purchased to:
'Act #74823	Master Class
'Act #74824	Little Shop of Horrors
'Act #75208	Hedwig and the Angry Inch
'And in Tier 3 (Green)

'ADDITIONAL DISCOUNT (20% off)
'If the patron has qualified for one of the discounts above, I would like them to be able to purchase tickets to Act #74830 Legends: Stephen Sondheim at a 20% discount. Is that possible to make that automatic as well?

'====================================================================

SeriesCount = 3

ActCodeList = "74823,74824,75208"

DarkBluePercentage = 25
DarkGoldPercentage = 20
DarkGreenPercentage = 10

BonusActCodeList = "74830"
BonusPercentage = 20

'====================================================================

'Determine that it's okay to apply discounts.

If AllowDiscount = "Y" Then 

	            SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList & ") AND OrderLine.SeatTypeCode = " & Clean(Request("SeatTypeCode")) & " GROUP BY Event.ActCode) AS ActCount"
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
                        
                        'Get the color for this section (if needed for discount)
                        SQLColor = "SELECT Color FROM Section(NOLOCK) WHERE EventCode = " & EventCode & " AND SectionCode = '" & SectionCode & "' "
                        Set rsColor = OBJdbConnection.Execute(SQLColor)
                        Color = rsColor("Color")
                        rsColor.Close
                        Set rsColor = nothing
                        
                        'Determine the number of tickets which have been discounted
                        SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ActCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
                        Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)			
                        AppliedCount = rsDiscCount("LineCount")        		
                        rsDiscCount.Close
                        Set rsDiscCount = nothing	

                        'Should the number of possible discounts be less then the total possible go ahead and discount this ticket
                        If AppliedCount < NbrSubscriptions Then	
                        
                            Select Case ActCode
                                Case  74830
                                NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(BonusPercentage)/100), 2)

                                Case  74823,74824,75208
                                    Select Case Color
                                        Case "DARKBLUE" 
                                        NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(DarkBluePercentage)/100), 2)
                                        Case "DARKGOLD"
                                        NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(DarkGoldPercentage)/100), 2)
                                        Case "DARKGREEN"
                                        NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(DarkGreenPercentage)/100), 2)
                                    End Select
                            End Select
                                                                   
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
                        
                End If
   
End If
                
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf
        
%>