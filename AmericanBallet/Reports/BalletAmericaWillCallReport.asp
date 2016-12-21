<!--#include virtual="GlobalInclude.asp"-->
<!--#include virtual="dbOpenInclude.asp"-->
<%
Page = "ManagementReport"

If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then Response.Redirect("/Management/Default.asp")

If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then Response.Redirect("/Management/Default.asp")

Select Case Clean(Request("FormName"))

	Case "ReportCriteria"
		Call ReportOutput()
	Case Else
		Call ReportCriteria()
End Select

Sub ReportCriteria()
%>
<HTML>
<HEAD>
<TITLE>Tix - Will Call Report</TITLE>
<script LANGUAGE="JavaScript">    

<!-- Hide code from non-js browsers

function makeCheck(thisForm){
	for (i = 0; i < thisForm.DeliveryMethods.length; i++){
		if(thisForm.SelectAll.checked==true){
			thisForm.DeliveryMethods[i].checked=true
			}
			else
			{
			thisForm.DeliveryMethods[i].checked=false
			}
		}
	}

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
<%
If Excel <> "Y" Then
%>
	<CENTER>
	<!--#include virtual="TopNavInclude.asp" -->
<%
End If

Response.Write "<BR><BR><FONT FACE=verdana,arial,helvetica COLOR=#008400><H3>Will Call Report</H3></FONT>" & vbCrLf
Response.Write "<FONT FACE=verdana,arial,helvetica SIZE=2>" & vbCrLf

'REE 5/28/5 - Added ability to output to Excel
If Excel <> "Y" Then
	Response.Write "<FORM ACTION=""BalletAmericaWillCallReport.asp"" METHOD=""post"" id=form1 name=Report onSubmit=""return ValidateForm()"">" & vbCrLf
	Response.Write "<INPUT TYPE=""hidden"" NAME=""FormName"" VALUE=""ReportCriteria"">" & vbCrLf
	Response.Write "<SELECT NAME=""Events"">" & vbCrLf

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
	SQLEvents = "SELECT Event.EventCode, Act, EventDate, SurveyNumber FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE EventDate > GETDATE()-" & ArchiveDays & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " ORDER BY EventDate"
	Set rsEvents = OBJdbConnection.Execute(SQLEvents)
	Response.Write "<OPTION VALUE=0 SELECTED>--Select Event--" & vbCrLf
	Do Until rsEvents.EOF
		Response.Write "<OPTION VALUE=" & rsEvents("EventCode") & ">" & rsEvents("EventDate") & "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" & rsEvents("Act") & vbCrLf
		If Not IsNull(rsEvents("SurveyNumber")) Then 'There's a survey.  Display the survey option.
			SurveyExists = "Y"
		End If
		rsEvents.MoveNext
	Loop
	
	rsEvents.Close
	Set rsEvents = nothing

	Response.Write "</SELECT><BR><BR>" & vbCrLf

	'REE 11/23/7 - Added flexible Delivery Methods
	'REE 10/27/8 - Reorganized second query to run faster.  Nested OrderLine/Event tables.
	SQLDeliveryMethods = "SELECT Shipping.ShipCode, Shipping.ShipType FROM Event (NOLOCK) INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN EventShip (NOLOCK) ON Event.EventCode = EventShip.EventCode INNER JOIN Shipping (NOLOCK) ON EventShip.ShipCode = Shipping.ShipCode WHERE OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND Event.EventDate > GETDATE()-" & ArchiveDays & " UNION SELECT Shipping.ShipCode, Shipping.ShipType FROM Shipping (NOLOCK) WHERE ShipCode IN (SELECT ShipCode FROM OrderLIne (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND Event.EventDate > GETDATE()-" & ArchiveDays & " AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent')) GROUP BY Shipping.ShipCode, Shipping.ShipType ORDER BY Shipping.ShipType"
	Set rsDeliveryMethods = OBJdbConnection.Execute(SQLDeliveryMethods)
	
	Response.Write "<TABLE CELLPADDING=""3"">" & vbCrLf

	Response.Write "<TR BGCOLOR=""#008400""><TD ALIGN=""center""><INPUT TYPE=checkbox Name=SelectAll onClick=""makeCheck(this.form)"" id=SelectAll name=SelectAll></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2>Delivery Method</FONT></TD></TR>" & vbCrLf

	Do Until rsDeliveryMethods.EOF

		Response.Write "<TR BGCOLOR=""#DDDDDD""><TD><INPUT TYPE=""checkbox"" NAME=""DeliveryMethods"" VALUE=" & rsDeliveryMethods("ShipCode") & "></TD><TD NOWRAP><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsDeliveryMethods("ShipType") & "</FONT></TD></TR>" & vbCrLf
		rsDeliveryMethods.MoveNext
			
	Loop
	
	Response.Write "</TABLE><BR><BR>" & vbCrLf

	'REE 3/4/2 - Added ability to sort by different fields
	Response.Write "<TABLE><TR><TD COLSPAN=""2"" ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2""><B>Sort By</B></FONT></TD></TR>" & vbCrLf
	Response.Write "<TR><TD><INPUT TYPE=""radio"" NAME=""SortBy"" VALUE=""Name"" CHECKED></TD><TD><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">Customer Name</FONT></TD></TR>" & vbCrLf
	Response.Write "<TR><TD><INPUT TYPE=""radio"" NAME=""SortBy"" VALUE=""OrderNumber""></TD><TD><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">Order Number</FONT></TD></TR>" & vbCrLf
	Response.Write "<TR><TD><INPUT TYPE=""radio"" NAME=""SortBy"" VALUE=""OrderDate""></TD><TD><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">Order Date</FONT></TD></TR></TABLE><BR>" & vbCrLf

	Response.Write "<TABLE ALIGN=CENTER CELLPADDING=0 CELLSPACING=1>" & vbCrLf
	'REE 8/25/5 - Added option to include survey results
	'If any of the events in the drop down list above have a survey associated with them, display the survey option.
	If SurveyExists = "Y" Then
		If Request("IncludeSurvey") = "on" Then SurveyChecked = " CHECKED"
		Response.Write "<TR><TD><INPUT TYPE=""checkbox"" NAME=""IncludeSurvey""" & SurveyChecked & "></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2>Include Survey Results</FONT></TD></TR>" & vbCrLf
	End If

	'JAI 5/17/6 - Added option to include order notes
	If Request("IncludeOrderNotes") = "on" Then OrderNotesChecked = " CHECKED"
	Response.Write "<TR><TD><INPUT TYPE=""checkbox"" NAME=""IncludeOrderNotes""" & OrderNotesChecked & "></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2>Include Order Notes</FONT></TD></TR>" & vbCrLf

	'TTT 10/26/07 - Added option to group matching rows
	'Response.Write "<TR><TD><INPUT TYPE=""checkbox"" NAME=""GroupCount"" VALUE=""Y""></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2>Summarize Report</FONT></TD></TR>" & vbCrLf

	'REE 5/5/5 - Added ability to output to Excel
	Response.Write "<TR><TD><INPUT TYPE=""checkbox"" NAME=""ExcelOutput"" VALUE=""Y""></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2>Output To Excel</FONT></TD></TR>" & vbCrLf


	Response.Write "</TABLE><BR>" & vbCrLf

	Response.Write "<INPUT TYPE=""submit"" VALUE=""Enter""></FORM><BR><BR>" & vbCrLf
	
%>
	<!--#include virtual="FooterInclude.asp"-->
<%
	Response.Write "</CENTER>" & vbCrLf
End If 'Excel Output

Response.Write "</BODY>" & vbCrLf
Response.Write "</HTML>" & vbCrLf

End Sub 'ReportCriteria

'===================================================

Sub ReportOutput()
	
'REE 5/28/5 - Added ability to output to Excel
Excel = Clean(Request("ExcelOutput"))

If Excel = "Y" Then
	Response.ContentType = "application/vnd.ms-excel"
End If

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>Tix - Will Call Report</TITLE>" & vbCrLf

If Excel <> "Y" Then
%>
    <script LANGUAGE="JavaScript">    
    <!-- Hide code from non-js browsers

    function bgOn(obj, clr) { 
	    obj.style.backgroundColor = clr; 
    }

    // end hiding -->
    </script>
<%
End If

Response.Write "</HEAD>" & vbCrLf

Response.Write "<BODY BGCOLOR=""#FFFFFF"">" & vbCrLf

If Excel <> "Y" Then
%>
	<CENTER>
	<!--#include virtual="TopNavInclude.asp" -->
<%
End If

Response.Write "<BR><BR><FONT FACE=verdana,arial,helvetica COLOR=#008400><H3>Will Call Report</H3></FONT>" & vbCrLf
Response.Write "<FONT FACE=verdana,arial,helvetica SIZE=2>" & vbCrLf

'REE 11/23/7 - Added flexible Delivery Methods
DeliveryMethods = "("
For Each DeliveryMethod In Request("DeliveryMethods")
	DeliveryMethods = DeliveryMethods & DeliveryMethod & ","
Next 'DeliveryMethod
DeliveryMethods = Left(DeliveryMethods, Len(DeliveryMethods)-1) & ")"

'REE 3/4/2 - Added ability to sort by different fields
Select Case Clean(Request("SortBy"))
    Case "Name"
	    SortBy = "Customer.LastName, Customer.FirstName"
    Case "OrderNumber"
	    SortBy = "OrderHeader.OrderNumber"
    Case "OrderDate"
	    SortBy = "OrderHeader.OrderDate"
End Select
	
'REE 3/4/2 - Added SortBy to Query
'REE 11/23/7 - Added Delivery Method to report.
'SQLSeat = "SELECT Act, Venue, EventDate, Section, Row, Seat, OrderHeader.OrderNumber, OrderDate, OrderHeader.CustomerNumber, ShipFirstName, ShipLastName, SeatStatus.Status, SeatType, Price, OrderLine.Discount, Shipping.ShipType FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.SectionCode = Section.SectionCode AND Seat.EventCode = Section.EventCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN SeatStatus (NOLOCK) ON Seat.StatusCode = SeatStatus.StatusCode INNER JOIN Shipping (NOLOCK) ON OrderLine.ShipCode = Shipping.ShipCode WHERE Seat.EventCode = " & CleanNumeric(Request("Events")) & " AND OrderLine.ShipCode IN " & DeliveryMethods & " AND Seat.StatusCode = 'S' AND OrderLine.ShippedDate IS NULL AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent', 'SubSeat') ORDER BY " & SortBy
SQLSeat = "SELECT Customer.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.EmailAddress, OrderHeader.OrderNumber, OrderHeader.OrderDate, COUNT(*) AS Total_Tickets_Per_Order FROM OrderHeader WITH (NOLOCK) INNER JOIN Customer WITH (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN OrderLine WITH (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE Seat.EventCode = " & CleanNumeric(Request("Events")) & " AND OrderLine.ShipCode IN " & DeliveryMethods & " AND Seat.StatusCode = 'S' AND OrderLine.ShippedDate IS NULL AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent', 'SubSeat') GROUP BY Customer.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.EmailAddress, OrderHeader.OrderNumber, OrderHeader.OrderDate ORDER BY " & SortBy 'Customer.FirstName, Customer.LastName, OrderHeader.OrderNumber"
Set rsSeat = OBJdbConnection.Execute(SQLSeat)
If Not rsSeat.EOF Then

	'Response.Write "<TABLE CELLPADDING=5 BORDER=0><TR><TD><FONT FACE=verdana,arial,helvetica SIZE=2><B>" & rsSeat("Act") & "</B></FONT></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2><B>" & rsSeat("Venue") & "</B></FONT></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2><B>" & FormatDateTime(rsSeat("EventDate"), vbShortDate) & "</B></FONT></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2><B>" & Left(FormatDateTime(rsSeat("EventDate"), vbLongTime), Len(FormatDateTime(rsSeat("EventDate"), vbLongTime))-6) & " " & Right(FormatDateTime(rsSeat("EventDate"),vbLongTime), 2) & "</B></FONT></TD></TR></TABLE>" & vbCrLf
	Call DBOpen(OBJdbConnection2)
	SQLEvent = "SELECT Act, Venue, EventDate FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode WHERE Event.EventCode = " & CleanNumeric(Request("Events"))
	Set rsEvent = OBJdbConnection2.Execute(SQLEvent)
	Response.Write "<TABLE CELLPADDING=5 BORDER=0><TR><TD><FONT FACE=verdana,arial,helvetica SIZE=2><B>" & rsEvent("Act") & "</B></FONT></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2><B>" & rsEvent("Venue") & "</B></FONT></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2><B>" & rsEvent("EventDate") & "</B></FONT></TD></TR></TABLE>" & vbCrLf
	rsEvent.Close
	Set rsEvent = nothing	
	
	Response.Write "<TABLE CELLPADDING=6 BORDER=0>" & vbCrLf
	
	Response.Write "<TR BGCOLOR=#008400><TD><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Order Date</B></FONT></TD>"
	Response.Write "<TD><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>First Name</B></FONT></TD>"
	Response.Write "<TD><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Last Name</B></FONT></TD>"
	If Clean(Request("IncludeSurvey")) = "on" Then
	    For i = 1 To 4
		    SurveyResults = "<TD ALIGN=center NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Question " & i & "</B></FONT></TD>"
		    Response.Write(SurveyResults)
		Next
    End If
	If Clean(Request("IncludeOrderNotes")) = "on" Then
		OrderNotesHeading = "<TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Order Notes</B></FONT></TD>"
		Response.Write(OrderNotesHeading)
    End If
	Response.Write "<TD><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Total Tickets</B></FONT></TD></TR>"
	
	CustomerNo = ""
	TotalTickets = 0
	TicketsPerOrder = 0
	Do Until rsSeat.EOF
	    TicketsPerOrder = rsSeat("Total_Tickets_Per_Order")
	    
	    'show each distinct customer with ONLY one oldest order
	    
		If CustomerNo <> rsSeat("CustomerNumber") Then
		    TotalTickets = 0
		    
		    Response.Write "<TR BGCOLOR=#EEEEEE><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("OrderDate") & "</FONT></TD>"
	        Response.Write "<TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("FirstName") & "</FONT></TD>"
	        Response.Write "<TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSeat("LastName") & "</FONT></TD>"
	        
	        'Response.Write "<TD><FONT FACE=verdana,arial,helvetica SIZE=2>" & TicketsPerOrder & "</FONT></TD></TR>"
	        
	        'Add Survey Results column
	        If SurveyResults <> "" Then
	            For i = 1 To 4
	                SurveyAnswers = "<TD ALIGN=left VALIGH=TOP NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & vbCrLf
    	            
	                SQLSurveyAnswers = "SELECT Answer FROM SurveyAnswers (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON SurveyAnswers.OrderNumber = OrderHeader.OrderNumber WHERE SurveyAnswers.OrderNumber = " & rsSeat("OrderNumber") & " AND AnswerNumber = " & i
	                Set rsSurveyAnswers = OBJdbConnection2.Execute(SQLSurveyAnswers)
	                Do While Not rsSurveyAnswers.EOF
	                    SurveyAnswers = SurveyAnswers & rsSurveyAnswers("Answer") & "<BR>" & vbCrLf
	                    rsSurveyAnswers.movenext
	                Loop
	                rsSurveyAnswers.Close
	                Set rsSurveyAnswers = Nothing
    	            
	                SurveyAnswers = SurveyAnswers & "</FONT></TD>" & vbCrLf
			        Response.Write(SurveyAnswers)
			    Next
	        End If
	        
	        'Add Order Notes column
	        If OrderNotesHeading <> "" Then 
			    OrderNotes = "<TD ALIGN=left VALIGH=TOP NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & vbCrLf
    				
			    SQLOrderNotes = "SELECT ModifyDate, FirstName, LastName, OrderNotes FROM OrderNotes(NOLOCK) INNER JOIN Users(NOLOCK) ON OrderNotes.ModifyUser = Users.UserNumber WHERE OrderNumber = " & rsSeat("OrderNumber") & " ORDER BY ModifyDate"
			    Set rsOrderNotes = OBJdbConnection2.Execute(SQLOrderNotes)
			    Do Until rsOrderNotes.EOF
				    OrderNotes = OrderNotes & rsOrderNotes("FirstName") & " " & rsOrderNotes("LastName") & " - " & rsOrderNotes("ModifyDate") & "<BR>" & vbCrLf
				    OrderNotes = OrderNotes & rsOrderNotes("OrderNotes")
				    rsOrderNotes.MoveNext
			    Loop
			    rsOrderNotes.Close
			    Set rsOrderNotes = nothing
    				
			    OrderNotes = OrderNotes & "</FONT></TD>" & vbCrLf
			    Response.Write(OrderNotes)
		    End If
		
		    CustomerNo = rsSeat("CustomerNumber")
		
		End If
	    
	    TotalTickets = TotalTickets + TicketsPerOrder
	    rsSeat.MoveNext
	    
	    If Not rsSeat.EOF Then
	        If CustomerNo <> rsSeat("CustomerNumber") Then
	            Response.Write "<TD><FONT FACE=verdana,arial,helvetica SIZE=2>" & TotalTickets & "</FONT></TD></TR>"
	            'Response.Write "<TR BGCOLOR=#FFFFFF><TD COLSPAN=""2"" ALIGN=""right""><FONT FACE=verdana,arial,helvetica SIZE=2>Total Tickets --></FONT></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=""RED"">" & TotalTickets & "</FONT></TD></TR>"
	        End If
	    Else
	        Response.Write "<TD><FONT FACE=verdana,arial,helvetica SIZE=2>" & TotalTickets & "</FONT></TD></TR>"
	        'Response.Write "<TR BGCOLOR=#FFFFFF><TD COLSPAN=""2"" ALIGN=""right""><FONT FACE=verdana,arial,helvetica SIZE=2>Total Tickets --></FONT></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=""RED"">" & TotalTickets & "</FONT></TD></TR>"
	    End If
	    
	Loop
	
	Call DBClose(OBJdbConnection2)
	Response.Write "</TABLE>" & vbCrLf
Else
	SQLEvent = "SELECT Act, Venue, EventDate FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode WHERE Event.EventCode = " & Clean(Request("Events"))
	Set rsEvent = OBJdbConnection.Execute(SQLEvent)
	Response.Write "<TABLE CELLPADDING=5 BORDER=0><TR><TD><FONT FACE=verdana,arial,helvetica SIZE=2><B>" & rsEvent("Act") & "</B></FONT></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2><B>" & rsEvent("Venue") & "</B></FONT></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2><B>" & FormatDateTime(rsEvent("EventDate"), vbShortDate) & "</B></FONT></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2><B>" & Left(FormatDateTime(rsEvent("EventDate"), vbLongTime), Len(FormatDateTime(rsEvent("EventDate"), vbLongTime))-6) & " " & Right(FormatDateTime(rsEvent("EventDate"),vbLongTime), 2) & "</B></FONT></TD></TR></TABLE>" & vbCrLf
	rsEvent.Close
	Set rsEvent = nothing
	Response.Write "No Tickets Found.<BR>" & vbCrLf
End If
	
%>

</FONT>
<BR>
<BR>
<BR>
<%
If Excel <> "Y" Then
%>
	<!--#include virtual="FooterInclude.asp"-->
	</CENTER>
<%
End If

Response.Write "</BODY>" & vbCrLf
Response.Write "</HTML>" & vbCrLf

End Sub 'ReportOutput
%>
