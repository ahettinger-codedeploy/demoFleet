<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->

<%

Page = "Survey"
SurveyNumber = 969
SurveyFileName = "ClassAdultSurvey.asp"

'========================================

'Saugatuck Center for the Arts (2/15/2011)
'Adult Class Registration 

'Survey to capture attendee information
'Adult classes
'All fields required

'Food class: Act Code: 61006, Event #: 345626
'Bollywood: Act Code:61016, Event #: 345655
'Henna: Act Code: 61017, Event #: 245666


'========================================

'Survey Questions

RequiredAdultList = "345626,345655,245666"

Dim Question(5)
NumQuestions = 4

Question(1) = "Name"
Question(2) = "Emergency Contact" 
Question(3) = "Emergency Contact Number" 
Question(4) = "REFUND POLICY for Camps and Classes"


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
    ClientFolder = "SC4A"
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

<script language="JavaScript" src="/clients/SC4A/survey/images/gen_validatorv4.js" type="text/javascript" xml:space="preserve"></script>

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
    	        <b>ADULT CLASS REGISTRATION</b><Br />
    	        <br />
    	        Attendee&nbsp;<%=OptionCount%><br /><br />
    	    </td>
        </tr>
            <tr>
                <td class="column" colspan="4">
                    REFUND POLICY<br />
                    for Camps and Classes<BR>
                    <BR>
                    To best serve you and manage our costs, the SCA refund policy for camps and classes is as follows:<BR>
                    <BR>
                    - Cancellation 7 or more days prior to camp/class = FULL refund<BR>
                    - Cancellation 3-6 days prior to a camp/class = 50% refund<BR>
                    - Cancellation less than 3 days prior to a camp/class = NO refund<BR>
                    <br />
                    If for any reason the SCA cancels a camp/class a FULL refund will be awarded.<BR>
                    <br />
                </td>
            </tr>
            <tr>
            <tr>
                <td class="data" colspan="4">&nbsp;</td>
            <tr>
                <td class="data-right" colspan="2"><font size=1><i>Questions marked with <b>*</b> require an answer</i></font></td>
                <td class="data-left" colspan="2">&nbsp;</td>
            </tr>
                <td class="data-right" colspan="2"><%= Question(1) %> <b>*</b></td>
                <td class="data-left" colspan="2"><INPUT TYPE="text" NAME="Answer1" SIZE="24" /></td>
            </tr>
            <tr>
                <td class="data-right" colspan="2"><%= Question(2) %> <b>*</b></td>
                <td class="data-left" colspan="2"><INPUT TYPE="text" NAME="Answer2" SIZE="24" /></td>
             </tr>
             <tr>
                <td class="data-right" colspan="2"><%= Question(3) %> <b>*</b></td>
                <td class="data-left" colspan="2"><INPUT TYPE="text" NAME="Answer3" SIZE="24" /></td>
            </tr>
            <tr>
                <td class="data-right" colspan="4">
                <br>
                <INPUT TYPE="checkbox" NAME="Answer4" VALUE="Accept">&nbsp;I have read the refund policy above and accept the terms and conditions.
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

Response.Redirect("ClassChildSurvey.asp")
Exit Sub

      
End Sub 'Continue


'======================================

%>


