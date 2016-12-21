<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->

<%

'Initialize Variables
NewPrice = Clean(Request("Price"))
Price = Clean(Request("Price"))
DiscountAmount = 0
Surcharge = Clean(Request("Surcharge"))
AppliedFlag = "N"
SeatTypeCode = CInt(Clean(Request("SeatTypeCode")))

SQLEventCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Clean(Request("OrderNumber")) & " AND Seat.EventCode = " & Clean(Request("EventCode"))
Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)

If Not rsEventCount.EOF Then
	If rsEventCount("SeatCount") >= CInt(Clean(Request("Qty"))) Then 'Apply the discount
			Select Case SeatTypeCode 
						Case 1 'Adult
									NewPrice = CDbl(Clean(Request("Price"))) - 3
						Case 3 'Senior
									NewPrice = CDbl(Clean(Request("Price"))) - 6
						Case 6 'Student
									NewPrice = CDbl(Clean(Request("Price"))) - 2
						Case 436 'Child
									NewPrice = CDbl(Clean(Request("Price"))) 
			End Select
	 End If

		DiscountAmount = CDbl(Clean(Request("Price"))) - NewPrice
		
		'REE 9/3/4 - Added CalcServiceFee parameter
		If Request("CalcServiceFee") <> "N" Then
			'JAI - 2/9/5 - Added ItemType to CalcCustomerFee
			Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, Clean(Request("EventCode")), Clean(Request("ItemType")))
		End If
		AppliedFlag = "Y"
End If

				
rsEventCount.Close
Set rsEventCount = nothing

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>