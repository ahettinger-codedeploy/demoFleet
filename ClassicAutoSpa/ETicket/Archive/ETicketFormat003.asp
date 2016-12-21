<!--#INCLUDE virtual=GlobalInclude.asp -->
<!--#INCLUDE virtual="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL ="ETicketInclude.asp"-->

<%

OrderNumber = Clean(Request("OrderNumber"))
TicketNumber = Clean(Request("TicketNumber"))

'Find the OrderNumber for this Ticket.  Check using both OrderNumber and TicketNumber for added security.
SQLOrderNum = "SELECT OrderNumber FROM Ticket (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND TicketNumber = '" & TicketNumber & "'"
Set rsOrderNum = OBJdbConnection.Execute(SQLOrderNum)

If Not rsOrderNum.EOF Then

	'Check the Order for ETicket (ShipCode=13)
	SQLTix = "SELECT OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipCountry, OrderLine.ShipPostalCode, OrderLine.Price, OrderLine.Discount AS LineDiscount, OrderLine.ItemType, OrderHeader.OrderNumber, OrderHeader.Subtotal, OrderHeader.ShipFee, OrderHeader.OrderSurcharge, OrderHeader.Total, OrderHeader.Discount AS OrderDiscount, OrderHeader.OrderTypeNumber, OrderDate, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.Country, Customer.PostalCode, Seat.ItemNumber, Seat.Row, Seat.Seat, Section.SectionCode, Section.Section, Event.EventCode, Event.EventDate, Event.Phone AS EventPhoneNumber, Event.EMailAddress AS EventEMailAddress, Event.Map, Act.Act, Act.ShortAct, Act.Producer, Act.Comments AS ActComments, Event.Comments AS EventComments, Venue.Venue, Venue.Address_1 AS VenueAddress1, Venue.Address_2 AS VenueAddress2, Venue.City AS VenueCity, Venue.State AS VenueState, Venue.Zip_Code AS VenuePostalCode, SeatType.SeatType, Shipping.ShipType, OrderType, Organization.Organization, Ticket.TicketNumber FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN Shipping (NOLOCK) ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN Section (NOLOCK) ON Seat.SectionCode = Section.SectionCode AND Seat.EventCode = Section.EventCode LEFT JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber INNER JOIN Ticket (NOLOCK) ON OrderLine.ItemNumber = Ticket.ItemNumber INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber WHERE OrderLine.OrderNumber = " & rsOrderNum("OrderNumber") & " AND OrderLine.ShipCode = 13 AND Ticket.StatusCode = 'A' AND OrganizationVenue.Owner = 1"
	Set rsTix = OBJdbConnection.Execute(SQLTix)

	If Not rsTix.EOF Then

		SQLTotalTix = "SELECT COUNT(TicketNumber) AS TotalTix FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN Shipping (NOLOCK) ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN Section (NOLOCK) ON Seat.SectionCode = Section.SectionCode AND Seat.EventCode = Section.EventCode LEFT JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber INNER JOIN Ticket (NOLOCK) ON OrderLine.ItemNumber = Ticket.ItemNumber INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber WHERE OrderLine.OrderNumber = " & rsOrderNum("OrderNumber") & " AND OrderLine.ShipCode = 13 AND Ticket.StatusCode = 'A' AND OrderLine.ItemType = 'SubFixedEvent' AND OrganizationVenue.Owner = 1"
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
		Response.Write "div {page-break-before: always}" & vbCrLf
		Response.Write "</STYLE>" & vbCrLf

		Response.Write "<CENTER>" & vbCrLf

		Do Until rsTix.EOF
		
			TixCount = TixCount + 1
			
	    If rsTix("ItemType") = "Seat" Then

		'Begin Ticket

			Response.Write "<TABLE WIDTH=""620"" BORDER=""0"">" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD VALIGN=""top"">" & vbCrLf
			
			Response.Write "<TABLE WIDTH=""620"" HEIGHT=""240"" BORDER=""0"" BACKGROUND=""/Clients/ClassicAutoSpa/ETicket/Images/CustomETicketBackground.png"" CELLPADDING=""0"" CELLSPACING=""0"">" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD WIDTH=""620"" VALIGN=""top"">" & vbCrLf
			
			Response.Write "<TABLE BORDER=""0"" CELLPADDING=""0"" CELLSPACING=""0"" WIDTH=""100%"">" & vbCrLf
			Response.Write "<TR>" & vbCrLf
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
			Response.Write "<TD COLSPAN=""2"">" & vbCrLf
			Response.Write "<IMG SRC=""/Images/clear.gif"" HEIGHT=""55"">" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD>" & vbCrLf
			Response.Write "<IMG SRC=""/Images/clear.gif"" WIDTH=""15"">" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			Response.Write "<TD VALIGN=""top"">" & vbCrLf
			Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""2""><I>" & rsTix("Organization") & " Presents</I></FONT><BR>" & vbCrLf
			Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""5""><B>" & rsTix("Act") & "</B></FONT><BR>" & vbCrLf
			Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""3""><B>" & rsTix("Venue") & "</B></FONT><BR>" & vbCrLf
			Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""3"">" & FormatDateTime(rsTix("EventDate"), vbLongDate) & "&nbsp;&nbsp;" & rsTix("ShortAct") & "</FONT><BR><BR>" & vbCrLf
			Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""2"">" & rsTix("SeatType") & "  $" & FormatNumber(rsTix("Price"),2) & "</FONT><BR>" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf
			Response.Write "</TD>" & vbCrLf
									
			Response.Write "</TR>" & vbCrLf
					  
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD ALIGN=""center"" COLSPAN=""2"" VALIGN=""bottom"" BGCOLOR=""#032E5D"" HEIGHT=""20"">" & vbCrLf
			Response.Write "<IMG SRC=""/Clients/ClassicAutoSpa/ETicket/Images/CustomETicketBottomBar.jpg"">" & vbCrLf
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
			Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""2"">" & vbCrLf
			Response.Write "<B>www.laartshow.com</B>" & vbCrLf
			Response.Write "<br />" & vbCrLf
			Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""1"">" & vbCrLf
			Response.Write "Visit our website for directions." & vbCrLf
			'Response.Write "Take the 110 NORTH, transition to the 10 WEST," & vbCrLf
			'Response.Write "and exit immediately from the LEFT lane to" & vbCrLf
			'Response.Write "PICO Blvd. The PICO off-ramp becomes" & vbCrLf
			'Response.Write "CHERRY St. Turn RIGHT into the West Hall" & vbCrLf
			'Response.Write "parking garage." & vbCrLf
			'Response.Write "<br />" & vbCrLf
			'Response.Write "FROM THE NORTH" & vbCrLf
			'Response.Write "Take the 110 SOUTH, exit at OLYMPIC Blvd. LEFT" & vbCrLf
			'Response.Write "at bottom of ramp onto BLAINE. LEFT on 11th" & vbCrLf
			'Response.Write "St. Immediate RIGHT on CHERRY St, and LEFT" & vbCrLf
			'Response.Write "into the West Hall garage." & vbCrLf
			'Response.Write "<br />" & vbCrLf

			Response.Write "</FONT>" & vbCrLf			
			Response.Write "</TD>" & vbCrLf
			
			'Begin Right Column
			Response.Write "<TD VALIGN=""top"" WIDTH=""34%"">" & vbCrLf
			Response.Write "<IMG alt=""Barcode Image"" src=""/Barcode.asp?Barcode=" & rsTix("TicketNumber") & """><BR>" & vbCrLf
			Response.Write "<BR>" & vbCrLf
			Response.Write "<BR>" & vbCrLf
			Response.Write "<BR>" & vbCrLf
			Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""2"">" & vbCrLf
			Response.Write "<B>GENERAL INFORMATION</B><BR>" & vbCrLf
			Response.Write "</FONT>" & vbCrLf
			Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""1"">" & vbCrLf
			Response.Write "NO REFUNDS - NO EXCHANGES.  DO NOT COPY THIS TICKET.  MULTIPLE COPIES INVALID.  Holder assumes all risk and danger including, without limitation, injury, death, personal loss, property damage, or other related harm.  Management reserves the right to refuse admission or eject any person who fails to comply with the terms and conditions and/or rules for the event in which this ticket is issued." & vbCrLf
			Response.Write "</FONT>" & vbCrLf
			Response.Write "</FONT>" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf
			
			'Response.Write "<TABLE WIDTH=""620"" BORDER=""0"" CELLPADDING=""0"" CELLSPACING=""0"">" & vbCrLf
			'Response.Write "<TR>" & vbCrLf
			'Response.Write "<TD>" & vbCrLf
			'Response.Write "</TD>" & vbCrLf
			'Response.Write "</TR>" & vbCrLf
			'Response.Write "</TABLE>" & vbCrLf

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
			Response.Write "<IMG SRC=""/Clients/ClassicAutoSpa/ETicket/Images/ETicketAd.jpg"" WIDTH=""300"">" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf			

		'End Ad Space
		
ElseIf rsTix("ItemType") = "SubSeat" Then
		
		
'Start MultiDay Pass
'Multiple Bar Codes Printed
'----------------------------
		
		    'If rsTix("EventCode") = 426911 OR rsTix("EventCode") = 426890 OR rsTix("EventCode") = 426893 OR rsTix("EventCode") = 426899 OR rsTix("EventCode") = 426905 OR rsTix("EventCode") = 426917 OR rsTix("EventCode") = 426923 Then
		    If rsTix("EventCode") = 426911 OR rsTix("EventCode") = 426890 OR rsTix("EventCode") = 426893 OR rsTix("EventCode") = 426899 OR rsTix("EventCode") = 426905 OR rsTix("EventCode") = 426917 OR rsTix("EventCode") = 426923 OR rsTix("EventCode") = 422289 OR rsTix("EventCode") = 422305 Then
		    
		    CurrentEventCode = rsTix("EventCode")
		    
		    Select Case CurrentEventCode
		    
		        Case 426911
		            CurrentAct = "6 Full Service washes for the price of 4"
		            CurrentPrice = "$51.80"
		        
		        Case 426890
		            CurrentAct = "3 Express Details For $100"
		            CurrentPrice = "$100.00"
		        
		        Case 426893
		            CurrentAct = "6 Basic Washes For The Price Of 4"
		            CurrentPrice = "$67.80"
		            
		        Case 426899
		            CurrentAct = "6 Classic Washes For The Price Of 4"
		            CurrentPrice = "$87.80"
		            
		        Case 426905
		            CurrentAct = "6 Exterior Washes For The Price Of 4"
		            CurrentPrice = "$39.80"
		            
		        Case 426917
		            CurrentAct = "6 Vintage Washes For The Price Of 4"
		            CurrentPrice = "$75.80"
		            
		        Case 426923
		            CurrentAct = "6 VIP Washes For The Price Of 4"
		            CurrentPrice = "$111.80"
		            
		            		            
		    End Select
		    
		        If TixCount < TotalTix Then
			        'REE 3/9/7 - Added space inbetween DIV tag to resolve IE 7 Page Break issue.
			        Response.Write "<DIV>&nbsp;</DIV>" 'Page Break
		        End If
		
'Begin Custom Ticket
'-------------------

'Start TIX Ticket 
'=================
		    
			Response.Write "<TABLE WIDTH=""620"" BORDER=""0"" BORDERCOLOR=""RED"">" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD VALIGN=""top"">" & vbCrLf
			
			Response.Write "<TABLE WIDTH=""615"" HEIGHT=""240"" BORDER=""1"" BACKGROUND=""/Clients/ClassicAutoSpa/ETicket/Images/CustomETicketBackground.png"" BGCOLOR=""#FFD718"" CELLPADDING=""0"" CELLSPACING=""0"">" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD WIDTH=""615"" VALIGN=""top"">" & vbCrLf
			
			Response.Write "<TABLE BORDER=""0"" CELLPADDING=""0"" CELLSPACING=""0"" WIDTH=""100%"">" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD WIDTH=""220"" HEIGHT=""70"" VALIGN=""top"">" & vbCrLf
			Response.Write "<IMG SRC=""/Clients/ClassicAutoSpa/ETicket/Images/CustomETicketLogo.gif"">" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			
'Ticket Order Number / Ticket Number
'-----------------------------------
			
			'Response.Write "<TD VALIGN=""top"" ALIGN=""right"">" & vbCrLf

			'TicketDigit = 1
			'ETicketNumber = ""
			'Do Until TicketDigit >= Len(rsTix("TicketNumber"))
			'	If TicketDigit < Len(rsTix("TicketNumber")) - 4 Then
		    '		ETicketNumber = ETicketNumber & Mid(rsTix("TicketNumber"), TicketDigit, 4) & "-"
	        '		TicketDigit = TicketDigit + 4
            '	Else
			'		ETicketNumber = ETicketNumber & Mid(rsTix("TicketNumber"), TicketDigit, (Len(rsTix("TicketNumber")) - TicketDigit) + 1)
			'		TicketDigit = Len(rsTix("TicketNumber"))
			'	End If
			'Loop
			'Response.Write "<FONT FACE=""Verdana,Arial,Helvetica"" SIZE=""1"">" & ETicketNumber & "&nbsp;&nbsp;&nbsp;&nbsp;" & rsTix("OrderNumber") & " - " & rsTix("ItemNumber") & "</FONT></TD>" & vbCrLf '********** ADDED FOR TEST DRIVE **********
							
			'Response.Write "</TD>" & vbCrLf
			
			Response.Write "</TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf
			
			Response.Write "<TABLE BORDER=""0"" CELLPADDING=""0"" CELLSPACING=""0"" WIDTH=""100%"">" & vbCrLf
			
			Response.Write "<TR>" & vbCrLf
			
			Response.Write "<TD WIDTH=""20"">" & vbCrLf
			Response.Write "&nbsp;" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			
			Response.Write "<TD VALIGN=""top"">" & vbCrLf
			
			'Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""2""><I>" & rsTix("Organization") & " Presents</I></FONT><BR>" & vbCrLf
			
			Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""5""><B>" & CurrentAct & "</B></FONT><BR><BR>" & vbCrLf
			Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""3""><B>" & rsTix("Venue") & "</B></FONT><BR>" & vbCrLf
					
			
'Do not print event date if the event has datesuppress option
'Do not print event time if the event has timesuppress option
'-------------------------------------------------------------				
			
			SQLDateOption = "SELECT OptionValue FROM EventOptions (NOLOCK) WHERE EventCode = " & rsTix("EventCode") & " AND OptionName = 'DATESUPPRESS'"
			Set rsDateOption = OBJdbConnection.Execute(SQLDateOption)
			If Not rsDateOption.EOF Then
			    DateOption = rsDateOption("OptionValue")	
			Else
			    DateOption = "F"
			End If
		    rsDateOption.Close
		    Set rsDateOption = nothing 
		
			SQLTimeOption = "SELECT OptionValue FROM EventOptions (NOLOCK) WHERE EventCode = " & rsTix("EventCode") & " AND OptionName = 'TIMESUPPRESS'"
			Set rsTimeOption = OBJdbConnection.Execute(SQLTimeOption)
			If Not rsTimeOption.EOF Then
			    TimeOption = rsTimeOption("OptionValue")
			Else
			    TimeOption = "F"
			End If		
		    rsTimeOption.Close
		    Set rsTimeOption = nothing
		    
		    If DateOption = "Y" AND TimeOption = "Y" Then		    		
			    Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""3"">&nbsp;</FONT><BR><BR>" & vbCrLf
			End IF
			
			If DateOption = "Y" AND TimeOption = "F" Then			    		
			   ' Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""3"">" & FormatDateTime(rsTix("EventDate"), vbLongDate) & "</FONT><BR><BR>" & vbCrLf
			End If
			
			If DateOption = "F" AND TimeOption = "Y" Then
			    'Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""3"">" & Left(FormatDateTime(rsTix("EventDate"),vbLongTime),Len(FormatDateTime(rsTix("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsTix("EventDate"),vbLongTime),3) & "</FONT><BR><BR>" & vbCrLf
            End If	
            
            If DateOption = "F" AND TimeOption = "F" Then
			    'Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""3"">" & FormatDateTime(rsTix("EventDate"), vbLongDate) & " at " & Left(FormatDateTime(rsTix("EventDate"),vbLongTime),Len(FormatDateTime(rsTix("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsTix("EventDate"),vbLongTime),3) & "</FONT><BR><BR>" & vbCrLf
            End If
            
'If Subscription Child and Not Comp, display Price, otherwise Net Price
'----------------------------------------------------------------------            
			
            'If rsTix("ItemType") = "SubSeat" And rsTix("OrderTypeNumber") <> 5 Then 
            '    TicketPrice = FormatNumber(rsTix("Price"),2))
            'Else
            '    TicketPrice = FormatNumber((rsTix("Price"))-LineDiscount,2))
            'End If
            
			
			Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""2""><BR><BR>" & rsTix("SeatType") & "  " & CurrentPrice & "</FONT><BR><BR>" & vbCrLf
			
			Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""2""><B>Voucher expires 1 year from date of purchase</B>" & vbCrLf
			
			
'If general admission seating, leave section name blank
'If reserved seating, list section name, seat number and row
'-------------------------------------------------------------	
					
            If rsTix("Map") = "general" Then
			Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""2"">&nbsp;</FONT><BR>" & vbCrLf
            Else
            Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""2""><B>Section: " & rsTix("Section") & "&nbsp;&nbsp;&nbsp;&nbsp;Row: " & rsTix("Row") & "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Seat: " & rsTix("Seat") & "</B></FONT><BR>" & vbCrLf
            End If
						
			Response.Write "</TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf
			Response.Write "</TD>" & vbCrLf

'Ticket Body Bar Code
'-----------------------------------	
								
			'Response.Write "<TD ALIGN=""center"" VALIGN=""center"">" & vbCrLf
			'Response.Write "<IMG alt=""Barcode Image"" src=""/Barcode.asp?Barcode=" & rsTix("TicketNumber") & "&Rotate=270"">&nbsp;" & vbCrLf
			'Response.Write "</TD>" & vbCrLf
			
			Response.Write "</TR>" & vbCrLf
					  
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD ALIGN=""center"" VALIGN=""bottom"" BGCOLOR=""#000000"" HEIGHT=""20"">" & vbCrLf
			Response.Write "<IMG SRC=""/Clients/ClassicAutoSpa/ETicket/Images/CustomETicketBottomBar.jpg"">" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf
			
			Response.Write "</TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf

		    'End Ticket

		    'Begin Body Space
		    
		     'Start TIX Order Details
		    '=======================

			Response.Write "<TABLE WIDTH=""620"" BORDER=""0"" CELLPADDING=""5"" CELLSPACING=""5"">" & vbCrLf			
			
'Order Information
'Billing Information
'General Information

			Response.Write "<TR>" & vbCrLf
			
			'------------------------------------------------------
			
			Response.Write "<TD VALIGN=""top"" WIDTH = ""33%"">" & vbCrLf		
			
			Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""2"">" & vbCrLf
			Response.Write "<B>ORDER INFORMATION</B><BR><BR>" & vbCrLf
			Response.Write "Order Number:&nbsp;&nbsp;" & rsTix("OrderNumber") & "<BR>" & vbCrLf
			Response.Write "Order Date:&nbsp;&nbsp;" & FormatDateTime(rsTix("OrderDate"), vbShortDate) & "<BR>" & vbCrLf
			Response.Write "Order Time:&nbsp;&nbsp;" & FormatDateTime(rsTix("OrderDate"), vbShortTime) & "<BR>" & vbCrLf
			Response.Write "Order Total:&nbsp;&nbsp;" & FormatCurrency(rsTix("Total"),2)& "<BR>" & vbCrLf
			Response.Write "<BR>" & vbCrLf						
			Response.Write "</FONT>" & vbCrLf			
			
			Response.Write "</TD>" & vbCrLf	
			
			'------------------------------------------------------			
					
			Response.Write "<TD VALIGN=""top"" WIDTH = ""33%"">" & vbCrLf
			Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""2"">" & vbCrLf
			
			Response.Write "<B>BILLING INFORMATION</B><BR><BR>" & vbCrLf
			Response.Write rsTix("FirstName") & " " & rsTix("LastName") & "<BR>" & vbCrLf
			Response.Write rsTix("Address1") & "<BR>" & vbCrLf
			If rsTix("Address2") <> "" Then
				Response.Write rsTix("Address2") & "<BR>" & vbCrLf
			End If
			Response.Write rsTix("City") & ", " & rsTix("State") & " " & rsTix("PostalCode") & "<BR>" & vbCrLf
            
			Response.Write "</TD>" & vbCrLf
			
			'------------------------------------------------------	
				
			Response.Write "<TD VALIGN=""top"" WIDTH = ""34%"">" & vbCrLf
			
			Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""2"">" & vbCrLf
			Response.Write "<B>GENERAL INFORMATION</B><BR><BR>" & vbCrLf
			Response.Write "</FONT>" & vbCrLf
			Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""1"">" & vbCrLf
			Response.Write "NO REFUNDS - NO EXCHANGES.  DO NOT COPY THIS TICKET.  MULTIPLE COPIES INVALID.  Holder assumes all risk and danger including, without limitation, injury, death, personal loss, property damage, or other related harm.  Management reserves the right to refuse admission or eject any person who fails to comply with the terms and conditions and/or rules for the event in which this ticket is issued." & vbCrLf
			Response.Write "</FONT>" & vbCrLf
			
			Response.Write "</TD>" & vbCrLf
			
			'------------------------------------------------------	
			
'BarCode 1
'BarCode 2
'BarCode 3
			 
			    SQLChildBarCode = "SELECT Ticket.TicketNumber, Event.EventDate, Event.ActCode FROM Ticket (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON Ticket.ItemNumber = OrderLine.ItemNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.Eventcode = Event.EventCode WHERE OrderLine.OrderNumber = " & rsOrderNum("OrderNumber") & " AND OrderLine.ItemType = 'SubSeat' AND Ticket.StatusCode = 'A'  AND ParentLineNumber IN (SELECT ParentLineNumber FROM OrderLine (NOLOCK) WHERE OrderNumber = " & rsOrderNum("OrderNumber") & " AND OrderLine.ItemNumber = " & rsTix("ItemNumber") & ") ORDER BY Event.EventDate"
			    Set rsChildBarCode = OBJdbConnection.Execute(SQLChildBarCode)
			    
			    CellNumber = 1
			    
			    Do While Not rsChildBarCode.EOF 
			    
			        CellCount = CellNumber Mod 3
			        
			        If CellCount = 1 Then
			            Response.Write "<TR>" & vbCrLf
			            Response.Write "<TD align=""center"">" & vbCrLf
			        Else
			            Response.Write "<TD align=""center"">" & vbCrLf
			        End If
			    			    
			        SQLActName = "SELECT Act FROM Act (NOLOCK) WHERE ActCode = " & rsChildBarCode("ActCode")& ""
			        Set rsActName = OBJdbConnection.Execute(SQLActName)
			        Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""2""><B>" & rsActName("Act")& "<Br>" & vbCrLf
                    rsActName.Close
                    Set rsActName = Nothing 
			        Response.Write "<IMG alt=""Barcode Image"" src=""/Barcode.asp?Barcode=" & rsChildBarCode("TicketNumber") & """><BR><BR>" & vbCrLf
			        Response.Write "</B></FONT>" & vbCrLf
			        
                    If CellCount = 0 Then
                        Response.Write "</TD>" & vbCrLf
                        Response.Write "</TR>" & vbCrLf
                    Else
                        Response.Write "</TD>" & vbCrLf
                    End If
			        
			        CellNumber = CellNumber + 1
			        
			    rsChildBarCode.MoveNext
			    Loop
			    rsChildBarCode.Close
			    Set rsChildBarCode = Nothing    
			    Response.Write "</FONT>" & vbCrLf
			
			Response.Write "</TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf
		    
'------------------------------------------------------	
'End Order Information

		    'Begin Ad Space

			Response.Write "<TABLE WIDTH=""620"" BORDER=""0"" CELLPADDING=""0"" CELLSPACING=""0"">" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD ALIGN=""center"">" & vbCrLf
			Response.Write "<IMG SRC=""/Clients/ClassicAutoSpa/ETicket/Images/ETicketAd.jpg"" WIDTH=""300"">" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf

		    'End Ad Space		    
		        
		    End If
		
		End If
		
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
  