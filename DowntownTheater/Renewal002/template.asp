<!-- #INCLUDE VIRTUAL=GlobalInclude.asp-->
<!-- #INCLUDE VIRTUAL=DBOpenInclude.asp-->

<%

'-----------------------------------------------

ServerName = Request.ServerVariables ("SERVER_NAME") 

If ServerName <> "localhost" Then

	Page = "Management"

	Session.Timeout = 60
	Server.ScriptTimeout = 3600

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
	
 
End If

DIM rootFolder
rootFolder = fnRootFolder

'-----------------------------------------------

%>

<!DOCTYPE html>

<html lang="en">

<head>	

	<title>title</title>

	<!-- Force IE to turn off past version compatibility mode and use current version mode -->
	<meta http-equiv="X-UA-Compatible" content="IE=edge;chrome=1">

	<!-- Get the width of the users display-->
	<meta name="viewport" content="width=device-width, initial-scale=1.0">

	<!-- Text encoded as UTF-8 -->
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

	<link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet">

	<link href='https://fonts.googleapis.com/css?family=Roboto:100italic,300italic,400italic,500italic,700italic,900italic,100,300,400,500,700,900' rel='stylesheet' type='text/css'>

	<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css" rel="stylesheet" type="text/css">
	
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

</head>

	<body class="container">

		<header>
			<!-- #INCLUDE VIRTUAL="TopNavInclude.asp" -->
		</header>
		
		<section>	
		
			<div class="panel panel-default" id="panel-parent">
			
				<div class="panel-heading">
					<div class="panel-title">

						<nav class="navbar" role="navigation">
						
							<div class="navbar-header">
								<span class="navbar-brand">Organization Name</span>
							</div>
				 
							<div class="pull-left">
								<ul class="nav nav-tabs">
								
									<li class="active" >
									  <a href="#Tab1" data-toggle="tab">
									  <i class="glyphicon glyphicon-print"></i>
									  <span class="icon-label">Letters</span>
									  </a>
									</li>

									<li>
									  <a href="#Tab2" data-toggle="tab">
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
									
								</ul>
							</div>

							<div class="nav-btn pull-right">
							  <button class="btn btn-large btn-default" id="btn-options" type="button" data-placement="top" title="Options">
							  <span class="glyphicon glyphicon-cog"></span>
							  <span class="icon-label">Options</span>
							  </button>
							</div>
							
						</nav>

					</div>
				</div>
				
				<div class="panel-body" id="panel-display">
							
				</div>
				
			</div>
			
		</section>
			
		<footer>
			<!-- #INCLUDE VIRTUAL="FooterInclude.asp" -->	
			<script src="https://code.jquery.com/jquery-2.1.4.min.js"></script>
			<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js"></script>
		</footer>

	</body>
		
</html>

<%


%>


