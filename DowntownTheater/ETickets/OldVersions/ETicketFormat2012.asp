<%

'CHANGE LOG

'SSR 10/31/2012 - Per Silvia: added TicketText options to generic script

'SSR 10/25/2012 - Boerne PAC: added option for multiple ETicketAd based on ActCode.

'SSR 10/17/12 - Green Frog Music: added option for customizable ETicketBackground, ETicketBottomBar and .ETicketLogo.

'SSR 10/16/12 - Idaho Regional Ballet: added option for customizable ETicketAd (single).

'JAI 7/30/12 - Added ability to consolidate e-tickets if Subscription parent and children all have same barcode. Request("PrintSub") = "Y"

%>

<!--#INCLUDE virtual=GlobalInclude.asp -->
<!--#INCLUDE virtual="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL ="ETicketInclude.asp"-->

<%

OrderNumber = Clean(Request("OrderNumber"))
TicketNumber = Clean(Request("TicketNumber"))

'===============================================
'Options
'===============================================

'E-Ticket Logo:

TicketLogo = "Tix"

'Options:

'TicketLogo = "Tix" (tix logo - Gold version- default)
'TicketLogo = "TixGray" (tix logo - Gray version)
'TicketLogo = "" (tix logo not displayed)
'TicketLogo = "images/logo.gif" (custom logo - expected size: 215x68)

'----------------------

'E-Ticket Background:

TicketBackground = "Tix"

'Options:

'TicketBackground = "Tix" (tix background - Gold version - default)
'TicketBackground = "TixGray" (tix background - Gray version)
'TicketBackground = "TixWhite" (tix background - White version)
'TicketBackground = "" = (background not displayed)
'TicketBackground = "images/background.gif" (custom background)

'----------------------

'E-Ticket BottomBar:

TicketBottomBar = "Tix"

'Options:

'TicketBottomBar = "Tix" (tix bottom-bar - default)
'TicketBottomBar = "" = (tix bottom-bar not displayed)
'TicketBottomBar = "images/logo.gif" (custom bottom-bar)

'----------------------

'E-Ticket Ad Option
'images located in T:/Clients/OrgName/ETickets/Images

ShowEventAd = False
ShowActAd = False
ShowAd = False

Dim RequiredItem(3)
Dim  DisplayItem(3)

RequiredItem(1) = 512594  'Drumline Live
DisplayItem(1) = "SodaPops.jpg"

RequiredItem(2) = 512610 '5 Browns
DisplayItem(2) = "Browns.jpg"


RequiredItem(3) = 512612 'Celtic Nights
DisplayItem(3) = "Celtic.jpg"

'----------------------

'E-Ticket Text

'Options:  Use ETicketText(1), ETicketText(2), ETicketText(3) variables to display data from TicketText1, TicketText2, TicketText3 fields in EventOptions table

DIM OptionName(4), ETicketText(4)

OptionName(1) = "TicketText1"
OptionName(2) = "TicketText2"
OptionName(3) = "TicketText3"

SQLVerifyEvent = "SELECT Event.EventCode FROM Event (NOLOCK) INNER JOIN Seat on Event.EventCode = Seat.EventCode INNER JOIN OrderLine on Seat.ItemNumber = OrderLine.ItemNumber WHERE OrderLine.OrderNumber = " &  OrderNumber & ""
Set rsVerifyEvent = OBJdbConnection.Execute(SQLVerifyEvent)

	 If NOT rsVerifyEvent.EOF Then 
	 
		For i = LBound(OptionName) to UBound(OptionName)

		SQLVerifyOption = "SELECT OptionName FROM EventOptions WHERE EventOptions.OptionName = '" &  OptionName(i)  & "' AND EventOptions.EventCode = " &  rsVerifyEvent("EventCode")  & ""
		Set rsVerifyOption = OBJdbConnection.Execute(SQLVerifyOption)

			If NOT rsVerifyOption.EOF Then     
	 
				SQLCustomText = "SELECT OptionValue FROM EventOptions WHERE EventOptions.OptionName = '" &  OptionName(i)  & "' AND EventOptions.EventCode = " &  rsVerifyEvent("EventCode")  & ""
				Set rsCustomText = OBJdbConnection.Execute(SQLCustomText)
				
				 If rsCustomText("OptionValue") <> "" Then 
					ETicketText(i) = rsCustomText("OptionValue")
				 End If
	 
				rsCustomText.Close
				Set rsCustomText = nothing

			End If	
			
		Next
			
	End If	
			
	rsVerifyOption.Close
	Set rsVerifyOption = nothing

rsVerifyEvent.Close
Set rsVerifyEvent = nothing


'----------------------

'===============================================

'Find the OrderNumber for this Ticket.  
'Check using both OrderNumber and TicketNumber for added security.

SQLOrderNum = "SELECT OrderNumber FROM Ticket (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND TicketNumber = '" & TicketNumber & "'"
Set rsOrderNum = OBJdbConnection.Execute(SQLOrderNum)

If Not rsOrderNum.EOF Then

	'Check the Order for ETicket (ShipCode=13)
    If UCase(Clean(Request("PrintSub"))) <> "Y" Then 'Standard, Print Individual & Child tickets only
    	SQLTix = "SELECT OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipCountry, OrderLine.ShipPostalCode, OrderLine.Price, OrderLine.Discount AS LineDiscount, OrderLine.Price - OrderLine.Discount AS NetPrice, OrderLine.ItemType, OrderHeader.OrderNumber, OrderHeader.Subtotal, OrderHeader.ShipFee, OrderHeader.OrderSurcharge, OrderHeader.Total, OrderHeader.Discount AS OrderDiscount, OrderDate, OrderHeader.OrderTypeNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.Country, Customer.PostalCode, Seat.ItemNumber, Seat.Row, Seat.Seat, Section.SectionCode, Section.Section, Event.EventCode, Event.EventDate, Event.Phone AS EventPhoneNumber, Event.EMailAddress AS EventEMailAddress, Act.Act, Act.Actcode, Act.ShortAct, Act.Comments AS ActComments, Event.Comments AS EventComments, Venue.Venue, Venue.Address_1 AS VenueAddress1, Venue.Address_2 AS VenueAddress2, Venue.City AS VenueCity, Venue.State AS VenueState, Venue.Zip_Code AS VenuePostalCode, SeatType.SeatType, Shipping.ShipType, OrderType, Organization.Organization, Ticket.TicketNumber FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN Shipping (NOLOCK) ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN Section (NOLOCK) ON Seat.SectionCode = Section.SectionCode AND Seat.EventCode = Section.EventCode LEFT JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber INNER JOIN Ticket (NOLOCK) ON OrderLine.ItemNumber = Ticket.ItemNumber INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization (NOLOCK) ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber WHERE OrderLine.OrderNumber = " & rsOrderNum("OrderNumber") & " AND OrderLine.ShipCode = 13 AND Ticket.StatusCode = 'A' AND OrganizationVenue.Owner = 1 AND OrderLine.ItemType IN ('Seat', 'SubSeat')"
    Else 'Request("PrintSub") = "Y", Print Individual, plus only Parent ticket if all Children have same barcode, otherwise Children only (no Parent).
    	SQLTix = "SELECT OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipCountry, OrderLine.ShipPostalCode, OrderLine.Price, OrderLine.Discount AS LineDiscount, OrderLine.Price - OrderLine.Discount AS NetPrice, OrderLine.ItemType, OrderHeader.OrderNumber, OrderHeader.Subtotal, OrderHeader.ShipFee, OrderHeader.OrderSurcharge, OrderHeader.Total, OrderHeader.Discount AS OrderDiscount, OrderDate, OrderHeader.OrderTypeNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.Country, Customer.PostalCode, Seat.ItemNumber, Seat.Row, Seat.Seat, Section.SectionCode, Section.Section, Event.EventCode, Event.EventDate, Event.Phone AS EventPhoneNumber, Event.EMailAddress AS EventEMailAddress, Act.Act, Act.Actcode, Act.ShortAct, Act.Comments AS ActComments, Event.Comments AS EventComments, Venue.Venue, Venue.Address_1 AS VenueAddress1, Venue.Address_2 AS VenueAddress2, Venue.City AS VenueCity, Venue.State AS VenueState, Venue.Zip_Code AS VenuePostalCode, SeatType.SeatType, Shipping.ShipType, OrderType, Organization.Organization, Ticket.TicketNumber FROM (SELECT DISTINCT TicketLine.OrderNumber, TicketLine.LineNumber, CASE WHEN TicketLine.ItemType = 'Seat' THEN 'Seat' WHEN TicketLine.LineNumber = TicketLine.MinTicketMatch AND TicketLine.LineNumber = TicketLine.MaxTicketMatch THEN 'SubFixedEvent' ELSE 'SubSeat' END AS TLItemType, ISNULL(TL2.AvailChildCount,0) AS AvailChildCount FROM (SELECT OrderLine.OrderNumber, OrderLine.LineNumber, OrderLine.ItemType, ISNULL(MIN(CASE TChild.TicketNumber WHEN Ticket.TicketNumber THEN OrderLine.LineNumber ELSE OLChild.LineNumber END), OrderLine.LineNumber) AS MinTicketMatch, ISNULL(MAX(CASE TChild.TicketNumber WHEN Ticket.TicketNumber THEN OrderLine.LineNumber ELSE OLChild.LineNumber END), OrderLine.LineNumber) AS MaxTicketMatch FROM OrderLine (NOLOCK) LEFT JOIN Ticket (NOLOCK) ON OrderLine.ItemNumber = Ticket.ItemNumber AND Ticket.StatusCode IN ('A', 'S') LEFT JOIN OrderLine (NOLOCK) AS OLChild ON OrderLine.OrderNumber = OLChild.OrderNumber AND OrderLine.LineNumber = OLChild.ParentLineNumber LEFT JOIN Ticket (NOLOCK) AS TChild ON OLChild.ItemNumber = TChild.ItemNumber WHERE OrderLine.OrderNumber = " & rsOrderNum("OrderNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') GROUP BY OrderLine.OrderNumber, OrderLine.LineNumber, OrderLine.ItemType) AS TicketLine LEFT JOIN OrderLine (NOLOCK) AS OL ON TicketLine.OrderNumber = OL.OrderNumber AND TicketLine.LineNumber = OL.ParentLineNumber LEFT JOIN (SELECT Ticket.OrderNumber, OrderLine.LineNumber, COUNT(*) AS AvailChildCount FROM Ticket (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON Ticket.OrderNumber = OrderLine.OrderNumber AND Ticket.ItemNumber = OrderLine.ItemNumber INNER JOIN OrderLine (NOLOCK) AS OLC1 ON OrderLine.OrderNumber = OLC1.OrderNumber AND OrderLine.LineNumber = OLC1.ParentLineNumber INNER JOIN Ticket (NOLOCK) AS TC1 ON OLC1.OrderNumber = TC1.OrderNumber AND OLC1.ItemNumber = TC1.ItemNumber WHERE Ticket.OrderNumber = " & rsOrderNum("OrderNumber") & " AND OrderLine.ItemType = 'SubFixedEvent' AND TC1.StatusCode = 'A' GROUP BY Ticket.OrderNumber, OrderLine.LineNumber) AS TL2 ON TicketLine.OrderNumber = TL2.OrderNumber AND TicketLine.LineNumber = TL2.LineNumber) AS TicketLine2 INNER JOIN OrderLine (NOLOCK) ON TicketLine2.OrderNumber = OrderLine.OrderNumber INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN Shipping (NOLOCK) ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN Section (NOLOCK) ON Seat.SectionCode = Section.SectionCode AND Seat.EventCode = Section.EventCode LEFT JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber INNER JOIN Ticket (NOLOCK) ON OrderLine.ItemNumber = Ticket.ItemNumber INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization (NOLOCK) ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber WHERE OrderLine.OrderNumber = " & rsOrderNum("OrderNumber") & " AND ISNULL(OrderLine.ParentLineNumber,OrderLine.LineNumber) = TicketLine2.LineNumber AND TicketLine2.TLItemType = OrderLine.ItemType AND (TLItemType = 'SubFixedEvent' AND (Ticket.StatusCode = 'A' OR AvailChildCount > 0) OR TLItemType <> 'SubFixedEvent' AND Ticket.StatusCode = 'A') AND OrderLine.ShipCode = 13 AND OrganizationVenue.Owner = 1"
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
			
			ETicketBackground = "/Images/ETicketBackground.gif"

			If TicketBackground  = "" Then
				ETicketBackground = ""
			ElseIf TicketBackground = "Tix" Then
				ETicketBackground = "/Images/ETicketBackground.gif"
			ElseIf TicketBackground = "TixGray" Then
				ETicketBackground = "/Images/ETicketBackgroundGray.gif"
			ElseIf TicketBackground = "TixWhite" Then
				ETicketBackground = "/Images/ETicketBackgroundWhite.gif"
			Else
				ETicketBackground = TicketBackground
			End If

			Response.Write "<TABLE WIDTH=""615"" HEIGHT=""240"" BORDER=""1"" BACKGROUND=""" & ETicketBackground & """ BGCOLOR=""#FFD718"" CELLPADDING=""0"" CELLSPACING=""0"">" & vbCrLf   
			
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD WIDTH=""500"" VALIGN=""top"">" & vbCrLf
			Response.Write "<TABLE BORDER=""0"" CELLPADDING=""0"" CELLSPACING=""0"" WIDTH=""100%"">" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD WIDTH=""220"" HEIGHT=""70"" VALIGN=""top"">" & vbCrLf
			
			'---------------------
			'Custom Logo Option 
			'---------------------

			ETicketLogo = "/Images/ETicketLogo.gif"

			If TicketLogo  = "" Then
				ETicketLogo = ""
			ElseIf TicketLogo = "Tix" Then
				ETicketLogo = "/Images/ETicketLogo.gif"
			ElseIf TicketLogo = "TixGray" Then
				ETicketLogo = "/Images/ETicketLogoGray.gif"
			Else
				ETicketLogo = TicketLogo
			End If
				
			Response.Write "<IMG SRC=""" & ETicketLogo & """>" & vbCrLf 
						
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
			Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""5""><B>" & rsTix("Act") & "</B></FONT><BR>" & vbCrLf
			Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""3""><B>" & rsTix("Venue") & "</B></FONT><BR>" & vbCrLf
			Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""3"">" & FormatDateTime(rsTix("EventDate"), vbLongDate) & " at " & Left(FormatDateTime(rsTix("EventDate"),vbLongTime),Len(FormatDateTime(rsTix("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsTix("EventDate"),vbLongTime),3) & "</FONT><BR><BR>" & vbCrLf
			Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""2"">" & rsTix("SeatType") & "  $" & FormatNumber(rsTix("Price"),2) & "</FONT><BR>" & vbCrLf
			Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""2""><B>Section: " & rsTix("Section") & "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Row: " & rsTix("Row") & "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Seat: " & rsTix("Seat") & "</B></FONT><BR>" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf
			Response.Write "</TD>" & vbCrLf
									
			Response.Write "<TD ALIGN=""center"" VALIGN=""center"">" & vbCrLf
			Response.Write "<IMG alt=""Barcode Image"" src=""/Barcode.asp?Barcode=" & rsTix("TicketNumber") & "&Rotate=270"">&nbsp;" & vbCrLf
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

			Response.Write "<TABLE WIDTH=""620"" CELLSPACING=""0"" CELLPADDING=""0"" BORDER=""1"">" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD>" & vbCrLf
		
		%>
				
		<div id="groups">

		<p>
		<h3>ORDER INFORMATION</h3>
		Order Number: <%=rsTix("OrderNumber")%><BR>
		Order Date: <%=FormatDateTime(rsTix("OrderDate"), vbShortDate)%><BR>
		Order Time: <%=FormatDateTime(rsTix("OrderDate"), vbShortTime) %><BR>
		Order Total:<%=FormatCurrency(rsTix("Total"),2)%><BR>
		</p>

		<p>
		<h3>BILLING INFORMATION</h3>
		<%=rsTix("FirstName")%>&nbsp;<%=rsTix("LastName")%><BR>
		<%=rsTix("Address1") %><BR>

		<%
		If rsTix("Address2") <> "" Then
			Response.Write rsTix("Address2") & "<BR>" & vbCrLf
		End If
		%>
					
		<%=rsTix("City")%>,&nbsp;<%=rsTix("State")%>&nbsp;<%=rsTix("PostalCode")%>
		</p>

		<p>
		<h3>ATTENDEE INFORMATION</h3>
		<%=rsTix("ShipFirstName")%>&nbsp;<%=rsTix("ShipLastName")%><BR>
		<%=rsTix("ShipAddress1")%><BR>
		
		<%
		If rsTix("ShipAddress2") <> "" Then
		Response.Write rsTix("ShipAddress2") & "<BR>" & vbCrLf
		End If
		%>
		
		<%=rsTix("ShipCity")%>,&nbsp;<%=rsTix("ShipState")%>&nbsp;<%=rsTix("ShipPostalCode")%><BR>
		</p>
				
		<p>
		<h3>VENUE INFORMATION</h3>
		<%=rsTix("Venue")%><BR>
		<%=rsTix("VenueAddress1")%><BR>

		<%
		If rsTix("VenueAddress2") <> "" Then
			Response.Write rsTix("VenueAddress2") & "<BR>" & vbCrLf
		End If
		%>

		<%=rsTix("VenueCity")%>,&nbsp;<%=rsTix("VenueState")%>&nbsp;<%=rsTix("VenuePostalCode")%><BR>
		
		<%
		If rsTix("EventPhoneNumber") <> "" Then
			Response.Write "Phone: " & FormatPhone(rsTix("EventPhoneNumber"), "United States") & "<BR>" & vbCrLf
		End If
		%>
		</p>
				
		<p>
		<IMG alt="Barcode Image" src="/Barcode.asp?Barcode=<%=rsTix("TicketNumber") %>"><BR>
		</p>
				
		<p>
		<h3>PARKING INFORMATION</h3>
		Parking at Lincoln Garage. BSU Lincoln Ave Garage is located across from the Student Union Building (SUB) at the corner of University Dr and Lincoln Ave.  Parking spaces are numbered throughout the structures. Customers without a Reserve Permit for the respective garage are to pre-pay for parking at any pay-by-space unit on any level of the Garage. Garages are available 24 hours per day, 7 days a week and are always pay-by-space or permit only unless otherwise posted.  Make a note of your parking space number before you leave your car.  You will need to enter the number to pay for parking.
		</p>
				
		</div>		
				
		<%
		
		Response.Write "</TD>" & vbCrLf
		Response.Write "</TR>" & vbCrLf
		Response.Write "</TABLE>" & vbCrLf

		'End Body Space
		
		'Begin General Information
		
		Response.Write "<TABLE WIDTH=""620"" BORDER=""1"" CELLPADDING=""0"" CELLSPACING=""0"">" & vbCrLf
		Response.Write "<TR>" & vbCrLf
		Response.Write "<TD>" & vbCrLf
		Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""2"">" & vbCrLf
		Response.Write "<B>GENERAL INFORMATION</B><BR>" & vbCrLf
		Response.Write "</FONT>" & vbCrLf
		Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""1"">" & vbCrLf
		Response.Write "NO REFUNDS - NO EXCHANGES.  DO NOT COPY THIS TICKET.  MULTIPLE COPIES INVALID.  Holder assumes all risk and danger including, without limitation, injury, death, personal loss, property damage, or other related harm.  Management reserves the right to refuse admission or eject any person who fails to comply with the terms and conditions and/or rules for the event in which this ticket is issued." & vbCrLf
		Response.Write "</FONT>" & vbCrLf
		Response.Write "</TD>" & vbCrLf
		Response.Write "</TR>" & vbCrLf
		Response.Write "</TABLE>" & vbCrLf
		
		'End General Information

'==============================
'Ad Space
'==============================

            ETicketAd = "/Images/TixLogo300x225.jpg"

			If ShowEventAd Then
			
				For i = LBound(RequiredItem) to UBound(RequiredItem)
					If rsTIX("EventCode") =  RequiredItem(i) Then
						ETicketAd = DisplayItem(i)
					End If
				Next
			
			ElseIf ShowActAd Then
			
				For i = LBound(RequiredItem) to UBound(RequiredItem)
					If rsTIX("ActCode") =  RequiredItem(i) Then
						ETicketAd = DisplayItem(i)
					End If
				Next
				
			Else
			
				If TicketAd  = "" Then
					ETicketAd = ""
				ElseIf TicketAd = "Tix" Then
					ETicketAd = "/Images/TixLogo300x225.jpg"
				Else
					ETicketAd = TicketAd
				End If
				
			End if

            Response.Write "<TABLE WIDTH=""620"" BORDER=""0"" CELLPADDING=""0"" CELLSPACING=""0"">" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD ALIGN=""center"">" & vbCrLf
			Response.Write "<IMG src=""" & ETicketAd & """ border=""0"" Height=""250"">" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf 

'==============================
'End Ad Space
'==============================
			
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

'===============================================

'Customer Name Formating (Proper Case)

Function PCase(ByVal strInput)' As String
     Dim I 'As Integer
     Dim CurrentChar, PrevChar 'As Char
     Dim strOutput 'As String

     PrevChar = ""
     strOutput = ""

     For I = 1 To Len(strInput)
         CurrentChar = Mid(strInput, I, 1)

         Select Case PrevChar
             Case "", " ", ".", "-", ",", """", "'"
                 strOutput = strOutput & UCase(CurrentChar)
             Case Else
                 strOutput = strOutput & LCase(CurrentChar)
         End Select

         PrevChar = CurrentChar
     Next 'I

     PCase = strOutput
     
End Function

'===============================================

'Client Directory

Function CDir(strInput)

Dim PrivateLabel

If Session("OrganizationNumber") <> 1 Then

SQLVenueCodeCheck = "SELECT VenueCode FROM VenueOptions (NOLOCK) WHERE OptionName = 'OrganizationNumber' AND OptionValue = '" &  Session("OrganizationNumber") & "'"
Set rsVenueCodeCheck = OBJdbConnection.Execute(SQLVenueCodeCheck)

	If Not rsVenueCodeCheck.EOF Then 
	
		ThisVenueCode = rsVenueCodeCheck("VenueCode")
		   
			SQLVenueRefCheck = "SELECT OptionValue as URL FROM VenueOptions (NOLOCK) WHERE VenueCode = '" & rsVenueCodeCheck("VenueCode") & "' AND OptionName = 'VenueReference'"
			Set rsVenueRefCheck = OBJdbConnection.Execute(SQLVenueRefCheck)
							
				PrivateLabel = rsVenueRefCheck("URL")

			rsVenueRefCheck.Close
			Set rsVenueRefCheck = nothing   
			
	End If
	
rsVenueCodeCheck.Close
Set rsVenueCodeCheck = nothing
	
End If

CDir = "" & PrivateLabel & "/ETickets/Images/" & strInput & ""

End Function
          
'===============================================



%>
  