<%

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

Dim Question(16)
Question(1) = "First Name"	
Question(2) = "Last Name"	
Question(3) = "Gender"	
Question(4) = "Date of Birth"	
Question(5) = "Age"	
Question(6) = "Grade"
Question(7) = "School"	
Question(8) = "Parent/Guardian Name"	
Question(9) = "Emergency Contact Name"	
Question(10) = "Emergency Contact Phone Number"
Question(11) = "Who where you referred by?"
Question(12) = "Physician Name"
Question(13) = "Physician Phone"
Question(14) = "Date of last Tetanus Shot"
Question(15) = "Medical Concerns"
Question(16) = "Waiver"

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

#dark-corner
{
font-size: 11px;
font-weight: 400;
text-align: left;
border-collapse: collapse;
top: 10px;
line-height: 15px;
margin-top:  10px;
}

#dark-corner table
{
padding-top: 0px;
padding-bottom: 0px;
padding-left: 0px;
padding-right: 0px;
}

#dark-corner thead th.category
{
padding-top: 0px;
padding-bottom: 0px;
padding-left: 0px;
padding-right: 15px;
font-size: 11px;
font-weight: 600;
color: #000000;
text-align: left;
white-space:nowrap;
}

#dark-corner thead th.category-left
{
background-repeat: repeat;
text-align: right;
}

#dark-corner thead th.category-right
{
background-repeat: repeat;
text-align: left;
}

#dark-corner tr.data-odd
{
background: #f2fff2;
}

#dark-corner tr.data-even
{
background: #e9e9e9;
}

#dark-corner tr.data
{
padding-top: 10px;
padding-bottom: 10px;
padding-left: 10px;
padding-right: 15px;
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
		Response.Write "<table >" & vbCrLf
	    Response.Write "<thead>" & vbCrLf
		Response.Write "<tr>" & vbCrLf		
		
		'Column Names - Standard
		'--------------------------------------
        Response.Write "<th class=""category"">Order Number</th><th class=""category"">Order Date/Time</th><th class=""category"">Customer Name</th><th class=""category"">Status</th><th class=""category"">Ticket Type</th><th class=""category"">Net Price</th><th class=""category"">Order Type</th>" & vbCrLf
        
        
        'Column Names - Custom
        '------------------------------------     
        For j = 1 to UBound(Question)
            Response.Write "<th class=""category"">" & Question(j) & "</th>" & vbCrLf
        Next
        
        Response.Write "</tr>" & vbCrLf         
        
        'Report Survey Results - Standard 
        '--------------------------------- 
                
        'Alternating row color - set the line count to 0
        lc = 0         
        
        SQLSeat = "SELECT Seat.EventCode, OrderLine.OrderNumber, OrderLine.LineNumber, Seat.ItemNumber, Seat.SectionCode, Section.Section, Section.SectionType, Seat.Row, Seat.Seat, SeatStatus.Status, Seat.HoldType, OrderType, OrderLine.SeatTypeCode, SeatType, Price, OrderLine.Discount, OrderDate, OrderHeader.CustomerNumber, ShipFirstName AS FirstName, ShipLastName AS LastName FROM Seat (NOLOCK) INNER JOIN Section (NOLOCK) ON Seat.SectionCode = Section.SectionCode AND Seat.EventCode = Section.EventCode INNER JOIN SeatStatus (NOLOCK) ON Seat.StatusCode = SeatStatus.StatusCode LEFT JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent', 'SubSeat') INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode AND OrganizationVenue.OrganizationNumber = OrganizationAct.OrganizationNumber LEFT JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber LEFT JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode LEFT JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber WHERE Seat.EventCode = " & ReportEventCode & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND Seat.StatusCode = 'S' ORDER BY Seat.SectionCode, Seat.RowSort, Seat.SeatSort DESC"
        Set rsSeat = OBJdbConnection.Execute(SQLSeat)
	
	    If Not rsSeat.EOF Then  
		
		Do Until rsSeat.EOF
		
		        lc = lc + 1
		        
		        'Set row background color to white 
                classtype = "data-odd"
                
                'For odd rows, set background color to a lovely green
                If lc mod 2 = 1 then 
                    classtype = "data-even"
                End If
                
                Response.Write "<tr class='" & classtype & "'>" & vbCrLf
		        Response.Write "<td NOWRAP>" & rsSeat("OrderNumber") & "</td>" & vbCrLf
		        Response.Write "<td NOWRAP>" & DateAndTimeFormat(rsSeat("OrderDate")) & "</td>" & vbCrLf
		        Response.Write "<td NOWRAP>" & rsSeat("LastName") & ", " & rsSeat("FirstName") & "</td>" & vbCrLf
		        Response.Write "<td NOWRAP>" & rsSeat("Status") & "</td>" & vbCrLf
		        
		        If IsNull(rsSeat("SeatTypeCode")) Then
					SeatType = ""
					Price = 0
				Else
					SeatType = rsSeat("SeatType")
					Price = rsSeat("Price") - rsSeat("Discount")
				End If       
		        
		        Response.Write "<td NOWRAP>" & SeatType & "</td>" & vbCrLf
		        Response.Write "<td NOWRAP>" & FormatCurrency(Price,2)  & "</td>" & vbCrLf
		        Response.Write "<td NOWRAP>" & rsSeat("OrderType") & "</td>" & vbCrLf


                'Report Column Names - Custom Data Fields  
                '----------------------------------------
                
                For k = 1 to UBound(Question)

                    SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & rsSeat("OrderNumber") & " AND LineNumber = " & rsSeat("LineNumber") & " AND FieldName = 'Answer" & k & "'"
                    Set rsOrderLineDetail = OBJdbConnection.Execute(SQLOrderLineDetail) 
                    
                    If NOT rsOrderLineDetail.EOF Then   
                        
                        If rsOrderLineDetail("FieldValue") = "" OR rsOrderLineDetail("FieldValue") = "0" Then                
                            Response.Write "<td>&nbsp;</td>" & vbCrLf                 
                        Else                
                            Response.Write "<td NOWRAP>" & rsOrderLineDetail("FieldValue") & "&nbsp;&nbsp;&nbsp;</td>" & vbCrLf                        
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