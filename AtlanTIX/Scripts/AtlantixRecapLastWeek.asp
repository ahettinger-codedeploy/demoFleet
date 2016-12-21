<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp"-->
<!--#INCLUDE VIRTUAL="NoCacheInclude.asp"-->
<%

StartDate = CDate(FormatDateTime(Now - (14 + Weekday(Now, 2)) + 1, vbShortDate))
EndDate = CDate(FormatDateTime(Now - Weekday(Now, 2) - 7, vbShortDate))

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>Atlantix Statement for " & StartDate & " through " & EndDate & "</TITLE>" & vbCrLf
Response.Write "</HEAD>" & vbCrLf
Response.Write "<BODY>" & vbCrLf


'StartDate = CDate(Now - (6 + Weekday(Now, 3)))
'EndDate = CDate(Now - Weekday(Now, 2))
Response.Write "Below is a statement for events taking place from " & StartDate & " - " & EndDate & ".<BR><HR><BR>" & vbCrLf

Response.Write "<TABLE>" & vbCrLf

Response.Write "<TR><TD COLSPAN=""4"" ALIGN=""center""><FONT FACE=verdana,arial,helvetica COLOR=#008400><H3>Atlanta Coalition of Performing Arts</H3></FONT></TD></TR>" & vbCrLf

Response.Write "<TR><TD COLSPAN=""4"" ALIGN=""center""><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Sales For Events From " & StartDate & " Through " &  EndDate & "</B></FONT><BR><BR></TD></TR>" & vbCrLf

SQLEvents = "SELECT Event.Comments AS Producer, Act.Act AS Production, SUM(OrderLine.Price) AS FaceValue, SUM(OrderLine.Discount) AS Discount, COUNT(OrderLine.ItemNumber) AS TicketCount FROM Act (NOLOCK) INNER JOIN Event (NOLOCK) ON Act.ActCode = Event.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber WHERE EventDate >= '" & StartDate & "' AND EventDate < '" & EndDate + 1 & "' AND OrganizationVenue.OrganizationNumber = 10 AND OrganizationVenue.Owner = 1 AND OrganizationAct.OrganizationNumber = 10 AND OrderLine.StatusCode = 'S' AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent', 'SubSeat') GROUP BY Event.Comments, Act.Act ORDER BY Event.Comments, Act.Act"
Set rsEvents = OBJdbConnection.Execute(SQLEvents)

Response.Write "<TR BGCOLOR=#008400><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=""#FFFFFF"" SIZE=2><B>Producer</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=""#FFFFFF"" SIZE=2><B>Production</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=""#FFFFFF"" SIZE=2><B># Tickets</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=""#FFFFFF"" SIZE=2><B>Revenue</B></FONT></TD></TR>" & vbCrLf

Do Until rsEvents.EOF
	Response.Write "<TR BGCOLOR=""#CCCCCC""><TD><FONT FACE='verdana,arial,helvetica' SIZE=2>" & CleanProducer(rsEvents("Producer")) & "</FONT></TD><TD><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsEvents("Production") & "</FONT></TD><TD ALIGN=""right""><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsEvents("TicketCount") & "</FONT></TD><TD ALIGN=""right""><FONT FACE='verdana,arial,helvetica' SIZE=2>" & FormatCurrency(rsEvents("FaceValue") - rsEvents("Discount"),2) & "</FONT></TD></TR>" & vbCrLf
	TotalTicketCount = TotalTicketCount + rsEvents("TicketCount")
	TotalRevenue = TotalRevenue + (rsEvents("FaceValue") - rsEvents("Discount"))
	
	rsEvents.MoveNext
	
Loop

Response.Write "<TR BGCOLOR=""999999""><TD COLSPAN=""2""><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Subtotal</B></FONT></TD><TD ALIGN=""right""><FONT FACE='verdana,arial,helvetica' SIZE=2><B>" & TotalTicketCount & "</B></FONT></TD><TD ALIGN=""right""><FONT FACE='verdana,arial,helvetica' SIZE=2><B>" & FormatCurrency(TotalRevenue,2) & "</B></FONT></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=""CCCCCC""><TD COLSPAN=""3""><FONT FACE='verdana,arial,helvetica' SIZE=2>Atlantix Fees</FONT></TD><TD ALIGN=""right""><FONT FACE='verdana,arial,helvetica' SIZE=2>" & FormatCurrency(TotalTicketCount,2) & "</FONT></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=""999999""><TD COLSPAN=""3""><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Total</B></FONT></TD><TD ALIGN=""right""><FONT FACE='verdana,arial,helvetica' SIZE=2><B>" & FormatCurrency(TotalRevenue + TotalTicketCount,2) & "</B></FONT></TD></TR>" & vbCrLf

Response.Write "</TABLE>" & vbCrLf
rsEvents.Close
Set rsEvents = nothing

Response.Write "<BR>A deposit has been made into your account in  the amount of " & FormatCurrency(TotalRevenue + TotalTicketCount, 2) & " on " & EndDate + 5 & ".<BR><BR>" & vbCrLf
Response.Write "Thank you for choosing www.TIX.com!<BR><BR>" & vbCrLf

Function CleanProducer(Producer)

CleanProducer = Replace(Producer, "<B>", "")
CleanProducer = Replace(CleanProducer, "</B>", "")

End Function 'RemoveBold

%>
