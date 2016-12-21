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


NECorner="/clients/downtowntheater/gif/image.asp?FirstHex=efebe3&LastHex=565f68&Src=TopLeftCorner16.txt"

NWCorner="/clients/downtowntheater/gif/image.asp?FirstHex=efebe3&LastHex=565f68&Src=TopRightCorner16.txt"

SWCorner="/clients/downtowntheater/gif/image.asp?FirstHex=f3f1ed&LastHex=ded6c8&Src=BottomLeftCorner16.txt"

SECorner="/clients/downtowntheater/gif/image.asp?FirstHex=f3f1ed&LastHex=ded6c8&Src=BottomRightCorner16.txt"

%>

<%
SRC = Request.QueryString("SRC")
FirstHex = Request.QueryString("FirstHex")
LastHex = Request.QueryString("LastHex")
%>

<html>
<head>
<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->
<title>Title</title>

<style type="text/css">
body
{
line-height: 1.5 em;
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
	text-align: center;
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

<style type="text/css">
body
{
line-height: 1.5 em;
}
#rounded-corner1
{
	font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
	font-size: 12px;
	font-weight: 400;
	width: 550px;
	text-align: left;
	border-collapse: collapse;
}
#rounded-corner1 thead th.category
{
	color: <%=TableCategoryFontColor%>;
	background: <%=TableCategoryBGColor%>;
}
#rounded-corner1 thead th.category-left
{
	background: <%=TableCategoryBGColor%> url('<%=NECorner%>') left -1px no-repeat;
	text-align: right;
}
#rounded-corner1 thead th.category-right
{
	background: <%=TableCategoryBGColor%> url('<%=NWCorner%>') right -1px no-repeat;
    text-align: left;
}
#rounded-corner1 td.category
{
	padding-top: 5px;
    padding-left: 15px;
	font-size: 15px;
	font-weight: 600;
	color: <%=TableCategoryFontColor%>;
	background: <%=TableCategoryBGColor%>;
}
#rounded-corner1 td.footer
{
	background: <%=TableDataBGColor%>;
}
#rounded-corner1 td.footer-left
{
	background: <%=TableDataBGColor%> url('<%=SWCorner%>') left bottom no-repeat;
}
#rounded-corner1 td.footer-right
{
	background: <%=TableDataBGColor%> url('<%=SECorner%>') right bottom no-repeat;
}
#rounded-corner1 td.data
{
	padding-top: 5px;
	padding-bottom: 5px;
	text-align: center;
	font-weight: normal;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner1 td.data-left
{
	padding-top: 2px;
	padding-bottom: 2px;
	text-align: left;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}		
#rounded-corner1 td.data-right
{	
	padding-top: 2px;
	padding-bottom: 2px;
	padding-right: 15px;
	text-align: right;
	vertical-align: top; 
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner1 td.column
{
	padding-top: 5px;
    padding-left: 15px;
	text-align: left;
	color: <%=TableColumnHeadingFontColor%>;
	background: <%=TableColumnHeadingBGColor%>;
}
</style>

<script type="text/javascript" >
  function showfield(name){
    if(name=='lstbox')document.getElementById('div1').style.display="block";
    else document.getElementById('div1').style.display="none";
  }
 
  function hidefield() {
 document.getElementById('div1').style.display='none';
 }

function showfield2(name){
    if(name=='chkbox')document.getElementById('div2').style.display="block";
    else document.getElementById('div2').style.display="none";
  }
 
  function hidefield2() {
 document.getElementById('div2').style.display='none';
 }

</script>

</head>

<%= strBody %>

<!--#include virtual="TopNavInclude.asp"-->
<br />

<html>

<head>

</head>

<body onload = "hidefield(), hidefield2()">

<form action = "test3.php" method = "post">

Please enter a name for the App <input type = "text" name = "name">

<table id="table1" border = "1">
<tr>
    <th>Choose a Label</th><th>Choose an element</th>
</tr>
<tr>
    <td><input type = "text" name = "label1" /></td> 
    <td> 
        <select name = "elementtype1" id="elementtype1" onchange="showfield(this.options[this.selectedIndex].value), showfield2(this.options[this.selectedIndex].value)">
            <option value = 000> Select an option...</option>
            <option value='txtbox'>Text Box</option>
            <option value='lstbox'>List Box</option>
            <option value='chkbox'>Check Box</option>
            <option value='radio'>Radio Button</option>
        </select>
    </td>
    <td>
    <div id="div1">Enter Listbox options: <input type="text" name="whatever1" /></div>
    <div id="div2">Enter Checkbox options: <input type="text" name="whatever2" /></div>
    </td>
</tr>
</table>

<input type = "submit" value = "Submit">

</form>
        
<!--#INCLUDE virtual="FooterInclude.asp"-->
</body>
</html>


	
