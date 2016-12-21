

<%

'-------------------------------------------------

PUBLIC FUNCTION createLogFile

DIM tab
tab = chr(9)

DIM objFSO
set objFSO  = Server.CreateObject( "Scripting.FileSystemObject" )

xmlFileName = createFileName

If xmlFileName = "" Then
      response.write "Error 10: : XML file name missing<BR>"
end if

DIM xmlFolderPath
xmlFolderPath = getFolderPath

If Not objFSO.FolderExists( xmlFolderPath ) Then 
	objFSO.CreateFolder ( xmlFolderPath )
End If

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
logArray = Split(logResults,",") 

For i = LBound(logArray) to UBound(logArray)
	objWrite.WriteLine(tab & "<email>" & logArray(i) & "<datesent>" & Now() & "</datesent></email>")
Next

objWrite.WriteLine("</emaillist>")
objWrite.Close()

displaylog(xmlFileName)

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
   
End Function  
 
'-------------------------------------------------

PUBLIC FUNCTION getFolderPath

'response.write "<B>getFolderPath</B> <BR><BR>"

DIM strTemp
DIM strPath

   ' get the current folder URL path
   strTemp = Mid(Request.ServerVariables("URL"),2)
   strPath = ""

   Do While Instr(strTemp,"/")
      strPath = strPath & Left(strTemp,Instr(strTemp,"/"))
      strTemp = Mid(strTemp,Instr(strTemp,"/")+1)      
   Loop

	strPath = "/" & strPath
	strPath = strPath & "logs" 
	strPath = strPath & "/" 
	strPath = server.mappath(strPath)

   getFolderPath = strPath
   
 End Function  
 
'-------------------------------------------------

PUBLIC FUNCTION getFileList

DIM xmlFolderPath
xmlFolderPath = getFolderPath
			 
DIM objFSO
set objFSO  = Server.CreateObject( "Scripting.FileSystemObject" )

DIM ObjFolder 
Set ObjFolder = objFSO.GetFolder(xmlFolderPath)

DIM colFiles
Set colFiles = objFolder.Files
	
DIM ObjFile
For Each objFile in colFiles

	If instr(objFile.Name,".xml") <> 0 Then
			
		'response.write "objFile.Name: " & objFile.Name & "<BR>"
					
		strText = split(objFile.Name,".xml")
		
		'response.write "strText(0): " & strText(0) & "<BR>"
					
		strTemp = split(strText(0),"-")
		
		'response.write "strTemp(0): " & strTemp(0)& "<BR>"
		'response.write "strTemp(1): " & strTemp(1)& "<BR>"
		'response.write "strTemp(2): " & strTemp(2)& "<BR>"
		'response.write "strTemp(3): " & strTemp(3)& "<BR>"


		strFileName = strTemp(1) & "/" & strTemp(2) & "/" & strTemp(0) & " (" & strTemp(3)& ")"
		
		strFileList = strFileList & "<li><a href=""?mode=logs&file=" & objFile.Name & """>" & strFileName & "</a></li>"

	End If
		
Next
	
getFileList = strFileList

END FUNCTION

'-------------------------------------------------

PUBLIC FUNCTION displaylog(xmlFileName)

DIM xmlFolderPath
xmlFolderPath = getFolderPath
response.write "xmlFolderPath: " & xmlFolderPath & "<BR><BR>"

DIM xmlFilePath
xmlFilePath = xmlFolderPath & "\" & xmlFileName
response.write "xmlFilePath: " & xmlFilePath & "<BR><BR>"

DIM xslFileName
xslFileName ="anyTable.xsl"

DIM xslFilePath
xslFilePath = xmlFolderPath & "\" & xslFileName
response.write "xslFilePath: " & xslFilePath & "<BR><BR>"


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
	
    displaylog = transformer.output
    
END FUNCTION

'-------------------------------------------------


DIM xmlFileName


DIM logResults
logResults = "<id>01</id><ordernumber>17724963</ordernumber><firstname>bob</firstname><lastname>patterson</lastname>	<emailaddress>tixuser-002@yahoo.com</emailaddress><renewalnumber>5736169155248149</renewalnumber>,<id>02</id><ordernumber>17737308</ordernumber><firstname>samuel</firstname><lastname>garza</lastname>	<emailaddress>tixuser-003@yahoo.com</emailaddress><renewalnumber>6080481155248151</renewalnumber>,<id>03</id><ordernumber>17749653</ordernumber><firstname>steven</firstname><lastname>banks</lastname><emailaddress>tixuser-004@yahoo.com</emailaddress><renewalnumber>6101606155248152</renewalnumber>,<id>04</id><ordernumber>17761998</ordernumber><firstname>cody</firstname><lastname>kuhn</lastname>	<emailaddress>tixuser-001@yahoo.com</emailaddress><renewalnumber>6101636155248150</renewalnumber>,<id>05</id><ordernumber>17774343</ordernumber><firstname>bob</firstname><lastname>patterson</lastname><emailaddress>tixuser-002@yahoo.com</emailaddress><renewalnumber>5736169155248149</renewalnumber>,<id>06</id><ordernumber>17786688</ordernumber><firstname>samuel</firstname><lastname>garza</lastname><emailaddress>tixuser-003@yahoo.com</emailaddress><renewalnumber>6080481155248151</renewalnumber>,<id>07</id><ordernumber>17799033</ordernumber><firstname>steven</firstname><lastname>banks</lastname><emailaddress>tixuser-004@yahoo.com</emailaddress><renewalnumber>6101606155248152</renewalnumber>,<id>08</id><ordernumber>17811378</ordernumber><firstname>cody</firstname><lastname>kuhn</lastname><emailaddress>tixuser-001@yahoo.com</emailaddress><renewalnumber>6101636155248150</renewalnumber>,<id>09</id><ordernumber>17823723</ordernumber><firstname>bob</firstname><lastname>patterson</lastname><emailaddress>tixuser-002@yahoo.com</emailaddress><renewalnumber>5736169155248149</renewalnumber>,<id>10</id><ordernumber>17836068</ordernumber><firstname>samuel</firstname><lastname>garza</lastname><emailaddress>tixuser-003@yahoo.com</emailaddress><renewalnumber>6080481155248151</renewalnumber>,<id>11</id><ordernumber>17848413</ordernumber><firstname>steven</firstname><lastname>banks</lastname><emailaddress>tixuser-004@yahoo.com</emailaddress><renewalnumber>6101606155248152</renewalnumber>,<id>12</id><ordernumber>17860758</ordernumber><firstname>cody</firstname><lastname>kuhn</lastname><emailaddress>tixuser-001@yahoo.com</emailaddress><renewalnumber>6101636155248150</renewalnumber>,<id>13</id><ordernumber>17873103</ordernumber><firstname>bob</firstname><lastname>patterson</lastname><emailaddress>tixuser-002@yahoo.com</emailaddress><renewalnumber>5736169155248149</renewalnumber>,<id>14</id><ordernumber>17885448</ordernumber><firstname>samuel</firstname><lastname>garza</lastname><emailaddress>tixuser-003@yahoo.com</emailaddress><renewalnumber>6080481155248151</renewalnumber>,<id>15</id><ordernumber>17897793</ordernumber><firstname>steven</firstname><lastname>banks</lastname><emailaddress>tixuser-004@yahoo.com</emailaddress><renewalnumber>6101606155248152</renewalnumber>,<id>16</id><ordernumber>17910138</ordernumber><firstname>cody</firstname><lastname>kuhn</lastname><emailaddress>tixuser-001@yahoo.com</emailaddress><renewalnumber>6101636155248150</renewalnumber>"

createLogFile

response.write "<ul>" &  getFileList & "</ul>"

response.write "<br><br>"

response.write displaylog("2014-08-20-1251.xml")

%>
