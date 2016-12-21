<%

'CHANGE LOG - Inception
'SSR 8/10/2011
'Custom Discount Code

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'========================================================

'Initialize Variables
QtyToBuy = 5
QtyFree = 1
AllEvents = True

'========================================================


If AllowDiscount = "Y" Then 'It's okay to apply to this order type and Seat Type.


    If AllEvents Then
	    SQLCount = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') INNER JOIN DiscountEvents (NOLOCK) ON Seat.EventCode = DiscountEvents.EventCode AND DiscountEvents.DiscountTypeNumber = "& DiscountTypeNumber & " WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.Price >= " & Price & " AND OrderLine.Price > 0"
    Else
	    SQLCount = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.Price >= " & Price & " AND OrderLine.Price > 0 AND EventCode = " & EventCode
    End If
    
    Set rsCount = OBJdbConnection.Execute(SQLCount)
    nbrTickets = rsCount("TicketCount")
    rsCount.Close
    Set rsCount = nothing

    If NbrTickets > 1 Then 'Need to have more than one ticket on order


	    If Clean(Request("ExpirationDate")) <> "" Then 'The discount has an expiration date
		    ExpirationDate = CDate(Clean(Request("ExpirationDate")))
	    Else 'There is no expiration.  Add one to the current date so that it does not expire.
		    ExpirationDate = DateAdd("d", 1, Now())
	    End If


	    If Clean(Request("StartDate")) <> "" Then 'The discount has a start date
		    StartDate = CDate(Clean(Request("StartDate")))
	    Else 'There is no start date.  Subtract one from the current date so that it's valid now.
		    StartDate = DateAdd("d", -1, Now())
	    End If

	    If Now() > StartDate And Now() < ExpirationDate Then

	        'Count # of existing seats which have discount applied.
	        If Clean(Request("AllEvents")) = "Y" Then
		        SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber 
	        Else
		        SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber 
	        End If
	        Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
            QtyApplied = rsDiscCount("LineCount")
	        rsDiscCount.Close
	        Set rsDiscCount = nothing
    	
            TotalFree = 0
            QtyRemainder = NbrTickets Mod (QtyToBuy + QtyFree)
            If NbrTickets >= QtyToBuy + QtyFree Then
                If QtyRemainder > QtyToBuy Then
    	            TotalFree = Fix((NbrTickets - (QtyToBuy + QtyFree)) / (QtyToBuy + QtyFree)) * QtyFree + (QtyRemainder - QtyToBuy) + QtyFree
                Else
    	            TotalFree = Fix((NbrTickets - (QtyToBuy + QtyFree)) / (QtyToBuy + QtyFree)) * QtyFree + QtyFree
                End If
            Else 
                If NbrTickets > QtyToBuy Then
                    TotalFree = QtyRemainder - QtyToBuy
                End If
            End If

	        If QtyApplied < TotalFree Then 'Apply the discount
		        NewPrice = 0
		        DiscountAmount = Price - NewPrice
		        Surcharge = 0
		        AppliedFlag = "Y"
	        End If
        End If
    End If
End If
					
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>