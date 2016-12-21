<%

'CHANGE LOG
'JAI 06/01/12 - New per ticket discount script.  Combination of Amount, Percentage, and Fixed Price discounts.
'SSR 04/03/15 - Extended "Per Ticket Discount" script extended to allow discounts on the per ticket service fee.


%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'=========================================================


'=========================================================

	If AllowDiscount = "Y" Then 'It's okay to apply to this order.
	
		SQLEventCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'SubFixedEvent' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = 709169"
		Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)
			ErrorLog("LineCount " & rsEventCount("LineCount") & "")
			If rsEventCount("LineCount") >= 1 Then
				Call ProcessDiscount
			End If
		rsEventCount.Close
		Set rsEventCount = nothing
	
	End If	

	Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
	Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
	Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
	Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

'---------------------------------------------

	Sub ProcessDiscount

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
		
		Call ProcessSurcharge
		
		AppliedFlag = "Y"
		
	End Sub

'---------------------------------------------

	Sub ProcessSurcharge
	
		If AppliedFlag = "Y" Then

			If NewSurcharge <> "" Then
				Surcharge = NewSurcharge
			ElseIf Request("CalcServiceFee") <> "N" Then
				Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
			End If
			
		End If
			
	End Sub

'---------------------------------------------

%>