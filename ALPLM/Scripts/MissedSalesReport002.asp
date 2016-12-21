<!--#include virtual="GlobalInclude.asp"-->
<!--#include virtual="dbOpenInclude.asp"-->
<%
Page = "SalesByEventReport"
ReportFileName = "MissedSalesReport.asp"
ReportTitle = "Missed Sales Report"
EventListDaysDefault = 30

If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then Response.Redirect("/Management/Default.asp")

If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then Response.Redirect("/Management/Default.asp")

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

    <script src="/Javascript/ValidateDateInput.js" type="text/javascript" ></script>
    <script src="/Javascript/PopupCalendar.js" language="javascript" type="text/javascript"></script>
    <link href="/CSS/PopupCalendar.css" rel="stylesheet" type="text/css" />
    <link href="/CSS/Report.css" rel="stylesheet" type="text/css" />

</head>
<body>
<center>

<!--#include virtual="TopNavInclude.asp" -->

<div class="pageTitle"><%= ReportTitle %></div>

<form name="ReportCriteria" action="<%= ReportFileName %>" method="post">

<fieldset style="width: 600px;" class="reportCriteriaField">
    <legend class="reportCriteriaFieldTitle">Event Selection</legend>

    <!--#INCLUDE VIRTUAL="/Include/EventListDayIncludeNew.asp" -->

    <!--#INCLUDE VIRTUAL="/Include/EventSelectionIncludeNew.asp" -->
</fieldset>

<br />

<input type="checkbox" name="ExcelOutput" value="Y"<% If Request("ExcelOutput") = "Y" Then %> checked="checked"<% End If %>>&nbsp;&nbsp;Output To Excel<br /><br />

<input type="submit" value="Submit" name="btnSubmit" onclick="return validateForm();" />

</form>

<script language="javascript" type="text/javascript">
function validateForm() {
    formObj = document.ReportCriteria;
    <%= jsValidateForm %>
}
</script>

<!--#include virtual="FooterInclude.asp"-->

</center>
</body>
</html>
<%

End Sub 'ReportCriteria

'=======================

Sub ReportOutput

'REE 5/28/5 - Added ability to output to Excel
Excel = Clean(Request("ExcelOutput"))
If Excel = "Y" Then
	Response.ContentType = "application/vnd.ms-excel"
End If

%>
<HTML>
<HEAD>
<TITLE>Tix - Missed Sales Report</TITLE>
</HEAD>
<BODY BGCOLOR="#FFFFFF">
<%
If Excel <> "Y" Then
%>
	<CENTER>
	<!--#include virtual="TopNavInclude.asp" -->
<%
End If
%>

<BR>

<BR>

<FONT FACE=verdana,arial,helvetica COLOR=#008400><H3>Missed Sales Report</H3></FONT>
<FONT FACE=verdana,arial,helvetica SIZE=2>

<%

Response.Write "<TABLE CELLPADDING=5>" & vbCrLf

If Request("EventCode") <> "" Then
	EventList = "("
	For Each EventCode In Request("EventCode")
		EventList = EventList & CleanNumeric(EventCode) & ","
	Next 'Event
	EventList = Left(EventList, Len(EventList)-1) & ")"
Else
    Response.Redirect(ReportFileName)
End If

SQLLostSale = "SELECT LostSale.EventCode, Act, EventDate, Type, COUNT(*) AS UniqueHit FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN OrganizationAct (NOLOCK) ON Act.ActCode = OrganizationAct.ActCode INNER JOIN LostSale (NOLOCK) ON Event.EventCode = LostSale.EventCode WHERE OrganizationNumber = " & Session("OrganizationNumber") & " AND Event.EventCode IN" & EventList & " GROUP BY LostSale.EventCode, Type, IPAddress, EventDate, Act ORDER BY Event.EventDate, Act, Type"
Set rsLostSale = OBJdbConnection.Execute(SQLLostSale)

Response.Write "<TR BGCOLOR=#008400 style=""color:#fff""><TD align=""center""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2""><B>Event Code</B></FONT></TD><TD align=""center""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2""><B>Production</B></FONT></TD><TD align=""center""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2""><B>Event Date/Time</B></FONT></TD><TD align=""center""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2""><B>Event Status</B></FONT></TD><TD align=""center""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2""><B>Unique<br>Visitors</B></FONT></TD><TD align=""center""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2""><B>Total<br>Visits</B></FONT></TD></TR>" & vbCrLf

If Not rsLostSale.EOF Then
    LastEventCode = "-1"
    LostType = "undefined"
    UniqueCount = 0
    TotalCount = 0
    
    Do While Not rsLostSale.EOF  
              
        If LastEventCode <> rsLostSale("EventCode") Or LostType <> rsLostSale("Type") Then
            UniqueCount = 1
            TotalCount = 0
            
            Response.Write "<TR BGCOLOR=#DDDDDD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsLostSale("EventCode") & "</FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsLostSale("Act") & "</FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & DateAndTimeFormat(rsLostSale("EventDate")) & "</FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsLostSale("Type") & "</FONT></TD>" & vbCrLf
            
            LastEventCode = rsLostSale("EventCode")
            LostType = rsLostSale("Type")    
        Else
            UniqueCount = UniqueCount + 1            
        End If     
        
        TotalCount = TotalCount + rsLostSale("UniqueHit")
        rsLostSale.Movenext
        
        If Not rsLostSale.EOF Then
            If LastEventCode <> rsLostSale("EventCode") Or LostType <> rsLostSale("Type") Then
                Response.Write "<TD ALIGN=right NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & UniqueCount & "</FONT></TD><TD ALIGN=right NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & TotalCount & "</FONT></TD></TR>" & vbCrLf
            End If
        Else
            Response.Write "<TD ALIGN=right NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & UniqueCount & "</FONT></TD><TD ALIGN=right NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & TotalCount & "</FONT></TD></TR>" & vbCrLf
        End If
        
    Loop
         
Else
    Response.Write "<TR><TD colspan=""6"" align=""center""><FONT SIZE=""2""><B>There are no missed sales found for the selected events.</B></FONT></TD></TR>" & vbCrLf
End If
rsLostSale.Close
Set rsLostSale = Nothing

UniqueGrandTotal = 0
TotalGrandTotal = 0
'Calculate SubTotal and GrandTotal
SQLSubTotal = "SELECT Type, COUNT(*) AS UniqueHit FROM LostSale (NOLOCK) WHERE EventCode IN(SELECT Event.EventCode FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN OrganizationAct (NOLOCK) ON Act.ActCode = OrganizationAct.ActCode WHERE OrganizationNumber = " & Session("OrganizationNumber") & " AND Event.EventCode IN" & EventList & ") GROUP BY Type, IPAddress ORDER BY Type"
Set rsSubTotal = OBJdbConnection.Execute(SQLSubTotal)
If Not rsSubTotal.EOF Then
    LastLostType = "undefined"
    UniqueSubTotal = 0
    UniqueTotal = 0
    Do While Not rsSubTotal.EOF
        If LastLostType <> rsSubTotal("Type") Then
            UniqueSubTotal = 1
            UniqueTotal = 0
            
            Response.Write "<TR BGCOLOR=#AAAAAA><TD colspan=""3""><FONT FACE=verdana,arial,helvetica SIZE=2>SubTotal</FONT></TD><TD NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSubTotal("Type") & "</FONT></TD>" & vbCrLf    
        
            LastLostType = rsSubTotal("Type")
        Else
            UniqueSubTotal = UniqueSubTotal + 1    
        End If
        
        UniqueTotal = UniqueTotal + rsSubTotal("UniqueHit")
        UniqueGrandTotal = UniqueGrandTotal + 1
        TotalGrandTotal = TotalGrandTotal + rsSubTotal("UniqueHit")
        rsSubTotal.Movenext
        
        If Not rsSubTotal.EOF Then
            If LastLostType <> rsSubTotal("Type") Then
                Response.Write "<TD ALIGN=right NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & UniqueSubTotal & "</FONT></TD><TD ALIGN=right NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & UniqueTotal & "</FONT></TD></TR>" & vbCrLf
            End If
        Else
            Response.Write "<TD ALIGN=right NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & UniqueSubTotal & "</FONT></TD><TD ALIGN=right NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & UniqueTotal & "</FONT></TD></TR>" & vbCrLf
        End If
    Loop
    
End If
rsSubTotal.Close
Set rsSubTotal = Nothing

'Show GrandTotal
If UniqueGrandTotal <> 0 Or TotalGrandTotal <> 0 Then
    Response.Write "<TR BGCOLOR=#008400 style=""color:#fff""><TD colspan=""4""><FONT FACE=verdana,arial,helvetica SIZE=2><B>GrandTotal</B></FONT></TD><TD ALIGN=right NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2><B>" & UniqueGrandTotal & "</B></FONT></TD><TD ALIGN=right NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2><B>" & TotalGrandTotal & "</B></FONT></TD></TR>" & vbCrLf
End If
		
Response.Write "</TABLE><BR>" & vbCrLf

If Excel <> "Y" Then
%>
	<!--#include virtual="FooterInclude.asp"-->
<%
	Response.Write "</CENTER>" & vbCrLf
End If

Response.Write "</BODY>" & vbCrLf
Response.Write "</HTML>" & vbCrLf

OBJdbConnection.Close
Set OBJdbConnection = nothing

End Sub 'Display Report
%>
