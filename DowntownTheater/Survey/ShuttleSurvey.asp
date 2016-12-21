<%

'SSR 5/15/2012 - Changed name from AttendeeSurvey (which is the name of another, different survey) to ShuttleSurvey

'TTT 2/9/12 - Realigned set of questions horizontally instead of displaying vertically
'Custom Survey 

'CHANGE LOG - Inception
'SSR 1/30/2012



%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->

<%

'========================================

Page = "Survey"
SurveyNumber = 1193
SurveyName = "ShuttleSurvey.asp"

'========================================
'University of Alabama - HRC (Housing and Residential Communities) (3942)

'Custom registration-ish survey

'1 set of answers per each ticket purchased (1-for-1)

'Question set:
'- Rider Name (required answer)
'- Rider Cell # (required answer)
'- Rider Email Address (required answer)
'- Rider CWID (required answer)
'- Airline (required answer)
'- Flight # (required answer)
'- Flight Departure/Arrival Time (required answer)
'- Number of bags (required answer)
'- Other items to be brought on board

'All answers should be text fields (50 character max for each)

'Client would like all questions sets on one page.  They've provided an example, which is attached.

'Survey should be attached to EventCodes 442956,442957,442958,442959,442960,442961,442962,442963,442964

'Language for top of the page (above the question set):
'"Important!  It is critical that we have contact information for the RIDER, not another person or parent.  Please make sure that the RIDER'S phone # is given and the phone is charged during the trip in the event that a staff person needs to contact the rider."

'Language for bottom of the page (below the question set):
'Only UA students, faculty and staff may ride on the Airport Shuttle.  Family or friends may not use the shuttle service

'===============================================
'Survey Parameters

SurveyTitle = "Registration Information"
SurveyHeader = "Important!  It is critical that we have contact information for the RIDER, not another person or parent.  Please make sure that the RIDER'S phone # is given and the phone is charged during the trip in the event that a staff person needs to contact the rider."
SurveyFooter = "Only UA students, faculty and staff may ride on the Airport Shuttle.  Family or friends may not use the shuttle service.<BR><BR>*Required field"

Dim Question(9)
Question(1) = "Rider Name*"
Question(2) = "Rider Cell #*"
Question(3) = "Rider Email*"
Question(4) = "Rider CWID*"
Question(5) = "Airline*"
Question(6) = "Flight #*"
Question(7) = "Departure/Arrival Time*"
Question(8) = "Number of bags*"
Question(9) = "Other items to be brought on board"

'===============================================

'CSS Survey Variables

If Session("UserNumber")<> "" Then
    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "#FFFFFF"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "#000000"
    TableDataBGColor = "#E9E9E9"
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

'Bypass this survey on Comp Orders

If Session("OrderTypeNumber") = 5 Then
	Call Continue
End If

'============================================================

'Request the form name and process requested action

 Select Case Clean(Request("FormName"))
    Case "SurveyUpdate"
        Call SurveyUpdate
    Case Else
        Call SurveyForm
 End Select

'==========================================================
	
Sub SurveyForm

If DocType <> "" Then
	Response.Write DocType
Else
	Response.Write "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
End If

%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<html>
<head>

<title>TIX.com</title>

<style>
    
.datatable 
{
	padding-top: 10px;
	padding-bottom: 15px;
	border-collapse: collapse;
	font-size: 1em;
	width: 33%;
		
}
	
.datatable  thead 
{
	background-color: <%=TableCategoryBGColor%>;
	color: <%=TableCategoryFontColor%> !important;
	font-weight: 700;
	border-top: solid 1px #000000;
	border-bottom: solid 1px #000000;
}
.datatable  tbody
{
    background: <%=TableDataBGColor%>;
	color: <%=TableDataFontColor%> !important;
}
.datatable  tbody td
{
    padding-bottom:15px;
}
</style>

<LINK rel="stylesheet" type="text/css" href="js/validationEngine.jquery.css">

<SCRIPT type="text/javascript" charset="utf-8" src="js/jquery.validationEngine.js"></SCRIPT>

<SCRIPT type="text/javascript" charset="utf-8" src="js/jquery.validationEngine-en.js"></SCRIPT>

<script type="text/javascript">
    jQuery(document).ready(function () {
        jQuery("#formID").validationEngine('attach');
    });
</script>

</head>

<%=strBody %>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<form action="<%= SurveyFileName %>" name="Survey" id="formID" class="formular" method="post">
<input type="hidden" name="FormName" value="SurveyUpdate">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">
<table>
<%

OptionCount = 1
counter = 0
SQLPatronCount = "SELECT OrderLine.LineNumber, OrderLine.SeatTypeCode, SeatType FROM OrderLine (NOLOCK) INNER JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode WHERE OrderNumber = " & Session("OrderNumber") & " ORDER BY OrderLine.LineNumber"
Set rsPatronCount = OBJdbConnection.Execute(SQLPatronCount)   
    
    Do While Not rsPatronCount.EOF 
        If counter = 0 Then
            Response.Write "<TR>" & vbCrLf
        End If
    %>
    
<td>
<table class="datatable" summary="surveypage" border="0">
    <thead>
	    <tr>
    	    <td colspan="2"><%=SurveyTitle%><br />Rider&nbsp;<%=OptionCount%></td>
        </tr>        
   </thead>
   <tbody>
        <tr>
            <td class="data" colspan="2"><%=SurveyHeader%></td>
        </tr>
        <%        
        For x = 1 To UBound(Question)
        %>
        <tr>
            <td ><%=Question(x)%></td>
            <td ><INPUT TYPE="text" NAME="Answer<%=x%>" id="Answer<%=x%>_<%=rsPatronCount("LineNumber")%>" class="validate[required] text-input" SIZE="24"  /></td>
        </tr>
        
        <%        
        Next
        %>
        <tr>
            <td colspan="2"><%=SurveyFooter%></td>
        </tr>
   </tbody>
 </table>
 </td>

<%
        counter = counter + 1
        OptionCount = OptionCount + 1

        rsPatronCount.Movenext
        If Not rsPatronCount.EOF Then
            If counter = 4 Then
                counter = 0
                Response.Write "</TR>" & vbCrLf
            End If
        End If    
    Loop

rsPatronCount.Close
Set rsPatronCount = nothing
Response.Write "</TR>" & vbCrLf
%>
</table>

<INPUT TYPE="submit" VALUE="Continue"></FORM>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%

End Sub ' SurveyForm

'==========================================

Sub SurveyUpdate

NumQuestions = 9

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

'==========================================


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


