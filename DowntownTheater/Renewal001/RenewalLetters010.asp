
<% 

'CHANGE LOG


%>

<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
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

<html lang="en">

<title>Support Dashboard</title>

<!-- Force IE to turn off past version compatibility mode and use current version mode -->
<meta http-equiv="X-UA-Compatible" content="IE=edge;chrome=1">

<!-- Get the width of the users display-->
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- Text encoded as UTF-8 -->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<link href='http://fonts.googleapis.com/css?family=Droid+Sans:400,700' rel="stylesheet" type="text/css">
<link href="https://netdna.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" >
<link href="https://netdna.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" rel="stylesheet" type="text/css" >
<link href="https://cdn.jsdelivr.net/animatecss/3.2.0/animate.css" rel="stylesheet" type="text/css" >


<style>
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

.dropdown-menu li a,
.dropdown-menu li a:active,
.dropdown-menu li a:focus,
.dropdown-menu li a:hover,

ul.dropdown-menu li a,
ul.dropdown-menu li a:active,
ul.dropdown-menu li a:focus,
ul.dropdown-menu li a:hover,

.nav-tabs li a,
.nav-tabs li a:active,
.nav-tabs li a:focus { outline:0px !important; -webkit-appearance:none;  text-decoration:none; color: #666666;}  

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
</style>

<style>

/* outline button */ 

.btn-default.btn-outline:active,
.btn-default.btn-outline:focus, 
.btn-default.btn-outline 		{ color: #676767; border-color: #676767; background-color: transparent; border-width: 2px; -webkit-transition: all 0.25s; -moz-transition: all 0.25s; transition: all 0.25s;} 	
.btn-default.btn-outline:hover 	{ color: #000000; border-color: #000000; background-color: transparent; border-width: 2px; -webkit-transition: all 0.75s; -moz-transition: all 0.75s; transition: all 0.75s; } 

</style>


<style>

/* toggle switch */ 
 
.switch { position: relative; display: inline-block; vertical-align: top; width: 102px; height: 31px; background-color: transparent; cursor: pointer; box-sizing: content-box; overflow: hidden; }

.switch-input { position: absolute; top: 0px; left: 0px; opacity: 0; }

.switch-handle { position: absolute; top: 2px; left: 2px; width: 30px; height: 27px; border: 1px solid rgb(209, 212, 215); border-radius: 1px; background: none repeat scroll 0% 0% rgb(209, 212, 215); transition: left 0.45s ease-out 0s; }

.switch-label { border: 1px solid rgb(209, 212, 215); border-radius: 2px; position: relative; display: block; height: inherit; font-size: 15px; text-transform: uppercase; background: none repeat scroll 0% 0% rgb(248, 248, 248); transition: all 0.15s ease-out 0s; }

.switch-label:before, 
.switch-label:after { position: absolute; top: 50%; margin-top: -0.5em; line-height: 1; transition: inherit; }
.switch-label:before { content: attr(data-off); right: 11px; color: rgb(209, 212, 215); }
.switch-label:after { content: attr(data-on); left: 11px; color: white; opacity: 0; }

.switch-input:checked ~ .switch-label { background: none repeat scroll 0% 0% rgb(248, 249, 250); }
.switch-input:checked ~ .switch-handle { left: 70px; background-color: white;}
.switch-input:checked ~ .switch-label:before { opacity: 0; }
.switch-input:checked ~ .switch-label:after { opacity: 1; }
 
.switch-default > .switch-input:checked ~ .switch-label { background: none repeat scroll 0% 0% rgb(209, 212, 215); }
.switch-default > .switch-input:checked ~ .switch-handle { border-color: #999999; }

.switch-primary > .switch-input:checked ~ .switch-label { background: none repeat scroll 0% 0% rgb(32, 168, 216); border-color: rgb(25, 133, 172); }
.switch-primary > .switch-input:checked ~ .switch-handle { border-color: rgb(25, 133, 172); }

.switch-success > .switch-input:checked ~ .switch-label { background: none repeat scroll 0% 0% rgb(77, 189, 116); border-color: rgb(58, 157, 93); }
.switch-success > .switch-input:checked ~ .switch-handle { border-color: rgb(58, 157, 93); }

.switch-warning > .switch-input:checked ~ .switch-label { background: none repeat scroll 0% 0% rgb(248, 203, 0); border-color: rgb(197, 161, 0); }
.switch-warning > .switch-input:checked ~ .switch-handle { border-color: rgb(197, 161, 0); }

.switch-info > .switch-input:checked ~ .switch-label { background: none repeat scroll 0% 0% rgb(99, 194, 222); border-color: rgb(57, 178, 213); }
.switch-info > .switch-input:checked ~ .switch-handle { border-color: rgb(57, 178, 213); }

.switch-danger > .switch-input:checked ~ .switch-label { background: none repeat scroll 0% 0% rgb(248, 108, 107); border-color: rgb(246, 60, 58); }
.switch-danger > .switch-input:checked ~ .switch-handle { border-color: rgb(246, 60, 58); }
 
</style>


<style>
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

/* Retina support */
@media only screen and (-webkit-min-device-pixel-ratio: 1.5),
only screen and (-moz-min-device-pixel-ratio: 1.5),
only screen and (-o-min-device-pixel-ratio: 3/2),
only screen and (min-device-pixel-ratio: 1.5) 
{
	.icheckbox_square-green
	{
	background-image: url(http://cdnjs.cloudflare.com/ajax/libs/iCheck/1.0.1/skins/square/green@2x.png);
	-webkit-background-size: 240px 24px;
	background-size: 240px 24px;
	position: absolute !important; 
	z-index: 1 !important; 
	}
}
</style>

<style>

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
div.panel div.panel-heading div.panel-title nav.navbar div.pull-left ul.nav.nav-tabs li a { min-height: 47px !important; max-height: 47px !important; margin-top: 3px; font-size: 14px;}

/* panel button */ 
div.panel div.panel-heading div.panel-title .nav-btn .btn { height: 49px; border: 0; background-color: #f5f5f5; }

</style>

<style>

div#panel-parent.panel
{;
position: relative;
min-height: 450px;
}

div#panel-parent.panel div#panel-header.panel-heading
{

}

div#panel-parent.panel div#panel-edit.panel-body
{	
border-left:1px solid red;
border-right:1px solid red;
position: absolute;
z-index: 20;
overflow: hidden;
width: 100%;
padding: 0px;
}

div#panel-parent.panel div#panel-edit.panel-body form#box-inner.form-horizontal
{
border: 1px solid #000000;
border-radius: 0px 0px 4px 4px;
box-shadow: 0 6px 12px rgba(0, 0, 0, 0.176);

top: -100px;
background-color: #f8f8f8;
margin-top: 5px;
margin-left: 10px;
margin-right: 10px;
margin-bottom: 10px;
}


div#panel-parent.panel div#panel-display.panel-body
{	
background-color: #ffffff;
position: absolute;
z-index: 10;
width: 100%;
}



</style>

</head>

	<body>
	
		<div class="container" style="margin-top: 35px;">
		
			<!--#INCLUDE VIRTUAL="TopNavInclude.asp" -->
									
					<div class="panel panel-default" id="panel-parent">
					
						<div class="panel-heading" id="panel-header">
						
							<div class="panel-title">
							
								<nav class="navbar" role="navigation">
								
										<div class="navbar-header">
											<span class="navbar-brand">Renewal Letters</span>
										</div>

										<div class="pull-left">
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
														<span class="icon-label"> Emails</span>
													</a>
												</li>
												<li>
													<a href="#loglist" data-toggle="tab">
														<i class="glyphicon glyphicon-list"></i>
														<span class="icon-label">Logs</span>
													</a>
												</li>
											</ul>
										</div>


										<div class="nav-btn pull-right">
											<button class="btn btn-large btn-default" id="btn4" type="button" data-placement="top" title="Options">
												<span class="glyphicon glyphicon-cog"></span>
												<span class="nav-label">Preferences</span>
											</button>
										</div>

								</nav>	
								
							</div>
							
						</div>
						
						<div class="panel-body" id="panel-edit">

								<form class="form-horizontal" id="box-inner">
								
									<fieldset>
							 
										<div class="col-sm-4">

											<div class="form-group">
												<label for="name" class="col-xs-5 control-label">Test Mode</label>
												<div class="col-xs-7">
													<label class="switch switch-primary">
														<input class="switch-input" checked="checked" type="checkbox">
														<span class="switch-label" data-on="ON" data-off="OFF"></span>
														<span class="switch-handle"></span>
													</label>
												</div>
											</div>
											
											<div class="form-group">
												<label for="name1" class="col-sm-5 control-label">&nbsp;</label>
												<div class="col-sm-7">
													
												</div>
											</div>

										</div>
										
										<div class="col-sm-4">
										
											<div class="form-group">
												<label for="name" class="col-xs-4 control-label">Email 1</label>
												<div class="col-xs-8">
													<input type="text" class="form-control" placeholder="enter email address" />
												</div>
											</div>
											
											<div class="form-group">
												<label for="name" class="col-xs-4 control-label">Email 2</label>
												<div class="col-xs-8">
													<input type="text" class="form-control" placeholder="enter email address" />
												</div>
											</div>
											
										</div>
										
										<div class="col-sm-4">
										
											<div class="form-group">
												<label for="name" class="col-xs-4 control-label">Email 3</label>
												<div class="col-xs-8">
													<input type="text" class="form-control" placeholder="enter email address" />
												</div>
											</div>
											
											<div class="form-group">
												<label for="name" class="col-xs-4 control-label">Email 4</label>
												<div class="col-xs-8">
													<input type="text" class="form-control" placeholder="enter email address" />
												</div>
											</div>
											
										</div>
										
									</fieldset>
									<BR>
									<BR>
									<INPUT TYPE="submit" CLASS="btn btn-outline btn-default" id="toggle" VALUE="Submit">
										
								</form>

						</div>

						<div class="panel-body" id="panel-display">
							
							<div class="tab-content">

								<div class="tab-pane fade in active" id="letters">
								<h3>Letters</h3>
								<FORM ACTION="" METHOD="post">
									<INPUT TYPE="hidden" NAME="FormName" VALUE="PrintLetters">
									<TABLE class="table">
									<THEAD>
										<TR><TH>Print</TH><TH style="text-align:left">Subscription</TH><TH style="text-align:left">Venue</TH><TH>Date/Time</TH><TH>Quantity</TH></TR>
									</THEAD>
									<TBODY>
										<TR><TD><INPUT TYPE="checkbox" NAME="EventCode" VALUE=588031 class="checkbox"></TD><TD>Season Subscription (Winter)</TD><TD>Downtown Theater</TD><TD>1/1/2015 12:00 PM</TD><TD>8</TD></TR>
										<TR><TD><INPUT TYPE="checkbox" NAME="EventCode" VALUE=588031 class="checkbox"></TD><TD>Season Subscription (Spring)</TD><TD>Downtown Theater</TD><TD>1/1/2015 12:00 PM</TD><TD>8</TD></TR>
										<TR><TD><INPUT TYPE="checkbox" NAME="EventCode" VALUE=588031 class="checkbox"></TD><TD>Season Subscription (Summer)</TD><TD>Downtown Theater</TD><TD>1/1/2015 12:00 PM</TD><TD>8</TD></TR>
										<TR><TD><INPUT TYPE="checkbox" NAME="EventCode" VALUE=588031 class="checkbox"></TD><TD>Season Subscription (Fall)</TD><TD>Downtown Theater</TD><TD>1/1/2015 12:00 PM</TD><TD>8</TD></TR>
									</TBODY>
									</TABLE>
									Select events and click below<BR><BR>
									<INPUT TYPE="submit" CLASS="btn btn-outline btn-default" VALUE="Submit">
								</FORM>
								</div>
							
													
								<div class="tab-pane fade" id="emails">
								<h3>Emails</h3>								 
								<FORM ACTION="" METHOD="post">
									<INPUT TYPE="hidden" NAME="FormName" VALUE="PrintLetters">
									<TABLE class="table table-striped">
									<THEAD>
										<TR><TH>Print</TH><TH style="text-align:left">Subscription</TH><TH style="text-align:left">Venue</TH><TH>Date/Time</TH><TH>Quantity</TH></TR>
									</THEAD>
									<TBODY>
										<TR><TD><INPUT TYPE="checkbox" NAME="EventCode" VALUE=588031 class="checkbox"></TD><TD>Season Subscription (Winter)</TD><TD>Downtown Theater</TD><TD>1/1/2015 12:00 PM</TD><TD>8</TD></TR>
										<TR><TD><INPUT TYPE="checkbox" NAME="EventCode" VALUE=588031 class="checkbox"></TD><TD>Season Subscription (Spring)</TD><TD>Downtown Theater</TD><TD>1/1/2015 12:00 PM</TD><TD>8</TD></TR>
										<TR><TD><INPUT TYPE="checkbox" NAME="EventCode" VALUE=588031 class="checkbox"></TD><TD>Season Subscription (Summer)</TD><TD>Downtown Theater</TD><TD>1/1/2015 12:00 PM</TD><TD>8</TD></TR>
										<TR><TD><INPUT TYPE="checkbox" NAME="EventCode" VALUE=588031 class="checkbox"></TD><TD>Season Subscription (Fall)</TD><TD>Downtown Theater</TD><TD>1/1/2015 12:00 PM</TD><TD>8</TD></TR>
									</TBODY>
									</TABLE>
									Select events and click below<BR><BR>
									<INPUT TYPE="submit" CLASS="btn btn-outline btn-default" VALUE="Submit">
								</FORM>
								</div>
								
								<div class="tab-pane fade" id="loglist">
								<h3>Logs</h3>									 
								<FORM ACTION="" METHOD="post">
									<INPUT TYPE="hidden" NAME="FormName" VALUE="PrintLetters">
									<TABLE class="table table-striped">
									<THEAD>
										<TR><TH>Print</TH><TH style="text-align:left">Subscription</TH><TH style="text-align:left">Venue</TH><TH>Date/Time</TH><TH>Quantity</TH></TR>
									</THEAD>
									<TBODY>
										<TR><TD><INPUT TYPE="checkbox" NAME="EventCode" VALUE=588031 class="checkbox"></TD><TD>Season Subscription (Winter)</TD><TD>Downtown Theater</TD><TD>1/1/2015 12:00 PM</TD><TD>8</TD></TR>
										<TR><TD><INPUT TYPE="checkbox" NAME="EventCode" VALUE=588031 class="checkbox"></TD><TD>Season Subscription (Spring)</TD><TD>Downtown Theater</TD><TD>1/1/2015 12:00 PM</TD><TD>8</TD></TR>
										<TR><TD><INPUT TYPE="checkbox" NAME="EventCode" VALUE=588031 class="checkbox"></TD><TD>Season Subscription (Summer)</TD><TD>Downtown Theater</TD><TD>1/1/2015 12:00 PM</TD><TD>8</TD></TR>
										<TR><TD><INPUT TYPE="checkbox" NAME="EventCode" VALUE=588031 class="checkbox"></TD><TD>Season Subscription (Fall)</TD><TD>Downtown Theater</TD><TD>1/1/2015 12:00 PM</TD><TD>8</TD></TR>
									</TBODY>
									</TABLE>
									<BR><BR>
									<INPUT TYPE="submit" CLASS="btn btn-outline btn-default" VALUE="Submit">
								</FORM>
								</div>

							</div>
							
						</div>
						
					</div>

					<footer>

						<!--#INCLUDE VIRTUAL="FooterInclude.asp" -->
						
						<script src="http://code.jquery.com/jquery-1.9.1.js" type="text/javascript" language="javascript"></script>
						<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js" type="text/javascript" language="javascript" ></script>
						<script src="http://cdn.jsdelivr.net/icheck/1.0.2/icheck.min.js" type="text/javascript" language="javascript" ></script>
				
						<script type="text/javascript" language="javascript">
							
							$(document).ready(function() 
							{

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
										$(this).closest("tr").toggleClass("active")
									});
							 
								}
								
								icheck(); 


								function tableFade() 
								{				
									$(".table-fade")
									.delay(25)
									.animate({"opacity": "1"}, 1000);
								}
								
								tableFade();

							});	

						</script>

						<script type="text/javascript" language="javascript">

						$(function () 
						{

							$('[data-toggle="tooltip"]').tooltip();
							$('.dropdown-toggle').dropdown();
							$('.dropdown-toggle').tooltip();

						});	
						
						</script>	

						<script type="text/javascript" language="javascript">

						jQuery.fn.blindToggle = function(speed, easing, callback) 
						{
						  var h = (this.height() + parseInt(this.css('paddingTop')) + parseInt(this.css('paddingBottom')) - 0);
						  return this.animate({marginTop: parseInt(this.css('marginTop')) < 0 ? 0 : -h}, speed, easing, callback);  
						};

						$(document).ready(function() 
						{
						  var $box = $('#box-inner')
						   $('#btn4').click(function() 
						  {
							$box.blindToggle('slow');  
						  });    
						});
								
						</script>

					</footer>
			
		</div>

	</body>
		
</html>

<%

End Sub

%>
