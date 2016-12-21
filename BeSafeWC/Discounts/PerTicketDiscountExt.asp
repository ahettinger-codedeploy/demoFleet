<%

'CHANGE LOG
'JAI 06/01/12	'New per ticket discount script.  Combination of Amount, Percentage, and Fixed Price discounts.

'SSR 09/24/14	'Per Ticket Discount Survey
				'Companion to Per Ticket Discount 
				'New option to allow discount based on customer's past donation purchase history
				'Number of tickets discounted based on donation item purchased.
				'Total ticket count is sum of all donation items purchased.
				'Donation items must be purchased in the past 365 days and/or on current order
				
				'Requires 2 Parameters:
				
				'Required Item (single):    &RequiredDonationItem=4758
				'Required Item (multiple):  &RequiredDonationItem=4758,4759,4761,4762
				
				'Tickets to discount (single): 		&SeriesCount=10
				'Tickets to discount (multiple):	&SeriesCount=10,8,4,4
				

'SSR 09/24/14	'Updated to prevent conflicts between the TIX2 discount and TIX1 survey 
%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

	'--------------------------------------------------------
	
	AllowDiscount = "N"
	
	If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then 

		'Get the Required Donation Item(s)
		DIM varIndex
		varIndex = "RequiredDonationItem"

		DIM varDisc
		varDisc = "SeriesCount"

		DIM MaxDiscount
		MaxDiscount = getMaxDisc

		If MaxDiscount > 0 Then
						
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
			
			If CInt(MaxDiscount) =< LineCount Then
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
	
	'--------------------------------------------------------
	
	Function getMaxDisc
	
		DIM CustomerNbr 'Customer Number
		CustomerNbr = 1
	
		DIM TicketCount 'Number of Allowed Discounted Tickets
		TicketCount = 0
	
		DIM IndexList 'Donation Items
		IndexList = Request.QueryString(varIndex)
		
		DIM DiscList 'Number of tickets per donation item
		DiscList = Request.QueryString(varDisc)
		
		DIM arrayTble 'Discount Table
		
		'get Customer Number
		SQLMemberNumber= "SELECT CustomerNumber FROM OrderHeader (NOLOCK) WHERE OrderHeader.OrderNumber = " & OrderNumber & ""
		Set rsMemberNumber = OBJdbConnection.Execute(SQLMemberNumber)
			If Not rsMemberNumber.EOF Then
				CustomerNbr = rsMemberNumber("CustomerNumber")
			End If
		rsMemberNumber.Close
		Set rsMemberNumber = nothing
		
		If instr(IndexList,",") <> 0 AND instr(DiscList,",") <> 0 Then
				
			'get list of donation items
			DIM IndexArr 
			IndexArr = split(IndexList,",")
			
			'get list of tickets per donation item
			DIM DiscArr	
			DiscArr = split(DiscList,",")
			
			'1st column: donation items
			DIM IndexCol 
			IndexCol = 0
			
			'2nd column: ticket count
			DIM DiscCol 
			DiscCol = 1
			
			'Number of rows in table
			DIM rowCount 
			rowCount = uBound(IndexArr)

			'Resize table
			reDIM arrayTble(rowCount) 
			
			'Populate table
			For i = 0 to rowCount
				arrayTble(i) = array(CDbl(IndexArr(i)),CDbl(DiscArr(i)))
			Next
			
			'Sort table
			For col1 = UBound(arrayTble) - 1 To 0 Step -1
				For col2 = 0 To col1
					If arrayTble(col2)(0) > arrayTble(col2+1)(0) Then
						swap = arrayTble(col2)
						arrayTble(col2) = arrayTble(col2+1)
						arrayTble(col2+1) = swap
					End If
				Next
			Next
			
			'Determine past purchase history
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
				
		End If
		
	
		getMaxDisc = TicketCount

	End Function
	
	'--------------------------------------------------------

%>