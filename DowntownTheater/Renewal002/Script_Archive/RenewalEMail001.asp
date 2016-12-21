<% 
'CHANGE LOG
'JAI 3/11/14 - Corrected formatting if multiple events, and some formatting updates.  Use this as the base template going forward.
'JAI 5/16/14 - New
'SLM 5/5/14 - Updated per client
'SLM 6/16/14 - Updated Reminder

%>

<!--METADATA TYPE="typelib" UUID="CD000000-8B95-11D1-82DB-00C04FB1625D"  NAME="CDO for Windows 2000 Library" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp"-->
<!--#INCLUDE VIRTUAL="TicketPrintInclude.asp"-->
<!--#INCLUDE VIRTUAL="NoCacheInclude.asp"-->
<%

'JAI 6/24/9 - Specify organization ReplyTo e-mail address and the e-mail subject
EMailOrganization = "Lockheed Martin Armed Forces Bowl"
EMailReplyTo = "Trisha.M.Branch@espn.com"
EMailSubject = "Lockheed Martin Armed Forces Bowl Reminder!" 
EMailRenewalURL = "http://armedforcesbowl.tix.com/renew.aspx"
EMailFontFace = "arial,helvetica"
TestEMailAddress = "sergio@tix.com"
'TestEMailAddress = "joe@tix.com;silvia.mahoney@tix.com"
If TestEMailAddress <> "" Then
    EMailSubject = EMailSubject & " [Test Email for your review]"
End If

<a href=""" & EMailRenewalURL & "?o=" & rsOrderLine("OrderNumber") & "&c=" & RenewalCode & """>

EMailMessageBody = ""
EMailMessageBody = EMailMessageBody & "<BR><table border=""0""><tbody>" & vbCrLf
EMailMessageBody = EMailMessageBody & "<tr><td><FONT FACE=" & EMailFontFace & ">" & vbCrLf

EMailMessageBody = EMailMessageBody & "<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height: normal;text-autospace:none'><span style='font-size:12.0pt;font-family:""Arial"",""sans-serif""'>Questions?  Contact Trisha.M.Branch@espn.com</i></b></span></p>" & "<BR>" & vbCrLf
EMailMessageBody = EMailMessageBody & "<p class=MsoNormal style='margin-bottom:0in;margin-bottom:.0001pt;line-height: normal;text-autospace:none'><span style='font-size:12.0pt;font-family:""Arial"",""sans-serif""'>Thank you for your support!</span></p>" & "<BR><BR>" & vbCrLf

EMailMessageBody = EMailMessageBody & "All the best!<BR><BR>" & vbCrLf
EMailMessageBody = EMailMessageBody & "Brant B. Ringler</B><BR>Executive Director" & "<BR>" & vbCrLf

EMailMessageBody = EMailMessageBody & "</FONT></TD></TR></TBODY></TABLE>" & vbCrLf

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

'Decide which subroutine to route to
Select Case Request("FormName")
	Case "DisplayMenu"
		Call SendEmails
	Case Else
		Call DisplayMenu
End Select

'----------------------------------

Sub DisplayMenu

%>
<HTML>
<HEAD>
<TITLE>TIX - Subscription Renewal E-Mail</TITLE>

<SCRIPT LANGUAGE="JavaScript">    
<!-- Hide code from non-js browsers

    function makeCheckEvent(thisForm) {
        if (thisForm.EventCode.length > 1) {
            for (i = 0; i < thisForm.EventCode.length; i++) {
                if (thisForm.SelectAllEvents.checked == true) {
                    thisForm.EventCode[i].checked = true
                } else {
                    thisForm.EventCode[i].checked = false
                }
            }
        } else {
            if (thisForm.SelectAllEvents.checked == true) {
                thisForm.EventCode.checked = true
            } else {
                thisForm.EventCode.checked = false
            }
        }
    }

    function eventSelectedCheck(thisForm) {

        var EventCodeSelected = false;
        var EventCodeIndex = 0;

        //Check for Event Selection.	
        if (formObj.EventCode.length) { //There's multiple events
            for (var i = 0; i < formObj.EventCode.length; i++) {
                if (eval("formObj.EventCode[i].checked") == true) {
                    EventCodeSelected = true;
                    EventCodeIndex = formObj.EventCode[i].value;
                }
            }
        }
        else { //There's only one event
            if (formObj.EventCode.checked == true) {
                EventCodeSelected = true;
                EventCodeIndex = formObj.EventCode.value;
            }
        }
        if (EventCodeSelected != true) { //Event not selected.
            alert("Please select at least one Event.");
            return false;
        }
    }

    // end hiding -->
</SCRIPT>

</HEAD>
<BODY BGCOLOR="#FFFFFF">

<CENTER>

<!--#INCLUDE VIRTUAL="TopNavInclude.asp"-->
<BR>

<BR>

<FONT FACE="verdana,arial,helvetica" COLOR="#008400"><H3>Subscription Renewal E-Mail</H3></FONT>


<%
If TestEMailAddress <> "" Then
    Response.Write "Test Mode.  A test email will be sent to: " & TestEMailAddress & "<BR><BR>" & vbCrLf
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
		Response.Write "<FORM ACTION=""RenewalEMail.asp"" METHOD=""post""><INPUT TYPE=""hidden"" NAME=""FormName"" VALUE=""DisplayMenu"">" & vbCrLf

		Response.Write "<TABLE CELLPADDING=""3"">" & vbCrLf
		Response.Write "<TR BGCOLOR=""#666666""><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><INPUT TYPE=""checkbox"" Name=""SelectAllEvents"" onClick=""makeCheckEvent(this.form)"" id=SelectAllEvents></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Subscription</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Venue</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Date/Time</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Quantity</B></FONT></TD></TR>" & vbCrLf

		'Display Event and UnPrinted Ticket Quantities
		Do Until rsTickets.EOF

			Response.Write "<TR BGCOLOR=""DDDDDD""><TD ALIGN=""center""><INPUT TYPE=""checkbox"" NAME=""EventCode"" VALUE=" & rsTickets("EventCode") & "></FONT></TD><TD><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">" & rsTickets("Act") & "</FONT></TD><TD><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">" & rsTickets("Venue") & "</FONT></TD><TD ALIGN=""center"" NOWRAP><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">" & DateAndTimeFormat(rsTickets("EventDate")) & "</FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">" & rsTickets("TicketCount") & "</FONT></TD></TR>" & vbCrLf

			rsTickets.MoveNext

		Loop
			
		Response.Write "</TABLE><BR>" & vbCrLf
		'Display Buttons to Print
		Response.Write "<FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">Select the Renewal Events for which you want to send e-mails and click 'Send E-Mails' below.</FONT><BR><BR>" & vbCrLf
		Response.Write "<INPUT TYPE=""submit"" VALUE=""Send E-Mails""></FORM>" & vbCrLf
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

End Sub 'DisplayMenu

'---------------------------------

Sub PrintLetters

'Server.ScriptTimeout = 600

%>

<HTML>
<HEAD>
<TITLE>Tix - Subscription Renewal Letters</TITLE>
<SCRIPT LANGUAGE="JavaScript">
<!--    Begin
    function PrintLetters() {
        window.print();
    }

//  End -->
</SCRIPT>

<style type="text/css" media="print">
@page  
{ 
/* set content to full width */
* { width: 100%; margin: 0; float: none;}


/* this affects the margin in the printer settings */ 
size: auto; 
margin: 0.5in 0.35in ;  

/* Avoid image breaks across pages */ 
img, table { page-break-inside: avoid; }

table {width:100%;}
} 

body  
{ 
/* this affects the margin on the content before sending to printer */ 
margin: 0px;  
} 

</style>


</HEAD>
<BODY onLoad="PrintLetters()" LEFTMARGIN="0" RIGHTMARGIN="0" TOPMARGIN="0" MARGINHEIGHT="0" MARGINWIDTH="0">

<STYLE>	
	div {page-break-before: always}
	table tbody tr td { font-family: arial,helvetica, sans-serif; color: #000000;}
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
SQLOrderLine = SQLOrderLine & SQLWhere & ") AND OrderLine.StatusCode = 'R' AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') ORDER BY OrderLine.OrderNumber, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry, OrderLine.ShipCode, Seat.EventCode, Seat.SectionCode, RowSort, SeatSort DESC"
Set rsOrderLine = OBJdbConnection.Execute(SQLOrderLine)
		
Call DBOpen(OBJdbConnection2)
		
Do Until rsOrderLine.EOF

	If rsOrderLine("OrderNumber") <> LastOrderNumber Then 'It's different.  Print it.
	
		If TicketCount > 0 Then 'It's not the first one, print the footer.
		
	        Response.Write "</TABLE>" & vbCrLf
	        Response.Write "</CENTER><BR>" & vbCrLf
			
	        Response.Write "<table border=""0""><tbody>" & vbCrLf
	        Response.Write "<tr><td><FONT FACE=" & EmailFontFace & ">" & vbCrLf
			
			'-----------------------------------------
			
			'Insert HTML Template - Footer Content
			Response.Write InsertTemplate("EmailInclude.asp","Footer") 
			
			'-----------------------------------------
			
	        Response.Write "</FONT></td></tr></tbody></table>" & vbCrLf

			Response.Write "<div></div>" & vbCrLf
			
		End If
				
		SQLCustInfo = "SELECT Customer.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry FROM OrderHeader (NOLOCK) INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber WHERE OrderHeader.OrderNumber = " & rsOrderLine("OrderNumber") & " AND OrderLine.LineNumber = " & rsOrderLine("LineNumber")
		Set rsCustInfo = OBJdbConnection.Execute(SQLCustInfo)

		If Not rsCustInfo.EOF Then
		
			Response.Write "<BR>" & vbCrLf
			Response.Write "<TABLE WIDTH=""650"">" & vbCrLf
    		Response.Write "<TR><TD>" & vbCrLf
			
			Response.Write "<FONT FACE=" & EmailFontFace & "><IMG SRC="" " & MsgLogoPath & " ""><BR><BR>" & vbCrLf
			Response.Write "</TD><TR>" & vbCrLf
			
			Response.Write "<TR><TD WIDTH=300>" & vbCrLf
			
			'Return Address
			Response.Write "<FONT FACE=" & EmailFontFace & ">" & PCase(rsCustInfo("ShipFirstName")) & " " & PCase(rsCustInfo("ShipLastName")) & "<BR>" & PCase(rsCustInfo("ShipAddress1")) & "<BR>" & vbCrLf
			
			If rsCustInfo("ShipAddress2") <> "" Then
				Response.Write PCase(rsCustInfo("ShipAddress2")) & "<BR>" & vbCrLf
			End If
			
			Response.Write PCase(rsCustInfo("ShipCity")) & ", " & rsCustInfo("ShipState") & " " & rsCustInfo("ShipPostalCode") & "</FONT>" & vbCrLf
			
			Response.Write"</TD></TR>" & vbCrLf
            Response.Write "</TABLE>" & vbCrLf
			
			Response.Write"<TABLE border=""0""><TBODY>" & vbCrLf
			Response.Write"<TR><TD valign=top>" & vbCrLf
			Response.Write"<FONT FACE=" & EmailFontFace & "><BR>" & vbCrLf

			'-----------------------------------------
			
			'Insert HTML Template - Body Content
			Response.Write InsertTemplate("EmailInclude.asp","Body") 
			
			'-----------------------------------------

			Response.Write"</FONT>" & vbCrLf
			Response.Write"</TD></TR></TBODY></TABLE>" & vbCrLf
						
			SQLItemNumber = "SELECT ItemNumber FROM OrderLine (NOLOCK) WHERE OrderNumber = " & rsOrderLine("OrderNumber") & " ORDER BY ItemNumber"
			Set rsItemNumber = OBJdbConnection.Execute(SQLItemNumber)
			
			RenewalCode = rsCustInfo("CustomerNumber") & rsItemNumber("ItemNumber")
			
			rsItemNumber.Close
			Set rsItemNumber = nothing
			
			Response.Write "<TABLE WIDTH=""650"" BORDER=0>" & vbCrLf
			Response.Write "<TR><TD WIDTH=""20"">" & vbCrLf
			
			Response.Write "<FONT FACE=" & EmailFontFace & ">&nbsp;</FONT>" & vbCrLf
			
			Response.Write "</TD><TD>" & vbCrLf
			Response.Write "<FONT FACE=" & EmailFontFace & "><B>Order Number:&nbsp;" & rsOrderLine("OrderNumber") & "<BR>Renewal Code:&nbsp;" & RenewalCode & "</B></FONT>" & vbCrLf
			Response.Write "</TD></TR></TABLE>" & vbCrLf
			
			EmailRenewalURL =  EmailRenewalURL & "?o=" & rsOrderLine("OrderNumber") & "&c=" & RenewalCode

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
		Response.Write "<TABLE WIDTH=""650"" BORDER=0><TR><TD WIDTH=""20""><FONT FACE=" & EmailFontFace & ">&nbsp;</FONT></TD><TD><FONT FACE=" & EmailFontFace & "><B>" & rsOrderLine("Act") & " at " & rsOrderLine("Venue")
		
		'REE 6/5/6 - Modified to look at EventOptions for Date & Time Display Options
		SQLDateSuppress = "SELECT OptionValue AS DateSuppress FROM EventOptions (NOLOCK) WHERE EventCode = " & rsOrderLine("EventCode") & " AND OptionName = 'DateSuppress' AND OptionValue = 'Y'"
		Set rsDateSuppress = OBJdbConnection.Execute(SQLDateSuppress)
		If rsDateSuppress.EOF Then
			Response.Write " on " & FormatDateTime(rsOrderLine("EventDate"),vbLongDate)
		End If
		rsDateSuppress.Close
		Set rsDateSuppress = nothing

		SQLTimeSuppress = "SELECT OptionValue AS TimeSuppress FROM EventOptions (NOLOCK) WHERE EventCode = " & rsOrderLine("EventCode") & " AND OptionName = 'TimeSuppress' AND OptionValue = 'Y'"
		Set rsTimeSuppress = OBJdbConnection.Execute(SQLTimeSuppress)
		If rsTimeSuppress.EOF Then
			Response.Write " at " & Left(FormatDateTime(rsOrderLine("EventDate"),vbLongTime),Len(FormatDateTime(rsOrderLine("EventDate"),vbLongTime))-6) & "&nbsp;" & Right(FormatDateTime(rsOrderLine("EventDate"),vbLongTime),2)
		End If
		rsTimeSuppress.Close
		Set rsTimeSuppress = nothing

		Response.Write "</B><BR>Delivery Method: " & rsOrderLine("ShipType") & "</FONT></TD></TR></TABLE><BR>" & vbCrLf
		
		
		'-----------------------------------------

			'Child Events

			SQLEventChild = "SELECT SubscriptionEvent.EventCode, Event.EventDate, Act.Act FROM SubscriptionEvent (NOLOCK) INNER JOIN Event (NOLOCK) ON SubscriptionEvent.EventCode = Event.EventCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode WHERE SubscriptionEvent.SubscriptionNumber = " & rsOrderLine("EventCode") & ""
			Set rsEventChild = OBJdbConnection.Execute(SQLEventChild)
			
			If Not rsEventChild.EOF Then
				
				linecount = 1

				Response.Write "<TABLE WIDTH=""650"" CELLPADDING=""0"" CELLSPACING=""0"" BORDER=""0"">" & vbCrLf
				Response.Write "<TR>" & vbCrLf
				Response.Write "<TD WIDTH=""20""><FONT FACE=" & EmailFontFace & ">&nbsp;</FONT></TD>" & vbCrLf
				Response.Write "<td colspan=""2"">" & vbCrLf
				Response.Write "<FONT FACE=" & EmailFontFace & "><B>This subscription includes:</B></FONT>" & vbCrLf
				Response.Write "</td>" & vbCrLf
				Response.Write "</tr>" & vbCrLf
			
					Do While Not rsEventChild.EOF

						Response.Write "<tr>" & vbCrLf	
						Response.Write "<TD WIDTH=""20""><FONT FACE=" & EmailFontFace & ">&nbsp;</FONT></TD>" & vbCrLf
						Response.Write "<td>" & vbCrLf
						Response.Write "<FONT FACE=" & EmailFontFace & ">" & rsEventChild("Act") & "</FONT>" & vbCrLf	
						Response.Write "</td>" & vbCrLf	
						Response.Write "<td NOWRAP>" & vbCrLf
						Response.Write "<FONT FACE=" & EmailFontFace & ">" & FormatDateTime(rsEventChild("EventDate"), vbLongDate) & " at " & Left(FormatDateTime(rsEventChild("EventDate"),vbLongTime),Len(FormatDateTime(rsEventChild("EventDate"),vbLongTime))-6) & Right(FormatDateTime(rsEventChild("EventDate"),vbLongTime),3) & "</FONT>" & vbCrLf
						Response.Write "</td>" & vbCrLf
						Response.Write "</tr>" & vbCrLf
							
					rsEventChild.movenext
					Loop
					
				Response.Write "</TABLE>" & vbCrLf

			Else
		
				Response.Write " " & vbCrLf
			
			End If
				
			rsEventChild.Close
			Set rsEventChild = nothing

			Response.Write "<BR>" & vbCrLf
		
		'-----------------------------------------

		'Calculate Number of Columns
		SQLNumColumns = "SELECT SUM(OrderLine.Surcharge) AS ServiceFee, SUM(OrderLine.Discount) AS Discount FROM OrderLine WHERE OrderNumber = " & rsOrderLine("OrderNumber") & " AND ItemType IN ('Seat', 'SubFixedEvent')"
		Set rsNumColumns = OBJdbConnection.Execute(SQLNumColumns)

		NumColumns = 6
		ColumnHeading = "<TABLE WIDTH=""650"" BORDER=0><TR><TD WIDTH=""20""><FONT FACE=" & EmailFontFace & ">&nbsp;</FONT></TD><TD><FONT FACE=" & EmailFontFace & "><B><U>Section</U></B></FONT></TD><TD ALIGN=center><FONT FACE=" & EmailFontFace & "><B><U>Row</U></B></FONT></TD><TD ALIGN=center><FONT FACE=" & EmailFontFace & "><B><U>Seat</U></B></FONT></TD><TD><FONT FACE=" & EmailFontFace & "><B><U>Type</U></B></FONT></TD><TD ALIGN=right><FONT FACE=" & EmailFontFace & "><B><U>Price</U></B></FONT></TD>"

		FacilityCharge = 0
		If FacilityCharge <> 0 Then
			NumColumns = NumColumns + 1
			ColumnHeading = ColumnHeading + "<TD ALIGN=right><FONT FACE=" & EmailFontFace & "><B><U>Facility Charge</U></B></FONT></TD>"
			ColFacilityCharge = "Y"
		End If
		If rsNumColumns("ServiceFee") <> 0 Then
			NumColumns = NumColumns + 1
			ColumnHeading = ColumnHeading + "<TD ALIGN=right><FONT FACE=" & EmailFontFace & "><B><U>Service Fee</U></B></FONT></TD>"
			ColServiceFee = "Y"
		End If
		If rsNumColumns("Discount") <> 0 Then
			NumColumns = NumColumns + 1
			ColumnHeading = ColumnHeading + "<TD ALIGN=right><FONT FACE=" & EmailFontFace & "><B><U>Discount</U></B></FONT></TD>"
			ColDiscount = "Y"
		End If

		rsNumColumns.Close
		Set rsNumColumns = nothing

		ColumnHeading = ColumnHeading + "<TD ALIGN=right><FONT FACE=" & EmailFontFace & "><B><U>Amount</U></B></FONT></TD></TR>" & vbCrLf
		
		Response.Write ColumnHeading

		LastEventCode = rsOrderLine("EventCode")
	End If
			
	'Print the detail
	'Add the OrderNumber and LineNumber to the Form
	LineDetail = "<TR><TD WIDTH=""20""><FONT FACE=" & EmailFontFace & ">&nbsp;</FONT></TD><TD><FONT FACE=" & EmailFontFace & ">" & rsOrderLine("Section") & "</FONT></TD><TD ALIGN=center><FONT FACE=" & EmailFontFace & ">" & rsOrderLine("Row") & "</FONT></TD><TD ALIGN=center><FONT FACE=" & EmailFontFace & ">" & rsOrderLine("Seat") & "</FONT></TD><TD><FONT FACE=" & EmailFontFace & ">" & rsOrderLine("SeatType") & "</FONT></TD><TD ALIGN=right><FONT FACE=" & EmailFontFace & ">" & FormatCurrency(rsOrderLine("Price"),2) & "</FONT></TD>"
	
	If ColFacilityCharge = "Y" Then
		LineDetail = LineDetail & "<TD ALIGN=right><FONT FACE=" & EmailFontFace & ">" & FormatCurrency(FacilityCharge,2) & "</FONT></TD>"
	End If
	If ColServiceFee = "Y" Then
		LineDetail = LineDetail & "<TD ALIGN=right><FONT FACE=" & EmailFontFace & ">" & FormatCurrency(rsOrderLine("Surcharge"),2) & "</FONT></TD>"
	End If
	If ColDiscount = "Y" Then
		LineDetail = LineDetail & "<TD ALIGN=right><FONT FACE=" & EmailFontFace & ">" & FormatCurrency(rsOrderLine("Discount"),2) & "</FONT></TD>"
	End If
	
	LineDetail = LineDetail & "<TD ALIGN=right><FONT FACE=" & EmailFontFace & ">" & FormatCurrency(rsOrderLine("Price")+FacilityFee+rsOrderLine("Surcharge")-rsOrderLine("Discount"),2) & "</FONT></TD></TR>" & vbCrLf
	
	Response.Write LineDetail

	LastOrderNumber = rsOrderLine("OrderNumber")
	
	rsOrderLine.MoveNext
		
Loop	
	
If TicketCount > 0 Then	'Print the last footer

	Response.Write "</TABLE>" & vbCrLf
	Response.Write "</CENTER><BR>" & vbCrLf
	
	Response.Write "<table border=""0""><tbody>" & vbCrLf
	Response.Write "<tr><td><FONT FACE=" & EmailFontFace & ">" & vbCrLf

	
	'-----------------------------------------
	
	'Insert HTML Template - Footer Content
	Response.Write InsertTemplate("EmailInclude.asp","Footer") 
	
	'-----------------------------------------
	
	 Response.Write "</FONT></TD></TR></TBODY></TABLE>" & vbCrLf
	 Response.Write "<div></div>" & vbCrLf

End If

rsOrderLine.Close
Set rsOrderLine = nothing

Call DBClose(OBJdbConnection2)

%>

</FONT>
</BODY>
</HTML>

<%

End Sub 'PrintLetters

'-------------------------------------------------

FUNCTION  PCase(str) 

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

PUBLIC FUNCTION InsertTemplate(templateFile,templateName)

DIM templateFileName
templateFileName = "\Clients\ArmedForcesBow\Renewal\templates\2015\EmailInclude.asp"

Dim  strText
strText = ""

Dim strNewText
strNewText = ""

	Const ForReading = 1

	Set objFSO = CreateObject("Scripting.FileSystemObject")
	
	templatePath = Server.MapPath(templateFileName)

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

		strNewText = Replace(strText, 	 "[FirstName]", CustomerFName)
		strNewText = Replace(strNewText, "[webSite]", webSite)
		strNewText = Replace(strNewText, "[orgNumber]", orgNumber)
		strNewText = Replace(strNewText, "[senderFName]", senderFName)
		strNewText = Replace(strNewText, "[senderLName]", senderLName)
		strNewText = Replace(strNewText, "[senderAddress]", senderAddress)
		strNewText = Replace(strNewText, "[OrgName]", fnOrgName)
		strNewText = Replace(strNewText, "[EmailRenewalURL]",RenewalURL)
		strNewText = Replace(strNewText, "[ServerName]",Request.ServerVariables("server_name"))
		
		replaceVar = strNewText
		
END FUNCTION 

'--------------------------------------------------------------------

%>