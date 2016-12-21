<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%
Page = "Survey"

SurveyNumber = 394
SurveyFileName = "Survey.asp"
NumQuestions = 1

Dim Question(2)

Question(1) = "How did you hear about this production?"

'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If

If Clean(Request("FormName")) = "GeneralSurvey" Then
    Call GeneralSurvey
ElseIf Clean(Request("FormName")) = "UpdateSurvey" Then
    Call UpdateSurveyAnswer
Else
    Call SurveyForm
End If

OBJdbConnection.Close
Set OBJdbConnection = nothing

Sub SurveyForm

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & Title & "</TITLE>" & vbCrLf
%>
<script language="javascript">
    function validate() {
        if(document.Survey.terms.checked != true) {
            alert('Please accept the terms above to continue');
            return false;
        }
    }
</script>
<%
Response.Write "</HEAD>" & vbCrLf
Response.Write strBody & vbCrLf
%>

<!--#INCLUDE virtual="TopNavInclude.asp"-->
<BR>
<BR>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3>Survey - Waiver Language</H3></FONT><BR>
<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><FONT face="Geneva, Arial, Helvetica, san-serif">Please read and accept the following terms:</FONT></FONT><BR>

<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey" onsubmit="return validate();">
<INPUT TYPE="hidden" NAME="FormName" VALUE="GeneralSurvey">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">
<TABLE CELLPADDING=10 CELLSPACING=5 WIDTH="600" border=0>
  <TR>
    <TD ALIGN=left NOWRAP width=600><div style="width:600px">
	  <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><B>Release, Waiver, and Assumption of Risk</B><br />(must be signed before participating in any event or activity).  As a registered participant, or parent/legal guardian of a registered participant, in the listed activity or event, I am fully aware of and understand the potential risk involved with my, or my child’s, participation in this physical activity, including, but not limited to, cuts, bruises, broken bones, and other injuries, damages, or losses.  I hereby agree to assume all risk of injury, damage to persons or property, or death resulting from my, or my child’s, participation in this activity or event and the use of City of Novi facilities.  I do hereby fully release and discharge the City of Novi, its officers, agents, employees, volunteers, sponsors, and organizers from any and all liability for any injury, including death, damages, or loss that I, or my child, may have or incur as a participant in the listed activity or event, and further agree to indemnify and hold harmless the City of Novi, its officers, agents, employees, volunteers, sponsors, and organizers from and against any and all liability that may be suffered by me or my child as a result of, or in any way connected to, my or my child’s participation in the listed activity or event.  This Release, Waiver, and Assumption of Risk shall be binding upon my heirs and dependents.<br /><b>Photo/Video Authorization</b><br />I hereby give my consent for Novi Parks to use photos/video coverage of myself and/or minor child participating in a Novi Parks sponsored program or event in future Recreation Guides, flyers, local cable channel programming, website, etc.<br /><b>Special Needs</b><br />If anyone requires special accommodations to attend or participate in a Novi Parks program or activity, please call the office 248.347.0400 or email noviparks@cityofnovi.org at least 48 hours prior to the event.</FONT>
	</div></TD>
  </TR>
  <TR>
    <TD ALIGN=left NOWRAP>
	  <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><input type="checkbox" name="terms" />&nbsp;I accept</FONT>
	</TD>
  </TR>
</TABLE>
<BR><BR><BR>

<INPUT TYPE="submit" VALUE="Continue"></FORM>


<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%
End Sub ' SurveyForm

Sub GeneralSurvey

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & Title & "</TITLE>" & vbCrLf
%>
<script language="javascript">
    function validateSurvey() {
        if(document.GeneralSurveyForm.Answer1[0].checked == false && document.GeneralSurveyForm.Answer1[1].checked == false && document.GeneralSurveyForm.Answer1[2].checked == false && document.GeneralSurveyForm.Answer1[3].checked == false && document.GeneralSurveyForm.Answer1[4].checked == false && document.GeneralSurveyForm.Answer1[5].checked == false && document.GeneralSurveyForm.Answer1[6].checked == false && document.GeneralSurveyForm.Answer1[7].checked == false && document.GeneralSurveyForm.Answer1[8].checked == false) {
            alert('Please select an answer to continue');
            return false;
        }
    }
</script>
<%
Response.Write "</HEAD>" & vbCrLf
Response.Write strBody & vbCrLf
%>

<!--#INCLUDE virtual="TopNavInclude.asp"-->
<BR>
<BR>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3>Required Survey</H3></FONT><BR>
<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><FONT face="Geneva, Arial, Helvetica, san-serif">Please select one or more from the following question:</FONT></FONT><BR>

<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="GeneralSurveyForm" onsubmit="return validateSurvey();">
<INPUT TYPE="hidden" NAME="FormName" VALUE="UpdateSurvey">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">
<TABLE CELLPADDING=10 CELLSPACING=5 WIDTH="100%" border=0>
  <TR>
    <TD ALIGN=left NOWRAP>
	  <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><B><%=Question(1)%></B></FONT>
	</TD>
  </TR>
  <TR>
    <TD ALIGN=left NOWRAP>
	  <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">
		<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Newspaper">&nbsp;Newspaper<BR>
		<INPUT TYPE="checkbox" NAME="Answer1" VALUE="City of Novi Website">&nbsp;City of Novi Website<BR>
		<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Word of Mouth">&nbsp;Word of Mouth<BR>
		<INPUT TYPE="checkbox" NAME="Answer1" VALUE="E-mail">&nbsp;E-mail<BR>
		<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Production Poster">&nbsp;Production Poster<BR>
		<INPUT TYPE="checkbox" NAME="Answer1" VALUE="School Flyer">&nbsp;School Flyer<BR>
		<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Engage">&nbsp;Engage<BR>
		<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Channel 13">&nbsp;Channel 13<BR>
		<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Other">&nbsp;Other&nbsp;<INPUT TYPE="text" NAME="Answer1" SIZE=25><BR>
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
End Sub ' GeneralSurveyForm

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


