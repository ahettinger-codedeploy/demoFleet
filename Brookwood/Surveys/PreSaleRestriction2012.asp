<%

'CHANGE LOG - Inception
'SSR (1/03/2012)
'Custom Survey

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->

<%

'============================================================

Page = "Survey"
SurveyNumber = 1191
SurveyName = "PreSaleRestriction2012.asp"
BoxOfficeByPass = False

'============================================================

'CSS Survey Variables

If Session("UserNumber")<> "" Then
    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "FFFFFF"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "000000"
    TableDataBGColor = "E9E9E9"
End If

'LastHex = box color
'FirstHex = background color

If Session("UserNumber")<> "" Then
    NECorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=008400&Src=TopLeftCorner16.txt"
    NWCorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=008400&Src=TopRightCorner16.txt"
    SWCorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=E9E9E9&Src=BottomLeftCorner16.txt"
    SECorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=E9E9E9&Src=BottomRightCorner16.txt"
Else
    NECorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=6699cc&Src=TopLeftCorner16.txt"
    NWCorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=6699cc&Src=TopRightCorner16.txt"
    SWCorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=f1f1f1&Src=BottomLeftCorner16.txt"
    SECorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=f1f1f1&Src=BottomRightCorner16.txt"
End If

'============================================================
 
'Verify that Order Number exists - if not bounce back to default page
'Verify that User Number exists - if so display management tabs

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
'Bypass this survey for Box Office Users (optional)

If Session("OrderTypeNumber") = 5 Then
	Call Continue
End If

If Session("OrderTypeNumber") <> 1 Then
    If BoxOfficeByPass Then
	    Call Continue
    End If
End If


'============================================================

'Request the form name and process requested action

Select Case Request("FormName")
	Case "MemberNumberForm"
		Call ValidateMember(Clean(Request("MemberNumber")))
	Case "Continue"
		Call MemberNumberForm(Message)
	Case Else
		Call MemberNumberForm(Message)
End Select

'============================================================
	
Sub MemberNumberForm(Message)

'Check for existing survey entry for this order
SQLSurveyAnswers = "SELECT Answer FROM SurveyAnswers(NOLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND SurveyNumber = " &  SurveyNumber & " AND Question = 'MembershipNumber'"
Set rsSurveyAnswers = OBJdbConnection.Execute(SQLSurveyAnswers)

If NOT rsSurveyAnswers.EOF Then
    MemberNumber = rsSurveyAnswers("Answer")
End If

rsSurveyAnswers.Close
Set SurveyAnswers = nothing

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
bgwrap
{
background: #EBF7FA;
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
	color: #000000
	background: #f1f1f1;
}
#rounded-corner td.footer-left
{
    background: <%=TableDataBGColor%>;
    color: #000000
	background: #f1f1f1;
}
#rounded-corner td.footer-right
{
	background: <%=TableDataBGColor%>;
	color: #000000
	background: #f1f1f1;
}
#rounded-corner td.data
{
	padding-left: 10px;
	padding-right: 10px;
	padding-top: 10px;
	padding-bottom: 10px;
	text-align: center;
	color: #000000
	background: #f1f1f1;
}
#rounded-corner td.data-left
{
	padding-left: 10px;
	padding-right: 10px;
	padding-top: 10px;
	padding-bottom: 10px;
	text-align: left;
	color: #000000
	background: #f1f1f1;
}
#rounded-corner td.data-right
{
	padding-left: 10px;
	padding-right: 10px;
	padding-top: 10px;
	padding-bottom: 10px;
    text-align: right;
	color: #000000
	background: #f1f1f1;
}
</style>
</head>

<% If Message = "" Then %>
    <%=strBody%>
<% Else %>
	<body onLoad="alert('<%= Message %>');">
<% End If %>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<form action="<%= SurveyFileName %>" method="post" id=form1 name=form1>
<input type="hidden" name="FormName" value="MemberNumberForm">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">


<table id="rounded-corner" summary="surveypage" border="0">
<thead>
    <tr>
	    <th scope="col" class="category-left"></th>
	    <th scope="col" class="category" colspan="2"><%=SurveyTitle%></th>
	    <th scope="col" class="category-right"></th>
    </tr>        
</thead>
<tbody>
    <tr>
        <td class="data-right">&nbsp;</td>
        <td class="data" colspan="2"><%=SurveyHeader%></td>
        <td class="data-right">&nbsp;</td>
    </tr>
   <tr>
        <td class="data-right">&nbsp;</td>
        <td class="data" colspan="2"><INPUT TYPE="text" NAME="MemberNumber" VALUE="<%=MemberNumber%>"  SIZE="30" onFocus="Member[1].checked = true;"></td>
        <td class="data-right">&nbsp;</td>
    </tr>
    <tr>
        <td class="footer-left">&nbsp;</td>
        <td class="footer" colspan="2">&nbsp;</td>
        <td class="footer-right">&nbsp;</td>
    </tr>
    <tr>
        <td >&nbsp;</td>
        <td colspan="2">&nbsp;</td>
        <td >&nbsp;</td>
    </tr>
    <tr>
        <td >&nbsp;</td>
        <td align="center">
            <% If Session("UserNumber") = "" Then %>
            <INPUT TYPE="button" VALUE="<<&nbsp;&nbsp;Back" onclick="location.href='/ShoppingCart.asp';" ID=1 NAME=1 STYLE="width: 100px">
            <% Else  %>
            <INPUT TYPE="button" VALUE="<<&nbsp;&nbsp;Back" onclick="location.href='/Management/ShoppingCart.asp';" id=Button1 name=1  STYLE="width: 100px">
            <% End If %>
        </td>
        <td align="center">
            <INPUT TYPE=submit VALUE="Continue&nbsp;&nbsp;>>" id=submit1 name=submit1 STYLE="width: 100px">	
            </form>
        </td>
        <td >&nbsp;</td>
    </tr>
</tbody>
</table>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>
</htmlL>

<%


End Sub 'MemberNumberForm

'============================================================

Sub ValidateMember(MemberNumber)

If Len(MemberNumber) = CardNumberDigits Then

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
bgwrap
{
background: #EBF7FA;
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
	color: #000000
	background: #f1f1f1;
}
#rounded-corner td.footer-left
{
    background: <%=TableDataBGColor%>;
    color: #000000
	background: #f1f1f1;
}
#rounded-corner td.footer-right
{
	background: <%=TableDataBGColor%>;
	color: #000000
	background: #f1f1f1;
}
#rounded-corner td.data
{
	padding-left: 10px;
	padding-right: 10px;
	padding-top: 10px;
	padding-bottom: 10px;
	text-align: center;
	color: #000000
	background: #f1f1f1;
}
#rounded-corner td.data-left
{
	padding-left: 10px;
	padding-right: 10px;
	padding-top: 10px;
	padding-bottom: 10px;
	text-align: left;
	color: #000000
	background: #f1f1f1;
}
#rounded-corner td.data-right
{
	padding-left: 10px;
	padding-right: 10px;
	padding-top: 10px;
	padding-bottom: 10px;
    text-align: right;
	color: #000000
	background: #f1f1f1;
}
</style>

</head>


<!--#INCLUDE virtual="TopNavInclude.asp"-->

<form action="<%= SurveyFileName %>" method="post" id=form2 name=form1>
<input type="hidden" name="FormName" value="MemberNumberForm">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">


<table id="rounded-corner" summary="surveypage" border="1">
<thead>
    <tr>
	    <th scope="col" class="category-left"></th>
	    <th scope="col" class="category" colspan="2">Membership Number</th>
	    <th scope="col" class="category-right"></th>
    </tr>        
</thead>
<tbody>
    <tr>
        <td class="data-right">&nbsp;</td>
        <td class="data" colspan="2">Validate Membership Number</td>
        <td class="data-right">&nbsp;</td>
    </tr>
   <tr>
        <td class="data-right">&nbsp;</td>
        <td class="data" colspan="2">Membership Number:<%=MemberNumber%></td>
        <td class="data-right">&nbsp;</td>
    </tr>
    <tr>
        <td class="footer-left">&nbsp;</td>
        <td class="footer" colspan="2">&nbsp;</td>
        <td class="footer-right">&nbsp;</td>
    </tr>
    <tr>
        <td >&nbsp;</td>
        <td colspan="2">&nbsp;</td>
        <td >&nbsp;</td>
    </tr>
    <tr>
        <td >&nbsp;</td>
        <td align="center">

        </td>
        <td align="center">
            <INPUT TYPE=submit VALUE="Continue&nbsp;&nbsp;>>" id=submit2 name=submit1 STYLE="width: 100px">	
            </form>
        </td>
        <td >&nbsp;</td>
    </tr>
</tbody>
</table>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>
</htmlL>

<%

End If

End Sub 'MemberNumberForm

'============================================================

Sub RecordNumber(MemberNumber)	

    'Check for existing survey entry for this order and delete existing survey entry 
    SQLSurveyAnswers = "SELECT Answer FROM SurveyAnswers(NOLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND SurveyNumber = " &  SurveyNumber & " AND Question = 'MembershipNumber'"
    Set rsSurveyAnswers = OBJdbConnection.Execute(SQLSurveyAnswers)

    If NOT rsSurveyAnswers.EOF Then
		SQLDeleteSurveyAnswer = "DELETE SurveyAnswers WHERE OrderNumber = " & Session("OrderNumber") & " AND SurveyNumber = " &  SurveyNumber & " AND Question = 'MembershipNumber'"
		Set rsDetail = OBJdbConnection.Execute(SQLDeleteSurveyAnswer)
    End If

    rsSurveyAnswers.Close
    Set SurveyAnswers = nothing
	
    'Record MemberNumber in SurveyAnswers
    SQLInsertSurvey = "INSERT SurveyAnswers(SurveyNumber, OrderNumber, CustomerNumber, SurveyDate, AnswerNumber, Answer, Question) VALUES(" & SurveyNumber & ", " & Session("OrderNumber") & ", " & Session("CustomerNumber") & ", '" & Now() & "', 1, '" & MemberNumber & "', 'MembershipNumber')"
    Set rsInsertSurvey = OBJdbConnection.Execute(SQLInsertSurvey)
	
	Call Continue


End Sub 'RecordNumber

'============================================================

Sub Continue


If Session("UserNumber") = "" Then
	Session("SurveyComplete") = Session("OrderNumber")
	Response.Redirect("/Ship.asp")
Else
	Session("SurveyComplete") = Session("OrderNumber")
	Response.Redirect("/Management/AdvanceShip.asp")
End If



End Sub 'Continue

'============================================================

%>
