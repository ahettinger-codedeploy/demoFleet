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

'===============================================

Page = "Management"

'===============================================

'Design Your Own Schedule Page

'===============================================

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
    NECorner="/clients/tix/images/image.asp?FirstHex=efebe3&LastHex=008400&Src=TopLeftCorner16.txt"
    NWCorner="/clients/tix/images/image.asp?FirstHex=efebe3&LastHex=008400&Src=TopRightCorner16.txt"
    SWCorner="/clients/tix/images/image.asp?FirstHex=f3f1ed&LastHex=E9E9E9&Src=BottomLeftCorner16.txt"
    SECorner="/clients/tix/images/image.asp?FirstHex=f3f1ed&LastHex=E9E9E9&Src=BottomRightCorner16.txt"
Else
    NECorner="/clients/tix/images/image.asp?FirstHex=efebe3&LastHex=565f68&Src=TopLeftCorner16.txt"
    NWCorner="/clients/tix/images/image.asp?FirstHex=efebe3&LastHex=565f68&Src=TopRightCorner16.txt"
    SWCorner="/clients/tix/images/image.asp?FirstHex=f3f1ed&LastHex=ded6c8&Src=BottomLeftCorner16.txt"
    SECorner="/clients/tix/images/image.asp?FirstHex=f3f1ed&LastHex=ded6c8&Src=BottomRightCorner16.txt"
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
    font-size: 13px;
    font-weight: 400;
}
}
div.row
{
	color: red;
	background: #008400;
	width: 600px;
	border: 0px solid black;
}
div.category
{
	color: #ffffff;
	background: #008400;
	width: 600px;
	border: 0px solid black;
}
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

<%=strBody %>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<form>

<div class="row">
<hr width="50%" /> 
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
<hr width="50%" /> 
EVENT LISTING
<input type="radio" name="event" value="No" onClick="Hide('div4', this); Reveal('div3', this)" />No
<input type="radio" name="event" value="Yes" onClick="Hide('div3', this); Reveal('div4', this)" CHECKED/>Yes
</div>
<div class="row" id="div3" style="display:none"></div>
<div class="row" id="div4" style="none:none">
Title: <INPUT TYPE="text" NAME="EventTitle" SIZE="23" /><br />
Include Venue:<INPUT TYPE="radio" NAME="EventVenueLocation" VALUE="False" />No<INPUT TYPE="radio" NAME="EventVenueLocation" VALUE="True" CHECKED>Yes
</div> 
<div class="row">
<hr width="50%" /> 
ACT SELECTION LISTING
<input type="radio" name="ActSelectionDisplay" value="False" onClick="Hide('div6', this); Reveal('div5', this)" CHECKED />No
<input type="radio" name="ActSelectionDisplay" value="True" onClick="Hide('div5', this); Reveal('div6', this)"/>Yes
</div>
<div class="row" id="div5" style="display:none"></div>
<div class="row" id="div6" style="display:none">
Title: <INPUT TYPE="text" NAME="ActSelectionTitle" SIZE="23" /><br />
</div> 
<div class="row">
<hr width="50%" /> 
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
<hr width="50%" /> 
DONATION/MEMBERSHIP
<input type="radio" name="DonationDisplay" value="False" onClick="Hide('div10', this); Reveal('div9', this)" CHECKED />No
<input type="radio" name="DonationDisplay" value="True" onClick="Hide('div9', this); Reveal('div10', this)"/>Yes
</div>
<div class="row" id="div9" style="display:none"></div>
<div class="row" id="div10" style="display:none">
Title: <INPUT TYPE="text" NAME="DonationEventsTitle" SIZE="23" /><br />
</div> 
</form>




 
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