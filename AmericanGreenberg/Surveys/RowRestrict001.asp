<%

'CHANGE LOG
'SSR - 12/13/2012 - Custom Survey Created

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'============================================================

Page = "Survey"
SurveyNumber = 1391
SurveyName = "RowRestrict.asp"
BoxOfficeByPass = False
CompOrderByPass = True

'Options
'BoxOfficeByPass = False will display for box office, fax, phone order types (default)
'CompOrderByPass = True  will bypass for comp order type (default)

'============================================================

'American University Greenberg

'Custom Presale Code Programming 
'(Survey to restrict seat sales unless discount code has been entered)

'We have the parameters for our special sale needs. 
'However, it isn’t truly what I would call a presale.
'We want the other seating for the event to be on sale along with the special seating section. 
'The event is set up, but not activated. 

'Production Name:	Cabaret (85415)
'Event:				514772 
'Date:				Thursday, April 4, 2013 

'Sale Beginning: Activated when programming is complete 
'Sale End: March 15, 2013 (All seats go to regular sale at 12:00am on March 16, 2013) 

'Seat Locations: 
'Row D 1-21 (all) 
'Row E 1-23 (all) 
'Row F 1-23 (all) 
'Row G 1-24 (all) 

'code SYLVIA2013. 

'============================================================

'Unlock Code
SpecialDiscountType = "75795"

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

'Bypass this survey on all Comp Orders
'Bypass this survey for Box Office Users

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

'============================================================

'Request the form name and process requested action

Select Case Clean(Request("FormName"))
    Case "Continue"
        Call Continue
    Case Else
        Call CheckCurrentOrder
 End Select
 
'==========================================================

Sub CheckCurrentOrder

ErrorLog("Check Order")

'Check if there are any restricted seats on the current order
SQLSeatCheck = "SELECT Count(Seat.ItemNumber) as Count FROM Seat (NOLOCK) WHERE Seat.OrderNumber = " & CleanNumeric(Session("OrderNumber"))& " AND Seat.Row IN ('D','E','F')"
Set rsSeatCheck = OBJdbConnection.Execute(SQLSeatCheck)

ErrorLog("SeatCount " & rsSeatCheck("Count") & "")

	If rsSeatCheck("Count") >= 1 Then 
	
		SQLApplied = "SELECT COUNT(OrderLine.LineNumber) AS Count FROM OrderLine (NOLOCK) WHERE OrderLine.OrderNumber = " & CleanNumeric(Session("OrderNumber")) & " AND OrderLine.DiscountTypeNumber  = 75795"
		Set rsApplied = OBJdbConnection.Execute(SQLApplied)
		
		ErrorLog("Discounts " & rsApplied("Count") & "")
		
		   If rsApplied("Count") = 0 Then
				Call WarningPage
			Else
				Call Continue
			End If
			
		rsApplied.Close
		Set rsApplied  = nothing	
		
	Else
		Call Continue
	End If
		
rsSeatCheck.Close
Set rsSeatCheck = nothing	


End Sub 'CheckCurrentOrder

'==========================================================

Sub WarningPage

%>

<!DOCTYPE html>

<html>

<head>

<!--#INCLUDE VIRTUAL="TopNavInclude.asp"-->

<title>TIX.com</title>

<style type="text/css">

button, input, textarea { font-family: Arial,Helvetica,sans-serif; font-size: 13px; line-height: 16px; color: rgb(102, 102, 102); }
p, ul, ol, dl { margin-bottom: 16px; }
p:last-child, ul:last-child, ol:last-child, dl:last-child, fieldset:last-child, .fieldset:last-child { margin-bottom: 0pt; }
a { text-decoration: none; }
a:hover { color: rgb(0, 153, 255); }
h1, h2 { padding: 0pt; text-shadow: 0px 1px 5px rgba(0, 0, 0, 0.25); }
h1 { font-size: 30px; line-height: 36px; margin-bottom: 26px; }
h2 { font-size: 24px; line-height: 28px; margin: 32px 0pt 22px; }
h3 { font-size: 21px; line-height: 25px; margin: 30px 0pt 20px; }
h4 { font-size: 16px; line-height: 19px; margin: 25px 0pt 15px; }
h5 { margin: 20px 0pt 10px; }
h6 { font-size: 11px; text-transform: uppercase; }
h2:first-child, h3:first-child, h4:first-child, h5:first-child, h6:first-child { margin-top: 0pt; }
.thin, .thin h1, .thin h2, .thin h3, .thin h4, .thin h5, .thin h6 { font-weight: 300; font-family: 'Open Sans',sans-serif; }
.with-padding { padding: 20px ! important; }
.margin-bottom { margin-bottom: 16px ! important; }
.columns { margin-left: -2.25%; }
.columns:last-child { margin-bottom: -20px; }
.columns > div, .columns > form { float: left; margin: 0pt 0pt 20px 2.25%; }
.two-columns, .two-columns-tablet, .two-columns-mobile, .two-columns-mobile-landscape, .two-columns-mobile-portrait { width: 14.4167%; }
.three-columns, .three-columns-tablet, .three-columns-mobile, .three-columns-mobile-landscape, .three-columns-mobile-portrait { width: 22.75%; }
.four-columns, .four-columns-tablet, .four-columns-mobile, .four-columns-mobile-landscape, .four-columns-mobile-portrait { width: 31.0833%; }
.six-columns, .six-columns-tablet, .six-columns-mobile, .six-columns-mobile-landscape, .six-columns-mobile-portrait { width: 47.75%; }
.eight-columns, .eight-columns-tablet, .eight-columns-mobile, .eight-columns-mobile-landscape, .eight-columns-mobile-portrait { width: 64.4167%; }
.twelve-columns, .twelve-columns-tablet, .twelve-columns-mobile, .twelve-columns-mobile-landscape, .twelve-columns-mobile-portrait { width: 97.75%; }
.block, details.details { border: 1px solid rgb(191, 191, 191); position: relative; border-radius: 9px 9px 9px 9px; }
.block-title, details.details > summary { display: block; position: relative; padding: 18px 19px; border-bottom-width: 1px; border-bottom-style: solid; box-shadow: 0pt 1px 0pt rgba(255, 255, 255, 0.75) inset, 0pt 1px 1px rgba(0, 0, 0, 0.15); }
.block-title { border-top-left-radius: 8px; border-top-right-radius: 8px; }
h3.block-title { padding: 15px 19px; margin: 0pt; }
#main { position: relative; z-index: 2; }
.disabled, .disabled span, .disabled .input, .disabled input, .disabled .label, .disabled label, .disabled .button, .disabled button, .disabled a, :disabled { cursor: not-allowed ! important; }
:active > .button-icon, .active > .button-icon { box-shadow: 0pt 1px 5px rgba(0, 0, 0, 0.75) inset; }
:active > .button-icon.black-gradient, .active > .button-icon.black-gradient, :active > .button-icon.anthracite-gradient, .active > .button-icon.anthracite-gradient, :active > .button-icon.grey-gradient, .active > .button-icon.grey-gradient, :active > .button-icon.blue-gradient, .active > .button-icon.blue-gradient { text-shadow: 0pt -1px 0pt rgba(0, 0, 0, 0.6); }
:active > .button-icon.white-gradient, .active > .button-icon.white-gradient { text-shadow: 0pt 1px 0pt rgba(255, 255, 255, 0.75); }
:disabled > .button-icon, .disabled .button-icon { box-shadow: none; text-shadow: none; }

a:link {  }
.clearfix:before, .clearfix:after, .columns:before, .columns:after, .left-column-200px:before, .left-column-200px:after, .right-column-200px:before, .right-column-200px:after, #profile:before, #profile:after, #main-title:before, #main-title:after, .notification:before, .notification:after, .inline-small-label:before, .inline-small-label:after, .inline-label:before, .inline-label:after, .inline-medium-label:before, .inline-medium-label:after, .inline-large-label:before, .inline-large-label:after, .definition.inline:before, .definition.inline:after, .blocks-list:before, .blocks-list:after { content: " "; display: block; height: 0pt; visibility: hidden; }
.clearfix:after, .columns:after, .left-column-200px:after, .right-column-200px:after, #profile:after, #main-title:after, .notification:after, .inline-small-label:after, .inline-label:after, .inline-medium-label:after, .inline-large-label:after, .definition.inline:after, .blocks-list:after { clear: both; }
.clearfix, .columns, .left-column-200px, .right-column-200px, #profile, #main-title, .notification, .inline-small-label, .inline-label, .inline-medium-label, .inline-large-label, .definition.inline, .blocks-list {  }

.button, .button:visited, .select-value, .select-arrow, .switch-button, .black-inputs .radio > .check-knob, .black-inputs.radio > .check-knob, .legend, .block-title, .details > summary, .accordion > dt, .table > thead > tr > th, .table > thead > tr > td, .table > tfoot > tr > th, .table > tfoot > tr > td, .agenda-header, .agenda-event, .tabs-back, .blocks-list > li { color: rgb(102, 102, 102); background: -moz-linear-gradient(center top , rgb(239, 239, 244), rgb(214, 218, 223)) repeat scroll 0% 0% transparent; border-color: rgb(204, 204, 204); }
.no-touch .drop-down > span:hover, .no-touch .drop-down > a:hover, .drop-down > .selected, :hover > .button-icon { color: white; background: -moz-linear-gradient(center top , rgb(0, 137, 195), rgb(0, 61, 134)) repeat scroll 0% 0% transparent; border-color: rgb(0, 71, 149); }
:hover > .button-icon.glossy, .glossy:hover > .button-icon { background: -moz-linear-gradient(center top , rgb(70, 189, 229), rgb(2, 108, 196) 50%, rgb(0, 92, 172) 50%, rgb(5, 111, 201)) repeat scroll 0% 0% transparent; }
a.silver-gradient:hover, button.silver-gradient:hover, :hover > .button-icon.silver-gradient, .silver-gradient > a.select-value:hover, .silver-gradient > .select-arrow:hover { color: rgb(102, 102, 102); background: -moz-linear-gradient(center top , rgb(254, 254, 254), rgb(215, 219, 223)) repeat scroll 0% 0% transparent; border-color: rgb(204, 204, 204); }
a.silver-gradient.glossy:hover, button.silver-gradient.glossy:hover, .glossy:hover > .button-icon.silver-gradient, :hover > .button-icon.glossy.silver-gradient, .silver-gradient.glossy > a.select-value:hover, .silver-gradient.glossy > .select-arrow:hover { background: -moz-linear-gradient(center top , rgb(250, 250, 252), rgb(237, 237, 240) 50%, rgb(227, 227, 229) 50%, rgb(232, 232, 235)) repeat scroll 0% 0% transparent; }
a.silver-gradient:active, button.silver-gradient:active, .button.silver-gradient:active, .silver-gradient.active, :active > .button-icon.silver-gradient, .active > .button-icon.silver-gradient { background: -moz-linear-gradient(center top , rgb(189, 189, 189), rgb(219, 219, 219)) repeat scroll 0% 0% transparent ! important; }
a.black-gradient:hover, button.black-gradient:hover, :hover > .button-icon.black-gradient, .black-gradient > a.select-value:hover, .black-gradient > .select-arrow:hover { color: white; background: -moz-linear-gradient(center top , rgb(71, 71, 71), rgb(27, 27, 27)) repeat scroll 0% 0% transparent; border-color: black; }
a.black-gradient.glossy:hover, button.black-gradient.glossy:hover, .glossy:hover > .button-icon.black-gradient, :hover > .button-icon.glossy.black-gradient, .black-gradient.glossy > a.select-value:hover, .black-gradient.glossy > .select-arrow:hover { background: -moz-linear-gradient(center top , rgb(107, 107, 107), rgb(92, 92, 92) 4%, rgb(48, 48, 48) 44%, rgb(38, 38, 38) 50%, rgb(13, 13, 13) 50%, rgb(8, 8, 8)) repeat scroll 0% 0% transparent; }
a.black-gradient:active, button.black-gradient:active, .button.black-gradient:active, .black-gradient.active, :active > .button-icon.black-gradient, .active > .button-icon.black-gradient { background: -moz-linear-gradient(center top , black, rgb(38, 38, 38)) repeat scroll 0% 0% transparent ! important; }
a.anthracite-gradient:hover, button.anthracite-gradient:hover, :hover > .button-icon.anthracite-gradient, .no-touch .red-gradient > .drop-down > span:hover, .no-touch .red-gradient > .drop-down > a:hover, .red-gradient > .drop-down > .selected, .no-touch .orange-gradient > .drop-down > span:hover, .no-touch .orange-gradient > .drop-down > a:hover, .orange-gradient > .drop-down > .selected, .no-touch .green-gradient > .drop-down > span:hover, .no-touch .green-gradient > .drop-down > a:hover, .green-gradient > .drop-down > .selected, .no-touch .blue-gradient > .drop-down > span:hover, .no-touch .blue-gradient > .drop-down > a:hover, .blue-gradient > .drop-down > .selected, .anthracite-gradient > a.select-value:hover, .anthracite-gradient > .select-arrow:hover, .black-inputs .number-up:hover, .black-input > .number-up:hover, .black-inputs .number-down:hover, .black-input > .number-down:hover { color: white; background: -moz-linear-gradient(center top , rgb(109, 109, 109), rgb(58, 58, 58)) repeat scroll 0% 0% transparent; border-color: rgb(40, 46, 54); }
a.anthracite-gradient.glossy:hover, button.anthracite-gradient.glossy:hover, .glossy:hover > .button-icon.anthracite-gradient, :hover > .button-icon.glossy.anthracite-gradient, .anthracite-gradient.glossy > a.select-value:hover, .anthracite-gradient.glossy > .select-arrow:hover { background: -moz-linear-gradient(center top , rgb(145, 145, 145), rgb(90, 90, 90) 50%, rgb(62, 62, 62) 50%, rgb(101, 101, 101)) repeat scroll 0% 0% transparent; }
a.anthracite-gradient:active, button.anthracite-gradient:active, .button.anthracite-gradient:active, .anthracite-gradient.active, :active > .button-icon.anthracite-gradient, .active > .button-icon.anthracite-gradient, .black-inputs .number-up:active, .black-input > .number-up:active, .black-inputs .number-down:active, .black-input > .number-down:active { background: -moz-linear-gradient(center top , rgb(38, 38, 38), rgb(71, 71, 71)) repeat scroll 0% 0% transparent ! important; }
a.grey-gradient:hover, button.grey-gradient:hover, :hover > .button-icon.grey-gradient, .grey-gradient > a.select-value:hover, .grey-gradient > .select-arrow:hover { color: white; background: -moz-linear-gradient(center top , rgb(214, 214, 214), rgb(139, 139, 139)) repeat scroll 0% 0% transparent; border-color: rgb(102, 102, 102); }
a.grey-gradient.glossy:hover, button.grey-gradient.glossy:hover, .glossy:hover > .button-icon.grey-gradient, :hover > .button-icon.glossy.grey-gradient, .grey-gradient.glossy > a.select-value:hover, .grey-gradient.glossy > .select-arrow:hover { background: -moz-linear-gradient(center top , rgb(212, 212, 212), rgb(160, 160, 160) 50%, rgb(136, 136, 136) 50%, rgb(171, 171, 171)) repeat scroll 0% 0% transparent; }
a.grey-gradient:active, button.grey-gradient:active, .button.grey-gradient:active, .grey-gradient.active, :active > .button-icon.grey-gradient, .active > .button-icon.grey-gradient, .black-inputs .switch-off, .black-input > .switch-off { background: -moz-linear-gradient(center top , rgb(122, 122, 122), rgb(183, 183, 183)) repeat scroll 0% 0% transparent ! important; }
a.white-gradient:hover, button.white-gradient:hover, :hover > .button-icon.white-gradient, .white-gradient > a.select-value:hover, .white-gradient > .select-arrow:hover { color: rgb(102, 102, 102); background: -moz-linear-gradient(center top , rgb(254, 254, 254), rgb(237, 240, 242)) repeat scroll 0% 0% transparent; border-color: rgb(204, 204, 204); }
a.white-gradient.glossy:hover, button.white-gradient.glossy:hover, .glossy:hover > .button-icon.white-gradient, :hover > .button-icon.glossy.white-gradient, .white-gradient.glossy > a.select-value:hover, .white-gradient.glossy > .select-arrow:hover { background: -moz-linear-gradient(center top , rgb(254, 254, 255), rgb(245, 245, 247) 50%, rgb(239, 239, 241) 50%, rgb(245, 245, 247)) repeat scroll 0% 0% transparent; }
a.white-gradient:active, button.white-gradient:active, .button.white-gradient:active, .white-gradient.active, :active > .button-icon.white-gradient, .active > .button-icon.white-gradient, .switch-off { background: -moz-linear-gradient(center top , rgb(224, 224, 224), rgb(240, 240, 240)) repeat scroll 0% 0% transparent ! important; border-color: rgb(204, 204, 204); }
a.green-gradient:active, button.green-gradient:active, .button.green-gradient:active, .green-gradient.active, :active > .button-icon.green-gradient, .active > .button-icon.green-gradient, .switch-on { background: -moz-linear-gradient(center top , rgb(109, 173, 18), rgb(176, 210, 34)) repeat scroll 0% 0% transparent ! important; border-color: rgb(109, 150, 12); }
:disabled > .button-icon, .disabled .button-icon { color: white ! important; border-color: rgb(133, 140, 148) ! important; background: -moz-linear-gradient(center top , rgb(132, 183, 215), rgb(132, 164, 200)) repeat scroll 0% 0% transparent ! important; }
</style>

</head>



<body>

<section id="main">

	<div class="with-padding">

		<div class="columns">
				
		    <div class="three-columns">
		    <p>&nbsp;</p>
		    </div>

			<div class="six-columns">
				<div class="block margin-bottom">
					<h2 class="block-title">Sorry</h2>
					<div class="with-padding">
						<p style="margin-top: -10px;">
                            A promotional code is required in order to purchase the following seats:<br>
							<br>
							<table border="1" cellpadding="5" cellspacing="0">
							<tr> <th>Row</th><th>Seats</th> <tr>
							<tr> <td>D</td><td>1-21</td> </tr>
							<tr> <td>E</td><td>1-21</td> </tr>
							<tr> <td>F</td><td>1-21</td> </tr>
							<tr> <td>G</td><td>1-21</td> </tr>
							</table>
							<br>
                        </p>
                            <%
                            If Session("UserNumber") = "" Then
	                            Response.Write "<FORM ACTION=""/ShoppingCart.asp"" METHOD=""POST"" id=form1 name=form1>" & vbCrLf
                            Else
	                            Response.Write "<FORM ACTION=""/Management/ShoppingCart.asp"" METHOD=""POST"" id=form1 name=form1>" & vbCrLf
                            End If

                            Response.Write "<INPUT TYPE=""submit"" VALUE=""Return to Shopping Cart"" id=""form1"" name=""form1""></FORM>" & vbCrLf
                            %>
                        </p>
					</div>
				</div>
			</div>

			<div class="three-columns">
			<p>&nbsp;</p>
			</div>

		</div>

	</div>
	   
</section>

</body>
<!--#INCLUDE virtual="FooterInclude.asp"-->

</html>



<%


End Sub 'CongratulationsPageNewSubscription

'============================================================

Sub Continue

Session("SurveyComplete") = Session("OrderNumber")

If Session("UserNumber") = "" Then
	Response.Redirect("/Ship.asp")
Else
	Response.Redirect("/Management/AdvanceShip.asp")
End If

End Sub 'Continue

'============================================================

Sub Continue2



End Sub 'Continue

'============================================================

%>