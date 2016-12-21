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

'Per Ticket Discount
'Amount Discount
'By Section Color - 2 Tier

'========================================================

DIM SectionColor(1)
SectionColor(0) = "DARKBLUE"
SectionColor(1) = "DARKGREEN"

DIM AmountDiscount(1)
AmountDiscount(0) = 8
AmountDiscount(1) = 5

DIM DiscountAmount
DiscountAmount = 0

'========================================================

If AllowDiscount = "Y" Then 'It's okay to apply to this order.
		
      'Determine the section color of the ticket 
      SQLColor = "SELECT Color FROM Section(NOLOCK) WHERE EventCode = " & EventCode & " AND SectionCode = '" & SectionCode & "' "
      Set rsColor = OBJdbConnection.Execute(SQLColor)
            Color = UCase(rsColor("Color"))
      rsColor.Close
      Set rsColor = nothing
      
      'Determine the discount amount    	        
      Select Case Color
            Case SectionColor(0)
               DiscountAmount = AmountDiscount(0) 
            Case SectionColor(1)
               DiscountAmount = AmountDiscount(1)
      End Select
      
      If DiscountAmount > 0 Then 
      
            NewPrice = Clean(Request("Price")) -  DiscountAmount
            
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