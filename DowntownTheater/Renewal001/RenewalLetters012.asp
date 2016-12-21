
<% 

'CHANGE LOG
'JAI 04/29/14 - 2015 Renewal Emails
'SSR 06/18/14 - 2015 Renewal Reminder Emails
'SSR 07/17/14 - Updated for use with Road Company
'SSR 07/18/14 - Updated EmailReplayTo 
'SSR 10/21/14 - Update

%>

<!--METADATA TYPE="typelib" UUID="CD000000-8B95-11D1-82DB-00C04FB1625D"  NAME="CDO for Windows 2000 Library" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp"-->
<!--#INCLUDE VIRTUAL="TicketPrintInclude.asp"-->
<!--#INCLUDE VIRTUAL="NoCacheInclude.asp"-->

<%

'-----------------------------------

DIM orgNumber
orgNumber = Session("OrganizationNumber")

DIM orgName
orgName = GetOrgName

DIM PrivateLabel
privateLabel =  GetPrivateLabel

DIM CustomerID
CustomerID = ""

DIM OtherID
CustomerID = ""

'-----------------------------------

EMailOrganization = orgName
PrivateLabel =  GetPrivateLabel
EMailRenewalURL = "http://" & PrivateLabel & ".tix.com/renew.aspx"
EmailTemplateFile = "LetterInclude.asp"
MsgLogoPath = "http://www.tix.com/images/clear.gif"
MsgFontFace = "'Times New Roman', Times, serif"
EMailReplyTo = "sergio@tix.com"
EMailSubject = "Season Renewal" 

'-----------------------------------

'Organization Variables

MsgRenewalURL = "http://" & PrivateLabel & ".tix.com/renew.aspx"
MsgLogoPath = "http://www.tix.com/images/clear.gif"
MsgFontFace = "'Times New Roman', Times, serif"

'-----------------------------------

'Testing Variables

TestMode = TRUE

If TestMode Then
	TestEMailAddress = "sergio.rodriguez@tix.com"
    EMailSubject =  "[Test Email] " & EMailSubject
	EMailReplyTo =  TestEMailAddress
	TestModeStatus = "Test Mode On"
	TestEmailCount = 3
End If

'-----------------------------------

BeginOrderNumber = 0

'REE 4/15/2 - Increased Session Timeout to 30 minutes to reduce Print validation timeout issues.
Session.Timeout = 60
Server.ScriptTimeout = 3600

Page = "ManagementMenu"

'Verify OrganizationNumber
If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then 
    OBJdbConnection.Close
    Set OBJdbConnection = nothing
    Response.Redirect("/Management/Default.asp")
End If

'Get Organization Name
Session("OrgName") = GetOrgName


'Verify User
If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then 
    OBJdbConnection.Close
    Set OBJdbConnection = nothing
    Response.Redirect("/Management/Default.asp")
Else
	TixUser = checkTixUser
End If

'-----------------------------------------------

DIM logList
DIM logFile
DIM strMode
DIM strTitle
DIM LgTab 
DIM LtTab 
DIM EmTab 
DIM TestMsg 
DIM logResults
DIM xmlFileName
DIM HRef

'-----------------------------------------------

'Program Workflow

Call checkStatus

Select Case Request("FormName")

	Case "PrintLetters"
		Call PrintLetters	
		
	Case "SendEmails"
		Call SendEmails	
		Call SaveEmailLog
		
	Case Else
		Call PrintMenu
		
End Select

'-----------------------------------------------

Sub PrintMenu

%>

<!DOCTYPE html>

<HTML lang="en">

<HEAD>

  <META name="generator" content="HTML Tidy for HTML5 (experimental) for Windows https://github.com/w3c/tidy-html5/tree/c63cc39">

  <TITLE>Support Dashboard</TITLE>
  
  <!-- Force IE to turn off past version compatibility mode and use current version mode -->
  <META http-equiv="X-UA-Compatible" content="IE=edge;chrome=1">
  
  <!-- Get the width of the users display-->
  <META name="viewport" content="width=device-width, initial-scale=1.0">
  
  <!-- Text encoded as UTF-8 -->
  <META http-equiv="Content-Type" content="text/html; charset=utf-8">
  
  <!--<LINK href='https://fonts.googleapis.com/css?family=Droid+Sans:400,700' rel="stylesheet" type="text/css">-->
  
  <!--<LINK href='http://fonts.googleapis.com/css?family=Lato:400,700,900,400italic' rel="stylesheet" type="text/css">-->
  
  <link href='http://fonts.googleapis.com/css?family=Open+Sans:400,800,700,600&subset=latin,latin-ext' rel='stylesheet' type='text/css'>
  
  <LINK href="https://netdna.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css" rel="stylesheet" type="text/css">
  
  <link href="https://oss.maxcdn.com/icheck/1.0.2/skins/all.min.css" rel="stylesheet" type="text/css" >
  
  <LINK href="https://netdna.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" rel="stylesheet" type="text/css">
  
<STYLE>

/* fonts */ 

.TixManagementContent 
{
font-family: 'Open Sans', sans-serif !important;
text-align: left !important;
min-height: 600px !important;
background-color: #fbfbfb !important;
padding: 5px !important;
}

/* links: remove all outlines and underscores */ 

a.btn:focus, 
a.btn:active:focus, 
a.btn.active:focus,

.btn:focus, 
.btn:active:focus, 
.btn.active:focus,

ul.dropdown-menu li a,
ul.dropdown-menu li a.active,
ul.dropdown-menu li a.focus,
ul.dropdown-menu li a.hover,

ul.nav.nav-pills li a,
ul.nav.nav-pills li a.active,
ul.nav.nav-pills li a.focus,
ul.nav.nav-pills li a.hover,

ul.nav-tabs li a,
ul.nav-tabs li a.active,
ul.nav-tabs li a.focus { outline:0px !important; -webkit-appearance:none;  text-decoration:none; color: #666666;}  

/* remove blue glow  */ 
 
.form-control 
{
box-shadow: none;
outline: none;
transition: border-color 0.15s ease-in-out 0s;
}

.form-control:focus 
{
box-shadow: none;
outline: none;
}
</STYLE>

<STYLE>

.table-fade {}

.table tbody tr.active {background-color: red;}

</STYLE>

<STYLE>

/* outline button */ 

.btn-default.btn-outline:active,
.btn-default.btn-outline:focus, 
.btn-default.btn-outline                	{ color: #676767; border-color: #676767; background-color: transparent; border-width: 2px; -webkit-transition: all 0.25s; -moz-transition: all 0.25s; transition: all 0.25s;}   
.btn-default.btn-outline:hover  			{ color: #000000; border-color: #000000; background-color: transparent; border-width: 2px; -webkit-transition: all 0.75s; -moz-transition: all 0.75s; transition: all 0.75s; } 

</STYLE>

<style>

/* toggle switch */ 

.switch { height: 34px;  width: 100px; position: relative; display: inline-block; vertical-align: top; width: 103px;  background-color: transparent; cursor: pointer; box-sizing: content-box; overflow: hidden; }
.switch-input { position: absolute; top: 0px; left: 0px; opacity: 0; }
.switch-handle {width: 29px; height: 28px; border: 2px solid #c2d0de;  border-radius: 4px; position: absolute; top: 3px; left: 3px;   border-radius: 1px; background: none repeat scroll 0% 0% #c2d0de; transition: left 0.45s ease-out 0s; }
.switch-label { border: 2px solid #c2d0de; border-radius: 4px; position: relative; display: block; height: inherit; font-size: 15px; text-transform: uppercase; background: none repeat scroll 0% 0% rgb(248, 248, 248); transition: all 0.15s ease-out 0s; }

.switch-label:before, 
.switch-label:after { position: absolute; top: 50%; margin-top: -0.5em; line-height: 1; transition: inherit; }
.switch-label:before { content: attr(data-off); right: 11px; color: #c2d0de; }
.switch-label:after { content: attr(data-on); left: 11px; color: white; opacity: 0; }

.switch-input:checked ~ .switch-label { background: none repeat scroll 0% 0% rgb(248, 249, 250); }
.switch-input:checked ~ .switch-handle { left: 70px; background-color: white;}
.switch-input:checked ~ .switch-label:before { opacity: 0; }
.switch-input:checked ~ .switch-label:after { opacity: 1; }

.switch-success > .switch-input:checked ~ .switch-label { background: none repeat scroll 0% 0% rgb(77, 189, 116); border-color: rgb(58, 157, 93); }
.switch-success > .switch-input:checked ~ .switch-handle {background: none repeat scroll 0% 0% #ffffff; border-color: #ffffff; }

</style>

<STYLE>

/* panel header, panel title, panel navbar, panel tabs, panel button */ 

div.panel div.panel-heading,
div.panel div.panel-heading div.panel-title,
div.panel div.panel-heading div.panel-title .nav-btn,
div.panel div.panel-heading div.panel-title .nav-tabs,
div.panel div.panel-heading div.panel-title .navbar,
div.panel div.panel-heading div.panel-title .navbar .navbar-header
{ padding: 0; margin: 0; border: 0; min-height: 50px !important; max-height: 50px !important;}

/* panel header */ 

div.panel div.panel-heading { border-bottom:1px solid #dddddd; }

/* panel tabs */

div.panel div.panel-heading div.panel-title nav.navbar div.pull-left ul.nav.nav-tabs li a { min-height: 47px !important; max-height: 47px !important;  min-width: 115px; margin-top: 3px; font-size: 14px;}

/* panel button */

div.panel div.panel-heading div.panel-title .nav-btn .btn { height: 49px; border: 0; background-color: #f5f5f5; }

/* panel labels */

div.panel .icon-label { margin-left: 5px; }

</STYLE>

<STYLE>

/* hide-show panels */ 

div#panel-parent.panel
{
position: relative;
min-height: 450px;
}

div#panel-parent.panel div#panel-edit.panel-body
{       
position: absolute;
z-index: 20;
overflow: hidden;
width: 100%;
padding: 0px .5px 20px .5px;
}

div#panel-parent.panel div#panel-edit.panel-body div#panel-edit-inner.container-fluid
{
background-color: white;
margin-top: -330px;
padding: 10px;
border-radius: 6px;
border-top-right-radius: 0px;
border-top-left-radius: 0px;
box-shadoww: 0 6px 12px rgba(0, 0, 0, 0.176);
border: 1px solid #dddddd;
border-top: 0;
-webkit-box-shadow: 0 10px 6px -6px #999;
-moz-box-shadow: 0 10px 6px -6px #999;
box-shadow: 0 10px 6px -6px #999;
}

div#panel-parent.panel.panel-default div#panel-edit.panel-body div#panel-edit-inner.container-fluid.effect1 ul.nav.nav-pills.nav-stacked.col-sm-3 li.active a
{
border-radius: 4px;
font-weight: bold;
transition: all 300ms ease 0s;
margin-right: 2px;
display: block;
position: relative;
color: #ffffff;
}

div#panel-parent.panel div#panel-display.panel-body
{       
background-color: #ffffff;
position: absolute;
z-index: 10;
width: 100%;
opacity: 0;
}

</STYLE>


<style>

* hide-show disabled buttons */ 

#email-test.email-control.disabled, 
#email-test.email-control[disabled],
#email-submit.email-control.disabled, 
#email-submit.email-control[disabled]
{
display: none;
visibility: hidden;
}

</style>

</head>

	<body>
			
		<!--#INCLUDE VIRTUAL="TopNavInclude.asp" -->
		
		<DIV class="panel panel-default" id="panel-parent">
		
			<DIV class="panel-heading" id="panel-header">			   
				<DIV class="panel-title">
					<NAV class="navbar" role="navigation">
					
						<DIV class="navbar-header">
							<SPAN class="navbar-brand">Renewal Letters</SPAN>
						</DIV>
						
						 <DIV class="pull-left">
							<ul class="nav nav-tabs">
						
							<%
								response.write "<li class=""" & ltTab & """><a href=""?mode=letters""><i class=""glyphicon glyphicon-print""></i><span class=""icon-label"">Letters</span></a></li>"
								If TIXUser Then
									response.write "<li class=""" & emTab & """><a href=""?mode=emails""><i class=""glyphicon glyphicon-send""></i><span class=""icon-label"">Emails</span></a></li>"	
									If lgTab = "disabled" Then
										ahref = "<a href=""?"">"
									Else
										ahref = "<a href=""?mode=loglist"">"
									End If
									response.write "<li class=""" & lgTab & """>" & ahref & "<i class=""glyphicon glyphicon-list""></i><span class=""icon-label"">Logs</span></a></li>"
								End If 
							%>
							</ul>
						</div>

						<DIV class="nav-btn pull-right">
						  <BUTTON class="btn btn-large btn-default" id="btn4" type="button" data-placement="top" title="Options">
							<span class="glyphicon glyphicon-cog"></span>
							<SPAN class="icon-label">Options</SPAN>
						  </BUTTON>
						</DIV>
					
					</NAV>
				</DIV>
			</DIV>
			
			<DIV class="panel-body" id="panel-edit">

				<% Call PanelEdit %>
					
			</DIV>

			<DIV class="panel-body" id="panel-display">
			
				<h3><%=strTitle%></h3>
				
				<%
				
				Select Case strMode
					Case "letters"
						Call DisplayLetters
					Case "emails"
						Call DisplayEmails
					Case "loglist"
						Call DisplayLogList		
					Case "logs"
						Call DisplayLog								
				End Select
			
				%>
			

			</DIV>
			
		</div>
		
	<FOOTER>

	<!--#INCLUDE VIRTUAL="FooterInclude.asp" -->

<SCRIPT src="https://code.jquery.com/jquery-1.9.1.js" type="text/javascript" language="javascript"></SCRIPT> 
<SCRIPT src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.10.3/jquery-ui.min.js" type="text/javascript" language="javascript"></SCRIPT> 
<SCRIPT src="https://cdnjs.cloudflare.com/ajax/libs/jquery-easing/1.3/jquery.easing.min.js" type="text/javascript" language="javascript">	</SCRIPT> 

<SCRIPT src="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js" type="text/javascript" language="javascript"></SCRIPT> 
<script type="text/javascript" language="javascript" src="https://cdn.jsdelivr.net/icheck/1.0.2/icheck.min.js"></script>  


<SCRIPT type="text/javascript" language="javascript">

function tableFade() 
{                                                              
$("#panel-display")
.delay(25)
.animate({"opacity": "1"}, 800);
}

tableFade();

</SCRIPT> 

<SCRIPT type="text/javascript" language="javascript">

$(function () 
{

$('[data-toggle="tooltip"]').tooltip();
$('.dropdown-toggle').dropdown();
$('.dropdown-toggle').tooltip();

});           

</SCRIPT> 

<SCRIPT type="text/javascript" language="javascript">

jQuery.fn.blindToggle = function(speed, easing, callback) 
{
var h = (this.height() + parseInt(this.css('paddingTop')) + parseInt(this.css('paddingBottom')) + 9);
return this.animate({marginTop: parseInt(this.css('marginTop')) < 0 ? 0 : -h}, speed, easing, callback);  
};

$(document).ready(function() 
{
var $box = $('#panel-edit-inner')
$('#btn4').click(function() 
{
$box.blindToggle(1000, 'easeInOutQuart');
});    
});

</SCRIPT> 

<SCRIPT type="text/javascript" language="javascript">

(function($) 
 {
	$.fn.toggleDisabled = function() 
	{
		return this.each(function() 
		{
			var $this = $(this);
			if ($this.attr('disabled')) $this.removeAttr('disabled');		
			
			else $this.attr('disabled', 'disabled');
		});
	};
})(jQuery);

$(function() 
{
	//disable all email controls
	$('.email-control').prop('disabled', true);
	
	//disable email switch
	$('#email-switch').prop('checked', false);
	
	//enable email submit
	$('#email-submit').prop('disabled', false);
	
	//check for email-switch to be toggled
	$('#email-switch').change(function() 
	{
		$('.email-control').toggleDisabled();       
	});
});

</script>

</FOOTER>
		
	</body>
		
</html>

<%

End Sub
	
'-----------------------------------
	
Sub DisplayLetters
	
		'Get Matching Events
		'REE 4/6/2 - Modified to include OrganizationAct selection criteria
		'REE 2/25/3 - Removed TicketFormat from criteria.
		SQLEvents = "SELECT Event.EventCode FROM Event (NOLOCK) INNER JOIN Venue ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber WHERE Organization.OrganizationNumber = " & Session("OrganizationNumber") & " AND EventDate > GETDATE() ORDER BY EventDate"
		Set rsEvents = OBJdbConnection.Execute(SQLEvents)

		EventList = ""
		If Not rsEvents.EOF Then
			EventList = "("
			Do Until rsEvents.EOF
				EventList = EventList & rsEvents("EventCode") & "," 
				rsEvents.MoveNext
			Loop
			EventList = Left(EventList,len(EventList)-1) & ")"
		End If

		If EventList <> "" Then
			'REE 2/25/3 - Removed TicketFormat from criteria.
			SQLTickets = "SELECT COUNT(OrderLine.ItemNumber) AS TicketCount, Act.Act, EventDate, Event.EventCode, Venue FROM Event (NOLOCK) INNER JOIN Seat ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Shipping ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN Act ON Event.ActCode = Act.ActCode INNER JOIN Venue ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber INNER JOIN OrganizationAct ON Event.ActCode = OrganizationAct.ActCode WHERE Event.EventCode IN " & EventList & " AND EventDate > GETDATE() AND OrderLine.StatusCode = 'R' AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') GROUP BY Event.EventCode, EventDate, Act.Act, Venue.Venue ORDER BY EventDate, Act.Act"
			Set rsTickets = OBJdbConnection.Execute(SQLTickets)
			
			'REE 4/6/2 - Modified to check for events.
			If Not rsTickets.EOF Then 'There are some events.  List them
			%>
			<FORM ACTION="" METHOD="post">
			
				<INPUT TYPE="hidden" NAME="FormName" VALUE="PrintLetters">
				
				<TABLE class="table table-data table-striped table-fade">
					<THEAD>
						<TR><TH data-toggle="tooltip" data-placement="top">Select</TH><TH>Production</TH><TH data-container="body">Venue</TH><TH>Date/Time</TH><TH>Ticket Quantity</TH></TR>
					</THEAD>
					<TFOOT>
						<TR><TH colspan="5"></TH></TR>
					</TFOOT>
					<TBODY>
			<%
					'Display Event and UnPrinted Ticket Quantities
					Do Until rsTickets.EOF
						Response.Write "<TR><TD><INPUT TYPE=""checkbox"" NAME=""EventCode"" VALUE=""" & rsTickets("EventCode") & """></TD><TD>" & rsTickets("Act") & "</TD><TD>" & rsTickets("Venue") & "</TD><TD>" & DateAndTimeFormat(rsTickets("EventDate")) & "</TD><TD>" & rsTickets("TicketCount") & "</TD></TR>" & vbCrLf
					rsTickets.MoveNext
					Loop
			%>
					</TBODY>
				</TABLE>
				
				Select events and click below<BR>
				<BR>
				<INPUT TYPE="submit" CLASS="btn btn-outline btn-default" VALUE="Submit">
				
			</FORM>
			<%
	
			Else 'There aren't any matching events
				Response.Write "<FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">There are no events to be printed.</FONT>" & vbCrLf
			End If
			
		Else 'There aren't any matching events
			Response.Write "<FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">There are no events to be printed.</FONT>" & vbCrLf
		End If


End Sub
	
'-----------------------------------

Sub DisplayEmails
	
	'Get Matching Events
	'REE 4/6/2 - Modified to include OrganizationAct selection criteria
	'REE 2/25/3 - Removed TicketFormat from criteria.
	SQLEvents = "SELECT Event.EventCode FROM Event (NOLOCK) INNER JOIN Venue ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber WHERE Organization.OrganizationNumber = " & Session("OrganizationNumber") & " AND EventDate > GETDATE() ORDER BY EventDate"
	Set rsEvents = OBJdbConnection.Execute(SQLEvents)

	EventList = ""
	If Not rsEvents.EOF Then
		EventList = "("
		Do Until rsEvents.EOF
			EventList = EventList & rsEvents("EventCode") & "," 
			rsEvents.MoveNext
		Loop
		EventList = Left(EventList,len(EventList)-1) & ")"
	End If

	If EventList <> "" Then
		'REE 2/25/3 - Removed TicketFormat from criteria.
		SQLTickets = "SELECT COUNT(OrderLine.ItemNumber) AS TicketCount, Act.Act, EventDate, Event.EventCode, Venue FROM Event (NOLOCK) INNER JOIN Seat ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Shipping ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN Act ON Event.ActCode = Act.ActCode INNER JOIN Venue ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber INNER JOIN OrganizationAct ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber WHERE Event.EventCode IN " & EventList & " AND EventDate > GETDATE() AND OrderLine.StatusCode = 'R' AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') AND Customer.EMailAddress IS NOT NULL AND Customer.EMailAddress <> '' GROUP BY Event.EventCode, EventDate, Act.Act, Venue.Venue ORDER BY EventDate, Act.Act"
		Set rsTickets = OBJdbConnection.Execute(SQLTickets)
		
		'REE 4/6/2 - Modified to check for events.
		If Not rsTickets.EOF Then 'There are some events.  List them
	%>	
			<FORM class="form-horizontal" ACTION="" METHOD="post">
			
				<INPUT TYPE="hidden" NAME="FormName" VALUE="SendEmails">
				
				<TABLE class="table table-data table-striped table-fade">
					<THEAD>
						<TR><TH>Select</TH><TH>Production</TH><TH>Venue</TH><TH>Date/Time</TH><TH>Quantity</TH></TR>
					</THEAD>
					<TFOOT>
						<TR><TH colspan="5"> </TH></TR>
					</TFOOT>
					<TBODY>
	<%
			
					'Display Event and UnPrinted Ticket Quantities
					Do Until rsTickets.EOF

						Response.Write "<TR><TD><INPUT TYPE=""checkbox"" NAME=""EventCode"" VALUE=" & rsTickets("EventCode") & "></TD><TD>" & rsTickets("Act") & "</TD><TD>" & rsTickets("Venue") & "</TD><TD >" & DateAndTimeFormat(rsTickets("EventDate")) & "</TD><TD >" & rsTickets("TicketCount") & "</TD></TR>" & vbCrLf

						rsTickets.MoveNext

					Loop
	%>		
					</TBODY>
				</TABLE>

				Select events and click below<BR>
				<BR>
				
				<div class="form-group">
					<label class="col-sm-3 control-label"></label>
					<div class="col-lg-7">
						<input type="submit" id="email-submit" class="btn btn-primary email-control" value="Submit" /> 
						<input type="submit" id="email-test"   class="btn btn-danger  email-control" value="Test"/>
					</div>
				</div>
			
			</FORM>
	
	<%
			
		Else 'There aren't any matching events
			Response.Write "<BR><BR><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">There are no events to be generated.</FONT><BR><BR>" & vbCrLf
		End If
		
	Else 'There aren't any matching events
		Response.Write "<BR><BR><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">There are no events to be generated.</FONT><BR><BR>" & vbCrLf
	End If

End Sub

'-------------------------------------------------

Sub PrintLetters

'Server.ScriptTimeout = 600

%>

<HTML>
<HEAD>
<TITLE>www.TIX.com - Subscription Renewal Letters</TITLE>
<SCRIPT LANGUAGE="JavaScript">
<!-- Begin
	function PrintLetters(){
		window.print(); 
		}

//  End -->
</SCRIPT>
</HEAD>
<BODY onLoad="PrintLetters()" LEFTMARGIN="0" RIGHTMARGIN="0" TOPMARGIN="0" MARGINHEIGHT="0" MARGINWIDTH="0">

<STYLE>	
	div {page-break-before: always}
</STYLE>

<FONT COLOR="#000000">
<%

'Build the Query to select each of the selected events
'REE 7/7/3 - Removed EventShip from Query.
SQLOrderLine = "SELECT OrderHeader.OrderTypeNumber, OrderHeader.OrderSurcharge, OrderHeader.ShipFee, OrderHeader.Total, OrderLine.OrderNumber, OrderLine.LineNumber, OrderLine.ItemNumber, OrderLine.Price, OrderLine.Surcharge, OrderLine.Discount, OrderLine.ShipCode, Event.EventCode, Event.EventDate, Event.Map, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, PostalCode, Customer.DayPhone, Customer.NightPhone, Customer.EMailAddress, Shipping.ShipType, Act.Act, Venue.Venue, SeatType.SeatType, Seat.Row, Seat.Seat, Seat.SectionCode, Section.Section FROM OrderLine INNER JOIN OrderHeader ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN Seat ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event ON Seat.EventCode = Event.EventCode INNER JOIN Section ON Seat.SectionCode = Section.SectionCode AND Event.EventCode = Section.EventCode INNER JOIN Act ON Event.ActCode = Act.ActCode INNER JOIN Venue ON Event.VenueCode = Venue.VenueCode INNER JOIN SeatType ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN Shipping ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct ON Event.ActCode = OrganizationAct.ActCode "
SQLWhere = SQLWhere & " WHERE Event.EventCode IN (" & Clean(Request("EventCode"))

'Get the Info to Print
'REE 4/6/2 - Modified to use OrganizationAct in selection criteria
'REE 8/1/5 - Added OrderNumbers for 2 orders.

SQLOrderLine = SQLOrderLine & SQLWhere & ") AND OrderLine.StatusCode = 'R' AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent')" & OrderRange & " ORDER BY OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.OrderNumber, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry, OrderLine.ShipCode, Seat.EventCode, Seat.SectionCode, RowSort, SeatSort DESC"
Set rsOrderLine = OBJdbConnection.Execute(SQLOrderLine)
		
Do Until rsOrderLine.EOF ' Or LetterCount >= 1

	If rsOrderLine("OrderNumber") <> LastOrderNumber Then 
	'This is not the last order.
	
		'Print the footer
		If TicketCount > 0 Then 
		
			Response.Write "<TR><TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf	
			
			If LastShipFee <> 0 And LastOrderTypeNumber <> 5 Then
				Response.Write "<TR><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=""" & MsgFontFace & """>Processing Fee</TD><TD ALIGN=""right""><FONT FACE=""" & MsgFontFace & """>" & FormatCurrency(LastShipFee,2) & "</TD></TR>" & vbCrLf
				Response.Write "<TR><TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf
			End If

			SQLTender = "SELECT SUM(Tender.Amount) AS TenderAmount FROM Tender (NOLOCK) WHERE Tender.OrderNumber = " & LastOrderNumber
			Set rsTender = OBJdbConnection.Execute(SQLTender)
		
			If IsNull(rsTender("TenderAmount")) Then
				LastTender = 0
			Else
				LastTender = rsTender("TenderAmount")
			End If
		
			rsTender.Close
			Set rsTender = nothing	

			Response.Write "<TR><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=""" & MsgFontFace & """>Order Total</TD><TD ALIGN=""right""><FONT FACE=""" & MsgFontFace & """>" & FormatCurrency(LastTotal,2) & "</TD></TR>" & vbCrLf
			
			If LastTender <> 0 Then
				Response.Write "<TR><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=""" & MsgFontFace & """>Less Payments</TD><TD ALIGN=""right""><FONT FACE=""" & MsgFontFace & """>" & FormatCurrency(LastTender,2) & "</TD></TR>" & vbCrLf
				Response.Write "<TR><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=""" & MsgFontFace & """>Balance Due</TD><TD ALIGN=""right""><FONT FACE=""" & MsgFontFace & """>" & FormatCurrency(LastTotal - LastTender,2) & "</TD></TR>" & vbCrLf
			End If
			
			If LastShipFee = 0 And LastOrderTypeNumber <> 5 Then
				Response.Write "<TR><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=""" & MsgFontFace & """>[&nbsp;&nbsp;] ADD $1 for mailing</TD><TD ALIGN=""right""><FONT FACE=""" & MsgFontFace & """>&nbsp;&nbsp;</TD></TR>" & vbCrLf
				Response.Write "<TR><TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf
			End If
			
			Response.Write "</TABLE><BR>" & vbCrLf
			
			'-----------------------------------------
			
			'Insert HTML Template - Footer Content
			Response.Write InsertTemplate("LetterInclude.asp","Footer") 
			
			'Insert HTML Template - Footer Content
			EMailMessage = EMailMessage & InsertTemplate(EmailTemplateFile,"Footer") 
			
			'-----------------------------------------
			
			Response.Write "<div></div>"
			
			Response.Write "</CENTER>" & vbCrLf
			
			LetterCount = LetterCount + 1

            If LetterCount Mod 100 = 0 Then
                Response.Flush
            End If

		End If
				
		SQLCustInfo = "SELECT Customer.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry, OrderLine.Price - OrderLine.Discount AS NetPrice FROM OrderHeader (NOLOCK) INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber WHERE OrderHeader.OrderNumber = " & rsOrderLine("OrderNumber") & " AND OrderLine.LineNumber = " & rsOrderLine("LineNumber") & " ORDER BY OrderLine.Price - OrderLine.Discount DESC"
		Set rsCustInfo = OBJdbConnection.Execute(SQLCustInfo)

		If Not rsCustInfo.EOF Then

			Response.Write "<CENTER>"

			'-----------------------------------------
			
			'Insert HTML Template - Header Content
			Response.Write InsertTemplate("LetterInclude.asp","Header") 
			
			'-----------------------------------------
						
			'Insert HTML Template - Masthead Content
			Response.Write InsertTemplate("LetterInclude.asp","Masthead") 
			
			'-----------------------------------------
			
			'Shipping and Billing Address
			
			Response.Write "<TABLE WIDTH=""750"" cellpadding=""0"" cellspacing=""0""  border=""0"">" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD WIDTH=""400""><FONT FACE=""" & MsgFontFace & """><B>Shipping Information</B></TD>" & vbCrLf
			Response.Write "<TD WIDTH=""330""><FONT FACE=""" & MsgFontFace & """><B>Billing Information</B></TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD>" & vbCrLf
			
			Response.Write "<FONT FACE=""" & MsgFontFace & """>" & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & "<BR>" & rsCustInfo("ShipAddress1") & "<BR>" & vbCrLf
			
			If rsCustInfo("ShipAddress2") <> "" Then
				Response.Write rsCustInfo("ShipAddress2") & "<BR>" & vbCrLf
			End If
			
			Response.Write rsCustInfo("ShipCity") & ", " & rsCustInfo("ShipState") & " " & rsCustInfo("ShipPostalCode") & "" & vbCrLf
			
			Response.Write "</TD>" & vbCrLf
			Response.Write "<TD>" & vbCrLf
			Response.Write "<FONT FACE=""" & MsgFontFace & """>" & rsCustInfo("FirstName") & " " & rsCustInfo("LastName") & "<BR>" & rsCustInfo("Address1") & "<BR>" & vbCrLf
			
			If rsCustInfo("Address2")<> "" Then
				Response.Write rsCustInfo("Address2") & "<BR>" & vbCrLf
			End If
			
			Response.Write rsCustInfo("City") & ", " & rsCustInfo("State") & " " & rsCustInfo("PostalCode") & "" & vbCrLf
			Response.Write"</TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD COLSPAN=""3""><hr></TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf
			
			Response.Write "<BR>" & vbCrLf
			
			'-----------------------------------------
			
			'Order Number and Renewal Number
			
			Response.Write "<TABLE WIDTH=""750"" cellpadding=""0"" cellspacing=""0"" border=""0"">" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD ALIGN=""left"">" & vbCrLf
			Response.Write "<FONT FACE=""" & MsgFontFace & """><B>Order Number:</B>&nbsp;" & rsOrderLine("OrderNumber") & "" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			Response.Write "<TD ALIGN=""right"">" & vbCrLf
			SQLItemNumber = "SELECT ItemNumber FROM OrderLine (NOLOCK) WHERE OrderNumber = " & rsOrderLine("OrderNumber") & " ORDER BY ItemNumber"
			Set rsItemNumber = OBJdbConnection.Execute(SQLItemNumber)
			RenewalCode = rsCustInfo("CustomerNumber") & rsItemNumber("ItemNumber")
			rsItemNumber.Close
			Set rsItemNumber = nothing
			Response.Write "<B>Renewal Code:</B>&nbsp;" & RenewalCode & "" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf
			Response.Write "<BR>" & vbCrLf
			
			'-----------------------------------------

		Else

			ErrorLog("Invoice Format - Order Number = " & Clean(Request("OrderNumber")) & " | Line Number = " & Clean(Request("LineNumber")))

		End If

		rsCustInfo.Close
		Set rsCustInfo = nothing

		LastEventCode = 0
		LastOrderNumber = rsOrderLine("OrderNumber")
		LastOrderTypeNumber = rsOrderLine("OrderTypeNumber")
				
		'Update the Footer Totals
		LastOrderSurcharge = rsOrderLine("OrderSurcharge")
		LastShipType = rsOrderLine("ShipType")
		LastShipFee = rsOrderLine("ShipFee")
		LastDiscount = rsOrderLine("Discount")
		LastTotal = rsOrderLine("Total")
		

		
		TicketCount = TicketCount + 1

	End If

	'Print Event Info and Column Headings if this is a new Event
	If LastEventCode <> rsOrderLine("EventCode") Or LastOrderNumber <> rsOrderLine("OrderNumber") Then
	
		'-----------------------------------------
			
		'Production Name, Date & Time
		'Order Delivery Method
	
		Response.Write "<TABLE WIDTH=""750"" cellpadding=""0"" cellspacing=""0""  border=""0"">" & vbCrLf
		Response.Write "<TR><TD><FONT FACE=""" & MsgFontFace & """><B>" & rsOrderLine("Act") & " at " & rsOrderLine("Venue") & "" & vbCrLf
		
		'REE 6/5/6 - Modified to look at EventOptions for Date & Time Display Options
		SQLDateSuppress = "SELECT OptionValue AS DateSuppress FROM EventOptions (NOLOCK) WHERE EventCode = " & rsOrderLine("EventCode") & " AND OptionName = 'DateSuppress' AND OptionValue = 'Y'"
		Set rsDateSuppress = OBJdbConnection.Execute(SQLDateSuppress)
		If rsDateSuppress.EOF Then
			Response.Write " on " & FormatDateTime(rsOrderLine("EventDate"),vbShortDate)
		End If
		rsDateSuppress.Close
		Set rsDateSuppress = nothing

		SQLTimeSuppress = "SELECT OptionValue AS TimeSuppress FROM EventOptions (NOLOCK) WHERE EventCode = " & rsOrderLine("EventCode") & " AND OptionName = 'TimeSuppress' AND OptionValue = 'Y'"
		Set rsTimeSuppress = OBJdbConnection.Execute(SQLTimeSuppress)
		If rsTimeSuppress.EOF Then
			Response.Write " at " & Left(FormatDateTime(rsOrderLine("EventDate"),vbLongTime),Len(FormatDateTime(rsOrderLine("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsOrderLine("EventDate"),vbLongTime),3)
		End If
		rsTimeSuppress.Close
		Set rsTimeSuppress = nothing

		Response.Write "</B><BR>Delivery Method: " & rsOrderLine("ShipType") & "</TD></TR>" & vbCrLf
		Response.Write "</TABLE>" & vbCrLf
		
		Response.Write "<BR>" & vbCrLf
		
		'-----------------------------------------
					
		'Seat Location, Price, Service Fee

		'Calculate Number of Columns
		SQLNumColumns = "SELECT SUM(OrderLine.Surcharge) AS ServiceFee, SUM(OrderLine.Discount) AS Discount FROM OrderLine WHERE OrderNumber = " & rsOrderLine("OrderNumber") & " AND ItemType IN ('Seat', 'SubFixedEvent')"
		Set rsNumColumns = OBJdbConnection.Execute(SQLNumColumns)

		NumColumns = 6
		ColumnHeading = "<TABLE WIDTH=""750"" cellpadding=""0"" cellspacing=""0"" border=""0""><TR><TD><FONT FACE=""" & MsgFontFace & """><B><U>Section</U></B></TD><TD ALIGN=center><FONT FACE=""" & MsgFontFace & """><B><U>Row</U></B></TD><TD ALIGN=center><FONT FACE=""" & MsgFontFace & """><B><U>Seat</U></B></TD><TD><FONT FACE=""" & MsgFontFace & """><B><U>Type</U></B></TD><TD ALIGN=right><FONT FACE=""" & MsgFontFace & """><B><U>Price</U></B></TD>"

		FacilityCharge = 0
		If FacilityCharge <> 0 Then
			NumColumns = NumColumns + 1
			ColumnHeading = ColumnHeading + "<TD ALIGN=right><FONT FACE=""" & MsgFontFace & """><B><U>Facility Charge</U></B></TD>"
			ColFacilityCharge = "Y"
		End If
		If rsNumColumns("ServiceFee") <> 0 Then
			NumColumns = NumColumns + 1
			ColumnHeading = ColumnHeading + "<TD ALIGN=right><FONT FACE=""" & MsgFontFace & """><B><U>Service Fee</U></B></TD>"
			ColServiceFee = "Y"
		End If
		If rsNumColumns("Discount") <> 0 Then
			NumColumns = NumColumns + 1
			ColumnHeading = ColumnHeading + "<TD ALIGN=right><FONT FACE=""" & MsgFontFace & """><B><U>Discount</U></B></TD>"
			ColDiscount = "Y"
		End If

		rsNumColumns.Close
		Set rsNumColumns = nothing

		ColumnHeading = ColumnHeading + "<TD ALIGN=right><FONT FACE=""" & MsgFontFace & """><B><U>Amount</U></B></TD></TR>" & vbCrLf
		
		Response.Write ColumnHeading

		LastEventCode = rsOrderLine("EventCode")
		
		'-----------------------------------------
		
	End If
	
	'-----------------------------------------
		
	'Facility Charge, Surcharge, Discount, Price
	
	LineDetail = "<TR><TD><FONT FACE=""" & MsgFontFace & """>" & rsOrderLine("Section") & "</TD><TD ALIGN=center><FONT FACE=""" & MsgFontFace & """>" & rsOrderLine("Row") & "</TD><TD ALIGN=center><FONT FACE=""" & MsgFontFace & """>" & rsOrderLine("Seat") & "</TD><TD><FONT FACE=""" & MsgFontFace & """>" & rsOrderLine("SeatType") & "</TD><TD ALIGN=right><FONT FACE=""" & MsgFontFace & """>" & FormatCurrency(rsOrderLine("Price"),2) & "</TD>"
	
	If ColFacilityCharge = "Y" Then
		LineDetail = LineDetail & "<TD ALIGN=right><FONT FACE=""" & MsgFontFace & """>" & FormatCurrency(FacilityCharge,2) & "</TD>"
	End If
	
	If ColServiceFee = "Y" Then
		LineDetail = LineDetail & "<TD ALIGN=right><FONT FACE=""" & MsgFontFace & """>" & FormatCurrency(rsOrderLine("Surcharge"),2) & "</TD>"
	End If
	
	If ColDiscount = "Y" Then
		LineDetail = LineDetail & "<TD ALIGN=right><FONT FACE=""" & MsgFontFace & """>" & FormatCurrency(rsOrderLine("Discount"),2) & "</TD>"
	End If
	
	LineDetail = LineDetail & "<TD ALIGN=right><FONT FACE=""" & MsgFontFace & """>" & FormatCurrency(rsOrderLine("Price")+FacilityFee+rsOrderLine("Surcharge")-rsOrderLine("Discount"),2) & "</TD></TR>" & vbCrLf
	
	Response.Write LineDetail

	LastOrderNumber = rsOrderLine("OrderNumber")
	
	'-----------------------------------------
	
rsOrderLine.MoveNext	
Loop	

	
	
If TicketCount > 0 Then	'Print the last footer

	Response.Write "<TR><TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf	
	
	If LastShipFee <> 0 And LastOrderTypeNumber <> 5 Then
		Response.Write "<TR><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=""" & MsgFontFace & """>Processing Fee</TD><TD ALIGN=""right""><FONT FACE=""" & MsgFontFace & """>" & FormatCurrency(LastShipFee,2) & "</TD></TR>" & vbCrLf
		Response.Write "<TR><TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf
	End If

	SQLTender = "SELECT SUM(Tender.Amount) AS TenderAmount FROM Tender (NOLOCK) WHERE Tender.OrderNumber = " & LastOrderNumber
	Set rsTender = OBJdbConnection.Execute(SQLTender)
		If IsNull(rsTender("TenderAmount")) Then
			LastTender = 0
		Else
			LastTender = rsTender("TenderAmount")
			Response.Write SQLTender & "<BR>"
		End If
	rsTender.Close
	Set rsTender = nothing	

	Response.Write "<TR><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=""" & MsgFontFace & """>Total Order</TD><TD ALIGN=""right""><FONT FACE=""" & MsgFontFace & """>" & FormatCurrency(LastTotal,2) & "</TD></TR>" & vbCrLf
	
	If LastTender <> 0 Then
		Response.Write "<TR><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=""" & MsgFontFace & """>Less Payments</TD><TD ALIGN=""right""><FONT FACE=""" & MsgFontFace & """>" & FormatCurrency(LastTender,2) & "</TD></TR>" & vbCrLf
		Response.Write "<TR><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=""" & MsgFontFace & """>Balance Due</TD><TD ALIGN=""right""><FONT FACE=""" & MsgFontFace & """>" & FormatCurrency(LastTotal - LastTender,2) & "</TD></TR>" & vbCrLf
	End If
			
	Response.Write "</TABLE><BR>" & vbCrLf

	'-----------------------------------------
	
	'Footer Info
	'Insert HTML Template - Footer Content
	 Response.Write InsertTemplate("LetterInclude.asp","Footer") 
	
	'-----------------------------------------
	
	Response.Write "<div></div>"
	
	Response.Write "</CENTER>" & vbCrLf
			
End If

rsOrderLine.Close
Set rsOrderLine = nothing

%>
</FONT>
</BODY>
</HTML>

<%

End Sub 'PrintLetters

'-------------------------------------------------

Sub SendEmails

	DIM FName
	DIM LName
	
	'Build the Query to select each of the selected events
	'REE 7/7/3 - Removed EventShip from Query.
	SQLOrderLine = "SELECT OrderHeader.OrderTypeNumber, OrderHeader.OrderSurcharge, OrderHeader.ShipFee, OrderHeader.Total, OrderLine.OrderNumber, OrderLine.LineNumber, OrderLine.ItemNumber, OrderLine.Price, OrderLine.Surcharge, OrderLine.Discount, OrderLine.ShipCode, Event.EventCode, Event.EventDate, Event.Map, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, PostalCode, Customer.DayPhone, Customer.NightPhone, Customer.EMailAddress, Shipping.ShipType, Act.Act, Venue.Venue, SeatType.SeatType, Seat.Row, Seat.Seat, Seat.SectionCode, Section.Section FROM OrderLine INNER JOIN OrderHeader ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN Seat ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event ON Seat.EventCode = Event.EventCode INNER JOIN Section ON Seat.SectionCode = Section.SectionCode AND Event.EventCode = Section.EventCode INNER JOIN Act ON Event.ActCode = Act.ActCode INNER JOIN Venue ON Event.VenueCode = Venue.VenueCode INNER JOIN SeatType ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN Shipping ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct ON Event.ActCode = OrganizationAct.ActCode "
	For Each Item In Request("EventCode") 'Loop for each Event requested
		EventNumber = EventNumber + 1
		If SQLWhere = "" Then 
			SQLWhere = " WHERE Event.EventCode IN (" & Clean(Request("EventCode"))
		Else
			SQLWhere = SQLWhere & ", " & Clean(Request("EventCode"))
		End If
	Next

	'Get the Info to Print
	'REE 4/6/2 - Modified to use OrganizationAct in selection criteria
	SQLOrderLine = SQLOrderLine & SQLWhere & ") AND OrderLine.StatusCode = 'R' AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') AND Customer.EMailAddress IS NOT NULL AND Customer.EMailAddress <> '' AND OrderHeader.OrderNumber > 2082898 ORDER BY OrderLine.OrderNumber, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry, OrderLine.ShipCode, Seat.EventCode, Seat.SectionCode, RowSort, SeatSort DESC"
	Set rsOrderLine = OBJdbConnection.Execute(SQLOrderLine)
				
		Do Until rsOrderLine.EOF

			If rsOrderLine("OrderNumber") <> LastOrderNumber Then 
			'This is not the last order.
			
				'Print the footer
				If TicketCount > 0 Then
				
					EMailMessage = EMailMessage & "<TR><TD WIDTH=""50"">&nbsp;</TD><TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf			
					If LastShipFee <> 0 And LastOrderTypeNumber <> 5 Then
						EMailMessage = EMailMessage & "<TR><TD WIDTH=""50"">&nbsp;</TD><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=" & MsgFontFace & ">Processing Fee</TD><TD ALIGN=""right""><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(LastShipFee,2) & "</TD></TR>" & vbCrLf
						EMailMessage = EMailMessage & "<TR><TD WIDTH=""50"">&nbsp;</TD><TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf
					End If

					SQLTender = "SELECT SUM(Tender.Amount) AS TenderAmount FROM Tender (NOLOCK) WHERE Tender.OrderNumber = " & LastOrderNumber
					Set rsTender = OBJdbConnection.Execute(SQLTender)
				
					If IsNull(rsTender("TenderAmount")) Then
						LastTender = 0
					Else
						LastTender = rsTender("TenderAmount")
						Response.Write SQLTender & "<BR>"
					End If
				
					rsTender.Close
					Set rsTender = nothing	

					EMailMessage = EMailMessage & "<TR><TD WIDTH=""50"">&nbsp;</TD><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=" & MsgFontFace & ">Order Total</TD><TD ALIGN=""right""><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(LastTotal,2) & "</TD></TR>" & vbCrLf
					If LastTender <> 0 Then
						EMailMessage = EMailMessage & "<TR><TD WIDTH=""50"">&nbsp;</TD><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=C" & MsgFontFace & ">Less Payments</TD><TD ALIGN=""right""><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(LastTender,2) & "</TD></TR>" & vbCrLf
						EMailMessage = EMailMessage & "<TR><TD WIDTH=""50"">&nbsp;</TD><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=" & MsgFontFace & ">Balance Due</TD><TD ALIGN=""right""><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(LastTotal - LastTender,2) & "</TD></TR>" & vbCrLf
					End If
					EMailMessage = EMailMessage & "</TABLE>" & vbCrLf
					EMailMessage = EMailMessage & "</CENTER><BR>" & vbCrLf
					
					'-----------------------------------------
					
					'Insert HTML Template - Footer Content
					EMailMessage = EMailMessage & InsertTemplate(EmailTemplateFile,"Footer") 
					
					'-----------------------------------------

					'JAI 3/2/5 - Modified to use CDO Mail
					'Create the e-mail server object
					Set objCDOSYSMail = Server.CreateObject("CDO.Message")
					Set objCDOSYSCon = Server.CreateObject ("CDO.Configuration")

					objCDOSYSCon.Fields(cdoSendUsingMethod) = cdoSendUsingPickup 'For localhost
					objCDOSYSCon.Fields.Update

					'Update the CDOSYS Configuration
					Set objCDOSYSMail.Configuration = objCDOSYSCon
					objCDOSYSMail.From = EMailOrganization & " <" & EMailReplyTo & ">" 
					objCDOSYSMail.ReplyTo = EMailReplyTo
					If TestEMailAddress <> "" Then
						EmailAddress = LastEMailAddress
						LastEMailAddress = TestEMailAddress
					End If
					objCDOSYSMail.To = LastEMailAddress
					objCDOSYSMail.Subject = EMailSubject
					objCDOSYSMail.HTMLBody = EMailMessage
					objCDOSYSMail.Send

					'Close the server mail object
					Set objCDOSYSMail = Nothing
					Set objCDOSYSCon = Nothing 

					EMailMessage = ""
					
					'One Log Results

					OrderIndex = OrderCount + 1
					
					logResults = logResults & "<id>" & OrderCount  & "</id><organizationnumber>" & Session("OrganizationNumber") & "</organizationnumber><ordernumber>" & LastOrderNumber & "</ordernumber><firstname>" & ShipFName & "</firstname><lastname>" & ShipLName & "</lastname><emailaddress>" & LastEMailAddress & "</emailaddress><renewalnumber>" & CustomerNumber & "-" & OrderItemNumber & "</renewalnumber><datesent>" & Now() & "</datesent>,"
				
					If TestEMailAddress <> "" And OrderCount >= TestEmailCount Then
						Exit Do
					End If

				End If

				SQLCustInfo = "SELECT Customer.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry FROM OrderHeader (NOLOCK) INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber WHERE OrderHeader.OrderNumber = " & rsOrderLine("OrderNumber") & " AND OrderLine.LineNumber = " & rsOrderLine("LineNumber")
				Set rsCustInfo = OBJdbConnection.Execute(SQLCustInfo)

				If Not rsCustInfo.EOF Then
				
					'-----------------------------------------
					
					'Insert HTML Template - Header Content
					EMailMessage = EMailMessage & InsertTemplate(EmailTemplateFile,"Header") 
					
					'-----------------------------------------
								
					'Insert HTML Template - Masthead Content
					EMailMessage = EMailMessage & InsertTemplate(EmailTemplateFile,"Masthead") 
					
					'-----------------------------------------
								
					'Shipping and Billing Address
					
					EMailMessage = EMailMessage & "<TABLE WIDTH=""750"" cellpadding=""0"" cellspacing=""0""  border=""0"">" & vbCrLf
					EMailMessage = EMailMessage & "<TR>" & vbCrLf
					EMailMessage = EMailMessage & "<TD WIDTH=""400""><FONT FACE=""" & MsgFontFace & """><B>Shipping Information</B></TD>" & vbCrLf
					EMailMessage = EMailMessage & "<TD WIDTH=""330""><FONT FACE=""" & MsgFontFace & """><B>Billing Information</B></TD>" & vbCrLf
					EMailMessage = EMailMessage & "</TR>" & vbCrLf
					EMailMessage = EMailMessage & "<TR>" & vbCrLf
					EMailMessage = EMailMessage & "<TD>" & vbCrLf
					
					ShipFName = rsCustInfo("ShipFirstName")
					ShipLName = rsCustInfo("ShipLastName") 
					
					EMailMessage = EMailMessage & "<FONT FACE=""" & MsgFontFace & """>" & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & "<BR>" & rsCustInfo("ShipAddress1") & "<BR>" & vbCrLf
					
					If rsCustInfo("ShipAddress2") <> "" Then
						EMailMessage = EMailMessage & rsCustInfo("ShipAddress2") & "<BR>" & vbCrLf
					End If
					
					EMailMessage = EMailMessage & rsCustInfo("ShipCity") & ", " & rsCustInfo("ShipState") & " " & rsCustInfo("ShipPostalCode") & "" & vbCrLf
					
					EMailMessage = EMailMessage & "</TD>" & vbCrLf
					EMailMessage = EMailMessage & "<TD>" & vbCrLf
					EMailMessage = EMailMessage & "<FONT FACE=""" & MsgFontFace & """>" & rsCustInfo("FirstName") & " " & rsCustInfo("LastName") & "<BR>" & rsCustInfo("Address1") & "<BR>" & vbCrLf
					
					If rsCustInfo("Address2")<> "" Then
						EMailMessage = EMailMessage & rsCustInfo("Address2") & "<BR>" & vbCrLf
					End If
					
					EMailMessage = EMailMessage & rsCustInfo("City") & ", " & rsCustInfo("State") & " " & rsCustInfo("PostalCode") & "" & vbCrLf
					EMailMessage = EMailMessage &"</TD>" & vbCrLf
					EMailMessage = EMailMessage & "</TR>" & vbCrLf
					EMailMessage = EMailMessage & "<TR>" & vbCrLf
					EMailMessage = EMailMessage & "<TD COLSPAN=""3""><hr></TD>" & vbCrLf
					EMailMessage = EMailMessage & "</TR>" & vbCrLf
					EMailMessage = EMailMessage & "</TABLE>" & vbCrLf
					
					EMailMessage = EMailMessage & "<BR>" & vbCrLf
					
					'-----------------------------------------
					
					'Order Number and Renewal Number
					
					EMailMessage = EMailMessage & "<TABLE WIDTH=""750"" cellpadding=""0"" cellspacing=""0"" border=""0"">" & vbCrLf
					EMailMessage = EMailMessage & "<TR>" & vbCrLf
					EMailMessage = EMailMessage & "<TD ALIGN=""left"">" & vbCrLf
					EMailMessage = EMailMessage & "<FONT FACE=""" & MsgFontFace & """><B>Order Number:</B>&nbsp;" & rsOrderLine("OrderNumber") & "</FONT>" & vbCrLf
					EMailMessage = EMailMessage & "</TD>" & vbCrLf
					EMailMessage = EMailMessage & "<TD ALIGN=""right"">" & vbCrLf
					
					SQLItemNumber = "SELECT ItemNumber FROM OrderLine (NOLOCK) WHERE OrderNumber = " & rsOrderLine("OrderNumber") & " ORDER BY ItemNumber"
					Set rsItemNumber = OBJdbConnection.Execute(SQLItemNumber)
						CustomerNumber = rsCustInfo("CustomerNumber")
						OrderItemNumber = rsItemNumber("ItemNumber")
						RenewalCode = rsCustInfo("CustomerNumber") & rsItemNumber("ItemNumber")
					rsItemNumber.Close
					Set rsItemNumber = nothing
					
					EMailMessage = EMailMessage & "<FONT FACE=""" & MsgFontFace & """><B>Renewal Code:</B>&nbsp;" & RenewalCode & "</FONT>" & vbCrLf
					EMailMessage = EMailMessage & "</TD>" & vbCrLf
					EMailMessage = EMailMessage & "</TR>" & vbCrLf
					EMailMessage = EMailMessage & "</TABLE>" & vbCrLf
					EMailMessage = EMailMessage & "<BR>" & vbCrLf
					
					'-----------------------------------------

				Else

					ErrorLog("Invoice Format - Order Number = " & Clean(Request("OrderNumber")) & " | Line Number = " & Clean(Request("LineNumber")))

				End If

				rsCustInfo.Close
				Set rsCustInfo = nothing

				LastEventCode = 0
				LastOrderNumber = rsOrderLine("OrderNumber")
				LastOrderTypeNumber = rsOrderLine("OrderTypeNumber")
						
				'Update the Footer Totals
				LastOrderSurcharge = rsOrderLine("OrderSurcharge")
				LastShipType = rsOrderLine("ShipType")
				LastShipFee = rsOrderLine("ShipFee")
				LastDiscount = rsOrderLine("Discount")
				LastTotal = rsOrderLine("Total")
				
				LastEMailAddress = rsOrderLine("EMailAddress")
				
				TicketCount = TicketCount + 1

			End If

			'Print Event Info and Column Headings if this is a new Event
			If LastEventCode <> rsOrderLine("EventCode") Or LastOrderNumber <> rsOrderLine("OrderNumber") Then
			
				If LastEventCode <> 0 AND LastEventCode <> rsOrderLine("EventCode") Then
					EMailMessage = EMailMessage & "</TABLE><BR>" & vbCrlf
				End if
				
				'-----------------------------------------
					
				'Production Name, Date & Time
				'Order Delivery Method
			
				EMailMessage = EMailMessage & "<TABLE WIDTH=""750"" cellpadding=""0"" cellspacing=""0""  border=""0"">" & vbCrLf
				EMailMessage = EMailMessage & "<TR><TD><FONT FACE=""" & MsgFontFace & """><B>" & rsOrderLine("Act") & " at " & rsOrderLine("Venue") & "" & vbCrLf
				
				'REE 6/5/6 - Modified to look at EventOptions for Date & Time Display Options
				SQLDateSuppress = "SELECT OptionValue AS DateSuppress FROM EventOptions (NOLOCK) WHERE EventCode = " & rsOrderLine("EventCode") & " AND OptionName = 'DateSuppress' AND OptionValue = 'Y'"
				Set rsDateSuppress = OBJdbConnection.Execute(SQLDateSuppress)
				If rsDateSuppress.EOF Then
					EMailMessage = EMailMessage & " on " & FormatDateTime(rsOrderLine("EventDate"),vbShortDate)
				End If
				rsDateSuppress.Close
				Set rsDateSuppress = nothing

				SQLTimeSuppress = "SELECT OptionValue AS TimeSuppress FROM EventOptions (NOLOCK) WHERE EventCode = " & rsOrderLine("EventCode") & " AND OptionName = 'TimeSuppress' AND OptionValue = 'Y'"
				Set rsTimeSuppress = OBJdbConnection.Execute(SQLTimeSuppress)
				If rsTimeSuppress.EOF Then
					EMailMessage = EMailMessage & " at " & Left(FormatDateTime(rsOrderLine("EventDate"),vbLongTime),Len(FormatDateTime(rsOrderLine("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsOrderLine("EventDate"),vbLongTime),3)
				End If
				rsTimeSuppress.Close
				Set rsTimeSuppress = nothing

				EMailMessage = EMailMessage & "</B><BR>Delivery Method: " & rsOrderLine("ShipType") & "</TD></TR>" & vbCrLf
				EMailMessage = EMailMessage & "</TABLE>" & vbCrLf
				
				EMailMessage = EMailMessage & "<BR>" & vbCrLf
				
				'-----------------------------------------
				
				'Seat Location, Price, Service Fee

				'Calculate Number of Columns
				SQLNumColumns = "SELECT SUM(OrderLine.Surcharge) AS ServiceFee, SUM(OrderLine.Discount) AS Discount FROM OrderLine WHERE OrderNumber = " & rsOrderLine("OrderNumber") & " AND ItemType IN ('Seat', 'SubFixedEvent')"
				Set rsNumColumns = OBJdbConnection.Execute(SQLNumColumns)

				NumColumns = 6
				ColumnHeading = "<TABLE WIDTH=""660"" BORDER=""0""><TR><TD WIDTH=10>&nbsp;</TD><TD><FONT FACE=" & MsgFontFace & "><B><U>Section</U></B></FONT></TD><TD ALIGN=center><FONT FACE=" & MsgFontFace & "><B><U>Row</U></B></FONT></TD><TD ALIGN=center><FONT FACE=" & MsgFontFace & "><B><U>Seat</U></B></FONT></TD><TD><FONT FACE=" & MsgFontFace & "><B><U>Type</U></B></FONT></TD><TD ALIGN=right><FONT FACE=" & MsgFontFace & "><B><U>Price</U></B></FONT></TD>"
				
				FacilityCharge = 0
				If FacilityCharge <> 0 Then
					NumColumns = NumColumns + 1
					ColumnHeading = ColumnHeading + "<TD ALIGN=right><FONT FACE=" & MsgFontFace & "><B><U>Facility Charge</U></B></FONT></TD>"
					ColFacilityCharge = "Y"
				End If
				
				If rsNumColumns("ServiceFee") <> 0 Then
					NumColumns = NumColumns + 1
					ColumnHeading = ColumnHeading + "<TD ALIGN=right><FONT FACE=" & MsgFontFace & "><B><U>Service Fee</U></B></FONT></TD>"
					ColServiceFee = "Y"
				End If
				
				If rsNumColumns("Discount") <> 0 Then
					NumColumns = NumColumns + 1
					ColumnHeading = ColumnHeading + "<TD ALIGN=right><FONT FACE=" & MsgFontFace & "><B><U>Discount</U></B></FONT></TD>"
					ColDiscount = "Y"
				End If

				rsNumColumns.Close
				Set rsNumColumns = nothing

				ColumnHeading = ColumnHeading + "<TD ALIGN=right><FONT FACE=" & MsgFontFace & "><B><U>Amount</U></B></FONT></TD></TR>" & vbCrLf
				
				EMailMessage = EMailMessage & ColumnHeading

				LastEventCode = rsOrderLine("EventCode")
				
				'-----------------------------------------
				
			End If
			
			'-----------------------------------------
				
			'Facility Charge, Surcharge, Discount, Price
			
			LineDetail = "<TR><TD WIDTH=10>&nbsp;</TD><TD><FONT FACE=" & MsgFontFace & ">" & rsOrderLine("Section") & "</FONT></TD><TD ALIGN=center><FONT FACE=" & MsgFontFace & ">" & rsOrderLine("Row") & "</FONT></TD><TD ALIGN=center><FONT FACE=" & MsgFontFace & ">" & rsOrderLine("Seat") & "</FONT></TD><TD><FONT FACE=" & MsgFontFace & ">" & rsOrderLine("SeatType") & "</FONT></TD><TD ALIGN=right><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(rsOrderLine("Price"),2) & "</FONT></TD>"
			
			If ColFacilityCharge = "Y" Then
				LineDetail = LineDetail & "<TD ALIGN=right><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(FacilityCharge,2) & "</FONT></TD>"
			End If
			If ColServiceFee = "Y" Then
				LineDetail = LineDetail & "<TD ALIGN=right><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(rsOrderLine("Surcharge"),2) & "</FONT></TD>"
			End If
			If ColDiscount = "Y" Then
				LineDetail = LineDetail & "<TD ALIGN=right><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(rsOrderLine("Discount"),2) & "</FONT></TD>"
			End If
			
			LineDetail = LineDetail & "<TD ALIGN=right><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(rsOrderLine("Price")+FacilityFee+rsOrderLine("Surcharge")-rsOrderLine("Discount"),2) & "</FONT></TD></TR>" & vbCrLf
			
			EMailMessage = EMailMessage & LineDetail

			LastOrderNumber = rsOrderLine("OrderNumber")
			
			'-----------------------------------------
			
		rsOrderLine.MoveNext	
		Loop	
		
		If TicketCount > 0 Then	'Print the last footer

			EMailMessage = EMailMessage & "</TABLE>" & vbCrLf
			EMailMessage = EMailMessage & "</CENTER><BR>" & vbCrLf
			EMailMessage = EMailMessage & EMailMessageBody
			
			If TestEMailAddress = "" Then
			
					EMailMessage = EMailMessage & "<TR><TD WIDTH=""50"">&nbsp;</TD><TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf			
					
					If LastShipFee <> 0 And LastOrderTypeNumber <> 5 Then
						EMailMessage = EMailMessage & "<TR><TD WIDTH=""50"">&nbsp;</TD><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=" & MsgFontFace & ">Processing Fee</TD><TD ALIGN=""right""><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(LastShipFee,2) & "</TD></TR>" & vbCrLf
						EMailMessage = EMailMessage & "<TR><TD WIDTH=""50"">&nbsp;</TD><TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf
					End If

					SQLTender = "SELECT SUM(Tender.Amount) AS TenderAmount FROM Tender (NOLOCK) WHERE Tender.OrderNumber = " & LastOrderNumber
					Set rsTender = OBJdbConnection.Execute(SQLTender)
						If IsNull(rsTender("TenderAmount")) Then
							LastTender = 0
						Else
							LastTender = rsTender("TenderAmount")
							Response.Write SQLTender & "<BR>"
						End If
					rsTender.Close
					Set rsTender = nothing	

					EMailMessage = EMailMessage & "<TR><TD WIDTH=""50"">&nbsp;</TD><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=" & MsgFontFace & ">Order Total</TD><TD ALIGN=""right""><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(LastTotal,2) & "</TD></TR>" & vbCrLf
					
					If LastTender <> 0 Then
						EMailMessage = EMailMessage & "<TR><TD WIDTH=""50"">&nbsp;</TD><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=" & MsgFontFace & ">Less Payments</TD><TD ALIGN=""right""><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(LastTender,2) & "</TD></TR>" & vbCrLf
						EMailMessage = EMailMessage & "<TR><TD WIDTH=""50"">&nbsp;</TD><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=" & MsgFontFace & ">Balance Due</TD><TD ALIGN=""right""><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(LastTotal - LastTender,2) & "</TD></TR>" & vbCrLf
					End If
								
					EMailMessage = EMailMessage & "</TABLE><BR>" & vbCrLf
					
					'-----------------------------------------
					
					'Footer Info
					'Insert HTML Template - Footer Content
					 EMailMessage = EMailMessage & InsertTemplate(EmailTemplateFile,"Footer") 
					
					'-----------------------------------------
					
					EMailMessage = EMailMessage & "</CENTER>" & vbCrLf
					

				'JAI 3/2/5 - Modified to use CDO Mail
				'Create the e-mail server object
				Set objCDOSYSMail = Server.CreateObject("CDO.Message")
				Set objCDOSYSCon = Server.CreateObject ("CDO.Configuration")

				objCDOSYSCon.Fields(cdoSendUsingMethod) = cdoSendUsingPickup 'For localhost
				objCDOSYSCon.Fields.Update

				'Update the CDOSYS Configuration
				Set objCDOSYSMail.Configuration = objCDOSYSCon
				objCDOSYSMail.From = EMailOrganization & " <" & EMailReplyTo & ">" 
				objCDOSYSMail.ReplyTo = EMailReplyTo
				objCDOSYSMail.To = LastEMailAddress
				objCDOSYSMail.BCC = ""
				objCDOSYSMail.Subject = EMailSubject
				objCDOSYSMail.HTMLBody = EMailMessage
				objCDOSYSMail.Send

				'Close the server mail object
				Set objCDOSYSMail = Nothing
				Set objCDOSYSCon = Nothing 
				
				'Two Log Results

				OrderCount = OrderCount + 1
				
				logResults = logResults & "<id>" & OrderCount  & "</id><organizationnumber>" & Session("OrganizationNumber") & "</organizationnumber><ordernumber>" & LastOrderNumber & "</ordernumber><firstname>" & ShipFName & "</firstname><lastname>" & ShipLName & "</lastname><emailaddress>" & LastEMailAddress & "</emailaddress><renewalnumber>" & CustomerNumber & "-" & OrderItemNumber & "</renewalnumber><datesent>" & Now() & "</datesent>,"
			
			End If
			
			EMailMessage = ""

		End If

		'Response.Write "Order Count: " & OrderCount & "<BR>"
	
	rsOrderLine.Close
	Set rsOrderLine = nothing

	
End Sub 'Send Emails

'==================================================================================
'RenewalLetters_Include.asp
'==================================================================================

Sub checkStatus

	EmTab = ""
	LgTab = ""
	LtTab = ""

	If strMode = "" Then
		If Request.QueryString("mode") <> "" Then
			strMode = request.queryString("mode")
		Else
			strMode = "letters"
		End If
	End If
	
	
	If fileCount("logs","txt") = 0 Then
		LgTab = "disabled"	
	End If
	
 
	If Request.Form("logAction") <> "" Then
		xmlFileName = Request.Form("fileName")
		Select Case Request.Form("logAction")
			Case "Delete"
				Call DeleteFile(xmlFileName)
			Case "View"
				strMode = "logs"
		End Select
	End If
	

	Select Case strMode		
		Case "emails"
			EmTab = "active"
			strTitle = "Emails"			
		Case "letters"
			LtTab = "active"
			strTitle = "Letters"	
		Case "loglist"
			If LgTab <> "disabled" Then
				LgTab = "active"
				strTitle = "Logs"
			End If
		Case "logs"
			strTitle = "Email Log: " & xmlFileName & ""
			LgTab = "active"
		Case Else
			LtTab = "active"
	End Select
	
End Sub

'-------------------------------------------------

Sub PanelEdit
  
  %>
	 
	<DIV class="container-fluid effect1" id="panel-edit-inner">

		<ul class="nav nav-pills nav-stacked col-sm-3" style="margin-top: 15px;">
			<li class="active"><a href="#tab1" data-toggle="tab">Email Testing</a></li>
			<li><a href="#tab2" data-toggle="tab">Option 2</a></li>
			<li><a href="#tab3" data-toggle="tab">Option 3</a></li>
			<li><a href="#tab4" data-toggle="tab">Option 4</a></li>
		</ul>
		
		<div class="tab-content col-sm-9">
				
			<div class="tab-pane active" id="tab1">
			
				<form class="form-horizontal" role="form">
				
					<div class="form-group">
						<label class="col-sm-3 control-label">Test Mode:</label>
						<div class="col-lg-7">
							<label class="switch switch-success">
								<input type="checkbox" id="email-switch" class="switch-input form control"> 
								<span class="switch-label" data-on="ON" data-off="OFF"></span>
								<span class="switch-handle"></span>
							</label>
						</div>
					</div>
					
					<div class="form-group">
						<label class="col-sm-3 control-label">Email Address</label>
						<div class="col-lg-7">
							<select class="email-control form-control">
								<option>Select Email Address</option>
								<option>sergio.rodriguez@tix.com</option>
								<option>sergio@tix.com</option>
								<option>sergio.rodriguez.delao@gmail.com</option>
							</select>	
						</div>
						<div class="col-sm-2">
							<button type="button" class="btn btn-primary email-control form control">
								<i class="glyphicon glyphicon-send"></i>
							</button>
						</div>
					</div>
						
					<div class="form-group">
						<label class="col-sm-3 control-label"></label>
						<div class="col-lg-7">
							<input type="submit" class="btn btn-primary" value="Submit" /> 
						</div>
					</div>
						
				</form>
				
			</div>

			<div class="tab-pane" id="tab2" style="border:2px solid rgb(222, 223, 225); border-radius:4px; padding: 5px; min-height: 250px;">
				<h3>Page 2</h3>
			</div>
			
			<div class="tab-pane" id="tab3" style="border:2px solid rgb(222, 223, 225); border-radius:4px; padding: 5px; min-height: 250px;">
				<h3>Page 3</h3>
			</div>
			
			<div class="tab-pane" id="tab4" style="border:2px solid rgb(222, 223, 225); border-radius:4px; padding: 5px; min-height: 250px;">
				<h3>Page 4</h3>
			</div>

		</div>
		
	</DIV>
	  
<%

End Sub 'Panel Edit

'-------------------------------------------------
	
PUBLIC FUNCTION GetOrgName

SQLThisOrg = "Select  Organization  FROM Organization (NOLOCK) WHERE OrganizationNumber = " &  Session("OrganizationNumber") & ""
Set rsThisOrg = OBJdbConnection.Execute(SQLThisOrg)
	OrgName = rsThisOrg("Organization") 
rsThisOrg.Close
Set rsThisOrg = Nothing

GetOrgName = OrgName

END FUNCTION

'-------------------------------------------------

PUBLIC FUNCTION GetPrivateLabel

OrgNumbr = Session("OrganizationNumber")

DIM strTemp
strTemp = ""

SQLVenueRefCheck = "SELECT VenueCode, OptionName, OptionValue FROM VenueOptions WITH (NOLOCK) WHERE VenueCode = (SELECT TOP 1 VenueCode FROM VenueOptions (NOLOCK) WHERE OptionName = 'OrganizationNumber' AND OptionValue = '" & OrgNumbr & "') AND (OptionName = 'VenueReference')"
Set rsVenueRefCheck = OBJdbConnection.Execute(SQLVenueRefCheck)
If NOT rsVenueRefCheck.EOF Then
	strTemp = rsVenueRefCheck("OptionValue")
End If
rsVenueRefCheck.Close
Set rsVenueRefCheck = nothing

GetPrivateLabel = strTemp


END FUNCTION

'---------------------------------------

PUBLIC FUNCTION checkTixUser

	Dim strResult
	strResult = FALSE

		SQLOrgUsers = "Select UserNumber FROM Users (NOLOCK) WHERE OrganizationNumber = 1 AND UserNumber = " & Session("UserNumber") & ""
		Set rsOrgUsers = OBJdbConnection.Execute(SQLOrgUsers)

			If NOT rsOrgUsers.EOF Then
				strResult = TRUE
			End If
			
		rsOrgUsers.Close
		Set rsOrgUsers = Nothing

		checkTixUser = strResult

END FUNCTION

'-------------------------------------------------

PUBLIC FUNCTION GetUserEmails(OrgNumbr)

	'Generates an email address list for users  associated with the organization

	thisUserNumber = Session("UserNumber")

	DIM status
	status = ""

	SQLOrgUsers = "SELECT UserNumber, FirstName, LastName, EMailAddress, Status FROM Users (NOLOCK) WHERE OrganizationNumber = " &  OrgNumbr & " AND Status = 'A' AND USERS.EMailAddress is not null and len(USERS.EMailAddress) > 1"
	Set rsOrgUsers = OBJdbConnection.Execute(SQLOrgUsers)

		If Not rsOrgUsers.EOF Then 
			Do Until rsOrgUsers.EOF
			
				If rsOrgUsers("UserNumber") = Session("UserNumber") Then
					status="selected"
				Else
					status=""
				End If
				
				Name ="<option value="" " & rsOrgUsers("EMailAddress") & " "" >" & rsOrgUsers("FirstName") & "&nbsp;" & rsOrgUsers("LastName") & "&nbsp;(" & rsOrgUsers("EMailAddress") & ")</option>"							
				
				UserEmailList = UserEmailList & "," & Name
				
			rsOrgUsers.MoveNext
			Loop
		End If	

	rsOrgUsers.Close
	Set rsOrgUsers = Nothing

	UserEmailList = trimComma(UserEmailList)
	
	GetUserEmails = UserEmailList

END FUNCTION

'-------------------------------------------------

PUBLIC FUNCTION trimComma(strText)

	'This function trims any commas from the start and end of the string submitted

	If Right(strText, 1) = "," Then
	strText = Left(strText, Len(strText) - 1)  
	End If

	If Left(strText, 1) = "," Then 
	strText = Right(strText, Len(strText) - 1)  
	End If

	trimComma = strText

END FUNCTION 

'-------------------------------------------------

PUBLIC FUNCTION getFolderPath(strFolderName)

		DIM strTemp
		DIM strPath

		'get the current folder URL path
		strTemp = Mid(Request.ServerVariables("URL"),2)
		strPath = ""

		Do While Instr(strTemp,"/")
		strPath = strPath & Left(strTemp,Instr(strTemp,"/"))
		strTemp = Mid(strTemp,Instr(strTemp,"/")+1)      
		Loop

		strPath = "/" & strPath
		
		If strFolderName <> "" Then
			strPath = strPath & strFolderName
			strPath = strPath & "/" 
		End If
		
		strPath = Server.Mappath(strPath)
		
		strPath = strPath & "\"

		getFolderPath = strPath

END FUNCTION
 
'-------------------------------------------------

PUBLIC FUNCTION createFileName

	DIM dtDate
	DIM strFileName

	Dim dtHour
	Dim dtMin

	dtDate = Now()

	dtYear = CStr(Year(dtDate))
	dtMonth = Right("00" & Month(dtDate), 2)
	dtDay = Right("00" & Day(dtDate), 2) 

	dtHour = Hour(dtDate)
	If Len(Hour(dtDate)) = 1 Then 
	dtHour = "0" & Hour(dtDate)
	End If

	dtMin = Minute(dtDate)
	If Len(dtMin) = 1 Then 
		dtMin = "0" & dtMin
	End If
		
	strFileName = "" & dtYear & "-"& dtMonth & "-" & dtDay & "-" & dtHour & dtMin & ".txt"

	createFileName = strFileName

END FUNCTION 'createFileName
 
'-------------------------------------------------

	PUBLIC FUNCTION getFileList

		DIM xmlFolderPath
		xmlFolderPath = getFolderPath("logs")
					 
		DIM objFSO
		set objFSO  = Server.CreateObject( "Scripting.FileSystemObject" )
		
		If Not objFSO.FolderExists( xmlFolderPath ) Then 
			objFSO.CreateFolder ( xmlFolderPath )
		End If
		
		strPath= xmlFolderPath

		Set filesystem = CreateObject("Scripting.FileSystemObject")
		Set folder = filesystem.GetFolder(xmlFolderPath)

		Set filecollection = folder.Files
		For Each file in filecollection
		
			If instr(file.Name,".xml") <> 0 Then
			
				strFileList = strFileList & "<tr>"
				
				strFileList = strFileList & "<td><INPUT TYPE=""radio"" NAME=""fileName"" VALUE=" & file.name & "></td>"
				strFileList = strFileList & "<td>" & file.Name & "</td>"
				strFileList = strFileList & "<td>" & file.DateCreated & "</td>"
				strFileList = strFileList & "<td>" & file.ParentFolder & "</td>"
				strFileList = strFileList & "<td>" & file.Size & "</td>"
				strFileList = strFileList & "<td>" & file.Type & "</td>"
				
				strFileList = strFileList & "</tr>"
				
			End If
			
		Next

		set filesystem=nothing
		set folder=nothing
		set filecollection=nothing
	
		getFileList = strFileList

	END FUNCTION

'-------------------------------------------------

Function fileCount(strFolderName,strFileExt)

	dim Count
	Count = 0

	dim objFSO
    set objFSO = Server.CreateObject("SCRIPTING.FILESYSTEMOBJECT")
	
	strFolderPath = getFolderPath(strFolderName)

    dim objFolder
    set objFolder = objFSO.GetFolder(strFolderPath)

    dim objFile
 
    For Each objFile in objFolder.Files
		If objFSO.GetExtensionName(objFile.Path)= strFileExt Then
			Count = Count + 1
		End If
	Next
 
	
    set objFile = nothing
    set objFolder = nothing
    set objFSO = nothing
 
	fileCount = Count

End Function

'-------------------------------------------------

Sub DeleteFile(xmlFileName)
 
	DIM xmlFolderPath
	xmlFolderPath = getFolderPath("logs")

	DIM xmlFilePath
	xmlFilePath = xmlFolderPath & "\" & xmlFileName
	
	DIM ObjFSO
	Set ObjFSO = Server.CreateObject("Scripting.FileSystemObject")
			
	If Not ObjFSO.FileExists(xmlFilePath) Then 
		response.write "Error_12:  XML file does not exist: " & xmlFilePath & "<BR><BR>"
		response.end
	End If

	'Delete Files 
	ObjFSO.DeleteFile xmlFilePath, True 

	Set ObjFSO = nothing
	
	If fileCount("logs","txt") = 0 Then
		strMode = "emails"
		LgTab = "disabled"	
		EmTab = "active"
		strTitle = "Send Emails"
	Else
		strMode = "loglist"
		LgTab = "active"
		EmTab = ""
		strTitle = "Log Listing"
	End If

End Sub

'==================================================================================
'EmailInclude.asp
'==================================================================================

PUBLIC FUNCTION InsertTemplate(templateFile,templateName)

'Insert HTML content

Dim  strText
strText = ""

Dim strNewText
strNewText = ""


	Const ForReading = 1

	Set objFSO = CreateObject("Scripting.FileSystemObject")
	
	templatePath = Server.MapPath(templateFile)

	If objFSO.FileExists(templatePath) Then

		Set objFile = objFSO.OpenTextFile(templatePath, ForReading)

		strContents = objFile.ReadAll
		objFile.Close

		strStartText = "[" & templatename & "]"
		strEndText = "[/" & templatename & "]"

		intStart = InStr(strContents, strStartText)
		intStart = intStart + Len(strStartText)

		intEnd = InStr(strContents, strEndText)

		intCharacters = intEnd - intStart

		strText = Mid(strContents, intStart, intCharacters)
		
		'Replace
		strNewText = replaceVar(strText)
		
		'Clean
		strNewText = cleanBOM(strNewText)

	End If
	
	InsertTemplate = strNewText
			
END FUNCTION

'-------------------------------------------------

PUBLIC FUNCTION cleanBOM(strText)

	'remove BOM if present http://unicode.org/faq/utf_bom.html

	If (Len(Trim(strText)) > 0) Then
	
		Dim AscValue : AscValue = Asc(Trim(strText))
	  
		If ((AscValue = -15441) Or (AscValue = 239)) Then : strText = Mid(Trim(strText),4) : End If
	  
	End If
	
	cleanBOM = strText
	
END FUNCTION 

'-------------------------------------------------

PUBLIC FUNCTION replaceVar(strText)

		'replace placeholders with actual text

		DIM strNewText

		strNewText = Replace(strNewText, "[orgNumber]", orgNumber)
		strNewText = Replace(strNewText, "[OrgName]", GetOrgName(Session("OrganizationNumber")))
		strNewText = Replace(strNewText, "[customerID]", customerID)
		strNewText = Replace(strText, 	 "[recipientFName]", recipientFName)
		strNewText = Replace(strNewText, "[webSite]", webSite)
		strNewText = Replace(strNewText, "[senderFName]", senderFName)
		strNewText = Replace(strNewText, "[senderLName]", senderLName)
		strNewText = Replace(strNewText, "[senderAddress]", senderAddress)

		strNewText = Replace(strNewText, "[MsgRenewalURL]",MsgRenewalURL)
		strNewText = Replace(strNewText, "[ServerName]",Request.ServerVariables("server_name"))
		
		replaceVar = strNewText
		
END FUNCTION 


'==================================================================================
'LogFileinclude.asp
'==================================================================================

Sub SaveEmailLog

	DIM tab
	tab = chr(9)

	DIM objFSO
	set objFSO  = Server.CreateObject( "Scripting.FileSystemObject" )

	xmlFileName = createFileName

	If xmlFileName = "" Then
		  response.write "Error 10: : XML file name missing<BR>"
	end if

	DIM xmlFolderPath
	xmlFolderPath = getFolderPath("logs")

	DIM xmlFilePath
	xmlFilePath = xmlFolderPath & "\" & xmlFileName

	If Not objFSO.FileExists( xmlFilePath ) Then 
		objFSO.CreateTextFile( xmlFilePath )
	End If

	DIM ojbWrite
	set objWrite = objFSO.OpenTextFile( xmlFilePath, 2 )

	objWrite.WriteLine("<?xml version=""1.0"" encoding=""UTF-8""?>")
	objWrite.WriteLine("<emaillist>")

		DIM logArray
		logArray = Split(logResults,",") 

		For i = LBound(logArray) to UBound(logArray)
			objWrite.WriteLine(tab & "<email>" & logArray(i) & "</email>")
		Next

	objWrite.WriteLine("</emaillist>")
	
	objWrite.Close()
	
	strMode = "logs"

End Sub

'-------------------------------------------------
 
Sub DisplayLogList

	%>
	
	<div class="right-content clearfix">

			<FORM ACTION="" METHOD="post">
			
				<INPUT TYPE="hidden" NAME="FormName" VALUE="ViewLogs">
			
				<div class="table-relative table-responsive">
			
					<TABLE class="table table-striped table-fade">
						<THEAD>
							<TR>				
								<th>Select</th>						
								<th>Name</th>
								<th>DateCreated</th>
								<th>ParentFolder</th>
								<th>Size</th>
								<th>Type</th>
							</TR>
						</THEAD>
						<TBODY>
							<%Response.Write getFilelist %>
						</TBODY>
					</TABLE>

					<input type="submit" CLASS="btn btn-outline btn-default" name="logAction" value="Delete" />
					<input type="submit" CLASS="btn btn-outline btn-default" name="logAction" value="View" />
				
				</div>

			</FORM>
		
	</div>
	
	<%


End Sub

'-------------------------------------------------

Sub DisplayLog

		DIM  xslFileName
		xslFileName = getXSLFile

		DIM xmlFolderPath
		xmlFolderPath = getFolderPath("logs")

		DIM xmlFilePath
		xmlFilePath = xmlFolderPath & "\" & xmlFileName

		Set FSO = Server.CreateObject("Scripting.FileSystemObject")
				
		If Not FSO.FileExists(xmlFilePath) Then 
			response.write "Error_11:  XML file does not exist: " & xmlFilePath & "<BR><BR>"
			response.end
		End If

		Set FSO = nothing
		
		dim xmlDoc
		Set xmlDoc = Server.CreateObject("MSXML2.FreeThreadedDOMDocument.3.0")
		xmlDoc.async = false

		xmlDoc.ValidateOnParse = True
		
		xmlDoc.load xmlFilePath
		if xmlDoc.parseError.errorCode <> 0 Then
			 'error found so  stop
			  response.write "Error_12: processing  XML file: " & xmlFilePath & "<BR><BR>"
			 response.end
		end if
		
		Set xslDoc = Server.CreateObject("MSXML2.FreeThreadedDOMDocument.3.0")
		xslDoc.async = false

		xslDoc.ValidateOnParse = True
		
		'load the XSL stylesheet and check for errors
		xslDoc.loadXML xslFileName

		if xslDoc.parseError.errorCode <> 0 Then
			  'error found so  stop
			 response.write "Error_14: processing  XSL file<BR><BR>"
			 response.end
		end if
		
		'all must be OK, so perform transformation

	Set templates = Server.CreateObject("Msxml2.XSLTemplate.3.0")
	templates.stylesheet = xslDoc

	Set transformer = templates.createProcessor()

	transformer.input = xmlDoc

	transformer.transform()

	response.write transformer.output

	

End Sub

	


%>