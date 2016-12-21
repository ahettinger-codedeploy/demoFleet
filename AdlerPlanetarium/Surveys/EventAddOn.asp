<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%
Page = "Survey"
'Event Add On Survey
SurveyNumber = 732
SurveyFileName = "EventAddOn.asp"

'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	OBJdbConnection.Close
	Set OBJdbConnection = nothing
	Response.Redirect("/Default.asp")
End If

Select Case Request("FormName")
	Case "EventOffer"
		Call AddToCart(CleanNumeric(Request("EventCode")), Clean(Request("SectionCode")), CleanNumeric(Request("Quantity")))
	Case "Continue"
		Call Continue
	Case Else
		Call TicketOffer(Message)
End Select

'==============================

Sub TicketOffer(Message)

'Check for qualifying events on this order

Call DBOpen(OBJdbConnection)

RequiredEventSection = "Seat.EventCode = 244470" 'Adler After Dark 
OfferEventSection = "Seat.EventCode = 244476 AND Seat.SectionCode IN ('GA')" 'Unsung Stars

OfferText = ""

SQLWorkshop = "SELECT COUNT(OrderLine.ItemNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND " & RequiredEventSection & " AND OrderLine.ItemType = 'Seat' GROUP BY Seat.EventCode ORDER BY Seat.EventCode"
Set rsWorkshop = OBJdbConnection.Execute(SQLWorkshop)
	
	If Not rsWorkshop.EOF Then
		TicketCount = rsWorkshop("TicketCount")
	Else
		TicketCount = 0
	End If
	
	rsWorkshop.Close
	Set rsWorkshop = nothing
	
	
	If TicketCount > 0 Then

		SQLSection = "SELECT Act.Act, Event.EventCode, Event.EventDate, Section.SectionCode, Section.Section, COUNT(Seat.ItemNumber) AS AvailableCount FROM Seat (NOLOCK) INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE Seat.EventCode = 244476 AND Seat.SectionCode IN ('GA') AND Seat.StatusCode = 'A' GROUP BY Act.Act, Event.EventCode, Event.EventDate, Section.SectionCode, Section.Section ORDER BY Section.Section"
		Set rsSection = OBJdbConnection.Execute(SQLSection)	

			Act = rsSection("Act")
			EventCode = rsSection("EventCode")
			EventDate = rsSection("EventDate")
			SectionCode = rsSection("SectionCode")
			Section = rsSection("Section")
			AvailableCount = rsSection("AvailableCount")
			
			'Get Existing Offer Count on this order
			SQLApplied = "SELECT COUNT(OrderLine.ItemNumber) AS AppliedCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND " & OfferEventSection
			Set rsApplied = OBJdbConnection.Execute(SQLApplied)			
			AppliedCount = rsApplied("AppliedCount")			
			rsApplied.Close
			Set rsApplied = nothing
			
			If TicketCount <= AvailableCount And TicketCount > AppliedCount Then
						
			    'Display the Event info and start a new row.
				OfferText = OfferText & "<TABLE WIDTH=""600""><TR><TD ALIGN=""CENTER"" COLSPAN=""2""><FONT FACE=" & FontFace & " COLOR=" &  FontColor & " SIZE=2><B>" & Act & "</B><BR>" & Section & " - " & TicketCount - AppliedCount & " Ticket(s)<br>$0.00 per ticket</FONT></TD></TR>" & vbCrLf
				OfferText = OfferText & "<TR>"		
				OfferText = OfferText & "<TD ALIGN=""CENTER""><FORM ACTION=""" & SurveyFileName & """ METHOD=""post"" id=form1 name=form1><INPUT TYPE=""hidden"" NAME=""FormName"" VALUE=""EventOffer""><INPUT TYPE=""hidden"" NAME=""EventCode"" VALUE=""" & EventCode & """><INPUT TYPE=""hidden"" NAME=""SectionCode"" VALUE=""" & SectionCode & """><INPUT TYPE=""hidden"" NAME=""SeatTypeCode"" VALUE=""16""><INPUT TYPE=""hidden"" NAME=""Quantity"" VALUE=""" & TicketCount - AppliedCount & """><INPUT TYPE=""submit"" VALUE=""" & Section & """ id=1 name=1></FORM></TD>"
				OfferText = OfferText & "</TR></TABLE>" & vbCrLf
				
			End If


	End If
	
If OfferText <> "" Then	

	Response.Write "<HTML>" & vbCrLf
	Response.Write "<HEAD>" & vbCrLf
	Response.Write "<TITLE>" & Title & "</TITLE>" & vbCrLf
	Response.Write "</HEAD>" & vbCrLf

	If Message = "" Then
		Response.Write "<BODY BGCOLOR=" & BGColor & " LINK="& LinkColor & " ALINK=" & ALinkColor & " VLINK=" & VLinkColor & " leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0 " & BodyParameters & ">" & vbCrLf
	Else
		Response.Write "<BODY BGCOLOR=" & BGColor & " LINK="& LinkColor & " ALINK=" & ALinkColor & " VLINK=" & VLinkColor & " onLoad=""alert('" & Message & "');"" leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0 " & BodyParameters & ">" & vbCrLf
	End If
								
%>
	<!--#INCLUDE virtual="TopNavInclude.asp"-->
<%
	Response.Write "<BR>" & vbCrLf
	Response.Write "<BR>" & vbCrLf	
	Response.Write "<TABLE WIDTH=""600""><TR><TD ALIGN=""CENTER"">" & vbCrLf
    Response.Write "<FONT FACE=" & FontFace & " COLOR=" &  FontColor & " SIZE=2><h3>Unsung Stars</h3></FONT>" & vbCrLf
    Response.Write "<FONT FACE=" & FontFace & " COLOR=" &  FontColor & " SIZE=2><B>Live Theater Performance</B></FONT><BR />" & vbCrLf
    Response.Write "<FONT FACE=" & FontFace & " COLOR=" &  FontColor & " SIZE=2><B>7:30 p.m. Universe Theater</B></FONT><BR /><BR>" & vbCrLf
    Response.Write "<FONT FACE=" & FontFace & " COLOR=" &  FontColor & " SIZE=2>Unsung Stars tells the true story of early female researchers hired by the Harvard Observatory for the painstaking task of measuring stars and of Henrietta Leavitt's breakthrough discovery that enabled astronomers to measure huge distances in space. This premiere performance, developed by the women of the Moving Dock ensemble, explores a fascinating moment in the history of astronomy and portrays the moving drama of these unsung stars.<BR><BR>The Moving Dock Theatre Company is a Chicago-based ensemble and studio dedicated to the Art of the Actor. For the past ten years, it has brought its audiences a unique roster of ensemble-created works exploring the inner movement of human experience.<BR><BR>" & vbCrLf
    Response.Write "<FONT FACE=" & FontFace & " COLOR=" &  FontColor & " SIZE=2><B>WOULD YOU LIKE TO ADD THIS ADDITIONAL EVENT?</B><BR><br>" & vbCrLf
    Response.Write "<FONT FACE=" & FontFace & " COLOR=" &  FontColor & " SIZE=2>Please click on the corresponding button below if<br />you would like to add the following ticket(s) to your shopping cart." & vbCrLf
    Response.Write "</TD></TR></TABLE><BR>" & vbCrLf

	Response.Write OfferText & vbCrLf

	Response.Write "<BR><BR>" & vbCrLf

	Response.Write "<FORM ACTION=""" & SurveyFileName & """ METHOD=""post""><INPUT TYPE=""hidden"" NAME=""FormName"" VALUE=""Continue""><INPUT TYPE=""submit"" VALUE=""No Thanks""></FORM>" & vbCrLf
%>
	<!--#INCLUDE virtual="FooterInclude.asp"-->
<%

	Response.Write "</BODY>" & vbCrLf
	Response.Write "</HTML>" & vbCrLf
	
Else

	Call Continue
	
End If


Call DBClose(OBJdbConnection)

End Sub 'TicketOffer

'==============================

Sub AddToCart(EventCode, SectionCode, OfferQuantity)

If Session("UserNumber") = "" Then

	Response.Redirect("/Event.asp?FormName=EventForm&Event=" & EventCode & "&Section=" & SectionCode & "&SeatCount=" & OfferQuantity & "&SeatTypeCode=" & Request("SeatTypeCode"))
	
Else

	Response.Redirect("/Management/Event.asp?FormName=EventForm&Event=" & EventCode & "&Section=" & SectionCode & "&SeatCount=" & OfferQuantity & "&SeatTypeCode=" & Request("SeatTypeCode"))

End If

End Sub 'AddToCart

'==============================

Sub Continue

If Session("UserNumber") = "" Then
	Session("SurveyComplete") = Session("OrderNumber")
	Response.Redirect("/Ship.asp")
Else
	Session("SurveyComplete") = Session("OrderNumber")
	Response.Redirect("/Management/AdvanceShip.asp")
End If

End Sub 'Continue

'==============================

%>
