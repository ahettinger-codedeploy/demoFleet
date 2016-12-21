
<%

'CHANGE LOG

'JAI 06/07/12  	Tightened application of discount to not allow extra tickets to be discounted.

'SSR 04/13/13  	Updated generic FlexSub discount script to allow additional tickets to be discounted. 
'			Optional parameter:
'			Parameter: &AllowDiscAddTicket=Y
				
'SSR 08/07/14  	Updated generic FlexSub discount script to allow discount pricing by act count
'			Required parameters:
'			1 - SeriesCount
'			2 - Discount
'			Example Discount:		Buy 3 acts get 10% off, Buy 5 acts get 15% off, buy 7 acts get 20% off.
'			Parameters: 		&SeriesCount=3,5,7&Percentage=10,15,20
			
'SSR 12/23/14	Updated FlexSub discount script to calcuate min required number of acts
			
'SSR 05/11/16	Updated script - renamed some of the variables to make it easier to follow the discount logic. 
'			Just in case I dont look at this again for another 2 years, it should now be easier to troubleshoot.

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'-------------------------------------
	
	'Initialize Discount Variables
	
	DIM NbrSubscriptions
	DIM NbrTickets
	DIM ActCode
	DIM AppliedCount
	DIM TotalCount
		
	DIM SeriesCount
	SeriesCount = CInt(fnMinQty)
	
	DIM ActCount
	ActCount = 0

	'Allow discount on additional tickets?
	DIM AllowDiscAddTicket
	AllowDiscAddTicket = FALSE
	
	If Clean(Request("AllowDiscAddTicket")) = "Y" Then
		AllowDiscAddTicket =  TRUE
	End If

'-------------------------------------

If AllowDiscount = "Y" Then 'It's okay to apply to this order.

	'Determine # of acts on the order.
	SQLActCount = "SELECT COUNT(DISTINCT Event.ActCode) AS ActCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode INNER JOIN DiscountEvents (NOLOCK) ON Event.EventCode = DiscountEvents.EventCode WHERE Seat.OrderNumber = " & OrderNumber & " AND DiscountEvents.DiscountTypeNumber = " & DiscountTypeNumber & AllowedSeatTypeList & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent')"
	Set rsActCount = OBJdbConnection.Execute(SQLActCount)
		ActCount = rsActCount("ActCount")
	rsActCount.Close
	Set rsActCount = nothing
	
	If ActCount >= SeriesCount Then
				
		If ActCount > SeriesCount Then
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

	'Percentage Discount
	If Clean(Request("Percentage")) <> "" Then
	
		NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(fnDiscPrice("Percentage"))/100), 2)
		
	'FixedPrice Discount
	ElseIf Clean(Request("FixedPrice")) <> "" Then
	
		NewPrice = round(CDbl(fnDiscPrice("FixedPrice")),2)
	
	'Amount Discount	
	ElseIf Clean(Request("DiscountAmount")) <> "" Then
	
		NewPrice = round(CDbl(Clean(Request("Price"))),2) - round(CDbl(fnDiscPrice("DiscountAmount")),2)
	
	'Series Price
	ElseIf Clean(Request("SeriesPrice")) <> "" Then
	
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
	
	End If

	DiscountAmount = Round(Clean(Request("Price")),2) - NewPrice
		
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

Function fnDiscPrice(DiscType)

	'This function determines the discount amount for multiple act discounts
	'It takes the act count on the current order then matches that against
	'a list of series counts to determine the appropriate discount.
	
	DIM DiscAmount
	DiscAmount = 0

	'List of act counts
	DIM CountList
	CountList = Request.QueryString("SeriesCount")
	
	DIM CountArr 
	CountArr = split(CountList,",")

	'List of discount amounts
	DIM DiscList
	DiscList = Request.QueryString(DiscType)

	DIM DiscArr	
	DiscArr = split(DiscList,",")
	
	'1st column: act count
	DIM CountCol 
	CountCol = 0
	
	'2nd column: discount amount
	DIM DiscCol 
	DiscCol = 1
	
	'Determine size of table
	DIM rowCount 
	rowCount = uBound(CountArr)

	'Resize table with correct row count
	reDIM arrayTble(rowCount) 

	'Populate each row in the table with act count = discount information
	For i = 0 to rowCount
		arrayTble(i) = array(CDbl(CountArr(i)),CDbl(DiscArr(i)))
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
	
	'Loop through the table - match the order act count against list of series counts to determine the correct discount
	For i = 0 To rowCount
		row = arrayTble
		If ActCount >= row(i)(CountCol) Then
			DiscAmount = row(i)(DiscCol)	
		End If
	Next

	fnDiscPrice = DiscAmount
	

End Function

'---------------------------------------------

Function fnMinQty

	'This function finds the min number of acts needed to qualify for the discount

	DIM CountList
	CountList = Request.QueryString("SeriesCount")
	
	DIM CountArr 
	CountArr = split(CountList,",")
	
	DIM minNumber
	
	If instr(CountList,",") <> 0 Then
	
		minNumber = CountArr(0)
		
		For i = 1 to ubound(CountArr)
			If minNumber > CountArr(i) Then
				minNumber = CountArr(i)
			End If
		Next
				
	Else
	
		minNumber = CountList
		
	End If
	
	fnMinQty = minNumber
	
End Function

'---------------------------------------------



%>