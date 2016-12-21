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

Dim Answer(11)
Answer(1) = "Postcard"
Answer(2) = "Know someone in the show"
Answer(3) = "eNewsletter"
Answer(4) = "Search Engine/Website"
Answer(5) = "cltc.org"
Answer(6) = "Facebook"
Answer(7) = "Review"
Answer(8) = "Patron who saw the show"
Answer(9) = "Our Non-Profit Partner"
Answer(10) = "Other"



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
    text-align: left;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
</style>


<script>
//*********************************************
// Function that Shows an HTML element
//*********************************************
function showDiv(divID)
{
	var div = document.getElementById(divID);
	div.style.display = ""; //display div
}

//*********************************************
// Function that Hides an HTML element
//*********************************************
function hideDiv(divID)
{
	var div = document.getElementById(divID);
	div.style.display = "none"; // hide
}
//*****************************************************************************
// Function that Hides all the Div elements in the select menu Value
//*****************************************************************************
function hideAllDivs()
{
	//Loop through the seclect menu values and hide all
	var selectMenu = document.getElementById("selectMenu");
	for (var i=0; i<=selectMenu.options.length -1; i++)
	{
		hideDiv(selectMenu.options[i].value);
	}
}
//*********************************************
// Main function that calls others to toggle divs
//*********************************************
function toggle(showID)
{
	hideAllDivs(); // Hide all
	showDiv(showID); // Show the one we asked for

}


</script>


<head>

</head>

<body onload="hideAllDivs();  showDiv('formNumber1')">

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
        <td class="data-left" colspan="2" colspan="2">
            <%= Question(1) %>
        </td>
        <td class="data-right" colspan="2" colspan="2">                
        <select name="Answer1">
    	    <option value="0"> -- Select An Answer -- </option>
            <OPTION VALUE="<%= Answer(1) %>">&nbsp;<%= Answer(1) %></OPTION>
            <OPTION VALUE="<%= Answer(2) %>">&nbsp;<%= Answer(2) %></OPTION>
            <OPTION VALUE="<%= Answer(3) %>">&nbsp;<%= Answer(3) %></OPTION>
            <OPTION VALUE="<%= Answer(4) %>">&nbsp;<%= Answer(4) %></OPTION>
            <OPTION VALUE="<%= Answer(5) %>">&nbsp;<%= Answer(5) %></OPTION>
            <OPTION VALUE="<%= Answer(6) %>">&nbsp;<%= Answer(6) %></OPTION>
            <OPTION VALUE="<%= Answer(7) %>">&nbsp;<%= Answer(7) %></OPTION>
            <OPTION VALUE="<%= Answer(8) %>">&nbsp;<%= Answer(8) %></OPTION>
            <OPTION VALUE="<%= Answer(9) %>">&nbsp;<%= Answer(9) %></OPTION>
            <OPTION VALUE="<%= Answer(10) %>" onChange="showhide('Question2');">&nbsp;<%= Answer(10) %></OPTION>
        </select>
        </td>
    </tr>
    <tr id='Question2' style="display:none">
        <td class="data-right" colspan="2"><%= Question(2) %></td>
        <td class="data-left" colspan="2"><INPUT TYPE="text" NAME="Answer2"SIZE="24" /></td>
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

<select id="selectMenu" onchange="toggle(this.options[this.options.selectedIndex].value)">
<option value="formNumber1"> Show Form 1 </option>
<option value="formNumber2"> Show Form 2 </option>
<option value="formNumber3"> Show Form 3 </option>
<option value="formNumber4"> Show Form 4 </option>

</select>

<div id="formNumber1" style="display:none;"> I am Form Number one. Any content within this div will be showed</div>

<div id="formNumber2" style="display:none;"> I am Form Number two. Any content within this div will be showed</div>

<div id="formNumber3" style="display:none;"> I am Form Number three. Any content within this div will be showed</div>

<div id="formNumber4" style="display:none;"> I am Form Number four. Any content within this div will be showed</div>



<br /> 
<br />
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
 