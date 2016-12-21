<% 

'CHANGE LOG
'REE 4/15/2 - Increased Session Timeout to 30 minutes to reduce Print validation timeout issues.
'JAI 6/24/9 - Specify organization ReplyTo e-mail address and the e-mail subject
'JAI 04/29/14 - 2015 Renewal Emails
'SSR 06/18/14 - 2015 Renewal Reminder Emails
'SSR 07/17/14 - Updated for use with Road Company
'SSR 07/18/14 - Updated EmailReplayTo 
'SLM 08/10/16 - Updated for NT Live

%>

<!--METADATA TYPE="typelib" UUID="CD000000-8B95-11D1-82DB-00C04FB1625D"  NAME="CDO for Windows 2000 Library" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp"-->
<!--#INCLUDE VIRTUAL="TicketPrintInclude.asp"-->
<!--#INCLUDE VIRTUAL="NoCacheInclude.asp"-->

<%

'-----------------------------------

Page = "Management"

Server.ScriptTimeout = 60 * 60 

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
DIM tabURL(4)

DIM SQLWhereEvents

DIM NavMenu

'-----------------------------------

'Organization Variables

DIM OrganizationName
OrganizationName = fnOrgName

DIM MsgFontFace
MsgFontFace = "arial,helvetica"

DIM PrivateLabel
PrivateLabel = "centerpointtheatre"

DIM LogoFilePath
LogoFilePath = "https://www.tix.com/clients/" & PrivateLabel & "/Renewal/images/logocolor.png"
 
DIM RenewalURL
RenewalURL = "http://" & PrivateLabel & ".tix.com/renew.aspx?"

DIM RenewalCode

DIM RenewalOrder

DIM EasyRenewalURL
 
DIM SHOWCHILD 
SHOWCHILD = TRUE

'-----------------------------------

'Email Variables

DIM JohnsonHead
JohnsonHead = "Don't miss out! Be sure to renew your subscription by September 3rd.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"

DIM EMailReplyTo
EMailReplyTo = "tickets@centerpointtheatre.org"

DIM EMailSubject
EMailSubject = "Your CenterPoint Theatre 2017 Season Subscription Renewal"

DIM EmailButton
EmailButton = "<input type=""submit"" class=""btn btn-ghost btn-default toggle-submit"" value=""Send""/>" 
 
DIM TestEMailAddress
DIM TestEMailAddress2
DIM TestModeStatus

'TestEMailAddress = "sergio.rodriguez@tix.com"
'TestEMailAddress2 = "silvia.mahoney@tix.com,djensen@centerpointtheatre.org"
'TestEMailAddress = "sergio@tix.com"
'TestEMailAddress = "silvia.mahoney@tix.com"
'TestEMailAddress = "kjb@rialtocinemas.com"
'TestEMailAddress = "michael@michaelorand.com"
'TestEMailAddress = "silvia.mahoney@tix.com,kjb@rialtocinemas.com,michael@michaelorand.com"

TestEmailCount = 10

If TestEMailAddress <> "" Then
	EMailReplyTo = "sergio.rodriguez@tix.com"
	EMailSubject =  "[Test Email for your review] " & EMailSubject

	TestModeStatus = "Test Mode.  " & TestEmailCount & " test email will be sent to: " & TestEMailAddress & ""
      If TestEMailAddress2 <> "" Then
            TestModeStatus = TestModeStatus & "," & TestEMailAddress2
      End If
	EmailButton = "<input type=""submit"" class=""btn btn-ghost btn-danger"" value=""Test""/>"
End If

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
            tabURL(1)  = "renewalletters.asp"

'Emails Tab

	If SecurityCheck("SubscriptionRenewalEmails") = True Then 
		tabPage(2) = "Emails"
		tabName(2) = "Send Emails"
            tabURL(2)  = "renewalemails.asp"
	End If

'Reminders Tab

	If SecurityCheck("SubscriptionRenewalReminders") = True Then 
		tabPage(3) = "Reminders"
		tabName(3) = "Send Reminder"
            tabURL(3)  = "renewalreminders.asp"
	End If

'Admin Tab

	If SecurityCheck("SubscriptionRenewal") = True Then 
		tabPage(4) = "Options"
		tabName(4) = ""
            tabURL(4)  = ""
	End If

'-------------------------------------------------

'Determine the requested page view
'Verify permission to display page

If Request.QueryString("PageView") <> "" Then
      PageView = Request.QueryString("PageView")
Else
      PageView = "Emails"
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

<link rel="stylesheet" type="text/css" href="https://oss.maxcdn.com/icheck/1.0.2/skins/all.min.css" >

<style>
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
/* ===============
PANEL STYLES 
=============== */


/* slide down panel */ 
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
width: 989px;
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
/* =====================
NAV BAR
===================== */


.page-content div#navbar ul
{
margin-top: 0px !important;
margin-bottom: 0px !important;
padding-left: 10px;
}

#content-inner-wrapper 
{
padding-top: 0px !important;
}

div#navbar
{
background-color: #F2F2F2;
height: 45px;
border:1px solid #DDDDDD;
width: 100%;
}


div#navbar ul.nav.nav-tabs
{
border: 0;
height: 44px;
}

div#navbar ul.nav.nav-tabs li
{
border-bottom: 0px;
}


div#navbar ul.nav.nav-tabs li a
{
position: relative
font-family: arial;
font-size: 13px;
text-decoration: none;
display:block;
padding: 10px;
margin-top: 3px;
transition: all 0.35s ease-in-out 0s;
color: #A9A9A9; 
border:1px solid #cccccc;
border-bottom: 1px solid #dddddd;
}


div#navbar ul.nav.nav-tabs li a:hover
{
background-color: #E3E3E3;
transition: all 0.35s ease-in-out 0s;
color: #696969;
border:1px solid #cccccc;
border-bottom: 1px solid #dddddd;
}


div#navbar ul.nav.nav-tabs li.active a,
div#navbar ul.nav.nav-tabs li.active a:hover
{
color: #0E9F0E;
background-color: #ffffff;
transition: all 0.35s ease-in-out 0s;
border: 1px solid #cccccc;
border-bottom: 1px solid #ffffff;
}


div#navbar div.pull-right a.btn.btn-default
{
margin-top:5px;
margin-right: 10px;
font-family: arial;
font-size: 13px;
text-decoration: none;
background-color: #ECECEC;
outline: none;
}


div#navbar div.pull-right a.btn.btn-default
{
color: #333333;
transition: all 0.35s ease-in-out 0s;
}

div#navbar div.pull-right a:hover.btn.btn-default
{
background-color: #CECECE;
transition: all 0.35s ease-in-out 0s;
}

div#navbar div.nav-btn.pull-right button#btnOptions.btn.btn-large.btn-default
{
margin-top: 5px;
margin-right: 5px;
color: #333333;
background-color: #FFFFFF;
transition: all 0.35s ease-in-out 0s;
}

div.page-content h2.pageHeader
{
margin-top:35px;
margin-bottom:25px;
}

</style>

<style>
#content-inner-wrapper
{
width: 990px !important;
max-width: 990px !important;
}

#panel-main
{
padding: 10px;
}

</style>

<style>


/* -- Table style -------------- */

.table
{
width: 95%;
max-width: 95%;
margin-bottom: 2rem;
background-color: #fff;
border-collapse: collapse;
}


.table > thead > tr > th,
.table > tbody > tr > th,
.table > tfoot > tr > th,
.table > thead > tr > td,
.table > tbody > tr > td,
.table > tfoot > tr > td 
{
text-align: left;
padding: 15px;
vertical-align: top;
border-top: 0;
border-bottom: 1px solid #DCEDC8;
font-size: 13px;
font-weight: 400;
}

.table > thead > tr > th 
{
font-weight: 600;
color: #ffffff;
background-color:  #42A940;
vertical-align: bottom;
border-bottom: 1px solid rgba(0, 0, 0, 0.12);
}


.table > caption + thead > tr:first-child > th,
.table > colgroup + thead > tr:first-child > th,
.table > thead:first-child > tr:first-child > th,
.table > caption + thead > tr:first-child > td,
.table > colgroup + thead > tr:first-child > td,
.table > thead:first-child > tr:first-child > td 
{
border-top: 0;
}


.table .table
{
background-color: #fff;
}


.table .no-border
{
border: 0;
}

.table-condensed > thead > tr > th,
.table-condensed > tbody > tr > th,
.table-condensed > tfoot > tr > th,
.table-condensed > thead > tr > td,
.table-condensed > tbody > tr > td,
.table-condensed > tfoot > tr > td 
{
padding: 5px;
}

.table-bordered 
{
border: 0;
}


.table-striped.table-mc-light-green > tbody > tr:nth-child(odd) > td,
.table-striped.table-mc-light-green > tbody > tr:nth-child(odd) > th 
{
background-color: #f1f1f1;
}


.table-striped.table-mc-light-green > tbody tr.checked > td
{
background-color: #dcedc8;
border-bottom: 1px solid #ffffff;
}

</style>

<style>

.group-head
{
text-transform: uppercase;
font-size: 0.90em;
font-weight: 700;
border-bottom:1px solid #cccccc;
}

</style>

</head>

<body>

<!--#INCLUDE VIRTUAL="TopNavInclude.asp"-->
							
<%

'Build Navigation Menu
Call NavBar

'Build Options Panel
Call PanelOptions

Call EventListing

%>

<!--#INCLUDE virtual="FooterInclude.asp"-->

	<SCRIPT src="https://cdn.jsdelivr.net/icheck/1.0.2/icheck.min.js" type="text/javascript" language="javascript" ></SCRIPT> 
	
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
		})(jQuery);

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
			$('#btnOptions').click(function() 
			{
				$('#panel-options-inner').blindToggle(1000, 'easeInOutQuart');
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
		response.write "<a href=""" & Server.URLEncode(tabURL(i)) & "?PageView=" & Server.URLEncode(tabPage(i)) & """>" & tabName(i) & "</a>" & vbCrLf
		response.write "</li>" & vbCrLf
	End If
Next

response.write "</ul>" & vbCrLf

response.write "<div class=""nav-btn pull-right"">" & vbCrLf
response.write "<BUTTON class=""btn btn-large btn-default"" id=""btnOptions"" type=""button"" data-placement=""top"" title=""Options"">" & vbCrLf
response.write "<span class=""fa fa-cog""></span>" & vbCrLf
response.write "<SPAN class=""icon-label"">Options</SPAN>" & vbCrLf
response.write "</BUTTON>" & vbCrLf
response.write "</div>" & vbCrLf
	
response.write "</div>" & vbCrLf

response.write "<h2 class=""pageHeader inset-shadow-bar"">" & strPageTitle & "</h2>"
response.write "Template Name: " & fnTemplateDetail("Name") & "<BR>"
response.write TestModeStatus

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
                  <li  class="active"><a href="#tabA" data-toggle="tab">Template</a></li>
            </ul>

                  <div class="tab-content col-sm-9">
            
                        <div style="background-color: #ffffff; border: 1px solid #e3e3e3; border-radius: 4px; box-shadow: 0 1px 1px rgba(0, 0, 0, 0.05) inset; padding: 10px;">

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
                                            <button type="submit" class="btn btn-primary" style="color:#ffffff;">Update</button>
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

Response.Write "<DIV class=""panel-body"" id=""panel-main"">" & vbCrLf
				
SQLEvents = "SELECT Event.EventCode, Event.EventDate, Act.Act, Venue.Venue, COUNT(distinct OrderHeader.OrderNumber) AS OrderCount  FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK)  ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK)  ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Shipping (NOLOCK)  ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN Act (NOLOCK)  ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK)  ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization (NOLOCK) ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber  WHERE Event.EventCode IN ( SELECT Event.EventCode  FROM Event(NOLOCK) INNER JOIN Venue ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber  WHERE Organization.OrganizationNumber = " & Session("OrganizationNumber") & " AND EventDate > GETDATE() ) AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') " & SQLWhereEvents & " GROUP BY Event.EventCode, Act.Act, Event.EventDate, Venue.Venue ORDER BY Event.EventDate"
Set rsEvents = OBJdbConnection.Execute(SQLEvents)

If Not rsEvents.EOF Then

            Response.Write "<FONT style=""text-align:center;"">" & vbCrLf
            
            Response.Write "<FORM ACTION=""" & fnScriptName() & """ METHOD=""post"">" & vbCrLf
            Response.Write "<INPUT TYPE=""hidden"" NAME=""FormName"" VALUE=""PrintMenu"">" & vbCrLf

            Response.Write "<table class=""table"" id=""eventlist"">" & vbCrLf
            Response.Write "<thead>" & vbCrLf
            Response.Write "<tr>" & vbCrLf
            Response.Write "<th valign=""middle"">Print</th>" & vbCrLf
            Response.Write "<th valign=""middle"">Event<BR>Code</th>" & vbCrLf
            Response.Write "<th valign=""middle"">Date<BR>Time</th>" & vbCrLf
            Response.Write "<th valign=""middle"">Event<BR>Name</th>" & vbCrLf
            Response.Write "<th valign=""middle"">Venue<BR>Location</th>" & vbCrLf
            Response.Write "<th valign=""middle"">Order<BR>Count</th>" & vbCrLf
            Response.Write "</tr>" & vbCrLf
            Response.Write "</thead>" & vbCrLf
            Response.Write "<tbody>" & vbCrLf

		Do Until rsEvents.EOF
		
                  'Determine if event has date or time suppressed

                  'Event List

                  Response.Write "<tr>" & vbCrLf
                  Response.Write "<td><INPUT TYPE=""checkbox"" NAME=""EventCode"" VALUE=" & rsEvents("EventCode") & "></td>" & vbCrLf
                  Response.Write "<td>" & rsEvents("EventCode") & "</td>" & vbCrLf
                  Response.Write "<td>" & FormatDateTime(rsEvents("EventDate"), vbShortDate) & "<BR>" & Left(FormatDateTime(rsEvents("EventDate"),vbLongTime),Len(FormatDateTime(rsEvents("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsEvents("EventDate"),vbLongTime),3) & "</td>" & vbCrLf
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
		Response.Write "<INPUT CLASS=""btn btn-ghost btn-default toggle-submit"" TYPE=""submit"" VALUE=""Email"">" & vbCrLf
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
		Response.Write "</FONT>" & vbCrLf


    
End If


Response.Write "</DIV>" & vbCrLf

rsEvents.Close
Set rsEvents = nothing

End Sub
				
'-------------------------------------------------

Sub PrintLetters

'Server.ScriptTimeout = 600

DIM OrderCount
OrderCount = 1


%>

<HTML>
<HEAD>
<TITLE>TIX - Subscription Renewal E-Mail</TITLE>
</HEAD>
<BODY LEFTMARGIN="0" RIGHTMARGIN="0" TOPMARGIN="0" MARGINHEIGHT="0" MARGINWIDTH="0">

<STYLE>	
	div {page-break-before: always}
</STYLE>

<FONT COLOR="#000000">
<%

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
SQLOrderLine = SQLOrderLine & SQLWhere & ") AND OrderLine.StatusCode = 'R' AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') AND Customer.EMailAddress IS NOT NULL AND Customer.EMailAddress <> '' AND OrderHeader.OrderNumber > 22278245 ORDER BY OrderLine.OrderNumber, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry, OrderLine.ShipCode, Seat.EventCode, Seat.SectionCode, RowSort, SeatSort DESC"
Set rsOrderLine = OBJdbConnection.Execute(SQLOrderLine)
		
Do Until rsOrderLine.EOF

	If rsOrderLine("OrderNumber") <> LastOrderNumber Then 
	'This is not the last order.
	
		'Print the footer
		If TicketCount > 0 Then
		
			EMailMessage = EMailMessage & "<TR><TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf			
			If LastShipFee <> 0 And LastOrderTypeNumber <> 5 Then
				EMailMessage = EMailMessage & "<TR><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=" & MsgFontFace & ">Processing Fee</TD><TD ALIGN=""right""><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(LastShipFee,2) & "</TD></TR>" & vbCrLf
				EMailMessage = EMailMessage & "<TR><TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf
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

			EMailMessage = EMailMessage & "<TR><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=" & MsgFontFace & ">Order Total</TD><TD ALIGN=""right""><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(LastTotal,2) & "</TD></TR>" & vbCrLf
			If LastTender <> 0 Then
				EMailMessage = EMailMessage & "<TR><TD WIDTH=""50"">&nbsp;</TD><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=C" & MsgFontFace & ">Less Payments</TD><TD ALIGN=""right""><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(LastTender,2) & "</TD></TR>" & vbCrLf
				EMailMessage = EMailMessage & "<TR><TD WIDTH=""50"">&nbsp;</TD><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=" & MsgFontFace & ">Balance Due</TD><TD ALIGN=""right""><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(LastTotal - LastTender,2) & "</TD></TR>" & vbCrLf
			End If
			EMailMessage = EMailMessage & "</TABLE>" & vbCrLf
			EMailMessage = EMailMessage & "</CENTER><BR>" & vbCrLf
			
			'-----------------------------------------
			
			'Footer Info
			'Insert HTML Template - Footer Content
									
			EMailMessage = EMailMessage & "<TABLE WIDTH=""650"" cellpadding=""0"" cellspacing=""0"" border=""0"">" & vbCrLf
			EMailMessage = EMailMessage & "<TR>" & vbCrLf
			EMailMessage = EMailMessage & "<TD valign=top>" & vbCrLf
			EMailMessage = EMailMessage & "<FONT FACE=" & MsgFontFace & "><BR>" & vbCrLf

			'Insert HTML Template - Body Content
			EMailMessage = EMailMessage & InsertTemplate("Footer") 

			EMailMessage = EMailMessage & "</FONT>" & vbCrLf
			EMailMessage = EMailMessage & "</TD>" & vbCrLf
			EMailMessage = EMailMessage & "</TR>" & vbCrLf
			EMailMessage = EMailMessage & "</TABLE>" & vbCrLf
			EMailMessage = EMailMessage & "<BR>" & vbCrLf
			
			'-----------------------------------------

			'JAI 3/2/5 - Modified to use CDO Mail
			'Create the e-mail server object
			Set objCDOSYSMail = Server.CreateObject("CDO.Message")
			Set objCDOSYSCon = Server.CreateObject ("CDO.Configuration")

			objCDOSYSCon.Fields(cdoSendUsingMethod) = cdoSendUsingPickup 'For localhost
			objCDOSYSCon.Fields.Update

			'Update the CDOSYS Configuration
			Set objCDOSYSMail.Configuration = objCDOSYSCon
			objCDOSYSMail.From = OrganizationName & " <" & EMailReplyTo & ">" 
			objCDOSYSMail.ReplyTo = EMailReplyTo
			
                  If TestEMailAddress <> "" Then
				LastEMailAddress = TestEMailAddress
                  End If
                  
                  If TestEMailAddress2 <> "" Then
                        objCDOSYSMail.Cc = TestEMailAddress2
                  End If

                  objCDOSYSMail.To = LastEMailAddress
			objCDOSYSMail.Subject = EMailSubject
			objCDOSYSMail.HTMLBody = EMailMessage
			objCDOSYSMail.Send

			'Close the server mail object
			Set objCDOSYSMail = Nothing
			Set objCDOSYSCon = Nothing 
                  
                  ErrorLog("#(" &  OrderCount & ") | " & Now() & " | " & LastOrderNumber & " | " & LastEmailAddress & "")
                  Response.Write "#(" &  OrderCount & ") | " & Now() & " | " & LastOrderNumber & " | " & LastEmailAddress & "<BR>" & vbCrLf
                  OrderCount = OrderCount + 1

                  Call WaitTime(10)

			EMailMessage = ""

			If TestEMailAddress <> "" And OrderCount >= TestEmailCount Then
				Exit Do
			End If

		End If

		SQLCustInfo = "SELECT Customer.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry FROM OrderHeader (NOLOCK) INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber WHERE OrderHeader.OrderNumber = " & rsOrderLine("OrderNumber") & " AND OrderLine.LineNumber = " & rsOrderLine("LineNumber")
		Set rsCustInfo = OBJdbConnection.Execute(SQLCustInfo)

		If Not rsCustInfo.EOF Then
		
			'-----------------------------------------
			
			'Insert HTML Template - Header Content
			'Response.Write InsertTemplate("CoverPage") 
			
			'-----------------------------------------
									
			'Shipping and Billing Address
			
			ReturnAddress = ""

			ReturnAddress = ReturnAddress & "<BR>" & vbCrLf
			ReturnAddress = ReturnAddress & "<TABLE WIDTH=""650"" cellpadding=""0"" cellspacing=""0"" border=""0"">" & vbCrLf
                  ReturnAddress = ReturnAddress & "<TR><TD>" & vbCrLf
			ReturnAddress = ReturnAddress & "<div style=""font-family:Arial, sans-serif;font-size:1px;color:#f6f7fb;line-height:1px;mso-line-height-rule:exactly;display:none;max-width:0px;max-height:0px;opacity:0;overflow:hidden;mso-hide:all;"">" & JohnsonHead & "</div>" & vbCrLf
			ReturnAddress = ReturnAddress & "</TD></TR>" & vbCrLf
                  ReturnAddress = ReturnAddress & "<TR><TD>" & vbCrLf
			ReturnAddress = ReturnAddress & "<IMG SRC=""https://cdn.pbrd.co/images/dp5oEpcwR.png""><BR><BR>" & vbCrLf
			ReturnAddress = ReturnAddress & "</TD></TR>" & vbCrLf
			
			ReturnAddress = ReturnAddress & "<TR><TD style=""font-family:arial,sans-serif; font-size:16px; line-height:25px; color:#4E5561"">" & vbCrLf
			
			ReturnAddress = ReturnAddress & "<p style=""font-family:arial,sans-serif; font-size:17px; line-height:25px; color:#4E5561"">Dear " & PCase(rsCustInfo("ShipFirstName")) & "</p>" & vbCrLf
						
			ReturnAddress = ReturnAddress & "</TD></TR>" & vbCrLf
                  ReturnAddress = ReturnAddress & "</TABLE>" & vbCrLf
			
			EMailMessage = EMailMessage &  ReturnAddress
			
			'-----------------------------------------
									
			'Order Number and Renewal Number
			
			RenewalOrderNumber = rsOrderLine("OrderNumber")
			
			SQLItemNumber = "SELECT ItemNumber FROM OrderLine (NOLOCK) WHERE OrderNumber = " & rsOrderLine("OrderNumber") & " ORDER BY ItemNumber"
			Set rsItemNumber = OBJdbConnection.Execute(SQLItemNumber)
				RenewalCode = rsCustInfo("CustomerNumber") & rsItemNumber("ItemNumber")
				RenewalOrder = rsOrderLine("OrderNumber")
				EasyRenewalURL = RenewalURL & "o=" & RenewalOrder & "&c=" & RenewalCode & ""
			rsItemNumber.Close
			Set rsItemNumber = nothing
			
			
			OrderRenewal = ""
			OrderRenewal = OrderRenewal & "<TABLE WIDTH=""650"" cellpadding=""0"" cellspacing=""0"" border=""0"">" & vbCrLf
			OrderRenewal = OrderRenewal & "<TR>" & vbCrLf
			OrderRenewal = OrderRenewal & "<TD ALIGN=""left"" style=""font-family:arial,sans-serif; font-size:16px; line-height:25px; color:#4E5561"">" & vbCrLf
			OrderRenewal = OrderRenewal & "<B>Order Number:</B>&nbsp;" & rsOrderLine("OrderNumber") & "" & vbCrLf
			OrderRenewal = OrderRenewal & "</TD>" & vbCrLf
			OrderRenewal = OrderRenewal & "<TD ALIGN=""right"" style=""font-family:arial,sans-serif; font-size:16px; line-height:25px; color:#4E5561"">" & vbCrLf		
			OrderRenewal = OrderRenewal & "<B>Renewal Code:</B>&nbsp;" & RenewalCode & "" & vbCrLf
			OrderRenewal = OrderRenewal & "</TD>" & vbCrLf
			OrderRenewal = OrderRenewal & "</TR>" & vbCrLf
			OrderRenewal = OrderRenewal & "</TABLE>" & vbCrLf
			OrderRenewal = OrderRenewal & "<BR>" & vbCrLf
			
			'-----------------------------------------
			
			EMailMessage = EMailMessage & "<TABLE WIDTH=""650"" cellpadding=""0"" cellspacing=""0"" border=""0"">" & vbCrLf
			EMailMessage = EMailMessage & "<TR><TD valign=top>" & vbCrLf
			EMailMessage = EMailMessage & "<FONT FACE=" & MsgFontFace & "><BR>" & vbCrLf

			'Insert HTML Template - Body Content
			EMailMessage = EMailMessage & InsertTemplate("Header") 

			EMailMessage = EMailMessage & "</FONT>" & vbCrLf
			EMailMessage = EMailMessage & "</TD></TR></TBODY></TABLE>" & vbCrLf
			EMailMessage = EMailMessage & "<BR>" & vbCrLf
			
			EMailMessage = EMailMessage & OrderRenewal
			
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
	
		EMailMessage = EMailMessage & "<TABLE WIDTH=""650"" cellpadding=""0"" cellspacing=""0""  border=""0"">" & vbCrLf
		EMailMessage = EMailMessage & "<TR><TD style=""font-family:arial,sans-serif; font-size:16px; line-height:25px; color:#4E5561"">" & vbCrLf
		EMailMessage = EMailMessage & "<B>" & rsOrderLine("Act") & "</B><br>" & vbCrLf
		EMailMessage = EMailMessage & "at " & rsOrderLine("Venue") & "<br>" & vbCrLf
		
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
				
			'Child Events
			
			If SHOWCHILD Then
			
				ChildEvents = ""

				SQLEventChild = "SELECT SubscriptionEvent.EventCode, Event.EventDate, Act.Act FROM SubscriptionEvent (NOLOCK) INNER JOIN Event (NOLOCK) ON SubscriptionEvent.EventCode = Event.EventCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode WHERE SubscriptionEvent.SubscriptionNumber = " & rsOrderLine("EventCode") & ""
				Set rsEventChild = OBJdbConnection.Execute(SQLEventChild)
				
				If Not rsEventChild.EOF Then
					
					linecount = 1

					ChildEvents = ChildEvents & "<TABLE WIDTH=""650"" cellpadding=""0"" cellspacing=""0"" border=""0"">" & vbCrLf
					ChildEvents = ChildEvents & "<TR>" & vbCrLf
					ChildEvents = ChildEvents & "<TD colspan=""2"" style=""font-family:arial,sans-serif; font-size:16px; line-height:25px; color:#4E5561"">" & vbCrLf
					ChildEvents = ChildEvents & "<B>This subscription includes:</B>" & vbCrLf
					ChildEvents = ChildEvents & "</td>" & vbCrLf
					ChildEvents = ChildEvents & "</tr>" & vbCrLf
				
						Do While Not rsEventChild.EOF

							ChildEvents = ChildEvents & "<tr>" & vbCrLf	
							ChildEvents = ChildEvents & "<td ALIGN=""LEFT"" WIDTH=""65%"" style=""font-family:arial,sans-serif; font-size:16px; line-height:25px; color:#4E5561"">" & vbCrLf
							ChildEvents = ChildEvents & "" & rsEventChild("Act") & "" & vbCrLf	
							ChildEvents = ChildEvents & "</td>" & vbCrLf	
							ChildEvents = ChildEvents & "<td ALIGN=""RIGHT""  WIDTH=""35%"" NOWRAP style=""font-family:arial,sans-serif; font-size:16px; line-height:25px; color:#4E5561"">" & vbCrLf
							ChildEvents = ChildEvents & "" & WeekDayName(WeekDay(rsEventChild("EventDate")),1) & "&nbsp;" & FormatDateTime(rsEventChild("EventDate"),vbShortDate) & " at " & Left(FormatDateTime(rsEventChild("EventDate"),vbLongTime),Len(FormatDateTime(rsEventChild("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsEventChild("EventDate"),vbLongTime),3) & "" & vbCrLf
							ChildEvents = ChildEvents & "</td>" & vbCrLf
							ChildEvents = ChildEvents & "</tr>" & vbCrLf
								
						rsEventChild.movenext
						Loop
						
					ChildEvents = ChildEvents & "</TABLE>" & vbCrLf

				Else
			
					ChildEvents = ChildEvents & " " & vbCrLf
				
				End If
					
				rsEventChild.Close
				Set rsEventChild = nothing

				ChildEvents = ChildEvents & "<BR>" & vbCrLf
				
				EMailMessage = EMailMessage & ChildEvents
			
			End If
		
		'-----------------------------------------
		
		'Seat Location, Price, Service Fee

		'Calculate Number of Columns
		SQLNumColumns = "SELECT SUM(OrderLine.Surcharge) AS ServiceFee, SUM(OrderLine.Discount) AS Discount FROM OrderLine WHERE OrderNumber = " & rsOrderLine("OrderNumber") & " AND ItemType IN ('Seat', 'SubFixedEvent')"
		Set rsNumColumns = OBJdbConnection.Execute(SQLNumColumns)

		NumColumns = 6
		
		ColumnHeading = "<TABLE WIDTH=""650"" cellpadding=""0"" cellspacing=""0"" border=""0""> <TR><TD style=""font-family:arial,sans-serif; font-size:16px; line-height:25px; color:#4E5561""><B><U>Section</U></B></FONT></TD><TD ALIGN=center style=""font-family:arial,sans-serif; font-size:16px; line-height:25px; color:#4E5561""><B><U>Row</U></B></TD><TD ALIGN=center style=""font-family:arial,sans-serif; font-size:16px; line-height:25px; color:#4E5561""><B><U>Seat</U></B></TD><TD style=""font-family:arial,sans-serif; font-size:16px; line-height:25px; color:#4E5561""><B><U>Type</U></B></FONT></TD><TD ALIGN=right style=""font-family:arial,sans-serif; font-size:16px; line-height:25px; color:#4E5561""><B><U>Price</U></B></TD>"
		
		FacilityCharge = 0
		If FacilityCharge <> 0 Then
			NumColumns = NumColumns + 1
			ColumnHeading = ColumnHeading + "<TD ALIGN=right style=""font-family:arial,sans-serif; font-size:16px; line-height:25px; color:#4E5561""><B><U>Facility Charge</U></B></TD>"
			ColFacilityCharge = "Y"
		End If
		
		If rsNumColumns("ServiceFee") <> 0 Then
			NumColumns = NumColumns + 1
			ColumnHeading = ColumnHeading + "<TD ALIGN=right style=""font-family:arial,sans-serif; font-size:16px; line-height:25px; color:#4E5561""><B><U>Service Fee</U></B></TD>"
			ColServiceFee = "Y"
		End If
		
		If rsNumColumns("Discount") <> 0 Then
			NumColumns = NumColumns + 1
			ColumnHeading = ColumnHeading + "<TD ALIGN=right style=""font-family:arial,sans-serif; font-size:16px; line-height:25px; color:#4E5561""><B><U>Discount</U></B></TD>"
			ColDiscount = "Y"
		End If

		rsNumColumns.Close
		Set rsNumColumns = nothing

		ColumnHeading = ColumnHeading + "<TD ALIGN=right style=""font-family:arial,sans-serif; font-size:16px; line-height:25px; color:#4E5561""><B><U>Amount</U></B></TD></TR>" & vbCrLf
		
		EMailMessage = EMailMessage & ColumnHeading

		LastEventCode = rsOrderLine("EventCode")
		
		'-----------------------------------------
		
	End If
	
	'-----------------------------------------
		
	'Facility Charge, Surcharge, Discount, Price
	
	LineDetail = "<TR><TD style=""font-family:arial,sans-serif; font-size:16px; line-height:25px; color:#4E5561"">" & rsOrderLine("Section") & "</TD><TD ALIGN=center style=""font-family:arial,sans-serif; font-size:16px; line-height:25px; color:#4E5561"">" & rsOrderLine("Row") & "</TD><TD ALIGN=center style=""font-family:arial,sans-serif; font-size:16px; line-height:25px; color:#4E5561"">" & rsOrderLine("Seat") & "</TD><TD style=""font-family:arial,sans-serif; font-size:16px; line-height:25px; color:#4E5561"">" & rsOrderLine("SeatType") & "</TD><TD ALIGN=right style=""font-family:arial,sans-serif; font-size:16px; line-height:25px; color:#4E5561"">" & FormatCurrency(rsOrderLine("Price"),2) & "</TD>"
	
	If ColFacilityCharge = "Y" Then
		LineDetail = LineDetail & "<TD ALIGN=right style=""font-family:arial,sans-serif; font-size:16px; line-height:25px; color:#4E5561"">" & FormatCurrency(FacilityCharge,2) & "</TD>"
	End If
	If ColServiceFee = "Y" Then
		LineDetail = LineDetail & "<TD ALIGN=right style=""font-family:arial,sans-serif; font-size:16px; line-height:25px; color:#4E5561"">" & FormatCurrency(rsOrderLine("Surcharge"),2) & "</TD>"
	End If
	If ColDiscount = "Y" Then
		LineDetail = LineDetail & "<TD ALIGN=right style=""font-family:arial,sans-serif; font-size:16px; line-height:25px; color:#4E5561"">" & FormatCurrency(rsOrderLine("Discount"),2) & "</TD>"
	End If
	
	LineDetail = LineDetail & "<TD ALIGN=right style=""font-family:arial,sans-serif; font-size:16px; line-height:25px; color:#4E5561"">" & FormatCurrency(rsOrderLine("Price")+FacilityFee+rsOrderLine("Surcharge")-rsOrderLine("Discount"),2) & "</TD></TR>" & vbCrLf
	
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
	
			EMailMessage = EMailMessage & "<TR><TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf			
			
			If LastShipFee <> 0 And LastOrderTypeNumber <> 5 Then
				EMailMessage = EMailMessage & "<TR><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=" & MsgFontFace & ">Processing Fee</TD><TD ALIGN=""right""><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(LastShipFee,2) & "</TD></TR>" & vbCrLf
				EMailMessage = EMailMessage & "<TR><TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf
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

			EMailMessage = EMailMessage & "<TR><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """ style=""font-family:arial,sans-serif; font-size:16px; line-height:25px; color:#4E5561"">Order Total</TD><TD ALIGN=""right"" style=""font-family:arial,sans-serif; font-size:16px; line-height:25px; color:#4E5561"">" & FormatCurrency(LastTotal,2) & "</TD></TR>" & vbCrLf
			
			If LastTender <> 0 Then
				EMailMessage = EMailMessage & "<TR><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=" & MsgFontFace & ">Less Payments</TD><TD ALIGN=""right""><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(LastTender,2) & "</TD></TR>" & vbCrLf
				EMailMessage = EMailMessage & "<TR><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=" & MsgFontFace & ">Balance Due</TD><TD ALIGN=""right""><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(LastTotal - LastTender,2) & "</TD></TR>" & vbCrLf
			End If
						
			EMailMessage = EMailMessage & "</TABLE><BR>" & vbCrLf
			
			'-----------------------------------------
			
			'Footer Info
			'Insert HTML Template - Footer Content
									
			EMailMessage = EMailMessage & "<TABLE WIDTH=""650"" cellpadding=""0"" cellspacing=""0"" border=""0"">" & vbCrLf
			EMailMessage = EMailMessage & "<TR>" & vbCrLf
			EMailMessage = EMailMessage & "<TD valign=top>" & vbCrLf
			EMailMessage = EMailMessage & "<FONT FACE=" & MsgFontFace & "><BR>" & vbCrLf

			'Insert HTML Template - Body Content
			EMailMessage = EMailMessage & InsertTemplate("Footer") 

			EMailMessage = EMailMessage & "</FONT>" & vbCrLf
			EMailMessage = EMailMessage & "</TD>" & vbCrLf
			EMailMessage = EMailMessage & "</TR>" & vbCrLf
			EMailMessage = EMailMessage & "</TABLE>" & vbCrLf
			EMailMessage = EMailMessage & "<BR>" & vbCrLf
			
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
		objCDOSYSMail.From = OrganizationName & " <" & EMailReplyTo & ">" 
		objCDOSYSMail.ReplyTo = EMailReplyTo
		objCDOSYSMail.To = LastEMailAddress
		objCDOSYSMail.BCC = "sergio@tix.com"
		objCDOSYSMail.Subject = EMailSubject
		objCDOSYSMail.HTMLBody = EMailMessage
		objCDOSYSMail.Send

		'Close the server mail object
		Set objCDOSYSMail = Nothing
		Set objCDOSYSCon = Nothing 
            
            ErrorLog("(" &  OrderCount & ") | " & Now() & " | " & LastOrderNumber & " | " & LastEmailAddress & "")
            Response.Write "(" &  OrderCount & ") | " & Now() & " | " & LastOrderNumber & " | " & LastEmailAddress & "<BR>" & vbCrLf
            OrderCount = OrderCount + 1

            Call WaitTime(10)

	End If
	
	EMailMessage = ""

End If

Response.Write "Order Count: " & OrderCount & "<BR>"

rsOrderLine.Close
Set rsOrderLine = nothing

%>



</body>
</html>

<%

End Sub 'PrintLetters

'-------------------------------------------------

PUBLIC FUNCTION fnOrgName

DIM strResults

SQLSearch = "Select  Organization  FROM Organization (NOLOCK) WHERE OrganizationNumber = " &  Session("OrganizationNumber") & ""
Set rsSearch = OBJdbConnection.Execute(SQLSearch)
	strResults = rsSearch("Organization") 
rsSearch.Close
Set rsSearch = Nothing

fnOrgName = strResults

END FUNCTION

'-------------------------------------------------

Public Function fnFolderPath

	'This function looks for the name of the client folder in the database
	'and builds the path for that folder
	
	DIM StrResults

	RootPath =  Server.MapPath("/") & "\"

	DataFolder = "\EventSelection\"

	SQLSearch = "SELECT OptionValue FROM OrganizationOptions (NOLOCK) WHERE OrganizationNumber = " & Session("OrganizationNumber") & " AND OptionName = 'ClientFolder'"
	set rsSearch = OBJdbConnection.Execute(SQLSearch)
		If Not rsSearch.EOF Then
			ClientFolder = "Clients\" & rsSearch("OptionValue")
		End If
	rsSearch.Close
	Set rsSearch = nothing

	strResults =  RootPath & ClientFolder & DataFolder

	fnFolderPath = StrResults

End Function

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

Public Function fnInArray(item, strList)

	arrItem = split(strList,",")

	fnInArray = False

	For i=0 To Ubound(arrItem)
		
		If Int(arrItem(i)) = Int(item) Then
		  fnInArray = True
		  Exit Function      
		End If
	 
	Next
  
End Function

'-------------------------------------------------

PUBLIC FUNCTION fnTemplateList

	'Populates a drop down list with the organizations email templates
	
	DIM strResults
      strResults = strResults & "<option value="""">---- Select Template File ----</option>"

      SQLQuery = "SELECT TemplateIndex, OrganizationNumber, TemplateDescription, TemplateFileName, TemplateType, TemplateDefault FROM TemplateFiles (NOLOCK) WHERE OrganizationNumber = " &  Session("OrganizationNumber") & " AND TemplateType = 'Email'"
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

      SQLQuery = "SELECT TemplateIndex FROM TemplateFiles (NOLOCK) WHERE OrganizationNumber = " &  Session("OrganizationNumber") & " AND TemplateType = 'Email' AND TemplateDefault='True'"
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
            SQLQuery = "SELECT TemplateIndex FROM TemplateFiles (NOLOCK) WHERE OrganizationNumber = " &  Session("OrganizationNumber") & " AND TemplateType = 'Email' AND TemplateDefault='True'"
            Set rsQuery = OBJdbConnection.Execute(SQLQuery)
                  If Not rsQuery.EOF Then
                        strResults = rsQuery("TemplateIndex") 
                  Else
                        strResults = "6"
                  End If
            rsQuery.Close
            Set rsQuery = Nothing
     
     Case "Name"
            SQLQuery = "SELECT TemplateDescription FROM TemplateFiles (NOLOCK) WHERE OrganizationNumber = " &  Session("OrganizationNumber") & " AND TemplateIndex=" & TemplateIndex & ""
            Set rsQuery = OBJdbConnection.Execute(SQLQuery)
                  If Not rsQuery.EOF Then
                        strResults = rsQuery("TemplateDescription") 
                  Else
                        strResults = "Generic Template"
                  End If
            rsQuery.Close
            Set rsQuery = Nothing
      
      Case "File"
            SQLQuery = "SELECT TemplateFileName FROM TemplateFiles (NOLOCK) WHERE OrganizationNumber = " &  Session("OrganizationNumber") & " AND TemplateIndex=" & TemplateIndex & ""
            Set rsQuery = OBJdbConnection.Execute(SQLQuery)
                  If Not rsQuery.EOF Then
                        strResults = rsQuery("TemplateFileName") 
                  Else
                        strResults = "/Clients/Tix/EMailTemplates/PlainTemplate.html"
                  End If	
            rsQuery.Close
            Set rsQuery = Nothing
            End Select



fnTemplateDetail = strResults 

END FUNCTION

'-------------------------------------------------

Sub SetDefaultTemplate(Index)

SQLQuery = "SELECT TemplateIndex FROM TemplateFiles (NOLOCK) WHERE OrganizationNumber = " &  Session("OrganizationNumber") & " AND TemplateType = 'Email' Order by TemplateIndex"
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

Sub WaitTime(TimeInMs)

Dim oShell
Set oShell= Server.CreateObject("WScript.Shell")
'Response.Write "Email sent at: " & Now() & "<br />" & VbCrLf
Call oShell.run("ping 1.1.1.1 -n 1 -w " & TimeInMs, 0, TRUE)

End Sub

'-------------------------------------------------

PUBLIC FUNCTION  PCase(str) 

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

PUBLIC FUNCTION InsertTemplate(templateName)

Dim  strText
strText = ""

Dim strNewText
strNewText = ""

DIM TemplateFilePath
TemplateFilePath = Server.MapPath(fnTemplateDetail("File"))

	Const ForReading = 1

	Set objFSO = CreateObject("Scripting.FileSystemObject")
	
	If objFSO.FileExists(TemplateFilePath) Then

		Set objFile = objFSO.OpenTextFile(TemplateFilePath, ForReading)

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

	Else
	
		strNewText = "Sorry! Template File Not Found: " & TemplateFilePath & ""
	
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
		
		strNewText = Replace(strText,    "[ShipFirstName]", ShipFirstName)
		strNewText = Replace(strText,    "[FirstName]", CustomerFName)
		strNewText = Replace(strNewText, "[webSite]", webSite)
		strNewText = Replace(strNewText, "[orgNumber]", orgNumber)
		strNewText = Replace(strNewText, "[senderFName]", senderFName)
		strNewText = Replace(strNewText, "[senderLName]", senderLName)
		strNewText = Replace(strNewText, "[senderAddress]", senderAddress)
		strNewText = Replace(strNewText, "[OrgName]", fnOrgName)
		strNewText = Replace(strNewText, "[RenewalURL]", RenewalURL)
		strNewText = Replace(strNewText, "[RenewalFirstName]", RenewalFirstName)
		strNewText = Replace(strNewText, "[ServerName]",Request.ServerVariables("server_name"))
		strNewText = Replace(strNewText, "[EasyRenewalURL]", EasyRenewalURL)
		
		replaceVar = strNewText
		
END FUNCTION 

'-------------------------------------------------



%>