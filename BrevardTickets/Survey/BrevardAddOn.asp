<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%
Page = "Survey"

SurveyNumber = 595
SurveyFileName = "BrevardAddOn.asp"
MatchEventCode = 194322
AddOnEventCode = 194325
SeatTypeCode = 16

'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If

If Clean(Request("FormName")) = "EventOffer" Then
	Call AddToCart(CleanNumeric(Request("EventCode")), Clean(Request("SectionCode")), CleanNumeric(Request("Quantity")), CleanNumeric(Request("SeatTypeCode")))
ElseIf Clean(Request("FormName")) = "Continue" Then
    Call Continue
Else
    Call AddOnSurvey
End If

'------------------------------------------


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
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="3"><B>Benefit Luncheon with Mindi Abair</B></FONT><BR><BR>
<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">If you would like to also attend the Benefit Luncheon with Mindi Abair, please click on the "Yes, Add Benefit Luncheon" button to add the same number of tickets as you currently have for the Benefit Performance.
<BR><BR>Otherwise, click on "No, thanks" and you may complete your order.</FONT>


<center>
<TABLE CELLPADDING=10 CELLSPACING=5 WIDTH="600" border=0>
<%
    
    'Determine how many tickets in this package
    SQLTicketCount = "SELECT COUNT(LineNumber) AS TotalTickets FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND EventCode = " & MatchEventCode
    Set rsTicketCount = OBJdbConnection.Execute(SQLTicketCount)
    NumTickets = rsTicketCount("TotalTickets")
    rsTicketCount.Close
    Set rsTicketCount = nothing
    
%>
    <tr><td align="center"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">
        <FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey">
            <INPUT TYPE="hidden" NAME="FormName" VALUE="EventOffer">
            <INPUT TYPE="hidden" NAME="EventCode" VALUE="<%=AddOnEventCode%>">
            <INPUT TYPE="hidden" NAME="SectionCode" VALUE="GA">
            <INPUT TYPE="hidden" NAME="Quantity" VALUE="<%=NumTickets%>">
            <INPUT TYPE="hidden" NAME="SeatTypeCode" VALUE="<%=SeatTypeCode%>">
            <INPUT type="submit" value="Yes, Add Benefit Luncheon">
        </FORM>   <FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey"><INPUT TYPE="hidden" NAME="FormName" VALUE="Continue"><INPUT type="submit" value="No, Thanks"></FORM> 

    </FONT></td></tr>
<%
%>
</TABLE>
</center>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%
    
End Sub 'AddOnSurvey



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

Select Case ReturnCode
	Case 0	'Stored Procedure executed properly.  Continue.
	
		For i = 1 To OfferQuantity

			'REE 6/21/5 - Added Seat Type Code to OrderLines.
			SQLPrice = "SELECT Price, Surcharge FROM Price (NOLOCK) WHERE EventCode = " & EventCode & " AND SectionCode = '" & SectionCode & "' AND SeatTypeCode = " & SeatTypeCode
			Set rsPrice = OBJdbConnection.Execute(SQLPrice)
							
			Price = rsPrice("Price")
			Surcharge = rsPrice("Surcharge")
							
			rsPrice.Close
			Set rsPrice = nothing
							
			'REE 11/29/6 - Modified for subscriptions.  Update Seat and SubFixedEvent lines only.
			SQLUpdateSeatType = "UPDATE OrderLine WITH (ROWLOCK) SET SeatTypeCode = " & SeatTypeCode & ", Price = " & Price & ", Surcharge = " & Surcharge & " WHERE OrderNumber = " & Session("OrderNumber") & " AND ItemNumber IN (SELECT TOP 1 ItemNumber FROM OrderLine (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND SeatTypeCode IS NULL AND ItemType IN ('Seat', 'SubFixedEvent') ORDER BY LineNumber DESC)"
			Set rsUpdateSeatType = OBJdbConnection.Execute(SQLUpdateSeatType)
			
		Next				

		Call DBClose(OBJdbConnection)
		Call Continue
		
	Case Else
	
		Call AddOnSurvey
		
End Select

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


