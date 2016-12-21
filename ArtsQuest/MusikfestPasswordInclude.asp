<%
If Session("OrderNumber") <> "" Then
	OrderNumber = Session("OrderNumber")
End If

SQLMembershipPassword = "SELECT ItemNumber FROM OrderLine (NOLOCK) WHERE OrderNumber = " & OrderNumber & " AND ItemNumber IN (23, 24, 25) AND ItemType = 'Donation'"
Set rsMembershipPassword = OBJdbConnection.Execute(SQLMembershipPassword)

Do Until rsMembershipPassword.EOF
	Select Case rsMembershipPassword("ItemNumber")
		Case 25
			MembershipPassword = MembershipPassword & "<BR><FONT FACE=""verdana, arial, helvetica"" SIZE=""3""><B>Your Club ArtsQuest User is ""castar"".<BR>Your Musikfest Password is ""casta2007"".</B></FONT><BR>"
		Case 24
			MembershipPassword = MembershipPassword & "<BR><FONT FACE=""verdana, arial, helvetica"" SIZE=""3""><B>Your Club ArtsQuest User is ""casuper"".<BR>Your Musikfest Password is ""casup2007"".</B></FONT><BR>"
		Case 23
			MembershipPassword = MembershipPassword & "<BR><FONT FACE=""verdana, arial, helvetica"" SIZE=""3""><B>Your Club ArtsQuest User is ""camega"".<BR>Your Musikfest Password is ""cameg2007"".</B></FONT><BR>"
		Case 170
			MembershipPassword = MembershipPassword & "<BR><FONT FACE=""verdana, arial, helvetica"" SIZE=""3""><B>Your Club ArtsQuest User is ""caelite"".<BR>Your Musikfest Password is ""caeli2007"".</B></FONT><BR>"
	End Select

	rsMembershipPassword.MoveNext

Loop

rsMembershipPassword.Close
Set rsMembershipPassword = nothing

If MembershipPassword <> "" Then
	MembershipPassword = MembershipPassword & "<BR>" & vbCrLf
End If

%>