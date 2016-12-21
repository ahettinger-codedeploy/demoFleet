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

<link href='https://fonts.googleapis.com/css?family=Droid+Sans:400,700' rel='stylesheet' type='text/css'>

<style>
#report
{
    margin: auto;
    margin-top: 50px;
    text-align: center;
    border: 1px solid #cbcbcb;
    -webkit-border-radius: 5px;
    -moz-border-radius: 5px;
    border-radius: 5px;
    border-top-left-radius: 5px;
    -webkit-box-shadow: 0 1px 3px 1px rgba(0,0,0,.05);
    -moz-box-shadow: 0 1px 3px 1px rgba(0,0,0,.05);
    box-shadow: 0 1px 3px 1px rgba(0,0,0,.05);
    background-color: #fafafa;
}

#report th 
{
    background: -webkit-linear-gradient(top, #e9eaec 0%,#d4d4d6 100%);
    background: -moz-linear-gradient(top, #e9eaec 0%,#d4d4d6 100%);
    background: -o-linear-gradient(top, #e9eaec 0%,#d4d4d6 100%);
    background: -ms-linear-gradient(top, #e9eaec 0%,#d4d4d6 100%);
    background: linear-gradient(top, #e9eaec 0%,#d4d4d6 100%);
    font-size: 15px;
    white-space: nowrap;
    text-align: left;
    padding-left: 10px;
    padding-right: 10px;
    padding-top: 12px;
    padding-bottom: 12px;
    line-height: 27px;
    border-bottom: 2px solid rgba(0,0,0,.15);
    border-top: 1px solid rgba(255,255,255,.9);
    text-shadow: 0 1px 1px #fff;
    border-top-left-radius:5px;
    border-top-right-radius:5px;
}

#report tr:last-child td 
{
border-bottom: none !important;
}

#report tr:first-child td 
{
    border-top: none !important;
}

#report td:last-child 
{
border-right: none !important;
}

#report td 
{
    border-top: 2px solid #fefefe;
    border-bottom: 1px solid #e0e0e0;
    white-space: nowrap;
    font-size: 12px;
    text-align: left;
    padding-left: 10px;
    padding-right: 10px;
    padding-top: 5px;
    padding-bottom: 5px;
}

#report td:nth-child(even) 
{
    background: -webkit-linear-gradient(top, rgba(255,255,255,0.01) 0%,rgba(0,0,0,.02) 100%);
    background: -moz-linear-gradient(top, rgba(255,255,255,0.01) 0%,rgba(0,0,0,.02) 100%);
    background: -o-linear-gradient(top, rgba(255,255,255,0.01) 0%,rgba(0,0,0,.02) 100%);
    background: -ms-linear-gradient(top, rgba(255,255,255,0.01) 0%,rgba(0,0,0,.02) 100%);
    background: linear-gradient(top, rgba(255,255,255,0.01) 0%,rgba(0,0,0,.02) 100%);
    border-top: none;
    border-bottom: 1px solid rgba(0,0,0,.1);
}
</style>

</head>

<body>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<form action="<%= SurveyFileName %>" method="post" name="Survey">
<input type="hidden" name="FormName" value="ReportCriteria">
	
<% EventListDaysDefault = 30 %>

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

'Report Title
'-------------------
Response.Write "<H4>" & ReportTitle & "</H4>" & vbCrLf

%>

<table border="0" cellpadding="0" cellspacing="0" id="report" width="600px">
<thead>
    <tr>
	    <th>&nbsp;</th>
	    <th>Date/Time</th>
	    <th>Production</th>
	    <th>Attendee Count</th>
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
<%	

    rsTicketsSold.Close
    Set rsTicketsSold = nothing

rsEvents.MoveNext	
Loop

rsEvents.Close
Set rsEvents = nothing

%>
    

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

Response.Buffer = False
Excel = Clean(Request("ExcelOutput"))

If Excel = "Y" Then

	Response.ContentType = "application/vnd.ms-excel"

End If

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & ReportTitle & "</TITLE>" & vbCrLf

%>
<style>
#report
{
    margin: auto;
    margin-top: 50px;
    text-align: center;
    border: 1px solid #cbcbcb;
    -webkit-border-radius: 5px;
    -moz-border-radius: 5px;
    border-radius: 5px;
    border-top-left-radius: 5px;
    -webkit-box-shadow: 0 1px 3px 1px rgba(0,0,0,.05);
    -moz-box-shadow: 0 1px 3px 1px rgba(0,0,0,.05);
    box-shadow: 0 1px 3px 1px rgba(0,0,0,.05);
    background-color: #fafafa;
}

#report th 
{
    background: -webkit-linear-gradient(top, #e9eaec 0%,#d4d4d6 100%);
    background: -moz-linear-gradient(top, #e9eaec 0%,#d4d4d6 100%);
    background: -o-linear-gradient(top, #e9eaec 0%,#d4d4d6 100%);
    background: -ms-linear-gradient(top, #e9eaec 0%,#d4d4d6 100%);
    background: linear-gradient(top, #e9eaec 0%,#d4d4d6 100%);
    font-size: 15px;
    white-space: nowrap;
    text-align: left;
    padding-left: 10px;
    padding-right: 10px;
    padding-top: 12px;
    padding-bottom: 12px;
    line-height: 27px;
    border-bottom: 2px solid rgba(0,0,0,.15);
    border-top: 1px solid rgba(255,255,255,.9);
    text-shadow: 0 1px 1px #fff;
    border-top-left-radius:5px;
    border-top-right-radius:5px;
}

#report tr:last-child td 
{
border-bottom: none !important;
}

#report tr:first-child td 
{
    border-top: none !important;
}

#report td:last-child 
{
border-right: none !important;
}

#report td 
{
    border-top: 2px solid #fefefe;
    border-bottom: 1px solid #e0e0e0;
    white-space: nowrap;
    font-size: 12px;
    text-align: left;
    padding-left: 10px;
    padding-right: 10px;
    padding-top: 5px;
    padding-bottom: 5px;
}

#report td:nth-child(even) 
{
    background: -webkit-linear-gradient(top, rgba(255,255,255,0.01) 0%,rgba(0,0,0,.02) 100%);
    background: -moz-linear-gradient(top, rgba(255,255,255,0.01) 0%,rgba(0,0,0,.02) 100%);
    background: -o-linear-gradient(top, rgba(255,255,255,0.01) 0%,rgba(0,0,0,.02) 100%);
    background: -ms-linear-gradient(top, rgba(255,255,255,0.01) 0%,rgba(0,0,0,.02) 100%);
    background: linear-gradient(top, rgba(255,255,255,0.01) 0%,rgba(0,0,0,.02) 100%);
    border-top: none;
    border-bottom: 1px solid rgba(0,0,0,.1);
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
        Response.Write "<table border=""0"" cellpadding=""0"" cellspacing=""0"" id=""report"">" & vbCrLf
	    Response.Write "<thead>" & vbCrLf
		Response.Write "<tr>" & vbCrLf		
		
		
		'Column Heading Labels
		'---------------------
		
        'Standard Headings
        For j = 1 to UBound(StandardQuestion)
            Response.Write "<th>" & StandardQuestion(j) & "</th>" & vbCrLf
        Next

        'Custom Headings
        SQLSurveyNum = "SELECT SurveyNumber FROM Event (NOLOCK) WHERE Event.EventCode = " & ReportEventCode & ""
        Set rsSurveyNum = OBJdbConnection.Execute(SQLSurveyNum)
            ThisSurveyNum = rsSurveyNum ("SurveyNumber")
        rsSurveyNum.Close
		Set rsSurveyNum = Nothing

        SQLMaxQuestions = "SELECT MAX(QuestionNumber) AS Count FROM SurveyQuestion(NOLOCK) WHERE SurveyNumber = " & ThisSurveyNum & ""
        Set rsMaxQuestions = OBJdbConnection.Execute(SQLMaxQuestions)
		    MaxQuestions = rsMaxQuestions("Count")
		rsMaxQuestions.Close
		Set rsMaxQuestions = Nothing
        
        For k = 1 to MaxQuestions

           SQLSurveyQuestion = "SELECT QuestionText FROM SurveyQuestion(NOLOCK) WHERE SurveyNumber = " & ThisSurveyNum & " AND  SurveyQuestion.QuestionNumber = " & k & ""
           Set rsSurveyQuestion = OBJdbConnection.Execute(SQLSurveyQuestion)
           Response.Write "<td>" & rsSurveyQuestion("QuestionText") & "</td>" & vbCrLf
           rsSurveyQuestion.Close
           Set rsSurveyQuestion = Nothing

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

                SQLMaxQuestions = "SELECT MAX(QuestionNumber) AS Count FROM SurveyQuestion(NOLOCK) WHERE SurveyNumber = " & ThisSurveyNum & ""
                Set rsMaxQuestions = OBJdbConnection.Execute(SQLMaxQuestions)
                MaxQuestions = rsMaxQuestions("Count")
                rsMaxQuestions.Close
                Set rsMaxQuestions = Nothing
                
                For k = 1 to MaxQuestions

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