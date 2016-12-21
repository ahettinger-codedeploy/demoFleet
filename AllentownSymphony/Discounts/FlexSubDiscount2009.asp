<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->

<%

'Initialize Variables
NewPrice = Clean(Request("Price"))
Price = Clean(Request("Price"))
DiscountAmount = 0
Surcharge = Clean(Request("Surcharge"))
AppliedFlag = "N"
OrderNumber = Clean(Request("OrderNumber"))
EventCode = Clean(Request("EventCode"))
DiscountTypeNumber = Clean(Request("DiscountTypeNumber"))
SeatTypeCode = Clean(Request("SeatTypeCode"))

'Counts total number of tickets in order. This discount looks at tickets in any combination, regardless of production.
SQLEventCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Clean(Request("OrderNumber"))
Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)

If rsEventCount("SeatCount") >= 4 Then

	'FlexPass-8 pricing
	If rsEventCount("SeatCount") >= 8 Then 
		SeriesCount = 8
		SeriesPrice = 305 '$38.125 per ticket
		
	'FlexPass-6 pricing
	ElseIf rsEventCount("SeatCount") >= 6 And rsEventCount("SeatCount") <= 7 Then 
		SeriesCount = 6
		SeriesPrice = 235 '$39.166 per ticket
		
	'FlexPass-4 pricing	
	ElseIf rsEventCount("SeatCount") >= 4 And rsEventCount("SeatCount") <= 5 Then 
		SeriesCount = 4
		SeriesPrice = 160 '$40.00 per ticket
	End If
		
'Count # of existing seats which have discount applied.
SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber 
Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)

If Int(rsDiscCount("LineCount") / SeriesCount) < Int(rsEventCount("SeatCount") / SeriesCount) Then 'If this ticket is within the series count, apply the discount price to this ticket
		
		SQLCount = "SELECT COUNT(OrderLine.ItemNumber) AS AppliedCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND DiscountTypeNumber = " & DiscountTypeNumber
		Set rsCount = OBJdbConnection.Execute(SQLCount)
		Count = rsCount("AppliedCount")
		rsCount.Close
		Set rsCount = nothing
	
		'MOD function to determine the last ticket to complete the subscription discount (i.e. fourth ticket in the FlexPass-4, or eighth ticket in a FlexPass-8, etc.).  
		'The MOD function calculates the remainder when dividing one number by the other. 
		Remainder = Count MOD SeriesCount

		' Calculates the total of all discounted ticket prices already given to figure out the discounted ticket price to be assign to this ticket.
		If Remainder = SeriesCount - 1 Then 
		    NewPrice = SeriesPrice - ((SeriesCount - 1) * Round(SeriesPrice/SeriesCount, 2))
		Else
				'Standard rounding on all other tickets.
		    NewPrice = Round(SeriesPrice/SeriesCount, 2)
		End If
			
Else
	
		NewPrice = Price 'Falls outside of the required series number. Gets full price.

End If
		
	rsDiscCount.Close
	Set rsDiscCount = nothing			
	
	AppliedFlag = "Y"					
	
	DiscountAmount = Clean(Request("Price")) - NewPrice
									
	If Request("CalcServiceFee") <> "N" Then
		Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, Clean(Request("EventCode")), Clean(Request("ItemType")))
	End If

End If				
	
rsEventCount.Close
Set rsEventCount = nothing

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>