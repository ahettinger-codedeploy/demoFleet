<%

'CHANGE LOG
'JAI 06/01/12 - New per ticket discount script.  Combination of Amount, Percentage, and Fixed Price discounts.

'SSR 01/06/15 -	'Updated discount script.
				'Added expiration date check
				'Use the original order date not the current date to determine if a discount has expired.
				'This allows re-opened orders to receive the correct discount should they be re-opened after the discount expiration date

'SSR 04/03/15 - 'Updated discount script.
				'Added option to pass a new delivery surcharge, aka per order processing fee, aka ship fee 
				'Parameter: &NewShipFee=0

'SSR 04/28/15 - Extended this discount to allow a maximumn total of per ticket fees.

'SSR 06/29/15 - 'Updated discount script for San Diego Junior Theater
				'Added option to pass a per order discount.  
				'The discount amount is divided between the tickets on the order.
				'Example: $10 per order discount
				'Parameter: &SeriesDiscount=10
				'To limit the number of tickets to be discounted use:
				'Optional Parameter:  &Multiple=3
				
'SSR 07/01/15 - 'Updated to restrict the discount to the subfixed events only

'SSR 07/16/15 - 'Updated to allow discount to be applied to subscription and non-subscription events.

'SSR 09/08/15 - 'Updated discount script for TheaterZone-FL
				'Added option to change the ShipCode for the discounted ticket.
				'Parameter: &NewShipCode=4


%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

	DIM varIndex
	varIndex = "SectionColor"

'---------------------------------------------

	If Request("ExpirationDate") <> "" Then

		ExpirationDate = Request("ExpirationDate")

		SQLDateCheck = "SELECT OrderHeader.OrderDate FROM OrderHeader (NOLOCK) WHERE OrderHeader.OrderNumber = " & OrderNumber & ""
		Set rsDateCheck = OBJdbConnection.Execute(SQLDateCheck)
		OriginalDate = rsDateCheck("OrderDate")
		rsDateCheck.Close
		Set rsDateCheck = nothing

		If CDate(OriginalDate) < CDate(ExpirationDate) Then  
			AllowDiscount = "Y"
		Else
			AllowDiscount = "N"
		End If
		
	End If

'---------------------------------------------

	If AllowDiscount = "Y" Then 'It's okay to apply to this order.
	
		If Left(SectionCode,3) = "TBL" Then
	
			SQLSectionCount = "SELECT Count(Seat.ItemNumber) AS Count FROM Seat (NOLOCK) WHERE Seat.EventCode = " & EventCode & " AND Seat.SectionCode = '" & SectionCode & "'"	
			Set rsSectionCount = OBJdbConnection.Execute(SQLSectionCount)	
				ErrorLog("EventCode: " & EventCode & " SectionCode: " & SectionCode & " Seat Count: " & rsSectionCount("Count") & "")
				SectionSeatCount = rsSectionCount("Count")
			rsSectionCount.Close
			Set rsSectionCount = nothing
			
			SQLOrderCount = "SELECT COUNT(OrderLine.ItemNumber)  AS Count FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND Seat.SectionCode = '" & SectionCode & "'"	
			Set rsOrderCount = OBJdbConnection.Execute(SQLOrderCount)	
				ErrorLog("OrderNumber: " & OrderNumber & " SectionCode: " & SectionCode & " Seat Count: " & rsOrderCount("Count") & "")
				OrderSeatCount = rsOrderCount("Count")
			rsOrderCount.Close
			Set rsOrderCount = nothing
			
			If OrderSeatCount = SectionSeatCount Then
			
				Call ProcessDiscount
				Call ProcessSurcharge
				Call ProcessShipFee	

			End If
		
		End If
	
	End If	

	Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
	Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
	Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
	Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

'---------------------------------------------
	
	Sub ProcessDiscount
	
		SQLSectionColor = "SELECT Section.Color FROM Section (NOLOCK) WHERE EventCode = " & EventCode & " AND SectionCode = '" & SectionCode & "'"
		Set rsSectionColor = OBJdbConnection.Execute(SQLSectionColor)	
			Select Case UCase(rsSectionColor("Color"))
				Case "GOLD"
					DiscountAmount = 3.75
				Case "GRAY"
					DiscountAmount = 1.25
			End Select
		rsSectionColor.Close
		Set rsSectionColor = nothing

		NewPrice = Price - DiscountAmount 
		
		AppliedFlag = "Y"
		
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
		
			'Apply New Ship Type
			If Clean(Request("NewShipCode")) <> "" Then
			
				NewShipCode = Clean(Request("NewShipCode"))
			
				SQLUpdate = "UPDATE OrderLine SET ShipCode = " & NewShipCode & " WHERE OrderLine.OrderNumber = " & OrderNumber & "" 
				Set rsUpdate  = OBJdbConnection.Execute(SQLUpdate)
				
			End If

			'Apply New Ship Fee
			If Clean(Request("NewShipFee")) <> "" Then
			
				NewShipFee = Clean(Request("NewShipFee"))
				
				SQLUpdate = "UPDATE OrderHeader SET ShipFee = " & NewShipFee & " WHERE OrderHeader.OrderNumber = " & OrderNumber & " "
				Set rsUpdate  = OBJdbConnection.Execute(SQLUpdate)
				
			End If

		End If
			
	End Sub	

'---------------------------------------------


%>