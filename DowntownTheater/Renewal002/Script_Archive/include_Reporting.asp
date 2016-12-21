
<%

 
Sub SaveLogReport(logInfoList,logResults)

	DIM tab
	tab = chr(9)

	DIM objFSO
	set objFSO  = Server.CreateObject( "Scripting.FileSystemObject" )

	logFileName = fnFileNameCreate

	If logFileName = "" Then
		response.write "Error: log file name missing<BR>"
	End If
	
	If Not fnFolderExists(xmlFolderPath) Then
		response.write "Error: log folder not found<BR>"
	End If
	
	DIM logFilePath
	logFilePath = xmlFolderPath & logFileName
 
	If Not fnFileExists(logFilePath) Then
		objFSO.CreateTextFile(logFilePath)
	End If

	DIM ojbWrite
	Set objWrite = objFSO.OpenTextFile(logFilePath, 2)

	objWrite.WriteLine("<?xml version=""1.0"" encoding=""UTF-8""?>")
	
	objWrite.WriteLine("<loglist>")
	objWrite.WriteLine(tab & "<infolist>")
	objWrite.WriteLine(tab & tab & logInfoList)
	objWrite.WriteLine(tab & "</infolist>")

	objWrite.WriteLine(tab & "<emaillist>")

	DIM logArray
	logArray = Split(logResults,",") 
	
	For i = LBound(logArray) to UBound(logArray)
		objWrite.WriteLine(tab & tab & logArray(i))
	Next

	objWrite.WriteLine(tab & "</emaillist>")
	
	objWrite.WriteLine("</loglist>")
	
	objWrite.Close()
	
	strMode = "loglist"

End Sub

'-------------------------------------------------

Sub DisplayLogList

%>
				<FORM ACTION="" METHOD="post">
					<INPUT TYPE="hidden" NAME="FormName" VALUE="ViewLogs">
				
						<table class="table">
							<thead>
								<tr>
									<th>Select</th>
									<th>Datesent</th>
									<th>Email Count</th> 
									<th>Reply To</th> 
									<th>Subject</th> 
									<th>Sample</th>
								</tr> 
							</thead>
						<tbody>

							<%
 
								response.write fnLogList("filelist")
						
							%> 
 
						</tbody>
						</table>
						
					<BR>
					<BR>
	
					<input type="submit" CLASS="btn btn-outline btn-default" name="logAction" value="View" />
					<input type="submit" CLASS="btn btn-outline btn-default" name="logAction" value="Delete" />
				

				</FORM>
 
	  

<%

End Sub

'-----------------------------

Sub DisplayLogDetail

%>
 
								<table class="table">
								<thead>
								<tr>
								<th>Date Sent</th>
								<th>Order Count</th> 
								<th>Reply To</th> 
								<th>Subject</th> 
								<th>Sample</th>
								</tr> 
								</thead>
								<tbody>
									<% 
 
									response.write fnReportWrite(logFileName, "header")

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

								response.write fnReportWrite(logFileName, "detail")
								 
								%>
								</tbody>
								</table>
 
	  

<%

End Sub

'----------------------------------

Public Function fnLogList(reportType)

strFileExt = "xml"

DIM strResults

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFolder = objFSO.GetFolder(xmlFolderPath)
Set colFiles = objFolder.Files

For Each objFile in colFiles

	If objFSO.GetExtensionName(objFile.Path)= strFileExt Then
			strResults = strResults & fnReportWrite(objFile.Path, reportType)
	End If

Next

fnLogList = strResults
 
End Function

'-------------------------------------------------
 
Public Function fnReportWrite(xmlFilePath, reportType)


	DIM xPath
	DIM strResults

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

 
	set xmlDocument = getXml(xmlFilePath)

	set currentNode = xmlDocument.selectNodes(xPath)
 

	For i = 0 to currentNode.length-1 

		strResults = strResults & "<tr>"
		
		strResults = strResults & radioSelect

		If currentNode(i).HasChildNodes Then
		
			Select Case reportType
				Case "detail"
				strResults = strResults & "<td>" & i & "</td>"
			End Select

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

function getXml(XMLfilePath)

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

    set getXml = xmlDoc
	
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


%>



