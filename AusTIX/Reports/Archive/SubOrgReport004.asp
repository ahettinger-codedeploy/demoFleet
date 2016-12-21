<!--#include virtual="GlobalInclude.asp"-->
<!--#include virtual="dbOpenInclude.asp"-->
<%
Page = "ManagementReport"

'Initalize Report Variables
ParentOrgNumber = 700

If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then Response.Redirect("Default.asp")

		SQLUserOrg = "SELECT OrganizationNumber FROM Users (NOLOCK) WHERE UserNumber = " & Session("UserNumber")
		Set rsUserOrg = OBJdbConnection.Execute(SQLUserOrg)

		If rsUserOrg("OrganizationNumber") <> "1" And  rsUserOrg("OrganizationNumber") <> " & ParentOrgNumber & " Then Response.Redirect("Default.asp")

				OrganizationNumber = rsUserOrg("OrganizationNumber")

				rsUserOrg.Close
				Set rsUserOrg = nothing


				If Request("FormName") = "Update" Then
					Call Update
				ElseIf Request("OrganizationNumber") <> "" Then
					Call Add_Organization(Message)
				Else
					Call OrganizationList
				End If



'=====================

Sub OrganizationList


%>
<HTML>
<HEAD>
<TITLE>Tix - SubOrganization Maintenance</TITLE>

<style type="text/css">
<!--
a.sort:link  {color: #FFFFFF; font-weight: bold; text-decoration: underline;}
a.sort:visited  {color: #FFFFFF; font-weight: bold; text-decoration: underline;}
a.sort:active  {color: #FFFFFF; font-weight: bold; text-decoration: underline;}
a.sort:hover  {color: #FFFFFF; font-weight: bold; text-decoration: underline;}
a.ClickHere:link  {color: #0000FF; font-weight: bold; text-decoration: underline;}
a.ClickHere:visited  {color: #0000FF; font-weight: bold; text-decoration: underline;}
a.ClickHere:active  {color: #0000FF; font-weight: bold; text-decoration: underline;}
a.ClickHere:hover  {color: #0000FF; font-weight: bold; text-decoration: underline;}
-->
</style>

</HEAD>
<BODY BGCOLOR="#FFFFFF">
<CENTER>
<!--#INCLUDE VIRTUAL="TopNavInclude.asp"-->
<BR>
<FONT FACE="verdana, arial, helvetica" COLOR="#008400" SIZE="2"><H3>Austin Circle of Theatres</H3></FONT>
<FONT FACE="verdana, arial, helvetica" COLOR="#008400" SIZE="2"><H3>Sub-Organization Maintenance</H3></FONT>

<% 
Response.Write "<BR>" & vbCrLf
Response.Write "<TABLE CELLPADDING=""0""><TR BGCOLOR=""#008400""><TD ALIGN=""center""><FONT FACE='verdana,arial,helvetica' COLOR=""#FFFFFF"" SIZE=2><B>Number</B></FONT></TD><TD ALIGN=""center""><FONT FACE='verdana,arial,helvetica' COLOR=""#FFFFFF"" SIZE=2><B>Sub-Organization</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=""#FFFFFF"" SIZE=2><B>Name</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=""#FFFFFF"" SIZE=2><B>User ID & Password</B></FONT></TD></TR>" & vbCrLf

SQLReport = "SELECT Organization.OrganizationNumber, (Select Left(Organization, Len(Organization)-8)) as Organization, Users.FirstName, Users.LastName, Users.UserID, Users.UserNumber FROM Users INNER JOIN Organization ON Organization.OrganizationNumber = Users.OrganizationNumber WHERE (Users.OrganizationNumber IN (SELECT SubOrganizationNumber FROM SubOrganization WHERE (OrganizationNumber = " & ParentOrgNumber & "))) ORDER BY Organization"
Set rsReport = OBJdbConnection.Execute(SQLReport)

Do Until rsReport.EOF
		
		Response.Write "<TR BGCOLOR=""#DDDDDD""><TD><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsReport("OrganizationNumber") & "</FONT></TD><TD><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsReport("Organization") & "</FONT></TD></TD><TD ALIGN=""left""><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsReport("FirstName") & " " & rsReport("LastName") & "</FONT></TD>" & vbCrLf
		
		SQLUserEmail = "SELECT EMailAddress from Users (NOLOCK) WHERE UserNumber = " & rsReport("UserNumber") & " "
		Set rsUserEmail = OBJdbConnection.Execute(SQLUserEmail)		
		EmailAddress = rsUserEmail("EMailAddress")
		rsUserEmail.Close
		Set rsUserEmail = nothing
		
		If EmailAddress = "" Or IsNull(EmailAddress) Then 
		%>
		<TD ALIGN="center" VALIGN="middle"><FONT FACE="verdana,arial,helvetica" SIZE=1><FORM ACTION="SubOrgReport.asp" METHOD="post" Name="EMailUpdate"><INPUT TYPE="hidden" NAME="FormName" VALUE="EmailUpdate"><INPUT TYPE="hidden" NAME="UserID" VALUE="<%=UserID%>"><input type="submit" value="Update EMail Address" style="Border: none; background: none; Color: #0000FF; Font-size: 10px; text-decoration: underline"></FORM></FONT></TD>
		<% 
		Else
		%>
		<FORM ACTION="/Management/PasswordReset.asp" METHOD="post" Name="EMailForm"><INPUT TYPE="hidden" NAME="FormName" VALUE="EmailRequest"><INPUT TYPE="hidden" NAME="EmailAddress" VALUE="<%=EmailAddress%>"><INPUT TYPE="submit" VALUE="Send Email" id=submit1 name=submit1><TD ALIGN="center" VALIGN="middle"><FONT FACE="verdana,arial,helvetica" SIZE=2></FONT></TD></FORM>
		<% 
		End If
				
		Response.Write "</TR>" & vbCrLf

		rsReport.MoveNext		

Loop

Response.Write "</TABLE>" & vbCrLf
Response.Write "<BR><BR>" & vbCrLf

If OrganizationNumber = 1 Then 
Response.Write "<FORM ACTION=""SubOrgReport.asp"" METHOD=""post"" id=form1 name=Add_Organization><INPUT TYPE=""hidden"" NAME=""OrganizationNumber"" VALUE=""NEW""><INPUT TYPE=""submit"" VALUE=""Create New Sub-Organization"" id=submit1 name=submit1></FORM>" & vbCrL
End If

%>

</CENTER>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<% 

End Sub 'OrganizationList

'==============================

Sub Add_Organization(Message)

%>

<HTML>
<HEAD>
<TITLE>Tix - SubOrganization Maintenance</TITLE>
</HEAD>
<BODY BGCOLOR="#FFFFFF">

<!--#INCLUDE VIRTUAL="TopNavInclude.asp"-->

<% 

SubOrganization = ""
OrganizationNumber = Session("OrganizationNumber")
SubOrganizationNumber = Clean(Request("OrganizationNumber"))
CCProcessor = "N/A"
MerchantAccountNumber = "N/A"
AddressPrintFormat = "0"
TicketPrintFormat = "185"
FooterPrintFormat = "0"
TixFulfillment = "False"
StatusCode ="A"
AcceptReservations = "N"
OrderExpirationDelay = "30"
TimeZoneOffset = "-360"
TixCallCenter = "No"
Comments = "Austin Circle of Theaters Sub Organization"

%>

<BR>
<FONT FACE="verdana, arial, helvetica" COLOR="#008400" SIZE="2"><H3>Add New Sub-Organization</H3></FONT>

<fieldset style="width:650px">
<legend style="color:#000;font-size:13px;font-weight:bold">Sub-Organization Fixed Parameters</legend>
<FORM ACTION="SubOrgReport.asp" METHOD="post" id=form1 name=form1>
<TABLE>
  <tr>
    <td align="right"><font size="2">Organization Number:</font></td>
    <td><input type="text" name="OrganizationNumber" value="<%=OrganizationNumber%>" size="20" readonly style="background-color: #b6c8da"/>&nbsp;&nbsp;&nbsp;</td>
    <td align="right"><font size="2">Sub-Org Number:</font></td>
    <td><input type="text" name="SubOrganizationNumber" value="<%=SubOrganizationNumber%>" size="20" readonly style="background-color: #b6c8da"  /></td>
  </tr>
  <tr>
    <td align="right"><font size="2">CCProcessor:</font></td>
    <td><input type="text" name="CCProcessor" value="<%=CCProcessor%>" size="20" readonly style="background-color: #b6c8da" />&nbsp;&nbsp;&nbsp;</td>
    <td align="right"><font size="2">MerchantAccount:</font></td>
    <td><input type="text" name="MerchantAccountNumber" value="<%=MerchantAccountNumber%>" size="20" readonly style="background-color: #b6c8da" /></td>
  </tr>
  <tr>
    <td align="right"><font size="2">TixFulfillment:</font></td>
    <td><input type="text" name="TixFulfillment" value="<%=TixFulfillment%>" size="20" readonly style="background-color: #b6c8da" />&nbsp;&nbsp;&nbsp;</td>
    <td align="right"><font size="2">AcceptReservations:</font></td>
    <td><input type="text" name="AcceptReservations" value="<%=AcceptReservations%>" size="20" readonly style="background-color: #b6c8da" />&nbsp;&nbsp;</td>
  </tr>
  <tr>
    <td align="right"><font size="2">OrderExpirationDelay:</font></td>
    <td><input type="text" name="OrderExpirationDelay" value="<%=OrderExpirationDelay%>" size="20" readonly style="background-color: #b6c8da" />&nbsp;&nbsp;&nbsp;</td>
    <td align="right"><font size="2">TimeZoneOffset:</font></td>
    <td><input type="text" name="TimeZoneOffset" value="<%=TimeZoneOffset%>" size="20" readonly style="background-color: #b6c8da" />&nbsp;&nbsp;&nbsp;</td>
  </tr>
 <tr>
  <td align="right"><font size="2">TixCallCenter:</font></td>
  <td><input type="text" name="TixCallCenter" value="<%=TixCallCenter%>" size="20" readonly style="background-color: #b6c8da" />&nbsp;&nbsp;&nbsp;</td>
  <td align="right"><font size="2">Comments:</font></td>
  <td><input type="text" name="Comments" value="<%=Comments%>" size="20" readonly style="background-color: #b6c8da" />&nbsp;&nbsp;&nbsp;</td>
</tr>
</TABLE>
</fieldset>
<BR>
<BR>
<fieldset style="width:650px">
<legend style="color:#000;font-size:13px;font-weight:bold">Sub-Organization Parameters</legend>
<TABLE CELLSPACING="0">
  <tr>
    <td align="right"><font size="2">Sub-Organization Name:</font></td>
    <td><input type="text" name="SubOrganization" value="<%=SubOrganization%>" size="70" />&nbsp;&nbsp;</td>    
  </tr>
  <tr>
    <td align="right"><font size="2">User First/Last Name:</font></td>
    <td><input type="text" name="FirstName" value="<%=FirstName%>" size="20">&nbsp;<input type="text" name="LastName" value="<%=LastName%>" size="20"></td>
  </tr>
  <tr>
    <td align="right"><font size="2">User E-mail Address:</font></td>
    <td><input type="text" name="EmailAddress" value="<%=EmailAddress%>" size="45">&nbsp;&nbsp;</td>
  </tr>
</TABLE>
</fieldset>
<BR>
<INPUT TYPE="hidden" NAME="FormName" VALUE="Update">
<INPUT TYPE="hidden" NAME="CCProcessor" VALUE="<%=CCProcessor%>">
<INPUT TYPE="submit" VALUE="Submit"></FORM>

</CENTER>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%

End Sub 'Add_Organization

'==============================

Sub Update

%>

<HTML>
<HEAD>
<TITLE>Tix - SubOrganization Maintenance</TITLE>
</HEAD>
<BODY BGCOLOR="#FFFFFF">

<!--#INCLUDE VIRTUAL="TopNavInclude.asp"-->

<fieldset style="width:650px">
<legend style="color:#000;font-size:13px;font-weight:bold">Organization</legend>
<TABLE>
  <tr>
    <td align="right"><font size="2">Sub-Organization:</font></td><td><font size="2"><%=SubOrganization%></td>
    <td align="right"><font size="2">Sub-Organization Number:</font></td><td><font size="2"><%=SubOrganizationNumber%></td>
  </tr>
  <tr>
    <td align="right"><font size="2">Credit Card Processor:</font></td><td><font size="2"><%=CCProcessor%></td>
    <td align="right"><font size="2">Merchant Account:</font></td><td><font size="2"><%=MerchantAccountNumber%></td>
  </tr>
  <tr>
    <td align="right"><font size="2">Address Print Format:</font></td><td><font size="2"><%=AddressPrintFormat%></td>
    <td align="right"><font size="2">Ticket Print Format:</font></td><td><font size="2"><%=TicketPrintFormat%></td>
  </tr>
  <tr>
    <td align="right"><font size="2">Footer Print Format:</font></td><td><font size="2"><%=FooterPrintFormat%></td>
    <td align="right"><font size="2">Tix Fulfillment:</font></td><td><font size="2"><%=TixFulfillment%></td>
  </tr>
 <tr>
  <td align="right"><font size="2">Status Code:</font></td><td><font size="2"><%=StatusCode%></td>
  <td align="right">&nbsp;&nbsp;&nbsp;</td><td>&nbsp;&nbsp;&nbsp;</td>
</tr>
</TABLE>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%

End Sub 'Add_Organization

'==============================

%> 
