<%

'CHANGE LOG
'JAI 06/07/12 - Tightened application of discount to not allow extra tickets to be discounted.
'SSR 04/13/13 - Updated generic FlexSub discount script to allow additional tickets to be discounted. 
				'Parameter: AllowDiscAddTicket=Y
'SSR 07/05/14 - Updated generic FlexSub discount script to allow series surcharge to be passed.
'SSR 08/07/14 - Updated generic FlexSub discount script to allow discount pricing by actcount
				'Parameter: SeriesCount=8,7,6,5,4&FixedPrice=15,16,17,18,20
 
%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'--------------------------------------------------------

	'Initialize Variables


	DIM MinSeriesCount
	DIM SeriesCount
	DIM FixedPrice
	DIM SeriesDiscount

	NbrSubscriptions = 0
	NbrTickets = 0

'--------------------------------------------------------

	'Extended Discount Option
	'Allows discount on additional tickets

	If Clean(Request("AllowDiscAddTicket")) = "Y" Then
		AllowDiscAddTicket =  TRUE
	Else
		AllowDiscAddTicket  = FALSE
	End If

'--------------------------------------------------------

	If AllowDiscount = "Y" Then 'It's okay to apply to this order.

		'Count # of applicable Acts on the order.
		SQLActCount = "SELECT COUNT(DISTINCT Event.ActCode) AS ActCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode INNER JOIN DiscountEvents (NOLOCK) ON Event.EventCode = DiscountEvents.EventCode WHERE Seat.OrderNumber = " & OrderNumber & " AND DiscountEvents.DiscountTypeNumber = " & DiscountTypeNumber & AllowedSeatTypeList & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent')"
		Set rsActCount = OBJdbConnection.Execute(SQLActCount)
		ActCount = rsActCount("ActCount")
		rsActCount.Close
		Set rsActCount = nothing
		
		Call ProcessSeriesCount
				
		If ActCount >= MinSeriesCount Then

			'Get the fewest number of tickets for any applicable ActCode
			SQLMinTicketCount = "SELECT ActCode, COUNT(*) AS NumSubs FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode INNER JOIN DiscountEvents (NOLOCK) ON Event.EventCode = DiscountEvents.EventCode WHERE Seat.OrderNumber = " & OrderNumber & " AND DiscountEvents.DiscountTypeNumber = " & DiscountTypeNumber & AllowedSeatTypeList & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') GROUP BY Event.ActCode ORDER BY COUNT(*) DESC"
			Set rsMinTicketCount = OBJdbConnection.Execute(SQLMinTicketCount)
			If Not rsMinTicketCount.EOF Then
				rsMinTicketCount.Move(ActCount - 1) 'Read ahead one less than the the SeriesCount records.  Check to see if there are SeriesCount different Acts are on order.
				If Not rsMinTicketCount.EOF Then
					NbrSubscriptions = rsMinTicketCount("NumSubs")
					NbrTickets = NbrSubscriptions * ActCount
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
				Call ProcessSurcharge				
			Else
				If AllowDiscAddTicket Then
					Call ProcessDiscount
					Call ProcessSurcharge
				End If
			End If
			
						
		End If
		
	End If	

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

'---------------------------------------------

Sub ProcessSeriesCount

Dim SeriesArr
Dim DiscArr

SeriesCount = Request.QueryString("SeriesCount")
SeriesDiscount = Request.QueryString("FixedPrice")

SeriesArr = split(SeriesCount,",")
DiscArr = split(SeriesDiscount,",")

reDim arrNodes(1,uBound(SeriesArr))

for i = lBound(SeriesArr) to uBound(SeriesArr)
	arrNodes(0,i) = SeriesArr(i)
	arrNodes(1,i) = DiscArr(i)
next

call SortArry(arrNodes,1)

i = 0
If CInt(ActCount) >= CInt(arrNodes(0,i)) Then
	SeriesDiscount = CInt(arrNodes(1,i))
End If


For i = 1 to UBound(arrNodes,2)
	If CInt(ActCount) = CInt(arrNodes(0,i)) Then
		SeriesDiscount = CInt(arrNodes(1,i))
	End If
Next

lineNbr = uBound(arrNodes,2)

MinSeriesCount = CInt(arrNodes(0,lineNbr))

End Sub

'---------------------------------------------

Sub  ProcessDiscount


	If Request.QueryString("FixedPrice") <> "" Then
		ErrorLog("FixedPriceFound")
	End If

	If Clean(Request("Percentage")) <> "" Then
		NewPrice = round(Price * (1-CDbl(Clean(Request("Percentage")))/100), 2)
	ElseIf SeriesDiscount <> ""
		If NewPrice > SeriesDiscount Then
			NewPrice = Round(CDbl(SeriesDiscount),2)
		End If
	ElseIf Clean(Request("DiscountAmount")) <> "" Then
		NewPrice = Price - Round(CDbl(Clean(Request("DiscountAmount"))),2)
	ElseIf Clean(Request("SeriesPrice"))<> "" Then
		SeriesPrice = Clean(Request("SeriesPrice"))
		
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
	
End Sub
	
'---------------------------------------------

Sub ProcessSurcharge

ErrorLog("ProcessSurcharge")

	'SeriesSurcharge, NewSurcharge, CalcServiceFee

	If Clean(Request("SeriesSurcharge")) <> "" Then
	
		SeriesSurcharge = Round(CDbl(Clean(Request("SeriesSurcharge"))),2)
		
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
			Surcharge = SeriesSurcharge - ((SeriesCount - 1) * Round(SeriesSurcharge / SeriesCount, 2))
		Else
			'Standard rounding on all other tickets.
			Surcharge = Round(SeriesSurcharge/SeriesCount, 2)
		End If

	ElseIf Request("NewSurcharge") <> "" Then
		Surcharge = Request("NewSurcharge")
	ElseIf Request("CalcServiceFee") <> "N" Then
		Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
	End If

End Sub

'---------------------------------------------

Sub SortArry(byRef arrNodes,sortBy)

	Dim c, d, e, smallestValue, smallestIndex, tempValue
	For c = 0 To uBound( arrNodes, 2 ) - 1	
		smallestValue = CLNG( "0" & arrNodes( sortBy, c ))
		smallestIndex = c
		For d = c + 1 To uBound( arrNodes, 2 )
			if CLNG("0" & arrNodes( sortBy, d )) < smallestValue   Then
				smallestValue = CLNG( "0" & arrNodes( sortBy, d ))
				smallestIndex = d
			End if
		Next
		if smallestIndex <> c Then 'swap
			For e = 0 To uBound( arrNodes, 1 )
				tempValue = arrNodes( e, smallestIndex )
				arrNodes( e, smallestIndex ) = arrNodes( e, c )
				arrNodes( e, c ) = tempValue 
			Next
		End if
	Next

End Sub

'---------------------------------------------



%>