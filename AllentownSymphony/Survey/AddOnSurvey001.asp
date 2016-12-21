<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%
Page = "Survey"

SurveyNumber = 786
SurveyFileName = "AddOnSurvey.asp"

'Check to see if Order Number exists.  If not, redirect to Home Page.
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
	        Call AddToCart(CleanNumeric(Request("EventCode")(index)), Clean(Request("Color")(index)), CleanNumeric(Request("Quantity")(index)))
	    End If
	    index = index + 1
	Next

    Call Continue
ElseIf Clean(Request("FormName")) = "Continue" Then
    Call Continue
Else
    Call AddOnSurvey(Message)
End If

Sub AddOnSurvey(Message)

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & Title & "</TITLE>" & vbCrLf
Response.Write "</HEAD>" & vbCrLf
'Response.Write strBody & vbCrLf

If Message = "" Then
	Response.Write "<BODY BGCOLOR=#FFFFFF onLoad=" & CHR(34) & "loadForm()" & CHR(34) & ">" & vbCrLf
Else
	Response.Write "<BODY BGCOLOR=#FFFFFF onLoad=" & CHR(34) & "alert('" & Message & "')" & CHR(34) & ">" & vbCrLf
End If

%>

<!--#INCLUDE virtual="TopNavInclude.asp"-->
<BR>
<BR>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3>Please select the following events to add on to your order:</H3></FONT>


<center>
<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey">
<INPUT TYPE="hidden" NAME="FormName" VALUE="EventOffer">
<TABLE CELLPADDING=10 CELLSPACING=5 WIDTH="700" border=0>
<tr><td><hr style="width:500px;" /></td></tr>
<%
    SQLEventCode = "SELECT Event.EventCode, Count(Event.EventCode) AS TotalTix FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Event.EventCode IN(260533,276204,276206,276205,260535,276325,276327,276326) GROUP BY Event.EventCode ORDER BY TotalTix DESC"
    Set rsEventCode = OBJdbConnection.Execute(SQLEventCode)
    OfferEventCode = rsEventCode("EventCode")
    NumTickets = rsEventCode("TotalTix")
    rsEventCode.Close
    Set rsEventCode = nothing
    
    If CInt(NumTickets) = 0 Then
        Call Continue    
    End If
    
    'Get color of parent offer event
    SQLColor = "SELECT Section.Color FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.SectionCode = Section.SectionCode AND Seat.EventCode = Section.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Section.EventCode = " & OfferEventCode
    Set rsColor = OBJdbConnection.Execute(SQLColor)
    Color = rsColor("Color")
    rsColor.Close
    Set rsColor = Nothing
    
    EventCodeList = "257782"
    SQLPackages = "SELECT Event.EventCode, Event.EventDate, Event.Comments AS EventComments, Act.Act, Act.Comments AS ActComments FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode WHERE Event.EventCode IN(" & EventCodeList & ") ORDER BY Event.EventDate"
    Set rsPackages = OBJdbConnection.Execute(SQLPackages)
    If Not rsPackages.EOF Then
        Do While Not rsPackages.eof
%>
    <tr><td nowrap><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><b><%=rsPackages("Act")%> - <%=rsPackages("EventDate")%> (<%=rsPackages("EventCode")%>)</b></FONT></td></tr>
    <tr><td><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><%=rsPackages("ActComments")%></FONT></td></tr>
    
    <tr><td align="center"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">
        <INPUT TYPE="hidden" NAME="EventCode" VALUE="<%=rsPackages("EventCode")%>">
        <INPUT TYPE="hidden" NAME="Color" VALUE="<%=Color%>">
        <INPUT TYPE="text" NAME="Quantity" maxlength="3" size="3" value="<%=NumTickets%>">
    </FONT></td></tr>
<%
            rsPackages.movenext
        Loop
    End If
    rsPackages.Close
    Set rsPackages = Nothing
%>
    <tr><td align=center><INPUT type="submit" value="Add To Cart" /></FORM></td></tr>
    <tr><td><hr style="width:500px;" /></td></tr>
    <tr><td align=center><form action="<%= SurveyFileName %>" method="post"><INPUT TYPE="hidden" NAME="FormName" VALUE="Continue"><input type="submit" value="No Thanks!" /></form></td></tr>
</TABLE>

</center>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%
    
End Sub 'AddOnSurvey



Sub AddToCart(EventCode, Color, SeatCount)
'ErrorLog("Line 115: " & EventCode & " - " & Color & " - " & OfferQuantity)

'Create an Order Header if Necessary
If Session("OrderNumber") = "" Then 
	If Session("CustomerNumber") = "" Then
		CustomerNumber = 1
	Else
		CustomerNumber = Session("CustomerNumber")
	End If

	'Check to see if this is a box office entry.  If so, set up the UserNumber
	If Session("UserNumber") <> "" Then
		UserNumber = Session("UserNumber")
	Else
		UserNumber = 0
	End If

	'REE 11/24/2 - Added ExpirationDate to OrderHeader

	'Set Default Expiration to 30 minutes from now using TimeOffset.  UnReserve will catch it 30 minutes from now.
	OrderExpirationDate = DateAdd("n", 30 + (TimeOffset() * -1), Now())

	'Get TimeZone Offset for VenueOwner Organization
	SQLLocalOffset = "SELECT OrganizationOptions.OrganizationNumber, OptionValue AS LocalOffset FROM Event (NOLOCK) INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Venue.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationOptions (NOLOCK) ON OrganizationVenue.OrganizationNumber = OrganizationOptions.OrganizationNumber WHERE Event.EventCode = " & EventCode & " AND OrganizationVenue.Owner <> 0 AND OrganizationOptions.OptionName = 'TimeZoneOffset'"
	Set rsLocalOffset = OBJdbConnection.Execute(SQLLocalOffset)
	
	If Not rsLocalOffset.EOF Then 'Get Expiration Delay for VenueOwner Organization
		SQLExpirationDelay = "SELECT OptionValue As ExpirationDelay FROM OrganizationOptions (NOLOCK) WHERE OrganizationNumber = " & rsLocalOffset("OrganizationNumber") & " AND OptionName = 'OrderExpirationDelay'"
		Set rsExpirationDelay = OBJdbConnection.Execute(SQLExpirationDelay)
		
		If Not rsExpirationDelay.EOF Then 'Set the ExpirationDate based on Offset and Delay
			OrderExpirationDate = DateAdd("n", (rsLocalOffset("LocalOffset") - TimeOffset()) + rsExpirationDelay("ExpirationDelay"), Now())
		End If
		
		rsExpirationDelay.close
		Set rsExpirationDelay = nothing
	End If
	
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
	spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("OrderTypeNumber", 3, 1, , Session("OrderTypeNumber")) 'As Integer and Input
	spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("UserNumber", 3, 1, , UserNumber) 'As Integer and Input
	spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("OrderExpirationDate", 7, 1, , OrderExpirationDate) 'As Date and Input
	spInsertOrderHeader.Parameters.Append spInsertOrderHeader.CreateParameter("IPAddress", 200, 1, 15, IPAddress) 'As Varchar and Input
	spInsertOrderHeader.Execute

	Session("OrderNumber") = spInsertOrderHeader.Parameters("OrderNumber")

	If Session("OrderNumber") = 0 Then
		Message = "There was a problem processing this request.  Please try again later."
		Session.Contents.Remove("OrderNumber")
		Call BestAvailable(Message)
	End If
	
End If

'**********************
'Find Best Available
'**********************
SQLAvailable = "SELECT Count(LineNumber) AS ExistingSeats FROM Orderline (NOLOCK) LEFT JOIN Seat (NOLOCK) ON Orderline.ItemNumber = Seat.ItemNumber WHERE Orderline.OrderNumber = " & Session("OrderNumber") & " AND EventCode = " & EventCode & " AND OrderLine.ItemType = 'Seat'"
Set rsAvailable = OBJdbConnection.Execute(SQLAvailable)
ExistingSeatCount = rsAvailable("ExistingSeats")
rsAvailable.Close
Set rsAvailable = nothing
TotalSeatCount = ExistingSeatCount + SeatCount

If TotalSeatCount > MaxTickets Then 'Display error
	OrderError = "Y"
End If

'REE 5/3/4 - Moved code to determine which stored procedure is to be used to outside of loop below.
EventType = ""
SQLEventType = "SELECT EventType FROM Event (NOLOCK) WHERE EventCode = " & EventCode
Set rsEventType = OBJdbConnection.Execute(SQLEventType)
If Not rsEventType.EOF Then
	EventType = rsEventType("EventType")
End If
rsEventType.Close
Set rsEventType = nothing	

'REE 5/3/4 - Added initialization of SectionList Variable
SectionList = ""

'JAI 6/26/3 - Added subscription capability for Best Available
If EventType = "SubFixedEvent" Then
	SQLCommandText = "spBestAvailableReserveSeatsSubFixedEvent"

    'JAI 6/14/5 - Added check to sell child seats that are on hold.  Default is Yes, unless an OrganizationOption exists.
    'Check if Held Child seats are to be made available
    SQLSellChild = "SELECT OptionValue AS SellChild FROM Event (NOLOCK) INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Venue.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationOptions (NOLOCK) ON OrganizationVenue.OrganizationNumber = OrganizationOptions.OrganizationNumber WHERE Event.EventCode = " & EventCode & " AND OrganizationVenue.Owner <> 0 AND OrganizationOptions.OptionName = 'SubscriptionSellChildHeld'"
    Set rsSellChild = OBJdbConnection.Execute(SQLSellChild)
    SellChild = "Y"
    If Not rsSellChild.EOF Then
        If rsSellChild("SellChild") = "N" Then
            SellChild = "N"
        End If
    End If
    rsSellChild.Close
    Set rsSellChild = nothing

Else
	SQLCommandText = "spBestAvailableReserveSeats"
End If

ReturnCode = 0
iPriority = 0
MemberType = ""
SelectionFulfilled = "N"
SelectionError = "N"

Do Until SelectionFulfilled = "Y"  OR SelectionError = "Y"

    Set SQLCommand = Server.Createobject("Adodb.Command")
    Set SQLCommand.ActiveConnection = OBJdbConnection
    SQLCommand.CommandType = 4 ' Value for Stored Procedure
    SQLCommand.CommandText = SQLCommandText
    SQLCommand.Parameters.Append SQLCommand.CreateParameter("ReturnCode", 3, 4) 'As Integer and ParamReturnValue
    SQLCommand.Parameters.Append SQLCommand.CreateParameter("EventCode", 3, 1, , EventCode) 'As Integer and Input
    SQLCommand.Parameters.Append SQLCommand.CreateParameter("OrderNumber", 3, 1, , Session("OrderNumber")) 'As Integer and Input
    SQLCommand.Parameters.Append SQLCommand.CreateParameter("SeatCount", 3, 1, , SeatCount) 'As Integer and Input
    SQLCommand.Parameters.Append SQLCommand.CreateParameter("Color", 200, 1, 15, Color) 'As Varchar and Input
    SQLCommand.Parameters.Append SQLCommand.CreateParameter("MemberType", 200, 1, 50, MemberType) 'As Varchar and Input
    If 	EventType = "SubFixedEvent" Then
        SQLCommand.Parameters.Append SQLCommand.CreateParameter("SellChild", 200, 1, 1, SellChild) 'As Varchar and Input
    End If
    SQLCommand.Parameters.Append SQLCommand.CreateParameter("Priority", 3, 3, , iPriority) 'As Integer and Input/Output
    SQLCommand.Parameters.Append SQLCommand.CreateParameter("BestSectionCode", 200, 3, 5, "") 'As Varchar and Input/Output
    SQLCommand.Execute

    ReturnCode = SQLCommand.Parameters("ReturnCode")
    iPriority = SQLCommand.Parameters("Priority")
    BestSeatSectionCode = SQLCommand.Parameters("BestSectionCode")

    Select Case ReturnCode
        Case 0	'Stored Procedure executed properly.  Continue.
            SelectionFulfilled = "Y"
        Case 1	'SQL database error.
            SelectionError = "Y"
        Case 2	'Seats not available.  Continue Loop.
        Case 3 'No more seats available for this event
            SelectionError = "Y"
        Case Else 'Unknown.  Assume error.
            SelectionError = "Y"
    End Select
Loop
If SelectionFulfilled = "Y" Then
    OrderSelectionFulfilled = SelectionFulfilled
End If
If SelectionError = "Y" Then
    OrderError = "Y"
    OrderErrorReturnCode = ReturnCode
End If

If OrderError = "Y" Then
    If OrderSelectionFulfilled = "Y" Then
        Message = Message & "Only part of your ticket request was fulfilled properly.\nClick on the Shopping Cart link at the bottom of the page to view the tickets in your cart.\n\nThe following text provides additional information:\n"
    End If
	Select Case OrderErrorReturnCode
		Case 1	'SQL database error.
			Message = Message & "There was a problem processing your request.  Please try again later."
		Case 3	'Seats not available.
			If SeatCount = 1 Then
				Message = Message & "There are no seats available for your request.\nPlease select a different price option or use the Select Tickets option."
			Else
				Message = Message & "There are not " & SeatCount & " adjacent seats available for your request.\nPlease select a smaller quantity, a different price option or use the Select Tickets option."
			End If
		Case Else 'Unknown.  Assume error.
			Message = Message & "There was a problem processing your request.  Please try again later."
	End Select
	If TotalSeatCount > MaxTickets Then 'Display error
		Message = Message & "The maximum number of seats allowed is " & MaxTickets & " per event."
	End If
	Call AddOnSurvey(Message)
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


