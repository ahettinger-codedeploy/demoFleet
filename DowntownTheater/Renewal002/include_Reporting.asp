
<%

Sub DisplayReports

If logFileName = "" Then

%>

	<H4 class="page-header" style="margin-top:20px; margin-bottom:20px;">Reports - Listing</H4>
	
	<FORM action="index.asp#tabReports" method="post">
	
	<INPUT TYPE="hidden" NAME="FormName" VALUE="ViewLogs">

		<table class="table">
			<thead>
				<tr>
					<th>Select</th>
					<th>Datesent</th>
					<th>Email Count</th> 
					<th>Reply To</th> 
					<th>Subject</th> 
				</tr> 
			</thead>
			<tbody>
				<%

		
			
				%> 
			</tbody>
		</table>
			
		<BR>
		<BR>

		<input type="submit" CLASS="btn btn-outline btn-default" name="logAction" value="View" />
		<input type="submit" CLASS="btn btn-outline btn-default" name="logAction" value="Delete" />

	</FORM>

<%

Else

%>

			<H4 class="page-header" style="margin-top:20px; margin-bottom:20px;">Reports - Detail</H4>
 
			<table class="table">
			<thead>
			<tr>
			<th>Date Sent</th>
			<th>Order Count</th> 
			<th>Reply To</th> 
			<th>Subject</th> 
			</tr> 
			</thead>
			<tbody>
				<% 



				%>
			</tbody>
			</table>

			<BR><BR>

			<table class="table">
			<thead>
			<tr>
				<th>Index</th> 
				<th>First name</th> 
				<th>Last name</th> 
				<th>Order Number</th> 
				<th>Email Address</th> 
				<th>Customer Number</th> 
				<th>Renewal Number</th> 
			</tr>
			</thead>
			<tbody>
			
			<% 


			 
			%>
			</tbody>
			</table>
 
	  

<%

End If

End Sub

'----------------------------------

Sub SaveLogReport(logInfoList,logResults)

	DIM tab
	tab = chr(9)

	DIM objFSO
	set objFSO  = Server.CreateObject( "Scripting.FileSystemObject" )

	DIM logFileName
	logFileName = fnFileNameCreate

	If logFileName = "" Then
		response.write "Error: log file name missing<BR>"
	End If
 

	logFolderPath = Server.MapPath("/Clients/DowntownTheater/Renewal/logs/")
	
	response.write "logFolderPath: " & logFolderPath & "<BR>"
	
	response.write "ClientDirectory: " & ClientDirectory & "<BR>"
	response.write "logLocation " & LogLocation & "<BR>"
	response.write "logFileName " & logFileName & "<BR>"
	
	If Not fnFolderExists(logFolderPath) Then
		response.write "logFolderPath does not exisit: " & logFolderPath & "<BR>"
		objFSO.CreateTextFile(logFolderPath)
		response.write "logFilePath created: " & logFilePath & "<BR>"
	Else
		response.write "logFilePath found: " & logFilePath & "<BR>"
	End If

	DIM objWrite
	Set objWrite = objFSO.OpenTextFile(logFilePath, 2)

	objWrite.WriteLine("<?xml version=""1.0"" encoding=""UTF-8""?>")
	
	objWrite.WriteLine("<loglist>")
	objWrite.WriteLine(tab & "<infolist>")
	objWrite.WriteLine(tab & tab & logInfoList)
	objWrite.WriteLine(tab & "</infolist>")

	objWrite.WriteLine(tab & "<emaillist>")

	DIM logArray
	logArray = Split(logResults,",") 
	
	DIM i
	For i = LBound(logArray) to UBound(logArray)
		objWrite.WriteLine(tab & tab & logArray(i))
	Next

	objWrite.WriteLine(tab & "</emaillist>")
	
	objWrite.WriteLine("</loglist>")
	
	objWrite.Close()
 
End Sub
 
'--------------------------------------------------------------------

Public Function fnLogList()

DIM strFileExt
strFileExt = "xml"

DIM reportType	
reportType = "filelist"
						
DIM  strResults
DIM  objFSO						
Set objFSO = CreateObject("Scripting.FileSystemObject")

DIM objFolder 
Set objFolder = objFSO.GetFolder(logFolderPath)

DIM colFiles
Set colFiles = objFolder.Files

DIM objFile
For Each objFile in colFiles

	If objFSO.GetExtensionName(objFile.Path)= strFileExt Then
			strResults = strResults & fnReportWrite(objFile.Path, reportType)
	End If

Next

 fnLogList = strResults
 
End Function

'--------------------------------------------------------------------
 
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
 
PUBLIC FUNCTION fnLogFileCount()

	DIM strFileExt
	strFileExt = "xml"
		
	DIM Count
	Count = 0
 
		DIM objFSO
		SET objFSO = Server.CreateObject("SCRIPTING.FILESYSTEMOBJECT")

			DIM objFolder
			SET objFolder = objFSO.GetFolder(logFolderPath)

			DIM objFile
		 
			FOR EACH objFile in objFolder.Files
				If objFSO.GetExtensionName(objFile.Path)= strFileExt Then
					Count = Count + 1
				End If
			NEXT
			
		SET objFile = nothing
		SET objFolder = nothing
		SET objFSO = nothing
 
	fnLogFileCount = Count
		
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

PUBLIC FUNCTION  fnCreateFolder(strFolderPath)

	DIM objFSO
	DIM folder
      
	Set objFSO = CreateObject("Scripting.FileSystemObject")
    
	Set folder = objFSO.CreateFolder(strFolderPath)
  
	Set objFSO = Nothing   
	
	fnCreateFolder = folder.Path
 
END FUNCTION

'--------------------------------------------------------------------
  
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


'--------------------------------------------------------------------
 
Public Function fnReportWrite(xmlFilePath, reportType)


	DIM xPath
	DIM strResults
	
	DIM radioSelect

	Select Case reportType
		Case "filelist"
			xPath = "/loglist/infolist"
			radioSelect ="<td><input type=""radio""  value=""" & xmlFilePath & """ name=""logfilename""></td>"
		Case "header"
			xPath = "/loglist/infolist"
			radioSelect =""
		Case "detail"
			xPath = "/loglist/emaillist/*"
			radioSelect = ""
	End Select

	DIM xmlDocument
	set xmlDocument = fnLoadXml(xmlFilePath)

	DIM currentNode
	set currentNode = xmlDocument.selectNodes(xPath)
 
	DIM i
	For i = 0 to currentNode.length-1 

		strResults = strResults & "<tr>"
		
		strResults = strResults & radioSelect

		If currentNode(i).HasChildNodes Then
		
			Select Case reportType
				Case "detail"
				strResults = strResults & "<td>" & i & "</td>"
			End Select

			DIM l
			For l = 0 To currentNode(i).ChildNodes.length-1

				If currentNode(i).ChildNodes(l) Is Nothing Then
					strResults = strResults & "<br>" 
				Else  
					strResults = strResults & "<td>"
					strResults = strResults & currentNode(i).ChildNodes(l).Text
					strResults = strResults & "</td>"
				End If 
				
			Next
		
		End If
		
		strResults = strResults & "</tr>"
		
	Next
	
	fnReportWrite = strResults
	
 
End Function

'-------------------------------------------------

function fnLoadXml(XMLfilePath)

    dim xmlDoc
    dim isValid
 
    set xmlDoc = server.createObject("Microsoft.XMLDOM")
	
	xmlDoc.setProperty "SelectionLanguage", "XPath"  
		
    xmlDoc.async = false
	
    xmlDoc.load (XMLfilePath)
	
    isValid = cBool(xmlDoc.parseError.errorCode = 0)
	
    if not isValid then
        response.write fnXMLError(xmlDoc)
    end if

    set fnLoadXml = xmlDoc
	
end function

'-------------------------------------------------

function fnXMLError(xmlDoc)

    dim strText

    strText = "INVALID XML FILE!<br /><br>"
	strText = strText & "<b>File:</b> " & xmlDoc.parseError.url & "<br />"
	strText = strText & "<b>Line:</b> " & xmlDoc.parseError.line & "<br />"
	strText = strText & "<b>Character:</b> " & xmlDoc.parseError.linepos & "<br />"
	strText = strText & "<b>Source Text:</b> " & xmlDoc.parseError.srcText & "<br />"
	strText = strText & "<b>Description:</b> " & xmlDoc.parseError.reason & "<br />"
   
   fnXMLError = strText
	
end function

'-------------------------------------------------

PUBLIC FUNCTION fnFileNameCreate

	DIM strFileExt
	strFileExt = "xml"
 
	DIM dtDate
	dtDate = Now()

	DIM dtYear
	dtYear = CStr(Year(dtDate))
	
	DIM dtMonth
	dtMonth = Right("00" & Month(dtDate), 2)
	
	DIM dtDay
	dtDay = Right("00" & Day(dtDate), 2) 

	Dim dtHour
	dtHour = Hour(dtDate)
	
	If Len(Hour(dtDate)) = 1 Then 
	dtHour = "0" & Hour(dtDate)
	End If

	Dim dtMin
	dtMin = Minute(dtDate)
	
	If Len(dtMin) = 1 Then 
		dtMin = "0" & dtMin
	End If
		
	DIM strFileName
	strFileName = "" & dtYear & "-"& dtMonth & "-" & dtDay & "-" & dtHour & dtMin & "." & strFileExt

	fnFileNameCreate = strFileName

END FUNCTION
 
'-------------------------------------------------

 

%>




