<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<%
Page = "ManagementUserMaintenance"

If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then Response.Redirect("Default.asp")
If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then Response.Redirect("Default.asp")

'REE 1/27/9 - Make sure the user is authorized to use this program
If SecurityCheck("UserMaintenance") <> True Then Response.Redirect("Default.asp")

%>
<HTML>
<HEAD>
<TITLE>Tix - User Security Log</TITLE>
</HEAD>
<BODY BGCOLOR="#FFFFFF">
<CENTER>
<!--#INCLUDE VIRTUAL="TopNavInclude.asp"-->
<BR>
<FONT FACE="verdana, arial, helvetica" COLOR="#008400" SIZE="2"><H3>User Security Log</H3></FONT>

<%
SQLUser = "SELECT Users.UserNumber, Users.FirstName, Users.LastName, Users.UserID, Organization.Organization FROM Users (NOLOCK) INNER JOIN Organization (NOLOCK) ON Users.OrganizationNumber = Organization.OrganizationNumber WHERE Organization.OrganizationNumber = " & Session("OrganizationNumber") & " AND Status <> 'D' ORDER BY FirstName, LastName"
Set rsUser = OBJdbConnection.Execute(SQLUser)

If Not rsUser.EOF Then 
	Response.Write "<TABLE CELLPADDING=3><TR BGCOLOR=#008400><TD VALIGN=top ALIGN=center><FONT FACE=verdana,arial,helvetica COLOR=#FFFFFF SIZE=2><B>Organization</B></FONT></TD><TD VALIGN=top ALIGN=center><FONT FACE=verdana,arial,helvetica COLOR=#FFFFFF SIZE=2><B>Name</B></FONT></TD><TD VALIGN=top ALIGN=center><FONT FACE=verdana,arial,helvetica COLOR=#FFFFFF SIZE=2><B>User ID</B></FONT></TD><TD VALIGN=top ALIGN=center><FONT FACE=verdana,arial,helvetica COLOR=#FFFFFF SIZE=2><B>View Records</B></FONT></TD></TR>" & vbCrLf

	Do Until rsUser.EOF
		Response.Write "<TR><TD VALIGN=top ALIGN=left BGCOLOR=#DDDDDD><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsUser("Organization") & "</FONT></TD><TD VALIGN=top ALIGN=left BGCOLOR=#DDDDDD><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsUser("FirstName") & " " & rsUser("LastName") & "</FONT></TD><TD VALIGN=top ALIGN=left BGCOLOR=#DDDDDD><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsUser("UserID") & "</FONT></TD><TD VALIGN=top ALIGN=left BGCOLOR=#DDDDDD><FONT FACE=verdana,arial,helvetica SIZE=2><A HREF=UserSecurityRecords.asp?UserNumber=" & rsUser("UserNumber") & ">View</A></FONT></TD></TR>" & vbCrLf
		rsUser.MoveNext
	Loop

	Response.Write "</TABLE>" & vbCrLf
End If

%>

</CENTER>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

