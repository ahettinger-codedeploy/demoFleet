<%

'Update Number 13 - 1/20/2012
'Added the patron's email address to the report - SSR

'CHANGE LOG - Inception
'SSR (8/30/2011)
'Custom Survey

%>

<!--#include virtual="GlobalInclude.asp"-->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="/include/managementinclude.asp"-->

<%

'============================================================

Page = "Management"
ReportFileName = "ClassRegistrationReport.asp"
SurveyReportNumber = "676"
ReportTitle = "Class Registration Report"

'============================================================

'Adventure Theater Attendee Report

'CSS Survey Variables

    TableCategoryBGColor = "#e5c43d"
    TableCategoryFontColor = "000000"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "000000"
    TableDataBGColor = "E9E9E9"

'============================================================

'Request the form name and process requested action

If Clean(Request("FormName")) = "ReportCriteria" Then
	Call DisplayReport(Request("ReportEventCode"))

ElseIf Clean(Request("FormName")) = "Continue" Then
    Call Continue

Else
    Call SurveyForm
End If


'==========================================================
	
Sub SurveyForm

If DocType <> "" Then
	Response.Write DocType
Else
	Response.Write "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
End If

%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<html>
<head>

<title>TIX.com</title>

<style type="text/css">
    
body
{
    font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
    line-height: 1 em;
}
#rounded-corner
{
	font-size: 11px;
    font-weight: 400;
	text-align: left;
	border-collapse: collapse;
	width: 100%;
	top: 10px;
	line-height: 12px;
	margin-top:  10px;
}
#rounded-corner thead th.category
{
	padding-top: 5px;
    padding-bottom: 5px;
    padding-left: 10px;
    padding-right: 10px;
	font-size: 12px;
	font-weight: 600;
	text-align: center;
	color: <%=TableCategoryFontColor%>;
	background: <%=TableCategoryBGColor%>;
}
#rounded-corner thead th.category-left
{
	background: <%=TableCategoryBGColor%> url('<%=NECorner%>') left -1px no-repeat;
	text-align: right;
}
#rounded-corner thead th.category-right
{
	background: <%=TableCategoryBGColor%> url('<%=NWCorner%>') right -1px no-repeat;
    text-align: left;
}
#rounded-corner td.footer
{
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.footer-left
{
    background: <%=TableDataBGColor%> url('<%=SWCorner%>') left bottom no-repeat;
}
#rounded-corner td.footer-right
{
	background: <%=TableDataBGColor%> url('<%=SECorner%>') right bottom no-repeat;
}
#rounded-corner td.data
{
	padding-left: 5px;
	padding-right: 5px;
	padding-top: 5px;
	padding-bottom: 5px;
	text-align: center;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-left
{
	padding-left: 10px;
	padding-right: 10px;
	padding-top: 10px;
	padding-bottom: 10px;
	text-align: left;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-right
{
	padding-left: 10px;
	padding-right: 10px;
	padding-top: 10px;
	padding-bottom: 10px;
    text-align: right;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
</style>
</head>

<body>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<form action="<%= SurveyFileName %>" method="post" name="Survey">
<input type="hidden" name="FormName" value="ReportCriteria">
	
<% EventListDaysDefault = 30 %>

<fieldset style="width: 600px;" class="reportCriteriaField">

<legend class="reportCriteriaFieldTitle">Event Selection</legend>

<B><%=ReportTitle%></B>

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

%>

<table id="rounded-corner" summary="surveypage" border="0">
<thead>
    <tr>
	    <th scope="col" class="category">&nbsp;</th>
	    <th scope="col" class="category">Date/Time</th>
	    <th scope="col" class="category">Production</th>
	    <th scope="col" class="category">Attendee Count</th>
    </tr>        
</thead>
<tbody>

<%

SQLEvents = "SELECT Event.EventCode, Act, Venue, EventDate, SurveyNumber FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE EventDate > GETDATE()-" & ArchiveDays & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND Event.SurveyNumber = " & SurveyReportNumber & " ORDER BY EventDate, Act"
Set rsEvents = OBJdbConnection.Execute(SQLEvents)

Do Until rsEvents.EOF

    SQLTicketsSold = "SELECT Count(OrderLine.LineNumber) as Count FROM Seat (NOLOCK) INNER JOIN Section (NOLOCK) ON Seat.SectionCode = Section.SectionCode AND Seat.EventCode = Section.EventCode INNER JOIN SeatStatus (NOLOCK) ON Seat.StatusCode = SeatStatus.StatusCode LEFT JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent', 'SubSeat') INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode AND OrganizationVenue.OrganizationNumber = OrganizationAct.OrganizationNumber LEFT JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber LEFT JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode LEFT JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber WHERE Seat.EventCode = " & rsEvents("EventCode") & "  AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND Seat.StatusCode = 'S' "
    Set rsTicketsSold = OBJdbConnection.Execute(SQLTicketsSold)

%>

    <TR>
        <TD class="data"><INPUT TYPE="radio" NAME="ReportEventCode" VALUE=<%=rsEvents("EventCode")%>></TD>
        <TD class="data" NOWRAP><%=DateAndTimeFormat(rsEvents("EventDate"))%></TD>
        <TD class="data-left"><%=rsEvents("Act")%></TD>
        <TD class="data" NOWRAP><%=rsTicketsSold("Count")%></TD>
    </TR>
    <tr>
      <TD class="data" colspan="4"><hr /></TD>
    </tr>

<%	

    rsTicketsSold.Close
    Set rsTicketsSold = nothing

rsEvents.MoveNext	
Loop

rsEvents.Close
Set rsEvents = nothing

%>
    
</fieldset><br /><br />

<tr>
    <td class="footer" colspan="4">&nbsp;</td>
</tr>
<tr>
    <td align="center" colspan="4">
    <br /><br />
    <INPUT TYPE="checkbox" NAME="ExcelOutput" VALUE="Y">&nbsp;&nbsp;<FONT FACE=verdana,arial,helvetica SIZE=2>Output To Excel</FONT>
    <br /><br />
    <INPUT TYPE="submit" VALUE="Continue"></FORM></td>
</tr>
</tbody>
</table>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>
</html>

<%

End Sub

'======================================

Sub DisplayReport(ReportEventCode)


Dim StandardQuestion(10)
StandardQuestion(1) = "Order Number"
StandardQuestion(2) = "Order Date/Time"
StandardQuestion(3) = "Customer Name"
StandardQuestion(4) = "Day Phone"
StandardQuestion(5) = "Evening Phone"
StandardQuestion(6) = "Email Address"
StandardQuestion(7) = "Status"
StandardQuestion(8) = "Ticket Type"
StandardQuestion(9) = "Net Price"
StandardQuestion(10) = "Order Type"

Dim CustomQuestion(16) 
CustomQuestion(1) = "First Name"	
CustomQuestion(2) = "Last Name"	
CustomQuestion(3) = "Gender"	
CustomQuestion(4) = "Date of Birth"	
CustomQuestion(5) = "Age"	
CustomQuestion(6) = "Grade"
CustomQuestion(7) = "School"	
CustomQuestion(8) = "Parent/Guardian Name"	
CustomQuestion(9) = "Emergency Contact Name"	
CustomQuestion(10) = "Emergency Contact Phone Number"
CustomQuestion(11) = "Who where you referred by?"
CustomQuestion(12) = "Physician Name"
CustomQuestion(13) = "Physician Phone"
CustomQuestion(14) = "Date of last Tetanus Shot"
CustomQuestion(15) = "Medical Concerns"
CustomQuestion(16) = "Waiver"

Response.Buffer = False
Excel = Clean(Request("ExcelOutput"))

If Excel = "Y" Then

	Response.ContentType = "application/vnd.ms-excel"

End If

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & ReportTitle & "</TITLE>" & vbCrLf

%>

<style type="text/css">
    
body
{
font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
line-height: 1 em;
}

#report
{
font-size: 11px;
font-weight: 400;
text-align: left;
border-collapse: collapse;
top: 10px;
line-height: 15px;
margin-top:  10px;
}

#report table
{
padding-top: 0px;
padding-bottom: 0px;
padding-left: 0px;
padding-right: 0px;
}

#report th
{
padding-top: 0px;
padding-bottom: 0px;
padding-left: 0px;
padding-right: 20px;
font-size: 11px;
font-weight: 600;
color: #ffffff;
text-align: left;
white-space:nowrap;
}
#report td
{
padding-top: 0px;
padding-bottom: 0px;
padding-left: 0px;
padding-right: 10px;
white-space:nowrap;
}
</style>

<%

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

	
		SQLEvent = "SELECT Act, Venue, EventDate, OrganizationVenue.OrganizationNumber FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) on Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) on Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = Act.ActCode AND OrganizationVenue.OrganizationNumber = OrganizationAct.OrganizationNumber WHERE Event.EventCode = " & ReportEventCode & " AND OrganizationVenue.Owner <> 0"
		Set rsEvent = OBJdbConnection.Execute(SQLEvent)
				
	    'Report Title
	    '-------------------
	    Response.Write "<BR><H4>" & rsEvent("Act") & " at " & rsEvent("Venue") & " on " & FormatDateTime(rsEvent("EventDate"), vbShortDate) & " at " & Left(FormatDateTime(rsEvent("EventDate"), vbLongTime), Len(FormatDateTime(rsEvent("EventDate"), vbLongTime))-6) & " " & Right(FormatDateTime(rsEvent("EventDate"),vbLongTime), 2) & "</H4>" & vbCrLf
		
		rsEvent.Close
		Set rsEvent = nothing
		
		
	    'Report Start 
		'-------------------		
		Response.Write "<table id=""report"" >" & vbCrLf
	    Response.Write "<thead>" & vbCrLf
		Response.Write "<tr>" & vbCrLf		
		
		
		'Column Heading Labels
		'---------------------
		
        'Standard Headings
        For j = 1 to UBound(StandardQuestion)
            Response.Write "<th>" & StandardQuestion(j) & "</th>" & vbCrLf
        Next

        'Custom Headings
        For k = 1 to UBound(CustomQuestion)
            Response.Write "<th>" & CustomQuestion(k) & "</th>" & vbCrLf
        Next
        
        Response.Write "</tr>" & vbCrLf         
        
        
        'Survey Results
        '--------------   
        
        SQLSeat = "SELECT Seat.EventCode, OrderLine.OrderNumber, OrderLine.LineNumber, Seat.ItemNumber, Seat.SectionCode, Section.Section, Section.SectionType, Seat.Row, Seat.Seat, SeatStatus.Status, Seat.HoldType, OrderType, OrderLine.SeatTypeCode, SeatType, Price, OrderLine.Discount, OrderDate, OrderHeader.CustomerNumber, ShipFirstName AS FirstName, ShipLastName AS LastName FROM Seat (NOLOCK) INNER JOIN Section (NOLOCK) ON Seat.SectionCode = Section.SectionCode AND Seat.EventCode = Section.EventCode INNER JOIN SeatStatus (NOLOCK) ON Seat.StatusCode = SeatStatus.StatusCode LEFT JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent', 'SubSeat') INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode AND OrganizationVenue.OrganizationNumber = OrganizationAct.OrganizationNumber LEFT JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber LEFT JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode LEFT JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber WHERE Seat.EventCode = " & ReportEventCode & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND Seat.StatusCode = 'S' ORDER BY Seat.SectionCode, Seat.RowSort, Seat.SeatSort DESC"
        Set rsSeat = OBJdbConnection.Execute(SQLSeat)
	
	    If Not rsSeat.EOF Then  
		
		Do Until rsSeat.EOF
		
        'Standard Data
        '-------------
		
                SQLCustomerInfo = "SELECT FirstName, MiddleInitial, LastName, Address1, Address2, City, State, PostalCode, Country, DayPhone, NightPhone, EMailAddress, OptIn FROM Customer (NOLOCK) WHERE CustomerNumber = " & rsSeat("CustomerNumber") & ""
                Set rsCustomerInfo = OBJdbConnection.Execute(SQLCustomerInfo)

                    Response.Write "<tr>" & vbCrLf
		            Response.Write "<td>" & rsSeat("OrderNumber") & "</td>" & vbCrLf
		            Response.Write "<td>" & DateAndTimeFormat(rsSeat("OrderDate")) & "</td>" & vbCrLf
		            Response.Write "<td>" & rsCustomerInfo("LastName") & ", " & rsCustomerInfo("FirstName") & "</td>" & vbCrLf
		            Response.Write "<td>" & rsCustomerInfo("DayPhone") & "</td>" & vbCrLf
		            Response.Write "<td>" & rsCustomerInfo("NightPhone") & "</td>" & vbCrLf
		            Response.Write "<td>" & rsCustomerInfo("EMailAddress") & "</td>" & vbCrLf
		            Response.Write "<td>" & rsSeat("Status") & "</td>" & vbCrLf
		        
                rsCustomerInfo.Close
                Set rsCustomerInfo = nothing
		        
		        
		        If IsNull(rsSeat("SeatTypeCode")) Then
					SeatType = ""
					Price = 0
				Else
					SeatType = rsSeat("SeatType")
					Price = rsSeat("Price") - rsSeat("Discount")
				End If       
		        
		        Response.Write "<td>" & SeatType & "</td>" & vbCrLf
		        Response.Write "<td>" & FormatCurrency(Price,2)  & "</td>" & vbCrLf
		        Response.Write "<td>" & rsSeat("OrderType") & "</td>" & vbCrLf


        'Custom Data Fields  
        '-----------------
                
                For k = 1 to UBound(CustomQuestion)

                    SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & rsSeat("OrderNumber") & " AND LineNumber = " & rsSeat("LineNumber") & " AND FieldName = 'Answer" & k & "'"
                    Set rsOrderLineDetail = OBJdbConnection.Execute(SQLOrderLineDetail) 
                    
                    If NOT rsOrderLineDetail.EOF Then   
                        
                        If rsOrderLineDetail("FieldValue") = "" OR rsOrderLineDetail("FieldValue") = "0" Then                
                            Response.Write "<td>&nbsp;</td>" & vbCrLf                 
                        Else                
                            Response.Write "<td>" & rsOrderLineDetail("FieldValue") & "&nbsp;&nbsp;&nbsp;</td>" & vbCrLf                        
                        End If 
                               
                    Else   
                    
                        Response.Write "<td>&nbsp;</td>" & vbCrLf   
                        
                    End If   
                    
                    rsOrderLineDetail.Close
                    Set rsOrderLineDetail = nothing

                Next
                
                Response.Write "</tr>" & vbCrLf
                
        rsSeat.MoveNext
        Loop
        
        End If
       
       Response.Write "</table>" & vbCrLf
	
%>

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