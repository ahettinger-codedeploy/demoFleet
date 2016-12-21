<%
'CHANGE LOG

%>

<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include virtual="/include/managementinclude.asp"-->

<%

Page = "ManagementEventAdd"

Session("Timeout") = 120
Server.ScriptTimeout = 60 * 20 '20 Minutes

'========== INITIAL VALIDATION ==========

'Check for OrganizationNumber
If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then 
	OBJdbConnection.Close
	Set OBJdbConnection = nothing
	Response.Redirect("/Management/Default.asp")
End If

'Check for User
If Session("UserNumber") = "" Then
	OBJdbConnection.Close
	Set OBJdbConnection = nothing
	Response.Redirect("Default.asp")
End If

'Make sure user is authorized
If SecurityCheck("EventManagement") <> True Then
	OBJdbConnection.Close
	Set OBJdbConnection = nothing
	Response.Redirect("Default.asp")
End If

SQLUserOrg = "SELECT OrganizationNumber FROM Users (NOLOCK) WHERE UserNumber = " & Session("UserNumber")
Set rsUserOrg = OBJdbConnection.Execute(SQLUserOrg)
UserOrgNum = rsUserOrg("OrganizationNumber")
rsUserOrg.Close
Set rsUserOrg = nothing

'========== PROGRAM FLOW ==========

Select Case Request("NextFormName")
	Case "AcknowledgePastEvent"
		Call AcknowledgePastEvent
	Case "ActVenueDates"
		Call ActVenueDates(Clean(Request("Message")))
	Case "Pricing"
		Call Pricing(Message)
'	Case "MapSelection"
'		Call Pricing(Message)
	Case "ReviewEvent"
		If Request("submit") = "Calculate Fees" Then
			Call Pricing(Message)
		Else
			Call ReviewEvent(Message)
		End If
	Case "EventAdd"
		If Request("submit") = "Go Back" Then
			Call ActVenueDates(Message)
		Else
			Call EventAdd
		End If
	Case "ActivateEvent"
		Call ActivateEvent
	Case "ActivateMultiEvents"
		Call ActivateMultiEvents
	Case "DisplayEvent"
		Call DisplayEvent(Clean(Request("EventCode")), Clean(Request("Message")))		
	Case "DeleteEvent"
		Call DeleteEvent
	Case Else
'		Call ActVenueDates(Message)
		Call EventList(Clean(Request("Message")))
End Select

'========== DISPLAY EVENT LISTING ===========

Sub EventList(Message)

%>
<HTML>

<HEAD>

<TITLE>TIX</TITLE>

<style>
.page-content
{
min-height: 600px;
background-color: #FBFBFB;
}
</style>

</HEAD>

<%
If Message = "" Then
	Response.Write "<BODY BGCOLOR=#FFFFFF>" & vbCrLf
Else
	Response.Write "<BODY BGCOLOR=#FFFFFF onLoad=" & CHR(34) & "alert('" & Message & "')" & CHR(34) & ">" & vbCrLf
End If
Message = ""
%>
<!--#include virtual="TopNavInclude.asp" -->
<CENTER>

</CENTER>
<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>

</HTML>

<%

End Sub 'EventList

%>