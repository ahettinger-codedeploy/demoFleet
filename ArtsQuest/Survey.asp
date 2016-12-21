<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%
Page = "Survey"

SurveyNumber = 3

Response.Write "Order Number = " & Session("OrderNumber") & "<BR>"

Sub Test
'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		'Response.Redirect("/Default.asp")
		Response.Write "No Order Number<BR>"
		Response.Redirect ("http://www.yahoo.com")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If

If Session("UserNumber") = "" Then 'It's not Management
	'Check to see if there is a Club Musikfest Member
	If Session("MemberID") <> "" Then 'If the database hasn't been updated for this order, update it.
		'Check to see if survey has already been completed for this order.  If so, redirect to Ship.asp.
		SQLSurvey = "SELECT OrderHeader.CustomerNumber FROM SurveyAnswers INNER JOIN OrderHeader ON SurveyAnswers.CustomerNumber = OrderHeader.CustomerNumber WHERE SurveyAnswers.OrderNumber = " & Session("OrderNumber") & " OR SurveyAnswers.SurveyNumber = " & SurveyNumber
		Set rsSurvey = OBJdbConnection.Execute(SQLSurvey)
		If Not rsSurvey.EOF Then
			rsSurvey.close
			Set rsSurvey = nothing
			Response.Redirect("/Ship.asp?SurveyComplete=Y")
		Else 'Insert the Survey Answer
		
			'Get the CustomerNumber for this Order		
			SQLOrder = "SELECT OrderNumber, CustomerNumber FROM OrderHeader WHERE OrderNumber = " & Session("OrderNumber")
			Set rsOrder = OBJdbConnection.Execute(SQLOrder)
			
			'Insert Survey
			SQLInsertSurvey = "INSERT SurveyAnswers(SurveyNumber, OrderNumber, CustomerNumber, SurveyDate, AnswerNumber, Answer) VALUES(" & SurveyNumber & ", " & rsOrder("OrderNumber") & ", " & rsOrder("CustomerNumber") & ", '" & Now() & "', 1, '" & Session("MemberID") & "')"
			Set rsInsertSurvey = OBJdbConnection.Execute(SQLInsertSurvey)
			
			rsOrder.Close
			Set rsOrder = nothing
			
		End If
		rsSurvey.Close
		Set rsSurvey = nothing
	Else
		Response.Redirect("/Ship.asp?SurveyComplete=Y")
	End If

Else

	If Clean(Request("FormName")) <> "SurveyForm" Then
		Call SurveyForm
	Else
		Call UpdateSurveyAnswer
	End If

	OBJdbConnection.Close
	Set OBJdbConnection = nothing

End If

End Sub 'Test

Sub SurveyForm

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & Title & "</TITLE>" & vbCrLf
Response.Write "</HEAD>" & vbCrLf

%>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<BR>
<BR>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3>Club Musikfest Member</H3></FONT>
<BR>
<FORM ACTION="Survey.asp" METHOD="post" NAME="Survey">
<INPUT TYPE="hidden" NAME="FormName" VALUE="SurveyForm">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">
<TABLE WIDTH="90%">
  <TR>
	<TD ALIGN=right>
		<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><B>Enter Club Musifest/Sponsor ID:</B></FONT>
	</TD>
	<TD>
		<SELECT NAME="Answer1">
		<OPTION VALUE="" SELECTED>None
<%
SQLMembers = "SELECT MemberID, MemberName FROM Members WHERE OrganizationNumber = 9 ORDER BY MemberName"
Set rsMembers = OBJdbConnection.Execute(SQLMembers)

Do Until rsMembers.EOF
	Response.Write "<OPTION VALUE=""" & rsMembers("MemberID") & """>" & rsMembers("MemberName") & vbCrLf
	rsMembers.MoveNext
Loop

rsMembers.Close
Set rsMembers = nothing

%>
		</SELECT>
	</TD>
  </TR>
  <TR>
    <TD COLSPAN="2">&nbsp;</TD>
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

	SQLOrder = "SELECT OrderNumber, CustomerNumber FROM OrderHeader WHERE OrderNumber = " & Session("OrderNumber")
	Set rsOrder = OBJdbConnection.Execute(SQLOrder)

	If Not rsOrder.EOF Then

		If Request("Answer1") <> "" Then
			SQLInsertSurvey = "INSERT SurveyAnswers(SurveyNumber, OrderNumber, CustomerNumber, SurveyDate, AnswerNumber, Answer) VALUES(" & Clean(Request("SurveyNumber")) & ", " & rsOrder("OrderNumber") & ", " & rsOrder("CustomerNumber") & ", '" & Now() & "', 1, '" & Clean(Request("Answer1")) & "')"
			Set rsInsertSurvey = OBJdbConnection.Execute(SQLInsertSurvey)
		End If
		
	End If

	rsOrder.Close
	Set rsOrder = nothing

	If Session("UserNumber") = "" Then
		Response.Redirect("/Ship.asp?SurveyComplete=Y")
	Else
		Response.Redirect("/Management/AdvanceShip.asp?SurveyComplete=Y")
	End If
		

Else 'No Session Order Number
	
	Response.Redirect(HomePage)	

End If


End Sub 'Update SurveyAnswer

%>


