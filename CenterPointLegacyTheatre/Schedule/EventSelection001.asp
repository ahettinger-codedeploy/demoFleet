<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<%

Page = "ManagementEventSelection"

If Session("UserNumber") = "" Then 
	OBJdbConnection.Close
	Set OBJdbConnection = nothing
	Response.Redirect("Default.asp")
End If
If Session("OrganizationNumber") = "" Then 
	OBJdbConnection.Close
	Set OBJdbConnection = nothing
	Response.Redirect("Default.asp")
End If

HeadingFontColor = "#008400"
FontColor = "#000000"
FontFace = "verdana,arial,helvetica"

%>
<HTML>

<HEAD>

<TITLE>www.TIX.com - Event Selection</TITLE>

<script src="http://code.jquery.com/jquery-latest.js"></script>

<script>
	$(document).ready(function(){
		
		$(".buttons").click(function () {
		var divname= this.value;
		  $("#"+divname).show("slow").siblings().hide("slow");
		});
	
	  });
</script> 

</HEAD>

<BODY BGCOLOR="#FFFFFF">

<CENTER>

<!--#INCLUDE VIRTUAL="TopNavInclude.asp"-->

<BR>

<fieldset>
<legend>Venue Code Selection</legend> 
<div id="buttonsDiv"> 
<input type="button" id="button1" class="buttons" value="Venue1"></input>
<input type="button" id="button2" class="buttons" value="Venue2"></input>
</div>
</fieldset>


<FONT FACE="verdana,arial,helvetica" COLOR="#008400"><H3>Ticket Sales</H3></FONT>

<%

'REE 4/6/2 - Modified to include OrganizationAct selection criteria
'REE 4/10/2 - Modified to include Sale Start Date and OnSale criteria
'REE 6/26/2 - Modified to allow sales prior to Sale Start Date
'REE 9/13/2 - Modified to allow sales for the entire day of the event

If Session("USerType") = "C" Then
	EventStart = FormatDateTime(Now(), vbShortDate)
Else
	EventStart = FormatDateTime(Now() - .25, vbShortDate)
	Response.Write "<FONT FACE=verdana,arial,helvetica COLOR=#FFFFFF SIZE=2><A HREF=EventSelectionPast.asp>(Click Here for Past Events)</A><BR><BR>"
End If

Response.Write "<TABLE CELLSPACING=0 CELLPADDING=1 WIDTH=85% BORDER=0>" & vbCrLf

SQLUsers = "SELECT UserType FROM Users (NOLOCK) WHERE UserNumber = " & Session("UserNumber")
Set rsUsers = OBJdbConnection.Execute(SQLUsers)
If Not IsNull(rsUsers("UserType")) Then
	UserType = rsUsers("UserType")
Else
	UserType = ""
End If
rsUsers.Close
Set rsUsers = nothing


'List Subscriptions First
'Do not change the following line without changing the appropriate GetRows array
SQLEvents = "SELECT EventDate, Map, Act, Event.EventCode, SeatCount, SaleEndDate, City, State, ActSuffix.ActSuffix FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode LEFT JOIN (SELECT Seat.EventCode, COUNT(ItemNumber) AS SeatCount FROM Seat (NOLOCK) INNER JOIN Event (NOLOCK) on Seat.EventCode = Event.EventCode WHERE StatusCode  = 'A' AND EventDate > GetDate()-.25 GROUP BY Seat.EventCode) TicketCount ON Event.EventCode = TicketCount.EventCode LEFT JOIN (SELECT EventCode, ' - ' + OptionValue AS ActSuffix FROM EventOptions (NOLOCK) WHERE OptionName = 'ActSuffix') AS ActSuffix ON Event.EventCode = ActSuffix.EventCode WHERE OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND EventDate >= '" & EventStart & "' AND OnSale <> 0 AND Event.EventType = 'SubFixedEvent'"
If Request("ActCode") <> "" Then
	SQLEvents = SQLEvents & " AND Act.ActCode IN (" & Clean(Request("ActCode")) & ")"
End If
SQLEvents = SQLEvents & " ORDER BY EventDate"
Set rsEvents = OBJdbConnection.Execute(SQLEvents)

If Not rsEvents.EOF Then

	If Session("OrderTypeNumber") = 7 Then
	    Response.Write "<TR BGCOLOR=#008400><TD ALIGN=center><FONT FACE=verdana,arial,helvetica COLOR=#FFFFFF SIZE=2><B>Date/Time</B></FONT></TD><TD ALIGN=center WIDTH=""40%""><FONT FACE=verdana,arial,helvetica COLOR=#FFFFFF SIZE=2><B>Event</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica COLOR=#FFFFFF SIZE=2><B>Available<BR>Tickets</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica COLOR=#FFFFFF SIZE=2><B>Quick<BR>Sale</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica COLOR=#FFFFFF SIZE=2><B>Best<BR>Available</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica COLOR=#FFFFFF SIZE=2><B>Select<BR>Seats</B></FONT></TD></TR>"
	    ColNum = 6
	Else
	    Response.Write "<TR BGCOLOR=#008400><TD ALIGN=center><FONT FACE=verdana,arial,helvetica COLOR=#FFFFFF SIZE=2><B>Date/Time</B></FONT></TD><TD ALIGN=center WIDTH=""40%""><FONT FACE=verdana,arial,helvetica COLOR=#FFFFFF SIZE=2><B>Event</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica COLOR=#FFFFFF SIZE=2><B>Available<BR>Tickets</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica COLOR=#FFFFFF SIZE=2><B>Best<BR>Available</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica COLOR=#FFFFFF SIZE=2><B>Select<BR>Seats</B></FONT></TD></TR>"
	    ColNum = 5
	End If
	
	Response.Write "<TR BGCOLOR=#FFFFFF><TD COLSPAN=" & ColNum & " HEIGHT=1></TD></TR>" & vbCrLf
	Response.Write "<TR BGCOLOR=#008400><TD COLSPAN=" & ColNum & " HEIGHT=1></TD></TR>" & vbCrLf

	CellBGColor = "#FFFFFF"

	Do Until rsEvents.EOF

		If Hour(rsEvents("EventDate")) >= 12 Then
			APM = "PM"
		Else
			APM = "AM"
		End If

		If Hour(rsEvents("EventDate")) > 12 Then 
			EventHour = Hour(rsEvents("EventDate")) - 12
		Else
			EventHour = Hour(rsEvents("EventDate"))
		End If
		
		Response.Write "<TR BGCOLOR=" & CellBGColor & "><TD COLSPAN=" & ColNum & " HEIGHT=2></TD></TR>" & vbCrLf

		If IsNull(rsEvents("SeatCount")) Then
			AvailableSeatCount = 0
		Else
			AvailableSeatCount = FormatNumber(rsEvents("SeatCount"),0)
		End If

		If rsEvents("Map") <> "general" Then
			Response.Write "<TR BGCOLOR=" & CellBGColor & "><TD ALIGN=left><FONT FACE=verdana,arial,helvetica COLOR=#333333 SIZE=1><B>" & WeekDayName(Weekday(rsEvents("EventDate")),TRUE) & "&nbsp;" & FormatDateTime(rsEvents("EventDate"), vbShortDate) & "</B><BR>at " & EventHour & ":" & Right("00" & Minute(rsEvents("EventDate")),2) & " " & APM & "</FONT></TD><TD ALIGN=left><FONT FACE=verdana,arial,helvetica COLOR=#333383 SIZE=1><B>" & rsEvents("Act") & rsEvents("ActSuffix") & "</B><BR>" & rsEvents("City") & ", " & rsEvents("State") & "</FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica COLOR=#333333 SIZE=1>" & AvailableSeatCount & "</TD>"
			
			'REE 2/7/9 - Added Quick Sale
			If Session("OrderTypeNumber") = 7 Then
			    Response.Write "<TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=1><A HREF=QuickSaleTouchScreen.asp?EventCode=" & rsEvents("EventCode") & ">Quick</A></FONT></TD>"
			End If
			
			Response.Write "<TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=1><A HREF=BestAvailable.asp?Event=" & rsEvents("EventCode") & ">Best</A></FONT></TD>"
			Response.Write "<TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=1>"
			If  rsEvents("SaleEndDate") > Now() Or UserType <> "C" Then

				'REE 11/05/7 - Modified to use Generic Map File if custom map file does not exist.
				MapFile = Server.MapPath(rsEvents("Map") & ".asp")  
								
				Set FS=Server.CreateObject("Scripting.FileSystemObject")
				If FS.FileExists(MapFile)=TRUE Then
				  MapScript = rsEvents("Map") & ".asp"
				Else
				   MapScript = "GenericMap.asp"
				End If
				Set FS=nothing

				Response.Write "<A HREF=" & MapScript & "?Event=" & rsEvents("EventCode") & ">Select</A>"

			End If
			Response.Write "</FONT></TD>"
			Response.Write "</TR>" & vbCrLf
		Else
		    'REE 2/7/9 - Added QuickSale
			If Session("OrderTypeNumber") = 7 Then
		        Response.Write "<TR BGCOLOR=" & CellBGColor & "><TD ALIGN=left><FONT FACE=verdana,arial,helvetica COLOR=#333333 SIZE=1><B>" & WeekDayName(Weekday(rsEvents("EventDate")),TRUE) & "&nbsp;" & FormatDateTime(rsEvents("EventDate"), vbShortDate) & "</B><BR>at " & EventHour & ":" & Right("00" & Minute(rsEvents("EventDate")),2) & " " & APM & "</FONT></TD><TD ALIGN=left><FONT FACE=verdana,arial,helvetica COLOR=#333383 SIZE=1><B>" & rsEvents("Act") & rsEvents("ActSuffix") & "</B><BR>" & rsEvents("City") & ", " & rsEvents("State") & "</FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica COLOR=#333333 SIZE=1>" & AvailableSeatCount & "</TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=1><A HREF=QuickSaleTouchScreen.asp?EventCode=" & rsEvents("EventCode") & ">Quick</A></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=1><A HREF=Event.asp?Event=" & rsEvents("EventCode") & ">Sell</A></FONT></TD><TD>&nbsp;</TD></TR>" & vbCrLf
			Else
			    Response.Write "<TR BGCOLOR=" & CellBGColor & "><TD ALIGN=left><FONT FACE=verdana,arial,helvetica COLOR=#333333 SIZE=1><B>" & WeekDayName(Weekday(rsEvents("EventDate")),TRUE) & "&nbsp;" & FormatDateTime(rsEvents("EventDate"), vbShortDate) & "</B><BR>at " & EventHour & ":" & Right("00" & Minute(rsEvents("EventDate")),2) & " " & APM & "</FONT></TD><TD ALIGN=left><FONT FACE=verdana,arial,helvetica COLOR=#333383 SIZE=1><B>" & rsEvents("Act") & rsEvents("ActSuffix") & "</B><BR>" & rsEvents("City") & ", " & rsEvents("State") & "</FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica COLOR=#333333 SIZE=1>" & AvailableSeatCount & "</TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=1><A HREF=Event.asp?Event=" & rsEvents("EventCode") & ">Sell</A></FONT></TD><TD>&nbsp;</TD></TR>" & vbCrLf
		    End If
		End If
		Response.Write "<TR BGCOLOR=" & CellBGColor & "><TD COLSPAN=" & ColNum & " HEIGHT=2></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=#008400><TD COLSPAN=" & ColNum & " HEIGHT=1></TD></TR>" & vbCrLf

		If CellBGColor = "#FFFFFF" Then 
			CellBGColor = "#EEEEEE"
		Else
			CellBGColor = "#FFFFFF"
		End If

		rsEvents.MoveNext
	Loop
'	Response.Write "</TABLE></CENTER><BR>" & vbCrLf
Else
	Response.Write "<BR><CENTER><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#000000>There are no subscription events on sale at this time.</CENTER><BR>" & vbCrLf
End If
rsEvents.Close
Set rsEvents = nothing

'List Individual shows.

'Do not change the following line without changing the appropriate GetRows array
SQLEvents = "SELECT EventDate, Map, Act, Event.EventCode, SeatCount, SaleEndDate, City, State, ActSuffix.ActSuffix FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode LEFT JOIN (SELECT Seat.EventCode, COUNT(ItemNumber) AS SeatCount FROM Seat (NOLOCK) INNER JOIN Event (NOLOCK) on Seat.EventCode = Event.EventCode WHERE StatusCode  = 'A' AND EventDate > GetDate()-.25 GROUP BY Seat.EventCode) TicketCount ON Event.EventCode = TicketCount.EventCode LEFT JOIN (SELECT EventCode, ' - ' + OptionValue AS ActSuffix FROM EventOptions (NOLOCK) WHERE OptionName = 'ActSuffix') AS ActSuffix ON Event.EventCode = ActSuffix.EventCode WHERE OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND EventDate >= '" & EventStart & "' AND OnSale <> 0 AND (Event.EventType <> 'SubFixedEvent' OR Event.EventType IS NULL)"
If Request("ActCode") <> "" Then
	SQLEvents = SQLEvents & " AND Act.ActCode IN (" & Clean(Request("ActCode")) & ")"
End If
SQLEvents = SQLEvents & " ORDER BY EventDate"
Set rsEvents = OBJdbConnection.Execute(SQLEvents)

If Not rsEvents.EOF Then

	If Session("OrderTypeNumber") = 7 Then
	    Response.Write "<TR BGCOLOR=#008400><TD ALIGN=center><FONT FACE=verdana,arial,helvetica COLOR=#FFFFFF SIZE=2><B>Date/Time</B></FONT></TD><TD ALIGN=center WIDTH=""40%""><FONT FACE=verdana,arial,helvetica COLOR=#FFFFFF SIZE=2><B>Event</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica COLOR=#FFFFFF SIZE=2><B>Available<BR>Tickets</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica COLOR=#FFFFFF SIZE=2><B>Quick<BR>Sale</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica COLOR=#FFFFFF SIZE=2><B>Best<BR>Available</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica COLOR=#FFFFFF SIZE=2><B>Select<BR>Seats</B></FONT></TD></TR>"
	    ColNum = 6
	Else
	    Response.Write "<TR BGCOLOR=#008400><TD ALIGN=center><FONT FACE=verdana,arial,helvetica COLOR=#FFFFFF SIZE=2><B>Date/Time</B></FONT></TD><TD ALIGN=center WIDTH=""40%""><FONT FACE=verdana,arial,helvetica COLOR=#FFFFFF SIZE=2><B>Event</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica COLOR=#FFFFFF SIZE=2><B>Available<BR>Tickets</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica COLOR=#FFFFFF SIZE=2><B>Best<BR>Available</B></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica COLOR=#FFFFFF SIZE=2><B>Select<BR>Seats</B></FONT></TD></TR>"
	    ColNum = 5
	End If
	
	Response.Write "<TR BGCOLOR=#FFFFFF><TD COLSPAN=" & ColNum & " HEIGHT=1></TD></TR>" & vbCrLf
	Response.Write "<TR BGCOLOR=#008400><TD COLSPAN=" & ColNum & " HEIGHT=1></TD></TR>" & vbCrLf

	CellBGColor = "#FFFFFF"

	Do Until rsEvents.EOF

		If Hour(rsEvents("EventDate")) >= 12 Then
			APM = "PM"
		Else
			APM = "AM"
		End If

		If Hour(rsEvents("EventDate")) > 12 Then 
			EventHour = Hour(rsEvents("EventDate")) - 12
		Else
			EventHour = Hour(rsEvents("EventDate"))
		End If
		
		Response.Write "<TR BGCOLOR=" & CellBGColor & "><TD COLSPAN=" & ColNum & " HEIGHT=2></TD></TR>" & vbCrLf

		If IsNull(rsEvents("SeatCount")) Then
			AvailableSeatCount = 0
		Else
			AvailableSeatCount = FormatNumber(rsEvents("SeatCount"),0)
		End If

		If rsEvents("Map") <> "general" Then
			Response.Write "<TR BGCOLOR=" & CellBGColor & "><TD ALIGN=left><FONT FACE=verdana,arial,helvetica COLOR=#333333 SIZE=1><B>" & WeekDayName(Weekday(rsEvents("EventDate")),TRUE) & "&nbsp;" & FormatDateTime(rsEvents("EventDate"), vbShortDate) & "</B><BR>at " & EventHour & ":" & Right("00" & Minute(rsEvents("EventDate")),2) & " " & APM & "</FONT></TD><TD ALIGN=left><FONT FACE=verdana,arial,helvetica COLOR=#333383 SIZE=1><B>" & rsEvents("Act") & rsEvents("ActSuffix") & "</B><BR>" & rsEvents("City") & ", " & rsEvents("State") & "</FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica COLOR=#333333 SIZE=1>" & AvailableSeatCount & "</TD>"
			
			'REE 2/7/9 - Added Quick Sale
			If Session("OrderTypeNumber") = 7 Then
			    Response.Write "<TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=1><A HREF=QuickSaleTouchScreen.asp?EventCode=" & rsEvents("EventCode") & ">Quick</A></FONT></TD>"
			End If
			
			Response.Write "<TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=1><A HREF=BestAvailable.asp?Event=" & rsEvents("EventCode") & ">Best</A></FONT></TD>"
			Response.Write "<TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=1>"
			If  rsEvents("SaleEndDate") > Now() Or UserType <> "C" Then

				'REE 11/5/7 - Modified to use Generic Map File if custom map file does not exist.
				MapFile = Server.MapPath(rsEvents("Map") & ".asp")  
								
				Set FS=Server.CreateObject("Scripting.FileSystemObject")
				If FS.FileExists(MapFile)=TRUE Then
				  MapScript = rsEvents("Map") & ".asp"
				Else
				   MapScript = "GenericMap.asp"
				End If
				Set FS=nothing

				Response.Write "<A HREF=" & MapScript & "?Event=" & rsEvents("EventCode") & ">Select</A>"
			End If
			Response.Write "</FONT></TD>"
			Response.Write "</TR>" & vbCrLf
		Else
		    'REE 2/7/9 - Added QuickSale
			If Session("OrderTypeNumber") = 7 Then
			    Response.Write "<TR BGCOLOR=" & CellBGColor & "><TD ALIGN=left><FONT FACE=verdana,arial,helvetica COLOR=#333333 SIZE=1><B>" & WeekDayName(Weekday(rsEvents("EventDate")),TRUE) & "&nbsp;" & FormatDateTime(rsEvents("EventDate"), vbShortDate) & "</B><BR>at " & EventHour & ":" & Right("00" & Minute(rsEvents("EventDate")),2) & " " & APM & "</FONT></TD><TD ALIGN=left><FONT FACE=verdana,arial,helvetica COLOR=#333383 SIZE=1><B>" & rsEvents("Act") & rsEvents("ActSuffix") & "</B><BR>" & rsEvents("City") & ", " & rsEvents("State") & "</FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica COLOR=#333333 SIZE=1>" & AvailableSeatCount & "</TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=1><A HREF=QuickSaleTouchScreen.asp?EventCode=" & rsEvents("EventCode") & ">Quick</A></FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=1><A HREF=Event.asp?Event=" & rsEvents("EventCode") & ">Sell</A></FONT></TD><TD>&nbsp;</TD></TR>" & vbCrLf
			Else
			    Response.Write "<TR BGCOLOR=" & CellBGColor & "><TD ALIGN=left><FONT FACE=verdana,arial,helvetica COLOR=#333333 SIZE=1><B>" & WeekDayName(Weekday(rsEvents("EventDate")),TRUE) & "&nbsp;" & FormatDateTime(rsEvents("EventDate"), vbShortDate) & "</B><BR>at " & EventHour & ":" & Right("00" & Minute(rsEvents("EventDate")),2) & " " & APM & "</FONT></TD><TD ALIGN=left><FONT FACE=verdana,arial,helvetica COLOR=#333383 SIZE=1><B>" & rsEvents("Act") & rsEvents("ActSuffix") & "</B><BR>" & rsEvents("City") & ", " & rsEvents("State") & "</FONT></TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica COLOR=#333333 SIZE=1>" & AvailableSeatCount & "</TD><TD ALIGN=center><FONT FACE=verdana,arial,helvetica SIZE=1><A HREF=Event.asp?Event=" & rsEvents("EventCode") & ">Sell</A></FONT></TD><TD>&nbsp;</TD></TR>" & vbCrLf
		    End If
		End If
		Response.Write "<TR BGCOLOR=" & CellBGColor & "><TD COLSPAN=" & ColNum & " HEIGHT=2></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=#008400><TD COLSPAN=" & ColNum & " HEIGHT=1></TD></TR>" & vbCrLf

		If CellBGColor = "#FFFFFF" Then 
			CellBGColor = "#EEEEEE"
		Else
			CellBGColor = "#FFFFFF"
		End If

		rsEvents.MoveNext
	Loop
	Response.Write "</TABLE></CENTER><BR>" & vbCrLf
Else
	Response.Write "<BR><CENTER><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#000000>There are no events on sale at this time.</CENTER><BR>" & vbCrLf
End If
rsEvents.Close
Set rsEvents = nothing
	
'REE 10/11/3 - Modified to include Donation/Memberships
SQLDonation = "SELECT Donation.OrganizationNumber, Organization.Organization FROM Donation (NOLOCK) INNER JOIN Organization (NOLOCK) ON Donation.OrganizationNumber = Organization.OrganizationNumber WHERE Donation.OrganizationNumber = " & Session("OrganizationNumber") & " OR Donation.RemittalOrganizationNumber = " & Session("OrganizationNumber") & " AND Donation.StatusCode = 'A' AND OffLineDonationFlag = 1 GROUP BY Donation.OrganizationNumber, Organization.Organization ORDER BY Organization.Organization"
Set rsDonation = OBJdbConnection.Execute(SQLDonation)

If Not rsDonation.EOF Then
	Response.Write "<CENTER><TABLE CELLSPACING=0 CELLPADDING=3 WIDTH=85% BORDER=0>" & vbCrLf

	Response.Write "<TR BGCOLOR=#008400><TD ALIGN=left><FONT FACE=verdana,arial,helvetica COLOR=#FFFFFF SIZE=2><B>Donation/Membership</B></FONT></TD><TD><FONT FACE=verdana,arial,helvetica COLOR=#FFFFFF SIZE=2><B>Sell</B></FONT></TD></TR>" & vbCrLf
	Response.Write "<TR BGCOLOR=#FFFFFF><TD COLSPAN=5 HEIGHT=1></TD></TR>" & vbCrLf
	Response.Write "<TR BGCOLOR=#008400><TD COLSPAN=5 HEIGHT=1></TD></TR>" & vbCrLf

	CellBGColor = "#FFFFFF"

	Do Until rsDonation.EOF

		Response.Write "<TR BGCOLOR=" & CellBGColor & "><TD ALIGN=left><FONT FACE=verdana,arial,helvetica COLOR=#333333 SIZE=1>" & rsDonation("Organization") & " Donation/Membership</A></FONT></TD><TD><FONT FACE=verdana,arial,helvetica COLOR=#333333 SIZE=1><A HREF=Donation.asp?OrganizationNumber=" & rsDonation("OrganizationNumber") & ">Sell</A></FONT></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=" & CellBGColor & "><TD COLSPAN=5 HEIGHT=2></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=#008400><TD COLSPAN=5 HEIGHT=1></TD></TR>" & vbCrLf
		
		rsDonation.MoveNext
	Loop
	
	Response.Write "</TABLE></CENTER><BR><BR>" & vbCrLf

End If

rsDonation.Close
Set rsDonation = nothing

%>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%
OBJdbConnection.Close
Set OBJdbConnection = nothing
%>