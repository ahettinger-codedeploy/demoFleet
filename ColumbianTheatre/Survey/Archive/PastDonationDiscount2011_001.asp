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

'Columbian Theater
'Past Donation Discount Survey

'Purchase donation (Individual,Family,Columbian Assets,Corporate Eagles,JC Rogers,Roger Circle Patrons)
'within the past 365 days and receive a discount for valid ticket type to any event

'Valid Ticket Type
'------------------
'Adult


'Placeholder discount - does not need to be attached to events
'---------------------------------------------------------------

IndividualNumber = 61334	

FamilyNumber = 61342

AssetsNumber = 61335	

EagleNumber = 61336	

JCRogersNumber = 61337

RogerCircleNumber = 61339


'Per Ticket Discount
'-------------------
'Individual	- $5 off Adult ticket
IndividualDiscount = 5

'Family	- 100% off Child ticket (with each Adult ticket purchased)
FamilyDiscount = 100

'Assets -10% off Adult ticket	
AssetsDiscount = 10

'Eagles -15% off Adult ticket
EagleDiscount = 15
	
'JC Rogers - 20% off Adult ticket
JCRogersDiscount = 20%

'Roger Circle Patrons - 25% off Adult ticket
RogerCircleDiscount = 25


'Donation Levels
'---------------
ItemNumberList = "349,350,351,352,353,354"


'Valid Ticket Types
'-------------------
AllowedSeatType = "1008,1012,1011,1015"











'Columbian Theater
'Automatic discount based on past donation

'349 Individual		
'$5 off Adult ticket

'350 Family	
'100% off Child ticket (with each Adult ticket purchased)

'351 Columbian Assets
'10% off Adult ticket

'352 Corporate Eagles
'15% off Adult ticket
	
'353 JC Rogers	
'20% off Adult ticket

'354 Roger Circle Patrons
'25% off Adult ticket


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

'349 Individual	- $5 off Adult ticket
IndividualNumber = 61334	
IndividualDiscount = 5

'350 Family	- 100% off Child ticket 
'(with each Adult ticket purchased)
FamilyNumber = 61342
FamilyDiscount = 100

'351 Assets -10% off Adult ticket
AssetsNumber = 61335	
AssetsDiscount = 10

'352 Eagles -15% off Adult ticket
EagleNumber = 61336	
EagleDiscount = 15
	
'353 JC Rogers - 20% off Adult ticket
JCRogersNumber = 61337
JCRogersDiscount = 20%

'354 Roger Circle Patrons - 25% off Adult ticket
RogerCircleNumber = 61339
RogerCircleDiscount = 25

'Membership Levels 
ItemNumberList = "349,350,351,352,353,354"


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
	Call CalcDiscount	
Else
	Call Continue
End If

End Sub 'MemberCheck

'==========================================================

Sub CalcDiscount	


SQLFreeTickets  = "SELECT OrderLine.ItemNumber FROM OrderHeader (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber WHERE (OrderLine.ItemNumber IN (" & ItemNumberList & ")) AND (CustomerNumber = " & Session("CustomerNumber") & " AND OrderHeader.StatusCode = 'S' OR OrderHeader.OrderNumber = " & Session("OrderNumber") & ") ORDER BY LineNumber"
Set rsFreeTickets   = OBJdbConnection.Execute(SQLFreeTickets)

    If Not rsFreeTickets.EOF Then
        
        Do While Not rsFreeTickets.EOF
               
            Select Case rsFreeTickets("ItemNumber")
                Case  349  'Individual - $5 off 
                    DiscType = Amount
                    
                Case  350  'Family - Free Child with Adult 
                    DiscType = BOGO
                    
                Case  351  'Assets - 10% off 
                    DiscType = Percentage
                    
                Case  352  'Eagles - 15% off 
                    DiscType = Percentage
                    
                Case  353  'JC Rogers - 20% off
                    DiscType = Percentage
                    
                Case 354   'Rogers Circle - 25% off
                    DiscType = Percentage                
            End Select
        
        rsFreeTickets.movenext    
        Loop
    	
    End If

rsFreeTickets.Close
Set rsFreeTickets = Nothing  

Call ApplyDiscount(DiscType)


End Sub 'CalcDiscount


''==========================================================

Sub ApplyFree	


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
               
    Select Case DiscType
        Case  Amount
            
            
        Case   BOGO
            
            
        Case  Percentage
            
                        
    End Select



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