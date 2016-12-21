
<%

'CHANGE LOG

'JAI 06/07/12 - Tightened application of discount to not allow extra tickets to be discounted.

'SSR 04/13/13 - Updated generic FlexSub discount script to allow additional tickets to be discounted. 
				'Parameter: AllowDiscAddTicket=Y
				
'SSR 07/05/14 - Updated generic FlexSub discount script to allow series surcharge to be passed.

'SSR 12/23/14 - Updated generic FlexSub discount script to allow discount pricing by act count
				'Requires 2 parameters:
				'1 - ActCount - Example: &ActCount=2,4,6
				'2 - Discount - Example: &Percentage=10,15,20
				
'SSR 01/02/15 - Updated generic FlexSub discount script to calculate min series count.

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'---------------------------------------------------------
	
	'Initialize Variables
	
	DIM varIndex
	'Get the price tier index item
	varIndex = "SeriesCount"
	
	'Number of productions required for discount
	DIM SeriesCount
	SeriesCount = 0
	
	'Number of productions in the order
	DIM ActCount
	ActCount = 0
	
'-------------------------------------

	'Option to allow discounting on additional tickets

	DIM AllowDiscAddTicket
	AllowDiscAddTicket  = FALSE
	
	If Clean(Request("AllowDiscAddTicket")) = "Y" Then
		AllowDiscAddTicket =  TRUE
	End If
	
'-------------------------------------

If AllowDiscount = "Y" Then 'It's okay to apply to this order.

	'Determine number of productions in the order.
	SQLActCount = "SELECT COUNT(DISTINCT Event.ActCode) AS ActCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode INNER JOIN DiscountEvents (NOLOCK) ON Event.EventCode = DiscountEvents.EventCode WHERE Seat.OrderNumber = " & OrderNumber & " AND OrderLine.SeatTypeCode = " & Clean(Request("SeatTypeCode")) & " AND DiscountEvents.DiscountTypeNumber = " & DiscountTypeNumber & AllowedSeatTypeList & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent')"
	Set rsActCount = OBJdbConnection.Execute(SQLActCount)
		ActCount = rsActCount("ActCount")
	rsActCount.Close
	Set rsActCount = nothing
	
	'Determine number of productions required for discount
	SeriesCount = CInt(fnMinAct())
	
	'Determine if order qualifies for a discount
	If ActCount >= SeriesCount Then
		
		'Determine the number of possible subscriptions in the order
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
		
		'Get the production code
		SQLAct = "SELECT ActCode FROM Event (NOLOCK) WHERE EventCode = " & EventCode
		Set rsAct = OBJdbConnection.Execute(SQLAct)
		ActCode = rsAct("ActCode")
		rsAct.Close
		Set rsAct = nothing

		'Count number of discounts for the production which have been applied on this order
		SQLDiscCount = "SELECT COUNT(*) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ActCode & " AND DiscountTypeNumber = " & DiscountTypeNumber
		Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
		AppliedCount = rsDiscCount("LineCount")
		rsDiscCount.Close
		Set rsDiscCount = nothing

		'Count number of discounts which have been applied on this order 
		SQLTotalCount = "SELECT COUNT(*) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND DiscountTypeNumber = " & DiscountTypeNumber
		Set rsTotalCount = OBJdbConnection.Execute(SQLTotalCount)
		TotalCount = rsTotalCount("LineCount")
		rsTotalCount.Close
		Set rsTotalCount = nothing

		'If the number of applied discounts per production is less than number of possible subscriptions
		'And the number of applied discounts is less then the number of possible discounts, 
		'Go ahead and apply the discount
		If AppliedCount < NbrSubscriptions And TotalCount < NbrTickets Then
			Call ProcessDiscount			
		Else
			If AllowDiscAddTicket Then
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

Sub ProcessDiscount

	If Clean(Request("Percentage")) <> "" Then
		'Percentage Discount
		NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(fnDiscPrice("Percentage"))/100), 2)
		
	ElseIf Clean(Request("FixedPrice")) <> "" Then
		'FixedPrice Discount
		NewPrice = round(CDbl(fnDiscPrice("FixedPrice")),2)
		
	ElseIf Clean(Request("DiscountAmount")) <> "" Then
		'Amount Discount
		NewPrice = round(CDbl(Clean(Request("Price"))),2) - round(CDbl(fnDiscPrice("DiscountAmount")),2)
	
	ElseIf Clean(Request("SeriesPrice")) <> "" Then
		'Series Price
		SeriesPrice = round(CDbl(fnDiscPrice("SeriesPrice")),2)
		
		'Series Count
		SeriesCount = ActCount
		
		'Count # of applied tickets on this order
		SQLCount = "SELECT COUNT(*) AS AppliedCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND DiscountTypeNumber = " & DiscountTypeNumber
		Set rsCount = OBJdbConnection.Execute(SQLCount)
			TotalAppliedCount = rsCount("AppliedCount")
		rsCount.Close
		Set rsCount = nothing
	
		'MOD function to determine the last ticket to complete the subscription discount (i.e. fourth ticket in the FlexPass-4, or eighth ticket in a FlexPass-8, etc.).  
		Remainder = TotalAppliedCount MOD SeriesCount

		'Calculates the total of all discounted ticket prices already given to figure out the discounted ticket price to be assign to this ticket.
		If Remainder = SeriesCount - 1 Then 
			NewPrice = SeriesPrice - ((SeriesCount - 1) * Round(SeriesPrice / SeriesCount, 2))
		Else
		'Standard rounding on all other tickets.
			NewPrice = Round(SeriesPrice/SeriesCount, 2)
		End If

	Else
	
		NewPrice = round(CDbl(Clean(Request("Price"))))
	
	End If
		
	If NewPrice < Price Then
	
		If NewPrice < 0 Then
			NewPrice = 0
		End If
		
		DiscountAmount = Round(Clean(Request("Price")),2) - NewPrice
		
		AppliedFlag = "Y"
		
	End If
	
	Call ProcessSurcharge
	
End Sub

'---------------------------------------------

Sub ProcessSurcharge

	'SeriesSurcharge, NewSurcharge, ReCalcSurcharge
	
	If AppliedFlag = "Y" Then

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
		
		
	End If

End Sub

'---------------------------------------------

Function fnMinAct()

	'Function takes the two provided parameters:
	'varIndex and ActCount
	'and determines the min required number of acts

	DIM IndexList
	IndexList = Request.QueryString(varIndex)
		
	DIM IndexArr 
	IndexArr = split(IndexList,",")
		
	DIM minNumber
	minNumber = IndexArr(0)
		
	For i = lbound(IndexArr) to ubound(IndexArr)		
		If ActCount >= IndexArr(i) Then
			minNumber = IndexArr(i)
		End If
	Next
			
	fnMinAct = minNumber
	
End Function

'---------------------------------------------

Function fnDiscPrice(varDisc)

	'Function takes the three provided parameters:
	'ActCount, varIndex, varDisc
	'and builds a discount matrix table
	
	' Series | Disc 
	' Count	 | Amount
	'------- |---------
	'  2	 |	10%
	'  4	 |	15%
	'  6	 |	20%
	

	'Ticket Count
	DIM IndexCount
	IndexCount = ActCount

	'Get the list of ticket counts
	DIM IndexList
	IndexList = Request.QueryString(varIndex)

	'Get the list of discount amounts
	DIM DiscList
	DiscList = Request.QueryString(varDisc)
	
	'Initialize discount amount
	DIM DiscAmount
	DiscAmount = 0

	'Create array of ticket counts
	DIM IndexArr 
	IndexArr = split(IndexList,",")
	
	'Create array of discount amounts
	DIM DiscArr	
	DiscArr = split(DiscList,",")
	
	'Create 1st column: Ticket Count
	DIM IndexCol 
	IndexCol = 0
	
	'Create 2nd column: Discount Amount
	DIM DiscCol 
	DiscCol = 1
	
	'Determine size of table
	DIM rowCount 
	rowCount = uBound(IndexArr)

	'Create table with correct number of rows
	reDIM arrayTble(rowCount) 

	'Populate each row in the table with ticket count = discount amount information
	For i = 0 to rowCount
		arrayTble(i) = array(CDbl(IndexArr(i)),CDbl(DiscArr(i)))
	Next
	
	'Sort the rows in the table from lowest to highest
	For col1 = UBound(arrayTble) - 1 To 0 Step -1
		For col2 = 0 To col1
			If arrayTble(col2)(0) > arrayTble(col2+1)(0) Then
				swap = arrayTble(col2)
				arrayTble(col2) = arrayTble(col2+1)
				arrayTble(col2+1) = swap
			End If
		Next
	Next
	
	'Loop through the table - match the index to the current index count and determine the correct discount amount
	For i = 0 To rowCount
		row = arrayTble
		If IndexCount >= row(i)(IndexCol) Then
			DiscAmount = row(i)(DiscCol)	
		End If
	Next

	fnDiscPrice = DiscAmount
	

End Function

'---------------------------------------------




%>