<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp"-->
<!--#INCLUDE VIRTUAL="TicketPrintInclude.asp"-->
<!--#INCLUDE VIRTUAL="NoCacheInclude.asp"-->
<%

'CHANGE LOG
'JAI 4/23/13 - New script for TheatreZone renewals.
'JAI 4/16/14 - Uodated for 2014 TheatreZone renewals.
'SSR 4/21/14 - Updated renewal letter
'JAI 5/1/14 - Cleaned up formatting.
'SLM 3/22/15 - Updated for 2015
'SSR 3/23/15 - Updated to print letters in alpha order, sorted by last name.
'SLM 3/27/15 - Saved edits
'JAI 3/30/15 - Reset Column Heading values after each order

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
<HEAD>
<TITLE>www.TIX.com - Subscription Renewal Letters</TITLE>

<SCRIPT LANGUAGE="JavaScript">    
<!-- Hide code from non-js browsers

    function makeCheckEvent(thisForm) {
        if (thisForm.EventCode.length > 1) {
            for (i = 0; i < thisForm.EventCode.length; i++) {
                if (thisForm.SelectAllEvents.checked == true) {
                    thisForm.EventCode[i].checked = true
                } else {
                    thisForm.EventCode[i].checked = false
                }
            }
        } else {
            if (thisForm.SelectAllEvents.checked == true) {
                thisForm.EventCode.checked = true
            } else {
                thisForm.EventCode.checked = false
            }
        }
    }

    function eventSelectedCheck(thisForm) {

        var EventCodeSelected = false;
        var EventCodeIndex = 0;

        //Check for Event Selection.	
        if (formObj.EventCode.length) { //There's multiple events
            for (var i = 0; i < formObj.EventCode.length; i++) {
                if (eval("formObj.EventCode[i].checked") == true) {
                    EventCodeSelected = true;
                    EventCodeIndex = formObj.EventCode[i].value;
                }
            }
        }
        else { //There's only one event
            if (formObj.EventCode.checked == true) {
                EventCodeSelected = true;
                EventCodeIndex = formObj.EventCode.value;
            }
        }
        if (EventCodeSelected != true) { //Event not selected.
            alert("Please select at least one Event.");
            return false;
        }
    }

    // end hiding -->
</SCRIPT>

</HEAD>
<BODY BGCOLOR="#FFFFFF">

<CENTER>

<!--#INCLUDE VIRTUAL="TopNavInclude.asp"-->
<BR>
<BR>

<FONT FACE="verdana,arial,helvetica" COLOR="#008400"><H3>Subscription Renewal Printing</H3></FONT>


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
		Response.Write "<TABLE CELLPADDING=""3"">" & vbCrLf
		Response.Write "<TR BGCOLOR=""#666666""><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><INPUT TYPE=""checkbox"" Name=""SelectAllEvents"" onClick=""makeCheckEvent(this.form)"" id=SelectAllEvents></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Subscription</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Venue</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Date/Time</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Quantity</B></FONT></TD></TR>" & vbCrLf

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

</CENTER>

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
SQLOrderLine = SQLOrderLine & SQLWhere & ") AND OrderLine.StatusCode = 'R' AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent')" & LetterRange & " ORDER BY OrderLine.ShipLastName, OrderLine.ShipFirstName, OrderLine.OrderNumber, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry, OrderLine.ShipCode, Seat.EventCode, Seat.SectionCode, RowSort, SeatSort DESC"
Set rsOrderLine = OBJdbConnection.Execute(SQLOrderLine)
		
Do Until rsOrderLine.EOF ' Or LetterCount >= 1

	If rsOrderLine("OrderNumber") <> LastOrderNumber Then 'It's different.  Print it.
		If TicketCount > 0 Then 'It's not the first one, print the footer.
		
			Response.Write "<TR><TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf	
			
			If LastShipFee <> 0 And LastOrderTypeNumber <> 5 Then
				Response.Write "<TR><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=Calibri,Charcoal,Arial>Processing Fee</TD><TD ALIGN=""right""><FONT FACE=Calibri,Charcoal,Arial>" & FormatCurrency(LastShipFee,2) & "</TD></TR>" & vbCrLf
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
			
			If LastShipFee = 0 And LastOrderTypeNumber <> 5 Then
				Response.Write "<TR><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=Calibri,Charcoal,Arial>[&nbsp;&nbsp;] ADD $1 for mailing</TD><TD ALIGN=""right""><FONT FACE=Calibri,Charcoal,Arial>&nbsp;&nbsp;</TD></TR>" & vbCrLf
				Response.Write "<TR><TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf
			End If
			
			Response.Write "</TABLE><BR>" & vbCrLf

	        'Footer Info
	        Response.Write "<TABLE WIDTH=""750"" >" & vbCrLf
        	Response.Write "<TR><TD COLSPAN=""3""><FONT FACE=Calibri,Charcoal,Arial>Please provide email for E-tickets ________________________________________________________________<br />Please note, all tickets are held in Will Call unless otherwise directed as E-Tickets that you may print like a boarding pass, or as indicated add $1 for US Mail.<br /></FONT></TD></TR>" & vbCrLf
	        Response.Write "<TR><TD COLSPAN=""3""><FONT FACE=Calibri,Charcoal,Arial>I prefer to pay by:&nbsp;&nbsp;[&nbsp;&nbsp;] Check&nbsp;&nbsp;&nbsp;[&nbsp;&nbsp;] MasterCard&nbsp;&nbsp;&nbsp;[&nbsp;&nbsp;] Visa&nbsp;&nbsp;&nbsp;[&nbsp;&nbsp;] Discover&nbsp;&nbsp;[&nbsp;&nbsp;] American Express<br /></FONT></TD></TR>" & vbCrLf
	        Response.Write "<TR><TD COLSPAN=""3""><FONT FACE=Calibri,Charcoal,Arial>____ ____ ____ ____ - ____ ____ ____ ____ - ____ ____ ____ ____ - ____ ____ ____ ____</FONT></TD></TR>" & vbCrLf
	        Response.Write "<TR><TD COLSPAN=""3""><FONT FACE=Calibri,Charcoal,Arial>(Card Number)</FONT></TD></TR>" & vbCrLf
        				
	        Response.Write "<TR><TD><FONT FACE=Calibri,Charcoal,Arial>______________</FONT></TD>"
	        Response.Write "<TD><FONT FACE=Calibri,Charcoal,Arial>___________________________________</FONT></TD>"
	        Response.Write "<TD><FONT FACE=Calibri,Charcoal,Arial>_____________________________________</FONT></TD></TR>"
	        Response.Write "<TR><TD><FONT FACE=Calibri,Charcoal,Arial>(Expiration Date)</FONT></TD>" & vbCrLf
	        Response.Write "<TD><FONT FACE=Calibri,Charcoal,Arial>(Name as it appears on card - please print)</FONT></TD>" & vbCrLf
	        Response.Write "<TD><FONT FACE=Calibri,Charcoal,Arial>(Signature)</FONT></TD></TR></TABLE>" & vbCrLf
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
			Response.Write rsCustInfo("City") & ", " & rsCustInfo("State") & " " & rsCustInfo("PostalCode") & "</TD></TR>" & vbCrLf
			Response.Write "<TR><TD COLSPAN=""3""><br /><HR></TD></TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf
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
		ColFacilityCharge = "N"
		ColServiceFee = "N"
		ColDiscount = "N"

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
	
	If LastShipFee = 0 And LastOrderTypeNumber <> 5 Then
		Response.Write "<TR><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=Calibri,Charcoal,Arial>[&nbsp;&nbsp;] ADD $1 for mailing</TD><TD ALIGN=""right""><FONT FACE=Calibri,Charcoal,Arial>&nbsp;&nbsp;</TD></TR>" & vbCrLf
		Response.Write "<TR><TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf
	End If
			
	Response.Write "</TABLE><BR>" & vbCrLf

	'Footer Info
	Response.Write "<TABLE WIDTH=""750"" >" & vbCrLf
	Response.Write "<TR><TD COLSPAN=""3""><FONT FACE=Calibri,Charcoal,Arial>Please provide email for E-tickets ________________________________________________________________<br />Please note, all tickets are in Will Call unless otherwise directed as E-Tickets that you may print like a boarding pass, or as indicated add $1 for US Mail.<br /></FONT></TD></TR>" & vbCrLf
	Response.Write "<TR><TD COLSPAN=""3""><FONT FACE=Calibri,Charcoal,Arial>I prefer to pay by:&nbsp;&nbsp;[&nbsp;&nbsp;] Check&nbsp;&nbsp;&nbsp;[&nbsp;&nbsp;] MasterCard&nbsp;&nbsp;&nbsp;[&nbsp;&nbsp;] Visa&nbsp;&nbsp;&nbsp;[&nbsp;&nbsp;] Discover&nbsp;&nbsp;[&nbsp;&nbsp;] American Express<br /></FONT></TD></TR>" & vbCrLf
	Response.Write "<TR><TD COLSPAN=""3""><FONT FACE=Calibri,Charcoal,Arial>____ ____ ____ ____ - ____ ____ ____ ____ - ____ ____ ____ ____ - ____ ____ ____ ____</FONT></TD></TR>" & vbCrLf
	Response.Write "<TR><TD COLSPAN=""3""><FONT FACE=Calibri,Charcoal,Arial>(Card Number)</FONT></TD></TR>" & vbCrLf
        				
	Response.Write "<TR><TD><FONT FACE=Calibri,Charcoal,Arial>______________</FONT></TD>"
	Response.Write "<TD><FONT FACE=Calibri,Charcoal,Arial>___________________________________</FONT></TD>"
	Response.Write "<TD><FONT FACE=Calibri,Charcoal,Arial>_____________________________________</FONT></TD></TR>"
	Response.Write "<TR><TD><FONT FACE=Calibri,Charcoal,Arial>(Expiration Date)</FONT></TD>" & vbCrLf
	Response.Write "<TD><FONT FACE=Calibri,Charcoal,Arial>(Name as it appears on card - please print)</FONT></TD>" & vbCrLf
	Response.Write "<TD><FONT FACE=Calibri,Charcoal,Arial>(Signature)</FONT></TD></TR></TABLE><BR>" & vbCrLf
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