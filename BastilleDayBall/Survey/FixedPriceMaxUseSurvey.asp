<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<!--#include virtual="NoCacheInclude.asp"-->

<%

'Committee of French Speaking Societies (6/14/2010)
'===================================================
'Fixed Price Discount with Max System Usage by Ticket Type

'SeatCode   Ticket Type    Fixed Price     Max
'4449       Bleu ticket    $15.00          100
'4450       Blanc ticket   $75.00          50
'4451       Rouge ticket   $150.00         25


'Initialise general parameters
Page = "Survey"
SurveyNumber = 798
DiscountTypeNumber = 46229


'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If


Call ApplyDiscount


'==============================

Sub ApplyDiscount	


DiscountTypeNumber = 46229
DiscountApplied = "N"

OneSeatCode = 4449 'Bleu tickets
OneSystemUsage = 100
OnePrice = 15
OneAppliedCount = 0
OneAvailTickets = 0

TwoSeatCode = 4450 'Blanc tickets
TwoSystemUsage  = 50
TwoPrice = 75
TwoAppliedCount = 0
TwoAvailTickets = 0

ThreeSeatCode = 4451 'Rouge tickets
ThreeSystemUsage = 25
ThreePrice = 150
ThreeAppliedCount = 0
ThreeAvailTickets = 0

	
'Remove discounts on this order
SQLRemove = "UPDATE OrderLine WITH (ROWLOCK) SET DiscountTypeNumber = 0, Discount = 0 WHERE OrderNumber = " & Session("OrderNumber") & " AND DiscountTypeNumber = " & DiscountTypeNumber
Set rsRemove = OBJdbConnection.Execute(SQLRemove)
	
'------------------------------------      
      
'Determine the number of ticket type one which has already been discounted
SQLDiscCountOne = "SELECT Count(OrderLine.LineNumber) as TicketCount FROM OrderLine (NOLOCK) WHERE OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.OrderNumber NOT IN (" & Session("OrderNumber") & ") AND OrderLine.SeatTypeCode = " & OneSeatCode & " "
Set rsDiscCountOne = OBJdbConnection.Execute(SQLDiscCountOne)        
OneAppliedCount = rsDiscCountOne("TicketCount")        
rsDiscCountOne.Close
Set rsDiscCountOne = nothing   


'Determine number of discounts left for ticket type one
OneAvailTickets = (OneSystemUsage - OneAppliedCount)
    
If CInt(OneAvailTickets) > 0 Then 'it is okay to give free tickets

    SQLLineNo = "SELECT TOP(" & OneAvailTickets & ") LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.SeatTypeCode IN (" & OneSeatCode & ") ORDER BY LineNumber"
    Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)
    If Not rsLineNo.EOF Then
        Do While Not rsLineNo.EOF
            SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = 15, DiscountTypeNumber = " & DiscountTypeNumber & " WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber")
            Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
            DiscountApplied = "Y"
            rsLineNo.movenext
        Loop
	End If
	rsLineNo.Close
	Set rsLineNo = Nothing                                  
End If      

'------------------------------------   

'Determine the number of ticket type Two which has already been discounted
SQLDiscCountTwo = "SELECT Count(*) as TicketCount FROM OrderLine (NOLOCK) WHERE OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.SeatTypeCode = " & TwoSeatCode & " "
Set rsDiscCountTwo = OBJdbConnection.Execute(SQLDiscCountTwo)        
TwoAppliedCount = rsDiscCountTwo("TicketCount")        
rsDiscCountTwo.Close
Set rsDiscCountTwo = nothing   


'Determine number of discounts left for ticket type Two
TwoAvailTickets = (TwoSystemUsage - TwoAppliedCount)
    
If CInt(TwoAvailTickets) > 0 Then 'it is okay to give free tickets

    SQLLineNo = "SELECT TOP(" & TwoAvailTickets & ") LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.SeatTypeCode IN (" & TwoSeatCode & ") ORDER BY LineNumber"
    Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)
    If Not rsLineNo.EOF Then
        Do While Not rsLineNo.EOF
            SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = 20, DiscountTypeNumber = " & DiscountTypeNumber & " WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber")
            Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
            DiscountApplied = "Y"
            rsLineNo.movenext
        Loop
	End If
	rsLineNo.Close
	Set rsLineNo = Nothing                                  
End If     

'------------------------------------       
    
'Determine the number of ticket type Three which has already been discounted
SQLDiscCountThree = "SELECT Count(*) as TicketCount FROM OrderLine (NOLOCK) WHERE OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.SeatTypeCode = " & ThreeSeatCode & " "
Set rsDiscCountThree = OBJdbConnection.Execute(SQLDiscCountThree)        
ThreeAppliedCount = rsDiscCountThree("TicketCount")        
rsDiscCountThree.Close
Set rsDiscCountThree = nothing   


'Determine number of discounts left for ticket type Three
ThreeAvailTickets = (ThreeSystemUsage - ThreeAppliedCount)
    
If CInt(ThreeAvailTickets) > 0 Then 'it is okay to give free tickets

    SQLLineNo = "SELECT TOP(" & ThreeAvailTickets & ") LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.SeatTypeCode IN (" & ThreeSeatCode & ") ORDER BY LineNumber"
    Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)
    If Not rsLineNo.EOF Then
        Do While Not rsLineNo.EOF
            SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = 50, DiscountTypeNumber = " & DiscountTypeNumber & " WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber")
            Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
            DiscountApplied = "Y"
            rsLineNo.movenext
        Loop
	End If
	rsLineNo.Close
	Set rsLineNo = Nothing                                  
End If   

'------------------------------------   
        
If DiscountApplied = "Y" Then
        Call WarningPage
    Else
        Call Continue
End If


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

<%	

Response.Write "<BR><BR><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=2><H3>Congratulations!</H3></FONT>" & vbCrLf

Response.Write "<CENTER><TABLE><TR><TD><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=2>Your ticket purchase qualified for early bird pricing.<BR><BR><CENTER>" & vbCrLf

If Session("UserNumber") = "" Then
Response.Write "<TR><TD ALIGN=""center""><FORM ACTION=""/Ship.asp"" METHOD=""POST"" id=form1 name=form1>" & vbCrLf
Else
Response.Write "<TR><TD ALIGN=""center""><FORM ACTION=""/Management/AdvanceShip.asp"" METHOD=""POST"" id=form1 name=form1>" & vbCrLf
End If

Response.Write "<BR><BR><INPUT TYPE=""submit"" VALUE=""Continue"" id=1 name=1></FORM></CENTER></TD></TR></TABLE></CENTER><BR><BR>" & vbCrLf

%>

<!--#INCLUDE virtual="FooterInclude.asp"-->

<%	

Response.Write "</BODY>" & vbCrLf
Response.Write "</HTML>" & vbCrLf

		
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