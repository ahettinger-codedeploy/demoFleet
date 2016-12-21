<!--METADATA TYPE="typelib" UUID="CD000000-8B95-11D1-82DB-00C04FB1625D"  NAME="CDO for Windows 2000 Library" -->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp"-->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<%
Page = "ManagementReport"

Server.ScriptTimeout = 60 * 20 '20 Minutes

If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then Response.Redirect("/Management/Default.asp")

If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then Response.Redirect("/Management/Default.asp")

Select Case Clean(Request("FormName"))
	Case "EventSelection"
		Call EMailText
	Case "EMailText"
		Call Confirmation
	Case "Confirmation"
		Call SendEMail
	Case "SendEMail"
		Call DisplayCustomerInfo
	Case Else
		Call EventSelection(Message)
End Select

'=================================

Sub EventSelection(Message)
%>
<HTML>
<HEAD>
<TITLE>TIX - Event E-Mail</TITLE>
<script LANGUAGE="JavaScript">    

<!-- Hide code from non-js browsers

function makeCheck(thisForm)
{
for (i = 0; i < thisForm.EventCode.length; i++)
	{
	thisForm.EventCode[i].checked=true
	}
}

// end hiding -->
</script>
<style type="text/css">
<!--
a.sort:link  {color: #FFFFFF; font-weight: bold; text-decoration: underline;}
a.sort:visited  {color: #FFFFFF; font-weight: bold; text-decoration: underline;}
a.sort:active  {color: #FFFFFF; font-weight: bold; text-decoration: underline;}
a.sort:hover  {color: #FFFFFF; font-weight: bold; text-decoration: underline;}
-->
</style>
</HEAD>
<%
If Message <> "" Then
	Response.Write "<BODY BGCOLOR=""#FFFFFF"" onLoad=""alert('" & Message & "')"">" & vbCrLf
Else
	Response.Write "<BODY BGCOLOR=""#FFFFFF"">" & vbCrLf
End If
%>

<CENTER>

<!--#include virtual="TopNavInclude.asp" -->

<BR>

<BR>

<FONT FACE="verdana,arial,helvetica" COLOR="#008400"><H3>Event E-Mail</H3></FONT>
<FONT FACE="verdana,arial,helvetica" SIZE="2">
<FORM ACTION="EventEMail.asp" METHOD="post" NAME="Report"><INPUT TYPE="hidden" NAME="FormName" VALUE="EventSelection">

<%
'Get all events for Organization

'REE 6/30/3 - Added OrganizationOption ReportArchiveDays
'If there's an entry use it.  Otherwise use -31
SQLArchiveDays = "SELECT OptionValue FROM OrganizationOptions (NOLOCK) WHERE OrganizationNumber = " & Session("OrganizationNumber") & " AND OptionName = 'ReportArchiveDays'"
Set rsArchiveDays = OBJdbConnection.Execute(SQLArchiveDays)

If Not rsArchiveDays.EOF Then
	ArchiveDays = rsArchiveDays("OptionValue")
Else
	ArchiveDays = 31
End If

rsArchiveDays.Close
Set rsArchiveDays = nothing


'REE 4/6/2 - Modified to include OrganizationAct selection criteria
Select Case Request("SortMethod")
	Case "Act"
		SQLEvents = "SELECT Event.EventCode, Act, Venue, EventDate FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE EventDate > GETDATE()-" & ArchiveDays & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " ORDER BY Act, Venue, EventDate"
	Case "Venue"
		SQLEvents = "SELECT Event.EventCode, Act, Venue, EventDate FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE EventDate > GETDATE()-" & ArchiveDays & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " ORDER BY Venue, EventDate"
	Case Else
		SQLEvents = "SELECT Event.EventCode, Act, Venue, EventDate FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE EventDate > GETDATE()-" & ArchiveDays & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " ORDER BY EventDate, Act"
End Select
Set rsEvents = OBJdbConnection.Execute(SQLEvents)

Response.Write "<TABLE CELLPADDING=""3""><TR><TD COLSPAN=""2""><INPUT TYPE=button VALUE=""Select All"" onclick=""makeCheck(this.form)"" id=button1 name=button1><INPUT TYPE=reset VALUE=""Clear All"" id=reset1 name=reset1></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=""#008400""><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=#FFFFFF SIZE=""2""><B>X</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><A class=sort HREF=EventEMail.asp?SortMethod=Date>Date/Time</A></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><A class=sort HREF=EventEMail.asp?SortMethod=Act>Production</A></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><A class=sort HREF=EventEMail.asp?SortMethod=Venue>Venue</A></FONT></TD></TR>" & vbCrLf


Do Until rsEvents.EOF

	Response.Write "<TR BGCOLOR=""#DDDDDD""><TD><INPUT TYPE=""checkbox"" NAME=""EventCode"" VALUE=" & rsEvents("EventCode") & "></TD><TD NOWRAP><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & DateAndTimeFormat(rsEvents("EventDate")) & "</FONT></TD><TD><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsEvents("Act") & "</FONT></TD><TD><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsEvents("Venue") & "</FONT></TD></TR>" & vbCrLf
	rsEvents.MoveNext
	
Loop
Response.Write "<TR><TD COLSPAN=""2""><INPUT TYPE=button VALUE=""Select All"" onclick=""makeCheck(this.form)""><INPUT TYPE=reset VALUE=""Clear All""></TD></TR>" & vbCrLf
Response.Write "</TABLE></CENTER><LEFT><BR>" & vbCrLf

Response.Write "<CENTER><INPUT TYPE=submit VALUE=Submit></FORM><BR><BR>" & vbCrLf

Response.Write "</FONT></CENTER><BR><BR>" & vbCrLf

%>
<!--#INCLUDE virtual="FooterInclude.asp"-->
<%

Response.Write "</BODY>" & vbCrLf
Response.Write "</HTML>" & vbCrLf

End Sub 'Display Event Selection

'=================================

Sub EMailText

%>
<HTML>
<HEAD>
<TITLE>TIX - Event E-Mail</TITLE>
</HEAD>
<BODY BGCOLOR="#FFFFFF">
<CENTER>
<!--#include virtual="TopNavInclude.asp" -->

<BR>

<BR>

<FONT FACE=verdana,arial,helvetica COLOR=#008400><H3>Event E-Mail</H3></FONT>
<FORM ACTION="EventEMail.asp" METHOD="post" NAME="Report"><INPUT TYPE="hidden" NAME="FormName" VALUE="EMailText">

<INPUT TYPE="hidden" NAME="EventCode" VALUE="<%= Clean(Request("EventCode")) %>">

<TABLE WIDTH="600">
<TR><TD ALIGN="right"><FONT FACE=verdana,arial,helvetica SIZE=2><B>Reply E-Mail Address:</B></FONT></TD><TD><INPUT TYPE="text" NAME="ReplyAddress" SIZE="40"></TD></TR>
<TR><TD ALIGN="right"><FONT FACE=verdana,arial,helvetica SIZE=2><B>Subject:</B></FONT></TD><TD><INPUT TYPE="text" NAME="Subject" SIZE="40"></TD></TR>
<TR><TD COLSPAN=2"><TEXTAREA NAME="EMailText" COLS="60" ROWS="20"></TEXTAREA></TD></TR>
</TABLE>
<BR>

<INPUT TYPE="submit" VALUE="Continue"></FORM>

</CENTER>

<BR>
<BR>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%
End Sub 'EMail Text

'=================================

Sub Confirmation

EMailTextConfirm = "Dear [Customer Name]: " & vbCrLf & vbCrLf & Clean(Request("EMailText")) & Disclaimer()

%>

<HTML>
<HEAD>
<TITLE>TIX - Event E-Mail</TITLE>
</HEAD>
<BODY BGCOLOR="#FFFFFF">
<!--#include virtual="TopNavInclude.asp" -->

<BR>

<BR>

<FONT FACE=verdana,arial,helvetica COLOR=#008400><H3>Event E-Mail</H3></FONT>
<FORM ACTION="EventEMail.asp" METHOD="post" NAME="Report"><INPUT TYPE="hidden" NAME="FormName" VALUE="Confirmation">

<INPUT TYPE="hidden" NAME="EventCode" VALUE="<%= Clean(Request("EventCode")) %>">
<INPUT TYPE="hidden" NAME="ReplyAddress" VALUE="<%= Clean(Request("ReplyAddress")) %>">
<INPUT TYPE="hidden" NAME="Subject" VALUE="<%= Clean(Request("Subject")) %>">
<INPUT TYPE="hidden" NAME="EMailText" VALUE="<%= Clean(Request("EMailText")) %>">

<FONT FACE=verdana,arial,helvetica SIZE=2>Confirm the Information Below and Click "Send" or "Cancel".</FONT><BR><BR>

<TABLE WIDTH="600">
<TR><TD ALIGN="right"><FONT FACE=verdana,arial,helvetica SIZE=2><B>Reply E-Mail Address:</B></FONT></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2><%= Clean(Request("ReplyAddress")) %></FONT></TD></TR>
<TR><TD ALIGN="right"><FONT FACE=verdana,arial,helvetica SIZE=2><B>Subject:</B></FONT></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2><%= Clean(Request("Subject")) %></FONT></TD></TR>
<TR><TD COLSPAN=2"><BR><FONT FACE=verdana,arial,helvetica SIZE=2><B>Message:</B></FONT><BR><TABLE BORDER="1"><TR><TD><PRE><%= EMailTextConfirm %></PRE></TD></TR></TABLE></TD></TR>
</TABLE>
<BR>
<BR>
<FONT FACE=verdana,arial,helvetica SIZE=2><B>Events</B></FONT><BR>

<%

SQLEvents = "SELECT Event.EventCode, Act, Venue, EventDate FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE Event.EventCode IN (" & Clean(Request("EventCode")) & ") AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " ORDER BY Act, Venue, EventDate"
Set rsEvents = OBJdbConnection.Execute(SQLEvents)

Response.Write "<TABLE CELLPADDING=""3"">" & vbCrLf
Response.Write "<TR BGCOLOR=""#008400""><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2>Date/Time</FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2>Production</FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2>Venue</FONT></TD></TR>" & vbCrLf

Do Until rsEvents.EOF

	Response.Write "<TR BGCOLOR=""#DDDDDD""><TD NOWRAP><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & DateAndTimeFormat(rsEvents("EventDate")) & "</FONT></TD><TD><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsEvents("Act") & "</FONT></TD><TD><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsEvents("Venue") & "</FONT></TD></TR>" & vbCrLf
	rsEvents.MoveNext
	
Loop

Response.Write "</TABLE><BR><BR>" & vbCrLf

%>

<INPUT TYPE="submit" VALUE="Send" id=submit1 name=submit>&nbsp;&nbsp;&nbsp;&nbsp;<INPUT TYPE="submit" NAME="submit" VALUE="Cancel"></FORM>

</CENTER>
<BR>
<BR>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%
End Sub 'Confirmation

'=================================

Sub SendEMail

If Clean(Request("Submit")) = "Cancel" Then

	Call EventSelection("E-Mail Message Cancelled")
	Exit Sub
	
End If

SecurityLog(Left("Event E-Mail - " & Clean(Request("EventCode")) & " - " & Clean(Request("EMailText")), 2000))

ReplyAddress = Clean(Request("ReplyAddress"))
Subject = Clean(Request("Subject"))
EMailBody = Clean(Request("EmailText")) & Disclaimer()

SQLCustomer = "SELECT Customer.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, Customer.DayPhone, Customer.NightPhone, Customer.EMailAddress FROM Customer (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON Customer.CustomerNumber = OrderHeader.CustomerNumber INNER JOIN Seat (NOLOCK) ON OrderHeader.OrderNumber = Seat.OrderNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode WHERE Event.EventCode IN (" & Clean(Request("EventCode")) & ") AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " GROUP BY Customer.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, Customer.DayPhone, Customer.NightPhone, Customer.EMailAddress ORDER BY Customer.LastName, Customer.FirstName, Customer.CustomerNumber"
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
			objCDOSYSMail.TextBody = Greeting & EMailBody
			objCDOSYSMail.Send

			'Close the server mail object
			Set objCDOSYSMail = Nothing
			Set objCDOSYSCon = Nothing 
			
			SentCount = SentCount + 1
			
	Else 'There's no e-mail address.  List customer information so they can be contacted via another means.
	
		NotSentCount = NotSentCount + 1

'		Response.Write "<B>" & rsCustomer("FirstName") & " " & rsCustomer("LastName") & " " & rsCustomer("EMailAddress") & " - Not Sent</B><BR>"
	
	End If
	
	rsCustomer.MoveNext
	
Loop

%>

<HTML>
<HEAD>
<TITLE>TIX - Event E-Mail</TITLE>
</HEAD>
<BODY BGCOLOR="#FFFFFF">

<!--#include virtual="TopNavInclude.asp" -->

<BR>

<BR>

<FONT FACE=verdana,arial,helvetica COLOR=#008400><H3>Event E-Mail</H3></FONT>

<TABLE>
<TR><TD ALIGN="right"><FONT FACE=verdana,arial,helvetica SIZE=2><B>Sent Messages:</B></FONT></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2><%= FormatNumber(SentCount, 0) %></FONT></TD></TR>
<TR><TD ALIGN="right"><FONT FACE=verdana,arial,helvetica SIZE=2><B>Unsent Messages:</B></FONT></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2><%= FormatNumber(NotSentCount, 0) %></FONT></TD></TR>
</TABLE>

<BR>
<BR>
<FONT FACE=verdana,arial,helvetica SIZE=2><B>Display Customer Information</B></FONT><BR>
<FORM ACTION="EventEMail.asp" METHOD="post" NAME="Report"><INPUT TYPE="hidden" NAME="FormName" VALUE="SendEMail">
<INPUT TYPE="hidden" NAME="EventCode" VALUE="<%= Clean(Request("EventCode")) %>">
<TABLE WIDTH="600">
<TR><TD ALIGN="right"><INPUT TYPE="checkbox" NAME="EMailCustomers" VALUE="Y"></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2>Customers With E-Mail Addresses (Sent)</FONT></TD></TR>
<TR><TD ALIGN="right"><INPUT TYPE="checkbox" NAME="NoEMailCustomers" VALUE="Y"></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2>Customers Without E-Mail Addresses (Not Sent)</FONT></TD></TR>
<TR><TD ALIGN="right"><INPUT TYPE="checkbox" NAME="ExcelOutput" VALUE="Y"><BR><BR></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2>Output To Excel</FONT><BR><BR></TD></TR>
<TR><TD ALIGN="right"><INPUT TYPE="submit" VALUE="Display Customer Information" NAME="Display Customers"></FORM></TD><TD><FORM ACTION="Default.asp" METHOD="post">&nbsp;&nbsp;&nbsp;<INPUT TYPE="submit" VALUE="   Exit   " NAME="Exit"></FORM></TD></TR>
</TABLE>

</CENTER>
<BR>
<BR>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%
	
End Sub 'Send EMail

'=================================

Sub DisplayCustomerInfo

Excel = Clean(Request("ExcelOutput"))

If Excel = "Y" Then

	Response.ContentType = "application/vnd.ms-excel"

End If

%>
<HTML>
<HEAD>
<TITLE>TIX - Event E-Mail</TITLE>
</HEAD>
<BODY BGCOLOR="#FFFFFF">
<CENTER>

<%
If Excel <> "Y" Then
%>

	<!--#include virtual="TopNavInclude.asp" -->

<%
End If	
%>

<BR>
<BR>

<FONT FACE=verdana,arial,helvetica COLOR=#008400><H3>Event E-Mail</H3></FONT>
<FONT FACE=verdana,arial,helvetica SIZE=2>
<FORM ACTION="CustomerList.asp" METHOD="post" id=form1 name=form1>

<%

EMailAddressCriteria = ""

If Request("EMailCustomers") = "Y" Then
	If Request("NoEMailCustomers") = "Y" Then 'All Customers
		EMailAddressCriteria = ""
	Else
		EMailAddressCriteria = " AND Customer.EMailAddress LIKE '%@%'"
	End If
ElseIf Request("NoEMailCustomers") = "Y" Then 'No EMail Address Customers Only
	EMailAddressCriteria = " AND (Customer.EMailAddress NOT LIKE '%@%' OR Customer.EMailAddress IS NULL)"
Else 'None selected
	EMailAddressCriteria = " AND Customer.EMailAddress IS NULL AND Customer.EMailAddress IS NOT NULL" 'Force none.
End If
	
SQLCustomer = "SELECT Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, Customer.DayPhone, Customer.NightPhone, Customer.EMailAddress FROM Customer (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON Customer.CustomerNumber = OrderHeader.CustomerNumber INNER JOIN Seat (NOLOCK) ON OrderHeader.OrderNumber = Seat.OrderNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode WHERE Event.EventCode IN (" & Clean(Request("EventCode")) & ") AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & EMailAddressCriteria & " GROUP BY Customer.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, Customer.DayPhone, Customer.NightPhone, Customer.EMailAddress ORDER BY Customer.LastName, Customer.FirstName, Customer.CustomerNumber"
Set rsCustomer = OBJdbConnection.Execute(SQLCustomer)

If Not rsCustomer.EOF Then

	Response.Write "<TABLE CELLPADDING=3>" & vbCrLf
	Response.Write "<TR BGCOLOR=#008400><TD NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2 COLOR=#FFFFFF><B>First Name</B></FONT></TD><TD ALIGN=""center"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2 COLOR=#FFFFFF><B>Last Name</B></FONT></TD><TD ALIGN=center NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2 COLOR=#FFFFFF><B>Address Line 1</B></FONT></TD><TD ALIGN=center NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2 COLOR=#FFFFFF><B>Address Line 2</B></FONT></TD><TD ALIGN=center NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2 COLOR=#FFFFFF><B>City</B></FONT></TD><TD ALIGN=center NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2 COLOR=#FFFFFF><B>State</B></FONT></TD><TD ALIGN=center NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2 COLOR=#FFFFFF><B>Postal Code</B></FONT></TD><TD ALIGN=center NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2 COLOR=#FFFFFF><B>Country</B></FONT></TD><TD ALIGN=center NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2 COLOR=#FFFFFF><B>Daytime Phone</B></FONT></TD><TD ALIGN=center NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2 COLOR=#FFFFFF><B>Evening Phone</B></FONT></TD><TD ALIGN=center NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2 COLOR=#FFFFFF><B>E-Mail Address</B></FONT></TD></TR>" & vbCrLf
	
End If

Do Until rsCustomer.EOF

	Response.Write "<TR BGCOLOR=#DDDDDD><TD NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsCustomer("FirstName") & "</FONT></TD><TD NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsCustomer("LastName") & "</FONT></TD><TD NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsCustomer("Address1") & "</FONT></TD><TD NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsCustomer("Address2") & "</FONT></TD><TD NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsCustomer("City") & "</FONT></TD><TD NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsCustomer("State") & "</FONT></TD><TD NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsCustomer("PostalCode") & "</FONT></TD><TD NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsCustomer("Country") & "</FONT></TD><TD NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>" & FormatPhone(rsCustomer("DayPhone"), rsCustomer("Country")) & "</FONT></TD><TD NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>" & FormatPhone(rsCustomer("NightPhone"), rsCustomer("Country")) & "</FONT></TD><TD NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsCustomer("EMailAddress") & "</FONT></TD></TR>" & vbCrLf
	
	rsCustomer.MoveNext
	
Loop

Response.Write "</TABLE>" & vbCrLf

%>

</FONT>
<BR>
<BR>
<BR>
<%
If Excel <> "Y" Then
%>
<!--#INCLUDE virtual="FooterInclude.asp"-->
<%
End If
%>
</CENTER>
</BODY>
</HTML>

<%

End Sub 'Display Customer Info

'=================================

Public Function Disclaimer()

Disclaimer = vbCrLf & vbCrLf & vbCrLf & vbCrLf
Disclaimer = Disclaimer & "----------------------------------------------" & vbCrLf
Disclaimer = Disclaimer & "You received this e-mail because you previously purchased tickets to Bethlehem Musikfest and asked to be included on the mailing list.  If you'd like to be removed from our mailing list, please click on the link below or cut and paste the link into your browser." & vbCrLf
Disclaimer = Disclaimer & "http://www.tix.com/optout.asp?EMailAddress=" & rsList("EMailAddress") & vbCrLf
Disclaimer = Disclaimer & "----------------------------------------------" & vbCrLf & vbCrLf

End Function


%>
