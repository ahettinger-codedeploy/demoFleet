<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%

Page = "Survey"
SurveyNumber = 891
SurveyFileName = "EventAddOn2011.asp"

'===============================================
'Desert Classic Concours d'Elegance (10/26/2010)
'Event Add On Survey

'Required Event List
'Multiple Offer Events
'Open Ended Ticket Quantity

'Required Event
RequiredCount = 2
Dim RequiredEvent(2)
RequiredEvent(1) = 310389 
RequiredEvent(2) = 310390

OfferCount = 2
Dim OfferEvent(2)
OfferEvent(1) =  310391   'The Tour - Car and Driver Fee 
OfferEvent(2) =  310392   'The Tour - Passenger Fee 

OfferSection =  "GA"
TicketQuantityCount = 10

'===============================================

If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If


If Clean(Request("FormName")) = "EventOffer" Then
	index = 1
	For Each EventCd In Request("EventCode")
	    If Request("Quantity")(index) <> "" And Request("Quantity")(index) <> "0" Then
	        Call AddToCart(CleanNumeric(Request("EventCode")(index)), Clean(Request("SectionCode")(index)), CleanNumeric(Request("Quantity")(index)), CleanNumeric(Request("SeatTypeCode")(index)))
	    End If
	    index = index + 1
	Next
	
	Call Terms
	
ElseIf Clean(Request("FormName")) = "Terms" Then
    Call Terms
    
ElseIf Clean(Request("FormName")) = "UpdateSurvey" Then    
    Call UpdateSurvey
    
ElseIf Clean(Request("FormName")) = "Continue" Then    
    Call Continue
        
Else
    Call AddOnSurvey
    
End If


'=======================================

Sub AddOnSurvey

For j = 1 to RequiredCount

    'Required Event ticket count
	SQLRequiredCheck = "SELECT COUNT(OrderLine.ItemNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Seat.EventCode = " & RequiredEvent(j) & " AND OrderLine.ItemType = 'Seat' GROUP BY Seat.EventCode ORDER BY Seat.EventCode"
	Set rsRequiredCheck = OBJdbConnection.Execute(SQLRequiredCheck)	
		
	    If Not rsRequiredCheck.EOF Then	

              If DocType <> "" Then
            Response.Write(DocType)
        Else
            Response.Write("<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">")
        End If

    %>

    <!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

    <html>
    <head>

    <%

    'Dynamic Page Title
    If Request("OrganizationNumber")<> "" And Title = "" Then
        SQLOrg = "SELECT Organization FROM Organization (NOLOCK) WHERE OrganizationNumber = " & CleanNumeric(Request("OrganizationNumber"))
        Set rsOrg = OBJdbConnection.Execute(SQLOrg)    
        Title = rsOrg("Organization") & " Ticket Sales"    
        rsOrg.Close
        Set rsOrg = nothing
    End If  
     
    %>

    <title>="<%= Title %>"</title>

    <style type="text/css">
    <!--
    @import url('/Clients/DesertConcours/Survey/Images/style.css');
    -->
    </style>

    </head>

    <%=strBody %>

    <!--#INCLUDE virtual="TopNavInclude.asp"-->

        <FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey" >
        <INPUT TYPE="hidden" NAME="FormName" VALUE="EventOffer">
        
        <! -- Table Begin -- >
        <table id = "tix-eventoffer" summary="surveypage" width="500" cellpadding="0" cellspacing="0">
        <! -- Table Column Headings -- >
            <thead>
                <tr>
                    <th scope="col">SPECIAL OFFERS<BR />Desert Classic Concours d'Elegance</th>
                </tr>
            </thead>
            <tbody>        
        <%
	
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
            
            'Offer Event Code
            SQLOfferType = "SELECT Price.EventCode FROM Price (NOLOCK) INNER JOIN SeatType (NOLOCK) ON Price.SeatTypeCode = SeatType.SeatTypeCode WHERE Price.EventCode = " & OfferEvent(i) & " AND SectionCode = '" & OfferSection & "'"
	        Set rsOfferType = OBJdbConnection.Execute(SQLOfferType)
	            OfferEventCode = rsOfferType("EventCode")
            rsOfferType.Close   
            Set rsOfferType = Nothing 
            
            %>     

            <tr>
                <td>
                     <table bgcolor="#f1f1f1" summary="surveypage" width="100%" cellpadding="20">
                         <tr align="center">
                            <td>
                            <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="3"><B><%=rsPackages("Act")%></B></FONT><br /><br />
                            <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><%=rsPackages("ActComments")%></FONT><br /><br />
                            <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><%=rsPackages("Act")%></FONT><br />
                            <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><%=FormatDateTime(rsPackages("EventDate"),vbLongDate)%> at</FONT>
                            <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><%=Left(FormatDateTime(rsPackages("EventDate"),vbLongTime),Len(FormatDateTime(rsPackages("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsPackages("EventDate"),vbLongTime),3)%></FONT><br />
                            <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><B><%=rsVenueDetail("Venue")%></B></FONT><br />
                            <br />
                                <table width="100%" border="0" CELLPADDING="5" CELLSPACING="0">        
                                <tr align="left">
                                    <td ALIGN="left"><FONT FACE=verdana,arial,helvetica COLOR=#000000 SIZE=2><B><U>Ticket Type</U></B></FONT></td>
                                    <td ALIGN="left"><FONT FACE=verdana,arial,helvetica COLOR=#000000 SIZE=2><B><U>Price</U></B></FONT></td>
                                    <td ALIGN="center"><FONT FACE=verdana,arial,helvetica COLOR=#000000 SIZE=2><B><U>Ticket Quantity</U></B></FONT></td>
                                </tr>                                
                                    <%                                 
                                    SQLSeatType = "SELECT Price.SeatTypeCode, SeatType.SeatType, Price.Price FROM Price (NOLOCK) INNER JOIN SeatType (NOLOCK) ON Price.SeatTypeCode = SeatType.SeatTypeCode WHERE Price.EventCode = " & rsPackages("EventCode") & " AND SectionCode = '" & OfferSection & "'"
		                            Set rsSeatType = OBJdbConnection.Execute(SQLSeatType)
                            		
		                            If Not rsSeatType.EOF Then		    
                                  
                                        Do While Not rsSeatType.EOF
                                        %>                                     
                                        <tr>
                                            <td ALIGN="left"><FONT FACE=verdana,arial,helvetica COLOR=#000000 SIZE=2>
                                                <%=rsSeatType("SeatType")%></FONT>
                                            </td>
                                            <td ALIGN="left"><FONT FACE=verdana,arial,helvetica COLOR=#000000 SIZE=2>
                                                <%=FormatCurrency(rsSeatType("Price"),2)%></FONT>
                                            </td>
                                            <td ALIGN="center"><FONT FACE=verdana,arial,helvetica COLOR=#000000 SIZE=2> 
                	                            <select name="Quantity">
	                                            <option value="0">-- Select Quantity --</option>
                                                <%
                                                For k = 1 to TicketQuantityCount
                                                    Select Case k
                                                        Case 1   
                                                        %>
                                                        <option value="<%=k%>"><%=k%>&nbsp;&nbsp;ticket</option>
                                                        <%
                                                        Case Else
                                                        %>
                                                        <option value="<%=k%>"><%=k%>&nbsp;&nbsp;tickets</option>
                                                        <%
                                                    End Select                   
                                                Next
                                                %>
                                                </select>                                         
                                                <INPUT TYPE="hidden" NAME="EventCode" VALUE="<%=rsPackages("EventCode")%>">
                                                <INPUT TYPE="hidden" NAME="SectionCode" VALUE="<%=OfferSection%>">
                                                <INPUT TYPE="hidden" NAME="SeatTypeCode" VALUE="<%=rsSeatType("SeatTypeCode")%>">
                                            </td>
                                        </tr>                                                                
                                        <%                                
                                        rsSeatType.movenext        
                                        Loop
                                                                             
                                    End If    
                                
                                    rsSeatType.Close
                                    Set rsSeatType = Nothing                                
                                    %>                                   
                                </table>                
                            </td>
                        </tr>
                    </table>
                    <br />
        </td>
    </tr>
<%

           rsOfferCheck.Close
           Set rsOfferCheck = Nothing   
           
           rsPackages.Close
           Set rsPackages = Nothing   
           
           rsVenueDetail.Close
           Set rsVenueDetail = Nothing 
       
       Next 
    

   
    rsRequiredCheck.Close
	Set rsRequiredCheck = nothing
    


%>
    <tr>
        <table>
        <tr>
        <td align=center>
        <INPUT type="submit" value="Add To Cart" /></form>
        </td>
        <td>        
        <form action="<%= SurveyFileName %>" method="post">
        
        <INPUT TYPE="hidden" NAME="FormName" VALUE="Terms">
        <input type="submit" value="No Thanks!" /></form>
        </td>
        </tr>
        </table>
   </tr>
</TABLE>

</center>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%

End If

Next

Call Terms

    
End Sub 'OfferEvent

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

'======================

Sub Terms


Response.Redirect("TicketPolicy2011.asp")
Exit Sub


End Sub

'====================

Sub Continue

    Session("SurveyComplete") = Session("OrderNumber")
    If Session("UserNumber") = "" Then
	    Response.Redirect("/Ship.asp")
    Else
	    Response.Redirect("/Management/AdvanceShip.asp")
    End If
    
End Sub 'Continue

'====================

%>