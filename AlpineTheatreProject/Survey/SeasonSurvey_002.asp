<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%
Page = "Survey"

SurveyNumber = 319
SurveyName = "SurveyAlpineTheatreProject.asp"
NumQuestions = 1

Dim Question(2)

Question(1) = "How did you hear about us?"

'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If

If Clean(Request("FormName")) <> "SurveyForm" Then
	'Call SurveyForm
	Call CheckSeasonSubscription
Else
	Call UpdateSurveyAnswer
End If

OBJdbConnection.Close
Set OBJdbConnection = nothing

'check to make sure at least 1 ticket is selected from each production
Sub CheckSeasonSubscription
    'get number of tickets for 34540 - Stone
    SQLAct1Count = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & CleanNumeric(Session("OrderNumber")) & " AND ActCode = 34540"
    Set rsAct1Count = OBJdbConnection.Execute(SQLAct1Count)
    Act1Tickets = rsAct1Count("LineCount")
    rsAct1Count.Close
    Set rsAct1Count = nothing
    'get number of tickets for 34541 - Bee
    SQLAct2Count = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & CleanNumeric(Session("OrderNumber")) & " AND ActCode = 34541"
    Set rsAct2Count = OBJdbConnection.Execute(SQLAct2Count)
    Act2Tickets = rsAct2Count("LineCount")
    rsAct2Count.Close
    Set rsAct2Count = nothing
    'get number of tickets for 34542 - World
    SQLAct3Count = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & CleanNumeric(Session("OrderNumber")) & " AND ActCode = 34542"
    Set rsAct3Count = OBJdbConnection.Execute(SQLAct3Count)
    Act3Tickets = rsAct3Count("LineCount")
    rsAct3Count.Close
    Set rsAct3Count = nothing
    
    'check if any are not selected
    If Act1Tickets = 0 Or Act2Tickets = 0 Or Act3Tickets = 0 Then
        Call WarningPage("You need to buy at least one ticket from <u>each</u>: The World Goes Round, The 25th Annual Putnam County Spelling Bee and Stones in His Pockets.")
    Else
        'Check if all productions have the same number of tickets for each
        If Act1Tickets = Act2Tickets And Act2Tickets = Act3Tickets And Act3Tickets = Act1Tickets Then
            'they all have same number of tickets
            Call SurveyForm
        Else
            Call WarningPage("The number of tickets for The World Goes Round, The 25th Annual Putnam County Spelling Bee and Stones in His Pockets need to be the same.<br>(ex: 1,1,1 or 2,2,2)")
        End If
    End If
End Sub

'Warning Page
Sub WarningPage(Message)
Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & Title & "</TITLE>" & vbCrLf
Response.Write "</HEAD>" & vbCrLf
Response.Write "<BODY BGCOLOR=" & BGColor & " LINK="& LinkColor & " ALINK=" & ALinkColor & " VLINK=" & VLinkColor & " leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0 " & BodyParameters & ">" & vbCrLf
%>
<!--#INCLUDE virtual="TopNavInclude.asp"-->

<BR>
<BR>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3>Notice</H3></FONT>

<%
If Session("UserNumber") = "" Then
Response.Write "<CENTER><TABLE><TR><TD Align=center><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=2>" & Message & "</FONT><BR><BR><INPUT TYPE=""button"" VALUE=""Back to Shopping"" onclick=""location.href='/ShoppingCart.asp';""><BR><BR></TD></TR></TABLE></CENTER>" & vbCrLf
Else
Response.Write "<CENTER><TABLE><TR><TD Align=center><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=2>" & Message & "</FONT><BR><BR><INPUT TYPE=""button"" VALUE=""Back to Shopping"" onclick=""location.href='/Management/ShoppingCart.asp';""><BR><BR></TD></TR></TABLE></CENTER>" & vbCrLf
End If
%>

<!--#INCLUDE virtual="FooterInclude.asp"-->
<%
Response.Write "</BODY>" & vbCrLf
Response.Write "</HTML>" & vbCrLf
End Sub

'General Survey
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
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3>Brief Audience Survey</H3></FONT>
<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><FONT face="Geneva, Arial, Helvetica, san-serif">Please take a minute to complete the following audience survey, and help us serve you better.</FONT><BR>
<BR>
<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey">
<INPUT TYPE="hidden" NAME="FormName" VALUE="SurveyForm">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">
<TABLE WIDTH="70%">
  <TR>
		<TD>
			<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><B><%= Question(1) %></B></FONT>
		</TD>
  </TR>
  <TR>
		<TD>
			<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">
			<INPUT TYPE="radio" NAME="Answer1" VALUE="Advertising">&nbsp;Advertising<BR>
			<INPUT TYPE="radio" NAME="Answer1" VALUE="Direct Mail">&nbsp;Direct Mail<BR>
			<INPUT TYPE="radio" NAME="Answer1" VALUE="Article or Interview">&nbsp;Article or Interview<BR>
			<INPUT TYPE="radio" NAME="Answer1" VALUE="Signage (posters, etc)">&nbsp;Signage (posters, etc)<BR>
			<INPUT TYPE="radio" NAME="Answer1" VALUE="Word of Mouth">&nbsp;Word of Mouth<BR>
			<INPUT TYPE="radio" NAME="Answer1" VALUE="Internet or Email">&nbsp;Internet or Email<BR>
			</FONT><BR>
    </TD>
  </TR>
  </TABLE>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="3"><B>Thank You for your time!</B></FONT><BR><BR><BR>

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
		Response.Redirect("Ship.asp")
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


