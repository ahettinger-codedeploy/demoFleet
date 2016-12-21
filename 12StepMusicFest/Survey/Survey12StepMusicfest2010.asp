<!--#INCLUDE virtual=/PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=/GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=/DBOpenInclude.asp -->
<%
Page = "Survey"

SurveyNumber = 560

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

If Session("UserNumber") = "" Then 'Do not run this survey if box office user

'Count number of 3-Night RV Sites
SQLVIPCampCount = "SELECT COUNT(ItemNumber) AS VIPCampCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber")	& " AND SeatTypeCode IN (4874,4873,4869)"
Set rsVIPCampCount = OBJdbConnection.Execute(SQLVIPCampCount)

'Count number of 4-Day Passes
SQLVIPPassCount = "SELECT COUNT(ItemNumber) AS VIPPassCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber")	& " AND SeatTypeCode IN (1736,2756)"
Set rsVIPPassCount = OBJdbConnection.Execute(SQLVIPPassCount)


	If rsVIPCampCount("VIPCampCount") > rsVIPPassCount("VIPPassCount") Then 'Need to purchase more VIP Pass Tickets.  Go to warning page
	
		Message = "You are purchasing an RV/Camping site.  You MUST purchase either a 3-day or a 4-Day ticket."

		Call WarningPage(Message)

		Exit Sub

	End If


rsVIPCampCount.Close
Set rsVIPCampCount = nothing

rsVIPPassCount.Close
Set rsVIPPassCount = nothing






OBJdbConnection.Close
Set OBJdbConnection = nothing

End If

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



