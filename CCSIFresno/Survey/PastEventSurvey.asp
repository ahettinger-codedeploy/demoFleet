<%

'CHANGE LOG - Inception
'SSR (8/30/2011)
'Custom Survey

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'============================================================

Page = "Survey"
SurveyNumber = 1164
SurveyFileName = "PastEventSurvey.asp"
BoxOfficeByPass = True

''===============================================

'Central California Society of India (CCSI)
'Customer must have past or current purchase to EventCode 412541 in order to purchase a ticket for EventCode #427528.
'Restriction is online only
'If the ticket buyer is stopped, the message should say:
'“You must be a member to purchase tickets to CCSI New Year’s Eve.  Our records show that you are not a member.  If you would like to purchase a membership and continue with your order, please click on the Back to Shopping button below.”
'There should be two buttons they have to choose from - “Back to Shopping” and “Cancel Order”.
'Contact
'Mrutyunjay “Muttu” Hiremath
'hiremath.m@gmail.com

'============================================================

'Survey Parameters
MemberEvent = 412541
WarningMessage = "You must be a member to purchase tickets to CCSI New Year’s Eve.  Our records show that you are not a member.  If you would like to purchase a membership and continue with your order, please click on the Back to Shopping button below."

'============================================================

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

'============================================================

'Bypass this survey on all Comp Orders


If Session("OrderTypeNumber") = 5 Then
	Call Continue
End If

'Bypass this survey for Box Office Users

If Session("OrderTypeNumber") <> 1 Then
    If BoxOfficeByPass Then
	    Call Continue
    End If
End If

'============================================================

'Request the form name and process requested action

Select Case Clean(Request("FormName"))
    Case "Continue"
        Call Continue
    Case Else
        Call MemberCheck
 End Select

'==========================================================

Sub MemberCheck

EventFound = False

'Check for current order
SQLMemberCurrent = "SELECT Seat.EventCode FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.ItemType IN ('Seat','SubFixedEvent') AND Seat.EventCode = " & MemberEvent & ""
Set rsMemberCurrent = OBJdbConnection.Execute(SQLMemberCurrent)
If Not rsMemberCurrent.EOF Then 'it is in order
    EventFound = True
    ReqEventCode = rsMemberCurrent("EventCode")
End If
rsMemberCurrent.Close
Set rsMemberCurrent = nothing


'check for past orders if current doesn't have it
If EventFound <> True Then
    SQLMemberPast = "SELECT Seat.EventCode FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderHeader.StatusCode = 'S' AND OrderHeader.CustomerNumber = " & Session("CustomerNumber") & " AND OrderHeader.OrderNumber <> " & Session("OrderNumber") & " AND OrderLine.ItemType IN ('Seat','SubFixedEvent') AND Seat.EventCode = " & MemberEvent & ""
    Set rsMemberPast = OBJdbConnection.Execute(SQLMemberPast)
    If Not rsMemberPast.EOF Then 'it is in order
        EventFound = True
        ReqEventCode = rsMemberPast("EventCode")
    End If
    rsMemberPast.Close
    Set rsMemberPast = nothing
End If


If EventFound Then
    Call Continue
Else
    Call WarningPage
End If


End Sub

'==========================================================

Sub WarningPage
 
If Session("UserNumber")<> "" Then
    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "FFFFFF"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "000000"
    TableDataBGColor = "E9E9E9"
    ClientFolder= "Tix"
Else
    ClientFolder = "PhoenixCooks"
End If
 
 
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
	width: 80%;
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

<input type="hidden" name="SurveyNumber" value="<%= SurveyNumber %>">
<input type="hidden" name="FormName" value="Continue">
<br />
<br />
<table id="rounded-corner" summary="surveypage" border="0">
<thead>
    <tr>
	    <th scope="col" class="category"><b>Sorry</b></th>
    </tr>        
</thead>
    <tbody>
    <tr>
        <td class="data" align="center"><%=WarningMessage%><br /><br /></td>
    </tr>
    <tr>
        <td  align="center">
            <br />        
            <%
            If Session("UserNumber") <> "" Then
                ShoppingPage = "/Management/Event.asp?Event=" & MemberEvent & ""
            Else
                ShoppingPage = "/Event.asp?Event=" & MemberEvent & ""
            End If        
            %>        
            <form action="<%=ShoppingPage%>" method="post">
            <input type="submit" width: 100px  value="Back To Shopping" />
            </form>  
            <form>
            <INPUT TYPE="BUTTON" width: 100px VALUE="Cancel" ONCLICK="javascript:window.opener='x';window.close();"> 
            </form>
        </td>
    </tr>
 </table>
<!--#INCLUDE virtual="FooterInclude.asp"-->
</center>
</body>
</html>

<%

End Sub ' Warning Page

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