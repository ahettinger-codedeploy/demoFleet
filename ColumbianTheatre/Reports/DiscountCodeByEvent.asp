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
EndDate = FormatDateTime(Year(Now - 1))
 

Response.Write "<TABLE CELLPADDING=5 ALIGN=CENTER>"

'Report Date Range starts on 1 year ago
DefaultStartDate = (Now - 366)

'Report Start Month
Response.Write "<TR><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Start Date:</B></FONT></TD><TD><SELECT NAME=ReportStartMonth>"
For i = 1 to 12
		If i = Month(DefaultStartDate) Then
		Response.Write "<OPTION SELECTED VALUE=" & i & ">" & MonthName(i) & "</OPTION>" & vbCrLf
	Else
		Response.Write "<OPTION VALUE=" & i & ">" & MonthName(i) & "</OPTION>" & vbCrLf
	End If
Next
Response.Write "</SELECT></TD>"

'Report Start Day
Response.Write "<TD><SELECT NAME=ReportStartDay>"
For i= 1 to 31
		If i = Day(DefaultStartDate) Then
		Response.Write "<OPTION SELECTED VALUE=" & i & ">" & i & "</OPTION>" & vbCrLf
	Else
		Response.Write "<OPTION VALUE=" & i & ">" & i & "</OPTION>" & vbCrLf
	End If
Next
Response.Write "</SELECT></TD>"

'Report Start Year
Response.Write "<TD><SELECT NAME=ReportStartYear>"
For i = Year(Now - 365) to Year(Now + 720)
	If i = Year(DefaultStartDate) Then
		Response.Write "<OPTION SELECTED VALUE=" & i & ">" & i & "</OPTION>" & vbCrLf
	Else
		Response.Write "<OPTION VALUE=" & i & ">" & i & "</OPTION>" & vbCrLf
	End If
Next
Response.Write "</SELECT></TD></TR>" & vbCrLf

'Report Date Range ends on yesterday's date
DefaultEndDate = (Now - 1)

'Report End Month
Response.Write "<TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B>End Date:</B></FONT></TD><TD><SELECT NAME=ReportEndMonth>"
For i = 1 to 12
	If i = Month(DefaultEndDate) Then
		Response.Write "<OPTION SELECTED VALUE=" & i & ">" & MonthName(i) & "</OPTION>" & vbCrLf
	Else
		Response.Write "<OPTION VALUE=" & i & ">" & MonthName(i) & "</OPTION>" & vbCrLf
	End If
Next
Response.Write "</SELECT></TD>"

'Report End Day
Response.Write "<TD><SELECT NAME=ReportEndDay>"
For i= 1 to 31
	If i = Day(DefaultEndDate) Then
		Response.Write "<OPTION SELECTED VALUE=" & i & ">" & i & "</OPTION>" & vbCrLf
	Else
		Response.Write "<OPTION VALUE=" & i & ">" & i & "</OPTION>" & vbCrLf
	End If
Next
Response.Write "</SELECT></TD>"

'Report End Year
Response.Write "<TD><SELECT NAME=ReportEndYear>"
For i = Year(Now - 365) to Year(Now + 720)
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

ReportStartDate = CDate(Request("ReportStartMonth") & "/" & Request("ReportStartDay") & "/" & Request("ReportStartYear"))
ReportEndDate = CDate(Request("ReportEndMonth") & "/" & Request("ReportEndDay") & "/" & Request("ReportEndYear"))

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

SQLEvents = "SELECT Event.EventCode, Act as EventName, Event.EventDate FROM Event (NOLOCK) INNER JOIN DiscountEvents (NOLOCK) ON DiscountEvents.EventCode = Event.EventCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE Event.EventDate >  '" & ReportStartDate & "' AND EventDate < '" & ReportEndDate & "' AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND DiscountTypeNumber <> '' GROUP BY Event.EventCode, Act.Act, Event.EventDate ORDER BY Event.EventDate"
Set rsEvents = OBJdbConnection.Execute(SQLEvents)

If Not rsEvents.EOF Then

			Response.Write "<TABLE CELLPADDING=4>" & vbCrLf
	
			Call DBOpen(OBJdbConnection2)

			Do Until rsEvents.EOF
    
			'List all events which have a discount code attached

			

			Response.Write "<TR STYLE=""border-width: 0px"" BGCOLOR=#008400><TD COLSPAN=3><FONT FACE='verdana,arial,helvetica' SIZE=2 COLOR=#FFFFFF><B>" & rsEvents("EventName") & "&nbsp;&nbsp;-&nbsp;&nbsp;EventCode: " & rsEvents("EventCode") & "</B></FONT></TD><TD ALIGN=""right""><FONT FACE='verdana,arial,helvetica' SIZE=2 COLOR=#FFFFFF><B>" & FormatDateTime(rsEvents("EventDate"), vbShortDate) & "</B></FONT></TD></TR>" & vbCrLf
	    
			'List all discount codes for this particular event
				    
			SQLDiscount = "SELECT Event.EventCode, DiscountEvents.DiscountTypeNumber, UPPER(DiscountType.DiscountCode) as DiscountCode, DiscountType.DiscountDescription, DiscountEvents.Hidden FROM Event (NOLOCK) INNER JOIN DiscountEvents (NOLOCK) ON DiscountEvents.EventCode = Event.EventCode INNER JOIN DiscountType (NOLOCK) ON DiscountEvents.DiscountTypeNumber = DiscountType.DiscountTypeNumber WHERE Event.EventCode = " & rsEvents("EventCode")& "" 
			Set rsDiscount = OBJdbConnection.Execute(SQLDiscount)
						
					If Not rsDiscount.EOF Then
					
					
							Response.Write "<TR BGCOLOR=#AAAAAA><TD NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Discount Number</B></FONT></TD><TD NOWRAP ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Discount Code</B></FONT></TD><TD NOWRAP ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Discount Description</B></FONT></TD><TD NOWRAP ALIGN=left><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Discount Type</B></FONT></TD></TR>" & vbCrLf
						
											
							Call DBOpen(OBJdbConnection3)
											 
							Do Until rsDiscount.EOF	

							
							If IsNumeric(rsDiscount("Hidden")) = 0 Then
								DiscountType = "Automatic"
							Else
								DiscountType = "Code Required"
							End If
											  
							Response.Write "<TR BGCOLOR=#DDDDDD><TD NOWRAP ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsDiscount("DiscountTypeNumber") & "</FONT></TD><TD NOWRAP ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsDiscount("DiscountCode") & "</FONT></TD><TD NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsDiscount("DiscountDescription") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>" & DiscountType & "</FONT></TD></TR>" & vbCrLf
								   
							rsDiscount.MoveNext
												
							Loop
									    
							OBJdbConnection3.Close
							Set OBJdbConnection3 = nothing
									
					Else 
					
					  Response.Write "<b>There are no discount codes found for the specified date range.</b>" & vbCrLf

					End If
							
					rsDiscount.Close
					Set rsDiscount = nothing   
				  
			rsEvents.MoveNext
    	
			Loop

			OBJdbConnection2.Close
			Set OBJdbConnection2 = nothing
    
			Response.Write "</TABLE>" & vbCrLf
    
Else

    Response.Write "<b>There are no discount codes found for the specified date range.</b>" & vbCrLf

End If

rsEvents.Close
Set rsEvent = nothing    

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
