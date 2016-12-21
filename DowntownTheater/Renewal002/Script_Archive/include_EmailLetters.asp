<%

Sub DisplayEmails
			
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
				SQLTickets = "SELECT COUNT(OrderLine.ItemNumber) AS TicketCount, Act.Act, EventDate, Event.EventCode, Venue FROM Event (NOLOCK) INNER JOIN Seat ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Shipping ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN Act ON Event.ActCode = Act.ActCode INNER JOIN Venue ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber INNER JOIN OrganizationAct ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber WHERE Event.EventCode IN " & EventList & " AND EventDate > GETDATE() AND OrderLine.StatusCode = 'R' AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') AND Customer.EMailAddress IS NOT NULL AND Customer.EMailAddress <> '' GROUP BY Event.EventCode, EventDate, Act.Act, Venue.Venue ORDER BY EventDate, Act.Act"
				Set rsTickets = OBJdbConnection.Execute(SQLTickets)
				
				'REE 4/6/2 - Modified to check for events.
				If Not rsTickets.EOF Then 'There are some events.  List them
					Response.Write "<FORM ACTION=""RenewalEMail.asp"" METHOD=""post""><INPUT TYPE=""hidden"" NAME=""FormName"" VALUE=""PrintMenu"">" & vbCrLf

					%>
					<table class="table table-data table-striped table-hover table-checkbox"> 
						<thead> 
							<tr class="noselect"> 
								<th class="cell-center">Print</th> 
								<th class="sort-alpha">Subscription Name</th> 
								<th class="sort-numb">Venue</th> 
								<th class="sort-numb">Date/Time</th> 
								<th class="sort-numb">Quantity</th> 
							</tr> 
						</thead> 
					<%	
					Response.Write "<TBODY>" & vbCrLf

					'Display Event and UnPrinted Ticket Quantities
					Do Until rsTickets.EOF

						Response.Write "<TR><TD><INPUT TYPE=""checkbox"" NAME=""EventCode"" VALUE=" & rsTickets("EventCode") & "></TD><TD>" & cleanHTML(rsTickets("Act")) & "</TD><TD>" & cleanHTML(rsTickets("Venue")) & "</TD><TD>" & DateAndTimeFormat(rsTickets("EventDate")) & "</TD><TD>" & rsTickets("TicketCount") & "</TD></TR>" & vbCrLf

						rsTickets.MoveNext

					Loop
					Response.Write "</TBODY>" & vbCrLf	
					Response.Write "</TABLE><BR>" & vbCrLf
					'Display Buttons to Print
					Response.Write "Select the Renewal Events for which you want to send e-mails and click 'Send E-Mails' below.<BR><BR>" & vbCrLf
					Response.Write "<INPUT TYPE=""submit"" CLASS=""btn btn-outline btn-default"" VALUE=""Send E-Mails""></FORM>" & vbCrLf
				Else 'There aren't any matching events
					Response.Write "<BR><BR>There are no events to be generated.<BR><BR>" & vbCrLf
				End If
			Else 'There aren't any matching events
				Response.Write "<BR><BR>There are no events to be generated.<BR><BR>" & vbCrLf
			End If
			
			
End Sub

'--------------------------------------

Sub SendEmails

	DIM FName
	DIM LName
	DIM EmailTemplateFile
	EmailTemplateFile = "EmailInclude.asp"
	
	
	'Build the Query to select each of the selected events
	'REE 7/7/3 - Removed EventShip from Query.
	SQLOrderLine = "SELECT OrderHeader.OrderTypeNumber, OrderHeader.OrderSurcharge, OrderHeader.ShipFee, OrderHeader.Total, OrderLine.OrderNumber, OrderLine.LineNumber, OrderLine.ItemNumber, OrderLine.Price, OrderLine.Surcharge, OrderLine.Discount, OrderLine.ShipCode, Event.EventCode, Event.EventDate, Event.Map, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, PostalCode, Customer.DayPhone, Customer.NightPhone, Customer.EMailAddress, Shipping.ShipType, Act.Act, Venue.Venue, SeatType.SeatType, Seat.Row, Seat.Seat, Seat.SectionCode, Section.Section FROM OrderLine INNER JOIN OrderHeader ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN Seat ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event ON Seat.EventCode = Event.EventCode INNER JOIN Section ON Seat.SectionCode = Section.SectionCode AND Event.EventCode = Section.EventCode INNER JOIN Act ON Event.ActCode = Act.ActCode INNER JOIN Venue ON Event.VenueCode = Venue.VenueCode INNER JOIN SeatType ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN Shipping ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct ON Event.ActCode = OrganizationAct.ActCode "
	For Each Item In Request("EventCode") 'Loop for each Event requested
		EventNumber = EventNumber + 1
		If SQLWhere = "" Then 
			SQLWhere = " WHERE Event.EventCode IN (" & Clean(Request("EventCode"))
		Else
			SQLWhere = SQLWhere & ", " & Clean(Request("EventCode"))
		End If
	Next

	'Get the Info to Print
	'REE 4/6/2 - Modified to use OrganizationAct in selection criteria
	SQLOrderLine = SQLOrderLine & SQLWhere & ") AND OrderLine.StatusCode = 'R' AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') AND Customer.EMailAddress IS NOT NULL AND Customer.EMailAddress <> '' AND OrderHeader.OrderNumber > 2082898 ORDER BY OrderLine.OrderNumber, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry, OrderLine.ShipCode, Seat.EventCode, Seat.SectionCode, RowSort, SeatSort DESC"
	Set rsOrderLine = OBJdbConnection.Execute(SQLOrderLine)
				
		Do Until rsOrderLine.EOF

			If rsOrderLine("OrderNumber") <> LastOrderNumber Then 
			'This is not the last order.
			
				'Print the footer
				If TicketCount > 0 Then
				
					EMailMessage = EMailMessage & "<TR><TD WIDTH=""50"">&nbsp;</TD><TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf			
					If LastShipFee <> 0 And LastOrderTypeNumber <> 5 Then
						EMailMessage = EMailMessage & "<TR><TD WIDTH=""50"">&nbsp;</TD><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=" & MsgFontFace & ">Processing Fee</TD><TD ALIGN=""right""><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(LastShipFee,2) & "</TD></TR>" & vbCrLf
						EMailMessage = EMailMessage & "<TR><TD WIDTH=""50"">&nbsp;</TD><TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf
					End If

					SQLTender = "SELECT SUM(Tender.Amount) AS TenderAmount FROM Tender (NOLOCK) WHERE Tender.OrderNumber = " & LastOrderNumber
					Set rsTender = OBJdbConnection.Execute(SQLTender)
				
					If IsNull(rsTender("TenderAmount")) Then
						LastTender = 0
					Else
						LastTender = rsTender("TenderAmount")
						Response.Write SQLTender & "<BR>"
					End If
				
					rsTender.Close
					Set rsTender = nothing	

					EMailMessage = EMailMessage & "<TR><TD WIDTH=""50"">&nbsp;</TD><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=" & MsgFontFace & ">Order Total</TD><TD ALIGN=""right""><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(LastTotal,2) & "</TD></TR>" & vbCrLf
					If LastTender <> 0 Then
						EMailMessage = EMailMessage & "<TR><TD WIDTH=""50"">&nbsp;</TD><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=C" & MsgFontFace & ">Less Payments</TD><TD ALIGN=""right""><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(LastTender,2) & "</TD></TR>" & vbCrLf
						EMailMessage = EMailMessage & "<TR><TD WIDTH=""50"">&nbsp;</TD><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=" & MsgFontFace & ">Balance Due</TD><TD ALIGN=""right""><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(LastTotal - LastTender,2) & "</TD></TR>" & vbCrLf
					End If
					EMailMessage = EMailMessage & "</TABLE>" & vbCrLf
					EMailMessage = EMailMessage & "</CENTER><BR>" & vbCrLf
					
					'-----------------------------------------
					
					'Insert HTML Template - Footer Content
					EMailMessage = EMailMessage & InsertTemplate(EmailTemplateFile,"Footer") 
					
					'-----------------------------------------

					'JAI 3/2/5 - Modified to use CDO Mail
					'Create the e-mail server object
					Set objCDOSYSMail = Server.CreateObject("CDO.Message")
					Set objCDOSYSCon = Server.CreateObject ("CDO.Configuration")

					objCDOSYSCon.Fields(cdoSendUsingMethod) = cdoSendUsingPickup 'For localhost
					objCDOSYSCon.Fields.Update

					'Update the CDOSYS Configuration
					Set objCDOSYSMail.Configuration = objCDOSYSCon
					objCDOSYSMail.From = EMailOrganization & " <" & EMailReplyTo & ">" 
					objCDOSYSMail.ReplyTo = EMailReplyTo
					If TestEMailAddress <> "" Then
						EmailAddress = LastEMailAddress
						LastEMailAddress = TestEMailAddress
					End If
					objCDOSYSMail.To = LastEMailAddress
					objCDOSYSMail.Subject = EMailSubject
					objCDOSYSMail.HTMLBody = EMailMessage
					objCDOSYSMail.Send

					'Close the server mail object
					Set objCDOSYSMail = Nothing
					Set objCDOSYSCon = Nothing 

					EMailMessage = ""
					
					'One Log Results

					OrderIndex = OrderCount + 1
					
					logResults = logResults & "<id>" & OrderCount  & "</id><organizationnumber>" & Session("OrganizationNumber") & "</organizationnumber><ordernumber>" & LastOrderNumber & "</ordernumber><firstname>" & ShipFName & "</firstname><lastname>" & ShipLName & "</lastname><emailaddress>" & LastEMailAddress & "</emailaddress><renewalnumber>" & CustomerNumber & "-" & OrderItemNumber & "</renewalnumber><datesent>" & Now() & "</datesent>,"
				
					If TestEMailAddress <> "" And OrderCount >= TestEmailCount Then
						Exit Do
					End If

				End If

				SQLCustInfo = "SELECT Customer.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry FROM OrderHeader (NOLOCK) INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber WHERE OrderHeader.OrderNumber = " & rsOrderLine("OrderNumber") & " AND OrderLine.LineNumber = " & rsOrderLine("LineNumber")
				Set rsCustInfo = OBJdbConnection.Execute(SQLCustInfo)

				If Not rsCustInfo.EOF Then
				
					'-----------------------------------------
					
					'Insert HTML Template - Header Content
					EMailMessage = EMailMessage & InsertTemplate(EmailTemplateFile,"Header") 
					
					'-----------------------------------------
								
					'Insert HTML Template - Masthead Content
					EMailMessage = EMailMessage & InsertTemplate(EmailTemplateFile,"Masthead") 
					
					'-----------------------------------------
								
					'Shipping and Billing Address
					
					'EMailMessage = EMailMessage & "<TABLE WIDTH=""750"" cellpadding=""0"" cellspacing=""0""  border=""0"">" & vbCrLf
					'EMailMessage = EMailMessage & "<TR>" & vbCrLf
					'EMailMessage = EMailMessage & "<TD WIDTH=""400""><FONT FACE=""" & MsgFontFace & """><B>Shipping Information</B></TD>" & vbCrLf
					'EMailMessage = EMailMessage & "<TD WIDTH=""330""><FONT FACE=""" & MsgFontFace & """><B>Billing Information</B></TD>" & vbCrLf
					'EMailMessage = EMailMessage & "</TR>" & vbCrLf
					'EMailMessage = EMailMessage & "<TR>" & vbCrLf
					'EMailMessage = EMailMessage & "<TD>" & vbCrLf
					
					'ShipFName = rsCustInfo("ShipFirstName")
					'ShipLName = rsCustInfo("ShipLastName") 
					
					'EMailMessage = EMailMessage & "<FONT FACE=""" & MsgFontFace & """>" & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & "<BR>" & rsCustInfo("ShipAddress1") & "<BR>" & vbCrLf
					
					'If rsCustInfo("ShipAddress2") <> "" Then
					'	EMailMessage = EMailMessage & rsCustInfo("ShipAddress2") & "<BR>" & vbCrLf
					'End If
					
					'EMailMessage = EMailMessage & rsCustInfo("ShipCity") & ", " & rsCustInfo("ShipState") & " " & rsCustInfo("ShipPostalCode") & "" & vbCrLf
					
					'EMailMessage = EMailMessage & "</TD>" & vbCrLf
					'EMailMessage = EMailMessage & "<TD>" & vbCrLf
					'EMailMessage = EMailMessage & "<FONT FACE=""" & MsgFontFace & """>" & rsCustInfo("FirstName") & " " & rsCustInfo("LastName") & "<BR>" & rsCustInfo("Address1") & "<BR>" & vbCrLf
					
					'If rsCustInfo("Address2")<> "" Then
					'	EMailMessage = EMailMessage & rsCustInfo("Address2") & "<BR>" & vbCrLf
					'End If
					
					'EMailMessage = EMailMessage & rsCustInfo("City") & ", " & rsCustInfo("State") & " " & rsCustInfo("PostalCode") & "" & vbCrLf
					'EMailMessage = EMailMessage &"</TD>" & vbCrLf
					'EMailMessage = EMailMessage & "</TR>" & vbCrLf
					'EMailMessage = EMailMessage & "<TR>" & vbCrLf
					'EMailMessage = EMailMessage & "<TD COLSPAN=""3""><hr></TD>" & vbCrLf
					'EMailMessage = EMailMessage & "</TR>" & vbCrLf
					'EMailMessage = EMailMessage & "</TABLE>" & vbCrLf
					
					'EMailMessage = EMailMessage & "<BR>" & vbCrLf
					
					'-----------------------------------------
					
					'Order Number and Renewal Number
					
					EMailMessage = EMailMessage & "<TABLE WIDTH=""750"" cellpadding=""0"" cellspacing=""0"" border=""0"">" & vbCrLf
					EMailMessage = EMailMessage & "<TR>" & vbCrLf
					EMailMessage = EMailMessage & "<TD ALIGN=""left"">" & vbCrLf
					EMailMessage = EMailMessage & "<FONT FACE=""" & MsgFontFace & """><B>Order Number:</B>&nbsp;" & rsOrderLine("OrderNumber") & "</FONT>" & vbCrLf
					EMailMessage = EMailMessage & "</TD>" & vbCrLf
					EMailMessage = EMailMessage & "<TD ALIGN=""right"">" & vbCrLf
					
					SQLItemNumber = "SELECT ItemNumber FROM OrderLine (NOLOCK) WHERE OrderNumber = " & rsOrderLine("OrderNumber") & " ORDER BY ItemNumber"
					Set rsItemNumber = OBJdbConnection.Execute(SQLItemNumber)
						CustomerNumber = rsCustInfo("CustomerNumber")
						OrderItemNumber = rsItemNumber("ItemNumber")
						RenewalCode = rsCustInfo("CustomerNumber") & rsItemNumber("ItemNumber")
					rsItemNumber.Close
					Set rsItemNumber = nothing
					
					EMailMessage = EMailMessage & "<FONT FACE=""" & MsgFontFace & """><B>Renewal Code:</B>&nbsp;" & RenewalCode & "</FONT>" & vbCrLf
					EMailMessage = EMailMessage & "</TD>" & vbCrLf
					EMailMessage = EMailMessage & "</TR>" & vbCrLf
					EMailMessage = EMailMessage & "</TABLE>" & vbCrLf
					EMailMessage = EMailMessage & "<BR>" & vbCrLf
					
					'-----------------------------------------

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
				
				LastEMailAddress = rsOrderLine("EMailAddress")
				
				TicketCount = TicketCount + 1

			End If

			'Print Event Info and Column Headings if this is a new Event
			If LastEventCode <> rsOrderLine("EventCode") Or LastOrderNumber <> rsOrderLine("OrderNumber") Then
			
				If LastEventCode <> 0 AND LastEventCode <> rsOrderLine("EventCode") Then
					EMailMessage = EMailMessage & "</TABLE><BR>" & vbCrlf
				End if
				
				'-----------------------------------------
					
				'Production Name, Date & Time
				'Order Delivery Method
			
				EMailMessage = EMailMessage & "<TABLE WIDTH=""750"" cellpadding=""0"" cellspacing=""0""  border=""0"">" & vbCrLf
				EMailMessage = EMailMessage & "<TR><TD><FONT FACE=""" & MsgFontFace & """><B>" & rsOrderLine("Act") & " at " & rsOrderLine("Venue") & "" & vbCrLf
				
				'REE 6/5/6 - Modified to look at EventOptions for Date & Time Display Options
				SQLDateSuppress = "SELECT OptionValue AS DateSuppress FROM EventOptions (NOLOCK) WHERE EventCode = " & rsOrderLine("EventCode") & " AND OptionName = 'DateSuppress' AND OptionValue = 'Y'"
				Set rsDateSuppress = OBJdbConnection.Execute(SQLDateSuppress)
				If rsDateSuppress.EOF Then
					EMailMessage = EMailMessage & " on " & FormatDateTime(rsOrderLine("EventDate"),vbShortDate)
				End If
				rsDateSuppress.Close
				Set rsDateSuppress = nothing

				SQLTimeSuppress = "SELECT OptionValue AS TimeSuppress FROM EventOptions (NOLOCK) WHERE EventCode = " & rsOrderLine("EventCode") & " AND OptionName = 'TimeSuppress' AND OptionValue = 'Y'"
				Set rsTimeSuppress = OBJdbConnection.Execute(SQLTimeSuppress)
				If rsTimeSuppress.EOF Then
					EMailMessage = EMailMessage & " at " & Left(FormatDateTime(rsOrderLine("EventDate"),vbLongTime),Len(FormatDateTime(rsOrderLine("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsOrderLine("EventDate"),vbLongTime),3)
				End If
				rsTimeSuppress.Close
				Set rsTimeSuppress = nothing

				EMailMessage = EMailMessage & "</B><BR>Delivery Method: " & rsOrderLine("ShipType") & "</TD></TR>" & vbCrLf
				EMailMessage = EMailMessage & "</TABLE>" & vbCrLf
				
				EMailMessage = EMailMessage & "<BR>" & vbCrLf
				
				'-----------------------------------------
				
				'Seat Location, Price, Service Fee

				'Calculate Number of Columns
				SQLNumColumns = "SELECT SUM(OrderLine.Surcharge) AS ServiceFee, SUM(OrderLine.Discount) AS Discount FROM OrderLine WHERE OrderNumber = " & rsOrderLine("OrderNumber") & " AND ItemType IN ('Seat', 'SubFixedEvent')"
				Set rsNumColumns = OBJdbConnection.Execute(SQLNumColumns)

				NumColumns = 6
				ColumnHeading = "<TABLE WIDTH=""660"" BORDER=""0""><TR><TD WIDTH=10>&nbsp;</TD><TD><FONT FACE=" & MsgFontFace & "><B><U>Section</U></B></FONT></TD><TD ALIGN=center><FONT FACE=" & MsgFontFace & "><B><U>Row</U></B></FONT></TD><TD ALIGN=center><FONT FACE=" & MsgFontFace & "><B><U>Seat</U></B></FONT></TD><TD><FONT FACE=" & MsgFontFace & "><B><U>Type</U></B></FONT></TD><TD ALIGN=right><FONT FACE=" & MsgFontFace & "><B><U>Price</U></B></FONT></TD>"
				
				FacilityCharge = 0
				If FacilityCharge <> 0 Then
					NumColumns = NumColumns + 1
					ColumnHeading = ColumnHeading + "<TD ALIGN=right><FONT FACE=" & MsgFontFace & "><B><U>Facility Charge</U></B></FONT></TD>"
					ColFacilityCharge = "Y"
				End If
				
				If rsNumColumns("ServiceFee") <> 0 Then
					NumColumns = NumColumns + 1
					ColumnHeading = ColumnHeading + "<TD ALIGN=right><FONT FACE=" & MsgFontFace & "><B><U>Service Fee</U></B></FONT></TD>"
					ColServiceFee = "Y"
				End If
				
				If rsNumColumns("Discount") <> 0 Then
					NumColumns = NumColumns + 1
					ColumnHeading = ColumnHeading + "<TD ALIGN=right><FONT FACE=" & MsgFontFace & "><B><U>Discount</U></B></FONT></TD>"
					ColDiscount = "Y"
				End If

				rsNumColumns.Close
				Set rsNumColumns = nothing

				ColumnHeading = ColumnHeading + "<TD ALIGN=right><FONT FACE=" & MsgFontFace & "><B><U>Amount</U></B></FONT></TD></TR>" & vbCrLf
				
				EMailMessage = EMailMessage & ColumnHeading

				LastEventCode = rsOrderLine("EventCode")
				
				'-----------------------------------------
				
			End If
			
			'-----------------------------------------
				
			'Facility Charge, Surcharge, Discount, Price
			
			LineDetail = "<TR><TD WIDTH=10>&nbsp;</TD><TD><FONT FACE=" & MsgFontFace & ">" & rsOrderLine("Section") & "</FONT></TD><TD ALIGN=center><FONT FACE=" & MsgFontFace & ">" & rsOrderLine("Row") & "</FONT></TD><TD ALIGN=center><FONT FACE=" & MsgFontFace & ">" & rsOrderLine("Seat") & "</FONT></TD><TD><FONT FACE=" & MsgFontFace & ">" & rsOrderLine("SeatType") & "</FONT></TD><TD ALIGN=right><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(rsOrderLine("Price"),2) & "</FONT></TD>"
			
			If ColFacilityCharge = "Y" Then
				LineDetail = LineDetail & "<TD ALIGN=right><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(FacilityCharge,2) & "</FONT></TD>"
			End If
			If ColServiceFee = "Y" Then
				LineDetail = LineDetail & "<TD ALIGN=right><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(rsOrderLine("Surcharge"),2) & "</FONT></TD>"
			End If
			If ColDiscount = "Y" Then
				LineDetail = LineDetail & "<TD ALIGN=right><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(rsOrderLine("Discount"),2) & "</FONT></TD>"
			End If
			
			LineDetail = LineDetail & "<TD ALIGN=right><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(rsOrderLine("Price")+FacilityFee+rsOrderLine("Surcharge")-rsOrderLine("Discount"),2) & "</FONT></TD></TR>" & vbCrLf
			
			EMailMessage = EMailMessage & LineDetail

			LastOrderNumber = rsOrderLine("OrderNumber")
			
			'-----------------------------------------
			
		rsOrderLine.MoveNext	
		Loop	
		
		If TicketCount > 0 Then	'Print the last footer

			EMailMessage = EMailMessage & "</TABLE>" & vbCrLf
			EMailMessage = EMailMessage & "</CENTER><BR>" & vbCrLf
			EMailMessage = EMailMessage & EMailMessageBody
			
			If TestEMailAddress = "" Then
			
					EMailMessage = EMailMessage & "<TR><TD WIDTH=""50"">&nbsp;</TD><TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf			
					
					If LastShipFee <> 0 And LastOrderTypeNumber <> 5 Then
						EMailMessage = EMailMessage & "<TR><TD WIDTH=""50"">&nbsp;</TD><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=" & MsgFontFace & ">Processing Fee</TD><TD ALIGN=""right""><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(LastShipFee,2) & "</TD></TR>" & vbCrLf
						EMailMessage = EMailMessage & "<TR><TD WIDTH=""50"">&nbsp;</TD><TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf
					End If

					SQLTender = "SELECT SUM(Tender.Amount) AS TenderAmount FROM Tender (NOLOCK) WHERE Tender.OrderNumber = " & LastOrderNumber
					Set rsTender = OBJdbConnection.Execute(SQLTender)
						If IsNull(rsTender("TenderAmount")) Then
							LastTender = 0
						Else
							LastTender = rsTender("TenderAmount")
							Response.Write SQLTender & "<BR>"
						End If
					rsTender.Close
					Set rsTender = nothing	

					EMailMessage = EMailMessage & "<TR><TD WIDTH=""50"">&nbsp;</TD><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=" & MsgFontFace & ">Order Total</TD><TD ALIGN=""right""><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(LastTotal,2) & "</TD></TR>" & vbCrLf
					
					If LastTender <> 0 Then
						EMailMessage = EMailMessage & "<TR><TD WIDTH=""50"">&nbsp;</TD><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=" & MsgFontFace & ">Less Payments</TD><TD ALIGN=""right""><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(LastTender,2) & "</TD></TR>" & vbCrLf
						EMailMessage = EMailMessage & "<TR><TD WIDTH=""50"">&nbsp;</TD><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=" & MsgFontFace & ">Balance Due</TD><TD ALIGN=""right""><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(LastTotal - LastTender,2) & "</TD></TR>" & vbCrLf
					End If
								
					EMailMessage = EMailMessage & "</TABLE><BR>" & vbCrLf
					
					'-----------------------------------------
					
					'Footer Info
					'Insert HTML Template - Footer Content
					 EMailMessage = EMailMessage & InsertTemplate(EmailTemplateFile,"Footer") 
					
					'-----------------------------------------
					
					EMailMessage = EMailMessage & "</CENTER>" & vbCrLf
					

				'JAI 3/2/5 - Modified to use CDO Mail
				'Create the e-mail server object
				Set objCDOSYSMail = Server.CreateObject("CDO.Message")
				Set objCDOSYSCon = Server.CreateObject ("CDO.Configuration")

				objCDOSYSCon.Fields(cdoSendUsingMethod) = cdoSendUsingPickup 'For localhost
				objCDOSYSCon.Fields.Update

				'Update the CDOSYS Configuration
				Set objCDOSYSMail.Configuration = objCDOSYSCon
				objCDOSYSMail.From = EMailOrganization & " <" & EMailReplyTo & ">" 
				objCDOSYSMail.ReplyTo = EMailReplyTo
				objCDOSYSMail.To = LastEMailAddress
				objCDOSYSMail.BCC = ""
				objCDOSYSMail.Subject = EMailSubject
				objCDOSYSMail.HTMLBody = EMailMessage
				objCDOSYSMail.Send

				'Close the server mail object
				Set objCDOSYSMail = Nothing
				Set objCDOSYSCon = Nothing 
				
				'Two Log Results

				OrderCount = OrderCount + 1
				
				logResults = logResults & "<id>" & OrderCount  & "</id><organizationnumber>" & Session("OrganizationNumber") & "</organizationnumber><ordernumber>" & LastOrderNumber & "</ordernumber><firstname>" & ShipFName & "</firstname><lastname>" & ShipLName & "</lastname><emailaddress>" & LastEMailAddress & "</emailaddress><renewalnumber>" & CustomerNumber & "-" & OrderItemNumber & "</renewalnumber><datesent>" & Now() & "</datesent>,"
			
			End If
			
			EMailMessage = ""

		End If

		'Response.Write "Order Count: " & OrderCount & "<BR>"
	
	rsOrderLine.Close
	Set rsOrderLine = nothing

	
End Sub 'Send Emails


%>