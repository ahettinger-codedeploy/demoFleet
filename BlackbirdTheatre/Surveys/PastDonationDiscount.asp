<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%
Page = "Survey"

SurveyNumber = 490
DiscountTypeNumber = 31544
ItemNumberList = "1741,1742,1743"
DiscountAmount = 1.0 '100% Discount

'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If

'Check to see if this is a Comp Order. If so, skip discount.
If Session("OrderTypeNumber") = 5 Then
	Call Continue
End If

DonationFound = False
'Check if the donation item number is in order
SQLMemberDonation = "SELECT OrderLine.ItemNumber FROM OrderLine (NOLOCK) WHERE OrderLine.ItemNumber IN (" & ItemNumberList & ") AND OrderLine.OrderNumber = " & CleanNumeric(Session("OrderNumber"))
Set rsMemberDonation = OBJdbConnection.Execute(SQLMemberDonation)
If Not rsMemberDonation.EOF Then 'it is in order
    DonationFound = True
    DonationItemNo = rsMemberDonation("ItemNumber")
End If
rsMemberDonation.Close
Set rsMemberDonation = nothing

'check if this customer has purchased this donation item number before
SQLMemberBefore = "SELECT OrderLine.ItemNumber FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE CustomerNumber = " & CleanNumeric(Session("CustomerNumber")) & " AND OrderLine.ItemNumber IN (" & ItemNumberList & ") AND OrderHeader.OrderNumber <> " & CleanNumeric(Session("OrderNumber")) & " ORDER BY OrderLine.ItemNumber"
Set rsMemberBefore = OBJdbConnection.Execute(SQLMemberBefore)
If Not rsMemberBefore.EOF Then
    DonationFound = True
    DonationItemNo = rsMemberBefore("ItemNumber")
End If
rsMemberBefore.Close
Set rsMemberBefore = nothing

If DonationFound Then 
	Call ApplyDiscount
Else
	Call Continue
End If


'==============================

Sub ApplyDiscount

Select Case DonationItemNo
    Case "1741"
        ProductionFreeList = "30532"
        TotalFreeTickets = 2
    Case "1742"
        ProductionFreeList = ""
        TotalFreeTickets = 4
    Case "1743"
        ProductionFreeList = ""
        TotalFreeTickets = 2
End Select

ProductionList = Split(ProductionFreeList,",")

For ActCd = lbound(ProductionList) to ubound(ProductionList)
    ApplyDiscountOK = false
    'Check if this production has given away free tickets before
    SQLDiscCheck = "SELECT OrderLine.LineNumber FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE CustomerNumber = " & CleanNumeric(Session("CustomerNumber")) & " AND ActCode = " & CleanNumeric(ProductionList(ActCd)) & " AND OrderHeader.OrderNumber <> " & CleanNumeric(Session("OrderNumber"))
    Set rsDiscCheck = OBJdbConnection.Execute(SQLDiscCheck)
    If rsDiscCheck.EOF Then 
        ApplyDiscountOK = true
    End If
    rsDiscCheck.Close
    Set rsDiscCheck = Nothing
    
    If ApplyDiscountOK Then 'it is okay to give free tickets
        SQLLineNo = "SELECT TOP(" & TotalFreeTickets & ") LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN EVENT (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND ActCode = " & ProductionList(ActCd) & " ORDER BY LineNumber DESC"
        Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)
        If Not rsLineNo.EOF Then
            Do While Not rsLineNo.EOF
                SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = Price * " & DiscountAmount & ", Surcharge = 0, DiscountTypeNumber = " & DiscountTypeNumber & " WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber")
                Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
                rsLineNo.movenext
            Loop
        End If
        rsLineNo.Close
        Set rsLineNo = Nothing
    End If
Next

Call DBClose(OBJdbConnection)
	
Call Continue

End Sub 'ApplyDiscount

'==============================

Sub WarningPage

Session("SurveyComplete") = Session("OrderNumber")

If FontFace = "" Then
	FontFace = "verdana,arial,helvetica"
End If

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & Title & "</TITLE>" & vbCrLf
Response.Write "</HEAD>" & vbCrLf

Response.Write "<BODY BGCOLOR=" & BGColor & " LINK="& LinkColor & " ALINK=" & ALinkColor & " VLINK=" & VLinkColor & " leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0 " & BodyParameters & ">" & vbCrLf
					
%>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<BR>
<BR>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3>Congratulations!!</H3></FONT>

<%
If Session("UserNumber") = "" Then
	Response.Write "<CENTER><TABLE><TR><TD><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=2>Your membership has qualified you for a discount on this order.<BR><BR><CENTER><FORM ACTION=""/Ship.asp"" METHOD=""POST"" id=form1 name=form1><INPUT TYPE=""submit"" VALUE=""Continue"" id=1 name=1></FORM></CENTER></TD></TR></TABLE></CENTER><BR><BR>" & vbCrLf
Else
	Response.Write "<CENTER><TABLE><TR><TD><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=2>Your membership has qualified you for a discount on this order.<BR><BR><CENTER><FORM ACTION=""/Management/AdvanceShip.asp"" METHOD=""POST"" id=form1 name=form1><INPUT TYPE=""submit"" VALUE=""Continue"" id=1 name=1></FORM></CENTER></TD></TR></TABLE></CENTER><BR><BR>" & vbCrLf
End If

%>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%			
End Sub 'Warning Page

'==============================

Sub Continue
				
Session("SurveyComplete") = Session("OrderNumber")
If Session("UserNumber") = "" Then
	Response.Redirect("/Ship.asp")
Else
	Response.Redirect("/Management/AdvanceShip.asp")
End If		

End Sub 'Continue

'==============================

%>