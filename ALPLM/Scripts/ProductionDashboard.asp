<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<%
Page = "CustomerDetails"

'Check Needed Session Variables
If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then Response.Redirect("/Management/Default.asp")

If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then Response.Redirect("/Management/Default.asp")

FontColor = "#000000"
FontFace = "verdana,arial,helvetica"
HeadingFontColor = "#008400"
TableCategoryBGColor = "#008400"
TableCategoryFontColor = "#FFFFFF"
TableColumnHeadingBGColor = "#99CC99"
TableColumnHeadingFontColor = "#000000"
TableDataBGColor = "#DDDDDD"
TableDataFontColor = "#000000"


If Request("SubmitButton") = "Submit" Then
    Call DisplayReport
Else
    Call ProductionSelection
End If

Sub ProductionSelection
%>
<html>
<head>
<title>Tix - Production Dashboard</title>

<style type="text/css">
<!--
a.sort:link  {color: #FFFFFF; font-weight: bold; text-decoration: underline;}
a.sort:visited  {color: #FFFFFF; font-weight: bold; text-decoration: underline;}
a.sort:active  {color: #FFFFFF; font-weight: bold; text-decoration: underline;}
a.sort:hover  {color: #FFFFFF; font-weight: bold; text-decoration: underline;}
-->
</style>

<%

Response.Write "<SCRIPT LANGUAGE=""JavaScript"">" & vbCrLf
Response.Write "<!-- Hide code from non-js browsers" & vbCrLf

Response.Write "function validateForm(){" & vbCrLf
Response.Write "formObj = document.Report;" & vbCrLf

If DateRangeSelection = True Then
	Response.Write "if(dateRangeCheck(formObj) == false){" & vbCrLf
	Response.Write "return false;" & vbCrLf
	Response.Write "}" & vbCrLf
End If

If EventDateRangeSelection = True Then
	Response.Write "if(eventDateRangeCheck(formObj) == false){" & vbCrLf
	Response.Write "return false;" & vbCrLf
	Response.Write "}" & vbCrLf
End If

'If EventSelection = True Then
'	Response.Write "if(eventSelectedCheck(formObj) == false){" & vbCrLf
'	Response.Write "return false;" & vbCrLf
'	Response.Write "}" & vbCrLf
'End If

Response.Write "}" & vbCrLf

Response.Write "// end hiding -->" & vbCrLf
Response.Write "</SCRIPT>" & vbCrLf

Response.Write "<LINK REL=""stylesheet"" TYPE=""text/css"" HREF=""/Reports/Report.css"">" & vbCrLf

%>

</head>
<body>
<center>

<!--#include virtual="TopNavInclude.asp" -->

<BR>

<BR>

<FONT FACE="verdana,arial,helvetica" COLOR="#008400"><H3>Production Dashboard</H3></FONT>
<FONT FACE="verdana,arial,helvetica" SIZE="2">

<%
'Get all events for Organization

If Request("EventListDays") <> "" Then
    EventListDays = CInt(CleanNumeric(Request("EventListDays")))
Else
    EventListDays = 30
End If        

Select Case Request("SortMethod")
	Case "Venue"
		SQLEvents = "SELECT DISTINCT Act.ActCode, Act, Venue FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE EventDate > GETDATE()-" & EventListDays & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " ORDER BY Venue, Act"
	Case Else
		SQLEvents = "SELECT DISTINCT Act.ActCode, Act, Venue FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE EventDate > GETDATE()-" & EventListDays & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " ORDER BY Act, Venue"
End Select
Set rsEvents = OBJdbConnection.Execute(SQLEvents)

Response.Write "<FORM NAME=""Report"" ACTION=""ProductionDashboard.asp"" METHOD=""post"">" & vbCrLf

Response.Write "<TABLE CELLPADDING=""4"" BORDER=""1"">" & vbCrLf

'REE 8/4/9 - Added Transaction Date Range Selection
If IsDate(Request("ReportStartMonth") & "/" & Request("ReportStartDay") & "/" & Request("ReportStartYear")) And IsDate(Request("ReportEndMonth") & "/" & Request("ReportEndDay") & "/" & Request("ReportEndYear")) Then
    DefaultStartDate = Request("ReportStartMonth") & "/" & Request("ReportStartDay") & "/" & Request("ReportStartYear")
    DefaultEndDate = Request("ReportEndMonth") & "/" & Request("ReportEndDay") & "/" & Request("ReportEndYear")
Else
    DefaultStartDate = "1/1/2001"
    DefaultEndDate = Date()
End If    

Response.Write "<TR><TD COLSPAN=""3"">" & vbCrLf
%>
	<!--#INCLUDE VIRTUAL="/Reports/DateRangeSelectionInclude.asp" -->
<%
Response.Write "</TD></TR>" & vbCrLf

'REE 8/4/9 - Added Event Date Range Selection
If IsDate(Request("ReportEventStartMonth") & "/" & Request("ReportEventStartDay") & "/" & Request("ReportEventStartYear")) And IsDate(Request("ReportEventEndMonth") & "/" & Request("ReportEventEndDay") & "/" & Request("ReportEventEndYear")) Then
    DefaultStartDate = Request("ReportEventStartMonth") & "/" & Request("ReportEventStartDay") & "/" & Request("ReportEventStartYear")
    DefaultEndDate = Request("ReportEventEndMonth") & "/" & Request("ReportEventEndDay") & "/" & Request("ReportEventEndYear")
Else
    DefaultStartDate = "1/1/2001"
    DefaultEndDate = Date()

    SQLMinMaxEventDate = "SELECT MIN(Event.EventDate) AS MinDate, MAX(Event.EventDate) AS MaxDate FROM vOrgEvent (NOLOCK) INNER JOIN Event (NOLOCK) ON vOrgEvent.EventCode = Event.EventCode WHERE vOrgEvent.OrganizationNumber = " & Session("OrganizationNumber")
    Set rsMinMaxEventDate = OBJdbConnection.Execute(SQLMinMaxEventDate)

    If Not rsMinMaxEventDate.EOF Then
        DefaultStartDate = rsMinMaxEventDate("MinDate")
        DefaultEndDate = rsMinMaxEventDate("MaxDate")
    End If

    rsMinMaxEventDate.Close
    Set rsMinMaxEventDate = nothing
End If    

Response.Write "<TR><TD COLSPAN=""3"">" & vbCrLf
%>
	<!--#INCLUDE VIRTUAL="/Reports/EventDateRangeSelectionInclude.asp" -->
<%
Response.Write "</TD></TR>" & vbCrLf

Response.Write "<TR><TD COLSPAN=""3"" CLASS=""SectionHeading""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">Show Past Productions From "
Response.Write "<SELECT NAME=""EventListDays"" onchange='javascript:document.Report.submit();'>" & vbCrLf
EventListDayArray = Array(0, 30, 90, 180, 365, 7300)
For i = 0 To 5
    If CInt(EventListDays) = EventListDayArray(i) Then
        Selected = "SELECTED "
    Else
        Selected = ""
    End If
    
    Select Case i
        Case 0
            EventListDayDesc = "Future Only"
        Case 5
            EventListDayDesc = "All"
        Case Else
            EventListDayDesc = EventListDayArray(i) & " Days Ago"
    End Select
    
    Response.Write "<OPTION " & Selected & "VALUE=""" & EventListDayArray(i) & """>" & EventListDayDesc & "</OPTION>" & vbCrLf
Next

Response.Write "</SELECT>&nbsp;&nbsp;<INPUT TYPE=""submit"" NAME=""ProductionList"" VALUE=""Update Production List""></FONT></TD></TR>" & vbCrLf

Response.Write "<TR BGCOLOR=""#008400""><TD ALIGN=center CLASS=""ColumnHeading""><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><B>Select</B></FONT></TD><TD ALIGN=center CLASS=""ColumnHeading""><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2 CLASS=""ColumnHeading""><A class=sort HREF=SalesbyProductionReport.asp?SortMethod=Act&EventListDays=" & EventListDays & ">Production</A></FONT></TD><TD ALIGN=center CLASS=""ColumnHeading""><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><A class=sort HREF=SalesbyProductionReport.asp?SortMethod=Venue&EventListDays=" & EventListDays & ">Venue</A></FONT></TD></TR>" & vbCrLf

Do Until rsEvents.EOF

	Response.Write "<TR BGCOLOR=""#DDDDDD""><TD ALIGN=""center""><INPUT TYPE=""checkbox"" NAME=""ActCode"" VALUE=""" & rsEvents("ActCode") & """></TD><TD><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsEvents("Act") & "</FONT></TD><TD><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsEvents("Venue") & "</FONT></TD></TR>" & vbCrLf
	rsEvents.MoveNext
	
Loop

rsEvents.Close
Set rsEvents = nothing

Response.Write "</TABLE><BR>" & vbCrLf

Response.Write "<INPUT TYPE=""submit"" VALUE=""Submit""></FORM>" & vbCrLf

%>

</FONT>

</CENTER>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>


<%

End Sub 'ProductionSelection

Sub DisplayReport        

%>
<HTML>
<HEAD>
<title>Tix - Production Dashboard</title>
</HEAD>
<BODY BGCOLOR=#FFFFFF>

<!--#include virtual="TopNavInclude.asp"-->


<%

TransactionStartDate = CDate(Request("ReportStartDate"))
TransactionEndDate = CDate(Request("ReportEndDate"))

EventStartDate = CDate(Request("ReportEventStartDate"))
EventEndDate = CDate(Request("ReportEventEndDate"))

ActCode = CleanNumeric(Request("ActCode"))
Session("ReturnToPage") = "/Reports/ProductionDashboard.asp?ActCode=" & ActCode

Call DBOpen(OBJdbConnection2)

SQLAct = "SELECT Act.ActCode, MIN(Event.EventDate) As FirstEventDate, MAX(Event.EventDate) AS LastEventDate, Act.Act FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode AND OrganizationAct.OrganizationNumber = OrganizationVenue.OrganizationNumber WHERE Event.ActCode = " & ActCode & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " GROUP BY Act.ActCode, Act.Act"
Set rsAct = OBJdbConnection.Execute(SQLAct)

If Not rsAct.EOF Then 'There is a matching Act

	Response.Write "<br /><FONT FACE=verdana,arial,helvetica COLOR=#008400 SIZE=2><H3>Production Dashboard</H3></FONT>" & vbCrLf

	Response.Write "<TABLE CELLPADDING=""0"" CELLSPACING=""10"" WIDTH=""740"" BORDER=""0""><TR>" & vbCrLf
	
	'Begin Left Column
	Response.Write "<TD VALIGN=""top"" ALIGN=""left"">" & vbCrLf
	
	'Production Information Pad
	Response.Write "<TABLE CELLPADDING=""0"" CELLSPACING=""0"" WIDTH=""100%""><TR><TD BACKGROUND=""/clients/Tix/Images/PadHeaderBG.gif"" WIDTH=""10"" ALIGN=""left""><IMG SRC=""/clients/Tix/Images/PadHeaderLeftCorner.gif""></TD><TD BACKGROUND=""/clients/Tix/Images/PadHeaderBG.gif"" ALIGN=""center""><FONT COLOR=""#FFFFFF"" SIZE=""2""><B>Production Information</B></FONT></TD><TD BACKGROUND=""/clients/Tix/Images/PadHeaderBG.gif"" WIDTH=""10"" ALIGN=""right""><IMG SRC=""/clients/tix/images/padheaderrightcorner.gif""></TD></TR>" & vbCrLf

	Response.Write "<TR BGCOLOR=""#E8C63E""><TD><IMG SRC=""/images/clear.gif"" WIDTH=""1"" HEIGHT=""1""></TD>"
	Response.Write "<TD ALIGN=""left""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & vbCrLf
	Response.Write "<B>" & rsAct("Act") & "</B><br />" & vbCrLf
	
	Response.Write "From: " & WeekdayName(Weekday(rsAct("FirstEventDate"))) & " " & FormatDateTime(rsAct("FirstEventDate"), vbShortDate) & "<br />" & vbCrLf
	Response.Write "Through: " & WeekdayName(Weekday(rsAct("LastEventDate"))) & " " & FormatDateTime(rsAct("LastEventDate"), vbShortDate) & "<br />" & vbCrLf

    Response.Write "Production Code: " & rsAct("ActCode") & "<br />" & vbCrLf
		
	Response.Write "</FONT></TD>" & vbCrLf

	Response.Write "<TD><IMG SRC=""/images/clear.gif"" WIDTH=""1"" HEIGHT=""1""></TD></TR>" & vbCrLf

	Response.Write "<TR><TD><IMG SRC=""/Clients/Tix/Images/gfx_cornerYellow_BL.gif""></TD><TD BGCOLOR=""#E8C63E""><IMG SRC=""/images/clear.gif"" WIDTH=""1"" HEIGHT=""1""></TD><TD><IMG SRC=""/Clients/Tix/Images/gfx_cornerYellow_BR.gif""></TD></TR>" & vbCrLf

	Response.Write "</TABLE>" & vbCrLf
	
	'End Production Information Pad
	
	Response.Write "<br />" & vbCrLf
	
	'Begin Revenue Pad
	
	Response.Write "<TABLE CELLPADDING=""0"" CELLSPACING=""0"" WIDTH=""100%""><TR><TD BACKGROUND=""/clients/Tix/Images/PadHeaderBG.gif"" WIDTH=""10"" ALIGN=""left""><IMG SRC=""/clients/Tix/Images/PadHeaderLeftCorner.gif""></TD><TD BACKGROUND=""/clients/Tix/Images/PadHeaderBG.gif"" ALIGN=""center""><FONT COLOR=""#FFFFFF"" SIZE=""2""><B>Ticket Sales Revenue</B></FONT></TD><TD BACKGROUND=""/clients/Tix/Images/PadHeaderBG.gif"" WIDTH=""10"" ALIGN=""right""><IMG SRC=""/clients/tix/images/padheaderrightcorner.gif""></TD></TR>" & vbCrLf

	Response.Write "<TR BGCOLOR=""#C5E2CE""><TD><IMG SRC=""/images/clear.gif"" WIDTH=""1"" HEIGHT=""1""></TD>"
	Response.Write "<TD ALIGN=""left""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & vbCrLf

	SQLSales = "SELECT ISNULL(SUM(OrderLine.Price), 0) AS FaceValue, ISNULL(SUM(OrderLine.Surcharge), 0) AS ServiceFees, ISNULL(SUM(OrderLine.Discount), 0) AS Discount FROM Seat (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode AND OrganizationVenue.OrganizationNumber = OrganizationAct.OrganizationNumber WHERE Event.ActCode = " & ActCode & " AND Seat.StatusCode = 'S' AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber")
	Set rsSales = OBJdbConnection2.Execute(SQLSales)
	
    Response.Write "<table>"
    
    Response.Write "<tr><td align=""right""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">Face Value: </FONT></td><td align=""right""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & FormatCurrency(rsSales("FaceValue")) & "</FONT></td></tr>" & vbCrLf
    Response.Write "<tr><td align=""right""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">Customer Fees: </FONT></td><td align=""right""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & FormatCurrency(rsSales("ServiceFees")) & "</FONT></td></tr>" & vbCrLf
    Response.Write "<tr><td align=""right""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">Discounts: </FONT></td><td align=""right""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">(" & FormatCurrency(rsSales("Discount")) & ")</FONT></td></tr>" & vbCrLf
    Response.Write "<tr><td>&nbsp;</td><td><hr /></td></tr>" & vbCrLf
    Response.Write "<tr><td align=""right""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">Net Revenue: </FONT></td><td align=""right""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & FormatCurrency(rsSales("FaceValue") + rsSales("ServiceFees") - rsSales("Discount")) & "</FONT></td></tr>" & vbCrLf
    
    rsSales.Close
    Set rsSales = nothing
    
	Response.Write "</table>"
	
	Response.Write "</FONT></TD>" & vbCrLf
	
	Response.Write "<TD><IMG SRC=""/images/clear.gif"" WIDTH=""1"" HEIGHT=""1""></TD></TR>" & vbCrLf

	Response.Write "<TR><TD><IMG SRC=""/Clients/Tix/Images/gfx_cornerTS_BL.gif""></TD><TD BGCOLOR=""#C5E2CE""><IMG SRC=""/images/clear.gif"" WIDTH=""1"" HEIGHT=""1""></TD><TD><IMG SRC=""/Clients/Tix/Images/gfx_cornerTS_BR.gif""></TD></TR>" & vbCrLf

	Response.Write "</TABLE>" & vbCrLf
	
	'End Revenue Pad

	Response.Write "</TD>" & vbCrLf
	
	'End Left Column
	
	'Begin Right Column
	
	Response.Write "<TD VALIGN=""top"" ALIGN=""left"">"
	
	Response.Write "<TABLE CELLPADDING=""0"" CELLSPACING=""0""><TR><TD>"

	'Begin Ticket Status Pad
	Response.Write "<TABLE CELLPADDING=""0"" CELLSPACING=""0"" WIDTH=""100%""><TR><TD BACKGROUND=""/clients/Tix/Images/PadHeaderBG.gif"" WIDTH=""10"" ALIGN=""left""><IMG SRC=""/clients/Tix/Images/PadHeaderLeftCorner.gif""></TD><TD BACKGROUND=""/clients/Tix/Images/PadHeaderBG.gif"" ALIGN=""center""><FONT COLOR=""#FFFFFF"" SIZE=""2""><B>Ticket Status</B></FONT></TD><TD BACKGROUND=""/clients/Tix/Images/PadHeaderBG.gif"" WIDTH=""10"" ALIGN=""right""><IMG SRC=""/clients/tix/images/padheaderrightcorner.gif""></TD></TR>" & vbCrLf

	Response.Write "<TR BGCOLOR=""#C5E2CE""><TD><IMG SRC=""/images/clear.gif"" WIDTH=""1"" HEIGHT=""1""></TD>"
	Response.Write "<TD ALIGN=""left""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & vbCrLf

    SQLSales = "SELECT Seat.StatusCode, COUNT(*) AS Count FROM Seat (NOLOCK) INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode AND OrganizationVenue.OrganizationNumber = OrganizationAct.OrganizationNumber WHERE Event.ActCode = " & ActCode & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " GROUP BY Seat.StatusCode"
    Set rsSales = OBJdbConnection2.Execute(SQLSales)
    
    Do Until rsSales.EOF
        Select Case rsSales("StatusCode")
            Case "A"
                AvailableQty = rsSales("Count")
            Case "H"
                HeldQty = rsSales("Count")
            Case "R"
                ReservedQty = rsSales("Count")
            Case "S"
                SoldQty = rsSales("Count")
        End Select
        
        rsSales.MoveNext
    Loop
    
    rsSales.Close
    Set rsSales = nothing
    
    'Response.Write "<br />" & vbCrLf
    'Response.Write "<table cellpadding=""0"" cellspacing=""0"">"
    Response.Write "<table>"
    
    TotalQty = AvailableQty + HeldQty + ReservedQty + SoldQty
    Response.Write "<tr><td align=""right""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">Available: </FONT></td><td align=""right""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & FormatNumber(AvailableQty, 0) & "</FONT></td><td align=""right""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & FormatNumber((AvailableQty/TotalQty) * 100, 2) & "%</FONT></td></tr>" & vbCrLf
    Response.Write "<tr><td align=""right""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">Held: </FONT></td><td align=""right""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & FormatNumber(HeldQty, 0) & "</FONT></td><td align=""right""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & FormatNumber((HeldQty/TotalQty) * 100, 2) & "%</FONT></td></tr>" & vbCrLf
    Response.Write "<tr><td align=""right""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">Reserved: </FONT></td><td align=""right""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & FormatNumber(ReservedQty, 0) & "</FONT></td><td align=""right""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & FormatNumber((ReservedQty/TotalQty) * 100, 2) & "%</FONT></td></tr>" & vbCrLf
    Response.Write "<tr><td align=""right""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">Sold: </FONT></td><td align=""right""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & FormatNumber(SoldQty, 0) & "</FONT></td><td align=""right""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & FormatNumber((SoldQty/TotalQty) * 100, 2) & "%</FONT></td></tr>" & vbCrLf
    Response.Write "<tr><td>&nbsp;</td><td colspan=""2""><hr /></td></tr>" & vbCrLf
	Response.Write "<tr><td align=""right""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">Total: </FONT></td><td align=""right""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & FormatNumber(TotalQty, 0) & "</FONT><td align=""right""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & FormatNumber((TotalQty/TotalQty) * 100, 2) & "%</FONT></td></tr>" & vbCrLf
	
	Response.Write "</table>"
	
	Response.Write "</FONT></TD>" & vbCrLf
	
	Response.Write "<TD><IMG SRC=""/images/clear.gif"" WIDTH=""1"" HEIGHT=""1""></TD></TR>" & vbCrLf

	Response.Write "<TR><TD><IMG SRC=""/Clients/Tix/Images/gfx_cornerTS_BL.gif""></TD><TD BGCOLOR=""#C5E2CE""><IMG SRC=""/images/clear.gif"" WIDTH=""1"" HEIGHT=""1""></TD><TD><IMG SRC=""/Clients/Tix/Images/gfx_cornerTS_BR.gif""></TD></TR>" & vbCrLf

	Response.Write "</TABLE>" & vbCrLf
	
	Response.Write "</TD>"
	
	'End Ticket Status Pad
	
	'Begin Ticket Status Chart
		
	Response.Write "<TD>" & vbCrLf
	
	Response.Write "<IMG SRC=""ProductionSalesChart.asp?ChartImage=Y&ActCode=" & ActCode & """><br />" & vbCrLf

	Response.Write "</TD></TR>" & vbCrLf
	
	'End Ticket Status Chart

	Response.Write "<TR><TD>&nbsp;</TD></TR>" & vbCrLf

	'Begin OrderType Pad

	Response.Write "<TR><TD>" & vbCrLf
	
	Response.Write "<TABLE CELLPADDING=""0"" CELLSPACING=""0"" WIDTH=""100%""><TR><TD BACKGROUND=""/clients/Tix/Images/PadHeaderBG.gif"" WIDTH=""10"" ALIGN=""left""><IMG SRC=""/clients/Tix/Images/PadHeaderLeftCorner.gif""></TD><TD BACKGROUND=""/clients/Tix/Images/PadHeaderBG.gif"" ALIGN=""center""><FONT COLOR=""#FFFFFF"" SIZE=""2""><B>Sales By Order Type</B></FONT></TD><TD BACKGROUND=""/clients/Tix/Images/PadHeaderBG.gif"" WIDTH=""10"" ALIGN=""right""><IMG SRC=""/clients/tix/images/padheaderrightcorner.gif""></TD></TR>" & vbCrLf

	Response.Write "<TR BGCOLOR=""#C5E2CE""><TD><IMG SRC=""/images/clear.gif"" WIDTH=""1"" HEIGHT=""1""></TD>"
	Response.Write "<TD ALIGN=""left""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & vbCrLf

	SQLSales = "SELECT OrderType.OrderType, COUNT(*) AS Count FROM OrderHeader (NOLOCK) INNER JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber INNER JOIN Seat (NOLOCK) ON OrderHeader.OrderNumber = Seat.OrderNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode AND OrganizationVenue.OrganizationNumber = OrganizationAct.OrganizationNumber WHERE Event.ActCode = " & ActCode & " AND Seat.StatusCode = 'S' AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " GROUP BY OrderType.OrderType ORDER BY OrderType.OrderType"
	Set rsSales = OBJdbConnection2.Execute(SQLSales)
	
    Response.Write "<table>"
    
    Do Until rsSales.EOF
        Response.Write "<tr><td align=""right""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsSales("OrderType") & ": </FONT></td><td align=""right""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & FormatNumber(rsSales("Count"), 0) & "</FONT></td><td align=""right""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & FormatNumber((rsSales("Count")/SoldQty) * 100, 2) & "%</FONT></td></tr>" & vbCrLf
        
        rsSales.MoveNext
    Loop
    
    rsSales.Close
    Set rsSales = nothing
    
    If SoldQty > 0 Then
        Response.Write "<tr><td>&nbsp;</td><td colspan=""2""><hr /></td></tr>" & vbCrLf
	    Response.Write "<tr><td align=""right""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">Total: </FONT></td><td align=""right""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & FormatNumber(SoldQty, 0) & "</FONT></td><td align=""right""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & FormatNumber((SoldQty/SoldQty) * 100, 2) & "%</FONT></td></tr>" & vbCrLf
    Else
        Response.Write "<tr><td align=""center"" colspan=""3""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">No Sales</FONT></td></tr>" & vbCrLf
    End If	

	Response.Write "</table>"
	
	Response.Write "</FONT></TD>" & vbCrLf
	
	Response.Write "<TD><IMG SRC=""/images/clear.gif"" WIDTH=""1"" HEIGHT=""1""></TD></TR>" & vbCrLf

	Response.Write "<TR><TD><IMG SRC=""/Clients/Tix/Images/gfx_cornerTS_BL.gif""></TD><TD BGCOLOR=""#C5E2CE""><IMG SRC=""/images/clear.gif"" WIDTH=""1"" HEIGHT=""1""></TD><TD><IMG SRC=""/Clients/Tix/Images/gfx_cornerTS_BR.gif""></TD></TR>" & vbCrLf

	Response.Write "</TABLE>" & vbCrLf
	
	Response.Write "</TD>" & vbCrLf
	
	'End Order Type Pad
	
	'Begin Order Type Chart
		
	Response.Write "<TD>" & vbCrLf

	Response.Write "<IMG SRC=""ProductionOrderTypeChart.asp?ChartImage=Y&ActCode=" & ActCode & """><br />" & vbCrLf
	
    Response.Write "</TD></TR>" & vbCrLf
    
    'End Order Type Chart

	Response.Write "<TR><TD>&nbsp;</TD></TR>" & vbCrLf
	
	'Begin Ticket Type Pad

	Response.Write "<TR><TD>" & vbCrLf
	
	Response.Write "<TABLE CELLPADDING=""0"" CELLSPACING=""0"" WIDTH=""100%""><TR><TD BACKGROUND=""/clients/Tix/Images/PadHeaderBG.gif"" WIDTH=""10"" ALIGN=""left""><IMG SRC=""/clients/Tix/Images/PadHeaderLeftCorner.gif""></TD><TD BACKGROUND=""/clients/Tix/Images/PadHeaderBG.gif"" ALIGN=""center""><FONT COLOR=""#FFFFFF"" SIZE=""2""><B>Sales By Ticket Type</B></FONT></TD><TD BACKGROUND=""/clients/Tix/Images/PadHeaderBG.gif"" WIDTH=""10"" ALIGN=""right""><IMG SRC=""/clients/tix/images/padheaderrightcorner.gif""></TD></TR>" & vbCrLf

	Response.Write "<TR BGCOLOR=""#C5E2CE""><TD><IMG SRC=""/images/clear.gif"" WIDTH=""1"" HEIGHT=""1""></TD>"
	Response.Write "<TD ALIGN=""left""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & vbCrLf

	SQLSales = "SELECT SeatType.SeatType, COUNT(*) AS Count FROM Seat (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode AND OrganizationVenue.OrganizationNumber = OrganizationAct.OrganizationNumber WHERE Event.ActCode = " & ActCode & " AND Seat.StatusCode = 'S' AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " GROUP BY SeatType.SeatType ORDER BY SeatType.SeatType"
	Set rsSales = OBJdbConnection2.Execute(SQLSales)
	
    Response.Write "<table>"
    
    Do Until rsSales.EOF
        Response.Write "<tr><td align=""right""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsSales("SeatType") & ": </FONT></td><td align=""right""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & FormatNumber(rsSales("Count"), 0) & "</FONT></td><td align=""right""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & FormatNumber((rsSales("Count")/SoldQty) * 100, 2) & "%</FONT></td></tr>" & vbCrLf
        
        rsSales.MoveNext
    Loop
    
    rsSales.Close
    Set rsSales = nothing
    
    If SoldQty > 0 Then
        Response.Write "<tr><td>&nbsp;</td><td colspan=""2""><hr /></td></tr>" & vbCrLf
	    Response.Write "<tr><td align=""right""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">Total: </FONT></td><td align=""right""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & FormatNumber(SoldQty, 0) & "</FONT></td><td align=""right""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & FormatNumber((SoldQty/SoldQty) * 100, 2) & "%</FONT></td></tr>" & vbCrLf
    Else
        Response.Write "<tr><td align=""center"" colspan=""3""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">No Sales</FONT></td></tr>" & vbCrLf
	End If
	
	Response.Write "</table>"
	
	Response.Write "</FONT></TD>" & vbCrLf
	
	Response.Write "<TD><IMG SRC=""/images/clear.gif"" WIDTH=""1"" HEIGHT=""1""></TD></TR>" & vbCrLf

	Response.Write "<TR><TD><IMG SRC=""/Clients/Tix/Images/gfx_cornerTS_BL.gif""></TD><TD BGCOLOR=""#C5E2CE""><IMG SRC=""/images/clear.gif"" WIDTH=""1"" HEIGHT=""1""></TD><TD><IMG SRC=""/Clients/Tix/Images/gfx_cornerTS_BR.gif""></TD></TR>" & vbCrLf

	Response.Write "</TABLE>" & vbCrLf
	
	Response.Write "</TD>" & vbCrLf
	
	'End Ticket Type Pad
	
	'Begin Ticket Type Chart
		
	Response.Write "<TD>" & vbCrLf

	Response.Write "<IMG SRC=""ProductionTicketTypeChart.asp?ChartImage=Y&ActCode=" & ActCode & """><br />" & vbCrLf
	
    Response.Write "</TD></TR>" & vbCrLf
    
    'End Ticket Type Chart
    
    Response.Write "</TABLE>" & vbCrLf

    Response.Write "</TD></TR>" & vbCrLf
	
	Response.Write "</TABLE>" & vbCrLf	

	'End Right Column
	
	Response.Write "<IMG SRC=""DailyProductionSalesChart.asp?ChartImage=Y&ActCode=" & ActCode & """><br /><br />" & vbCrLf
	
	Response.Write "<IMG SRC=""WeeklyProductionSalesChart.asp?ChartImage=Y&ActCode=" & ActCode & """><br />" & vbCrLf

	'Total Revenue
	'Face Value
	'Customer Fees
	'Discounts
	
	'Date Entered
	'Entered By
	'Last Modified
	'Modified By
	
	'Stats
	'Sales by week (bar chart)
	'Sales by ticket type

If 1 = 2 Then

	'Begin Order History Pad

	Response.Write "<TABLE CELLPADDING=""0"" CELLSPACING=""0"" WIDTH=""740""><TR><TD BACKGROUND=""/clients/Tix/Images/PadHeaderBG.gif"" WIDTH=""10"" ALIGN=""left""><IMG SRC=""/clients/Tix/Images/PadHeaderLeftCorner.gif""></TD><TD BACKGROUND=""/clients/Tix/Images/PadHeaderBG.gif"" ALIGN=""center""><FONT COLOR=""#FFFFFF"" SIZE=""2""><B>Order History</B></FONT></TD><TD BACKGROUND=""/clients/Tix/Images/PadHeaderBG.gif"" WIDTH=""10"" ALIGN=""right""><IMG SRC=""/clients/tix/images/padheaderrightcorner.gif""></TD></TR>" & vbCrLf

	Response.Write "<TR BGCOLOR=""#C5E2CE""><TD><IMG SRC=""/images/clear.gif"" WIDTH=""1"" HEIGHT=""1""></TD>"
	Response.Write "<TD ALIGN=""left""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2""><br />" & vbCrLf
	
	Response.Write "</FONT></TD>" & vbCrLf
		
	Response.Write "<TD><IMG SRC=""/images/clear.gif"" WIDTH=""1"" HEIGHT=""1""></TD></TR>" & vbCrLf

	Response.Write "<TR><TD><IMG SRC=""/Clients/Tix/Images/gfx_cornerTS_BL.gif""></TD><TD BGCOLOR=""#C5E2CE""><IMG SRC=""/images/clear.gif"" WIDTH=""1"" HEIGHT=""1""></TD><TD><IMG SRC=""/Clients/Tix/Images/gfx_cornerTS_BR.gif""></TD></TR>" & vbCrLf

	Response.Write "</TABLE>" & vbCrLf

End If	

Else 'There is no matching event
	Response.Write "<br /><FONT FACE=verdana,arial,helvetica COLOR=#008400 SIZE=2><H3>Production Dashboard</H3></FONT>" & vbCrLf
	Response.Write "<br /><br /><FONT FACE=verdana,arial,helvetica SIZE=2>Production Not Found</FONT><br /><br />" & vbCrLf
End If

Response.Write "<FORM ACTION=""ProductionDashboard.asp?EventListDays=" & CInt(CleanNumeric(Request("EventListDays"))) & """ METHOD=""post""><INPUT TYPE=""submit"" VALUE=""Return To Listing""></FORM>" & vbCrLf
%>

<!--#INCLUDE VIRTUAL="FooterInclude.asp"-->

</BODY>
</HTML>

<%
End Sub 'EventSelection
%>

