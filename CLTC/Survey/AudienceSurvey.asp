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

NumQuestions = 4

Dim Question(5)

Question(1) = "How did you hear about this events?"
Question(2) = "Other (please specify)"
Question(3) = "Age Range"
Question(4) = "Ethnicity"

Dim AnswerField(5,9)

AnswerField(1,1) = "Postcard"
AnswerField(1,2) = "Know someone in the show"
AnswerField(1,3) = "eNewsletter"
AnswerField(1,4) = "Search Engine/Website"
AnswerField(1,5) = "cltc.org"
AnswerField(1,6) = "Facebook"
AnswerField(1,7) = "Review"
AnswerField(1,8) = "Patron who saw the show"
AnswerField(1,9) = "Our Non-Profit Partner"

AnswerField(3,1) = "Under 25"
AnswerField(3,2) = "26-40"
AnswerField(3,3) = "41-65"
AnswerField(3,4) = "Over 65"

AnswerField(4,1) = "American Indian/Alaskan Native"
AnswerField(4,2) = "Asian; African-American"
AnswerField(4,3) = "Hispanic/Latino"
AnswerField(4,4) = "Native Hawaiian/Other Pacific Islander"
AnswerField(4,5) = "Caucasian"

'============================================================

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

'============================================================

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

<script type="text/javascript" >
function showfield(name)
  {
    if(name=="other")document.getElementById("div1").style.display="block";
    else document.getElementById("div1").style.display="none";
  }
 
function hidefield() 
  {
    document.getElementById("div1").style.display="none";
  }
</script>

<head>

</head>

<body onload = "hidefield()">

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
            <select name = "Answer1" id="Answer1" onchange="showfield(this.options[this.selectedIndex].value)">
            <option value="000"> Select an answer below...</option>
            <OPTION VALUE="<%= AnswerField(1,1) %>">&nbsp;<%= AnswerField(1,1) %></OPTION>
            <OPTION VALUE="<%= AnswerField(1,2) %>">&nbsp;<%= AnswerField(1,2) %></OPTION>
            <OPTION VALUE="<%= AnswerField(1,3) %>">&nbsp;<%= AnswerField(1,3) %></OPTION>
            <OPTION VALUE="<%= AnswerField(1,4) %>">&nbsp;<%= AnswerField(1,4) %></OPTION>
            <OPTION VALUE="<%= AnswerField(1,5) %>">&nbsp;<%= AnswerField(1,5) %></OPTION>
            <OPTION VALUE="<%= AnswerField(1,6) %>">&nbsp;<%= AnswerField(1,6) %></OPTION>
            <OPTION VALUE="<%= AnswerField(1,7) %>">&nbsp;<%= AnswerField(1,7) %></OPTION>
            <OPTION VALUE="<%= AnswerField(1,8) %>">&nbsp;<%= AnswerField(1,8) %></OPTION>
            <OPTION VALUE="<%= AnswerField(1,9) %>">&nbsp;<%= AnswerField(1,9) %></OPTION>
            <option value="Other">&nbsp;Other</option>
            </select>    
        </td>
    </tr>
    <tr>
        <td class="data">&nbsp;</td>
        <td class="data">&nbsp;</td>
        <td class="data-right"><div id="div1">Please Specify:&nbsp;<input type="text" name="Answer2" /><br /><br /></div></td>
        <td class="data">&nbsp;</td>
    </tr>
    <tr>
        <td class="data-left" colspan="2" width="50%"><%=Question(3)%><br /><br /></td>
        <td class="data-right" colspan="2" width="50%">
            <select name="Answer3">
            <option value="0"> -- Select An Answer -- </option>
            <OPTION VALUE="<%= AnswerField(3,1) %>">&nbsp;<%= AnswerField(3,1) %></OPTION>
            <OPTION VALUE="<%= AnswerField(3,2) %>">&nbsp;<%= AnswerField(3,2) %></OPTION>
            <OPTION VALUE="<%= AnswerField(3,3) %>">&nbsp;<%= AnswerField(3,3) %></OPTION>
            <OPTION VALUE="<%= AnswerField(3,4) %>">&nbsp;<%= AnswerField(3,4) %></OPTION>
            </select>
            <br /><br /> 
        </td>
    </tr>
    <tr>
        <td class="data-left" colspan="2" width="50%">
            <%=Question(4)%>
        </td>
        <td class="data-right" colspan="2" width="50%">
            <select name="Answer4">
            <option value="0"> -- Select An Answer -- </option>
            <OPTION VALUE="<%= AnswerField(4,1) %>">&nbsp;<%= AnswerField(4,1) %></OPTION>
            <OPTION VALUE="<%= AnswerField(4,2) %>">&nbsp;<%= AnswerField(4,2) %></OPTION>
            <OPTION VALUE="<%= AnswerField(4,3) %>">&nbsp;<%= AnswerField(4,3) %></OPTION>
            <OPTION VALUE="<%= AnswerField(4,4) %>">&nbsp;<%= AnswerField(4,4) %></OPTION>
            <OPTION VALUE="<%= AnswerField(4,5) %>">&nbsp;<%= AnswerField(4,5) %></OPTION>
            </select>    
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

'============================================================

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

'============================================================

%> 
