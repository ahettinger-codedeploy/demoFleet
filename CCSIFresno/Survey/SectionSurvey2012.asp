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
SurveyNumber = 1336
SurveyFileName = "SectionSurvey2012.asp"

'Options
'BoxOfficeByPass - False will display for ordertype box office 
'CompOrderByPass - False will display for ordertype comp 

'===============================================

'Central California Society of India 

'Require that no less than 2 tickets be purchased in the following
'Sections: PLAT, DMND,GOLD, SLVR
'The requirement should be for online purchases only
'Warning page should read:  "There is a two-ticket minimum purchase in this section.  Please go Back to Shopping to add the additional tickets to your order."

'Discount
'----------
'Each ticket purchased over 2 in each section should be priced as follows:

'Section	Full Price	New Price	Discount
'-------	---------	--------	----------
'PLAT   	$68.75		$45.00 		($23.75)	
'DMND   	$62.50		$40.00 		($22.50)
'GOLD  		$56.25		$40.00 		($16.25)
'SLVR  		$48.75		$40.00 		($8.75)

'Do not recalc the service fees

'Discount valid online and offline

'===============================================

DiscountTypeNumber = 74062

DIM SectionList(4)
SectionList(1) = "PLAT"
SectionList(2) = "DMND"
SectionList(3) = "GOLD"
SectionList(4) = "SLVR"

DIM SectionName(4)
SectionName(1) = "Platinum Seating"
SectionName(2) = "Diamond Seating"
SectionName(3) = "Gold Seating"
SectionName(4) = "Silver Seating"

DIM SectionCount(4)
SectionCount(1) = 0
SectionCount(2) = 0
SectionCount(3) = 0
SectionCount(4) = 0

RequiredCount = 2

PLATPrice = 45	
DMNDPrice = 40
GOLDPrice = 40
SLVRPrice =	40

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

'Request the form name and process requested action

Select Case Clean(Request("FormName"))
    Case "Continue"
        Call Continue
    Case Else
        Call SurveyForm
 End Select
 
'--------------------------------------------------------------

Sub SurveyForm

'Check the order to see if it has restricted tickets.  If it does not have any, go to continue and end survey

'ErrorLog("1. SurveyForm")

SQLTicketCount = "SELECT COUNT(OrderLine.ItemNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber")	& " AND Seat.SectionCode IN ('PLAT','DMND','GOLD','SLVR') AND OrderLine.ItemType IN ('SubFixedEvent', 'SubSeat', 'Seat')"
Set rsTicketCount = OBJdbConnection.Execute(SQLTicketCount)
TicketCount = rsTicketCount("TicketCount")
rsTicketCount.Close
Set rsTicketCount = nothing

'ErrorLog("2. TicketCount " & TicketCount & "")


If TicketCount > 0 Then 
	Call ProcessSection
Else
	Call Continue
End If

End Sub

'--------------------------------------------------------------

Sub ProcessSection

Warn = False

For i = 1 to UBound(SectionList)

	SQLOrderSeats = "SELECT COUNT(OrderLine.ItemNumber) AS Count FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber")	& " AND OrderLine.ItemType IN ('SubFixedEvent', 'SubSeat', 'Seat') AND Left(Seat.SectionCode,4) = '" & SectionList(i)  &"' GROUP BY Seat.EventCode, Seat.SectionCode, Section.Section"
	Set rsOrderSeats = OBJdbConnection.Execute(SQLOrderSeats)
	
	If Not rsOrderSeats.EOF Then
				
		If rsOrderSeats("Count") < 2 Then 
					
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

Call Continue

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

For i = 1 to ubound(SectionCount)
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

<!--#INCLUDE VIRTUAL="TopNavInclude.asp"-->

<title>TIX.com</title>

<style>
#newspaper-b
{
	font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
	font-size: 12px;
	margin: 45px;
	width: 480px;
	text-align: left;
	border-collapse: collapse;
	border: 1px solid #69c;
}
#newspaper-b th
{
	padding: 15px 10px 10px 10px;
	font-weight: normal;
	font-size: 20px;
	color: #039;
}
#newspaper-b tbody
{
	background: #e8edff;
}
#newspaper-b td
{
	padding: 10px;
	color: #669;
	border-top: 1px dashed #fff;
}
#newspaper-b tbody 
{
	color: #339;
	background: #d0dafd;
}
</style>

</head>

<body>

<table id="newspaper-b">
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
					
					For i = 1 to ubound(SectionCount)
					
						If SectionCount(i) > 0 AND SectionCount(i) < RequiredCount Then
						
							If SectionCount(i) = 1 Then
							 tickets = "ticket"
							Else
							  tickets = "tickets"
							End If
													
							Response.Write "<h4> " & SectionName(i) & " - Your Order: " & SectionCount(i) & "&nbsp;" & tickets & " </h4>" & vbCrLf
							
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

				Response.Write "<INPUT TYPE=""submit"" VALUE=""Return to Shopping Cart"" id=""form1"" name=""form1"" class=""button gray-bg""></FORM>" & vbCrLf
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



