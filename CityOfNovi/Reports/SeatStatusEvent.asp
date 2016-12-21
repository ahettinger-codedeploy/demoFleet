<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<%
Page = "SeatStatusEvent"

If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then Response.Redirect("/Management/Default.asp")

If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then Response.Redirect("/Management/Default.asp")

%>
<HTML>
<HEAD>
<TITLE>Tix - Seat Status Event Selection</TITLE>
<style type="text/css">
<!--
a.sort:link  {color: #FFFFFF; font-weight: bold; text-decoration: underline;}
a.sort:visited  {color: #FFFFFF; font-weight: bold; text-decoration: underline;}
a.sort:active  {color: #FFFFFF; font-weight: bold; text-decoration: underline;}
a.sort:hover  {color: #FFFFFF; font-weight: bold; text-decoration: underline;}
-->
</style>
</HEAD>
<BODY BGCOLOR="#FFFFFF">
<CENTER>

<!--#INCLUDE VIRTUAL="TopNavInclude.asp" -->

<BR>

<BR>

<FONT FACE="verdana,arial,helvetica" COLOR="#008400"><H3>Seat Status Maintenance</H3></FONT>


<%

'REE 4/6/2 - Modified to include OrganizationAct selection criteria
'REE 1/17/5 - Modified to only display events that are no more than a day in the past.
Select Case Request("SortMethod")
	Case "Act"
		SQLEvents = "SELECT EventDate, Map, Event.EventCode, Act, Venue FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Venue (NOLOCK) ON OrganizationVenue.VenueCode = Venue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE EventDate > GETDATE() - 1 AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND Event.Map <> 'general' ORDER BY Act, Venue, EventDate"
	Case "Venue"
		SQLEvents = "SELECT EventDate, Map, Event.EventCode, Act, Venue FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Venue (NOLOCK) ON OrganizationVenue.VenueCode = Venue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE EventDate > GETDATE() - 1 AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND Event.Map <> 'general' ORDER BY Venue, EventDate"
	Case Else
		SQLEvents = "SELECT EventDate, Map, Event.EventCode, Act, Venue FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Venue (NOLOCK) ON OrganizationVenue.VenueCode = Venue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE EventDate > GETDATE() - 1 AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND Event.Map <> 'general' ORDER BY EventDate, Act"
End Select
Set rsEvents = OBJdbConnection.Execute(SQLEvents)

Response.Write "<TABLE CELLSPACING=1 CELLPADDING=2 WIDTH=95% BORDER=0>" & vbCrLf
Response.Write "<TR BGCOLOR=""#008400""><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><A class=sort HREF=SeatStatusEvent.asp?SortMethod=Date&Method=Seat>Date/Time</A><B></B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><B><A class=sort HREF=SeatStatusEvent.asp?SortMethod=Act&Method=Seat>Production</A></B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><B><A class=sort HREF=SeatStatusEvent.asp?SortMethod=Venue&Method=Seat>Venue</A></B></FONT></TD></TR>" & vbCrLf

Do While Not rsEvents.EOF
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
  
	'REE 10/20/7 - Modified to use Generic Map File if custom map file does not exist.
	MapFile = Server.MapPath("SeatStatus" & rsEvents("Map") & ".asp")  
						
	Set FS=Server.CreateObject("Scripting.FileSystemObject")
	If FS.FileExists(MapFile)=TRUE Then
	  MapScript = "SeatStatus" & rsEvents("Map") & ".asp"
	Else
	   MapScript = "SeatStatusGenericMap.asp"
	End If
	Set FS=nothing

  
	Response.Write "<TR BGCOLOR=#DDDDDD><TD ALIGN=left NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & DateAndTimeFormat(rsEvents("EventDate")) & "</FONT></TD><TD ALIGN=left>  <FONT FACE=verdana,arial,helvetica SIZE=2><A HREF=" & MapScript & "?Event=" & rsEvents("EventCode") & "&Method=Seat>" & rsEvents("Act") & "</A></FONT></TD><TD ALIGN=left><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsEvents("Venue") & "</FONT></TD></TR>" & vbCrLf
	events="Y"
	rsEvents.MoveNext
Loop 
Response.Write "</TABLE>"

If events <> "Y" Then
  Response.Write "<font color=#545454><BR>No events are available matching you criteria</font>"
End If

%>

</center>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>
</html>
