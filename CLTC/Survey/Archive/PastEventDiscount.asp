<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%
Page = "Survey"

SurveyNumber = 959

DiscountTypeNumber = 56975
DiscountAmount = 10

'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If

'Check to see if this is a Comp Order or Date is before May 2011. If so, skip discount.
If Session("OrderTypeNumber") = 5 Or FormatDateTime(Now(), vbShortDate) > "4/30/2011" Then
	Call Continue
End If


'Check for a Compleat Beauty ticket on current order or on any other order in the past year
SQLActEvent = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderHeader (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE Event.ActCode = 55353 AND OrderHeader.StatusCode = 'S' AND CustomerNumber = " & Session("CustomerNumber") & " AND OrderLine.OrderNumber <> " & Session("OrderNumber")
Set rsActEvent = OBJdbConnection.Execute(SQLActEvent)
ActEventCount = rsActEvent("TicketCount")
rsActEvent.Close
Set rsActEvent = nothing

If ActEventCount > 0 Then 
	Call ApplyDiscount
Else
	Call Continue
End If


'==============================

Sub ApplyDiscount

SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = " & DiscountAmount & ", DiscountTypeNumber = " & DiscountTypeNumber & " WHERE OrderNumber = " & Session("OrderNumber") & " AND OrderLine.ItemNumber IN (SELECT ItemNumber FROM Seat (NOLOCK) WHERE Seat.EventCode IN (300270,300271,300272,300280,300273,300274,300275,300281))"
Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)

Call DBClose(OBJdbConnection)
	
Call Continue

End Sub 'ApplyDiscount

'==============================

Sub Continue
				
Session("SurveyComplete") = Session("OrderNumber")
If Session("UserNumber") = "" Then
	Response.Redirect("/Ship.asp")
Else
	Response.Redirect("/Management/AdvanceShip.asp")
End If		

End Sub 'Continue

'==============================

%>

