<!--#include virtual="GlobalInclude.asp"-->
<!--#include virtual="dbOpenInclude.asp"-->
<%
Page = "ManagementReport"
'Server.ScriptTimeout = 300

If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then Response.Redirect("/Management/Default.asp")

If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then Response.Redirect("/Management/Default.asp")

IncludeCustomerContactInfo = Clean(Request("IncludeCustomerContactInfo"))
IncludeSurveyResults = Clean(Request("IncludeSurveyResults"))
IncludeOrderNotes = Clean(Request("IncludeOrderNotes"))
Excel = Clean(Request("ExcelOutput"))

If Excel = "Y" Then
	Response.ContentType = "application/vnd.ms-excel"
	LineBreak = ""
Else
	LineBreak = "<BR>"
End If
%>
<HTML>
<HEAD>
<TITLE>Tix - Donation/Membership Report</TITLE>

<%
If Excel <> "Y" Then
%>
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
<%
End If
%>

<style type="text/css">
<!--
a.sort:link  {color: #FFFFFF; font-weight: bold; text-decoration: underline;}
a.sort:visited  {color: #FFFFFF; font-weight: bold; text-decoration: underline;}
a.sort:active  {color: #FFFFFF; font-weight: bold; text-decoration: underline;}
a.sort:hover  {color: #FFFFFF; font-weight: bold; text-decoration: underline;}
-->
</style>
</HEAD>
<BODY BGCOLOR="#FFFFFF">
<CENTER>

<%
If Excel <> "Y" Then
%>

	<!--#include virtual="TopNavInclude.asp" -->
	<BR>
	<BR>

	<FONT FACE=verdana,arial,helvetica COLOR=#008400><H3>Donation/Membership Report</H3></FONT>
	<FONT FACE=verdana,arial,helvetica SIZE=2>
	<FORM ACTION="DonationReport.asp" METHOD="post" NAME="Report" onsubmit="return ValidateForm()">
	<%

	Response.Write "<TABLE CELLPADDING=5><TR VALIGN=TOP>"
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

	Response.Write "<TABLE ALIGN=CENTER CELLPADDING=0 CELLSPACING=1><TR VALIGN=TOP>" & vbCrLf
	If Request("IncludeCustomerContactInfo") = "Y" Then CustomerContactInfoChecked = " CHECKED"
	Response.Write "<TD><INPUT TYPE=""checkbox"" NAME=""IncludeCustomerContactInfo""" & CustomerContactInfoChecked & " VALUE=""Y""></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2>Include Customer Contact Information</FONT></TD></TR><TR VALIGN=TOP>" & vbCrLf
	'JAI 12/20/7 - Added option to include order notes
	If Request("IncludeSurveyResults") = "Y" Then SurveyResultsChecked = " CHECKED"
	Response.Write "<TD><INPUT TYPE=""checkbox"" NAME=""IncludeSurveyResults""" & SurveyResultsChecked & " VALUE=""Y""></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2>Include Survey Results</FONT></TD></TR><TR VALIGN=TOP>" & vbCrLf
	If Request("IncludeOrderNotes") = "Y" Then OrderNotesChecked = " CHECKED"
	Response.Write "<TD><INPUT TYPE=""checkbox"" NAME=""IncludeOrderNotes""" & OrderNotesChecked & " VALUE=""Y""></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2>Include Order Notes</FONT></TD></TR><TR VALIGN=TOP>" & vbCrLf
	If Request("ExcelOutput") = "Y" Then ExcelOutput = " CHECKED"
	Response.Write "<TD><INPUT TYPE=""checkbox"" NAME=""ExcelOutput""" & ExcelOutput & " VALUE=""Y""></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2>Output To Excel</FONT></TD></TR><TR VALIGN=TOP>" & vbCrLf
	Response.Write "</TR></TABLE><BR>" & vbCrLf

	Response.Write "<INPUT TYPE=submit VALUE=Enter></FORM><BR><BR>" & vbCrLf
	
End If 'If Not Excel

If Clean(Request("ReportStartMonth")) <> "" Then
	ReportStartDate = CDate(Clean(Request("ReportStartMonth")) & "/" & Clean(Request("ReportStartDay")) & "/" & Clean(Request("ReportStartYear")))
	ReportEndDate = CDate(Clean(Request("ReportEndMonth")) & "/" & Clean(Request("ReportEndDay")) & "/" & Clean(Request("ReportEndYear")))
	
	Select Case Clean(Request("SortMethod"))
	Case "OrderDate"
		SortBy = "OrderLine.StatusDate, OrderHeader.OrderNumber"
	Case "CustomerName"
		SortBy = "Customer.LastName, Customer.FirstName, OrderHeader.OrderNumber"
	Case "Organization"
		SortBy = "Organization"
	Case "Amount"
		SortBy = "OrderLine.Price - OrderLine.Discount"
	Case "TenderType"
		SortBy = "COUNT(DISTINCT Tender.TenderNumber), MIN(TenderType.TenderType)"
	Case "OrderType"
		SortBy = "OrderType, OrderHeader.OrderNumber"
	Case Else
		SortBy = "OrderHeader.OrderNumber"
	End Select
		
	'REE 3/14/6 - Changed to use OrderLine.StatusDate rather than OrderHeader.OrderDate
	SQLDonations = "SELECT OrderHeader.OrderNumber, OrderLine.StatusDate, Customer.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, Customer.DayPhone, Customer.NightPhone, Customer.EMailAddress, Organization.Organization, Donation.Description, OrderLine.Price - OrderLine.Discount AS DonationAmount, OrderType, COUNT(DISTINCT Tender.TenderNumber) AS TenderCount, MIN(TenderType.TenderType) AS TenderType FROM OrderLine (NOLOCK) INNER JOIN Donation (NOLOCK) ON OrderLine.ItemNumber = Donation.ItemNumber INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN Organization (NOLOCK) ON Donation.OrganizationNumber = Organization.OrganizationNumber LEFT OUTER JOIN (SELECT OrderNumber, TenderNumber FROM Tender(NOLOCK)) AS Tender ON OrderHeader.OrderNumber = Tender.OrderNumber LEFT OUTER JOIN TenderType(NOLOCK) ON Tender.TenderNumber = TenderType.TenderNumber LEFT JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber WHERE (Donation.OrganizationNumber = " & Session("OrganizationNumber") & " OR Donation.RemittalOrganizationNumber = " & Session("OrganizationNumber") & " OR " & Session("OrganizationNumber") & " = 1) AND OrderLine.ItemType = 'Donation' AND OrderLine.StatusCode = 'S' AND OrderLine.StatusDate >= '" & ReportStartDate & "' AND OrderLine.StatusDate < '" & ReportEndDate + 1 & "' GROUP BY OrderHeader.OrderNumber, OrderLine.StatusDate, Customer.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, Customer.DayPhone, Customer.NightPhone, Customer.EMailAddress, Organization.Organization, Donation.Description, OrderLine.Price - OrderLine.Discount, OrderType ORDER BY " & SortBy
	Set rsDonations = OBJdbConnection.Execute(SQLDonations)

	Response.Write "<FONT FACE='verdana,arial,helvetica' SIZE=2><B>Donations/Memberships From " & ReportStartDate & " Through " &  ReportEndDate & "</B></FONT><BR><BR>" & vbCrLf
	If Not rsDonations.EOF Then
	
		If IncludeCustomerContactInfo = "Y" Then
			CustomerContactHeader = "<TD ALIGN=center NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Address 1</B></FONT></TD><TD ALIGN=center NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Address 2</B></FONT></TD><TD ALIGN=center NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>City</B></FONT></TD><TD ALIGN=center NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>State/Province</B></FONT></TD><TD ALIGN=center NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Postal Code</B></FONT></TD><TD ALIGN=center NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Country</B></FONT></TD><TD ALIGN=center NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Daytime Phone</B></FONT></TD><TD ALIGN=center NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Evening Phone</B></FONT></TD><TD ALIGN=center NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>E-Mail Address</B></FONT></TD>"
		Else
			CustomerContactHeader = ""
		End If			
		
		If IncludeSurveyResults = "Y" Then
			SurveyResultsHeader = "<TD ALIGN=center NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Survey<BR>Results</B></FONT></TD>"
		Else
			SurveyResultsHeader = ""
		End If			
		
		If IncludeOrderNotes = "Y" Then
			OrderNotesHeader = "<TD ALIGN=center NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Order<BR>Notes</B></FONT></TD>"
		Else
			OrderNotesHeader = ""
		End If			
		
		If Excel <> "Y" Then 'Include links.
			Response.Write "<TABLE CELLPADDING=""3""><TR VALIGN=TOP BGCOLOR=""#008400""><TD ALIGN=center NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><A class=sort HREF=DonationReport.asp?SortMethod=OrderNumber&ExcelOutput=" & Request("ExcelOutput") & "&ReportStartMonth=" & Request("ReportStartMonth") & "&ReportStartDay=" & Request("ReportStartDay") & "&ReportStartYear=" & Request("ReportStartYear") & "&ReportEndMonth=" & Request("ReportEndMonth") & "&ReportEndDay=" & Request("ReportEndDay") & "&ReportEndYear=" & Request("ReportEndYear") & "&IncludeCustomerContactInfo=" & IncludeCustomerContactInfo & "&IncludeSurveyResults=" & IncludeSurveyResults & "&IncludeOrderNotes=" & IncludeOrderNotes & "><B>Order<BR>Number</B></A></FONT></TD><TD ALIGN=center NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><A class=sort HREF=DonationReport.asp?SortMethod=OrderDate&ExcelOutput=" & Request("ExcelOutput") & "&ReportStartMonth=" & Request("ReportStartMonth") & "&ReportStartDay=" & Request("ReportStartDay") & "&ReportStartYear=" & Request("ReportStartYear") & "&ReportEndMonth=" & Request("ReportEndMonth") & "&ReportEndDay=" & Request("ReportEndDay") & "&ReportEndYear=" & Request("ReportEndYear") & "&IncludeCustomerContactInfo=" & IncludeCustomerContactInfo & "&IncludeSurveyResults=" & IncludeSurveyResults & "&IncludeOrderNotes=" & IncludeOrderNotes & "><B>Order<BR>Date/Time</B></A></FONT></TD><TD ALIGN=center NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><A class=sort HREF=DonationReport.asp?SortMethod=CustomerName&ExcelOutput=" & Request("ExcelOutput") & "&ReportStartMonth=" & Request("ReportStartMonth") & "&ReportStartDay=" & Request("ReportStartDay") & "&ReportStartYear=" & Request("ReportStartYear") & "&ReportEndMonth=" & Request("ReportEndMonth") & "&ReportEndDay=" & Request("ReportEndDay") & "&ReportEndYear=" & Request("ReportEndYear") & "&IncludeCustomerContactInfo=" & IncludeCustomerContactInfo & "&IncludeSurveyResults=" & IncludeSurveyResults & "&IncludeOrderNotes=" & IncludeOrderNotes & "><B>Customer<BR>Name</B></A></FONT></TD>" & CustomerContactHeader & "<TD ALIGN=center NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><A class=sort HREF=DonationReport.asp?SortMethod=Organization&ExcelOutput=" & Request("ExcelOutput") & "&ReportStartMonth=" & Request("ReportStartMonth") & "&ReportStartDay=" & Request("ReportStartDay") & "&ReportStartYear=" & Request("ReportStartYear") & "&ReportEndMonth=" & Request("ReportEndMonth") & "&ReportEndDay=" & Request("ReportEndDay") & "&ReportEndYear=" & Request("ReportEndYear") & "&IncludeCustomerContactInfo=" & IncludeCustomerContactInfo & "&IncludeSurveyResults=" & IncludeSurveyResults & "&IncludeOrderNotes=" & IncludeOrderNotes & "><B>Organization</B></A></FONT></TD><TD ALIGN=center NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Description</B></FONT></TD><TD ALIGN=center NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><A class=sort HREF=DonationReport.asp?SortMethod=Amount&ExcelOutput=" & Request("ExcelOutput") & "&ReportStartMonth=" & Request("ReportStartMonth") & "&ReportStartDay=" & Request("ReportStartDay") & "&ReportStartYear=" & Request("ReportStartYear") & "&ReportEndMonth=" & Request("ReportEndMonth") & "&ReportEndDay=" & Request("ReportEndDay") & "&ReportEndYear=" & Request("ReportEndYear") & "&IncludeCustomerContactInfo=" & IncludeCustomerContactInfo & "&IncludeSurveyResults=" & IncludeSurveyResults & "&IncludeOrderNotes=" & IncludeOrderNotes & "><B>Amount</B></A></FONT></TD><TD ALIGN=center NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><A class=sort HREF=DonationReport.asp?SortMethod=TenderType&ExcelOutput=" & Request("ExcelOutput") & "&ReportStartMonth=" & Request("ReportStartMonth") & "&ReportStartDay=" & Request("ReportStartDay") & "&ReportStartYear=" & Request("ReportStartYear") & "&ReportEndMonth=" & Request("ReportEndMonth") & "&ReportEndDay=" & Request("ReportEndDay") & "&ReportEndYear=" & Request("ReportEndYear") & "&IncludeCustomerContactInfo=" & IncludeCustomerContactInfo & "&IncludeSurveyResults=" & IncludeSurveyResults & "&IncludeOrderNotes=" & IncludeOrderNotes & "><B>Tender<BR>Type</B></A></FONT></TD><TD ALIGN=center NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><A class=sort HREF=DonationReport.asp?SortMethod=OrderType&ExcelOutput=" & Request("ExcelOutput") & "&ReportStartMonth=" & Request("ReportStartMonth") & "&ReportStartDay=" & Request("ReportStartDay") & "&ReportStartYear=" & Request("ReportStartYear") & "&ReportEndMonth=" & Request("ReportEndMonth") & "&ReportEndDay=" & Request("ReportEndDay") & "&ReportEndYear=" & Request("ReportEndYear") & "&IncludeCustomerContactInfo=" & IncludeCustomerContactInfo & "&IncludeSurveyResults=" & IncludeSurveyResults & "&IncludeOrderNotes=" & IncludeOrderNotes & "><B>Order<BR>Type</B></A></FONT></TD>" & SurveyResultsHeader & OrderNotesHeader & "</TR>" & vbCrLf
		Else
			Response.Write "<TABLE CELLPADDING=""3""><TR VALIGN=TOP BGCOLOR=""#008400""><TD ALIGN=center NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Order Number</B></FONT></TD><TD ALIGN=center NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Order Date/Time</B></FONT></TD><TD ALIGN=center NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Customer Name</B></FONT></TD>" & CustomerContactHeader & "<TD ALIGN=center NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Organization</B></FONT></TD><TD ALIGN=center NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Description</B></FONT></TD><TD ALIGN=center NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Amount</B></FONT></TD><TD ALIGN=center NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Tender Type</B></FONT></TD><TD ALIGN=center NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Order Type</B></FONT></TD>" & SurveyResultsHeader & OrderNotesHeader & "</TR>" & vbCrLf
		End If		

		Call DBOpen(OBJdbConnection2)
		Do Until rsDonations.EOF
			Select Case rsDonations("TenderCount")
			Case 1
				TenderType = rsDonations("TenderType")
			Case 0
				TenderType = "N/A"
			Case Else
				TenderType = "Multiple"
			End Select
			
			If IncludeCustomerContactInfo = "Y" Then
				CustomerContactInfo = "<TD NOWRAP><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsDonations("Address1") & "</FONT></TD><TD NOWRAP><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsDonations("Address2") & "</FONT></TD><TD NOWRAP><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsDonations("City") & "</FONT></TD><TD NOWRAP><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsDonations("State") & "</FONT></TD><TD NOWRAP><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsDonations("PostalCode") & "</FONT></TD><TD NOWRAP><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsDonations("Country") & "</FONT></TD><TD NOWRAP><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & FormatPhone(rsDonations("DayPhone"), "United States") & "</FONT></TD><TD NOWRAP><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & FormatPhone(rsDonations("NightPhone"), "United States") & "</FONT></TD><TD NOWRAP><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsDonations("EMailAddress") & "</FONT></TD>"
			Else
				CustomerContactInfo = ""
			End If				
			
			'REE 8/25/5 - Added Survey Information
			If IncludeSurveyResults = "Y" Then 'Add the column
				SurveyDetail = "<TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & vbCrLf
				
				SQLSurveyAnswers = "SELECT Question, Answer FROM SurveyAnswers (NOLOCK) WHERE OrderNumber = " & rsDonations("OrderNumber") & " ORDER BY AnswerNumber, SurveyDate"
				Set rsSurveyAnswers = OBJdbConnection2.Execute(SQLSurveyAnswers)
				Do Until rsSurveyAnswers.EOF
					SurveyDetail = SurveyDetail & rsSurveyAnswers("Question") & ": " & rsSurveyAnswers("Answer") & "<BR>" & vbCrLf
					rsSurveyAnswers.MoveNext
				Loop
				rsSurveyAnswers.Close
				Set rsSurveyAnswers = nothing
				
				SurveyDetail = SurveyDetail & "</FONT></TD>" & vbCrLf
			End If
			
			'JAI 5/17/6 - Added Order Notes
			If IncludeOrderNotes = "Y" Then 'Add the column
				OrderNotes = "<TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 REE>" & vbCrLf
				
				'REE 6/23/6 - Added check for Null OrderNumber
				If Not IsNull(rsDonations("OrderNumber")) Then
					SQLOrderNotes = "SELECT ModifyDate, FirstName, LastName, OrderNotes FROM OrderNotes(NOLOCK) INNER JOIN Users(NOLOCK) ON OrderNotes.ModifyUser = Users.UserNumber WHERE OrderNumber = " & rsDonations("OrderNumber") & " ORDER BY ModifyDate"
					Set rsOrderNotes = OBJdbConnection2.Execute(SQLOrderNotes)
					Do Until rsOrderNotes.EOF
						OrderNotes = OrderNotes & rsOrderNotes("FirstName") & " " & rsOrderNotes("LastName") & " - " & rsOrderNotes("ModifyDate") & LineBreak & vbCrLf
						OrderNotes = OrderNotes & rsOrderNotes("OrderNotes")
						rsOrderNotes.MoveNext
					Loop
					rsOrderNotes.Close
					Set rsOrderNotes = nothing
				Else
					OrderNotes = OrderNotes & "&nbsp;"
				End If
				
				OrderNotes = OrderNotes & "</FONT></TD>" & vbCrLf
			End If

			If Excel <> "Y" Then 'Include links.
				Response.Write "<TR VALIGN=TOP BGCOLOR=""#DDDDDD""><TD ALIGN=RIGHT NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2><A HREF=OrderDetails.asp?OrderNumber=" & rsDonations("OrderNumber") & ">" & rsDonations("OrderNumber") & "</A></FONT></TD><TD ALIGN=LEFT NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & DateAndTimeFormat(rsDonations("StatusDate")) & "</FONT></TD><TD NOWRAP><FONT FACE=""verdana,arial,helvetica"" SIZE=""2""><A HREF=CustomerDetails.asp?CustomerNumber=" & rsDonations("CustomerNumber") & ">" & rsDonations("LastName") & ", " & rsDonations("FirstName") & "</A></FONT></TD>" & CustomerContactInfo & "<TD ALIGN=LEFT NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsDonations("Organization") & "</FONT></TD><TD ALIGN=LEFT><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsDonations("Description") & "</FONT></TD><TD ALIGN=right NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & FormatCurrency(rsDonations("DonationAmount"),2) & "</FONT></TD><TD ALIGN=right NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsDonations("TenderType") & "</FONT></TD><TD ALIGN=right NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsDonations("OrderType") & "</FONT></TD>" & SurveyDetail & OrderNotes & "</TR>" & vbCrLf
			Else 'Exclude links
				Response.Write "<TR VALIGN=TOP BGCOLOR=""#DDDDDD""><TD ALIGN=RIGHT NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsDonations("OrderNumber") & "</FONT></TD><TD ALIGN=LEFT NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & DateAndTimeFormat(rsDonations("StatusDate")) & "</FONT></TD><TD NOWRAP><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsDonations("LastName") & ", " & rsDonations("FirstName") & "</FONT></TD>" & CustomerContactInfo & "<TD ALIGN=LEFT NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsDonations("Organization") & "</FONT></TD><TD ALIGN=LEFT NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsDonations("Description") & "</FONT></TD><TD ALIGN=right NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & FormatCurrency(rsDonations("DonationAmount"),2) & "</FONT></TD><TD ALIGN=right NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsDonations("TenderType") & "</FONT></TD><TD ALIGN=right NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsDonations("OrderType") & "</FONT></TD>" & SurveyDetail & OrderNotes & "</TR>" & vbCrLf
			End If
			DonationTotal = DonationTotal + rsDonations("DonationAmount")
			rsDonations.MoveNext
		Loop
		Call DBClose(OBJdbConnection2)

		NumCols = 7
		If IncludeCustomerContactInfo = "Y" Then
			NumCols = NumCols + 9
		End If
		If IncludeSurveyResults = "Y" Then
			NumCols = NumCols + 1
		End If
		If IncludeOrderNotes = "Y" Then
			NumCols = NumCols + 1
		End If
		Response.Write "<TR VALIGN=TOP BGCOLOR=""#AAAAAA""><TD COLSPAN=""" & NumCols - 2 & """><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Grand Total&nbsp;&nbsp;</B></FONT></TD><TD ALIGN=""right""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2""><B>" & FormatCurrency(DonationTotal, 2) & "</FONT></TD><TD COLSPAN=""2""><FONT FACE='verdana,arial,helvetica' SIZE=2>&nbsp;</FONT></TD></TR>" & vbCrLf
		Response.Write "</TABLE>" & vbCrLf
	Else
		Response.Write "There are no donations or memberships to report for this date range."
	End If				
End If
%>

</FONT>
</CENTER>

<%
If Excel <> "Y" Then 'Include links.
%>
<!--#INCLUDE VIRTUAL="FooterInclude.asp"-->
<%
End If
%>

</BODY>
</HTML>