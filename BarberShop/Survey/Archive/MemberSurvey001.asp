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
MemberList = "3442" 'List of Member Seat Type Codes
SeatTypeCode = (Clean(Request("SeatTypeCode")))


'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	OBJdbConnection.Close
	Set OBJdbConnection = nothing
	Response.Redirect("/Default.asp")
End If

'Count number of member tickets
SQLMemberCount = "SELECT COUNT(ItemNumber) AS TicketCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber")	& " AND OrderLine.SeatTypeCode IN (" & MemberList & ")"
Set rsMemberCount = OBJdbConnection.Execute(SQLMemberCount)
MemberCount = rsMemberCount("TicketCount")
rsMemberCount.Close
Set rsMemberCount = nothing


If MemberCount > 2 Then
	Call WarningPage(MemberCount)

Else If MemberCount <= 2 
	Call MemberNumberForm(Message)

Else 
	Call Continue
	
End If

'==============================

Sub MemberNumberForm(Message)

'Check for existing survey entry for this order
SQLSurveyAnswers = "SELECT Answer FROM SurveyAnswers(NOLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND SurveyNumber = 616 AND Question = 'Member Number'"
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
Response.Write "<FONT FACE=" & FontFace & " COLOR=" &  HeadingFontColor & " SIZE=4><B>Enter Your Membership Number</B></FONT><BR><BR>" & vbCrLf
Response.Write "<TABLE>" & vbCrLf
Response.Write "<TR><TD><FONT FACE=" & FontFace & " COLOR=" &  FontColor & " SIZE=2>Members, Associates & Affiliates may purchase up to two registrations at the “member price” per member number entered.</FONT>
Response.Write "<INPUT TYPE=""text"" NAME=""MemberNumber"" VALUE=""" & Clean(Request("MemberNumber")) & """ SIZE=""20"" onFocus=""Member[1].checked = true;""></TD></TR>" & vbCrLf
Response.Write "</TABLE><BR>" & vbCrLf
	
If Session("UserNumber") = "" Then
Response.Write "<INPUT TYPE=""button"" VALUE=""Back"" onclick=""location.href='/ShoppingCart.asp';"" id=1 name=1>" & vbCrLf
Else
Response.Write "<INPUT TYPE=""button"" VALUE=""Back"" onclick=""location.href='/Management/ShoppingCart.asp';"" id=1 name=1>" & vbCrLf
End If
Response.Write "<INPUT TYPE=submit VALUE=""Continue"" id=submit1 name=submit1></FORM><BR><BR>" & vbCrLf	



	%>

	<!--#INCLUDE virtual="FooterInclude.asp"-->

	</BODY>
	</HTML>

<%

Else

	Call Continue
	
End If

End Sub 'MemberNumberForm	

'==============================
Sub ValidateMember(MemberNumber)


	If Not IsNumeric(MemberNumber) And Len(MemberNumber) <> 6 Then
		Call MemberNumberForm("Invalid Member Number")
	End If

End Sub 'ValidateMember	

'==============================
Sub RecordNumber(MemberNumber)	
	
		'Record MemberNumber in SurveyAnswers
		SQLInsertSurvey = "INSERT SurveyAnswers(SurveyNumber, OrderNumber, CustomerNumber, SurveyDate, AnswerNumber, Answer, Question) VALUES(" & SurveyNumber & ", " & Session("OrderNumber") & ", " & Session("CustomerNumber") & ", '" & Now() & "', 1, '" & MemberNumber & "')"
		Set rsInsertSurvey = OBJdbConnection.Execute(SQLInsertSurvey)
	
		Call Continue


End Sub 'RecordNumber

'==============================
Sub WarningPage(ActCount, SeriesCount)

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & Title & "</TITLE>" & vbCrLf
Response.Write "</HEAD>" & vbCrLf

Response.Write "<BODY BGCOLOR=" & BGColor & " LINK="& LinkColor & " ALINK=" & ALinkColor & " VLINK=" & VLinkColor & " leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0 " & BodyParameters & ">" & vbCrLf
					
%>

<!--#INCLUDE virtual="/TopNavInclude.asp"-->

<%

Response.Write "<BR><BR><FONT FACE=""" & FontFace & """ COLOR=""" & HeadingFontColor & """ SIZE=""2""><H3>NOTICE</H3></FONT>" & vbCrLf

Response.Write "<CENTER><TABLE><TR><TD><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=2><CENTER><B>Members, Associates & Affiliates may purchase no more than two registrations at the “member price” per member number entered.</B><BR>You currently have more than 2 tickets in your order.<BR>Please click on ""Back to Shopping"" to reduce the number of tickets." & vbCrLf

If Session("UserNumber") = "" Then
	Response.Write "<FORM ACTION=""/ShoppingCart.asp"" METHOD=""POST"" id=form1 name=form1>" & vbCrLf
Else
	Response.Write "<FORM ACTION=""/Management/ShoppingCart.asp"" METHOD=""POST"" id=form1 name=form1>" & vbCrLf
End If

Response.Write "<INPUT TYPE=""submit"" VALUE=""&nbsp;&nbsp;&nbsp;&nbsp;OK&nbsp;&nbsp;&nbsp;&nbsp;"" id=1 name=1></FORM></CENTER></TD></TR></TABLE></CENTER><BR><BR>" & vbCrLf



%>

<!--#INCLUDE virtual="/FooterInclude.asp"-->

<%	

Response.Write "</BODY>" & vbCrLf
Response.Write "</HTML>" & vbCrLf

		
End Sub 'Warning Page
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
