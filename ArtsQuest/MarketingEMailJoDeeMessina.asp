<!--METADATA TYPE="typelib" UUID="CD000000-8B95-11D1-82DB-00C04FB1625D"  NAME="CDO for Windows 2000 Library" -->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp"-->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<HTML>
<HEAD>
<TITLE>TIX - Event E-Mail</TITLE>
</HEAD>
<BODY BGCOLOR="#FFFFFF">

<!--#include virtual="TopNavInclude.asp" -->

<BR>

<BR>

<FONT FACE=verdana,arial,helvetica COLOR=#008400><H3>Event E-Mail</H3></FONT>

<%
Page = "ManagementReport"

Server.ScriptTimeout = 60 * 30 '30 Minutes

If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then Response.Redirect("/Management/Default.asp")

If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then Response.Redirect("/Management/Default.asp")

EMailText = "Country superstar JoDee Messina is coming to Musikfest 2005!  Don’t miss your chance to see JoDee Messina take Bethlehem by storm, as she rocks the Straub Chrysler Jeep RiverPlace stage!  Her ‘Give a Damn’ may be busted, but her show definitely doesn’t need any fixin’!" & vbCrLf & vbCrLf
EMailText = EMailText & "For limited time only, when you buy one ticket for the JoDee Messina concert at Musikfest, you will get one FREE!  This exclusive offer is valid only for online ticket orders placed using the special promotion code listed below.  Log onto to www.fest.org to place your order today. " & vbCrLf & vbCrLf
EMailText = EMailText & "Offer ends Aug. 3." & vbCrLf & vbCrLf
EMailText = EMailText & "To take advantage of this offer, add two tickets to your shopping cart and enter the Promotional Code below and you'll receive one of the tickets for free during checkout." & vbCrLf & vbCrLf
EMailText = EMailText & "Promotion Code: aqjd241" & vbCrLf & vbCrLf
EMailText = EMailText & "Musikfest, America’s Music Festival, takes place Aug. 5-14 this year. The festival features more than 300 musical performers on 13 indoor and outdoor stages throughout Bethlehem’s historic downtown. In addition, the 10-day event showcases a wide variety of food, children’s activities, visual arts and crafts and a closing-night fireworks spectacular.  For more information log onto www.fest.org or call 610-332-FEST." & vbCrLf & vbCrLf

ReplyAddress = "sales@fest.org"
Subject = "Musikfest Special Offer"
EMailBody = EMailText

SQLCustomer = "SELECT     Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, Customer.DayPhone, Customer.NightPhone, Customer.EMailAddress FROM         Customer WITH (NOLOCK) INNER JOIN OrderHeader WITH (NOLOCK) ON Customer.CustomerNumber = OrderHeader.CustomerNumber INNER JOIN Seat WITH (NOLOCK) ON OrderHeader.OrderNumber = Seat.OrderNumber INNER JOIN Event WITH (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationVenue WITH (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct WITH (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode AND  OrganizationVenue.OrganizationNumber = OrganizationAct.OrganizationNumber INNER JOIN CustomerMailingList WITH (NOLOCK) ON Customer.CustomerNumber = CustomerMailingList.CustomerNumber WHERE     (Customer.CustomerNumber NOT IN (SELECT     CustomerNumber FROM          OrderHeader INNER JOIN Seat ON OrderHeader.OrderNumber = Seat.OrderNumber WHERE      Seat.EventCode IN (29679, 29673, 29676))) AND (OrganizationVenue.OrganizationNumber = 9) AND  (OrganizationAct.OrganizationNumber = 9) AND (OrderHeader.StatusCode = 'S') AND (CustomerMailingList.OrganizationNumber IN (0, 9)) AND  (CustomerMailingList.OptInFlag = 'Y') AND (Event.EventCode IN (3420, 3426, 12497, 12504, 26394, 26483, 26490, 26590)) AND (Customer.EMailAddress <> '') GROUP BY Customer.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State,  Customer.PostalCode, Customer.Country, Customer.DayPhone, Customer.NightPhone, Customer.EMailAddress, Customer.DateEntered ORDER BY Customer.LastName, Customer.FirstName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode,  Customer.Country, Customer.DayPhone, Customer.NightPhone, Customer.EMailAddress "
Set rsCustomer = OBJdbConnection.Execute(SQLCustomer)

SentCount = 0
NotSentCount = 0

Do Until rsCustomer.EOF

	
	If InStr(1, rsCustomer("EMailAddress"), "@") <> 0 Then 'There's an e-mail address.  Send the E-Mail message.
	
	
			Greeting = "Dear " & rsCustomer("FirstName") & " " & rsCustomer("LastName") & ":" & vbCrLf & vbCrLf
	
			'Create the e-mail server object
			Set objCDOSYSMail = Server.CreateObject("CDO.Message")
			Set objCDOSYSCon = Server.CreateObject ("CDO.Configuration")
			objCDOSYSCon.Fields(cdoSendUsingMethod) = cdoSendUsingPickup 'For localhost
			objCDOSYSCon.Fields.Update

			'Update the CDOSYS Configuration
			Set objCDOSYSMail.Configuration = objCDOSYSCon
			objCDOSYSMail.From = "no_reply@tix.com" 
			objCDOSYSMail.ReplyTo = ReplyAddress
			objCDOSYSMail.To = rsCustomer("EMailAddress")
'			objCDOSYSMail.To = "robert.edmison@tix.com" 'Testing Only
			If SentCount = 0 Then 'BCC info@tix.com on the first one.
				objCDOSYSMail.Bcc = "info@tix.com," & ReplyAddress
			End If
							
			objCDOSYSMail.Subject = Subject
			objCDOSYSMail.TextBody = Greeting & EMailBody & Disclaimer(rsCustomer("EMailAddress"))
			objCDOSYSMail.Send

			'Close the server mail object
			Set objCDOSYSMail = Nothing
			Set objCDOSYSCon = Nothing 
			
			SentCount = SentCount + 1
'Response.Write rsCustomer("EMailAddress") & "<BR>"
			
	Else 'There's no e-mail address.  List customer information so they can be contacted via another means.
	
		NotSentCount = NotSentCount + 1

'		Response.Write "<B>" & rsCustomer("FirstName") & " " & rsCustomer("LastName") & " " & rsCustomer("EMailAddress") & " - Not Sent</B><BR>"
	
	End If
	
	rsCustomer.MoveNext
	
Loop

Response.Write "<BR><BR><B>SentCount = " & SentCount & "</B><BR>"
Response.Write "<BR><BR><B>NotSentCount = " & NotSentCount & "</B><BR>"

%>

</CENTER>
<BR>
<BR>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%
	
'=================================

Public Function Disclaimer(EMailAddress)

Disclaimer = vbCrLf & vbCrLf & vbCrLf & vbCrLf
Disclaimer = Disclaimer & "----------------------------------------------" & vbCrLf
Disclaimer = Disclaimer & "You received this e-mail because you previously purchased tickets to Bethlehem Musikfest and asked to be included on the mailing list.  If you'd like to be removed from our mailing list, please click on the link below or cut and paste the link into your browser." & vbCrLf
Disclaimer = Disclaimer & "http://musikfest.tix.com/optout.asp?EMailAddress=" & EMailAddress & vbCrLf
Disclaimer = Disclaimer & "----------------------------------------------" & vbCrLf & vbCrLf

End Function


%>
