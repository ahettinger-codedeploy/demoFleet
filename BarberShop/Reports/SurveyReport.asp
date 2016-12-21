<%

'SSR - 6/20/2012 - Updated report for use with UA HRC

'Update Number 13 - 1/20/2012
'SSR 1/20/2012 - Added the patron's email address to the report - SSR

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
ReportFileName = "SurveyReport.asp"
SurveyReportNumber = 600
ReportTitle = "Survey Report"

'============================================================

'Saugatuck Center for the Arts

'CSS Survey Variables

    TableCategoryBGColor = "#e5c43d"
    TableCategoryFontColor = "#000000"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "#000000"
    TableDataBGColor = "#ffffff"

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
html, body, form, fieldset, h1, h2, h3, h4, h5, h6, p, pre, blockquote, ul, ol, dl, address 
{
	margin:0;
	padding:0;
}
body 
{
	background: #fff url(graphics/bg-body.gif) repeat-x;
	font:76%/160% "Trebuchet MS",Verdana,Arial,Helvetica,sans-serif;
	}
p 
{
	text-align:center;
	}	
a:link 
{
	color:#d42945;
	text-decoration:none;
	border-bottom:1px dotted #ffbac8;
	}	
a:visited 
{
	color:#d42945;
	border-bottom:none;
	text-decoration:none;
	}		
a:hover,
a:focus 
{
	color:#f03b58;
	border-bottom:1px solid #f03b58;
	text-decoration:none;
	}
table a,
table a:link,
table a:visited 
{
	border:none;
	}							
	
img {
	border:0;
	margin-top:.5em;
	}	
table {
	width:90%;
	border-top:1px solid #e5eff8;
	border-right:1px solid #e5eff8;
	margin:1em auto;
		border-collapse:collapse;
	}
caption {
	color: #9ba9b4;
	font-size:.94em;
		letter-spacing:.1em;
		margin:1em 0 0 0;
		padding:0;
		caption-side:top;
		text-align:center;
	}	
tr.odd td	{
	background:#f7fbff
	}
tr.odd .column1	{
	background:#f4f9fe;
	}	
.column1	{
	background:#f9fcfe;
	}
td {
	color:#678197;
	border-bottom:1px solid #e5eff8;
	border-left:1px solid #e5eff8;
	padding:.3em 1em;
	text-align:center;
	}				
th {
	font-weight:normal;
	color: #678197;
	text-align:left;
	border-bottom: 1px solid #e5eff8;
	border-left:1px solid #e5eff8;
	padding:.3em 1em;
	}							
thead th {
	background:#f4f9fe;
	text-align:center;
	font:bold 1.2em/2em "Century Gothic","Trebuchet MS",Arial,Helvetica,sans-serif;
	color:#66a3d3
	}	
tfoot th {
	text-align:center;
	background:#f4f9fe;
	}	
tfoot th strong {
	font:bold 1.2em "Century Gothic","Trebuchet MS",Arial,Helvetica,sans-serif;
	margin:.5em .5em .5em 0;
	color:#66a3d3;
		}		
tfoot th em {
	color:#f03b58;
	font-weight: bold;
	font-size: 1.1em;
	font-style: normal;
	}	
</style>
</head>

<body>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<form action="<%= SurveyFileName %>" method="post" name="Survey">
<input type="hidden" name="FormName" value="ReportCriteria">
	
<% EventListDaysDefault = 30 %>

<fieldset style="width: 600px;" class="reportCriteriaField">

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

<table summary="surveypage" border="0">
<thead>
    <tr>
	    <th scope="col" >&nbsp;</th>
	    <th scope="col" >Date/Time</th>
	    <th scope="col" >Production</th>
	    <th scope="col" >Attendee Count</th>
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
        <TD><INPUT TYPE="radio" NAME="ReportEventCode" VALUE=<%=rsEvents("EventCode")%>></TD>
        <TD NOWRAP><%=DateAndTimeFormat(rsEvents("EventDate"))%></TD>
        <TD><%=rsEvents("Act")%></TD>
        <TD NOWRAP><%=rsTicketsSold("Count")%></TD>
    </TR>
    <tr>
      <TD colspan="4"><hr /></TD>
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

Dim CustomQuestion(9)
CustomQuestion(1) = "Rider Name"
CustomQuestion(2) = "Rider Cell"
CustomQuestion(3) = "Rider Email"
CustomQuestion(4) = "Rider CWID"
CustomQuestion(5) = "Airline"
CustomQuestion(6) = "Flight #"
CustomQuestion(7) = "Departure/Arrival Time"
CustomQuestion(8) = "Number of bags"
CustomQuestion(9) = "Other items"

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
padding-top: 5px;
padding-bottom: 5px;
padding-left: 0px;
padding-right: 10px;
font-size: 10px;
font-weight: 400;
text-align: left;
color: <%=TableCategoryFontColor%>;
background: <%=TableCategoryBGColor%>;
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

                    SQLSurveyInfo = "SELECT Question, Answer FROM SurveyAnswers (NOLOCK) LEFT JOIN SurveyQuestion (NOLOCK) ON SurveyAnswers.SurveyNumber = SurveyQuestion.SurveyNumber AND SurveyAnswers.AnswerNumber = SurveyQuestion.QuestionNumber  WHERE OrderNumber = " & rsSeat("OrderNumber") & " AND AnswerNumber = " & k & " AND QuestionNumber IS NOT NULL"
		            Set rsSurveyInfo = OBJdbConnection.Execute(SQLSurveyInfo)
                    
                    If NOT rsSurveyInfo.EOF Then   
                        
                        If rsSurveyInfo("Answer") = "" OR rsSurveyInfo("Answer") = "0" Then                
                            Response.Write "<td>&nbsp;</td>" & vbCrLf                 
                        Else                
                            Response.Write "<td>" & rsSurveyInfo("Answer") & "&nbsp;&nbsp;&nbsp;</td>" & vbCrLf                        
                        End If 
                               
                    Else   
                    
                        Response.Write "<td>&nbsp;</td>" & vbCrLf   
                        
                    End If    
                    
                    rsSurveyInfo.Close
                    Set rsSurveyInfo = nothing

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