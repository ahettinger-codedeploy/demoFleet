<%

'CHANGE LOG - Inception
'SSR 9/26/2011
'Custom Discount Code Created.

%>

<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'==================================================
'California Pops Orchestra (9/26/2011)
'Group Discount


'Single Event Tickets
'Buy 	10-19 individual show tickets 	get $1 off  
'	    20-29				            get $2 off  '
'	    30+				                get $3 off		

'Season Group discount (6 tickets in set)
'Buy 	10-19 individual show tickets 	get $6 off  
'	    20-29				            get $12 off  
'	    30+				                get $18 off

'Eligible ActCodes / EventCodes

'EventCodes: 
'402991-Subscription
'402995, 402996, 402998, 402999, 403000, 403001- Single

'Offline/Online: Online and Offline
'Service Fees: No Service Fee Change
'Additional Tickets: Only complete subscriptions should be discounted for subscription flex
'All tickets for single event
'Automatic/Code Entry: Discount should be applied automatically 
'Expiration: No expiration
'Restrictions: exclude premium tickets.
'Contact
'Alicia
'California Pops Orchestra
'manager@californiapopsorchestra.com

'==================================================

IndGroupQuantity1 = 10
IndGroupDiscount1 = 1

IndGroupQuantity2 = 20
IndGroupDiscount2 = 2

IndGroupQuantity3 = 30
IndGroupDiscount3 = 3

SubGroupQuantity1 = 10
SubGroupDiscount1 = 6

SubGroupQuantity2 = 20
SubGroupDiscount2 = 12

SubGroupQuantity3 = 30
SubGroupDiscount3 = 18

'==================================================

If AllowDiscount = "Y" Then

        Select Case EventCode
        
            Case 402995, 402996, 402998, 402999, 403000, 403001

            SQLEventCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Clean(Request("OrderNumber")) & " AND Seat.EventCode = " & Clean(Request("EventCode"))
            Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)

            If Not rsEventCount.EOF Then
            
			        If rsEventCount("SeatCount") >= IndGroupQuantity1  And rsEventCount("SeatCount") <= (IndGroupQuantity2 - 1) Then 
				        NewPrice = Clean(Request("Price")) - IndGroupDiscount1
    				    
				    ElseIf rsEventCount("SeatCount") >= IndGroupQuantity2  And rsEventCount("SeatCount") <= (IndGroupQuantity3 - 1) Then 
				        NewPrice = Clean(Request("Price")) - IndGroupDiscount2
        			
			        ElseIf rsEventCount("SeatCount") >= IndGroupQuantity3 Then 
    				    NewPrice = Clean(Request("Price")) - IndGroupDiscount3

			        Else 
				        'No change in price
				         NewPrice = Clean(Request("Price"))
			        End If
        			
			        If Price > NewPrice Then
                        DiscountAmount = Clean(Request("Price")) - NewPrice
                        AppliedFlag = "Y"
                    End If
                    
            End If
            
            rsEventCount.Close
            Set rsEventCount = nothing
            
                        
            Case 402991

            SQLEventCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Clean(Request("OrderNumber")) & " AND Seat.EventCode = " & Clean(Request("EventCode"))
            Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)

            If Not rsEventCount.EOF Then
            
			        If rsEventCount("SeatCount") >= SubGroupQuantity1  And rsEventCount("SeatCount") <= (SubGroupQuantity2 - 1) Then 
				        NewPrice = Clean(Request("Price")) - SubGroupDiscount1
    				    
				    ElseIf rsEventCount("SeatCount") >= SubGroupQuantity2  And rsEventCount("SeatCount") <= (SubGroupQuantity3 - 1) Then 
				        NewPrice = Clean(Request("Price")) - SubGroupDiscount2
        			
			        ElseIf rsEventCount("SeatCount") >= SubGroupQuantity3 Then 
    				    NewPrice = Clean(Request("Price")) - SubGroupDiscount3

			        Else 
				        'No change in price
				         NewPrice = Clean(Request("Price"))
			        End If
        			
			        If Price > NewPrice Then
                        DiscountAmount = Clean(Request("Price")) - NewPrice
                        AppliedFlag = "Y"
                    End If
                    
            End If
            
            rsEventCount.Close
            Set rsEventCount = nothing
            
      End Select
	
End If

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>