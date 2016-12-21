
<!--#INCLUDE virtual=GlobalInclude.asp -->
<!--#INCLUDE virtual="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL ="ETicketInclude.asp"-->

<%

'J'La Chick - E-ticket customization 11/18/2009
'E-ticket will display a different advertising image based on the event code



OrderNumber = Clean(Request("OrderNumber"))
TicketNumber = Clean(Request("TicketNumber"))


'===============================================
'Options
'===============================================

'E-Ticket Ad Option

AdByEvent = True
		
If AdByEvent Then

	Dim RequiredEvent(3)
	Dim OfferEvent(3)

	RequiredEvent(1) = 512594  'Drumline Live
	OfferEvent(1) = "Images/SodaPops.jpg"

	RequiredEvent(2) = 512610 '5 Browns
	OfferEvent(2) = "Images/InfusionSpa.jpg"


	RequiredEvent(3) = 512612 'Celtic Nights
	OfferEvent(3) = "Images/2014Season.jpg"


End If

'===============================================
'===============================================


'Find the OrderNumber for this Ticket.  Check using both OrderNumber and TicketNumber for added security.
SQLOrderNum = "SELECT OrderNumber FROM Ticket (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND TicketNumber = '" & TicketNumber & "'"
Set rsOrderNum = OBJdbConnection.Execute(SQLOrderNum)

If Not rsOrderNum.EOF Then

	'Check the Order for ETicket (ShipCode=13)
	SQLTix = "SELECT OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipCountry, OrderLine.ShipPostalCode, OrderLine.Price, OrderLine.Discount AS LineDiscount, OrderHeader.OrderNumber, OrderHeader.Subtotal, OrderHeader.ShipFee, OrderHeader.OrderSurcharge, OrderHeader.Total, OrderHeader.Discount AS OrderDiscount, OrderDate, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.Country, Customer.PostalCode, Seat.ItemNumber, Seat.Row, Seat.Seat, Section.SectionCode, Section.Section, Event.EventCode, Event.EventDate, Event.Phone AS EventPhoneNumber, Event.EMailAddress AS EventEMailAddress, Act.Act, Act.ShortAct, Act.Producer, Act.Comments AS ActComments, Event.Comments AS EventComments, Venue.Venue, Venue.Address_1 AS VenueAddress1, Venue.Address_2 AS VenueAddress2, Venue.City AS VenueCity, Venue.State AS VenueState, Venue.Zip_Code AS VenuePostalCode, SeatType.SeatType, Shipping.ShipType, OrderType, Organization.Organization, Ticket.TicketNumber FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN Shipping (NOLOCK) ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN Section (NOLOCK) ON Seat.SectionCode = Section.SectionCode AND Seat.EventCode = Section.EventCode LEFT JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber INNER JOIN Ticket (NOLOCK) ON OrderLine.ItemNumber = Ticket.ItemNumber INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber WHERE OrderLine.OrderNumber = " & rsOrderNum("OrderNumber") & " AND OrderLine.ShipCode = 13 AND Ticket.StatusCode = 'A' AND OrganizationVenue.Owner = 1"
	Set rsTix = OBJdbConnection.Execute(SQLTix)

	If Not rsTix.EOF Then

		SQLTotalTix = "SELECT COUNT(TicketNumber) AS TotalTix FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN Shipping (NOLOCK) ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN Section (NOLOCK) ON Seat.SectionCode = Section.SectionCode AND Seat.EventCode = Section.EventCode LEFT JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber INNER JOIN Ticket (NOLOCK) ON OrderLine.ItemNumber = Ticket.ItemNumber INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber WHERE OrderLine.OrderNumber = " & rsOrderNum("OrderNumber") & " AND OrderLine.ShipCode = 13 AND Ticket.StatusCode = 'A' AND OrganizationVenue.Owner = 1"
		Set rsTotalTix = OBJdbConnection.Execute(SQLTotalTix)
		
		TotalTix = rsTotalTix("TotalTix")
		
		rsTotalTix.Close
		Set rsTotalTix = nothing

		Response.Write "<HTML>" & vbCrLf
		Response.Write "<HEAD>" & vbCrLf
		Response.Write "<TITLE>www.TIX.com - E-Ticket</TITLE>" & vbCrLf
		Response.Write "</HEAD>" & vbCrLf
		Response.Write "<BODY onLoad=""window.print()"">" & vbCrLf

		'Set Page Break Style
		Response.Write "<STYLE>" & vbCrLf
		Response.Write ".PageBreak {page-break-before: always}" & vbCrLf
		Response.Write "</STYLE>" & vbCrLf

		Response.Write "<CENTER>" & vbCrLf

		Do Until rsTix.EOF
		
			TixCount = TixCount + 1

		'Begin Ticket

            Response.Write "<TABLE WIDTH=""620"" BORDER=""0"">" & vbCrLf
            Response.Write "<TR>" & vbCrLf
            Response.Write "<TD VALIGN=""top"">" & vbCrLf
            Response.Write "<TABLE WIDTH=""615"" HEIGHT=""240"" BORDER=""1"" BORDERCOLOR=""#00214E"" BACKGROUND=""/Images/ETicketBackground.gif"" BGCOLOR=""#ECF0F5"" CELLPADDING=""0"" CELLSPACING=""0"">" & vbCrLf
            Response.Write "<TR>" & vbCrLf
            Response.Write "<TD WIDTH=""615"" VALIGN=""top"">" & vbCrLf
            Response.Write "<TABLE BORDER=""0"" CELLPADDING=""0"" CELLSPACING=""0"" WIDTH=""100%"">" & vbCrLf
            Response.Write "<TR>" & vbCrLf
            Response.Write "<TD WIDTH=""220"" HEIGHT=""70"" VALIGN=""top"">" & vbCrLf
            Response.Write "<IMG SRC=""/Clients/JLaChic/ETickets/Images/ETicketGoldLogo.gif"">" & vbCrLf
            Response.Write "</TD>" & vbCrLf
            Response.Write "<TD VALIGN=""top"" ALIGN=""right"">" & vbCrLf
            Response.Write "<FONT FACE=""Verdana,Arial,Helvetica"" SIZE=""1"">" & rsTix("OrderNumber") & " - " & rsTix("ItemNumber") & "</FONT></TD>" & vbCrLf
            Response.Write "</TD>" & vbCrLf
            Response.Write "</TR>" & vbCrLf
            Response.Write "</TABLE>" & vbCrLf			
			
			Response.Write "<TABLE BORDER=""0"" CELLPADDING=""0"" CELLSPACING=""0"" WIDTH=""100%"">" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD WIDTH=""20"" VALIGN=""top"">" & vbCrLf
			Response.Write "&nbsp;" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			Response.Write "<TD WIDTH=""395"" VALIGN=""top"">" & vbCrLf
			Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""2""><I>" & rsTix("Organization") & " Presents</I></FONT><BR>" & vbCrLf
			Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""5""><B>" & rsTix("Act") & "</B></FONT><BR><BR>" & vbCrLf
			Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""3""><B>" & rsTix("Venue") & "</B></FONT><BR>" & vbCrLf
			Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""3"">" & FormatDateTime(rsTix("EventDate"), vbLongDate) & " at " & Left(FormatDateTime(rsTix("EventDate"),vbLongTime),Len(FormatDateTime(rsTix("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsTix("EventDate"),vbLongTime),3) & "</FONT><BR><BR>" & vbCrLf
			Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""3"">" & rsTix("SeatType") & "  $" & FormatNumber(rsTix("Price"),2) & "</FONT><BR>" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			Response.Write "<TD WIDTH=""200"" VALIGN=""top"">" & vbCrLf
            Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""5""><B>SECTION:</B> " & rsTix("Section") & "</FONT><BR><BR>" & vbCrLf
            Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""5""><B>ROW:</B> " & rsTix("Row") & "</FONT><BR><BR>" & vbCrLf
            Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""5""><B>SEAT:</B> " & rsTix("Seat") & "</FONT><BR><BR>" & vbCrLf
            Response.Write "</TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf					  
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD ALIGN=""center"" COLSPAN=""2"" VALIGN=""bottom"" BGCOLOR=""#000000"" HEIGHT=""20"">" & vbCrLf
			Response.Write "<IMG SRC=""/Images/ETicketBottomBar.gif"">" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf

		'End Ticket

		'Begin Body Space

			Response.Write "<TABLE WIDTH=""620"" BORDER=""0"" CELLPADDING=""5"" CELLSPACING=""5"">" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			
			'Begin Left Column
			Response.Write "<TD VALIGN=""top"" WIDTH = ""33%"">" & vbCrLf
			Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""2"">" & vbCrLf
			Response.Write "<B>ORDER INFORMATION</B><BR>" & vbCrLf
			Response.Write "<SPAN style=""font-face: Arial, Helvetica; font-size: 8pt"">" & vbCrLf
			Response.Write "Order Number:&nbsp;&nbsp;" & rsTix("OrderNumber") & "<BR>" & vbCrLf
			Response.Write "Order Date:&nbsp;&nbsp;" & FormatDateTime(rsTix("OrderDate"), vbShortDate) & "<BR>" & vbCrLf			
			Response.Write "Order Time:&nbsp;&nbsp; " & Left(FormatDateTime(rsTix("OrderDate"),vbLongTime),Len(FormatDateTime(rsTix("OrderDate"),vbLongTime))-6) & Right(FormatDateTime(rsTix("OrderDate"),vbLongTime),3)& "&nbsp;Pacific Time<BR>" & vbCrLf
			
	        Response.Write "Order Total:&nbsp;&nbsp;" & FormatCurrency(rsTix("Total"),2)& "<BR>" & vbCrLf
			Response.Write "</SPAN>" & vbCrLf
			Response.Write "<BR>" & vbCrLf
			Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""2"">" & vbCrLf
			Response.Write "<B>BILLING INFORMATION</B><BR>" & vbCrLf
			Response.Write "<SPAN style=""font-face: Arial, Helvetica; font-size: 8pt"">" & vbCrLf
			Response.Write rsTix("FirstName") & " " & rsTix("LastName") & "<BR>" & vbCrLf
			Response.Write rsTix("Address1") & "<BR>" & vbCrLf
			If rsTix("Address2") <> "" Then
				Response.Write rsTix("Address2") & "<BR>" & vbCrLf
			End If
			Response.Write rsTix("City") & ", " & rsTix("State") & " " & rsTix("PostalCode") & "<BR>" & vbCrLf
		    Response.Write "</SPAN>" & vbCrLf
			Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""2"">" & vbCrLf
			Response.Write "<BR>" & vbCrLf
			Response.Write "<B>E-TICKET BARCODE</B><BR>" & vbCrLf
			Response.Write "<IMG alt=""Barcode Image"" src=""/Barcode.asp?Barcode=" & rsTix("TicketNumber") & """ WIDTH=""150""><BR>" & vbCrLf
			Response.Write "</FONT>" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			
			'Begin Middle Column
			'Venue Information
			Response.Write "<TD VALIGN=""top"" WIDTH=""33%"">" & vbCrLf
            Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""2"">" & vbCrLf
            Response.Write "<B>VENUE INFORMATION</B><BR>" & vbCrLf
            Response.Write "<SPAN style=""font-face: Arial, Helvetica; font-size: 8pt"">" & vbCrLf
			Response.Write rsTix("Venue") & "<BR>" & vbCrLf
			Response.Write rsTix("VenueAddress1") & "<BR>" & vbCrLf
			If rsTix("VenueAddress2") <> "" Then
				Response.Write rsTix("VenueAddress2") & "<BR>" & vbCrLf
			End If
			Response.Write rsTix("VenueCity") & ", " & rsTix("VenueState") & " " & rsTix("VenuePostalCode") & "<BR>" & vbCrLf
            Response.Write "</SPAN>" & vbCrLf
            Response.Write "<BR>" & vbCrLf
            Response.Write "<IMG SRC=""/Clients/JLaChic/ETickets/Images/MapRedArrow.jpg"" WIDTH=""200"">" & vbCrLf
            Response.Write "</TD>" & vbCrLf
			
			'Begin Right Column
			Response.Write "<TD VALIGN=""top"" WIDTH=""34%"">" & vbCrLf
			Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""2"">" & vbCrLf
			Response.Write "<B>DRIVING DIRECTIONS</B><BR>" & vbCrLf
			Response.Write "<SPAN style=""font-face: Arial, Helvetica; font-size: 6pt"">" & vbCrLf
            Response.Write "<BR>" & vbCrLf
            Response.Write "<B>From the South Bay</B><BR>" & vbCrLf
            Response.Write "Take Highway 101 North to Highway 80 East<BR>" & vbCrLf
            Response.Write "Exit at 4th Street<BR>" & vbCrLf
            Response.Write "Stay left onto Bryant Street (get in right lane)<BR>" & vbCrLf
            Response.Write "Stay on Bryant Street to The Embarcadero<BR>" & vbCrLf
            Response.Write "Turn left onto The Embarcadero (get into right lane)<BR>" & vbCrLf
            Response.Write "Straight to PIER 39 (2 1/2 miles)<BR>" & vbCrLf
            Response.Write "<BR>" & vbCrLf
            Response.Write "<B>From the North Bay</B><BR>" & vbCrLf
            Response.Write "Take Highway 101 South across the Golden Gate Bridge<BR>" & vbCrLf
            Response.Write "Pass through the Toll Plaza and stay to your left<BR>" & vbCrLf
            Response.Write "Take Lombard Street Exit (on right side)<BR>" & vbCrLf
            Response.Write "Follow Lombard Street to Van Ness Avenue<BR>" & vbCrLf
            Response.Write "Take a left onto Van Ness Avenue (stay right)<BR>" & vbCrLf
            Response.Write "Follow Van Ness Avenue to Bay Street (about three blocks)<BR>" & vbCrLf
            Response.Write "Stay on Bay Street until it runs into The Embarcadero" & vbCrLf
            Response.Write "Turn left onto The Embarcadero<BR>" & vbCrLf
            Response.Write "You will see PIER 39 on right side of the street<BR>" & vbCrLf
            Response.Write "<BR>" & vbCrLf
            Response.Write "<B>From the East Bay</B><BR>" & vbCrLf
            Response.Write "Take Interstate 80 West across the Bay Bridge<BR>" & vbCrLf
            Response.Write "Take Fremont Exit (on right side)<BR>" & vbCrLf
            Response.Write "Stay in far right lane<BR>" & vbCrLf
            Response.Write "Turn left on Folsom St.<BR>" & vbCrLf
            Response.Write "Follow Folsom to The Embarcadero<BR>" & vbCrLf
            Response.Write "Turn left onto The Embarcadero<BR>" & vbCrLf
            Response.Write "Straight to PIER 39 (aprox. 2 miles)" & vbCrLf
            Response.Write "</span><BR>" & vbCrLf
            Response.Write "</FONT>" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf

            'Terms And Conditions
            Response.Write "<TABLE WIDTH=""620"" BORDER=""0"" CELLPADDING=""5"" CELLSPACING=""5"">" & vbCrLf
            Response.Write "<TR>" & vbCrLf
            Response.Write "<TD>" & vbCrLf
            Response.Write "<FONT FACE=""Arial, Helvetica"">" & vbCrLf
            Response.Write "<SPAN style=""font-face: Arial, Helvetica; font-size: 6pt"">" & vbCrLf
            Response.Write "No refunds. No exchanges. Do not copy this ticket. Multiple copies are invalid. J'La Chic Productions cannot be responsible for lost or stolen tickets. Management reserves the right to refuse admission to any person who fails to comply with the terms and conditions and/or rules for the event for which this ticket is issued. All information was correct as of date ticket was printed; however, changes to the schedule may occur. J'La Chic will make every effort to notify you if there is a schedule change following your purchase of tickets." & vbCrLf
            Response.Write "</SPAN>" & vbCrLf
            Response.Write "</FONT>" & vbCrLf
            Response.Write "</TD>" & vbCrLf
            Response.Write "</TR>" & vbCrLf
            Response.Write "</TABLE>" & vbCrLf


			'Begin Horizonal Rule
			Response.Write "<TABLE WIDTH=""620"" BORDER=""0"" CELLPADDING=""0"" CELLSPACING=""0"">" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD ALIGN=""center"">" & vbCrLf
			Response.Write "<HR>" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf

		'End Body Space
		
		'Ad Space -------------------------------

            ETicketAd = "/Images/TixLogo300x225.jpg"

			If AdByEvent Then
			
				For i = LBound(RequiredEvent) to UBound(RequiredEvent)
					If rsTIX("EventCode") =  RequiredEvent(i) Then
						ETicketAd = OfferEvent(i)
					End If
				Next
			
			Else
				ETicketAd = "/Images/TixLogo300x225.jpg"
			End if

            Response.Write "<TABLE WIDTH=""620"" BORDER=""0"" CELLPADDING=""0"" CELLSPACING=""0"">" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD ALIGN=""center"">" & vbCrLf
			Response.Write "<IMG src=""" & ETicketAd & """ border=""0"" Height=""200"">" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf 
			
		'End Ad Space -------------------------------
			
			If TixCount < TotalTix Then
				'REE 3/9/7 - Added space inbetween DIV tag to resolve IE 7 Page Break issue.
				Response.Write "<DIV CLASS=""PageBreak"">&nbsp;</DIV>" 'Page Break
			End If

			rsTix.MoveNext

		Loop

		Response.Write "</CENTER>" & vbCrLf
		Response.Write "</BODY>" & vbCrLf
		Response.Write "</HTML>" & vbCrLf

	Else

		ETicketError("ETicketFormat - Ticket #" & TicketNumber)
		ErrorLog("ETicketPrint - Invalid Ticket - Order #" & OrderNumber & " - Ticket #" & TicketNumber & " - " & SQLTix)

	End If

	rsTix.Close
	Set rsTix = nothing

Else

	ETicketError("Invalid Ticket")
	ErrorLog("ETicketPrint - Invalid Ticket - Order #" & OrderNumber & " - Ticket #" & TicketNumber)

End If


rsOrderNum.Close
Set rsOrderNum = nothing



%>
  