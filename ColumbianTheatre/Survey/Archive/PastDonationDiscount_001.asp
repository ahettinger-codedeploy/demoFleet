<%

'CHANGE LOG - Inception
'SSR 4/6/2011

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->

<%

'============================================================

Page = "Survey"
SurveyNumber = 149
SurveyFileName = "PastDonationDiscount.asp"

'============================================================

'Columbian Theater
'Past Donation Discount Survey

'Purchase donation (Individual,Family,Columbian Assets,Corporate Eagles,JC Rogers,Roger Circle Patrons,Donation)
'within the past 365 days and receive $1.00 off each ticket to any event
'which has valid ticket type: Adult Show Only, Child (Show Only), Adult Show & Buffet, Child (Show & Buffet)


'Placeholder discount - does not need to be attached to events
'---------------------------------------------------------------
DiscountTypeNumber = 29138 


'Per Ticket Discount
'-------------------
DiscountAmount = 1


'Donation Levels
'---------------
ItemNumberList = "349,350,351,352,353,354,380"


'Valid Ticket Types
'-------------------
AllowedSeatType = "1008,1012,1011,1015"

'============================================================

'Survey Start. 
'Check to see if Order Number exists.
'Skip Survey if Comp Order
'Request the form name and process requested action


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


If Session("OrderTypeNumber") = 5 Then
	Call Continue
End If


Select Case Clean(Request("FormName"))
    Case "Continue"
        Call Continue
    Case Else
        Call MemberCheck
End Select
 

'============================================================
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
SQLMemberPrevious = "SELECT OrderLine.ItemNumber FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE CustomerNumber = " & CleanNumeric(Session("CustomerNumber")) & " AND OrderLine.ItemNumber IN (" & ItemNumberList & ") AND OrderHeader.OrderNumber <> " & CleanNumeric(Session("OrderNumber")) & " AND GetDate() < DateAdd(day, 365, OrderDate) ORDER BY OrderLine.ItemNumber"
Set rsMemberPrevious = OBJdbConnection.Execute(SQLMemberPrevious)
If Not rsMemberPrevious.EOF Then
    DonationFound = True
    DonationItemNo = rsMemberPrevious("ItemNumber")
End If
rsMemberPrevious.Close
Set rsMemberPrevious = nothing


If DonationFound Then 
	Call ApplyDiscount (DonationItemNo)
Else
	Call Continue
End If


End Sub 'MemberCheck
'============================================================
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

If Not rsFreeTickets.EOF Then
    
    Select Case rsFreeTickets("ItemNumber")
        Case 349	'Individual
        DonationDescription = "Individual"
        Case 350	'Family
        DonationDescription = "Family"
        Case 351	'Columbian Assets
        DonationDescription = "Columbian Assets"
        Case 352	'Corporate Eagles
        DonationDescription = "Corporate Eagles"
        Case 353	'JC Rogers
        DonationDescription = "JC Rogers"
        Case 354	'Roger Circle Patrons
        DonationDescription = "Roger Circle Patrons"
        Case 380	'Donation
        DonationDescription = "Donation"    
    End Select

End If

rsFreeTickets.Close
Set rsFreeTickets = Nothing  


'Apply the discount for this membership level
SQLLineNo = "SELECT OrderLine.LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN EVENT (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " ORDER BY OrderLine.Price DESC"
Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)

If Not rsLineNo.EOF Then

    Do While Not rsLineNo.EOF

        SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = " & DiscountAmount & ", DiscountTypeNumber = " & DiscountTypeNumber & " WHERE OrderNumber = " & Session("OrderNumber") & " AND (OrderLine.SeatTypeCode IN (" & AllowedSeatType & ")) AND OrderLine.ItemNumber IN (SELECT ItemNumber FROM Seat (NOLOCK) INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE Event.SurveyNumber = " & SurveyNumber & ")"
        Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
        DiscountApplied = "Y"
        DiscountTicketCount = DiscountTicketCount + 1
    
    rsLineNo.movenext
    Loop
    
End If

rsLineNo.Close
Set rsLineNo = Nothing 

Call DBClose(OBJdbConnection)

Call WarningPage (DonationDescription,DiscountTicketCount)

End Sub 'ApplyDiscount

'============================================================

Sub WarningPage (DonationDescription, DiscountTicketCount)


If Session("UserNumber")<> "" Then
    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "FFFFFF"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "000000"
    TableDataBGColor = "E9E9E9"
    ClientFolder= "Tix"
Else
    ClientFolder = "ColumbianTheatre"
End If
 
 
Select Case DiscountTicketCount
    Case  1
        S2 = ""
    Case Else
        S2 = "s"
End Select
 
 
%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

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
	font-size: 13px;
    font-weight: 400;
	width: 600px;
	text-align: left;
	border-collapse: collapse;
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
	background: <%=TableCategoryBGColor%> url('/Clients/<%=ClientFolder%>/Survey/Images/nw.gif') left -1px no-repeat;
	text-align: right;
}
#rounded-corner thead th.category-right
{
	background: <%=TableCategoryBGColor%> url('/Clients/<%=ClientFolder%>/Survey/Images/ne.gif') right -1px no-repeat;
    text-align: left;
}
#rounded-corner td.footer
{
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.footer-left
{
	background: <%=TableDataBGColor%> url('/Clients/<%=ClientFolder%>/Survey/Images/sw.gif') left bottom no-repeat;
}
#rounded-corner td.footer-right
{
	background: <%=TableDataBGColor%> url('/Clients/<%=ClientFolder%>/Survey/Images/se.gif') right bottom no-repeat;
}
#rounded-corner td.data
{
	padding-left: 25px;
	padding-right: 25px;
	padding-top: 15px;
	padding-bottom: 15px;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
</style>

</head>

<%=strBody %>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<form action="<%= SurveyFileName %>" NAME="Survey" >
<input type="hidden" name="SurveyNumber" value="<%= SurveyNumber %>">
<input type="hidden" name="FormName" value="Continue">
<br />
<table id="rounded-corner" summary="surveypage" >
<thead>
    <tr>
	    <th scope="col" class="category-left"></th>
	    <th scope="col" class="category" colspan="2"><b>Congratulations!</b></th>
	    <th scope="col" class="category-right"></th>
    </tr>        
</thead>
    <tbody>
    <tr>
        <td class="data" colspan="4"><br />Your <%=DonationDescription%> membership has qualified this order for a discount on <%=DiscountTicketCount%> ticket<%=S2%>.<br /><br /><br /><font size = 1><i>Discount appplies only to the following tickets: Adult Show Only, Adult Show & Buffet, Child Show Only, Child Show & Buffet.</font></i><br /></td>
    </tr>
    <tr>
        <td class="footer-left">&nbsp;</td>
        <td class="footer" colspan="2">&nbsp;</td>
        <td class="footer-right">&nbsp;</td>
    </tr>
    <tr align="center">
        <td>&nbsp;</td>
        <td colspan="2"><br /><INPUT TYPE="submit" VALUE="Continue"></form></td>
        <td>&nbsp;</td>
    </tr>
</table>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>
</html>

<%

End Sub 'Warning Page

'==========================================================

Sub Continue
				
Session("SurveyComplete") = Session("OrderNumber")

If Session("UserNumber") = "" Then
	Response.Redirect("/Ship.asp")
Else
	Response.Redirect("/Management/AdvanceShip.asp")
End If		

End Sub 'Continue

'==========================================================

%>

