
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->

<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->

<!-- #INCLUDE VIRTUAL="./SergioTest/Support/tixDashboard/includes/includeVB.asp" -->

<!-- #INCLUDE VIRTUAL="./SergioTest/Support/tixDashboard/includes/includeSQL.asp"-->

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
DIM LgBtn 
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

OBJdbConnection.Close
Set OBJdbConnection = nothing

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
	<link href="https://netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css" rel="stylesheet" id="default">
	
	<style>
	/* links: outlines and underscores */  
	a.btn, 			
	a.btn:active,	
	a.btn:focus,  	
	button.btn:active, 
	button.btn:focus,   
	button.btn:active, 
	button.btn:focus,  
	.dropdown-menu li a:active,
	.dropdown-menu li a:focus,
	.nav-tabs li a,
	.nav-tabs li a:active,
	.nav-tabs li a:focus { outline:0px !important; -webkit-appearance:none;  text-decoration:none; }  
	</style>

	<style>
	/* panel */ 
	.panel .panel-heading { padding: 5px 5px 0 5px;}
	.panel .nav-tabs {border-bottom: none;}
	
	/* inactive tabs */ 
	.nav > li > a,
	.nav > li > a:active,
	.nav > li > a:focus 		{color: #999999;} 
	.nav > li > a:hover 		{color: #777777;} 
	
	/* active tabs */ 
	.nav > li.active > a:hover 	{color: #222222;} 
		
	/* table */ 
	table.table.table-striped.table-bordered.table-dark thead tr{ background-color: #676767; color: #ffffff; text-align: center;}  

	/* buttons */ 
	.btn-default.btn-outline:active,
	.btn-default.btn-outline:focus, 
	.btn-default.btn-outline 		{ color: #676767; border-color: #676767; background-color: transparent; border-width: 2px; -webkit-transition: all 0.25s; -moz-transition: all 0.25s; transition: all 0.25s;} 
	.btn-default.btn-outline:hover 	{ color: #000000; border-color: #000000; background-color: transparent; border-width: 2px; -webkit-transition: all 0.75s; -moz-transition: all 0.75s; transition: all 0.75s; } 
	
	.btn-group button.btn.btn-outline.btn-default:focus,
	.btn-group button.btn.btn-outline.btn-default 			{ color: #676767; border-color: #dddddd; background-color: transparent; border-width: 1px; padding: 5px 15px; line-height: 2;  -webkit-transition: all 0.25s; -moz-transition: all 0.25s; transition: all 0.25s;} 
	
	.btn-group button.btn.btn-outline.btn-default:active,
	.btn-group button.btn.btn-outline.btn-default:hover 	{ color: #000000; border-color: #dddddd; background-color: #ffffff; border-width: 1px; -webkit-transition: all 0.75s; -moz-transition: all 0.75s; transition: all 0.75s; } 
	
	
	.display-title { font family: verdana, arial, helvetica; color:#008400;}
	
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
										<% 
										End If 
										%>
										
									</ul>
									
								</div>
								
								<div class="btn-group pull-right">
									<div class="btn-group">
										<button type="button" class="btn btn-outline btn-default">
											<i class="glyphicon glyphicon-cog"></i> Options
										</button>
										<button type="button" class="btn btn-outline btn-default <%=lgBtn%> dropdown-toggle" data-toggle="dropdown">
											<i class="glyphicon glyphicon-list"></i> Logs
											<span class="caret"></span>
										</button>
										<ul class="dropdown-menu" role="menu">
											<% response.write getFileList %>
										</ul>
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
				<script src="https://code.jquery.com/jquery-1.9.1.js" type="text/javascript" ></script>
				<script src="https://netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>
				<script type="text/javascript">
				$(".display-fade").delay(25).animate({"opacity": "1"}, 800);
				$(".table-fade").delay(25).animate({"opacity": "1"}, 800);
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
		<TABLE class="table table-striped table-bordered table-dark">
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
	
Sub DisplayEmails
	
	%>

	<FORM ACTION="" METHOD="post">
		<INPUT TYPE="hidden" NAME="FormName" VALUE="SendEmails">
		<TABLE class="table table-striped table-bordered table-dark">
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

Sub SendEmails

	DIM FName
	DIM LName
	
For i = 1 to 10	
	j = 249 * (i + 3)
	k = 561 * (i + 3)
	Fname = "Bob" & i
	LastName = "Smith" & i
	datesent = Now()
	emResults = emResults & "<id>" & i & "</id><ordernumber>" & j &"</ordernumber><firstname>" & fname & "</firstname><lastname>" & lname & "</lastname><emailaddress>tixuser-00" & i &"@yahoo.com</emailaddress><renewalnumber>" & k & "</renewalnumber><datesent>" & datesent & "</datesent>,"
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

Sub DisplayLog

	response.write "xslFileName: " & xmlFileName & "<BR><BR>"

End Sub

'-------------------------------------------------

Sub DisplayForm

	DIM xmlFolderPath
	xmlFolderPath = getFolderPath("logs")

	DIM xmlFilePath
	xmlFilePath = xmlFolderPath & "\" & xmlFileName

	DIM xslFileName
	xslFileName ="anyTable.xsl"

	DIM xslFolderPath
	xslFolderPath = getFolderPath("includes")

	DIM xslFilePath
	xslFilePath = xslFolderPath & "\" & xslFileName

    dim xmlDoc
    dim xslDoc
    dim templates
    dim transformer
 
    'create two document instances
    Set xmlDoc = Server.CreateObject("MSXML2.FreeThreadedDOMDocument.3.0")
    xmlDoc.async = false

    'set the parser properties
    xmlDoc.ValidateOnParse = True

    If xmlFileName = "" Then
          response.write "Error_10: : XML file name missing<BR>"
         response.end
    end if
    
    
    Set FSO = Server.CreateObject("Scripting.FileSystemObject")
                
        If Not FSO.FileExists(xmlFilePath) Then 
            response.write "Error_11:  XML file does not exist: " & xmlFilePath & "<BR><BR>"
            response.end
        End If

    Set FSO = nothing

    'load the source XML document and check for errors
    xmlDoc.load xmlFilePath
    if xmlDoc.parseError.errorCode <> 0 Then
         'error found so  stop
          response.write "Error_12: processing  XML file: " & xmlFilePath & "<BR><BR>"
         response.end
    end if
    
	Set xslDoc = Server.CreateObject("MSXML2.FreeThreadedDOMDocument.3.0")
	xslDoc.async = false

	xslDoc.ValidateOnParse = True
    
    
    Set FSO = Server.CreateObject("Scripting.FileSystemObject")
              
        If Not FSO.FileExists(xslFilePath) Then 
            response.write "Error_13: XSL file does not exist: " & xslFilePath & "<BR><BR>" 
            response.end
        End If

    Set FSO = nothing
    

    'load the XSL stylesheet and check for errors
    xslDoc.load xslFilePath
    if xslDoc.parseError.errorCode <> 0 Then
          'error found so  stop
         response.write "Error_14: processing  XSL file: " & xslFilePath & "<BR><BR>"
         response.end
    end if

    'all must be OK, so perform transformation

    Set templates = Server.CreateObject("Msxml2.XSLTemplate.3.0")
    templates.stylesheet = xslDoc
    
    Set transformer = templates.createProcessor()

    transformer.input = xmlDoc
    transformer.transform()
	
    emaillog = transformer.output
	
	response.write emaillog
    
End Sub

'-------------------------------------------------

Sub checkStatus

	MsgOrgName = GetOrgName(Session("OrganizationNumber"))

	If getFileList = "" Then
		LgBtn = "disabled"
	End If


	If Request.QueryString("file") <> "" Then
		xmlFileName = request.queryString("file")
	End If


	If Request.QueryString("mode") <> "" Then
		strMode = request.queryString("mode")
	Else
		strMode = "letters"
	End If
	
	strTitle = "Renewal " & PCase(strMode) 	
	
	LtTab = ""
	EmTab = ""
	LgBtn = ""
	TestMsg = "&nbsp;&nbsp;<BR>"
	
	Select Case strMode		
		Case "emails"
			EmTab = "active"		
		Case "letters"
			LtTab = "active"
		Case "logs"
			LgBtn = "focus"
	End Select
		
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
		
		If objFolder.Files.Count > 0 Then
			
			DIM ObjFile
			For Each objFile in objFolder.Files
			
				If instr(objFile.Name,".xml") <> 0 Then
					
					strText = split(objFile.Name,".xml")	
					strTemp = split(strText(0),"-")
					strFileName = strTemp(1) & "/" & strTemp(2) & "/" & strTemp(0) & " (" & strTemp(3)& ")"
					strFileList = strFileList & "<li><a href=""?mode=logs&file=" & objFile.Name & """>" & strFileName & "</a></li>"

				End If
					
			Next
			
		Else
		
			strFileList = ""
		
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
	



	%>