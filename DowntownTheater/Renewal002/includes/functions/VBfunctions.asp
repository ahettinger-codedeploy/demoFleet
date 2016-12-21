<%

'------------------------------------------

PUBLIC FUNCTION fnDomainURL()

'File Location: http://www.testtix.com/sergiotest/support/tixdashboard/private_label_gallery/index.asp
'Returns: 		http://www.testtix.com/

	DIM protocol
    DIM siteRootUrl
	DIM hostname
	DIM port

    if Request.ServerVariables("HTTPS") = "off" then
        protocol = "http"
    else
        protocol = "https"
    end if
	
    siteRootUrl = protocol & "://"

    hostname = Request.ServerVariables("HTTP_HOST")
    siteRootUrl = siteRootUrl & hostname        

    port = Request.ServerVariables("SERVER_PORT")
    if port <> 80 and port <> 443 then
        siteRootUrl = siteRootUrl & ":" & port
    end if

    fnDomainURL = siteRootUrl
	
END FUNCTION 

'--------------------------------------

PUBLIC FUNCTION fnServerName()

'URL: 			http://www.testtix.com/sergiotest/support/tixdashboard/private_label_gallery/index.asp
'Returns: 		testtix

DIM strResults

strResults = Request.ServerVariables ("SERVER_NAME") 

fnServerName = strResults
	
END FUNCTION 

'--------------------------------------


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

PUBLIC FUNCTION fnScriptFolder()

'File Location: T:/sergiotest/support/tixdashboard/private_label_gallery/index.asp
'Returns: 		/sergiotest/support/tixdashboard/private_label_gallery/

  Dim lsPath, arPath

  ' Obtain the virtual file path. The SCRIPT_NAME
  ' item in the ServerVariables collection in the
  ' Request object has the complete virtual file path
  lsPath = Request.ServerVariables("SCRIPT_NAME")
   
  ' Split the path along the /s. This creates an
  ' This creates an one-dimensional array
  arPath = Split(lsPath, "/")

  ' Set the last item in the array to blank string
  ' (The last item actually is the file name)
  arPath(UBound(arPath,1)) = ""

  ' Join the items in the array. This will
  ' give you the virtual path of the file
  fnScriptFolder = Join(arPath, "/")
  
END FUNCTION 

'----------------------------------

PUBLIC FUNCTION fnScriptName()

'File Location: T:/sergiotest/support/tixdashboard/private_label_gallery/index.asp
'Returns: 		index.asp

  Dim lsPath, arPath

  ' Obtain the virtual file path
  lsPath = Request.ServerVariables("SCRIPT_NAME")

  ' Split the path along the /s. This creates an
  ' one-dimensional array
  arPath = Split(lsPath, "/")

  ' The last item in the array contains the file name
  fnScriptName =arPath(UBound(arPath,1))
  
END FUNCTION 

'----------------------------------

PUBLIC FUNCTION  fnFileExists(strFolderPath)

'Pass a file path location and it returns true if file found.

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

PUBLIC FUNCTION fnTrimComma(strText)

'Pass a string and this trims any commas from the start and end of the string submitted

	If Right(strText, 1) = "," Then
	strText = Left(strText, Len(strText) - 1)  
	End If

	If Left(strText, 1) = "," Then 
	strText = Right(strText, Len(strText) - 1)  
	End If

	fnTrimComma = strText

END FUNCTION 

'----------------------------------

PUBLIC FUNCTION fnISODateTime(ByVal dtDate) 

	'This function converts date/time into ISO format.
	'Date:  	7/17/2008 at 9:24AM
	'Result:	2008-07-17T09:24:17Z

	On Error Resume Next 

    fnISODateTime = CStr(Year(dtDate)) & "-" & Right("00" & Month(dtDate), 2) & "-" & Right("00" & Day(dtDate), 2) & "T" & Right("00" & Hour(dtDate), 2) & ":" & Right("00" & Minute(dtDate), 2) & ":" & Right("00" & Second(dtDate), 2) 
	
END FUNCTION 

'----------------------------------


PUBLIC FUNCTION fnISODate(ByVal dtDate) 

	'This function converts date into ISO format
	'Date:  	7/17/2008 at 9:24AM
	'Result:	2008-07-17

	On Error Resume Next 

    fnISODate = CStr(Year(dtDate)) & "-" & Right("00" & Month(dtDate), 2) & "-" & Right("00" & Day(dtDate), 2) 
	
END FUNCTION 

'----------------------------------

PUBLIC FUNCTION fnISOTime(ByVal dtDate)

	'This function converts date/time into ISO format.
	'Date:  	7/17/2008 at 9:24AM
	'Result:	09:24:17Z

  Dim h
  Dim n
  Dim s
  
  h = Hour(dtDate)
  If Len(h) = 1 Then h = "0" & h
  
  n = Minute(dtDate)
  If Len(n) = 1 Then n = "0" & n
  
  s = Second(dtDate)
  If Len(s) = 1 Then s = "0" & s
  
  fnISOTime = h & n & s
  
END FUNCTION 

'-----------------------------

FUNCTION  PCase(strIn) 

	'This function converts string into proper case
	'String:  sergio rodriguez
	'Results: Sergio Rodriguez

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

'-----------------------------

PUBLIC FUNCTION wordCount(strText)

	'This function returns the number of words in the strong

	dim aryText
	dim nbrWords
	
	'Start by trimming leading/trailing spaces
	strText = Trim(strText)

	'Now, if we have 2 consecutive spaces, replace them
	'with a single space...
	Do While InStr(1, strText, "  ")
	  strText = Replace(strText, "  ", " ")
	Loop
	
	'Then, if we have a comma, replace it
	'with a single space...
	Do While InStr(1, strText, ",")
	  strText = Replace(strText, "  ", " ")
	Loop
	
	'slice it up!
	aryText = split(strText, " ")
	
	'count it down!
	nbrWords = UBound(aryText) + 1
	
	wordCount = nbrWords
		
END FUNCTION 

'----------------------------------

PUBLIC FUNCTION PadString(strString)

  ' This function pads a string (usually a number) to a specified length
  
  ' pString - String to pad
  ' pLength - Required length
  ' pChar   - Single character to use for padding
  ' pSide   - Add padding on the "left" or "right"

  ' If the string is already longer than pLength it will
  ' be truncated.
  
	pLength = 4
	pChar   = "0"
	pSide   = "left"
    
  ' Create padding of required length
  strPadding = String(pLength,pChar)  
  
  If lcase(pSide)="left" then
    strString = strPadding & strString
    strString = Right(strString,pLength)
  else
    strString = strString & strPadding
    strString = Left(strString,pLength)  
  End if
  
  PadString = strString 
   
END FUNCTION 


'----------------------------------------

PUBLIC FUNCTION HTMLDecode(sText)

   'This function converts a character entity such as: &gt; &lt;  and it becomes this: < >

    dim I
	
    sText = Replace(sText, "&quot;"		, Chr(34))
    sText = Replace(sText, "&lt;"  		, Chr(60))
    sText = Replace(sText, "&gt;"  		, Chr(62))
    sText = Replace(sText, "&amp;" 		, Chr(38))
    sText = Replace(sText, "&nbsp;"		, Chr(32))
	sText = Replace(sText, "&equals;"	, Chr(61))
	
    For I = 1 to 255
        sText = Replace(sText, "&#" & I & ";", Chr(I))
    next
	
    HTMLDecode = sText
	
END FUNCTION 


'---------------------------------------

PUBLIC FUNCTION URLDecode(sConvert)

	'This function converts a URL such from: www.example1%2Dbegin20%Page1.asp to this: www.example1-begin Page1.asp

    Dim aSplit
    Dim sOutput
    Dim I
	
    If IsNull(sConvert) Then
       URLDecode = ""
       Exit Function
    End If

    ' convert all pluses to spaces
    sOutput = REPLACE(sConvert, "+", " ")

    ' next convert %hexdigits to the character
    aSplit = Split(sOutput, "%")

    If IsArray(aSplit) Then
      sOutput = aSplit(0)
      For I = 0 to UBound(aSplit) - 1
        sOutput = sOutput & _
          Chr("&H" & Left(aSplit(i + 1), 2)) &_
          Right(aSplit(i + 1), Len(aSplit(i + 1)) - 2)
      Next
    End If

    URLDecode = sOutput
	
END FUNCTION

'---------------------------------------

PUBLIC FUNCTION  RegExClean(EventCodeList,digitCount) 

	'A handy lil function to strip out alpha characters only.
	'From: 653848 THE NERD - Dinner & Show 653849 THE NERD - Show Only 653850 THE NERD - Matinee 
	'To: 653848,653849,653850 

	Dim objRegExp
	Dim targetString
	Dim colMatch
	Dim objMatch

	'Prepare new regular expression
	Set objRegExp = New RegExp

	'Set the regular expression parameters

	With objRegExp
	  .Pattern = "(\d{" & digitCount & "})" 'find match based on number of digits
	  .Global = True		'find every match!
	  .IgnoreCase = True	'not case sensitive
	End With 

	'start by grabbing the raw text
	targetString = EventCodeList	

	'then strip out anything that does not match the pattern
	Set colMatch = objRegExp.Execute(targetString)

	'then run through every match, adding a comma between each one 
	For each objMatch  in colMatch
	  tempString = tempString & objMatch.Value & ","
	Next 

	'finally chop off that last unneeded comma
	If Len(tempString) > 0 Then
	tempString = Left(tempString, len(tempString) - 1)
	End If

	'remove duplicates
	Set oDict = Server.CreateObject("Scripting.Dictionary")
	oDict.CompareMode = vbTextCompare
	For Each word In Split(tempString, ",")
		oDict(word) = Null
	Next

	tempString = Join(oDict.Keys, ",")
	Set oDict = Nothing

	'print out the result!
	RegExClean = tempString

END FUNCTION

'---------------------------------------

PUBLIC FUNCTION  getImageFromURL(PrivateLabel)

strFileUrl = "http://api.webthumbnail.org?width=500&height=400&screen=1280&format=png&url=http://" & PrivateLabel & ".tix.com"

strSaveFileTo = "D:\inetpub\tix\SergioTest\Support\tixDashboard\PrivateLabel\images\" & PrivateLabel & ".jpg"

'create a XMLHTTP object
Set oHTTP = Server.CreateObject("MSXML2.XMLHTTP")

oHTTP.open "GET", strFileUrl, False
oHTTP.send

'create FSO object
Set oFSO = Server.CreateObject("Scripting.FileSystemObject")

'If  strSaveFileTo file already exist, delete it
If oFSO.FileExists(strSaveFileTo) Then
  oFSO.DeleteFile(strSaveFileTo)
End If

If oHTTP.Status = 200 Then
  Dim oADOStream
  Set oADOStream = Server.CreateObject("ADODB.Stream")
  With oADOStream
    .Type = 1
    .Open
    .Write oHTTP.ResponseBody
    .SaveToFile strSaveFileTo
    .Close
  End With
  set oADOStream = Nothing
End If

If oFSO.FileExists(strSaveFileTo) Then
	'Server-Side VBScript -> Client-Side JS Alert 
	'msg = "file upload complete" 
	'Response.Write("<" & "script>alert('" & msg & "');") 
	'Response.Write("<" & "/script>") 
End If

End Function
 
'---------------------------------------

%>
