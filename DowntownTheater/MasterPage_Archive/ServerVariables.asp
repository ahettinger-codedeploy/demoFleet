<!DOCTYPE html>
<html lang="en">
	<head>
	<title>template</title>
	<!-- Force IE to turn off past version compatibility mode and use current version mode -->
	<meta http-equiv="X-UA-Compatible" content="IE=edge;chrome=1">
	<!-- Get the width of the users display-->
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<!-- Text encoded as UTF-8 -->
	<meta http-equiv="Content-Type"  content="text/html; charset=utf-8">
	<!-- styles and fonts -->
	<link rel="stylesheet" href="https://netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.no-icons.min.css" />
	<link rel="stylesheet" href="https://netdna.bootstrapcdn.com/font-awesome/3.2.1/css/font-awesome.min.css" />
	<link href="http://www.testtix.com/Utilities/Support/tixDashboard/includes/css/flat-tix.css" rel="stylesheet">
	<style>
	body {background-color: rgb(224, 224, 224);}
	.main { font-family: "Segoe UI", "Lato", "Helvetica Neue", Helvetica, Arial, sans-serif; font-size: 15px; line-height: 1.428571429;  color: #2c3e50; background-color: rgb(255, 255, 255) }
	.container, section, div.container, div.section { width: 965px; text-align: left; }
	.container a { text-decoration: none;}
	</style>
	<!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries in IE8, IE9 -->
	<!--[if lt IE 9]>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/html5shiv/3.6.2/html5shiv.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/respond.js/1.3.0/respond.js"></script>
	<![endif]-->
	</head>

  <body>

	
	<div class="container main" style="margin-top:50px;">
	
		<div class="page-header">
		<h1>Flat Design&nbsp;&nbsp;<small>Basic elements</small></h1>
		</div>
 
		<TABLE class="table">
				<TR>
				   <TD>
						<B>Server Varriable</B>
				   </TD>
				   <TD>
						<B>Value</B>
				   </TD>
				</TR>
				<% For Each name In Request.ServerVariables %>
				  <TR>
					   <TD>
							<%= name %>
					   </TD>
					   <TD>
							<%= Request.ServerVariables(name) %>
					   </TD>
				 </TR>
				<% Next %>
		</TABLE>

    </div>

    <!-- Load JS here for greater good =============================-->


		<script src="https://code.jquery.com/jquery-1.9.1.js" type="text/javascript" ></script>

		<script src="https://code.jquery.com/ui/1.10.2/jquery-ui.js" type="text/javascript" ></script>

		<script src="https://netdna.bootstrapcdn.com/bootstrap/3.0.0/js/bootstrap.min.js"></script>
  </body>
</html>