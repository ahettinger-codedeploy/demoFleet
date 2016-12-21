<%
'CHANGE LOG
'JAI 6/1/12 - New per ticket discount script.  Combination of Amount, Percentage, and Fixed Price discounts.
'SSR 11/5/2013 - Updated discount code. Added NewShipFee parameter
%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%
'Discount Definition - Required/Optional Parameters
'Required
'1) Percentage, DiscountAmount, or FixedPrice - To define the amount to discount
'Optional
'4) All fields in DiscountScriptInclude

'--------------------------------------------
'Additional Optional Parameter
'5) &NewShipFee=X  TIX2 only


'Initialize Variables
DIM NewShipFee


If AllowDiscount = "Y" Then 'It's okay to apply to this order.

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
	
		If Clean(Request("NewShipFee")) <> "" Then
		
			OrderNumber = Clean(Request("OrderNumber"))
			
			SQLOrderHeader = "SELECT OrderHeader.ShipFee, OrderHeader.Total FROM OrderHeader (NOLOCK)  WHERE OrderHeader.OrderNumber = " & OrderNumber & " "
			Set rsOrderHeader = OBJdbConnection.Execute(SQLOrderHeader)
			
				If Not rsOrderHeader.EOF Then  
				
					NewShipFee = Round(CDbl(CleanNumeric(Request("NewShipFee"))),2)
					
					ThisOrderTotal = Round(CDbl(Clean(rsOrderHeader("Total"))),2)
					
					NewOrderTotal = ThisOrderTotal - NewShipFee
									
					SQLUpdateShipFee = "UPDATE OrderHeader WITH (ROWLOCK) SET ShipFee = " & NewShipFee & ", OrderTotal =  " & NewOrderTotal & " WHERE OrderHeader.OrderNumber = " & OrderNumber & " "
					Set rsUpdateShipFee  = OBJdbConnection.Execute(SQLUpdateShipFee)
					
				End If
			rsOrderHeader.Close
			Set rsOrderHeader = Nothing  
			
		End If
			
	'If NewSurcharge <> "" Then
		'Surcharge = NewSurcharge
	'ElseIf Request("CalcServiceFee") <> "N" Then
		'Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
	'End If
	
	AppliedFlag = "Y"
	
End If	

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>