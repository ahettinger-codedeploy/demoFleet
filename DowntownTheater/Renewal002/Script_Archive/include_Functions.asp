<%

'-----------------------------------------------

'Assign Variables
 
DIM rootPath
rootPath = Server.MapPath("\")

DIM parentFolder
parentFolder = "\Clients\"
 
DIM clientFolderPath
clientFolderPath = rootPath & parentFolder & fnClientFolder

DIM appFolderPath
appFolderPath = clientFolderPath & "\renewal\"

DIM templateFolderPath
templateFolderPath = appFolderPath & "data\template\"

DIM xmlFolderPath
xmlFolderPath = appFolderPath & "data\logs\"

DIM strFileExt
strFileExt = "xml"

DIM	EmTab
DIM	LgTab 
DIM	LtTab 

DIM	LogTab 
DIM	EmailTab
DIM LetterTab 

DIM strMode
DIM strTitle

DIM logResults
DIM logFileName
DIM xmlErrorMsg 

DIM XMLfile

'==================================================================================
'Renewal Program - Settings
'==================================================================================

Sub CheckStatus

	If strMode = "" Then
		If Request.QueryString("mode") <> "" Then
			strMode = request.queryString("mode")
		Else
			strMode = "letters"
		End If
	End If
	
	If Request.Form("logAction") <> "" Then
	response.write "logAction!"
		logFileName = Request.Form("logfileName")
		Select Case Request.Form("logAction")
			Case "Delete"
			response.write "delete: " & logfilename & "<BR>"
				Call DeleteFile(logFileName)
			Case "View"
				strMode = "logs"
		End Select
	End If
	
	Select Case strMode		
		Case "emails"
			 EmTab = "active"
			 strTitle = "Emails"					
		Case "loglist"
			 LgTab = "active"
			 strTitle = "Reports"
			 testModeStatus = ""
		Case "logs"
			 strTitle = "Report - Emails"
			 lgTab = "active"
			 testModeStatus = ""
		Case Else
			 LtTab = "active"
			 strTitle = "Letters"	
			 testModeStatus = ""
	End Select
	
	If fnCheckTixUser Then
	
		LetterTab = "<li class=""" & LtTab & """><a href=""?mode=letters""><i class=""glyphicon glyphicon-print""></i><span class=""icon-label"">Letters</span></a></li>"
		
		EmailTab = "<li class=""" & EmTab & """><a href=""?mode=emails""><i class=""glyphicon glyphicon-send""></i><span class=""icon-label"">Emails</span></a></li>"	
	
		If fnFileCount("xml") = 0 Then
			LogTab = ""
		Else
			LogTab =  "<li class=""" & lgTab & """><a href=""?mode=loglist""><i class=""glyphicon glyphicon-list""></i><span class=""icon-label"">Reports</span></a></li>"
		End If

	Else
	
		LetterTab = "<li class=""" & LtTab & """><a href=""?mode=letters""><i class=""glyphicon glyphicon-print""></i><span class=""icon-label"">Letters</span></a></li>"
		
		EmailTab = ""
		
		LogTab =  ""
	
	End If
	
End Sub

'-----------------------------------------------------

Sub AppSetings

'Organization Variables

MsgOrgName = fnOrgName
MsgRenewalURL = "http://" & fnClientFolder & ".tix.com/renew.aspx"
MsgLogoPath = "http://www.tix.com/images/clear.gif"
MsgFontFace = "'Times New Roman', Times, serif"
MailFeeFlag = "N"
EMailReplyTo = "tickets@downtowntheater.com"
EMailSubject = "Your Same Seat Renewal at Downtown Theater!" 

'Testing Variables

TestEMailAddress = "sergio@tix.com"
TestEmailCount = 2

DIM CustFirstName
DIM CustLastName

If TestEMailAddress <> "" Then
    EMailSubject =  "[Test] " & EMailSubject
	EMailReplyTo =  TestEMailAddress
	TestModeStatus = "Test Mode.  A test email will be sent to: " & TestEMailAddress & ""
End If

End Sub

'-----------------------------------------------------

Sub ErrorCheck

	'Error Processing

	DIM strError
	strError = ""

	DIM strMessage
	strMessage = ""

	If NOT fnFolderExists(clientFolderPath) Then
		strError = "Client Folder Location"
	End If

	If fnClientFolder = "" Then
		strError = "Client Folder Name"
	End If

	If Session("OrganizationNumber") = 1 Then
		strError = "Wrong Org"
	End If

	If strError <> "" Then

		Select Case strError
			Case "Wrong Org"
				strMessage = "<div><h2 class=""text-danger""><i class=""fa fa-exclamation-triangle""></i>&nbsp;Hey There!</h2><p>" & fnOrgName & " is unable to use this invoice format.<BR>In order to add or edit an invoice please select a <a href=""index.asp"">new organization</a>.</p></div>"
				formButton1 = "TIX Org Refresh"
			Case "Client Folder Name"
				strMessage = "<div><h2 class=""text-danger""><i class=""fa fa-exclamation-triangle""></i>&nbsp;Hold Up!</h2><p>" & fnOrgName & " does not have a designated client folder.<BR>Please update <a href=""https://www.tix.com/Management/OrganizationSettings.aspx?OrganizationNumber=" & Session("OrganizationNumber")&""" target=""blank"" style=""font-weight:700;text-decoration: none;"">Organization Settings</a> with the client folder name.</p></div>"
				formButton1 = "Client Folder Name Refresh"
			Case "Client Folder Location"
				strMessage = "<div><h2 class=""text-danger""><i class=""fa fa-exclamation-triangle""></i>&nbsp;Wait, Wait...</h2><p>Unable to find the client folder at this location:<BR> <pre>" & parentFolder & fnClientFolder & "</pre> Please update <a href=""https://www.tix.com/Management/OrganizationSettings.aspx?OrganizationNumber=" & Session("OrganizationNumber")&""" target=""blank"" style=""font-weight:700;text-decoration: none;"">Organization Settings</a> with the correct client folder name.</p></div>"
				formButton1 = "Client Folder Path Refresh"
		End Select
			
	End If

End Sub

'--------------------------------------------------------------------
	
PUBLIC FUNCTION fnOrgName
 
	fnOrgName = "Downtown Theater"

END FUNCTION

'--------------------------------------------------------------------

PUBLIC FUNCTION fnCheckTixUser

	Dim strResult
	strResult = TRUE
 
	fnCheckTixUser = strResult

END FUNCTION

'--------------------------------------------------------------------

PUBLIC FUNCTION fnClientFolder

	DIM strResults

 
			strResults = "downtowntheater"
 

	fnClientFolder = strResults 

END FUNCTION

'--------------------------------------------------------------------

PUBLIC FUNCTION fnEmailList(OrgNumbr)
 
	GetUserEmails = "sergio.rodriguez@tix.com"

END FUNCTION

'-------------------------------------------------

PUBLIC FUNCTION fnCommaTrim(strText)

	'This function trims any commas from the start and end of the string submitted

	If Right(strText, 1) = "," Then
	strText = Left(strText, Len(strText) - 1)  
	End If

	If Left(strText, 1) = "," Then 
	strText = Right(strText, Len(strText) - 1)  
	End If

	trimComma = strText

END FUNCTION 

'-------------------------------------------------

PUBLIC FUNCTION fnFileNameCreate

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
		
	strFileName = "" & dtYear & "-"& dtMonth & "-" & dtDay & "-" & dtHour & dtMin & "." & strFileExt

	fnFileNameCreate = strFileName

END FUNCTION
 
'-------------------------------------------------

PUBLIC FUNCTION fnFileListing()

	DIM strResults

	DIM objFSO
	SET objFSO = CreateObject("Scripting.FileSystemObject")
 
    DIM objFolder
    SET objFolder = objFSO.GetFolder(logFolderPath)

    DIM objFile
	
    FOR EACH objFile in objFolder.Files

		If objFSO.GetExtensionName(objFile.Path)= strFileExt Then
		
			strFileName = "<td><input type=""radio""  value=""" & objFile.Path & """ name=""logfilename""></td>"
			strFileInfo = fnLogFileInfo(objFile.Path)
			strResults  = strResults & "<tr> " & strFileName & strFileInfo & "</tr>"
			
		End If
 
	NEXT
	
	SET objFSO = nothing
    SET objFolder = nothing
 
    fnFileListing = strResults

END FUNCTION

'-------------------------------------------------


PUBLIC FUNCTION fnFileCount(strFileExt)
		
	DIM Count
	Count = 0
		 
	If fnFolderExists(xmlFolderPath) Then

		DIM objFSO
		SET objFSO = Server.CreateObject("SCRIPTING.FILESYSTEMOBJECT")

			DIM objFolder
			SET objFolder = objFSO.GetFolder(xmlFolderPath)

			DIM objFile
		 
			FOR EACH objFile in objFolder.Files
				If objFSO.GetExtensionName(objFile.Path)= strFileExt Then
					Count = Count + 1
				End If
			NEXT
			
		SET objFile = nothing
		SET objFolder = nothing
		SET objFSO = nothing
		
	End If
	
	fnFileCount = Count
		
END FUNCTION

'-------------------------------------------------

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

'-------------------------------------------------------------------

PUBLIC FUNCTION fnScriptFileName()

	DIM my_array
	DIM fullpath
	DIM fname

	fullpath = Request.ServerVariables("SCRIPT_NAME")

	arraypath = split(fullpath,"/")

	filename = arraypath(ubound(arraypath))

	fnScriptFileName = filename

END FUNCTION

'-------------------------------------------------------------------

PUBLIC FUNCTION InsertTemplate(templateFile,templateName)


DIM templatePath
templatePath = templateFolderPath & templateFile

Dim  strText
strText = ""

Dim strNewText
strNewText = ""


	Const ForReading = 1

	Set objFSO = CreateObject("Scripting.FileSystemObject")
	
	'templatePath = Server.MapPath(templateFile)

	If objFSO.FileExists(templatePath) Then

		Set objFile = objFSO.OpenTextFile(templatePath, ForReading)

		strContents = objFile.ReadAll
		objFile.Close

		strStartText = "[" & templatename & "]"
		strEndText = "[/" & templatename & "]"

		intStart = InStr(strContents, strStartText)
		intStart = intStart + Len(strStartText)

		intEnd = InStr(strContents, strEndText)

		intCharacters = intEnd - intStart

		strText = Mid(strContents, intStart, intCharacters)
		
		'Replace
		strNewText = replaceVar(strText)
		
		'Clean
		strNewText = cleanBOM(strNewText)

	End If
	
	InsertTemplate = strNewText
			
END FUNCTION

'-------------------------------------------------------------------

PUBLIC FUNCTION cleanBOM(strText)

	'remove BOM if present http://unicode.org/faq/utf_bom.html

	If (Len(Trim(strText)) > 0) Then
	
		Dim AscValue : AscValue = Asc(Trim(strText))
	  
		If ((AscValue = -15441) Or (AscValue = 239)) Then : strText = Mid(Trim(strText),4) : End If
	  
	End If
	
	cleanBOM = strText
	
END FUNCTION 

'-------------------------------------------------------------------

PUBLIC FUNCTION replaceVar(strText)

		'replace placeholders with actual text

		DIM strNewText

		strNewText = Replace(strText, 	 "[FirstName]", CustomerFName)
		strNewText = Replace(strNewText, "[webSite]", webSite)
		strNewText = Replace(strNewText, "[orgNumber]", orgNumber)
		strNewText = Replace(strNewText, "[senderFName]", senderFName)
		strNewText = Replace(strNewText, "[senderLName]", senderLName)
		strNewText = Replace(strNewText, "[senderAddress]", senderAddress)
		strNewText = Replace(strNewText, "[OrgName]", fnOrgName)
		strNewText = Replace(strNewText, "[MsgRenewalURL]",MsgRenewalURL)
		strNewText = Replace(strNewText, "[ServerName]",Request.ServerVariables("server_name"))
		
		replaceVar = strNewText
		
END FUNCTION 

'-------------------------------------------------------------------

PUBLIC FUNCTION cleanHTML(strReplace)

		strReplace = Replace(strReplace,"“","&ldquo;")
		strReplace = Replace(strReplace,"”","&rdquo;")
		strReplace = Replace(strReplace,"’","&rsquo;")
		strReplace = Replace(strReplace,"—","&mdash;")
		strReplace = Replace(strReplace,"–","&ndash;")
		strReplace = Replace(strReplace,"-","&#45;")
		strReplace = Replace(strReplace,"…","&hellip;")
		strReplace = Replace(strReplace,"&amp;#","&#")
		strReplace = Replace(strReplace,"®","&reg;")
		cleanHTML = strReplace

END FUNCTION

'-------------------------------------------------------------------

Sub DeleteFile(xmlFilePath)
 
	DIM ObjFSO
	Set ObjFSO = Server.CreateObject("Scripting.FileSystemObject")
	
		If NOT fnFileExists(xmlFilePath) Then
			response.write "Error: Log file does not exist: " & xmlFilePath & "<BR><BR>"
		Else
			'Delete Files 
			ObjFSO.DeleteFile xmlFilePath, True 
		End If
		
	Set ObjFSO = nothing

	If fnFileCount("xml") = 0 Then
		strMode = "emails"
		LgTab = "disabled"	
		EmTab = "active"
		strTitle = "Send Emails"
	Else
		strMode = "loglist"
		LgTab = "active"
		EmTab = ""
		strTitle = "Log Listing"
	End If

End Sub

'-------------------------------------------------------------------
 

 

%>



	
