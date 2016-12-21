<%

'CHANGE LOG - Inception
'SSR 6/7/2011
'Custom Survey

%>

<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="CalcCustomerFeeInclude.asp"-->
<!--#INCLUDE VIRTUAL="/Discounts/DiscountScriptInclude.asp"-->

<%

'-------------------------------------------------

Page = "Survey"
SurveyNumber = 1363
SurveyFileName = "SectionSurveyMEGADiwali.asp"
BoxOfficeByPass = False
CompOrderByPass = True

'Options
'BoxOfficeByPass = False will display for box office, fax, phone order types (default)
'CompOrderByPass = True  will bypass for comp order type (default)

'===============================================

'Central California Society of India 

'Require that min 2 tickets be purchased - per price tier

'The requirement is for online purchases only
'Warning page should read:  "There is a two-ticket minimum purchase in this section.  Please go Back to Shopping to add the additional tickets to your order."

'Discount
'----------
'Client states that pricing is the same as the other event for which this was previously used (EventCode 506904), and only change is to pricing for individual add-on tickets:
'	Platinum   	$35
'	Diamond  	$30
'	Gold        $25
'	Silver      $20
'	General   	$15

'Do not recalc the service fees

'Discount valid online and offline

'===============================================

DiscountTypeNumber = 74062

'List of sections to check for the min seat requirements

DIM SectionList(4)
SectionList(1) = "1BLUE" 	'Platinum Seating
SectionList(2) = "1GREEN" 	'Diamond Seating
SectionList(3) = "2GOLD" 	'Gold Seating
SectionList(4) = "2SILVER" 	'Silver Seating


'People friendly list of same sections

DIM SectionName(4)
SectionName(1) = "Platinum Seating"
SectionName(2) = "Diamond Seating"
SectionName(3) = "Gold Seating"
SectionName(4) = "Silver Seating"


'Valid ticket type for each section

DIM SectionTicket(4)
SectionTicket(1) = "6017"
SectionTicket(2) = "6018"
SectionTicket(3) = "6019"
SectionTicket(4) = "6020"

'New discounted ticket price for each section

DIM SectionPrice(4)
SectionPrice(1) = 45 'Platinum Seating
SectionPrice(2) = 40 'Diamond Seating
SectionPrice(3) = 40 'Gold Seating
SectionPrice(4) = 40 'Silver Seating


'Total of seats for each section

DIM SectionCount(4)
SectionCount(1) = 0
SectionCount(2) = 0
SectionCount(3) = 0
SectionCount(4) = 0


RequiredCount = 2

WarningTitle = "SORRY"

WarningMessage = "<p>You must have at least " & RequiredCount & " tickets in this section.<p><p>Please click on the Back to Shopping button to add the additional tickets to your order.</p>"


'--------------------------------------------------------------

 
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


'--------------------------------------------------------------

Select Case Session("OrderTypeNumber") 
    Case 5 'Comp Orders
        If CompOrderByPass Then
	        Call Continue
        End If
    Case 7 
        If BoxOfficeByPass Then
	        Call Continue
        End If
End Select

'--------------------------------------------------------------

'Request the form name and process requested action

Select Case Clean(Request("FormName"))
    Case "Continue"
        Call Continue
    Case Else
        Call SurveyForm
 End Select
 
'--------------------------------------------------------------

Sub SurveyForm

Warn = False

For i = 1 to UBound(SectionList)

	SQLOrderSeats = "SELECT COUNT(OrderLine.ItemNumber) AS Count FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber")	& " AND OrderLine.SeatTypeCode = " & SectionTicket(i) & " AND OrderLine.ItemType IN ('SubFixedEvent', 'SubSeat', 'Seat') AND Section.Color = '" & SectionList(i)  &"' GROUP BY Seat.EventCode, Seat.SectionCode, OrderLine.SeatTypeCode"
	Set rsOrderSeats = OBJdbConnection.Execute(SQLOrderSeats)
	
	If Not rsOrderSeats.EOF Then
				
		If rsOrderSeats("Count") < RequiredCount Then 
					
			SectionCount(i) = SectionCount(i) + rsOrderSeats("Count")
			
			'ErrorLog("4. " & SectionList(i) & " " & SectionCount(i) & "")
			
			Warn = True
		
		End If
		
	End If
		
	rsOrderSeats.Close
	Set rsOrderSeats = nothing

Next 

If Warn Then
	
Call WarningPage	

Else

Call ApplyDiscount

End If


End Sub

'-------------------------------------------------

Sub WarningPage

'Discplay warning page if any restricted section has less than the required number of seats.

If Session("UserNumber")<> "" Then
    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "FFFFFF"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "000000"
    TableDataBGColor = "E9E9E9"
End If

For i = lbound(SectionCount) to ubound(SectionCount)
	If SectionCount(i) > 0 AND SectionCount(i) < RequiredCount Then
		Count = Count + SectionCount(i)
	End If
Next

If Count = 1 Then 
	sections = "section"
	does = "does"
Else
	sections = "sections"
	does = "do"
End If

%>

<!DOCTYPE html>

<html>

<head>

<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">

<title>TIX Support</title>

<!--#INCLUDE VIRTUAL="TopNavInclude.asp"-->


<!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
<!--[if lt IE 9]>
<script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
<![endif]-->

<style>
#newspaper-b
{
	font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
	font-size: 12px;
	margin: 45px;
	width: 480px;
	text-align: left;
	border-collapse: collapse;
	border: 1px solid #003399;
}
#newspaper-b th
{
	padding: 15px 10px 10px 10px;
	font-weight: normal;
	font-size: 20px;
	color: #071c61;
}
#newspaper-b tbody
{
	background: #e8edff;
}
#newspaper-b td
{
	padding: 10px;
	color: #1040e1;
	border-top: 1px dashed #fff;
	font-size: 12px;
}
#newspaper-b tbody 
{
	color: #339;
	background: #f1f4fe
}
#newspaper-b .errorcount
{
font-size: 12pt;
}
</style>

</head>

<body>

<table id="newspaper-b" border="1">
<thead>
    <tr>
	    <th><%=WarningTitle%></th>
    </tr>        
</thead>
<tbody>
    <tr>
        <td >
		<%
					Response.Write "<p>There is a two-ticket minimum purchase in the sections listed below</p>" & vbCrLf
					
					For i = lbound(SectionCount) to ubound(SectionCount)
					
						If SectionCount(i) > 0 AND SectionCount(i) < RequiredCount Then
						
							If SectionCount(i) = 1 Then
							 tickets = "ticket"
							Else
							  tickets = "tickets"
							End If
													
							Response.Write "<p class=""errorcount""> " & SectionName(i) & " - Your Order: " & SectionCount(i) & "&nbsp;" & tickets & " </p>" & vbCrLf
							
						End If
						
					Next
		
				Response.Write "<p>Please go click the button below<Br>to add the additional tickets to your order.</P>" & vbCrLf
%>
		</td>
    </tr>
	<tfoot>
	<tr>
	    <td align="center">
		
				<%
				If Session("UserNumber") = "" Then
					Response.Write "<FORM ACTION=""/ShoppingCart.asp"" METHOD=""POST"" id=form1 name=form1>" & vbCrLf
				Else
					Response.Write "<FORM ACTION=""/Management/ShoppingCart.asp"" METHOD=""POST"" id=form1 name=form1>" & vbCrLf
				End If

				Response.Write "<INPUT TYPE=""submit"" VALUE=""Return to Shopping Cart"" id=""form1"" name=""form1"" ></FORM>" & vbCrLf
				%>
        </td>
	</tr>
	</tfoot>
	</tr>
</tbody>
</table>

</body>
<!--#INCLUDE virtual="FooterInclude.asp"-->

</html>



<%


End Sub 


'========================================

Sub ApplyDiscount

'ErrorLog ("Line 350")

'Clear out any other discounts on the order
'-----------------------------------------
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


'Cycle through each production in the season
'Give discount to applicable tickets
'---------------------------------------------

For i = 1 to UBound(SectionList)

	SQLOrderSeats = "SELECT Seat.SectionCode, OrderLine.Price, COUNT(OrderLine.ItemNumber) AS OrderSeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber")	& " AND Section.Color = '" & SectionList(i)  &"' AND OrderLine.SeatTypeCode = " & SectionTicket(i) & " AND OrderLine.ItemType IN ('SubFixedEvent', 'SubSeat', 'Seat') GROUP BY Seat.EventCode, Seat.SectionCode, OrderLine.Price"
	Set rsOrderSeats = OBJdbConnection.Execute(SQLOrderSeats)
		
	If Not rsOrderSeats.EOF Then

		SectionCount(i) = rsOrderSeats("OrderSeatCount")
							
		If SectionCount(i) > 2 Then

			NewPrice = SectionPrice(i)

			DiscountAmount = rsOrderSeats("Price") - NewPrice
			
			SQLLineNo = "SELECT TOP((" & SectionCount(i) & ") - (" & RequiredCount & ")) LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN SECTION (NOLOCK) ON Seat.EventCode = Section.EventCode INNER JOIN EVENT (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.SeatTypeCode = " & SectionTicket(i) & " AND Section.Color = '" & SectionList(i)  &"'  ORDER BY LineNumber DESC"
			Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)
		
				If Not rsLineNo.EOF Then                
					Do While Not rsLineNo.EOF
						SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount =  " & DiscountAmount & ", Surcharge = 0, DiscountTypeNumber = " & DiscountTypeNumber & " WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber")
						Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
						rsLineNo.movenext
					Loop
				End If
		
			rsLineNo.Close
			Set rsLineNo = Nothing
								
		End If
				
	End If
													 
	rsOrderSeats.Close
	Set rsOrderSeats = nothing  
        
Next

Call Continue

End Sub 'ApplyDiscount

'-----------------------------------

Sub Continue

Session("SurveyComplete") = Session("OrderNumber")

If Session("UserNumber") = "" Then
	Response.Redirect("/Ship.asp")
Else
	Response.Redirect("/Management/AdvanceShip.asp")
End If

End Sub 'Continue

'-----------------------------------

%>






