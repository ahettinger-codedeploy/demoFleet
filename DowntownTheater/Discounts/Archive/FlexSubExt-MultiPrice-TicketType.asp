<%

'CHANGE LOG
'JAI 06/07/12 - Tightened application of discount to not allow extra tickets to be discounted.

'SSR 04/13/13 - Updated FlexSub discount script to allow additional tickets to be discounted. 
				'Renamed script FlexSubExt to identify this same script with extended functionality
				'Parameter: &AddTicketDisc=Y
				
'SSR 05/05/13 - 'Updated FlexSubExt discount script
				'Added option to round price down to the nearest dollar. 
				'Parameter: &roundFunction=roundDown
				'Added option to round price up to the nearest dollar. 
				'Parameter: &roundFunction=roundUp
				
'SSR 08/22/14 - 'Updated FlexSubExt discount script
				'Added option to pass different discount pricing by ticket type
				'DiscountType and SeatType both must be in the same order
				'Parameter: [DiscountType]=X,X&AllowedSeatTypeCode=X,X
				'Example: DiscountAmount=1,2,2&AllowedSeatTypeCode=1,23,1314
				'Example: FixedPrice=20,15,15&AllowedSeatTypeCode=1,23,1314
				
'SSR 10/01/14 - 'Updated FlextSubExt discount script
				'Added option to pass a new delivery surcharge
				'Parameter: &NewShipFee=X
				'Removed the AllowedSeatTypeList variable. It's available in the discount include script

'SSR 05/01/15 - 'Updated FlexSubExt discount script with 2 parameters:
				'Added new option to require that all tickets are of the same seat type code
				'Parameter: &SameSeatType=Y
				'Added new option to require that all tickets belong to the same price tier (color)
				'Parameter: &SamePriceTier=Y
				
				
%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%
	
'-------------------------------------

	'Initialize Variables
	DIM SeriesCount
	SeriesCount = CInt(CleanNumeric(Request("SeriesCount"))) 'Number of Productions in the Subscription
	
	DIM SeriesDiscount
	SeriesDiscount = 0
	
	DIM NbrSubscriptions
	NbrSubscriptions = 0
	
	DIM NbrTickets
	NbrTickets = 0

'-------------------------------------
	'Allow discount on additional tickets
	'Default setting is false

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
	

'-------------------------------------
	'Require that all tickets belong to the same ticket type
	'Default setting is true
	
	DIM SameSeatType
	SameSeatType = TRUE
		
	If Clean(Request("SameSeatType")) <> "" Then
	
		If Clean(Request("SameSeatType")) = "Y" Then
			SameSeatType = TRUE
		End If
		
		If Clean(Request("SameSeatType")) = "N" Then
			SameSeatType = FALSE
		End If
		
	End If
		
'-------------------------------------
	'Require that all tickets belong to the same price tier 
	'Price tier is determined by section color
	'Default setting is true
	
	DIM SamePriceTier
	SamePriceTier = TRUE
	
	DIM Color
	Color = ""
	
	 'Get the price tier (aka color) for this section 
	SQLColor = "SELECT Color FROM Section(NOLOCK) WHERE EventCode = " & EventCode & " AND SectionCode = '" & SectionCode & "'"
	Set rsColor = OBJdbConnection.Execute(SQLColor)	
	Color = UCase(rsColor("Color"))	
	rsColor.Close
	Set rsColor = nothing

	If Clean(Request("SamePriceTier")) <> "" Then
	
		If Clean(Request("SamePriceTier")) = "Y" Then
			SamePriceTier = TRUE
		End If
		
		If Clean(Request("SamePriceTier")) = "N" Then
			SamePriceTier = FALSE
		End If
		
	End If
	
'-------------------------------------
	'Allows discounted ticket price to be rounded to the nearest dollar
	'Default setting is False
	'RoundUp = always round up to the nearest dollar
	'RoundDown = always round down to the nearest dollar
	'RoundOut = if ticket > .50 then RoundUp OR if ticket < .50 RoundDown
	
	DIM roundFunction
				
	If Clean(Request("roundFunction")) <> "" Then
	
		If Clean(Request("roundFunction")) = "roundUp" Then
			roundFunction = "roundUp"
		End If
		
		If Clean(Request("roundFunction")) = "roundDown" Then
			roundFunction = "roundDown"
		End If
		
		If Clean(Request("roundFunction")) = "roundOut" Then
			roundFunction = "roundOut"
		End If
		
	End If
	
'--------------------------------------------------------

	If AllowDiscount = "Y" Then 

			SQLWhere = "Seat.OrderNumber = " & OrderNumber & " AND DiscountEvents.DiscountTypeNumber = " & DiscountTypeNumber & " AND  OrderLine.ItemType IN ('Seat', 'SubFixedEvent')"
			
			If SameSeatType Then
				SQLWhere = SQLWhere & "AND OrderLine.SeatTypeCode = " & SeatTypeCode & ""
			End If
			
			If SamePriceTier Then
				SQLWhere = SQLWhere  & "AND Color = '" & Color & "'"
			End If
			
			'Count # of applicable Acts on the order.
			SQLActCount = "SELECT COUNT(DISTINCT Event.ActCode) AS ActCount FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode INNER JOIN DiscountEvents (NOLOCK) ON Event.EventCode = DiscountEvents.EventCode WHERE Seat.OrderNumber = " & OrderNumber & " AND DiscountEvents.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') AND " & SQLWhere & ""
			Set rsActCount = OBJdbConnection.Execute(SQLActCount)
			ActCount = rsActCount("ActCount")
			rsActCount.Close
			Set rsActCount = nothing
				
		If ActCount >= SeriesCount Then
		
			'Get the fewest number of tickets for any applicable ActCode
			SQLMinTicketCount = "SELECT ActCode, COUNT(*) AS NumSubs FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode INNER JOIN DiscountEvents (NOLOCK) ON Event.EventCode = DiscountEvents.EventCode WHERE Seat.OrderNumber = " & OrderNumber & " AND DiscountEvents.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') AND " & SQLWhere & " GROUP BY Event.ActCode ORDER BY COUNT(*) DESC"
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
				Call ProcessSurcharge
				Call ProcessShipFee				
			Else
				If AddTicketDisc Then
					Call ProcessDiscount
					Call ProcessSurcharge
					Call ProcessShipFee
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
	'-------------------
	If Clean(Request("Percentage")) <> "" Then

		NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Clean(Request("Percentage")))/100), 2)
		
	'FixedPrice Discount
	'-------------------			
	ElseIf Clean(Request("FixedPrice")) <> "" Then

		NewPrice = round(CDbl(Clean(Request("FixedPrice"))),2)
		
	'Amount Discount
	'-------------------
	ElseIf Clean(Request("DiscountAmount")) <> "" Then

		NewPrice = round(CDbl(Clean(Request("Price"))),2) - round(CDbl(Clean(Request("DiscountAmount"))),2)
			
	'Series Price
	'-------------------
	ElseIf Clean(Request("SeriesPrice")) <> "" Then

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
		
	If NewPrice < Clean(Request("Price")) Then
	
		If NewPrice < 0 Then
			NewPrice = 0
		End If
		
		Select Case roundFunction
			Case "roundUp"
				NewPrice = fnRoundUp(NewPrice)
			Case "roundDown"
				NewPrice = fnRoundDown(NewPrice)
			Case "roundOut"
				NewPrice = fnRoundOut(NewPrice)
		End Select
		
		DiscountAmount = Round(Clean(Request("Price")),2) - NewPrice
		
		AppliedFlag = "Y"
		
	End If
	
End Sub

'---------------------------------------------

Sub ProcessSurcharge

	'Process per ticket service fees

	If AppliedFlag = "Y" Then
		
		'Apply a new surcharge
		'-------------------------------------
		If Clean(Request("NewSurcharge")) <> "" Then
			Surcharge = Request("NewSurcharge")
			
			
		'Recalculate the surcharge
		'-------------------------------------
		ElseIf Request("CalcServiceFee") <> "N" Then
			
				Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))			

		'Apply a flat surcharge
		'-------------------------------------
		ElseIf Clean(Request("OrderSurcharge")) <> "" Then
			
				OrderSurcharge = Round(CDbl(Clean(Request("OrderSurcharge"))),2)

				SQLCount = "SELECT COUNT(*) AS SeriesCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & OrderNumber & ""
				Set rsCount = OBJdbConnection.Execute(SQLCount)
				SeriesCount = rsCount("SeriesCount")
				rsCount.Close
				Set rsCount = nothing
				
				SQLCount = "SELECT COUNT(*) AS AppliedCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND DiscountTypeNumber = " & DiscountTypeNumber
				Set rsCount = OBJdbConnection.Execute(SQLCount)
				TotalAppliedCount = rsCount("AppliedCount")
				rsCount.Close
				Set rsCount = nothing
			
				Remainder = TotalAppliedCount MOD SeriesCount

				If Remainder = SeriesCount - 1 Then 
					Surcharge = OrderSurcharge - ((SeriesCount - 1) * Round(OrderSurcharge / SeriesCount, 2))
				Else
					Surcharge = Round(OrderSurcharge/SeriesCount, 2)
				End If
			

		End If
		
	End If

End Sub	

'---------------------------------------------

Sub ProcessShipFee

	If AppliedFlag = "Y" Then

		'Apply a new delivery surcharge
		If Clean(Request("NewShipFee")) <> "" Then
		
			NewShipFee = Clean(Request("NewShipFee"))
			
			SQLUpdate = "UPDATE OrderHeader SET ShipFee = " & NewShipFee & " WHERE OrderHeader.OrderNumber = " & OrderNumber & " "
			Set rsUpdate  = OBJdbConnection.Execute(SQLUpdate)
			
		End If
		
	End If
		
End Sub	

'---------------------------------------------

Public Function fnRoundOut(number)
	decimals = 2
	fnRoundOut = round(number,decimals)
End Function

Public Function fnRoundUp(number)
	decimals = 0
	roundednumber = round(number,decimals)
	if roundednumber < number then roundednumber = roundednumber + (10^(decimals * -1))
	fnRoundUp = roundednumber
End Function

Public Function fnRoundDown(number)
	decimals = 0
	roundednumber = round(number,decimals)
	if roundednumber > number then roundednumber = roundednumber - (10^(decimals * -1))
	fnRoundDown = roundednumber
End Function

'---------------------------------------------

%>