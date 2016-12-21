<%
'CHANGE LOG
'SSR 4/10/13 - Create custom discount code

%>

<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'==================================================
'African American Forum

'Platform Tix 2

'Parameters
'Group Discount - Buy 10 more Tickets - Get $5.00 off per ticket
'Group Discount- Buy 1-9 tickets, get $2.50 off

'Eligible ActCodes / EventCodes
'ActCodes: 93592 
'EventCodes: 581446 

'Offline/Online: Online and Offline
'Service Fees: No Service Fee change
'Additional Tickets: All additional tickets should receive discount 

'Automatic/Code Entry: Discount should be applied automatically 
'Expiration: No expiration
'Restrictions: Discount valid on all tickets

'==================================================

DIM GroupCount(2)
GroupCount(1) = 1
GroupCount(2) = 10

DIM GroupDiscount(2)
GroupDiscount(1) = 2.50
GroupDiscount(2) = 5.00

'==================================================

If AllowDiscount = "Y" Then

        SQLEventCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Clean(Request("OrderNumber")) & " AND Seat.EventCode = " & Clean(Request("EventCode"))
        Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)

        If Not rsEventCount.EOF Then
        
				'Determine Discount Tier
			    If rsEventCount("SeatCount") >= GroupCount(1)  And rsEventCount("SeatCount") <= (GroupCount(2) - 1) Then 
					DiscountAmount = GroupDiscount(1)
    			
			    ElseIf rsEventCount("SeatCount") >= GroupCount(2) Then 
					DiscountAmount = GroupDiscount(2)
				
    			Else
					DiscountAmount = 0
					
				End If
				
    							
				'Apply Discount
				If DiscountAmount <> 0 Then
				
					NewPrice = Clean(Request("Price")) - DiscountAmount
					AppliedFlag = "Y"

					' Determine Service Fees
					If Request("NewSurcharge") <> "" Then
						Surcharge = NewSurcharge
					Else
						If Request("CalcServiceFee") <> "N" Then
							Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, Clean(Request("EventCode")), Clean(Request("ItemType")))
						End If
					End If
				
				End If
                
        End If
	
End If

				
rsEventCount.Close
Set rsEventCount = nothing

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>