<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%

'Carousel Dinner Theater (3/20/2010)
'2010 Season Subscription Discount

'5 Show Subscription - Evening
'Patron is entited to 1 free ticket to all 5 evening productions:

'48596   Defending the Caveman 
'48597   Aida 
'48603   42nd Street 
'48601   Smokey Joe's Cafe 
'48608   Annie Get Your Gun 


'5 Show Subscription - Matinee
'Patron is entited to 1 free ticket to all 5 matinee productions:

'49247 Defending the Caveman 
'49248 Aida 
'49249 42nd Street
'49250 Smokey Joe's Cafe 
'49251 Annie Get Your Gun 


'3 Show Subscription
'Patron is entited to 1 free ticket to any 3 different productions
'which are listed above

'List of valid ticket types:
'Adult, Senior, Student

Page = "Survey"
EventCode = Clean(Request("EventCode"))

SurveyNumber = 745

DiscountAmount = 1.0 '100% Discount
AllowedSeatType = "1,3,6"

DiscountTypeNumber = 43768

MemberEventCode = 250633 '5 Show Evening Subscription
MatineeEventCode = 250632 '5 Show Matinee Subscription
ThreeEventCode = 250631  '3 Show Subscription


'===================================

'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If

'Check to see if this is a Comp Order. If so, skip discount.
If Session("OrderTypeNumber") = 5 Then
	Call Continue
Else
    Call MemberEventCheck
End If

'===================================

Sub MemberEventCheck '5 Show Evening Subscription

MemberEvent = ""

'Check if the member event code is in order
SQLMemberEvent = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE EventCode = " & CleanNumeric(MemberEventCode) & " AND OrderLine.OrderNumber = " & CleanNumeric(Session("OrderNumber"))
Set rsMemberEvent = OBJdbConnection.Execute(SQLMemberEvent)
If Not rsMemberEvent.EOF Then 'it is in order
    MemberEventCount = rsMemberEvent("TicketCount")
End If
rsMemberEvent.Close
Set rsMemberEvent = nothing

MemberEventCount2 = ""

'check if this customer has purchased this member event code before
SQLMemberBefore = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE CustomerNumber = " & CleanNumeric(Session("CustomerNumber")) & " AND EventCode = " & CleanNumeric(MemberEventCode) & " AND OrderHeader.OrderNumber <> " & CleanNumeric(Session("OrderNumber"))
Set rsMemberBefore = OBJdbConnection.Execute(SQLMemberBefore)
If Not rsMemberBefore.EOF Then
    MemberEventCount2 = rsMemberBefore("TicketCount")
End If
rsMemberBefore.Close
Set rsMemberBefore = nothing
'End If

If MemberEventCount >= 1 Or MemberEventCount2 >= 1 Then 
    ProductionFreeList = "48596,48597,48601,48603,48608"
	Call ApplyFiveDiscount(ProductionFreeList,MemberEventCount,MemberEventCount2)
Else
	Call MatineeEventCheck
End If

End Sub 'MemberEventCheck


'===================================

Sub MatineeEventCheck '5 Show Matinee Subscription

MemberEvent = ""

'Check if the Matinee event code is in order
SQLMatineeEvent = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE EventCode = " & CleanNumeric(MatineeEventCode) & " AND OrderLine.OrderNumber = " & CleanNumeric(Session("OrderNumber"))
Set rsMatineeEvent = OBJdbConnection.Execute(SQLMatineeEvent)
If Not rsMatineeEvent.EOF Then 'it is in order
    MemberEventCount = rsMatineeEvent("TicketCount")
End If
rsMatineeEvent.Close
Set rsMatineeEvent = nothing

MemberEventCount2 = ""

'Check if this customer has purchased this Matinee event code before
SQLMatineeBefore = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE CustomerNumber = " & CleanNumeric(Session("CustomerNumber")) & " AND EventCode = " & CleanNumeric(MatineeEventCode) & " AND OrderHeader.OrderNumber <> " & CleanNumeric(Session("OrderNumber"))
Set rsMatineeBefore = OBJdbConnection.Execute(SQLMatineeBefore)
If Not rsMatineeBefore.EOF Then
    MemberEventCount2 = rsMatineeBefore("TicketCount")
End If
rsMatineeBefore.Close
Set rsMatineeBefore = nothing


If MemberEventCount >= 1 Or MemberEventCount2 >= 1 Then 
    ProductionFreeList = "49247,49248,49249,49250,49251"
	Call ApplyFiveDiscount(ProductionFreeList,MemberEventCount,MemberEventCount2)
Else
	Call ThreeEventCheck
End If


End Sub 'MatineeEventCheck

'===================================

Sub ThreeEventCheck

MemberEvent = ""

'Check if the Three event code is in order
SQLThreeEvent = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE EventCode = " & CleanNumeric(ThreeEventCode) & " AND OrderLine.OrderNumber = " & CleanNumeric(Session("OrderNumber"))
Set rsThreeEvent = OBJdbConnection.Execute(SQLThreeEvent)
If Not rsThreeEvent.EOF Then 'it is in order
    MemberEventCount = rsThreeEvent("TicketCount")
End If
rsThreeEvent.Close
Set rsThreeEvent = nothing

MemberEventCount2 = ""

'check if this customer has purchased this Three event code before
SQLThreeBefore = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE CustomerNumber = " & CleanNumeric(Session("CustomerNumber")) & " AND EventCode = " & CleanNumeric(ThreeEventCode) & " AND OrderHeader.OrderNumber <> " & CleanNumeric(Session("OrderNumber"))
Set rsThreeBefore = OBJdbConnection.Execute(SQLThreeBefore)
If Not rsThreeBefore.EOF Then
    MemberEventCount2 = rsThreeBefore("TicketCount")
End If
rsThreeBefore.Close
Set rsThreeBefore = nothing
'End If

If MemberEventCount >= 1 Or MemberEventCount2 >= 1 Then 
    ProductionFreeList = "49247,49248,49249,49250,49251,48596,48597,48601,48603,48608"
	Call ApplyThreeDiscount(ProductionFreeList,MemberEventCount,MemberEventCount2)
Else
	Call Continue
End If

End Sub 'ThreeEventCheck


'===================================

Sub ApplyFiveDiscount(ProductionFreeList,MemberEventCount,MemberEventCount2)

ProductionList = Split(ProductionFreeList,",")

If MemberEventCount2 >= 1 Then 'calculate total tickets free
    MemberEventCount = MemberEventCount + MemberEventCount2
End If

For ActCd = lbound(ProductionList) to ubound(ProductionList)
    ApplyDiscountOK = false
    'Check if this production has given away free tickets before
    SQLDiscCheck = "SELECT OrderLine.LineNumber FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE CustomerNumber = " & CleanNumeric(Session("CustomerNumber")) & " AND ActCode = " & CleanNumeric(ProductionList(ActCd)) & " AND OrderHeader.OrderNumber <> " & CleanNumeric(Session("OrderNumber"))
    Set rsDiscCheck = OBJdbConnection.Execute(SQLDiscCheck)
    If rsDiscCheck.EOF Then 
        ApplyDiscountOK = true
    End If
    rsDiscCheck.Close
    Set rsDiscCheck = Nothing
    
    If ApplyDiscountOK Then 'it is okay to give free tickets
        SQLLineNo = "SELECT TOP(" & MemberEventCount & ") LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN EVENT (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND ActCode = " & ProductionList(ActCd) & " ORDER BY LineNumber DESC"
        Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)
        If Not rsLineNo.EOF Then
            Do While Not rsLineNo.EOF
                SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = Price * " & DiscountAmount & ", Surcharge = 0, DiscountTypeNumber = " & DiscountTypeNumber & " WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber")
                Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
                rsLineNo.movenext
            Loop
        End If
        rsLineNo.Close
        Set rsLineNo = Nothing
    End If
Next

Call DBClose(OBJdbConnection)

If ApplyDiscountOK Then
	Call WarningPage
Else
	Call Continue
End If

End Sub 'ApplyFiveDiscount

'=================================

Sub ApplyThreeDiscount(ProductionFreeList,MemberEventCount,MemberEventCount2)

ProductionList = Split(ProductionFreeList,",")

If MemberEventCount2 >= 1 Then 'calculate total tickets free
    MemberEventCount = MemberEventCount + MemberEventCount2
End If



    For ActCd = lbound(ProductionList) to ubound(ProductionList)
        ApplyDiscountOK = false
        'Check if this production has given away free tickets before
        SQLDiscCheck = "SELECT OrderLine.LineNumber FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE CustomerNumber = " & CleanNumeric(Session("CustomerNumber")) & " AND ActCode = " & CleanNumeric(ProductionList(ActCd)) & " AND OrderHeader.OrderNumber <> " & CleanNumeric(Session("OrderNumber"))
        Set rsDiscCheck = OBJdbConnection.Execute(SQLDiscCheck)
        If rsDiscCheck.EOF Then 
            ApplyDiscountOK = true
        End If
        rsDiscCheck.Close
        Set rsDiscCheck = Nothing
        
        If ApplyDiscountOK Then 'it is okay to give free tickets
            SQLLineNo = "SELECT TOP(" & MemberEventCount & ") LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN EVENT (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND ActCode = " & ProductionList(ActCd) & " ORDER BY LineNumber DESC"
            Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)
            
            If Not rsLineNo.EOF Then
                Do While Not rsLineNo.EOF
                    SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = Price * " & DiscountAmount & ", Surcharge = 0, DiscountTypeNumber = " & DiscountTypeNumber & " WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber")
                    Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
                    rsLineNo.movenext
                Loop
            End If
            
            rsLineNo.Close
            Set rsLineNo = Nothing
        End If
    Next
    

Call DBClose(OBJdbConnection)

If ApplyDiscountOK Then
	Call WarningPage
Else
	Call Continue
End If

End Sub 'ApplyFiveDiscount

'========================================

Sub WarningPage(AppliedCount,NbrSubscriptions)

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
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3>Congratulations!!</H3></FONT>

<%
If Session("UserNumber") = "" Then
	Response.Write "<CENTER><TABLE><TR><TD><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=2>Your membership has qualified you for a discount on this order.<BR><BR>AppliedCount: " & AppliedCount & "<CENTER><FORM ACTION=""/Ship.asp"" METHOD=""POST"" id=form1 name=form1><INPUT TYPE=""submit"" VALUE=""Continue"" id=1 name=1></FORM></CENTER></TD></TR></TABLE></CENTER><BR><BR>" & vbCrLf
Else
	Response.Write "<CENTER><TABLE><TR><TD><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=2>Your membership has qualified you for a discount on this order.<BR><BR>AppliedCount: " & AppliedCount & "<BR>NbrSubscriptions: " & NrbSubscriptions & "<CENTER><FORM ACTION=""/Management/AdvanceShip.asp"" METHOD=""POST"" id=form1 name=form1><INPUT TYPE=""submit"" VALUE=""Continue"" id=1 name=1></FORM></CENTER></TD></TR></TABLE></CENTER><BR><BR>" & vbCrLf
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