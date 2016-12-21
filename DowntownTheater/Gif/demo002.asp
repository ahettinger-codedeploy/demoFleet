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
</head>

<%= strBody %>

<!--#include virtual="TopNavInclude.asp"-->
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
	        <b>Table with Static Rounded Corners</b>
	    </td>
   </tr>
   <tr>
        <td class="data" colspan="4">
            This is a demonstration showing static rounded corners.<br />
            <br />
            The rounded corners are graphic images which must be created.<br />
            <br />
            Any change to the color of this table requires new graphics<br />
            <br />
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
<BR />
<BR />



<table id="rounded-corner1" summary="surveypage">
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
	        <b>Rounded Corners with no graphics</b><Br />
	    </td>
   </tr>
   <tr>
        <td class="data" colspan="4">&nbsp;</td>
   </tr> 
   <tr>
        <td class="data" colspan="4">
            This is a demonstration showing non-graphic rounded corners.<br />
            <br />
            Corners are programmed.<br />
            <br />
             Any change to the color of this table simply requires an update to the colors<br />
            <br />
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
<Br />
<br />


	        <b>Other possible uses</b><Br />

<Br />

        	This demonstration allows you to load a template file and define the<br />
			first and last colors in a palette.  The stepping colors in between<br />
			are calculated for you and the end result is an image that can change<br />
			on the fly!<br />
            <Br />
		    <FORM name="MyForm">
            Select an image<br />
			<SELECT name="PrePop" onChange="document.MyForm.SRC.value = this[this.selectedIndex].value">
				<OPTION value="">Predefined Images</OPTION>
				<OPTION value="GoButton.txt">Go Button</OPTION>
				<OPTION value="TopLeftCorner16.txt">Top Left Corner</OPTION>
				<OPTION value="TopRightCorner16.txt">Top Right Corner</OPTION>
				<OPTION value="BottomLeftCorner16.txt">Bottom Left Corner</OPTION>
				<OPTION value="BottomRightCorner16.txt">Bottom Right Corner</OPTION>
			</SELECT><BR>
            <br />
            <br />
			Template File Source:<BR>
			<INPUT name="SRC" value="<%=SRC%>" size="50"><BR>
			<BR>
			<br />
			Select Background Color:<BR>
		    <SELECT name="FirstHex">
				<OPTION value="">choose a color</OPTION>
				<OPTION value="ffffff">white</OPTION>
				<OPTION value="f1f1f1">grey</OPTION>
				<OPTION value="efebe3">this page</OPTION>
			</SELECT><BR>
			<br />
			<br />
			Select Image Color:<BR>
			<SELECT name="LastHex">
				<OPTION value="">choose a color</OPTION>
				<OPTION value="4f0dff">Dark Purple</OPTION>
				<OPTION value="450000">Dark Red</OPTION>
			</SELECT><BR>
			<br />
			<INPUT type="Submit" value="Create Image">
		</FORM>
        <br /><br />
		Image:
		<IMG src="Image.asp?<%=Request.QueryString%>" align="absmiddle"><BR>
        
<!--#INCLUDE virtual="FooterInclude.asp"-->
</body>
</html>


	
