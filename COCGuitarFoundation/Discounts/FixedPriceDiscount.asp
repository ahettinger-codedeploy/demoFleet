<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%
'Crown of the Continent Guitar Foundation (5/28/2010)
'Fixed Price discount based on ticket price.

'The ticket price of $67.50 will be discounted to $62.00
'The ticket price of $36.50 will be discounted to $32.50
'The ticket price of $25.00 will be discounted to $23.00
'The ticket price of $13.50 will be discounted to $12.00

'Prices not listed will get $0 off


If Clean(Request("Price")) > 0 Then
	
		Select Case Price
		    Case 67.50
			    NewPrice = 62.00
		    Case 36.50
			    NewPrice = 32.50
		    Case 25
			    NewPrice = 23.00
		    Case 13.50
			    NewPrice = 12.00
	   End Select
		

        AppliedFlag = "Y"


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

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>