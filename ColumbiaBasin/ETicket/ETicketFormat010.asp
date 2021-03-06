<%
'CHANGE LOG
'LSP 06/10/15 - hardcoded directions using if statement. updated the map to be dynamically changed through mgmt
'SSR 07/31/15 - updated script to fix page break issue
%>

<!--#INCLUDE virtual=GlobalInclude.asp -->
<!--#INCLUDE virtual="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL ="ETicketInclude.asp"-->

<%

OrderNumber = CleanNumeric(Request("OrderNumber"))
TicketNumber = Clean(Request("TicketNumber"))


'Find the OrderNumber for this Ticket.  Check using both OrderNumber and TicketNumber for added security.
Set cmd = server.createobject("ADODB.Command")

cmd.ActiveConnection = OBJdbConnection 'connection object already created
SQLOrderNum = "SELECT OrderNumber FROM Ticket (NOLOCK) WHERE OrderNumber = ? AND TicketNumber = ?"

cmd.CommandText = SQLOrderNum
set prmOrderNumber = cmd.CreateParameter("@OrderNumber", 3, 1, 4, CLng(OrderNumber))
cmd.Parameters.Append prmOrderNumber
set prmOrderNumber = cmd.CreateParameter("@TicketNumber", 200, 1, 24, TicketNumber)
cmd.Parameters.Append prmOrderNumber

Set rsOrderNum = cmd.Execute

If Not rsOrderNum.EOF Then

    If UCase(Clean(Request("PrintSub"))) <> "Y" Then 'Standard, Print Individual & Child tickets only
    	SQLTix = "SELECT OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipCountry, OrderLine.ShipPostalCode, OrderLine.Price, OrderLine.Discount AS LineDiscount, OrderLine.Price - OrderLine.Discount AS NetPrice, OrderLine.ItemType, OrderHeader.OrderNumber, OrderHeader.Subtotal, OrderHeader.ShipFee, OrderHeader.OrderSurcharge, OrderHeader.Total, OrderHeader.Discount AS OrderDiscount, OrderDate, OrderHeader.OrderTypeNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.Country, Customer.PostalCode, Seat.ItemNumber, Seat.Row, Seat.Seat, Section.SectionCode, Section.Section, Event.EventCode, Event.EventDate, Event.Phone AS EventPhoneNumber, Event.EMailAddress AS EventEMailAddress, Act.Act, Act.Actcode, Act.ShortAct, Act.Producer, Act.Comments AS ActComments, Event.Comments AS EventComments, Event.Map, Venue.Venue, Venue.Address_1 AS VenueAddress1, Venue.Address_2 AS VenueAddress2, Venue.City AS VenueCity, Venue.State AS VenueState, Venue.Zip_Code AS VenuePostalCode, SeatType.SeatType, Shipping.ShipType, OrderType, Organization.Organization, Ticket.TicketNumber, ETicketAdPath, ETicketMapPath, ETicketDrivingDirections, ETicketGeneralInfo, ETicketBackgroundPath, ETicketLogoPath, ETicketBottomBarPath, TicketText1, TicketText2, TicketText3 FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN Shipping (NOLOCK) ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN Section (NOLOCK) ON Seat.SectionCode = Section.SectionCode AND Seat.EventCode = Section.EventCode LEFT JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber INNER JOIN Ticket (NOLOCK) ON OrderLine.ItemNumber = Ticket.ItemNumber AND OrderLine.OrderNumber = Ticket.OrderNumber AND Ticket.StatusCode IN ('A', 'S') INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization (NOLOCK) ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber LEFT JOIN (SELECT EventCode, OptionValue AS ETicketAdPath FROM EventOptions (NOLOCK) WHERE OptionName = 'ETicketAd') AS ETicketAd ON Event.EventCode = ETicketAd.EventCode LEFT JOIN (SELECT EventCode, OptionValue AS ETicketMapPath FROM EventOptions (NOLOCK) WHERE OptionName = 'ETicketMap') AS ETicketMap ON Event.EventCode = ETicketMap.EventCode LEFT JOIN (SELECT EventCode, OptionValue AS ETicketDrivingDirections FROM EventOptions (NOLOCK) WHERE OptionName = 'ETicketDrivingDirections') AS ETicketDrivingDirections ON Event.EventCode = ETicketDrivingDirections.EventCode LEFT JOIN (SELECT EventCode, OptionValue AS ETicketGeneralInfo FROM EventOptions (NOLOCK) WHERE OptionName = 'ETicketGeneralInfo') AS ETicketGeneralInfo ON Event.EventCode = ETicketGeneralInfo.EventCode LEFT JOIN(SELECT EventCode, OptionValue AS ETicketBackgroundPath FROM EventOptions (NOLOCK) WHERE OptionName = 'ETicketBackground') AS ETicketBackground ON Event.EventCode = ETicketBackground.EventCode LEFT JOIN (SELECT EventCode, OptionValue AS ETicketLogoPath FROM EventOptions (NOLOCK) WHERE OptionName = 'ETicketLogo') AS ETicketLogo ON Event.EventCode = ETicketLogo.EventCode LEFT JOIN (SELECT EventCode, OptionValue AS ETicketBottomBarPath FROM EventOptions (NOLOCK) WHERE OptionName = 'ETicketBottomBar') AS ETicketBottomBar ON Event.EventCode = ETicketBottomBar.EventCode LEFT JOIN (SELECT EventCode, OptionValue AS TicketText1 FROM EventOptions (NOLOCK) WHERE OptionName = 'TicketText1') AS TicketText1 ON Event.EventCode = TicketText1.EventCode LEFT JOIN (SELECT EventCode, OptionValue AS TicketText2 FROM EventOptions (NOLOCK) WHERE OptionName = 'TicketText2') AS TicketText2 ON Event.EventCode = TicketText2.EventCode LEFT JOIN (SELECT EventCode, OptionValue AS TicketText3 FROM EventOptions (NOLOCK) WHERE OptionName = 'TicketText3') AS TicketText3 ON Event.EventCode = TicketText3.EventCode WHERE OrderLine.OrderNumber = " & rsOrderNum("OrderNumber") & " AND OrderLine.ShipCode = 13 AND Ticket.StatusCode = 'A' AND OrganizationVenue.Owner = 1 AND OrderLine.ItemType IN ('Seat', 'SubSeat')"
    Else 'Request("PrintSub") = "Y", Print Individual, plus only Parent ticket if all Children have same barcode, otherwise Children only (no Parent).
    	SQLTix = "SELECT OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipCountry, OrderLine.ShipPostalCode, OrderLine.Price, OrderLine.Discount AS LineDiscount, OrderLine.Price - OrderLine.Discount AS NetPrice, OrderLine.ItemType, OrderHeader.OrderNumber, OrderHeader.Subtotal, OrderHeader.ShipFee, OrderHeader.OrderSurcharge, OrderHeader.Total, OrderHeader.Discount AS OrderDiscount, OrderDate, OrderHeader.OrderTypeNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.Country, Customer.PostalCode, Seat.ItemNumber, Seat.Row, Seat.Seat, Section.SectionCode, Section.Section, Event.EventCode, Event.EventDate, Event.Phone AS EventPhoneNumber, Event.EMailAddress AS EventEMailAddress, Act.Act, Act.Actcode, Act.ShortAct, Act.Producer, Act.Comments AS ActComments, Event.Comments AS EventComments, Event.Map, Venue.Venue, Venue.Address_1 AS VenueAddress1, Venue.Address_2 AS VenueAddress2, Venue.City AS VenueCity, Venue.State AS VenueState, Venue.Zip_Code AS VenuePostalCode, SeatType.SeatType, Shipping.ShipType, OrderType, Organization.Organization, Ticket.TicketNumber, ETicketAdPath, ETicketMapPath, ETicketDrivingDirections, ETicketGeneralInfo, ETicketBackgroundPath, ETicketLogoPath, ETicketBottomBarPath, TicketText1, TicketText2, TicketText3 FROM (SELECT DISTINCT TicketLine.OrderNumber, TicketLine.LineNumber, CASE WHEN TicketLine.ItemType = 'Seat' THEN 'Seat' WHEN TicketLine.LineNumber = TicketLine.MinTicketMatch AND TicketLine.LineNumber = TicketLine.MaxTicketMatch THEN 'SubFixedEvent' ELSE 'SubSeat' END AS TLItemType, ISNULL(TL2.AvailChildCount,0) AS AvailChildCount FROM (SELECT OrderLine.OrderNumber, OrderLine.LineNumber, OrderLine.ItemType, ISNULL(MIN(CASE TChild.TicketNumber WHEN Ticket.TicketNumber THEN OrderLine.LineNumber ELSE OLChild.LineNumber END), OrderLine.LineNumber) AS MinTicketMatch, ISNULL(MAX(CASE TChild.TicketNumber WHEN Ticket.TicketNumber THEN OrderLine.LineNumber ELSE OLChild.LineNumber END), OrderLine.LineNumber) AS MaxTicketMatch FROM OrderLine (NOLOCK) LEFT JOIN Ticket (NOLOCK) ON OrderLine.ItemNumber = Ticket.ItemNumber AND OrderLine.OrderNumber = Ticket.OrderNumber AND Ticket.StatusCode IN ('A', 'S') LEFT JOIN OrderLine (NOLOCK) AS OLChild ON OrderLine.OrderNumber = OLChild.OrderNumber AND OrderLine.LineNumber = OLChild.ParentLineNumber LEFT JOIN Ticket (NOLOCK) AS TChild ON OLChild.ItemNumber = TChild.ItemNumber AND OLChild.OrderNumber = TChild.OrderNumber AND TChild.StatusCode IN ('A', 'S') WHERE OrderLine.OrderNumber = " & rsOrderNum("OrderNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') GROUP BY OrderLine.OrderNumber, OrderLine.LineNumber, OrderLine.ItemType) AS TicketLine LEFT JOIN OrderLine (NOLOCK) AS OL ON TicketLine.OrderNumber = OL.OrderNumber AND TicketLine.LineNumber = OL.ParentLineNumber LEFT JOIN (SELECT Ticket.OrderNumber, OrderLine.LineNumber, COUNT(*) AS AvailChildCount FROM Ticket (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON Ticket.OrderNumber = OrderLine.OrderNumber AND Ticket.ItemNumber = OrderLine.ItemNumber INNER JOIN OrderLine (NOLOCK) AS OLC1 ON OrderLine.OrderNumber = OLC1.OrderNumber AND OrderLine.LineNumber = OLC1.ParentLineNumber INNER JOIN Ticket (NOLOCK) AS TC1 ON OLC1.OrderNumber = TC1.OrderNumber AND OLC1.ItemNumber = TC1.ItemNumber AND TC1.StatusCode IN ('A', 'S') WHERE Ticket.OrderNumber = " & rsOrderNum("OrderNumber") & " AND OrderLine.ItemType = 'SubFixedEvent' AND TC1.StatusCode = 'A' GROUP BY Ticket.OrderNumber, OrderLine.LineNumber) AS TL2 ON TicketLine.OrderNumber = TL2.OrderNumber AND TicketLine.LineNumber = TL2.LineNumber) AS TicketLine2 INNER JOIN OrderLine (NOLOCK) ON TicketLine2.OrderNumber = OrderLine.OrderNumber INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN Shipping (NOLOCK) ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN Section (NOLOCK) ON Seat.SectionCode = Section.SectionCode AND Seat.EventCode = Section.EventCode LEFT JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber INNER JOIN Ticket (NOLOCK) ON OrderLine.ItemNumber = Ticket.ItemNumber AND OrderLine.OrderNumber = Ticket.OrderNumber AND Ticket.StatusCode IN ('A', 'S') INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization (NOLOCK) ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber LEFT JOIN (SELECT EventCode, OptionValue AS ETicketAdPath FROM EventOptions (NOLOCK) WHERE OptionName = 'ETicketAd') AS ETicketAd ON Event.EventCode = ETicketAd.EventCode LEFT JOIN (SELECT EventCode, OptionValue AS ETicketMapPath FROM EventOptions (NOLOCK) WHERE OptionName = 'ETicketMap') AS ETicketMap ON Event.EventCode = ETicketMap.EventCode LEFT JOIN (SELECT EventCode, OptionValue AS ETicketDrivingDirections FROM EventOptions (NOLOCK) WHERE OptionName = 'ETicketDrivingDirections') AS ETicketDrivingDirections ON Event.EventCode = ETicketDrivingDirections.EventCode LEFT JOIN (SELECT EventCode, OptionValue AS ETicketGeneralInfo FROM EventOptions (NOLOCK) WHERE OptionName = 'ETicketGeneralInfo') AS ETicketGeneralInfo ON Event.EventCode = ETicketGeneralInfo.EventCode LEFT JOIN (SELECT EventCode, OptionValue AS ETicketBackgroundPath FROM EventOptions (NOLOCK) WHERE OptionName = 'ETicketBackground') AS ETicketBackground ON Event.EventCode = ETicketBackground.EventCode LEFT JOIN (SELECT EventCode, OptionValue AS ETicketLogoPath FROM EventOptions (NOLOCK) WHERE OptionName = 'ETicketLogo') AS ETicketLogo ON Event.EventCode = ETicketLogo.EventCode LEFT JOIN (SELECT EventCode, OptionValue AS ETicketBottomBarPath FROM EventOptions (NOLOCK) WHERE OptionName = 'ETicketBottomBar') AS ETicketBottomBar ON Event.EventCode = ETicketBottomBar.EventCode LEFT JOIN (SELECT EventCode, OptionValue AS TicketText1 FROM EventOptions (NOLOCK) WHERE OptionName = 'TicketText1') AS TicketText1 ON Event.EventCode = TicketText1.EventCode LEFT JOIN (SELECT EventCode, OptionValue AS TicketText2 FROM EventOptions (NOLOCK) WHERE OptionName = 'TicketText2') AS TicketText2 ON Event.EventCode = TicketText2.EventCode LEFT JOIN (SELECT EventCode, OptionValue AS TicketText3 FROM EventOptions (NOLOCK) WHERE OptionName = 'TicketText3') AS TicketText3 ON Event.EventCode = TicketText3.EventCode WHERE OrderLine.OrderNumber = " & rsOrderNum("OrderNumber") & " AND ISNULL(OrderLine.ParentLineNumber,OrderLine.LineNumber) = TicketLine2.LineNumber AND TicketLine2.TLItemType = OrderLine.ItemType AND (TLItemType = 'SubFixedEvent' AND (Ticket.StatusCode = 'A' OR AvailChildCount > 0) OR TLItemType <> 'SubFixedEvent' AND Ticket.StatusCode = 'A') AND OrderLine.ShipCode = 13 AND OrganizationVenue.Owner = 1"
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


			Response.Write "<TABLE WIDTH=""620"" BORDER=""0"">" & vbCrLf
            Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""4""><B>THIS IS YOUR TICKET.  " & "<FONT FACE=""Arial, Helvetica"" SIZE=""3"">Present this entire page at the event.</B></FONT>" & vbCrLf 
			Response.Write "<BR>" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD VALIGN=""top"">" & vbCrLf
			Response.Write "<TABLE WIDTH=""615"" HEIGHT=""240"" BORDER=""1"" BACKGROUND=""/Images/ETicketBackground.gif"" BGCOLOR=""#FFD718"" CELLPADDING=""0"" CELLSPACING=""0"">" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD WIDTH=""500"" VALIGN=""top"">" & vbCrLf
			Response.Write "<TABLE BORDER=""0"" CELLPADDING=""0"" CELLSPACING=""0"" WIDTH=""100%"">" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD WIDTH=""220"" HEIGHT=""70"" VALIGN=""top"">" & vbCrLf
			Response.Write "<IMG SRC=""/Images/ETicketLogo.gif"">" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			Response.Write "<TD VALIGN=""top"" ALIGN=""right"">" & vbCrLf
			'REE 7/8/6 - Modified to allow flexible length ticket numbers.  Insert dash after every 4th digit.
			TicketDigit = 1
			ETicketNumber = ""
			Do Until TicketDigit >= Len(rsTix("TicketNumber"))
				If TicketDigit < Len(rsTix("TicketNumber")) - 4 Then
					ETicketNumber = ETicketNumber & Mid(rsTix("TicketNumber"), TicketDigit, 4) & "-"
					TicketDigit = TicketDigit + 4
				Else
					ETicketNumber = ETicketNumber & Mid(rsTix("TicketNumber"), TicketDigit, (Len(rsTix("TicketNumber")) - TicketDigit) + 1)
					TicketDigit = Len(rsTix("TicketNumber"))
				End If
			Loop
			Response.Write "<FONT FACE=""Verdana,Arial,Helvetica"" SIZE=""1"">" & ETicketNumber & "&nbsp;&nbsp;&nbsp;&nbsp;" & rsTix("OrderNumber") & " - " & rsTix("ItemNumber") & "</FONT></TD>" & vbCrLf '********** ADDED FOR TEST DRIVE **********
					
			Response.Write "</TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf
			Response.Write "<TABLE BORDER=""0"" CELLPADDING=""0"" CELLSPACING=""0"" WIDTH=""100%"">" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD WIDTH=""20"">" & vbCrLf
			Response.Write "&nbsp;" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			Response.Write "<TD VALIGN=""top"">" & vbCrLf
			Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""2""><I>" & rsTix("Organization") & " Presents</I></FONT><BR>" & vbCrLf
			Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""3""><B>" & rsTix("Act") & "</B></FONT><BR>" & vbCrLf
			Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""2""><B>" & rsTix("Venue") & "</B></FONT><BR>" & vbCrLf
			Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""2"">" & FormatDateTime(rsTix("EventDate"), vbLongDate) & " at " & Left(FormatDateTime(rsTix("EventDate"),vbLongTime),Len(FormatDateTime(rsTix("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsTix("EventDate"),vbLongTime),3) & "</FONT><BR><BR>" & vbCrLf
			Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""2"">" & rsTix("SeatType") & "  $" & FormatNumber(rsTix("Price"),2) & "</FONT><BR>" & vbCrLf
			Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""2""><B>Section: " & rsTix("Section") & "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Row: " & rsTix("Row") & "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Seat: " & rsTix("Seat") & "</B></FONT><BR>" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf
			Response.Write "</TD>" & vbCrLf
									
			Response.Write "<TD ALIGN=""center"" VALIGN=""center"">" & vbCrLf
		
			Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""1""><B>" & rsTix("ShortAct") & "</B></FONT><BR>" & vbCrLf
			Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""1""><B>" & rsTix("Venue") & "</B></FONT><BR>" & vbCrLf
			Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""1"">" & FormatDateTime(rsTix("EventDate"), vbLongDate) & " at " & Left(FormatDateTime(rsTix("EventDate"),vbLongTime),Len(FormatDateTime(rsTix("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsTix("EventDate"),vbLongTime),3) & "</FONT><BR><BR>" & vbCrLf
			Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""1"">" & rsTix("SeatType") & "  $" & FormatNumber(rsTix("Price"),2) & "</FONT><BR>" & vbCrLf
			Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""1""><B>Section: " & rsTix("Section") & "<BR>Row: " & rsTix("Row") & "<BR>Seat: " & rsTix("Seat") & "</B></FONT><BR>" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf
					  
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD ALIGN=""center"" COLSPAN=""2"" VALIGN=""bottom"" BGCOLOR=""#000000"" HEIGHT=""20"">" & vbCrLf
		'ETicket Bottom Bar Path
			If Not IsNull(rsTix("ETicketBottomBarPath")) Then
			    Response.Write "<IMG SRC=""" & rsTix("ETicketBottomBarPath") & """ width=""614"" height=""27"">" & vbCrLf
            Else
			    Response.Write "<IMG SRC=""/Images/ETicketBottomBar.gif"">" & vbCrLf
            End If
			Response.Write "</TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf

		'End Ticket

		'Begin Body Space

			Response.Write "<TABLE WIDTH=""620"" BORDER=""0"">" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			
			'Begin Left Column
			Response.Write "<TD VALIGN=""top"" WIDTH = ""33%"">" & vbCrLf
			Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""2"">" & vbCrLf
			Response.Write "<B>ORDER INFORMATION</B><BR>" & vbCrLf
			Response.Write "Order Number:&nbsp;&nbsp;" & rsTix("OrderNumber") & "<BR>" & vbCrLf
			Response.Write "Order Date:&nbsp;&nbsp;" & FormatDateTime(rsTix("OrderDate"), vbShortDate) & "<BR>" & vbCrLf
			Response.Write "Order Time:&nbsp;&nbsp;" & FormatDateTime(rsTix("OrderDate"), vbShortTime) & "<BR>" & vbCrLf
			Response.Write "Order Total:&nbsp;&nbsp;" & FormatCurrency(rsTix("Total"),2)& "<BR>" & vbCrLf
			Response.Write "<BR>" & vbCrLf
			Response.Write "<B>BILLING INFORMATION</B><BR>" & vbCrLf
			Response.Write rsTix("FirstName") & " " & rsTix("LastName") & "<BR>" & vbCrLf
			Response.Write rsTix("Address1") & "<BR>" & vbCrLf
			If rsTix("Address2") <> "" Then
				Response.Write rsTix("Address2") & "<BR>" & vbCrLf
			End If
			Response.Write rsTix("City") & ", " & rsTix("State") & " " & rsTix("PostalCode") & "<BR>" & vbCrLf
			Response.Write "<BR>" & vbCrLf
			Response.Write "<B>ATTENDEE INFORMATION</B><BR>" & vbCrLf
			Response.Write rsTix("ShipFirstName") & " " & rsTix("ShipLastName") & "<BR>" & vbCrLf
			Response.Write rsTix("ShipAddress1") & "<BR>" & vbCrLf
			If rsTix("ShipAddress2") <> "" Then
				Response.Write rsTix("ShipAddress2") & "<BR>" & vbCrLf
			End If
			Response.Write rsTix("ShipCity") & ", " & rsTix("ShipState") & " " & rsTix("ShipPostalCode") & "<BR>" & vbCrLf
			Response.Write "<BR>" & vbCrLf
			Response.Write "</FONT>" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			
			'Begin Middle Column
			Response.Write "<TD VALIGN=""top"" WIDTH=""33%"">" & vbCrLf
			Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""2"">" & vbCrLf
			Response.Write "<B>VENUE INFORMATION</B><BR>" & vbCrLf
			Response.Write rsTix("Venue") & "<BR>" & vbCrLf
			Response.Write rsTix("VenueAddress1") & "<BR>" & vbCrLf
			If rsTix("VenueAddress2") <> "" Then
				Response.Write rsTix("VenueAddress2") & "<BR>" & vbCrLf
			End If
			Response.Write rsTix("VenueCity") & ", " & rsTix("VenueState") & " " & rsTix("VenuePostalCode") & "<BR>" & vbCrLf
			Response.Write "Phone: " & FormatPhone(rsTix("EventPhoneNumber"), "United States") & "<BR>" & vbCrLf
			Response.Write "<BR>" & vbCrLf
			Response.Write "</FONT>" & vbCrLf
					Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""2"">" & vbCrLf

			Response.Write "<B>DIRECTIONS</B><BR>" & vbCrLf
			Response.Write "</FONT>" & vbCrLf
			Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""1"">" & vbCrLf
			
						Select Case rsTix("EventCode") 
			  
			    Case "759156","759157"
				    Directions1 = "From I-182 take exit 12B<BR>Turn onto 20th Ave., head North<BR>Turn left onto campus, at light (Sun Willows Blvd)<BR>Follow road around campus<BR>At stop sign turn right<BR>P-building is the three story concrete building on the right<BR>Outdoor Theatre is located outside, west of the P-building"
					
				 Case "750179","754171","754172","754173","754178","754174","754175","754176","754177"
			
				    Directions1 = "From I-182 take exit 12B<BR>Turn onto 20th Ave., head North<BR>Turn left onto campus, at light (Sun Willows Blvd)<BR>Follow road around campus<BR>At stop sign turn right<BR>P-building is the three story concrete building on the right"	
				Case "768831","768832"
				    Directions1 = "From I-182 take exit 12B<BR>Turn onto 20th Ave., head North<BR>Turn left onto Argent St., at  2nd light<BR>Turn left onto Saraceno Way, at light<BR>Turn right at round about and then left <BR>The parking lot is to the left<BR>The H-building is strait in front of you<BR>The Gjerde Center will be to your left as you enter"
			  
				Case Else 'Default Advertisting Image
				    Directions1 = "&nbsp;"
	        End Select	
			
			
			Response.Write ""& Directions1 & "" & vbCrLf
			
			Response.Write "</TD>" & vbCrLf
			
			'Begin Right Column
			Response.Write "<TD VALIGN=""top"" WIDTH=""34%"">" & vbCrLf
			Response.Write "<IMG alt=""Barcode Image"" src=""/Barcode.asp?Barcode=" & rsTix("TicketNumber") & """><BR>" & vbCrLf
			Response.Write "<BR>" & vbCrLf
				Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""2"">" & vbCrLf

			Response.Write "<B>MAP</B><BR>" & vbCrLf
			Response.Write "</FONT>" & vbCrLf
		Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""2"">" & vbCrLf
		
	
						
			'Response.Write "<IMG SRC = ""/Clients/ColumbiaBasin/ETicket/Images/CBCTixMap.jpg"">" & vbCrLf
					   If Not IsNull(rsTix("ETicketMapPath")) Then
    			Response.Write "<IMG SRC=""" & rsTix("ETicketMapPath") & """>" & vbCrLf
            End If
			
			Response.Write "</FONT>" & vbCrLf
			Response.Write "</FONT>" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf
			Response.Write "<TABLE WIDTH=""620"" BORDER=""0"" CELLPADDING=""0"" CELLSPACING=""0"">" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD>" & vbCrLf
			Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""2"">" & vbCrLf
			Response.Write "<B>GENERAL INFORMATION</B><BR>" & vbCrLf
			Response.Write "</FONT>" & vbCrLf
			Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""1"">" & vbCrLf
			Response.Write "NO REFUNDS. All ticket sales are final. DO NOT COPY THIS TICKET. MULTIPLE COPIES INVALID.<BR><BR>SEATING AFTER CURTAIN TIME IS NOT GAURANTEED. Once the performance has started, it may not be possible to seat late arriving patrons or those leaving their seats for other reasons. The CBC Arts Center accepts no responsibility for inconvenience to latecomers or people leaving their seats.  CHILDREN under seven-years-old, babes in arms, and pets are NOT ALLOWED.  We reserve the right to ask you to leave for disruptive behavior.  If you have not arrived by the time the show starts we reserve the right to RESELL YOUR SEAT, with no refund.<BR><BR>EXCHANGES, contact the CBC Arts Center at 509.542.5531.  The management reserves the right to revoke the license granted by this ticket by refunding the purchase price.<BR><BR> " & vbCrLf
			Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""1"">" & rsTix("TicketText3") & "</FONT><BR>" & vbCrLf
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

		'Begin Ad Space

			Response.Write "<TABLE WIDTH=""620"" BORDER=""0"" CELLPADDING=""0"" CELLSPACING=""0"">" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD ALIGN=""center"">" & vbCrLf
			Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""2"">" & vbCrLf
			Response.Write "<B>Thank you, from the CBC Arts Center!</B><BR>" & vbCrLf
			Response.Write "</FONT>" & vbCrLf
			Response.Write "<IMG SRC=""/clients/ColumbiaBasin/ETicket/Images/NewCBClogomonocompact.jpg "" >" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf

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
  