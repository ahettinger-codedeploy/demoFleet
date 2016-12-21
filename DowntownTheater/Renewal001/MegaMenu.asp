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

  <TITLE>Support Dashboard</TITLE>
  
  <!-- Force IE to turn off past version compatibility mode and use current version mode -->
  <META http-equiv="X-UA-Compatible" content="IE=edge;chrome=1">
  
  <!-- Get the width of the users display-->
  <META name="viewport" content="width=device-width, initial-scale=1.0">
  
  <!-- Text encoded as UTF-8 -->
  <META http-equiv="Content-Type" content="text/html; charset=utf-8">
  
  <!--<LINK href='https://fonts.googleapis.com/css?family=Droid+Sans:400,700' rel="stylesheet" type="text/css">-->
  
  <LINK href='http://fonts.googleapis.com/css?family=Lato:400,700,900,400italic' rel="stylesheet" type="text/css">
  
  <LINK href="https://netdna.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css" rel="stylesheet" type="text/css">
  
  <LINK href="https://netdna.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" rel="stylesheet" type="text/css">
  
  <link rel="stylesheet" type="text/css" href="http://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.6.3/css/bootstrap-select.css">
  
  <STYLE>
  /* fonts */ 

  .TixManagementContent {font-family: 'Droid Sans', sans-serif; text-align:left;}

  /* links: remove all outlines and underscores */ 

  a.btn,                  
  a.btn:active,   
  a.btn:focus, 

  button.btn:active, 
  button.btn:focus,   
  button.btn:active, 
  button.btn:focus, 
  
  ul.dropdown-menu li a,
  ul.dropdown-menu li a.active,
  ul.dropdown-menu li a.focus,
  ul.dropdown-menu li a.hover,
  
  ul.nav.nav-pills li a,
  ul.nav.nav-pills li a.active,
  ul.nav.nav-pills li a.focus,
  ul.nav.nav-pills li a.hover,
  
  ul.nav-tabs li a,
  ul.nav-tabs li a.active,
  ul.nav-tabs li a.focus { outline:0px !important; -webkit-appearance:none;  text-decoration:none; color: #666666;}  

  /* remove blue glow  */ 

  .form-control 
  {
  background-color: #fff;
  background-image: none;
  border-radius: 4px;
  box-shadow: none;
  outline: none;
  border-width: 2px;
  color: #555;
  display: block;
  font-size: 14px;
  height: 34px;
  line-height: 1.42857;
  padding: 6px 12px;
  transition: border-color 0.15s ease-in-out 0s, box-shadow 0.15s ease-in-out 0s;
  width: 100%;
  }

  .form-control:focus 
  {
  border-color: #66afe9;
  box-shadow: none;
  outline: none;
  border-width: 2px;
  }
  </STYLE>
  
  <STYLE>

  .table-fade {}

  .table tbody tr.active {background-color: red;}

  </STYLE>
  
  <STYLE>

  /* outline button */ 

  .btn-default.btn-outline:active,
  .btn-default.btn-outline:focus, 
  .btn-default.btn-outline                	{ color: #676767; border-color: #676767; background-color: transparent; border-width: 2px; -webkit-transition: all 0.25s; -moz-transition: all 0.25s; transition: all 0.25s;}   
  .btn-default.btn-outline:hover  			{ color: #000000; border-color: #000000; background-color: transparent; border-width: 2px; -webkit-transition: all 0.75s; -moz-transition: all 0.75s; transition: all 0.75s; } 

  </STYLE>
  
 <style>

/* toggle switch */ 
 
.switch { position: relative; display: inline-block; vertical-align: top; width: 103px; height: 36px; background-color: transparent; cursor: pointer; box-sizing: content-box; overflow: hidden; }
.switch-input { position: absolute; top: 0px; left: 0px; opacity: 0; }
.switch-handle {border: 2px solid #c2d0de;  border-radius: 4px; position: absolute; top: 3px; left: 3px; width: 30px; height: 30px;  border-radius: 1px; background: none repeat scroll 0% 0% #c2d0de; transition: left 0.45s ease-out 0s; }
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

</style>
  
<STYLE>

/* checkbox  */

.icheckbox_square-green
{
display: inline-block;
*display: inline;
vertical-align: middle;
margin: 0;
padding: 0;
width: 22px;
height: 22px;
background: url(http://cdnjs.cloudflare.com/ajax/libs/iCheck/1.0.1/skins/square/green.png) no-repeat;
border: none;
cursor: pointer;
background-position: 0 0;
}

.icheckbox_square-green 
{

}

.icheckbox_square-green.hover 
{
background-position: -24px 0;
}

.icheckbox_square-green.checked 
{
background-position: -48px 0;
}

.icheckbox_square-green.disabled 
{
background-position: -72px 0;
cursor: default;
}

.icheckbox_square-green.checked.disabled 
{
background-position: -96px 0;
}

</STYLE>
  
<STYLE>

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

div.panel div.panel-heading div.panel-title nav.navbar div.pull-left ul.nav.nav-tabs li a { min-height: 47px !important; max-height: 47px !important;  min-width: 115px; margin-top: 3px; font-size: 14px;}

/* panel button */

div.panel div.panel-heading div.panel-title .nav-btn .btn { height: 49px; border: 0; background-color: #f5f5f5; }

/* panel labels */

div.panel .icon-label { margin-left: 5px; }

</STYLE>
  
<STYLE>

/* hide-show panels */ 

div#panel-parent.panel
{
position: relative;
min-height: 450px;
}

div#panel-parent.panel div#panel-edit.panel-body
{       
position: absolute;
z-index: 20;
overflow: hidden;
width: 100%;
padding: 0px .5px 20px .5px;
}

div#panel-parent.panel div#panel-edit.panel-body div#panel-edit-inner.container-fluid
{
background-color: white;
margin-top: -330px;
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

div#panel-parent.panel.panel-default div#panel-edit.panel-body div#panel-edit-inner.container-fluid.effect1 ul.nav.nav-pills.nav-stacked.col-sm-3 li.active a
{
border-radius: 4px;
font-weight: bold;
transition: all 300ms ease 0s;
margin-right: 2px;
display: block;
position: relative;
color: #ffffff;
}


div#panel-parent.panel div#panel-display.panel-body
{       
background-color: #ffffff;
position: absolute;
z-index: 10;
width: 100%;
opacity: 0;
}

</STYLE>


<style>

.tab-pane.active
{
background-color: rgb(255, 255, 255);
border-collapse: separate;
border-color: rgb(220, 228, 236);
border-radius: 4px;
border-style: solid;
border-width: 2px;
bottom: auto;
box-shadow: none;
box-sizing: border-box;
clear: none;
display: block;
float: none;
left: auto;
margin: 0;
outline: 0 none rgb(0, 0, 0);
outline-offset: 0;
padding: 6px 12px;
position: static;
right: auto;
text-align: start;
top: auto;
vertical-align: middle;

z-index: auto;
}

div.btn-group button.btn.btn-success.dropdown-toggle.btn-select.email-cntrl
{
border: 2px solid #c2d0de;
color: #555555;
background: transparent;
-webkit-transition: background 0.2s ease-in-out;
-moz-transition: background 0.2s ease-in-out;
-ms-transition: background 0.2s ease-in-out;
-o-transition: background 0.2s ease-in-out;
transition: background 0.2s ease-in-out;
}

div.btn-group button.btn.btn-success.dropdown-toggle.btn-select.email-cntrl.disabled
{
border: 2px solid #c2d0de;
background-color: #dce4ec;
-webkit-transition: background 0.2s ease-in-out;
-moz-transition: background 0.2s ease-in-out;
-ms-transition: background 0.2s ease-in-out;
-o-transition: background 0.2s ease-in-out;
transition: background 0.2s ease-in-out;
}

ul.nav.navbar-nav.navbar-tabs li.active a span.icon-label
font-size: 16px;
font-weight: bold;
line-height: 20px;
padding: 10px;
transition: color 350ms ease 0s;

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
              <BUTTON class="btn btn-large btn-default" id="btn4" type="button" data-placement="top" title="Options">
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

           
          </DIV>

         

  
        </DIV>
      </DIV>
    </DIV>

<FOOTER>

<!--#INCLUDE VIRTUAL="FooterInclude.asp" -->

<SCRIPT src="https://code.jquery.com/jquery-1.9.1.js" type="text/javascript" language="javascript"></SCRIPT> 
<SCRIPT src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.10.3/jquery-ui.min.js" type="text/javascript" language="javascript"></SCRIPT> 
<SCRIPT src="https://cdnjs.cloudflare.com/ajax/libs/jquery-easing/1.3/jquery.easing.min.js" type="text/javascript" language="javascript">	</SCRIPT> 

<SCRIPT src="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js" type="text/javascript" language="javascript"></SCRIPT> 
<SCRIPT src="https://cdn.jsdelivr.net/icheck/1.0.2/icheck.min.js" type="text/javascript" language="javascript"></SCRIPT> 

<SCRIPT type="text/javascript" language="javascript">

$(document).ready(function() 
{

function icheck() 
{
$('input.checkbox').iCheck(
{
checkboxClass: 'icheckbox_square-gray',
radioClass: 'iradio_square-gray',
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

});           

</SCRIPT> 

<SCRIPT type="text/javascript" language="javascript">

$(function () 
{

$('[data-toggle="tooltip"]').tooltip();
$('.dropdown-toggle').dropdown();
$('.dropdown-toggle').tooltip();

});           

</SCRIPT> 

<SCRIPT type="text/javascript" language="javascript">

jQuery.fn.blindToggle = function(speed, easing, callback) 
{
var h = (this.height() + parseInt(this.css('paddingTop')) + parseInt(this.css('paddingBottom')) + 9);
return this.animate({marginTop: parseInt(this.css('marginTop')) < 0 ? 0 : -h}, speed, easing, callback);  
};

$(document).ready(function() 
{
var $box = $('#panel-edit-inner')
$('#btn4').click(function() 
{
$box.blindToggle(1000, 'easeInOutQuart');
});    
});

</SCRIPT> 

</FOOTER>
	
	
  </DIV>
  
  <%

  End Sub
  
  Sub PanelEdit
  
  %>
	 
	<DIV class="panel-body" id="panel-edit">

		<DIV class="container-fluid effect1" id="panel-edit-inner">

			<ul class="nav nav-pills nav-stacked col-sm-3" style="margin-top: 15px;">
				<li class="active"><a href="#tab1" data-toggle="tab">Email Testing</a></li>
				<li><a href="#tab2" data-toggle="tab">Option 2</a></li>
				<li><a href="#tab3" data-toggle="tab">Option 3</a></li>
				<li><a href="#tab4" data-toggle="tab">Option 4</a></li>
			</ul>
			
			<div class="tab-content col-sm-9">
					
				<div class="tab-pane active" id="tab1" style="border:2px solid rgb(222, 223, 225); border-radius:4px; padding: 5px; min-height: 250px;">
				
					<form id="surveyForm" mthod="post" class="form-horizontal">
					
					<div class="form-group">
						<div class="col-lg-12">
							<h3>Email Testing</h3>
						</div>
					</div>
					
						<div class="form-group">
							<label for="Email" class="col-lg-3 control-label">Email Test Mode</label>
							<div class="col-lg-5">
								<label class="switch switch-success">
									<input type="checkbox" class="switch-input" data-classtoggle-class="--disabled" data-classtoggle-target=".email-cntrl" > 
									<span class="switch-label" data-on="ON" data-off="OFF"></span>
									<span class="switch-handle"></span>
								</label>
							</div>
						</div>
 
						<div class="form-group">

							<label class="col-sm-3 control-label">Email Address 1</label>
							
							<div class="col-lg-7">
								<select class="selectpicker show-tick form-control">
									<option>sergio.rodriguez@tix.com</option>
									<option>sergio@tix.com</option>
									<option>sergio.rodriguez.delao@gmail.com</option>
								</select>	
							</div>
							
							<div class="col-sm-2">
								<button type="button" class="btn btn-default">
									<i class="glyphicon glyphicon-send"></i>
								</button>
							</div>
							
						</div>

						<div class="form-group">

							<label class="col-sm-3 control-label">Email Address 3</label>
							
							<div class="col-lg-7">
								<select class="selectpicker show-tick form-control">
									<option>sergio.rodriguez@tix.com</option>
									<option>sergio@tix.com</option>
									<option>sergio.rodriguez.delao@gmail.com</option>
								</select>	
							</div>
							
							<div class="col-sm-2">
								<button type="button" class="btn btn-default">
									<i class="glyphicon glyphicon-send"></i>
								</button>
							</div>
							
						</div>
								
					</form>
					
				</div>

				<div class="tab-pane" id="tab2" style="border:2px solid rgb(222, 223, 225); border-radius:4px; padding: 5px; min-height: 250px;">
					<h3>Page 2</h3>
				</div>
				
				<div class="tab-pane" id="tab3" style="border:2px solid rgb(222, 223, 225); border-radius:4px; padding: 5px; min-height: 250px;">
					<h3>Page 3</h3>
				</div>
				
				<div class="tab-pane" id="tab4" style="border:2px solid rgb(222, 223, 225); border-radius:4px; padding: 5px; min-height: 250px;">
					<h3>Page 4</h3>
				</div>

			</div>
			
		</DIV>
		
	</div>
	  
<%

End Sub

%>
  
</BODY>
</HTML>
