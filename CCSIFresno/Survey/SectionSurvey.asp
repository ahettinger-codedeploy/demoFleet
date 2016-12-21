<%

'CHANGE LOG - Inception
'SSR 6/7/2011
'Custom Survey

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'===============================================

Page = "Survey"
SurveyNumber = 1113
SurveyFileName = "SectionSurvey.asp"
BoxOfficeByPass = True

'===============================================

'Central California Society of India (9/23/2011)

'Require that no less than 4 tickets be purchased in the following
'sectioncodes: PLAT, DMND,GOLD, SLVR
'The requirement should be for online purchases only
'Warning page should read:  "There is a four-ticket minimum purchase in this section.  Please go Back to Shopping to add the additional tickets to your order."


'Discount
'========
'When more than 4 tickets are purchased in each of the following sectioncodes a discount should be given to those additional tickets:

'PLAT - Ticket Qty =>5, New Price = $45
'DMND - Ticket Qty =>5, New Price = $40
'GOLD - Ticket Qty =>5, New Price = $40
'SLVR - Ticket Qty =>5, New Price = $40

'Do not recalc the service fees

'Discount valid online and offline

'Let me know if you have any questions.

RequiredCount = 5

DIM TicketType(6)
TicketType(1) = "6017"
TicketType(2) = "6018"
TicketType(3) = "6019"
TicketType(4) = "6020"
TicketType(5) = "6023"

DIM MinCount(6)
MinCount(1) = "4"
MinCount(2) = "5"
MinCount(3) = "4"
MinCount(4) = "4"
MinCount(5) = "4"

DIM AreaName(6)
AreaName(1) = "Platinum Seating"
AreaName(2) = "Diamond Seating"
AreaName(3) = "Gold Seating"
AreaName(4) = "Silver Seating"
AreaName(5) = "Dinner Only"




'===============================================
'CSS Survey Variables

If Session("UserNumber")<> "" Then
    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "FFFFFF"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "000000"
    TableDataBGColor = "E9E9E9"
End If

'LastHex = box color
'FirstHex = background color

If Session("UserNumber")<> "" Then

    NECorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=008400&Src=TopLeftCorner16.txt"
    NWCorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=008400&Src=TopRightCorner16.txt"
    SWCorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=E9E9E9&Src=BottomLeftCorner16.txt"
    SECorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=E9E9E9&Src=BottomRightCorner16.txt"
Else
    NECorner="/clients/tix/images/image.asp?FirstHex=efebe3&LastHex=565f68&Src=TopLeftCorner16.txt"
    NWCorner="/clients/tix/images/image.asp?FirstHex=efebe3&LastHex=565f68&Src=TopRightCorner16.txt"
    SWCorner="/clients/tix/images/image.asp?FirstHex=f3f1ed&LastHex=ded6c8&Src=BottomLeftCorner16.txt"
    SECorner="/clients/tix/images/image.asp?FirstHex=f3f1ed&LastHex=ded6c8&Src=BottomRightCorner16.txt"
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

'Bypass this survey for Box Office Orders

If Session("OrderTypeNumber") <> 1 Then
    If BoxOfficeByPass Then
	    Call Continue
    End If
End If

'============================================================

'Request the form name and process requested action

Select Case Clean(Request("FormName"))
    Case "Continue"
        Call Continue
    Case Else
        Call TicketValidation1
 End Select
 

'==========================================================

Sub TicketValidation1

QuantityToBuy = 4

SQLTicketCount = "SELECT COUNT(ItemNumber) AS TicketCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber")& " AND OrderLine.SeatTypeCode = 6017"
Set rsTicketCount = OBJdbConnection.Execute(SQLTicketCount)
TicketCount = rsTicketCount("TicketCount")
rsTicketCount.Close
Set rsTicketCount = nothing

If TicketCount > 0 AND  TicketCount < QuantityToBuy Then 
    ThisAreaName = "Platinum Seating"
    Call WarningPage(QuantityToBuy,ThisAreaName)
    Exit Sub	
End If

Call TicketValidation2

End Sub 'TicketValidation1

'===============================================

Sub TicketValidation2

QuantityToBuy = 4

SQLTicketCount = "SELECT COUNT(ItemNumber) AS TicketCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber")& " AND OrderLine.SeatTypeCode = 6018"
Set rsTicketCount = OBJdbConnection.Execute(SQLTicketCount)
TicketCount = rsTicketCount("TicketCount")
rsTicketCount.Close
Set rsTicketCount = nothing

If TicketCount > 0 AND  TicketCount < QuantityToBuy Then 
    ThisAreaName = "Diamond Seating"
    Call WarningPage(QuantityToBuy,ThisAreaName)
    Exit Sub	
End If

Call TicketValidation3

End Sub 'TicketValidation2

'===============================================
'===============================================

Sub TicketValidation3

QuantityToBuy = 4

SQLTicketCount = "SELECT COUNT(ItemNumber) AS TicketCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber")& " AND OrderLine.SeatTypeCode = 6019"
Set rsTicketCount = OBJdbConnection.Execute(SQLTicketCount)
TicketCount = rsTicketCount("TicketCount")
rsTicketCount.Close
Set rsTicketCount = nothing

If TicketCount > 0 AND  TicketCount < QuantityToBuy Then 
    ThisAreaName = "Gold Seating"
    Call WarningPage(QuantityToBuy,ThisAreaName)
    Exit Sub	
End If

Call TicketValidation4

End Sub 'TicketValidation3

'===============================================
'===============================================

Sub TicketValidation4

QuantityToBuy = 4

SQLTicketCount = "SELECT COUNT(ItemNumber) AS TicketCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber")& " AND OrderLine.SeatTypeCode = 6020"
Set rsTicketCount = OBJdbConnection.Execute(SQLTicketCount)
TicketCount = rsTicketCount("TicketCount")
rsTicketCount.Close
Set rsTicketCount = nothing

If TicketCount > 0 AND  TicketCount < QuantityToBuy Then 
    ThisAreaName = "Silver Seating"
    Call WarningPage(QuantityToBuy,ThisAreaName)
    Exit Sub	
End If

Call TicketValidation5

End Sub 'TicketValidation4

'===============================================
'===============================================

Sub TicketValidation5

QuantityToBuy = 2

SQLTicketCount = "SELECT COUNT(ItemNumber) AS TicketCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber")& " AND OrderLine.SeatTypeCode = 6023"
Set rsTicketCount = OBJdbConnection.Execute(SQLTicketCount)
TicketCount = rsTicketCount("TicketCount")
rsTicketCount.Close
Set rsTicketCount = nothing

If TicketCount > 0 AND  TicketCount < QuantityToBuy Then 
    ThisAreaName = "Dinner Only"
    Call WarningPage(QuantityToBuy,ThisAreaName)
    Exit Sub	
End If

Call Continue

End Sub 'TicketValidation5

'===============================================
'===============================================

Sub WarningPage(QuantityToBuy,ThisAreaName)		


If DocType <> "" Then
	Response.Write DocType
Else
	Response.Write "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
End If

%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<html>
<head>

<title>TIX.com</title>

<style type="text/css">
    
body
{
    font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
    line-height: 1 em;
}
#rounded-corner
{
	font-size: 11px;
    font-weight: 400;
	text-align: left;
	border-collapse: collapse;
	width: 70%;
	top: 10px;
	line-height: 22px;
	margin-top:  10px;
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
	padding-left: 10px;
	padding-right: 10px;
	padding-top: 10px;
	padding-bottom: 10px;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-left
{
	padding-left: 20px;
	padding-right: 20px;
	padding-top: 10px;
	padding-bottom: 10px;
	text-align: left;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-right
{
	padding-left: 10px;
	padding-right: 10px;
	padding-top: 10px;
	padding-bottom: 10px;
    text-align: right;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
</style>
</head>

<body>

<!--#INCLUDE virtual="TopNavInclude.asp"-->



<table id="rounded-corner" summary="surveypage">
<thead>
    <tr>
	    <th scope="col" class="category-left"></th>
	    <th scope="col" class="category" colspan="2">SORRY</th>
	    <th scope="col" class="category-right"></th>
    </tr>        
</thead>
<tbody>
    <tr>
        <td class="data-right">&nbsp;</td>
        <td class="data-left" colspan="2">There is a <%=QuantityToBuy%> ticket minimum purchase in the <%=ThisAreaName%> section.<br />Please click the Back to Shopping button below to add additional tickets to your order.</td>
        <td class="data-right">&nbsp;</td>
    </tr>
    <tr>
	    <td class="footer-left">&nbsp;</td>
	    <td class="footer" colspan="2">&nbsp;</td>
	    <td class="footer-right">&nbsp;</td>
	</tr>
	    <td >&nbsp;</td>
	    <td align="center" colspan="2">
        <%
        If Session("UserNumber") = "" Then
        %>
        <FORM ACTION="/ShoppingCart.asp" METHOD="POST" id=form1 name=form1>
        <%
        Else
        %>
        <FORM ACTION="/Management/ShoppingCart.asp" METHOD="POST" id=form1 name=form1>
        <%
        End If
        %>
        <br />
        <br />
        <INPUT TYPE="submit" VALUE="Back To Shopping" id=Submit2 name=1></FORM>
        </td>
	    <td >&nbsp;</td>
	</tr>
    </tbody>
</table>


<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>
</htmlL>

<%

	
End Sub 'Warning Page

'========================================

Sub Continue

Session("SurveyComplete") = Session("OrderNumber")

If Session("UserNumber") = "" Then
	Response.Redirect("/Ship.asp")
Else
	Response.Redirect("/Management/AdvanceShip.asp")
End If

End Sub 'Continue

'=================================
%>



