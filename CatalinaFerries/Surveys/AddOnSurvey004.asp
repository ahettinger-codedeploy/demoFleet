<%

'CHANGE LOG - Inception
'SSR Wednesday, July 06, 2011
'Custom Code 

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'========================================

Page = "Survey"
SurveyNumber = 1059
SurveyFileName = "AddOnSurvey.asp"

'========================================

'Music Worchester - Audience Survey
'Survey 2 of 4

'===============================================

'CSS Survey Variables

If Session("UserNumber")<> "" Then
    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "FFFFFF"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "000000"
    TableDataBGColor = "E9E9E9"
    'LastHex = box color
    'FirstHex = background color
    NECorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=008400&Src=TopLeftCorner16.txt"
    NWCorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=008400&Src=TopRightCorner16.txt"
    SWCorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=E9E9E9&Src=BottomLeftCorner16.txt"
    SECorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=E9E9E9&Src=BottomRightCorner16.txt"
Else
    'LastHex = box color
    'FirstHex = background color
    NECorner="/clients/tix/images/image.asp?FirstHex=efebe3&LastHex=565f68&Src=TopLeftCorner16.txt"
    NWCorner="/clients/tix/images/image.asp?FirstHex=efebe3&LastHex=565f68&Src=TopRightCorner16.txt"
    SWCorner="/clients/tix/images/image.asp?FirstHex=f3f1ed&LastHex=ded6c8&Src=BottomLeftCorner16.txt"
    SECorner="/clients/tix/images/image.asp?FirstHex=f3f1ed&LastHex=ded6c8&Src=BottomRightCorner16.txt"
End If

'============================================================
 
'Check to see if Order Number exists.
'Display management tabs for box office orders

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

'============================================================

'Request the form name and process requested action

If Clean(Request("FormName")) = "EventOffer" Then
	Call AddTickets
ElseIf Clean(Request("FormName")) = "Continue" Then
    Call PartTwo(Message)
ElseIf Clean(Request("FormName")) = "UpdateSurvey" Then
    Call UpdateSurvey
Else
    Call AddOnSurvey(Message)
End If

'==========================================================

Sub AddOnSurvey(Message)

If DocType <> "" Then
	Response.Write DocType
Else
	Response.Write "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
End If

%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<html>
<head>

<title>TIX.com</title>

<style type="text/css">
body
{
    font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
    line-height: 1 em;
}
#rounded-corner
{
	font-size: 11px;
    font-weight: 400;
	width: 80%;
	text-align: left;
	border-collapse: collapse;
}
#rounded-corner thead th.category
{
	padding-top: 10px;
    padding-bottom: 10px;
    padding-left: 0px;
    padding-right: 1px;
	font-size: 15px;
	font-weight: 600;
	text-align: center;
	color: <%=TableCategoryFontColor%>;
	background: <%=TableCategoryBGColor%>;
}
#rounded-corner thead th.category-left
{
	background: <%=TableCategoryBGColor%> url('<%=NECorner%>') left -1px no-repeat;
	text-align: right;
}
#rounded-corner thead th.category-right
{
	background: <%=TableCategoryBGColor%> url('<%=NWCorner%>') right -1px no-repeat;
    text-align: left;
}
#rounded-corner td.footer
{
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.footer-left
{
    background: <%=TableDataBGColor%> url('<%=SWCorner%>') left bottom no-repeat;
}
#rounded-corner td.footer-right
{
	background: <%=TableDataBGColor%> url('<%=SECorner%>') right bottom no-repeat;
}
#rounded-corner td.data
{
	padding-left: 25px;
	padding-right: 25px;
	padding-top: 15px;
	padding-bottom: 15px;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-left
{
	padding-left: 10px;
	padding-right: 10px;
	padding-top: 5px;
	padding-bottom: 5px;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-right
{
	padding-left: 25px;
	padding-right: 25px;
	padding-top: 15px;
	padding-bottom: 15px;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
</style>
<script language="javascript">
<% If Message <> "" Then %>
alert('<%=Message%>');
<% End If %>
</script>
</head>

<%=strBody %>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<form action="<%= SurveyFileName %>" name="Survey" method="post">
<INPUT TYPE="hidden" NAME="FormName" VALUE="EventOffer">

<table id="rounded-corner" summary="surveypage">
<thead>
    <tr>
        <th scope="col" class="category-left">&nbsp;</th>
        <th scope="col" class="category" colspan="2"><b>Brief Audience Survey</b></th>
        <th scope="col" class="category-right">&nbsp;</th>
    </tr>        
</thead>

<%
    EventCodeList = ""
    SQLReqAct = "SELECT Event.ActCode, Event.EventDate, COUNT(*) AS TotalTix FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') AND Event.ActCode IN (66492,66503) GROUP BY Event.ActCode, Event.EventDate"
    Set rsReqAct = OBJdbConnection.Execute(SQLReqAct)
    Do While Not rsReqAct.EOF
        If rsReqAct("ActCode") = "66492" Then
            AddOnActCode = "67121"
        Else
            AddOnActCode = "67120"
        End If
        
        SQLEventAddOn = "SELECT EventCode FROM Event (NOLOCK) WHERE ActCode = " & AddOnActCode & " AND EventDate = '" & rsReqAct("EventDate") & "'"
        Set rsEventAddOn = OBJdbConnection.Execute(SQLEventAddOn)
        If Not rsEventAddOn.EOF Then 'Collect All Add-On Events
            Response.Write "<input type=""hidden"" name=""Qty_" & rsEventAddOn("EventCode") & """ value=""" & rsReqAct("TotalTix") & """>" & vbCrLf
            EventCodeList = EventCodeList & rsEventAddOn("EventCode") & ","
        End If
        rsEventAddOn.Close
        Set rsEventAddOn = Nothing
        
        rsReqAct.MoveNext
    Loop
    rsReqAct.Close
    Set rsReqAct = Nothing
    
    EventCodeList = Left(EventCodeList, Len(EventCodeList) - 1)
    EventCodeNum = "-1"
    'Show Package Info
    SQLPackages = "SELECT Event.EventCode, Event.EventDate, Event.Comments AS EventComments, Act.Act, Act.Comments AS ActComments, SeatType.SeatTypeCode, SeatType.SeatType, Price.Price, Price.SectionCode FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Price (NOLOCK) ON Event.EventCode = Price.EventCode INNER JOIN SeatType (NOLOCK) ON Price.SeatTypeCode = SeatType.SeatTypeCode WHERE Event.EventCode IN(" & EventCodeList & ") AND Price.EventCode IN(" & EventCodeList & ") ORDER BY Event.EventDate, Price.SeatTypeCode"
    Set rsPackages = OBJdbConnection.Execute(SQLPackages)
    Do While Not rsPackages.EOF
       
%>

    <tr align="left" >
        <td class="data-left" colspan="2">
<% If rsPackages("SectionCode") = "ADDL" Then %>
    <% If rsPackages("SeatTypeCode") = "5613" Then 'display add-on tickets' description only once for the first tickettype %>
        <H3>Add-On Tickets</H3>
        Would you like to add any of the following to your purchase?<br /><font size="1">**A ticket is required for all infants 2 and under.  Nothing to add?  Click on "not at this time" at the bottom of this page.</font><br />
    <% End If %>
<% Else %>
        <H3><%=rsPackages("Act")%></H3>
        <b>Upgrade your seats to the Admiral's Lounge!</b><br />Travel back to the mainland in style in the VIP Admiral's Lounge. Includes complimentary drink & snack, priority boarding, and private, reserved indoor seating on the top deck with 360° views. Only $15 per person (each way) in addition to base fair. Enjoy a beer or cocktail as you relax on your way back home.<br /><font size="1">**You'll need one Admiral's Lounge upgrade for each ticket you'd like to upgrade. Don't want to upgrade? Click on "not at this time" at the bottom of this page.</font><br />
<% End If %>
        <br /><b>Event Date: <%=rsPackages("EventDate")%> - <%=rsPackages("SeatType")%> - Price: <%=FormatCurrency(rsPackages("Price"),2)%></b><br />
        <INPUT TYPE="hidden" NAME="EventSeatTypeCode" VALUE="<%=rsPackages("EventCode") & "_" & rsPackages("SeatTypeCode")%>">
        <INPUT TYPE="hidden" NAME="EventCode" VALUE="<%=rsPackages("EventCode")%>">
        <INPUT TYPE="hidden" NAME="SectionCode" VALUE="<%=rsPackages("SectionCode")%>">
        <INPUT TYPE="hidden" NAME="SeatTypeCode" VALUE="<%=rsPackages("SeatTypeCode")%>">
        Enter Quantity: <INPUT TYPE="text" NAME="Quantity" maxlength="3" size="3" />
        </td>
    </tr>

<%
            If EventCodeNum <> rsPackages("EventCode") Then
                EventCodeNum = rsPackages("EventCode")    
            End If    
        rsPackages.MoveNext
        If Not rsPackages.EOF Then
            If EventCodeNum <> rsPackages("EventCode") Then
%>
        <tr><td>&nbsp;</td></tr>
<%   
            End If
        End If
    Loop
    rsPackages.Close
    Set rsPackages = Nothing
%>

<tr><td align="center"><INPUT type="submit" value="Add to Cart" /></td></tr>
</TABLE>
</FORM>

<table>
    <tr><td align="center">
        <FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey">
        <INPUT TYPE="hidden" NAME="FormName" VALUE="Continue">
        <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><INPUT type="submit" value="Not at this time" /></FONT>  
        </FORM>
    </td></tr>
</table>

</center>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%
    
End Sub 'AddOnSurvey

'=====================================

Sub AddTickets
    'check to prevent adding too many VIP Lounge tickets per add-on event
	index = 1
	For Each EventCd In Request("EventSeatTypeCode")
	    If Request("Quantity")(index) <> "" Then
	        If CInt(Request("Quantity")(index)) > 0 Then
	            If CInt(Request("Quantity")(index)) > CInt(Request("Qty_" & Request("EventCode")(index))) Then
	                Message = "You cannot exceed the maximum of VIP Lounge tickets of " & Request("Qty_" & Request("EventCode")(index)) & " for any Add-on Events."
	                Call AddOnSurvey(Message)
	                Exit Sub
	            End If
	        End If
	    End If
	    index = index + 1
	Next
	
	index = 1
	For Each EventCd In Request("EventSeatTypeCode")
	    If Request("Quantity")(index) <> "" And Request("Quantity")(index) <> "0" Then
	        Call AddToCart(CleanNumeric(Request("EventCode")(index)), Clean(Request("SectionCode")(index)), CleanNumeric(Request("Quantity")(index)), CleanNumeric(Request("SeatTypeCode")(index)))
	    End If
	    index = index + 1
	Next
	Call PartTwo(Message)
End Sub

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
		Call AddOnSurvey(Message)
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
				SQLPrice = "SELECT Price, Surcharge FROM Price (NOLOCK) WHERE EventCode = " & EventCode & " AND SectionCode = '" & SectionCode & "' AND SeatTypeCode = " & SeatTypeCd
				Set rsPrice = OBJdbConnection.Execute(SQLPrice)
				Price = rsPrice("Price")
				'Surcharge = rsPrice("Surcharge")
				rsPrice.Close
				Set rsPrice = nothing
				
				'REE 11/29/6 - Modified for subscriptions.  Update Seat and SubFixedEvent lines only.
				SQLUpdateSeatType = "UPDATE OrderLine WITH (ROWLOCK) SET SeatTypeCode = " & SeatTypeCd & ", Price = " & Price & ", Surcharge = 0 WHERE OrderNumber = " & Session("OrderNumber") & " AND ItemNumber IN (SELECT TOP 1 ItemNumber FROM OrderLine (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND SeatTypeCode IS NULL AND ItemType IN ('Seat', 'SubFixedEvent') ORDER BY LineNumber DESC)"
				Set rsUpdateSeatType = OBJdbConnection.Execute(SQLUpdateSeatType)
				
			Next				

		Case Else
		
			Call AddOnSurvey(Message)
			
	End Select
End If

End Sub

'=====================================

Sub PartTwo(Message)

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & Title & "</TITLE>" & vbCrLf
Response.Write "</HEAD>" & vbCrLf

If Message <> "" Then
    Response.Write "<BODY onload=""alert('" & Message & "')"">" & vbCrLf
Else
    Response.Write strBody & vbCrLf
End If
%>

<!--#INCLUDE virtual="TopNavInclude.asp"-->
<center>
<h3><b>Please complete the following survey (Required):</b></h3>
<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey">
<INPUT TYPE="hidden" NAME="FormName" VALUE="UpdateSurvey">
<TABLE CELLPADDING=10 CELLSPACING=5 WIDTH="600" border=0>
<%
    SQLReqAct = "SELECT OrderLine.LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') AND Event.ActCode IN (66492)"
    Set rsReqAct = OBJdbConnection.Execute(SQLReqAct)
    If Not rsReqAct.EOF Then
%>
    <input type="hidden" name="Question1" value="What is your arrival port?" />
    <tr><td><font size=2>What is your arrival port?</font></td></tr>
    <tr><td><font size=2>
        <select name="Answer1">
            <option value="">- Select Port -</option>
            <option value="Arrival Port: Avalon">Avalon</option>
            <option value="Arrival Port: Two Harbors">Two Harbors</option>
        </select>
    </font></td></tr>
<%    
    End If
    rsReqAct.Close
    Set rsReqAct = Nothing    
    
    SQLReqAct = "SELECT OrderLine.LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') AND Event.ActCode IN (66503)"
    Set rsReqAct = OBJdbConnection.Execute(SQLReqAct)
    If Not rsReqAct.EOF Then
%>
    <input type="hidden" name="Question2" value="What is your departure port?" />
    <tr><td><font size=2>What is your departure port?</font></td></tr>
    <tr><td><font size=2>
        <select name="Answer2">
            <option value="">- Select Port -</option>
            <option value="Departure Port: Avalon (5:00pm)">Avalon</option>
            <option value="Departure Port: Two Harbors (4:00pm)">Two Harbors</option>
        </select>
    </font></td></tr>
<%    
    End If
    rsReqAct.Close
    Set rsReqAct = Nothing       
%>
    <tr><td align="center"><INPUT type="submit" value="Continue" /></td></tr>
</TABLE>
</FORM>

</center>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%

End Sub

Sub UpdateSurvey
    'check to ensure questions are answered in survey's part two
    For i = 1 To 2
        If Request("Question" & i) <> "" Then
            If Request("Answer" & i) = "" Then
                Message = "Please select both arrival and departure ports"
                Call PartTwo(Message)
                Exit Sub
            End If
        End If
    Next
    
    For AnswerNumber = 1 To 2
		If Clean(Request("Answer" & AnswerNumber)) <> "" Then
			For Each Item IN Request("Answer" & AnswerNumber)
				If Item <> "" Then
					SQLUpdateSurvey = "INSERT SurveyAnswers(SurveyNumber, OrderNumber, CustomerNumber, SurveyDate, AnswerNumber, Answer, Question) VALUES(" & CleanNumeric(SurveyNumber) & ", " & CleanNumeric(Session("OrderNumber")) & ", " & CleanNumeric(Session("CustomerNumber")) & ", '" & Now() & "', " & AnswerNumber & ", '" & Clean(Item) & "', '" & Clean(Request("Question" & AnswerNumber)) & "')"
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

'=====================================

%>


