<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->

<%

'Initialize Variables
NewPrice = Clean(Request("Price"))
Price = Clean(Request("Price"))
Surcharge = Clean(Request("Surcharge"))
OrderNumber = Clean(Request("OrderNumber"))
EventCode = Clean(Request("EventCode"))
DiscountTypeNumber = Clean(Request("DiscountTypeNumber"))
SeatTypeCode = Clean(Request("SeatTypeCode"))
AppliedFlag = "N"

'Discount Code Variables
TicketTypeOne = "6017"
TicketTypeTwo = "6018"
TicketTypeThree = "6019"
TicketTypeFour = "6020"

'====================================
				
'Determine the number of tickets type one on order
SQLTicketOne = "SELECT COUNT(OrderLine.LineNumber) AS Count FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND EventCode = " & EventCode & " AND OrderLine.SeatTypeCode = " & TicketTypeOne & " "
Set rsTicketOne = OBJdbConnection.Execute(SQLTicketOne)

If rsTicketOne("Count") => 4 Then

    'Count tickets which have already been discounted
    SQLDiscTicketCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.SeatTypeCode = " & TicketTypeOne & ""
    Set rsDiscTicketCount = OBJdbConnection.Execute(SQLDiscTicketCount)  
        
    		'Determine if this ticket receives a discount							
			If (rsDiscTicketCount("LineCount")/ rsTicketOne("Count")) < (4 / rsTicketOne("Count")) Then 
				Select Case SeatTypeCode 
				Case TicketTypeOne
	                NewPrice = Price
	            End Select
			Else
		        Select Case SeatTypeCode 
                Case TicketTypeOne
	                NewPrice = 45
	            End Select
			End If
            
    rsDiscTicketCount.Close
    Set rsDiscTicketCount = nothing
	
End If

rsTicketOne.Close
Set rsDiscTicketOne = nothing

'====================================
'====================================
				
'Determine the number of tickets type Two on order
SQLTicketTwo = "SELECT COUNT(OrderLine.LineNumber) AS Count FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND EventCode = " & EventCode & " AND OrderLine.SeatTypeCode = " & TicketTypeTwo & " "
Set rsTicketTwo = OBJdbConnection.Execute(SQLTicketTwo)

If rsTicketTwo("Count") => 4 Then

    'Count tickets which have already been discounted
    SQLDiscTicketCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.SeatTypeCode = " & TicketTypeTwo & ""
    Set rsDiscTicketCount = OBJdbConnection.Execute(SQLDiscTicketCount)  
        
    		'Determine if this ticket receives a discount							
			If (rsDiscTicketCount("LineCount")/ rsTicketTwo("Count")) < (4 / rsTicketTwo("Count")) Then 
				Select Case SeatTypeCode 
				Case TicketTypeTwo
	                NewPrice = Price
	            End Select
			Else
		        Select Case SeatTypeCode 
                Case TicketTypeTwo
	                NewPrice = 40
	            End Select
			End If
            
    rsDiscTicketCount.Close
    Set rsDiscTicketCount = nothing
	
End If

rsTicketTwo.Close
Set rsDiscTicketTwo = nothing

'====================================
'====================================
				
'Determine the number of tickets type Three on order
SQLTicketThree = "SELECT COUNT(OrderLine.LineNumber) AS Count FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND EventCode = " & EventCode & " AND OrderLine.SeatTypeCode = " & TicketTypeThree & " "
Set rsTicketThree = OBJdbConnection.Execute(SQLTicketThree)

If rsTicketThree("Count") => 4 Then

    'Count tickets which have already been discounted
    SQLDiscTicketCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.SeatTypeCode = " & TicketTypeThree & ""
    Set rsDiscTicketCount = OBJdbConnection.Execute(SQLDiscTicketCount)  
        
    		'Determine if this ticket receives a discount							
			If (rsDiscTicketCount("LineCount")/ rsTicketThree("Count")) < (4 / rsTicketThree("Count")) Then 
				Select Case SeatTypeCode 
				Case TicketTypeThree
	                NewPrice = Price
	            End Select
			Else
		        Select Case SeatTypeCode 
                Case TicketTypeThree
	                NewPrice = 40
	            End Select
			End If
            
    rsDiscTicketCount.Close
    Set rsDiscTicketCount = nothing
	
End If

rsTicketThree.Close
Set rsDiscTicketThree = nothing

'====================================
'====================================
				
'Determine the number of tickets type Four on order
SQLTicketFour = "SELECT COUNT(OrderLine.LineNumber) AS Count FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND EventCode = " & EventCode & " AND OrderLine.SeatTypeCode = " & TicketTypeFour & " "
Set rsTicketFour = OBJdbConnection.Execute(SQLTicketFour)

If rsTicketFour("Count") => 4 Then

    'Count tickets which have already been discounted
    SQLDiscTicketCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.SeatTypeCode = " & TicketTypeFour & ""
    Set rsDiscTicketCount = OBJdbConnection.Execute(SQLDiscTicketCount)  
        
    		'Determine if this ticket receives a discount							
			If (rsDiscTicketCount("LineCount")/ rsTicketFour("Count")) < (4 / rsTicketFour("Count")) Then 
				Select Case SeatTypeCode 
				Case TicketTypeFour
	                NewPrice = Price
	            End Select
			Else
		        Select Case SeatTypeCode 
                Case TicketTypeFour
	                NewPrice = 40
	            End Select
			End If
            
    rsDiscTicketCount.Close
    Set rsDiscTicketCount = nothing
	
End If

rsTicketFour.Close
Set rsDiscTicketFour = nothing

'====================================


DiscountAmount = Clean(Request("Price")) - NewPrice   
AppliedFlag = "Y" 

If Request("NewSurcharge") <> "" Then
    Surcharge = NewSurcharge
Else
    If Request("CalcServiceFee") <> "N" Then
	    Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, Clean(Request("EventCode")), Clean(Request("ItemType")))
    End If
End If

'====================================


Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>