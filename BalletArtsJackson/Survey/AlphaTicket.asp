
<!--#INCLUDE virtual=/PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=/GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=/DBOpenInclude.asp -->
<%
'Survey which requires the purchase of Alpha ticket in order in order to be allowed purchase of Beta ticket. - SSR

'Initialize Variables
Page = "Survey"
SurveyNumber = 443

AlphaName = "Father" 'Name of Alpha Ticket
BetaName = "Daughter" 'Name of Beta Ticket
AlphaList = "711" 'List of Alpha Seat Type Codes
BetaList = "3937" 'List of Beta Seat Type Codes

WarningHeader = "PLEASE NOTE" 'Warning Page Header
Restriction = "Daugthers must be accompanied by at least one Father." 'Warning Page Explanation


'Check to see if this is a Internet (1), Phone (2), Fax (3), Mail (4), Comp (5), Box Office (7) Order. If so, continue with restriction.
If Session("OrderTypeNumber") = 1 Or Session("OrderTypeNumber") = 2 Or Session("OrderTypeNumber") = 3 Or Session("OrderTypeNumber") = 4 Or Session("OrderTypeNumber") = 5 Or Session("OrderTypeNumber") = 7 Then

Call TicketCount

'----------------------------
Sub TicketCount

'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If


'Count number of Beta tickets
SQLBetaCount = "SELECT COUNT(ItemNumber) AS BetaCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber")	& " AND OrderLine.SeatTypeCode IN (" & BetaList & ")"
Set rsBetaCount = OBJdbConnection.Execute(SQLBetaCount)

BetaCount = rsBetaCount("BetaCount")

rsBetaCount.Close
Set rsBetaCount = nothing

'Count number of Alpha tickets
SQLAlphaCount = "SELECT COUNT(ItemNumber) AS AlphaCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber")	& " AND OrderLine.SeatTypeCode IN (" & AlphaList & ")"
Set rsAlphaCount = OBJdbConnection.Execute(SQLAlphaCount)

AlphaCount = rsAlphaCount("AlphaCount")

rsAlphaCount.Close
Set rsAlphaCount = nothing



If AlphaCount < 1 Or BetaCount < 1 Then 'Cannot have 1 Alpha or 1 Beta tickets on order than Alpha. Go to warning page
		
	Call WarningPage (AlphaCount, BetaCount)
		
	Exit Sub

End If
				

Session("SurveyComplete") = Session("OrderNumber")

If Session("OrderTypeNumber") = 1 Then
	Response.Redirect("/Ship.asp")
Else
	Response.Redirect("/Management/AdvanceShip.asp")
End If

End Sub 'TicketCount
			
				
'----------------------------

Sub WarningPage (AlphaCount, BetaCount)

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & Title & "</TITLE>" & vbCrLf
Response.Write "</HEAD>" & vbCrLf

Response.Write "<BODY BGCOLOR=" & BGColor & " LINK="& LinkColor & " ALINK=" & ALinkColor & " VLINK=" & VLinkColor & " leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0 " & BodyParameters & ">" & vbCrLf
					
%>

<!--#INCLUDE virtual="/TopNavInclude.asp"-->

<BR>
<BR>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H2><%= WarningHeader %></H2></FONT>

<%

If AlphaCount < 1 Then
MissingName = AlphaName
Else
MissingName = BetaName
End If

If Session("UserNumber") = "" Then ' Display message for patron
	Response.Write "<CENTER><TABLE><TR><TD><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=2><CENTER><B>"& Restriction &"</B><BR><BR>Please update your order with at least 1 "& MissingName &" ticket<BR><CENTER><FORM ACTION=""/ShoppingCart.asp"" METHOD=""POST"" id=form1 name=form1><INPUT TYPE=""submit"" VALUE=""&nbsp;&nbsp;&nbsp;&nbsp;OK&nbsp;&nbsp;&nbsp;&nbsp;"" id=1 name=1></FORM></CENTER></TD></TR></TABLE></CENTER><BR><BR>" & vbCrLf
Else ' Display message for box office
	Response.Write "<CENTER><TABLE><TR><TD><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=2><CENTER><B>"& Restriction &"</B><BR><BR>Please update your order with at least 1 "& MissingName &" ticket<BR><CENTER><FORM ACTION=""/Management/ShoppingCart.asp"" METHOD=""POST"" id=form1 name=form1><INPUT TYPE=""submit"" VALUE=""&nbsp;&nbsp;&nbsp;&nbsp;OK&nbsp;&nbsp;&nbsp;&nbsp;"" id=1 name=1></FORM></CENTER></TD></TR></TABLE></CENTER><BR><BR>" & vbCrLf
End If

%>

<!--#INCLUDE virtual="/FooterInclude.asp"-->

</BODY>
</HTML>

<%			
End Sub 'Warning Page

End If

%>



