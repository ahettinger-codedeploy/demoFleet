<%

'CHANGE LOG
'SSR - 7/17/2012 - Updated unknown programmers existing survey. Almost everything is hard coded. Instructed by SM to leave code as is and only update starting at Line 161
'TTT 1/15/13 - Added SurveyNumber to OrderLineDetail
'LSP 07/19/13 - update eventcodes
%>
<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%
Page = "Survey"

SurveyNumber = 638
SurveyFileName = "AddOnSurvey.asp"

'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If

SQLTicketType = "SELECT OrderLine.SeatTypeCode, COUNT(*) AS TotalTix FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Seat.EventCode = 590159 GROUP BY OrderLine.SeatTypeCode ORDER BY OrderLine.SeatTypeCode"
Set rsTicketType = OBJdbConnection.Execute(SQLTicketType)
If rsTicketType.EOF Then
    Call Continue
Else
    TotalTickets = 0
    SeatTypeList = ""
    Do While Not rsTicketType.EOF
        SeatTypeList = SeatTypeList & rsTicketType("SeatTypeCode") & ","
        TotalTickets = TotalTickets + rsTicketType("TotalTix")
        rsTicketType.movenext
    Loop
    SeatTypeList = Left(SeatTypeList,Len(SeatTypeList)-1)
End If

If Clean(Request("FormName")) = "EventOffer" Then
    'Call AddToCart(CleanNumeric(Request("EventCode")), Clean(Request("SectionCode")), CleanNumeric(Request("Quantity")), Clean(Request("SurveyType")), CleanNumeric(Request("OriginalEventCode")), CleanNumeric(Request("SeatTypeCode")))
    Call EventOffer
ElseIf Clean(Request("FormName")) = "Continue" Then
    Call Continue
ElseIf Clean(Request("FormName")) = "SurveyForm" Then
    Call SurveyForm
ElseIf Clean(Request("FormName")) = "SurveyUpdate" Then
    Call SurveyUpdate
Else
    Call AddOnSurvey
End If

Sub EventOffer
    EventCodeList = Split(Replace(Request("EventCodeList")," ",""),",")    
    For i = lbound(EventCodeList) to ubound(EventCodeList)
        If Request("Quantity"&EventCodeList(i)) <> "" Then
            Call AddToCart(CleanNumeric(Request("EventCode"&EventCodeList(i))), Clean(Request("SectionCode"&EventCodeList(i))), CleanNumeric(Request("Quantity"&EventCodeList(i))), CleanNumeric(Request("SeatTypeCode"&EventCodeList(i))))
        End If
    Next
    Call SurveyForm
End Sub

Sub AddOnSurvey

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & Title & "</TITLE>" & vbCrLf
Response.Write "</HEAD>" & vbCrLf
Response.Write strBody & vbCrLf

%>

<!--#INCLUDE virtual="TopNavInclude.asp"-->
<BR>
<BR>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H6>Would you like to attend any of these events?</H6><BR></FONT>


<center>
<TABLE CELLPADDING=0 CELLSPACING=0 WIDTH="99%" border=0>
<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey">
    <INPUT TYPE="hidden" NAME="FormName" VALUE="EventOffer">
<%
    EventCodeList = ""
    'Determine which packages to show
    If InStr(SeatTypeList,"3553") Or InStr(SeatTypeList,"3554") Or InStr(SeatTypeList,"3556") Or InStr(SeatTypeList,"5737") Then
        EventCodeList = EventCodeList & "590160 ,590161"            
    End If
    If InStr(SeatTypeList,"3553") Or InStr(SeatTypeList,"3555") Or InStr(SeatTypeList,"3556") Or InStr(SeatTypeList,"5737") Then
        If EventCodeList <> "" Then
            EventCodeList = EventCodeList & ","    
        End If
        EventCodeList = EventCodeList & "590162"            
    End If
    
    'Show Package Info
    'SQLPackages = "SELECT Event.EventCode, Event.EventDate, Event.Comments AS EventComments, Act.Act, Act.Comments AS ActComments, SeatType.SeatTypeCode, SeatType.SeatType FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Price (NOLOCK) ON Event.EventCode = Price.EventCode INNER JOIN SeatType (NOLOCK) ON Price.SeatTypeCode = SeatType.SeatTypeCode WHERE Event.EventCode IN(" & EventCodeList & ") AND Price.EventCode IN(" & EventCodeList & ") ORDER BY Event.EventDate"
    SQLPackages = "SELECT Event.EventCode, Event.EventDate, Event.Comments AS EventComments, Act.Act, Event.Comments AS EventComments, SeatType.SeatTypeCode, SeatType.SeatType, Venue.Venue, Price.Price FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Price (NOLOCK) ON Event.EventCode = Price.EventCode INNER JOIN SeatType (NOLOCK) ON Price.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode WHERE Event.EventCode IN(" & EventCodeList & ") AND Price.EventCode IN(" & EventCodeList & ") ORDER BY Event.EventDate"
    Set rsPackages = OBJdbConnection.Execute(SQLPackages)
    Do While Not rsPackages.eof
%>
    <tr>
      <td><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><b><%=rsPackages("EventComments")%><BR><%=rsPackages("Venue")%> - <%=Replace(FormatDateTime(rsPackages("EventDate"),vbLongTime),":00 "," ")%> - $<%=rsPackages("Price")%></b><BR></FONT></td>
      <td valign="middle">
        Qty.&#32;<INPUT TYPE="text" NAME="Quantity<%=rsPackages("EventCode")%>" maxlength="3" size="3">     
        <INPUT TYPE="hidden" NAME="EventCode<%=rsPackages("EventCode")%>" VALUE="<%=rsPackages("EventCode")%>">
        <INPUT TYPE="hidden" NAME="SectionCode<%=rsPackages("EventCode")%>" VALUE="GA">
        <INPUT TYPE="hidden" NAME="SeatTypeCode<%=rsPackages("EventCode")%>" VALUE="<%=rsPackages("SeatTypeCode")%>">
      </td>
    </tr><TR><TD colspan=2><HR></TD><TR>
<%
        rsPackages.movenext
    Loop        
    rsPackages.Close
    Set rsPackages = Nothing
%>
    <tr><td align="center" colspan="2"><br /><input type="hidden" name="EventCodeList" value="<%=EventCodeList%>" /><input type="submit" value="Add To Cart" /></FORM></td></tr>
    <tr><td align="center" colspan="2"><form action="<%= SurveyFileName %>" method="post"><INPUT TYPE="hidden" NAME="FormName" VALUE="SurveyForm"><input type="submit" value="No Thanks" /></form></td></tr>
</TABLE>
</center>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%
    
End Sub 'AddOnSurvey

Sub SurveyForm

%>

<HTML>

<HEAD>

<TITLE><%=Title%></TITLE>

<style>
    
.report
{
font-family: Arial;   
}

hr 
{
margin: 17px 0 18px;
width: 250px;
clear: both;
border-width: 1px 0 0;
border-top: 1px solid #e1e1e1;
border-bottom: 1px solid #ffffff; 
}

b
{
margin: 0px; 
padding-top: 10px;
font-size: 20px; 
text-shadow: 0pt 1px 0px rgb(182,182,182); 
font-weight: strong; 
color: rgb(0,0,0);   
}

input[type="radio"] 
{
margin-right: 10;
}

</style>

</HEAD>

<BODY>

<!--#INCLUDE virtual="TopNavInclude.asp"-->
<BR>
<BR>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H6>Please indicate the sessions you are interested in attending:</H6><BR></FONT>


<center>
<TABLE CELLPADDING=0 CELLSPACING=0 WIDTH="99%" border=0>
<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey">
    <INPUT TYPE="hidden" NAME="FormName" VALUE="SurveyUpdate">
<%
    SQLTicketType = "SELECT OrderLine.SeatTypeCode FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Seat.EventCode = 590159 ORDER BY OrderLine.LineNumber"
    Set rsTicketType = OBJdbConnection.Execute(SQLTicketType)
    counter = 1
    Do While Not rsTicketType.EOF
        'Thursday, September 29
        If rsTicketType("SeatTypeCode")="3553" Or rsTicketType("SeatTypeCode")="3554" Or rsTicketType("SeatTypeCode")="3556" Or rsTicketType("SeatTypeCode")="5737" Then
%>
<tr><td><FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><b>THURSDAY, SEPTEMBER 26</b></FONT></td></tr> 
<tr><td><FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><b>8:30&#32;&#45;&#32;10:00</b><input type="hidden" name="Question1_<%=counter%>" value="Thursday, September 26 (8:30&#32;&#45;&#32;10:00)" /></td></tr> 
<tr><td><FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><input type="radio" name="Answer1_<%=counter%>" value="The Civil War Era" />The Civil War Era<BR><input type="radio" name="Answer1_<%=counter%>" value="Tales from the Progressive Era" />Tales from the Progressive Era<BR><input type="radio" name="Answer1_<%=counter%>" value="The Illinois College Time Capsule Project" />The Illinois College Time Capsule Project<br /><input type="radio" name="Answer1_<%=counter%>" value="The Life and Work of Ernest Hemingway" />The Life and Work of Ernest Hemingway*</td></tr> 
<tr><td><FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><b>10:15&#32;&#45;&#32;11:45</b><input type="hidden" name="Question2_<%=counter%>" value="Thursday, September 26(10:15&#32;&#45;&#32;11:45)" /></FONT></td></tr> 
<tr><td><FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><input type="radio" name="Answer2_<%=counter%>" value="Illinois Libraries" />Illinois Libraries<BR><input type="radio" name="Answer2_<%=counter%>" value="Stories from the 1930s" />Stories from the 1930s<BR><input type="radio" name="Answer2_<%=counter%>" value="The Importance of Place" />The Importance of Place<br /><input type="radio" name="Answer2_<%=counter%>" value="Teaching Abraham Lincoln with Spielbergs Film" />Teaching Abraham Lincoln with Spielberg's Film</FONT></td></tr> 
<tr><td><FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><b>1:45&#32;&#45;&#32;3:15</b><input type="hidden" name="Question3_<%=counter%>" value="Thursday, September 26(1:45&#32;&#45;&#32;3:15)" /></FONT></td></tr> 
<tr><td><FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><input type="radio" name="Answer3_<%=counter%>" value="17th Century Travel and Trade" />17th-Century Travel and Trade<BR><input type="radio" name="Answer3_<%=counter%>" value="Transcending Place and Time" />Transcending Place &amp; Time<BR><input type="radio" name="Answer3_<%=counter%>" value="Popular Culture" />Popular Culture<BR><input type="radio" name="Answer3_<%=counter%>" value="Teaching the Gettysburg Address" />Teaching the Gettysburg Address*<BR></FONT></td></tr> 
<tr><td><FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><b>3:30&#32;&#45;&#32;5:00</b><input type="hidden" name="Question4_<%=counter%>" value="Thursday, September 26(3:30&#32;&#45;&#32;5:00)" /></FONT></td></tr> 
<tr><td><FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><input type="radio" name="Answer4_<%=counter%>" value="Southern Illinois Stories" />Southern Illinois Stories<BR><input type="radio" name="Answer4_<%=counter%>" value="Lincoln and the Law" />Lincoln and the Law<BR><input type="radio" name="Answer4_<%=counter%>" value="Unusual Family Stories" />Unusual Family Stories<BR><input type="radio" name="Answer4_<%=counter%>" value="The Contours and Contexts of Teaching" />The Contours and Contexts of Teaching<BR></td></FONT></tr>  
<%            
        End If
        'Friday, September 30
        If rsTicketType("SeatTypeCode")="3553" Or rsTicketType("SeatTypeCode")="3555" Or rsTicketType("SeatTypeCode")="3556" Or rsTicketType("SeatTypeCode")="5737" Then
%>
<tr><td><hr /></td></tr>
<tr><td><FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><b>FRIDAY, SEPTEMBER 27</b></FONT></td></tr>
<tr><td><FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><b>8:30&#32;&#45;&#32;10:00</b><input type="hidden" name="Question5_<%=counter%>" value="FRIDAY, SEPTEMBER 27 (8:30&#32;&#45;&#32;10:00)" /></FONT></td></tr> 
<tr><td><FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><input type="radio" name="Answer5_<%=counter%>" value="Anglo-Indian Warfare on the Illinois Frontier" />Anglo-Indian Warfare on the Illinois Frontier<BR><input type="radio" name="Answer5_<%=counter%>" value="Late 20th-Century Politics" />Late 20th-Century Politics<BR><input type="radio" name="Answer5_<%=counter%>" value="Special Buildings" />Special Buildings<BR><input type="radio" name="Answer5_<%=counter%>" value="Understanding Abraham Lincoln Through Primary Sources*" />Understanding Abraham Lincoln Through Primary Sources*<BR></FONT></td></tr> 
<tr><td><FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><b>10:15&#32;&#45;&#32;11:45</b><input type="hidden" name="Question6_<%=counter%>" value="FRIDAY, SEPTEMBER 27 (10:15&#32;&#45;&#32;11:45)" /></FONT></td></tr> 
<tr><td><FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><input type="radio" name="Answer6_<%=counter%>" value="Government Initiatives-Federal and Local" />Government Initiatives-Federal and Local<BR><input type="radio" name="Answer6_<%=counter%>" value="Latino Experiences in Illinois" />Latino Experiences in Illinois<BR><input type="radio" name="Answer6_<%=counter%>" value="Historical Meanings in Arts and Crafts" />Historical Meanings in Arts and Crafts<BR><input type="radio" name="Answer6_<%=counter%>" value="Mapping the Prairie State*" />Mapping the Prairie State*<BR></FONT></td></tr> 
<tr><td><FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><b>1:45&#32;&#45;&#32;3:15</b><input type="hidden" name="Question7_<%=counter%>" value="FRIDAY, SEPTEMBER 27 (1:45&#32;&#45;&#32;3:15)" /></FONT></td></tr> 
<tr><td><FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><input type="radio" name="Answer7_<%=counter%>" value="Civil Rights Stories" />Civil Rights Stories<BR><input type="radio" name="Answer7_<%=counter%>" value="Adventures in Genealogy" />Adventures in Genealogy<BR><input type="radio" name="Answer7_<%=counter%>" value="Illinois Civil War Generals" />Illinois Civil War Generals<BR><input type="radio" name="Answer7_<%=counter%>" value="What is the National Register of Historic Places" />What is the National Register of Historic Places<BR></FONT></td></tr> 
<tr><td><FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><b>3:30&#32;&#45;&#32;5:00</b><input type="hidden" name="Question8_<%=counter%>" value="FRIDAY, SEPTEMBER 27 (3:30&#32;&#45;&#32;5:00)" /></FONT></td></tr> 
<tr><td><FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><input type="radio" name="Answer8_<%=counter%>" value="Industrial and Social Change in Chicago" />Industrial and Social Change in Chicago<BR><input type="radio" name="Answer8_<%=counter%>" value="Lincoln Stories from Historic Sites" />Lincoln Stories from Historic Sites<BR><input type="radio" name="Answer8_<%=counter%>" value="Social History in the Lincoln Era" />Social History in the Lincoln Era<BR><input type="radio" name="Answer8_<%=counter%>" value="How Do I Get a Property Registered?" />How Do I Get a Property Registered?<BR></FONT></td></tr> 
<%       
        End If
        
        counter = counter + 1
        rsTicketType.movenext
        
        If Not rsTicketType.EOF Then
            Response.Write "<tr><td><hr /></td></tr>"
        End If
    Loop
    rsTicketType.Close
    Set rsTicketType = Nothing
%>
    <tr><td align="center" colspan="2"><br><FONT SIZE="1">*Denotes Teacher Workshop</FONT><BR><BR><input type="submit" value="Continue" /></FORM></td></tr>
</TABLE>
</center>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%
    
End Sub 'SurveyForm

Sub SurveyUpdate
    For i = 1 to TotalTickets
        For j = 1 to 8
            If Request("Answer"&j&"_"&i) <> "" Then
                SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & i & " AND FieldName = '" & Clean(Request("Question"&j&"_"&i)) & "'"
		        Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)
		        SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, SurveyNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & i & "," & SurveyNumber & ", '" & Clean(Request("Question"&j&"_"&i)) & "', '" & Clean(Request("Answer"&j&"_"&i)) & "')"
		        Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)
            End If
        Next
    Next
    
    Call Continue
End Sub

Sub AddToCart(EventCode, SectionCode, OfferQuantity, SeatTypeCode)

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
				SQLPrice = "SELECT Price, Surcharge FROM Price (NOLOCK) WHERE EventCode = " & EventCode & " AND SectionCode = '" & SectionCode & "' AND SeatTypeCode = " & Clean(SeatTypeCode)
				Set rsPrice = OBJdbConnection.Execute(SQLPrice)
								
				Price = rsPrice("Price")
				Surcharge = rsPrice("Surcharge")
								
				rsPrice.Close
				Set rsPrice = nothing
								
				'REE 11/29/6 - Modified for subscriptions.  Update Seat and SubFixedEvent lines only.
				SQLUpdateSeatType = "UPDATE OrderLine WITH (ROWLOCK) SET SeatTypeCode = " & Clean(SeatTypeCode) & ", Price = " & Price & ", Surcharge = " & Surcharge & " WHERE OrderNumber = " & Session("OrderNumber") & " AND ItemNumber IN (SELECT TOP 1 ItemNumber FROM OrderLine (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND SeatTypeCode IS NULL AND ItemType IN ('Seat', 'SubFixedEvent') ORDER BY LineNumber DESC)"
				Set rsUpdateSeatType = OBJdbConnection.Execute(SQLUpdateSeatType)
				
			Next				

			'Call DBClose(OBJdbConnection)
			
			'Call Continue
			
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


