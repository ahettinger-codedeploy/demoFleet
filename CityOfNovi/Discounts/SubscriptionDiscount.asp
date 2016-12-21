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
    'check if this order has any Child/Senior tickets
    SQLActCheck = "SELECT OrderLine.Price FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode IN(" & Clean(ActCodeList) & ") AND OrderLine.SeatTypeCode IN (23,1555)"
    Set rsActCheck = OBJdbConnection.Execute(SQLActCheck)
    If rsActCheck.EOF Then
        'all tickets on order are adults, apply discount
        If SeatTypeCode = "16" Then	
		    If Price = "15" Then
			    DiscountAmount = Price - 1
		    Else 
			    DiscountAmount = Price - 6
		    End If
        Else
            DiscountAmount = Price - 2
        End If
        
        NewPrice = DiscountAmount
        AppliedFlag = "Y"        
    End If

ElseIf ActCodeList = "26600,26631,26632" Then 'Young Actor Series
    If SeatTypeCode = "1" Then        
        DiscountAmount = Price - 1.17
    ElseIf SeatTypeCode = "23" Or SeatTypeCode = "1555" Then
        DiscountAmount = Price - 1.42
    Else
        DiscountAmount = Price - 1.16
    End If
    NewPrice = DiscountAmount
    AppliedFlag = "Y"
ElseIf ActCodeList = "26599,26602,26633" Then 'Adult Actor Series
    If SeatTypeCode = "1" Then        
        DiscountAmount = Price - 3.83
    ElseIf SeatTypeCode = "23" Or SeatTypeCode = "1555" Then
        DiscountAmount = Price - 3.33
    Else
        DiscountAmount = Price - 3.84
    End If
    NewPrice = DiscountAmount
    AppliedFlag = "Y"
'Else
'    NewPrice = Price
End If
	
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>