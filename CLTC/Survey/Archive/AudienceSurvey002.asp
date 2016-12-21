<%

'CHANGE LOG - Inception
'SSR 6/14/2011
'Custom Survey

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->

<%

'======================================================

Page = "Survey"
SurveyNumber = 1066
SurveyFileName = "AudienceSurvey.asp"

'======================================================

'City Lights Theater Company of San Jose (7/11/2011)
'Audience Survey

FormName = "Brief Audience Survey"

NumQuestions = 2
Dim Question(2)
Question(1) = "How did you hear about this event?"
Question(2) = "Other (please specify)"

Dim AnswerField(11)
AnswerField(1) = "Postcard"
AnswerField(2) = "Know someone in the show"
AnswerField(3) = "eNewsletter"
AnswerField(4) = "Search Engine/Website"
AnswerField(5) = "cltc.org"
AnswerField(6) = "Facebook"
AnswerField(7) = "Review"
AnswerField(8) = "Patron who saw the show"
AnswerField(9) = "Our Non-Profit Partner"
AnswerField(10) = "Other"



''===============================================

'Check to see if Order Number exists.  
'If not, redirect to Home Page.


If Session("OrderNumber") = "" Then

	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
	
Else

	If Session("UserNumber") = "" Then
        Page = "Survey"
	Else
	    Page = "Management"
	End If
	
End If

'===============================================

'CSS Survey Variables

If Session("UserNumber")<> "" Then
    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "FFFFFF"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "000000"
    TableDataBGColor = "E9E9E9"
    'LastHex = box color
    'FirstHex = background color
    NECorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=008400&Src=TopLeftCorner16.txt"
    NWCorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=008400&Src=TopRightCorner16.txt"
    SWCorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=E9E9E9&Src=BottomLeftCorner16.txt"
    SECorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=E9E9E9&Src=BottomRightCorner16.txt"
Else
    'LastHex = box color
    'FirstHex = background color
    NECorner="/clients/tix/images/image.asp?FirstHex=efebe3&LastHex=565f68&Src=TopLeftCorner16.txt"
    NWCorner="/clients/tix/images/image.asp?FirstHex=efebe3&LastHex=565f68&Src=TopRightCorner16.txt"
    SWCorner="/clients/tix/images/image.asp?FirstHex=f3f1ed&LastHex=ded6c8&Src=BottomLeftCorner16.txt"
    SECorner="/clients/tix/images/image.asp?FirstHex=f3f1ed&LastHex=ded6c8&Src=BottomRightCorner16.txt"
End If

'============================================================
 
'Check to see if Order Number exists.
'Display management tabs for box office orders

If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
    Else
		Response.Redirect("/Management/Default.asp")
	End If	
Else
	If Session("UserNumber") = "" Then
        Page = "Survey"
	Else
	    Page = "Management"
	End If	
End If

'============================================================

'Request the form name and process requested action

If Clean(Request("FormName")) <> "SurveyForm" Then
	Call SurveyForm
Else
	Call UpdateSurveyAnswer
End If

'============================================================

Sub SurveyForm

If DocType <> "" Then
	Response.Write DocType
Else
	Response.Write "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
End If

%>

<html>
<head>
<title>change code</title>
<script language="javascript">
function changeCode()
{
  if(document.getElementById('Answer1').selectedIndex > 8)
  {
     document.getElementById('eucode').style.display="block";
     document.getElementById('eucode').style.visibility="visible";
  }
  else
  {
     document.getElementById('eucode').style.display="none";
     document.getElementById('eucode').style.visibility="hidden";
  }

}
</script>
</head>
<body onLoad="changeCode();">
<table>
	<tr>
        <td class="data-left" colspan="2" colspan="2">
            <%= Question(1) %>
        </td>
		<td>
		<select name="Answer1" id="Answer1" onChange="changeCode();">
            <option value="<%= AnswerField(1) %>">&nbsp;<%= AnswerField(1) %></option>
            <option value="<%= AnswerField(2) %>">&nbsp;<%= AnswerField(2) %></option>
            <option value="<%= AnswerField(3) %>">&nbsp;<%= AnswerField(3) %></option>
            <option value="<%= AnswerField(4) %>">&nbsp;<%= AnswerField(4) %></option>
            <option value="<%= AnswerField(5) %>">&nbsp;<%= AnswerField(5) %></option>
            <option value="<%= AnswerField(6) %>">&nbsp;<%= AnswerField(6) %></option>
            <option value="<%= AnswerField(7) %>">&nbsp;<%= AnswerField(7) %></option>
            <option value="<%= AnswerField(8) %>">&nbsp;<%= AnswerField(8) %></option>
            <option value="<%= AnswerField(9) %>">&nbsp;<%= AnswerField(9) %></option>
            <option value="<%= AnswerField(10) %>">&nbsp;<%= AnswerField(10) %></option>
		</select> 		
		</td>
	</tr>				
	<tr>
		<td colspan="2">
        <div id="eucode" name="eucode">
        <strong>Postcode (EU):</strong>
		<input type="text" name="postcodeEU" size="8"  maxlength="20"> 
        </div>
		</td>
	</tr>	
</table>
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
