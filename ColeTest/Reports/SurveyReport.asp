<!--#include virtual="GlobalInclude.asp"-->
<!--#include virtual="dbOpenInclude.asp"-->
<%
Page = "ManagementReport"
'Server.ScriptTimeout = 300

If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then Response.Redirect("/Management/Default.asp")

If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then Response.Redirect("/Management/Default.asp")

Excel = Clean(Request("ExcelOutput"))

'REE 3/16/7 - Added Output to Excel option
If Excel = "Y" Then

	Response.ContentType = "application/vnd.ms-excel"

End If

%>
<HTML>
<HEAD>
<TITLE>Tix - Survey Report</TITLE>
<SCRIPT LANGUAGE="JavaScript">    

<!-- Hide code from non-js browsers


function isDate (day,month,year) {
   var dateStr = month + '/' + day + '/' + year
   var objDate = new Date (dateStr);
   if (month != objDate.getMonth() + 1) return false;
   if (day != objDate.getDate()) return false;
   if (year != objDate.getFullYear()) return false;

   return true;
} 

function ValidateForm()
{
	formObj = document.Report;
	if (!isDate(formObj.ReportStartDay.options[formObj.ReportStartDay.selectedIndex].value, formObj.ReportStartMonth.options[formObj.ReportStartMonth.selectedIndex].value, formObj.ReportStartYear.options[formObj.ReportStartYear.selectedIndex].value))
		{alert("Invalid Start Date");
		formObj.ReportStartMonth.focus();
	    return false;
	    }
	if (!isDate(formObj.ReportEndDay.options[formObj.ReportEndDay.selectedIndex].value, formObj.ReportEndMonth.options[formObj.ReportEndMonth.selectedIndex].value, formObj.ReportEndYear.options[formObj.ReportEndYear.selectedIndex].value))
		{alert("Invalid End Date");
		formObj.ReportEndMonth.focus();
	    return false;
	    }
}

// end hiding -->
</SCRIPT>
</HEAD>
<BODY BGCOLOR="#FFFFFF">
<CENTER>

<%
If Excel <> "Y" Then
%>
<!--#include virtual="TopNavInclude.asp" -->
<%
End If
%>

<BR>

<BR>

<FONT FACE=verdana,arial,helvetica COLOR=#008400><H3>Survey Report</H3></FONT>
<FONT FACE=verdana,arial,helvetica SIZE=2>
<%
'REE 3/16/7 - Added Output to Excel option
If Excel <> "Y" Then 

	Response.Write "<FORM ACTION=""SurveyReport.asp"" METHOD=""post"" NAME=""Report"" onsubmit=""return ValidateForm()"">" & vbCrLf
	
	Response.Write "<TABLE CELLPADDING=5><TR>"
	Response.Write "<TD><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Start Date</B></FONT></TD><TD><SELECT NAME=ReportStartMonth>"
	For i = 1 to 12
	  If i <> Month(Date) Then
	    Response.Write "<OPTION VALUE=" & i & ">" & MonthName(i) & "</OPTION>" & vbCrLf
	  Else
	    Response.Write "<OPTION SELECTED VALUE=" & i & ">" & MonthName(i) & "</OPTION>" & vbCrLf
	  End If
	Next
	Response.Write "</SELECT></TD>"

	Response.Write "<TD><SELECT NAME=ReportStartDay>"
	For i= 1 to 31
	  If i <> Day(Date) Then
	    Response.Write "<OPTION VALUE=" & i & ">" & i & "</OPTION>" & vbCrLf
	  Else
	    Response.Write "<OPTION SELECTED VALUE=" & i & ">" & i & "</OPTION>" & vbCrLf
	  End If
	Next
	Response.Write "</SELECT></TD>"

	Response.Write "<TD><SELECT NAME=ReportStartYear>"
    'REE 1/29/9 - Modified to use years going back to 2001
    For ReportYear = 2001 To Year(Date)
        If ReportYear = Year(Date) Then
            Selected = "SELECTED "
        Else
            Selected = ""
        End If
        Response.Write "<OPTION " & Selected & "VALUE=""" & ReportYear & """>" & ReportYear & "</OPTION>" & vbCrLf
    Next
	Response.Write "</SELECT></TD></TR>" & vbCrLf

	Response.Write "<TD><FONT FACE='verdana,arial,helvetica' SIZE=2><B>End Date</B></FONT></TD><TD><SELECT NAME=ReportEndMonth>"
	For i = 1 to 12
	  If i <> Month(Date) Then
	    Response.Write "<OPTION VALUE=" & i & ">" & MonthName(i) & "</OPTION>" & vbCrLf
	  Else
	    Response.Write "<OPTION SELECTED VALUE=" & i & ">" & MonthName(i) & "</OPTION>" & vbCrLf
	  End If
	Next
	Response.Write "</SELECT></TD>"

	Response.Write "<TD><SELECT NAME=ReportEndDay>"
	For i= 1 to 31
	  If i <> Day(Date) Then
	    Response.Write "<OPTION VALUE=" & i & ">" & i & "</OPTION>" & vbCrLf
	  Else
	    Response.Write "<OPTION SELECTED VALUE=" & i & ">" & i & "</OPTION>" & vbCrLf
	  End If
	Next
	Response.Write "</SELECT></TD>"

	Response.Write "<TD><SELECT NAME=ReportEndYear>"
    'REE 1/29/9 - Modified to use years going back to 2001
    For ReportYear = 2001 To Year(Date)
        If ReportYear = Year(Date) Then
            Selected = "SELECTED "
        Else
            Selected = ""
        End If
        Response.Write "<OPTION " & Selected & "VALUE=""" & ReportYear & """>" & ReportYear & "</OPTION>" & vbCrLf
    Next
	Response.Write "</SELECT></TD></TR>" & vbCrLf

	Response.Write "</TABLE><BR>" & vbCrLf

	'REE 3/16/7 - Added Output to Excel option
	Response.Write "<TABLE><TR><TD><INPUT TYPE=""checkbox"" NAME=""ExcelOutput"" VALUE=""Y""></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2>Output To Excel</FONT></TD></TR></TABLE><BR>" & vbCrLf

	Response.Write "<INPUT TYPE=submit VALUE=Enter></FORM><BR><BR>" & vbCrLf

End If	


SQLOrganization = "SELECT Organization FROM Organization (NOLOCK) WHERE OrganizationNumber = " & Session("OrganizationNumber")
Set rsOrganization = OBJdbConnection.Execute(SQLOrganization)

If Request("ReportStartMonth") <> "" Then
	ReportStartDate = CDate(Request("ReportStartMonth") & "/" & Request("ReportStartDay") & "/" & Request("ReportStartYear"))
	ReportEndDate = CDate(Request("ReportEndMonth") & "/" & Request("ReportEndDay") & "/" & Request("ReportEndYear"))

	Response.Write "<FONT FACE='verdana,arial,helvetica' SIZE=2><B>" & rsOrganization("Organization") & "</B></FONT><BR>" & vbCrLf
	Response.Write "<FONT FACE='verdana,arial,helvetica' SIZE=2><B> Survey Report From " & ReportStartDate & " Through " &  ReportEndDate & "</B></FONT><BR><BR>" & vbCrLf

	If Session("OrganizationNumber") = 1 Then 'It's Tix.  Show all Organizations.
		SQLSurveyAnswers = "SELECT SurveyAnswers.OrderNumber, SurveyAnswers.SurveyDate, Customer.CustomerNumber, Customer.FirstName, Customer.LastName, SurveyAnswers.Question, SurveyAnswers.Answer FROM SurveyAnswers (NOLOCK) INNER JOIN Customer (NOLOCK) ON SurveyAnswers.CustomerNumber = Customer.CustomerNumber INNER JOIN Survey (NOLOCK) ON SurveyAnswers.SurveyNumber = Survey.SurveyNumber INNER JOIN OrderHeader (NOLOCK) ON SurveyAnswers.OrderNumber = OrderHeader.OrderNumber WHERE SurveyAnswers.SurveyDate >= '" & ReportStartDate & "' AND SurveyAnswers.SurveyDate < '" & ReportEndDate + 1 & "' AND OrderHeader.StatusCode = 'S' ORDER BY SurveyAnswers.OrderNumber, SurveyDate"
	Else
		'JAI 10/19/6 - Changed Criteria to display Survey for all associated organizations, not just the Owner.
		'SQLSurveyAnswers = "SELECT SurveyAnswers.OrderNumber, SurveyAnswers.SurveyDate, Customer.CustomerNumber, Customer.FirstName, Customer.LastName, SurveyAnswers.Question, SurveyAnswers.Answer FROM SurveyAnswers (NOLOCK) INNER JOIN Customer (NOLOCK) ON SurveyAnswers.CustomerNumber = Customer.CustomerNumber INNER JOIN Survey (NOLOCK) ON SurveyAnswers.SurveyNumber = Survey.SurveyNumber INNER JOIN OrderHeader (NOLOCK) ON SurveyAnswers.OrderNumber = OrderHeader.OrderNumber WHERE Survey.OrganizationNumber = " & Session("OrganizationNumber") & " AND SurveyAnswers.SurveyDate >= '" & ReportStartDate & "' AND SurveyAnswers.SurveyDate < '" & ReportEndDate + 1 & "' AND OrderHeader.StatusCode = 'S' ORDER BY SurveyAnswers.OrderNumber, SurveyDate"
		SQLSurveyAnswers = "SELECT DISTINCT SurveyAnswers.OrderNumber, SurveyAnswers.SurveyDate, Customer.CustomerNumber, Customer.FirstName, Customer.LastName FROM SurveyAnswers (NOLOCK) INNER JOIN Customer (NOLOCK) ON SurveyAnswers.CustomerNumber = Customer.CustomerNumber INNER JOIN OrderHeader (NOLOCK) ON SurveyAnswers.OrderNumber = OrderHeader.OrderNumber INNER JOIN OrderLine (Nolock) ON OrderHeader.OrderNumber = OrderLine.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " WHERE SurveyAnswers.SurveyDate >= '" & ReportStartDate & "' AND SurveyAnswers.SurveyDate < '" & ReportEndDate + 1 & "' AND OrderHeader.StatusCode = 'S' GROUP BY SurveyAnswers.OrderNumber, SurveyAnswers.SurveyDate, Customer.CustomerNumber, Customer.FirstName, Customer.LastName ORDER BY SurveyAnswers.OrderNumber, SurveyDate"
	End If
	
	Set rsSurveyAnswers = OBJdbConnection.Execute(SQLSurveyAnswers)
	
	If Not rsSurveyAnswers.EOF Then
		
	    Call DBOpen(OBJdbConnection2)
	    
		'get the maximum number of questions on all surveys belong to this Organization
		SQLMaxQues = "SELECT MAX(AnswerNumber) AS MaxQues FROM SurveyAnswers (NOLOCK) WHERE SurveyNumber IN(SELECT SurveyNumber FROM Survey (NOLOCK) WHERE OrganizationNumber = " & Session("OrganizationNumber") & ") GROUP BY SurveyNumber ORDER BY MaxQues DESC"
		Set rsMaxQues = OBJdbConnection2.Execute(SQLMaxQues)
		MaxQuestions = rsMaxQues("MaxQues")
		rsMaxQues.Close
		Set rsMaxQues = Nothing

		Response.Write "<TABLE CELLPADDING=5>" & vbCrLf
		
		'write out the row heading
		Response.Write "<TR BGCOLOR=#008400><TD ALIGN=center nowrap><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><B>Order Number</B></FONT></TD><TD ALIGN=center nowrap><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><B>Survey Date</B></FONT></TD><TD ALIGN=center nowrap><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><B>Customer Name</B></FONT></TD>"
        For i = 1 to MaxQuestions
            Response.Write "<TD ALIGN=center nowrap><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><B>Question " & i & "</B></FONT></TD>"
        Next
        Response.Write "</TR>" & vbCrLf
        
        'use array to store answers
        Dim AnswerArray(25)		
		
		Do Until rsSurveyAnswers.EOF
		
		    'get answers and store them - use this looping approach or else we couldn't get multiple answers for each question
		    For i = 1 to MaxQuestions
		        SQLSurveyInfo = "SELECT isnull(Answer,'') AS Answer FROM SurveyAnswers (NOLOCK) WHERE AnswerNumber = " & i & " AND OrderNumber = " & rsSurveyAnswers("OrderNumber")
		        Set rsSurveyInfo = OBJdbConnection2.Execute(SQLSurveyInfo)
		        If Not rsSurveyInfo.EOF Then
		            SurveyAnsStr = ""
		            Do While Not rsSurveyInfo.EOF
		                SurveyAnsStr = SurveyAnsStr & rsSurveyInfo("Answer") & "<BR>"
		                rsSurveyInfo.movenext		                
		            Loop
		            SurveyAnsStr = Left(SurveyAnsStr,len(SurveyAnsStr)-4)
		            AnswerArray(i) = SurveyAnsStr
		        Else 'no answer found
		            AnswerArray(i) = ""
		        End If
		        rsSurveyInfo.Close
		        Set rsSurveyInfo = Nothing    
		    Next

			'REE 3/16/7 - Added Output to Excel option
			If Excel <> "Y" Then
				Response.Write "<TR BGCOLOR=#DDDDDD><TD ALIGN=""center""><FONT FACE='verdana,arial,helvetica' SIZE=2><A HREF=""/Reports/OrderDetails.asp?OrderNumber=" & rsSurveyAnswers("OrderNumber") & """>" & rsSurveyAnswers("OrderNumber") & "</A></FONT></TD><TD ALIGN=""center""><FONT FACE='verdana,arial,helvetica' SIZE=2>" & FormatDateTime(rsSurveyAnswers("SurveyDate"), vbShortDate) & "</FONT></TD><TD ALIGN=""left"" NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2><A HREF=""/Reports/CustomerDetails.asp?CustomerNumber=" & rsSurveyAnswers("CustomerNumber") & """>" & rsSurveyAnswers("FirstName") & " " & rsSurveyAnswers("LastName") & "</A></FONT></TD>"
			Else
				Response.Write "<TR BGCOLOR=#DDDDDD><TD ALIGN=""center""><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsSurveyAnswers("OrderNumber") & "</FONT></TD><TD ALIGN=""center""><FONT FACE='verdana,arial,helvetica' SIZE=2>" & FormatDateTime(rsSurveyAnswers("SurveyDate"), vbShortDate) & "</FONT></TD><TD ALIGN=""left"" NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSurveyAnswers("FirstName") & " " & rsSurveyAnswers("LastName") & "</FONT></TD>"
			End If
			
			'display answers in array
			For i = 1 to MaxQuestions
			    Response.Write "<TD ALIGN=""left"" NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & AnswerArray(i) & "</FONT></TD>"
			Next
			
			Response.Write "</TR>" & vbCrLf
			
			'clear array after displaying answers for each order
			Erase AnswerArray
			
			'REE 2/23/9 - Added Response Flush to prevent Response Buffer overflow.
            RecordCount = RecordCount + 1
		    PageBuffer = PageBuffer + 1
    		
		    If PageBuffer >=100 Then	
			    Response.Flush
			    PageBuffer = 0
		    End If
    		
		    rsSurveyAnswers.MoveNext
			
		Loop

		Response.Write "</TABLE>" & vbCrLf
		
		Call DBClose(OBJdbConnection2)
	Else
		Response.Write "There are no survey responses for this date range."
	End If	
	
	rsSurveyAnswers.Close
	Set rsSurveyAnswers = nothing
				
End If

%>

</FONT>

<!--#INCLUDE VIRTUAL="FooterInclude.asp" -->

</CENTER>
</BODY>
</HTML>
