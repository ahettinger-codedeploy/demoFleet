<%
    'CHANGE LOG
    'TTT 10/22/12 - Created generic 1-on-1 custom OrderLineDetail attendee survey
    'TTT 10/24/12 - Ensured matching LineNumbers are stored in OrderLineDetail
    'TTT 1/14/13 - Removed leading space for multi-checkbox answers
    'TTT 1/15/13 - Added SurveyNumber to OrderLineDetail
    'TTT 2/7/13 - Fixed issue for survey answers with commas
    'TTT 3/22/13 - Revised to include DateSuppress and TimeSuppress flags
    'TTT 4/29/13 - Revised to fix issue with multiple events attached to the same Attendee Survey
%>
<!--#INCLUDE VIRTUAL=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->

<% 
If Session("UserNumber") <> "" Then
    Page = "ManagementTicketSales"
Else
    Page = "Survey"
End If

If Session("OrderNumber") <> "" And Request("SurveyNo") = "" Then
    SQLEventSurvey = "SELECT SurveyNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Event.SurveyNumber IS NOT NULL AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent', 'SubSeat')"
	SQLEventSurvey = SQLEventSurvey & " UNION SELECT SurveyNumber FROM OrderLine (NOLOCK) INNER JOIN Donation (NOLOCK) ON OrderLine.ItemNumber = Donation.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Donation.SurveyNumber IS NOT NULL AND OrderLine.ItemType = 'Donation'"
	Set rsEventSurvey = OBJdbConnection.Execute(SQLEventSurvey)
	If Not rsEventSurvey.EOF Then 'Get the Survey FileName
		SurveyNumber = rsEventSurvey("SurveyNumber")
    End If
    rsEventSurvey.Close
	Set rsEventSurvey = nothing
Else
    SurveyNumber = CleanNumeric(Request("SurveyNo"))
End If

If SurveyNumber = "" Then
    Response.Redirect("/Management/Default.asp")
End If

SQLSurvey = "SELECT SurveyFileName, OrganizationNumber, TotalQuestions, SurveyTitle, SurveyHeader, SurveyFooter FROM Survey (NOLOCK) WHERE SurveyNumber= " & SurveyNumber
Set rsSurvey = OBJdbConnection.Execute(SQLSurvey)
If Not rsSurvey.EOF Then
    SurveyFileName = rsSurvey("SurveyFileName")
    OrganizationNumber = rsSurvey("OrganizationNumber")
    SurveyTitle = rsSurvey("SurveyTitle")
    SurveyHeader = rsSurvey("SurveyHeader")
    SurveyFooter = rsSurvey("SurveyFooter")
End If
rsSurvey.Close
Set rsSurvey = Nothing

If Session("OrderNumber") = "" Then
    If Session("UserNumber") = "" Then
	    Response.Redirect("/Default.asp")
    Else
	    Response.Redirect("/Management/Default.asp")
    End If
End If
'Check if this Survey belongs to the right Organization
'JAI 10/22/10 - Include check for donation
SQLSurveyCheck = "SELECT Survey.SurveyNumber, Survey.OrganizationNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Survey (NOLOCK) ON OrganizationVenue.OrganizationNumber = Survey.OrganizationNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Survey.SurveyNumber = " & SurveyNumber & " UNION SELECT Survey.SurveyNumber, Survey.OrganizationNumber  FROM OrderLine (NOLOCK) INNER JOIN Donation (NOLOCK) ON OrderLine.ItemNumber = Donation.ItemNumber  INNER JOIN Survey (NOLOCK) ON (Donation.OrganizationNumber = Survey.OrganizationNumber OR Donation.RemittalOrganizationNumber = Survey.OrganizationNumber) WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Survey.SurveyNumber = " & SurveyNumber
Set rsSurveyCheck = OBJdbConnection.Execute(SQLSurveyCheck)
If rsSurveyCheck.EOF Then
    rsSurveyCheck.Close
    Set rsSurveyCheck = Nothing
    SecurityLog("Survey Number: " & SurveyNumber & " is INVALID for the Organization of Events in Order Number: " & Session("OrderNumber"))
    'Exit Survey
    Call UpdateSurveyAnswer
End If
rsSurveyCheck.Close
Set rsSurveyCheck = Nothing

NumTickets = 0
SQLNumTickets = "SELECT COUNT(OrderLine.LineNumber) AS TotalTix FROM OrderLine WITH (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event WITH (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') AND Event.SurveyNumber = " & SurveyNumber
Set rsNumTickets = OBJdbConnection.Execute(SQLNumTickets)
If Not rsNumTickets.EOF Then
    NumTickets = rsNumTickets("TotalTix")
End If
rsNumTickets.Close
Set rsNumTickets = Nothing

ReDim LineDetail(CInt(NumTickets))
ReDim LineNumbers(CInt(NumTickets))
ReDim EventDetail(CInt(NumTickets))
LineCounter = 1
SQLLineInfo = "SELECT Act.Act, Event.EventDate, ISNULL(DateSuppress.DateSuppress,'') AS DateSuppress, ISNULL(TimeSuppress.TimeSuppress,'') AS TimeSuppress, OrderLine.LineNumber, Section.Section, IsNull(Seat.Row,'') AS Row, Seat.Seat, SeatType.SeatType FROM Seat WITH (NOLOCK) INNER JOIN OrderLine WITH (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Event WITH (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN SeatType WITH (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN Section WITH (NOLOCK) ON Seat.SectionCode = Section.SectionCode AND Seat.EventCode = Section.EventCode INNER JOIN Act WITH (NOLOCK) ON Event.ActCode = Act.ActCode LEFT OUTER JOIN (SELECT EventCode, OptionValue AS DateSuppress FROM EventOptions WITH (NOLOCK) WHERE (OptionName = 'DateSuppress')) AS DateSuppress ON Event.EventCode = DateSuppress.EventCode LEFT OUTER JOIN (SELECT EventCode, OptionValue AS TimeSuppress FROM EventOptions AS EventOptions_2 WITH (NOLOCK) WHERE (OptionName = 'TimeSuppress')) AS TimeSuppress ON Event.EventCode = TimeSuppress.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') AND Event.SurveyNumber = " & SurveyNumber & " ORDER BY Event.EventDate, OrderLine.LineNumber"
Set rsLineInfo = OBJdbConnection.Execute(SQLLineInfo)
Do While Not rsLineInfo.EOF
    LineInfo = rsLineInfo("Section") & ", "
    If CStr(Trim(rsLineInfo("Row"))) <> "" Then
        LineInfo = LineInfo & "Row: " & rsLineInfo("Row") & ", "
    End If
    LineInfo = LineInfo & "Seat: " & rsLineInfo("Seat") & ", " & rsLineInfo("SeatType")
    LineDetail(LineCounter) = LineInfo
    LineNumbers(LineCounter) = CInt(rsLineInfo("LineNumber"))
    EventInfo = rsLineInfo("Act")
    If rsLineInfo("DateSuppress") <> "Y" Then
        EventInfo = EventInfo & " on " & FormatDateTime(rsLineInfo("EventDate"), vbShortDate)
    End If
    If rsLineInfo("TimeSuppress") <> "Y" Then
        EventInfo = EventInfo & " at " & Left(FormatDateTime(rsLineInfo("EventDate"),vbLongTime),Len(FormatDateTime(rsLineInfo("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsLineInfo("EventDate"),vbLongTime),3)
    End If
    EventDetail(LineCounter) = EventInfo
    LineCounter = LineCounter + 1
    rsLineInfo.movenext
Loop
rsLineInfo.Close
Set rsLineInfo = Nothing

Dim AnswersArray()
SQLCountLines = "SELECT ISNULL(COUNT(LineNumber), 0) AS TotalLines FROM OrderLineDetail WITH (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber")
Set rsCountLines = OBJdbConnection.Execute(SQLCountLines)
If Not rsCountLines.EOF Then
    ReDim AnswersArray(CInt(rsCountLines("TotalLines")), 2)
End If
rsCountLines.Close
Set rsCountLines = Nothing

index = 0
SQLLineDetail = "SELECT LineNumber, FieldName, FieldValue FROM OrderLineDetail WITH (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " ORDER BY LineNumber, FieldName, DetailNumber"
Set rsLineDetail = OBJdbConnection.Execute(SQLLineDetail)
Do While Not rsLineDetail.EOF
    AnswersArray(index, 0) = rsLineDetail("LineNumber")
    AnswersArray(index, 1) = rsLineDetail("FieldName")
    AnswersArray(index, 2) = rsLineDetail("FieldValue")
    index = index + 1
    rsLineDetail.movenext
Loop
rsLineDetail.Close
Set rsLineDetail = Nothing

If Clean(Request("FormName")) <> "SurveyForm" Then
    Call SurveyForm
Else
    Call UpdateSurveyAnswer
End If

Sub SurveyForm

answer_name_list = ""
answer_type_list = ""

'REE 9/19/8 - Added PageTopInclude
%>
<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->
<%

Response.Write "<TITLE>" & Title & "</TITLE>" & vbCrLf

For i = 1 To NumTickets
    SQLSurveyQues = "SELECT QuestionNumber, QuestionType FROM SurveyQuestion (NOLOCK) WHERE SurveyNumber= " & SurveyNumber & " AND QuestionRequired = 'Y' ORDER BY QuestionNumber"
    Set rsSurveyQues = OBJdbConnection.Execute(SQLSurveyQues)
    Do While Not rsSurveyQues.EOF
        answer_name_list = answer_name_list & "'Answer" & rsSurveyQues("QuestionNumber") & "_" & LineNumbers(i) & "',"
        answer_type_list = answer_type_list & "'" & rsSurveyQues("QuestionType") & "',"
        rsSurveyQues.movenext
    Loop
    rsSurveyQues.Close
    Set rsSurveyQues = Nothing
Next

If answer_name_list <> "" Then
    answer_name_list = Left(answer_name_list, len(answer_name_list) - 1)
    answer_type_list = Left(answer_type_list, len(answer_type_list) - 1)
End If
        
%>
<script language="javascript">
var answer_name = new Array (<%=answer_name_list%>);
var answer_type = new Array (<%=answer_type_list%>);

function validateForm() {
    var arrayLength = answer_name.length
    
    for (var i = 0; i < arrayLength; i++) {
        isAnswered = true
        switch(answer_type[i]) {
            case "checkbox":
                count = 0
                for (var x = 0 ; x < document.getElementsByName(answer_name[i]).length ; x++) {
                    if (document.getElementsByName(answer_name[i])[x].checked) {count++}
                }
                if (count == 0) {
                    isAnswered = false
                }
                break;
            case "radio":
                radioVal = getCheckedValue(document.getElementsByName(answer_name[i]))
                if( radioVal == "" ) {
                    isAnswered = false
                }
                break;
            case "select":
                if( document.getElementById(answer_name[i]).selectedIndex == 0 ) {
                    isAnswered = false
                }
                break;
            case "text":
                if( document.getElementById(answer_name[i]).value == "" ) {
                    isAnswered = false
                }
                break;
        }    
            
        if( isAnswered == false ) {
            alert("Please answer all questions that are required on this survey");
		    return false;
        }
    }
}
function getCheckedValue(radioObj) {
    if(!radioObj)
	    return "";
    var radioLength = radioObj.length;
    if(radioLength == undefined)
	    if(radioObj.checked)
		    return radioObj.value;
	    else
		    return "";
    for(var i = 0; i < radioLength; i++) {
	    if(radioObj[i].checked) {
		    return radioObj[i].value;
	    }
    }
    return "";
}
</script>

<link href="https://netdna.bootstrapcdn.com/twitter-bootstrap/2.3.1/css/bootstrap-combined.no-icons.min.css" rel="stylesheet">

<style>
.table {width: 60%;  font-family: Helvetica,Arial,sans-serif; font-size: medium;}
.table thead tr th { color: <%=TableCategoryFontColor%>; background: <%=TableCategoryBGColor%>; }
.table tbody tr td { color: <%=TableDataFontColor%>;  background: <%=TableDataBGColor%>; padding-top: 10px; padding-bottom: 10px;}
.table tbody tr td:first-child {text-align:right;}
</style>

<%
Response.Write "</HEAD>" & vbCrLf
Response.Write strBody & vbCrLf
%>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey"<% If answer_name_list <> "" Then %> onsubmit="return validateForm();"<% End If %>>
<INPUT TYPE="hidden" NAME="FormName" VALUE="SurveyForm">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">
<INPUT TYPE="hidden" NAME="SurveyNo" VALUE="<%= CleanNumeric(Request("SurveyNo")) %>">
<% If Request("SurveyRenew") = "Y" Then %>
<input type="hidden" name="SurveyRenew" value="Y" />
<% End If %>
<BR><BR>

<table class="table">
<% 
For j = 1 To NumTickets
    i = LineNumbers(j)
    Response.Write "<thead><tr><th colspan=""2""><h3>Attendee " & j & "</h3></th></tr></thead><tbody>" & vbCrLf
    SQLSurveyQues = "SELECT QuestionNumber, QuestionText, QuestionType, QuestionRequired FROM SurveyQuestion (NOLOCK) WHERE SurveyNumber= " & SurveyNumber & " ORDER BY IsNull(SortOrder,1), QuestionNumber"
    Set rsSurveyQues = OBJdbConnection.Execute(SQLSurveyQues)
    Call DBOpen(OBJdbConnection2)
    Do While Not rsSurveyQues.EOF
        IsRequired = ""
        If rsSurveyQues("QuestionRequired") = "Y" Then
            IsRequired = " *"
        End If
%>
	
    <tr>
        <td>
		<%=rsSurveyQues("QuestionText") & IsRequired%>
        <% If j = 1 Then %>        
        <input type="hidden" name="Question<%=rsSurveyQues("QuestionNumber")%>" value="<%=rsSurveyQues("QuestionText")%>" />
        <% End If %>
        </td>
		
		<td>
		<div class="controls">
<%
        SQLSurveyAns = "SELECT AnswerNumber, AnswerText, AnswerTextFieldIncluded FROM SurveyAnswer (NOLOCK) WHERE SurveyNumber = " & SurveyNumber & " AND QuestionNumber = " & rsSurveyQues("QuestionNumber") & " ORDER BY AnswerNumber"
        Set rsSurveyAns = OBJdbConnection2.Execute(SQLSurveyAns)
		
        'Only for question type of dropdown list
        If rsSurveyQues("QuestionType") = "select" Then
%>
        <select name="Answer<%=rsSurveyQues("QuestionNumber")%>_<%=i%>" id="Answer<%=rsSurveyQues("QuestionNumber")%>_<%=i%>">
          <option value="">- Select -</option>
<%        
        End If
		

				
        Do While Not rsSurveyAns.EOF
            If rsSurveyQues("QuestionType") = "checkbox" Or rsSurveyQues("QuestionType") = "radio" Then 
			
				Response.Write " <label class="""&rsSurveyQues("QuestionType")&"""> " & vbCrLf
				
                StoredAnswer = ""
                If GetLineAnswer(i, rsSurveyQues("QuestionText")) <> "" Then
                    AnswerArray = Split(GetLineAnswer(i, rsSurveyQues("QuestionText")), "|")
                    StrChecked = ""
                    For x = LBound(AnswerArray) To UBound(AnswerArray)
                        If InStr(AnswerArray(x), rsSurveyAns("AnswerText") & " - ") Then
                            StoredAnswer = Replace(AnswerArray(x), rsSurveyAns("AnswerText") & " - ", "")
                        End If
                        If CStr(rsSurveyAns("AnswerText")) = CStr(AnswerArray(x)) Or InStr(AnswerArray(x), rsSurveyAns("AnswerText") & " - ") Then
                            StrChecked = " checked=checked"
                            Exit For
                        End If
                    Next
                Else
                    StrChecked = ""
                End If
%>

			<%

			%>
			
			<INPUT TYPE="<%=rsSurveyQues("QuestionType")%>" NAME="Answer<%=rsSurveyQues("QuestionNumber")%>_<%=i%>" VALUE="<%=rsSurveyAns("AnswerText")%>"<% If StrChecked <> "" Then Response.Write StrChecked End If %>><%=rsSurveyAns("AnswerText")%></label class="3">
          <% If rsSurveyAns("AnswerTextFieldIncluded") = "Y" Then %><INPUT type="text" name="<%=rsSurveyAns("AnswerText")%>_<%=rsSurveyQues("QuestionNumber")%>_<%=i%>" value="<%=StoredAnswer%>" size="50" /></label class="4"><% End If %>
<%          ElseIf rsSurveyQues("QuestionType") = "text" Then 
                If GetLineAnswer(i, rsSurveyQues("QuestionText")) <> "" Then
                    StoredAnswer = GetLineAnswer(i, rsSurveyQues("QuestionText"))
                Else
                    StoredAnswer = ""
                End If
%>
          <%=rsSurveyAns("AnswerText")%>&nbsp;<INPUT TYPE="<%=rsSurveyQues("QuestionType")%>" NAME="Answer<%=rsSurveyQues("QuestionNumber")%>_<%=i%>" ID="Answer<%=rsSurveyQues("QuestionNumber")%>_<%=i%>" value="<%=StoredAnswer%>" size="50"></label class="2">
<%          Else 'dropdown list 
                If GetLineAnswer(i, rsSurveyQues("QuestionText")) <> "" Then
                    If CStr(rsSurveyAns("AnswerText")) = GetLineAnswer(i, rsSurveyQues("QuestionText")) Then
                        StrChecked = " selected=selected"
                    Else
                        StrChecked = ""
                    End If
                Else
                    StrChecked = ""
                End If
%>
          <option value="<%=rsSurveyAns("AnswerText")%>"<% If StrChecked <> "" Then Response.Write StrChecked End If %>><%=rsSurveyAns("AnswerText")%></option>
        <% End If %>
<%
            rsSurveyAns.movenext
        Loop
        rsSurveyAns.Close
        Set rsSurveyAns = Nothing
        
        'Only for question type of dropdown list
        If rsSurveyQues("QuestionType") = "select" Then
			Response.Write " </select>" & vbCrLf   			
        End If
		
		If rsSurveyQues("QuestionType") = "checkbox" Or rsSurveyQues("QuestionType") = "radio" Then 
		Response.Write " </label>" & vbCrLf  
		End If
%>
        </div>
		</td>
    </tr>
<%
        
        rsSurveyQues.movenext
    Loop
    Call DBClose(OBJdbConnection2)
    rsSurveyQues.Close
    Set rsSurveyQues = Nothing
Next
        
%>
<tr>
	<td> </td>
	<td>
		<% If answer_name_list <> "" Then %>
		* - Answer Required
		<% End If %>
	</td>
</tr>

<tr>
	<td> </td>
	<td>
		<%=SurveyFooter%>
	</td>
</tr>
</tbody>
</table>

<INPUT TYPE="submit" VALUE="Continue">
</FORM>

<!--#INCLUDE virtual="FooterInclude.asp"-->

<%

Response.Write "</BODY>" & vbCrLf
Response.Write "</HTML>" & vbCrLf

End Sub ' SurveyForm

'==================================================

Sub UpdateSurveyAnswer

If Session("OrderNumber") <> "" Then
    SQLCurQuesNo = "SELECT ISNULL(MAX(QuestionNumber),0) AS CurNo FROM SurveyQuestion (NOLOCK) WHERE SurveyNumber = " & SurveyNumber
    Set rsCurQuesNo = OBJdbConnection.Execute(SQLCurQuesNo)
    NumQuestions = rsCurQuesNo("CurNo")
    rsCurQuesNo.Close
    Set rsCurQuesNo = Nothing    

    'Delete all previous OrderLineDetail answers
    SQLDeleteAnswers = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND SurveyNumber = " & SurveyNumber
    Set rsDeleteAnswers = OBJdbConnection.Execute(SQLDeleteAnswers)

    For k = 1 To NumTickets
        y = LineNumbers(k)
        For AnswerNumber = 1 To NumQuestions
            If Clean(Request("Answer" & AnswerNumber & "_" & y)) <> "" Then
                For Each Item IN Request("Answer" & AnswerNumber & "_" & y)
			        If Item <> "" Then
                        AnswerValue = Trim(Item)
                        If Request(AnswerValue & "_" & AnswerNumber & "_" & y) <> "" Then
                            AnswerValue = AnswerValue & " - " & Request(AnswerValue & "_" & AnswerNumber & "_" & y)
                        End If
                        SQLInsertLine = "INSERT OrderLineDetail(OrderNumber,LineNumber,SurveyNumber,FieldName,FieldValue) VALUES(" & Session("OrderNumber") & "," & y & "," & SurveyNumber & ",'" & Clean(Request("Question" & AnswerNumber)) & "','" & Clean(AnswerValue) & "')"
                        Set rsInsertLine = OBJdbConnection.Execute(SQLInsertLine)
                    End If
                Next
            End If
        Next
    Next
    
	If Session("UserNumber") = "" Then
		'REE 4/19/3 - Modified to use Session Variable for SurveyComplete
		Session("SurveyComplete") = Session("OrderNumber")
		If Request("SurveyRenew") <> "Y" Then
		    Response.Redirect("/Ship.asp")
		Else
		    Response.Redirect("/Pay.asp")
		End If
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

Function GetLineAnswer(counter,Question)
    AnswerValues = ""
        
    If index = 0 Then
        GetLineAnswer = AnswerValues
        Exit Function
    End If
        
    For i = LBound(AnswersArray) To UBound(AnswersArray)
        If CInt(counter) = CInt(AnswersArray(i, 0)) And CStr(Question) = CStr(AnswersArray(i, 1)) Then
            AnswerValues = AnswerValues & AnswersArray(i, 2) & "|"
        End If
    Next
        
    If AnswerValues <> "" Then
        AnswerValues = Left(AnswerValues, Len(AnswerValues) - 1)
    End If
        
    GetLineAnswer = AnswerValues
End Function
%>