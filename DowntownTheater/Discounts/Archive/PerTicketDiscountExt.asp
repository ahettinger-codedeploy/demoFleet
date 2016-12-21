<%

'CHANGE LOG
'JAI 06/01/12 - New per ticket discount script.  Combination of Amount, Percentage, and Fixed Price discounts.
'SSR 06/26/14 - 'Extended the generic percentage discount for Heathens House Arts & Entertainment Group.  
				'Added new optional parameter to only give discount if patron:
				'- has purchased donation item in past 365 days
				'- has donation item in shopping cart.
				'Parameter example:  AllowedDonationItem=4687

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->


<%

'========================================================

'Heathens House Arts & Entertainment Group
'Percentage discount based on past donation


'Donation/Membership Required
'----------------------------
'Discount granted if patron is a member.
'Valid membership:
' - patron has purchased membership in the past 365 days
' - patron has added membership to their current order


'Valid Tickets
'----------------------------
'Valid for all ticket types


'Discount Amount
'----------------------------
'Per ticket discount: 50% off

		
'Offline/Online
'----------------------------
'Online Only


'Service Fees
'----------------------------
'No change to existing service fees


'Additional Tickets
'----------------------------
'N/A


'Automatic/Code Entry
'----------------------------
'Automatic


'Expiration
'----------------------------
'No expiration


'Restrictions
'----------------------------
'N/A

'========================================================

'Discount Definition - Required/Optional Parameters
'Required
'1) Percentage, DiscountAmount, or FixedPrice - To define the amount to discount
'Optional
'4) All fields in DiscountScriptInclude


If Clean(Request("OrderTypeNumber")) = 1 Then

	ErrorLog("Internet Order")
	
	'Internet Order
	'--------------------------------------------------------

	'Extended Discount Option
	'Verify if patron has made donation/membership purchase 

	DIM CustomerNbr
	CustomerNbr = 0

	DIM AllowedDonationItem

	If Request("AllowedDonationItem") <> "" Then
	
		'Get the donation item numbers
		AllowedDonationItem = Clean(Request("AllowedDonationItem")) 

		'Get the customer number
		SQLMemberNumber= "SELECT CustomerNumber FROM OrderHeader (NOLOCK) WHERE OrderHeader.OrderNumber = " & OrderNumber & ""
		Set rsMemberNumber = OBJdbConnection.Execute(SQLMemberNumber)
			If Not rsMemberNumber.EOF Then
				CustomerNbr = rsMemberNumber("CustomerNumber")
			End If
		rsMemberNumber.Close
		Set rsMemberNumber = nothing
			
		If CustomerNbr <> 0 Then
				
			'Check for donation item numbers on current order or orders in last 365 days
			SQLMember = "SELECT OrderLine.ItemNumber FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE (OrderLine.ItemNumber IN (" & AllowedDonationItem & ") AND OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.StatusCode = 'R') OR (OrderLine.ItemNumber IN (" & AllowedDonationItem & ") AND OrderHeader.CustomerNumber = " & CustomerNbr & " AND OrderLine.StatusCode = 'S' AND GetDate() < (DateAdd(Day, 365, OrderHeader.OrderDate))) ORDER BY OrderLine.ItemNumber"
			Set rsMember = OBJdbConnection.Execute(SQLMember)
				If rsMember.EOF Then 'not found
					AllowDiscount = "N"
				End If
			rsMember.Close
			Set rsMember = nothing

			'ErrorLog("DonationFound: " & DonationFound & " || Item: " & DonationItemNo & "")
			
		End If
		
	End If
	
	'--------------------------------------------------------

	If AllowDiscount = "Y" Then 'It's okay to apply to this order.

		If Clean(Request("Percentage")) <> "" Then
			NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Clean(Request("Percentage")))/100), 2)
		ElseIf Clean(Request("FixedPrice")) <> "" Then
			NewPrice = Round(CDbl(Clean(Request("FixedPrice"))),2)
		Else
			NewPrice = Round(CDbl(Clean(Request("Price"))),2) - Round(CDbl(Clean(Request("DiscountAmount"))),2)
		End If	
		
		If NewPrice < 0 Then
			NewPrice = 0
		End If
		
		DiscountAmount = Round(Clean(Request("Price")),2) - NewPrice

		If NewSurcharge <> "" Then
			Surcharge = NewSurcharge
		ElseIf Request("CalcServiceFee") <> "N" Then
			Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
		End If
		
		AppliedFlag = "Y"
		
	End If	
	
	'--------------------------------------------------------
	

Else

'Box Office Order
ErrorLog("Box Office Order")

'How many session variables are there?
Dim strName
Dim i

ErrorLog("Survey: " & Session.Contents.Count & " Session variables")

If Session.Contents.Count = 10 Then
	ErrorLog("Clear SurveyComplete")
	Session.Contents.Remove "SurveyComplete"
	ErrorLog("Clear DonationComplete")
	Session.Contents.Remove "DonationComplete"
	ErrorLog("Re-Survey: " & Session.Contents.Count & " Session variables")
End If

i = 1

For Each strName in Session.Contents
	ErrorLog("(" & i & ") [" & strName & "] (" & Session.Contents(strName) & ")")
	i = i + 1
Next

Session.Contents.RemoveAll

End If

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>