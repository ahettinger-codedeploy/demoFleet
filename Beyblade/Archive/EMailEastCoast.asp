<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=dbOpenInclude.asp -->

<%
Server.ScriptTimeout = 30 * 60 '30 Minutes
%>
<HTML>
<HEAD>
<TITLE>www.TIX.com - E-Mail Notification</TITLE>
</HEAD>

<BODY BGCOLOR=#FFFFFF>
<CENTER>
<!--#INCLUDE VIRTUAL="TopNavInclude.asp"-->
<BR>
<FONT FACE="verdana, arial, helvetica" COLOR="#008400" SIZE="2"><H3>E-Mail Notification</H3></FONT>
<FONT FACE="verdana, arial, helvetica" SIZE="2">

<%

Subject = "BBA Blader Jam"
Message = "PLEASE DO NOT REPLY TO THIS EMAIL<BR>---------------------------------------------------------------<BR><BR>Attention BBA Blader Jam Competitors:<BR><BR>The Beyblade Battle Association is sending this email to confirm that you or a family member has purchased a BBA Blader Jam Competitor Ticket to compete in our upcoming Championships.<BR><BR>Spectators for the East Coast Championships must only purchase a general admission at The Intrepid Sea, Air & Space Museum the day of the event (And will receive a $3.00 discount if you come with a BBA competitor!)<BR><BR>If you have purchased a Competitor ticket (as a Spectator) in error please contact us at <A HREF=""mailto:bbainfo@theregangroup.com"">bbainfo@theregangroup.com</A>.<BR><BR>Get ready to battle! We look forward seeing you at the Championships!<BR><BR>Let It Rip!<BR><BR>---------------------------------------------------------------<BR>PLEASE DO NOT REPLY TO THIS EMAIL<BR><BR>" & vbCrLf & vbCrLf

SQLList = "SELECT DISTINCT Customer.EMailAddress, Customer.FirstName, Customer.LastName FROM Customer INNER JOIN OrderHeader ON Customer.CustomerNumber = OrderHeader.CustomerNumber INNER JOIN OrderLine ON OrderHeader.OrderNumber = OrderLine.OrderNumber INNER JOIN Seat ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event ON Seat.EventCode = Event.EventCode WHERE Event.EventCode IN (7153) AND OrderLine.ItemType = 'Seat' AND Customer.EMailAddress IS NOT NULL AND Customer.EMailAddress <> ' ' GROUP BY Customer.EMailAddress, Customer.FirstName, Customer.LastName ORDER BY Customer.EMailAddress"
'SQLList = "SELECT Customer.EMailAddress, Customer.FirstName, Customer.LastName FROM Customer INNER JOIN OrderHeader ON Customer.CustomerNumber = OrderHeader.CustomerNumber INNER JOIN OrderLine ON OrderHeader.OrderNumber = OrderLine.OrderNumber INNER JOIN Seat ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event ON Seat.EventCode = Event.EventCode INNER JOIN Venue ON Event.VenueCode = Venue.VenueCode WHERE Customer.EMailAddress = 'robert.edmison@tix.com' GROUP BY Customer.EMailAddress, Customer.FirstName, Customer.LastName ORDER BY Customer.EMailAddress"
Response.Write SQLList & "<BR>"
Set rsList = OBJdbConnection.Execute(SQLList)

Do Until rsList.EOF

	Response.Write rsList("EmailAddress") & "<BR>"
		
	Set Mail = CreateObject("CDONTS.NewMail")
	Mail.From="customerservice@tix.com"
	Mail.To=rsList("EMailAddress")
	Mail.Subject= Subject
	Mail.BodyFormat=0
	Mail.MailFormat=0
	Mail.Body=Message
	Mail.Send
	set Mail=nothing

	'Count them
	i = i + 1

	rsList.MoveNext
	
Loop

rsList.Close
Set rsList = nothing

Response.Write "<B>Total = " & i & "</B><BR>" & vbCrLf
%>

</CENTER>

<!--#INCLUDE VIRTUAL="FooterInclude.asp"-->

</BODY>
</HTML>