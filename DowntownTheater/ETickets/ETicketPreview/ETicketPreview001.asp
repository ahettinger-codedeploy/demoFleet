%>
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="CalcCustomerFeeInclude.asp"-->
<!--#include virtual="/include/managementinclude.asp"-->
<%

Dim FSO

DIM i


Dim FilePath
Dim ETicketBackground 

Dim ActAdsFolderName
Dim ActCode
Dim ActMsg


Dim TicketBackground

DIM ETicketNumber
DIM OrderNumber
DIM ItemNumber

DIM Organization 
DIM  Act 
DIM  Venue 
DIM  EventDateTime 
DIM  SeatType 
DIM  Section 
DIM  Row
DIM  Seat
DIM Price


ETicketNumber = "000000000000"
OrderNumber = "0000000"
ItemNumber = "00000000"
Organization ="Organization"
Act = "Act"
ActCode = "12345"
Venue = "Venue"
EventDateTime = "September 20, 2013"
SeatType = "Adult"
Section = "Orchestra"
Row = "A"
Seat = "1"
Price = "0.00"


Dim FileName(4)
FileName(1) = "ETicketBackground.gif"
FileName(2) = "ETicketLogo.gif"
FileName(3) = "ETicketBottomBar.gif"
FileName(4) = "12345.gif"

Dim FolderName
FolderName = "images"


Dim FileLocation(4)

DIM Msg(4)
Msg(1) = ""
Msg(2) = ""
Msg(3) = ""
Msg(4) = ""

Set FSO = Server.CreateObject("Scripting.FileSystemObject")

For i = 1 to uBound(FileName)

	FilePath = (server.mappath(FolderName&"/"&FileName(i)))
	
	If (FSO.FileExists(FilePath)) Then
		Msg(i) = "<div class=""alert alert-success""> "&FileName(i)&" <BR>Local Image Found</div>"
		FileLocation(i) = FolderName&"/"&FileName(i)
	Else

		FilePath = (server.mappath("/"&FolderName&"/"&FileName(i)))
	
		If (FSO.FileExists(FilePath)) Then
			Msg(i) = "<div class=""alert"">"& FileName(i) &" <BR>Remote Image Found</div>"
			FileLocation(i) = "/"&FolderName&"/"&FileName(i)
		Else
			Msg(i) = "<div class=""alert alert-error"">"& FileName(i) &"<BR>Image Not Found<Br></div>"
			FileLocation(i) = ""
		End If

	End If
			
Next

set FSO = nothing

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
	<link href="css/style.css" rel="stylesheet">
	

    <!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->

     <!--[if IE 7]>
     <link href="//netdna.bootstrapcdn.com/font-awesome/3.0.2/css/font-awesome-ie7.css" rel="stylesheet">
    <![endif]-->

    <!-- Le fav and touch icons -->
    <link rel="shortcut icon" href="assets/ico/favicon.ico">
    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="img/apple-touch-icon-144-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="img/apple-touch-icon-114-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="72x72" href="img/apple-touch-icon-72-precomposed.png">
    <link rel="apple-touch-icon-precomposed" href="img/apple-touch-icon-57-precomposed.png">

  
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

<div class="container">

<div class="span8">

	<div style="border: 1px solid  #909090; border-radius: 4px 4px 4px 4px; margin-left: 10px; margin-top: 25px;">
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
		<FONT FACE="Arial,Helvetica" SIZE="2"><I>Downtown Theater Presents</I></FONT><BR>
		<FONT FACE="Arial,Helvetica" SIZE="5"><B>Audible Occamy </B></FONT><BR>
		<FONT FACE="Arial,Helvetica" SIZE="3"><B>Locotini</B></FONT><BR>
		<FONT FACE="Arial,Helvetica" SIZE="3">Friday, June 12, 2015 at 8:00 PM</FONT><BR><BR>
		<FONT FACE="Arial,Helvetica" SIZE="2">Individual  $30.00</FONT><BR>
		<FONT FACE="Arial,Helvetica" SIZE="2"><B>Section: TABLE F10B&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Row: F10B&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Seat: F10B</B></FONT><BR>

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

		<TABLE WIDTH="620" BORDER="0" class="info">
		<TR>
		<TD VALIGN="top" WIDTH = "33%">
		<FONT FACE="Arial, Helvetica" SIZE="2">
		<B>ORDER INFORMATION</B><BR>
		Order Number:&nbsp;&nbsp;14711068<BR>
		Order Date:&nbsp;&nbsp;4/10/2013<BR>
		Order Time:&nbsp;&nbsp;17:40<BR>
		Order Total:&nbsp;&nbsp;$30.25<BR>

		<BR>
		<B>BILLING INFORMATION</B><BR>
		Sergio Rodriguez<BR>
		110 W. Ocean Blvd<BR>
		Long Beach, CA 90802<BR>
		<BR>
		<B>ATTENDEE INFORMATION</B><BR>
		Sergio Rodriguez<BR>
		110 W. Ocean Blvd<BR>
		Long Beach, CA 90802<BR>

		<BR>
		</FONT>
		</TD>
		<TD VALIGN="top" WIDTH="33%">
		<FONT FACE="Arial, Helvetica" SIZE="2">
		<B>VENUE INFORMATION</B><BR>
		Locotini<BR>
		110 West Ocean Blvd<BR>
		10th Floor<BR>
		Long Beach, CA 90802<BR>
		Phone: <BR>

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
	
	<div class="span3" style="border: 1px solid  #909090; border-radius: 4px 4px 4px 4px; margin-top: 25px; font-size: 10px;">
		<%
		Response.Write "<br>" & vbCrLf
		Response.Write "<br>" & vbCrLf

		Response.Write Msg(1)
		Response.Write Msg(2)
		Response.Write Msg(3)


dim OrganizationNumber
OrganizationNumber = 2266

'dim today
'today = (FormatDateTime(Now(), vbShortDate))
'Response.Write "Today is "& today &"<BR>"& vbCrLf 

Response.Write " Event Listing "& vbCrLf

Response.Write " <select id=""e1"" style=""width:265px"" class=""populate placeholder""> "& vbCrLf

SQLActs = "SELECT DISTINCT EventDate, EventCode, Act From Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Category (NOLOCK) ON Act.CategoryCode = Category.CategoryCode INNER JOIN SubCategory (NOLOCK) ON Act.SubCategoryCode = SubCategory.SubCategoryCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode WHERE OrganizationAct.OrganizationNumber = 2266 AND OrganizationVenue.OrganizationNumber = 2266 AND Event.OnSale = 1  ORDER BY Event.EventDate, Act.Act"
Set rsActs = OBJdbConnection.Execute(SQLActs)

Do While Not rsActs.EOF

	
	If Now() < CDate(rsActs("EventDate")) Then 
	
		Response.Write "<optgroup label="""& rsActs("Act") &"""> "& vbCrLf
	
		SQLEvents = "SELECT DISTINCT EventDate, EventCode From Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Category (NOLOCK) ON Act.CategoryCode = Category.CategoryCode INNER JOIN SubCategory (NOLOCK) ON Act.SubCategoryCode = SubCategory.SubCategoryCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode WHERE OrganizationAct.OrganizationNumber = 2266 AND OrganizationVenue.OrganizationNumber = 2266 AND Event.OnSale = 1  ORDER BY Event.EventDate"
		Set rsEvents = OBJdbConnection.Execute(SQLEvents)
		
			Do While Not rsEvents.EOF
			
			If Now() < CDate(rsEvents("EventDate")) Then 
			
			 Response.Write " <option value="" "& rsEvents("Eventcode") &" ""> "& FormatDateTime(rsEvents("EventDate"), vbShortDate) &" - #"& rsEvents("Eventcode") &"</option> "& vbCrLf
			
			End If
		
		rsEvents.MoveNext 
		Loop 
		rsEvents.Close
		Set rsEvents = Nothing
		
		Response.Write "</optgroup> "& vbCrLf
	
	End If

rsActs.MoveNext 
Loop 

rsActs.Close
Set rsActs = Nothing

Response.Write "</select> "& vbCrLf
		
%>

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
	

