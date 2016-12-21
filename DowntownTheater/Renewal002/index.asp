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
	
<style>

/* ===============
GLOBAL SETTINGS 
=============== */

/* font styles */ 

.TixManagementContent,
.TixManagementContent section div#panel-parent
{
font-family: 'Roboto', sans-serif !important;
color: #666666;
}


/* tix management section style */ 

.TixManagementContent
{
text-align: left !important;
min-height: 600px !important;
padding: 0px !important;
border: 1px solid red;

/* user page footer image - resized to cover enter area */ 
background-color: #fbfbfb !important;
background-image: url('http://www.tix.com/clients/tix/images/bg-footer.png') !important;
background-size: cover !important;
background-repeat: no-repeat !important;
}


code
{
background-color: #f9f2f4;
border-radius: 4px;
color: #000000;
padding: 2px 4px;
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
ul.nav-tabs li a.focus { outline:0px !important; -webkit-appearance:none;  text-decoration:none;}  


/* form input: remove blue glow */ 
.form-control,
.form-control:focus 
{
box-shadow: none;
border-width: 1px;
transition: border-color 0.15s ease-in-out 0s;
}


/* =====================
PANELS
===================== */

div.panel-heading h3
{
margin: 0px;
color: #333333;
}


div#panel-display.panel-body div.panel
{

}
	

/* =====================
   Card Shadows
===================== */

.card-1  { box-shadow: 0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.24); transition: all 0.2s ease-in-out;}

.card-1:hover { box-shadow: 0 10px 20px rgba(0,0,0,0.19), 0 6px 6px rgba(0,0,0,0.23);}

.card-2  { box-shadow: 0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.24); transition: all 0.2s ease-in-out;}

.card-3 	{ box-shadow: 0 3px 6px rgba(0,0,0,0.16), 0 3px 6px rgba(0,0,0,0.23);}

.card-4 	{ box-shadow: 0 10px 20px rgba(0,0,0,0.19), 0 6px 6px rgba(0,0,0,0.23);}

.card-5 	{ box-shadow: 0 14px 28px rgba(0,0,0,0.25), 0 10px 10px rgba(0,0,0,0.22);}

.card-6 	{ box-shadow: 0 19px 38px rgba(0,0,0,0.30), 0 15px 12px rgba(0,0,0,0.22);}

.card-7	{ box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.12), 0 1px 2px 0 rgba(0, 0, 0, 0.12);}
	


 
/* =====================
   NAVBAR
   ===================== */
   
.navheader
{
margin-top:10px;
color: #666666;
}
   
/* navbar buttons */ 

.btn.btn-navbar
{
box-shadow: none;
}
 
.btn.btn-navbar,
.input-navbar.form-control
{
color: #666666;
border:1px solid #999999;
}

.btn.btn-navbar:hover,
.input-group.focusClass > .input-navbar.form-control
{
color: #222222;
border:1px solid #666666;
}

div.input-group input#input-search.form-control.input-navbar
{
height: 38px;
}


.btn.btn-navbar:hover,
.input-group.focusClass .input-group-btn .btn.btn-navbar
{
color: #222222;
background-color: #E6E6E6;
}

/* remove the navbar's background color. 
Allows the panel color to be visible */ 

/* =====================
   NAVBAR PANEL
   ===================== */
   
div#panel-parent.panel
{
background-color: rgb(251, 251, 251);
background-image: url('http://www.tix.com/clients/tix/images/bg-footer.png');
border: 0px;
box-shadow: none;
margin-bottom: 0px !important;
border-radius: 0px;
} 

div#panel-parent
{
border-width: 1px;
-webkit-box-shadow: 0 10px 6px -6px #999 !important;
-moz-box-shadow: 0 10px 6px -6px #999 !important;
box-shadow-old: 0 10px 6px -6px #999 !important;
box-shadow: 0 none !important;
position: relative;
min-height: 450px;
}

/* panel header, panel title, panel navbar, panel tabs, panel button */ 

div#panel-parent > div.panel-heading,
div#panel-parent > div.panel-heading div.panel-title,
div#panel-parent > div.panel-heading div.panel-title .nav-btn,
div#panel-parent > div.panel-heading div.panel-title .nav-tabs,
div#panel-parent > div.panel-heading div.panel-title .navbar,
div#panel-parent > div.panel-heading div.panel-title .navbar .navbar-header
{ padding: 0; margin: 0; border: 0; min-height: 50px !important; text-align: center;}


/* panel header */ 
div#panel-parent > div.panel-heading { border-bottom: 1px solid #dddddd !important;}


/* panel tabs */
div#panel-parent > div.panel-heading div.panel-title nav.navbar div.pull-left ul.nav.nav-tabs li a { min-height: 47px !important; max-height: 47px !important;  min-width: 115px; margin-top: 3px; font-size: 14px;}


/* panel button */
div#panel-parent > div.panel-heading div.panel-title .nav-btn .btn { height: 49px; border: 0; background-color: #f5f5f5; }


/* panel labels */
div#panel-parent > .icon-label { margin-left: 5px; }

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
						panel title
					</div>
				</div>
				
				<div class="panel-body" id="panel-display">
						panel body
				</div>

			</div>
			
		</section>
			
		<footer>
			<!-- #INCLUDE VIRTUAL="FooterInclude.asp" -->	
		</footer>

	</body>
		
</html>

<%


%>


