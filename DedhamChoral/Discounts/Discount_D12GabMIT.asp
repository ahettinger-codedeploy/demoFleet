<%

'CHANGE LOG - Inception
'SSR 10/18/2012 Custom Discount Code

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'========================================================

'Dedham Choral Society 

'AmountDiscount 2 Tier by SeatType - NewPrice

'Parameters
'Enter discount code “D12GabMIT” get:
'Adult Ticket @ $25.00 will be $22.00
'Senior Ticket @ $20.00 will be $18.00

'Eligible ActCodes / EventCodes: Event Code: 515381
'Offline/Online: Online and Offline
'Service Fees: Do not re-calculate service fees
'Additional Tickets:
'Automatic/Code Entry: Discount code entry required
'Expiration: No expiration
'Restrictions


'========================================================

If AllowDiscount = "Y" Then 'It's okay to apply to this order.

	If Clean(Request("Price")) > 0 Then

		'Fixed Amount Discount by Seat Type			
		Select Case SeatTypeCode
		Case 1 'Adult
			NewPrice = 22
		Case 3 'Senior
			NewPrice = 18
		End Select
	
		DiscountAmount = Clean(Request("Price")) -  NewPrice
		
		AppliedFlag = "Y"
		
	End If

End If

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>