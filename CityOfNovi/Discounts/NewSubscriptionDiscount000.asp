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

'Get all ActCode in the shopping cart
SQLActCode = "SELECT Event.ActCode FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " GROUP BY Event.ActCode ORDER BY Event.ActCode"
Set rsActCode = OBJdbConnection.Execute(SQLActCode)
Do While Not rsActCode.EOF
    ActCodeList = ActCodeList & rsActCode("ActCode") & ","
    rsActCode.movenext
Loop
rsActCode.Close
Set rsActCode = nothing

If ActCodeList <> "" Then
    ActCodeList = Left(ActCodeList,len(ActCodeList)-1)    
End If

'Check for the right type of subscriptions
If ActCodeList = "26599,26600,26602,26631,26632,26633" Then 'Full Season Pass
    If SeatTypeCode = "23" Or SeatTypeCode = "1555" Then 'Child/Senior
        NewPrice = 6.125
    Else 'Adult Tickets
        NewPrice = 7.75
    End If
    If Price > NewPrice Then
	    DiscountAmount = Price - NewPrice
	    AppliedFlag = "Y"
    End If
ElseIf ActCodeList = "26600,26631,26632" Then 'Young Actor Series
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
ElseIf ActCodeList = "26599,26602,26633" Then 'Adult Actor Series
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
	
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>