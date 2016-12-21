<!--#include virtual="GlobalInclude.asp"-->
<!--#include virtual="dbOpenInclude.asp"-->
<%
Page = "ManagementReport"

'Initalize Report Variables
ParentOrgNumber = 2463


If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then Response.Redirect("Default.asp")

			SQLUserOrg = "SELECT OrganizationNumber FROM Users (NOLOCK) WHERE UserNumber = " & Session("UserNumber")
			Set rsUserOrg = OBJdbConnection.Execute(SQLUserOrg)		
			OrganizationNumber = rsUserOrg("OrganizationNumber")
			rsUserOrg.Close
			Set rsUserOrg = nothing	
				

			If OrganizationNumber <> "1" And  OrganizationNumber <> ParentOrgNumber Then 						
					Response.Redirect("Default.asp")						
			Else									
					Select Case Request("FormName")
						Case "Send_Email"
								Call Send_Email
						Case "New_Organization"
								Call New_Organization
						Case "Create_Organization"
								Call Create_Organization (FirstName, LastName)
						Case Else 
								Call OrganizationList
					End Select
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
<FONT FACE="verdana, arial, helvetica" COLOR="#008400" SIZE="2"><H3>Cultural Alliance of Greater Washington</H3></FONT>
<FONT FACE="verdana, arial, helvetica" COLOR="#008400" SIZE="2"><H3>Sub-Organization Report</H3></FONT>
<FORM ACTION="/Management/PasswordReset.asp" METHOD="post" Name="EMailForm">
<% 

Response.Write "<BR>" & vbCrLf
Response.Write "<TABLE BORDER=""0"" CELLPADDING=""3""><TR BGCOLOR=""#008400""><TD ALIGN=""center""><FONT FACE='verdana,arial,helvetica' COLOR=""#FFFFFF"" SIZE=2><B>&nbsp;</TD><TD ALIGN=""center""><FONT FACE='verdana,arial,helvetica' COLOR=""#FFFFFF"" SIZE=2><B>Organization</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=""#FFFFFF"" SIZE=2><B>User&nbsp;Name</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=""#FFFFFF"" SIZE=2><B>EMail&nbsp;Address</FONT></TD></TR>" & vbCrLf

SQLReport = "SELECT Organization.OrganizationNumber, (Select Left(Organization, Len(Organization)-8)) as Organization, Users.FirstName, Users.LastName, Users.UserID, Users.UserNumber, Users.EMailAddress FROM Users INNER JOIN Organization ON Organization.OrganizationNumber = Users.OrganizationNumber WHERE (Users.OrganizationNumber IN (SELECT SubOrganizationNumber FROM SubOrganization WHERE (OrganizationNumber = " & ParentOrgNumber & "))) ORDER BY Organization"
Set rsReport = OBJdbConnection.Execute(SQLReport)

Do Until rsReport.EOF
			
		If rsReport("EMailAddress") <> "" Or  rsReport("EMailAddress") <> "NULL" Then		
		    Response.Write "<TR BGCOLOR=""#DDDDDD"">" & vbCrLf
		    Response.Write "<TD><INPUT TYPE=""radio"" NAME=""EmailAddress"" VALUE=" & rsReport("EmailAddress") & "></TD>" & vbCrLf
		    Response.Write "<TD><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsReport("Organization") & "</FONT></TD>" & vbCrLf
		    Response.Write "<TD><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsReport("FirstName") & "&nbsp" & rsReport("LastName") & "</FONT></TD>" & vbCrLf	
		    Response.Write "<TD ALIGN=""middle"">&nbsp;<IMG SRC=""/images/greensquar.gif""></b></TD>" & vbCrLf
	  Else
	  	    Response.Write "<TR BGCOLOR=""#DDDDDD"">" & vbCrLf
		    Response.Write "<TD>&nbsp;</TD>" & vbCrLf
		    Response.Write "<TD><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsReport("Organization") & "</FONT></TD>" & vbCrLf
		    Response.Write "<TD><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsReport("FirstName") & "&nbsp" & rsReport("LastName") & "</FONT></TD>" & vbCrLf	
		    Response.Write "<TD ALIGN=""middle"">&nbsp;</TD>" & vbCrLf
	  End If

rsReport.MoveNext		

Loop

Response.Write "</TR>" & vbCrLf
Response.Write "<TR><TD align=""center"" colspan=""4""><BR><BR>" & vbCrLf

%>
<INPUT TYPE="hidden" NAME="FormName" VALUE="EmailRequest"><INPUT TYPE="submit" STYLE="width: 15em" VALUE="Send Login Email" id=submit1 name=submit1></FORM>
<% 
	
If OrganizationNumber = 1 Then 
%>
<FORM ACTION="SubOrgReport.asp" METHOD="post"><INPUT TYPE="hidden" NAME="FormName" VALUE="New_Organization"><INPUT TYPE="hidden" NAME="OrganizationNumber" VALUE="NEW"><INPUT TYPE="submit" STYLE="width: 15em" VALUE="Create New Sub-Organization" ID=submit2 NAME=submit2></FORM>
<% 
End If

Response.Write "</TD></TR></TABLE>" & vbCrLf
Response.Write "<BR><BR>" & vbCrLf

%>

</CENTER>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<% 

End Sub 'OrganizationList

'==============================

Sub New_Organization

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
    <td align="right"><font size="2">Sub-Organization Name:</td>
    <td><input type="text" name="SubOrganization" value="<%=SubOrganization%>" size="45" /><font size="2">&nbsp;&nbsp;(AusTIX)</font></td>    
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
<INPUT TYPE="hidden" NAME="FormName" VALUE="Create_Organization">
<INPUT TYPE="hidden" name="FirstName" value="<%=FirstName%>">
<INPUT TYPE="hidden" name="LastName" value="<%=LastName%>">
<INPUT TYPE="submit" VALUE="Submit"></FORM>

</CENTER>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%

End Sub 'Add_Organization

'==============================

Sub Create_Organization (FirstName, LastName)

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
</fieldset>

<fieldset style="width:650px">
<legend style="color:#000;font-size:13px;font-weight:bold">User</legend>
<TABLE>
  <tr>
    <td align="right"><font size="2">Name:</font></td><td><font size="2">"<%=FirstName%>" "<%=LastName%>"</td>
  </tr>
  <tr>
    <td align="right"><font size="2">User ID:</font></td><td><font size="2"><%=UserID%></td>
  </tr>
  <tr>
    <td align="right"><font size="2">User Password:</font></td><td><font size="2"><%=Password%></td>
  </tr>
</TABLE>
</fieldset>
<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%

End Sub 'Create_Organization

'==============================

%> 
