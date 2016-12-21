<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->

<%

'Initialize Variables
NewPrice = Clean(Request("Price"))
DiscountAmount = 0
Surcharge = Clean(Request("Surcharge"))
AppliedFlag = "N"
OrderNumber = Clean(Request("OrderNumber"))
EventCode = Clean(Request("EventCode"))
SeatTypeCode = Clean(Request("SeatTypeCode"))
AllowedSeatTypeCode = Clean(Request("AllowedSeatTypeCode"))
SectionCode = Clean(Request("SectionCode"))
If Request("AllowedSectionList") <> "" Then
	AllowedSectionList = "," & Clean(Request("AllowedSectionList")) & ","
End If
DiscountTypeNumber = Clean(Request("DiscountTypeNumber"))
MaxDiscountsPerEvent = CInt(Clean(Request("MaxDiscountsPerEvent")))
MaxDiscountsPerOrderPerEvent = CInt(Clean(Request("MaxDiscountsPerOrderPerEvent")))
MaxDiscountsPerOrder = CInt(Clean(Request("MaxDiscountsPerOrder")))
MaxDiscountSystemUsage = CInt(Clean(Request("MaxDiscountSystemUsage")))


'SSR 3/28/5 - Added Offline/Online Order Type Check
OrderTypeFlag = "Y"
If Clean(Request("OfflineOnly")) = "Y" And Clean(Request("OrderTypeNumber")) = 1 Then
	OrderTypeFlag = "N"
End If
If Clean(Request("OnlineOnly")) = "Y" And Clean(Request("OrderTypeNumber")) <> 1 Then
	OrderTypeFlag = "N"
End If

'JAI 5/24/5 - Added check for Seat Type
AllowedSeatTypeFlag = "Y"
If AllowedSeatTypeCode <> "" And SeatTypeCode <> AllowedSeatTypeCode Then
	AllowedSeatTypeFlag = "N"
End If

'REE 3/23/6 - Added Maximum Per Event Usage
MaxDiscountsPerEventOK = "Y"
If MaxDiscountsPerEvent <> 0 Then
	SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' WHERE Seat.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber 
	Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
	TicketCount = rsDiscCount("LineCount")
	rsDiscCount.Close
	Set rsDiscCount = nothing
	If TicketCount >= MaxDiscountsPerEvent Then
		MaxDiscountsPerEventOK = "N"
	End If
End If

'REE 9/30/5 - Added Maximum Order Event Usage
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

'REE 10/19/5 - Added Maximum Order Usage
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

'REE 10/19/5 - Added Maximum System Usage
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

'JAI 9/8/6 - Added Check for allowed Section
AllowedSectionOK = "Y"
If AllowedSectionList <> "" Then
	If InStr(AllowedSectionList, "," & SectionCode & ",") = 0 Then
		AllowedSectionOK = "N"
	End If
End If

'REE 11/29/6 - Added MaxDiscountsPerEventOK to criteria
If OrderTypeFlag = "Y" And AllowedSeatTypeFlag = "Y" And MaxDiscountsPerEventOK = "Y" And MaxDiscountsPerOrderPerEventOK = "Y" And MaxDiscountsPerOrderOK = "Y" And MaxDiscountSystemUsageOK = "Y" And AllowedSectionOK = "Y" Then 'It's okay to apply to this order type and seat type.

	'REE 11/16/4 - Added NewSurcharge
	NewSurcharge = CDbl(Clean(Request("NewSurcharge")))


	'REE 8/6/4 - Added Expiration Date Functionality
	If Clean(Request("ExpirationDate")) <> "" Then 'The discount has an expiration date
		ExpirationDate = CDate(Clean(Request("ExpirationDate")))
	Else 'There is no expiration.  Add one to the current date so that it does not expire.
		ExpirationDate = DateAdd("d", 1, Now())
	End If

	'REE 8/21/4 - Added Start Date Functionality
	If Clean(Request("StartDate")) <> "" Then 'The discount has a start date
		StartDate = CDate(Clean(Request("StartDate")))
	Else 'There is no start date.  Subtract one from the current date so that it's valid now.
		StartDate = DateAdd("d", -1, Now())
	End If

	If Now() > StartDate And Now() < ExpirationDate Then

		If CleanNumeric(Request("Price")) = 30 Or CleanNumeric(Request("Price")) = 37 Then
			NewPrice = Clean(Request("Price")) - Clean(Request("DiscountAmount"))
			AppliedFlag = "Y"
		End If
		If NewPrice < 0 Then
			NewPrice = 0
		End If

		DiscountAmount = Clean(Request("Price")) - NewPrice

			'REE 11/16/4 - Added NewSurcharge
			If Request("NewSurcharge") <> "" Then
				Surcharge = NewSurcharge
			Else
				If Request("CalcServiceFee") <> "N" Then
					'JAI - 2/9/5 - Added ItemType to CalcCustomerFee
					Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
				End If
			End If

	End If

End If

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>