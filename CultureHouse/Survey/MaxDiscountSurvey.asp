<%

'CHANGE LOG - Inception
'SSR 4/20/2011
'Discount Code Restriction
'Survey Created 

%>

<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'===============================================

Page = "Survey"
SurveyNumber = 1111
SurveyFileName = "MaxDiscountSurvey.asp"

'===============================================

'The Culture House

'Discount Code Restriction Survey
'The listed discount code will only give 2 discounted tickets per customer

'===============================================

'Initialize Survey Variables

'Discount Code Name
DiscountCodeName = "Storlingx2"

'Discount Code Number
DiscountCodeNumber = "60943" 

'Discount Percentage Amount
DiscountAmount = 1.0

'Maximum Discount Code Use
DiscountCodeMax = "2"

'===============================================

'Check to see if Order Number exists.  If not, redirect to Home Page.
'Check to see if box office order or online order

If Session("OrderNumber") = "" Then

	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
    Else
		Response.Redirect("/Management/Default.asp")
	End If
	
Else

	If Session("UserNumber") = "" Then
        Page = "Survey"
	Else
	    Page = "Management"
	End If
	
End If

'===============================================

'Check to see if this is a Comp Order. If so, bypass this survey.

If Session("OrderTypeNumber") = 5 Then
	Call Continue
Else
	Call CheckCurrentOrder
End if

'===============================================

Sub CheckCurrentOrder

'Check if there is a discount code to the current order
'------------------------------------------------------
SQLCurrentDiscount = "SELECT OrderLine.DiscountTypeNumber FROM OrderLine (NOLOCK) WHERE OrderLine.DiscountTypeNumber IN (" & DiscountCodeNumber & ") AND OrderLine.OrderNumber = " & CleanNumeric(Session("OrderNumber"))
Set rsCurrentDiscount = OBJdbConnection.Execute(SQLCurrentDiscount)

    If Not rsCurrentDiscount.EOF Then 
		    CurrentDiscountFound = True
		    CurrentDiscountTypeNumber = rsCurrentDiscount("DiscountTypeNumber")
    End If

rsCurrentDiscount.Close
Set rsCurrentDiscount = nothing


'If discount found on order proceed to check past order otherwise bypass restriction 
'------------------------------------------------------

If CurrentDiscountFound Then 
	Call CheckPastOrders(CurrentDiscountTypeNumber)
Else
	Call Continue
End If


End Sub 'CheckCurrentOrder

'=============================================

Sub CheckPastOrders(CurrentDiscountTypeNumber)

'Check if customer has used this discount code before
'------------------------------------------------------
SQLPastDiscount = "SELECT OrderLine.DiscountTypeNumber FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE CustomerNumber = " & CleanNumeric(Session("CustomerNumber")) & " AND OrderLine.DiscountTypeNumber = " & CurrentDiscountTypeNumber & " AND OrderHeader.OrderNumber <> " & CleanNumeric(Session("OrderNumber")) & " ORDER BY OrderLine.DiscountTypeNumber"
Set rsPastDiscount = OBJdbConnection.Execute(SQLPastDiscount)

If Not rsPastDiscount.EOF Then
    PastDiscountFound = True
End If

rsPastDiscount.Close
Set rsPastDiscount = nothing

'If discount found on past orders proceed to apply discount otherwise bypass restriction
'------------------------------------------------------
If PastDiscountFound Then 
	Call ApplyDiscount(CurrentDiscountTypeNumber)
Else
	Call Continue
End If


End Sub 'CheckPastOrders

'=============================================

Sub ApplyDiscount(CurrentDiscountTypeNumber)

AppliedCount = 0
DiscountApplied = "N"


'Remove the discount from this order
'---------------------------------------
SQLDiscLine = "SELECT LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.ItemType IN ('Seat','SubFixedEvent') ORDER BY LineNumber"
Set rsDiscLine = OBJdbConnection.Execute(SQLDiscLine)

If Not rsDiscLine.EOF Then
    Do While Not rsDiscLine.EOF
    
        SQLClearDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = 0, DiscountTypeNumber = 0 WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsDiscLine("LineNumber")
        Set rsClearDiscount = OBJdbConnection.Execute(SQLClearDiscount)
        
    rsDiscLine.movenext
    Loop
End If

rsDiscLine.Close
Set rsDiscLine = Nothing  


'Determine the number of tickets for which this customer has already received a discount
'---------------------------------------------------------------------------------------
'Determine number of free tickets already given
SQLApplied = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE OrderHeader.CustomerNumber = " & Session("CustomerNumber") & " AND OrderLine.DiscountTypeNumber = " & DiscountCodeNumber & " AND OrderLine.StatusCode = 'S'"
Set rsApplied = OBJdbConnection.Execute(SQLApplied)
AppliedTicketCount = rsApplied("TicketCount")
rsApplied.Close
Set rsApplied = nothing

RemainingTickets = (DiscountCodeMax - AppliedTicketCount)
    
If CInt(RemainingTickets) > 0 Then 'It is ok to give further discounts

				SQLLineNo = "SELECT TOP(" & RemainingTickets & ") LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " ORDER BY LineNumber"
				Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)

				If Not rsLineNo.EOF Then
							Do While Not rsLineNo.EOF
									SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = (Price * " & DiscountAmount & "), Surcharge = 0, DiscountTypeNumber = " & CurrentDiscountTypeNumber & " WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber")& ""
									Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
									DiscountApplied = "Y"
									rsLineNo.movenext
							Loop
				End If

				rsLineNo.Close
				Set rsLineNo = Nothing
				        
				If DiscountApplied = "Y" Then
					Call Continue
				Else
					Call Continue
				End If


Else
    Call Continue
End If


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