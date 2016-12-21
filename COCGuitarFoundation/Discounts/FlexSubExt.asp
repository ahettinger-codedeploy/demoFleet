<%

'CHANGE LOG
'JAI 06/07/12 - Tightened application of discount to not allow extra tickets to be discounted.
'SSR 05/05/13 - 'Custom discount created for The City Choir of Washington
				'Extended generic FlexSub discount script with these new parameters:
				'Added option to allow extra tickets to be discounted. Parameter: AllowDiscAddTicket=Y
				'Added option to round price down to the nearest dollar. Parameter: AllowRoundUp=Y
				'Added option to round price up to the nearest dollar. Parameter: AllowRoundDown=Y 

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'--------------------------------------------------------

	'Allow discount on additional tickets
	'Default is FALSE

	DIM AddTicketDisc
	AddTicketDisc = FALSE
	
	If Clean(Request("AddTicketDisc")) <> "" Then
	
		If Clean(Request("AddTicketDisc")) = "Y" Then
			AddTicketDisc = TRUE
		End If
		
		If Clean(Request("AddTicketDisc")) = "N" Then
			AddTicketDisc = FALSE
		End If
		
	End If
	
'--------------------------------------------------------

	'Extended Discount Option
	'Round new price up or down to nearest dollar

	DIM roundFunction

	If Request("AllowRoundUp") = "Y" Then
		roundFunction = "roundUp"
	End If

	If Request("AllowRoundDown") = "Y" Then
		roundFunction = "roundDown"
	End If

	ErrorLog("roundFunction (" & roundFunction & ")")

	If roundFunction = "" Then
		roundFunction = "roundOut"
	End If


'--------------------------------------------------------

	'Initialize Variables

	SeriesCount = CInt(CleanNumeric(Request("SeriesCount"))) 'Number of Productions in the Subscription
	NbrSubscriptions = 0
	NbrTickets = 0

'--------------------------------------------------------

	If AllowDiscount = "Y" Then 'It's okay to apply to this order.

		'Count # of applicable Acts on the order.
		SQLActCount = "SELECT COUNT(DISTINCT Event.ActCode) AS ActCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode INNER JOIN DiscountEvents (NOLOCK) ON Event.EventCode = DiscountEvents.EventCode WHERE Seat.OrderNumber = " & OrderNumber & " AND DiscountEvents.DiscountTypeNumber = " & DiscountTypeNumber & AllowedSeatTypeList & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent')"
		Set rsActCount = OBJdbConnection.Execute(SQLActCount)
		ActCount = rsActCount("ActCount")
		rsActCount.Close
		Set rsActCount = nothing
		
		If ActCount >= SeriesCount Then
		
			'Get the fewest number of tickets for any applicable ActCode
			SQLMinTicketCount = "SELECT ActCode, COUNT(*) AS NumSubs FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode INNER JOIN DiscountEvents (NOLOCK) ON Event.EventCode = DiscountEvents.EventCode WHERE Seat.OrderNumber = " & OrderNumber & " AND DiscountEvents.DiscountTypeNumber = " & DiscountTypeNumber & AllowedSeatTypeList & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') GROUP BY Event.ActCode ORDER BY COUNT(*) DESC"
			Set rsMinTicketCount = OBJdbConnection.Execute(SQLMinTicketCount)
			If Not rsMinTicketCount.EOF Then
				rsMinTicketCount.Move(SeriesCount - 1) 'Read ahead one less than the the SeriesCount records.  Check to see if there are SeriesCount different Acts are on order.
				If Not rsMinTicketCount.EOF Then
					NbrSubscriptions = rsMinTicketCount("NumSubs")
					NbrTickets = NbrSubscriptions * SeriesCount
				End If
			End If
			rsMinTicketCount.Close
			Set rsMinTicketCount = nothing
						
			'Get Act Code
			SQLAct = "SELECT ActCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
			Set rsAct = OBJdbConnection.Execute(SQLAct)
			ActCode = rsAct("ActCode")
			rsAct.Close
			Set rsAct = nothing

			'Count # of existing seats which have discount applied for this act
			SQLDiscCount = "SELECT COUNT(*) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ActCode & " AND DiscountTypeNumber = " & DiscountTypeNumber
			Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
			AppliedCount = rsDiscCount("LineCount")
			rsDiscCount.Close
			Set rsDiscCount = nothing

			'Count total # of existing seats which have discount applied 
			SQLTotalCount = "SELECT COUNT(*) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND DiscountTypeNumber = " & DiscountTypeNumber
			Set rsTotalCount = OBJdbConnection.Execute(SQLTotalCount)
			TotalCount = rsTotalCount("LineCount")
			rsTotalCount.Close
			Set rsTotalCount = nothing

			'If the # of discounts at this price for these events < the total possible, discount price
			If AppliedCount < NbrSubscriptions And TotalCount < NbrTickets Then
				Call ProcessDiscount				
			Else
				If AddTicketDisc Then
					Call ProcessDiscount
				End If
			End If
		
			
		End If
		
	End If	

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf


'---------------------------------------------

Sub  ProcessDiscount

	If Clean(Request("Percentage")) <> "" Then
		
		NewPrice = GetRef(roundFunction)(Price * (1-CDbl(Clean(Request("Percentage")))/100))

	ElseIf Clean(Request("FixedPrice")) <> "" Then
		NewPrice = roundUp(CDbl(Clean(Request("FixedPrice"))))
	ElseIf Clean(Request("DiscountAmount")) <> "" Then
		NewPrice = roundUp(Price - roundUp(CDbl(Clean(Request("DiscountAmount")))))
	ElseIf Clean(Request("SeriesPrice"))<> "" Then
		SeriesPrice = roundUp(CDbl(Clean(Request("SeriesPrice"))))
		
		'Count # of applied tickets on this order
		SQLCount = "SELECT COUNT(*) AS AppliedCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND DiscountTypeNumber = " & DiscountTypeNumber
		Set rsCount = OBJdbConnection.Execute(SQLCount)
		TotalAppliedCount = rsCount("AppliedCount")
		rsCount.Close
		Set rsCount = nothing
	
		'MOD function to determine the last ticket to complete the subscription discount (i.e. fourth ticket in the FlexPass-4, or eighth ticket in a FlexPass-8, etc.).  
		Remainder = TotalAppliedCount MOD SeriesCount

		' Calculates the total of all discounted ticket prices already given to figure out the discounted ticket price to be assign to this ticket.
		If Remainder = SeriesCount - 1 Then 
			NewPrice = SeriesPrice - ((SeriesCount - 1) * Round(SeriesPrice / SeriesCount, 2))
		Else
				'Standard rounding on all other tickets.
			NewPrice = Round(SeriesPrice/SeriesCount, 2)
		End If

	End If	
	
	DiscountAmount = Price - NewPrice
	AppliedFlag = "Y"

	'REE 10/15/5 - Added NewSurcharge
	If Request("NewSurcharge") <> "" Then
		Surcharge = NewSurcharge
	ElseIf Request("CalcServiceFee") <> "N" Then
		'JAI - 2/9/5 - Added ItemType to CalcCustomerFee
		Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
	End If

End Sub

'---------------------------------------------

Function roundOut(number)
	decimals = 2
	roundOut = round(number,decimals)
End Function

Function roundUp(number)
	decimals = 0
	roundednumber = round(number,decimals)
	if roundednumber < number then roundednumber = roundednumber + (10^(decimals * -1))
	roundUp = roundednumber
End Function

Function roundDown(number)
	decimals = 0
	roundednumber = round(number,decimals)
	if roundednumber > number then roundednumber = roundednumber - (10^(decimals * -1))
	roundDown = roundednumber
End Function

'---------------------------------------------

%>