<%

'CHANGE LOG
'SSR - 7/22/2013 - created event add-on

'SSR - 7/24/2013 - added 6 more events

'SSR - 7/24/2013 - added ticket price back on offer page

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->

<%

'---------------------------------------------

Page = "Survey"
SurveyFileName = "EventAddOnDiscount.asp"

'===============================================

'Sunset Center
'Event Add On 

'Purchase 1 (or more) tickets to the required event
'Offer to buy 1 (or more) tickets to the offer event

'Offer tickets offered to patron is equal to the number of required tickets

'Offer event will only be listed if there are available tickets

'Offer event is GA seating

'No discount on offere tickets

'===============================================

OfferSection =  "GA"

RequiredCount = 1

Dim RequiredEvent(1)
Dim OfferEvent(1)

RequiredEvent(1) = 632602	'Required Event
OfferEvent(1) = 479444		


RequiredSectionColor = "GOLD"

'---------------------------------------------

'CSS Variables

If Session("UserNumber")<> "" Then
    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "#FFFFFF"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "#000000"
    TableDataBGColor = "#E9E9E9"
End If

'---------------------------------------------

'Page Type Variables

If Session("OrderNumber") = "" Then

	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
    Else
		Response.Redirect("/Management/Default.asp")
	End If
	
Else

	If Session("UserNumber") = "" Then
        Page = "Survey"
	Else
	    Page = "Management"
	End If
	
End If

'---------------------------------------------


Select Case Clean(Request("FormName"))
    Case "EventOffer"
	
		'ErrorLog("EventCode "&(Request("EventCode"))&"")
		'ErrorLog("SectionCode "&(Request("SectionCode"))&"")
		'ErrorLog("SeatTypeCode "&(Request("SeatTypeCode"))&"")
		'ErrorLog("OfferQuantity "&(Request("OfferQuantity"))&"")
		
        Call AddToCart(CleanNumeric(Request("EventCode")), Clean(Request("SectionCode")), Clean(Request("SeatTypeCode")),CleanNumeric(Request("OfferQuantity")))
		
	Case "Continue"
		Call Continue
    Case Else
        Call AddOnSurvey
 End Select




'---------------------------------------------

Sub AddOnSurvey

'Determine if required event is in the shopping cart    
  

For i = 1 To UBound(RequiredEvent)
  
    SQLRequiredTicketCount = "SELECT Count(LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Event.EventCode = " & RequiredEvent(i) & " AND Seat.SectionCode IN (" & getSectionCodes(RequiredSectionColor,RequiredEvent(i))  & ")"
    Set rsRequiredTicketCount = OBJdbConnection.Execute(SQLRequiredTicketCount)

    RequiredTicketCount = rsRequiredTicketCount("TicketCount")

    If RequiredTicketCount => 1 Then
    
        SQLOfferTicketCount = "SELECT Count(ItemNumber) AS TicketCount FROM Seat (NOLOCK) WHERE Seat.EventCode = " & OfferEvent(i) & " AND Seat.SectionCode = 'GA' AND Seat.StatusCode = 'A'"
        Set rsOfferTicketCount = OBJdbConnection.Execute(SQLOfferTicketCount)
        OfferTicketCount = rsOfferTicketCount("TicketCount")
        
        If OfferTicketCount => 1 Then  
    
            OfferCount = OfferCount + rsOfferTicketCount("TicketCount")
            
        End If
        
	    rsOfferTicketCount.Close
	    Set rsOfferTicketCount = nothing
	    
	End If
	
	rsRequiredTicketCount.Close
    Set rsRequiredTicketCount = nothing
	
Next   

ErrorLog("OfferCount: " & Offercount & "")

    If OfferCount = 0 Then
        Call Continue 
        Exit Sub   
    Else
        Call OfferEventList
    End If
    
  

End Sub

'---------------------------------------------

Sub OfferEventList

%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
	<title>Survey Page</title>
	<link href='http://fonts.googleapis.com/css?family=Droid+Sans:400,700' rel='stylesheet' type='text/css'>
	<style type="text/css"> body {line-height:1 em} .rounded-corner{font-family:"Droid Sans",Sans-Serif;font-size:12px;font-weight:400;text-align:left;border-collapse:collapse;} .rounded-corner thead th.category{padding-top:20px;padding-bottom:20px;padding-left:20px;padding-right:20px;font-size:20px;font-weight:700;color:<%=TableCategoryFontColor%>;background:<%=TableCategoryBGColor%>} .rounded-corner thead th.category-left{background:<%=TableCategoryBGColor%>;text-align:right}#rounded-corner thead th.category-right{background:<%=TableCategoryBGColor%>;text-align:left} .rounded-corner td.footer{background:<%=TableDataBGColor%>}#rounded-corner td.footer-left{background:<%=TableDataBGColor%>} .rounded-corner td.footer-right{background:<%=TableDataBGColor%>} .rounded-corner td.data{padding-top:10px;padding-bottom:10px;padding-left:10px;padding-right:10px;font-weight:400;text-align:center;color:<%=TableDataFontColor%>;background:<%=TableDataBGColor%>} .rounded-corner td.data-left{padding-top:3px;padding-bottom:3px;padding-left:10px;padding-right:10px;text-align:left;color:<%=TableDataFontColor%>;background:<%=TableDataBGColor%>} .rounded-corner span{font-size:16px;font-weight:400;text-align:center;color:<%=TableDataFontColor%>} div#frm *{display:inline; } table.rounded-corner  + table.rounded-corner {margin-top: 50px;} </style>
	</head>
	<body>
	<!--#INCLUDE virtual="TopNavInclude.asp"-->

	<FORM action="<%= SurveyFileName %>" method="post">
	<INPUT TYPE="hidden" NAME="FormName" VALUE="EventOffer">
	
	<br />
	<br />

<%

	For i = 1 To UBound(RequiredEvent)
	
    'Required Event ticket count
	SQLRequiredCheck = "SELECT Count(LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Event.EventCode = " & RequiredEvent(i) & " AND Seat.SectionCode IN (" & getSectionCodes(RequiredSectionColor,RequiredEvent(i))  & ")"
    Set rsRequiredCheck = OBJdbConnection.Execute(SQLRequiredCheck)
	
	If rsRequiredCheck("TicketCount") > 0 Then
	
		'Verify that offer event has available seats
	    SQLOfferCheck = "SELECT COUNT(Seat.ItemNumber) AS AvailCount FROM Seat (NOLOCK) INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Event.EventCode = " & OfferEvent(i) & " AND Seat.SectionCode IN ('" & OfferSection & "') AND Seat.StatusCode = 'A'"
        Set rsOfferCheck = OBJdbConnection.Execute(SQLOfferCheck)
        
        'Verify that there are enough offer event tickets to match required event tickets
        If  rsRequiredCheck("TicketCount") > rsOfferCheck("AvailCount") Then
            OfferTicketCount = rsOfferCheck("AvailCount") 
        Else
            OfferTicketCount = rsRequiredCheck("TicketCount")
        End If
    	
        'Offer Act and Date
        SQLPackages = "SELECT Event.EventCode, Event.EventDate, Event.Comments AS EventComments, Act.Act, Act.Producer, Act.Comments AS ActComments FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode WHERE Event.EventCode = " & OfferEvent(i) & " "
        Set rsPackages = OBJdbConnection.Execute(SQLPackages) 
        
        SQLVenueDetail = "Select Venue.Venue, Venue.Address_1, Venue.Address_2, Venue.City, Venue.State, Venue.Zip_Code FROM Venue (NOLOCK) INNER JOIN Event (NOLOCK) ON Venue.VenueCode = Event.VenueCode WHERE EventCode = " & rsPackages("EventCode") & " "
        Set rsVenueDetail = OBJdbConnection.Execute(SQLVenueDetail)              
 
%>    
        <table class="rounded-corner" BORDER="0">
        <thead>
            <tr>
                <th scope="col" class="category"><%=rsPackages("Producer")%></th>
            </tr>        
        </thead>
        <tbody>
            <tr>
                <td class="data" colspan="4">
                    <span class="large""><%=rsPackages("Act")%></span><br />
					<br />
                    <%=rsPackages("ActComments")%><br />
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
					<b><%=FormatDateTime(rsPackages("EventDate"),vbLongDate)%></b> at
                    <b><%=Left(FormatDateTime(rsPackages("EventDate"),vbLongTime),Len(FormatDateTime(rsPackages("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsPackages("EventDate"),vbLongTime),3)%></b><br />
					<br />
                    <center>
					
                    <table border="0" id="rounded-corner" WIDTH="50%"> 
						<thead>
                        <tr>
                            <th class="data-left" WIDTH="50%">
                                <B>&nbsp;Ticket Quantity</B>
                            </th>
                            <th class="data-left" WIDTH="50%">
                                <B>&nbsp;Ticket Price</B>
                           </th>
                        </tr> 
						</thead>
						<tbody>						
                        <tr>							
							<td class="data-left">
								<INPUT TYPE="hidden" NAME="SectionCode" VALUE="GA">
								<select name="OfferQuantity">
									<option value="0">--- Select Ticket Quantity ---</option> 
									<%
									For j = 0 to OfferTicketCount
										Select Case j
											Case 1   
											%><option value="<%=j%>"><%=j%>&nbsp;&nbsp;ticket</option><%
											Case Else
											%><option value="<%=j%>"><%=j%>&nbsp;&nbsp;tickets</option><%
										End Select                   
									Next
									%>
								</select>
							</td>
                            <td class="data-left">    
							<INPUT TYPE="hidden" NAME="EventCode" VALUE="<%=rsPackages("EventCode")%>">  							
                                <%
 
								SQLSeatTypeCount = "SELECT  Count(SeatType.SeatType) as SeatTypeCount FROM Price (NOLOCK) INNER JOIN SeatType (NOLOCK) ON Price.SeatTypeCode = SeatType.SeatTypeCode WHERE Price.EventCode = " & rsPackages("EventCode") & " AND SectionCode = '" & OfferSection & "'"
								Set rsSeatTypeCount = OBJdbConnection.Execute(SQLSeatTypeCount) 
                                
									If TicketTypeCount > 1 Then
									
										%>
										<select name="SeatTypeCode">
										<option value="0" selected>--- Select Ticket Type ---</option>  
										
										<%
									
											SQLSeatType = "SELECT SeatType.SeatType, Price.SeatTypeCode, Price.Price, Price.PhoneOrderSurcharge, Price.FaxOrderSurcharge, Price.MailOrderSurcharge, Price.BoxOfficeSurcharge, Price.Surcharge FROM Price (NOLOCK) INNER JOIN SeatType (NOLOCK) ON Price.SeatTypeCode = SeatType.SeatTypeCode WHERE Price.EventCode = " & rsPackages("EventCode") & " AND SectionCode = '" & OfferSection & "' ORDER BY Price.Price"
											Set rsSeatType = OBJdbConnection.Execute(SQLSeatType) 
										
												If Not rsSeatType.EOF Then
												
													Do While Not rsSeatType.EOF
													
														TicketPrice = FormatCurrency(rsSeatType("Price"),2)   
														
														Select Case Session("OrderTypeNumber")
															Case 1
															Surcharge = rsSeatType("Surcharge")
															Case 2
															Surcharge = rsSeatType("PhoneOrderSurcharge")
															Case 3
															Surcharge = rsSeatType("FaxOrderSurcharge")
															Case 4
															Surcharge = rsSeatType("MailOrderSurcharge")
															Case 7
															Surcharge = rsSeatType("BoxOfficeSurcharge")
															Case Else
															Surcharge = 0
														End Select
													
														If Surcharge > 0 Then
															TicketSurcharge = "(+" & FormatCurrency(Surcharge,2) & "&nbsp;Fee)"
														Else
															TicketSurcharge = ""
														End If
																   
														%>   							  
														<option value="<%=rsSeatType("SeatTypeCode")%>"><%=rsSeatType("SeatType")%>&nbsp;&nbsp;<%=TicketPrice%>&nbsp;&nbsp;<%=TicketSurcharge%></option>
														<%
													
													rsSeatType.movenext
													Loop
													
												End If
											
											rsSeatType.Close
											Set rsSeatType = Nothing 

										%> 
										</select>
										<%										

									Else
								
										SQLSeatType = "SELECT SeatType.SeatType, Price.SeatTypeCode, Price.Price, Price.PhoneOrderSurcharge, Price.FaxOrderSurcharge, Price.MailOrderSurcharge, Price.BoxOfficeSurcharge, Price.Surcharge FROM Price (NOLOCK) INNER JOIN SeatType (NOLOCK) ON Price.SeatTypeCode = SeatType.SeatTypeCode WHERE Price.EventCode = " & rsPackages("EventCode") & " AND SectionCode = '" & OfferSection & "'"
										Set rsSeatType = OBJdbConnection.Execute(SQLSeatType) 
									
											If Not rsSeatType.EOF Then
																						
												TicketPrice = FormatCurrency(rsSeatType("Price"),2)   
												
												Select Case Session("OrderTypeNumber")
													Case 1
													Surcharge = rsSeatType("Surcharge")
													Case 2
													Surcharge = rsSeatType("PhoneOrderSurcharge")
													Case 3
													Surcharge = rsSeatType("FaxOrderSurcharge")
													Case 4
													Surcharge = rsSeatType("MailOrderSurcharge")
													Case 7
													Surcharge = rsSeatType("BoxOfficeSurcharge")
													Case Else
													Surcharge = 0
												End Select
											
												If Surcharge > 0 Then
													TicketSurcharge = "(+" & FormatCurrency(Surcharge,2) & "&nbsp;Fee)"
												Else
													TicketSurcharge = ""
												End If
														   
												%>   
												<div style="border-top: 1px solid #ABADB3; background-color: #ffffff; padding-left: 5px;">
													<%=rsSeatType("SeatType")%>&nbsp;&nbsp;<%=TicketPrice%>&nbsp;&nbsp;<%=TicketSurcharge%>
												</div>
												<INPUT TYPE="hidden" NAME="SeatTypeCode" VALUE="<%=rsSeatType("SeatTypeCode")%>">  
												<%
																							
											End If
										
										rsSeatType.Close
										Set rsSeatType = Nothing  
										
									End If
								
								
                                %>    
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
    
    End If 
    
    rsRequiredCheck.Close
	Set rsRequiredCheck = nothing
	
	OptionCount = OptionCount 
    
    Next 

%>

				<tr>
					<td align="center">
					<br><br>
						<div id="frm">
						 <INPUT type="submit" value="Add To Cart" /></form>
						
						<form action="<%= SurveyFileName %>" method="post">
						<INPUT TYPE="hidden" NAME="FormName" VALUE="Continue">
						<input type="submit" value="No Thanks!" /></form>
						</div>

					</td>
				</tr>
			</tbody>
		</table>
		
	</form>
	
	</center>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%
    
End Sub 'DisplayOfferEvent


'---------------------------------------------

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
		'ErrorLog(Message)
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
		
			SeatType = Request("SeatTypeCode")
			DiscountNumber = 87392
			ReqEventCode = 573141
			OfferFree = 1

			'Determine if Required Event had discounted tickets
			SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = "&Session("OrderNumber")&" AND OrderLine.DiscountTypeNumber = "&DiscountNumber&""
			Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
			nbrTickets = rsDiscCount("LineCount")
			rsDiscCount.Close
			Set rsDiscCount = nothing
			
			'ErrorLog("nbrTickets Discounted: "&nbrTickets&" ")
	    
		
			For i = 1 To OfferQuantity

				'REE 6/21/5 - Added Seat Type Code to OrderLines.
				SQLPrice = "SELECT Price, PhoneOrderSurcharge, FaxOrderSurcharge, MailOrderSurcharge, BoxOfficeSurcharge, Surcharge FROM Price (NOLOCK) WHERE EventCode = " & EventCode & " AND SectionCode = '" & SectionCode & "' AND SeatTypeCode = " & Clean(Request("SeatTypeCode"))
				Set rsPrice = OBJdbConnection.Execute(SQLPrice)
				
					If NbrTickets > 0 Then 

						'Count the number of existing Offer seats which have had discount applied.
						SQLDiscCount = "SELECT COUNT(OrderLine.LineNumber) AS LineCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber AND OrderLine.ItemType = 'Seat' INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = "&Session("OrderNumber")&" AND Event.EventCode = " & EventCode & " AND OrderLine.DiscountTypeNumber = "&DiscountNumber&" "
						Set rsDiscCount = OBJdbConnection.Execute(SQLDiscCount)
							If Fix(rsDiscCount("LineCount")) < (Fix(NbrTickets) * OfferFree)  Then 'Apply the discount
								Price = rsPrice("Price")
								DiscountAmount = rsPrice("Price")	
								DiscountNumber = 87392
							Else
								Price = rsPrice("Price")
								DiscountAmount =  0
								DiscountNumber = 0
							End If
						rsDiscCount.Close
						Set rsDiscCount = nothing
						
					End If
										
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

				'ErrorLog("Price: "&Price&" ")				
				'ErrorLog("DiscountAmount: "&DiscountAmount&" ")
				'ErrorLog("DiscountNumber: "&DiscountNumber&" ")	
				ErrorLog("Surcharge: "&Session("OrderTypeNumber")&" ")	
				ErrorLog("Surcharge: "&Surcharge&" ")				
				
				
				'REE 11/29/6 - Modified for subscriptions.  Update Seat and SubFixedEvent lines only.
				SQLUpdateSeatType = "UPDATE OrderLine WITH (ROWLOCK) SET SeatTypeCode = "& SeatType &", Price = " & Price & ", Surcharge = " & Surcharge & ", DiscountTypeNumber = " & DiscountNumber & ", Discount =  " & DiscountAmount & " WHERE OrderNumber = " & Session("OrderNumber") & " AND ItemNumber IN (SELECT TOP 1 ItemNumber FROM OrderLine (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND SeatTypeCode IS NULL AND ItemType IN ('Seat', 'SubFixedEvent') ORDER BY LineNumber DESC)"
				Set rsUpdateSeatType = OBJdbConnection.Execute(SQLUpdateSeatType)
				
			Next				

			Call DBClose(OBJdbConnection)
			
			Call Continue
			
		Case Else
		
			Call AddOnSurvey
			
	End Select
End If

End Sub

'---------------------------------------------

Sub Continue
				
Session("SurveyComplete") = Session("OrderNumber")
If Session("UserNumber") = "" Then
	Response.Redirect("/Ship.asp")
Else
	Response.Redirect("/Management/AdvanceShip.asp")
End If		

End Sub 'Continue

'---------------------------------------------

Function getSectionCodes(strColor,strEventCode)

dim SectionList

SQLSectionCode = "SELECT SectionCode FROM Section (NOLOCK) WHERE Section.EventCode = " & strEventCode & " and Section.Color =  '"& strColor &"' "
Set rsSectionCode = OBJdbConnection.Execute(SQLSectionCode) 

	If Not rsSectionCode.EOF Then

		Do Until rsSectionCode.EOF

			SectionList = SectionList & "'"&rsSectionCode("SectionCode")&"',"
								
		rsSectionCode.movenext
		Loop

	End If

rsSectionCode.Close
Set rsSectionCode = Nothing 

 If Len(SectionList) > 0 Then
	SectionList = Left(SectionList, Len(SectionList)- 1)
 End If

getSectionCodes = SectionList 

End Function

'---------------------------------------------



%>

