<!--#INCLUDE virtual="PrivateLabelInclude.asp" -->
<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<%
Page = "Survey"

SurveyNumber = 193
SurveyName = "SurveyATCCo.asp"
NumQuestions = 2

Dim Question(3)

Question(1) = "How did you hear about African Continuum Theatre?"
Question(2) = "Have you ever subscribed to the African Continuum Theatre?"


'Count Subscriptions
SQLEventCount = "SELECT COUNT(ItemNumber) AS EventCount FROM Seat (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND EventCode IN (69327,69376,69377,69326,69363,69364,69365,69367,69368,69369,69370,69371,69373,69374,69375,69325)"
Set rsEventCount = OBJdbConnection.Execute(SQLEventCount)

EventCount = rsEventCount("EventCount")

rsEventCount.Close
Set rsEventCount = nothing

'Count Jitney
SQLTeaPartyCount = "SELECT COUNT(ItemNumber) AS TeaPartyCount FROM Seat (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND EventCode IN (69844)"
Set rsTeaPartyCount = OBJdbConnection.Execute(SQLTeaPartyCount)

TeaPartyCount = rsTeaPartyCount("TeaPartyCount")

rsTeaPartyCount.Close
Set rsTeaPartyCount = nothing

If EventCount > TeaPartyCount Then
	If Request("NextFormName") = "Continue" Then
		Call Continue
	Else
		Call Offer
	End If
ElseIf EventCount < TeaPartyCount Then
	Call TooMany
Else
	Call Continue
End If


Sub Offer
%>
<html>
<HEAD>
<title><%= Title %></title>

<SCRIPT LANGUAGE="JavaScript">    

<!-- Hide code from non-js browsers

function validateForm() {
	formObj = document.EventForm;
//	var yes = 0;
//	for (var i=0;i<2;i++) {
//	    if (eval("formObj.Event[i].checked") == true)
//	        yes++;
//		}
//	if (yes == 0) {
//		alert("Please select an option.");
//		return false;
//		}
  if (formObj.SeatCount.value == "") {
      alert("Please enter the number of tickets you would like to purchase.");
      formObj.SeatCount.focus();
      return false;
      }
	var emailReg = "\\D";
	var regex = new RegExp(emailReg);
	if (regex.test(formObj.SeatCount.value)==true){
		alert("Please enter a valid ticket quantity.")
		return false;
		}
    }    

// end hiding -->
</SCRIPT>

</HEAD>
<%= strBody %>
<center>

<!--#INCLUDE VIRTUAL="TopNavInclude.asp"-->

<br>

<%
If Session("UserNumber") = "" Then
	EventPage = "Event.asp"
Else
	EventPage = "/Management/Event.asp"
End If

SQLEventCode = "SELECT EventCode FROM Seat (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND EventCode IN (69327,69376,69377,69326,69363,69364,69365,69367,69368,69369,69370,69371,69373,69374,69375,69325)"
Set rsEventCode = OBJdbConnection.Execute(SQLEventCode)

EventCode = rsEventCode("EventCode")

rsEventCode.Close
Set rsEventCode = nothing

Select Case EventCode
	Case 69327
		TeaEventCode = 69844
	Case 69376
		TeaEventCode = 69844
	Case 69377
		TeaEventCode = 69844
	Case 69326
		TeaEventCode = 69844
	Case 69363
		TeaEventCode = 69844
	Case 69364
		TeaEventCode = 69844
	Case 69365
		TeaEventCode = 69844
	Case 69367
		TeaEventCode = 69844
	Case 69368
		TeaEventCode = 69844
	Case 69369
		TeaEventCode = 69844
	Case 69370
		TeaEventCode = 69844
	Case 69371
		TeaEventCode = 69844
	Case 69373
		TeaEventCode = 69844
	Case 69374
		TeaEventCode = 69844
	Case 69375
		TeaEventCode = 69844
	Case 69325
		TeaEventCode = 69844
End Select
	
%>

<FORM ACTION="<%= EventPage %>" METHOD="post" onSubmit='return validateForm()' Name="EventForm">
<INPUT TYPE="hidden" NAME="FormName" VALUE="EventForm">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">
<TABLE width=700>
	<TD ALIGN=CENTER>
			<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="3"><B>Please take a moment to complete our brief audience survey.</B></FONT><BR><BR>
	</TD>
	<TR ALIGN="center">
		<TD>
			<B><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><%= Question(1) %></FONT></B><BR><BR>
		</TD>
	</TR>
	<TR>
		<TD>
		<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">
			<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Newspaper">Newspaper&nbsp;&nbsp;&nbsp;Which one?&nbsp;<INPUT TYPE="text" NAME="Answer1" SIZE=25><BR>
			<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Advertisement">Advertisement&nbsp;&nbsp;&nbsp;Which one?&nbsp;<INPUT TYPE="text" NAME="Answer1" SIZE=25><BR>
			<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Friend">Friend<BR>
			<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Subscriber">Subscriber<BR>
			<INPUT TYPE="checkbox" NAME="Answer1" VALUE="H Street Corridor">H Street Corridor<BR>
			<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Atlas materials">Atlas materials<BR>
			<INPUT TYPE="checkbox" NAME="Answer1" VALUE="African Continuum Theatre materials (season brochure, poster, postcard)">African Continuum Theatre materials (season brochure, poster, postcard)<BR><BR>
    </TD>
  </TR><BR>
  	<TR ALIGN="center">
		<TD>
			<B><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><%= Question(2) %></FONT></B><BR><BR>
		</TD>
	</TR>
    <TR>
		<TD>
			<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">
			<INPUT TYPE="checkbox" NAME="Answer2" VALUE="Yes">&nbsp;Yes - Thank you for your support.<BR>
			<INPUT TYPE="checkbox" NAME="Answer2" VALUE="No">&nbsp;No - Why did you choose to subscribe this year?&nbsp;<INPUT TYPE="text" NAME="Answer1" SIZE=50><BR><BR>
			</FONT>
    </TD>
  </TR>
</TABLE>
<BR>
<TABLE WIDTH="700">
	<TR>
		<TD ALIGN=CENTER>
			<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><B>Would you like to add the following event to your purchase?</B></FONT><BR><BR>
		</TD>
	</TR>
	<TR>
		<TD ALIGN=CENTER>
			<INPUT TYPE="hidden" NAME="Event" VALUE="69844">
			<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">Jitney at Ford's Theatre - $35.00</FONT>
		</TD>
	</TR>

</TABLE>
<BR>
<BR>
<TABLE WIDTH="400">
<TR><TD ALIGN="right"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">Ticket Quantity: </FONT></TD><TD ALIGN="left"><INPUT TYPE="text" NAME="SeatCount" SIZE="5"></TD></TR>

</TABLE>
<BR>
<INPUT TYPE="submit" VALUE="Add To Cart"></FORM>

<BR>
<%

'Session("SurveyComplete") = Session("OrderNumber")

If Session("UserNumber") = "" Then
	ShipPage = "Ship.asp"
Else
	ShipPage = "/Management/AdvanceShip.asp"
End If

Response.Write "<FORM ACTION=""SurveyACTCo.asp"" METHOD=""post""><INPUT TYPE=""hidden"" NAME=""NextFormName"" VALUE=""Continue""><INPUT TYPE=""submit"" VALUE=""No Thanks""></FORM>" & vbCrLf

%>

<!--#INCLUDE VIRTUAL="FooterInclude.asp"-->

</BODY>
</HTML>

<%

End Sub 'Offer

'=================================

Sub TooMany

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
Response.Write "<TABLE><TR><TD><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=2>You may not order more Jitney tickets than subscription tickets.</FONT><BR><BR>" & vbCrLf
If Session("UserNumber") = "" Then
	Response.Write "<CENTER><FORM ACTION=""ShoppingCart.asp"" METHOD=""POST""><INPUT TYPE=""submit"" VALUE=""Back to Shopping""></FORM></CENTER></TD></TR></TABLE><BR><BR>" & vbCrLf
Else
	Response.Write "<CENTER><FORM ACTION=""ShoppingCart.asp"" METHOD=""POST"" id=form1 name=form1><INPUT TYPE=""submit"" VALUE=""Back to Shopping"" id=1 name=1></FORM></CENTER></TD></TR></TABLE><BR><BR>" & vbCrLf
End If
%>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%

End Sub 'TooMany

'=================================

Sub Continue

OBJdbConnection.Close
Set OBJdbConnection = nothing

Session("SurveyComplete") = Session("OrderNumber")

If Session("OrderTypeNumber") = 1 Then
	Response.Redirect("/Ship.asp")
Else
	Response.Redirect("/Management/AdvanceShip.asp")
End If

End Sub 'Continue

%>


