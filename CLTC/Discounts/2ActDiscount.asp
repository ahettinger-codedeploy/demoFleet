<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%
'City Lights Theater Company of San Jose (5/20/2010)
'===================================================
'UPDATE:  Removed the Adult ticket restriction on the 
'Second Weekend in September


'City Lights Theater Company of San Jose (5/20/2010)
'===================================================
'If ticket buyer has one ticket to:
'ActCode    ActName 
'39966      Second Weekend in September

'They receive a discount on one ticket to:
'ActCode    ActName
'39967      Rent 

'Series Price
'------------
'Rent tickets discounted to $14.00, any ticket type
'SWS tickets, no discount, must be Adult ticket
'Discount is one-for-one.
'Discount expires on June 2nd at 12:00am
'Discount is automatic.
'Discount is available online and offline.


'Initialize Discount Variables
ActCode1 = "39966" 'Second Weekend in September
Count1 = 1

ActCode2 = "39967" 'Rent
Count2 = 1
FixedPrice2 = 14

ExpirationDate = CDate("6/2/2010")

AppliedFlag = "N"


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
        		
		               Select Case ActCode 'Second Weekend in September
                            Case 39966 
                                NewPrice = Price 
                            Case 39967 'Rent
                                NewPrice = 14
                        End Select  	
            		
                        If Price > NewPrice Then
                            DiscountAmount = Price - NewPrice
                            AppliedFlag = "Y"
                        Else
                            NewPrice = Price
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