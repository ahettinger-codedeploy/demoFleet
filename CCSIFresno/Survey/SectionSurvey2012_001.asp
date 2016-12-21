<%

'CHANGE LOG - Inception
'SSR 6/7/2011
'Custom Survey

%>

<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->

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

DIM SectionList
SectionList = "PLAT,DMND,GOLD,SLVR"

DIM SectionSeatCount

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

ErrorLog("1. SurveyForm")

SQLTicketCount = "SELECT COUNT(OrderLine.ItemNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber")	& " AND Seat.SectionCode IN ('PLAT','DMND','GOLD','SLVR') AND OrderLine.ItemType IN ('SubFixedEvent', 'SubSeat', 'Seat')"
Set rsTicketCount = OBJdbConnection.Execute(SQLTicketCount)
TicketCount = rsTicketCount("TicketCount")
rsTicketCount.Close
Set rsTicketCount = nothing

ErrorLog("2. TicketCount " & TicketCount & "")


If TicketCount > 0 Then 
	Call ProcessSection
Else
	Call Continue
End If

End Sub

'--------------------------------------------------------------

Sub ProcessSection

SQLOrderSeats = "SELECT Seat.EventCode, Seat.SectionCode, COUNT(OrderLine.ItemNumber) AS OrderSeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber")	& " AND Left(Seat.SectionCode,4) = 'PLAT' AND OrderLine.ItemType IN ('SubFixedEvent', 'SubSeat', 'Seat') GROUP BY Seat.EventCode, Seat.SectionCode"
Set rsOrderSeats = OBJdbConnection.Execute(SQLOrderSeats)

If Not rsOrderSeats.EOF Then

    Do Until rsOrderSeats.EOF

	    SQLSectionSeats = "SELECT COUNT(ItemNumber) AS SectionSeatCount FROM Seat (NOLOCK) WHERE EventCode = " & rsOrderSeats("EventCode") & " AND SectionCode = '" & rsOrderSeats("SectionCode") & "'"
	    Set rsSectionSeats = OBJdbConnection.Execute(SQLSectionSeats)
    	
	    OrderSeatCount = rsOrderSeats("OrderSeatCount")
		
		ErrorLog("OrderSeatCount " & OrderSeatCount & "")

	    If OrderSeatCount < RequiredCount Then 'Not all seats were selected.  Go to warning page
    	
		    rsSectionSeats.Close
		    Set rsSectionSeats = nothing
    		
		    Call WarningPage
    		
		    Exit Sub
    					
	    End If
    				
	    rsSectionSeats.Close
	    Set rsSectionSeats = nothing
    	
    rsOrderSeats.MoveNext
    Loop

End If
		
rsOrderSeats.Close
Set rsOrderSeats = nothing

Call Continue

End Sub 'TableCheck


'-------------------------------------------------

Sub WarningPage

'Discplay warning page if any restricted section has less than the required number of seats.

If ActCount = 1 Then 
	s = ""
Else
	s = "s"
End If

%>

<!DOCTYPE html>

<html>

<head>

<!--#INCLUDE VIRTUAL="TopNavInclude.asp"-->

<title>TIX.com</title>

<style type="text/css"> 

body, button, input, textarea { font-family: Arial,Helvetica,sans-serif; font-size: 13px; line-height: 16px; color: rgb(102, 102, 102); }
p, ul, ol, dl { margin-bottom: 16px; }
p:last-child, ul:last-child, ol:last-child, dl:last-child, fieldset:last-child, .fieldset:last-child { margin-bottom: 0pt; }
a { text-decoration: none; }
a:hover { color: rgb(0, 153, 255); }
h3 { font-size: 21px; line-height: 25px; margin: 30px 0pt 20px; }
h4 { font-size: 16px; line-height: 19px; margin: 25px 0pt 15px; }
h2:first-child, h3:first-child, h4:first-child, h5:first-child, h6:first-child { margin-top: 0pt; }
.thin, .thin h1, .thin h2, .thin h3, .thin h4, .thin h5, .thin h6 { font-weight: 300; font-family: 'Open Sans',sans-serif; }
.with-padding { padding: 20px ! important; }
.margin-bottom { margin-bottom: 16px ! important; }
.columns { margin-left: -2.25%; }
.columns:last-child { margin-bottom: -20px; }
.columns > div, .columns > form { float: left; margin: 0pt 0pt 20px 2.25%; }
.three-columns, .three-columns-tablet, .three-columns-mobile, .three-columns-mobile-landscape, .three-columns-mobile-portrait { width: 22.75%; }
.six-columns, .six-columns-tablet, .six-columns-mobile, .six-columns-mobile-landscape, .six-columns-mobile-portrait { width: 47.75%; }
.block, details.details { border: 1px solid rgb(191, 191, 191); position: relative; border-radius: 9px 9px 9px 9px; }
.block-title, details.details > summary { display: block; position: relative; padding: 18px 19px; border-bottom-width: 1px; border-bottom-style: solid; box-shadow: 0pt 1px 0pt rgba(255, 255, 255, 0.75) inset, 0pt 1px 1px rgba(0, 0, 0, 0.15); }
.block-title { border-top-left-radius: 8px; border-top-right-radius: 8px; }
h3.block-title { padding: 15px 19px; margin: 0pt; }

#main { position: relative; z-index: 2; }
.disabled, .disabled span, .disabled .input, .disabled input, .disabled .label, .disabled label, .disabled .button, .disabled button, .disabled a, :disabled { cursor: not-allowed ! important; }
.button { display: inline-block; vertical-align: baseline; position: relative; text-align: center; font-weight: bold; text-transform: none; padding: 0pt 11px; font-size: 13px; line-height: 28px; height: 28px; -moz-box-sizing: content-box; min-width: 6px; border-width: 1px; border-style: solid; border-radius: 4px 4px 4px 4px; background-position: center center ! important; }
.button, .button-group > .button:first-child, .select-value, .legend { box-shadow: 0pt 1px 0pt rgba(255, 255, 255, 0.75) inset, 0pt 1px 1px rgba(0, 0, 0, 0.15); }
.button, .select-value, .legend { text-shadow: 0pt 1px 0pt rgba(255, 255, 255, 0.75); }
.button:active, .button.active { border: 0pt none; padding: 1px 12px; box-shadow: 0pt 1px 5px rgba(0, 0, 0, 0.75) inset, 0pt 1px 1px rgba(255, 255, 255, 0.35) ! important; }
.button:disabled, .button.disabled, .disabled .button, .disabled .select-value, .disabled .select-arrow { box-shadow: none ! important; text-shadow: none ! important; }
.button:disabled, .button.disabled, .disabled .button { border-width: 1px; border-style: solid; padding: 0pt 11px; }
:active > .button-icon, .active > .button-icon { box-shadow: 0pt 1px 5px rgba(0, 0, 0, 0.75) inset; }
:active > .button-icon.black-gradient, .active > .button-icon.black-gradient, :active > .button-icon.anthracite-gradient, .active > .button-icon.anthracite-gradient, :active > .button-icon.grey-gradient, .active > .button-icon.grey-gradient, :active > .button-icon.blue-gradient, .active > .button-icon.blue-gradient { text-shadow: 0pt -1px 0pt rgba(0, 0, 0, 0.6); }
:active > .button-icon.white-gradient, .active > .button-icon.white-gradient { text-shadow: 0pt 1px 0pt rgba(255, 255, 255, 0.75); }
:disabled > .button-icon, .disabled .button-icon { box-shadow: none; text-shadow: none; }

.clearfix:before, .clearfix:after, .columns:before, .columns:after, .left-column-200px:before, .left-column-200px:after, .right-column-200px:before, .right-column-200px:after, #profile:before, #profile:after, #main-title:before, #main-title:after, .notification:before, .notification:after, .inline-small-label:before, .inline-small-label:after, .inline-label:before, .inline-label:after, .inline-medium-label:before, .inline-medium-label:after, .inline-large-label:before, .inline-large-label:after, .definition.inline:before, .definition.inline:after, .blocks-list:before, .blocks-list:after { content: " "; display: block; height: 0pt; visibility: hidden; }
.clearfix:after, .columns:after, .left-column-200px:after, .right-column-200px:after, #profile:after, #main-title:after, .notification:after, .inline-small-label:after, .inline-label:after, .inline-medium-label:after, .inline-large-label:after, .definition.inline:after, .blocks-list:after { clear: both; }
.clearfix, .columns, .left-column-200px, .right-column-200px, #profile, #main-title, .notification, .inline-small-label, .inline-label, .inline-medium-label, .inline-large-label, .definition.inline, .blocks-list {  }

.button, .button:visited, .select-value, .select-arrow, .switch-button, .black-inputs .radio > .check-knob, .black-inputs.radio > .check-knob, .legend, .block-title, .details > summary, .accordion > dt, .table > thead > tr > th, .table > thead > tr > td, .table > tfoot > tr > th, .table > tfoot > tr > td, .agenda-header, .agenda-event, .tabs-back, .blocks-list > li { color: rgb(102, 102, 102); background: -moz-linear-gradient(center top , rgb(239, 239, 244), rgb(214, 218, 223)) repeat scroll 0% 0% transparent; border-color: rgb(204, 204, 204); }
.no-touch .drop-down > span:hover, .no-touch .drop-down > a:hover, .drop-down > .selected, :hover > .button-icon { color: white; background: -moz-linear-gradient(center top , rgb(0, 137, 195), rgb(0, 61, 134)) repeat scroll 0% 0% transparent; border-color: rgb(0, 71, 149); }
:hover > .button-icon.glossy, .glossy:hover > .button-icon { background: -moz-linear-gradient(center top , rgb(70, 189, 229), rgb(2, 108, 196) 50%, rgb(0, 92, 172) 50%, rgb(5, 111, 201)) repeat scroll 0% 0% transparent; }

.red-gradient.glossy:hover, button.red-gradient.glossy:hover, .glossy:hover > .button-icon.red-gradient, :hover > .button-icon.glossy.red-gradient, .red-gradient.glossy > a.select-value:hover, .red-gradient.glossy > .select-arrow:hover { background: -moz-linear-gradient(center top , rgb(254, 155, 150), rgb(223, 20, 17) 50%, rgb(206, 13, 12) 50%, rgb(233, 66, 55)) repeat scroll 0% 0% transparent; }
a.red-gradient:active, button.red-gradient:active, .button.red-gradient:active, .red-gradient.active, :active > .button-icon.red-gradient, .active > .button-icon.red-gradient { background: -moz-linear-gradient(center top , rgb(206, 29, 6), rgb(228, 54, 10)) repeat scroll 0% 0% transparent ! important; }
a.orange-gradient:hover, button.orange-gradient:hover, :hover > .button-icon.orange-gradient, .orange-gradient > a.select-value:hover, .orange-gradient > .select-arrow:hover { color: white; background: -moz-linear-gradient(center top , rgb(255, 205, 0), rgb(255, 151, 0)) repeat scroll 0% 0% transparent; border-color: rgb(204, 151, 7); }
a.orange-gradient.glossy:hover, button.orange-gradient.glossy:hover, .glossy:hover > .button-icon.orange-gradient, :hover > .button-icon.glossy.orange-gradient, .orange-gradient.glossy > a.select-value:hover, .orange-gradient.glossy > .select-arrow:hover { background: -moz-linear-gradient(center top , rgb(255, 227, 38), rgb(255, 183, 0) 50%, rgb(236, 169, 0) 50%, rgb(241, 174, 0) 80%, rgb(232, 164, 0)) repeat scroll 0% 0% transparent; }
a.orange-gradient:active, button.orange-gradient:active, .button.orange-gradient:active, .orange-gradient.active, :active > .button-icon.orange-gradient, .active > .button-icon.orange-gradient { background: -moz-linear-gradient(center top , rgb(255, 138, 0), rgb(255, 191, 0)) repeat scroll 0% 0% transparent ! important; }
a.green-gradient:hover, button.green-gradient:hover, :hover > .button-icon.green-gradient, .green-gradient > a.select-value:hover, .green-gradient > .select-arrow:hover { color: white; background: -moz-linear-gradient(center top , rgb(191, 221, 77), rgb(128, 181, 20)) repeat scroll 0% 0% transparent; border-color: rgb(109, 150, 12); }

</style>


</head>



<body>

<section id="main">

	<div class="with-padding">

		<div class="columns">
				
			<div class="block margin-bottom" style="background-color: #ffe;">
			<h3 class="block-title orange-gradient" style=" color: white; background: -moz-linear-gradient(center top , rgb(255, 205, 0), rgb(255, 151, 0)) repeat scroll 0% 0% transparent; border-color: rgb(204, 151, 7); margin-top: 0px; " ><%=WarningTitle%></h3>
			<div class="with-padding">
				<h4 class="thin">
					<p><%=WarningMessage%></p>
				</h4>
				</p>
				<%
				If Session("UserNumber") = "" Then
					Response.Write "<FORM ACTION=""/ShoppingCart.asp"" METHOD=""POST"" id=form1 name=form1>" & vbCrLf
				Else
					Response.Write "<FORM ACTION=""/Management/ShoppingCart.asp"" METHOD=""POST"" id=form1 name=form1>" & vbCrLf
				End If

				Response.Write "<INPUT TYPE=""submit"" VALUE=""Return to Shopping Cart"" id=""form1"" name=""form1"" class=""button gray-bg""></FORM>" & vbCrLf
				%>
				</p>
			</div>
			</div>
			</div>


			
			


		</div>


	   
</section>

</body>
<!--#INCLUDE virtual="FooterInclude.asp"-->

</html>



<%


End Sub 
'========================================

Sub ApplyDiscount

ReqSectionList = ""
ReqSectionCount = ""

SectionArray = Split(SectionList,",")


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

SectionArray = Split(SectionList,",")

For i = 0 to ubound(SectionArray)

	ErrorLog("SectionArray " & SectionArray(i) & "")

	SQLOrderSeats = "SELECT Seat.SectionCode, OrderLine.Price, COUNT(OrderLine.ItemNumber) AS OrderSeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber")	& " AND Seat.SectionCode = '" & SectionArray(i) & "' AND OrderLine.ItemType IN ('SubFixedEvent', 'SubSeat', 'Seat') GROUP BY Seat.EventCode, Seat.SectionCode, OrderLine.Price"
	Set rsOrderSeats = OBJdbConnection.Execute(SQLOrderSeats)
	
			ThisSectionCode = rsOrderSeats("SectionCode")
			ThisSectionCount = rsOrderSeats("OrderSeatCount")
									
				If ThisSectionCount > 2 Then
				
					If ThisSectionCode = "PLAT" Then
						NewPrice = 45
					Else
						NewPrice = 40
					End If
					
					DiscountAmount = rsOrderSeats("Price") - NewPrice
					
					SQLLineNo = "SELECT TOP(" & ThisSectionCount & ") LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN EVENT (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Seat.SectionCode =  '" & SectionArray(i) & "'  ORDER BY LineNumber DESC"
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



