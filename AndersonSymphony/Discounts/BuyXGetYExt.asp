<%

'CHANGE LOG

'SSR 11/24/14	'Created extended BuyXGetY discount based on the generic BuyXGetY discount currently in use.

				'5 Required Parameters:  
				'(1) Adult ticket types:  &AdultSeatType=54126,65545&
				'(2) Adult tickets to purchase: &AdultQty=1
				'(3) Child ticket types: &ChildSeatType=54146
				'(4) Child tickets to discount: &ChildQty=1
				'(5) Discount type (Percentage, Discount Amount, Fixed Price) 
		
'SSR 08/31/15 - Updated generic discount script to allow additional tickets to be discounted. 
				'Parameter: AllowDiscAddTicket=Y
				
%>

<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'---------------------------------------------------------

'Initialize Discount Variables

DIM ChildSeatType
ChildSeatType = Clean(Request("ChildSeatType"))

'ErrorLog("ChildSeatType: " & ChildSeatType& "")

DIM ChildQty
ChildQty = Clean(Request("ChildQty"))

DIM TicketCount 
TicketCount = 0

'---------------------------------------------------------

	'Multi Event Option
		
	AllowMultiEvent = "N"

	If Clean(Request("AllowMultiEvent")) = "Y" Then
		SQLMultiEvent = ""
	Else
		SQLMultiEvent = " AND Seat.EventCode = " & Clean(Request("EventCode")) & ""
	End If

'---------------------------------------------------------

	'Required Seat Type Code

	If Clean(Request("RequiredSeatTypeCode")) <> "" Then
		SQLSeatType = "AND OrderLine.SeatTypeCode IN (" & Request("RequiredSeatTypeCode") & ")"
	End If
	
	ErrorLog("RequiredSeatTypeCode: " & RequiredSeatTypeCode & "")

'---------------------------------------------------------

	'Required Seat Type Count

	If Clean(Request("RequiredSeatCount")) <> "" Then
		RequiredSeatCount = Request("RequiredSeatCount")
	End If
	
	ErrorLog("RequiredSeatCount: " & RequiredSeatCount & "")

'---------------------------------------------------------

	'Allow discount on additional tickets
	
	DIM AllowDiscAddTicket
	AllowDiscAddTicket  = FALSE
	
	If Clean(Request("AllowDiscAddTicket")) = "Y" Then
		AllowDiscAddTicket =  TRUE
	End If
	
	ErrorLog("AllowDiscAddTicket: " & AllowDiscAddTicket & "")

'---------------------------------------------------------


	If AllowDiscount = "Y" Then 'It's okay to apply to this order.
	
		SQLEventCount = "SELECT COUNT(*) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & SQLMultiEvent & SQLSeatType & ""
		Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)

			If Not rsEventCount.EOF Then
			
				GroupCount = rsEventCount("SeatCount")
				
			End If
			
		rsEventCount.Close
		Set rsEventCount = nothing	

		ErrorLog("GroupCount  " & GroupCount & "")		
	
		SQLEventCount = "SELECT COUNT(*) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & SQLMultiEvent & SQLSeatType & ""
		Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)
		
			ErrorLog("TicketCount " & rsEventCount("TicketCount") & "")
		
			Call ProcessDiscount
			Call ProcessSurcharge
			
		rsEventCount.Close
		Set rsEventCount = nothing	

	End If	

	Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
	Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
	Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
	Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf

'-----------------------------------------------------------------

	Sub ProcessDiscount

		NewPrice = 1
		
		DiscountAmount = Round(Clean(Request("Price")),2) - NewPrice
			
		AppliedFlag = "Y"
		
	End Sub

'-----------------------------------------------------------------

	Sub ProcessSurcharge

		If AppliedFlag = "Y" Then

			If NewSurcharge <> "" Then
				Surcharge = NewSurcharge
			ElseIf Request("CalcServiceFee") <> "N" Then
				Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
			End If
			
		End If
			
	End Sub
	
'-----------------------------------------------------------------


%>