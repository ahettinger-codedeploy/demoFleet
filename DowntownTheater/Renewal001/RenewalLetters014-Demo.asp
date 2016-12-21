<% 

'CHANGE LOG


%><!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp"-->
<%

'-----------------------------------

ServerName = Request.ServerVariables ("SERVER_NAME") 

If ServerName <> "localhost" Then

                'REE 4/15/2 - Increased Session Timeout to 30 minutes to reduce Print validation timeout issues.
                Session.Timeout = 60
                Server.ScriptTimeout = 3600

                Page = "Management"

                'Verify OrganizationNumber
                If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then 
                                OBJdbConnection.Close
                                Set OBJdbConnection = nothing
                                Response.Redirect("/Management/Default.asp")
                End If


                'Verify User
                If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then 
                                OBJdbConnection.Close
                                Set OBJdbConnection = nothing
                                Response.Redirect("/Management/Default.asp")
                End If
                
                Call WorkFlow
                
                OBJdbConnection.Close
                Set OBJdbConnection = nothing
                
Else

                Call WorkFlow

End If

'-----------------------------------------------

Sub WorkFlow

                Select Case Request("FormName")

                                Case "Display"
                                                Call Display          
                                                
                                Case Else
                                                Call Display
                                                
                End Select
                
End Sub

'-----------------------------------------------

Sub Display

%>
<!DOCTYPE html>

<HTML lang="en">
<HEAD>
  <META name="generator" content="HTML Tidy for HTML5 (experimental) for Windows https://github.com/w3c/tidy-html5/tree/c63cc39">

  <TITLE>Support Dashboard</TITLE><!-- Force IE to turn off past version compatibility mode and use current version mode -->
  <META http-equiv="X-UA-Compatible" content="IE=edge;chrome=1"><!-- Get the width of the users display-->
  <META name="viewport" content="width=device-width, initial-scale=1.0"><!-- Text encoded as UTF-8 -->
  <META http-equiv="Content-Type" content="text/html; charset=utf-8">
  
   <link href='https://fonts.googleapis.com/css?family=Droid+Sans:400,700' rel="stylesheet" type="text/css">
  
  <!--<LINK href='http://fonts.googleapis.com/css?family=Lato:400,700,900,400italic' rel="stylesheet" type="text/css">-->
  
  <link href="https://netdna.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css" rel="stylesheet" type="text/css">
  
  <link href="https://netdna.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" rel="stylesheet" type="text/css">
  
  <link href="http://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.6.3/css/bootstrap-select.css" rel="stylesheet" type="text/css" >
  
<STYLE>

/* global styles */ 

.TixManagementContent 
{
font-family: 'Open Sans', sans-serif !important;
text-align: left !important;
min-height: 600px !important;
background-color: #fbfbfb !important;
padding: 5px !important;
}

/* links: remove all outlines and underscores */ 

a.btn:focus, 
a.btn:active:focus, 
a.btn.active:focus,

.btn:focus, 
.btn:active:focus, 
.btn.active:focus,

.nav > li > a,
.nav > li > a.active,
.nav > li > a.focus,
.nav > li > a.hover,

ul.dropdown-menu li a,
ul.dropdown-menu li a.active,
ul.dropdown-menu li a.focus,
ul.dropdown-menu li a.hover,

ul.nav-tabs li a,
ul.nav-tabs li a.active,
ul.nav-tabs li a.focus { outline:0px !important; -webkit-appearance:none; text-decoration:none; color: #666666; }  

/* remove blue glow  */ 
 
.form-control 
{
box-shadow: none;
outline: none;
transition: border-color 0.15s ease-in-out 0s;
}

.form-control:focus 
{
box-shadow: none;
outline: none;
}
 
/* toggle switch */ 

.switch { border-radius: 3px; margin-bottom: 5px; width: 103px; height: 32px; position: relative; display: inline-block; vertical-align: top;  cursor: pointer; box-sizing: content-box; overflow: hidden; }

.switch-input { position: absolute; top: 0px; left: 0px; opacity: 0;}

.switch-handle { border-radius: 2px; background-color: #eeeeee;  width: 30px; height: 28px; position: absolute; top: 2px; left: 3px; transition: left 0.45s ease-out 0s; }

.switch-label { border-radius: 3px; background-color: #cccccc;  margin: 0; position: relative; display: block; height: inherit; font-size: 15px; text-transform: uppercase; transition: all 0.15s ease-out 0s; }

.switch-label:before, 
.switch-label:after {  position: absolute; top: 50%; margin-top: -0.5em; line-height: 1; transition: inherit; }

/* toggle off - show text off */
.switch-label:before { content: attr(data-off); right: 11px; color: #dddddd; }

/* toggle off - hide text on */
.switch-input:checked ~ .switch-label:after {  opacity: 1; }

/* toggle on  - show text on */
.switch-label:after { content: attr(data-on); left: 11px; color: #ffffff; opacity: 0; }

/* toggle on - hide text off */
.switch-input:checked ~ .switch-label:before { opacity: 0; }


/* toggle background on */
.switch-input:checked ~ .switch-label { background-color: transparent; }

/* toggle square on */
.switch-input:checked ~ .switch-handle { left: 70px; background-color: #ffffff;}



/* panel header, panel title, panel navbar, panel tabs, panel button */ 

div.panel div.panel-heading,
div.panel div.panel-heading div.panel-title,
div.panel div.panel-heading div.panel-title .nav-btn,
div.panel div.panel-heading div.panel-title .nav-tabs,
div.panel div.panel-heading div.panel-title .navbar,
div.panel div.panel-heading div.panel-title .navbar .navbar-header
{ padding: 0; margin: 0; border: 0; min-height: 50px !important; max-height: 50px !important;}

/* panel header */ 

div.panel div.panel-heading { border-bottom:1px solid #dddddd; }

/* panel tabs */

div.panel div.panel-heading div.panel-title nav.navbar div.pull-left ul.nav.nav-tabs li a { min-height: 47px !important; max-height: 47px !important;  min-width: 115px; margin-top: 3px; font-size: 14px; background-color: #eeeeee; color: #333333;}

.nav-tabs > li > a { background-color: red; outline: blue;}




/* panel button */

div.panel div.panel-heading div.panel-title .nav-btn .btn { height: 49px; border: 0; background-color: #f5f5f5; }

/* panel labels */

div.panel .icon-label { margin-left: 5px; }


/* hide-show panels */ 

div#panel-parent.panel
{
position: relative;
min-height: 450px;
}

 #panel-parent.panel  #panel-edit.panel-body
{       
position: absolute;
z-index: 20;
overflow: hidden;
width: 100%;
padding: 0px .5px 20px .5px;
}

 #panel-parent.panel  #panel-edit.panel-body  #panel-edit-inner 
{
background-color: white;
margin-top: -450px;
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
 
div#panel-parent.panel div#panel-display.panel-body
{       
background-color: #ffffff;
position: absolute;
z-index: 10;
width: 100%;
opacity: 0;
}


#panel-edit-inner.container-fluid.effect1 div.well.panel-well
{
background-color: #F5F5F5;
min-height: 280px;
box-shadow: 0;
padding: 10px;
margin: 0px;
}

 
ul.nav.nav-pills.nav-stacked li
{
background-color: #fdfdfd;
box-shadow: 0;
}

ul.nav.nav-pills.nav-stacked li.label-primary a
{
border: 1px solid #dddddd;
box-shadow: 0;
}

.tab-pane > .panel
{
padding: 0px;
margin: 0px;
}

.tab-pane > .panel > .panel-header 
{
background-color: #fff;
border-bottom: 1px solid #e5e5e5;
padding: 15px;
text-align: left;
border-top-left-radius: 6px;
border-top-right-radius: 6px;
}

.tab-pane > .panel > .panel-header > .panel-title
{
line-height: 1.42857;
margin: 0;
font-size: 18px;
font-weight: 500;
}

 
.tab-pane > .panel > .panel-footer
{
background-color: #fff;
border-top: 1px solid #e5e5e5;
padding: 15px;
text-align: right;
}


#email-test.email-control.disabled, 
#email-test.email-control[disabled],
#email-submit.email-control.disabled, 
#email-submit.email-control[disabled]
{
display: none;
visibility: hidden;
}
 

/*
  Common Select CSS Properties
  ---------------------
  These properties will be applied to any themes that you use
*/

/* SelectBoxIt container */

.selectboxit-container 
{
position: relative;
display: inline-block;
vertical-align: top;
}

/* Styles that apply to all SelectBoxIt elements */

.selectboxit-container * 
{
/* Prevents text selection */
-webkit-touch-callout: none;
-webkit-user-select: none;
-khtml-user-select: none;
-moz-user-select: -moz-none;
-ms-user-select: none;
-o-user-select: none;
user-select: none;
outline: none;
white-space: nowrap;
}

/* Button */

.selectboxit-container .selectboxit
{
width: 220px; /* Width of the dropdown button */
cursor: pointer;
margin: 0;
padding: 0;
border-radius: 6px;
overflow: hidden;
display: block;
position: relative;
}

/* Height and Vertical Alignment of Text */

.selectboxit-container span, .selectboxit-container .selectboxit-options a 
{
height: 34px; /* Height of the drop down */
line-height: 20px; /* Vertically positions the drop down text */
display: block;
}

/* Focus pseudo selector */

.selectboxit-container .selectboxit:focus 
{
outline: 0;
}

/* Disabled Mouse Interaction */
.selectboxit.selectboxit-disabled, .selectboxit-options .selectboxit-disabled 
{
  opacity: 0.65;
  filter: alpha(opacity=65);
  -webkit-box-shadow: none;
  -moz-box-shadow: none;
  box-shadow: none;
  cursor: default;
}

/* Button Text */
.selectboxit-text 
{
  text-indent: 5px;
  overflow: hidden;
  text-overflow: ellipsis;
  float: left;
}

.selectboxit .selectboxit-option-icon-container 
{
  margin-left: 5px;
}

/* Options List */
.selectboxit-container .selectboxit-options 
{
-moz-box-sizing: border-box;
box-sizing: border-box;
min-width: 100%;  /* Minimum Width of the dropdown list box options */
*width: 100%;
margin: 0;
padding: 0;
list-style: none;
position: absolute;
overflow-x: hidden;
overflow-y: auto;
cursor: pointer;
display: none;
z-index: 9999999999999;
border-radius: 6px;
text-align: left;
-webkit-box-shadow: none;
-moz-box-shadow: none;
box-shadow: none;
}

/* Individual options */
.selectboxit-option .selectboxit-option-anchor{
padding: 0 2px;
}

/* Individual Option Hover Action */
.selectboxit-option .selectboxit-option-anchor:hover 
{
text-decoration: none;
}

/* Individual Option Optgroup Header */
.selectboxit-option, .selectboxit-optgroup-header 
{
text-indent: 5px; /* Horizontal Positioning of the select box option text */
margin: 0;
list-style-type: none;
}

/* The first Drop Down option */
.selectboxit-option-first 
{
border-top-right-radius: 6px;
border-top-left-radius: 6px;
}

/* The first Drop Down option optgroup */
.selectboxit-optgroup-header + .selectboxit-option-first 
{
border-top-right-radius: 0px;
border-top-left-radius: 0px;
}

/* The last Drop Down option */
.selectboxit-option-last 
{
border-bottom-right-radius: 6px;
border-bottom-left-radius: 6px;
}

/* Drop Down optgroup headers */
.selectboxit-optgroup-header 
{
font-weight: bold;
}

/* Drop Down optgroup header hover psuedo class */
.selectboxit-optgroup-header:hover 
{
cursor: default;
}

/* Drop Down down arrow container */
.selectboxit-arrow-container 
{
/* Positions the down arrow */
width: 30px;
position: absolute;
right: 0;
}

/* Drop Down down arrow */
.selectboxit .selectboxit-arrow-container .selectboxit-arrow 
{
/* Horizontally centers the down arrow */
margin: 0 auto;
position: absolute;
top: 50%;
right: 0;
left: 0;
}

/* Drop Down down arrow for jQueryUI and jQuery Mobile */
.selectboxit .selectboxit-arrow-container .selectboxit-arrow.ui-icon 
{
top: 30%;
}

/* Drop Down individual option icon positioning */
.selectboxit-option-icon-container 
{
float: left;
}

.selectboxit-container .selectboxit-option-icon 
{
margin: 0;
padding: 0;
vertical-align: middle;
}

/* Drop Down individual option icon positioning */
.selectboxit-option-icon-url 
{
width: 18px;
background-size: 18px 18px;
background-repeat: no-repeat;
height: 100%;
background-position: center;
float: left;
}

.selectboxit-rendering 
{
display: inline-block !important;
*display: inline !important;
zoom: 1 !important;
visibility: visible !important;
position: absolute !important;
top: -9999px !important;
left: -9999px !important;
}


/* SelectBoxIt theme */

.selectboxit-container * { font: 13px "open sans",Helvetica,Arial; -moz-user-select: none; outline: 0px none; white-space: nowrap; z-index: 1000;}
.selectboxit-container { position: relative; display: block; vertical-align: top; }
.selectboxit-container .selectboxit { width: 100% ! important; cursor: pointer; margin: 0px; height: 34px; padding: 6px 12px; border-radius: 3px; overflow: hidden; display: block; position: relative; }
.selectboxit-container span, .selectboxit-container .selectboxit-options a { display: block; }
.selectboxit-container .selectboxit:focus { outline: 0px none; }

.selectboxit-text { overflow: hidden; text-overflow: ellipsis; display: block; max-width: 100% ! important; }

.selectboxit-option .selectboxit-option-anchor { margin: 0px; height: 34px; padding: 6px 12px; text-decoration: none; }
.selectboxit-option .selectboxit-option-anchor:hover { text-decoration: none; }
.selectboxit-option,.selectboxit-optgroup-header { position: relative; text-indent: 5px; margin: 0px; list-style-type: none; }

.selectboxit-option-first { border-top-right-radius: 3px; border-top-left-radius: 3px; }
.selectboxit-option-last { border-bottom-right-radius: 3px; border-bottom-left-radius: 3px; }
.selectboxit-option-icon-container { float: left; }
.selectboxit-option-icon-container { margin-left: 5px; }

.selectboxit-options {width: 100% ! important; max-height: 300px ! important;  margin: 0px;  padding: 4px; list-style: outside none none; position: absolute; overflow-x: hidden; overflow-y: auto; cursor: pointer; display: none; z-index: 9998; text-align: left; border-radius: 3px; box-shadow: none; }
.selectboxit-options:not(.selectboxit-above) { border-top-right-radius: 0px; border-top-left-radius: 0px; }

.selectboxit .selectboxit-arrow-container .selectboxit-arrow { margin: 0px auto; position: absolute; top: 8px; right: 10px; left: 0px; }

.selectboxit-btn.selectboxit-focus.selectboxit-open .selectboxit-default-arrow:before {transform: rotate(-180deg);}
.selectboxit-btn.selectboxit-enabled:hover, 
.selectboxit-btn.selectboxit-enabled:focus { text-decoration: none; }

.selectboxit-option-icon.fa { display: inline-block; font-family: FontAwesome; font-size: 16px; background-image: none ! important; }
.selectboxit-option-icon.glyphicon { display: inline-block; font-family: "Glyphicons Halflings"; font-size: 16px; background-image: none ! important; margin-top: 12px; }
.selectboxit-option-icon-url { position: absolute; top: 0px; right: 42px; width: 18px; background-size: 18px 18px; background-repeat: no-repeat; height: 100%; background-position: center center; float: left; }
.selectboxit-option-icon { margin: 0px; padding: 0px; position: absolute; right: 42px; width: 20px; text-align: center; }

.selectboxit-default-arrow { width: 0px; }
.selectboxit-default-arrow:before { display: inline-block; font-family: FontAwesome; content: "\f107"; transition: all 0.3s ease 0s; }


/* SelectBoxIt theme color */

.selectboxit-btn { border: 1px solid rgb(194, 208, 222); background-color: rgb(255, 255, 255); transition: all 0.45s ease 0s; }

.selectboxit-list { background-color: rgb(255, 255, 255);   border: 1px solid #428BCA; box-shadow: none; margin-top: 4px; }
.selectboxit-list .selectboxit-option-anchor { color: rgb(57, 66, 100); font-size: 13px;  }
.selectboxit-list > .selectboxit-focus > .selectboxit-option-anchor { background-color: #428BCA; color: #FFFFFF; transition: all 0.45s ease 0s;}

.selectboxit-btn.selectboxit-enabled:hover, 
.selectboxit-btn.selectboxit-enabled:focus, 
.selectboxit-btn.selectboxit-enabled:active,
.selectboxit.form-control,
.selectboxit.form-control:focus
{ 
background-color: #EEEEEE; 
border: 1px solid #CCCCCC; 
color: #EEEEEE; 
opacity: 1; 
transition: all 0.45s ease 0s; 
box-shadow: none;
}

.selectboxit-arrow-container 
{
background-color: #CCCCCC;
width: 34px; 
height: 34px; 
position: absolute; 
opacity: 1;
top: 0px; 
right: 0px; 
color: #EEEEEE;
}

.selectboxit.form-control[disabled],
.selectboxit.form-control:focus[disabled],
.selectboxit.form-control:focus.disabled
{ background-color: #ffffff;  border: 1px solid #428BCA; color: rgb(57, 66, 100); opacity: 1; transition: all 0.45s ease 0s; box-shadow: none;}


.selectboxit.form-control[disabled] > .selectboxit-arrow-container
{ 
background-color: #428BCA;
 
width: 34px; 
height: 34px; 
position: absolute; 
opacity: 1;
top: 0px; 
right: 0px; 
color: #ffffff;
}

</style>

</HEAD>

<BODY class="bootstrap">
  <DIV class="container">
    <!--#INCLUDE VIRTUAL="TopNavInclude.asp" -->

    <DIV class="panel panel-default" id="panel-parent">
      <DIV class="panel-heading" id="panel-header">
	  
        <DIV class="panel-title">
          <NAV class="navbar" role="navigation">
            <DIV class="navbar-header">
              <SPAN class="navbar-brand">Renewal Letters</SPAN>
            </DIV>

            <DIV class="pull-left">
				<ul class="nav nav-tabs">
                <li class="active">
                  <a href="#letters" data-toggle="tab">
				  <i class="glyphicon glyphicon-print"></i>
				  <span class="icon-label">Letters</span>
				  </a>
                </li>

                <li>
                  <a href="#emails" data-toggle="tab">
				  <i class="glyphicon glyphicon-send"></i>
				  <span class="icon-label">Emails</span>
				  </a>
                </li>

                <li>
                  <a href="#loglist" data-toggle="tab">
				  <i class="glyphicon glyphicon-list"></i>
				  <span class="icon-label">Logs</span>
				  </a>
                </li>
              </ul>
            </DIV>

            <DIV class="nav-btn pull-right">
              <BUTTON class="btn btn-large btn-inverse btn-options"  type="button" data-placement="top" title="Options">
			  <span class="glyphicon glyphicon-cog"></span>
			  <SPAN class="icon-label">Options</SPAN>
			  </BUTTON>
            </DIV>
          </NAV>
        </DIV>
      </DIV>
	  
	  <% Call PanelEdit %>
	  
	 

      <DIV class="panel-body" id="panel-display">
	  
        <DIV class="tab-content">
          <DIV class="tab-pane fade in active" id="letters">
		  
            <H3>Letters</H3>

            <FORM action="" method="post">
              <INPUT type="hidden" name="FormName" value="PrintLetters">

              <TABLE class="table table-striped table-fade">
                <THEAD>
                  <TR>
                    <TH>Print</TH>

                    <TH style="text-align:left">Subscription</TH>

                    <TH style="text-align:left">Venue</TH>

                    <TH>Date/Time</TH>

                    <TH>Quantity</TH>
                  </TR>
                </THEAD>

                <TBODY>
                  <TR>
                    <TD><INPUT type="checkbox" name="EventCode" value="588031" class="checkbox"></TD>

                    <TD>Season Subscription (Winter)</TD>

                    <TD>Downtown Theater</TD>

                    <TD>1/1/2015 12:00 PM</TD>

                    <TD>8</TD>
                  </TR>

                  <TR>
                    <TD><INPUT type="checkbox" name="EventCode" value="588031" class="checkbox"></TD>

                    <TD>Season Subscription (Spring)</TD>

                    <TD>Downtown Theater</TD>

                    <TD>1/1/2015 12:00 PM</TD>

                    <TD>8</TD>
                  </TR>

                  <TR>
                    <TD><INPUT type="checkbox" name="EventCode" value="588031" class="checkbox"></TD>

                    <TD>Season Subscription (Summer)</TD>

                    <TD>Downtown Theater</TD>

                    <TD>1/1/2015 12:00 PM</TD>

                    <TD>8</TD>
                  </TR>

                  <TR>
                    <TD><INPUT type="checkbox" name="EventCode" value="588031" class="checkbox"></TD>

                    <TD>Season Subscription (Fall)</TD>

                    <TD>Downtown Theater</TD>

                    <TD>1/1/2015 12:00 PM</TD>

                    <TD>8</TD>
                  </TR>
                </TBODY>
              </TABLE>Select events and click below<BR>
              <BR>
              <INPUT type="submit" class="btn btn-outline btn-default" value="Submit">
            </FORM>
          </DIV>

          <DIV class="tab-pane fade" id="emails">
            <H3>Emails</H3>

            <FORM action="" method="post">
              <INPUT type="hidden" name="FormName" value="PrintLetters">

              <TABLE class="table table-striped table-fade">
                <THEAD>
                  <TR>
                    <TH>Print</TH>

                    <TH style="text-align:left">Subscription</TH>

                    <TH style="text-align:left">Venue</TH>

                    <TH>Date/Time</TH>

                    <TH>Quantity</TH>
                  </TR>
                </THEAD>

                <TBODY>
                  <TR>
                    <TD><INPUT type="checkbox" name="EventCode" value="588031" class="checkbox"></TD>

                    <TD>Season Subscription (Winter)</TD>

                    <TD>Downtown Theater</TD>

                    <TD>1/1/2015 12:00 PM</TD>

                    <TD>8</TD>
                  </TR>

                  <TR>
                    <TD><INPUT type="checkbox" name="EventCode" value="588031" class="checkbox"></TD>

                    <TD>Season Subscription (Spring)</TD>

                    <TD>Downtown Theater</TD>

                    <TD>1/1/2015 12:00 PM</TD>

                    <TD>8</TD>
                  </TR>

                  <TR>
                    <TD><INPUT type="checkbox" name="EventCode" value="588031" class="checkbox"></TD>

                    <TD>Season Subscription (Summer)</TD>

                    <TD>Downtown Theater</TD>

                    <TD>1/1/2015 12:00 PM</TD>

                    <TD>8</TD>
                  </TR>

                  <TR>
                    <TD><INPUT type="checkbox" name="EventCode" value="588031" class="checkbox"></TD>

                    <TD>Season Subscription (Fall)</TD>

                    <TD>Downtown Theater</TD>

                    <TD>1/1/2015 12:00 PM</TD>

                    <TD>8</TD>
                  </TR>
                </TBODY>
              </TABLE>Select events and click below<BR>
              <BR>
            <input type="submit" id="email-submit" class="btn btn-info btn-outline email-control" value="Submit" style="width:70px;"/> 
			<input type="submit" id="email-test"   class="btn btn-danger email-control" value="Test" style="width:70px;"/>
            </FORM>
        </DIV>

          <DIV class="tab-pane fade" id="loglist">
            <H3>Logs</H3>

            <FORM action="" method="post">
              <INPUT type="hidden" name="FormName" value="PrintLetters">

              <TABLE class="table table-striped table-fade">
                <THEAD>
                  <TR>
                    <TH>Print</TH>

                    <TH style="text-align:left">Subscription</TH>

                    <TH style="text-align:left">Venue</TH>

                    <TH>Date/Time</TH>

                    <TH>Quantity</TH>
                  </TR>
                </THEAD>

                <TBODY>
                  <TR>
                    <TD><INPUT type="checkbox" name="EventCode" value="588031" class="checkbox"></TD>

                    <TD>Season Subscription (Winter)</TD>

                    <TD>Downtown Theater</TD>

                    <TD>1/1/2015 12:00 PM</TD>

                    <TD>8</TD>
                  </TR>

                  <TR>
                    <TD><INPUT type="checkbox" name="EventCode" value="588031" class="checkbox"></TD>

                    <TD>Season Subscription (Spring)</TD>

                    <TD>Downtown Theater</TD>

                    <TD>1/1/2015 12:00 PM</TD>

                    <TD>8</TD>
                  </TR>

                  <TR>
                    <TD><INPUT type="checkbox" name="EventCode" value="588031" class="checkbox"></TD>

                    <TD>Season Subscription (Summer)</TD>

                    <TD>Downtown Theater</TD>

                    <TD>1/1/2015 12:00 PM</TD>

                    <TD>8</TD>
                  </TR>

                  <TR>
                    <TD><INPUT type="checkbox" name="EventCode" value="588031" class="checkbox"></TD>

                    <TD>Season Subscription (Fall)</TD>

                    <TD>Downtown Theater</TD>

                    <TD>1/1/2015 12:00 PM</TD>

                    <TD>8</TD>
                  </TR>
                </TBODY>
              </TABLE>Select events and click below<BR>
              <BR>
              <INPUT type="submit" class="btn btn-primary" value="Submit">
            </FORM>
          </DIV>
        
      </DIV>
    </DIV>

    <FOOTER>
	
    <!--#INCLUDE VIRTUAL="FooterInclude.asp" -->
	  
<SCRIPT src="https://code.jquery.com/jquery-1.9.1.js" type="text/javascript" language="javascript"></SCRIPT> 
<SCRIPT src="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js" type="text/javascript" language="javascript"></SCRIPT> 

<SCRIPT src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.10.3/jquery-ui.min.js" type="text/javascript" language="javascript"></SCRIPT> 
<SCRIPT src="https://cdnjs.cloudflare.com/ajax/libs/jquery-easing/1.3/jquery.easing.min.js" type="text/javascript" language="javascript">	</SCRIPT> 

<SCRIPT src="https://cdn.jsdelivr.net/icheck/1.0.2/icheck.min.js" type="text/javascript" language="javascript"></SCRIPT> 
<script src="http://gregfranko.com/jquery.selectBoxIt.js/js/jquery.selectBoxIt.min.js" type="text/javascript" language="javascript"></SCRIPT> 

<SCRIPT type="text/javascript" language="javascript">

function icheck() 
{
$('input.checkbox').iCheck(
{
checkboxClass: 'icheckbox_square-green',
radioClass: 'iradio_square-green',
increaseArea: '30%'
});

$('input').on('ifToggled', function(event)
{
if ($( this ).closest("tr").hasClass("active")) 
{
$(this).closest("tr").removeClass("active");
}
$( this ).closest("tr").addClass("active");     

});

}

icheck(); 


function tableFade() 
{                                                              
$("#panel-display")
.delay(25)
.animate({"opacity": "1"}, 800);
}

tableFade();

</SCRIPT> 

<SCRIPT type="text/javascript" language="javascript">

$(function () 
{

$('[data-toggle="tooltip"]').tooltip();
$('.dropdown-toggle').dropdown();
$('.dropdown-toggle').tooltip();

});           

</SCRIPT> 
	
<script type="text/javascript" language="javascript">

// toggle slide down panel

jQuery.fn.blindToggle = function(speed, easing, callback) 
{
var h = (this.height() + parseInt(this.css('paddingTop')) + parseInt(this.css('paddingBottom')) + 9);
return this.animate({marginTop: parseInt(this.css('marginTop')) < 0 ? 0 : -h}, speed, easing, callback);  
};

var $box = $('#panel-edit-inner')
$('.btn-options').click(function() 
{
$box.blindToggle(1000, 'easeInOutQuart');
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
	//disable all email controls
	$('.email-control').prop('disabled', true);
	
	//disable email switch
	$('#email-switch').prop('checked', false);
	
	//enable email submit
	$('#email-submit').prop('disabled', false);
	
	//check for email-switch to be toggled
	$('#email-switch').change(function() 
	{
		$('.email-control').toggleDisabled();       
	});
});

</script>

    
</FOOTER>
	
	
  </DIV>
  
  <%

  End Sub
  
  Sub PanelEdit
  
  %>
	 
	<DIV class="panel-body" id="panel-edit">

		<DIV class="container-fluid effect1" id="panel-edit-inner">
		
		<div class="well panel-well">

			<ul class="nav nav-pills nav-stacked col-sm-3">
				<li class="label-primary active"><a  href="#tab1" data-toggle="tab">Email Test</a></li>
				<li class="label-primary" ><a href="#tab2" data-toggle="tab">Page 2</a></li>
				<li class="label-primary" ><a   href="#tab3" data-toggle="tab">Page 3</a></li>
				<li class="label-primary" ><a   href="#tab4" data-toggle="tab">Page 4</a></li>
			</ul>
					
			<div class="tab-content col-sm-9">
					
				<div class="tab-pane active" id="tab1">
		
					<div class="panel panel-default">
						<div class="panel-header">
							<h4 class="panel-title">Email Testing</h4>
						</div>
						<div class="panel-body">
							<form class="form-horizontal" role="form">
	 
								<div class="form-group">
									<label class="col-sm-2 control-label pull-left">Test Mode</label>
									<div class="col-lg-10">
										<label class="switch switch-default label-primary">
										 
											<input type="checkbox" id="email-switch" class="switch-input form control"> 
											<span class="switch-label" data-on="ON" data-off="OFF"></span>
											<span class="switch-handle"></span>
									 
										</label>
									
									</div>
								</div>
								
								<div class="form-group">
									<label class="col-sm-2 control-label" >Email</label>
									<div class="col-sm-10" >
										<select class="form-control" name="TestEMailAddress">
											<option value="">Select Email Address</option>
												<%
												EmailArray = Split(GetUserEmails(1),",")
												For i =  lbound(EmailArray) to ubound(EmailArray)
													Response.Write "" & EmailArray(i) & ""
												Next
												%>
										</select>
									</div>
								</div>
 	
							</form>
						</div>
						<div class="panel-footer">
							<button type="button" class="btn btn-default btn-options" data-dismiss="modal">Close</button>
							<button type="button" class="btn btn-primary">Save changes</button>
						</div>
					</div>
 
				</div>
				
				<div class="tab-pane" id="tab2">
					<div class="panel panel-default">
						<div class="panel-header">
							<h4 class="panel-title">Page 2</h4>
						</div>
						<div class="panel-body">
							<form class="form-horizontal" role="form">
							
								<div class="form-group">
									<label class="col-sm-2 control-label" >Option 1</label>
									<div class="col-sm-10" >
										<input type="text" class="form-control">
									</div>
								</div>
								
								<div class="form-group">
									<label class="col-sm-2 control-label" >Option 2</label>
									<div class="col-sm-10" >
										<input type="text" class="form-control">
									</div>
								</div>
							
							</form>
						</div>
						<div class="panel-footer">
							<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
							<button type="button" class="btn btn-primary">Save changes</button>
						</div>
					</div>
				</div>
				
				<div class="tab-pane" id="tab3">
					<div class="panel panel-default">
						<div class="panel-header">
							<h4 class="panel-title">Page 3</h4>
						</div>
						<div class="panel-body">
							<form class="form-horizontal" role="form">
							
								<div class="form-group">
									<label class="col-sm-2 control-label" >Option 1</label>
									<div class="col-sm-10" >
										<input type="text" class="form-control">
									</div>
								</div>
								
								<div class="form-group">
									<label class="col-sm-2 control-label" >Option 2</label>
									<div class="col-sm-10" >
										<input type="text" class="form-control">
									</div>
								</div>
							
							</form>
						</div>
						<div class="panel-footer">
							<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
							<button type="button" class="btn btn-primary">Save changes</button>
						</div>
					</div>
				</div>
				
				<div class="tab-pane" id="tab4">
					<div class="panel panel-default">
						<div class="panel-header">
							<h4 class="panel-title">Page 4</h4>
						</div>
						<div class="panel-body">
							<form class="form-horizontal" role="form">
							
								<div class="form-group">
									<label class="col-sm-2 control-label" >Option 1</label>
									<div class="col-sm-10" >
										<input type="text" class="form-control">
									</div>
								</div>
								
								<div class="form-group">
									<label class="col-sm-2 control-label" >Option 2</label>
									<div class="col-sm-10" >
										<input type="text" class="form-control">
									</div>
								</div>
							
							</form>
						</div>
						<div class="panel-footer">
							<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
							<button type="button" class="btn btn-primary">Save changes</button>
						</div>
					</div>
				</div>

			</div>
			
		</div>
			
		</DIV>
		
	</div>
	  
<%

End Sub

%>
  
</BODY>
</HTML>
