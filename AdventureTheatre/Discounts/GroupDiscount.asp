<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->

<%
' GROUP DISCOUNT BY TIER - 4 discount levelS
' Adventure Theater - 2/7/08 - SSR

'Initialize Variables
Price = Clean(Request("Price"))
NewPrice = Price
DiscountAmount = 0
Surcharge = Clean(Request("Surcharge"))
If Request("NewSurcharge") <> "" Then
    NewSurcharge = CDbl(Clean(Request("NewSurcharge")))
End If
AppliedFlag = "N"
EventCode = Clean(Request("EventCode"))


'SSR 7/10/8 - Added Offline/Online Order Type Check
OrderTypeFlag = "Y"
If Clean(Request("OfflineOnly")) = "Y" And Clean(Request("OrderTypeNumber")) = 1 Then
	OrderTypeFlag = "N"
End If
If Clean(Request("OnlineOnly")) = "Y" And Clean(Request("OrderTypeNumber")) <> 1 Then
	OrderTypeFlag = "N"
End If

'REE 11/29/6 - Added MaxDiscountsPerEventOK to criteria
If OrderTypeFlag = "Y" Then 'It's okay to apply to this order type and seat type.

	'REE 11/16/4 - Added NewSurcharge
	NewSurcharge = CDbl(Clean(Request("NewSurcharge")))

'Count number of tickets on order	
SQLEventCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Clean(Request("OrderNumber")) & " AND Seat.EventCode = " & EventCode
Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)

If Not rsEventCount.EOF Then
            'REE 3/14/8 - Added criteria to apply new price only when existing price is higher.
			If rsEventCount("SeatCount") >= 10 And rsEventCount("SeatCount") <= 19 And Price > 11 Then 
				NewPrice = 11
				ElseIf rsEventCount("SeatCount") >= 20 And rsEventCount("SeatCount") <= 49 And Price > 10 Then 
					NewPrice = 10
				ElseIf rsEventCount("SeatCount") >= 50 And rsEventCount("SeatCount") <= 99 And Price > 9 Then				
					NewPrice = 9
				ElseIf rsEventCount("SeatCount") >= 100 And Price > 8 Then 
					NewPrice = 8
				Else 'No change in price
					NewPrice = Price
			End If


'Apply Discount
DiscountAmount = Clean(Request("Price")) - NewPrice
			
If DiscountAmount <> 0 Then
	AppliedFlag = "Y"
    ' Determine Surcharge
    If NewSurcharge <> "" Then
	    Surcharge = NewSurcharge
    Else
	    If Request("CalcServiceFee") <> "N" Then
		    Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, Clean(Request("EventCode")), Clean(Request("ItemType")))
	    End If
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