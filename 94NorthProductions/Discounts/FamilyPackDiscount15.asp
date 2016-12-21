<%

'CHANGE LOG
'SSR - 06/24/2014 - Created new discount based on the existing family pack discount

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'=========================================================

'94 North Productions
'Family Pack Discount

'Discount given with purchase of 2 Adult tickets and 2 Child tickets
'for the series price of $149.95

'Valid only for the following adult ticket types: Adult, Adult Preferred,
'Valid only for the following child ticket type:  Child (under 12)

'Ticket Type		Price		Discount	New Price	
'-------------------------------------------------
'Child (under 12)	$39.95		$12.45		$27.48
'Adult Preferred	$59.95		$12.45		$47.49
'Adult				$59.95		$12.51		$47.44
'--------------------------------------------------
'					$199.80		$49.85		$149.95

'=========================================================

DIM ChildSeatList
ChildSeatList = "54146" 'Child (under 12)

DIM AdultSeatList
AdultSeatList = "65545,54126"  'Adult, Adult Preferred,

DIM SectionColor

DIM PackageCount
PackageCount  = 4

DIM DiscountGold
DiscountBlue = 49.85

DIM DiscountBlue
DiscountGold = 49.85

'---------------------------------------------

If AllowDiscount = "Y" Then 'It's okay to apply to this order.

	'Get the section colors for this order
	SQLSectionColor = "SELECT Section.Color FROM Section (NOLOCK) WHERE EventCode = " & EventCode & " AND SectionCode = '" & SectionCode & "'"
	Set rsSectionColor = OBJdbConnection.Execute(SQLSectionColor)
	
		SectionColor = rsSectionColor("Color")

		If Not rsSectionColor.EOF Then
				
			'Sum up ticket counts for Adult and Child				
			SQLEventCount = "SELECT AdultCount, ChildCount, (AdultCount+ChildCount) as TotalCount FROM (SELECT (SELECT Count(OrderLine.SeatTypeCode) FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Section  (NOLOCK) ON Seat.Eventcode = Section.eventcode AND Seat.Sectioncode = Section.Sectioncode inner join SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Seat.EventCode = " & EventCode & " AND ORDERLINE.SEATTYPECODE IN (" & AdultSeatList & ") AND SECTION.COLOR = '" & rsSectionColor("Color") & "') as AdultCount, (SELECT Count(OrderLine.SeatTypeCode) FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Section  (NOLOCK) ON Seat.Eventcode = Section.eventcode AND Seat.Sectioncode = Section.Sectioncode inner join SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Seat.EventCode = " & EventCode & " AND ORDERLINE.SEATTYPECODE IN (" & ChildSeatList & ") AND SECTION.COLOR = '" & rsSectionColor("Color") & "') as ChildCount )t"
			Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)

				'Verify the ratio of Adult to Child tickets
				If Not rsEventCount.EOF Then
				
					AdultCount = rsEventCount("AdultCount")
					ChildCount = rsEventCount("ChildCount")
				
					If rsEventCount("TotalCount") >= PackageCount Then
					
						If AdultCount >= (PackageCount / 2) AND ChildCount >= (PackageCount / 2)  Then
							Call ProcessDiscount
						End If
						
					End If
					
				End If
			
			rsEventCount.Close
			Set rsEventCount = nothing	

		End If
		
	rsSectionColor.Close
	Set rsSectionColor = nothing
		
End If	

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

'---------------------------------------------

	Sub ProcessDiscount

			Select Case SectionColor
				Case "DARKBLUE"
					PackageDiscount = DiscountBlue
				Case "DARKGOLD"
					PackageDiscount = DiscountGold
			End Select

			'Count number of tickets which have been given a discount
			SQLCount = "SELECT COUNT(OrderLine.ItemNumber) AS AppliedCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND DiscountTypeNumber = " & DiscountTypeNumber
			Set rsCount = OBJdbConnection.Execute(SQLCount)
				AppliedCount = rsCount("AppliedCount")
			rsCount.Close
			Set rsCount = nothing 
			
			Remainder = AppliedCount MOD PackageCount
			
			If Remainder = (PackageCount - 1) Then 
				DiscountAmount = PackageDiscount - ((PackageCount - 1)*(Round(PackageDiscount/PackageCount,2)))
			Else
				DiscountAmount = Round(PackageDiscount/PackageCount,2)
			End If

			NewPrice = Round(CDbl(Clean(Request("Price"))),2) - DiscountAmount

			If NewPrice < 0 Then
				NewPrice = 0
			End If
				
			AppliedFlag = "Y"
			
			Call ProcessSurcharge
		
	End Sub

'---------------------------------------------

	Sub ProcessSurcharge

			If NewSurcharge <> "" Then
				Surcharge = NewSurcharge
			ElseIf Request("CalcServiceFee") <> "N" Then
				Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
			End If
			
	End Sub

'---------------------------------------------



%>