<%

'CHANGE LOG 
'SSR 1/31/2012 - Inception - Custom Survey
'SSR 5/29/2012 - Removed Call DBClose(OBJdbConnection)


%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'-------------------------------------------------

Page = "Survey"
SurveyNumber = 1203
SurveyFileName = "PastEventDiscount2012.asp"
BoxOfficeByPass = False
CompOrderByPass = True

'Default Options
'BoxOfficeByPass - False will display for box office orders
'CompOrderByPass - True will suppress for comp orders

'===============================================

'Chester Theatre Company (3/19/2013)
'2013 Season Subscription

'Complimentary Tickets with Event Purchase
'When patron buys a ticket to either of the two subscription events,
'they will receive a 100% discount on 1 ticket to each of the 4 productions
 
'EventCode		Name							
'----------		----------------------------------------------------------		
'558050 	 	2013 Weekday Season Subscription - Wednesday/Thursday/Friday Shows
'558051 	 	2013 Weekend Season Subscription - Saturdays/Sundays


'ActCode    Production
'-------	----------
'89688 	 	An Iliad
'89689 	 	Arms On Fire
'89691 	 	Body Awareness
'89687 	 	Tryst


'SeatCode   SeatType
'--------	----------
' 16        Individual


'Discount
'--------------------------- 
' 100% Discount on 1 ticket to each of the 4 productions.
' 



'==================================================

'Survey Variables

DiscountAmount = 1.0 

AllowedSeatType = 16

DiscountTypeNumber = 78582

Event1Code = 558050
Event2Code = 558051 
 
ActCodeList = "89688,89689,89691,89687"


'--------------------------------------------------------------
 
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


'ErrorLog("OrderNumber "&OrderNumber&" ")

'--------------------------------------------------------------

'Bypass this survey on all Comp Orders
'Bypass this survey for Box Office Users

Select Case Session("OrderTypeNumber") 
    Case 1
	    Call SurveyForm
    Case 5
		If CompByPass Then
			Call Continue
		Else
			Call SurveyForm
		End If
    Case Else
        If BoxOfficeByPass Then
	        Call Continue
        Else
			Call SurveyForm
		End If
End Select

'--------------------------------------------------------------

Sub SurveyForm

Call Event1Check

End Sub

'--------------------------------------------------------------

'Weekday Subscription - CHECK

Sub Event1Check

'Determine if patron has purchased the season ticket in current order

'Check if the member event code is in order
SQLEvent1Current = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber  INNER JOIN OrderHeader (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber WHERE EventCode = " & CleanNumeric(Event1Code) & " AND OrderLine.OrderNumber = " & CleanNumeric(Session("OrderNumber"))& " "
Set rsEvent1Current = OBJdbConnection.Execute(SQLEvent1Current)
    If Not rsEvent1Current.EOF Then 'it is in order
        Event1CurrentCount = rsEvent1Current("TicketCount")
    End If
rsEvent1Current.Close
Set rsEvent1Current = nothing


'Determine if patron has purchased the season ticket in the past

SQLEvent1Before = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE CustomerNumber = " & CleanNumeric(Session("CustomerNumber")) & " AND EventCode = " & CleanNumeric(Event1Code) & " AND OrderHeader.OrderNumber <> " & CleanNumeric(Session("OrderNumber")) & "" 
Set rsEvent1Before = OBJdbConnection.Execute(SQLEvent1Before)
    If Not rsEvent1Before.EOF Then
        Event1BeforeCount = rsEvent1Before("TicketCount")
    End If
rsEvent1Before.Close
Set rsEvent1Before = nothing


If Event1CurrentCount >= 1 Or Event1BeforeCount >= 1 Then 
    NumberFreeTickets = Event1CurrentCount + Event1BeforeCount
	Call Event1Discount(NumberFreeTickets)
Else
	Call Event2Check
End If


End Sub 'Event1Check

'-------------------------------------------------

'Weekend Subscription - CHECK

Sub Event2Check

'Determine if patron has purchased the season ticket in current order

'Check if the member event code is in order
SQLEvent2Current = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber  INNER JOIN OrderHeader (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber WHERE EventCode = " & CleanNumeric(Event2Code) & " AND OrderLine.OrderNumber = " & CleanNumeric(Session("OrderNumber"))& " "
Set rsEvent2Current = OBJdbConnection.Execute(SQLEvent2Current)
    If Not rsEvent2Current.EOF Then 'it is in order
        Event2CurrentCount = rsEvent2Current("TicketCount")
    End If
rsEvent2Current.Close
Set rsEvent2Current = nothing


'Determine if patron has purchased the season ticket in the past

SQLEvent2Before = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE CustomerNumber = " & CleanNumeric(Session("CustomerNumber")) & " AND EventCode = " & CleanNumeric(Event2Code) & " AND OrderHeader.OrderNumber <> " & CleanNumeric(Session("OrderNumber")) & "" 
Set rsEvent2Before = OBJdbConnection.Execute(SQLEvent2Before)
    If Not rsEvent2Before.EOF Then
        Event2BeforeCount = rsEvent2Before("TicketCount")
    End If
rsEvent2Before.Close
Set rsEvent2Before = nothing


If Event2CurrentCount >= 1 Or Event2BeforeCount >= 1 Then 
    NumberFreeTickets = Event2CurrentCount + Event2BeforeCount
	Call Event2Discount(NumberFreeTickets)
Else
	Call Continue
End If

End Sub 'Event2Check

'-------------------------------------------------

'Weekday Subscription - APPLY

Sub Event1Discount(NumberFreeTickets)

SeriesName = "Weekday Season Subscriber"
ProductionList = Split(ActCodeList,",")

For ActCd = lbound(ProductionList) to ubound(ProductionList)

    ApplyDiscountOK = false
    
    'Check if this production has given away free tickets before
    SQLDiscCheck = "SELECT OrderLine.LineNumber FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE CustomerNumber = " & CleanNumeric(Session("CustomerNumber")) & " AND ActCode = " & CleanNumeric(ProductionList(ActCd)) & " AND OrderHeader.OrderNumber <> " & CleanNumeric(Session("OrderNumber")) & " AND (DATEPART(WEEKDAY, Event.Eventdate)) IN (2,3,4,5,6)"
    Set rsDiscCheck = OBJdbConnection.Execute(SQLDiscCheck)
    
    If rsDiscCheck.EOF Then 
        ApplyDiscountOK = true
    End If
    
    rsDiscCheck.Close
    Set rsDiscCheck = Nothing
    
    If ApplyDiscountOK Then 'it is okay to give free tickets
    
        SQLLineNo = "SELECT TOP(" & NumberFreeTickets & ") LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN EVENT (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND ActCode = " & ProductionList(ActCd) & " AND (DATEPART(WEEKDAY, Event.Eventdate)) IN (2,3,4,5,6) ORDER BY LineNumber DESC"
        Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)
        
        If Not rsLineNo.EOF Then
        
            Do While Not rsLineNo.EOF
                SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = Price * " & DiscountAmount & ", Surcharge = 0, DiscountTypeNumber = " & DiscountTypeNumber & " WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber")
                Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
                rsLineNo.movenext
            Loop
            
        End If
        
        rsLineNo.Close
        Set rsLineNo = Nothing
        
    End If
    
Next

'Call DBClose(OBJdbConnection)


Call Event2Check


End Sub 'ApplyMemberEvent1

'-------------------------------------------------

'Weekend Subscription - APPLY

Sub Event2Discount(NumberFreeTickets)

SeriesName = "Weekend Season Subscriber"
ProductionList = Split(ActCodeList,",")

For ActCd = lbound(ProductionList) to ubound(ProductionList)

    ApplyDiscountOK = false
    
    'Check if this production has given away free tickets before
    SQLDiscCheck = "SELECT OrderLine.LineNumber FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE CustomerNumber = " & CleanNumeric(Session("CustomerNumber")) & " AND ActCode = " & CleanNumeric(ProductionList(ActCd)) & " AND OrderHeader.OrderNumber <> " & CleanNumeric(Session("OrderNumber")) & " AND (DATEPART(WEEKDAY, Event.Eventdate)) IN (1,7)"
    Set rsDiscCheck = OBJdbConnection.Execute(SQLDiscCheck)
    
    If rsDiscCheck.EOF Then 
        ApplyDiscountOK = true
    End If
    
    rsDiscCheck.Close
    Set rsDiscCheck = Nothing
    
    If ApplyDiscountOK Then 'it is okay to give free tickets
    
        SQLLineNo = "SELECT TOP(" & NumberFreeTickets & ") LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN EVENT (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND ActCode = " & ProductionList(ActCd) & " AND (DATEPART(WEEKDAY, Event.Eventdate)) IN (1,7) ORDER BY LineNumber DESC"
        Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)
        
        If Not rsLineNo.EOF Then
        
            Do While Not rsLineNo.EOF
                SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = Price * " & DiscountAmount & ", Surcharge = 0, DiscountTypeNumber = " & DiscountTypeNumber & " WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber")
                Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
                rsLineNo.movenext
            Loop
            
        End If
        
        rsLineNo.Close
        Set rsLineNo = Nothing
        
    End If
    
Next

'Call DBClose(OBJdbConnection)

Call Continue

End Sub 'Event2Discount

'---------------------------------------------------------------

Sub Continue
				
Session("SurveyComplete") = Session("OrderNumber")
If Session("UserNumber") = "" Then
	Response.Redirect("/Ship.asp")
Else
	Response.Redirect("/Management/AdvanceShip.asp")
End If		

End Sub 'Continue

'-------------------------------------------------

%>