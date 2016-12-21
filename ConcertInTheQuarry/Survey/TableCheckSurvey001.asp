<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->

<%

Page = "Survey"
SurveyNumber = 822


'1201/ 5400 Corporation (8/3/2010)
'=================================
'Table Check Survey  PLUS
'Audience Survey


'Patron is required to buy a minimum of 8 seats per table
'All 8 seats must be at the same table



'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If

'Check to see if this is a Comp Order. If so, skip survey.
If Session("OrderTypeNumber") = 5 Then
	Call Continue
End If

'Survey Parameters


Call TableCheck

'=================================

Sub TableCheck

SQLOrderSeats = "SELECT Seat.EventCode, Section.Section, Seat.SectionCode, COUNT(OrderLine.ItemNumber) AS OrderSeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber")	& " AND Section.Color = '2Green' AND OrderLine.ItemType IN ('SubFixedEvent', 'SubSeat', 'Seat') GROUP BY Seat.EventCode, Seat.SectionCode, Section.Section"
Set rsOrderSeats = OBJdbConnection.Execute(SQLOrderSeats)

Do Until rsOrderSeats.EOF

	SQLSectionSeats = "SELECT COUNT(ItemNumber) AS SectionSeatCount FROM Seat (NOLOCK) WHERE EventCode = " & rsOrderSeats("EventCode") & " AND SectionCode = '" & rsOrderSeats("SectionCode") & "'"
	Set rsSectionSeats = OBJdbConnection.Execute(SQLSectionSeats)
	
	    OrderSection = rsOrderSeats("Section")
	    OrderSectionCode = rsOrderSeats("SectionCode")
	    OrderEventCode = rsOrderSeats("EventCode")	
	    OrderSeatCount = rsOrderSeats("OrderSeatCount")
	    SectionSeatCount = rsSectionSeats("SectionSeatCount")


	    If OrderSeatCount < 8 Then 'Not all seats were selected.  Go to warning page	
		    rsSectionSeats.Close
		    Set rsSectionSeats = nothing		
		    Call WarningPage(OrderSeatCount, SectionSeatCount, OrderSection, OrderEventCode, OrderSectionCode)		
		    Exit Sub
		Else
		    Call Continue					
	    End If
				
	rsSectionSeats.Close
	Set rsSectionSeats = nothing
	
	rsOrderSeats.MoveNext

Loop
		
rsOrderSeats.Close
Set rsOrderSeats = nothing

OBJdbConnection.Close
Set OBJdbConnection = nothing

End Sub	
				
'=================================

Sub WarningPage(OrderSeatCount, SectionSeatCount, OrderSection, OrderEventCode, OrderSectionCode)

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & Title & "</TITLE>" & vbCrLf
Response.Write "</HEAD>" & vbCrLf

Response.Write "<BODY BGCOLOR=" & BGColor & " LINK="& LinkColor & " ALINK=" & ALinkColor & " VLINK=" & VLinkColor & " leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0 " & BodyParameters & ">" & vbCrLf
		
%>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3>SORRY</H3></FONT>
<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">Tables require a minimum purchase of 8 tickets.<BR /><br />
<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">You have only selected <%= OrderSeatCount %> seats at <b> <%= OrderSection %> </b>.<BR><br />

<%
If Session("UserNumber") = "" Then
	Response.Write "<CENTER><FORM ACTION=""ShoppingCart.asp"" METHOD=""POST"" id=form1 name=form1><INPUT TYPE=""submit"" VALUE=""View Shopping Cart"" id=1 name=1></FORM></CENTER>" & vbCrLf
	Response.Write "<CENTER><FORM ACTION=""/Event.asp?Event=" & OrderEventCode & "Section=" & OrderSection & "&Details=NO"" METHOD=""POST"" id=form1 name=form1><INPUT TYPE=""submit"" VALUE=""Add Additional Seats"" id=1 name=1></FORM></CENTER>" & vbCrLf
Else
    Response.Write "<CENTER><FORM ACTION=""/Management/SectionRowSelect.asp?Event=" &OrderEventCode& "&Section=" & OrderSectionCode & "&Details=NO"" METHOD=""POST"" id=form1 name=form1><INPUT TYPE=""submit"" VALUE=""Add Additional Seats"" id=1 name=1></FORM></CENTER>" & vbCrLf
	Response.Write "<CENTER><FORM ACTION=""/Management/ShoppingCart.asp"" METHOD=""POST"" id=form1 name=form1><INPUT TYPE=""submit"" VALUE=""View Shopping Cart"" id=1 name=1></FORM></CENTER>" & vbCrLf
    
End If
%>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%			
End Sub 'Warning Page

'=================================

Sub Continue

Session("SurveyComplete") = Session("OrderNumber")

If Session("OrderTypeNumber") = 1 Then
	Response.Redirect("/Ship.asp")
Else
	Response.Redirect("/Management/AdvanceShip.asp")
End If

End Sub 'Continue

'=================================

%>



