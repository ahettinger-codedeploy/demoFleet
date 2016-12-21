<!--#INCLUDE VIRTUAL="GlobalInclude.asp"-->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<%
Page = "ManagementReport"

Server.ScriptTimeout = 60 * 10

If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then Response.Redirect("/Management/Default.asp")

If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then Response.Redirect("/Management/Default.asp")

If Request("FormName") = "DailyReport" Then
	Call DisplayReport
Else
	Call DisplayForm
End If

Sub DisplayForm
%>
<HTML>
<HEAD>
<TITLE>Tix - Discount Code Report</TITLE>
<!-- EM 04/20/07 modified function makeCheck and added a checkbox to the form to check and uncheck all the checkboxes-->
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

function makeCheck(thisForm){
	for (i = 0; i < thisForm.EventCode.length; i++){
		if(thisForm.SelectAll.checked==true){
			thisForm.EventCode[i].checked=true
			}
			else
			{
			thisForm.EventCode[i].checked=false
			}
		}
	}

function ValidateForm(){
formObj = document.Report;
if (!isDate(formObj.ReportDay.value, formObj.ReportMonth.value, formObj.ReportYear.value))
	{alert("Invalid Date");
	formObj.ReportMonth.focus();
    return false;
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

<FONT FACE="verdana,arial,helvetica" COLOR="#008400"><H3>Discount Code Report</H3></FONT>
<FONT FACE="verdana,arial,helvetica" SIZE="2">
<FORM ACTION="DiscountCodeReport.asp" METHOD="post" NAME="Report"><INPUT TYPE="hidden" NAME="FormName" VALUE="DailyReport">

<%
'Get all events for Organization

'REE 6/30/3 - Added OrganizationOption ReportArchiveDays
'If there's an entry use it.  Otherwise use -31
SQLArchiveDays = "SELECT OptionValue FROM OrganizationOptions (NOLOCK) WHERE OrganizationNumber = " & Session("OrganizationNumber") & " AND OptionName = 'ReportArchiveDays'"
Set rsArchiveDays = OBJdbConnection.Execute(SQLArchiveDays)

If Not rsArchiveDays.EOF Then
	ArchiveDays = rsArchiveDays("OptionValue")
Else
	ArchiveDays = 31
End If

rsArchiveDays.Close
Set rsArchiveDays = nothing


'REE 4/6/2 - Modified to include OrganizationAct selection criteria
Select Case Request("SortMethod")
	Case "Act"
		SQLEvents = "SELECT Event.EventCode, Act, Venue, EventDate FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE EventDate > GETDATE()-" & ArchiveDays & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " ORDER BY Act, Venue, EventDate"
	Case "Venue"
		SQLEvents = "SELECT Event.EventCode, Act, Venue, EventDate FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE EventDate > GETDATE()-" & ArchiveDays & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " ORDER BY Venue, EventDate"
	Case Else
		SQLEvents = "SELECT Event.EventCode, Act, Venue, EventDate FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE EventDate > GETDATE()-" & ArchiveDays & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " ORDER BY EventDate, Act"
End Select
Set rsEvents = OBJdbConnection.Execute(SQLEvents)

Response.Write "<TABLE CELLPADDING=""3"">" & vbCrLf
Response.Write "<TR BGCOLOR=""#008400""><TD ALIGN=""center""><INPUT TYPE=checkbox Name=SelectAll onClick=""makeCheck(this.form)"" id=SelectAll name=SelectAll></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><A class=sort HREF=SalesbyEventReport.asp?SortMethod=Date>Date/Time</A></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><A class=sort HREF=SalesbyEventReport.asp?SortMethod=Act>Production</A></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><A class=sort HREF=SalesbyEventReport.asp?SortMethod=Venue>Venue</A></FONT></TD></TR>" & vbCrLf


Do Until rsEvents.EOF

	Response.Write "<TR BGCOLOR=""#DDDDDD""><TD><INPUT TYPE=""checkbox"" NAME=""EventCode"" VALUE=" & rsEvents("EventCode") & "></TD><TD NOWRAP><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & DateAndTimeFormat(rsEvents("EventDate")) & "</FONT></TD><TD><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsEvents("Act") & "</FONT></TD><TD><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsEvents("Venue") & "</FONT></TD></TR>" & vbCrLf
	rsEvents.MoveNext
	
Loop
Response.Write "</TABLE></CENTER><LEFT><BR>" & vbCrLf

Response.Write "<CENTER><INPUT TYPE=submit VALUE=Submit></FORM><BR><BR>" & vbCrLf

Response.Write "</FONT>" & vbCrLf

%>
<!--#INCLUDE VIRTUAL="FooterInclude.asp" -->
<%

Response.Write "</CENTER>" & vbCrLf
Response.Write "</BODY>" & vbCrLf
Response.Write "</HTML>" & vbCrLf

End Sub 'Display Form

'------------------------------------------------

Sub DisplayReport

%>
<HTML>
<HEAD>
<TITLE>Tix - Discount Code Report</TITLE>
</HEAD>
<BODY BGCOLOR="#FFFFFF">
<CENTER>

<!--#include virtual="TopNavInclude.asp" -->

<BR>
<BR>

<FONT FACE=verdana,arial,helvetica COLOR=#008400><H3>Discount Code Report</H3></FONT>
<FONT FACE=verdana,arial,helvetica SIZE=2>
<FORM ACTION="DiscountCodeReport.asp" METHOD="post" id=form1 name=form1>

<%

EventTicketCount = 0
EventFaceValue = 0
EventDiscount = 0
EventNet = 0
TotalTicketCount = 0
TotaFaceValue = 0
TotalDiscount = 0
TotalNet = 0

'For each event chosen from the previous page, display the data
If Request("EventCode") <> "" Then
	EventList = "("
	For Each EventCode In Request("EventCode")
		EventList = EventList & EventCode & ","
	Next 'Event
	EventList = Left(EventList, Len(EventList)-1) & ")"
	
	'REE 5/28/3 - Modified to use LEFT JOIN on Seat Table.  Program blew up if there were no seats assigned to an event...Client deleted all seats.	
	SQLDiscount = "SELECT Event.EventCode, DiscountType.DiscountTypeNumber, DiscountDescription, UPPER(DiscountCode) AS DiscountCode, COUNT(OrderLine.LineNumber) AS TicketCount, SUM(OrderLine.Price) AS FaceValue, SUM(OrderLine.Discount) AS Discount FROM Orderline (NOLOCK) INNER JOIN Orderheader (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN DiscountType (NOLOCK) ON OrderLine.DiscountTypeNumber = DiscountType.DiscountTypeNumber WHERE Event.EventCode IN " & EventList & " AND OrderHeader.StatusCode = 'S' AND DiscountCode IS NOT NULL GROUP BY Event.EventCode, DiscountType.DiscountTypeNumber, DiscountDescription, DiscountCode ORDER BY Event.EventCode, DiscountType.DiscountTypeNumber, DiscountDescription, DiscountCode"
 	Set rsDiscount = OBJdbConnection.Execute(SQLDiscount)

	If Not rsDiscount.EOF Then

		LastEventCode = rsDiscount("EventCode")
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

		Response.Write "<TABLE CELLPADDING=4>" & vbCrLf
		Response.Write "<TR BGCOLOR=#008400><TD COLSPAN=4><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><B>" & rsEvents("Act") & "</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2 COLOR=#FFFFFF><B>" & FormatDateTime(rsEvents("EventDate"), vbShortDate) & "</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2 COLOR=#FFFFFF><B>" & EventTime & "</B></FONT></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=#AAAAAA><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Discount Description</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Discount Code</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Ticket Count</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Face Value</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Discount</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Net Price</B></FONT></TD></TR>" & vbCrLf

		Do Until rsDiscount.EOF

			If rsDiscount("EventCode") <> LastEventCode Then
		
				EventTotal = EventRevenue + EventServiceFees - EventDiscount
				Response.Write "<TR BGCOLOR=#AAAAAA><TD ALIGN=center COLSPAN=2><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Event Total</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B>" & FormatNumber(EventTicketCount,0) & "</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B>" & FormatCurrency(EventFaceValue, 2) & "</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B>" & FormatCurrency(EventDiscount, 2) & "</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B>" & FormatCurrency(EventNet, 2) & "</B></FONT></TD></TR>" & vbCrLf
				TotalTicketCount = TotalTicketCount + EventTicketCount
				EventTicketCount = 0
				TotalFaceValue = TotalFaceValue + EventFaceValue
				EventFaceValue = 0
				TotalDiscount = TotalDiscount + EventDiscount
				EventDiscount = 0
				TotalNet = TotalNet + EventNet
				EventNet = 0
				LastEventCode = rsDiscount("EventCode")

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

				Response.Write "<TR BGCOLOR=#008400><TD COLSPAN=4><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><B>" & rsEvents("Act") & "</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2 COLOR=#FFFFFF><B>" & FormatDateTime(rsEvents("EventDate"), vbShortDate) & "</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2 COLOR=#FFFFFF><B>" & EventTime & "</B></FONT></TD></TR>" & vbCrLf
				Response.Write "<TR BGCOLOR=#AAAAAA><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Discount Description</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Discount Code</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Ticket Count</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Face Value</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Discount</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Net Price</B></FONT></TD></TR>" & vbCrLf

			End If

			Response.Write "<TR BGCOLOR=#DDDDDD><TD><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsDiscount("DiscountDescription") & "</FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2>" &rsDiscount("DiscountCode") & "</FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2>" & FormatNumber(rsDiscount("TicketCount"), 0) & "</FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2>" & FormatCurrency(rsDiscount("FaceValue"), 2) & "</FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2>" & FormatCurrency(rsDiscount("Discount"), 2) & "</FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2>" & FormatCurrency(rsDiscount("FaceValue") - rsDiscount("Discount"), 2) & "</FONT></TD></TR>" & vbCrLf

			EventTicketCount = EventTicketCount + rsDiscount("TicketCount")
			EventFaceValue = EventFaceValue + rsDiscount("FaceValue")
			EventDiscount = EventDiscount + rsDiscount("Discount")
			EventNet = EventNet + rsDiscount("FaceValue") - rsDiscount("Discount")

			rsDiscount.MoveNext	
		Loop

		Response.Write "<TR BGCOLOR=#AAAAAA><TD ALIGN=center COLSPAN=2><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Event Total</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B>" & FormatNumber(EventTicketCount,0) & "</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B>" & FormatCurrency(EventFaceValue, 2) & "</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B>" & FormatCurrency(EventDiscount, 2) & "</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B>" & FormatCurrency(EventNet, 2) & "</B></FONT></TD></TR>" & vbCrLf
		TotalTicketCount = TotalTicketCount + EventTicketCount
		EventTicketCount = 0
		TotalFaceValue = TotalFaceValue + EventFaceValue
		EventFaceValue = 0
		TotalDiscount = TotalDiscount + EventDiscount
		EventDiscount = 0
		TotalNet = TotalNet + EventNet
		EventNet = 0
		Response.Write "<TR BGCOLOR=#DDDDDD><TD ALIGN=center COLSPAN=2><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Total</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B>" & FormatNumber(TotalTicketCount,0) & "</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B>" & FormatCurrency(TotalFaceValue, 2) & "</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B>" & FormatCurrency(TotalDiscount, 2) & "</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B>" & FormatCurrency(TotalNet, 2) & "</B></FONT></TD></TR>" & vbCrLf

		Response.Write "</TABLE>" & vbCrLf
	Else
		Response.Write "There were no discount codes used for these events."
	End If	
Else				
	Response.Write "There were no events selected."
End If
		
%>

</FONT>
</CENTER>

<!--#INCLUDE VIRTUAL="FooterInclude.asp"-->

</BODY>
</HTML>

<%
End Sub 'Display Report
%>
