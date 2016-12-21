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
		
		'Show Disclaimer
		Response.Write "<H3>TICKET DISCLAIMER</H3><BR>" & vbCrLf
		Response.Write "<TABLE><TR><TD><FONT FACE=""verdana,arial,helvetica"" SIZE=""1"">For good and valuable consideration, the receipt and sufficiency of such are hereby acknowledged, I and my parent or legal guardian hereby agree as follows:<BR><BR>1. I acknowledge that my execution of this Waiver and Release is a condition of the Company (as defined below) permitting me to participate in the Event. I acknowledge I have been provided with the BBA Times Square Rumble (the ""Event"") Official Rules of Play and that I will review them. I hereby certify that I am in proper physical condition and meet the appropriate age and ability standards to participate in Event. I further certify that neither I, my parent or legal guardian, nor any member of my immediate family is an employee of Hasbro Inc., Corus Entertainment Inc., Nelvana Limited, Atari Inc., d-rights, ABC Family Worldwide Inc., The World Entertainment, Inc., The Regan Group or any of their respective parents, affiliates, subsidiaries, advertising and promotional agencies, retailers, distributors and suppliers (collectively, the ""Company""). I understand that my parent or legal guardian is solely responsible for all federal, provincial, and municipal taxes on any items received in connection with the Event.<BR><BR>2. In consideration of my attendance at and/or participation in the Event, I hereby release and forever discharge the Company and all sponsors of the Event, their respective parents, subsidiaries, affiliates, and each of their respective officers, directors, agents, successors, sponsors, employees, partners, licensees and assigns from and against any and all manner of action, causes of actions, suits, debts, covenants, contracts, claims and demands, including legal fees and expenses, whatsoever including but not limited to claims based on negligence, breach of contract and fundamental breach, liability for physical injury, death, property damage, invasion of privacy, defamation, or any other cause of action arising from a result of my attendance at and/or participation in this Event or as a result of any item received by me in connection with the Event. <BR><BR>3. I hereby agree that the Company shall have, without further obligation to me, the right to record my name, likeness, biographical facts, video image, photograph, voice, conversation, sounds, and performance in connection with my appearance and/or participation at the Event and/or other activities related to the Event (including, without limitation, any travel related to the Event or activity at the World Entertainment Complex) (the ""Recordings"") and to use such Recordings in any manner and all forms of media, now or hereafter known, as set forth herein. I acknowledge that the Company shall be the exclusive and absolute owner of all rights in and to the Recordings and will be able to modify the Recordings and to use these rights and Recordings or permit others to use them forever, throughout the world, in any manner, and for any purpose the Company chooses including advertising, promoting, and publicizing the Company, Event (or any portion thereof), and any merchandise, tie-ins, or other products licensed in connection therewith. I further acknowledge the Company is not obligated to use any of the Recordings.<BR><BR>4. I understand and agree this is a complete release and discharge of all claims and rights of me, my parent or legal guardian, our respective heirs, executors, and administrators against the Company, and their respective directors, officers, shareholders, employees, and agents from any legal claims I might have in connection with the use of the rights granted in this Waiver and Release and any and all claims which I may have for invasion of privacy, defamation, personal injury, or any other cause of action. I have voluntarily agreed to this Waiver and Release and understand its contents.<BR><BR>I consent to the foregoing Waiver and Release on behalf of my child, and I hereby grant permission for my child to participate in the Event, as applicable. I acknowledge my execution of this Waiver and Release is a condition of the Company permitting my child to participate in the Event. I acknowledge I have been provided with the Event Official Rules of Play and that I have reviewed them with my child. I understand and acknowledge that I must be present at all times when my child is participating in the Event. In addition, on my own behalf, I agree that my attendance at the Event may be recorded and that such recording may be used by the Company in any manner and media without any further compensation or my further consent. Furthermore, on my own behalf, I agree to the provisions of paragraphs 2 and 4. <BR><BR></TD></TR></TABLE><BR><BR>" & vbCrLf
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
	SQLOrder = "SELECT OrderNumber, CustomerNumber FROM OrderHeader (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber")
	Set rsOrder = OBJdbConnection.Execute(SQLOrder)

	If Not rsOrder.EOF Then
	
		SQLInsertAnswer = "INSERT SurveyAnswers(SurveyNumber, OrderNumber, CustomerNumber, SurveyDate, AnswerNumber, Question, Answer) VALUES(" & SurveyNumber & ", " & rsOrder("OrderNumber") & ", " & rsOrder("CustomerNumber") & ", '" & Now() & "', 1, 'I have read and AGREE to the terms of this disclaimer', '" & Clean(Request("Response")) & "')"
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


