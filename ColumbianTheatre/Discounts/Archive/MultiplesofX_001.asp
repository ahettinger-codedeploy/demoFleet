<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->

<%

'Columbian Theatre - Multiples of 2 Discount - 2/3/10
'$5.00 per ticket when 2 or more tickets are purchased
'Discount only given on those tickets which are mulitples of 2.  


'Initialize Variables
Price = CleanNumeric(Request("Price"))
Surcharge = Clean(Request("Surcharge"))
OrderNumber = CleanNumeric(Request("OrderNumber"))
EventCode = CleanNumeric(Request("EventCode"))
DiscountTypeNumber = CleanNumeric(Request("DiscountTypeNumber"))
AppliedFlag = "N"


'Discount Variables
Multiple = 2
DiscountAmount = 5

SQLEventCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Seat.EventCode = " & EventCode
Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)

If Not rsEventCount.EOF Then

	If rsEventCount("SeatCount") >= Multiple Then 'Apply the discount to this order

		'Determine number of existing seats which have discount applied.
		SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber 
		Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)

		If Int(rsDiscCount("LineCount") / Multiple) < Int(rsEventCount("SeatCount") / Multiple) Then 'Apply the discount to this item		

			NewPrice = Round(Price - DiscountAmount, 2)
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


Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>