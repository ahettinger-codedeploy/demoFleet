<%

'CHANGE LOG - Inception
'SSR (8/17/2011)
'Custom Code 

%>

<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'===============================================

'working 4 act and 3 event discount

'Duke City Repertory Theatre (8/17/2011)
'3 Tier Season Subscription

'Single Subscription, DCRT Duet: $120 Two tickets for each production of the season with a 25% savings!
'Now until August 28th,2011; 


'**After August 28th these packages cannot be available for sale on the website.** 

'3 for $48 Flex Package will be available for purchase during reasons to be pretty and Wooden Snowflakes
'Now until December 19th, 2011; 
'Event codes: 380435, 380413, 380414, 380415, 380416, 380417, 380418, 380419, 380410, 380426, 380427, 380428, 380429, 380430, 380431, 380432
'**After December 19th this package cannot be available for sale on the website.**

'2 for $32 Flex Package will be available for purchase during reasons to be pretty, Wooden Snowflakes, and Oedipus
'Now until February 19th, 2012; 
'Event codes: 380435, 380413, 380414, 380415, 380416, 380417, 380418, 380419, 380410, 380426, 380427, 380428, 380429, 380430, 380431, 380432, 384055, 384056, 384057, 384058, 384059, 384060, 384061, 384062
'After February 19th, we’d like the Subscription Page to read "Subscriptions for our 2011/2012 Season are no longer available for purchase. 
'Please check back soon for details about our 2012/2013 Subscription Packages.”

'Amelia Ampuero
'Artistic Director
'Duke City Repertory Theatre
'artisticdirector@dukecityrep.com


'===============================================

'Survey Variables

'--------------------
'Duet Subscription
'--------------------

'2 tickets to each of the 4 productions
'Adult tickets only
'Series Price $120.00
'$5.00 discount per ticket
'Vaild only until August 28, 2011

'ActCode Act
'66539   reasons to be pretty by Neil LaBute
'66543   Wooden Snowflakes by Catherine Bush
'67023   Oedipus by Sophocles, adapted by John Hardy
'67024   Phoenix by Scott Organ

SeriesCount01 = 4 
SeriesDiscount01 = 5.00
SeriesPrice01 = 120
SeriesSeatType01 = 1
SeriesCount01 = 4
ActCodeList01 = "66539,66543,67023,67024"
ExpDate01 = "8/28/2011"


'--------------------
' 3 Flex Package
'--------------------

'1 tickets to each of 3 events
'Adult tickets only
'Series Price $48.00 
'$4.00 discount per ticket
'Valid until December 19th, 2011

'EventCode  Event                               Date
'380435	    reasons to be pretty by Neil LaBute	2011-08-18 
'380413	    reasons to be pretty by Neil LaBute	2011-08-19 
'380414	    reasons to be pretty by Neil LaBute	2011-08-20 
'380415	    reasons to be pretty by Neil LaBute	2011-08-21 
'380416	    reasons to be pretty by Neil LaBute	2011-08-25 
'380417	    reasons to be pretty by Neil LaBute	2011-08-26 
'380418	    reasons to be pretty by Neil LaBute	2011-08-27 
'380419	    reasons to be pretty by Neil LaBute	2011-08-28 
'380410	    Wooden Snowflakes by Catherine Bush	2011-12-08 
'380426	    Wooden Snowflakes by Catherine Bush	2011-12-09 
'380427	    Wooden Snowflakes by Catherine Bush	2011-12-10 
'380428	    Wooden Snowflakes by Catherine Bush	2011-12-11 
'380429	    Wooden Snowflakes by Catherine Bush	2011-12-15 
'380430	    Wooden Snowflakes by Catherine Bush	2011-12-16 
'380431	    Wooden Snowflakes by Catherine Bush	2011-12-17 


SeriesDiscount03 = 5.00
SeriesSeatType03 = 1
SeriesCount03 = 3
EventCodeList03 = "380435, 380413, 380414, 380415, 380416, 380417, 380418, 380419, 380410, 380426, 380427, 380428, 380429, 380430, 380431, 380432"
ExpDate03 = "12/19/2011"


'--------------------
' 2 Flex Package
'--------------------

'1 tickets to each of 2 events
'Adult tickets only
'Series Price $32.00 
'$4.00 discount per ticket
'Valid until February 19th, 2012

'EventCode  Event                                           Date
'380410	    Wooden Snowflakes by Catherine Bush	            2011-12-08 
'380413	    reasons to be pretty by Neil LaBute         	2011-08-19 
'380414	    reasons to be pretty by Neil LaBute         	2011-08-20 
'380415	    reasons to be pretty by Neil LaBute	            2011-08-21 
'380416 	reasons to be pretty by Neil LaBute	            2011-08-25 
'380417 	reasons to be pretty by Neil LaBute	            2011-08-26 
'380418 	reasons to be pretty by Neil LaBute	            2011-08-27 
'380419 	reasons to be pretty by Neil LaBute         	2011-08-28 
'380426 	Wooden Snowflakes by Catherine Bush	            2011-12-09 
'380427 	Wooden Snowflakes by Catherine Bush	            2011-12-10 
'380428  	Wooden Snowflakes by Catherine Bush	            2011-12-11 
'380429 	Wooden Snowflakes by Catherine Bush	            2011-12-15 
'380430 	Wooden Snowflakes by Catherine Bush         	2011-12-16 
'380431	    Wooden Snowflakes by Catherine Bush	            2011-12-17 
'380432 	Wooden Snowflakes by Catherine Bush	            2011-12-18 
'380435 	reasons to be pretty by Neil LaBute	            2011-08-18 
'384055      Oedipus by Sophocles, adapted by John Hardy	2012-02-09 
'384056	    Oedipus by Sophocles, adapted by John Hardy	    2012-02-10 
'384057 	Oedipus by Sophocles, adapted by John Hardy	    2012-02-11 
'384058 	Oedipus by Sophocles, adapted by John Hardy	    2012-02-12 
'384059 	Oedipus by Sophocles, adapted by John Hardy	    2012-02-16 
'384060 	Oedipus by Sophocles, adapted by John Hardy 	2012-02-17 
'384061 	Oedipus by Sophocles, adapted by John Hardy 	2012-02-18 
'384062 	Oedipus by Sophocles, adapted by John Hardy	    2012-02-19 


SeriesDiscount02 = 2.00
SeriesSeatType02 = 1
SeriesCount02 = 2
EventCodeList02 = "380435, 380413, 380414, 380415, 380416, 380417, 380418, 380419, 380410, 380426, 380427, 380428, 380429, 380430, 380431, 380432, 384055, 384056, 384057, 384058, 384059, 384060, 384061, 384062"
ExpDate02 = "2/19/2012"


'===============================================

'--------------------
'Duet Subscription
'--------------------

'Determine the original order date, for date based season subscriptions
'this allows re-opened orders to calculate based on the original order date

SQLDateCheck = "SELECT OrderHeader.OrderDate FROM OrderHeader (NOLOCK) WHERE OrderHeader.OrderNumber = " & OrderNumber & ""
Set rsDateCheck = OBJdbConnection.Execute(SQLDateCheck)
OriginalDate = rsDateCheck("OrderDate")
rsDateCheck.Close
Set rsDateCheck = nothing

If CDate(OriginalDate) < CDate(ExpDate01) Then  

    'Count # of Acts on the order.
    SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList01 & ") AND OrderLine.SeatTypeCode = " & SeriesSeatType01 & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS ActCount"
    Set rsActCount = OBJdbConnection.Execute(SQLActCount)	
    ActCount = rsActCount("ActCount")	
    rsActCount.Close
    Set rsActCount = nothing
    	
    If ActCount >= SeriesCount01 Then

        'Get the least number of tickets for any applicable ActCode
        SQLMinTicketCount = "SELECT MIN(TicketCount) AS NumSubs FROM (SELECT ActCode, COUNT(Seat.ItemNumber) AS TicketCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND Event.ActCode IN (" & ActCodeList01 & ") AND OrderLine.SeatTypeCode = " & SeriesSeatType01 & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY Event.ActCode) AS TicketCount"
        Set rsMinTicketCount = OBJdbConnection.Execute(SQLMinTicketCount)		
        SingleSubscriptions = rsMinTicketCount("NumSubs")		
        rsMinTicketCount.Close
        Set rsMinTicketCount = nothing
    						
	    CountRemainder = (SingleSubscriptions Mod 2)	
		
        If CountRemainder = 0 Then
            NbrSubscriptions = SingleSubscriptions       
        Else
            NbrSubscriptions = (SingleSubscriptions - CountRemainder)
        End If	
    			
            If NbrSubscriptions >= 2 Then
    		
                'Get Act Code
                SQLAct = "SELECT ActCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
                Set rsAct = OBJdbConnection.Execute(SQLAct)		
                ActCode = rsAct("ActCode")		
                rsAct.Close
                Set rsAct = nothing

                'Count # of existing seats which have discount applied for this act and seat type code
                SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ActCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
                Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)		
                AppliedCount = rsDiscCount("LineCount")		
                rsDiscCount.Close
                Set rsDiscCount = nothing
            
	            If AppliedCount < NbrSubscriptions Then

                    NewPrice = Price - SeriesDiscount01	
                    
                    If NewPrice < 0 Then
                       NewPrice = 0
                    End If
                    
                    DiscountAmount = Price - NewPrice	
                    AppliedFlag = "Y"
                	    
                        
                    If Request("NewSurcharge") <> "" Then
                        Surcharge = NewSurcharge
                    Else
                       If Request("CalcServiceFee") <> "N" Then
                           Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
                       End If
                    End If	
            	        
	            End If
                
            End If	

        End If

End If

'--------------------
' 3 Flex Package
'--------------------

'Determine the original order date, for date based season subscriptions
'this allows re-opened orders to calculate based on the original order date

SQLDateCheck = "SELECT OrderHeader.OrderDate FROM OrderHeader (NOLOCK) WHERE OrderHeader.OrderNumber = " & OrderNumber & ""
Set rsDateCheck = OBJdbConnection.Execute(SQLDateCheck)
OriginalDate = rsDateCheck("OrderDate")
rsDateCheck.Close
Set rsDateCheck = nothing

If CDate(OriginalDate) < CDate(ExpDate03) Then  

        'Determine the number of events on this order.
        SQLEventCount = "SELECT Count(OrderLine.ItemNumber) as TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode  WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode IN ( " & EventCodeList03 & ") AND OrderLine.SeatTypeCode = 1 " 
        Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)	
        TicketCount03 = rsEventCount("TicketCount")	
        rsEventCount.Close
        Set rsEventCount = nothing 
        
        ErrorLog("TicketCount03 " & TicketCount03 & "") 

            'Determine if this meets the 3 event minimum
            'If not skip over and determine if it meets the 2 event minimum
            '----------------------------------------------
            If TicketCount03 >= SeriesCount03 Then       
        						
	                'Determine the correct ticket count to discount
	                'Must be a multiple of 3
	                '----------------------------------------------
	                If TicketCount = SeriesCount03 Then	            
	                    TicketSub03 = TicketCount03  
	                Else	                
	                    CountRemainder = (TicketCount03 Mod SeriesCount03)
                		
                        If CountRemainder = 0 Then
                            TicketSub03 = (TicketCount03)       
                        Else
                            TicketSub03 = (TicketCount03 - CountRemainder)
                        End If                    
                    End If
                                  

	                'Process the discounts
	                '----------------------------------------------
                    'Count # of existing seats which have discount applied for this act and seat type code
                    SQLDiscCount = "SELECT Count(OrderLine.ItemNumber) as LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode  WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode IN ( " & EventCodeList03 & ") AND OrderLine.SeatTypeCode = 1 AND DiscountTypeNumber = " & DiscountTypeNumber & "" 
                    Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount) 
                    AppliedCount03 = rsDiscCount("LineCount")    
                    rsDiscCount.Close
                    Set rsDiscCount = nothing 
                    
                    ErrorLog("AppliedCount03  " & AppliedCount03  & "") 
                    
                    
                                    'Apply the discount to tickets that make up the 3 event subscription
                                    '--------------------------------------------------------------------
                                    If AppliedCount03 <  TicketSub03 Then
                                    
                                            Select Case SeatTypeCode
                                                Case 1 
                                           	            
                                                    NewPrice = Clean(Request("Price")) - SeriesDiscount03
                                    
                                                    If NewPrice < 0 Then
                                                       NewPrice = 0
                                                    End If

                                                    If Price > NewPrice Then
                                                       DiscountAmount = Clean(Request("Price")) - NewPrice	
                                                       AppliedFlag = "Y"
                                                    End If
                                                    
                                            End Select
                                    
                                    Else
                                    
                                        '---------------------
                                        ' Start 2 Flex Package
                                        '---------------------   

                                            'Determine the original order date, for date based season subscriptions
                                            'this allows re-opened orders to calculate based on the original order date

                                            SQLDateCheck = "SELECT OrderHeader.OrderDate FROM OrderHeader (NOLOCK) WHERE OrderHeader.OrderNumber = " & OrderNumber & ""
                                            Set rsDateCheck = OBJdbConnection.Execute(SQLDateCheck)
                                            OriginalDate = rsDateCheck("OrderDate")
                                            rsDateCheck.Close
                                            Set rsDateCheck = nothing

                                            If CDate(OriginalDate) < CDate(ExpDate02) Then  

                                                    'Determine the number of events on this order.
                                                    'SQLEventCount = "SELECT COUNT(Seat.ItemNumber) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Clean(Request("OrderNumber"))& " AND Seat.EventCode IN (" & EventCodeList02 & ") AND OrderLine.SeatTypeCode = " & SeriesSeatType02 & " " 
                                                    SQLEventCount = "SELECT COUNT(Seat.ItemNumber) AS SeatCount  FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode      WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode IN (" & EventCodeList02 & ") AND OrderLine.SeatTypeCode = 1 AND OrderLine.Discount < 5" 
                                                    Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)

	                                                If Not rsEventCount.EOF Then
                                            	    
		                                                If rsEventCount("SeatCount") >= SeriesCount02 Then 'Apply the discount to this order                
                                                        
                                                            'Count # of existing seats which have discount applied.
			                                                SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode IN (" & EventCodeList02 & ")  AND OrderLine.SeatTypeCode = " & SeriesSeatType02 & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber 
			                                                Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount) 
			                                                
			                                                'Determine the correct ticket count to discount
	                                                        'Must be a multiple of 2
	                                                        '----------------------------------------------
	                                                        If rsEventCount("SeatCount") = SeriesCount02 Then	            
	                                                            TicketSub02 = rsEventCount("SeatCount")
	                                                        Else	                
	                                                            CountRemainder = (rsEventCount("SeatCount") Mod SeriesCount02)
                                                        		
                                                                If CountRemainder = 0 Then
                                                                    TicketSub02 = (rsEventCount("SeatCount"))       
                                                                Else
                                                                    TicketSub02 = (rsEventCount("SeatCount") - CountRemainder)
                                                                End If                    
                                                            End If
                                            			    
			                                                Select Case SeatTypeCode
			                                                
                                                                Case 1                                                 	            
                                                                NewPrice = Clean(Request("Price")) - SeriesDiscount02	
                                                                
                                                                If NewPrice < 0 Then
                                                                   NewPrice = 0
                                                                End If

                                                                If Price > NewPrice Then
                                                                   DiscountAmount = Clean(Request("Price")) - NewPrice	
                                                                   AppliedFlag = "Y"
                                                                End If
                                                                	
                                                            End Select    	    
                                                                
	                                                        
                                                            rsDiscCount.Close
	                                                        Set rsDiscCount = nothing 
	                                                                   
                                                        End If
                                                    End If
                                                    
                                                    rsEventCount.Close
	                                                Set rsEventCount = nothing
                                                    
                                            End If  

                                            '--------------------
                                            ' End 2 Flex Package
                                            '--------------------
                                    
                                    End If        
                    
            ELSE

                '--------------------
                ' Start 2 Flex Package
                '--------------------

                
                NewPrice = Price
                
                '--------------------
                ' End 2 Flex Package
                '--------------------

            End If							
End If
        	
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>