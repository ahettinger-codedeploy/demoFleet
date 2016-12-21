<%

'CHANGE LOG
'JAI 06/01/12	'New per ticket discount script.  Combination of Amount, Percentage, and Fixed Price discounts.

'SSR 09/24/14	'Extended the Per Ticket Discount Script
				'New option to allow discount based on customer's past donation purchase history
				'Number of tickets discounted based on donation item purchased.
				'Total ticket count is sum of all donation items purchased.
				'Donation items must be purchased in the past 365 days and/or on current order
				
				'Requires 2 Parameters:
				
				'Required Item (single):    &RequiredDonationItem=4758
				'Required Item (multiple):  &RequiredDonationItem=4758,4759,4761,4762
				
				'Tickets to discount (single): 		&SeriesCount=10
				'Tickets to discount (multiple):	&SeriesCount=10,8,4,4
				
'SSR 11/21/14	'Modified script to allow a different discount amount for the holiday event

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%
	'--------------------------------------------------------
	'Holiday Event Variables
	
	DIM HolidayEventCode
	HolidayEventCode = "684032"
	
	DIM HolidayEventDiscount
	HolidayEventDiscount = 5

	'--------------------------------------------------------
	'Discount Variables
	
	DIM varIndex
	varIndex = "RequiredDonationItem"

	DIM varDisc
	varDisc = "SeriesCount"
	
	DIM CustomerNbr
	CustomerNbr = fnCustomerNbr
	
	DIM MaxDisc
	MaxDisc = fnMaxDisc
		
	'-------------------------------------------------------
		
	If AllowDiscount = "Y" Then 'It's okay to apply to this order.

		If MaxDisc > 0 Then
		
			SQLLineCount = "SELECT Count(OrderLine.DiscountTypeNumber) as LineCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderHeader.CustomerNumber = " & CustomerNbr & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND Event.ActCode = (SELECT Event.ActCode FROM Event (NOLOCK) WHERE Event.EventCode = " & EventCode & ")"
			Set rsLineCount = OBJdbConnection.Execute(SQLLineCount)
				LineCount = rsLineCount("LineCount")
			rsLineCount.Close
			Set rsLineCount = nothing
			
			If CInt(LineCount) < CInt(MaxDisc) Then
				Call ProcessDiscount
				Call ProcessSurcharge
			End If
								
		End If
		
	End If
	
	Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
	Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
	Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
	Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf
		
	'--------------------------------------------------------
	
	Sub ProcessDiscount
				
		Select Case EventCode
		
			Case HolidayEventCode
			
				NewPrice = Round(CDbl(Clean(Request("Price"))),2) - Round(CDbl((HolidayEventDiscount)),2)
		
			Case Else

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
		
		End Select
		
		If NewPrice < Price Then
		
			If NewPrice < 0 Then
				NewPrice = 0
			End If
			
			DiscountAmount = Round(Clean(Request("Price")),2) - NewPrice
			
			AppliedFlag = "Y"
			
		End If
		
	End Sub
	
	'--------------------------------------------------------
	
	Sub ProcessSurcharge

		If AppliedFlag = "Y" Then

			'Apply Series Surcharge
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

			'Apply NewSurcharge
			ElseIf Request("NewSurcharge") <> "" Then
				Surcharge = Request("NewSurcharge")
			
			'Apply ReCalc Surcharge
			ElseIf Request("CalcServiceFee") <> "N" Then
				Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
				
			End If
			
		End If

	End Sub
	
	'--------------------------------------------------------
	
	Function fnMaxDisc
	
		'Determine the number of allowed discount tickets by:
		'- count the donation item(s) purchased
		'- determine the number of discounted tickets allowed for each donation item
		
		DIM TicketCount 'Number of Allowed Discounted Tickets
		TicketCount = 0
	
		DIM IndexList 'List of donation items
		IndexList = Request.QueryString(varIndex)
		
		DIM DiscList 'Number of allowed discounts per donation item
		DiscList = Request.QueryString(varDisc)
		
		DIM arrayTble 'Discount Table
		
		'Determine if there multiple price tiers
		If instr(IndexList,",") <> 0 AND instr(DiscList,",") <> 0 Then
		
		'Multiple Price Tiers Found!
				
			'get list of donation items
			DIM IndexArr 
			IndexArr = split(IndexList,",")
			
			'get list of series counts
			DIM DiscArr	
			DiscArr = split(DiscList,",")
			
			'1st column: donation items
			DIM IndexCol 
			IndexCol = 0
			
			'2nd column: series count
			DIM DiscCol 
			DiscCol = 1
			
			'number of rows in discount table
			DIM rowCount 
			rowCount = uBound(IndexArr)

			'resize discount table
			reDIM arrayTble(rowCount) 
			
			'populate discount table
			For i = 0 to rowCount
				arrayTble(i) = array(CDbl(IndexArr(i)),CDbl(DiscArr(i)))
			Next
			
			'sort discount table
			For col1 = UBound(arrayTble) - 1 To 0 Step -1
				For col2 = 0 To col1
					If arrayTble(col2)(0) > arrayTble(col2+1)(0) Then
						swap = arrayTble(col2)
						arrayTble(col2) = arrayTble(col2+1)
						arrayTble(col2+1) = swap
					End If
				Next
			Next
			
			'use discount table to determine the correct number of allowed discounts
			For i = 0 To rowCount
			
				row = arrayTble
				RequiredDonationItem = row(i)(IndexCol)
				SeriesCount = row(i)(DiscCol)
			
				SQLMember = "SELECT Count(OrderLine.ItemNumber) AS ItemCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE (OrderLine.ItemNumber = " & RequiredDonationItem & " AND OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.StatusCode = 'R') OR (OrderLine.ItemNumber = " & RequiredDonationItem & " AND OrderHeader.CustomerNumber = " & CustomerNbr & " AND OrderLine.StatusCode = 'S' AND GetDate() < (DateAdd(Day, 365, OrderHeader.OrderDate)))" 
				Set rsMember = OBJdbConnection.Execute(SQLMember)
					If Not IsNull(rsMember("ItemCount")) Then
						TicketCount = TicketCount + (rsMember("ItemCount") * SeriesCount)				
					End If
				rsMember.Close
				Set rsMember = nothing
				
			Next
				
		Else
		
		'Single Discount Price Tier Found!
			
			If cInt(GroupCount) >=  cInt(IndexList) Then
				OrderDiscount = DiscList	
			End If
				
		End If
		
		fnMaxDisc = TicketCount

	End Function
	
	'--------------------------------------------------------
	
	Function fnCustomerNbr
	
		DIM strResult
	
		'get Customer Number
		SQLMemberNumber= "SELECT CustomerNumber FROM OrderHeader (NOLOCK) WHERE OrderHeader.OrderNumber = " & OrderNumber & ""
		Set rsMemberNumber = OBJdbConnection.Execute(SQLMemberNumber)
			If Not rsMemberNumber.EOF Then
				strResult = rsMemberNumber("CustomerNumber")
			End If
		rsMemberNumber.Close
		Set rsMemberNumber = nothing
		
		
		fnCustomerNbr = strResult
		
		
	End Function
	
	'--------------------------------------------------------

%>