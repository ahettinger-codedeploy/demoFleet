<%

'CHANGE LOG
'SSR 6/26/2014 - 'Custom Discount Code - Prices given for Family Pack discount ($179.75 x 2, $69.75 x 2) add up to $499, not $599. Will contact client to confirm
'SLM 6/26/2015 - Updated for 2016 and changed series price to $599

%>

<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'====================================================================

'Barbershop Harmony Society 

' 2015 Family Pack Discount

' Package Price: $599.00 (not including ticket and mailing fees).

' Discount requires 2 Adult tickets + 2 Child tickets
' Discount requires tickets in multiples of 4
' Additional tickets purchased with family pack 
' may qualify for discount pricing

' Family Pack Pricing
'---------------------
' Adult ticket: $204.95
' Child ticket: $94.75

' Additional ticket pricing
'-------------------------
' Adult ticket: no discount
' Child ticket: $30.00

' Valid Adult tickets
'-------------------------
' 3442  Member/ Associate 
' 123   Non-Member 

' Valid Child tickets
'-------------------------
' 3445  Youth (25 and under) 

'Discount Code
'-------------------------
'fp2015

'Automatic/Manual
'-------------------------
'Manual entry required

'Valid Events
'------------
'Event Code: 772235 2015 International Convention - Full Registration
'Event Code: 771162 2015 International Convention - VIP SEATING ONLY

'====================================================================

FamPakQty = 4 
AdultList = "3442,123" 
ChildList = "3445" 
AdultPrice = 204.75
MemberPrice = 204.75 
ChildPrice = 94.75
AddChild = 30.00

'----------------------------------------------------------------------

'Determine the number of Adult and Child tickets on the order
SQLEventCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Clean(Request("OrderNumber")) & " AND Seat.EventCode = " & EventCode & " AND OrderLine.SeatTypeCode IN (" & AdultList & ", " & ChildList & ")"
Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)

If Not rsEventCount.EOF Then	

        If rsEventCount("SeatCount") >= FamPakQty Then         				
        				
	            'Determine the number of Adult tickets on order
	            SQLAdultCount = "SELECT COUNT(OrderLine.LineNumber) AS AdultCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND EventCode = " & EventCode & " AND OrderLine.SeatTypeCode IN (" & AdultList & ")"
	            Set rsAdultCount = OBJdbConnection.Execute(SQLAdultCount)
				
				ErrorLog("AdultCount " & rsAdultCount("AdultCount") & "")
            	
	            'Determine the number of Child tickets on order
	            SQLChildCount = "SELECT COUNT(OrderLine.LineNumber) AS ChildCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND EventCode = " & EventCode & " AND OrderLine.SeatTypeCode IN (" & ChildList & ")"
	            Set rsChildCount = OBJdbConnection.Execute(SQLChildCount)
				
				ErrorLog("ChildCount " & rsChildCount("ChildCount") & "")
            	
                'Verify the ratio of Adult to Child tickets
	            If rsAdultCount("AdultCount") => (FamPakQty / 2) And rsChildCount("ChildCount") => (FamPakQty / 2)  Then '

	                    'Count Adult tickets which have already been discounted
	                    SQLDiscAdultCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.SeatTypeCode IN (" & AdultList & ")"
	                    Set rsDiscAdultCount = OBJdbConnection.Execute(SQLDiscAdultCount)
                	    
	                    'Count Child tickets which have already been discounted
	                    SQLDiscChildCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.SeatTypeCode IN (" & ChildList & ")"
	                    Set rsDiscChildCount = OBJdbConnection.Execute(SQLDiscChildCount)
                	        		
                        'Apply the discount to Adult tickets
                        If Int(rsDiscAdultCount("LineCount") / (FamPakQty / 2)) < Int(rsChildCount("ChildCount") / (FamPakQty / 2)) Then
                            Select Case SeatTypeCode 
                                Case 3442 'AdultList  Member/ Associate
                                    NewPrice = AdultPrice          
                                    AppliedFlag = "Y"
                                Case 123 'Non-Member
                                    NewPrice = MemberPrice            
                                    AppliedFlag = "Y"
                             End Select  					
                        End If          	        
  
						ErrorLog("NewPrice  " & NewPrice  & "")
                	        	        		
                        'Apply the discount to Child tickets
	                    If Int(rsDiscChildCount("LineCount") / (FamPakQty / 2)) < Int(rsAdultCount("AdultCount") / (FamPakQty / 2)) Then        			        
                           Select Case SeatTypeCode 
                                Case 3445
	                                NewPrice = ChildPrice  
	                                AppliedFlag = "Y"		
                            End Select                        
	                    Else         					
			                Select Case SeatTypeCode 
				                Case 3445
					                NewPrice = AddChild
					                AppliedFlag = "Y" 
	                        End Select	
	                    End If		
                		
		                DiscountAmount = (Price - NewPrice) 
						
						Surcharge = 0
		                
	                    If Request("CalcServiceFee") <> "N" Then
				        Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, Clean(Request("EventCode")), Clean(Request("ItemType")))
				        End If
						
                            
                    rsDiscAdultCount.Close
		            Set rsDiscAdultCount = nothing	
        		    
		            rsDiscChildCount.Close
		            Set rsDiscChildCount = nothing	
               
                End If  
    							
	            	rsAdultCount.Close
		            Set rsAdultCount = nothing	

		            rsChildCount.Close
		            Set rsChildCount = nothing

            					
	            End If
        										
        End If	

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>

