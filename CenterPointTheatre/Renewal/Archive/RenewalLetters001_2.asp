<%
'CHANGE LOG

'SSR 06/26/16 - Updated Event Selection Qty for Tulip Festival

%>

<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#include virtual="/include/managementinclude.asp"-->

<%

'-------------------------------------------------

Page = "Management"

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

SQLUsers = "SELECT UserType FROM Users (NOLOCK) WHERE UserNumber = " & Session("UserNumber")
Set rsUsers = OBJdbConnection.Execute(SQLUsers)
	If Not IsNull(rsUsers("UserType")) Then
		UserType = rsUsers("UserType")
	Else
		UserType = ""
	End If
rsUsers.Close
Set rsUsers = nothing	

'-------------------------------------------------

'Variables

DIM ScriptName
DIM MaxSeats

DIM strGroupUser

DIM EventStart
DIM EventEnd


DIM strPageTitle

DIM tabName(4)
DIM tabStatus(4)
DIM tabPage(4)
DIM tabIcon(4)

DIM SQLWhereEvents

DIM NavMenu

'-------------------------------------------------

ScriptName = fnScriptName()
MaxSeats = 500

EventStart = FormatDateTime(Now(), vbShortDate)
EventEnd = Now() - .25

NumColumns = 0
LastTotal = 0

'-------------------------------------------------

'Form Data

DIM TemplateIndex

If Request("TemplateIndex") <> "" Then
      TemplateIndex = Request.Form("TemplateIndex")       
      Call SetDefaultTemplate(TemplateIndex)
Else
      TemplateIndex = fnTemplateDetail("Index")
End If

'-------------------------------------------------

'Navigation Menu

'Letters Tab

            tabPage(1) = "Letters"
            tabName(1) = "Print Letters"
            tabIcon(1) = "fa fa-print"

'Emails Tab

	If SecurityCheck("SubscriptionRenewalEmails") = True Then 
		tabPage(2) = "Emails"
		tabName(2) = "Send Emails"
            tabIcon(2) = "fa fa-envelope-o"
	End If

'Reminders Tab

	If SecurityCheck("SubscriptionRenewalReminders") = True Then 
		tabPage(3) = "Reminders"
		tabName(3) = "Send Reminder"
            tabIcon(3) = "fa fa-paper-plane"
	End If

'Admin Tab

	If SecurityCheck("SubscriptionRenewalLetters") = True Then 
		tabPage(4) = "Options"
		tabName(4) = ""
            tabIcon(4) = "fa fa-cog "
	End If

'-------------------------------------------------

'Determine the requested page view
'Verify permission to display page

If Request.QueryString("PageView") <> "" Then
      PageView = Request.QueryString("PageView")
Else
      PageView = "Letters"
End If



If PageView = tabPage(1) Then
      'Letters
	If SecurityCheck("SubscriptionRenewalLetters") = True Then 

		strPageTitle	=  tabName(1)
		tabStatus(1) 	= "active"
            SQLWhereEvents 	= " AND OrderLine.StatusCode = 'R'"
            
	End If
	
ElseIf PageView = tabPage(2) Then
      'Emails
	If SecurityCheck("SubscriptionRenewalEmails") = True Then 

		strPageTitle	=  tabName(2)
		tabStatus(2) 	= "active"
		SQLWhereEvents 	= " AND OrderLine.StatusCode = 'R' AND Customer.EMailAddress IS NOT NULL AND Customer.EMailAddress <> ''"

	End If
      
ElseIf PageView = tabPage(3) Then
      'Reminders
	If SecurityCheck("SubscriptionRenewalReminders") = True Then 

		strPageTitle	=  tabName(3)
		tabStatus(3) 	= "active"
		SQLWhereEvents 	= " AND OrderLine.StatusCode = 'S' AND Customer.EMailAddress IS NOT NULL AND Customer.EMailAddress <> ''"

	End If

ElseIf PageView = tabPage(4) Then
      'Options
	If SecurityCheck("SubscriptionRenewalLetters") = True Then 

		strPageTitle	=  tabName(4)
		tabStatus(4) 	= "active"
		
	End If

End if

'-------------------------------------------------

If request("FormName") = "PrintMenu" Then
      Call PrintLetters
Else
      Call EventMenu
End If

'-------------------------------------------------

Sub EventMenu

%>

<html>
<head>
<title>Tix - <%=strPageTitle%> </title>

<meta http-equiv="X-UA-Compatible" content="IE=edge;chrome=1">

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link rel="stylesheet" type="text/css" href="https://fonts.googleapis.com/css?family=Roboto:400,100,300,500,700,900" >

<link rel="stylesheet" type="text/css" href="https://oss.maxcdn.com/icheck/1.0.2/skins/all.min.css" >

<link type="text/css" rel="stylesheet" href="/css/basic.css">

<link type="text/css" rel="stylesheet" href="css/panels.css">	

<link type="text/css" rel="stylesheet" href="css/tablee.css">

<link type="text/css" rel="stylesheet" href="css/switch.css">

<link type="text/css" rel="stylesheet" href="css/buttons.css">

<link type="text/css" rel="stylesheet" href="css/navbar.css">


<style>

#panel-options-outer
{       
position: absolute;
z-index: 20;
overflow: hidden;
width: 990px;
padding: 0px .5px 20px .5px;
}

#panel-options-inner
{
background-color: white;
margin-top: -675px;
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
background-color: rgb(194, 208, 222);
}

.nav-pills > li > a
{
background-color: rgb(248, 248, 248);
font-weight: 700;
}
</style>


<style>
#content-inner-wrapper
{
width: 990px !important;
max-width: 990px !important;
margin-top: -1px !important;
}
 
</style>

<style>

/* -- Table style -------------- */

.table
{
width: 100%;
background-color: #fff;
border-collapse: collapse;
font-size: 12px;
}


/* table columns - center first/last columns */ 

.table > thead > tr > th:first-child,
.table > thead > tr > th:last-child,
.table > tbody > tr > td:first-child,
.table > tbody > tr > td:last-child
{
text-align: center;
vertical-align: middle; 
padding: 0px;
}

.table > thead > tr > th 
{
color: #ffffff;
background-color:  #42A940;
vertical-align: middle;
border-bottom: 1px solid rgba(0, 0, 0, 0.12);
border-top: 1px solid rgba(0, 0, 0, 0.12);
}

.table > tbody > tr > td 
{
color: #333333;
border-bottom: 1px solid rgba(66, 169, 64,.5);
border-top: 1px solid rgba(66, 169, 64,.5);
transition: all 1s ease-in 0s;
}

.table > tbody > tr.active > td
{
background-color: rgba(115, 113, 110, .1);
color: #000000;
transition: all 1s ease-in 0s;
}
 

/* column headers: hand cursor, prevent text highlight */

table.table thead .header,
table.table thead .headerSortDown,
table.table thead .headerSortUp
{
cursor: pointer;
-webkit-touch-callout: none; /* iOS Safari */
-webkit-user-select: none;   /* Chrome/Safari/Opera */
-khtml-user-select: none;    /* Konqueror */
-moz-user-select: none;      /* Firefox */
-ms-user-select: none;       /* Internet Explorer/Edge */
user-select: none;           /* Non-prefixed version, currently */
vertical-align: inherit;
}


/* column headers: sorting icons */

table.table thead .header:after 
{
font-family: 'FontAwesome';
content: "\00a0\00a0\00a0\f0dc"; /* dual arrows */
color: rgba(255,255,255,.5);
}

table.table thead .headerSortDown:after 
{
font-family: 'FontAwesome';
content: "\00a0\00a0\00a0\f0dd";  /* down arrow */
color: rgba(255,255,255,1);
}

table.table thead .headerSortUp:after 
{
font-family: 'FontAwesome';
content: "\00a0\00a0\00a0\f0de";  /* up arrow */
color: rgba(255,255,255,1);
}
  
</style>


</head>

<body>

<!--#INCLUDE VIRTUAL="TopNavInclude.asp"-->

<section>
							
<%

'Build Navigation Menu
Call NavBar

'Build Options Panel
Call PanelOptions

Call EventListing

%>

</section>

<!--#INCLUDE virtual="FooterInclude.asp"-->

<SCRIPT src='https://tablesorter.com/__jquery.tablesorter.min.js'></SCRIPT>
<SCRIPT src="https://cdn.jsdelivr.net/icheck/1.0.2/icheck.min.js"></SCRIPT> 

<SCRIPT type="text/javascript" language="javascript">

      $(function() 
      {
      
            // iCHECK - RADIO BUTTON
      
            // set radio button color
            $("input[type=radio]").iCheck(
            {
                  radioClass: 'iradio_square-grey',
                  increaseArea: '30%'
            });
            
            // activate hightlight for pre-selected radiobuttons
            $("input[type=radio]:checked").each(function() 
            {
                  $(this).closest("tr").addClass("active");
            });
            
            // toggle hightlight when radiobutton changes state
            $("input[type=radio]").on('ifToggled', function(event)
            {
                  $(this).closest("tr").toggleClass("active")
            });
            
            // iCHECK - CHECKBOX
            
            // set checkbox color
            // ignore toggle switch checkboxes
            $("input[type=checkbox]:not(.switch-input)").iCheck(
            {
                  checkboxClass: 'icheckbox_square-grey',
                  increaseArea: '30%'
            });

            // activate hightlight for pre-selected checkboxes
            $("input[type=checkbox]:checked").each(function() 
            {
                  $(this).closest("tr").addClass("active");
            });

            // toggle hightlight when checkbox changes state
            $("input[type=checkbox]").on('ifToggled', function(event)
            {
                  $(this).closest("tr").toggleClass("active")
            });
       
      }); 
      
      
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
            
      }); 

      $(function() 
      {
            //toggle switch is disabled by default
            $('#toggle-switch').prop('checked', false);
            
            //toggle controls are all disabled by default
            $('.toggle-control').prop('disabled', true);

            //toggle control submit is enabled by default
            $('.toggle-submit').prop('disabled', false);
            
            //enable toggle controls when toggle switch selected
            $('#toggle-switch').change(function() 
            {
                  $('.toggle-control').toggleDisabled();       
            });
      });


      $.fn.blindToggle = function(speed, easing, callback) 
      {
      var h = (this.height() + parseInt(this.css('paddingTop')) + parseInt(this.css('paddingBottom')) + 9);
      return this.animate({marginTop: parseInt(this.css('marginTop')) < 0 ? 0 : -h}, speed, easing, callback);  
      };

      $.fn.slideFadeToggle = function(speed, easing, callback) 
      {
      return this.animate({opacity: 'toggle', height: 'toggle'}, speed, easing, callback);  
      };

      $(function() 
      {
            $('#btnOptions').click(function() 
            {
                  $('#panel-options-inner').blindToggle(1000, 'easeInOutQuart');
            });    
      });
      
      $(function()
      {
            $('.table').tablesorter(
            {
              headers: 
                  { 
                  0: { sorter: false }, 
                  5: { sorter: false } 
              } 
            });
       });

</SCRIPT>
<SCRIPT type="text/javascript" language="javascript">

		function save_settings()
			{
			//Get display label settings and save to local storage
			localStorage.setItem("display_label", $( "#display_label" ).val());

			//Update display
			apply_preferences_to_page();
                  
                  alert('settings saved');
			}

				
		function load_settings()
			{
			//Get existing display label settings from local storage
			var display_label = localStorage.getItem( "display_label" );

			//Update form with current display label settings
			$("#display_label").val(display_label);

			//Update display label with current settings
			apply_preferences_to_page();
                  
                   alert('settings loaded');
			}


		function apply_preferences_to_page()
			{
			var display_label = localStorage.getItem("display_label");

			//apply display label setting to the page
			$(".nav-label").attr("class",'nav-label '+display_label);
                  
                  alert('existing settings loaded');
			
			}


		$(function()
		{
			load_settings();
			$('form#preferences').submit(function(event)
			{
			save_settings();
			});
		});

</SCRIPT>



</body>

</html>

<%

End Sub

'-------------------------------------------------

Sub NavBar

response.write "<div id=""navbar"">" & vbCrLf

response.write "<ul class=""nav nav-tabs pull-left"">" & vbCrLf

For i = 1 to 3
	If tabPage(i) <> "" Then
		response.write "<li class=" & tabStatus(i) & ">" & vbCrLf
		response.write "<a href=""" & Server.URLEncode(fnScriptName) & "?PageView=" & Server.URLEncode(tabPage(i)) & """><span style=""margin-right:10px;margin-left:10px;"" class=""" & tabIcon(i) & """></span><span class=""nav-label"">" & tabName(i) & "</span></a>" & vbCrLf
		response.write "</li>" & vbCrLf
	End If
Next
 
response.write "</ul>" & vbCrLf

response.write "<div class=""nav-btn pull-right"">" & vbCrLf
response.write "<button class=""btn btn-large btn-default"" id=""btnOptions"" type=""button"" data-placement=""top"" title=""Options"">" & vbCrLf
response.write "<span class=""fa fa-cog"" style=""margin-right:10px;margin-left:10px;""></span>" & vbCrLf
response.write "<span class=""nav-label"">" & tabName(4) & "</span>" & vbCrLf
response.write "</button>" & vbCrLf
response.write "</div>" & vbCrLf

response.write "</div>" & vbCrLf

response.write "<h2 class=""pageHeader inset-shadow-bar"">" & strPageTitle & "</h2>"
response.write "<div style=""-webkit-box-shadow: 0 4px 6px -6px #222;  -moz-box-shadow: 0 4px 6px -6px #222;  box-shadow: 0 4px 6px -6px #222;"">Template Name: " & fnTemplateDetail("Name") & "</div>"


'Build Event Listing

Select Case strPageTitle
	Case tabPage(4)

	Case Else

		If strPageTitle <> tabPage(2) Then

		End If
End Select


End Sub

'-------------------------------------------------

Sub PanelOptions

%>

<!-- panel edit -->  
<DIV class="panel-body" id="panel-options-outer">
<DIV class="container-fluid" id="panel-options-inner"> 

                               
            <ul class="nav nav-pills nav-stacked col-sm-3" style="margin-top: 15px;" style="outline:1px solid #666666; padding: 15px;">
                  <li  class="active"><a href="#tabA" data-toggle="tab">Printing Options</a></li>
                  <li class=""><a href="#tabB" data-toggle="tab">Display Options</a></li>
            </ul>

                  <div class="tab-content col-sm-9">
                  
                         <div class="tab-pane  active" id="tabA" style="background-color: #ffffff; border: 1px solid #e3e3e3; border-radius: 4px; box-shadow: 0 1px 1px rgba(0, 0, 0, 0.05) inset; padding: 10px;">
 
                              <form method="POST" action="" class="form-horizontal" name="TemplateFile" style="background-color: #f5f5f5; border: 1px solid #e3e3e3; border-radius: 4px; box-shadow: 0 1px 1px rgba(0, 0, 0, 0.05) inset; margin:0px;padding:20px;">
 
                                    <div class="form-group">
                                    
                                          <label class="control-label col-md-3"> 
                                           Template File
                                          </label>
                                          
							<div class="col-lg-9">
								<select class="form-control" name="TemplateIndex">
									<%=fnTemplateList%>
								</select>
							</div>
						</div>
 
                                    <div class="form-group">
                                          <label class="control-label col-md-3"> 
                                                &nbsp;
                                          </label>
                                          <div class="col-md-9" style="text-align:left;">
                                            <button type="submit" class="btn btn-primary">Update</button>
                                          </div>
                                    </div>

                              </form>
                          
                        </div>
                        
                       <div class="tab-pane" id="tabB" style="background-color: #ffffff; border: 1px solid #e3e3e3; border-radius: 4px; box-shadow: 0 1px 1px rgba(0, 0, 0, 0.05) inset; padding: 10px;">
                       
                              <form method="POST" action="" class="form-horizontal" name="preferences" id="preferences" style="background-color: #f5f5f5; border: 1px solid #e3e3e3; border-radius: 4px; box-shadow: 0 1px 1px rgba(0, 0, 0, 0.05) inset; margin:0px;padding:20px;">
 
                                    <div class="form-group">
                                    
                                           <label class="control-label col-md-3"> 
                                          Icon Labels
                                          </label>
                                          
                                          <div class="col-lg-9">
                                                <select class="form-control" id="display_label" name="display_label">
                                                      <option value="hide">Icons Only</option>
                                                      <option value="">Icons/Labels</option>
                                                </select>
                                          </div>
                                    </div>
 
                                    <div class="form-group">
                                          <label class="control-label col-md-3"> 
                                                &nbsp;
                                          </label>
                                          <div class="col-md-9" style="text-align:left;">
                                            <button type="submit" class="btn btn-primary">Update</button>
                                          </div>
                                    </div>

                              </form>
                       
                       </div>
                  
                  
                  </div>
       
</div>
</div>
               
<%     
     
End Sub

'------------------------------------

Sub EventListing

'Build the event list page for ticket sales

Response.Write "<div style=""padding-left:20px; padding-right:20px;"">" & vbCrLf
			
SQLEvents = "SELECT Event.EventCode, Event.EventDate, Act.Act, Venue.Venue, COUNT(distinct OrderHeader.OrderNumber) AS OrderCount  FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK)  ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK)  ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Shipping (NOLOCK)  ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN Act (NOLOCK)  ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK)  ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization (NOLOCK) ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber  WHERE Event.EventCode IN ( SELECT Event.EventCode  FROM Event(NOLOCK) INNER JOIN Venue ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber  WHERE Organization.OrganizationNumber = " & Session("OrganizationNumber") & " AND EventDate > GETDATE() ) AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') " & SQLWhereEvents & " GROUP BY Event.EventCode, Act.Act, Event.EventDate, Venue.Venue ORDER BY Event.EventDate"
Set rsEvents = OBJdbConnection.Execute(SQLEvents)

If Not rsEvents.EOF Then


            Response.Write "<FORM ACTION=""" & fnScriptName() & """ METHOD=""post"">" & vbCrLf
            Response.Write "<INPUT TYPE=""hidden"" NAME=""FormName"" VALUE=""PrintMenu"">" & vbCrLf

            Response.Write "<table class=""table"" id=""#eventlisting"" border=""0"" style=""margin-top:25px;"">" & vbCrLf
            Response.Write "<thead>" & vbCrLf
            Response.Write "<tr>" & vbCrLf
            Response.Write "<th>Print</th>" & vbCrLf
            Response.Write "<th>Event<BR>Code</th>" & vbCrLf
            Response.Write "<th>Date<BR>Time</th>" & vbCrLf
            Response.Write "<th>Event<BR>Name</th>" & vbCrLf
            Response.Write "<th>Venue<BR>Location</th>" & vbCrLf
            Response.Write "<th>Order<BR>Count</th>" & vbCrLf
            Response.Write "</tr>" & vbCrLf
            Response.Write "</thead>" & vbCrLf
            Response.Write "<tbody>" & vbCrLf

		Do Until rsEvents.EOF
		
                  'Determine if event has date or time suppressed

                  'Event List

                  Response.Write "<tr>" & vbCrLf
                  Response.Write "<td><INPUT TYPE=""checkbox"" NAME=""EventCode"" VALUE=" & rsEvents("EventCode") & "></td>" & vbCrLf
                  Response.Write "<td>" & rsEvents("EventCode") & "</td>" & vbCrLf
                  Response.Write "<td>" & rsEvents("EventDate") & "</td>" & vbCrLf
                  Response.Write "<td>" & rsEvents("Act") & "</td>" & vbCrLf
                  Response.Write "<td>" & rsEvents("Venue") & "</td>" & vbCrLf
                  Response.Write "<td>" & rsEvents("OrderCount") & "</td>" & vbCrLf
                  Response.Write "</tr>" & vbCrLf

                  rsEvents.MoveNext
		Loop
 
		Response.Write "</TBODY>" & vbCrLf
		Response.Write "</TABLE>" & vbCrLf
		Response.Write "</FONT>" & vbCrLf
		Response.Write "<DIV STYLE=""width:95%; text-align:left;"">" & vbCrLf
		Response.Write "<INPUT CLASS=""btn btn-ghost btn-default toggle-submit"" TYPE=""submit"" VALUE=""Print"">" & vbCrLf
		Response.Write "</DIV>" & vbCrLf
		Response.Write "</FORM>" & vbCrLf

Else


		Response.Write "<FONT>" & vbCrLf
		Response.Write "<TABLE CELLSPACING=0 CELLPADDING=1 WIDTH=95% BORDER=0>" & vbCrLf
		Response.Write "<TR>" & vbCrLf
		Response.Write "<TD>" & vbCrLf

		Response.Write "<div style=""min-height: 300px; text-align: center; font-family: Verdana,Arial,Helvetica, sans-serif; font-size: small;  color: black;"">There are no events to list at this time.</div>" & vbCrLf

		Response.Write "</TD>" & vbCrLf
		Response.Write "</TR>" & vbCrLf
		Response.Write "</TABLE>" & vbCrLf
   
End If
 
rsEvents.Close
Set rsEvents = nothing

Response.Write "</div>" & vbCrLf

End Sub
				
'-------------------------------------------------

Sub PrintLetters

'Server.ScriptTimeout = 600

%>

<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="utf-8">

<title>2017 Fixed Renewal Letters</title>

<SCRIPT LANGUAGE="JavaScript">
<!-- Begin
	function PrintLetters(){
		window.print(); 
		}

//  End -->
</SCRIPT>

<meta name="viewport" content="width=device-width, initial-scale=1">


<style type="text/css">

@media screen 
{
	/* background */
	html 
	{ 
	background-color: #838383;
	padding: 0.2in;
	margin-top: .4in;
	cursor: default; 
	}

	/* content wrapper */
	body 
	{ 
	background-color: #ffffff;
	box-sizing: border-box; 
	width: 8.5in; 
	padding-top: .5in;
	padding-bottom: .5in;
	padding-left: .5in;
	padding-right: .5in;
	margin: 0px auto; 
	box-shadow: 0px 0px 1in -0.25in rgba(0, 0, 0, 0.5); 
	border: 0;
	}

	/* content - first page */
	.section:first-of-type 
	{
	margin-top:0;
	}

	/* content */
	.section
	{
      font-family: 'Times New Roman', TimesNewRoman, Times, Baskerville, Georgia, serif;
	font-size: 15px; 
	background-color: #ffffff;
	outline: 1px dashed #999999;
	margin-top: .7in;
	margin-bottom: .7in;
	min-height:800px;
	}

	.page-break	
	{ 
	height:25px; 
	width:816px; 
	background-color: #838383;
	border-left: 1px solid #838383;
	border-right: 1px solid #838383;
	margin-bottom:10px; 
	margin-left: -49px; 
	}

}

@media print 
{
	html
	{ 
	background-color: #ffffff;
	padding: 0;
	width: auto; 
	margin: auto;
      font-family: 'Times New Roman', TimesNewRoman, Times, Baskerville, Georgia, serif;
	font-size: 11pt; 
	}

	.section
	{
	background-color:  #ffffff;
	outline: 1px dashed #999999;
	width: auto; 
	margin: auto;
	float: none;
	}

	.page-break 
	{ 
	height: 0; 
	page-break-before: always; 
	margin: 0; 
	border-top: none; 
	}

	@page 
	{ 
	size: 8.5in 11in; 
	margin: .5in;
	}
      
}
	
</style>


</head>

<!--<BODY onLoad="PrintLetters()" LEFTMARGIN="0" RIGHTMARGIN="0" TOPMARGIN="0" MARGINHEIGHT="0" MARGINWIDTH="0">-->
<BODY LEFTMARGIN="0" RIGHTMARGIN="0" TOPMARGIN="0" MARGINHEIGHT="0" MARGINWIDTH="0">

<%

'Build the Query to select each of the selected events
'REE 7/7/3 - Removed EventShip from Query.
SQLOrderLine = "SELECT OrderHeader.OrderTypeNumber, OrderHeader.OrderSurcharge, OrderHeader.ShipFee, OrderHeader.Total, OrderLine.OrderNumber, OrderLine.LineNumber, OrderLine.ItemNumber, OrderLine.Price, OrderLine.Surcharge, OrderLine.Discount, OrderLine.ShipCode, Event.EventCode, Event.EventDate, Event.Map, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, PostalCode, Customer.DayPhone, Customer.NightPhone, Customer.EMailAddress, Shipping.ShipType, Act.Act, Venue.Venue, SeatType.SeatType, Seat.Row, Seat.Seat, Seat.SectionCode, Section.Section FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.SectionCode = Section.SectionCode AND Event.EventCode = Section.EventCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN Shipping (NOLOCK) ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode "
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
SQLOrderLine = SQLOrderLine & SQLWhere & ") AND OrderLine.StatusCode = 'R' AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') ORDER BY OrderLine.OrderNumber, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry, OrderLine.ShipCode, Seat.EventCode, Seat.SectionCode, RowSort, SeatSort DESC"
Set rsOrderLine = OBJdbConnection.Execute(SQLOrderLine)
		
Call DBOpen(OBJdbConnection2)
		
Do Until rsOrderLine.EOF

	If rsOrderLine("OrderNumber") <> LastOrderNumber Then 'It's different.  Print it.
      
		If TicketCount > 0 Then 'It's not the first one, print the footer.
            Call PrintFooter
		End If
				
		SQLCustInfo = "SELECT Customer.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry FROM OrderHeader (NOLOCK) INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber WHERE OrderHeader.OrderNumber = " & rsOrderLine("OrderNumber") & " AND OrderLine.LineNumber = " & rsOrderLine("LineNumber")
		Set rsCustInfo = OBJdbConnection.Execute(SQLCustInfo)

                  If Not rsCustInfo.EOF Then

                        %>
                        <!--#INCLUDE FILE="RenewalLetterInclude.asp"-->
                        <%	
       
                        SQLItemNumber = "SELECT ItemNumber FROM OrderLine (NOLOCK) WHERE OrderNumber = " & rsOrderLine("OrderNumber") & " ORDER BY ItemNumber"
                        Set rsItemNumber = OBJdbConnection.Execute(SQLItemNumber)
                        RenewalCode = rsCustInfo("CustomerNumber") & rsItemNumber("ItemNumber")
                        rsItemNumber.Close
                        Set rsItemNumber = nothing
                        
                        Response.Write "<div class=""section""> " & vbCrLf
                        
                        'Letterhead
                        Response.Write "<table border=""0"" cellpadding=""0"" cellspacing=""0"" WIDTH=""100%""> " & vbCrLf 
                        Response.Write "<tbody> " & vbCrLf 
                        Response.Write "<tr> " & vbCrLf 
                        Response.Write "<td align=""center""> " & vbCrLf 
                        Response.Write "<img src=""https://cdn.pbrd.co/images/bS3EgB7ev.png"" /><BR>" & vbCrLf 
                        Response.Write "</td> " & vbCrLf 
                        Response.Write "</tr> " & vbCrLf 
                        Response.Write "</table> " & vbCrLf 
                        

                        'Bill To / Ship To Address
                        Response.Write "<TABLE WIDTH=""100%"" border=""0"" style=""margin-top:25px;"">" & vbCrLf 
                        Response.Write "<TR>" & vbCrLf 
                        Response.Write "<TD WIDTH=""10%"">&nbsp;</TD>" & vbCrLf 
                        Response.Write "<TD WIDTH=""60%""><B>Shipping Information</B></TD>" & vbCrLf 
                        Response.Write "<TD WIDTH=""20%""><B>Billing Information</B></TD>" & vbCrLf 
                        Response.Write "<TD WIDTH=""10%"">&nbsp;</TD>" & vbCrLf 
                        Response.Write "</TR>" & vbCrLf 
                        Response.Write "<TR>" & vbCrLf 
                        Response.Write "<TD>&nbsp;</TD>" & vbCrLf 
                        Response.Write "<TD>" & vbCrLf 
                        Response.Write "" & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & "<BR>" & rsCustInfo("ShipAddress1") & "<BR>" & vbCrLf
                        If rsCustInfo("ShipAddress2") <> "" Then
                              Response.Write rsCustInfo("ShipAddress2") & "<BR>" & vbCrLf
                        End If
                        Response.Write rsCustInfo("ShipCity") & ", " & rsCustInfo("ShipState") & " " & rsCustInfo("ShipPostalCode") & "</TD><TD>" & rsCustInfo("FirstName") & " " & rsCustInfo("LastName") & "<BR>" & rsCustInfo("Address1") & "<BR>" & vbCrLf
                        If rsCustInfo("Address2")<> "" Then
                              Response.Write rsCustInfo("Address2") & "<BR>" & vbCrLf
                        End If
                        Response.Write rsCustInfo("City") & ", " & rsCustInfo("State") & " " & rsCustInfo("PostalCode") & "" & vbCrLf
                        Response.Write "</TD>" & vbCrLf
                        Response.Write "<TD>&nbsp;</TD>" & vbCrLf 
                        Response.Write "</TR>" & vbCrLf
                        Response.Write "</TABLE>" & vbCrLf

                        
                        'Order Number / Renewal Number
                        Response.Write "<TABLE WIDTH=""100%"" border=""0"" style=""margin-top:25px;"">" & vbCrLf 
                        Response.Write "<TR>" & vbCrLf
                        Response.Write "<TD WIDTH=""10%"">&nbsp;</TD>" & vbCrLf 
                        Response.Write "<TD WIDTH=""60%""><B>Order Number</B></TD>" & vbCrLf 
                        Response.Write "<TD WIDTH=""20%""><B>Renewal Code</B></TD>" & vbCrLf 
                        Response.Write "<TD WIDTH=""10%"">&nbsp;</TD>" & vbCrLf 
                        Response.Write "</TR>" & vbCrLf
                        Response.Write "<TR>" & vbCrLf
                        Response.Write "<TD>&nbsp;</TD>" & vbCrLf 
                        Response.Write "<TD>" & rsOrderLine("OrderNumber") & "</TD>" & vbCrLf
                        Response.Write "<TD>" & RenewalCode & "</TD>" & vbCrLf
                        Response.Write "<TD>&nbsp;</TD>" & vbCrLf 
                        Response.Write "</TABLE>" & vbCrLf

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
		
		If rsOrderLine("OrderSurcharge") > 0 Then
			LastTotal = LastTotal - rsOrderLine("OrderSurcharge")
		End If

		TicketCount = TicketCount + 1

        If TicketCount Mod 100 = 0 Then 
            Response.Flush
        End If

	End If

	'Print Event Info and Column Headings if this is a new Event
	If LastEventCode <> rsOrderLine("EventCode") Or LastOrderNumber <> rsOrderLine("OrderNumber") Then
      
            'Act and Delivery Method
		Response.Write "<TABLE WIDTH=""100%"" style=""margin-top:25px;"">" & vbCrLf
            Response.Write "<TR>" & vbCrLf
            Response.Write "<TD><B>Subscription</B></TD>" & vbCrLf
            Response.Write "<TD>" & vbCrLf
            Response.Write "" & rsOrderLine("Act") & " at " & rsOrderLine("Venue")
		
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
			Response.Write " at " & Left(FormatDateTime(rsOrderLine("EventDate"),vbLongTime),Len(FormatDateTime(rsOrderLine("EventDate"),vbLongTime))-6) & "&nbsp;" & Right(FormatDateTime(rsOrderLine("EventDate"),vbLongTime),2)
		End If
		rsTimeSuppress.Close
		Set rsTimeSuppress = nothing
            
            Response.Write "</TD></TR>" & vbCrLf
            Response.Write "<TR><TD><b>Delivery Method</b></TD>" & vbCrLf
		Response.Write "<TD>" & rsOrderLine("ShipType") & "</TD></TR></TABLE>" & vbCrLf
            
            'Ticket Line Item Details
 
		'Calculate Number of Columns
		SQLNumColumns = "SELECT SUM(OrderLine.Surcharge) AS ServiceFee, SUM(OrderLine.Discount) AS Discount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & rsOrderLine("OrderNumber") & " AND ItemType IN ('Seat', 'SubFixedEvent')"
		Set rsNumColumns = OBJdbConnection.Execute(SQLNumColumns)

            NumColumns = 6
		ColFacilityCharge = "N"
		ColServiceFee = "N"
		ColDiscount = "N"
            
            ColumnHeading = "<TABLE WIDTH=""100%"" BORDER=""0"" style=""margin-top:25px;""><TR><TD><B><U>Section</U></B></TD><TD ALIGN=center><B><U>Row</U></B></TD><TD ALIGN=center><B><U>Seat</U></B></TD><TD><B><U>Type</U></B></TD><TD ALIGN=right><B><U>Price</U></B></TD>"

		FacilityCharge = 0
            
		If FacilityCharge <> 0 Then
			NumColumns = NumColumns + 1
			ColumnHeading = ColumnHeading + "<TD ALIGN=right><B><U>Facility Charge</U></B></TD>"
			ColFacilityCharge = "Y"
		End If
            
		If rsNumColumns("ServiceFee") > 0 Then
			'NumColumns = NumColumns + 1
			'ColumnHeading = ColumnHeading + "<TD ALIGN=right><B><U>Service Fee</U></B></TD>"
			'ColServiceFee = "Y"
		End If
            
		If rsNumColumns("Discount") <> 0 Then
			NumColumns = NumColumns + 1
			ColumnHeading = ColumnHeading + "<TD ALIGN=right><B><U>Discount</U></B></TD>"
			ColDiscount = "Y"
		End If

		rsNumColumns.Close
		Set rsNumColumns = nothing

		ColumnHeading = ColumnHeading + "<TD ALIGN=right><B><U>Amount</U></B></TD></TR>" & vbCrLf
		
		Response.Write ColumnHeading

		LastEventCode = rsOrderLine("EventCode")
	End If
      
      'Print the detail
	'Add the OrderNumber and LineNumber to the Form
	LineDetail = "<TR><TD>" & rsOrderLine("Section") & "</TD><TD ALIGN=center>" & rsOrderLine("Row") & "</TD><TD ALIGN=center>" & rsOrderLine("Seat") & "</TD><TD>" & rsOrderLine("SeatType") & "</TD><TD ALIGN=right>" & FormatCurrency(rsOrderLine("Price"),2) & "</TD>"
	
	If ColFacilityCharge = "Y" Then
		LineDetail = LineDetail & "<TD ALIGN=right>" & FormatCurrency(FacilityCharge,2) & "</TD>"
	End If
	If ColServiceFee = "Y" Then
		LineDetail = LineDetail & "<TD ALIGN=right>" & FormatCurrency(rsOrderLine("Surcharge"),2) & "</TD>"
	End If
	If ColDiscount = "Y" Then
		LineDetail = LineDetail & "<TD ALIGN=right>" & FormatCurrency(rsOrderLine("Discount"),2) & "</TD>"
	End If
	
	LineDetail = LineDetail & "<TD ALIGN=right>" & FormatCurrency(rsOrderLine("Price")-rsOrderLine("Discount"),2) & "</TD></TR>" & vbCrLf
	
	Response.Write LineDetail

	LastOrderNumber = rsOrderLine("OrderNumber")
	
	rsOrderLine.MoveNext
			
	
rsOrderLine.MoveNext		
Loop	
	
If TicketCount > 0 Then	'Print the last footer
    Call PrintFooter
End If

rsOrderLine.Close
Set rsOrderLine = nothing

Call DBClose(OBJdbConnection2)

End Sub 'PrintLetters

'-------------------------------------------------

Sub PrintFooter

'Response.Write "<TR><TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf			
If LastShipFee <> 0 And LastOrderTypeNumber <> 5 Then
	'Response.Write "<TR><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """>Processing Fee</TD><TD ALIGN=""right"">" & FormatCurrency(LastShipFee,2) & "</TD></TR>" & vbCrLf
	Response.Write "<TR><TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf
End If

'Response.Write "<TR><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """>Total</TD><TD ALIGN=""right"">" & FormatCurrency(LastTotal,2) & "</TD></TR>" & vbCrLf

Response.Write "</TABLE>" & vbCrLf

'Credit Card Number

Response.Write "<TABLE WIDTH=""100%"" style=""margin-top:25px;"">" & vbCrLf
Response.Write "<TR><TD COLSPAN=""3"">Make checks payable to Centerpoint Legacy Theatre" &  vbCrLf
Response.Write "<TR><TD COLSPAN=""3"">I prefer to pay by:&nbsp;&nbsp;[&nbsp;&nbsp;] MasterCard&nbsp;&nbsp;&nbsp;[&nbsp;&nbsp;] Visa&nbsp;&nbsp;&nbsp;[&nbsp;&nbsp;] American Express&nbsp;&nbsp;&nbsp;[&nbsp;&nbsp;] Discover</TD></TR>" & vbCrLf
Response.Write "<TR><TD COLSPAN=""3""><BR>____ ____ ____ ____ -  _____ _____ _____ _____ -  _____ _____ _____ _____ -  _____ _____ _____ _____</TD></TR>" & vbCrLf
Response.Write "<TR><TD COLSPAN=""3"">(Card Number)<BR></TD></TR>" & vbCrLf
Response.Write "<TR><TD>_________________&nbsp;&nbsp;</TD>"
Response.Write "<TD>_____________________________&nbsp;&nbsp;</TD>"
Response.Write "<TD>_____________________________</TD></TR>"
Response.Write "<TR><TD>(Expiration Date)</TD>" & vbCrLf
Response.Write "<TD>(Name as it appears on card) PRINT</TD>" & vbCrLf
Response.Write "<TD>(Signature)</TD></TR></TABLE><BR>" & vbCrLf

Select Case fnTemplateDetail("Index")

Case 28 'Flex

'Subscription Pricing
Response.Write "<CENTER>"
Response.Write "<TABLE border cellpadding=""0"" cellspacing=""0"" bgcolor=""#bfbfbf"" width=""550px"">" & vbCrLf
Response.Write "<TR>" & vbCrLf 
Response.Write "<TD align=""center"">" & vbCrLf  
Response.Write "<BR>" & vbCrLf 
Response.Write "<B>SEASON TICKETS.</B>&nbsp;Flexible when your schedule isn't!<BR>" & vbCrLf 
Response.Write "<BR>" & vbCrLf  
Response.Write "<TABLE border=""0"" cellpadding=""0"" cellspacing=""0"" width=""450px"">" & vbCrLf 
Response.Write "<TR>" & vbCrLf 
Response.Write "<TD width=""75%""><B><i>Flex Subscription Pricing</i></B></TD>" & vbCrLf 
Response.Write "<TD width=""25%"">&nbsp;</TD>" & vbCrLf 
Response.Write "</TR>" & vbCrLf 
Response.Write "<TR>" & vbCrLf 
Response.Write "<TD>Adult&nbsp;</TD>" & vbCrLf 
Response.Write "<TD>$124.00</TD>" & vbCrLf 
Response.Write "</TR>" & vbCrLf 
Response.Write "<TR>" & vbCrLf 
Response.Write "<TD>Senior/Student&nbsp;</TD>" & vbCrLf 
Response.Write "<TD>$112.00</TD>" & vbCrLf 
Response.Write "</TR>" & vbCrLf 
Response.Write "</TABLE>" & vbCrLf
Response.Write "<BR>" & vbCrLf 
Response.Write "</CENTER>"

Case 27  'Fixed

'Subscription Pricing
Response.Write "<CENTER>"
Response.Write "<TABLE border cellpadding=""0"" cellspacing=""0"" bgcolor=""#bfbfbf"" width=""550px"">" & vbCrLf
Response.Write "<TR>" & vbCrLf 
Response.Write "<TD align=""center"">" & vbCrLf  
Response.Write "<BR>" & vbCrLf 
Response.Write "<B>SEASON TICKETS.</B>&nbsp;Guaranteed Same Seating for Every Show!<BR>" & vbCrLf 
Response.Write "<BR>" & vbCrLf  
Response.Write "<TABLE border=""0"" cellpadding=""0"" cellspacing=""0"" width=""450px"">" & vbCrLf 
Response.Write "<TR>" & vbCrLf 
Response.Write "<TD width=""50%""></TD>" & vbCrLf 
Response.Write "<TD width=""25%""><I><B>Tu/We/Mat</B></I></TD>" & vbCrLf 
Response.Write "<TD width=""25%""><I><B>Mo/Th/Fr/Sa</B></I></TD>" & vbCrLf 
Response.Write "</TR>" & vbCrLf 
Response.Write "<TR>" & vbCrLf 
Response.Write "<TD>Main Level Adult&nbsp;</TD>" & vbCrLf 
Response.Write "<TD>$111.00</TD>" & vbCrLf 
Response.Write "<TD>$124.00</TD>" & vbCrLf 
Response.Write "</TR>" & vbCrLf 
Response.Write "<TR>" & vbCrLf 
Response.Write "<TD>Main Level Senior/Student&nbsp;</TD>" & vbCrLf 
Response.Write "<TD>$101.00</TD>" & vbCrLf 
Response.Write "<TD>$112.00</TD>" & vbCrLf 
Response.Write "</TR>" & vbCrLf 
Response.Write "<TR>" & vbCrLf 
Response.Write "<TD>Balcony Level Adult&nbsp;</TD>" & vbCrLf 
Response.Write "<TD>$83.00</TD>" & vbCrLf 
Response.Write "<TD>$95.00</TD>" & vbCrLf 
Response.Write "</TR>" & vbCrLf 
Response.Write "<TR>" & vbCrLf 
Response.Write "<TD>Balcony Level Senior/Student&nbsp;</TD>" & vbCrLf 
Response.Write "<TD>$75.00</TD>" & vbCrLf 
Response.Write "<TD>$86.00</TD>" & vbCrLf 
Response.Write "</TR>" & vbCrLf 
Response.Write "</TABLE>" & vbCrLf 
Response.Write "<BR>" & vbCrLf 
Response.Write "</TD>" & vbCrLf 
Response.Write "</TR>" & vbCrLf 
Response.Write "</TABLE>" & vbCrLf
Response.Write "</CENTER>"

End Select

'End Wrapper
Response.Write "</td> " & vbCrLf 
Response.Write "</tr> " & vbCrLf 
Response.Write "</table> " & vbCrLf 
Response.Write "</div> " & vbCrLf 
Response.Write "<div class=""page-break""></div>" & vbCrLf

End Sub 'PrintFooter

'-------------------------------------------------

PUBLIC FUNCTION fnTemplateList

	'Populates a drop down list with the organizations email templates
	
	DIM strResults
      strResults = strResults & "<option value="""">---- Select Template File ----</option>"

      SQLQuery = "SELECT TemplateIndex, OrganizationNumber, TemplateDescription, TemplateFileName, TemplateType, TemplateDefault FROM TemplateFiles (NOLOCK) WHERE OrganizationNumber = " &  Session("OrganizationNumber") & " AND TemplateType = 'Letter'"
      Set rsQuery = OBJdbConnection.Execute(SQLQuery)

            If Not rsQuery.EOF Then 
                  Do Until rsQuery.EOF
            
                        If rsQuery("TemplateDefault") = "True" Then
                              selected = "selected=selected"
                        Else
                              selected = ""
                        End If
                        
                       strResults = strResults & "<option value=""" & rsQuery("TemplateIndex") & """ " & selected & ">" & rsQuery("TemplateDescription") & "</option>"

                  rsQuery.MoveNext
                  Loop
            End If	

      rsQuery.Close
      Set rsQuery = Nothing
      
      'errorlog("strResults: " & strResults)

	fnTemplateList = strResults

END FUNCTION

'-------------------------------------------------

PUBLIC FUNCTION fnDefaultTemplate

DIM strResults

      SQLQuery = "SELECT TemplateIndex FROM TemplateFiles (NOLOCK) WHERE OrganizationNumber = " &  Session("OrganizationNumber") & " AND TemplateType = 'Letter' AND TemplateDefault='True'"
      Set rsQuery = OBJdbConnection.Execute(SQLQuery)
            If Not rsQuery.EOF Then 
                 strResults = rsQuery("TemplateIndex") 
            End If	
      rsQuery.Close
      Set rsQuery = Nothing
      
      fnDefaultTemplate = strResults 

END FUNCTION

'-------------------------------------------------

PUBLIC FUNCTION fnTemplateDetail(strItem)

      DIM strResults
 
      Select Case strItem
      
            Case "Index"
                  SQLQuery = "SELECT TemplateIndex FROM TemplateFiles (NOLOCK) WHERE OrganizationNumber = " &  Session("OrganizationNumber") & " AND TemplateDefault='True'"
                  Set rsQuery = OBJdbConnection.Execute(SQLQuery)
                        If Not rsQuery.EOF Then
                              strResults = rsQuery("TemplateIndex") 
                        End If	
                  rsQuery.Close
                  Set rsQuery = Nothing
            Case "Name"
                  SQLQuery = "SELECT TemplateDescription FROM TemplateFiles (NOLOCK) WHERE OrganizationNumber = " &  Session("OrganizationNumber") & " AND TemplateIndex=" & TemplateIndex & ""
                  Set rsQuery = OBJdbConnection.Execute(SQLQuery)
                        If Not rsQuery.EOF Then
                              strResults = rsQuery("TemplateDescription") 
                        End If	
                  rsQuery.Close
                  Set rsQuery = Nothing
            Case "File"
                  SQLQuery = "SELECT TemplateFileName FROM TemplateFiles (NOLOCK) WHERE OrganizationNumber = " &  Session("OrganizationNumber") & " AND TemplateIndex=" & TemplateIndex & ""
                  Set rsQuery = OBJdbConnection.Execute(SQLQuery)
                        If Not rsQuery.EOF Then
                              strResults = rsQuery("TemplateFileName") 
                        End If	
                  rsQuery.Close
                  Set rsQuery = Nothing
            End Select

      fnTemplateDetail = strResults 

END FUNCTION

'-------------------------------------------------

Sub SetDefaultTemplate(Index)

SQLQuery = "SELECT TemplateIndex FROM TemplateFiles (NOLOCK) WHERE OrganizationNumber = " &  Session("OrganizationNumber") & " AND TemplateType = 'Letter' Order by TemplateIndex"
Set rsQuery = OBJdbConnection.Execute(SQLQuery)
      If Not rsQuery.EOF Then 
            Do Until rsQuery.EOF
                  If int(rsQuery("TemplateIndex")) = int(Index) Then
                        SQLUpdateOrderLine = "UPDATE TemplateFiles WITH (ROWLOCK) SET TemplateFiles.TemplateDefault = 'True' WHERE TemplateFiles.TemplateIndex = " & rsQuery("TemplateIndex") & ""
                        Set rsUpdateOrderLine = OBJdbConnection.Execute(SQLUpdateOrderLine)
                       errorlog("Update " & rsQuery("TemplateIndex") & " true")
                  Else
                       SQLUpdateOrderLine = "UPDATE TemplateFiles  WITH (ROWLOCK) SET TemplateDefault = 'False' WHERE TemplateFiles.TemplateIndex = " & rsQuery("TemplateIndex") & ""
                       Set rsUpdateOrderLine = OBJdbConnection.Execute(SQLUpdateOrderLine)
                       errorlog("Update " & rsQuery("TemplateIndex")  & " false")
                  End If
            rsQuery.MoveNext	
            Loop	
      End If	
rsQuery.Close
Set rsQuery = Nothing
      
END Sub

'-------------------------------------------------

Public Function fnScriptName()

	DIM strPath
	DIM arrPath
	DIM strResults

	strPath = Request.ServerVariables("SCRIPT_NAME")
	arrPath = Split(strPath, "/")
	strResults = arrPath(UBound(arrPath,1))
	
	fnScriptName = strResults
  
End Function 

'-------------------------------------------------




%>