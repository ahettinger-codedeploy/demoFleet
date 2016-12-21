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

<FONT FACE=verdana,arial,helvetica COLOR=#008400><H3>Custom Survey Report</H3></FONT>
<FONT FACE=verdana,arial,helvetica SIZE=2>
<%
'REE 3/16/7 - Added Output to Excel option
If Excel <> "Y" Then 

	Response.Write "<FORM ACTION=""ConferenceReport2010.asp"" METHOD=""post"" NAME=""Report"" onsubmit=""return ValidateForm()"">" & vbCrLf
	
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

	SQLSurveyAnswers = "SELECT DISTINCT OrderLineDetail.OrderNumber, OrderLineDetail.LineNumber, OrderHeader.OrderDate, Customer.CustomerNumber, Customer.FirstName, Customer.LastName, OrderLineDetail.FieldName AS Question, OrderLineDetail.FieldValue AS Answer FROM OrderHeader (NOLOCK) INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN OrderLineDetail (NOLOCK) ON OrderHeader.OrderNumber = OrderLineDetail.OrderNumber INNER JOIN OrderLine (Nolock) ON OrderHeader.OrderNumber = OrderLine.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " WHERE OrderHeader.OrderDate >= '" & ReportStartDate & "' AND OrderHeader.OrderDate < '" & ReportEndDate + 1 & "' AND OrderHeader.StatusCode = 'S' ORDER BY OrderLineDetail.OrderNumber, OrderLineDetail.LineNumber, OrderLineDetail.FieldName, OrderHeader.OrderDate"
	Set rsSurveyAnswers = OBJdbConnection.Execute(SQLSurveyAnswers)
	
	If Not rsSurveyAnswers.EOF Then

		Response.Write "<TABLE CELLPADDING=5>" & vbCrLf
		Response.Write "<TR BGCOLOR=#008400><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><B>Order Number</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><B>Order Date</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><B>Customer Name</B></FONT></TD><TD ALIGN=center NOWRAP><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><B>Survey Questions/Answers</B></FONT></TD></TR>" & vbCrLf

		OrderNum = -1
		LineNum = -1
		SurveyResults = ""
		
		Do Until rsSurveyAnswers.EOF            
            
            If OrderNum <> rsSurveyAnswers("OrderNumber") Or LineNum <> rsSurveyAnswers("LineNumber") Then			    
			    SurveyResults = ""
			    OrderDt = rsSurveyAnswers("OrderDate")
			    CustomerNo = rsSurveyAnswers("CustomerNumber")
			    FN = rsSurveyAnswers("FirstName")
			    LN = rsSurveyAnswers("LastName")
			    OrderNum = rsSurveyAnswers("OrderNumber")
			    LineNum = rsSurveyAnswers("LineNumber")
			End If			
			
			SurveyResults = SurveyResults & "<B>" & rsSurveyAnswers("Question") & "</B> - " & rsSurveyAnswers("Answer") & "<BR>"
			
			'REE 2/23/9 - Added Response Flush to prevent Response Buffer overflow.
            RecordCount = RecordCount + 1
		    PageBuffer = PageBuffer + 1    		
		    If PageBuffer >=100 Then	
			    Response.Flush
			    PageBuffer = 0
		    End If
    		
		    rsSurveyAnswers.MoveNext
		    
		    If Not rsSurveyAnswers.EOF Then
		        If OrderNum <> rsSurveyAnswers("OrderNumber") Or LineNum <> rsSurveyAnswers("LineNumber") Then
		            'REE 3/16/7 - Added Output to Excel option
			        If Excel <> "Y" Then
			            Response.Write "<TR BGCOLOR=#DDDDDD><TD ALIGN=""center""><FONT FACE='verdana,arial,helvetica' SIZE=2><A HREF=""/Reports/OrderDetails.asp?OrderNumber=" & OrderNum & """>" & OrderNum & "</A></FONT></TD><TD ALIGN=""center""><FONT FACE='verdana,arial,helvetica' SIZE=2>" & FormatDateTime(OrderDt, vbShortDate) & "</FONT></TD><TD ALIGN=""left"" NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2><A HREF=/Reports/CustomerDetails.asp?CustomerNumber=" & CustomerNo & ">" & FN & " " & LN & "</A></FONT></TD><TD ALIGN=""left"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>" & SurveyResults & "</FONT></TD></TR>" & vbCrLf
		            Else
			            Response.Write "<TR BGCOLOR=#DDDDDD><TD ALIGN=""center"" VALIGN=""top""><FONT FACE='verdana,arial,helvetica' SIZE=2>" & OrderNum & "</FONT></TD><TD ALIGN=""center"" VALIGN=""top""><FONT FACE='verdana,arial,helvetica' SIZE=2>" & FormatDateTime(OrderDt, vbShortDate) & "</FONT></TD><TD ALIGN=""left"" VALIGN=""top"" NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & FN & " " & LN & "</FONT></TD><TD ALIGN=""left"" VALIGN=""top"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>" & SurveyResults & "</FONT></TD></TR>" & vbCrLf
		            End If
		        End If
		    Else
		        'REE 3/16/7 - Added Output to Excel option
		        If Excel <> "Y" Then
			        Response.Write "<TR BGCOLOR=#DDDDDD><TD ALIGN=""center""><FONT FACE='verdana,arial,helvetica' SIZE=2><A HREF=""/Reports/OrderDetails.asp?OrderNumber=" & OrderNum & """>" & OrderNum & "</A></FONT></TD><TD ALIGN=""center""><FONT FACE='verdana,arial,helvetica' SIZE=2>" & FormatDateTime(OrderDt, vbShortDate) & "</FONT></TD><TD ALIGN=""left"" NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2><A HREF=/Reports/CustomerDetails.asp?CustomerNumber=" & CustomerNo & ">" & FN & " " & LN & "</A></FONT></TD><TD ALIGN=""left"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>" & SurveyResults & "</FONT></TD></TR>" & vbCrLf
		        Else
			        Response.Write "<TR BGCOLOR=#DDDDDD><TD ALIGN=""center"" VALIGN=""top""><FONT FACE='verdana,arial,helvetica' SIZE=2>" & OrderNum & "</FONT></TD><TD ALIGN=""center"" VALIGN=""top""><FONT FACE='verdana,arial,helvetica' SIZE=2>" & FormatDateTime(OrderDt, vbShortDate) & "</FONT></TD><TD ALIGN=""left"" VALIGN=""top"" NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & FN & " " & LN & "</FONT></TD><TD ALIGN=""left"" VALIGN=""top"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>" & SurveyResults & "</FONT></TD></TR>" & vbCrLf
		        End If
		    End If
			
		Loop

		Response.Write "</TABLE>" & vbCrLf
	Else
		Response.Write "There are no survey responses for this date range."
	End If	
	
	rsSurveyAnswers.Close
	Set rsSurveyAnswers = nothing
				
End If

%>

</FONT>
<%
If Excel <> "Y" Then
%>
<!--#INCLUDE VIRTUAL="FooterInclude.asp" -->
<%
End If
%>
</CENTER>
</BODY>
</HTML>
