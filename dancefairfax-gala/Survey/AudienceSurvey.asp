<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<!--#INCLUDE VIRTUAL="CalcCustomerFeeInclude.asp"-->
<%

Page = "Survey"
SurveyNumber = 914
SurveyName = "AudienceSurvey.asp"

'========================================
'Fairfax County Dance Coalition (12/10/2010)
'Audience Survey

FormName = "Brief Audience Survey"

NumQuestions = 2
Dim Question(2)
Question(1) = "Affiliated with:"
Question(2) = "Other:"

Dim QuestionField(1)
QuestionField(1) = "Please indicate if you are affiliated with any of the following Fairfax County Dance organizations. If none, please mark None."

Dim AnswerField(11)
AnswerField(1) = "BalletNova"
AnswerField(2) = "Ballet Arts Ensemble of Fairfax"
AnswerField(3) = "Center Stage Dance Company"
AnswerField(4) = "Classical Ballet Theatre"
AnswerField(5) = "Dancin Unlimited Jazz Dance Company"
AnswerField(6) = "Encore Theatrical Arts Project"
AnswerField(7) = "Impact Youth Dance Company"
AnswerField(8) = "Laysa Dance Company"
AnswerField(9) = "Virginia Ballet Company"
AnswerField(10) = "Other"
AnswerField(11) = "None"


'========================================

'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If

If Session("UserNumber")<> "" Then
TableCategoryBGColor = "#008400"
TableCategoryFontColor = "FFFFFF"
TableColumnHeadingBGColor = "99CC99"
TableColumnHeadingFontColor = "000000"
TableDataBGColor = "E9E9E9"
End If

If Clean(Request("FormName")) <> "SurveyForm" Then
	Call SurveyForm
Else
	Call UpdateSurveyAnswer
End If

'========================================

Sub SurveyForm

If DocType <> "" Then
	Response.Write DocType
Else
	Response.Write "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
End If

%>

<html>
<head>
<title><%= title %></title>

<script Language="JavaScript">
<!--
function radio_button_checker()
{
// set var radio_choice to false
var radio_choice = false;

// Loop from zero to the one minus the number of radio button selections
for (counter = 0;  counter < Survey.Answer1.length; counter++)
{
// If a radio button has been selected it will return true
// (If not it will return false)
if (Survey.Answer1[counter].checked)
radio_choice = true; 
}

if (!radio_choice)
{
// If there were no selections made display an alert box 
alert("Please indicate if you are affiliated with any of the listed Fairfax County Dance organizations.  If none, please mark None.")
return (false);
}
return (true);
}

-->
</script>

<script language="JavaScript">
function setVisibility(id, visibility) {
document.getElementById(id).style.display = visibility;
}

</script>

<head>

</head>

<%= strBody %>

<!--#include virtual="TopNavInclude.asp"-->

<FORM ACTION="<%= SurveyName %>" name="Survey" METHOD="post" onsubmit="return radio_button_checker()">
<INPUT TYPE="hidden" NAME="FormName" VALUE="SurveyForm">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">

<table id="tix-table" width="600" cellpadding="10" cellspacing="10">
<tr bgcolor="<%=TableCategoryBGColor%>">
    <td>
        <FONT FACE="<%= FontFace %>" COLOR="<%=TableCategoryFontColor%>" SIZE="4">
        <b><%= FormName %></b></FONT>
    </td>
</tr> 
<tr bgcolor="<%=TableDataBGColor%>">
    <td align="left">  
    <FONT FACE="<%= FontFace %>" SIZE="2">   
    <%=QuestionField(1)%><br />
    <br />
    <INPUT TYPE="radio" NAME="Answer1" VALUE="<%=AnswerField(1)%>"  onclick="setVisibility('other','none');";>&nbsp;<%=AnswerField(1)%><br />
    <INPUT TYPE="radio" NAME="Answer1" VALUE="<%=AnswerField(2)%>"  onclick="setVisibility('other','none');";>&nbsp;<%=AnswerField(2)%><br />
    <INPUT TYPE="radio" NAME="Answer1" VALUE="<%=AnswerField(3)%>"  onclick="setVisibility('other','none');";>&nbsp;<%=AnswerField(3)%><br />
    <INPUT TYPE="radio" NAME="Answer1" VALUE="<%=AnswerField(4)%>"  onclick="setVisibility('other','none');";>&nbsp;<%=AnswerField(4)%><br />
    <INPUT TYPE="radio" NAME="Answer1" VALUE="<%=AnswerField(5)%>"  onclick="setVisibility('other','none');";>&nbsp;<%=AnswerField(5)%><br />
    <INPUT TYPE="radio" NAME="Answer1" VALUE="<%=AnswerField(6)%>"  onclick="setVisibility('other','none');";>&nbsp;<%=AnswerField(6)%><br />
    <INPUT TYPE="radio" NAME="Answer1" VALUE="<%=AnswerField(7)%>"  onclick="setVisibility('other','none');";>&nbsp;<%=AnswerField(7)%><br />
    <INPUT TYPE="radio" NAME="Answer1" VALUE="<%=AnswerField(8)%>"  onclick="setVisibility('other','none');";>&nbsp;<%=AnswerField(8)%><br />
    <INPUT TYPE="radio" NAME="Answer1" VALUE="<%=AnswerField(9)%>"  onclick="setVisibility('other','none');";>&nbsp;<%=AnswerField(9)%><br />
    <input type=radio   name="Answer1" value="<%=AnswerField(10)%>" onclick="setVisibility('other','inline');";>&nbsp;Other&nbsp;&nbsp;&nbsp;<span style="display: none;" id="other">Please Specify:<INPUT TYPE="text" NAME="Answer2" size="23"></span><br />    
    <INPUT TYPE="radio" NAME="Answer1" VALUE="<%=AnswerField(11)%>" onclick="setVisibility('other','none');";>&nbsp;<%=AnswerField(11)%><br />
    </td>
</tr>
 <tr>
    <td align="center">            
        <FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2">Thank you for your response!</FONT><BR><BR><BR>
        <INPUT TYPE="submit" VALUE="Continue"></FORM>
    </td>
</tr>
</table>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>
</html>

<%		
	
End Sub 'Warning Page

'========================================

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

'========================================

%> 
