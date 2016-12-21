<%

'CHANGE LOG

'SSR (9/16/2011) Created survey

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'===============================================

Page = "Survey"
SurveyNumber = 1086
SurveyName = "Registration.asp"

'===============================================

'Sioux Empire Community Theatre, Inc.

EventCodeList = 426939

'===============================================

'Page 1
'-------
'Attendee Informaton
'Patron is required to fill out all answers on this form

FormName1 = "Attendee Information"
FormHeader1 = "Please complete the following information for each attendee"

Dim Question(10)
Question(1) = "Student First Name"
Question(2) = "Student Last Name"
Question(3) = "Guardian First Name"
Question(4) = "Guardian Last Name"
Question(5) = "Address"
Question(6) = "City"
Question(7) = "State"
Question(8) = "Telephone number"
Question(9) = "Email Address"
Question(10) = "Current Grade"


'===============================================

'Check to see if Order Number exists.  
'If not, redirect to Home Page.

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

'===============================================

'CSS Survey Variables

If Session("UserNumber")<> "" Then
    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "#FFFFFF"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "#000000"
    TableDataBGColor = "#E9E9E9"
End If

'LastHex = box color
'FirstHex = background color

If Session("UserNumber")<> "" Then
    NECorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=008400&Src=TopLeftCorner16.txt"
    NWCorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=008400&Src=TopRightCorner16.txt"
    SWCorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=E9E9E9&Src=BottomLeftCorner16.txt"
    SECorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=E9E9E9&Src=BottomRightCorner16.txt"
Else
    NECorner="/clients/tix/images/image.asp?FirstHex=efebe3&LastHex=565f68&Src=TopLeftCorner16.txt"
    NWCorner="/clients/tix/images/image.asp?FirstHex=efebe3&LastHex=565f68&Src=TopRightCorner16.txt"
    SWCorner="/clients/tix/images/image.asp?FirstHex=f3f1ed&LastHex=ded6c8&Src=BottomLeftCorner16.txt"
    SECorner="/clients/tix/images/image.asp?FirstHex=f3f1ed&LastHex=ded6c8&Src=BottomRightCorner16.txt"
End If

'===============================================

Select Case Clean(Request("FormName"))

    Case "SurveyUpdate"
        Call SurveyUpdate
    Case "EventListUpdate"
        Call EventListUpdate
    Case "Continue"
        Call Continue
    Case Else
        Call SurveyForm(Message)
        
End Select

'===============================================

Sub SurveyForm(Message)


SQLTicketCount = "SELECT Count(LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Event.EventCode IN (" & EventCodeList & ")"
Set rsTicketCount = OBJdbConnection.Execute(SQLTicketCount)
TicketCount = rsTicketCount("TicketCount")
rsTicketCount.Close
Set rsTicketCount = nothing  

%>

<!DOCTYPE html>

<html>

<head>

<title>TIX Support</title>

<!--#INCLUDE VIRTUAL="TopNavInclude.asp"-->

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

<script type="text/javascript" src="sw-js/jquery-1.4.2.min.js"></script>

<script type="text/javascript" src="sw-js/jquery.smartWizard-2.0.min.js"></script>

<style>

.swMain {
  position:relative;
  display:block;
  margin:0;
  padding:0;
  overflow:visible;
  float:left;
  width:780px;
}
.stepContainer 
{
  display:block;
  position: relative;
  margin: 0;
  padding:0;       
  overflow:hidden;
  clear:right;
}

.stepContainer div.content {
  display:block;
  position: absolute;  
  float:left;
  margin: 0;
  padding:5px;    
  font: normal 12px Verdana, Arial, Helvetica, sans-serif; 
  color:#5A5655;   
  background-color:#F8F8F8;  
  text-align:left;  
  width:780px;
  z-index:88; 
  -webkit-border-radius: 5px;
  -moz-border-radius  : 5px;
  clear:both;
}

.swMain div.actionBar {
  display:block;
  position: relative; 
  clear:right;
  margin:             3px 0 0 0;   
  padding:            0;    
  color:              #5A5655;   
  background-color: white;
  height:40px;
  text-align:left;   
  z-index:88; 
  -webkit-border-radius: 5px;
  -moz-border-radius  : 5px;

}

.swMain .stepContainer .StepTitle {
  display:block;
  position: relative;
  margin:0;   
  padding:5px;   
  font: bold 16px Verdana, Arial, Helvetica, sans-serif; 
  color:#5A565;   
  background-color:#E0E0E0;
  clear:both;
  text-align:left; 
  z-index:88;
  -webkit-border-radius: 5px 5px 0px 0px;  
  -moz-border-radius: 5px 5px 0px 0px;    
}

.swMain ul.anchor {
  position: relative;
  display:block;
  float:left;
  list-style: none;
  padding: 0px;  
  margin: 5px 10px 0 0;   
  background: transparent; /*#EEEEEE */
}
.swMain ul.anchor li{ 
  position: relative; 
  display:block;
  margin: 0;
  padding: 0; 
  padding-top:3px;
  padding-bottom: 3px;
  border: 0px solid #E0E0E0;      
  float: left;
  clear:both;
}
/* Anchor Element Style */
.swMain ul.anchor li a {
  display:block;
  position:relative;
  float:left;
  margin:0;
  padding:3px;
  height:70px;
  width:230px;
  text-decoration: none;
  outline-style:none;
  -moz-border-radius  : 5px;
  -webkit-border-radius: 5px;
  z-index:99;
}

.swMain ul.anchor li a .stepNumberNew {background: none repeat scroll 0 0 #067EAD; color: #FFFFFF; background: none repeat scroll 0 0 #EFEFEF; border-radius: 30px 30px 30px 30px; color: #818181; display: block; font-size: 32px; left: 0; line-height: 62px; position: absolute; text-align: center; top: 6px; width: 62px;}

.swMain ul.anchor li a .stepNumber
{
  position:relative;
  float:left;
  width:30px;
  text-align: center;
  padding:5px;
  padding-top:0;
  font: bold 45px Verdana, Arial, Helvetica, sans-serif;
}


.swMain ul.anchor li a .stepDesc{
  position:relative;
  display:block;
  float:left;
  text-align: left;
  padding:5px;
  width:70%;
  font: bold 18px Verdana, Arial, Helvetica, sans-serif;
}
.swMain ul.anchor li a .stepDesc small{
  font: normal 12px Verdana, Arial, Helvetica, sans-serif;
}
.swMain ul.anchor li a.selected{
  color: black;
  background: white;  
  border: 1px solid black;
  cursor:text;
 /*  -moz-box-shadow: 1px 5px 10px #888;  */
 /*  -webkit-box-shadow: 1px 5px 10px #888;  */
/*   box-shadow: 1px 5px 10px #888;  */
}
.swMain ul.anchor li a.selected:hover {
  color:#F8F8F8;  
  background: white;  
}

.swMain ul.anchor li a.done { 
  position:relative;
  color:#FFF;  
  background: #8CC63F;  
  border: 1px solid #8CC63F;   
  z-index:99;
}
.swMain ul.anchor li a.done:hover {
  color:#5A5655;  
  background: #8CC63F; 
  border: 1px solid #5A5655;   
}
.swMain ul.anchor li a.disabled {
  color:#CCCCCC;  
  background: #F8F8F8;
  border: 1px solid #CCC;  
  cursor:text;   
}
.swMain ul.anchor li a.disabled:hover {
  color:#CCCCCC;  
  background: #F8F8F8;     
}

.swMain ul.anchor li a.error {
  color:#6c6c6c !important;  
  background: #f08f75 !important;
  border: 1px solid #fb3500 !important;      
}
.swMain ul.anchor li a.error:hover {
  color:#000 !important;       
}

.swMain .buttonNext {
  display:block;
  float:right;
  margin:5px 3px 0 3px;
  padding:5px;
  text-decoration: none;
  text-align: center;
  font: bold 13px Verdana, Arial, Helvetica, sans-serif;
  width:100px;
  color:#FFF;
  outline-style:none;
  background-color:   #5A5655;
  border: 1px solid #5A5655;
  -moz-border-radius  : 5px; 
  -webkit-border-radius: 5px;    
}
.swMain .buttonDisabled {
  color:#F8F8F8  !important;
  background-color: #CCCCCC !important;
  border: 1px solid #CCCCCC  !important;
  cursor:text;    
}
.swMain .buttonPrevious {
  display:block;
  float:right;
  margin:5px 3px 0 3px;
  padding:5px;
  text-decoration: none;
  text-align: center;
  font: bold 13px Verdana, Arial, Helvetica, sans-serif;
  width:100px;
  color:#FFF;
  outline-style:none;
  background-color:   #5A5655;
  border: 1px solid #5A5655;
  -moz-border-radius  : 5px; 
  -webkit-border-radius: 5px;    
}
.swMain .buttonFinish {
  display:block;
  float:right;
  margin:5px 10px 0 3px;
  padding:5px;
  text-decoration: none;
  text-align: center;
  font: bold 13px Verdana, Arial, Helvetica, sans-serif;
  width:100px;
  color:#FFF;
  outline-style:none;
  background-color:   #5A5655;
  border: 1px solid #5A5655;
  -moz-border-radius  : 5px; 
  -webkit-border-radius: 5px;    
}

/* Form Styles */

.txtBox {
  border:1px solid #CCCCCC;
  color:#5A5655;
  font:13px Verdana,Arial,Helvetica,sans-serif;
  padding:2px;
  width:430px;
}
.txtBox:focus {
  border:1px solid #EA8511;
}

.swMain .loader {
  position:relative;  
  display:none;
  float:left;  
  margin: 2px 0 0 2px;
  padding:8px 10px 8px 40px;
  border: 1px solid #FFD700; 
  font: bold 13px Verdana, Arial, Helvetica, sans-serif; 
  color:#5A5655;       
  background: #FFF url(../images/loader.gif) no-repeat 5px;  
  -moz-border-radius  : 5px;
  -webkit-border-radius: 5px;
  z-index:998;
}
.swMain .msgBox {
  position:relative;  
  display:none;
  float:left;
  margin: 4px 0 0 5px;
  padding:5px;
  border: 1px solid #FFD700; 
  background-color: #FFFFDD;  
  font: normal 12px Verdana, Arial, Helvetica, sans-serif; 
  color:#5A5655;         
  -moz-border-radius  : 5px;
  -webkit-border-radius: 5px;
  z-index:999;
  min-width:200px;  
}
.swMain .msgBox .content {
  font: normal 12px Verdana,Arial,Helvetica,sans-serif;
  padding: 0px;
  float:left;
}
.swMain .msgBox .close {
  border: 1px solid #CCC;
  border-radius: 3px;
  color: #CCC;
  display: block;
  float: right;
  margin: 0 0 0 5px;
  outline-style: none;
  padding: 0 2px 0 2px;
  position: relative;
  text-align: center;
  text-decoration: none;
}
.swMain .msgBox .close:hover{
  color: #EA8511;
  border: 1px solid #EA8511;  
}
</style>

<style>
audio:not([controls]) { display: none; }
html { font-size: 100%; }
button, input, select, textarea { margin: 0pt; font-size: 100%; vertical-align: middle; }
button, input { line-height: normal; }
button::-moz-focus-inner, input::-moz-focus-inner { padding: 0pt; border: 0pt none; }
button, input[type="button"], input[type="reset"], input[type="submit"] { cursor: pointer; }
textarea { overflow: auto; vertical-align: top; }
body { margin: 0pt; font-family: "PT Sans",Arial,sans-serif; font-size: 13px; line-height: 18px; color: rgb(147, 150, 153); background-color: rgb(245, 245, 245); }
p { margin: 0pt 0pt 9px; }
h1, h2, h3, h4, h5, h6 { margin: 0pt; font-family: inherit; font-weight: bold; color: rgb(82, 82, 82); text-rendering: optimizelegibility; }
fieldset { padding: 0pt; margin: 0pt; border: 0pt none; }
label, input, button, select, textarea { font-size: 13px; font-weight: normal; line-height: 18px; }
input, button, select, textarea { font-family: "PT Sans",Arial,sans-serif; }
label { display: block; margin-bottom: 5px; }
select, textarea, input[type="text"], input[type="password"], input[type="datetime"], input[type="datetime-local"], input[type="date"], input[type="month"], input[type="time"], input[type="week"], input[type="number"], input[type="email"], input[type="url"], input[type="search"], input[type="tel"], input[type="color"], .uneditable-input { display: inline-block; height: 18px; padding: 4px; margin-bottom: 9px; font-size: 13px; line-height: 18px; color: rgb(85, 85, 85); }
input, textarea { width: 210px; }
textarea { height: auto; }
textarea, input[type="text"], input[type="password"], input[type="datetime"], input[type="datetime-local"], input[type="date"], input[type="month"], input[type="time"], input[type="week"], input[type="number"], input[type="email"], input[type="url"], input[type="search"], input[type="tel"], input[type="color"], .uneditable-input { background-color: rgb(255, 255, 255); border: 1px solid rgb(204, 204, 204); border-radius: 3px 3px 3px 3px; box-shadow: 0pt 1px 1px rgba(0, 0, 0, 0.075) inset; -moz-transition: border 0.2s linear 0s, box-shadow 0.2s linear 0s; }
textarea:focus, input[type="text"]:focus, input[type="password"]:focus, input[type="datetime"]:focus, input[type="datetime-local"]:focus, input[type="date"]:focus, input[type="month"]:focus, input[type="time"]:focus, input[type="week"]:focus, input[type="number"]:focus, input[type="email"]:focus, input[type="url"]:focus, input[type="search"]:focus, input[type="tel"]:focus, input[type="color"]:focus, .uneditable-input:focus { border-color: rgba(82, 168, 236, 0.8); outline: 0pt none; box-shadow: 0pt 1px 1px rgba(0, 0, 0, 0.075) inset, 0pt 0pt 8px rgba(82, 168, 236, 0.6); }
input[type="radio"], input[type="checkbox"] { margin: 3px 0pt; line-height: normal; cursor: pointer; }
input[type="submit"], input[type="reset"], input[type="button"], input[type="radio"], input[type="checkbox"] { width: auto; }
select, input[type="file"] { height: 28px; line-height: 28px; }
select { width: 220px; border: 1px solid rgb(187, 187, 187); }
select:focus, input[type="file"]:focus, input[type="radio"]:focus, input[type="checkbox"]:focus { outline: thin dotted rgb(51, 51, 51); outline-offset: -2px; }
.radio, .checkbox { min-height: 18px; padding-left: 18px; }
.radio input[type="radio"], .checkbox input[type="checkbox"] { float: left; margin-left: -18px; }
.controls > .radio:first-child, .controls > .checkbox:first-child { padding-top: 5px; }
.input-xlarge { width: 270px; }
input, textarea, .uneditable-input { margin-left: 0pt; }
input:focus:required:invalid, textarea:focus:required:invalid, select:focus:required:invalid { color: rgb(185, 74, 72); border-color: rgb(238, 95, 91); }
input:focus:required:invalid:focus, textarea:focus:required:invalid:focus, select:focus:required:invalid:focus { border-color: rgb(233, 50, 45); box-shadow: 0pt 0pt 6px rgb(248, 185, 183); }
.form-actions { padding: 17px 20px 18px; margin-top: 18px; margin-bottom: 18px; background-color: rgb(255, 255, 255); border-top: 1px solid rgb(229, 229, 229); }
.form-actions:before, .form-actions:after { display: table; content: ""; }
.form-actions:after { clear: both; }
:-moz-placeholder { color: rgb(153, 153, 153); }
.help-block, .help-inline { color: rgb(85, 85, 85); }
.help-block { display: block; margin-bottom: 9px; }
.form-search input, .form-inline input, .form-horizontal input, .form-search textarea, .form-inline textarea, .form-horizontal textarea, .form-search select, .form-inline select, .form-horizontal select, .form-search .help-inline, .form-inline .help-inline, .form-horizontal .help-inline, .form-search .uneditable-input, .form-inline .uneditable-input, .form-horizontal .uneditable-input, .form-search .input-prepend, .form-inline .input-prepend, .form-horizontal .input-prepend, .form-search .input-append, .form-inline .input-append, .form-horizontal .input-append { display: inline-block; margin-bottom: 0pt; }
.control-group { margin-bottom: 9px; }

.form-horizontal .control-group { margin-bottom: 18px; }
.form-horizontal .control-group:before, .form-horizontal .control-group:after { display: table; content: ""; }
.form-horizontal .control-group:after { clear: both; }
.form-horizontal .control-label { float: left; width: 150px; padding-top: 5px; text-align: right; }
.form-horizontal .controls { margin-left: 160px; }
.form-horizontal .controls:first-child {  }
.form-horizontal .help-block { margin-top: 9px; margin-bottom: 0pt; }
.form-horizontal .form-actions { padding-left: 160px; }

.table-striped tbody tr:nth-child(2n+1) td, .table-striped tbody tr:nth-child(2n+1) th { background-color: rgb(249, 249, 249); }
.btn { display: inline-block; padding: 4px 10px; margin-bottom: 0pt; font-size: 13px; line-height: 18px; color: rgb(51, 51, 51); text-align: center; text-shadow: 0pt 1px 1px rgba(255, 255, 255, 0.75); vertical-align: middle; cursor: pointer; background-color: rgb(245, 245, 245); background-image: -moz-linear-gradient(center top , rgb(255, 255, 255), rgb(230, 230, 230)); background-repeat: repeat-x; border-width: 1px; border-style: solid; border-color: rgb(204, 204, 204) rgb(204, 204, 204) rgb(179, 179, 179); -moz-border-top-colors: none; -moz-border-right-colors: none; -moz-border-bottom-colors: none; -moz-border-left-colors: none; -moz-border-image: none; border-radius: 4px 4px 4px 4px; box-shadow: 0pt 1px 0pt rgba(255, 255, 255, 0.2) inset, 0pt 1px 2px rgba(0, 0, 0, 0.05); }
.btn:hover, .btn:active, .btn.active, .btn.disabled, .btn[disabled] { background-color: rgb(230, 230, 230); }
.btn:active, .btn.active {  }
.btn:first-child {  }
.btn:hover { color: rgb(51, 51, 51); text-decoration: none; background-color: rgb(230, 230, 230); background-position: 0pt -15px; -moz-transition: background-position 0.1s linear 0s; }
.btn:focus { outline: thin dotted rgb(51, 51, 51); outline-offset: -2px; }
.btn.active, .btn:active { background-color: rgb(230, 230, 230); background-image: none; outline: 0pt none; box-shadow: 0pt 2px 4px rgba(0, 0, 0, 0.15) inset, 0pt 1px 2px rgba(0, 0, 0, 0.05); }
.btn-large { padding: 9px 14px; font-size: 15px; line-height: normal; border-radius: 5px 5px 5px 5px; }
.btn-primary, .btn-primary:hover, .btn-warning, .btn-warning:hover, .btn-danger, .btn-danger:hover, .btn-success, .btn-success:hover, .btn-info, .btn-info:hover, .btn-inverse, .btn-inverse:hover { color: rgb(255, 255, 255); text-shadow: 0pt -1px 0pt rgba(0, 0, 0, 0.25); }
.btn { border-color: rgba(0, 0, 0, 0.1) rgba(0, 0, 0, 0.1) rgba(0, 0, 0, 0.25); }
.btn-primary { background-color: rgb(95, 155, 32); background-image: -moz-linear-gradient(center top , rgb(107, 155, 32), rgb(76, 155, 32)); background-repeat: repeat-x; border-color: rgba(0, 0, 0, 0.1) rgba(0, 0, 0, 0.1) rgba(0, 0, 0, 0.25); }
.btn-primary:hover, .btn-primary:active, .btn-primary.active, .btn-primary.disabled, .btn-primary[disabled] { background-color: rgb(76, 155, 32); }
.btn-primary:active, .btn-primary.active {  }
button.btn, input.btn[type="submit"] {  }
button.btn::-moz-focus-inner, input.btn[type="submit"]::-moz-focus-inner { padding: 0pt; border: 0pt none; }
button.btn.btn-large, input.btn.btn-large[type="submit"] {  }
@font-face {
	font-family: "FontAwesome";
	font-style: normal;
	font-weight: normal;
	src: url('fontawesome-webfont.eot@') format("embedded-opentype"), url('@22@22') format("woff"), url('fontawesome-webfont.ttf') format("truetype"), url('fontawesome-webfont.svg') format("svg");
}
body { background-image: url('@22@22'); background-repeat: repeat; background-position: center center; }
h1, h2, h3, h4, h5, h6 { margin: 0pt; line-height: normal; }
h1:first-child, h2:first-child, h3:first-child, h4:first-child, h5:first-child, h6:first-child { margin-top: 0pt; }
.data-block .data-container > :last-child { margin-bottom: 20px; }
.btn { box-shadow: 0pt 1px 2px rgba(0, 0, 0, 0.05); }
.btn.btn-alt { border-radius: 18px 18px 18px 18px; box-shadow: 0pt 1px 0pt rgba(255, 255, 255, 0.15) inset, 0pt 1px 2px rgba(0, 0, 0, 0.15); }
.btn.btn-alt.btn-large { border-radius: 22px 22px 22px 22px; }
.btn.btn-alt.btn-primary { box-shadow: 0pt 1px 0pt rgba(255, 255, 255, 0.15) inset, 0pt 1px 2px rgba(0, 0, 0, 0.5); }
.table.table-striped tbody tr:nth-child(2n+1) td, .table.table-striped tbody tr:nth-child(2n+1) th { background-color: rgb(248, 248, 248); }
label { font-weight: bold; color: rgb(82, 82, 82); }
label.radio, label.checkbox { font-weight: normal; color: rgb(82, 84, 89); }
.form-horizontal .control-label { text-align: left; }
.control-group, .form-horizontal .control-group { margin: 0pt; padding: 10px; border-bottom: 1px dashed #ffffff;}
.control-group:last-child, .form-horizontal .control-group:last-child { border: medium none; }
.form-actions { border: medium none; background-color: transparent; margin: 0pt; }
.form-horizontal .form-actions { padding-left: 180px; }
textarea:focus, input[type="text"]:focus, input[type="password"]:focus, input[type="datetime"]:focus, input[type="datetime-local"]:focus, input[type="date"]:focus, input[type="month"]:focus, input[type="time"]:focus, input[type="week"]:focus, input[type="number"]:focus, input[type="email"]:focus, input[type="url"]:focus, input[type="search"]:focus, input[type="tel"]:focus, input[type="color"]:focus, .uneditable-input:focus { border-color: rgb(191, 191, 191); box-shadow: 0pt 1px 1px rgba(0, 0, 0, 0.075) inset, 0pt 0pt 8px rgba(0, 0, 0, 0.2); }
</style>


<script type="text/javascript" src="sw-js/jquery.smartWizard-2.0.min.js"></script>

<script type="text/javascript">
$(document).ready(function(){

	$("#A1").change(function() {
		$("#B1").val($("#A1").val());
	});

});
</script>

<script type="text/javascript">
$(document).ready(function(){
// Smart Wizard	
$('#wizard').smartWizard({transitionEffect:'fade'});

function leaveAStepCallback(obj){
        var step_num= obj.attr('rel');
        return validateSteps(step_num);
      }
      
      function onFinishCallback(){
       if(validateAllSteps()){
        $('form').submit();
       }
      }
            
		});
	   
    function validateAllSteps(){
       var isStepValid = true;
       
       if(validateStep1() == false){
         isStepValid = false;
         $('#wizard').smartWizard('setError',{stepnum:1,iserror:true});         
       }else{
         $('#wizard').smartWizard('setError',{stepnum:1,iserror:false});
       }
       
       if(validateStep3() == false){
         isStepValid = false;
         $('#wizard').smartWizard('setError',{stepnum:3,iserror:true});         
       }else{
         $('#wizard').smartWizard('setError',{stepnum:3,iserror:false});
       }
       
       if(!isStepValid){
          $('#wizard').smartWizard('showMessage','Please correct the errors the steps and continue');
       }
              
       return isStepValid;
    } 	
		
		
		function validateSteps(step){
		  var isStepValid = true;
      // validate step 1
      if(step == 1){
        if(validateStep1() == false ){
          isStepValid = false; 
          $('#wizard').smartWizard('showMessage','Please correct the errors in step'+step+ ' and click next.');
          $('#wizard').smartWizard('setError',{stepnum:step,iserror:true});         
        }else{
          $('#wizard').smartWizard('setError',{stepnum:step,iserror:false});
        }
      }
      
      // validate step3
      if(step == 3){
        if(validateStep3() == false ){
          isStepValid = false; 
          $('#wizard').smartWizard('showMessage','Please correct the errors in step'+step+ ' and click next.');
          $('#wizard').smartWizard('setError',{stepnum:step,iserror:true});         
        }else{
          $('#wizard').smartWizard('setError',{stepnum:step,iserror:false});
        }
      }
      
      return isStepValid;
    }
		
		function validateStep1(){
       var isValid = true; 
       // Validate Username
       var un = $('#username').val();
       if(!un && un.length <= 0){
         isValid = false;
         $('#msg_username').html('Please fill username').show();
       }else{
         $('#msg_username').html('').hide();
       }
       
       // validate password
       var pw = $('#password').val();
       if(!pw && pw.length <= 0){
         isValid = false;
         $('#msg_password').html('Please fill password').show();         
       }else{
         $('#msg_password').html('').hide();
       }
       
       // validate confirm password
       var cpw = $('#cpassword').val();
       if(!cpw && cpw.length <= 0){
         isValid = false;
         $('#msg_cpassword').html('Please fill confirm password').show();         
       }else{
         $('#msg_cpassword').html('').hide();
       }  
       
       // validate password match
       if(pw && pw.length > 0 && cpw && cpw.length > 0){
         if(pw != cpw){
           isValid = false;
           $('#msg_cpassword').html('Password mismatch').show();            
         }else{
           $('#msg_cpassword').html('').hide();
         }
       }
       return isValid;
    }
    
    function validateStep3(){
      var isValid = true;    
      //validate email  email
      var email = $('#email').val();
       if(email && email.length > 0){
         if(!isValidEmailAddress(email)){
           isValid = false;
           $('#msg_email').html('Email is invalid').show();           
         }else{
          $('#msg_email').html('').hide();
         }
       }else{
         isValid = false;
         $('#msg_email').html('Please enter email').show();
       }       
      return isValid;
    }
    
    // Email Validation
    function isValidEmailAddress(emailAddress) {
      var pattern = new RegExp(/^(("[\w-\s]+")|([\w-]+(?:\.[\w-]+)*)|("[\w-\s]+")([\w-]+(?:\.[\w-]+)*))(@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$)|(@\[?((25[0-5]\.|2[0-4][0-9]\.|1[0-9]{2}\.|[0-9]{1,2}\.))((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\.){2}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\]?$)/i);
      return pattern.test(emailAddress);
    } 
		
		
</script>

</head>

<% If Message = "" Then %>
    <body>
<% Else %>
	<body onLoad="alert('<%= Message %>');" <%= BodyParameters %>>
<% End If %>

<table align="center" border="0" cellpadding="0" cellspacing="0">
<tr><td> 

<form action="<%= SurveyFileName %>" name="Survey" class="form-horizontal">
<input type="hidden" name="FormName" value="SurveyUpdate">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">

<!-- Tabs -->
  		<div id="wizard" class="swMain">
  			<ul>
			
			<% For i = 1 to TicketCount %>
			
				<li>
					<a href="#step-<%=i%>">
						<label class="stepNumber"><%=i%></label>
						<span class="stepDesc">Attendee Name</span>
					</a>
				</li>
				
			<% Next %>	
			
  			</ul>
			
			<% For j = 1 to TicketCount %>
			
			<div id="step-<%=j%>" style="background-color: white;">	
			
				<h2 class="StepTitle"><span id="guestname">Attendee <%=j%></span> Registration Form</h2>
				
					<fieldset style="background-color: #f1f1f1; margin-top: 10px;">
					<% For k = 1 to UBound(Question) %>
					
						<div class="control-group">
							<label class="control-label" for="input"><%=question(k)%></label>
							<input type="text" name="Answer<%=k%>" id="Answer<%=k%>_<%=j%>">
						</div>
						
					<% Next %>		
					</fieldset>  	
				
			</div>
			
			<% Next %>	

  		
<!-- End SmartWizard Content -->  		
</form>
</td></tr>
</table> 
	
</body>

</html>

<%

End Sub

'==========================================================

Sub SurveyUpdate

    SQLRequiredTicketCount = "SELECT COUNT(OrderLine.ItemNumber) AS Count FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.ItemType = 'Seat'"' GROUP BY Seat.EventCode ORDER BY Seat.EventCode"
    Set rsRequiredTicketCount = OBJdbConnection.Execute(SQLRequiredTicketCount)        
        If Not rsRequiredTicketCount.EOF Then
            AvailOfferCount = rsRequiredTicketCount("Count")
        End If    	
    rsRequiredTicketCount.Close
    Set rsRequiredTicketCount = nothing  

    For i = 1 To AvailOfferCount
            
        SQLEvent = "SELECT Event.EventCode, Event.EventDate, Act.Act, Venue.Venue FROM OrderLine WITH (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event WITH (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act WITH (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue WITH (ROWLOCK) ON Event.VenueCode = Venue.VenueCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.LineNumber = " & i & " GROUP BY Event.EventCode, Event.EventDate, Act.Act, Venue.Venue ORDER BY Event.EventDate, Act.Act, Venue.Venue"
        Set rsEvent = OBJdbConnection.Execute(SQLEvent)    

            For j = 1 to UBound(Question)                        
                        
                '----------------------------

                'Delete existing Answer record for this line number.
                SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & i & " AND FieldName = 'Answer" & j & "'"
                Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)

                'Insert Answer record for this line number.          
                SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & i & ", 'Answer" & j & "', '" & Clean(Request("Answer"&j&"_"&i)) & "'  )"            
                Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)
                               
                '----------------------------
  
            Next

        rsEvent.Close
        Set rsEvent = nothing
            
        Next        
	
Call FormValidate
    
    
    
End Sub 'SurveyUpdate

'==========================================================

Sub FormValidate

FormComplete = "True"

Message = "Please answer all questions on this form"

AvailOfferCount = 0

SQLRequiredTicketCount = "SELECT COUNT(OrderLine.ItemNumber) AS Count FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.ItemType = 'Seat'"' GROUP BY Seat.EventCode ORDER BY Seat.EventCode"
Set rsRequiredTicketCount = OBJdbConnection.Execute(SQLRequiredTicketCount)

    If Not rsRequiredTicketCount.EOF Then
    AvailOfferCount = rsRequiredTicketCount("Count")
    End If

rsRequiredTicketCount.Close
Set rsRequiredTicketCount = nothing  


For i = 1 To AvailOfferCount
		
	SQLEvent = "SELECT Event.EventCode, Event.EventDate, Act.Act, Venue.Venue FROM OrderLine WITH (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event WITH (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act WITH (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue WITH (ROWLOCK) ON Event.VenueCode = Venue.VenueCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.LineNumber = " & i & " GROUP BY Event.EventCode, Event.EventDate, Act.Act, Venue.Venue ORDER BY Event.EventDate, Act.Act, Venue.Venue"
	Set rsEvent = OBJdbConnection.Execute(SQLEvent)

			'Question Count
			For j = 1 to UBound(Question)  

			SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & i & " AND FieldName = 'Answer" & j & "'"
			Set rsOrderLineDetail = OBJdbConnection.Execute(SQLOrderLineDetail)  
						
			If rsOrderLineDetail("FieldValue") = "" Then
			FormComplete = "False"
			End If
			
			rsOrderLineDetail.Close
			Set rsOrderLineDetail = nothing

			Next

	rsEvent.Close
	Set rsEvent = nothing

Next


If FormComplete Then
    Call Continue
Else
    Call DisplaySurvey(Message)   
End If



End Sub
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
%>
