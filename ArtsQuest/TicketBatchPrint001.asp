<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp"-->
<!--#INCLUDE VIRTUAL="TicketPrintInclude.asp"-->
<!--#INCLUDE VIRTUAL="NoCacheInclude.asp"-->
<%

Server.ScriptTimeout = 1200 '20 Minutes

'REE 4/15/2 - Increased Session Timeout to 60 minutes to reduce Print validation timeout issues.
Session.Timeout = 60

Page = "TicketBatchPrint"

'Make sure the correct Session variables are in place.  If not clear the variables and go to the menu.
If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then 
	Response.Write "No OrganizationNumber<BR>"
	Session.Abandon
'	Response.Redirect("Default.asp")
End If

If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then 
	Session.Abandon
	'Response.Redirect("Default.asp")
	Response.Write "No UserNumber<BR>"
End If

'Decide which subroutine to route to
Select Case Request("FormName")
	Case "PrintMenu"
		Call PrintEvent
	Case "PrintEvent"
		Call DisplayTickets
	Case "OKPrint"
		Call UpdatePrintDate
	Case Else
		Call PrintMenu
End Select

'----------------------------------

Sub PrintMenu

%>
<HTML>
<HEAD>
<TITLE>www.TIX.com - Batch Ticket Printing</TITLE>
</HEAD>
<BODY BGCOLOR="#FFFFFF">

<CENTER>

<!--#INCLUDE VIRTUAL="TopNavInclude.asp"-->
<BR>

<BR>

<FONT FACE="verdana,arial,helvetica" COLOR="#008400"><H3>Batch Ticket Printing</H3></FONT>


<%

If Session("OrganizationNumber") = 1 Then
	 TixFulfillment = " AND TixFulfillment = 1 "
Else
	TixFulfillment = ""
End If

'Get Matching Events
'REE 4/6/2 - Modified to include OrganizationAct selection criteria
SQLEvents = "SELECT Event.EventCode FROM Event (NOLOCK) INNER JOIN Venue ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber WHERE EventDate > GETDATE()-31 AND Owner = 1  AND Organization.TicketPrintFormat IS NOT NULL" & TixFulfillment & " ORDER BY EventDate"
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
	SQLTickets = "SELECT COUNT(OrderLine.ItemNumber) AS TicketCount, Act.Act, EventDate, Event.EventCode, Venue, Orderline.ShipCode, ShipType FROM Event (NOLOCK) INNER JOIN Seat ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Shipping ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN Act ON Event.ActCode = Act.ActCode INNER JOIN Venue ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber INNER JOIN OrganizationAct ON Event.ActCode = OrganizationAct.ActCode WHERE Event.EventCode IN " & EventList & " AND EventDate > GETDATE()-31 AND OrderLine.StatusCode = 'S' AND OrderLine.PrintDate IS NULL AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND Organization.TicketPrintFormat IS NOT NULL AND OrderLine.ItemType = 'Seat' GROUP BY ShipType, OrderLine.ShipCode, Event.EventCode, EventDate, Act.Act, Venue.Venue ORDER BY ShipType, OrderLine.ShipCode, EventDate"
	Set rsTickets = OBJdbConnection.Execute(SQLTickets)
	
	'REE 4/6/2 - Modified to check for events.
	If Not rsTickets.EOF Then 'There are some events.  List them
		Response.Write "<FORM ACTION=""TicketBatchPrint.asp"" METHOD=""post""><INPUT TYPE=""hidden"" NAME=""FormName"" VALUE=""PrintMenu"">" & vbCrLf

		ShipCode = rsTickets("ShipCode")
		Response.Write "<TABLE CELLPADDING=""3""><TR BGCOLOR=""#008400""><TD ALIGN=""left"" COLSPAN=""5""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>" & rsTickets("ShipType") & "</B></FONT></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=""#666666""><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Print</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Event</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Venue</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Date/Time</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>UnPrinted Tickets</B></FONT></TD></TR>" & vbCrLf

		'Display Event and UnPrinted Ticket Quantities
		Do Until rsTickets.EOF
			If rsTickets("ShipCode") <> ShipCode Then
				ShipCode = rsTickets("ShipCode")
				Response.Write "<TR BGCOLOR=""#FFFFFF""><TD COLSPAN=""5"">&nbsp;</TD></TR>" & vbCrLf
				Response.Write "<TR BGCOLOR=""#008400""><TD ALIGN=""left"" COLSPAN=""5""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>" & rsTickets("ShipType") & "</B></FONT></TD></TR>" & vbCrLf
				Response.Write "<TR BGCOLOR=""666666""><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Print</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Event</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Venue</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Date/Time</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>UnPrinted Tickets</B></FONT></TD></TR>" & vbCrLf
			End If
			ShipPad = "0000" & rsTickets("ShipCode")
			ShipPad = right(ShipPad,4)
			CheckboxValue = ShipPad & rsTickets("EventCode")

			Response.Write "<TR BGCOLOR=""DDDDDD""><TD ALIGN=""center""><INPUT TYPE=""checkbox"" NAME=""ShipEvent"" VALUE=" & CheckboxValue & "></FONT></TD><TD><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">" & rsTickets("Act") & "</FONT></TD><TD><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">" & rsTickets("Venue") & "</FONT></TD><TD ALIGN=""center"" NOWRAP><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">" & DateAndTimeFormat(rsTickets("EventDate")) & "</FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">" & rsTickets("TicketCount") & "</FONT></TD></TR>" & vbCrLf

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

</CENTER>

<!--#INCLUDE VIRTUAL="FooterInclude.asp"-->

</BODY>
</HTML>

<%

End Sub 'PrintMenu

'---------------------------------

Sub PrintEvent

'Server.ScriptTimeout = 600

'Set the Print Date and Time
PrintDate = Now()

%>

<HTML>
<HEAD>
<TITLE>www.TIX.com - Batch Ticket Printing</TITLE>
<SCRIPT LANGUAGE="JavaScript">
<!-- Begin
	function PrintTickets(){
		window.print();
		TicketPrintForm.submit();
		}

//  End -->
</SCRIPT>
</HEAD>
<BODY onLoad="PrintTickets()">

<CENTER>
<TABLE WIDTH="600">
  <TR>
    <TD><FONT SIZE="1" COLOR="#FFFFFF">
		<PRE>
		<%

		Response.Write "<FORM ACTION=""TicketBatchPrint.asp"" METHOD=""post"" NAME=""TicketPrintForm""><INPUT TYPE=""hidden"" NAME=""FormName"" VALUE=""PrintEvent"">" & vbCrLf

		'Build the Query to select each of the selected events
		'REE 4/6/2 - Modified to use OrganizationAct in selection criteria
		SQLTickets = "SELECT OrderLine.OrderNumber, OrderLine.LineNumber, Event.EventCode, PrintFormat.Format FROM OrderLine INNER JOIN Seat ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct ON Event.ActCode = OrganizationAct.ActCode INNER JOIN EventOptions ON Event.EventCode = EventOptions.EventCode INNER JOIN PrintFormat ON EventOptions.OptionValue = PrintFormat.FormatNumber"
		For Each Item In Request("ShipEvent") 'Loop for each Event requested
			EventNumber = EventNumber + 1
			If SQLWhere = "" Then 
				SQLWhere = " WHERE ((Event.EventCode = " & right(Request("ShipEvent")(EventNumber),len(Request("ShipEvent")(EventNumber))-4) & "AND ShipCode = " & left(Request("ShipEvent")(EventNumber),4) & ") "
			Else
				SQLWhere = SQLWhere & "OR (Event.EventCode = " & right(Request("ShipEvent")(EventNumber),len(Request("ShipEvent")(EventNumber))-4) & "AND ShipCode = " & left(Request("ShipEvent")(EventNumber),4) & ") "
			End If
		Next

		'Get the Info to Print
		'REE 4/6/2 - Modified to use OrganizationAct in selection criteria
		SQLTickets = SQLTickets & SQLWhere & ") AND OrderLine.StatusCode = 'S' AND OrderLine.PrintDate IS NULL AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderLine.ItemType = 'Seat'  AND EventOptions.OptionName = 'TicketFormatNumber' AND OrderLine.OrderNumber <= 77360 ORDER BY OrderLine.OrderNumber, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry, OrderLine.ShipCode, Seat.EventCode, Seat.SectionCode, RowSort, SeatSort DESC"
		Set rsTickets = OBJdbConnection.Execute(SQLTickets)
				
		LastOrderNumber = 0
		NumberOfOrders = 0

		Do Until rsTickets.EOF

			If LastOrderNumber <> rsTickets("OrderNumber") Then
				'It's not the first order.  Cut the tickets
				If NumberOfOrders > 0 Then 
					Response.Write "     &lt;p&gt;<BR>"
				End If
							
				'Get the Printing Formats for this Organization
				SQLAddressFormat = "SELECT Format As AddressFormat FROM Event (NOLOCK) INNER JOIN Venue ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue ON Venue.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber INNER JOIN PrintFormat ON Organization.AddressPrintFormat = PrintFormat.FormatNumber WHERE EventCode = " & rsTickets("EventCode") & " AND Owner = 1"
				Set rsAddressFormat = OBJdbConnection.Execute(SQLAddressFormat)

				If Not rsAddressFormat.EOF Then 'There's an address format.  Print the address ticket
					Response.Write FormatTicket(rsTickets("OrderNumber"), rsTickets("LineNumber"), rsAddressFormat("AddressFormat")) & "     &lt;q&gt;<BR>"
				End If

				NumberOfOrders = NumberOfOrders + 1
				LastOrderNumber = rsTickets("OrderNumber")
					
			Else 'Feed
				Response.Write "     &lt;q&gt;<BR>"
			End If
						
			'Add the OrderNumber and LineNumber to the Form
			Response.Write "<INPUT TYPE=""hidden"" NAME=""OrderNumber"" VALUE=" & rsTickets("OrderNumber") & "><INPUT TYPE=""hidden"" NAME=""LineNumber"" VALUE=" & rsTickets("LineNumber") & ">" & vbCrLf
						

			'Print the ticket			
			Response.Write FormatTicket(rsTickets("OrderNumber"), rsTickets("LineNumber"), rsTickets("Format"))
						
			TicketCount = TicketCount + 1
						
			rsTickets.MoveNext

		Loop	
			
		'Cut off the last ticket
		Response.Write "     &lt;p&gt;<BR>" & vbCrLf


		Response.Write "</FORM>"

		rsAddressFormat.Close
		Set rsAddressFormat = nothing

		rsTickets.Close
		Set rsTickets = nothing

		%>
		</PRE>
		</FONT>
   </TD>
  </TR>
</TABLE>
</CENTER>
</BODY>
</HTML>

<%

End Sub 'PrintEvent

'----------------------------

Sub DisplayTickets

%>
<HTML>
<HEAD>
<TITLE>www.TIX.com - Batch Ticket Printing</TITLE>
<SCRIPT LANGUAGE="JavaScript">    

<!-- Hide code from non-js browsers
	function loadForm() {
		formObj = document.OKPrint;
		formObj.Button.focus();
	}
// end hiding -->
</SCRIPT>

</HEAD>
<BODY onLoad="loadForm()">
<CENTER>

<!--#INCLUDE VIRTUAL="TopNavInclude.asp"-->

<FORM ACTION="TicketBatchPrint.asp" METHOD="post" NAME="OKPrint"><INPUT TYPE="hidden" NAME="FormName" VALUE="OKPrint">
<TABLE CELLPADDING="5">
<%

'Get Each Order Number from the previous form
For Each Item In Request("OrderNumber")
	
	'This sets the position of the Request("OrderNumber") and Request("LineNumber") arrays
	ArrayPos = ArrayPos + 1
	OrderNumber = Request("OrderNumber")(ArrayPos)
	LineNumber = Request("LineNumber")(ArrayPos)

	'Get Ticket Header Info
'	SQLTicketHeader = "SELECT * FROM OrderLine INNER JOIN Seat ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode WHERE OrderLine.OrderNumber = " & OrderNumber & " ORDER BY OrderLine.OrderNumber, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry, OrderLine.ShipCode"
	'REE 4/6/2 - Modified to use OrganizationAct in selection criteria
	SQLTicket = "SELECT * FROM OrderLine INNER JOIN OrderHeader ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event ON Seat.EventCode = Event.EventCode INNER JOIN Venue ON Event.VenueCode = Venue.VenueCode INNER JOIN Act ON Event.ActCode = Act.ActCode INNER JOIN Shipping ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN SeatType ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct ON Event.ActCode = OrganizationAct.ActCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrderLine.LineNumber = " & LineNumber & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderLine.ItemType = 'Seat' ORDER BY Seat.EventCode, Seat.SectionCode, RowSort, SeatSort DESC"
	Set rsTicket = OBJdbConnection.Execute(SQLTicket)

	Do Until rsTicket.EOF
		'Check to see if we've printed a header exactly like this already
		NewAddress = rsTicket("OrderNumber") & rsTicket("ShipFirstName") & rsTicket("ShipLastName") & rsTicket("ShipAddress1") & rsTicket("ShipAddress2") & rsTicket("ShipCity") & rsTicket("ShipState") & rsTicket("ShipPostalCode") & rsTicket("ShipCountry") & rsTicket("ShipCode")
		If NewAddress <> LastAddress Then 'It's different.  Print it.
			Response.Write "<TR><TD COLSPAN=""9"">&nbsp;</TD></TR>" & vbCrLf	
			Response.Write "<TR BGCOLOR=""#008400""><TD COLSPAN=""9""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Order Number: " & rsTicket("OrderNumber") & " " & rsTicket("ShipFirstName") & " " & rsTicket("ShipLastName") & " " & rsTicket("ShipAddress1") & " " & rsTicket("ShipAddress2") & " " & rsTicket("ShipCity") & ", " & rsTicket("ShipState") & " " & rsTicket("ShipPostalCode") & "</B></FONT></TD></TR>" & vbCrLf
			Response.Write "<TR BGCOLOR=""#666666""><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Ticket #</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Event</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Venue</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Date/Time</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Section</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Row</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Seat</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Seat Type</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Price</B></FONT></TD></TR>" & vbCrLf
			LastAddress = NewAddress
		End If
		
		'Print the Ticket Detail
		Response.Write "<TR BGCOLOR=""#DDDDDD""><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2""><INPUT TYPE=""hidden"" NAME=""OrderNumber"" VALUE=" & rsTicket("OrderNumber") & "><INPUT TYPE=""hidden"" NAME=""LineNumber"" VALUE=" & rsTicket("LineNumber") & ">" & rsTicket("ItemNumber") & "</FONT></TD><TD><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsTicket("Act") & "</FONT></TD><TD><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsTicket("Venue") & "</FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsTicket("EventDate") & "</FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsTicket("SectionCode") & "</FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsTicket("Row") & "</FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsTicket("Seat") & "</FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsTicket("SeatType") & "</FONT></TD><TD ALIGN=""right""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & FormatNumber(rsTicket("Price"),2) & "</FONT></TD></TR>" & vbCrLf

		rsTicket.MoveNext
		
	Loop
		
Next

Response.Write "</TABLE><BR>" & vbCrLf
'Set Focus to Ticket Printing Menu Button
'Find Tickets based on Print Date, Organization, etc.
'List Tickets
'Display Button to return to Ticket Printing Menu
Response.Write "<FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">Did the tickets print properly?</FONT><BR>" & vbCrLf
Response.Write "<TABLE CELLPADDING=""10""><TR><TD><INPUT TYPE=""submit"" VALUE=""Yes"" NAME=""Button""></FORM></TD><TD><FORM ACTION=""TicketBatchPrint.asp"" METHOD=""post"" NAME=""NoPrint""><INPUT TYPE=""hidden"" NAME=""FormName"" VALUE=""NoPrint""><INPUT TYPE=""submit"" VALUE=""No""></FORM></TR></TABLE>" & vbCrLf

%>

</CENTER>

<!--#INCLUDE VIRTUAL="FooterInclude.asp"-->

</BODY>
</HTML>

<%

End Sub 'DisplayTickets

'------------------------------

Sub UpdatePrintDate

'Set Print Date
PrintDate = Now()

'Loop Throught The Order Lines from DisplayTickets Sub
For Each Item In Request("OrderNumber")
	
	'This sets the position of the Request("OrderNumber") and Request("LineNumber") arrays
	ArrayPos = ArrayPos + 1
	OrderNumber = Request("OrderNumber")(ArrayPos)
	LineNumber = Request("LineNumber")(ArrayPos)
	
	SQLUpdatePrintDate = "UPDATE OrderLine SET PrintDate = '" & PrintDate & "' WHERE OrderNumber = " & OrderNumber & " AND LineNumber = " & LineNumber
	Set rsUpdatePrintDate = OBJdbConnection.Execute(SQLUpdatePrintDate)

Next

Call PrintMenu

End Sub 'UpdatePrintDate
%>