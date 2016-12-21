<%
SQLMembershipPassword = "SELECT ItemNumber FROM OrderLine (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND ItemNumber IN (23, 24, 25) AND ItemType = 'Donation'"
Set rsMembershipPassword = OBJdbConnection.Execute(SQLMembershipPassword)

Do Until rsMembershipPassword.EOF
	Select Case rsMembershipPassword("ItemNumber")
		Case 25
			MembershipPassword = MembershipPassword & "<BR><FONT FACE=""verdana, arial, helvetica"" SIZE=""3""><B>Your Musikfest User is ""CMstar"".<BR>Your Musikfest Password is ""festing2"".</B></FONT><BR>"
		Case 24
			MembershipPassword = MembershipPassword & "<BR><FONT FACE=""verdana, arial, helvetica"" SIZE=""3""><B>Your Musikfest User is ""CMsuperstar"".<BR>Your Musikfest Password is ""festing4"".</B></FONT><BR>"
		Case 23
			MembershipPassword = MembershipPassword & "<BR><FONT FACE=""verdana, arial, helvetica"" SIZE=""3""><B>Your Musikfest User is ""CMmegastar"".<BR>Your Musikfest Password is ""festing6"".</B></FONT><BR>"
	End Select

	rsMembershipPassword.MoveNext

Loop

rsMembershipPassword.Close
Set rsMembershipPassword = nothing

If MembershipPassword <> "" Then
	MembershipPassword = MembershipPassword & "<BR>" & vbCrLf
End If

%>