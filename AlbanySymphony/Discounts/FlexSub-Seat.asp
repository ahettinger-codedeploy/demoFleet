<%

'CHANGE LOG
'CHANGE LOG
'JAI 06/07/12 - Tightened application of discount to not allow extra tickets to be discounted.
'SSR 04/13/13 - Updated generic FlexSub discount script to allow additional tickets to be discounted. 
				'Parameter: AllowDiscAddTicket=Y
'SSR 07/05/14 - Updated generic FlexSub discount script to allow series surcharge to be passed.
'SSR 08/22/14 - Updated generic FlexSub discount script to allow discount pricing by ticket type
				'Example: DiscountAmount=1,2,2&AllowedSeatTypeCode=1,23,1314
				'Example: FixedPrice=20,15,15&AllowedSeatTypeCode=1,23,1314

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%
	
'-------------------------------------

	SeriesCount = CInt(CleanNumeric(Request("SeriesCount"))) 'Number of Productions in the Subscription

	NbrSubscriptions = 0
	NbrTickets = 0

'-------------------------------------

	'Initialize Series Discount
	DIM SeriesDiscount
	
	'Allow discount on additional acts
	DIM AllowDiscAddAct

	'Allow discount on additional tickets
	DIM AllowDiscAddTicket
	AllowDiscAddTicket  = FALSE
	
	If Clean(Request("AllowDiscAddTicket")) = "Y" Then
		AllowDiscAddTicket =  TRUE
	End If
	
	'Require ticket types to be the same type
	DIM AllowSameTicketType
	If Clean(Request("AllowSameTicketType")) = "Y" Then
		AllowSameTicketType =  "AND OrderLine.SeatTypeCode = " & SeatTypeCode & ""
	End If
	

'-------------------------------------


If AllowDiscount = "Y" Then 'It's okay to apply to this order.

	'Count # of applicable Acts on the order.
	SQLActCount = "SELECT COUNT(DISTINCT Event.ActCode) AS ActCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode INNER JOIN DiscountEvents (NOLOCK) ON Event.EventCode = DiscountEvents.EventCode WHERE Seat.OrderNumber = " & OrderNumber & AllowSameTicketType & " AND DiscountEvents.DiscountTypeNumber = " & DiscountTypeNumber & AllowedSeatTypeList & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent')"
	Set rsActCount = OBJdbConnection.Execute(SQLActCount)
	ActCount = rsActCount("ActCount")
	rsActCount.Close
	Set rsActCount = nothing

	If ActCount >= SeriesCount Then

		'Get the fewest number of tickets for any applicable ActCode
		SQLMinTicketCount = "SELECT ActCode, COUNT(*) AS NumSubs FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode INNER JOIN DiscountEvents (NOLOCK) ON Event.EventCode = DiscountEvents.EventCode WHERE Seat.OrderNumber = " & OrderNumber & AllowSameTicketType & " AND DiscountEvents.DiscountTypeNumber = " & DiscountTypeNumber & AllowedSeatTypeList & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') GROUP BY Event.ActCode ORDER BY COUNT(*) DESC"
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
		If AppliedCount < NbrSubscriptions & AllowDiscAddAct  Then
			
			If AppliedCount < NbrSubscriptions Then
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
	
End If	

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

'---------------------------------------------

Sub ProcessDiscount

	If Clean(Request("Percentage")) <> "" Then
		NewPrice = round(Price * (1-CDbl(getSeatPricing("Percentage"))/100), 2)
	ElseIf Clean(Request("FixedPrice")) <> "" Then
		NewPrice = Round(CDbl(getSeatPricing("FixedPrice")),2)
	ElseIf Clean(Request("DiscountAmount")) <> "" Then
		NewPrice = Price - Round(CDbl(getSeatPricing("DiscountAmount")),2)
	ElseIf Clean(Request("SeriesPrice"))<> "" Then
		SeriesPrice = Round(CDbl(getSeatPricing("SeriesPrice")),2)
		
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

PUBLIC FUNCTION getSeatPricing(strDiscType)

	SeriesDiscount = Request.QueryString(strDiscType)
	
	DIM strSeatList
	strSeatList  = trimComma(AllowedSeatTypeCode)
	
	DIM strDiscList
	strDiscList = SeriesDiscount
	
	DIM strDiscount
	
	If instr(strSeatList,",") <> 0 AND instr(strDiscList,",") <> 0 Then
	
		DIM SeatArr
		SeatArr = split(strSeatList,",")
		
		DIM DiscArr
		DiscArr = split(strDiscList,",")
		
		DIM SeatCol
		SeatCol = 0
		
		DIM DiscCol
		DiscCol = 1

		reDIM arrNodes(1,uBound(SeatArr))
		
		For i = 0 to ubound(SeatArr)
			arrNodes(SeatCol,i) = SeatArr(i)
			arrNodes(DiscCol,i) = DiscArr(i)
		Next

		Call SortArry(arrNodes,1)
	
		For i = 0 to UBound(arrNodes,2)
			If SeatTypeCode = arrNodes(SeatCol,i) Then
				strDiscount = arrNodes(DiscCol,i)
			End If
		Next
		
	Else
	
		strDiscount = strDiscList
	
	End If
	
	getSeatPricing = strDiscount
	
END FUNCTION

'---------------------------------------------

PUBLIC FUNCTION SortArry(byRef arrNodes,sortBy)

	'This function takes a 2 dimensional array and returns it sorted from highest to lowest

	DIM c, d, e, smallestValue, smallestIndex, tempValue
	
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

END FUNCTION

'---------------------------------------------

PUBLIC FUNCTION trimComma(strText)

	'This function trims any commas from the start and end of the string submitted

	If Right(strText, 1) = "," Then
	strText = Left(strText, Len(strText) - 1)  
	End If

	If Left(strText, 1) = "," Then 
	strText = Right(strText, Len(strText) - 1)  
	End If

	trimComma = strText

END FUNCTION 

'---------------------------------------------

%>