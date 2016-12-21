<!--#INCLUDE virtual=/PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=/GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=/DBOpenInclude.asp -->
<%
Page = "Survey"

SurveyNumber = 485
SurveyName = "/EsthersFollies.asp"
NumQuestions = 1

Dim Question(2)

Question(1) = "I hereby acknowledge that I understand my party must arrive at the theater and check in, no later than 30 minutes prior to the performance. I also acknowledge that Esther's Follies tickets and e-tickets, purchased through Austix, which are not redeemed 20 minutes prior to the performance, may be released to non-ticket holders.  I also acknowledge that if my tickets are released due to late arrival, there will be no refunds or exchanges."

'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If

If Clean(Request("FormName")) <> "SurveyForm" Then
	Call SurveyForm
Else
	Call UpdateSurveyAnswer
End If

OBJdbConnection.Close
Set OBJdbConnection = nothing

Sub SurveyForm

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & Title & "</TITLE>" & vbCrLf
%>

 <SCRIPT LANGUAGE="JavaScript">    

 <!-- Hide code from non-js browsers

function validateForm() {
     formObj = document.Survey;
 	var yes = 0;
 	var no = 0;
		
    if (eval("formObj.Answer1.checked") != true){
 		alert("You must check the box acknowledging the terms before proceeding.");
 		return false;
 		}
 	}

 // end hiding -->
 </SCRIPT>

<%
Response.Write "</HEAD>" & vbCrLf
Response.Write strBody & vbCrLf
%>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<BR>
<BR>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3>Esther's Follies</H3></FONT>
<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">Please take a minute to read the following information.</FONT><BR>
<BR>
<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey" onSubmit='return validateForm()'>
<INPUT TYPE="hidden" NAME="FormName" VALUE="SurveyForm">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">
<TABLE WIDTH="70%">
  <TR ALIGN="center">
		<TD>
		<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><%= Question(1) %><BR><BR><INPUT TYPE="checkbox" NAME="Answer1" VALUE="Acknowledge"></FONT>&nbsp;&nbsp;I have read the the terms and conditions listed above.<BR><BR><BR>
		</TD>
  </TR>
</TABLE>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="3"><B>Thank You!</B></FONT><BR><BR><BR>

<INPUT TYPE="submit" VALUE="Continue"></FORM>
</CENTER>

<!--#INCLUDE virtual="/FooterInclude.asp"-->

</BODY>
</HTML>

<%
End Sub ' SurveyForm

Sub UpdateSurveyAnswer

If Session("OrderNumber") <> "" Then

	For AnswerNumber = 1 To 1
		If Clean(Request("Answer" & AnswerNumber)) <> "" Then
			SQLUpdateSurvey = "INSERT SurveyAnswers(SurveyNumber, OrderNumber, CustomerNumber, SurveyDate, AnswerNumber, Answer, Question) VALUES(" & Clean(Request("SurveyNumber")) & ", " & Session("OrderNumber") & ", " & Session("CustomerNumber") & ", '" & Now() & "', " & AnswerNumber & ", '" & Clean(Request("Answer" & AnswerNumber)) & "', '" & Question(AnswerNumber) & "')"
			Set rsUpdateSurvey = OBJdbConnection.Execute(SQLUpdateSurvey)
		End If
	Next
		
	If Session("UserNumber") = "" Then
		Session("SurveyComplete") = Session("OrderNumber")
		Response.Redirect("/Ship.asp")
	Else
		Session("SurveyComplete") = Session("OrderNumber")
		Response.Redirect("/Management/AdvanceShip.asp")
	End If

Else 'No Session Order Number
	
	If Session("UserNumber") = "" Then
		Session.Contents.Remove("OrderNumber") 
		OBJdbConnection.Close
		Set OBJdbConnection = nothing
		Response.Redirect("/Default.asp")
	Else
		Session.Contents.Remove("OrderNumber") 
		OBJdbConnection.Close
		Set OBJdbConnection = nothing
		Response.Redirect("http://" & Request.ServerVariables("SERVER_NAME") & "/Management/ClearOrderNumber.asp")
	End If

End If


End Sub 'Update SurveyAnswer

%>


