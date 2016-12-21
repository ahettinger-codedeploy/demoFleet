<%

'CHANGE LOG - Inception
'SSR 8/10/2011
'Custom Discount Code

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'========================================================

'Midland Community Tennis Center (3407)

'Seat Code  Seat Type   Discount
'----------------------------------
'4901       Club Seat   $3.00 Off
'4902       Adult GA    $2.00 Off
'4903       Junior GA   $2.00 Off 

'Online and offline

'Do not recalc fees

'Discount code entry required

'Replace existing “MHS” (DiscountTypeNumber 63213) discount code with this custom version

'========================================================

If AllowDiscount = "Y" Then 'It's okay to apply to this order.

    If Clean(Request("Price")) > 0 Then
	
        Select Case SeatTypeCode
	        Case 4901 'Adult
		        DiscountAmount = 3
	        Case 4902 'Senior
		        DiscountAmount = 2
	        Case 4902 'Student
		        DiscountAmount = 2
        End Select		
        		
        NewPrice = Clean(Request("Price")) -  DiscountAmount

        If NewPrice < 0 Then
	        NewPrice = 0
        End If

        DiscountAmount = Clean(Request("Price")) - NewPrice
        
        AppliedFlag = "Y"

        If Request("NewSurcharge") <> "" Then
	        Surcharge = NewSurcharge
        Else
	        If Request("CalcServiceFee") <> "N" Then
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