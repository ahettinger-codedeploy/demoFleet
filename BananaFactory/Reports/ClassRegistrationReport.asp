<!--#include virtual="GlobalInclude.asp"-->
<!--#include virtual="dbOpenInclude.asp"-->
<%
Page = "EventDetailReport"
EventSelection = True
ReportTitle = "Class Registration Report"

'Check Needed Session Variables
If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Or Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then 
	Response.Redirect("/Management/Default.asp")
End If

'Security Check
If SecurityCheck(ReportName) <> TRUE Then 'Prevent Access
'	Response.Redirect("/Management/Default.asp")
Else 'Log usage
	SecurityLog(ReportName)
End If

If Request("FormName") = "ReportSelection" Then
	Call DisplayReport
Else
	Call DisplayForm(Message)
End If

Sub DisplayForm(Message)

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>www.TIX.com - " & ReportTitle & "</TITLE>" & vbCrLf

Response.Write "<SCRIPT LANGUAGE=""JavaScript"">" & vbCrLf
Response.Write "<!-- Hide code from non-js browsers" & vbCrLf

Response.Write "function validateForm(){" & vbCrLf
Response.Write "formObj = document.Report;" & vbCrLf

If DateRangeSelection = True Then
	Response.Write "if(dateRangeCheck(formObj) == false){" & vbCrLf
	Response.Write "return false;" & vbCrLf
	Response.Write "}" & vbCrLf
End If

If EventSelection = True Then
	Response.Write "if(eventSelectedCheck(formObj) == false){" & vbCrLf
	Response.Write "return false;" & vbCrLf
	Response.Write "}" & vbCrLf
End If

Response.Write "if ((!formObj.Available.checked) && (!formObj.Hold.checked) && (!formObj.Reserved.checked) && (!formObj.Open.checked)&& (!formObj.Sold.checked)) {" & vbCrLf
Response.Write "alert(""You must select at least one status to include."");" & vbCrLf
Response.Write "formObj.Available.focus();" & vbCrLf
Response.Write "return false;" & vbCrLf
Response.Write "}" & vbCrLf

Response.Write "}" & vbCrLf

Response.Write "// end hiding -->" & vbCrLf
Response.Write "</SCRIPT>" & vbCrLf

Response.Write "<LINK REL=""stylesheet"" TYPE=""text/css"" HREF=""/Reports/Report.css"">" & vbCrLf

Response.Write "</HEAD>" & vbCrLf
If Message = "" Then
	Response.Write "<BODY>" & vbCrLf
Else
	Response.Write "<BODY onLoad=""alert('" & Message & "')"">" & vbCrLf
End If
Response.Write "<CENTER>" & vbCrLf

If Excel <> "Y" Then
%>
	<!--#include virtual="TopNavInclude.asp" -->
<%
End If
%>

<BR>

<BR>

<FONT FACE=verdana,arial,helvetica COLOR=#008400><H3>Class Registration Report</H3></FONT>

<FONT FACE=verdana,arial,helvetica SIZE=2>
<FORM ACTION="ClassRegistrationReport.asp" METHOD="post" id=form1 name=Report onSubmit="return validateForm()">
<INPUT TYPE="hidden" NAME="FormName" VALUE="ReportSelection">
	
<%	
If EventSelection = True Then
%>
	<!--#INCLUDE VIRTUAL="/Reports/EventSelectionInclude.asp"-->
<%
	Response.Write "<BR>" & vbCrLf
End If

'REE 6/12/4 - Default checks based on previous submit.
If Request("Available") = "on" Then AvailableChecked = " CHECKED"
If Request("Hold") = "on" Then HoldChecked = " CHECKED"
If Request("Reserved") = "on" Then ReservedChecked = " CHECKED"
If Request("Open") = "on" Then OpenChecked = " CHECKED"
If Request("Sold") = "on" Or Request("Events") = "" Then SoldChecked = " CHECKED"

Response.Write "<B>Include:</B> <INPUT TYPE=checkbox NAME=Available" & AvailableChecked & ">Available" & vbCrLf
'REE 3/8/2 - Added ability to select Hold seats
Response.Write "<INPUT TYPE=checkbox NAME=Hold" &  HoldChecked & ">Hold" & vbCrLf
Response.Write "<INPUT TYPE=checkbox NAME=Reserved" & ReservedChecked & ">Reserved" & vbCrLf
Response.Write "<INPUT TYPE=checkbox NAME=Open" & OpenChecked & ">Open" & vbCrLf
Response.Write "<INPUT TYPE=checkbox NAME=Sold" & SoldChecked & ">Sold<BR><BR>" & vbCrLf

Response.Write "<TABLE ALIGN=CENTER CELLPADDING=0 CELLSPACING=1><TR>" & vbCrLf
'REE 8/25/5 - Added option to include survey results
'If any of the events in the drop down list above have a survey associated with them, display the survey option.
'	If SurveyExists = "Y" Then
'		If Request("IncludeSurvey") = "on" Then SurveyChecked = " CHECKED"
'		Response.Write "<TD><INPUT TYPE=""checkbox"" NAME=""IncludeSurvey""" & SurveyChecked & "></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2>Include Survey Results</FONT></TD></TR><TR>" & vbCrLf
'	End If

'JAI 5/17/6 - Added option to include order notes
If Request("IncludeOrderNotes") = "on" Then OrderNotesChecked = " CHECKED"
Response.Write "<TD><INPUT TYPE=""checkbox"" NAME=""IncludeOrderNotes""" & OrderNotesChecked & "></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2>Include Order Notes</FONT></TD></TR><TR>" & vbCrLf

'REE 5/5/5 - Added ability to output to Excel
Response.Write "<TD><INPUT TYPE=""checkbox"" NAME=""ExcelOutput"" VALUE=""Y""></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2>Output To Excel</FONT></TD>" & vbCrLf
Response.Write "</TR></TABLE><BR>" & vbCrLf

Response.Write "<INPUT TYPE=submit VALUE=Enter></FORM><BR><BR>" & vbCrLf

End Sub

'==========================

Sub DisplayReport

If DateRangeSelection = True Then

	'Validate Start Date
	If Not IsDate(Request("ReportStartMonth") & "/" & Request("ReportStartDay") & "/" & Request("ReportStartYear")) Then
		Call DisplayForm("Invalid Start Date")
		Exit Sub
	End If

	'Validate End Date
	If Not IsDate(Request("ReportEndMonth") & "/" & Request("ReportEndDay") & "/" & Request("ReportEndYear")) Then
		Call DisplayForm("Invalid End Date")
		Exit Sub
	End If

	ReportStartDate = CDate(Request("ReportStartMonth") & "/" & Request("ReportStartDay") & "/" & Request("ReportStartYear"))
	ReportEndDate = CDate(Request("ReportEndMonth") & "/" & Request("ReportEndDay") & "/" & Request("ReportEndYear"))

	'Validate Date Range
	If ReportStartDate > ReportEndDate Then
		Call DisplayForm("Start Date must not be after End Date")
		Exit Sub
	End If		
	
End If

If EventSelection = True Then

	If Request("EventCode") = "" And Request("EventList") = "" Then 'If there are no events selected, go back to form page with error message.
		Call DisplayForm("Please select at least one Event.")
		Exit Sub
	End If
	
	If Request("EventCode") <> "" Then
		For Each EventCode In Request("EventCode")
			EventList = EventList & CleanNumeric(EventCode) & ","
		Next
		'Trim last comma
		EventList = Left(EventList, Len(EventList) - 1)
	Else
		EventList = Clean(Request("EventList"))
	End If
	
End If

'REE 5/28/5 - Added ability to output to Excel
Excel = Clean(Request("ExcelOutput"))
If Excel = "Y" Then
	Response.ContentType = "application/vnd.ms-excel"
End If

If DateRangeSelection = True Then
	ReportStartDate = CDate(Request("ReportStartMonth") & "/" & Request("ReportStartDay") & "/" & Request("ReportStartYear"))
	ReportEndDate = CDate(Request("ReportEndMonth") & "/" & Request("ReportEndDay") & "/" & Request("ReportEndYear"))
End If

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & ReportTitle & "</TITLE>" & vbCrLf
If Excel <> "Y" Then
	Response.Write "<LINK REL=""stylesheet"" TYPE=""text/css"" HREF=""/Reports/Report.css"">" & vbCrLf
End If
Response.Write "</HEAD>" & vbCrLf
Response.Write "<BODY>" & vbCrLf

If Excel <> "Y" Then
	Response.Write "<CENTER>" & vbCrLf
%>
<!--#INCLUDE VIRTUAL="TopNavInclude.asp" -->
<%
End If

Response.Write "<H3>" & ReportTitle & "</H3>" & vbCrLf

If DateRangeSelection = True Then
	Response.Write "<B>Sales From " & ReportStartDate & " through " & ReportEndDate & "</B><BR><BR>" & vbCrLf
End If

'REE 3/8/2 - Added ability to select Hold seats
'JAI 5/3/3 - Cleaned up SQL Statement
'REE 1/10/4 - Changed Customer Name to ShipTo Name.  Removed Join to Customer.
'REE 2/17/5 - Added Customer Class
'REE 5/24/7 - Added Customer E-Mail Address
SQLSeat = "SELECT Seat.EventCode, OrderLine.OrderNumber, OrderLine.LineNumber, Seat.ItemNumber, SeatStatus.Status, OrderLine.SeatTypeCode, SeatType, OrderDate, OrderHeader.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.DayPhone, Customer.EMailAddress, OrganizationCustomerClass.Class, FirstName.FieldValue AS StudentFirstName, LastName.FieldValue AS StudentLastName FROM Seat (NOLOCK) INNER JOIN SeatStatus (NOLOCK) ON Seat.StatusCode = SeatStatus.StatusCode LEFT JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent', 'SubSeat') LEFT JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber LEFT JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode LEFT JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber LEFT JOIN CustomerClass (NOLOCK) ON OrderHeader.CustomerNumber = CustomerClass.CustomerNumber LEFT JOIN OrganizationCustomerClass (NOLOCK) ON CustomerClass.ClassNumber = OrganizationCustomerClass.ClassNumber LEFT JOIN Customer WITH (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber LEFT JOIN (SELECT OrderLineDetail.OrderNumber, OrderLineDetail.LineNumber, OrderLineDetail.FieldValue FROM OrderLineDetail WITH (NOLOCK) WHERE OrderLineDetail.FieldName = 'FirstName') AS FirstName ON OrderLine.OrderNumber = FirstName.OrderNumber AND OrderLine.LineNumber = FirstName.LineNumber LEFT JOIN (SELECT OrderLineDetail.OrderNumber, OrderLineDetail.LineNumber, OrderLineDetail.FieldValue FROM OrderLineDetail WITH (NOLOCK) WHERE OrderLineDetail.FieldName = 'LastName') AS LastName ON OrderLine.OrderNumber = LastName.OrderNumber AND OrderLine.LineNumber = LastName.LineNumber WHERE Seat.EventCode IN (" & EventList & ")"

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
		SQLSeat = SQLSeat & " ORDER BY LastName.FieldValue, FirstName.FieldValue, Seat.SectionCode, Seat.RowSort, Seat.SeatSort DESC"
End Select

Set rsSeat = OBJdbConnection.Execute(SQLSeat)
	
Call DBOpen(OBJdbConnection2)

If Not rsSeat.EOF Then
	'REE 2/17/5 - Added Event Owner Organization 
	SQLEvent = "SELECT Act, Venue, EventDate, OrganizationVenue.OrganizationNumber FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) on Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) on Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = Act.ActCode AND OrganizationVenue.OrganizationNumber = OrganizationAct.OrganizationNumber WHERE Event.EventCode = " & rsSeat("EventCode") & " AND OrganizationVenue.Owner <> 0"
	Set rsEvent = OBJdbConnection2.Execute(SQLEvent)
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
		
	'REE 2/17/5 - Added Customer Class Column When Applicable
	SQLCustomerClass = "SELECT OrganizationNumber FROM OrganizationCustomerClass (NOLOCK) WHERE OrganizationNumber = " & EventOrganizationNumber
	Set rsCustomerClass = OBJdbConnection2.Execute(SQLCustomerClass)
		
	CustomerClassHeading = ""
		
	If Not rsCustomerClass.EOF Then 'Add Column for Customer Class
		If Excel <> "Y" Then
			'REE 5/24/7 - Added Customer E-Mail Address
			CustomerClassHeading = "<TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B><A class=sort HREF=ClassRegistrationReport.asp?SortMethod=CustomerClass&EventList=" & EventList & "&Hold=" & Request("Hold") & "&Reserved=" & Request("Reserved") & "&Open=" & Request("Open") & "&Sold=" & Request("Sold") & "&Available=" & Request("Available") & "&IncludeOrderNotes=" & Request("IncludeOrderNotes") & "&FormName=ReportSelection#Anc_Sort>&nbsp;Customer Class&nbsp;</A></B></FONT></TD>"
		Else
			'REE 5/24/7 - Added Customer E-Mail Address
			CustomerClassHeading = "<TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Customer Class</A></B></FONT></TD>"
		End If
			
	End If
		
	rsCustomerClass.Close
	Set rsCustomerClass = nothing
		
	'REE 8/25/5 - Added Survey Column
'		If Clean(Request("IncludeSurvey")) = "on" Then
'			SurveyHeading = "<TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Survey</B></FONT></TD>"
'		Else
'			SurveyHeading = ""
'		End If
		
	'JAI 5/17/6 - Added Order Notes Column
	If Clean(Request("IncludeOrderNotes")) = "on" Then
		OrderNotesHeading = "<TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Order Notes</B></FONT></TD>"
	Else
		OrderNotesHeading = ""
	End If
		
	Response.Write "<BR><BR>" & vbCrLf
	Response.Write "<TABLE CELLPADDING=3 BORDER=0>" & vbCrLf
		
	If Excel <> "Y" Then
		'REE 2/17/5 - Added Customer Class Heading
		Response.Write "<TR BGCOLOR=#008400><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B><A class=sort HREF=ClassRegistrationReport.asp?SortMethod=OrderNumber&EventList=" & EventList & "&Hold=" & Request("Hold") & "&Reserved=" & Request("Reserved") & "&Open=" & Request("Open") & "&Sold=" & Request("Sold") &  "&Available=" & Request("Available") & "&IncludeOrderNotes=" & Request("IncludeOrderNotes") & "&FormName=ReportSelection#Anc_Sort>&nbsp;Order Number&nbsp;</A></B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>&nbsp;Order Date/Time&nbsp;</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Student Name</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B><A class=sort HREF=ClassRegistrationReport.asp?SortMethod=CustomerName&EventList=" & EventList & "&Hold=" & Request("Hold") & "&Reserved=" & Request("Reserved") & "&Open=" & Request("Open") & "&Sold=" & Request("Sold") &  "&Available=" & Request("Available") & "&IncludeOrderNotes=" & Request("IncludeOrderNotes") & "&FormName=ReportSelection#Anc_Sort>&nbsp;Billing Name&nbsp;</A></B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Address 1</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Address 2</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>City</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>State</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Postal Code</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Daytime Phone</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>E-Mail Address</B></FONT></TD>" & CustomerClassHeading & "<TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>&nbsp;Status&nbsp;</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>&nbsp;Type&nbsp;</B></FONT></TD>" & OrderNotesHeading & "</TR>" & vbCrLf
	Else
		Response.Write "<TR BGCOLOR=#008400><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Order Number</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Order Date/Time</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Student Name</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Billing Name</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Address 1</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Address 2</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>City</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>State</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Postal Code</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Daytime Phone</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>E-Mail Addres</B></FONT></TD>" & CustomerClassHeading & "<TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Status</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Type</B></FONT></TD>" & OrderNotesHeading & "</TR>" & vbCrLf
	End If

	Do Until rsSeat.EOF

		'REE 2/17/5 - Added Customer Class Detail
		CustomerClassDetail = ""
		If CustomerClassHeading <> "" Then 'Add the column
			CustomerClassDetail = "<TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;" & rsSeat("Class") & "&nbsp;</FONT></TD>"
		End If
			
		'JAI 5/17/6 - Added Order Notes
		If OrderNotesHeading <> "" Then 'Add the column
			OrderNotes = "<TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 REE>" & vbCrLf
				
			'REE 6/23/6 - Added check for Null OrderNumber
			If Not IsNull(rsSeat("OrderNumber")) Then
				SQLOrderNotes = "SELECT ModifyDate, FirstName, LastName, OrderNotes FROM OrderNotes(NOLOCK) INNER JOIN Users(NOLOCK) ON OrderNotes.ModifyUser = Users.UserNumber WHERE OrderNumber = " & rsSeat("OrderNumber") & " ORDER BY ModifyDate"
				Set rsOrderNotes = OBJdbConnection2.Execute(SQLOrderNotes)
				Do Until rsOrderNotes.EOF
					OrderNotes = OrderNotes & rsOrderNotes("FirstName") & " " & rsOrderNotes("LastName") & " - " & rsOrderNotes("ModifyDate") & "<BR>" & vbCrLf
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
			Else
				SeatType = rsSeat("SeatType")
			End If
				
			If Excel <> "Y" Then
				'REE 5/24/7 - Added Customer E-Mail Address
				Response.Write "<TR BGCOLOR=#DDDDDD><TD ALIGN=right NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;<A HREF=/Reports/OrderDetails.asp?OrderNumber=" & rsSeat("OrderNumber") & ">" & rsSeat("OrderNumber") & "</A>&nbsp;</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;" & DateAndTimeFormat(rsSeat("OrderDate")) & "&nbsp;</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("StudentLastName") & ", " & rsSeat("StudentFirstName") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;<A HREF=/Reports/CustomerDetails.asp?CustomerNumber=" & rsSeat("CustomerNumber") & ">" & rsSeat("LastName") & ", " & rsSeat("FirstName") & "</A>&nbsp;</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("Address1") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("Address2") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("City") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("State") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("PostalCode") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & FormatPhone(rsSeat("DayPhone"), "United States") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("EMailAddress") & "</FONT></TD>" & CustomerClassDetail & "<TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;" & rsSeat("Status") & "&nbsp;</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;" & SeatType & "&nbsp;</FONT></TD>" & SurveyDetail & OrderNotes & "</TR>" & vbCrLf
			Else
				'REE 5/24/7 - Added Customer E-Mail Address
				Response.Write "<TR BGCOLOR=#DDDDDD><TD ALIGN=right NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("OrderNumber") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & DateAndTimeFormat(rsSeat("OrderDate")) & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("StudentLastName") & ", " & rsSeat("StudentFirstName") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("LastName") & ", " & rsSeat("FirstName") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("Address1") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("Address2") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("City") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("State") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("PostalCode") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & FormatPhone(rsSeat("DayPhone"), "United States") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("EMailAddress") & "</FONT></TD>" & CustomerClassDetail & "<TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("Status") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & SeatType & "</FONT></TD>" & SurveyDetail & OrderNotes & "</TR>" & vbCrLf
			End If
		Else
			Response.Write "<TR BGCOLOR=#DDDDDD><TD ALIGN=right NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;</FONT></TD><TD>&nbsp;</TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;</FONT></TD><TD>&nbsp;</TD><TD>&nbsp;</TD><TD>&nbsp;</TD><TD>&nbsp;</TD><TD>&nbsp;</TD><TD>&nbsp;</TD>" & CustomerClassDetail & "<TD ALIGN=center NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("Status") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;</FONT></TD><TD>&nbsp;</TD>" & SurveyDetail & OrderNotes & "</TR>" & vbCrLf
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
