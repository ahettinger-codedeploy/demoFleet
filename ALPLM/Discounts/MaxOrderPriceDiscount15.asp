<%

'CHANGE LOG - Inception
'SSR 11/15/2012 - Custom discount code created

%>

<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%



'========================================================

'Lincoln Presidential Library and Museum (2469)

'$10 total on an order, regardless of how many tickets are on the order.  
'So, if there are 4 tickets on the order, each ticket gets discounted to $2.50 per ticket...
'if there are 10 tickets on the order, each ticket gets discounted down to $1.00 per ticket.
'Discount Code = “turkey”
'Offline only
'No limits on how many tickets can be given the discount on one order
'Contact
'Clare Thorpe
'Clare.Thorpe@Illinois.gov

'========================================================

MinTicketCount = 0

TotalOrderPrice = 15

OnlyOffLine = True

'-------------------------------

If OnlyOffLine AND CInt(OrderTypeNumber) <> 1 Then

	'Determine the number of tickets on the order
	SQLTicketCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.Price <> 0 AND Seat.EventCode = " & EventCode & ""
	Set rsTicketCount = OBJdbConnection.Execute(SQLTicketCount)		
	TotalTicketCount = rsTicketCount("SeatCount")		
	rsTicketCount.Close
	Set rsTicketCount = nothing
	

	If TotalTicketCount >= MinTicketCount Then

		SeriesCount = TotalTicketCount
		
		SeriesPrice = TotalOrderPrice

		'Determine how many seats have already been discounted
		SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')"
		Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)		
		AppliedCount = rsDiscCount("LineCount")		
		rsDiscCount.Close
		Set rsDiscCount = nothing
		
		If AppliedCount < SeriesCount Then
		
				Remainder = AppliedCount MOD SeriesCount
				
				If Remainder = SeriesCount - 1 Then 
					NewPrice = SeriesPrice - ((SeriesCount - 1) * Round(SeriesPrice/SeriesCount, 2))
				Else
					NewPrice = Round(SeriesPrice/SeriesCount, 2)
				End If
						   
				If Price > NewPrice Then
				
					DiscountAmount = Price - NewPrice
					
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
	
End If
    	


Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>