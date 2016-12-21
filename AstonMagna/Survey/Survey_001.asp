<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%
Page = "Survey"

SurveyNumber = 374

'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If

'Check to make sure the subscription event 131241 is in the shopping cart
SQLSubEvent = "SELECT Seat.EventCode FROM Seat (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON Seat.OrderNumber = OrderHeader.OrderNumber INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber WHERE OrderHeader.OrderNumber = " & CleanNumeric(Session("OrderNumber")) & " AND OrderLine.OrderNumber = " & CleanNumeric(Session("OrderNumber")) & " AND Seat.OrderNumber = " & CleanNumeric(Session("OrderNumber")) & " AND Seat.EventCode = 131241 AND OrderLine.ItemType = 'SubFixedEvent'"
Set SubEvent = OBJdbConnection.Execute(SQLSubEvent)
If Not SubEvent.EOF Then  
    Call ApplyDiscount    
Else
    Call Continue
End If

'==============================

Sub ApplyDiscount

'Get all OrderLines on order that are one of the six subscription events
'SQLOrderLine = "SELECT OrderLine.LineNumber, Event.EventCode FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.Discount = 0 AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') AND Event.SurveyNumber = " & SurveyNumber & " AND Seat.EventCode IN(127231, 127232, 127233, 127234, 127235, 127236) ORDER BY OrderLine.LineNumber"
SQLOrderLine = "SELECT OrderLine.LineNumber, Seat.EventCode FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & CleanNumeric(Session("OrderNumber")) & " AND Seat.EventCode IN(127231, 127232, 127233, 127234, 127235, 127236) AND OrderLine.ItemType = 'Seat' AND OrderLine.SeatTypeCode = 16"
Set rsOrderLine = OBJdbConnection.Execute(SQLOrderLine)

Call DBOpen(OBJdbConnection2)

Do Until rsOrderLine.EOF
    EventCode = rsOrderLine("EventCode")
    
    SQLPrice = "SELECT Price, Surcharge, BoxOfficeSurcharge FROM Price (NOLOCK) WHERE EventCode = " & EventCode & " AND SectionCode = 'GA' AND SeatTypeCode = 16"
    Set rsPrice = OBJdbConnection2.Execute(SQLPrice)
	'Price = rsPrice("Price")
    Surcharge = rsPrice("BoxOfficeSurcharge")
	rsPrice.Close
    Set rsPrice = nothing
    'discount $5 from an individual ticket price
    DiscountAmount = 5
	SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = " & DiscountAmount & ", Surcharge = " & Surcharge & ", DiscountTypeNumber = 28940 WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLine("LineNumber")
	Set rsApplyDiscount = OBJdbConnection2.Execute(SQLApplyDiscount)
	
	rsOrderLine.MoveNext
Loop

Call DBClose(OBJdbConnection2)

rsOrderLine.Close
Set rsOrderLine = nothing

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

