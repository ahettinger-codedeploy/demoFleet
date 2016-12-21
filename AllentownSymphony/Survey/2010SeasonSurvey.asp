
<!--#INCLUDE virtual=/PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=/GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=/DBOpenInclude.asp -->

<%

'Allentown Symphony (4/27/2010)
'2010 Season Subscription Single Ticket Restriction

'Patron must purchase  

'1 ticket to: Allentown Symphony 2010-2011 Season Subscription: Saturday 
'OR
'1 ticket to: Allentown Symphony 2010-2011 Season Subscription: Sunday

'To be allowed the purchase of:

'1 ticket to: Gala Opener: Andre Watts Concert
'AND/OR
'1 ticket to: Pops Concert I: Bravo Broadway
'AND/OR
'1 ticket to: Pops Concert II: Classical Mystery Tour



'Initialize Variables
Page = "Survey"
SurveyNumber = 759

AlphaName = "Season Subscription" 'Name of Alpha Ticket
BetaName = "Andre Watts" 'Name of Beta Ticket
DeltaName = "Pops Concert I"

AlphaTicketList = 1 'Adult
AlphaEventList = "260533,260535" 'Saturday Subscription, Sunday Subscription

BetaTicketList = 1 'Adult
BetaEventList = 257782 'Andre Watts

DeltaTicketList = 1 'Adult
DeltaEventList = 260543 'Pops Concert I

GammaTicketList = 1 'Adult
GammaEventList = 260544 'Pops Concert II


WarningHeader = "Please Note" 'Warning Page Header
Restriction = ""
RestrictionB = "<BR><B>Gala Opener: Andre Watts Concert<BR>October 16, 2010 at 8:00 PM</B><BR>" 'Warning Page Explanation
RestrictionD = "<BR><B>Pops Concert I: Bravo Broadway! <BR>September 9, 2010 at 8:00 PM</B><BR>" 'Warning Page Explanation
RestrictionG = "<BR><B>Pops Concert II: Classical Mystery Tour <BR>May 14th, 2011 at 8:00 PM</B><BR>" 'Warning Page Explanation


'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If


Call TicketCount

'----------------------------

Sub TicketCount 


'Count number of Alpha tickets
SQLAlphaCount = "SELECT COUNT(OrderLine.ItemNumber) AS AlphaCount FROM OrderHeader (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderHeader.OrderNumber = " & Session("OrderNumber")& " AND EventCode IN (" & AlphaEventList & ") AND OrderLine.SeatTypeCode IN (" & AlphaTicketList & ")"
Set rsAlphaCount = OBJdbConnection.Execute(SQLAlphaCount)
AlphaCount = rsAlphaCount("AlphaCount")
rsAlphaCount.Close
Set rsAlphaCount = nothing


'Count number of Beta tickets
SQLBetaCount = "SELECT COUNT(OrderLine.ItemNumber) AS BetaCount FROM OrderHeader (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderHeader.OrderNumber = " & Session("OrderNumber")& " AND EventCode IN (" & BetaEventList & ") AND OrderLine.SeatTypeCode IN (" & BetaTicketList & ")"
Set rsBetaCount = OBJdbConnection.Execute(SQLBetaCount)
BetaCount = rsBetaCount("BetaCount")
rsBetaCount.Close
Set rsBetaCount = nothing

If AlphaCount > BetaCount Then
    Restriction = Restriction & ""
ElseIf AlphaCount = BetaCount Then
   Restriction = Restriction & ""
Else
   Restriction = Restriction & RestrictionB
End If


'Count number of Delta tickets
SQLDeltaCount = "SELECT COUNT(OrderLine.ItemNumber) AS DeltaCount FROM OrderHeader (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderHeader.OrderNumber = " & Session("OrderNumber")& " AND EventCode IN (" & DeltaEventList & ") AND OrderLine.SeatTypeCode IN (" & DeltaTicketList & ")"
Set rsDeltaCount = OBJdbConnection.Execute(SQLDeltaCount)
DeltaCount = rsDeltaCount("DeltaCount")
rsDeltaCount.Close
Set rsDeltaCount = nothing

If AlphaCount > DeltaCount Then
    Restriction = Restriction & ""
ElseIf AlphaCount = DeltaCount Then
   Restriction = Restriction & ""
Else
   Restriction = Restriction & RestrictionD
End If


'Count number of Gamma tickets
SQLGammaCount = "SELECT COUNT(OrderLine.ItemNumber) AS GammaCount FROM OrderHeader (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderHeader.OrderNumber = " & Session("OrderNumber")& " AND EventCode IN (" & GammaEventList & ") AND OrderLine.SeatTypeCode IN (" & GammaTicketList & ")"
Set rsGammaCount = OBJdbConnection.Execute(SQLGammaCount)
GammaCount = rsGammaCount("GammaCount")
rsGammaCount.Close
Set rsGammaCount = nothing

If AlphaCount > GammaCount Then
    Restriction = Restriction & ""
ElseIf AlphaCount = GammaCount Then
   Restriction = Restriction & ""
Else
   Restriction = Restriction & RestrictionG
End If


If Restriction = "" Then
    Call Continue
Else
    Call WarningPage (Restriction, BetaCount, AlphaCount)
End If


End Sub 'TicketCount			
				
'----------------------------

Sub WarningPage (Restriction, BetaCount, AlphaCount)

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & Title & "</TITLE>" & vbCrLf
Response.Write "</HEAD>" & vbCrLf

Response.Write "<BODY BGCOLOR=" & BGColor & " LINK="& LinkColor & " ALINK=" & ALinkColor & " VLINK=" & VLinkColor & " leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0 " & BodyParameters & ">" & vbCrLf
					
%>

<!--#INCLUDE virtual="/TopNavInclude.asp"-->

<BR>
<BR>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3><%= WarningHeader %></H3></FONT>

<%

Response.Write "<CENTER><TABLE><TR><TD><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=2><CENTER>Single ticket sales are not allowed for:<BR>" & Restriction & "<BR>These tickets must be purchased with a season subscription.<BR><BR>Please click the button below to add season subscription tickets to your order<BR><CENTER>" & vbCrLf

If Session("UserNumber") = "" Then ' Display message for patron
	Response.Write "<FORM ACTION=""/ShoppingCart.asp"" METHOD=""POST"" id=form1 name=form1><INPUT TYPE=""submit"" VALUE=""Back to Shopping Cart"" id=1 name=1>" & vbCrLf             
Else ' Display message for box office
	Response.Write "<FORM ACTION=""/Management/EventSelectionSubscriptions.asp"" METHOD=""POST"" id=form1 name=form1><INPUT TYPE=""submit"" VALUE=""Back to Ticket Sales"" id=1 name=1>" & vbCrLf
End If

Response.Write "</FORM></CENTER></TD></TR></TABLE></CENTER><BR><BR>" & vbCrLf


%>

<!--#INCLUDE virtual="/FooterInclude.asp"-->

</BODY>
</HTML>

<%			
End Sub 'Warning Page

'----------------------------

Sub Continue

Session("SurveyComplete") = Session("OrderNumber")

If Session("OrderTypeNumber") = 1 Then
    Response.Redirect("/Ship.asp")
Else
    Response.Redirect("/Management/AdvanceShip.asp")
End If

End Sub 'Continue

'----------------------------

%>



