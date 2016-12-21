<%
'CHANGE LOG
'SSR 10/23/2013 - Created Discount

%>
<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->

<%

'==================================================================

'Illinois Youth Dance Theatre, Inc. 10/23/2013
'Group Discount - All Events

'Discount Code:			Group10
'Description:			10+ ticket sales discount
'Available Internet:	YES
'Available Box Office:	YES
'Ticket Type:			All
'Start Date/Time:		Now
'End Date/Time:			Does Not Expire
'Service Fee:			No Change to Service Fees
'Additional Parameters:	Tickets are counted across all events on the order 

'==================================================================

'Initialize Variables
NewPrice = Clean(Request("Price"))
DiscountAmount = 0
Surcharge = Clean(Request("Surcharge"))
AppliedFlag = "N"
OrderNumber = Clean(Request("OrderNumber"))
EventCode = Clean(Request("EventCode"))
SeatTypeCode = Clean(Request("SeatTypeCode"))
AllowedSeatTypeCode = Clean(Request("AllowedSeatTypeCode"))
If Request("AllowedSeatTypeCode") <> "" Then
	AllowedSeatTypeCode = "," & Clean(Request("AllowedSeatTypeCode")) & ","
End If
SectionCode = Clean(Request("SectionCode"))
If Request("AllowedSectionList") <> "" Then
	AllowedSectionList = "," & Clean(Request("AllowedSectionList")) & ","
	SQLAllowedSectionList = Replace(AllowedSectionList, ",", "','")
	SQLAllowedSectionList = Left(SQLAllowedSectionList, Len(SQLAllowedSectionList) - 2)
	SQLAllowedSectionList = Mid(SQLAllowedSectionList, 3, Len(SQLAllowedSectionList))
	SQLAllowedSectionList = " AND Seat.SectionCode IN (" & SQLAllowedSectionList & ")"
End If
DiscountTypeNumber = Clean(Request("DiscountTypeNumber"))
MaxDiscountsPerEvent = CInt(Clean(Request("MaxDiscountsPerEvent")))
MaxDiscountsPerOrderPerEvent = CInt(Clean(Request("MaxDiscountsPerOrderPerEvent")))
MaxDiscountsPerOrder = CInt(Clean(Request("MaxDiscountsPerOrder")))
MaxDiscountSystemUsage = CInt(Clean(Request("MaxDiscountSystemUsage")))
NewSurcharge = CDbl(Clean(Request("NewSurcharge")))


'SSR 3/23/5 - Added Offline/Online Order Type Check
OrderTypeFlag = "Y"
If Clean(Request("OfflineOnly")) = "Y" And Clean(Request("OrderTypeNumber")) = 1 Then
	OrderTypeFlag = "N"
End If
If Clean(Request("OnlineOnly")) = "Y" And Clean(Request("OrderTypeNumber")) <> 1 Then
	OrderTypeFlag = "N"
End If

'JAI 5/24/5 - Added check for Seat Type
'JAI 3/22/7 - Now allow multiple Seat Types in list
AllowedSeatTypeFlag = "Y"
If AllowedSeatTypeCode <> "" Then
	If InStr(AllowedSeatTypeCode, "," & CStr(SeatTypeCode) & ",") = 0 Then
		AllowedSeatTypeFlag = "N"
	End If
End If

'REE 5/17/6 - Added Maximum Checks
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

'REE 3/23/6 - Added Maximum Per Event Usage
MaxDiscountsPerEventOK = "Y"
If MaxDiscountsPerEvent <> 0 Then
	SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') WHERE Seat.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber 
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
	SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Seat.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber 
	Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
	TicketCount = rsDiscCount("LineCount")
	rsDiscCount.Close
	Set rsDiscCount = nothing
	If TicketCount >= MaxDiscountsPerOrderPerEvent Then
		MaxDiscountsPerOrderPerEventOK = "N"
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

'SSR 12/30/08 - Added Check for allowed Section
AllowedSectionOK = "Y"
If AllowedSectionList <> "" Then
	If InStr(AllowedSectionList, "," & SectionCode & ",") = 0 Then
		AllowedSectionOK = "N"
	End If
End If

'JAI 2/17/9 - Added Expiration Date Functionality
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

If OrderTypeFlag = "Y" And AllowedSeatTypeFlag = "Y" And MaxDiscountsPerOrderOK = "Y" And MaxDiscountsPerEventOK = "Y" And MaxDiscountsPerOrderPerEventOK = "Y" And MaxDiscountSystemUsageOK = "Y" And AllowedSectionOK = "Y" And Now() > StartDate And Now() < ExpirationDate Then 'It's okay to apply to this order type and seat type.
	
	If Clean(Request("AllEvents")) = "Y" Then
		'SSR 10/01/2013 - Count tickets acrross all events
		 SQLEventCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Clean(Request("OrderNumber")) &  SQLAllowedSectionList
	Else
		'REE 6/20/7 - Removed SQLList from query criteria since SeatTypeCode is being checked above.
		 SQLEventCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Clean(Request("OrderNumber")) & " AND Seat.EventCode = " & Clean(Request("EventCode")) & SQLAllowedSectionList
	End If
	
	Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)

	If Not rsEventCount.EOF Then
		If rsEventCount("SeatCount") >= CInt(Clean(Request("Qty"))) Then 'Apply the discount
			'REE 8/12/4 - Added abilty to pass dollar off and percentage off
			If Clean(Request("Percentage")) <> "" Then
				NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Clean(Request("Percentage")))/100), 2)
			ElseIf Clean(Request("FixedPrice")) <> "" Then
				NewPrice = Round(CDbl(Clean(Request("FixedPrice"))),2)
			Else
				NewPrice = Round(CDbl(Clean(Request("Price"))),2) - Round(CDbl(Clean(Request("DiscountAmount"))),2)
			End If			
			DiscountAmount = Round(Clean(Request("Price")),2) - NewPrice

			'REE 10/15/5 - Added NewSurcharge
			If Request("NewSurcharge") <> "" Then
				Surcharge = NewSurcharge
			Else
				If Request("CalcServiceFee") <> "N" Then
					'JAI - 2/9/5 - Added ItemType to CalcCustomerFee
					Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
				End If
			End If

			AppliedFlag = "Y"
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