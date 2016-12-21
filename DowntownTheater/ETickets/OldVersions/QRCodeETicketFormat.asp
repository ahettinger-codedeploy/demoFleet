<%
'CHANGE LOG
'REE 3/10/11 - Added Parent Price for SubSeats
%>
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
	SQLTix = "SELECT OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipCountry, OrderLine.ShipPostalCode, OrderLine.Price, OrderLine.Discount AS LineDiscount, OrderHeader.OrderNumber, OrderHeader.Subtotal, OrderHeader.ShipFee, OrderHeader.OrderSurcharge, OrderHeader.Total, OrderHeader.Discount AS OrderDiscount, OrderDate, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.Country, Customer.PostalCode, Seat.ItemNumber, Seat.Row, Seat.Seat, Section.SectionCode, Section.Section, Event.EventCode, Event.EventDate, Event.URL, Event.Phone AS EventPhoneNumber, Event.EMailAddress AS EventEMailAddress, Act.Act, Act.ShortAct, Act.Producer, Act.Comments AS ActComments, Event.Comments AS EventComments, Venue.Venue, Venue.Address_1 AS VenueAddress1, Venue.Address_2 AS VenueAddress2, Venue.City AS VenueCity, Venue.State AS VenueState, Venue.Zip_Code AS VenuePostalCode, SeatType.SeatType, Shipping.ShipType, OrderType, Organization.Organization, Ticket.TicketNumber, OrderLine.ItemType FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN Shipping (NOLOCK) ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN Section (NOLOCK) ON Seat.SectionCode = Section.SectionCode AND Seat.EventCode = Section.EventCode LEFT JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber INNER JOIN Ticket (NOLOCK) ON OrderLine.ItemNumber = Ticket.ItemNumber INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber WHERE OrderLine.OrderNumber = " & rsOrderNum("OrderNumber") & " AND OrderLine.ShipCode = 13 AND Ticket.StatusCode = 'A' AND OrganizationVenue.Owner = 1"
	Set rsTix = OBJdbConnection.Execute(SQLTix)

	If Not rsTix.EOF Then

		SQLTotalTix = "SELECT COUNT(TicketNumber) AS TotalTix FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN Shipping (NOLOCK) ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN Section (NOLOCK) ON Seat.SectionCode = Section.SectionCode AND Seat.EventCode = Section.EventCode LEFT JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber INNER JOIN Ticket (NOLOCK) ON OrderLine.ItemNumber = Ticket.ItemNumber INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber WHERE OrderLine.OrderNumber = " & rsOrderNum("OrderNumber") & " AND OrderLine.ShipCode = 13 AND Ticket.StatusCode = 'A' AND OrganizationVenue.Owner = 1"
		Set rsTotalTix = OBJdbConnection.Execute(SQLTotalTix)
		
		TotalTix = rsTotalTix("TotalTix")
		
		rsTotalTix.Close
		Set rsTotalTix = nothing

		Response.Write "<HTML>" & vbCrLf
		Response.Write "<HEAD>" & vbCrLf
		Response.Write "<TITLE>Tix - E-Ticket</TITLE>" & vbCrLf
		Response.Write "</HEAD>" & vbCrLf
		Response.Write "<BODY onLoad=""window.print()"">" & vbCrLf

		'Set Page Break Style
		Response.Write "<STYLE TYPE=""text/css"">" & vbCrLf
		Response.Write ".PageBreakAfter {page-break-after: always}" & vbCrLf
		'Response.Write ".PageBreakBefore {page-break-before: always}" & vbCrLf
		Response.Write ".Disclaimer {font-family: times new roman, arial, helvetica; font-size: 6pt;}" & vbCrLf
		Response.Write "</STYLE>" & vbCrLf

		Response.Write "<CENTER>" & vbCrLf

		Do Until rsTix.EOF
		
			TixCount = TixCount + 1

		    'Begin Ticket

			'Top Section
            Response.Write "<TABLE WIDTH=""620"" BORDER=""0"">" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD VALIGN=""top"">" & vbCrLf
			Response.Write "<TABLE WIDTH=""615"" BORDER=""1"" BACKGROUND=""/Images/ETicketBackgroundGoldNew.gif"" BGCOLOR=""#FFD718"" CELLPADDING=""0"" CELLSPACING=""0"">" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD WIDTH=""500"" VALIGN=""top"">" & vbCrLf
			Response.Write "<TABLE BORDER=""0"" CELLPADDING=""0"" CELLSPACING=""0"" WIDTH=""100%"">" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD WIDTH=""200"" HEIGHT=""70"" VALIGN=""top"" ALIGN=""center"">" & vbCrLf
			Response.Write "<IMG SRC=""/Clients/GPLB/ETicket/Images/ETicketLogo.jpg"">" & vbCrLf
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
			Response.Write "<FONT FACE=""Verdana,Arial,Helvetica"" SIZE=""1"">" & ETicketNumber & "&nbsp;&nbsp;&nbsp;&nbsp;" & rsTix("OrderNumber") & " - " & rsTix("ItemNumber") & "</FONT>" & vbCrLf 
			Response.Write "<BR><CENTER><FONT FACE=""Verdana,Arial,Helvetica"" SIZE=""4"">Admit One</FONT></CENTER></TD>" & vbCrLf
					
			Response.Write "</TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf
			Response.Write "<TABLE BORDER=""0"" CELLPADDING=""0"" CELLSPACING=""0"" WIDTH=""100%"">" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD WIDTH=""20"">" & vbCrLf
			Response.Write "&nbsp;" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			Response.Write "<TD VALIGN=""top"">" & vbCrLf
			'Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""2""><I>Toyota Presents</I></FONT><BR>" & vbCrLf
			Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""5""><B>" & rsTix("Act")
			If rsTix("SectionCode") = "GA" Then
			    SectionType = " / General Admission"
            Else			
			    SectionType = " / Reserved Seat"
			End If
			Response.Write SectionType & "</B></FONT><BR>" & vbCrLf
			'Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""3""><B>" & rsTix("Venue") & "</B></FONT><BR>" & vbCrLf
			Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""3"">" & FormatDateTime(rsTix("EventDate"), vbLongDate) & " at " & Left(FormatDateTime(rsTix("EventDate"),vbLongTime),Len(FormatDateTime(rsTix("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsTix("EventDate"),vbLongTime),3) & "</FONT><BR>" & vbCrLf

	        If rsTix("ItemType") = "SubSeat" Then
                Call DBOpen(OBJdbConnection2)
	            SQLParentPrice = "SELECT Parent.Price FROM OrderLine AS Parent (NOLOCK) INNER JOIN OrderLine AS Child (NOLOCK) ON Parent.OrderNumber = Child.OrderNumber AND Parent.LineNumber = Child.ParentLineNumber WHERE Child.OrderNumber = " & rsTix("OrderNumber") & " AND Child.ItemNumber = " & rsTix("ItemNumber")
	            Set rsParentPrice = OBJdbConnection2.Execute(SQLParentPrice)
	            If Not rsParentPrice.EOF Then
	                ETicketPrice = FormatNumber(rsParentPrice("Price"),2)
                Else
                    ETicketPrice = FormatNumber(rsTix("Price"),2)
                End If
                rsParentPrice.Close
                Set rsParentPrice = nothing	            
                Call DBClose(OBJdbConnection2)
            Else
	            ETicketPrice = FormatNumber(rsTix("Price"),2)
            End If	        

			Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""2"">" & rsTix("SeatType") & "  $" & ETicketPrice & "</FONT><BR>" & vbCrLf
			Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""2""><B>" & rsTix("Section") & "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" & vbCrLf
			If rsTix("SectionCode") <> "GA" Then
			    Response.Write "Row: " & rsTix("Row") & "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Seat: " & rsTix("Seat") & vbCrLf
            End If			    
			Response.Write "</B><BR><BR></FONT>" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf
			Response.Write "</TD>" & vbCrLf
									
			Response.Write "<TD ALIGN=""center"" VALIGN=""center"" BACKGROUND=""/images/white.gif"">" & vbCrLf
			Response.Write "<img src=""https://web12.tix.com/BarcodeGen.axd?S=DataMatrix&C=" & rsTix("TicketNumber") & """ HEIGHT=""75"">" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf
					  
			'Response.Write "<TR>" & vbCrLf
			'Response.Write "<TD ALIGN=""center"" COLSPAN=""2"" VALIGN=""bottom"" BGCOLOR=""#000000"" HEIGHT=""20"">" & vbCrLf
			'Response.Write "<IMG SRC=""/Images/ETicketBottomBar.gif"">" & vbCrLf
			'Response.Write "</TD>" & vbCrLf
			'Response.Write "</TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf

		    'End Ticket

		    'Begin Order Information

			Response.Write "<TABLE WIDTH=""620"" BORDER=""0"">" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			
			'Begin Left Column
			Response.Write "<TD VALIGN=""top"" WIDTH = ""33%"" ROWSPAN=""2"">" & vbCrLf
			Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""2"">" & vbCrLf
			Response.Write "<B>ORDER INFORMATION</B><BR>" & vbCrLf
			Response.Write "Order Number:&nbsp;&nbsp;" & rsTix("OrderNumber") & "<BR>" & vbCrLf
			Response.Write "Order Date:&nbsp;&nbsp;" & FormatDateTime(rsTix("OrderDate"), vbShortDate) & "<BR>" & vbCrLf
			Response.Write "Order Time:&nbsp;&nbsp;" & FormatDateTime(rsTix("OrderDate"), vbShortTime) & "<BR>" & vbCrLf
			Response.Write "Order Total:&nbsp;&nbsp;" & FormatCurrency(rsTix("Total"),2) & vbCrLf
			Response.Write "</FONT>" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			
			'Begin Middle Column
			Response.Write "<TD VALIGN=""top"" WIDTH=""33%"">" & vbCrLf
			Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""2"">" & vbCrLf
			Response.Write "<B>BILLING INFORMATION</B><BR>" & vbCrLf
			Response.Write rsTix("FirstName") & " " & rsTix("LastName") & "<BR>" & vbCrLf
			Response.Write rsTix("Address1") & "<BR>" & vbCrLf
			If rsTix("Address2") <> "" Then
				Response.Write rsTix("Address2") & "<BR>" & vbCrLf
			End If
			Response.Write rsTix("City") & ", " & rsTix("State") & " " & rsTix("PostalCode") & vbCrLf
			Response.Write "</FONT>" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			
			'Begin Right Column
			Response.Write "<TD VALIGN=""top"" WIDTH=""34%"">" & vbCrLf
			Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""2"">" & vbCrLf
			Response.Write "<B>ATTENDEE INFORMATION</B><BR>" & vbCrLf
			Response.Write rsTix("ShipFirstName") & " " & rsTix("ShipLastName") & "<BR>" & vbCrLf
			Response.Write rsTix("ShipAddress1") & "<BR>" & vbCrLf
			If rsTix("ShipAddress2") <> "" Then
				Response.Write rsTix("ShipAddress2") & "<BR>" & vbCrLf
			End If
			Response.Write rsTix("ShipCity") & ", " & rsTix("ShipState") & " " & rsTix("ShipPostalCode") & vbCrLf
			Response.Write "</FONT>" & vbCrLf
			'Response.Write "<img src=""https://web12.tix.com/BarcodeGen.axd?S=DataMatrix&C=" & rsTix("TicketNumber") & """ HEIGHT=""75"">" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf

			Response.Write "<IMG SRC=""/Images/ETicketFold.gif""><BR><BR>" & vbCrLf

            'Middle Section

			Response.Write "<TABLE WIDTH=""620"" BORDER=""0"">" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD>" & vbCrLf
			Response.Write "<IMG SRC=""/Clients/GPLB/ETicket/Images/TrackMap.jpg""><BR>" & vbCrLf
			Response.Write "<BR><FONT FACE=""Arial, Helvetica"" SIZE=""2"">To view or to download the Official Fan Guide go to <a href=""http://www.gplb.com"">www.gplb.com</a>.</FONT>" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			Response.Write "<TD>" & vbCrLf
			Response.Write "<img src=""https://web12.tix.com/BarcodeGen.axd?S=DataMatrix&C=" & rsTix("TicketNumber") & """ HEIGHT=""75"">" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf

			Response.Write "<IMG SRC=""/Images/ETicketFold.gif""><BR>" & vbCrLf

		    'Bottom Section
		    
			Response.Write "<TABLE WIDTH=""620"" BORDER=""0"" CELLPADDING=""0"" CELLSPACING=""0"">" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD VALIGN=""bottom"">" & vbCrLf
			Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""2"">" & vbCrLf
			Response.Write "<B>TERMS AND CONDITIONS</B></FONT><BR><BR>" & vbCrLf
			Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""1"">NO REFUNDS - NO EXCHANGES.  DO NOT COPY THIS TICKET.  MULTIPLE COPIES INVALID.<BR><BR></FONT>" & vbCrLf
            Response.Write "</TD>" & vbCrLf
			Response.Write "<TD ALIGN=""right"">" & vbCrLf
			Response.Write "<img src=""https://www.tix.com/BarcodeGen.axd?S=QRCode&QRCodeVersion=Auto&C=http://" & rsTix("URL") & """ HEIGHT=""50"">&nbsp;" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf
			Response.Write "<TR><TD COLSPAN=""2"" CLASS=""Disclaimer"">" & vbCrLf
			'Response.Write "NO REFUNDS - NO EXCHANGES.  DO NOT COPY THIS TICKET.  MULTIPLE COPIES INVALID.<BR><BR>" & vbCrLf
			Response.Write Disclaimer() & vbCrLf
			
			Response.Write "</TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf
			
			Response.Write "<DIV STYLE=""page-break-before: always;"">&nbsp;</DIV>" 'Page Break

            'Begin Page 2
            'Toyota Ad
			Response.Write "<TABLE WIDTH=""620"" BORDER=""0"" CELLPADDING=""0"" CELLSPACING=""0"">" & vbCrLf
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD><IMG SRC=""/Clients/GPLB/ETicket/Images/Schedule.gif""></TD>" & vbCrLf
			Response.Write "<TD VALIGN=""top"" ALIGN=""right"">&nbsp;<IMG SRC=""/Clients/GPLB/ETicket/Images/ToyotaAd.jpg""></TD>" & vbCrLf
			Response.Write "</TR>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf
			
			Response.Write "<HR><BR>" & vbCrLf
			
			'Disclaimer
			
			'Do's and Don'ts
			Response.Write "<IMG SRC=""/Clients/GPLB/ETicket/Images/Restrictions.gif""><BR><BR>" & vbCrLf
			
			Response.Write "<HR>" & vbCrLf

			'Sponsors
			Response.Write "<BR><IMG SRC=""/Clients/GPLB/ETicket/Images/ETicketAd.jpg"">" & vbCrLf
			
			If TixCount < TotalTix Then
				'REE 3/9/7 - Added space inbetween DIV tag to resolve IE 7 Page Break issue.
				Response.Write "<DIV STYLE=""page-break-after: always;"">&nbsp;</DIV>" 'Page Break
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

Function Disclaimer()

Disclaimer = "<b>PARTICIPATION IN THIS RACING EVENT IS AT YOUR " &_
"OWN RISK. The ticket holder expressly assumes all risk " &_
"incident to the event, whether occurring prior to, during " &_
"or subsequent to the actual conduct of the event, and " &_
"HEREBY RELEASES all event participants, sanctioning " &_
"bodies, sponsors, Indy Racing League, LLC d/b/a INDYCAR " &_
"(&#8220;INDYCAR&#8221;), Aquarium Holdings LLC, Grand Prix " &_
"Association of Long Beach LLC (&#8220;GPALB&#8221;), International " &_
"Motor Sports Association (&#8220;IMSA&#8221;), City of Long Beach " &_
"and Toyota Motor Sales, U.S.A., and all directors, officers, " &_
"members, shareholders, owners, affiliates, employees and " &_
"agents of each of the foregoing from any and all claims " &_
"arising from the event, including claims of negligence of " &_
"releasees.</b><br /><br />" &_
"The ticket holder grants INDYCAR, IMSA, GPALB and their " &_
"designees the right to use your image and/or likeness in any " &_
"photographs, live or recorded video display or other transmission " &_
"or reproduction of the event, including your rights of publicity. All " &_
"rights to broadcast, record, photograph, repeat, reproduce or " &_
"recreate the event are reserved by INDYCAR. The ticket holder " &_
"agrees not to take any action, or cause others to take any action, " &_
"which would infringe on the rights of INDYCAR, IMSA and GPALB " &_
"or their designees.<br /><br />" &_
"You must abide by our rules and regulations, including printed " &_
"fan guides. No coolers or bags larger than 14” permitted in " &_
"grandstands. No glass containers, cans, alcoholic beverages, " &_
"strollers, motorized vehicles or weapons allowed. Smoking not " &_
"allowed in grandstands. We reserve the right to remove you from " &_
"the event premises, without refund, for offensive or hazardous " &_
"behavior.<br /><br />" &_
"You may not use this ticket for advertising, promotion (including " &_
"contests and sweepstakes) or other trade purposes without " &_
"our written consent. No distribution or sale of literature, other " &_
"materials or merchandise is allowed on the premises. You may " &_
"not re-sell this ticket for more than face value. You may not re-sell " &_
"this ticket at all if you are on event property. You must obtain your " &_
"ticket from us or our authorized agents. You must have a ticket " &_
"in your possession at all times. If your ticket was lost, stolen or " &_
"counterfeit we will not honor it.<br /><br />" &_
"<u>The holder of this ticket is not entitled to a refund (including " &_
"handling charges and convenience fees), replacement ticket " &_
"or to payment for any damages of any kind for any reason " &_
"from INDYCAR, IMSA or GPALB, including without limitation " &_
"cancellation, shortening or other alteration of the event. If the " &_
"event is postponed, this ticket will entitle you to admission on " &_
"the rescheduled date for the event. Use of this ticket constitutes " &_
"acceptance of these terms.</u>"

End Function



%>
  