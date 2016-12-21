<%
'CHANGE LOG
'SSR 4/10/13 - Create custom discount code

%>

<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'==================================================
'Academy of Dance and Performing Arts dba Worth Producing
'Parameters:
'Tiered Group Discount
'20 or more tickets = 10% off per-ticket
'40 or more tickets = 20% off per-ticket
'Automatic - Internet and Box Office
'No service fee change
'No expiration
'No ticket limit

'Seat map in programming; event not yet set up
'Contact
'Wendy Worth
'9086384880
'wendyworth@yahoo.com

'==================================================

DIM GroupCount(2)
GroupCount(1) = 20
GroupCount(2) = 40

DIM GroupPercentage(2)
GroupPercentage(1) = 10
GroupPercentage(2) = 20



If AllowDiscount = "Y" Then 
        		
	'Determine the number of tickets for each event on the order	
	SQLEventCount = "SELECT COUNT(Seat.EventCode) AS SeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Clean(Request("OrderNumber")) & " AND Seat.EventCode = " & Clean(Request("EventCode"))
	Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)
	TicketCount = rsEventCount("SeatCount")
	rsEventCount.Close
	Set rsEventCount = nothing
	
	ErrorLog("TicketCount " & TicketCount & "")
		
	If TicketCount >= GroupCount(1) Then
	
		If TicketCount >= GroupCount(1) And TicketCount <= (GroupCount(2) - 1) Then 
			Percentage = GroupPercentage(1)
		ElseIf TicketCount  >= GroupCount(2) Then 
			Percentage = GroupPercentage(2)
		End If

		NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(Percentage)/100), 2) 
		
		If Price > NewPrice Then
			DiscountAmount = Clean(Request("Price")) - NewPrice	
		End If
		
		AppliedFlag = "Y"

		If Request("NewSurcharge") <> "" Then
			Surcharge = NewSurcharge
		Else
			If Request("CalcServiceFee") <> "N" Then
				Surcharge = CalcCustomerFee(Clean(Request("OrganizationNumber")), Clean(Request("OrderTypeNumber")), NewPrice, EventCode, Clean(Request("ItemType")))
			End If
		End If	
		
	End If

End If

Response.Write "<NEWPRICE>" & NewPrice & "</NEWPRICE>" & vbCrLf
Response.Write "<DISCOUNTAMOUNT>" & DiscountAmount & "</DISCOUNTAMOUNT>" & vbCrLf
Response.Write "<SURCHARGE>" & Surcharge & "</SURCHARGE>" & vbCrLf
Response.Write "<APPLIEDFLAG>" & AppliedFlag & "</APPLIEDFLAG>" & vbCrLf



%>
