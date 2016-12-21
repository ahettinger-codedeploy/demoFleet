<%

'CHANGE LOG - Inception
'SSR  (12/14/2011) - Custom Discount Code Created. 
'SLM  (6/15/2012) - Added ticket type to ticket type list

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'====================================================================

'Bay View Association (1930)   
'Parameters: Buy  6  productions for $120.00
'Eligible ActCodes: 78810, 78809, 78806, 78805, 78808, 78807, 78811 
'Event code: 471212, 471213, 471214, 471215, 471216, 471218, 471217 3
'Discount should be allowed Online and Offline
'Service fees: leave intact
'Additional tickets should not be discounted. Must be 6 productions
'The discount should be automatic 
'Discount valid now until June 30th , 2012
'Discount:  Adult tickets only

'Act Code   Acts
'78805	    On The Rocks - Project Trio
'78806	    On The Rocks - Motown In Motion
'78807	    On The Rocks - The Wonderbread Years
'78808	    On The Rocks - The Good Lovelies
'78809	    On The Rocks - Chapter 6
'78810	    On The Rocks - Blind Pilot
'78811	    On The Rocks - Tribute to ABBA

'====================================================================

SeriesPrice = 120
SeriesCount = 6
SeriesTicketList = "1,6755" 
ActCodeList = "78810, 78809, 78806, 78805, 78808, 78807, 78811"
ExpDate = "06/30/12"

'====================================================================

'Determine that it's okay to apply discounts.

If AllowDiscount = "Y" Then 


    'Determine the original order date, this will allow re-opened orders to
    'keep the original discount should the order be re-opened after the exp date.

    SQLDateCheck = "SELECT OrderHeader.OrderDate FROM OrderHeader (NOLOCK) WHERE OrderHeader.OrderNumber = " & OrderNumber & ""
    Set rsDateCheck = OBJdbConnection.Execute(SQLDateCheck)
    OriginalDate = rsDateCheck("OrderDate")
    rsDateCheck.Close
    Set rsDateCheck = nothing

    If CDate(OriginalDate) < CDate(ExpDate) Then  

        'Determine the number of acts with matching ticket types.
        SQLActCount = "SELECT COUNT(ActCode) AS ActCount FROM (SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & OrderNumber & " AND OrderLine.SeatTypeCode = " & Clean(Request("SeatTypeCode")) & " AND Event.ActCode IN (" & ActCodeList & ") GROUP BY Event.ActCode) AS ActCount"
        Set rsActCount = OBJdbConnection.Execute(SQLActCount)	
        ActCount = rsActCount("ActCount")	
        rsActCount.Close
        Set rsActCount = nothing

        If ActCount => SeriesCount Then

            'Determine how many sets of matching act code are on the order
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
            
	                    'Count number of tickets which have been given a discount
	                    SQLCount = "SELECT COUNT(OrderLine.LineNumber) AS AppliedCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.OrderNumber = " & OrderNumber & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')" 
	                    Set rsCount = OBJdbConnection.Execute(SQLCount)
	                    Count = rsCount("AppliedCount")
	                    rsCount.Close
	                    Set rsCount = nothing
        	    
                        Remainder = Count MOD SeriesCount				        

                            If Remainder = SeriesCount - 1 Then 
                                NewPrice = SeriesPrice - ((SeriesCount - 1) * Round(SeriesPrice/SeriesCount, 2))
                            Else
                                NewPrice = Round(SeriesPrice/SeriesCount, 2)
                            End If
        				
	                        DiscountAmount =  Clean(Request("Price")) - NewPrice
        	    	            
                            If Request("NewSurcharge") <> "" Then
                                Surcharge = NewSurcharge	
                            ElseIf Request("CalcServiceFee") <> "N" Then
                                Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))				
                            End If
                
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