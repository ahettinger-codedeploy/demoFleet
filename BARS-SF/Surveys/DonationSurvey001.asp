<!--#INCLUDE virtual=/PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=/GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=/DBOpenInclude.asp -->
<%
Page = "Survey"

SurveyNumber = 778
SurveyName = "DonationSurvey.asp"
NumQuestions = 17

Dim Question(18)

Question(1) = "Given By Name:"
Question(2) = "Given By Address:"
Question(3) = "Given By City:"
Question(4) = "Given By State:"
Question(5) = "Given By Zip Code:"
Question(6) = "Memory or Honor?"
Question(7) = "Occasion:"
Question(8) = "Memoriam Name:"
Question(9) = "Memoriam Address:"
Question(10) = "Memoriam City:"
Question(11) = "Memoriam State:"
Question(12) = "Memoriam Zip Code:"
Question(13) = "Acknowledgement Name:"
Question(14) = "Acknowledgement Address:"
Question(15) = "Acknowledgement City:"
Question(16) = "Acknowledgement State:"
Question(17) = "Acknowledgement Zip Code:"


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

<!--#INCLUDE virtual="/TopNavInclude.asp"-->

<BR>
<BR>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3>MEMORIALS/HONORARIUMS</H3></FONT>
<BR>
<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey">
<INPUT TYPE="hidden" NAME="FormName" VALUE="SurveyForm">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">

	<TABLE border="0" cellpadding="2" cellspacing="0" width="550">
		<TR>
			<TD bgcolor="#391B76"  colspan=2><font color="#FFFFFF" face="Arial" size="3">&nbsp;<b>GIVEN BY:</font></b><BR></TD>
		</TR>
		<TR>
			<TD align="left" width="125"><b><font size="3" face="Arial" color="#000000">Name:&nbsp;</font></b></td><td width="425"><input TYPE="text" NAME="Answer1" size=50>
			</TD>
		</TR>
		<TR>
			<TD align="left" width="125"><b><font size="3" face="Arial" color="#000000">Address:&nbsp;</font></b></td><td width="425"><input TYPE="text" NAME="Answer2" size=50 rows="3">
			</TD>
		</TR>
		<TR>
			<TD align="left" width="125"><b><font size="3" face="Arial" color="#000000">City:&nbsp;</font></b></td>
			<td width="425"><input TYPE="text" NAME="Answer3" size=50></TD>
		</TR>
		<TR>
			<TD align="left" width="125"><b><font size="3" face="Arial" color="#000000">State:&nbsp;</font></b></TD>
			<TD width="425"><input TYPE="text" NAME="Answer4" size=2>&nbsp;<font size="3" face="Arial" color="#000000"><b>Zip Code:&nbsp;</b><input TYPE="text" NAME="Answer5" size=5></font></b></TD>
		</TR>
	</TABLE>
	<br><br>
	<TABLE border="0" cellpadding="2" cellspacing="0" width="550">
	<TR>
		<TD bgcolor="#391B76"  colspan=2><font color="#FFFFFF" face="Arial" size="3"><INPUT TYPE="radio" NAME="Answer6" VALUE="MEMORY OF">&nbsp;<b>MEMORY OF:&nbsp;&nbsp;&nbsp;<INPUT TYPE="radio" NAME="Answer6" VALUE="HONOR OF">&nbsp;<b>HONOR OF:</TD>
	</TR>
	<TR>
		<TD align="left" width="125"><b><font size="3" face="Arial" color="#000000">Occasion:&nbsp;</font></b></td><td width="425"><input TYPE="text" NAME="Answer7" size=50></TD>
	</TR>
	<TR>
		<TD align="left" width="125"><b><font size="3" face="Arial" color="#000000">Name:&nbsp;</font></b></td><td width="425"><input TYPE="text" NAME="Answer8" size=50>
		</TD>
	</TR>
	<TR>
		<TD align="left" width="125"><b><font size="3" face="Arial" color="#000000">Address:&nbsp;</font></b></td><td width="425"><input TYPE="text" NAME="Answer9" size=50 rows="3">
		</TD>
	</TR>
	<TR>
		<TD align="left" width="125"><b><font size="3" face="Arial" color="#000000">City:&nbsp;</font></b></td>
		<td width="425"><input TYPE="text" NAME="Answer10" size=50></TD>
	</TR>
	<TR>
		<TD align="left" width="125"><b><font size="3" face="Arial" color="#000000">State:&nbsp;</font></b></TD>
		<TD width="425"><input TYPE="text" NAME="Answer11" size=2>&nbsp;<font size="3" face="Arial" color="#000000"><b>Zip Code:&nbsp;</b><input TYPE="text" NAME="Answer12" size=5></font></b></TD>
	</TR>
</TABLE>
<br><br>
	<TABLE border="0" cellpadding="2" cellspacing="0" width="550">
		<TR>
			<TD bgcolor="#391B76"  colspan=2><font color="#FFFFFF" face="Arial" size="3">&nbsp;<b>PLEASE SEND ACKNOWLEDGEMENT TO:</font></b><BR></TD>
		</TR>
		<TR>
			<TD align="left" width="125"><b><font size="3" face="Arial" color="#000000">Name:&nbsp;</font></b></td><td width="425"><input TYPE="text" NAME="Answer13" size=50>
			</TD>
		</TR>
		<TR>
			<TD align="left" width="125"><b><font size="3" face="Arial" color="#000000">Address:&nbsp;</font></b></td><td width="425"><input TYPE="text" NAME="Answer14" size=50 rows="3">
			</TD>
		</TR>
		<TR>
			<TD align="left" width="125"><b><font size="3" face="Arial" color="#000000">City:&nbsp;</font></b></td>
			<td width="425"><input TYPE="text" NAME="Answer15" size=50></TD>
		</TR>
		<TR>
			<TD align="left" width="125"><b><font size="3" face="Arial" color="#000000">State:&nbsp;</font></b></TD>
			<TD width="425"><input TYPE="text" NAME="Answer16" size=2>&nbsp;<font size="3" face="Arial" color="#000000"><b>Zip Code:&nbsp;</b><input TYPE="text" NAME="Answer17" size=5></font></b></TD>
		</TR>
	</TABLE>
<br><br>
</TR>
</TD>
</TABLE>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><BR><B>Thank You</B></FONT><BR><BR>

<INPUT TYPE="submit" VALUE="Continue"></FORM>


<!--#INCLUDE virtual="/FooterInclude.asp"-->

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


