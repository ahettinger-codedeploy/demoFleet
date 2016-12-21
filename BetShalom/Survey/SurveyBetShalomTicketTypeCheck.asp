<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%
Page = "Survey"
SurveyNumber = 713

If Clean(Request("FormName")) = "MemberConfirmation" Then
	Call MemberResponse
End If

Call MemberCheck

'====================================

Sub MemberCheck

'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If


'Check for a Member Ticket Type on this order.  If it exists, Display Member Confirmation message.
			
SQLMember = "SELECT OrderLine.ItemNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.SeatTypeCode IN (3934,3935)"
'SQLMember = "SELECT OrderLine.ItemNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.SeatTypeCode = 717"
Set rsMember = OBJdbConnection.Execute(SQLMember)
			
If Not rsMember.EOF Then 'There's a member ticket on this order.
			
	Call MemberConfirmationMessage
				
Else

	Call Continue

End If
		
rsMember.Close
Set rsMember = nothing
		
End Sub 'MemberCheck
				
'====================================

Sub MemberConfirmationMessage

If FontFace = "" Then
	FontFace = "verdana,arial,helvetica"
End If

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & Title & "</TITLE>" & vbCrLf
%>

 <SCRIPT LANGUAGE="JavaScript">    

 <!-- Hide code from non-js browsers

function validateForm() {
     formObj = document.MemberConfirmation;
 	var yes = 0;
 	var no = 0;

 	for (var i=0;i<2;i++) {
 	    if (eval("formObj.Response[i].checked") == true)
 	        yes++;
 		}
 	if (yes == 0) {
 		alert("Please enter a response.");
 		return false;
 		}
 	}

 // end hiding -->
 </SCRIPT>

<%
Response.Write "</HEAD>" & vbCrLf

Response.Write "<BODY BGCOLOR=" & BGColor & " LINK="& LinkColor & " ALINK=" & ALinkColor & " VLINK=" & VLinkColor & " leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0 " & BodyParameters & ">" & vbCrLf
					
%>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<BR>
<BR>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3>Member Confirmation</H3></FONT>

<%
Response.Write "<TABLE><TR><TD><FONT FACE=""" & FontFace & """ SIZE=""2"">You must be a Bet Shalom or Minnesota Public Radio member to purchase at this discounted price.  Please acknowledge your membership by checking the box below.  Membership will be verified by Bet Shalom and if no membership exists, you will be charged the normal ticket price.</TD></TR></TABLE><BR><BR>" & vbCrLf
Response.Write "<FORM ACTION=""/SurveyBetShalomTicketTypeCheck.asp"" METHOD=""post"" onSubmit='return validateForm()' NAME=""MemberConfirmation""><INPUT TYPE=""hidden"" NAME=""FormName"" VALUE=""MemberConfirmation""><TABLE><TR><TD><INPUT TYPE=""radio"" NAME=""Response"" VALUE=""Yes""></TD><TD><FONT FACE=""" & FontFace & """ SIZE=""2"">I am a Minnesota Public Redio Member or Bet Shalom Member</FONT><TD></TR><TR><TD><INPUT TYPE=""radio"" NAME=""Response"" VALUE=""No""></TD><TD><FONT FACE=""" & FontFace & """ SIZE=""2"">I am not a member.  Please cancel my order.</FONT></TD></TR></TABLE><BR><INPUT TYPE=""submit"" VALUE=""Submit"" id=1 name=1></FORM><BR><BR>" & vbCrLf

%>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%			
End Sub 'MemberConfirmationMessage

'====================================

Sub MemberResponse

	'Add Survey Answer
	SQLOrder = "SELECT OrderNumber, CustomerNumber FROM OrderHeader (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber")
	Set rsOrder = OBJdbConnection.Execute(SQLOrder)

	If Not rsOrder.EOF Then
	
		SQLInsertAnswer = "INSERT SurveyAnswers(SurveyNumber, OrderNumber, CustomerNumber, SurveyDate, AnswerNumber, Question, Answer) VALUES(" & SurveyNumber & ", " & rsOrder("OrderNumber") & ", " & Session("CustomerNumber") & ", '" & Now() & "', 1, 'Member Confirmation', '" & Clean(Request("Response")) & "')"
		Set rsInsertAnswer = OBJdbConnection.Execute(SQLInsertAnswer)
	
		If Clean(Request("Response")) = "Yes" Then 'Agreed. Continue.
		
			Call Continue
			
		ElseIf Clean(Request("Response")) = "No" Then 'Cancel Order

			'Delete OrderLines
			SQLDeleteOrderLines = "DELETE OrderLine WHERE OrderNumber = " & Session("OrderNumber")
			Set rsDeleteOrderLines = OBJdbConnection.Execute(SQLDeleteOrderLines)
			
			'Update Seat Status, OrderNumber on Seat
			SQLUpdateSeats = "UPDATE Seat WITH (ROWLOCK) SET StatusCode = 'A', OrderNumber = 0 WHERE OrderNumber = " & Session("OrderNumber")
			Set rsUpdateSeats = OBJdbConnection.Execute(SQLUpdateSeats)
			
			'Redirect to Default	
			If Session("UserNumber") = "" Then
				Response.Redirect("/Default.asp")
			Else
				Response.Redirect("/Management/EventSelection.asp")
			End If
			
		Else 'No Response.  Redisplay Disclaimer.
		
			Call MemberConfirmationMessage

		End If
	
	Else
	
		If Session("UserNumber") = "" Then
			Response.Redirect("/Default.asp")
		Else
			Response.Redirect("/Management/Default.asp")
		End If
	
	End If
	
End Sub 'TermsResponse

'====================================

Sub Continue

If Session("UserNumber") = "" Then
	'REE 4/19/3 - Modified to use Session Variable for SurveyComplete
	Session("SurveyComplete") = Session("OrderNumber")
	Response.Redirect("Ship.asp")
Else
	'REE 4/19/3 - Modified to use Session Variable for SurveyComplete
	Session("SurveyComplete") = Session("OrderNumber")
	Response.Redirect("/Management/AdvanceShip.asp")
End If

End Sub 'Continue


%>




