<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%

Page = "Survey"
SurveyNumber = 948
SurveyFileName = "PastEventDiscount2011.asp"

'===============================================
'Chester Theatre Company (2/3/2011)
'2011 Season Subscription

'Ticket Discount with Past Event Purchase
'If Patron buys (or has purchased) one of the four Season Ticket events
'they are entited to free tickets from the list of valid productions.


' Valid Season Productions
'-------------------------
'ActCode    ActName
'59293      pride@prejudice
'59402	    Crime and Punishment
'59406      The Turn Of The Screw
'59407      Wittenberg


' Valid Seat Types
'------------------
'SeatCode   SeatType
' 16        Individual


' Valid Member Events
'-------------------------
' (1) Weekday Season Subscription  Event1Code: 334517
' Patron is entitled to 1 ticket to each of the 4 season productions.
' Valid only for Wednesday, Thursday or Friday performances. 


' (2) Weekend Season Subscription  Event2Code: 334518  
' Patron is entitled to 1 ticket to each of the 4 season productions.
' Valid only for Saturday or Sunday performances.


' (3) Weekday Flex Pass  Event3Code: 334516
' Patron is entitled to 6 tickets to any of the season productions.
' Tickets can be used in any combination 
' Valid only for Wednesday, Thursday or Friday performances.  


' (4) Anyday Flex Pass  Event4Code: 334515  
' Patron is entitled to 6 tickets to any of the season productions.
' Tickets can be used in any combination 
' Valid for any performance

'===================================
'Survey Variables

DiscountAmount = 1.0 
AllowedSeatType = "16"
DiscountTypeNumber = 54138

Event1Code = "334517" 
Event2Code = "334518" 
Event3Code = "334516"  
Event4Code = "334515" 

Event3Count = 6
Event4Count = 6
 
ActCodeList = "59293,59402,59406,59407"

'===================================

If Session("UserNumber")<> "" Then
TableCategoryBGColor = "#008400"
TableCategoryFontColor = "FFFFFF"
TableColumnHeadingBGColor = "99CC99"
TableColumnHeadingFontColor = "000000"
TableDataBGColor = "E9E9E9"
ClientFolder= "Tix"
Else
ClientFolder = "ChesterTheatre"
End If

'===================================

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


'Check to see if this is a Comp Order. If so, skip the survey.
If Session("OrderTypeNumber") = 5 Then
	Call Continue
End If


If Clean(Request("FormName")) = "Continue" Then    
    Call Continue    
Else
   Call Event1Check    
End If


'===================================
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

'===================================
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
	Call Event3Check
End If


End Sub 'Event2Check

'===================================
'Weekday Flex Pass - CHECK

Sub Event3Check

'Determine if patron has purchased the season ticket in current order

'Check if the member event code is in order
SQLEvent3Current = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber  INNER JOIN OrderHeader (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber WHERE EventCode = " & CleanNumeric(Event3Code) & " AND OrderLine.OrderNumber = " & CleanNumeric(Session("OrderNumber"))& " "
Set rsEvent3Current = OBJdbConnection.Execute(SQLEvent3Current)
    If Not rsEvent3Current.EOF Then 'it is in order
        Event3CurrentCount = rsEvent3Current("TicketCount")
    End If
rsEvent3Current.Close
Set rsEvent3Current = nothing

'Determine if patron has purchased the season ticket in the past

SQLEvent3Before = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE CustomerNumber = " & CleanNumeric(Session("CustomerNumber")) & " AND EventCode = " & CleanNumeric(Event3Code) & " AND OrderHeader.OrderNumber <> " & CleanNumeric(Session("OrderNumber")) & "" 
Set rsEvent3Before = OBJdbConnection.Execute(SQLEvent3Before)
    If Not rsEvent3Before.EOF Then
        Event3BeforeCount = rsEvent3Before("TicketCount")
    End If
rsEvent3Before.Close
Set rsEvent3Before = nothing

If Event3CurrentCount >= 1 Or Event3BeforeCount >= 1 Then 
	Call Event3Discount
Else
	Call Event4Check
End If


End Sub 'Event3Check

'===================================
'AnyDay Flex Pass - CHECK

Sub Event4Check

'Determine if patron has purchased the season ticket in current order

'Check if the member event code is in order
SQLEvent4Current = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber  INNER JOIN OrderHeader (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber WHERE EventCode = " & CleanNumeric(Event4Code) & " AND OrderLine.OrderNumber = " & CleanNumeric(Session("OrderNumber"))& " "
Set rsEvent4Current = OBJdbConnection.Execute(SQLEvent4Current)
    If Not rsEvent4Current.EOF Then 'it is in order
        Event4CurrentCount = rsEvent4Current("TicketCount")
    End If
rsEvent4Current.Close
Set rsEvent4Current = nothing

'Determine if patron has purchased the season ticket in the past

SQLEvent4Before = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE CustomerNumber = " & CleanNumeric(Session("CustomerNumber")) & " AND EventCode = " & CleanNumeric(Event4Code) & " AND OrderHeader.OrderNumber <> " & CleanNumeric(Session("OrderNumber")) & "" 
Set rsEvent4Before = OBJdbConnection.Execute(SQLEvent4Before)
    If Not rsEvent4Before.EOF Then
        Event4BeforeCount = rsEvent4Before("TicketCount")
    End If
rsEvent4Before.Close
Set rsEvent4Before = nothing

If Event4CurrentCount >= 1 Or Event4BeforeCount >= 1 Then 
	Call Event4Discount
Else
	Call Continue
End If


End Sub 'Event4Check

'===================================

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

Call DBClose(OBJdbConnection)

If ApplyDiscountOK Then
	Call WarningPage(SeriesName)
Else
	Call Event2Check
End If

End Sub 'ApplyMemberEvent1

'=======================================
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

Call DBClose(OBJdbConnection)

If ApplyDiscountOK Then
	Call WarningPage(SeriesName)
Else
	Call Event3Check
End If

End Sub 'Event2Discount

'===================================
' Weekday FlexPass - Apply

Sub Event3Discount

SeriesName = "Weekday Flex Pass Holder"
SeriesTicketCount = Event3Count 
ProductionList = Split(ActCodeList,",")
	
	SQLRemove = "UPDATE OrderLine WITH (ROWLOCK) SET DiscountTypeNumber = 0, Discount = 0 WHERE OrderNumber = " & Session("OrderNumber") & " AND DiscountTypeNumber = " & DiscountTypeNumber
	Set rsRemove = OBJdbConnection.Execute(SQLRemove)
	
	SQLFreeTickets =  "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE (OrderHeader.CustomerNumber = " & Session("CustomerNumber") & " OR OrderHeader.OrderNumber = " & Session("OrderNumber") & ") AND Seat.EventCode = " & CleanNumeric(Event3Code)
	Set rsFreeTickets = OBJdbConnection.Execute(SQLFreeTickets)
	SeasonTickets = rsFreeTickets("TicketCount")
	rsFreeTickets.Close
	Set rsFreeTickets = nothing
	
	AppliedCount = 0
	SQLApplied = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE OrderHeader.CustomerNumber = " & Session("CustomerNumber") & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.StatusCode = 'S'"
	Set rsApplied = OBJdbConnection.Execute(SQLApplied)
	AppliedCount = rsApplied("TicketCount")
	rsApplied.Close
	Set rsApplied = nothing
	
    NumberFreeTickets = (SeriesTicketCount * SeasonTickets) - AppliedCount    
        
    If CInt(NumberFreeTickets) > 0 Then 
    
    ApplyDiscountOK = false 
        
        SQLLineNo = "SELECT TOP(" & NumberFreeTickets & ") LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN EVENT (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND ActCode IN (" & ActCodeList & ") AND (DATEPART(WEEKDAY, Event.Eventdate)) IN (2,3,4,5,6) ORDER BY LineNumber DESC"
        Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)
        
            If Not rsLineNo.EOF Then
            
                Do While Not rsLineNo.EOF            
                    SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = Price * " & DiscountAmount & ", Surcharge = 0, DiscountTypeNumber = " & DiscountTypeNumber & " WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber")
                    Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
                    ApplyDiscountOK = true
                    rsLineNo.movenext
                Loop
                
		    End If
		
		rsLineNo.Close
		Set rsLineNo = Nothing 
        
        Call DBClose(OBJdbConnection)
        
        If ApplyDiscountOK Then
            Call WarningPage(SeriesName)
        Else
            Call Event4Check
        End If
        
    Else
        Call Event4Check
    End If
    
End Sub 'Event3Discount

'===================================

' Anyday FlexPass - APPLY

Sub Event4Discount

SeriesName = "Anyday Flex Pass Holder"
SeriesTicketCount = Event4Count 
ProductionList = Split(ActCodeList,",")
	
	SQLRemove = "UPDATE OrderLine WITH (ROWLOCK) SET DiscountTypeNumber = 0, Discount = 0 WHERE OrderNumber = " & Session("OrderNumber") & " AND DiscountTypeNumber = " & DiscountTypeNumber
	Set rsRemove = OBJdbConnection.Execute(SQLRemove)
	
	SQLFreeTickets =  "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE (OrderHeader.CustomerNumber = " & Session("CustomerNumber") & " OR OrderHeader.OrderNumber = " & Session("OrderNumber") & ") AND Seat.EventCode = " & CleanNumeric(Event4Code)
	Set rsFreeTickets = OBJdbConnection.Execute(SQLFreeTickets)
	SeasonTickets = rsFreeTickets("TicketCount")
	rsFreeTickets.Close
	Set rsFreeTickets = nothing
	
	AppliedCount = 0
	SQLApplied = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE OrderHeader.CustomerNumber = " & Session("CustomerNumber") & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.StatusCode = 'S'"
	Set rsApplied = OBJdbConnection.Execute(SQLApplied)
	AppliedCount = rsApplied("TicketCount")
	rsApplied.Close
	Set rsApplied = nothing
	
    NumberFreeTickets = (SeriesTicketCount * SeasonTickets) - AppliedCount    
        
    If CInt(NumberFreeTickets) > 0 Then 
    
    ApplyDiscountOK = false 
        
        SQLLineNo = "SELECT TOP(" & NumberFreeTickets & ") LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN EVENT (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND ActCode IN (" & ActCodeList & ") AND (DATEPART(WEEKDAY, Event.Eventdate)) IN (1,2,3,4,5,6,7) ORDER BY LineNumber DESC"
        Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)
        
            If Not rsLineNo.EOF Then
            
                Do While Not rsLineNo.EOF            
                    SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = Price * " & DiscountAmount & ", Surcharge = 0, DiscountTypeNumber = " & DiscountTypeNumber & " WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber")
                    Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
                    ApplyDiscountOK = true
                    rsLineNo.movenext
                Loop
                
		    End If
		
		rsLineNo.Close
		Set rsLineNo = Nothing 
        
        Call DBClose(OBJdbConnection)
        
        If ApplyDiscountOK Then
            Call WarningPage(SeriesName)
        Else
            Call Continue
        End If
        
    Else
        Call Continue
    End If
    
End Sub 'Event4Discount

'===================================

Sub WarningPage(SeriesName)

%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>

<title>Ticket Sales</title>

<style type="text/css">
body
{
    line-height: 1.6em;
}
#rounded-corner
{
	font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
	font-size: 14px;
	margin: 45px;
	width: 500px;
	text-align: center;
	border-collapse: collapse;
}
#rounded-corner thead th.rounded-left
{
	background: <%=TableCategoryBGColor%> url('/Clients/<%=ClientFolder%>/Images/corner_nw.gif') left -1px no-repeat;
	text-align: right;
}
#rounded-corner thead th.rounded-right
{
	background: <%=TableCategoryBGColor%> url('/Clients/<%=ClientFolder%>/Images/corner_ne.gif') right -1px no-repeat;
    text-align: left;
}
#rounded-corner th.category
{
	padding: 8px;
	font-weight: strong;
	font-size: 14px;
	color: <%=TableCategoryFontColor%>;
	background: <%=TableCategoryBGColor%>;
}
#rounded-corner td.data
{
	padding: 8px;
	font-weight: normal;
	font-size: 14px;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
	border-top: 1px solid;
	border-color: #ffffff;
}
</style>

</head>

<%=strBody %>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<form action="<%= SurveyFileName %>" NAME="Survey" >
<input type="hidden" name="FormName" value="Continue">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">


<! -- Table Begin -- >
    <table id="rounded-corner" summary="surveypage">
    <thead>
	    <tr>
    	    <th scope="col" class="rounded-left"></th>
    	    <th scope="col" class="category">Congratulations Subscriber!</th>
    	    <th scope="col" class="rounded-right"></th>
        </tr>
   </thead>
   <tbody>
        <tr>
            <td colspan= "3" class="data">
            <br>
            <br>
            <br>
             As a valued <%= seriesname %>,<br />your order qualified for <%= AppliedTicketCount %> discounted tickets.<br>
            <br>
            <br>
            <br />            
            </td>
        </tr>
        <tr>
        	<td class="rounded-foot-left">&nbsp;</td>
        	<td>&nbsp;</td>
        	<td >&nbsp;</td>
        </tr>
    	<tr>
        	<td  colspan="3">
       
        	</td>
        </tr>
        	<td  class="footer-bottom" colspan = "3">
            <INPUT TYPE="submit" VALUE="Continue"></FORM>
            </td>
        </tr>
   </tbody>
   </table>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>

</html>

<%

End Sub ' SurveyForm

'=======================================

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