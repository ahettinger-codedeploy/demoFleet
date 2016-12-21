<%

'CHANGE LOG
'SSR 8/13/2012 - Created discount code.

%>

<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'===============================================================

'Atlanta Vocal Arts Society

'Per-ticket fee to be reduced by half after the first ticket in the order.

'For example: Client is passing $5.00 per ticket. 
'On a four ticket order the fees should be $5.00 for the first ticket 
'$2.50 fee for each subsequent ticket (half the per-ticket fee amount).

'Please let me know if you have any questions or concerns.
'Discount is automatic
'Applies to all ticket types
'Applies to event codes: 498692, 498689, 498690,498691, 498707

'===============================================================

Percentage = 50
ExcludeQuantity = 1

'===============================================================

If AllowDiscount = "Y" Then

	SQLEventCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Clean(Request("OrderNumber")) & " AND Seat.EventCode = " & Clean(Request("EventCode"))
	Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)

	If Not rsEventCount.EOF Then

		SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & ""
		Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)

			If Int(rsDiscCount("LineCount")) = 1 Then 'Apply the discount to this item	
			
				If Surcharge > 0 Then
					NewSurcharge = Surcharge
					AppliedFlag = "Y"
				End If

			Else
			
				If Surcharge > 0 Then
					NewSurcharge = round(CDbl(Clean(Request("Surcharge"))) * (1-CDbl(Percentage)/100), 2)
					Surcharge = NewSurcharge
					AppliedFlag = "Y"
				End If
			
			
			End If
		
		rsDiscCount.Close
		Set rsDiscCount = nothing

	End If

	rsEventCount.Close
	Set rsEventCount = nothing
	
End If
		
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf
	
%>