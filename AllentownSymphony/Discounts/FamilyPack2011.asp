<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'Allentown Symphony Orchestra
'====================================
'Family Package Discount - 8/17/2010

'2 Adult tickets + 2 Child tickets 

FamPakQty = 4 'Number of tickets in each Family Pack
FamPakTtl = 7 'Number of Family Pack Discounts

Dim FamilyEventCode(7)
Dim FamilyAdultList(7)
Dim FamilyChildList(7)
Dim FamilyAdultPrice(7)
Dim FamilyChildPrice(7)

'Alice & Wonderland (10/3/2010)
'Family 4 Pack Price: $50.00
FamilyEventCode(1) = "287579" 'Event Code
FamilyAdultList(1) = "1"  'Adult Seat Type Codes
FamilyChildList(1) = "1575" 'Child Seat Type Codes
FamilyAdultPrice(1) = "15.50" 'Adult Discounted Price
FamilyChildPrice(1) = "9.50" 'Child Discounted Price

'ZooBash (10/23/2010)
'Family 4 Pack Price: $55.00
FamilyEventCode(2) = "230663" 'Event Code
FamilyAdultList(2) = "1"  'Adult Seat Type Codes
FamilyChildList(2) = "3873" 'Child Seat Type Codes
FamilyAdultPrice(2) = "11.75" 'Adult Discounted Price
FamilyChildPrice(2) = "15.75" 'Child Discounted Price

'Strega Nona (10/31/2010)
'Family 4 Pack Price: $50.00
FamilyEventCode(3) = "285897" 'Event Code
FamilyAdultList(3) = "1"  'Adult Seat Type Codes
FamilyChildList(3) = "1575" 'Child Seat Type Codes
FamilyAdultPrice(3) = "15.50" 'Adult Discounted Price
FamilyChildPrice(3) = "9.50" 'Child Discounted Price

'Mooseltoe (11/27/2010)
'Family 4 Pack Price: $50.00
FamilyEventCode(4) = "287582" 'Event Code
FamilyAdultList(4) = "1"  'Adult Seat Type Codes
FamilyChildList(4) = "1575" 'Child Seat Type Codes
FamilyAdultPrice(4) = "15.50" 'Adult Discounted Price
FamilyChildPrice(4) = "9.50" 'Child Discounted Price

'Harold and the Purple Crayon (1/22/2010)
'Family 4 Pack Price: $50.00
FamilyEventCode(5) = "287797" 'Event Code
FamilyAdultList(5) = "1"  'Adult Seat Type Codes
FamilyChildList(5) = "1575" 'Child Seat Type Codes
FamilyAdultPrice(5) = "15.50" 'Adult Discounted Price
FamilyChildPrice(5) = "9.50" 'Child Discounted Price

'Harold and the Purple Crayon (1/22/2010)
'Family 4 Pack Price: $50.00
FamilyEventCode(6) = "287798" 'Event Code
FamilyAdultList(6) = "1"  'Adult Seat Type Codes
FamilyChildList(6) = "1575" 'Child Seat Type Codes
FamilyAdultPrice(6) = "15.50" 'Adult Discounted Price
FamilyChildPrice(6) = "9.50" 'Child Discounted Price

'Magical Tales (5/1/2011)
'Family 4 Pack Price; $40.00
FamilyEventCode(7) = "261790" 'Event Code
FamilyAdultList(7) = "1"  'Adult Seat Type Codes
FamilyChildList(7) = "417" 'Child Seat Type Codes
FamilyAdultPrice(7) = "13.80" 'Adult Discounted Price
FamilyChildPrice(7) = "6.80" 'Child Discounted Price


'===================================
'Allentown Family Pack Discount
'===================================

For i = 1 To FamPakTtl

'Determine the number of Adult and Child tickets on the order 
SQLFamilyEventCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Clean(Request("OrderNumber")) & " AND Seat.EventCode = " & FamilyEventCode(i) & " AND OrderLine.SeatTypeCode IN (" & FamilyAdultList(i) & ", " & FamilyChildList(i) & ")"
Set rsFamilyEventCount = OBJdbConnection.Execute(SQLFamilyEventCount)

If Not rsFamilyEventCount.EOF Then	

	If rsFamilyEventCount("SeatCount") >= FamPakQty Then 				
				
	    'Determine the number of Adult tickets on order
	    SQLAdultCount = "SELECT COUNT(OrderLine.LineNumber) AS AdultCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND EventCode = " & FamilyEventCode(i) & " AND OrderLine.SeatTypeCode IN (" & FamilyAdultList(i) & ")"
	    Set rsAdultCount = OBJdbConnection.Execute(SQLAdultCount)
    	
	    'Determine the number of Child tickets on order
	    SQLChildCount = "SELECT COUNT(OrderLine.LineNumber) AS ChildCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND EventCode = " & FamilyEventCode(i) & " AND OrderLine.SeatTypeCode IN (" & FamilyChildList(i) & ")"
	    Set rsChildCount = OBJdbConnection.Execute(SQLChildCount)
    	
        'Verify the ratio of Adult to Child tickets
	    If rsAdultCount("AdultCount") => (FamPakQty / 2) And rsChildCount("ChildCount") => (FamPakQty / 2)  Then '

		    'Count Adult tickets which have already been discounted
		    SQLDiscAdultCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & FamilyEventCode(i) & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.SeatTypeCode IN (" & FamilyAdultList(i) & ")"
		    Set rsDiscAdultCount = OBJdbConnection.Execute(SQLDiscAdultCount)
    		
            'Apply the discount to Adult tickets
		    If Int(rsDiscAdultCount("LineCount") / (FamPakQty / 2)) < Int(rsFamilyEventCount("SeatCount") / FamPakQty) Then	
		        Select Case EventCode
		            Case FamilyEventCode(i)  'Event Code
		                Select Case SeatTypeCode 
			                Case FamilyAdultList(i) 'Adult Seat Types
				                NewPrice = FamilyAdultPrice(i) 'Adult Price
                        End Select 
                End Select 
    	     End If
    	     
    	     
    	    'Count Child tickets which have already been discounted
		    SQLDiscChildCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & FamilyEventCode(i) & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.SeatTypeCode IN (" & FamilyChildList(i) & ")"
		    Set rsDiscChildCount = OBJdbConnection.Execute(SQLDiscChildCount)
    		
            'Apply the discount to Child tickets
		    If Int(rsDiscChildCount("LineCount") / (FamPakQty / 2)) < Int(rsFamilyEventCount("SeatCount") / FamPakQty) Then
		        Select Case EventCode
		             Case FamilyEventCode(i)  'Event Code
		                Select Case SeatTypeCode 
			                Case FamilyChildList(i) 'Child Seat Types
				                NewPrice = FamilyChildPrice(i) 'Child Price
                        End Select 
                End Select        
    	     End If 				
    		
    		DiscountAmount = Clean(Request("Price")) - NewPrice   
    		AppliedFlag = "Y"			
    							
		    rsFamilyEventCount.Close
		    Set rsFamilyEventCount = nothing

		    rsAdultCount.Close
		    Set rsAdultCount = nothing	

		    rsChildCount.Close
		    Set rsChildCount = nothing
    							
		    rsDiscAdultCount.Close
		    Set rsDiscAdultCount = nothing	
		    
		    rsDiscChildCount.Close
		    Set rsDiscChildCount = nothing	
		    	
	        If Request("NewSurcharge") <> "" Then
		       Surcharge = NewSurcharge
	        Else
		        If Request("CalcServiceFee") <> "N" Then
			        Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, Clean(Request("EventCode")), Clean(Request("ItemType")))
		        End If
	        End If	
    					
	    End If
										
	End If
	
End If

Next


Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>