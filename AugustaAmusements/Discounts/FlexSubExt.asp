
<%

'CHANGE LOG

'JAI 06/07/12  	Tightened application of discount to not allow extra tickets to be discounted.

'SSR 04/13/13  	Generic FlexSub discount does not have option to allow additional tickets to be discounted. 
'			Updated to allow that with an optional parameter.
'			Parameter: &AllowDiscAddTicket=Y
				
'SSR 12/23/14  	Updated generic FlexSub discount script to allow discount pricing by act count
			'Example Discount:	Buy 3 acts get 10% off, Buy 5 acts get 15% off, buy 7 acts get 20% off.
			'Parameters: 		&SeriesCount=3,5,7&Percentage=10,15,20
			
'SSR 05/20/16	Updated script to allow bonus acts. These acts are not added to the series count to qualify for a subscription discount.
'			Once there is a valid subscription on the order, they receive the same discount as the subscription
			'Parameters: 		&BonusActs=127719,128217

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'-------------------------------------

DIM BuyEventList
BuyEventList = Clean(Request("BuyEventCode"))

DIM BuyQty
If Clean(Request("BuyQty")) <> "" Then
	BuyQty = Clean(Request("BuyQty"))
Else
	BuyQty = 1
End If

DIM GetEventList
GetEventList = Clean(Request("GetEventCode"))

DIM GetQty
GetQty = Clean(Request("GetQty"))

DIM BuyCount 
DIM GetCount

'Allow discount on additional tickets?
DIM AllowDiscAddTicket
AllowDiscAddTicket  = FALSE

If Clean(Request("AllowDiscAddTicket")) = "Y" Then
	AllowDiscAddTicket =  TRUE
End If

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
	
	'Bonus Acts
	DIM BonusActs
	DIM SQLBonus
	DIM AllowDiscBonusTicket
	
	If Clean(Request("BonusActs")) <> "" Then
		BonusActs = Clean(Request("BonusActs"))
		SQLBonus = "AND Event.ActCode NOT IN (" & BonusActs & ")"
		AllowDiscBonusTicket =  TRUE
	Else
		AllowDiscBonusTicket =  FALSE
	End If


'-------------------------------------

If AllowDiscount = "Y" Then 'It's okay to apply to this order.


	'Determine # of Fixed Subs on Order
	SQLCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType IN ('SubfixedEvent') INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode IN (" & BuyEventList & ")"
	Set rsCount = OBJdbConnection.Execute(SQLCount)
		NbrTickets = rsCount("LineCount")
	rsCount.Close
	Set rsCount = nothing

	If cInt(NbrTickets) >= cInt(BuyQty) Then 
	
		'ErrorLog("NbrTickets: " & NbrTickets & " BuyQty: " & BuyQty & "")

		SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType IN ('Seat') INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode IN (" & GetEventList & ") AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber
		Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
			QtyApplied = rsDiscCount("LineCount")
		rsDiscCount.Close
		Set rsDiscCount = nothing
		
		'ErrorLog("EventCode: " & EventCode & " GetEventList: " & GetEventList & "")
		
		'ErrorLog("QtyApplied: " & QtyApplied & " NbrTickets: " & NbrTickets & "GetQty: " & GetQty & "")

		If fnFindEvent(EventCode,GetEventList) Then
		
			'ErrorLog("EventFound!")
		
			If Fix(QtyApplied) < (Fix(NbrTickets) * GetQty) Then 'Apply the discount

				ErrorLog("ProcessDiscount")	
				
				Call ProcessAddDiscount
			Else
				If AllowDiscAddTicket Then
					Call ProcessAddDiscount
				End If
			End If
		'Else
		
		'ErrorLog("Event NOT Found!")
		
		End If

	Else
	
		'Determine # of acts on the order.
		SQLActCount = "SELECT COUNT(DISTINCT Event.ActCode) AS ActCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode INNER JOIN DiscountEvents (NOLOCK) ON Event.EventCode = DiscountEvents.EventCode WHERE Seat.OrderNumber = " & OrderNumber & " AND DiscountEvents.DiscountTypeNumber = " & DiscountTypeNumber & AllowedSeatTypeList & SQLBonus & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent')"
		Set rsActCount = OBJdbConnection.Execute(SQLActCount)
			ActCount = rsActCount("ActCount")
		rsActCount.Close
		Set rsActCount = nothing

		If ActCount >= SeriesCount Then
		
			If ActCount > SeriesCount Then
				SeriesCount = ActCount
			End If
		
			'Get the fewest number of tickets for any applicable ActCode
			SQLMinTicketCount = "SELECT ActCode, COUNT(*) AS NumSubs FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode INNER JOIN DiscountEvents (NOLOCK) ON Event.EventCode = DiscountEvents.EventCode WHERE Seat.OrderNumber = " & OrderNumber & " AND DiscountEvents.DiscountTypeNumber = " & DiscountTypeNumber & AllowedSeatTypeList & SQLBonus  & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') GROUP BY Event.ActCode ORDER BY COUNT(*) DESC"
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
			SQLDiscCount = "SELECT COUNT(*) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND ActCode = " & ActCode & " AND DiscountTypeNumber = " & DiscountTypeNumber & SQLBonus & ""
			Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
				AppliedCount = rsDiscCount("LineCount")
			rsDiscCount.Close
			Set rsDiscCount = nothing

			'Count total # of existing seats which have discount applied 
			SQLTotalCount = "SELECT COUNT(*) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND DiscountTypeNumber = " & DiscountTypeNumber & SQLBonus & ""
			Set rsTotalCount = OBJdbConnection.Execute(SQLTotalCount)
				TotalCount = rsTotalCount("LineCount")
			rsTotalCount.Close
			Set rsTotalCount = nothing

			'If the # of discounts at this price for these events < the total possible, discount price
			If NOT fnFindAct(ActCode,BonusActs) Then
			
				If AppliedCount < NbrSubscriptions And TotalCount < NbrTickets Then
					Call ProcessDiscount			
				End If
			Else
						
				If AllowDiscBonusTicket Then
					If fnFindAct(ActCode,BonusActs) Then
						'ErrorLog("Bonus Act: " & ActCode & " found")
						Call ProcessDiscount
					Else
						'ErrorLog("Bonus Act: " & ActCode & " not found")
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

'---------------------------------------------

Sub ProcessDiscount

	'ErrorLog("Process Discount")
	
	'ErrorLog("Process Discount")

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
	
	If Request("NewSurcharge") <> "" Then
		Surcharge = NewSurcharge
	ElseIf Request("CalcServiceFee") <> "N" Then
		Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
	End If

End Sub

'---------------------------------------------

Sub ProcessAddDiscount

	If Clean(Request("AddPercentage")) <> "" Then
		'Percentage Discount
		NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Clean(Request("AddPercentage")))/100), 2)
		
	Else
	
		NewPrice = round(CDbl(Clean(Request("Price"))))
	
	End If
	

	If NewPrice < Price Then
	
		If NewPrice < 0 Then
			NewPrice = 0
		End If
		
		DiscountAmount = Round(Clean(Request("Price")),2) - NewPrice
			
		AppliedFlag = "Y"
		
		If Request("NewSurcharge") <> "" Then
			Surcharge = NewSurcharge
		ElseIf Request("CalcServiceFee") <> "N" Then
			Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
		End If
		
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
					
			If int(minNumber) > int(CountArr(i)) Then
			
				'ErrorLog("minNumber: " & minNumber & " is greater than Count " & CountArr(i) & "")
				
				int(minNumber) = int(CountArr(i))
			Else
			
				'ErrorLog("minNumber: " & minNumber & " is not greater than Count " & CountArr(i) & "")
			
			End If
		Next
				
	Else
	
		minNumber = CountList
		
	End If
	
	fnMinQty = minNumber
	
End Function

'---------------------------------------------------------

Public Function fnFindAct(strAct,strActList)

	'this function requires the current actcode and a list of series actcodes.
	'it looks for the current actcode in that list and answers with a Boolean value.

	fnFindAct = FALSE

	arrActs = Split(strActList,",")

	For i=0 To Ubound(arrActs)
		If Trim(arrActs(i)) = Trim(strAct) Then
			fnFindAct = TRUE
			Exit Function      
		End If 
	Next

End Function

'---------------------------------------------------------

Public Function fnFindEvent(EventCode,GetEventList)

	'this function requires the current actcode and a list of series actcodes.
	'it looks for the current actcode in that list and answers with a Boolean value.

	fnFindEvent = FALSE

	arrEvents = Split(GetEventList,",")

	For i=0 To Ubound(arrEvents)
		If int(arrEvents(i)) = int(EventCode) Then
			fnFindEvent = TRUE
			Exit Function      
		End If 
	Next

End Function

'---------------------------------------------------------



%>