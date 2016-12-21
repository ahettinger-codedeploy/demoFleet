<% 

'CHANGE LOG
'JAI 04/29/14 - 2015 Renewal Emails
'SSR 06/18/14 - 2015 Renewal Reminder Emails
'SSR 07/17/14 - Updated for use with Road Company

%>

<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp"-->
<!--#INCLUDE VIRTUAL="TicketPrintInclude.asp"-->
<!--#INCLUDE VIRTUAL="NoCacheInclude.asp"-->

<%

'-----------------------------------

'Organization Variables

MsgOrgName = GetOrgName(Session("OrganizationNumber"))
PrivateLabel =  GetPrivateLabel(Session("OrganizationNumber"))
MsgRenewalURL = "http://" & PrivateLabel & ".tix.com/renew.aspx"
MsgLogoPath = "http://www.tix.com/images/clear.gif"
MsgFontFace = "'Times New Roman', Times, serif"

'-----------------------------------

Server.ScriptTimeout = 600

'REE 4/15/2 - Increased Session Timeout to 30 minutes to reduce Print validation timeout issues.
Session.Timeout = 60

Page = "ManagementMenu"

'Make sure the correct Session variables are in place.  If not clear the variables and go to the menu.
If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then 
	Session.Abandon
	Response.Redirect("Default.asp")
End If

If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then 
	Session.Abandon
	Response.Redirect("Default.asp")
End If

'Decide which subroutine to route to
Select Case Request("FormName")
	Case "PrintMenu"
		Call PrintLetters
	Case Else
		Call PrintMenu
End Select

'-----------------------------------

Sub PrintMenu

%>
<html>

<head>

	<title>TIX - Ticket Sales</title>
	<!-- Force IE to turn off past version compatibility mode and use current version mode -->
	<meta http-equiv="X-UA-Compatible" content="IE=edge;chrome=1">
	<!-- Get the width of the users display-->
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<!-- Text encoded as UTF-8 -->
	<meta http-equiv="Content-Type"  content="text/html; charset=utf-8">
	
	<link href="https://netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.min.css" rel="stylesheet"  media="screen">
	<link href="https://netdna.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.css" rel="stylesheet">

	<style>

	/* outline and underscore - nasty things I hate 'em*/

	a.btn  			{outline:0px !important; -webkit-appearance:none;   text-decoration:none;} 
	a.btn:active	{outline:0px !important; -webkit-appearance:none;   text-decoration:none;} 
	a.btn:focus  	{outline:0px !important; -webkit-appearance:none;   text-decoration:none;}

	button.btn:active {outline:0px !important; -webkit-appearance:none;   text-decoration:none; }
	button.btn:focus  {outline:0px !important; -webkit-appearance:none;   text-decoration:none; }

	button.btn:active {outline:0px !important; -webkit-appearance:none;   text-decoration:none; }
	button.btn:focus  {outline:0px !important; -webkit-appearance:none;  text-decoration:none; }
	 
	ul.dropdown-menu li a:active {outline:0px !important; -webkit-appearance:none;  text-decoration:none; }
	ul.dropdown-menu li a:focus  {outline:0px !important; -webkit-appearance:none;  text-decoration:none; }

	ul.nav-tabs li a:active  {outline:0px !important; -webkit-appearance:none;  text-decoration:none;}
	ul.nav-tabs li a:focus 	 {outline:0px !important; -webkit-appearance:none;  text-decoration:none;}

	.nav-tabs > li.active > a,
	.nav-tabs > li > a { color: #333333; text-decoration: none;}

	/* inactive tabs */
	.nav-tabs > li > a { border: 1px solid #DDDDDD; color: #999999;}

	.nav > li > a:hover, 
	.nav > li > a:focus { border:1px solid #DDDDDD; color:#777777;}

	/* body border */
	.tab-content { border: 1px solid #DDDDDD; border-radius: 0px 6px 6px 6px; padding:20px;}
	.nav-tabs { border-bottom: 0px;}

	/* table */
	div.TixManagementContent table.table tbody tr th { background-color: rgb(102, 102, 102); color: #ffffff; text-align: center; }
	
	.btn-default
	{
	color: #222222;
	border-color: #222222;
	}

	.btn-outline 
	{
	background-color: transparent;
	color: inherit;
	border-width: 2px;
	-webkit-transition: all 0.75s;
	-moz-transition: all 0.75s;
	transition: all 0.75s;
	}

	.btn-default.btn-outline:hover
	{
	color: #666666;
	}

	.table-fade
	{
	opacity: 0;
	}

	</style>
		
</head>

<body>
<!--#INCLUDE VIRTUAL="TopNavInclude.asp"-->

<div id="wrapper" class="row">
	<div class="col-lg-12">

		<ul class="nav nav-tabs">
		
			<li id="Letters" class="active">	
				<a href="LogLetters.asp">
					<i class="fa fa-print fa-lg"></i>
					Letters
				</a>
			</li>
			
			<% 
			If CheckTixUser(Session("UserNumber")) Then
			%>
			<li id="Emails">		
				<a href="RenewalEmail.asp">
					<i class="fa fa-paper-plane fa-lg"></i>
					Emails
				</a>
			</li>
			<% 
			End If 
			%>
			
		</ul>
		
		<div class="tab-content" style="padding:10px;">
		
			<FONT FACE="verdana,arial,helvetica" COLOR="#008400"><H4><%=MsgOrgName%><BR></FONT>
			<FONT FACE="verdana,arial,helvetica" COLOR="#008400">Renewal Letters</H4></FONT>
			<BR>			
			<BR>
			<BR>
				<%

				'Get Matching Events
				'REE 4/6/2 - Modified to include OrganizationAct selection criteria
				'REE 2/25/3 - Removed TicketFormat from criteria.
				SQLEvents = "SELECT Event.EventCode FROM Event (NOLOCK) INNER JOIN Venue ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber WHERE Organization.OrganizationNumber = " & Session("OrganizationNumber") & " AND EventDate > GETDATE() ORDER BY EventDate"
				Set rsEvents = OBJdbConnection.Execute(SQLEvents)

				EventList = ""
				If Not rsEvents.EOF Then
					EventList = "("
					Do Until rsEvents.EOF
						EventList = EventList & rsEvents("EventCode") & "," 
						rsEvents.MoveNext
					Loop
					EventList = Left(EventList,len(EventList)-1) & ")"
				End If

				If EventList <> "" Then
					'REE 2/25/3 - Removed TicketFormat from criteria.
					SQLTickets = "SELECT COUNT(OrderLine.ItemNumber) AS TicketCount, Act.Act, EventDate, Event.EventCode, Venue FROM Event (NOLOCK) INNER JOIN Seat ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Shipping ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN Act ON Event.ActCode = Act.ActCode INNER JOIN Venue ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber INNER JOIN OrganizationAct ON Event.ActCode = OrganizationAct.ActCode WHERE Event.EventCode IN " & EventList & " AND EventDate > GETDATE() AND OrderLine.StatusCode = 'R' AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') GROUP BY Event.EventCode, EventDate, Act.Act, Venue.Venue ORDER BY EventDate, Act.Act"
					Set rsTickets = OBJdbConnection.Execute(SQLTickets)
					
					'REE 4/6/2 - Modified to check for events.
					If Not rsTickets.EOF Then 'There are some events.  List them
						Response.Write "<FORM ACTION=""RenewalLetters.asp"" METHOD=""post""><INPUT TYPE=""hidden"" NAME=""FormName"" VALUE=""PrintMenu"">" & vbCrLf

						Response.Write "<TABLE BORDERCOLOR=""red"" border=1 class=""table table-striped table-bordered table-fade"">" & vbCrLf
						Response.Write "<TR><TH>Print</TH><TH style=""text-align:left"">Subscription</TH><TH style=""text-align:left"">Venue</TH><TH>Date/Time</TH><TH>Quantity</TH></TR>" & vbCrLf

						'Display Event and UnPrinted Ticket Quantities
						Do Until rsTickets.EOF

							Response.Write "<TR BGCOLOR=""DDDDDD""><TD ALIGN=""center""><INPUT TYPE=""checkbox"" NAME=""EventCode"" VALUE=" & rsTickets("EventCode") & "></FONT></TD><TD><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">" & rsTickets("Act") & "</FONT></TD><TD><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">" & rsTickets("Venue") & "</FONT></TD><TD ALIGN=""center"" NOWRAP><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">" & DateAndTimeFormat(rsTickets("EventDate")) & "</FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">" & rsTickets("TicketCount") & "</FONT></TD></TR>" & vbCrLf

							rsTickets.MoveNext

						Loop
							
						Response.Write "</TABLE><BR>" & vbCrLf
						'Display Buttons to Print
						Response.Write "<FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">Select events to print and click below.</FONT><BR><BR>" & vbCrLf
						Response.Write "<INPUT TYPE=""submit"" CLASS=""btn btn-outline btn-default"" VALUE=""Submit""></FORM>" & vbCrLf
					Else 'There aren't any matching events
						Response.Write "<BR><BR><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">There are no events to be printed.</FONT><BR><BR>" & vbCrLf
					End If
				Else 'There aren't any matching events
					Response.Write "<BR><BR><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">There are no events to be printed.</FONT><BR><BR>" & vbCrLf
				End If
				%>
			
		</div>

	</div>
	
</div>

</body>

<!--#INCLUDE VIRTUAL="FooterInclude.asp"-->

<script src="http://code.jquery.com/jquery-1.9.1.js" type="text/javascript" ></script>
<script src="https://netdna.bootstrapcdn.com/bootstrap/3.1.0/js/bootstrap.min.js"></script>
<script type="text/javascript">
$(".table-fade").delay(175).animate({"opacity": "1"}, 400);
</script>

</html>

<%

End Sub 'PrintMenu

'---------------------------------

Sub PrintLetters

'Server.ScriptTimeout = 600

%>

<HTML>
<HEAD>
<TITLE>www.TIX.com - Subscription Renewal Letters</TITLE>
<SCRIPT LANGUAGE="JavaScript">
<!-- Begin
	function PrintLetters(){
		window.print(); 
		}

//  End -->
</SCRIPT>
</HEAD>
<BODY onLoad="PrintLetters()" LEFTMARGIN="0" RIGHTMARGIN="0" TOPMARGIN="0" MARGINHEIGHT="0" MARGINWIDTH="0">

<STYLE>	
	div {page-break-before: always}
</STYLE>

<FONT COLOR="#000000">
<%

'Build the Query to select each of the selected events
'REE 7/7/3 - Removed EventShip from Query.
SQLOrderLine = "SELECT OrderHeader.OrderTypeNumber, OrderHeader.OrderSurcharge, OrderHeader.ShipFee, OrderHeader.Total, OrderLine.OrderNumber, OrderLine.LineNumber, OrderLine.ItemNumber, OrderLine.Price, OrderLine.Surcharge, OrderLine.Discount, OrderLine.ShipCode, Event.EventCode, Event.EventDate, Event.Map, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, PostalCode, Customer.DayPhone, Customer.NightPhone, Customer.EMailAddress, Shipping.ShipType, Act.Act, Venue.Venue, SeatType.SeatType, Seat.Row, Seat.Seat, Seat.SectionCode, Section.Section FROM OrderLine INNER JOIN OrderHeader ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN Seat ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event ON Seat.EventCode = Event.EventCode INNER JOIN Section ON Seat.SectionCode = Section.SectionCode AND Event.EventCode = Section.EventCode INNER JOIN Act ON Event.ActCode = Act.ActCode INNER JOIN Venue ON Event.VenueCode = Venue.VenueCode INNER JOIN SeatType ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN Shipping ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct ON Event.ActCode = OrganizationAct.ActCode "
SQLWhere = SQLWhere & " WHERE Event.EventCode IN (" & Clean(Request("EventCode"))

'Get the Info to Print
'REE 4/6/2 - Modified to use OrganizationAct in selection criteria
'REE 8/1/5 - Added OrderNumbers for 2 orders.

SQLOrderLine = SQLOrderLine & SQLWhere & ") AND OrderLine.StatusCode = 'R' AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent')" & LetterRange & " ORDER BY OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.OrderNumber, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry, OrderLine.ShipCode, Seat.EventCode, Seat.SectionCode, RowSort, SeatSort DESC"
Set rsOrderLine = OBJdbConnection.Execute(SQLOrderLine)
		
Do Until rsOrderLine.EOF ' Or LetterCount >= 1

	If rsOrderLine("OrderNumber") <> LastOrderNumber Then 
	'This is not the last order.
	
		'Print the footer
		If TicketCount > 0 Then 
		

			
			If LastShipFee <> 0 And LastOrderTypeNumber <> 5 Then
			End If

			SQLTender = "SELECT SUM(Tender.Amount) AS TenderAmount FROM Tender (NOLOCK) WHERE Tender.OrderNumber = " & LastOrderNumber
			Set rsTender = OBJdbConnection.Execute(SQLTender)
		
			If IsNull(rsTender("TenderAmount")) Then
				LastTender = 0
			Else
				LastTender = rsTender("TenderAmount")
			End If
		
			rsTender.Close
			Set rsTender = nothing	


			If LastTender <> 0 Then
		End If
			
			If LastShipFee = 0 And LastOrderTypeNumber <> 5 Then
			End If
			
			Response.Write "</TABLE><BR>" & vbCrLf
			

			

			

			
			LetterCount = LetterCount + 1

            If LetterCount Mod 100 = 0 Then
                Response.Flush
            End If

		End If
				
		SQLCustInfo = "SELECT Customer.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry, OrderLine.Price - OrderLine.Discount AS NetPrice FROM OrderHeader (NOLOCK) INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber WHERE OrderHeader.OrderNumber = " & rsOrderLine("OrderNumber") & " AND OrderLine.LineNumber = " & rsOrderLine("LineNumber") & " ORDER BY OrderLine.Price - OrderLine.Discount DESC"
		Set rsCustInfo = OBJdbConnection.Execute(SQLCustInfo)
		
		Response.Write "<TABLE WIDTH=""750"" cellpadding=""0"" cellspacing=""0""  border=""0"">" & vbCrLf

		If Not rsCustInfo.EOF Then


			
			'Shipping and Billing Address
			
		
			Response.Write "<TR>" & vbCrLf
			Response.Write "<TD WIDTH=""400""><FONT FACE=""" & MsgFontFace & """><B>Shipping Information</B></TD>" & vbCrLf

			
			Response.Write "<FONT FACE=""" & MsgFontFace & """>" & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & "<BR>" & rsCustInfo("ShipAddress1") & "<BR>" & vbCrLf
			
			'-----------------------------------------
			
			'Order Number and Renewal Number
			
			Response.Write "<TD ALIGN=""left"">" & vbCrLf
			Response.Write "<FONT FACE=""" & MsgFontFace & """><B>Order Number:</B>&nbsp;" & rsOrderLine("OrderNumber") & "" & vbCrLf
			Response.Write "</TD>" & vbCrLf
			Response.Write "<TD ALIGN=""right"">" & vbCrLf
			SQLItemNumber = "SELECT ItemNumber FROM OrderLine (NOLOCK) WHERE OrderNumber = " & rsOrderLine("OrderNumber") & " ORDER BY ItemNumber"
			Set rsItemNumber = OBJdbConnection.Execute(SQLItemNumber)
			RenewalCode = rsCustInfo("CustomerNumber") & rsItemNumber("ItemNumber")
			rsItemNumber.Close
			Set rsItemNumber = nothing
			Response.Write "<B>Renewal Code:</B>&nbsp;" & RenewalCode & "" & vbCrLf
			Response.Write "</TD>" & vbCrLf

			
			'-----------------------------------------

		Else

			ErrorLog("Invoice Format - Order Number = " & Clean(Request("OrderNumber")) & " | Line Number = " & Clean(Request("LineNumber")))

		End If

		rsCustInfo.Close
		Set rsCustInfo = nothing

		LastEventCode = 0
		LastOrderNumber = rsOrderLine("OrderNumber")
		LastOrderTypeNumber = rsOrderLine("OrderTypeNumber")
				
		'Update the Footer Totals
		LastOrderSurcharge = rsOrderLine("OrderSurcharge")
		LastShipType = rsOrderLine("ShipType")
		LastShipFee = rsOrderLine("ShipFee")
		LastDiscount = rsOrderLine("Discount")
		LastTotal = rsOrderLine("Total")
		

		
		TicketCount = TicketCount + 1

	End If

	'Print Event Info and Column Headings if this is a new Event
	If LastEventCode <> rsOrderLine("EventCode") Or LastOrderNumber <> rsOrderLine("OrderNumber") Then
	
		'-----------------------------------------
			
		'Production Name, Date & Time
		'Order Delivery Method
	

	
		
		'REE 6/5/6 - Modified to look at EventOptions for Date & Time Display Options
		SQLDateSuppress = "SELECT OptionValue AS DateSuppress FROM EventOptions (NOLOCK) WHERE EventCode = " & rsOrderLine("EventCode") & " AND OptionName = 'DateSuppress' AND OptionValue = 'Y'"
		Set rsDateSuppress = OBJdbConnection.Execute(SQLDateSuppress)
		If rsDateSuppress.EOF Then
			Response.Write " on " & FormatDateTime(rsOrderLine("EventDate"),vbShortDate)
		End If
		rsDateSuppress.Close
		Set rsDateSuppress = nothing

		SQLTimeSuppress = "SELECT OptionValue AS TimeSuppress FROM EventOptions (NOLOCK) WHERE EventCode = " & rsOrderLine("EventCode") & " AND OptionName = 'TimeSuppress' AND OptionValue = 'Y'"
		Set rsTimeSuppress = OBJdbConnection.Execute(SQLTimeSuppress)
		If rsTimeSuppress.EOF Then
			Response.Write " at " & Left(FormatDateTime(rsOrderLine("EventDate"),vbLongTime),Len(FormatDateTime(rsOrderLine("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsOrderLine("EventDate"),vbLongTime),3)
		End If
		rsTimeSuppress.Close
		Set rsTimeSuppress = nothing

		
		'-----------------------------------------
					
		'Seat Location, Price, Service Fee

		'Calculate Number of Columns
		SQLNumColumns = "SELECT SUM(OrderLine.Surcharge) AS ServiceFee, SUM(OrderLine.Discount) AS Discount FROM OrderLine WHERE OrderNumber = " & rsOrderLine("OrderNumber") & " AND ItemType IN ('Seat', 'SubFixedEvent')"
		Set rsNumColumns = OBJdbConnection.Execute(SQLNumColumns)

		NumColumns = 6

		FacilityCharge = 0
		If FacilityCharge <> 0 Then
			NumColumns = NumColumns + 1
			ColumnHeading = ""
			ColFacilityCharge = "Y"
		End If
		If rsNumColumns("ServiceFee") <> 0 Then
			NumColumns = NumColumns + 1
			ColumnHeading = ""
			ColServiceFee = "Y"
		End If
		If rsNumColumns("Discount") <> 0 Then
			NumColumns = NumColumns + 1
			ColumnHeading = ""
			ColDiscount = "Y"
		End If

		rsNumColumns.Close
		Set rsNumColumns = nothing

		ColumnHeading = ""
		
		Response.Write ColumnHeading

		LastEventCode = rsOrderLine("EventCode")
		
		'-----------------------------------------
		
	End If
	
	'-----------------------------------------
		
	'Facility Charge, Surcharge, Discount, Price
	
	LineDetail = ""
	
	If ColFacilityCharge = "Y" Then
		LineDetail = ""
	End If
	
	If ColServiceFee = "Y" Then
		LineDetail = ""
	End If
	
	If ColDiscount = "Y" Then
		LineDetail = ""
	End If
	
	LineDetail = ""
	
	Response.Write LineDetail

	LastOrderNumber = rsOrderLine("OrderNumber")
	
	'-----------------------------------------
	
rsOrderLine.MoveNext	
Loop	

	
	
If TicketCount > 0 Then	'Print the last footer

	Response.Write ""
	
	If LastShipFee <> 0 And LastOrderTypeNumber <> 5 Then

	End If

	SQLTender = "SELECT SUM(Tender.Amount) AS TenderAmount FROM Tender (NOLOCK) WHERE Tender.OrderNumber = " & LastOrderNumber
	Set rsTender = OBJdbConnection.Execute(SQLTender)
		If IsNull(rsTender("TenderAmount")) Then
			LastTender = 0
		Else
			LastTender = rsTender("TenderAmount")

		End If
	rsTender.Close
	Set rsTender = nothing	

	If LastTender <> 0 Then
	End If

	

	

			
End If

rsOrderLine.Close
Set rsOrderLine = nothing

%>
</FONT>
</BODY>
</HTML>

<%

End Sub 'PrintLetters

'-------------------------------------------------

PUBLIC FUNCTION  PCase(str) 

strOut = "" 
boolUp = True 	
aLen =  Len(str)  

If len(aLen) > 0 Then 

	For i = 1 To Len(str) 

		c = Mid(str, i, 1)

		If c = " " or c = "'" or c = "-"  then 
			strOut = strOut & c 
			boolUp = True 
		Else 
			If boolUp Then 
				tc = Ucase(c) 
			Else 
				tc = LCase(c) 
			End If 
			strOut = strOut & tc 
			boolUp = False 
		End If 

	Next 

End If

PCase = strOut 

END FUNCTION

'-------------------------------------------------

PUBLIC FUNCTION GetPrivateLabel(OrgNumbr)

	DIM strTemp

	SQLVenueRefCheck = "SELECT VenueCode, OptionName, OptionValue FROM VenueOptions WITH (NOLOCK) WHERE VenueCode = (SELECT VenueCode FROM VenueOptions (NOLOCK) WHERE OptionName = 'OrganizationNumber' AND OptionValue = '" & OrgNumbr & "') AND (OptionName = 'VenueReference')"
	Set rsVenueRefCheck = OBJdbConnection.Execute(SQLVenueRefCheck)
		strTemp = rsVenueRefCheck("OptionValue")
	rsVenueRefCheck.Close
	Set rsVenueRefCheck = nothing
	
	GetPrivateLabel = strTemp

	
END FUNCTION
	
'-------------------------------------------------

PUBLIC FUNCTION GetOrgName(OrgNumber)

SQLThisOrg = "Select  Organization  FROM Organization (NOLOCK) WHERE OrganizationNumber = " &  Session("OrganizationNumber") & ""
Set rsThisOrg = OBJdbConnection.Execute(SQLThisOrg)
	OrgName = rsThisOrg("Organization") 
rsThisOrg.Close
Set rsThisOrg = Nothing

GetOrgName = OrgName

END FUNCTION

'-------------------------------------------------

PUBLIC FUNCTION CheckTixUser(UserNumber)

Dim strResult
strResult = FALSE

SQLOrgUsers = "Select UserNumber FROM Users (NOLOCK) WHERE OrganizationNumber = 1 AND UserNumber = " & Session("UserNumber") & ""
Set rsOrgUsers = OBJdbConnection.Execute(SQLOrgUsers)

	If NOT rsOrgUsers.EOF Then
		strResult = TRUE
	End If
	
rsOrgUsers.Close
Set rsOrgUsers = Nothing

CheckTixUser = strResult

END FUNCTION

'-------------------------------------------------

PUBLIC FUNCTION InsertTemplate(templateFile,templateName)

'Insert HTML content

Dim  strText
strText = ""

Dim strNewText
strNewText = ""


	Const ForReading = 1

	Set objFSO = CreateObject("Scripting.FileSystemObject")
	
	templatePath = Server.MapPath(templateFile)

	If objFSO.FileExists(templatePath) Then

		Set objFile = objFSO.OpenTextFile(templatePath, ForReading)

		strContents = objFile.ReadAll
		objFile.Close

		strStartText = "[" & templatename & "]"
		strEndText = "[/" & templatename & "]"

		intStart = InStr(strContents, strStartText)
		intStart = intStart + Len(strStartText)

		intEnd = InStr(strContents, strEndText)

		intCharacters = intEnd - intStart

		strText = Mid(strContents, intStart, intCharacters)
		
		'Replace
		strNewText = replaceVar(strText)
		
		'Clean
		strNewText = cleanBOM(strNewText)

	End If
	
	InsertTemplate = strNewText
			
END FUNCTION

'-------------------------------------------------

PUBLIC FUNCTION cleanBOM(strText)

	'remove BOM if present http://unicode.org/faq/utf_bom.html

	If (Len(Trim(strText)) > 0) Then
	
		Dim AscValue : AscValue = Asc(Trim(strText))
	  
		If ((AscValue = -15441) Or (AscValue = 239)) Then : strText = Mid(Trim(strText),4) : End If
	  
	End If
	
	cleanBOM = strText
	
END FUNCTION 

'-------------------------------------------------

PUBLIC FUNCTION replaceVar(strText)

		'replace placeholders with actual text

		DIM strNewText

		strNewText = Replace(strText, 	 "[recipientFName]", recipientFName)
		strNewText = Replace(strNewText, "[webSite]", webSite)
		strNewText = Replace(strNewText, "[orgNumber]", orgNumber)
		strNewText = Replace(strNewText, "[senderFName]", senderFName)
		strNewText = Replace(strNewText, "[senderLName]", senderLName)
		strNewText = Replace(strNewText, "[senderAddress]", senderAddress)
		strNewText = Replace(strNewText, "[OrgName]", GetOrgName(Session("OrganizationNumber")))
		strNewText = Replace(strNewText, "[MsgRenewalURL]",MsgRenewalURL)
		strNewText = Replace(strNewText, "[ServerName]",Request.ServerVariables("server_name"))
		
		replaceVar = strNewText
		
END FUNCTION 

'-------------------------------------------------

%>