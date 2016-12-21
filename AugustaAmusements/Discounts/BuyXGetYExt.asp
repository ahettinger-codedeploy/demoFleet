<%

'CHANGE LOG

'JAI 6/1/12 	- 	New Buy X Get Y discount script.  Combination of Amount, Percentage, and Fixed Price Buy X Get Y discounts.
'					Discount Definition - Required/Optional Parameters
'					Required
'					1) QtyToBuy - The quantity of tickets required at full price in order to receive additional discounted tickets
'					2) QtyDiscounted - The quantity available to receive a discount above QtyToBuy.
'					3) Percentage, DiscountAmount, or FixedPrice - To define the amount to discount
'					Optional
'					4) All fields in DiscountScriptInclude

'JAI 9/5/12 	- 	Removed ErrorLog entries.

'SSR 12/15/14   		'Updated discount with additional parameters to specify which event is discounted:
'					The standard Buy X Get Y discounts tickets to the same event 
'					This update allows Buy X Event Get Y Event discounts
'					This discount is applied only to the Y tickets.

'					Required Parameters:  
'					(1) BuyEventCode - The "X" event code to purchase
'					(2) BuyQty - Number of required "X" tickets
'					(3) GetEventCode - The "Y" event code to discount
'					(4) GetQty - Number of required "Y" tickets
'					
'					Example: For every Season Subscription event ticket purchased get 100% off holiday event ticket 
'					Parameters: BuyEventCode=000000&BuyQty=1&GetEventCode=222222&GetQty=1&Percentage=100 
'					
%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'---------------------------------------------------------

'Initialize Discount Variables

DIM BuyEventList
BuyEventList = Clean(Request("BuyEventCode"))

DIM BuyQty
BuyQty = Clean(Request("BuyQty"))

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

'---------------------------------------------------------

	If AllowDiscount = "Y" Then 'It's okay to apply to this order type and Seat Type.

		'Determine # of Required Tickets on order
		SQLCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType IN ('SubfixedEvent','Seat') INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode IN (" & BuyEventList & ")"
		Set rsCount = OBJdbConnection.Execute(SQLCount)
			NbrTickets = rsCount("LineCount")
		rsCount.Close
		Set rsCount = nothing
		
	
		If cInt(NbrTickets) >= cInt(QtyToBuy) Then 	

			SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType IN ('SubfixedEvent','Seat') INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Event.EventCode IN (" & GetEventList & ") AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber
			Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
				QtyApplied = rsDiscCount("LineCount")
			rsDiscCount.Close
			Set rsDiscCount = nothing

			If fnFindEvent(EventCode,GetEventList) Then
				If Fix(QtyApplied) < (Fix(NbrTickets) * GetQty) Then 'Apply the discount			
					Call ProcessDiscount
				Else
					If AllowDiscAddTicket Then
						Call ProcessDiscount
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
		'Percentage Discount
		NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Clean(Request("Percentage")))/100), 2)
		
	ElseIf Clean(Request("FixedPrice")) <> "" Then
		'FixedPrice Discount
		NewPrice = round(CDbl(Clean(Request("FixedPrice"))),2)
		
	ElseIf Clean(Request("DiscountAmount")) <> "" Then
		'Amount Discount
		NewPrice = round(CDbl(Clean(Request("Price"))),2) - round(CDbl(Clean(Request("DiscountAmount"))),2)
	
	ElseIf Clean(Request("SeriesPrice")) <> "" Then
		'Series Price
		SeriesPrice = round(CDbl(Clean(Request("SeriesPrice"))),2)
		
		'Series Count
		SeriesCount = Clean(Request("Multiple"))
		
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
		
		Call ProcessSurcharge
		
	End If
	
End Sub

'---------------------------------------------

Sub ProcessSurcharge

	'SeriesSurcharge, NewSurcharge, ReCalcSurcharge

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