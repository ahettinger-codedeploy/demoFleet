<% 

'CHANGE LOG
'SLM 3/6/14 - New King Lear
'JAI 3/11/14 - Corrected formatting if multiple events, and some formatting updates.  Use this as the base template going forward.
'SLM 3/12/14 - New King Lear using revised format
'SSR 6/09/14 - Updated for The Nance

%>

<!--METADATA TYPE="typelib" UUID="CD000000-8B95-11D1-82DB-00C04FB1625D"  NAME="CDO for Windows 2000 Library" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp"-->
<!--#INCLUDE VIRTUAL="TicketPrintInclude.asp"-->
<!--#INCLUDE VIRTUAL="NoCacheInclude.asp"-->

<%

'-----------------------------------

'Print the Billing and Shipping Address
DIM SecReturnAddress
SecReturnAddress = "FALSE"

DIM SecRenewalSection
SecRenewalSection = "TRUE"

DIM SecChildEvents
SecChildEvents = "TRUE"

DIM ColHeading 
ColHeading = "TRUE"

DIM SecLineDetail
SecLineDetail = "TRUE"

DIM ColFacilityCharge
ColFacilityCharge = "N"

DIM ColServiceFee
ColServiceFee = "N"

DIM ColDiscount
ColDiscount = "N"

DIM CustomerNumber

DIM OrderItemNumber

DIM RenewalCode 

DIM RenewalOrderNumber

DIM EMailMessageBody

DIM OrderCount

'-----------------------------------

'Organization Variables

MsgOrgName = GetOrgName(Session("OrganizationNumber"))

PrivateLabel =  GetPrivateLabel(Session("OrganizationNumber"))

DIM CustomerFName

DIM CustomerLName

DIM RenewalPage
RenewalPage = "http://JuniorTheatre.tix.com/renew.aspx"

DIM RenewalOrder
RenewalOrder = 0

DIM RenewalURL

DIM EmailTemplateFile
EmailTemplateFile = "EmailTemplate.asp"

MsgLogoPath = "http://www.tix.com/Clients/" & PrivateLabel & "/Renewals/logo.jpg"

MsgFontFace = "arial,helvetica"

'-----------------------------------

'JAI 6/24/9 - Specify organization ReplyTo e-mail address and the e-mail subject

EMailReplyTo = "diane@juniortheatre.com"

EMailSubject = "Subscription Renewal"

DIM TestMessage
TestMessage = ""

DIM TestEMailCount
TestEMailCount =  20

DIM TestEMailAddress
'TestEMailAddress = "tixtest3@gmail.com"
'TestEMailAddress = "sergio.rodriguez@tix.com"
'TestEMailAddress = "diane@juniortheatre.com"


If TestEMailAddress <> "" Then
	EMailReplyTo = TestEMailAddress
    EMailSubject = EMailSubject & " [Test Email]"
	TestMessage = "Test Mode.  " & TestEMailCount & " test emails will be sent to: " & TestEMailAddress & "<BR><BR>"
End If
'-----------------------------------

'REE 4/15/2 - Increased Session Timeout to 30 minutes to reduce Print validation timeout issues.
Session.Timeout = 60
Server.ScriptTimeout = 3600

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

'Decide which subroutine to route to
Select Case Request("FormName")
	Case "SendEmails"
		Call SendEmails
	Case Else
		Call DisplayMenu
End Select

'----------------------------------

Sub DisplayMenu

%>

<html>

<head>

	<title>TIX - Ticket Sales</title>
	<!-- Force IE to turn off past version compatibility mode and use current version mode -->
	<meta http-equiv="X-UA-Compatible" content="IE=edge;chrome=1">
	<!-- Get the width of the users display-->
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<!-- Text encoded as UTF-8 -->
	<meta http-equiv="Content-Type"  content="text/html; charset=utf-8">

	<link href="https://lipis.github.io/bootstrap-sweetalert/lib/sweet-alert.css" rel="stylesheet" type="text/css">
	<link href="https://netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.min.css" rel="stylesheet"  media="screen">
	<link href="https://netdna.bootstrapcdn.com/font-awesome/3.2.1/css/font-awesome.css" rel="stylesheet">

	<style>	
		
		/* fix page shifing issue */
		
		html { overflow-y: scroll;}
		
		/* remove outline and underscore from buttons - nasty things I hate 'em*/
		 
		a.btn:active { outline:0;   text-decoration:none; } 
		a.btn:focus  { outline:0;   text-decoration:none; }

		button.btn:active { outline:0;   text-decoration:none; }
		button.btn:focus  { outline:0;   text-decoration:none; }
		
		a { text-decoration: none; outline: medium none;}
		
		/* page tabs */

		div.TixManagementContent table.table tbody tr th { background-color: rgb(102, 102, 102); color: #ffffff; }
		.nav-tabs { border-bottom: 0px;}.nav-tabs > li > a { border-width: 2px; border-radius: 4px; border-color: #DDDDDD; #DDDDDD; #DDDDDD; background-color: #EEEEEE; color: #888888; } 
		.nav-tabs > li > a:hover, nav.nav-tabs > li > a:focus, .nav .open > a, .nav .open > a:hover, .nav .open > a:focus { border-color: #DDDDDD; #DDDDDD; #DDDDDD; background-color: #EEEEEE; color: #555555; } 
		.dropdown-menu > li > a:hover, .dropdown-menu > li > a:focus { background-color: #ffffff; color: #262626; text-decoration: none; } .nav-tabs > li.active > a { color: #000000; } 
		.tab-content { border: 2px solid #DDDDDD; border-radius: 4px padding:20px; }  
				
		/* transition animation between page views */
		#wrapper * { -webkit-transition: all .5s ease-in-out; -moz-transition: all .5s ease-in-out; -ms-transition: all .5s ease-in-out; transition: all .5s ease-in-out;}
			
	</style>
	
	<!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
	<!--[if lt IE 9]>
	<script src="../bower_components/bootstrap/assets/js/html5shiv.js"></script>
	<script src="../bower_components/bootstrap/assets/js/respond.min.js"></script>
	<![endif]-->
		
</head>
		
<body>

<!--#INCLUDE VIRTUAL="TopNavInclude.asp"-->
		
<div id="wrapper" class="row">
	<div class="col-lg-12">
		
		<ul class="nav nav-tabs">
			<li id="Letters">	
				  <a href="RenewalLetters.asp">
					Letters
				  </a>
			</li>
			<li id="Emails" class="active">		
				<a href="RenewalEmails.asp">
					Emails
				</a>
			</li>
		</ul>
		
		<div class="tab-content" style="padding:10px;">
			<FONT FACE="verdana,arial,helvetica" COLOR="#008400"><H3><%=MsgOrgName%><BR>
			<FONT FACE="verdana,arial,helvetica" COLOR="#008400">Renewal Emails</H3>
						
			<%=TestMessage%><BR><BR>

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

			If EventList <> "" Then
				'REE 2/25/3 - Removed TicketFormat from criteria.
				SQLTickets = "SELECT COUNT(OrderLine.ItemNumber) AS TicketCount, Act.Act, EventDate, Event.EventCode, Venue FROM Event (NOLOCK) INNER JOIN Seat ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Shipping ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN Act ON Event.ActCode = Act.ActCode INNER JOIN Venue ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber INNER JOIN OrganizationAct ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber WHERE Event.EventCode IN " & EventList & " AND EventDate > GETDATE() AND OrderLine.StatusCode = 'R' AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') AND Customer.EMailAddress IS NOT NULL AND Customer.EMailAddress <> '' GROUP BY Event.EventCode, EventDate, Act.Act, Venue.Venue ORDER BY EventDate, Act.Act"
				Set rsTickets = OBJdbConnection.Execute(SQLTickets)
				
				'REE 4/6/2 - Modified to check for events.
				If Not rsTickets.EOF Then 'There are some events.  List them
					Response.Write "<FORM ACTION=""RenewalEMails.asp"" METHOD=""post""><INPUT TYPE=""hidden"" NAME=""FormName"" VALUE=""SendEmails"">" & vbCrLf

					%>
					<table class="table table-data table-striped table-hover table-checkbox"> 
						<thead> 
							<tr class="noselect"> 
								<th class="cell-center">Print</th> 
								<th class="sort-alpha">Subscription Name</th> 
								<th class="sort-numb">Venue</th> 
								<th class="sort-numb">Date/Time</th> 
								<th class="sort-numb">Quantity</th> 
							</tr> 
						</thead> 
					<%	
					Response.Write "<TBODY>" & vbCrLf

					'Display Event and UnPrinted Ticket Quantities
					Do Until rsTickets.EOF

						Response.Write "<TR><TD><INPUT TYPE=""checkbox"" NAME=""EventCode"" VALUE=" & rsTickets("EventCode") & "></TD><TD>" & cleanHTML(rsTickets("Act")) & "</TD><TD>" & cleanHTML(rsTickets("Venue")) & "</TD><TD>" & DateAndTimeFormat(rsTickets("EventDate")) & "</TD><TD>" & rsTickets("TicketCount") & "</TD></TR>" & vbCrLf

						rsTickets.MoveNext

					Loop
					Response.Write "</TBODY>" & vbCrLf	
					Response.Write "</TABLE><BR>" & vbCrLf
					'Display Buttons to Print
					Response.Write "Select the Renewal Events for which you want to send e-mails and click 'Send E-Mails' below.<BR><BR>" & vbCrLf
					Response.Write "<INPUT TYPE=""submit"" CLASS=""btn btn-outline btn-default"" VALUE=""Send E-Mails""></FORM>" & vbCrLf
				Else 'There aren't any matching events
					Response.Write "<BR><BR>There are no events to be generated.<BR><BR>" & vbCrLf
				End If
			Else 'There aren't any matching events
				Response.Write "<BR><BR>There are no events to be generated.<BR><BR>" & vbCrLf
			End If
			
%>
		</div>

	</div>
	
</div>

</body>

<!--#INCLUDE VIRTUAL="FooterInclude.asp"-->

<script src="https://code.jquery.com/jquery-1.10.2.min.js"></script>
<script src="https://netdna.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
<script src="https://lipis.github.io/bootstrap-sweetalert/lib/sweet-alert.js"></script>


</HTML>

<%

End Sub 

'---------------------------------

Sub SendEmails

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
						EMailMessage = EMailMessage & "<TR><TD WIDTH=""50"">&nbsp;</TD><TD style=""font-family: helvetica,Arial,sans-serif; font-size: 14px; text-align: right; line-height: 20px;"" ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """>Processing Fee</TD><TD style=""font-family: helvetica,Arial,sans-serif; font-size: 14px; text-align: right; line-height: 20px;"" ALIGN=""right"">" & FormatCurrency(LastShipFee,2) & "</TD></TR>" & vbCrLf
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

					EMailMessage = EMailMessage & "<TR>" & vbCrLf
					EMailMessage = EMailMessage & "<TD WIDTH=""50"">&nbsp;</TD>" & vbCrLf
					EMailMessage = EMailMessage & "<TD style=""font-family: helvetica,Arial,sans-serif; font-size: 14px; text-align: right; line-height: 20px; width:15px;"" COLSPAN=""" & NumColumns - 1 & """></TD>" & vbCrLf
					EMailMessage = EMailMessage & "<TD style=""font-family: helvetica,Arial,sans-serif; font-size: 14px; text-align: right; line-height: 20px;"" >" & FormatCurrency(LastTotal,2) & "</TD>" & vbCrLf
					EMailMessage = EMailMessage & "</TR>" & vbCrLf
					If LastTender <> 0 Then
						EMailMessage = EMailMessage & "<TR><TD WIDTH=""50"">&nbsp;</TD><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=C" & MsgFontFace & ">Less Payments</TD><TD ALIGN=""right"">Order Total&nbsp;&nbsp;" & FormatCurrency(LastTender,2) & "</TD></TR>" & vbCrLf
						EMailMessage = EMailMessage & "<TR><TD WIDTH=""50"">&nbsp;</TD><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """>Balance Due</TD><TD ALIGN=""right"">" & FormatCurrency(LastTotal - LastTender,2) & "</TD></TR>" & vbCrLf
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
			
					Response.Write LastOrderNumber & " | " & LastEmailAddress & "<BR>" & vbCrLf

					OrderCount = OrderCount + 1
					
					If TestEMailAddress <> "" And OrderCount >= TestEMailCount Then
						Exit Do
					End If

				End If

				SQLCustInfo = "SELECT Customer.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry FROM OrderHeader (NOLOCK) INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber WHERE OrderHeader.OrderNumber = " & rsOrderLine("OrderNumber") & " AND OrderLine.LineNumber = " & rsOrderLine("LineNumber")
				Set rsCustInfo = OBJdbConnection.Execute(SQLCustInfo)

				If Not rsCustInfo.EOF Then
				
					CustomerFName = rsCustInfo("FirstName")
					CustomerLName = rsCustInfo("LastName") 
				
					'-----------------------------------------
					
					'Insert HTML Template - Header Content
					EMailMessage = EMailMessage & InsertTemplate(EmailTemplateFile,"Header") 
					
					'-----------------------------------------
								
					'Insert HTML Template - Masthead Content
					EMailMessage = EMailMessage & InsertTemplate(EmailTemplateFile,"Masthead") 
					
					'-----------------------------------------
								
					'Shipping and Billing Address
					
					ReturnAddress = "<table width=""100%"" border=""0"" cellspacing=""0"" cellpadding=""0"">" & vbCrLf
					ReturnAddress = ReturnAddress & "<TR>" & vbCrLf
					ReturnAddress = ReturnAddress & "<TD WIDTH=""50%""><FONT FACE=""" & MsgFontFace & """><B>Shipping Information</B></TD>" & vbCrLf
					ReturnAddress = ReturnAddress & "<TD WIDTH=""50%""><FONT FACE=""" & MsgFontFace & """><B>Billing Information</B></TD>" & vbCrLf
					ReturnAddress = ReturnAddress & "</TR>" & vbCrLf
					ReturnAddress = ReturnAddress & "<TR>" & vbCrLf
					ReturnAddress = ReturnAddress & "<TD>" & vbCrLf

					ReturnAddress = ReturnAddress & "<FONT FACE=""" & MsgFontFace & """>" & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & "<BR>" & rsCustInfo("ShipAddress1") & "<BR>" & vbCrLf
					
					If rsCustInfo("ShipAddress2") <> "" Then
						ReturnAddress = ReturnAddress & rsCustInfo("ShipAddress2") & "<BR>" & vbCrLf
					End If
					
					ReturnAddress = ReturnAddress & rsCustInfo("ShipCity") & ", " & rsCustInfo("ShipState") & " " & rsCustInfo("ShipPostalCode") & "" & vbCrLf
					
					ReturnAddress = ReturnAddress & "</TD>" & vbCrLf
					ReturnAddress = ReturnAddress & "<TD>" & vbCrLf
					ReturnAddress = ReturnAddress & "<FONT FACE=""" & MsgFontFace & """>" & rsCustInfo("FirstName") & " " & rsCustInfo("LastName") & "<BR>" & rsCustInfo("Address1") & "<BR>" & vbCrLf
					
					If rsCustInfo("Address2")<> "" Then
						ReturnAddress = ReturnAddress & rsCustInfo("Address2") & "<BR>" & vbCrLf
					End If
					
					ReturnAddress = ReturnAddress & rsCustInfo("City") & ", " & rsCustInfo("State") & " " & rsCustInfo("PostalCode") & "" & vbCrLf
					ReturnAddress = ReturnAddress &"</TD>" & vbCrLf
					ReturnAddress = ReturnAddress & "</TR>" & vbCrLf
					ReturnAddress = ReturnAddress & "<TR>" & vbCrLf
					ReturnAddress = ReturnAddress & "<TD COLSPAN=""3""><hr></TD>" & vbCrLf
					ReturnAddress = ReturnAddress & "</TR>" & vbCrLf
					ReturnAddress = ReturnAddress & "</TABLE>" & vbCrLf
							
					If SecReturnAddress = "TRUE" Then
						EMailMessage = EMailMessage & ReturnAddress
					End If
					
					'-----------------------------------------
					
					'Order Number and Renewal Number
					
					RenewalSection = "<table width=""100%"" border=""0"" cellspacing=""0"" cellpadding=""0"">" & vbCrLf
					RenewalSection = RenewalSection & "<TR>" & vbCrLf
					RenewalSection = RenewalSection & "<TD WIDTH=""50%"" style=""font-family: helvetica,Arial,sans-serif; font-size: 14px; text-align: left; line-height: 20px;"">" & vbCrLf
					RenewalSection = RenewalSection & "<B>Order Number:</B>&nbsp;" & rsOrderLine("OrderNumber") & "" & vbCrLf
					
					RenewalOrderNumber = rsOrderLine("OrderNumber")
					
					RenewalSection = RenewalSection & "</TD>" & vbCrLf
					RenewalSection = RenewalSection & "<TD WIDTH=""50%"" style=""font-family: helvetica,Arial,sans-serif; font-size: 14px; text-align: right; line-height: 20px;"">" & vbCrLf
					
					SQLItemNumber = "SELECT TOP 1 ItemNumber FROM OrderLine (NOLOCK) WHERE OrderNumber = " & rsOrderLine("OrderNumber") & " ORDER BY ItemNumber"
					Set rsItemNumber = OBJdbConnection.Execute(SQLItemNumber)
						CustomerNumber = rsCustInfo("CustomerNumber")
						OrderItemNumber = rsItemNumber("ItemNumber")
						RenewalCode = rsCustInfo("CustomerNumber") & rsItemNumber("ItemNumber")
					rsItemNumber.Close
					Set rsItemNumber = nothing
					
					RenewalSection = RenewalSection & "<B>Renewal Code:</B>&nbsp;" & RenewalCode & "" & vbCrLf
					RenewalSection = RenewalSection & "</TD>" & vbCrLf
					RenewalSection = RenewalSection & "</TR>" & vbCrLf
					RenewalSection = RenewalSection & "</TABLE>" & vbCrLf
					RenewalSection = RenewalSection & "<BR>" & vbCrLf
					
					If SecRenewalSection = "TRUE" Then
						EMailMessage = EMailMessage & RenewalSection
					End If
					
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
				EMailMessage = EMailMessage & "<TR>" & vbCrLf
				EMailMessage = EMailMessage & "<TD style=""font-family: helvetica,Arial,sans-serif; font-size: 14px; text-align: left; line-height: 20px;""><B>Subscription: </B>" & rsOrderLine("Act") & "" & vbCrLf
				EMailMessage = EMailMessage & "<TD style=""font-family: helvetica,Arial,sans-serif; font-size: 14px; text-align: left; line-height: 20px;"">" & vbCrLf 'Delivery Method
				
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

				
				EMailMessage = EMailMessage & "</TD>" & vbCrLf
				EMailMessage = EMailMessage & "</TABLE>" & vbCrLf
				
				EMailMessage = EMailMessage & "<BR>" & vbCrLf
				
				'-----------------------------------------

				'Child Events
				
				SQLEventChild = "SELECT SubscriptionEvent.EventCode, Event.EventDate, Act.Act, Venue.Venue FROM SubscriptionEvent (NOLOCK) INNER JOIN Event (NOLOCK) ON SubscriptionEvent.EventCode = Event.EventCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode WHERE SubscriptionEvent.SubscriptionNumber = " & rsOrderLine("EventCode") & ""
				Set rsEventChild = OBJdbConnection.Execute(SQLEventChild)
				
				If Not rsEventChild.EOF Then
					
					linecount = 1
				
					ChildEvents = "<table width=""100%"" border=""0"" cellspacing=""0"" cellpadding=""0"">" & vbCrLf
					ChildEvents  = ChildEvents  &  "<TR>" & vbCrLf
					ChildEvents  = ChildEvents  &  "<td colspan=""2"" style=""font-family: helvetica,Arial,sans-serif; font-size: 14px; text-align: left; line-height: 18px;"">" & vbCrLf
					ChildEvents  = ChildEvents  &  "<B>This subscription includes:</B><BR>" & vbCrLf
					ChildEvents  = ChildEvents  &  "</td>" & vbCrLf
					ChildEvents  = ChildEvents  &  "</tr>" & vbCrLf
					ChildEvents = ChildEvents &  "<tr>" & vbCrLf
					ChildEvents = ChildEvents &  "<TD WIDTH=""35%"" style=""font-family: helvetica,Arial,sans-serif; font-size: 14px; text-align: left; line-height: 18px;""><B><U>Name</U></B></TD>" & vbCrLf	
					ChildEvents = ChildEvents &  "<TD WIDTH=""25%"" style=""font-family: helvetica,Arial,sans-serif; font-size: 14px; text-align: left; line-height: 18px;""><B><U>Date</U></B></TD>" & vbCrLf	
					ChildEvents = ChildEvents &  "<TD WIDTH=""15%"" style=""font-family: helvetica,Arial,sans-serif; font-size: 14px; text-align: left; line-height: 18px;""><B><U>Time</U></B></TD>" & vbCrLf	
					ChildEvents = ChildEvents &  "<TD WIDTH=""25%"" style=""font-family: helvetica,Arial,sans-serif; font-size: 14px; text-align: left; line-height: 18px;""><B><U>Venue</U></B></TD>" & vbCrLf	
					ChildEvents = ChildEvents &  "</tr>" & vbCrLf					
				
						Do While Not rsEventChild.EOF

							ChildEvents = ChildEvents &  "<tr>" & vbCrLf	
							ChildEvents = ChildEvents &  "<td style=""font-family: helvetica,Arial,sans-serif; font-size: 14px; text-align: left; line-height: 18px;"">" & vbCrLf
							ChildEvents = ChildEvents &  "" & rsEventChild("Act") & "" & vbCrLf	
							ChildEvents = ChildEvents &  "</td>" & vbCrLf	
							ChildEvents = ChildEvents &  "<td NOWRAP style=""font-family: helvetica,Arial,sans-serif; font-size: 14px; text-align: left; line-height: 18px;"">" & vbCrLf
							ChildEvents = ChildEvents &  "" & FormatDateTime(rsEventChild("EventDate"), vbLongDate) & "" & vbCrLf
							ChildEvents = ChildEvents &  "</td>" & vbCrLf
							ChildEvents = ChildEvents &  "<td NOWRAP style=""font-family: helvetica,Arial,sans-serif; font-size: 14px; text-align: left; line-height: 18px;"">" & vbCrLf
							ChildEvents = ChildEvents &  "" & Left(FormatDateTime(rsEventChild("EventDate"),vbLongTime),Len(FormatDateTime(rsEventChild("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsEventChild("EventDate"),vbLongTime),3) & "" & vbCrLf
							ChildEvents = ChildEvents &  "</td>" & vbCrLf
							ChildEvents = ChildEvents &  "<td style=""font-family: helvetica,Arial,sans-serif; font-size: 14px; text-align: left; line-height: 18px;"">" & vbCrLf
							ChildEvents = ChildEvents &  "" & rsEventChild("Venue") & "" & vbCrLf	
							ChildEvents = ChildEvents &  "</td>" & vbCrLf	
							ChildEvents = ChildEvents &  "</tr>" & vbCrLf
	        
						rsEventChild.movenext
						Loop
						
					ChildEvents = ChildEvents &  "</TABLE>" & vbCrLf
					ChildEvents = ChildEvents &  "<BR><BR>" & vbCrLf

				Else
			
					ChildEvents = ChildEvents &  "NO CHILD EVENTS" & vbCrLf
				
				End If
					
				rsEventChild.Close
				Set rsEventChild = nothing

				If SecChildEvents = "TRUE" Then
					EMailMessage = EMailMessage & ChildEvents
				End If

				'-----------------------------------------
				
				'Seat Location, Price, Service Fee

				'Calculate Number of Columns
				SQLNumColumns = "SELECT SUM(OrderLine.Surcharge) AS ServiceFee, SUM(OrderLine.Discount) AS Discount FROM OrderLine WHERE OrderNumber = " & rsOrderLine("OrderNumber") & " AND ItemType IN ('Seat', 'SubFixedEvent')"
				Set rsNumColumns = OBJdbConnection.Execute(SQLNumColumns)

				NumColumns = 5
				
				ColumnHeading = "<TABLE WIDTH=""100%"" BORDER=""0"">" & vbCrLf
				ColumnHeading = ColumnHeading & "<TR>" & vbCrLf
				ColumnHeading = ColumnHeading & "<TD style=""font-family: helvetica,Arial,sans-serif; font-size: 14px; text-align: left; line-height: 20px; white-space: nowrap;""><B><U>Section</U></B></TD>" & vbCrLf
				ColumnHeading = ColumnHeading & "<TD style=""font-family: helvetica,Arial,sans-serif; font-size: 14px; text-align: left; line-height: 20px;"" ALIGN=center><B><U>Row</U></B></TD>" & vbCrLf
				ColumnHeading = ColumnHeading & "<TD style=""font-family: helvetica,Arial,sans-serif; font-size: 14px; text-align: left; line-height: 20px;""><B><U>Seat</U></B></TD>" & vbCrLf
				ColumnHeading = ColumnHeading & "<TD style=""font-family: helvetica,Arial,sans-serif; font-size: 14px; text-align: left; line-height: 20px;""><B><U>Type</U></B></TD>" & vbCrLf
				ColumnHeading = ColumnHeading & "<TD style=""font-family: helvetica,Arial,sans-serif; font-size: 14px; text-align: left; line-height: 20px;""><B><U>Price</U></B></TD>" & vbCrLf
				
				FacilityCharge = 0
				If FacilityCharge <> 0 Then
					NumColumns = NumColumns + 1
					ColumnHeading = ColumnHeading & "<TD style=""font-family: helvetica,Arial,sans-serif; font-size: 14px; text-align: left; line-height: 20px;""><B><U>Facility Charge</U></B></TD>"
					ColFacilityCharge = "Y"
				End If
				
				If rsNumColumns("ServiceFee") <> 0 Then
					NumColumns = NumColumns + 1
					ColumnHeading = ColumnHeading & "<TD style=""font-family: helvetica,Arial,sans-serif; font-size: 14px; text-align: left; line-height: 20px;""><B><U>Service Fee</U></B></TD>"
					ColServiceFee = "Y"
				End If
				
				If rsNumColumns("Discount") <> 0 Then
					NumColumns = NumColumns + 1
					ColumnHeading = ColumnHeading & "<TD style=""font-family: helvetica,Arial,sans-serif; font-size: 14px; text-align: left; line-height: 20px;""><B><U>Discount</U></B></TD>"
					ColDiscount = "Y"
				End If

				rsNumColumns.Close
				Set rsNumColumns = nothing

				ColumnHeading = ColumnHeading & "<TD style=""font-family: helvetica,Arial,sans-serif; font-size: 14px; text-align: right; line-height: 20px;""><B><U>Amount</U></B></TD>" & vbCrLf
				ColumnHeading = ColumnHeading & "</TR>" & vbCrLf
				
				EMailMessage = EMailMessage & ColumnHeading

				LastEventCode = rsOrderLine("EventCode")
				
				'-----------------------------------------
				
			End If
			
			'-----------------------------------------
				
				'Facility Charge, Surcharge, Discount, Price
			
				LineDetail = "<TR>" & vbCrLf
				
					LineDetail = LineDetail & "<TD style=""font-family: helvetica,Arial,sans-serif; font-size: 14px; text-align: left; line-height: 20px; white-space: nowrap;"">" & rsOrderLine("Section") & "</TD>" & vbCrLf
					LineDetail = LineDetail & "<TD style=""font-family: helvetica,Arial,sans-serif; font-size: 14px; text-align: left; line-height: 20px;"">" & rsOrderLine("Row") & "</TD>" & vbCrLf
					LineDetail = LineDetail & "<TD style=""font-family: helvetica,Arial,sans-serif; font-size: 14px; text-align: left; line-height: 20px;"">" & rsOrderLine("Seat") & "</TD>" & vbCrLf
					LineDetail = LineDetail & "<TD style=""font-family: helvetica,Arial,sans-serif; font-size: 14px; text-align: left; line-height: 20px;"">" & rsOrderLine("SeatType") & "</TD>" & vbCrLf
					LineDetail = LineDetail & "<TD style=""font-family: helvetica,Arial,sans-serif; font-size: 14px; text-align: left; line-height: 20px;"">" & FormatCurrency(rsOrderLine("Price"),2) & "</TD>" & vbCrLf

					If ColFacilityCharge = "Y" Then
					LineDetail = LineDetail & "<TD style=""font-family: helvetica,Arial,sans-serif; font-size: 14px; text-align: left; line-height: 20px;"">" & FormatCurrency(FacilityCharge,2) & "</TD>" & vbCrLf
					End If

					If ColServiceFee = "Y" Then
					LineDetail = LineDetail & "<TD style=""font-family: helvetica,Arial,sans-serif; font-size: 14px; text-align: left; line-height: 20px;"">" & FormatCurrency(rsOrderLine("Surcharge"),2) & "</TD>" & vbCrLf
					End If

					If ColDiscount = "Y" Then
					LineDetail = LineDetail & "<TD style=""font-family: helvetica,Arial,sans-serif; font-size: 14px; text-align: left; line-height: 20px;"">" & FormatCurrency(rsOrderLine("Discount"),2) & "</TD>" & vbCrLf
					End If
			
					LineDetail = LineDetail & "<TD style=""font-family: helvetica,Arial,sans-serif; font-size: 14px; text-align: left; line-height: 20px; text-align: right;"">" & FormatCurrency(rsOrderLine("Price")+FacilityFee+rsOrderLine("Surcharge")-rsOrderLine("Discount"),2) & "</TD>" & vbCrLf
			
				LineDetail = LineDetail & "</TR>" & vbCrLf
			
				EMailMessage = EMailMessage & LineDetail
				
				
			'-----------------------------------------

			LastOrderNumber = rsOrderLine("OrderNumber")
			

			
		rsOrderLine.MoveNext	
		Loop	
		
		If TicketCount > 0 Then	'Print the last footer

			EMailMessage = EMailMessage & "</TABLE>" & vbCrLf
			EMailMessage = EMailMessage & "</CENTER><BR>" & vbCrLf
			EMailMessage = EMailMessage & EMailMessageBody
			
			If TestEMailAddress = "" Then
			
					EMailMessage = EMailMessage & "<TR>" & vbCrLf	
					EMailMessage = EMailMessage & "<TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD>" & vbCrLf
					EMailMessage = EMailMessage & "<TD><HR></TD>" & vbCrLf
					EMailMessage = EMailMessage & "</TR>" & vbCrLf			
					
					If LastShipFee <> 0 And LastOrderTypeNumber <> 5 Then
						EMailMessage = EMailMessage & "<TR>" & vbCrLf
						EMailMessage = EMailMessage & "<TD style=""font-family: helvetica,Arial,sans-serif; font-size: 14px; text-align: left; line-height: 20px;""  COLSPAN=""" & NumColumns - 1 & """>Processing Fee</TD>" & vbCrLf
						EMailMessage = EMailMessage & "<TD style=""font-family: helvetica,Arial,sans-serif; font-size: 14px; text-align: left; line-height: 20px;"">" & FormatCurrency(LastShipFee,2) & "</TD>" & vbCrLf
						EMailMessage = EMailMessage & "</TR>" & vbCrLf
						EMailMessage = EMailMessage & "<TR>" & vbCrLf
						EMailMessage = EMailMessage & "<TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD>" & vbCrLf
						EMailMessage = EMailMessage & "<TD><HR></TD>" & vbCrLf
						EMailMessage = EMailMessage & "</TR>" & vbCrLf
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

					EMailMessage = EMailMessage & "<TR>" & vbCrLf
					EMailMessage = EMailMessage & "<TD style=""font-family: helvetica,Arial,sans-serif; font-size: 14px; text-align: right; line-height: 20px; COLSPAN=""" & NumColumns - 1 & """>Order Total</TD>" & vbCrLf
					EMailMessage = EMailMessage & "<TD style=""font-family: helvetica,Arial,sans-serif; font-size: 14px; text-align: right; line-height: 20px;>" & FormatCurrency(LastTotal,2) & "</TD>" & vbCrLf
					EMailMessage = EMailMessage & "</TR>" & vbCrLf
					
					If LastTender <> 0 Then
						EMailMessage = EMailMessage & "<TR><TD style=""font-family: helvetica,Arial,sans-serif; font-size: 14px; text-align: left; line-height: 20px;"" COLSPAN=""" & NumColumns - 1 & """>Less Payments</TD><TD ALIGN=""right"">" & FormatCurrency(LastTender,2) & "</TD></TR>" & vbCrLf
						EMailMessage = EMailMessage & "<TR><TD style=""font-family: helvetica,Arial,sans-serif; font-size: 14px; text-align: left; line-height: 20px;"" COLSPAN=""" & NumColumns - 1 & """>Balance Due</TD><TD ALIGN=""right"">" & FormatCurrency(LastTotal - LastTender,2) & "</TD></TR>" & vbCrLf
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
				
				Response.Write LastOrderNumber & " | " & LastEmailAddress & "<BR>" & vbCrLf
				OrderCount = OrderCount + 1

			End If
			
			EMailMessage = ""

		End If

		Response.Write "Order Count: " & OrderCount & "<BR>"
	
	rsOrderLine.Close
	Set rsOrderLine = nothing
	
	Call DisplayMenu

	
End Sub 'Send Emails


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

PUBLIC FUNCTION GetPrivateLabel(OrgNumbr)

	DIM strTemp

	'SQLVenueRefCheck = "SELECT VenueCode, OptionName, OptionValue FROM VenueOptions WITH (NOLOCK) WHERE VenueCode = (SELECT VenueCode FROM VenueOptions (NOLOCK) WHERE OptionName = 'OrganizationNumber' AND OptionValue = '" & OrgNumbr & "') AND OptionName = 'VenueReference'"
	SQLVenueRefCheck = "SELECT VenueCode, OptionName, OptionValue FROM VenueOptions WITH (NOLOCK) WHERE VenueCode = (SELECT VenueCode FROM VenueOptions (NOLOCK) WHERE OptionName = 'OrganizationNumber' AND OptionValue = '" & (Session("OrganizationNumber")) & "') AND (OptionName = 'VenueReference')"
	Set rsVenueRefCheck = OBJdbConnection.Execute(SQLVenueRefCheck)
		strTemp = rsVenueRefCheck("OptionValue")
	rsVenueRefCheck.Close
	Set rsVenueRefCheck = nothing
	
	GetPrivateLabel = strTemp

	
END FUNCTION

'-------------------------------------------------

PUBLIC FUNCTION GetOrgName(OrgNumber)

SQLThisOrg = "Select  Organization  FROM Organization (NOLOCK) WHERE OrganizationNumber = " &  OrgNumber & ""
Set rsThisOrg = OBJdbConnection.Execute(SQLThisOrg)
	OrgName = rsThisOrg("Organization") 
rsThisOrg.Close
Set rsThisOrg = Nothing

GetOrgName = OrgName

END FUNCTION

'-------------------------------------------------

PUBLIC FUNCTION InsertTemplate(templateFileName,templateName)

Dim  strText
strText = ""

Dim strNewText
strNewText = ""

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
		
		RenewalURL = RenewalPage & "?o=" & RenewalOrderNumber & "&c=" & RenewalCode
	
		DIM strNewText
		
		strNewText = Replace(strText, 	 "[FirstName]", CustomerFName)
		strNewText = Replace(strText, 	 "[LastName]", CustomerLName)
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

%>