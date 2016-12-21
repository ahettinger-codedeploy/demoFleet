<%
'CHANGE LOG
'JAI 7/30/12 - Added ability to consolidate e-tickets if Subscription parent and children all have same barcode. Request("PrintSub") = "Y"
'JAI 2/12/13 - JOIN Ticket to OrderLine on both ItemNumber and OrderNumber to correct issues.
'JAI 2/27/13 - Added ability to specify ETicketAd (relative path and file name of image), ETicketMap (relative path and file name of image), and ETicketDrivingDirections (HTML text) within EventOptions.
'SSR 6/11/13 - Added custom Eticket Graphics, missing elements (height, width) from ETicket Map and ETicket Ad
%>

<!--#INCLUDE virtual=GlobalInclude.asp -->
<!--#INCLUDE virtual="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL ="ETicketInclude.asp"-->

<%

'----------------------------------

'ETicket Custom Graphics

	Dim ClientFolder
	Dim GenericFolder
	
	Dim FileLocation(3)
	FileLocation(1) = ""
	FileLocation(2) = ""
	FileLocation(3) = ""

	Dim FileName(3)
	FileName(1) = "ETicketBackground.gif"
	FileName(2) = "ETicketLogo.gif"
	FileName(3) = "ETicketBottomBar.gif"

	ClientFolder = "/Clients/DowntownTheater/ETickets/Images"
	GenericFolder = "images"
	

		Set FSO = Server.CreateObject("Scripting.FileSystemObject")

		For i = 1 to uBound(FileName)

			FilePath = (server.mappath(ClientFolder&"/"&FileName(i)))
			
			ErrorLog("FilePath "&FilePath&"")
			
			If (FSO.FileExists(FilePath)) Then 'Use custom image
				FileLocation(i) = ClientFolder&"/"&FileName(i)
			Else
				FilePath = (server.mappath("/"&GenericFolder&"/"&FileName(i))) 'Use generic image
				If (FSO.FileExists(FilePath)) Then
					FileLocation(i) = "/"&GenericFolder&"/"&FileName(i)
				Else
					FileLocation(i) = ""
				End If
			End If
					
		Next
		

		Set FSO = nothing
		
'--------------------------------------------	

OrderNumber = Clean(Request("OrderNumber"))
TicketNumber = Clean(Request("TicketNumber"))

'Find the OrderNumber for this Ticket.  Check using both OrderNumber and TicketNumber for added security.
SQLOrderNum = "SELECT OrderNumber FROM Ticket (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND TicketNumber = '" & TicketNumber & "'"
Set rsOrderNum = OBJdbConnection.Execute(SQLOrderNum)

If Not rsOrderNum.EOF Then

	'Check the Order for ETicket (ShipCode=13)
    If UCase(Clean(Request("PrintSub"))) <> "Y" Then 'Standard, Print Individual & Child tickets only
    	SQLTix = "SELECT OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipCountry, OrderLine.ShipPostalCode, OrderLine.Price, OrderLine.Discount AS LineDiscount, OrderLine.Price - OrderLine.Discount AS NetPrice, OrderLine.ItemType, OrderHeader.OrderNumber, OrderHeader.Subtotal, OrderHeader.ShipFee, OrderHeader.OrderSurcharge, OrderHeader.Total, OrderHeader.Discount AS OrderDiscount, OrderDate, OrderHeader.OrderTypeNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.Country, Customer.PostalCode, Seat.ItemNumber, Seat.Row, Seat.Seat, Section.SectionCode, Section.Section, Event.EventCode, Event.EventDate, Event.Phone AS EventPhoneNumber, Event.EMailAddress AS EventEMailAddress, Act.Act, Act.Actcode, Act.ShortAct, Act.Comments AS ActComments, Event.Comments AS EventComments, Venue.Venue, Venue.Address_1 AS VenueAddress1, Venue.Address_2 AS VenueAddress2, Venue.City AS VenueCity, Venue.State AS VenueState, Venue.Zip_Code AS VenuePostalCode, SeatType.SeatType, Shipping.ShipType, OrderType, Organization.Organization, Ticket.TicketNumber, ETicketAdPath, ETicketMapPath, ETicketDrivingDirections FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN Shipping (NOLOCK) ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN Section (NOLOCK) ON Seat.SectionCode = Section.SectionCode AND Seat.EventCode = Section.EventCode LEFT JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber INNER JOIN Ticket (NOLOCK) ON OrderLine.ItemNumber = Ticket.ItemNumber AND OrderLine.OrderNumber = Ticket.OrderNumber AND Ticket.StatusCode IN ('A', 'S') INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization (NOLOCK) ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber LEFT JOIN (SELECT EventCode, OptionValue AS ETicketAdPath FROM EventOptions (NOLOCK) WHERE OptionName = 'ETicketAd') AS ETicketAd ON Event.EventCode = ETicketAd.EventCode LEFT JOIN (SELECT EventCode, OptionValue AS ETicketMapPath FROM EventOptions (NOLOCK) WHERE OptionName = 'ETicketMap') AS ETicketMap ON Event.EventCode = ETicketMap.EventCode LEFT JOIN (SELECT EventCode, OptionValue AS ETicketDrivingDirections FROM EventOptions (NOLOCK) WHERE OptionName = 'ETicketDrivingDirections') AS ETicketDrivingDirections ON Event.EventCode = ETicketDrivingDirections.EventCode WHERE OrderLine.OrderNumber = " & rsOrderNum("OrderNumber") & " AND OrderLine.ShipCode = 13 AND Ticket.StatusCode = 'A' AND OrganizationVenue.Owner = 1 AND OrderLine.ItemType IN ('Seat', 'SubSeat')"
    Else 'Request("PrintSub") = "Y", Print Individual, plus only Parent ticket if all Children have same barcode, otherwise Children only (no Parent).
    	SQLTix = "SELECT OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipCountry, OrderLine.ShipPostalCode, OrderLine.Price, OrderLine.Discount AS LineDiscount, OrderLine.Price - OrderLine.Discount AS NetPrice, OrderLine.ItemType, OrderHeader.OrderNumber, OrderHeader.Subtotal, OrderHeader.ShipFee, OrderHeader.OrderSurcharge, OrderHeader.Total, OrderHeader.Discount AS OrderDiscount, OrderDate, OrderHeader.OrderTypeNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.Country, Customer.PostalCode, Seat.ItemNumber, Seat.Row, Seat.Seat, Section.SectionCode, Section.Section, Event.EventCode, Event.EventDate, Event.Phone AS EventPhoneNumber, Event.EMailAddress AS EventEMailAddress, Act.Act, Act.Actcode, Act.ShortAct, Act.Comments AS ActComments, Event.Comments AS EventComments, Venue.Venue, Venue.Address_1 AS VenueAddress1, Venue.Address_2 AS VenueAddress2, Venue.City AS VenueCity, Venue.State AS VenueState, Venue.Zip_Code AS VenuePostalCode, SeatType.SeatType, Shipping.ShipType, OrderType, Organization.Organization, Ticket.TicketNumber, ETicketAdPath, ETicketMapPath, ETicketDrivingDirections FROM (SELECT DISTINCT TicketLine.OrderNumber, TicketLine.LineNumber, CASE WHEN TicketLine.ItemType = 'Seat' THEN 'Seat' WHEN TicketLine.LineNumber = TicketLine.MinTicketMatch AND TicketLine.LineNumber = TicketLine.MaxTicketMatch THEN 'SubFixedEvent' ELSE 'SubSeat' END AS TLItemType, ISNULL(TL2.AvailChildCount,0) AS AvailChildCount FROM (SELECT OrderLine.OrderNumber, OrderLine.LineNumber, OrderLine.ItemType, ISNULL(MIN(CASE TChild.TicketNumber WHEN Ticket.TicketNumber THEN OrderLine.LineNumber ELSE OLChild.LineNumber END), OrderLine.LineNumber) AS MinTicketMatch, ISNULL(MAX(CASE TChild.TicketNumber WHEN Ticket.TicketNumber THEN OrderLine.LineNumber ELSE OLChild.LineNumber END), OrderLine.LineNumber) AS MaxTicketMatch FROM OrderLine (NOLOCK) LEFT JOIN Ticket (NOLOCK) ON OrderLine.ItemNumber = Ticket.ItemNumber AND Ticket.StatusCode IN ('A', 'S') LEFT JOIN OrderLine (NOLOCK) AS OLChild ON OrderLine.OrderNumber = OLChild.OrderNumber AND OrderLine.LineNumber = OLChild.ParentLineNumber LEFT JOIN Ticket (NOLOCK) AS TChild ON OLChild.ItemNumber = TChild.ItemNumber WHERE OrderLine.OrderNumber = " & rsOrderNum("OrderNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') GROUP BY OrderLine.OrderNumber, OrderLine.LineNumber, OrderLine.ItemType) AS TicketLine LEFT JOIN OrderLine (NOLOCK) AS OL ON TicketLine.OrderNumber = OL.OrderNumber AND TicketLine.LineNumber = OL.ParentLineNumber LEFT JOIN (SELECT Ticket.OrderNumber, OrderLine.LineNumber, COUNT(*) AS AvailChildCount FROM Ticket (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON Ticket.OrderNumber = OrderLine.OrderNumber AND Ticket.ItemNumber = OrderLine.ItemNumber INNER JOIN OrderLine (NOLOCK) AS OLC1 ON OrderLine.OrderNumber = OLC1.OrderNumber AND OrderLine.LineNumber = OLC1.ParentLineNumber INNER JOIN Ticket (NOLOCK) AS TC1 ON OLC1.OrderNumber = TC1.OrderNumber AND OLC1.ItemNumber = TC1.ItemNumber WHERE Ticket.OrderNumber = " & rsOrderNum("OrderNumber") & " AND OrderLine.ItemType = 'SubFixedEvent' AND TC1.StatusCode = 'A' GROUP BY Ticket.OrderNumber, OrderLine.LineNumber) AS TL2 ON TicketLine.OrderNumber = TL2.OrderNumber AND TicketLine.LineNumber = TL2.LineNumber) AS TicketLine2 INNER JOIN OrderLine (NOLOCK) ON TicketLine2.OrderNumber = OrderLine.OrderNumber INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN Shipping (NOLOCK) ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN Section (NOLOCK) ON Seat.SectionCode = Section.SectionCode AND Seat.EventCode = Section.EventCode LEFT JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber INNER JOIN Ticket (NOLOCK) ON OrderLine.ItemNumber = Ticket.ItemNumber INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization (NOLOCK) ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber LEFT JOIN (SELECT EventCode, OptionValue AS ETicketAdPath FROM EventOptions (NOLOCK) WHERE OptionName = 'ETicketAd') AS ETicketAd ON Event.EventCode = ETicketAd.EventCode LEFT JOIN (SELECT EventCode, OptionValue AS ETicketMapPath FROM EventOptions (NOLOCK) WHERE OptionName = 'ETicketMap') AS ETicketMap ON Event.EventCode = ETicketMap.EventCode LEFT JOIN (SELECT EventCode, OptionValue AS ETicketDrivingDirections FROM EventOptions (NOLOCK) WHERE OptionName = 'ETicketDrivingDirections') AS ETicketDrivingDirections ON Event.EventCode = ETicketDrivingDirections.EventCode WHERE OrderLine.OrderNumber = " & rsOrderNum("OrderNumber") & " AND ISNULL(OrderLine.ParentLineNumber,OrderLine.LineNumber) = TicketLine2.LineNumber AND TicketLine2.TLItemType = OrderLine.ItemType AND (TLItemType = 'SubFixedEvent' AND (Ticket.StatusCode = 'A' OR AvailChildCount > 0) OR TLItemType <> 'SubFixedEvent' AND Ticket.StatusCode = 'A') AND OrderLine.ShipCode = 13 AND OrganizationVenue.Owner = 1"
    End If
	Set rsTix = OBJdbConnection.Execute(SQLTix)

	If Not rsTix.EOF Then

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


						Response.Write "<CENTER>" & vbCrLf	
						Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""4"" COLOR=""black""><B>THIS IS YOUR TICKET.</B></FONT>&nbsp;&nbsp;<FONT FACE=""Arial, Helvetica"" SIZE=""3"" COLOR=""black"">Present this entire page at the event.</FONT>" & vbCrLf						
						Response.Write "<TABLE  WIDTH=""615"" HEIGHT=""240"" BORDER=""0"" BACKGROUND="" "&FileLocation(1)&" "" BGCOLOR=""#FFD718"" CELLPADDING=""0"" CELLSPACING=""0"">" & vbCrLf
						Response.Write "<TR>" & vbCrLf
						Response.Write "<TD WIDTH=""500"" VALIGN=""top"">" & vbCrLf
						
						Response.Write "<TABLE class=""grayedout"" BORDER=""0"" CELLPADDING=""0"" CELLSPACING=""0"" WIDTH=""100%"">" & vbCrLf
						Response.Write "<TR>" & vbCrLf
						Response.Write "<TD WIDTH=""220"" HEIGHT=""70"" VALIGN=""top"">" & vbCrLf
						Response.Write "<IMG SRC="" "&FileLocation(2)&" "">" & vbCrLf
						Response.Write "</TD>" & vbCrLf
						Response.Write "<TD VALIGN=""top"" ALIGN=""right"">" & vbCrLf
						Response.Write "<FONT FACE=""Verdana,Arial,Helvetica"" SIZE=""1"">" &EventData(1)&"</FONT></TD>" & vbCrLf '********** ADDED FOR TEST DRIVE **********
						Response.Write "</TD>" & vbCrLf
						Response.Write "</TR>" & vbCrLf
						Response.Write "</TABLE>" & vbCrLf
						
						Response.Write "<TABLE class=""grayedout"" BORDER=""0"" CELLPADDING=""0"" CELLSPACING=""0"" WIDTH=""100%"">" & vbCrLf
						Response.Write "<TR>" & vbCrLf
						Response.Write "<TD WIDTH=""20"">" & vbCrLf
						Response.Write "&nbsp;" & vbCrLf
						Response.Write "</TD>" & vbCrLf
						Response.Write "<TD VALIGN=""top"">" & vbCrLf
						
						Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""2""><I>" & rsTix("Organization") & " Presents</I></FONT><BR>" & vbCrLf
						Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""5""><B>" & rsTix("Act") & "</B></FONT><BR>" & vbCrLf
						Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""3""><B>" & rsTix("Venue") & "</B></FONT><BR>" & vbCrLf
						Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""3"">" & FormatDateTime(rsTix("EventDate"), vbLongDate) & " at " & Left(FormatDateTime(rsTix("EventDate"),vbLongTime),Len(FormatDateTime(rsTix("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsTix("EventDate"),vbLongTime),3) & "</FONT><BR><BR>" & vbCrLf
						Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""2"">" & rsTix("SeatType") & "  $" & FormatNumber(rsTix("Price"),2) & "</FONT><BR>" & vbCrLf
						Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""2""><B>Section: " & rsTix("Section") & "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Row: " & rsTix("Row") & "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Seat: " & rsTix("Seat") & "</B></FONT><BR>" & vbCrLf
						Response.Write "</TD>" & vbCrLf
						Response.Write "</TR>" & vbCrLf
						Response.Write "</TABLE>" & vbCrLf
						Response.Write "</TD>" & vbCrLf
			
						Response.Write "</TD>" & vbCrLf
						Response.Write "</TR>" & vbCrLf
						Response.Write "</TABLE>" & vbCrLf
						Response.Write "</TD>" & vbCrLf
					
						Response.Write "<TD ALIGN=""center"" VALIGN=""center"">" & vbCrLf
						Response.Write "<IMG alt=""Barcode Image"" src=""/images/clear.gif"" WIDTH=""150"" HEIGHT=""150"">&nbsp;" & vbCrLf
						Response.Write "</TD>" & vbCrLf
						Response.Write "</TR>" & vbCrLf
					
						Response.Write "<TR>" & vbCrLf
						Response.Write "<TD ALIGN=""center"" COLSPAN=""2"" VALIGN=""bottom"" BGCOLOR=""#000000"" HEIGHT=""20"">" & vbCrLf
						Response.Write "<IMG SRC="" "&FileLocation(3)&" "">" & vbCrLf
						Response.Write "</TD>" & vbCrLf
						Response.Write "</TR>" & vbCrLf
						Response.Write "</TABLE>" & vbCrLf
						
						'Begin Body Space

						Response.Write "<TABLE WIDTH=""620"" BORDER=""0"" class=""whiteout loose"">" & vbCrLf
						Response.Write "<TR>" & vbCrLf
					
						'Begin Left Column
						
						Response.Write "<TD VALIGN=""top"" WIDTH = ""33%"">" & vbCrLf
						Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""2"">" & vbCrLf
						Response.Write "<B>ORDER INFORMATION</B><BR>" & vbCrLf
						Response.Write "Order Number:&nbsp;&nbsp;" & EventData(11) & "<BR>" & vbCrLf
						Response.Write "Order Date:&nbsp;&nbsp;" & EventData(12) & "<BR>" & vbCrLf
						Response.Write "Order Time:&nbsp;&nbsp;" & EventData(13) & "<BR>" & vbCrLf
						Response.Write "Order Total:&nbsp;&nbsp;" & EventData(14) & "<BR>" & vbCrLf
						Response.Write "<BR>" & vbCrLf
						Response.Write "<B>BILLING INFORMATION</B><BR>" & vbCrLf
						Response.Write EventData(15) & "<BR>" & vbCrLf
						Response.Write EventData(16) & "<BR>" & vbCrLf
						Response.Write EventData(17) & "<BR>" & vbCrLf
						Response.Write "<BR>" & vbCrLf
						Response.Write "<B>ATTENDEE INFORMATION</B><BR>" & vbCrLf
						Response.Write EventData(15) & "<BR>" & vbCrLf
						Response.Write EventData(16) & "<BR>" & vbCrLf
						Response.Write EventData(17) & "<BR>" & vbCrLf
						Response.Write "<BR>" & vbCrLf
						Response.Write "</FONT>" & vbCrLf
						Response.Write "</TD>" & vbCrLf
					
						'Begin Middle Column
						
						Response.Write "<TD VALIGN=""top"" WIDTH=""33%"">" & vbCrLf
						Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""2"">" & vbCrLf
						Response.Write "<B>VENUE INFORMATION</B><BR>" & vbCrLf
						Response.Write EventData(3) & "<BR>" & vbCrLf
						
						If EventData(18) <> "" Then
							Response.Write EventData(18) & "<BR>" & vbCrLf
						End If
						
						If EventData(19) <> "" Then
							Response.Write EventData(19) & "<BR>" & vbCrLf
						End If
						
						Response.Write EventData(20) & ", " & EventData(21) & " " & EventData(22)& "<BR>" & vbCrLf
						Response.Write "Phone: " & FormatPhone(EventData(24), "United States") & "<BR>" & vbCrLf
						Response.Write "<BR>" & vbCrLf
						
						If ETicketDrivingDirections <> "" Then
							Response.Write "<B>DRIVING DIRECTIONS</B><BR>" & vbCrLf
							Response.Write ETicketDrivingDirections & vbCrLf
						End If
						
						Response.Write "</FONT>" & vbCrLf
						Response.Write "</TD>" & vbCrLf
						
						'Begin Right Column
						
						Response.Write "<TD VALIGN=""top"" WIDTH=""34%"">" & vbCrLf
						Response.Write "<IMG alt=""Barcode Image"" src=""""><BR>" & vbCrLf
						Response.Write "<BR>" & vbCrLf
						
						If ETicketMapPath <> "" Then
							Response.Write "<IMG SRC="" "&ETicketMapPath&" WIDTH=""200PX"" HEIGHT=""200PX"" "">" & vbCrLf
						Else
							Response.Write "" & vbCrLf
						End If
						
						Response.Write "</FONT>" & vbCrLf
						Response.Write "</TD>" & vbCrLf
						Response.Write "</TR>" & vbCrLf
						Response.Write "</TABLE>" & vbCrLf
						
						'Begin Bottom
						
						Response.Write "<TABLE WIDTH=""620"" BORDER=""0"" class=""whiteout tight"">" & vbCrLf
						Response.Write "<TR>" & vbCrLf
						Response.Write "<TD VALIGN=""top"" WIDTH = ""33%"">" & vbCrLf
						Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""2"">" & vbCrLf			
						Response.Write "<B>GENERAL INFORMATION</B><BR>" & vbCrLf
						Response.Write "</FONT>" & vbCrLf
						Response.Write "</TD>" & vbCrLf
						Response.Write "</TR>" & vbCrLf
						Response.Write "<TR>" & vbCrLf
						Response.Write "<TD VALIGN=""top"" WIDTH = ""33%"">" & vbCrLf
						Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""1"">" & vbCrLf
						Response.Write "NO REFUNDS - NO EXCHANGES.  DO NOT COPY THIS TICKET.  MULTIPLE COPIES INVALID.  Holder assumes all risk and danger including, without limitation, injury, death, personal loss, property damage, or other related harm.  Management reserves the right to refuse admission or eject any person who fails to comply with the terms and conditions and/or rules for the event in which this ticket is issued." & vbCrLf
						Response.Write "</FONT>" & vbCrLf
						Response.Write "</TD>" & vbCrLf
						Response.Write "</TR>" & vbCrLf
						Response.Write "</TABLE>" & vbCrLf
						
						'Begin Horizonal Rule
						
						Response.Write "<TABLE WIDTH=""620"" BORDER=""0"" CELLPADDING=""0"" CELLSPACING=""0"" CLASS=""whiteout"">" & vbCrLf
						Response.Write "<TR>" & vbCrLf
						Response.Write "<TD ALIGN=""center"">" & vbCrLf
						Response.Write "<HR>" & vbCrLf
						Response.Write "</TD>" & vbCrLf
						Response.Write "</TR>" & vbCrLf
						Response.Write "</TABLE>" & vbCrLf
												
						'Begin Ad Space

						Response.Write "<TABLE WIDTH=""620"" BORDER=""0"" CELLPADDING=""0"" CELLSPACING=""0"" CLASS=""whiteout"">" & vbCrLf
						Response.Write "<TR>" & vbCrLf
						Response.Write "<TD ALIGN=""center"">" & vbCrLf
						
						If ETicketAdPath <> "" Then
							Response.Write "<IMG SRC="" "&ETicketAdPath&" "">" & vbCrLf
						Else
							Response.Write "<IMG SRC=""/Images/clear.gif"" HEIGHT=""200"">" & vbCrLf
						End If
						
						Response.Write "</TD>" & vbCrLf
						Response.Write "</TR>" & vbCrLf
						Response.Write "</TABLE>" & vbCrLf
						
						Response.Write "</CENTER>" & vbCrLf	

						Response.Write "</div>" & vbCrLf
						Response.Write "</div>" & vbCrLf

		'End Ad Space
			
			rsTix.MoveNext

            If Not rsTix.EOF Then
				Response.Write "<DIV CLASS=""PageBreak"">&nbsp;</DIV>" 'Page Break
            End If

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
  