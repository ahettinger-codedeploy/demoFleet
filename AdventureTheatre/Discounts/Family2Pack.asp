<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'Adventure Theatre (8/4/2010)
'=======================================
'Family 2 Pack Discount

'Requires purchase of 1 Adult ticket and  1 Child ticket
'Each ticket is discounted to $175.00

'Adult/Youth ticket at $350.00 removed per Silvia
'Does not recalculate the service fees.  
'Discount is automatic.
'Valid for EventCode 284792 only

' Adult ticket types:
' 4528 Adult Only (21 and over)

' Child ticket types:
'4202 Child Registration Only

'Discount Code Variables
FamPakQty = 2 
AdultList = "4528" 
ChildList = "4202"
FamilyPrice = 175


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
                                Case 4528 'AdultList
                                    NewPrice = FamilyPrice             
                                    AppliedFlag = "Y"
                             End Select 					
                         End If
                	        	        		
                        'Apply the discount to Child tickets
	                    If Int(rsDiscChildCount("LineCount") / (FamPakQty / 2)) < Int(rsAdultCount("AdultCount") / (FamPakQty / 2)) Then        			        
                           Select Case SeatTypeCode 
                                Case 4202
                                    NewPrice = FamilyPrice        
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

