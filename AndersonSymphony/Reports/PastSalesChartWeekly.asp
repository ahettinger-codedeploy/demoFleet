<!--#include virtual="GlobalInclude.asp"-->
<!--#include virtual="dbOpenInclude.asp"-->
<%
Page = "SalesChartWeekly"

If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then Response.Redirect("/Management/Default.asp")

If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then Response.Redirect("/Management/Default.asp")

%>
<HTML>
<HEAD>
<TITLE>Tix - Weekly Sales Chart</TITLE>
<script LANGUAGE="JavaScript">    

<!-- Hide code from non-js browsers

function ValidateForm(){
formObj = document.Report;
if (formObj.Events.value == 0) {
	alert("Select an event");
	formObj.Events.focus();
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

<FONT FACE=verdana,arial,helvetica COLOR=#008400><H3>Past Sales Chart - Weekly</H3></FONT>
<FONT FACE=verdana,arial,helvetica>
<FORM ACTION="/Reports/SalesChartWeekly.asp" METHOD="post" name=Report onSubmit="return ValidateForm()">
<SELECT NAME="Events">
<%

'REE 4/6/2 - Modified to include OrganizationAct selection criteria
SQLEvents = "SELECT Event.EventCode, Act, EventDate FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " ORDER BY EventDate"
Set rsEvents = OBJdbConnection.Execute(SQLEvents)
Response.Write "<OPTION VALUE=0 SELECTED>--Select Event--" & vbCrLf

Do Until rsEvents.EOF
	Response.Write "<OPTION VALUE=" & rsEvents("EventCode") & ">" & rsEvents("EventDate") & "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" & rsEvents("Act") & vbCrLf
	rsEvents.MoveNext
Loop

Response.Write "</SELECT>" & vbCrLf
Response.Write "<INPUT TYPE=submit VALUE=Enter></FORM>" & vbCrLf
If Request("Events") <> "" Then

	For DateNum = 1 To 7
		SQLSales = "SELECT SUM(Price) AS Sales, SUM(OrderLine.Discount) AS Discount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE EventCode = " & Request("Events") & " AND OrderHeader.OrderDate >= '" & FormatDateTime(Now() - (7 - DateNum), vbShortDate) & "' AND OrderHeader.OrderDate <= '" & FormatDateTime(Now() - (6 - DateNum), vbShortDate) & "' AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent', 'SubSeat')"
		Set rsSales = OBJdbConnection.Execute(SQLSales)
		Session("Sales" & DateNum) = rsSales("Sales") - rsSales("Discount")
		If IsNull(Session("Sales" & DateNum)) Then
			Session("Sales" & DateNum) = 0
		End If
		Session("SalesDate" & DateNum) = FormatDateTime(Now() - (7-DateNum), vbShortDate)
	Next
	SQLEvents = "SELECT Act, EventDate FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode WHERE Event.EventCode = " & Request("Events")
	Set rsEvents = OBJdbConnection.Execute(SQLEvents)
	Response.Write "<img src=/Reports/SalesChartWeeklyMem.asp?Event=" & Server.URLEncode(rsEvents("Act") & " " & rsEvents("EventDate")) & " alt='" & rsEvents("Act") & " " & rsEvents("EventDate") & "'><BR>" & vbCrLf

End If

%>

</FONT>

<!--#include virtual="FooterInclude.asp"-->

</CENTER>


</BODY>
</HTML>
