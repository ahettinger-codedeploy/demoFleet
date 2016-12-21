<!--#include virtual="GlobalInclude.asp"-->
<!--#include virtual="dbOpenInclude.asp"-->
<%
Page = "ManagementReport"


'Check Needed Session Variables
If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then Response.Redirect("Default.asp")

'REE 9/16/5 - Modified to use User's organization rather than Session Organization
SQLUserOrg = "SELECT OrganizationNumber FROM Users (NOLOCK) WHERE UserNumber = " & Session("UserNumber")
Set rsUserOrg = OBJdbConnection.Execute(SQLUserOrg)

If rsUserOrg("OrganizationNumber") <> "1" Then Response.Redirect("Default.asp")

If rsUserOrg("OrganizationNumber") <> "700" Then Response.Redirect("Default.asp")

rsUserOrg.Close
Set rsUserOrg = nothing



%>
<!--#include virtual="TopNavInclude.asp" -->
<%

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>www.TIX.com - Austin Circle of Theaters Sub-Organization Management</TITLE>" & vbCrLf
Response.Write "</HEAD>" & vbCrLf
Response.Write "<BODY BGCOLOR=#FFFFFF>" & vbCrLf

Response.Write "<CENTER><FONT FACE=verdana,arial,helvetica COLOR=#008400><H3>Austin Circle of Theaters<BR>Sub-Organization Report</H3></FONT>" & vbCrLf
Response.Write "<TABLE CELLPADDING=""3""><TR BGCOLOR=""#008400""><TD ALIGN=""center""><FONT FACE='verdana,arial,helvetica' COLOR=""#FFFFFF"" SIZE=2><B>Number</B></FONT></TD><TD ALIGN=""center""><FONT FACE='verdana,arial,helvetica' COLOR=""#FFFFFF"" SIZE=2><B>Name</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=""#FFFFFF"" SIZE=2><B>User Name</B></FONT></TD></TR>" & vbCrLf

SQLReport = "SELECT Organization.OrganizationNumber, (Select Left(Organization, Len(Organization)-8)) as Organization, Users.FirstName, Users.LastName, Users.UserID, Users.UserNumber FROM Users INNER JOIN Organization ON Organization.OrganizationNumber = Users.OrganizationNumber WHERE (Users.OrganizationNumber IN (SELECT SubOrganizationNumber FROM SubOrganization WHERE (OrganizationNumber = 700))) ORDER BY Organization"
Set rsReport = OBJdbConnection.Execute(SQLReport)

Do Until rsReport.EOF
		
		Response.Write "<TR BGCOLOR=""#DDDDDD""><TD><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsReport("OrganizationNumber") & "</FONT></TD><TD><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsReport("Organization") & "</FONT></TD></TD><TD ALIGN=""left""><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsReport("FirstName") & " " & rsReport("LastName") & "</FONT></TD></TR>" & vbCrLf

		rsReport.MoveNext		

		Loop

Response.Write "</TABLE></CENTER><BR><BR>" & vbCrLf

Response.Write "<FORM ACTION=""OrganizationMaintenance.asp"" METHOD=""post"" id=form1 name=form1><INPUT TYPE=""hidden"" NAME=""rganizationNumber"" VALUE=""NEW""><INPUT TYPE=""submit"" VALUE=""Add Organization"" id=submit1 name=submit1></FORM>" & vbCrL

%>
<!--#include virtual="FooterInclude.asp"-->
<%

Response.Write "</BODY>" & vbCrLf
Response.Write "</HTML>" & vbCrLf
%>



