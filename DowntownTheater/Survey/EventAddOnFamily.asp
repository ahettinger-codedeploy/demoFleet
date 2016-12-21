<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%

Page = "Survey"
SurveyNumber = 850
SurveyName = "EventAddOnFamily.asp"

'===============================================
'Event Add On



'===============================================

RequiredEventCount = 1

Dim RequiredEventCode(1)
RequiredEventCode(1)="298144" 

NumberRequiredSeatType = 1

Dim RequiredSeatCode(1)
RequiredSeatCode(1)= "16" 

OfferEventCount = 1

Dim OfferEventCode(1)
OfferEventCode(1)="337831"

OfferSectionCode="GA"

OfferName = "Family Pack Upgrade"
OfferPackPrice = 9

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

'Verify the number of required tickets on the required event

RequiredTicketCount = 0

For i = 1 To RequiredEventCount

    For j = 1 to NumberRequiredSeatType

        'Required Event ticket count
        SQLRequiredCheck = "SELECT COUNT(OrderLine.ItemNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Seat.EventCode = " & RequiredEventCode(i) & " AND OrderLine.SeatTypeCode = " & RequiredSeatCode(j) & ""
        Set rsRequiredCheck = OBJdbConnection.Execute(SQLRequiredCheck)	
        	
        If Not rsRequiredCheck.EOF Then	    
             RequiredTicketCount =  (RequiredTicketCount + rsRequiredCheck("TicketCount"))
        End If
        
        rsRequiredCheck.Close
        Set rsRequiredCheck = nothing
    
    Next
    
Next

If RequiredTicketCount => 4 Then
    Call CheckOffer(RequiredTicketCount)
Else
    Call Continue
End If

End Sub 'AddOnSurvey

'=======================================

Sub CheckOffer(RequiredTicketCount)

'Verify that offer event has enough available seats

OfferTicketCount = 0

For i = 1 To RequiredEventCount
    
    SQLOfferCheck = "SELECT COUNT(Seat.ItemNumber) AS AvailCount FROM Seat (NOLOCK) INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Event.EventCode = " & OfferEventCode(i) & " AND Seat.SectionCode IN ('" & OfferSectionCode & "') AND Seat.StatusCode = 'A'"
    Set rsOfferCheck = OBJdbConnection.Execute(SQLOfferCheck)
    
    If Not rsOfferCheck.EOF Then	   

        If RequiredTicketCount > rsOfferCheck("AvailCount") Then
            OfferTicketCount = RequiredTicketCount - rsOfferCheck("AvailCount")
        Else
            OfferTicketCount = RequiredTicketCount
        End If
        
        Remainder = OfferTicketCount MOD 4
                        
        If Remainder = 0 Then 
	        OfferFamilyCount = (OfferTicketCount / 4)
		End If
		
		If Remainder > 0 Then 
			OfferFamilyCount = ((OfferTicketCount - Remainder) / 4)
		End If 
		
		ErrorLog("OfferTicketCount: " & OfferTicketCount & "")
		
		ErrorLog("Remainder: " & Remainder & "")  
		
		ErrorLog("OfferFamilyCount: " & OfferFamilyCount & "")
		     

        rsOfferCheck.Close
        Set rsOfferCheck = nothing

    End If

Next

If OfferTicketCount <> 0 Then
    Call DisplayOfferEvent(OfferFamilyCount)
Else
    Call Continue
End If


End Sub 'CheckOffer

'=======================================

Sub DisplayOfferEvent(OfferFamilyCount)

%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title>="<%= Title %>"</title>

<% If Session("UserNumber")<> "" Then %>

<style type="text/css">
.category 
{ 
width: 640px;
	
padding-top:20px; 
padding-bottom:20px; 
padding-left:10px; 
padding-right:0px; 
background-color: #008400;

text-align: left;
font-size: medium;
font-weight: 700;
color: #ffffff;

border-width:2px;
border-style:solid;
border-color:#ffffff;
border-collapse:collapse;
}
.column
{ 
width: 640px;	

padding-top:10px; 
padding-bottom:10px; 
padding-left:10px; 
padding-right:0px; 
background-color: #99cc99;

text-align: left;
font-size: x-small;
font-weight: 400;
color: #000000;

border-width:2px;
border-style:solid;
border-color:#ffffff;
border-collapse:collapse;
}
.data
{ 
width: 640px;
	
padding-top:20px; 
padding-bottom:20px; 
padding-left:10px; 
padding-right:0px; 
background-color: #dddddc;

text-align: center;
font-size: x-small;
font-weight: 400;
color: #000000;

border-width:2px;
border-style:solid;
border-color:#ffffff;
border-collapse:collapse;
}

</style>

<% Else %>

<style type="text/css">
.category 
{ 
width: 640px;
	
padding-top:20px; 
padding-bottom:20px; 
padding-left:10px; 
padding-right:0px; 
background-color: <%=TableCategoryBGColor%>;

text-align: left;
font-size: medium;
font-weight: 700;
color: <%=TableCategoryFontColor%>;

border-width:2px;
border-style:solid;
border-color:#ffffff;
border-collapse:collapse;
}
.column
{ 
width: 640px;	

padding-top:10px; 
padding-bottom:10px; 
padding-left:10px; 
padding-right:0px; 
background-color: <%=TableColumnHeadingBGColor%>;

text-align: left;
font-size: x-small;
font-weight: 400;
color: <%=TableColumnHeadingFontColor%>;

border-width:2px;
border-style:solid;
border-color:#ffffff;
border-collapse:collapse;
}
.data
{ 
width: 640px;
	
padding-top:20px; 
padding-bottom:20px; 
padding-left:10px; 
padding-right:0px; 
background-color: <%=TableDataBGColor%>;

text-align: center;
font-size: x-small;
font-weight: 400;
color: <%=TableDataFontColor%>;

border-width:2px;
border-style:solid;
border-color:#ffffff;
border-collapse:collapse;
}

</style>

<% End If %>

</head>

<%=strBody %>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey">
<INPUT TYPE="hidden" NAME="FormName" VALUE="EventOffer">

<table>
<tr>
    <td class="category">
        Special Offer!
    </td>
</tr>
<tr>
    <td class="column">
        Would you like to add these tickets to your order?
    </td>
</tr>

<%
  	
For i = 1 To RequiredEventCount
    	
'Offer Act and Date
SQLPackages = "SELECT Event.EventCode, Event.EventDate, Event.Comments AS EventComments, Act.Act, Act.Comments AS ActComments FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode WHERE Event.EventCode = " & OfferEventCode(i) & " "
Set rsPackages = OBJdbConnection.Execute(SQLPackages) 

SQLVenueDetail = "Select Venue.Venue, Venue.Address_1, Venue.Address_2, Venue.City, Venue.State, Venue.Zip_Code FROM Venue (NOLOCK) INNER JOIN Event (NOLOCK) ON Venue.VenueCode = Event.VenueCode WHERE EventCode = " & rsPackages("EventCode") & " "
Set rsVenueDetail = OBJdbConnection.Execute(SQLVenueDetail)     
            
    'Offer TicketType and Price
    SQLSeatType = "SELECT Price.SeatTypeCode, SeatType.SeatType, Price.Price FROM Price (NOLOCK) INNER JOIN SeatType (NOLOCK) ON Price.SeatTypeCode = SeatType.SeatTypeCode WHERE Price.EventCode = " & rsPackages("EventCode") & " AND SectionCode = '" & OfferSectionCode & "'"
    Set rsSeatType = OBJdbConnection.Execute(SQLSeatType)
        OfferSeatTypeCode = rsSeatType("SeatTypeCode")
        OfferSeatType = rsSeatType("SeatType")
        OfferPrice = rsSeatType("Price")
    rsSeatType.Close   
    Set rsrsSeatType = Nothing 
      
%>     
        <tr>
            <td class="data">
                <B><%=rsPackages("Act")%></B><br />
                <%=rsPackages("ActComments")%><br />
                <%=FormatDateTime(rsPackages("EventDate"),vbLongDate)%> at
                <%=Left(FormatDateTime(rsPackages("EventDate"),vbLongTime),Len(FormatDateTime(rsPackages("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsPackages("EventDate"),vbLongTime),3)%><br />
                <br />
                <B><%=rsVenueDetail("Venue")%></B><br />
                
                <%
                If rsVenueDetail("Address_1") <> "" Then
                %>
                <%=rsVenueDetail("Address_1")%><br />
                <%
                End If
                
                If rsVenueDetail("Address_2") <> "" Then
                %>
                <%=rsVenueDetail("Address_2")%><br />
                <%
                End If
                
                If rsVenueDetail("City") <> "" AND rsVenueDetail("State") <> "" Then
                %>
                <%=rsVenueDetail("City")%>, <%=rsVenueDetail("State") %>&nbsp;<%=rsVenueDetail("Zip_Code")%><br />
                <%
                End If
                %>
                <br />
                <center>
                <table border="0" cellpadding="0" cellspacing="10">
                <tr>    
                    <td ALIGN="center"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><B><U>Ticket Type</U></B></FONT></td>
                    <td ALIGN="center"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><B><U>Price</U></B></FONT></td>
                    <td ALIGN="center"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><B><U>Ticket Quantity</U></B></FONT></td>
                </tr>
                <tr>
                    <td ALIGN="center"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><%=OfferName%></FONT></td>
                    <td ALIGN="center"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><%=FormatCurrency(OfferPackPrice,2)%></FONT></td>                        
                    <td ALIGN="center"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">     
                        <select name="Quantity">
    		            <option value="0">-- Choose Quantity --</option>
                        <%
                        
                        For j = 1 to OfferFamilyCount
                            j2 = (j * 4)
                            
                            
                            ErrorLog("j: " & j & "")  
                              ErrorLog("j2: " & j2 & "")  
                            
                            
                            Select Case OfferFamilyCount
                                Case 1   
                                %><option value="<%=j2%>"> <%=j%>&nbsp;&nbsp;family pack</option><%
                                Case Else
                                %><option value="<%=j2%>"> <%=j%>&nbsp;&nbsp;family packs</option><%
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
                     <INPUT TYPE="hidden" NAME="Quantity" VALUE="<%=OfferTicketCount%>">
                    </td>
                </tr>    
               </table> 
               </center>             
            </td>
        </tr>
<%

rsVenueDetail.Close
Set rsVenueDetail = Nothing 

rsPackages.Close
Set rsPackages = Nothing   
    
Next 

%>
    <tr>
        <td align=center>
        <INPUT type="submit" value="Add To Cart" /></form>
        <br /><br />
        <form action="<%= SurveyFileName %>" method="post">
        <INPUT TYPE="hidden" NAME="FormName" VALUE="Continue">
        <input type="submit" value="No Thanks!" /></form>
        </td>
   </tr>
</table>

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

'=======================================

Sub Continue
    Session("SurveyComplete") = Session("OrderNumber")
    If Session("UserNumber") = "" Then
	    Response.Redirect("/Ship.asp")
    Else
	    Response.Redirect("/Management/AdvanceShip.asp")
    End If
    
End Sub 'Continue

'=======================================

%>



