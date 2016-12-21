<!--#INCLUDE virtual=GlobalInclude.asp -->
<!--#INCLUDE virtual="dbOpenInclude.asp"-->
<!--#INCLUDE virtual="dgChargeUtilityInclude.asp"-->
<!--#INCLUDE virtual="NoCacheInclude.asp"-->
<%
'REE 4/6/2 - Added check for session organization number
If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then Response.Redirect("/Management/Default.asp")

OrderQuantity = 0
FontFace = "verdana,arial,helvetica"
FontColor = "#000000"

%>

<HTML>
<HEAD>
<CENTER>
<TITLE>www.TIX.com - American University's Greenberg Theatre Letter</TITLE>
</HEAD>
<BODY>
<BR>
<BR>
<FONT FACE="verdana,arial,helvetica" COLOR="green"><H3>www.TIX.com - American University's Greenberg Theatre Letter</H3>
<%
Response.Write "<FONT FACE=verdana,arial,helvetica COLOR=#000000 SIZE=""2"">Begin Time:" & FormatDateTime(Now()) & "<BR>" & vbCrLf

Call Connect_dgChargeDB()

SQLdgcTrans = "SELECT CustomerID AS OrderNumber FROM dgcTransaction (NOLOCK) WHERE SettleStatusID = 7 AND MerchantID = 3 ORDER BY CustomerID"
Set rsdgcTrans = g_cnnDB.Execute(SQLdgcTrans)

Do While Not rsdgcTrans.EOF

	OrderNumber = rsdgcTrans("OrderNumber")
	Session("OrderNumber") = OrderNumber

	SQLOrderHeader = "SELECT Total, OrderSurcharge, ShipFee, StatusCode, Discount, CustomerNumber, OrderDate, StatusCode, OrderType, Users.FirstName AS UserFirstName, Users.LastName AS UserLastName FROM OrderHeader (NOLOCK) LEFT JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber LEFT JOIN Users (NOLOCK) on OrderHeader.UserNumber = Users.UserNumber WHERE OrderNumber = " & Session("OrderNumber")
	Set rsOrderHeader = OBJdbConnection.Execute(SQLOrderHeader)

	Select Case rsOrderHeader("StatusCode")
		Case "R" 'Reserved
			strStatus = "Reserved"
		Case "C" 'Cancelled
			strStatus = "<FONT COLOR=Red>Cancelled</FONT>"
		Case "H" 'On Hold
			strStatus = "On Hold"
		Case "S" 'Shipped
			strStatus = "Complete"
		Case Else 'Pending
			strStatus = "Incomplete"
	End Select
	
	If IsNull(rsOrderHeader("UserFirstName")) And IsNull(rsOrderHeader("UserLastName")) Then
		UserName = "N/A"
	Else
		UserName = rsOrderHeader("UserFirstName") & "&nbsp;" & rsOrderHeader("UserLastName")
	End If
		
	SQLCustomer = "Select FirstName, LastName, EMailAddress, Address1, Address2, City, State, PostalCode, Country, DayPhone, NightPhone FROM Customer (NOLOCK) WHERE CustomerNumber = " & rsOrderHeader("CustomerNumber")
	Set rsCustomer = OBJdbConnection.Execute(SQLCustomer)

	'REE 11/2/2 - Modified to look for seats and donations separately.
	'REE 1/1/3 - Modified to include Subscriptions
	SQLOrganization = "SELECT TOP 1 Organization.OrganizationNumber, Organization, MerchantAccountNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN Organization (NOLOCK) ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent') AND OrganizationVenue.Owner <> 0 UNION SELECT TOP 1 Organization.OrganizationNumber, Organization, MerchantAccountNumber FROM OrderLine (NOLOCK) INNER JOIN Donation (NOLOCK) ON OrderLine.ItemNumber = Donation.ItemNumber INNER JOIN Organization (NOLOCK) ON Donation.RemittalOrganizationNumber = Organization.OrganizationNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.ItemType = 'Donation'"
	Set rsOrganization = OBJdbConnection.Execute(SQLOrganization)

	OrgEMail = "GreenbergTheatre@american.edu"
	Message = "[If you are unable to read the remainder of this message, please call the Harold and Sylvia Greenberg Theatre Box Office at (202) 885-2587, Monday through Friday, 3 pm to 6 pm for some important information regarding your recent order.  Please reference Order # " & OrderNumber & ".]"
	Message = Message & "<HTML>"
	Message = Message & "<BODY BGCOLOR=#FFFFFF>" & vbCrLf
	Message = Message & "<TABLE  WIDTH=""95%"" CELLPADDING=""10"" BORDER=""0"">" & vbCrLf
	Message = Message & "<TR><TD ALIGN=RIGHT><FONT FACE=verdana,arial,helvetica COLOR=#000000 SIZE=""2"">" & FormatDateTime(Now(), vbLongDate) & "<BR></TD></TR>" & vbCrLf & vbCrLf
	Message = Message & "<TR><TD><FONT FACE=verdana,arial,helvetica COLOR=#000000 SIZE=""2"">Box Office Management<BR>" & vbCrLf & vbCrLf
	Message = Message & "American University<BR>" & vbCrLf & vbCrLf
	Message = Message & "Harold and Sylvia Greenberg Theatre<BR>" & vbCrLf & vbCrLf
	Message = Message & "4200 Wisconsin Avenue<BR>" & vbCrLf & vbCrLf
	Message = Message & "Washington, DC  20016<BR><BR>" & vbCrLf & vbCrLf

	Message = Message & "Dear " & rsCustomer("FirstName") & " " & rsCustomer("LastName") & ",<BR><BR>" & vbCrLf & vbCrLf
	Message = Message & "Thank you for your recent patronage of American University’s Greenberg Theatre.  We’re writing because we recently discovered a problem with our credit card settlement processing system.  This has affected credit card transactions for tickets purchased between October 24, 2003 and January 26, 2004.  Regrettably, one of your transactions was affected by this problem.  Please see the order information included for your transaction below.<BR><BR>" & vbCrLf & vbCrLf
	Message = Message & "When the original ticket(s) were purchased, your card was initially verified for the amount of the sale.  Unfortunately, the settlement processing system did not properly complete the transaction, and subsequently, we were unable to collect the funds from your card.<BR><BR>" & vbCrLf & vbCrLf
	Message = Message & "In an effort to recover the sale amount, we would like to reprocess the transaction of the original ticket order on your credit card.  We apologize for any inconvenience or confusion this may cause and your understanding of this transaction is important to us.  If you deem it acceptable for us to reprocess the transaction on your original credit card, you need not do anything; we will automatically process a new transaction 14 days from the date of this letter.  <B>Note:</B> You will not be asked to verify the card number and/or expiration date you originally used for this transaction either over the phone or via e-mail.<BR><BR>" & vbCrLf & vbCrLf
	Message = Message & "If you have any questions regarding this transaction or would like to arrange for an alternate method of payment, please call us at the Theatre Box Office, (202) 885-2587 or e-mail us at <A HREF=MailTo:" & OrgEmail & ">" & OrgEmail & "</A>.  Our hours of operation are Monday through Friday, 3 pm to 6 pm.<BR><BR>" & vbCrLf & vbCrLf
	Message = Message & "We apologize for this inconvenience, and ensure you that your patronage and support is vitally important to us.  Thank you for your understanding.<BR><BR>" & vbCrLf & vbCrLf
	Message = Message & "Sincerely,<BR><BR>" & vbCrLf & vbCrLf
	Message = Message & "Box Office Management<BR>" & vbCrLf & vbCrLf
	Message = Message & "Harold and Sylvia Greenberg Theatre<BR>" & vbCrLf & vbCrLf
	Message = Message & "</TD></TR></TABLE>"

	Message = Message & "<FONT FACE=verdana,arial,helvetica COLOR=#008400><CENTER><H3>Order Details</H3></FONT>" & vbCrLf
	Message = Message & "<TABLE WIDTH=""80%"" CELLPADDING=""5"" BORDER=""0""><TR><TD>" & vbCrLf
	Message = Message & "<FONT FACE=""verdana,arial,helvetica"" SIZE=""2""><B>Order Number: </B>" & Session("OrderNumber") & "<BR><B>Customer: </B>" & rsCustomer("FirstName") & "&nbsp;" & rsCustomer("LastName") & "<BR><B>Order Type: </B>" & rsOrderHeader("OrderType") & "</FONT></TD><TD ALIGN=""right""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2""><B>Order Status: </B>" & strStatus & "<BR><B>Order Date: </B>" & DateAndTimeFormat(rsOrderHeader("OrderDate")) & "<BR><B>User: </B>" & UserName & "</FONT>" & vbCrLf
	Message = Message & "</TD></TR></TABLE>"


	'JAI 10/29/3 - Modified to include canceled order details
	'REE 4/6/2 - Modified to include OrganizationAct selection criteria
	SQLOrderLine = "SELECT OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrganizationVenue.OrganizationNumber = " & rsOrganization("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & rsOrganization("OrganizationNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent', 'SubSeat') "
	SQLOrderLine = SQLOrderLine & " UNION SELECT OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry FROM RefundOrderLine AS OrderLine(NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE OrderLine.OrderNumber = " & OrderNumber & " AND OrganizationVenue.OrganizationNumber = " & rsOrganization("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & rsOrganization("OrganizationNumber") & " AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent', 'SubSeat')"
	SQLOrderLine = SQLOrderLine & " UNION SELECT OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry FROM OrderLine (NOLOCK) INNER JOIN Donation (NOLOCK) ON OrderLine.ItemNumber = Donation.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND (Donation.OrganizationNumber = " & rsOrganization("OrganizationNumber") & " OR Donation.RemittalOrganizationNumber = " & rsOrganization("OrganizationNumber") & " OR " & rsOrganization("OrganizationNumber") & " = 1) AND OrderLine.ItemType = 'Donation'"
	SQLOrderLine = SQLOrderLine & " UNION SELECT OrderLine.ShipFirstName, OrderLine.ShipLastName, OrderLine.ShipAddress1, OrderLine.ShipAddress2, OrderLine.ShipCity, OrderLine.ShipState, OrderLine.ShipPostalCode, OrderLine.ShipCountry FROM RefundOrderLine AS OrderLine (NOLOCK) INNER JOIN Donation (NOLOCK) ON OrderLine.ItemNumber = Donation.ItemNumber WHERE OrderLine.OrderNumber = " & OrderNumber & " AND (Donation.OrganizationNumber = " & rsOrganization("OrganizationNumber") & " OR Donation.RemittalOrganizationNumber = " & rsOrganization("OrganizationNumber") & " OR " & rsOrganization("OrganizationNumber") & " = 1) AND OrderLine.ItemType = 'Donation'"
	Set rsOrderLine = OBJdbConnection.Execute(SQLOrderLine)

	If Not rsOrderLine.EOF and (rsOrderHeader("StatusCode") = "S" Or rsOrderHeader("StatusCode") = "R" Or rsOrderHeader("StatusCode") = "C") Then 'It found the Order and it matched the User's organization

		ShipAddress = "N"
		Do Until rsOrderLine.EOF
			If rsOrderLine("ShipFirstName") <> "" Then 
				ShipAddress = "Y"
				Exit Do
			Else
				rsOrderLine.MoveNext
			End If
		Loop
		
		Message = Message & "<TABLE WIDTH=80% CELLPADDING=5>" 
		Message = Message & "<TR><TD VALIGN=top BGCOLOR=#008400><FONT FACE=verdana,arial,helvetica COLOR=#FFFFFF SIZE=2><B>Billing Information</B></FONT></TD>" & vbCrLf
		Message = Message & "<TD VALIGN=top BGCOLOR=#008400><FONT FACE=verdana,arial,helvetica COLOR=#FFFFFF SIZE=2><B>Shipping Information</B></FONT></TD></TR>" & vbCrLf

		Message = Message & "<TR><TD VALIGN=top BGCOLOR=#DDDDDD><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsCustomer("FirstName") & "&nbsp;" & rsCustomer("LastName") & "<BR>" & vbCrLf
		Message = Message & rsCustomer("Address1") & "<BR>" & vbCrLf
		If rsCustomer("Address2") <> "" Then Message = Message & rsCustomer("Address2") & "<BR>" & vbCrLf
		Message = Message & rsCustomer("City") & ", " & rsCustomer("State") & " " & rsCustomer("PostalCode") & "<BR>" & vbCrLf
		If rsCustomer("Country") <> "" Then Message = Message & rsCustomer("Country") & "<BR>" & vbCrLf
		Message = Message & "Day Phone: " & FormatPhone(rsCustomer("DayPhone"),rsCustomer("Country")) & "<BR>" & vbCrLf
		Message = Message & "Evening Phone: " & FormatPhone(rsCustomer("NightPhone"),rsCustomer("Country")) & "<BR>" & vbCrLf
		Message = Message & "E-Mail Address: " & rsCustomer("EMailAddress") & "<BR></TD>" & vbCrLF	
		If ShipAddress = "Y" Then
			Message = Message & "<TD VALIGN=top BGCOLOR=#DDDDDD><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsOrderLine("ShipFirstName") & "&nbsp;" & rsOrderLine("ShipLastName") & "<BR>" & vbCrLf
			Message = Message & rsOrderLine("ShipAddress1") & "<BR>" & vbCrLf
			If rsOrderLine("ShipAddress2") <> "" Then Message = Message & rsOrderLine("ShipAddress2") & "<BR>" & vbCrLf
			Message = Message & rsOrderLine("ShipCity") & ", " & rsOrderLine("ShipState") & " " & rsOrderLine("ShipPostalCode") & "<BR>" & vbCrLf
			If rsOrderLine("ShipCountry") <> "" Then Message = Message & rsOrderLine("ShipCountry") & "</FONT>" & vbCrLf
		Else' Same As Billing
			Message = Message & "<TD VALIGN=top BGCOLOR=#DDDDDD><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsCustomer("FirstName") & "&nbsp;" & rsCustomer("LastName") & "<BR>" & vbCrLf
			Message = Message & rsCustomer("Address1") & "<BR>" & vbCrLf
			If rsCustomer("Address2") <> "" Then Message = Message & rsCustomer("Address2") & "<BR>" & vbCrLf
			Message = Message & rsCustomer("City") & ", " & rsCustomer("State") & " " & rsCustomer("PostalCode") & "<BR>" & vbCrLf
			If rsCustomer("Country") <> ""  Then Message = Message & rsCustomer("Country") & "</FONT>" & vbCrLf
		End If
		Message = Message & "</TD></TR></TABLE>" & vbCrLf
	End If
	rsOrderLine.Close
	Set rsOrderLine = nothing

	OrderDetails = "<CENTER><TABLE WIDTH=""80%"" CELLPADDING=""5"" BORDER=""0"">" & vbCrLf
	%>
	<!--#INCLUDE virtual="OrderDetailsIncludeEMail.asp"-->
	<%

	Message = Message & OrderDetails
	Message = Message & "</TABLE><BR><BR>"
	Message = Message & "<TABLE WIDTH=""80%""><TR><TD><FONT FACE=" & FontFace & " COLOR=" & FontColor & " SIZE=""2"">"
	Message = Message & "<FONT FACE=verdana,arial,helvetica COLOR=#000000 SIZE=""2"">Please Note:  Your credit card statement will reflect a charge from " & rsOrganization("Organization") & " for the amount stated above.<BR><BR>" & vbCrLf
	Message = Message & "</FONT></TD></TR></TABLE></CENTER>" & vbCrLf
	Message = Message & "</BODY>" & vbCrLf
	Message = Message & "</HTML>" & vbCrLf
	rsOrganization.Close
	Set rsOrganization = nothing

	Set Mail = CreateObject("CDONTS.NewMail")
	Mail.From="GreenbergTheatre@american.edu"
	Mail.To=rsCustomer("EMailAddress")
	Mail.Subject="An Important Message From American University’s Greenberg Theatre - Order # " & OrderNumber
	Mail.BodyFormat=0
	Mail.MailFormat=0
	Mail.Body=Message
	Mail.Send
	set Mail=nothing

	rsCustomer.Close
	Set rsCustomer = nothing
	rsOrderHeader.Close
	Set rsOrderHeader = nothing

	SQLUpdatedgcTrans = "UPDATE dgcTransaction SET SettleStatusID = 8 WHERE SettleStatusID = 7 AND CustomerID =" & OrderNumber
	Set rsUpdatedgcTrans = g_cnnDB.Execute(SQLUpdatedgcTrans)

	OrderQuantity = OrderQuantity + 1
	rsdgcTrans.MoveNext
Loop

Response.Write "<FONT FACE=verdana,arial,helvetica COLOR=#000000 SIZE=""2"">Order E-Mails Sent:" & OrderQuantity & "<BR>" & vbCrLf
Response.Write "<FONT FACE=verdana,arial,helvetica COLOR=#000000 SIZE=""2"">End Time:" & FormatDateTime(Now()) & "<BR>" & vbCrLf

%>
</CENTER>
</BODY>
</HTML>
<%

Session.Contents.Remove OrderNumber
OBJdbConnection.Close
Set OBJdbConnection = nothing
%>