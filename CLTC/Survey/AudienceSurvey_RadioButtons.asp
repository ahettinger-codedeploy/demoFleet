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
<title><%= title %></title>

<style type="text/css">
body
{
    font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
}
#rounded-corner
{
	font-size: 11px;
    font-weight: 400;
	width: 80%;
	text-align: left;
	border-collapse: collapse;
}
#rounded-corner thead th.category
{
	padding-top: 10px;
    padding-bottom: 10px;
    padding-left: 10px;
    padding-right: 10px;
	font-size: 15px;
	font-weight: 600;
	text-align: center;
	color: <%=TableCategoryFontColor%>;
	background: <%=TableCategoryBGColor%>;
}
#rounded-corner thead th.category-left
{
	background: <%=TableCategoryBGColor%> url('<%=NECorner%>') left -1px no-repeat;
	text-align: right;
}
#rounded-corner thead th.category-right
{
	background: <%=TableCategoryBGColor%> url('<%=NWCorner%>') right -1px no-repeat;
    text-align: left;
}
#rounded-corner td.footer
{
    background: <%=TableDataBGColor%>;
}
#rounded-corner td.footer-left
{

    background: <%=TableDataBGColor%> url('<%=SWCorner%>') left bottom  no-repeat;
}
#rounded-corner td.footer-right
{
    background: <%=TableDataBGColor%> url('<%=SECorner%>') right bottom  no-repeat;
}
#rounded-corner td.data
{
    text-align: center;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-left
{
    text-align: right;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-right
{
    padding-left: 10px;
    padding-right: 10px;
    text-align: left;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
</style>

<script language="JavaScript">
function setVisibility(id, visibility) {
document.getElementById(id).style.display = visibility;
}
</script>

<head>

</head>

<%= strBody %>

<!--#include virtual="TopNavInclude.asp"-->

<FORM ACTION="<%= SurveyName %>" name="Survey" METHOD="post">
<INPUT TYPE="hidden" NAME="FormName" VALUE="SurveyForm">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">
<br />
<table id="rounded-corner" summary="surveypage">
<thead>
    <tr>
	    <th scope="col" class="category-left"></th>
	    <th scope="col" class="category" colspan="2">AUDIENCE SURVEY</th>
	    <th scope="col" class="category-right"></th>
    </tr>        
</thead>
    <tbody>
   <tr>
        <td class="data" colspan="4">&nbsp;</td>
   </tr> 
    <tr>
        <td class="data-left" colspan="2" width="50%">  
        <%=Question(1)%>
        </td>
        <td class="data-right" colspan="2" width="50%">  
        <INPUT TYPE="radio" NAME="Answer1" VALUE="<%=AnswerField(1)%>"  onclick="setVisibility('other','none');";>&nbsp;<%=AnswerField(1)%><br />
        <INPUT TYPE="radio" NAME="Answer1" VALUE="<%=AnswerField(2)%>"  onclick="setVisibility('other','none');";>&nbsp;<%=AnswerField(2)%><br />
        <INPUT TYPE="radio" NAME="Answer1" VALUE="<%=AnswerField(3)%>"  onclick="setVisibility('other','none');";>&nbsp;<%=AnswerField(3)%><br />
        <INPUT TYPE="radio" NAME="Answer1" VALUE="<%=AnswerField(4)%>"  onclick="setVisibility('other','none');";>&nbsp;<%=AnswerField(4)%><br />
        <INPUT TYPE="radio" NAME="Answer1" VALUE="<%=AnswerField(5)%>"  onclick="setVisibility('other','none');";>&nbsp;<%=AnswerField(5)%><br />
        <INPUT TYPE="radio" NAME="Answer1" VALUE="<%=AnswerField(6)%>"  onclick="setVisibility('other','none');";>&nbsp;<%=AnswerField(6)%><br />
        <INPUT TYPE="radio" NAME="Answer1" VALUE="<%=AnswerField(7)%>"  onclick="setVisibility('other','none');";>&nbsp;<%=AnswerField(1)%><br />
        <INPUT TYPE="radio" NAME="Answer1" VALUE="<%=AnswerField(8)%>"  onclick="setVisibility('other','none');";>&nbsp;<%=AnswerField(2)%><br />
        <INPUT TYPE="radio" NAME="Answer1" VALUE="<%=AnswerField(9)%>"  onclick="setVisibility('other','none');";>&nbsp;<%=AnswerField(3)%><br />
        <INPUT TYPE="radio" NAME="Answer1" VALUE="<%=AnswerField(10)%>"  onclick="setVisibility('other','inline');";>&nbsp;Other<br /><span style="display: none;" id="other">Please Specify:<INPUT TYPE="text" NAME="Answer2" size="23"></span><br />
        </td>
    </tr>
    <tr>
        <td class="data" colspan="4">&nbsp;</td>
    </tr>
    <tr>
        <td class="footer-left">&nbsp;</td>
        <td class="footer" colspan="2">&nbsp;</td>
        <td class="footer-right">&nbsp;</td>
    </tr>
    </tbody>
</table>
<br />         
<INPUT TYPE="submit" VALUE="Continue"></FORM>


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
