<!--#INCLUDE virtual="PrivateLabelInclude.asp" -->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->

<%

TooltipIncludeFlag = "Y"
Page = "Schedule"

'============================================================

'Special Events Listing

SpecialEventCount = 1

Dim SpecialEventsTitle(1)
Dim SpecialEventsList(1)

SpecialEventsTitle(1) = "Chicago"
SpecialEventsList(1) = "297511,297512,298147,298146" 
 
SpecialEventsOnSale = "N"

'============================================================

'CSS Survey Variables

If Session("UserNumber")<> "" Then
    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "FFFFFF"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "000000"
    TableDataBGColor = "E9E9E9"
End If

'LastHex = box color
'FirstHex = background color

If Session("UserNumber")<> "" Then
    NECorner="/clients/tix/images/image.asp?FirstHex=efebe3&LastHex=008400&Src=TopLeftCorner16.txt"
    NWCorner="/clients/tix/images/image.asp?FirstHex=efebe3&LastHex=008400&Src=TopRightCorner16.txt"
    SWCorner="/clients/tix/images/image.asp?FirstHex=f3f1ed&LastHex=E9E9E9&Src=BottomLeftCorner16.txt"
    SECorner="/clients/tix/images/image.asp?FirstHex=f3f1ed&LastHex=E9E9E9&Src=BottomRightCorner16.txt"
Else
    NECorner="/clients/tix/images/image.asp?FirstHex=000000&LastHex=CF3D18&Src=TopLeftCorner16.txt"
    NWCorner="/clients/tix/images/image.asp?FirstHex=000000&LastHex=CF3D18&Src=TopRightCorner16.txt"
    SWCorner="/clients/tix/images/image.asp?FirstHex=000000&LastHex=000000&Src=BottomLeftCorner16.txt"
    SECorner="/clients/tix/images/image.asp?FirstHex=000000&LastHex=000000&Src=BottomRightCorner16.txt"
End If

'============================================================

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
	width: 700px;
	text-align: left;
	border-collapse: collapse;
}
#rounded-corner thead th.category
{
	padding-top: 10px;
    padding-bottom: 10px;
    padding-left: 0px;
    padding-right: 1px;
	font-size: 15px;
	font-weight: 600px;
	text-align: left;
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
	padding-left: 5px;
	padding-right: 5px;
	padding-top: 5px;
	padding-bottom: 5px;
	text-align: left;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-right
{
	padding-left: 5px;
	padding-right: 5px;
	padding-top: 5px;
	padding-bottom: 5px;
    text-align: right;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner hr 
{
   border: 0;
   width: 100%;
   height: 1px;
   color: #565f68;
   background-color: #565f68;
 }
 /* link */
#rounded-corner a:link 
{
text-decoration: none;
color: #<%=TableCategoryBGColor%>;
font-size: 11px;
font-weight: 400;
} 
 /* visited link */
#rounded-corner a:visited
{
text-decoration: none;
color: #<%=TableCategoryBGColor%>;
font-size: 11px;
font-weight: 400;
} 
/* mouse over link */
#rounded-corner a:hover
{
text-decoration: none;
color:#<%=TableCategoryBGColor%>;
font-size: 11px;
font-weight: 400;
} 
/* selected link */
#rounded-corner a:active
{
text-decoration: none;
color: #<%=TableCategoryBGColor%>;
font-size: 11px;
font-weight: 400;
} 
</style>

</HEAD>

</head>

<%=strBody %>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<BR />
<FONT FACE="<%= FontFace%>" COLOR="<%=HeadingFontColor%>" SIZE="5"><B><%=ScheduleTitle%></B></FONT>
<BR />
<BR />
<%


'===================================
'SPECIAL EVENTS

SpecialEventsOnSale = "N"

For i = 1 To SpecialEventCount

        SQLWhere = "WHERE Event.EventDate >= '" & FormatDateTime(Now(), vbShortDate) & "'"

        If IsDate(Clean(Request("StartDate"))) Then
	        SQLWhere = SQLWhere & " AND Event.EventDate >= '" & CDate(Clean(Request("StartDate"))) & "'"
        End If
        If IsDate(Clean(Request("EndDate"))) Then
	        SQLWhere = SQLWhere & " AND Event.EventDate < '" & CDate(Clean(Request("EndDate"))) + 1 & "'"
        End If

        If Request("OrganizationNumber") <> "" Then SQLWhere = SQLWhere & " AND OrganizationAct.OrganizationNumber = '" & Clean(Request("OrganizationNumber")) & "' AND OrganizationVenue.OrganizationNumber = '" & Clean(Request("OrganizationNumber")) & "'"

        SQLQuery = "SELECT DISTINCT EventDate, EventCode, Act, City, State, Venue From Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Category (NOLOCK) ON Act.CategoryCode = Category.CategoryCode INNER JOIN SubCategory (NOLOCK) ON Act.SubCategoryCode = SubCategory.SubCategoryCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode " & SQLWhere & " AND Event.OnSale = 1 AND Event.SaleStartDate <= '" & Now() &  "' AND (Event.EventType <> 'SubFixedEvent' OR Event.EventType IS NULL) AND Event.EventCode IN (" & SpecialEventsList(i) & ") ORDER BY Event.EventDate, Act.Act"

        Set rsEvents = OBJdbConnection.Execute(SQLQuery)

        If Not rsEvents.EOF Then

        SpecialEventsOnSale = "Y"
        	
	        If SpecialEventVenueLocation Then
	        %>                
                <H3><%= SpecialEventsTitle %></H3> 
                <table id="rounded-corner" summary="special events">
                <thead>
                <tr>
                    <th scope="col" class="category-left">&nbsp;</th>
                    <th scope="col" class="category">Date/Time</th>
                    <th scope="col" class="category">Event</th>
                    <th scope="col" class="category">Venue/Location</th>
                    <th scope="col" class="category">Tickets</th>
                    <th scope="col" class="category-right">&nbsp;</th>
                </tr>        
                </thead>
                <tbody>                
         <% 
	     Else
	     %>                
                <H3><%= SpecialEventsTitle %></H3> 
                <table id="rounded-corner" summary="special events">
                <thead>
                <tr>
                    <th scope="col" class="category-left">&nbsp;</th>
                    <th scope="col" class="category">Date/Time</th>
                    <th scope="col" class="category">Event</th>
                    <th scope="col" class="category">Tickets</th>
                    <th scope="col" class="category-right">&nbsp;</th>
                </tr>        
                </thead>
                <tbody>                
            <% 
         End If
        	
	        Do While Not rsEvents.EOF
        	
	          strDate = FormatDateTime(rsEvents("EventDate"),vbShortDate)
	          strWeekDay = WeekdayName(Weekday(rsEvents("EventDate")), True) & "."
	          strTime = Left(FormatDateTime(rsEvents("EventDate"),vbLongTime),Len(FormatDateTime(rsEvents("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsEvents("EventDate"),vbLongTime),3)
        	  
	          'REE 5/14/3 - Added ActSuffix
	          SQLActSuffix = "SELECT OptionValue AS ActSuffix FROM EventOptions (NOLOCK) WHERE EventCode = " & rsEvents("EventCode") & " AND OptionName = 'ActSuffix'"
	          Set rsActSuffix = OBJdbConnection.Execute(SQLActSuffix)
	          If Not rsActSuffix.EOF Then 'Use it
		        ActSuffix = " - " & rsActSuffix("ActSuffix")
	          Else
		        ActSuffix = ""
	          End If
        	  
	          rsActSuffix.Close
	          Set rsActSuffix = nothing

		        DisplayDate = ""

		        'REE 12/10/3 - Modified to look at EventOptions for Date & Time Display Options
		        SQLDateSuppress = "SELECT OptionValue AS DateSuppress FROM EventOptions (NOLOCK) WHERE EventCode = " & rsEvents("EventCode") & " AND OptionName = 'DateSuppress' AND OptionValue = 'Y'"
		        Set rsDateSuppress = OBJdbConnection.Execute(SQLDateSuppress)
		        If rsDateSuppress.EOF Then
			        DisplayDate = DisplayDate & strWeekDay & "&nbsp;" & strDate
		        End If
		        rsDateSuppress.Close
		        Set rsDateSuppress = nothing

		        SQLTimeSuppress = "SELECT OptionValue AS TimeSuppress FROM EventOptions (NOLOCK) WHERE EventCode = " & rsEvents("EventCode") & " AND OptionName = 'TimeSuppress' AND OptionValue = 'Y'"
		        Set rsTimeSuppress = OBJdbConnection.Execute(SQLTimeSuppress)
		        If rsTimeSuppress.EOF Then
			        DisplayDate = DisplayDate & "<BR>at " & strTime
		        End If
		        rsTimeSuppress.Close
		        Set rsTimeSuppress = nothing

	          If IncludeVenueLocation Then
		        Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=8 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
		        Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD>&nbsp;&nbsp;</TD><TD ALIGN=left NOWRAP><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1>" & DisplayDate & "</FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=/Event.asp?Event=" & rsEvents("EventCode") & " id=""EventLink_" & rsEvents("EventCode") & """ onmouseover=""ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode=" & rsEvents("EventCode") & "\', this)', 200);"" onmouseout=""clearTimeout(ttDelay);hideTooltip();""><B>" & rsEvents("Act") & ActSuffix & "</B></A></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1>" & rsEvents("Venue") & "<BR>" & rsEvents("City") & ", " & rsEvents("State") & "</FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=/Event.asp?Event=" & rsEvents("EventCode") & " id=""TixInfoLink_" & rsEvents("EventCode") & """ onmouseover=""ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode=" & rsEvents("EventCode") & "\', this)', 200);"" onmouseout=""clearTimeout(ttDelay);hideTooltip();"">Tix & Info</A>&nbsp;</FONT></TD></TR>" & vbCrLf
		        Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=8 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
		        Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=8 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
	          Else
		        Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=6 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
		        Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD>&nbsp;&nbsp;</TD><TD ALIGN=left NOWRAP><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1>" & DisplayDate & "</FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=/Event.asp?Event=" & rsEvents("EventCode") & " id=""EventLink_" & rsEvents("EventCode") & """ onmouseover=""ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode=" & rsEvents("EventCode") & "\', this)', 200);"" onmouseout=""clearTimeout(ttDelay);hideTooltip();""><B>" & rsEvents("Act") & ActSuffix & "</B></A></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=/Event.asp?Event=" & rsEvents("EventCode") & " id=""TixInfoLink_" & rsEvents("EventCode") & """ onmouseover=""ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode=" & rsEvents("EventCode") & "\', this)', 200);"" onmouseout=""clearTimeout(ttDelay);hideTooltip();"">Tix & Info</A>&nbsp;</FONT></TD></TR>" & vbCrLf
		        Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=6 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
		        Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=6 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
	          End If	
	          events="Y"
	          rsEvents.MoveNext
	        Loop 

	        Response.Write "</TABLE>" & vbCrLf

        End If
        rsEvents.Close
        Set rsEvents = Nothing
        
 Next
        

'===================================
'Off Sale Message

%>

</CENTER>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>
</html>

<%

OBJdbConnection.Close
Set OBJdbConnection = nothing

%>

