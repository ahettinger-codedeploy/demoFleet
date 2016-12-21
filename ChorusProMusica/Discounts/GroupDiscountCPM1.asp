<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->

<%

'Initialize Variables
NewPrice = Clean(Request("Price"))
DiscountAmount = 0
Surcharge = Clean(Request("Surcharge"))
AppliedFlag = "N"
SeatTypeCode = Clean(Request("SeatTypeCode"))
AllowedSeatTypeCode = Clean(Request("AllowedSeatTypeCode"))
'REE 10/15/5 - Added NewSurcharge
NewSurcharge = CDbl(Clean(Request("NewSurcharge")))
Price = Clean(Request("Price"))

'SSR 10/27/5 Include only these prices for the discount
If Price = "45" Or Price = "35" Or Price = "25" Then  

'SSR 3/23/5 - Added Offline/Online Order Type Check
OrderTypeFlag = "Y"
If Clean(Request("OfflineOnly")) = "Y" And Clean(Request("OrderTypeNumber")) = 1 Then
	OrderTypeFlag = "N"
End If
If Clean(Request("OnlineOnly")) = "Y" And Clean(Request("OrderTypeNumber")) <> 1 Then
	OrderTypeFlag = "N"
End If

SQLSTC = ""
'JAI 5/24/5 - Added check for Seat Type
AllowedSeatTypeFlag = "Y"
If AllowedSeatTypeCode <> "" Then
	If SeatTypeCode <> AllowedSeatTypeCode Then
			AllowedSeatTypeFlag = "N"
	Else
		SQLSTC = " AND SeatTypeCode = " & AllowedSeatTypeCode
	End If
End If

If OrderTypeFlag = "Y" And AllowedSeatTypeFlag = "Y" Then 'It's okay to apply to this order type and seat type.

	SQLEventCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Clean(Request("OrderNumber")) & " AND Seat.EventCode = " & Clean(Request("EventCode")) & SQLSTC
	Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)

	If Not rsEventCount.EOF Then
		If rsEventCount("SeatCount") >= CInt(Clean(Request("Qty"))) Then 'Apply the discount
			'REE 8/12/4 - Added abilty to pass dollar off and percentage off
			If Clean(Request("Percentage")) <> "" Then
				NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Clean(Request("Percentage")))/100), 2)
			ElseIf Clean(Request("FixedPrice")) <> "" Then
				NewPrice = CDbl(Clean(Request("FixedPrice")))
			Else
				NewPrice = CDbl(Clean(Request("Price"))) - CDbl(Clean(Request("DiscountAmount")))
			End If			
			DiscountAmount = Clean(Request("Price")) - NewPrice

			'REE 10/15/5 - Added NewSurcharge
			If Request("NewSurcharge") <> "" Then
				Surcharge = NewSurcharge
			Else
				If Request("CalcServiceFee") <> "N" Then
					'JAI - 2/9/5 - Added ItemType to CalcCustomerFee
					Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
				End If
			End If

			AppliedFlag = "Y"
		End If
	End If
					
	rsEventCount.Close
	Set rsEventCount = nothing

End If

End If

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>