<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%


'This survey prompts for a membership number when member ticket types are purchased. 
'When a membership number is keyed in, it's "validated" by system. Only "valid" membership numbers can continue.
'This survey limits the number of member tickets to be purchased.

Page = "Survey"
SurveyNumber = 616
SurveyFileName = "MemberSurvey.asp"
MemberName = "Member/Associate"
MemberList = "3442" 'List of Member Seat Type Codes
SeatTypeCode = (Clean(Request("SeatTypeCode")))


'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	OBJdbConnection.Close
	Set OBJdbConnection = nothing
	Response.Redirect("/Default.asp")
End If

'Count number of member tickets
SQLMemberCount = "SELECT COUNT(ItemNumber) AS TicketCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber")& " AND OrderLine.SeatTypeCode IN (" & MemberList & ")"
Set rsMemberCount = OBJdbConnection.Execute(SQLMemberCount)
MemberCount = rsMemberCount("TicketCount")
rsMemberCount.Close
Set rsMemberCount = nothing



If MemberCount = 0 Then 
		Call Continue
End If

If MemberCount > 2 Then
		
		Call WarningPage(MemberCount, MemberName)
		
Else

		Select Case Request("FormName")
			Case "MemberNumberForm"
				Call ValidateMember(Clean(Request("MemberNumber")))
			Case "Continue"
				Call MemberNumberForm(Message)
			Case Else
				Call MemberNumberForm(Message)
		End Select
	
	
End If


'==============================
Sub MemberNumberForm(Message)

'Check for existing survey entry for this order
SQLSurveyAnswers = "SELECT Answer FROM SurveyAnswers(NOLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND SurveyNumber = 616 AND Question = 'MembershipNumber'"
Set rsSurveyAnswers = OBJdbConnection.Execute(SQLSurveyAnswers)

If rsSurveyAnswers.EOF Then
	SurveyComplete = "N"
Else
	SurveyComplete = "Y"
End If

rsSurveyAnswers.Close
Set SurveyAnswers = nothing

If SurveyComplete = "N" Then 

	Response.Write "<HTML>" & vbCrLf
	Response.Write "<HEAD>" & vbCrLf
	Response.Write "<TITLE>" & Title & "</TITLE>" & vbCrLf
	Response.Write "</HEAD>" & vbCrLf

	If Message = "" Then
		Response.Write "<BODY BGCOLOR=" & BGColor & " LINK="& LinkColor & " ALINK=" & ALinkColor & " VLINK=" & VLinkColor & " leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0 " & BodyParameters & ">" & vbCrLf
	Else
		Response.Write "<BODY BGCOLOR=" & BGColor & " LINK="& LinkColor & " ALINK=" & ALinkColor & " VLINK=" & VLinkColor & " onLoad=""alert('" & Message & "');"" leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0 " & BodyParameters & ">" & vbCrLf
	End If
						
	%>

	<!--#INCLUDE virtual="TopNavInclude.asp"-->

	<BR>
	<BR>

	<%

Response.Write "<FORM ACTION=""" & SurveyFileName & """ METHOD=""post"" id=form1 name=form1><INPUT TYPE=""hidden"" NAME=""FormName"" VALUE=""MemberNumberForm"">" & vbCrLf
Response.Write "<FONT FACE=" & FontFace & " COLOR=" &  HeadingFontColor & " SIZE=4><B>Membership Validation</B></FONT><BR><BR>" & vbCrLf
Response.Write "<TABLE>" & vbCrLf
Response.Write "<TR><TD Align=center><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=""2"">In order to qualify for reduced member ticket pricing,<BR>please enter your membership number below.<BR><BR></FONT><INPUT TYPE=""text"" NAME=""MemberNumber"" VALUE=""" & Clean(Request("MemberNumber")) & """ SIZE=""40"" onFocus=""Member[1].checked = true;""></FONT></TD></TR>" & vbCrLf

If Message <> "" Then 'Display Error Message
	Response.Write "<TR BGCOLOR=""" & FontColor & """><TD ALIGN=""center"" COLSPAN=""2""><FONT FACE=""" & FontFace & """ COLOR=""" &  BGColor & """ SIZE=""2""><B>" & Message & "</FONT></TD></TR>" & vbCrLf
End If

Response.Write "</TABLE><BR>" & vbCrLf
	
If Session("UserNumber") = "" Then
Response.Write "<INPUT TYPE=""button"" VALUE=""<<&nbsp;&nbsp;Back"" onclick=""location.href='/ShoppingCart.asp';"" ID=1 NAME=1 STYLE=""width: 100px"">" & vbCrLf
Else
Response.Write "<INPUT TYPE=""button"" VALUE=""<<&nbsp;&nbsp;Back"" onclick=""location.href='/Management/ShoppingCart.asp';"" id=1 name=1  STYLE=""width: 100px"">" & vbCrLf
End If


Response.Write "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<INPUT TYPE=submit VALUE=""Continue&nbsp;&nbsp;>>"" id=submit1 name=submit1 STYLE=""width: 100px""></FORM><BR><BR>" & vbCrLf	



%>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%

Else

	Call Continue
	
End If

End Sub 'MemberNumberForm
'==============================

Sub ValidateMember(MemberNumber)


If Not IsNumeric(MemberNumber) Then
		Call MemberNumberForm("Invalid Member Number")
		
ElseIf Len(MemberNumber) <> 6 Then
		Call MemberNumberForm("Invalid Member Number")

Else
		Call RecordNumber(MemberNumber)	

End If


End Sub 'ValidateMember	
'==============================

Sub WarningPage(MemberCount,MemberName)


Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & Title & "</TITLE>" & vbCrLf
Response.Write "</HEAD>" & vbCrLf

Response.Write "<BODY BGCOLOR=" & BGColor & " LINK="& LinkColor & " ALINK=" & ALinkColor & " VLINK=" & VLinkColor & " leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0 " & BodyParameters & ">" & vbCrLf
					
%>

<!--#INCLUDE virtual="/TopNavInclude.asp"-->

<%

Response.Write "<BR><BR><FONT FACE=" & FontFace & " COLOR=" &  HeadingFontColor & " SIZE=4><B>NOTICE</FONT>" & vbCrLf
Response.Write "<CENTER><TABLE><TR><TD Align=center><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=""2"">No more than 2 " & MemberName & " tickets per member may be purchased.<BR><BR></FONT>" & vbCrLf
Response.Write "<FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=""2"">You currently have " & MemberCount & " " & MemberName & " tickets in your order.<BR><BR></FONT>" & vbCrLf
Response.Write "<FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=""2"">Please click on ""Back to Shopping"" and reduce the number of tickets in your order.</FONT>" & vbCrLf

If Session("UserNumber") = "" Then
	Response.Write "<FORM ACTION=""/ShoppingCart.asp"" METHOD=""POST"" id=form1 name=form1>" & vbCrLf
Else
	Response.Write "<FORM ACTION=""/Management/ShoppingCart.asp"" METHOD=""POST"" id=form1 name=form1>" & vbCrLf
End If

Response.Write "<INPUT TYPE=""submit"" VALUE=""Back To Shopping"" id=1 name=1></FORM></CENTER></TD></TR></TABLE></CENTER><BR><BR>" & vbCrLf



%>

<!--#INCLUDE virtual="/FooterInclude.asp"-->

<%	

Response.Write "</BODY>" & vbCrLf
Response.Write "</HTML>" & vbCrLf

		
End Sub 'Warning Page
'==============================

Sub RecordNumber(MemberNumber)	
	
		'Record MemberNumber in SurveyAnswers
		SQLInsertSurvey = "INSERT SurveyAnswers(SurveyNumber, OrderNumber, CustomerNumber, SurveyDate, AnswerNumber, Answer, Question) VALUES(" & SurveyNumber & ", " & Session("OrderNumber") & ", " & Session("CustomerNumber") & ", '" & Now() & "', 1, '" & MemberNumber & "', 'MembershipNumber')"
		Set rsInsertSurvey = OBJdbConnection.Execute(SQLInsertSurvey)
	
		Call Continue


End Sub 'RecordNumber
'==============================

Sub Continue



If Session("UserNumber") = "" Then
	Session("SurveyComplete") = Session("OrderNumber")
	Response.Redirect("/Ship.asp")
Else
	Session("SurveyComplete") = Session("OrderNumber")
	Response.Redirect("/Management/AdvanceShip.asp")
End If



End Sub 'Continue
'==============================

%>
