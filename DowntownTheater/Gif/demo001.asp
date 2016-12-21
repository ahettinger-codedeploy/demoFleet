<%

'CHANGE LOG - Inception
'SSR 6/09/2011
'How did you hear about us survey - required answer

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->

<%

'========================================

If Session("UserNumber")<> "" Then
    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "FFFFFF"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "000000"
    TableDataBGColor = "E9E9E9"
    ClientFolder= "Tix"
Else
    ClientFolder = "DowntownTheater"
End If

'========================================

If DocType <> "" Then
	Response.Write DocType
Else
	Response.Write "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
End If

%>

<html>
<head>
<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->
<title>Title</title>
<style type="text/css">
body
{
line-height: 1 em;
}
#rounded-corner
{
	font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
	font-size: 12px;
	font-weight: 400;
	width: 550px;
	text-align: left;
	border-collapse: collapse;
}
#rounded-corner thead th.category
{

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
#rounded-corner td.category
{
	padding-top: 5px;
    padding-left: 15px;
	font-size: 15px;
	font-weight: 600;
	color: <%=TableCategoryFontColor%>;
	background: <%=TableCategoryBGColor%>;
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
	padding-top: 5px;
	padding-bottom: 5px;
	font-weight: normal;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-left
{
	padding-top: 2px;
	padding-bottom: 2px;
	text-align: left;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}		
#rounded-corner td.data-right
{	
	padding-top: 2px;
	padding-bottom: 2px;
	padding-right: 15px;
	text-align: right;
	vertical-align: top; 
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.column
{
	padding-top: 5px;
    padding-left: 15px;
	text-align: left;
	color: <%=TableColumnHeadingFontColor%>;
	background: <%=TableColumnHeadingBGColor%>;
}
</style>
</head>

<%= strBody %>

<!--#include virtual="TopNavInclude.asp"-->

<br />
<B>Rounded Corners Demo</B></FONT>
<br />
<br />
old rounded corner:
<IMG src="/clients/downtowntheater/gif/nw.gif">
<br />
<br />
new rounded corner:
<IMG src="/clients/downtowntheater/gif/image.asp?FirstHex=000000&LastHex=ffffff&Src=TopLeftCorner16.txt">
<br />
<br />
<table id="rounded-corner" summary="surveypage">
<thead>
    <tr>
	    <th scope="col" class="category-left"></th>
	    <th scope="col" class="category" colspan="2">&nbsp;</th>
	    <th scope="col" class="category-right"></th>
    </tr>        
</thead>
    <tbody>
    <tr>
	    <td class="category" colspan="4">
	        <b>AUDIENCE SURVEY</b><Br />
	    </td>
    </tr>
   <tr>
        <td class="category" colspan="4">&nbsp;</td>
   </tr>
   <tr>
        <td class="data" colspan="4">&nbsp;</td>
   </tr> 
    <tr>
        <td class="data-right" colspan="2">Question 1<br /><font size=1><i>(please check all that apply)</i></font></td>
        <td class="data-left" colspan="2">
            <INPUT TYPE="checkbox" NAME="Answer1" VALUE="Anwser1">Answer1<BR>
            <INPUT TYPE="checkbox" NAME="Answer1" VALUE="Anwser2">Answer2<BR>
           <INPUT TYPE="checkbox" NAME="Answer1" VALUE="Anwser2">Answer2<BR>               
        </td>
    </tr>
    <tr>
        <td class="data" colspan="4">&nbsp;</td>
    </tr>
    <tr>
        <td class="footer-left">&nbsp;</td>
        <td class="footer" colspan="2">&nbsp;</td>
        <td class="footer-right">&nbsp;</td>
    </tr>
    </tbody>
</table>
<!--#INCLUDE virtual="FooterInclude.asp"-->
</body>
</html>


	
