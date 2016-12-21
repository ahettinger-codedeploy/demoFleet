<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%

Page = "Survey"
SurveyNumber = 875
SurveyFileName = "EventAddOn2010.asp"

'===============================================
'Armed Forces Bowl (10/5/2010)
'Event Add On Survey

'Purchase 1 ticket to the required event:
'Bell Helicopter Armed Forces Bowl

'Option to purchase 1 ticket for each of these two offer events:
' 2010 Bell Helicopter Armed Forces Bowl Team Kick-off Luncheon
' 2010 Bell Helicopter Armed Forces Bowl Game Program

'1 to 1 ratio of required to offer tickets
'Can purchase no higher then number of required tickets

'Offer event is GA seating

'Required Event
RequiredEvent = 296419

OfferCount = 2

Dim OfferEvent(2)

'Offer Event
OfferEvent(1) =  306477
OfferEvent(2) =  306478

OfferSection =  "GA"


'===============================================

If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If

If Session("UserNumber")<> "" Then
TableFontFace = "Arial"
TableCategoryBGColor = "#008400"
TableCategoryFontColor = "FFFFFF"
TableColumnHeadingBGColor = "99CC99"
TableColumnHeadingFontColor = "000000"
TableDataBGColor = "E9E9E9"
End If


If Clean(Request("FormName")) = "EventOffer" Then
	index = 1
	For Each EventCd In Request("EventCode")
	    If Request("Quantity")(index) <> "" And Request("Quantity")(index) <> "0" Then
	        Call AddToCart(CleanNumeric(Request("EventCode")(index)), Clean(Request("SectionCode")(index)), CleanNumeric(Request("Quantity")(index)), CleanNumeric(Request("SeatTypeCode")(index)))
	    End If
	    index = index + 1
	Next
	
	Call Continue
	
ElseIf Clean(Request("FormName")) = "Continue" Then
    Call Continue
    
ElseIf Clean(Request("FormName")) = "UpdateSurvey" Then    
    Call UpdateSurvey
    
Else
    Call AddOnSurvey
    
End If


'=======================================
Sub AddOnSurvey

%>

<html>
<head>
<title><%= Title %></title>

</head>

<%=strBody %>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey" >
<INPUT TYPE="hidden" NAME="FormName" VALUE="EventOffer">


<table cellpadding="10" cellspacing="25" border="0">
<tr bgcolor="<%=TableCategoryBGColor%>" align="left">
    <td>
        <FONT FACE="<%=TableFontFace%>" COLOR="<%=TableCategoryFontColor%>" SIZE="4">
        <strong>SPECIAL OFFER</strong></FONT>
    </td>
</tr>
<%

    'Required Event ticket count
	SQLRequiredCheck = "SELECT COUNT(OrderLine.ItemNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Seat.EventCode = " & RequiredEvent & " AND OrderLine.ItemType = 'Seat' GROUP BY Seat.EventCode ORDER BY Seat.EventCode"
	Set rsRequiredCheck = OBJdbConnection.Execute(SQLRequiredCheck)	
		
	If Not rsRequiredCheck.EOF Then	
	
	    For i = 1 to OfferCount
    	
		    'Verify that offer event has equal quantity of available seats
	        SQLOfferCheck = "SELECT COUNT(Seat.ItemNumber) AS AvailCount FROM Seat (NOLOCK) INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Event.EventCode = " & OfferEvent(i) & " AND Seat.SectionCode IN ('" & OfferSection & "') AND Seat.StatusCode = 'A'"
            Set rsOfferCheck = OBJdbConnection.Execute(SQLOfferCheck)
            
            'Verify that there are enough offer event tickets to match required event tickets
            If rsRequiredCheck("TicketCount") > rsOfferCheck("AvailCount") Then
                OfferTicketCount = rsRequiredCheck("TicketCount") - rsOfferCheck("AvailCount")
            Else
                OfferTicketCount = rsRequiredCheck("TicketCount")
            End If
    	
            'Offer Act and Date
            SQLPackages = "SELECT Event.EventCode, Event.EventDate, Event.Comments AS EventComments, Act.Act, Act.Comments AS ActComments FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode WHERE Event.EventCode = " & OfferEvent(i) & " "
            Set rsPackages = OBJdbConnection.Execute(SQLPackages)
            
            SQLVenueDetail = "Select Venue.Venue, Venue.Address_1, Venue.Address_2, Venue.City, Venue.State, Venue.Zip_Code FROM Venue (NOLOCK) INNER JOIN Event (NOLOCK) ON Venue.VenueCode = Event.VenueCode WHERE EventCode = " & rsPackages("EventCode") & " "
            Set rsVenueDetail = OBJdbConnection.Execute(SQLVenueDetail)       
            
            'Offer TicketType and Price
            SQLSeatType = "SELECT Price.SeatTypeCode, SeatType.SeatType, Price.Price FROM Price (NOLOCK) INNER JOIN SeatType (NOLOCK) ON Price.SeatTypeCode = SeatType.SeatTypeCode WHERE Price.EventCode = " & OfferEvent(i) & " AND SectionCode = '" & OfferSection & "'"
	        Set rsSeatType = OBJdbConnection.Execute(SQLSeatType)
	            OfferSeatTypeCode = rsSeatType("SeatTypeCode")
	            OfferSeatType = rsSeatType("SeatType")
	            OfferPrice = rsSeatType("Price")
            rsSeatType.Close   
            Set rsrsSeatType = Nothing 
  
%>     

        <tr align="left" bgcolor="<%=TableDataBGColor%>">
            <td align="center">
                <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="4"><B><%=rsPackages("Act")%></B></FONT><br /><br />
                <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><%=rsPackages("ActComments")%></FONT><br /><br />
                <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><%=rsPackages("Act")%></FONT><br />
                <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><%=FormatDateTime(rsPackages("EventDate"),vbLongDate)%> at</FONT>
                <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><%=Left(FormatDateTime(rsPackages("EventDate"),vbLongTime),Len(FormatDateTime(rsPackages("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsPackages("EventDate"),vbLongTime),3)%></FONT><br />
                <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><B><%=rsVenueDetail("Venue")%></B></FONT><br />
                <%
                 If rsVenueDetail("Address_1") <> "" Then
                %>
                <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><%=rsVenueDetail("Address_1")%></FONT><br />
                <%
                End If
                If rsVenueDetail("Address_2") <> "" Then
                %>
                <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><%=rsVenueDetail("Address_2")%></FONT><br />
                <%
                End If
                If rsVenueDetail("City") <> "" AND rsVenueDetail("State") <> "" Then
                %>
                <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><%=rsVenueDetail("City")%>, <%=rsVenueDetail("State") %>&nbsp;<%=rsVenueDetail("Zip_Code")%></FONT><br />
                <%
                End If
                %>
                <table width ="70%" border="0" cellpadding="0" cellspacing="10">
                <tr>    
                    <td ALIGN="center"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><B><U>Ticket Type</U></B></FONT></td>
                    <td ALIGN="center"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><B><U>Price</U></B></FONT></td>
                    <td ALIGN="center"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><B><U>Ticket Quantity</U></B></FONT></td>
                </tr>
                <tr>
                    <td ALIGN="center"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><%=OfferSeatType%></td>
                    <td ALIGN="center"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><%=FormatCurrency(OfferPrice,2)%></FONT></td>
                    <td ALIGN="center"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">     
                        		        <select name="Quantity">
    		        <option value="0">-- Select Ticket Quantity --</option>
                    <%
                    For j = 1 to OfferTicketCount
                        Select Case OfferTicketCount
                            Case 1   
                            %><option value="<%=j%>"><%=j%>&nbsp;&nbsp;ticket</option><%
                            Case Else
                            %><option value="<%=j%>"><%=j%>&nbsp;&nbsp;tickets</option><%
                       End Select                   
                    Next
                    %>
                    </select>
                   </td>
                 </tr>
                 <tr>
                    <td colspan=4 align="center">
                     <INPUT TYPE="hidden" NAME="EventCode" VALUE="<%=rsPackages("EventCode")%>">
                     <INPUT TYPE="hidden" NAME="SectionCode" VALUE="<%=OfferSection%>">
                     <INPUT TYPE="hidden" NAME="SeatTypeCode" VALUE="<%=OfferSeatTypeCode%>">
                    </td>
                </tr>    
               </table>
               
            </td>
        </tr>
           


<%

       rsVenueDetail.Close
       Set rsVenueDetail = Nothing 
       
       rsPackages.Close
       Set rsPackages = Nothing   
       
       Next 
    
    End If 
    
    rsRequiredCheck.Close
	Set rsRequiredCheck = nothing
    


%>
    <tr>
        <td align=center>
        <INPUT type="submit" value="Add To Cart" /></form>
        
        <form action="<%= SurveyFileName %>" method="post">
        <INPUT TYPE="hidden" NAME="FormName" VALUE="Continue">
        <input type="submit" value="No Thanks!" /></form>
        </td>
   </tr>
</TABLE>

</center>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%
    
End Sub 'DisplayOfferEvent


'=======================================

Sub AddToCart(EventCode, SectionCode, OfferQuantity, SeatTypeCd)

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
				SQLPrice = "SELECT Price, Surcharge FROM Price (NOLOCK) WHERE EventCode = " & EventCode & " AND SectionCode = '" & SectionCode & "' AND SeatTypeCode = " & CleanNumeric(SeatTypeCd)
				Set rsPrice = OBJdbConnection.Execute(SQLPrice)
								
				Price = rsPrice("Price")
				Surcharge = rsPrice("Surcharge")
								
				rsPrice.Close
				Set rsPrice = nothing
								
				'REE 11/29/6 - Modified for subscriptions.  Update Seat and SubFixedEvent lines only.
				SQLUpdateSeatType = "UPDATE OrderLine WITH (ROWLOCK) SET SeatTypeCode = " & CleanNumeric(SeatTypeCd) & ", Price = " & Price & ", Surcharge = " & Surcharge & ", Discount = 0 WHERE OrderNumber = " & Session("OrderNumber") & " AND ItemNumber IN (SELECT TOP 1 ItemNumber FROM OrderLine (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND SeatTypeCode IS NULL AND ItemType IN ('Seat', 'SubFixedEvent') ORDER BY LineNumber DESC)"
				Set rsUpdateSeatType = OBJdbConnection.Execute(SQLUpdateSeatType)
				
			Next				
			
		Case Else
		
			Call AddOnSurvey
			
	End Select
End If

End Sub

Sub GeneralSurvey

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & Title & "</TITLE>" & vbCrLf
%>
<script language="javascript">
function validate() {
    form = document.GeneralForm;
    isAnswered = true;
    for(i=0;i<form.elements.length;i++) {
        if(form.elements[i].type == "text") {
            if(form.elements[i].value == "") {
                isAnswered = false
            }
        }
    }
    if(isAnswered == false) {
        alert("You are required to complete this survey")
        return false;
    }
}
</script>
<%
Response.Write "</HEAD>" & vbCrLf
Response.Write strBody & vbCrLf
%>

<!--#INCLUDE virtual="TopNavInclude.asp"-->
<BR>
<BR>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3>Car Information Survey</H3></FONT>


<center>
<form action="<%= SurveyFileName %>" method="post" name="GeneralForm" onsubmit="return validate()">
<input type="hidden" name="FormName" value="UpdateSurvey" />
<TABLE CELLPADDING=10 CELLSPACING=5 WIDTH="600" border=0>
<%
    SQLEventCode = "SELECT Count(LineNumber) AS TotalTix FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Event.EventCode = 256090"
    Set rsEventCode = OBJdbConnection.Execute(SQLEventCode)
    NumTickets = rsEventCode("TotalTix")
    rsEventCode.Close
    Set rsEventCode = nothing
    
    If CInt(NumTickets) = 0 Then
        Call Continue    
    End If
    
    For i = 1 To NumTickets
        For x = 1 To UBound(Questions)
%>
    <tr><td align="right"><FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><%=Questions(x)%></FONT></td><td><input type="text" name="Answer<%=x%>" /></td></tr>
<%
        Next
    Next
%>
<tr><td>&nbsp;</td><td><input type="submit" value="Continue" /></td></tr>
</TABLE>
</form>
</center>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%
End Sub

Sub UpdateSurvey
    For AnswerNumber = 1 To UBound(Questions)
		If Clean(Request("Answer" & AnswerNumber)) <> "" Then
			For Each Item IN Request("Answer" & AnswerNumber)
				If Item <> "" Then
					SQLUpdateSurvey = "INSERT SurveyAnswers(SurveyNumber, OrderNumber, CustomerNumber, SurveyDate, AnswerNumber, Answer, Question) VALUES(" & CleanNumeric(SurveyNumber) & ", " & CleanNumeric(Session("OrderNumber")) & ", " & CleanNumeric(Session("CustomerNumber")) & ", '" & Now() & "', " & AnswerNumber & ", '" & Clean(Item) & "', '" & Clean(Questions(AnswerNumber)) & "')"
					Set rsUpdateSurvey = OBJdbConnection.Execute(SQLUpdateSurvey)
				End If
			Next
		End If
	Next
	
    Call Continue
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
