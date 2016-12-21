
<% 

'CHANGE LOG
'JAI 04/29/14 - 2015 Renewal Emails
'SSR 06/18/14 - 2015 Renewal Reminder Emails
'SSR 07/17/14 - Updated for use with Road Company
'SSR 07/18/14 - Updated EmailReplayTo 

%>

<!--METADATA TYPE="typelib" UUID="CD000000-8B95-11D1-82DB-00C04FB1625D"  NAME="CDO for Windows 2000 Library" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp"-->
<!--#INCLUDE VIRTUAL="TicketPrintInclude.asp"-->
<!--#INCLUDE VIRTUAL="NoCacheInclude.asp"-->

<%

EMailOrganization = GetOrgName(Session("OrganizationNumber"))
PrivateLabel =  GetPrivateLabel(Session("OrganizationNumber"))
EMailRenewalURL = "http://" & PrivateLabel & ".tix.com/renew.aspx"
MsgLogoPath = "http://www.tix.com/images/clear.gif"
MsgFontFace = "'Times New Roman', Times, serif"
EMailReplyTo = "sergio@tix.com"
EMailSubject = "Season Renewal" 

'-----------------------------------

'Organization Variables

MsgOrgName = GetOrgName(Session("OrganizationNumber"))
PrivateLabel =  GetPrivateLabel(Session("OrganizationNumber"))
MsgRenewalURL = "http://" & PrivateLabel & ".tix.com/renew.aspx"
MsgLogoPath = "http://www.tix.com/images/clear.gif"
MsgFontFace = "'Times New Roman', Times, serif"

'-----------------------------------

'Testing Variables

TestEMailAddress = "sergio@tix.com"

If TestEMailAddress <> "" Then
    EMailSubject =  "[Test Email for your review] " & EMailSubject
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
Session("OrgName") = GetOrgName(Session("OrganizationNumber"))


'Verify User
If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then 
    OBJdbConnection.Close
    Set OBJdbConnection = nothing
    Response.Redirect("/Management/Default.asp")
Else
	TixUser = checkTixUser(Session("UserNumber"))
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
DIM MsgOrgName
DIM emResults
DIM xmlFileName
DIM logAction

'-----------------------------------------------

'Program Workflow

Select Case Request("FormName")

	Case "PrintLetters"
		Call PrintLetters	
		
	Case "SendEmails"
		Call SendEmails	
		Call SaveLog
		
End Select

Call checkStatus

Call PrintMenu

'-----------------------------------------------

Sub PrintMenu

%>

<!DOCTYPE html>

	<html lang="en">

		<title>Support Dashboard</title>
		
		<!-- Force IE to turn off past version compatibility mode and use current version mode -->
		<meta http-equiv="X-UA-Compatible" content="IE=edge;chrome=1">
		
		<!-- Get the width of the users display-->
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		
		<!-- Text encoded as UTF-8 -->
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		
		<link rel="stylesheet" type="text/css" href="https://oss.maxcdn.com/icheck/1.0.2/skins/all.min.css" >
		<link rel="stylesheet" type="text/css" href="https://netdna.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css" >


		<!-- bootstrap -->
		<link rel="stylesheet" type="text/css" href="https://netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap.min.css">


		<style>

		.container
		{
		background-color: #fcfcfc;
		border-left: 1px solid #e0e0e0;
		border-right: 1px solid #e0e0e0;
		border-top: 1px solid red;
		border-bottom: 1px solid #fcfcfc;
		left: -250px;
		width: 990px;
		margin-left: -15px;
		margin-right: -15px;
		margin-top: -15px;
		margin-bottom: -12px;
		}

		</style>
			
			
		<style>

		/* links: outlines and underscores */  
		a.btn,     		
		a.btn:active,	
		a.btn:focus, 

		button.btn:active, 
		button.btn:focus,   
		button.btn:active, 
		button.btn:focus, 

		.dropdown-menu li a,
		.dropdown-menu li a:active,
		.dropdown-menu li a:focus,
		.dropdown-menu li a:hover,

		ul.dropdown-menu li a,
		ul.dropdown-menu li a:active,
		ul.dropdown-menu li a:focus,
		ul.dropdown-menu li a:hover,

		.nav-tabs li a,
		.nav-tabs li a:active,
		.nav-tabs li a:focus { outline:0px !important; -webkit-appearance:none;  text-decoration:none; color: #666666;}  

		</style>
				
		<style>

		/* panels */ 

		.panel {margin-top: 25px;}
		.panel .panel-heading { padding: 5px 5px 0 5px;}
		.panel .nav-tabs {border-bottom: none;}
		.panel .panel-body { min-height: 450px; }
		.panel .panel-footer { background-color: #ffffff; text-align: center; margin-top: -10px; }

		</style>
				
		<style>

		/* table - fade in effect */ 
		.table-fade
		{ 
		opacity: 1; 
		} 

		/* table font color*/ 
		.table > thead > tr > th, 
		.table > tbody > tr > th, 
		.table > tfoot > tr > th,
		.table > thead > tr > td, 
		.table > tbody > tr > td, 
		.table > tfoot > tr > td 
		{
		color: #333333;
		}

		
		/* table head - non-sort 1st column */ 
		.table > tbody > tr > td:first-child,
		.table > thead > tr > th:first-child
		{
		text-align: center;
		vertical-align: middle; 
		padding: 0px;
		cursor: default;
		}
		
		/* table head - sort columns */ 
		.table > thead > tr > th.sorting,  
		.table > thead > tr > th.sorting_desc,
		.table > thead > tr > th.sorting_asc
		{
		color: #333333;
		cursor: pointer;
		}
		
		/* table footer border color */ 
		.table > tfoot > tr > th
		{
		border-top: 2px solid #dddddd;
		}

		/* table row zebra-stripes */ 
		.table-striped > tbody > tr:nth-child(2n+1) > td, .table-striped > tbody > tr:nth-child(2n+1) > th 
		{
		background-color: rgba(224, 224, 224, .2);
		}

		/* table first column */ 
		.table > tbody > tr > td:first-child,
		.table > thead > tr > th:first-child
		{
		text-align: center;
		vertical-align: middle; 
		padding: 0px;
		cursor: default;
		}

		/* table - active row fade in */ 
		table#example.table.table-fade.dataTable.no-footer tbody tr:hover.odd td,
		table#example.table.table-fade.dataTable.no-footer tbody tr:hover.even td,

		table#example.table.table-fade.dataTable.no-footer tbody tr.active:hover.odd td,
		table#example.table.table-fade.dataTable.no-footer tbody tr.active:hover.even td,

		.table tbody tr.active td, 
		.table tbody tr.active th,

		.table tbody tr.active:hover td,
		.table tbody tr.active:hover th
		{
		color: black;
		border-color: white;
		background-color: rgba(27, 126, 90, .2) !important;
		-webkit-transition: all 1s ease-in;
		-moz-transition: all 1s ease-in;
		-o-transition: all 1s ease-in;
		-ms-transition: all 1s ease-in;
		transition: all 1s ease-in;
		}

		/* table - inactive row fade out effect */ 
		.table.table-fade.dataTable.no-footer tbody tr.odd,
		.table.table-fade.dataTable.no-footer tbody tr.even,
		 
		table#example.table.table-fade.dataTable.no-footer tbody tr:hover.odd td,
		table#example.table.table-fade.dataTable.no-footer tbody tr:hover.even td,

		.table tbody tr td, 
		.table tbody tr th,

		.table tbody tr:hover td,
		.table tbody tr:hover th
		{
		border-color: #e0e0e0;
		-webkit-transition: all 1s ease-out;
		-moz-transition: all 1s ease-out;
		-o-transition: all 1s ease-out;
		-ms-transition: all 1s ease-out;
		transition: all 1s ease-out;
		}
		 
		</style>
 	
		<style>

		/* buttons */ 

		.btn-default.btn-outline:active,
		.btn-default.btn-outline:focus, 
		.btn-default.btn-outline 		{ color: #676767; border-color: #676767; background-color: transparent; border-width: 2px; -webkit-transition: all 0.25s; -moz-transition: all 0.25s; transition: all 0.25s;} 	
		.btn-default.btn-outline:hover 	{ color: #000000; border-color: #000000; background-color: transparent; border-width: 2px; -webkit-transition: all 0.75s; -moz-transition: all 0.75s; transition: all 0.75s; } 

		.btn-outline.btn-highlight	{ color: #676767; border-color: #676767; background-color: transparent; border-width: 2px;}

		</style>

		<style>

		.display-header
		{
		color: inherit;
		font-family: inherit;
		font-weight: 500;
		line-height: 1.1;
		text-align: center;
		}

		.display-org
		{
		font-size: 22px;
		}

		.display-title
		{
		font-size: 18px;
		}

		</style>
		
 
	</head>

		<body class="bootstrap">
		
			<!--#INCLUDE VIRTUAL="TopNavInclude.asp" -->
			
			<section class="container">
		
				<div class="col-md-12"> 
				
					<div class="panel panel-default">
					
						<div class="panel-heading">
				
							<ul class="nav nav-tabs">

								<li class="<%=ltTab%>">	
									<a href="?mode=letters">
										<i class="glyphicon glyphicon-print"></i>											
										Letters
									</a>
								</li>
								
								<% 
								If TIXUser Then
								%>
								<li class="<%=emTab%>">		
									<a href="?mode=emails">
										<i class="glyphicon glyphicon-send"></i>
										Emails
									</a>
								</li>
								<li class="<%=lgTab%>">		
									<a href="?mode=loglist">
										<i class="glyphicon glyphicon-list"></i>
										Logs
									</a>
								</li>
								<% 
								End If 
								%>
								
							</ul>
							
						</div>

						<div class="panel-body">

								<span class="display-org"><%=MsgOrgName%></span><BR>
								<span class="display-title"><%=strTitle%></span><BR>
								
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
						

						</div>
						
					</div>
						
				</div>
				
			</section>
			
			<footer>
			
				<!--#INCLUDE VIRTUAL="FooterInclude.asp" -->
				<script type="text/javascript" language="javascript" src="https://code.jquery.com/jquery-1.11.1.min.js"></script>
				<script type="text/javascript" language="javascript" src="https://netdna.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>
				<script type="text/javascript" language="javascript" src="https://cdn.datatables.net/1.10.2/js/jquery.dataTables.min.js"></script>
				<script type="text/javascript" language="javascript" src="https://cdn.jsdelivr.net/icheck/1.0.2/icheck.min.js"></script>	
				
				<script type="text/javascript" language="javascript">
				
				$(document).ready(function() 
				{
				
					function datatable() 
					{
				 
						$.extend( $.fn.dataTable.defaults, 
						{
							"paging"		: false,
							"info"			: false,
							"searching"		: false,
							"ordering"		: true
						});
					 
						$('.table').dataTable(
						{
							"columnDefs": 
							[
								{ 
									"orderable": false, 
									"targets": 0 
								}
							],
							
							"order": [ 1, 'asc' ]
						});
						
						$(".table > thead > tr > th.sorting").mousedown(function(e) 
						{
							e.preventDefault();
						});
						
					}
					
					datatable(); 

					
					function icheck() 
					{
						$('input').iCheck(
						{
							checkboxClass: 'icheckbox_square-green',
							radioClass: 'iradio_square-green',
							increaseArea: '30%'
						});
						
						$('input').on('ifToggled', function(event)
						{
							$(this).closest("tr").toggleClass("active")
						});
				 
					}
					
					icheck(); 


					function tableFade() 
					{				
						$(".table-fade")
						.delay(25)
						.animate({"opacity": "1"}, 1000);
					}
					
					tableFade();
					
					//tooltip
					$(function() 
					{
						var tooltips = $( "[aria-label]" ).tooltip();
						$(document)(function() 
						{
						tooltips.tooltip( "open" );
						});
					});

				});	

				</script>
				
			</footer>

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
				
				<TABLE class="table table-striped table-fade">
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
			<FORM ACTION="" METHOD="post">
			
				<INPUT TYPE="hidden" NAME="FormName" VALUE="SendEmails">
				
				<TABLE class="table table-striped table-fade">
					<THEAD>
						<TR><TH>Select</TH><TH>Subscription</TH><TH>Venue</TH><TH>Date/Time</TH><TH>Quantity</TH></TR>
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
				<INPUT TYPE="submit" CLASS="btn btn-outline btn-default" VALUE="Submit">
			
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
					EMailMessage = EMailMessage & InsertTemplate("LetterInclude.asp","Footer") 
					
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

					OrderCount = OrderCount + 1
					
					logResults = logResults & "<id>" & OrderCount & "</id><ordernumber>" & LastOrderNumber & "</ordernumber><firstname>" & FName & "</firstname><lastname>" & LName & "</lastname><emailaddress>" & LastEmailAddress & "</emailaddress><renewalnumber>" & RenewalCode & "</renewalnumber><datesent>" & Now() & "</datesent>,"
				
					If TestEMailAddress <> "" And OrderCount >= TestEmailCount Then
						Exit Do
					End If

				End If

				SQLCustInfo = "SELECT Customer.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry FROM OrderHeader (NOLOCK) INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber WHERE OrderHeader.OrderNumber = " & rsOrderLine("OrderNumber") & " AND OrderLine.LineNumber = " & rsOrderLine("LineNumber")
				Set rsCustInfo = OBJdbConnection.Execute(SQLCustInfo)

				If Not rsCustInfo.EOF Then
				
					'-----------------------------------------
					
					'Insert HTML Template - Header Content
					EMailMessage = EMailMessage & InsertTemplate("LetterInclude.asp","Header") 
					
					'-----------------------------------------
								
					'Insert HTML Template - Masthead Content
					EMailMessage = EMailMessage & InsertTemplate("LetterInclude.asp","Masthead") 
					
					'-----------------------------------------
								
					'Shipping and Billing Address
					
					EMailMessage = EMailMessage & "<TABLE WIDTH=""750"" cellpadding=""0"" cellspacing=""0""  border=""0"">" & vbCrLf
					EMailMessage = EMailMessage & "<TR>" & vbCrLf
					EMailMessage = EMailMessage & "<TD WIDTH=""400""><FONT FACE=""" & MsgFontFace & """><B>Shipping Information</B></TD>" & vbCrLf
					EMailMessage = EMailMessage & "<TD WIDTH=""330""><FONT FACE=""" & MsgFontFace & """><B>Billing Information</B></TD>" & vbCrLf
					EMailMessage = EMailMessage & "</TR>" & vbCrLf
					EMailMessage = EMailMessage & "<TR>" & vbCrLf
					EMailMessage = EMailMessage & "<TD>" & vbCrLf
					
					FName = rsCustInfo("ShipFirstName")
					LName = rsCustInfo("ShipLastName") 
					
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
					 EMailMessage = EMailMessage & InsertTemplate("LetterInclude.asp","Footer") 
					
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

				OrderCount = OrderCount + 1
				
				logResults = logResults & "<id>" & OrderCount & "</id><ordernumber>" & LastOrderNumber & "</ordernumber><firstname>" & FName & "</firstname><lastname>" & LName & "</last name><emailaddress>" & LastEmailAddress & "</emailaddress><renewalnumber>" & RenewalCode & "</renewalnumber><datesent>" & Now() & "</datesent>,"
				
			End If
			
			EMailMessage = ""

		End If

		'Response.Write "Order Count: " & OrderCount & "<BR>"

	rsOrderLine.Close
	Set rsOrderLine = nothing

	
End Sub 'Send Emails
	
'-------------------------------------------------

PUBLIC FUNCTION GetOrgName(OrgNumber)

SQLThisOrg = "Select  Organization  FROM Organization (NOLOCK) WHERE OrganizationNumber = " &  Session("OrganizationNumber") & ""
Set rsThisOrg = OBJdbConnection.Execute(SQLThisOrg)
	OrgName = rsThisOrg("Organization") 
rsThisOrg.Close
Set rsThisOrg = Nothing

GetOrgName = OrgName

END FUNCTION

'-------------------------------------------------

PUBLIC FUNCTION GetPrivateLabel(OrgNumbr)

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

'-------------------------------------------------

PUBLIC FUNCTION checkTixUser(UserNbr)

	Dim strResult
	strResult = FALSE

		SQLOrgUsers = "Select UserNumber FROM Users (NOLOCK) WHERE OrganizationNumber = 1 AND UserNumber = " & UserNbr & ""
		Set rsOrgUsers = OBJdbConnection.Execute(SQLOrgUsers)

			If NOT rsOrgUsers.EOF Then
				strResult = TRUE
			End If
			
		rsOrgUsers.Close
		Set rsOrgUsers = Nothing

		checkTixUser = strResult

END FUNCTION

'-------------------------------------------------

Sub checkStatus
 
	If Request.Form("logAction") <> "" Then
		logAction = Request.Form("logAction")
		xmlFileName = Request.Form("fileName")
	End If
		

	Select Case logAction
	
		Case "Delete"
			Call DeleteFile(xmlFileName)
			strMode = "loglist"
		
		Case "View"
			strMode = "logs"
		
	End Select


 
	If strMode = "" Then
		If Request.QueryString("mode") <> "" Then
			strMode = request.queryString("mode")
		Else
			strMode = "letters"
		End If
	End If
	
	EmTab = ""
	LgTab = ""
	LtTab = ""
	
	If fileCount("logs","xml") = 0 Then
		LgTab = "disabled"		
	End If

	Select Case strMode		
		Case "emails"
			EmTab = "active"
			strTitle = "Send Emails"			
		Case "letters"
			LtTab = "active"
			strTitle = "Print Letters"	
		Case "loglist"
			If LgTab <> "disabled" Then
				LgTab = "active"
				strTitle = "Log Listing"
			End If
		Case "logs"
			strTitle = "Email Report"
			LgTab = "active"
		Case Else
			LtTab = "active"
	End Select
	
End Sub

'==================================================================================
'LogFileinclude.asp
'==================================================================================

Sub SaveLog

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
		logArray = Split(emResults,",") 

		For i = LBound(logArray) to UBound(logArray)
			objWrite.WriteLine(tab & "<email>" & logArray(i) & "</email>")
		Next

	objWrite.WriteLine("</emaillist>")
	objWrite.Close()
	
	strMode = "logs"

End Sub

'-------------------------------------------------

Sub DisplayLogList

	Dim strFolderName
	strFolderName = "logs"

	Dim strFileExt
	strFileExt ="xml"

	Dim FileDict
	Set FileDict = GetFileList(strFolderName,strFileExt)

	%>
 
	<FORM ACTION="" METHOD="post">
	
		<INPUT TYPE="hidden" NAME="FormName" VALUE="DisplayLogList">
		
		<TABLE class="table table-striped table-fade">
			<THEAD>
				<TR><TH>Select</TH><TH>File Name</TH><TH>File Type</TH><TH>File Size</TH><TH>File Date</TH></TR>
			</THEAD>
			<TBODY>
				<%
					If  FileDict.Count <> 0 then

						For Each Filename in FileDict
							%>
							<tr>
								<td><input type="radio" name="filename" value ="<%= Filename %>"</td>
								<td><%= Filename %></td>
								<td><%= FileDict(Filename)(0) %></td>
								<td><%= FileDict(Filename)(1) %></td>
								<td><%= FileDict(Filename)(2) %></td>
							</tr>
							<%
						Next
						
					End If
				%>
			</TBODY>
		</TABLE>

		Select files and click below<BR>
		
		<BR>
		
		<input type="submit" CLASS="btn btn-outline btn-default" name="logAction" value="Delete" />
		<input type="submit" CLASS="btn btn-outline btn-default" name="logAction" value="View" />

	</FORM>

	<%

End Sub 'DisplayLogList

'-------------------------------------------------

Sub DisplayLog
	
	response.write xmlTransform(xmlFileName)

End Sub 'DisplayLog

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
		
	strFileName = "" & dtYear & "-"& dtMonth & "-" & dtDay & "-" & dtHour & dtMin & ".xml"

	createFileName = strFileName

END FUNCTION 'createFileName
 
'-------------------------------------------------

Function getFileList(strFolderName,strFileExt)
 
    dim fileDict
    set fileDict = Server.CreateObject("SCRIPTING.DICTIONARY")

	dim objFSO
    set objFSO = Server.CreateObject("SCRIPTING.FILESYSTEMOBJECT")
 
	strFolderPath = getFolderPath(strFolderName)
 
    dim objFolder
    set objFolder = objFSO.GetFolder(strFolderPath)

    dim objFile
	
    For Each objFile in objFolder.Files

		If objFSO.GetExtensionName(objFile.Path)= strFileExt Then
			fileDict.add objFile.Name, Array(objFile.Type, objFile.Size, objFile.DateCreated )	
		End If

	Next
	
    set objFile = nothing
    set objFolder = nothing
    set FSo = nothing
    set Regex = nothing

    set getFileList = fileDict

End Function 'getFileList

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

Function xmlTransform(xmlFileName)

		DIM xmlFilePath
		xmlFilePath = getFolderPath("logs") & xmlFileName

		dim objFSO
		set objFSO = Server.CreateObject("SCRIPTING.FILESYSTEMOBJECT")
				
		If Not objFSO.FileExists(xmlFilePath) Then 
			response.write "Error_11:  XML file does not exist: " & xmlFilePath & "<BR><BR>"
			response.end
		End If

		Set objFSO = nothing
		
		'load xml
		dim xmlDoc
		Set xmlDoc = Server.CreateObject("MSXML2.FreeThreadedDOMDocument.3.0")
		xmlDoc.async = false

		xmlDoc.ValidateOnParse = True
		
		xmlDoc.load xmlFilePath
		
		if xmlDoc.parseError.errorCode <> 0 Then
			  response.write "Error_12: processing  XML file: " & xmlFilePath & "<BR><BR>"
			 response.end
		end if
		
		'load xsl
		xslFileName = getXSLFile
		
		dim xslDoc
		Set xslDoc = Server.CreateObject("MSXML2.FreeThreadedDOMDocument.3.0")
		xslDoc.async = false

		xslDoc.ValidateOnParse = True
		
		xslDoc.xmlload xslFileName

		if xslDoc.parseError.errorCode <> 0 Then
			 response.write "Error_14: processing  XSL file<BR><BR>"
			 response.end
		end if

	Set templates = Server.CreateObject("Msxml2.XSLTemplate.3.0")
	templates.stylesheet = xslDoc

	Set transformer = templates.createProcessor()

	transformer.input = xmlDoc

	transformer.transform()

	xmlTransform = transformer.output

	
End Function

'-------------------------------------------------

PUBLIC FUNCTION getXSLFile
	
		DIM strText
		
		 strText = strText & "<?xml version=""1.0""?>" 
		 strText = strText & "<xsl:stylesheet version=""1.0"" xmlns:xsl=""http://www.w3.org/1999/XSL/Transform"">" 
		 strText = strText & "<xsl:template match=""/*"">" 
		 strText = strText & "<table id=""example"" class=""table table-striped"">" 
		 strText = strText & "<thead>" 
		 strText = strText & "<tr>" 
		 strText = strText & "<xsl:for-each select=""*[position() = 1]/*"">" 
		 strText = strText & "<th><xsl:value-of select=""local-name()""/></th>" 
		 strText = strText & "</xsl:for-each>" 
		 strText = strText & "</tr>" 
		 strText = strText & "</thead>" 
		 strText = strText & "<tbody>" 
		 strText = strText & "<xsl:apply-templates/>" 
		 strText = strText & "</tbody>" 
		 strText = strText & "</table>" 
		 strText = strText & "</xsl:template>" 
		 strText = strText & "<xsl:template match=""/*/*"">" 
		 strText = strText & "<tr><xsl:apply-templates/></tr>" 
		 strText = strText & "</xsl:template>" 
		 strText = strText & "<xsl:template match=""/*/*/*"">" 
		 strText = strText & "<td><xsl:value-of select="".""/></td>" 
		 strText = strText & "</xsl:template>" 
		 strText = strText & "</xsl:stylesheet>" 
		 
		 getXSLFile = strText
	

END FUNCTION
 
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

		strNewText = Replace(strText, 	 "[recipientFName]", recipientFName)
		strNewText = Replace(strNewText, "[webSite]", webSite)
		strNewText = Replace(strNewText, "[orgNumber]", orgNumber)
		strNewText = Replace(strNewText, "[senderFName]", senderFName)
		strNewText = Replace(strNewText, "[senderLName]", senderLName)
		strNewText = Replace(strNewText, "[senderAddress]", senderAddress)
		strNewText = Replace(strNewText, "[OrgName]", GetOrgName(Session("OrganizationNumber")))
		strNewText = Replace(strNewText, "[MsgRenewalURL]",MsgRenewalURL)
		strNewText = Replace(strNewText, "[ServerName]",Request.ServerVariables("server_name"))
		
		replaceVar = strNewText
		
END FUNCTION 
	


%>