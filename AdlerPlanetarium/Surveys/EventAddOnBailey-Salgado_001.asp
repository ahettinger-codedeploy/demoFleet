<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%

Page = "Survey"
SurveyNumber = 1051
SurveyFileName = "EventAddOnBailey-Salgado.asp"


'Adler Planetarium (4/29/11)
'==================
'Event Add On Survey
'Required Event
'==============
'Adler After Dark (364552)

'Offer Events
'===========
'-Event code:  364639
'Name of Event:  7:00 pm - Science and Music with the Bailey-Salgado Project (64048)
'-Event Code:  364640 
'Name of Event:  8:00 pm - Science and Music with the Bailey-Salgado Project (64049)

'Offer should be 1-for-1

'Online and offline

'Pass along fees in event settings


'ratio of tickets in offer is 1-to-1
'offered event tickets are not discounted
'offered event tickets incurr no change in per ticket service fees
'when either event sells out, it will no longer be listed.
'when both events sell out, survey will not display

'======================
'Survey Variables

ReqrdEvent = 364552

Dim OfferEvent(2)
OfferEvent(0) = 364639
OfferEvent(1) = 364640 
OfferSection =  "GA"

'======================

'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If


If Clean(Request("FormName")) = "EventOffer" Then
	Call AddToCart(CleanNumeric(Request("EventCode")), Clean(Request("SectionCode")), Clean(Request("SeatTypeCode")),CleanNumeric(Request("Quantity")))
ElseIf Clean(Request("FormName")) = "Continue" Then
    Call Continue
Else
    Call AddOnSurvey
End If


'======================

Sub AddOnSurvey

    'Determine if required event is in the shopping cart    
  
    SQLTicketCount = "SELECT Count(LineNumber) AS TotalTix FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Event.EventCode = " & ReqrdEvent & ""
    Set rsTicketCount = OBJdbConnection.Execute(SQLTicketCount)
    NumTickets = rsTicketCount("TotalTix")
    rsTicketCount.Close
    Set rsTicketCount = nothing
        
    If CInt(NumTickets) = 0 Then
        Call Continue    
    End If
    
    
    'Determine which offer events have available seats
    For EventCount = 0 To 1
    
    SQLCountAvail = "SELECT COUNT(Seat.ItemNumber) AS CountAvail FROM Seat (NOLOCK) INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.EventCode = " & OfferEvent(EventCount) & " AND Seat.SectionCode IN ('GA') AND Seat.StatusCode = 'A' GROUP BY Event.EventCode"
    Set rsCountAvail = OBJdbConnection.Execute(SQLCountAvail)  
    
    AvailTickets = AvailTickets + rsCountAvail("CountAvail")
    
    If Not rsCountAvail.EOF Then	
    	SQLEventList = "SELECT EventCode FROM Event (NOLOCK) WHERE Event.EventCode = " & OfferEvent(EventCount) & " "
        Set rsEventList= OBJdbConnection.Execute(SQLEventList) 
        EventList = EventList & rsEventList("EventCode") & ","  
        rsEventList.Close
        Set rsEventList = nothing 
    End If
    
	rsCountAvail.Close
	Set rsCountAvail = nothing
	
	Next   

    If CInt(AvailTickets) = 0 Then
        Call Continue    
    End If
    

   OfferList = Left(EventList,((Len(EventList))-1))

 
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML>
<HEAD>
<TITLE><%= Title %></TITLE>
</HEAD>
<%
Response.Write strBody & vbCrLf
%>
<!--#INCLUDE virtual="TopNavInclude.asp"-->
<center>
<TABLE CELLPADDING=10 CELLSPACING=5 WIDTH="600" border="0">
<tr>
    <td>  
        <TABLE WIDTH="90%" border="0">
        <TR>
            <TD VALIGN="top" ALIGN="center">
            <!-- Offer Event Production Description -->
            <%
            SQLActInfo = "SELECT Act.Act, Act.Comments as ActComments, Event.EventDate, Venue.Venue, Venue.Address_1, Venue.Address_2, Venue.City, Venue.State, Venue.Zip_Code FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode WHERE Event.EventCode IN(" & OfferList & ")"
            Set rsActInfo = OBJdbConnection.Execute(SQLActInfo) 
                %>
                <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="3">WOULD YOU LIKE TO ADD THIS ADDITIONAL EVENT?</FONT><br /><br /><br />
                <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="4"><B><%=rsActInfo("Act")%></B></FONT><br />
                <br />
                <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><%=rsActInfo("ActComments")%></FONT>
                <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><%=rsActInfo("Act")%></FONT><br />
                <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><%=FormatDateTime(rsActInfo("EventDate"),vbLongDate)%></FONT><br />
                <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><B><%=rsActInfo("Venue")%></B></FONT><br />
                <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><%=rsActInfo("Address_1")%><br />
                <%
                If rsActInfo("Address_2") <> "" Then
                %>
                <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><%=rsActInfo("Address_2")%><br />
                <%
                End If
                %>
                <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><%=rsActInfo("City")%>, <%=rsActInfo("State")%><%=rsActInfo("Zip_Code")%></FONT><br />
                <br />
                <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">Please click on the corresponding button below if</FONT><br />
                <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">you would like to add the following ticket(s) to your shopping cart</FONT><br />
                <br /><br />
                <% 
            rsActInfo.Close   
            Set rsrsActInfo = Nothing 
                       
            'Offer Event Price Info
            SQLPackages = "SELECT Event.EventCode, Event.EventDate, Act.Act FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Price (NOLOCK) ON Event.EventCode = Price.EventCode INNER JOIN SeatType (NOLOCK) ON Price.SeatTypeCode = SeatType.SeatTypeCode WHERE Event.EventCode IN(" & OfferList & ") AND Price.EventCode IN(" & OfferList & ") ORDER BY SeatType.SeatTypeCode"
            Set rsPackages = OBJdbConnection.Execute(SQLPackages)
            
            If Not rsPackages.EOF Then
            
                Do While Not rsPackages.EOF
                
                'SeatType and Price
                SQLSeatType = "SELECT Price.SeatTypeCode, SeatType.SeatType, Price.Price FROM Price (NOLOCK) INNER JOIN SeatType (NOLOCK) ON Price.SeatTypeCode = SeatType.SeatTypeCode WHERE Price.EventCode = " & rsPackages("EventCode") & " AND SectionCode = '" & OfferSection & "'"
		        Set rsSeatType = OBJdbConnection.Execute(SQLSeatType)
		            OfferSeatTypeCode = rsSeatType("SeatTypeCode")
		            OfferSeatType = rsSeatType("SeatType")
		            OfferPrice = rsSeatType("Price")
                rsSeatType.Close   
                Set rsrsSeatType = Nothing  
                
                OptionCount = OptionCount + 1
                %>
                <fieldset style="width:400px; border:2px solid #006699">
                <legend style="color:#000;font-size:13px;font-weight:bold">Option <%=OptionCount%></legend>
                <br />
                <table width="70%" border="0" CELLPADDING="5" CELLSPACING="0">
                <tr>    
                    <td><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><B><U>Date</U></B></FONT></td>
                    <td><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><B><U>Time</U></B></FONT></td>
                    <td ALIGN="right"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><B><U>Price</U></B></FONT></td>
                    <td ALIGN="right"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><B><U>Quantity</U></B></FONT></td>
                </tr>
                <tr>
                    <td ALIGN="left"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><%=FormatDateTime(rsPackages("EventDate"),vbShortDate)%></FONT></td>
                    <td ALIGN="left"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><%=Left(FormatDateTime(rsPackages("EventDate"),vbLongTime),Len(FormatDateTime(rsPackages("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsPackages("EventDate"),vbLongTime),3)%></FONT></FONT></td>
                    <td ALIGN="right"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><%=FormatCurrency(OfferPrice,2)%></FONT></td>
                    <td ALIGN="center"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><%=NumTickets%></td>
                 </tr>
                 <tr>
                    <td colspan=4 align="center">
                    <br />
                     <FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey">
                     <INPUT TYPE="hidden" NAME="FormName" VALUE="EventOffer">
                     <INPUT TYPE="hidden" NAME="EventCode" VALUE="<%=rsPackages("EventCode")%>">
                     <INPUT TYPE="hidden" NAME="SectionCode" VALUE="<%=OfferSection%>">
                     <INPUT TYPE="hidden" NAME="SeatTypeCode" VALUE="<%=OfferSeatTypeCode%>">
                     <INPUT TYPE="hidden" NAME="Quantity" VALUE="<%=NumTickets%>">    
                     <INPUT TYPE="submit" VALUE="Add to Cart" />
                    </FORM>
                    </td>
                </tr>    
                </table> 
                </fieldset>                              
                <BR /><BR />
                <%
                OptionCount = OptionCount 
                rsPackages.movenext
         
                Loop
           
                End If
            
                rsPackages.Close
                Set rsPackages = Nothing
            
                %>
    
<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey">
<INPUT TYPE="hidden" NAME="FormName" VALUE="Continue">
<INPUT TYPE="submit" VALUE="No Thanks" />
</FORM>
</td>
</tr>
</table>

</td>
</tr>
</table>

</center>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%
    
End Sub 'AddOnSurvey

'========================

Sub AddToCart(EventCode, SectionCode, SeatTypeCode, OfferQuantity)

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
				SQLPrice = "SELECT Price, PhoneOrderSurcharge, FaxOrderSurcharge, MailOrderSurcharge, BoxOfficeSurcharge, Surcharge FROM Price (NOLOCK) WHERE EventCode = " & EventCode & " AND SectionCode = '" & SectionCode & "' AND SeatTypeCode = " & Clean(Request("SeatTypeCode"))
				Set rsPrice = OBJdbConnection.Execute(SQLPrice)
								
				Price = rsPrice("Price")
				
				Select Case Session("OrderTypeNumber")
                    Case 2
                    Surcharge = rsPrice("PhoneOrderSurcharge")
                    Case 3
                    Surcharge = rsPrice("FaxOrderSurcharge")
                    Case 4
                    Surcharge = rsPrice("MailOrderSurcharge")
                    Case 7
                    Surcharge = rsPrice("BoxOfficeSurcharge")
                    Case Else
                    Surcharge = rsPrice("Surcharge")
                End Select
				
	            								
				rsPrice.Close
				Set rsPrice = nothing		
								
								
				'REE 11/29/6 - Modified for subscriptions.  Update Seat and SubFixedEvent lines only.
				SQLUpdateSeatType = "UPDATE OrderLine WITH (ROWLOCK) SET SeatTypeCode = " & Clean(Request("SeatTypeCode")) & ", Price = " & Price & ", Surcharge = " & Surcharge & " WHERE OrderNumber = " & Session("OrderNumber") & " AND ItemNumber IN (SELECT TOP 1 ItemNumber FROM OrderLine (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND SeatTypeCode IS NULL AND ItemType IN ('Seat', 'SubFixedEvent') ORDER BY LineNumber DESC)"
				Set rsUpdateSeatType = OBJdbConnection.Execute(SQLUpdateSeatType)
				
			Next				

			Call DBClose(OBJdbConnection)
			
			Call Continue
			
		Case Else
		
			Call AddOnSurvey
			
	End Select
End If

End Sub

Sub Continue
    Session("SurveyComplete") = Session("OrderNumber")
    If Session("UserNumber") = "" Then
	    Response.Redirect("/Ship.asp")
    Else
	    Response.Redirect("/Management/AdvanceShip.asp")
    End If
End Sub 'Continue

%>


