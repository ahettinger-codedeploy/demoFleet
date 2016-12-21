<%

'CHANGE LOG
'SSR 6/30/2011 - 'Custom Discount Code

'SSR 6/22/2011 - 'Updated Discount Code with new pricing


%>

<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'====================================================================

'Barbershop Harmony Society Family Pack Discount

' Family Pack Discount
' Package Price: $499.00 (plus any additonal fees)

' Discount requires 2 Adult tickets + 2 Child tickets
' Discount requires tickets in multiples of 4

' Each Adult (Member and Non-Member) ticket within the Family Pack is priced at $179.75
' Each Child ticket within the Family Pack is priced at $69.75
' Any additional child tickets outside the Family Pack are priced at $30.00
' No discount on additional Adult tickets

' Valid Adult ticket types:
' 3442  Member/ Associate 
' 123   Non-Member 

' Valid Child ticket types: 
' 3445  Youth (25 and under) 

'====================================================================

FamPakQty = 4 

AdultList = "3442,123" 

ChildList = "3445" 

'====================================================================

'Determine the number of Adult and Child tickets on the order
SQLEventCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Clean(Request("OrderNumber")) & " AND Seat.EventCode = " & EventCode & " AND OrderLine.SeatTypeCode IN (" & AdultList & ", " & ChildList & ")"
Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)

If Not rsEventCount.EOF Then	

        If rsEventCount("SeatCount") >= FamPakQty Then         				
        				
	            'Determine the number of Adult tickets on order
	            SQLAdultCount = "SELECT COUNT(OrderLine.LineNumber) AS AdultCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND EventCode = " & EventCode & " AND OrderLine.SeatTypeCode IN (" & AdultList & ")"
	            Set rsAdultCount = OBJdbConnection.Execute(SQLAdultCount)
            	
	            'Determine the number of Child tickets on order
	            SQLChildCount = "SELECT COUNT(OrderLine.LineNumber) AS ChildCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND EventCode = " & EventCode & " AND OrderLine.SeatTypeCode IN (" & ChildList & ")"
	            Set rsChildCount = OBJdbConnection.Execute(SQLChildCount)
            	
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
                                    NewPrice = 179.75           
                                    AppliedFlag = "Y"
                                Case 123 'Non-Member
                                    NewPrice = 179.75              
                                    AppliedFlag = "Y"
                             End Select  					
                        End If          	        
  
                	        	        		
                        'Apply the discount to Child tickets
	                    If Int(rsDiscChildCount("LineCount") / (FamPakQty / 2)) < Int(rsAdultCount("AdultCount") / (FamPakQty / 2)) Then        			        
                           Select Case SeatTypeCode 
                                Case 3445
	                                NewPrice = 69.75  
	                                AppliedFlag = "Y"		
                            End Select                        
	                    Else         					
			                Select Case SeatTypeCode 
				                Case 3445
					                NewPrice = 30.00
					                AppliedFlag = "Y" 
	                        End Select	
	                    End If		
                		
		                DiscountAmount = (Price - NewPrice) 
		                
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

