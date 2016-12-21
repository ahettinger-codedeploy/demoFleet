<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<!--#include virtual="NoCacheInclude.asp"-->
<%
Page = "Survey"

SurveyNumber = 504

NumQuestions = 1
Dim Question(2)
Question(1) = "Pre-Sale Code"

If Session("MemberID") <> "" Then 'If the database hasn't been updated for this order, update it.
	'Check to see if survey has already been completed for this order.  If not, add it.
	SQLSurvey = "SELECT OrderHeader.CustomerNumber FROM SurveyAnswers (NOLOCK) INNER JOIN OrderHeader WITH (NOLOCK) ON SurveyAnswers.CustomerNumber = OrderHeader.CustomerNumber WHERE SurveyAnswers.OrderNumber = " & Session("OrderNumber") & " AND SurveyAnswers.SurveyNumber = " & SurveyNumber
	Set rsSurvey = OBJdbConnection.Execute(SQLSurvey)
	If rsSurvey.EOF Then 'Insert the Survey Answer
	
		'Insert Survey
		SQLInsertSurvey = "INSERT SurveyAnswers(SurveyNumber, OrderNumber, CustomerNumber, SurveyDate, AnswerNumber, Answer, Question) VALUES(" & SurveyNumber & ", " & Session("OrderNumber") & ", " & Session("CustomerNumber") & ", '" & Now() & "', 1, '" & Session("MemberID") & "', '" & Question(1) & "')"
		Set rsInsertSurvey = OBJdbConnection.Execute(SQLInsertSurvey)
		
	End If
	
	rsSurvey.Close
	Set rsSurvey = nothing

End If

Session("SurveyComplete") = Session("OrderNumber")

If Session("UserNumber") = "" Then
	Response.Redirect("/Ship.asp")
Else
	Response.Redirect("/Management/AdvanceShip.asp")
End If


%>


