<%option explicit%>
<%Response.Buffer = True%>
<%Response.Expires = -1442%>
<%Response.AddHeader "Pragma", "no-cache" %>
<%Response.AddHeader "Cache-Control", "no-cache"%>
<%
'###########################################################################
'# 
'#  Version History
'# 
'#  1.0
'#  2004/09/26: Original build
'# 
'#  1.1
'#  2004/10/25: Added "View Source" ability for ASP files.
'# 
'#  1.2
'#  2004/11/13: - Added rudimentary syntax highlighting for ASP Source View,
'#              which can be VERY slow with large files, but it seems well 
'#              worth the cost to me. Also, file must use CR+LF for line breaks 
'#              for syntax highlighting to work properly.
'#              - Fixed "parent directory" link when viewing source.
'#
'#  1.3
'#  2005/01/12: - Added choices for which files to be able to view source of.
'# 
'#  1.4
'#  2005/05/02: - Toggled alternate background colors for highlighted list.
'#              which makes it easier to find which "view source" link you 
'#              want to choose.
'# 
'#  1.5
'#  2005/05/13: - Added ability to exclude files / folders from view.
'# 
'#  1.5.1
'#  2006/03/01: - Pound symbol in folders resulted in non-downloadable files.
'#   
'#  1.5.2
'#  2007/04/27: - The script breaks if it is in the root directory of the website. Who knew! 
'#   
'#  1.5.3
'#  2008/09/19: - Added option to turn off folder sizes - makes things much quicker for large collections of files.
'#   
'#  1.5.4
'#  2008-11-24: - Fixed script so that it now asks for NT credentials (instead of crashing) when it doesn't have permission to access files.
'# 
'#  1.6.0
'#  2009-03-08: - Added "default document" list. When the EDB runs in to one of the listed documents, it will redirect to it, instead of listing the contents of the containing directory. I would have liked to have pulled the default document property right from IIS itself, but IIS doesn't even allow anonymous users read-only access to the metabase. 
'# 
'#  1.6.1
'#  2009-04-20: - Happy Four Twenty! Fixed a bug with redirection... Redirecting over "#" symbols in file names turned out badly. Had to redirect by manually specifying location header, as opposed to using Response.Redirect. (Thanks Craig!)
'# 
'# 1.6.2
'# 2009-12-08: - Fixed case sensitivity issue for arrPathsToExclude
'# 
'# 
'##########  


Const Version = "1.6.2 (2009/12/08)"


'###########################################################################
'#
'#  Script Config
'#
'##########

Const bAllowViewSource = True
                              ' Boolean. Are anonymous users allowed to see 
                              ' the source code of ASP pages in this directory
                              ' and its subdirectories?

Dim arrSourceViewFilenameExtensions
arrSourceViewFilenameExtensions = Array(".asp",".vbs")
															' Which file types do you want to be able to view
															' the source of?

'Const LocateLink = "/locate/default.asp?Catalog=Files"
Const LocateLink = ""
                              ' String. If you have Dale's LOCATE or some 
                              ' other file search utility available, put the link 
                              ' to it here, and it will display itself near the top right 
                              ' hand side of the page. Otherwise, leave this as a zero-length string.


Const bShowHiddenFiles = False
                              ' Boolean. Show files with the "hidden" attribute?
                              ' You probably dont want this on.

Const bShowSystemFiles = False 
                              ' Boolean. Show files with the "system" attribute?
                              ' You probably dont want this on.

Const bShowShortcutFiles = False 
                              ' Boolean. Show files that are links /aliases / or 
                              ' shortcuts to other files? Note that IIS does not
                              ' follow links and shortcuts. It is more prone to 
                              ' just let the browser download a ".lnk" file, which
                              ' isnt all that useful.
  

Const bSyntaxHighlightingOnByDefault = True      
                              ' Boolean. Only applies to source viewing. 

Const bLineNumberingOnByDefault = False        
                              ' Boolean. Only applies to source viewing. 


Const bShowFolderSizes = False 
                              ' Boolean - If the script is dog slow, it's because it's collecting 
                              ' folder sizes. Set this to false to speed things up. 



dim arrPathsToExclude

' ArrPathsToExclude can be either filenames or folder names.
' They must include leading slashes, and are relative to the current directory.
' Becasue this file cannot browse above its own directory, the leading 
' slash indicates the root of this directory. This directory is effectively
' the root directory.

arrPathsToExclude = Array( _ 
											"/incoming" _ 
											, "/notpublic" _ 
											, "/_search.asp" _ 
											)



Dim arrDefaultDocumentList

' If EDB runs in to one of these files, it will redirect to it instead of 
' listing the directory that it's in. 

arrDefaultDocumentList = Array ()










'###########################################################################
'#
'#  Declare Global Constants and Variables
'#
'##########
Const VbEnum = 100
Const ColumnOrdinal_LastModified = 0
Const ColumnOrdinal_Size = 1
Const ColumnOrdinal_Filename = 2
Const ColumnOrdinal_CanViewSource = 3
Const ColumnOrdinal_StepSize = 4
Const FileAttribute_Hidden = 2
Const FileAttribute_System = 4
Const FileAttribute_Alias = 64
Const ShowHidden = False
Const ShowSystem = False
Const ShowAlias = False 'links or shortcuts to other files
Dim oFso, oFiles, oFolders, oFolder, path, thing
Dim PageTitle
Dim FolderSpec, FileSpec
Dim i
Dim arrfiles, arrFolders
Dim Sort
Dim DefaultVPath
Dim DefaultPhysPath
Dim ParentDirectoryLink
Dim DefaultSort
Dim bViewSource, bRequestedSourceFileFound
Dim gVisibleFilesCount
Dim gVisibleFoldersCount
gVisibleFilesCount = 0 
gVisibleFoldersCount = 0 


'###########################################################################
'#
'#  Runtime
'#
'##########

  Call ScriptInit
  Call DumpHtmlBody
  Call ScriptTerminate
  'End of Script.






'###########################################################################
'#
'#  Primary Functions
'#
'##########


'___________________________________________________________________
Sub DumpHtmlBody
	%>
	<html>
	<head>
	<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title><%=PageTitle %></title>
	<style type="text/css">
	<!-- 
	.h1 { font-family: "Times New Roman", Times, serif; font-size: 24pt; font-weight: bold; color: #000000; }
	.td, td, th { font-family: "Courier New", Courier, mono; font-size: 10pt; white-space: nowrap; vertical-align: top; }
	.lm { text-align: right; padding-left: 4px; padding-right: 4px; }
	.sz { text-align: right; padding-left: 4px; padding-right: 4px; }
	.fn { text-align: left; padding-left: 4px; padding-right: 4px; }
	.InsideASP { color: #000000; '     background-color: #ffffee; '     width: 100%; }
	.OutsideASP { color: #9999cc; background-color: #ffffff; }
	.AspComment { font-style: italic; color: #008080; background-color: #ffffff; }
	.AspTransition { color: #000000; background-color: #ffffcc; }
	.InsideQuote { color: #808080; }
	.LineNumber { color: #666666; }
	-->
	</style>
	</head>
	<body>
	
	<table width="100%"  border="0">
	<tr valign="top">
	<td width="84%" class="h1"><%=PageTitle %></td>
	<td width="16%" align="right">&nbsp;</td>
	</tr>
	</table>
	
	<hr>
	
	<table width="100%" border="0" cellpadding="0"  cellspacing="0">
		<tr>
		<td colspan="3"><a href="<%=ParentDirectoryLink %>">[To Parent Directory]</a></td>
		<td align="right">&nbsp;
		<%
		If Len(locateLink) > 0 Then
		%>
		<a href="<%=LocateLink %>">[Search Filenames]</a>
		<%
		End If
		%>
		</td>
		</tr>
		<tr>
		<td colspan="4">&nbsp;</td>
		</tr>
	</table>

	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<%
	If bViewSource And bAllowViewSource Then 
		%>
		<tr colspan="4"><td>
		<%
		Call DumpSource(oFso, FolderSpec & "\" & FileSpec)
		%>
		</td></tr>
		<%
	Else
		%>
		<tr bgcolor="#dddddd">
		<th width="20%" colspan="2">
		<a href="<%=PathInfo() %>?sort=<%=ColumnOrdinal_LastModified %>&FolderSpec=<%=server.urlencode(FolderSpec) %>">Last Modified</a>
		</th>
		<th width="10%">
		<a href="<%=PathInfo() %>?sort=<%=ColumnOrdinal_Size %>&FolderSpec=<%=server.urlencode(FolderSpec)  %>">Size</a>
		</th>
		<th width="70%" colspan="2">
		<a href="<%=PathInfo() %>?sort=<%=ColumnOrdinal_Filename %>&FolderSpec=<%=server.urlencode(FolderSpec) %>">Name</a> 
		</th>
		</tr>
		<%    
 
		if gVisibleFoldersCount > 0 Then 
			%>
			<tr>
			<th colspan="5" align="left" bgcolor="#eeeeee">Folders</th>
			</tr>
			<% 	       
			bgcolor_now = bgcolor_dark
			Call DumpFoldersList(arrFolders, 0, ubound(arrFolders,1), sort)
			%>
			<tr>
			<td colspan="5">&nbsp;</td>
			</tr>
			<%
		End If

		if gVisibleFilesCount > 0 Then 
			%>
			<tr>
			<th colspan="5" align="left" bgcolor="#eeeeee">Files</th>
			</tr>
			<%    
			bgcolor_now = bgcolor_dark
			Call DumpFilesList(FolderSpec, ArrFiles, 0, ubound(arrFiles,1), sort)
		End If

	End If
%>
</table>

</body>
</html>
<%
End Sub


'___________________________________________________________________
Sub ScriptInit
  FileSpec = Request("FileSpec")
  bRequestedSourceFileFound = False
  Set oFso = createobject("scripting.filesystemobject")
  DefaultVPath = oFso.GetParentFolderName(PathInfo())
  If Len(DefaultVPath) = 0 Then ' This means that the script is in the root folder of the website. It's not recommended to do this, btw.
  	DefaultVPath = "/"
  End If 
  DefaultPhysPath = Server.MapPath(DefaultVPath)
  DefaultSort = ColumnOrdinal_Filename
  Sort = Request.Querystring("sort")
  bViewSource = Typecast(Len(request("ViewSource")),VbBoolean,False)
  PageTitle = request.servervariables("SERVER_NAME")
  Dim j
  If Sort = "0" Then
    Sort = ColumnOrdinal_LastModified
  ElseIf Sort = "1" Then
    Sort = ColumnOrdinal_Size
  Else
    sort = DefaultSort
  End If
  
  'Validate the FolderSpec request
  '{
  FolderSpec = Trim(Request("FolderSpec"))
  FolderSpec = Replace(FolderSpec, "\", "/")
  FolderSpec = Replace(FolderSpec, "//", "/")
  If Len(FolderSpec) = 0 Then FolderSpec = DefaultVPath
  If Len(FolderSpec) > 255 Then FolderSpec = DefaultVPath
  If Left(FolderSpec, Len(DefaultVPath)) <> DefaultVPath Then   FolderSpec = DefaultVPath
  If bFilenameHasIllegalChars(FolderSpec, True) Then FolderSpec = DefaultVPath
  If InStr(FolderSpec, "..") > 0 Then   FolderSpec = DefaultVPath
  If Not (InStr(FolderSpec, "/") > 0) Then FolderSpec = DefaultVPath 'FolderSpec must start with a leading slash
  if InArray(Replace(FolderSpec, DefaultVPath, "", 1, 1, vbTextCompare), arrPathsToExclude) Then FolderSpec = DefaultVPath
  '}
  path = mappath(FolderSpec)
  Dim ErrorCheck
  On Error Resume Next 
    Set oFolder = oFso.getFolder(path)
    ErrorCheck = err.number
  On Error GoTo 0
  If ErrorCheck <> 0 Then 
    FolderSpec = DefaultVPath
    path = Server.MapPath(DefaultVPath)
    Set oFolder = oFso.getFolder(path)
  End If
  If bViewSource Then
      ParentDirectoryLink = PathInfo() & "?FolderSpec=" & server.urlencode((FolderSpec)) & "&sort=" & sort
  Else    
    If (FolderSpec = DefaultVPath) Then 
      ParentDirectoryLink = "../"
    Else
      ParentDirectoryLink = PathInfo() & "?FolderSpec=" & server.urlencode(oFso.GetParentFolderName(FolderSpec)) & "&sort=" & sort
    End If
  End If
  Set oFolders = oFolder.subfolders
  Set oFiles = oFolder.Files

  On Error Resume Next
	Dim sRedirectURL
	
  For Each thing In oFiles
  
		'Look for a default document in this folder. If found, display it. 
  	If InArray(thing.Name, arrDefaultDocumentList) Then 
  		If LCase(FolderSpec & "/" & thing.Name) <> LCase(Pathinfo()) Then 
  			sRedirectURL = FolderSpec & "/" & thing.Name
  			'sRedirectURL = Replace(sRedirectURL, "#", "%23")
  			'br sRedirectURL
  			sRedirectURL = Replace(sRedirectURL, "/", "FFFOOORRWWWARDDDSSLLLLAAASHH")
  			sRedirectURL = Replace(sRedirectURL, ".", "DDDDDDDDDDDDOOOOOOOOOOTTTTTTT")
  			sRedirectURL = Server.UrlEncode(sRedirectURL)
  			sRedirectURL = Replace(sRedirectURL, "+", "%20")
  			sRedirectURL = replace(sRedirectURL, "FFFOOORRWWWARDDDSSLLLLAAASHH", "/")
  			sRedirectURL = Replace(sRedirectURL, "DDDDDDDDDDDDOOOOOOOOOOTTTTTTT", ".")
  			'Response.Redirect sRedirectURL
  			Response.Status = "302 Object Moved"
  			Response.AddHeader "Location", sRedirectUrl
  			'br sRedirectURL
  			Response.End
  		End If 
  	End If 

    'Just counting files. 
    If bShowFile(Thing) Then
    	gVisibleFilesCount = gVisibleFilesCount + 1
    End if

	Next
  ReDim arrFiles(gVisibleFilesCount - 1, ColumnOrdinal_StepSize - 1)
  if lcase(err.description) = "permission denied" And Request.ServerVariables("LOGON_USER") = "" Then
    Response.Status = "401 Authorization Required"
    Response.End
  End If      
  on error goto 0
  
	
	
	For Each Thing in oFolders
		If bShowFile(Thing) Then 
			gVisibleFoldersCount = gVisibleFoldersCount + 1
		End If
	Next
  ReDim arrFolders(gVisibleFoldersCount - 1, ColumnOrdinal_StepSize - 1)
  
  If err.number <> 0 Then 
		If Len(Request.ServerVariables("LOGON_USER")) = 0 Then   
			Response.Status = "401 Authorization Required"
	    Response.End
		End If
  End If  
  i = 0
  For Each thing In oFiles
    If bShowFile(Thing) Then
      On Error Resume Next
      ArrFiles(i,ColumnOrdinal_LastModified) = thing.datelastmodified
      ArrFiles(i,ColumnOrdinal_Size) = thing.size
      ArrFiles(i,ColumnOrdinal_Filename) = thing.name
      ArrFiles(i,ColumnOrdinal_CanViewSource) = False 'set default
      For j = 0 To UBound(arrSourceViewFilenameExtensions)
      	If LCase(ext(thing.name)) = LCase(arrSourceViewFilenameExtensions(j)) Then 
      		ArrFiles(i,ColumnOrdinal_CanViewSource) = True
      	End If
      Next
      If bViewSource Then
        If LCase(thing.path) = LCase(Server.MapPath(FolderSpec) & "\" & FileSpec) Then 
          bRequestedSourceFileFound = True
        End If
      End If
      On Error GoTo 0
	    i = i + 1
    End If
  Next
  If Not bRequestedSourceFileFound Then bViewSource = False
  i = 0
  For each thing in oFolders
    If bShowFile(Thing) Then
      On Error Resume Next
      ArrFolders(i,ColumnOrdinal_LastModified) = thing.datelastmodified
      If bShowFolderSizes Then
	      ArrFolders(i,ColumnOrdinal_Size) = thing.size
      Else
	      ArrFolders(i,ColumnOrdinal_Size) = Null 
     	End If
      ArrFolders(i,ColumnOrdinal_Filename) = thing.name 
      On Error GoTo 0
    	i = i + 1
    End If
  Next
  If Sort <> DefaultSort Then 
    If ubound(arrFiles,1) > 0 Then Call QuickSort(arrFiles, 0, ubound(arrFiles,1), cint(sort))
    If ubound(arrFolders,1) > 0 Then Call QuickSort(arrFolders, 0, ubound(arrFolders,1), cint(sort))
  End if
  PageTitle = PageTitle & " - " & FolderSpec 
  If bViewSource Then PageTitle = PageTitle & "/" & FileSpec & " (Source)"
  On Error GoTo 0 
End Sub


'___________________________________________________________________
Sub ScriptTerminate
  On Error Resume Next
    Set oFiles = nothing
    Set oFolders = nothing
    Set oFolder = nothing
    Set oFso = Nothing
  On Error GoTo 0 
End Sub



'###########################################################################
'#
'#  Secondary Functions
'#
'##########


'___________________________________________________________________
Sub DumpFilesList(FolderSpec, ArrFiles, lo, hi, mark)
  '==-----------------------------------------==
  '== Print out an array from the lo bound    ==
  '==  to the hi bound.  Highlight the column ==
  '==  whose number matches parm mark         ==
  '==-----------------------------------------==
  Dim Row,Column
  Dim Filename
  Dim v
  For Row = lo to hi
    Filename = FolderSpec & "/" & ArrFiles(Row, ColumnOrdinal_Filename) 
    If LCase(Filename) <> LCase(PathInfo()) Then 
      echo "<tr>"
      For Column = 0 to Ubound(ArrFiles,2)
        v = ArrFiles(Row,Column)
        If Column = mark then 
          echo "<td bgcolor=""" & BgColor() & """ class=""" & ColumnClass(Column) & """>"
        Else 
          echo "<td class=""" & ColumnClass(Column) & """>" 
        End If
        If VarType(v) <> 0 Then 
          if Column = ColumnOrdinal_Filename then 
            echo "<a href=""" & Replace(FolderSpec, "#", "%23") & "/" & FilenameAsUrl(v) & """>" & v & "</a>"
            If ArrFiles(Row,ColumnOrdinal_CanViewSource) And bAllowViewSource Then 
              If Column = mark then 
                echo "</td><td bgcolor=""" & BgColor_Now & """ class=""sz""><a href=""" & PathInfo & "?ViewSource=1&FolderSpec=" & Server.UrlEncode(FolderSpec) & "&FileSpec=" & Server.UrlEncode(v) & """>(view source)</a>"
              Else 
                echo "</td><td class=""sz""><a href=""" & PathInfo & "?ViewSource=1&FolderSpec=" & Server.UrlEncode(FolderSpec) & "&FileSpec=" & Server.UrlEncode(v) & """>(view source)</a>"
              End If
              
'              echo "</td><td>
            Else
              If Column = mark then 
                echo "</td><td bgcolor=""" & BgColor_Now & """ class=""sz"">&nbsp;"
              Else 
                echo "</td><td class=""sz"">&nbsp;" 
              End If
            End If
          ElseIf Column = ColumnOrdinal_Size Then
            echo FormatNumber(v, 0)
          ElseIf Column = ColumnOrdinal_LastModified Then
            echo FormatDateTime(DateValue(v), VbShortDate) & "</td><td class=""" & ColumnClass(Column) & """>" & FormatDateTime(TimeValue(v), VbShortTime)
          ElseIf column = ColumnOrdinal_CanViewSource Then
            'do nothing
          Else
            echo v 
          End If
        End If
        response.write "</td>"
      Next
      echo "</tr>"
    End If
  Next
End Sub  'PrintArray


Const BgColor_Dark = "#EEEEEE"
Const BgColor_Light = "#FFFFEE"
Dim BgColor_Now
Function BgColor()
	If BgColor_Now = BgColor_Light Then
		BgColor_Now = BgColor_Dark
	Else
		BgColor_Now = BgColor_Light
	End If
	BgColor = BgColor_Now
End Function


'___________________________________________________________________
Sub DumpFoldersList(ByVal ArrFolders,lo,hi,mark)
  '==-----------------------------------------==
  '== Print out an array from the lo bound    ==
  '==  to the hi bound.  Highlight the column ==
  '==  whose number matches parm mark         ==
  '==-----------------------------------------==
  Dim Row, Column
  Dim Data
  For Row = lo to hi
  		echo "<tr>"
      For Column = 0 to Ubound(ArrFolders,2)
        Data = ArrFolders(Row, Column)
        If Column = mark then 
          echo "<td bgcolor=""" & BgColor() & """ class=""" & ColumnClass(Column) & """>"
        Else 
          echo "<td class=""" & ColumnClass(Column) & """>" 
        End If
          If Column = ColumnOrdinal_Filename Then
          	if vartype(data) = 0 then 
          		response.write "&nbsp;"
          	else
           		echo "<a href=""" & PathInfo() & "?FolderSpec=" & Server.UrlEncode(FolderSpec & "/" & Data) & "&sort=" & sort & """>" & Data & "</a>"
          	end if
            If Column = mark then 
              echo "</td><td bgcolor=""" & BgColor_Now & """ class=""sz"">&nbsp;"
            Else 
              echo "</td><td class=""sz"">&nbsp;" 
            End If
          ElseIf Column = ColumnOrdinal_Size Then
          	if vartype(data) = 0 then 
          		response.write "&nbsp;"
          	Elseif IsNull(data) then 
          		response.write "<span style=""color:#cccccc;"">&lt;n/a&gt;</span>"
          	else
            	Echo FormatNumber(Data, 0)
          	end if
          ElseIf Column = ColumnOrdinal_LastModified Then
          	if vartype(data) = 0 then 
          		echo "&nbsp;</td><td class=""" & ColumnClass(Column) & """>&nbsp;" 
          	else
	            echo FormatDateTime(DateValue(Data), VbShortDate) 
	            echo "</td><td class=""" & ColumnClass(Column) & """>" 
	            echo FormatDateTime(TimeValue(Data), VbShortTime)
          	end if
          Else
          	if vartype(data) = 0 then 
          		response.write "&nbsp;"
          	else
          		Response.Write Data 
          	end if
          End If
        response.write "</td>"
      Next
      echo "</tr>"
  Next
End Sub  


'___________________________________________________________________
Sub DumpSource(ByRef fso, ByVal VPath)
  Dim tso, buffer, i
  Dim NewBuffer
  Dim CursorPos
  Dim Needle
  Dim c, cPrefix, cPostfix
  Dim LN
  Dim bWaitingForMoreChars
  Dim bInsideASP
  Dim bCommentOn
  Dim bInsideQuote
  Dim cLast
  LN = 1
  Set tso = fso.opentextfile(server.mappath(VPath))
  Set NewBuffer = CreateObject("ADODB.Stream")
  NewBuffer.Type = 2 'String
  NewBuffer.Open
  
  echo "<pre>"
  If bShowLineNumbers Then 
    response.write "  <a href=""" & PathInfo() & "?ln=0&hls=" & Abs(CInt(bShowSyntaxHighlighting)) & "&ViewSource=1&FolderSpec=" & Server.UrlEncode(FolderSpec) & "&FileSpec=" & Server.UrlEncode(FileSpec) & """>Turn off line numbering</a>"
  Else
    response.write "  <a href=""" & PathInfo() & "?ln=1&hls=" & Abs(CInt(bShowSyntaxHighlighting)) & "&ViewSource=1&FolderSpec=" & Server.UrlEncode(FolderSpec) & "&FileSpec=" & Server.UrlEncode(FileSpec) & """>Turn on line numbering</a>"
  End If
  
  If bShowSyntaxHighlighting Then 
    response.write "  <a href=""" & PathInfo() & "?hls=0&ln=" & Abs(CInt(bShowLineNumbers)) & "&ViewSource=1&FolderSpec=" & Server.UrlEncode(FolderSpec) & "&FileSpec=" & Server.UrlEncode(FileSpec) & """>Turn off syntax highlighting</a>"
  Else
    response.write "  <a href=""" & PathInfo() & "?hls=1&ln=" & Abs(CInt(bShowLineNumbers)) & "&ViewSource=1&FolderSpec=" & Server.UrlEncode(FolderSpec) & "&FileSpec=" & Server.UrlEncode(FileSpec) & """>Turn on syntax highlighting</a>"
  End If
  

  echo ""


  
  If bShowSyntaxHighlighting Then 
    echo ""
    bInsideASP = False
    bWaitingForMoreChars = False
    bCommentOn = False
    bInsideQuote = False
    Buffer = Tso.ReadAll
    Response.Write "<span class=""OutsideASP"">"
    For i = 1 To Len(Buffer)
      cPrefix = ""
      cPostfix = ""
      c = Mid(Buffer, i, 1)
      If bInsideAsp Then 
        Select Case C
        Case ">" 
          If Not bInsideQuote Then
            If bWaitingForMoreChars Then 
              bInsideAsp = False
              cPrefix =  "</span><span class=""AspTransition"">"
              cPostfix = "</span><span class=""OutsideASP"">"
            End If
          End If
          bWaitingForMoreChars = False
        Case VbCr 
          If Not bInsideQuote Then 
            If bCommentOn Then
              bCommentOn = False
              cPostfix = "</span><span class=""InsideASP"">"
            End If
          End If
          bWaitingForMoreChars = False
        Case "%" 'stop right here, wait to see if next char is a greater than symbol.
          If Not bInsideQuote Then 
            bWaitingForMoreChars = True
          End If
        Case "'" 
          If Not bInsideQuote Then 
            bCommentOn = True
            cPrefix = "</span><span class=""AspComment"">"
          End If
          bWaitingForMoreChars = False
        Case Chr(34) 
          If Not bCommentOn Then 
            If bInsideQuote Then 
              bInsideQuote = False
              cPostfix = "</span><span class=""InsideASP"">"
            Else
              bInsideQuote = True
              cPrefix = "</span><span class=""InsideQuote"">"
            End If
          End If
          bWaitingForMoreChars = False
        Case Else
          bWaitingForMoreChars = False
        End Select
      Else
        If bWaitingForMoreChars Then 
          If c = "%" Then 
            bInsideAsp = True
            cPrefix = "</span><span class=""AspTransition"">"
            cPostFix = "</span><span class=""InsideASP"">"
          End If
          bWaitingForMoreChars = False
        Else
          If c = "<" Then 'stop right here, wait to see if next char is a percent symbol.
            bWaitingForMoreChars = True
          Else
            bWaitingForMoreChars = False
          End If
        End If
      End If
      If bShowLineNumbers Then
        If c = VbLf Then 
          LN = LN + 1
        End If
        If i = 1 Then 
          response.write "<span class=""LineNumber"">" & LN & "</span>" & VbTab
        Else
          If c = VbLf Then 
            cpostfix = cpostfix & "<span class=""LineNumber"">" & LN & "</span>" & VbTab
          End If
        End If
      End If
      If bWaitingForMoreChars Then 
        cLast = cLast & C
      Else
        Response.Write cPrefix & server.htmlencode(cLast & C) & cPostfix
        cLast = ""
      End If
    Next
  Else
    Do While Not tso.atendofstream
      i = i + 1
      response.write vbnewline
      If bShowLineNumbers Then response.write "<span class=""LineNumber"">" &  i & "</span>" & VbTab 
      response.write server.htmlencode(tso.readline)
    Loop
  End If
  tso.close
  Set tso = Nothing
  NewBuffer.Position = 0
  Response.Write NewBuffer.ReadText
  NewBuffer.Close
  Set NewBuffer = Nothing
  echo "</pre>"
End Sub




'###########################################################################
'#
'#  Tertiary Functions and Utilities
'#
'##########


'___________________________________________________________________
Function FilenameAsUrl(s)
  FilenameAsUrl = Replace(Server.UrlEncode(oFso.GetBaseName(s)),"+","%20") & Ext(s)
End Function

'___________________________________________________________________
'EXT RETURNS THE dot IN THE FILENAME
function ext(byval fname)
  If InStr(fname, ".") > 0 Then
    ext = lcase(mid(fname,inStrRev(fname,".")))
  Else
    ext = ""
  End If
end function 

'___________________________________________________________________
Function ColumnClass(i)
  Select Case i
    case ColumnOrdinal_LastModified
      ColumnClass = "lm"
    case ColumnOrdinal_Size
      ColumnClass = "sz"
    case ColumnOrdinal_Filename
      ColumnClass = "fn"
  End Select
End Function

'___________________________________________________________________
Function P()
  p = Request.ServerVariables("PATH_INFO")
End Function

'___________________________________________________________________
'Replacement for Server.MapPath
Function MapPath(ByVal path)
  Dim i
  Dim arrBadChars
  Dim arrDidReplace
  Dim arrGoodChars
  arrBadChars =       Array(";"     ,","    ,"'"    ,"]")
  arrDidReplace =     Array(False   ,False  ,False  ,False)
  arrGoodChars  =     Array("%3B"   ,"%2C"  ,"%27"  ,"%5D")
  For i = 0 To UBound(arrBadChars)
    If InStr(path, arrBadChars(i)) > 0 Then
      path = Replace(path, arrBadChars(i), arrGoodChars(i))
      arrDidReplace(i) = True
    End If 
  Next
  Path = Server.MapPath(path)
  For i = 0 To UBound(arrBadChars)
    If arrDidReplace(i) Then
      Path = Replace(path, arrGoodChars(i), arrBadChars(i))
    End If 
  Next
  MapPath = Path
End Function



' ________________________________________ 
Function TypeCast(ByVal What, ByVal WhatType, ByVal DefaultValue)
  Dim result, i
  if vartype(What) = WhatType Then
    result = What ' no problem! lets split and get back to work.
  else
    ' not specifically that type. 
    ' Ok, lets try and convert it.
    on error resume next
    select case WhatType
      case vbInteger
        result = CInt(what)
      case vbLong
        result = CLng(what)
      case vbSingle
        result = CSng(what)
      case vbDouble
        result = CDbl(what)
      case vbCurrency
        result = CCur(what)
      case vbDate
        result = CDate(what)
      case vbString
        result = CStr(what)
      case vbBoolean
        result = CBool(what)
      case vbByte
        result = CByte(what)
      case VbEnum '### NOTE!! IMPORTANT!! VbEnum is NOT a built-in vb value: 
                  ' This is something that I made up myself-
                  ' you MUST declare VbEnum as a global CONST
                  ' for this to work!!!! (i use 100 - its far enough away 
                  ' from any other VbXXX constants that its not likely to 
                  ' interfereany time soon)
        'to use this option, pass an ARRAY of possible enum values
        ' in the "DefaultValue" argument. 
        ' If "what" does not match any of the values of the array,
        ' then TypeCast() will return the first value in the array.
        'echo ";&nbsp;&nbsp;&nbsp;what=" & what & " " & typename(what) 
        for i = 0 to ubound(DefaultValue)
          if what = DefaultValue(i) then 
            result = what
            exit for
          else
            result = defaultValue(0)
          end if 
        next
    end select 
    if err.number <> 0 then 
      Result = DefaultValue 'sorry pal. you trying to fake us out. no soup for you.
    end if
    on error goto 0
  End If
  TypeCast = result
End Function



'__________________________________________________________

'__________________________________________________________
Function pathinfo()
  pathinfo = Request.ServerVariables("PATH_INFO")
End Function

'************************************************************************
' Just an error-free wrapper. Especially handy in the case of html-encoding values
' directly from an SQL recordset, because "Server.HtmlEncode" chokes on nulls. 
'___________________________________________________________________
Function HtmlEncode(s)
	HtmlEncode = Server.HtmlEncode(Typecast(s,VbString,""))
End Function

'____________________________________________________________________
Function echo(s)
  Response.write vbnewline & s
End Function




'______________________________________________________________________________
Function bDeveloperMode
	Dim Result
	Result = False
	If request.servervariables("REMOTE_ADDR") = "64.251.68.235" _
		or request.servervariables("REMOTE_ADDR") = "64.251.68.238" _
		or request.servervariables("REMOTE_ADDR") = "64.251.68.232" _
		Then 
		Result = True
	End If
	bDeveloperMode = Result
End Function


'___________________________________________________________________
Sub Debug(s)
	DebugL "Debug", s
End Sub


'___________________________________________________________________
Sub DebugL(label, value)
	If bDeveloperMode Then 
		echo "<div style=""font-family: Courier New, Courier, mono, monospace; font-size: 10pt; "">" _
		& " <font color=""#aaaaaa"">" & htmlencode(label) & ":</font>" _ 
		& " <font color=""#0000aa"">" & HtmlEncode(value) & "</font>" _ 
		& " <font color=""#aaaaaa"">(" & TypeName(value) & ")</font>" _ 
		& "</div>"
	End If
End Sub


'___________________________________________________________________
Sub DebugE(s)
	Dim ErrorCheck
	On Error Resume Next
	ErrorCheck = eval(s)
	ErrorCheck = err.number 
	On Error GoTo 0
	If ErrorCheck = 0 Then 
		If Not IsEmpty(Eval(s)) Then 
			DebugL s, eval(s)
		Else
			DebugL "Debug:", s
		End If
	Else
		DebugL "Debug:", s
	End If
End Sub




'___________________________________________________________________
Function bFilenameHasIllegalChars(byVal s, bIgnoreSlashes)
  dim i 'as integer - used for incrementing through each character of the string
  dim Result 'as boolean - status of our investigating
  dim c 'as string - each piece of the string as we move through it
  dim a 'as integer - the numeric Ascii value of c
  ' looks for any non alphanumeric characters, returns false if the string is 'clean'
  Result = False 'innocent until proven guilty.
  If VarType(s) <> VbString Then 
    Result = True
  Else
    for i = 1 to len(s)
      c = mid(s,i,1)
      a = asc(c)
      Select Case True
        '    (n.p  ),  ",  *,  :,  <,  >,  ?,   |
        Case (a <= 31)
          'not printable
          Result = True
          Exit For
        Case (a = 34 Or a = 42 or a = 58 or a = 60 or a = 62 or a = 63 or a = 124)
          'is an illegal character. 
          Result = True
          Exit For
        '     /,  \
        Case (a = 47 Or a = 92)
          'is a back or forward slash
          If Not bIgnoreSlashes Then 
            Result = True
            Exit For
          End If 
        Case True
          'is printable and not illegal. don't do anything.
      End Select 
    Next
  End If
  bFilenameHasIllegalChars = Result
End Function




'___________________________________________________________________
Function bShowFile(ByRef objFile)
  Dim Result
  Dim Attributes, Hidden, System, Alias
  Result = True
  Attributes = objFile.attributes
  Hidden = cbool(attributes and FileAttribute_Hidden) 
  System = cbool(attributes and FileAttribute_System) 
  Alias = cbool(attributes and FileAttribute_Alias) 
  dim ppath
  Dim vpath
  ppath = objFile.path
  vpath = Replace(ppath, DefaultPhysPath, "", 1, 1, vbTextCompare)
  vpath = replace(vpath, "\", "/")
	if InArray(vpath, arrPathsToExclude) Then 
		Result = False
	End If 
	If StrComp(DefaultVpath & vpath, PathInfo(), VbTextCompare) = 0 then 
		Result = False
	End If
  if Alias then
    if not ShowAlias Then Result = False
  end if
  If Hidden Then
    If Not ShowHidden Then Result = False
  end if
  If System Then
    If Not SHowSystem Then Result = False
  End If
  bShowFile = Result
End Function



'___________________________________________________________________
sub echo(s)
  response.write vbnewline & s
end sub
'___________________________________________________________________
sub br(s)
  echo "<br>" & s
end sub
'___________________________________________________________________
Function Table(s)
  table = VbNewLine & "<table>" & s & "</table>"
End Function
'___________________________________________________________________
Function th(s)
  th = VbNewLine & "<th>" & s & "</th>"
End Function
'___________________________________________________________________
Function td(s)
  td = VbNewLine & "<td class=""td"">" & s & "</td>"
End Function
'___________________________________________________________________
Function Tr(s)
  tr = VbNewLine & "<tr>" & s & "</tr>"
End Function


'___________________________________________________________________
Sub SwapRows(ary,row1,row2)
  '== This proc swaps two rows of an array 
  Dim x,tempvar
  For x = 0 to Ubound(ary,2)
    tempvar = ary(row1,x)    
    ary(row1,x) = ary(row2,x)
    ary(row2,x) = tempvar
  Next
End Sub  'SwapRows

'___________________________________________________________________
Sub QuickSort(vec,loBound,hiBound,SortField)
  '==--------------------------------------------------------==
  '== Sort a 2 dimensional array on SortField                ==
  '==                                                        ==
  '== This procedure is adapted from the algorithm given in: ==
  '==    ~ Data Abstractions & Structures using C++ by ~     ==
  '==    ~ Mark Headington and David Riley, pg. 586    ~     ==
  '== Quicksort is the fastest array sorting routine For     ==
  '== unordered arrays.  Its big O is  n log n               ==
  '==                                                        ==
  '== Parameters:                                            ==
  '== vec       - array to be sorted                         ==
  '== SortField - The field to sort on (2nd dimension value) ==
  '== loBound and hiBound are simply the upper and lower     ==
  '==   bounds of the array's 1st dimension.  It's probably  ==
  '==   easiest to use the LBound and UBound functions to    ==
  '==   Set these.                                           ==
  '==--------------------------------------------------------==

  Dim pivot(),loSwap,hiSwap,temp,counter
  Redim pivot (Ubound(vec,2))
  '== Two items to sort
  if hiBound - loBound = 1 then
    if vec(loBound,SortField) > vec(hiBound,SortField) then 
      Call SwapRows(vec,hiBound,loBound)
    End If
  End If

  '== Three or more items to sort
  For counter = 0 to Ubound(vec,2)
    pivot(counter) = vec(int((loBound + hiBound) / 2),counter)
    vec(int((loBound + hiBound) / 2),counter) = vec(loBound,counter)
    vec(loBound,counter) = pivot(counter)
  Next

  loSwap = loBound + 1
  hiSwap = hiBound
  Do
    '== Find the right loSwap
    while loSwap < hiSwap and vec(loSwap,SortField) <= pivot(SortField)
      loSwap = loSwap + 1
    wend
    '== Find the right hiSwap
    while vec(hiSwap,SortField) > pivot(SortField)
      hiSwap = hiSwap - 1
    wend
    '== Swap values if loSwap is less then hiSwap
    if loSwap < hiSwap then Call SwapRows(vec,loSwap,hiSwap)


  Loop While loSwap < hiSwap
  
  For counter = 0 to Ubound(vec,2)
    vec(loBound,counter) = vec(hiSwap,counter)
    vec(hiSwap,counter) = pivot(counter)
  Next
    
  '== Recursively call function .. the beauty of Quicksort
    '== 2 or more items in first section
    if loBound < (hiSwap - 1) then Call QuickSort(vec,loBound,hiSwap-1,SortField)
    '== 2 or more items in second section
    if hiSwap + 1 < hibound then Call QuickSort(vec,hiSwap+1,hiBound,SortField)

End Sub  'QuickSort

Function bShowLineNumbers
  Dim ln, result
  ln = Request("ln")
  If ln = "1" Then 
    Result = True
  ElseIf ln = "0" Then 
    result = False
  Else
    result = bLineNumberingOnByDefault
  End If
  bShowLineNumbers = result
End Function

Function bShowSyntaxHighlighting
  Dim hls, result
  hls = Request("hls")
  If hls = "1" Then 
    Result = True
  ElseIf hls = "0" Then 
    result = False
  Else
    result = bSyntaxHighlightingOnByDefault
  End If
  bShowSyntaxHighlighting = result
End Function 


Function bStillHasUnclosedQuotes(ByVal Chunk)
  Dim Result, i, c
  Dim bInsideSingleQuote
  Dim bInsideDoubleQuote
  Result = False
  bInsideSingleQuote = False
  bInsideDoubleQuote = False
  For i = 1 to len(chunk)
    c = mid(chunk,i,1)
    If (Not(bInsideSingleQuote)) And (Not(bInsideDoubleQuote)) Then
      If c = Chr(34) then 
        bInsideDoubleQuote = True
      ElseIf c = "'" then 
        bInsideSingleQuote = True
      end if
    Elseif (bInsideDoubleQuote) Then 
      If c = Chr(34) then 
        bInsideDoubleQuote = False
      end if
    Elseif (bInsideSingleQuote) Then
      If c = "'" then 
        bInsideSingleQuote = False
      end if
    End If  
  Next
  Result = bInsideSingleQuote Or bInsideDoubleQuote
  If Result Then
    'br "364: CHUNK STILL INSIDE QUOTES!!!"
  Else
    'br "366: Chunk Not in quotes. Safe to continue."
  End If
  bStillHasUnclosedQuotes = Result
End Function

	'*******************************************************
	' Pass this an array to look through, and a value to look for.
	' Returns: Boolean.
	'______________________________________________________________________________
	Function InArray(ByVal vNeedle, ByVal aHaystack)
	  Dim i
	  Dim Result
	  Result = False
	  For i = 0 To UBound(aHaystack)
	    If strComp(aHaystack(i), vNeedle, VbTextCompare) = 0 Then 
	      Result = True
	      Exit For
	    End If
	  Next
	  InArray = Result
	End Function



'###########################################################################
'#
'#  End of File.
'#
'##########
%>