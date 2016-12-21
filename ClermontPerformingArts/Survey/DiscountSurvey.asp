<%
    'CHANGE LOG
    'TTT 1/20/15 - Created custom survey to call custom discount
    'TTT 1/26/15 - Modified to set appropriate values to track RefundOrderLine records
	'SSR 2/27/15 - Updated to pass Customer Number
	'SSR 3/27/15 - Updated for Flager
	
%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<!--#INCLUDE VIRTUAL="/Discounts/ApplyDiscountInclude.asp"-->

<%

'Include 'ApplyDiscountInclude.asp' above to call discount subroutine from this survey
Page = "Survey"

DIM SurveyNumber 
SurveyNumber = 1895

DIM DiscountTypeNumber
DiscountTypeNumber =  117313

DIM DiscountCode
DiscountCode = ""

'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If


If IsNumeric(Session("CustomerNumber")) Then
	SQLUpdateOrderHeader = "UPDATE OrderHeader WITH (ROWLOCK) SET OrderHeader.CustomerNumber = " & Session("CustomerNumber") & " WHERE OrderHeader.CustomerNumber = 1 AND OrderHeader.OrderNumber = " & Session("OrderNumber") & ""
	Set rsUpdateOrderHeader = OBJdbConnection.Execute(SQLUpdateOrderHeader)
End If


SQLDiscountCode = "SELECT DiscountCode FROM DiscountType (NOLOCK) WHERE DiscountTypeNumber = 117313"
Set rsDiscountCode = OBJdbConnection.Execute(SQLDiscountCode)
	If Not rsDiscountCode.EOF Then
	
		DiscountCode = rsDiscountCode("DiscountCode")

		If DiscountCode <> "" Then
			'Loop through all seats for this Survey
			Call DBOpen(OBJdbConnection2)
			SQLOrderLine = "SELECT Price, Surcharge, Event.EventCode, LineNumber, SeatTypeCode, SectionCode, ItemType, DiscountTypeNumber, Discount FROM Seat (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND (OrderLine.ItemType = 'Seat' OR OrderLine.ItemType = 'SubFixedEvent') AND Event.SurveyNumber = " & SurveyNumber & " ORDER BY Price DESC"
			Set rsOrderLine = OBJdbConnection2.Execute(SQLOrderLine)
			Do While Not rsOrderLine.EOF
				Price = Round(rsOrderLine("Price"),2)
				Surcharge = Round(rsOrderLine("Surcharge"),2)
				SeatTypeCode = rsOrderLine("SeatTypeCode")
				DiscountAmount = rsOrderLine("Discount")
				DiscountTypeNumber = rsOrderLine("DiscountTypeNumber")
				AppliedFlag = "N"

				'REE 3/11/3 - Added SeatType to passed parameters.
				Call Discount(Session("OrderNumber"), rsOrderLine("LineNumber"), rsOrderLine("EventCode"), Clean(DiscountCode), Price, Surcharge, SeatTypeCode, DiscountAmount, DiscountTypeNumber, AppliedFlag, rsOrderLine("SectionCode"), rsOrderLine("ItemType"))
		
				rsOrderLine.MoveNext
			Loop 
			rsOrderLine.Close
			Set rsOrderLine = nothing
			Call DBClose(OBJdbConnection2)
		End If
		
	End If
rsDiscountCode.Close
Set rsDiscountCode = Nothing

UpdateOrderHeaderTotals(Session("OrderNumber"))

If Session("OrderNumber") <> "" Then

	If Session("UserNumber") = "" Then
		'REE 4/19/3 - Modified to use Session Variable for SurveyComplete
		Session("SurveyComplete") = Session("OrderNumber")
		Response.Redirect("Ship.asp")
	Else
		'REE 4/19/3 - Modified to use Session Variable for SurveyComplete
		Session("SurveyComplete") = Session("OrderNumber")
		Response.Redirect("/Management/AdvanceShip.asp")
	End If
		
Else 'No Session Order Number
	
	If Session("UserNumber") = "" Then
		Session.Contents.Remove("OrderNumber") 
		OBJdbConnection.Close
		Set OBJdbConnection = nothing
		Response.Redirect("/Default.asp")
	Else
		Session.Contents.Remove("OrderNumber") 
		OBJdbConnection.Close
		Set OBJdbConnection = nothing
		Response.Redirect("http://" & Request.ServerVariables("SERVER_NAME") & "/Management/ClearOrderNumber.asp")
	End If

End If

%>


