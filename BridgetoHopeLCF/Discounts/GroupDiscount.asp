<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'GA (GENAD) Settings, must be sets of 4
GAGroupCount = 4
GADiscountAmount = 12.50
'Preferred (PREF) Settings, 10 or more
PreferredGroupCount = 10
PreferredDiscountAmount = 6
'VIP (VIP) Settings, 4 or more
VIPGroupCount = 4
VIPDiscountAmount = 15

If AllowDiscount = "Y" Then 'It's okay to apply this ticket

    'Count # of tickets in this event / section
	SQLEventCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Clean(Request("OrderNumber")) & " AND Seat.EventCode = " & Clean(Request("EventCode")) & " AND Seat.SectionCode = '" & SectionCode & "'"
	Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)
    SectionCount = rsEventCount("SeatCount")
    rsEventCount.Close
    Set rsEventCount = nothing

	Select Case SectionCode
	Case "GENAD" ' General Admission
        If SectionCount >= GAGroupCount Then
            'Count # of tickets with discount already applied
            SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND Seat.SectionCode = '" & SectionCode & "'"
            Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
            AppliedCount = rsDiscCount("LineCount")
            rsDiscCount.Close
            Set rsDiscCount = nothing

            QtyToApply = Fix(SectionCount / GAGroupCount) * GAGroupCount
            If AppliedCount < QtyToApply Then 'Apply the discount to this item	
                NewPrice = Price - GADiscountAmount
			    AppliedFlag = "Y"
		    End If
        End If
        						
    Case "PREF" 'Preferred
        If SectionCount >= PreferredGroupCount Then
            NewPrice = Price - PreferredDiscountAmount
   			AppliedFlag = "Y"
        End If
    
    Case "VIP" 'VIP
        If SectionCount >= VIPGroupCount Then
            NewPrice = Price - VIPDiscountAmount
   			AppliedFlag = "Y"
        End If

	End Select	
	DiscountAmount = Clean(Request("Price")) - NewPrice

	If Request("CalcServiceFee") <> "N" Then
		Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, Clean(Request("EventCode")), Clean(Request("ItemType")))
	End If
		
End If
					
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>