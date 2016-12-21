<% 
'CHANGE LOG
'JAI 7/12/13 - Centerpoint Theatre Rewnewal Letter 2014
'JAI 7/15/13 - Changed signature font.
'JAI 7/16/13 - Set RenewalLetterDate
'SSR 7/16/2015 - Updated RenewalLetter
'SSR 7/17/15 - Updated

%>

<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp"-->
<!--#INCLUDE VIRTUAL="TicketPrintInclude.asp"-->
<!--#INCLUDE VIRTUAL="NoCacheInclude.asp"-->
<%

'REE 4/15/2 - Increased Session Timeout to 30 minutes to reduce Print validation timeout issues.
Session.Timeout = 60
Server.ScriptTimeout = 600
Page = "ManagementMenu"
NumColumns = 0
LastTotal = 0

'Set the Date to be printed on the renewal letters
'RenewalLetterDate = FormatDateTime(Now(), vbLongDate)
'RenewalLetterDate = FormatDateTime("8/1/14", vbLongDate)
RenewalLetterDate = "August 01, 2015" 


'Make sure the correct Session variables are in place.  If not clear the variables and go to the menu.
If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then 
	Session.Abandon
	Response.Redirect("/Default.asp")
End If

If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then 
	Session.Abandon
	Response.Redirect("/Default.asp")
End If

OrganizationName = "CenterPoint Legacy Theatre"

SendTo = "<TABLE border cellpadding=""0"" cellspacing=""0"" bgcolor=""#bfbfbf"" width=""550px""> <TR> <TD align=""center"">  <BR> <B>SEASON TICKETS.</B>&nbsp;Flexible when your schedule isn't!<BR> <BR>  <TABLE border=""0"" cellpadding=""0"" cellspacing=""0"" width=""450px""> <TR> <TD width=""50%""></TD> <TD width=""25%""><I><B>Tu/We/Mat</B></I></TD> <TD width=""25%""><I><B>Mo/Th/Fr/Sa</B></I></TD> </TR> <TR> <TD>Main Level Adult&nbsp;</TD> <TD>$106.00</TD> <TD>$118.00</TD> </TR> <TR> <TD>Main Level Senior/Student&nbsp;</TD> <TD>$99.00</TD> <TD>$110.00</TD> </TR> <TR> <TD>Balcony Level Adult&nbsp;</TD> <TD>$81.00</TD> <TD>$93.00</TD> </TR> <TR> <TD>Balcony Level Senior/Student&nbsp;</TD> <TD>$75.00</TD> <TD>$86.00</TD> </TR> </TABLE> <BR> </TD> </TR> </TABLE>"

LogoImage = "http://www.tix.com/clients/CenterpointTheatre/Renewal/Images/BW_CenterPoint_shadedlogo_H.jpg"


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

<FONT FACE="verdana,arial,helvetica" COLOR="#008400"><H3>Subscription Renewal Printing</H3></FONT>
<FONT FACE="verdana,arial,helvetica" COLOR="#008400"><H3>Flex Subscription</H3></FONT>


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
	SQLTickets = "SELECT COUNT(OrderLine.ItemNumber) AS TicketCount, Act.Act, EventDate, Event.EventCode, Venue FROM Event (NOLOCK) INNER JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Shipping (NOLOCK) ON OrderLine.ShipCode = Shipping.ShipCode INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization (NOLOCK) ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE Event.EventCode IN " & EventList & " AND EventDate > GETDATE() AND OrderLine.StatusCode = 'R' AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') GROUP BY Event.EventCode, EventDate, Act.Act, Venue.Venue ORDER BY EventDate, Act.Act"
	Set rsTickets = OBJdbConnection.Execute(SQLTickets)
	
	'REE 4/6/2 - Modified to check for events.
	If Not rsTickets.EOF Then 'There are some events.  List them
		Response.Write "<FORM ACTION=""RenewalLetter_Flex.asp"" METHOD=""post""><INPUT TYPE=""hidden"" NAME=""FormName"" VALUE=""PrintMenu"">" & vbCrLf

		Response.Write "<TABLE CELLPADDING=""3"">" & vbCrLf
		Response.Write "<TR BGCOLOR=""#666666""><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><INPUT TYPE=""checkbox"" Name=""SelectAllEvents"" onClick=""makeCheckEvent(this.form)"" id=SelectAllEvents></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Subscription</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Venue</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Date/Time</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=""2""><B>Quantity</B></FONT></TD></TR>" & vbCrLf

		'Display Event and UnPrinted Ticket Quantities
		Do Until rsTickets.EOF

			Response.Write "<TR BGCOLOR=""DDDDDD""><TD ALIGN=""center""><INPUT TYPE=""checkbox"" NAME=""EventCode"" VALUE=" & rsTickets("EventCode") & "></FONT></TD><TD><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">" & rsTickets("Act") & "</FONT></TD><TD><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">" & rsTickets("Venue") & "</FONT></TD><TD ALIGN=""center"" NOWRAP><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">" & DateAndTimeFormat(rsTickets("EventDate")) & "</FONT></TD><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">" & rsTickets("TicketCount") & "</FONT></TD></TR>" & vbCrLf

			rsTickets.MoveNext

		Loop
			
		Response.Write "</TABLE><BR>" & vbCrLf
		'Display Buttons to Print
		Response.Write "<FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">Select Events to print and click 'Print' below.</FONT><BR><BR>" & vbCrLf
		Response.Write "<INPUT TYPE=""submit"" VALUE=""Print""></FORM>" & vbCrLf
	Else 'There aren't any matching events
		Response.Write "<BR><BR><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">There are no events to be printed.</FONT><BR><BR>" & vbCrLf
	End If
Else 'There aren't any matching events
	Response.Write "<BR><BR><FONT FACE=""verdana,arial,helvetica"" COLOR=""#000000"" SIZE=""2"">There are no events to be printed.</FONT><BR><BR>" & vbCrLf
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
<TITLE>Tix - Subscription Renewal Letters</TITLE>
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
    div
    {
        page-break-before: always;
    }

    body, td
    {
        font-size: 17px;
        font-family: "Times New Roman", Times, serif
    }

    .smalltable td
    {
		font-family: Arial, Helvetica;
        font-size: 13px;
    }
</STYLE>

<STYLE>

@page  
{ 
	/* auto is the initial value */ 
    size: auto; 
	
	html 
	{ 
	overflow: auto; 
	padding: 5mm;
	}
		
	body 
	{ 
	width: 8.5in; 
	height: 11in; 
	margin: 0mm 0mm 0mm 0mm; 
	}
}


</STYLE>

<style>

#customers 
{
font-family:Arial, Helvetica, sans-serif;
width: 100%;
border-collapse: collapse;
border: 2px solid #000000;
background-color: #cccccc;
}

#customers th
{
font-style: italic;
}

#customers th 
{
text-align: left;
padding-top: 5px;
padding-bottom: 4px;
color: #000000;
}

#customers tr td.alt
{
color: #000000;
font-family:"Courier New", Courier, monospace;
}
</style>

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
SQLOrderLine = SQLOrderLine & SQLWhere & ") AND OrderLine.StatusCode = 'R' AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') ORDER BY OrderLine.OrderNumber, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry, OrderLine.ShipCode, Seat.EventCode, Seat.SectionCode, RowSort, SeatSort DESC"
Set rsOrderLine = OBJdbConnection.Execute(SQLOrderLine)
		
Call DBOpen(OBJdbConnection2)
		
Do Until rsOrderLine.EOF

	If rsOrderLine("OrderNumber") <> LastOrderNumber Then 'It's different.  Print it.
		If TicketCount > 0 Then 'It's not the first one, print the footer.
            Call PrintFooter
		End If
				
		SQLCustInfo = "SELECT Customer.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry FROM OrderHeader (NOLOCK) INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber WHERE OrderHeader.OrderNumber = " & rsOrderLine("OrderNumber") & " AND OrderLine.LineNumber = " & rsOrderLine("LineNumber")
		Set rsCustInfo = OBJdbConnection.Execute(SQLCustInfo)

		If Not rsCustInfo.EOF Then

            %>
            <!--#INCLUDE FILE="RenewalLetterInclude_Flex.asp"-->
            <%		

			SQLItemNumber = "SELECT ItemNumber FROM OrderLine (NOLOCK) WHERE OrderNumber = " & rsOrderLine("OrderNumber") & " ORDER BY ItemNumber"
			Set rsItemNumber = OBJdbConnection.Execute(SQLItemNumber)
			
			RenewalCode = rsCustInfo("CustomerNumber") & rsItemNumber("ItemNumber")
			
			rsItemNumber.Close
			Set rsItemNumber = nothing
			
			'Letterhead / Logo Image
            'Response.Write "<table width=""750""><tr><td align=""center"" colspan=""2""><img src=" & LogoImage & " width=""350""><br /><b>PO Box 62, Centerville, UT  84014 - www.CPTUtah.org</b><br /></td></tr></table><br />" & vbCrLf
			
			'Blank spacer to allow pre-printed logo image
           ' Response.Write "<table width=""750""><tr><td align=""center"" colspan=""2""><img src=""images/clear.gif"" height=""80""><br /></td></tr></table><br />" & vbCrLf
			
			Response.Write "<TABLE WIDTH=""750""><TR><TD WIDTH=""400""><B>Shipping Information</B></TD><TD WIDTH=""300""><B>Billing Information</B></TD></TR>"
			Response.Write "<TR><TD>" & rsCustInfo("ShipFirstName") & " " & rsCustInfo("ShipLastName") & "<BR>" & rsCustInfo("ShipAddress1") & "<BR>" & vbCrLf
			If rsCustInfo("ShipAddress2") <> "" Then
				Response.Write rsCustInfo("ShipAddress2") & "<BR>" & vbCrLf
			End If
			Response.Write rsCustInfo("ShipCity") & ", " & rsCustInfo("ShipState") & " " & rsCustInfo("ShipPostalCode") & "</TD><TD>" & rsCustInfo("FirstName") & " " & rsCustInfo("LastName") & "<BR>" & rsCustInfo("Address1") & "<BR>" & vbCrLf
			If rsCustInfo("Address2")<> "" Then
				Response.Write rsCustInfo("Address2") & "<BR>" & vbCrLf
			End If
			Response.Write rsCustInfo("City") & ", " & rsCustInfo("State") & " " & rsCustInfo("PostalCode") & "</TD></TR></TABLE><BR>" & vbCrLf

			Response.Write "<TABLE WIDTH=""750"">" & vbCrLf
			Response.Write "<TR><hr></TD></TR>" & vbCrLf
			Response.Write "<TR><TD ALIGN=""left""><B>Order Number:&nbsp;" & rsOrderLine("OrderNumber") & "</B></TD><TD ALIGN=""right""><B>Renewal Code:&nbsp;" & RenewalCode & "</B></TD>" & vbCrLf
			Response.Write "</TABLE>" & vbCrLf

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
		
		If rsOrderLine("OrderSurcharge") > 0 Then
			LastTotal = LastTotal - rsOrderLine("OrderSurcharge")
		End If

		TicketCount = TicketCount + 1

        If TicketCount Mod 100 = 0 Then 
            Response.Flush
        End If

	End If

	'Print Event Info and Column Headings if this is a new Event
	If LastEventCode <> rsOrderLine("EventCode") Or LastOrderNumber <> rsOrderLine("OrderNumber") Then
		Response.Write "<TABLE WIDTH=""750""><TR><TD><B>" & rsOrderLine("Act") & " at " & rsOrderLine("Venue")
		
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
			Response.Write " at " & Left(FormatDateTime(rsOrderLine("EventDate"),vbLongTime),Len(FormatDateTime(rsOrderLine("EventDate"),vbLongTime))-6) & "&nbsp;" & Right(FormatDateTime(rsOrderLine("EventDate"),vbLongTime),2)
		End If
		rsTimeSuppress.Close
		Set rsTimeSuppress = nothing

		Response.Write "</B><BR>Delivery Method: " & rsOrderLine("ShipType") & "</TD></TR></TABLE>" & vbCrLf

		'Calculate Number of Columns
		SQLNumColumns = "SELECT SUM(OrderLine.Surcharge) AS ServiceFee, SUM(OrderLine.Discount) AS Discount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & rsOrderLine("OrderNumber") & " AND ItemType IN ('Seat', 'SubFixedEvent')"
		Set rsNumColumns = OBJdbConnection.Execute(SQLNumColumns)

        NumColumns = 6
		ColFacilityCharge = "N"
		ColServiceFee = "N"
		ColDiscount = "N"

		ColumnHeading = "<TABLE WIDTH=""750"" BORDER=""0""><TR><TD><B><U>Section</U></B></TD><TD ALIGN=center><B><U>Row</U></B></TD><TD ALIGN=center><B><U>Seat</U></B></TD><TD><B><U>Type</U></B></TD><TD ALIGN=right><B><U>Price</U></B></TD>"

		FacilityCharge = 0
		If FacilityCharge <> 0 Then
			NumColumns = NumColumns + 1
			ColumnHeading = ColumnHeading + "<TD ALIGN=right><B><U>Facility Charge</U></B></TD>"
			ColFacilityCharge = "Y"
		End If
		If rsNumColumns("ServiceFee") > 0 Then
			'NumColumns = NumColumns + 1
			'ColumnHeading = ColumnHeading + "<TD ALIGN=right><B><U>Service Fee</U></B></TD>"
			'ColServiceFee = "Y"
		End If
		If rsNumColumns("Discount") <> 0 Then
			NumColumns = NumColumns + 1
			ColumnHeading = ColumnHeading + "<TD ALIGN=right><B><U>Discount</U></B></TD>"
			ColDiscount = "Y"
		End If

		rsNumColumns.Close
		Set rsNumColumns = nothing

		ColumnHeading = ColumnHeading + "<TD ALIGN=right><B><U>Amount</U></B></TD></TR>" & vbCrLf
		
		Response.Write ColumnHeading

		LastEventCode = rsOrderLine("EventCode")
	End If
			
	'Print the detail
	'Add the OrderNumber and LineNumber to the Form
	LineDetail = "<TR><TD>" & rsOrderLine("Section") & "</TD><TD ALIGN=center>" & rsOrderLine("Row") & "</TD><TD ALIGN=center>" & rsOrderLine("Seat") & "</TD><TD>" & rsOrderLine("SeatType") & "</TD><TD ALIGN=right>" & FormatCurrency(rsOrderLine("Price"),2) & "</TD>"
	
	If ColFacilityCharge = "Y" Then
		LineDetail = LineDetail & "<TD ALIGN=right>" & FormatCurrency(FacilityCharge,2) & "</TD>"
	End If
	If ColServiceFee = "Y" Then
		LineDetail = LineDetail & "<TD ALIGN=right>" & FormatCurrency(rsOrderLine("Surcharge"),2) & "</TD>"
	End If
	If ColDiscount = "Y" Then
		LineDetail = LineDetail & "<TD ALIGN=right>" & FormatCurrency(rsOrderLine("Discount"),2) & "</TD>"
	End If
	
	LineDetail = LineDetail & "<TD ALIGN=right>" & FormatCurrency(rsOrderLine("Price")-rsOrderLine("Discount"),2) & "</TD></TR>" & vbCrLf
	
	Response.Write LineDetail

	LastOrderNumber = rsOrderLine("OrderNumber")
	
	rsOrderLine.MoveNext
		
Loop	
	
If TicketCount > 0 Then	'Print the last footer
    Call PrintFooter
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
'------------------------------------------------------------------------------

Sub PrintFooter

Response.Write "<TR><TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf			
If LastShipFee <> 0 And LastOrderTypeNumber <> 5 Then
	Response.Write "<TR><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """>Processing Fee</TD><TD ALIGN=""right"">" & FormatCurrency(LastShipFee,2) & "</TD></TR>" & vbCrLf
	Response.Write "<TR><TD COLSPAN=""" & NumColumns - 1 & """>&nbsp;</TD><TD><HR></TD></TR>" & vbCrLf
End If

Response.Write "<TR><TD ALIGN=""right"" COLSPAN=""" & NumColumns - 1 & """>Total</TD><TD ALIGN=""right"">" & FormatCurrency(LastTotal,2) & "</TD></TR>" & vbCrLf

Response.Write "</TABLE>" & vbCrLf

Response.Write "<TABLE WIDTH=""750"" >" & vbCrLf
Response.Write "<TR><TD COLSPAN=""3"">Make checks payable to " & OrganizationName & vbCrLf
Response.Write "<TR><TD COLSPAN=""3"">I prefer to pay by:&nbsp;&nbsp;[&nbsp;&nbsp;] MasterCard&nbsp;&nbsp;&nbsp;[&nbsp;&nbsp;] Visa&nbsp;&nbsp;&nbsp;[&nbsp;&nbsp;] American Express&nbsp;&nbsp;&nbsp;[&nbsp;&nbsp;] Discover</TD></TR>" & vbCrLf
Response.Write "<TR><TD COLSPAN=""3""><BR>_____ _____ _____ _____ -  _____ _____ _____ _____ -  _____ _____ _____ _____ -  _____ _____ _____ _____</TD></TR>" & vbCrLf
Response.Write "<TR><TD COLSPAN=""3"">(Card Number)<BR></TD></TR>" & vbCrLf
Response.Write "<TR><TD>_________________&nbsp;&nbsp;</TD>"
Response.Write "<TD>_______________________________________________&nbsp;&nbsp;</TD>"
Response.Write "<TD>_______________________________________________</TD></TR>"
Response.Write "<TR><TD>(Expiration Date)</TD>" & vbCrLf
Response.Write "<TD>(Print Name as it appears on card)</TD>" & vbCrLf
Response.Write "<TD>(Signature)</TD></TR></TABLE><BR>" & vbCrLf
Response.Write "<TABLE WIDTH=""750""><TR><TD ALIGN=""center""><BR><BR>" & SendTo & "</TD></TR></TABLE>" & vbCrLf
Response.Write "</CENTER>" & vbCrLf
Response.Write "<div>&nbsp;</div>" & vbCrLf


End Sub 'PrintFooter

%>