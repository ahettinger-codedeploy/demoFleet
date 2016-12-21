<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%
Page = "Survey"
SurveyNumber = 63
SurveyFileName = "DinnerSurvey.asp"
EventCode = Request("EventCode")

If Session("UserNumber") = "" Then
	ShipPage = "/Ship.asp"
Else
	ShipPage = "/Management/AdvanceShip.asp"
End If

'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	OBJdbConnection.Close
	Set OBJdbConnection = nothing
	Response.Redirect("/Default.asp")
End If

Select Case Request("FormName")
	Case "EventForm"
		Call AddToCart(CleanNumeric(Request("EventCode")), Clean(Request("SectionCode")), CleanNumeric(Request("Quantity")))
	Case "Continue"
		Call Continue
	Case Else
		Call TicketOffer(Message)
End Select

'==============================

Sub TicketOffer(Message)

%>

<html>
<HEAD>
<title><%= Title %></title>

<SCRIPT LANGUAGE="JavaScript">    

<!-- Hide code from non-js browsers

function validateForm() {
	formObj = document.EventForm;
	var yes = 0;
 	for (var i=0;i<3;i++) {
 	    if (eval("formObj.EventCode[i].checked") == true)
 	        yes++;
 		}
 	if (yes == 0) {
 		alert("Please select a restaurant.");
 		return false;
 		}
  if (formObj.Quantity.value == "") {
      alert("Please enter the number of dinners you would like to purchase.");
      formObj.Quantity.focus();
      return false;
      }
	var emailReg = "\\D";
	var regex = new RegExp(emailReg);
	if (regex.test(formObj.Quantity.value)==true){
		alert("Please enter a valid dinner quantity.")
		return false;
		}
    }    

// end hiding -->
</SCRIPT>

</HEAD>
<%= strBody %>
<center>

<!--#INCLUDE VIRTUAL="TopNavInclude.asp"-->

<br>
<BR>
<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><B>Would you like to add a dinner to your purchase?</B></FONT><BR>
<BR>
<FORM ACTION="DinnerSurvey.asp" METHOD="post" Name="EventForm" onSubmit='return validateForm()'>
<input type="hidden" name="FormName" value="EventForm">
<input type="hidden" name="SectionCode" value="GA">
<input type="hidden" name="SeatTypeCode" value="16">

<TABLE WIDTH="400">
<TR><TD ALIGN="right"><INPUT TYPE="radio" NAME="EventCode" VALUE="156623"></TD><TD><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">Metropolitan Cafe</FONT></TD><TD ALIGN="right"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">$30.00</FONT></TD></TR>
<TR><TD ALIGN="right"><INPUT TYPE="radio" NAME="EventCode" VALUE="156624"></TD><TD><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">Solo Trattoria</FONT></TD><TD ALIGN="right"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">$30.00</FONT></TD></TR>
<TR><TD ALIGN="right"><INPUT TYPE="radio" NAME="EventCode" VALUE="199215"></TD><TD><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">Bayou Cafe</FONT></TD><TD ALIGN="right"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">$30.00</FONT></TD></TR>
</TABLE>
<BR>
<TABLE WIDTH="400">
<TR><TD ALIGN="right"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">Quantity: </FONT></TD><TD ALIGN="left"><INPUT TYPE="text" NAME="Quantity" SIZE="5"></TD></TR>
</TABLE>
<BR>
<INPUT TYPE="submit" VALUE="Add To Cart" id=submit1 name=submit1></FORM>

<BR>

<FORM ACTION="DinnerSurvey.asp" METHOD="post"><INPUT TYPE="submit" VALUE="No Thanks">
<input type="hidden" name="FormName" value="Continue">
</FORM>


<!--#INCLUDE VIRTUAL="FooterInclude.asp"-->

</BODY>
</HTML>


<%

End Sub 'TicketOffer

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

				'REE 6/21/5 - Added Seat Type Code to OrderLines.
				SQLPrice = "SELECT Price, Surcharge FROM Price (NOLOCK) WHERE EventCode = " & EventCode & " AND SectionCode = '" & SectionCode & "' AND SeatTypeCode = " & Clean(Request("SeatTypeCode"))
				Set rsPrice = OBJdbConnection.Execute(SQLPrice)
								
				Price = rsPrice("Price")
				Surcharge = rsPrice("Surcharge")
								
				rsPrice.Close
				Set rsPrice = nothing
								
				'REE 11/29/6 - Modified for subscriptions.  Update Seat and SubFixedEvent lines only.
				SQLUpdateSeatType = "UPDATE OrderLine WITH (ROWLOCK) SET SeatTypeCode = " & Clean(Request("SeatTypeCode")) & ", Price = " & Price & ", Surcharge = " & Surcharge & " WHERE OrderNumber = " & Session("OrderNumber") & " AND ItemNumber IN (SELECT TOP 1 ItemNumber FROM OrderLine (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND SeatTypeCode IS NULL AND ItemType IN ('Seat', 'SubFixedEvent') ORDER BY LineNumber DESC)"
				Set rsUpdateSeatType = OBJdbConnection.Execute(SQLUpdateSeatType)
				
			Next				

			Call DBClose(OBJdbConnection)
			
			Call Continue
			
		Case Else
		
			Call TicketOffer(Message)
			
	End Select
End If

End Sub

'==============================

Sub Continue

If Session("UserNumber") = "" Then
	Session("SurveyComplete") = Session("OrderNumber") 
	Response.Redirect("/Ship.asp")
Else
	Session("SurveyComplete") = Session("OrderNumber")
	Response.Redirect("/Management/AdvanceShip.asp")
End If

End Sub 'Continue

'==============================


%>