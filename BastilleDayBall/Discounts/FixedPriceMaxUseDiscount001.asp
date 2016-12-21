<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'Committee of French Speaking Societies (6/14/2010)
'===================================================
'Fixed Price Discount with max number of discounts per ticket type

'SeatCode   Seat Name
'(4449)     Bleu tickets - the first 100 @ $15.00 each
'(4450)     Blanc tickets - the first 50 tickets @ $75.00 each
'(4451)     Rouge tickets - the first 25 tickets @ 150 each


'Discount Variables
BleuSeatCode = 4449
BleuDiscountSystemUsage = 100
BleuPrice = 15

BlancSeatCode = 4450
BlancMax = 50
BlancPrice = 75

RougeSeatCode = 4451
RougeMax = 25
RougePrice = 150

If AllowDiscount = "Y" Then 'It's okay to apply to this order.

ErrorLog("Line 32")

    If Clean(Request("SeatTypeCode")) = BleuSeatCode Then    

    	    
            If Clean(Request("Price")) > 0 Then
                NewPrice = BleuPrice
                AppliedFlag = "Y"
            End If

            If NewPrice < 0 Then
                NewPrice = 0
            End If

            DiscountAmount = Round(Clean(Request("Price")),2) - NewPrice
            
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