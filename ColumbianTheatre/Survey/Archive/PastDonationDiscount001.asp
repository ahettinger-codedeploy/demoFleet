<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%
Page = "Survey"

SurveyNumber = 149
DiscountTypeNumber = 29138 'Does not need to be attached to events
DiscountAmount = 1
ItemList = "349,350,351,354,380,479"
AllowedSeatType = "1008,1012,1011,1015"

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



'Check for the donation item numbers in the past year.
SQLMemberEvent = "SELECT COUNT(OrderLine.ItemNumber) AS TicketCount FROM OrderHeader (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber WHERE (OrderLine.ItemNumber IN (" & ItemList & ")) AND (CustomerNumber = " & Session("CustomerNumber") & " AND OrderHeader.StatusCode = 'S' OR OrderHeader.OrderNumber = " & Session("OrderNumber") & ") AND GetDate() < DateAdd(day, 365, OrderDate)"
Set rsMemberEvent = OBJdbConnection.Execute(SQLMemberEvent)

MemberItemCount = rsMemberEvent("TicketCount")

rsMemberEvent.Close
Set rsMemberEvent = nothing


If MemberItemCount > 0 Then
	Call ApplyDiscount
Else
	Call Continue
End If


'==============================

Sub ApplyDiscount


SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = " & DiscountAmount & ", DiscountTypeNumber = " & DiscountTypeNumber & " WHERE OrderNumber = " & Session("OrderNumber") & " AND (OrderLine.SeatTypeCode IN (" & AllowedSeatType & ")) AND OrderLine.ItemNumber IN (SELECT ItemNumber FROM Seat (NOLOCK) INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE Event.SurveyNumber = " & SurveyNumber & ")"
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
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3>Congratulations!!</H3></FONT>

<%
If Session("UserNumber") = "" Then
	Response.Write "<CENTER><TABLE><TR><TD><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=2>Your past donation has qualified you for a discount on any of the following tickets: Adult Show Only, Adult Show & Buffet, Child Show Only, Child Show & Buffet.<BR><BR><CENTER><FORM ACTION=""/Ship.asp"" METHOD=""POST"" id=form1 name=form1><INPUT TYPE=""submit"" VALUE=""Continue"" id=1 name=1></FORM></CENTER></TD></TR></TABLE></CENTER><BR><BR>" & vbCrLf
Else
	Response.Write "<CENTER><TABLE><TR><TD><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=2>Your past donation has qualified you for a discount on any of the following tickets: Adult Show Only, Adult Show & Buffet, Child Show Only, Child Show & Buffet.<BR><BR><CENTER><FORM ACTION=""/Management/AdvanceShip.asp"" METHOD=""POST"" id=form1 name=form1><INPUT TYPE=""submit"" VALUE=""Continue"" id=1 name=1></FORM></CENTER></TD></TR></TABLE></CENTER><BR><BR>" & vbCrLf
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

