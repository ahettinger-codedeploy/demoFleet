<% 

'CHANGE LOG
'SLM 2/26/13 - New for 2013
'SLM 2/28/13 - Updated format
'SLM 3/1/13 - Shifted Logo
'SLM 3/4/13 - Changed from ShortDate to LongDate
'SSR 8/8/13 - Updated for 2014
'SLM 2/26/14 - New King Lear for 2014
'SSR 6/09/14 - Updated for The Nance

%>

<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp"-->
<!--#INCLUDE VIRTUAL="TicketPrintInclude.asp"-->
<!--#INCLUDE VIRTUAL="NoCacheInclude.asp"-->

<%

'-----------------------------------

Server.ScriptTimeout = 600

'REE 4/15/2 - Increased Session Timeout to 30 minutes to reduce Print validation timeout issues.
Session.Timeout = 60

Page = "ManagementMenu"

'Make sure the correct Session variables are in place.  If not clear the variables and go to the menu.
If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then 
	Session.Abandon
	Response.Redirect("Default.asp")
End If

If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then 
	Session.Abandon
	Response.Redirect("Default.asp")
End If

DIM CustomerInfo

	
'Decide which subroutine to route to
Select Case Request("FormName")
	Case "PrintLetters"
		Call PrintLetters
	Case Else
		Call PrintMenu
End Select

'----------------------------------

Sub PrintMenu

%>

<!DOCTYPE html>

<html lang="en">

<head>	

	<title>Renewal Letters</title>

	<!-- Force IE to turn off past version compatibility mode and use current version mode -->
	<meta http-equiv="X-UA-Compatible" content="IE=edge;chrome=1">

	<!-- Get the width of the users display-->
	<meta name="viewport" content="width=device-width, initial-scale=1.0">

	<!-- Text encoded as UTF-8 -->
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	
	<!-- CSS Style Sheets -->
	<link href="https://fonts.googleapis.com/css?family=Roboto:400,300,500,700,900" rel="stylesheet" type="text/css" >
	<link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" >
	<link href="https://oss.maxcdn.com/icheck/1.0.2/skins/all.min.css" rel="stylesheet" type="text/css" >
	<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css" type="text/css" rel="stylesheet" >
	
<style>

/* ===============
GLOBAL SETTINGS 
=============== */

/* font styles */ 

.TixManagementContent,
.panel,
.nav
{
font-family: 'Roboto', sans-serif !important;
}


/* tix management section style */ 

.TixManagementContent
{
text-align: left !important;
min-height: 600px !important;
background-color: #fbfbfb !important;
padding: 0px !important;
}


/* =====================
RESET/CLEAR LINKS 
===================== */

/* links: remove all outlines and underscores */ 

a,     		
a:active,	
a:focus, 
a:hover,

a.btn,     		
a.btn:active,	
a.btn:focus, 
a.btn:hover,

button.btn,     		
button.btn:active,	
button.btn:focus, 
button.btn:hover,

.dropdown-menu li a,
.dropdown-menu li a:active,
.dropdown-menu li a:focus,
.dropdown-menu li a:hover,

.nav-pills li a,
.nav-pills li a:active,
.nav-pills li a:focus,
.nav-pills li a:hover,

.nav-tabs li a,
.nav-tabs li a:active,
.nav-tabs li a:focus,
.nav-tabs li a:hover

ul.nav-tabs li a,
ul.nav-tabs li a.active,
ul.nav-tabs li a.focus { outline:0px !important; -webkit-appearance:none;  text-decoration:none; color: #666666;}  


/* form input: remove blue glow */ 
.form-control,
.form-control:focus 
{
box-shadow: none;
border-width: 1px;
transition: border-color 0.15s ease-in-out 0s;
}

</style>

<style>
/* =====================
PANEL STYLES
===================== */

/* panel header: title,navbar,tabs,button */ 

div.panel div.panel-heading,
div.panel div.panel-heading div.panel-title,
div.panel div.panel-heading div.panel-title .nav-btn,
div.panel div.panel-heading div.panel-title .nav-tabs,
div.panel div.panel-heading div.panel-title .navbar,
div.panel div.panel-heading div.panel-title .navbar .navbar-header
{ padding: 0; margin: 0; border: 0; min-height: 50px !important; max-height: 50px !important;}

/* navbar-brand */ 
div.panel div.panel-heading div.panel-title .navbar .navbar-header .navbar-brand
{
min-width: 150px;
}

/* panel header */ 
div.panel div.panel-heading { border-bottom: 1px solid #dddddd; }

/* panel tabs */
div.panel div.panel-heading div.panel-title nav.navbar div.pull-left ul.nav.nav-tabs li a { min-height: 47px !important; max-height: 47px !important;  min-width: 100px; margin-top: 3px; margin-left: 3px; font-size: 14px; -webkit-transition: all 0.25s; -moz-transition: all 0.25s; transition: all 0.25s;}

/* panel button */
div.panel div.panel-heading div.panel-title .nav-btn .btn { min-height: 44px !important; max-height: 44px !important; min-width: 100px; margin-top: 3px; margin-right: 3px; font-size: 14px; border:1px solid #dddddd; -webkit-transition: all 0.25s; -moz-transition: all 0.25s; transition: all 0.25s;}
div.panel div.panel-heading div.panel-title .nav-btn .btn:focus { background-color: #ffffff;}
div.panel div.panel-heading div.panel-title .nav-btn .btn:hover { background-color: #eeeeee;}

/* panel labels */
div.panel .icon-label { margin-left: 5px; }


/* =====================
OPTIONS PANEL STYLES
===================== */

#panel-parent
{
position: relative;
min-height: 450px;
}

#panel-options-outer
{       
position: absolute;
z-index: 20;
overflow: hidden;
width: 100%;
padding: 0px .5px 20px .5px;
}

#panel-options-inner
{
background-color: white;
margin-top: -650px;
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

/* edit panel vertical tabs */ 

.nav-pills > li.active > a, 
.nav-pills > li.active > a:hover, 
.nav-pills > li.active > a:focus 
{
background-color: rgb(40, 96, 144);
font-size: 14px;
font-weight: 700;
}

.nav-pills > li > a
{
background-color: rgb(248, 248, 248);
font-size: 14px;
font-weight: 400;
}
</style>	

<style>

/* =====================
TABLE STYLES
===================== */

/* table - page load fade in effect */ 

.table-fade
{ 
opacity: 0; 
} 

/* table header cells - text color */ 
.table > thead > tr > th, 
.table > tbody > tr > th, 
.table > tfoot > tr > th
{
color: #333333;
font-size: 14px;
}

/* table body cells - text color */ 
.table > thead > tr > td, 
.table > tbody > tr > td, 
.table > tfoot > tr > td 
{
color: #666666;
font-size: 14px;
}

/* table  - borders */ 

.table > thead > tr > th 
{
border-bottom: 2px solid #ddd;
vertical-align: bottom;
}

.table > tbody > tr:last-child 
{ 
border-bottom: 2px solid #ddd;
vertical-align: bottom;
}

.table > tfoot > tr > th
{
border-bottom: 2px solid #ddd;
vertical-align: bottom;
}



/* Table Columns - center first/last columns */ 
.table > thead > tr > th:first-child
.table > tbody > tr > td:first-child,
.table > thead > tr > th:last-child,
.table > tbody > tr > td:last-child
{
text-align: center;
vertical-align: middle; 
padding: 0px;
}

/* table columns - change cursor over sortable columns */ 
.table > thead > tr > th.sorting,  
.table > thead > tr > th.sorting_desc,
.table > thead > tr > th.sorting_asc
{
cursor: pointer;
}

/* table - active row fade in */ 

.table.table-fade.dataTable.no-footer tbody tr:hover.odd td,
.table.table-fade.dataTable.no-footer tbody tr:hover.even td,

.table.table-fade.dataTable.no-footer tbody tr.active:hover.odd td,
.table.table-fade.dataTable.no-footer tbody tr.active:hover.even td,

.table tbody tr.active td, 
.table tbody tr.active th,

.table tbody tr.active:hover td,
.table tbody tr.active:hover th
{
color: #000000;
border-color: white;
background-color: rgba(51, 51, 51, 0.1) !important;
-webkit-transition: all 1s ease-in;
-moz-transition: all 1s ease-in;
-o-transition: all 1s ease-in;
-ms-transition: all 1s ease-in;
transition: all 1s ease-in;
}


/* table - active row  fade out */ 

.table.table-fade.dataTable.no-footer tbody tr.odd,
.table.table-fade.dataTable.no-footer tbody tr.even,

.table.table-fade.dataTable.no-footer tbody tr:hover.odd td,
.table.table-fade.dataTable.no-footer tbody tr:hover.even td,

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

input.btn.toggle-control.disabled, 
input.btn.toggle-control[disabled]
{
display: none;
visibility: hidden;
}

</style>

<style>

/* make keyframes that tell the start state and the end state of our object */

@-webkit-keyframes fadeIn { from { opacity:0; } to { opacity:1; } }
@-moz-keyframes fadeIn { from { opacity:0; } to { opacity:1; } }
@keyframes fadeIn { from { opacity:0; } to { opacity:1; } }

.fade-in 
{
opacity:0;  /* make things invisible upon start */
-webkit-animation:fadeIn ease-in 1;  /* call our keyframe named fadeIn, use animattion ease-in and repeat it only 1 time */
-moz-animation:fadeIn ease-in 1;
animation:fadeIn ease-in 1;

-webkit-animation-fill-mode:forwards;  /* this makes sure that after animation is done we remain at the last keyframe value (opacity: 1)*/
-moz-animation-fill-mode:forwards;
animation-fill-mode:forwards;

-webkit-animation-duration:.5s;
-moz-animation-duration:.5s;
animation-duration:.5s;
}

.fade-in.one 
{
-webkit-animation-delay: 0.15s;
-moz-animation-delay: 0.15s;
animation-delay: 0.15s;
}

.fade-in.two 
{
-webkit-animation-delay: .3s;
-moz-animation-delay:.3s;
animation-delay: .3s;
}

.fade-in.three 
{
-webkit-animation-delay: .4s;
-moz-animation-delay: .4s;
animation-delay: .4s;
}
		
</style>


</head>

	<body class="container">

		<header>
			<!-- #INCLUDE VIRTUAL="TopNavInclude.asp" -->
		</header>
		
		<section>	
		
			<DIV class="panel panel-default fade-in one" id="panel-parent">
			
				<DIV class="panel-heading fade-in two" id="panel-header">
				  
					<DIV class="panel-title">
					
						<NAV class="navbar" role="navigation">
						
							<div class="navbar-header">
								<span class="navbar-brand"><%=fnOrgName%></span>
							</div>
				 
							<DIV class="pull-left">
								<ul class="nav nav-tabs">
								
									<li class="active" >		
										<a href="RenewalLetters.asp">
											<i class="glyphicon glyphicon-print"></i>
											<span class="icon-label">Letters</span>
										</a>
									</li>

								</ul>
							</DIV>
							
							<% If CheckTixUser(Session("UserNumber")) Then %>

							<DIV class="nav-btn pull-right">
							  <BUTTON class="btn btn-large btn-default" id="btn-options" type="button" data-placement="top" title="Options">
							  <span class="glyphicon glyphicon-cog"></span>
							  <SPAN class="icon-label">Options</SPAN>
							  </BUTTON>
							</DIV>
							
							<% End If %>
							
						</NAV>
					  
					</DIV>
					
				</DIV>
			  
			
				<!-- panel edit -->
			  
		<DIV class="panel-body" id="panel-options-outer">
		
			<DIV class="container-fluid effect1" id="panel-options-inner"> 
								 
				<ul class="nav nav-pills nav-stacked col-sm-3" style="margin-top: 15px;">
					<li  class="active"><a href="#tabA" data-toggle="tab">Printing Options</a></li>
					<li><a href="#tabB" data-toggle="tab">Option B</a></li>
					<li><a href="#tabC" data-toggle="tab">Option C</a></li>
					<li><a href="#tabD" data-toggle="tab">Option D</a></li>
				</ul>

				<div class="tab-content col-sm-9">
						
					<div class="tab-pane  active" id="tabA" style="border:1px solid rgb(222, 223, 225); border-radius:4px; padding: 5px; min-height: 250px;">

						<form class="form-horizontal" role="form">
						
							<fieldset>
							
								<div class="form-group">

									<label class="col-sm-3 control-label"><h4>Print Options</h4></label>

								</div>
		 
								<div class="form-group">

									<label class="col-sm-3 control-label">Edit Mode</label>

									<div class="col-lg-6">

										<label class="switch switch-success">
											<input type="checkbox" id="toggle-switch" class="switch-input form control"> 
											<span class="switch-label" data-on="ON" data-off="OFF"></span>
											<span class="switch-handle"></span>
										</label>

									</div>

								</div>

								<div class="form-group">

									<label class="col-sm-3 control-label">Template</label>
									
									<div class="col-lg-7">
										<select class="toggle-control form-control">
											<option>Select Template</option>
											<option>JuniorTheater2015</option>
											<option>RoadCompany2015</option>
											<option>CenterPoint2015</option>
										</select>	
									</div>
			 
								</div>
								
								<div class="form-group">
								
									<label class="col-sm-3 control-label">Page Margins</label>
									
									<div class="col-lg-3">
										<input class="toggle-control  form-control" placeholder="Top Margin" type="text">
									</div>
									
									<div class="col-lg-3">
										<input class="toggle-control  form-control" placeholder="Left Margin" type="text">
									</div>
										
								</div>
								<div class="form-group">
								
									<label class="col-sm-3 control-label"></label>
									
									<div class="col-lg-3">
										<input class="toggle-control  form-control" placeholder="Bottom Margin" type="text">
									</div>
									
									<div class="col-lg-3">
										<input class="toggle-control form-control" placeholder="Right Margin" type="text">
									</div>
										
								</div>


							</fieldset>

						</form>
						
					</div>
					
					<div class="tab-pane" id="tabB" style="border:1px solid rgb(222, 223, 225); border-radius:4px; padding: 5px; min-height: 250px;">
						<h3>Option B</h3>	
					</div>
					
					<div class="tab-pane" id="tabC" style="border:1px solid rgb(222, 223, 225); border-radius:4px; padding: 5px; min-height: 250px;">
						<h3>Option C</h3>
					</div>
					
					<div class="tab-pane" id="tabD" style="border:1px solid rgb(222, 223, 225); border-radius:4px; padding: 5px; min-height: 250px;">
						<h3>Option D</h3>
					</div>
					
				</div>
					
			</div>

		</div>
			  
			  
				<!-- panel body -->
		 
				<DIV class="panel-body fade-in two" id="panel-display">

				<H3>Letters</H3>

				<%

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
				
				ErrorLog("EventList: " & EventList & "")

				If EventList <> "" Then
				
					'REE 2/25/3 - Removed TicketFormat from criteria.
					SQLTickets = "SELECT COUNT(OrderLine.ItemNumber) AS TicketCount, Act.Act, EventDate, Event.EventCode, Venue FROM Event (NOLOCK) INNER JOIN Seat ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Shipping ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN Act ON Event.ActCode = Act.ActCode INNER JOIN Venue ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber INNER JOIN OrganizationAct ON Event.ActCode = OrganizationAct.ActCode WHERE Event.EventCode IN " & EventList & " AND EventDate > GETDATE() AND OrderLine.StatusCode = 'R' AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') GROUP BY Event.EventCode, EventDate, Act.Act, Venue.Venue ORDER BY EventDate, Act.Act"
					Set rsTickets = OBJdbConnection.Execute(SQLTickets)
					
					'REE 4/6/2 - Modified to check for events.
					If Not rsTickets.EOF Then 'There are some events.  List them
					
					%>
					
					<FORM ACTION="RenewalLetters.asp" METHOD="post">
					
					<INPUT TYPE="hidden" NAME="FormName" VALUE="PrintLetters">

					<TABLE class="table table-striped fade-in three">
						<THEAD>
							<TR>
								<TH>Print</TH>
								<TH>Subscription</TH>
								<TH>Venue</TH>
								<TH>Date/Time</TH>
								<TH>Quantity</TH>
							</TR>
						</THEAD>
						<TBODY>
					<%

						'Display Event and UnPrinted Ticket Quantities
						Do Until rsTickets.EOF
						
					%>
						<TR>
							<TD><INPUT TYPE="checkbox" NAME="EventCode" VALUE="<%=rsTickets("EventCode")%>"></TD>
							<TD><%=rsTickets("Act")%></TD>
							<TD><%=rsTickets("Venue")%></TD>
							<TD><%=DateAndTimeFormat(rsTickets("EventDate"))%></TD>
							<TD><%=rsTickets("TicketCount")%></TD>
						</TR>
					<%
						rsTickets.MoveNext
						Loop
					%>
						</TBODY>	
					</TABLE>
										
					<INPUT TYPE="submit" CLASS="btn btn-outline btn-default" VALUE="Print Letters">
					
					</FORM>
					
					<% Else %>
					
						There are no events to be printed.
						
					<% End If %>

				<% Else	%>
				
					There are no events to be printed.
					
				<% End If %>

				</DIV>
				
			</DIV>
			
		</section>
			
		<footer>
		
			<!-- #INCLUDE VIRTUAL="FooterInclude.asp" -->	
			
			<SCRIPT src="https://code.jquery.com/jquery-1.9.1.js" type="text/javascript" language="javascript"></SCRIPT> 
			<SCRIPT src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.10.3/jquery-ui.min.js" type="text/javascript" language="javascript"></SCRIPT> 
			<SCRIPT src="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js" type="text/javascript" language="javascript"></SCRIPT> 
			<script src="https://cdn.jsdelivr.net/icheck/1.0.2/icheck.min.js" type="text/javascript" language="javascript" ></script>	

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
						//disable all toggle controls
						$('.toggle-control').prop('disabled', true);
						
						//disable the switch
						$('#toggle-switch').prop('checked', false);
						
						//enable submit button
						$('#toggle-submit').prop('disabled', false);
						
						//check for  switch to be toggled
						$('#toggle-switch').change(function() 
						{
							$('.toggle-control').toggleDisabled();       
						});
					});

					jQuery.fn.blindToggle = function(speed, easing, callback) 
					{
					var h = (this.height() + parseInt(this.css('paddingTop')) + parseInt(this.css('paddingBottom')) + 9);
					return this.animate({marginTop: parseInt(this.css('marginTop')) < 0 ? 0 : -h}, speed, easing, callback);  
					};
			 
					jQuery.fn.slideFadeToggle = function(speed, easing, callback) 
					{
					return this.animate({opacity: 'toggle', height: 'toggle'}, speed, easing, callback);  
					};
			 
						$(function() 
						{
						
						
							$('#btn-options').click(function() 
							{
								$('#panel-options-inner').blindToggle(1000, 'easeInOutQuart');
							});    
						});
						
						$(function() 
						{
							$('input:not(.switch-input)').iCheck(
							{
								checkboxClass: 'icheckbox_square-grey',
								radioClass: 'iradio_square-grey',
								increaseArea: '30%'
							});
							
							$('input').on('ifToggled', function(event)
							{
								$(this).closest("tr").toggleClass("active")
							});

						}); 

			</SCRIPT> 
	

		</footer>

	</body>
		
</html>

<%

END SUB 'PrintMenu

'---------------------------------

SUB PrintLetters

'Server.ScriptTimeout = 600

%>
<HTML>
<HEAD>
<TITLE>Renewal Letters</TITLE>

<link rel="stylesheet" type="text/css" href="https://fonts.googleapis.com/css?family=Roboto:400,100,300,500,700,900" >

<style>

@media screen 
{

	html 
	{ 
	overflow: auto; 
	padding: 0.2in;
	background: none repeat scroll 0% 0% rgb(153, 153, 153); 
	cursor: default; 
	}

	body 
	{ 
	box-sizing: border-box; 
	width: 8.5in; 
	height: 11in; 
	overflow: hidden; 
	padding: 0.5in;
	margin: 0px auto; 
	border-radius: 1px; 
	background: none repeat scroll 0% 0% rgb(255, 255, 255);
	box-shadow: 0px 0px 1in -0.25in rgba(0, 0, 0, 0.5); 
	outline: 3px solid green;
	}
	
	.section
	{
	outline: 1px solid #dddddd;
	color: #000000;
	}
}

@page  
{ 
	/* auto is the initial value */ 
    size: auto; 

	.section
	{
	outline: 1px solid orange;
	color: #000000;
	}	
}

html 
{ 
font-family: "Roboto",sans-serif; 
font-size: 15px; 
}

</style>

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

DIM TemplateFileName
TemplateFileName = "Template_Letter.asp"

'Build the Query to select each of the selected events
'REE 7/7/3 - Removed EventShip from Query.
SQLOrderLine = "SELECT OrderHeader.OrderTypeNumber, OrderHeader.OrderSurcharge, OrderHeader.ShipFee, OrderHeader.Total, OrderLine.OrderNumber, OrderLine.LineNumber, OrderLine.ItemNumber, OrderLine.Price, OrderLine.Surcharge, OrderLine.Discount, OrderLine.ShipCode, Event.EventCode, Event.EventDate, Event.Map, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, PostalCode, Customer.DayPhone, Customer.NightPhone, Customer.EMailAddress, Shipping.ShipType, Act.Act, Venue.Venue, SeatType.SeatType, Seat.Row, Seat.Seat, Seat.SectionCode, Section.Section FROM OrderLine INNER JOIN OrderHeader ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN Seat ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event ON Seat.EventCode = Event.EventCode INNER JOIN Section ON Seat.SectionCode = Section.SectionCode AND Event.EventCode = Section.EventCode INNER JOIN Act ON Event.ActCode = Act.ActCode INNER JOIN Venue ON Event.VenueCode = Venue.VenueCode INNER JOIN SeatType ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN Shipping ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct ON Event.ActCode = OrganizationAct.ActCode "
SQLWhere = SQLWhere & " WHERE Event.EventCode IN (" & Clean(Request("EventCode"))

'Get the Info to Print
'REE 4/6/2 - Modified to use OrganizationAct in selection criteria
'REE 8/1/5 - Added OrderNumbers for 2 orders.

SQLOrderLine = SQLOrderLine & SQLWhere & ") AND OrderLine.StatusCode = 'R' AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') ORDER BY OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.OrderNumber, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry, OrderLine.ShipCode, Seat.EventCode, Seat.SectionCode, RowSort, SeatSort DESC"
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
				'Response.Write "<TR><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=""" & MsgFontFace & """>[&nbsp;&nbsp;] ADD $1 for mailing</TD><TD ALIGN=""right""><FONT FACE=""" & MsgFontFace & """>&nbsp;&nbsp;</TD></TR>" & vbCrLf
				Response.Write "<TR><TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf
			End If
			
			Response.Write "</TABLE><BR>" & vbCrLf
			
			'-----------------------------------------
			
			'Insert HTML Template - Footer Content
			Response.Write InsertTemplate(TemplateFileName,"Footer") 
			
			'-----------------------------------------
			
			'Response.Write "<div></div>"
			
			Response.Write "</CENTER>" & vbCrLf
			
			LetterCount = LetterCount + 1

            If LetterCount Mod 100 = 0 Then
                Response.Flush
            End If

		End If
				
		SQLCustInfo = "SELECT Customer.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry, OrderLine.Price - OrderLine.Discount AS NetPrice FROM OrderHeader (NOLOCK) INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber WHERE OrderHeader.OrderNumber = " & rsOrderLine("OrderNumber") & " AND OrderLine.LineNumber = " & rsOrderLine("LineNumber") & " ORDER BY OrderLine.Price - OrderLine.Discount DESC"
		Set rsCustInfo = OBJdbConnection.Execute(SQLCustInfo)

		If Not rsCustInfo.EOF Then
					
			CustomerInfo = rsCustInfo("FirstName") & "&nbsp;" & rsCustInfo("LastName") & "<BR>"
			
			If rsCustInfo("Address2") <> "" Then
				CustomerInfo = CustomerInfo & rsCustInfo("Address1")  & "<BR>" & rsCustInfo("Address1") & "<BR>" 
			Else
				CustomerInfo = CustomerInfo & rsCustInfo("Address1")& "<BR>"
			End If
			
			CustomerInfo = CustomerInfo & rsCustInfo("City") & "&nbsp;" & rsCustInfo("State") & "&nbsp;" & rsCustInfo("PostalCode")

			Response.Write "<CENTER>"

			'-----------------------------------------
			
			'Insert HTML Template - Header Content
			
			OrderNumber = rsOrderLine("OrderNumber")
			
			Response.Write InsertTemplate(TemplateFileName,"CoverPage") 
			
			'-----------------------------------------
						
			'Insert HTML Template - Masthead Content
			Response.Write InsertTemplate(TemplateFileName,"Header") 
			
			'-----------------------------------------
			
			'Shipping and Billing Address
			
			'Response.Write "<TABLE WIDTH=""750"" cellpadding=""0"" cellspacing=""0""  border=""0"">" & vbCrLf
			Response.Write "<table border=""0"" cellpadding=""0"" cellspacing=""0"" WIDTH=""100%"">" & vbCrLf
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
			
			'Response.Write "<TABLE WIDTH=""750"" cellpadding=""0"" cellspacing=""0"" border=""0"">" & vbCrLf
			Response.Write "<table border=""0"" cellpadding=""0"" cellspacing=""0"" WIDTH=""100%"">" & vbCrLf
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
	
		'Response.Write "<TABLE WIDTH=""750"" cellpadding=""0"" cellspacing=""0""  border=""0"">" & vbCrLf
		Response.Write "<table border=""0"" cellpadding=""0"" cellspacing=""0"" WIDTH=""100%"">" & vbCrLf
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
		ColumnHeading = "<table border=""0"" cellpadding=""0"" cellspacing=""0"" WIDTH=""100%""><TR><TD><FONT FACE=""" & MsgFontFace & """><B><U>Section</U></B></TD><TD ALIGN=center><FONT FACE=""" & MsgFontFace & """><B><U>Row</U></B></TD><TD ALIGN=center><FONT FACE=""" & MsgFontFace & """><B><U>Seat</U></B></TD><TD><FONT FACE=""" & MsgFontFace & """><B><U>Type</U></B></TD><TD ALIGN=right><FONT FACE=""" & MsgFontFace & """><B><U>Price</U></B></TD>"

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
	 Response.Write InsertTemplate(TemplateFileName,"Footer") 
	
	'-----------------------------------------
	
	'Response.Write "<div></div>"
	
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

FUNCTION  PCase(str) 

strOut = "" 
boolUp = True 	
aLen =  Len(str)  

If len(aLen) > 0 Then 

	For i = 1 To Len(str) 

		c = Mid(str, i, 1)

		If c = " " or c = "'" or c = "-"  then 
			strOut = strOut & c 
			boolUp = True 
		Else 
			If boolUp Then 
				tc = Ucase(c) 
			Else 
				tc = LCase(c) 
			End If 
			strOut = strOut & tc 
			boolUp = False 
		End If 

	Next 

End If

PCase = strOut 

END FUNCTION


'-------------------------------------------------

PUBLIC FUNCTION InsertTemplate(templateFileName,templateName)


	Const ForReading = 1

	Set objFSO = CreateObject("Scripting.FileSystemObject")
	
	templatePath = Server.MapPath(templateFileName)

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
		
		strNewText = Replace(strText, 	 "[CustomerInfo]", CustomerInfo)
						
		strNewText = Replace(strNewText, "[webSite]", webSite)
		strNewText = Replace(strNewText, "[orgNumber]", orgNumber)
		strNewText = Replace(strNewText, "[senderFName]", senderFName)
		strNewText = Replace(strNewText, "[senderLName]", senderLName)
		strNewText = Replace(strNewText, "[senderAddress]", senderAddress)
		strNewText = Replace(strNewText, "[OrgName]", fnOrgName)
		strNewText = Replace(strNewText, "[RenewalURL]",RenewalURL)
		strNewText = Replace(strNewText, "[ServerName]",Request.ServerVariables("server_name"))
		
		replaceVar = strNewText
		
END FUNCTION 

'--------------------------------------------------------------------

PUBLIC FUNCTION fnOrgName

DIM strResult

SQLSearch = "Select  Organization  FROM Organization (NOLOCK) WHERE OrganizationNumber = " &  Session("OrganizationNumber") & ""
Set rsSearch = OBJdbConnection.Execute(SQLSearch)
	strResult = rsSearch("Organization") 
rsSearch.Close
Set rsSearch = Nothing

fnOrgName = strResult

END FUNCTION

'--------------------------------------------------------------------

PUBLIC FUNCTION fnCustomerName(Item,OrderNumber)

DIM strResult

SQLSearch = "Select " & Item & "  FROM Organization (NOLOCK) WHERE OrganizationNumber = " &  Session("OrganizationNumber") & ""
Set rsSearch = OBJdbConnection.Execute(SQLSearch)
	strResult = rsSearch("Organization") 
rsSearch.Close
Set rsSearch = Nothing

fnCustomerName = strResult

END FUNCTION

'--------------------------------------------------------------------



%>


