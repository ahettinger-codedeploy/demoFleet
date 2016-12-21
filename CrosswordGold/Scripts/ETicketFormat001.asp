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
%>
            <div align="center">
              <p><font color="#FF0000" size="3" face="Arial, Helvetica, sans-serif"><strong>Please read <u>all</u> information before printing this ticket.</strong></font></p>
              <table width="800" border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                  <td width="37">&nbsp;</td>
                  <td width="725">
                  <table width="725" background="/clients/crosswordgold/images/tiger_time_ticket_2.jpg" border="0" cellpadding="0" cellspacing="0">
                    <tr><td><img src="/images/clear.gif" width="1" height="140" alt="" /></td></tr>
                    <tr><td align="center" valign="top"><font face="Arial, Helvetica, sans-serif" size="5"><b><%= rsTix("TicketNumber") %></b></font></td></tr>
                    <tr><td><img src="/images/clear.gif" width="1" height="110" alt="" /></td></tr>
                  </table>
                  <td width="38">&nbsp;</td>
                </tr>
              </table>
              <table width="800" border="0" align="center" cellpadding="5" cellspacing="0">
                <tr align="left" valign="top">
                  <td width="37"><p><font color="#000000" size="3" face="Arial, Helvetica, sans-serif"></font></p></td>
                  <td width="241"><p><font color="#000000" size="3" face="Arial, Helvetica, sans-serif">
                    <strong>ORDER INFORMATION</strong><br>
                    Order Number: <%= rsTix("OrderNumber") %> <br>
                    Order Date: <%= FormatDateTime(rsTix("OrderDate"), vbShortDate) %> <br>
                    Order Time: <%= FormatDateTime(rsTix("OrderDate"), vbShortTime) %><br>
                    Order Total: <%= FormatCurrency(rsTix("Total"),2) %></font></p>

                    <p><font color="#000000" size="3" face="Arial, Helvetica, sans-serif"><strong>BILLING
                    INFORMATION</strong><br>
                    <%= rsTix("FirstName") & " " & rsTix("LastName") %><br />
                    <%= rsTix("Address1") %><br />
                    <%= rsTix("Address2") %><br />
                    <%= rsTix("City") & ", " & rsTix("State") & " " & rsTix("PostalCode") %><br />
                    </font></p>
                  </td>
                  <td width="242"><p><font color="#000000" size="3" face="Arial, Helvetica, sans-serif"><strong>EVENT
                    INFORMATION</strong><br>
                        www.CrosswordGold.com<br>
                        This is a timed puzzle solving event.  Answers are submitted via
                        the Internet.  Learn all about this event on our Web site.</font></p>
                  <p><font color="#000000" size="3" face="Arial, Helvetica, sans-serif"><strong>DOWNLOADS</strong><br>
                    Go to the Web site to download the Tiger Time Competition file and
                        complete the Competition Sample.</font></p></td>
                  <td width="242"><p><font color="#000000" size="3" face="Arial, Helvetica, sans-serif"><strong>Registration
                        Number</strong><br>
                        Guard your registration number.&nbsp; It is your entry into the event.</font></p></td>
                  <td width="38"><p><font color="#000000" size="3" face="Arial, Helvetica, sans-serif"></font></p></td>
                </tr>
              </table>
              <table width="800" border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                  <td width="37"><p>&nbsp;</p></td>
                  <td width="715" align="left" valign="top"><p><font color="#000000" size="3" face="Arial, Helvetica, sans-serif"><strong>GENERAL
                        INFORMATION</strong><br>
                        <font size="2">NO REFUNDS - NO EXCHANGES.&nbsp; DO NOT COPY THIS
                        TICKET.&nbsp; Visit www.CrosswordGold.com to read the Terms
                        and Conditions that apply to Crossword Gold events.&nbsp; Keep this
                        ticket.&nbsp; You
                        will need to present it in the event you win a major prize.<br>
                        ______________________________________________________________________________________________________<br>
                        <br>
                  </font></font></p></td>
                  <td width="40">&nbsp;</td>
                </tr>
              </table>
              <table width="800" border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                  <td width="37"><p>&nbsp;</p></td>
                  <td width="715" align="left" valign="top"><p><font color="#000000" size="3" face="Arial, Helvetica, sans-serif">If
                        you are going to present this ticket as a gift, I would recommend
                        laminating it to get the finest looking item.&nbsp; You can
                        get it laminated at any Staples, Office Max, or similar stores.&nbsp; Ask
                        the associate to use a 7 mil or 10 mil laminating sheet.&nbsp; If
                        you are going to get it laminated, <font color="#FF0000"><strong>do
                        not</strong></font> print
                        on glossy photo stock.
                        It
                      has a tendency to delaminate and form bubbles.&nbsp; I recommend Epson
                      Premium Presentation Paper Matte for laminating.&nbsp; This is a heavy
                      weight paper, like a card stock.&nbsp; If you do not want to purchase
                      that paper, I recommend any matte card stock.&nbsp; If you are not
                      going to laminate, a high gloss premium photo paper or a white, 65
                      - 110 lb. card stock would be
                  good choices.&nbsp; Use a <u><strong>photo setting</strong></u> when printing
                  the ticket.&nbsp; You can
                  get creative by setting up your word processor or drawing program to personalize
                  the reverse side of this ticket before cutting it out and laminating.&nbsp; If
                  you decide to do that, be sure to use a double sided paper like the Epson
                  Matte.</font></p>
                    <p><font color="#000000" size="3" face="Arial, Helvetica, sans-serif">Good
                  luck in the competition.&nbsp; There will be many more Crossword Gold events,
                  so keep checking the Web site for new challenges or sign up to receive
                  our updates.&nbsp;<strong><font color="#990000"> www.CrosswordGold.com</font></strong></font></p></td>
                  <td width="40">&nbsp;</td>
                </tr>
              </table>
              <p>&nbsp;</p>
            </div>
<%
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
  