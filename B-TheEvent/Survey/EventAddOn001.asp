
<%

'CHANGE LOG
'SSR - 6/27/2012 - created event add-on

%>

<!--#INCLUDE virtual=/PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=/GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=/DBOpenInclude.asp -->

<%

'===============================================

Page = "Survey"
SurveyNumber = 1295
SurveyFileName = "EventAddOn.asp"

'===============================================

'B The Event
'Event Add On

'Patron purchases event #491193 the system prompts the patron to buy single ticket from event #491709.
'Text: “Would you like to puchase an additional guest ticket for $225.00?

'Event codes:
'491193   Thursday 11/8/2012 8:00 PM   B...the event 
'491709   Thursday 11/8/2012 8:00 PM   B...the event- Additional Guest 

'SeatType codes:
'7020 The Asheville Experience (Brides)
'7021 The Asheville Inspiration (Vendors)	

'===============================================

Dim RequiredEventCode(1)
RequiredEventCode(1)= 491193 

Dim RequiredSeatCode(2)
RequiredSeatCode(1) = "7020" 
RequiredSeatCode(2) = "7021" 

Dim OfferEventCode(1)
OfferEventCode(1)= 491709

OfferSectionCode="GA"

'===============================================


If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If

'===============================================


If Clean(Request("FormName")) = "EventOffer" Then

	Call AddToCart(CleanNumeric(Request("EventCode")), Clean(Request("SectionCode")), Clean(Request("SeatTypeCode")),CleanNumeric(Request("OfferQuantity")))

ElseIf Clean(Request("FormName")) = "Continue" Then

    Call Continue

Else
    Call AddOnSurvey

End If

'===============================================

Sub AddOnSurvey

'Determine the number of required tickets on the required event
'Determine if any offer tickets are already in the shopping cart.
'If no required tickets - end function

RequiredTicketCount = 0

For i = 1 To UBound(RequiredEventCode)

    For j = 1 to UBound(RequiredSeatCode)

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

If RequiredTicketCount <> 0 Then
    Call CheckOffer(RequiredTicketCount)
Else
    Call Continue
End If

End Sub 'AddOnSurvey

'=======================================

Sub CheckOffer(RequiredTicketCount)

'Verify that the offer event has enough available seats
'If there are limited number of tickets, offer those
'If there are no tickets avail end function

OfferSoldCount = 0
OfferTicketCount = 0

For k = 1 To UBound(OfferEventCode)

        'Determine number of offer events already in shopping cart
        SQLOfferSold = "SELECT COUNT(OrderLine.ItemNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Seat.EventCode = " & OfferEventCode(k) & ""
        Set rsOfferSold = OBJdbConnection.Execute(SQLOfferSold)	
        	
        If Not rsOfferSold.EOF Then	    
             OfferSoldCount =  (OfferSoldCount + rsOfferSold("TicketCount"))
        End If
        
        rsOfferSold.Close
        Set rsOfferSold = nothing
    
Next
    

For l = 1 To UBound(OfferEventCode)
    
    SQLOfferCheck = "SELECT COUNT(Seat.ItemNumber) AS AvailCount FROM Seat (NOLOCK) INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Event.EventCode = " & OfferEventCode(l) & " AND Seat.SectionCode IN ('" & OfferSectionCode & "') AND Seat.StatusCode = 'A'"
    Set rsOfferCheck = OBJdbConnection.Execute(SQLOfferCheck)
    
    If Not rsOfferCheck.EOF Then	   

        If RequiredTicketCount > rsOfferCheck("AvailCount") Then
            OfferTicketCount = rsOfferCheck("AvailCount")
        Else
            OfferTicketCount = RequiredTicketCount
        End If

    End If

    rsOfferCheck.Close
    Set rsOfferCheck = nothing

Next


If OfferSoldCount = 0 Then 'Offer ticket not in shopping cart

    If OfferTicketCount <> 0 Then 'Offer tickets not sold out
        Call DisplayOfferEvent(OfferTicketCount)
    Else
        Call Continue
    End If

Else
    Call Continue
End If


End Sub 'CheckOffer

'=======================================

Sub DisplayOfferEvent(OfferTicketCount)

If Session("UserNumber")<> "" Then
    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "#FFFFFF"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "#000000"
    TableDataBGColor = "#E9E9E9"
End If

%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>

<head>

<title>="<%= Title %>"</title>

<link href='http://fonts.googleapis.com/css?family=Droid+Sans:400,700' rel='stylesheet' type='text/css'>

<style type="text/css">
* 
{
margin: 0; 
padding: 0;
}
body 
{
background: #ededed;
}
 
.pricingtable 
{

    
width: 600px; 
height: 550px;

padding: 0px;
margin: 50px;

background: <%=TableDataBGColor%>;
color: <%=TableDataFontColor%>;
 
-webkit-border-radius: 10px;
-moz-border-radius: 10px;
border-radius: 10px;
-webkit-box-shadow: 2px 2px 9px rgba(0,0,0,0.3);
-moz-box-shadow: 2px 2px 9px rgba(0,0,0,0.3);
box-shadow: 2px 2px 9px rgba(0,0,0,0.3);
}

.category 
{
width: 600px; 
height: 50px;
background: <%=TableCategoryBGColor%>;
-webkit-border-radius: 10px 10px 0 0;
-moz-border-radius: 10px 10px 0 0;
border-radius: 10px 10px 0 0;
}

.category h2 
{
color: <%=TableCategoryFontColor%>;
text-align: center;
font: 300 25px/50px Helvetica, Verdana, sans-serif;
}

</style>

</head>

<%=strBody %>

<!--#INCLUDE virtual="TopNavInclude.asp"-->
<div class="pricingtable ">

<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey">
<INPUT TYPE="hidden" NAME="FormName" VALUE="EventOffer">

<div class="category">
    <h2>Special Offer</h2>
</div>

<div style="padding: 10px; font-size: medium">
<b>Would you like to puchase an additional guest ticket for $225.00?</b>
</div>

<%
  	
For m = 1 To UBound(RequiredEventCode)
    	
'Offer Act and Date
SQLPackages = "SELECT Event.EventCode, Event.EventDate, Event.Comments AS EventComments, Act.Act, Act.Comments AS ActComments FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode WHERE Event.EventCode = " & OfferEventCode(m) & " "
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
            <div style="padding: 10px;">
                <B><%=rsPackages("Act")%></B><br /><br />
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
             </div>
                <center>
                <table border="0" cellpadding="10" cellspacing="10" width="90%">
                <tr>    
                    <td ALIGN="center"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><B><U>Ticket Type</U></B></FONT></td>
                    <td ALIGN="center"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><B><U>Price</U></B></FONT></td>
                    <td ALIGN="center"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><B><U>Ticket Quantity</U></B></FONT></td>
                </tr>
                <tr>
                    <td ALIGN="center"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><%=OfferSeatType%></FONT></td>
                    <td ALIGN="center"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><%=FormatCurrency(OfferPrice,2)%></FONT></td>                        
                    <td ALIGN="center"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">     
                        <select name="Quantity">
    		            <option value="0">-- Choose Quantity --</option>
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
                     <INPUT TYPE="hidden" NAME="OfferQuantity" VALUE="<%=OfferTicketCount%>">
                    </td>
                </tr>    
               </table> 
               </center>             
<%

rsVenueDetail.Close
Set rsVenueDetail = Nothing 

rsPackages.Close
Set rsPackages = Nothing   
    
Next 

%>
<br /><br />
<INPUT type="submit" value="Add To Cart" /></form>
<br /><br />
<form action="<%= SurveyFileName %>" method="post">
<INPUT TYPE="hidden" NAME="FormName" VALUE="Continue">
<input type="submit" value="No Thanks!" /></form>

</div>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%
    
End Sub 'DisplayOfferEvent

'=======================================

Sub AddToCart(EventCode, SectionCode, SeatTypeCode, OfferQuantity)

ErrorLog("EventCode " & EventCode & "")
ErrorLog("SectionCode " & SectionCode & "")
ErrorLog("SeatTypeCode " & SeatTypeCode & "")
ErrorLog("OfferQuantity " & OfferQuantity & "")


If Clean(OfferQuantity) = 0 Then
    Call Continue
End If


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
				SQLPrice = "SELECT Price, Surcharge, PhoneOrderSurcharge, FaxOrderSurcharge, MailOrderSurcharge, BoxOfficeSurcharge FROM Price (NOLOCK) WHERE EventCode = " & EventCode & " AND SectionCode = '" & SectionCode & "' AND SeatTypeCode = " & Clean(Request("SeatTypeCode"))
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

'========================================

Sub Continue

Response.Redirect("/GenericSurvey.asp?SurveyNo=1297")

End Sub 'Continue

'========================================	

%>

