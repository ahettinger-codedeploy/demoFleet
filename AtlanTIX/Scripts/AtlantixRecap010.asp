<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp"-->
<!--#INCLUDE VIRTUAL="CalcTixFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="NoCacheInclude.asp"-->
<%

Page = "ManagementReport"

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
<TITLE>Tix - AtlanTIX Recap</TITLE>
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

<FONT FACE="verdana,arial,helvetica" COLOR="#008400"><H3>AtlanTIX Recap</H3></FONT>
<%

If Weekday(Now) = 2 Then
	StartDate = CDate(FormatDateTime(Now - (Weekday(Now, 3)), vbShortDate))
Else
	StartDate = CDate(FormatDateTime(Now - (7 + Weekday(Now, 3)), vbShortDate))
End If
EndDate = CDate(FormatDateTime(Now - Weekday(Now, 2), vbShortDate))

Response.Write "<FORM ACTION=""AtlantixRecap.asp"" METHOD=""post"" NAME=""Report""><INPUT TYPE=""hidden"" NAME=""FormName"" VALUE=""DailyReport"">" & vbCrLf

'Get the dates for the previous week for default
StartDate = FormatDateTime(Now - (6 + Weekday(Now, 2)), vbShortDate)
EndDate = FormatDateTime(Now - Weekday(Now, 2), vbShortDate)

Response.Write "<TABLE CELLPADDING=5>"

'If this is Tix display a list of all organizations to choose from.  Otherwise Organization will be based on Session("Organization")
If Session("OrganizationNumber") = 1 Then
	Response.Write "<TR><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Organization:</B></FONT></TD><TD COLSPAN=3><SELECT NAME=OrganizationNumber>"
	
	SQLOrganization = "SELECT * FROM Organization (NOLOCK) ORDER BY Organization"
	Set rsOrganization = OBJdbConnection.Execute(SQLOrganization)

	Response.Write "<OPTION VALUE=0 SELECTED>--SELECT ORGANIZATION--" & vbCrLf
	
	Do Until rsOrganization.EOF
		Response.Write "<OPTION VALUE=" & rsOrganization("OrganizationNumber") & ">" & rsOrganization("Organization") & vbCrLf
		rsOrganization.MoveNext
	Loop
	
	Response.Write "</SELECT></TD></TR>" & vbCrLf
Else
	Response.Write "<INPUT TYPE=""hidden"" NAME=""OrganizationNumber"" VALUE=" & Session("OrganizationNumber") & ">"
End If

'REE 3/1/9 - Added Transaction Date Range option.
Response.Write "<TR><TD COLSPAN=""4""><FONT FACE='verdana,arial,helvetica' SIZE=2><INPUT TYPE=""radio"" NAME=""DateRangeType"" VALUE=""Event"" CHECKED>&nbsp;Event Date Range&nbsp;&nbsp;&nbsp;<INPUT TYPE=""radio"" NAME=""DateRangeType"" VALUE=""Transaction"">&nbsp;Transaction Date Range<br /></font></TD></TR>" & vbCrLf

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
Response.Write "<OPTION VALUE=" & Year(StartDate) - 2 & ">" & Year(StartDate) - 2 & "</OPTION>" & vbCrLf
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
Response.Write "<OPTION VALUE=" & Year(EndDate) - 2 & ">" & Year(EndDate) - 2 & "</OPTION>" & vbCrLf
Response.Write "<OPTION VALUE=" & Year(EndDate) - 1 & ">" & Year(EndDate) - 1 & "</OPTION>" & vbCrLf
Response.Write "<OPTION SELECTED VALUE=" & Year(EndDate) & ">" & Year(EndDate) & "</OPTION>" & vbCrLf
Response.Write "<OPTION VALUE=" & Year(EndDate) + 1 & ">" & Year(EndDate) + 1 & "</OPTION>" & vbCrLf
Response.Write "</SELECT></TD></TR>" & vbCrLf

Response.Write "</TABLE><BR>" & vbCrLf

Response.Write "<INPUT TYPE=submit VALUE=Enter id=submit1 name=submit1></FORM><BR><BR>" & vbCrLf

Response.Write "</FONT>" & vbCrLf

%>
	<!--#include virtual="FooterInclude.asp"-->
<%

Response.Write "</CENTER>" & vbCrLf
Response.Write "</BODY>" & vbCrLf
Response.Write "</HTML>" & vbCrLf

End Sub 'Display Form

'------------------------------------------------

Sub DisplayReport


ReportStartDate = CDate(Request("ReportStartMonth") & "/" & Request("ReportStartDay") & "/" & Request("ReportStartYear"))
ReportEndDate = CDate(Request("ReportEndMonth") & "/" & Request("ReportEndDay") & "/" & Request("ReportEndYear"))

Response.Write "<TABLE>" & vbCrLf

Response.Write "<TR><TD COLSPAN=""4"" ALIGN=""center""><FONT FACE=verdana,arial,helvetica COLOR=#008400><H3>Atlanta Coalition of Performing Arts</H3></FONT></TD></TR>" & vbCrLf

'REE 3/1/9 - Added Transaction Date option
If Clean(Request("DateRangeType")) = "Transaction" Then
    Response.Write "<TR><TD COLSPAN=""4"" ALIGN=""center""><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Sales For Transactions From " & ReportStartDate & " Through " &  ReportEndDate & "</B></FONT><BR><BR></TD></TR>" & vbCrLf
    SQLEvents = "SELECT Event.Comments AS Producer, Act.Act AS Production, SUM(OrderLine.Price) AS FaceValue, SUM(OrderLine.Surcharge) AS ServiceFee, SUM(OrderLine.Discount) AS Discount, COUNT(OrderLine.ItemNumber) AS TicketCount FROM Act (NOLOCK) INNER JOIN Event (NOLOCK) ON Act.ActCode = Event.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber WHERE OrderLine.StatusDate >= '" & ReportStartDate & "' AND OrderLine.StatusDate < '" & ReportEndDate + 1 & "' AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationVenue.Owner = 1 AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderLine.StatusCode = 'S' AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent', 'SubSeat') GROUP BY Event.Comments, Act.Act ORDER BY Event.Comments, Act.Act"
Else
    Response.Write "<TR><TD COLSPAN=""4"" ALIGN=""center""><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Sales For Events From " & ReportStartDate & " Through " &  ReportEndDate & "</B></FONT><BR><BR></TD></TR>" & vbCrLf
    SQLEvents = "SELECT Event.Comments AS Producer, Act.Act AS Production, SUM(OrderLine.Price) AS FaceValue, SUM(OrderLine.Surcharge) AS ServiceFee, SUM(OrderLine.Discount) AS Discount, COUNT(OrderLine.ItemNumber) AS TicketCount FROM Act (NOLOCK) INNER JOIN Event (NOLOCK) ON Act.ActCode = Event.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber WHERE EventDate >= '" & ReportStartDate & "' AND EventDate < '" & ReportEndDate + 1 & "' AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationVenue.Owner = 1 AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderLine.StatusCode = 'S' AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent', 'SubSeat') GROUP BY Event.Comments, Act.Act ORDER BY Event.Comments, Act.Act"
End If

Set rsEvents = OBJdbConnection.Execute(SQLEvents)

Response.Write "<TR BGCOLOR=#008400><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=""#FFFFFF"" SIZE=2><B>Producer</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=""#FFFFFF"" SIZE=2><B>Production</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=""#FFFFFF"" SIZE=2><B># Tickets</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=""#FFFFFF"" SIZE=2><B>Producer<BR>Income</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=""#FFFFFF"" SIZE=2><B>ACPA<BR>Service<BR>Income</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=""#FFFFFF"" SIZE=2><B>Total Revenue</B></FONT></TD></TR>" & vbCrLf

Do Until rsEvents.EOF
	Response.Write "<TR BGCOLOR=""#CCCCCC""><TD><FONT FACE='verdana,arial,helvetica' SIZE=2>" & CleanProducer(rsEvents("Producer")) & "</FONT></TD><TD><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsEvents("Production") & "</FONT></TD><TD ALIGN=""right""><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsEvents("TicketCount") & "</FONT></TD><TD ALIGN=""right""><FONT FACE='verdana,arial,helvetica' SIZE=2>" & FormatCurrency(rsEvents("FaceValue") - rsEvents("Discount"),2) & "</FONT></TD><TD ALIGN=""right""><FONT FACE='verdana,arial,helvetica' SIZE=2>" & FormatCurrency(rsEvents("ServiceFee")) & "</FONT></TD><TD ALIGN=""right""><FONT FACE='verdana,arial,helvetica' SIZE=2>" & FormatCurrency(rsEvents("FaceValue") + rsEvents("ServiceFee") - rsEvents("Discount"),2) & "</FONT></TD></TR>" & vbCrLf
	TotalTicketCount = TotalTicketCount + rsEvents("TicketCount")
	TotalProducerIncome = TotalProducerIncome + (rsEvents("FaceValue") - rsEvents("Discount"))
	TotalServiceFee = TotalServiceFee + rsEvents("ServiceFee")
		
	rsEvents.MoveNext
		
Loop

Response.Write "<TR BGCOLOR=""999999""><TD COLSPAN=""2""><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Subtotal</B></FONT></TD><TD ALIGN=""right""><FONT FACE='verdana,arial,helvetica' SIZE=2><B>" & TotalTicketCount & "</B></FONT></TD><TD ALIGN=""right""><FONT FACE='verdana,arial,helvetica' SIZE=2><B>" & FormatCurrency(TotalProducerIncome,2) & "</B></FONT></TD><TD ALIGN=""right""><FONT FACE='verdana,arial,helvetica' SIZE=2><B>" & FormatCurrency(TotalServiceFee,2) & "</B></FONT></TD><TD ALIGN=""right""><FONT FACE='verdana,arial,helvetica' SIZE=2><B>" & FormatCurrency(TotalProducerIncome + TotalServiceFee,2) & "</B></FONT></TD></TR>" & vbCrLf

'Calculate Tix Fees
'REE 3/1/9 - Added Transaction Date Range option
If Clean(Request("DateRangeType")) = "Transaction" Then
    SQLTixFees = "SELECT OrderHeader.OrderNumber, OrderHeader.OrderTypeNumber, OrderLine.Price, OrderLine.Discount, Event.EventCode, OrderLine.ItemType FROM Event (NOLOCK) INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE OrderLine.StatusDate >= '" & ReportStartDate & "' AND OrderLine.StatusDate < '" & ReportEndDate + 1 & "' AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationVenue.Owner = 1 AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderLine.StatusCode = 'S' AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent', 'SubSeat')"
Else
    SQLTixFees = "SELECT OrderHeader.OrderNumber, OrderHeader.OrderTypeNumber, OrderLine.Price, OrderLine.Discount, Event.EventCode, OrderLine.ItemType FROM Event (NOLOCK) INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE EventDate >= '" & ReportStartDate & "' AND EventDate < '" & ReportEndDate + 1 & "' AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationVenue.Owner = 1 AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderHeader.StatusCode = 'S' AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent', 'SubSeat')"
End If
Set rsTixFees = OBJdbConnection.Execute(SQLTixFees)

Do Until rsTixFees.EOF

	SQLCreditCard = "SELECT TenderType.TenderNumber FROM Tender (NOLOCK) INNER JOIN TenderType (NOLOCK) ON Tender.TenderNumber = TenderType.TenderNumber WHERE Tender.OrderNumber = " & rsTixFees("OrderNumber") & " AND TenderType.TenderMethod = 'Credit Card'"
	Set rsCreditCard = OBJdbConnection.Execute(SQLCreditCard)
	If Not rsCreditCard.EOF Then
		TenderNumber = rsCreditCard("TenderNumber")
	Else
		SQLTender = "SELECT TenderNumber FROM Tender (NOLOCK) WHERE OrderNumber = " & rsTixFees("OrderNumber")
		Set rsTender = OBJdbConnection.Execute(SQLTender)
		
		If Not rsTender.EOF Then
			TenderNumber = rsTender("TenderNumber")
		Else
			TenderNumber = 1 'Set to Cash as default
		End If
		
		rsTender.Close
		Set rsTender = nothing
		
	End If

	rsCreditCard.Close
	Set rsCreditCard = nothing

	'JAI - 2/9/5 - Added ItemType to CalcTixFee
	TixFees = TixFees + CalcTixFee(Session("OrganizationNumber"), rsTixFees("OrderTypeNumber"), TenderNumber, rsTixFees("Price"), rsTixFees("Discount"), rsTixFees("EventCode"), rsTixFees("ItemType"))

	rsTixFees.MoveNext
	
Loop

rsTixFees.Close
Set rsTixFees = nothing

Response.Write "<TR BGCOLOR=""999999""><TD COLSPAN=""2""><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Total</B></FONT></TD><TD ALIGN=""right""><FONT FACE='verdana,arial,helvetica' SIZE=2><B>" & TotalTicketCount & "</B></FONT></TD><TD ALIGN=""right""><FONT FACE='verdana,arial,helvetica' SIZE=2><B>" & FormatCurrency(TotalProducerIncome,2) & "</B></FONT></TD><TD ALIGN=""right""><FONT FACE='verdana,arial,helvetica' SIZE=2><B>" & FormatCurrency(TotalServiceFee,2) & "</B></FONT></TD><TD ALIGN=""right""><FONT FACE='verdana,arial,helvetica' SIZE=2><B>" & FormatCurrency(TotalProducerIncome + TotalServiceFee - TixFees,2) & "</B></FONT></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=""CCCCCC""><TD COLSPAN=""5""><FONT FACE='verdana,arial,helvetica' SIZE=2>Tix Fees</FONT></TD><TD ALIGN=""right""><FONT FACE='verdana,arial,helvetica' SIZE=2>" & FormatCurrency(TixFees*-1,2) & "</FONT></TD></TR>" & vbCrLf

Response.Write "</TABLE>" & vbCrLf
rsEvents.Close
Set rsEvents = nothing

'Response.Write "<BR><FONT FACE='verdana,arial,helvetica' SIZE=2>A deposit has been made into your account in  the amount of " & FormatCurrency(TotalProducerIncome + TotalServiceFee - TixFees,2) & " on " & ReportEndDate + 5 & ".<BR><BR>" & vbCrLf
Response.Write "<BR><FONT FACE='verdana,arial,helvetica' SIZE=2>Net Revenue = " & FormatCurrency(TotalProducerIncome + TotalServiceFee - TixFees,2) & "<BR><BR>" & vbCrLf
Response.Write "Thank you for choosing Tix!</FONT><BR><BR>" & vbCrLf
	
End Sub 'Display Report

Function CleanProducer(Producer)

CleanProducer = Replace(Producer, "<B>", "")
CleanProducer = Replace(CleanProducer, "</B>", "")

End Function 'RemoveBold

%>
