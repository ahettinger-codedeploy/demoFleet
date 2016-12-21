<%

PUBLIC FUNCTION getFileList()

	DIM strFolderPath
	strFolderPath = Server.MapPath("/SergioTest/Support/tixDashboard/renewalLetters/logs") & "\"
	response.write "strFolderPath: " & strFolderPath & "<BR><BR>"
		
	DIM strText
	DIM strTemp
	DIM strFileList
	 
	Dim objFSO  
	Set objFSO = CreateObject("Scripting.FileSystemObject")

	DIM ObjFolder 
	Set ObjFolder = objFSO.GetFolder(strFolderPath)

	DIM colFolderFiles
	Set colFolderFiles = ObjFolder.Files
	
	DIM ObjFile
	For Each ObjFile In colFolderFiles
	
		If instr(objFile.Name,".xml") <> 0 Then
				
			response.write "objFile.Name: " & objFile.Name & "<BR>"
						
			strText = split(objFile.Name,".xml")
			
			'response.write "strText(0): " & strText(0) & "<BR>"
						
			strTemp = split(strText(0),"-")
			
			'response.write "strTemp(0): " & strTemp(0)& "<BR>"
			'response.write "strTemp(1): " & strTemp(1)& "<BR>"
			'response.write "strTemp(2): " & strTemp(2)& "<BR><BR>"
			
			strFileName = strTemp(1) & "/" & strTemp(2) & "/" & strTemp(0)
			
			strFileList = strFileList & "<a href=""" & strFolderPath & objFile.Name & """>" & strFileName & "</a><BR>"
	
		End If
		
	Next
	
	getFileList = "<BR><BR>" & strFileList

END FUNCTION

response.write getFileList

%>
