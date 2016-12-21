<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

If AllowDiscount = "Y" Then
	SQLEventCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Clean(Request("OrderNumber")) & " AND Seat.EventCode = " & Clean(Request("EventCode"))
	Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)

	If Not rsEventCount.EOF Then
		If rsEventCount("SeatCount") >= CInt(Clean(Request("Qty"))) Then 'Apply the discount
			'REE 8/12/4 - Added abilty to pass dollar off and percentage off
			If Clean(Request("Percentage")) <> "" Then
				NewPrice = round(CDbl(Price) * (1-CDbl(Clean(Request("Percentage")))/100), 2)
			ElseIf Clean(Request("FixedPrice")) <> "" Then
				NewPrice = CDbl(Clean(Request("FixedPrice")))
			Else
				NewPrice = CDbl(Price) - CDbl(Clean(Request("DiscountAmount")))
			End If			
			DiscountAmount = Clean(Request("Price")) - NewPrice

			'REE 10/15/5 - Added NewSurcharge
			If NewSurcharge <> "" Then
				Surcharge = NewSurcharge
			Else
				If Request("CalcServiceFee") <> "N" Then
					'JAI - 2/9/5 - Added ItemType to CalcCustomerFee
					Surcharge = CalcCustomerFee(OrganizationNumber, OrderTypeNumber, NewPrice, EventCode, Clean(Request("ItemType")))
				End If
			End If

			AppliedFlag = "Y"
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