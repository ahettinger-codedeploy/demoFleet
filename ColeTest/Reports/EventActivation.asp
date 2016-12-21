<!--#INCLUDE VIRTUAL="GlobalInclude.asp"-->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<%
Page = "ManagementReport"

Server.ScriptTimeout = 60 * 10

If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then Response.Redirect("/Management/Default.asp")

If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then Response.Redirect("/Management/Default.asp")

Select Case Request("NextFormName")

	Case "DisplayEvent"
		Call DisplayEvent(Clean(Request("EventCode")), Clean(Request("Message")))		

	Case "ActivateEvent"
		Call ActivateEvent

	Case Else
		Call DisplayForm

End Select

'==========================================

Sub DisplayForm
%>
<HTML>
<HEAD>
<TITLE>www.TIX.com - Event Activation Report</TITLE>
<script LANGUAGE="JavaScript">    

<!-- Hide code from non-js browsers

function y2k(number) { 
return (number < 1000) ? number + 1900 : number; 
}

function isDate (day,month,year) {
var today = new Date();
year = ((!year) ? y2k(today.getYear()):year);
month = ((!month) ? today.getMonth():month-1);
if (!day) return false
var test = new Date(year,month,day);
if ( (y2k(test.getYear()) == year) &&
     (month == test.getMonth()) &&
     (day == test.getDate()) )
    return true;
else
    return false
}

function makeCheck(thisForm)
{
for (i = 0; i < thisForm.EventCode.length; i++)
	{
	thisForm.EventCode[i].checked=true
	}
}

function ValidateForm(){
formObj = document.Report;
if (!isDate(formObj.ReportDay.value, formObj.ReportMonth.value, formObj.ReportYear.value))
	{alert("Invalid Date");
	formObj.ReportMonth.focus();
    return false;
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
<BODY BGCOLOR="#FFFFFF">
<CENTER>

<!--#include virtual="TopNavInclude.asp" -->

<BR>

<BR>

<FONT FACE="verdana,arial,helvetica" COLOR="#008400"><H3>Event Activation Report</H3></FONT>
<FONT FACE="verdana,arial,helvetica" SIZE="2">

<%
'Get all events for Organization

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

'REE 4/21/5 - Added Keyword Search if it's Tix
If Session("OrganizationNumber") = 1 Then
	Response.Write "<FONT FACE=""verdana,arial,helvetica"" SIZE=""2""><FORM NAME=""KeywordSearch"" ACTION=""EventActivation.asp"" METHOD=""post""><B>Keyword Search:&nbsp;</B></FONT><INPUT TYPE=""text"" NAME=""Keyword"" SIZE=""14"">&nbsp;&nbsp;<INPUT TYPE=""submit"" VALUE=""Search"" id=1 name=1></FORM><BR>" & vbCrLf
	Keyword = Clean(Request("Keyword"))
	If Keyword <> "" Then
		SQLEvents = "SELECT Event.EventCode, Act, Venue, EventDate FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode LEFT JOIN State (NOLOCK) ON Venue.State = State.State LEFT JOIN Category (NOLOCK) ON Act.CategoryCode = Category.CategoryCode INNER JOIN Organization (NOLOCK) ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber WHERE EventDate > GETDATE()-" & ArchiveDays & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND (Act LIKE '%" & Keyword & "%' OR Act.Comments LIKE '%" & Keyword & "%' OR Event.Comments LIKE '%" & Keyword & "%' OR Venue.Venue LIKE '%" & Keyword & "%' OR StateName LIKE '%" & Keyword & "%' OR Category LIKE '%" & Keyword & "%' OR Organization.Organization LIKE '%" & Keyword & "%' OR Venue.State LIKE '%" & Keyword & "%' OR Venue.City LIKE '%" & Keyword & "%') ORDER BY EventDate, Act"
	Else 'Only choose events where Tix is the owner.  Should be none.  This prevents a huge lists of events from being listed.
		SQLEvents = "SELECT Event.EventCode, Act, Venue, EventDate FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE EventDate > GETDATE()-" & ArchiveDays & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationVenue.Owner = 1 ORDER BY EventDate, Act"
	End If
Else
	Select Case Request("SortMethod")
		Case "Act"
			SQLEvents = "SELECT Event.EventCode, Act, Venue, EventDate, Event.OnSale FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE EventDate > GETDATE()-" & ArchiveDays & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " ORDER BY Act, Venue, EventDate"
		Case "Venue"
			SQLEvents = "SELECT Event.EventCode, Act, Venue, EventDate, Event.OnSale FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE EventDate > GETDATE()-" & ArchiveDays & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " ORDER BY Venue, EventDate"
		Case "EventCode"
			SQLEvents = "SELECT Event.EventCode, Act, Venue, EventDate, Event.OnSale FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE EventDate > GETDATE()-" & ArchiveDays & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " ORDER BY EventCode"
		Case "Status"
			SQLEvents = "SELECT Event.EventCode, Act, Venue, EventDate, Event.OnSale FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE EventDate > GETDATE()-" & ArchiveDays & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " ORDER BY Event.OnSale, EventDate, Act"
		Case Else
			SQLEvents = "SELECT Event.EventCode, Act, Venue, EventDate, Event.OnSale FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE EventDate > GETDATE()-" & ArchiveDays & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " ORDER BY EventDate, Act"
	End Select
End If	
Set rsEvents = OBJdbConnection.Execute(SQLEvents)

Response.Write "<TABLE CELLPADDING=""3"" width=""90%"">" & vbCrLf
Response.Write "<TR BGCOLOR=""#008400""><TD ALIGN=""center"" NOWRAP><FONT FACE=""verdana,arial,helvetica"" COLOR=#FFFFFF SIZE=""2""><B><A class=sort HREF=EventActivation.asp?SortMethod=EventCode>Event Code</A></B></FONT></TD><TD ALIGN=center NOWRAP><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><A class=sort HREF=EventActivation.asp?SortMethod=Date>Date/Time</A></FONT></TD><TD ALIGN=center WIDTH=""40%""><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><A class=sort HREF=EventActivation.asp?SortMethod=Act>Production</A></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><A class=sort HREF=EventActivation.asp?SortMethod=Venue>Venue</A></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><A class=sort HREF=EventActivation.asp?SortMethod=Status>Status</A></FONT></TD></TR>" & vbCrLf


Do Until rsEvents.EOF

	If rsEvents("OnSale") = True Then
		EventStatus = "Active"
	Else
		EventStatus = "<B>Inactive</B>"
	End If

	Response.Write "<TR BGCOLOR=""#DDDDDD""><TD ALIGN=""right""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsEvents("EventCode") & "&nbsp;</FONT></TD><TD NOWRAP><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">&nbsp;" & WeekdayName(Weekday(rsEvents("EventDate"))) & " " & DateAndTimeFormat(rsEvents("EventDate")) & "&nbsp;</FONT></TD><TD><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">&nbsp;<A HREF=""EventActivation.asp?NextFormName=DisplayEvent&EventCode=" & rsEvents("EventCode") & """>" & rsEvents("Act") & "</A></FONT></TD><TD><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">&nbsp;" & rsEvents("Venue") & "&nbsp;</FONT></TD><TD><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">&nbsp;" & EventStatus & "&nbsp;</FONT></TD></TR>" & vbCrLf
	rsEvents.MoveNext
	
Loop

Response.Write "</TABLE></CENTER><LEFT><BR>" & vbCrLf


Response.Write "</FONT>" & vbCrLf

%>

<BR>
<BR>
<BR>
<FONT SIZE="1" FACE="verdana, helvetica, arial">Copyright © <%= Year(Now)%> Tix, Inc.  All rights reserved.</FONT>

</CENTER>
</BODY>
</HTML>

<%

End Sub 'Display Form

'------------------------------------------------

Sub DisplayEvent(EventCode, Message)

%>
<HTML>
<HEAD>
<TITLE>www.TIX.com - Event Verify Report</TITLE>
</HEAD>
<%
If Message = "" Then
	Response.Write "<BODY BGCOLOR=#FFFFFF>" & vbCrLf
Else
	Response.Write "<BODY BGCOLOR=#FFFFFF onLoad=" & CHR(34) & "alert('" & Message & "')" & CHR(34) & ">" & vbCrLf
End If
Message = ""
%>


<STYLE>	
	TD {FONT-SIZE: 10pt; FONT-FAMILY: "verdana,arial,helvetica"}
</STYLE>

<CENTER>

<!--#include virtual="TopNavInclude.asp" -->

<BR>

<BR>

<FONT FACE=verdana,arial,helvetica COLOR=#008400><H3>Event Activation Report</H3></FONT>
<FONT FACE=verdana,arial,helvetica SIZE=2>
<FORM ACTION="EventActivation.asp" METHOD="post" id=form1 name=form1>

<%

SQLEvent = "SELECT Event.EventCode, Event.VenueCode, Event.ActCode, Event.EventDate, Event.SaleStartDate, Event.SaleEndDate, Event.Phone, Event.EMailAddress, Event.URL, Event.OnSale, Venue.Venue, Venue.Address_1, Venue.Address_2, Venue.City, Venue.State, Venue.Zip_Code, Act.Act, Event.Comments AS EventComments, Act.Comments AS ActComments, Event.SurveyNumber FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode WHERE Event.EventCode = " & EventCode
Set rsEvent = OBJdbConnection.Execute(SQLEvent)

If Not rsEvent.EOF Then
	Response.Write "<TABLE BORDER=""0"">" & vbCrLf
	Response.Write "<TR><TD COLSPAN=""2"" ALIGN=""center""><H3>Event Code - " & rsEvent("EventCode") & "</H3></TD></TR>" & vbCrLf
		
	SQLOrgNum = "SELECT OrganizationVenue.OrganizationNumber, Organization.Organization FROM OrganizationVenue (NOLOCK) INNER JOIN Organization (NOLOCK) ON OrganizationVenue.OrganizationNumber = Organization.OrganizationNumber WHERE VenueCode = " & rsEvent("VenueCode") & " AND Owner=1"
	Set rsOrgNum = OBJdbConnection.Execute(SQLOrgNum)
	
	OwnerOrgNum = rsOrgNum("OrganizationNumber")
	OwnerOrg = rsOrgNum("Organization")
		
	Response.Write "<TR><TD COLSPAN=""2"" VALIGN=""TOP"" ALIGN=""center"">Owner - " & OwnerOrg & " (" & OwnerOrgNum & ")<BR></TD></TR>" & vbCrLf
		
	rsOrgNum.Close
	Set rsOrgNum = nothing
		
	Response.Write "<TR VALIGN=""TOP""><TD WIDTH=""200"" NOWRAP><B>Name of Event:</B></TD><TD>" & rsEvent("Act") & " (ActCode = " & rsEvent("ActCode") & ")</TD></TR>" & vbCrLf
	Response.Write "<TR VALIGN=""TOP""><TD NOWRAP><B>Act Comments:</B></TD><TD>" & rsEvent("ActComments") & "</TD></TR>" & vbCrLf
	Response.Write "<TR VALIGN=""TOP""><TD NOWRAP><B>Event Subtitle:</B></TD><TD>" & rsEvent("EventComments") & "</TD></TR>" & vbCrLf
	Response.Write "<TR VALIGN=""TOP""><TD NOWRAP><B>Event Date:</B></TD><TD>" & FormatDateTime(rsEvent("EventDate"),vbLongDate) & "</TD></TR>" & vbCrLf 
	Response.Write "<TR VALIGN=""TOP""><TD NOWRAP><B>Event Time:</B></TD><TD>" & FormatDateTime(rsEvent("EventDate"), vbLongTime) & "</TD></TR>" & vbCrLf
	Response.Write "<TR VALIGN=""TOP""><TD NOWRAP><B>Venue Name:</B></TD><TD>" & rsEvent("Venue") & " (VenueCode = " & rsEvent("VenueCode") & ")</TD></TR>" & vbCrLf
	Response.Write "<TR VALIGN=""TOP""><TD NOWRAP><B>Venue Address 1:</B></TD><TD>" & rsEvent("Address_1") & "</TD></TR>" & vbCrLf
	Response.Write "<TR VALIGN=""TOP""><TD NOWRAP><B>Venue Address 2:</B></TD><TD>" & rsEvent("Address_2") & "</TD></TR>" & vbCrLf
	Response.Write "<TR VALIGN=""TOP""><TD NOWRAP><B>Venue City, ST ZIP:</B></TD><TD>" & rsEvent("City") & ", " & rsEvent("State") & " " & rsEvent("Zip_Code") & "</TD></TR>" & vbCrLf
	Response.Write "<TR VALIGN=""TOP""><TD NOWRAP><B>Box Office Phone #:</B></TD><TD>" & FormatPhone(rsEvent("Phone"), "United States") & "</TD></TR>" & vbCrLf
	Response.Write "<TR VALIGN=""TOP""><TD NOWRAP><B>Event Web Site (URL):</B></TD><TD>" & rsEvent("URL") & "</TD></TR>" & vbCrLf
	Response.Write "<TR VALIGN=""TOP""><TD NOWRAP><B>Event E-Mail Addr:</B></TD><TD>" & rsEvent("EMailAddress") & "</TD></TR>" & vbCrLf
		
	SQLPrice = "SELECT DISTINCT Section, SeatType, Price.SeatTypeCode, Price, Surcharge, PhoneOrderSurcharge, MailOrderSurcharge, FaxOrderSurcharge, BoxOfficeSurcharge, OnlinePriceFlag, OfflinePriceFlag, StartDate, EndDate FROM Price (NOLOCK) INNER JOIN SeatType (NOLOCK) ON Price.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN Section (NOLOCK) ON Price.SectionCode = Section.SectionCode AND Price.EventCode = Section.EventCode WHERE Price.EventCode = " & rsEvent("EventCode") & " ORDER BY Section, SeatType, Price"
	Set rsPrice = OBJdbConnection.Execute(SQLPrice)
		
	If Not rsPrice.EOF Then
		Response.Write "<TR><TD COLSPAN=""2""><TABLE><TR ALIGN=""CENTER""><TD><B>Section</B></TD><TD><B>Seat Type</B></TD><TD><B>Price</B></TD><TD><B>Online<BR>Service Fee</B></TD><TD><B>Phone Order<BR>Service Fee</B></TD><TD><B>Fax Order<BR>Service Fee</B></TD><TD><B>Mail Order<BR>Service Fee</B></TD><TD><B>Box Office<BR>Service Fee</B></TD><TD><B>Online<BR>Flag</B></TD><TD><B>Offline<BR>Flag</B></TD></TR>" & vbCrLf
		Do Until rsPrice.EOF
			Response.Write "<TR><TD>" & rsPrice("Section") & "</TD><TD>" & rsPrice("SeatType") & " (" & rsPrice("SeatTypeCode") & ")</TD><TD ALIGN=""RIGHT"">" & FormatCurrency(rsPrice("Price"),2) & "</TD><TD ALIGN=""RIGHT"">" & FormatCurrency(rsPrice("Surcharge"),2) & "</TD><TD ALIGN=""RIGHT"">" & FormatCurrency(rsPrice("PhoneOrderSurcharge"),2) & "</TD><TD ALIGN=""RIGHT"">" & FormatCurrency(rsPrice("FaxOrderSurcharge"),2) & "</TD><TD ALIGN=""RIGHT"">" & FormatCurrency(rsPrice("MailOrderSurcharge"),2) & "</TD><TD ALIGN=""RIGHT"">" & FormatCurrency(rsPrice("BoxOfficeSurcharge"),2) & "</TD><TD ALIGN=""RIGHT"">" & rsPrice("OnlinePriceFlag") & "</TD><TD ALIGN=""RIGHT"">" & rsPrice("OfflinePriceFlag") & "</TD></TR>" & vbCrLf
			rsPrice.MoveNext
		Loop
		Response.Write "</TABLE><BR></TD></TR>" & vbCrLf
	End If
		
	rsPrice.Close
	Set rsPrice = nothing

	SQLNumTickets = "SELECT COUNT(ItemNumber) AS NumTickets FROM Seat (NOLOCK) WHERE EventCode = " & rsEvent("EventCode")
	Set rsNumTickets = OBJdbConnection.Execute(SQLNumTickets)
		
	Response.Write "<TR><TD>Number of Tickets:</TD><TD>" & rsNumTickets("NumTickets") & "</TD></TR>" & vbCrLf

	SQLTimeZone = "SELECT OptionValue AS Offset FROM OrganizationOptions (NOLOCK) INNER JOIN OrganizationVenue (NOLOCK) ON OrganizationOptions.OrganizationNumber = OrganizationVenue.OrganizationNumber WHERE OrganizationVenue.VenueCode = " &  rsEvent("VenueCode") & " AND OrganizationVenue.Owner = 1 AND OrganizationOptions.OptionName = 'TimezoneOffset'"
	Set rsTimeZone = OBJdbConnection.Execute(SQLTimeZone)
		
	SQLShipType = "SELECT Shipping.ShipCode, Shipping.ShipType, EventShip.ShipFee, EventShip.StartDate, EventShip.EndDate, EventShip.OnlineShipFlag, EventShip.OfflineShipFlag FROM Shipping (NOLOCK) INNER JOIN EventShip (NOLOCK) ON Shipping.ShipCode = EventShip.ShipCode WHERE EventShip.EventCode = " & rsEvent("EventCode") & " ORDER BY Shipping.ShipType"
	Set rsShipType = OBJdbConnection.Execute(SQLShipType)
		
	If Not rsShipType.EOF Then
		Response.Write "<TR><TD COLSPAN=""2""><BR><TABLE><TR><TD><B>Ship Method</B></TD><TD><B>Price</B></TD><TD><B>Start Date</B></TD><TD><B>End Date</B></TD><TD ALIGN=""CENTER""><B>Online<BR>Flag</B></TD><TD ALIGN=""CENTER""><B>Offline<BR>Flag</B></TD></TR>" & vbCrLf
		Do Until rsShipType.EOF
			Response.Write "<TR><TD>" & rsShipType("ShipType") & " (" & rsShipType("ShipCode") & ")</TD><TD ALIGN=""RIGHT"">" & FormatCurrency(rsShipType("ShipFee"),2) & "</TD><TD>" & DateAndTimeFormat(LocalTime(rsShipType("StartDate"), rsTimeZone("Offset"))) & "</TD><TD>" & DateAndTimeFormat(LocalTime(rsShipType("EndDate"), rsTimeZone("Offset"))) & "</TD><TD ALIGN=""RIGHT"">" & rsShipType("OnlineShipFlag") & "</TD><TD ALIGN=""RIGHT"">" & rsShipType("OfflineShipFlag") & "</TD></TR>" & vbCrLf
			rsShipType.MoveNext
		Loop
		Response.Write "</TABLE><BR></TD></TR>" & vbCrLf
	End If
		
	rsShipType.Close
	Set rsShipType = nothing
		
	Response.Write "<TR><TD><B>Tickets On Sale:</B></TD><TD>" & DateAndTimeFormat(LocalTime(rsEvent("SaleStartDate"), rsTimeZone("Offset"))) & "</TD></TR>"				
	Response.Write "<TR><TD><B>Tickets Off Sale:</B></TD><TD>" & DateAndTimeFormat(LocalTime(rsEvent("SaleEndDate"), rsTimeZone("Offset"))) & "</TD></TR>"				
	
	rsTimeZone.Close
	Set rsTimeZone = nothing
		
	SQLCallCenter = "SELECT OrganizationVenue.OrganizationNumber FROM OrganizationVenue (NOLOCK) INNER JOIN OrganizationAct (NOLOCK) ON OrganizationVenue.OrganizationNumber = OrganizationAct.OrganizationNumber WHERE OrganizationVenue.VenueCode = " & rsEvent("VenueCode") & " AND OrganizationAct.ActCode = " & rsEvent("ActCode") & " AND OrganizationVenue.OrganizationNumber = 11 AND OrganizationAct.OrganizationNumber = 11"
	Set rsCallCenter = OBJdbConnection.Execute(SQLCallCenter)
		
	If rsCallCenter.EOF Then
		CallCenter = "No"
	Else
		CallCenter = "Yes"
	End If
		
	rsCallCenter.Close
	Set rsCallCenter = nothing
		
	Response.Write "<TR><TD><BR><B>Call Center:</B></TD><TD><BR>" & CallCenter & "</TD></TR>"
		
	SQLTixFulfillment = "SELECT TixFulfillment FROM Organization (NOLOCK) INNER JOIN OrganizationVenue (NOLOCK) ON Organization.OrganizationNumber = OrganizationVenue.OrganizationNumber WHERE OrganizationVenue.VenueCode = " & rsEvent("VenueCode") & " AND OrganizationVenue.Owner = 1 AND Organization.TixFulfillment = 1"
	Set rsTixFulfillment = OBJdbConnection.Execute(SQLTixFulfillment)
		
	If rsTixFulfillment.EOF Then
		TixFulfillment = "No"
	Else
		TixFulfillment = "Yes"
	End If
		
	rsTixFulfillment.Close
	Set rsTixFulfillment = nothing
		
	Response.Write "<TR><TD><B>Tix Fulfillment:</B></TD><TD>" & TixFulfillment & "</TD></TR>"
		
	If rsEvent("OnSale") Then
		OnSale = "Yes"
	Else
		OnSale = "No"
	End If
		
	Response.Write "<TR><TD><BR><B>Event On Sale:</B></TD><TD><BR>" & OnSale & "</TD></TR>"
	
	'REE 6/12/6 - Added credit cards accepted
	CCTypes = ""
	SQLCCTypes = "SELECT CCType FROM OrganizationCreditCard (NOLOCK) WHERE OrganizationNumber = " & OwnerOrgNum & " ORDER BY CCType"
	Set rsCCTypes = OBJdbConnection.Execute(SQLCCTypes)
		
	If rsCCTypes.EOF Then
		CCTypes = "American Express, Discover, Mastercard, Visa"
	Else
		Do Until rsCCTypes.EOF
			CCTypes = CCTypes & rsCCTypes("CCType") & ", "
			rsCCTypes.MoveNext
		Loop
		CCTypes = LEFT(CCTypes, LEN(CCTypes) - 2)
	End If
		
	rsCCTypes.Close
	Set rsCCTypes = nothing
	
	Response.Write "<TR><TD COLSPAN=""2"">&nbsp;</TD></TR>" & vbCrLf
		
	Response.Write "<TR><TD NOWRAP><B>Credit Card Types Accepted :</B></TD><TD>" & CCTypes & "</TD></TR>"

	'REE 12/20/4 - Added Discount Codes
	SQLDiscounts = "SELECT DiscountType.DiscountTypeNumber, DiscountType.DiscountCode, DiscountType.DiscountDescription, DiscountEvents.Hidden FROM DiscountEvents (NOLOCK) INNER JOIN DiscountType (NOLOCK) ON DiscountEvents.DiscountTypeNumber = DiscountType.DiscountTypeNumber WHERE DiscountEvents.EventCode = " & EventCode & " ORDER BY DiscountType.DiscountCode"
	Set rsDiscounts = OBJdbConnection.Execute(SQLDiscounts)
	
	If Not rsDiscounts.EOF Then
		Response.Write "<TR><TD COLSPAN=""2""><BR><BR><TABLE CELLPADDING=""5""><TR><TD><B>Discount Code</B></TD><TD><B>Description</B></TD><TD><B>Hidden</B></TD></TR>" & vbCrLf
		Discounts = "Y"
	End If
		
	Do Until rsDiscounts.EOF

		If rsDiscounts("Hidden") = TRUE Then
			Hidden = "Y"
		Else
			Hidden = "N"
		End If
		
		Response.Write "<TR><TD>" & rsDiscounts("DiscountCode") & " (" & rsDiscounts("DiscountTypeNumber") & ")</TD><TD>" & rsDiscounts("DiscountDescription") & "</TD><TD ALIGN=""center"">" & Hidden & "</TD></TR>" & vbCrLf
		
		rsDiscounts.MoveNext
		
	Loop
	
	If Discounts = "Y" Then
		Response.Write "</TABLE></TD></TR>" & vbCrLf
	End If
	
	rsDiscounts.Close
	Set rsDiscounts = nothing
	
	'REE 12/20/4 - Added Survey
	If Not IsNull(rsEvent("SurveyNumber")) And rsEvent("SurveyNumber") <> "" Then
		SQLSurvey = "SELECT SurveyNumber, SurveyFileName FROM Survey (NOLOCK) WHERE SurveyNumber = " & rsEvent("SurveyNumber")
		Set rsSurvey = OBJdbConnection.Execute(SQLSurvey)
	
		If Not rsSurvey.EOF Then
			Response.Write "<TR><TD><BR><BR><B>Survey:</B></TD><TD><BR><BR>" & rsSurvey("SurveyFileName") & " (" & rsSurvey("SurveyNumber") & ")</TD></TR>" & vbCrLf
		End If
	
		rsSurvey.Close
		Set rsSurvey = nothing
	End If
	
	'REE 12/20/4 - Added EventOptions
	SQLEventOptions = "SELECT OptionName, OptionValue FROM EventOptions (NOLOCK) WHERE EventCode = " & EventCode & " ORDER BY OptionName"
	Set rsEventOptions = OBJdbConnection.Execute(SQLEventOptions)
	
	If Not rsEventOptions.EOF Then
		Response.Write "<TR><TD><BR><BR><B>Option Name</B></TD><TD><BR><BR><B>Option Value</B></TD></TR>" & vbCrLf
	End If
	
	Do Until rsEventOptions.EOF
		Response.Write "<TR><TD>" & rsEventOptions("OptionName") & "</TD><TD>" & rsEventOptions("OptionValue") & "</TD></TR>" & vbCrLf
		rsEventOptions.MoveNext
	Loop
		
	rsEventOptions.Close
	Set rsEventOptions = nothing


	'REE 7/7/6 - Added Event Add/Modification History
	Response.Write "<TR><TD COLSPAN=""2""><BR><BR><TABLE CELLPADDING=""5""><TR><TD ALIGN=""center""><B>Action Type</B></TD><TD ALIGN=""center""><B>Date</B></TD><TD ALIGN=""center""><B>User Name</B></TD></TR>" & vbCrLf
	SQLEventHistory = "SELECT EventHistory.ModifyType, EventHistory.ModifyDate, Users.FirstName, Users.LastName FROM EventHistory WITH (NOLOCK) INNER JOIN Users WITH (NOLOCK) ON EventHistory.ModifyUserNumber = Users.UserNumber WHERE EventHistory.EventCode = " & EventCode & " ORDER BY dbo.EventHistory.ModifyDate"
	Set rsEventHistory = OBJdbConnection.Execute(SQLEventHistory)
	
	Do Until rsEventHistory.EOF
		
		If rsEventHistory("ModifyType") = "After" Then
			ModifyType = "Update"
		Else
			ModifyType = rsEventHistory("ModifyType")
		End If
			
		If ModifyType <> "Before" Then 'Do not write out before records since after records are being written.	
			Response.Write "<TR><TD>" & ModifyType & "</TD><TD>" & rsEventHistory("ModifyDate") & "</TD><TD>" & rsEventHistory("FirstName") & " " & rsEventHistory("LastName") & "</TD></TR>" & vbCrLf		
		End If
		
		rsEventHistory.MoveNext
		
	Loop
	
	rsEventHistory.Close
	Set rsEventHistory = nothing
	
	Response.Write "</TABLE><BR></TD></TR>" & vbCrLf

	
	If SecurityCheck("EventActivation") = True Then 'Allow Activate and Deactivate
		Response.Write "<TR><TD COLSPAN=""2"" ALIGN=""center""><FORM ACTION=""EventActivation.asp"" METHOD=""post"" id=form2 name=form2><INPUT TYPE=""hidden"" NAME=""NextFormName"" VALUE=""ActivateEvent""><INPUT TYPE=""hidden"" NAME=""EventCode"" VALUE=""" & EventCode & """>" & vbCrLf

		If OnSale <> "Yes" Then
			Response.Write "<FONT FACE=""verdana, arial, helvetica"" SIZE=""2"">By clicking on the ""Activate Event"" button below, you acknowledge<BR>that the above information is accurate and complete.</FONT><BR><BR>" & vbCrLf
			Response.Write "<INPUT TYPE=""submit"" NAME=""Submit"" VALUE=""Activate Event"">" & vbCrLf
		Else
			Response.Write "<INPUT TYPE=""submit"" NAME=""Submit"" VALUE=""DeActivate Event"">" & vbCrLf
		End If
		Response.Write "</FORM><BR></TD></TR>" & vbCrLf

	End If
	
	Response.Write "<TR><TD COLSPAN=""2"" ALIGN=""center""><FORM ACTION=""EventActivation.asp"" METHOD=""post""><INPUT TYPE=""submit"" VALUE=""Return To Listing""></FORM></TD></TR>"

	If SecurityCheck("EventCopy") = TRUE Then
		Response.Write "<TR><TD COLSPAN=""2"" ALIGN=""center""><FORM ACTION=""/Management/EventCopy.asp"" METHOD=""post"" id=form2 name=form2><INPUT TYPE=""hidden"" NAME=""EventCode"" VALUE=""" & EventCode & """><INPUT TYPE=""submit"" VALUE=""Copy"" id=1 name=1></FORM></TD></TR>"
	End If
		

	Response.Write "</TABLE>" & vbCrLf
		
End If


rsEvent.Close
Set rsEvent = Nothing

%>

</FONT>
<BR>
<BR>
<BR>
<FONT SIZE="1" FACE="verdana, helvetica, arial">Copyright © <%= Year(Now)%> Tix, Inc.  All rights reserved.</FONT>

</CENTER>
</BODY>
</HTML>

<%
End Sub 'Display Report

'====================================

Sub ActivateEvent

EventCode = Clean(Request("EventCode"))

If Clean(Request("Submit")) = "Activate Event" Then
	OnSale = 1
	Message = "Event Has Been Activated"
Else
	OnSale = 0
	Message = "Event Has Been Deactivated"
End If

'Check to make sure this is one of the user's events.
SQLEvent = "SELECT EventCode FROM Event (NOLOCK) INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE Event.EventCode = " & EventCode & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber")
Set rsEvent = OBJdbConnection.Execute(SQLEvent)

If Not rsEvent.EOF And SecurityCheck("EventActivation") = True Then 'It's okay to update it.

	SQLActivateEvent = "UPDATE Event WITH (ROWLOCK) SET OnSale = " & OnSale & " WHERE EventCode = " & EventCode
	Set rsActivateEvent = OBJdbConnection.Execute(SQLActivateEvent)
	
	If OnSale = 1 Then
		HistoryType = "Activation"
	Else
		HistoryType = "Deactivation"
	End If

	'Log Event History at the time of activation/deactivation
	SQLLogEventMod = "INSERT EventHistory SELECT EventCode, ActCode, VenueCode, EventDate, URL, Capacity, Map, EventType, Comments, SaleStartDate, SaleEndDate, OnSale, Phone, Fax, EMailAddress, SurveyNumber, SelectTicketsButton, BestAvailableButton, GETDATE(), '" & HistoryType & "', " & Session("UserNumber") & ", '" & Request.ServerVariables("REMOTE_ADDR") & "' FROM Event (NOLOCK) WHERE EventCode = " & EventCode 
	Set rsLogEventMod = OBJdbConnection.Execute(SQLLogEventMod)

	'Log Price Records at the time of activation/deactivation
	SQLLogPriceMod = "INSERT PriceHistory SELECT EventCode, SectionCode, SeatTypeCode, Price, Surcharge, PhoneOrderSurcharge, FaxOrderSurcharge, MailOrderSurcharge, BoxOfficeSurcharge, OnlinePriceFlag, OfflinePriceFlag, StartDate, EndDate, GETDATE(), '" & HistoryType & "', " & Session("UserNumber") & ", '" & Request.ServerVariables("REMOTE_ADDR") & "' FROM Price WHERE EventCode = " & EventCode
	Set rsLogPriceMod = OBJdbConnection.Execute(SQLLogPriceMod)
		
	'Log EventShip Records at the time of activation/deactivation
	SQLLogEventShipMod = "INSERT EventShipHistory SELECT EventCode, ShipCode, StartDate, EndDate, ShipFee, OnLineShipFlag, OffLineShipFlag, GETDATE(), '" & HistoryType & "', " & Session("UserNumber") & ", '" & Request.ServerVariables("REMOTE_ADDR") & "' FROM EventShip WHERE EventCode = " & EventCode
	Set rsLogEventShipMod = OBJdbConnection.Execute(SQLLogEventShipMod)

	
Else
	
	Message = "You are not authorized to activate or deactivate this event."
	
End If

rsEvent.Close
Set rsEvent = nothing

Call DisplayEvent(EventCode, Message)

End Sub 'ActivateEvent

'====================================

%>
