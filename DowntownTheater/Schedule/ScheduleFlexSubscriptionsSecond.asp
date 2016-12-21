<%

'CHANGE LOG - Inception
'SSR 5/12/2011
'Custom schedule page to display flex subscriptions

%>


<!--#INCLUDE virtual="PrivateLabelInclude.asp" -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->

<%

'==================================================================

Page = "Schedule"
TooltipIncludeFlag = "Y"
OrgNumber = 2964

'==================================================================

'Tannery Pond (5/12/2011)
'Flexible Subscription Schedule Page
'Second Floor Subscription Series

'Display events valid for first floor subscription series
'EventCode   EventName
'339323      Amerigo Trio
'339324      Andrés Díaz
'339325      Christine Brewer
'339326      Vassily Primakov
'339327      Arabella Ensemble
'339328      Ilya Poletaev
'339329      Harlem String Quartet

'==================================================================

SubscriptionTitle = "Second Floor Subscription Series"
SubscriptionHeader = "Build your own subscription:<BR>Please enter 1 ticket to 4 productions below</B><BR><B>Season subscription discount will be calculated on the final payment page"
EventCodeList = "339323,339324,339325,339326,339327,339328,339329"

'==================================================================

If Clean(Request("FormName")) <> "" Then 
	FormName = Clean(Request("FormName"))
End If

'REE 12/7/3 - Moved Session OrderTypeNumber to Top of Script
If Session("OrderTypeNumber") = "" Then
	Session("OrderTypeNumber") = 1
End If

'REE 5/4/4 - Added OrderTypeNumber variable to top of script.
OrderTypeNumber = 1

If Request("FormName") <> "EventForm" Then
	Call EventForm(Message)
Else
	Call AddToCart
End If
OBJdbConnection.Close
Set OBJdbConnection = nothing


Sub EventForm(Message)

'REE 6/19/9 - Added Dynamic Page Title
If Request("OrganizationNumber")<> "" Then
    SQLOrg = "SELECT Organization FROM Organization (NOLOCK) WHERE OrganizationNumber = " & CleanNumeric(Request("OrganizationNumber"))
    Set rsOrg = OBJdbConnection.Execute(SQLOrg)
    
    Title = rsOrg("Organization") & " Ticket Sales"
    
    rsOrg.Close
    Set rsOrg = nothing
End If    

%>
<HTML>
<HEAD>
<TITLE><%= Title %></TITLE>
</HEAD>

<%
If Message = "" Then
	Response.Write "<BODY BGCOLOR=#FFFFFF leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0>" & vbCrLf
Else
	Response.Write "<BODY BGCOLOR=#FFFFFF onLoad=" & CHR(34) & "alert('" & Message & "');" & CHR(34) & " leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0>" & vbCrLf
End If
%>

<CENTER>
<!--#INCLUDE VIRTUAL="TopNavInclude.asp"-->
<BR>
<!--<FONT FACE="verdana,arial,helvetica" COLOR="#9CC3DE"><H3>Schedule</H3></FONT>-->

<%

Response.Write "<FONT FACE=" & FontFace & " COLOR=" & HeadingFontColor & "><H3>" &  SubscriptionTitle  & "</H3></FONT><BR>" & vbCrLf
Response.Write "<FONT FACE=""verdana,arial,helvetica"" SIZE=""1""><B>Build your own subscription:<BR>Please enter 1 ticket to each production below</B><BR><B>Season subscription discount will be calculated on the final payment page</B>" & vbCrLf

SQLWhere = "WHERE Event.EventDate >= '" & FormatDateTime(Now(), vbShortDate) & "'"

'REE 8/26/3 - Added new Start and End Date Criteria.  This allows dates to be passed in URL.
If IsDate(Clean(Request("StartDate"))) Then
	SQLWhere = SQLWhere & " AND Event.EventDate >= '" & CDate(Clean(Request("StartDate"))) & "'"
End If
If IsDate(Clean(Request("EndDate"))) Then
	SQLWhere = SQLWhere & " AND Event.EventDate < '" & CDate(Clean(Request("EndDate"))) + 1 & "'"
End If

'REE 4/9/2 - Added criteria for ActCode
'REE 7/6/2 - Added criteria for Organization
If Request("OrganizationNumber") <> "" Then SQLWhere = SQLWhere & " AND OrganizationAct.OrganizationNumber = '" & Clean(Request("OrganizationNumber")) & "' AND OrganizationVenue.OrganizationNumber = '" & Clean(Request("OrganizationNumber")) & "'"
'If Request("ActCode") <> "" Then SQLWhere = SQLWhere & " AND Event.ActCode IN (" & Clean(Request("ActCode")) & ")"
'If Request("VenueCode") <> "" Then SQLWhere = SQLWhere & " AND Venue.VenueCode IN( " & Clean(Request("VenueCode")) & ")"
SQLWhere = SQLWhere & " AND Event.EventCode IN (" & EventCodeList & ")"
'If Request("Category") <> "" Then SQLWhere = SQLWhere & " AND Category.Category IN (" & Clean(Request("Category")) & ")"
'REE 10/11/3 - Commented out Venue specific criteria.  This is controlled by OrgVenue

'REE 7/6/2 - Added Join to OrganizationAct and OrganizationVenue.  Added DISTINCT parameter.
'REE 4/26/3 - Added Act.Act to the Sort Criteria after EventDate
'JAI 8/6/3 - Added ability to sort by Act first, then event date
Select Case Request("SortOrder")
Case "Act"
	SQLQuery = "SELECT DISTINCT EventDate, EventCode, Act, City, State, Venue, Map From Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Category (NOLOCK) ON Act.CategoryCode = Category.CategoryCode INNER JOIN SubCategory (NOLOCK) ON Act.SubCategoryCode = SubCategory.SubCategoryCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode " & SQLWhere & "AND Event.OnSale = 1 AND Event.SaleStartDate <= '" & Now() &  "' ORDER BY Act.Act, Event.EventDate"
'REE 12/15/6 - Added Venue, Act sort	
Case "VenueAct"
	SQLQuery = "SELECT DISTINCT EventDate, EventCode, Act, City, State, Venue, Map From Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Category (NOLOCK) ON Act.CategoryCode = Category.CategoryCode INNER JOIN SubCategory (NOLOCK) ON Act.SubCategoryCode = SubCategory.SubCategoryCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode " & SQLWhere & "AND Event.OnSale = 1 AND Event.SaleStartDate <= '" & Now() &  "' ORDER BY Venue.Venue, Act.Act, Event.EventDate"
'REE 01/22/7 - Added Venue, EventDate, Act sort	
Case "VenueEventDate"
	SQLQuery = "SELECT DISTINCT EventDate, EventCode, Act, City, State, Venue, Map From Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Category (NOLOCK) ON Act.CategoryCode = Category.CategoryCode INNER JOIN SubCategory (NOLOCK) ON Act.SubCategoryCode = SubCategory.SubCategoryCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode " & SQLWhere & "AND Event.OnSale = 1 AND Event.SaleStartDate <= '" & Now() &  "' ORDER BY Venue.Venue, Event.EventDate, Act.Act"
Case Else
	SQLQuery = "SELECT DISTINCT EventDate, EventCode, Act, City, State, Venue, Map From Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Category (NOLOCK) ON Act.CategoryCode = Category.CategoryCode INNER JOIN SubCategory (NOLOCK) ON Act.SubCategoryCode = SubCategory.SubCategoryCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode " & SQLWhere & "AND Event.OnSale = 1 AND Event.SaleStartDate <= '" & Now() &  "' ORDER BY Event.EventDate, Act.Act"
End Select
Set rsEvents = OBJdbConnection.Execute(SQLQuery)

'JAI 4/12/5 - Open OBJdbConnection2 for Loop reads.
Call DBOpen(OBJdbConnection2)
	  
If Not rsEvents.EOF Then

    Response.Write "<FORM ACTION=ScheduleFirst.asp METHOD=post id=form1 name=EventForm><INPUT TYPE=hidden NAME=FormName VALUE=EventForm>" & vbCrLf
	Response.Write "<TABLE CELLSPACING=""0"" CELLPADDING=""0"" WIDTH=""90%"" BORDER=""0"">" & vbCrLf
	If IncludeVenueLocation Then
		Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=8 HEIGHT=2><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>Date/Time</B></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>Event</B></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>Venue/Location</B></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>Qty/Info&nbsp;</B></FONT></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=8 HEIGHT=2><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=8 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=8 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
	Else
		Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=6 HEIGHT=2><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>Date/Time</B></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>Event</B></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>Qty/Info&nbsp;</B></FONT></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=6 HEIGHT=2><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=6 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=6 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
	End If

	Call DBOpen(OBJdbConnection2)

	Do Until rsEvents.EOF

	  strDate = FormatDateTime(rsEvents("EventDate"),vbShortDate)
	  Select Case Weekday(rsEvents("EventDate"))
		Case 1
			strWeekDay = "Sun."
		Case 2
			strWeekDay = "Mon."
		Case 3
			strWeekDay = "Tue."
		Case 4
			strWeekDay = "Wed."
		Case 5
			strWeekDay = "Thu."
		Case 6
			strWeekDay = "Fri."
		Case 7
			strWeekDay = "Sat."
	  End Select
	  
	  strTime = Left(FormatDateTime(rsEvents("EventDate"),vbLongTime),Len(FormatDateTime(rsEvents("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsEvents("EventDate"),vbLongTime),3)
	  
	  'REE 5/14/3 - Added ActSuffix
	  SQLActSuffix = "SELECT OptionValue AS ActSuffix FROM EventOptions (NOLOCK) WHERE EventCode = " & rsEvents("EventCode") & " AND OptionName = 'ActSuffix'"
	  Set rsActSuffix = OBJdbConnection2.Execute(SQLActSuffix)
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
        Set rsDateSuppress = OBJdbConnection2.Execute(SQLDateSuppress)
        If rsDateSuppress.EOF Then
	        DisplayDate = DisplayDate & strWeekDay & "&nbsp;" & strDate
        End If
        rsDateSuppress.Close
        Set rsDateSuppress = nothing

        SQLTimeSuppress = "SELECT OptionValue AS TimeSuppress FROM EventOptions (NOLOCK) WHERE EventCode = " & rsEvents("EventCode") & " AND OptionName = 'TimeSuppress' AND OptionValue = 'Y'"
        Set rsTimeSuppress = OBJdbConnection2.Execute(SQLTimeSuppress)
        If rsTimeSuppress.EOF Then
	        DisplayDate = DisplayDate & "<BR>at " & strTime
        End If
        rsTimeSuppress.Close
        Set rsTimeSuppress = nothing

     ' If rsEvents("Map") = "general" Then
        QtyInfo = "<TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=1><INPUT TYPE=""hidden"" NAME=""EventCode"" VALUE=""" & rsEvents("EventCode") & """><INPUT TYPE=""text"" NAME=""SeatCount"" SIZE=""1""></FONT></TD>"
      'Else 
        'QtyInfo = "<TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=//Event.asp?Event=" & rsEvents("EventCode") & """ onmouseover=""ttDelay=setTimeout('eventTooltip(\'/AJAX/EventInfo.asp?EventCode=" & rsEvents("EventCode") & "\', this)', 200);"" onmouseout=""clearTimeout(ttDelay);hideTooltip();"">Tix & Info</A>&nbsp;</FONT></TD>"
      'End If
      
	  If IncludeVenueLocation Then
		Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=8 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD>&nbsp;&nbsp;</TD><TD ALIGN=left NOWRAP><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1>" & DisplayDate & "</FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><B>" & rsEvents("Act") & ActSuffix & "</B></A></FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1>" & rsEvents("Venue") & "<BR>" & rsEvents("City") & ", " & rsEvents("State") & "</FONT></TD><TD>&nbsp;&nbsp;</TD>" & QtyInfo & "</TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=8 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=8 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
	  Else
		Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=6 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD>&nbsp;&nbsp;</TD><TD ALIGN=left NOWRAP><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1>" & DisplayDate & "</FONT></TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><B>" & rsEvents("Act") & ActSuffix & "</B></A></FONT></TD><TD>&nbsp;&nbsp;</TD>" & QtyInfo & "</TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=6 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=6 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif"" ALT=""""></TD></TR>" & vbCrLf
	  End If	
	  events="Y"
	  rsEvents.MoveNext

	Loop

	Call DBClose(OBJdbConnection2)

    If IncludeVenueLocation Then
	    Response.Write "<TR><TD COLSPAN=8 ALIGN=RIGHT><FONT FACE=verdana,arial,helvetica SIZE=1><BR><INPUT TYPE=submit VALUE='Add to Cart' id=submit1 name=submit1></FONT></TD></TR><BR>" & vbCrLf
    Else
	    Response.Write "<TR><TD COLSPAN=6 ALIGN=RIGHT><FONT FACE=verdana,arial,helvetica SIZE=1><BR><INPUT TYPE=submit VALUE='Add to Cart' id=submit1 name=submit1></FONT></TD></TR><BR>" & vbCrLf
    End If
	Response.Write "<TR><TD COLSPAN=8 ALIGN=RIGHT><FONT FACE=verdana,arial,helvetica SIZE=1><B><BR>Enter ticket quantities above, then click ""Add to Cart""<BR></B></FONT></TD></TR>" & vbCrLf
	Response.Write "</TABLE></FORM></CENTER><BR>" & vbCrLf
Else
	Response.Write "<BR><CENTER><FONT FACE=verdana,arial,helvetica SIZE=2>There are no events on sale at this time.</CENTER><BR>" & vbCrLf
End If

rsEvents.Close
Set rsEvents = nothing
	


%>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%
End Sub


Sub AddToCart

Dim Seats(20)
Message = ""


SectionCode = "GA"


If Session("OrderNumber") <> "" Then 'There's an order number.  Check the status of the order.
	SQLOrderHeader = "SELECT StatusCode From OrderHeader WITH (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber")
	Set rsOrderHeader = OBJdbConnection.Execute(SQLOrderHeader)
	If rsOrderHeader("StatusCode") = "S" Then 
		Session("OrderNumber") = "" 'If the order has been completed, clear the Session("OrderNumber") and create a new one.
	End If
	rsOrderHeader.Close
	Set rsOrderHeader = nothing
End If

'Create an Order Header if Necessary
If Session("OrderNumber") = "" Then 
	If Session("CustomerNumber") = "" Then
		CustomerNumber = 1
	Else
		CustomerNumber = Session("CustomerNumber")
	End If

	'Check to see if this is a box office entry.  If so, set up the UserNumber
	If Session("UserNumber") <> "" Then
		UserNumber = Session("UserNumber")
	Else
		UserNumber = 0
	End If

	'REE 11/24/2 - Added ExpirationDate to OrderHeader

	'Set Default Expiration to 30 minutes from now using TimeOffset.  UnReserve will catch it 30 minutes from now.
	OrderExpirationDate = DateAdd("n", 30 + (TimeOffset() * -1), Now())

	'Get TimeZone Offset for VenueOwner Organization
	SQLLocalOffset = "SELECT OrganizationOptions.OrganizationNumber, OptionValue AS LocalOffset FROM Event (NOLOCK) INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Venue.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationOptions (NOLOCK) ON OrganizationVenue.OrganizationNumber = OrganizationOptions.OrganizationNumber WHERE Event.EventCode = " & Clean(Request("EventCode")(1)) & " AND OrganizationVenue.Owner <> 0 AND OrganizationOptions.OptionName = 'TimeZoneOffset'"
	Set rsLocalOffset = OBJdbConnection.Execute(SQLLocalOffset)
	
	If Not rsLocalOffset.EOF Then 'Get Expiration Delay for VenueOwner Organization
		SQLExpirationDelay = "SELECT OptionValue As ExpirationDelay FROM OrganizationOptions (NOLOCK) WHERE OrganizationNumber = " & rsLocalOffset("OrganizationNumber") & " AND OptionName = 'OrderExpirationDelay'"
		Set rsExpirationDelay = OBJdbConnection.Execute(SQLExpirationDelay)
		
		If Not rsExpirationDelay.EOF Then 'Set the ExpirationDate based on Offset and Delay
			OrderExpirationDate = DateAdd("n", (rsLocalOffset("LocalOffset") - TimeOffset()) + rsExpirationDelay("ExpirationDelay"), Now())
		End If
		
		rsExpirationDelay.close
		Set rsExpirationDelay = nothing
	End If
	
	rsLocalOffset.close
	Set rsLocalOffset = nothing

	'REE 5/29/3 - Added the user IP Address
	IPAddress = Request.ServerVariables("REMOTE_ADDR")
		
	Set spInsertOrderHeader = Server.Createobject("Adodb.Command")
	Set spInsertorderHeader.ActiveConnection = OBJdbConnection
	spInsertOrderHeader.Commandtype = 4 ' Value for Stored Procedure
	spInsertOrderHeader.Commandtext = "spInsertOrderHeader"
	spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("OrderNumber", 3, 4) 'As Integer and ParamReturnValue
	spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("CustomerNumber", 3, 1, , CustomerNumber) 'As Integer and Input
	spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("OrderTypeNumber", 3, 1, , Session("OrderTypeNumber")) 'As Integer and Input
	spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("UserNumber", 3, 1, , UserNumber) 'As Integer and Input
	spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("OrderExpirationDate", 7, 1, , OrderExpirationDate) 'As Date and Input
	spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("IPAddress", 200, 1, 15, IPAddress) 'As Varchar and Input
	spInsertOrderHeader.Execute

	Session("OrderNumber") = spInsertOrderHeader.Parameters("OrderNumber")

	If Session("OrderNumber") = 0 Then
		Message = Message & "There was a problem processing your request.  Please try again later.  "
		Session.Contents.Remove("OrderNumber")
		Call EventForm(Message)
	End If

End If

'**********************
'Reserve the seats
'**********************
SeatsAdded =FALSE
For EventCountLoop = 1 To Request("SeatCount").Count
	If IsNumeric(Request("SeatCount")(EventCountLoop)) Then
		SeatCount = Fix(Request("SeatCount")(EventCountLoop))
		EventCode = Clean(Request("EventCode")(EventCountLoop))
	
		SQLAvailable = "SELECT Count(LineNumber) AS ExistingSeats FROM Orderline (NOLOCK) LEFT JOIN Seat (NOLOCK) ON Orderline.ItemNumber = Seat.ItemNumber WHERE Orderline.OrderNumber = " & Session("OrderNumber") & " AND EventCode = " & EventCode & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent', 'SubSeat')"
		Set rsAvailable = OBJdbConnection.Execute(SQLAvailable)
		ExistingSeatCount = rsAvailable("ExistingSeats")
		rsAvailable.Close
		Set rsAvailable = Nothing
		TotalSeatCount = ExistingSeatCount + SeatCount
%>

<!--#INCLUDE VIRTUAL="TicketMaxInclude.asp" -->

<%
		If TotalSeatCount <= MaxTickets Then 'Process Request

			SQLEventType = "SELECT EventType FROM Event (NOLOCK) WHERE EventCode = " & EventCode
			Set rsEventType = OBJdbConnection.Execute(SQLEventType)
			
			Select Case rsEventType("EventType")
			Case "SubFixedEvent" 'Fixed Event Subscription

				Set spEventReserveSeatsSubFixedEvent = Server.Createobject("Adodb.Command")
				Set spEventReserveSeatsSubFixedEvent.ActiveConnection = OBJdbConnection
				spEventReserveSeatsSubFixedEvent.Commandtype = 4 ' Value for Stored Procedure
				spEventReserveSeatsSubFixedEvent.Commandtext = "spEventReserveSeatsSubFixedEvent"
				spEventReserveSeatsSubFixedEvent.Parameters.Append spEventReserveSeatsSubFixedEvent.CreateParameter("ReturnCode", 3, 4) 'As Integer and ParamReturnValue
				spEventReserveSeatsSubFixedEvent.Parameters.Append spEventReserveSeatsSubFixedEvent.CreateParameter("EventCode", 3, 1, , EventCode) 'As Integer and Input
				spEventReserveSeatsSubFixedEvent.Parameters.Append spEventReserveSeatsSubFixedEvent.CreateParameter("OrderNumber", 3, 1, , Session("OrderNumber")) 'As Integer and Input
				spEventReserveSeatsSubFixedEvent.Parameters.Append spEventReserveSeatsSubFixedEvent.CreateParameter("SeatCount", 3, 1, , SeatCount) 'As Integer and Input
				spEventReserveSeatsSubFixedEvent.Parameters.Append spEventReserveSeatsSubFixedEvent.CreateParameter("SectionCode", 200, 1, 5, SectionCode) 'As Varchar and Input with Section Code for General Admission events.
				spEventReserveSeatsSubFixedEvent.Execute
				
				ReturnCode = spEventReserveSeatsSubFixedEvent.Parameters("ReturnCode")
			
			Case Else

				Set spEventReserveSeats = Server.Createobject("Adodb.Command")
				Set spEventReserveSeats.ActiveConnection = OBJdbConnection
				spEventReserveSeats.Commandtype = 4 ' Value for Stored Procedure
				spEventReserveSeats.Commandtext = "spEventReserveSeats"
				spEventReserveSeats.Parameters.Append spEventReserveSeats.CreateParameter("ReturnCode", 3, 4) 'As Integer and ParamReturnValue
				spEventReserveSeats.Parameters.Append spEventReserveSeats.CreateParameter("EventCode", 3, 1, , EventCode) 'As Integer and Input
				spEventReserveSeats.Parameters.Append spEventReserveSeats.CreateParameter("OrderNumber", 3, 1, , Session("OrderNumber")) 'As Integer and Input
				spEventReserveSeats.Parameters.Append spEventReserveSeats.CreateParameter("SeatCount", 3, 1, , SeatCount) 'As Integer and Input
				spEventReserveSeats.Parameters.Append spEventReserveSeats.CreateParameter("SectionCode", 200, 1, 5, SectionCode) 'As Varchar and Input with Section Code for General Admission events.
				spEventReserveSeats.Execute

				ReturnCode = spEventReserveSeats.Parameters("ReturnCode")
		    End Select

			Select Case ReturnCode
				Case 0	'Stored Procedure executed properly.  Continue.
					SeatsAdded = TRUE
				Case 1	'SQL database error.
					Message = Message & "There was a problem processing your request.  Please try again later.  "
				Case 2	'Seats not available.
					SQLEvents = "SELECT Map From Event (NOLOCK) WHERE EventCode = " & EventCode
					Set rsEvents = OBJdbConnection.Execute(SQLEvents)

					If rsEvents("Map") <> "general" And Clean(Request("Section")) <> "" Then
						SelectionType = "section"
					Else
						SelectionType = "event"
					End If
					rsEvents.Close
					Set rsEvents = nothing
					If SeatCount = 1 Then
						Message = Message & "There are no tickets available for this " & SelectionType & ".  "
					Else
						Message = Message & "There are not " & SeatCount & " tickets available for this " & SelectionType & ".  "
					End If
				Case Else
					Message = Message & "There was a problem processing your request.  Please try again later.  "
			End Select
		Else
			Message = Message & "The maximum number of seats allowed is " & MaxTickets & " per event.  "
		End If

	End If
Next

If SeatsAdded Then
	OBJdbConnection.Close
	Set OBJdbConnection = nothing
	Response.Redirect("/ShoppingCart.asp")
Else
	Call EventForm(Message)
End If

End Sub


%>