<!--#INCLUDE VIRTUAL="GlobalInclude.asp"-->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<%
Page = "SalesByEventReport"
ReportFileName = "MissedSalesReport.asp"
Server.ScriptTimeout = 60 * 10

If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then Response.Redirect("/Management/Default.asp")

If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then Response.Redirect("/Management/Default.asp")

If Request("FormName") = "DisplayReport" Then
	Call DisplayReport
Else
	Call DisplayForm
End If

Sub DisplayForm
%>
<HTML>
<HEAD>
<TITLE>Tix - Missed Sales Report</TITLE>
<!-- EM 04/20/07 modified function makeCheck and added a checkbox to the form to check and uncheck all the checkboxes-->
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

function makeCheck(thisForm){
	for (i = 0; i < thisForm.EventCode.length; i++){
		if(thisForm.SelectAll.checked==true){
			thisForm.EventCode[i].checked=true
			}
			else
			{
			thisForm.EventCode[i].checked=false
			}
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

<FONT FACE="verdana,arial,helvetica" COLOR="#008400"><H3>Missed Sales Report</H3></FONT>
<FONT FACE="verdana,arial,helvetica" SIZE="2">

<!--#include virtual="/Include/EventListDayInclude.asp" -->

<FORM ACTION="<%=ReportFileName%>" METHOD="post" NAME="Report" style="display: inline;"><INPUT TYPE="hidden" NAME="FormName" VALUE="DisplayReport">

<!--#include virtual="/Include/EventSelectionInclude.asp" -->

<%

Response.Write "<BR>" & vbCrLf

'REE 5/28/5 - Added ability to output to Excel
Response.Write "<INPUT TYPE=""checkbox"" NAME=""ExcelOutput"" VALUE=""Y"">&nbsp;Output To Excel<BR><BR>" & vbCrLf

Response.Write "<INPUT TYPE=submit VALUE=Submit></FORM><BR><BR>" & vbCrLf

Response.Write "</FONT>" & vbCrLf

%>
	<!--#include virtual="FooterInclude.asp"-->
<%

Response.Write "</CENTER>" & vbCrLf
Response.Write "</BODY>" & vbCrLf
Response.Write "</HTML>" & vbCrLf

End Sub 'Display Form

'------------------------------------------------

Sub DisplayReport

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
