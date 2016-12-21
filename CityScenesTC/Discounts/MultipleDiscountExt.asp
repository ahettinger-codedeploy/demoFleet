<%

'CHANGE LOG
'JAI 5/16/12 - New multiples discount script.  Variable "Multiple" must be passed.  Discount will be applied to all even multiples of the passed variable for a given event.
'SSR 05/23/13 - 'Custom discount created for City Scenes Theater Company, based on generic mutiple discount.
				'Extended generic MultipleDiscount.asp discount script with these new parameters:
				'Added new parameter to require purchase of specific ticket type.  Parameter: RequiredSeatTypeCode=1
				'Updated script to allow discount of specific ticket type. Parameter: AllowedSeatTypeCode=2984
				'Added new parameter to control how discount is applied. Parameter: QuantityToDiscountPerMultiple=1

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'--------------------------------------------------------

'Discount Option
'Discount tickets in multiples of X

If Clean(Request("Multiple")) <> "" Then
    Multiple = CInt(Clean(Request("Multiple")))
Else 
    AllowDiscount = "N"
End If

'--------------------------------------------------------

'Discount Option
'Allow discounts in specific section

AllowedSectionSQL = ""
If Clean(Request("AllowedSectionList")) <> "" Then
AllowedSectionSQL = " AND Seat.SectionCode IN ('" & Replace(Clean(Request("AllowedSectionList")),",","','") & "')"
End If

'--------------------------------------------------------

'Discount Option
'Allow discounts on specific seat types

AllowedSeatTypeSQL = ""
If Clean(Request("AllowedSeatTypeCode")) <> "" Then
AllowedSeatTypeSQL = " AND OrderLine.SeatTypeCode IN (" & Clean(Request("AllowedSeatTypeCode")) & ")"
End If

'--------------------------------------------------------

'Extended Discount Option
'Require purchase of specific seat types

RequiredSeatTypeSQL = ""
If Clean(Request("RequiredSeatTypeCode")) <> "" Then
RequiredSeatTypeSQL = " AND OrderLine.SeatTypeCode IN (" & Clean(Request("RequiredSeatTypeCode")) & ")"
End If

'--------------------------------------------------------

'Extended Discount Option
'Determine number of discounted tickets per each multiple

QuantityToDiscountPerMultiple = ""
If Clean(Request("QuantityToDiscountPerMultiple")) <> "" Then
QuantityToDiscountPerMultiple = Clean(Request("QuantityToDiscountPerMultiple"))
End If

'--------------------------------------------------------

If AllowDiscount = "Y" Then 'It's okay to apply to this order.

	'Count Required Tickets
	SQLTicketCount = "SELECT COUNT(*) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.OrderNumber = Seat.OrderNumber AND OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Seat.EventCode = " & EventCode & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent')" & AllowedSectionSQL & RequiredSeatTypeSQL
	Set rsTicketCount = OBJdbConnection.Execute(SQLTicketCount)
    TicketCount = rsTicketCount("TicketCount")
    rsTicketCount.Close
	Set rsTicketCount = nothing
	
	'Count Allowed Tickets
	SQLDiscCount = "SELECT COUNT(*) AS AppliedCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.OrderNumber = Seat.OrderNumber AND OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & "  AND Seat.EventCode = " & EventCode & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent')" & AllowedSeatTypeSQL & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber
	Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
    AppliedCount = rsDiscCount("AppliedCount")
	rsDiscCount.Close
	Set rsDiscCount = nothing
		
    AllowCount = 0
	
	If TicketCount >= Multiple Then
		
		If QuantityToDiscountPerMultiple <> "" Then
			AllowCount = Fix(TicketCount / Multiple) * QuantityToDiscountPerMultiple
			ErrorLog("AllowCountQty " & AllowCount & "")
		Else
			AllowCount = Fix(TicketCount / Multiple) * Multiple
			ErrorLog("AllowCountStnd " & AllowCount & "")
		End If

    End If

    If AllowCount > AppliedCount Then
	
		If Clean(Request("Percentage")) <> "" Then
			NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Clean(Request("Percentage")))/100), 2)
		ElseIf Clean(Request("FixedPrice")) <> "" Then
			NewPrice = Round(CDbl(Clean(Request("FixedPrice"))),2)
		Else
			NewPrice = Round(CDbl(Clean(Request("Price"))),2) - Round(CDbl(Clean(Request("DiscountAmount"))),2)
		End If	
		
		DiscountAmount = Round(Clean(Request("Price")),2) - NewPrice

		If Request("NewSurcharge") <> "" Then
			Surcharge = NewSurcharge
		ElseIf Request("CalcServiceFee") <> "N" Then
			Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
		End If

		AppliedFlag = "Y"
		
	End If
	
End If	

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>