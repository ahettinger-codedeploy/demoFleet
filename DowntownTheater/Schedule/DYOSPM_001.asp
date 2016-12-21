<%

'CHANGE LOG - Inception
'SSR (8/30/2011)
'Custom Survey

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->

<%

'============================================================


'============================================================



'============================================================



'============================================================

'CSS Survey Variables
'This will override the default values
'because I prefer green over gold

    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "FFFFFF"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "000000"
    TableDataBGColor = "E9E9E9"
    
'============================================================


'============================================================


'============================================================

 
'============================================================
	
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

</head>

<%=strBody %>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<table id="rounded-corner" summary="surveypage">
<thead>
    <tr>
	    <th scope="col" class="category-left"></th>
	    <th scope="col" class="category" colspan="2">DESIGN YOUR OWN SCHEDULE PAGE!</th>
	    <th scope="col" class="category-right"></th>
    </tr>        
</thead>
<tbody>
    <tr>
        <td class="data-right" colspan="2">
            Display Season Subscriptions?
        </td>
        <td class="data-left" colspan="2">
            <INPUT TYPE="radio" NAME="Answer1" id="Radio1" VALUE="True" />&nbsp;&nbsp;Yes&nbsp;&nbsp;&nbsp;&nbsp;
            <INPUT TYPE="radio" NAME="Answer1" id="Radio1" VALUE="False"> &nbsp;&nbsp;No&nbsp;&nbsp;&nbsp;&nbsp;
        </td>
    </tr>
    <tr>
        <td class="data-right" colspan="2">
            Display Individual Event List?
        </td>
        <td class="data-left" colspan="2">
            <INPUT TYPE="radio" NAME="Answer2" id="Radio2" VALUE="True" />&nbsp;&nbsp;Yes&nbsp;&nbsp;&nbsp;&nbsp;
            <INPUT TYPE="radio" NAME="Answer2" id="Radio2" VALUE="False"> &nbsp;&nbsp;No&nbsp;&nbsp;&nbsp;&nbsp;
        </td>
    </tr>
    <tr>
        <td class="data-right" colspan="2">
            Display Act Selection List?
        </td>
        <td class="data-left" colspan="2">
            <INPUT TYPE="radio" NAME="Answer3" id="Radio3" VALUE="True" />&nbsp;&nbsp;Yes&nbsp;&nbsp;&nbsp;&nbsp;
            <INPUT TYPE="radio" NAME="Answer3" id="Radio3" VALUE="False"> &nbsp;&nbsp;No&nbsp;&nbsp;&nbsp;&nbsp;
        </td>
    </tr>
    <tr>
        <td class="data-right" colspan="2">
            Display Donation / Membership?
        </td>
        <td class="data-left" colspan="2">
            <INPUT TYPE="radio" NAME="Answer4" id="Radio4" VALUE="True" />&nbsp;&nbsp;Yes&nbsp;&nbsp;&nbsp;&nbsp;
            <INPUT TYPE="radio" NAME="Answer4" id="Radio4" VALUE="False"> &nbsp;&nbsp;No&nbsp;&nbsp;&nbsp;&nbsp;
        </td>
    </tr>
    <tr>
	    <td class="footer-left">&nbsp;</td>
	    <td class="footer" colspan="2">&nbsp;</td>
	    <td class="footer-right">&nbsp;</td>
	</tr>
    </tbody>
</table>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%

End Sub ' SurveyForm

'==========================================================

%>