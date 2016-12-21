<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%
Page = "Survey"

SurveyNumber = 607
DiscountTypeNumber = 37662
MemberEventCode = 176317
EventCode = Clean(Request("EventCode"))
DiscountAmount = 1.0 '100% Discount
AllowedSeatType = "16,564"

'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If

'Check to see if this is an offline order. If so, display warning page.
If Session("OrderTypeNumber") = 2 Or Session("OrderTypeNumber") = 3 Or  Session("OrderTypeNumber") = 4 Or  Session("OrderTypeNumber") = 5 Or  Session("OrderTypeNumber") = 7 Then
	Call OfflineWarning
End If

MemberEventCount = ""
'Check if the member event code is in order
SQLMemberEvent = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE EventCode = " & CleanNumeric(MemberEventCode) & " AND OrderLine.OrderNumber = " & CleanNumeric(Session("OrderNumber"))
Set rsMemberEvent = OBJdbConnection.Execute(SQLMemberEvent)
If Not rsMemberEvent.EOF Then 'it is in order
    MemberEventCount = rsMemberEvent("TicketCount")
End If
rsMemberEvent.Close
Set rsMemberEvent = nothing

'check if this customer has purchased this member event code before
'If MemberEventCount = 0 Then
SQLMemberBefore = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE CustomerNumber = " & CleanNumeric(Session("CustomerNumber")) & " AND EventCode = " & CleanNumeric(MemberEventCode) & " AND OrderHeader.OrderNumber <> " & CleanNumeric(Session("OrderNumber"))
Set rsMemberBefore = OBJdbConnection.Execute(SQLMemberBefore)
If Not rsMemberBefore.EOF Then
    MemberEventCount2 = rsMemberBefore("TicketCount")
End If
rsMemberBefore.Close
Set rsMemberBefore = nothing
'End If

If MemberEventCount >= 1 Or MemberEventCount2 >= 1 Then 
	Call ApplyDiscount
Else
	Call Continue
End If


'==============================

Sub ApplyDiscount	
	
	'REE 5/21/9 - Remove discounts on this order
	SQLRemove = "UPDATE OrderLine WITH (ROWLOCK) SET DiscountTypeNumber = 0, Discount = 0 WHERE OrderNumber = " & Session("OrderNumber") & " AND DiscountTypeNumber = " & DiscountTypeNumber
	Set rsRemove = OBJdbConnection.Execute(SQLRemove)
	
	'SQLFreeTickets = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderHeader.CustomerNumber = " & Session("CustomerNumber") & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderHeader.OrderNumber <> " & Session("OrderNumber")
	SQLFreeTickets = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE (OrderHeader.CustomerNumber = " & Session("CustomerNumber") & " OR OrderHeader.OrderNumber = " & Session("OrderNumber") & ") AND Seat.EventCode = " & CleanNumeric(MemberEventCode)
	Set rsFreeTickets = OBJdbConnection.Execute(SQLFreeTickets)
	SeasonTickets = rsFreeTickets("TicketCount")
	rsFreeTickets.Close
	Set rsFreeTickets = nothing
	
	AppliedCount = 0
	'REE 5/21/9 - Count how many discounts have been applied for this customer
	SQLApplied = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE OrderHeader.CustomerNumber = " & Session("CustomerNumber") & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.StatusCode = 'S'"
	Set rsApplied = OBJdbConnection.Execute(SQLApplied)
	AppliedCount = rsApplied("TicketCount")
	rsApplied.Close
	Set rsApplied = nothing
	

    'REE 5/21/9 - Modified to take applied count into consideration
    NumberFreeTickets = (6 * SeasonTickets) - AppliedCount
    
    If CInt(NumberFreeTickets) > 0 Then 'it is okay to give free tickets
        DiscountApplied = "N"
        SQLLineNo = "SELECT TOP(" & NumberFreeTickets & ") LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Seat.EventCode <> " & CleanNumeric(MemberEventCode) & " AND OrderLine.SeatTypeCode = 1 ORDER BY LineNumber"
        Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)
        If Not rsLineNo.EOF Then
            Do While Not rsLineNo.EOF
                SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = Price * " & DiscountAmount & ", Surcharge = 0, DiscountTypeNumber = " & DiscountTypeNumber & " WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber")
                Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
                DiscountApplied = "Y"
                rsLineNo.movenext
            Loop
		End If
		rsLineNo.Close
		Set rsLineNo = Nothing
        
        If DiscountApplied = "Y" Then
            Call WarningPage
        Else
            Call Continue
        End If
    Else
        Call Continue
    End If

End Sub 'ApplyDiscount

'==============================

Sub OfflineWarningPage

Session("SurveyComplete") = Session("OrderNumber")

If FontFace = "" Then
	FontFace = "verdana,arial,helvetica"
End If

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & Title & "</TITLE>" & vbCrLf
Response.Write "</HEAD>" & vbCrLf

Response.Write "<BODY BGCOLOR=" & BGColor & " LINK="& LinkColor & " ALINK=" & ALinkColor & " VLINK=" & VLinkColor & " leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0 " & BodyParameters & ">" & vbCrLf
					
%>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<BR>
<BR>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3>ATTENTION</H3></FONT>

<%

Session("SurveyComplete") = Session("OrderNumber")

Response.Write "<CENTER><TABLE><TR><TD><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=2>This patron is a Flex Pass season subscriber and is qualified for up to 6 discounted tickets.<BR>Please have the patron enter this order themselves. <BR><BR><CENTER><FORM ACTION=""/Management/AdvanceShip.asp"" METHOD=""POST"" id=form1 name=form1><INPUT TYPE=""submit"" VALUE=""Continue"" id=1 name=1></FORM></CENTER></TD></TR></TABLE></CENTER><BR><BR>" & vbCrLf


%>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%			
End Sub 'OfflineWarning Page

'==============================

Sub WarningPage

Session("SurveyComplete") = Session("OrderNumber")

If FontFace = "" Then
	FontFace = "verdana,arial,helvetica"
End If

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & Title & "</TITLE>" & vbCrLf
Response.Write "</HEAD>" & vbCrLf

Response.Write "<BODY BGCOLOR=" & BGColor & " LINK="& LinkColor & " ALINK=" & ALinkColor & " VLINK=" & VLinkColor & " leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0 " & BodyParameters & ">" & vbCrLf
					
%>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<BR>
<BR>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3>Congradulations!</H3></FONT>

<%

Session("SurveyComplete") = Session("OrderNumber")

Response.Write "<CENTER><TABLE><TR><TD><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=2>Your season subscription purchase has qualified you for a discount on this order.<BR><BR><CENTER>

If Session("UserNumber") = "" Then
<FORM ACTION=""/Ship.asp"" METHOD=""POST"" id=form1 name=form1>
Else




<INPUT TYPE=""submit"" VALUE=""Continue"" id=1 name=1></FORM></CENTER></TD></TR></TABLE></CENTER><BR><BR>" & vbCrLf
Else
	Response.Write "<CENTER><TABLE><TR><TD><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=2>Your season subscription purchase has qualified you for a discount on this order.<BR><BR><CENTER><FORM ACTION=""/Management/AdvanceShip.asp"" METHOD=""POST"" id=form1 name=form1><INPUT TYPE=""submit"" VALUE=""Continue"" id=1 name=1></FORM></CENTER></TD></TR></TABLE></CENTER><BR><BR>" & vbCrLf
End If

%>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%			
End Sub 'Warning Page

'==============================

Sub Continue
				
Session("SurveyComplete") = Session("OrderNumber")
If Session("UserNumber") = "" Then
	Response.Redirect("/Ship.asp")
Else
	Response.Redirect("/Management/AdvanceShip.asp")
End If		

End Sub 'Continue

'==============================

%>