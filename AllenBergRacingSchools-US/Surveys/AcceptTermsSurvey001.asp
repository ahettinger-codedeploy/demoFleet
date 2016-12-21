<!--#INCLUDE virtual=/PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=/GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=/DBOpenInclude.asp -->
<%
Page = "Survey"

'Survey to have ticket buyer acknowledge that they've read the terms and conditions on the client's website

SurveyNumber = 354
SurveyName = "SurveyAcceptTerms.asp"
NumQuestions = 1

Dim Question(2)

Question(1) = "Terms Accepted"

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

<!--#INCLUDE virtual="/TopNavInclude.asp"-->

<BR>
<BR>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3>Terms and Conditions</H3></FONT>
<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">Please be sure you understand the terms and conditions before making your ticket purchase.</FONT><BR>
<BR>
<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey" onSubmit='return validateForm()'>
<INPUT TYPE="hidden" NAME="FormName" VALUE="SurveyForm">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">

<TABLE WIDTH="70%">
  <TR ALIGN="center">
		<TD>
			<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">I accept ABRS Terms and Conditions as outined on website.</FONT><BR>
			<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><%= Question(2) %><INPUT TYPE="radio" NAME="Answer1" VALUE="Yes">&nbsp;<INPUT TYPE="radio" NAME="Answer1" VALUE="No">&nbsp;</FONT><BR><BR><BR>
		</TD>
  </TR>
</TABLE>

<INPUT TYPE="submit" VALUE="Continue"></FORM>
</CENTER>

<!--#INCLUDE virtual="/FooterInclude.asp"-->

</BODY>
</HTML>

<%
End Sub ' SurveyForm

Sub UpdateSurveyAnswer

If Session("OrderNumber") <> "" Then

	If Clean(Request("Answer1")) = "" Then
		
		Call SurveyForm
	Else
	
		'REE 2/20/7 - Update Customer.Address1 field with Company Name (Answer1)
		SQLInsertCompanyName = "UPDATE Customer WITH (ROWLOCK) SET Address1 = '" & Clean(Request("Answer1")) & "' WHERE CustomerNumber = " & Session("CustomerNumber")
		Set rsInsertCompanyName = OBJdbConnection.Execute(SQLInsertCompanyName)

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
			Response.Redirect("Ship.asp")
		Else
			'REE 4/19/3 - Modified to use Session Variable for SurveyComplete
			Session("SurveyComplete") = Session("OrderNumber")
			Response.Redirect("/Management/AdvanceShip.asp")
		End If
		
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


