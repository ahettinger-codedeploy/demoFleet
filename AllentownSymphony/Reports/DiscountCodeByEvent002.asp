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

'REE 5/28/5 - Added ability to output to Excel
Excel = Clean(Request("ExcelOutput"))
If Excel = "Y" Then
	Response.ContentType = "application/vnd.ms-excel"
End If


ReportStartDate = CDate(Request("ReportStartMonth") & "/" & Request("ReportStartDay") & "/" & Request("ReportStartYear"))
ReportEndDate = CDate(Request("ReportEndMonth") & "/" & Request("ReportEndDay") & "/" & Request("ReportEndYear")) + 1


Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>Event / Discount Code Report</TITLE>" & vbCrLf
Response.Write "</HEAD>" & vbCrLf
Response.Write "<BODY BGCOLOR=#FFFFFF>" & vbCrLf

If Excel <> "Y" Then
	Response.Write "<CENTER>" & vbCrLf
%>
<!--#include virtual="TopNavInclude.asp" -->
<%
End If

Response.Write "<BR><BR>" & vbCrLf
Response.Write "<FONT FACE=""verdana,arial,helvetica"" COLOR=""#008400""><H3>Event / Discount Code Report</H3></FONT>" & vbCrLf
Response.Write "<FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2""><B>Sales From " & ReportStartDate & " through " & ReportEndDate & "</B></FONT><BR><BR>" & vbCrLf
Response.Write "<FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & vbCrLf


		SQLOrderLine = "SELECT Event.EventDate, Event.EventCode, DiscountType.DiscountTypeNumber, DiscountType.DiscountCode, DiscountType.DiscountDescription FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN DiscountEvents (NOLOCK) ON DiscountEvents.EventCode = Event.EventCode INNER JOIN DiscountType (NOLOCK) ON DiscountType.DiscountTypeNumber = DiscountEvents.DiscountTypeNumber INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & "  AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & "  AND Event.EventDate >= '" & ReportStartDate & "' AND Event.EventDate < '" & ReportEndDate & "' GROUP BY Event.EventDate, Event.EventCode, DiscountType.DiscountTypeNumber, DiscountType.DiscountCode ORDER BY Event.EventDate, Event.EventCode, DiscountType.DiscountTypeNumber, DiscountType.DiscountCode"
		Set rsOrderLine = OBJdbConnection.Execute(SQLOrderLine)

		If Not rsOrderLine.EOF Then
		
		LastEventCode = rsOrderLine("EventCode")
		SQLEvents = "SELECT EventDate, Act, Event.EventCode FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode WHERE Event.EventCode = " & LastEventCode
		Set rsEvents = OBJdbConnection.Execute(SQLEvents)
		
		If Hour(rsEvents("EventDate")) > 12 Then
			EventHour = Hour(rsEvents("EventDate")) - 12
			APM = " PM"
		Else
			EventHour = Hour(rsEvents("EventDate"))
			APM = " AM"
		End If
		
		EventTime = EventHour & ":" & Right("00" & Minute(rsEvents("EventDate")), 2) & APM
		
		Response.Write "<TABLE CELLPADDING=3>" & vbCrLf
		Response.Write "<TR BGCOLOR=#008400><TD COLSPAN=7><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><B>" & rsEvents("Act") & "</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2 COLOR=#FFFFFF><B>" & FormatDateTime(rsEvents("EventDate"), vbShortDate) & "</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2 COLOR=#FFFFFF><B>" & EventTime & "</B></FONT></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=#AAAAAA><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Seat&nbsp;Type</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>&nbsp;Ticket&nbsp;Price&nbsp;</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>&nbsp;Discount&nbsp;</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>&nbsp;Net&nbsp;Price&nbsp;</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Ticket&nbsp;Count</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>&nbsp;Face&nbsp;Value&nbsp;</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>&nbsp;Total&nbsp;Discount&nbsp;&nbsp;</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>&nbsp;Total&nbsp;Service&nbsp;Fees&nbsp;&nbsp;</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>&nbsp;&nbsp;Revenue&nbsp;&nbsp;</B></FONT></TD></TR>" & vbCrLf
		
		LastDiscountTypeNumber = rsOrderLine("DiscountTypeNumber")
		LastDiscountCode = rsOrderLine("DiscountCode")

		SQLDiscountType = "SELECT DiscountTypeNumber FROM DiscountType (NOLOCK) WHERE DiscountTypeNumber = " & LastDiscountTypeNumber
		Set rsDiscountType = OBJdbConnection.Execute(SQLDiscountType)
		
		Do Until rsOrderLine.EOF
		
			If LastDiscountTypeNumber <> rsOrderLine("DiscountTypeNumber") Or rsOrderLine("DiscountCode") <> LastDisccountCode Then
			Response.Write "<TR BGCOLOR=#DDDDDD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsDiscountType("DiscountTypeNumber") & "</FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2>" & LastDiscountCode & "</FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2>" & FormatCurrency(LastDiscount,2) & "</FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2>" & LastDiscountDescription & "</FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2></FONT></TD></TR>" & vbCrLf
			LastDiscountTypeNumber = rsOrderLine("DiscountTypeNumber")
			LastDiscountCode = rsOrderLine("DiscountCode")
			LastDiscountDescription = rsOrderLine("DiscountDescription")
			SQLDiscountType = "SELECT DiscountTypeNumber FROM DiscountType (NOLOCK) WHERE DiscountTypeNumber = " & LastDiscountTypeNumber
			Set rsDiscountType = OBJdbConnection.Execute(SQLDiscType)
							

			End If
			
			
			If rsOrderLine("EventCode") <> LastEventCode Then
			
			
			SQLEvents = "SELECT EventDate, Act, Event.EventCode FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode WHERE Event.EventCode = " & LastEventCode
				Set rsEvents = OBJdbConnection.Execute(SQLEvents)

				If Hour(rsEvents("EventDate")) > 12 Then
					EventHour = Hour(rsEvents("EventDate")) - 12
					APM = " PM"
				Else
					EventHour = Hour(rsEvents("EventDate"))
					APM = " AM"
				End If
						
				EventTime = EventHour & ":" & Right("00" & Minute(rsEvents("EventDate")), 2) & APM
				
	Response.Write "<TR BGCOLOR=#008400><TD COLSPAN=7><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><B>" & rsEvents("Act") & "</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2 COLOR=#FFFFFF><B>" & FormatDateTime(rsEvents("EventDate"), vbShortDate) & "</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2 COLOR=#FFFFFF><B>" & EventTime & "</B></FONT></TD></TR>" & vbCrLf
   Response.Write "<TR BGCOLOR=#AAAAAA><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Seat&nbsp;Type</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>&nbsp;Ticket&nbsp;Price&nbsp;</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>&nbsp;Discount&nbsp;</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>&nbsp;Net&nbsp;Price&nbsp;</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Ticket&nbsp;Count</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>&nbsp;Face&nbsp;Value&nbsp;</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>&nbsp;Total&nbsp;Discount&nbsp;&nbsp;</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>&nbsp;Total&nbsp;Service&nbsp;Fees&nbsp;&nbsp;</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>&nbsp;&nbsp;Revenue&nbsp;&nbsp;</B></FONT></TD></TR>" & vbCrLf

End If

			rsOrderLine.MoveNext	
		Loop
		
	Response.Write "<TR BGCOLOR=#DDDDDD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsDiscountType("DiscountTypeNumber") & "</FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2>" & LastDiscountCode & "</FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2>" & LastDiscountDescription & "</FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2></FONT></TD></TR>" & vbCrLf
	Response.Write "<TR BGCOLOR=#AAAAAA><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>SubTotal</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B>&nbsp;</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B>&nbsp;</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B>&nbsp;</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B></B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B></B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B></B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B></B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B></B></FONT></TD></TR>" & vbCrLf
	
	Response.Write "<TR BGCOLOR=#008400><TD COLSPAN=9 align=""left""><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><B>Total Sales</B></FONT></TD></TR>" & vbCrLf
		
		rsOrderLine.Close
	    Set rsOrderLine = Nothing
	    
	    
	    	SQLOrderLine = "SELECT EventDate, EventCode, DiscountTypeNumber, DiscountCode, DiscountDescription FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN DiscountEvents (NOLOCK) ON DiscountEvents.EventCode = Event.EventCode INNER JOIN DiscountType (NOLOCK) ON DiscountType.DiscountTypeNumber = DiscountEvents.DiscountTypeNumber INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & "  AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & "  AND Event.EventDate >= '" & ReportStartDate & "' AND Event.EventDate < '" & ReportEndDate & "' GROUP BY EventDate, EventCode, DiscountTypeNumber, DiscountCode ORDER BY EventDate, EventCode, DiscountTypeNumber, DiscountCode"
    
	    
	    	    If Not rsOrderLine.EOF Then
		    Response.Write "<TR BGCOLOR=#AAAAAA><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Discount&nbsp;TypeNumber</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>&nbsp;Discount&nbsp;Code&nbsp;</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>&nbsp;Discount Description&nbsp;</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>&nbsp;Net&nbsp;Price&nbsp;</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Ticket&nbsp;Count</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>&nbsp;Face&nbsp;Value&nbsp;</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>&nbsp;Total&nbsp;Discount&nbsp;&nbsp;</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>&nbsp;Total&nbsp;Service&nbsp;Fees&nbsp;&nbsp;</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>&nbsp;&nbsp;Revenue&nbsp;&nbsp;</B></FONT></TD></TR>" & vbCrLf
	        Do While Not rsOrderLine.EOF	        
	            SQLDiscountType = "SELECT DiscountTypeNumber FROM DiscountType (NOLOCK) WHERE DiscountTypeNumber = " & rsOrderLine("DiscountTypeNumber")
		        Set rsDiscountType = OBJdbConnection.Execute(SQLDiscountType)				
				
							Response.Write "<TR BGCOLOR=#DDDDDD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsDiscountType("DiscountTypeNumber") & "</FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsOrderLine("DiscountDescription")& "</FONT></TD><TD ALIGN=right></TD><TD ALIGN=right></TD><TD ALIGN=right></TD><TD ALIGN=right></TD><TD ALIGN=right></TD><TD ALIGN=right></TD><TD ALIGN=right></TD></TR>" & vbCrLf
	            
	            rsSeatType.Close
	            Set rsSeatType = Nothing	            
	            rsOrderLine.movenext
	        Loop
	    End If	    
	    rsOrderLine.Close
	    Set rsOrderLine = Nothing
	    
	    
	    		Response.Write "</TABLE>" & vbCrLf
	Else
	    rsOrderLine.Close
	    Set rsOrderLine = Nothing
	    
		Response.Write "There are no sales to report for the selected events."
	End If	
					
				
%>
<BR>
<BR>
<BR>

<%
If Excel <> "Y" Then
%>
	<!--#include virtual="FooterInclude.asp"-->
<%
	Response.Write "</CENTER>" & vbCrLf
End If

Response.Write "</BODY>" & vbCrLf
Response.Write "</HTML>" & vbCrLf
			
End Sub 'Display Report

%>


