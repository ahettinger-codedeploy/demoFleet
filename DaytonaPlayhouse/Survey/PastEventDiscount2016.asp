
<%

'CHANGE LOG - Inception

'SSR 7/03/2013 - Created script
'SSR 7/10/2013 - Updated script - patron selects # tickets to discount
'SSR 7/11/2013 - Updated script - seat map change.  New required event code is 589274 


%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->

<%

'----------------------------------------------------------

Page = "Survey"
SurveyNumber = 2136
SurveyName = "PastEventDiscount2016.asp"

'============================================================

'Daytona Playhouse
'2016 Subscription - Past Event Discount

'2016-17 SERIES

'If patron buys 1 ticket to this season subscription event:

'Event Code		Event Name
'-----------------------
'846794		Subscription Package Flex - 2016-17

'they are entitled to 6 discounted tickets to any event of the following acts:

'Act Code		Act Name
'-----------------------
'125182		NOISES OFF
'125184		SIDE EFFECTS
'125186		THE ACTRESS
'125187		THE ADDAMS FAMILY
'125354		THE KIDS LEFT. THE DOG DIED. NOW WHAT?
'125355		THE LAST ROMANCE



'RENAISSANCE SERIES

'If patron buys 1 ticket to this season subscription event:
 
'Event Code		Event Name
'-----------------------
'846795		Subscription Package Flex - Renaissance

'they are entitled to 3 discounted tickets to any event of the following acts:

'Act Code		Act Name
'-----------------------
'125183		REX'S EXES
'125185		SQUABBLES
'125356		SWEET CHARITY



'BOTH SERIES

'If patron buys 1 ticket to this season subscription event:
 
'Event Code		Event Name
'-----------------------
'846793		Subscription Package Flex - Both

'they are entitled to 6 discounted tickets to any event of the following acts:

'Act Code		Act Name
'-----------------------
'125182		NOISES OFF
'125184		SIDE EFFECTS
'125186		THE ACTRESS
'125187		THE ADDAMS FAMILY
'125354		THE KIDS LEFT. THE DOG DIED. NOW WHAT?
'125355		THE LAST ROMANCE

'and they are also entitled to 3 discounted tickets to any event of the following acts:

'Act Code		Act Name
'-----------------------
'125183		REX'S EXES
'125185		SQUABBLES
'125356		SWEET CHARITY



'Eligible Ticket Type
'--------------------
'Discount applied to all ticket types


'Eligible Price Tier/Section
'---------------------------
'Discount applied to all sections / price tiers


'Offline/Online
'-------------
'Discount applied to both online and offline orders


'Service Fees
'-------------
'Discounted tickets will have a surcharge of $0.00 per ticket


'Automatic/Code Entry
'---------------------
'Automatic Discount: code entry not required


'Discount Code
'--------------
'2016sub


'Expiration
'----------
'No expiration


'Discount Limits
'---------------
'Discount will be applied to all eligible tickets
'on each order

'Purchase of multiple subscriptions will increase the number  of 
'discounted tickets

'============================================================

DiscountTypeNumber = 123050
SeriesPercentage = 1.0 '100% Discount

DIM MemberEventCode(2)
MemberEventCode(0) = 846980 '2017 Flex
MemberEventCode(1) = 846982 'Ren
MemberEventCode(2) = 846981 'Both


Dim AllowedSeatType(1)
AllowedSeatType(0) = 8120 'Adult - Package
AllowedSeatType(1) = 8121 'Senior - Package

Dim Count(2)
Count(0) = 0
Count(1) = 0
Count(2) = 0


Dim SeriesCount(2)
SeriesCount(0) = 6
SeriesCount(1) = 3
SeriesCount(2) = 9


Dim SeriesName(2)
SeriesName(0) = "Subscription Package Flex - 2016-17"
SeriesName(1) = "Subscription Package Flex - Renaissance"
SeriesName(2) = "Subscription Package Flex - Both"


DIM ActList(2)
ActList(0)  = 	"125182,125184,125186,125187,125354,125355"
ActList(1)	= 	"125183,125185,125356"
ActList(2)	= 	"125182,125184,125186,125187,125354,125355,125183,125185,125356"


DIM ActCodeList

DIM AppliedTicketCount(1)
DIM AvailableTicketCount(1)
DIM CurrentOrderTicketCount

DIM TicketCount
TicketCount = 0

DIM AnswerNumber
AnswerNumber = 1

DIM Question
Question = "Please select the number of tickets to redeem"

'----------------------------------------------------------

'Check to see if Order Number exists.  If not, redirect to Home Page.

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

'----------------------------------------------------------

'Survey Start. 
'Skip Survey if Comp Order
'Request the form name and process requested action


If Clean(Request("FormName")) = "ApplyDiscount" Then

	Call ApplyDiscount(CleanNumeric(Request("TicketQuantity")),Request("ActCodeList"))

ElseIf Clean(Request("FormName")) = "Continue" Then

    Call Continue

Else

    Call MemberCheck
    
End If

'----------------------------------------------------------

'Determine if required event is on the current order or has already been purchased.

Sub MemberCheck
       
      'Determine how many of the subscription events have been purchased
      SQLMemberCurrent = "SELECT Event.EventCode, Orderline.ItemNumber FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE (Event.EventCode IN (" & MemberEventCode(0) & "," & MemberEventCode(1) & "," & MemberEventCode(2) & ")  AND OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.StatusCode = 'R') OR (Event.EventCode IN (" & MemberEventCode(0) & "," & MemberEventCode(1) & "," & MemberEventCode(2) & ") AND OrderHeader.CustomerNumber = " & Session("CustomerNumber") & " AND OrderLine.StatusCode = 'S' AND GetDate() < (DateAdd(Day, 365, OrderHeader.OrderDate)))"
      Set rsMemberCurrent = OBJdbConnection.Execute(SQLMemberCurrent)

            If Not rsMemberCurrent.EOF Then

                  Do While Not rsMemberCurrent.EOF
         
                        Select Case rsMemberCurrent("EventCode")
                        
                              'Full Subscription
                              Case	MemberEventCode(0)
                                          Count(0)		= Count(0)		+ SeriesCount(0)
     
                              'Half Subscription
                              Case	MemberEventCode(1)
                                          Count(1)		= Count(1)		+ SeriesCount(1)
                                          
                             Case	MemberEventCode(2)
                                          Count(0) 		= Count(0) 		+ SeriesCount(0)
                                          Count(1)		= Count(1) 		+ SeriesCount(1)
                              
                        End Select
                         
                  rsMemberCurrent.MoveNext	
                  Loop
                        
            End If
            
      rsMemberCurrent.Close
      Set rsMemberCurrent = nothing
      
      ErrorLog("Count(0): " & Count(0) & "")
      ErrorLog("Count(1): " & Count(1) & "")
      
      If Count(0) > 0 AND Count(1) > 0 Then
            ActCodeList = ActList(2)
      ElseIf  Count(0) = 0 AND Count(1) > 0 Then
            ActCodeList = ActList(1)
      ElseIf Count(0) > 1 AND Count(1) = 0 Then
            ActCodeList = ActList(0)
      End If
       
      If ActCodeList <> "" Then
            Call DetermineOffer
      Else
            Call Continue
      End If
      

End Sub 'MemberCheck

'----------------------------------------------------------

Sub DetermineOffer

      For i = 0 to 1

            'Determine number of discounted tickets already applied
            SQLApplied = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat(NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Event(NOLOCK) On Seat.EventCode = Event.EventCode WHERE OrderHeader.CustomerNumber = " & Session("CustomerNumber") & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.StatusCode = 'S' AND Event.ActCode IN (" & ActList(i) & ")"
            Set rsApplied = OBJdbConnection.Execute(SQLApplied)
                 AppliedTicketCount(i) = rsApplied("TicketCount")
                 ErrorLog("AppliedTicketCount " & AppliedTicketCount(i) & "")
            rsApplied.Close
            Set rsApplied = nothing
            
            ErrorLog("Count " & Count(i) & " -  AppliedCount" & AppliedTicketCount(i) &" = " &  AvailableTicketCount(i) & "")
            
            'Determine number of discounted tickets remaining
            AvailableTicketCount(i) = (Count(i) - AppliedTicketCount(i))
                 
     Next

      'Determine the number of tickets on the order
      SQLCurrentOrder = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & CleanNumeric(Session("OrderNumber"))& ""
      Set rsCurrentOrder = OBJdbConnection.Execute(SQLCurrentOrder)
            CurrentOrderTicketCount = rsCurrentOrder("TicketCount")
      rsCurrentOrder.Close
      Set rsCurrentOrder = nothing

      'Bypass the offer if there are no discounts left to allocate 
      If AvailableTicketCount(0) > 0 OR AvailableTicketCount(1) > 0 Then 
            Call DisplayOffer
      Else
            Call Continue
      End If
            
      

End Sub 'DetermineOffer

'------------------------------------------------------------

Sub DisplayOffer

DIM CustomerName
CustomerName = fnCustomerName

DIM TableCategoryBGColor
DIM TableCategoryFontColor
DIM TableDataBGColor
DIM TableDataFontColor

TableCategoryBGColor = "#008400"
TableCategoryFontColor = "#FFFFFF"
TableDataBGColor = "#DDDDDD"
TableDataFontColor = "#333333"

%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<html>
<head>

<title>TIX.com</title>

<style type="text/css">
    
body
{
    font-family: veranda, Sans-Serif;
    line-height: 1 em;
}
#rounded-corner
{
font-size: 11px;
font-weight: 400;
text-align: left;
border-collapse: collapse;
width: 70%;
top: 10px;
line-height: 22px;
margin-top:  10px;
}

#rounded-corner thead th.category
{
padding-top: 10px;
padding-bottom: 10px;
padding-left: 0px;
padding-right: 1px;
font-size: 15px;
font-weight: 600;
text-align: center;
color: <%=TableCategoryFontColor%>;
background: <%=TableCategoryBGColor%>;
}

#rounded-corner thead th.category-left
{
background: <%=TableCategoryBGColor%>;
text-align: right;
}

#rounded-corner thead th.category-right
{
background: <%=TableCategoryBGColor%>;
text-align: left;
}

#rounded-corner td.footer
{
background: <%=TableDataBGColor%>;
}

#rounded-corner td.footer-left
{
background: <%=TableDataBGColor%>;
}

#rounded-corner td.footer-right
{
background: <%=TableDataBGColor%>;
}

#rounded-corner td.data
{
padding-left: 10px;
padding-right: 10px;
padding-top: 10px;
padding-bottom: 10px;
color: <%=TableDataFontColor%>;
background: <%=TableDataBGColor%>;
}

#rounded-corner td.data-left
{
padding-left: 10px;
padding-right: 10px;
padding-top: 10px;
padding-bottom: 10px;
text-align: left;
color: <%=TableDataFontColor%>;
background: <%=TableDataBGColor%>;
}

#rounded-corner td.data-right
{
padding-left: 10px;
padding-right: 10px;
padding-top: 10px;
padding-bottom: 10px;
text-align: right;
color: <%=TableDataFontColor%>;
background: <%=TableDataBGColor%>;
}
</style>
</head>

<body>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<form action="<%= SurveyFileName %>" NAME="Survey" >
<input type="hidden" name="SurveyNumber" value="<%= SurveyNumber %>">
<input type="hidden" name="FormName" value="ApplyDiscount">
<input type="hidden" name="ActCodeList" value="<%=ActCodeList%>">
<br />
<table id="rounded-corner" summary="surveypage" border="0">
<thead>
    <tr>
	    <th scope="col" class="category-left"></th>
	    <th scope="col" class="category" colspan="2"><b>Season Subscriber</b></th>
	    <th scope="col" class="category-right"></th>
    </tr>        
</thead>
    <tbody>
    
<%

For i = 0 to 1
      If AvailableTicketCount(i) > 0 Then
            AvailableMsg = AvailableMsg & "" & SeriesName(i) & " qualifies you for " & AvailableTicketCount(i) & " season ticket.<br />"
      End If
Next


If CurrentOrderTicketCount > AvailableTicketCount(0) + AvailableTicketCount(1) Then
  CurrentOrderTicketCount = AvailableTicketCount(0) + AvailableTicketCount(1)
End If

%>
    
      <tr>
            <td class="data">&nbsp;</td>
            <td class="data" colspan="2">
            <%=AvailableMsg%>

                  <br />
                  Please select the number of tickets to redeem:&nbsp;
                  <select name="TicketQuantity">
                  <option value="0">-- Choose Quantity --</option>
                  <% For j = 0 to CurrentOrderTicketCount %>
                  <% Select Case j %>
                  <% Case 1 %>  
                  <option value="<%=j%>"><%=j%>&nbsp;&nbsp;ticket</option>
                  <% Case Else %>
                  <option value="<%=j%>"><%=j%>&nbsp;&nbsp;tickets</option>
                  <% End Select %>                  
                  <% Next %>
                  </select>
                  
            </td>
            <td class="data">&nbsp;</td>
      </tr>

    <tr>
        <td class="footer-left">&nbsp;</td>
        <td class="footer" colspan="2">&nbsp;</td>
        <td class="footer-right">&nbsp;</td>
    </tr>
    <tr align="center">
        <td>&nbsp;</td>
        <td colspan="2" align="center" col>
            <br />
            <INPUT type="submit" value="Redeem Tickets" /></form>
            <br />
            <br />
            <form action="<%= SurveyFileName %>" method="post">
            <INPUT TYPE="hidden" NAME="FormName" VALUE="Continue">
            <input type="submit" value="&nbsp;&nbsp;No Thanks!&nbsp;&nbsp;" /></form>
        </td>
        <td>&nbsp;</td>
    </tr>
</table>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>
</html>

<%

End Sub ' SurveyForm

'------------------------------------------------------------

Sub ApplyDiscount(TicketQuantity,ActCodeList)

DiscountApplied = "N"

TicketCount = AppliedTicketCount(0) +  AppliedTicketCount(1)

If TicketQuantity > 0 Then

    'First remove any other discounts on this order
    SQLRemove = "UPDATE OrderLine WITH (ROWLOCK) SET DiscountTypeNumber = 0, Discount = 0 WHERE OrderNumber = " & Session("OrderNumber") & " AND DiscountTypeNumber = " & DiscountTypeNumber & ""
    Set rsRemove = OBJdbConnection.Execute(SQLRemove)
            
    'Then select the number of tickets to be discounted, highest price first
    SQLLineNo = "SELECT TOP(" & TicketQuantity & ") LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN EVENT (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Event.ActCode IN (" &  ActCodeList & ") ORDER BY Price DESC"
    Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)
    If Not rsLineNo.EOF Then
        Do While Not rsLineNo.EOF
            SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = Price * " & SeriesPercentage & ", DiscountTypeNumber = " & DiscountTypeNumber & ", Surcharge = 0  WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber")
            Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
            TicketCount = TicketCount + 1
            DiscountApplied = "Y"
            rsLineNo.movenext
        Loop
    End If
    rsLineNo.Close
    Set rsLineNo = Nothing
    
      SQLUpdateSurvey = "INSERT SurveyAnswers(SurveyNumber, OrderNumber, CustomerNumber, SurveyDate, AnswerNumber, Answer, Question) VALUES(" & SurveyNumber & ", " & Session("OrderNumber") & ", " & Session("CustomerNumber") & ", '" & Now() & "', " & AnswerNumber & ", '" & TicketCount & "', '" & Question & "')"
      Set rsUpdateSurvey = OBJdbConnection.Execute(SQLUpdateSurvey)

End If

Call Continue

End Sub 'ApplyDiscount

'------------------------------------------------------------

Sub Continue
				
Session("SurveyComplete") = Session("OrderNumber")
If Session("UserNumber") = "" Then
	Response.Redirect("/Ship.asp")
Else
	Response.Redirect("/Management/AdvanceShip.asp")
End If		

End Sub 'Continue

'------------------------------------------------------------

Public Function fnCustomerName

DIM strResult

SQLCustomer = "SELECT Customer.FirstName, Customer.LastName FROM Customer(NOLOCK) WHERE Customer.CustomerNumber = " & Session("CustomerNumber") & ""
Set rsCustomer = OBJdbConnection.Execute(SQLCustomer)
    If Not rsCustomer.EOF Then
      strResult = rsCustomer("FirstName") & "&nbsp;" & rsCustomer("LastName")
    End If
rsCustomer.Close
Set rsCustomer = Nothing

fnCustomerName = strResult 

End Function

'------------------------------------------------------------

%>