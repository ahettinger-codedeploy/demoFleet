<!--#INCLUDE VIRTUAL="GlobalInclude.asp"-->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<%
Page = "AtlantixStatement"

Server.ScriptTimeout = 600 '10 Minutes

'Check Needed Session Variables
If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then Response.Redirect("/Management/Default.asp")

'If the Organization is not ACPA or Tix, redirect them.
If Session("OrganizationNumber") <> 1 And Session("OrganizationNumber") <> 10 And Session("OrganizationNumber") <> 323 Then Response.Redirect("/Management/Default.asp")

'If Session("VenueCode") = "" Or IsNull(Session("VenueCode")) Then Response.Redirect("/Management/Default.asp")

If Request("FormName") = "DailyReport" Then
	Call DisplayReport
Else
	Call DisplayForm
End If

Sub DisplayForm
%>
<HTML>
<HEAD>
<TITLE>www.TIX.com - AtlanTIX Statement</TITLE>
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
// end hiding -->
</script>
</HEAD>
<BODY BGCOLOR="#FFFFFF">
<CENTER>

<!--#include virtual="TopNavInclude.asp" -->

<BR>

<BR>

<FONT FACE="verdana,arial,helvetica" COLOR="#008400"><H3>AtlanTIX Statement</H3></FONT>
<%

If Session("OrganizationNumber") = 323 Then
	FullHalf = "Half"
Else
	FullHalf = "Full"
End If	

Response.Write "<FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">Producer Income from " & FullHalf & " Price Ticket Sales<BR>" & vbCrLf

Response.Write "<FORM ACTION=""AtlantixStatement.asp"" METHOD=""post"" NAME=""Report""><INPUT TYPE=""hidden"" NAME=""FormName"" VALUE=""DailyReport"">" & vbCrLf

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
Response.Write "<OPTION VALUE=" & Year(Date) - 1 & ">" & Year(Date) - 1 & "</OPTION>" & vbCrLf
Response.Write "<OPTION SELECTED VALUE=" & Year(Date) & ">" & Year(Date) & "</OPTION>" & vbCrLf
Response.Write "<OPTION VALUE=" & Year(Date) + 1 & ">" & Year(Date) + 1 & "</OPTION>" & vbCrLf
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
Response.Write "<OPTION VALUE=" & Year(Date) - 1 & ">" & Year(Date) - 1 & "</OPTION>" & vbCrLf
Response.Write "<OPTION SELECTED VALUE=" & Year(Date) & ">" & Year(Date) & "</OPTION>" & vbCrLf
Response.Write "<OPTION VALUE=" & Year(Date) + 1 & ">" & Year(Date) + 1 & "</OPTION>" & vbCrLf
Response.Write "</SELECT></TD></TR>" & vbCrLf

Response.Write "</TABLE><BR>" & vbCrLf

'Get all Producers (Event.Comments) for ACPA
'SQLEvents = "SELECT Event.Comments FROM Event (NOLOCK) INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE OrganizationVenue.OrganizationNumber = 10 AND OrganizationAct.OrganizationNumber = 10 GROUP BY Event.Comments ORDER BY Event.Comments"
'Set rsEvents = OBJdbConnection.Execute(SQLEvents)

'Response.Write "<B>Producer: </B><SELECT NAME=""Producer""><OPTION VALUE=0>--Select Producer--</OPTION>" & vbCrLf

'Do Until rsEvents.EOF

'	Response.Write "<OPTION VALUE=""" & rsEvents("Comments") & """>" & rsEvents("Comments") & "</OPTION>" & vbCrLf
'	rsEvents.MoveNext
	
'Loop

'Response.Write "</SELECT><BR><BR>" & vbCrLf

Response.Write "<INPUT TYPE=submit VALUE=Enter></FORM><BR><BR>" & vbCrLf

Response.Write "</FONT></CENTER>" & vbCrLf
Response.Write "</BODY>" & vbCrLf
Response.Write "</HTML>" & vbCrLf

End Sub 'Display Form

'------------------------------------------------

Sub DisplayReport

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>AtlanTIX Statement</TITLE>" & vbCrLf
Response.Write "<STYLE>" & vbCrLf
Response.Write "div {page-break-before: always}" & vbCrLf
Response.Write "</STYLE>" & vbCrLf

Response.Write "</HEAD>" & vbCrLf
Response.Write "<BODY BGCOLOR=#FFFFFF>" & vbCrLf

ReportStartDate = CDate(Request("ReportStartMonth") & "/" & Request("ReportStartDay") & "/" & Request("ReportStartYear"))
ReportEndDate = CDate(Request("ReportEndMonth") & "/" & Request("ReportEndDay") & "/" & Request("ReportEndYear"))


SQLProducer = "SELECT Event.Comments AS Producer FROM Event (NOLOCK) INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND EventDate >= '" & ReportStartDate & "' AND EventDate < '" & ReportEndDate + 1 & "' GROUP BY Event.Comments ORDER BY Event.Comments"
Set rsProducer = OBJdbConnection.Execute(SQLProducer)

Do Until rsProducer.EOF

	Response.Write "<CENTER><FONT FACE=verdana,arial,helvetica COLOR=#008400><H3>AtlanTIX Statement</H3></FONT>" & vbCrLf

	If Session("OrganizationNumber") = 323 Then
		FullHalf = "Half"
	Else
		FullHalf = "Full"
	End If	

	Response.Write "<FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">Producer Income from " & FullHalf & " Price Ticket Sales<BR><BR>" & vbCrLf

	Response.Write "<B>Statement Date:</B> " & FormatDateTime(Now(), vbShortDate) & "<BR>" & vbCrLf
	Response.Write "<B>For Period:</B> " & Request("ReportStartMonth") & "/" & Request("ReportStartDay")  & "/" & Request("ReportStartYear") & " - " & Request("ReportEndMonth") & "/" & Request("ReportEndDay") & "/" & Request("ReportEndYear") & "<BR><BR>" & vbCrLf
	Response.Write "<B>Check Payable to: </B>" & rsProducer("Producer") & "<BR><BR>" & vbCrLf

	'Sales By Act, Price Point
	Response.Write "<TABLE CELLPADDING=""3""><TR BGCOLOR=""#008400""><TD ALIGN=""center""><FONT FACE='verdana,arial,helvetica' COLOR=""#FFFFFF"" SIZE=2><B>Show Title</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=""#FFFFFF"" SIZE=2><B>" & FullHalf & " Price</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=""#FFFFFF"" SIZE=2><B>Quantity</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=""#FFFFFF"" SIZE=2><B>Sub Total</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=""#FFFFFF"" SIZE=2><B>Discount</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=""#FFFFFF"" SIZE=2><B>Total</B></FONT></TD></TR>" & vbCrLf

	SQLShows = "SELECT Act, Price, COUNT(OrderLine.ItemNumber) AS TicketCount, SUM(Price) AS TicketTotal, SUM(Discount) AS DiscountTotal FROM Act (NOLOCK) INNER JOIN Event (NOLOCK) ON Act.ActCode = Event.ActCode INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode WHERE Event.Comments = '" & CleanSingleQuote(rsProducer("Producer")) & "' AND OrderLine.StatusCode = 'S' AND EventDate >= '" & ReportStartDate & "' AND EventDate < '" & ReportEndDate + 1 & "' AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent', 'SubSeat') GROUP BY Act, Price ORDER BY Act, Price"
	Set rsShows = OBJdbConnection.Execute(SQLShows)

	Do Until rsShows.EOF
		
		Response.Write "<TR BGCOLOR=""#DDDDDD""><TD><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsShows("Act") & "</FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2>" & FormatNumber(rsShows("Price"),2) & "</FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsShows("TicketCount") & "</FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2>" & FormatNumber(rsShows("TicketTotal"), 2) & "</FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2>" & FormatNumber(rsShows("DiscountTotal"), 2) & "</FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2>" & FormatNumber(rsShows("TicketTotal") - rsShows("DiscountTotal"), 2) & "</FONT></TD></TR>" & vbCrLf

		TotalTicketCount = TotalTicketCount + rsShows("TicketCount")
		TotalTicketAmount = TotalTicketAmount + rsShows("TicketTotal") 
		TotalDiscountAmount = TotalDiscountAmount + rsShows("DiscountTotal")
		TotalAmount = TotalAmount + rsShows("TicketTotal") - rsShows("DiscountTotal")
		
		rsShows.MoveNext		

	Loop
		
	'Write out the Totals
	Response.Write "<TR BGCOLOR=#AAAAAA><TD><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Total</B></FONT></TD><TD ALIGN=right>&nbsp;</TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B>" & TotalTicketCount & "</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B>" & FormatNumber(TotalTicketAmount,2) & "</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B>" & FormatNumber(TotalDiscountAmount,2) & "</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B>" & FormatNumber(TotalAmount,2) & "</B></FONT></TD></TR>" & vbCrLf

	Response.Write "</TABLE><BR><BR>" & vbCrLf

	Response.Write "</CENTER><FONT FACE='verdana,arial,helvetica' SIZE=1>Note: " & FullHalf & "Price ticket includes any applicable venue fees.  Your Organization is solely responsible for all Georgia Sales Taxes associated with your sale of tickets and for remitting said sales tax to the state of Georgia from funds collected for, and disbursed to you by the AtlanTIX Ticket Service.   AtlanTIX Ticket Services is a program of the Atlanta Coalition of Performing Arts.  For questions regarding your statement, please call 404-873-1185.</FONT><BR><BR><DIV></DIV>" & vbCrLf

	TotalTicketCount = 0
	TotalTicketAmount = 0
	TotalDiscountAmount = 0
	TotalAmount = 0

	rsProducer.MoveNext
	
Loop

Response.Write "</BODY>" & vbCrLf
Response.Write "</HTML>" & vbCrLf
				
End Sub 'Display Report

%>

