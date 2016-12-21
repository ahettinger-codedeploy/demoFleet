<!--METADATA TYPE="typelib" UUID="CD000000-8B95-11D1-82DB-00C04FB1625D"  NAME="CDO for Windows 2000 Library" -->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp"-->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!-- #INCLUDE virtual="/Components/fckeditor/fckeditor.asp" -->
<%
Page = "ManagementReport"

Server.ScriptTimeout = 60 * 20 '20 Minutes

If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then Response.Redirect("/Management/Default.asp")

If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then Response.Redirect("/Management/Default.asp")

Select Case Clean(Request("FormName"))
	Case "EventSelection"
		Call EMailText
	Case "EMailText"
		Call Confirmation(Message)
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
<TITLE>Tix - Event E-Mail</TITLE>
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
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
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

<FONT FACE="verdana,arial,helvetica" COLOR="#008400"><H3>Renewal Reminder E-Mail</H3></FONT>
<FONT FACE="verdana,arial,helvetica" SIZE="2">
<FORM ACTION="RenewalReminderEMail.asp" METHOD="post" NAME="Report"><INPUT TYPE="hidden" NAME="FormName" VALUE="EventSelection">

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
		SQLEvents = "SELECT Event.EventCode, Act, Venue, EventDate FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " ORDER BY Act, Venue, EventDate"
	Case "Venue"
		SQLEvents = "SELECT Event.EventCode, Act, Venue, EventDate FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " ORDER BY Venue, EventDate"
	Case Else
		SQLEvents = "SELECT Event.EventCode, Act, Venue, EventDate FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " ORDER BY EventDate, Act"
End Select
Set rsEvents = OBJdbConnection.Execute(SQLEvents)

Response.Write "<TABLE CELLPADDING=""3""><TR><TD COLSPAN=""2""><INPUT TYPE=button VALUE=""Select All"" onclick=""makeCheck(this.form)"" id=button1 name=button1><INPUT TYPE=reset VALUE=""Clear All"" id=reset1 name=reset1></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=""#008400""><TD ALIGN=""center""><FONT FACE=""verdana,arial,helvetica"" COLOR=#FFFFFF SIZE=""2""><B>X</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><A class=sort HREF=RenewalReminderEMail?SortMethod=Date>Date/Time</A></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><A class=sort HREF=RenewalReminderEMail.asp?SortMethod=Act>Production</A></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><A class=sort HREF=RenewalReminderEMail.asp?SortMethod=Venue>Venue</A></FONT></TD></TR>" & vbCrLf


Do Until rsEvents.EOF

	Response.Write "<TR BGCOLOR=""#DDDDDD""><TD><INPUT TYPE=""checkbox"" NAME=""EventCode"" VALUE=" & rsEvents("EventCode") & "></TD><TD NOWRAP><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & DateAndTimeFormat(rsEvents("EventDate")) & "</FONT></TD><TD><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsEvents("Act") & "</FONT></TD><TD><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsEvents("Venue") & "</FONT></TD></TR>" & vbCrLf
	EventCount = EventCount + 1
	If EventCount > 100 Then
		Response.Flush
		EventCount = 0
	End If
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
<TITLE>Tix - Event E-Mail</TITLE>
</HEAD>
<BODY BGCOLOR="#FFFFFF">
<CENTER>
<!--#include virtual="TopNavInclude.asp" -->

<BR>

<BR>

<FONT FACE=verdana,arial,helvetica COLOR=#008400><H3>Renewal Reminder E-Mail</H3></FONT>
<FORM ACTION="RenewalReminderEMail.asp" METHOD="post" NAME="Report"><INPUT TYPE="hidden" NAME="FormName" VALUE="EMailText">

<INPUT TYPE="hidden" NAME="EventCode" VALUE="<%= Clean(Request("EventCode")) %>">

<TABLE WIDTH="600">
<TR><TD ALIGN="right"><FONT FACE=verdana,arial,helvetica SIZE=2><B>Reply E-Mail Address:</B></FONT></TD><TD><INPUT TYPE="text" NAME="ReplyAddress" SIZE="40"></TD></TR>
<TR><TD ALIGN="right"><FONT FACE=verdana,arial,helvetica SIZE=2><B>Subject:</B></FONT></TD><TD><INPUT TYPE="text" NAME="Subject" SIZE="50"></TD></TR>
<TR><TD COLSPAN=2">
<%
	Dim oFCKeditor
    Set oFCKeditor = New FCKeditor
    oFCKeditor.BasePath	= "/Components/fckeditor/"
    oFCKeditor.Value = "Type Email Content Here"
    oFCKeditor.Width = "600"
    oFCKeditor.Height = "300"
    oFCKeditor.Create "EMailText"
%>
</TD></TR>

<%
'REE 6/19/6 - Added ability to suppress non-marketing e-mail option based on Org Option for User's Org.
'Get User's Org
'SQLUserOrg = "SELECT OrganizationNumber FROM Users (NOLOCK) WHERE UserNumber = " & Session("UserNumber")
'Set rsUserOrg = OBJdbConnection.Execute(SQLUserOrg)

'UserOrgNum = rsUserOrg("OrganizationNumber")

'rsUserOrg.Close
'Set rsUserOrg = nothing

'Look for OrganizationOption restricting User's org to Marketing E-Mail Only.
'SQLAllowMarketingEMailOnly = "SELECT OptionValue FROM OrganizationOptions (NOLOCK) WHERE OrganizationNumber = " & UserOrgNum & " AND OptionName = 'EventEmailMarketingOnly' AND OptionValue = 'Y'"
'Set rsAllowMarketingEMailOnly = OBJdbConnection.Execute(SQLAllowMarketingEMailOnly)

'If Not rsAllowMarketingEmailOnly.EOF Then 'Do not allow non-marketing option.
	'Response.Write "<TR><TD ALIGN=""right""><INPUT TYPE=""hidden"" NAME=""OptIn"" VALUE=""on""><IMG SRC=""/Images/Blusquar.gif""></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2><B>Marketing E-Mail (Mailing List Members Only)</B></TD></TR>" & vbCrLf
'Else
	'Response.Write "<TR><TD ALIGN=""right""><INPUT TYPE=""checkbox"" NAME=""OptIn"" CHECKED></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2><B>Marketing E-Mail (Mailing List Members Only)</B></TD></TR>" & vbCrLf
'End If

'rsAllowMarketingEMailOnly.Close
'Set rsAllowMarketingEmailOnly = nothing

%>

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

Sub Confirmation(RtnMessage)

SQLOrgName = "SELECT Organization FROM Organization (NOLOCK) WHERE OrganizationNumber = " & Session("OrganizationNumber")
Set rsOrgName = OBJdbConnection.Execute(SQLOrgName)

Organization = rsOrgName("Organization")

rsOrgName.Close
Set rsOrgName = nothing

If Clean(Request("OptIn")) = "on" Then
	OptIn = "Y"
Else
	OptIn = "N"
	'REE 10/8/7 - Added warning for non-marketing e-mail messages.
	'Message = "WARNING: The e-mail message you are attempting to send is set to be sent to both customers on the mailing list and those that have opted out of the mailing list.  The message must not be a solicitation and must only be used for important information relating to an event these customers have already purchased tickets to.  This information may be related to a cancellation, postponement, location change, etc.  As per the terms of our Privacy Policy, the message being sent must not be a solicitation.  If this message includes important information relating to an event these customers have ALREADY purchased tickets to, please click on the Send button below.  If this message is a solicitation, please click on the Cancel button below and make sure the Marketing E-Mail checkbox is checked when resubmitting your message."
End If

EMailTextConfirm = "Dear [Customer Name]: " & vbCrLf & vbCrLf & Request("EMailText") & Disclaimer("customer@emailaddress.com", Organization, OptIn)

%>

<HTML>
<HEAD>
<TITLE>Tix - Renewal Reminder E-Mail</TITLE>
<script language="javascript">
function sendTestEmail() {
    if(document.Report.TestEmailAddress.value == "" || document.Report.TestEmailAddress.value.indexOf('@') == -1 || document.Report.TestEmailAddress.value.indexOf('.') == -1) {
        alert('Please enter a valid email address');
        document.Report.TestEmailAddress.focus();
        return false;
    }
}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
</HEAD>
<%
If OptIn = "Y" Then
	If RtnMessage <> "" Then
	    Response.Write "<BODY BGCOLOR=""#FFFFFF"" onLoad=""alert('" & RtnMessage & "')"">" & vbCrLf
    Else
	    Response.Write "<BODY BGCOLOR=""#FFFFFF"">" & vbCrLf
    End If
Else
    If RtnMessage <> "" Then
	    Response.Write "<BODY BGCOLOR=""#FFFFFF"" onLoad=""alert('" & RtnMessage & "')"">" & vbCrLf
    Else
	    'Response.Write "<BODY BGCOLOR=""#FFFFFF"" onLoad=""alert('" & Message & "')"">" & vbCrLf
	End If
End If
%>
<!--#include virtual="TopNavInclude.asp" -->

<BR>

<BR>

<FONT FACE=verdana,arial,helvetica COLOR=#008400><H3>Renewal Reminder E-Mail</H3></FONT>
<FORM ACTION="RenewalReminderEMail.asp" METHOD="post" NAME="Report"><INPUT TYPE="hidden" NAME="FormName" VALUE="Confirmation">

<INPUT TYPE="hidden" NAME="EventCode" VALUE="<%= Clean(Request("EventCode")) %>">
<INPUT TYPE="hidden" NAME="ReplyAddress" VALUE="<%= Clean(Request("ReplyAddress")) %>">
<INPUT TYPE="hidden" NAME="Subject" VALUE="<%= Replace(Request("Subject"), """", "&#034;") %>">
<INPUT TYPE="hidden" NAME="EMailText" VALUE="<%= Replace(Request("EMailText"), """", "&#034;") %>">
<INPUT TYPE="hidden" NAME="OptIn" VALUE="<%= OptIn %>">

<FONT FACE=verdana,arial,helvetica SIZE=2>Confirm the Information Below and Click "Send" or "Cancel".</FONT><BR><BR>

<TABLE WIDTH="600">
<TR><TD ALIGN="right" WIDTH="50%"><FONT FACE=verdana,arial,helvetica SIZE=2><B>Reply E-Mail Address:</B></FONT></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2><%= Clean(Request("ReplyAddress")) %></FONT></TD></TR>
<TR><TD ALIGN="right" WIDTH="50%"><FONT FACE=verdana,arial,helvetica SIZE=2><B>Subject:</B></FONT></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2><%= Request("Subject") %></FONT></TD></TR>
<TR><TD COLSPAN=2"><BR><FONT FACE=verdana,arial,helvetica SIZE=2><B>Message:</B></FONT><BR><TABLE BORDER="1"><TR><TD><%= EMailTextConfirm %></TD></TR></TABLE></TD></TR>
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

Response.Write "</TABLE><BR>" & vbCrLf

%>
<font size="2">Test Email Address:</font>&nbsp;<input type="text" name="TestEmailAddress" />&nbsp;<input type="submit" value="Send Test" name=submit onclick="return sendTestEmail();" /><BR><BR>
<input type="button" value="Back" onclick="history.back()" />&nbsp;&nbsp;&nbsp;&nbsp;<INPUT TYPE="submit" VALUE="Send" id=submit1 name=submit>&nbsp;&nbsp;&nbsp;&nbsp;<INPUT TYPE="submit" NAME="submit" VALUE="Cancel"></FORM>

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

If Clean(Request("Submit")) = "Send Test" Then
    If Request("TestEmailAddress") = "" Then
        Call Confirmation("Please enter a valid email address.")
        Exit Sub
    End If
End If

If Clean(Request("Submit")) = "Cancel" Then

	Call EventSelection("E-Mail Message Cancelled")
	Exit Sub
	
End If

SQLOrgName = "SELECT Organization FROM Organization (NOLOCK) WHERE OrganizationNumber = " & Session("OrganizationNumber")
Set rsOrgName = OBJdbConnection.Execute(SQLOrgName)

Organization = rsOrgName("Organization")

rsOrgName.Close
Set rsOrgName = nothing

ReplyAddress = Clean(Request("ReplyAddress"))
Subject = Request("Subject")
'EMailBody = Replace (Request("EmailText"), """", "&#034;")
'EMailBody = Request("EmailText")
EMailBodyTemplate = EMailBodyTemplate & "<font color=""#ffffff"">Please disregard the previous email message.  Due to a programming error, the incorrect name was listed below.  We apologize for any inconvenience.<br /><br />" & vbCrLf & vbCrLf
EMailBodyTemplate = EMailBodyTemplate & "If you have difficulty reading this email message, <a href=""http://www.tix.com/clients/gplb/scripts/renewalreminder.html"">click here</a></font><html><body bgcolor=""Black"" style=""color: #FFFFFF; font-size: small; font-family: Arial, Helvetica, sans-serif""><table width=""600"" cellspacing=""5"" bgcolor=""Black"" border=""0"" style=""font-size: small; font-family: Arial, Helvetica, sans-serif"">" & vbCrLf
EMailBodyTemplate = EMailBodyTemplate & "<tr><td colspan=""2""><font color=""#ffffff""><img src=""http://www.tix.com/clients/gplb/images/emailbanner.jpg"" alt=""Toyota Grand Prix of Long Beach"" /><br /><br /></font></td></tr>" & vbCrLf
EMailBodyTemplate = EMailBodyTemplate & "<tr><td colspan=""2""><font color=""#ffffff"">Dear <CUSTOMERNAME>:<br /><br />The Toyota Grand Prix of Long Beach would like to remind you that you can renew your 2010 seats for the April 15-17, 2011 race from now through Friday, Sept. 24. To renew your seats, visit <a href=""http://www.gplb.com/"" style=""color: #FFFFFF; text-decoration: underline"">www.gplb.com</a> and click on the &quot;Ticket Renewal&quot; button on the home page, return the renewal form you've already received in the mail or call the Grand Prix ticket office at (888) 827-7333. <br /><br /></font></td></tr>" & vbCrLf
EMailBodyTemplate = EMailBodyTemplate & "<tr><td valign=""top""><font color=""#ffffff"">The 2011 Toyota Grand Prix of Long Beach will be the third round on the recently released 2011 IZOD IndyCar Series schedule. Five other racing events will be on tap including the American Le Mans Series and the popular Toyota Pro/Celebrity Race. In addition, a variety of activities will return including the Tecate Light Fiesta Friday and Saturday Rock-N-Roar concerts, the Lifestyle Expo and Green Power Prix-View, Go-Karts, and an expanded Family Fun Zone featuring games, simulators, and more.<br /></td><td align=""left"" valign=""top"" width=""300"" style=""font-family: Arial; font-size: x-small""><img src=""http://www.tix.com/clients/gplb/images/rhr.jpg"" alt=""Ryan Hunter-Reay won the 2010 Toyota Grand Prix of Long Beach."" /><br />Ryan Hunter-Reay won the 2010 Toyota Grand Prix of Long Beach.</font></td></tr>" & vbCrLf
EMailBodyTemplate = EMailBodyTemplate & "<tr><td colspan=""2""><font color=""#ffffff""><br />Thank you for your continued support of the Toyota Grand Prix of Long Beach, and we look forward to hosting you next April!<br /><br />Sincerely,<br /><br />Jim Michaelian</font><br /></font></td></tr></table>" & vbCrLf
OptIn = Clean(Request("OptIn"))

SecurityLog(Left("Event E-Mail - OptIn: " & OptIn & " - " & Clean(Request("EMailText")) & " - Event Codes: " & Clean(Request("EventCode")), 2000))

SentCount = 0
NotSentCount = 0

If Clean(Request("Submit")) = "Send Test" Then
    If InStr(1, Request("TestEmailAddress"), "@") <> 0 Then
        EMailBody = Replace(EMailBodyTemplate, "<CUSTOMERNAME>", Clean(Request("TestEmailAddress")))
    	
	    'Create the e-mail server object
	    Set objCDOSYSMail = Server.CreateObject("CDO.Message")
	    Set objCDOSYSCon = Server.CreateObject ("CDO.Configuration")
	    objCDOSYSCon.Fields(cdoSendUsingMethod) = cdoSendUsingPickup 'For localhost
	    objCDOSYSCon.Fields.Update

	    'Update the CDOSYS Configuration
	    Set objCDOSYSMail.Configuration = objCDOSYSCon
	    'REE 12/1/6 - Modified to display Organization name in From field
	    'REE 10/9/7 - Modified to send mail from reply address
	    objCDOSYSMail.From = Organization & " <" & ReplyAddress & ">" 
	    objCDOSYSMail.ReplyTo = ReplyAddress
	    'REE 12/1/6 - Modified to display Customer name in To field
	    objCDOSYSMail.To = Clean(Request("TestEmailAddress")) & " <" & Clean(Request("TestEmailAddress")) & ">"
	    If SentCount = 0 Then 'BCC info@tix.com on the first one.
		    objCDOSYSMail.Bcc = ReplyAddress
	    End If
						
	    objCDOSYSMail.Subject = Subject
	    'REE 5/4/8 - Modified to HTML format.
	    objCDOSYSMail.HTMLBody = EMailBody & Disclaimer(Clean(Request("TestEmailAddress")), Organization, OptIn)
	    objCDOSYSMail.Send
'			Response.Write rsCustomer("EmailAddress") & " |" & Greeting & EMailBody & Disclaimer(rsCustomer("EMailAddress"), Organization, OptIn)
	    'Close the server mail object
	    Set objCDOSYSMail = Nothing
	    Set objCDOSYSCon = Nothing
	    
	    Call Confirmation("One email has been sent to the test EMail Address: " & Clean(Request("TestEmailAddress")))
        Exit Sub
        
        SentCount = 1
    End If
Else    

    'If OptIn= "Y" Then
        'REE 11/4/8 - Modified to use Session OrgNum instead of OrgNum IN (0, Session OrgNum)
	    'SQLCustomer = "SELECT Customer.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, Customer.DayPhone, Customer.NightPhone, Customer.EMailAddress FROM Customer (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON Customer.CustomerNumber = OrderHeader.CustomerNumber INNER JOIN Seat (NOLOCK) ON OrderHeader.OrderNumber = Seat.OrderNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN CustomerMailingList (NOLOCK) ON CustomerMailingList.CustomerNumber = Customer.CustomerNumber WHERE Event.EventCode IN (" & Clean(Request("EventCode")) & ") AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND CustomerMailingList.OrganizationNumber = " & Session("OrganizationNumber") & " AND CustomerMailingList.OptInFlag = 'Y' GROUP BY Customer.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, Customer.DayPhone, Customer.NightPhone, Customer.EMailAddress ORDER BY Customer.LastName, Customer.FirstName, Customer.CustomerNumber"
    'Else
	    'SQLCustomer = "SELECT Customer.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, Customer.DayPhone, Customer.NightPhone, Customer.EMailAddress FROM Customer (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON Customer.CustomerNumber = OrderHeader.CustomerNumber INNER JOIN Seat (NOLOCK) ON OrderHeader.OrderNumber = Seat.OrderNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode WHERE Event.EventCode IN (" & Clean(Request("EventCode")) & ") AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " GROUP BY Customer.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, Customer.DayPhone, Customer.NightPhone, Customer.EMailAddress ORDER BY Customer.LastName, Customer.FirstName, Customer.CustomerNumber"
    'End If	
    SQLCustomer = "SELECT Customer.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, Customer.DayPhone, Customer.NightPhone, Customer.EMailAddress FROM Customer (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON Customer.CustomerNumber = OrderHeader.CustomerNumber INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode WHERE Event.EventCode IN (" & Clean(Request("EventCode")) & ") AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderHeader.StatusCode = 'R' AND OrderHeader.ExpirationDate = '9/30/2010' AND Customer.EmailAddress <> '' AND Customer.EmailAddress IS NOT NULL GROUP BY Customer.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, Customer.DayPhone, Customer.NightPhone, Customer.EMailAddress ORDER BY Customer.LastName, Customer.FirstName, Customer.CustomerNumber"
    'The SQL below includes OrderNumber, CustomerNumber, and Min ItemNumber for Renewal Info.
    'SQLCustomer = "SELECT OrderHeader.OrderNumber, Customer.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, Customer.DayPhone, Customer.NightPhone, Customer.EMailAddress, MinItemNum.MinItemNum FROM Customer (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON Customer.CustomerNumber = OrderHeader.CustomerNumber INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN (SELECT OrderNumber, MIN(ItemNumber) AS MinItemNum FROM OrderLine (NOLOCK) GROUP BY OrderNumber) AS MinItemNum ON OrderHeader.OrderNumber = MinItemNum.OrderNumber WHERE Event.EventCode IN (" & Clean(Request("EventCode")) & ") AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderHeader.StatusCode = 'R' AND OrderHeader.ExpirationDate = '9/30/2010' AND Customer.EmailAddress <> '' AND Customer.EmailAddress IS NOT NULL GROUP BY OrderHeader.OrderNumber, Customer.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, Customer.DayPhone, Customer.NightPhone, Customer.EMailAddress, MinItemNum.MinItemNum ORDER BY Customer.LastName, Customer.FirstName, Customer.CustomerNumber"
    Set rsCustomer = OBJdbConnection.Execute(SQLCustomer)

    Do Until rsCustomer.EOF
    'Do Until rsCustomer.EOF OR SentCount >= 5 'Testing Only

    	
	    If InStr(1, rsCustomer("EMailAddress"), "@") <> 0 Then 'There's an e-mail address.  Send the E-Mail message.
    	
			    'Greeting = "<font face=""verdana,arial,helvetica"" size=""2"">Dear " & rsCustomer("FirstName") & " " & rsCustomer("LastName") & ":</font><BR><BR>" & vbCrLf
                EMailBody = Replace(EMailBodyTemplate, "<CUSTOMERNAME>", rsCustomer("FirstName") & " " & rsCustomer("LastName"))
    	
			    'Create the e-mail server object
			    Set objCDOSYSMail = Server.CreateObject("CDO.Message")
			    Set objCDOSYSCon = Server.CreateObject ("CDO.Configuration")
			    objCDOSYSCon.Fields(cdoSendUsingMethod) = cdoSendUsingPickup 'For localhost
			    objCDOSYSCon.Fields.Update

			    'Update the CDOSYS Configuration
			    Set objCDOSYSMail.Configuration = objCDOSYSCon
			    'REE 12/1/6 - Modified to display Organization name in From field
			    'REE 10/9/7 - Modified to send mail from reply address
			    objCDOSYSMail.From = Organization & " <" & ReplyAddress & ">" 
			    objCDOSYSMail.ReplyTo = ReplyAddress
			    'REE 12/1/6 - Modified to display Customer name in To field
			    objCDOSYSMail.To = rsCustomer("FirstName") & " " & rsCustomer("LastName") & " <" & rsCustomer("EMailAddress") & ">"
    			'objCDOSYSMail.To = "robert.edmison@tix.com" 'Testing Only
			    If SentCount = 0 Then 'BCC info@tix.com on the first one.
				    objCDOSYSMail.Bcc = "robert.edmison@tix.com," & ReplyAddress
			    End If
    							
			    objCDOSYSMail.Subject = Subject
			    'REE 5/4/8 - Modified to HTML format.
			    objCDOSYSMail.HTMLBody = EMailBody & Disclaimer(rsCustomer("EMailAddress"), Organization, OptIn)
			    objCDOSYSMail.Send
    '			Response.Write rsCustomer("EmailAddress") & " |" & Greeting & EMailBody & Disclaimer(rsCustomer("EMailAddress"), Organization, OptIn)
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

End If
%>

<HTML>
<HEAD>
<TITLE>Tix - Renewal Reminder E-Mail</TITLE>
</HEAD>
<BODY BGCOLOR="#FFFFFF">

<!--#include virtual="TopNavInclude.asp" -->

<BR>

<BR>

<FONT FACE=verdana,arial,helvetica COLOR=#008400><H3>Renewal Reminder E-Mail</H3></FONT>

<TABLE>
<TR><TD ALIGN="right"><FONT FACE=verdana,arial,helvetica SIZE=2><B>Sent Messages:</B></FONT></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2><%= FormatNumber(SentCount, 0) %></FONT></TD></TR>
<TR><TD ALIGN="right"><FONT FACE=verdana,arial,helvetica SIZE=2><B>Unsent Messages:</B></FONT></TD><TD><FONT FACE=verdana,arial,helvetica SIZE=2><%= FormatNumber(NotSentCount, 0) %></FONT></TD></TR>
</TABLE>

<BR>
<BR>
<FONT FACE=verdana,arial,helvetica SIZE=2><B>Display Customer Information</B></FONT><BR>
<FORM ACTION="RenewalReminderEMail.asp" METHOD="post" NAME="Report"><INPUT TYPE="hidden" NAME="FormName" VALUE="SendEMail">
<INPUT TYPE="hidden" NAME="EventCode" VALUE="<%= Clean(Request("EventCode")) %>">
<INPUT TYPE="hidden" NAME="OptIn" VALUE="<%= OptIn %>">
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
<TITLE>Tix - Event E-Mail</TITLE>
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

<FONT FACE=verdana,arial,helvetica COLOR=#008400><H3>Renewal Reminder E-Mail</H3></FONT>
<FONT FACE=verdana,arial,helvetica SIZE=2>
<FORM ACTION="CustomerList.asp" METHOD="post" id=form1 name=form1>

<%

OptIn = Clean(Request("OptIn"))

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

'REE 5/4/8 - Modified to include OptIn criteria
'SQLCustomer = "SELECT Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, Customer.DayPhone, Customer.NightPhone, Customer.EMailAddress FROM Customer (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON Customer.CustomerNumber = OrderHeader.CustomerNumber INNER JOIN Seat (NOLOCK) ON OrderHeader.OrderNumber = Seat.OrderNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode WHERE Event.EventCode IN (" & Clean(Request("EventCode")) & ") AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & EMailAddressCriteria & " GROUP BY Customer.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, Customer.DayPhone, Customer.NightPhone, Customer.EMailAddress ORDER BY Customer.LastName, Customer.FirstName, Customer.CustomerNumber"
'If OptIn= "Y" Then
'	SQLCustomer = "SELECT Customer.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, Customer.DayPhone, Customer.NightPhone, Customer.EMailAddress FROM Customer (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON Customer.CustomerNumber = OrderHeader.CustomerNumber INNER JOIN Seat (NOLOCK) ON OrderHeader.OrderNumber = Seat.OrderNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN CustomerMailingList (NOLOCK) ON CustomerMailingList.CustomerNumber = Customer.CustomerNumber WHERE Event.EventCode IN (" & Clean(Request("EventCode")) & ") AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND CustomerMailingList.OrganizationNumber = " & Session("OrganizationNumber") & " AND CustomerMailingList.OptInFlag = 'Y' " & EMailAddressCriteria & " GROUP BY Customer.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, Customer.DayPhone, Customer.NightPhone, Customer.EMailAddress ORDER BY Customer.LastName, Customer.FirstName, Customer.CustomerNumber"
'Else
'	SQLCustomer = "SELECT Customer.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, Customer.DayPhone, Customer.NightPhone, Customer.EMailAddress FROM Customer (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON Customer.CustomerNumber = OrderHeader.CustomerNumber INNER JOIN Seat (NOLOCK) ON OrderHeader.OrderNumber = Seat.OrderNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode WHERE Event.EventCode IN (" & Clean(Request("EventCode")) & ") AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & EMailAddressCriteria & " GROUP BY Customer.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, Customer.DayPhone, Customer.NightPhone, Customer.EMailAddress ORDER BY Customer.LastName, Customer.FirstName, Customer.CustomerNumber"
'End If	
SQLCustomer = "SELECT Customer.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, Customer.DayPhone, Customer.NightPhone, Customer.EMailAddress FROM Customer (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON Customer.CustomerNumber = OrderHeader.CustomerNumber INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode WHERE Event.EventCode IN (" & Clean(Request("EventCode")) & ") AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrderHeader.StatusCode = 'R' AND OrderHeader.ExpirationDate = '9/30/2010' " & EMailAddressCriteria & " GROUP BY Customer.CustomerNumber, Customer.FirstName, Customer.LastName, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, Customer.DayPhone, Customer.NightPhone, Customer.EMailAddress ORDER BY Customer.LastName, Customer.FirstName, Customer.CustomerNumber"

Set rsCustomer = OBJdbConnection.Execute(SQLCustomer)

Response.Write "<TABLE CELLPADDING=3>" & vbCrLf

Response.Write "<TR BGCOLOR=#008400><TD NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2 COLOR=#FFFFFF><B>First Name</B></FONT></TD><TD ALIGN=""center"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2 COLOR=#FFFFFF><B>Last Name</B></FONT></TD><TD ALIGN=center NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2 COLOR=#FFFFFF><B>Address Line 1</B></FONT></TD><TD ALIGN=center NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2 COLOR=#FFFFFF><B>Address Line 2</B></FONT></TD><TD ALIGN=center NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2 COLOR=#FFFFFF><B>City</B></FONT></TD><TD ALIGN=center NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2 COLOR=#FFFFFF><B>State</B></FONT></TD><TD ALIGN=center NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2 COLOR=#FFFFFF><B>Postal Code</B></FONT></TD><TD ALIGN=center NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2 COLOR=#FFFFFF><B>Country</B></FONT></TD><TD ALIGN=center NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2 COLOR=#FFFFFF><B>Daytime Phone</B></FONT></TD><TD ALIGN=center NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2 COLOR=#FFFFFF><B>Evening Phone</B></FONT></TD><TD ALIGN=center NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2 COLOR=#FFFFFF><B>E-Mail Address</B></FONT></TD></TR>" & vbCrLf
	
Do Until rsCustomer.EOF

	Response.Write "<TR BGCOLOR=#DDDDDD><TD NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsCustomer("FirstName") & "</FONT></TD><TD NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsCustomer("LastName") & "</FONT></TD><TD NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsCustomer("Address1") & "</FONT></TD><TD NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsCustomer("Address2") & "</FONT></TD><TD NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsCustomer("City") & "</FONT></TD><TD NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsCustomer("State") & "</FONT></TD><TD NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsCustomer("PostalCode") & "</FONT></TD><TD NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsCustomer("Country") & "</FONT></TD><TD NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>" & FormatPhone(rsCustomer("DayPhone"), rsCustomer("Country")) & "</FONT></TD><TD NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>" & FormatPhone(rsCustomer("NightPhone"), rsCustomer("Country")) & "</FONT></TD><TD NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsCustomer("EMailAddress") & "</FONT></TD></TR>" & vbCrLf
	
	CustomerCount = CustomerCount + 1
	
	rsCustomer.MoveNext
	
Loop

If CustomerCount = 0 Then

	Response.Write "<TR BGCOLOR=#DDDDDD><TD COLSPAN=""11"" ALIGN=""center""><FONT FACE='verdana,arial,helvetica' SIZE=2>No Customers</FONT></TD></TR>" & vbCrLf

End If

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

Public Function Disclaimer(EMailAddress, Organization, OptIn)

If OptIn <> "Y" Then
	Disclaimer = "<BR><BR><BR><HR>" & vbCrLf
'	Disclaimer = Disclaimer & "---------------------------------------------------<BR>" & vbCrLf
	Disclaimer = Disclaimer & "<FONT FACE=""verdanna, arial, helvetica"" SIZE=""2"">You are receiving this message because your e-mail address is on file as the purchaser " & vbCrLf
	Disclaimer = Disclaimer & "of tickets to an event related to the message above.</FONT><BR><BR>" & vbCrLf
	'Disclaimer = Disclaimer & "The message above is intended to notify you of important information relating to the" & vbCrLf
	'Disclaimer = Disclaimer & "tickets that you purchased.  The message above should not include marketing or other" & vbCrLf
	'Disclaimer = Disclaimer & "solicitations.  Please report any abuse to abuse@tix.com.<BR></FONT>" & vbCrLf
'	Disclaimer = Disclaimer & "---------------------------------------------------<BR>" & vbCrLf
	Disclaimer = Disclaimer & "<HR><BR></body></html>" & vbCrLf
Else
	Disclaimer = "<BR><BR><BR><HR>" & vbCrLf
'	Disclaimer = Disclaimer & "----------------------------------------------<BR>" & vbCrLf
	Disclaimer = Disclaimer & "<FONT FACE=""verdanna, arial, helvetica"" SIZE=""2"">You have received this e-mail because you previously purchased tickets to an event" & vbCrLf
	Disclaimer = Disclaimer & "produced by " & Organization & " and asked to be included on the mailing list.<BR><BR>" & vbCrLf
    'REE 8/5/8 - Added OrganizationNumber to OptOut link.	
	Disclaimer = Disclaimer & "If you'd like to be removed from the mailing list please go to <A HREF=""http://www.tix.com/optout.asp?organizationnumber=" & Session("OrganizationNumber") & """>http://www.tix.com/optout.asp?organizationnumber=" & Session("OrganizationNumber") & "</A> and enter your e-mail address.<BR></FONT>" & vbCrLf
'	Disclaimer = Disclaimer & "----------------------------------------------<BR>" & vbCrLf
	Disclaimer = Disclaimer & "<HR><BR></body></html>" & vbCrLf
End If

End Function


%>
