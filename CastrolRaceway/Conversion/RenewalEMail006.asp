<% 
'CHANGE LOG
'JAI 9/25/12 - 2013 Update
'JAI 10/22/13 - 2014 Update.  Custom for Castrol 2014.  Do not use in subsequent years.
'JAI 10/24/14 - Updated for 2015.
%>

<!--METADATA TYPE="typelib" UUID="CD000000-8B95-11D1-82DB-00C04FB1625D"  NAME="CDO for Windows 2000 Library" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp"-->
<!--#INCLUDE VIRTUAL="TicketPrintInclude.asp"-->
<!--#INCLUDE VIRTUAL="NoCacheInclude.asp"-->
<%

'JAI 6/24/9 - Specify organization ReplyTo e-mail address and the e-mail subject
EMailOrganization = "Castrol Raceway"
EMailSubject = "Castrol Raceway 2015 Race Season Renewal" 
EMailRenewalURL = "http://CastrolRaceway.tix.com/renew.aspx"
EMailReplyTo = "info@castrolraceway.com"
EMailPhone = "(780) 461-5801"
'TestEMailAddress = "joe@tix.com"

RMNEventList = "699151,699152,698843,699153,699154"
WOOEventList = "702537,702541,702543,702545,702547"
HANEventList = "701638"

Server.ScriptTimeout = 3600

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

'----------------------------------

Sub PrintMenu

%>
<HTML>
<HEAD>
<TITLE>TIX - Subscription Renewal E-Mail</TITLE>
</HEAD>
<BODY BGCOLOR="#FFFFFF">

<CENTER>

<!--#INCLUDE VIRTUAL="TopNavInclude.asp"-->
<BR>

<BR>

<FONT FACE="verdana,arial,helvetica" COLOR="#008400"><H3>Subscription Renewal E-Mail</H3></FONT>


<%

'Get Matching Events
'REE 4/6/2 - Modified to include OrganizationAct selection criteria
'REE 2/25/3 - Removed TicketFormat from criteria.
SQLEvents = "SELECT Event.EventCode FROM Event (NOLOCK) INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization (NOLOCK) ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber WHERE Organization.OrganizationNumber = " & Session("OrganizationNumber") & " AND EventDate > GETDATE() ORDER BY EventDate"
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
	SQLTickets = "SELECT COUNT(OrderLine.ItemNumber) AS TicketCount, Act.Act, EventDate, Event.EventCode, Venue FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Shipping (NOLOCK) ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization (NOLOCK) ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber WHERE Event.EventCode IN " & EventList & " AND EventDate > GETDATE() AND OrderLine.StatusCode = 'R' AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') AND Customer.EMailAddress IS NOT NULL AND Customer.EMailAddress <> '' GROUP BY Event.EventCode, EventDate, Act.Act, Venue.Venue ORDER BY EventDate, Act.Act"
	Set rsTickets = OBJdbConnection.Execute(SQLTickets)
	
	'REE 4/6/2 - Modified to check for events.
	If Not rsTickets.EOF Then 'There are some events.  List them
		If TestEMailAddress <> "" Then
    		Response.Write "<FONT FACE=""verdana,arial,helvetica"" SIZE=""2""><B>TEST MODE</B> - A Test email will be sent to: " & TestEMailAddress & "<BR><BR></FONT>" & vbCrLf
        End If
		Response.Write "<FORM ACTION=""RenewalEMail.asp"" METHOD=""post""><INPUT TYPE=""hidden"" NAME=""FormName"" VALUE=""PrintMenu"">" & vbCrLf

		Response.Write "<TABLE CELLPADDING=""3"">" & vbCrLf
		Response.Write "<TR BGCOLOR=""#666666""><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Include</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Subscription</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Venue</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Date/Time</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Quantity</B></FONT></TD></TR>" & vbCrLf

		'Display Event and UnPrinted Ticket Quantities
		Do Until rsTickets.EOF

			Response.Write "<TR BGCOLOR=""DDDDDD""><TD ALIGN=""center""><INPUT TYPE=""checkbox"" NAME=""EventCode"" VALUE=" & rsTickets("EventCode") & "></FONT></TD><TD><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">" & rsTickets("Act") & "</FONT></TD><TD><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">" & rsTickets("Venue") & "</FONT></TD><TD ALIGN=""center"" NOWRAP><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">" & DateAndTimeFormat(rsTickets("EventDate")) & "</FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">" & rsTickets("TicketCount") & "</FONT></TD></TR>" & vbCrLf

			rsTickets.MoveNext

		Loop
			
		Response.Write "</TABLE><BR>" & vbCrLf
		'Display Buttons to Print
		Response.Write "<FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">Select Events to submit and click 'Send E-mails' below.</FONT><BR><BR>" & vbCrLf
		Response.Write "<INPUT TYPE=""submit"" VALUE=""Send E-mails""></FORM>" & vbCrLf
	Else 'There aren't any matching events
		Response.Write "<BR><BR><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">There are no events to be generated.</FONT><BR><BR>" & vbCrLf
	End If
Else 'There aren't any matching events
	Response.Write "<BR><BR><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">There are no events to be generated.</FONT><BR><BR>" & vbCrLf
End If
%>

</CENTER>

<!--#INCLUDE VIRTUAL="FooterInclude.asp"-->

</BODY>
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
SQLOrderLine = "SELECT OrderHeader.OrderTypeNumber, OrderHeader.OrderSurcharge, OrderHeader.ShipFee, OrderHeader.Total, OrderLine.OrderNumber, OrderLine.LineNumber, OrderLine.ItemNumber, OrderLine.Price, OrderLine.Surcharge, OrderLine.Discount, OrderLine.ShipCode, Event.EventCode, Event.EventDate, Event.Map, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, PostalCode, Customer.DayPhone, Customer.NightPhone, Customer.EMailAddress, Shipping.ShipType, Act.Act, Venue.Venue, SeatType.SeatType, Seat.Row, Seat.Seat, Seat.SectionCode, Section.Section FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Section (NOLOCK) ON Seat.SectionCode = Section.SectionCode AND Event.EventCode = Section.EventCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN Shipping (NOLOCK) ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode "
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
		
			EMailMessage = EMailMessage & "<TR><TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf			
			If LastShipFee <> 0 And LastOrderTypeNumber <> 5 Then
				EMailMessage = EMailMessage & "<TR><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=Calibri,Charcoal,Arial>Processing Fee</TD><TD ALIGN=""right""><FONT FACE=Calibri,Charcoal,Arial>" & FormatCurrency(LastShipFee,2) & "</TD></TR>" & vbCrLf
				EMailMessage = EMailMessage & "<TR><TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf
			End If

			SQLTender = "SELECT SUM(Tender.Amount) AS TenderAmount FROM Tender (NOLOCK) WHERE Tender.OrderNumber = " & LastOrderNumber
			Set rsTender = OBJdbConnection.Execute(SQLTender)
		
			If IsNull(rsTender("TenderAmount")) Then
				LastTender = 0
			Else
				LastTender = rsTender("TenderAmount")
				Response.Write SQLTender & "<BR>"
			End If
		
			rsTender.Close
			Set rsTender = nothing	

			EMailMessage = EMailMessage & "<TR><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=Calibri,Charcoal,Arial>Order Total</TD><TD ALIGN=""right""><FONT FACE=Calibri,Charcoal,Arial>" & FormatCurrency(LastTotal,2) & "</TD></TR>" & vbCrLf
			If LastTender <> 0 Then
				EMailMessage = EMailMessage & "<TR><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=Calibri,Charcoal,Arial>Less Payments</TD><TD ALIGN=""right""><FONT FACE=Calibri,Charcoal,Arial>" & FormatCurrency(LastTender,2) & "</TD></TR>" & vbCrLf
				EMailMessage = EMailMessage & "<TR><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=Calibri,Charcoal,Arial>Balance Due</TD><TD ALIGN=""right""><FONT FACE=Calibri,Charcoal,Arial>" & FormatCurrency(LastTotal - LastTender,2) & "</TD></TR>" & vbCrLf
			End If
			EMailMessage = EMailMessage & "</TABLE>" & vbCrLf
        	EMailMessage = EMailMessage & "<FONT FACE=Calibri,Charcoal,Arial><BR>For more information, please contact us at " & EMailPhone & " or <A HREF=mailto:" & EMailReplyTo & ">" & EMailReplyTo & "</A>.<BR>"
			EMailMessage = EMailMessage & "</CENTER>" & vbCrLf

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
			
			If TestEMailAddress <> "" Then
				Exit Do
			End If

		End If

		SQLCustInfo = "SELECT Customer.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry FROM OrderHeader (NOLOCK) INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber WHERE OrderHeader.OrderNumber = " & rsOrderLine("OrderNumber") & " AND OrderLine.LineNumber = " & rsOrderLine("LineNumber")
		Set rsCustInfo = OBJdbConnection.Execute(SQLCustInfo)

		If Not rsCustInfo.EOF Then

	        SQLEventInfo = "SELECT DISTINCT CASE WHEN Seat.EventCode IN (" & RMNEventList & ") THEN 'RMN' WHEN Seat.EventCode IN (" & HANEventList & ") THEN 'HAN' WHEN Seat.EventCode IN (" & WOOEventList & ") THEN 'WOO' END AS LetterFormat FROM OrderHeader (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderHeader.OrderNumber = Seat.OrderNumber WHERE OrderHeader.OrderNumber = " & rsOrderLine("OrderNumber")
	        Set rsEventInfo = OBJdbConnection.Execute(SQLEventInfo)
            Do Until rsEventInfo.EOF
                LetterFormat = rsEventInfo("LetterFormat")
                %>
                <!--#INCLUDE FILE="RenewalEMailInclude.asp"-->
                <%		
                rsEventInfo.MoveNext
            Loop
		    rsEventInfo.Close
		    Set rsEventInfo = nothing

			EMailMessage = EMailMessage & "<br /><table><tr><td style=""background:none; border:inset 4px #333333; border-width:4px 0 0 0; height:1px; width:100%; margin:0px 0px 0px 0px; padding-top:1px;padding-bottom:1px;""><IMG SRC=""http://www.tix.com/Images/Clear.gif"" WIDTH=""1"" HEIGHT=""1""></td></tr>" & vbCrLf
			EMailMessage = EMailMessage & "<tr><td><FONT FACE=Calibri,Charcoal,Arial><br />If you are mailing in your Save My Seat form to Castrol Raceway, please fill out the payment information below.<BR><BR>" & vbCrLf
			EMailMessage = EMailMessage & "<B>" & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & "</B><BR>" & vbCrLf
			EMailMessage = EMailMessage & "<B>Order Number: " & rsOrderLine("OrderNumber") & "</B><BR>" & vbCrLf
			EMailMessage = EMailMessage & "<B>Order Total: " & FormatCurrency(rsOrderLine("Total")) & "</B><BR><BR>" & vbCrLf
			EMailMessage = EMailMessage & "Method of Payment:&nbsp;&nbsp;&nbsp;&nbsp;VISA&nbsp;&nbsp;&nbsp;&nbsp;MASTERCARD&nbsp;&nbsp;&nbsp;&nbsp;CHECK&nbsp;&nbsp;&nbsp;&nbsp;MONEY ORDER<BR><BR><BR>" & vbCrLf
			EMailMessage = EMailMessage & "Credit Card #:____________________________&nbsp;&nbsp;&nbsp;Expiration Date:__________<BR><BR><BR>" & vbCrLf
			EMailMessage = EMailMessage & "Check #:______________&nbsp;&nbsp;&nbsp;&nbsp;Amount Paid:______________<BR><BR>" & vbCrLf
			EMailMessage = EMailMessage & "If your mailing address has changed or is changing, please notify the Castrol Raceway office.<BR><BR>" & vbCrLf
			EMailMessage = EMailMessage & "<b>Mail To:</b><BR>" & vbCrLf
			EMailMessage = EMailMessage & "Castrol Raceway - Renewals<BR>" & vbCrLf
			EMailMessage = EMailMessage & "7003 Girard Rd<BR>" & vbCrLf
			EMailMessage = EMailMessage & "Edmonton, Alberta  T6B 0B1<BR>" & vbCrLf
			EMailMessage = EMailMessage & "<br /></FONT></TD></TR>" & vbCrLf
			EMailMessage = EMailMessage & "<tr><td style=""background:none; border:inset 4px #333333; border-width:4px 0 0 0; height:1px; width:100%; margin:0px 0px 0px 0px; padding-top:1px;padding-bottom:1px;""><IMG SRC=""http://www.tix.com/Images/Clear.gif"" WIDTH=""1"" HEIGHT=""1""></td></tr></TBODY></TABLE></CENTER>" & vbCrLf
			EMailMessage = EMailMessage & "<DIV>&nbsp;</DIV>" & vbCrLf

            EMailMessage = EMailMessage & "<CENTER><IMG SRC=""http://www.tix.com/PrivateLabel/CastrolRaceway/Conversion/CastrolRaceway.png"" WIDTH=""175""><IMG SRC=""http://www.tix.com/PrivateLabel/CastrolRaceway/Conversion/SaveMySeat.gif"" WIDTH=""225""><BR>" & vbCrLf
			EMailMessage = EMailMessage & "<TABLE CELLPADDING=""3"" WIDTH=""745""><TR><TD><FONT FACE=Calibri,Charcoal,Arial><BR><B>Order Number:&nbsp;" & rsOrderLine("OrderNumber") & "</B><BR>" & vbCrLf

			SQLItemNumber = "SELECT ItemNumber FROM OrderLine (NOLOCK) WHERE OrderNumber = " & rsOrderLine("OrderNumber") & " ORDER BY ItemNumber"
			Set rsItemNumber = OBJdbConnection.Execute(SQLItemNumber)
			
			RenewalCode = rsCustInfo("CustomerNumber") & rsItemNumber("ItemNumber")
			
			rsItemNumber.Close
			Set rsItemNumber = nothing
			
			EMailMessage = EMailMessage & "<B>Renewal Code:&nbsp;" & RenewalCode & "</B><BR></TD></TR><TR><TD><FONT FACE=Calibri,Charcoal,Arial><B>To renew, <A HREF=" & EMailRenewalURL & ">click here</A>.</B><BR></TD></TR></TABLE>" & vbCrLf
    		EMailMessage = EMailMessage & "<TABLE WIDTH=""745"">" & vbCrLf

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
		
	End If

	TicketCount = TicketCount + 1

	'Print Event Info and Column Headings if this is a new Event
	If LastEventCode <> rsOrderLine("EventCode") Or LastOrderNumber <> rsOrderLine("OrderNumber") Then
		'Calculate Number of Columns
		SQLNumColumns = "SELECT SUM(OrderLine.Surcharge) AS ServiceFee, SUM(OrderLine.Discount) AS Discount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & rsOrderLine("OrderNumber") & " AND ItemType IN ('Seat', 'SubFixedEvent')"
		Set rsNumColumns = OBJdbConnection.Execute(SQLNumColumns)

		NumColumns = 6
		ColumnHeading = "<TR><TD><FONT FACE=Calibri,Charcoal,Arial><B><U>Section</U></B></TD><TD ALIGN=center><FONT FACE=Calibri,Charcoal,Arial><B><U>Row</U></B></TD><TD ALIGN=center><FONT FACE=Calibri,Charcoal,Arial><B><U>Seat</U></B></TD><TD><FONT FACE=Calibri,Charcoal,Arial><B><U>Type</U></B></TD><TD ALIGN=right><FONT FACE=Calibri,Charcoal,Arial><B><U>Price</U></B></TD>"
		
		FacilityCharge = 0
		If FacilityCharge <> 0 Then
			NumColumns = NumColumns + 1
			ColumnHeading = ColumnHeading + "<TD ALIGN=right><FONT FACE=Calibri,Charcoal,Arial><B><U>Facility Charge</U></B></TD>"
			ColFacilityCharge = "Y"
		End If
		If rsNumColumns("ServiceFee") <> 0 Then
			NumColumns = NumColumns + 1
			ColumnHeading = ColumnHeading + "<TD ALIGN=right><FONT FACE=Calibri,Charcoal,Arial><B><U>Service Fee</U></B></TD>"
			ColServiceFee = "Y"
		End If
		If rsNumColumns("Discount") <> 0 Then
			NumColumns = NumColumns + 1
			ColumnHeading = ColumnHeading + "<TD ALIGN=right><FONT FACE=Calibri,Charcoal,Arial><B><U>Discount</U></B></TD>"
			ColDiscount = "Y"
		End If

		rsNumColumns.Close
		Set rsNumColumns = nothing

		ColumnHeading = ColumnHeading + "<TD ALIGN=right><FONT FACE=Calibri,Charcoal,Arial><B><U>Amount</U></B></TD></TR>" & vbCrLf
		
		EMailMessage = EMailMessage & "<TR><TD colspan=""" & NumColumns & """><B><FONT FACE=Calibri,Charcoal,Arial>" & rsOrderLine("Act") & " at " & rsOrderLine("Venue")
	
		'REE 6/5/6 - Modified to look at EventOptions for Date & Time Display Options
		SQLDateSuppress = "SELECT OptionValue AS DateSuppress FROM EventOptions (NOLOCK) WHERE EventCode = " & rsOrderLine("EventCode") & " AND OptionName = 'DateSuppress' AND OptionValue = 'Y'"
		Set rsDateSuppress = OBJdbConnection.Execute(SQLDateSuppress)
		If rsDateSuppress.EOF Then
			EMailMessage = EMailMessage & " on " & FormatDateTime(rsOrderLine("EventDate"),vbShortDate)
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

		EMailMessage = EMailMessage & "</B><BR>Delivery Method: " & rsOrderLine("ShipType") & "</TD></TR>" & vbCrLf

		EMailMessage = EMailMessage & ColumnHeading

		LastEventCode = rsOrderLine("EventCode")
	End If
			
	'Print the detail
	'Add the OrderNumber and LineNumber to the Form
	LineDetail = "<TR><TD><FONT FACE=Calibri,Charcoal,Arial>" & rsOrderLine("Section") & "</TD><TD ALIGN=center><FONT FACE=Calibri,Charcoal,Arial>" & rsOrderLine("Row") & "</TD><TD ALIGN=center><FONT FACE=Calibri,Charcoal,Arial>" & rsOrderLine("Seat") & "</TD><TD><FONT FACE=Calibri,Charcoal,Arial>" & rsOrderLine("SeatType") & "</TD><TD ALIGN=right><FONT FACE=Calibri,Charcoal,Arial>" & FormatCurrency(rsOrderLine("Price"),2) & "</TD>"
	
	If ColFacilityCharge = "Y" Then
		LineDetail = LineDetail & "<TD ALIGN=right><FONT FACE=Calibri,Charcoal,Arial>" & FormatCurrency(FacilityCharge,2) & "</TD>"
	End If
	If ColServiceFee = "Y" Then
		LineDetail = LineDetail & "<TD ALIGN=right><FONT FACE=Calibri,Charcoal,Arial>" & FormatCurrency(rsOrderLine("Surcharge"),2) & "</TD>"
	End If
	If ColDiscount = "Y" Then
		LineDetail = LineDetail & "<TD ALIGN=right><FONT FACE=Calibri,Charcoal,Arial>" & FormatCurrency(rsOrderLine("Discount"),2) & "</TD>"
	End If
	
	LineDetail = LineDetail & "<TD ALIGN=right><FONT FACE=Calibri,Charcoal,Arial>" & FormatCurrency(rsOrderLine("Price")+FacilityFee+rsOrderLine("Surcharge")-rsOrderLine("Discount"),2) & "</TD></TR>" & vbCrLf
	
	EMailMessage = EMailMessage & LineDetail

	LastOrderNumber = rsOrderLine("OrderNumber")
'	
	rsOrderLine.MoveNext
		
Loop	
	
If TicketCount > 0 Then	'Print the last footer

	EMailMessage = EMailMessage & "<TR><TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf			
	If LastShipFee <> 0 And LastOrderTypeNumber <> 5 Then
		EMailMessage = EMailMessage & "<TR><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=Calibri,Charcoal,Arial>Processing Fee</TD><TD ALIGN=""right""><FONT FACE=Calibri,Charcoal,Arial>" & FormatCurrency(LastShipFee,2) & "</TD></TR>" & vbCrLf
		EMailMessage = EMailMessage & "<TR><TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf
	End If

	SQLTender = "SELECT SUM(Tender.Amount) AS TenderAmount FROM Tender (NOLOCK) WHERE Tender.OrderNumber = " & LastOrderNumber
	Set rsTender = OBJdbConnection.Execute(SQLTender)
		
	If IsNull(rsTender("TenderAmount")) Then
		LastTender = 0
	Else
		LastTender = rsTender("TenderAmount")
'		Response.Write SQLTender & "<BR>"
	End If
		
	rsTender.Close
	Set rsTender = nothing	

	EMailMessage = EMailMessage & "<TR><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=Calibri,Charcoal,Arial>Order Total</TD><TD ALIGN=""right""><FONT FACE=Calibri,Charcoal,Arial>" & FormatCurrency(LastTotal,2) & "</TD></TR>" & vbCrLf
	If LastTender <> 0 Then
		EMailMessage = EMailMessage & "<TR><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=Calibri,Charcoal,Arial>Less Payments</TD><TD ALIGN=""right""><FONT FACE=Calibri,Charcoal,Arial>" & FormatCurrency(LastTender,2) & "</TD></TR>" & vbCrLf
		EMailMessage = EMailMessage & "<TR><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """><FONT FACE=Calibri,Charcoal,Arial>Balance Due</TD><TD ALIGN=""right""><FONT FACE=Calibri,Charcoal,Arial>" & FormatCurrency(LastTotal - LastTender,2) & "</TD></TR>" & vbCrLf
	End If
	EMailMessage = EMailMessage & "</TABLE>" & vbCrLf
	EMailMessage = EMailMessage & "<FONT FACE=Calibri,Charcoal,Arial><BR>For more information, please contact us at " & EMailPhone & " or <A HREF=mailto:" & EMailReplyTo & ">" & EMailReplyTo & "</A>.<BR>"
	EMailMessage = EMailMessage & "</CENTER>" & vbCrLf
	
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
	    objCDOSYSMail.BCC = "joe@tix.com"
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

%>