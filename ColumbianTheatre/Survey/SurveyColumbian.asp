<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%
Page = "Survey"

SurveyNumber = 149
SurveyFileName = "SurveyColumbian.asp"
NumQuestions = 1

Dim Question(2)

Question(1) = "How did you hear about the show?"


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
		if(formObj.Answer1.selectedIndex == 0) {
			alert("Please select an answer.");
			formObj.Answer1.focus();
			return false;
			}
        if (formObj.Answer1.selectedIndex == 8) {
			if (formObj.Answer2.value == "") {
				alert("Please describe how you found out about this year's event");
				formObj.Answer2.focus();
				return false;
				}
            }
	}       
// end hiding -->
</SCRIPT>
</HEAD>

<%= strBody %>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<BR>
<BR>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3>Help Us Serve You Better...</H3></FONT>
<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><FONT face="Geneva, Arial, Helvetica, san-serif">Please take a minute to answer the following question:</FONT><BR>
<BR>
<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey" onSubmit='return validateForm()'>
<INPUT TYPE="hidden" NAME="FormName" VALUE="SurveyForm">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">
<TABLE ALIGN=CENTER WIDTH="90%">
  <TR>
	<TD ALIGN=CENTER>
		<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><B><%= Question(1) %></B></FONT>
	</TD>
	</TR>
	<TR>
	<TD ALIGN=CENTER>
		<SELECT NAME="Answer1">
		<OPTION VALUE="" SELECTED>Select One
		<OPTION>I received an e-mail
		<OPTION>Postcard in the mail
		<OPTION>Manhattan Mercury
		<OPTION>Topeka Capital Journal
		<OPTION>Wamego Newspapers
		<OPTION>Other Newspapers
		<OPTION>Poster display
		<OPTION>Radio
		<OPTION>Website
		<OPTION>Word of Mouth
		<OPTION>Other
		</SELECT>
	</TD>
  </TR>
</TABLE>

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
			SQLUpdateSurvey = "INSERT SurveyAnswers(SurveyNumber, OrderNumber, CustomerNumber, SurveyDate, AnswerNumber, Answer, Question) VALUES(" & Clean(Request("SurveyNumber")) & ", " & Session("OrderNumber") & ", " & Session("CustomerNumber") & ", '" & Now() & "', " & AnswerNumber & ", '" & Clean(Request("Answer" & AnswerNumber)) & "', '" & Clean(Question(AnswerNumber)) & "')"
			Set rsUpdateSurvey = OBJdbConnection.Execute(SQLUpdateSurvey)
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


