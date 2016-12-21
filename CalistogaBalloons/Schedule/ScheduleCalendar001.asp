<!--#INCLUDE virtual="PrivateLabelInclude.asp" -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<%
'set the flag to include the TooltipInclude.html file
TooltipIncludeFlag = "Y"

If IsNumeric(CleanNumeric(Request("OrganizationNumber"))) AND Request("OrganizationNumber") <> "" Then
    OrgNum = CleanNumeric(Request("OrganizationNumber"))
Else
    OrgNum = 0
End If

'TTT 2/26/10 - filtered schedule page with ActCodes
ActCodeList = ""
If Request("ActCode") <> "" Then       
    ActCodeList = CleanNumList(Request("ActCode"))
End If

FirstEventDate = Now()
'Get the first Event that is on sale and passed current date/time
SQLEvents = "SELECT TOP(1) EventDate FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE OrganizationVenue.OrganizationNumber = " & OrgNum & " AND OrganizationAct.OrganizationNumber = " & OrgNum & " AND Event.EventDate > GETDATE() AND Event.SaleStartDate <= '" & Now() & "' AND OnSale = 1"
If ActCodeList <> "" Then
    SQLEvents = SQLEvents & " AND Event.ActCode IN (" & ActCodeList & ")"
End If
SQLEvents = SQLEvents & " ORDER BY EventDate"
Set rsEvents = OBJdbConnection.Execute(SQLEvents)
If Not rsEvents.EOF Then
    FirstEventDate = CDate(rsEvents("EventDate"))
End If
rsEvents.Close
Set rsEvents = Nothing

If IsNumeric(Request("CalendarMonth")) And Request("CalendarMonth") <> "" Then
    CalendarMonth = CleanNumeric(Request("CalendarMonth"))
Else
    CalendarMonth = Month(FirstEventDate)
End If
If IsNumeric(Request("CalendarYear")) And Request("CalendarYear") <> ""  Then        
    CalendarYear = CleanNumeric(Request("CalendarYear"))
Else    
    CalendarYear = Year(FirstEventDate)
End If
CampaignNumberLink = ""
If IsNumeric(Request("CampaignNumber")) And Request("CampaignNumber") <> ""  Then        
    CampaignNumberLink = "&CampaignNumber=" & CleanNumeric(Request("CampaignNumber"))
End If

If Request("FormName") = "dateselection" Then
    Call CopyEvent
Else
    Call DateSelectionForm
End If


Sub DateSelectionForm
'REE 6/19/9 - Added Dynamic Page Title
'REE 10/23/9 - Modified to use dynamic title only when no PL Title exists.
'REE 1/16/10 - Added CleanNumerics throughout
If Request("OrganizationNumber")<> "" And Title = "" Then
    SQLOrg = "SELECT Organization FROM Organization (NOLOCK) WHERE OrganizationNumber = " & CleanNumeric(Request("OrganizationNumber"))
    Set rsOrg = OBJdbConnection.Execute(SQLOrg)
    
    Title = rsOrg("Organization") & " Ticket Sales"
    
    rsOrg.Close
    Set rsOrg = nothing
End If
%>
<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<TITLE><%= Title %></TITLE>

<style type="text/css">
    
/* calendar */
/* by not setting a table width you get a table that will cover the size of the div or page you put it in  */
table.calendar { 
    border-left:1px solid #999; 
}
/* Settings for the control menu */
table.calendar-control { 
	width: 100%;
	text-align: center; 
}
/* This changes the select month and select year drop down menus */
table.calendar-control-select {  
}

tr.calendar-row {  
}
td.calendar-day, td.calendar-weekend-day, td.calendar-current-day { 
	height:100px; 
	font-size:11px;
	position:relative;
	vertical-align: top;
	line-height: 8px; /* This determins the space that will  space out the events on the calendar */
}
* html div.calendar-day, div.calendar-weekend-day, div.calendar-current-day { 
	height:100px; 
}
/* This alters the headings (the days of the week) Change the colour and background for those here */
td.calendar-day-head { 
	background:#CCC; 
	color: #000;
	font-weight:bold; 
	text-align:center; 
	width:120px; 
	padding:5px; 
	border-bottom:1px solid #999; 
	border-top:1px solid #999; 
	border-right:1px solid #999; 
}
/* Change these colours to alter the respective portion of the calendar */
td.calendar-day	{ 
	background-color: #E1E1E1;
}
td.calendar-weekend-day	{ 
	background-color: #CFCFCF;
}
td.calendar-current-day	{ 
	background-color: #ECEFF5; 
}
/* These colours are for the mouse over effects on the calendar */
td.calendar-day:hover { 
	background:#ECEFF5; 
}
td.calendar-weekend-day:hover {
	background:#D7DADF;
}
td.calendar-current-day:hover { 
	background:#E5E7ED; 
}
/* background colour of the blank dates */
td.calendar-day-np { 
	background:#EEE; 
	min-height:100px; 
}
* html div.calendar-day-np { 
	height:100px; }
	
/* This alters the number dates of the calendar */
div.calendar-day-number {
	position: relative;
	padding:5px; 
	color:#000; 
	/*
	Uncomment this to make a background square around the dates
	Personally I think it looks ugly, but depending on your colour scheme
	it can work :) 
	background-color: #C1C1C1;
	*/ 
	font-weight:bold; 
	float:right; 
	margin:-5px -5px 0 0; 
	width:20px; 
	text-align:right;
	line-height: normal; 
}
/* This alters the text section for events on the calendar. */
div.calendar-text {
	color:#111;	
}
div.calendar-text a {
	color: #111;
	text-decoration: none; 
}
div.calendar-text a:hover {
	color: #333;
	text-decoration: underline; 
}
/* shared */
td.calendar-day,td.calendar-current-day, td.calendar-weekend-day, td.calendar-day-np { 
	width:120px; 
	padding:5px; 
	border-bottom:1px solid #999; 
	border-right:1px solid #999; 
}
</style>

</HEAD>
<%= strBody %>

<!--#include virtual="TopNavInclude.asp"-->

<% If ScheduleTitle <> "" Then %>
<FONT FACE="<%=FontFace%>" COLOR="<%=HeadingFontColor%>"><H3><%=ScheduleTitle%></H3></FONT>
<% Else %>
<FONT FACE="<%=FontFace%>" COLOR="<%=HeadingFontColor%>"><H3>Calendar Schedule</H3></FONT>
<% End If %>

<TABLE cellpadding="0" cellspacing="0" border="5">
  <tr>
<%
ColCount = 3

StartDate = CalendarMonth & "/1/" & CalendarYear

For i = 0 to 0
    If i Mod ColCount = 0 Then
        Response.Write "</tr><tr>"
    End If
    Response.Write "<td>" & Calendar(FormatDateTime(DateAdd("m", i, StartDate), vbShortDate)) & "</td>"
Next
%>
  </tr>
</table>

</CENTER>
<BR>
<!--#INCLUDE VIRTUAL="FooterInclude.asp"-->

</BODY>
</HTML>

<%
End Sub 'Date Selection Form

'================

function calendar(CurrentDate)

	Today = Date
	if isnull(CurrentDate) then
		CurrentDate = Today
	end if                   
		
     CurrentDate = DateValue(CurrentDate)                           
     CurrentMonth = month(CurrentDate)    
     CurrentYear = year(CurrentDate)                           
     
     month_names = Array("January", _
                         "February", _
                         "March", _
                         "April", _
                         "May", _
                         "June", _
                         "July", _
                         "August", _
                         "September", _
                         "October", _
                         "November", _
                         "December")                                      
              
     this_month = datevalue(CurrentMonth & "/1/" & CurrentYear)                           
     next_month = datevalue(dateadd("m", 1, CurrentMonth &  "/1/" & CurrentYear))
     
     'Find out when this month starts and ends.         
     first_week_day = weekday(this_month) - 1                  
     
     days_in_this_month = datediff("d", this_month, next_month)                  
     
     'Previous/Next Nav Control
     '-------------------------                 
     calendar_html = "<table cellpadding=""0"" cellspacing=""0"" class=""calendar-control"">"
    
    If CurrentMonth - 1 = 0 Then
        PreviousMonth = 12
        PreviousYear = CurrentYear - 1
    Else
        PreviousMonth = CurrentMonth - 1
        PreviousYear = CurrentYear
    End If
    
    If CurrentMonth + 1 > 12 Then
        NextMonth = 1
        NextYear = CurrentYear + 1
    Else
        NextMonth = CurrentMonth + 1
        NextYear = CurrentYear
    End If        
            
    PreviousLink = "ScheduleCalendar.asp?OrganizationNumber=" & OrgNum
    
    If ActCodeList <> "" Then
        PreviousLink = PreviousLink & "&ActCode=" & ActCodeList
    End If
    
    PreviousLink = PreviousLink & "&CalendarMonth=" & PreviousMonth & "&CalendarYear=" & PreviousYear & CampaignNumberLink 
    
    NextLink = "ScheduleCalendar.asp?OrganizationNumber=" & OrgNum
    
    If ActCodeList <> "" Then
        NextLink = NextLink & "&ActCode=" & ActCodeList
    End If
    
    NextLink = NextLink & "&CalendarMonth=" & NextMonth & "&CalendarYear=" & NextYear & CampaignNumberLink 
     
     calendar_html = calendar_html & _
                     "<tr><td><a href=""" & PreviousLink & """ class=""control""><< Previous Month</a></td><td colspan=""5"">" & _
                     month_names(CurrentMonth - 1) & " " & CurrentYear & "</td><td><a href=""" & NextLink & """  class=""control"">Next Month >></a></td></tr>"
                       
     calendar_html = calendar_html & "</tr>" & vbCrLf
     calendar_html = calendar_html & "</table>" & vbCrLf
     
     'Calendar - Days Of Week Header
     '------------------------------
     calendar_html = calendar_html & "<table cellpadding=""0"" cellspacing=""0"" align=""center"" class=""calendar"">" & vbCrLf  
     calendar_html = calendar_html & "<tr class=""calendar-row"">" & vbCrLf 
     
     for wdnum = 1 To 7
        calendar_html = calendar_html & "<td class=""calendar-day-head"">" & WeekdayName(wdnum, true) & "</td>"
     next
                    
     calendar_html = calendar_html & "</tr>" & vbCrLf
     
     'Calendar - Blank Days
     '------------------------------
       
     calendar_html = calendar_html & "<tr class=""calendar-row"">"
     
     'Fill the first week of the month with the appropriate number of blanks.       
     for week_day = 0 to first_week_day - 1            
         calendar_html = calendar_html & "<td class=""calendar-day-np"">&nbsp;</td>"   
         daycount = daycount + 1
     next
        
     week_day = first_week_day
     for day_counter = 1 to days_in_this_month           
        daycount = daycount + 1
         week_day = week_day mod 7
        
         if week_day = 0 then
            calendar_html = calendar_html & "</tr>" & vbCrLf
            calendar_html = calendar_html & "<tr class=""calendar-row"">" & vbCrLf
         end if
    
        CalendarDate = CDate(CalendarMonth & "/" & day_counter & "/" & CalendarYear)
        
		If CalendarDate < Today Then
			DayDisplay = "<div class=""calendar-day-number"">" & day_counter & "</div>"
		ElseIf CalendarDate = Today Then
			DayDisplay = "<div class=""calendar-day-number"">" & day_counter & "</div>"
		Else 'CalendarDate > Today 
			DayDisplay = "<div class=""calendar-day-number"">" & day_counter & "</div>"
		End If
		
        calendar_html = calendar_html & "<td class=""calendar-day"">" & DayDisplay & ""                                
                                        
        SQLEvent = "SELECT Act.ActCode, Act.Act, Event.EventCode, Event.EventDate FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode AND OrganizationAct.OrganizationNumber = OrganizationVenue.OrganizationNumber WHERE OrganizationVenue.OrganizationNumber = " & OrgNum & " AND Event.EventDate >= '" & CalendarDate & "' AND Event.EventDate < '" & CalendarDate + 1 & "' AND Event.SaleStartDate <= '" & Now() & "' AND OnSale = 1"
        
        If ActCodeList <> "" Then
            SQLEvent = SQLEvent & " AND Event.ActCode IN (" & ActCodeList & ")"
        End If
        
        SQLEvent = SQLEvent & " ORDER BY Act.Act, Act.ActCode, Event.EventCode"
        
        Set rsEvent = OBJdbConnection.Execute(SQLEvent)
        ActCd = -1
        
        'calendar_html = calendar_html & "<div class=""calendar-text"">"
        
        Do Until rsEvent.EOF
            If ActCd <> rsEvent("ActCode") Then
                SameAct = 1
                EventCd = rsEvent("EventCode")
                ActCd = rsEvent("ActCode")
                ActNm = rsEvent("Act")
            Else
                SameAct = SameAct + 1
            End If
            
            'calendar_html = calendar_html & CalendarDate
            rsEvent.MoveNext
            
            If Not rsEvent.EOF Then
                If ActCd <> rsEvent("ActCode") Then
                    If SameAct > 1 Then
                        If CalendarDate >= Date() Then 
                            calendar_html = calendar_html & "<div class=""calendar-text""><a href=""/Schedule.asp?ActCode=" & ActCd & "&StartDate=" & CalendarDate & "&EndDate=" & CalendarDate & CampaignNumberLink & """ onmouseover=""ttDelay=setTimeout('eventTooltip(\'/AJAX/ProductionInfo.asp?ActCode=" & ActCd & "\', this)', 200);"" onmouseout=""clearTimeout(ttDelay);hideTooltip();"">" & ActNm & "</a></div><br>"
                        End If
                    Else
                        If CalendarDate >= Date() Then
                            calendar_html = calendar_html & "<div class=""calendar-text""><a href=""/Event.asp?Event=" & EventCd & CampaignNumberLink & """ onmouseover=""ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode=" & EventCd & "\', this)', 200);"" onmouseout=""clearTimeout(ttDelay);hideTooltip();"">" & ActNm & "</a></div><br>"
                         End If
                    End If
                End If
            Else
                If SameAct > 1 Then
                    If CalendarDate >= Date() Then 
                        calendar_html = calendar_html & "<div class=""calendar-text""><a href=""/Schedule.asp?ActCode=" & ActCd & "&StartDate=" & CalendarDate & "&EndDate=" & CalendarDate & CampaignNumberLink & """ onmouseover=""ttDelay=setTimeout('eventTooltip(\'/AJAX/ProductionInfo.asp?ActCode=" & ActCd & "\', this)', 200);"" onmouseout=""clearTimeout(ttDelay);hideTooltip();"">" & ActNm & "</a></div><br>"
                    End If
                Else
                    If CalendarDate >= Date() Then
                        calendar_html = calendar_html & "<div class=""calendar-text""><a href=""/Event.asp?Event=" & EventCd & CampaignNumberLink & """ onmouseover=""ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode=" & EventCd & "\', this)', 200);"" onmouseout=""clearTimeout(ttDelay);hideTooltip();"">" & ActNm & "</a></div><br>"
                   End If
                End If    
            End If
        Loop
        
        rsEvent.Close
        Set rsEvent = nothing
        
        'calendar_html = calendar_html & "</div><BR>"
        calendar_html = calendar_html & "</td>"
            
         week_day = week_day + 1
     next
     
     for ree = 0 to 6 - week_day
        calendar_html = calendar_html & "<td>&nbsp;</td>"
     next
        
     calendar_html = calendar_html & "</tr>" & vbCrLf
     calendar_html = calendar_html & "</table>"
               
     Calendar = calendar_html
end function
%>
