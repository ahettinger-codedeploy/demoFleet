<%
'CHANGE LOG
'JAI 6/1/12 - New per ticket discount script.  Combination of Amount, Percentage, and Fixed Price discounts.
'SSR 11/5/2013 - Updated existing discount. Added NewShipFee parameter for TIX2, could have hard coded but maybe possible re-use?
				'Example: NewShipFee=X  TIX2 only
'SSR 03/20/2015 - Finally got to reuse this for City of Santa Clarita! Perhaps we should upload this for generic use?

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%
'Initialize Variables
DIM NewShipFee

'--------------------------------------------


If AllowDiscount = "Y" Then 'It's okay to apply to this order.

	If Clean(Request("NewShipFee")) <> "" Then
		OrderNumber = Clean(Request("OrderNumber"))
		NewShipFee = Round(CDbl(CleanNumeric(Request("NewShipFee"))),2)
		SQLUpdateShipFee = "UPDATE OrderHeader SET ShipFee = " & NewShipFee & " WHERE OrderHeader.OrderNumber = " & OrderNumber & " "
		Set rsUpdateShipFee  = OBJdbConnection.Execute(SQLUpdateShipFee)							
	End If

	If Clean(Request("Percentage")) <> "" Then
		NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Clean(Request("Percentage")))/100), 2)
	ElseIf Clean(Request("FixedPrice")) <> "" Then
		NewPrice = Round(CDbl(Clean(Request("FixedPrice"))),2)
	Else
		NewPrice = Round(CDbl(Clean(Request("Price"))),2) - Round(CDbl(Clean(Request("DiscountAmount"))),2)
	End If			
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