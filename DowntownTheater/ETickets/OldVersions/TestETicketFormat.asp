
<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->

<%

Page = "Management"
SecurityFunction = "SupportDashboard"
ReportFileName = "Dashboard.asp"
ReportTitle = "Support Dashboard"

'===============================================

Server.ScriptTimeout = 1200

If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then Response.Redirect("/Management/Default.asp")

If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then Response.Redirect("/Management/Default.asp")

If SecurityCheck("SecurityFunction") = False Then Response.Redirect("/Management/Default.asp")


'===============================================


Dim FSOobj,FilePath,FolderPath

Dim FileName(5)

FileName(1) = "ETicketLogo"
FileName(2) = "ETicketBackground"
FileName(3) = "ETicketBottomBar"
FileName(4) = "ETicketMap"
FileName(5) = "ETicketAd"

Dim FolderName(5)

FolderName(1) = "images"
FolderName(2) = "images"
FolderName(3) = "images"
FolderName(4) = "images"
FolderName(5) = "images"

For i = 1 to uBound(FileName)

	FilePath = Server.MapPath("images/"&FileName(i)&".asp") 
	FolderPath = Server.MapPath("images/") 

	Set FSOobj = Server.CreateObject("Scripting.FileSystemObject")

	If  FSOobj.fileExists(FilePath) Then
		Response.Write " "&FileName(i)&": file located!<BR><BR> "
		FolderName(i) = FolderPath
		Response.Write "Folder Name: "&FolderName(i)&" <BR><BR>"
	Else
		Response.Write " "&FileName(i)&": error! file not found<BR><BR>"
		Response.Write "Folder Name: "&FolderName(i)&" <BR><BR>"
	End If

Set FSOobj = Nothing

Next
%>