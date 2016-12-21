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
'SQLEventCount = "SELECT Seat.EventCode, COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE (OrderLine.OrderNumber = " & OrderNumber & ") AND (Seat.EventCode IN (31100,32401,33420,33421,32723,34010,34011,34012,33746,33747,33748,33749,33750,33751,33752,33753,34809,36911,37243,36912,36913,40278,40206,40290,40285,40286,40205,40284,40288,40287,40283,40289,40277,40276,44532,40286,40821,44967,52090,55710,55888,57467,58649,58650,61324,61220,61445,61446,61449,61450,61487,61488,61491,61650,61652,61654,64927,65567,57467,74889,74893,74894,74895,74896,74897,74898,74914,74977,74979,75000,75001,75005,75024,75036,75063,80774,86003,96011,96014, 96355, 96391,96413,96424,97344,97608,97609,97909,107244,107245,107251,107350,107373,107374,107376,107377,107391,107397,107401,107409,107414,107416,107420,107428,120049,120052,120055,120056,120057,120178,120179,120188,120189,120324,120334,120346,120363,120381,124508,145884,145928,145954,147034,147044,147045,147046,147127,147138,147143,147165,147190)) GROUP BY Seat.EventCode ORDER BY COUNT(Seat.EventCode) DESC"
SQLEventCount = "SELECT Seat.EventCode, COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE (OrderLine.OrderNumber = " & OrderNumber & ") AND (Seat.EventCode IN (Select EventCode from DiscountEvents (nolock) where DiscountTypeNumber = 346)) GROUP BY Seat.EventCode ORDER BY COUNT(Seat.EventCode) DESC"
Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)
If Not rsEventCount.EOF Then
	rsEventCount.Move(3)
	If Not rsEventCount.EOF Then
		If rsEventCount("SeatCount") >= 1 Then
			NewPrice = round(Price * .85, 2)
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