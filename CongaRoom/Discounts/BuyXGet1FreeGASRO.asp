<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->

<%

AllowedSectionCode = "GASRO" 

'Initialize Variables
Price = Clean(Request("Price"))
NewPrice = Price
DiscountAmount = 0
Surcharge = Clean(Request("Surcharge"))
AppliedFlag = "N"
OrderNumber = Clean(Request("OrderNumber"))
SeatTypeCode = Clean(Request("SeatTypeCode"))
AllowedSeatTypeCode = Clean(Request("AllowedSeatTypeCode"))
If Request("AllowedSeatTypeCode") <> "" Then
	AllowedSeatTypeCode = "," & Clean(Request("AllowedSeatTypeCode")) & ","
End If
SectionCode = Clean(Request("SectionCode"))
EventCode = Clean(Request("EventCode"))
DiscountTypeNumber = Clean(Request("DiscountTypeNumber"))
OrganizationNumber = Clean(Request("OrganizationNumber"))
QtyToBuy = Clean(Request("QtyToBuy"))

'SSR 4/04/5 - Added Offline/Online Order Type Check
OrderTypeFlag = "Y"
If Clean(Request("OfflineOnly")) = "Y" And Clean(Request("OrderTypeNumber")) = 1 Then
	OrderTypeFlag = "N"
End If
If Clean(Request("OnlineOnly")) = "Y" And Clean(Request("OrderTypeNumber")) <> 1 Then
	OrderTypeFlag = "N"
End If

'REE 8/9/7 - Added check for Seat Type
AllowedSeatTypeFlag = "Y"
If AllowedSeatTypeCode <> "" Then
	If InStr(AllowedSeatTypeCode, "," & CStr(SeatTypeCode) & ",") = 0 Then
		AllowedSeatTypeFlag = "N"
	End If
End If
AllowedSectionOK = "Y"
If SectionCode <> AllowedSectionCode Then
	AllowedSectionOK = "N"
Else
	AllowedSectionCodeInclude = " AND Seat.SectionCode = '" & AllowedSectionCode & "'"
End If

If OrderTypeFlag = "Y" And AllowedSeatTypeFlag = "Y" And AllowedSectionOK = "Y" Then 'It's okay to apply to this order type and Seat Type.

'JAI 10/7/7 - Determine # of Tickets on this order with a price greater than or equal to the current ticket.
If Clean(Request("AllEvents")) = "Y" Then
	SQLCount = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') INNER JOIN DiscountEvents (NOLOCK) ON Seat.EventCode = DiscountEvents.EventCode AND DiscountEvents.DiscountTypeNumber = " & DiscountTypeNumber & " WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.Price >= " & Price & " AND OrderLine.Price > 0" & AllowedSectionCodeInclude
Else
	SQLCount = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.Price >= " & Price & " AND OrderLine.Price > 0 AND EventCode = " & EventCode & AllowedSectionCodeInclude
End If
Set rsCount = OBJdbConnection.Execute(SQLCount)
nbrTickets = rsCount("TicketCount")
rsCount.Close
Set rsCount = nothing

If NbrTickets > 1 Then 'Need to have more than one ticket on order

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

		'Count # of existing seats which have discount applied.
		If Clean(Request("AllEvents")) = "Y" Then
			SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber 
		Else
			SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber 
		End If
		Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
	
		If rsDiscCount("LineCount") < Fix(NbrTickets / (Fix(QtyToBuy)+1)) Then 'Apply the discount
			NewPrice = 0
			DiscountAmount = Price - NewPrice
			Surcharge = 0
			AppliedFlag = "Y"
		End If
		rsDiscCount.Close
		Set rsDiscCount = nothing

	End If
End If
End If
					
Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>