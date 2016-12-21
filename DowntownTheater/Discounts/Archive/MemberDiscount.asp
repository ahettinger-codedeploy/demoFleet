<%

'Basic Discount

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->


<%

'========================================================
FixedPrice = 12
'========================================================

If AllowDiscount = "Y" Then 
        		
		If Clean(Request("Price")) > 0 Then
			NewPrice = FixedPrice
			AppliedFlag = "Y"
		End If
		
		If NewPrice < 0 Then
			NewPrice = 0
		End If

		DiscountAmount = Price - NewPrice

End If

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf



%>
