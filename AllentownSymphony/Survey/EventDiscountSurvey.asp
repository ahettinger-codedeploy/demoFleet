<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%
Page = "Survey"

SurveyNumber = 584

'Survey Variables
MemberEventList = 192291
DiscountTypeNumber = 37258
DiscountAmount = 1
ProductionFreeList = "3891"
TotalFreeTickets = 1


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
End If


'Check for a ticket to the Member Event(s)on current order or on any other order in the past year
SQLMemberEvent = "SELECT COUNT(OrderLine.ItemNumber) AS TicketCount FROM OrderHeader (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE EventCode IN (" & MemberEventList & ") AND (CustomerNumber = " & Session("CustomerNumber") & " AND OrderHeader.StatusCode = 'S' OR OrderHeader.OrderNumber = " & Session("OrderNumber") & ") AND GetDate() < DateAdd(day, 365, OrderDate)"
Set rsMemberEvent = OBJdbConnection.Execute(SQLMemberEvent)

MemberEventCount = rsMemberEvent("TicketCount")

rsMemberEvent.Close
Set rsMemberEvent = nothing

If MemberEventCount > 0 Then 
	Call ApplyDiscount
Else
	Call Continue
End If


'==============================

Sub ApplyDiscount

SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = Price * " & DiscountAmount & ", DiscountTypeNumber = " & DiscountTypeNumber & " WHERE OrderNumber = " & Session("OrderNumber") & " AND OrderLine.ItemNumber IN (SELECT ItemNumber FROM Seat (NOLOCK) INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE Event.SurveyNumber = " & SurveyNumber & ")"
Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)

Call DBClose(OBJdbConnection)
	
Call WarningPage

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

<BR>
<BR>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3><IMG SRC="/PrivateLabel/AllentownSymphony/Survey/stars.gif">Congratulations!!<IMG SRC="/PrivateLabel/AllentownSymphony/Survey/stars.gif"></H3></FONT><IMG SRC="/stars.gif">

<%
If Session("UserNumber") = "" Then
	Response.Write "<CENTER><TABLE><TR><TD><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=2>Your membership has qualified you for a discount on this order.<BR><BR><CENTER><FORM ACTION=""/Ship.asp"" METHOD=""POST"" id=form1 name=form1><INPUT TYPE=""submit"" VALUE=""Continue"" id=1 name=1></FORM></CENTER></TD></TR></TABLE></CENTER><BR><BR>" & vbCrLf
Else
	Response.Write "<CENTER><TABLE><TR><TD><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=2>Your membership has qualified you for a discount on this order.<BR><BR><CENTER><FORM ACTION=""/Management/AdvanceShip.asp"" METHOD=""POST"" id=form1 name=form1><INPUT TYPE=""submit"" VALUE=""Continue"" id=1 name=1></FORM></CENTER></TD></TR></TABLE></CENTER><BR><BR>" & vbCrLf
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

