<%

'CHANGE LOG - Inception

'SSR 5/17/2013 -  Update
'SSR 5/10/2013  - Custom discount code created

%>

<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%



'========================================================
'(5/17/2013)
'Updated Discount with maximum of 1 order per discount code system wide


'(5/10/2013)

'Collective Dance 

'Amount Discount - Maxmimum per Order Discount

'Platform: 'Tix 2

'Coded Discount- One $36.00 discount per order.
'Eligible ActCodes: 92250
'EventCodes: Events(??)pending per set up
'Online and Offline
'Re-calculate service fees
'Additional Tickets: 
'One Per  Order
'Code entry required
'No expiration
'Discount valid on all tickets


'========================================================


MinTicketCount = 1 'Min number of tickets per order

MaxDiscount = 36  'Max discount amount per order

MaxDiscountSystemUsage = 1 'Only 1 order system use

HistoryBeginDate = CDate("5/14/2013") 'Start of ticket sales

MaxDiscountSystemUsageOK = "Y" 

'-------------------------------

If MaxDiscountSystemUsage <> 0 Then

    If HistoryBeginDate <> "" Then
        SQLHistoryBeginDate = " AND OrderLine.StatusDate >= '" & HistoryBeginDate & "'"
    End If
	
	SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) WHERE OrderLine.OrderNumber NOT IN (" & OrderNumber & ") AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & SQLHistoryBeginDate
	Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
	MaxTicketCount = rsDiscCount("LineCount")
	rsDiscCount.Close
	Set rsDiscCount = nothing
	
	If MaxTicketCount >= MaxDiscountSystemUsage Then
		MaxDiscountSystemUsageOK = "N"
	End If
	
End If


If MaxDiscountSystemUsageOK = "Y" Then 

'Determine the number of tickets on the order
SQLTicketCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.Price <> 0 AND Seat.EventCode = " & EventCode & ""
Set rsTicketCount = OBJdbConnection.Execute(SQLTicketCount)		
TotalTicketCount = rsTicketCount("SeatCount")		
rsTicketCount.Close
Set rsTicketCount = nothing


If TotalTicketCount >= MinTicketCount Then

	SeriesCount = TotalTicketCount
	
	SeriesDiscount = MaxDiscount

	'Determine how many seats have already been discounted
	SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
	Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)		
	AppliedCount = rsDiscCount("LineCount")		
	rsDiscCount.Close
	Set rsDiscCount = nothing
	
	If AppliedCount < SeriesCount Then
		
		Remainder = AppliedCount  MOD SeriesCount
		
		If Remainder = SeriesCount - 1 Then 
			DiscountAmount = SeriesDiscount - ((SeriesCount - 1) * Round(SeriesDiscount /SeriesCount, 2))
		Else
			DiscountAmount = Round(SeriesDiscount/SeriesCount, 2)
		End If
								
		NewPrice = Price - DiscountAmount
		
		If NewPrice < 0 Then 
			NewPrice = 0
		End If
			
		AppliedFlag = "Y"
							
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
    	


Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf


%>