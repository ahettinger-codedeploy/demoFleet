<% 

'CHANGE LOG
'SLM 2/26/13 - New for 2013
'SLM 3/1/13 - Shifted Logo
'SLM 8/9/13 - New NT Live

%>

<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp"-->
<!--#INCLUDE VIRTUAL="TicketPrintInclude.asp"-->
<!--#INCLUDE VIRTUAL="NoCacheInclude.asp"-->

<%

'JAI 6/24/9 - Specify organization ReplyTo e-mail address and the e-mail subject
LetterOrganization1 = "<B>Rialto Cinemas Elmwood</B>"
'LetterOrganization2 = "Elmwood"
LetterOrganization = LetterOrganization1 & " " & LetterOrganization2
ChangeSeatURL = "http://www.rialtocinemas.com/elmwood"
TagLine = "<I>Berkeley's Best Neighborhood Movie Theatre</I>"

LetterOrgNumber = "1691"
LetterRenewalURL = "http://RialtoCinemasElmwood.tix.com/renew.aspx?np=sc"
LetterLogoPath = "http://www.tix.com/Clients/RialtoCinemasElmwood/Renewal/Elmwoodlogo.jpg"
LetterFontFace = "arial,helvetica"



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
<HEAD>
<TITLE>Tix - Subscription Renewal Letters</TITLE>
<link href="https://netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.min.css" rel="stylesheet">
<link href="https://netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap.min.css" rel="stylesheet">
<style>
div.TixManagementContent  a { text-decoration: none; outline: medium none;}div.TixManagementContent table.table tbody tr th { background-color: rgb(102, 102, 102); color: #ffffff; }.nav-tabs { border-bottom: 0px;}.nav-tabs > li > a { border-width: 2px; border-radius: 4px; border-color: #DDDDDD; #DDDDDD; #DDDDDD; background-color: #EEEEEE; color: #888888; } nav.nav-tabs > li > a:hover, nav.nav-tabs > li > a:focus, .nav .open > a, .nav .open > a:hover, .nav .open > a:focus { border-color: #DDDDDD; #DDDDDD; #DDDDDD; background-color: #EEEEEE; color: #555555; } .dropdown-menu > li > a:hover, .dropdown-menu > li > a:focus { background-color: #ffffff; color: #262626; text-decoration: none; } .nav-tabs > li.active > a { color: #000000; } .tab-content { border: 2px solid #DDDDDD; border-radius: 4px padding:20px; }  
</style>
</HEAD>
<BODY BGCOLOR="#FFFFFF">

<CENTER>

<!--#INCLUDE VIRTUAL="TopNavInclude.asp"-->
<BR>
<BR>

	<div class="tabs">

		<ul class="nav nav-tabs">
			<li class="active">	
				  <a href="#" class="dropdown-toggle" data-toggle="dropdown" id="dropdownMenu1">
					Letters&nbsp;<span style="color: #000000;" class="caret"></span>
				  </a>
				  <ul class="dropdown-menu" role="menu">
					<li role="presentation"><a role="menuitem" tabindex="-1" href="/Clients/RialtoCinemasCerrito/Renewal/RenewalLetters.asp">Rialto Cinemas&#174;&nbsp;Cerrito</a></li>
					<li role="presentation"><a role="menuitem" tabindex="-1" href="/Clients/RialtoCinemasElmwood/Renewal/RenewalLetters.asp">Rialto Cinemas&#174;&nbsp;Elmwood</a></li>
				  </ul>
			</li>
			<% If Session("UserNumber") = 1212 or Session("UserNumber") = 263 Then %>
			<li>	
				<a href="#" class="dropdown-toggle" data-toggle="dropdown" id="dropdownMenu1">
					Emails&nbsp;<span style="color: #777777;" class="caret"></span>
				</a>
				<ul class="dropdown-menu" role="menu">
					<li role="presentation"><a role="menuitem" tabindex="-1" href="/Clients/RialtoCinemasCerrito/Renewal/RenewalEMail.asp">Rialto Cinemas&#174;&nbsp;Cerrito</a></li>
					<li role="presentation"><a role="menuitem" tabindex="-1" href="/Clients/RialtoCinemasElmwood/Renewal/RenewalEMail.asp">Rialto Cinemas&#174;&nbsp;Elmwood</a></li>
				</ul>

				
			</li>
			<% End If %>
		</ul>
		<div class="tab-content" style="padding:10px;">
		
			<FONT FACE="verdana,arial,helvetica" COLOR="#008400"><H3>Subscription Renewal Letters</H3></FONT>

				<%

				'Get Matching Events
				'REE 4/6/2 - Modified to include OrganizationAct selection criteria
				'REE 2/25/3 - Removed TicketFormat from criteria.
				SQLEvents = "SELECT Event.EventCode FROM Event (NOLOCK) INNER JOIN Venue ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber WHERE Organization.OrganizationNumber = " & LetterOrgNumber & " AND EventDate > GETDATE() ORDER BY EventDate"
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

						Response.Write "<TABLE class=""table table-striped table-bordered"">" & vbCrLf
						Response.Write "<TR><TH ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2""><B>Print</B></FONT></TH><TH ALIGN=""center""><FONT FACE=""verdana,arial,helvetica""  SIZE=""2""><B>Subscription</B></FONT></TH><TH ALIGN=""center""><FONT FACE=""verdana,arial,helvetica""  SIZE=""2""><B>Venue</B></FONT></TH><TH ALIGN=""center""><FONT FACE=""verdana,arial,helvetica""  SIZE=""2""><B>Date/Time</B></FONT></TH><TH ALIGN=""center""><FONT FACE=""verdana,arial,helvetica""  SIZE=""2""><B>Quantity</B></FONT></TH></TR>" & vbCrLf

						'Display Event and UnPrinted Ticket Quantities
						Do Until rsTickets.EOF

							Response.Write "<TR BGCOLOR=""DDDDDD""><TD ALIGN=""center""><INPUT TYPE=""checkbox"" NAME=""EventCode"" VALUE=" & rsTickets("EventCode") & "></FONT></TD><TD><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">" & rsTickets("Act") & "</FONT></TD><TD><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">" & rsTickets("Venue") & "</FONT></TD><TD ALIGN=""center"" NOWRAP><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">" & DateAndTimeFormat(rsTickets("EventDate")) & "</FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">" & rsTickets("TicketCount") & "</FONT></TD></TR>" & vbCrLf

							rsTickets.MoveNext

						Loop
							
						Response.Write "</TABLE><BR>" & vbCrLf
						'Display Buttons to Print
						Response.Write "<FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">Select Events to print and click 'Print' below.</FONT><BR><BR>" & vbCrLf
						Response.Write "<INPUT TYPE=""submit"" VALUE=""Print""></FORM>" & vbCrLf
					Else 'There aren't any matching events
						Response.Write "<BR><BR><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">There are no events to be printed.</FONT><BR><BR>" & vbCrLf
					End If
				Else 'There aren't any matching events
					Response.Write "<BR><BR><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">There are no events to be printed.</FONT><BR><BR>" & vbCrLf
				End If
				%>
		
			
		</div>

	</div>
	
</CENTER>

</BODY>
<!--#INCLUDE VIRTUAL="FooterInclude.asp"-->
<script src="https://netdna.bootstrapcdn.com/bootstrap/3.1.0/js/bootstrap.min.js"></script>
<script>(function(e,t,n){var r=e();e.fn.dropdownHover=function(n){if("ontouchstart"in document)return this;r=r.add(this.parent());return this.each(function(){var i=e(this),s=i.parent(),o={delay:500,instantlyCloseOthers:!0},u={delay:e(this).data("delay"),instantlyCloseOthers:e(this).data("close-others")},a="show.bs.dropdown",f="hide.bs.dropdown",l=e.extend(!0,{},o,n,u),c;s.hover(function(e){if(!s.hasClass("open")&&!i.is(e.target))return!0;l.instantlyCloseOthers===!0&&r.removeClass("open");t.clearTimeout(c);s.addClass("open");i.trigger(a)},function(){c=t.setTimeout(function(){s.removeClass("open");i.trigger(f)},l.delay)});i.hover(function(){l.instantlyCloseOthers===!0&&r.removeClass("open");t.clearTimeout(c);s.addClass("open");i.trigger(a)});s.find(".dropdown-submenu").each(function(){var n=e(this),r;n.hover(function(){t.clearTimeout(r);n.children(".dropdown-menu").show();n.siblings().children(".dropdown-menu").hide()},function(){var e=n.children(".dropdown-menu");r=t.setTimeout(function(){e.hide()},l.delay)})})})};e(document).ready(function(){e('[data-hover="dropdown"]').dropdownHover()})})(jQuery,this); </script>
<script>
$(document).ready(function() {
  $('.js-activated').dropdownHover().dropdown();
});
</script>
</HTML>

<%

End Sub 'PrintMenu

'---------------------------------

Sub PrintLetters

'Server.ScriptTimeout = 600

%>

<HTML>
<HEAD>
<TITLE>Tix - Subscription Renewal Letters</TITLE>
<SCRIPT LANGUAGE="JavaScript">
<!--    Begin
    function PrintLetters() {
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
		
	        Response.Write "</TABLE>" & vbCrLf
	        Response.Write "</CENTER><BR>" & vbCrLf
			
	        Response.Write "<table border=""0""><tbody>" & vbCrLf
	        Response.Write "<tr><td><FONT FACE=" & LetterFontFace & ">" & vbCrLf
			
            %>
            <!--#INCLUDE FILE="RenewalLetterInclude2.asp"-->
            <%	
			Response.Write RenewalHeader
            %>
            <!--#INCLUDE FILE="RenewalLetterInclude3.asp"-->
            <%	

	        Response.Write "</FONT></td></tr></tbody></table>" & vbCrLf


			Response.Write "<div></div>" & vbCrLf
			
		End If
				
		SQLCustInfo = "SELECT Customer.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry FROM OrderHeader (NOLOCK) INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber WHERE OrderHeader.OrderNumber = " & rsOrderLine("OrderNumber") & " AND OrderLine.LineNumber = " & rsOrderLine("LineNumber")
		Set rsCustInfo = OBJdbConnection.Execute(SQLCustInfo)

		If Not rsCustInfo.EOF Then
		
			Response.Write "<BR>" & vbCrLf
			Response.Write "<TABLE WIDTH=750>" & vbCrLf
    		Response.Write "<TR><TD>" & vbCrLf
			Response.Write "<FONT FACE=" & LetterFontFace & "><IMG SRC="" " & LetterLogoPath & " ""><BR><BR>" & vbCrLf
			Response.Write "</TD><TR>" & vbCrLf
			
			Response.Write "<TR><TD WIDTH=300>" & vbCrLf
			
			'Return Address
			Response.Write "<FONT FACE=" & LetterFontFace & ">" & PCase(rsCustInfo("ShipFirstName")) & " " & PCase(rsCustInfo("ShipLastName")) & "<BR>" & PCase(rsCustInfo("ShipAddress1")) & "<BR>" & vbCrLf
			
			If rsCustInfo("ShipAddress2") <> "" Then
				Response.Write PCase(rsCustInfo("ShipAddress2")) & "<BR>" & vbCrLf
			End If
			
			Response.Write PCase(rsCustInfo("ShipCity")) & ", " & rsCustInfo("ShipState") & " " & rsCustInfo("ShipPostalCode") & "</FONT>" & vbCrLf
			
			Response.Write"</TD></TR>" & vbCrLf
            Response.Write "</TABLE>" & vbCrLf
			
			Response.Write"<TABLE border=""0""><TBODY>" & vbCrLf
			Response.Write"<TR><TD valign=top>" & vbCrLf
			Response.Write"<FONT FACE=" & LetterFontFace & ">" & vbCrLf

            %>
            <!--#INCLUDE FILE="RenewalLetterInclude1.asp"-->
            <%		

			Response.Write"</FONT>" & vbCrLf
			Response.Write"</TD></TR></TBODY></TABLE><BR>" & vbCrLf
						
			SQLItemNumber = "SELECT ItemNumber FROM OrderLine (NOLOCK) WHERE OrderNumber = " & rsOrderLine("OrderNumber") & " ORDER BY ItemNumber"
			Set rsItemNumber = OBJdbConnection.Execute(SQLItemNumber)
			
			RenewalCode = rsCustInfo("CustomerNumber") & rsItemNumber("ItemNumber")
			
			rsItemNumber.Close
			Set rsItemNumber = nothing
			
			Response.Write "<TABLE WIDTH=""650"" BORDER=0>" & vbCrLf
			Response.Write "<TR><TD WIDTH=""20"">" & vbCrLf
			
			Response.Write "<FONT FACE=" & LetterFontFace & ">&nbsp;</FONT>" & vbCrLf
			
			Response.Write "</TD><TD>" & vbCrLf
			Response.Write "<FONT FACE=" & LetterFontFace & "><B>Order Number:&nbsp;" & rsOrderLine("OrderNumber") & "<BR>Renewal Code:&nbsp;" & RenewalCode & "</B></FONT>" & vbCrLf
			Response.Write "</TD></TR></TABLE>" & vbCrLf

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
		Response.Write "<TABLE WIDTH=""650"" BORDER=0><TR><TD WIDTH=""20""><FONT FACE=" & LetterFontFace & ">&nbsp;</FONT></TD><TD><FONT FACE=" & LetterFontFace & "><B>" & rsOrderLine("Act") & " at " & rsOrderLine("Venue")
		
		'REE 6/5/6 - Modified to look at EventOptions for Date & Time Display Options
		SQLDateSuppress = "SELECT OptionValue AS DateSuppress FROM EventOptions (NOLOCK) WHERE EventCode = " & rsOrderLine("EventCode") & " AND OptionName = 'DateSuppress' AND OptionValue = 'Y'"
		Set rsDateSuppress = OBJdbConnection.Execute(SQLDateSuppress)
		If rsDateSuppress.EOF Then
			Response.Write " on " & FormatDateTime(rsOrderLine("EventDate"),vbLongDate)
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

		Response.Write "</B><BR>Delivery Method: " & rsOrderLine("ShipType") & "</FONT></TD></TR></TABLE>" & vbCrLf

		'Calculate Number of Columns
		SQLNumColumns = "SELECT SUM(OrderLine.Surcharge) AS ServiceFee, SUM(OrderLine.Discount) AS Discount FROM OrderLine WHERE OrderNumber = " & rsOrderLine("OrderNumber") & " AND ItemType IN ('Seat', 'SubFixedEvent')"
		Set rsNumColumns = OBJdbConnection.Execute(SQLNumColumns)

		NumColumns = 6
		ColumnHeading = "<TABLE WIDTH=""650"" BORDER=0><TR><TD WIDTH=""20""><FONT FACE=" & LetterFontFace & ">&nbsp;</FONT></TD><TD><FONT FACE=" & LetterFontFace & "><B><U>Section</U></B></FONT></TD><TD ALIGN=center><FONT FACE=" & LetterFontFace & "><B><U>Row</U></B></FONT></TD><TD ALIGN=center><FONT FACE=" & LetterFontFace & "><B><U>Seat</U></B></FONT></TD><TD><FONT FACE=" & LetterFontFace & "><B><U>Type</U></B></FONT></TD><TD ALIGN=right><FONT FACE=" & LetterFontFace & "><B><U>Price</U></B></FONT></TD>"

		FacilityCharge = 0
		If FacilityCharge <> 0 Then
			NumColumns = NumColumns + 1
			ColumnHeading = ColumnHeading + "<TD ALIGN=right><FONT FACE=" & LetterFontFace & "><B><U>Facility Charge</U></B></FONT></TD>"
			ColFacilityCharge = "Y"
		End If
		If rsNumColumns("ServiceFee") <> 0 Then
			NumColumns = NumColumns + 1
			ColumnHeading = ColumnHeading + "<TD ALIGN=right><FONT FACE=" & LetterFontFace & "><B><U>Service Fee</U></B></FONT></TD>"
			ColServiceFee = "Y"
		End If
		If rsNumColumns("Discount") <> 0 Then
			NumColumns = NumColumns + 1
			ColumnHeading = ColumnHeading + "<TD ALIGN=right><FONT FACE=" & LetterFontFace & "><B><U>Discount</U></B></FONT></TD>"
			ColDiscount = "Y"
		End If

		rsNumColumns.Close
		Set rsNumColumns = nothing

		ColumnHeading = ColumnHeading + "<TD ALIGN=right><FONT FACE=" & LetterFontFace & "><B><U>Amount</U></B></FONT></TD></TR>" & vbCrLf
		
		Response.Write ColumnHeading

		LastEventCode = rsOrderLine("EventCode")
	End If
			
	'Print the detail
	'Add the OrderNumber and LineNumber to the Form
	LineDetail = "<TR><TD WIDTH=""20""><FONT FACE=" & LetterFontFace & ">&nbsp;</FONT></TD><TD><FONT FACE=" & LetterFontFace & ">" & rsOrderLine("Section") & "</FONT></TD><TD ALIGN=center><FONT FACE=" & LetterFontFace & ">" & rsOrderLine("Row") & "</FONT></TD><TD ALIGN=center><FONT FACE=" & LetterFontFace & ">" & rsOrderLine("Seat") & "</FONT></TD><TD><FONT FACE=" & LetterFontFace & ">" & rsOrderLine("SeatType") & "</FONT></TD><TD ALIGN=right><FONT FACE=" & LetterFontFace & ">" & FormatCurrency(rsOrderLine("Price"),2) & "</FONT></TD>"
	
	If ColFacilityCharge = "Y" Then
		LineDetail = LineDetail & "<TD ALIGN=right><FONT FACE=" & LetterFontFace & ">" & FormatCurrency(FacilityCharge,2) & "</FONT></TD>"
	End If
	If ColServiceFee = "Y" Then
		LineDetail = LineDetail & "<TD ALIGN=right><FONT FACE=" & LetterFontFace & ">" & FormatCurrency(rsOrderLine("Surcharge"),2) & "</FONT></TD>"
	End If
	If ColDiscount = "Y" Then
		LineDetail = LineDetail & "<TD ALIGN=right><FONT FACE=" & LetterFontFace & ">" & FormatCurrency(rsOrderLine("Discount"),2) & "</FONT></TD>"
	End If
	
	LineDetail = LineDetail & "<TD ALIGN=right><FONT FACE=" & LetterFontFace & ">" & FormatCurrency(rsOrderLine("Price")+FacilityFee+rsOrderLine("Surcharge")-rsOrderLine("Discount"),2) & "</FONT></TD></TR>" & vbCrLf
	
	Response.Write LineDetail

	LastOrderNumber = rsOrderLine("OrderNumber")
	
	rsOrderLine.MoveNext
		
Loop	
	
If TicketCount > 0 Then	'Print the last footer

	Response.Write "</TABLE>" & vbCrLf
	Response.Write "</CENTER><BR>" & vbCrLf
	
	Response.Write "<table border=""0""><tbody>" & vbCrLf
	Response.Write "<tr><td><FONT FACE=" & LetterFontFace & ">" & vbCrLf


	%>
	<!--#INCLUDE FILE="RenewalLetterInclude2.asp"-->
	<%	
		
	%>
	<!--#INCLUDE FILE="RenewalLetterInclude3.asp"-->
	<%	
	
	 Response.Write "</FONT></TD></TR></TBODY></TABLE>" & vbCrLf
	 Response.Write "<div></div>" & vbCrLf

End If

rsOrderLine.Close
Set rsOrderLine = nothing

Call DBClose(OBJdbConnection2)

%>
</FONT>
</BODY>
</HTML>

<%

End Sub 'PrintLetters


'-----------------------------

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

'-----------------------------

%>