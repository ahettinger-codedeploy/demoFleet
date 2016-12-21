<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->

<%

'Initialize Variables
NewPrice = Clean(Request("Price"))
DiscountAmount = 0
Surcharge = Clean(Request("Surcharge"))
AppliedFlag = "N"


'REE 8/6/4 - Added Expiration Date Functionality
If Clean(Request("ExpirationDate")) <> "" Then 'The discount has an expiration date
	ExpirationDate = CDate(Clean(Request("ExpirationDate")))
Else 'There is no expiration.  Add one to the current date so that it does not expire.
	ExpirationDate = DateAdd("d", 1, Now())
End If

'REE 8/21/4 - Added Start Date Functionality
If Clean(Request("StartDate")) <> "" Then 'The discount has a start date
	StartDate = CDate(Clean(Request("StartDate")))
Else 'There is no start date.  Subtract one from the current date so that it's valid.
	StartDate = DateAdd("d", -1, Now())
End If

If Now() > StartDate And Now() < ExpirationDate Then

	If Clean(Request("Price")) > 0 Then
		NewPrice = Clean(Request("Price")) - Clean(Request("DiscountAmount"))
		AppliedFlag = "Y"
	End If
	If NewPrice < 0 Then
		NewPrice = 0
	End If

	DiscountAmount = Clean(Request("Price")) - NewPrice

	If Request("CalcServiceFee") <> "N" Then
		'JAI - 2/9/5 - Added ItemType to CalcCustomerFee
		Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, Clean(Request("EventCode")), Clean(Request("ItemType")))
	End If

End If

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>