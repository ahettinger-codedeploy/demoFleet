<%

'CHANGE LOG - Inception
'SSR 11/1/2012 Created Custom Discount Code

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'========================================================

'Chamber Opera Chicago

'2 Tier New Price Discount by Seat Type Code

'Client would like a custom two-tiered amount discount:
'$15 price for adults (regularly $25)
'$8 price for children (regularly $10)
'Discount Code = CAST
'Attach to EventCodes 492796, 492797.
'Discount code entry required.
'Contact
'Kerri Burkhardt
'chamberopera@aol.com

'========================================================
		
			 Select Case SeatTypeCode
				Case 1
					FixedPrice = 15
				Case 5
					FixedPrice = 8
				Case Else
					FixedPrice = Price
			End Select
		
			If Price > FixedPrice Then
		
				If Clean(Request("Price")) > 0 Then
					NewPrice = FixedPrice
				End If

				If NewPrice < 0 Then
					NewPrice = 0
				End If

				DiscountAmount = Price - NewPrice
				AppliedFlag = "Y"

				If Request("NewSurcharge") <> "" Then
				Surcharge = NewSurcharge
				Else
				If Request("CalcServiceFee") <> "N" Then
					Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, Clean(Request("EventCode")), Clean(Request("ItemType")))
				End If
				End If

			End If
		

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>