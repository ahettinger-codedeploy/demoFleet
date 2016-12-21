<%

'CHANGE LOG - Inception
'SSR (8/30/2011)
'Custom Survey

%>

<!--#include virtual="GlobalInclude.asp"-->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="/include/managementinclude.asp"-->

<%

'===============================================

Page = "Management"
ReportFileName = "ClassRegistrationReport.asp"
SurveyReportNumber = 676
ReportTitle = "Attendee Report<BR>Survey No 676"

'============================================================

'CSS Survey Variables

    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "FFFFFF"
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
	padding-top: 10px;
    padding-bottom: 10px;
    padding-left: 10px;
    padding-right: 10px;
	font-size: 15px;
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


<FONT FACE=verdana,arial,helvetica COLOR=#008400><H3><%=ReportTitle%></H3></FONT>
<FONT FACE=verdana,arial,helvetica SIZE=2>
	
<%
EventListDaysDefault = 30
%>
<fieldset style="width: 600px;" class="reportCriteriaField">
    <legend class="reportCriteriaFieldTitle">Event Selection</legend>

    <!--#INCLUDE VIRTUAL="/Include/EventListDayInclude.asp" -->
    
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



SQLEvents = "SELECT Event.EventCode, Act, Venue, EventDate, SurveyNumber FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE EventDate > GETDATE()-" & ArchiveDays & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND Event.SurveyNumber = " & SurveyReportNumber & " ORDER BY EventDate, Act"
Set rsEvents = OBJdbConnection.Execute(SQLEvents)

%>

<table id="rounded-corner" summary="surveypage" border="0">
<thead>
    <tr>
	    <th scope="col" class="category-left">&nbsp;</th>
	    <th scope="col" class="category">&nbsp;</th>
	    <th scope="col" class="category">Date/Time</th>
	    <th scope="col" class="category">Production</th>
	    <th scope="col" class="category">Venue</th>
	    <th scope="col" class="category-right">&nbsp;</th>
    </tr>        
</thead>
<tbody>

<%

Do Until rsEvents.EOF

%>

<TR>
    <TD class="data">&nbsp;</TD>
    <TD class="data"><INPUT TYPE="radio" NAME="ReportEventCode" VALUE=<%=rsEvents("EventCode")%>></TD>
    <TD class="data" NOWRAP><%=DateAndTimeFormat(rsEvents("EventDate"))%></TD>
    <TD class="data"><%=rsEvents("Act")%></TD>
    <TD class="data" NOWRAP><%=rsEvents("Venue")%></TD>
    <TD class="data" NOWRAP>&nbsp;</TD>
</TR>
<tr>
   <TD class="data">&nbsp;</TD>
  <TD class="data" colspan="4"><hr /></TD>
  <TD class="data">&nbsp;</TD>
</tr>

<%	

rsEvents.MoveNext
	
Loop

%>
    
</fieldset><br /><br />

<tr>
    <td class="footer-left">&nbsp;</td>
    <td class="footer" colspan="4">&nbsp;</td>
    <td class="footer-right">&nbsp;</td>
</tr>
<tr>
    <td >&nbsp;</td>
    <td align="center" colspan="4"><br /><br /><INPUT TYPE="submit" VALUE="Continue"></FORM></td>
    <td >&nbsp;</td>
</tr>
</tbody>
</table>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>
</htmlL>

<%

End Sub

'======================================

Sub DisplayReport(ReportEventCode)

DIM SurveyFields(13,1)
SurveyFields(1,1) = "Hot wings platter"
SurveyFields(2,1) = "Croissant Sandwich Platter"
SurveyFields(3,1) = "Vegetable Platter"
SurveyFields(4,1) = "Salami platter"
SurveyFields(5,1) = "Mixed nut platter"
SurveyFields(6,1) = "Chips and Salsa platter"
SurveyFields(7,1) = "Desert platter pastry"
SurveyFields(8,1) = "Tap beer"
SurveyFields(9,1) = "Premium beers"
SurveyFields(10,1) = "Soda"
SurveyFields(11,1) = "Water"
SurveyFields(12,1) = "Wine"
SurveyFields(13,1) = "Coffee"

ReportOrganizationNumber = 3886

Response.Buffer = False

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
#title
{
font-size: 11px;
font-weight: 400;
text-align: left;
border-collapse: collapse;
width: 70%;
top: 10px;
line-height: 15px;
margin-top:  10px;
}
#dark-corner
{
font-size: 11px;
font-weight: 400;
text-align: left;
border-collapse: collapse;
width: 70%;
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
padding-right: 25px;
font-size: 11px;
font-weight: 600;
color: #ffffff;
text-align: left;
white-space:nowrap;
background-image: url('/clients/Tix/Images/PadHeaderBG.gif');
}
#dark-corner thead th.category-left
{
background: #202020 url('/clients/Tix/Images/PadHeaderBG.gif');
background-repeat: repeat;
text-align: right;
}
#dark-corner thead th.category-right
{
background: #202020 url('/clients/Tix/Images/PadHeaderBG.gif');
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
</style>


</head>

<body>

<!--#INCLUDE VIRTUAL="TopNavInclude.asp" -->

<%

        Response.Write "<H3>" & ReportTitle & "</H3>" & vbCrLf
	
		SQLEvent = "SELECT Act, Venue, EventDate, OrganizationVenue.OrganizationNumber FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) on Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) on Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = Act.ActCode AND OrganizationVenue.OrganizationNumber = OrganizationAct.OrganizationNumber WHERE Event.EventCode = " & ReportEventCode & " AND OrganizationVenue.Owner <> 0"
		Set rsEvent = OBJdbConnection.Execute(SQLEvent)
		
		'Report Title
		'-------------------
		Response.Write "<table>" & vbCrLf
		Response.Write "<TR>" & vbCrLf
		Response.Write "<TD>" & rsEvent("Act") & "</TD>" & vbCrLf
		Response.Write "</TR>" & vbCrLf
		Response.Write "<TR>" & vbCrLf
		Response.Write "<TD>" & rsEvent("Venue") & "</TD>" & vbCrLf
	    Response.Write "</TR>" & vbCrLf
		Response.Write "<TR>" & vbCrLf
		Response.Write "<TD>" & FormatDateTime(rsEvent("EventDate"), vbShortDate) & " " & Left(FormatDateTime(rsEvent("EventDate"), vbLongTime), Len(FormatDateTime(rsEvent("EventDate"), vbLongTime))-6) & " " & Right(FormatDateTime(rsEvent("EventDate"),vbLongTime), 2) & "</TD>" & vbCrLf
		Response.Write "</TR></TABLE>" & vbCrLf	
		rsEvent.Close
		Set rsEvent = nothing
		
		
	    'Report Start 
		'-------------------		
		Response.Write "<table id=""dark-corner"">" & vbCrLf
	    Response.Write "<thead>" & vbCrLf
		Response.Write "<tr>" & vbCrLf
	    Response.Write "<th class=""category-left""><img src=""/clients/Tix/Images/PadHeaderLeftCorner.gif"" border=""0""></th>" & vbCrLf 
		
		'Column Names - Standard
		'--------------------------------------
        Response.Write "<th class=""category"">Section</th><th class=""category"">Row</th><th class=""category"">Seat</th><th class=""category"">Order Number</th><th class=""category"">Order Date/Time</th><th class=""category"">Customer Name</th><th class=""category"">Status</th><th class=""category"">Ticket Type</th><th class=""category"">Net Price</th><th class=""category"">Order Type</th>" & vbCrLf
        
        
        'Column Names - Custom
        '------------------------------------     
        For j = 1 to UBound(SurveyFields,1)
            Response.Write "<th class=""category"">" & SurveyFields(j,1) & "</th>" & vbCrLf
        Next
        
        Response.Write "<th class=""category-right""><img src=""/clients/Tix/Images/PadHeaderRightCorner.gif""></th>" & vbCrLf 
        Response.Write "</tr>" & vbCrLf         
        
        'Report Survey Results - Standard 
        '--------------------------------- 
                
        'Alternating row color - set the line count to 0
        lc = 0         
        
        SQLSeat = "SELECT Seat.EventCode, OrderLine.OrderNumber, Seat.ItemNumber, Seat.SectionCode, Section.Section, Section.SectionType, Seat.Row, Seat.Seat, SeatStatus.Status, Seat.HoldType, OrderType, OrderLine.SeatTypeCode, SeatType, Price, OrderLine.Discount, OrderDate, OrderHeader.CustomerNumber, ShipFirstName AS FirstName, ShipLastName AS LastName FROM Seat (NOLOCK) INNER JOIN Section (NOLOCK) ON Seat.SectionCode = Section.SectionCode AND Seat.EventCode = Section.EventCode INNER JOIN SeatStatus (NOLOCK) ON Seat.StatusCode = SeatStatus.StatusCode LEFT JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent', 'SubSeat') INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode AND OrganizationVenue.OrganizationNumber = OrganizationAct.OrganizationNumber LEFT JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber LEFT JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode LEFT JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber WHERE Seat.EventCode = " & ReportEventCode & " AND OrganizationVenue.OrganizationNumber = " & ReportOrganizationNumber & " AND OrganizationAct.OrganizationNumber = " & ReportOrganizationNumber & " AND Seat.StatusCode = 'S' ORDER BY Seat.SectionCode, Seat.RowSort, Seat.SeatSort DESC"
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
				
				Response.Write "<td>&nbsp;</td>" & vbCrLf				
				Response.Write "<td nowrap=""nowrap"">" & rsSeat("Section") & "</td>" & vbCrLf
				
				If rsSeat("SectionType") = "general" Then
				    SeatNumber = "&nbsp;"
				    RowNumber = "&nbsp;"
				Else	
					SeatNumber = rsSeat("Number")
				    RowNumber = rsSeat("Row")	
				End If	
								
		        Response.Write "<td>" & RowNumber & "</td>" & vbCrLf
		        Response.Write "<td>" & SeatNumber & "</td>" & vbCrLf
		        Response.Write "<td>" & rsSeat("OrderNumber") & "</td>" & vbCrLf
		        Response.Write "<td>" & DateAndTimeFormat(rsSeat("OrderDate")) & "</td>" & vbCrLf
		        Response.Write "<td nowrap=""nowrap"">" & rsSeat("LastName") & ", " & rsSeat("FirstName") & "</td>" & vbCrLf
		        Response.Write "<td>" & rsSeat("Status") & "</td>" & vbCrLf
		        
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


                'Report Column Names - Custom Data Fields  
                '----------------------------------------                                    
                'Line Count
                For i = 1 to 1
                
                    'Answer Count          
                    'Question Count
                    For j = 1 to UBound(SurveyFields,1)

                        SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & rsSeat("OrderNumber") & " AND LineNumber = " & i & " AND FieldName = 'Answer" & j & "'"
                        Set rsOrderLineDetail = OBJdbConnection.Execute(SQLOrderLineDetail)          
                            If rsOrderLineDetail("FieldValue") = "" OR rsOrderLineDetail("FieldValue") = "0" Then                
                                Response.Write "<td>&nbsp;</td>" & vbCrLf                 
                            Else                
                                Response.Write "<td>" & rsOrderLineDetail("FieldValue") & "</td>" & vbCrLf                        
                            End If            
                        rsOrderLineDetail.Close
                        Set rsOrderLineDetail = nothing

                    Next
                Next
                
                Response.Write "<td>&nbsp;</td>" & vbCrLf
                Response.Write "</tr>" & vbCrLf
                
        rsSeat.MoveNext
        Loop
        
        End If
       
       Response.Write "</table>" & vbCrLf
	
%>

</CENTER>

<!--#include virtual="FooterInclude.asp"-->

</BODY>

</HTML>

<% End Sub %>
