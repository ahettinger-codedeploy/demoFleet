<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%
'CHANGE LOG
'SLM - 5.24.11
'Update Pricing per client

'=======================

'ALPLM Pork and Cork

'Valid for any ticket
'Valid on mulitples of 2

'Series Price: $30.00
'Ticket Price: $15.00

'=========================

'Discount Variables
Multiple = 2
FixedPrice = 15.00
ExpirationDate = CDate("7/17/2011")

If Now() < ExpirationDate Then

SQLEventCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Seat.EventCode = " & EventCode
Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)

If Not rsEventCount.EOF Then

	If rsEventCount("SeatCount") >= Multiple Then 'Apply the discount to this order

		'Determine number of existing seats which have discount applied.
		SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber 
		Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)

		If Int(rsDiscCount("LineCount") / Multiple) < Int(rsEventCount("SeatCount") / Multiple) Then 'Apply the discount to this item	
		
		    'If Clean(Request("Price")) > FixedPrice Then
		    If Clean(Request("Price")) = 15 Then
					NewPrice = FixedPrice
				Else 
					NewPrice = Price - 5
		    End If	

			DiscountAmount = Round(Price - NewPrice, 2)
			
			AppliedFlag = "Y"

        	NewSurcharge = CDbl(Clean(Request("NewSurcharge")))
			If Request("NewSurcharge") <> "" Then
				Surcharge = NewSurcharge
			Else
				If Request("CalcServiceFee") <> "N" Then
					Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
				End If
			End If

		End If
			
	End If
		
End If
						
rsEventCount.Close
Set rsEventCount = nothing

End If

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>