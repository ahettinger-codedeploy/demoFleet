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

'Apply the discount to this ticket type only
If SeatTypeCode = 16 Then


SQLEventCount = "SELECT Event.ActCode, COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE (OrderLine.OrderNumber = " & OrderNumber & ") AND (Event.ActCode IN (24326,24325,24324,24323,24322,24321)) GROUP BY Event.ActCode ORDER BY COUNT(Event.ActCode) DESC"
Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)
If Not rsEventCount.EOF Then
	rsEventCount.Move(2) 'Read ahead 2 records.  Check to see if 3 different Acts are on order.
	If Not rsEventCount.EOF Then
		If rsEventCount("SeatCount") >= 1 Then
			NewPrice = 37.5
			DiscountAmount = Price - NewPrice
			AppliedFlag = "Y"
		End If
	End If
End If
If Not rsEventCount.EOF Then
	rsEventCount.Move(1) 'Read ahead 1 records.  Check to see if 4 different Acts are on order.
	If Not rsEventCount.EOF Then
		If rsEventCount("SeatCount") >= 1 Then
			NewPrice = 37.5
			DiscountAmount = Price - NewPrice
			AppliedFlag = "Y"
		End If
	End If
End If
If Not rsEventCount.EOF Then
	rsEventCount.Move(2) 'Read ahead 2 records.  Check to see if 5 Acts are on order.
	If Not rsEventCount.EOF Then
		If rsEventCount("SeatCount") >= 1 Then
			NewPrice = 37.5
			DiscountAmount = Price - NewPrice
			AppliedFlag = "Y"
		End If
	End If
End If



rsEventCount.Close
Set rsEventCount = nothing
	
End If	
	
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>