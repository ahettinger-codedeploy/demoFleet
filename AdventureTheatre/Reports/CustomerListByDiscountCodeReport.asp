<!--#include virtual="GlobalInclude.asp"-->
<!--#include virtual="dbOpenInclude.asp"-->

<%

'Customer List By Discount Code Report (3/26/2010)
'Creates a Customer List sorted by discount code

'Update: 6/7/2010
'Added Order Notes

Page = "ManagementReport"
ReportFileName = "CustomerListByDiscountCodeReport.asp"
ReportTitle = "Customer List by Discount Code"

If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then Response.Redirect("/Management/Default.asp")

If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then Response.Redirect("/Management/Default.asp")

If Request("btnSubmit") = "Submit" Then
    Call ReportOutput
Else
    If Request("FormName") = "DisplayOrders" Then
        Call DisplayOrders
    Else
        Call ReportCriteria
    End If
End If        

Sub ReportCriteria
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
    <title><%= ReportTitle %></title>
    <link href="/CSS/Report.css" rel="stylesheet" type="text/css" />
</head>
<body>


<!--#include virtual="TopNavInclude.asp" -->

<div class="pageTitle"><%= ReportTitle %></div>

<form name="ReportCriteria" action="<%= ReportFileName %>" method="post">
<%
EventListDaysDefault = 30
%>
<fieldset style="width: 600px;" class="reportCriteriaField">
    <legend class="reportCriteriaFieldTitle">Event Selection</legend>

    <!--#INCLUDE VIRTUAL="/Include/EventListDayInclude.asp" -->

    <!--#INCLUDE VIRTUAL="/Include/EventSelectionInclude.asp" -->
</fieldset>
<br />

<input type="submit" value="Submit" name="btnSubmit" onclick="return validateForm();" />

</form>

<script language="javascript" type="text/javascript">
function validateForm() {
    formObj = document.ReportCriteria;
    <%= jsValidateForm %>
}
</script>

<!--#include virtual="FooterInclude.asp"-->


</body>
</html>
<%

End Sub 'ReportCriteria

'=======================

Sub ReportOutput

'REE 1/16/9 - Added Excel Output option
Excel = Clean(Request("ExcelOutput"))

If Excel = "Y" Then

	Response.ContentType = "application/vnd.ms-excel"

End If

%>
<HTML>
<HEAD>
<TITLE>Tix - Discount Code Report</TITLE>
</HEAD>
<BODY BGCOLOR="#FFFFFF">


<% If Excel <> "Y" Then %>
    <!--#include virtual="TopNavInclude.asp" -->
<% End If %>

<BR>
<BR>

<FONT FACE=verdana,arial,helvetica COLOR=#008400><H3>Customer List by Discount Code</H3></FONT>
<FONT FACE=verdana,arial,helvetica SIZE=2>Select a discount code to view patron data</FONT><br />
<FONT FACE=verdana,arial,helvetica SIZE=2>
<FORM ACTION="CustomerListByDiscountCodeReport.asp" METHOD="post" id=form1 name=form1>

<%

EventTicketCount = 0
EventFaceValue = 0
EventDiscount = 0
EventNet = 0
TotalTicketCount = 0
TotaFaceValue = 0
TotalDiscount = 0
TotalNet = 0

'For each event chosen from the previous page, display the data
If Request("EventCode") <> "" Then
	EventList = "("
	For Each EventCode In Request("EventCode")
		EventList = EventList & EventCode & ","
	Next 'Event
	EventList = Left(EventList, Len(EventList)-1) & ")"
	
	'REE 5/28/3 - Modified to use LEFT JOIN on Seat Table.  Program blew up if there were no seats assigned to an event...Client deleted all seats.	
	SQLDiscount = "SELECT DiscountType.DiscountTypeNumber, DiscountDescription, UPPER(DiscountCode) AS DiscountCode, COUNT(OrderLine.LineNumber) AS TicketCount, SUM(OrderLine.Price) AS FaceValue, SUM(OrderLine.Discount) AS Discount FROM Orderline (NOLOCK) INNER JOIN Orderheader (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN DiscountType (NOLOCK) ON OrderLine.DiscountTypeNumber = DiscountType.DiscountTypeNumber WHERE Event.EventCode IN " & EventList & " AND OrderHeader.StatusCode = 'S' AND DiscountCode IS NOT NULL GROUP BY DiscountType.DiscountTypeNumber, DiscountDescription, DiscountCode ORDER BY DiscountType.DiscountTypeNumber, DiscountDescription, DiscountCode"
 	Set rsDiscount = OBJdbConnection.Execute(SQLDiscount)

	If Not rsDiscount.EOF Then

'		LastEventCode = rsDiscount("EventCode")
'		SQLEvents = "SELECT EventDate, Act, Event.EventCode FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode WHERE Event.EventCode = " & LastEventCode
'		Set rsEvents = OBJdbConnection.Execute(SQLEvents)
'
'		If Hour(rsEvents("EventDate")) > 12 Then
'			EventHour = Hour(rsEvents("EventDate")) - 12
'			APM = " PM"
'		Else
'			EventHour = Hour(rsEvents("EventDate"))
'			APM = " AM"
'		End If
'					
'		EventTime = EventHour & ":" & Right("00" & Minute(rsEvents("EventDate")), 2) & APM

		Response.Write "<TABLE CELLPADDING=4>" & vbCrLf
'		Response.Write "<TR BGCOLOR=#008400><TD COLSPAN=4><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><B>" & rsEvents("Act") & "</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2 COLOR=#FFFFFF><B>" & FormatDateTime(rsEvents("EventDate"), vbShortDate) & "</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2 COLOR=#FFFFFF><B>" & EventTime & "</B></FONT></TD></TR>" & vbCrLf
		Response.Write "<TR BGCOLOR=#008400><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><B>Discount Description</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><B>Discount Code</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><B>Ticket Count</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><B>Face Value</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><B>Discount</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><B>Net Price</B></FONT></TD></TR>" & vbCrLf

		Do Until rsDiscount.EOF

			If rsDiscount("DiscountTypeNumber") <> LastDiscountTypeNumber Then
		
				EventTotal = EventRevenue + EventServiceFees - EventDiscount
'				Response.Write "<TR BGCOLOR=#AAAAAA><TD ALIGN=center COLSPAN=2><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Event Total</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B>" & FormatNumber(EventTicketCount,0) & "</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B>" & FormatCurrency(EventFaceValue, 2) & "</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B>" & FormatCurrency(EventDiscount, 2) & "</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B>" & FormatCurrency(EventNet, 2) & "</B></FONT></TD></TR>" & vbCrLf
				TotalTicketCount = TotalTicketCount + EventTicketCount
				EventTicketCount = 0
				TotalFaceValue = TotalFaceValue + EventFaceValue
				EventFaceValue = 0
				TotalDiscount = TotalDiscount + EventDiscount
				EventDiscount = 0
				TotalNet = TotalNet + EventNet
				EventNet = 0
				LastDiscountTypeNumber = rsDiscount("DiscountTypeNumber")
				
'				SQLEvents = "SELECT EventDate, Act, Event.EventCode FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode WHERE Event.EventCode = " & LastEventCode
'				Set rsEvents = OBJdbConnection.Execute(SQLEvents)
'
'				If Hour(rsEvents("EventDate")) > 12 Then
'					EventHour = Hour(rsEvents("EventDate")) - 12
'					APM = " PM"
'				Else
'					EventHour = Hour(rsEvents("EventDate"))
'					APM = " AM"
'				End If
'					
'				EventTime = EventHour & ":" & Right("00" & Minute(rsEvents("EventDate")), 2) & APM
'
'				Response.Write "<TR BGCOLOR=#008400><TD COLSPAN=4><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><B>" & rsEvents("Act") & "</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2 COLOR=#FFFFFF><B>" & FormatDateTime(rsEvents("EventDate"), vbShortDate) & "</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2 COLOR=#FFFFFF><B>" & EventTime & "</B></FONT></TD></TR>" & vbCrLf
'				Response.Write "<TR BGCOLOR=#AAAAAA><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Discount Description</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Discount Code</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Ticket Count</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Face Value</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Discount</B></FONT></TD><TD ALIGN=center><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Net Price</B></FONT></TD></TR>" & vbCrLf

			End If
			
			If Excel <> "Y" Then
			    Response.Write "<TR BGCOLOR=#DDDDDD><TD><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsDiscount("DiscountDescription") & "</FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><A HREF=""CustomerListByDiscountCodeReport.asp?FormName=DisplayOrders&DiscountTypeNumber=" & rsDiscount("DiscountTypeNumber") & "&EventList=" & Mid(EventList,2,Len(EventList) - 2) & """>" & rsDiscount("DiscountCode") & "</A></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2>" & FormatNumber(rsDiscount("TicketCount"), 0) & "</FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2>" & FormatCurrency(rsDiscount("FaceValue"), 2) & "</FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2>" & FormatCurrency(rsDiscount("Discount"), 2) & "</FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2>" & FormatCurrency(rsDiscount("FaceValue") - rsDiscount("Discount"), 2) & "</FONT></TD></TR>" & vbCrLf
			Else
			    Response.Write "<TR BGCOLOR=#DDDDDD><TD><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsDiscount("DiscountDescription") & "</FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsDiscount("DiscountCode") & "</A></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2>" & FormatNumber(rsDiscount("TicketCount"), 0) & "</FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2>" & FormatCurrency(rsDiscount("FaceValue"), 2) & "</FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2>" & FormatCurrency(rsDiscount("Discount"), 2) & "</FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2>" & FormatCurrency(rsDiscount("FaceValue") - rsDiscount("Discount"), 2) & "</FONT></TD></TR>" & vbCrLf
			End If

			EventTicketCount = EventTicketCount + rsDiscount("TicketCount")
			EventFaceValue = EventFaceValue + rsDiscount("FaceValue")
			EventDiscount = EventDiscount + rsDiscount("Discount")
			EventNet = EventNet + rsDiscount("FaceValue") - rsDiscount("Discount")

			rsDiscount.MoveNext	
		Loop

'		Response.Write "<TR BGCOLOR=#AAAAAA><TD ALIGN=center COLSPAN=2><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Event Total</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B>" & FormatNumber(EventTicketCount,0) & "</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B>" & FormatCurrency(EventFaceValue, 2) & "</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B>" & FormatCurrency(EventDiscount, 2) & "</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B>" & FormatCurrency(EventNet, 2) & "</B></FONT></TD></TR>" & vbCrLf
		TotalTicketCount = TotalTicketCount + EventTicketCount
		EventTicketCount = 0
		TotalFaceValue = TotalFaceValue + EventFaceValue
		EventFaceValue = 0
		TotalDiscount = TotalDiscount + EventDiscount
		EventDiscount = 0
		TotalNet = TotalNet + EventNet
		EventNet = 0
		Response.Write "<TR BGCOLOR=#DDDDDD><TD ALIGN=center COLSPAN=2><FONT FACE='verdana,arial,helvetica' SIZE=2><B>Total</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B>" & FormatNumber(TotalTicketCount,0) & "</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B>" & FormatCurrency(TotalFaceValue, 2) & "</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B>" & FormatCurrency(TotalDiscount, 2) & "</B></FONT></TD><TD ALIGN=right><FONT FACE='verdana,arial,helvetica' SIZE=2><B>" & FormatCurrency(TotalNet, 2) & "</B></FONT></TD></TR>" & vbCrLf

		Response.Write "</TABLE>" & vbCrLf
	Else
		Response.Write "There were no discount codes used for these events."
	End If	
Else				
	Response.Write "There were no events selected."
End If
		
%>

</FONT>


<% If Excel <> "Y" Then %>
    <!--#INCLUDE VIRTUAL="FooterInclude.asp"-->
<% End If %>

</BODY>
</HTML>

<%
End Sub 'Display Report

'=======================================

Sub DisplayOrders

'REE 2/26/9 - Added ability to output to Excel
Excel = Clean(Request("ExcelOutput"))
If Excel = "Y" Then
	Response.ContentType = "application/vnd.ms-excel"
End If

%>

<HTML>
<HEAD>
<TITLE>Tix - Discount Code Report</TITLE>
</HEAD>
<BODY BGCOLOR="#FFFFFF">


<% If Excel <> "Y" Then %>
    <!--#include virtual="TopNavInclude.asp" -->
<% End If %>
<BR>
<BR>

<FONT FACE=verdana,arial,helvetica COLOR=#008400><H3>Customer List by Discount Code Report</H3></FONT>
<FONT FACE=verdana,arial,helvetica SIZE=2>

<%

'REE 11/3/2 - Modified to get Seat and Donation orders.
SQLOrderHeader = "SELECT DISTINCT Customer.FirstName, Customer.LastName, Customer.CustomerNumber, Customer.Address1, Customer.Address2, Customer.City, Customer.State, Customer.PostalCode, Customer.Country, Customer.DayPhone, Customer.NightPhone, Customer.EmailAddress, Customer.OptIn, OrderHeader.OrderNumber, OrderHeader.Total, OrderHeader.OrderDate, OrderHeader.StatusCode, OrderHeader.StatusDate FROM OrderHeader (NOLOCK) INNER JOIN OrderLine (NOLOCK) ON OrderHeader.OrderNumber = OrderLine.OrderNumber INNER JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCOde INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode WHERE OrderLine.DiscountTypeNumber = " & Clean(Request("DiscountTypeNumber")) & " AND Seat.EventCode IN (" & Clean(Request("EventList")) & ") AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " ORDER BY OrderHeader.OrderNumber"
Set rsOrderHeader = OBJdbConnection.Execute(SQLOrderHeader)

If Not rsOrderHeader.EOF Then

	SQLDiscountCode = "SELECT DiscountCode, DiscountDescription FROM DiscountType (NOLOCK) WHERE DiscountTypeNumber = " & Clean(Request("DiscountTypeNumber")) & " AND OrganizationNumber = " & Session("OrganizationNumber")
	Set rsDiscountCode = OBJdbConnection.Execute(SQLDiscountCode)
	
	Response.Write "<FONT FACE=verdana,arial,helvetica SIZE=2>" & rsDiscountCode("DiscountCode") & " - " & rsDiscountCode("DiscountDescription") & "</FONT><BR><BR>" & vbCrLf

    If Excel <> "Y" Then	
        Response.Write "<TABLE CELLPADDING=3><TR BGCOLOR=#008400><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Customer Number</B></FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>First Name</B></FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Last Name</B></FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Address Line 1</B></FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Address Line 2</B></FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>City</B></FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>State</B></FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Postal Code</B></FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Country</B></FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Day Phone</B></FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Night Phone</B></FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>E-Mail Address</B></FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Mailing List</B></FONT></TD></TR>" & vbCrLf
    Else
        Response.Write "<TABLE CELLPADDING=3><TR BGCOLOR=#008400><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Customer Number</B></FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>First Name</B></FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Last Name</B></FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Address Line 1</B></FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Address Line 2</B></FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>City</B></FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>State</B></FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Postal Code</B></FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Country</B></FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Day Phone</B></FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Night Phone</B></FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>E-Mail Address</B></FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2 COLOR=#FFFFFF><B>Mailing List</B></FONT></TD></TR>" & vbCrLf
    End If
	rsDiscountCode.Close
	Set rsDiscountCode = nothing
	
End If


Do Until rsOrderHeader.EOF

	Select Case rsOrderHeader("StatusCode")
		Case "R" 'Reserved
			strStatus = "Incomplete"
		Case "C" 'Cancelled
			strStatus = "<FONT COLOR=Red>Cancelled</FONT>"
		Case "H" 'On Hold
			strStatus = "On Hold"
		Case "S" 'Shipped
			strStatus = "Complete"
		Case Else 'Pending
			strStatus = "Incomplete"
	End Select
	
	Select Case rsOrderHeader("Customer.OptIn") 
	    Case "True"
	        MailingList = "Yes"
	    Case "False"
	        MailingList = "No"
	End Select
	
	
	If Excel <> "Y" Then
        Response.Write "<TR BGCOLOR=#DDDDDD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsOrderHeader("CustomerNumber") & "</FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsOrderHeader("FirstName") & "</FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsOrderHeader("LastName") & "</FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsOrderHeader("Address1") & "</FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsOrderHeader("Address2") & "</FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsOrderHeader("City") & "</FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsOrderHeader("State") & "</FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsOrderHeader("PostalCode") & "</FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsOrderHeader("Country") & "</FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & FormatPhone(rsOrderHeader("DayPhone"), rsOrderHeader("Country")) & "</FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & FormatPhone(rsOrderHeader("NightPhone"), rsOrderHeader("Country")) & "</FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsOrderHeader("EMailAddress") & "</FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & MailingList & "</FONT></TD></TR>" & vbCrLf
    Else
        Response.Write "<TR BGCOLOR=#DDDDDD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsOrderHeader("CustomerNumber") & "</FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsOrderHeader("FirstName") & "</FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsOrderHeader("LastName") & "</FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsOrderHeader("Address1") & "</FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsOrderHeader("Address2") & "</FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsOrderHeader("City") & "</FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsOrderHeader("State") & "</FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsOrderHeader("PostalCode") & "</FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsOrderHeader("Country") & "</FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & FormatPhone(rsOrderHeader("DayPhone"), rsOrderHeader("Country")) & "</FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & FormatPhone(rsOrderHeader("NightPhone"), rsOrderHeader("Country")) & "</FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsOrderHeader("EMailAddress") & "</FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & MailingList & "</FONT></TD></TR>" & vbCrLf
    End If
    
	rsOrderHeader.MoveNext
Loop

Response.Write "</TABLE>" & vbCrLf

'REE 2/26/9 - Added Output to Excel Option
If Excel <> "Y" Then
    Response.Write "<FORM ACTION=""CustomerListByDiscountCodeReport.asp"" METHOD=""post"" NAME=""Report""><INPUT TYPE=""hidden"" NAME=""btnSubmit"" VALUE=""Submit"">" & vbCrLf
    'Response.Write "<INPUT TYPE=""hidden"" NAME=""EventCode"" VALUE=""" & Clean(Request("EventList")) & """><INPUT TYPE=""submit"" VALUE=""Back""></FORM><BR>" & vbCrLf
	Response.Write "<INPUT TYPE=""hidden"" NAME=""EventCode"" VALUE=""" & Clean(Request("EventList")) & """><INPUT TYPE=""submit"" VALUE=""Back"" id=1 name=1></FORM><BR>" & vbCrLf

    'Excel Output Option
    Response.Write "<FORM ACTION=""CustomerListByDiscountCodeReport.asp"" METHOD=""post"" NAME=""Report"">" & vbCrLf
    Response.Write "<INPUT TYPE=""hidden"" NAME=""FormName"" VALUE=""DisplayOrders"">" & vbCrLf
    Response.Write "<INPUT TYPE=""hidden"" NAME=""DiscountTypeNumber"" VALUE=""" & CLng(CleanNumeric(Request("DiscountTypeNumber"))) & """>" & vbCrLf
    Response.Write "<INPUT TYPE=""hidden"" NAME=""EventList"" VALUE=""" & Clean(Request("EventList")) & """>" & vbCrLf
    Response.Write "<BR><INPUT TYPE=""checkbox"" NAME=""ExcelOutput"" VALUE=""Y"">&nbsp;Output To Excel<BR><BR>" & vbCrLf
    Response.Write "<INPUT TYPE=""submit"" VALUE=""Output to Excel""></FORM>" & vbCrLf
End If

Response.Write "</FONT>"

If Excel <> "Y" Then 

%>
    <!--#INCLUDE VIRTUAL="FooterInclude.asp"-->
<%

End If

Response.Write "</BODY>" & vbCrLf
Response.Write "</HTML>" & vbCrLf

End Sub 'DisplayOrders

%>
