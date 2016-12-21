
<%

'CHANGE LOG

'JAI 06/07/12 - Tightened application of discount to not allow extra tickets to be discounted.

'SSR 04/13/13 - Updated generic FlexSub discount script to allow additional tickets to be discounted. 
				'Parameter: AllowDiscAddTicket=Y
				
'SSR 07/05/14 - Updated generic FlexSub discount script to allow series surcharge to be passed.

'SSR 12/23/14 - Updated generic FlexSub discount script to allow discount pricing by act count
				'Requires 2 parameters: Series Count and Discounts

'SSR 01/08/16 - Updated to allow additional discount on acts or tickets.

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'---------------------------------------------------------

'Flexible Subscription Discount (Extended)

'Based on the generic flex sub discount script
'Requires 2 parameters: Series Counts and Discounts
'
'Example Discount: 
'Buy 3 acts get 10% off, Buy 5 acts get 15% off, buy 7 acts get 20% off.
'Example Script: FlexSubExt.asp?SeriesCount=3,5,7&Percentage=10,15,20

'By default there is no discount on additonal acts. 
'For example, orders with 4 acts will only have 3 acts discounted

'To grant discount to all 4 acts, add parameter: AllowDiscAddAct
'Example Script: FlexSubExt.asp?SeriesCount=3,5,7&Percentage=10,15,20&AllowAddAct=Y

'By default there is no discount on additonal tickets. 
'For example, order with 4 tickets (2 tickets Act A, 1 ticket Act B, 1 ticket Act C) will only have 3 tickets discounts

'To grant discount to all 4 acts, add parameter: AllowDiscAddAct
'Example Script: FlexSubExt.asp?SeriesCount=3,5,7&Percentage=10,15,20&AllowAddAct=Y


'-------------------------------------
	
	'Initialize Variables
	
	DIM varIndex
	'Get the price tier index item
	varIndex = "SeriesCount"
	
	DIM SeriesCount
	SeriesCount = CInt(fnMinQty)
	
	DIM ActCount
	ActCount = 0
	
	'Allows discount on additional acts

	DIM AllowDiscAddAct
	AllowDiscAddAct = FALSE
	
	If Clean(Request("AllowDiscAddAct")) = "Y" Then
		AllowDiscAddAct =  TRUE
	End If


	'Allows discount on additional tickets

	DIM AllowDiscAddTicket
	AllowDiscAddTicket  = FALSE
	
	If Clean(Request("AllowDiscAddTicket")) = "Y" Then
		AllowDiscAddTicket =  TRUE
	End If

'-------------------------------------


If AllowDiscount = "Y" Then 'It's okay to apply to this order.

	'Determine # of acts on the order.
	SQLActCount = "SELECT COUNT(DISTINCT Event.ActCode) AS ActCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode INNER JOIN DiscountEvents (NOLOCK) ON Event.EventCode = DiscountEvents.EventCode WHERE Seat.OrderNumber = " & OrderNumber & " AND OrderLine.SeatTypeCode = " & Clean(Request("SeatTypeCode")) & " AND DiscountEvents.DiscountTypeNumber = " & DiscountTypeNumber & AllowedSeatTypeList & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent')"
	Set rsActCount = OBJdbConnection.Execute(SQLActCount)
		ActCount = rsActCount("ActCount")
	rsActCount.Close
	Set rsActCount = nothing
	
	
	If ActCount >= SeriesCount Then
	
		If ActCount >= 5 Then
			SeriesCount = ActCount
		End If

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
	
End Sub

'---------------------------------------------

Function fnDiscPrice(varDisc)

	'Function used to determine the discount amount when there are multiple price tiers
	'Requires  an index:  ActCount=2,3,5
	'Requires discounts:  Percentage=10,15

	DIM IndexCount
	IndexCount = ActCount

	DIM IndexList
	IndexList = Request.QueryString(varIndex)

	DIM DiscList
	DiscList = Request.QueryString(varDisc)
	
	DIM DiscAmount
	DiscAmount = 0


	'List of required quantities
	DIM IndexArr 
	IndexArr = split(IndexList,",")
	
	'List of discount amounts
	DIM DiscArr	
	DiscArr = split(DiscList,",")
	
	'1st column: quantity
	DIM IndexCol 
	IndexCol = 0
	
	'2nd column: discount
	DIM DiscCol 
	DiscCol = 1
	
	'Determine size of table
	DIM rowCount 
	rowCount = uBound(IndexArr)

	'Resize table with correct row count
	reDIM arrayTble(rowCount) 

	'Populate each row in the table with quantity = discount information
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
	
	'Loop through the table - match the index quantity to determine the correct discount
	For i = 0 To rowCount
		row = arrayTble
		If IndexCount >= row(i)(IndexCol) Then
			DiscAmount = row(i)(DiscCol)	
		End If
	Next

	fnDiscPrice = DiscAmount
	

End Function

'---------------------------------------------

Function fnMinQty

	DIM IndexList
	IndexList = Request.QueryString(varIndex)

	DIM IndexArr 
	IndexArr = split(IndexList,",")
	
	DIM minNumber
	
	If instr(IndexList,",") <> 0 Then
	
		minNumber = IndexArr(0)

		For i = 1 to ubound(IndexArr)
			If minNumber > IndexArr(i) Then
				minNumber = IndexArr(i)
			End If
		Next
				
	Else
	
		minNumber = IndexList
		
	End If
	
	fnMinQty = minNumber
	
End Function

'---------------------------------------------



%>