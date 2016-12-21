<%

'CHANGE LOG - Inception
'SSR 4/20/2011
'Discount Created 

%>

<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'==================================================

'Fort Lewis College (260) (TIX) 

'Percentage Off With Max Discount Per Order

'Discount will discount each ticket at the stated percentage

'Total amount of discount on the order will max out at the stated cap

'==================================================

RequiredSeatTypeCode = 16

Percentage = 10

MaxTickets = 3

'==================================================


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