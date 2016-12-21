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
ActCodeList = "42293,33138,33144,33148,33145,33142,41741,33146,41742,41743" 'ActCodes of Productions which can be included in Season Subscription.
TotalActs = 0

SQLActCode = "SELECT Event.ActCode, COUNT(Event.ActCode) AS Smallest FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.ActCode IN(" & ActCodeList & ") GROUP BY Event.ActCode ORDER BY COUNT(Event.ActCode)"
Set rsActCode = OBJdbConnection.Execute(SQLActCode)
If Not rsActCode.EOF Then
    Do While Not rsActCode.EOF
        TotalActs = TotalActs + 1
        rsActCode.movenext
    Loop
End If
rsActCode.Close
Set rsActCode = nothing

If CInt(TotalActs) >= 3 Then
    If SeatTypeCode = "1119" Then
        NewPrice = 7
    End If
End If

DiscountAmount = Price - NewPrice            
AppliedFlag = "Y"        
	
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>