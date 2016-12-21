<%

'-----------------------------

Sub DirectoryList

'Change log - default.asp

'Option Explicit
'On Error Resume Next

''
' Scripts name
''
Dim arPath, strScript
arPath = Split(Request.ServerVariables("SCRIPT_NAME"), "/")
strScript = arPath(Ubound(arPath))


''
' Recursive directory listing


' FILE/FOLDER'S PROPERTIES
'
	Dim strBrowseFolder
	Dim objFSO, objFolder
		
	If strBrowseFolder = "" Then
		strBrowseFolder = getAppPhyPath(Request.QueryString("browse"))
	Else
		strBrowseFolder = Request.QueryString("browse")
	End If
		
	dim Files
	set Files = GetFiles(strBrowseFolder)

	Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
	Set objFolder = objFSO.GetFolder(strBrowseFolder)

	Dim colFiles
	Dim colSubfolders
	Dim strFolderPath
	Dim objSubFolder, objFile
	Dim objDrive, strDriveType

	Set colFiles = objFolder.Files
	Set colSubfolders = objFolder.SubFolders
	strFolderPath = objFolder.Path
	Set strParent = objFolder.ParentFolder


	'Display Bread Crumbs
	response.write "<BR>" 
	'response.write getBreadCrumbs(strFolderPath)
	response.write "<BR>" 

		'LIST FOLDERS
		
		If colSubfolders.Count > 0 Then
		
		%>
			<table class="table table-data table-striped table-hover table-checkbox"> 
			<thead> 
				<tr class="noselect"> 
					<!--<th class="cell-center"> <INPUT TYPE="checkbox" ID="selectAll" NAME="0" value="0"> </th> -->
					<th class="sort-alpha">Name</th> 
					<th class="sort-alpha">Type</th>  
					<th class="sort-numb">Size</th> 
					<th class="sort-numb">Size</th> 
					<th class="sort-numb">Date Modified</th> 
				</tr> 
			</thead> 
			<tfoot>
				<tr>
					<th colspan="8" style="text-align: right;">Showing <%=colSubfolders.Count%> folders</th>
				</tr>
			</tfoot>
			<tbody>
		<%

				For Each objSubFolder In colSubfolders
				
					With Response
					
						Response.Write "<tr>" & vbCRLF
						'Response.Write "<td> <input type='checkbox' name='items' value='" & objSubFolder.Name & "\'> </td>" & vbCRLF
						Response.Write "<td> <a href='" & strScript & "?browse=" & objSubFolder.Path & "\'>" & objSubFolder.Name & "</a> </td>" & vbCRLF
						Response.Write "<td> Folder </td>" & vbCRLF
						objAttributes = objSubFolder.Attributes
						Err.Clear
						
						If Err.Number <> 0 Then
							Response.Write Tab(4) & "<td colspan='4'>&nbsp;</td>" & vbCRLF
						Else
							Response.Write Tab(4) & "<td> " & objSubFolder.Size & "</td>" & vbCRLF
							Response.Write Tab(4) & "<td> " & displaySize(objSubFolder.Size) & "</td>" & vbCRLF
							Response.Write Tab(4) & "<td> " & CStr(displayDateTime(objSubFolder.DateLastModified)) & "</td>" & vbCRLF

						End If

					End With
					Response.Write "</tr>" & vbCRLF
					
				Next
				
		%>
		</tbody>	
	</table>
			
		<%
				
		End If
		
		'LIST FILES
		
		If colFiles.Count = 0 Then
	
		
%>
		<table border="1" cellspacing="0" cellpadding="5">
        <tr>
            <td colspan="4">There are no fiiles to display. </td>
        </tr>
		</table>
<%
    else
%>
<BR>
<BR>
	<table class="table table-data table-striped table-hover table-checkbox"> 
		<thead> 
			<tr class="noselect"> 
				<th class="cell-center"> <INPUT TYPE="checkbox" ID="selectAll" NAME="0" value="0"> </th> 
				<th class="sort-alpha">Name</th> 
				<th class="sort-alpha">Type</th>  
				<th class="sort-numb">Size</th> 
				<th class="sort-numb">Date Modified</th> 
			</tr> 
		</thead>  
		<tfoot>
			<tr> 
				<th colspan='8' style="text-align: right;">Showing <%=files.Count%> files</th>
			</tr> 
		</tfoot>  
		<tbody>
<%

			dim Filename
			for each Filename in Files
				%>
				<tr>
					<td> <input type="checkbox" name="items" value="<%=MapURL(Files(Filename)(0))%>\<%= Filename %> "> </td>
					<td>  <a href="<%=MapURL(Files(Filename)(0))%>"> <%= Filename %> </a></td>
					<td><%= Files(Filename)(1) %></td>
					<td><%= Files(Filename)(2) %></td>
					<td><%= Files(Filename)(3) %></td>
				</tr>
				<%
			next
			%>
		</tbody>
	</table>
<%
end if
%>
</form>
	
</div>
</div>
			
<%

End Sub

'--------------------------------------

Function MapURL(path)

 dim rootPath, url

 'Convert a physical file path to a URL for hypertext links.

 rootPath = Server.MapPath("/")
 url = Right(path, Len(path) - Len(rootPath))
 MapURL = Replace(url, "\", "/")

end function

'--------------------------------------

Function GetFileType(LongFileType)

dim ShortFileType
ShortFileType = ""

Select Case LongFileType
	Case "HTML Document"
		ShortFileType = "HTML"
	Case "JSON File"
		ShortFileType = "JSON"
	Case "ASP File"
		ShortFileType ="ASP"
	Case Else
		ShortFileType = LongFileType
End Select

GetFileType = ShortFileType

End Function

'--------------------------------------

Function Tab(intCount)

	''
	' Generates tabs
	'
	' @param int intCount Number of tabs
	''

	If intCount > 0 Then
		Dim arTmp()
		ReDim arTmp(intCount)
		Tab = Join(arTmp, vbTab)
	End If
End Function

'--------------------------------------

Function GetFiles(strFolderPath)

    dim Filelist
    set Filelist = Server.CreateObject("SCRIPTING.DICTIONARY")

    dim Regex
    set Regex = new RegExp
        Regex.IgnoreCase = true
        Regex.Pattern = strPattern

	dim FSO
    set FSO = Server.CreateObject("SCRIPTING.FILESYSTEMOBJECT")

    dim objFolder
    set objFolder = FSO.GetFolder(strFolderPath)

    dim objFile
	
    For Each objFile in objFolder.Files

		If Regex.Test(objFile.Name) Then
		
			'Select FileName Checkbox
			strCheckbox = "<input type=""checkbox"" name=""filename"" value='" & objFile.Path & "\'>"

			'Format DateLastModified 
			strDateLastModified = displayDateTime(objFile.DateLastModified)
			
			'Format File Size
			strFileSize = displaySize(objFile.Size)
			
			'File Physical Path
			strFilePath = Request.ServerVariables("APPL_PHYSICAL_PATH")
			
			'Add to file properties dictionary
			Filelist.add objFile.Name, Array(objFile.Path, objFile.Type, strFileSize, strDateLastModified, strFilePath)	
			
		End If

	Next
	
    set objFile = nothing
    set objFolder = nothing
    set FSo = nothing
    set Regex = nothing

    set GetFiles = Filelist

end function

'--------------------------------------

function displaySize(Bytes)

dim strSize
dim strUnit
dim intSizeB 
dim intSizeK 
dim intSizeM
dim intSizeG
dim intSizeT

'Size
'1 Kilobyte = 1,024 Bytes
'1 Megabyte = 1,048,576 Bytes
'1 Gigabyte = 1,073,741,824 Bytes
'1 Terabyte = 1,099,511,627,776 Bytes

intSizeB 			= Int(Bytes)
intSizeK 			= Int(Bytes/1024)
intSizeM			= Int(Bytes/1048576)
intSizeG			= Int(Bytes/1073741824)
intSizeT			= Int(Bytes/1099511627776)


If intSizeB 				>= 1099511627776 Then 
	strSize = intSizeT
	strUnit = "Tb"
	
ElseIf intSizeB 			>= 1073741824 Then 
	strSize = intSizeG
	strUnit = "Gb"
	
ElseIf intSizeB 		>= 1048576 Then 
	strSize = intSizeM
	strUnit = "Mb"
	
ElseIf 	intSizeB			>= 1024 Then 
	strSize = intSizeK
	strUnit = "Kb"
	
Else
	strSize = intSizeB
	strUnit = "b"
	
End If

displaySize = strSize & " " & strUnit

End Function

'--------------------------------------

Public Function displayDateTime(datetime)

    strYear = CStr(Year(datetime)) 
	
	strMonth = CStr(Month(datetime))
	
	strDay = CStr(Day(datetime))
	
	strHour = CStr(Hour(datetime))
	
	strMinute = CStr(Minute(datetime))
	
	If Len(CStr(strMonth)) < 2 Then strMonth = "0" & strMonth Else strMonth = strMonth
	
	If Len(CStr(strDay)) < 2 Then strDay = "0" & strDay Else strDay = strDay
	
	If strHour > 11 Then strAMPM = "PM" Else strAMPM = "AM"
	
	If strHour > 13 Then strHour = strHour - 13
	
    'Get the AM/PM designation
    Dim AMPMPart
    AMPMPart = Right(datetime, 3)

	displayDateTime = strYear & "-" & strMonth & "-" & strDay & " at " & strHour & ":" & strMinute & " " & strAMPM
	
End Function  

'-------------------------------------- 

Public Function getServerVariables

	strText = strText & "<hr/><div class=""server-variables-list""><h2>SERVER VARIABLES COLLECTION</h2><dl class=""dl-horizontal"">"
	
	For Each variableName in Request.ServerVariables
		strText = strText & "<dt>" & variableName & "</dt><dd>" & Request.ServerVariables(variableName) & "</dd>"
	Next

    strText = strText &  "</dl>"

	getServerVariables = strText

End Function 

'--------------------------------------

Public Function getAppPhyPath(strText)

	If strText = "" Then
	
		strText  = Request.ServerVariables("APPL_PHYSICAL_PATH")
		
		If Len(strText ) = 0 Then 
			strText  = "."
		Else
			strText  = Trim(strText)
		End If

		Select Case fnRootFolder
			Case "localhost"
				strText = strText & "\LocalTest\"
			Case "sergiotest"
				strText = strText & "\SergioTest\"
			Case "utilities"
				strText = strText & "\SergioTest\"
		End Select
				
	End If
	
	getAppPhyPath = strText 
	
End Function 

'--------------------------------------

Public Function getBreadCrumbs(strFolderPath)

Dim BasePath
Dim Port
Dim strServerName
Dim strLocalHost
Dim strText

strServerName = LCase(Request.ServerVariables("SERVER_NAME")) 

If strServerName = "localhost" Then
	port = "8080"
	strLocalHost = strServerName
	strServerName = strLocalHost& ":" & port
End If

strScript	=  	Request.Servervariables("SCRIPT_NAME")
BasePath = Request.Servervariables("SCRIPT_PATH")

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

If strFolderName <> "" Then
	strPath = strPath & strFolderName
	strPath = strPath & "/" 
End If

response.write "url: " & strTemp& "<BR>"
response.write "strPath: " & strPath & "<BR>"
response.write "server: " & strServerName & "<BR>"
response.write "BasePath: " & BasePath & "<BR>"
response.write "strScript: " & strScript & "<BR>"

strText =" <div class=""row""> <div class=""col-md-12""> <div class=""btn-group btn-breadcrumb"">"
strText = strText & "<a href=""http://" & strServerName & """  class=""btn btn-default"" style=""background-color:#f5f5f5; color:#666666;""> <i class=""fa fa-home""> </i></a>"

FullPath = strFolderPath
'response.write "(1) FullPath: " & FullPath & "<BR>"

NewPath = Replace(FullPath,BasePath,"")
FullPath = NewPath
'response.write "(1.5) FullPath: " & FullPath & "<BR>"

'response.write "(2) Start Loop<BR>"
Do Until instr(1,FullPath,"\") = 0

'## split on the /
tmpPath = mid(FullPath,1,instr(1,FullPath,"\")-1)
'response.write "(3) tmpPath: " & tmpPath & "<BR>"

strTmpPath = Trim(tmpPath)
'response.write "(4) strTmpPath: " & strTmpPath & "<BR>"

DirPath = DirPath & strTmpPath & "\"
'response.write "(5) DirPath: " & DirPath & "<BR>"

'## split the next one out	
FullPath = mid(FullPath,instr(1,FullPath,"\")+1,Len(FullPath)-Len(tmpPath))
'response.write "(6) FullPath: " & FullPath & "<BR>"

if strTmpPath <> "" Then

strText = strText & "<a href="" " & strScript & "?browse=" & BasePath & "\" & DirPath & " "" class=""btn btn-default"" style=""background-color:#f5f5f5; color:#666666;"" ><i class=""fa fa-angle-right""></i>&nbsp;&nbsp;&nbsp;" & strTmpPath & "</a>"

strFolderName = FullPath

end if

Loop

If fullPath <> "" Then
strText = strText & "<a href="" " & strScript & "?browse=" & BasePath & "\" & DirPath & "\" & FullPath & " "" class=""btn btn-default"" style=""background-color:#f5f5f5; color:#666666;""><i class=""fa fa-angle-right""></i>&nbsp;&nbsp;&nbsp;" & FullPath & "</a>"
End if

strText = strText & "</div></div></div>"

getBreadCrumbs =  strText

End Function

Function MapURL(path)

	Dim rootPath
	Dim url

	'Convert the physical file path to a URL for hypertext links.

	rootPath = Server.MapPath("/")
	
	url = Right(path, Len(path) - Len(rootPath))
	
	MapURL = Replace(url, "\", "/")

End Function

'--------------------------------------

PUBLIC FUNCTION fnRootFolder()

	'File Location: http://www.testtix.com/sergiotest/support/tixdashboard/private_label_gallery/index.asp
	'Returns: sergiotest

Dim sScriptLocation
dim sScriptName
dim iScriptLength
dim iLastSlash

ScriptLocation = Request.ServerVariables("URL")
ScriptLength   = Len(ScriptLocation)
FirstSlash      = InStr(ScriptLocation, "/")
ScriptName     = Right(ScriptLocation,ScriptLength - FirstSlash)
ScriptNameArray = Split(ScriptName,"/")

If ScriptNameArray(0) <> "" Then
	strResults = ScriptNameArray(0)
Else
	strResults = ""
End If

fnRootFolder = strResults


END FUNCTION 

'--------------------------------------


%>
