
<!--#INCLUDE virtual=/PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=/GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=/DBOpenInclude.asp -->

<%

'Allentown Symphony (4/14/2010)
'Single Ticket Restriction Survey
'Survey which requires the purchase of a Season Subscription ticket for each Andre Watts ticket purchased. 

'Initialize Variables
Page = "Survey"
SurveyNumber = 759

AlphaName = "Season Subscription" 'Name of Alpha Ticket
BetaName = "Andre Watts" 'Name of Beta Ticket
AlphaTicketList = 1 'Adult
AlphaEventList = "260533,260535" 'Saturday Subscription, Sunday Subscription
BetaTicketList = 1 'Adult
BetaEventList = 257782 'Andre Watts

WarningHeader = "Please Note" 'Warning Page Header
Restriction = "Single ticket sales are not allowed for:<BR><BR><B>Gala Opener: Andre Watts<BR>October 16, 2010 at 8:00 PM</B><BR><BR>These tickets must be purchased with a season subscription." 'Warning Page Explanation

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
SQLBetaCount = "SELECT COUNT(OrderLine.ItemNumber) AS BetaCount FROM OrderHeader (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderHeader.OrderNumber = " & Session("OrderNumber")& " AND EventCode IN (" & BetaEventList & ") AND OrderLine.SeatTypeCode IN (" & BetaTicketList & ")"
Set rsBetaCount = OBJdbConnection.Execute(SQLBetaCount)

If Not rsBetaCount.EOF Then	

        BetaCount = rsBetaCount("BetaCount")

        'Count number of Alpha tickets
        SQLAlphaCount = "SELECT COUNT(OrderLine.ItemNumber) AS AlphaCount FROM OrderHeader (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderHeader.OrderNumber = " & Session("OrderNumber")& " AND EventCode IN (" & AlphaEventList & ") AND OrderLine.SeatTypeCode IN (" & AlphaTicketList & ")"
        Set rsAlphaCount = OBJdbConnection.Execute(SQLAlphaCount)
        AlphaCount = rsAlphaCount("AlphaCount")
        rsAlphaCount.Close
        Set rsAlphaCount = nothing


        If BetaCount <> AlphaCount Then 'Must have equal number of Beta tickets on order than Alpha. Go to warning page		
	        Call WarningPage (AlphaCount, BetaCount)		
	        Exit Sub
        Else
            Session("SurveyComplete") = Session("OrderNumber")
            
            If Session("OrderTypeNumber") = 1 Then
                Response.Redirect("/Ship.asp")
            Else
                Response.Redirect("/Management/AdvanceShip.asp")
            End If
            
        End If
    
Else				

        Session("SurveyComplete") = Session("OrderNumber")
        
        If Session("OrderTypeNumber") = 1 Then
            Response.Redirect("/Ship.asp")
        Else
            Response.Redirect("/Management/AdvanceShip.asp")
        End If
    
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
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3><%= WarningHeader %></H3></FONT>

<%


If Session("UserNumber") = "" Then ' Display message for patron
	Response.Write "<CENTER><TABLE><TR><TD><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=2><CENTER>"& Restriction &"<BR><BR>Please update your order with an equal number of<BR>"& BetaName &" and "& AlphaName &" tickets<BR><CENTER><FORM ACTION=""/ShoppingCart.asp"" METHOD=""POST"" id=form1 name=form1><INPUT TYPE=""submit"" VALUE=""Back to Shopping Cart"" id=1 name=1></FORM></CENTER></TD></TR></TABLE></CENTER><BR><BR>" & vbCrLf
Else ' Display message for box office
	Response.Write "<CENTER><TABLE><TR><TD><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=2><CENTER>"& Restriction &"<BR><BR>Please update your order with an equal number of<BR>"& BetaName &" and "& AlphaName &" tickets<BR><CENTER><FORM ACTION=""/Management/ShoppingCart.asp"" METHOD=""POST"" id=form1 name=form1><INPUT TYPE=""submit"" VALUE=""Back to Shopping Cart"" id=1 name=1></FORM></CENTER></TD></TR></TABLE></CENTER><BR><BR>" & vbCrLf
End If

%>

<!--#INCLUDE virtual="/FooterInclude.asp"-->

</BODY>
</HTML>

<%			
End Sub 'Warning Page
%>



