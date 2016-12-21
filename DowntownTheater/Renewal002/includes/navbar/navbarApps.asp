
<%

function fnListFolders(path)

	dim fs, folder, file, item, url

	set fs = CreateObject("Scripting.FileSystemObject")
	set folder = fs.GetFolder(path)

    	'Display a list of sub folders.
    	for each item in folder.SubFolders
    		fnListFolders item.Path
    	next
 
    	'Display a list of files.
    	for each item in folder.Files
    		if item.name = "index.asp" then
				parentfolder = fnParentFolder(item.parentfolder)
				if parentfolder <> "tixDashboard" then
					'response.write parentfolder & "<BR>"
					url = MapURL(item.path)
					filesList = filesList & "<a href=""" & url & """ class=""" & btnClass & """>" & parentfolder & "</a>,"
				end if
    		end if
    	next

		fnListFolders = filesList
		
end function

'-----------------------------

   function MapURL(path)

     dim rootPath, url

     'Convert a physical file path to a URL for hypertext links.

     rootPath = Server.MapPath("/")
     url = Right(path, Len(path) - Len(rootPath))
     MapURL = Replace(url, "\", "/")

   end function 
   
'-----------------------------

   function fnParentFolder(strfolder)
   
	dim files, url, segments

    'get then current url from the server variables
    url = strfolder

    segments = split(url,"\")

    'read the last segment
    url = segments(ubound(segments))
	
	url = parseFileName(url)
	
    fnParentFolder = url

   end function 
   
'-----------------------------

function parseFileName(FolderName)

	If instr(FolderName,"_") > 0 Then

		'split folder name at each underline
		appNameArray = split(FolderName,"_")
		
		'loop thru each split name and capitialize
		For i =  lbound(appNameArray) to ubound(appNameArray)
			appNameArray(i) = PCase(appNameArray(i))
		Next
		
		'rejoin the split names
		appName = Join(appNameArray,"&nbsp;")
		
	Else
	
		appName = FolderName
	
	End If
	
	parseFileName = appName
					
end function 	
'-----------------------------

FUNCTION  PCase(strIn) 

'Converts string to proper case - for names and addresses

strOut = "" 
boolUp = True 	
aLen =  Len(strIn)  
If len(aLen) > 0 Then 
For i = 1 To Len(strIn) 
c = Mid(strIn, i, 1)
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

'--------------------------------------

PUBLIC FUNCTION fnTrimComma(strText)

	'response.write "pre-trim: " & strText & "<BR>"

'Pass a string and this trims any commas from the start and end of the string submitted

	If Right(strText, 1) = "," Then
	strText = Left(strText, Len(strText) - 1)  
	End If

	If Left(strText, 1) = "," Then 
	strText = Right(strText, Len(strText) - 1)  
	End If
	
	'response.write "post-trim: " & strText & "<BR>"

	fnTrimComma = strText

END FUNCTION 

'----------------------------------

PUBLIC FUNCTION fnRootFolder()

'File Location: http://www.testtix.com/sergiotest/support/tixdashboard/private_label_gallery/index.asp
'Returns: 		sergiotest

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

Public Function fnColumnCount(filesList)

DIM filesListArray
DIM filesListCount

DIM colCount
colCount = 3
	
filesListArray = Split(filesList,",")
filesListCount = ubound(filesListArray) + 1

col3Count = filesListCount \ colCount
col3Mod = filesListCount MOD colCount

Col1 = col3Count
Col2 = col3Count
Col3 = col3Count

If col3Mod <> 0 Then
	col2Count = col3Mod \ (colCount-1)
	Col1 = Col1 + col2Count
	Col2 = Col2 + col2Count
End If
	
col2Mod = col3Mod MOD (colCount-1)

If col2Mod <> 0 Then
	col3Count = col2Mod \ (colCount-2)
	Col1 = Col1 + col3Count
End If

End Function

'---------------------------

DIM appFolderPath
appFolderPath = Server.MapPath("/" & fnRootFolder & "/support/tixDashboard")

DIM btnClass
btnClass="btn btn-dashapps btn-default btn-block"

DIM filesList
filesList = fnListFolders(appFolderPath)

filesList = fnTrimComma(filesList)

DIM Col1
DIM Col2
DIM Col3

fnColumnCount(filesList)

filesListArray = Split(filesList,",")

%>

<!-- navbar apps -->
	<DIV class="panel-hidden" id="panel-options">

		<DIV class="container-fluid"> 
		
			<div class="page-header" style="margin: 20px; text-align:center">
				<h4>Dashboard Apps</h4>
			</div>
			
			<div class="row">
		
				<div class="col-sm-4">

					<ul class="appsList">
						<%
						For i = 0 to (Col1-1)
							response.write "<li>" & filesListArray(i) &"</li>"
						Next
						%>
					</ul>

				</div>
				
				<div class="col-sm-4">

					<ul class="appsList">
						<%
						For i = (Col1) to (Col1+Col2-1)
							response.write "<li>" & filesListArray(i) &"</li>"
						Next
						%>
					</ul>

				</div>
				
				<div class="col-sm-4">

					<ul class="appsList">
						<%
						For i = (Col1+Col2) to (Col1+Col2+Col3-1)
							response.write "<li>" & filesListArray(i) &"</li>"
						Next
						%>
					</ul>

				</div>

			</div>
			
			
		</DIV>
		
	</div>
	<!-- end panel edit -->
