<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<%

'Initialize Variables
Price = Clean(Request("Price"))
NewPrice = Price
DiscountAmount = 0
Surcharge = Clean(Request("Surcharge"))
AppliedFlag = "N"
OrderNumber = Clean(Request("OrderNumber"))
SeatTypeCode = Clean(Request("SeatTypeCode"))
SectionCode = Clean(Request("SectionCode"))

SQLEventCount = "SELECT Seat.EventCode, COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE (OrderLine.OrderNumber = " & OrderNumber & ") AND (Seat.EventCode IN (12920,12921,12922,12923,12924,12925)) GROUP BY Seat.EventCode ORDER BY COUNT(Seat.EventCode) DESC"
Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)
If Not rsEventCount.EOF Then
	rsEventCount.Move(3)
	If Not rsEventCount.EOF Then
		If rsEventCount("SeatCount") >= 1 Then
			NewPrice = round(Price * .90, 2)
			DiscountAmount = Price - NewPrice
			AppliedFlag = "Y"
		End If
	End If
End If
rsEventCount.Close
Set rsEventCount = nothing
	
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>