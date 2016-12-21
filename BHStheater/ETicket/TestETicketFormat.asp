
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

Dim ImageName(4)
ImageName(1) = "BackgroundImage"
ImageName(2) = "LogoImage"
ImageName(3) = "BottemBar"
ImageName(4) = "AdvertisingSpace"

Dim ImageLocation(4)
ImageLocation(1) = "images"
ImageLocation(2) = "images"
ImageLocation(3) = "images"
ImageLocation(4) = "images"

set FileSysObj = CreateObject("Scripting.FileSystemObject")
FileAndPath = Request.Servervariables("SCRIPT_NAME")
PathOnly = Mid(FileAndPath,1 ,InStrRev(FileAndPath, "/")) & "Images"


For i = 1 to uBound(ImageName)

	FilePath = Server.MapPath("images/"&ImageName(i)&".jpg") 
	FolderPath = Server.MapPath("images/") 

	Set FSOobj = Server.CreateObject("Scripting.FileSystemObject")

	If  FSOobj.fileExists(FilePath) Then
		ImageName(i) = ImageName(i) & ".jpg"
		ImageLocation(i) = PathOnly &"/"&ImageName(i)		
	Else
		ImageName(i) = ImageName(i) & ".gif"
		ImageLocation(i) = PathOnly &"/"&ImageName(i)
	End If

	Set FSOobj = Nothing

Next

For i = 1 to UBound(ImageLocation)

Response.Write "<IMG SRC = """ & ImageLocation(i) & """ >" & vbCrLf
Response.Write "<HR>"

Next


%>