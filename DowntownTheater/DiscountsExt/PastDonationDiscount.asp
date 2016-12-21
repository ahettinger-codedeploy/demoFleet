<%

'CHANGE LOG
'JAI 06/01/12	'New per ticket discount script.  Combination of Amount, Percentage, and Fixed Price discounts.
'SSR 07/28/14	'Extended the Per Ticket Discount Script 
				'New option to allow discounts based on a specific customer's past donation/membership purchase history
				
				'Requires 1 Parameter:
				'Required Item (single):    &AllowedDonationItem=2077
				'Required Item (multiple):  &AllowedDonationItem=2077,2078,2079,2080,2449
				
				'Discount granted if a donation item was purchased in the past 365 days or is on current order
				
'SSR 09/23/14	'Changed AllowedDonationItem to RequiredDonationItem, as that makes much more sense

'SSR 09/24/14 	'Added option to allow discount based on sum of past donations made by patron.

				'Requires 1 Parameter:
				'Min donation amount:	&RequiredDonationAmount=5
				'If not used, there will be no minimum required.
				
'SSR 12/01/14 - 'Removed the AllowedSeatTypeList variable. It's already in the discount include script	

'SSR 06/01/15 - Added option to pass a new per ticket fee. 		
				'&NewSurcharge=0
				
'SSR 06/02/15 - Updated to allow discount if a valid RequiredDonationAmount or a valid RequiredDonationItem is either on the current order or in the past 365 days.

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'---------------------------------------------------------

	'Get the Customer Number
	DIM CustomerNumber
	CustomerNumber = fnCustomerNumber


	If CustomerNumber = 1 OR CustomerNumber = "" Then
		AllowDiscount = "N"
	End If


	'Get the Required Donation Item(s)
	DIM RequiredDonationItem
	If  Clean(Request("RequiredDonationItem")) <> "" Then
		RequiredDonationItem = Clean(Request("RequiredDonationItem"))
	Else
		AllowDiscount = "N"
	End If


	'Get the Required Donation Amount
	DIM RequiredDonationAmount
	If  Clean(Request("RequiredDonationAmount")) <> "" Then
		RequiredDonationAmount = CDbl(Clean(Request("RequiredDonationAmount"))) 
	End If

'---------------------------------------------------------

If AllowDiscount = "Y" Then

	ErrorLog("AllowDiscount")
		
	SQLMember = "SELECT COUNT(OrderLine.LineNumber) AS ItemCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE (OrderLine.ItemNumber IN (" & RequiredDonationItem & ") AND OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.StatusCode = 'R') OR (OrderLine.ItemNumber IN (" & RequiredDonationItem & ") AND OrderHeader.CustomerNumber = " & CustomerNumber & " AND OrderLine.StatusCode = 'S' AND GetDate() < (DateAdd(Day, 365, OrderHeader.OrderDate)))" 
	Set rsMember = OBJdbConnection.Execute(SQLMember)
		If Not rsMemberCurrent.EOF Then
			If rsMemberCurrent("ItemCount") > 0 Then
				Call ProcessDiscount
			End If	
		End If
	rsMember.Close
	Set rsMember = nothing

End If	

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

'---------------------------------------------------------

	Sub ProcessDiscount
	
	ErrorLog("ProcessDiscount")
				
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
											
			If NewSurcharge <> "" Then
				Surcharge = NewSurcharge
			ElseIf Request("CalcServiceFee") <> "N" Then
				Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
			ElseIf NewPrice = 0 Then
				Surcharge = 0
			End If
			
			AppliedFlag = "Y"
			
		End If
			
		
	End Sub
	
'--------------------------------------------------------

	Public Function fnCustomerNumber

		'this function returns the patrons customer number

		DIM strResults

		If Request("CustomerNumber") = "" Then 
			SQLOrderCustomer = "SELECT CustomerNumber FROM OrderHeader (NOLOCK) WHERE OrderNumber = " & OrderNumber
			Set rsOrderCustomer = OBJdbConnection.Execute(SQLOrderCustomer)
				If Not rsOrderCustomer.EOF Then
					strResults = rsOrderCustomer("CustomerNumber")
				End If
			rsOrderCustomer.Close
			Set rsOrderCustomer = nothing
		Else
			strResults = CleanNumeric(Request("CustomerNumber"))
		End If
		
		fnCustomerNumber = strResults

	End Function

'---------------------------------------------------------

%>
