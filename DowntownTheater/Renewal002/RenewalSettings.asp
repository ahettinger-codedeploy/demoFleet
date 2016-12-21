<!-- #INCLUDE VIRTUAL=GlobalInclude.asp-->
<!-- #INCLUDE VIRTUAL=DBOpenInclude.asp-->

<!-- #INCLUDE VIRTUAL="sergiotest/support/tixDashboard/includes/functions/VBfunctions.asp" -->
<!-- #INCLUDE VIRTUAL="sergiotest/support/tixDashboard/includes/functions/SQLfunctions.asp" -->
<!-- #INCLUDE VIRTUAL="sergiotest/support/tixDashboard/includes/functions/adoXMLcls.asp" -->
<!-- #INCLUDE VIRTUAL="sergiotest/support/tixDashboard/includes/functions/aspJSON1.17.asp" -->


<%

'-----------------------------------------------

DIM ServerName 
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

'-----------------------------------------------------
 
DIM OrganizationName
DIM StreetAddress
DIM City
DIM State
DIM ZipCode
DIM InvoiceEmailAddress 
DIM InvoicePhoneNumber  
DIM LogoFileName
 
DIM rootPath
rootPath = Server.MapPath("\")

DIM parentFolder
parentFolder = "\Clients\"
 
DIM clientFolderPath
clientFolderPath = rootPath & parentFolder & fnClientFolder

DIM invoiceFolderPath
invoiceFolderPath = clientFolderPath & "\Invoice\"

DIM xmlFolderPath
xmlFolderPath = invoiceFolderPath & "\data\"

DIM xmlFileName
xmlFileName = "invoiceData.xml"

DIM xmlFilePath
xmlFilePath = xmlFolderPath & xmlFileName

'-----------------------------------------------------

'Error Processing

DIM strError
strError = ""

DIM strMessage
strMessage = ""

DIM xmlErrorMsg
xmlErrorMsg = ""

If NOT fnFolderExists(clientFolderPath) Then
	strError = "ClientFolderLocation"
End If

If fnClientFolder = "" Then
	strError = "ClientFolderName"
End If

If fnInvoiceFormat = False Then
	strError = "InvoiceFormat"
End if

If Session("OrganizationNumber") = 1 Then
	strError = "WrongOrg"
End If

	If strError <> "" Then

		Select Case strError
			Case "WrongOrg"
				strMessage = "<div><h2 class=""text-danger""><i class=""fa fa-exclamation-triangle""></i>&nbsp;Hey There!</h2><p>" & fnOrgName & " is unable to use this invoice format.<BR>In order to add or edit an invoice please select a <a href=""index.asp"">new organization</a>.</p></div>"
				formButton1 = "TIX Org Refresh"
			Case "ClientFolderName"
				strMessage = "<div><h2 class=""text-danger""><i class=""fa fa-exclamation-triangle""></i>&nbsp;Hold Up!</h2><p>" & fnOrgName & " does not have a designated client folder.<BR>Please use <a href=""index.asp"">Organization Options</a> and add the client folder name.</p></div>"
				formButton1 = "Client Folder Name Refresh"
			Case "ClientFolderLocation"
				strMessage = "<div><h2 class=""text-danger""><i class=""fa fa-exclamation-triangle""></i>&nbsp;Wait, Wait...</h2><p>Unable to find the client folder at this location: " & parentFolder & fnClientFolder & "<BR>Please select <a href=""index.asp"">Organization Options</a> and update the client folder name.</p></div>"
				formButton1 = "Client Folder Path Refresh"
			Case "InvoiceFormat"
				strMessage = "<div><h2 class=""text-danger""><i class=""fa fa-exclamation-triangle""></i>&nbsp;Duh!</h2><p>" & fnOrgName & " is using a different invoice format script.<BR>Please use <a href=""index.asp"">Organization Options</a> and update the invoice format script to: <pre>/Management/InvoiceFormatExt.asp</pre>.</p></div>"
				formButton1 = "Client Folder Path Refresh"
		End Select

	Else

		'Data File Processing

		If Request("FormName") = "Save" Then
			Call SaveToXML(xmlFilePath)
		End If
		
		Call LoadXML(xmlFilePath)
		
	End If

	If LogoFileName <> "" Then
		LogoPath = mapURL(LogoFileName)
		LogoArray = split(LogoFileName,"/")
		LogoName = uBound(LogoArray)
	Else
		LogoPath = "/images/tixlogo.gif"
		LogoName = "Select Logo"
	End If
	 
'-----------------------------------------------------

%>

<!DOCTYPE html>

<html lang="en">

<head>	

	<title>Invoice Editor</title>

	<!-- Force IE to turn off past version compatibility mode and use current version mode -->
	<meta http-equiv="X-UA-Compatible" content="IE=edge;chrome=1">

	<!-- Get the width of the users display-->
	<meta name="viewport" content="width=device-width, initial-scale=1.0">

	<!-- Text encoded as UTF-8 -->
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

	<!-- #INCLUDE VIRTUAL="sergiotest/support/tixDashboard/includes/functions/globalStyles.asp" -->

	
</head>

	<body class="container">
	
		<header>
		<!-- #INCLUDE VIRTUAL="TopNavInclude.asp" -->
		</header>
	
		<section>	
		
			<div class="panel panel-default" id="panel-parent">
			
				<div class="panel-heading">
					<div class="panel-title">
						<!-- #INCLUDE VIRTUAL="sergiotest/support/tixDashboard/includes/functions/Navbar.asp" -->
						<!-- #INCLUDE VIRTUAL="sergiotest/support/tixDashboard/includes/functions/NavbarApps.asp" -->
					</div>
				</div>
				
				<div class="panel-body" id="panel-display">
					<% appBody() %>			
				</div>

			</div>

		</section>
		
		<footer>

			<!-- #INCLUDE VIRTUAL="FooterInclude.asp" -->	
			<!-- #INCLUDE VIRTUAL="sergiotest/support/tixDashboard/includes/functions/globalScripts.asp" -->

	
			<script>
			
				//Set the current image 

				$('#imageName').change(function () 
				{
					var imageSRC = $(this).val()
					$('#imagePreview').attr("src",imageSRC);
				});	

			</script>	
			
		</footer>


	</body>

</html>
	
<%


SUB appBody

%>

	<div class="panel">

		<div class="panel-body">
		
			<div class="col-sm-3">
				<a href="#tab1" class="btn btn-primary btn-block">Edit</a> 
				<a  href="invoicePreview.asp" class="btn btn-default btn-block" target=blank>Preview</a> 
			</div>
			
			<div class="col-sm-9">

				<form method="POST" action="index.asp" class="form-horizontal" id="xmlUpdate">
									
					<input type="hidden" name="FormName" value="Save">

					<div class="panel panel-primary">
					
						<div class="panel-heading">
						
							<div class="panel-title clearfix">
						
								<span class="pull-left" style="font-size: 18px;">
									<%=fnOrgName%> - Invoice Format
								</span>
								
								<span class="pull-right">
									<a href="#" class="refresh-link" data-placement="top" title="Options" style="font-size: 14px; color: #ffffff;">
										<i class="fa fa-refresh"></i>
									</a>
								</span>
																
							</div>
							
						</div>
						
						<div class="panel-body">
							<%
							If strError  <> "" Then
								Response.Write "" & strMessage  & "<BR>"
							Else
							%>
							
							<fieldset>

								<legend> </legend>
									
									<div class="form-group">
										<label class="col-sm-3 control-label" for="OrganizationName">Organization Name</label>
										<div class="col-sm-9">
										  <input type="text" class="form-control" autocomplete=off placeholder="Organization Name" name="OrganizationName" value="<%=OrganizationName%>">
										</div>
									</div>
							
								<legend> </legend>

									<div class="form-group">
										<label class="col-sm-3 control-label" for="StreetAddress">Street Address</label>
										<div class="col-sm-9">
											<input type="text" class="form-control" autocomplete=off placeholder="Street Address" name="StreetAddress" value="<%=streetAddress%>">
										</div>
									</div>

									<div class="form-group">
										<label class="col-sm-3 control-label" for="City">City</label>
										<div class="col-sm-9">
										  <input type="text" class="form-control" autocomplete=off placeholder="City" name="City" value="<%=City%>">
										</div>
									</div>

									  
									<div class="form-group">
									  
										<label class="col-sm-3 control-label" for="State">State</label>
										<div class="col-sm-4">
										  <input type="text" class="form-control" autocomplete=off placeholder="State" name="State" value="<%=State%>">
										</div>

										<label class="col-sm-1 control-label" for="ZipCode">ZIP</label>
										<div class="col-sm-4">
										  <input type="text" class="form-control" autocomplete=off placeholder="ZIP Code" name="ZipCode" value="<%=ZipCode%>">
										</div>
										
									</div>
									  
								<legend> </legend>
								
									<div class="form-group">
										<label class="col-sm-3 control-label" for="InvoiceWebsite">Website Address</label>
										<div class="col-sm-9">
										  <input type="text" class="form-control" autocomplete=off placeholder="Website URL" name="InvoiceWebsite" value="<%=InvoiceWebsite%>">
										</div>
									</div>
								
									<div class="form-group">
										<label class="col-sm-3 control-label" for="InvoiceEmailAddress">Email Address</label>
										<div class="col-sm-9">
										  <input type="text" class="form-control" autocomplete=off placeholder="Email Address" name="InvoiceEmailAddress" value="<%=InvoiceEmailAddress%>">
										</div>
									</div>
									
									<div class="form-group">
										<label class="col-sm-3 control-label" for="InvoicePhoneNumber">Phone Number</label>
										<div class="col-sm-9">
										  <input type="text" class="form-control" autocomplete=off placeholder="Phone Number" name="InvoicePhoneNumber" value="<%=InvoicePhoneNumber%>">
										</div>
									</div>

								<legend> </legend>
								
									<div class="form-group">
										<label class="col-sm-3 control-label" for="logoFileImage">Image</label>
										<div class="col-sm-9">
											<div class="thumbnail">
													<img src="<%=LogoPath%>" id="imagePreview">
											</div>
										</div>
									</div>
								
									<div class="form-group">
										<label class="col-sm-3 control-label" for="logoFileName">Image File Name</label>
										<div class="col-sm-9">										
											<select id="imageName" name="invoiceImage" class="form-control" style="width: 460px">
												<option value="">Select Graphic</option>
												<% Response.Write DisplayFilelist(invoiceFolderPath) %>
											</select>
										</div>
									</div>
								
							</fieldset>

							<%
							End If
							%>
						</div>
						
						<div class="panel-footer clearfix">
							<button type="submit" class="btn btn-primary pull-right ">Update</button>
						</div>
						
					</div>
					
				</form> 
				
			</div>
			
		</div>
		
	</div>


<%

END SUB

'--------------------------------------------------------------------

SUB LoadXML(xmlFilePath)

DIM ItemArr 
DIM ValueArr 

If fnFileExists(xmlFilePath) Then

	DIM currentNode

	DIM xPath
	xPath = "*/*"

	DIM i
	i = 0

	DIM l
	l = 0

	Set xmlDoc = fnLoadXML(xmlFilePath)
		
	Set currentNode = xmlDoc.selectNodes(xPath)
	
	REDIM ItemArr(currentNode(i).ChildNodes.length-1)
	REDIM ValueArr(currentNode(i).ChildNodes.length-1)

	For i = 0 to currentNode.length-1 
		If currentNode(i).HasChildNodes Then
			For l = 0 To currentNode(i).ChildNodes.length-1
			
				ItemArr(l) = currentNode(i).ChildNodes(l).nodeName
				
				If currentNode(i).ChildNodes(l) Is Nothing Then  
					ValueArr(l) = ""
				Else  
					ValueArr(l) = currentNode(i).ChildNodes(l).Text
				End If  
				
				Execute ItemArr(l) & " = """ & ValueArr(l) & """"
			Next
		End If
	Next
	
Set currentNode = Nothing
Set xmlDoc = Nothing

Else
	OrganizationName = fnOrgName
	StreetAddress = "c/o Tix<BR>110 West Ocean Blvd. 11th Floor"
	City = "Long Beach"
	State = "CA"
	ZipCode = "98002"
	InvoiceEmailAddress = fnOrgEmailAddress
	InvoicePhoneNumber = fnOrgPhoneNumber
	LogoFileName = "/Tix/images/TixLogo.gif"
End If

END SUB

'--------------------------------------------------------------------

SUB SaveToXML(xmlFilePath)

'The "ConvertFormtoXML" Function accepts to parameters.
'strXMLFilePath - The physical path where the XML file will be saved.
'strFileName - The name of the XML file that will be saved.

DIM xmlRoot
xmlRoot = "InvoiceFormat"

DIM xmlNode
xmlNode = "Invoice"

'Instantiate the Microsoft XMLDOM.
DIM objDom
Set objDom = server.CreateObject("Microsoft.XMLDOM")
objDom.preserveWhiteSpace = True


'Create your root element and append it to the XML document.
DIM objRoot
Set objRoot = objDom.createElement(xmlRoot)
objDom.appendChild objRoot

'Create node.
DIM objNode
Set objNode = objDom.createElement(xmlNode)

	'Iterate through the Form Collection of the Request Object.
	DIM x
	For x = 1 To Request.Form.Count
	
 
	
		'Check to see if "btn" is in the name of the form element.
		'If it is, then it is a button and we do not want to add it
		'to the XML document.
		
		If Request.Form.Key(x) <> "FormName" Then

			'Create a new element
			DIM objField
			Set objField = objDom.createElement(Request.Form.Key(x))

			'Set the value of the field_value element equal to
			'the value of the current field in the Form Collection.
			objField.Text = Request.Form(x)

			'Append the field_value element as a child of the field elemnt.
			objNode.appendChild objField 
						
		End If
		
	Next

'Append the field element as a child of the root element.
objRoot.appendChild objNode
	
'Create the xml processing instruction.
DIM objPI
Set objPI = objDom.createProcessingInstruction("xml", "version='1.0'")

'Append the processing instruction to the XML document.
objDom.insertBefore objPI, objDom.childNodes(0)

If NOT fnFolderExists(xmlFolderPath) Then	
	fnCreateFolder
End If

'Save the XML document.
objDom.save(xmlFilePath)


'Release all of your object references.
Set objDom = Nothing
Set objRoot = Nothing
Set objField = Nothing
Set objPI = Nothing
 
 
END SUB

'--------------------------------------------------------------------

PUBLIC FUNCTION fnLoadXML(xmlFilePath)

	DIM isValid
    DIM xmlDoc
	
    Set xmlDoc = CreateObject("Microsoft.XMLDOM")
	xmlDoc.SetProperty "SelectionLanguage", "XPath"
    xmlDoc.Async = false
	
    xmlDoc.Load(xmlFilePath)
	
    isValid = cBool(xmlDoc.ParseError.ErrorCode = 0)
	
    If Not isValid then
		xmlErrorMsg = "<b>File:</b> " & xmlDoc.parseError.url & "<br />"
		xmlErrorMsg = xmlErrorMsg & "<b>Error Code:</b> " & xmlDoc.ParseError.errorCode & "<br />"
		xmlErrorMsg = xmlErrorMsg & "<b>Line:</b> " & xmlDoc.parseError.line & "<br />"
		xmlErrorMsg = xmlErrorMsg & "<b>Character:</b> " & xmlDoc.parseError.linePos & "<br />"
		xmlErrorMsg = xmlErrorMsg & "<b>Source Text:</b> " & xmlDoc.parseError.srcText & "<br />"
		xmlErrorMsg = xmlErrorMsg & "<b>Description:</b> " & xmlDoc.parseError.reason & "<br />"
    End If

    Set fnLoadXML = xmlDoc
	
END FUNCTION

'-------------------------------------------------------------------

PUBLIC FUNCTION fnFolderExists(strFolderPath)

	DIM objFSO
	DIM strResults

	Set objFSO = CreateObject("Scripting.FileSystemObject")

	If objFSO.FolderExists(strFolderPath) Then
		strResults = TRUE
	Else
		strResults = FALSE
	End If
	
	Set objFSO = Nothing  

	fnFolderExists = strResults
   
END FUNCTION

'--------------------------------------------------------------------

PUBLIC FUNCTION  fnFileExists(strFolderPath)

	DIM objFSO
	DIM strResults
      
	Set objFSO = CreateObject("Scripting.FileSystemObject")
    
	If objFSO.FileExists(strFolderPath) Then
		strResults = TRUE
	Else
		strResults = FALSE
	End If
  
	Set objFSO = Nothing   
	
	fnFileExists = strResults
 
END FUNCTION

'--------------------------------------------------------------------

PUBLIC FUNCTION fnCreateFolder

	DIM objFSO
	Set objFSO = CreateObject("Scripting.FileSystemObject")
	 	
	If NOT objFSO.FolderExists(Server.MapPath("\") & "\Clients\" & fnClientFolder & "\Invoice\") Then
		objFSO.CreateFolder(Server.MapPath("\") & "\Clients\" & fnClientFolder & "\Invoice\")
    End If
	
	If NOT objFSO.FolderExists(Server.MapPath("\") & "\Clients\" & fnClientFolder & "\Invoice\data") Then
		objFSO.CreateFolder(Server.MapPath("\") & "\Clients\" & fnClientFolder & "\Invoice\data")
    End If
 	
	Set objFSO = Nothing
 
  
END FUNCTION
	
'--------------------------------------------------------------------

PUBLIC FUNCTION fnClientFolder

	DIM strResults

	SQLSearch = "Select OptionValue  FROM OrganizationOptions (NOLOCK) WHERE OrganizationNumber = " &  Session("OrganizationNumber") & " AND OptionName = 'ClientFolder'"
	Set rsSearch = OBJdbConnection.Execute(SQLSearch)
		If Not rsSearch.EOF Then 
			strResults = rsSearch("OptionValue") 
		End If
	rsSearch.Close
	Set rsSearch = Nothing

	fnClientFolder = strResults 

END FUNCTION

'--------------------------------------------------------------------

PUBLIC FUNCTION fnInvoiceFormat

	DIM strResults
	strResults = FALSE

	SQLSearch = "Select OptionValue  FROM OrganizationOptions (NOLOCK) WHERE OrganizationNumber = " &  Session("OrganizationNumber") & " AND OptionName = 'InvoiceFormat'"
	Set rsSearch = OBJdbConnection.Execute(SQLSearch)
		If Not rsSearch.EOF Then 
			strText = rsSearch("OptionValue") 
		End If
	rsSearch.Close
	Set rsSearch = Nothing
	
	If strText = "/Management/InvoiceFormatExt.asp" Then
		strResults = TRUE
	End If

	fnInvoiceFormat = strResults 

END FUNCTION

'--------------------------------------------------------------------

PUBLIC FUNCTION fnOrgName

	DIM strResults

	'Get Organization Information
	SQLSearch = "SELECT DISTINCT Organization.Organization FROM Organization (NOLOCK) WHERE OrganizationNumber = " &  Session("OrganizationNumber") & ""
	Set rsSearch = OBJdbConnection.Execute(SQLSearch)
		strResults =  rsSearch("Organization") 
	rsSearch.Close
	Set rsSearch = Nothing

	fnOrgName = strResults

END FUNCTION

'--------------------------------------------------------------------
 
PUBLIC FUNCTION fnOrgEmailAddress

	DIM strResults
	
	SQLSearch = "Select OptionValue  FROM OrganizationOptions (NOLOCK) WHERE OrganizationNumber = " &  Session("OrganizationNumber") & " AND OrganizationOptions.OptionName = 'CustomerServiceEmailAddress'"
	Set rsSearch = OBJdbConnection.Execute(SQLSearch)
		If Not rsSearch.EOF Then 
			strResults = rsSearch("OptionValue") 
		End If
	rsSearch.Close
	Set rsSearch = Nothing

	fnOrgEmailAddress = strResults

END FUNCTION

'--------------------------------------------------------------------

Function DisplayFilelist(strFolderPath)

	Dim strText
	Dim objFSO
	Set objFSO = CreateObject("Scripting.FileSystemObject")

	strText = CreateFileList(objFSO.GetFolder(strFolderPath), TRUE)

	Set objFSO = Nothing
	
	strText = strText & "<option value=""/images/TixLogo.gif"">TixLogo.gif</option>"
	
	DisplayFilelist = strText

End Function

'--------------------------------------------------------------------

Function CreateFileList(objFolder, bRecursive)

	Dim objFile
	Dim objSubFolder
	
	Dim Regex
	Set Regex = New RegExp
	Regex.IgnoreCase = TRUE
	Regex.Pattern = "\.(bmp|gif|jpg|jpeg|png|tif)$"
		
        'For Each objFile In objFolder.Files
		
			'If Regex.Test(objFile.Name) Then
			'response.write objFile.Path & "<BR>"
			
				'If LogoFileName = objFile.Path Then					
					'CreateFileList = CreateFileList & "<option selected value= " & MapURL(objFile.Path) & ">" & objFile.Name & "</option>"
				'Else
					'CreateFileList = CreateFileList & "<option value= " & MapURL(objFile.Path) & " >" & objFile.Name & "</option>"
				'End If
			
			'End If
			
		'Next
		
	CreateFileList = CreateFileList & "<option value=""/Clients/DowntownTheater/Invoice/downtowntheater5.png"">downtowntheater5.png</option>"
	CreateFileList = CreateFileList & "<option value=""/Clients/DowntownTheater/Invoice/images/downtowntheater.png"">downtowntheater.png</option>"
	CreateFileList = CreateFileList & "<option selected value=""/Clients/DowntownTheater/Invoice/images/DowntownTheaterLogo.png"">DowntownTheaterLogo.png</option>"
	CreateFileList = CreateFileList & "<option value=""/images/TixLogo.gif"">TixLogo.gif</option>"

	If bRecursive = TRUE Then
		For Each objSubFolder In objFolder.Subfolders
			CreateFileList = CreateFileList & CreateFileList(objSubFolder, TRUE)
	    Next
	End If
	
End Function

'--------------------------------------------------------------------

Function MapURL(path)

	'Convert the physical file path to a hypertext link.

	Dim rootPath
	Dim strPath
	Dim strURL

	rootPath = Server.MapPath("/")
	strPath  = Right(path, Len(path) - Len(rootPath))
	strURL   = Replace(strPath, "\", "/")

	MapURL = strURL 

End Function


'--------------------------------------------------------------------

%>

