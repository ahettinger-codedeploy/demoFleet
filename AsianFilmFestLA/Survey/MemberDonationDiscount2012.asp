<%

'CHANGE LOG - Inception
'SSR 4/6/2011
'TTT 4/3/2012 - Revised for 2012 Member Donations
'TTT 4/17/2012 - Excluded VIP tix count from past discounted tix and only to those attached to the right DiscountTypeNumber
'TTT 4/27/2012 - Applied COMP/Fixed discount to VIP Tickets to Opening Night and accounted two discounted tickets per subscription event ticket
'JAI 5/3/12 - Added Expiration Date for Internet orders.

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->

<%

'============================================================

Page = "Survey"
SurveyNumber = 1229
SurveyFileName = "MemberDonationDiscount2012.asp"
OnlineExpirationDate = CDate("5/3/12")

'Survey variables

If Session("UserNumber")<> "" Then
    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "FFFFFF"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "000000"
    TableDataBGColor = "E9E9E9"
    ClientFolder= "Tix"
Else
    ClientFolder = "asianfilmfestla"
End If

'============================================================

'Discount variables

DiscountTypeNumber = 56298

'Membership Levels 
ItemNumberList = "3669,3671,3673,3674,3675,3676,3677,3678,3679,3680,3681,3682,3683"

'ClosingNight - VIP Events
CloseEventList = "458059"

'Opening Night - VIP Events
OpenEventList = "448528, 448530"

Dim ItemNo
'============================================================

'Survey Start. 
'Check to see if Order Number exists.
'Skip Survey if Comp Order
'Request the form name and process requested action

If Session("OrderNumber") = "" Then

	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
    Else
		Response.Redirect("/Management/Default.asp")
	End If
	
Else

	If Session("UserNumber") = "" Then
        Page = "Survey"
	Else
	    Page = "Management"
	End If
	
End If

If Session("OrderTypeNumber") = 5 Then
	Call Continue
End If


Select Case Clean(Request("FormName"))
    Case "Continue"
        Call Continue
    Case Else
        If Session("OrderTypeNumber") = 1 And Now() > OnlineExpirationDate Then
            Call Continue
        Else
            Call MemberCheck
        End If
 End Select
 

OBJdbConnection.Close
Set OBJdbConnection = nothing

'==========================================================

Sub MemberCheck

DonationFound = False

'Check for donations in current order
SQLMemberCurrent = "SELECT OrderLine.ItemNumber FROM OrderLine (NOLOCK) WHERE OrderLine.ItemNumber IN (" & ItemNumberList & ") AND OrderLine.OrderNumber = " & CleanNumeric(Session("OrderNumber"))
Set rsMemberCurrent = OBJdbConnection.Execute(SQLMemberCurrent)
If Not rsMemberCurrent.EOF Then 'it is in order
    DonationFound = True
End If
rsMemberCurrent.Close
Set rsMemberCurrent = nothing


'Check for donations in past orders
SQLMemberPrevious = "SELECT OrderLine.ItemNumber FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE CustomerNumber = " & CleanNumeric(Session("CustomerNumber")) & " AND OrderLine.ItemNumber IN (" & ItemNumberList & ") AND OrderHeader.StatusCode = 'S' ORDER BY OrderLine.ItemNumber"
Set rsMemberPrevious = OBJdbConnection.Execute(SQLMemberPrevious)
If Not rsMemberPrevious.EOF Then
    DonationFound = True
End If
rsMemberPrevious.Close
Set rsMemberPrevious = nothing


If DonationFound Then 
	Call ApplyFree
Else
	Call Continue
End If

End Sub 'MemberCheck

'==========================================================

Sub ApplyFree	

     FreeTicketCount = 0
  AllowedTicketCount = 0    'Total number of free tickets allowed
  AppliedTicketCount = 0    'Number of free tickets already given
AvailableTicketCount = 0    'Number of free tickets available for this order



'Remove other discounts from this order
SQLDiscLine = "SELECT LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.ItemType IN ('Seat','SubFixedEvent') ORDER BY LineNumber"
Set rsDiscLine = OBJdbConnection.Execute(SQLDiscLine)

If Not rsDiscLine.EOF Then
    Do While Not rsDiscLine.EOF
    
        SQLClearDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = 0, DiscountTypeNumber = 0 WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsDiscLine("LineNumber")
        Set rsClearDiscount = OBJdbConnection.Execute(SQLClearDiscount)
        
    rsDiscLine.movenext
    Loop
End If

rsDiscLine.Close
Set rsDiscLine = Nothing  

HighClassFound = False
SQLFreeTickets  = "SELECT OrderLine.ItemNumber FROM OrderHeader (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber WHERE (OrderLine.ItemNumber IN (" & ItemNumberList & ")) AND (CustomerNumber = " & Session("CustomerNumber") & " AND OrderHeader.StatusCode = 'S' OR OrderHeader.OrderNumber = " & Session("OrderNumber") & ") ORDER BY LineNumber"
Set rsFreeTickets   = OBJdbConnection.Execute(SQLFreeTickets)

If Not rsFreeTickets.EOF Then
    Do While Not rsFreeTickets.EOF
               
        Select Case rsFreeTickets("ItemNumber")
            Case  3669 'VC SUPPORTER 
                Count = 0
                OpeningCount = 0
                ClosingCount = 0                
            Case  3671 'VC FRIEND
                Count = 2
                OpeningCount = 0
                ClosingCount = 0
            Case  3673 'VC FILMMAKER 
                Count = 4
                OpeningCount = 0
                ClosingCount = 0
            Case  3674 'VC SPONSOR 
                Count = 6
                OpeningCount = 2
                ClosingCount = 2
            Case  3675 'VC PATRON 
                Count = 8
                OpeningCount = 1
                ClosingCount = 2
            Case 3676 'VC BENEFACTOR
                Count = 10
                OpeningCount = 2
                ClosingCount = 2
            Case 3677 'VC DIRECTOR
                Count = 1
                OpeningCount = 2
                ClosingCount = 2
                HighClassFound = True
            Case 3678 'VIP ALL-ACCESS PASS
                Count = 1
                OpeningCount = 1
                ClosingCount = 1
                HighClassFound = True
            Case 3679 'VIP FESTIVAL GUEST 
                Count = 15
                OpeningCount = 1
                ClosingCount = 1
                HighClassFound = True
            Case 3680 'NON-VIP FESTIVAL GUEST A 
                Count = 15
                OpeningCount = 1
                ClosingCount = 1
                HighClassFound = True
            Case 3681 'NON-VIP FESTIVAL GUEST B 
                Count = 15
                OpeningCount = 1
                ClosingCount = 0
                HighClassFound = True
            Case 3682 'NON-VIP FESTIVAL GUEST C
                Count = 15
                OpeningCount = 0
                ClosingCount = 1
                HighClassFound = True
            Case 3683 'FESTIVAL GUEST
                Count = 15
                OpeningCount = 0
                ClosingCount = 0
                HighClassFound = True
        End Select
         
        AllowedTicketCount = AllowedTicketCount + Count        
        CustomerOpeningCount = CustomerOpeningCount + OpeningCount
        CustomerClosingCount = CustomerClosingCount + ClosingCount

        ItemNo = rsFreeTickets("ItemNumber")
        rsFreeTickets.movenext    
    Loop
    	
End If

rsFreeTickets.Close
Set rsFreeTickets = Nothing  


'Determine number of free tickets already given
SQLApplied = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderHeader.CustomerNumber = " & Session("CustomerNumber") & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.StatusCode = 'S' AND OrderLine.ItemType IN ('Seat', 'SubSeat') AND Seat.EventCode NOT IN (" & CloseEventList & "," & OpenEventList & ") AND Seat.EventCode IN (SELECT EventCode FROM DiscountEvents (NOLOCK) WHERE DiscountTypeNumber = " & DiscountTypeNumber & ")"
Set rsApplied = OBJdbConnection.Execute(SQLApplied)
AppliedTicketCount = rsApplied("TicketCount")
rsApplied.Close
Set rsApplied = nothing

	
'Determine number of free tickets left
AvailableTicketCount = (AllowedTicketCount - AppliedTicketCount)


If CInt(AvailableTicketCount) > 0 Then 'it is okay to give free tickets 
    If HighClassFound Then 'Discounts for 1 per event and max 15 tix
        SQLLineNo = "SELECT"
        If AvailableTicketCount Mod 15 = 0 Then
            SQLLineNo = SQLLineNo & " TOP (15)"
        End If
        SQLLineNo = SQLLineNo & " Seat.EventCode FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.ItemType IN ('Seat','SubFixedEvent') AND Event.EventCode NOT IN (" & CloseEventList & "," & OpenEventList & ") AND Event.SurveyNumber = " & SurveyNumber & " GROUP BY Seat.EventCode"
        Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)
        Do While Not rsLineNo.EOF
            SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = Price, DiscountTypeNumber = " & DiscountTypeNumber & ", Surcharge = 0  WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber IN (SELECT TOP 1 OrderLine.LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.ItemType IN ('Seat','SubFixedEvent') AND Seat.EventCode = " & rsLineNo("EventCode") & ")"
            Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
            If rsLineNo("EventCode") = "463727" Then 'Subscription Event
                SQLApplyChild = "UPDATE OrderLine WITH (ROWLOCK) SET DiscountTypeNumber = " & DiscountTypeNumber & " WHERE OrderNumber = " & Session("OrderNumber") & " AND ItemType = 'SubSeat' AND ParentLineNumber IN (SELECT TOP 1 OrderLine.LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Seat.EventCode = " & rsLineNo("EventCode") & " AND OrderLine.ItemType = 'SubFixedEvent' AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & ")"
                Set rsApplyChild = OBJdbConnection.Execute(SQLApplyChild)
                AvailableTicketCount = AvailableTicketCount - 1
            End If
            FreeTicketCount = FreeTicketCount+ 1
            AvailableTicketCount = AvailableTicketCount - 1
            rsLineNo.movenext
        Loop
        rsLineNo.Close
        Set rsLineNo = Nothing
    Else
        SQLLineNo = "SELECT TOP(" & AvailableTicketCount & ") LineNumber, OrderLine.ItemType FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN EVENT (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.ItemType IN ('Seat','SubFixedEvent') AND Event.EventCode NOT IN (" & CloseEventList & "," & OpenEventList & ") ORDER BY OrderLine.Price DESC"
        Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)
        If Not rsLineNo.EOF Then
            Do While Not rsLineNo.EOF And AvailableTicketCount > 0
                SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = Price, DiscountTypeNumber = " & DiscountTypeNumber & ", Surcharge = 0  WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber")
                Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
                If rsLineNo("ItemType") = "SubFixedEvent" Then
                    SQLApplyChild = "UPDATE OrderLine WITH (ROWLOCK) SET DiscountTypeNumber = " & DiscountTypeNumber & " WHERE OrderNumber = " & Session("OrderNumber") & " AND ItemType = 'SubSeat' AND ParentLineNumber = " & rsLineNo("LineNumber")
                    Set rsApplyChild = OBJdbConnection.Execute(SQLApplyChild)
                    AvailableTicketCount = AvailableTicketCount - 1
                End If
                FreeTicketCount = FreeTicketCount+ 1
                AvailableTicketCount = AvailableTicketCount - 1
                rsLineNo.movenext
            Loop
        End If
        rsLineNo.Close
        Set rsLineNo = Nothing 
    End If
End If
  

If CustomerOpeningCount > 0 Then
    Call ApplyOpenFree(CustomerOpeningCount)
End If
If CustomerClosingCount > 0 Then
    Call ApplyCloseFree(CustomerClosingCount)
End If

Call ApplyDiscount(FreeTicketCount)
Call Continue

End Sub 'ApplyDiscount

'==========================================================

Sub ApplyOpenFree(VIPCount)

  AllowedOpenTicketCount = VIPCount     'Total number of free tickets allowed
  AppliedOpenTicketCount = 0            'Number of free tickets already given
AvailableOpenTicketCount = 0            'Number of free tickets available for this order
FreeTicketCount = 0

'Determine number of free tickets already given
WHERECLAUSE = ""
If ItemNo = "3678" Or ItemNo = "3679" Then
    WHERECLAUSE = " AND OrderLine.Discount = OrderLine.Price"
End If
SQLAppliedOpen = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderHeader.CustomerNumber = " & Session("CustomerNumber") & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.StatusCode = 'S' AND Seat.EventCode IN (" & OpenEventList & ")" & WHERECLAUSE
Set rsAppliedOpen = OBJdbConnection.Execute(SQLAppliedOpen)
AppliedOpenTicketCount= rsAppliedOpen("TicketCount")
rsAppliedOpen.Close
Set rsAppliedOpen = nothing

'Determine number of free tickets left
AvailableOpenTicketCount = (AllowedOpenTicketCount - AppliedOpenTicketCount)
               
If CInt(AvailableOpenTicketCount) > 0 Then 'it is okay to give free tickets 

    SQLOpenLineNo = "SELECT LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN EVENT (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Seat.EventCode IN (" & OpenEventList & ") AND OrderLine.SeatTypeCode IN (155) ORDER BY OrderLine.Price"
    Set rsOpenLineNo = OBJdbConnection.Execute(SQLOpenLineNo)
    If Not rsOpenLineNo.EOF Then
        Do While Not rsOpenLineNo.EOF
            If FreeTicketCount < AvailableOpenTicketCount Then
                If ItemNo = "3678" Or ItemNo = "3679" Then 'within limit, COMP tickets only VIP ItemNumbers
                    SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = Price, DiscountTypeNumber = " & DiscountTypeNumber & ", Surcharge = 0  WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOpenLineNo("LineNumber") & " "
                Else
                    SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = Price - 75, DiscountTypeNumber = " & DiscountTypeNumber & ", Surcharge = 0  WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOpenLineNo("LineNumber") & " "
                End If
                Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)                
            Else 'update vip tickets to fixed price $75 after exceed limits only to VIP ItemNumbers
                If ItemNo = "3678" Or ItemNo = "3679" Then
                    SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = Price - 75, DiscountTypeNumber = " & DiscountTypeNumber & ", Surcharge = 0  WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOpenLineNo("LineNumber") & " "
                    Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
                End If
            End If
            FreeTicketCount = FreeTicketCount+ 1
            rsOpenLineNo.movenext
        Loop
    End If
    rsOpenLineNo.Close
    Set rsOpenLineNo = Nothing 
    
End If


End Sub 'ApplyOpenFree

'==========================================================

Sub ApplyCloseFree(VIPCount)

  AllowedCloseTicketCount = VIPCount     'Total number of free tickets allowed
  AppliedCloseTicketCount = 0            'Number of free tickets already given
AvailableCloseTicketCount = 0            'Number of free tickets available for this order


'Determine number of free tickets already given
SQLAppliedClose = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderHeader.CustomerNumber = " & Session("CustomerNumber") & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.StatusCode = 'S' AND Seat.EventCode IN (" & CloseEventList & ")"
Set rsAppliedClose = OBJdbConnection.Execute(SQLAppliedClose)
AppliedCloseTicketCount= rsAppliedClose("TicketCount")
rsAppliedClose.Close
Set rsAppliedClose = nothing


'Determine number of free tickets left
AvailableCloseTicketCount = (AllowedCloseTicketCount - AppliedCloseTicketCount)
               
If CInt(AvailableCloseTicketCount) > 0 Then 'it is okay to give free tickets 

    SQLCloseLineNo = "SELECT TOP(" & AvailableCloseTicketCount & ") LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN EVENT (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Seat.EventCode IN (" & CloseEventList & ") ORDER BY OrderLine.Price DESC"
    Set rsCloseLineNo = OBJdbConnection.Execute(SQLCloseLineNo)
    If Not rsCloseLineNo.EOF Then
        Do While Not rsCloseLineNo.EOF
            SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = Price, DiscountTypeNumber = " & DiscountTypeNumber & ", Surcharge = 0  WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsCloseLineNo("LineNumber")
            Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
            FreeTicketCount = FreeTicketCount+ 1
            rsCloseLineNo.movenext
        Loop
    End If
    rsCloseLineNo.Close
    Set rsCloseLineNo = Nothing 
    
End If


End Sub 'ApplyCloseFree

'==========================================================

Sub ApplyDiscount(FreeTicketCount)

DiscountTicketCount = 0

'Apply discount for this membership level
SQLLineNo = "SELECT OrderLine.LineNumber, OrderLine.Price FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.DiscountTypeNumber = 0 AND OrderLine.Price IN (12,15) ORDER BY LineNumber"
Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)

If Not rsLineNo.EOF Then
    Do While Not rsLineNo.EOF

            If rsLineNo("Price") = 12 Then
                DiscountAmount = 2
            ElseIf rsLineNo("Price") = 15 Then
                DiscountAmount = 3
            End If
                
            SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = " & DiscountAmount & ", DiscountTypeNumber = " & DiscountTypeNumber & " WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber") & " "
            Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
            DiscountApplied = "Y"
            DiscountTicketCount = DiscountTicketCount + 1
                     
    rsLineNo.movenext
    Loop
End If

rsLineNo.Close
Set rsLineNo = Nothing  


End Sub 'ApplyDiscount

'==========================================================

Sub WarningPage(DiscountTicketCount,FreeTicketCount)

Select Case FreeTicketCount
    Case  1
        S1 = ""
    Case Else
        S1 = "s"
 End Select
 
 Select Case DiscountTicketCount
    Case  1
        S2 = ""
    Case Else
        S2 = "s"
 End Select
 
%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>

<head>

<title>Member Discount</title>

<style type="text/css">
body
{
    font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
    line-height: 1 em;
}
#rounded-corner
{
	font-size: 13px;
    font-weight: 400;
	width: 600px;
	text-align: left;
	border-collapse: collapse;
}
#rounded-corner thead th.category
{
	padding-top: 10px;
    padding-bottom: 10px;
    padding-left: 0px;
    padding-right: 1px;
	font-size: 15px;
	font-weight: 600;
	text-align: center;
	color: <%=TableCategoryFontColor%>;
	background: <%=TableCategoryBGColor%>;
}
#rounded-corner thead th.category-left
{
	background: <%=TableCategoryBGColor%> url('/Clients/<%=ClientFolder%>/Survey/Images/nw.gif') left -1px no-repeat;
	text-align: right;
}
#rounded-corner thead th.category-right
{
	background: <%=TableCategoryBGColor%> url('/Clients/<%=ClientFolder%>/Survey/Images/ne.gif') right -1px no-repeat;
    text-align: left;
}
#rounded-corner td.footer
{
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.footer-left
{
	background: <%=TableDataBGColor%> url('/Clients/<%=ClientFolder%>/Survey/Images/sw.gif') left bottom no-repeat;
}
#rounded-corner td.footer-right
{
	background: <%=TableDataBGColor%> url('/Clients/<%=ClientFolder%>/Survey/Images/se.gif') right bottom no-repeat;
}
#rounded-corner td.data
{
	padding-left: 25px;
	padding-right: 25px;
	padding-top: 15px;
	padding-bottom: 15px;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
</style>

</head>

<%=strBody %>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<form action="<%= SurveyFileName %>" NAME="Survey" >
<input type="hidden" name="SurveyNumber" value="<%= SurveyNumber %>">
<input type="hidden" name="FormName" value="Continue">
<br />
<table id="rounded-corner" summary="surveypage" >
<thead>
    <tr>
	    <th scope="col" class="category-left"></th>
	    <th scope="col" class="category" colspan="2"><b>Congratulations!</b></th>
	    <th scope="col" class="category-right"></th>
    </tr>        
</thead>
    <tbody>
    <tr>
        <td class="data" colspan="4">
<%
        If FreeTicketCount > 0 Then
%>
        Your membership has qualified you for <%= FreeTicketCount %> complimentary ticket<%= S1 %> on this order.<br />
         <br />
<%
        End If

        If DiscountTicketCount > 0 Then
%>
        Your membership has qualified you for <%= DiscountTicketCount %> discounted ticket<%= S2 %> on this order.<br />
         <br />
<%
        End If
%>      
        </td>
    </tr>
    <tr>
        <td class="footer-left">&nbsp;</td>
        <td class="footer" colspan="2">&nbsp;</td>
        <td class="footer-right">&nbsp;</td>
    </tr>
    <tr align="center">
        <td>&nbsp;</td>
        <td colspan="2"><br /><INPUT TYPE="submit" VALUE="Continue"></FORM></td>
        <td>&nbsp;</td>
    </tr>
</table>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>
</html>

<%

End Sub ' Warning Page

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