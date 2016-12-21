<%

'CHANGE LOG
'JAI 6/1/12 - New per ticket discount script.  Combination of Amount, Percentage, and Fixed Price discounts.

%>

<!--#INCLUDE virtual="PrivateLabelInclude.asp"-->
<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="NoCacheInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'--------------------------------------------------------

		ErrorLog("discount start")
		
		ErrorLog("CampaignNumber: " & CampaignNumber & "")
		ErrorLog("UserNumber: " & UserNumber & "")
		ErrorLog("CustomerNumber: " & CustomerNumber & "")
		ErrorLog("OrganizationNumber: " & OrganizationNumber & "")
		ErrorLog("OrderNumber : " & OrderNumber  & "")
	
		If AllowDiscount = "Y" Then

			NewPrice = Round(CDbl(Clean(Request("Price"))),2) - 1
		
			If NewPrice < 0 Then
				NewPrice = 0
			End If
		
			DiscountAmount = Round(Clean(Request("Price")),2) - NewPrice

			If NewSurcharge <> "" Then
				Surcharge = NewSurcharge
			ElseIf Request("CalcServiceFee") <> "N" Then
				Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
			End If
		
			AppliedFlag = "Y"
									

		End If
		
	
	Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
	Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
	Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
	Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf



%>