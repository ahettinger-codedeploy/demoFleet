<%
'CHANGE LOG
'SSR - 11/19/2013 - New Discount Created

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'======================================================='

'Academy of Music Theatre (11/19/2013)

'Family 4 Pack: $25.00

'Valid Family Pack ticket types:

'Valid Adult Tickets

'SeatCode	SeatType
'--------------------
'1			Adult 
'3678		Adult cc 

'Valid Child Tickets

'SeatCode	SeatType
'--------------------
'5			Child 12 & under 
'417		Child 
'6			Student 
'3681 		Student cc 

'Note: For purposes of this family pack discount, 
'AdultCC, and StudentCC  will be counted as if they were Adult, Student tickets

'Discounts tickets in packs of 4
'Each family pack requires 2 Adult tickets + 2 Child tickets

'Adult tickets are discounted to $6.25 per ticket
'Child tickets are discounted to $6.25 per ticket

'Qualifying event is 612666 - The Sweetback Sisters’...
'Online and offline
'Additional tickets that do not meet the parameters do not get discounted.

'=========================================================

FamPakQty = 4 'Total Number of tickets in Family Pack
AdultList = "1,3678" 'Adult SeatType Codes
AdultPrice = 6.25 'Discounted Adult Price
ChildList = "5,417,6,3681" 'Child SeatType Codes
ChildPrice = 6.25 'Discounted Child Price


'Determine the number of Adult and Child tickets on the order
SQLEventCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Clean(Request("OrderNumber")) & " AND Seat.EventCode = " & Clean(Request("EventCode")) & " AND OrderLine.SeatTypeCode IN (" & AdultList & ", " & ChildList & ")"
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
    		
            'Apply the discount to remaining Adult tickets
		    If Int(rsDiscAdultCount("LineCount") / (FamPakQty / 2)) < Int(rsEventCount("SeatCount") / FamPakQty) Then	
		        Select Case SeatTypeCode 
			        Case 1,3678 'Adult
				        NewPrice = AdultPrice
                End Select  
    	     End If
    	     
    	     
    	    'Count Child tickets which have already been discounted
		    SQLDiscChildCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.SeatTypeCode IN (" & ChildList & ")"
		    Set rsDiscChildCount = OBJdbConnection.Execute(SQLDiscChildCount)
    		
            'Apply the discount to remaining Child tickets
		    If Int(rsDiscChildCount("LineCount") / (FamPakQty / 2)) < Int(rsEventCount("SeatCount") / FamPakQty) Then	
		        Select Case SeatTypeCode 
			        Case 5,417,6,3681 'Child
				        NewPrice = ChildPrice
                End Select 
    	     End If 				
    		
    		DiscountAmount = Clean(Request("Price")) - NewPrice 
			
    		AppliedFlag = "Y"			
    							
		    rsEventCount.Close
		    Set rsEventCount = nothing

		    rsAdultCount.Close
		    Set rsAdultCount = nothing	

		    rsChildCount.Close
		    Set rsChildCount = nothing
    							
		    rsDiscAdultCount.Close
		    Set rsDiscAdultCount = nothing	
		    
		    rsDiscChildCount.Close
		    Set rsDiscChildCount = nothing		
    					
	    End If
										
	End If
					
		If Request("NewSurcharge") <> "" Then
			Surcharge = NewSurcharge
		Else
			If Request("CalcServiceFee") <> "N" Then
				Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, Clean(Request("EventCode")), Clean(Request("ItemType")))
			End If
		End If
	
End If

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf
%>