<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%
Page = "Survey"

SurveyNumber = 401
SurveyName = "SubscriptionSurveyCheck.asp"
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
    'get number of tickets for 22672 - The Full Monty
    SQLAct1Count = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & CleanNumeric(Session("OrderNumber")) & " AND ActCode = 27150"
    Set rsAct1Count = OBJdbConnection.Execute(SQLAct1Count)
    Act1Tickets = rsAct1Count("LineCount")
    rsAct1Count.Close
    Set rsAct1Count = nothing
    'get number of tickets for 22673 - Other Side of the Island
    SQLAct2Count = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & CleanNumeric(Session("OrderNumber")) & " AND ActCode = 27151"
    Set rsAct2Count = OBJdbConnection.Execute(SQLAct2Count)
    Act2Tickets = rsAct2Count("LineCount")
    rsAct2Count.Close
    Set rsAct2Count = nothing
    'get number of tickets for 22674 - Pete 'n' Keely
    SQLAct3Count = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & CleanNumeric(Session("OrderNumber")) & " AND ActCode = 27152"
    Set rsAct3Count = OBJdbConnection.Execute(SQLAct3Count)
    Act3Tickets = rsAct3Count("LineCount")
    rsAct3Count.Close
    Set rsAct3Count = nothing
    
    'check if any are not selected
    If Act1Tickets = 0 Or Act2Tickets = 0 Or Act3Tickets = 0 Then
        Call WarningPage("You need to buy at least one ticket from <u>each</u>: Brahms Requiem, Christmas Concert, Schubert Mass and Lauridsen Lux Aeterna")
    Else
        'Check if all productions have the same number of tickets for each
        If Act1Tickets = Act2Tickets And Act2Tickets = Act3Tickets And Act3Tickets = Act1Tickets Then
            'they all have same number of tickets
            Call UpdateSurveyAnswer
        Else
            Call WarningPage("The number of tickets for Brahms Requiem, Christmas Concert, Schubert Mass and Lauridsen Lux Aeterna need to be the same.<br>(ex: 1,1,1 or 2,2,2)")
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


