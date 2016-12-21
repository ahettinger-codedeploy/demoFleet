
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
SurveyNumber = 1705
SurveyName = "PastEventDiscount2014.asp"

'------------------------------------------------------------

'Daytona Playhouse

'If patron buys 1 ticket to the required event
'they are eligiable for vouchers to season events
'Patron can select the number of vouchers to redeem
'Each voucher will grant a 100% discount on the selected ticket

'Required Event Purchase
'------------------------
'EventCode  Name 
'678679   	2014-2015 Subscription Package FLEX 


'Required Ticket Type
'--------------------
'SeatCode  	Name 						Vouchers
'8120		Adult Package				6
'8121		Senior Package				6


'Eligible Acts
'--------------
'ActCode    Act
'107071		A MURDER IS ANNOUNCED
'107065		A TINY MIRACLE WITH A FIBEROPTIC UNICORN
'107066		DILEMMAS WITH DINNER
'107069		SOCIAL SECURITY
'107070		SPAMALOT
'107064		VANYA AND SONIA AND MASHA AND SPIKE


'Pricing
'--------------
'100% discount applied to each redeemed ticket


'Eligible Ticket Types
'--------------
'Discount can be applied to all ticket types


'Eligible Price Tier/Section
'--------------
'Discount can be applied to all price tiers or sections


'Offline/Online
'--------------
'Discount can be applied to both online and offline orders


'Service Fees
'--------------
'Discounted tickets receive new surcharge: $0.00 per ticket


'Automatic/Code Entry
'--------------
'Automatic Discount: code entry not required


'Discount
'Number		Code		Description
'-----------------------------------------
'98384		2014Flex	2014 Flex Discount


'------------------------------------------------------------

DiscountTypeNumber = 98384
SeriesPercentage = 1.0 '100% Discount
MemberEventCode = 678679 'Requred event to purchase


Dim AllowedSeatType(1)
AllowedSeatType(0) = 8120 'Adult - Package
AllowedSeatType(1) = 8121 'Senior - Package

Dim SeriesCount(1)
SeriesCount(1) = 6

Dim SeriesName(1)
SeriesName(1) = "Season Subscription"


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
	Call ApplyDiscount(CleanNumeric(Request("TicketQuantity")))

ElseIf Clean(Request("FormName")) = "Continue" Then
    Call Continue

Else
    Call MemberCheck
End If

'----------------------------------------------------------

'Determine if required event is on the current order or has already been purchased.

Sub MemberCheck

MemberCurrentCount = 0
   MemberPastCount = 0
       MemberCount = 0
 
 
'Determine if member event is in shopping cart
SQLMemberCurrent = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE EventCode = " & CleanNumeric(MemberEventCode) & " AND OrderLine.OrderNumber = " & CleanNumeric(Session("OrderNumber"))& ""
Set rsMemberCurrent = OBJdbConnection.Execute(SQLMemberCurrent)
    If Not rsMemberCurrent.EOF Then 'it is in order
        MemberCurrentCount = rsMemberCurrent("TicketCount")
    End If
rsMemberCurrent.Close
Set rsMemberCurrent = nothing


'Determine if the member event was purchased previously
SQLMemberPast = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE CustomerNumber = " & CleanNumeric(Session("CustomerNumber")) & " AND EventCode = " & CleanNumeric(MemberEventCode) & " AND OrderHeader.OrderNumber <> " & CleanNumeric(Session("OrderNumber"))
Set rsMemberPast = OBJdbConnection.Execute(SQLMemberPast)
    If Not rsMemberPast.EOF Then
        MemberPastCount = rsMemberPast("TicketCount")
    End If
rsMemberPast.Close
Set rsMemberPast = nothing

MemberCount = (MemberCurrentCount + MemberPastCount)

If MemberCount >= 1 Then     
	Call DetermineOffer
Else
	Call Continue
End If


End Sub 'MemberCheck


'----------------------------------------------------------

Sub DetermineOffer	

  AllowedTicketCount = 0    'Total number of free tickets allowed
  AppliedTicketCount = 0    'Number of free tickets already given
AvailableTicketCount = 0    'Number of free tickets available for this order
    OrderTicketCount = 0    'Number of free tickets used on this order
RemainingTicketCount = 0    'Number of free tickets left for next order

'Determine the total number of discounted tickets orginally due to the paton
SQLFreeTickets = "SELECT OrderLine.SeatTypeCode FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE (OrderHeader.CustomerNumber = " & Session("CustomerNumber") & " OR OrderHeader.OrderNumber = " & Session("OrderNumber") & ") AND Seat.EventCode = " & CleanNumeric(MemberEventCode)& ""
Set rsFreeTickets = OBJdbConnection.Execute(SQLFreeTickets)

    If Not rsFreeTickets.EOF Then
        Do While Not rsFreeTickets.EOF
               
        Select Case rsFreeTickets("SeatTypeCode")
            Case  AllowedSeatType(0), AllowedSeatType(1)
                Count = SeriesCount(1)
         End Select
         
        AllowedTicketCount = AllowedTicketCount + Count
        
        rsFreeTickets.movenext    
        Loop
    	
    End If

rsFreeTickets.Close
Set rsFreeTickets = Nothing  


'Determine number of discounted tickets already given to the patron
SQLApplied = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE OrderHeader.CustomerNumber = " & Session("CustomerNumber") & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.StatusCode = 'S'"
Set rsApplied = OBJdbConnection.Execute(SQLApplied)
AppliedTicketCount = rsApplied("TicketCount")
rsApplied.Close
Set rsApplied = nothing
	
'Determine number of discounted tickets remaining
AvailableTicketCount = (AllowedTicketCount - AppliedTicketCount)


'Determine the number of tickets on the order
SQLCurrentOrder = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & CleanNumeric(Session("OrderNumber"))& ""
Set rsCurrentOrder = OBJdbConnection.Execute(SQLCurrentOrder)
CurrentOrderTicketCount = rsCurrentOrder("TicketCount")
rsCurrentOrder.Close
Set rsCurrentOrder = nothing

'Bypass the offer if there are no discounts left to allocate 
If AvailableTicketCount > 0 Then 

    If CurrentOrderTicketCount > AvailableTicketCount  Then
        CurrentOrderTicketCount = AvailableTicketCount
    End If

    Call DisplayOffer(AvailableTicketCount,CurrentOrderTicketCount)
	
Else
    Call Continue
End If

End Sub 'DetermineOffer

'------------------------------------------------------------

Sub DisplayOffer(AvailableTicketCount,CurrentOrderTicketCount)

'Display the offer event
Select Case AvailableTicketCount
    Case  1
        S1 = ""
    Case Else
        S1 = "s"
End Select

%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<html>
<head>

<title>TIX.com</title>

<style type="text/css">
    
body
{
    font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
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
<br />
<table id="rounded-corner" summary="surveypage" border="0">
<thead>
    <tr>
	    <th scope="col" class="category-left"></th>
	    <th scope="col" class="category" colspan="2"><b>Welcome Back Season Subscriber</b></th>
	    <th scope="col" class="category-right"></th>
    </tr>        
</thead>
    <tbody>
    <tr>
    	<td class="data">&nbsp;</td>
        <td class="data" colspan="2">
        Your subscription qualifies you for <%= AvailableTicketCount %> season ticket<%= S1 %>.<br />
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

Sub ApplyDiscount(TicketQuantity)

DiscountApplied = "N"

If TicketQuantity > 0 Then

    'First remove any other discounts on this order
    SQLRemove = "UPDATE OrderLine WITH (ROWLOCK) SET DiscountTypeNumber = 0, Discount = 0 WHERE OrderNumber = " & Session("OrderNumber") & " AND DiscountTypeNumber = " & DiscountTypeNumber & ""
    Set rsRemove = OBJdbConnection.Execute(SQLRemove)

    'Then select the number of tickets to be discounted, highest price first
    SQLLineNo = "SELECT TOP(" & TicketQuantity & ") LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN EVENT (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Seat.EventCode <> " & CleanNumeric(MemberEventCode)& " ORDER BY Price DESC"
    Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)
    If Not rsLineNo.EOF Then
        Do While Not rsLineNo.EOF
            SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = Price * " & SeriesPercentage & ", DiscountTypeNumber = " & DiscountTypeNumber & ", Surcharge = 0  WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber")
            Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
            DiscountApplied = "Y"
            rsLineNo.movenext
        Loop
    End If
    rsLineNo.Close
    Set rsLineNo = Nothing

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


%>