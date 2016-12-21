<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->

<%

'Initialize Variables
NewPrice = Clean(Request("Price"))
DiscountAmount = 0
Surcharge = Clean(Request("Surcharge"))
AppliedFlag = "N"

Select Case Clean(Request("SeatTypeCode"))

	Case 312, 316, 320, 313, 317, 321 'Adult and Senior types for each meal
		NewPrice = NewPrice - Clean(Request("DiscountAmount"))
		DiscountAmount = Clean(Request("Price")) - NewPrice
		If Request("CalcServiceFee") <> "N" Then
			'JAI - 2/9/5 - Added ItemType to CalcCustomerFee
			Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, Clean(Request("EventCode")), Clean(Request("ItemType")))
		End If
		AppliedFlag = "Y"

End Select	

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>