<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%
Page = "Survey"
'9.15.07 SM ===>This survey presents patrons with an add-on event offer.  Modified "SurveySkirballNoaksArkNew".
SurveyNumber = 299
SurveyFileName = "SurveySCB2007.asp"

'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	OBJdbConnection.Close
	Set OBJdbConnection = nothing
	Response.Redirect("/Default.asp")
End If

Select Case Request("FormName")
	'Case "MemberNumberForm"
		'Call ValidateMember(Clean(Request("MemberNumber"))) ===>9.15.07 SM
	Case "EventOffer"
		Call AddToCart(CleanNumeric(Request("EventCode")), Clean(Request("SectionCode")), CleanNumeric(Request("Quantity")))
	Case "Continue"
		Call Continue 'SM 9.15.07==>Look Here===>Changed Call to "Call Continue"
	Case Else
		Call TicketOffer(Message)
End Select

'==============================

Sub TicketOffer(Message)

'Check for qualifying events on this order

Call DBOpen(OBJdbConnection2)

Dim RequiredEventSection(7)
Dim OfferEventSection(7)

RequiredEventSection(0) = "Seat.EventCode = 110455"
OfferEventSection(0) = "Seat.EventCode = 110453 AND Seat.SectionCode IN ('GA')"

RequiredEventSection(1) = "Seat.EventCode = 110454"
OfferEventSection(1) = "Seat.EventCode = 110452 AND Seat.SectionCode IN ('GA')"

RequiredEventSection(2) = "Seat.EventCode = 111075"
OfferEventSection(2) = "Seat.EventCode = 111808 AND Seat.SectionCode IN ('GA')"

RequiredEventSection(3) = "Seat.EventCode = 110448"
OfferEventSection(3) = "Seat.EventCode = 110456 AND Seat.SectionCode IN ('GA')"

RequiredEventSection(4) = "Seat.EventCode = 110449"
OfferEventSection(4) = "Seat.EventCode = 110457 AND Seat.SectionCode IN ('GA')"

RequiredEventSection(5) = "Seat.EventCode = 110450"
OfferEventSection(5) = "Seat.EventCode = 110458 AND Seat.SectionCode IN ('GA')"

RequiredEventSection(6) = "Seat.EventCode = 110451"
OfferEventSection(6) = "Seat.EventCode = 110459 AND Seat.SectionCode IN ('GA')"


OfferText = ""

'For EventCount = 0 To 6

	SQLWorkshop = "SELECT COUNT(OrderLine.ItemNumber) AS TicketCount, Seat.EventCode FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.SeatTypeCode = 5 AND OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Seat.EventCode IN (110455, 110454, 111075, 110448, 110449, 110450, 110451) AND OrderLine.ItemType = 'Seat' GROUP BY Seat.EventCode ORDER BY Seat.EventCode"
	Set rsWorkshop = OBJdbConnection.Execute(SQLWorkshop)
	
	If Not rsWorkshop.EOF Then
		TicketCount = rsWorkshop("TicketCount")
		SelectedEventCode = rsWorkshop("EventCode")
	Else
		Response.Redirect("/Clients/SpindleCityBallet/Surveys/SCBQuestionnaire.asp")
		TicketCount = 0
	End If
	
	rsWorkshop.Close
	Set rsWorkshop = nothing
	
	counter = 0
	If TicketCount > 0 Then
	    If SelectedEventCode = "110454" Then
	        NewEventCode = "110452"
	    ElseIf SelectedEventCode = "110455" Then
	        NewEventCode = "110453"
	    Else
	        NewEventCode = "110453, 110452, 111808, 110456, 110457, 110458, 110459"
	    End If

		SQLSection = "SELECT Act.Act, Act.Comments, Event.EventCode, Event.EventDate, Section.SectionCode, Section.Section, COUNT(Seat.ItemNumber) AS AvailableCount FROM Seat (NOLOCK) INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.EventCode IN(" & NewEventCode & ") AND Seat.SectionCode IN ('GA') AND Seat.StatusCode = 'A' GROUP BY Act.Act, Act.Comments, Event.EventCode, Event.EventDate, Section.SectionCode, Section.Section ORDER BY Section.Section"
		Set rsSection = OBJdbConnection.Execute(SQLSection)
		
		SectionCount = 0
			
		Do Until rsSection.EOF
			Act = rsSection("Act")
			Comments = rsSection ("Comments")
			EventCode = rsSection("EventCode")
			EventDate = rsSection("EventDate")
			SectionCode = rsSection("SectionCode")
			Section = rsSection("Section")
			AvailableCount = rsSection("AvailableCount")
			
			'Get Existing Offer Count on this order
			SQLApplied = "SELECT COUNT(OrderLine.ItemNumber) AS AppliedCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Seat.EventCode IN(110453, 110452, 111808, 110456, 110457, 110458, 110459) AND Seat.SectionCode IN ('GA')" '& OfferEventSection(EventCount)
			Set rsApplied = OBJdbConnection2.Execute(SQLApplied)
			
			AppliedCount = rsApplied("AppliedCount")
			
			rsApplied.Close
			Set rsApplied = nothing
			
			If TicketCount <= AvailableCount And TicketCount > AppliedCount Then
					
				SectionCount = SectionCount + 1
						
				If SectionCount = 1 Then 'Display the Event info and start a new row.
					OfferText = OfferText & "<TABLE WIDTH=""600""><TR><TD COLSPAN=""2""><FONT FACE=" & FontFace & " COLOR=" &  FontColor & " SIZE=2><B>" & Act & " on " & FormatDateTime(EventDate, vbLongDate) & " - " & TicketCount - AppliedCount & " Tickets</B><BR><BR>" & Comments & "</FONT></TD></TR>" & vbCrLf
					OfferText = OfferText & "<TR>"
				End If
				
				If counter = 0 Then
				    OfferText = OfferText & "<TD><FORM ACTION=""" & SurveyFileName & """ METHOD=""post"" id=form1 name=form1><INPUT TYPE=""hidden"" NAME=""FormName"" VALUE=""EventOffer""><INPUT TYPE=""hidden"" NAME=""EventCode"" VALUE=""" & EventCode & """><INPUT TYPE=""hidden"" NAME=""SectionCode"" VALUE=""" & SectionCode & """><INPUT TYPE=""hidden"" NAME=""Quantity"" VALUE=""" & TicketCount - AppliedCount & """><INPUT TYPE=""submit"" VALUE=""" & Section & """ id=1 name=1></FORM></TD>"
				End If
			
			End If
			
            counter = counter + 1					
			rsSection.MoveNext
					
		Loop

		rsSection.Close
		Set rsSection = nothing

		If SectionCount > 0 Then 'End table row.
			OfferText = OfferText & "</TR></TABLE>" & vbCrLf
		End If

	End If
	
'Next

If OfferText <> "" Then	

	Response.Write "<HTML>" & vbCrLf
	Response.Write "<HEAD>" & vbCrLf
	Response.Write "<TITLE>" & Title & "</TITLE>" & vbCrLf
	Response.Write "</HEAD>" & vbCrLf

	If Message = "" Then
		Response.Write "<BODY BGCOLOR=" & BGColor & " LINK="& LinkColor & " ALINK=" & ALinkColor & " VLINK=" & VLinkColor & " leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0 " & BodyParameters & ">" & vbCrLf
	Else
		Response.Write "<BODY BGCOLOR=" & BGColor & " LINK="& LinkColor & " ALINK=" & ALinkColor & " VLINK=" & VLinkColor & " onLoad=""alert('" & Message & "');"" leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0 " & BodyParameters & ">" & vbCrLf
	End If
								
%>
	<!--#INCLUDE virtual="TopNavInclude.asp"-->
<%
	Response.Write "<BR>" & vbCrLf
	Response.Write "<BR>" & vbCrLf
	
	Response.Write "<TABLE WIDTH=""600""><TR><TD><FONT FACE=" & FontFace & " COLOR=" &  FontColor & " SIZE=2>Please click on the corresponding button below if you would like to add the following ticket(s) to your shopping cart.<BR><BR><B>Please note: Party tickets are for children only</B></FONT></TD></TR></TABLE><BR>" & vbCrLf

	Response.Write OfferText & vbCrLf

	Response.Write "<BR><BR>" & vbCrLf

	Response.Write "<FORM ACTION=""" & SurveyFileName & """ METHOD=""post""><INPUT TYPE=""hidden"" NAME=""FormName"" VALUE=""Continue""><INPUT TYPE=""submit"" VALUE=""No Thanks""></FORM>" & vbCrLf
%>
	<!--#INCLUDE virtual="FooterInclude.asp"-->
<%

	Response.Write "</BODY>" & vbCrLf
	Response.Write "</HTML>" & vbCrLf
	
Else 

	Call Continue 'SM 9.15.07 ===>Look here!!! ===>Changed to "Call Continue"
	
End If


Call DBClose(OBJdbConnection2)

End Sub 'TicketOffer

'==============================

Sub AddToCart000(EventCode, SectionCode, OfferQuantity)

If Session("UserNumber") = "" Then

	Response.Redirect("/Event.asp?FormName=EventForm&Event=" & EventCode & "&Section=" & SectionCode & "&SeatCount=" & OfferQuantity & "&SeatTypeCode=417")
	
Else

	Response.Redirect("/Management/Event.asp?FormName=EventForm&Event=" & EventCode & "&Section=" & SectionCode & "&SeatCount=" & OfferQuantity & "&SeatTypeCode=417")

End If

End Sub 'AddToCart

'==============================

Sub AddToCart(EventCode, SectionCode, OfferQuantity)

If Clean(SectionCode) <> "" Then
	SectionCode = Clean(SectionCode)
Else
	SectionCode = "GA"
End If

If Session("OrderNumber") <> "" Then 'There's an order number.  Check the status of the order.
	SQLOrderHeader = "SELECT StatusCode From OrderHeader WITH (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber")
	Set rsOrderHeader = OBJdbConnection.Execute(SQLOrderHeader)
	If rsOrderHeader("StatusCode") = "S" Then Session("OrderNumber") = "" 'If the order has been completed, clear the Session("OrderNumber") and create a new one.
	rsOrderHeader.Close
	Set rsOrderHeader = Nothing
End If

'Create an Order Header if Necessary
If Session("OrderNumber") = "" Then 
	If Session("CustomerNumber") = "" Then
		CustomerNumber = 1
	Else
		CustomerNumber = Session("CustomerNumber")
	End If

	If Session("OrderTypeNumber") = "" Then
		OrderTypeNumber = 1
	Else
		OrderTypeNumber = Session("OrderTypeNumber")
	End If

	'REE 11/24/2 - Added ExpirationDate to OrderHeader

	'Set Default Expiration to 30 minutes from now using TimeOffset.  UnReserve will catch it 30 minutes from now.
	OrderExpirationDate = DateAdd("n", 30 + (TimeOffset() * -1), Now())

	'Get TimeZone Offset for VenueOwner Organization
	SQLLocalOffset = "SELECT OrganizationOptions.OrganizationNumber, OptionValue AS LocalOffset FROM Event (NOLOCK) INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Venue.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationOptions (NOLOCK) ON OrganizationVenue.OrganizationNumber = OrganizationOptions.OrganizationNumber WHERE Event.EventCode = " & EventCode & " AND OrganizationVenue.Owner <> 0 AND OrganizationOptions.OptionName = 'TimeZoneOffset'"
	Set rsLocalOffset = OBJdbConnection.Execute(SQLLocalOffset)

	'JAI 4/12/5 - Open OBJdbConnection2 for Loop reads.
	Call DBOpen(OBJdbConnection2)

	If Not rsLocalOffset.EOF Then 'Get Expiration Delay for VenueOwner Organization
		SQLExpirationDelay = "SELECT OptionValue As ExpirationDelay FROM OrganizationOptions (NOLOCK) WHERE OrganizationNumber = " & rsLocalOffset("OrganizationNumber") & " AND OptionName = 'OrderExpirationDelay'"
		Set rsExpirationDelay = OBJdbConnection2.Execute(SQLExpirationDelay)
		
		If Not rsExpirationDelay.EOF Then 'Set the ExpirationDate based on Offset and Delay
			OrderExpirationDate = DateAdd("n", (rsLocalOffset("LocalOffset") - TimeOffset()) + rsExpirationDelay("ExpirationDelay"), Now())
		End If
		
		rsExpirationDelay.close
		Set rsExpirationDelay = nothing

	End If
	
	'JAI 4/12/5 - Close OBJdbConnection2
	Call DBClose(OBJdbConnection2)
	rsLocalOffset.close
	Set rsLocalOffset = nothing
	
	'REE 5/29/3 - Added the user IP Address
	IPAddress = Request.ServerVariables("REMOTE_ADDR")

	Set spInsertOrderHeader = Server.Createobject("Adodb.Command")
	Set spInsertorderHeader.ActiveConnection = OBJdbConnection
	spInsertOrderHeader.Commandtype = 4 ' Value for Stored Procedure
	spInsertOrderHeader.Commandtext = "spInsertOrderHeader"
	spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("OrderNumber", 3, 4) 'As Integer and ParamReturnValue
	spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("CustomerNumber", 3, 1, , CustomerNumber) 'As Integer and Input
	spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("OrderTypeNumber", 3, 1, , OrderTypeNumber) 'As Integer and Input
	spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("UserNumber", 3, 1, , 0) 'As Integer and Input
	spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("OrderExpirationDate", 7, 1, , OrderExpirationDate) 'As Date and Input
	spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("IPAddress", 200, 1, 15, IPAddress) 'As Varchar and Input
	spInsertOrderHeader.Execute

	Session("OrderNumber") = spInsertOrderHeader.Parameters("OrderNumber")

	If Session("OrderNumber") = 0 Then
		Message = "There was a problem processing your request.  Please try again later."
		ErrorLog(Message)
		Call TicketOffer(Message)
		Exit Sub
	End If

End If

'**********************
'Reserve the seats
'**********************
'REE 11/29/6 - Modified to include SubFixedEvent in count
SQLAvailable = "SELECT Count(LineNumber) AS ExistingSeats FROM Orderline (NOLOCK) LEFT JOIN Seat (NOLOCK) ON Orderline.ItemNumber = Seat.ItemNumber WHERE Orderline.OrderNumber = " & Session("OrderNumber") & " AND EventCode = " & EventCode & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent')"
Set rsAvailable = OBJdbConnection.Execute(SQLAvailable)
ExistingSeatCount = rsAvailable("ExistingSeats")
rsAvailable.Close
Set rsAvailable = Nothing
TotalSeatCount = ExistingSeatCount + OfferQuantity

If TotalSeatCount <= MaxTickets Then 'Process Request

	EventType = ""
	SQLEventType = "SELECT EventType FROM Event (NOLOCK) WHERE EventCode = " & EventCode
	Set rsEventType = OBJdbConnection.Execute(SQLEventType)
	If Not rsEventType.EOF Then
		EventType = rsEventType("EventType")
	End If
	rsEventType.Close
	Set rsEventType = nothing

	
	Select Case EventType
		Case "SubFixedEvent" 'Fixed Event Subscription

			Set spEventReserveSeatsSubFixedEvent = Server.Createobject("Adodb.Command")
			Set spEventReserveSeatsSubFixedEvent.ActiveConnection = OBJdbConnection
			spEventReserveSeatsSubFixedEvent.Commandtype = 4 ' Value for Stored Procedure
			spEventReserveSeatsSubFixedEvent.Commandtext = "spEventReserveSeatsSubFixedEvent"
			spEventReserveSeatsSubFixedEvent.Parameters.Append spEventReserveSeatsSubFixedEvent.CreateParameter("ReturnCode", 3, 4) 'As Integer and ParamReturnValue
			spEventReserveSeatsSubFixedEvent.Parameters.Append spEventReserveSeatsSubFixedEvent.CreateParameter("EventCode", 3, 1, , EventCode) 'As Integer and Input
			spEventReserveSeatsSubFixedEvent.Parameters.Append spEventReserveSeatsSubFixedEvent.CreateParameter("OrderNumber", 3, 1, , Session("OrderNumber")) 'As Integer and Input
			spEventReserveSeatsSubFixedEvent.Parameters.Append spEventReserveSeatsSubFixedEvent.CreateParameter("SeatCount", 3, 1, , OfferQuantity) 'As Integer and Input
			spEventReserveSeatsSubFixedEvent.Parameters.Append spEventReserveSeatsSubFixedEvent.CreateParameter("SectionCode", 200, 1, 5, SectionCode) 'As Varchar and Input with Section Code for General Admission events.
			spEventReserveSeatsSubFixedEvent.Execute
			
			ReturnCode = spEventReserveSeatsSubFixedEvent.Parameters("ReturnCode")
		
		Case Else

			Set spEventReserveSeats = Server.Createobject("Adodb.Command")
			Set spEventReserveSeats.ActiveConnection = OBJdbConnection
			spEventReserveSeats.Commandtype = 4 ' Value for Stored Procedure
			spEventReserveSeats.Commandtext = "spEventReserveSeats"
			spEventReserveSeats.Parameters.Append spEventReserveSeats.CreateParameter("ReturnCode", 3, 4) 'As Integer and ParamReturnValue
			spEventReserveSeats.Parameters.Append spEventReserveSeats.CreateParameter("EventCode", 3, 1, , EventCode) 'As Integer and Input
			spEventReserveSeats.Parameters.Append spEventReserveSeats.CreateParameter("OrderNumber", 3, 1, , Session("OrderNumber")) 'As Integer and Input
			spEventReserveSeats.Parameters.Append spEventReserveSeats.CreateParameter("SeatCount", 3, 1, , OfferQuantity) 'As Integer and Input
			spEventReserveSeats.Parameters.Append spEventReserveSeats.CreateParameter("SectionCode", 200, 1, 5, SectionCode) 'As Varchar and Input with Section Code for General Admission events.
			spEventReserveSeats.Execute

			ReturnCode = spEventReserveSeats.Parameters("ReturnCode")
			
	End Select

	Select Case ReturnCode
		Case 0	'Stored Procedure executed properly.  Continue.
		
			For i = 1 To OfferQuantity

				If Session("OrderTypeNumber")="1" Then 
					OrderTypeName="Internet"
				ElseIf Session("OrderTypeNumber")="2" Then 
					OrderTypeName="Phone"
				ElseIf Session("OrderTypeNumber")="3" Then 
					OrderTypeName="Fax"
				ElseIf Session("OrderTypeNumber")="4" Then 
					OrderTypeName="Mail"
				ElseIf Session("OrderTypeNumber")="5" Then 
					OrderTypeName="Comp"
				ElseIf Session("OrderTypeNumber")="7" Then 
					OrderTypeName="BoxOffice"
				End If
				
				'REE 6/21/5 - Added Seat Type Code to OrderLines.
				If OrderTypeName = "Internet" Then 
					
					SQLPrice = "SELECT Price, Surcharge FROM Price (NOLOCK) WHERE EventCode = " & EventCode & " AND SectionCode = '" & SectionCode & "' AND SeatTypeCode = 417"
					Set rsPrice = OBJdbConnection.Execute(SQLPrice)
								
					Price = rsPrice("Price")
					Surcharge = rsPrice("Surcharge")
				Else
					If OrderTypeName = "BoxOffice" Then
						OrderTypeSur = ""
					Else
						OrderTypeSur = "Order"
					End If
						
					SQLPrice = "SELECT Price, " & OrderTypeName & OrderTypeSur & "Surcharge FROM Price (NOLOCK) WHERE EventCode = " & EventCode & " AND SectionCode = '" & SectionCode & "' AND SeatTypeCode = 417"
					Set rsPrice = OBJdbConnection.Execute(SQLPrice)
								
					Price = rsPrice("Price")
					Surcharge = rsPrice(OrderTypeName & OrderTypeSur & "Surcharge")
				
				End If
				
										
				rsPrice.Close
				Set rsPrice = nothing
								
				'REE 11/29/6 - Modified for subscriptions.  Update Seat and SubFixedEvent lines only.
				SQLUpdateSeatType = "UPDATE OrderLine WITH (ROWLOCK) SET SeatTypeCode = 417, Price = " & Price & ", Surcharge = " & Surcharge & " WHERE OrderNumber = " & Session("OrderNumber") & " AND ItemNumber IN (SELECT TOP 1 ItemNumber FROM OrderLine (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND SeatTypeCode IS NULL AND ItemType IN ('Seat', 'SubFixedEvent') ORDER BY LineNumber DESC)"
				Set rsUpdateSeatType = OBJdbConnection.Execute(SQLUpdateSeatType)
				
			Next				

			Call DBClose(OBJdbConnection)
			
			'Call the specified General Survey
			Response.Redirect("/Clients/SpindleCityBallet/Surveys/SCBQuestionnaire.asp")
		Case Else
		
			Call TicketOffer(Message)
			
	End Select
End If

End Sub

'==============================

Sub Continue

Session("SurveyComplete") = Session("OrderNumber")
Response.Redirect("/Clients/SpindleCityBallet/Surveys/SCBQuestionnaire.asp")

If Session("UserNumber") = "" Then
	Session("SurveyComplete") = Session("OrderNumber") 'SM 9.15.07===>Look here!!===>ASK ROBERT why this was commented out for Skirball===
	Response.Redirect("/Ship.asp")
Else
	Session("SurveyComplete") = Session("OrderNumber")
	Response.Redirect("/Management/AdvanceShip.asp")
End If

End Sub 'Continue

'==============================

%>
