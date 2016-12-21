<!--#include virtual="GlobalInclude.asp"-->
<!--#include virtual="dbOpenInclude.asp"-->
<%
Page = "ManagementReport"

'REE 4/12/6 - Added Script Timeout
Server.ScriptTimeout = 1200

Response.Buffer = False

If Session("UserNumber") = "" Or IsNull(Session("UserNumber"))Then
Session.Abandon
OBJdbConnection.Close
Set OBJdbConnection = nothing
Response.Redirect("/Management/Default.asp")
End If

If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then 
Session.Abandon
OBJdbConnection.Close
Set OBJdbConnection = nothing
Response.Redirect("/Management/Default.asp")
End If

'Set Variables
Excel = Clean(Request("ExcelOutput"))

If Excel = "Y" Then
	Response.ContentType = "application/vnd.ms-excel"
End If

%>
<HTML>
<HEAD>
<TITLE>Tix - Conference Report</TITLE>
<script LANGUAGE="JavaScript">    

<!-- Hide code from non-js browsers

function ValidateForm(){
formObj = document.Report;
if (formObj.Events.value == 0) {
	alert("Select an event");
	formObj.Events.focus();
    return false;
    }
if ((!formObj.Available.checked) && (!formObj.Hold.checked) && (!formObj.Reserved.checked) && (!formObj.Open.checked)&& (!formObj.Sold.checked)) {
	alert("You must select at least one status to include.");
	formObj.Available.focus();
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

<%


If Excel <> "Y" Then
%>
	<!--#include virtual="/TopNavInclude.asp" -->
<%
End If

Response.Write "<BR><BR>"& vbCrLf
Response.Write "<FONT FACE=verdana,arial,helvetica COLOR=#008400><H3>Douglas County Libraries Foundation<BR>Custom Event Detail Report</H3></FONT>"& vbCrLf

If Excel <> "Y" Then
%>

	<FONT FACE=verdana,arial,helvetica SIZE=2>
	<FORM ACTION="ConferenceReport.asp" METHOD="post" id=form1 name=Report onSubmit="return ValidateForm()">
	<SELECT NAME="Events">
<%

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
	 SQLEvents = "SELECT Event.EventCode, Act, EventDate, Event.SurveyNumber FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE EventDate > GETDATE()-" & ArchiveDays & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " ORDER BY EventDate"
	'SQLEvents = "SELECT Event.EventCode, Act, EventDate, Event.SurveyNumber FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN Seat ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine ON Seat.OrderNumber = Orderline.OrderNumber INNER JOIN OrderLineDetail ON OrderLine.OrderNumber = OrderLineDetail.OrderNumber WHERE EventDate > GETDATE()-" & ArchiveDays & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " GROUP BY Event.EventCode, Act.Act, Event.EventDate, Event.SurveyNumber ORDER BY EventDate"
	Set rsEvents = OBJdbConnection.Execute(SQLEvents)
	Response.Write "<OPTION VALUE=0 SELECTED>--Select Event--" & vbCrLf
	Do Until rsEvents.EOF
		Response.Write "<OPTION VALUE=" & rsEvents("EventCode") & ">" & rsEvents("EventDate") & "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" & rsEvents("Act") & vbCrLf
		If Not IsNull(rsEvents("SurveyNumber")) Then 'There's a survey.  Display the survey option.
			SurveyExists = "Y"
		End If
		rsEvents.MoveNext
	Loop

	Response.Write "</SELECT><BR><BR>" & vbCrLf


	If Request("Available") = "on" Then AvailableChecked = " CHECKED"
	If Request("Hold") = "on" Then HoldChecked = " CHECKED"
	If Request("Reserved") = "on" Then ReservedChecked = " CHECKED"
	If Request("Open") = "on" Then OpenChecked = " CHECKED"
	If Request("Sold") = "on" Or Request("Events") = "" Then SoldChecked = " CHECKED"
	
	
	Response.Write "<B>Include:</B> <INPUT TYPE=checkbox NAME=Available" & AvailableChecked & ">Available" & vbCrLf

	Response.Write "<INPUT TYPE=checkbox NAME=Hold" &  HoldChecked & ">Hold" & vbCrLf
	
	Response.Write "<INPUT TYPE=checkbox NAME=Reserved" & ReservedChecked & ">Reserved" & vbCrLf

	Response.Write "<INPUT TYPE=checkbox NAME=Sold" & SoldChecked & ">Sold<BR><BR>" & vbCrLf

	Response.Write "<TABLE ALIGN=CENTER CELLPADDING=0 CELLSPACING=1><TR>" & vbCrLf
	
	
	If Request("IncludeAttendee") = "on" Then AttendeeChecked = " CHECKED"
	Response.Write "<TD><INPUT TYPE=""checkbox"" NAME=""IncludeAttendee""" & AttendeeChecked & "></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2>Include Workshop Selection</FONT></TD></TR><TR>" & vbCrLf


	If Request("IncludeLunch") = "on" Then LunchChecked = " CHECKED"
	Response.Write "<TD><INPUT TYPE=""checkbox"" NAME=""IncludeLunch""" & LunchChecked & "></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2>Include Lunch Selection</FONT></TD></TR><TR>" & vbCrLf

	
	If Request("IncludePitch") = "on" Then PitchChecked = " CHECKED"
	Response.Write "<TD><INPUT TYPE=""checkbox"" NAME=""IncludePitch""" & PitchChecked & "></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2>Include Agent & Pitch Session</FONT></TD></TR><TR>" & vbCrLf



	Response.Write "<TD><INPUT TYPE=""checkbox"" NAME=""ExcelOutput"" VALUE=""Y""></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2>Output To Excel</FONT></TD>" & vbCrLf
	
	Response.Write "</TR></TABLE><BR>" & vbCrLf

	Response.Write "<INPUT TYPE=submit VALUE=Enter></FORM><BR><BR>" & vbCrLf

End If

If Request("Events") <> "" Then

	SQLSeat = "SELECT Seat.EventCode, OrderLine.OrderNumber, OrderLine.LineNumber, Seat.ItemNumber, Section, Row, Seat, SeatStatus.Status, OrderType, OrderLine.SeatTypeCode, SeatType, Price, OrderLine.Discount, OrderDate, OrderHeader.CustomerNumber, Customer.FirstName AS FirstName, Customer.LastName AS LastName, (SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'FirstName') as AttendeeFirstName, (SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'LastName') as AttendeeLastName, (SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'SessionOne') as SESSIONONE,(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'SessionTwo') as SessionTwo,(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'SessionThree') as SessionThree,(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'SessionFour') as SessionFour, (SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'Lunch') as Lunch, (SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'PitchAgent') as PitchAgent, (SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'PitchSessionTime') as PitchSession, OrganizationCustomerClass.Class FROM Seat (NOLOCK) INNER JOIN Section (NOLOCK) ON Seat.SectionCode = Section.SectionCode AND Seat.EventCode = Section.EventCode INNER JOIN SeatStatus (NOLOCK) ON Seat.StatusCode = SeatStatus.StatusCode LEFT JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent', 'SubSeat') INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode AND OrganizationVenue.OrganizationNumber = OrganizationAct.OrganizationNumber LEFT JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber LEFT JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode LEFT JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber LEFT JOIN CustomerClass (NOLOCK) ON OrderHeader.CustomerNumber = CustomerClass.CustomerNumber LEFT JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber LEFT JOIN OrganizationCustomerClass (NOLOCK) ON CustomerClass.ClassNumber = OrganizationCustomerClass.ClassNumber AND OrganizationVenue.OrganizationNumber = OrganizationCustomerClass.OrganizationNumber LEFT JOIN OrderLineDetail (NOLOCK) ON OrderHeader.OrderNumber  = OrderLineDetail.OrderNumber WHERE Seat.EventCode = " & CleanNumeric(Request("Events")) & " AND OrganizationVenue.OrganizationNumber = " &  Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber")
		
		If Request("Available") <> "on" Or Request("Hold") <> "on" Or Request("Reserved") <> "on" Or Request("Open") <> "on" Or Request("Sold") <> "on" Then 'Select Status Codes in Query
		SQLSeat = SQLSeat & " AND Seat.StatusCode IN ("
		CommaSeparator = ""

		If Request("Available") = "on" Then
			SQLSeat = SQLSeat & CommaSeparator & "'A'"
			CommaSeparator = ","
		End If

		If Request("Hold") = "on" Then
			SQLSeat = SQLSeat & CommaSeparator & "'H'"
			CommaSeparator = ","
		End If

		If Request("Reserved") = "on" Then
			SQLSeat = SQLSeat & CommaSeparator & "'R'"
			CommaSeparator = ","
		End If

		If Request("Open") = "on" Then
			SQLSeat = SQLSeat & CommaSeparator & "'O'"
			CommaSeparator = ","
		End If

		If Request("Sold") = "on" Then 
			SQLSeat = SQLSeat & CommaSeparator & "'S'"
			CommaSeparator = ","
		End If

		SQLSeat = SQLSeat & ")"
	End If
		
	'JAI 5/3 - Added Display Order	
	Select Case Request("SortMethod")
		Case "OrderNumber"
			SQLSeat = SQLSeat & " GROUP BY Seat.EventCode, OrderLine.OrderNumber, OrderLine.LineNumber, Seat.ItemNumber, Seat.SectionCode, Section, Seat.RowSort, Row, Seat, Seat.SeatSort, SeatStatus.Status, OrderType, OrderLine.SeatTypeCode, SeatType, Price, OrderLine.Discount, OrderDate, OrderHeader.CustomerNumber, FirstName, LastName, OrganizationCustomerClass.Class ORDER BY OrderLine.OrderNumber, Seat.SectionCode, RowSort, SeatSort DESC"
		Case "CustomerName"
			SQLSeat = SQLSeat & " GROUP BY Seat.EventCode, OrderLine.OrderNumber, OrderLine.LineNumber, Seat.ItemNumber, Seat.SectionCode, Section, Seat.RowSort, Row, Seat, Seat.SeatSort, SeatStatus.Status, OrderType, OrderLine.SeatTypeCode, SeatType, Price, OrderLine.Discount, OrderDate, OrderHeader.CustomerNumber, FirstName, LastName, OrganizationCustomerClass.Class ORDER BY LastName, FirstName, OrderLine.OrderNumber"
		Case "AttendeeName"
			SQLSeat = SQLSeat & " GROUP BY Seat.EventCode, OrderLine.OrderNumber, OrderLine.LineNumber, Seat.ItemNumber, Seat.SectionCode, Section, Seat.RowSort, Row, Seat, Seat.SeatSort, SeatStatus.Status, OrderType, OrderLine.SeatTypeCode, SeatType, Price, OrderLine.Discount, OrderDate, OrderHeader.CustomerNumber, FirstName, LastName, OrganizationCustomerClass.Class ORDER BY AttendeeLastName, AttendeeFirstName, OrderLine.OrderNumber"
		Case "SessionOne"
			SQLSeat = SQLSeat & " GROUP BY Seat.EventCode, OrderLine.OrderNumber, OrderLine.LineNumber, Seat.ItemNumber, Seat.SectionCode, Section, Seat.RowSort, Row, Seat, Seat.SeatSort, SeatStatus.Status, OrderType, OrderLine.SeatTypeCode, SeatType, Price, OrderLine.Discount, OrderDate, OrderHeader.CustomerNumber, FirstName, LastName, OrganizationCustomerClass.Class ORDER BY SessionOne, OrderLine.OrderNumber"
		Case "SessionTwo"
			SQLSeat = SQLSeat & " GROUP BY Seat.EventCode, OrderLine.OrderNumber, OrderLine.LineNumber, Seat.ItemNumber, Seat.SectionCode, Section, Seat.RowSort, Row, Seat, Seat.SeatSort, SeatStatus.Status, OrderType, OrderLine.SeatTypeCode, SeatType, Price, OrderLine.Discount, OrderDate, OrderHeader.CustomerNumber, FirstName, LastName, OrganizationCustomerClass.Class ORDER BY SessionTwo, OrderLine.OrderNumber"
		Case "SessionThree"
			SQLSeat = SQLSeat & " GROUP BY Seat.EventCode, OrderLine.OrderNumber, OrderLine.LineNumber, Seat.ItemNumber, Seat.SectionCode, Section, Seat.RowSort, Row, Seat, Seat.SeatSort, SeatStatus.Status, OrderType, OrderLine.SeatTypeCode, SeatType, Price, OrderLine.Discount, OrderDate, OrderHeader.CustomerNumber, FirstName, LastName, OrganizationCustomerClass.Class ORDER BY SessionThree, OrderLine.OrderNumber"
		Case "SessionFour"
			SQLSeat = SQLSeat & " GROUP BY Seat.EventCode, OrderLine.OrderNumber, OrderLine.LineNumber, Seat.ItemNumber, Seat.SectionCode, Section, Seat.RowSort, Row, Seat, Seat.SeatSort, SeatStatus.Status, OrderType, OrderLine.SeatTypeCode, SeatType, Price, OrderLine.Discount, OrderDate, OrderHeader.CustomerNumber, FirstName, LastName, OrganizationCustomerClass.Class ORDER BY SessionFour, OrderLine.OrderNumber"
		Case "Lunch"
			SQLSeat = SQLSeat & " GROUP BY Seat.EventCode, OrderLine.OrderNumber, OrderLine.LineNumber, Seat.ItemNumber, Seat.SectionCode, Section, Seat.RowSort, Row, Seat, Seat.SeatSort, SeatStatus.Status, OrderType, OrderLine.SeatTypeCode, SeatType, Price, OrderLine.Discount, OrderDate, OrderHeader.CustomerNumber, FirstName, LastName, OrganizationCustomerClass.Class ORDER BY Lunch, OrderLine.OrderNumber"
		Case "Pitch"
			SQLSeat = SQLSeat & " GROUP BY Seat.EventCode, OrderLine.OrderNumber, OrderLine.LineNumber, Seat.ItemNumber, Seat.SectionCode, Section, Seat.RowSort, Row, Seat, Seat.SeatSort, SeatStatus.Status, OrderType, OrderLine.SeatTypeCode, SeatType, Price, OrderLine.Discount, OrderDate, OrderHeader.CustomerNumber, FirstName, LastName, OrganizationCustomerClass.Class ORDER BY PitchAgent, OrderLine.OrderNumber"
		Case "OrderType"
			SQLSeat = SQLSeat & " GROUP BY Seat.EventCode, OrderLine.OrderNumber, OrderLine.LineNumber, Seat.ItemNumber, Seat.SectionCode, Section, Seat.RowSort, Row, Seat, Seat.SeatSort, SeatStatus.Status, OrderType, OrderLine.SeatTypeCode, SeatType, Price, OrderLine.Discount, OrderDate, OrderHeader.CustomerNumber, FirstName, LastName, OrganizationCustomerClass.Class ORDER BY OrderType, OrderLine.OrderNumber"
		Case Else
			SQLSeat = SQLSeat & " GROUP BY Seat.EventCode, OrderLine.OrderNumber, OrderLine.LineNumber, Seat.ItemNumber, Seat.SectionCode, Section, Seat.RowSort, Row, Seat, Seat.SeatSort, SeatStatus.Status, OrderType, OrderLine.SeatTypeCode, SeatType, Price, OrderLine.Discount, OrderDate, OrderHeader.CustomerNumber, FirstName, LastName, OrganizationCustomerClass.Class ORDER BY Seat.SectionCode, Seat.RowSort, Seat.SeatSort DESC"
	End Select
	
	Set rsSeat = OBJdbConnection.Execute(SQLSeat)
	
	If Not rsSeat.EOF Then

		SQLEvent = "SELECT Act, Venue, EventDate, OrganizationVenue.OrganizationNumber FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) on Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) on Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = Act.ActCode AND OrganizationVenue.OrganizationNumber = OrganizationAct.OrganizationNumber WHERE Event.EventCode = " & rsSeat("EventCode") & " AND OrganizationVenue.Owner <> 0"
		Set rsEvent = OBJdbConnection.Execute(SQLEvent)
		Response.Write "<TABLE CELLPADDING=5 BORDER=0><TR><TD><FONT FACE=verdana,arial,helvetica SIZE=2><B>" & rsEvent("Act") & "</B></FONT></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2><B>" & rsEvent("Venue") & "</B></FONT></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2><B>" & FormatDateTime(rsEvent("EventDate"), vbShortDate) & "</B></FONT></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2><B>" & Left(FormatDateTime(rsEvent("EventDate"), vbLongTime), Len(FormatDateTime(rsEvent("EventDate"), vbLongTime))-6) & " " & Right(FormatDateTime(rsEvent("EventDate"),vbLongTime), 2) & "</B></FONT></TD></TR></TABLE>" & vbCrLf
		EventOrganizationNumber = rsEvent("OrganizationNumber")
		
		rsEvent.Close
		Set rsEvent = nothing
		

		If Excel <> "Y" Then

			If Request("Available") = "on" Then Response.Write "<IMG SRC=/images/blusquar.gif>Available&nbsp;&nbsp;&nbsp;"
			'REE 3/8/2 - Added Hold Status
			If Request("Hold") = "on" Then Response.Write "<IMG SRC=/images/blusquar.gif>Hold&nbsp;&nbsp;&nbsp;"
			If Request("Reserved") = "on" Then Response.Write "<IMG SRC=/images/blusquar.gif>Reserved&nbsp;&nbsp;&nbsp;"
			If Request("Open") = "on" Then Response.Write "<IMG SRC=/images/blusquar.gif>Open&nbsp;&nbsp;&nbsp;"
			If Request("Sold") = "on" Then Response.Write "<IMG SRC=/images/blusquar.gif>Sold"

		End If
		
		Call DBOpen(OBJdbConnection2)
				
		'Attendee Column 
		If Clean(Request("IncludeAttendee")) = "on" Then
			AttendeeHeading = "<TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B><A class=sort HREF=ConferenceReport.asp?SortMethod=AttendeeName&Events=" & Request("Events") & "&Hold=" & Request("Hold") & "&Reserved=" & Request("Reserved") & "&Open=" & Request("Open") & "&Sold=" & Request("Sold") &  "&Available=" & Request("Available") & "&IncludeOrderNotes=" & Request("IncludeOrderNotes") & "#Anc_Sort>&nbsp;Attendee Name&nbsp;</A></B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B><A class=sort HREF=ConferenceReport.asp?SortMethod=SessionOne&Events=" & Request("Events") & "&Hold=" & Request("Hold") & "&Reserved=" & Request("Reserved") & "&Open=" & Request("Open") & "&Sold=" & Request("Sold") &  "&Available=" & Request("Available") & "&IncludeOrderNotes=" & Request("IncludeOrderNotes") & "#Anc_Sort>&nbsp;Session One&nbsp;</A></B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B><A class=sort HREF=ConferenceReport.asp?SortMethod=SessionTwo&Events=" & Request("Events") & "&Hold=" & Request("Hold") & "&Reserved=" & Request("Reserved") & "&Open=" & Request("Open") & "&Sold=" & Request("Sold") &  "&Available=" & Request("Available") & "&IncludeOrderNotes=" & Request("IncludeOrderNotes") & "#Anc_Sort>&nbsp;Session Two&nbsp;</A></B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B><A class=sort HREF=ConferenceReport.asp?SortMethod=SessionThree&Events=" & Request("Events") & "&Hold=" & Request("Hold") & "&Reserved=" & Request("Reserved") & "&Open=" & Request("Open") & "&Sold=" & Request("Sold") &  "&Available=" & Request("Available") & "&IncludeOrderNotes=" & Request("IncludeOrderNotes") & "#Anc_Sort>&nbsp;Session Three&nbsp;</A></B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B><A class=sort HREF=ConferenceReport.asp?SortMethod=SessionFour&Events=" & Request("Events") & "&Hold=" & Request("Hold") & "&Reserved=" & Request("Reserved") & "&Open=" & Request("Open") & "&Sold=" & Request("Sold") &  "&Available=" & Request("Available") & "&IncludeOrderNotes=" & Request("IncludeOrderNotes") & "#Anc_Sort>&nbsp;Session Four&nbsp;</A></B></FONT></TD>" 
		Else
			AttendeeHeading = ""
		End If
		
		'Lunch Column
		If Clean(Request("IncludeLunch")) = "on" Then
			LunchHeading = "<TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B><A class=sort HREF=ConferenceReport.asp?SortMethod=Lunch&Events=" & Request("Events") & "&Hold=" & Request("Hold") & "&Reserved=" & Request("Reserved") & "&Open=" & Request("Open") & "&Sold=" & Request("Sold") &  "&Available=" & Request("Available") & "&IncludeOrderNotes=" & Request("IncludeOrderNotes") & "#Anc_Sort>&nbsp;Lunch&nbsp;</A></B></FONT></TD>"
		Else
			LunchHeading = ""
		End If
		
		
		'Pitch Column
		If Clean(Request("IncludePitch")) = "on" Then
			PitchHeading = "<TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B><A class=sort HREF=ConferenceReport.asp?SortMethod=Pitch&Events=" & Request("Events") & "&Hold=" & Request("Hold") & "&Reserved=" & Request("Reserved") & "&Open=" & Request("Open") & "&Sold=" & Request("Sold") &  "&Available=" & Request("Available") & "&IncludeOrderNotes=" & Request("IncludeOrderNotes") & "#Anc_Sort>&nbsp;Agent&nbsp;</A></B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>&nbsp;Time&nbsp;</B></FONT></TD>"
		Else
			PitchHeading = ""
		End If
		
				
		Response.Write "<BR><BR>" & vbCrLf
		Response.Write "<TABLE CELLPADDING=3 BORDER=0>" & vbCrLf
		
		If Excel <> "Y" Then
			Response.Write "<TR BGCOLOR=#008400><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B><A class=sort HREF=ConferenceReport.asp?SortMethod=OrderNumber&Events=" & Request("Events") & "&Hold=" & Request("Hold") & "&Reserved=" & Request("Reserved") & "&Open=" & Request("Open") & "&Sold=" & Request("Sold") &  "&Available=" & Request("Available") & "&IncludeOrderNotes=" & Request("IncludeOrderNotes") & "#Anc_Sort>&nbsp;Order Number&nbsp;</A></B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>&nbsp;Order Date/Time&nbsp;</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B><A class=sort HREF=ConferenceReport.asp?SortMethod=CustomerName&Events=" & Request("Events") & "&Hold=" & Request("Hold") & "&Reserved=" & Request("Reserved") & "&Open=" & Request("Open") & "&Sold=" & Request("Sold") &  "&Available=" & Request("Available") & "&IncludeOrderNotes=" & Request("IncludeOrderNotes") & "#Anc_Sort>&nbsp;Bill To Name&nbsp;</A></B></FONT></TD>" & CustomerClassHeading & "<TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>&nbsp;Status&nbsp;</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>&nbsp;Ticket Type&nbsp;</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Net Price</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B><A class=sort HREF=ConferenceReport.asp?SortMethod=OrderType&Events=" & Request("Events") & "&Hold=" & Request("Hold") & "&Reserved=" & Request("Reserved") & "&Open=" & Request("Open") & "&Sold=" & Request("Sold") &  "&Available=" & Request("Available") & "&IncludeOrderNotes=" & Request("IncludeOrderNotes") & "#Anc_Sort>&nbsp;Order Type&nbsp;</A></B></FONT></TD>" & SurveyHeading & OrderNotesHeading & AttendeeHeading & LunchHeading & PitchHeading & "</TR>" & vbCrLf
			LineBreak = "<BR>"
		Else
			Response.Write "<TR BGCOLOR=#008400><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Order Number</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Order Date/Time</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Bill To Name</B></FONT></TD>" & CustomerClassHeading & "<TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Status</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Type</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Net Price</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Order Type</B></FONT></TD>" & SurveyHeading & OrderNotesHeading & AttendeeHeading & LunchHeading & PitchHeading & "</TR>" & vbCrLf
			LineBreak = ""
		End If
		
		Do Until rsSeat.EOF
		
		If AttendeeHeading <> "" Then 'Add the column
		Attendee = "<TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;" & rsSeat("AttendeeLastName") & ",&nbsp;" & rsSeat("AttendeeFirstName") & "&nbsp;</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("SessionOne") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("SessionTwo") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("SessionThree") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("SessionFour") & "</FONT></TD>" & vbCrLf
		End If

		If LunchHeading <> "" Then 'Add the column
		Lunch = "<TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("Lunch") & "</FONT></TD>" & vbCrLf
		End If	
		
		If PitchHeading <> "" Then 'Add the column
		Pitch = "<TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("PitchAgent") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("PitchSession") & "</FONT></TD>" & vbCrLf
		End If	
		
			
			If Not IsNull(rsSeat("OrderNumber")) Then
				If IsNull(rsSeat("SeatTypeCode")) Then
					SeatType = ""
					Price = 0
				Else
					SeatType = rsSeat("SeatType")
					Price = rsSeat("Price") - rsSeat("Discount")
				End If
				
				If Excel <> "Y" Then
					Response.Write "<TR BGCOLOR=#DDDDDD><TD ALIGN=right NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;<A HREF=/Reports/OrderDetails.asp?OrderNumber=" & rsSeat("OrderNumber") & ">" & rsSeat("OrderNumber") & "</A>&nbsp;</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;" & DateAndTimeFormat(rsSeat("OrderDate")) & "&nbsp;</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;<A HREF=/Reports/CustomerDetails.asp?CustomerNumber=" & rsSeat("CustomerNumber") & ">" & rsSeat("LastName") & ", " & rsSeat("FirstName") & "</A>&nbsp;</FONT></TD>" & CustomerClassDetail & "<TD ALIGN=center NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;" & rsSeat("Status") & "&nbsp;</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;" & SeatType & "&nbsp;</FONT></TD><TD ALIGN=right NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;" & FormatCurrency(Price,2)  & "&nbsp;</FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;" & rsSeat("OrderType") & "&nbsp;</FONT></TD>" & SurveyDetail & OrderNotes & Attendee & Lunch & Pitch & "</TR>" & vbCrLf
				Else
					Response.Write "<TR BGCOLOR=#DDDDDD><TD ALIGN=right NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("OrderNumber") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & DateAndTimeFormat(rsSeat("OrderDate")) & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("LastName") & ", " & rsSeat("FirstName") & "</FONT></TD>" & CustomerClassDetail & "<TD ALIGN=center NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("Status") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & SeatType & "</FONT></TD><TD ALIGN=right NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & FormatCurrency(Price,2)  & "</FONT></TD></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("OrderType") & "</FONT></TD>" & SurveyDetail & OrderNotes & Attendee & Lunch & Pitch & "</TR>" & vbCrLf
				End If
			Else
				If Excel <> "Y" Then
    				Response.Write "<TR BGCOLOR=#DDDDDD><TD ALIGN=right NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;</FONT></TD>" & CustomerClassDetail & "<TD ALIGN=center NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("Status") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;</FONT></TD><TD>&nbsp;</TD><TD>&nbsp;</TD>" & SurveyDetail & OrderNotes & Attendee & Lunch & Pitch & "</TR>" & vbCrLf
                Else
    				Response.Write "<TR BGCOLOR=#DDDDDD><TD ALIGN=right NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2></FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2></FONT></TD>" & CustomerClassDetail & "<TD ALIGN=center NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2></FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("Status") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2></FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2></FONT></TD><TD></TD><TD></TD>" & SurveyDetail & OrderNotes & Attendee & Lunch & Pitch & "</TR>" & vbCrLf
    		    End If
			End If
			rsSeat.MoveNext
		Loop
		
		Call DBClose(OBJdbConnection2)

		Response.Write "</TABLE>" & vbCrLf
	Else
		Response.Write "No Seats Found.<BR>" & vbCrLf
	End If
	rsSeat.Close
	Set rsSeat = nothing

End If

%>

</FONT>
</CENTER>

<%
If Excel <> "Y" Then
%>
	<!--#include virtual="/FooterInclude.asp"-->
<%
End If
%>

</BODY>
</HTML>
