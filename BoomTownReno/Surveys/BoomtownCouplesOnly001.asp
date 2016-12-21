<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%
Page = "Survey"

SurveyNumber = 748
'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If

If Session("UserNumber") = "" Or Session("UserType") = "C" Then 'Internet or Call Center

	SQLTicketCount = "SELECT Event.EventCode, EventDate, Act, COUNT(LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Section ON Seat.SectionCode = Section.SectionCode AND Seat.EventCode = Section.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Event.SurveyNumber = " & SurveyNumber & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') GROUP BY Event.EventCode, EventDate, Act ORDER BY Event.EventCode, EventDate"
	Set rsTicketCount = OBJdbConnection.Execute(SQLTicketCount)
			
	OddOrder = FALSE
	Do Until rsTicketCount.EOF
		Remainder = rsTicketCount("TicketCount") Mod 2

		If Remainder <> 0 Then
				OddOrder = TRUE
				Message = Message & "<B>" & rsTicketCount("Act") & " on " & FormatDateTime(rsTicketCount("EventDate"), VBLongDate) & " at " & Left(FormatDateTime(rsTicketCount("EventDate"), vbLongTime), Len(FormatDateTime(rsTicketCount("EventDate"), vbLongTime))-6) & " " & Right(FormatDateTime(rsTicketCount("EventDate"),vbLongTime), 2) & "</B><BR>"
		End If
		rsTicketCount.MoveNext
	Loop
	rsTicketCount.Close
	Set rsTicketCount = nothing

	If OddOrder Then
						
		Call WarningPage					
	Else
						
		OBJdbConnection.Close
		Set OBJdbConnection = nothing
						
		Session("SurveyComplete") = Session("OrderNumber")
		If Session("UserNumber") = "" Then
			Response.Redirect("/Ship.asp")
		Else
			Response.Redirect("/Management/AdvanceShip.asp")
		End If		
	End If
						
Else
						
	OBJdbConnection.Close
	Set OBJdbConnection = nothing
						
	Session("SurveyComplete") = Session("OrderNumber")
	Response.Redirect("/Management/AdvanceShip.asp")
					
End If

OBJdbConnection.Close
Set OBJdbConnection = nothing



'----------------------------

Sub WarningPage

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & Title & "</TITLE>" & vbCrLf
Response.Write "</HEAD>" & vbCrLf

Response.Write "<BODY BGCOLOR=" & BGColor & " LINK="& LinkColor & " ALINK=" & ALinkColor & " VLINK=" & VLinkColor & " leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0 " & BodyParameters & ">" & vbCrLf
					
%>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<BR>
<BR>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3>Please Note:</H3></FONT>

<%
Response.Write "<TABLE WIDTH=""80%""><TR><TD><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=2>Package tickets must be purchased in sets of 2.  In order to complete your purchase, please click on ""Shopping Cart"" to add or remove the appropriate number of tickets.</FONT><BR><BR><BR>" & vbCrLf
If Session("UserNumber") = "" Then
	Response.Write "<CENTER><FORM ACTION=""/ShoppingCart.asp"" METHOD=""POST""><INPUT TYPE=""submit"" VALUE=""Shopping Cart""></FORM>" & vbCrLf
Else
	Response.Write "<CENTER><FORM ACTION=""/Management/EventSelection.asp"" METHOD=""POST""><INPUT TYPE=""submit"" VALUE=""Back to Shopping""></FORM>" & vbCrLf
End If
Response.Write "</CENTER></TD></TR></TABLE><BR><BR>" & vbCrLf
%>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%			
End Sub 'Warning Page
%>

