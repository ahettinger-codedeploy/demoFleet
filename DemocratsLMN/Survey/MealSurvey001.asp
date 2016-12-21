<%

'CHANGE LOG - Inception
'SSR 4/1/2011
'Meal Selection Survey. 

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->

<%

'===============================================

Page = "Survey"
SurveyNumber = 997
SurveyFileName = "MealSurvey.asp"


'===============================================
'Democratic Committee of Lower Merion & Narberth
'Simple, simple

'One question:
'What is the meal preference for all of those attending?"

'Answers:
'- Chicken
'- Fish
'- Vegetarian

'Radio buttons - answer required

'1-for-1

'The custom survey report is already in place.


NumQuestions = 1
Dim Question(2)
Question(1) = "Meal Preference:"


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
    ClientFolder = "democratslmn"
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

'Survey Start. 
'Request the form name and process requested action


Select Case Clean(Request("FormName"))
    Case "SurveyUpdate"
        Call SurveyUpdate
    Case "Continue"
        Call Continue
    Case Else
        Call SurveyForm
End Select


OBJdbConnection.Close
Set OBJdbConnection = nothing

'===============================================
	
Sub SurveyForm

%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>

<head>

<title>Survey</title>


<style type="text/css">
body
{
    font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
    line-height: 1 em;
}
#rounded-corner
{
	font-size: 13px;
    font-weight: 400;
	width: 500px;
	text-align: left;
	border-collapse: collapse;
}
#rounded-corner thead th.category
{
	padding-top: 15px;
    padding-bottom: 15px;
    padding-left: 0px;
    padding-right: 1px;
	font-size: 15px;
	font-weight: 600;
	text-align: center;
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
	padding-left: 25px;
	padding-right: 25px;
	padding-top: 15px;
	padding-bottom: 15px;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-left
{
	padding-top: 15px;
	padding-bottom: 10px;
	padding-right: 10px;
	text-align: left;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}		
#rounded-corner td.data-right
{	
	padding-top: 15px;
	padding-bottom: 10px;
	padding-right: 15px;
	text-align: right;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
</style>

<script language="JavaScript" src="/clients/SC4A/survey/images/gen_validatorv4.js" type="text/javascript" xml:space="preserve"></script>

</head>

<%=strBody %>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<form action="<%= SurveyFileName %>" name="Survey"  onsubmit="return radio_button_checker();">
<input type="hidden" name="FormName" value="SurveyUpdate">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">
<br />

<%

OptionCount = 1

SQLOrderLine = "SELECT OrderLine.LineNumber FROM OrderLine WITH (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " ORDER BY OrderLine.LineNumber"
Set rsOrderLine = OBJdbConnection.Execute(SQLOrderLine)
Do Until rsOrderLine.EOF

%>

<table id="rounded-corner" summary="surveypage" >
<thead>
    <tr>
	    <th scope="col" class="category-left"></th>
	    <th scope="col" class="category" colspan="2"><b>Meal Selection</b> for Attendee #<%=OptionCount%></th>
	    <th scope="col" class="category-right"></th>
    </tr>        
</thead>
    <tbody>
    <tr>
        <td class="data-right" colspan="2" width="70%">
        What is the meal preference for all of those attending?
        </td>
        <td class="data-left" colspan="2">
            <input type="radio" name="AttendeeInfo<%=OptionCount%>" value="Chicken">&nbsp;Chicken<br />
            <input type="radio" name="AttendeeInfo<%=OptionCount%>" value="Fish">&nbsp;Fish<br />
            <input type="radio" name="AttendeeInfo<%=OptionCount%>" value="Vegetarian">&nbsp;Vegetarian<br />      
        </td>
    </tr>
    <tr>
        <td class="footer-left">&nbsp;</td>
        <td class="footer" colspan="2">&nbsp;</td>
        <td class="footer-right">&nbsp;</td>
    </tr>
    <tr>
        <td colspan="4"><br /><br /><br /></td>
    </tr>

<%

OptionCount = OptionCount + 1

rsOrderLine.MoveNext
	
Loop

rsOrderLine.Close
Set rsOrderLine = nothing

%>
<tr align="center">
    <td>&nbsp;</td>
    <td colspan="2"><br />
        <INPUT TYPE="submit" VALUE="Continue"></FORM>   
          
<script language="JavaScript" type="text/javascript" xml:space="preserve">
//<![CDATA[//You should create the validator only after the definition of the HTML form
  var frmvalidator  = new Validator("Survey");
    frmvalidator.addValidation("AttendeeInfo&1","selone_radio","Please let us know your meal choice");      
//]]></script>
        
                           
    </td>
    <td>&nbsp;</td>
</tr>
</table>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%


End Sub ' SurveyForm

'================================

Sub SurveyUpdate

SQLTotalTickets = "SELECT COUNT(LineNumber) AS TotalTickets FROM OrderLine (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber")
Set rsTotalTickets = OBJdbConnection.Execute(SQLTotalTickets)
TotalTix = CInt(rsTotalTickets("TotalTickets"))
rsTotalTickets.Close
Set rsTotalTickets = Nothing

    For i = 1 To TotalTix   
   
    
        If Request("AttendeeInfo" & i)   <> "" Then    
           
            SQLInsertSurvey = "INSERT SurveyAnswers(SurveyNumber, OrderNumber, CustomerNumber, SurveyDate, AnswerNumber, Answer, Question) VALUES(" & CleanNumeric(SurveyNumber) & ", " & CleanNumeric(Session("OrderNumber")) & ", " & CleanNumeric(Session("CustomerNumber")) & ", '" & Now() & "', " & i & ", '" & FixSingleQuotes(Request("AttendeeInfo" & i)) & "','" & Clean("AttendeeInfo") & "')"
            Set rsInsertSurvey = OBJdbConnection.Execute(SQLInsertSurvey)	    
	    
	    End If
		
    Next
    
    Call Continue
  
End Sub  'AudienceSurveyUpdate


'================================

function FixSingleQuotes(byval strString)
    Dim intIndex
    intIndex = Instr(strString, "'")
    While intIndex > 0 
    strString = Mid(strString,1,intIndex) & "'" & Mid(strString,intIndex+1)
    intIndex = InStr(intIndex+2, strString, "'")
    Wend
    FixSingleQuotes = strString
End function

'================================

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

'================================
%>