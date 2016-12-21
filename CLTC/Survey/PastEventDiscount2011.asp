<%

'CHANGE LOG - Inception
'SSR 6/08/2011
'Custom Discount

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->

<%

'============================================================

Page = "Survey"

SurveyNumber = 1038

SurveyFileName = "PastEventDiscount2011.asp"

DiscountTypeNumber = 56975

'With Past Purchase of Distracted ticket
RequiredActCode = 55354 

'Get Discount Amount on Nine ticket for these events
OfferEventList = "300316,300317,300318,300329,300319,300320,300321,300322,300330"

DiscountAmount = 10

ExpirationDate = CDate("6/30/2011") 

'============================================================


'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If


If Session("OrderTypeNumber") = 5 Then
	Call Continue
End If


If Now() > ExpirationDate Then
    Call Continue
Else
    Call SurveyForm
End If

'============================================================

Sub SurveyForm

'Check for a ticket to the required act on a past order. 
SQLActEvent = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderHeader (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE Event.ActCode = " & RequiredActCode & " AND OrderHeader.StatusCode = 'S' AND CustomerNumber = " & Session("CustomerNumber") & " AND OrderLine.OrderNumber <> " & Session("OrderNumber") & ""
Set rsActEvent = OBJdbConnection.Execute(SQLActEvent)
    If Not rsActEvent.EOF Then 'it is in order
        TicketFound = True
    End If
rsActEvent.Close
Set rsActEvent = nothing

If TicketFound Then
    Call ApplyDiscount
Else
    Call Continue
End If

End Sub 'SurveyForm

'============================================================

Sub ApplyDiscount

SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = " & DiscountAmount & ", DiscountTypeNumber = " & DiscountTypeNumber & " WHERE OrderNumber = " & Session("OrderNumber") & " AND OrderLine.ItemNumber IN (SELECT ItemNumber FROM Seat (NOLOCK) WHERE Seat.EventCode IN (" & OfferEventList & "))"
Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)

Call DBClose(OBJdbConnection)
	
Call Continue

End Sub 'ApplyDiscount

'============================================================

Sub Continue
				
Session("SurveyComplete") = Session("OrderNumber")
If Session("UserNumber") = "" Then
	Response.Redirect("/Ship.asp")
Else
	Response.Redirect("/Management/AdvanceShip.asp")
End If		

End Sub 'Continue

'============================================================

%>

