<%

'CHANGE LOG
'JAI 06/01/12 - New per ticket discount script.  Combination of Amount, Percentage, and Fixed Price discounts.
'SSR 04/03/15 - Extended this discount to allow discounts on the per ticket service fee.
'SSR 04/28/15 - Extended this discount to allow a maximumn total of per ticket fees.

'SSR 06/29/15 - 'Updated discount script for San Diego Junior Theater
				'Added option to pass a per order discount.  
				'The discount amount is divided between the tickets on the order.
				'Example: give a $10 per order discount
				'Parameter: &SeriesDiscount=10
				'To limit the number of tickets to be discounted use:
				'Optional Parameter:  &Multiple=3
				
'SSR 07/01/15 - 'Updated to restrict the discount to the subfixed events only

'SSR 07/16/15 - 'Updated to allow discount to be applied to subscription and non-subscription events.

'SSR 07/29/15 - 'Updated to pass combined per ticket surcharge fees. Tix Fees + New Surcharge + Percentage Surcharge (based on discounted ticket price)

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'---------------------------------------------

	'Expiration Date Check
	'Determine the original date of the order
	'this allows re-opened orders to receive the correct discount
	'if re-opened after the original discount expiration date

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
	
		Call ProcessTicketDiscount
		Call ProcessTicketSurcharge
		'Call ProcessDeliverySurcharge
	
	End If	

	Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
	Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
	Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
	Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

'---------------------------------------------

	Sub ProcessTicketDiscount

			'Percentage Discount
			'-------------------------------------
			If Clean(Request("Percentage")) <> "" Then
			
				NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Clean(Request("Percentage")))/100), 2)
				
			'Fixed Price
			'-------------------------------------
			ElseIf Clean(Request("FixedPrice")) <> "" Then
			
				NewPrice = round(CDbl(Clean(Request("FixedPrice"))),2)
			
			'Discount Amount
			'-------------------------------------		
			ElseIf Clean(Request("DiscountAmount")) <> "" Then
			
				NewPrice = round(CDbl(Clean(Request("Price"))),2) - round(CDbl(Clean(Request("DiscountAmount"))),2)
			
			'Series Price
			'-------------------------------------		
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

			'Series Discount
			'-------------------------------------		
			ElseIf Clean(Request("SeriesDiscount")) <> "" Then

				SeriesDiscount = round(CDbl(Clean(Request("SeriesDiscount"))),2)
				Price = round(CDbl(Clean(Request("Price"))),2)
				
				'Series Count (if "Multiple" is left blank - discount applied to all tickets)
				SQLCount = "SELECT COUNT(*) AS SeriesCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND OrderLine.ItemType IN ('SubFixedEvent','Seat')"
				Set rsCount = OBJdbConnection.Execute(SQLCount)
					SeriesCount = rsCount("SeriesCount")
				rsCount.Close
				Set rsCount = nothing

				'Count # of applied tickets on this order
				SQLCount = "SELECT COUNT(*) AS AppliedCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.ItemType IN ('SubFixedEvent','Seat')"
				Set rsCount = OBJdbConnection.Execute(SQLCount)
					TotalAppliedCount = rsCount("AppliedCount")
				rsCount.Close
				Set rsCount = nothing
			
				'MOD function to determine the last ticket to complete the subscription discount (i.e. fourth ticket in the FlexPass-4, or eighth ticket in a FlexPass-8, etc.).  
				Remainder = TotalAppliedCount MOD SeriesCount

				'Calculates the total of all discounted ticket prices already given to figure out the discounted ticket price to be assign to this ticket.
				If Remainder = SeriesCount - 1 Then 
					DiscountAmount = SeriesDiscount - ((SeriesCount - 1) * Round(SeriesDiscount / SeriesCount, 2))
					NewPrice = Price - DiscountAmount
				Else
				'Standard rounding on all other tickets.
					DiscountAmount = Round(SeriesDiscount / SeriesCount, 2)
					NewPrice = Price - DiscountAmount
				End If

			Else
			
				NewPrice = round(CDbl(Clean(Request("Price"))))
			
			End If

			
		If NewPrice < 0 Then
			NewPrice = 0
		End If
			
		DiscountAmount = Round(Clean(Request("Price")),2) - NewPrice
			
		AppliedFlag = "Y"
		
	End Sub

'---------------------------------------------

	Sub ProcessTicketSurcharge
			
		If AppliedFlag = "Y" Then
		
			'Recalculate Tix Service Fees
			If Request("CalcServiceFee") = "Y" Then
				TixFee = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
			Else
				TixFee = Surcharge
			End If

			'Add New Surcharge Fee
			If Clean(Request("NewSurcharge")) <> "" Then
				NewSurcharge = Request("NewSurcharge")
			Else
				NewSurcharge = 0
			End If
			
			'Add New Surcharge Percentage
			If Clean(Request("SurchargePercentage")) <> "" Then
				AddSurcharge = (round(CDbl(NewPrice))) - (round(CDbl(NewPrice) * (1-CDbl(Clean(Request("SurchargePercentage")))/100), 2))
			Else
				AddSurcharge = 0
			End If
					
			Surcharge = TixFee + NewSurcharge + AddSurcharge

		End If
			
	End Sub

'---------------------------------------------

%>