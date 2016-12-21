<%

'CHANGE LOG - Inception
'SSR 10/20/2011

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->

<%

'============================================================

Page = "Survey"
SurveyNumber = 1131
SurveyFileName = "PastDonationDiscount2011.asp"

'============================================================

'Columbian Theater
'Past Donation Discount Survey

'Purchase donation in the past year and receive a discount for valid ticket type to any event

'Valid Ticket Type
'------------------
'Adult Show & Buffet (1012)
'Adult Show Only (1008)


'Donation Levels
'-------------------

'351  'Assets - 10% off Adult ticket
AssetsNumber = 61335	
AssetsDescription = "Columbian Assets Membership"
AssetsPercentage = .10

'352  'Eagles - 15% off Adult ticket
EaglesNumber = 61336	
EaglesDescription = "Corporate Eagle Membership"
EaglesPercentage = .15
	
'353  'JC Rogers - 20% off Adult ticket
JCRogersNumber =   61337
JCRogersDescription =  "J.C. Rogers Circle Membership"
JCRogersPercentage = .20

'354  'Roger Circle Patrons - 25% off Adult ticket
RCircleNumber =   61339
RCircleDescription = "Roger Circle Patron Membership"
RCirclePercentage = .25


'Additional Donation Levels
'-------------------------
'349 Individual	- $5 off Adult ticket
IndividualNumber = 61334	
IndividualDescription = "Individual Membership"
IndividualDiscount = 5

'350 Family	- Free Child with Adult ticket
FamilyNumber = 61342	
FamilyDescription = "Family Membership"
FamilyDiscount = 1.0


'Donation Levels
'---------------
DiscountNumberList = "61335,61336,61337,61339,61334,61342"
ItemNumberList = "349,351,352,353,354"
FamilyNumberList = "350"
SeatTypeList = "1012,1008"
ChildSeatList = "1015,1011"

'============================================================

'CSS Survey Variables

If Session("UserNumber")<> "" Then
    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "FFFFFF"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "000000"
    TableDataBGColor = "E9E9E9"
    'LastHex = box color
    'FirstHex = background color
    NECorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=008400&Src=TopLeftCorner16.txt"
    NWCorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=008400&Src=TopRightCorner16.txt"
    SWCorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=E9E9E9&Src=BottomLeftCorner16.txt"
    SECorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=E9E9E9&Src=BottomRightCorner16.txt"
Else
    'LastHex = box color
    'FirstHex = background color
    NECorner="/clients/tix/images/image.asp?FirstHex=f1ecd9&LastHex=343730&Src=TopLeftCorner16.txt"
    NWCorner="/clients/tix/images/image.asp?FirstHex=f1ecd9&LastHex=343730&Src=TopRightCorner16.txt"
    SWCorner="/clients/tix/images/image.asp?FirstHex=f1ecd9&LastHex=f1f1f1&Src=BottomLeftCorner16.txt"
    SECorner="/clients/tix/images/image.asp?FirstHex=f1ecd9&LastHex=f1f1f1&Src=BottomRightCorner16.txt"
End If

'============================================================
 
'Check to see if Order Number exists.
'Display management tabs for box office orders

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

'============================================================

'Bypass this survey on Comp Orders

If Session("OrderTypeNumber") = 5 Then
	Call Continue
End If

'============================================================

'Request the form name and process requested action

Select Case Clean(Request("FormName"))
    Case "Continue"
        Call Continue
    Case Else
        Call MemberCheck
 End Select
 

'============================================================

Sub MemberCheck

DonationFound = False
DiscountFound = False
FamilyDonationFound = False

'-------------------------------------------
'Check for Group Donations
'-------------------------------------------

'Check for group donations in current order
SQLMemberCurrent = "SELECT OrderLine.ItemNumber FROM OrderLine (NOLOCK) WHERE OrderLine.ItemNumber IN (" & ItemNumberList & ") AND OrderLine.OrderNumber = " & CleanNumeric(Session("OrderNumber"))
Set rsMemberCurrent = OBJdbConnection.Execute(SQLMemberCurrent)
    If Not rsMemberCurrent.EOF Then 'it is in order
        DonationFound = True
    End If
rsMemberCurrent.Close
Set rsMemberCurrent = nothing


'Check for group donations in the past year
SQLMemberPrevious = "SELECT OrderLine.ItemNumber FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE CustomerNumber = " & CleanNumeric(Session("CustomerNumber")) & " AND OrderLine.ItemNumber IN (" & ItemNumberList & ") AND OrderHeader.OrderNumber <> " & CleanNumeric(Session("OrderNumber")) & " AND GetDate() < DateAdd(day, 365, OrderDate) ORDER BY OrderLine.ItemNumber"
Set rsMemberPrevious = OBJdbConnection.Execute(SQLMemberPrevious)
    If Not rsMemberPrevious.EOF Then
        DonationFound = True
    End If
rsMemberPrevious.Close
Set rsMemberPrevious = nothing



'-------------------------------------------
'Check for Family Donations
'-------------------------------------------

'Check for Family donations in current order
SQLFamilyCurrent = "SELECT OrderLine.ItemNumber FROM OrderLine (NOLOCK) WHERE OrderLine.ItemNumber IN (" & FamilyNumberList  & ") AND OrderLine.OrderNumber = " & CleanNumeric(Session("OrderNumber")) & ""
Set rsFamilyCurrent = OBJdbConnection.Execute(SQLFamilyCurrent)
    If Not rsFamilyCurrent.EOF Then 'it is in order
        FamilyDonationFound = True
    End If
rsFamilyCurrent.Close
Set rsFamilyCurrent = nothing


'Check for Family donations in the past year
SQLFamilyPrevious = "SELECT OrderLine.ItemNumber FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE CustomerNumber = " & CleanNumeric(Session("CustomerNumber")) & " AND OrderLine.ItemNumber IN (" & FamilyNumberList  & ") AND OrderHeader.OrderNumber <> " & CleanNumeric(Session("OrderNumber")) & " AND GetDate() < DateAdd(day, 365, OrderDate) ORDER BY OrderLine.ItemNumber"
Set rsFamilyPrevious = OBJdbConnection.Execute(SQLFamilyPrevious)
    If Not rsFamilyPrevious.EOF Then
        FamilyDonationFound = True
    End If
rsFamilyPrevious.Close
Set rsFamilyPrevious = nothing


'-------------------------------------------
'Check for Other Discounts
'-------------------------------------------

'Check the order for any other discounts
SQLOtherDiscount = "SELECT OrderLine.ItemNumber FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE OrderLine.OrderNumber = " & CleanNumeric(Session("OrderNumber")) & " AND OrderLine.DiscountTypeNumber <> 0"
Set rsOtherDiscount = OBJdbConnection.Execute(SQLOtherDiscount)
    If Not rsOtherDiscount.EOF Then
           DiscountFound = True
    End If
rsOtherDiscount.Close
Set rsOtherDiscount = nothing



'-------------------------------------------
'Process the Orders
'-------------------------------------------

'If some other external discount has been assigned, then bypass this donation discount
'Otherwise, if the patron qualifies for the family donation discount process that discount first   
'And then process any other donation discount 

If DiscountFound Then
    Call Continue
 
ElseIf FamilyDonationFound Then 
Call ApplyFamilyDiscount
   
ElseIf DonationFound Then 
    FamilyDiscountMessage = ""
	Call ApplyDiscount(FamilyDiscountMessage)
	
Else
    Call Continue
    
End If


End Sub 'MemberCheck



'============================================================

Sub ApplyFamilyDiscount

ApplyFamily = False

FamilyTicketCount = 0

FamilyDiscountApplied = "N"

FamilyDiscountMessage = ""


'--------------------------------
'Clear and Reset any Discounts
'--------------------------------

SQLDiscLine = "SELECT OrderLine.LineNumber, OrderLine.ItemNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " ORDER BY LineNumber"
Set rsDiscLine = OBJdbConnection.Execute(SQLDiscLine)

If Not rsDiscLine.EOF Then
    Do While Not rsDiscLine.EOF
    
        SQLClearDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = 0, DiscountTypeNumber = 0 WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsDiscLine("LineNumber")
        Set rsClearDiscount = OBJdbConnection.Execute(SQLClearDiscount)
        
    rsDiscLine.MoveNext
    Loop
End If

rsDiscLine.Close
Set rsDiscLine = Nothing


'----------------------------
'Verify Family Membershiop
'----------------------------

SQLFamilyTickets  = "SELECT OrderLine.ItemNumber FROM OrderHeader (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber WHERE (OrderLine.ItemNumber IN (" & FamilyNumberList & ")) AND (CustomerNumber = " & Session("CustomerNumber") & " AND OrderHeader.StatusCode = 'S' OR OrderHeader.OrderNumber = " & Session("OrderNumber") & ") ORDER BY ItemNumber"
Set rsFamilyTickets   = OBJdbConnection.Execute(SQLFamilyTickets)

If Not rsFamilyTickets.EOF Then
    Do While Not rsFamilyTickets.EOF

    Select Case rsFamilyTickets("ItemNumber")
    
        Case 350 'Family - 100% off Child tickets
            ApplyFamily = True
                 
    End Select  
      
    rsFamilyTickets.movenext
    Loop
    
End If

rsFamilyTickets.Close
Set rsFamilyTickets = Nothing


'---------------------------
'Apply Family Discount
'---------------------------

If ApplyFamily Then

    'Determine number of adult tickets on order
    SQLApplied = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.SeatTypeCode IN (" & SeatTypeList & ")"
    Set rsApplied = OBJdbConnection.Execute(SQLApplied)
    AvailableTicketCount = rsApplied("TicketCount")
    rsApplied.Close
    Set rsApplied = nothing
    

    If CInt(AvailableTicketCount) > 0 Then 'it is okay to give discounted tickets 

        SQLLineNo = "SELECT TOP(" & AvailableTicketCount & ") LineNumber FROM OrderLine (NOLOCK) WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.SeatTypeCode IN (" & ChildSeatList & ")"
        Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)
        If Not rsLineNo.EOF Then
        
        
            Do While Not rsLineNo.EOF
                SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = (Price * " & FamilyDiscount & "), DiscountTypeNumber = " & FamilyNumber & " WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber")& ""
                Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
                FamilyTicketCount = FamilyTicketCount + 1
                FamilyDiscountApplied = "Y"
                rsLineNo.movenext
            Loop
        End If
        rsLineNo.Close
        Set rsLineNo = Nothing 
        
    End If
        
End If
           
If FamilyDiscountApplied = "Y" Then

        Select Case FamilyTicketCount
        Case 1
             FamilyDiscountMessage = "Your Family Membership has qualified this<br /> order for 1 free child ticket."
        Case Else
             FamilyDiscountMessage = "Your Family Membership has qualified this<br /> order for " & FamilyTicketCount & " free child tickets."
        End Select
        
End If


Call ApplyDiscount(FamilyDiscountMessage)


End Sub 'ApplyFamilyDiscount

'============================================================

Sub ApplyDiscount(FamilyDiscountMessage)

'Discount allows for either a $5.00 per ticket or a variable percentage rate discount

ApplyIndividual = False

ApplyGroup = False

IndividualTicketCount = 0

GroupTicketCount = 0

DiscountMessage = ""


'----------------------------
'Determine Membership Level
'----------------------------

SQLFreeTickets  = "SELECT OrderLine.ItemNumber FROM OrderHeader (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber WHERE (OrderLine.ItemNumber IN (" & ItemNumberList & ")) AND (CustomerNumber = " & Session("CustomerNumber") & " AND OrderHeader.StatusCode = 'S' OR OrderHeader.OrderNumber = " & Session("OrderNumber") & ") ORDER BY ItemNumber"
Set rsFreeTickets   = OBJdbConnection.Execute(SQLFreeTickets)

If Not rsFreeTickets.EOF Then
    Do While Not rsFreeTickets.EOF

    Select Case rsFreeTickets("ItemNumber")
    
        Case 349 'Individual - $5 off Adult ticket
            ApplyIndividual = True
    
        Case 351  'Assets - 10% off Adult ticket
            GroupMembership = AssetsDescription
            GroupNumber = AssetsNumber
            GroupDiscount = AssetsPercentage
            ApplyGroup = True
        
        Case 352  'Eagles - 15% off Adult ticket
            GroupMembership = EagleDescription
            GroupNumber = EagleNumber
            GroupDiscount = EaglePercentage
            ApplyGroup = True
        
        Case 353  'JC Rogers - 20% off Adult ticket
            GroupMembership = JCRogersDescription
            GroupNumber = JCRogersNumber
            GroupDiscount = JCRogersPercentage
            ApplyGroup = True
        
        Case 354  'Roger Circle Patrons - 25% off Adult ticket
            GroupMembership = RCircleDescription
            GroupNumber = RCircleNumber
            GroupDiscount = RCirclePercentage
            ApplyGroup = True
            
    End Select  
      
    rsFreeTickets.movenext
    Loop
    
End If

rsFreeTickets.Close
Set rsFreeTickets = Nothing


'---------------------------
'Apply Individual Discount
'---------------------------

If ApplyIndividual Then

    'Determine number of adult tickets to discount
    SQLApplied = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.SeatTypeCode IN (" & SeatTypeList & ")"
    Set rsApplied = OBJdbConnection.Execute(SQLApplied)
    AvailableTicketCount = rsApplied("TicketCount")
    rsApplied.Close
    Set rsApplied = nothing

    If CInt(AvailableTicketCount) > 0 Then 'it is okay to give discounted tickets 

        SQLLineNo = "SELECT TOP(" & AvailableTicketCount & ") LineNumber FROM OrderLine (NOLOCK) WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.SeatTypeCode IN (" & SeatTypeList & ")"
        Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)
        If Not rsLineNo.EOF Then
            Do While Not rsLineNo.EOF
                SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = " & IndividualDiscount & ", DiscountTypeNumber = " & IndividualDiscount & " WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber")
                Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
                IndividualTicketCount = IndividualTicketCount + 1
                DiscountApplied = "Y"
                rsLineNo.movenext
            Loop
        End If
        rsLineNo.Close
        Set rsLineNo = Nothing 
        
    End If
           

'---------------------------
'OR Apply Group Discount
'---------------------------

ElseIf ApplyGroup Then

    'Determine number of adult tickets to discount
    SQLApplied = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.SeatTypeCode IN (" & SeatTypeList & ")"
    Set rsApplied = OBJdbConnection.Execute(SQLApplied)
    AvailableTicketCount = rsApplied("TicketCount")
    rsApplied.Close
    Set rsApplied = nothing

    If CInt(AvailableTicketCount) > 0 Then 'it is okay to give discounted tickets 

        SQLLineNo = "SELECT TOP(" & AvailableTicketCount & ") LineNumber FROM OrderLine (NOLOCK) WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.SeatTypeCode IN (" & SeatTypeList & ")"
        Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)
        If Not rsLineNo.EOF Then
            Do While Not rsLineNo.EOF
                SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = Price * " & GroupDiscount & ", DiscountTypeNumber = " & GroupNumber & " WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber")
                Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
                GroupTicketCount = GroupTicketCount + 1
                DiscountApplied = "Y"
                rsLineNo.movenext
            Loop
        End If
        rsLineNo.Close
        Set rsLineNo = Nothing 
        
    End If
    

End If


If DiscountApplied = "Y" Then
'If Discount were discounted process the discount message

    If ApplyIndividual Then
        Select Case IndividualTicketCount
        Case 1
             DiscountMessage = "Your Individual Membership has qualified this<br /> order for a $5.00 discount on 1 ticket."
        Case Else
             DiscountMessage = "Your Individual Membership has qualified this<br /> order for a $5.00 discount on " & IndividualTicketCount & " tickets"
        End Select
        
        Call WarningPage(DiscountMessage)
        
        Exit Sub
    Else
        Select Case GroupTicketCount
        Case 1
             DiscountMessage = "Your " & GroupMembership & " has qualified this<br /> order for a " & FormatPercent(GroupDiscount,0) & " discount on 1 ticket."
        Case Else
             DiscountMessage = "Your " & GroupMembership & " has qualified this<br /> order for a " & FormatPercent(GroupDiscount,0) & " discount on " & GroupTicketCount & " tickets."
        End Select
        
        Call WarningPage(DiscountMessage)
        
        Exit Sub
    End If

End If


Call Continue


End Sub 'ApplyDiscount

'============================================================

Sub WarningPage(DiscountMessage)
 
 
%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<style type="text/css">
body
{
    font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
    line-height: 1 em;
}
#rounded-corner
{
	font-size: 12px;
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
	background: <%=TableCategoryBGColor%> url('<%=NECorner%>') left -1px no-repeat;
	text-align: right;
}
#rounded-corner thead th.category-right
{
	background: <%=TableCategoryBGColor%> url('<%=NWCorner%>') right -1px no-repeat;
    text-align: left;
}
#rounded-corner td.footer
{
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.footer-left
{
    background: <%=TableDataBGColor%> url('<%=SWCorner%>') left bottom no-repeat;
}
#rounded-corner td.footer-right
{
	background: <%=TableDataBGColor%> url('<%=SECorner%>') right bottom no-repeat;
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
        <td class="data" colspan="4" align="center"><%= DiscountMessage %></td>
    </tr>
        <td class="footer-left">&nbsp;</td>
        <td class="footer" colspan="2">&nbsp;</td>
        <td class="footer-right">&nbsp;</td>
    </tr>
    <tr align="center">
        <td>&nbsp;</td>
        <td colspan="2"><br /><INPUT TYPE="submit" VALUE="Continue"></form></td>
        <td>&nbsp;</td>
    </tr>
</table>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>
</html>

<%

End Sub 'Warning Page

'==========================================================

Sub Continue
				
Session("SurveyComplete") = Session("OrderNumber")

If Session("UserNumber") = "" Then
	Response.Redirect("/Ship.asp")
Else
	Response.Redirect("/Management/AdvanceShip.asp")
End If		

End Sub 'Continue

'==========================================================

%>

