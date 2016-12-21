<%

'CHANGE LOG - Inception
'SSR (8/30/2011)
'Custom Survey

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'============================================================

Page = "Survey"
SurveyNumber = 1113
SurveyName = "SectionSurvey.asp"

'============================================================

'Central California Society of India (9/22/11)

'Require that no less than 4 tickets be purchased in the following
'Sectioncodes: PLAT, DMND,GOLD, SLVR
'The requirement should be for online purchases only

'============================================================

SurveyTitle = "Sorry"
SurveyHeader = "There is a four-ticket minimum purchase in this section.<br>Please go Back to Shopping to add the additional tickets to your order."

'============================================================

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

'Request the form name and process requested action

Select Case Clean(Request("FormName"))
    Case "Continue"
        Call Continue
    Case Else
        Call SurveyForm
 End Select
 

'==========================================================
	
Sub SurveyForm
		
ActCodeList="PLAT,DMND,GOLD,SLVR"			
ProductionList = Split(ActCodeList,",")		

For ActCd = lbound(ProductionList) to ubound(ProductionList)
		
SQLFreeTickets = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE (OrderHeader.CustomerNumber = " & Session("CustomerNumber") & " OR OrderHeader.OrderNumber = " & Session("OrderNumber") & ") AND Seat.SectionCode = '" &  ProductionList(ActCd) & "' AND Seat.EventCode = " & CleanNumeric(403580)& ""
Set rsFreeTickets = OBJdbConnection.Execute(SQLFreeTickets)
SeasonTicketCount = rsFreeTickets("TicketCount")

    If SeasonTicketCount  < 4 Then
        Call WarningPage
        Exit Sub
    Else
        Call Continue
        Exit Sub
    End If

rsFreeTickets.Close
Set rsFreeTickets = nothing	

Next	
		

End Sub

'==========================================================

Sub WarningPage

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
	width: 400px;
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
	padding-left: 10px;
	padding-right: 10px;
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

<table id="rounded-corner" summary="surveypage" border="1">
<thead>
    <tr>
	    <th scope="col" class="category-left"></th>
	    <th scope="col" class="category" colspan="2"><%=SurveyTitle%></th>
	    <th scope="col" class="category-right"></th>
    </tr>        
</thead>
<tbody>
    <tr>
        <td class="data-right">&nbsp;</td>
        <td class="data-left" colspan="2">There is a four-ticket minimum purchase in this area.<br />Please go Back to Shopping to add the additional tickets to your order.</td>
        <td class="data-right">&nbsp;</td>
    </tr>
    <tr>
	    <td class="footer-left">&nbsp;</td>
	    <td class="footer" colspan="2">&nbsp;</td>
	    <td class="footer-right">&nbsp;</td>
	</tr>
	<tr>
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

End Sub ' SurveyForm


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