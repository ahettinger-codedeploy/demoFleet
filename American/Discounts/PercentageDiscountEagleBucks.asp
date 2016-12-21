<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->

<%

'Initialize Variables
NewPrice = CDbl(Clean(Request("Price")))
DiscountAmount = 0
Surcharge = CDbl(Clean(Request("Surcharge")))
AppliedFlag = "N"
'REE 10/26/4 - Added NewSurcharge
NewSurcharge = CDbl(Clean(Request("NewSurcharge")))
SeatTypeCode = CInt(Clean(Request("SeatTypeCode")))

If SeatTypeCode = 563 Then
				
	'REE 8/10/4 - Added Offline/Online Order Type Check
	OrderTypeFlag = "Y"
	If Clean(Request("OfflineOnly")) = "Y" And Clean(Request("OrderTypeNumber")) = 1 Then
		OrderTypeFlag = "N"
	End If
	If Clean(Request("OnlineOnly")) = "Y" And Clean(Request("OrderTypeNumber")) <> 1 Then
		OrderTypeFlag = "N"
	End If
		
	If OrderTypeFlag = "Y" Then 'It's okay to apply to this order type.
		'REE 8/6/4 - Added Expiration Date Functionality
		If Clean(Request("ExpirationDate")) <> "" Then 'The discount has an expiration date
			ExpirationDate = CDate(Clean(Request("ExpirationDate")))
		Else 'There is no expiration.  Add one to the current date so that it does not expire.
			ExpirationDate = DateAdd("d", 1, Now())
		End If

		If Now() < ExpirationDate Then

			NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Clean(Request("Percentage")))/100), 2)
			DiscountAmount = Clean(Request("Price")) - NewPrice
			
			'REE 10/26/4 - Added NewSurcharge
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

End If

	

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>