<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%
Page = "Survey"

SurveyNumber = 372
SurveyFileName = "Survey.asp"
NumQuestions = 2

Dim Question(3)

Question(1) = "How did you learn about our show?"
Question(2) = "Which chorus member told you about the show?"

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
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3>Survey</H3></FONT><BR>

<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey">
<INPUT TYPE="hidden" NAME="FormName" VALUE="SurveyForm">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">
<TABLE CELLPADDING=10 CELLSPACING=5 WIDTH="100%" border=0>
	<TR>
  <TD ALIGN=left NOWRAP>
			<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><B><%= Question(1) %></B></FONT>
	</TD>
	<TR>
		<TD>
			<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">
			<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Flyer">&nbsp;Saw a flyer about the show<BR>
			<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Radio/TV">&nbsp;Heard about it on radio or TV<BR>
			<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Ad/Story/Newspaper">&nbsp;Saw an ad or story in the newspaper<BR>
			<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Chorus Member">&nbsp;Heard about it from a chorus member (Select a member from below)<BR>
			<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Other">&nbsp;Other&nbsp;<INPUT TYPE="text" NAME="Answer1" SIZE=25><BR>
			</FONT><BR>
		</TD>
		</TR>
	 <TR>
		<TD ALIGN=left NOWRAP>
			<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><B><%= Question(2) %></B></FONT>
		</TD>
		</TR>
		<TR>
		<TD>
		    <select name="Answer2">
		        <option>- Select -</option>
		        <option>Rodney Atherton</option>
		        <option>Bobby Berrien</option>
		        <option>Dave Berrien</option>
		        <option>Tommy Berrien</option>
		        <option>Bruce Bickley</option>
		        <option>Thomas Brandt</option>
		        <option>Erich Brough</option>
		        <option>Robbie Brunger</option>
		        <option>Donald Carraway</option>
		        <option>Daniel Colletti</option>
		        <option>Joseph DeChello</option>
		        <option>Rik Dezego</option>
		        <option>Dennis Fagen</option>
		        <option>Nicholas Folkes</option>
		        <option>Ken Ford</option>
		        <option>Eddie Gray</option>
		        <option>James Hinson</option>
		        <option>Stephen Jacobsen</option>
		        <option>Duke Jean</option>
		        <option>Dennis Kehoe</option>
		        <option>Tom Kemble</option>
		        <option>Glenn Lillibridge</option>
		        <option>Paul Maurer</option>
		        <option>Steve Pennington</option>
		        <option>Billy Poston</option>
		        <option>Arlen Schwerin</option>
		        <option>Governor Staten</option>
		        <option>Sean Stork</option>
		        <option>Pete Tanzy</option>
		        <option>Jeffrey Wienand</option>
		        <option>Fred Williams</option>
		        <option>Woody Wise</option>
		        <option>Gene Kelley</option>
		        <option>Brian Bailey</option>
		        <option>Other, or don't know</option>
		    </select>
			<BR>
		</TD>
		</TR>
	 
	</TABLE>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><BR><B>Thank You for your time!  And enjoy the show!</B></FONT><BR><BR><BR>

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


