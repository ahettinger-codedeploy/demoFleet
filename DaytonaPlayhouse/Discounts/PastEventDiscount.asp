<%

'CHANGE LOG
'JAI 6/1/12 - New per ticket discount script.  Combination of Amount, Percentage, and Fixed Price discounts.

%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

	'--------------------------------------------------------

	'Extended Per Ticket Discount Script
	'New option to allow discounts based on past event purchase
	'Requires 2 Parameters:
	'RequiredPastEvent=678679 - The subscription event
	'SeriesCount=6 - The number of discounted tickets per subscription
	
	If Request("RequiredPastEvent") <> "" Then
	
		'Get the Required Event Code
		DIM RequiredPastEvent
		RequiredPastEvent = Clean(Request("RequiredPastEvent")) 
		
		'Get the Customer Number
		DIM CustomerNbr
		SQLMemberNumber= "SELECT CustomerNumber FROM OrderHeader (NOLOCK) WHERE OrderHeader.OrderNumber = " & OrderNumber & ""
		Set rsMemberNumber = OBJdbConnection.Execute(SQLMemberNumber)
			If Not rsMemberNumber.EOF Then
				CustomerNbr = rsMemberNumber("CustomerNumber")
			End If
		rsMemberNumber.Close
		Set rsMemberNumber = nothing

		'Determine the maximum discounts allowed for this Customer
		DIM NbrSubscriptions
		DIM SeriesCount
		
		'Determine the Number of Subscriptions by checking two parameters:
		'(1) Required Event is currently in shopping cart
		'(2) Required Event has been purchased in the past year
		SQLPastEventCount = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE (EventCode IN (" & RequiredPastEvent & ") AND OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.StatusCode = 'R') OR (EventCode IN (" & RequiredPastEvent & ") AND OrderHeader.CustomerNumber = " & CustomerNbr & " AND OrderLine.StatusCode = 'S' AND GetDate() < (DateAdd(Day, 365, OrderHeader.OrderDate)))"
		Set rsPastEventCount = OBJdbConnection.Execute(SQLPastEventCount)
			If Not rsPastEventCount.EOF Then
				NbrSubscriptions = rsPastEventCount("TicketCount")
			End If
		rsPastEventCount.Close
		Set rsPastEventCount = nothing
		
		If NbrSubscriptions <> 0 Then
		
			'Determine the number of discounted tickets allowed per subscription
			SeriesCount = Clean(Request("SeriesCount")) 

			'Determine the number of discounts already given to this customer
			Set spCommand = Server.Createobject("Adodb.Command")
			Set spCommand.ActiveConnection = OBJdbConnection
			spCommand.Commandtype = 4 ' Value for Stored Procedure
			spCommand.Commandtext = "spRetrieveCustomerTicketCount"
			spCommand.Parameters.Append spCommand.CreateParameter("LineCount", 3, 4) 'As Integer and ParamReturnValue
			spCommand.Parameters.Append spCommand.CreateParameter("OrderNumber", 3, 1, , OrderNumber) 'As Integer and Input
			spCommand.Parameters.Append spCommand.CreateParameter("DiscountTypeNumber", 3, 1, , DiscountTypeNumber) 'As Integer and Input
			spCommand.Execute
			
			LineCount = spCommand.Parameters("LineCount") 
			
			If LineCount >= CInt( NbrSubscriptions * SeriesCount ) Then
				AllowDiscount = "N"
			End If

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

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

%>