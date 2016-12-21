<!--#INCLUDE virtual=/PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=/GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=/DBOpenInclude.asp -->
<%
Page = "Survey"

SurveyNumber = 377

Call TicketCount

Sub TicketCount

'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If


'Count number of RV Sites
SQLVIPCampCount = "SELECT COUNT(ItemNumber) AS VIPCampCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber")	& " AND SeatTypeCode IN (2434)"
Set rsVIPCampCount = OBJdbConnection.Execute(SQLVIPCampCount)

'Count number of 4-Day VIP Passes
SQLVIPPassCount = "SELECT COUNT(ItemNumber) AS VIPPassCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber")	& " AND SeatTypeCode=2436"
Set rsVIPPassCount = OBJdbConnection.Execute(SQLVIPPassCount)


	If rsVIPCampCount("VIPCampCount") > rsVIPPassCount("VIPPassCount") Then 'Need to purchase more VIP Pass Tickets.  Go to warning page
	
		Message = "You are purchasing a 4-Day RV site.  You MUST purchase a 4-Day ticket."

		Call WarningPage(Message)

		Exit Sub

	End If


rsVIPCampCount.Close
Set rsVIPCampCount = nothing

rsVIPPassCount.Close
Set rsVIPPassCount = nothing


'REE 12/15/7 - Modified to include regular campsite restrictions.

'Count number of Regular Camp Sites
SQLCampCount = "SELECT COUNT(ItemNumber) AS CampCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber")	& " AND SeatTypeCode=2435"
Set rsCampCount = OBJdbConnection.Execute(SQLCampCount)

'Count number of 3-Day Passes
SQLPassCount = "SELECT COUNT(ItemNumber) AS PassCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber")	& " AND SeatTypeCode IN (2437)"
Set rsPassCount = OBJdbConnection.Execute(SQLPassCount)


	If rsCampCount("CampCount") > rsPassCount("PassCount") Then 'Need to purchase more 3-Day passes.  Go to warning page
	
		Message = "You are purchasing a 3-Day RV site.  You MUST purchase a 3-Day ticket"

		Call WarningPage(Message)

		Exit Sub

	End If


rsCampCount.Close
Set rsCampCount = nothing

rsPassCount.Close
Set rsPassCount = nothing



OBJdbConnection.Close
Set OBJdbConnection = nothing

Session("SurveyComplete") = Session("OrderNumber")

If Session("UserNumber") = "" Then
	Response.Redirect("/Ship.asp")
Else
	Response.Redirect("/Management/AdvanceShip.asp")
End If

End Sub 'TicketCount
			
				
'----------------------------

Sub WarningPage(Message)

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & Title & "</TITLE>" & vbCrLf
Response.Write "</HEAD>" & vbCrLf

Response.Write "<BODY BGCOLOR=" & BGColor & " LINK="& LinkColor & " ALINK=" & ALinkColor & " VLINK=" & VLinkColor & " leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0 " & BodyParameters & ">" & vbCrLf
					
%>

<!--#INCLUDE virtual="/TopNavInclude.asp"-->

<BR>
<BR>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3>Notice</H3></FONT>

<%

If Session("UserNumber") = "" Then
	ShoppingCartLink="/ShoppingCart.asp"
Else
	ShoppingCartLink="/Management/ShoppingCart.asp"
End If
Response.Write "<CENTER><TABLE><TR><TD Align=center><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=2>" & Message & "<BR><BR><CENTER><FORM ACTION=""" & ShoppingCartLink & """ METHOD=""POST"" id=form1 name=form1><INPUT TYPE=""submit"" VALUE=""Back to Shopping"" id=1 name=1></FORM></CENTER></TD></TR></TABLE></CENTER><BR><BR>" & vbCrLf
%>

<!--#INCLUDE virtual="/FooterInclude.asp"-->

</BODY>
</HTML>

<%			
End Sub 'Warning Page
%>



