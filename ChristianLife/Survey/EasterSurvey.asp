<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%
Page = "Survey"

SurveyNumber = 566
SurveyName = "EasterSurvey.asp"
NumQuestions = 1

Dim Question(2)

Question(1) = "How did you hear about Easter Celebration?"

'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If

MemberEventCount = ""
'Check if the member event code is in order
SQLMemberEvent = "SELECT COUNT (Distinct OrderLine.ItemNumber) AS TicketCount FROM OrderHeader (NOLOCK)  INNER JOIN Customer (NOLOCK)  ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN OrderLine  (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber INNER JOIN Seat (NOLOCK)  ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK)  ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationVenue (NOLOCK)  ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK)  ON Event.ActCode = OrganizationAct.ActCode AND OrganizationVenue.OrganizationNumber = OrganizationAct.OrganizationNumber INNER JOIN CustomerMailingList  (NOLOCK) ON Customer.CustomerNumber = CustomerMailingList.CustomerNumber WHERE (OrganizationVenue.OrganizationNumber = 473) AND OrderHeader.OrderNumber <> " & CleanNumeric(Session("OrderNumber")) 
Set rsMemberEvent = OBJdbConnection.Execute(SQLMemberEvent)
If Not rsMemberEvent.EOF Then 'it is in order
    MemberEventCount = rsMemberEvent("TicketCount")
End If
rsMemberEvent.Close
Set rsMemberEvent = nothing


If Clean(Request("FormName")) <> "SurveyForm" AND MemberEventCount = 0 Then
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


<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey">
<INPUT TYPE="hidden" NAME="FormName" VALUE="SurveyForm">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">
<BR><BR><FONT FACE="verdana,arial,helvetica" COLOR="#000000" SIZE="4">Survey</FONT><BR><BR>

<table cellpadding="0" cellspacing="0" border="0" width="600">

    <tr>
        <td width="600" align="left"><FONT FACE="verdana,arial,helvetica" COLOR="#000000" SIZE="2"><B><%= Question(1) %></B></FONT>
        
        <input type="hidden" name="Question1" value="How did you hear about Easter Celebration?" />
        
        </td>
    </tr>
    <tr><td>&nbsp;</td></tr>

    <tr>
        <td width="600" align="left">

          <INPUT TYPE="checkbox" NAME="Answer1" VALUE="Friend/Family"><FONT FACE="verdana,arial,helvetica" COLOR="#000000" SIZE="2">Friend/Family</FONT><br />
        
          <INPUT TYPE="checkbox" NAME="Answer1" VALUE="Mailer Postcard"><FONT FACE="verdana,arial,helvetica" COLOR="#000000" SIZE="2">Mailer Postcard</FONT><br />
        
          <INPUT TYPE="checkbox" NAME="Answer1" VALUE="Radio"><FONT FACE="verdana,arial,helvetica" COLOR="#000000" SIZE="2">Radio</FONT><br />
        
          <INPUT TYPE="checkbox" NAME="Answer1" VALUE="TV"><FONT FACE="verdana,arial,helvetica" COLOR="#000000" SIZE="2">TV</FONT><br />
        
          <INPUT TYPE="checkbox" NAME="Answer1" VALUE="Poster"><FONT FACE="verdana,arial,helvetica" COLOR="#000000" SIZE="2">Poster</FONT><br />
        
          <INPUT TYPE="checkbox" NAME="Answer1" VALUE="CLA Newsletter"><FONT FACE="verdana,arial,helvetica" COLOR="#000000" SIZE="2">CLA Newsletter</FONT><br />
        
          <INPUT TYPE="checkbox" NAME="Answer1" VALUE="CLA E-News"><FONT FACE="verdana,arial,helvetica" COLOR="#000000" SIZE="2">CLA E-News</FONT><br />
        
          <INPUT TYPE="checkbox" NAME="Answer1" VALUE="CLA Church Service"><FONT FACE="verdana,arial,helvetica" COLOR="#000000" SIZE="2">CLA Church Service</FONT><br />
        
        </td>
    </tr>
    <tr><td>&nbsp;</td></tr>

</table>

<FONT FACE="verdana,arial,helvetica" COLOR="#000000" SIZE="2">Thank you for your time!</FONT><BR><BR>


<INPUT TYPE="submit" VALUE="Continue">
</FORM>


</CENTER>

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


