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

'Organization Variables

MsgOrgName = "Rialto Cinemas"
RenewalURL = "http://rialtocinemas.tix.com/renew.aspx?np=sc"
LogoPath = "http://www.tix.com/Clients/RialtoCinemas/Renewal/RialtoCinemasLogo.jpg"
MsgFontFace = "arial,helvetica"

TemplateFileName = "Template_Letter.asp"
TemplateLocation = "\Clients\RialtoCinemas\Renewal\template\"
TemplateFilePath = Server.MapPath(TemplateLocation & TemplateFileName)

SHOWCHILD = TRUE

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
				  <a href="RenewalLetters.asp">
					Letters
				  </a>
			</li>
			<% If Session("UserNumber") = 1212 or Session("UserNumber") = 263 Then %>
			<li>	
				<a href="RenewalEmails.asp">
					Emails
				</a>
			</li>
			<% End If %>
		</ul>
		<div class="tab-content" style="padding:10px;">
			<FONT FACE="verdana,arial,helvetica" COLOR="#008400"><H3><%=MsgOrgName%><BR></FONT>
			<FONT FACE="verdana,arial,helvetica" COLOR="#008400">Subscription Renewal Letters</H3></FONT>

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

<style type="text/css" media="print">
@page  
{ 
/* set content to full width */
* { width: 100%; margin: 0; float: none;}


/* this affects the margin in the printer settings */ 
size: auto; 
margin: 0.5in 0.35in ;  

/* Avoid image breaks across pages */ 
img, table { page-break-inside: avoid; }

table {width:100%;}
} 

body  
{ 
/* this affects the margin on the content before sending to printer */ 
margin: 0px;  
} 

</style>


</HEAD>
<BODY onLoad="PrintLetters()" LEFTMARGIN="0" RIGHTMARGIN="0" TOPMARGIN="0" MARGINHEIGHT="0" MARGINWIDTH="0">

<STYLE>	
	div {page-break-before: always}
	table tbody tr td { font-family: arial,helvetica, sans-serif; color: #000000;}
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
	        Response.Write "<tr><td><FONT FACE=" & MsgFontFace & ">" & vbCrLf
			
			'-----------------------------------------
			
			'Insert HTML Template - Footer Content
			Response.Write InsertTemplate("Footer") 
			
			'-----------------------------------------
			
	        Response.Write "</FONT></td></tr></tbody></table>" & vbCrLf

			Response.Write "<div></div>" & vbCrLf
			
		End If
				
		SQLCustInfo = "SELECT Customer.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry FROM OrderHeader (NOLOCK) INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber WHERE OrderHeader.OrderNumber = " & rsOrderLine("OrderNumber") & " AND OrderLine.LineNumber = " & rsOrderLine("LineNumber")
		Set rsCustInfo = OBJdbConnection.Execute(SQLCustInfo)

		If Not rsCustInfo.EOF Then
		
			ReturnAddress = ""
		
			ReturnAddress = ReturnAddress & "<BR>" & vbCrLf
			ReturnAddress = ReturnAddress & "<TABLE WIDTH=""650"">" & vbCrLf
    		ReturnAddress = ReturnAddress & "<TR><TD>" & vbCrLf
			
			ReturnAddress = ReturnAddress & "<IMG SRC=""" & LogoPath & """><BR><BR>" & vbCrLf
			ReturnAddress = ReturnAddress & "</TD></TR>" & vbCrLf
			
			ReturnAddress = ReturnAddress & "<TR><TD>" & vbCrLf
			
			ReturnAddress = ReturnAddress & "<FONT FACE=" & MsgFontFace & ">" & PCase(rsCustInfo("ShipFirstName")) & " " & PCase(rsCustInfo("ShipLastName")) & "<BR>" & PCase(rsCustInfo("ShipAddress1")) & "<BR>" & vbCrLf
			
			If rsCustInfo("ShipAddress2") <> "" Then
				ReturnAddress = ReturnAddress & PCase(rsCustInfo("ShipAddress2")) & "<BR>" & vbCrLf
			End If
			
			ReturnAddress = ReturnAddress & PCase(rsCustInfo("ShipCity")) & ", " & rsCustInfo("ShipState") & " " & rsCustInfo("ShipPostalCode") & "</FONT>" & vbCrLf
			
			ReturnAddress = ReturnAddress & "</TD></TR>" & vbCrLf
            ReturnAddress = ReturnAddress & "</TABLE>" & vbCrLf
			
			Response.Write ReturnAddress
			
			'-----------------------------------------
			
			Response.Write"<TABLE border=""0""><TBODY>" & vbCrLf
			Response.Write"<TR><TD valign=top>" & vbCrLf
			Response.Write"<FONT FACE=" & MsgFontFace & "><BR>" & vbCrLf

			'Insert HTML Template - Body Content
			Response.Write InsertTemplate("Body") 

			Response.Write"</FONT>" & vbCrLf
			Response.Write"</TD></TR></TBODY></TABLE>" & vbCrLf
			
			'-----------------------------------------
			
			'Order Number and Renewal Number
			
			RenewalOrderNumber = rsOrderLine("OrderNumber")
			
			SQLItemNumber = "SELECT ItemNumber FROM OrderLine (NOLOCK) WHERE OrderNumber = " & rsOrderLine("OrderNumber") & " ORDER BY ItemNumber"
			Set rsItemNumber = OBJdbConnection.Execute(SQLItemNumber)
				RenewalCode = rsCustInfo("CustomerNumber") & rsItemNumber("ItemNumber")
			rsItemNumber.Close
			Set rsItemNumber = nothing
			
			OrderRenewal = ""
			OrderRenewal = OrderRenewal & "<TABLE WIDTH=""650"" cellpadding=""0"" cellspacing=""1"" border=""0"">" & vbCrLf
			OrderRenewal = OrderRenewal & "<TR>" & vbCrLf
			OrderRenewal = OrderRenewal & "<TD ALIGN=""left"">" & vbCrLf
			OrderRenewal = OrderRenewal & "<FONT FACE=""" & MsgFontFace & """><B>Order Number:</B>&nbsp;" & rsOrderLine("OrderNumber") & "</FONT>" & vbCrLf
			OrderRenewal = OrderRenewal & "</TD>" & vbCrLf
			OrderRenewal = OrderRenewal & "<TD ALIGN=""right"">" & vbCrLf		
			OrderRenewal = OrderRenewal & "<FONT FACE=""" & MsgFontFace & """><B>Renewal Code:</B>&nbsp;" & RenewalCode & "</FONT>" & vbCrLf
			OrderRenewal = OrderRenewal & "</TD>" & vbCrLf
			OrderRenewal = OrderRenewal & "</TR>" & vbCrLf
			OrderRenewal = OrderRenewal & "</TABLE>" & vbCrLf
			OrderRenewal = OrderRenewal & "<BR>" & vbCrLf
			
			Response.Write OrderRenewal
			
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
	
		Response.Write "<TABLE WIDTH=""650"" cellpadding=""0"" cellspacing=""0""  border=""0"">" & vbCrLf
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
		
			'Child Events
			
			If SHOWCHILD Then
			
				ChildEvents = ""

				SQLEventChild = "SELECT SubscriptionEvent.EventCode, Event.EventDate, Act.Act FROM SubscriptionEvent (NOLOCK) INNER JOIN Event (NOLOCK) ON SubscriptionEvent.EventCode = Event.EventCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode WHERE SubscriptionEvent.SubscriptionNumber = " & rsOrderLine("EventCode") & ""
				Set rsEventChild = OBJdbConnection.Execute(SQLEventChild)
				
				If Not rsEventChild.EOF Then
					
					linecount = 1

					ChildEvents = ChildEvents & "<TABLE WIDTH=""650"" cellpadding=""0"" cellspacing=""0"" border=""0"">" & vbCrLf
					ChildEvents = ChildEvents & "<TR>" & vbCrLf
					ChildEvents = ChildEvents & "<TD colspan=""2"">" & vbCrLf
					ChildEvents = ChildEvents & "<FONT FACE=" & MsgFontFace & "><B>This subscription includes:</B></FONT>" & vbCrLf
					ChildEvents = ChildEvents & "</td>" & vbCrLf
					ChildEvents = ChildEvents & "</tr>" & vbCrLf
				
						Do While Not rsEventChild.EOF

							ChildEvents = ChildEvents & "<tr>" & vbCrLf	
							ChildEvents = ChildEvents & "<td>" & vbCrLf
							ChildEvents = ChildEvents & "<FONT FACE=" & MsgFontFace & ">" & rsEventChild("Act") & "</FONT>" & vbCrLf	
							ChildEvents = ChildEvents & "</td>" & vbCrLf	
							ChildEvents = ChildEvents & "<td NOWRAP>" & vbCrLf
							ChildEvents = ChildEvents & "<FONT FACE=" & MsgFontFace & ">" & FormatDateTime(rsEventChild("EventDate"), vbLongDate) & " at " & Left(FormatDateTime(rsEventChild("EventDate"),vbLongTime),Len(FormatDateTime(rsEventChild("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsEventChild("EventDate"),vbLongTime),3) & "</FONT>" & vbCrLf
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
				
				Response.Write ChildEvents
			
			End If
		
		'-----------------------------------------
							
		'Seat Location, Price, Service Fee

		'Calculate Number of Columns
		SQLNumColumns = "SELECT SUM(OrderLine.Surcharge) AS ServiceFee, SUM(OrderLine.Discount) AS Discount FROM OrderLine WHERE OrderNumber = " & rsOrderLine("OrderNumber") & " AND ItemType IN ('Seat', 'SubFixedEvent')"
		Set rsNumColumns = OBJdbConnection.Execute(SQLNumColumns)

		NumColumns = 6
		ColumnHeading = "<TABLE WIDTH=""650"" cellpadding=""0"" cellspacing=""0"" border=""0""><TR><TD><FONT FACE=""" & MsgFontFace & """><B><U>Section</U></B></TD><TD ALIGN=center><FONT FACE=""" & MsgFontFace & """><B><U>Row</U></B></TD><TD ALIGN=center><FONT FACE=""" & MsgFontFace & """><B><U>Seat</U></B></TD><TD><FONT FACE=""" & MsgFontFace & """><B><U>Type</U></B></TD><TD ALIGN=right><FONT FACE=""" & MsgFontFace & """><B><U>Price</U></B></TD>"

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
		
		Response.Write "<div></div>"
		
		Response.Write "</CENTER>" & vbCrLf
				
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

PUBLIC FUNCTION InsertTemplate(templateName)

'DIM templateFileName
'templateFileName = "\Clients\RialtoCinemas\Renewal\template\LetterInclude.asp"

Dim  strText
strText = ""

Dim strNewText
strNewText = ""

	Const ForReading = 1

	Set objFSO = CreateObject("Scripting.FileSystemObject")
	
	'templatePath = Server.MapPath(templateFileName)

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

		strNewText = Replace(strText, 	 "[FirstName]", CustomerFName)
		strNewText = Replace(strNewText, "[webSite]", webSite)
		strNewText = Replace(strNewText, "[orgNumber]", orgNumber)
		strNewText = Replace(strNewText, "[senderFName]", senderFName)
		strNewText = Replace(strNewText, "[senderLName]", senderLName)
		strNewText = Replace(strNewText, "[senderAddress]", senderAddress)
		strNewText = Replace(strNewText, "[OrgName]", fnOrgName)
		strNewText = Replace(strNewText, "[RenewalURL]", RenewalURL)
		strNewText = Replace(strNewText, "[ServerName]",Request.ServerVariables("server_name"))
		
		replaceVar = strNewText
		
END FUNCTION 

'--------------------------------------------------------------------

%>


