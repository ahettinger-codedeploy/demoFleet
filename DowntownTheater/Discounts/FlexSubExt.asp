<%

'CHANGE LOG
'JAI 06/07/12 - Tightened application of discount to not allow extra tickets to be discounted.

'SSR 11/13/12 - 'Renamed script FlexSub as FlexSubExt to identify script with extended functionality
				'FlexSubExt will allow more parameters to be passed than FlexSub using same URL format
				'Example - 6 act subscription at $100 series price 
				'FlexSubExt.asp?SeriesCount=6&SeriesPrice=100
			
'SSR 05/05/13 - 'Added option allow rounding down to the nearest dollar. 
				'Parameter: &roundFunction=roundDown
				
'SSR 05/05/13 -	'Added option allow rounding up to the nearest dollar. 
				'Parameter: &roundFunction=roundUp
				
'SSR 07/20/15 - 'Added option to allow discounts on additional tickets with subscription
				'Parameter: &AddTicketDisc=Y
				
'SSR 10/15/15 - 'Added option to allow series discounts. Example Buy 3 shows and get $5.00 off ($1.67, $1.67 & $1.66 off per ticket)
				'Parameter: &SeriesDiscount=5.00	
				'Parameter: &SeriesCount=3			
						
%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%
	
'-------------------------------------

	'Initialize Variables
	DIM SeriesDiscount
	DIM SeriesCount
	DIM NbrSubscriptions
	DIM NbrTickets

	SeriesCount = CInt(CleanNumeric(Request("SeriesCount"))) 'Number of Productions in the Subscription
	NbrSubscriptions = 0
	NbrTickets = 0

'-------------------------------------

	'Allow discount on additional tickets
	'Default is FALSE

	DIM AddDisc
	AddDisc = FALSE
	
	If Clean(Request("AddTicketDisc")) = "Y" Then
		AddDisc = TRUE
	Else
		AddDisc = FALSE
	End If

'-------------------------------------

	'Require that all tickets are rounded to the nearest dollar
	'Default is no rounding
	
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
				Call ProcessSurcharge
				Call ProcessShipFee				
			Else
				If AddDisc Then
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


	'Series Discount
	'-------------------
	ElseIf Clean(Request("SeriesDiscount")) <> "" Then	
	
		SeriesDiscount = round(CDbl(Clean(Request("SeriesDiscount"))),2)
		
		'Determine the series count. 
		'Search for "Multiple" then "Series Count" 
		'If neither is found then apply discount to all tickets
		
		If Clean(Request("Multiple")) <> "" Then
			SeriesCount = Clean(Request("Multiple"))
		End If
		
		If Clean(Request("SeriesCount")) <> "" Then
			SeriesCount = Clean(Request("SeriesCount"))
		End If
		
		If SeriesCount = "" Then
			SQLCount = "SELECT COUNT(*) AS SeriesCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND OrderLine.ItemType IN ('SubFixedEvent','Seat')"
			Set rsCount = OBJdbConnection.Execute(SQLCount)
				SeriesCount = rsCount("SeriesCount")
			rsCount.Close
			Set rsCount = nothing
		End If
		
		'Count number of applied discounts on this order
		SQLCount = "SELECT COUNT(*) AS AppliedCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND DiscountTypeNumber = " & DiscountTypeNumber
		Set rsCount = OBJdbConnection.Execute(SQLCount)
			TotalAppliedCount = rsCount("AppliedCount")
		rsCount.Close
		Set rsCount = nothing
	
		'MOD function to determine the final ticket to complete the subscription discount  
		Remainder = TotalAppliedCount MOD SeriesCount

		'Calculate the discount to be assigned to the final ticket.
		If Remainder = SeriesCount - 1 Then 
			DiscountAmount = SeriesDiscount - ((SeriesCount - 1) * Round(SeriesDiscount  / SeriesCount, 2))
		Else
		'Calculate the discount to be assigned to all other tickets.
			DiscountAmount = Round(SeriesDiscount/SeriesCount, 2)
		End If
		
		NewPrice = round(CDbl(Clean(Request("Price"))),2) - round(CDbl(DiscountAmount),2)
	
	Else
	
		NewPrice = round(CDbl(Clean(Request("Price"))))
	
	End If
		
		
	If NewPrice < Price Then
	
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
		
		'Apply new surcharge
		'-------------------------------------
		If Clean(Request("NewSurcharge")) <> "" Then
			Surcharge = Request("NewSurcharge")
			
			
		'Recalculate the surcharge
		'-------------------------------------
		ElseIf Request("CalcServiceFee") <> "N" Then
			
				Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))			

		'Apply order surcharge
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

		'Apply Order Surcharge
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