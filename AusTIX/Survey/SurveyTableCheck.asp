<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%
Page = "Survey"
SurveyNumber = 550
AllowedColor = DARKBLUE

Call TableCheck

Sub TableCheck

'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If

SQLOrderSeats = "SELECT Seat.EventCode, Seat.SectionCode, COUNT(OrderLine.ItemNumber) AS OrderSeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber")	& " AND Section.Color IN ('DARKBLUE') AND OrderLine.ItemType IN ('SubFixedEvent', 'SubSeat', 'Seat') GROUP BY Seat.EventCode, Seat.SectionCode"
Set rsOrderSeats = OBJdbConnection.Execute(SQLOrderSeats)


Do Until rsOrderSeats.EOF

OrderSeatCount = rsOrderSeats("OrderSeatCount")


If OrderSeatCount <> 2 AND OrderSeatCount <> 4 AND OrderSeatCount <> 6 AND OrderSeatCount <> 8 AND OrderSeatCount <> 10 Then 
	

		
Call WarningPage(OrderSeatCount, SectionSeatCount)
		
Exit Sub
					
End If
				

	
rsOrderSeats.MoveNext

Loop
		
rsOrderSeats.Close
Set rsOrderSeats = nothing

OBJdbConnection.Close
Set OBJdbConnection = nothing

Session("SurveyComplete") = Session("OrderNumber")

If Session("OrderTypeNumber") = 1 Then
	Response.Redirect("/Ship.asp")
Else
	Response.Redirect("/Management/AdvanceShip.asp")
End If

End Sub 'TableCheck
			
				
'----------------------------

Sub WarningPage(OrderSeatCount, SectionSeatCount)

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & Title & "</TITLE>" & vbCrLf
Response.Write "</HEAD>" & vbCrLf

Response.Write "<BODY BGCOLOR=" & BGColor & " LINK="& LinkColor & " ALINK=" & ALinkColor & " VLINK=" & VLinkColor & " leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0 " & BodyParameters & ">" & vbCrLf
					
%>

<!--#INCLUDE virtual="/TopNavInclude.asp"-->

<BR>
<BR>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3>PLEASE NOTE</H3></FONT>

<%
If Session("UserNumber") = "" Then
	Response.Write "<CENTER><TABLE><TR><TD ALIGN=""center""><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=2>Table seats may only be purchased in pairs.<BR>Please click on the button below and adjust your order.<BR><BR><CENTER><FORM ACTION=""/ShoppingCart.asp"" METHOD=""POST"" id=form1 name=form1><INPUT TYPE=""submit"" VALUE=""Back to Shopping"" id=1 name=1></FORM></CENTER></TD></TR></TABLE></CENTER><BR><BR>" & vbCrLf
Else
	Response.Write "<CENTER><TABLE><TR><TD ALIGN=""center""><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=2>Table seats may only be purchased in pairs.<BR>Please click on the button below and adjust your order.<BR><BR><CENTER><FORM ACTION=""/Management/ShoppingCart.asp"" METHOD=""POST"" id=form1 name=form1><INPUT TYPE=""submit"" VALUE=""Back to Shopping"" id=1 name=1></FORM></CENTER></TD></TR></TABLE></CENTER><BR><BR>" & vbCrLf
End If

%>

<!--#INCLUDE virtual="/FooterInclude.asp"-->

</BODY>
</HTML>

<%			
End Sub 'Warning Page
%>



