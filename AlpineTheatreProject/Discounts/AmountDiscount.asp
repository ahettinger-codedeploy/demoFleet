<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->

<%

'Alpine Theatre Project
'For the first 6 performances of The World Goes 'Round tickets are $18.50 each. 50% discount per ticket
'For the next 5 performances of The World Goes 'Round tickets are $25.00 each.
'Discount is only valid for Adult tickets
'Discount is only valid for seats in Front section (Rows A to F)
'8/10/09 Updated discount code. Was given wrong eventcode. Changed 101104 to 191104

'Initialize Variables
Price = Clean(Request("Price"))
NewPrice = Clean(Request("Price"))
DiscountAmount = 0
EventCode = Clean(Request("EventCode"))
SeatTypeCode = Clean(Request("SeatTypeCode"))
Surcharge = Clean(Request("Surcharge"))
AppliedFlag = "N"
SectionCode = Clean(Request("SectionCode"))

If SectionCode = "FRONT" Then

		Select Case SeatTypeCode
			Case 1
						Select Case EventCode
							Case 191090, 191102, 191103, 191104, 191105, 191106
							NewPrice = 18.50
							Case 191107, 191108, 191109, 191110, 191111
							NewPrice = 25.00
						End Select
		End Select
	
		DiscountAmount = Price -  NewPrice
		AppliedFlag = "Y"

End If



Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>