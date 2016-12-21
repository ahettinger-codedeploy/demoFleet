<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->

<%

'This discount code will give an amount discount based on ticket type.
'Example: Adult $5 off, Senior $3 off, Child $2 off
'Seat Type Code not listed will get $0 off

'Initialize Variables
NewPrice = Clean(Request("Price"))
DiscountAmount = 0
Surcharge = Clean(Request("Surcharge"))
SeatTypeCode = Clean(Request("SeatTypeCode"))
AppliedFlag = "N"


	If Now() > StartDate And Now() < ExpirationDate Then

		If Clean(Request("Price")) > 0 Then

	
					Select Case SeatTypeCode
						Case 1 'Adult
							FixedPrice = 10
						Case 417 'Child
							FixedPrice = 5
	                End Select

		
			NewPrice = Clean(Request("Price")) -  DiscountAmount
			AppliedFlag = "Y"
	End If
	
		If NewPrice < 0 Then
			NewPrice = 0
		End If

		DiscountAmount = Clean(Request("Price")) - NewPrice
		

			'REE 11/16/4 - Added NewSurcharge
			If Request("NewSurcharge") <> "" Then
				Surcharge = NewSurcharge
			Else
				If Request("CalcServiceFee") <> "N" Then
					'JAI - 2/9/5 - Added ItemType to CalcCustomerFee
					Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
				End If
			End If

	End If

End If

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>