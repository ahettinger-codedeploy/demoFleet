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
CombinedPrice = 20

SQLAct1Count = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.SeatTypeCode = 2980 AND OrderLine.OrderNumber = " & CleanNumeric(OrderNumber) & " AND EventCode = 167879"
Set rsAct1Count = OBJdbConnection.Execute(SQLAct1Count)
NoTixAct1 = rsAct1Count("LineCount")
rsAct1Count.Close
Set rsAct1Count = nothing

'at least 3 tickets on order, make total to be $20 total
If NoTixAct1 >= 3 Then
    SQLDiscountPackage = "SELECT OrderLine.LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & CleanNumeric(OrderNumber) & " AND EventCode = 167879"
    Set rsDiscountPackage = OBJdbConnection.Execute(SQLDiscountPackage)
    Do While Not rsDiscountPackage.EOF
        If CInt(rsDiscountPackage("LineNumber")) = CInt(Request("LineNumber")) Then
            'NewPrice = FormatNumber(20/NoTixAct1,6)
            NewPrice = Round(CombinedPrice/NoTixAct1, 2)
        End If
        If Price > NewPrice Then
	        DiscountAmount = Price - NewPrice
	        AppliedFlag = "Y"
        End If
        rsDiscountPackage.movenext
    Loop
End If
	
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>