<!--#include virtual="GlobalInclude.asp"-->
<!--#include virtual="dbOpenInclude.asp"-->
<%
Page = "ManagementReport"

SecurityFunction = "CustomSalesDetailCustNbr"

'set the flag to include the TooltipInclude.html file
TooltipIncludeFlag = "Y"
ColumnCount = 32

If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then Response.Redirect("/Management/Default.asp")

If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then Response.Redirect("/Management/Default.asp")

If SecurityCheck(SecurityFunction) = False Then Response.Redirect("/Management/Default.asp")

ReportFileName = "OrgWillCallReport.asp"

ReportTitle = "Will Call Report"

If Request("btnSubmit") = "Submit" Then
    Call ReportOutput
Else
    Call ReportCriteria
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
fldTitle = "Transaction Date Range"
fldStartDate = "TransactionStartDate"
fldEndDate = "TransactionEndDate"
StartDateDefault = FormatDateTime(Now(), vbShortDate)
EndDateDefault = FormatDateTime(Now(), vbShortDate)
%>



<p></p>
<%
EventListDaysDefault = 30
%>
<fieldset style="width: 600px;" class="reportCriteriaField">
    <legend class="reportCriteriaFieldTitle">Event Selection</legend>

    <!--#INCLUDE VIRTUAL="/Include/EventListDayInclude.asp" -->



<%

'-------------------------------------------------------
'INCLUDE VIRTUAL="/Include/EventSelectionInclude.asp
'-------------------------------------------------------

    'CHANGE LOG
    'TTT 11/8/12 - Modified to submit to the right form via link sortings
	
%>
<SCRIPT LANGUAGE="JavaScript">    

<!-- Hide code from non-js browsers

function makeCheckEvent(thisForm){
    if(thisForm.EventCode.length > 1) {
	    for (i = 0; i < thisForm.EventCode.length; i++){
		    if(thisForm.SelectAllEvents.checked==true){
			    thisForm.EventCode[i].checked=true
			} else {
			    thisForm.EventCode[i].checked=false
			}
		}
	} else {
	    if(thisForm.SelectAllEvents.checked==true){
	        thisForm.EventCode.checked=true
	    } else {
	        thisForm.EventCode.checked=false
	    }
	}
}

function eventSelectedCheck(thisForm){
	
	var EventCodeSelected = false;
	var EventCodeIndex = 0;

	//Check for Event Selection.	
	if (formObj.EventCode.length){ //There's multiple events
		for (var i=0;i<formObj.EventCode.length; i++){ 
			if (eval("formObj.EventCode[i].checked") == true){	        
				EventCodeSelected = true;
				EventCodeIndex = formObj.EventCode[i].value;
				}
			}
		}
	else{ //There's only one event
		if (formObj.EventCode.checked == true){	        
			EventCodeSelected = true;
			EventCodeIndex = formObj.EventCode.value;
			}
		}	
	if (EventCodeSelected != true){ //Event not selected.
		alert("Please select at least one Event.");
		return false;
		}
}

function GoSorting(column) {
    var formObj = document.getElementById('SelectAllEvents').form
    document.getElementById("SortMethod").value = column;
    formObj.submit();
}	
	
// end hiding -->
</SCRIPT>

<%

If EventListDays = "" Then
    EventListDays = 30 'Default Event List Days
End If

If EventFutureDays <> "" Then
    DateFiltered = "EventDate >= '" & DateAdd("D", - EventListDays, LocalDateTime(Session("OrganizationNumber"), FormatDateTime(Now(), VBShortDate))) & "' AND EventDate < '" & DateAdd("D", EventFutureDays, LocalDateTime(Session("OrganizationNumber"), FormatDateTime(Now(), VBShortDate))) & "'"
Else
    DateFiltered = "EventDate > GETDATE()-" & EventListDays
End If

'REE 4/6/2 - Modified to include OrganizationAct selection criteria
Select Case Request("SortMethod")
	'REE 12/11/6 - Added Event Status (Event.OnSale)
	Case "Act"
		SQLEvents = "SELECT Event.EventCode, Act, COALESCE (Act.Act + ActSuffix.ActSuffix, Act.Act) AS Act2, Venue, EventDate, Event.OnSale, COUNT(Seat.ItemNumber) AS SeatCount FROM Event (NOLOCK) LEFT JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode LEFT JOIN OrderLine (NOLOCK) on Seat.ItemNumber = OrderLine.ItemNumber AND Seat.OrderNumber = OrderLine.OrderNumber LEFT JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode LEFT OUTER JOIN (SELECT EventCode, COALESCE (' - ' + OptionValue, '') AS ActSuffix FROM EventOptions AS EventOptions_1 WITH (NOLOCK) WHERE (OptionName = 'ActSuffix')) AS ActSuffix ON Event.EventCode = ActSuffix.EventCode WHERE " & DateFiltered & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND Seat.StatusCode='S' GROUP BY EventDate, Act, ActSuffix, Venue, Event.OnSale, Event.EventCode ORDER BY Act, Venue, EventDate"
	Case "Venue"
		SQLEvents = "SELECT Event.EventCode, Act, COALESCE (Act.Act + ActSuffix.ActSuffix, Act.Act) AS Act2, Venue, EventDate, Event.OnSale, COUNT(Seat.ItemNumber) AS SeatCount FROM Event (NOLOCK) LEFT JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode LEFT JOIN OrderLine (NOLOCK) on Seat.ItemNumber = OrderLine.ItemNumber AND Seat.OrderNumber = OrderLine.OrderNumber LEFT JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode LEFT OUTER JOIN (SELECT EventCode, COALESCE (' - ' + OptionValue, '') AS ActSuffix FROM EventOptions AS EventOptions_1 WITH (NOLOCK) WHERE (OptionName = 'ActSuffix')) AS ActSuffix ON Event.EventCode = ActSuffix.EventCode WHERE " & DateFiltered & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND Seat.StatusCode='S' GROUP BY EventDate, Act, ActSuffix, Venue, Event.OnSale, Event.EventCode ORDER BY Venue, EventDate"
	Case "EventCode"
		SQLEvents = "SELECT Event.EventCode, Act, COALESCE (Act.Act + ActSuffix.ActSuffix, Act.Act) AS Act2, Venue, EventDate, Event.OnSale, COUNT(Seat.ItemNumber) AS SeatCount FROM Event (NOLOCK) LEFT JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode LEFT JOIN OrderLine (NOLOCK) on Seat.ItemNumber = OrderLine.ItemNumber AND Seat.OrderNumber = OrderLine.OrderNumber LEFT JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode LEFT OUTER JOIN (SELECT EventCode, COALESCE (' - ' + OptionValue, '') AS ActSuffix FROM EventOptions AS EventOptions_1 WITH (NOLOCK) WHERE (OptionName = 'ActSuffix')) AS ActSuffix ON Event.EventCode = ActSuffix.EventCode WHERE " & DateFiltered & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND Seat.StatusCode='S' GROUP BY EventDate, Act, ActSuffix, Venue, Event.OnSale, Event.EventCode ORDER BY EventCode"
	Case "Status"
		SQLEvents = "SELECT Event.EventCode, Act, COALESCE (Act.Act + ActSuffix.ActSuffix, Act.Act) AS Act2, Venue, EventDate, Event.OnSale, COUNT(Seat.ItemNumber) AS SeatCount FROM Event (NOLOCK) LEFT JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode LEFT JOIN OrderLine (NOLOCK) on Seat.ItemNumber = OrderLine.ItemNumber AND Seat.OrderNumber = OrderLine.OrderNumber LEFT JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode LEFT OUTER JOIN (SELECT EventCode, COALESCE (' - ' + OptionValue, '') AS ActSuffix FROM EventOptions AS EventOptions_1 WITH (NOLOCK) WHERE (OptionName = 'ActSuffix')) AS ActSuffix ON Event.EventCode = ActSuffix.EventCode WHERE " & DateFiltered & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND Seat.StatusCode='S' GROUP BY EventDate, Act, ActSuffix, Venue, Event.OnSale, Event.EventCode ORDER BY OnSale, EventDate, Act"
	Case Else
		SQLEvents = "SELECT Event.EventCode, Act, COALESCE (Act.Act + ActSuffix.ActSuffix, Act.Act) AS Act2, Venue, EventDate, Event.OnSale, COUNT(Seat.ItemNumber) AS SeatCount FROM Event (NOLOCK) LEFT JOIN Seat (NOLOCK) ON Event.EventCode = Seat.EventCode LEFT JOIN OrderLine (NOLOCK) on Seat.ItemNumber = OrderLine.ItemNumber AND Seat.OrderNumber = OrderLine.OrderNumber LEFT JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode LEFT OUTER JOIN (SELECT EventCode, COALESCE (' - ' + OptionValue, '') AS ActSuffix FROM EventOptions AS EventOptions_1 WITH (NOLOCK) WHERE (OptionName = 'ActSuffix')) AS ActSuffix ON Event.EventCode = ActSuffix.EventCode WHERE " & DateFiltered & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND Seat.StatusCode='S' GROUP BY EventDate, Act, ActSuffix, Venue, Event.OnSale, Event.EventCode ORDER BY EventDate, Act"
End Select
Set rsEvents = OBJdbConnection.Execute(SQLEvents)

Response.Write "<INPUT TYPE=""hidden"" NAME=""SortMethod"" ID=""SortMethod"" VALUE=""Date"">" & vbCrLf

Response.Write "<TABLE CELLPADDING=""3"" BORDER=""1"" WIDTH=""100%"">" & vbCrLf
Response.Write "<TR CLASS=""SectionHeading"">" & vbCrLf
Response.Write "<TD ALIGN=""center""><INPUT TYPE=""checkbox"" Name=""SelectAllEvents"" onClick=""makeCheckEvent(this.form)"" id=SelectAllEvents></TD>" & vbCrLf
Response.Write "<TD ALIGN=center><A class=sort HREF=""#"" onclick=""GoSorting('Date')"">Date/Time</A></TD>" & vbCrLf
Response.Write "<TD ALIGN=center><A class=sort HREF=""#"" onclick=""GoSorting('Act')"">Production</A></TD>" & vbCrLf
Response.Write "<TD ALIGN=center><A class=sort HREF=""#"" onclick=""GoSorting('Venue')"">Venue</A></TD>" & vbCrLf
Response.Write "<TD ALIGN=center><A class=sort HREF=""#"" onclick=""GoSorting('Tickets')"">Tickets</A></TD>" & vbCrLf
Response.Write "</TR>" & vbCrLf

RecordCounter = 0
EventCodesArray = Split(Request("EventCode"),",")
Do Until rsEvents.EOF

    StatusEvent = ""
    For i = 0 to UBound(EventCodesArray)
        If CLng(EventCodesArray(i)) = CLng(rsEvents("EventCode")) Then
            StatusEvent = " checked = checked"
        End If
    Next
    
	Response.Write "<TR CLASS=""Detail"">" & vbCrLf
	Response.Write "<TD ALIGN=""center""><INPUT TYPE=""checkbox"" NAME=""EventCode"" VALUE=" & rsEvents("EventCode") & StatusEvent & "></TD>" & vbCrLf
	Response.Write "<TD NOWRAP>" & DateAndTimeFormat(rsEvents("EventDate")) & "</TD>" & vbCrLf
	Response.Write "<TD>" & rsEvents("Act2") & "</TD>" & vbCrLf
	Response.Write "<TD>" & rsEvents("Venue") & "</TD>" & vbCrLf
	Response.Write "<TD>" & rsEvents("SeatCount") & "</TD>" & vbCrLf
	Response.Write "</TR>" & vbCrLf
    
	
	
	RecordCounter = RecordCounter + 1
    If RecordCounter Mod 100 = 0 Then 'Flush Buffer every 100 records
        Response.Flush
    End If
	rsEvents.MoveNext
	
Loop

Response.Write "</TABLE>" & vbCrLf

jsValidateForm = jsValidateForm & "   var EventCount = 0;" & vbCrLf &_
"   if(formObj.EventCode.length>1) {" & vbCrLf &_
"   for(i=0;i<formObj.EventCode.length;i++) {" & vbCrLf &_
"       if(formObj.EventCode[i].checked == true)" & vbCrLf &_
"           EventCount += 1" & vbCrLf &_
"   }" & vbCrLf &_
"   if(EventCount == 0) {" & vbCrLf &_
"       alert('Please select one or more events.');" & vbCrLf &_
"       return false;" & vbCrLf &_
"   }}" & vbCrLf

'-------------------------------------------------------
'INCLUDE VIRTUAL="/Include/EventSelectionInclude.asp
'-------------------------------------------------------

%> 
	
</fieldset>
<br />
<%

%>
   	
<%

%>

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


%>