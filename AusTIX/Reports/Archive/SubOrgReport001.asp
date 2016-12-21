<!--#include virtual="GlobalInclude.asp"-->
<!--#include virtual="dbOpenInclude.asp"-->
<%
Page = "ManagementReport"


'Check Needed Session Variables
If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then Response.Redirect("/Management/Default.asp")

'If the Organization is not ACPA or Tix, redirect them.
If Session("OrganizationNumber") <> 1 And Session("OrganizationNumber") <> 700 Then Response.Redirect("/Management/Default.asp")

%>
<!--#include virtual="TopNavInclude.asp" -->
<%

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>www.TIX.com - Austin Circle of Theaters Sub-Organization Report</TITLE>" & vbCrLf
Response.Write "</HEAD>" & vbCrLf
Response.Write "<BODY BGCOLOR=#FFFFFF>" & vbCrLf

Response.Write "<CENTER><FONT FACE=verdana,arial,helvetica COLOR=#008400><H3>Austin Circle of Theaters<BR>Sub-Organization Report</H3></FONT>" & vbCrLf
Response.Write "<TABLE CELLPADDING=""3""><TR BGCOLOR=""#008400""><TD ALIGN=""center""><FONT FACE='verdana,arial,helvetica' COLOR=""#FFFFFF"" SIZE=2><B>Sub-Organization Name</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=""#FFFFFF"" SIZE=2><B>User Name</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=""#FFFFFF"" SIZE=2><B>User ID</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=""#FFFFFF"" SIZE=2><B>Password</B></FONT></TD></TR>" & vbCrLf

SQLReport = "SELECT Organization.Organization, Users.FirstName, Users.LastName, Users.UserID, Users.UserNumber FROM Users INNER JOIN Organization ON Organization.OrganizationNumber = Users.OrganizationNumber WHERE (Users.OrganizationNumber IN (SELECT SubOrganizationNumber FROM SubOrganization WHERE (OrganizationNumber = 700)))"
Set rsReport = OBJdbConnection.Execute(SQLReport)

Do Until rsReport.EOF
		
		Response.Write "<TR BGCOLOR=""#DDDDDD""><TD><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsReport("Organization") & "</FONT></TD></TD><TD ALIGN=""left""><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsReport("FirstName") & " " & rsReport("LastName") & "</FONT></TD><TD ALIGN=""left""><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsReport("UserID") & "</FONT></TD><TD ALIGN=""center""><FONT FACE='verdana,arial,helvetica' SIZE=2><a href=""https://www.tix.com/Management/UserModify.asp?UserNumber=" & rsReport("UserNumber") & """>Modify</a></FONT></TD></TR>" & vbCrLf

		rsReport.MoveNext		

		Loop

Response.Write "</TABLE></CENTER><BR><BR>" & vbCrLf

%>
<!--#include virtual="FooterInclude.asp"-->
<%

Response.Write "</BODY>" & vbCrLf
Response.Write "</HTML>" & vbCrLf

%>


