<%

Const NUMBER_OF_PAGES = 4

Dim intPreviousPage
Dim intCurrentPage
Dim strItem

'Hey there what page did we come from?
intPreviousPage = Request.Form("page")

'Do you know what page we are on?
Select Case Request.Form("navigate")
	Case "< Back"
		intCurrentPage = intPreviousPage - 1
	Case "Next >"
		intCurrentPage = intPreviousPage + 1
	Case Else
		' Either it's our first run of the page and we're on page 1 or
		' the form is complete and pages are unimportant because we're
		' about to process our data!
		intCurrentPage = 1
End Select

' If we're not finished then display the form.
If Request.Form("navigate") <> "Finish" Then %>
	<form action="<%= Request.ServerVariables("URL") %>" method="post">
	<input type="hidden" name="page" value="<%= intCurrentPage %>">

	<%
	' We now take the data and store it in hidden form fields. Sneaky!  
	' All the fields are prefixed with a number so that we know what page it belongs to.
	For Each strItem In Request.Form
		' Ignore the "page" and "navigate" button form fields.
		If strItem <> "page" And strItem <> "navigate" Then
			' If the data is from the current page we don't need
			' the hidden field since the data will show in the visible
			' form fields.
			If CInt(Left(strItem, 1)) <> intCurrentPage Then
				Response.Write("<input type=""hidden"" name=""" & strItem & """" _
				& " value=""" & Request.Form(strItem) & """>" & vbCrLf)
			End If
		End If
	Next

	' Display current page fields.  The fields are all named with
	' numerical prefix that tells us which page they belong to.
	' We need a Case for each page.
	Select Case intCurrentPage
		Case 1
		'Production #1
		
		
%>
            <table id="rounded-corner" summary="surveypage" >
            <thead>
	            <tr>
    	            <th scope="col" class="category-left"></th>
    	            <th scope="col" class="category" colspan="2"><b>Annie Get Your Gun</b></th>
    	            <th scope="col" class="category-right"></th>
                </tr>        
            </thead>
<%
                SQLPackages = "SELECT Distinct Event.EventCode, Event.EventDate, Act.Act, Act.Comments AS ActComments, SeatType.SeatTypeCode, SeatType.SeatType, Seat.StatusCode FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Seat ON Event.EventCode = Seat.EventCode INNER JOIN Price (NOLOCK) ON Event.EventCode = Price.EventCode INNER JOIN SeatType (NOLOCK) ON Price.SeatTypeCode = SeatType.SeatTypeCode WHERE Event.ActCode = 54885 AND Seat.StatusCode = 'A' GROUP BY  Event.EventCode, Event.EventDate, Act.Act, Act.Comments, SeatType.SeatTypeCode, SeatType.SeatType, Seat.StatusCode ORDER BY Event.EventCode, Event.EventDate"
                Set rsPackages = OBJdbConnection.Execute(SQLPackages)
%>
                <tr><td class="data" colspan="4"><%=rsPackages("ActComments")%></td></tr>
<%
                rsPackages.Close
                Set rsPackages = Nothing
%>
                <tr><td class="data" colspan="4"><input type="radio" name="1_eventcode" value="296190" <% If Request.Form("1_eventcode") = "296190" Then Response.Write("checked=""checked""") %>>Friday 1/20/2012 8:00 PM</td></tr>
				<tr><td class="data" colspan="4"><input type="radio" name="1_eventcode" value="296191" <% If Request.Form("1_eventcode") = "296191" Then Response.Write("checked=""checked""") %>>Saturday 1/21/2012 8:00 PM</td></tr>
		        <tr><td class="data" colspan="4"><input type="radio" name="1_eventcode" value="296194" <% If Request.Form("1_eventcode") = "296194" Then Response.Write("checked=""checked""") %>>Sunday 1/22/2012 2:00 PM</td></tr>
		        <tr>
    	            <td class="footer-left">&nbsp;</td>
    	            <td class="footer" colspan="2">&nbsp;</td>
    	            <td class="footer-right">&nbsp;</td>
    	        </tr>		
			</table>
<%
		Case 2
		'Production #2
%>
            <table id="rounded-corner" summary="surveypage" >
            <thead>
	            <tr>
    	            <th scope="col" class="category-left"></th>
    	            <th scope="col" class="category" colspan="2"><b>Chicago</b></th>
    	            <th scope="col" class="category-right"></th>
                </tr>        
            </thead>
<%
                SQLPackages = "SELECT Distinct Event.EventCode, Event.EventDate, Act.Act, Act.Comments AS ActComments, SeatType.SeatTypeCode, SeatType.SeatType, Seat.StatusCode FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Seat ON Event.EventCode = Seat.EventCode INNER JOIN Price (NOLOCK) ON Event.EventCode = Price.EventCode INNER JOIN SeatType (NOLOCK) ON Price.SeatTypeCode = SeatType.SeatTypeCode WHERE Event.ActCode = 54886 AND Seat.StatusCode = 'A' GROUP BY  Event.EventCode, Event.EventDate, Act.Act, Act.Comments, SeatType.SeatTypeCode, SeatType.SeatType, Seat.StatusCode ORDER BY Event.EventCode, Event.EventDate"
                Set rsPackages = OBJdbConnection.Execute(SQLPackages)
%>
                <tr><td class="data" colspan="4"><%=rsPackages("ActComments")%></td></tr>
<%
                rsPackages.Close
                Set rsPackages = Nothing
%>
				<tr><td class="data" colspan="4"><input type="radio" name="2_eventcode" value="297511" <% If Request.Form("2_eventcode") = "297511"   Then Response.Write("checked=""checked""") %>>Friday 2/10/2012 8:00 PM</td></tr>
				<tr><td class="data" colspan="4"><input type="radio" name="2_eventcode" value="297512" <% If Request.Form("2_eventcode") = "297512" Then Response.Write("checked=""checked""") %>>Saturday 2/11/2012 8:00 PM</td></tr>
		        <tr><td class="data" colspan="4"><input type="radio" name="2_eventcode" value="359645" <% If Request.Form("2_eventcode") = "359645" Then Response.Write("checked=""checked""") %>>Sunday 2/12/2012 2:00 PM</td></tr>
		        <tr>
    	            <td class="footer-left">&nbsp;</td>
    	            <td class="footer" colspan="2">&nbsp;</td>
    	            <td class="footer-right">&nbsp;</td>
    	        </tr>		
			</table>
<%
		Case 3
		'Production #3
%>
		    <table id="rounded-corner" summary="surveypage" >
            <thead>
	            <tr>
    	            <th scope="col" class="category-left"></th>
    	            <th scope="col" class="category" colspan="2"><b>Grease</b></th>
    	            <th scope="col" class="category-right"></th>
                </tr>        
            </thead>
                <%
                SQLPackages = "SELECT Distinct Event.EventCode, Event.EventDate, Act.Act, Act.Comments AS ActComments, SeatType.SeatTypeCode, SeatType.SeatType, Seat.StatusCode FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Seat ON Event.EventCode = Seat.EventCode INNER JOIN Price (NOLOCK) ON Event.EventCode = Price.EventCode INNER JOIN SeatType (NOLOCK) ON Price.SeatTypeCode = SeatType.SeatTypeCode WHERE Event.ActCode = 55462 AND Seat.StatusCode = 'A' GROUP BY  Event.EventCode, Event.EventDate, Act.Act, Act.Comments, SeatType.SeatTypeCode, SeatType.SeatType, Seat.StatusCode ORDER BY Event.EventCode, Event.EventDate"
                Set rsPackages = OBJdbConnection.Execute(SQLPackages)
                %>
                <tr><td class="data" colspan="4"><%=rsPackages("ActComments")%></td></tr>
                <%
                rsPackages.Close
                Set rsPackages = Nothing
                %>
				<tr><td class="data" colspan="4"><input type="radio" name="3_eventcode" value="300470" <% If Request.Form("3_eventcode") = "300470" Then Response.Write("checked=""checked""") %>>Friday 4/13/2012 8:00 PM</td></tr>
				<tr><td class="data" colspan="4"><input type="radio" name="3_eventcode" value="300471" <% If Request.Form("3_eventcode") = "300471" Then Response.Write("checked=""checked""") %>>Saturday 4/14/2012 8:00 PM</td></tr>
		        <tr><td class="data" colspan="4"><input type="radio" name="3_eventcode" value="359645" <% If Request.Form("3_eventcode") = "359645" Then Response.Write("checked=""checked""") %>>Sunday 4/15/2012 2:00 PM</td></tr>
		       <tr>
    	            <td class="footer-left">&nbsp;</td>
    	            <td class="footer" colspan="2">&nbsp;</td>
    	            <td class="footer-right">&nbsp;</td>
    	        </tr>		
			    </table>
<%
		Case 4
		'Review Page
%>
        <table id="rounded-corner" summary="surveypage">
        <thead>
	        <tr>
    	        <th scope="col" class="category-left"></th>
    	        <th scope="col" class="category" colspan="2"><b><h2>Congratulations!</h2>Here's the custom season subscription you created!</b></th>
    	        <th scope="col" class="category-right"></th>
            </tr>        
        </thead>
        <tbody>
         <tr><td class="data" colspan="4"></td></tr>
         <%
            SQLPackages = "SELECT Distinct Event.EventCode, Event.EventDate, Act.Act, Act.Comments AS ActComments, SeatType.SeatTypeCode, SeatType.SeatType, Seat.StatusCode FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Seat ON Event.EventCode = Seat.EventCode INNER JOIN Price (NOLOCK) ON Event.EventCode = Price.EventCode INNER JOIN SeatType (NOLOCK) ON Price.SeatTypeCode = SeatType.SeatTypeCode WHERE Event.EventCode = " & Request.Form("1_eventcode") & " AND Seat.StatusCode = 'A' GROUP BY  Event.EventCode, Event.EventDate, Act.Act, Act.Comments, SeatType.SeatTypeCode, SeatType.SeatType, Seat.StatusCode ORDER BY Event.EventCode, Event.EventDate"
            Set rsPackages = OBJdbConnection.Execute(SQLPackages)
         %>
         <tr><td class="data-left" colspan="2"><strong>Event #1:</strong></td><td class="data-right" colspan="2"><%=rsPackages("Act")%><br /><%=FormatDateTime(rsPackages("EventDate"),vbLongDate)%><br /><%=Left(FormatDateTime(rsPackages("EventDate"),vbLongTime),Len(FormatDateTime(rsPackages("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsPackages("EventDate"),vbLongTime),3)%></td></tr>
         <%
            rsPackages.Close
            Set rsPackages = Nothing
            
            SQLPackages = "SELECT Distinct Event.EventCode, Event.EventDate, Act.Act, Act.Comments AS ActComments, SeatType.SeatTypeCode, SeatType.SeatType, Seat.StatusCode FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Seat ON Event.EventCode = Seat.EventCode INNER JOIN Price (NOLOCK) ON Event.EventCode = Price.EventCode INNER JOIN SeatType (NOLOCK) ON Price.SeatTypeCode = SeatType.SeatTypeCode WHERE Event.EventCode = " & Request.Form("2_eventcode") & " AND Seat.StatusCode = 'A' GROUP BY  Event.EventCode, Event.EventDate, Act.Act, Act.Comments, SeatType.SeatTypeCode, SeatType.SeatType, Seat.StatusCode ORDER BY Event.EventCode, Event.EventDate"
            Set rsPackages = OBJdbConnection.Execute(SQLPackages)
         %>
         <tr><td class="data-left" colspan="2"><strong>Event #2:</strong></td><td class="data-right" colspan="2"><%=rsPackages("Act")%><br /><%=FormatDateTime(rsPackages("EventDate"),vbLongDate)%><br /><%=Left(FormatDateTime(rsPackages("EventDate"),vbLongTime),Len(FormatDateTime(rsPackages("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsPackages("EventDate"),vbLongTime),3)%></td></tr>
         <%
            rsPackages.Close
            Set rsPackages = Nothing
                              
            SQLPackages = "SELECT Distinct Event.EventCode, Event.EventDate, Act.Act, Act.Comments AS ActComments, SeatType.SeatTypeCode, SeatType.SeatType, Seat.StatusCode FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Seat ON Event.EventCode = Seat.EventCode INNER JOIN Price (NOLOCK) ON Event.EventCode = Price.EventCode INNER JOIN SeatType (NOLOCK) ON Price.SeatTypeCode = SeatType.SeatTypeCode WHERE Event.EventCode = " & Request.Form("3_eventcode") & " AND Seat.StatusCode = 'A' GROUP BY  Event.EventCode, Event.EventDate, Act.Act, Act.Comments, SeatType.SeatTypeCode, SeatType.SeatType, Seat.StatusCode ORDER BY Event.EventCode, Event.EventDate"
            Set rsPackages = OBJdbConnection.Execute(SQLPackages)
         %>
         <tr><td class="data-left" colspan="2"><strong>Event #3:</strong></td><td class="data-right" colspan="2"><%=rsPackages("Act")%><br /><%=FormatDateTime(rsPackages("EventDate"),vbLongDate)%><Br /><%=Left(FormatDateTime(rsPackages("EventDate"),vbLongTime),Len(FormatDateTime(rsPackages("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsPackages("EventDate"),vbLongTime),3)%></td></tr>
         <%
            rsPackages.Close
            Set rsPackages = Nothing
         %> 
         <tr>
    	    <td class="footer-left">&nbsp;</td>
    	    <td class="footer" colspan="2">&nbsp;</td>
    	    <td class="footer-right">&nbsp;</td>
    	</tr>
    </table>
<%
	Case Else
			' You shouldn't see this error unless something goes wrong.
			Response.Write("Error: Bad Page Number!")
	End Select
	%>
	<br />
	<!-- Display form navigation buttons. -->
	<% If intCurrentPage > 1 Then %>
		<input type="submit" name="navigate" value="&lt; Back">
	<% End If %>
	
	<% If intCurrentPage < NUMBER_OF_PAGES Then %>
		<input type="submit" name="navigate" value="Next &gt;">
	<% Else %>
		<input type="submit" name="navigate" value="Finish">
	<% End If %>
	
	</form>
    
    <%
    Else
    
        For Each strItem In Request.Form
        
            If CInt(Left(strItem, 1)) <> "" Then
				Response.Write("EventCode=""" & Request.Form(strItem) & """>" & vbCrLf)
				SectionCode = "GA"
				OfferQuantity = "1"
				SeatTypeCode = "16"
				Call AddToCart(EventCode, SectionCode, OfferQuantity, SeatTypeCode)
	        End If

         Next

    End If
    
    Call Continue
    
End Sub 

'================================================================

Sub AddToCart(EventCode, SectionCode, OfferQuantity, SeatTypeCode)

ErrorLog("EventCode " & EventCode & "")

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

				SQLPrice = "SELECT Price, PhoneOrderSurcharge, FaxOrderSurcharge, MailOrderSurcharge, BoxOfficeSurcharge FROM Price (NOLOCK) WHERE EventCode = " & EventCode & " AND SectionCode = '" & SectionCode & "' AND SeatTypeCode = " & Clean(Request("SeatTypeCode"))
				Set rsPrice = OBJdbConnection.Execute(SQLPrice)
			        Price = rsPrice("Price")
			    rsPrice.Close
				Set rsPrice = nothing	
				
				Surcharge = NewSurcharge
				
				DiscountAmount = (Price - NewPrice)
						
								
				'REE 11/29/6 - Modified for subscriptions.  Update Seat and SubFixedEvent lines only.
				SQLUpdateSeatType = "UPDATE OrderLine WITH (ROWLOCK) SET SeatTypeCode = " & CleanNumeric(SeatTypeCd) & ", Price = " & Price & ", Surcharge = " & Surcharge & ", DiscountTypeNumber = " & DiscountTypeNumber & ", Discount = " & DiscountAmount & " WHERE OrderNumber = " & Session("OrderNumber") & " AND ItemNumber IN (SELECT TOP 1 ItemNumber FROM OrderLine (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND SeatTypeCode IS NULL AND ItemType IN ('Seat', 'SubFixedEvent') ORDER BY LineNumber DESC)"
				Set rsUpdateSeatType = OBJdbConnection.Execute(SQLUpdateSeatType)
				
			Next				
			
		Case Else
		
			Call AddOnSurvey
			
	End Select
	
End If

Call Continue

End Sub

'===========================

%>

