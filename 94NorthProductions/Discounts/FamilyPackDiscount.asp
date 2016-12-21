<%

'CHANGE LOG
'SSR - 09/30/2014 - New Family Pack Discount created.
'SSR - 10/29/2014 - Updated discount of DARKBLUE section from 19.85 to 9.85
'SSR - 11/04/2014 - Updated Adult ticket type to Adult Preferred ticket type
'SSR - 11/14/2014 - Updated Adult ticket type to include both Adult and Adult Preferred
'SSR - 10/26/2014 - Updated discount amount

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'=========================================================

DIM ChildSeatList
ChildSeatList = "54146"

DIM AdultSeatList
AdultSeatList = "65545,54126"

DIM SectionColor

DIM PackageCount
PackageCount  = 4

DIM DiscountGold
DiscountBlue = 29.85

DIM DiscountBlue
DiscountGold = 29.85


'Tier 1 Pricing - DARKBLUE

'Ticket Type		Price		Discount	Total	
'-------------------------------------------------
'Child (under 12)	$29.95		$7.47		$27.48
'Child (under 12)	$29.95		$7.46		$27.49
'Adult				$59.95		$7.46		$57.49
'Adult				$59.95		$7.46		$57.49
'---------------------------------------------------
'					$179.80		$29.85		$149.95


'Tier 2 Pricing - DARKGOLD

'Ticket Type		Price		Discount	Total	
'-------------------------------------------------
'Child (under 12)	$29.95		$7.47		$27.48
'Child (under 12)	$29.95		$7.46		$27.49
'Adult				$49.95		$7.46		$47.49
'Adult				$49.95		$7.46		$47.49
'--------------------------------------------------
'					$159.80		$29.85		$129.95


'=========================================================

	If AllowDiscount = "Y" Then 'It's okay to apply to this order.
		Call TicketCount
	End If	

	Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
	Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
	Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
	Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

'---------------------------------------------

	Sub TicketCount

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


	End Sub

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