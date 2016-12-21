<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->

<%
'Allentown Symphony Family Package Discount - 4/23/2010
'------------------------------------------------------
'Added Magical Tales to Family Pack Discount

'Magical Tales: 2 Adult tickets + 2 Child tickets = $40.00 total
'Adult tickets are discounted down to $13.50 per ticket
'Child tickets are discounted down to $6.50 per ticket

'ZooBash: 2 Adult tickets + 2 Zoobilee tickets = $55.00 total
'Adult tickets are discounted down to $15.75 per ticket
'Zoobilee tickets are discounted down to $11.75 per ticket

'Peter and the Wolf: 2 Adult tickets + 2 Child tickets = $30.00 total
'Adult (18 and over) tickets are discounted down to $9.5 per ticket
'Child (12 and under) tickets are discounted down to $5.5 per ticket


'Allentown Symphony Family Package Discount - 4/19/2010
'------------------------------------------------------
'Update: Peter and the Wolf - changed ticket type from "Adult" to "Adult (18 and over)"
'Update: Peter and the Wolf - added a new surcharge of $1.50 per ticket.


'Allentown Symphony Family Pack Discount - 2/11/2010
'------------------------------------------------------
'Added ZooBash to Family Pack Discount

'ZooBash: 2 Adult tickets + 2 Zoobilee tickets = $55.00 total
'Adult tickets are discounted down to $15.75 per ticket
'Zoobilee tickets are discounted down to $11.75 per ticket

'Peter and the Wolf: 2 Adult tickets + 2 Child tickets = $30.00 total
'Adult tickets are discounted down to $9.5 per ticket
'Child (12 and under) tickets are discounted down to $5.5 per ticket


'Allentown Symphony Family Package Discount - 2/09/2010
'-------------------------------------------------------
'Peter and the Wolf: 2 Adult tickets + 2 Child tickets = $30.00 total
'Adult tickets are discounted down to $9.5 per ticket
'Child tickets are discounted down to $5.5 per ticket

'Initialize Variables
NewPrice = Clean(Request("Price"))
Surcharge = Clean(Request("Surcharge"))
OrderNumber = Clean(Request("OrderNumber"))
EventCode = Clean(Request("EventCode"))
DiscountTypeNumber = Clean(Request("DiscountTypeNumber"))
SeatTypeCode = Clean(Request("SeatTypeCode"))
AppliedFlag = "N"

'Discount Code Variables
PeterEventCode = 197186
FamPakQty= 4 'Number of tickets in each Family Pack
AdultList = "269" 'List of valid Adult ticket SeatType Codes
ChildList = "5" 'List of valid Child ticket SeatType Codes

ZooEventCode = 230663
FamPakQty= 4 'Number of tickets in each Family Pack
ZooAdultList = "1" 'List of valid Adult ticket SeatType Codes
ZooChildList = "3873" 'List of valid Child ticket SeatType Codes


'========================================
'Peter and the Wolf Family Pack Discount
'========================================

'Determine the number of Adult and Child tickets on the order
SQLEventCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Clean(Request("OrderNumber")) & " AND Seat.EventCode = " & PeterEventCode & " AND OrderLine.SeatTypeCode IN (" & AdultList & ", " & ChildList & ")"
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
		        Select Case EventCode
		            Case 197186 'Peter and the Wolf
		                Select Case SeatTypeCode 
			                Case AdultList 'Adult
				                NewPrice = 9.50
				                Surcharge = 1.50
                        End Select 
                End Select 
    	     End If
    	     
    	     
    	    'Count Child tickets which have already been discounted
		    SQLDiscChildCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.SeatTypeCode IN (" & ChildList & ")"
		    Set rsDiscChildCount = OBJdbConnection.Execute(SQLDiscChildCount)
    		
            'Apply the discount to remaining Child tickets
		    If Int(rsDiscChildCount("LineCount") / (FamPakQty / 2)) < Int(rsEventCount("SeatCount") / FamPakQty) Then
		        Select Case EventCode
		            Case 197186 'Peter and the Wolf
		                Select Case SeatTypeCode 
			                Case ChildList 'Child
				                NewPrice = 5.50
				                Surcharge = 1.50
                        End Select 
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

'===================================
'ZooBash Family Pack Discount
'===================================

'Determine the number of Adult and Child tickets on the order for ZooBash
SQLZooBashEventCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Clean(Request("OrderNumber")) & " AND Seat.EventCode = " & ZooEventCode & " AND OrderLine.SeatTypeCode IN (" & ZooAdultList & ", " & ZooChildList & ")"
Set rsZooBashEventCount = OBJdbConnection.Execute(SQLZooBashEventCount)

If Not rsZooBashEventCount.EOF Then	

	If rsZooBashEventCount("SeatCount") >= FamPakQty Then 
				
				
	    'Determine the number of Adult tickets on order
	    SQLAdultCount = "SELECT COUNT(OrderLine.LineNumber) AS AdultCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND EventCode = " & ZooEventCode & " AND OrderLine.SeatTypeCode IN (" & ZooAdultList & ")"
	    Set rsAdultCount = OBJdbConnection.Execute(SQLAdultCount)
    	
	    'Determine the number of Child tickets on order
	    SQLChildCount = "SELECT COUNT(OrderLine.LineNumber) AS ChildCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND EventCode = " & ZooEventCode & " AND OrderLine.SeatTypeCode IN (" & ZooChildList & ")"
	    Set rsChildCount = OBJdbConnection.Execute(SQLChildCount)
    	
        'Verify the ratio of Adult to Child tickets
	    If rsAdultCount("AdultCount") => (FamPakQty / 2) And rsChildCount("ChildCount") => (FamPakQty / 2)  Then '

		    'Count Adult tickets which have already been discounted
		    SQLDiscAdultCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & ZooEventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.SeatTypeCode IN (" & ZooAdultList & ")"
		    Set rsDiscAdultCount = OBJdbConnection.Execute(SQLDiscAdultCount)
    		
            'Apply the discount to remaining Adult tickets
		    If Int(rsDiscAdultCount("LineCount") / (FamPakQty / 2)) < Int(rsZooBashEventCount("SeatCount") / FamPakQty) Then	
		        Select Case EventCode
		            Case 230663 'ZooBash
		                Select Case SeatTypeCode 
			                Case ZooAdultList 'Adult
				                NewPrice = 11.75
                        End Select 
                End Select 
    	     End If
    	     
    	     
    	    'Count Child tickets which have already been discounted
		    SQLDiscChildCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & ZooEventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.SeatTypeCode IN (" & ZooChildList & ")"
		    Set rsDiscChildCount = OBJdbConnection.Execute(SQLDiscChildCount)
    		
            'Apply the discount to remaining Child tickets
		    If Int(rsDiscChildCount("LineCount") / (FamPakQty / 2)) < Int(rsZooBashEventCount("SeatCount") / FamPakQty) Then
		        Select Case EventCode
		            Case 230663 'ZooBash
		                Select Case SeatTypeCode 
			                Case ZooChildList 'Child
				                NewPrice = 15.75
                        End Select 
                End Select        
    	     End If 				
    		
    		DiscountAmount = Clean(Request("Price")) - NewPrice   
    		AppliedFlag = "Y"			
    							
		    rsZooBashEventCount.Close
		    Set rsZooBashEventCount = nothing

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

'===================================
'Magical Tales Family Pack Discount
'===================================

'Determine the number of Adult and Child tickets on the order for Magical Tales
SQLMagicalTalesEventCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Clean(Request("OrderNumber")) & " AND Seat.EventCode = " & MagicEventCode & " AND OrderLine.SeatTypeCode IN (" & MagicAdultList & ", " & MagicChildList & ")"
Set rsMagicalTalesEventCount = OBJdbConnection.Execute(SQLMagicalTalesEventCount)

If Not rsMagicalTalesEventCount.EOF Then	

	If rsMagicalTalesEventCount("SeatCount") >= FamPakQty Then 
				
				
	    'Determine the number of Adult tickets on order
	    SQLAdultCount = "SELECT COUNT(OrderLine.LineNumber) AS AdultCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND EventCode = " & MagicEventCode & " AND OrderLine.SeatTypeCode IN (" & MagicAdultList & ")"
	    Set rsAdultCount = OBJdbConnection.Execute(SQLAdultCount)
    	
	    'Determine the number of Child tickets on order
	    SQLChildCount = "SELECT COUNT(OrderLine.LineNumber) AS ChildCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND EventCode = " & MagicEventCode & " AND OrderLine.SeatTypeCode IN (" & MagicChildList & ")"
	    Set rsChildCount = OBJdbConnection.Execute(SQLChildCount)
    	
        'Verify the ratio of Adult to Child tickets
	    If rsAdultCount("AdultCount") => (FamPakQty / 2) And rsChildCount("ChildCount") => (FamPakQty / 2)  Then '

		    'Count Adult tickets which have already been discounted
		    SQLDiscAdultCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & MagicEventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.SeatTypeCode IN (" & MagicAdultList & ")"
		    Set rsDiscAdultCount = OBJdbConnection.Execute(SQLDiscAdultCount)
    		
            'Apply the discount to remaining Adult tickets
		    If Int(rsDiscAdultCount("LineCount") / (FamPakQty / 2)) < Int(rsMagicalTalesEventCount("SeatCount") / FamPakQty) Then	
		        Select Case EventCode
		            Case 230663 'MagicalTales
		                Select Case SeatTypeCode 
			                Case MagicAdultList 'Adult
				                NewPrice = MagicAdultPrice
                        End Select 
                End Select 
    	     End If
    	     
    	     
    	    'Count Child tickets which have already been discounted
		    SQLDiscChildCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & MagicEventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.SeatTypeCode IN (" & MagicChildList & ")"
		    Set rsDiscChildCount = OBJdbConnection.Execute(SQLDiscChildCount)
    		
            'Apply the discount to remaining Child tickets
		    If Int(rsDiscChildCount("LineCount") / (FamPakQty / 2)) < Int(rsMagicalTalesEventCount("SeatCount") / FamPakQty) Then
		        Select Case EventCode
		            Case MagicEventCode
		                Select Case SeatTypeCode 
			                Case MagicChildList 
				                NewPrice = MagicChildPrice
                        End Select 
                End Select        
    	     End If 				
    		
    		DiscountAmount = Clean(Request("Price")) - NewPrice   
    		AppliedFlag = "Y"			
    							
		    rsMagicalTalesEventCount.Close
		    Set rsMagicalTalesEventCount = nothing

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