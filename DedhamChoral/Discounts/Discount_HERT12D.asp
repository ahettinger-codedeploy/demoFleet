<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'========================================================
'Dedham Choral Society (3/5/2012)
'FixedPrice Discount - 6 Tier by Ticket Type

'Custom Discount
'For Eventcode 451494 - Classic to Romantic 

'Ticket Type         Code 
'--------------------------   
'Balcony $45        (3110)  
'Balcony $35        (3111) 
'Balcony $20        (3112) 

'Floor/ Circle $45  (3107)   
'Floor/ Circle $35  (3108)  
'Floor/ Circle $20  (3109) 


'Floor/ Circle, Balcony $45 discount to -$38; 
'Floor/ Circle, Balcony $35 discount to -$30; 
'Floor/ Circle, Balcony $20 discount to -$17 


'========================================================

'Discount Variables

'Tier 1
TicketType1 = "3110"
TicketPrice1 = "38"

'Tier 2
TicketType2 = "3111"
TicketPrice2 = "30"

'Tier 3
TicketType3 = "3112"
TicketPrice3 = "17"

'Tier 4
TicketType4 = "3107"
TicketPrice4 = "38"

'Tier 5
TicketType5 = "3108"
TicketPrice5 = "30"

'Tier 6
TicketType6 = "3109"
TicketPrice6 = "17"

'========================================================

If AllowDiscount = "Y" Then 'It's okay to apply to this order.
        
        Select Case SeatTypeCode
	        Case TicketType1
		        FixedPrice = TicketPrice1
	        Case TicketType2
		        FixedPrice = TicketPrice2
            Case TicketType3
		        FixedPrice = TicketPrice3
	        Case TicketType4
		        FixedPrice = TicketPrice4
             Case TicketType5
		        FixedPrice = TicketPrice5
	        Case TicketType6
		        FixedPrice = TicketPrice6
		    Case Else
		        FixedPrice = NewPrice
        End Select
		
		If Clean(Request("Price")) > 0 Then
			NewPrice = FixedPrice
			AppliedFlag = "Y"
		End If
		
		If NewPrice < 0 Then
			NewPrice = 0
		End If

		DiscountAmount = Price - NewPrice

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