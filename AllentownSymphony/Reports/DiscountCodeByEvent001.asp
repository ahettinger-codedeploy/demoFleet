<!--#INCLUDE VIRTUAL="GlobalInclude.asp"-->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<%
Page = "ManagementReport"

Server.ScriptTimeout = 60 * 10

'REE 11/22/5 - Added Response Buffer False to prevent buffer limit from being exceeded.
Response.Buffer = False

If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then Response.Redirect("/Management/Default.asp")

If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then Response.Redirect("/Management/Default.asp")

If Request("FormName") = "EnterCriteria" Then
	Call DisplayReport
Else
	Call DisplayForm
End If

Sub DisplayForm
%>
<HTML>
<HEAD>
<TITLE>Tix - DiscountCode by Event</TITLE>
<script LANGUAGE="JavaScript">    

<!-- Hide code from non-js browsers

function y2k(number) { 
return (number < 1000) ? number + 1900 : number; 
}

function isDate (day,month,year) {
var today = new Date();
year = ((!year) ? y2k(today.getYear()):year);
month = ((!month) ? today.getMonth():month-1);
if (!day) return false
var test = new Date(year,month,day);
if ( (y2k(test.getYear()) == year) &&
     (month == test.getMonth()) &&
     (day == test.getDate()) )
    return true;
else
    return false
}

function ValidateForm(){
formObj = document.Report;
if (!isDate(formObj.ReportStartDay.value, formObj.ReportStartMonth.value, formObj.ReportStartYear.value))
	{alert("Invalid Start Date");
	formObj.ReportStartMonth.focus();
    return false;
    }
if (!isDate(formObj.ReportEndDay.value, formObj.ReportEndMonth.value, formObj.ReportEndYear.value))
	{alert("Invalid End Date");
	formObj.ReportEndMonth.focus();
    return false;
    }
}

function makeCheck(thisForm){
formObj = document.Report;
for (i = 0; i < formObj.Cashier.length; i++)
	{
	formObj.Cashier[i].checked=true
	}
}

// end hiding -->
</script>
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

<!--#include virtual="TopNavInclude.asp" -->

<BR>

<BR>

<FONT FACE="verdana,arial,helvetica" COLOR="#008400"><H3>Discount Code By Event</H3></FONT>
<FONT FACE="verdana,arial,helvetica" SIZE="2">
<FORM ACTION="DiscountCodeByEvent.asp" METHOD="post" NAME="Report" onsubmit="return ValidateForm()"><INPUT TYPE="hidden" NAME="FormName" VALUE="EnterCriteria">

<%
StartDate = FormatDateTime(Now)
EndDate = FormatDateTime(Now - 1)

Response.Write "<TABLE CELLPADDING=5 ALIGN=CENTER>"

Response.Write "<TR><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Event Start Date:</B></FONT></TD><TD><SELECT NAME=ReportStartMonth>"

For i = 1 to 12
	If i = 1 Then
		Response.Write "<OPTION SELECTED VALUE=" & i & ">" & MonthName(i) & "</OPTION>" & vbCrLf
	Else
		Response.Write "<OPTION VALUE=" & i & ">" & MonthName(i) & "</OPTION>" & vbCrLf
	End If
Next
Response.Write "</SELECT></TD>"

Response.Write "<TD><SELECT NAME=ReportStartDay>"
For i= 1 to 31
	If i = 1 Then
		Response.Write "<OPTION SELECTED VALUE=" & i & ">" & i & "</OPTION>" & vbCrLf
	Else
		Response.Write "<OPTION VALUE=" & i & ">" & i & "</OPTION>" & vbCrLf
	End If
Next
Response.Write "</SELECT></TD>"

Response.Write "<TD><SELECT NAME=ReportStartYear>"
For i = 2000 To Year(Now)
	If i = 2000 Then
		Response.Write "<OPTION SELECTED VALUE=" & i & ">" & i & "</OPTION>" & vbCrLf
	Else
		Response.Write "<OPTION VALUE=" & i & ">" & i & "</OPTION>" & vbCrLf
	End If
Next
Response.Write "</SELECT></TD></TR>" & vbCrLf

'Default to previous day's date.
DefaultEndDate = Now - 1

Response.Write "<TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Event End Date:</B></FONT></TD><TD><SELECT NAME=ReportEndMonth>"
For i = 1 to 12
	If i = Month(DefaultEndDate) Then
		Response.Write "<OPTION SELECTED VALUE=" & i & ">" & MonthName(i) & "</OPTION>" & vbCrLf
	Else
		Response.Write "<OPTION VALUE=" & i & ">" & MonthName(i) & "</OPTION>" & vbCrLf
	End If
Next
Response.Write "</SELECT></TD>"

Response.Write "<TD><SELECT NAME=ReportEndDay>"
For i= 1 to 31
	If i = Day(DefaultEndDate) Then
		Response.Write "<OPTION SELECTED VALUE=" & i & ">" & i & "</OPTION>" & vbCrLf
	Else
		Response.Write "<OPTION VALUE=" & i & ">" & i & "</OPTION>" & vbCrLf
	End If
Next
Response.Write "</SELECT></TD>"

Response.Write "<TD><SELECT NAME=ReportEndYear>"
For i = 2001 to Year(Now)
	If i = Year(DefaultEndDate) Then
		Response.Write "<OPTION SELECTED VALUE=" & i & ">" & i & "</OPTION>" & vbCrLf
	Else
		Response.Write "<OPTION VALUE=" & i & ">" & i & "</OPTION>" & vbCrLf
	End If
Next
Response.Write "</SELECT></TD></TR>" & vbCrLf

Response.Write "</TABLE><BR>" & vbCrLf

Response.Write "<BR><BR><INPUT TYPE=""checkbox"" NAME=""ExcelOutput"" VALUE=""Y"">&nbsp;Output To Excel<BR><BR>" & vbCrLf

Response.Write "<BR><BR><INPUT TYPE=submit VALUE=Submit></FORM>" & vbCrLf

Response.Write "</FONT></CENTER>" & vbCrLf

%>
<!--#INCLUDE VIRTUAL="FooterInclude.asp"-->
<%

Response.Write "</BODY>" & vbCrLf
Response.Write "</HTML>" & vbCrLf

End Sub 'Display Form

'------------------------------------------------

Sub DisplayReport

Excel = Clean(Request("ExcelOutput"))

If Excel = "Y" Then

	Response.ContentType = "application/vnd.ms-excel"

End If

%>
<HTML>
<HEAD>
<TITLE>Tix - Discount Code By Event</TITLE>
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

<FONT FACE=verdana,arial,helvetica COLOR=#008400><H3>Discount Code By Event</H3></FONT>
<FONT FACE=verdana,arial,helvetica SIZE=2>
<FORM ACTION="DiscountCodeByEvent.asp" METHOD="post" id=form1 name=form1>

<%


ReportStartDate = CDate(Request("ReportStartMonth") & "/" & Request("ReportStartDay") & "/" & Request("ReportStartYear"))
ReportEndDate = CDate(Request("ReportEndMonth") & "/" & Request("ReportEndDay") & "/" & Request("ReportEndYear")) + 1

SQLDiscount = "SELECT CONVERT(VARCHAR(10), Event.EventDate, 101) AS EventDate, (SELECT right(CONVERT( varchar, Event.EventDate, 100),7)) as EventTime, Event.EventCode, Act, UPPER(DiscountType.DiscountCode) as DiscountCode, DiscountType.DiscountDescription FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN DiscountEvents (NOLOCK) ON DiscountEvents.EventCode = Event.EventCode INNER JOIN DiscountType (NOLOCK) ON DiscountType.DiscountTypeNumber = DiscountEvents.DiscountTypeNumber INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & "  AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & "  AND Event.EventDate >= '" & ReportStartDate & "' AND Event.EventDate < '" & ReportEndDate & "' ORDER BY DiscountType.DiscountCode"
Set rsDiscount = OBJdbConnection.Execute(SQLDiscount)

If Not rsDiscount.EOF Then

	Response.Write "<TABLE CELLPADDING=3>" & vbCrLf
	Response.Write "<TR BGCOLOR=#008400><TD NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2 COLOR=#FFFFFF><B>Discount Code</B></FONT></TD><TD NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2 COLOR=#FFFFFF><B>Discount Description</B></FONT></TD><TD ALIGN=""center"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2 COLOR=#FFFFFF><B>Event Code</B></FONT></TD><TD ALIGN=center NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2 COLOR=#FFFFFF><B>Event Name</B></FONT></TD><TD ALIGN=center NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2 COLOR=#FFFFFF><B>Event Date</B></FONT></TD></TR>"

    Call DBOpen(OBJdbConnection2)

    Do Until rsDiscount.EOF


	    Response.Write "<TR BGCOLOR=#DDDDDD><TD NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsDiscount("DiscountCode") & "</FONT></TD><TD NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsDiscount("DiscountDescription") & "</FONT></TD><TD NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsDiscount("EventCode") & "</FONT></TD><TD NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsDiscount("Act") & "</FONT></TD><TD NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsDiscount("EventDate") & "</FONT></TD></TR>"
    	
	    rsDiscount.MoveNext
    	
    Loop

    OBJdbConnection2.Close
    Set OBJdbConnection2 = nothing
    
    Response.Write "</TABLE>" & vbCrLf
    
Else

    Response.Write "<b>There are no discount codes found for the specified date range.</b>"

End If

rsDiscount.Close
Set rsDiscount = nothing    

%>

</FONT>
<BR>
<BR>
<BR>
<%
If Excel <> "Y" Then
%>
	<!--#INCLUDE VIRTUAL="FooterInclude.asp"-->
<%
End If
%>

</CENTER>
</BODY>
</HTML>

<%
End Sub 'Display Report

%>
