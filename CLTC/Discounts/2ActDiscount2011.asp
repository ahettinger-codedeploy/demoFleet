<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'===================================================

'City Lights Theater Company of San Jose (6/2/2011)


'Trigger
'-------
'With purchase of one ticket to Distracted (ActCode 55354)
'Receive discount on one ticket to Nine (ActCode 55355) 


'Restrictions
'------------
'Good only on events dated 8/11/2011 to 8/21/2011
'Good only if purchased before midnight on 6/30/2011
'Required ticket can be on current order or any order in the past 365 days


'Discount Amount
'---------------
'Offer tickets discounted by $10.00
'Required tickets do not get a discount
'Ratio is one-for-one.


'Automatic/Manual
'----------------
'Discount is automatic.


'Online/Offline
'--------------
'Discount is available both online and offline.

'===================================================

'Required Event: Distracted
ActCode1 = "55354"
Count1 = 1

'Offer Event: Nine
ActCode2 = "55355"
Count2 = 1

DiscAmount2 = 10

ExpirationDate = "6/30/2011"

AppliedFlag = "N"

'===================================================

If Now() < ExpirationDate Then 'It's okay to apply to this order.

        'Determine number of ActCode1 tickets on order
        SQLAct1Count = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ActCode1 & ""
        Set rsAct1Count = OBJdbConnection.Execute(SQLAct1Count)
        NbrTickets = rsAct1Count("LineCount")	
        rsAct1Count.Close
        Set rsAct1Count = nothing

        If NbrTickets >= Count1 Then 'Need to have at least one ticket on order

		        'Count number of Act2 tickets which have discount applied.
		        SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.ActCode = " & ActCode2 & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber  & ""
		        Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
        		
		        'Get Act Code
		        SQLAct = "SELECT ActCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
		        Set rsAct = OBJdbConnection.Execute(SQLAct)		
		        ActCode = rsAct("ActCode")		
		        rsAct.Close
		        Set rsAct = nothing

		        If Fix(rsDiscCount("LineCount")) < (Fix(NbrTickets)/ Count1) * Count2 Then 'Apply the discount
        		
		               Select Case ActCode
                            Case 55354      'Distracted
                                DiscountAmount = 0
                            Case 55355      'Nine
                                DiscountAmount = 10
                        End Select
                       
                        NewPrice = Price - DiscountAmount            
                        
                        If Price > NewPrice Then                                
                            
                            If NewPrice < 0 Then
                            NewPrice = 0
                            End If
                            
                            AppliedFlag = "Y"
                            
                        End If				
        			
		        End If
        				
		        rsDiscCount.Close
		        Set rsDiscCount = nothing

        End If

End If
					
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>