<%

'CHANGE LOG

'SSR - 12/13/2012 - Custom Survey Created

'SSR - 12/14/2012 - Update to Survey

'SSR - 1/23/2013 - Update to Survey

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'------------------------------------------------------------

Page = "Survey"
SurveyNumber = 1391
SurveyName = "RowRestrict.asp"
BoxOfficeByPass = True
CompOrderByPass = True

'Options
'BoxOfficeByPass = False will display for box office, fax, phone order types (default)
'CompOrderByPass = True  will bypass for comp order type (default)

'============================================================'

'American University Greenberg (1/23/2013)
'Update to survey:  bypass the survey restriction for box office orders.


'American University Greenberg (12/14/2012)

'Update to survey:
'Restriction Begin: Activated when programming is complete 
'Restriction End: March 15, 2013 

'American University Greenberg (12/13/2012)

'Custom Presale Code Programming 
'(Survey to restrict seat sales unless discount code has been entered)

'We have the parameters for our special sale needs. 
'However, it isn’t truly what I would call a presale.
'We want the other seating for the event to be on sale along with the special seating section. 
'The event is set up, but not activated. 

'Production Name:	Cabaret (85415)
'Event:				514772 
'Date:				Thursday, April 4, 2013 

'Seat Locations: 
'Row D 1-21 (all) 
'Row E 1-23 (all) 
'Row F 1-23 (all) 
'Row G 1-24 (all) 

'code SYLVIA2013. 

'============================================================'

SpecialDiscountType = "75795"

ExpDate = "3/15/2013"

'------------------------------------------------------------

'CSS Survey Variables

If Session("UserNumber")<> "" Then
    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "#FFFFFF"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "#000000"
    TableDataBGColor = "#E9E9E9"
End If

'LastHex = box color
'FirstHex = background color

If Session("UserNumber")<> "" Then
    NECorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=008400&Src=TopLeftCorner16.txt"
    NWCorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=008400&Src=TopRightCorner16.txt"
    SWCorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=E9E9E9&Src=BottomLeftCorner16.txt"
    SECorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=E9E9E9&Src=BottomRightCorner16.txt"
Else
    NECorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=012652&Src=TopLeftCorner16.txt"
    NWCorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=012652&Src=TopRightCorner16.txt"
    SWCorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=f1f1f1&Src=BottomLeftCorner16.txt"
    SECorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=f1f1f1&Src=BottomRightCorner16.txt"
End If
 
 
'------------------------------------------------------------ 
 
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


'------------------------------------------------------------

'Check for Survey bypass options

Select Case Session("OrderTypeNumber") 
    Case 1 'Internet Orders
	    Call CheckCurrentOrder
    Case 5 'Comp Orders
        If CompOrderByPass Then
	        Call Continue
        End If
    Case Else 'Remaining Order Types
        If BoxOfficeByPass Then
	        Call Continue
        End If
End Select

'------------------------------------------------------------

'Request the form name and process requested action

Select Case Clean(Request("FormName"))
    Case "WarningPage"
        Call WarningPage
    Case "Continue"
        Call Continue
    Case Else
        Call CheckCurrentOrder
 End Select
 
'------------------------------------------------------------

Sub CheckCurrentOrder

If Now() < CDate(ExpDate) Then

	'Check if there are any restricted seats on the current order
	SQLSeatCheck = "SELECT Count(Seat.ItemNumber) as Count FROM Seat (NOLOCK) WHERE Seat.OrderNumber = " & CleanNumeric(Session("OrderNumber"))& " AND Seat.Row IN ('D','E','F','G')"
	Set rsSeatCheck = OBJdbConnection.Execute(SQLSeatCheck)

		If rsSeatCheck("Count") >= 1 Then 
		
			'Check if the order has the required discount code for those restricted seats
			SQLApplied = "SELECT COUNT(OrderLine.LineNumber) AS Count FROM OrderLine (NOLOCK) WHERE OrderLine.OrderNumber = " & CleanNumeric(Session("OrderNumber")) & " AND OrderLine.DiscountTypeNumber  =  " & SpecialDiscountType & " "
			Set rsApplied = OBJdbConnection.Execute(SQLApplied)
					
			   If rsApplied("Count") = 0 Then
					Call WarningPage
				Else
					Call Continue
					Exit Sub
				End If
				
			rsApplied.Close
			Set rsApplied  = nothing	
			
		Else
			Call Continue
			Exit Sub
		End If
			
	rsSeatCheck.Close
	Set rsSeatCheck = nothing	
	
Else

	Call Continue
	Exit Sub

End If


End Sub 'CheckCurrentOrder

'------------------------------------------------------------

Sub WarningPage

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>

<head>

<title>TIX.com</title>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

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
width: 50%;
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
text-align: center;
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

#smalltable thead th
{
background: #ffffff;
}
</style>

</head>

<% If Message = "" Then %>
    <%=strBody%>
<% Else %>
	<body onLoad="alert('<%= Message %>');">
<% End If %>


<table id="rounded-corner" summary="surveypage" border="0">
	<thead>
		<tr>
			<th scope="col" class="category-left"></th>
			<th scope="col" class="category" colspan="2">Sorry</th>
			<th scope="col" class="category-right"></th>
		</tr>        
	</thead>
	<tbody>
	   <tr>
			<td class="data-right">&nbsp;</td>
			<td class="data" colspan="2">
			<center>
				A promotional code is required in order to purchase the following seats:<br>
				
				<br>
				<table id="smalltable" border="1" cellpadding="5" cellspacing="0">
				<tr> <th align="center">Row</th><th align="center">Seats</th> <tr>
				<tr> <td align="center">D</td><td align="center">1-21</td> </tr>
				<tr> <td align="center">E</td><td align="center">1-21</td> </tr>
				<tr> <td align="center">F</td><td align="center">1-21</td> </tr>
				<tr> <td align="center">G</td><td align="center">1-21</td> </tr>
				</table>
				<br>
				
			</center>
			</td>
			<td class="data-right">&nbsp;</td>
		</tr>
		<tr>
			<td >&nbsp;</td>
			<td colspan="2">
			<br>
			<center>
			<%
			If Session("UserNumber") = "" Then
				Response.Write "<FORM ACTION=""/ShoppingCart.asp"" METHOD=""POST"" id=form1 name=form1>" & vbCrLf
			Else
				Response.Write "<FORM ACTION=""/Management/ShoppingCart.asp"" METHOD=""POST"" id=form1 name=form1>" & vbCrLf
			End If

			Response.Write "<INPUT TYPE=""submit"" VALUE=""Return to Shopping Cart"" id=""form1"" name=""form1""></FORM>" & vbCrLf
			%>
			</center>
			</td>
			<td >&nbsp;</td>
		</tr>
	</tbody>
</table>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>

</html>

<%


End Sub 

'------------------------------------------------------------

Sub Continue

Session("SurveyComplete") = Session("OrderNumber")

If Session("UserNumber") = "" Then
	Response.Redirect("/Ship.asp")
Else
	Response.Redirect("/Management/AdvanceShip.asp")
End If

End Sub 'Continue

'------------------------------------------------------------


%>