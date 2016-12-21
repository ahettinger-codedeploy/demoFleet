<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp"-->
<!--#INCLUDE VIRTUAL="TicketPrintInclude.asp"-->
<!--#INCLUDE VIRTUAL="NoCacheInclude.asp"-->
<%

'CHANGE LOG
'JAI 4/23/13 - New script for TheatreZone renewals.
'JAI 4/16/14 - Uodated for 2014 TheatreZone renewals.
'SSR 4/21/14 - Updated renewal letter

Server.ScriptTimeout = 3600

Page = "ManagementMenu"

'Make sure the correct Session variables are in place.  If not clear the variables and go to the menu.
If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then 
'	Session.Abandon
'	Response.Redirect("/Default.asp")
End If

If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then 
'	Session.Abandon
'	Response.Redirect("Default.asp")
End If

'Decide which subroutine to route to
Select Case Request("FormName")
	Case "PrintMenu"
		Call PrintLetters
	Case Else
		Call PrintMenu
End Select

'----------------------------------

Sub PrintMenu

%>
<HTML>
	<head>
			<title>www.TIX.com - Subscription Renewal Letters</title>
			<!-- Force IE to turn off past version compatibility mode and use current version mode -->
			<meta http-equiv="X-UA-Compatible" content="IE=edge;chrome=1">
			<!-- Get the width of the users display-->
			<meta name="viewport" content="width=device-width, initial-scale=1.0">
			<!-- Text encoded as UTF-8 -->
			<meta http-equiv="Content-Type"  content="text/html; charset=utf-8">
		
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
				
				/* page tabs */

				ul.dropdown-menu li a:active { outline:0;  text-decoration:none; }
				ul.dropdown-menu li a:focus  { outline:0;  text-decoration:none; }

				ul.nav-tabs { margin-bottom: 25px;}

				ul.nav-tabs li a {outline:0;  text-decoration:none; font-size: 10pt;}
				ul.nav-tabs li a:active  {outline:0;  text-decoration:none;}
				ul.nav-tabs li a:focus 	 {outline:0;  text-decoration:none;}
				
				ul.nav-tabs > li.active > a, 
				ul.nav-tabs > li.active > a:link,
				ul.nav-tabs > li.active > a:visited,
				ul.nav-tabs > li.active > a:hover { border-top: 4px solid #008400; color: #000000;}
				
				ul.nav-tabs > li > a, 
				ul.nav-tabs > li > a:link,
				ul.nav-tabs > li > a:visited { border-top: 4px solid #f8f8f8; color: #999999;}
				
				ul.nav-tabs > li > a:hover { border-top: 4px solid #bebebe; color: #999999;}
				
				ul.nav-tabs > li { float: left; margin-bottom: -1px; }
				ul.nav-tabs > li > a { margin-right: 2px; line-height: 1.42857; border: 1px solid transparent; border-radius: 0px; }
				
				.table-fade
				{
				opacity: 0;
				}
				
				/* transition animation between page views */
				#wrapper * { -webkit-transition: all .5s ease-in-out; -moz-transition: all .5s ease-in-out; -ms-transition: all .5s ease-in-out; transition: all .5s ease-in-out;}
				
				/* table */
				th { background: #555555; color: #ffffff; }
				
			</style>


			<!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
			<!--[if lt IE 9]>
			<script src="../bower_components/bootstrap/assets/js/html5shiv.js"></script>
			<script src="../bower_components/bootstrap/assets/js/respond.min.js"></script>
			<![endif]-->
			
	</head>
<BODY BGCOLOR="#FFFFFF">

<!--#INCLUDE VIRTUAL="TopNavInclude.asp"-->
	<div id="wrapper" class="row">
		<div class="col-lg-12">

			<ul class="nav nav-tabs">
				<li class="active"><a href="#">Letters</a></li>
				<li><a href="renewalEmail.asp">Emails</a></li>
				<li><a href="renewalEditor.asp">Editor</a></li>
			</ul>

			<FONT FACE="verdana,arial,helvetica" COLOR="#008400"><H3>Subscription Renewal Letters</H3></FONT><BR><BR>


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
	SQLTickets = "SELECT COUNT(OrderLine.ItemNumber) AS TicketCount, Act.Act, EventDate, Event.EventCode, Venue FROM Event (NOLOCK) INNER JOIN Seat ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Shipping ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN Act ON Event.ActCode = Act.ActCode INNER JOIN Venue ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber INNER JOIN OrganizationAct ON Event.ActCode = OrganizationAct.ActCode WHERE Event.EventCode IN " & EventList & " AND EventDate > GETDATE() AND OrderLine.StatusCode = 'R' AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') GROUP BY Event.EventCode, EventDate, Act.Act, Venue.Venue ORDER BY EventDate, Act.Act"
	Set rsTickets = OBJdbConnection.Execute(SQLTickets)
	
	'REE 4/6/2 - Modified to check for events.
	If Not rsTickets.EOF Then 'There are some events.  List them
		Response.Write "<FORM ACTION=""RenewalLetters.asp"" METHOD=""post""><INPUT TYPE=""hidden"" NAME=""FormName"" VALUE=""PrintMenu"">" & vbCrLf
		Response.Write "<INPUT TYPE=""hidden"" NAME=""start"" VALUE=""" & Clean(Request("Start")) & """><INPUT TYPE=""hidden"" NAME=""end"" VALUE=""" & Clean(Request("End")) & """>" & vbCrLf
		Response.Write "<TABLE class=""table table-striped table-condensed table-hover"">" & vbCrLf
		Response.Write "<THEAD>" & vbCrLf
		Response.Write "<TR><TH>Print</TH><TH>Subscription</TH><TH>Venue</TH><TH>Date/Time</TH><TH>Quantity</TH></TR>" & vbCrLf
		Response.Write "</THEAD>" & vbCrLf
		Response.Write "<TBODY>" & vbCrLf
		'Display Event and UnPrinted Ticket Quantities
		Do Until rsTickets.EOF

			Response.Write "<TR><TD><INPUT TYPE=""checkbox"" NAME=""EventCode"" VALUE=" & rsTickets("EventCode") & "></TD><TD>" & rsTickets("Act") & "</TD><TD>" & rsTickets("Venue") & "</TD><TD NOWRAP>" & DateAndTimeFormat(rsTickets("EventDate")) & "</TD><TD>" & rsTickets("TicketCount") & "</TD></TR>" & vbCrLf
			rsTickets.MoveNext

		Loop
		Response.Write "</TBODY>" & vbCrLf	
		Response.Write "</TABLE><BR>" & vbCrLf
		'Display Buttons to Print
		Response.Write "Select events and click below.<BR><BR>" & vbCrLf
		Response.Write "<INPUT class=""btn btn-large btn-default"" TYPE=""submit"" style=""border-color:#565656;"" VALUE=""Print""></FORM>" & vbCrLf
	Else 'There aren't any matching events
		Response.Write "<BR><BR>There are no events to be printed.</FONT><BR><BR>" & vbCrLf
	End If
Else 'There aren't any matching events
	Response.Write "<BR><BR>There are no events to be printed.</FONT><BR><BR>" & vbCrLf
End If
%>

</div>
</div>


<!--#INCLUDE VIRTUAL="FooterInclude.asp"-->

</BODY>
</HTML>

<%

End Sub 'PrintMenu

'---------------------------------

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
SQLOrderLine = SQLOrderLine & SQLWhere & ") AND OrderLine.StatusCode = 'R' AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent')" & LetterRange & " ORDER BY OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.OrderNumber, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry, OrderLine.ShipCode, Seat.EventCode, Seat.SectionCode, RowSort, SeatSort DESC"
Set rsOrderLine = OBJdbConnection.Execute(SQLOrderLine)
		
Do Until rsOrderLine.EOF ' Or LetterCount >= 1

	If rsOrderLine("OrderNumber") <> LastOrderNumber Then 'It's different.  Print it.
		If TicketCount > 0 Then 'It's not the first one, print the footer.
		
			Response.Write "<TR><TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf			
			If LastShipFee <> 0 And LastOrderTypeNumber <> 5 Then
				Response.Write "<TR><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=Calibri,Charcoal,Arial>[  ] ADD $1 for mailing</TD><TD ALIGN=""right""><FONT FACE=Calibri,Charcoal,Arial>" & FormatCurrency(LastShipFee,2) & "</TD></TR>" & vbCrLf
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

			Response.Write "<TR><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=Calibri,Charcoal,Arial>Order Total</TD><TD ALIGN=""right""><FONT FACE=Calibri,Charcoal,Arial>" & FormatCurrency(LastTotal,2) & "</TD></TR>" & vbCrLf
			If LastTender <> 0 Then
				Response.Write "<TR><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=Calibri,Charcoal,Arial>Less Payments</TD><TD ALIGN=""right""><FONT FACE=Calibri,Charcoal,Arial>" & FormatCurrency(LastTender,2) & "</TD></TR>" & vbCrLf
				Response.Write "<TR><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=Calibri,Charcoal,Arial>Balance Due</TD><TD ALIGN=""right""><FONT FACE=Calibri,Charcoal,Arial>" & FormatCurrency(LastTotal - LastTender,2) & "</TD></TR>" & vbCrLf
			End If
			Response.Write "</TABLE><BR>" & vbCrLf

	        'Footer Info
	        Response.Write "<TABLE WIDTH=""750"" >" & vbCrLf
        	Response.Write "<TR><TD COLSPAN=""3""><FONT FACE=Calibri,Charcoal,Arial>[&nbsp;&nbsp;]  ADD $1 for mailing, or provide the option for E-tickets.<br />Please note, all tickets are in Will Call unless otherwise directed as E-Tickets that you may print like a boarding pass, or as indicated add $1 for US Mail.<br /></FONT></TD></TR>" & vbCrLf
	        Response.Write "<TR><TD COLSPAN=""3""><FONT FACE=Calibri,Charcoal,Arial>I prefer to pay by:&nbsp;&nbsp;[&nbsp;&nbsp;] Check&nbsp;&nbsp;&nbsp;[&nbsp;&nbsp;] MasterCard&nbsp;&nbsp;&nbsp;[&nbsp;&nbsp;] Visa&nbsp;&nbsp;&nbsp;[&nbsp;&nbsp;] Discover<br /></FONT></TD></TR>" & vbCrLf
	        Response.Write "<TR><TD COLSPAN=""3""><FONT FACE=Calibri,Charcoal,Arial>____ ____ ____ ____ - ____ ____ ____ ____ - ____ ____ ____ ____ - ____ ____ ____ ____</FONT></TD></TR>" & vbCrLf
	        Response.Write "<TR><TD COLSPAN=""3""><FONT FACE=Calibri,Charcoal,Arial>(Card Number)</FONT></TD></TR>" & vbCrLf
        				
	        Response.Write "<TR><TD><FONT FACE=Calibri,Charcoal,Arial>______________</FONT></TD>"
	        Response.Write "<TD><FONT FACE=Calibri,Charcoal,Arial>___________________________________</FONT></TD>"
	        Response.Write "<TD><FONT FACE=Calibri,Charcoal,Arial>_____________________________________</FONT></TD></TR>"
	        Response.Write "<TR><TD><FONT FACE=Calibri,Charcoal,Arial>(Expiration Date)</FONT></TD>" & vbCrLf
	        Response.Write "<TD><FONT FACE=Calibri,Charcoal,Arial>(Name as it appears on card - please print)</FONT></TD>" & vbCrLf
	        Response.Write "<TD><FONT FACE=Calibri,Charcoal,Arial>(Signature)</FONT></TD></TR></TABLE><BR><BR>" & vbCrLf
			Response.Write "</CENTER>" & vbCrLf
			Response.Write "<div></div>" & vbCrLf
			
			LetterCount = LetterCount + 1

            If LetterCount Mod 100 = 0 Then
                Response.Flush
            End If

		End If
				
		SQLCustInfo = "SELECT Customer.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry, OrderLine.Price - OrderLine.Discount AS NetPrice FROM OrderHeader (NOLOCK) INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber WHERE OrderHeader.OrderNumber = " & rsOrderLine("OrderNumber") & " AND OrderLine.LineNumber = " & rsOrderLine("LineNumber") & " ORDER BY OrderLine.Price - OrderLine.Discount DESC"
		Set rsCustInfo = OBJdbConnection.Execute(SQLCustInfo)

		If Not rsCustInfo.EOF Then

			%>
			<!--#INCLUDE FILE="RenewalLetterInclude.asp"-->
			<%		

			Response.Write "<CENTER>" & vbCrLf
			Response.Write "<TABLE WIDTH=750><TR><TD WIDTH=""20"">&nbsp;</TD><TD WIDTH=""400""><FONT FACE=Calibri,Charcoal,Arial><B>Shipping Information</B></TD><TD WIDTH=""330""><FONT FACE=Calibri,Charcoal,Arial><B>Billing Information</B></TD></TR>"
			Response.Write "<TR><TD>&nbsp;</TD><TD><FONT FACE=Calibri,Charcoal,Arial>" & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & "<BR>" & rsCustInfo("ShipAddress1") & "<BR>" & vbCrLf
			If rsCustInfo("ShipAddress2") <> "" Then
				Response.Write rsCustInfo("ShipAddress2") & "<BR>" & vbCrLf
			End If
			Response.Write rsCustInfo("ShipCity") & ", " & rsCustInfo("ShipState") & " " & rsCustInfo("ShipPostalCode") & "</TD><TD><FONT FACE=Calibri,Charcoal,Arial>" & rsCustInfo("FirstName") & " " & rsCustInfo("LastName") & "<BR>" & rsCustInfo("Address1") & "<BR>" & vbCrLf
			If rsCustInfo("Address2")<> "" Then
				Response.Write rsCustInfo("Address2") & "<BR>" & vbCrLf
			End If
			Response.Write rsCustInfo("City") & ", " & rsCustInfo("State") & " " & rsCustInfo("PostalCode") & "</TD></TR></TABLE><BR>" & vbCrLf
			Response.Write "<HR>" & vbCrLf
			Response.Write "<BR><TABLE CELLPADDING=""3"" WIDTH=""750""><TR><TD><FONT FACE=Calibri,Charcoal,Arial><B>Order Number:&nbsp;" & rsOrderLine("OrderNumber") & "<BR>" & vbCrLf

			SQLItemNumber = "SELECT ItemNumber FROM OrderLine (NOLOCK) WHERE OrderNumber = " & rsOrderLine("OrderNumber") & " ORDER BY ItemNumber"
			Set rsItemNumber = OBJdbConnection.Execute(SQLItemNumber)
			RenewalCode = rsCustInfo("CustomerNumber") & rsItemNumber("ItemNumber")
			rsItemNumber.Close
			Set rsItemNumber = nothing
			
			Response.Write "Renewal Code:&nbsp;" & RenewalCode & "</B><BR></TD></TR></TABLE>" & vbCrLf

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
		Response.Write "<TABLE WIDTH=""750""><TR><TD><FONT FACE=Calibri,Charcoal,Arial><B>" & rsOrderLine("Act") & " at " & rsOrderLine("Venue")
		
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

		Response.Write "</B><BR>Delivery Method: " & rsOrderLine("ShipType") & "</TD></TR></TABLE>" & vbCrLf

		'Calculate Number of Columns
		SQLNumColumns = "SELECT SUM(OrderLine.Surcharge) AS ServiceFee, SUM(OrderLine.Discount) AS Discount FROM OrderLine WHERE OrderNumber = " & rsOrderLine("OrderNumber") & " AND ItemType IN ('Seat', 'SubFixedEvent')"
		Set rsNumColumns = OBJdbConnection.Execute(SQLNumColumns)

		NumColumns = 6
		ColumnHeading = "<TABLE WIDTH=""750"" BORDER=""0""><TR><TD><FONT FACE=Calibri,Charcoal,Arial><B><U>Section</U></B></TD><TD ALIGN=center><FONT FACE=Calibri,Charcoal,Arial><B><U>Row</U></B></TD><TD ALIGN=center><FONT FACE=Calibri,Charcoal,Arial><B><U>Seat</U></B></TD><TD><FONT FACE=Calibri,Charcoal,Arial><B><U>Type</U></B></TD><TD ALIGN=right><FONT FACE=Calibri,Charcoal,Arial><B><U>Price</U></B></TD>"

		FacilityCharge = 0
		If FacilityCharge <> 0 Then
			NumColumns = NumColumns + 1
			ColumnHeading = ColumnHeading + "<TD ALIGN=right><FONT FACE=Calibri,Charcoal,Arial><B><U>Facility Charge</U></B></TD>"
			ColFacilityCharge = "Y"
		End If
		If rsNumColumns("ServiceFee") <> 0 Then
			NumColumns = NumColumns + 1
			ColumnHeading = ColumnHeading + "<TD ALIGN=right><FONT FACE=Calibri,Charcoal,Arial><B><U>Service Fee</U></B></TD>"
			ColServiceFee = "Y"
		End If
		If rsNumColumns("Discount") <> 0 Then
			NumColumns = NumColumns + 1
			ColumnHeading = ColumnHeading + "<TD ALIGN=right><FONT FACE=Calibri,Charcoal,Arial><B><U>Discount</U></B></TD>"
			ColDiscount = "Y"
		End If

		rsNumColumns.Close
		Set rsNumColumns = nothing

		ColumnHeading = ColumnHeading + "<TD ALIGN=right><FONT FACE=Calibri,Charcoal,Arial><B><U>Amount</U></B></TD></TR>" & vbCrLf
		
		Response.Write ColumnHeading

		LastEventCode = rsOrderLine("EventCode")
	End If
			
	'Print the detail
	'Add the OrderNumber and LineNumber to the Form
	LineDetail = "<TR><TD><FONT FACE=Calibri,Charcoal,Arial>" & rsOrderLine("Section") & "</TD><TD ALIGN=center><FONT FACE=Calibri,Charcoal,Arial>" & rsOrderLine("Row") & "</TD><TD ALIGN=center><FONT FACE=Calibri,Charcoal,Arial>" & rsOrderLine("Seat") & "</TD><TD><FONT FACE=Calibri,Charcoal,Arial>" & rsOrderLine("SeatType") & "</TD><TD ALIGN=right><FONT FACE=Calibri,Charcoal,Arial>" & FormatCurrency(rsOrderLine("Price"),2) & "</TD>"
	
	If ColFacilityCharge = "Y" Then
		LineDetail = LineDetail & "<TD ALIGN=right><FONT FACE=Calibri,Charcoal,Arial>" & FormatCurrency(FacilityCharge,2) & "</TD>"
	End If
	If ColServiceFee = "Y" Then
		LineDetail = LineDetail & "<TD ALIGN=right><FONT FACE=Calibri,Charcoal,Arial>" & FormatCurrency(rsOrderLine("Surcharge"),2) & "</TD>"
	End If
	If ColDiscount = "Y" Then
		LineDetail = LineDetail & "<TD ALIGN=right><FONT FACE=Calibri,Charcoal,Arial>" & FormatCurrency(rsOrderLine("Discount"),2) & "</TD>"
	End If
	
	LineDetail = LineDetail & "<TD ALIGN=right><FONT FACE=Calibri,Charcoal,Arial>" & FormatCurrency(rsOrderLine("Price")+FacilityFee+rsOrderLine("Surcharge")-rsOrderLine("Discount"),2) & "</TD></TR>" & vbCrLf
	
	Response.Write LineDetail

	LastOrderNumber = rsOrderLine("OrderNumber")
	
	rsOrderLine.MoveNext
		
Loop	
	
If TicketCount > 0 Then	'Print the last footer

	Response.Write "<TR><TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf			
	If LastShipFee <> 0 And LastOrderTypeNumber <> 5 Then
		Response.Write "<TR><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=Calibri,Charcoal,Arial>Processing Fee</TD><TD ALIGN=""right""><FONT FACE=Calibri,Charcoal,Arial>" & FormatCurrency(LastShipFee,2) & "</TD></TR>" & vbCrLf
		Response.Write "<TR><TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf
	End If

	SQLTender = "SELECT SUM(Tender.Amount) AS TenderAmount FROM Tender (NOLOCK) WHERE Tender.OrderNumber = " & LastOrderNumber
	Set rsTender = OBJdbConnection.Execute(SQLTender)
	LastTender = rsTender("TenderAmount")
	rsTender.Close
	Set rsTender = nothing	

	Response.Write "<TR><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=Calibri,Charcoal,Arial>Total Order</TD><TD ALIGN=""right""><FONT FACE=Calibri,Charcoal,Arial>" & FormatCurrency(LastTotal,2) & "</TD></TR>" & vbCrLf
	If LastTender <> 0 Then
		Response.Write "<TR><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=Calibri,Charcoal,Arial>Less Payments</TD><TD ALIGN=""right""><FONT FACE=Calibri,Charcoal,Arial>" & FormatCurrency(LastTender,2) & "</TD></TR>" & vbCrLf
		Response.Write "<TR><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=Calibri,Charcoal,Arial>Balance Due</TD><TD ALIGN=""right""><FONT FACE=Calibri,Charcoal,Arial>" & FormatCurrency(LastTotal - LastTender,2) & "</TD></TR>" & vbCrLf
	End If
	Response.Write "</TABLE><BR>" & vbCrLf

	'Footer Info
	Response.Write "<TABLE WIDTH=""750"" >" & vbCrLf
	Response.Write "<TR><TD COLSPAN=""3""><FONT FACE=Calibri,Charcoal,Arial>[&nbsp;&nbsp;]  ADD $1 for mailing, or provide the option for E-tickets.<br />Please note, all tickets are in Will Call unless otherwise directed as E-Tickets that you may print like a boarding pass, or as indicated add $1 for US Mail.<br /></FONT></TD></TR>" & vbCrLf
	Response.Write "<TR><TD COLSPAN=""3""><FONT FACE=Calibri,Charcoal,Arial>I prefer to pay by:&nbsp;&nbsp;[&nbsp;&nbsp;] Check&nbsp;&nbsp;&nbsp;[&nbsp;&nbsp;] MasterCard&nbsp;&nbsp;&nbsp;[&nbsp;&nbsp;] Visa<br /></FONT></TD></TR>" & vbCrLf
	Response.Write "<TR><TD COLSPAN=""3""><FONT FACE=Calibri,Charcoal,Arial>____ ____ ____ ____ - ____ ____ ____ ____ - ____ ____ ____ ____ - ____ ____ ____ ____</FONT></TD></TR>" & vbCrLf
	Response.Write "<TR><TD COLSPAN=""3""><FONT FACE=Calibri,Charcoal,Arial>(Card Number)</FONT></TD></TR>" & vbCrLf
        				
	Response.Write "<TR><TD><FONT FACE=Calibri,Charcoal,Arial>______________</FONT></TD>"
	Response.Write "<TD><FONT FACE=Calibri,Charcoal,Arial>___________________________________</FONT></TD>"
	Response.Write "<TD><FONT FACE=Calibri,Charcoal,Arial>_____________________________________</FONT></TD></TR>"
	Response.Write "<TR><TD><FONT FACE=Calibri,Charcoal,Arial>(Expiration Date)</FONT></TD>" & vbCrLf
	Response.Write "<TD><FONT FACE=Calibri,Charcoal,Arial>(Name as it appears on card - please print)</FONT></TD>" & vbCrLf
	Response.Write "<TD><FONT FACE=Calibri,Charcoal,Arial>(Signature)</FONT></TD></TR></TABLE><BR><BR>" & vbCrLf
	Response.Write "</CENTER>" & vbCrLf
	Response.Write "<div></div>" & vbCrLf
			
End If

rsOrderLine.Close
Set rsOrderLine = nothing

%>
</FONT>
</BODY>
</HTML>

<%

End Sub 'PrintLetters

%>