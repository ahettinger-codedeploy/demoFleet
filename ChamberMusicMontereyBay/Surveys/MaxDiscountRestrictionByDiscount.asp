<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<!--#INCLUDE VIRTUAL="CalcCustomerFeeInclude.asp"-->
<%
Page = "Survey"


'========================================

'Chamber Music Monterey Bay (9/28/2010)

'This survey counts the number of times a discount code has been used by the patron. 
'Discount code "worldmusic30" - Max use: 1 order

Page = "Survey"
SurveyNumber = 865
SurveyName = "MaxDiscountRestrictionByDiscount.asp"

'Initialize Survey Variables
MemberEventList = "265748,293267,293270,293274,293275,293276" 'Eventcode for which discount is valid
DiscountNumberList = "48814" 'Valid discount codes
DiscountAmount = 1.0


'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If

'Check to see if this is a Comp Order. If so, bypass this survey.
If Session("OrderTypeNumber") = 5 Then
	Call Continue
Else
	Call CheckCurrentOrder
End if



'==============================

Sub CheckCurrentOrder


'Check if there is a discount code to the current order
SQLCurrentDiscount = "SELECT OrderLine.DiscountTypeNumber FROM OrderLine (NOLOCK) WHERE OrderLine.DiscountTypeNumber IN (" & DiscountNumberList & ") AND OrderLine.OrderNumber = " & CleanNumeric(Session("OrderNumber"))
Set rsCurrentDiscount = OBJdbConnection.Execute(SQLCurrentDiscount)

If Not rsCurrentDiscount.EOF Then 
		CurrentDiscountFound = True
		CurrentDiscountTypeNumber = rsCurrentDiscount("DiscountTypeNumber")
End If

rsCurrentDiscount.Close
Set rsCurrentDiscount = nothing


'If discount found on order proceed to check past order
'otherwise bypass restriction 
If CurrentDiscountFound Then 
	Call CheckPastOrders(CurrentDiscountTypeNumber)
Else
	Call Continue
End If



End Sub 'CheckCurrentOrder

'==============================
Sub CheckPastOrders(CurrentDiscountTypeNumber)

'Check if customer has used this discount code before
SQLPastDiscount = "SELECT OrderLine.DiscountTypeNumber FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE CustomerNumber = " & CleanNumeric(Session("CustomerNumber")) & " AND OrderLine.DiscountTypeNumber = " & CurrentDiscountTypeNumber & " AND OrderHeader.OrderNumber <> " & CleanNumeric(Session("OrderNumber")) & " ORDER BY OrderLine.DiscountTypeNumber"
Set rsPastDiscount = OBJdbConnection.Execute(SQLPastDiscount)

If Not rsPastDiscount.EOF Then
    PastDiscountFound = True
End If

rsPastDiscount.Close
Set rsPastDiscount = nothing

'If discount found on past orders proceed to apply discount
'otherwise bypass restriction
If PastDiscountFound Then 
	Call ApplyDiscount(CurrentDiscountTypeNumber)
Else
	Call Continue
End If


End Sub 'CheckPastOrders

'==============================

Sub ApplyDiscount(CurrentDiscountTypeNumber)

Select Case CurrentDiscountTypeNumber
	Case 48814 'RCA2
		DiscountCode ="worldmusic30"
		TotalFreeTickets = 20
	Case 30618 'RCA4
		DiscountCode ="RCA4"
		TotalFreeTickets = 4
	Case 30710 'RCACHAIR
		DiscountCode ="RCACHAIR"
		TotalFreeTickets = 2
End Select

AppliedCount = 0
NumberFreeTickets = 0

If Session("OrderTypeNumber") = 1 Then
			If Clean(Request("Price"))> 0 Then
				NewSurcharge = 0
			Else
				NewSurcharge = 0
			End If
Else
			If Clean(Request("Price"))> 0 Then
				NewSurcharge = 0
			Else
				NewSurcharge = 0
			End If
End if

SQLRemove = "UPDATE OrderLine WITH (ROWLOCK) SET DiscountTypeNumber = 0, Discount = 0, Surcharge = " & NewSurcharge & " WHERE OrderNumber = " & Session("OrderNumber") & " AND DiscountTypeNumber = " & CurrentDiscountTypeNumber
Set rsRemove = OBJdbConnection.Execute(SQLRemove)

'Determine the number of tickets for which this customer has already received a discount
SQLApplied = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE OrderHeader.CustomerNumber = " & Session("CustomerNumber") & " AND OrderLine.DiscountTypeNumber = " & CurrentDiscountTypeNumber & " AND OrderLine.StatusCode = 'S'"
Set rsApplied = OBJdbConnection.Execute(SQLApplied)
AppliedCount = rsApplied("TicketCount")
rsApplied.Close
Set rsApplied = nothing

NumberFreeTickets = (TotalFreeTickets - AppliedCount)
    
If CInt(NumberFreeTickets) > 0 Then 'It is ok to give further discounts

				DiscountApplied = "N"

				SQLLineNo = "SELECT TOP(" & NumberFreeTickets & ") LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Seat.EventCode IN (" & MemberEventList & ")" & " ORDER BY LineNumber"
				Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)

				If Not rsLineNo.EOF Then
							Do While Not rsLineNo.EOF
									SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = (Price * " & DiscountAmount & "), Surcharge = 0, DiscountTypeNumber = " & CurrentDiscountTypeNumber & " WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber")& ""
									Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
									DiscountApplied = "Y"
									rsLineNo.movenext
							Loop
				End If

				rsLineNo.Close
				Set rsLineNo = Nothing
				        
				If DiscountApplied = "Y" Then
					Call CongratulationsPage(NumberFreeTickets)
				Else
					Call WarningPage(DiscountCode,TotalFreeTickets)
				End If


Else
        Call WarningPage(DiscountCode,TotalFreeTickets)
End If

End Sub 'ApplyDiscount	

'==============================

Sub CongratulationsPage(NumberFreeTickets)

If NumberFreeTickets = 1 Then
	tix1 = "ticket"
Else
	tix1 = "tickets"
End If

%>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<%

Session("SurveyComplete") = Session("OrderNumber")

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & Title & "</TITLE>" & vbCrLf
Response.Write "</HEAD>" & vbCrLf
Response.Write "<BODY BGCOLOR=" & BGColor & " LINK="& LinkColor & " ALINK=" & ALinkColor & " VLINK=" & VLinkColor & " leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0 " & BodyParameters & ">" & vbCrLf
Response.Write "<FONT FACE=" & FontFace & " COLOR=" & HeadingFontColor & " SIZE=""2""><H3>CONGRATULATIONS!!</H3></FONT>" & vbCrLf
Response.Write "<CENTER><TABLE><TR><TD><FONT FACE=" & FontFace & " COLOR=" & FontColor & " SIZE=""2"">Your order qualifies for discount pricing on your order.<BR><BR><CENTER>" & vbCrLf

If Session("UserNumber") = "" Then
	Response.Write "<FORM ACTION=""/Ship.asp"" METHOD=""POST"" id=form1 name=form1>" & vbCrLf
Else
	Response.Write "<FORM ACTION=""/Management/AdvanceShip.asp"" METHOD=""POST"" id=form1 name=form1>" & vbCrLf
End If

Response.Write "<INPUT TYPE=""submit"" VALUE=""Continue"" id=1 name=1></FORM></CENTER></TD></TR></TABLE></CENTER><BR><BR>" & vbCrLf
Response.Write "</BODY>" & vbCrLf
Response.Write "</HTML>" & vbCrLf

%>

<!--#INCLUDE virtual="FooterInclude.asp"-->

<%			

End Sub 'CongratulationsPage

'==============================

Sub WarningPage(DiscountCode,TotalFreeTickets)

%>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<%

Session("SurveyComplete") = Session("OrderNumber")

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & Title & "</TITLE>" & vbCrLf
Response.Write "</HEAD>" & vbCrLf
Response.Write "<BODY BGCOLOR=" & BGColor & " LINK="& LinkColor & " ALINK=" & ALinkColor & " VLINK=" & VLinkColor & " leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0 " & BodyParameters & ">" & vbCrLf
Response.Write "<H3>SORRY</H3>" & vbCrLf
Response.Write "<CENTER><TABLE><TR><TD ALIGN=""center""><FONT FACE=" & FontFace & " COLOR=" & FontColor & " SIZE=""2"">The discount code <B>" & DiscountCode & "</B> is no longer valid.<BR>" & vbCrLf
Response.Write "<FONT FACE=" & FontFace & " COLOR=" & FontColor & " SIZE=""2"">The maximum usage of this discount has been reached.<BR><BR>" & vbCrLf

If Session("UserNumber") = "" Then
	Response.Write "<FORM ACTION=""/Ship.asp"" METHOD=""POST"" id=form1 name=form1>" & vbCrLf
Else
	Response.Write "<FORM ACTION=""/Management/AdvanceShip.asp"" METHOD=""POST"" id=form1 name=form1>" & vbCrLf
End If

style="width: 5em"
Response.Write "<INPUT TYPE=""submit"" VALUE=""OK"" STYLE=""width: 5em"" id=1 name=1></FORM></CENTER></TD></TR></TABLE></CENTER><BR><BR>" & vbCrLf
Response.Write "</BODY>" & vbCrLf
Response.Write "</HTML>" & vbCrLf

%>

<!--#INCLUDE virtual="FooterInclude.asp"-->

<%			

End Sub 'WarningPage

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