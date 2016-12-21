	

<%
Option Explicit

Dim FSO

DIM i


Dim FilePath
Dim ETicketBackground 

Dim ActAdsFolderName
Dim ActCode
Dim ActMsg


Dim TicketBackground

DIM ETicketNumber
DIM OrderNumber
DIM ItemNumber

DIM Organization 
DIM  Act 
DIM  Venue 
DIM  EventDateTime 
DIM  SeatType 
DIM  Section 
DIM  Row
DIM  Seat
DIM Price


ETicketNumber = "000000000000"
OrderNumber = "0000000"
ItemNumber = "00000000"
Organization ="Organization"
Act = "Act"
ActCode = "12345"
Venue = "Venue"
EventDateTime = "September 20, 2013"
SeatType = "Adult"
Section = "Orchestra"
Row = "A"
Seat = "1"
Price = "0.00"


Dim FileName(4)

FileName(1) = "ETicketBackground"
FileName(2) = "ETicketLogo"
FileName(3) = "ETicketBottomBar"
FileName(4) = "12345"

Dim FolderName(4)

FolderName(1) = "Images"
FolderName(2) = "Images"
FolderName(3) = "Images"
FolderName(4) = "Images"

Dim FileLocation(4)

DIM Msg(4)

Msg(1) = ""
Msg(2) = ""
Msg(3) = ""
Msg(4) = ""

Dim MyString, MyArray, Ext, M

MyString = "jpg,gif,png,bmp"
myArray = Split(myString,",")  


Set FSO = Server.CreateObject("Scripting.FileSystemObject")

For i = 1 to uBound(FileName)

	For m = 0 To UBound(myArray) 
	ext = (myArray(m))

		FilePath = (server.mappath(FolderName(i)&"/"&FileName(i)&"."&ext))
		
		If (FSO.FileExists(FilePath)) Then
			Msg(i) = "<div class=""alert alert-success""> "&FileName(i)&"."&ext&"<BR>Local Image Found</div>"
			FileLocation(i) = FolderName(i)&"/"&FileName(i)&"."&ext
		Else
	
			FilePath = (server.mappath("/"&FolderName(i)&"/"&FileName(i)))
		
			If (FSO.FileExists(FilePath)) Then
				Msg(i) = "<div class=""alert alert-success""> "&FileName(i)&"."&ext&"<BR>Remote Image Found</div>"
				FileLocation(i) = "/"&FolderName(i)&"/"&FileName(i)&"."&ext
			Else
				Msg(i) = "<div class=""alert alert-error""> "&FileName(i)&"<BR>Image Not Found<Br></div>"
				FileLocation(i) = ""
			End If

		End If
		
	Next
	
Next

set FSO = nothing

%>


<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>knowledgeBase</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">
	
    <link href="//fonts.googleapis.com/css?family=Signika+Negative:400,700" rel="stylesheet" type="text/css">
	
    <!-- Le styles -->
	<link href="//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.1/css/bootstrap-combined.no-icons.min.css" rel="stylesheet">
	<link href="//netdna.bootstrapcdn.com/font-awesome/3.0.2/css/font-awesome.css" rel="stylesheet">
	  
	<style>
	body {
		position: relative;
		padding-top: 10px;
	  color: #909090;
	  border-top:5px solid #333333;
	}

	h1, h2, h3, h4, h5, h6 {
	  color: #333333;
	}

	/* Header
	-------------------------------------------------- */

	header {
	  padding: 20px 0 0 0;
	}

	.header{
	  border-bottom:1px solid #eeeeee;
	}

	#header-nav {
	  padding: 15px 0 0 0;
	}

	.header h1 {
	  font-family: 'Signika Negative', sans-serif;
	  font-weight: 700; 
	  font-size:40px;
	  line-height: 42px;
	}

	.header h1 span {
	  color:#08C; 
	}

	.header h1 a{
	  color:#333333;
	}

	.header h1 a:hover{
	  color:#333333;
	  text-decoration: none;
	}

	.tinynav { display: none }


	/* Brand
	-------------------------------------------------- */

	body > .navbar .brand {
		padding-right: 0;
		padding-left: 0;
		margin-left: 20px;
		float: right;
		font-weight: bold;
		color: #000;
		text-shadow: 0 1px 0 rgba(255,255,255,.1), 0 0 30px rgba(255,255,255,.125);
	  -webkit-transition: all .2s linear;
		 -moz-transition: all .2s linear;
			  transition: all .2s linear;
	}
	body > .navbar .brand:hover {
		text-decoration: none;
		text-shadow: 0 1px 0 rgba(255,255,255,.1), 0 0 30px rgba(255,255,255,.4);
	}



	/* Faded out hr */
	hr.soften {
		height: 1px;
		margin: 70px 0;
		background-image: -webkit-linear-gradient(left, rgba(0,0,0,0), rgba(0,0,0,.1), rgba(0,0,0,0));
		background-image:    -moz-linear-gradient(left, rgba(0,0,0,0), rgba(0,0,0,.1), rgba(0,0,0,0));
		background-image:     -ms-linear-gradient(left, rgba(0,0,0,0), rgba(0,0,0,.1), rgba(0,0,0,0));
		background-image:      -o-linear-gradient(left, rgba(0,0,0,0), rgba(0,0,0,.1), rgba(0,0,0,0));
		border: 0;
	}

	/* Homepage
	-------------------------------------------------- */
	.lead-txt {
	  text-align: center;
	  margin: 30px 0 40px 0;
	  border-bottom: 1px solid #EEEEEE;
	}

	.lead-txt p {
	  font-size: 30px;
	  line-height: 36px;
	  color: #333333;
	}

	.latest-projects {
	  padding: 50px 0 50px 0;
	}

	.projects-title, .blog-title {
	  border-bottom:1px solid #eeeeee;
	  margin-bottom: 20px;
	}

	.projects-title h5, .blog-title h5 {
	  text-transform: uppercase;
	}

	.latest-projects h6 {
	  text-align: center;
	}

	.latest-blog h4.single-title{
	  margin-bottom: 3px;
	}

	.latest-blog .meta {
	  font-size: 11px;
	}

	/* Titles
	-------------------------------------------------- */
	h1.page-title {
	  font-weight: 300;
	  letter-spacing: -0.1px;
	  margin: 25px 0;
	  font-size: 28px;
	  padding: 0 0 20px;
	  border-bottom: 1px solid #EEE;
	}

	h5.sidebar-title {
	  color: #414141;
	  font-weight: 400;
	  text-transform: uppercase;
	  margin: 0 0 12px;
	}

	h3.post-tile {
	  margin: 0;
	  line-height: 28px;
	}

	/* Portfolio
	-------------------------------------------------- */
	#portfolio-filter {
	  margin: 0 0 15px 0;
	  }


	/* Blog
	-------------------------------------------------- */
	.blog-post {
	  border-bottom: 1px dotted #CED8DF;
	  margin: 0 0 50px;
	  padding: 0 0 30px;
	}

	.post-image {
	  margin:0 auto 15px;
	}

	.blog-post .meta {
	  padding: 0 0 10px 0;
	}

	/* Sidebar
	-------------------------------------------------- */
	.widget {
	  margin: 0 0 50px 0;
	}

	.widget li {
	  padding:0 0 3px 0;
	}

	/*  Comments
	 -------------------------------------------------- */

	.comments-list {
	  border-bottom: 1px dotted #ced8df;
	  margin: 27px 0 45px;
	  padding: 0 0 30px;
	  overflow: hidden;
	}

			.comment {
			  border-top: 1px dotted #ced8df;
			  list-style: none;
			  margin: 30px 0 0;
			  padding: 35px 0 0;
			}

			.comment:first-child {
			  border-top: none;
			  margin-top: 0;
			  padding-top: 0;
			}

			  .comment > article {
				margin: 0;
				overflow: hidden;
			  }

				.comment .avatar {
				  background: #fff;
				  margin: 0 0 5px 0;
				  position: relative;
				  width: 70px;
				  z-index: 1;
				}

				.comment .comment-meta { margin-bottom: 0; }

				  .comment .author, .comment .author a {
					color: #54555a;
					margin: 0;
				  }

				  .comment .author .comment-reply-link { font-size: 11px; }

				  .comment .date, .comment .date a {
					color: #adb3b8;
					font-style: italic;
					margin: 1px 0 5px;
				  }

					.comment .author a:hover, .comment .date a:hover { color: #f15a23; }

			  .comment .children {
				margin: 0;
				padding: 30px 0 0 70px;
				position: relative;
			  }

	.comment .children .comment {
	  border-top: 1px dotted #ced8df;
	  margin: 30px 0 0;
	  padding: 35px 0 0;
	  position: relative;
	}

	.comment .children .comment:first-child { margin-top: 0; }


	.comments-form .input-block {
	  float: left;
	  margin: 0 30px 20px 0;
	}


	/* Footer
	-------------------------------------------------- */

	.footer {
		padding: 20px 0;
		margin-top: 30px;
		border-top: 1px solid #E5E5E5;
		background-color: #3A3A3A;
	  font-size: 12px;
	  color: #868686;
	}

	.footer-two li a {
	  color: #868686;
	  border-left: 1px solid #505050;
	  padding: 0 15px;
	  font-size: 11px;
	  text-transform: uppercase;
	}

	.footer-two li a {
	  text-transform: none;
	}

	.footer-two li:first-child a {
	  border-left: none;
	  padding-left: 0;
	}

	.footer-two {
	  background: #303030;
	  line-height: 17px;
	  padding: 12px 0;
	}

	.footer p {
		margin-bottom: 10px;
		color: #777;
	}

	.footer-two .footer-links li {
		display: inline;
	}

	ul.footer-links {
	  margin-left: 0;
	}

	.footer-two ul.footer-links {
	  margin-left: 0;
	  margin-bottom: 0;
	}

	.footer .footer-links {
	  width: 49%;
	  display: inline-block;
	}

	.footer .footer-links li a {
	  color: #868686;
	}

	.footer .icon-large {
	  font-size: 22px;
	  text-align: center;
	  padding-right: 4px;
	}

	.footer h3 {
	  font-size: 22px;
	  line-height: 31.5px;
	  color: #868686;
	}

	.footer li {
	  border-bottom: 1px solid #505050;
	  padding: 5px 0;
	  margin-right: 30px;
	}

	.footer-social {
	  font-size: 50px;
	  margin: 15px 0;
	}

	.footer-social a{
	  color: #b1b1b1;
	  text-decoration: none;
	  line-height: 40px
	}

	.footer-social a:hover{
	  color: #08C;
	  text-decoration: none;
	}



	/* Responsive
	-------------------------------------------------- */

	/* Desktop large
	------------------------- */
	@media (min-width: 1200px) {
	  .inner-container {
		max-width: 970px;
	  }
	  .inner-sidenav {
		width: 258px;
	  }
	}

	/* Desktop
	------------------------- */
	@media (max-width: 980px) {
	  /* Unfloat brand */
	  body > .navbar-fixed-top .brand {
		float: left;
		margin-left: 0;
		padding-left: 10px;
		padding-right: 10px;
	  }

	   #header-nav .pull-right {
		float: none;
	  }

	}

	/* Tablet to desktop
	------------------------- */
	@media (min-width: 768px) and (max-width: 980px) {
	  /* Remove any padding from the body */
	  body {
		padding-top: 0;
	  }

	  #header-nav .pull-right {
		float: none;
	  }
	  
	}

	/* Tablet
	------------------------- */
	@media (max-width: 768px) {
	  /* Remove any padding from the body */
	 body {
		padding-top: 0;
	  }

	.footer, .footer-two {
		margin-left: -20px;
		margin-right: -20px;
		padding-left: 20px;
		padding-right: 20px;
	  }

	.footer p {
		margin-bottom: 9px;
	  }
	}

	/* styles for mobile 
	------------------------- */
	@media screen and (max-width: 600px) {
		.tinynav { display: block; width: 100%; }
		.nav { display: none }
	}

	/* Landscape phones
	------------------------- */
	@media (max-width: 480px) {
	  /* Remove padding above jumbotron */
	body {
		padding-top: 0;
	  }

	  /* Change up some type stuff */
	h2 small {
		display: block;
	  }

	table code {
		white-space: normal;
		word-wrap: break-word;
		word-break: break-all;
	  }

	 
	.footer .pull-right {
		float: none;
	  }
	}

	</style>


	<!-- Green Theme Style Sheet -->	
	<style>
	
	.accordion-heading-success { background-clip: padding-box; background-color: #FFFFFF; border: 1px solid rgba(0, 0, 0, 0.3); border-radius: 6px 6px 6px 6px;  box-shadow: 0 3px 7px rgba(0, 0, 0, 0.3); outline: medium none; top: 10%;}
	.accordion-inner-success { background-color: #ffffff;}
	
	a 			{color: #1f3a1f; text-decoration: none;}
	a:link 		{color:#2d542d;  text-decoration: none;}
	a:visited 	{color:#2d542d;  text-decoration: none;}
	a:hover 	{color:#2d542d;  text-decoration: none;}
	a:focus 	{color:#2d542d;  text-decoration: none;}
	a:active 	{color:#2d542d;  text-decoration: none;}
	
	.minibar {font-size: 12px;}
	.minibar a {padding-left: 2px; padding-right: 10px; }
	.minibar i {color: #000000; padding-left: 10px; padding-right: 2px; font-size: 14px;}
	
	.nav-pills-success > .active > a, .nav-pills > .active > a:hover, .nav-pills > .active > a:focus { background-color: #5BB75B; color: #FFFFFF;}
	
	.header-success h1 span  {color: #51A351;}

	.alert-success h1 {color: #468847;}
	.alert-success h2 {color: #468847;}
	.alert-success h3 {color: #468847;}
	.alert-success h4 {color: #468847;}

	.inverse-success {background-color: #ffffff; border-color: #468847;}

	.alert-info h1 {color: #3A87AD;}
	.alert-info h2 {color: #3A87AD;}
	.alert-info h3 {color: #3A87AD;}
	.alert-info h4 {color: #3A87AD;}

	.inverse-info {background-color: #ffffff; border-color: #3A87AD;}
	

	
	
table.eticket { border: 1px solid #f1f1f1; }
table.eticket th { color: #000000;}
table.eticket td { color: #000000; }

table.info { border: 1px solid #f1f1f1; }
table.info th { color: #000000; }
table.info td { color: #000000; line-height: 14px;}
	
	</style>

<!-- File Listing Style Sheet -->
<style>
.nav-list {font-size: 14px;}
.breadcrumb a:link {color:#1AAEFF;}      /* unvisited link */
.breadcrumb a:visited {color:#1AAEFF;}  /* visited link */
.breadcrumb a:hover {color:#FF00FF;}  /* mouse over link */
.breadcrumb a:active {color:#1AAEFF;}  /* selected link */ 
.page-header { border-bottom: 1px solid #333333; margin: 20px 0 30px; padding-bottom: 9px; }
.page-header { color: #3A87AD; }
.page-header  {border: 1px solid #BCE8F1 ; border-radius: 4px 4px 4px 4px;  margin-bottom: 10px; padding: 0px 0px 0px 14px;  text-shadow: 0 1px 0 rgba(255, 255, 255, 0.5); }
</style>

    <!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->

     <!--[if IE 7]>
     <link href="//netdna.bootstrapcdn.com/font-awesome/3.0.2/css/font-awesome-ie7.css" rel="stylesheet">
    <![endif]-->

    <!-- Le fav and touch icons -->
    <link rel="shortcut icon" href="assets/ico/favicon.ico">
    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="img/apple-touch-icon-144-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="img/apple-touch-icon-114-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="72x72" href="img/apple-touch-icon-72-precomposed.png">
    <link rel="apple-touch-icon-precomposed" href="img/apple-touch-icon-57-precomposed.png">

  
  </head>

  <body>

<header>
	<div class="container">
        <div class="header">
			<div class="row">
				<div class="span6">
				  <h1><a href="list.asp">e<span>Ticket</span> formater</a></h1>
				</div>
				<div class="span6" id="header-nav">
					<ul class="nav nav-pills pull-right">
						<li class="active"><a href="list.asp">Home</a>
						<li> <a href="edit.asp?new=yes">Add New</a>						
						<li><a href="list.asp?displayxml=yes">View XML</a></li>
					</ul>
				</div>
			</div>
		</div>
	</div>
</header>

<div class="container">

<div class="span8">

	<div style="border: 1px solid  #909090; border-radius: 4px 4px 4px 4px; margin-left: 10px; margin-top: 25px;">
		<CENTER>
		<TABLE WIDTH="620" BORDER="0" class="eticket">
		<FONT FACE="Arial, Helvetica" SIZE="4"><B>THIS IS YOUR TICKET.  <FONT FACE="Arial, Helvetica" SIZE="3">Present this entire page at the event.</B></FONT>
		<BR>
		<TR>
		<TD VALIGN="top">
		<TABLE WIDTH="615" HEIGHT="240" BORDER="1" BACKGROUND="<%=FileLocation(1)%>" BGCOLOR="#FFD718" CELLPADDING="0" CELLSPACING="0">

		<TR>
		<TD WIDTH="500" VALIGN="top">
		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="100%">
		<TR>
		<TD WIDTH="220" HEIGHT="70" VALIGN="top">
		<IMG SRC="<%=FileLocation(2)%>">
		</TD>
		<TD VALIGN="top" ALIGN="right">
		<FONT FACE="Verdana,Arial,Helvetica" SIZE="1">3918-8872-2899-8426-13935&nbsp;&nbsp;&nbsp;&nbsp;14711068 - 130629574</FONT></TD>
		</TD>
		</TR>
		</TABLE>
		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="100%">
		<TR>
		<TD WIDTH="20">

		&nbsp;
		</TD>
		<TD VALIGN="top">
		<FONT FACE="Arial,Helvetica" SIZE="2"><I>Downtown Theater Presents</I></FONT><BR>
		<FONT FACE="Arial,Helvetica" SIZE="5"><B>Audible Occamy </B></FONT><BR>
		<FONT FACE="Arial,Helvetica" SIZE="3"><B>Locotini</B></FONT><BR>
		<FONT FACE="Arial,Helvetica" SIZE="3">Friday, June 12, 2015 at 8:00 PM</FONT><BR><BR>
		<FONT FACE="Arial,Helvetica" SIZE="2">Individual  $30.00</FONT><BR>
		<FONT FACE="Arial,Helvetica" SIZE="2"><B>Section: TABLE F10B&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Row: F10B&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Seat: F10B</B></FONT><BR>

		</TD>
		</TR>
		</TABLE>
		</TD>
		<TD ALIGN="center" VALIGN="center">
		<IMG alt="Barcode Image" src="/Barcode.asp?Barcode=391888722899842613935&Rotate=270">&nbsp;
		</TD>
		</TR>
		<TR>
		<TD ALIGN="center" COLSPAN="2" VALIGN="bottom" BGCOLOR="#000000" HEIGHT="20">
		<IMG SRC="<%=FileLocation(3)%>">
		</TD>
		</TR>
		</TABLE>
		</TD>
		</TR>
		</TABLE>

		<TABLE WIDTH="620" BORDER="0" class="info">
		<TR>
		<TD VALIGN="top" WIDTH = "33%">
		<FONT FACE="Arial, Helvetica" SIZE="2">
		<B>ORDER INFORMATION</B><BR>
		Order Number:&nbsp;&nbsp;14711068<BR>
		Order Date:&nbsp;&nbsp;4/10/2013<BR>
		Order Time:&nbsp;&nbsp;17:40<BR>
		Order Total:&nbsp;&nbsp;$30.25<BR>

		<BR>
		<B>BILLING INFORMATION</B><BR>
		Sergio Rodriguez<BR>
		110 W. Ocean Blvd<BR>
		Long Beach, CA 90802<BR>
		<BR>
		<B>ATTENDEE INFORMATION</B><BR>
		Sergio Rodriguez<BR>
		110 W. Ocean Blvd<BR>
		Long Beach, CA 90802<BR>

		<BR>
		</FONT>
		</TD>
		<TD VALIGN="top" WIDTH="33%">
		<FONT FACE="Arial, Helvetica" SIZE="2">
		<B>VENUE INFORMATION</B><BR>
		Locotini<BR>
		110 West Ocean Blvd<BR>
		10th Floor<BR>
		Long Beach, CA 90802<BR>
		Phone: <BR>

		<BR>
		</FONT>
		</TD>
		<TD VALIGN="top" WIDTH="34%">
		<IMG alt="Barcode Image" src="/Barcode.asp?Barcode=391888722899842613935"><BR>
		<BR>
		</FONT>
		</TD>
		</TR>
		</TABLE>
		<TABLE WIDTH="620" BORDER="0" CELLPADDING="0" CELLSPACING="0" class="info">
		<TR>
		<TD>
		<FONT FACE="Arial, Helvetica" SIZE="2">
		<B>GENERAL INFORMATION</B><BR>
		</FONT>

		<FONT FACE="Arial, Helvetica" SIZE="1">
		NO REFUNDS - NO EXCHANGES.  DO NOT COPY THIS TICKET.  MULTIPLE COPIES INVALID.  Holder assumes all risk and danger including, without limitation, injury, death, personal loss, property damage, or other related harm.  Management reserves the right to refuse admission or eject any person who fails to comply with the terms and conditions and/or rules for the event in which this ticket is issued.
		</FONT>
		</TD>
		</TR>
		</TABLE>
		<TABLE WIDTH="620" BORDER="0" CELLPADDING="0" CELLSPACING="0">
		<TR>
		<TD ALIGN="center">
		<HR>
		</TD>
		</TR>
		</TABLE>
		<TABLE WIDTH="620" BORDER="0" CELLPADDING="0" CELLSPACING="0">
		<TR>
		<TD ALIGN="center">
		<IMG SRC="/Images/ETicketTixLogo.gif" HEIGHT="200">

		</TD>
		</TR>
		</TABLE>
		</CENTER>	
	</div>
	
</div>
	
	<div class="span3" style="border: 1px solid  #909090; border-radius: 4px 4px 4px 4px; margin-top: 25px;">
		<%
		Response.Write "<br>" & vbCrLf
		Response.Write "<br>" & vbCrLf

		Response.Write Msg(1)
		Response.Write Msg(2)
		Response.Write Msg(3)
		Response.Write ActMsg
		%>
	</div>
	
</div>



 <!-- Javascripot 
    ================================================== -->
<!-- Placed at the end of the document so the pages load faster -->
<script src="http://ajax.aspnetcdn.com/ajax/jquery/jquery-1.7.2.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<script src="js/bootstrap-transition.js"></script>



<script src="js/wysihtml5-0.3.0.min.js"></script>
<script src="js/bootstrap-wysihtml5-0.0.2.min.js"></script>
<script src="js/select2.min.js"></script>

<script>
	$(document).ready(function() { $("#category").select2(); });
</script>

<script>
	$(document).ready(function() { $("#status").select2(); });
</script>

<script>
	$(document).ready(function() { $("#access").select2(); });
</script>

<script >
	$(document).ready(function () {
		$("#tags").select2({tags:["red", "green", "blue"]});
	});
</script>

<script>
$('#story').wysihtml5({
	"font-styles"	: true,	//Font styling, e.g. h1, h2, etc. Default true
	"emphasis"		: true, //Italics, bold, etc. Default true
	"lists"			: true, //(Un)ordered lists, e.g. Bullets, Numbers. Default true
	"html"			: true, //Button which allows you to edit the generated HTML. Default false
	"link"			: true, //Button to insert a link. Default true
	"image"			: true, //Button to insert an image. Default true,
	"color"			: true 	//Button to change color of font  
});
</script>



</body>
</html>
	

