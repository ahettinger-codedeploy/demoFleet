<!--#include virtual="GlobalInclude.asp"-->
<!--#include virtual="dbOpenInclude.asp"-->
<%
Page = "EventDetailReport"
ReportFileName = "ClassRegistrationReport.asp"
ReportTitle = "Class Registration Report"

If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then Response.Redirect("/Management/Default.asp")

If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then Response.Redirect("/Management/Default.asp")

If Request("btnSubmit") = "Submit" Then
    Call ReportOutput
Else
    Call ReportCriteria
End If        

Sub ReportCriteria
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
    <title><%= ReportTitle %></title>
    <link href="/CSS/Report.css" rel="stylesheet" type="text/css" />
</head>
<body>


<!--#include virtual="TopNavInclude.asp" -->

<div class="pageTitle"><%= ReportTitle %></div>

<form name="ReportCriteria" action="<%= ReportFileName %>" method="post">
<%
EventListDaysDefault = 30
%>
<fieldset style="width: 600px;" class="reportCriteriaField">
    <legend class="reportCriteriaFieldTitle">Event Selection</legend>

    <!--#INCLUDE VIRTUAL="/Include/EventListDayInclude.asp" -->

    <!--#INCLUDE VIRTUAL="/Include/EventSelectionInclude.asp" -->
</fieldset>
<br />

<%
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

If Request("IncludeOrderNotes") = "on" Then OrderNotesChecked = " CHECKED"
Response.Write "<TABLE ALIGN=CENTER CELLPADDING=0 CELLSPACING=1><TR><TD><INPUT TYPE=""checkbox"" NAME=""IncludeOrderNotes""" & OrderNotesChecked & "></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2>Include Order Notes</FONT></TD></TR></TABLE>" & vbCrLf

%>

<input type="checkbox" name="ExcelOutput" value="Y"<% If Request("ExcelOutput") = "Y" Then %> checked="checked"<% End If %>>&nbsp;&nbsp;Output To Excel<br /><br />

<input type="submit" value="Submit" name="btnSubmit" onclick="return validateForm();" />

</form>

<script language="javascript" type="text/javascript">
function validateForm() {
    formObj = document.ReportCriteria;
    <%= jsValidateForm %>
}
</script>

<!--#include virtual="FooterInclude.asp"-->


</body>
</html>
<%

End Sub 'ReportCriteria

'=======================

Sub ReportOutput

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

'If EventSelection = True Then

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
	
'End If

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

Dim CustFields(12,2)

CustFields(0,0) = "Answer1"
CustFields(0,1) = "Student First Name"
CustFields(1,0) = "Answer2"
CustFields(1,1) = "Student Last Name"
CustFields(2,0) = "Answer3"
CustFields(2,1) = "Gender"
CustFields(3,0) = "Answer5"
CustFields(3,1) = "Age"
CustFields(4,0) = "Answer4"
CustFields(4,1) = "Date of Birth"
CustFields(5,0) = "Answer6"
CustFields(5,1) = "Grade"
CustFields(6,0) = "Answer7"
CustFields(6,1) = "School"
CustFields(7,0) = "Answer8"
CustFields(7,1) = "Parent/Guardian Name"
CustFields(8,0) = "Answer9"
CustFields(8,1) = "Emergency Contact Name"
CustFields(9,0) = "Answer10"
CustFields(9,1) = "Emergency Contact Phone Number"
CustFields(10,0) = "Answer11"
CustFields(10,1) = "Referral"
CustFields(11,0) = "Answer12"
CustFields(11,1) = "Waiver"

SQLSeat = "SELECT Seat.EventCode, OrderLine.OrderNumber, OrderLine.LineNumber, Seat.ItemNumber, SeatStatus.Status, OrderLine.SeatTypeCode, SeatType, OrderDate, OrderHeader.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.DayPhone, Customer.EMailAddress, OrganizationCustomerClass.Class"
For FieldNum = 0 To UBound(CustFields) - 1
    SQLSeat = SQLSeat & ", " & CustFields(FieldNum, 0) & ".FieldValue AS " & CustFields(FieldNum, 0)
Next    
SQLSeat = SQLSeat & " FROM Seat (NOLOCK) INNER JOIN SeatStatus (NOLOCK) ON Seat.StatusCode = SeatStatus.StatusCode LEFT JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent', 'SubSeat') LEFT JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber LEFT JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode LEFT JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber LEFT JOIN CustomerClass (NOLOCK) ON OrderHeader.CustomerNumber = CustomerClass.CustomerNumber LEFT JOIN OrganizationCustomerClass (NOLOCK) ON CustomerClass.ClassNumber = OrganizationCustomerClass.ClassNumber LEFT JOIN Customer WITH (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber "



For FieldNum = 0 To UBound(CustFields) - 1
    FieldName = CustFields(FieldNum, 0)
    SQLSeat = SQLSeat & "LEFT JOIN (SELECT OrderLineDetail.OrderNumber, OrderLineDetail.LineNumber, OrderLineDetail.FieldValue FROM OrderLineDetail WITH (NOLOCK) WHERE OrderLineDetail.FieldName = '" & FieldName & "') AS " & FieldName & " ON OrderLine.OrderNumber = " & FieldName & ".OrderNumber AND OrderLine.LineNumber = " & FieldName & ".LineNumber "
Next
SQLSeat = SQLSeat & "WHERE Seat.EventCode IN (" & EventList & ")"

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
		SQLSeat = SQLSeat & " ORDER BY LastName, FirstName, OrderLine.OrderNumber"
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
		Response.Write "<TR BGCOLOR=#008400><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B><A class=sort HREF=ClassRegistrationReport.asp?SortMethod=OrderNumber&EventList=" & EventList & "&Hold=" & Request("Hold") & "&Reserved=" & Request("Reserved") & "&Open=" & Request("Open") & "&Sold=" & Request("Sold") &  "&Available=" & Request("Available") & "&IncludeOrderNotes=" & Request("IncludeOrderNotes") & "&FormName=ReportSelection#Anc_Sort>&nbsp;Order Number&nbsp;</A></B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>&nbsp;Order Date/Time&nbsp;</B></FONT></TD>"
		For FieldNum = 0 To UBound(CustFields) - 1
		    Response.Write "<TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>" & CustFields(FieldNum, 1) & "</B></FONT></TD>"
		Next
		Response.Write "<TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B><A class=sort HREF=ClassRegistrationReport.asp?SortMethod=CustomerName&EventList=" & EventList & "&Hold=" & Request("Hold") & "&Reserved=" & Request("Reserved") & "&Open=" & Request("Open") & "&Sold=" & Request("Sold") &  "&Available=" & Request("Available") & "&IncludeOrderNotes=" & Request("IncludeOrderNotes") & "&FormName=ReportSelection#Anc_Sort>&nbsp;Billing Name&nbsp;</A></B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Address 1</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Address 2</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>City</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>State</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Postal Code</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Daytime Phone</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>E-Mail Address</B></FONT></TD>" & CustomerClassHeading & "<TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>&nbsp;Status&nbsp;</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>&nbsp;Type&nbsp;</B></FONT></TD>" & OrderNotesHeading & "</TR>" & vbCrLf
	Else
		Response.Write "<TR BGCOLOR=#008400><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Order Number</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Order Date/Time</B></FONT></TD>"
    	For FieldNum = 0 To UBound(CustFields) - 1
		    Response.Write "<TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>" & CustFields(FieldNum, 1) & "</B></FONT></TD>"
		Next
        Response.Write "<TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Billing Name</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Address 1</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Address 2</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>City</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>State</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Postal Code</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Daytime Phone</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>E-Mail Addres</B></FONT></TD>" & CustomerClassHeading & "<TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Status</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Type</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Waiver</B></FONT></TD>" & OrderNotesHeading & "</TR>" & vbCrLf
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
				Response.Write "<TR BGCOLOR=#DDDDDD><TD ALIGN=right NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;<A HREF=/Reports/OrderDetails.asp?OrderNumber=" & rsSeat("OrderNumber") & ">" & rsSeat("OrderNumber") & "</A>&nbsp;</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;" & DateAndTimeFormat(rsSeat("OrderDate")) & "&nbsp;</FONT></TD>"
            	For FieldNum = 0 To UBound(CustFields) - 1
				    Response.Write "<TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat(CustFields(FieldNum, 0)) & "</FONT></TD>"
				Next
				Response.Write "<TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;<A HREF=/Reports/CustomerDetails.asp?CustomerNumber=" & rsSeat("CustomerNumber") & ">" & rsSeat("LastName") & ", " & rsSeat("FirstName") & "</A>&nbsp;</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("Address1") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("Address2") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("City") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("State") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("PostalCode") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & FormatPhone(rsSeat("DayPhone"), "United States") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("EMailAddress") & "</FONT></TD>" & CustomerClassDetail & "<TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;" & rsSeat("Status") & "&nbsp;</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>&nbsp;" & SeatType & "&nbsp;</FONT></TD>" & SurveyDetail & OrderNotes & "</TR>" & vbCrLf
			Else
				'REE 5/24/7 - Added Customer E-Mail Address
				Response.Write "<TR BGCOLOR=#DDDDDD><TD ALIGN=right NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("OrderNumber") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & DateAndTimeFormat(rsSeat("OrderDate")) & "</FONT></TD>"
            	For FieldNum = 0 To UBound(CustFields) - 1
				    Response.Write "<TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat(CustFields(FieldNum, 0)) & "</FONT></TD>"
            	Next    
           	    Response.Write "<TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("LastName") & ", " & rsSeat("FirstName") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("Address1") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("Address2") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("City") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("State") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("PostalCode") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & FormatPhone(rsSeat("DayPhone"), "United States") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("EMailAddress") & "</FONT></TD>" & CustomerClassDetail & "<TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("Status") & "</FONT></TD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & SeatType & "</FONT></TD>" & SurveyDetail & OrderNotes & "</TR>" & vbCrLf
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
