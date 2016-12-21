<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%
Page = "Survey"

'Survey to have ticket buyer acknowledge that they've read the terms and conditions on the client's website
'Survey to ask ticket buyer if they wish a gift card

SurveyNumber = 354
SurveyName = "SurveyAcceptTerms.asp"
NumQuestions = 2

Dim Question(3)

Question(1) = "Terms and Conditions"
Question(2) = "Would you like a personalized gift letter?"

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

<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey" onSubmit='return validateForm()'>
<INPUT TYPE="hidden" NAME="FormName" VALUE="SurveyForm">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">

<CENTER>

<TABLE WIDTH="70%">
  <TR ALIGN="center">
		<TD>
			<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3>Gift Certificate</H3></FONT>
			<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><%= Question(2) %><BR></FONT>
			<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><INPUT TYPE="radio" NAME="Answer2" VALUE="Yes">&nbsp;Yes&nbsp;&nbsp;<INPUT TYPE="radio" NAME="Answer2" VALUE="No">&nbsp;No</FONT>
		</TD>
  </TR>
</TABLE>
<BR>
<BR>
<TABLE WIDTH="70%">
  <TR ALIGN="center">
		<TD>
			<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3>Terms and Conditions</H3></FONT>
			<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><INPUT TYPE="checkbox" NAME="Answer1" VALUE="Accept">&nbsp;I accept ABRS <a href="http://www.allenbergracingschools.com/terms.aspx" target=_blank>Terms and Conditions</a> as outlined on website.</FONT>
		</TD>
  </TR>
</TABLE>

<BR>
<BR>

<INPUT TYPE="submit" VALUE="Continue"></FORM>

</CENTER>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%
End Sub ' SurveyForm

Sub UpdateSurveyAnswer

If Session("OrderNumber") <> "" Then

	For AnswerNumber = 1 To NumQuestions
		If Clean(Request("Answer" & AnswerNumber)) <> "" Then
				For Each Item IN Request("Answer" & AnswerNumber)
					If Item <> "" Then
						SQLUpdateSurvey = "INSERT SurveyAnswers(SurveyNumber, OrderNumber, CustomerNumber, SurveyDate, AnswerNumber, Answer, Question) VALUES(" & Clean(Request("SurveyNumber")) & ", " & Session("OrderNumber") & ", " & Session("CustomerNumber") & ", '" & Now() & "', " & AnswerNumber & ", '" & Clean(Item) & "', '" & Question(AnswerNumber) & "')"
						Set rsUpdateSurvey = OBJdbConnection.Execute(SQLUpdateSurvey)
					End If
				Next
		End If
	Next
		
	If Session("UserNumber") = "" Then
		'REE 4/19/3 - Modified to use Session Variable for SurveyComplete
		Session("SurveyComplete") = Session("OrderNumber")
		Response.Redirect("/Ship.asp")
	Else
		'REE 4/19/3 - Modified to use Session Variable for SurveyComplete
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

