<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%
Page = "Survey"
'9.15.07 SM ===>This survey presents patrons with an add-on event offer.  Modified "SurveySkirballNoaksArkNew".
SurveyNumber = 300
SurveyFileName = "SurveyFuriousTheater_Immediate.asp"

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
		Call Continue 'SM 9.15.07==>Look Here===>Changed Call to "Call Continue"
	Case Else
		Call TicketOffer(Message)
End Select


'==============================

Sub TicketOffer(Message)

'Check for qualifying events on this order

Call DBOpen(OBJdbConnection2)

Dim RequiredEventSection(4)
Dim OfferEventSection(4)

RequiredEventSection(0) = "Seat.EventCode = 88911"
OfferEventSection(0) = "Seat.EventCode = 111693 AND Seat.SectionCode IN ('GA')"

RequiredEventSection(1) = "Seat.EventCode = 88914"
OfferEventSection(1) = "Seat.EventCode = 111694 AND Seat.SectionCode IN ('GA')"

RequiredEventSection(2) = "Seat.EventCode = 88917"
OfferEventSection(2) = "Seat.EventCode = 111695 AND Seat.SectionCode IN ('GA')"

RequiredEventSection(3) = "Seat.EventCode = 88920"
OfferEventSection(3) = "Seat.EventCode = 111696 AND Seat.SectionCode IN ('GA')"

OfferText = ""

For EventCount = 0 To 3

	SQLWorkshop = "SELECT COUNT(OrderLine.ItemNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND " & RequiredEventSection(EventCount) & " AND OrderLine.ItemType = 'Seat' GROUP BY Seat.EventCode ORDER BY Seat.EventCode"
	Set rsWorkshop = OBJdbConnection.Execute(SQLWorkshop)
	
	If Not rsWorkshop.EOF Then
		TicketCount = rsWorkshop("TicketCount")
	Else
		TicketCount = 0
	End If
	
	rsWorkshop.Close
	Set rsWorkshop = nothing
	
	
	If TicketCount > 0 Then

		SQLSection = "SELECT Act.Act, Event.EventCode, Event.EventDate, Section.SectionCode, Section.Section, COUNT(Seat.ItemNumber) AS AvailableCount FROM Seat (NOLOCK) INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE " & OfferEventSection(EventCount) & " AND Seat.StatusCode = 'A' GROUP BY Act.Act, Event.EventCode, Event.EventDate, Section.SectionCode, Section.Section ORDER BY Section.Section"
		Set rsSection = OBJdbConnection.Execute(SQLSection)
		
		SectionCount = 0
			
		Do Until rsSection.EOF
			Act = rsSection("Act")
			EventCode = rsSection("EventCode")
			EventDate = rsSection("EventDate")
			SectionCode = rsSection("SectionCode")
			Section = rsSection("Section")
			AvailableCount = rsSection("AvailableCount")
			
			'Get Existing Offer Count on this order
			SQLApplied = "SELECT COUNT(OrderLine.ItemNumber) AS AppliedCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND " & OfferEventSection(EventCount)
			Set rsApplied = OBJdbConnection2.Execute(SQLApplied)
			
			AppliedCount = rsApplied("AppliedCount")
			
			rsApplied.Close
			Set rsApplied = nothing
			
			If TicketCount <= AvailableCount And TicketCount > AppliedCount Then
					
				SectionCount = SectionCount + 1
						
				If SectionCount = 1 Then 'Display the Event info and start a new row.
					OfferText = OfferText & "<TABLE WIDTH=""600""><TR><TD COLSPAN=""2"" ALIGN=""center""><FONT FACE=" & FontFace & " COLOR=" &  FontColor & " SIZE=2><B>" & Act & " on " & FormatDateTime(EventDate, vbLongDate) & " at " & Left(FormatDateTime(EventDate, vbLongTime),Len(FormatDateTime(EventDate, vbLongTime))-6) & Right(FormatDateTime(EventDate, vbLongTime),3) & " - " & TicketCount - AppliedCount & " Tickets</B></FONT><BR><BR></TD></TR>" & vbCrLf
					OfferText = OfferText & "<TR>"
				End If
				
				OfferText = OfferText & "<TD ALIGN=""center""><FORM ACTION=""" & SurveyFileName & """ METHOD=""post"" id=form1 name=form1><INPUT TYPE=""hidden"" NAME=""FormName"" VALUE=""EventOffer""><INPUT TYPE=""hidden"" NAME=""EventCode"" VALUE=""" & EventCode & """><INPUT TYPE=""hidden"" NAME=""SectionCode"" VALUE=""" & SectionCode & """><INPUT TYPE=""hidden"" NAME=""SeatTypeCode"" VALUE=""16""><INPUT TYPE=""hidden"" NAME=""Quantity"" VALUE=""" & TicketCount - AppliedCount & """><INPUT TYPE=""submit"" VALUE=""Add To Cart"" id=1 name=1></FORM></TD>"
				
			End If
					
			rsSection.MoveNext
					
		Loop

		rsSection.Close
		Set rsSection = nothing

		If SectionCount > 0 Then 'End table row.
			OfferText = OfferText & "</TR></TABLE>" & vbCrLf
		End If

	End If
	
Next

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
	
	Response.Write "<TABLE WIDTH=""600"" BORDER=""0""><TR><TD ALIGN=""center""><FONT FACE=" & FontFace & " COLOR=" &  FontColor & " SIZE=2><H3>WOULD YOU LIKE TO BUY AN imMEDIAte Theatre TICKET FOR ONLY $5?</H3><BR><BR><IMG SRC=""/PrivateLabel/FuriousTheatre/Images/immediate_seasonblast.jpg"" height=""188"" width=""125"" border=""0""><BR><BR><BR><FONT SIZE=4><B>imMEDIAte Theatre</B></FONT><BR><BR>A barrage of news footage fills the screen. Lights up on stage. The cast tears through the headlines of the day's newspapers skewering the top stories, jumping from the anchor desk to the radio waves and covering the everyday events in your life. This is imMEDIAte Theatre…Furious Theatre Company continues “Furious Late Nights,” with imMEDIAte Theatre, a 60-minute improvised, multimedia comedy show based on the week’s news and pop culture events. The show, which was created and performed by the company and has been presented via word-of-mouth previews since late 2005.<BR><BR><B>Please click on the corresponding button below if you would like to add the following ticket(s) to your shopping cart.<BR></B></FONT></TD></TR></TABLE><BR>" & vbCrLf

	Response.Write OfferText & vbCrLf

	Response.Write "<BR>" & vbCrLf

	Response.Write "<FORM ACTION=""" & SurveyFileName & """ METHOD=""post""><INPUT TYPE=""hidden"" NAME=""FormName"" VALUE=""Continue""><INPUT TYPE=""submit"" VALUE=""No Thanks""></FORM>" & vbCrLf
%>
	<!--#INCLUDE virtual="FooterInclude.asp"-->
<%

	Response.Write "</BODY>" & vbCrLf
	Response.Write "</HTML>" & vbCrLf
	
Else 

	Call ApplyDiscount
	
End If


Call DBClose(OBJdbConnection2)

End Sub 'TicketOffer

'==============================

Sub ApplyDiscount

'Count number of times discount has been applied to this order.  Maximum allowed is 8.
SQLAppliedCount = "SELECT COUNT(OrderLine.ItemNumber) AS AppliedCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Event.ActCode = 16071 AND OrderLine.DiscountTypeNumber = 26120 AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') GROUP BY OrderLine.DiscountTypeNumber"
Set rsAppliedCount = OBJdbConnection.Execute(SQLAppliedCount)

If Not rsAppliedCount.EOF Then
	AppliedCount = rsAppliedCount("AppliedCount")
Else
	AppliedCount = 0
End If

rsAppliedCount.Close
Set rsAppliedCount =  nothing

If AppliedCount < 100 Then

	'Get OrderLines that do not have discount applied (if any).
	SQLOrderLine = "SELECT OrderLine.LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Event.ActCode = 16072 AND OrderLine.Discount = 0 AND OrderLine.ItemType IN ('Seat', 'SubSeat', 'SubFixedEvent') ORDER BY OrderLine.LineNumber"
	Set rsOrderLine = OBJdbConnection.Execute(SQLOrderLine)

	Call DBOpen(OBJdbConnection2)

	Do Until rsOrderLine.EOF Or AppliedCount >= 100
		SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = 2, Surcharge = 0, DiscountTypeNumber = 26120 WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLine("LineNumber")
		Set rsApplyDiscount = OBJdbConnection2.Execute(SQLApplyDiscount)
		AppliedCount = AppliedCount + 1
		rsOrderLine.MoveNext
	Loop

	Call DBClose(OBJdbConnection2)

	rsOrderLine.Close
	Set rsOrderLine = nothing

End If

'Call DBClose(OBJdbConnection)
	
Call Continue

End Sub 'ApplyDiscount

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
	Session("SurveyComplete") = Session("OrderNumber") 'SM 9.15.07===>Look here!!===>ASK ROBERT why this was commented out for Skirball===
	Response.Redirect("/Ship.asp")
Else
	Session("SurveyComplete") = Session("OrderNumber")
	Response.Redirect("/Management/AdvanceShip.asp")
End If

End Sub 'Continue

'==============================

%>
