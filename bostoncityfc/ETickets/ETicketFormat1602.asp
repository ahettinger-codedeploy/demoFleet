<%

  'CHANGE LOG
  'LSP 02/09/16 - initial development
  'SSR 04/22/16 - hardcoded price

  %><!--#INCLUDE virtual=GlobalInclude.asp -->
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


  Response.Write "<!doctype html>" &vbCrLf
  Response.Write "<html lang=""en"">" &vbCrLF
  Response.Write "<head>" &vbCrLf
  Response.Write "<meta http-equiv=""content-type"" content=""text/html; charset=UTF-8"">" &vbCrLf
  Response.Write "<meta http-equiv=""X-UA-Compatible"" content=""IE=edge,chrome=1"">" &vbCrLf
  Response.Write  "<meta charset=""utf-8"">" &vbCrLf
  Response.Write  "<meta name=""viewport"" content=""width=device-width, initial-scale=1.0"">" &vbCrLf
                Response.Write "<TITLE>TIX.com | Print at Home Ticket</TITLE>" & vbCrLf
  Response.Write  "<link rel=""stylesheet"" href=""https://www.tix.com/clients/tixnew/bootstrap/css/bootstrap.min.css"" media=""all"">" &vbCrLf
  Response.Write  "<link rel=""stylesheet"" href=""https://www.tix.com/clients/tixnew/bootstrap/css/bootstrap-theme.min.css"">" &vbCrLf

  Response.Write  "<link rel=""stylesheet"" href=""https://www.tix.com/Clients/TixNew/fonts/font-awesome/css/font-awesome.css"">" &vbCrLf
  Response.Write  "<link rel=""stylesheet"" href=""https://www.tix.com/clients/tixnew/css/eticketstyle.css"">" &vbCrLf


  Response.Write "<style>" &vbCrLf
  Response.Write ".PageBreak {page-break-before: always}" & vbCrLf
  Response.Write ".ETicketBackground {border:1px solid #333333;}" & vbCrLf
  Response.Write "img.AdImage {max-height: 300px; width: auto; max-width:620px;}" & vbCrLf


  Response.Write "</STYLE>" & vbCrLf

  Response.Write "</head>" &vbCrLf
  Response.Write "<BODY onLoad=""window.print()"">" & vbCrLf


  ETicketBackground = ""
  Do Until rsTix.EOF

  TixCount = TixCount + 1


  'call out at top'

  Response.Write "<div>" &vbCrLf
  Response.Write "<div class=""container"" >" &vbCrLF
  Response.Write "<div class=""row"">" &vbCrLf
  Response.Write "<div style=""height: 20px;""  class=""col-sm-12 hidden-xs text-center"">" &vbCrLF
  Response.Write "<font size=""3""><B>THIS IS YOUR TICKET. Please print and bring to event</B><BR></font>" &vbCrLf
  Response.Write "</div>" &vbCrLf
  Response.Write "</div>" &vbCrLf
  Response.Write  "</div>" &vbCrLf
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




  'Background Path
        If Not IsNull(rsTix("ETicketBackgroundPath")) Then
            ETicketBackground = rsTix("ETicketBackgroundPath")
        Else
            ETicketBackground = "/Images/ETicketBackground.gif"
        End If

  Response.Write "<div style="" background-image: url(" &  ETicketBackground & ");"" class=""container  barcode-body"">" &vbCrLf
  Response.Write "<div class=""row"">" &vbCrLf
  Response.Write "<div class="" col-sm-8 ticket-body text-left hidden-xs"">" &vbCrLf
  'Logo Path
        If Not IsNull(rsTix("ETicketLogoPath")) Then
      Response.Write "<IMG SRC=""" & rsTix("ETicketLogoPath") & """ height=""67"">" & vbCrLf
        Else
      Response.Write "<IMG SRC=""/Images/ETicketLogo.gif"">" & vbCrLf
        End If




  Response.Write "<p> " &vbCrLf

  'Producer Field'
  If rsTix("Producer") <> "" Then
    Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""1""><I>" & rsTix("Producer") & "</I></FONT><BR>" & vbCrLf
  Else
    Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""1""><I>" & rsTix("Organization") & " presents</I></FONT><BR>" & vbCrLf
  End If

  'start body of the printable ticket
  Response.Write "<br>" &vbCrLF
  Response.Write "<font face=""arial"" size=""3""><b>"& rsTix("Act") & "</b>" &vbCrLf
  Response.Write "<br>" &vbCrLf
  Response.Write "</font>" &vbCrLf
  Response.Write "<font face=""arial"" size=""2""><b>" & rsTix("Venue") & "</b></font>" &vbCrLf
  Response.Write "<br>" &vbCrLf

  'Date & Time
  Response.Write "<font face=""arial"" size=""2"">" & FormatDateTime(rsTix("EventDate"), vbLongDate) & " at " &        Left(FormatDateTime(rsTix("EventDate"),vbLongTime),Len(FormatDateTime(rsTix("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsTix("EventDate"),vbLongTime),3) &" </font>" &vbCrLF
  'Seat Location'
  Response.Write "<BR>"
  Response.Write "<font face=""arial"" size=""1"">" & rsTix("SeatType") & "  $12.00</font>" &vbCrLf
  Response.Write "<BR>"
            'General Admission Section
            If rsTix("Map") <> "general" Then
              Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""2""><B>Section: " & rsTix("Section") & "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Row: " & rsTix("Row") & "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Seat: " & rsTix("Seat") & "</B></FONT><BR>" & vbCrLf
            Else
            Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""2""><B>" & rsTix("Section") & "</B></FONT><BR>" & vbCrLf
            End If

  Response.Write "</p>"&vbCrLf
  Response.Write "</div>"&vbCrLf

  'Barcode Body
  Response.Write "<div class="" col-sm-4 text-center visible-lg visible-md visible-sm"">" &vbCrLf
  Response.Write "<BR>" &vbCrLf
  Response.Write "<IMG alt=""Barcode Image"" src=""/Barcode.asp?Barcode=" & rsTix("TicketNumber") & "&Rotate=270"">&nbsp;" & vbCrLf
  Response.Write "<BR>" &vbCrLf
  Response.Write "</div>" &vbCrLf
  Response.Write "</div>" &vbCrLf
  Response.Write "</div>" &vbCrLf


  'Bottom Bar
  Response.Write "<div class=""container "">" &vbCrLf
  Response.Write "<div class=""row"">" &vbCrLf
  Response.Write "<div class=""col-sm-12 visible-lg visible-md visible-sm"">" &vbCrLf
  'ETicket Bottom Bar Path
            If Not IsNull(rsTix("ETicketBottomBarPath")) Then
                Response.Write "<IMG SRC=""" & rsTix("ETicketBottomBarPath") & """ width=""100%"" height=""27"">" & vbCrLf
                  Else
                Response.Write "<IMG SRC=""/Images/ETicketBottomBar.gif"">" & vbCrLf
                  End If
  Response.Write "</div>" &vbCrLf
  Response.Write "</div>" &vbCrLf
  Response.Write "</div>" &vbCrLf

  'Order / Attendee Information'
  Response.Write "<div class=""container  orderinfo"">" &vbCrLf
  Response.Write "<div class=""row"">" &vbCrLf
  Response.Write "<div class=""col-sm-3 text-left hidden-xs"">" &vbCrLf
  Response.Write "<strong>ORDER INFO</strong><BR>" &vbCrLf
  Response.Write "<Strong>Order Number:</Strong>&nbsp;&nbsp;" & rsTix("OrderNumber") & "<BR>" & vbCrLf
  Response.Write "<strong>Order Date:&nbsp</strong>;&nbsp;" & FormatDateTime(rsTix("OrderDate"), vbShortDate) & "<BR>" & vbCrLf
  Response.Write "<strong>Order Time:&nbsp;&nbsp;</strong>" & FormatDateTime(rsTix("OrderDate"), vbShortTime) & "<BR>" & vbCrLf
  Response.Write "<strong>Order Total:&nbsp;&nbsp;</strong>" & FormatCurrency(rsTix("Total"),2)& "<BR>" & vbCrLf
  Response.Write "</div>" &vbCrLf
  Response.Write "<div class=""visible-lg visible-md visible-sm   text-left col-sm-3"">" &vbCrLf
  Response.Write "<strong>ATTENDEE</strong><BR>" &vbCrLf
  Response.Write "<strong>" &vbCrLf
  Response.Write  rsTix("ShipFirstName") & " " & rsTix("ShipLastName") & "<br>" & vbCrLf
  Response.Write "</strong>" &vbCrLf
            Response.Write rsTix("ShipAddress1") & "<BR>" & vbCrLf
            If rsTix("ShipAddress2") <> "" Then
              Response.Write rsTix("ShipAddress2") & "<BR>" & vbCrLf
            End If
  Response.Write rsTix("ShipCity") & ", " & rsTix("ShipState") & " " & rsTix("ShipPostalCode") & "<BR>" & vbCrLf
  Response.Write "</div>" &vbCrLf
  Response.Write "<div class=""col-sm-3 text-left visible-lg visible-md visible-sm"">" &vbCrLf
  Response.Write "<strong>VENUE</strong><BR>" &vbCrLf
  Response.Write "<strong>" &vbCrLf
  Response.Write rsTix("Venue") & "<br>" & vbCrLf
  Response.Write "</strong>" &vbCrLf
            Response.Write rsTix("VenueAddress1") & "<BR>" & vbCrLf
            If rsTix("VenueAddress2") <> "" Then
            Response.Write rsTix("VenueAddress2") & "<BR>" & vbCrLf
            End If
  Response.Write rsTix("VenueCity") & ", " & rsTix("VenueState") & " " & rsTix("VenuePostalCode") & "<BR>" & vbCrLf
  Response.Write "Phone: " & FormatPhone(rsTix("EventPhoneNumber"), "United States") & "<BR>" & vbCrLf
  Response.Write "</div>" &vbCrLf

  'Barcode Right Landscape
  Response.Write "<div class=""col-sm-3 text-center hidden-xs"">" &vbCrLF
  Response.Write "<BR>" &vbCrLf
  Response.Write "<IMG alt=""Barcode Image"" src=""/Barcode.asp?Barcode=" & rsTix("TicketNumber") & """>&nbsp;" & vbCrLf
  Response.Write "<BR>" &vbCrLf
  Response.Write "<BR>" &vbCrLf
  Response.Write "</div>" &vbCrLf
  Response.Write "</div>" &vbCrLf
  Response.Write "</div>" &vbCrLf

    'Directions & Map'
  Response.Write "<div  class=""container "">" &vbCrLf
  Response.Write "<div class=""row"">" &vbCrLf
  Response.Write "<div style=""height: 120px;"" class=""col-sm-9 visible-lg visible-md visible-sm text-left "">" &vbCrLf

  'Event Options Driving Directions
        If Not IsNull(rsTix("ETicketDrivingDirections")) Then
    Response.Write "<FONT FACE=""Arial, Helvetica"" SIZE=""1"">" & vbCrLf
      Response.Write "<strong>DRIVING DIRECTIONS</strong><BR>" & vbCrLf
      Response.Write rsTix("ETicketDrivingDirections") & vbCrLf
        End If
  Response.Write"</div>" &vbCrLf
  Response.Write "<div style=""height: 120px;"" class=""col-sm-3 visible-sm visible-lg visible-md text-center "">" &vbCrLf

  If Not IsNull(rsTix("ETicketMapPath")) Then
     Response.Write "<IMG width=""50%"" SRC=""" & rsTix("ETicketMapPath") & """>" & vbCrLf
       End If
       Response.Write "</div>" &vbCrLf
       Response.Write "   </div>" &vbCrLf
       Response.Write "</div>" &vbCrLf
  'GENERAL INFORMATION'
  Response.Write "<div class=""container "">" &vbCrLf
  Response.Write "<div class=""row"">" &vbCrLf
  Response.Write "<div style="" height: 68px;"" class=""col-sm-12 visible-lg visible-md visible-sm"">" &vbCrLf
  Response.Write "<STRONG>GENERAL INFORMATION</STRONG>" &vbCrLf
  Response.Write "<div class=""directions"">" &vbCrLf

            If Not IsNull(rsTix("ETicketGeneralInfo")) Then
                                          Response.Write rsTix("ETicketGeneralInfo") & vbCrLf
                                  Else
                                          Response.Write "NO REFUNDS - NO EXCHANGES.  DO NOT COPY THIS TICKET.  MULTIPLE COPIES INVALID.  Holder assumes all risk and danger including, without limitation, injury, death, personal loss, property damage, or other related harm.  Management reserves the right to refuse admission or eject any person who fails to comply with the terms and conditions and/or rules for the event in which this ticket is issued." & vbCrLf
                                  End If

  Response.Write "</div>" &vbCrLf

  Response.Write "</div>" &vbCrLf
  Response.Write "</div>" &vbCrLf
  Response.Write "</div>" &vbCrLf
          <!--AD-->
  Response.Write "<div  class=""container "">" &vbCrLf
  Response.Write "<div class=""row"">" &vbCrLf
  Response.Write "<div   class=""col-sm-12 text-center hidden-xs"">" &vbCrLf
  Response.Write "<hr>" &vbCrLf


'ETicket AdPath
    If Not IsNull(rsTix("ETicketAdPath")) Then
  Response.Write "<IMG SRC=""" & rsTix("ETicketAdPath") & """>" & vbCrLf
    Else
  Response.Write "<IMG SRC=""/Images/ETicketTixLogo.gif"" class=""center-block img-responsive "">" & vbCrLf
    End If
    Response.Write "<BR>" &vbCrLf

    Response.Write "</div>" &vbCrLf
    Response.Write "</div>" &vbCrLf
    Response.Write "</div>" &vbCrLf

'end body of the printable ticket


    'mobile adjustments'
    Response.Write "<div style=""background-image: url(" &  ETicketBackground & "); background-poition: top;"" class=""container barcode-body"" >" &vbCrLf
    Response.Write "<div class=""row"">" &vbCrLf
    Response.Write "<div class=""col-xs-12 text-center visible-xs"">" &vbCrLF
    Response.Write "<br>" &vbCrLF
    Response.Write "<p> " &vbCrLf

    'Producer Field'
    If rsTix("Producer") <> "" Then
      Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""2""><I>" & rsTix("Producer") & "</I></FONT><BR>" & vbCrLf
    Else
      Response.Write "<FONT FACE=""Arial,Helvetica"" SIZE=""2""><I>" & rsTix("Organization") & " presents</I></FONT><BR>" & vbCrLf
    End If


    Response.Write "<br>" &vbCrLF
    Response.Write "<font face=""arial"" size=""3""><b>"& rsTix("Act") & "</b>" &vbCrLf
    Response.Write "<br>" &vbCrLf
    Response.Write "</font>" &vbCrLf
    Response.Write "<font face=""arial"" size=""2""><b>" & rsTix("Venue") & "</b></font>" &vbCrLf
    Response.Write "<br>" &vbCrLf
    Response.Write "<font face=""arial"" size=""2"">" & FormatDateTime(rsTix("EventDate"), vbLongDate) & " at " &        Left(FormatDateTime(rsTix("EventDate"),vbLongTime),Len(FormatDateTime(rsTix("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsTix("EventDate"),vbLongTime),3) &" </font>" &vbCrLF
    Response.Write "<BR>" &vbCrLf
    Response.Write "<font face=""arial"" size=""2"">" & rsTix("SeatType") & "  $" & FormatNumber(rsTix("Price"),2) & "</font>" &vbCrLf
    Response.Write "<BR>" &vbCrLf


    Response.Write "</p>"&vbCrLf
    Response.Write "</div>" &vbCrLf
    Response.Write "</div>" &vbCrLf
    Response.Write "</div>" &vbCrLf


    Response.Write "<div style=""background-color: #000; color: #fff;"" class=""container"">" &vbCrLF
    Response.Write "<div class=""row"">" &vbCrLf
    Response.Write "<div class=""col-xs-6 text-left visible-xs"">" &vbCrLF
    Response.Write "<FONT FACE=""Arial"" size=""2""><B>SECTION</B><BR></FONT>" & vbCrLf
    Response.Write "<FONT FACE=""Arial"" size=""2"">" & rsTix("Section") &"</FONT>" & vbCrLf
    Response.Write "</div>" &vbCrLf
    Response.Write "<div class=""col-xs-3 text-center visible-xs"">" &vbCrLF
    Response.Write "<FONT FACE=""Arial"" size=""2""><B>ROW</B><BR></FONT>" & vbCrLf
    Response.Write "<FONT FACE=""Arial"" size=""2"">" & rsTix("Row") &"</FONT>" & vbCrLf
    Response.Write "</div>" &vbCrLf
    Response.Write "<div class=""col-xs-3 text-center visible-xs"">" &vbCrLF
    Response.Write "<FONT FACE=""Arial"" size=""2""><B>SEAT</B><BR></FONT>" & vbCrLf
    Response.Write "<FONT FACE=""Arial"" size=""2"">" & rsTix("Seat") &"</FONT>" & vbCrLf
    Response.Write "</div>" &vbCrLf
    Response.Write "</div>" &vbCrLf
    Response.Write "</div>" &vbCrLf

    Response.Write "<div class=""container"">" &vbCrLF
    Response.Write "<div class=""row"">" &vbCrLf
    Response.Write "<div class=""col-xs-12 text-center visible-xs"">" &vbCrLF
    Response.Write "<BR>" &vbCrLf
    Response.Write "<IMG alt=""Barcode Image"" src=""/Barcode.asp?Barcode=" & rsTix("TicketNumber") & """>&nbsp;" & vbCrLf
    Response.Write "<BR>" &vbCrLf
    Response.Write "<BR>" &vbCrLf
    Response.Write "</div>" &vbCrLf
    Response.Write "</div>" &vbCrLf
    Response.Write "</div>" &vbCrLf

    'order information
    Response.Write "<div class=""container "">" &vbCrLF
    Response.Write "<div class=""row"">" &vbCrLf
    Response.Write "<div style=""background-color:#000; color:#fff;"" class=""col-xs-12 text-left visible-xs"">" &vbCrLF

    Response.Write "<STRONG>ORDER INFORMATION</STRONG>"&vbCrLf
    Response.Write "<BR>" &vbCrLf
    Response.Write "</div>" &vbCrLf
    Response.Write "</div>" &vbCrLf
    Response.Write "</div>" &vbCrLf
    Response.Write "<div class=""container"">" &vbCrLF
    Response.Write "<div class=""row"">" &vbCrLf
    Response.Write "<div style=""background-color:#fff; color:#000;  font-size: 12px;"" class=""col-xs-12 text-left visible-xs"">" &vbCrLF
    Response.Write "<Strong>Order Number:</Strong>&nbsp;&nbsp;" & rsTix("OrderNumber") & "<BR>" & vbCrLf
    Response.Write "<strong>Order Date:&nbsp</strong>;&nbsp;" & FormatDateTime(rsTix("OrderDate"), vbShortDate) & "<BR>" & vbCrLf
    Response.Write "<strong>Order Time:&nbsp;&nbsp;</strong>" & FormatDateTime(rsTix("OrderDate"), vbShortTime) & "<BR>" & vbCrLf
    Response.Write "<strong>Order Total:&nbsp;&nbsp;</strong>" & FormatCurrency(rsTix("Total"),2)& "<BR>" & vbCrLf
    Response.Write "</div>" &vbCrLf
    Response.Write "</div>" &vbCrLf
    Response.Write "</div>" &vbCrLf

    'attendee information
    Response.Write "<div class=""container"">" &vbCrLF
    Response.Write "<div class=""row"">" &vbCrLf
    Response.Write "<div style=""background-color:#000; color:#fff;"" class=""col-xs-12 text-left visible-xs"">" &vbCrLF

    Response.Write "<STRONG>ATTENDEE INFORMATION</STRONG>"&vbCrLf
    Response.Write "<BR>" &vbCrLf
    Response.Write "</div>" &vbCrLf
    Response.Write "</div>" &vbCrLf
    Response.Write "</div>" &vbCrLf
    Response.Write "<div class=""container"">" &vbCrLF
    Response.Write "<div class=""row"">" &vbCrLf
    Response.Write "<div style=""background-color:#fff; color:#000; font-size: 12px;"" class=""col-xs-12 text-left visible-xs "">" &vbCrLF
    Response.Write  rsTix("ShipFirstName") & " " & rsTix("ShipLastName") & "<br>" & vbCrLf
    Response.Write "</div>" &vbCrLf
    Response.Write "</div>" &vbCrLf
    Response.Write "</div>" &vbCrLf
    'venue information
    Response.Write "<BR>" &vbCrLf
    Response.Write "<div class=""container"">" &vbCrLF
    Response.Write "<div class=""row"">" &vbCrLf
    Response.Write "<div style=""background-color:#000; color:#fff;"" class=""col-xs-12 text-left visible-xs"">" &vbCrLF
    Response.Write "<STRONG>VENUE INFORMATION</STRONG>"&vbCrLf
    Response.Write "<BR>" &vbCrLf
    Response.Write "</div>" &vbCrLf
    Response.Write "</div>" &vbCrLf
    Response.Write "</div>" &vbCrLf

    'venue name, address and phone number
    Response.Write "<div class=""container"">" &vbCrLF
    Response.Write "<div class=""row"">" &vbCrLf
    Response.Write "<div style=""background-color:#fff; color:#000; font-size: 12px;"" class=""col-xs-12 text-left visible-xs"">" &vbCrLF
    Response.Write "<strong>" &vbCrLf
    Response.Write rsTix("Venue") & "<br>" & vbCrLf
    Response.Write "</strong>" &vbCrLf
    Response.Write "<addressmobile>" &vbCrLf
    Response.Write rsTix("VenueAddress1") & "<BR>" & vbCrLf

    Response.Write rsTix("VenueCity") & ", " & rsTix("VenueState") & " " & rsTix("VenuePostalCode") & "<BR>" & vbCrLf
    Response.Write "</addressmobile>" &vbCrlf

    Response.Write "<BR>" &vbCrLf
    Response.Write "<strong>Phone:</strong> " & FormatPhone(rsTix("EventPhoneNumber"), "United States") & "<BR>" & vbCrLf

    Response.Write "</div>" &vbCrLf
    Response.Write "</div>" &vbCrLf
    Response.Write "</div>" &vbCrLf

    Response.Write "<div class=""container"">" &vbCrLf
    Response.Write "<div class=""row"">" &vbCrLf
    Response.Write "<div class=""col-xs-12 visible-xs text-center"">" &vbCrLf
    Response.Write "<BR>" &vbCrLf
    Response.Write "<i class=""fa fa-chevron-circle-up fa-2x""></i>" &vbCrLf
    Response.Write "</div>" &vbCrLf
    Response.Write "</div>" &vbCrLf
    Response.Write "</div>" &vbCrLf
        'End mobile adjustments
        rsTix.MoveNext

        If Not rsTix.EOF Then
    Response.Write "<DIV CLASS=""PageBreak"">&nbsp;</DIV>" 'Page Break
        End If


    Loop

    'ETicket Background Adjustment

          Response.Write "</DIV>" &vbCrlf 'Page Break
    Response.Write "</BODY>" & vbCrLf
    Response.Write "</HTML>" & vbCrLf
    PageCount = PageCount + 1
    ErrorLog("PageCount: " & PageCount & "")

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
