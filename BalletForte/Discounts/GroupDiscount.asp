<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->

<%
' GROUP DISCOUNT - This discount counts the number of tickets on each order and gives a discount amount based on the total number of tickets. -- SSR


'Initialize Variables
Price = Clean(Request("Price"))
NewPrice = Price
DiscountAmount = 0
Surcharge = Clean(Request("Surcharge"))
AppliedFlag = "N"
NewSurcharge = CDbl(Clean(Request("NewSurcharge")))
EventCode = Clean(Request("EventCode"))

'Count number of tickets on order	
SQLEventCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Clean(Request("OrderNumber")) & " AND Seat.EventCode = " & EventCode
Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)
		
If Not rsEventCount.EOF Then

			If rsEventCount("SeatCount") >= 15 And rsEventCount("SeatCount") <= 24 Then 
				NewPrice = round(CDbl(Clean(Request("Price"))) * (90/100), 2) '10% Discount
				ElseIf rsEventCount("SeatCount") >= 25 And rsEventCount("SeatCount") <= 39 Then 
				NewPrice = round(CDbl(Clean(Request("Price"))) * (85/100), 2) '15% Discount
				ElseIf rsEventCount("SeatCount") >= 40 Then 
				NewPrice = round(CDbl(Clean(Request("Price"))) * (75/100), 2) '25% Discount
				Else 'No change in price
					NewPrice = Price
			End If


'Apply Discount
DiscountAmount = Clean(Request("Price"))- NewPrice
			
If DiscountAmount <> 0 Then
		AppliedFlag = "Y"
End If

' Determine Surcharge
If Request("NewSurcharge") <> "" Then
	Surcharge = NewSurcharge
Else

	If Request("CalcServiceFee") <> "N" Then
		Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, Clean(Request("EventCode")), Clean(Request("ItemType")))
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