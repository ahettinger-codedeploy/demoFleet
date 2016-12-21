<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->

<%

'Initialize Variables
NewPrice = Clean(Request("Price"))
DiscountAmount = 0
Surcharge = Clean(Request("Surcharge"))
AppliedFlag = "N"

'REE 8/10/4 - Added Offline/Online Order Type Check
OrderTypeFlag = "Y"
If Clean(Request("OfflineOnly")) = "Y" And Clean(Request("OrderTypeNumber")) = 1 Then
	OrderTypeFlag = "N"
End If

If Clean(Request("OnlineOnly")) = "Y" And Clean(Request("OrderTypeNumber")) <> 1 Then
	OrderTypeFlag = "N"
End If
	
If OrderTypeFlag = "Y" Then 'It's okay to apply to this order type.

	If Clean(Request("SeatTypeCode")) = 3 OR Clean(Request("SeatTypeCode")) = 53 Then

		'REE 8/6/4 - Added Expiration Date Functionality
		If Clean(Request("ExpirationDate")) <> "" Then 'The discount has an expiration date
			ExpirationDate = CDate(Clean(Request("ExpirationDate")))
		Else 'There is no expiration.  Add one to the current date so that it does not expire.
			ExpirationDate = DateAdd("d", 1, Now())
		End If

		If Now() < ExpirationDate Then

			If Clean(Request("Price")) > 0 Then
				NewPrice = Clean(Request("FixedPrice"))
				AppliedFlag = "Y"
			End If
			If NewPrice < 0 Then
				NewPrice = 0
			End If

			DiscountAmount = Clean(Request("Price")) - NewPrice

			If Request("CalcServiceFee") <> "N" Then
				'JAI - 2/9/5 - Added ItemType to CalcCustomerFee
				Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, Clean(Request("EventCode")), Clean(Request("ItemType")))
			End If

		End If
		
	End If

End If

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>