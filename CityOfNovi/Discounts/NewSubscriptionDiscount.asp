<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<%

'Initialize Variables
Price = Clean(Request("Price"))
NewPrice = Price
DiscountAmount = 0
Surcharge = Clean(Request("Surcharge"))
OrderNumber = Clean(Request("OrderNumber"))
SeatTypeCode = Clean(Request("SeatTypeCode"))
AppliedFlag = "N"
ActCodeList = ""

SQLAct1Count = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & CleanNumeric(OrderNumber) & " AND ActCode = 26599"
Set rsAct1Count = OBJdbConnection.Execute(SQLAct1Count)
NoTixAct1 = rsAct1Count("LineCount")
rsAct1Count.Close
Set rsAct1Count = nothing

SQLAct2Count = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & CleanNumeric(OrderNumber) & " AND ActCode = 26600"
Set rsAct2Count = OBJdbConnection.Execute(SQLAct2Count)
NoTixAct2 = rsAct2Count("LineCount")
rsAct2Count.Close
Set rsAct2Count = nothing

SQLAct3Count = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & CleanNumeric(OrderNumber) & " AND ActCode = 26602"
Set rsAct3Count = OBJdbConnection.Execute(SQLAct3Count)
NoTixAct3 = rsAct3Count("LineCount")
rsAct3Count.Close
Set rsAct3Count = nothing

SQLAct4Count = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & CleanNumeric(OrderNumber) & " AND ActCode = 26631"
Set rsAct4Count = OBJdbConnection.Execute(SQLAct4Count)
NoTixAct4 = rsAct4Count("LineCount")
rsAct4Count.Close
Set rsAct4Count = nothing

SQLAct5Count = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & CleanNumeric(OrderNumber) & " AND ActCode = 26632"
Set rsAct5Count = OBJdbConnection.Execute(SQLAct5Count)
NoTixAct5 = rsAct5Count("LineCount")
rsAct5Count.Close
Set rsAct5Count = nothing

SQLAct6Count = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & CleanNumeric(OrderNumber) & " AND ActCode = 26633"
Set rsAct6Count = OBJdbConnection.Execute(SQLAct6Count)
NoTixAct6 = rsAct6Count("LineCount")
rsAct6Count.Close
Set rsAct6Count = nothing

'check for the right subscription
If NoTixAct1 >= 1 And NoTixAct2 >= 1 And NoTixAct3 >= 1 And NoTixAct4 >= 1 And NoTixAct5 >= 1 And NoTixAct6 >= 1 Then
    'Full Season Pass, get all tickets for this subscription and apply discount
    SQLDiscountPackage = "SELECT OrderLine.Price, OrderLine.LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & CleanNumeric(OrderNumber) & " AND ActCode IN(26599,26600,26602,26631,26632,26633) AND Seat.EventCode = " & Clean(Request("EventCode"))
    Set rsDiscountPackage = OBJdbConnection.Execute(SQLDiscountPackage)
    If Not rsDiscountPackage.EOF Then
        If SeatTypeCode = "23" Or SeatTypeCode = "1555" Then 'Child/Senior
            NewPrice = 6.125
        Else 'Adult Tickets
            NewPrice = 7.75
        End If
        If Price > NewPrice Then
	        DiscountAmount = Price - NewPrice
	        AppliedFlag = "Y"
        End If
    End If    
ElseIf NoTixAct2 >= 1 And NoTixAct4 >= 1 And NoTixAct5 >= 1 Then
    'Young Actor Series, get all tickets for this subscription and apply discount
    SQLDiscountPackage = "SELECT OrderLine.Price, OrderLine.LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & CleanNumeric(OrderNumber) & " AND ActCode IN(26600,26631,26632) AND Seat.EventCode = " & Clean(Request("EventCode"))
    Set rsDiscountPackage = OBJdbConnection.Execute(SQLDiscountPackage)
    If Not rsDiscountPackage.EOF Then
        If SeatTypeCode = "1" Then        
            NewPrice = 8
        ElseIf SeatTypeCode = "23" Or SeatTypeCode = "1555" Then
            NewPrice = 6.25
        Else
            NewPrice = 2.5
        End If
        If Price > NewPrice Then
	        DiscountAmount = Price - NewPrice
	        AppliedFlag = "Y"
        End If
    End If
ElseIf NoTixAct1 >= 1 And NoTixAct3 >= 1 And NoTixAct6 >= 1 Then
    'Adult Actor Series, get all tickets for this subscription and apply discount
    SQLDiscountPackage = "SELECT OrderLine.Price, OrderLine.LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & CleanNumeric(OrderNumber) & " AND ActCode IN(26599,26602,26633) AND Seat.EventCode = " & Clean(Request("EventCode"))
    Set rsDiscountPackage = OBJdbConnection.Execute(SQLDiscountPackage)
    If Not rsDiscountPackage.EOF Then
        If SeatTypeCode = "1" Then        
            NewPrice = 9.5
        ElseIf SeatTypeCode = "23" Or SeatTypeCode = "1555" Then
            NewPrice = 7.75
        Else
            NewPrice = 9.5
        End If
        If Price > NewPrice Then
	        DiscountAmount = Price - NewPrice
	        AppliedFlag = "Y"
        End If
    End If
End If
	
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>