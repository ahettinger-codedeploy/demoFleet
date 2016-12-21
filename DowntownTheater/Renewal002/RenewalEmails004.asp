<% 

'CHANGE LOG
'JAI 04/29/14 - 2015 Renewal Emails
'SSR 06/18/14 - 2015 Renewal Reminder Emails
'SSR 07/17/14 - Updated for use with Road Company
'SSR 07/18/14 - Updated EmailReplayTo 

%>

<!--METADATA TYPE="typelib" UUID="CD000000-8B95-11D1-82DB-00C04FB1625D"  NAME="CDO for Windows 2000 Library" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp"-->
<!--#INCLUDE VIRTUAL="TicketPrintInclude.asp"-->
<!--#INCLUDE VIRTUAL="NoCacheInclude.asp"-->
<%


'JAI 6/24/9 - Specify organization ReplyTo e-mail address and the e-mail subject

'-----------------------------------

'REE 4/15/2 - Increased Session Timeout to 30 minutes to reduce Print validation timeout issues.
Session.Timeout = 60
Server.ScriptTimeout = 3600

Page = "ManagementMenu"

'Make sure the correct Session variables are in place.  If not clear the variables and go to the menu.
If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then 
	Session.Abandon
	Response.Redirect("Default.asp")
End If

If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then 
	Session.Abandon
	Response.Redirect("Default.asp")
End If

'-----------------------------------

'Organization Variables

ClientDirectory = "/Clients/RialtoCinemas/Renewal"

TemplateFileName = "SEB_2015_Winter_Email.asp"

LogoFileName = "RialtoCinemasLogo.jpg"

DIM RenewalURL
RenewalURL = "http://rialtocinemas.tix.com/renew.aspx?"

DIM RenewalCode

DIM RenewalOrder

DIM EasyRenewalURL

'-----------------------------------

organizationNumber = Session("OrganizationNumber")

organizationName = fnOrgName(organizationNumber)

TemplateLocation = "/template/"

ImageLocation = "/images/"

DIM TemplateFilePath
TemplateFilePath = Server.MapPath(ClientDirectory & TemplateLocation & TemplateFileName)

DIM LogoFilePath
LogoFilePath = "http://www.tix.com/" & ClientDirectory & ImageLocation & LogoFileName

DIM MsgFontFace
MsgFontFace = "arial,helvetica"

DIM SHOWCHILD 
SHOWCHILD = TRUE

DIM ADDFEE
ADDFEE = FALSE

'-----------------------------------

'Email Variables

DIM EMailReplyTo
EMailReplyTo = "tickets@rialtocinemas.com"

DIM EMailSubject
EMailSubject = "Kenneth Branagh Theatre Company The Winter's Tale Starring Judi Dench!"

DIM EmailButton
EmailButton = "<input type=""submit"" class=""btn btn-ghost btn-default toggle-submit"" value=""Send""/>" 

'-----------------------------------

'Testing Variables

DIM EmailArray
EmailArray = EmailArray & fnUserEmailList(1)
EmailArray = EmailArray & fnUserEmailList(organizationNumber)

'TestEMailAddress = "sergio.rodriguez@tix.com"
'TestEMailAddress = "sergio@tix.com"
'TestEMailAddress = "silvia.mahoney@tix.com"
TestEMailAddress = "kjb@rialtocinemas.com"
'TestEMailAddress = "michael@michaelorand.com"

TestEmailCount = 1

If TestEMailAddress <> "" Then
	EMailReplyTo = TestEMailAddress
	EMailSubject =  "[Test Email for your review] " & EMailSubject
	TestModeStatus = "Test Mode.  " & TestEmailCount & " test email will be sent to: " & TestEMailAddress & ""
	EmailButton = "<input type=""submit"" class=""btn btn-ghost btn-danger"" value=""Test""/>"
End If

'-----------------------------------

'Decide which subroutine to route to
Select Case Request("FormName")
	Case "PrintMenu"
		Call PrintLetters
	Case Else
		Call PrintMenu
End Select

'----------------------------------

Sub PrintMenu

%>


<!DOCTYPE html>

<html lang="en">

<head>

<title>TIX Support</title>

<meta http-equiv="X-UA-Compatible" content="IE=edge;chrome=1">

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link type="text/css" rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">

<link rel="stylesheet" type="text/css" href="https://fonts.googleapis.com/css?family=Roboto:400,100,300,500,700,900" >

<link rel="stylesheet" type="text/css" href="https://oss.maxcdn.com/icheck/1.0.2/skins/all.min.css" >

<link rel="stylesheet" type="text/css" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css" >

<style>

/* ===============
GLOBAL SETTINGS 
=============== */

/* font styles */ 

.TixManagementContent,
.panel,
.nav
{
font-family: 'Roboto', sans-serif !important;
}


/* tix management section style */ 

.TixManagementContent
{
text-align: left !important;
min-height: 600px !important;
background-color: #fbfbfb !important;
padding: 0px !important;
}


/* =====================
RESET/CLEAR LINKS 
===================== */

/* links: remove all outlines and underscores */ 

a,     		
a:active,	
a:focus, 
a:hover,

a.btn,     		
a.btn:active,	
a.btn:focus, 
a.btn:hover,

button.btn,     		
button.btn:active,	
button.btn:focus, 
button.btn:hover,

.dropdown-menu li a,
.dropdown-menu li a:active,
.dropdown-menu li a:focus,
.dropdown-menu li a:hover,

.nav-pills li a,
.nav-pills li a:active,
.nav-pills li a:focus,
.nav-pills li a:hover,

.nav-tabs li a,
.nav-tabs li a:active,
.nav-tabs li a:focus,
.nav-tabs li a:hover

ul.nav-tabs li a,
ul.nav-tabs li a.active,
ul.nav-tabs li a.focus { outline:0px !important; -webkit-appearance:none;  text-decoration:none; color: #666666;}  


/* form input: remove blue glow */ 
.form-control,
.form-control:focus 
{
box-shadow: none;
border-width: 1px;
transition: border-color 0.15s ease-in-out 0s;
}

</style>


<style>

/* ===============
PANEL STYLES 
=============== */

/* panel header: title,navbar,tabs,button */ 

div.panel div.panel-heading,
div.panel div.panel-heading div.panel-title,
div.panel div.panel-heading div.panel-title .nav-btn,
div.panel div.panel-heading div.panel-title .nav-tabs,
div.panel div.panel-heading div.panel-title .navbar,
div.panel div.panel-heading div.panel-title .navbar .navbar-header
{ padding: 0; margin: 0; border: 0; min-height: 50px !important; max-height: 50px !important;}

/* navbar-brand */ 
div.panel div.panel-heading div.panel-title .navbar .navbar-header .navbar-brand
{
min-width: 150px;
margin-right: 50px;
}

/* panel header */ 
div.panel div.panel-heading { border-bottom: 1px solid #dddddd; }


/* panel tabs */
div.panel div.panel-heading div.panel-title nav.navbar div.pull-left ul.nav.nav-tabs li a { min-height: 47px !important; max-height: 47px !important;  min-width: 100px; margin-top: 3px; margin-left: 3px; font-size: 14px; -webkit-transition: all 0.25s; -moz-transition: all 0.25s; transition: all 0.25s;}

/* panel tabs hover colors */

ul.nav.nav-tabs li.active a,
ul.nav.nav-tabs li.active a:hover
{
color: #000000;
}

ul.nav.nav-tabs li a
{
color: #999999;
}

ul.nav.nav-tabs li a:hover
{
color: #666666;
}


/* panel button */
div.panel div.panel-heading div.panel-title .nav-btn .btn { min-height: 44px !important; max-height: 44px !important; min-width: 100px; margin-top: 3px; margin-right: 3px; font-size: 14px; border:1px solid #dddddd; -webkit-transition: all 0.25s; -moz-transition: all 0.25s; transition: all 0.25s;}
div.panel div.panel-heading div.panel-title .nav-btn .btn:focus { background-color: #ffffff;}
div.panel div.panel-heading div.panel-title .nav-btn .btn:hover { background-color: #eeeeee;}


/* panel labels */
div.panel .icon-label { margin-left: 5px; }


/* panel body title*/
#panel-display .panel-title
{
margin-bottom: 20px;
margin-top: 10px;
font-size: 24px;
color: #000000;
}


/* slide down panel */ 
#panel-parent
{
position: relative;
min-height: 450px;
}

#panel-options-outer
{       
position: absolute;
z-index: 20;
overflow: hidden;
width: 100%;
padding: 0px .5px 20px .5px;
}

#panel-options-inner
{
background-color: white;
margin-top: -650px;
padding: 10px;
border-radius: 6px;
border-top-right-radius: 0px;
border-top-left-radius: 0px;
box-shadoww: 0 6px 12px rgba(0, 0, 0, 0.176);
border: 1px solid #dddddd;
border-top: 0;
-webkit-box-shadow: 0 10px 6px -6px #999;
-moz-box-shadow: 0 10px 6px -6px #999;
box-shadow: 0 10px 6px -6px #999;
}

/* edit panel vertical tabs */ 

.nav-pills > li.active > a, 
.nav-pills > li.active > a:hover, 
.nav-pills > li.active > a:focus 
{
background-color: rgb(194, 208, 222);
}

.nav-pills > li > a
{
background-color: rgb(248, 248, 248);
font-weight: 700;
}

</style>

<style>

/* =====================
TABLE STYLES
===================== */

/* table - header cell style  */ 

.table > thead > tr > th, 
.table > tbody > tr > th, 
.table > tfoot > tr > th
{
background-color: #333333;
color: rgb(204, 204, 204);
border-bottom: 1px solid #F3F3F3;
border-top: 1px solid #F3F3F3 !important;
border-left: 0px;
border-right: 0px;
line-height: 1.42857;
padding: 8px;
vertical-align: top;
font-size: 16px;
font-weight: 700;
}

/* table - data cell style  */ 

.table > thead > tr > td, 
.table > tbody > tr > td, 
.table > tfoot > tr > td 
{
border-top: 1px solid #ffffff;
border-left: 0px;
border-right: 0px;
line-height: 1.42857;
padding: 8px;
vertical-align: top;
background-color: #ffffff;
font-size: 14px;
font-weight: 400;
}


/* table footer - border */ 

.table > tfoot > tr > th
{
border-top: 2px solid #dddddd;
}

/* table columns - center first/last columns */ 

.table > thead > tr > th:first-child,
.table > thead > tr > th:last-child,

.table > tbody > tr > td:first-child,
.table > tbody > tr > td:last-child
{
text-align: center;
vertical-align: middle; 
padding: 8px;
}

/* table columns - change cursor over sortable columns */ 

.table > thead > tr > th.sorting,  
.table > thead > tr > th.sorting_desc,
.table > thead > tr > th.sorting_asc
{
cursor: pointer;
}

/* table - active row fade in */ 

.table.table-fade.dataTable.no-footer tbody tr:hover.odd td,
.table.table-fade.dataTable.no-footer tbody tr:hover.even td,

.table.table-fade.dataTable.no-footer tbody tr.active:hover.odd td,
.table.table-fade.dataTable.no-footer tbody tr.active:hover.even td,

.table tbody tr.active td, 
.table tbody tr.active th,

.table tbody tr.active:hover td,
.table tbody tr.active:hover th
{
color: #000000;
border-color: white;
background-color: rgba(27, 126, 90, 0.3) !important;
-webkit-transition: all 1s ease-in;
-moz-transition: all 1s ease-in;
-o-transition: all 1s ease-in;
-ms-transition: all 1s ease-in;
transition: all 1s ease-in;
}


/* table - active row  fade out */ 

.table.table-fade.dataTable.no-footer tbody tr.odd,
.table.table-fade.dataTable.no-footer tbody tr.even,
 
 .table.table-fade.dataTable.no-footer tbody tr:hover.odd td,
 .table.table-fade.dataTable.no-footer tbody tr:hover.even td,

.table tbody tr td, 
.table tbody tr th,

.table tbody tr:hover td,
.table tbody tr:hover th
{
border-color: #e0e0e0;
-webkit-transition: all 1s ease-out;
-moz-transition: all 1s ease-out;
-o-transition: all 1s ease-out;
-ms-transition: all 1s ease-out;
transition: all 1s ease-out;
}


</style>

<style>

/* =====================
TOGGLE SWITCH
===================== */

.switch { height: 34px;  width: 100px; position: relative; display: inline-block; vertical-align: top; width: 103px;  background-color: transparent; cursor: pointer; box-sizing: content-box; overflow: hidden; }
.switch-input { position: absolute; top: 0px; left: 0px; opacity: 0; }
.switch-handle {width: 29px; height: 28px; border: 2px solid #c2d0de;  border-radius: 4px; position: absolute; top: 3px; left: 3px;   border-radius: 1px; background: none repeat scroll 0% 0% #c2d0de; transition: left 0.45s ease-out 0s; }
.switch-label { border: 2px solid #c2d0de; border-radius: 4px; position: relative; display: block; height: inherit; font-size: 15px; text-transform: uppercase; background: none repeat scroll 0% 0% rgb(248, 248, 248); transition: all 0.15s ease-out 0s; }

.switch-label:before, 
.switch-label:after { position: absolute; top: 50%; margin-top: -0.5em; line-height: 1; transition: inherit; }
.switch-label:before { content: attr(data-off); right: 11px; color: #c2d0de; }
.switch-label:after { content: attr(data-on); left: 11px; color: white; opacity: 0; }

.switch-input:checked ~ .switch-label { background: none repeat scroll 0% 0% rgb(248, 249, 250); }
.switch-input:checked ~ .switch-handle { left: 70px; background-color: white;}
.switch-input:checked ~ .switch-label:before { opacity: 0; }
.switch-input:checked ~ .switch-label:after { opacity: 1; }

.switch-success > .switch-input:checked ~ .switch-label { background: none repeat scroll 0% 0% rgb(77, 189, 116); border-color: rgb(58, 157, 93); }
.switch-success > .switch-input:checked ~ .switch-handle {background: none repeat scroll 0% 0% #ffffff; border-color: #ffffff; }

input.btn.toggle-control.disabled, 
input.btn.toggle-control[disabled]
{
display: none;
visibility: hidden;
}

</style>

<style>

/* =====================
BUTTONS
===================== */

.btn.btn-ghost
{
background: transparent;
color: #F2F2F2;
border-width: 2px;
paddingg: 10px 15px;
font-weight: 700;
letter-spacing: 1px;
text-transform: uppercase;
width: 120px;

/* CSS Transition */
-webkit-transition: background .2s ease-in-out, border .2s ease-in-out;
-moz-transition: background .2s ease-in-out, border .2s ease-in-out;
-ms-transition: background .2s ease-in-out, border .2s ease-in-out;
-o-transition: background .2s ease-in-out, border .2s ease-in-out;
transition: background .2s ease-in-out, border .2s ease-in-out;
}

.btn-default.btn-ghost
{
color: #333333;
border-color: #333333;
}

.btn-default.btn-ghost:hover
{
color: #000000;
border-color: #000000;
}

.btn-primary.btn-ghost
{
color: #337ab7;
}

.btn-primary.btn-ghost:hover
{
color: #2e6da4;
}


.btn-info.btn-ghost
{
color: #5bc0de;
}

.btn-info.btn-ghost:hover
{
color: #46b8da;
}

.btn-success.btn-ghost
{
color: #5cb85c;
}

.btn-success.btn-ghost:hover
{
color: #4cae4c;
}


.btn-warning.btn-ghost
{
color: #ec971f
}

.btn-warning.btn-ghost:hover
{
color: #d58512;
}

.btn-danger.btn-ghost
{
color: #d9534f;
}

.btn-danger.btn-ghost:hover
{
color: #ac2925;
}

</style>	
<style>

.col-sm-9 .SumoSelect .SlectBox
{ 
width: 100%; 
padding: 5px 8px;
}

/*this is applied on that hidden select. DO NOT USE display:none; or visiblity:hidden; and Do not override any of these properties. */
.SelectClass { position: absolute; top: 0px; left: 0px; right: 0px; height: 100%; width: 100%; border: none; z-index: 1; -webkit-box-sizing: border-box; -moz-box-sizing: border-box; box-sizing: border-box; -ms-filter: "progid:DXImageTransform.Microsoft.Alpha(Opacity=0)"; filter: alpha(opacity=0); -moz-opacity: 0; -khtml-opacity: 0; opacity: 0; }

.SumoSelect > .optWrapper > .options > li label, .SumoSelect > .CaptionCont { user-select: none; -o-user-select: none; -moz-user-select: none; -khtml-user-select: none; -webkit-user-select: none; }

.SumoSelect { display: inline-block; position: relative;outline:none;}

.SumoSelect:focus > .CaptionCont,.SumoSelect:hover > .CaptionCont 
{
border-color: #000000;
box-shadow: none;
border-width: 1px;
transition: border-color 0.15s ease-in-out 0s;
}

.SumoSelect > .CaptionCont { position: relative; border: 1px solid #A4A4A4; min-height: 14px; background-color: #fff;border-radius:2px;margin:0px;}
.SumoSelect > .CaptionCont > span { display: block; padding-right: 30px; text-overflow: ellipsis; white-space: nowrap; overflow: hidden;cursor:default;}
/*placeholder style*/
.SumoSelect > .CaptionCont > span.placeholder { color: #ccc; font-style: italic; }

.SumoSelect > .CaptionCont > label { position: absolute; top: 0px; right: 0px; bottom: 0px; width: 30px;}
.SumoSelect > .CaptionCont > label > i { background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA0AAAANCAYAAABy6+R8AAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH3wMdBhAJ/fwnjwAAAGFJREFUKM9jYBh+gBFKuzEwMKQwMDB8xaOWlYGB4T4DA0MrsuapDAwM//HgNwwMDDbYTJuGQ8MHBgYGJ1xOYGNgYJiBpuEpAwODHSF/siDZ+ISBgcGClEDqZ2Bg8B6CkQsAPRga0cpRtDEAAAAASUVORK5CYII=');
background-position: center center; width: 16px; height: 16px; display: block; position: absolute; top: 0px; left: 0px; right: 0px; bottom: 0px; margin: auto;background-repeat: no-repeat;opacity: 0.8;}

.SumoSelect > .optWrapper { top: 30px; width: 100%; position: absolute; left: 0; opacity: 0; visibility: hidden; transition: opacity 200ms ease-out, top 200ms ease-out, visibility 200ms ease-out; -webkit-transition: opacity 200ms ease-out, top 200ms ease-out, visibility 200ms ease-out; -moz-transition: opacity 200ms ease-out, top 200ms ease-out, visibility 200ms ease-out; -ms-transition: opacity 200ms ease-out, top 200ms ease-out, visibility 200ms ease-out; -o-transition: opacity 200ms ease-out, top 200ms ease-out, visibility 200ms ease-out; -webkit-box-sizing: border-box; -moz-box-sizing: border-box; box-sizing: border-box; z-index: -100; background: #fff; border: 1px solid #ddd; box-shadow: 2px 3px 3px rgba(0, 0, 0, 0.11); border-radius: 3px;overflow: hidden;}
.SumoSelect > .optWrapper.open { top: 35px; visibility: visible; opacity: 1; z-index: 1000; }

.SumoSelect > .optWrapper > .options { list-style: none; display: block; padding: 0px; margin: 0px; overflow: auto; border-radius: 2px; /*Set the height of pop up here (only for desktop mode)*/max-height: 250px;/*height*/ }
.SumoSelect > .optWrapper.isFloating > .options {max-height: 100%;box-shadow: 0px 0px 100px #595959;}
.SumoSelect > .optWrapper > .options > li { padding: 6px 6px; border-bottom: 1px solid #F3F3F3; position: relative; }
.SumoSelect > .optWrapper > .options > li:first-child { border-radius: 2px 2px 0px 0px; }
.SumoSelect > .optWrapper > .options > li:last-child { border-bottom: none; border-radius: 0px 0px 2px 2px; }
.SumoSelect > .optWrapper > .options > li:hover { background-color: #E4E4E4; }
.SumoSelect > .optWrapper > .options > li.sel{background-color: #a1c0e4;}

.SumoSelect > .optWrapper > .options > li label { text-overflow: ellipsis; white-space: nowrap; overflow: hidden; display: block;cursor: pointer;}
.SumoSelect > .optWrapper > .options > li span { display: none; }

/*Floating styles*/
.SumoSelect > .optWrapper.isFloating { position: fixed; top: 0px; left: 0px; right: 0px; width: 90%; bottom: 0px; margin: auto; max-height: 90%; }

/*Hover*/
/*.SumoSelect:hover > .CaptionCont > label { background-color: #F1F1F1; }*/

/*disabled state*/
.SumoSelect > .optWrapper > .options > li.disabled { background-color: inherit;pointer-events: none;}
.SumoSelect > .optWrapper > .options > li.disabled * { -ms-filter: "progid:DXImageTransform.Microsoft.Alpha(Opacity=50)"; /* IE 5-7 */ filter: alpha(opacity=50); /* Netscape */ -moz-opacity: 0.5; /* Safari 1.x */ -khtml-opacity: 0.5; /* Good browsers */ opacity: 0.5; }


/*styling for multiple select*/
.SumoSelect > .optWrapper.multiple > .options > li { padding-left: 35px;cursor: pointer;}
.SumoSelect > .optWrapper.multiple > .options > li span,
.SumoSelect .select-all > span{position:absolute;display:block;width:30px;top:0px;bottom:0px;margin-left:-35px;}
.SumoSelect > .optWrapper.multiple > .options > li span i,
.SumoSelect .select-all > span i{position: absolute;margin: auto;left: 0px;right: 0px;top: 0px;bottom: 0px;width: 14px;height: 14px;border: 1px solid #AEAEAE;border-radius: 2px;box-shadow: inset 0px 1px 3px rgba(0, 0, 0, 0.15);background-color: #fff;}
.SumoSelect > .optWrapper > .MultiControls { display: none; border-top: 1px solid #ddd; background-color: #fff; box-shadow: 0px 0px 2px rgba(0, 0, 0, 0.13); border-radius: 0px 0px 3px 3px; }
.SumoSelect > .optWrapper.multiple.isFloating > .MultiControls { display: block; margin-top: 5px; position: absolute; bottom: 0px; width: 100%; }

.SumoSelect > .optWrapper.multiple.okCancelInMulti > .MultiControls { display: block; }
.SumoSelect > .optWrapper.multiple.okCancelInMulti > .MultiControls > p { padding: 6px; }

.SumoSelect > .optWrapper.multiple > .MultiControls > p { display: inline-block; cursor: pointer; padding: 12px; width: 50%; box-sizing: border-box; text-align: center; }
.SumoSelect > .optWrapper.multiple > .MultiControls > p:hover { background-color: #f1f1f1; }
.SumoSelect > .optWrapper.multiple > .MultiControls > p.btnOk { border-right: 1px solid #DBDBDB; border-radius: 0px 0px 0px 3px; }
.SumoSelect > .optWrapper.multiple > .MultiControls > p.btnCancel { border-radius: 0px 0px 3px 0px; }
/*styling for select on popup mode*/
.SumoSelect > .optWrapper.isFloating > .options > li { padding: 12px 6px; }

/*styling for only multiple select on popup mode*/
.SumoSelect > .optWrapper.multiple.isFloating > .options > li { padding-left: 35px; }
.SumoSelect > .optWrapper.multiple.isFloating { padding-bottom: 43px; }
/*selected state
.SumoSelect > .optWrapper.multiple > .options > li.selected span i:after,
.SumoSelect .select-all.selected > span i:after{content: '';position: absolute;width: 11px;height: 11px;top: 2px;left: 2px;background-color: rgb(17, 169, 17);border-radius: 2px;box-shadow: 0px 1px 2px rgba(0, 0, 0, 0.15);}
*/
.SumoSelect > .optWrapper.multiple > .options > li.selected span i,
.SumoSelect .select-all.selected > span i,
.SumoSelect .select-all.partial > span i{background-color: rgb(17, 169, 17);box-shadow: none;border-color: transparent;background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAgAAAAGCAYAAAD+Bd/7AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAALEgAACxIB0t1+/AAAABx0RVh0U29mdHdhcmUAQWRvYmUgRmlyZXdvcmtzIENTNXG14zYAAABMSURBVAiZfc0xDkAAFIPhd2Kr1WRjcAExuIgzGUTIZ/AkImjSofnbNBAfHvzAHjOKNzhiQ42IDFXCDivaaxAJd0xYshT3QqBxqnxeHvhunpu23xnmAAAAAElFTkSuQmCC');background-repeat: no-repeat;background-position: center center;}
/*disabled state*/
.SumoSelect.disabled { opacity: 0.7;cursor: not-allowed;}
.SumoSelect.disabled > .CaptionCont{border-color:#ccc;box-shadow:none;}

/**Select all button**/
.SumoSelect .select-all{border-radius: 3px 3px 0px 0px;position: relative;border-bottom: 1px solid #ddd;background-color: #fff;padding: 8px 0px 3px 35px;height: 20px;}
.SumoSelect .select-all > span i{cursor:pointer;}
.SumoSelect .select-all.partial > span i{background-color:#ccc;}

/*styling for optgroups*/
.SumoSelect > .optWrapper > .options > li.optGroup { padding-left: 5px; text-decoration: underline; }


.SumoSelect > .optWrapper > .options > li.disabled.group-head span { display:none; }
.SumoSelect > .optWrapper > .options > li.disabled.group-head { padding-left: 12px; color: #000000; font-size:16px; }
.SumoSelect > .optWrapper > .options > li.disabled.group-head *{opacity:1;}
.SumoSelect > .optWrapper > .options > li.group-item { padding-left:40px; }


</style>	

</head>

<body class="container">

	<header>
		<!-- #INCLUDE VIRTUAL="TopNavInclude.asp" -->
	</header>
	
	<section>	

		<div class="panel panel-default" id="panel-parent">
		
			<div class="panel-heading" id="panel-header">
			  
				<div class="panel-title">
				
					<nav class="navbar" role="navigation">
					
						<div class="navbar-header">
							<span class="navbar-brand"><%=organizationName%></span>
						</div>
			 
						<div class="pull-left">
							<ul class="nav nav-tabs">
							
								<li>
								  <a href="RenewalLetters.asp">
								  <i class="glyphicon glyphicon-print"></i>
								  <span class="icon-label">Letters</span>
								  </a>
								</li>

								<% If fnCheckTixUser Then%>
								
								<li  class="active">
								  <a href="RenewalEmails.asp">
								  <i class="glyphicon glyphicon-send"></i>
								  <span class="icon-label">Emails</span>
								  </a>
								</li>

								<li>
								  <a href="#Tab3" data-toggle="tab">
								  <i class="glyphicon glyphicon-list"></i>
								  <span class="icon-label">Reports</span>
								  </a>
								</li>
								
								<% End If %>
							
							</ul>
						</div>
						
						<% If fnCheckTixUser Then%>

						<div class="nav-btn pull-right">
							<BUTTON class="btn btn-large btn-default" id="btnOptions" type="button" data-placement="top" title="Options">
								<span class="fa fa-cog"></span>
								<SPAN class="icon-label">Options</SPAN>
							</BUTTON>
						</div>
						
						<% End If %>
						
					</nav>
				  
				</div>
				
			</div>
		  
		
			<!-- panel edit -->  
			<DIV class="panel-body" id="panel-options-outer">
				<DIV class="container-fluid" id="panel-options-inner"> 
								 
					<ul class="nav nav-pills nav-stacked col-sm-3" style="margin-top: 15px;" style="outline:1px solid red; padding: 15px;">
						<li  class="active"><a href="#tabA" data-toggle="tab">Email Options</a></li>
						<li><a href="#tabB" data-toggle="tab">Option B</a></li>
						<li><a href="#tabC" data-toggle="tab">Option C</a></li>
						<li><a href="#tabD" data-toggle="tab">Option D</a></li>
					</ul>

					<div class="tab-content col-sm-9">
							
						<div class="tab-pane  active" id="tabA" style="border:1px solid rgb(222, 223, 225); border-radius:4px; padding: 5px; min-height: 250px;">
							
							<h4>Test Options</h4>
							
							<form class="form-horizontal" role="form">
							
								<fieldset>
			 
									<div class="form-group">

										<label class="col-sm-3 control-label">Test Mode</label>

										<div class="col-lg-6">

											<label class="switch switch-success">
												<input type="checkbox" id="toggle-switch" class="switch-input form control"> 
												<span class="switch-label" data-on="ON" data-off="OFF"></span>
												<span class="switch-handle"></span>
											</label>

										</div>

									</div>

									<div class="form-group">
									
										<label class="col-sm-3 control-label">Email Address</label>
										
										<div class="col-sm-9">
										
											<select id="recipientInfo" class="toggle-control form-control" required="" name="recipientInfo" multiple="multiple"  >
												<%=EmailArray%>
												<option value="Other">Other</option>
											</select>
											
										</div>
										
									</div>
									
									<div class="form-group">
									
										<label class="col-sm-3 control-label">Email Count</label>
										
										<div class="col-lg-6">
											<input type="text" class="form-control toggle-control" name="EmailCount" placeholder="3" onfocus="this.placeholder = ''" onblur="this.placeholder = '3'"/>										
										</div>
										
									</div>


								</fieldset>

							</form>
							
						</div>
						
						<div class="tab-pane" id="tabB" style="border:1px solid rgb(222, 223, 225); border-radius:4px; padding: 5px; min-height: 250px;">
							<h3>Option B</h3>	
						</div>
						
						<div class="tab-pane" id="tabC" style="border:1px solid rgb(222, 223, 225); border-radius:4px; padding: 5px; min-height: 250px;">
							<h3>Option C</h3>
						</div>
						
						<div class="tab-pane" id="tabD" style="border:1px solid rgb(222, 223, 225); border-radius:4px; padding: 5px; min-height: 250px;">
							<h3>Option D</h3>
						</div>
						
					</div>
					
				</div>

			</div>
		  
			<!-- panel body -->
			<div class="panel-body" id="panel-display">
	  
				<H3 class="panel-title">Email</H3> <%=TestModeStatus%>

			<%
			'Get Matching Events
			'REE 4/6/2 - Modified to include OrganizationAct selection criteria
			'REE 2/25/3 - Removed TicketFormat from criteria.
			SQLEvents = "SELECT Event.EventCode FROM Event (NOLOCK) INNER JOIN Venue ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber WHERE Organization.OrganizationNumber = " & Session("OrganizationNumber") & " AND EventDate > GETDATE() ORDER BY EventDate"
			Set rsEvents = OBJdbConnection.Execute(SQLEvents)

			EventList = ""
			If Not rsEvents.EOF Then
				EventList = "("
				Do Until rsEvents.EOF
					EventList = EventList & rsEvents("EventCode") & "," 
					rsEvents.MoveNext
				Loop
				EventList = Left(EventList,len(EventList)-1) & ")"
			End If

			If EventList <> "" Then
				'REE 2/25/3 - Removed TicketFormat from criteria.
				SQLTickets = "SELECT COUNT(OrderLine.ItemNumber) AS TicketCount, Act.Act, EventDate, Event.EventCode, Venue FROM Event (NOLOCK) INNER JOIN Seat ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Shipping ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN Act ON Event.ActCode = Act.ActCode INNER JOIN Venue ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber INNER JOIN OrganizationAct ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber WHERE Event.EventCode IN " & EventList & " AND EventDate > GETDATE() AND OrderLine.StatusCode = 'R' AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') AND Customer.EMailAddress IS NOT NULL AND Customer.EMailAddress <> '' GROUP BY Event.EventCode, EventDate, Act.Act, Venue.Venue ORDER BY EventDate, Act.Act"
				Set rsTickets = OBJdbConnection.Execute(SQLTickets)
				
				'REE 4/6/2 - Modified to check for events.
				If Not rsTickets.EOF Then 'There are some events.  List them
					Response.Write "<FORM ACTION=""RenewalEMails.asp"" METHOD=""post""><INPUT TYPE=""hidden"" NAME=""FormName"" VALUE=""PrintMenu"">" & vbCrLf

					Response.Write "<TABLE class=""table table-striped table-bordered table-fade"">" & vbCrLf
					Response.Write "<THEAD>" & vbCrLf
					Response.Write "<TR><TH>Print</TH><TH style=""text-align:left"">Subscription</TH><TH style=""text-align:left"">Venue</TH><TH>Date/Time</TH><TH>Quantity</TH></TR>" & vbCrLf
					Response.Write "</THEAD>" & vbCrLf
					Response.Write "<TBODY>" & vbCrLf
					'Display Event and UnPrinted Ticket Quantities
					Do Until rsTickets.EOF

						Response.Write "<TR BGCOLOR=""DDDDDD""><TD ALIGN=""center""><INPUT TYPE=""checkbox"" NAME=""EventCode"" VALUE=" & rsTickets("EventCode") & "></FONT></TD><TD><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">" & rsTickets("Act") & "</FONT></TD><TD><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">" & rsTickets("Venue") & "</FONT></TD><TD ALIGN=""center"" NOWRAP><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">" & DateAndTimeFormat(rsTickets("EventDate")) & "</FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">" & rsTickets("TicketCount") & "</FONT></TD></TR>" & vbCrLf

						rsTickets.MoveNext

					Loop
					Response.Write "</TBODY>" & vbCrLf	
					Response.Write "</TABLE><BR>" & vbCrLf
					
					'Display Buttons to Print
		
					Response.Write "<p>" & vbCrLf
										
					Response.Write EmailButton & vbCrLf

					Response.Write "</p>" & vbCrLf
				
				Else 'There aren't any matching events
				
					Response.Write "<BR><BR>There are no events to be printed.<BR><BR>" & vbCrLf
					
				End If
				
			Else 'There aren't any matching events
			
					Response.Write "<BR><BR>There are no events to be printed.<BR><BR>" & vbCrLf
				
			End If
			%>
			
			</div>

			
		</DIV>

	</section>
	
	<footer>

<!-- #INCLUDE VIRTUAL="FooterInclude.asp" -->	
			
	<SCRIPT src="https://code.jquery.com/jquery-1.9.1.js" type="text/javascript" language="javascript"></SCRIPT> 
	<SCRIPT src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.10.3/jquery-ui.min.js" type="text/javascript" language="javascript"></SCRIPT> 
	<SCRIPT src="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js" type="text/javascript" language="javascript"></SCRIPT> 
	<SCRIPT src="https://cdn.jsdelivr.net/icheck/1.0.2/icheck.min.js" type="text/javascript" language="javascript" ></SCRIPT> 
	
<script>
/*!
 * jquery.sumoselect - v2.0.2
 * http://hemantnegi.github.io/jquery.sumoselect
 * 2014-04-08
 *
 * Copyright 2015 Hemant Negi
 * Email : hemant.frnz@gmail.com
 * Compressor http://refresh-sf.com/yui/
 */

(function ($) {

    'namespace sumo';
    $.fn.SumoSelect = function (options) {

        // var is_visible_default = false;
        //$(document).click(function () { is_visible_default = false; });

        // This is the easiest way to have default options.
        var settings = $.extend({
            placeholder: 'Select Here',   // Dont change it here.
            csvDispCount: 3,              // display no. of items in multiselect. 0 to display all.
            captionFormat:'{0} Selected', // format of caption text. you can set your locale.
            floatWidth: 400,              // Screen width of device at which the list is rendered in floating popup fashion.
            forceCustomRendering: false,  // force the custom modal on all devices below floatWidth resolution.
            nativeOnDevice: ['Android', 'BlackBerry', 'iPhone', 'iPad', 'iPod', 'Opera Mini', 'IEMobile', 'Silk'], //
            outputAsCSV: false,           // true to POST data as csv ( false for Html control array ie. deafault select )
            csvSepChar: ',',              // seperation char in csv mode
            okCancelInMulti: false,       //display ok cancel buttons in desktop mode multiselect also.
            triggerChangeCombined: true,  // im multi select mode wether to trigger change event on individual selection or combined selection.
            selectAll: false,             // to display select all button in multiselect mode.|| also select all will not be available on mobile devices.
            selectAlltext: 'Select All'   // the text to display for select all.

        }, options);

        var ret = this.each(function () {
            var selObj = this; // the original select object.
            if (this.sumo || !$(this).is('select')) return; //already initialized

            this.sumo = {
                E: $(selObj),   //the jquery object of original select element.
                is_multi: $(selObj).attr('multiple'),  //if its a mmultiple select
                select: '',
                caption: '',
                placeholder: '',
                optDiv: '',
                CaptionCont: '',
                is_floating: false,
                is_opened: false,
                //backdrop: '',
                mob:false, // if to open device default select
                Pstate: [],

                createElems: function () {
                    var O = this;
                    O.E.wrap('<div class="SumoSelect" tabindex="0">');
                    O.select = O.E.parent();
                    O.caption = $('<span></span>');
                    O.CaptionCont = $('<p class="CaptionCont"><label><i></i></label></p>').addClass('SlectBox').attr('style', O.E.attr('style')).prepend(O.caption);
                    O.select.append(O.CaptionCont);

                    if(O.E.attr('disabled'))
                        O.select.addClass('disabled').removeAttr('tabindex');

                    //if output as csv and is a multiselect.
                    if (settings.outputAsCSV && O.is_multi && O.E.attr('name')) {
                        //create a hidden field to store csv value.
                        O.select.append($('<input class="HEMANT123" type="hidden" />').attr('name', O.E.attr('name')).val(O.getSelStr()));

                        // so it can not post the original select.
                        O.E.removeAttr('name');
                    }

                    //break for mobile rendring.. if forceCustomRendering is false
                    if (O.isMobile() && !settings.forceCustomRendering) {
                        O.setNativeMobile();
                        return;
                    }

                    //hide original select
                    O.E.hide();

                    //## Creating the list...
                    O.optDiv = $('<div class="optWrapper">');

                    //branch for floating list in low res devices.
                    O.floatingList();

                    //Creating the markup for the available options
                    ul = $('<ul class="options">');
                    O.optDiv.append(ul);

                    // Select all functionality
                    if (settings.selectAll) O.selAll();

                    $(O.E.children('option')).each(function (i, opt) {       // parsing options to li
                        opt = $(opt);
                        O.createLi(opt);
                    });

                    //if multiple then add the class multiple and add OK / CANCEL button
                    if (O.is_multi) O.multiSelelect();

                    O.select.append(O.optDiv);
                    O.basicEvents();
                    O.selAllState();
                },

                //## Creates a LI element from a given option and binds events to it
                //## Adds it to UL at a given index (Last by default)
                createLi: function (opt,i) {
                    var O = this;

                    if(!opt.attr('value'))opt.attr('value',opt.val());

                    li = $('<li data-val="' + opt.val() + '"><label>' + opt.text() + '</label></li>');
                    if (O.is_multi) li.prepend('<span><i></i></span>');

                    if (opt[0].disabled)
                        li = li.addClass('disabled');

                    O.onOptClick(li);

                    if (opt[0].selected)
                        li.addClass('selected');

                    if (opt.attr('class'))
                        li.addClass(opt.attr('class'));

                    ul = O.optDiv.children('ul.options');
                    if (typeof i == "undefined")
                        ul.append(li);
                    else
                        ul.children('li').eq(i).before(li);

                    return li;
                },

                //## Returns the selected items as string in a Multiselect.
                getSelStr: function () {
                    // get the pre selected items.
                    sopt = [];
                    this.E.children('option:selected').each(function () { sopt.push($(this).val()); });
                    return sopt.join(settings.csvSepChar);
                },

                //## THOSE OK/CANCEL BUTTONS ON MULTIPLE SELECT.
                multiSelelect: function () {
                    var O = this;
                    O.optDiv.addClass('multiple');
                    O.okbtn = $('<p class="btnOk">OK</p>').click(function () {

                        //if combined change event is set.
                        if (settings.triggerChangeCombined) {

                            //check for a change in the selection.
                            changed = false;
                            if (O.E.children('option:selected').length != O.Pstate.length) {
                                changed = true;
                            }
                            else {
                                O.E.children('option:selected').each(function () {
                                    if (O.Pstate.indexOf($(this).val()) < 0) changed = true;
                                });
                            }

                            if (changed) {
                                O.E.trigger('change').trigger('click');
                                O.setText();
                            }
                        }
                        O.hideOpts();
                    });
                    O.cancelBtn = $('<p class="btnCancel">Cancel</p>').click(function () {
                        O._cnbtn();
                        O.hideOpts();
                    });
                    O.optDiv.append($('<div class="MultiControls">').append(O.okbtn).append(O.cancelBtn));
                },

                _cnbtn:function(){
                    var O = this;
                    //remove all selections
                        O.E.children('option:selected').each(function () { this.selected = false; });
                        O.optDiv.find('li.selected').removeClass('selected')

                        //restore selections from saved state.
                        for (i = 0; i < O.Pstate.length; i++) {
                            O.E.children('option[value="' + O.Pstate[i] + '"]')[0].selected = true;
                            O.optDiv.find('li[data-val="' + O.Pstate[i] + '"]').addClass('selected');
                        }
                    O.selAllState();
                },

                selAll:function(){
                    var O = this;
                    if(!O.is_multi)return;
                    O.chkAll = $('<i>');
                    O.selAll = $('<p class="select-all"><label>' + settings.selectAlltext + '</label></p>').prepend($('<span></span>').append(O.chkAll));
                    O.chkAll.on('click',function(){
                        //O.toggSelAll(!);
                        O.selAll.toggleClass('selected');
                        O.optDiv.find('ul.options li').each(function(ix,e){
                            e = $(e);
                            if(O.selAll.hasClass('selected')){
                                if(!e.hasClass('selected'))e.trigger('click');
                            }
                            else
                                if(e.hasClass('selected'))e.trigger('click');
                        });
                    });

                    O.optDiv.prepend(O.selAll);
                },

                selAllState: function () {
                    var O = this;
                    if (settings.selectAll) {
                        var sc = 0, vc = 0;
                        O.optDiv.find('ul.options li').each(function (ix, e) {
                            if ($(e).hasClass('selected')) sc++;
                            if (!$(e).hasClass('disabled')) vc++;
                        });
                        //select all checkbox state change.
                        if (sc == vc) O.selAll.removeClass('partial').addClass('selected');
                        else if (sc == 0) O.selAll.removeClass('selected partial');
                        else O.selAll.addClass('partial')//.removeClass('selected');
                    }
                },

                showOpts: function () {
                    var O = this;
                    if (O.E.attr('disabled')) return; // if select is disabled then retrun
                    O.is_opened = true;
                    //O.backdrop.show();
                    O.optDiv.addClass('open');

                    // hide options on click outside.
//                    $(document).on('click.sumo', function (e) {
//                            if (!O.select.is(e.target)                  // if the target of the click isn't the container...
//                                && O.select.has(e.target).length === 0) // ... nor a descendant of the container
//                            {   if (O.is_multi && settings.okCancelInMulti)
//                                    O._cnbtn();
//                                O.hideOpts();
//                            }
//                    });

                    if (O.is_floating) {
                        H = O.optDiv.children('ul').outerHeight() + 2;  // +2 is clear fix
                        if (O.is_multi) H = H + parseInt(O.optDiv.css('padding-bottom'));
                        O.optDiv.css('height', H);
                    }

                    //maintain state when ok/cancel buttons are available.
                    if (O.is_multi && (O.is_floating || settings.okCancelInMulti)) {
                        O.Pstate = [];
                        O.E.children('option:selected').each(function () { O.Pstate.push($(this).val()); });
                    }
                },
                hideOpts: function () {
                    var O = this;
                    O.is_opened = false;
                    O.optDiv.removeClass('open').find('ul li.sel').removeClass('sel');
                    //$(document).off('click.sumo');
                },
                setOnOpen: function () {
                    var O = this;
                    var li = O.optDiv.find('ul li').eq(O.E[0].selectedIndex);
                    li.addClass('sel');
                    O.showOpts();
                },
                nav: function (up) {
                    var O = this, c;
                    var sel = O.optDiv.find('ul li.sel');
                    if (O.is_opened && sel.length) {
                        if (up)
                            c = sel.prevAll('li:not(.disabled)');
                        else
                            c = sel.nextAll('li:not(.disabled)');
                        if (!c.length)return;
                        sel.removeClass('sel');
                        sel = c.first().addClass('sel');

                        // setting sel item to visible view.
                        var ul = O.optDiv.find('ul'),
                            st = ul.scrollTop(),
                            t = sel.position().top + st;                            
                        if(t >= st + ul.height()-sel.outerHeight())
                            ul.scrollTop(t - ul.height() + sel.outerHeight());
                        if(t<st)
                            ul.scrollTop(t);

                    }
                    else
                        O.setOnOpen();
                },

                basicEvents: function () {
                    var O = this;
                    O.CaptionCont.click(function (evt) {
                        O.E.trigger('click');
                        if (O.is_opened) O.hideOpts(); else O.showOpts();
                        evt.stopPropagation();
                    });

                    O.select.on('blur focusout', function () {
                        if(!O.is_opened)return;
                        //O.hideOpts();
                        O.hideOpts();

                    if (O.is_multi && settings.okCancelInMulti)
                         O._cnbtn();
                    })
                        .on('keydown', function (e) {
                            switch (e.which) {
                                case 38: // up
                                    O.nav(true);
                                    break;

                                case 40: // down
                                    O.nav(false);
                                    break;

                                case 32: // space
                                case 13: // enter
                                    if (O.is_opened)
                                        O.optDiv.find('ul li.sel').trigger('click');
                                    else
                                        O.setOnOpen();
                                    break;

                                case 27: // esc
                                     if (O.is_multi && settings.okCancelInMulti)O._cnbtn();
                                    O.hideOpts();
                                    break;

                                default:
                                    return; // exit this handler for other keys
                            }
                            e.preventDefault(); // prevent the default action (scroll / move caret)
                        });

                    $(window).on('resize.sumo', function () {
                        O.floatingList();
                    });
                },

                onOptClick: function (li) {
                    var O = this;
                    li.click(function () {
                        var li = $(this);
                        if(li.hasClass('disabled'))return;
                        txt = "";
                        if (O.is_multi) {
                            li.toggleClass('selected');
                            O.E.children('option[value="' + li.data('val') + '"]')[0].selected = li.hasClass('selected');

                            O.selAllState();
                        }
                        else {
                            li.parent().find('li.selected').removeClass('selected'); //if not multiselect then remove all selections from this list
                            li.toggleClass('selected');
                            O.E.val(li.attr('data-val'));   //set the value of select element
                        }

                        //branch for combined change event.
                        if (!(O.is_multi && settings.triggerChangeCombined && (O.is_floating || settings.okCancelInMulti))) {
                            O.setText();
                            O.E.trigger('change').trigger('click');
                        }

                        if (!O.is_multi) O.hideOpts(); //if its not a multiselect then hide on single select.
                    });
                },

                setText: function () {
                    var O = this;
                    O.placeholder = "";
                    if (O.is_multi) {
                        sels = O.E.children(':selected').not(':disabled'); //selected options.

                        for (i = 0; i < sels.length; i++) {
                            if (i >= settings.csvDispCount && settings.csvDispCount) {
                                O.placeholder = settings.captionFormat.replace('{0}', sels.length);
                                //O.placeholder = i + '+ Selected';
                                break;
                            }
                            else O.placeholder += $(sels[i]).text() + ", ";
                        }
                        O.placeholder = O.placeholder.replace(/,([^,]*)$/, '$1'); //remove unexpected "," from last.
                    }
                    else {
                        O.placeholder = O.E.children(':selected').not(':disabled').text();
                    }

                    is_placeholder = false;

                    if (!O.placeholder) {

                        is_placeholder = true;

                        O.placeholder = O.E.attr('placeholder');
                        if (!O.placeholder)                  //if placeholder is there then set it
                        {
                            O.placeholder = O.E.children('option:disabled:selected').text();
                            //if (!O.placeholder && settings.placeholder === 'Select Here')
                            //    O.placeholder = O.E.val();
                        }
                    }

                    O.placeholder = O.placeholder ? O.placeholder : settings.placeholder

                    //set display text
                    O.caption.text(O.placeholder);

                    //set the hidden field if post as csv is true.
                    csvField = O.select.find('input.HEMANT123');
                    if (csvField.length) csvField.val(O.getSelStr());

                    //add class placeholder if its a placeholder text.
                    if (is_placeholder) O.caption.addClass('placeholder'); else O.caption.removeClass('placeholder');
                    return O.placeholder;
                },

                isMobile: function () {

                    // Adapted from http://www.detectmobilebrowsers.com
                    var ua = navigator.userAgent || navigator.vendor || window.opera;

                    // Checks for iOs, Android, Blackberry, Opera Mini, and Windows mobile devices
                    for (var i = 0; i < settings.nativeOnDevice.length; i++) if (ua.toString().toLowerCase().indexOf(settings.nativeOnDevice[i].toLowerCase()) > 0) return settings.nativeOnDevice[i];
                    return false;
                },

                setNativeMobile: function () {
                    var O = this;
                    O.E.addClass('SelectClass')//.css('height', O.select.outerHeight());
					O.mob = true;
                    O.E.change(function () {
                        O.setText();
                    });
                },

                floatingList: function () {
                    var O = this;
                    //called on init and also on resize.
                    //O.is_floating = true if window width is < specified float width
                    O.is_floating = $(window).width() <= settings.floatWidth;

                    //set class isFloating
                    O.optDiv.toggleClass('isFloating', O.is_floating);

                    //remove height if not floating
                    if (!O.is_floating) O.optDiv.css('height', '');

                    //toggle class according to okCancelInMulti flag only when it is not floating
                    O.optDiv.toggleClass('okCancelInMulti', settings.okCancelInMulti && !O.is_floating);
                },

                //HELPERS FOR OUTSIDERS
                // validates range of given item operations
                vRange: function (i) {
                    var O = this;
                    opts = O.E.children('option');
                    if (opts.length <= i || i < 0) throw "index out of bounds"
                    return O;
                },

                //toggles selection on c as boolean.
                toggSel: function (c, i) {
                    var O = this.vRange(i);
                    if (O.E.children('option')[i].disabled) return;
                    O.E.children('option')[i].selected = c;
                    if(!O.mob)O.optDiv.find('ul.options li').eq(i).toggleClass('selected',c);
                    O.setText();
                },

                //toggles disabled on c as boolean.
                toggDis: function (c, i) {
                    var O = this.vRange(i);
                    O.E.children('option')[i].disabled = c;
                    if(c)O.E.children('option')[i].selected = false;
                    if(!O.mob)O.optDiv.find('ul.options li').eq(i).toggleClass('disabled', c).removeClass('selected');
                    O.setText();
                },

                // toggle disable/enable on complete select control
                toggSumo: function(val) {
                    var O = this;
                    O.enabled = val;
                    O.select.toggleClass('disabled', val);

                    if (val) {
                        O.E.attr('disabled', 'disabled');
                        O.select.removeAttr('tabindex');
                    }
                    else{
                        O.E.removeAttr('disabled');
                        O.select.attr('tabindex','0');
                    }

                    return O;
                },

                //toggles alloption on c as boolean.
                toggSelAll: function (c) {
                    var O = this;
                    O.E.find('option').each(function (ix, el) {
                        if (O.E.find('option')[$(this).index()].disabled) return;
                        O.E.find('option')[$(this).index()].selected = c;
                        if (!O.mob)
							O.optDiv.find('ul.options li').eq($(this).index()).toggleClass('selected', c);
                        O.setText();
                    });
                    if(!O.mob && settings.selectAll)O.selAll.removeClass('partial').toggleClass('selected',c);
                },

                /* outside accessibility options
                   which can be accessed from the element instance.
                */
                reload:function(){
                    var elm = this.unload();
                    return $(elm).SumoSelect(settings);
                },

                unload: function () {
                    var O = this;
                    O.select.before(O.E);
                    O.E.show();

                    if (settings.outputAsCSV && O.is_multi && O.select.find('input.HEMANT123').length) {
                        O.E.attr('name', O.select.find('input.HEMANT123').attr('name')); // restore the name;
                    }
                    O.select.remove();
                    delete selObj.sumo;
                    return selObj;
                },

                //## add a new option to select at a given index.
                add: function (val, txt, i) {
                    if (typeof val == "undefined") throw "No value to add"

                    var O = this;
                    opts=O.E.children('option')
                    if (typeof txt == "number") { i = txt; txt = val; }
                    if (typeof txt == "undefined") { txt = val; }

                    opt = $("<option></option>").val(val).html(txt);

                    if (opts.length < i) throw "index out of bounds"

                    if (typeof i == "undefined" || opts.length == i) { // add it to the last if given index is last no or no index provides.
                        O.E.append(opt);
                        if(!O.mob)O.createLi(opt);
                    }
                    else {
                        opts.eq(i).before(opt);
                        if(!O.mob)O.createLi(opt, i);
                    }

                    return selObj;
                },

                //## removes an item at a given index.
                remove: function (i) {
                    var O = this.vRange(i);
                    O.E.children('option').eq(i).remove();
                    if(!O.mob)O.optDiv.find('ul.options li').eq(i).remove();
                    O.setText();
                },

                //## Select an item at a given index.
                selectItem: function (i) { this.toggSel(true, i); },

                //## UnSelect an iten at a given index.
                unSelectItem: function (i) { this.toggSel(false, i); },

                //## Select all items  of the select.
                selectAll: function () { this.toggSelAll(true); },

                //## UnSelect all items of the select.
                unSelectAll: function () { this.toggSelAll(false); },

                //## Disable an iten at a given index.
                disableItem: function (i) { this.toggDis(true, i) },

                //## Removes disabled an iten at a given index.
                enableItem: function (i) { this.toggDis(false, i) },

                //## New simple methods as getter and setter are not working fine in ie8-
                //## variable to check state of control if enabled or disabled.
                enabled : true,
                //## Enables the control
                enable: function(){return this.toggSumo(false)},

                //## Disables the control
                disable: function(){return this.toggSumo(true)},


                init: function () {
                    var O = this;
                    O.createElems();
                    O.setText();
                    return O
                }

            };

            selObj.sumo.init();
        });

        return ret.length == 1 ? ret[0] : ret;
    };


}(jQuery));


$('#recipientInfo').SumoSelect({ okCancelInMulti: true});

</script>
	
	<SCRIPT type="text/javascript" language="javascript">
	
		$(function() 
		{
		
			// iCHECK - RADIO BUTTON
		
			// set radio button color
			$("input[type=radio]").iCheck(
			{
				radioClass: 'iradio_square-green',
				increaseArea: '30%'
			});
			
			// activate hightlight for pre-selected radiobuttons
			$("input[type=radio]:checked").each(function() 
			{
				$(this).closest("tr").addClass("active");
			});
			
			// toggle hightlight when radiobutton changes state
			$("input[type=radio]").on('ifToggled', function(event)
			{
				$(this).closest("tr").toggleClass("active")
			});
			
			// iCHECK - CHECKBOX
			
			// set checkbox color
			// ignore toggle switch checkboxes
			$("input[type=checkbox]:not(.switch-input)").iCheck(
			{
				checkboxClass: 'icheckbox_square-green',
				increaseArea: '30%'
			});

			// activate hightlight for pre-selected checkboxes
			$("input[type=checkbox]:checked").each(function() 
			{
				$(this).closest("tr").addClass("active");
			});

			// toggle hightlight when checkbox changes state
			$("input[type=checkbox]").on('ifToggled', function(event)
			{
				$(this).closest("tr").toggleClass("active")
			});
		 
		}); 
		
				(function($) 
		{
			$.fn.toggleDisabled = function() 
			{
				return this.each(function() 
				{
					var $this = $(this);
					if ($this.attr('disabled')) $this.removeAttr('disabled');		
					
					else $this.attr('disabled', 'disabled');
				});
			};
		})(jQuery);

		$(function() 
		{
			//toggle switch is disabled by default
			$('#toggle-switch').prop('checked', false);
			
			//toggle controls are all disabled by default
			$('.toggle-control').prop('disabled', true);

			//toggle control submit is enabled by default
			$('.toggle-submit').prop('disabled', false);
			
			//enable toggle controls when toggle switch selected
			$('#toggle-switch').change(function() 
			{
				$('.toggle-control').toggleDisabled();       
			});
		});


		jQuery.fn.blindToggle = function(speed, easing, callback) 
		{
		var h = (this.height() + parseInt(this.css('paddingTop')) + parseInt(this.css('paddingBottom')) + 9);
		return this.animate({marginTop: parseInt(this.css('marginTop')) < 0 ? 0 : -h}, speed, easing, callback);  
		};
 
		jQuery.fn.slideFadeToggle = function(speed, easing, callback) 
		{
		return this.animate({opacity: 'toggle', height: 'toggle'}, speed, easing, callback);  
		};
 
		$(function() 
		{
			$('#btnOptions').click(function() 
			{
				$('#panel-options-inner').blindToggle(1000, 'easeInOutQuart');
			});    
		});

	</SCRIPT>
	
	</footer>
	
</BODY>

</HTML>

<%

End Sub 'PrintMenu

'---------------------------------

Sub PrintLetters

'Server.ScriptTimeout = 600

%>

<HTML>
<HEAD>
<TITLE>TIX - Subscription Renewal E-Mail</TITLE>
</HEAD>
<BODY LEFTMARGIN="0" RIGHTMARGIN="0" TOPMARGIN="0" MARGINHEIGHT="0" MARGINWIDTH="0">

<STYLE>	
	div {page-break-before: always}
</STYLE>

<FONT COLOR="#000000">
<%

'Build the Query to select each of the selected events
'REE 7/7/3 - Removed EventShip from Query.
SQLOrderLine = "SELECT OrderHeader.OrderTypeNumber, OrderHeader.OrderSurcharge, OrderHeader.ShipFee, OrderHeader.Total, OrderLine.OrderNumber, OrderLine.LineNumber, OrderLine.ItemNumber, OrderLine.Price, OrderLine.Surcharge, OrderLine.Discount, OrderLine.ShipCode, Event.EventCode, Event.EventDate, Event.Map, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, PostalCode, Customer.DayPhone, Customer.NightPhone, Customer.EMailAddress, Shipping.ShipType, Act.Act, Venue.Venue, SeatType.SeatType, Seat.Row, Seat.Seat, Seat.SectionCode, Section.Section FROM OrderLine INNER JOIN OrderHeader ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN Seat ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event ON Seat.EventCode = Event.EventCode INNER JOIN Section ON Seat.SectionCode = Section.SectionCode AND Event.EventCode = Section.EventCode INNER JOIN Act ON Event.ActCode = Act.ActCode INNER JOIN Venue ON Event.VenueCode = Venue.VenueCode INNER JOIN SeatType ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN Shipping ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct ON Event.ActCode = OrganizationAct.ActCode "
For Each Item In Request("EventCode") 'Loop for each Event requested
	EventNumber = EventNumber + 1
	If SQLWhere = "" Then 
		SQLWhere = " WHERE Event.EventCode IN (" & Clean(Request("EventCode"))
	Else
		SQLWhere = SQLWhere & ", " & Clean(Request("EventCode"))
	End If
Next

'Get the Info to Print
'REE 4/6/2 - Modified to use OrganizationAct in selection criteria
SQLOrderLine = SQLOrderLine & SQLWhere & ") AND OrderLine.StatusCode = 'R' AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') AND Customer.EMailAddress IS NOT NULL AND Customer.EMailAddress <> '' AND OrderHeader.OrderNumber > 2082898 ORDER BY OrderLine.OrderNumber, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry, OrderLine.ShipCode, Seat.EventCode, Seat.SectionCode, RowSort, SeatSort DESC"
Set rsOrderLine = OBJdbConnection.Execute(SQLOrderLine)
		
Do Until rsOrderLine.EOF

	If rsOrderLine("OrderNumber") <> LastOrderNumber Then 
	'This is not the last order.
	
		'Print the footer
		If TicketCount > 0 Then
		
			EMailMessage = EMailMessage & "<TR><TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf			
			If LastShipFee <> 0 And LastOrderTypeNumber <> 5 Then
				EMailMessage = EMailMessage & "<TR><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=" & MsgFontFace & ">Processing Fee</TD><TD ALIGN=""right""><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(LastShipFee,2) & "</TD></TR>" & vbCrLf
				EMailMessage = EMailMessage & "<TR><TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf
			End If

			SQLTender = "SELECT SUM(Tender.Amount) AS TenderAmount FROM Tender (NOLOCK) WHERE Tender.OrderNumber = " & LastOrderNumber
			Set rsTender = OBJdbConnection.Execute(SQLTender)
		
			If IsNull(rsTender("TenderAmount")) Then
				LastTender = 0
			Else
				LastTender = rsTender("TenderAmount")
				Response.Write SQLTender & "<BR>"
			End If
		
			rsTender.Close
			Set rsTender = nothing	

			EMailMessage = EMailMessage & "<TR><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=" & MsgFontFace & ">Order Total</TD><TD ALIGN=""right""><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(LastTotal,2) & "</TD></TR>" & vbCrLf
			If LastTender <> 0 Then
				EMailMessage = EMailMessage & "<TR><TD WIDTH=""50"">&nbsp;</TD><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=C" & MsgFontFace & ">Less Payments</TD><TD ALIGN=""right""><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(LastTender,2) & "</TD></TR>" & vbCrLf
				EMailMessage = EMailMessage & "<TR><TD WIDTH=""50"">&nbsp;</TD><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=" & MsgFontFace & ">Balance Due</TD><TD ALIGN=""right""><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(LastTotal - LastTender,2) & "</TD></TR>" & vbCrLf
			End If
			EMailMessage = EMailMessage & "</TABLE>" & vbCrLf
			EMailMessage = EMailMessage & "</CENTER><BR>" & vbCrLf
			
			'-----------------------------------------
			
			'Footer Info
			'Insert HTML Template - Footer Content
									
			EMailMessage = EMailMessage & "<TABLE WIDTH=""650"" cellpadding=""0"" cellspacing=""0"" border=""0"">" & vbCrLf
			EMailMessage = EMailMessage & "<TR>" & vbCrLf
			EMailMessage = EMailMessage & "<TD valign=top>" & vbCrLf
			EMailMessage = EMailMessage & "<FONT FACE=" & MsgFontFace & "><BR>" & vbCrLf

			'Insert HTML Template - Body Content
			EMailMessage = EMailMessage & InsertTemplate("Footer") 

			EMailMessage = EMailMessage & "</FONT>" & vbCrLf
			EMailMessage = EMailMessage & "</TD>" & vbCrLf
			EMailMessage = EMailMessage & "</TR>" & vbCrLf
			EMailMessage = EMailMessage & "</TABLE>" & vbCrLf
			EMailMessage = EMailMessage & "<BR>" & vbCrLf
			
			'-----------------------------------------

			'JAI 3/2/5 - Modified to use CDO Mail
			'Create the e-mail server object
			Set objCDOSYSMail = Server.CreateObject("CDO.Message")
			Set objCDOSYSCon = Server.CreateObject ("CDO.Configuration")

			objCDOSYSCon.Fields(cdoSendUsingMethod) = cdoSendUsingPickup 'For localhost
			objCDOSYSCon.Fields.Update

			'Update the CDOSYS Configuration
			Set objCDOSYSMail.Configuration = objCDOSYSCon
			objCDOSYSMail.From = OrganizationName & " <" & EMailReplyTo & ">" 
			objCDOSYSMail.ReplyTo = EMailReplyTo
			If TestEMailAddress <> "" Then
				LastEMailAddress = TestEMailAddress
			End If
			objCDOSYSMail.To = LastEMailAddress
			objCDOSYSMail.Subject = EMailSubject
			objCDOSYSMail.HTMLBody = EMailMessage
			objCDOSYSMail.Send

			'Close the server mail object
			Set objCDOSYSMail = Nothing
			Set objCDOSYSCon = Nothing 

			EMailMessage = ""
	
			Response.Write LastOrderNumber & " | " & LastEmailAddress & "<BR>" & vbCrLf

			OrderCount = OrderCount + 1
			
			If TestEMailAddress <> "" And OrderCount >= TestEmailCount Then
				Exit Do
			End If

		End If

		SQLCustInfo = "SELECT Customer.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry FROM OrderHeader (NOLOCK) INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber WHERE OrderHeader.OrderNumber = " & rsOrderLine("OrderNumber") & " AND OrderLine.LineNumber = " & rsOrderLine("LineNumber")
		Set rsCustInfo = OBJdbConnection.Execute(SQLCustInfo)

		If Not rsCustInfo.EOF Then
		
			'-----------------------------------------
			
			'Insert HTML Template - Header Content
			'Response.Write InsertTemplate("CoverPage") 
			
			'-----------------------------------------
									
			'Shipping and Billing Address
			
			ReturnAddress = ""
				
			ReturnAddress = ReturnAddress & "<BR>" & vbCrLf
			ReturnAddress = ReturnAddress & "<TABLE WIDTH=""650"" cellpadding=""0"" cellspacing=""0"" border=""0"">" & vbCrLf
    		ReturnAddress = ReturnAddress & "<TR><TD>" & vbCrLf
			
			ReturnAddress = ReturnAddress & "<IMG SRC=""" & LogoFilePath & """><BR><BR>" & vbCrLf
			ReturnAddress = ReturnAddress & "</TD></TR>" & vbCrLf
			
			ReturnAddress = ReturnAddress & "<TR><TD>" & vbCrLf
			
			ReturnAddress = ReturnAddress & "<FONT FACE=" & MsgFontFace & ">" & PCase(rsCustInfo("ShipFirstName")) & " " & PCase(rsCustInfo("ShipLastName")) & "<BR>" & PCase(rsCustInfo("ShipAddress1")) & "<BR>" & vbCrLf
			
			If rsCustInfo("ShipAddress2") <> "" Then
				ReturnAddress = ReturnAddress & PCase(rsCustInfo("ShipAddress2")) & "<BR>" & vbCrLf
			End If
			
			ReturnAddress = ReturnAddress & PCase(rsCustInfo("ShipCity")) & ", " & rsCustInfo("ShipState") & " " & rsCustInfo("ShipPostalCode") & "</FONT>" & vbCrLf
			
			ReturnAddress = ReturnAddress & "</TD></TR>" & vbCrLf
            ReturnAddress = ReturnAddress & "</TABLE>" & vbCrLf
			
			EMailMessage = EMailMessage &  ReturnAddress
			
			'-----------------------------------------
									
			'Order Number and Renewal Number
			
			RenewalOrderNumber = rsOrderLine("OrderNumber")
			
			SQLItemNumber = "SELECT ItemNumber FROM OrderLine (NOLOCK) WHERE OrderNumber = " & rsOrderLine("OrderNumber") & " ORDER BY ItemNumber"
			Set rsItemNumber = OBJdbConnection.Execute(SQLItemNumber)
				RenewalCode = rsCustInfo("CustomerNumber") & rsItemNumber("ItemNumber")
				RenewalOrder = rsOrderLine("OrderNumber")
				EasyRenewalURL = RenewalURL & "o=" & RenewalOrder & "&c=" & RenewalCode & "&np=sc"
			rsItemNumber.Close
			Set rsItemNumber = nothing
			
			
			OrderRenewal = ""
			OrderRenewal = OrderRenewal & "<TABLE WIDTH=""650"" cellpadding=""0"" cellspacing=""0"" border=""0"">" & vbCrLf
			OrderRenewal = OrderRenewal & "<TR>" & vbCrLf
			OrderRenewal = OrderRenewal & "<TD ALIGN=""left"">" & vbCrLf
			OrderRenewal = OrderRenewal & "<FONT FACE=""" & MsgFontFace & """><B>Order Number:</B>&nbsp;" & rsOrderLine("OrderNumber") & "</FONT>" & vbCrLf
			OrderRenewal = OrderRenewal & "</TD>" & vbCrLf
			OrderRenewal = OrderRenewal & "<TD ALIGN=""right"">" & vbCrLf		
			OrderRenewal = OrderRenewal & "<FONT FACE=""" & MsgFontFace & """><B>Renewal Code:</B>&nbsp;" & RenewalCode & "</FONT>" & vbCrLf
			OrderRenewal = OrderRenewal & "</TD>" & vbCrLf
			OrderRenewal = OrderRenewal & "</TR>" & vbCrLf
			OrderRenewal = OrderRenewal & "</TABLE>" & vbCrLf
			OrderRenewal = OrderRenewal & "<BR>" & vbCrLf
			
			'-----------------------------------------
			
			EMailMessage = EMailMessage & "<TABLE WIDTH=""650"" cellpadding=""0"" cellspacing=""0"" border=""0"">" & vbCrLf
			EMailMessage = EMailMessage & "<TR><TD valign=top>" & vbCrLf
			EMailMessage = EMailMessage & "<FONT FACE=" & MsgFontFace & "><BR>" & vbCrLf

			'Insert HTML Template - Body Content
			EMailMessage = EMailMessage & InsertTemplate("Header") 

			EMailMessage = EMailMessage & "</FONT>" & vbCrLf
			EMailMessage = EMailMessage & "</TD></TR></TBODY></TABLE>" & vbCrLf
			EMailMessage = EMailMessage & "<BR>" & vbCrLf
			
			EMailMessage = EMailMessage & OrderRenewal
			
			'-----------------------------------------

		Else

			ErrorLog("Invoice Format - Order Number = " & Clean(Request("OrderNumber")) & " | Line Number = " & Clean(Request("LineNumber")))

		End If

		rsCustInfo.Close
		Set rsCustInfo = nothing

		LastEventCode = 0
		LastOrderNumber = rsOrderLine("OrderNumber")
		LastOrderTypeNumber = rsOrderLine("OrderTypeNumber")
				
		'Update the Footer Totals
		LastOrderSurcharge = rsOrderLine("OrderSurcharge")
		LastShipType = rsOrderLine("ShipType")
		LastShipFee = rsOrderLine("ShipFee")
		LastDiscount = rsOrderLine("Discount")
		LastTotal = rsOrderLine("Total")
		
		LastEMailAddress = rsOrderLine("EMailAddress")
		
		TicketCount = TicketCount + 1

	End If

	'Print Event Info and Column Headings if this is a new Event
	If LastEventCode <> rsOrderLine("EventCode") Or LastOrderNumber <> rsOrderLine("OrderNumber") Then
	
        If LastEventCode <> 0 AND LastEventCode <> rsOrderLine("EventCode") Then
		    EMailMessage = EMailMessage & "</TABLE><BR>" & vbCrlf
        End if
		
		'-----------------------------------------
			
		'Production Name, Date & Time
		'Order Delivery Method
	
		EMailMessage = EMailMessage & "<TABLE WIDTH=""650"" cellpadding=""0"" cellspacing=""0""  border=""0"">" & vbCrLf
		EMailMessage = EMailMessage & "<TR><TD>" & vbCrLf
		EMailMessage = EMailMessage & "<FONT FACE=""" & MsgFontFace & """><B>" & rsOrderLine("Act") & "<br>" & vbCrLf
		EMailMessage = EMailMessage & "at " & rsOrderLine("Venue") & "<br>" & vbCrLf
		
		'REE 6/5/6 - Modified to look at EventOptions for Date & Time Display Options
		SQLDateSuppress = "SELECT OptionValue AS DateSuppress FROM EventOptions (NOLOCK) WHERE EventCode = " & rsOrderLine("EventCode") & " AND OptionName = 'DateSuppress' AND OptionValue = 'Y'"
		Set rsDateSuppress = OBJdbConnection.Execute(SQLDateSuppress)
		If rsDateSuppress.EOF Then
			EMailMessage = EMailMessage & " on " & FormatDateTime(rsOrderLine("EventDate"),vbShortDate)
		End If
		rsDateSuppress.Close
		Set rsDateSuppress = nothing

		SQLTimeSuppress = "SELECT OptionValue AS TimeSuppress FROM EventOptions (NOLOCK) WHERE EventCode = " & rsOrderLine("EventCode") & " AND OptionName = 'TimeSuppress' AND OptionValue = 'Y'"
		Set rsTimeSuppress = OBJdbConnection.Execute(SQLTimeSuppress)
		If rsTimeSuppress.EOF Then
			EMailMessage = EMailMessage & " at " & Left(FormatDateTime(rsOrderLine("EventDate"),vbLongTime),Len(FormatDateTime(rsOrderLine("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsOrderLine("EventDate"),vbLongTime),3)
		End If
		rsTimeSuppress.Close
		Set rsTimeSuppress = nothing

		EMailMessage = EMailMessage & "</B><BR>Delivery Method: " & rsOrderLine("ShipType") & "</TD></TR>" & vbCrLf
		EMailMessage = EMailMessage & "</TABLE>" & vbCrLf
		
		EMailMessage = EMailMessage & "<BR>" & vbCrLf
		
		'-----------------------------------------
				
			'Child Events
			
			If SHOWCHILD Then
			
				ChildEvents = ""

				SQLEventChild = "SELECT SubscriptionEvent.EventCode, Event.EventDate, Act.Act FROM SubscriptionEvent (NOLOCK) INNER JOIN Event (NOLOCK) ON SubscriptionEvent.EventCode = Event.EventCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode WHERE SubscriptionEvent.SubscriptionNumber = " & rsOrderLine("EventCode") & ""
				Set rsEventChild = OBJdbConnection.Execute(SQLEventChild)
				
				If Not rsEventChild.EOF Then
					
					linecount = 1

					ChildEvents = ChildEvents & "<TABLE WIDTH=""650"" cellpadding=""0"" cellspacing=""0"" border=""0"">" & vbCrLf
					ChildEvents = ChildEvents & "<TR>" & vbCrLf
					ChildEvents = ChildEvents & "<TD colspan=""2"">" & vbCrLf
					ChildEvents = ChildEvents & "<FONT FACE=" & MsgFontFace & "><B>This subscription includes:</B></FONT>" & vbCrLf
					ChildEvents = ChildEvents & "</td>" & vbCrLf
					ChildEvents = ChildEvents & "</tr>" & vbCrLf
				
						Do While Not rsEventChild.EOF

							ChildEvents = ChildEvents & "<tr>" & vbCrLf	
							ChildEvents = ChildEvents & "<td WIDTH=""60%"">" & vbCrLf
							ChildEvents = ChildEvents & "<FONT FACE=" & MsgFontFace & ">" & rsEventChild("Act") & "</FONT>" & vbCrLf	
							ChildEvents = ChildEvents & "</td>" & vbCrLf	
							ChildEvents = ChildEvents & "<td WIDTH=""40%"" NOWRAP>" & vbCrLf
							ChildEvents = ChildEvents & "<FONT FACE=" & MsgFontFace & ">" & FormatDateTime(rsEventChild("EventDate"), vbLongDate) & " at " & Left(FormatDateTime(rsEventChild("EventDate"),vbLongTime),Len(FormatDateTime(rsEventChild("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsEventChild("EventDate"),vbLongTime),3) & "</FONT>" & vbCrLf
							ChildEvents = ChildEvents & "</td>" & vbCrLf
							ChildEvents = ChildEvents & "</tr>" & vbCrLf
								
						rsEventChild.movenext
						Loop
						
					ChildEvents = ChildEvents & "</TABLE>" & vbCrLf

				Else
			
					ChildEvents = ChildEvents & " " & vbCrLf
				
				End If
					
				rsEventChild.Close
				Set rsEventChild = nothing

				ChildEvents = ChildEvents & "<BR>" & vbCrLf
				
				EMailMessage = EMailMessage & ChildEvents
			
			End If
		
		'-----------------------------------------
		
		'Seat Location, Price, Service Fee

		'Calculate Number of Columns
		SQLNumColumns = "SELECT SUM(OrderLine.Surcharge) AS ServiceFee, SUM(OrderLine.Discount) AS Discount FROM OrderLine WHERE OrderNumber = " & rsOrderLine("OrderNumber") & " AND ItemType IN ('Seat', 'SubFixedEvent')"
		Set rsNumColumns = OBJdbConnection.Execute(SQLNumColumns)

		NumColumns = 6
		
		ColumnHeading = "<TABLE WIDTH=""650"" cellpadding=""0"" cellspacing=""0"" border=""0""> <TR><TD><FONT FACE=" & MsgFontFace & "><B><U>Section</U></B></FONT></TD><TD ALIGN=center><FONT FACE=" & MsgFontFace & "><B><U>Row</U></B></FONT></TD><TD ALIGN=center><FONT FACE=" & MsgFontFace & "><B><U>Seat</U></B></FONT></TD><TD><FONT FACE=" & MsgFontFace & "><B><U>Type</U></B></FONT></TD><TD ALIGN=right><FONT FACE=" & MsgFontFace & "><B><U>Price</U></B></FONT></TD>"
		
		FacilityCharge = 0
		If FacilityCharge <> 0 Then
			NumColumns = NumColumns + 1
			ColumnHeading = ColumnHeading + "<TD ALIGN=right><FONT FACE=" & MsgFontFace & "><B><U>Facility Charge</U></B></FONT></TD>"
			ColFacilityCharge = "Y"
		End If
		
		If rsNumColumns("ServiceFee") <> 0 Then
			NumColumns = NumColumns + 1
			ColumnHeading = ColumnHeading + "<TD ALIGN=right><FONT FACE=" & MsgFontFace & "><B><U>Service Fee</U></B></FONT></TD>"
			ColServiceFee = "Y"
		End If
		
		If rsNumColumns("Discount") <> 0 Then
			NumColumns = NumColumns + 1
			ColumnHeading = ColumnHeading + "<TD ALIGN=right><FONT FACE=" & MsgFontFace & "><B><U>Discount</U></B></FONT></TD>"
			ColDiscount = "Y"
		End If

		rsNumColumns.Close
		Set rsNumColumns = nothing

		ColumnHeading = ColumnHeading + "<TD ALIGN=right><FONT FACE=" & MsgFontFace & "><B><U>Amount</U></B></FONT></TD></TR>" & vbCrLf
		
		EMailMessage = EMailMessage & ColumnHeading

		LastEventCode = rsOrderLine("EventCode")
		
		'-----------------------------------------
		
	End If
	
	'-----------------------------------------
		
	'Facility Charge, Surcharge, Discount, Price
	
	LineDetail = "<TR><TD><FONT FACE=" & MsgFontFace & ">" & rsOrderLine("Section") & "</FONT></TD><TD ALIGN=center><FONT FACE=" & MsgFontFace & ">" & rsOrderLine("Row") & "</FONT></TD><TD ALIGN=center><FONT FACE=" & MsgFontFace & ">" & rsOrderLine("Seat") & "</FONT></TD><TD><FONT FACE=" & MsgFontFace & ">" & rsOrderLine("SeatType") & "</FONT></TD><TD ALIGN=right><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(rsOrderLine("Price"),2) & "</FONT></TD>"
	
	If ColFacilityCharge = "Y" Then
		LineDetail = LineDetail & "<TD ALIGN=right><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(FacilityCharge,2) & "</FONT></TD>"
	End If
	If ColServiceFee = "Y" Then
		LineDetail = LineDetail & "<TD ALIGN=right><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(rsOrderLine("Surcharge"),2) & "</FONT></TD>"
	End If
	If ColDiscount = "Y" Then
		LineDetail = LineDetail & "<TD ALIGN=right><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(rsOrderLine("Discount"),2) & "</FONT></TD>"
	End If
	
	LineDetail = LineDetail & "<TD ALIGN=right><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(rsOrderLine("Price")+FacilityFee+rsOrderLine("Surcharge")-rsOrderLine("Discount"),2) & "</FONT></TD></TR>" & vbCrLf
	
	EMailMessage = EMailMessage & LineDetail

	LastOrderNumber = rsOrderLine("OrderNumber")
	
	'-----------------------------------------
	
rsOrderLine.MoveNext	
Loop	
	
If TicketCount > 0 Then	'Print the last footer

	EMailMessage = EMailMessage & "</TABLE>" & vbCrLf
	EMailMessage = EMailMessage & "</CENTER><BR>" & vbCrLf
	EMailMessage = EMailMessage & EMailMessageBody
	
	If TestEMailAddress = "" Then
	
			EMailMessage = EMailMessage & "<TR><TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf			
			
			If LastShipFee <> 0 And LastOrderTypeNumber <> 5 Then
				EMailMessage = EMailMessage & "<TR><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=" & MsgFontFace & ">Processing Fee</TD><TD ALIGN=""right""><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(LastShipFee,2) & "</TD></TR>" & vbCrLf
				EMailMessage = EMailMessage & "<TR><TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf
			End If

			SQLTender = "SELECT SUM(Tender.Amount) AS TenderAmount FROM Tender (NOLOCK) WHERE Tender.OrderNumber = " & LastOrderNumber
			Set rsTender = OBJdbConnection.Execute(SQLTender)
				If IsNull(rsTender("TenderAmount")) Then
					LastTender = 0
				Else
					LastTender = rsTender("TenderAmount")
					Response.Write SQLTender & "<BR>"
				End If
			rsTender.Close
			Set rsTender = nothing	

			EMailMessage = EMailMessage & "<TR><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=" & MsgFontFace & ">Order Total</TD><TD ALIGN=""right""><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(LastTotal,2) & "</TD></TR>" & vbCrLf
			
			If LastTender <> 0 Then
				EMailMessage = EMailMessage & "<TR><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=" & MsgFontFace & ">Less Payments</TD><TD ALIGN=""right""><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(LastTender,2) & "</TD></TR>" & vbCrLf
				EMailMessage = EMailMessage & "<TR><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=" & MsgFontFace & ">Balance Due</TD><TD ALIGN=""right""><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(LastTotal - LastTender,2) & "</TD></TR>" & vbCrLf
			End If
						
			EMailMessage = EMailMessage & "</TABLE><BR>" & vbCrLf
			
			'-----------------------------------------
			
			'Footer Info
			'Insert HTML Template - Footer Content
									
			EMailMessage = EMailMessage & "<TABLE WIDTH=""650"" cellpadding=""0"" cellspacing=""0"" border=""0"">" & vbCrLf
			EMailMessage = EMailMessage & "<TR>" & vbCrLf
			EMailMessage = EMailMessage & "<TD valign=top>" & vbCrLf
			EMailMessage = EMailMessage & "<FONT FACE=" & MsgFontFace & "><BR>" & vbCrLf

			'Insert HTML Template - Body Content
			EMailMessage = EMailMessage & InsertTemplate("Footer") 

			EMailMessage = EMailMessage & "</FONT>" & vbCrLf
			EMailMessage = EMailMessage & "</TD>" & vbCrLf
			EMailMessage = EMailMessage & "</TR>" & vbCrLf
			EMailMessage = EMailMessage & "</TABLE>" & vbCrLf
			EMailMessage = EMailMessage & "<BR>" & vbCrLf
			
			'-----------------------------------------

			EMailMessage = EMailMessage & "</CENTER>" & vbCrLf

		'JAI 3/2/5 - Modified to use CDO Mail
		'Create the e-mail server object
		Set objCDOSYSMail = Server.CreateObject("CDO.Message")
		Set objCDOSYSCon = Server.CreateObject ("CDO.Configuration")

		objCDOSYSCon.Fields(cdoSendUsingMethod) = cdoSendUsingPickup 'For localhost
		objCDOSYSCon.Fields.Update

		'Update the CDOSYS Configuration
		Set objCDOSYSMail.Configuration = objCDOSYSCon
		objCDOSYSMail.From = OrganizationName & " <" & EMailReplyTo & ">" 
		objCDOSYSMail.ReplyTo = EMailReplyTo
		objCDOSYSMail.To = LastEMailAddress
		objCDOSYSMail.BCC = ""
		objCDOSYSMail.Subject = EMailSubject
		objCDOSYSMail.HTMLBody = EMailMessage
		objCDOSYSMail.Send

		'Close the server mail object
		Set objCDOSYSMail = Nothing
		Set objCDOSYSCon = Nothing 

		Response.Write LastOrderNumber & " | " & LastEmailAddress & "<BR>" & vbCrLf
		OrderCount = OrderCount + 1

	End If
	
	EMailMessage = ""

End If

Response.Write "Order Count: " & OrderCount & "<BR>"

rsOrderLine.Close
Set rsOrderLine = nothing

%>

</body>
</html>

<%

End Sub 'PrintLetters



'-------------------------------------------------

PUBLIC FUNCTION  PCase(str) 

strOut = "" 
boolUp = True 	
aLen =  Len(str)  

If len(aLen) > 0 Then 

	For i = 1 To Len(str) 

		c = Mid(str, i, 1)

		If c = " " or c = "'" or c = "-"  then 
			strOut = strOut & c 
			boolUp = True 
		Else 
			If boolUp Then 
				tc = Ucase(c) 
			Else 
				tc = LCase(c) 
			End If 
			strOut = strOut & tc 
			boolUp = False 
		End If 

	Next 

End If

PCase = strOut 

END FUNCTION

'-------------------------------------------------

PUBLIC FUNCTION GetPrivateLabel(OrgNumbr)

	DIM strTemp

	SQLVenueRefCheck = "SELECT VenueCode, OptionName, OptionValue FROM VenueOptions WITH (NOLOCK) WHERE VenueCode = (SELECT VenueCode FROM VenueOptions (NOLOCK) WHERE OptionName = 'OrganizationNumber' AND OptionValue = '" & OrgNumbr & "') AND (OptionName = 'VenueReference')"
	Set rsVenueRefCheck = OBJdbConnection.Execute(SQLVenueRefCheck)
		strTemp = rsVenueRefCheck("OptionValue")
	rsVenueRefCheck.Close
	Set rsVenueRefCheck = nothing
	
	GetPrivateLabel = strTemp

	
END FUNCTION
	
'-------------------------------------------------

PUBLIC FUNCTION CheckTixUser(UserNumber)

Dim strResult
strResult = FALSE

SQLOrgUsers = "Select UserNumber FROM Users (NOLOCK) WHERE OrganizationNumber = 1 AND UserNumber = " & Session("UserNumber") & ""
Set rsOrgUsers = OBJdbConnection.Execute(SQLOrgUsers)

	If NOT rsOrgUsers.EOF Then
		strResult = TRUE
	End If
	
rsOrgUsers.Close
Set rsOrgUsers = Nothing

CheckTixUser = strResult

END FUNCTION

'-------------------------------------------------

PUBLIC FUNCTION InsertTemplate(templateName)

Dim  strText
strText = ""

Dim strNewText
strNewText = ""

	Const ForReading = 1

	Set objFSO = CreateObject("Scripting.FileSystemObject")
	
	If objFSO.FileExists(TemplateFilePath) Then

		Set objFile = objFSO.OpenTextFile(TemplateFilePath, ForReading)

		strContents = objFile.ReadAll
		objFile.Close

		strStartText = "[" & templatename & "]"
		strEndText = "[/" & templatename & "]"

		intStart = InStr(strContents, strStartText)
		intStart = intStart + Len(strStartText)

		intEnd = InStr(strContents, strEndText)

		intCharacters = intEnd - intStart

		strText = Mid(strContents, intStart, intCharacters)
		
		'Replace
		strNewText = replaceVar(strText)
		
		'Clean
		strNewText = cleanBOM(strNewText)

	Else
	
		strNewText = "Sorry! Template File Not Found"
	
	End If
	
	InsertTemplate = strNewText
			
END FUNCTION

'-------------------------------------------------

PUBLIC FUNCTION cleanBOM(strText)

	'remove BOM if present http://unicode.org/faq/utf_bom.html

	If (Len(Trim(strText)) > 0) Then
	
		Dim AscValue : AscValue = Asc(Trim(strText))
	  
		If ((AscValue = -15441) Or (AscValue = 239)) Then : strText = Mid(Trim(strText),4) : End If
	  
	End If
	
	cleanBOM = strText
	
END FUNCTION 

'-------------------------------------------------

PUBLIC FUNCTION replaceVar(strText)

		'replace placeholders with actual text

		DIM strNewText
		
		strNewText = Replace(strText, 	 "[ShipFirstName]", ShipFirstName)
		strNewText = Replace(strText, 	 "[FirstName]", CustomerFName)
		strNewText = Replace(strNewText, "[webSite]", webSite)
		strNewText = Replace(strNewText, "[orgNumber]", orgNumber)
		strNewText = Replace(strNewText, "[senderFName]", senderFName)
		strNewText = Replace(strNewText, "[senderLName]", senderLName)
		strNewText = Replace(strNewText, "[senderAddress]", senderAddress)
		strNewText = Replace(strNewText, "[OrgName]", fnOrgName)
		strNewText = Replace(strNewText, "[RenewalURL]", RenewalURL)
		strNewText = Replace(strNewText, "[RenewalFirstName]", RenewalFirstName)
		strNewText = Replace(strNewText, "[ServerName]",Request.ServerVariables("server_name"))
		strNewText = Replace(strNewText, "[EasyRenewalURL]", EasyRenewalURL)

		replaceVar = strNewText
		
END FUNCTION 

'--------------------------------------------------------------------

PUBLIC FUNCTION fnOrgName(OrgNumber)

DIM strResults

If OrgNumber = "" Then
OrgNumber = Session("OrganizationNumber")
End If

SQLSearch = "Select  Organization  FROM Organization (NOLOCK) WHERE OrganizationNumber = " &  OrgNumber & ""
Set rsSearch = OBJdbConnection.Execute(SQLSearch)
	strResults = rsSearch("Organization") 
rsSearch.Close
Set rsSearch = Nothing

fnOrgName = strResults

END FUNCTION

'-------------------------------------------------

PUBLIC FUNCTION fnCheckTixUser

	Dim strResult
	strResult = FALSE

	SQLOrgUsers = "Select UserNumber FROM Users (NOLOCK) WHERE OrganizationNumber = 1 AND UserNumber = " & Session("UserNumber") & ""
	Set rsOrgUsers = OBJdbConnection.Execute(SQLOrgUsers)

		If NOT rsOrgUsers.EOF Then
			strResult = TRUE
		End If
		
	rsOrgUsers.Close
	Set rsOrgUsers = Nothing

	fnCheckTixUser = strResult

END FUNCTION

'-------------------------------------------------

PUBLIC FUNCTION fnUserEmailList(OrgNumbr)

	'Populates a drop down list with the organizations user emails
	
	DIM strResults
	
	ServerName = Request.ServerVariables ("SERVER_NAME") 

	If ServerName <> "localhost" Then
	
		SQLOrgUsers = "SELECT UserNumber, FirstName, LastName, EMailAddress, Status FROM Users (NOLOCK) WHERE OrganizationNumber = " &  OrgNumbr & " AND Status = 'A' AND USERS.EMailAddress is not null and len(USERS.EMailAddress) > 1"
		Set rsOrgUsers = OBJdbConnection.Execute(SQLOrgUsers)

			If Not rsOrgUsers.EOF Then 

				strResults = strResults & "<option  class=""group-head"" disabled> " & fnOrgName(OrgNumbr) & " -  " & OrgNumbr & "</option>"
			
				Do Until rsOrgUsers.EOF
								
					strResults = strResults & "<option value="" " & rsOrgUsers("FirstName") & "|" & rsOrgUsers("LastName") & "|" & rsOrgUsers("EMailAddress") & " "" " & selected & ">" & rsOrgUsers("FirstName") & "&nbsp;" & rsOrgUsers("LastName") & "&nbsp;(" & rsOrgUsers("EMailAddress") & ")</option>"							

				rsOrgUsers.MoveNext
				Loop
				
			End If	

		rsOrgUsers.Close
		Set rsOrgUsers = Nothing

	Else
	
		Select Case OrgNumber
		Case 1
			strResults  ="<option value=""sergio.rodriguez@tix.com"" selected=""selected"" >Sergio&nbsp;Rodriguez&nbsp;(sergio.rodriguez@tix.com)</option>,<option value=""silvia.mahoney@tix.com"">Silvia&nbsp;Mahoney&nbsp;(silvia.mahoney@tix.com)</option>"													
		Case Else
			strResults = "<option value=""sergio.rodriguez.delao@gmail.com "" selected=""selected"">Sergio&nbsp;Rodriguez&nbsp;(sergio.rodriguez.delao@gmail.com)</option>,<option value=""silvia.mahoeny@gmail.com"">Silvia&nbsp;Mahoney&nbsp;(silvia.mahoney@gmail.com)</option>"							
		End Select		
	
	End If

	fnUserEmailList = strResults

END FUNCTION

'-------------------------------------------------

%>