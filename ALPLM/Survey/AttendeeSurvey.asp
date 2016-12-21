<%
'CHANGE LOG 
'SSR 3/17/2011
'Added dynamic text counter
'Revised to require every text field to be required, not just first

'CHANGE LOG - Inception
'SSR 3/16/2011
'Attendee survey

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->

<%

Page = "Survey"
SurveyNumber = 983
SurveyName = "AttendeeSurvey.asp"

'========================================
'Lincoln Presidential Library and Museum

'We need a custom survey for our friends at the ALPLM Foundation (Lincoln Museum).
'Question: “How would you like your name printed on your name badge?”
'Answer: Text Box w/ 100 character limit

'It needs to be attached to EventCode 350876
'Required response
'Need one answer for each ticket on the order
'They need this in place by tomorrow, so we need to be done EOD today...
'we = Sergio

'===============================================

'Survey Questions

RequiredAdultList = "350876"

Dim Question(2)
NumQuestions = 1

Question(1) = "How would you like your name printed on your name badge?"


'===============================================

'Survey Variables

If Session("UserNumber")<> "" Then
    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "FFFFFF"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "000000"
    TableDataBGColor = "E9E9E9"
    ClientFolder= "Tix"
Else
    ClientFolder = "ALPLM"
End If

'===============================================

'Check to see if Order Number exists.  If not, redirect to Home Page.

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

'Survey Start. Request Form name and process requested action

If Clean(Request("FormName")) = "SurveyUpdate" Then
    Call SurveyUpdate
Else
    Call SurveyForm
End If

OBJdbConnection.Close
Set OBJdbConnection = nothing

'===============================================

Sub SurveyForm

'Determine if required event is in the shopping cart  

AvailOfferCount = 0
 
SQLRequiredTicketCount = "SELECT COUNT(OrderLine.ItemNumber) AS Count FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Seat.EventCode IN (" & RequiredAdultList & ") AND OrderLine.ItemType = 'Seat'"' GROUP BY Seat.EventCode ORDER BY Seat.EventCode"
Set rsRequiredTicketCount = OBJdbConnection.Execute(SQLRequiredTicketCount)
    
    If Not rsRequiredTicketCount.EOF Then
        AvailOfferCount = rsRequiredTicketCount("Count")
	End If
	
rsRequiredTicketCount.Close
Set rsRequiredTicketCount = nothing  

If AvailOfferCount  => 1 Then
    Call AdultSurvey
Else
    Call Continue
    Exit Sub  
End If 
  

End Sub

'===============================================

Sub AdultSurvey


%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>

<title>Registration Page</title>

<style type="text/css">
body
{
line-height: 1 em;
}
#rounded-corner
{
	font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
	font-size: 12px;
	font-weight: 400;
	width: 550px;
	text-align: left;
	border-collapse: collapse;
}
#rounded-corner thead th.category
{

	color: <%=TableCategoryFontColor%>;
	background: <%=TableCategoryBGColor%>;
}
#rounded-corner thead th.category-left
{
	background: <%=TableCategoryBGColor%> url('/Clients/<%=ClientFolder%>/Survey/Images/nw.gif') left -1px no-repeat;
	text-align: right;
}
#rounded-corner thead th.category-right
{
	background: <%=TableCategoryBGColor%> url('/Clients/<%=ClientFolder%>/Survey/Images/ne.gif') right -1px no-repeat;
    text-align: left;
}
#rounded-corner td.category
{
	padding-top: 5px;
    padding-left: 15px;
	font-size: 15px;
	font-weight: 600;
	color: <%=TableCategoryFontColor%>;
	background: <%=TableCategoryBGColor%>;
}
#rounded-corner td.footer
{
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.footer-left
{
	background: <%=TableDataBGColor%> url('/Clients/<%=ClientFolder%>/Survey/Images/sw.gif') left bottom no-repeat;
}
#rounded-corner td.footer-right
{
	background: <%=TableDataBGColor%> url('/Clients/<%=ClientFolder%>/Survey/Images/se.gif') right bottom no-repeat;
}
#rounded-corner td.data
{
	padding-top: 5px;
	padding-bottom: 5px;
	font-weight: normal;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-left
{
	padding-top: 5px;
	padding-bottom: 5px;
	text-align: left;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}		
#rounded-corner td.data-right
{	
	padding-top: 2px;
	padding-bottom: 2px;
	padding-right: 15px;
	text-align: right;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.column
{
	padding-top: 5px;
    padding-left: 15px;
	text-align: left;
	color: <%=TableColumnHeadingFontColor%>;
	background: <%=TableColumnHeadingBGColor%>;
	border-top: 1px solid;
	border-bottom: 2px solid;
	border-color: #ffffff;
}
</style>

<SCRIPT LANGUAGE="JavaScript">
<!-- www.webprogrammingscripts.blogspot.com -->
<!-- Limit the number of characters per textarea -->
<!-- Begin
function textCounter(field,cntfield,maxlimit) {
if (field.value.length > maxlimit) // if too long...trim it!
field.value = field.value.substring(0, maxlimit);
// otherwise, update 'characters left' counter
else
cntfield.value = maxlimit - field.value.length;
}
//  End -->
</script>

<script language="javascript">   

function validateForm() {

	formObj = document.Survey;
	
	if (formObj.Answer1.length) {
		for (var i=0;i<formObj.Answer1.length; i++) {
			if (eval("formObj.Answer1[i].value") == ""){	        
		        alert("Please enter your name.");
		        formObj.Answer1[i].focus();
		        return false;
		        } 
		    } 
		 }
	    else {
		    if (formObj.Answer1.value == "") {
		        alert("Please enter your name.");
		        formObj.Answer1.focus();
		        return false;
		        } 
		}
	}        

// end hiding -->

</script>

</head>

<%=strBody %>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<form action="<%= SurveyFileName %>" name="Survey"  onSubmit="return validateForm()">
<input type="hidden" name="FormName" value="SurveyUpdate">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">

<%

OptionCount = 1

SQLOrderLine = "SELECT OrderLine.LineNumber FROM OrderLine WITH (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Seat.EventCode IN (" & RequiredAdultList & ") ORDER BY OrderLine.LineNumber"
Set rsOrderLine = OBJdbConnection.Execute(SQLOrderLine)
Do Until rsOrderLine.EOF

%>



    <table id="rounded-corner" summary="surveypage">
    <thead>
	    <tr>
    	    <th scope="col" class="category-left"></th>
    	    <th scope="col" class="category" colspan="2">&nbsp;</th>
    	    <th scope="col" class="category-right"></th>
        </tr>        
   </thead>
        <tbody>
	    <tr>
    	    <td class="category" colspan="4">
    	        <b>ATTENDEE INFORMATION</b><Br />
    	        <br />
    	        Attendee&nbsp;<%=OptionCount%><br /><br />
    	    </td>
        </tr>
            <tr>
            <tr>
                <td class="data-right" valign="top" colspan="2" width="50%">
                    <br />
                    Fields marked with <font color="red">&nbsp;<b>*</b>&nbsp;</font> are required.
                    <br />
                    <br />
                </td>
                <td class="data-left" valign="top" colspan="2" width="50%">
                    &nbsp;
                </td>
            </tr>
                <td class="data-right" valign="top" colspan="2">
                <%= Question(1) %>&nbsp;<font color="red">&nbsp;<b>*</b>&nbsp;</font><br />
                </td>
                <td class="data-left" valign="top" colspan="2">
                <textarea name="Answer1" wrap="physical" cols="28" rows="4" onKeyDown="textCounter(document.Survey.Answer1,document.Survey.remLen<%=OptionCount%>,100)"
                onKeyUp="textCounter(document.Survey.Answer1,document.getElementById('remLen<%=OptionCount%>').innerHTML=(100 -this.value.length))"></textarea><br />
                <span id="remLen<%=OptionCount%>">100</span>&nbsp;Characters left<br><br>

</td>
            </tr>
             <tr>
                <td class="data" colspan="4">&nbsp;</td>
            <tr>
            <tr>
        	    <td class="footer-left">&nbsp;</td>
        	    <td class="footer" colspan="2">&nbsp;</td>
        	    <td class="footer-right">&nbsp;</td>
        	</tr>
        </tbody>
 </table>
 <br />
 <br />
 <br />
<%

OptionCount = OptionCount + 1

rsOrderLine.MoveNext
	
Loop

rsOrderLine.Close
Set rsOrderLine = nothing


%>

<INPUT TYPE="submit" VALUE="Continue"></FORM>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%

End Sub ' SurveyForm

'======================================

Sub SurveyUpdate

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
		
End If

Call Continue

End Sub 'Update SurveyAnswer


'======================================



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
	
End Sub
      



'======================================

%>


