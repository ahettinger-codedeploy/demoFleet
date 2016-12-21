
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/include/managementinclude.asp"-->

<%

'----------------------------------

'Org Name

SQLThisOrg = "Select  Organization FROM Organization (NOLOCK) WHERE OrganizationNumber = " &  Session("OrganizationNumber") & ""
Set rsThisOrg = OBJdbConnection.Execute(SQLThisOrg)
	OrgName = rsThisOrg("Organization") 
rsThisOrg.Close
Set rsThisOrg = Nothing

'----------------------------------

'User Name
			
SQLNameUser = "Select  FirstName, LastName FROM Users (NOLOCK) WHERE UserNumber = " & Session("UserNumber") & ""
Set rsNameUser = OBJdbConnection.Execute(SQLNameUser)
	UserFirstName = rsNameUser("FirstName")
	ThisUserName = rsNameUser("FirstName") & " " & rsNameUser("LastName")
	ThisUserNumber = Session("UserNumber")
rsNameUser.Close
Set rsNameUser = Nothing


'----------------------------------

DIM ThisEventCode

ThisEventCode = Request.Form("EventCd")

DIM EventData(15)
EventData(1) = ""  'Organization
EventData(2) = ""  'Act
EventData(3) = ""  'Venue Name
EventData(4) = ""  'Date
EventData(5) = ""  'Time
EventData(6) = ""  'Ticket Type
EventData(7) = ""  'Price
EventData(8) = ""  'Section
EventData(9) = ""  'Row
EventData(10) = "" 'Seat
EventData(11) = "" 'Venue Address
EventData(12) = "" 'VenueCode
EventData(13) = "" 'ActCode
EventData(14) = "" 'EventCode
EventData(15) = "" '




If ThisEventCode <> "" Then

    EventData(1) = OrgName&" presents"

	SQLSeatInfo = "SELECT TOP(1) Seat.ItemNumber, Seat.SectionCode, Seat.Seat, Seat.Row, Seat.EventCode FROM Seat (NOLOCK)  WHERE Seat.EventCode = "& ThisEventCode &" "
	Set rsSeatInfo = OBJdbConnection.Execute(SQLSeatInfo)
	
	EventData(8) = rsSeatInfo("SectionCode")
	EventData(9) = rsSeatInfo("Row")
	EventData(10) = rsSeatInfo("Seat")
	
	rsSeatInfo.Close
	Set rsSeatInfo = Nothing
	
	
	SQLPriceInfo = "SELECT TOP(1) Price.Price, SeatType.SeatType FROM Price (NOLOCK) INNER JOIN SeatType (NOLOCK) on Price.SeatTypeCode = SeatType.SeatTypeCode WHERE Price.EventCode = "& ThisEventCode &"  AND Price.SectionCode = '"& EventData(8) &"' "
	Set rsPriceInfo = OBJdbConnection.Execute(SQLPriceInfo)
	
	EventData(6) = rsPriceInfo("SeatType")
	EventData(7) = FormatNumber(rsPriceInfo("Price"),2)


	
	rsPriceInfo.Close
	Set rsPriceInfo = Nothing
	
	SQLEventInfo = "SELECT Act.Act, Act.ActCode, Venue.Venue, Venue.Address_1, Venue.Address_2, Venue.City, Venue.State, Venue.Zip_Code, Venue.VenueCode, Event.EventCode, Event.EventDate FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode  WHERE Event.EventCode = " & ThisEventCode & ""
	Set rsEventInfo = OBJdbConnection.Execute(SQLEventInfo)
	
	EventData(2) = rsEventInfo("Act")
	EventData(3) = rsEventInfo("Venue")
	EventData(4) = FormatDateTime(rsEventInfo("EventDate"), vbLongDate) 
	EventData(5) = Left(FormatDateTime(rsEventInfo("EventDate"),vbLongTime),Len(FormatDateTime(rsEventInfo("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsEventInfo("EventDate"),vbLongTime),3)
	EventData(12) = rsEventInfo("VenueCode")
	EventData(13) = rsEventInfo("ActCode")
	EventData(14) = rsEventInfo("EventCode")
	
	If rsEventInfo("Address_1") <> "" Then
		EventData(11) = EventData(11) & rsEventInfo("Address_1") &"<BR>"
	End If
	
	If rsEventInfo("Address_2") <> "" Then
		EventData(11) = EventData(11) &"<BR>"&rsEventInfo("Address_2") &"<BR>"
	End If
		
	If rsEventInfo("City") <> "" Then
		EventData(11) = EventData(11)&" "&rsEventInfo("City")
	End If
	
	If rsEventInfo("State") <> "" Then
		EventData(11) = EventData(11)&", "&rsEventInfo("State")
	End If
	
	If rsEventInfo("Zip_Code") <> "" Then
		EventData(11) = EventData(11) &" "&rsEventInfo("Zip_Code")
	End If
	
	rsEventInfo.Close
	Set rsEventInfo = Nothing
	
End If

'----------------------------------------------

'Private Label
Dim PrivateLabelList

SQLVenueCodeCheck = "SELECT VenueCode FROM VenueOptions (NOLOCK) WHERE OptionName = 'OrganizationNumber' AND OptionValue = '" &  Session("OrganizationNumber") & "'"
Set rsVenueCodeCheck = OBJdbConnection.Execute(SQLVenueCodeCheck)

	If Not rsVenueCodeCheck.EOF Then 
	
			Do Until rsVenueCodeCheck.EOF
			   
			SQLVenueRefCheck = "SELECT OptionValue as URL FROM VenueOptions (NOLOCK) WHERE VenueCode = '" & rsVenueCodeCheck("VenueCode") & "' AND OptionName = 'VenueReference'"
			Set rsVenueRefCheck = OBJdbConnection.Execute(SQLVenueRefCheck)
			
			If Not rsVenueRefCheck.EOF Then
											
				PrivateLabelList = VenueList & " <option value="" "& rsVenueRefCheck("URL") &" ""> "& rsVenueRefCheck("URL") &"</option> "
									
			Else
			
				PrivateLabelList = "<optgroup>PL Error</optgroup>"
			
			End If
			
			rsVenueRefCheck.Close
			Set rsVenueRefCheck = nothing   
		
		rsVenueCodeCheck.MoveNext	    	    
		Loop 
		
	End If
	
rsVenueCodeCheck.Close
Set rsVenueCodeCheck = nothing
	
'----------------------------------------------	

DIM EventList

EventList = "<option></option>"

SQLActs = "select distinct act.act, event.actcode from event with (nolock) inner join act on event.actcode = act.actcode where event.actcode in (SELECT  ActCode FROM  OrganizationAct WITH (nolock) WHERE OrganizationNumber = " & (Session("OrganizationNumber")) & ") " 
'SQLActs = "SELECT DISTINCT Act, ActCode From Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode  WHERE OrganizationAct.OrganizationNumber = " & (Session("OrganizationNumber")) & "  AND Event.OnSale = 1  ORDER BY Event.EventDate, Act.Act"
Set rsActs = OBJdbConnection.Execute(SQLActs)

Do While Not rsActs.EOF
		
		EventList = EventList & "<optgroup label="""& rsActs("Act") &"""> "
	
		SQLEvents = "SELECT DISTINCT EventDate, EventCode From Event (NOLOCK) WHERE Event.ActCode = "& rsActs("actcode") &"  ORDER BY Event.EventDate"
		Set rsEvents = OBJdbConnection.Execute(SQLEvents)
		
			Do While Not rsEvents.EOF
			
			If Now() < CDate(rsEvents("EventDate")) Then 
			
			EventList = EventList &  " <option value="" "& rsEvents("Eventcode") &" "">Date: "& FormatDateTime(rsEvents("EventDate"), vbShortDate) &" - Event# "& rsEvents("Eventcode") &"</option> "
			
			End If
		
		rsEvents.MoveNext 
		Loop 
		
		rsEvents.Close
		Set rsEvents = Nothing
		
		EventList = EventList & "</optgroup> "
	
rsActs.MoveNext 
Loop 

rsActs.Close
Set rsActs = Nothing

'----------------------------------------------	

Dim FileName(3)
FileName(1) = "ETicketBackground.gif"
FileName(2) = "ETicketLogo.gif"
FileName(3) = "ETicketBottomBar.gif"

DIM FileLocation(3)
FileLocation(1) = ""
FileLocation(2) = ""
FileLocation(3) = ""

Dim FolderName
FolderName = "images"

Set FSO = Server.CreateObject("Scripting.FileSystemObject")

For i = 1 to uBound(FileName)

	FilePath = (server.mappath(FolderName&"/"&FileName(i)))
	
	If (FSO.FileExists(FilePath)) Then
		FileLocation(i) = FolderName&"/"&FileName(i)
	Else

		FilePath = (server.mappath("/"&FolderName&"/"&FileName(i)))
	
		If (FSO.FileExists(FilePath)) Then
			FileLocation(i) = "/"&FolderName&"/"&FileName(i)
		Else
			FileLocation(i) = ""
		End If

	End If
			
Next

set FSO = nothing

'----------------------------------------------	

'Search for custom ETicket Adverts


DIM Msg(3)

Msg(1) = ""
Msg(2) = ""
Msg(3) = ""                     

DIM AdFileName(3)
AdFileName(3) = EventData(12)&".gif" 'VenueCode
AdFileName(2) = EventData(13)&".gif" 'ActCode
AdFileName(1) = EventData(14)&".gif" 'EventCode

Dim AdFolderName
AdFolderName = "images"

DIM AdFilePath
AdFilePath = ""

DIM ETicketAdPath
ETicketAdPath = "/Images/ETicketTixLogo.gif"

Set FSO = Server.CreateObject("Scripting.FileSystemObject")

For i = 1 to uBound(AdFileName)

	AdFilePath = (server.mappath(AdFolderName&"/"&AdFileName(i)))
	
	If (FSO.FileExists(AdFilePath)) Then
		Msg(i) = "Local File Found!"&AdFileName(i)
		ETicketAd = AdFolderName&"/"&AdFileName(i)
		
	End If
			
Next

set FSO = nothing

'----------------------------------------------	

%>


<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>knowledgeBase</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">
	
    <link href="//fonts.googleapis.com/css?family=Signika+Negative:400,700" rel="stylesheet" type="text/css">
	<link href="//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.1/css/bootstrap-combined.no-icons.min.css" rel="stylesheet">
	<link href="//netdna.bootstrapcdn.com/font-awesome/3.0.2/css/font-awesome.css" rel="stylesheet">
	<link href="//cdn.jsdelivr.net/select2/3.3.1/select2.css" type="text/css" rel="stylesheet" />
	<link href="http://testtix.com/utilities/support/tixDashboard/eticketPreview/css/style.css" rel="stylesheet">
		
    <!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->

     <!--[if IE 7]>
     <link href="//netdna.bootstrapcdn.com/font-awesome/3.0.2/css/font-awesome-ie7.css" rel="stylesheet">
    <![endif]-->
  
  </head>

  <body>

<header>
	<div class="container">
        <div class="header">
			<div class="row">
				<div class="span6">
				  <h1><a href="list.asp">e<span>Ticket</span> preview</a></h1>
				</div>
				<div class="span6" id="header-nav">
					<ul class="nav nav-pills pull-right">
						<li class="active"><a href="list.asp">Home</a>
						<li> <a href="edit.asp?new=yes">Add New</a>						
						<li><a href="list.asp?displayxml=yes">View XML</a></li>
					</ul>
				</div>
			</div>
		</div>
	</div>
</header>

<div class="container well">

<div class="span8">

	<div style="border: 1px solid  black; border-radius: 4px 4px 4px 4px; margin-top: 25px; background-color: white;">
		<CENTER>
		<TABLE WIDTH="620" BORDER="0" class="eticket">
		<FONT FACE="Arial, Helvetica" SIZE="4"><B>THIS IS YOUR TICKET.  <FONT FACE="Arial, Helvetica" SIZE="3">Present this entire page at the event.</B></FONT>
		<BR>
		<TR>
		<TD VALIGN="top">
		<TABLE WIDTH="615" HEIGHT="240" BORDER="1" BACKGROUND="<%=FileLocation(1)%>" BGCOLOR="#FFD718" CELLPADDING="0" CELLSPACING="0">

		<TR>
		<TD WIDTH="500" VALIGN="top">
		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="100%">
		<TR>
		<TD WIDTH="220" HEIGHT="70" VALIGN="top">
		<IMG SRC="<%=FileLocation(2)%>">
		</TD>
		<TD VALIGN="top" ALIGN="right">
		<FONT FACE="Verdana,Arial,Helvetica" SIZE="1">3918-8872-2899-8426-13935&nbsp;&nbsp;&nbsp;&nbsp;14711068 - 130629574</FONT></TD>
		</TD>
		</TR>
		</TABLE>
		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="100%">
		<TR>
		<TD WIDTH="20">

		&nbsp;
		</TD>
		<TD VALIGN="top">
		
		<%
		
		If ThisEventCode <> "" Then
		
		Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""2""><I>" & EventData(1)  & "</I></FONT><BR>" & vbCrLf
		Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""5""><B>" & EventData(2)  & "</B></FONT><BR>" & vbCrLf
		Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""3""><B>" & EventData(3) & "</B></FONT><BR>" & vbCrLf
		Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""3"">"& EventData(4) &" at "& EventData(5) &" </FONT><BR><BR>" & vbCrLf
		Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""2"">" & EventData(6) & "  $" & EventData(7) & "</FONT><BR>" & vbCrLf
		Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""2""><B>Section: " & EventData(8) & "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Row: " & EventData(9)& "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Seat: " & EventData(10) & "</B></FONT><BR>" & vbCrLf
		
		End If
		
		%>

		</TD>
		</TR>
		</TABLE>
		</TD>
		<TD ALIGN="center" VALIGN="center">
		<IMG alt="Barcode Image" src="/Barcode.asp?Barcode=391888722899842613935&Rotate=270">&nbsp;
		</TD>
		</TR>
		<TR>
		<TD ALIGN="center" COLSPAN="2" VALIGN="bottom" BGCOLOR="#000000" HEIGHT="20">
		<IMG SRC="<%=FileLocation(3)%>">
		</TD>
		</TR>
		</TABLE>
		</TD>
		</TR>
		</TABLE>
		
		
		<% If ThisEventCode <> "" Then %>
		
		<TABLE WIDTH="620" BORDER="0" class="info">
		<TR>
		<TD VALIGN="top" WIDTH = "33%">
		<FONT FACE="Arial, Helvetica" SIZE="2">
		<B>ORDER INFORMATION</B><BR>
		Order Number:&nbsp;&nbsp;14711068<BR>
		Order Date:&nbsp;&nbsp;4/23/2013<BR>
		Order Time:&nbsp;&nbsp;12:00<BR>
		Order Total:&nbsp;&nbsp;$<%=EventData(7)%><BR>

		<BR>
		<B>BILLING INFORMATION</B><BR>
		<%=ThisUserName%><BR>
		110 W. Ocean Blvd<BR>
		Long Beach, CA 90802<BR>
		<BR>
		<B>ATTENDEE INFORMATION</B><BR>
		<%=ThisUserName%><BR>
		110 W. Ocean Blvd<BR>
		Long Beach, CA 90802<BR>

		<BR>
		</FONT>
		</TD>
		<TD VALIGN="top" WIDTH="33%">
		<FONT FACE="Arial, Helvetica" SIZE="2">
		<B>VENUE INFORMATION</B><BR>
		<%=EventData(3)%><BR>
		<%=EventData(11)%><BR>

		<BR>
		</FONT>
		</TD>
		<TD VALIGN="top" WIDTH="34%">
		<IMG alt="Barcode Image" src="/Barcode.asp?Barcode=391888722899842613935"><BR>
		<BR>
		</FONT>
		</TD>
		</TR>
		</TABLE>
		<TABLE WIDTH="620" BORDER="0" CELLPADDING="0" CELLSPACING="0" class="info">
		<TR>
		<TD>
		<FONT FACE="Arial, Helvetica" SIZE="2">
		<B>GENERAL INFORMATION</B><BR>
		</FONT>

		<FONT FACE="Arial, Helvetica" SIZE="1">
		NO REFUNDS - NO EXCHANGES.  DO NOT COPY THIS TICKET.  MULTIPLE COPIES INVALID.  Holder assumes all risk and danger including, without limitation, injury, death, personal loss, property damage, or other related harm.  Management reserves the right to refuse admission or eject any person who fails to comply with the terms and conditions and/or rules for the event in which this ticket is issued.
		</FONT>
		</TD>
		</TR>
		</TABLE>
		<TABLE WIDTH="620" BORDER="0" CELLPADDING="0" CELLSPACING="0">
		<TR>
		<TD ALIGN="center">
		<HR>
		</TD>
		</TR>
		</TABLE>
		
		
		<% End If %>
		
		<TABLE WIDTH="620" BORDER="0" CELLPADDING="0" CELLSPACING="0">
			<TR>
				<TD ALIGN="center">
					<IMG SRC="/Images/ETicketTixLogo.gif" HEIGHT="200">
				</TD>
			</TR>
		</TABLE>
		
		</CENTER>
		
		
	</div>
	
</div>
	
<div class="span3 well" style="margin-top: 25px;">

<h4>Organization</h4>
<%=OrgName%>
<BR>
<BR>
<BR>
<h4>Private Label</h4>
<%=PrivateLabelList%>
<BR>
<BR>
<BR>
<form class="form-horizontal" METHOD="POST"  action="ETicketPreview.asp">
	<fieldset>
	<h4>Event Listing</h4>
	<div class="control-group">
		<select name="eventcd" id="e1" style="width:265px" class="populate placeholder">
		<%=EventList%>
		</select>
	</div>
	<div class="form-actions">
		<button type="submit" class="btn btn-primary">Update</button>	
	</div>
	</fieldset>
</form>

<h4>Ad File Names</h4>
EventCode<BR>
<%=AdFileName(1)%><BR>
<BR>
ActCode<BR>
<%=AdFileName(2)%><BR>
<br>
VenueCode<BR>
<%=AdFileName(3)%><BR>




<%=Msg(1)%><BR>
<%=Msg(2)%><BR>
<%=Msg(3)%><BR>
</div>




 <!-- Javascripot 
    ================================================== -->
<!-- Placed at the end of the document so the pages load faster -->
<script src="http://ajax.aspnetcdn.com/ajax/jquery/jquery-1.7.2.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<script src="js/bootstrap-transition.js"></script>



<script src="js/wysihtml5-0.3.0.min.js"></script>
<script src="js/bootstrap-wysihtml5-0.0.2.min.js"></script>
<script src="js/select2.min.js"></script>

<script id="script_e1">
$(document).ready(function() {
	$("#e1").select2({
    placeholder: "Event Listing",
});
});
</script>





<script>
$('#story').wysihtml5({
	"font-styles"	: true,	//Font styling, e.g. h1, h2, etc. Default true
	"emphasis"		: true, //Italics, bold, etc. Default true
	"lists"			: true, //(Un)ordered lists, e.g. Bullets, Numbers. Default true
	"html"			: true, //Button which allows you to edit the generated HTML. Default false
	"link"			: true, //Button to insert a link. Default true
	"image"			: true, //Button to insert an image. Default true,
	"color"			: true 	//Button to change color of font  
});
</script>



</body>
</html>
	

