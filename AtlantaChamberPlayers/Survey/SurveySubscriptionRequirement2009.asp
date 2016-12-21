<!-- Survey that requires patrons to purchase a full season subscription -- SSR -->

<!--#INCLUDE virtual=/PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=/GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=/DBOpenInclude.asp -->
<%

'Initialize Variables
Page = "Survey"
SurveyNumber = 645

'Season Subscription Restriction Parameters
'The following Act Codes must be purchased as part of a subscription
ActCodeList = "41492,41496,41505" 'Production Actcodes.

Call SubCheck

'----------------------------
Sub SubCheck


'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If

	'Count # of Acts on the order.
		SQLActCount = "SELECT Event.ActCode FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.OrderNumber = " & Session("OrderNumber") & " AND Event.ActCode IN (" & ActCodeList & ") AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') AND DiscountTypeNumber = 0"
		Set rsActCount = OBJdbConnection.Execute(SQLActCount)
        If Not rsActCount.EOF Then
			Call WarningPage(ActCount, SeriesCount)
			Exit Sub
		End If
		
Session("SurveyComplete") = Session("OrderNumber")

If Session("OrderTypeNumber") = 1 Then
	Response.Redirect("/Ship.asp")
Else
	Response.Redirect("/Management/AdvanceShip.asp")
End If

End Sub 'SubCheck			
				
'----------------------------

Sub WarningPage(ActCount, SeriesCount)

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & Title & "</TITLE>" & vbCrLf
Response.Write "</HEAD>" & vbCrLf

Response.Write "<BODY BGCOLOR=" & BGColor & " LINK="& LinkColor & " ALINK=" & ALinkColor & " VLINK=" & VLinkColor & " leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0 " & BodyParameters & ">" & vbCrLf
					
%>

<!--#INCLUDE virtual="/TopNavInclude.asp"-->

<BR>
<BR>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3>Subscription Requirement Notice</H3></FONT>

<%
Response.Write "<CENTER><TABLE><TR><TD><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=2><CENTER><B>Tickets to the following performances must be purchased as part of a 3, 4, or 5 show subscription package:<BR><BR>Chamber Music at the Tavern - Tuesday, 1/26/2010 at 7:30 PM <BR>Chamber Music at Spivey Hall - Sunday, 2/28/2010 at 3:00 PM<BR>Chamber Music at the Tavern 2 - Wednesday, 4/28/2010 at 8:00 PM<BR><BR>Your order currently contains 1 or more tickets to these performances which are not part of a subscription package.<BR><BR>Click on ""Return to Shopping Cart"" to return to your Shopping Cart and either add or remove the appopriate tickets.<BR><BR><CENTER><FORM ACTION=""/ShoppingCart.asp"" METHOD=""POST"" id=form1 name=form1><INPUT TYPE=""submit"" VALUE=""Return to Shopping Cart"" id=1 name=1></FORM></CENTER></TD></TR></TABLE></CENTER><BR><BR>" & vbCrLf

%>

<!--#INCLUDE virtual="/FooterInclude.asp"-->

</BODY>
</HTML>

<%			
End Sub 'Warning Page
%>



