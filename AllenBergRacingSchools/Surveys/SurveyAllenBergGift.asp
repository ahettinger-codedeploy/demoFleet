<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%
Page = "Survey"

SurveyNumber = 310
SurveyName = "SurveyAllenBergGift.asp"

NumQuestions = 1
Dim Question(2)
Question(1) = "Would you like a personalized gift letter?"

'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
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

'Check to see if survey has already been completed for this order.  If so, redirect to Ship.asp.
SQLSurvey = "SELECT OrderHeader.CustomerNumber FROM SurveyAnswers (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON SurveyAnswers.CustomerNumber = OrderHeader.CustomerNumber WHERE SurveyAnswers.OrderNumber = " & Session("OrderNumber") 'Commented out for Test Drive Only & " OR SurveyAnswers.SurveyNumber = " & SurveyNumber
Set rsSurvey = OBJdbConnection.Execute(SQLSurvey)
If Not rsSurvey.EOF Then
	rsSurvey.close
	Set rsSurvey = nothing
	If Session("UserNumber") = "" Then
		Session("SurveyComplete") = Session("OrderNumber")
		Response.Redirect("/Ship.asp")
	Else
		Session("SurveyComplete") = Session("OrderNumber")
		Response.Redirect("/Management/AdvanceShip.asp")
	End If
End IF

If Request("FormName") <> "SurveyForm" Then
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
</HEAD>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<BR>
<BR>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3>Gift Certificate</H3></FONT>
<BR>
<FORM ACTION="/SurveyChicagoUncorked.asp" METHOD="post" NAME="Survey">
<INPUT TYPE="hidden" NAME="FormName" VALUE="SurveyForm">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">
<TABLE WIDTH="90%">
  <TR>
	<TD ALIGN=middle>
		<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><B><%= Question(1) %></B><BR></FONT>
	</TD>
	</TR>
	<TR>
	<TD ALIGN=middle>
			<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">
			<INPUT TYPE="radio" NAME="Answer1" VALUE="Yes">&nbsp;Yes&nbsp;&nbsp;<INPUT TYPE="radio" NAME="Answer1" VALUE="No">&nbsp;No<BR>
			
			</FONT><BR>
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


