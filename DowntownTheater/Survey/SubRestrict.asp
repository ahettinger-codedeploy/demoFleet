<%

'CHANGE LOG
'SSR - 12/07/2012 - Created custom survey
'SSR - 01/08/2012 - Updated for 2012 Season
'SSR - 01/09/2012 - Fixed display issues & updated warning page text
'SSR - 02/06/2013 - Updated for 2013 Season
'SSR - 01/09/2014 - Updated for 2014 Season
'SSR - 2/21/2014 -  Updated wording
'SSR - 3/4/2014  -  Set BoxOfficeByPass 


%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'============================================================

Page = "Survey"
SurveyNumber = 1141
SurveyName = "SubRestrict.asp"
BoxOfficeByPass = False
CompOrderByPass = True
DisplayProductions = True
DisplayExpirationDate = True

'Options
'BoxOfficeByPass = True/False  		bypass survey for box office, fax, and phone order types (Default is False)
'CompOrderByPass = True/False  		bypass survey for comp order type (default is True)
'DisplayProductions = True/False 	display which productions make up the season series (Default is False)
'DisplayExpirationDate = True/False display the date that this restriction ends.(Default is False)

'============================================================

'Union Avenue Opera 

'This survey prevents single ticket sales until the listed expiration date.  
'Until the expiration date is reached, only "build your own" season subscriptions are allowed.

'This restriction is bypassed on box office or comp orders.

'Survey checks each order for the season subscription discount code applied to season subscription orders. 
'If that discount code is not found, a warning page will be displayed and patron will be directed back to shopping cart.
'Warning page will list the productions which can be used to build a subscription.
'Warning page will also display the expiration date of this restriction.


'============================================================

CurrentSeasonDiscount = "95921"
ExpirationDate = "12/31/2015"
SeriesCount = 3

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

'Verify if survey should bypass 
'the comp or box office order types

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
        Else
			Call CheckCurrentOrder
		End If
End Select


'------------------------------------------------------------

Sub CheckCurrentOrder

'If restriction has expired, bypass the survey
'Otherwise, verify that order has the discount code

Dim SeasonDiscountList
SeasonDiscountList = CurrentSeasonDiscount & ", 37"

If Now() < CDate(ExpirationDate) Then

	'Confirm season subscription
	SQLSeasonDiscount = "SELECT Count(OrderLine.LineNumber) as Count FROM OrderLine (NOLOCK) WHERE OrderLine.DiscountTypeNumber IN (" & SeasonDiscountList & ") AND OrderLine.OrderNumber = " & CleanNumeric(Session("OrderNumber"))& ""
	Set rsSeasonDiscount = OBJdbConnection.Execute(SQLSeasonDiscount)

	If rsSeasonDiscount("Count") => SeriesCount Then 
		Call Continue
	Else
		Call WarningPage
	End If

	rsSeasonDiscount.Close
	Set rsSeasonDiscount = nothing
	
Else

Call Continue


End If


End Sub 'CheckCurrentOrder

'------------------------------------------------------------

Sub WarningPage

%>

<!DOCTYPE html>

<html>

<head>

<title>TIX.com</title>
<style>html { font-family: sans-serif; } body { margin: 0px; } a { background: none repeat scroll 0% 0% transparent; } a:focus { outline: thin dotted; } a:active, a:hover { outline: 0px none; } b, strong { font-weight: bold; } img { border: 0px none; } svg:not(:root) { overflow: hidden; } button, input, select, textarea { margin: 0px; font-family: inherit; font-size: 100%; } button, input { line-height: normal; } button, select { text-transform: none; } button, html input[type="button"], input[type="reset"], input[type="submit"] { cursor: pointer; } button::-moz-focus-inner, input::-moz-focus-inner { padding: 0px; border: 0px none; } table { border-collapse: collapse; border-spacing: 0px; } *, *:before, *:after { -moz-box-sizing: border-box; } html { font-size: 62.5%; } body { font-family: "Helvetica Neue",Helvetica,Arial,sans-serif; font-size: 14px; line-height: 1.42857; color: rgb(51, 51, 51); background-color: rgb(255, 255, 255); } input, button, select, textarea { font-family: inherit; font-size: inherit; line-height: inherit; } a { color: rgb(66, 139, 202); text-decoration: none; } a:hover, a:focus { color: rgb(42, 100, 150); text-decoration: underline; } a:focus { outline: thin dotted; outline-offset: -2px; } img { vertical-align: middle; } h1, h2, h3, h4, h5, h6, .h1, .h2, .h3, .h4, .h5, .h6 { font-family: "Helvetica Neue",Helvetica,Arial,sans-serif; font-weight: 500; line-height: 1.1; color: inherit; } h1, h2, h3 { margin-top: 20px; margin-bottom: 10px; } h3, .h3 { font-size: 24px; } ul, ol { margin-top: 0px; margin-bottom: 10px; } ul ul, ol ul, ul ol, ol ol { margin-bottom: 0px; } .row { margin-right: -15px; margin-left: -15px; } .row:before, .row:after { display: table; content: " "; } .row:after { clear: both; } .row:before, .row:after { display: table; content: " "; } .row:after { clear: both; } table { max-width: 100%; background-color: transparent; } .table-striped > tbody > tr:nth-child(2n+1) > td, .table-striped > tbody > tr:nth-child(2n+1) > th { background-color: rgb(249, 249, 249); } .form-control::-moz-placeholder { color: rgb(153, 153, 153); opacity: 1; } .btn { display: inline-block; padding: 6px 12px; margin-bottom: 0px; font-size: 14px; font-weight: normal; line-height: 1.42857; text-align: center; white-space: nowrap; vertical-align: middle; cursor: pointer; background-image: none; border: 1px solid transparent; border-radius: 4px; -moz-user-select: none; } .btn:focus { outline: thin dotted; outline-offset: -2px; } .btn:hover, .btn:focus { color: rgb(51, 51, 51); text-decoration: none; } .btn:active, .btn.active { background-image: none; outline: 0px none; box-shadow: 0px 3px 5px rgba(0, 0, 0, 0.125) inset; } .btn-default { color: rgb(51, 51, 51); background-color: rgb(255, 255, 255); border-color: rgb(204, 204, 204); } .btn-default:hover, .btn-default:focus, .btn-default:active, .btn-default.active, .open .dropdown-toggle.btn-default { color: rgb(51, 51, 51); background-color: rgb(235, 235, 235); border-color: rgb(173, 173, 173); } .btn-default:active, .btn-default.active, .open .dropdown-toggle.btn-default { background-image: none; } @font-face { font-family: "Glyphicons Halflings"; src: url('glyphicons-halflings-regular.eot') format("embedded-opentype"), url('glyphicons-halflings-regular.woff') format("woff"), url('glyphicons-halflings-regular.ttf') format("truetype"), url('glyphicons-halflings-regular.svg') format("svg"); } .btn-group > .btn:not(:first-child):not(:last-child):not(.dropdown-toggle) { border-radius: 0px; } .btn-group > .btn:first-child:not(:last-child):not(.dropdown-toggle) { border-top-right-radius: 0px; border-bottom-right-radius: 0px; } .btn-group > .btn:last-child:not(:first-child), .btn-group > .dropdown-toggle:not(:first-child) { border-bottom-left-radius: 0px; border-top-left-radius: 0px; } .btn-group > .btn-group:not(:first-child):not(:last-child) > .btn { border-radius: 0px; } .btn-group-vertical > .btn:not(:first-child):not(:last-child) { border-radius: 0px; } .btn-group-vertical > .btn:first-child:not(:last-child) { border-top-right-radius: 4px; border-bottom-right-radius: 0px; border-bottom-left-radius: 0px; } .btn-group-vertical > .btn:last-child:not(:first-child) { border-top-right-radius: 0px; border-bottom-left-radius: 4px; border-top-left-radius: 0px; } .btn-group-vertical > .btn-group:not(:first-child):not(:last-child) > .btn { border-radius: 0px; } .input-group-addon:not(:first-child):not(:last-child), .input-group-btn:not(:first-child):not(:last-child), .input-group .form-control:not(:first-child):not(:last-child) { border-radius: 0px; } .input-group .form-control:first-child, .input-group-addon:first-child, .input-group-btn:first-child > .btn, .input-group-btn:first-child > .dropdown-toggle, .input-group-btn:last-child > .btn:not(:last-child):not(.dropdown-toggle) { border-top-right-radius: 0px; border-bottom-right-radius: 0px; } .input-group .form-control:last-child, .input-group-addon:last-child, .input-group-btn:last-child > .btn, .input-group-btn:last-child > .dropdown-toggle, .input-group-btn:first-child > .btn:not(:first-child) { border-bottom-left-radius: 0px; border-top-left-radius: 0px; } @media screen and (min-width: 768px) { } .panel { margin-bottom: 20px; background-color: rgb(255, 255, 255); border: 1px solid transparent; border-radius: 4px; box-shadow: 0px 1px 1px rgba(0, 0, 0, 0.05); } .panel-body { padding: 15px; } .panel-body:before, .panel-body:after { display: table; content: " "; } .panel-body:after { clear: both; } .panel-body:before, .panel-body:after { display: table; content: " "; } .panel-body:after { clear: both; } .panel-heading { padding: 10px 15px; border-bottom: 1px solid transparent; border-top-right-radius: 3px; border-top-left-radius: 3px; } .panel-title { margin-top: 0px; margin-bottom: 0px; font-size: 16px; color: inherit; } .panel-footer { padding: 10px 15px; background-color: rgb(245, 245, 245); border-top: 1px solid rgb(221, 221, 221); border-bottom-right-radius: 3px; border-bottom-left-radius: 3px; } .panel-default { border-color: rgb(221, 221, 221); } .panel-default > .panel-heading { color: rgb(51, 51, 51); background-color: rgb(245, 245, 245); border-color: rgb(221, 221, 221); } @media screen and (min-width: 768px) { } @media screen and (min-width: 768px) { }</style>


</head>

<body>
<!--#INCLUDE VIRTUAL="TopNavInclude.asp"-->


	<div class="panel panel-default" style="width:500px;">

		<div class="panel-heading">
			<h4 class="panel-title">SORRY</h4>
		</div>

		<div class="panel-body">
			Only season subscriptions can be purchased at this time through the website.
			<br>
			<br>	
			A season subscription requires 1 ticket to <%=SeriesCount%> different productions.
			<br>
			<br>							
			<% If DisplayProductions Then %>
			Qualifying productions include:
			<br>
			<%
			SQLSeriesList = "SELECT DISTINCT Act FROM Act WITH (NOLOCK) INNER JOIN event (NOLOCK) on act.actcode = event.actcode WHERE event.surveynumber = " & SurveyNumber & ""
			Set rsSeriesList = OBJdbConnection.Execute(SQLSeriesList)

			If NOT rsSeriesList.EOF Then

				Do Until rsSeriesList.EOF
					%>
					<b><%=rsSeriesList("Act")%></b><br>
					<%
				rsSeriesList.MoveNext	
				Loop

			End If

			rsSeriesList.Close
			Set rsSeriesList = nothing
			
			End If
			%>     
			<br>	
			<% If DisplayExpirationDate Then %>
				Single tickets will go on sale <%=ExpirationDate%>.<BR>
			<% End If %>
			<br>
			If you are a member of the Comprimario Society wishing to purchase SINGLE TICKETS please call the UAO Box Office at 314-361-2881 during business hours to complete your purchase.			
		</div>

		<div class="panel-footer">
			<%
			If Session("UserNumber") = "" Then
				Response.Write "<FORM ACTION=""/ShoppingCart.asp"" METHOD=""POST"" id=form1 name=form1>" & vbCrLf
			Else
				Response.Write "<FORM ACTION=""/Management/ShoppingCart.asp"" METHOD=""POST"" id=form1 name=form1>" & vbCrLf
			End If

			Response.Write "<button TYPE=""submit"" class=""btn btn-default"">Return to Shopping Cart</button></FORM>" & vbCrLf
			
			%>
		</div>
	  
	</div>

<!--#INCLUDE virtual="FooterInclude.asp"-->
</body>

</html>


<%

End Sub 'CongratulationsPageNewSubscription

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