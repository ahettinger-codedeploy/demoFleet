<!--#INCLUDE virtual=GlobalInclude.asp -->
<!--#INCLUDE virtual="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL ="EasyPDFInclude.asp"-->
<!--#INCLUDE VIRTUAL ="ETicketInclude.asp"-->

<%

OrderNumber = Clean(Request("OrderNumber"))
TicketNumber = Clean(Request("TicketNumber"))

'Find the OrderNumber for this Ticket.  Check using both OrderNumber and TicketNumber for added security.
SQLOrderNum = "SELECT OrderNumber FROM Ticket (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND TicketNumber = '" & TicketNumber & "'"
Set rsOrderNum = OBJdbConnection.Execute(SQLOrderNum)

If Not rsOrderNum.EOF Then

	'Check the Order for ETicket (ShipCode=13)
	SQLTix = "SELECT OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipCountry, OrderLine.ShipPostalCode, OrderLine.Price, OrderLine.Discount AS LineDiscount, OrderHeader.OrderNumber, OrderHeader.Subtotal, OrderHeader.ShipFee, OrderHeader.OrderSurcharge, OrderHeader.Total, OrderHeader.Discount AS OrderDiscount, OrderDate, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.Country, Customer.PostalCode, Seat.ItemNumber, Seat.Row, Seat.Seat, Section.SectionCode, Section.Section, Event.EventCode, Event.EventDate, Event.Phone AS EventPhoneNumber, Event.EMailAddress AS EventEMailAddress, Act.Act, Act.ShortAct, Act.Comments AS ActComments, Event.Comments AS EventComments, Venue.Venue, Venue.Address_1 AS VenueAddress1, Venue.Address_2 AS VenueAddress2, Venue.City AS VenueCity, Venue.State AS VenueState, Venue.Zip_Code AS VenuePostalCode, SeatType.SeatType, Shipping.ShipType, OrderType, Organization.Organization, Ticket.TicketNumber FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN Shipping (NOLOCK) ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN Section (NOLOCK) ON Seat.SectionCode = Section.SectionCode AND Seat.EventCode = Section.EventCode LEFT JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber INNER JOIN Ticket (NOLOCK) ON OrderLine.ItemNumber = Ticket.ItemNumber INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber WHERE OrderLine.OrderNumber = " & rsOrderNum("OrderNumber") & " AND OrderLine.ShipCode = 13 AND Ticket.StatusCode = 'A' AND OrganizationVenue.Owner = 1"
	Set rsTix = OBJdbConnection.Execute(SQLTix)


	If Not rsTix.EOF Then

		Response.Expires = 0
		Response.Buffer = TRUE
		Response.Clear
		Response.ContentType = "application/pdf"

		dim PDF

		'MIT Data Easy PDF - www.mitdata.com
		set PDF = server.createobject("aspPDF.EasyPDF")

		PDF.Debug = FALSE

		PDF.License("EasyPDF.lic")

		' Set margins for the page
		PDF.SetMargins 20,20,20,20

		FirstTicket = "Y"

		Do Until rsTix.EOF
			
			If FirstTicket <> "Y" Then
				PDF.AddPage
			End If
				
			FirstTicket = "N"


			' Set margins for the page
			PDF.SetMargins 20,20,20,20
			PDF.SetProperty csPropTextAngle, "0"

			'PDF.SetProperty csPropGraphZoom, 1
			'PDF.SetProperty csPropGraphWZoom, 25
			'PDF.SetProperty csPropGraphHZoom, 25
			'PDF.AddGraphicPos 35,30, "Images\Ticket.jpg"
			PDF.AddGraphicPos 35,30, "..\..\Images\Ticket.gif"
			'PDF.SetProperty csPropGraphZoom, 1
			'PDF.SetProperty csPropGraphWZoom, 100
			'PDF.SetProperty csPropGraphHZoom, 100

			PDF.SetProperty csPropTextFont, "F1"
			PDF.SetProperty csPropTextSize, 10
			PDF.AddTextPos 310,45, rsTix("OrderNumber") & " - " & rsTix("ItemNumber")
			PDF.SetProperty csPropTextFont, "F3"
			PDF.SetProperty csPropTextSize, 10
			PDF.AddTextPos 50,100, "First Annual"
			PDF.SetProperty csPropTextFont, "F2"
			PDF.SetProperty csPropTextSize, 15
			PDF.AddTextPos 50,120, rsTix("ShortAct")
			PDF.SetProperty csPropTextSize, 15
			PDF.AddTextPos 50,140, rsTix("Venue")
			PDF.SetProperty csPropTextFont, "F1"
			PDF.AddTextPos 50,155, FormatDateTime(rsTix("EventDate"), vbLongDate) & " at " & Left(FormatDateTime(rsTix("EventDate"),vbLongTime),Len(FormatDateTime(rsTix("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsTix("EventDate"),vbLongTime),3)
			PDF.SetProperty csPropTextSize, 10
			PDF.AddTextPos 50,180, rsTix("SeatType") & "  $" & FormatNumber(rsTix("Price"),2)
			PDF.AddTextPos 50,200, rsTix("Section")
			'Stub
			PDF.SetProperty csPropTextAngle, "1.57"
			PDF.SetProperty csPropTextSize, 8
			PDF.AddTextPos 425,195, FormatDateTime(rsTix("EventDate"), vbShortDate) & " " & Left(FormatDateTime(rsTix("EventDate"),vbLongTime),Len(FormatDateTime(rsTix("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsTix("EventDate"),vbLongTime),3)
			PDF.AddTextPos 425,100, rsTix("OrderNumber") & " - " & rsTix("ItemNumber")
			PDF.SetProperty csPropTextFont, "F2"
			PDF.SetProperty csPropTextSize, 10
			PDF.AddTextPos 440,195, rsTix("ShortAct")
			PDF.SetProperty csPropTextSize, 10
			PDF.AddTextPos 455,195, rsTix("Venue")
			PDF.SetProperty csPropTextFont, "F1"
			PDF.AddTextPos 470,195, FormatDateTime(rsTix("EventDate"), vbShortDate) & " at " & Left(FormatDateTime(rsTix("EventDate"),vbLongTime),Len(FormatDateTime(rsTix("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsTix("EventDate"),vbLongTime),3)
			PDF.AddTextPos 485,195, rsTix("SeatType")
			PDF.AddTextPos 500,195, "Price: $" & FormatNumber(rsTix("Price"),2)
'			PDF.AddTextPos 520,195, "SECTION"
'			PDF.AddTextPos 520,110, "ROW"
'			PDF.AddTextPos 520,70, "SEAT"
			PDF.AddTextPos 535,195, rsTix("Section")
'			PDF.AddTextPos 535,110, rsTix("Row")
'			PDF.AddTextPos 535,70, rsTix("Seat")

			'Barcode
			'PDF.SetProperty csPropGraphBCAngle, 90
			PDF.SetProperty csPropGraphZoom, 1
			PDF.SetProperty csPropGraphWZoom, 75
			PDF.SetProperty csPropGraphHZoom, 100
			PDF.AddBarCode 35, 230, 30, csCode128B, rsTix("TicketNumber")
			PDF.SetProperty csPropTextAngle, "0"
			PDF.AddTextPos 35, 270, Left(rsTix("TicketNumber"), 4) & "-" & Mid(rsTix("TicketNumber"), 5, 4) & "-" & Mid(rsTix("TicketNumber"), 9, 4) & "-" & Mid(rsTix("TicketNumber"), 13, 4) & "-" & Right(rsTix("TicketNumber"), Len(rsTix("TicketNumber")) - 16)
			PDF.SetProperty csPropGraphZoom, 1
			PDF.SetProperty csPropGraphWZoom, 100

			'Billing Information
			PDF.SetProperty csPropTextFont, "F2"
			PDF.SetProperty csPropTextSize, 10
			PDF.AddTextPos 35,290, "BILLING INFORMATION"
			PDF.SetProperty csPropTextFont, "F1"
			PDF.AddTextPos 35,300, rsTix("FirstName") & " " & rsTix("LastName")
			PDF.AddTextPos 35,310, rsTix("Address1")
			PDF.AddTextPos 35,320, rsTix("Address2")
			PDF.AddTextPos 35,330, rsTix("City") & ", " & rsTix("State") & " " & rsTix("PostalCode")

			'Shipping Information
			PDF.SetProperty csPropTextFont, "F2"
			PDF.SetProperty csPropTextSize, 10
			PDF.AddTextPos 35,350, "ATTENDEE INFORMATION"
			PDF.SetProperty csPropTextFont, "F1"
			PDF.AddTextPos 35,360, rsTix("ShipFirstName") & " " & rsTix("ShipLastName")
			PDF.AddTextPos 35,370, rsTix("ShipAddress1")
			PDF.AddTextPos 35,380, rsTix("ShipAddress2")
			PDF.AddTextPos 35,390, rsTix("ShipCity") & ", " & rsTix("ShipState") & " " & rsTix("ShipPostalCode")
						
			'Order Information
			PDF.SetProperty csPropTextFont, "F2"
			PDF.SetProperty csPropTextSize, 10
			PDF.AddTextPos 35,410, "ORDER INFORMATION"
			PDF.SetProperty csPropTextFont, "F1"
			PDF.AddTextPos 35,420, "Order Number: " & rsTix("OrderNumber")
			PDF.AddTextPos 35,430, "Order Date: " & rsTix("OrderDate")
			PDF.AddTextPos 35,440, "Order Total: " & FormatCurrency(rsTix("Total"),2)

			'Order Information
			PDF.SetProperty csPropTextFont, "F2"
			PDF.SetProperty csPropTextSize, 10
			PDF.AddTextPos 35,460, "GENERAL INFORMATION"
			PDF.SetProperty csPropTextFont, "F1"
			PDF.SetProperty csPropTextSize, 10
			PDF.AddTextPos 35,470, "No Refunds - No Exchanges"
			PDF.SetProperty csPropTextSize, 7
			PDF.AddTextPos 35,480, "DO NOT COPY THIS TICKET - MULTIPLE COPIES INVALID"
			PDF.AddTextPos 35,488, "Holder assumes all risk and danger including, without limitation,"
			PDF.AddTextPos 35,496, "injury, death, personal loss, property damage, or other related"
			PDF.AddTextPos 35,504, "harm.  Management reserves the right to refuse admission or"
			PDF.AddTextPos 35,512, "eject any person whose fails to comply with the terms and "
			PDF.AddTextPos 35,520, "conditions and/or rules for the event in which this ticket is issued."


			'Venue Information
			PDF.SetProperty csPropTextFont, "F2"
			PDF.SetProperty csPropTextSize, 10
			PDF.AddTextPos 240,290, "VENUE INFORMATION"
			PDF.SetProperty csPropTextFont, "F1"
			PDF.AddTextPos 240,300, rsTix("Venue")
			PDF.AddTextPos 240,310, rsTix("VenueAddress1") & ""
			PDF.AddTextPos 240,320, rsTix("VenueAddress2") & ""
			PDF.AddTextPos 240,330, rsTix("VenueCity") & ", " & rsTix("VenueState") & " " & rsTix("VenuePostalCode") & ""
			PDF.AddTextPos 240,340, "Phone: " & FormatPhone(rsTix("EventPhoneNumber"), "United States") & ""
			PDF.AddTextPos 240,350, rsTix("EventEMailAddress") & ""

			'Directions
			PDF.SetProperty csPropTextFont, "F2"
			PDF.SetProperty csPropTextSize, 10
			PDF.AddTextPos 240,370, "DIRECTIONS"
			PDF.SetProperty csPropTextFont, "F1"
			PDF.AddTextPos 240,380, "Approximately 0.8 miles"
			PDF.AddTextPos 240,390, "North of the Train Station"
			PDF.AddTextPos 240,400, "and Downtown Durango on"
			PDF.AddTextPos 240,410, "Main Avenue."
'			PDF.AddTextPos 240,430, "Turn Left on Cover Street"
'			PDF.AddTextPos 240,440, "Turn Left on Pixie Street"
'			PDF.AddTextPos 240,460, "From Orange County:"
'			PDF.AddTextPos 240,470, "Take 405 North"
'			PDF.AddTextPos 240,480, "Exit Cherry Ave North"
'			PDF.AddTextPos 240,490, "Turn Right on Cover Street"
'			PDF.AddTextPos 240,500, "Turn Left on Pixie Street"

			'Additional Information
			PDF.SetProperty csPropTextFont, "F2"
			PDF.SetProperty csPropTextSize, 10
			PDF.AddTextPos 240,430, "ADDITIONAL INFORMATION"
			PDF.SetProperty csPropTextFont, "F1"
			PDF.SetProperty csPropTextSize, 10
			PDF.AddTextPos 240,440, "RAIN OR SHINE.  NO PETS"
			PDF.AddTextPos 240,450, "NO GLASS CONTAINERS"
			PDF.AddTextPos 240,460, "NO STANDARD HEIGHT LAWN CHAIRS"
			PDF.AddTextPos 240,470, "LOW PROFILE CHAIRS ONLY"
			PDF.AddTextPos 240,480, "LIMITED PREFERRED PARKING ON SITE"
			PDF.AddTextPos 240,490, "FREE SHUTTLES TO PARKING LOTS"
			
			'Ad
			PDF.AddGraphicPos 0,575, "..\..\Clients\DurangoConcerts\Images\ETicketAd.jpg"

			rsTix.MoveNext
				
		Loop

	'	PDF.AddPage
	'	PDF.AddHtml ("Page 2</FONT></BODY></HTML>")

		' BinaryWrite is quite slow, if you can use Save Method you will
		' get an increase of speed. 

		PDF.BinaryWrite
		' Generate the PDF document in a file
	'	PDF.Save Server.MapPath("TicketTest.pdf")

		set pdf = nothing

	Else

		ETicketError("ETicketFormat - Ticket #" & TicketNumber & " - " & SQLTix)
		ErrorLog("ETicketPrint - Invalid Ticket - Order #" & OrderNumber & " - Ticket #" & TicketNumber)

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