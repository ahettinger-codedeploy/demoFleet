<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<!--#INCLUDE VIRTUAL="CalcCustomerFeeInclude.asp"-->

<%

Page = "Survey"
SurveyNumber = 922
SurveyName = "TableSurvey.asp"

'ErrorLog("Line Number 0")

'========================================


'Survey counts the number of seats at each table.
'Requires that patron purchase all seats within a table. 

SectionList = "M9,M10,M11,M12,M13,F1,F8" 'Event Section to exclude

'========================================

	Session.Timeout = 60
	Server.ScriptTimeout = 3600

	'Verify OrganizationNumber
	If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then 
		OBJdbConnection.Close
		Set OBJdbConnection = nothing
		Response.Redirect("/Management/Default.asp")
	End If

	'Verify User
	If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then 
		OBJdbConnection.Close
		Set OBJdbConnection = nothing
		Response.Redirect("/Management/Default.asp")
	End If
	
'-----------------------------------------------

If Clean(Request("FormName")) = "Continue" Then
    Call Continue
Else
    Call TableCheck
End If

'-----------------------------------------------

Sub TableCheck

ErrorLog("Line Number 1")

SQLOrderSeats = "SELECT Seat.EventCode, Section.Section, Seat.SectionCode, COUNT(OrderLine.ItemNumber) AS OrderSeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber")	& " AND Section.SectionCode NOT IN ('" & SectionList & "') AND OrderLine.ItemType IN ('SubFixedEvent', 'SubSeat', 'Seat') GROUP BY Seat.EventCode, Seat.SectionCode, Section.Section"
Set rsOrderSeats = OBJdbConnection.Execute(SQLOrderSeats)

Do Until rsOrderSeats.EOF

ErrorLog("Line Number =2")

	SQLSectionSeats = "SELECT COUNT(ItemNumber) AS SectionSeatCount FROM Seat (NOLOCK) WHERE EventCode = " & rsOrderSeats("EventCode") & " AND SectionCode = '" & rsOrderSeats("SectionCode") & "'"
	Set rsSectionSeats = OBJdbConnection.Execute(SQLSectionSeats)
	
	    OrderSection = rsOrderSeats("Section")
	    OrderSectionCode = rsOrderSeats("SectionCode")
	    OrderEventCode = rsOrderSeats("EventCode")	
	    OrderSeatCount = rsOrderSeats("OrderSeatCount")
	    SectionSeatCount = rsSectionSeats("SectionSeatCount")
	    
	    ErrorLog("Line Number =3")


	    If OrderSeatCount < SectionSeatCount Then 'Not all seats were selected.  Go to warning page	
		    rsSectionSeats.Close
		    Set rsSectionSeats = nothing		
		    Call WarningPage(OrderSeatCount, SectionSeatCount, OrderSection, OrderEventCode, OrderSectionCode)		
		    Exit Sub
		Else
		    Call Continue	
		    Exit Sub		
	    End If
				
	rsSectionSeats.Close
	Set rsSectionSeats = nothing
	
	rsOrderSeats.MoveNext

Loop
		
rsOrderSeats.Close
Set rsOrderSeats = nothing

OBJdbConnection.Close
Set OBJdbConnection = nothing

Call Continue

End Sub	
				
'=================================

Sub WarningPage(OrderSeatCount, SectionSeatCount, OrderSection, OrderEventCode, OrderSectionCode)

If DocType <> "" Then
	Response.Write DocType
Else
	Response.Write "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
End If

RemainingSeatCount = (SectionSeatCount - OrderSeatCount)

If OrderSeatCount = 1 Then
	 s1 = ""
Else
	 s1 = "s"
End If

If RemainingSeatCount = 1 Then
    RemainingSeatCount = ""
	s2 = ""
Else
	 s2 = "s"
End If


%>

<html>
<head>
<title><%= title %></title>
<link href="https://maxcdn.bootstrapcdn.com/bootswatch/3.3.5/paper/bootstrap.min.css" rel="stylesheet">
<link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css" rel="stylesheet">
<style type="text/css">
	
/* =====================
   RESET/CLEAR LINKS 
   ===================== */

/* links: remove all outlines and underscores */ 

a,     		
a:active,	
a:focus, 
a:hover,

a.btn,     		
a.btn:active,	
a.btn:focus, 
a.btn:hover,

button.btn,     		
button.btn:active,	
button.btn:focus, 
button.btn:hover,

.dropdown-menu li a,
.dropdown-menu li a:active,
.dropdown-menu li a:focus,
.dropdown-menu li a:hover,

.nav-pills li a,
.nav-pills li a:active,
.nav-pills li a:focus,
.nav-pills li a:hover,

.nav-tabs li a,
.nav-tabs li a:active,
.nav-tabs li a:focus,
.nav-tabs li a:hover

ul.nav-tabs li a,
ul.nav-tabs li a.active,
ul.nav-tabs li a.focus { outline:0px !important; -webkit-appearance:none;  text-decoration:none;}  


/* form input: remove blue glow */ 
.form-control,
.form-control:focus 
{
box-shadow: none;
border-width: 1px;
transition: border-color 0.15s ease-in-out 0s;
}

a.btn.btn-large.btn-default span.fa
{
padding-top: 5px;
}

/* set font style */ 

body,
.panel,
.nav
{
font-size: 14px;
color: #666666;
}

</style>
<head>

</head>

<%= strBody %>

<!--header-->
	<!-- #INCLUDE VIRTUAL="TopNavInclude.asp" -->
<!--header-->

<section class="container">
	
	<div class="row">
		<div class="col-md-8 col-md-offset-1">
    		<div class="panel panel-default">
			  	<div class="panel-body">

					<h3>SORRY</H3>
					You have only selected <b><%= OrderSeatCount %> seat<%=s1%></b> at <%= OrderSection %>.<BR>
					<br>
					In order to complete  your transaction please add the remaining <b><%= RemainingSeatCount %> seat<%=s2%></b>  at <%= OrderSection %> <BR>
					by clicking the 'Add Additional Seats' button.<br>
					<br>
					If you do not want to purchase these additional seats,<BR>
					click 'Shopping Cart" to remove this seat from your order.<br>
					<br>
					
					<%
					If Session("UserNumber") = "" Then 'Internet order
					%> 
					
						<ul class="list-inline">
							<li>
								<a class="btn btn-large btn-default" href="/Section.asp?Event=<%= OrderEventCode %>&Section=<%= OrderSectionCode %>&Details=NO">
									<span class="fa fa-plus-circle"></span>
									<span class="nav-label">&nbsp;Add Additional Seats</span>
								</a>
							</li>
							<li>
								<a class="btn btn-large btn-default" href="/ShoppingCart.asp">
									<span class="fa fa-shopping-cart"></span>
									<span class="nav-label">&nbsp;Shopping Cart</span>
								</a>
							</li>
						</ul>

					<%
					Else 'Box Office Order
					%> 
					
						<ul class="list-inline">
							<li>
								<a class="btn btn-large btn-default" href="/Management/SectionRowSelect.asp?Event=<%= OrderEventCode %>&Section=<%= OrderSectionCode %>&Details=NO">
									<span class="fa fa-plus-circle"></span>
									<span class="nav-label">&nbsp;Add Additional Seats</span>
								</a>
							</li>
							<li>
								<a class="btn btn-large btn-default" href="/Management/ShoppingCart.asp" >
									<span class="fa fa-shopping-cart"></span>
									<span class="nav-label">&nbsp;Shopping Cart</span>
								</a>
							</li>
						</ul>
					
					<%
					End If
					%> 

				</div>
			</div>
		</div>
	</div>
	
	
</section>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>
</html>

<%		
	
End Sub 'Warning Page

'========================================

Sub Continue

Session("SurveyComplete") = Session("OrderNumber")

If Session("OrderTypeNumber") = 1 Then
	Response.Redirect("/Ship.asp")
Else
	Response.Redirect("/Management/AdvanceShip.asp")
End If

End Sub 'Continue

'========================================

%> 
