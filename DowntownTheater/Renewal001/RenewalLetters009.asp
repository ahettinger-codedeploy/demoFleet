
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

'-----------------------------------

DIM orgNumber
orgNumber = Session("OrganizationNumber")

DIM orgName
orgName = GetOrgName(orgNumber)

DIM PrivateLabel
privateLabel =  GetPrivateLabel(Session("OrganizationNumber"))

DIM CustomerID
CustomerID = ""

DIM OtherID
CustomerID = ""

'-----------------------------------

EMailOrganization = orgName
PrivateLabel =  GetPrivateLabel(orgNumber)
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

TestMode = Off

If TestMode Then
	TestEMailAddress = "Sergio.Rodriguez@tix.com"
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
		
End Select

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
		
		<link href='https://fonts.googleapis.com/css?family=Droid+Sans:400,700' rel="stylesheet" type="text/css">
		<link href="https://oss.maxcdn.com/icheck/1.0.2/skins/all.min.css" rel="stylesheet" type="text/css" >
		<link href="https://netdna.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" >
		<link href="https://netdna.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" rel="stylesheet" type="text/css" >

		
<style>

/* fonts */ 

html
{
min-height: 1500px;
{

html body.bootstrap center table tbody tr td table tbody tr td div.TixManagementContent
{
font-family: 'Droid Sans', sans-serif; 
text-align: left; 
background-color: #fbfbfb;
}
</style>
		
<style>

/* links: remove all outlines and underscores */ 

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


/* links: remove blue glow from inputs */ 

.form-control,
.form-control:focus 
{
box-shadow: none;
outline: none;
border-width: 2px;
}

</style>
				
<style>

/* panels: fix panel - tabs - button spacing */ 

.panel {margin-top: 25px;}
.panel .panel-heading { padding: 5px 5px 0 5px;}
.panel .panel-body { min-height: 450px; }
.panel .panel-footer { background-color: #ffffff; text-align: center; margin-top: -10px; }
.panel .panel-heading .nav-tabs {border-bottom: none;}
.panel .panel-heading .nav-tabs .icon-label {margin-left: 10px;}
.panel .panel-heading .btn {line-height: 2;}


/* panels: show hide panel-edit */ 

.panel-edit
{
max-height: 0; 
overflow-y: hidden;	    
top: -50px; 
border: 0px;
-webkit-transition: max-height 0.8s cubic-bezier(0.17, 0.04, 0.03, 0.94); 
-moz-transition: 	max-height 0.8s cubic-bezier(0.17, 0.04, 0.03, 0.94);
-o-transition: 		max-height 0.8s cubic-bezier(0.17, 0.04, 0.03, 0.94);
transition: 		max-height 0.8s cubic-bezier(0.17, 0.04, 0.03, 0.94);
}

.open 
{        
max-height: 300px ; 		 
} 


#panel-content
{
padding: 10px;
margin-top: 5px;
border-top:1px solid #dddddd;
border-bottom:1px solid #dddddd;
height: 200px;
background-color: #fcfcfc;
}

</style>

<style>

/* table - page load fade in effect */ 

.table-fade
{ 
opacity: 0; 
} 

</style>
	
<style>

/* buttons: outline button*/ 

.btn-default.btn-outline:active,
.btn-default.btn-outline:focus, 
.btn-default.btn-outline 		{ color: #676767; border-color: #676767; background-color: transparent; border-width: 2px; -webkit-transition: all 0.25s; -moz-transition: all 0.25s; transition: all 0.25s;} 	
.btn-default.btn-outline:hover 	{ color: #000000; border-color: #000000; background-color: transparent; border-width: 2px; -webkit-transition: all 0.75s; -moz-transition: all 0.75s; transition: all 0.75s; } 

</style>
		
 
	</head>

	<body class="bootstrap">
		
			<!--#INCLUDE VIRTUAL="TopNavInclude.asp" -->
									
					<div class="panel panel-default">
	
						<div class="panel-heading">
					   
							<span class="panel-title">
							
								<div class="pull-left">
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

								<div class="pull-right">
									<button type="button" class="btn btn-nav btn-default dropdown-toggle" onclick="document.getElementById('panel-edit').classList.toggle('open');">
										<span class="glyphicon glyphicon-cog"></span>
										<span class="nav-label">&nbsp;Preferences</span>
									</button>
								</div>
								
								<div class="clearfix"></div>

							</span>

						</div>	

						<div class="panel-edit" id="panel-edit">
						
							<div id="panel-content">
					
								<form class="form-horizontal" >
						 
									<div class="col-sm-4">

										<div class="form-group">
											<label for="name1" class="col-sm-5 control-label">Test Mode!</label>
											<div class="col-sm-7">
												<input type="text" name="name1" class="form-control" placeholder="control1" />
											</div>
										</div>
										
										<div class="form-group">
											<label for="name1" class="col-sm-5 control-label">Email Address</label>
											<div class="col-sm-7">
												<input type="text" name="name1" class="form-control" placeholder="control2" />
											</div>
										</div>

									</div>
									
									<div class="col-sm-4">
									
										<div class="form-group">
											<label for="name" class="col-xs-4 control-label">Subject</label>
											<div class="col-xs-8">
												<input type="text" class="form-control" placeholder="control3" />
											</div>
										</div>
										
										<div class="form-group">
											<label for="name" class="col-xs-4 control-label">Reply To</label>
											<div class="col-xs-8">
												<input type="text" class="form-control" placeholder="control4" />
											</div>
										</div>
										
									</div>
									
									<div class="col-sm-4">
									
										<div class="form-group">
											<label for="name" class="col-xs-4 control-label">Min Count</label>
											<div class="col-xs-8">
												<input type="text" class="form-control" placeholder="control5" />
											</div>
										</div>
										
										<div class="form-group">
											<label for="name" class="col-xs-4 control-label">Label6</label>
											<div class="col-xs-8">
												<input type="text" class="form-control" placeholder="control6" />
											</div>
										</div>
										
									</div>
						 
								
									Select events and click below<BR>
									<BR>
									<INPUT TYPE="submit" CLASS="btn btn-outline btn-default" id="toggle" VALUE="Submit">
									
								</form>
			 
							</div>
							
						</div>

						<div class="panel-body">
						
								<h3 class="display-title"><%=strTitle%></h3><BR>
								
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
	
			<footer>
			
				<!--#INCLUDE VIRTUAL="FooterInclude.asp" -->
				<script src="https://code.jquery.com/jquery-1.9.1.js" type="text/javascript" ></script>
				<script src="https://netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>
				
				<script type="text/javascript" language="javascript" src="https://cdn.datatables.net/1.10.2/js/jquery.dataTables.min.js"></script>
				<script type="text/javascript" language="javascript" src="https://cdn.datatables.net/1.10.2/js/dataTables.tableTools.js"></script>
				<script type="text/javascript" language="javascript" src="https://cdn.datatables.net/plug-ins/a5734b29083/integration/bootstrap/3/dataTables.bootstrap.js"></script>
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
					 
						$('.table-data').dataTable(
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
						
						$('.table-log').dataTable( 
						 {
							"ajax"			: "logs/<%=xmlFileName%>"
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
							checkboxClass: 'icheckbox_square-grey',
							radioClass: 'iradio_square-grey',
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
			SQLTickets = "SELECT COUNT(OrderLine.ItemNumber) AS TicketCount, COUNT(OrderHeader.OrderNumber) AS OrderCount, Act.Act, EventDate, Event.EventCode, Venue FROM Event (NOLOCK) INNER JOIN Seat ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN OrderHeader ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Shipping ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN Act ON Event.ActCode = Act.ActCode INNER JOIN Venue ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber INNER JOIN OrganizationAct ON Event.ActCode = OrganizationAct.ActCode WHERE Event.EventCode IN " & EventList & " AND EventDate > GETDATE() AND OrderLine.StatusCode = 'R' AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') GROUP BY Event.EventCode, EventDate, Act.Act, Venue.Venue ORDER BY EventDate, Act.Act"
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
			<FORM ACTION="" METHOD="post">
			
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
				<INPUT TYPE="submit" CLASS="btn btn-outline btn-danger" VALUE="TEST">
			
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
					
					logResults = logResults & " [ """ & OrderCount & """, """ & LastOrderNumber & """, """ & FName & """, """ & LName & """, """ & LastEMailAddress & """, """ & CustomerNumber & "-" & OrderItemNumber & """, """ & Now() & """ ], "
				
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

				logResults = logResults & " [ """ & OrderCount  & """, """ & LastOrderNumber & """, """ & FName & """, """ & LName & """, """ & LastEMailAddress & """, """ & CustomerNumber & "-" & OrderItemNumber & """, """ & Now() & """ ] "
			
			End If
			
			EMailMessage = ""

		End If

		'Response.Write "Order Count: " & OrderCount & "<BR>"
	
	rsOrderLine.Close
	Set rsOrderLine = nothing

	
End Sub 'Send Emails

'-------------------------------------------------

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

'==================================================================================
'LogFileinclude.asp
'==================================================================================

Sub SaveEmailLog

	'start email log
	strText = "{ ""data"": [" & logResults & "] }"	

	DIM tab
	tab = chr(9)

	DIM objFSO
	set objFSO  = Server.CreateObject( "Scripting.FileSystemObject" )

	xmlFileName = createFileName

	If xmlFileName = "" Then
		  response.write "Error 10: :  file name missing<BR>"
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

	objWrite.WriteLine logresults
	objWrite.Close()
	
	strMode = "loglist"
	LgTab = "active"
	EmTab = ""
	strTitle = "Log Listing"

End Sub

'-------------------------------------------------
 
Sub DisplayLogList

	Dim strFolderName
	strFolderName = "logs"

	Dim strFileExt
	strFileExt ="txt"

	Dim FileDict
	Set FileDict = GetFileList(strFolderName,strFileExt)

	%>
 
	<FORM ACTION="" METHOD="post">
		<INPUT TYPE="hidden" NAME="FormName" VALUE="DisplayLogList">
		<TABLE class="table table-data table-striped table-fade">
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

End Sub

'-------------------------------------------------

Sub DisplayLog
 
	%>
 
		<TABLE  class="table table-log table-striped table-fade">
			<thead>
				<tr>
					<th>Index</th>
					<th>Order Number</th>
					<th>First Name</th>
					<th>Last Name</th>
					<th>Email Address</th>
					<th>Renewal Code</th>
					<th>Date/Time</th>
				</tr>
			</thead>
			<tfoot>
				<tr>
					<th>Index</th>
					<th>Order Number</th>
					<th>First Name</th>
					<th>Last Name</th>
					<th>Email Address</th>
					<th>Renewal Code</th>
					<th>Date/Time</th>
				</tr>
			</tfoot>
		</table>
 
	<%

End Sub


'==================================================================================
'RenewalLetters_Include.asp
'==================================================================================
	
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

'---------------------------------------

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
	


%>