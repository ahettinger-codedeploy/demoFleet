<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->

<%
' GROUP DISCOUNT BY TIER - 4 discount levelS
' Atlas Theater/Adventure Theater for Goodnight Moon - 4/7/08 - SSR

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

'Count number of tickets on order	
SQLEventCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Clean(Request("OrderNumber")) & " AND Seat.EventCode = " & EventCode
Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)

If Not rsEventCount.EOF Then
			If rsEventCount("SeatCount") >= 10 And rsEventCount("SeatCount") <= 19 Then 
				NewPrice = round(CDbl(Clean(Request("Price"))) * (90/100), 2)
				ElseIf rsEventCount("SeatCount") >= 20 And rsEventCount("SeatCount") <= 49 Then 
					NewPrice = round(CDbl(Clean(Request("Price"))) * (85/100), 2)
				ElseIf rsEventCount("SeatCount") >= 50 And rsEventCount("SeatCount") <= 99 Then				
					NewPrice = round(CDbl(Clean(Request("Price"))) * (80/100), 2)
				ElseIf rsEventCount("SeatCount") >= 100 Then 
					NewPrice = round(CDbl(Clean(Request("Price"))) * (75/100), 2)
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

		
rsEventCount.Close
Set rsEventCount = nothing

End If

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>