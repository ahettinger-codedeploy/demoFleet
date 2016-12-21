<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->

<%

'Initialize Variables
NewPrice = CDbl(Clean(Request("Price")))
DiscountAmount = 0
Surcharge = CDbl(Clean(Request("Surcharge")))
AppliedFlag = "N"
'REE 10/26/4 - Added NewSurcharge
NewSurcharge = CDbl(Clean(Request("NewSurcharge")))
SeatTypeCode = Clean(Request("SeatTypeCode"))
AllowedSeatTypeCode = Clean(Request("AllowedSeatTypeCode"))
'REE 11/5/5 - Added Maximum Usage
MaxDiscountsPerOrderPerEvent = CInt(Clean(Request("MaxDiscountsPerOrderPerEvent")))
MaxDiscountsPerOrder = CInt(Clean(Request("MaxDiscountsPerOrder")))
MaxDiscountSystemUsage = CInt(Clean(Request("MaxDiscountSystemUsage")))
OrderNumber = Clean(Request("OrderNumber"))
EventCode = Clean(Request("EventCode"))
DiscountTypeNumber = Clean(Request("DiscountTypeNumber"))
SectionCode = Clean(Request("SectionCode"))

'Apply the discount to these sections only
If SectionCode = "B" Or SectionCode = "C" Then   


'REE 8/10/4 - Added Offline/Online Order Type Check
OrderTypeFlag = "Y"
If Clean(Request("OfflineOnly")) = "Y" And Clean(Request("OrderTypeNumber")) = 1 Then
	OrderTypeFlag = "N"
End If
If Clean(Request("OnlineOnly")) = "Y" And Clean(Request("OrderTypeNumber")) <> 1 Then
	OrderTypeFlag = "N"
End If

'SLM 10/11/5 - Added check for Seat Type
AllowedSeatTypeFlag = "Y"
If AllowedSeatTypeCode <> "" And SeatTypeCode <> AllowedSeatTypeCode Then
	AllowedSeatTypeFlag = "N"
End If

'REE 11/23/5 - Added Maximum Order Event Usage
MaxDiscountsPerOrderPerEventOK = "Y"
If MaxDiscountsPerOrderPerEvent <> 0 Then
	SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Seat.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber 
	Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
	TicketCount = rsDiscCount("LineCount")
	rsDiscCount.Close
	Set rsDiscCount = nothing
	If TicketCount >= MaxDiscountsPerOrderPerEvent Then
		MaxDiscountsPerOrderPerEventOK = "N"
	End If
End If

'REE 11/23/5 - Added Maximum Order Usage
MaxDiscountsPerOrderOK = "Y"
If MaxDiscountsPerOrder <> 0 Then
	SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber 
	Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
	TicketCount = rsDiscCount("LineCount")
	rsDiscCount.Close
	Set rsDiscCount = nothing
	If TicketCount >= MaxDiscountsPerOrder Then
		MaxDiscountsPerOrderOK = "N"
	End If
End If

'REE 11/23/5 - Added Maximum System Usage
MaxDiscountSystemUsageOK = "Y"
If MaxDiscountSystemUsage <> 0 Then
	SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) WHERE OrderLine.DiscountTypeNumber = " & DiscountTypeNumber 
	Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
	TicketCount = rsDiscCount("LineCount")
	rsDiscCount.Close
	Set rsDiscCount = nothing
	If TicketCount >= MaxDiscountSystemUsage Then
		MaxDiscountSystemUsageOK = "N"
	End If
End If

'REE 11/23/5 - Added Maximum Usage
If OrderTypeFlag = "Y" And AllowedSeatTypeFlag = "Y" And MaxDiscountsPerOrderPerEventOK = "Y" And MaxDiscountsPerOrderOK = "Y" And MaxDiscountSystemUsageOK = "Y" Then 'It's okay to apply to this order type.
	'REE 8/6/4 - Added Expiration Date Functionality
	If Clean(Request("ExpirationDate")) <> "" Then 'The discount has an expiration date
		ExpirationDate = CDate(Clean(Request("ExpirationDate")))
	Else 'There is no expiration.  Add one to the current date so that it does not expire.
		ExpirationDate = DateAdd("d", 1, Now())
	End If

	If Now() < ExpirationDate Then

		NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Clean(Request("Percentage")))/100), 2)
		DiscountAmount = Clean(Request("Price")) - NewPrice
		
		'REE 10/26/4 - Added NewSurcharge
		If Request("NewSurcharge") <> "" Then
			Surcharge = NewSurcharge
		Else
			If Request("CalcServiceFee") <> "N" Then
				'JAI - 2/9/5 - Added ItemType to CalcCustomerFee
				Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, Clean(Request("EventCode")), Clean(Request("ItemType")))
			End If
		End If
		
		AppliedFlag = "Y"

	End If
End If
End If

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>