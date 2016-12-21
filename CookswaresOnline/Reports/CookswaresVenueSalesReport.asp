<%
'Event Selection Modified
%>
<!--#include virtual="GlobalInclude.asp"-->
<!--#include virtual="dbOpenInclude.asp"-->
<%
Page = "ManagementReport"

If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then Response.Redirect("/Management/Default.asp")

'If Session("VenueCode") = "" Or IsNull(Session("VenueCode")) Then Response.Redirect("/Management/Default.asp")

If Request("FormName") = "CooksWaresVenueSalesReport" Then
	Call DisplayReport
Else
	Call DisplayForm
End If

Sub DisplayForm
%>
<HTML>
<HEAD>
<TITLE>Tix - Venue Sales Report</TITLE>
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
if	(formObj.VenueCode.value == 0)
	{alert("Plese select a venue.");
	return false;
	}
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
// end hiding -->
</script>
</HEAD>
<BODY BGCOLOR="#FFFFFF">
<CENTER>

<!--#include virtual="TopNavInclude.asp" -->

<BR>

<BR>

<FONT FACE="verdana,arial,helvetica" COLOR="#008400"><H3>Venue Sales Report</H3></FONT>
<FONT FACE="verdana,arial,helvetica" SIZE="2">
<FORM ACTION="CooksWaresVenueSalesReport.asp" METHOD="post" NAME="Report" onsubmit="return ValidateForm()"><INPUT TYPE="hidden" NAME="FormName" VALUE="CooksWaresVenueSalesReport">
<%

Response.Write "<TABLE CELLPADDING=5>"

Response.Write "<TR><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Venue:</B></FONT></TD><TD COLSPAN=3><SELECT NAME=VenueCode>"

'REE 2/16/3 - Moved Start and End Dates to before If Statement.
StartDate = FormatDateTime(Now - (6 + Weekday(Now, 2)), vbShortDate)
EndDate = FormatDateTime(Now - Weekday(Now, 2), vbShortDate)

If Session("UserNumber") <> 1 Then
	SQLVenue="SELECT DISTINCT Venue.VenueCode, Venue.Venue FROM Venue (NOLOCK) INNER JOIN OrganizationVenue (NOLOCK) ON Venue.VenueCode = OrganizationVenue.VenueCode WHERE OrganizationVenue.OrganizationNumber = '" & Session("OrganizationNumber") & "' ORDER BY Venue"
Else
	'REE 1/20/3 - Modified to select correct dates when it's being run on a Monday.  Removed need for EndDateNextDay, used DateAdd instead.
'	EndDateNextDay = FormatDateTime((Now - Weekday(Now, 2))+ 1, vbShortDate)
	
'	Response.Write EndDateNextDay & "<BR>"
	
	SQLVenue="SELECT DISTINCT Venue.VenueCode, Venue FROM Venue (NOLOCK) INNER JOIN Event (NOLOCK) ON Venue.VenueCode = Event.VenueCode WHERE Event.EventDate >= '" & StartDate & "' AND Event.EventDate < '" & DateAdd("d", 1, EndDate) & "' ORDER BY Venue"
'	Response.Write "SQLVENUE - " & SQLVenue & "<BR>"
End If

Set rsVenue = OBJdbConnection.Execute(SQLVenue)
Response.Write "<OPTION VALUE=0 SELECTED>--SELECT VENUE--" & vbCrLf
Do Until rsVenue.EOF
	Response.Write "<OPTION VALUE=" & rsVenue("VenueCode") & ">" & rsVenue("Venue") & vbCrLf
	rsVenue.MoveNext
Loop
Response.Write "</SELECT></TD></TR>" & vbCrLf

Response.Write "<TR><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Start Date:</B></FONT></TD><TD><SELECT NAME=ReportStartMonth>"
For i = 1 to 12
  If i <> Month(StartDate) Then
    Response.Write "<OPTION VALUE=" & i & ">" & MonthName(i) & "</OPTION>" & vbCrLf
  Else
    Response.Write "<OPTION SELECTED VALUE=" & i & ">" & MonthName(i) & "</OPTION>" & vbCrLf
  End If
Next
Response.Write "</SELECT></TD>"

Response.Write "<TD><SELECT NAME=ReportStartDay>"
For i= 1 to 31
  If i <> Day(StartDate) Then
    Response.Write "<OPTION VALUE=" & i & ">" & i & "</OPTION>" & vbCrLf
  Else
    Response.Write "<OPTION SELECTED VALUE=" & i & ">" & i & "</OPTION>" & vbCrLf
  End If
Next
Response.Write "</SELECT></TD>"

Response.Write "<TD><SELECT NAME=ReportStartYear>"
Response.Write "<OPTION VALUE=" & Year(StartDate) - 1 & ">" & Year(StartDate) - 1 & "</OPTION>" & vbCrLf
Response.Write "<OPTION SELECTED VALUE=" & Year(StartDate) & ">" & Year(StartDate) & "</OPTION>" & vbCrLf
Response.Write "<OPTION VALUE=" & Year(StartDate) + 1 & ">" & Year(StartDate) + 1 & "</OPTION>" & vbCrLf
Response.Write "</SELECT></TD></TR>" & vbCrLf

Response.Write "<TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B>End Date:</B></FONT></TD><TD><SELECT NAME=ReportEndMonth>"
For i = 1 to 12
  If i <> Month(EndDate) Then
    Response.Write "<OPTION VALUE=" & i & ">" & MonthName(i) & "</OPTION>" & vbCrLf
  Else
    Response.Write "<OPTION SELECTED VALUE=" & i & ">" & MonthName(i) & "</OPTION>" & vbCrLf
  End If
Next
Response.Write "</SELECT></TD>"

Response.Write "<TD><SELECT NAME=ReportEndDay>"
For i= 1 to 31
  If i <> Day(EndDate) Then
    Response.Write "<OPTION VALUE=" & i & ">" & i & "</OPTION>" & vbCrLf
  Else
    Response.Write "<OPTION SELECTED VALUE=" & i & ">" & i & "</OPTION>" & vbCrLf
  End If
Next
Response.Write "</SELECT></TD>"

Response.Write "<TD><SELECT NAME=ReportEndYear>"
Response.Write "<OPTION VALUE=" & Year(EndDate) - 1 & ">" & Year(EndDate) - 1 & "</OPTION>" & vbCrLf
Response.Write "<OPTION SELECTED VALUE=" & Year(EndDate) & ">" & Year(EndDate) & "</OPTION>" & vbCrLf
Response.Write "<OPTION VALUE=" & Year(EndDate) + 1 & ">" & Year(EndDate) + 1 & "</OPTION>" & vbCrLf
Response.Write "</SELECT></TD></TR>" & vbCrLf

Response.Write "</TABLE><BR>" & vbCrLf

Response.Write "<INPUT TYPE=submit VALUE=Enter></FORM><BR><BR>" & vbCrLf

Response.Write "</FONT>" & vbCrLf

%>
	<!--#include virtual="FooterInclude.asp"-->
<%

Response.Write "</CENTER>" & vbCrLf
Response.Write "</BODY>" & vbCrLf
Response.Write "</HTML>" & vbCrLf

End Sub

Sub DisplayReport

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>Venue Sales Report</TITLE>" & vbCrLf
Response.Write "</HEAD>" & vbCrLf
Response.Write "<BODY BGCOLOR=#FFFFFF>" & vbCrLf
Response.Write "<CENTER>" & vbCrLf


ReportStartDate = CDate(Request("ReportStartMonth") & "/" & Request("ReportStartDay") & "/" & Request("ReportStartYear"))
ReportEndDate = CDate(Request("ReportEndMonth") & "/" & Request("ReportEndDay") & "/" & Request("ReportEndYear"))

SQLEvents = "SELECT Venue, EventDate, Act, Event.EventCode FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode WHERE Event.VenueCode = " & Request("VenueCode") & " ORDER BY Event.EventDate"
'Response.Write SQLEvents & "<BR>"
Set rsEvents = OBJdbConnection.Execute(SQLEvents)

'REE 2/16/3 - Added If statement in case there were no events selected
If Not rsEvents.EOF Then

	Response.Write "<FONT FACE=verdana,arial,helvetica COLOR=#008400><H3>" & rsEvents("Venue") & " Sales Report</H3></FONT>" & vbCrLf
	Response.Write "<FONT FACE=verdana,arial,helvetica SIZE=2>" & vbCrLf

	Response.Write "<FONT FACE='verdana,arial,helvetica' SIZE=2><B> Sales For Events From " & ReportStartDate & " Through " &  ReportEndDate & "</B></FONT><BR><BR>" & vbCrLf

	Response.Write "<TABLE CELLPADDING=3>" & vbCrLf

	Do Until rsEvents.EOF

		If Hour(rsEvents("EventDate")) > 12 Then
			EventHour = Hour(rsEvents("EventDate")) - 12
			APM = " PM"
		Else
			EventHour = Hour(rsEvents("EventDate"))
			APM = " AM"
		End If
			
		EventTime = EventHour & ":" & Right("00" & Minute(rsEvents("EventDate")), 2) & APM

		'REE 6/9/4 - Added StatusCode Criteria.  It was picking up non-sold orders.
		SQLOrderLine = "SELECT Price, OrderLine.Discount, OrderDate FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND Seat.EventCode = " & rsEvents("EventCode") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent', 'SubSeat') AND OrderLine.StatusCode = 'S' AND OrderHeader.OrderDate > '" & ReportStartDate & "' AND OrderHeader.OrderDate < '" & ReportEndDate + 1 & "' ORDER BY OrderHeader.OrderDate"
		Set rsOrderLine = OBJdbConnection.Execute(SQLOrderLine)
			
		If Not rsOrderLine.EOF Then
			'Response.Write "<TR BGCOLOR=#008400><TD><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><B>" & rsEvents("Act") & "</B></FONT></TD><TD><FONT FACE='verdana,arial,helvetica' SIZE=2 COLOR=#FFFFFF><B>" & FormatDateTime(rsEvents("EventDate"), vbShortDate) & "</B></FONT></TD><TD><FONT FACE='verdana,arial,helvetica' SIZE=2 COLOR=#FFFFFF><B>" & EventTime & "</B></FONT></TD></TR>" & vbCrLf
			'Response.Write "<TR BGCOLOR=#AAAAAA><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Date</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Quantity</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Revenue</B></FONT></TD></TR>" & vbCrLf
			'Response.Write "<TR BGCOLOR=#DDDDDD><TD COLSPAN=3><FONT FACE='verdana,arial,helvetica' SIZE=2><B>No Sales For This Event</B></FONT></TD></TR>" & vbCrLf
			'Response.Write "<TR BGCOLOR=#AAAAAA><TD><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Event Total</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B>0</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B>" & FormatNumber(0, 2) & "</B></FONT></TD></TR>" & vbCrLf
			'Response.Write "<TR><TD COLSPAN=3>&nbsp;</TD></TR>" & vbCrLf
		'Else
							
	'			Response.Write "<TABLE CELLPADDING=3>" & vbCrLf
			Response.Write "<TR BGCOLOR=#008400><TD><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><B>" & rsEvents("Act") & "</B></FONT></TD><TD><FONT FACE='verdana,arial,helvetica' SIZE=2 COLOR=#FFFFFF><B>" & FormatDateTime(rsEvents("EventDate"), vbShortDate) & "</B></FONT></TD><TD><FONT FACE='verdana,arial,helvetica' SIZE=2 COLOR=#FFFFFF><B>" & EventTime & "</B></FONT></TD></TR>" & vbCrLf
			Response.Write "<TR BGCOLOR=#AAAAAA><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Date</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Quantity</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Revenue</B></FONT></TD></TR>" & vbCrLf
			
			LastDate = FormatDateTime(rsOrderLine("OrderDate"), vbShortDate)
					
			Do Until rsOrderLine.EOF
				If Not IsNull(rsOrderLine("Price")) Then
					DailyTicketCount = DailyTicketCount + 1
					DailyRevenue = DailyRevenue + rsOrderLine("Price") - rsOrderLine("Discount")
					EventTicketCount = EventTicketCount + 1
					EventRevenue = EventRevenue + rsOrderLine("Price") - rsOrderLine("Discount")
					TotalTicketCount = TotalTicketCount + 1
					TotalRevenue = TotalRevenue + rsOrderLine("Price") - rsOrderLine("Discount")
				End If
				rsOrderLine.MoveNext
				If Not rsOrderLine.EOF Then
					If LastDate <> FormatDateTime(rsOrderLine("OrderDate"), vbShortDate) Then
						If DailyRevenue <> 0 Then Response.Write "<TR BGCOLOR=#DDDDDD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2>" & LastDate & "</FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2>" & DailyTicketCount & "</FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2>" & FormatNumber(DailyRevenue, 2) & "</FONT></TD></TR>" & vbCrLf
						LastDate = FormatDateTime(rsOrderLine("OrderDate"), vbShortDate)
						DailyTicketCount = 0
						DailyRevenue = 0
					End If
				Else
					If DailyRevenue <> 0 Then Response.Write "<TR BGCOLOR=#DDDDDD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2>" & LastDate & "</FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2>" & DailyTicketCount & "</FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2>" & FormatNumber(DailyRevenue, 2) & "</FONT></TD></TR>" & vbCrLf
					DailyTicketCount = 0
					DailyRevenue = 0
				End If
			Loop
			Response.Write "<TR BGCOLOR=#AAAAAA><TD><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Event Total</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B>" & EventTicketCount & "</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B>" & FormatNumber(EventRevenue, 2) & "</B></FONT></TD></TR>" & vbCrLf
			Response.Write "<TR><TD COLSPAN=3>&nbsp;</TD></TR>" & vbCrLf
			EventTicketCount = 0
			EventRevenue = 0
		End If

		rsEvents.MoveNext
				
	Loop
	Response.Write "<TR BGCOLOR=#000000><TD><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><B>Grand Total</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><B>" & TotalTicketCount & "</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><B>" & FormatNumber(TotalRevenue, 2) & "</B></FONT></TD></TR>" & vbCrLf
	Response.Write "</TABLE>" & vbCrLf
Else
	Response.Write "<TR BGCOLOR=#DDDDDD><TD COLSPAN=4><FONT FACE='verdana,arial,helvetica' SIZE=2><B>No Events For This Period</B></FONT></TD></TR>" & vbCrLf
End If

Response.Write "</FONT></CENTER>" & vbCrLf
Response.Write "</BODY>" & vbCrLf
Response.Write "</HTML>" & vbCrLf
				
End Sub

%>

