<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%


'This survey prompts for a membership number when member ticket types are purchased. 
'When a membership number is keyed in, it's "validated" by system. Only "valid" membership numbers can continue.
'This survey limits the number of member tickets to be purchased.

Page = "Survey"
SurveyNumber = 616
SurveyFileName = "MemberSurvey.asp"
MemberName = "Member/Associate"
MemberList = "3442" 'List of Member Seat Type Codes
SeatTypeCode = (Clean(Request("SeatTypeCode")))
MaxTickets = 200
VIPEventCode = 200138

NumQuestions = 2
Dim Question(3)

Question(2) = "VIP status"
Question(3) = "Any Special Seating Requests?"

'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	OBJdbConnection.Close
	Set OBJdbConnection = nothing
	Response.Redirect("/Default.asp")
End If

MemberCount = 0
'Count number of member tickets
SQLMemberCount = "SELECT COUNT(LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber")& " AND OrderLine.SeatTypeCode IN (" & MemberList & ") AND EventCode IN(200130,200138)"
Set rsMemberCount = OBJdbConnection.Execute(SQLMemberCount)
MemberCount = rsMemberCount("TicketCount")
rsMemberCount.Close
Set rsMemberCount = nothing

If Request("FormName") = "" Then
    If CInt(MemberCount) > 0 Then
        If CInt(MemberCount) > CInt(MaxTickets) Then
	        Call WarningPage(MemberCount, MemberName)
        Else
            Call MemberNumberForm(Message)
        End If
    Else
        NbrTickets = 0
        'Determine number of tickets from VIP event on the order
        SQLCount = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND EventCode = " & VIPEventCode & ""
        Set rsCount = OBJdbConnection.Execute(SQLCount)
        NbrTickets = rsCount("TicketCount")
        rsCount.Close
        Set rsCount = nothing

        If CInt(NbrTickets) >= 1 Then
            Call VIPSurveyForm
        Else
	        Call Continue
        End If
    End If
End If

Select Case Request("FormName")
	Case "MemberNumberForm"
		Call ValidateMember(Clean(Request("MemberNumber")))
	Case "UpdateVIPSurveyAnswer"
		Call UpdateVIPSurveyAnswer	
	'Case Else
		'Call MemberNumberForm(Message)
End Select


'==============================
Sub MemberNumberForm(Message)

'Check for existing survey entry for this order
SQLSurveyAnswers = "SELECT Answer FROM SurveyAnswers(NOLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND SurveyNumber = 616 AND Question = 'MembershipNumber'"
Set rsSurveyAnswers = OBJdbConnection.Execute(SQLSurveyAnswers)

If rsSurveyAnswers.EOF Then
	SurveyComplete = "N"
Else
	SurveyComplete = "Y"
End If

rsSurveyAnswers.Close
Set SurveyAnswers = nothing

If SurveyComplete = "N" Then 

	Response.Write "<HTML>" & vbCrLf
	Response.Write "<HEAD>" & vbCrLf
	Response.Write "<TITLE>" & Title & "</TITLE>" & vbCrLf
	Response.Write "</HEAD>" & vbCrLf

	If Message = "" Then
		Response.Write "<BODY BGCOLOR=" & BGColor & " LINK="& LinkColor & " ALINK=" & ALinkColor & " VLINK=" & VLinkColor & " leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0 " & BodyParameters & ">" & vbCrLf
	Else
		Response.Write "<BODY BGCOLOR=" & BGColor & " LINK="& LinkColor & " ALINK=" & ALinkColor & " VLINK=" & VLinkColor & " onLoad=""alert('" & Message & "');"" leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0 " & BodyParameters & ">" & vbCrLf
	End If
						
	%>

	<!--#INCLUDE virtual="TopNavInclude.asp"-->

	<BR>
	<BR>

	<%

Response.Write "<FORM ACTION=""" & SurveyFileName & """ METHOD=""post"" id=form1 name=form1><INPUT TYPE=""hidden"" NAME=""FormName"" VALUE=""MemberNumberForm"">" & vbCrLf
Response.Write "<FONT FACE=" & FontFace & " COLOR=" &  HeadingFontColor & " SIZE=4><B>Membership Validation</B></FONT><BR><BR>" & vbCrLf
Response.Write "<TABLE>" & vbCrLf
Response.Write "<TR><TD Align=center><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=""2"">In order to qualify for reduced member ticket pricing,<BR>please enter your membership number below.<BR><BR></FONT><INPUT TYPE=""text"" NAME=""MemberNumber"" VALUE=""" & Clean(Request("MemberNumber")) & """ SIZE=""40"" onFocus=""Member[1].checked = true;""></FONT></TD></TR>" & vbCrLf

If Message <> "" Then 'Display Error Message
	Response.Write "<TR BGCOLOR=""" & FontColor & """><TD ALIGN=""center"" COLSPAN=""2""><FONT FACE=""" & FontFace & """ COLOR=""" &  BGColor & """ SIZE=""2""><B>" & Message & "</FONT></TD></TR>" & vbCrLf
End If

Response.Write "</TABLE><BR>" & vbCrLf
	
If Session("UserNumber") = "" Then
Response.Write "<INPUT TYPE=""button"" VALUE=""<<&nbsp;&nbsp;Back"" onclick=""location.href='/ShoppingCart.asp';"" ID=1 NAME=1 STYLE=""width: 100px"">" & vbCrLf
Else
Response.Write "<INPUT TYPE=""button"" VALUE=""<<&nbsp;&nbsp;Back"" onclick=""location.href='/Management/ShoppingCart.asp';"" id=1 name=1  STYLE=""width: 100px"">" & vbCrLf
End If


Response.Write "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<INPUT TYPE=submit VALUE=""Continue&nbsp;&nbsp;>>"" id=submit1 name=submit1 STYLE=""width: 100px""></FORM><BR><BR>" & vbCrLf	



%>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%

Else

	'Determine number of tickets from VIP event on the order
    SQLCount = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND EventCode = " & VIPEventCode & ""
    Set rsCount = OBJdbConnection.Execute(SQLCount)
    NbrTickets = rsCount("TicketCount")
    rsCount.Close
    Set rsCount = nothing


    If NbrTickets >= 1 Then
        Call VIPSurveyForm
    Else
	    Call Continue
    End If
	
End If

End Sub 'MemberNumberForm
'==============================

Sub ValidateMember(MemberNumber)


If Not IsNumeric(MemberNumber) Then
		Call MemberNumberForm("Invalid Member Number")
		
ElseIf Len(MemberNumber) <> 6 Then
		Call MemberNumberForm("Invalid Member Number")

Else
		Call RecordNumber(MemberNumber)	

End If


End Sub 'ValidateMember	
'==============================

Sub WarningPage(MemberCount,MemberName)


Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & Title & "</TITLE>" & vbCrLf
Response.Write "</HEAD>" & vbCrLf

Response.Write "<BODY BGCOLOR=" & BGColor & " LINK="& LinkColor & " ALINK=" & ALinkColor & " VLINK=" & VLinkColor & " leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0 " & BodyParameters & ">" & vbCrLf
					
%>

<!--#INCLUDE virtual="/TopNavInclude.asp"-->

<%

Response.Write "<BR><BR><FONT FACE=" & FontFace & " COLOR=" &  HeadingFontColor & " SIZE=4><B>NOTICE</FONT>" & vbCrLf
Response.Write "<CENTER><TABLE><TR><TD Align=center><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=""2"">No more than " & MaxTickets & " " & MemberName & " tickets per member may be purchased.<BR><BR></FONT>" & vbCrLf
Response.Write "<FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=""2"">You currently have " & MemberCount & " " & MemberName & " tickets in your order.<BR><BR></FONT>" & vbCrLf
Response.Write "<FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=""2"">Please click on ""Back to Shopping"" and reduce the number of tickets in your order.</FONT>" & vbCrLf

If Session("UserNumber") = "" Then
	Response.Write "<FORM ACTION=""/ShoppingCart.asp"" METHOD=""POST"" id=form1 name=form1>" & vbCrLf
Else
	Response.Write "<FORM ACTION=""/Management/ShoppingCart.asp"" METHOD=""POST"" id=form1 name=form1>" & vbCrLf
End If

Response.Write "<INPUT TYPE=""submit"" VALUE=""Back To Shopping"" id=1 name=1></FORM></CENTER></TD></TR></TABLE></CENTER><BR><BR>" & vbCrLf



%>

<!--#INCLUDE virtual="/FooterInclude.asp"-->

<%	

Response.Write "</BODY>" & vbCrLf
Response.Write "</HTML>" & vbCrLf

		
End Sub 'Warning Page
'==============================

Sub RecordNumber(MemberNumber)	
	
		'Record MemberNumber in SurveyAnswers
		SQLInsertSurvey = "INSERT SurveyAnswers(SurveyNumber, OrderNumber, CustomerNumber, SurveyDate, AnswerNumber, Answer, Question) VALUES(" & SurveyNumber & ", " & Session("OrderNumber") & ", " & Session("CustomerNumber") & ", '" & Now() & "', 1, '" & MemberNumber & "', 'MembershipNumber')"
		Set rsInsertSurvey = OBJdbConnection.Execute(SQLInsertSurvey)
		
		'Determine number of tickets from VIP event on the order
        SQLCount = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND EventCode = " & VIPEventCode & ""
        Set rsCount = OBJdbConnection.Execute(SQLCount)
        NbrTickets = rsCount("TicketCount")
        rsCount.Close
        Set rsCount = nothing


        If NbrTickets >= 1 Then
	        Call VIPSurveyForm
        Else
		    Call Continue
        End If

End Sub 'RecordNumber
'==============================

Sub VIPSurveyForm

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & Title & "</TITLE>" & vbCrLf
Response.Write "</HEAD>" & vbCrLf
Response.Write strBody & vbCrLf
%>

<!--#INCLUDE virtual="/TopNavInclude.asp"-->

<BR>
<BR>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" ><H3>Help us serve you better by<BR>answering the two questions below</H3></FONT>

<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey">
<INPUT TYPE="hidden" NAME="FormName" VALUE="UpdateVIPSurveyAnswer">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">

<TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0" WIDTH="100%">
  <TR>
		<TD VALIGN="top" ALIGN="center" WIDTH="40%">
				<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">
				<B>Please select your VIP seating status:</B><BR>
				<INPUT TYPE="radio" NAME="Answer2" VALUE="VIP">&nbsp;VIP&nbsp;&nbsp;<INPUT TYPE="radio" NAME="Answer2" VALUE="AIC">&nbsp;AIC&nbsp;&nbsp;<INPUT TYPE="radio" NAME="Answer2" VALUE="Presidents Council">&nbsp;Presidents Council
				<BR>
				<BR>
				<BR>
				<B>Any Special Seating Requests?</B>
				<BR>
				<INPUT TYPE="text" NAME="Answer3" SIZE=40>
				<BR>
				<BR>
				<BR>
				<BR>
				<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">Thank You for your time!</FONT><BR><BR><BR>
				<INPUT TYPE="submit" VALUE="Continue" id=submit2 name=submit2></FORM>
		</TD>
  </TR>
</TABLE>
</CENTER>

<!--#INCLUDE virtual="/FooterInclude.asp"-->

</BODY>
</HTML>

<%
End Sub ' SurveyForm
'==============================

Sub UpdateVIPSurveyAnswer

    If Session("OrderNumber") <> "" Then

	    For AnswerNumber = 2 To 3
		    If Clean(Request("Answer" & AnswerNumber)) <> "" Then
				    For Each Item IN Request("Answer" & AnswerNumber)
					    If Item <> "" Then
						    SQLUpdateSurvey = "INSERT SurveyAnswers(SurveyNumber, OrderNumber, CustomerNumber, SurveyDate, AnswerNumber, Answer, Question) VALUES(" & Clean(Request("SurveyNumber")) & ", " & Session("OrderNumber") & ", " & Session("CustomerNumber") & ", '" & Now() & "', " & AnswerNumber & ", '" & Clean(Item) & "', '" & Question(AnswerNumber) & "')"
						    Set rsUpdateSurvey = OBJdbConnection.Execute(SQLUpdateSurvey)
					    End If
				    Next
		    End If
	    Next
    		
    End If

	Call Continue
		

End Sub 'Update VIPSurveyAnswer

'==============================

Sub Continue

If Session("UserNumber") = "" Then
	Session("SurveyComplete") = Session("OrderNumber")
	Response.Redirect("/Ship.asp")
Else
	Session("SurveyComplete") = Session("OrderNumber")
	Response.Redirect("/Management/AdvanceShip.asp")
End If

End Sub 'Continue
'==============================

%>
