<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%
Page = "Survey"

SurveyNumber = 636
SurveyName = "Survey.asp"
NumQuestions = 1
OrganizationNumber = Session("OrganizationNumber")

Dim Question(2)

Question(1) = "How did you hear about us? (check all that apply)"

'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If

'Bypass survey if this is not a Phone (2) order. 
If Session("OrderTypeNumber") <> 2 Then
	Call Continue
End If


If Clean(Request("FormName")) <> "SurveyForm" Then
	Call SurveyForm
Else
	Call UpdateSurveyAnswer
End If

OBJdbConnection.Close
Set OBJdbConnection = nothing


'==============================
Sub SurveyForm

'Get Organization Name
SQLOrgName = "SELECT Organization FROM Organization (NOLOCK) WHERE OrganizationNumber = " & OrganizationNumber & ""
Set rsOrgName = OBJdbConnection.Execute(SQLOrgName)
OrgName = rsOrgName("Organization")
rsOrgName.Close
Set rsOrgName = nothing

%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->
<!--#INCLUDE virtual="TopNavInclude.asp"-->
<HTML>
<HEAD>
<TITLE>"<%= Title %>"</TITLE>
</HEAD>
<BR>
<BR>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3><%= OrgName %><BR>Phone Order Survey</H3></FONT>
<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><FONT face="Geneva, Arial, Helvetica, san-serif">Please take a moment to answer the following question:</FONT>
<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey">
<INPUT TYPE="hidden" NAME="FormName" VALUE="SurveyForm">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">
<TABLE WIDTH="95%">
  <TR>
		<TD>&nbsp;</TD>
		<TD ALIGN="CENTER">
			<TABLE>
			  <TR>
					<TD>
						<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><B>"How did you hear about us?</B><BR>(check all that apply)"</FONT>
						<BR>
						<BR>
					</TD>
			  </TR>
			  <TR>
					<TD align =left>
						<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">
						<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Beach Billboard">&nbsp;Beach Billboard<BR>
						<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Arendell Street Billboard">&nbsp;Arendell Street Billboard<BR>
						<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Hwy 58 Billboard">&nbsp;Hwy 58 Billboard<BR>
						<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Magazine Ad">&nbsp;Magazine Ad<BR>
						<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Rack Card-Brochure">&nbsp;Rack Card-Brochure<BR>
						<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Internet">&nbsp;Internet<BR>
						<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Poster">&nbsp;Poster<BR>
						<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Radio">&nbsp;Radio<BR>
						<INPUT TYPE="checkbox" NAME="Answer1" VALUE="TV">&nbsp;TV<BR>
						<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Word of Mouth">&nbsp;Word of Mouth<BR>
						<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Been Before">&nbsp;Been Before<BR>
						<INPUT TYPE="checkbox" NAME="Answer1" VALUE="News paper Ad">&nbsp;News paper Ad<BR>
						</FONT><BR>
			    </TD>
			  </TR>
			</TABLE>
    </TD>
		<TD>&nbsp;</TD>
  </TR>
</TABLE>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><B>Thank You for your time!</B></FONT><BR><BR><BR>

<INPUT TYPE="submit" VALUE="Continue"></FORM>
</CENTER>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%
End Sub ' SurveyForm


'==============================
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

'==============================
Sub Continue
				
Session("SurveyComplete") = Session("OrderNumber")

If Session("UserNumber") = "" Then
	Response.Redirect("/Ship.asp")
Else
	Response.Redirect("/Management/AdvanceShip.asp")
End If		

End Sub 'Continue

'==============================


%>


