<%
    'CHANGE LOG
    'TTT 6/30/2011 - Added check to prevent duplicate VenueReferences
%>

<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->

<%

Page = "Management"

'==========================================================

If Clean(Request("FormName"))="SurveyUpdate" Then
    Call SurveyUpdate	
Else
	Call SurveyForm
End If

OBJdbConnection.Close
Set OBJdbConnection = nothing

'==========================================================

Sub SurveyForm

If DocType <> "" Then
    Response.Write(DocType)
Else
    Response.Write("<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">")
End If

%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<html>

<head>

<title>=<%= Title %></title>


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
	width: 500px;
	text-align: left;
	border-collapse: collapse;
}
#rounded-corner thead th.category
{
	padding-top: 10px;
    padding-bottom: 10px;
    padding-left: 0px;
    padding-right: 1px;
	font-size: 12px;
	font-weight: 600;
	line-height: 2 em;
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
	padding-left: 10px;
	padding-right: 10px;
	padding-top: 10px;
	padding-bottom: 10px;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-left
{
	padding-left: 0px;
	padding-right: 10px;
	padding-top: 10px;
	padding-bottom: 10px;
	text-align: right;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-right
{
	padding-left: 0px;
	padding-right: 0px;
	padding-top: 10px;
	padding-bottom: 10px;
    text-align: left;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.waiver
{
	padding-left: 10px;
	padding-right: 10px;
	padding-top: 10px;
	padding-bottom: 10px;
	font-size: 8px;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
</style>

<script type="text/javascript"> 
 <!-- 
 function Reveal (it, box) { 
 var vis = (box.checked) ? "block" : "none"; 
 document.getElementById(it).style.display = vis;
 } 

 function Hide (it, box) { 
 var vis = (box.checked) ? "none" : "none"; 
 document.getElementById(it).style.display = vis;
 } 
 //--> 
 </script>
 
</head>
 
<body>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<form action="<%= SurveyFileName %>" name="Survey" method="post">
<input type="hidden" name="FormName" value="SurveyUpdate">


<table>
<tr>
<td>

<div class="row">
<hr width="100%" /> 
SEASON SUBSCRIPTIONS
<input type="radio" name="mype" value="ve1" onClick="Hide('div2', this); Reveal('div1', this)" CHECKED/>No
<input type="radio" name="mype" value="value2" onClick="Hide('div1', this); Reveal('div2', this)" />Yes
</div>
<div class="row" id="div1" style="display:none"></div>
<div class="row" id="div2" style="display:none">
Title: <INPUT TYPE="text" NAME="SubscriptionEventsTitle" SIZE="23" /><br />
Include Venue:<INPUT TYPE="radio" NAME="SubscriptionVenueLocation" VALUE="False" />No<INPUT TYPE="radio" NAME="SubscriptionVenueLocation" VALUE="True">Yes
</div>
<div class="row">
<hr width="100%" /> 
EVENT LISTING
<input type="radio" name="event" value="No" onClick="Hide('div4', this); Reveal('div3', this)" CHECKED/>No
<input type="radio" name="event" value="Yes" onClick="Hide('div3', this); Reveal('div4', this)"/>Yes
</div>
<div class="row" id="div3" style="display:none"></div>
<div class="row" id="div4" style="display:none">
Title: <INPUT TYPE="text" NAME="EventTitle" SIZE="23" /><br />
Include Venue:<INPUT TYPE="radio" NAME="EventVenueLocation" VALUE="False" />No<INPUT TYPE="radio" NAME="EventVenueLocation" VALUE="True" CHECKED>Yes
</div> 
<div class="row">
<hr width="100%" /> 
ACT SELECTION LISTING
<input type="radio" name="ActSelectionDisplay" value="False" onClick="Hide('div6', this); Reveal('div5', this)" CHECKED />No
<input type="radio" name="ActSelectionDisplay" value="True" onClick="Hide('div5', this); Reveal('div6', this)"/>Yes
</div>
<div class="row" id="div5" style="display:none"></div>
<div class="row" id="div6" style="display:none">
Title: <INPUT TYPE="text" NAME="ActSelectionTitle" SIZE="23" /><br />
</div> 
<div class="row">
<hr width="100%" /> 
SPECIAL EVENTS LIST
<input type="radio" name="SpecialEventDisplay" value="False" onClick="Hide('div8', this); Reveal('div7', this)" CHECKED />No
<input type="radio" name="SpecialEventDisplay" value="True" onClick="Hide('div7', this); Reveal('div8', this)"/>Yes
</div>
<div class="row" id="div7" style="display:none"></div>
<div class="row" id="div8" style="display:none">
Title: <INPUT TYPE="text" NAME="SpecialEventTitle" SIZE="23" /><br />
Include Venue:<INPUT TYPE="radio" NAME="SpecialEventVenueLocation" VALUE="False" />No<INPUT TYPE="radio" NAME="SpecialEventVenueLocation" VALUE="True">YesM<br />
Include Date:<INPUT TYPE="radio" NAME="SpecialEventDateDisplay" VALUE="False" />No<INPUT TYPE="radio" NAME="SpecialEventDateDisplay" VALUE="True">Yes<br />
EventCodes: <INPUT TYPE="text" NAME="SpecialEventList" SIZE="23" /><br />
</div> 
<div class="row">
<hr width="100%" /> 
DONATION/MEMBERSHIP
<input type="radio" name="DonationDisplay" value="False" onClick="Hide('div10', this); Reveal('div9', this)" CHECKED />No
<input type="radio" name="DonationDisplay" value="True" onClick="Hide('div9', this); Reveal('div10', this)"/>Yes
</div>
<div class="row" id="div9" style="display:none"></div>
<div class="row" id="div10" style="display:none">
Title: <INPUT TYPE="text" NAME="DonationEventsTitle" SIZE="23" /><br />
</div> 
<div class="row">
<hr width="100%" /> 
</div>

</td>
</tr>
</table>

<input type="submit" name="submit" value="Continue">
</form>
 
<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%

End Sub ' SurveyForm


'==========================================================
	
Sub SurveyUpdate

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
	font-size: 11px;
    font-weight: 400;
	width: 100px;
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
	padding-left: 25px;
	padding-right: 25px;
	padding-top: 15px;
	padding-bottom: 15px;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
</style>


</head>

<body>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<table id="rounded-corner" summary="surveypage" border="1" width="200">
<thead>
    <tr>
        <th scope="col" class="category-left"></th>
        <th scope="col" class="category" colspan="2"><b>Form Request</b></th>
        <th scope="col" class="category-right"></th>
    </tr>        
</thead>
<tbody>
<%
for x = 1 to Request.Form.count() 
%>
<tr>
    <td class="data-left" colspan="2"><%=Response.Write(Request.Form.key(x) & " = ")%></td>
    <td class="data-right" colspan="2"><%=Response.Write(Request.Form.item(x) & "<br>")%></td>
</tr> 
<% 
next 
%>
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

<%

End Sub 'SurveyUpdate

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