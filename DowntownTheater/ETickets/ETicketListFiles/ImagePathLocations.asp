	

<%
Option Explicit

Dim FSO
Dim FolderName
Dim FileName
Dim FilePath
DIM Msg

FolderName = "Images"
FileName = "ETicketBackground.gif"
FilePath = (server.mappath(FolderName&"/"&FileName))

Set FSO = Server.CreateObject("Scripting.FileSystemObject")

If (FSO.FileExists(FilePath)) Then
	Msg = "File exists"
Else
	Msg =  "File does not exists"
End If

set FSO = nothing

%>

<!-- #include file="header.asp" -->

<!-- #include file="navbar.asp" -->


<div class="container">
  <h1 class="page-title">Article Index</h1>
</div>

<div class="container">

<h4>FileName</h4>
<%=FileName%><BR>
<BR>
<h4>FolderName</h4>
<%=FolderName%><Br>
<br>
<h4>FilePath</h4>
<%=FilePath%><br>
<Br>
<h4>Message</h4>
<%=Msg%><br>
<br>

<h4>Local Image</h4>
Images/ETicketBackground.gif - local image
<TABLE WIDTH="615" HEIGHT="240" BORDER="1" BACKGROUND="Images/ETicketBackground.gif" BGCOLOR="#FFD718" CELLPADDING="0" CELLSPACING="0">
<tr><td></td></tr>
</table>

<h4>Remote Image</h4>
/Images/ETicketBackground.gif - remote image
<TABLE WIDTH="615" HEIGHT="240" BORDER="1" BACKGROUND="/Images/ETicketBackground.gif" BGCOLOR="#FFD718" CELLPADDING="0" CELLSPACING="0">
<tr><td></td></tr>
</table>


</div>

<!-- #include file="footer.asp" -->
	

<%


' **********************************
' Function to check file Existance
' **********************************
Function IsFileExists(byVal FileName)
 
 If FileName = ""  Then
  IsFileExists = False
  Exit Function
 End If
 
 Dim objFSO
    
 Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
    
 If (objFSO.FileExists( FileName )) = True  Then
  IsFileExists = True
 Else
  IsFileExists = False
 End If
  
 Set objFSO = Nothing   
End Function
%> 