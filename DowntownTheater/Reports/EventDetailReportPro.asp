<%
'CHANGE LOG
'JAI 4/27/11 - Adjusted CustomerClass JOIN to not display duplicate entries if a customer has classes associated with other organizations
'TTT - 5/23/11 - Specified name of Excel download file
'TTT 6/27/2011 - Added sorting sequence for survey's answers
'TTT - 9/22/11 - Added Tix2 Sync. for Session Variables
%>

<!--#include virtual="GlobalInclude.asp"-->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="/include/managementinclude.asp"-->
<%
Page = "EventDetailReport"
SecurityFunction = "EventDetailReport"
ReportFileName = "EventDetailReportPro.asp"
ExcelOutputFileName = "EventDetailReport.xls"
ReportTitle = "Event Detail Report"

'REE 4/12/6 - Added Script Timeout
Server.ScriptTimeout = 1200

If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then Response.Redirect("/Management/Default.asp")

If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then Response.Redirect("/Management/Default.asp")

If SecurityCheck(SecurityFunction) = False Then Response.Redirect("/Management/Default.asp")

If Request("btnSubmit") = "Submit" Then
    Call ReportOutput
Else
    Call ReportCriteria
End If 

Sub ReportCriteria

%>
<HTML>
<HEAD>
<TITLE>Tix - Event Detail Report</TITLE>

<style type="text/css">
<!--
a.sort:link  {color: #FFFFFF; font-weight: bold; text-decoration: underline;}
a.sort:visited  {color: #FFFFFF; font-weight: bold; text-decoration: underline;}
a.sort:active  {color: #FFFFFF; font-weight: bold; text-decoration: underline;}
a.sort:hover  {color: #FFFFFF; font-weight: bold; text-decoration: underline;}
-->
</style>
    <link href="/CSS/Report.css" rel="stylesheet" type="text/css" />
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

<FONT FACE=verdana,arial,helvetica COLOR=#008400><H3>Event Detail Report</H3></FONT>

<%
If Excel <> "Y" Then
%>

	<FONT FACE=verdana,arial,helvetica SIZE=2>
	<FORM ACTION="EventDetailReportPro.asp" METHOD="post" id=form1 name=Report onSubmit="return ValidateForm()">
	
<%
EventListDaysDefault = 30
%>
<fieldset style="width: 600px;" class="reportCriteriaField">
    <legend class="reportCriteriaFieldTitle">Event Selection</legend>

    <!--#INCLUDE VIRTUAL="/Include/EventListDayInclude.asp" -->

    <!--#INCLUDE VIRTUAL="/Include/EventSelectionInclude.asp" -->
</fieldset><br /><br />	
<%

	'REE 6/12/4 - Default checks based on previous submit.
	If Request("Available") = "on" Then AvailableChecked = " CHECKED"
	If Request("Hold") = "on" Then HoldChecked = " CHECKED"
	If Request("Reserved") = "on" Then ReservedChecked = " CHECKED"
	If Request("Open") = "on" Then OpenChecked = " CHECKED"
	If Request("Sold") = "on" Or Request("EventCode") = "" Then SoldChecked = " CHECKED"

	Response.Write "<B>Include:</B> <INPUT TYPE=checkbox NAME=Available" & AvailableChecked & ">Available" & vbCrLf
	'REE 3/8/2 - Added ability to select Hold seats
	Response.Write "<INPUT TYPE=checkbox NAME=Hold" &  HoldChecked & ">Hold" & vbCrLf
	Response.Write "<INPUT TYPE=checkbox NAME=Reserved" & ReservedChecked & ">Reserved" & vbCrLf
	'REE 6/27/8 - Removed Open Status Option.  Seat status is never "Open".  Report is not checking OrderHeader status.
'	Response.Write "<INPUT TYPE=checkbox NAME=Open" & OpenChecked & ">Open" & vbCrLf
	Response.Write "<INPUT TYPE=checkbox NAME=Sold" & SoldChecked & ">Sold<BR><BR>" & vbCrLf

	Response.Write "<TABLE ALIGN=CENTER CELLPADDING=0 CELLSPACING=1><TR>" & vbCrLf
	'REE 8/25/5 - Added option to include survey results
	'If any of the events in the drop down list above have a survey associated with them, display the survey option.
	'REE 4/6/2 - Modified to include OrganizationAct selection criteria
	SQLEvents = "SELECT Event.EventCode, Act, EventDate, Event.SurveyNumber FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE EventDate > GETDATE()-" & EventListDays & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " ORDER BY EventDate"
	Set rsEvents = OBJdbConnection.Execute(SQLEvents)
	Do Until rsEvents.EOF
		If Not IsNull(rsEvents("SurveyNumber")) Then 'There's a survey.  Display the survey option.
			SurveyExists = "Y"
		End If
		rsEvents.MoveNext
	Loop
	rsEvents.Close
	Set rsEvents = Nothing
	
	If SurveyExists = "Y" Then
		If Request("IncludeSurvey") = "on" Then SurveyChecked = " CHECKED"
		Response.Write "<TD><INPUT TYPE=""checkbox"" NAME=""IncludeSurvey""" & SurveyChecked & "></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2>Include Survey Results</FONT></TD></TR><TR>" & vbCrLf
	End If

	'JAI 5/17/6 - Added option to include order notes
	If Request("IncludeOrderNotes") = "on" Then OrderNotesChecked = " CHECKED"
	Response.Write "<TD><INPUT TYPE=""checkbox"" NAME=""IncludeOrderNotes""" & OrderNotesChecked & "></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2>Include Order Notes</FONT></TD></TR><TR>" & vbCrLf

	'REE 5/5/5 - Added ability to output to Excel
	Response.Write "<TD><INPUT TYPE=""checkbox"" NAME=""ExcelOutput"" VALUE=""Y""></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2>Output To Excel</FONT></TD>" & vbCrLf
	Response.Write "</TR></TABLE><BR>" & vbCrLf

	Response.Write "<INPUT TYPE=submit name=btnSubmit VALUE=Submit></FORM>" & vbCrLf

End If

%>

<script LANGUAGE="JavaScript">    

<!-- Hide code from non-js browsers

function ValidateForm(){
formObj = document.Report;
<%= jsValidateForm %>
if ((!formObj.Available.checked) && (!formObj.Hold.checked) && (!formObj.Reserved.checked) && (!formObj.Sold.checked)) {
	alert("You must select at least one status to include.");
	formObj.Available.focus();
    return false;
    }
}
// end hiding -->
</script>

<!--#include virtual="FooterInclude.asp"-->

</body>
</html>
<%

End Sub

Sub ReportOutput

Response.Buffer = False
Excel = Clean(Request("ExcelOutput"))

If Excel = "Y" Then

	Response.ContentType = "application/vnd.ms-excel"
	Response.AddHeader "Content-Disposition", "attachment; filename=" & ExcelOutputFileName

End If

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & ReportTitle & "</TITLE>" & vbCrLf

If Excel <> "Y" Then

    Response.Write "<LINK REL=""stylesheet"" TYPE=""text/css"" HREF=""/CSS/Report.css"">" & vbCrLf
    
End If

Response.Write "</HEAD>" & vbCrLf
Response.Write "<BODY>" & vbCrLf

If Excel <> "Y" Then
%>
<!--#INCLUDE VIRTUAL="TopNavInclude.asp" -->
<%
End If

Response.Write "<H3>" & ReportTitle & "</H3>" & vbCrLf

EventCodes = Clean(Replace(Request("EventCode")," ",""))
EventCodeList = Split(EventCodes,",")

For i = LBound(EventCodeList) To UBound(EventCodeList)
	'REE 3/8/2 - Added ability to select Hold seats
	'JAI 5/3/3 - Cleaned up SQL Statement
	'REE 1/10/4 - Changed Customer Name to ShipTo Name.  Removed Join to Customer.
	'REE 2/17/5 - Added Customer Class
	'REE 5/27/8 - Added OrganizationAct & OrganizationVenue to insure events belong to Session Org.
	'REE 5/27/8 - Added criteria to make sure CustomerClass belongs to the Session Org.
	'JAI 4/27/11 - Adjusted CustomerClass JOIN to not display duplicate entries if a customer has classes associated with other organizations
	SQLSeat = "SELECT Seat.EventCode, OrderLine.OrderNumber, Seat.ItemNumber, Section, Row, Seat, SeatStatus.Status, Seat.HoldType, PrintDate, OrderType, OrderLine.SeatTypeCode, SeatType, Price, OrderLine.Discount, OrderDate, OrderHeader.CustomerNumber, ShipFirstName AS FirstName, ShipLastName AS LastName, OrganizationCustomerClass.Class FROM Seat (NOLOCK) INNER JOIN Section (NOLOCK) ON Seat.SectionCode = Section.SectionCode AND Seat.EventCode = Section.EventCode INNER JOIN SeatStatus (NOLOCK) ON Seat.StatusCode = SeatStatus.StatusCode LEFT JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent', 'SubSeat') INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode AND OrganizationVenue.OrganizationNumber = OrganizationAct.OrganizationNumber LEFT JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber LEFT JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode LEFT JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber LEFT JOIN (SELECT CustomerClass.CustomerNumber, OrganizationCustomerClass.OrganizationNumber, OrganizationCustomerClass.ClassNumber, OrganizationCustomerClass.Class FROM CustomerClass (NOLOCK) INNER JOIN OrganizationCustomerClass (NOLOCK) ON CustomerClass.ClassNumber = OrganizationCustomerClass.ClassNumber ) AS OrganizationCustomerClass ON OrderHeader.CustomerNumber = OrganizationCustomerClass.CustomerNumber AND OrganizationVenue.OrganizationNumber = OrganizationCustomerClass.OrganizationNumber WHERE Seat.EventCode = " & CleanNumeric(EventCodeList(i)) & " AND OrganizationVenue.OrganizationNumber = " &  Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber")
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
			SQLSeat = SQLSeat & " ORDER BY OrderLine.OrderNumber, Seat.SectionCode, RowSort, SeatSort DESC"
		Case "CustomerName"
			SQLSeat = SQLSeat & " ORDER BY LastName, FirstName, OrderLine.OrderNumber"
		Case "CustomerClass"
			SQLSeat = SQLSeat & " ORDER BY Class DESC, LastName, FirstName, OrderLine.OrderNumber"
		Case "OrderType"
			SQLSeat = SQLSeat & " ORDER BY OrderType, OrderLine.OrderNumber"
		Case Else
			SQLSeat = SQLSeat & " ORDER BY Seat.SectionCode, Seat.RowSort, Seat.SeatSort DESC"
	End Select
	Set rsSeat = OBJdbConnection.Execute(SQLSeat)
	
	If Not rsSeat.EOF Then
		'REE 2/17/5 - Added Event Owner Organization 
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
		
		'REE 2/17/5 - Added Customer Class Column When Applicable
		SQLCustomerClass = "SELECT OrganizationNumber FROM OrganizationCustomerClass (NOLOCK) WHERE OrganizationNumber = " & EventOrganizationNumber
		Set rsCustomerClass = OBJdbConnection2.Execute(SQLCustomerClass)
		
		CustomerClassHeading = ""
		
		If Not rsCustomerClass.EOF Then 'Add Column for Customer Class
			If Excel <> "Y" Then
				CustomerClassHeading = "<TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B><A class=sort HREF=EventDetailReportPro.asp?btnSubmit=Submit&SortMethod=CustomerClass&EventCode=" & EventCodes & "&Hold=" & Request("Hold") & "&Reserved=" & Request("Reserved") & "&Open=" & Request("Open") & "&Sold=" & Request("Sold") & "&Available=" & Request("Available") & "&IncludeOrderNotes=" & Request("IncludeOrderNotes") & "&IncludeSurvey=" & Request("IncludeSurvey") & "#Anc_Sort>&nbsp;Customer Class&nbsp;</A></B></FONT></TD>"
			Else
				CustomerClassHeading = "<TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Customer Class</A></B></FONT></TD>"
			End If
			
		End If
		
		rsCustomerClass.Close
		Set rsCustomerClass = nothing
		
		'REE 8/25/5 - Added Survey Column
		If Clean(Request("IncludeSurvey")) = "on" Then
			SurveyHeading = "<TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Survey</B></FONT></TD>"
		Else
			SurveyHeading = ""
		End If
		
		'JAI 5/17/6 - Added Order Notes Column
		If Clean(Request("IncludeOrderNotes")) = "on" Then
			OrderNotesHeading = "<TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Order Notes</B></FONT></TD>"
		Else
			OrderNotesHeading = ""
		End If
		
		Response.Write "<TABLE CELLPADDING=3 BORDER=0>" & vbCrLf
		
		If Excel <> "Y" Then
			'REE 2/17/5 - Added Customer Class Heading
			'REE 12/12/7 - Modified to remove "<BR>" line break from Order Notes when outputting to Excel.  It was causing the Order Notes to sppear in multiple rows.
			Response.Write "<TR BGCOLOR=#008400><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B><A class=sort HREF=EventDetailReportPro.asp?btnSubmit=Submit&SortMethod=Section&EventCode=" & EventCodes & "&Hold=" & Request("Hold") & "&Reserved=" & Request("Reserved") & "&Open=" & Request("Open") &  "&Sold=" & Request("Sold") &  "&Available=" & Request("Available") & "&IncludeOrderNotes=" & Request("IncludeOrderNotes") & "&IncludeSurvey=" & Request("IncludeSurvey") & "#Anc_Sort>&nbsp;Section&nbsp;</A></B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>&nbsp;Row&nbsp;</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>&nbsp;Seat&nbsp;</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B><A class=sort HREF=EventDetailReportPro.asp?btnSubmit=Submit&SortMethod=OrderNumber&EventCode=" & EventCodes & "&Hold=" & Request("Hold") & "&Reserved=" & Request("Reserved") & "&Open=" & Request("Open") & "&Sold=" & Request("Sold") &  "&Available=" & Request("Available") & "&IncludeOrderNotes=" & Request("IncludeOrderNotes") & "&IncludeSurvey=" & Request("IncludeSurvey") & "#Anc_Sort>&nbsp;Order Number&nbsp;</A></B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>&nbsp;Order Date/Time&nbsp;</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B><A class=sort HREF=EventDetailReportPro.asp?btnSubmit=Submit&SortMethod=CustomerName&EventCode=" & EventCodes & "&Hold=" & Request("Hold") & "&Reserved=" & Request("Reserved") & "&Open=" & Request("Open") & "&Sold=" & Request("Sold") &  "&Available=" & Request("Available") & "&IncludeOrderNotes=" & Request("IncludeOrderNotes") & "&IncludeSurvey=" & Request("IncludeSurvey") & "#Anc_Sort>&nbsp;Customer Name&nbsp;</A></B></FONT></TD>" & CustomerClassHeading & "<TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>&nbsp;Status&nbsp;</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>&nbsp;Type&nbsp;</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>&nbsp;Net Price&nbsp;</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>&nbsp;Date Printed&nbsp;</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B><A class=sort HREF=EventDetailReportPro.asp?btnSubmit=Submit&SortMethod=OrderType&EventCode=" & EventCodes & "&Hold=" & Request("Hold") & "&Reserved=" & Request("Reserved") & "&Open=" & Request("Open") & "&Sold=" & Request("Sold") &  "&Available=" & Request("Available") & "&IncludeOrderNotes=" & Request("IncludeOrderNotes") & "&IncludeSurvey=" & Request("IncludeSurvey") & "#Anc_Sort>&nbsp;Order Type&nbsp;</A></B></FONT></TD>" & SurveyHeading & OrderNotesHeading & "</TR>" & vbCrLf
			LineBreak = "<BR>"
		Else
			Response.Write "<TR BGCOLOR=#008400><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Section</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Row</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Seat</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Order Number</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Order Date/Time</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Customer Name</B></FONT></TD>" & CustomerClassHeading & "<TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Status</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Type</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Net Price</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Date Printed</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Order Type</B></FONT></TD>" & SurveyHeading & OrderNotesHeading & "</TR>" & vbCrLf
			LineBreak = ""
		End If
		
		Do Until rsSeat.EOF

			'REE 2/17/5 - Added Customer Class Detail
			CustomerClassDetail = ""
			If CustomerClassHeading <> "" Then 'Add the column
				CustomerClassDetail = "<TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;" & rsSeat("Class") & "&nbsp;</FONT></TD>"
			End If
			
			'REE 8/25/5 - Added Survey Information
			If SurveyHeading <> "" Then 'Add the column
				SurveyDetail = "<TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & vbCrLf
				
				If rsSeat("OrderNumber") <> "" Then 
				    SQLSurveyAnswers = "SELECT Question, Answer FROM SurveyAnswers (NOLOCK) LEFT JOIN SurveyQuestion (NOLOCK) ON SurveyAnswers.SurveyNumber = SurveyQuestion.SurveyNumber AND SurveyAnswers.AnswerNumber = SurveyQuestion.QuestionNumber WHERE OrderNumber = " & rsSeat("OrderNumber") & " ORDER BY IsNull(SortOrder,1), AnswerNumber, SurveyDate"
				    Set rsSurveyAnswers = OBJdbConnection2.Execute(SQLSurveyAnswers)
				    Do Until rsSurveyAnswers.EOF
					    SurveyDetail = SurveyDetail & rsSurveyAnswers("Question") & ": " & rsSurveyAnswers("Answer") & "<BR>" & vbCrLf
					    rsSurveyAnswers.MoveNext
				    Loop
				    rsSurveyAnswers.Close
				    Set rsSurveyAnswers = nothing
               End If
				
				SurveyDetail = SurveyDetail & "</FONT></TD>" & vbCrLf
			End If
			
			'JAI 5/17/6 - Added Order Notes
			If OrderNotesHeading <> "" Then 'Add the column
				OrderNotes = "<TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 REE>" & vbCrLf
				
				'REE 6/23/6 - Added check for Null OrderNumber
				If Not IsNull(rsSeat("OrderNumber")) Then
					SQLOrderNotes = "SELECT ModifyDate, FirstName, LastName, OrderNotes FROM OrderNotes(NOLOCK) INNER JOIN Users(NOLOCK) ON OrderNotes.ModifyUser = Users.UserNumber WHERE OrderNumber = " & rsSeat("OrderNumber") & " ORDER BY ModifyDate"
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
			
			If Not IsNull(rsSeat("OrderNumber")) Then
				If IsNull(rsSeat("SeatTypeCode")) Then
					SeatType = ""
					Price = 0
				Else
					SeatType = rsSeat("SeatType")
					Price = rsSeat("Price") - rsSeat("Discount")
				End If
				
				If Excel <> "Y" Then
					Response.Write "<TR BGCOLOR=#DDDDDD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;" & rsSeat("Section") & "&nbsp;</FONT></TD><TD ALIGN=right NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;" & rsSeat("Row") & "&nbsp;</FONT></TD><TD ALIGN=right NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;" & rsSeat("Seat") & "&nbsp;</FONT></TD><TD ALIGN=right NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;<A HREF=OrderDetails.asp?OrderNumber=" & rsSeat("OrderNumber") & ">" & rsSeat("OrderNumber") & "</A>&nbsp;</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;" & DateAndTimeFormat(rsSeat("OrderDate")) & "&nbsp;</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;<A HREF=CustomerDetails.asp?CustomerNumber=" & rsSeat("CustomerNumber") & ">" & rsSeat("LastName") & ", " & rsSeat("FirstName") & "</A>&nbsp;</FONT></TD>" & CustomerClassDetail & "<TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;" & rsSeat("Status") & "&nbsp;</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;" & SeatType & "&nbsp;</FONT></TD><TD ALIGN=right NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;" & FormatCurrency(Price,2)  & "&nbsp;</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;" & DateFormat(rsSeat("PrintDate"))  & "&nbsp;</FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;" & rsSeat("OrderType") & "&nbsp;</FONT></TD>" & SurveyDetail & OrderNotes & "</TR>" & vbCrLf
				Else
					Response.Write "<TR BGCOLOR=#DDDDDD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("Section") & "</FONT></TD><TD ALIGN=right NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("Row") & "</FONT></TD><TD ALIGN=right NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("Seat") & "</FONT></TD><TD ALIGN=right NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("OrderNumber") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & DateAndTimeFormat(rsSeat("OrderDate")) & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("LastName") & ", " & rsSeat("FirstName") & "</FONT></TD>" & CustomerClassDetail & "<TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("Status") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & SeatType & "</FONT></TD><TD ALIGN=right NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & FormatCurrency(Price,2)  & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & DateFormat(rsSeat("PrintDate"))  & "</FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("OrderType") & "</FONT></TD>" & SurveyDetail & OrderNotes & "</TR>" & vbCrLf
				End If
			Else
				If Excel <> "Y" Then
    				Response.Write "<TR BGCOLOR=#DDDDDD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;" & rsSeat("Section") & "&nbsp;</FONT></TD><TD ALIGN=right NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;" & rsSeat("Row") & "&nbsp;</FONT></TD><TD ALIGN=right NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;" & rsSeat("Seat") & "&nbsp;</FONT></TD><TD ALIGN=right NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;</FONT></TD>" & CustomerClassDetail & "<TD ALIGN=center NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("Status") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;</FONT></TD><TD>&nbsp;</TD><TD>&nbsp;</TD>" & SurveyDetail & OrderNotes & "</TR>" & vbCrLf
                Else
    				Response.Write "<TR BGCOLOR=#DDDDDD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("Section") & "</FONT></TD><TD ALIGN=right NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("Row") & "</FONT></TD><TD ALIGN=right NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("Seat") & "</FONT></TD><TD ALIGN=right NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2></FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2></FONT></TD>" & CustomerClassDetail & "<TD ALIGN=center NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2></FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("Status") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2></FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2></FONT></TD><TD></TD><TD></TD>" & SurveyDetail & OrderNotes & "</TR>" & vbCrLf
    		    End If
			End If
			rsSeat.MoveNext
		Loop
		
		Call DBClose(OBJdbConnection2)

		Response.Write "</TABLE><BR><BR>" & vbCrLf
	'Else
		'Response.Write "No Seats Found.<BR>" & vbCrLf
	End If
	rsSeat.Close
	Set rsSeat = nothing
Next

%>

</FONT>
</CENTER>

<%
If Excel <> "Y" Then
%>
	<!--#include virtual="FooterInclude.asp"-->
<%
End If
%>

</BODY>
</HTML>

<%
End Sub
%>
