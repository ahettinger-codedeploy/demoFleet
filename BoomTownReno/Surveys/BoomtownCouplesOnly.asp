<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%
Page = "Survey"

SurveyNumber = 748
SurveyName = "BoomtownCouplesOnly.asp"
NumQuestions = 1

Dim Question(2)

Question(1) = "By checking this box, I acknowledge that admission is only allowed to those 21 and older and that all purchases are final.<BR><I>Management reserves all rights.</I>"

'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If


If Clean(Request("FormName")) <> "AcknowledgePage" Then
	Call CouplesOnly
Else
	Call UpdateSurveyAnswer
End If


OBJdbConnection.Close
Set OBJdbConnection = nothing

'----------------------------

Sub CouplesOnly

SQLTicketCount = "SELECT Event.EventCode, EventDate, Act, COUNT(LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Section ON Seat.SectionCode = Section.SectionCode AND Seat.EventCode = Section.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Event.SurveyNumber = " & SurveyNumber & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') GROUP BY Event.EventCode, EventDate, Act ORDER BY Event.EventCode, EventDate"
Set rsTicketCount = OBJdbConnection.Execute(SQLTicketCount)
			
OddOrder = FALSE
	
Do Until rsTicketCount.EOF
	
    Remainder = rsTicketCount("TicketCount") Mod 2

	If Remainder <> 0 Then
			OddOrder = TRUE
			Message = Message & "<B>" & rsTicketCount("Act") & " on " & FormatDateTime(rsTicketCount("EventDate"), VBLongDate) & " at " & Left(FormatDateTime(rsTicketCount("EventDate"), vbLongTime), Len(FormatDateTime(rsTicketCount("EventDate"), vbLongTime))-6) & " " & Right(FormatDateTime(rsTicketCount("EventDate"),vbLongTime), 2) & "</B><BR>"
	End If
		
	rsTicketCount.MoveNext
		
	Loop
	
	rsTicketCount.Close
	Set rsTicketCount = nothing

	If OddOrder Then						
		Call WarningPage						
	Else						
        Call AcknowledgePage			
	End If
	
						
End Sub ' Couples Only
'----------------------------

Sub WarningPage

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & Title & "</TITLE>" & vbCrLf
Response.Write "</HEAD>" & vbCrLf

Response.Write "<BODY BGCOLOR=" & BGColor & " LINK="& LinkColor & " ALINK=" & ALinkColor & " VLINK=" & VLinkColor & " leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0 " & BodyParameters & ">" & vbCrLf
					
%>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<BR>
<BR>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3>Please Note:</H3></FONT>

<%
Response.Write "<TABLE WIDTH=""80%""><TR><TD><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=2>Package tickets must be purchased in sets of 2.  In order to complete your purchase, please click on ""Shopping Cart"" to add or remove the appropriate number of tickets.</FONT><BR><BR><BR>" & vbCrLf
If Session("UserNumber") = "" Then
	Response.Write "<CENTER><FORM ACTION=""/ShoppingCart.asp"" METHOD=""POST""><INPUT TYPE=""submit"" VALUE=""Shopping Cart""></FORM>" & vbCrLf
Else
	Response.Write "<CENTER><FORM ACTION=""/Management/ShoppingCart.asp"" METHOD=""POST""><INPUT TYPE=""submit"" VALUE=""Shopping Cart""></FORM>" & vbCrLf
End If
Response.Write "</CENTER></TD></TR></TABLE><BR><BR>" & vbCrLf
%>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%			
End Sub 'Warning Page

'----------------------------

Sub AcknowledgePage

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3c.org/TR/1999/REC-html401-19991224/loose.dtd">
<HTML>
<HEAD>
<TITLE><%= Title %></TITLE>

 <SCRIPT LANGUAGE="JavaScript">    

 <!-- Hide code from non-js browsers

function validateForm() {
     formObj = document.Survey;
 	var yes = 0;
 	var no = 0;

    if (eval("formObj.Answer1.checked") != true){
 		alert("You must check the box acknowledging the terms before proceeding.");
 		return false;
 		}
 	}

 // end hiding -->
 </SCRIPT>
</HEAD>

<%

Response.Write "<BODY BGCOLOR=" & BGColor & " LINK="& LinkColor & " ALINK=" & ALinkColor & " VLINK=" & VLinkColor & " leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0 " & BodyParameters & ">" & vbCrLf

%>					

<!--#INCLUDE virtual="TopNavInclude.asp"-->
<BR>
<BR>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3>Important - Please Read</H3></FONT>
<BR>
<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey" onSubmit='return validateForm()'>
<INPUT TYPE="hidden" NAME="FormName" VALUE="AcknowledgePage">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">

<TABLE WIDTH="70%">
    <TR ALIGN="center">
		<TD>
		    <!--<img src="/clients/boomtownreno/surveys/images/over21.png" />-->
			<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><%= Question(1) %>&nbsp;&nbsp;&nbsp;<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Accept">&nbsp;</FONT><BR><BR><BR>
		</TD>
  </TR>
</TABLE>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="3"><B>Thank You!</B></FONT><BR><BR><BR>

<INPUT TYPE="submit" VALUE="Continue"></FORM>
</CENTER>

<!--#INCLUDE virtual="FooterInclude.asp"-->
</BODY>
</HTML>

<%

End Sub ' AcknowledgePage

'----------------------------

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

