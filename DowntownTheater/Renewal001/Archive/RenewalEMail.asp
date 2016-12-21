<% 

'CHANGE LOG
'SLM 3/6/14 - New King Lear
'JAI 3/11/14 - Corrected formatting if multiple events, and some formatting updates.  Use this as the base template going forward.
'SLM 3/12/14 - New King Lear using revised format
'SSR 6/09/14 - Updated for The Nance

%>

<!--METADATA TYPE="typelib" UUID="CD000000-8B95-11D1-82DB-00C04FB1625D"  NAME="CDO for Windows 2000 Library" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp"-->
<!--#INCLUDE VIRTUAL="TicketPrintInclude.asp"-->
<!--#INCLUDE VIRTUAL="NoCacheInclude.asp"-->

<!--#INCLUDE FILE="RenewalLetterInclude_Body.asp"--> 
<!--#INCLUDE FILE="RenewalLetterInclude_Signature.asp"--> 

<%

'---------------------------------------

'REE 4/15/2 - Increased Session Timeout to 30 minutes to reduce Print validation timeout issues.
Session.Timeout = 60
Server.ScriptTimeout = 3600

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

'-----------------------------------

'Organization Variables
MsgOrgName = "Rialto Cinemas Elmwood"
MsgRenewalURL = "http://RialtoCinemasCerrito.tix.com/renew.aspx"
MsgLogoPath = "http://www.tix.com/Clients/RialtoCinemasCerrito/Renewal/CerritoLogo.jpg"
MsgFontFace = "arial,helvetica"


'JAI 6/24/9 - Specify organization ReplyTo e-mail address and the e-mail subject
EMailReplyTo = "tickets@rialtocinemas.com"
EMailSubject = "Special Offer - The Nance"


TestOrderCount =  10
TestEMailAddress = "testtix@yahoo.com"
'TestEMailAddress = "silvia@tix.com;sergio@tix.com;robert@tix.com"
'TestEMailAddress = "joe@tix.com;silvia.mahoney@tix.com;kjb@rialtocinemas.com;Michael@michaelorand.com"
If TestEMailAddress <> "" Then
    EMailSubject = EMailSubject & " [Test Email]"
End If


EMailMessageBody = ""
EMailMessageBody = EMailMessageBody & RenewalLetter_Body
EMailMessageBody = EMailMessageBody & RenewalLetter_Signature


'Decide which subroutine to route to
Select Case Request("FormName")
	Case "PrintMenu"
		Call PrintLetters
	Case Else
		Call PrintMenu
End Select

'----------------------------------

Sub PrintMenu

%>

<HTML>

<HEAD>

	<TITLE>Tix - Subscription Renewal Letters</TITLE>
	<link href="https://netdna.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css" rel="stylesheet">
	<link href="https://netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap.min.css" rel="stylesheet">
	
	<style>
	/* body border */
	.tab-content { border: 1px solid #DDDDDD; border-radius: 0px 6px 6px 6px; padding:20px;}
	.nav-tabs { border-bottom: 0px;}

	/* tabs */
	.nav-tabs > li.active > a,
	.nav-tabs > li > a { color:#282828; text-decoration: none;}

	/* inactive tabs */
	.nav-tabs > li > a { background-color: #F8F8F8 ; border: 1px solid #DDDDDD; color:#787878;}

	/* inactive tabs hover */
	.nav > li > a:hover, 
	.nav > li > a:focus { border:1px solid #DDDDDD; color:#777777;}
	</style>
	
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
	</style>

</HEAD>

<BODY BGCOLOR="#FFFFFF">

<CENTER>

<!--#INCLUDE VIRTUAL="TopNavInclude.asp"-->
<BR>
<BR>

	<div class="tabs">

		<ul class="nav nav-tabs">
			<li>	
				  <a href="RenewalLetters.asp">
				  <i class="fa fa-print"></i>
					Letters
				  </a>
			</li>
			<li class="active">		
				<a href="RenewalEmail.asp">
					<i class="fa fa-paper-plane"></i>
					Emails
				</a>
			</li>
			<li>	
				<a href="emailEditor.asp">
				<i class="fa fa-pencil-square-o"></i>
					Editor
				</a>
			</li>
		</ul>
		
		<div class="tab-content" style="padding:10px;">
			<FONT FACE="verdana,arial,helvetica" COLOR="#008400"><H4 style="color:red;"><%=getOrgName(Session("OrganizationNumber"))%><BR></FONT>
			<FONT FACE="verdana,arial,helvetica" COLOR="#008400">Subscription Renewal Letters</H4></FONT>

			<%

			If TestEMailAddress <> "" Then
				Response.Write "Test Mode.  A test email will be sent to: " & TestEMailAddress & "<BR><BR>Requires " & TestOrderCount & " order for testing." & vbCrLf
			End If

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
				SQLTickets = "SELECT COUNT(OrderLine.ItemNumber) AS TicketCount, Act.Act, EventDate, Event.EventCode, Venue FROM Event (NOLOCK) INNER JOIN Seat ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Shipping ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN Act ON Event.ActCode = Act.ActCode INNER JOIN Venue ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber INNER JOIN OrganizationAct ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber WHERE Event.EventCode IN " & EventList & " AND EventDate > GETDATE() AND OrderLine.StatusCode = 'R' AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') AND Customer.EMailAddress IS NOT NULL AND Customer.EMailAddress <> '' GROUP BY Event.EventCode, EventDate, Act.Act, Venue.Venue ORDER BY EventDate, Act.Act"
				Set rsTickets = OBJdbConnection.Execute(SQLTickets)
				
				'REE 4/6/2 - Modified to check for events.
				If Not rsTickets.EOF Then 'There are some events.  List them
					Response.Write "<FORM ACTION=""RenewalEMail.asp"" METHOD=""post""><INPUT TYPE=""hidden"" NAME=""FormName"" VALUE=""PrintMenu"">" & vbCrLf

					Response.Write "<TABLE class=""table table-striped table-bordered"">" & vbCrLf
					Response.Write "<TR><TH>Print</TH><TH>Subscription</TH><TH>Venue</TH><TH>Date/Time</TH><TH>Quantity</TH></TR>" & vbCrLf
					
					'Display Event and UnPrinted Ticket Quantities
					Do Until rsTickets.EOF

						Response.Write "<TR BGCOLOR=""DDDDDD""><TD><INPUT TYPE=""checkbox"" NAME=""EventCode"" VALUE=" & rsTickets("EventCode") & "></TD><TD>" & rsTickets("Act") & "</TD><TD>" & rsTickets("Venue") & "</TD><TD NOWRAP>" & DateAndTimeFormat(rsTickets("EventDate")) & "</TD><TD>" & rsTickets("TicketCount") & "</TD></TR>" & vbCrLf

						rsTickets.MoveNext

					Loop
						
					Response.Write "</TABLE><BR>" & vbCrLf
					'Display Buttons to Print
					Response.Write "<FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">Select Events to email and click below.</FONT><BR><BR>" & vbCrLf
					Response.Write "<BUTTON TYPE=""submit"">Send Emails</BUTTON>" & vbCrLf
					Response.Write "</FORM>" & vbCrLf
				Else 'There aren't any matching events
					Response.Write "<BR><BR><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">There are no events to be generated.</FONT><BR><BR>" & vbCrLf
				End If
			Else 'There aren't any matching events
				Response.Write "<BR><BR><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">There are no events to be generated.</FONT><BR><BR>" & vbCrLf
			End If

			%>
		</div>

	</div>

</BODY>

<!--#INCLUDE VIRTUAL="FooterInclude.asp"-->

<script src="https://netdna.bootstrapcdn.com/bootstrap/3.1.0/js/bootstrap.min.js"></script>

</HTML>

<%

End Sub 'PrintMenu

'---------------------------------

Sub PrintLetters

'Server.ScriptTimeout = 600

%>

<HTML>
<HEAD>
<TITLE>TIX - Subscription Renewal E-Mail</TITLE>
</HEAD>
<BODY LEFTMARGIN="0" RIGHTMARGIN="0" TOPMARGIN="0" MARGINHEIGHT="0" MARGINWIDTH="0">

<STYLE>	
	div {page-break-before: always}
</STYLE>

<FONT COLOR="#000000">
<%

'Build the Query to select each of the selected events
'REE 7/7/3 - Removed EventShip from Query.
SQLOrderLine = "SELECT OrderHeader.OrderTypeNumber, OrderHeader.OrderSurcharge, OrderHeader.ShipFee, OrderHeader.Total, OrderLine.OrderNumber, OrderLine.LineNumber, OrderLine.ItemNumber, OrderLine.Price, OrderLine.Surcharge, OrderLine.Discount, OrderLine.ShipCode, Event.EventCode, Event.EventDate, Event.Map, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, PostalCode, Customer.DayPhone, Customer.NightPhone, Customer.EMailAddress, Shipping.ShipType, Act.Act, Venue.Venue, SeatType.SeatType, Seat.Row, Seat.Seat, Seat.SectionCode, Section.Section FROM OrderLine INNER JOIN OrderHeader ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN Seat ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event ON Seat.EventCode = Event.EventCode INNER JOIN Section ON Seat.SectionCode = Section.SectionCode AND Event.EventCode = Section.EventCode INNER JOIN Act ON Event.ActCode = Act.ActCode INNER JOIN Venue ON Event.VenueCode = Venue.VenueCode INNER JOIN SeatType ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN Shipping ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN OrganizationVenue ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct ON Event.ActCode = OrganizationAct.ActCode "
For Each Item In Request("EventCode") 'Loop for each Event requested
	EventNumber = EventNumber + 1
	If SQLWhere = "" Then 
		SQLWhere = " WHERE Event.EventCode IN (" & Clean(Request("EventCode"))
	Else
		SQLWhere = SQLWhere & ", " & Clean(Request("EventCode"))
	End If
Next

'Get the Info to Print
'REE 4/6/2 - Modified to use OrganizationAct in selection criteria
SQLOrderLine = SQLOrderLine & SQLWhere & ") AND OrderLine.StatusCode = 'R' AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') AND Customer.EMailAddress IS NOT NULL AND Customer.EMailAddress <> '' AND OrderHeader.OrderNumber > 2082898 ORDER BY OrderLine.OrderNumber, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry, OrderLine.ShipCode, Seat.EventCode, Seat.SectionCode, RowSort, SeatSort DESC"
Set rsOrderLine = OBJdbConnection.Execute(SQLOrderLine)
		
Do Until rsOrderLine.EOF

	If rsOrderLine("OrderNumber") <> LastOrderNumber Then 'It's different.  Print it.
		If TicketCount > 0 Then 'It's not the first one, print the footer.
		
	        EMailMessage = EMailMessage & "</TABLE>" & vbCrLf
	        EMailMessage = EMailMessage & "</CENTER><BR>" & vbCrLf
			EMailMessage = EMailMessage & EMailMessageBody

			'JAI 3/2/5 - Modified to use CDO Mail
			'Create the e-mail server object
			Set objCDOSYSMail = Server.CreateObject("CDO.Message")
			Set objCDOSYSCon = Server.CreateObject ("CDO.Configuration")

			objCDOSYSCon.Fields(cdoSendUsingMethod) = cdoSendUsingPickup 'For localhost
			objCDOSYSCon.Fields.Update

			'Update the CDOSYS Configuration
			Set objCDOSYSMail.Configuration = objCDOSYSCon
			objCDOSYSMail.From = EMailOrganization & " <" & EMailReplyTo & ">" 
			objCDOSYSMail.ReplyTo = EMailReplyTo
			If TestEMailAddress <> "" Then
				LastEMailAddress = TestEMailAddress
			End If
			objCDOSYSMail.To = LastEMailAddress
			objCDOSYSMail.Subject = EMailSubject
			objCDOSYSMail.HTMLBody = EMailMessage
			objCDOSYSMail.Send

			'Close the server mail object
			Set objCDOSYSMail = Nothing
			Set objCDOSYSCon = Nothing 

			EMailMessage = ""
	
			Response.Write LastOrderNumber & " | " & LastEmailAddress & "<BR>" & vbCrLf

			OrderCount = OrderCount + 1
			
			If TestEMailAddress <> "" And OrderCount >= TestOrderCount Then
				Exit Do
			End If

		End If

		SQLCustInfo = "SELECT Customer.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry FROM OrderHeader (NOLOCK) INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber WHERE OrderHeader.OrderNumber = " & rsOrderLine("OrderNumber") & " AND OrderLine.LineNumber = " & rsOrderLine("LineNumber")
		Set rsCustInfo = OBJdbConnection.Execute(SQLCustInfo)

		If Not rsCustInfo.EOF Then
		
			EMailMessage = EMailMessage & "<TABLE><TR><TD WIDTH=""400""><IMG SRC= " & MsgLogoPath & "></TD></TR></TABLE>" & vbCrLf
		
			%>
			<!--#INCLUDE FILE="RenewalLetterInclude_Header.asp"--> 
			<%
			
			EMailMessage = EMailMessage & RenewalLetter_Header
			
			EMailMessage = EMailMessage & "<TABLE CELLPADDING=""3"" WIDTH=""660""><TR><TD WIDTH=10>&nbsp;</TD><TD ALIGN=LEFT><FONT FACE=" & MsgFontFace & "><B>Order Number:&nbsp;" & rsOrderLine("OrderNumber") & "<BR>" & vbCrLf

			SQLItemNumber = "SELECT ItemNumber FROM OrderLine (NOLOCK) WHERE OrderNumber = " & rsOrderLine("OrderNumber") & " ORDER BY ItemNumber"
			Set rsItemNumber = OBJdbConnection.Execute(SQLItemNumber)
			
			RenewalCode = rsCustInfo("CustomerNumber") & rsItemNumber("ItemNumber")
			
			rsItemNumber.Close
			Set rsItemNumber = nothing
			
			EMailMessage = EMailMessage & "Renewal Code:&nbsp;" & RenewalCode & "</B></FONT></TD></TR></TABLE><BR>" & vbCrLf

		Else

			ErrorLog("Invoice Format - Order Number = " & Clean(Request("OrderNumber")) & " | Line Number = " & Clean(Request("LineNumber")))

		End If

		rsCustInfo.Close
		Set rsCustInfo = nothing

		LastEventCode = 0
		LastOrderNumber = rsOrderLine("OrderNumber")
		LastOrderTypeNumber = rsOrderLine("OrderTypeNumber")
		LastEMailAddress = rsOrderLine("EMailAddress")
				
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
        If LastEventCode <> 0 AND LastEventCode <> rsOrderLine("EventCode") Then
		    EMailMessage = EMailMessage & "</TABLE><BR>" & vbCrlf
        End if
		EMailMessage = EMailMessage & "<TABLE><TR><TD WIDTH=10>&nbsp;</TD><TD><FONT FACE=" & MsgFontFace & "><B>" & rsOrderLine("Act") & " at " & rsOrderLine("Venue")
	
		'REE 6/5/6 - Modified to look at EventOptions for Date & Time Display Options
		SQLDateSuppress = "SELECT OptionValue AS DateSuppress FROM EventOptions (NOLOCK) WHERE EventCode = " & rsOrderLine("EventCode") & " AND OptionName = 'DateSuppress' AND OptionValue = 'Y'"
		Set rsDateSuppress = OBJdbConnection.Execute(SQLDateSuppress)
		If rsDateSuppress.EOF Then
			EMailMessage = EMailMessage & " on " & FormatDateTime(rsOrderLine("EventDate"),vbLongDate)
		End If
		rsDateSuppress.Close
		Set rsDateSuppress = nothing

		SQLTimeSuppress = "SELECT OptionValue AS TimeSuppress FROM EventOptions (NOLOCK) WHERE EventCode = " & rsOrderLine("EventCode") & " AND OptionName = 'TimeSuppress' AND OptionValue = 'Y'"
		Set rsTimeSuppress = OBJdbConnection.Execute(SQLTimeSuppress)
		If rsTimeSuppress.EOF Then
			EMailMessage = EMailMessage & " at " & Left(FormatDateTime(rsOrderLine("EventDate"),vbLongTime),Len(FormatDateTime(rsOrderLine("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsOrderLine("EventDate"),vbLongTime),3)
		End If
		rsTimeSuppress.Close
		Set rsTimeSuppress = nothing

		EMailMessage = EMailMessage & "</B><BR>Delivery Method: " & rsOrderLine("ShipType") & "</FONT></TD></TR></TABLE>" & vbCrLf

		'Calculate Number of Columns
		SQLNumColumns = "SELECT SUM(OrderLine.Surcharge) AS ServiceFee, SUM(OrderLine.Discount) AS Discount FROM OrderLine WHERE OrderNumber = " & rsOrderLine("OrderNumber") & " AND ItemType IN ('Seat', 'SubFixedEvent')"
		Set rsNumColumns = OBJdbConnection.Execute(SQLNumColumns)

		NumColumns = 6
		ColumnHeading = "<TABLE WIDTH=""660"" BORDER=""0""><TR><TD WIDTH=10>&nbsp;</TD><TD><FONT FACE=" & MsgFontFace & "><B><U>Section</U></B></FONT></TD><TD ALIGN=center><FONT FACE=" & MsgFontFace & "><B><U>Row</U></B></FONT></TD><TD ALIGN=center><FONT FACE=" & MsgFontFace & "><B><U>Seat</U></B></FONT></TD><TD><FONT FACE=" & MsgFontFace & "><B><U>Type</U></B></FONT></TD><TD ALIGN=right><FONT FACE=" & MsgFontFace & "><B><U>Price</U></B></FONT></TD>"
		
		FacilityCharge = 0
		If FacilityCharge <> 0 Then
			NumColumns = NumColumns + 1
			ColumnHeading = ColumnHeading + "<TD ALIGN=right><FONT FACE=" & MsgFontFace & "><B><U>Facility Charge</U></B></FONT></TD>"
			ColFacilityCharge = "Y"
		End If
		If rsNumColumns("ServiceFee") <> 0 Then
			NumColumns = NumColumns + 1
			ColumnHeading = ColumnHeading + "<TD ALIGN=right><FONT FACE=" & MsgFontFace & "><B><U>Service Fee</U></B></FONT></TD>"
			ColServiceFee = "Y"
		End If
		If rsNumColumns("Discount") <> 0 Then
			NumColumns = NumColumns + 1
			ColumnHeading = ColumnHeading + "<TD ALIGN=right><FONT FACE=" & MsgFontFace & "><B><U>Discount</U></B></FONT></TD>"
			ColDiscount = "Y"
		End If

		rsNumColumns.Close
		Set rsNumColumns = nothing

		ColumnHeading = ColumnHeading + "<TD ALIGN=right><FONT FACE=" & MsgFontFace & "><B><U>Amount</U></B></FONT></TD></TR>" & vbCrLf
		
		EMailMessage = EMailMessage & ColumnHeading

		LastEventCode = rsOrderLine("EventCode")
	End If
			
	'Print the detail
	'Add the OrderNumber and LineNumber to the Form
	LineDetail = "<TR><TD WIDTH=10>&nbsp;</TD><TD><FONT FACE=" & MsgFontFace & ">" & rsOrderLine("Section") & "</FONT></TD><TD ALIGN=center><FONT FACE=" & MsgFontFace & ">" & rsOrderLine("Row") & "</FONT></TD><TD ALIGN=center><FONT FACE=" & MsgFontFace & ">" & rsOrderLine("Seat") & "</FONT></TD><TD><FONT FACE=" & MsgFontFace & ">" & rsOrderLine("SeatType") & "</FONT></TD><TD ALIGN=right><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(rsOrderLine("Price"),2) & "</FONT></TD>"
	
	If ColFacilityCharge = "Y" Then
		LineDetail = LineDetail & "<TD ALIGN=right><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(FacilityCharge,2) & "</FONT></TD>"
	End If
	If ColServiceFee = "Y" Then
		LineDetail = LineDetail & "<TD ALIGN=right><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(rsOrderLine("Surcharge"),2) & "</FONT></TD>"
	End If
	If ColDiscount = "Y" Then
		LineDetail = LineDetail & "<TD ALIGN=right><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(rsOrderLine("Discount"),2) & "</FONT></TD>"
	End If
	
	LineDetail = LineDetail & "<TD ALIGN=right><FONT FACE=" & MsgFontFace & ">" & FormatCurrency(rsOrderLine("Price")+FacilityFee+rsOrderLine("Surcharge")-rsOrderLine("Discount"),2) & "</FONT></TD></TR>" & vbCrLf
	
	EMailMessage = EMailMessage & LineDetail

	LastOrderNumber = rsOrderLine("OrderNumber")
'	
	rsOrderLine.MoveNext
		
Loop	
	
If TicketCount > 0 Then	'Print the last footer

	EMailMessage = EMailMessage & "</TABLE>" & vbCrLf
	EMailMessage = EMailMessage & "</CENTER><BR>" & vbCrLf
	EMailMessage = EMailMessage & EMailMessageBody
	
	If TestEMailAddress = "" Then
		'JAI 3/2/5 - Modified to use CDO Mail
		'Create the e-mail server object
		Set objCDOSYSMail = Server.CreateObject("CDO.Message")
		Set objCDOSYSCon = Server.CreateObject ("CDO.Configuration")

		objCDOSYSCon.Fields(cdoSendUsingMethod) = cdoSendUsingPickup 'For localhost
		objCDOSYSCon.Fields.Update

		'Update the CDOSYS Configuration
		Set objCDOSYSMail.Configuration = objCDOSYSCon
		objCDOSYSMail.From = EMailOrganization & " <" & EMailReplyTo & ">" 
		objCDOSYSMail.ReplyTo = EMailReplyTo
		objCDOSYSMail.To = LastEMailAddress
		objCDOSYSMail.BCC = ""
		objCDOSYSMail.Subject = EMailSubject
		objCDOSYSMail.HTMLBody = EMailMessage
		objCDOSYSMail.Send

		'Close the server mail object
		Set objCDOSYSMail = Nothing
		Set objCDOSYSCon = Nothing 

		Response.Write LastOrderNumber & " | " & LastEmailAddress & "<BR>" & vbCrLf
		OrderCount = OrderCount + 1

	End If
	
	EMailMessage = ""

End If

Response.Write "Order Count: " & OrderCount & "<BR>"

rsOrderLine.Close
Set rsOrderLine = nothing

%>

</FONT>
</BODY>
</HTML>

<%

End Sub 'PrintLetters

'-----------------------------

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

'-----------------------------

PUBLIC FUNCTION GetOrgName(OrgNumber)

SQLThisOrg = "Select  Organization  FROM Organization (NOLOCK) WHERE OrganizationNumber = " &  OrgNumber & ""
Set rsThisOrg = OBJdbConnection.Execute(SQLThisOrg)
	OrgName = rsThisOrg("Organization") 
rsThisOrg.Close
Set rsThisOrg = Nothing

GetOrgName = OrgName

END FUNCTION

'-----------------------------

%>