<%

'CHANGE LOG - Inception
'SSR 6/2/2011
'Past Event Discount Survey

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->

<%

'============================================================

Page = "Survey"
SurveyNumber = 1038
SurveyFileName = "PastEventDiscount2011.asp"

'============================================================

'City Lights Theater Company of San Jose (6/2/2011)


'Trigger
'-------
'With purchase of one ticket to Distracted (ActCode 55354)
'Receive discount on one ticket to Nine (ActCode 55355) 


'Restrictions
'------------
'Good only on events dated 8/11/2011 to 8/21/2011
'Good only if purchased before midnight on 6/30/2011
'Required ticket can be on current order or any order


'Discount Amount
'---------------
'Offer tickets discounted by $10.00
'Required tickets do not get a discount
'Ratio is one-for-one.


'Automatic/Manual
'----------------
'Discount is automatic.


'Online/Offline
'--------------
'Discount is available both online and offline.


'Variables
'----------------
RequiredActCode = 55354
OfferActCode = 55355
OfferDiscountAmount = 10
ExpirationDate = CDate("6/30/2011")

'============================================================

'Survey Start. 
'Check to see if Order Number exists.
'Skip Survey if Comp Order
'Skip Survey if expired
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

If FormatDateTime(Now(), vbShortDate) >  ExpirationDate  Then
    Message = "This discount has expired."
	Call WarningPage(Message)
End If

Select Case Clean(Request("FormName"))
    Case "Continue"
        Call Continue
    Case Else
        Call RequiredEventCheck
End Select
 

'============================================================

Sub RequiredEventCheck

ActEventCount = 0

SQLActEvent = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderHeader (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE Event.ActCode = " & RequiredActCode & " AND OrderHeader.StatusCode = 'S' AND CustomerNumber = " & Session("CustomerNumber") & " AND OrderLine.OrderNumber <> " & Session("OrderNumber")
Set rsActEvent = OBJdbConnection.Execute(SQLActEvent)
ActEventCount = rsActEvent("TicketCount")
rsActEvent.Close
Set rsActEvent = nothing

If ActEventCount > 0 Then 
	Call ApplyDiscount
Else
	Call Continue
End If


End Sub 'RequiredEventCheck

'==============================

Sub ApplyDiscount
        
SQLLineNo = "SELECT LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN EVENT (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND ActCode = " & OfferActCode & " ORDER BY LineNumber DESC"
Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)

If Not rsLineNo.EOF Then
    Do While Not rsLineNo.EOF
        SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Price = 0, Discount = Price, Surcharge = 0, DiscountTypeNumber = " & DiscountTypeNumber & " WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber")& ""
        Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
        rsLineNo.movenext
    Loop
End If

rsLineNo.Close
Set rsLineNo = Nothing
        
Call Continue

End Sub 'ApplyDiscount

'============================================================

Sub WarningPage(Message)

Select Case OrderTicketCount
    Case  1
        S1 = ""
    Case Else
        S1 = "s"
 End Select
 
 Select Case RemainingTicketCount
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

<title>Member Discount</title>

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
        <td class="data" colspan="4">
       ' Your subscription has qualified you for <%= OrderTicketCount %> complimentary ticket<%= S1 %> on this order.<br />
       ' <br />
       ' You have <%= RemainingTicketCount %> ticket<%= S2 %> remaining.<br />
       <%= Message %> 
        </td>
    </tr>
    <tr>
    <tr>
        <td class="footer-left">&nbsp;</td>
        <td class="footer" colspan="2">&nbsp;</td>
        <td class="footer-right">&nbsp;</td>
    </tr>
    <tr align="center">
        <td>&nbsp;</td>
        <td colspan="2"><br /><INPUT TYPE="submit" VALUE="Continue"></FORM></td>
        <td>&nbsp;</td>
    </tr>
</table>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>
</html>

<%

End Sub ' SurveyForm

'============================================================

Sub Continue
				
Session("SurveyComplete") = Session("OrderNumber")
If Session("UserNumber") = "" Then
	Response.Redirect("/Ship.asp")
Else
	Response.Redirect("/Management/AdvanceShip.asp")
End If		

End Sub 'Continue

'============================================================

%>


