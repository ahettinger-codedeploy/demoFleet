<%

'CHANGE LOG - Inception
'SSR 6/27/2013 - Past Donation Discount created
'SSR 6/28/2013 - Updated

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->

<%

'============================================================

Page = "Survey"
SurveyNumber = 1508
SurveyFileName = "PastDonationDiscount.asp"

'============================================================

'Fort Lewis College
'Past Donation Discount

'Patron receives discount based on membership/donation level purchased:

'Patron has membership/donation item in current order  or
'Patron has purchased membership/donation between July 1, 2013 and June 30, 2014.

'Item   Type                Benefit
'----------------------------------------------------------
'4258	Orchestra Level     10% discount on all tickets        
'4261	Star Level     		15% discount on all tickets 


'Discount Type Number assigned to donation level

'Number     'Description          
'---------------------------------
'81649	    Membership Discount

'Note: This discount is a 0% discount place holder discount code.
'Attached as an automatic discount to the events for use as a survey clear                

           
'Restrictions
'---------------------------------------
'Valid for any ticket type, any event
'Available for both online and offline orders
'Discount has no expiration date
'Unlimited number of discounts allowed
'Automatic discount
'No change to service fees

'---------------------------------------------------------------

DiscountTypeNumber = 81649


'Donation Levels
ItemNumberList = "4258,4261"


'Valid Dates
StartDate = "6/1/2013"
EndDate = "6/30/2014"

'---------------------------------------------------------
 
'Check to see if Order Number exists.
'Display management tabs for box office orders

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

'---------------------------------------------------------

'Bypass this survey on Comp Orders

If Session("OrderTypeNumber") = 5 Then
	Call Continue
End If

'---------------------------------------------------------

'Request the form name and process requested action

Select Case Clean(Request("FormName"))
    Case "Continue"
        Call Continue
    Case Else
        Call MemberCheck
 End Select
 

'---------------------------------------------------------

Sub MemberCheck


DonationFound = False

'Check for donations in current order
SQLMemberCurrent = "SELECT OrderLine.ItemNumber FROM OrderLine (NOLOCK) WHERE OrderLine.ItemNumber IN (" & ItemNumberList & ") AND OrderLine.OrderNumber = " & CleanNumeric(Session("OrderNumber"))
Set rsMemberCurrent = OBJdbConnection.Execute(SQLMemberCurrent)
If Not rsMemberCurrent.EOF Then 'it is in order
    DonationFound = True
    DonationItemNo = rsMemberCurrent("ItemNumber")
End If
rsMemberCurrent.Close
Set rsMemberCurrent = nothing


'Check for donations in past orders for past year
SQLMemberPrevious = "SELECT OrderLine.ItemNumber, OrderHeader.OrderDate FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE CustomerNumber = " & CleanNumeric(Session("CustomerNumber")) & " AND OrderLine.ItemNumber IN (" & ItemNumberList & ") AND OrderHeader.OrderNumber <> " & CleanNumeric(Session("OrderNumber")) & " ORDER BY OrderLine.ItemNumber"
Set rsMemberPrevious = OBJdbConnection.Execute(SQLMemberPrevious)


If Not rsMemberPrevious.EOF Then

	If rsMemberPrevious("OrderDate") > CDate(StartDate) Then
	
		If rsMemberPrevious("OrderDate") < CDate(EndDate) Then

			DonationFound = True
			DonationItemNo = rsMemberPrevious("ItemNumber")
		
		End If
		
	End If

End If

rsMemberPrevious.Close
Set rsMemberPrevious = nothing


If DonationFound Then 
	Call ApplyDiscount (DonationItemNo)
Else
	Call Continue
End If


End Sub 'MemberCheck

'---------------------------------------------------------

Sub ApplyDiscount (DonationItemNo)

DiscountTicketCount = 0

'Remove other discounts from this order
SQLDiscLine = "SELECT LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " ORDER BY LineNumber"
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

SQLFreeTickets  = "SELECT OrderLine.ItemNumber FROM OrderHeader (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber WHERE (OrderLine.ItemNumber IN (" & ItemNumberList & ")) AND (CustomerNumber = " & Session("CustomerNumber") & " AND OrderHeader.StatusCode = 'S' OR OrderHeader.OrderNumber = " & Session("OrderNumber") & ") ORDER BY LineNumber"
Set rsFreeTickets   = OBJdbConnection.Execute(SQLFreeTickets)

DonationItem = rsFreeTickets("ItemNumber")

If Not rsFreeTickets.EOF Then

    Select Case rsFreeTickets("ItemNumber")
        Case 4258	    
        DonationDescription = "Orchestra Level Membership"
		DonationPercentage = .10
        Case 4261
        DonationDescription = "Star Level Membership"
		DonationPercentage  = .15
    End Select

End If

rsFreeTickets.Close
Set rsFreeTickets = Nothing  

	'Apply the discount for this membership level
	SQLLineNo = "SELECT LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN EVENT (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & "  ORDER BY LineNumber DESC"
	Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)
			
	If Not rsLineNo.EOF Then                
		Do While Not rsLineNo.EOF
		
			NewPrice = round(CDbl(Clean(Request("Price"))) * (1-CDbl(DonationPercentage)/100), 2)
			
			ErrorLog ("Current Price" & Price & "")
			ErrorLog ("NewPrice" & NewPrice & "")
			ErrorLog ("New DonationPercentage " & DonationPercentage & "")
			
			SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = Price * " & DonationPercentage & ", Surcharge = 0, DiscountTypeNumber = " & DiscountTypeNumber & " WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber")
			Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
			DiscountTicketCount = DiscountTicketCount + 1
			AppliedFlag = "Y"
			rsLineNo.movenext

		Loop
	End If

	rsLineNo.Close
	Set rsLineNo = Nothing

Call DBClose(OBJdbConnection)

Call Continue

End Sub 

'---------------------------------------------------------

Sub Continue
				
Session("SurveyComplete") = Session("OrderNumber")

If Session("UserNumber") = "" Then
	Response.Redirect("/Ship.asp")
Else
	Response.Redirect("/Management/AdvanceShip.asp")
End If		

End Sub 

'---------------------------------------------------------

%>

