<%

'CHANGE LOG - Inception
'SSR 5/4/2012


%>

<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'========================================

'Clinton County Chamber of Commerce (4103)

'Parameters
'Multiples of two Adult tickets will be discounted a total of $20 at checkout. (ex: 2 Adult @ $65 ea. = $110)
'Event Code: 473976
'Online/Offline: Online and Offline
'Service Fees: Do not re-calculate service fees
'Additional Tickets: A $20 discount should be applied for each multiple of two Adult tickets.
'Automatic/Code Entry: Discount should be applied automatically
'Expiration: No expiration
'Restrictions: None.

'========================================

RequiredSeatType = 1
Multiple = 2
CoupleDiscount = 20

'========================================

'Determine the number of required Tickets on order
SQLEventCount = "SELECT COUNT(OrderLine.LineNumber) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' WHERE OrderLine.OrderNumber = " & OrderNumber & " AND EventCode = " & EventCode & " AND OrderLine.SeatTypeCode IN (" & RequiredSeatType & " )"
Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)

If Not rsEventCount.EOF Then

	If rsEventCount("SeatCount") >= Multiple Then 'Apply the discount to this order

		'Determine number of existing seats which have discount applied.
		SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber 
		Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)

		If Int(rsDiscCount("LineCount") / Multiple) < Int(rsEventCount("SeatCount") / Multiple) Then 'Apply the discount to this item	
		
        NewPrice = (Price - (CoupleDiscount / 2))
                        
             If Price > NewPrice Then

                    If NewPrice < 0 Then 
                        NewPrice = 0
                    End if
            
                    DiscountAmount = Clean(Request("Price")) - NewPrice

                    AppliedFlag = "Y"

                    If Request("NewSurcharge") <> "" Then
                        Surcharge = NewSurcharge	
                    ElseIf Request("CalcServiceFee") <> "N" Then
                        Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))				
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