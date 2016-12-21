<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<% 	Dim PageName
	PageName = "Ticket Information"
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Anderson Symphony Orchestra | <%= PageName %></title>
</head>
<!--[if lt IE 7]>
<style>
.png, td {behavior: url(http://www.andersonsymphony.org/includes/iepngfix.htc) }
</style>
<![endif]-->

<style>
<!--
* {margin:0; padding:0;}
p {margin-bottom: 15px;}
img {border:0}
body {background:url(http://www.andersonsymphony.org/images/background.jpg) repeat-x;}

#logo {position:absolute; z-index:100; left:123px; display:block; background:url(http://www.andersonsymphony.org/images/logo.png) no-repeat; width:337px; height:93px; border:none;}
	#logo a:hover {background:url(http://www.andersonsymphony.org/images/logo.png) no-repeat;}
#menu {position:absolute; left:442px; top:80px;}
	#menu td img {border:none;}
#contentBG {position:absolute; top:132px; left:151px; width:770px; height:616px; padding:15px; background: url(http://www.andersonsymphony.org/images/contentBGwide.png) no-repeat;}
#content {font-family:Times, serif; font-size:14px; line-height:21px; position:absolute; top:132px; left:145px; width:760px; height:560px; padding-right:20px; margin:15px;}
	#content p {text-align:justify;}
	#content td {text-align:left;}
	#content div {text-align:center;}
	#footer {display:block;}

/* Font Styles */
h1 {font-size:18px;}
h2 {font-size:16px;}
h3 {font-size:14px; color:#666666;}
h4 {font-size:12px; color:#666666;}
h5 {font-size:12px;}
h6 {font-size:12px;}
hr {margin:20px;}
.bold {font-weight:bold;}
.italic {font-style:italic;}
a {color:#000000; text-decoration:underline;}
a:hover {color:#767676; text-decoration:underline;}

-->
</style>
<body>
	<a href="/" id="logo"></a>
	<table cellpadding="0" cellspacing="0" border="0" id="menu">
		<tr>
			<td><a href="http://www.andersonsymphony.org"><img src="http://www.andersonsymphony.org/images/menu/menu_home.png" /></a></td>
			<td class="menu_sep"><img src="http://www.andersonsymphony.org/images/menu/menu_sep_wide.png" /></td>
			<td><a href="http://www.andersonsymphony.org/about.asp"><img src="http://www.andersonsymphony.org/images/menu/menu_about.png" /></a></td>
			<td class="menu_sep"><img src="http://www.andersonsymphony.org/images/menu/menu_sep_wide.png" /></td>
			<td><a href="http://www.andersonsymphony.org/season.asp"><img src="http://www.andersonsymphony.org/images/menu/menu_season.png" /></a></td>
			<td class="menu_sep"><img src="http://www.andersonsymphony.org/images/menu/menu_sep_wide.png" /></td>
			<td><a href="http://andersonsymphony.tix.com/Schedule.asp?OrganizationNumber=714" target="_blank"><img src="http://www.andersonsymphony.org/images/menu2/menu_tickets.png" /></a></td>
			<td class="menu_sep"><img src="http://www.andersonsymphony.org/images/menu/menu_sep_wide.png" /></td>
			<td><a href="http://www.andersonsymphony.org/contact.asp"><img src="http://www.andersonsymphony.org/images/menu/menu_contact.png" /></a></td>
			<td class="menu_sep"><img src="http://www.andersonsymphony.org/images/menu/menu_sep_wide.png" /></td>
			<!--<td><a href="http://www.andersonsymphony.org/give.asp"><img src="http://www.andersonsymphony.org/images/menu/menu_give.png" /></a></td>
			<td class="menu_sep"><img src="http://www.andersonsymphony.org/images/menu/menu_sep.png" /></td>-->
			<td><a href="http://www.andersonsymphony.org/mailing.asp"><img src="http://www.andersonsymphony.org/images/menu/menu_mailing_wide.png" /></a></td>
		</tr>
	</table>
	<div id="contentBG" class="png"></div>
	<div id="content">
		<img src="http://www.andersonsymphony.org/images/headers/tickets.png" style="padding:2px 0px 15px 7px;"  />

		<!-- Insert Ticket Information here. -->

		<div id="footer">
			<hr />
			<div>1124 Meridian Plaza<br />Downtown Anderson - At the Paramount Theatre Centre<br />(765) 644-2111 or Toll Free (888) 644-9490</div>
		</div>
	</div>
</body>
</html>