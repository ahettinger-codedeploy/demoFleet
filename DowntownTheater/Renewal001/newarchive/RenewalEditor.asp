<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp"-->
<!--#INCLUDE VIRTUAL="TicketPrintInclude.asp"-->
<!--#INCLUDE VIRTUAL="NoCacheInclude.asp"-->
<%

'CHANGE LOG
'JAI 4/23/13 - New script for TheatreZone renewals.
'JAI 4/16/14 - Uodated for 2014 TheatreZone renewals.
'SSR 4/21/14 - Updated renewal letter

Server.ScriptTimeout = 3600

Page = "ManagementMenu"

'Make sure the correct Session variables are in place.  If not clear the variables and go to the menu.
If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then 
'	Session.Abandon
'	Response.Redirect("/Default.asp")
End If

If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then 
'	Session.Abandon
'	Response.Redirect("Default.asp")
End If

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
<html>
	<head>
		<title>Support</title>
		
		<!-- Force IE to turn off past version compatibility mode and use current version mode -->
		<meta http-equiv="X-UA-Compatible" content="IE=edge;chrome=1">
		
		<!-- Get the width of the users display-->
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		
		<!-- Text encoded as UTF-8 -->
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		
		<link href='httpS://fonts.googleapis.com/css?family=Lato:100,300,400,700,900' rel='stylesheet' type='text/css'>
		<link href='httpS://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700,800' rel='stylesheet' type='text/css'>
		<link href='httpS://fonts.googleapis.com/css?family=Signika+Negative:400,700' rel='stylesheet' type='text/css'>
		  
		<!-- icons -->
		<link href="https://netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.min.css" rel="stylesheet">
		
		<!-- jquery ui -->
		<link href="httpS://code.jquery.com/ui/1.10.2/themes/smoothness/jquery-ui.css" rel="stylesheet" />
		
		<!-- bootstrap -->
		<link href="httpS://netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css" rel="stylesheet" id="default">
		
		<!-- theme -->
		<link href="httpS://netdna.bootstrapcdn.com/bootswatch/3.1.1/bootstrap/bootstrap.min.css" rel="stylesheet" title="theme">

		<style>	
		/* fix page shifing issue */

		html { overflow-y: scroll;}

		/* remove outline and underscore from buttons - nasty things I hate 'em*/

		a.btn:active { outline:0;   text-decoration:none; } 
		a.btn:focus  { outline:0;   text-decoration:none; }

		button.btn:active { outline:0;   text-decoration:none; }
		button.btn:focus  { outline:0;   text-decoration:none; }

		/* page tabs */

		ul.dropdown-menu li a:active { outline:0;  text-decoration:none; }
		ul.dropdown-menu li a:focus  { outline:0;  text-decoration:none; }

		ul.nav-tabs { margin-bottom: 25px;}

		ul.nav-tabs li a {outline:0;  text-decoration:none; font-size: 10pt;}
		ul.nav-tabs li a:active  {outline:0;  text-decoration:none;}
		ul.nav-tabs li a:focus 	 {outline:0;  text-decoration:none;}

		ul.nav-tabs > li.active > a, 
		ul.nav-tabs > li.active > a:link,
		ul.nav-tabs > li.active > a:visited,
		ul.nav-tabs > li.active > a:hover { border-top: 4px solid #008400; color: #000000;}

		ul.nav-tabs > li > a, 
		ul.nav-tabs > li > a:link,
		ul.nav-tabs > li > a:visited { border-top: 4px solid #f8f8f8; color: #999999;}

		ul.nav-tabs > li > a:hover { border-top: 4px solid #bebebe; color: #999999;}

		ul.nav-tabs > li { float: left; margin-bottom: -1px; }
		ul.nav-tabs > li > a { margin-right: 2px; line-height: 1.42857; border: 1px solid transparent; border-radius: 0px; }

		.table-fade
		{
		opacity: 0;
		}

		/* transition animation between page views */
		#wrapper * { -webkit-transition: all .5s ease-in-out; -moz-transition: all .5s ease-in-out; -ms-transition: all .5s ease-in-out; transition: all .5s ease-in-out;}

		/* table */
		th { background: #555555; color: #ffffff; }
		</style>
		
		<style>
		.note-editor { border: 1px solid rgb(169, 169, 169); }
		.note-editor .note-dropzone { position: absolute; z-index: 1; display: none; color: rgb(135, 206, 250); background-color: white; border: 2px dashed rgb(135, 206, 250); opacity: 0.95; }
		.note-editor .note-dropzone .note-dropzone-message { display: table-cell; font-size: 28px; font-weight: bold; text-align: center; vertical-align: middle; }
		.note-editor .note-toolbar { padding-bottom: 5px; padding-left: 5px; margin: 0px; background-color: rgb(245, 245, 245); border-bottom: 1px solid rgb(169, 169, 169); }
		.note-editor .note-toolbar > .btn-group { margin-top: 5px; margin-right: 5px; margin-left: 0px; }
		.note-editor .note-toolbar .note-table .dropdown-menu { min-width: 0px; padding: 5px; }
		.note-editor .note-toolbar .note-table .dropdown-menu .note-dimension-picker { font-size: 18px; }
		.note-editor .note-toolbar .note-table .dropdown-menu .note-dimension-picker .note-dimension-picker-mousecatcher { position: absolute ! important; z-index: 3; width: 10em; height: 10em; cursor: pointer; }
		.note-editor .note-toolbar .note-table .dropdown-menu .note-dimension-picker .note-dimension-picker-unhighlighted { position: relative ! important; z-index: 1; width: 5em; height: 5em; background: url('undefined') repeat scroll 0% 0% transparent; }
		.note-editor .note-toolbar .note-table .dropdown-menu .note-dimension-picker .note-dimension-picker-highlighted { position: absolute ! important; z-index: 2; width: 1em; height: 1em; background: url('undefined') repeat scroll 0% 0% transparent; }
		.note-editor .note-toolbar .note-style h1, .note-editor .note-toolbar .note-style h2, .note-editor .note-toolbar .note-style h3, .note-editor .note-toolbar .note-style h4, .note-editor .note-toolbar .note-style h5, .note-editor .note-toolbar .note-style h6, .note-editor .note-toolbar .note-style blockquote { margin: 0px; }
		.note-editor .note-toolbar .note-color .dropdown-toggle { width: 20px; padding-left: 5px; }
		.note-editor .note-toolbar .note-color .dropdown-menu { min-width: 290px; }
		.note-editor .note-toolbar .note-color .dropdown-menu .btn-group { margin: 0px; }
		.note-editor .note-toolbar .note-color .dropdown-menu .btn-group:first-child { margin: 0px 5px; }
		.note-editor .note-toolbar .note-color .dropdown-menu .btn-group .note-palette-title { margin: 2px 7px; font-size: 12px; text-align: center; border-bottom: 1px solid rgb(238, 238, 238); }
		.note-editor .note-toolbar .note-color .dropdown-menu .btn-group .note-color-reset { padding: 0px 3px; margin: 5px; font-size: 12px; cursor: pointer; border-radius: 5px; }
		.note-editor .note-toolbar .note-color .dropdown-menu .btn-group .note-color-reset:hover { background: none repeat scroll 0% 0% rgb(238, 238, 238); }
		.note-editor .note-toolbar .note-para .dropdown-menu { min-width: 216px; padding: 5px; }
		.note-editor .note-toolbar .note-para .dropdown-menu > div:first-child { margin-right: 5px; }
		.note-editor .note-statusbar { background-color: rgb(245, 245, 245); }
		.note-editor .note-statusbar .note-resizebar { width: 100%; height: 8px; cursor: s-resize; border-top: 1px solid rgb(169, 169, 169); }
		.note-editor .note-statusbar .note-resizebar .note-icon-bar { width: 20px; margin: 1px auto; border-top: 1px solid rgb(169, 169, 169); }
		.note-editor .note-popover .popover { max-width: none; }
		.note-editor .note-popover .popover .popover-content { padding: 5px; }
		.note-editor .note-popover .popover .popover-content a { display: inline-block; max-width: 200px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; vertical-align: middle; }
		.note-editor .note-popover .popover .popover-content .btn-group + .btn-group { margin-left: 5px; }
		.note-editor .note-popover .popover .arrow { left: 20px; }
		.note-editor .note-handle .note-control-selection { position: absolute; display: none; border: 1px solid black; }
		.note-editor .note-handle .note-control-selection > div { position: absolute; }
		.note-editor .note-handle .note-control-selection .note-control-selection-bg { width: 100%; height: 100%; background-color: black; opacity: 0.3; }
		.note-editor .note-handle .note-control-selection .note-control-holder { width: 7px; height: 7px; border: 1px solid black; }
		.note-editor .note-handle .note-control-selection .note-control-sizing { width: 7px; height: 7px; background-color: white; border: 1px solid black; }
		.note-editor .note-handle .note-control-selection .note-control-nw { top: -5px; left: -5px; border-right: 0px none; border-bottom: 0px none; }
		.note-editor .note-handle .note-control-selection .note-control-ne { top: -5px; right: -5px; border-bottom: 0px none; border-left: medium none; }
		.note-editor .note-handle .note-control-selection .note-control-sw { bottom: -5px; left: -5px; border-top: 0px none; border-right: 0px none; }
		.note-editor .note-handle .note-control-selection .note-control-se { right: -5px; bottom: -5px; cursor: se-resize; }
		.note-editor .note-handle .note-control-selection .note-control-selection-info { right: 0px; bottom: 0px; padding: 5px; margin: 5px; font-size: 12px; color: white; background-color: black; border-radius: 5px; opacity: 0.7; }
		.note-editor .note-dialog > div { display: none; }

		.note-editor .note-dialog .note-help-dialog { font-size: 12px; color: #666666; background-image: none; background-repeat: repeat; background-attachment: scroll; background-position: 0% 0%; background-clip: border-box; background-origin: padding-box; background-size: auto auto; border: 0px none; opacity: 0.9; }
		.note-editor .note-dialog .note-help-dialog .modal-content {  background-color: #ffffff ! important; background: none repeat scroll 0% 0% transparent; border: 1px solid #777777; border-radius: 5px; box-shadow: none; }
		.note-editor .note-dialog .note-help-dialog a { font-size: 12px; color: #777777; }
		.note-editor .note-dialog .note-help-dialog .title { padding-bottom: 5px; font-size: 14px; font-weight: bold; color: #777777; border-bottom: 1px solid #777777; }
		.note-editor .note-dialog .note-help-dialog .modal-close { font-size: 14px; color: #222222; cursor: pointer; }
		.note-editor .note-dialog .note-help-dialog .note-shortcut-layout { width: 100%; }
		.note-editor .note-dialog .note-help-dialog .note-shortcut-layout td { vertical-align: top; }
		.note-editor .note-dialog .note-help-dialog .note-shortcut { margin-top: 8px; }
		.note-editor .note-dialog .note-help-dialog .note-shortcut th { font-size: 13px; color: #222222; text-align: left; }
		.note-editor .note-dialog .note-help-dialog .note-shortcut td:first-child { min-width: 110px; padding-right: 10px; font-family: "Courier New"; color: #222222; text-align: right; }

		.note-editor .note-dialog .note-help-dialog .modal-dialog .modal-content .modal-body .modal-background p,
		.note-editor .note-dialog .note-help-dialog .modal-dialog .modal-content .modal-body .modal-background p a {color: #ffffff;}

		.note-editor .note-editable { padding: 10px; overflow: auto; outline: 0px none; }
		.note-editor .note-codable { display: none; width: 100%; padding: 10px; margin-bottom: 0px; font-family: Menlo,Monaco,monospace,sans-serif; font-size: 14px; color: rgb(204, 204, 204); background-color: rgb(34, 34, 34); border: 0px none; border-radius: 0px; box-shadow: none; -moz-box-sizing: border-box; resize: none; }
		.note-editor .dropdown-menu { min-width: 90px; }
		.note-editor .dropdown-menu li a i { color: deepskyblue; visibility: hidden; }
		.note-editor .note-fontsize-10 { font-size: 10px; }
		.note-editor .note-color-palette { line-height: 1; }
		.note-editor .note-color-palette div .note-color-btn { width: 17px; height: 17px; padding: 0px; margin: 0px; border: 1px solid rgb(255, 255, 255); }
		.note-editor .note-color-palette div .note-color-btn:hover { border: 1px solid rgb(0, 0, 0); }

		.summernote { font-family: Verdana,Helvetica,Arial,sans-serif; line-height: 1.2; color: rgb(51, 51, 51); background-color: rgb(255, 255, 255); text-align: left; padding: 0px; }
		.summernote h1, .summernote h2, .summernote h3, .summernote h4, .summernote h5, .summernote h6 { margin: 10px 0px; font-family: inherit; font-weight: bold; line-height: 1.5; color: inherit; }
		</style>
			
	</head>
	
	<BODY BGCOLOR="#FFFFFF">

	<!--#INCLUDE VIRTUAL="TopNavInclude.asp"-->
	<div id="wrapper" class="row">
		<div class="col-lg-12">

			<ul class="nav nav-tabs">
				<li ><a href="renewalLetters.asp">Letters</a></li>
				<li><a href="renewalEmail.asp">Emails</a></li>
				<li class="active"><a href="#">Editor</a></li>
			</ul>

			<FONT FACE="verdana,arial,helvetica" COLOR="#008400"><H3>Subscription Renewal Editor</H3></FONT><BR><BR>

			<section id="wrapper">

				<header> 		
					<div class="well well-sm">
						<h3>
							<span  class="text-primary"><%=HeaderName%></span>
						</h3>
					</div>
				</header>
				
				<form class="form-horizontal" METHOD="POST" name="example" ID="edit" ACTION="?">

					<div class="form-group">
						<div class="col-lg-12">
							<label for="title">Title</label>
							<input type="text" class="form-control" Name="title" placeholder="title">
						</div>
					</div>
				
				
					<div class="form-group">
						<div class="col-lg-12">
							<textarea class="summernote" id="summernote"><p></p></textarea>
						</div>
					</div>
					
					<button type="submit" class="btn btn-primary">Save</button>
					<button type="button" class="btn btn-default" id="Open" class="btn">Open</button>
						
				</form>
				
				<footer>
				
					<!--#INCLUDE VIRTUAL="FooterInclude.asp"--> 

					<!-- #INCLUDE VIRTUAL="./SergioTest/Support/tixDashboard/includes/scripts.asp" -->
					
					<script src="http://code.jquery.com/jquery-1.9.1.js" type="text/javascript" ></script>
					<script src="http://code.jquery.com/ui/1.10.2/jquery-ui.js" type="text/javascript" ></script>
					<script src="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>
					
					<script src="js/summernote.js"></script>
					
					<script type="text/javascript">
					$(document).ready(function() 
						{
							$('#summernote').summernote({height: 300, codemirror: {theme: 'monokai'}});
						});
						var postForm = function() 
						{
						var content = $('textarea[name="content"]').html($('#summernote').code());
						}
					</script>

				</footer>
				
			</section>

	</BODY>

</HTML>

<%

End Sub 'PrintMenu

%>