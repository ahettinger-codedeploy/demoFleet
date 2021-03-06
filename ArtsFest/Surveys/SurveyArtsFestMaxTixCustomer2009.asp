<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<!--#include virtual="NoCacheInclude.asp"-->
<%

Page = "Survey"
SurveyNumber = 529

MaxAllowed = 4
OnlineFlag = "Y"
OfflineFlag = "Y"

MaxCheck = "N"

If Session("UserNumber") = "" And OnlineFlag = "Y" Then
		MaxCheck = "Y"
End If

If Session("UserNumber") <> "" And OfflineFlag = "Y" Then
	MaxCheck = "Y"
End If

If MaxCheck = "Y" Then

	'Update OrderHeader with this Session(CustomerNumber) if it hasn't been already.
	SQLCustomerNumber = "UPDATE OrderHeader WITH (ROWLOCK) SET CustomerNumber = " & Session("CustomerNumber") & " WHERE OrderHeader.OrderNumber = " & Session("OrderNumber") & " AND OrderHeader.CustomerNumber = 1"
	Set rsCustomerNumber = OBJdbConnection.Execute(SQLCustomerNumber)

	'Count the number of tickets for this customer for any event with this survey number
	SQLMax = "SELECT COUNT(OrderLine.ItemNumber) AS TicketCount FROM OrderHeader(NOLOCK) INNER JOIN OrderLine(NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber INNER JOIN Seat(NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event(NOLOCK) ON Seat.EventCode = Event.EventCode WHERE Event.EventCode IN (SELECT EventCode FROM Seat(NOLOCK) WHERE Event.SurveyNumber = " & SurveyNumber & ") AND CustomerNumber = " & Session("CustomerNumber") & " AND CustomerNumber <> 1"
	Set rsMax = OBJdbConnection.Execute(SQLMax)

	MaxTickets = rsMax("TicketCount")

	rsMax.Close
	Set rsMax = nothing

	'REE 8/8/6 - Added Session UserNumber for offline orders only.
	If MaxTickets > MaxAllowed Then
		'Display Message
		Response.Write "<HTML>" & vbCrLf
		Response.Write "<HEAD>" & vbCrLf
		Response.Write "<TITLE>" & Title & "</TITLE>" & vbCrLf
		Response.Write "</HEAD>" & vbCrLf

	%>
		<!--#INCLUDE virtual="TopNavInclude.asp"-->
		<BR>
		<BR>
		<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3>Ticket Maximum Exceeded</H3></FONT>
		<BR>
	<%
		If Session("UserNumber") = "" Then
			Response.Write "<FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=""2"">The maximum number of tickets allowed per customer for events you have selected is " & MaxAllowed & ".<BR><BR>Please <A HREF=""/ShoppingCart.asp"">click here</A> to return to your Shopping Cart and remove the additional tickets.<BR></FONT>" & vbCrLf
		Else
			Response.Write "<FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=""2"">The maximum number of tickets allowed per customer is " & MaxAllowed & ".<BR><BR>Please <A HREF=""/Management/ShoppingCart.asp"">click here</A> to return to your Shopping Cart and remove the additional tickets.<BR></FONT>" & vbCrLf
		End If
	%>
		</CENTER>
		<!--#INCLUDE virtual="FooterInclude.asp"-->
		</BODY>
		</HTML>
	<%		

	Else

		If Session("UserNumber") = "" Then 'It's not management

			Session("SurveyComplete") = Session("OrderNumber")
			Response.Redirect("/Ship.asp")
		
		Else 'It's management

			Session("SurveyComplete") = Session("OrderNumber")
			Response.Redirect("/Management/AdvanceShip.asp")
		
		End If
		
		
	End If
	
Else

	If Session("UserNumber") = "" Then 'It's not management

		Session("SurveyComplete") = Session("OrderNumber")
		Response.Redirect("/Ship.asp")
		
	Else 'It's management

		Session("SurveyComplete") = Session("OrderNumber")
		Response.Redirect("/Management/AdvanceShip.asp")
		
	End If

End If
		


%>


