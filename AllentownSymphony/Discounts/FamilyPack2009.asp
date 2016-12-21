<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->

<%

'Allentown Symphony Family package Discount
'This discount requires multiples of 4 tickets to qualify for discount 

'Peter and the Wolf Family Discount
' 2 Adult tickets + 2 Child tickets = $30.00 total
'Adult tickets are discounted down to $9.5 per ticket
'Student tickets are discounted down to $5.5 per ticket

'Initialize Variables
NewPrice = Clean(Request("Price"))
Surcharge = Clean(Request("Surcharge"))
OrderNumber = Clean(Request("OrderNumber"))
EventCode = Clean(Request("EventCode"))
DiscountTypeNumber = Clean(Request("DiscountTypeNumber"))
SeatTypeCode = Clean(Request("SeatTypeCode"))
AppliedFlag = "N"

'Peter Discount Code Variables
PeterFamPakQty = 4 'Number of tickets in each Family Pack
PeterEventCode = 197186
PeterAdultList = "1" 'List of valid Adult ticket SeatType Codes
PeterChildList = "5" 'List of valid Child ticket SeatType Codes


'Determine the number of Adult and Child tickets on the order for Peter and the Wolf
SQLPeterEventCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Clean(Request("OrderNumber")) & " AND Seat.EventCode = " & PeterEventCode & " AND OrderLine.SeatTypeCode IN (" & PeterAdultList & ", " & PeterChildList & ")"
Set rsPeterEventCount = OBJdbConnection.Execute(SQLPeterEventCount)

If Not rsPeterEventCount.EOF Then	

	If rsPeterEventCount("SeatCount") >= PeterFamPakQty Then 
				
				
	    'Determine the number of Adult tickets on order
	    SQLAdultCount = "SELECT COUNT(OrderLine.LineNumber) AS AdultCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND EventCode = " & PeterEventCode & " AND OrderLine.SeatTypeCode IN (" & PeterAdultList & ")"
	    Set rsAdultCount = OBJdbConnection.Execute(SQLAdultCount)
    	
	    'Determine the number of Child tickets on order
	    SQLChildCount = "SELECT COUNT(OrderLine.LineNumber) AS ChildCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND EventCode = " & PeterEventCode & " AND OrderLine.SeatTypeCode IN (" & PeterChildList & ")"
	    Set rsChildCount = OBJdbConnection.Execute(SQLChildCount)
    	
        'Verify the ratio of Adult to Child tickets
	    If rsAdultCount("AdultCount") => (PeterFamPakQty / 2) And rsChildCount("ChildCount") => (PeterFamPakQty / 2)  Then '

		    'Count Adult tickets which have already been discounted
		    SQLDiscAdultCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & PeterEventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.SeatTypeCode IN (" & PeterAdultList & ")"
		    Set rsDiscAdultCount = OBJdbConnection.Execute(SQLDiscAdultCount)
    		
            'Apply the discount to remaining Adult tickets
		    If Int(rsDiscAdultCount("LineCount") / (PeterFamPakQty / 2)) < Int(rsPeterEventCount("SeatCount") / PeterFamPakQty) Then	
		        Select Case EventCode
		            Case 197186 'Peter and the Wolf
		                Select Case SeatTypeCode 
			                Case 1 'Adult
				                NewPrice = 9.50
                        End Select 
                End Select 
    	     End If
    	     
    	     
    	    'Count Child tickets which have already been discounted
		    SQLDiscChildCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & PeterEventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.SeatTypeCode IN (" & PeterChildList & ")"
		    Set rsDiscChildCount = OBJdbConnection.Execute(SQLDiscChildCount)
    		
            'Apply the discount to remaining Child tickets
		    If Int(rsDiscChildCount("LineCount") / (PeterFamPakQty / 2)) < Int(rsPeterEventCount("SeatCount") / PeterFamPakQty) Then
		        Select Case EventCode
		            Case 197186 'Peter and the Wolf
		                Select Case SeatTypeCode 
			                Case 5 'Child
				                NewPrice = 5.50
                        End Select 
                End Select        
    	     End If 				
    		
    		DiscountAmount = Clean(Request("Price")) - NewPrice   
    		AppliedFlag = "Y"			
    							
		    rsPeterEventCount.Close
		    Set rsPeterEventCount = nothing

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