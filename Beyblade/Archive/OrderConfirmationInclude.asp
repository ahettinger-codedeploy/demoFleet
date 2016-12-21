<%

'REE 11/7/3 - Modified to allow two different sets of confirmation notes depending on the events on the order.

OrderConfirmationInfo = ""

SQLBeybladeConfirmation = "SELECT Seat.EventCode FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent', 'SubSeat') GROUP BY Seat.EventCode"
Set rsBeybladeConfirmation = OBJdbConnection.Execute(SQLBeyBladeConfirmation)

Do Until rsBeybladeConfirmation.EOF

	Select Case rsBeybladeConfirmation("EventCode")
		Case 10600 'Red Competitor Ticket - Ages 8 - 14
			If OrderConfirmationInfo <> "" Then 'Add blank a blank line in between.
				OrderConfirmationInfo = OrderConfirmationInfo & "<BR><BR>"
			End If
			OrderConfirmationInfo = OrderConfirmationInfo & "<TABLE><TR BGCOLOR=""#FF0000""><TD>&nbsp;</TD></TR><TR><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" SIZE=""5""><B>RED COMPETITOR TICKET - AGES 8 to 14</B></FONT></TD></TR>"
		Case 10601 'Blue Competitor TIcket - Ages 15 and up
			If OrderConfirmationInfo <> "" Then 'Add blank a blank line in between.
				OrderConfirmationInfo = OrderConfirmationInfo & "<BR><BR>"
			End If
			OrderConfirmationInfo = OrderConfirmationInfo & "<TABLE><TR BGCOLOR=""#0000FF""><TD>&nbsp;</TD></TR><TR><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" SIZE=""5""><B>BLUE COMPETITOR TICKET - AGES 15 and up</B></FONT></TD></TR>"
	End Select		
	
	OrderConfirmationInfo = OrderConfirmationInfo & "<TR><TD><FONT FACE=""verdana,arial,helvetica"" SIZE=""2""><BR><CENTER><B>You are now an Official BBA Blader Jam Competitor!</B></CENTER><BR>Please print out a copy of this confirmation and bring it with you, along with a completed Competitor Waiver, to registration at 8AM on March 20th, 2004.  <A HREF=""http://www.beyblade.com/BBA/houston/waiver.asp"" TARGET=""Waiver"">Click here</A> to link to the Competitor Waiver.</FONT></TD></TR><TR><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2""><BR><B>Tickets CANNOT be picked up at the event.  Your Online Confirmation is your ticket.</B></FONT></TD></TR></TABLE><BR>" & vbCrLf
	
	rsBeybladeConfirmation.MoveNext
	
Loop

rsBeybladeConfirmation.Close
Set rsBeybladeConfirmation = nothing

%>