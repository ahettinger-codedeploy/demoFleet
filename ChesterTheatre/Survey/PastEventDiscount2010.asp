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
' (1) Weekday Season Subscription  EventCode: 334517
' Patron is entitled to 1 ticket to each of the 4 season productions.
' Valid only for Wednesday, Thursday or Friday performances. 


' (2) Weekend Season Subscription  EventCode: 334518  
' Patron is entitled to 1 ticket to each of the 4 season productions.
' Valid only for Saturday or Sunday performances.


' (3) Weekday Flex Pass  EventCode: 334516
' Patron is entitled to 6 tickets to any of the season productions.
' Tickets can be used in any combination 
' Valid only for Wednesday, Thursday or Friday performances.  


' (4) Anyday Flex Pass  EventCode: 334515  
' Patron is entitled to 6 tickets to any of the season productions.
' Tickets can be used in any combination 
' Valid for any performance

'===================================
'Survey Variables

DiscountAmount = 1.0 
AllowedSeatType = "16"
DiscountTypeNumber = 54138
MemberEventCode1 = "334517" 
MemberEventCode2 = "334518" 
MemberEventCode3 = "334516"  
MemberEventCode4 = "334515"  
ActCodeList = "59293,59402,59406,59407"

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


'Check to see if this is a Comp Order. If so, skip the survey.
If Session("OrderTypeNumber") = 5 Then
	Call Continue
End If


If Clean(Request("FormName")) = "Continue" Then    
    Call Continue    
Else
   Call MemberEvent1    
End If


'===================================
'Weekday Subscription - CHECK

Sub MemberEvent1 

MemberEventCount1 = 0

'Check if the member event code is in order
SQLMemberEvent = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE EventCode = 334517 AND OrderLine.OrderNumber = " & CleanNumeric(Session("OrderNumber"))
Set rsMemberEvent = OBJdbConnection.Execute(SQLMemberEvent)
If Not rsMemberEvent.EOF Then 'it is in order
    MemberEventCount1 = rsMemberEvent("TicketCount")
End If
rsMemberEvent.Close
Set rsMemberEvent = nothing

MemberEventCount2 = 0

'check if this customer has purchased this member event code before
SQLMemberBefore = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE CustomerNumber = " & CleanNumeric(Session("CustomerNumber")) & " AND EventCode = " & CleanNumeric(MemberEventCode1) & " AND OrderHeader.OrderNumber <> " & CleanNumeric(Session("OrderNumber"))
Set rsMemberBefore = OBJdbConnection.Execute(SQLMemberBefore)
If Not rsMemberBefore.EOF Then
    MemberEventCount2 = rsMemberBefore("TicketCount")
End If
rsMemberBefore.Close
Set rsMemberBefore = nothing
'End If

If MemberEventCount1 >= 1 Or MemberEventCount2 >= 1 Then 
    ProductionFreeList = "59293,59402,59406,59407"
	Call ApplyMemberEvent1(ProductionFreeList,MemberEventCount1,MemberEventCount2)
Else
	Call MemberEvent2
End If

End Sub 'MemberEvent1

'========================
' Weekday Subscription - APPLY

Sub ApplyMemberEvent1(ProductionFreeList,MemberEventCount1,MemberEventCount2)

ProductionList = Split(ProductionFreeList,",")

If MemberEventCount2 >= 1 Then 'calculate total tickets free
    NumberFreeTickets = MemberEventCount1 + MemberEventCount2
End If

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
	Call WarningPage
Else
	Call Continue
End If

End Sub 'ApplyMemberEvent1

'=======================================

Sub WarningPage

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
             As a season subscriber subscriber, your order qualified<br />for discounted tickets.<br>
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