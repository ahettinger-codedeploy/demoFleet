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


<!doctype html>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<html>

<head>
	
	<title>White Label - a full featured Admin Skin</title>
	
<style type="text/css">	
	

/*----------------------------------------------------------------------*/
/* Font Declaration
/*----------------------------------------------------------------------*/

html, textarea, input, input[type=submit], button, a.btn, span, div.alert p, header{ 
	font-family:'PT Sans', sans-serif;
}
code, pre{
	font-family:"Courier New", Courier, monospace;
}
	

/*----------------------------------------------------------------------*/
/* General Section
/*----------------------------------------------------------------------*/

#niceform html, body, textarea, input { 
	font-size:12px;
	-webkit-text-size-adjust:none;
}
#niceform html{
	background-attachment:fixed;
	overflow-y:scroll;
}
#niceform a{ text-decoration:none; cursor:pointer;}
#niceform a:hover { text-decoration:underline; }
#niceform a, a:hover, a:visited, a:link {color:#000;}

::-moz-selection{ text-shadow:none; }
::selection { text-shadow:none; }

#niceform header, footer, nav, section{
	display:block;
}

#niceform h1, h2, h3, h4, h5, h6{
	font-weight:100;
}
#niceform h1 {
	font-size:28px;
	line-height:32px;
	margin-top:22px;
}
#niceform h2 {
	font-size:24px;
	line-height:26px;
}
#niceform h3 {
	font-size:20px;
	line-height:24px;
}
h4 {
	font-size:18px;
	line-height:22px;
}
h5 {
	font-size:16px;
	line-height:22px;
}
h6 {
	font-size:14px;
	line-height:20px;
}
h1 span{
	font-size:14px;
	line-height:14px;
}
h2 span{
	font-size:12px;
	line-height:12px;
}
h3 span{
	font-size:10px;
	line-height:10px;
}

p, ul, ol, pre{
	margin-bottom:18px;
	line-height:18px;
	font-size:12px;
}

blockquote{
	font-size:16px;
	font-family:Georgia, "Times New Roman", Times, serif;
	font-style:italic;
	border-left:5px solid;
	padding:0 18px;
	margin:36px;
}
li{
	margin-left:18px;
}

hr { 
	display:block;
	height:0px;
	line-height:0px;
	border:0;
	border-top:1px solid;
	border-bottom:1px solid;
	margin:16px 0;
	float:none;
	clear:both;
	padding:0;
}
strong{
	font-weight:700;
}
em{
	font-style:italic;
}
img{
	border:0;
}

.small{
	font-size:10px;
}
/*----------------------------------------------------------------------*/
/* Pageoptions
/*----------------------------------------------------------------------*/
#pageoptions{
	position:relative;
	overflow:hidden;
	width:auto;
	padding:0;
	min-height:20px;
}
#pageoptions h1, #pageoptions h2,#pageoptions h3, #pageoptions h4, #pageoptions h5, #pageoptions h6{
}
#pageoptions ul{
	overflow:hidden;
	margin:0;
	padding:1px 6px;
}
#pageoptions ul li{
	float:right;
	list-style:none;
	padding:0;
	margin:0;
	margin-left:1px;
}
#pageoptions ul li a{
	text-decoration:none;
	padding:0 8px 6px;
	-webkit-border-top-left-radius:4px; -moz-border-radius-topleft:4px; border-top-left-radius:4px;
	-webkit-border-top-right-radius:4px; -moz-border-radius-topright:4px; border-top-right-radius:4px;
}
#pageoptions ul li a:hover, #pageoptions ul li a.active{
}
#pageoptions > div{
	position:absolute;
	left:15px;
	right:15px;
	padding:15px;
	overflow:hidden;
	min-height:400px;
	-webkit-border-top-left-radius:4px; -moz-border-radius-topleft:4px; border-top-left-radius:4px;
	-webkit-border-top-right-radius:4px; -moz-border-radius-topright:4px; border-top-right-radius:4px;
}

#pageoptions div li{
	float:none;
}
/*----------------------------------------------------------------------*/
/* Tables
/*----------------------------------------------------------------------*/

table{
	width:100%;
	border-collapse:collapse;
	margin-bottom:18px;
}
table td, table th{
	border:1px solid;
	padding:6px 3px;
	text-align:center;
}
table th{
	font-weight:700;
}
div.chart .legend table{
	border:0;
	width:auto;
}
div.chart{
	max-width:100%;
	margin-bottom:18px;
}
div.chart .legend table td{
	vertical-align:middle;
	text-align:center;
}
div.chart .legend table td.legendColorBox{
	opacity:0.6;
	filter:Alpha(opacity=60);
}

table.documentation{
}

table.documentation th, table.documentation td{
	text-align:left;
}



/*----------------------------------------------------------------------*/
/* Header
/*----------------------------------------------------------------------*/


header{
	position:relative;
	border-top:1px solid;
	z-index:10;
	-webkit-border-top-left-radius:4px; -moz-border-radius-topleft:4px; border-top-left-radius:4px;
	-webkit-border-top-right-radius:4px; -moz-border-radius-topright:4px; border-top-right-radius:4px;
}
#logo{
	height:24px;
	padding:18px 0 18px 15px;
	width:224px;
	border:0;
	-webkit-border-top-left-radius:4px; -moz-border-radius-topleft:4px; border-top-left-radius:4px;
	background:url(images/logo.png) left center no-repeat;
	
}
#logo, #logo a{
	font-weight:700;
	font-size:20px;
	text-decoration:none;
	text-indent:-99999px;
}
#logo a{
}
#header{
	height:60px;
	position:absolute;
	top:0;
	left:240px;
	right:0;
	border:0;
	-webkit-border-top-right-radius:4px; -moz-border-radius-topright:4px; border-top-right-radius:4px;
}
#header ul{
	width:75%;
	height:46px;
	float:left;
	margin:0;
}
#header ul li{
	list-style:none;
	margin:0;
}
#header ul li ul{
	width:100%;
	height:auto;
	float:none;
	padding:18px 0;
	margin:0;
}
#header ul li ul li{
	border:1px solid;
	position:relative;
	float:left;
	margin:0 10px 0 0;
	display:block;
	-webkit-border-radius:4px; -moz-border-radius:4px; border-radius:4px;
}
#header ul li ul li a{
	padding:2px 20px 4px 20px;
	font-size:14px;
	display:block;
	border-top:1px solid;
	-webkit-border-radius:4px; -moz-border-radius:4px; border-radius:4px;
}
#header ul li ul li a:hover{
	text-decoration:none;
}
#header ul li ul li a:active, #header ul li ul li a.active{
	border:0;
	padding:4px 20px 3px 20px;
}
#header ul li ul li:active, #header ul li ul li.active{
}
#header ul li ul li ul{
	display:none;
	padding:0;
	-webkit-border-bottom-left-radius:4px; -moz-border-radius-bottomleft:4px; border-bottom-left-radius:4px;
	-webkit-border-bottom-right-radius:4px; -moz-border-radius-bottomright:4px; border-bottom-right-radius:4px;
}
#header ul li ul li ul.shown{
	display:block;
}
#header ul li ul li ul li{
	margin:0;
	max-width:180px;
	border-left:0;
	border-right:0;
	border:0;
	border-top:1px solid;
	float:none;
	-webkit-border-radius:0; -moz-border-radius:0; border-radius:0;
}
#header ul li ul li ul li a{
	-webkit-border-radius:0; -moz-border-radius:0; border-radius:0;
}
#header ul li ul li ul li:last-child, #header ul li ul li ul li:last-child a{
	-webkit-border-bottom-left-radius:4px; -moz-border-radius-bottomleft:4px; border-bottom-left-radius:4px;
	-webkit-border-bottom-right-radius:4px; -moz-border-radius-bottomright:4px; border-bottom-right-radius:4px;
}

#header ul li ul li span{
	font-family:sans-serif;
	display:block;
	position:absolute;
	right:-12px;
	top:-12px;
	font-size:10px;
	line-height:10px;
	font-weight:700;
	padding:4px 4px 5px;
	text-align:center;
	min-width:10px;
	z-index:100;
	border:1px solid;
	cursor:pointer;
	-webkit-border-radius:36px;
	-moz-border-radius:36px;
	border-radius:36px;
}
#searchbox{
	float:right;
	margin:17px 10px 17px 0;
	padding:0;
	border:1px solid;
	-webkit-border-radius:4px; -moz-border-radius:4px; border-radius:4px;
}
form#searchform{
	width:90px;
	padding:0;
	border:0;
	-webkit-border-radius:4px; -moz-border-radius:4px; border-radius:4px;
}
form#searchform input#search{
	-webkit-appearance:none !important;
	padding:3px 0;
	font-size:14px;
	width:100%;
	text-align:center;
	border:0;
	border-top:1px solid;
	margin:0;
	font-style:normal;
}
form#searchform input::-webkit-search-decoration,
form#searchform input::-webkit-search-cancel-button,
form#searchform input::-webkit-search-results-button,
form#searchform input::-webkit-search-results-decoration {
  display:none;
}

form#searchform input#search:focus{
	border:0;
	padding:4px 0 3px;
}

/*----------------------------------------------------------------------*/
/* Navigation
/*----------------------------------------------------------------------*/

nav{
	border-right:0px solid;
	border-left:1px solid;
	-webkit-border-bottom-right-radius:4px; -moz-border-radius-bottomright:4px; border-bottom-right-radius:4px;
}

nav ul{
	border-top:1px solid;
	margin:0;
	-webkit-border-bottom-left-radius:4px; -moz-border-radius-bottomleft:4px; border-bottom-left-radius:4px;
	-webkit-border-bottom-right-radius:4px; -moz-border-radius-bottomright:4px; border-bottom-right-radius:4px;
}
nav ul li{
	list-style:none;
	padding:0;
	margin:0;
	background-repeat:no-repeat;
	background-position:-9999px;
}
nav ul li a{
	display:block;
	padding-right:0;
}
nav ul li a span{
	padding:12px 40px 11px;
	font-size:14px;
	display:block;
	border:1px solid;
	border-left:0;
	border-right:0;
	background-repeat:no-repeat;
	background-position:12px 10px;
	white-space:nowrap;
}
nav ul li a:hover{
	text-decoration:none;
	cursor:pointer;
	padding-right:0px;
}
nav ul li a:active, nav ul li a.active{
	padding-right:0px;
	padding-bottom:0px;
	background-repeat:repeat-x;
	background-position:left center;
	filter:none;
}
nav ul li a:active span, nav ul li a.active span{
	border-bottom:0;
	padding:12px 40px 12px;
}

nav ul li ul{
	border:0;
	margin-right:10px;
	margin-left:10px;
	display:none;
	margin-bottom:10px;
}
nav ul li ul li:first-child a{
}
nav ul li ul li:last-child, nav ul li ul li:last-child a, nav ul li ul li:last-child a span{
	-webkit-border-bottom-left-radius:4px; -moz-border-radius-bottomleft:4px; border-bottom-left-radius:4px;
	-webkit-border-bottom-right-radius:4px; -moz-border-radius-bottomright:4px; border-bottom-right-radius:4px;
}
nav ul li ul li{
	-webkit-border-radius:0; -moz-border-radius:0; border-radius:0;
}
nav ul li ul li a{
	padding-right:0;
	-webkit-border-radius:0; -moz-border-radius:0; border-radius:0;
}
nav ul li ul li a span{
	border:0;
	font-size:12px;
	line-height:12px;
	border-top:1px solid #ddd;
	padding-top:6px;
	padding-bottom:6px;
	padding-left:15px;
	background-position:-9999px;
	-webkit-border-radius:0; -moz-border-radius:0; border-radius:0;
}
nav ul li ul li:first-child a span{
}
nav ul li ul li a:active, nav ul li ul li a.active{
}
nav ul li ul li a:active span, nav ul li ul li a.active span{
	background-position:-9999px;
	padding-top:6px;
	padding-bottom:6px;
	padding-left:15px;
}
/*----------------------------------------------------------------------*/
/* Content
/*----------------------------------------------------------------------*/


#content{
	border:0;
	padding:15px 5px 15px 230px;
	margin:0;
	min-height:600px;
	border:1px solid;
	overflow:visible;
	-webkit-border-bottom-left-radius:4px; -moz-border-radius-bottomleft:4px; border-bottom-left-radius:4px;
	-webkit-border-bottom-right-radius:4px; -moz-border-radius-bottomright:4px; border-bottom-right-radius:4px;
}



.bgsample{
	border:1px solid;
	float:left;
	margin:8px;
	padding:27px 30px;
}

/*----------------------------------------------------------------------*/
/* Gallery
/*----------------------------------------------------------------------*/

.gallery{
	border:1px solid;
	padding:3px;
	overflow:auto;
	-webkit-border-radius:4px; -moz-border-radius:4px; border-radius:4px;
}
.widget .gallery{
	padding:0;
	border:0;
}

.gallery .sortable_placeholder{
	margin:4px;
}

.gallery li{
	margin:4px;
	position:relative;
	list-style:none;
	float:left;
	padding:8px;
	border:1px solid;
	overflow:hidden;
	-webkit-border-radius:4px; -moz-border-radius:4px; border-radius:4px;
}
.gallery li > a{
	display:block;
	margin:0;
	padding:0;
	height:116px;
	width:116px;
	background-position:center center;
	background-repeat:no-repeat;
	-webkit-border-radius:4px; -moz-border-radius:4px; border-radius:4px;
}
.gallery li img{
	position:relative;
}
.gallery li span{
	position:absolute;
	top:140px;
	left:0;
	display:block;
	height:132px;
	width:132px;
	padding-top:4px;
	border-top:1px solid;
}
.gallery li > a span a{
	/* position:relative; */
	display:block;
	padding-left:24px;
	margin:2px 16px;
	background-position:center left;
	background-repeat:no-repeat;
	height:20px;
}
.gallery li a span a.edit{
}
.gallery li a span a.delete{
}

/*----------------------------------------------------------------------*/
/* Breadcrumb
/*----------------------------------------------------------------------*/


.breadcrumb{
	margin-bottom:20px;
	display:block;
	overflow:hidden;
	-webkit-border-radius:4px; -moz-border-radius:4px; border-radius:4px;
}
.breadcrumb.disabled{
	opacity:0.8;
	filter:Alpha(opacity=80);
}
.breadcrumb li{
	float:left;
	margin:0;
	list-style:none;
	max-width:280px;
}
.breadcrumb li:first-child{
	margin-left:0px;
}
.breadcrumb li a{
	padding:10px 35px 5px 30px;
	font-size:14px;
	display:block;
	font-weight:700;
	margin-left:-20px;
	border:1px solid;
	border-left:0;
	background-repeat:no-repeat;
	background-position:0px 0px;
	height:25px;
	text-decoration:none;
	-webkit-border-radius:4px; -moz-border-radius:4px; border-radius:4px;
}
.breadcrumb li a span{
	padding:4px 9px;
	height:20px;
	background-repeat:no-repeat;
	background-position:-2px -2px;
	display:block;
	text-indent:-9999px;
}
.breadcrumb li a.previous span{
	opacity:0.6;
	filter:Alpha(opacity=60);
}
.breadcrumb li a.previous:hover span{
	opacity:1;
	filter:none;
}
.breadcrumb li:first-child a{
	border-left:1px solid;
	background-position:-20px 0px;
	margin-left:0px;
	padding-left:20px;
}
.breadcrumb li:last-child a{
	padding-right:20px;
}
.breadcrumb li a.previous{
	background-position:0px -129px;
}
.breadcrumb.disabled li a.previous:hover{
	background-position:0px -129px;
}
.breadcrumb li:first-child a.previous{
	background-position:-20px -129px;
}
.breadcrumb.disabled li:first-child a.previous:hover{
	background-position:-20px -129px;
}
.breadcrumb li a:hover{
	background-position:0px -43px;
}
.breadcrumb.disabled li a:hover{
	background-position:0px 0px;
}
.breadcrumb li:first-child a:hover{
	background-position:-20px -43px;
}
.breadcrumb.disabled li:first-child a:hover{
	background-position:-20px 0px;
}
.breadcrumb li a:active, .breadcrumb li a.active, .breadcrumb.disabled li a.active:hover{
	background-position:0px -86px;
}
.breadcrumb li:first-child a:active, .breadcrumb li:first-child a.active, .breadcrumb.disabled li:first-child a.active:hover{
	background-position:-20px -86px;
}
/*----------------------------------------------------------------------*/
/* Message Box
/*----------------------------------------------------------------------*/

#wl_msg{
	position:absolute;
	top:90px;
	right:25px;
	z-index:15;
	width:300px;
}
#wl_msg .msg-box:first-child{
	-webkit-border-top-left-radius:4px; -moz-border-radius-topleft:4px; border-top-left-radius:4px;
	-webkit-border-top-right-radius:4px; -moz-border-radius-topright:4px; border-top-right-radius:4px;
}
#wl_msg .msg-box:last-child{
	-webkit-border-bottom-left-radius:4px; -moz-border-radius-bottomleft:4px; border-bottom-left-radius:4px;
	-webkit-border-bottom-right-radius:4px; -moz-border-radius-bottomright:4px; border-bottom-right-radius:4px;
}

#wl_msg .msg-box, #wl_msg .msg-box-close{
	border:1px solid;
	margin-bottom:4px;
	display:none;
}
#wl_msg .msg-box-close{
	text-align:center;
	cursor:pointer;
	-webkit-border-bottom-left-radius:4px; -moz-border-radius-bottomleft:4px; border-bottom-left-radius:4px;
	-webkit-border-bottom-right-radius:4px; -moz-border-radius-bottomright:4px; border-bottom-right-radius:4px;
}
#wl_msg .msg-box-close:hover{
}
#wl_msg .msg-box h3, #wl_msg .msg-close{
	height:28px;
}
#wl_msg .msg-box h3{
	border-bottom:1px solid;
	font-size:14px;
	width:264px;
	line-height:30px;
	padding-left:8px;
	margin:0;
	float:left;
}
#wl_msg .msg-close{
	border-left:1px solid;
	border-bottom:1px solid;
	display:block;
	float:right;
	width:25px;
	line-height:1px;
	padding:0;
	text-indent:-9999px;
	background-position:50% 50%;
	background-repeat:no-repeat;
}
#wl_msg .msg-close:hover{
}
#wl_msg .msg-content{
	clear:both;
	padding:10px;
}


/*----------------------------------------------------------------------*/
/* Alert Boxes
/*----------------------------------------------------------------------*/

div.alert{
	border:1px solid;
	margin-bottom:15px;
	cursor:pointer;
	background-repeat:no-repeat;
	background-position:7px 8px;
	padding:10px 10px 10px 35px;
	font-size:14px;
	font-weight:700;
	margin:0;
	-webkit-border-radius:4px; -moz-border-radius:4px; border-radius:4px;
}
div.alert code{
	background:none;
	border:0;
}
form div.alert{
	margin:15px 4px;
}
div.alert:hover{
	border:1px solid;
}
div.alert a{
	font-size:14px;
	font-weight:700;
}

/*----------------------------------------------------------------------*/
/* Buttons
/*----------------------------------------------------------------------*/


button, a.btn,
.dataTables_paginate span.paginate_button,
.dataTables_paginate span.paginate_active{
	border:1px solid;
	position:relative;
	padding:9px 12px;
	display:inline-block;
	cursor:pointer;
	background-repeat:no-repeat;
	background-position:4px 5px;
	-webkit-border-radius:4px;
	-moz-border-radius:4px;
	border-radius:4px;
	text-decoration:none;
	font-size:11px;
	font-weight:700;
	outline:0 none;
	text-align:center;
	text-transform:uppercase;
	margin:2px;
	min-height:22px;
	min-width:8px;
	white-space:pre-line;
	vertical-align:baseline;
}
button.small, a.btn.small{
	min-height:14px;
	line-height:14px;
	font-size:10px;
	padding:4px 7px;
}
button.big, a.btn.big{
	font-size:14px;
	padding:12px 16px;
}
button.icon, a.btn.icon{
	padding-left:27px;
}
button.small.icon, a.btn.small.icon{
	padding-left:23px;
	background-position:0 -2px;
}
button.big.icon, a.btn.big.icon{
	padding-left:27px;
	background-position:-0 8px;
}
a.btn.nt, button.nt{
	background-position:50% 50%;
	text-indent:-9999px;
}
a.btn.small.nt, button.small.nt{
	padding-left:12px;
	padding-right:12px;
}
button{
}
a.btn{
	line-height:18px;
	min-height:18px;
}
button:hover, a.btn:hover{
}
button:active, a.btn:active,
.dataTables_paginate span.paginate_active{
	top:1px;
}


/*----------------------------------------------------------------------*/
/* Form Elements
/*----------------------------------------------------------------------*/

fieldset{
	padding:15px;
}
pre{
	white-space:pre-wrap;
	white-space:-moz-pre-wrap;
	white-space:-pre-wrap;
	white-space:-o-pre-wrap;
	word-wrap:break-word; 
	padding:12px 15px;
	line-height:18px;
}
pre, code{
	font-size:11px;
	padding:1px 2px;
	border:1px solid;
	-webkit-border-radius:4px; -moz-border-radius:4px; border-radius:4px;
}
pre code{
	display:block;
	border:0;
}

input,textarea{
	width:99%;
	border:1px solid;
	padding:4px 2px;
	margin:0 1px;
	-webkit-border-radius:4px; -moz-border-radius:4px; border-radius:4px;
}
input.placeholder,textarea.placeholder{
	font-style:italic;
}
input:focus,textarea:focus{
	outline:none;
}
select optgroup, select option{
	font-style:normal;
	border:0;
}
select option{
	border:1px solid;
	padding:3px;
}
input[type=submit], input[type=checkbox], input[type=radio], input[type=button], button{
	width:auto !important;
}

input[type=submit]{
	min-height:33px;
}

form{
	border:1px solid;
	padding:4px;
	margin-bottom:18px;
	-webkit-border-radius:4px; -moz-border-radius:4px; border-radius:4px;
}
form:last-child{
	margin-bottom:0;
}
.widget form{
	border:0;
}
form .wl_formstatus{
	padding-left:18px;
}
form fieldset{
	padding:0;
	margin:4px;
	border:1px solid;
	border-bottom:0;
	margin-top:18px;
	-webkit-border-radius:4px; -moz-border-radius:4px; border-radius:4px;
}
form fieldset:first-child{
	margin-top:4px;
}
form label{
	border-top:1px solid;
	display:block;
	font-size:16px;
	margin:0;
	padding:15px 10px;
	font-weight:700;
	-webkit-border-top-left-radius:4px; -moz-border-radius-topleft:4px; border-top-left-radius:4px;
	-webkit-border-top-right-radius:4px; -moz-border-radius-topright:4px; border-top-right-radius:4px;
}
form label span{
	font-size:12px;
}
form span.required{
	padding:0 4px;
	font-size:10px;
	background-repeat:no-repeat;
	background-position:left bottom;
}
form input, form textarea{
	padding:6px 2px;
	font-size:13px;
}
form fieldset > section{
	width:100%;
	border-top:1px solid;
	border-bottom:1px solid;
	float:left;
	padding:0;
	margin:0;
}
form fieldset > section:first-child{
	-webkit-border-top-left-radius:4px; -moz-border-radius-topleft:4px; border-top-left-radius:4px;
	-webkit-border-top-right-radius:4px; -moz-border-radius-topright:4px; border-top-right-radius:4px;
}
form fieldset > section:last-child{
	-webkit-border-bottom-left-radius:4px; -moz-border-radius-bottomleft:4px; border-bottom-left-radius:4px;
	-webkit-border-bottom-right-radius:4px; -moz-border-radius-bottomright:4px; border-bottom-right-radius:4px;
}

form fieldset > section > div{
	padding:15px 1%;
	width:78%;
	float:right;
	border-left:1px solid;
	height:100%;
	min-height:100%;
}

form fieldset > section > div > div{
	float:none;
	clear:both;
	width:auto;
}
form fieldset > section > div div.date{
	max-width:230px;
}
form fieldset > section.error > label{
	text-shadow:none;
	font-weight:700;
}
form fieldset > section > div span{
	font-size:11px;
}
form fieldset > section.error{
	border-bottom:1px solid;
}
form fieldset > section.error > label{
	text-shadow:none;
	font-weight:700;
}
form fieldset > section label{
	border:0;
	cursor:pointer;
	font-size:13px;
	font-weight:100;
	float:left;
	background:none;
	filter:none;
	margin:0;
	width:16%;
	padding-left:2px;
	margin-left:8px;
	text-align:left;
}
form fieldset > section > div > div.selector{
}
form fieldset > section > div > div.selector span{
	height:32px;
}
form fieldset > section > div > div.selector select{
	height:32px;
	cursor:pointer;
}
form fieldset > section > div > div.checker, form fieldset > section > div > div.radio{
	display:inline-block;
	margin:0;
	line-height:1;
	float:none;
}
form fieldset > section > div > div.checker span, form fieldset > section > div > div.radio span{
	display:inline-block;
	height:22px;
	width:22px;
	float:none;
}
form fieldset > section > div > div.checker span input, form fieldset > section > div > div.radio span input{
	display:inline;
	width:22px;
	height:22px;
	min-width:22px;
	min-height:22px;
	margin:0;
	padding:0;
	cursor:pointer;
}
form fieldset > section > div label{
	position:relative;
	width:auto;
	margin:0;
	padding:0;
	display:inline-block;
	float:none;
	top:-5px;
	font-size:11px;
	line-height:1.5;
	-webkit-border-radius:0; -moz-border-radius:0; border-radius:0;
}
form fieldset > section label span{
	font-size:10px;
}
form div input{
}
textarea{
	min-height:70px;
	resize:none;
	overflow:auto;
}
input.date{
	width:80px;
}
input[type=password], input.password{
	width:150px;
}
div.passwordstrength{
	font-size:12px;
	padding:5px 3px;
	text-align:center;
	width:150px;
	margin:3px 1px;
	-webkit-border-radius:4px; -moz-border-radius:4px; border-radius:4px;
}
div.passwordstrength.s_1{}
div.passwordstrength.s_2{}
div.passwordstrength.s_3{}
div.passwordstrength.s_4{}
div.passwordstrength.s_5{}

input.time{
	width:35px;
	text-align:center;
}
span.timeformat{
	font-size:11px;
	padding-left:1px;
}
input.integer, input.decimal{
	width:60px;
	text-align:right;
}
input.color{
	width:60px;
}


/*----------------------------------------------------------------------*/
/* jQuery Checkbox
/*----------------------------------------------------------------------*/

.jquery-checkbox, .jquery-checkbox span  { display: inline; font-size: 16px; line-height: 16px; cursor: pointer;}

.jquery-checkbox span.checkboxplaceholder { 
	vertical-align:baseline;
	padding:2px 12px 0px;
	line-height:8px;
	background-repeat:no-repeat;
}
.jquery-checkbox span.checkboxplaceholder { 
	background-image:url(dark/images/checkbox.png);
}
.jquery-checkbox.checkbox span.checkboxplaceholder{
	background-position: 0px 0px;
}
.jquery-checkbox.checkbox .hover span.checkboxplaceholder{
	background-position: 0px -26px;
}
.jquery-checkbox.checkbox .hover.pressed span.checkboxplaceholder{
	background-position: 0px -51px;
}
.jquery-checkbox.checkbox.checked span.checkboxplaceholder{
	background-position: 0px -77px;
}
.jquery-checkbox.checkbox.checked .hover span.checkboxplaceholder {
	background-position: 0px -102px;
}
.jquery-checkbox.checkbox.checked .hover.pressed span.checkboxplaceholder {
	background-position: 0px -128px;
}

.jquery-checkbox.checkbox .disabled span.checkboxplaceholder{
	background-position: 0px -153px !important;
	cursor:auto;
}
.jquery-checkbox.checkbox.checked .disabled span.checkboxplaceholder{
	background-position: 0px -179px !important;
	cursor:auto;
}


.jquery-checkbox.radio span.checkboxplaceholder{
	background-position: -26px 0px;
}
.jquery-checkbox.radio .hover span.checkboxplaceholder{
	background-position: -26px -26px;
}
.jquery-checkbox.radio .hover.pressed span.checkboxplaceholder{
	background-position: -26px -51px;
}
.jquery-checkbox.radio.checked span.checkboxplaceholder{
	background-position: -26px -77px;
}
.jquery-checkbox.radio.checked .hover span.checkboxplaceholder {
	background-position: -26px -102px;
}
.jquery-checkbox.radio.checked .hover.pressed span.checkboxplaceholder {
	background-position: -26px -128px;
}

.jquery-checkbox.radio .disabled span.checkboxplaceholder{
	background-position: -26px -153px !important;
	cursor:auto;
}
.jquery-checkbox.radio.checked .disabled span.checkboxplaceholder{
	background-position: -26px -179px !important;
	cursor:auto;
}

/*----------------------------------------------------------------------*/
/* File Upload
/*----------------------------------------------------------------------*/

div.fileuploadui{
	padding:0 5px;
	margin-bottom:5px;
}
div.fileuploadui a{
	margin-right:10px;
	font-size:11px;
	display:inline !important;
}
ul.fileuploadpool{
	display:block;
	clear:both;
	margin-bottom:5px;
	border:1px solid;
	z-index:1;
	-webkit-border-radius:4px; -moz-border-radius:4px; border-radius:4px;
	min-height:68px;
	min-width:138px;
	overflow:hidden;
	padding:4px;
}
ul.fileuploadpool.drop{
}
ul.fileuploadpool.single{
	width:138px;
}
ul.fileuploadpool li{
	font-size:11px;
	list-style-type:none;
	float:left;
	border:1px solid;
	margin:4px;
	padding:4px;
	height:50px;
	width:120px;
	-webkit-border-radius:4px; -moz-border-radius:4px; border-radius:4px;
	-webkit-animation-name: showfile;-moz-animation-name: showfile;animation-name: showfile;
	-webkit-animation-duration: 0.2s;-moz-animation-duration: 0.2s;animation-duration: 0.2s;
	-webkit-animation-direction: alternate;-moz-animation-direction: alternate;animation-direction: alternate;
	-webkit-animation-timing-function: ease-out;-moz-animation-timing-function: ease-out;animation-timing-function: ease-out;
}
@-webkit-keyframes showfile {
 from {	-webkit-transform: scale(0);}
 to {-webkit-transform: scale(1.0); }
}
@-moz-keyframes showfile {
 from {	-webkit-transform: scale(0);}
 to {-webkit-transform: scale(1.0); }
}
@keyframes showfile {
 from {	-webkit-transform: scale(0);}
 to {-webkit-transform: scale(1.0); }
}

ul.fileuploadpool li.error{
	text-shadow:none;
}
ul.fileuploadpool li .name{
	display:block;
	height:20px;
	overflow:hidden;
	white-space:nowrap;
	line-height:22px;
}
ul.fileuploadpool li a{
	display:block;
	height:24px;
	width:24px;
	text-indent:-9999px;
	float:right;
}
ul.fileuploadpool li a:hover{
	text-decoration:none;
}
ul.fileuploadpool li a.cancel{
}
ul.fileuploadpool li a.remove{
}
ul.fileuploadpool li .progress{
	display:block;
	line-height:1px;
	height:3px;
	width:0%;
	-webkit-border-radius:4px; -moz-border-radius:4px; border-radius:4px;
}
ul.fileuploadpool li.success .progress{
}

/*----------------------------------------------------------------------*/
/* Comboselect
/*----------------------------------------------------------------------*/

div.comboselectbox{
	display:block;
	clear:both;
	min-height:100px;
}
div.comboselectbox div.combowrap{
	-webkit-border-radius:4px; -moz-border-radius:4px; border-radius:4px;
	float:left;
	border:1px solid;
	-webkit-border-radius:4px; -moz-border-radius:4px; border-radius:4px;
	max-width:42%;
	width:200px;
	height:99%;
	padding:1% 1% 0 0;
}
div.comboselectbox ul.comboselect{
	overflow:auto;
	height:99%;
}
div.comboselectbox ul.comboselect li{
	display:block;
	margin:0;
	list-style-type:none;
	float:left;
	border:1px solid;
	margin:1px 6% 1px 2%;
	width:92%;
	-webkit-border-radius:4px; -moz-border-radius:4px; border-radius:4px;
}
div.comboselectbox ul.comboselect li a{
	font-size:11px;
	padding:3px;
	float:left;
	width:75%;
	cursor:pointer;
	text-decoration:none;
	cursor:pointer;
}
div.comboselectbox ul.comboselect.ui-sortable li.selected a{
	cursor:n-resize;
}
div.comboselectbox ul.comboselect li a.add, div.comboselectbox ul.comboselect li a.remove{
	float:right;
	display:block;
	width:18px;
	height:18px;
	text-indent:-9999px;
	background-position:center center;
	background-repeat:no-repeat;
	cursor:pointer;
}
div.comboselectbox ul.comboselect li.used a{
	text-decoration:line-through;
}
div.comboselectbox ul.comboselect li.selected{
}
div.comboselectbox div.comboselectbuttons{
	max-width:9%;
	height:99%;
	width:30px;
	float:left;
	padding:0 3px;
}
div.comboselectbox div.comboselectbuttons a{
	padding:3px;
	line-height:20px;
	font-size:20px;
	width:18px;
	height:18px;
	margin:0 2px;
	background-position:center center;
	background-repeat:no-repeat;
	display:inline-block;
}
div.comboselectbox div.comboselectbuttons a.add{
}
div.comboselectbox div.comboselectbuttons a.remove{
}
div.comboselectbox div.comboselectbuttons a.addall{
}
div.comboselectbox div.comboselectbuttons a.removeall{
}

@media screen and (max-width:700px){
	div.comboselectbox div.combowrap{
		max-width:98%;
		width:98%;
		height:40%;
		float:none;
	}
	div.comboselectbox div.comboselectbuttons{
		text-align:center;
		max-width:98%;
		width:98%;
		float:none;
		height:30px;
	}
}
/*----------------------------------------------------------------------*/
/* Widgets
/*----------------------------------------------------------------------*/

.widget{
	margin-bottom:15px;
	border:1px solid;
	-webkit-border-radius:4px; -moz-border-radius:4px; border-radius:4px;
}
.widget > div{
	margin:2px;
	padding:15px 6px 2px;
	border:1px solid;
	-webkit-border-radius:4px; -moz-border-radius:4px; border-radius:4px;
}
.widget > div > img{
	-webkit-border-radius:4px; -moz-border-radius:4px; border-radius:4px;
}
.widget > div.ui-widget{
	width:99%;
	padding:0;
}
.widget .ui-widget-header{
	overflow:hidden;
}
.widget h3{
	margin:0;
}
.widget:hover{
	border:1px solid;
}
.widget.ui-sortable-helper{
}
.widget h3.handle{
	position:relative;
	font-size:14px !important;
	border-top:1px solid;
	border-bottom:1px solid;
	padding:8px 10px;
	margin:0;
	line-height:18px;
	margin-bottom:1px;
	cursor:pointer;
	-webkit-border-top-left-radius:4px; -moz-border-radius-topleft:4px; border-top-left-radius:4px;
	-webkit-border-top-right-radius:4px; -moz-border-radius-topright:4px; border-top-right-radius:4px;
}
.widget.sortable h3.handle{
	cursor:move;
}
.widget h3.handle:hover{
}
.widget h3.handle.red{
}
.widget h3.handle.green{
}
.widget h3.handle.blue{
}
.widget h3.handle.yellow{
}
.widget h3.handle .collapse, .widget h3.handle .reload{
	position:absolute;
	right:8px;
	top:5px;
	display:block;
	height:24px;
	width:24px;
	background-repeat:no-repeat;
	background-position:center center;
	display:none;
}
.widget h3.handle .reload{
	right:30px;
}
.widget h3.handle a:first-child{
	right:8px;
}
.widget:hover h3.handle .collapse, .widget.loading h3.handle .reload, .widget:hover h3.handle .reload{
	display:block;
}
.widget h3.handle .collapse{
}
.widget h3.handle .icon{
	margin-top:-3px;
	margin-left:-4px;
	height:24px;
	width:24px;
	display:inline-block;
	float:left;
	background-position:center;
}
.widget.collapsed{
	border-bottom:1px solid;
}
.widget.collapsed h3.handle{
	border-bottom:0;
	-webkit-border-bottom-right-radius:4px; -moz-border-radius-bottomright:4px; border-bottom-right-radius:4px;
}
.widget.collapsed h3.handle .collapse{
}

.widget.number-widget > div ul{
	overflow:auto;
}
.widget.number-widget > div ul li{
	display:block;
	margin:0;
	list-style:none;
	border-top:1px dotted;
	padding:14px 10px 4px;
	margin:0;
}
.widget.number-widget > div ul li:first-child{
	border-top:0;
}
.widget.number-widget > div ul li a{
	font-size:12px;
	display:block;
}
.widget.number-widget > div ul li a:hover{
	text-decoration:none;
}
.widget.number-widget ul li a span{
	text-align:right;
	display:inline-block;
	width:80px;
	font-size:32px;
	font-weight:700;
	letter-spacing:-0.05em;
	padding:2px 6px 2px 0;
}

.sortable_placeholder{
	margin-bottom:15px;
	border:1px solid;
	z-index:1;
	-webkit-border-radius:4px; -moz-border-radius:4px; border-radius:4px;
}


/*----------------------------------------------------------------------*/
/* Footer
/*----------------------------------------------------------------------*/

footer{
	
}
/*----------------------------------------------------------------------*/
/* width
/*----------------------------------------------------------------------*/

.w_5{  width:5%  !important; }
.w_10{ width:10% !important; }
.w_15{ width:15% !important; }
.w_20{ width:20% !important; }
.w_25{ width:25% !important; }
.w_30{ width:30% !important; }
.w_33{ width:33% !important; }
.w_35{ width:35% !important; }
.w_40{ width:40% !important; }
.w_45{ width:45% !important; }
.w_50{ width:50% !important; }
.w_55{ width:55% !important; }
.w_60{ width:60% !important; }
.w_65{ width:65% !important; }
.w_66{ width:66% !important; }
.w_70{ width:70% !important; }
.w_75{ width:75% !important; }
.w_80{ width:80% !important; }
.w_85{ width:85% !important; }
.w_90{ width:90% !important; }
.w_95{ width:95% !important; }

.w_5p{  width:5px  !important; }
.w_10p{ width:10px !important; }
.w_15p{ width:15px !important; }
.w_20p{ width:20px !important; }
.w_25p{ width:25px !important; }
.w_30p{ width:30px !important; }
.w_35p{ width:35px !important; }
.w_40p{ width:40px !important; }
.w_45p{ width:45px !important; }
.w_50p{ width:50px !important; }
.w_55p{ width:55px !important; }
.w_60p{ width:60px !important; }
.w_65p{ width:65px !important; }
.w_70p{ width:70px !important; }
.w_75p{ width:75px !important; }
.w_80p{ width:80px !important; }
.w_85p{ width:85px !important; }
.w_90p{ width:90px !important; }
.w_95p{ width:95px !important; }
.w_100p{ width:100px !important; }

.w_105p{ width:105px !important; }
.w_110p{ width:110px !important; }
.w_115p{ width:115px !important; }
.w_120p{ width:120px !important; }
.w_125p{ width:125px !important; }
.w_130p{ width:130px !important; }
.w_135p{ width:135px !important; }
.w_140p{ width:140px !important; }
.w_145p{ width:145px !important; }
.w_150p{ width:150px !important; }
.w_155p{ width:155px !important; }
.w_160p{ width:160px !important; }
.w_165p{ width:165px !important; }
.w_170p{ width:170px !important; }
.w_175p{ width:175px !important; }
.w_180p{ width:180px !important; }
.w_185p{ width:185px !important; }
.w_190p{ width:190px !important; }
.w_195p{ width:195px !important; }
.w_200p{ width:200px !important; }

.fl{ float:left !important; }
.fr{ float:right !important; }

.l{ text-align:left; }
.c{ text-align:center; }
.j{ text-align:justify; }
.r{ text-align:right; }

/*----------------------------------------------------------------------*/
/* Clear Floats
/*----------------------------------------------------------------------*/
/* http://sonspring.com/journal/clearing-floats */
.clear {
	clear:both;
	display:block;
	overflow:hidden;
	visibility:hidden;
	width:0;
	height:0;
}
/* http://perishablepress.com/press/2008/02/05/lessons-learned-concerning-the-clearfix-css-hack */
.clearfix:after {
	clear:both;
	content:' ';
	display:block;
	font-size:0;
	line-height:0;
	visibility:hidden;
	width:0;
	height:0;
}
.clearfix {
	display:inline-block;
}
* html .clearfix {
	height:1%;
}
.clearfix {
	display:block;
}
/*----------------------------------------------------------------------*/
/* Grid System (based on the 960 Grid System (http://960.gs)
/*----------------------------------------------------------------------*/

.g1,.g2,.g3,.g4,.g5,.g6,.g7,.g8,.g9,.g10,.g11,.g12 {
	display:inline;
	float:left;
	margin-left:1%;
	margin-right:1%;
	padding:9px 0;
	min-height:10px;
}
.alpha{margin-left:0;}
.omega{margin-right:0;}

.g1{width:6.333%;}
.g2{width:14.667%;}
.g3{width:23.0%;}
.g4{width:31.333%;}
.g5{width:39.667%;}
.g6{width:48.0%;}
.g7{width:56.333%;}
.g8{width:64.667%;}
.g9{width:73.0%;}
.g10{width:81.333%;}
.g11{width:89.667%;}
.g12{width:98.0%;}

.p1{padding-left:8.333%;}
.p2{padding-left:16.667%;}
.p3{padding-left:25.0%;}
.p4{padding-left:33.333%;}
.p5{padding-left:41.667%;}
.p6{padding-left:50.0%;}
.p7{padding-left:58.333%;}
.p8{padding-left:66.667%;}
.p9{padding-left:75.0%;}
.p10{padding-left:83.333%;}
.p11{padding-left:91.667%;}

.s1{padding-right:8.333%;}
.s2{padding-right:16.667%;}
.s3{padding-right:25.0%;}
.s4{padding-right:33.333%;}
.s5{padding-right:41.667%;}
.s6{padding-right:50.0%;}
.s7{padding-right:58.333%;}
.s8{padding-right:66.667%;}
.s9{padding-right:75.0%;}
.s10{padding-right:83.333%;}
.s11{padding-right:91.667%;}

.ps1{left:8.333%;}
.ps2{left:16.667%;}
.ps3{left:25.0%;}
.ps4{left:33.333%;}
.ps5{left:41.667%;}
.ps6{left:50.0%;}
.ps7{left:58.333%;}
.ps8{left:66.667%;}
.ps9{left:75.0%;}
.ps10{left:83.333%;}
.ps11{left:91.667%;}

.pl1{left:-8.333%;}
.pl2{left:-16.667%;}
.pl3{left:-25.0%;}
.pl4{left:-33.333%;}
.pl5{left:-41.667%;}
.pl6{left:-50.0%;}
.pl7{left:-58.333%;}
.pl8{left:-66.667%;}
.pl9{left:-75.0%;}
.pl10{left:-83.333%;}
.pl11{left:-91.667%;}

/*----------------------------------------------------------------------*/
/* Layout
/*----------------------------------------------------------------------*/

body{
	margin:0 15px;
}

header{
	height:60px;
	z-index:2;
}
nav{
	position:absolute;
	width:216px;
	z-index:2;
}
#content{
	overflow:hidden;
	left:0px;
	right:0px;
	top:0px;
	z-index:1;
}
footer{
	padding:5px;
	text-align:right;
}

/*----------------------------------------------------------------------*/
/* Login
/*----------------------------------------------------------------------*/

body#login{
	position:static;
	left:auto;
	right:auto;
	width:350px;
	margin:120px auto;
	padding:2%;
}
body#login #content{
	min-height:50px;
	padding:8px;
}
body#login form label{
	padding:0;
	margin:0;
	width:100%;
}
body#login form section{
	width:100%;
}
body#login form section div{
	width:90%;
	float:none;
	padding:0 4% 6px 4%;
	border:0;
}
body#login form section > div{
	width:90% !important;
}
body#login form section div input{
	width:100% !important;
}
body#login form section div input#remember{
	width:auto !important;
}
body#login form section div.checker{
	width:auto !important;
	padding:0;
	margin:0;
}
body#login form section label{
	padding:3% 2% 1%;
	width:90% !important;
	float:none;
}
body#login form section label.checkbox div{
	width:10px;
	padding:0;
	margin:0;
}
body#login form section div label{
	width:80% !important;
}
body#login form section a{
	float:right;
}

/*----------------------------------------------------------------------*/
/* Wizard
/*----------------------------------------------------------------------*/

body#wizard{
	position:static;
	left:auto;
	right:auto;
	width:500px;
	margin:120px auto;
	padding:0;
}
body#wizard #content{
	min-height:50px;
	padding:8px;
}


/*----------------------------------------------------------------------*/
/* Error Page
/*----------------------------------------------------------------------*/

body#error{
	position:static;
	left:auto;
	right:auto;
	width:400px;
	margin:120px auto;
	padding:0;
}
body#error #content{
	min-height:50px;
	padding:8px;
}
body#error #content h1{
	font-size:116px;
	font-weight:700;
	line-height:0.7em;
	letter-spacing:-9px;
}
body#error #content h2{
	float:right;
}


/*----------------------------------------------------------------------*/
/* Media Queries
/*----------------------------------------------------------------------*/

/* For very large screens increes the margins*/
@media screen and (min-width:1281px) {
	body{
		margin-left:10%;
		margin-right:10%;
	}
}

/* Move the Headernav to a drop down menu to the right */
@media screen and (max-width:960px) {
	#header ul#headernav li ul, #header ul#headernav li ul.collapsed{
		display:none;
	}
	#header ul#headernav li ul.shown{
		display:block !important;
	}
	#header ul#headernav{
		border-left:1px solid;
		position:relative;
		float:right;
		height:60px;
		width:60px;
		cursor:pointer;
		background-repeat:no-repeat;
		background-position:center center;
	}
	
	#header ul#headernav li ul{
		position:absolute;
		right:0;
		width:170px;
		padding:0;
		margin:0;
		top:60px;
	}
	#header ul#headernav li ul li{
		float:none;
		margin:0;
		border-bottom:0;
		border-top:0;
		
	}
	#header ul#headernav li ul li a{
		padding:10px;	
	}
	#header ul#headernav li ul li:last-child{
		border-bottom:1px solid;
		
	}
	#header ul#headernav li ul span{
		right:5px;
		top:10px;
	}
	#header ul#headernav li ul li ul{
		position:relative;
		top:0;
		padding:0;
		display:none;
		padding-bottom:6%;
		z-index:20;
		width:99%;
	}
	#header ul#headernav li ul li ul.shown{
		display:block;
	}
	#header ul#headernav li ul li ul li{
		margin:0 6%;
	}
	#header ul#headernav li ul li ul li a{
		font-size:12px;
		padding:5px;
	}
	
	.g1,.g2,.g3,.g4,.g5,.g6 {
		padding:0;
		width:48.0%;
	}
	.g7,.g8,.g9,.g10,.g11,.g12 {
		padding:0;
		width:98%;
	}
	#header ul li ul li,#header ul li ul li a, #header ul#headernav li ul li ul{
		-webkit-border-radius:0; -moz-border-radius:0; border-radius:0;
	}
	
	#header ul li ul li:last-child,#header ul li ul li:last-child a{
		-webkit-border-bottom-left-radius:4px; -moz-border-radius-bottomleft:4px; border-bottom-left-radius:4px;
	}
}
@media screen and (max-width:900px) and (min-width:701px) {
	form fieldset > section > div{
		width:69%;
	}
	form fieldset > section label{
		width:24%;
	}
}

/* For more smaller Screens (iPad) */
@media screen and (max-width:700px) {
	header #search,header #searchbox{
		max-width:100px;
	}
	form label{
		padding:10px 1%;
	}
	form fieldset > section{
		padding-bottom:8px;
	}
	form fieldset > section > label{
		left:0;
		right:0;
		width:98%;
		margin:0;
		float:none;
		padding:1%;
		padding-bottom:8px;
	}
	form fieldset > section > div{
		float:none;
		width:98%;
		padding:4px;
		border:0;
	}
	.g1,.g2,.g3,.g4,.g5,.g6,.g7,.g8,.g9,.g10,.g11,.g12 {
		width:98%;
	}
	
}
@media screen and (max-width:800px) and (min-width:481px) {
	nav{
		width:150px;
	}
	nav ul li a span{
		font-size:12px;
	}
	nav ul li ul{
		margin-left:10px;
		margin-right:10px;
	}
	nav ul li ul li a span{
		padding-right:4px;
	}
	#content{
		padding:15px 0 15px 160px;
	}
	
}


/*----------------------------------------------------------------------*/
/* jQuery UI mods
/*----------------------------------------------------------------------*/

.ui-tabs .ui-tabs-nav li{
	margin:0 2px 0 0 !important;
}
.ui-tabs .ui-tabs-nav, .ui-tabs{
	padding:0 !important;
}
.ui-widget{
	padding:0 !important;
}
.ui-widget-header{
	border:0 !important;
	border-top:1px solid !important;
	border-bottom:1px solid !important;
	background-repeat:repeat !important;
	margin:0 !important;
}
.ui-widget-header a, .ui-accordion-header a, .ui-datepicker-title .ui-datepicker-month, .ui-datepicker-title .ui-datepicker-year{
	font-size:14px !important;
}
.ui-state-default a{
	border-top:1px solid !important;
	-webkit-border-radius:4px !important;
	-moz-border-radius:4px !important;
	border-radius:4px !important;
}
.ui-tabs .ui-tabs-panel {
	padding:0 !important;
}
.ui-tabs .ui-tabs-panel p {
	margin:1em 1.3em !important;
}
.ui-tabs .ui-tabs-selected{
	border-bottom:0;
}
.ui-accordion-content p{
	margin:0 !important;
}
.ui-accordion .ui-accordion-header{
	margin-top:0 !important;
}
.ui-datepicker .ui-widget-header{
	padding:4px !important;
}
.ui-widget-overlay{
	background-repeat:repeat !important;
}
.ui-slider-range.ui-widget-header{
	background-position:center !important;
	border:0 !important;
}
.ui-slider-horizontal .ui-slider-handle{
	top:-5px !important;
	min-height:22px;
	min-width:18px;
	margin-left:-10px !important;
	cursor:pointer !important;
}
.ui-slider-vertical{
	float:left;
}
.ui-slider-vertical .ui-slider-handle{
	left:-5px !important;
	min-height:18px;
	min-width:22px;
	margin-bottom:-10px !important;
	cursor:pointer !important;
}
.ui-slider{
	min-height:14px;
	min-width:14px;
	border:1px solid;
	background-repeat:repeat !important;
	margin:10px;
}
.ui-slider .ui-slider-handle{
	background-repeat:no-repeat !important;
	z-index:1 !important;
	position:relative;
}
.ui-slider-horizontal .ui-slider-handle{
	background-position:right center !important;
}
.ui-slider-vertical .ui-slider-handle{
	background-position:left center !important;
}
.ui-slider-range{
	-webkit-border-radius:4px !important;
	-moz-border-radius:4px !important;
	border-radius:4px !important;
}
</style>

	
	
	
	<!-- Google Font and style definitions -->
	<link rel="stylesheet" href="http://fonts.googleapis.com/css?family=PT+Sans:regular,bold">
	
	<link rel="stylesheet" href="css/style.css">
	
	<!-- include the skins (change to dark if you like) -->
	<link rel="stylesheet" href="css/light/theme.css" id="themestyle">
	<!-- <link rel="stylesheet" href="css/dark/theme.css" id="themestyle"> -->
	
	<!--[if lt IE 9]>
	<script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
	<link rel="stylesheet" href="css/ie.css">
	<![endif]-->
	
	<!-- Use Google CDN for jQuery and jQuery UI -->
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.12/jquery-ui.min.js"></script>
	
	<!-- Loading JS Files this way is not recommended! Merge them but keep their order -->
	
	<!-- some basic functions -->
	<script src="js/functions.js"></script>
		
	<!-- all Third Party Plugins and Whitelabel Plugins -->
	<script src="js/plugins.js"></script>
	<script src="js/editor.js"></script>
	<script src="js/calendar.js"></script>
	<script src="js/flot.js"></script>
	<script src="js/elfinder.js"></script>
	<script src="js/datatables.js"></script>
	<script src="js/wl_Alert.js"></script>
	<script src="js/wl_Autocomplete.js"></script>
	<script src="js/wl_Breadcrumb.js"></script>
	<script src="js/wl_Calendar.js"></script>
	<script src="js/wl_Chart.js"></script>
	<script src="js/wl_Color.js"></script>
	<script src="js/wl_Date.js"></script>
	<script src="js/wl_Editor.js"></script>
	<script src="js/wl_File.js"></script>
	<script src="js/wl_Dialog.js"></script>
	<script src="js/wl_Fileexplorer.js"></script>
	<script src="js/wl_Form.js"></script>
	<script src="js/wl_Gallery.js"></script>
	<script src="js/wl_Multiselect.js"></script>
	<script src="js/wl_Number.js"></script>
	<script src="js/wl_Password.js"></script>
	<script src="js/wl_Slider.js"></script>
	<script src="js/wl_Store.js"></script>
	<script src="js/wl_Time.js"></script>
	<script src="js/wl_Valid.js"></script>
	<script src="js/wl_Widget.js"></script>
	
	<!-- configuration to overwrite settings -->
	<script src="js/config.js"></script>
		
	<!-- the script which handles all the access to plugins etc... -->
	<script src="js/script.js"></script>
	
	
</head>

<body>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

            <section id="fancyform">	
				<form id="form" action="submit.php" method="post" autocomplete="off">
					<fieldset>
						<label>Text Fields</label>
						<section><label for="text_field">Text Field</label>
							<div><input type="text" id="text_field" name="text_field"></div>
						</section>
						<section><label for="text_tooltip">Field with Tooltip</label>
							<div><input type="text" id="text_tooltip" name="text_tooltip" title="A Tooltip">
							<span>Just specify a title attribut to get a Tooltip</span>
							</div>
						</section>
						<section><label for="text_tooltip">Placeholder Text</label>
							<div><input type="text" id="text_placeholder" name="text_placeholder" placeholder="your placeholder text">
							<span>use the placeholder attribute <code>placeholder="your placeholder text"</code></span>
							</div>
						</section>
						<section><label for="textarea">Textarea</label>
							<div><textarea id="textarea" name="textarea" rows="10"></textarea></div>
						</section>
						<section><label for="textarea_auto">Autogrow Textarea<br><span>Some extra information</span></label>
							<div><textarea id="textarea_auto" name="textarea_auto" data-autogrow="true"></textarea>
								<span>will expand after you hit the bottom edge</span>
							</div>
						</section>
						<section><label for="textarea_auto">WYSIWYG Editor<br><span>(W)hat (y)ou (s)ee (i)s (w)hat (y)ou (g)et</span></label>
							<div><textarea id="textarea_wysiwyg" name="textarea_wysiwyg" class="html" rows="12"></textarea>
							</div>
						</section>
					</fieldset>
					<div class="alert info">Some Fields are MouseWheel enabled!</div>
					<fieldset>
					<label>Numbers</label>
						<section><label for="integer">Integer</label>
							<div><input id="integer" name="integer" type="number" class="integer">
							<br><span>This must be an integer</span>
							</div>
						</section>
						<section><label for="decimal">Decimal</label>
							<div><input id="decimal" name="decimal" type="number" class="decimal">
							<br><span>This must be a decimal number</span>
							</div>
						</section>
						<section><label for="integer_minmax">Define min and max values</label>
							<div><input id="integer_minmax" name="integer_minmax" type="number" class="integer" min="20" max="40"><input id="decimal_minmax" name="decimal_minmax" type="number" class="decimal" min="-20" max="20">
							<br><span>Define ranges with <code>data-min="20" data-max="40"</code> and <code>data-min="-20" data-max="20"</code></span>
							</div>
						</section>
						<section><label for="integer_minmax">Define steps<br><span>only for mousewheel</span></label>
							<div><input id="integer_steps" name="integer_steps" type="number" class="integer" data-step="50" title="Use your MouseWheel!"><input id="decimal_steps" name="decimal_steps" type="number" class="decimal" step="0.04" data-decimals="4">
							<br><span>Define steps with <code>data-step="50"</code> and <code>data-step="0.04" data-decimals="4"</code></span>
							</div>
						</section>
						<section><label for="integer_start_from">Define a start<br><span>only for mousewheel</span></label>
							<div><input id="integer_start_from" name="integer_start_from" type="number" class="integer" data-start="1900" min="1900"> - <input id="integer_start_to" name="integer_start_to" type="number" class="integer" data-start="2000" max="2011">
							<br><span>Simulate Year Fields with <code>data-start="1900" data-min="1900"</code> and <code>data-start="2000" data-max="2011"</code></span>
							</div>
						</section>
					</fieldset>
					<fieldset>
					<label>Validation <span>with regular expressions</span></label>
						<section><label for="regex_letter">Only Letters</label>
							<div><input id="regex_letter" name="regex_letter" type="text" data-regex="^[a-zA-Z ]+$"><span>Regular Expression: <code>data-regex="^[a-zA-Z ]+$"</code></span></div>
						</section>
						<section><label for="regex_number">Only Numbers</label>
							<div><input id="regex_number" name="regex_number" type="text" data-regex="^[0-9 ]+$"><span>Regular Expression: <code>data-regex="^[0-9 ]+$"</code></span></div>
						</section>
						<section><label for="email">Email</label>
							<div><input id="email" name="email" type="email"></div>
						</section>
						<section><label for="url">Url</label>
							<div><input id="url" name="url" type="url" placeholder="http://">
							<br><span>Instant is off for URLs. Use <code>data-instant="true"</code> for instant validation</span>
							</div>
						</section>
					</fieldset>
					<fieldset>
					<label>File Upload <span>not all files are allowed in the livepreview</span></label>
						<section><label for="file_upload">Single File Upload<br><span>your uploaded data will get delete within 1 hour</span></label>
							<div><input type="file" id="file_upload" name="file_upload"></div>
						</section>
						<section><label for="file_upload_multiple">Multi File Upload</label>
							<div><input type="file" id="file_upload_multiple" name="file_upload_multiple" multiple>
							</div>
						</section>
						<section><label for="file_upload_manual">Manual start<br><span>only jpgs and gifs are allowed with less than 100 kb</span></label>
							<div><input type="file" id="file_upload_manual" name="file_upload_manual" data-auto-upload="false" multiple data-allowed-extensions="[jpg,jpeg,gif]" data-max-file-size="100000">
							<span>drag &amp; drop is currenlty only supported on Firefox 3.6+ Safari 5+ and Chrome 6+</span>
							</div>
						</section>
					</fieldset>
					<fieldset>
					<label>Other Fields</label>
						<section><label for="password">Password<br><span>with confirmation</span></label>
							<div><input type="password" id="password" name="password"></div>
						</section>
						<section><label for="color">Color</label>
							<div><input type="text" id="color" name="color" class="color"><br>
							<span>use mousewheel for brightness, mousewheel+shift for saturation and mousewheel+shift+alt for hue (not supported in all browsers)</span>
							</div>
						</section>
					</fieldset>
					<fieldset>
					<label>Autocomplete</label>
						<section><label for="autocomplete">Simple Autocomplete</label>
							<div><input id="autocomplete" name="autocomplete" type="text" class="autocomplete">
							<br><span>the source is defined within the call <code>$(selector).wl_Autocomplete({source:[...,...]});</code></span>
							</div>
						</section>
						<section><label for="autocomplete_inline">Autocomplete with inline data</label>
							<div><input id="autocomplete_inline" name="autocomplete_inline" type="text" class="autocomplete" data-source="[abc,def,ghi,jkl,mno,pqr,stu,vwx,yz]">
							<br><span>inline data with <code>data-source="[abc,def,ghi,jkl,mno,pqr,stu,vwx,yz]"</code></span>
							</div>
						</section>
						<section><label for="autocomplete_function">Autocomplete with user function</label>
							<div><input id="autocomplete_function" name="autocomplete_function" type="text" class="autocomplete" data-source="myAutocompleteFunction">
							<br><span>source is a user function with <code>data-source="myAutocompleteFunction"</code>. Function must return an array</span>
							</div>
						</section>
					</fieldset>
					<fieldset>
					<label>Date &amp; Time</label>
						<section><label for="date">Simple Date Field</label>
							<div><input id="date" name="date" type="text" class="date">
							<br><span>You can define displayed format within the settings. yyyy-mm-dd will always be used on submit</span>
							</div>
						</section>
						<section><label for="datetime">Date Field with Time<br><span>mousewheel enabled!</span></label>
							<div><input id="datetime" name="datetime" type="text" class="date"><input type="text" class="time" data-connect="datetime">
							<br><span>These fields get converted to a single date value on submit (yyyy-mm-dd hh:mm)</span>
							</div>
						</section>
						<section><label for="predefined_time">Predefined Time</label>
							<div><input id="predefined_time" name="predefined_time" type="text" class="date" data-value="+7"><input type="text" class="time" data-connect="predefined_time" data-value="now">
							<br><span>This fields always display the date in one week with <code>data-value="+7"</code> for the date field and <code>data-value="now"</code> for the time field</span>
							</div>
						</section>
						<section><label for="time_only_12">Time only</label>
							<div><input type="text" class="time" id="time_only_12" data-timeformat="12"><input type="text" class="time" id="time_only_24" title="Hold down the shift key to scroll hours!">
							<br><span>Use 12h timeformat with <code>data-timeformat="12"</code>. Both fields are always in 24h format on submit</span>
							</div>
						</section>
						<section><label>Inline Date Field<br><span>mousewheel enabled! Use shift key to scroll trough month</span></label>
							<div><div class="date" id="inline_date" data-value="tomorrow"></div>
							<br><span>yyyy-mm-dd on submit. Can't be undefined</span>
							</div>
						</section>
					</fieldset>
					<fieldset>
					<label>Sliders <span>working on iPhone and iPad!</span></label>
						<section><label>Slider</label>
							<div><div class="slider" id="slider"></div></div>
						</section>
						<section><label>vertical Sliders</label>
							<div>
								<div>
									<div class="slider" data-connect="slider_v_1" data-orientation="vertical" data-range="min"></div>
									<div class="slider" data-connect="slider_v_2" data-orientation="vertical" data-range="min"></div>
									<div class="slider" data-connect="slider_v_3" data-orientation="vertical" data-range="min"></div>
									<div class="slider" data-connect="slider_v_4" data-orientation="vertical" data-range="min"></div>
									<div class="slider" data-connect="slider_v_5" data-orientation="vertical" data-range="min"></div>
								</div>
								<div>
									<input type="number" class="integer w_25p" id="slider_v_1">
									<input type="number" class="integer w_25p" id="slider_v_2">
									<input type="number" class="integer w_25p" id="slider_v_3">
									<input type="number" class="integer w_25p" id="slider_v_4">
									<input type="number" class="integer w_25p" id="slider_v_5">
								</div>
							</div>
						</section>
						<section><label>Slider with tooltip</label>
							<div><div class="slider" id="slider_tooltip" data-tooltip="true" data-range="min"></div></div>
						</section>
						<section><label>Slider with custom tooltip Pattern</label>
							<div><div class="slider" id="slider_tooltip_pattern" data-tooltip="true" data-orientation="vertical" data-tooltip-pattern="current value is $ %n,-" data-range="min"></div><br><span>use <code>data-tooltip-pattern="current value is $ %n,-"</code></span></div>
						</section>
						<section><label>Slider with connected input field</label>
							<div><div class="slider" data-connect="slider_connect" data-value="30" data-range="min"></div>
							<input type="number" class="integer" id="slider_connect"><span>set the start value within the input or with <code>data-value="30"</code> within the slider</span>
							</div>
						</section>
						<section><label>Range Slider</label>
							<div><div id="slider_range" class="slider" data-range="true" data-max="1000" data-values="[350,650]"></div>
							</div>
						</section>
						<section><label>Connected Range Slider</label>
							<div><div class="slider" data-range="true" data-max="1000" data-values="[250,750]" data-connect="[slider_range_from,slider_range_to]"></div>
							<input type="number" class="integer" id="slider_range_from">
							<input type="number" class="integer" id="slider_range_to">
							<br><span>Use the shift key for faster scrolling</span>
							</div>
						</section>
						<section><label>Custom Callback</label>
							<div><div class="slider" id="slider_callback"></div>
								<div id="slider_callback_bar" style="background:#aaa;padding:2px;">Scroll!</div>
							</div>
						</section>
					</fieldset>
					<fieldset>
						<label>Other Basic Fields</label>
						<section>
							<label>Checkboxes</label>
							<div>
								<input type="checkbox" id="apples_check" ><label for="apples_check">Apples</label>
								<input type="checkbox" id="bananas_check" ><label for="bananas_check">Bananas</label>
								<input type="checkbox" id="oranges_check" ><label for="oranges_check">Oranges</label>
							</div>
						</section>
						<section>
							<label>Radio Buttons</label>
							<div>
								<input type="radio" id="apples_radio" name="radio" value="Apples" ><label for="apples_radio">Apples</label>
								<input type="radio" id="bananas_radio" name="radio" value="Bananas" ><label for="bananas_radio">Bananas</label>
								<input type="radio" id="oranges_radio" name="radio" ><label for="oranges_radio">Oranges</label>
							</div>
						</section>
						<section>
							<label for="dropdown_vegetables">Dropdown</label>
							<div>					
								<select name="dropdown_vegetables" id="dropdown_vegetables">
									<optgroup label="Vegetables">
										<option value="Broccoli">Broccoli</option>
										<option value="Corn">Corn</option>
										<option value="Spinach">Spinach</option>
									</optgroup>
								</select>
								<select name="dropdown_fruits" id="dropdown_fruits">
									<optgroup label="Fruits">
										<option value="Apples">Apples</option>
										<option value="Bananas">Bananas</option>
										<option value="Oranges">Oranges</option>
									</optgroup>
								</select>
							</div>
						</section>
						<section>
							<label for="multiselect">Multiple Select<br><span>use ctrl + shift key. The selection(right) is sortable with drag n' drop</span></label>
							<div>					
								<select name="multiselect" id="multiselect" multiple>
										<option value="artichoke">Artichoke</option>
										<option value="beans">Beans</option>
										<option value="broccoli">Broccoli</option>
										<option value="carrot">Carrot</option>
										<option value="corn">Corn</option>
										<option value="chicory">Chicory</option>
										<option value="kohlrabi">Kohlrabi</option>
										<option value="melon">Melon</option>
										<option value="onion">Onion</option>
										<option value="potato">Potato</option>
										<option value="pumpkin">Pumpkin</option>
										<option value="spinach">Spinach</option>
										<option value="tomato">Tomato</option>
								</select>
							</div>
						</section>
					</fieldset>
					<fieldset>
						<label>Required Fields</label>
						<section><label for="required_field">Required Text Field</label>
							<div><input type="text" id="required_field" name="required_field" required></div>
						</section>
						<section><label for="required_field_msg">Required Text Field with custom error message</label>
							<div><input type="text" id="required_field_msg" name="required_field_msg" required data-errortext="This is an custom error text!">
							<br><span>use <code>data-errortext="This is an custom error text!"</code> for custom message</span>
							</div>
						</section>
						<section><label for="required_valid_field">Required Field with validation</label>
							<div>
							<span>Please type in 'OK':</span><br>
							<input type="text" id="required_valid_field" name="required_valid_field" required data-regex="^OK$" class="w_10">
							</div>
						</section>
						<section>
							<div>
								<input type="checkbox" id="agreed" data-errortext="This is mandatory!" required><label for="agreed">I agree that this form is awesome ;)</label>
							</div>
						</section>
						<section>
							<div><button class="reset">Reset</button><button class="submit" name="submitbuttonname" value="submitbuttonvalue">Submit</button></div>
						</section>
					</fieldset>
				</form>	
				</div>
		</section>		
		<!--#INCLUDE virtual="FooterInclude.asp"-->
</body>
</html>

<%

End Sub ' SurveyForm

%>