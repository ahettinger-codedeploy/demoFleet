
<%

'CHANGE LOG
'SSR 05/13/2014 - Created survey to adjust service fees.

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->


<%

'---------------------------------------

'Tower Theater

'If total sale is $85 and under, we attach a $3.00 per ticket fee to the first ticket on the order. 
'If total sale is over $85, then we attach a per ticket fee (for each ticket) that is equal to 3.5% of the ticket price.

Page = "Survey"
SurveyNumber = 1670
SurveyName = "ServiceFee.asp"

MaxOrderAmount = 85

FeeAmountCount = 1
FeeAmount = 3

FeePercentage = 3.5

'---------------------------------------

'Check to see if Order Number exists.  
'If not, redirect to Home Page.

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

Call SurveyForm

'---------------------------------------

Sub SurveyForm

	SQLOrderTotal = "SELECT SUM(OrderLine.Price) AS OrderAmount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & ""
	Set rsOrderTotal = OBJdbConnection.Execute(SQLOrderTotal)
		TotalOrderAmount = rsOrderTotal("OrderAmount")
	rsOrderTotal.Close
	Set rsOrderTotal = nothing

	If TotalOrderAmount > MaxOrderAmount Then
	
		'Apply the new surcharge to all tickets
		'--------------------------------------
		SQLLineNo = "SELECT LineNumber, Price, Surcharge FROM OrderLine (NOLOCK) WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " ORDER BY LineNumber DESC"
		Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)
			If Not rsLineNo.EOF Then                
				Do While Not rsLineNo.EOF								
					NewSurcharge = rsLineNo("Price") - (round(CDbl(rsLineNo("Price")) * (1-CDbl(FeePercentage)/100), 2))			
					SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Surcharge = " & NewSurcharge & " WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber")
					Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
					rsLineNo.movenext						
				Loop
			End If
		rsLineNo.Close
		Set rsLineNo = Nothing
     
	Else
	
		'Reset all ticket fees to 0
		'---------------------------
		SQLDiscLine = "SELECT LineNumber FROM OrderLine (NOLOCK) WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " ORDER BY LineNumber"
		Set rsDiscLine = OBJdbConnection.Execute(SQLDiscLine)
			If Not rsDiscLine.EOF Then
				Do While Not rsDiscLine.EOF
					SQLClearDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Surcharge = 0 WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsDiscLine("LineNumber")
					Set rsClearDiscount = OBJdbConnection.Execute(SQLClearDiscount)
				rsDiscLine.movenext
				Loop
			End If
		rsDiscLine.Close
		Set rsDiscLine = Nothing
		
		
		'Apply the new surcharge to one ticket
		'--------------------------------------
		SQLLineNo = "SELECT  TOP " & FeeAmountCount & " LineNumber FROM OrderLine (NOLOCK) WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " ORDER BY LineNumber DESC"
		Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)
			If Not rsLineNo.EOF Then                								
					NewSurcharge = FeeAmount			
					SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Surcharge = " & NewSurcharge & " WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber")
					Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
			End If
		rsLineNo.Close
		Set rsLineNo = Nothing
	
	End If
      
	Call Continue
	
End Sub 'ApplyDiscount


'---------------------------

Sub Continue
    Session("SurveyComplete") = Session("OrderNumber")
    If Session("UserNumber") = "" Then
	    Response.Redirect("/Ship.asp")
    Else
	    Response.Redirect("/Management/AdvanceShip.asp")
    End If
End Sub 'Continue

'---------------------------

%>

