
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp"-->
<!--#INCLUDE VIRTUAL="TicketPrintInclude.asp"-->
<!--#INCLUDE VIRTUAL="NoCacheInclude.asp"-->
<!--#INCLUDE FILE="xmlClass.asp"-->

<%

Server.ScriptTimeout = 600

'REE 4/15/2 - Increased Session Timeout to 30 minutes to reduce Print validation timeout issues.
Session.Timeout = 60

Page = "ManagementMenu"

'Make sure the correct Session variables are in place.  If not clear the variables and go to the menu.
If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then 
	Session.Abandon
	Response.Redirect("Default.asp")
End If

If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then 
	Session.Abandon
	Response.Redirect("Default.asp")
End If

'-----------------------------------

'Organization Variables

MsgOrgName = GetOrgName(Session("OrganizationNumber"))
PrivateLabel =  GetPrivateLabel(Session("OrganizationNumber"))
MsgRenewalURL = "http://" & PrivateLabel & ".tix.com/renew.aspx"
MsgFontFace = "Arial, Helvetica, sans-serif"

'-----------------------------------


If Request.QueryString("mode") <> "" Then
	strMode = request.queryString("mode")
Else
	strMode = "letters"
End If


'Decide which subroutine to route to
Select Case Request("FormName")

	Case "PrintLetters"
		Call PrintLetters
		
	Case "SendEmails"
		Call SendEmails

	Case Else

		Select Case strMode
			Case "letters"
				lettertab = "active"
				emailtab = ""				
				strTestMode = "<BR>"			
			Case "emails"
				lettertab = ""
				emailtab = "active"		
			Case "logs"
				lettertab = ""
				emailtab = ""
				strTestMode = "<BR>"
		End Select
		
		strTitle = "Renewal " & PCase(strMode) 
		
		Call PrintMenu
	
	End Select

'-----------------------------------

Sub PrintMenu

%>

<html>

<head>

	<title>TIX - Ticket Sales</title>
	<!-- Force IE to turn off past version compatibility mode and use current version mode -->
	<meta http-equiv="X-UA-Compatible" content="IE=edge;chrome=1">
	<!-- Get the width of the users display-->
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<!-- Text encoded as UTF-8 -->
	<meta http-equiv="Content-Type"  content="text/html; charset=utf-8">
	
	<link href="https://netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.min.css" rel="stylesheet"  media="screen">
	<link href="https://netdna.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.css" rel="stylesheet">
	<style>
	/* outline and underscore - nasty things I hate 'em*/  
	a.btn  			{outline:0px !important; -webkit-appearance:none;   text-decoration:none;} 
	a.btn:active	{outline:0px !important; -webkit-appearance:none;   text-decoration:none;} 
	a.btn:focus  	{outline:0px !important; -webkit-appearance:none;   text-decoration:none;}  
	button.btn:active {outline:0px !important; -webkit-appearance:none;   text-decoration:none; } 
	button.btn:focus  {outline:0px !important; -webkit-appearance:none;   text-decoration:none; }  
	button.btn:active {outline:0px !important; -webkit-appearance:none;   text-decoration:none; } 
	button.btn:focus  {outline:0px !important; -webkit-appearance:none;  text-decoration:none; }  
	ul.dropdown-menu li a:active {outline:0px !important; -webkit-appearance:none;  text-decoration:none; } 
	ul.dropdown-menu li a:focus  {outline:0px !important; -webkit-appearance:none;  text-decoration:none; }  
	ul.nav-tabs li a:active  {outline:0px !important; -webkit-appearance:none;  text-decoration:none;} 
	ul.nav-tabs li a:focus 	 {outline:0px !important; -webkit-appearance:none;  text-decoration:none;}  
	nav-tabs > li.active > a, .nav-tabs > li > a { color: #333333; text-decoration: none;} 
	/* inactive tabs */ 
	.nav-tabs > li > a { border: 1px solid #DDDDDD; color: #999999;}  
	.nav > li > a:hover, .nav > li > a:focus { border:1px solid #DDDDDD; color:#777777;}  
	/* body border */ 
	.tab-content { border: 1px solid #DDDDDD; border-radius: 0px 6px 6px 6px; padding:20px;} 
	.nav-tabs { border-bottom: 0px;}  
	
	/* table */ 
	table.table.table-striped.table-bordered.table-fade thead tr th{ background-color: #676767; color: #ffffff; text-align: center;}  
	.table-fade { opacity: 0; } 
	
	/* buttons */ 
	.btn-default.btn-outline:active,
	.btn-default.btn-outline:focus, 
	.btn-default.btn-outline:hover,
	.btn-default.btn-outline { color: #222222; border-color: #222222; background-color: transparent; color: inherit; border-width: 2px; -webkit-transition: all 0.75s; -moz-transition: all 0.75s; transition: all 0.75s; }  

	</style>

	<style>
	/********************************************************************/
	/*** Remove Outlines  ***/

	a.btn  			{outline:1px !important; -webkit-appearance:none;   text-decoration:none;} 
	a.btn:active	{outline:1px !important; -webkit-appearance:none;   text-decoration:none;} 
	a.btn:focus  	{outline:1px !important; -webkit-appearance:none;   text-decoration:none;}
	 
	ul.dropdown-menu li a:active {outline:1px !important; -webkit-appearance:none;  text-decoration:none; }
	ul.dropdown-menu li a:focus  {outline:1px !important; -webkit-appearance:none;  text-decoration:none; }

	ul.nav-tabs li a:active  {outline:1px !important; -webkit-appearance:none;  text-decoration:none;}
	ul.nav-tabs li a:focus 	 {outline:1px !important; -webkit-appearance:none;  text-decoration:none;}

	/********************************************************************/

	.container {margin-top: 30px;}
	.panel .panel-heading { padding: 5px 5px 0 5px;}
	.panel .nav-tabs {border-bottom: none;}
	.panel .nav-justified { margin-bottom: -1px; }

	div.btn-group.pull-right {margin-top: 3px;}

	.nav > li > a:hover, .nav > li > a,
	.nav > li > a:hover, .nav > li > a:active,
	.nav > li > a:hover, .nav > li > a:focus {solid #dddddd; color: #939393; background-color: #e8e8e8;}
	.nav > li > a:hover, .nav > li > a:hover {solid #dddddd; color: #555555;}


	div.btn-group.pull-right button.btn.btn-default {color: #555555; }
	
	.page_header {text-align:center; color: #008400;}
		
	div.btn-group.pull-right div.btn-group button.btn.btn-default { border-radius: 4px; border: 1px solid #dddddd;}
	
	</style>
	
</head>

<body>

	<div class="container">

		<div class="row">
			
			<div class="col-md-12"> 
					
				<div class="panel panel-default">
				
					<div class="panel-heading">
				   
						<span class="panel-title">
						
							<div class="pull-left">
							
								<ul class="nav nav-tabs">
								
									<li id="Letters" class="<%=lettertab%>">	
										<a href="?mode=letters">
											<i class="glyphicon glyphicon-print"></i>											
											Letters
										</a>
									</li>
									
									<% 
									If CheckTixUser(Session("UserNumber")) Then
									%>
									<li id="Emails" class="<%=emailtab%>">		
										<a href="?mode=emails">
											<i class="glyphicon glyphicon-send"></i>
											Emails
										</a>
									</li>
									<% 
									End If 
									%>
									
								</ul>
								
							</div>
							
							<div class="btn-group pull-right">
								<div class="btn-group">
									<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
										<i class="fa fa-list-ul fa-lg"></i> Logs
										<span class="caret"></span>
									</button>
									<ul class="dropdown-menu" role="menu">
										<% response.write getFileList() %>
									</ul>
								</div>
							</div>

							<div class="clearfix"></div>

						</span>
						
					</div>

					<div class="panel-body">
					
						<H4><%=MsgOrgName%></H4>
						<H4 class="display-fade"><FONT FACE="verdana,arial,helvetica" COLOR="#008400"><%=strTitle%></FONT></H4>
						<H5 class="display-fade"><FONT FACE="verdana,arial,helvetica" COLOR="red"><%=strTestMode%></FONT></H5>	

						<%
						Select Case strMode
							Case "letters"
								Call DisplayLetters
							Case "emails"
								Call DisplayEmails
							Case "logs"
								Call DisplayLog							
						End Select
					
						%>
				
					</div>

				</div>
					
			</div>
				
		</div>
			
	</div>
	
	</body>
	
	<script src="http://code.jquery.com/jquery-1.9.1.js" type="text/javascript" ></script>
	<script src="https://netdna.bootstrapcdn.com/bootstrap/3.1.0/js/bootstrap.min.js"></script>
	<script type="text/javascript">
	$(".display-fade").delay(25).animate({"opacity": "1"}, 800);
	$(".table-fade").delay(25).animate({"opacity": "1"}, 800);
	</script>
	
	</html>
	
	
	<%
	
	End Sub
	
	Sub DisplayLetters
	
	%>

	<FORM ACTION="RenewalLetters.asp" METHOD="post">
		<INPUT TYPE="hidden" NAME="FormName" VALUE="PrintMenu">
			<TABLE class="table table-striped table-bordered table-fade">
			<THEAD>
			<TR><TH>Print</TH><TH style="text-align:left">Subscription</TH><TH style="text-align:left">Venue</TH><TH>Date/Time</TH><TH>Quantity</TH></TR>
			</THEAD>
			<TBODY>
			<TR><TD ALIGN="center"><INPUT TYPE="checkbox" NAME="EventCode" VALUE=588031></FONT></TD><TD><FONT FACE="verdana,arial,helvetica" COLOR="#000000" SIZE="2">Season Subscription (Fixed)</FONT></TD><TD><FONT FACE="verdana,arial,helvetica" COLOR="#000000" SIZE="2">Downtown Theater</FONT></TD><TD ALIGN="center" NOWRAP><FONT FACE="verdana,arial,helvetica" COLOR="#000000" SIZE="2">1/1/2015 12:00 PM</FONT></TD><TD ALIGN="center"><FONT FACE="verdana,arial,helvetica" COLOR="#000000" SIZE="2">8</FONT></TD></TR>
			</TBODY>
			</TABLE>
		<FONT FACE="verdana,arial,helvetica" COLOR="#000000" SIZE="2">Select events to print and click below.</FONT><BR><BR>
		<INPUT TYPE="submit" CLASS="btn btn-outline btn-default" VALUE="Submit">
	</FORM>



	<%
	
	End Sub
	
	
	Sub DisplayEmails
	
	%>

	<FORM ACTION="RenewalLetters.asp" METHOD="post">
		<INPUT TYPE="hidden" NAME="FormName" VALUE="PrintMenu">
			<TABLE class="table table-striped table-bordered table-fade">
			<THEAD>
			<TR><TH>Print</TH><TH style="text-align:left">Subscription</TH><TH style="text-align:left">Venue</TH><TH>Date/Time</TH><TH>Quantity</TH></TR>
			</THEAD>
			<TBODY>
			<TR><TD ALIGN="center"><INPUT TYPE="checkbox" NAME="EventCode" VALUE=588031></FONT></TD><TD><FONT FACE="verdana,arial,helvetica" COLOR="#000000" SIZE="2">Season Subscription (Fixed)</FONT></TD><TD><FONT FACE="verdana,arial,helvetica" COLOR="#000000" SIZE="2">Downtown Theater</FONT></TD><TD ALIGN="center" NOWRAP><FONT FACE="verdana,arial,helvetica" COLOR="#000000" SIZE="2">1/1/2015 12:00 PM</FONT></TD><TD ALIGN="center"><FONT FACE="verdana,arial,helvetica" COLOR="#000000" SIZE="2">8</FONT></TD></TR>
			</TBODY>
			</TABLE>
		<FONT FACE="verdana,arial,helvetica" COLOR="#000000" SIZE="2">Select events to print and click below.</FONT><BR><BR>
		<INPUT TYPE="submit" CLASS="btn btn-outline btn-default" VALUE="Submit">
	</FORM>



	<%
	
	End Sub
	
'-------------------------------------------------
	
	Sub DisplayLog	
	
		DIM strMode
		if request.queryString("mode") <> "" Then
			strMode = request.queryString("mode")
		end if

		DIM strXMLfile
		if request.queryString("file") <> "" Then
			strfile = request.queryString("file")
		end if
		
		strXMLfile = strfile
		
		DIM strXSLFile
		strXSLFile = "anyTable.xsl"

		DIM xmlDoc
		Set xmlDoc = New xmlClass

		xmlDoc.xmlFileName = strXMLfile

		xmlDoc.OpenXML

		response.write xmlDoc.transformXML(strXSLFile)

		xmlDoc.Close

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

	PUBLIC FUNCTION getFileList()

		DIM strFolderPath
		strFolderPath = Server.MapPath("/sergiotest/support/tixdashboard/renewalLetters/Logs/")
		
		DIM objFSO
		DIM ObjFolder 
		DIM colFolderFiles
		DIM ObjFile
		
		DIM strText
		DIM strTemp
		DIM strFileName
		
		DIM strLogList
		strLogList = ""
	 
		Set objFSO = CreateObject("Scripting.FileSystemObject")
		Set ObjFolder = objFSO.GetFolder(strFolderPath)
		Set colFolderFiles = ObjFolder.Files
			 
		For Each ObjFile In colFolderFiles
		
			If instr(objFile.Name,".xml") <> 0 Then
					
				'response.write objFile.Name & "<BR>"
							
				strText = split(objFile.Name,".xml")
				
				'response.write "strText(0): " & strText(0) & "<BR>"
							
				strTemp = split(strText(0),"-")
				
				'response.write "strTemp(0): " & strTemp(0)& "<BR>"
				'response.write "strTemp(1): " & strTemp(1)& "<BR>"
				'response.write "strTemp(2): " & strTemp(2)& "<BR><BR>"
				
				strFileName = strTemp(1) & "/" & strTemp(2) & "/" & strTemp(0)
				strLogList = strLogList & "<li><a href=""?mode=logs&file=" & objFile.Name & """>" & strFileName & "</a></li>"
		
			End If
			
		Next
		
		getFileList = strLogList
	
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

PUBLIC FUNCTION GetPrivateLabel(OrgNumbr)

	DIM strTemp
	strTemp = ""

	SQLVenueRefCheck = "SELECT VenueCode, OptionName, OptionValue FROM VenueOptions WITH (NOLOCK) WHERE VenueCode = (SELECT TOP 1 VenueCode FROM VenueOptions (NOLOCK) WHERE OptionName = 'OrganizationNumber' AND OptionValue = '" & OrgNumbr & "') AND (OptionName = 'VenueReference')"
	Set rsVenueRefCheck = OBJdbConnection.Execute(SQLVenueRefCheck)
	If NOT rsVenueRefCheck.EOF Then
		strTemp = rsVenueRefCheck("OptionValue")
	End If
	rsVenueRefCheck.Close
	Set rsVenueRefCheck = nothing
	
	GetPrivateLabel = strTemp

	
END FUNCTION
	
'-------------------------------------------------

	%>