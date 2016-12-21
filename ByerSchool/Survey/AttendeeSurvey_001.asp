<%

'CHANGE LOG - Inception
'SSR Wednesday, July 06, 2011
'Custom Code 

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->

<%

'========================================

Page = "Survey"
SurveyNumber = 1089
SurveyName = "AttendeeSurvey.asp"

'========================================

'The Byerschool Foundation (8/18/2011)

'We need a custom survey for our friends at The Byerschool Foundation.
'Parameters
'Collect attendee information for an event
'Number of attendees to collect names for will vary based on ticket types
'Eligible ActCodes / EventCodes
'EventCode 394447
'Offline/Online
'Online and Offline
'Restrictions
'If SeatTypeCode 5837 (Gala Sponsor Table) then we need to collect information for 8 attendees
'If SeatTypeCode 5838 (Gala Patron Table) then we need to collect information for 8 attendees
'If SeatTypeCode 5839 (Celebration Patron) then we need to collect information for 2 attendee
'If SeatTypeCode 16 (Individual) then we need to collect information for 1 attendee 
'If SeatTypeCode 5840 (Donation of Tickets) then do not display survey
'Survey Fields
'First Name
'Last Name

'Answers Required - Yes
'Custom Survey Report Required
'Yes - Please attach custom (linear) survey report to primary User account
'- Silvia Mahoney

'===============================================
'Survey Parameters

FormName = "Attendee Information"

NumQuestions = 2
Dim Question(3)
Question(1) = "First Name"
Question(2) = "Last Name"

AttendeeCount = 0

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
    SWCorner="/clients/tix/images/image.asp?FirstHex=fffffe&LastHex=E9E9E9&Src=BottomLeftCorner16.txt"
    SECorner="/clients/tix/images/image.asp?FirstHex=fffff3&LastHex=E9E9E9&Src=BottomRightCorner16.txt"
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

SQLPatronCount = "SELECT OrderLine.LineNumber, OrderLine.SeatTypeCode, SeatType FROM OrderLine (NOLOCK) INNER JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode WHERE OrderNumber = " & Session("OrderNumber") & " ORDER BY OrderLine.LineNumber"
Set rsPatronCount = OBJdbConnection.Execute(SQLPatronCount)   
   
        If Not rsPatronCount.EOF Then
            Do While Not rsPatronCount.EOF
               
            Select Case rsPatronCount("SeatTypeCode")
                Case  5837 'Gala Sponsor Table 
                    Count = 8
                    
                Case  5838 'Gala Patron Table
                    Count = 8
                    
                Case  5839 'Celebration Patron
                    Count = 2
                    
                Case  16 'Individual
                    Count = 1
                                    
                Case  5840 'Donation of Tickets 
                    Count = 0
                    
             End Select
         
            AttendeeCount = AttendeeCount + Count
        
            rsPatronCount.movenext    
            Loop
    	
        End If

rsPatronCount.Close
Set rsPatronCount = nothing

If AttendeeCount = 0 Then
    Call Continue
Else
    Call DisplayForm(AttendeeCount)
End If

End Sub

'==========================================================

Sub DisplayForm(AttendeeCount)

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

<style type="text/css">

body
{
    font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
    line-height: 1 em;
}
#rounded-corner
{
	font-size: 11px;
    font-weight: 400;
	width: 550px;
	text-align: left;
	border-collapse: collapse;
}
#rounded-corner thead th.category
{
	padding-top: 10px;
    padding-bottom: 10px;
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
    background: <%=TableDataBGColor%> url('<%=SWCorner%>') left bottom no-repeat;
}
#rounded-corner td.footer-right
{
	background: <%=TableDataBGColor%> url('<%=SECorner%>') right bottom no-repeat;
}
#rounded-corner td.data
{
	padding-left: 10px;
	padding-right: 10px;
	padding-top: 10px;
	padding-bottom: 10px;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-left
{
	padding-left: 10px;
	padding-right: 10px;
	padding-top: 10px;
	padding-bottom: 10px;
	text-align: left;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-right
{
	padding-left: 10px;
	padding-right: 10px;
	padding-top: 10px;
	padding-bottom: 10px;
    text-align: right;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
</style>

<script language="javascript">   

function validateForm() {

	formObj = document.Survey;
	
	if (formObj.Answer1.length) {
		for (var i=0;i<formObj.Answer1.length; i++) {
			if (eval("formObj.Answer1[i].value") == ""){	        
		        alert("Please enter each attendee's first name");
		        formObj.Answer1[i].focus();
		        return false;
		        } 
		    } 
		 }
	    else {
		    if (formObj.Answer1.value == "") {
		        alert("Please enter each attendees first name");
		        formObj.Answer1.focus();
		        return false;
		        } 
		}
		
	if (formObj.Answer2.length) {
		for (var i=0;i<formObj.Answer2.length; i++) {
			if (eval("formObj.Answer2[i].value") == ""){	        
		        alert("Please enter each attendee's last name");
		        formObj.Answer2[i].focus();
		        return false;
		        } 
		    } 
		 }
	    else {
		    if (formObj.Answer2.value == "") {
		        alert("Please enter each attendees last name");
		        formObj.Answer2.focus();
		        return false;
		        } 
		}
		
		
	}        

// end hiding -->

</script>


</head>

<%=strBody %>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<form action="<%= SurveyFileName %>" method="post" name="Survey" onSubmit="return validateForm()">
<input type="hidden" name="FormName" value="SurveyUpdate">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">

    <br />
    <table id="rounded-corner" summary="surveypage" border="0">
    <thead>
	    <tr>
    	    <th scope="col" width="8%" class="category-left"></th>
    	    <th scope="col" width="82%" class="category" colspan="3">ATTENDEE INFORMATION</th>
    	    <th scope="col" width="8%" class="category-right"></th>
        </tr>        
   </thead>
        <tbody>
        <tr>
            <td class="data" >&nbsp;</td>
            <td class="data" >&nbsp;</td>
            <td class="data-left" colspan="2"><br /><i>Please enter each attendee's first and last name</i></td>
            <td class="data" >&nbsp;</td>
        </tr>
        <tr>
            <td class="data" >&nbsp;</td>
            <td class="data-right" >&nbsp;</td>
            <td class="data-left" >&nbsp;&nbsp;<%= Question(1) %></td>
            <td class="data-left" ><%= Question(2) %></td>
            <td class="data" >&nbsp;</td>
        </tr>
        
        <% For i = 1 to AttendeeCount %>
        <tr>
            <td class="data" >&nbsp;</td>
            <td class="data-right">Attendee <%= i %></td>
            <td class="data-right"><INPUT TYPE="text" NAME="Answer1" SIZE="20" /></td>
            <td class="data-left"><INPUT TYPE="text" NAME="Answer2" SIZE="20" /></td>
            <td class="data" >&nbsp;</td>
        </tr>                   
        <% Next %>
        <tr>
    	    <td class="footer-left">&nbsp;</td>
    	    <td class="footer" colspan="3" >&nbsp;</td>
    	    <td class="footer-right">&nbsp;</td>
    	</tr>
        </tbody>
 </table>
<br />


<INPUT TYPE="submit" VALUE="Continue"></FORM>

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


