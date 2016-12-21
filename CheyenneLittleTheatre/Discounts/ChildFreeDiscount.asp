<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'Cheyenne Little Theatre Players  (5/07/2010)
'=================================
'Buy 1 Adult ticket Get 1 Student ticket free
'Additional Student tickets are 50% off
'Valid for EventCode 245063 - Old Fashioned Melodrama - 7/16/2010   
'Automatic discount

'Initialize Discount Variables
AdultSeatType = "1"
AdultPaid = 1
ChildSeatType = "6"
ChildFree = 1
ChildPercentage = 50
AppliedFlag = "N"

'Determine number of Adult Tickets 
SQLCount = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ItemType = 'Seat' AND EventCode = " & EventCode & " AND OrderLine.SeatTypeCode IN (" & AdultSeatType & " )"
Set rsCount = OBJdbConnection.Execute(SQLCount)
NbrTickets = rsCount("TicketCount")
rsCount.Close
Set rsCount = nothing

If NbrTickets >= AdultPaid Then 'Need to have at least one ticket on order

		'Determine number of Child tickets which have been discounted
		SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber  & " AND OrderLine.SeatTypeCode IN (" & ChildSeatType & ")"
		Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)

		If Fix(rsDiscCount("LineCount")) < (Fix(NbrTickets) * ChildFree) Then 'Apply the discount
		
		    Select Case SeatTypeCode
			    Case ChildSeatType
			    NewPrice = 0
            End Select
       
       Else
       
        	Select Case SeatTypeCode
			    Case ChildSeatType
			    NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(ChildPercentage)/100), 2)
            End Select
            
       End If
       
        
        If Price > NewPrice Then
            DiscountAmount = Clean(Request("Price")) - NewPrice
            AppliedFlag = "Y"
        End If
    		
        If Request("NewSurcharge") <> "" Then
            Surcharge = NewSurcharge
        Else
            If Request("CalcServiceFee") <> "N" Then
	            Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, Clean(Request("EventCode")), Clean(Request("ItemType")))
            End If
        End If
        
	   rsDiscCount.Close
	   Set rsDiscCount = nothing

End If

					
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>