<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%

'Initialise general parameters
Page = "Survey"
EventCode = Clean(Request("EventCode"))

'Set discount parameters
SurveyNumber = 607
DiscountTypeNumber = 37662
MemberEventName = "Flex Season Pass"
MemberEventCode = 176317 'Event required to purchase for discounts
ExcludeEventCode = "177191,177192,177193,177194,177195,177196"
GalaEventCode = "177197,177198,177199,177200,177201,177202"
PossibleFreeTickets = 6 'Number of discounts given per 1 member event
AllowedSeatType = "16"
DiscountAmount1 = "Price * 1.0" 'Regular Shows
DiscountAmount2 = "Price - 10" 'Gala shows

'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If

'Check to see if this is an offline order. If so, skip discount.
'If Session("OrderTypeNumber") = 2 Or Session("OrderTypeNumber") = 3 Or Session("OrderTypeNumber") = 4 Or Session("OrderTypeNumber") = 5 Or Session("OrderTypeNumber") = 7 Then
	'Call Continue
'End If

MemberEventCount = ""
'Determine if member event is in current order
SQLMemberEvent = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE EventCode = " & CleanNumeric(MemberEventCode) & " AND OrderLine.OrderNumber = " & CleanNumeric(Session("OrderNumber"))
Set rsMemberEvent = OBJdbConnection.Execute(SQLMemberEvent)
If Not rsMemberEvent.EOF Then 'it is in order
    MemberEventCount = rsMemberEvent("TicketCount")
End If
rsMemberEvent.Close
Set rsMemberEvent = nothing

'Determine if the member event was purchased previously
SQLMemberBefore = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE CustomerNumber = " & CleanNumeric(Session("CustomerNumber")) & " AND EventCode = " & CleanNumeric(MemberEventCode) & " AND OrderHeader.OrderNumber <> " & CleanNumeric(Session("OrderNumber"))
Set rsMemberBefore = OBJdbConnection.Execute(SQLMemberBefore)
If Not rsMemberBefore.EOF Then
    MemberEventCount2 = rsMemberBefore("TicketCount")
End If
rsMemberBefore.Close
Set rsMemberBefore = nothing


If MemberEventCount >= 1 Or MemberEventCount2 >= 1 Then 
	Call ApplyDiscount
Else
	Call Continue
End If


'==============================

Sub ApplyDiscount	
	
	'Remove discounts on this order
	SQLRemove = "UPDATE OrderLine WITH (ROWLOCK) SET DiscountTypeNumber = 0, Discount = 0 WHERE OrderNumber = " & Session("OrderNumber") & " AND DiscountTypeNumber = " & DiscountTypeNumber
	Set rsRemove = OBJdbConnection.Execute(SQLRemove)
	
	'Determine number of total discounts possible
	SQLFreeTickets = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE (OrderHeader.CustomerNumber = " & Session("CustomerNumber") & " OR OrderHeader.OrderNumber = " & Session("OrderNumber") & ") AND Seat.EventCode = " & CleanNumeric(MemberEventCode)
	Set rsFreeTickets = OBJdbConnection.Execute(SQLFreeTickets)
	SeasonTickets = rsFreeTickets("TicketCount")
	rsFreeTickets.Close
	Set rsFreeTickets = nothing
	
	'Determine number of discounts already given
	AppliedCount = 0
	SQLApplied = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE OrderHeader.CustomerNumber = " & Session("CustomerNumber") & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.StatusCode = 'S'"
	Set rsApplied = OBJdbConnection.Execute(SQLApplied)
	AppliedCount = rsApplied("TicketCount")
	rsApplied.Close
	Set rsApplied = nothing
	

   'Determine number of discount left
   NumberFreeTickets = (PossibleFreeTickets * SeasonTickets) - AppliedCount
    
    If CInt(NumberFreeTickets) > 0 Then 'it is okay to give free tickets
        DiscountApplied = "N"
        SQLLineNo = "SELECT TOP(" & NumberFreeTickets & ") LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Seat.EventCode NOT IN (" & ExcludeEventCode & ", " & MemberEventCode & ") AND OrderLine.SeatTypeCode IN (" & AllowedSeatType & ") ORDER BY LineNumber"
        Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)
        If Not rsLineNo.EOF Then
            Do While Not rsLineNo.EOF
                
                                   
								SQLFindEvent = "Select Seat.EventCode FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & "  AND LineNumber = " & rsLineNo("LineNumber")
								Set rsFindEvent = OBJdbConnection.Execute(SQLFindEvent)
								
								If rsFindEvent("EventCode") = 177202 Or rsFindEvent("EventCode") = 177197 Or rsFindEvent("EventCode") = 177198 Or rsFindEvent("EventCode") = 177199 Or rsFindEvent("EventCode") = 177200 Or rsFindEvent("EventCode") = 177201 Or rsFindEvent("EventCode") = 177202 Then 
								
								'Gala event discount
								SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = " & DiscountAmount2 & ", Surcharge = 0, DiscountTypeNumber = " & DiscountTypeNumber & " WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber")
                Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
                DiscountApplied = "Y"
                
                Else
                
                'Regular event discount
                SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = " & DiscountAmount1 & ", Surcharge = 0, DiscountTypeNumber = " & DiscountTypeNumber & " WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber")
                Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
                DiscountApplied = "Y"
                
                End If   
                
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

<%	

Response.Write "<BR><BR><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=2><H3>Congratulations!</H3></FONT>" & vbCrLf

'=========================================================
'Inform patron the number of free tickets on current order

CurrentCount = 0

SQLCurrent = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE OrderHeader.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " "
Set rsCurrent = OBJdbConnection.Execute(SQLCurrent)
CurrentCount = rsCurrent("TicketCount")
rsCurrent.Close
Set rsCurrent = nothing

Response.Write "<CENTER><TABLE border=""0""><TR VALIGN=""middle""><TD><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=3>Your " &  MemberEventName & " has qualified you for" & vbCrLf

If CurrentCount = 1 Then
Response.Write "1 discounted ticket" & vbCrLf 
Else
Response.Write "" &  CurrentCount & " discounted tickets" & vbCrLf 
End If

Response.Write "on this order.<BR><BR><HR></TD></TR>" & vbCrLf
'=========================================================
'Inform patron the number of free tickets left

RemainderCount = 0

'Number of total free tickets
SQLFreeTickets = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE (OrderHeader.CustomerNumber = " & Session("CustomerNumber") & " OR OrderHeader.OrderNumber = " & Session("OrderNumber") & ") AND Seat.EventCode = " & CleanNumeric(MemberEventCode)
Set rsFreeTickets = OBJdbConnection.Execute(SQLFreeTickets)

NumberFreeTickets = (PossibleFreeTickets * rsFreeTickets("TicketCount"))

rsFreeTickets.Close
Set rsFreeTickets = nothing

'Number of free tickets already given
AppliedCount = 0
SQLApplied = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE OrderHeader.OrderNumber <>(" & Session("OrderNumber") & ") AND OrderHeader.CustomerNumber = " & Session("CustomerNumber") & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.StatusCode = 'S'"
Set rsApplied = OBJdbConnection.Execute(SQLApplied)
AppliedCount = rsApplied("TicketCount")
rsApplied.Close
Set rsApplied = nothing

RemainderCount = (NumberFreeTickets - (AppliedCount + CurrentCount))

If RemainderCount = 0 Then
Response.Write "<TR><TD ALIGN=""center""><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=2><BR>There are now no discounted tickets left on your season subscription.</FONT></TR></TD>" & vbCrLf
End If

If RemainderCount = 1 Then
Response.Write "<TR><TD ALIGN=""center""><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=2><BR>There is now 1 ticket left on your season subscription.</FONT></TR></TD>" & vbCrLf
End If

If RemainderCount > 1 Then
Response.Write "<TR><TD ALIGN=""center""><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=2><BR>There are now " &  RemainderCount & " tickets left on your season subscription.</FONT></TR></TD>" & vbCrLf
End If

'=========================================================
'Inform patron that preview events do not qualify

SQLExcludeTickets = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE (OrderHeader.CustomerNumber = " & Session("CustomerNumber") & " OR OrderHeader.OrderNumber = " & Session("OrderNumber") & ") AND Seat.EventCode IN (" & ExcludeEventCode & ")"
Set rsExcludeTickets = OBJdbConnection.Execute(SQLExcludeTickets)
ExcludeCount = rsExcludeTickets("TicketCount")
rsExcludeTickets.Close
Set rsExcludeTickets = nothing

If ExcludeCount => 1 Then
Response.Write "<TR><TD ALIGN=""center""><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=2><BR>Preview events do not qualify for a season subscription discount.</FONT></TR></TD>" & vbCrLf
End If
'=========================================================
'Prevent box office users from completing the order


Session("SurveyComplete") = Session("OrderNumber")

'If order is Phone (2), Fax (3), Mail (4), Comp (5) or  BoxOffice (7)
If Session("OrderTypeNumber") = 2 Or Session("OrderTypeNumber") = 4 Or Session("OrderTypeNumber") = 5 Or Session("OrderTypeNumber") = 7 Then

Response.Write "<TR><TD ALIGN=""center""><BR><HR><FONT FACE=""" & FontFace & """ COLOR=""#FF0000""><H3>PLEASE NOTE:<BR>This order can not be processed at the box office.<BR>Please ask the patron to enter this order at home.</H3></FONT><HR>" & vbCrLf
Response.Write "<FORM ACTION=""/ShoppingCart.asp"" METHOD=""POST"" id=form1 name=form1>" & vbCrLf

Else

	If Session("UserNumber") = "" Then
	Response.Write "<TR><TD ALIGN=""center""><FORM ACTION=""/Ship.asp"" METHOD=""POST"" id=form1 name=form1>" & vbCrLf
	Else
	Response.Write "<TR><TD ALIGN=""center""><FORM ACTION=""/Management/AdvanceShip.asp"" METHOD=""POST"" id=form1 name=form1>" & vbCrLf
	End If

End If

Response.Write "<BR><BR><INPUT TYPE=""submit"" VALUE=""Continue"" id=1 name=1></FORM></CENTER></TD></TR></TABLE></CENTER><BR><BR>" & vbCrLf

%>

<!--#INCLUDE virtual="FooterInclude.asp"-->

<%	

Response.Write "</BODY>" & vbCrLf
Response.Write "</HTML>" & vbCrLf

		
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