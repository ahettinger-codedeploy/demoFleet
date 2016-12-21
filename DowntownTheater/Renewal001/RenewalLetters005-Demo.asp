
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->

<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->

<%

'-----------------------------------------------

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

'Verify User is authorized
If CheckTixUser(UserNumber) <> True Then
	OBJdbConnection.Close
	Set OBJdbConnection = nothing
	Response.Redirect("/Management/Default.asp")
End If

Session("Timeout") = 120
Server.ScriptTimeout = 60 * 20 '20 Minutes

'-----------------------------------------------

DIM logList
DIM logFile
DIM strMode
DIM strTitle
DIM LgTab 
DIM LtTab 
DIM EmTab 
DIM TestMsg 
DIM MsgOrgName
DIM emResults
DIM xmlFileName


'-----------------------------------------------

'Decide which subroutine to route to

Call checkStatus

Select Case Request("FormName")

	Case "PrintLetters"
		Call PrintLetters	
		
	Case "SendEmails"
		Call SendEmails	
		Call SaveEmailLog
		
End Select

Call PrintMenu

'-----------------------------------------------

Sub PrintMenu

%>

<!DOCTYPE html>

	<html lang="en">

	<head>
	
	<title>Support</title>
	
	<!-- Force IE to turn off past version compatibility mode and use current version mode -->
	<meta http-equiv="X-UA-Compatible" content="IE=edge;chrome=1">
	
	<!-- Get the width of the users display-->
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	
	<!-- Text encoded as UTF-8 -->
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		
	<!-- bootstrap -->

	<link rel="stylesheet" type="text/css" href="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="http://netdna.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css">
	<link rel="stylesheet" type="text/css" href="http://oss.maxcdn.com/icheck/1.0.2/skins/all.min.css">
	<link rel="stylesheet" type="text/css" href="http://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700,800)">
	<link rel="stylesheet" type="text/css"  href="https://oss.maxcdn.com/icheck/1.0.2/skins/all.min.css">

	
	<style>
	
	/* links: outlines and underscores */  
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
	.nav-tabs li a:focus { outline:0px !important; -webkit-appearance:none;  text-decoration:none; }  
	
	</style>

	<style>
	/* panel */ 
	.panel {margin-top: 25px;}
	.panel .panel-heading { padding: 5px 5px 0 5px;}
	.panel .nav-tabs {border-bottom: none;}
	
	.panel-heading 
	{
	background-color: rgb(238, 238, 238);
	border: 0 none;
	box-shadow: 0 0 4px rgba(0, 0, 0, 0.3);
	margin-bottom: 0;
	margin-left: 0;
	top: 2px;
	}
	
	.panel-body
	{
	background-color: rgb(251, 251, 251);
	box-shadow: 1px 0 10px 1px rgba(0, 0, 0, 0.3);
	padding: 16px 12px;
	position: relative;
	}
	
	/* panel buttons */ 
	.btn-group button.btn.btn-outline.btn-default 			{ background-color: #f5f5f5; color: #676767; border-color: #dddddd; border-width: 1px; padding: 5px 15px; line-height: 2; -webkit-transition: all 0.75s; -moz-transition: all 0.75s; transition: all 0.75s; }} 
	.btn-group button.btn.btn-outline.btn-default:focus		{ background-color: #f5f5f5;} 
	.btn-group button.btn.btn-outline.btn-default:active   	{ background-color: #f5f5f5;}
	.btn-group button.btn.btn-outline.btn-default:hover 	{ background-color: #eeeeee; border-width: 1px; -webkit-transition: all 0.75s; -moz-transition: all 0.75s; transition: all 0.75s; } 
		
	</style>
	
	<style>
	/* inactive tabs */ 
	.nav > li > a				{ background-color: #f5f5f5; color: #939393; border-color: #dddddd; border-width: 1px; padding: 5px 15px; line-height: 2; -webkit-transition: all 0.75s; -moz-transition: all 0.75s; transition: all 0.75s; }} 
	.nav > li > a:active		{ background-color: #f5f5f5; color: #676767;}
	.nav > li > a:focus 		{ background-color: #f5f5f5; color: #676767;} 
	.nav > li > a:hover 		{ background-color: #eeeeee; color: #555555; border-color: #dddddd;} 
	
	/* active tabs */ 
	.nav > li.active > a:hover 	{color: #222222;} 
	</style>
	
	<style>	
	/* table */ 

	.table-fade { opacity: 0; } 

	</style>
	
	<style>
	/* buttons */ 

	.btn-outline.btn-highlight	{ color: #676767; border-color: #676767; background-color: transparent; border-width: 2px;}
	
	.btn-sm, 
	.btn-group-sm > .btn { padding: 5px 7px; font-size: 12px; line-height: 1.5; border-radius: 3px; }

	.btn-group .btn + .btn, 
	.btn-group .btn + .btn-group, 
	.btn-group .btn-group + .btn, 
	.btn-group .btn-group + .btn-group { margin-left: 0px; }

	.btn-default { color: rgb(255, 255, 255); border: 0px none rgb(192, 194, 199); background-color: rgb(192, 194, 199); }

	.btn-default:hover, 
	.btn-default:focus, 
	.btn-default:active, 
	.btn-default.active, 
	.open .dropdown-toggle.btn-default { color: rgb(255, 255, 255); background-color: rgb(167, 170, 177); border-color: rgb(192, 194, 199); }

	.btn:focus, 
	.btn:active:focus, 
	.btn.active:focus { outline: medium none; }
	.btn-default.btn-outline:active,
	.btn-default.btn-outline:focus, 
	.btn-default.btn-outline 		{ color: #676767; border-color: #676767; background-color: transparent; border-width: 2px; -webkit-transition: all 0.25s; -moz-transition: all 0.25s; transition: all 0.25s;} 	
	.btn-default.btn-outline:hover 	{ color: #000000; border-color: #000000; background-color: transparent; border-width: 2px; -webkit-transition: all 0.75s; -moz-transition: all 0.75s; transition: all 0.75s; } 

	
	/* big buttons */ 

	.btn i { font-weight: 300;}

	.big-icons-buttons i { font-size: 30px; padding: 3px; display: block; clear: both; }
	.big-icons-buttons .btn { font-size: 0.85em; padding: 4px 7px; }
	.btn { font-weight: 600; font-family: 'Open Sans',sans-serif; transition: background 0.2s ease 0s; padding: 9px 12px; border: 0px none; }

	</style>
	
	<style>
	.display-title { font family: verdana, arial, helvetica; color:#008400;}
	
	.container {margin: 35px;}
	</style>
		
	<style>

	/* ========================================================================
	* Boostrap Tables
	* ======================================================================== */

	.table h1,
	.table h2,
	.table h3,
	.table h4,
	.table h5 
	{
	margin: 0;
	margin-bottom: 2px
	}

	.table 
	{
	border-top: 0;
	background: #fff;
	}

	.table .num 
	{
	font-size: 0.8em;
	display: inline-block;
	padding: 7px;
	width: 29px;
	text-align: center;
	border-radius: 35px;
	color: #fff;
	font-weight: 700;
	background-color: #d3d3d3;
	}

	.table .label 
	{
	font-size: .75em;
	display: inline-block;
	margin: 2px;
	}

	.table > thead > tr > th,
	.table > tbody > tr > th,
	.table > tfoot > tr > th,
	.table > thead > tr > td,
	.table > tbody > tr > td,
	.table > tfoot > tr > td 
	{
	padding: 6px 8px;
	vertical-align: middle;
	border-top: 1px solid #e2eae9;
	}

	.table > thead > tr > th 
	{
	background: #73716e;
	color: #fff;
	font-size: .87em;
	letter-spacing: 1px;
	text-transform: uppercase;
	font-weight: 700;
	border: 1px solid #73716e
	padding: 7px 10px;
	border-bottom: 7px solid #ddd
	}

	.table > tfoot > tr > th 
	{
	background: #ddd;
	color: #999;
	font-size: .87em;
	letter-spacing: 1px;
	text-transform: uppercase;
	font-weight: 700;
	border: 1px solid #ddd;
	padding: 7px 10px;
	}

	.table > tbody > tr:last-child 
	{ 
	border-bottom: 3px solid #ddd
	}

	.table-hover > tbody > tr:hover > td,
	.table-hover > tbody > tr:hover > th { background-color: #d8e3e6; }

	.table-hover > tbody > tr:hover > td .num,
	.table-hover > tbody > tr:hover > th .num { background-color: #858689; }

	/*Tables with Transparent thead and tfoot - the r air like*/

	.table.airtable > thead > tr > th {
	color: #858689;
	background: transparent;
	font-size: .87em;
	letter-spacing: 1px;
	text-transform: uppercase;
	font-weight: 700;
	border: 1px solid #fff;
	padding: 7px 10px;
	border-bottom: 7px solid #ddd
	}

	.table.airtable > tfoot > tr > th {
	background: transparent;
	color: #999;
	font-size: .87em;
	letter-spacing: 1px;
	text-transform: uppercase;
	font-weight: 700;
	border: 1px solid #fff;
	border-top: 7px solid #ddd;
	padding: 7px 10px;
	}

	/*Dark Tables*/

	.table.table-dark { border-top: 0 }

	.table.table-dark .num {
	color: #fff;
	background-color: #595F66;
	}

	.table.table-dark > thead > tr > th,
	.table.table-dark > tfoot > tr > th 
	{
	background: #595F66;
	color: #fff;
	font-size: .87em;
	letter-spacing: 1px;
	text-transform: uppercase;
	font-weight: 700;
	border: 1px solid #595F66;
	padding: 7px 10px;
	border-bottom: 7px solid #33383d
	}

	.table.table-dark > tbody > tr > td 
	{
	background: #33383d;
	border-top: 1px solid #33363b;
	color: #fff;
	}

	.table-striped.table-dark > tbody > tr:nth-child(odd) > td,
	.table-striped.table-dark > tbody > tr:nth-child(odd) > th { background-color: #454B52; }

	.table-hover.table-dark > tbody > tr:hover > td,
	.table-hover.table-dark > tbody > tr:hover > th 
	{
	background-color: #595F66;
	transition: background .2s ease-in-out; /*Annoyable Transition as a Experient*/
	}

	.table-hover.table-dark > tbody > tr:hover > td .num,
	.table-hover.table-dark > tbody > tr:hover > th .num { background-color: #3c4250; }

	.table-bordered.table-dark > tbody > tr > th,
	.table-bordered.table-dark > tfoot > tr > th,
	.table-bordered.table-dark > tbody > tr > td,
	.table-bordered.table-dark > tfoot > tr > td { border: 1px solid #454B52; }

	</style>

	
		</head>

		<body class="bootstrap">
		
			<!--#INCLUDE VIRTUAL="TopNavInclude.asp" -->
			
			<section id="wrapper">
			
				<div class="col-md-12"> 
						
					<div class="panel panel-default panel-fade">
					
						<div class="panel-heading">
					   
							<span class="panel-title">
							
								<div class="pull-left">
								
									<ul class="nav nav-tabs">

										<li class="<%=ltTab%>">	
											<a href="?mode=letters">
												<i class="glyphicon glyphicon-print"></i>											
												Letters
											</a>
										</li>
										
										<% 
										If CheckTixUser(UserNumber) <> False Then
										%>
										<li class="<%=emTab%>">		
											<a href="?mode=emails">
												<i class="glyphicon glyphicon-send"></i>
												Emails
											</a>
										</li>
										<li class="<%=lgTab%>">		
											<a href="?mode=logs">
												<i class="glyphicon glyphicon-list"></i>
												Logs
											</a>
										</li>
										<% 
										End If 
										%>
										
									</ul>
									
								</div>
								
								<div class="btn-group pull-right">
									<div class="btn-group">
										<button type="button" class="btn btn-default btn-outline dropdown-toggle" data-toggle="dropdown">
											<i class="glyphicon glyphicon-cog"></i> Options
											<span class="caret"></span>
										</button>
										
									</div>
								</div>

								<div class="clearfix"></div>

							</span>
							
						</div>

						<div class="panel-body">
						
							<H4 class="display-org"><%=MsgOrgName%></H4>
							<H4 class="display-title"><%=strTitle%></H4>
							<H5 class="display-test"><%=TestMsg%></H5>	

							<%
							
							Select Case strMode
								Case "letters"
									Call DisplayLetters
								Case "emails"
									Call DisplayEmails
								Case "loglists"
									Call DisplayLogList		
								Case "logs"
									Call DisplayLog									
							End Select
						
							%>
					
						</div>

					</div>
						
				</div>
						
			</section>
			
			<footer>
			
				<!--#INCLUDE VIRTUAL="FooterInclude.asp"--> 
				
				<script type="text/javascript" language="javascript" src="http://code.jquery.com/jquery-1.10.2.min.js"></script>
				<script type="text/javascript" language="javascript" src="http://cdn.datatables.net/1.10.2/js/jquery.dataTables.min.js"></script>
				<script type="text/javascript" language="javascript" src="http://cdn.datatables.net/plug-ins/725b2a2115b/integration/bootstrap/3/dataTables.bootstrap.js"></script>
				<script type="text/javascript" language="javascript" src="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>
				<script type="text/javascript" language="javascript" src="https://cdn.jsdelivr.net/icheck/1.0.2/icheck.min.js"></script>

				<script type="text/javascript">

					function icheck() 
					{
						$('input').iCheck(
						{
							checkboxClass: 'icheckbox_square-grey',
							radioClass: 'iradio_square-grey',
							increaseArea: '20%'
						});
					}
					 
					icheck();            
							
				</script>
				
				<script type="text/javascript" charset="utf-8">
					$(document).ready(function() 
						{
						$('#example').dataTable( 
						{
							"paging":   false,
							"ordering": true,
							"info":     false,
							"filter":	false
						});
					});
				</script>
				
				
				<script type="text/javascript">
					$(".table-fade").delay(25).animate({"opacity": "1"}, 1000);
				</script>

			</footer>

		</body>
		
	</html>

<%

End Sub

Sub DisplayLetters

	%>

	<FORM ACTION="" METHOD="post">
		<INPUT TYPE="hidden" NAME="FormName" VALUE="PrintLetters">
		<table class="table table-striped" id="example">
		<THEAD>
			<TR><TH>Print</TH><TH style="text-align:left">Subscription</TH><TH style="text-align:left">Venue</TH><TH>Date/Time</TH><TH>Quantity</TH></TR>
		</THEAD>
		<TBODY>
			<TR><TD><INPUT TYPE="checkbox" NAME="EventCode" VALUE=588031></TD><TD>Season Subscription (Winter)</TD><TD>Downtown Theater</TD><TD>1/1/2015 12:00 PM</TD><TD>8</TD></TR>
			<TR><TD><INPUT TYPE="checkbox" NAME="EventCode" VALUE=588031></TD><TD>Season Subscription (Spring)</TD><TD>Downtown Theater</TD><TD>1/1/2015 12:00 PM</TD><TD>8</TD></TR>
			<TR><TD><INPUT TYPE="checkbox" NAME="EventCode" VALUE=588031></TD><TD>Season Subscription (Summer)</TD><TD>Downtown Theater</TD><TD>1/1/2015 12:00 PM</TD><TD>8</TD></TR>
			<TR><TD><INPUT TYPE="checkbox" NAME="EventCode" VALUE=588031></TD><TD>Season Subscription (Fall)</TD><TD>Downtown Theater</TD><TD>1/1/2015 12:00 PM</TD><TD>8</TD></TR>
		</TBODY>
		</TABLE>
		Select events and click below<BR><BR>
		<INPUT TYPE="submit" CLASS="btn btn-outline btn-default" VALUE="Submit">
	</FORM>

	<%

End Sub

'-------------------------------------------------
	
Sub DisplayEmails
	
	%>

	<FORM ACTION="" METHOD="post">
		<INPUT TYPE="hidden" NAME="FormName" VALUE="SendEmails">
		<TABLE class="table table-striped table-fade">
		<THEAD>
			<TR><TH>Print</TH><TH style="text-align:left">Subscription</TH><TH style="text-align:left">Venue</TH><TH>Date/Time</TH><TH>Quantity</TH></TR>
		</THEAD>
		<TBODY>
			<TR><TD><INPUT TYPE="checkbox" NAME="EventCode" VALUE=588031></TD><TD>Season Subscription (Winter)</TD><TD>Downtown Theater</TD><TD>1/1/2015 12:00 PM</TD><TD>6</TD></TR>
			<TR><TD><INPUT TYPE="checkbox" NAME="EventCode" VALUE=588031></TD><TD>Season Subscription (Spring)</TD><TD>Downtown Theater</TD><TD>1/1/2015 12:00 PM</TD><TD>6</TD></TR>
			<TR><TD><INPUT TYPE="checkbox" NAME="EventCode" VALUE=588031></TD><TD>Season Subscription (Summer)</TD><TD>Downtown Theater</TD><TD>1/1/2015 12:00 PM</TD><TD>6</TD></TR>
			<TR><TD><INPUT TYPE="checkbox" NAME="EventCode" VALUE=588031></TD><TD>Season Subscription (Fall)</TD><TD>Downtown Theater</TD><TD>1/1/2015 12:00 PM</TD><TD>6</TD></TR>
		</TBODY>
		</TABLE>
		Select events and click below<BR><BR>
		<INPUT TYPE="submit" CLASS="btn btn-outline btn-default" VALUE="Submit">
	</FORM>

	<%
	
End Sub

'-------------------------------------------------

Sub PrintLetters 




End Sub

'-------------------------------------------------

Sub SendEmails

	DIM FName
	DIM LName
	
	For i = 1 to 10	
		j = 249 * (i + 3)
		k = 561 * (i + 3)
		Fname = "Bob" & i
		LName = "Smith" & i
		datesent = Now()
		emResults = emResults & "<id>" & i & "</id><ordernumber>" & j &"</ordernumber><firstname>" & fname & "</firstname><lastname>" & lname & "</lastname><emailaddress>tixuser-00" & i &"@yahoo.com</emailaddress><renewalnumber>" & k & "</renewalnumber><datesent>" & datesent & "</datesent>,"
		'response.write "<id>" & i & "</id><ordernumber>" & j &"</ordernumber><firstname>" & fname & "</firstname><lastname>" & lname & "</lastname><emailaddress>tixuser-00" & i &"@yahoo.com</emailaddress><renewalnumber>" & k & "</renewalnumber><datesent>" & datesent & "</datesent>,"
	Next

End Sub

'-------------------------------------------------

Sub SaveEmailLog

	DIM tab
	tab = chr(9)

	DIM objFSO
	set objFSO  = Server.CreateObject( "Scripting.FileSystemObject" )

	xmlFileName = createFileName

	If xmlFileName = "" Then
		  response.write "Error 10: : XML file name missing<BR>"
	end if

	DIM xmlFolderPath
	xmlFolderPath = getFolderPath("logs")

	DIM xmlFilePath
	xmlFilePath = xmlFolderPath & "\" & xmlFileName

	If Not objFSO.FileExists( xmlFilePath ) Then 
		objFSO.CreateTextFile( xmlFilePath )
	End If

	DIM ojbWrite
	set objWrite = objFSO.OpenTextFile( xmlFilePath, 2 )

	objWrite.WriteLine("<?xml version=""1.0"" encoding=""UTF-8""?>")
	objWrite.WriteLine("<emaillist>")

		DIM logArray  
		logArray = Split(emResults,",") 

		For i = LBound(logArray) to UBound(logArray)
			objWrite.WriteLine(tab & "<email>" & logArray(i) & "</email>")
		Next

	objWrite.WriteLine("</emaillist>")
	objWrite.Close()
	
	strMode = "logs"

End Sub

'-------------------------------------------------

Sub DisplayLogList

	%>
	
	<div class="right-content clearfix">
	
		<div class="big-icons-buttons clearfix margin-bottom"> 
			<div class="btn-group btn-group-sm pull-right">
				<a class="btn btn-default"><i class="fa fa-envelope"></i>New</a> 				
				<a class="btn btn-default mark_read"><i class="fa fa-check-circle-o"></i>Read</a> 
				<a class="btn btn-default mark_unread"><i class="fa fa-circle-o"></i>Unread</a> 
				<a class="btn btn-default delete"><i class="fa fa-times-circle"></i> Delete</a> 
				<a class="btn btn-default refresh"><i class="fa fa-refresh"></i> Refresh</a> 
			</div>
		</div>
		
		<div class="table-relative table-responsive">

			<FORM ACTION="" METHOD="post">
				<INPUT TYPE="hidden" NAME="FormName" VALUE="ViewLogs">
				<TABLE class="table table-striped table-fade">
					<THEAD>
						<TR><TH></TH><TH style="text-align:left">File Name</TH><TH>Date/Time</TH></TR>
					</THEAD>
					<TBODY>
						<%Response.Write getFilelist %>
					</TBODY>
				</TABLE>
			</FORM>
			
		</div>
	
	</div>

	<%


End Sub

'-------------------------------------------------

Sub DisplayLog

		DIM  xslFileName
		xslFileName = getXSLFile

		DIM xmlFolderPath
		xmlFolderPath = getFolderPath("logs")

		DIM xmlFilePath
		xmlFilePath = xmlFolderPath & "\" & xmlFileName

		Set FSO = Server.CreateObject("Scripting.FileSystemObject")
				
		If Not FSO.FileExists(xmlFilePath) Then 
			response.write "Error_11:  XML file does not exist: " & xmlFilePath & "<BR><BR>"
			response.end
		End If

		Set FSO = nothing
		
		dim xmlDoc
		Set xmlDoc = Server.CreateObject("MSXML2.FreeThreadedDOMDocument.3.0")
		xmlDoc.async = false

		xmlDoc.ValidateOnParse = True
		
		xmlDoc.load xmlFilePath
		if xmlDoc.parseError.errorCode <> 0 Then
			 'error found so  stop
			  response.write "Error_12: processing  XML file: " & xmlFilePath & "<BR><BR>"
			 response.end
		end if
		
		Set xslDoc = Server.CreateObject("MSXML2.FreeThreadedDOMDocument.3.0")
		xslDoc.async = false

		xslDoc.ValidateOnParse = True
		
		'load the XSL stylesheet and check for errors
		xslDoc.loadXML xslFileName

		if xslDoc.parseError.errorCode <> 0 Then
			  'error found so  stop
			 response.write "Error_14: processing  XSL file<BR><BR>"
			 response.end
		end if
		
		'all must be OK, so perform transformation

	Set templates = Server.CreateObject("Msxml2.XSLTemplate.3.0")
	templates.stylesheet = xslDoc

	Set transformer = templates.createProcessor()

	transformer.input = xmlDoc

	transformer.transform()

	response.write transformer.output

	

End Sub

'-------------------------------------------------

Sub checkStatus

	LtTab = ""
	EmTab = ""
	LgTab = ""
	TestMsg = "<BR>"

	MsgOrgName = GetOrgName(Session("OrganizationNumber"))

	If Request.QueryString("file") <> "" Then
		xmlFileName = request.queryString("file")
	End If

	If Request.QueryString("mode") <> "" Then
		strMode = request.queryString("mode")
	Else
		strMode = "letters"
	End If
	
	strTitle = "Renewal " & PCase(strMode) 	

	Select Case strMode		
		Case "emails"
			EmTab = "active"		
		Case "letters"
			LtTab = "active"
		Case "logs","loglists"
			LgTab = "active"
	End Select
	
	If getFileList = "" Then
		LgTab = "disabled"
	Else
		LgTab = ""
	End If
		
End Sub

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

	PUBLIC FUNCTION GetOrgName(OrgNumber)
	

		SQLThisOrg = "Select  Organization  FROM Organization (NOLOCK) WHERE OrganizationNumber = " &  Session("OrganizationNumber") & ""
		Set rsThisOrg = OBJdbConnection.Execute(SQLThisOrg)
			OrgName = rsThisOrg("Organization") 
		rsThisOrg.Close
		Set rsThisOrg = Nothing


		GetOrgName = OrgName

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

	PUBLIC FUNCTION getFileList

		DIM xmlFolderPath
		xmlFolderPath = getFolderPath("logs")
					 
		DIM objFSO
		set objFSO  = Server.CreateObject( "Scripting.FileSystemObject" )
		
		If Not objFSO.FolderExists( xmlFolderPath ) Then 
			objFSO.CreateFolder ( xmlFolderPath )
		End If
		
		DIM ObjFolder 
		Set ObjFolder = objFSO.GetFolder(xmlFolderPath)
		
		If objFolder.Files.Count <> 0 Then
		
			strFileList = ""
			
			DIM ObjFile
			For Each objFile in objFolder.Files

				If instr(objFile.Name,".xml") <> 0 Then
					
					strText = split(objFile.Name,".xml")	
					strTemp = split(strText(0),"-")
					
					strFileName = strTemp(1) & "/" & strTemp(2) & "/" & strTemp(0) & ""
					
					strFileList = strFileList & "<tr><TD><INPUT TYPE=""checkbox"" NAME=""EventCode"" VALUE=588031></TD><td><a href=""?mode=logs&file=" & objFile.Name & """>" & strFileName & "</a></td><td>" & strTemp(3)& " </td></tr>"

				End If
					
			Next
			
			strFileList = strFileList & ""

		End If
	
		getFileList = strFileList

	END FUNCTION
	
'-------------------------------------------------

	PUBLIC FUNCTION getFolderPath(strFolder)

		DIM strTemp
		DIM strPath

		'get the current folder URL path
		strTemp = Mid(Request.ServerVariables("URL"),2)
		strPath = ""

		Do While Instr(strTemp,"/")
		strPath = strPath & Left(strTemp,Instr(strTemp,"/"))
		strTemp = Mid(strTemp,Instr(strTemp,"/")+1)      
		Loop

		strPath = "/" & strPath
		
		If strFolder <> "" Then
			strPath = strPath & strFolder 
			strPath = strPath & "/" 
		End If
		
		strPath = Server.Mappath(strPath)

		getFolderPath = strPath

	END FUNCTION
 
'-------------------------------------------------

	PUBLIC FUNCTION createFileName

		DIM dtDate
		DIM strFileName

		Dim dtHour
		Dim dtMin

		dtDate = Now()

		dtYear = CStr(Year(dtDate))
		dtMonth = Right("00" & Month(dtDate), 2)
		dtDay = Right("00" & Day(dtDate), 2) 

		dtHour = Hour(dtDate)
		If Len(Hour(dtDate)) = 1 Then 
		dtHour = "0" & Hour(dtDate)
		End If

		dtMin = Minute(dtDate)
		If Len(dtMin) = 1 Then 
			dtMin = "0" & dtMin
		End If
			
		strFileName = "" & dtYear & "-"& dtMonth & "-" & dtDay & "-" & dtHour & dtMin & ".xml"

		createFileName = strFileName
   
	END FUNCTION
 
'-------------------------------------------------

	PUBLIC FUNCTION getXSLFile
	
		DIM strText
		
		 strText = strText & "<?xml version=""1.0""?>" 
		 strText = strText & "<xsl:stylesheet version=""1.0"" xmlns:xsl=""http://www.w3.org/1999/XSL/Transform"">" 
		 strText = strText & "<xsl:template match=""/*"">" 
		 strText = strText & "<table class=""table table-striped table-dark table-fade"">" 
		 strText = strText & "<thead>" 
		 strText = strText & "<tr>" 
		 strText = strText & "<xsl:for-each select=""*[position() = 1]/*"">" 
		 strText = strText & "<th><xsl:value-of select=""local-name()""/></th>" 
		 strText = strText & "</xsl:for-each>" 
		 strText = strText & "</tr>" 
		 strText = strText & "</thead>" 
		 strText = strText & "<tbody>" 
		 strText = strText & "<xsl:apply-templates/>" 
		 strText = strText & "</tbody>" 
		 strText = strText & "</table>" 
		 strText = strText & "</xsl:template>" 
		 strText = strText & "<xsl:template match=""/*/*"">" 
		 strText = strText & "<tr><xsl:apply-templates/></tr>" 
		 strText = strText & "</xsl:template>" 
		 strText = strText & "<xsl:template match=""/*/*/*"">" 
		 strText = strText & "<td><xsl:value-of select="".""/></td>" 
		 strText = strText & "</xsl:template>" 
		 strText = strText & "</xsl:stylesheet>" 
		 
		 getXSLFile = strText
	

	END FUNCTION
 
'-------------------------------------------------

%>