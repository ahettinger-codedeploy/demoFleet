<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%
Page = "Survey"

SurveyNumber = 421
NumQuestions =5

Dim Question(6)

Question(1) = "Passenger Name"
Question(2) = "Passport Number"
Question(3) = "Passport Expiration Date"
Question(4) = "Citizenship"
Question(5) = "Birth Date"
Question(6) = "Departing Airport"

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
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3>Additional Information</H3></FONT>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2">(Please complete for each passenger)</FONT>

<BR>
<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey">
<INPUT TYPE="hidden" NAME="FormName" VALUE="SurveyForm">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">
<TABLE WIDTH="70%">
<%

SQLBenTix = "SELECT Seat.ItemNumber FROM Seat (NOLOCK) INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE Seat.OrderNumber = " & Session("OrderNumber") & " AND Event.ActCode IN (27914,27915,27916,27917)"
Set rsBenTix = OBJdbConnection.Execute(SQLBenTix)

Do Until rsBenTix.EOF

%>
  <TR>
		<TD ALIGN="right">
			<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><B><%= Question(1) %></B></FONT>
		</TD>
		<TD ALIGN="left">
			<INPUT TYPE="text" NAME="Answer1" VALUE="" SIZE="20">
		</TD>
  </TR>
    <TR>
		<TD ALIGN="right">
			<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><B><%= Question(2) %></B></FONT>
		</TD>
		<TD ALIGN="left">
			<INPUT TYPE="text" NAME="Answer2" VALUE="" SIZE="20">
		</TD>
  </TR>
    <TR>
		<TD ALIGN="right">
			<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><B><%= Question(3) %></B></FONT>
		</TD>
		<TD ALIGN="left">
			<INPUT TYPE="text" NAME="Answer3" VALUE="" SIZE="20">
		</TD>
  </TR>
    <TR>
		<TD ALIGN="right">
			<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><B><%= Question(4) %></B></FONT>
		</TD>
		<TD ALIGN="left">
			<INPUT TYPE="text" NAME="Answer4" VALUE="" SIZE="20"><BR>
		</TD>
  </TR>
  <TR>
		<TD ALIGN="right">
			<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><B><%= Question(5) %></B></FONT>
		</TD>
		<TD ALIGN="left">
			<INPUT TYPE="text" NAME="Answer5" VALUE="" SIZE="20"><BR>
		</TD>
  </TR>
    <TR>
		<TD ALIGN="right">
			<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><B><%= Question(6) %></B></FONT>
		</TD>
		<TD ALIGN="left">
			<INPUT TYPE="text" NAME="Answer6" VALUE="" SIZE="20"><BR>
		</TD>
  </TR>
  <TR>
		<TD ALIGN="right">------------------------------</TD>
		<TD ALIGN="left">------------------------------</TD>
  </TR>
  

<%

	rsBenTix.MoveNext
Loop


rsBenTix.Close
Set rsBenTix = nothing



%>
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


