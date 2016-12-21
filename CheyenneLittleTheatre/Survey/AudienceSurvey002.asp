<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->

<style type="text/css" media="all">
.header {font-family: " & Font Face & "; font-color:" & HeaderFontColor & "; font-weight:bold; font-size: 14px}
.question {font-family: " & Font Face & "; font-color:" & FontColor & "; font-weight:bold; font-size: 12px}
.answer {font-family: " & Font Face & "; font-color:" & FontColor & "; font-size: 12px}
</style>

<%

'Cheyenne Little Theatre Players
'========================================
'Audience Survey (8/23/2010)

'How did you hear about us survey
'answer is required

Page = "Survey"
SurveyNumber = 835
SurveyName = "AudienceSurvey.asp"

NumQuestions = 1
Dim Question(1)
Question(1) = "How did you hear about us? (check all that apply)"

NumAnswers = 10
Dim SurveyFields(1,10)
SurveyFields(1,1) = "RADIO"
SurveyFields(1,2) = "TELEVISION"
SurveyFields(1,3) = "PRINT AD"
SurveyFields(1,4) = "INTERNET"
SurveyFields(1,5) = "POSTER"
SurveyFields(1,6) = "MARQUEE"
SurveyFields(1,7) = "WORD OF MOUTH"
SurveyFields(1,8) = "CAST/CREW"
SurveyFields(1,9) = "OTHER"
SurveyFields(1,10) = "SEASON MEMBER"

'========================================


'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If

If Clean(Request("FormName")) <> "SurveyForm" Then
	Call SurveyForm
Else
	Call UpdateSurveyAnswer
End If

OBJdbConnection.Close
Set OBJdbConnection = nothing

'========================

Sub SurveyForm

'Organization Name
SQLOrgName = "SELECT Organization FROM Organization (NOLOCK) WHERE OrganizationNumber = 2438"
Set rsOrgName = OBJdbConnection.Execute(SQLOrgName)
OrgName = rsOrgName("Organization")
rsOrgName.Close
Set rsOrgName = nothing

If DocType <> "" Then
	Response.Write DocType
Else
	Response.Write "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
End If

%>

<html>
<head>
<title><%= Title %></title>

<SCRIPT language="JavaScript">

<!-- Hide code from non-js browsers

function ValidateForm(SurveyForm)
{
var filledIn = false;    

    // Use the length property to iterate through each Checkbox
    // to determine if a selection has been made
       for (var counter=0; counter<SurveyForm.Answer1.length; counter++)
       if (SurveyForm.Answer1[counter].checked == true){
       filledIn = true;
       
       //else{
       if (SurveyForm.Answer1.checked == true){
       filledIn = true;
       }
      // }
    }

       if (filledIn == false){
       alert('Please select at least one answer');
       return(false);
    }  

 return(true);
}

// end hiding -->

</script>


</head>

<%=strBody %>

<!--#INCLUDE virtual="TopNavInclude.asp"-->
<BR>
<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey" onSubmit='return ValidateForm(this)'>
<INPUT TYPE="hidden" NAME="FormName" VALUE="SurveyForm">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">

<table width="90%" cellpadding="5" cellspacing="0" border="0">
<tr bgcolor="<%=TableCategoryBGColor%>">
    <td colspan="4">
        <FONT FACE="<%= FontFace %>" COLOR="<%=TableCategoryFontColor%>" SIZE="4">  
        <b><%= OrgName %></b><br />
        Brief Audience Survey</FONT><BR>
       <FONT FACE="<%= FontFace %>" COLOR="<%=TableCategoryFontColor%>" SIZE="2">Please take a moment to answer the following question:<BR></FONT>
    </td>
    </tr>
    <tr>
        <td colspan="4"><HR /></td>
    </tr>
    <tr>
        <td align="left">
            <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">
            <b>How did you hear about us?</b><br />(check all that apply)
            </FONT>
        </td>
	    <td>&nbsp;&nbsp;&nbsp;</td>
	    <td class=answer align="left">	    							
		    <INPUT TYPE="checkbox" NAME="Answer1" VALUE="<%= SurveyFields(1, 1) %>">&nbsp;<%= SurveyFields(1, 1) %><BR>
	        <INPUT TYPE="checkbox" NAME="Answer1" VALUE="<%= SurveyFields(1, 2) %>">&nbsp;<%= SurveyFields(1, 2) %><BR>
	        <INPUT TYPE="checkbox" NAME="Answer1" VALUE="<%= SurveyFields(1, 3) %>">&nbsp;<%= SurveyFields(1, 3) %><BR>						
	        <INPUT TYPE="checkbox" NAME="Answer1" VALUE="<%= SurveyFields(1, 4) %>">&nbsp;<%= SurveyFields(1, 4) %><BR>
	        <INPUT TYPE="checkbox" NAME="Answer1" VALUE="<%= SurveyFields(1, 5) %>">&nbsp;<%= SurveyFields(1, 5) %><BR>
	        <INPUT TYPE="checkbox" NAME="Answer1" VALUE="<%= SurveyFields(1, 6) %>">&nbsp;<%= SurveyFields(1, 6) %><BR>							
	        <INPUT TYPE="checkbox" NAME="Answer1" VALUE="<%= SurveyFields(1, 7) %>">&nbsp;<%= SurveyFields(1, 7) %><BR>								
	        <INPUT TYPE="checkbox" NAME="Answer1" VALUE="<%= SurveyFields(1, 8) %>">&nbsp;<%= SurveyFields(1, 8) %><BR>
	        <INPUT TYPE="checkbox" NAME="Answer1" VALUE="<%= SurveyFields(1, 9) %>">&nbsp;<%= SurveyFields(1, 9) %> &nbsp;(please specify):&nbsp;<INPUT TYPE="text" NAME="Answer1" SIZE="20"><BR>
		    <INPUT TYPE="checkbox" NAME="Answer1" VALUE="<%= SurveyFields(1, 10) %>">&nbsp;<%= SurveyFields(1, 10) %> 
		     </FONT>
	    </td>
    </tr>
    <tr>
        <td colspan="4"><HR /></td>
    </tr>
</table>
    
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><BR><B>Thank You for your time!</B></FONT><BR><BR><BR>

<INPUT TYPE="submit" VALUE="Continue"></FORM>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%
End Sub ' SurveyForm

'===========================

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

'===========================

%>


