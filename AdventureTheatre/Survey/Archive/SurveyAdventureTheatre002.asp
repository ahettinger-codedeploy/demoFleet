<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%
Page = "Survey"

SurveyNumber = 375
SurveyFileName = "SurveyAdventureTheatre.asp"
NumQuestions = 1

Dim Question(2)

Question(1) = "How did you hear about this performance at Adventure Theatre?"

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
		</TR>
		<TR>
		<TD>
			<BR>
			<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">
			<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Returning patron">&nbsp;Returning patron<BR>
			<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Postcard from Adventure Theatre">&nbsp;Postcard from Adventure Theatre<BR>
			<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Email from Adventure Theatre">&nbsp;Email from Adventure Theatre<BR>
			<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Glen Echo Park Brochure">&nbsp;Glen Echo Park Brochure<BR>
			<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Friend">&nbsp;Friend<BR>
			<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Website - Adventure Theatre">&nbsp;Website - Adventure Theatre<BR>
			<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Website">&nbsp;Website - Other:&nbsp;<INPUT TYPE="text" NAME="Answer1" SIZE=50><BR>
			<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Washington Post Advertisement">&nbsp;Washington Post Advertisement<BR>
			<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Advertisement">&nbsp;Advertisement - Other:&nbsp;<INPUT TYPE="text" NAME="Answer1" SIZE=50><BR>
			<INPUT TYPE="checkbox" NAME="Answer1" VALUE="TV">&nbsp;TV<BR>
			<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Radio">&nbsp;Radio<BR>
			<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Auction Award Winner">&nbsp;Auction Award Winner<BR>
			<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Other">&nbsp;Other:&nbsp;<INPUT TYPE="text" NAME="Answer1" SIZE=50><BR>
			</FONT><BR>
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


