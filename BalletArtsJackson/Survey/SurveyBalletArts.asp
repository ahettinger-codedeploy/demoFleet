<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%
Page = "Survey"

SurveyNumber = 360
SurveyName = "SurveyBalletArts.asp"
NumQuestions = 2

Dim Question(3)

Question(1) = "How did you find out about this event?"
Question(2) = "Please select one of the following:"

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
Response.Write "</HEAD>" & vbCrLf
Response.Write strBody & vbCrLf
%>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<BR>
<BR>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3>Brief Audience Survey</H3></FONT>
<BR>
<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey">
<INPUT TYPE="hidden" NAME="FormName" VALUE="SurveyForm">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">
<TABLE WIDTH="70%">
  <TR>
		<TD>
			<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><B><%= Question(1) %></B></FONT>
		</TD>
  </TR>
  <TR>
		<TD>
			<BR>
			<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">
			<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Friend">&nbsp;Friend<BR>
			<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Relative">&nbsp;Relative<BR>
			<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Internet website">&nbsp;Internet website<BR>
			<INPUT TYPE="checkbox" NAME="Answer1" VALUE="E-flyer">&nbsp;E-flyer<BR>
			<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Billboard">&nbsp;Billboard<BR>
			<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Bus sign">&nbsp;Bus sign<BR>
			<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Poster">&nbsp;Poster<BR>
			<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Newspaper/Print media">&nbsp;Newspaper / Print media<BR>
			<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Radio">&nbsp;Radio<BR>
			<INPUT TYPE="checkbox" NAME="Answer1" VALUE="WBBJ">&nbsp;WBBJ<BR>
			<INPUT TYPE="checkbox" NAME="Answer1" VALUE="JEA Cable">&nbsp;JEA Cable<BR>
			<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Other">&nbsp;Other:&nbsp;&nbsp;<input TYPE="text" NAME="Answer1" size=30><BR>
			</FONT><BR><BR><BR>
    </TD>
  </TR>
  <TR>
		<TD>
			<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><B><%= Question(2) %></B></FONT>
		</TD>
  </TR>
  <TR>
		<TD>
			<BR>
			<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">
			<INPUT TYPE="radio" NAME="Answer2" VALUE="First-time Patron">&nbsp;First-time Patron<BR>
			<INPUT TYPE="radio" NAME="Answer2" VALUE="Returning Patron">&nbsp;Returning Patron<BR>
			<INPUT TYPE="radio" NAME="Answer2" VALUE="Ballet Arts Member">&nbsp;Ballet Arts Member<BR>
			<INPUT TYPE="radio" NAME="Answer2" VALUE="Other">&nbsp;Other:&nbsp;&nbsp;<input TYPE="text" NAME="Answer2" size=30><BR>
			</FONT><BR>
    </TD>
  </TR>
</TABLE>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><BR><B>Thank You for your time!</B></FONT><BR><BR><BR>

<INPUT TYPE="submit" VALUE="Continue"></FORM>


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


