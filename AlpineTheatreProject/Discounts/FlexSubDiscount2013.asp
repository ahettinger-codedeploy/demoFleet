<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'========================================================

'Alpine Theatre Project
'2013 Season Subscription


'Code: 2013Subscription
'Discount Type: Automatic

'Act Code	Act Name
'------------------------------------------------------
'89482		Defying Gravity: Broadway's Next Generation
'89483		Bibbidi Bobbidi Boo: Broadway's Family Fare
'89484		5, 6, 7, 8!: Broadway's Style & Rhythm
'89485		Some Enchanted Evening: Broadway's Golden Age

'4-Show Discount - 20% + 1.00 per subscription fee 
'Must purchase at least 1 ticket to all 4 productions

'3-Show Discount - 10% + 1.00 per subscription fee 
'Must purchase at least 1 ticket to 3 productions

'Online and offline
'Do not recalc fees
'No expiration date
'Adult ticket only


'Contact
'Luke Walrath
'luke@alpinetheatreproject.org

'========================================================

ActCodeList = "89482,89483,89484,89485" 

SeriesCount01 = 4
SeriesPercentage01 = 20 

SeriesCount02 = 3
SeriesPercentage02 = 10

SeriesSurcharge = 1.00

'------------------------------------------------------

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
			            
			        Case SeriesCount02
			            Percentage = SeriesPercentage02
			            SeriesCount = SeriesCount02
		        End Select	
        	
		        'Divide between tickets if there is an uneven discount amount
        		
                 Select Case SeatTypeCode
                    Case 1    
					
		                NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Percentage)/100), 2)   
						
		                If Price > NewPrice Then
	                        DiscountAmount = Clean(Request("Price")) - NewPrice
	                    End If  

				        'Count number of discounted tickets
                        SQLCount = "SELECT COUNT(OrderLine.ItemNumber) AS AppliedCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND OrderLine.SeatTypeCode = 1 AND DiscountTypeNumber = " & DiscountTypeNumber
                        Set rsCount = OBJdbConnection.Execute(SQLCount)
                        Count = rsCount("AppliedCount")
                        rsCount.Close
                        Set rsCount = nothing  						
					
				        Remainder = Count MOD SeriesCount				        
				        
                        If Remainder = SeriesCount - 1 Then 
							Surcharge = SeriesSurcharge - ((SeriesCount - 1) * Round(SeriesSurcharge/SeriesCount, 2))
                        Else
                            Surcharge = Round(SeriesSurcharge/SeriesCount, 2)
                        End If
						
						AppliedFlag = "Y"

                 End Select    	    

	    End If
    		
    End If

End If

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>