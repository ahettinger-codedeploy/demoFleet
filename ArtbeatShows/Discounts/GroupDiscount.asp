<%
'CHANGE LOG
'SSR 4/10/13 - Create custom discount code
'SSR 4/11/13 - Updated discount code

%>

<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'==================================================

'ArtBeat Group Discount

'Tiered Group Discount
'8 or more tickets = $5.00 off per-ticket
'16 or more tickets = $10 off per-ticket
'Automatic - Internet and Box Office
'No service fee change
'No expiration
'No ticket limit

'Eligible ActCodes: 97509, 98119


'==================================================
DIM GroupCount(2)
GroupCount(1) = 8
GroupCount(2) = 16

DIM GroupDiscount(2)
GroupDiscount(1) = 5
GroupDiscount(2) = 10



If AllowDiscount = "Y" Then

		SQLEventCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Clean(Request("OrderNumber")) & " AND Seat.EventCode = " & EventCode
		Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)
				
		If rsEventCount("SeatCount") >= GroupCount(1) Then

			    If rsEventCount("SeatCount") >= GroupCount(1)  And rsEventCount("SeatCount") <= (GroupCount(2) - 1) Then 
					DiscountAmount = GroupDiscount(1)
			    ElseIf rsEventCount("SeatCount") >= GroupCount(2) Then 
					DiscountAmount = GroupDiscount(2)
				End If
				
				NewPrice = Clean(Request("Price")) - DiscountAmount	
				
				If NewSurcharge <> 0 Then
					Surcharge = NewSurcharge
				Else
					If Request("CalcServiceFee") <> "N" Then
						Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, Clean(Request("EventCode")), Clean(Request("ItemType")))
					End If
				End If
				
				AppliedFlag = "Y"	

        End If
	
End If

				
rsEventCount.Close
Set rsEventCount = nothing

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>