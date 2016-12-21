<%

'CHANGE LOG - Inception
'SSR 8/26/2011
'Custom Code 

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'============================================================

Page = "Survey"
SurveyNumber = 1073
SurveyName = "ParentsWeekend2012.asp"

'============================================================

'Organization Name

'Survey Parameters

SurveyHeader = "Audience Survey"

SurveyComments = "Please provide us with the information listed below"

DIM Question(5)
Question(1) = "First Name"
Question(2) = "Last Name"
Question(3) = "Address"
Question(4) = "Phone"

'===============================================

'CSS Survey Variables

If Session("UserNumber")<> "" Then

    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "#FFFFFF"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "#000000"
    TableDataBGColor = "#F1F1F1"
    TableDataFontColor = "#FFFFFF"
    BGColor = "#FFFFFF"
    
End If
    
    NECorner="/clients/tix/images/image.asp?FirstHex=Request.QueryString("BGColor")&LastHex=Request.QueryString("TableCategoryBGColor")&Src=TopLeftCorner16.txt"
    NWCorner="/clients/tix/images/image.asp?FirstHex=BGColor&LastHex=TableCategoryBGColor&Src=TopRightCorner16.txt"
    SWCorner="/clients/tix/images/image.asp?FirstHex=BGColor&LastHex=TableDataBGColor&Src=BottomLeftCorner16.txt"
    SECorner="/clients/tix/images/image.asp?FirstHex=BGColor&LastHex=TableDataBGColor&Src=BottomRightCorner16.txt"
    

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

'Bypass this survey on Comp Orders

If Session("OrderTypeNumber") = 5 Then
	Call Continue
End If

'============================================================

'Request the form name and process requested action

Select Case Clean(Request("FormName"))
    Case "Continue"
        Call Continue
    Case Else
        Call SurveyForm
 End Select
 

'==========================================================
	
Sub SurveyForm

If DocType <> "" Then
	Response.Write DocType
Else
	Response.Write "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
End If

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
	font-size: 12px;
    font-weight: 400;
	text-align: left;
	border-collapse: collapse;
}
#rounded-corner thead th.category
{
	padding-top: 10px;
    padding-bottom: 10px;
    padding-left: 1px;
    padding-right: 1px;
	font-size: 14px;
	font-weight: 600;
	text-align: center;
	color: <%=TableCategoryFontColor%>;
	background: <%=TableCategoryBGColor%>;
}
#rounded-corner thead th.category-left
{
	background: <%=TableCategoryBGColor%> url('<%=NECorner%>') left -1px no-repeat;
	text-align: right;
}
#rounded-corner thead th.category-right
{
	background: <%=TableCategoryBGColor%> url('<%=NWCorner%>') right -1px no-repeat;
    text-align: left;
}
#rounded-corner td.footer
{
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.footer-left
{
    background: <%=TableDataBGColor%> url('<%=SWCorner%>') left bottom no-repeat;
}
#rounded-corner td.footer-right
{
	background: <%=TableDataBGColor%> url('<%=SECorner%>') right bottom no-repeat;
}
#rounded-corner td.data
{
	padding-left: 1px;
	padding-right: 1px;
	padding-top: 20px;
	padding-bottom: 10px;
	text-align: center;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-left
{
	padding-left: 1px;
	padding-right: 1px;
	padding-top: 5px;
	padding-bottom: 1px;
	text-align: left;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-right
{
	padding-left: 50px;
	padding-right: 10px;
	padding-top: 5px;
	padding-bottom: 1px;
    text-align: right;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.price
{
	padding-left: 1px;
	padding-right: 1px;
	padding-top: 1px;
	padding-bottom: 1px;
	font-size: 12px;
	text-align: left;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner h3
{
	font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
	color: <%=TableCategoryFontColor%>;	
}
</style>

</head>

<%=strBody %>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<form action="<%= SurveyFileName %>" method="post" name="Survey" onSubmit="return validateForm()">
<input type="hidden" name="FormName" value="SurveyUpdate">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">

<%

OptionCount = 1

SQLPatronCount = "SELECT OrderLine.LineNumber, OrderLine.SeatTypeCode, SeatType FROM OrderLine (NOLOCK) INNER JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode WHERE OrderNumber = " & Session("OrderNumber") & " ORDER BY OrderLine.LineNumber"
Set rsPatronCount = OBJdbConnection.Execute(SQLPatronCount)   
    Do While Not rsPatronCount.EOF 

%>
<br />
<br />
<table id="rounded-corner" width="600px" summary="surveypage" >
<thead>
    <tr>
	    <th scope="col" class="category-left"></th>
	    <th scope="col" class="category" colspan="2"><h3><%=SurveyHeader%></h3></th>
	    <th scope="col" class="category-right"></th>
    </tr>        
</thead>
    <tbody>   
        <tr>
            <td class="data" colspan="4"><h4><%=SurveyComments%></h4></td>
        </tr>
        <tr>
            <td class="data-right" colspan="2">&nbsp;</td>
            <td class="data-left" colspan="2"><font size=1><i>Questions marked with <b>*</b> require an answer</i></font></td>
        </tr>
        <tr>
            <td class="data-right" colspan="2"><%= Question(1) %> <b> *</b></td>
            <td class="data-left" colspan="2"><INPUT TYPE="text" NAME="Answer1" SIZE="24" /></td>
        </tr>
        <tr>
            <td class="data-right" colspan="2"><%= Question(2) %> <b> *</b></td>
            <td class="data-left" colspan="2"><INPUT TYPE="text" NAME="Answer2" SIZE="24" /></td>
         </tr>
         <tr>
            <td class="data-right" colspan="2"><%= Question(3) %></td>
            <td class="data-left" colspan="2"><INPUT TYPE="text" NAME="Answer3" SIZE="24" /></td>
        </tr>
        <tr>
            <td class="data-right" colspan="2"><%= Question(4) %></td>
            <td class="data-left" colspan="2"><INPUT TYPE="text" NAME="Answer4" SIZE="24" /></td>
         </tr>
        <tr>
    	    <td class="footer-left">&nbsp;</td>
    	    <td class="footer" colspan="2">&nbsp;</td>
    	    <td class="footer-right">&nbsp;</td>
    	</tr>
        </tbody>
 </table>
<br />
<%

OptionCount = OptionCount + 1

rsPatronCount.Movenext    
Loop

rsPatronCount.Close
Set rsPatronCount = nothing


%>

<INPUT TYPE="submit" VALUE="Continue"></FORM>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%

End Sub ' SurveyForm

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