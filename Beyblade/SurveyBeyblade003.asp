<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%
Page = "Survey"

SurveyNumber = 14

'Check to see if Order Number exists.  If not, redirect to Home Page.

If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If

Select Case (Clean(Request("FormName")))
	Case "Disclaimer"
		Call DisclaimerResponse
	Case Else
		Call Disclaimer
End Select


OBJdbConnection.Close
Set OBJdbConnection = nothing

Sub Disclaimer

'Check Ticket Max
SQLMaxTix = "SELECT COUNT(OrderLine.ItemNumber) AS TixCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.ItemType = 'Seat' AND Seat.EventCode IN (10600, 10601)"
Set rsMaxTix = OBJdbConnection.Execute(SQLMaxTix)

If Not rsMaxTix.EOF Then

	Response.Write "<HTML>" & vbCrLf
	Response.Write "<HEAD>" & vbCrLf
	Response.Write "<TITLE>" & Title & "</TITLE>" & vbCrLf
	Response.Write "</HEAD>" & vbCrLf

	Response.Write strBody & vbCrLf

%>
	<!--#INCLUDE virtual="TopNavInclude.asp"-->
<%

	If rsMaxTix("TixCount") > 2 Then 'It's too many.  Display a warning and provide a link to the shopping cart

		'Warning
		Response.Write "<H3>Maximum Exceeded</H3>" & vbCrLf
		If Session("UserNumber") = "" Then
			ShoppingCartPath = "/"
		Else
			ShoppingCartPath = "/Management/"
		End If

		Response.Write "<FONT SIZE=""2"">The maximum number of tickets per order is (2) two.  You must remove " & rsMaxTix("TixCount") - 2 & " ticket(s) from your Shopping Cart in order to complete your order.</FONT><BR><BR><FORM ACTION=""" & ShoppingCartPath & "ShoppingCart.asp"" METHOD=""post""><INPUT TYPE=""submit"" VALUE=""Shopping Cart""></FORM><BR><BR>" & vbCrLf
		
	Else
%>
		<SCRIPT LANGUAGE="JavaScript">    

		<!-- Hide code from non-js browsers

	   function validateForm() {
		    formObj = document.Disclaimer;
			var yes = 0;
			var no = 0;

			for (var i=0;i<2;i++) {
			    if (eval("formObj.Response[i].checked") == true)
			        yes++;
				}
			if (yes == 0) {
				alert("Please enter a response.");
				return false;
				}
			}

		// end hiding -->
		</SCRIPT>

<%

		'Get EventDate
		SQLBeybladeDate = "SELECT EventDate FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent', 'SubSeat') AND Seat.EventCode = 7153"
		Set rsBeybladeDate = OBJdbConnection.Execute(SQLBeybladeDate)
		
		If rsBeybladeDate.EOF Then
			BBDate = "November 15, 2003"
		Else
			BBDate = "November 22, 2003"
		End If
		
		rsBeybladeDate.Close
		Set BeybladeDate = nothing
		
		'Show Disclaimer
		Response.Write "<H3>Ticket Disclaimer</H3><BR>" & vbCrLf
		Response.Write "<TABLE><TR><TD><FONT FACE=""verdana,arial,helvetica"" SIZE=""1"">This ticket is non-transferable, non-refundable and not redeemable for cash, and has no cash value. The ticket holder and/or purchaser, on behalf of themselves and for their child under the age of 18, hereby acknowledges, agrees, and assents to the following waiver, release, and discharge which is a condition of their attendance and/or participation at the " & BBDate & " event currently known as the “Beyblade™ Battle Association Blader Jam Championships” (the “Event”).  I permit Corus Entertainment Inc., Hasbro Inc., Atari Inc., Nelvana Limited, d-rights, ABC Family Worldwide Inc., Downtown Disney &#174; District, ESPN Zone &#174;, The Intrepid Museum Foundation, The Regan Group or any of their respective parents, affiliates, subsidiaries, advertising/promotional agencies, retailers, distributors and suppliers (collectively, “Company”) to generate recordings of me and/or my child during and in connection with my or their appearance and/or participation at the Event, which may include but are not limited recordings of our names, likenesses, biographical facts, photographs, voices, conversations, sounds, and performances (the “Recordings”), and to use such Recordings in any and all forms of media, now or hereafter known, as set forth herein.  I acknowledge Company is not obligated to use any of the Recordings.  I agree that Company shall be the exclusive and absolute owner of all rights in and to the Recordings, and that Company will be able to modify the Recordings and to use these rights and Recordings or permit others to use them forever, throughout the world, in any manner, and for any purpose Company chooses including advertising, promoting, and publicizing the Company, the “Beyblade” series, Event, and any merchandise, tie-ins, or other products licensed in connection therewith.  I agree that I shall not have any approval rights with respect to the Recordings.  I release and discharge Company, its affiliated entities and assigns, their respective directors, officers, shareholders, employees, and agents from any legal claims I might have in connection with the use of the rights granted herein and any and all claims which I have or may have for invasion of privacy, defamation, personal injury, or any other cause of action.  Company in its sole discretion reserves the right to revoke attendance and/or participation privileges of any ticket holder and that any such revocation will require ticket holder to leave the Event and the premises where it is situated.</TD></TR></TABLE><BR><BR>" & vbCrLf
		Response.Write "<FORM ACTION=""SurveyBeyblade.asp"" METHOD=""post"" onSubmit='return validateForm()' NAME=""Disclaimer""><INPUT TYPE=""hidden"" NAME=""FormName"" VALUE=""Disclaimer""><TABLE><TR><TD><INPUT TYPE=""radio"" NAME=""Response"" VALUE=""Approve""></TD><TD><FONT SIZE=""2"">I have read and AGREE to the terms of this disclaimer</FONT><TD></TR><TR><TD><INPUT TYPE=""radio"" NAME=""Response"" VALUE=""Decline""></TD><TD><FONT SIZE=""2"">I DO NOT AGREE to the terms of this disclaimer.<BR>Please cancel my order.</FONT></TD></TR></TABLE><BR><INPUT TYPE=""submit"" VALUE=""Submit""></FORM><BR><BR>" & vbCrLf

	End If

%>

	<!--#INCLUDE virtual="FooterInclude.asp"-->

	</BODY>
	</HTML>
<%
	
Else 'There weren't any tickets for these events.  Continue

	Call Continue
	
End If

End Sub 'Disclaimer

'========================

Sub DisclaimerResponse

	'Add Survey Answer
	SQLOrder = "SELECT OrderNumber, CustomerNumber FROM OrderHeader WHERE OrderNumber = " & Session("OrderNumber")
	Set rsOrder = OBJdbConnection.Execute(SQLOrder)

	If Not rsOrder.EOF Then
	
		SQLInsertAnswer = "INSERT SurveyAnswers(SurveyNumber, OrderNumber, CustomerNumber, SurveyDate, AnswerNumber, Answer) VALUES(" & SurveyNumber & ", " & rsOrder("OrderNumber") & ", " & rsOrder("CustomerNumber") & ", '" & Now() & "', 1, '" & Clean(Request("Response")) & "')"
		Set rsInsertAnswer = OBJdbConnection.Execute(SQLInsertAnswer)
	
		If Clean(Request("Response")) = "Approve" Then 'The approved. Continue.
		
			Call Continue
			
		ElseIf Clean(Request("Response")) = "Decline" Then 'Cancel Order

			'Delete OrderLines
			SQLDeleteOrderLines = "DELETE OrderLine WHERE OrderNumber = " & Session("OrderNumber")
			Set rsDeleteOrderLines = OBJdbConnection.Execute(SQLDeleteOrderLines)
			
			'Update Seat Status, OrderNumber on Seat
			SQLUpdateSeats = "UPDATE Seat WITH (ROWLOCK) SET StatusCode = 'A', OrderNumber = 0 WHERE OrderNumber = " & Session("OrderNumber")
			Set rsUpdateSeats = OBJdbConnection.Execute(SQLUpdateSeats)
			
			'Redirect to Default	
			If Session("UserNumber") = "" Then
				Response.Redirect("/Default.asp")
			Else
				Response.Redirect("/Management/Default.asp")
			End If
			
		Else 'No Response.  Redisplay Disclaimer.
		
			Call Disclaimer		

		End If
	
	Else
	
		If Session("UserNumber") = "" Then
			Response.Redirect("/Default.asp")
		Else
			Response.Redirect("/Management/Default.asp")
		End If
	
	End If
	
End Sub 'DisclaimerResponse

'=============================

Sub Continue

	If Session("UserNumber") = "" Then
		'REE 4/19/3 - Modified to use Session Variable for SurveyComplete
		Session("SurveyComplete") = Session("OrderNumber")
		Response.Redirect("/Ship.asp")
	Else
		'REE 4/19/3 - Modified to use Session Variable for SurveyComplete
		Session("SurveyComplete") = Session("OrderNumber")
		Response.Redirect("/Management/AdvanceShip.asp")
	End If

End Sub 'Continue

%>


