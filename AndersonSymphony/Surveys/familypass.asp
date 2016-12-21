<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%


'This survey is designed to prevent single ticket sales of the FamilyPass ticket. 
'FamilyPass tickets must be purchased in multiples of 4

'Initialize Survey Parameters
Page = "Survey"
SurveyNumber = 684
SurveyName = "FamilyPass.asp"

'Set Survey Variables
MemberName = "Family Pass"
MemberList = "1061" 'List of Member Seat Type Codes
MemberQty = 4 'Tickets must be purchased in this quantity


'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If


If Clean(Request("FormName")) <> "SurveyForm" Then
	Call SeatTypeCount
Else
	Call SeatTypeCount
End If


OBJdbConnection.Close
Set OBJdbConnection = nothing

'Check to see if this is a Phone (2), Fax (3), Mail (4), Comp (5), Box Office (7). If so, bypass the restriction.
'If Session("OrderTypeNumber") = 2 Or Session("OrderTypeNumber") = 3 Or Session("OrderTypeNumber") = 4 Or Session("OrderTypeNumber") = 5  Or Session("OrderTypeNumber") = 7
	'Call Continue
'End If


'==============================
Sub SeatTypeCount

'Count number of member tickets
SQLMemberCount = "SELECT COUNT(ItemNumber) AS TicketCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber")& " AND OrderLine.SeatTypeCode IN (" & MemberList & ")"
Set rsMemberCount = OBJdbConnection.Execute(SQLMemberCount)
MemberCount = rsMemberCount("TicketCount")
rsMemberCount.Close
Set rsMemberCount = nothing


If MemberCount = 0 Or MemberCount = 4 Or MemberCount = 8 Or MemberCount = 12 Then
    Call Continue
Else
    Call WarningPage(MemberCount, MemberName, MemberQty)
End If

End Sub 'SeatTypeCount

'==============================

Sub WarningPage(MemberCount, MemberName, MemberQty)

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & Title & "</TITLE>" & vbCrLf
Response.Write "</HEAD>" & vbCrLf

Response.Write "<BODY BGCOLOR=" & BGColor & " LINK="& LinkColor & " ALINK=" & ALinkColor & " VLINK=" & VLinkColor & " leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0 " & BodyParameters & ">" & vbCrLf
					
%>

<!--#INCLUDE virtual="/TopNavInclude.asp"-->


<%

Response.Write "<BR><BR><FONT FACE=" & FontFace & " COLOR=" &  HeadingFontColor & " SIZE=4><B>NOTICE</FONT>" & vbCrLf
Response.Write "<CENTER><TABLE><TR><TD Align=center><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=""2"">" & MemberName & " tickets must be purchased in multiples of " & MemberQty & "<BR><BR></FONT>" & vbCrLf
'Response.Write "<FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=""2"">You currently have " & MemberCount & "&nbsp;" & MemberName & " ticket(s) in your order.<BR><BR></FONT>" & vbCrLf
Response.Write "<FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=""2"">Please click on ""Back to Shopping"" and change the number of tickets in your order.</FONT>" & vbCrLf

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
Sub Continue

	If Session("UserNumber") = "" Then
		'REE 4/19/3 - Modified to use Session Variable for SurveyComplete
		Session("SurveyComplete") = Session("OrderNumber")
		Response.Redirect("/Ship.asp")
	Else
		'REE 4/19/3 - Modified to use Session Variable for SurveyComplete
		Session("SurveyComplete") = Session("OrderNumber")
		Response.Redirect("/Management/AdvanceShip.asp")
	End If



End Sub 'Continue
'==============================

%>
