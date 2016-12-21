<!--#INCLUDE VIRTUAL=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%
Page = "Survey"

'Bay Area Rainbow Symphony (5/18/2010)
'=================================
'How Did You Hear About Us Survey?

SurveyNumber = 734
SurveyName = "AudienceSurvey.asp"

Dim Question(2)
NumQuestions = 1
Question(1) = "How did you hear about this BARS event?"

Dim SurveyFields(1,16)
SurveyFields(1,1) = "Know a Member"
SurveyFields(1,2) = "I am a Member"
SurveyFields(1,3) = "Email List"
SurveyFields(1,4) = "BARS Social Networks (Facebook, Twitter)"
SurveyFields(1,5) = "BARS Website"
SurveyFields(1,6) = "Mailing (Postcard, Letter)"
SurveyFields(1,7) = "BARS Event (Performance, Fundraiser)"

SurveyFields(1,8) = "Ad on other Website"
SurveyFields(1,9) = "Ad on Radio or TV"
SurveyFields(1,10) = "Ad in Printed Publication"
SurveyFields(1,11) = "Poster/Flyer"
SurveyFields(1,12) = "Listing/Announcement on other Website/Email"
SurveyFields(1,13) = "Story/Article in Media (Radio, TV, Print, Web)"
SurveyFields(1,14) = "Other Event featuring or supporting BARS"

SurveyFields(1,15) = "Other"
SurveyFields(1,16) = "Unsure/Don't Remember"

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

'========================
Sub SurveyForm
%>
	<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->
<%
	Response.Write "<TITLE>" & Title & "</TITLE>" & vbCrLf
	Response.Write "</HEAD>" & vbCrLf
	Response.Write strBody & vbCrLf

%>

	<!--#INCLUDE virtual="TopNavInclude.asp"-->

	<BR>
	<BR>
    <TABLE WIDTH="85%" border="0"><TR><TD ALIGN="CENTER"><H3><FONT FACE=verdana,arial,helvetica COLOR=#0079c1 SIZE=4><B><%=Question(1)%></B></FONT></H3></FONT></TD></TR></TABLE>
    <BR />
	<FORM ACTION= "<%=SurveyFileName %>" METHOD="post" NAME="Survey">
	<INPUT TYPE="hidden" NAME="FormName" VALUE="SurveyForm">
	<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%=SurveyNumber %>">
	<TABLE WIDTH="80%">
    <tr>
    <TD align=left><FONT FACE=verdana,arial,helvetica COLOR = #000000 SIZE=2><B>From BARS</B></FONT></TD>
    <td>&nbsp;&nbsp;</td>
    <TD align=left><FONT FACE=verdana,arial,helvetica COLOR = #000000 SIZE=2><B>From Elsewhere</B></FONT></TD>
  </TR>
  <TR>
	<TD align=left>		
	<FONT FACE=verdana,arial,helvetica COLOR = #000000 SIZE=2>				
	<INPUT TYPE="checkbox" NAME="Answer1" VALUE="<%= SurveyFields(1, 1) %>">&nbsp;<%= SurveyFields(1, 1) %><BR>
    <INPUT TYPE="checkbox" NAME="Answer1" VALUE="<%= SurveyFields(1, 2) %>">&nbsp;<%= SurveyFields(1, 2) %><BR>
    <INPUT TYPE="checkbox" NAME="Answer1" VALUE="<%= SurveyFields(1, 3) %>">&nbsp;<%= SurveyFields(1, 3) %><BR>						
    <INPUT TYPE="checkbox" NAME="Answer1" VALUE="<%= SurveyFields(1, 4) %>">&nbsp;<%= SurveyFields(1, 4) %><BR>
    <INPUT TYPE="checkbox" NAME="Answer1" VALUE="<%= SurveyFields(1, 5) %>">&nbsp;<%= SurveyFields(1, 5) %><BR>
    <INPUT TYPE="checkbox" NAME="Answer1" VALUE="<%= SurveyFields(1, 6) %>">&nbsp;<%= SurveyFields(1, 6) %><BR>							
    <INPUT TYPE="checkbox" NAME="Answer1" VALUE="<%= SurveyFields(1, 7) %>">&nbsp;<%= SurveyFields(1, 7) %><BR>	
    </FONT>							
	</TD>
	<td>&nbsp;&nbsp;</td>
	<TD align=left>		
	<FONT FACE=verdana,arial,helvetica COLOR = #000000 SIZE=2>				
	<INPUT TYPE="checkbox" NAME="Answer1" VALUE="<%= SurveyFields(1, 8) %>">&nbsp;<%= SurveyFields(1, 8) %><BR>
    <INPUT TYPE="checkbox" NAME="Answer1" VALUE="<%= SurveyFields(1, 9) %>">&nbsp;<%= SurveyFields(1, 9) %><BR>
    <INPUT TYPE="checkbox" NAME="Answer1" VALUE="<%= SurveyFields(1, 10) %>">&nbsp;<%= SurveyFields(1, 10) %><BR>						
    <INPUT TYPE="checkbox" NAME="Answer1" VALUE="<%= SurveyFields(1, 11) %>">&nbsp;<%= SurveyFields(1, 11) %><BR>
    <INPUT TYPE="checkbox" NAME="Answer1" VALUE="<%= SurveyFields(1, 12) %>">&nbsp;<%= SurveyFields(1, 12) %><BR>
    <INPUT TYPE="checkbox" NAME="Answer1" VALUE="<%= SurveyFields(1, 13) %>">&nbsp;<%= SurveyFields(1, 13) %><BR>							
    <INPUT TYPE="checkbox" NAME="Answer1" VALUE="<%= SurveyFields(1, 14) %>">&nbsp;<%= SurveyFields(1, 14) %><BR>	
    </FONT>								
	</TD>
   </TR>
   <TR>
	<td align=left colspan="3">
    <FONT FACE=verdana,arial,helvetica COLOR = #000000 SIZE=2>	
    <br />
    <hr />
    <br />
	<INPUT TYPE="checkbox" NAME="Answer1" VALUE="<%= SurveyFields(1, 15) %>">&nbsp;<%= SurveyFields(1, 15) %>:&nbsp;<INPUT TYPE="text" NAME="Answer1" SIZE="20"><BR>
	<INPUT TYPE="checkbox" NAME="Answer1" VALUE="<%= SurveyFields(1, 16) %>">&nbsp;<%= SurveyFields(1, 16) %><BR>
	</FONT>
	</td>
  </TR>
</TABLE>
<center>
<INPUT TYPE="submit" VALUE="Continue"></FORM>
</center>
<!--#INCLUDE virtual="FooterInclude.asp"-->
</BODY>
</HTML>
<%
End Sub ' SurveyForm

'===========================

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

'===========================

%>


