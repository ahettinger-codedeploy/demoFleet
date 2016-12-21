<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%
Page = "Survey"

SurveyNumber = 368
SurveyFileName = "SurveyPackages.asp"

'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If

If Clean(Request("FormName")) = "EventOffer" Then
    Call AddToCart(CleanNumeric(Request("EventCode")), Clean(Request("SectionCode")), CleanNumeric(Request("Quantity")), Clean(Request("SurveyType")), CleanNumeric(Request("OriginalEventCode")))
ElseIf Clean(Request("FormName")) = "Continue" Then
    Call Continue
Else
    Call AddOnSurvey
End If

Sub AddOnSurvey

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & Title & "</TITLE>" & vbCrLf
Response.Write "</HEAD>" & vbCrLf
Response.Write strBody & vbCrLf

%>

<!--#INCLUDE virtual="TopNavInclude.asp"-->
<BR>
<BR>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3>Please select the seminar of your choice:</H3></FONT><BR>
<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><FONT face="Geneva, Arial, Helvetica, san-serif"></FONT><BR>

<center>
<TABLE CELLPADDING=10 CELLSPACING=5 WIDTH="600" border=0>
<tr><td><hr style="width:500px;" /></td></tr>
<%
    'Get the eventcode in the shopping cart
    SQLEventCode = "SELECT Seat.EventCode FROM OrderHeader (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderHeader.OrderNumber = " & CleanNumeric(Session("OrderNumber")) & " AND OrderLine.OrderNumber = " & CleanNumeric(Session("OrderNumber")) '& " AND GetDate() < DateAdd(day, 365, OrderDate)"
    Set rsEventCode = OBJdbConnection.Execute(SQLEventCode)
    If Not rsEventCode.EOF Then
        EventCodeSelected = rsEventCode("EventCode")
    Else
        Call Continue
    End If
    rsEventCode.Close
    Set rsEventCode = nothing
    
    'Determine which packages to show
    If EventCodeSelected = "128288" Or EventCodeSelected = "128049" Or EventCodeSelected = "128052" Then
        EventCodeList = "128050, 128051"
    ElseIf EventCodeSelected = "128305"  Or EventCodeSelected = "128055" Or EventCodeSelected = "128058" Then
        EventCodeList = "128056, 128057"
    ElseIf EventCodeSelected = "128309"  Or EventCodeSelected = "128066" Or EventCodeSelected = "128063" Then
        EventCodeList = "128064, 128065"
    Else 'Invalid EventCode
        Call Continue    
    End If
    
    'Determine how many tickets in this package
    SQLTicketCount = "SELECT COUNT(OrderLine.LineNumber) AS NumTickets FROM OrderHeader (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderHeader.OrderNumber = " & CleanNumeric(Session("OrderNumber")) & " AND OrderLine.OrderNumber = " & CleanNumeric(Session("OrderNumber")) & " AND Seat.EventCode = " & CleanNumeric(EventCodeSelected)
    Set rsTicketCount = OBJdbConnection.Execute(SQLTicketCount)
    If not rsTicketCount.EOF Then
        NumTickets = rsTicketCount("NumTickets")
    Else
        NumTickets = 1
    End If
    rsTicketCount.Close
    Set rsTicketCount = nothing
    
    'Show Package Info
    SQLPackages = "SELECT Event.EventCode, Event.EventDate, Event.Comments AS EventComments, Act.Act, Act.Comments AS ActComments FROM Event (NOLOCK) INNER JOIN Act ON Event.ActCode = Act.ActCode WHERE Event.EventCode IN(" & EventCodeList & ") ORDER BY Event.EventDate"
    Set rsPackages = OBJdbConnection.Execute(SQLPackages)
    Do While Not rsPackages.eof
%>
    <tr><td align="center"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><FONT face="Geneva, Arial, Helvetica, san-serif"><%=rsPackages("Act")%> - <%=rsPackages("EventDate")%></FONT></FONT></td></tr>
    <tr><td align="center"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><FONT face="Geneva, Arial, Helvetica, san-serif"><%=rsPackages("ActComments")%></FONT></FONT></td></tr>
    <tr><td align="center"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><FONT face="Geneva, Arial, Helvetica, san-serif">
    <FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey">
        <INPUT TYPE="hidden" NAME="FormName" VALUE="EventOffer">
        <INPUT TYPE="hidden" NAME="SurveyType" VALUE="OptionalSurvey">
        <INPUT TYPE="hidden" NAME="OriginalEventCode" VALUE="<%=EventCodeSelected%>">
        <INPUT TYPE="hidden" NAME="EventCode" VALUE="<%=rsPackages("EventCode")%>">
        <INPUT TYPE="hidden" NAME="SectionCode" VALUE="GA">
        <INPUT TYPE="hidden" NAME="Quantity" VALUE="<%=NumTickets%>">
        <INPUT type="submit" value="Add To Cart" />
    </FORM>
    </FONT></FONT></td></tr>
    <tr><td><hr style="width:500px;" /></td></tr>
<%
        rsPackages.movenext
    Loop
%>
</TABLE>
</center>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%
    
End Sub 'AddOnSurvey

Sub OptionalSurvey(OriginalEventCode, OfferQuantity)
Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & Title & "</TITLE>" & vbCrLf
Response.Write "</HEAD>" & vbCrLf
Response.Write strBody & vbCrLf
%>

<!--#INCLUDE virtual="TopNavInclude.asp"-->
<BR>
<BR>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3>Please select the wine dinner of your choice:</H3></FONT><BR>
<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><FONT face="Geneva, Arial, Helvetica, san-serif">To add the following event in your shopping cart, please click on the "Add To Cart" button below:</FONT><BR>
<center>
<TABLE CELLPADDING=10 CELLSPACING=5 WIDTH="600" border=0>
<tr><td><hr style="width:500px;" /></td></tr>
<%
    'Get the eventcode in the shopping cart
    'SQLEventCode = "SELECT Seat.EventCode FROM OrderHeader (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderHeader.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.OrderNumber = " & Session("OrderNumber") & " AND ShipCode IS NOT NULL"
    'Response.Write(SQLEventCode)
    'Set rsEventCode = OBJdbConnection2.Execute(SQLEventCode)
    'EventCodeSelected = rsEventCode("EventCode")
    'rsEventCode.Close
    'Set rsEventCode = nothing
    
    EventCodeSelected = OriginalEventCode
    
    'Determine which packages to show
    If EventCodeSelected = "128288" Or EventCodeSelected = "128049" Or EventCodeSelected = "128052" Then
        EventCodeList = "128044"
    ElseIf EventCodeSelected = "128305"  Or EventCodeSelected = "128055" Or EventCodeSelected = "128058" Then
        EventCodeList = "128054"
    ElseIf EventCodeSelected = "128309"  Or EventCodeSelected = "128066" Or EventCodeSelected = "128063" Then
        EventCodeList = "128062"
    Else 'Invalid EventCode
        Call Continue
    End If
    
    'Show Package Info
    Call DBOpen(OBJdbConnection2)
    SQLPackages = "SELECT Event.EventCode, Event.EventDate, Event.Comments AS EventComments, Act.Act, Act.Comments AS ActComments FROM Event (NOLOCK) INNER JOIN Act ON Event.ActCode = Act.ActCode WHERE Event.EventCode IN(" & EventCodeList & ") ORDER BY Event.EventDate"
    Set rsPackages = OBJdbConnection2.Execute(SQLPackages)
    Do While Not rsPackages.eof
%>
    <tr><td align="center"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><FONT face="Geneva, Arial, Helvetica, san-serif"><%=rsPackages("Act")%> - <%=rsPackages("EventDate")%></FONT></FONT></td></tr>
    <tr><td align="center"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><FONT face="Geneva, Arial, Helvetica, san-serif"><%=rsPackages("ActComments")%></FONT></FONT></td></tr>
    <tr><td align="center"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><FONT face="Geneva, Arial, Helvetica, san-serif">
    <FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey">
        <INPUT TYPE="hidden" NAME="FormName" VALUE="EventOffer">
        <INPUT TYPE="hidden" NAME="SurveyType" VALUE="Continue">
        <INPUT TYPE="hidden" NAME="OriginalEventCode" VALUE="<%=EventCodeSelected%>">
        <INPUT TYPE="hidden" NAME="EventCode" VALUE="<%=rsPackages("EventCode")%>">
        <INPUT TYPE="hidden" NAME="SectionCode" VALUE="GA">
        <INPUT TYPE="hidden" NAME="Quantity" VALUE="<%=OfferQuantity%>">
        <INPUT type="submit" value="Add To Cart" />
    </FORM>
    </FONT></FONT></td></tr>
    <tr><td><hr style="width:500px;" /></td></tr>
<%
        rsPackages.movenext
    Loop
    Call DBClose(OBJdbConnection2)
%>
</TABLE>



</center>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>
<%    
End Sub 'OptionalSurvey

Sub AddToCart(EventCode, SectionCode, OfferQuantity, SurveyType, OriginalEventCode)
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
		    Call AddOnSurvey
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

				    'REE 6/21/5 - Added Seat Type Code to OrderLines.
				    SQLPrice = "SELECT Price, Surcharge FROM Price (NOLOCK) WHERE EventCode = " & EventCode & " AND SectionCode = '" & SectionCode & "' AND SeatTypeCode = 16"
				    Set rsPrice = OBJdbConnection.Execute(SQLPrice)
    								
				    Price = rsPrice("Price")
				    Surcharge = rsPrice("Surcharge")
    								
				    rsPrice.Close
				    Set rsPrice = nothing
    								
				    'REE 11/29/6 - Modified for subscriptions.  Update Seat and SubFixedEvent lines only.
				    SQLUpdateSeatType = "UPDATE OrderLine WITH (ROWLOCK) SET SeatTypeCode = 16, Price = " & Price & ", Surcharge = " & Surcharge & " WHERE OrderNumber = " & Session("OrderNumber") & " AND ItemNumber IN (SELECT TOP 1 ItemNumber FROM OrderLine (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND SeatTypeCode IS NULL AND ItemType IN ('Seat', 'SubFixedEvent') ORDER BY LineNumber DESC)"
				    Set rsUpdateSeatType = OBJdbConnection.Execute(SQLUpdateSeatType)
    				
			    Next				

			    Call DBClose(OBJdbConnection)
    			
			    If SurveyType = "OptionalSurvey" Then
                    Call OptionalSurvey(OriginalEventCode,OfferQuantity)
                Else
                    Call Continue
                End If
                
		    Case Else
    		
			    Call AddOnSurvey
    			
	    End Select
    End If
End Sub 'AddToCart

Sub Continue
    Session("SurveyComplete") = Session("OrderNumber")
    If Session("UserNumber") = "" Then
	    Response.Redirect("/Ship.asp")
    Else
	    Response.Redirect("/Management/AdvanceShip.asp")
    End If
End Sub 'Continue

%>


