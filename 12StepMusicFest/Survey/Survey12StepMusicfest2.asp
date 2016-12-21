
<!--#INCLUDE virtual=/PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=/GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=/DBOpenInclude.asp -->
<%
'Survey which requires the purchase of Alpha ticket in order in order to be allowed purchase of Beta ticket. - SSR

'Initialize Variables
Page = "Survey"
SurveyNumber = 443

AlphaName = "Music Fest 4 Day VIP" 'Name of Alpha Ticket
BetaName = "Camping Event 3 Night" 'Name of Beta Ticket
AlphaList = "2436" 'List of Alpha Seat Type Codes
BetaList = "2772,2774,2773" 'List of Beta Seat Type Codes

Alpha2Name = "Music Fest 3 Day VIP" 'Name of Alpha2 Ticket
Beta2Name = "Camping Event 2 Night" 'Name of Beta2 Ticket
Alpha2List = "2437" 'List of Alpha2 Seat Type Codes
Beta2List = "2777,2779,2778" 'List of Beta2 Seat Type Codes

WarningHeader = "WARNING" 'Warning Page Header
Restriction = "Each 3 Night Camping ticket<BR>must be accompanied by a 4 Day Music Fest ticket." 'Warning Page Explanation
Restriction2 = "Each 2 Night Camping ticket<BR>must be accompanied by a 3 Day Music Fest ticket." 'Warning Page Explanation

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



If BetaCount > AlphaCount Then 'Cannot have more Beta tickets on order than Alpha. Go to warning page
		
	Call WarningPage (AlphaCount, BetaCount)
		
	Exit Sub

End If


'Count number of Beta2 tickets
SQLBeta2Count = "SELECT COUNT(ItemNumber) AS Beta2Count FROM OrderLine (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber")	& " AND OrderLine.SeatTypeCode IN (" & Beta2List & ")"
Set rsBeta2Count = OBJdbConnection.Execute(SQLBeta2Count)

Beta2Count = rsBeta2Count("Beta2Count")

rsBeta2Count.Close
Set rsBeta2Count = nothing

'Count number of Alpha2 tickets
SQLAlpha2Count = "SELECT COUNT(ItemNumber) AS Alpha2Count FROM OrderLine (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber")	& " AND OrderLine.SeatTypeCode IN (" & Alpha2List & ")"
Set rsAlpha2Count = OBJdbConnection.Execute(SQLAlpha2Count)

Alpha2Count = rsAlpha2Count("Alpha2Count")

rsAlpha2Count.Close
Set rsAlpha2Count = nothing



If Beta2Count > Alpha2Count Then 'Cannot have more Beta2 tickets on order than Alpha2. Go to warning page
		
	Call WarningPage2 (Alpha2Count, Beta2Count)
		
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


If Session("UserNumber") = "" Then ' Display message for patron
	Response.Write "<CENTER><TABLE><TR><TD><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=2><CENTER><B>"& Restriction &"</B><BR><BR>There are<B> "& BetaCount &"</B> "& BetaName &" ticket(s)and only <B> "& AlphaCount & "</B> "& AlphaName &" ticket(s) selected.<BR><BR>Update your order with an equal number of "& BetaName &" and "& AlphaName &" tickets<BR><CENTER><FORM ACTION=""/ShoppingCart.asp"" METHOD=""POST"" id=form1 name=form1><INPUT TYPE=""submit"" VALUE=""&nbsp;&nbsp;&nbsp;&nbsp;OK&nbsp;&nbsp;&nbsp;&nbsp;"" id=1 name=1></FORM></CENTER></TD></TR></TABLE></CENTER><BR><BR>" & vbCrLf
Else ' Display message for box office
	Response.Write "<CENTER><TABLE><TR><TD><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=2><CENTER><B>"& Restriction &"</B><BR><BR>There are<B> "& BetaCount &"</B> "& BetaName &" ticket(s)and only <B> "& AlphaCount & "</B> "& AlphaName &" ticket(s) selected.<BR><BR>Update your order with an equal number of "& BetaName &" and "& AlphaName &" tickets<BR><CENTER><FORM ACTION=""/Management/ShoppingCart.asp"" METHOD=""POST"" id=form1 name=form1><INPUT TYPE=""submit"" VALUE=""&nbsp;&nbsp;&nbsp;&nbsp;OK&nbsp;&nbsp;&nbsp;&nbsp;"" id=1 name=1></FORM></CENTER></TD></TR></TABLE></CENTER><BR><BR>" & vbCrLf
End If

%>

<!--#INCLUDE virtual="/FooterInclude.asp"-->

</BODY>
</HTML>

<%			
End Sub 'Warning Page

'----------------------------

Sub WarningPage2 (Alpha2Count, Beta2Count)

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


If Session("UserNumber") = "" Then ' Display message for patron
	Response.Write "<CENTER><TABLE><TR><TD><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=2><CENTER><B>"& Restriction2 &"</B><BR><BR>There are<B> "& Beta2Count &"</B> "& Beta2Name &" ticket(s)and only <B> "& Alpha2Count & "</B> "& Alpha2Name &" ticket(s) selected.<BR><BR>Update your order with an equal number of "& Beta2Name &" and "& Alpha2Name &" tickets<BR><CENTER><FORM ACTION=""/ShoppingCart.asp"" METHOD=""POST"" id=form1 name=form1><INPUT TYPE=""submit"" VALUE=""&nbsp;&nbsp;&nbsp;&nbsp;OK&nbsp;&nbsp;&nbsp;&nbsp;"" id=1 name=1></FORM></CENTER></TD></TR></TABLE></CENTER><BR><BR>" & vbCrLf
Else ' Display message for box office
	Response.Write "<CENTER><TABLE><TR><TD><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=2><CENTER><B>"& Restriction2 &"</B><BR><BR>There are<B> "& Beta2Count &"</B> "& Beta2Name &" ticket(s)and only <B> "& Alpha2Count & "</B> "& Alpha2Name &" ticket(s) selected.<BR><BR>Update your order with an equal number of "& Beta2Name &" and "& Alpha2Name &" tickets<BR><CENTER><FORM ACTION=""/Management/ShoppingCart.asp"" METHOD=""POST"" id=form1 name=form1><INPUT TYPE=""submit"" VALUE=""&nbsp;&nbsp;&nbsp;&nbsp;OK&nbsp;&nbsp;&nbsp;&nbsp;"" id=1 name=1></FORM></CENTER></TD></TR></TABLE></CENTER><BR><BR>" & vbCrLf
End If

%>

<!--#INCLUDE virtual="/FooterInclude.asp"-->

</BODY>
</HTML>

<%			
End Sub 'Warning Page
%>



