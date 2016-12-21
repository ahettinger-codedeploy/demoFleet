<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->

<%

'Initialize Variables
NewPrice = Clean(Request("Price"))
Price = Clean(Request("Price"))
DiscountAmount = 0
Surcharge = Clean(Request("Surcharge"))
NewSurcharge = CDbl(Clean(Request("NewSurcharge")))
AppliedFlag = "N"
FixedPrice = Clean(Request("FixedPrice"))

SQLEventCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Clean(Request("OrderNumber")) & " AND Seat.EventCode = " & Clean(Request("EventCode"))
Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)

If Not rsEventCount.EOF Then
	If rsEventCount("SeatCount") >= CInt(Clean(Request("Qty"))) Then 'Apply the discount
	
			If Price = 45 Then
						DiscountAmount = 5
					End If	
					
			If Price = 35 Then
						DiscountAmount = 4
					End If	
					
			If Price = 25 Then
						DiscountAmount = 3
					End If
	
		NewPrice = Clean(Request("Price")) - DiscountAmount
		
		'REE 9/3/4 - Added CalcServiceFee parameter
		'REE 7/12/5 - Added NewSurcharge
		If Request("NewSurcharge") <> "" Then
			Surcharge = NewSurcharge
		Else
			If Request("CalcServiceFee") <> "N" Then
				'JAI - 2/9/5 - Added ItemType to CalcCustomerFee
				Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, Clean(Request("EventCode")), Clean(Request("ItemType")))
			End If
		End If
		AppliedFlag = "Y"
	End If
End If
				
rsEventCount.Close
Set rsEventCount = nothing

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>