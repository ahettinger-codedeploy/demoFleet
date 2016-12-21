<%

'CHANGE LOG - Inception
'SSR 3/29/2011
'Custom Code 

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'============================================================

Page = "Management"

'============================================================

'CSS Survey Variables

If Session("UserNumber")<> "" Then
    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "FFFFFF"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "000000"
    TableDataBGColor = "E9E9E9"
    ClientFolder= "Tix"
End If

'============================================================

'Survey Questions

Dim Question(10)
NumQuestions = 9

Question(1) = "SeriesCount"
Question(2) = "AllowedSeatTypeList"
Question(3) = "DiscountType"
Question(4) = "Percentage"
Question(5) = "DiscountAmount"
Question(6) = "SeriesPrice"
Question(7) = "NewSurcharge"
Question(8) = "CalcServiceFee"
Question(9) = "OtherTickets"

EventListDays = 30

'============================================================

If Clean(Request("FormName"))="SurveyDisplay" Then
    Call SurveyDisplay
Else
	Call SurveyForm
End If

OBJdbConnection.Close
Set OBJdbConnection = nothing

'==========================================================

Sub SurveyForm

%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>

<title>Ticket Policy</title>

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
#rounded-corner td.data-right
{
	padding-left: 1px;
	padding-right: 1px;
	padding-top: 1px;
	padding-bottom: 1px;
	text-align: left;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-left
{
	padding-left: 1px;
	padding-right: 1px;
	padding-top: 1px;
	padding-bottom: 1px;
	text-align: right;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}

</style>

</head>

<%=strBody %>

<!--#INCLUDE virtual="TopNavInclude.asp"-->
<h3>TIX Invoice Format Management</h3>
This program will allow users to create and edit the custom invoice format<br />
<br />
<FONT size="2">
Click here to create a new invoice<br />
<a href="/clients/downtowntheater/invoice/invoiceformat.asp">[BUTTON]</a>
<br />
<BR />
This bit will edit the exiting invoice<bR />
<a href="/clients/downtowntheater/invoice/invoiceformat.asp">[BUTTON]</a>
</FONT>
<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>
</html>

<%

End Sub ' SurveyForm

%>
