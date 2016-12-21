<%

'CHANGE LOG - Inception
'SSR 4/6/2011

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->

<%

'============================================================

Page = "Survey"
SurveyNumber = 1001
SurveyFileName = "MemberDonationDiscount2011.asp"

'============================================================

'Visual Communiations
'Silvia’s Client
 
'Our friends at Visual Communications need a custom survey.  The current or past purchase of the following items entitles you to specific benefits.
 
'Please see below for the itemnumber and corresponding benefits that should be given automatically.

'VIP Events
'eventcode   eventdate  act
'----------- ---------- -------------------------------------------------------------------------------
'351974      2011-04-28 Opening Night Celebration - FAST FIVE - DGA 1 - 4/28 - 7PM
'353251      2011-05-05 CLOSING NIGHT CELEBRATION: LOVE IN DISGUISE (Lian ai tong gao) - CGV 1 - 5/5 - 7PM
'353253      2011-05-05 CLOSING NIGHT CELEBRATION: LOVE IN DISGUISE (Lian ai tong gao) - CGV 2 - 5/5 - 7PM
'353258 	 2011-05-05 CLOSING NIGHT CELEBRATION: LOVE IN DISGUISE (Lian ai tong gao) - CGV 3 - 5/5 - 7PM


'3260 VC SUPPORTER
'Discounts: 
'Fixed price - $10 on $12 tickets
'Fixed price - $12 on $15 tickets


'3261 VC FRIEND 
'Discounts: 
'Fixed price - $10 on $12 tickets
'Fixed price - $12 on $15 tickets
'2 free tickets to any event 
'Exclude: Opening Night, Closing Night


'3262 VC FILMMAKER 
'Discounts: 
'Fixed price - $10 on $12 tickets
'Fixed price - $12 on $15 tickets
'4 free tickets to any event. (exclude: Opening Night, Closing Night)


'3263 VC SPONSOR 
'Discounts: 
'Fixed price - $10 on $12 tickets
'Fixed price - $12 on $15 tickets
'2 free tickets to Opening Night
'2 free tickets to Closing Night
'6 free tickets to any event.
 

'3264 VC PATRON 
'Discounts: 
'Fixed price - $10 on $12 tickets
'Fixed price - $12 on $15 tickets
'2 free tickets to Opening Night
'2 free tickets to Closing Night
'8 free tickets to any event. (exclude: Opening Night, Closing Night)


'3265 VC BENEFACTOR
'Discounts: 
'Fixed price - $10 on $12 tickets
'Fixed price - $12 on $15 tickets
'2 free tickets to Opening Night
'2 free tickets to Closing Night
'10 free tickets to any event (exclude: Opening Night, Closing Night)


'3266 VC DIRECTOR
'Discounts: 
'Fixed price - $10 on $12 tickets
'Fixed price - $12 on $15 tickets
'2 free tickets to Opening Night
'2 free tickets to Closing Night

'============================================================

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

'100% Discount
SeriesPercentage = 1.0

'Membership Levels 
ItemNumberList = "3260,3261,3262,3263,3264,3265,3266"

'ClosingNight - VIP Events
CloseEventList = "353251, 353253, 353258"

'Opening Night - VIP Events
OpenEventList = "351974"


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
        Call MemberCheck
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
    DonationItemNo = rsMemberCurrent("ItemNumber")
End If
rsMemberCurrent.Close
Set rsMemberCurrent = nothing


'Check for donations in past orders
SQLMemberPrevious = "SELECT OrderLine.ItemNumber FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE CustomerNumber = " & CleanNumeric(Session("CustomerNumber")) & " AND OrderLine.ItemNumber IN (" & ItemNumberList & ") AND OrderHeader.OrderNumber <> " & CleanNumeric(Session("OrderNumber")) & " ORDER BY OrderLine.ItemNumber"
Set rsMemberPrevious = OBJdbConnection.Execute(SQLMemberPrevious)
If Not rsMemberPrevious.EOF Then
    DonationFound = True
    DonationItemNo = rsMemberPrevious("ItemNumber")
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


SQLFreeTickets  = "SELECT OrderLine.ItemNumber FROM OrderHeader (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber WHERE (OrderLine.ItemNumber IN (" & ItemNumberList & ")) AND (CustomerNumber = " & Session("CustomerNumber") & " AND OrderHeader.StatusCode = 'S' OR OrderHeader.OrderNumber = " & Session("OrderNumber") & ") ORDER BY LineNumber"
Set rsFreeTickets   = OBJdbConnection.Execute(SQLFreeTickets)

    If Not rsFreeTickets.EOF Then
        Do While Not rsFreeTickets.EOF
               
        Select Case rsFreeTickets("ItemNumber")
            Case  3260 'VC SUPPORTER 
                Count = 0
                
            Case  3261 'VC FRIEND
                Count = 2
                
            Case  3262 'VC FILMMAKER 
                Count = 4
                
            Case  3263 'VC SPONSOR 
                Count = 12
                ExtraCount = 0
                
            Case  3264 'VC PATRON 
                Count = 18
                ExtraCount = 0
                
            Case 3265 'VC BENEFACTOR
                Count = 24
                ExtraCount = 0
                
            Case 3266 'VC DIRECTOR
                Count = 0
                ExtraCount = 0
                
         End Select
         
        AllowedTicketCount = AllowedTicketCount + Count
        
        VIPCount = VIPCount + ExtraCount
        
        rsFreeTickets.movenext    
        Loop
    	
    End If

rsFreeTickets.Close
Set rsFreeTickets = Nothing  


'Determine number of free tickets already given
SQLApplied = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE OrderHeader.CustomerNumber = " & Session("CustomerNumber") & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.StatusCode = 'S'"
Set rsApplied = OBJdbConnection.Execute(SQLApplied)
AppliedTicketCount = rsApplied("TicketCount")
rsApplied.Close
Set rsApplied = nothing

	
'Determine number of free tickets left
AvailableTicketCount = (AllowedTicketCount - AppliedTicketCount)


If CInt(AvailableTicketCount) > 0 Then 'it is okay to give free tickets 

    SQLLineNo = "SELECT TOP(" & AvailableTicketCount & ") LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN EVENT (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.ItemType IN ('Seat','SubFixedEvent') AND Event.EventCode NOT IN (" & CloseEventList & "," & OpenEventList & ") ORDER BY OrderLine.Price DESC"
    Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)
    If Not rsLineNo.EOF Then
        Do While Not rsLineNo.EOF
            SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = Price * " & SeriesPercentage & ", DiscountTypeNumber = " & DiscountTypeNumber & ", Surcharge = 0  WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber")
            Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
            FreeTicketCount = FreeTicketCount+ 1
            rsLineNo.movenext
        Loop
    End If
    rsLineNo.Close
    Set rsLineNo = Nothing 
    
End If
  

If VIPCount > 0 Then
    Call ApplyOpenFree(FreeTicketCount,VIPCount)
Else
    Call ApplyDiscount(FreeTicketCount)
End If

End Sub 'ApplyDiscount

'==========================================================

Sub ApplyOpenFree(FreeTicketCount,VIPCount)

  AllowedOpenTicketCount = VIPCount     'Total number of free tickets allowed
  AppliedOpenTicketCount = 0            'Number of free tickets already given
AvailableOpenTicketCount = 0            'Number of free tickets available for this order


'Determine number of free tickets already given
SQLAppliedOpen = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderHeader.CustomerNumber = " & Session("CustomerNumber") & " AND OrderLine.DiscountTypeNumber = " & DiscountTypeNumber & " AND OrderLine.StatusCode = 'S' AND Seat.EventCode IN (" & OpenEventList & ")"
Set rsAppliedOpen = OBJdbConnection.Execute(SQLAppliedOpen)
AppliedOpenTicketCount= rsAppliedOpen("TicketCount")
rsAppliedOpen.Close
Set rsAppliedOpen = nothing

'Determine number of free tickets left
AvailableOpenTicketCount = (AllowedOpenTicketCount - AppliedOpenTicketCount)
               
If CInt(AvailableOpenTicketCount) > 0 Then 'it is okay to give free tickets 

    SQLOpenLineNo = "SELECT TOP(" & AvailableOpenTicketCount & ") LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN EVENT (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Seat.EventCode IN (" & OpenEventList & ") ORDER BY OrderLine.Price"
    Set rsOpenLineNo = OBJdbConnection.Execute(SQLOpenLineNo)
    If Not rsOpenLineNo.EOF Then
        Do While Not rsOpenLineNo.EOF
            SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = Price * " & SeriesPercentage & ", DiscountTypeNumber = " & DiscountTypeNumber & ", Surcharge = 0  WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOpenLineNo("LineNumber") & " "
            Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
            DiscountApplied = "Y"
            FreeTicketCount = FreeTicketCount+ 1
            rsOpenLineNo.movenext
        Loop
    End If
    rsOpenLineNo.Close
    Set rsOpenLineNo = Nothing 
    
End If

Call ApplyCloseFree(FreeTicketCount,VIPCount)

End Sub 'ApplyOpenFree

'==========================================================

Sub ApplyCloseFree(FreeTicketCount,VIPCount)

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
            SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = Price * " & SeriesPercentage & ", DiscountTypeNumber = " & DiscountTypeNumber & ", Surcharge = 0  WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsCloseLineNo("LineNumber")
            Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
            FreeTicketCount = FreeTicketCount+ 1
            rsCloseLineNo.movenext
        Loop
    End If
    rsCloseLineNo.Close
    Set rsCloseLineNo = Nothing 
    
End If

Call ApplyDiscount(FreeTicketCount)

End Sub 'ApplyCloseFree

'==========================================================

Sub ApplyDiscount(FreeTicketCount)

DiscountTicketCount = 0

'Apply discount for this membership level
SQLLineNo = "SELECT OrderLine.LineNumber, OrderLine.Price FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.DiscountTypeNumber <> " & DiscountTypeNumber & " AND OrderLine.Price IN (12,15) ORDER BY LineNumber"
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

Call WarningPage(DiscountTicketCount,FreeTicketCount)


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