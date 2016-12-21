<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'Barbershop Harmony Society (6/28/2010)
'=======================================
'UPDATE: Added additional ticket types and changed pricing 

'Pricing was changed from FixedPrice to DiscountAmount to
'allow for the same discount accross different events / ticket prices

'Famly pack tickets receive $16.74 discount per ticket
'Additional Child tickets receive $44.00 discount
'Additional Adult tickets are not discounted.

' New Adult ticket types:
' 3442  Member/ Associate 
' 123   Non-Member
' 4506  VIP Member/ Associate
' 4507  VIP Non-Member

' New Child ticket types:
' 765   Youth 
' 3445  Youth (25 and under)
' 4505  VIP Youth (25 and under)



'Barbershop Harmony Society (6/23/2009)
'=======================================
' Family Pack Discount
' Package Price: $349.00

' Discount requires 2 Adult tickets + 2 Child tickets
' Discount requires Adult/Child tickets in multiples of 4

' Non-Member tickets are discounted to 4142.25
' Member tickets are discounted to $122.25
' No discount on additional Adult tickets

' Youth tickets are discounted to $52.25 per ticket
' additional child tickets are discounted to $25.00

' Valid Adult ticket types:
' 3442  Member/ Associate 
' 123   Non-Member

' Valid Child ticket types:
' 3445  Youth (25 and under)


'Discount Code Variables
FamPakQty = 4 
AdultList = "123,3442,4506,4507" 
ChildList = "3445,4505,765"
FamilyDiscount = 16.75
ExtraDisc = 44.00 

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
                                Case 123,3442,4506,4507 'AdultList
                                    NewPrice = (Price - FamilyDiscount)                
                                    AppliedFlag = "Y"
                             End Select 					
                         End If
                	                     	        
  
                	        	        		
                        'Apply the discount to Child tickets
	                    If Int(rsDiscChildCount("LineCount") / (FamPakQty / 2)) < Int(rsAdultCount("AdultCount") / (FamPakQty / 2)) Then        			        
                           Select Case SeatTypeCode 
                                Case 3445,4505,765
	                                NewPrice = (Price - FamilyDiscount)  
	                                AppliedFlag = "Y"		
                            End Select                        
	                    Else         					
			                Select Case SeatTypeCode 
				                Case 3445,4505,765
					                NewPrice = (Price - ExtraDisc) 
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

