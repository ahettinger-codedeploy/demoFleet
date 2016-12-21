<%
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

RequiredEventList = "350876"

Dim Question(2)
NumQuestions = 1

Question(1) = "Name"

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
 
SQLRequiredTicketCount = "SELECT COUNT(OrderLine.ItemNumber) AS Count FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Seat.EventCode IN (" & RequiredEventList & ") AND OrderLine.ItemType = 'Seat'"' GROUP BY Seat.EventCode ORDER BY Seat.EventCode"
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

Sub SurveyForm

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

<script language="JavaScript" src="/clients/Tix/survey/images/gen_validatorv4.js" type="text/javascript" xml:space="preserve"></script>

</head>

<%=strBody %>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<form action="<%= SurveyFileName %>" name="Survey"  onSubmit="return validateForm()">
<input type="hidden" name="FormName" value="SurveyUpdate">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">

<%

i = 1

SQLOrderLine = "SELECT OrderLine.LineNumber FROM OrderLine WITH (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Seat.EventCode IN (" & RequiredEventList & ") ORDER BY OrderLine.LineNumber"
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
    	        Attendee&nbsp;<%=i%><br /><br />
    	    </td>
        </tr>
        <tr>
            <td class="data" colspan="4">&nbsp;</td>
        </tr>
        <tr>
            <td class="data-right" colspan="2"><font size=1><i>Questions marked with <b>*</b> require an answer</i></font></td>
            <td class="data-left" colspan="2">&nbsp;</td>
        </tr>
        <tr>
            <td class="data-right" colspan="2"><%= Question(1) %> <b>*</b></td>
            <td class="data-left" colspan="2"><INPUT TYPE="text" NAME="Answer1" SIZE="24" /></td>
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
 <br />
 <br />
<%

i = i+ 1

rsOrderLine.MoveNext
	
Loop

rsOrderLine.Close
Set rsOrderLine = nothing


%>

<INPUT TYPE="submit" VALUE="Continue"></FORM>

<script language="JavaScript" type="text/javascript" xml:space="preserve">
//<![CDATA[//You should create the validator only after the definition of the HTML form
  var frmvalidator  = new Validator("Survey");
    frmvalidator.addValidation("Answer1","req","Please provide the Attendee’s Name");
    frmvalidator.addValidation("Answer2","req","Please provide the Attendee’s Emergency Contact");
    frmvalidator.addValidation("Answer3","req","Please provide the Emergency Contact Number");
    frmvalidator.addValidation("Answer4","selmin=1","You must check the box acknowledging the terms before proceeding");
//]]></script>


<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%



End Sub ' SurveyForm

'======================================

Sub SurveyUpdate

If Session("OrderNumber") <> "" Then

SQLTotalTickets = "SELECT COUNT(LineNumber) AS TotalTickets FROM OrderLine (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber")
Set rsTotalTickets = OBJdbConnection.Execute(SQLTotalTickets)
TotalTix = CInt(rsTotalTickets("TotalTickets"))
rsTotalTickets.Close
Set rsTotalTickets = Nothing

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


    Session("SurveyComplete") = Session("OrderNumber")
    If Session("UserNumber") = "" Then
	    Response.Redirect("/Ship.asp")
    Else
	    Response.Redirect("/Management/AdvanceShip.asp")
    End If
    
    
End Sub 'Continue


'======================================

%>


