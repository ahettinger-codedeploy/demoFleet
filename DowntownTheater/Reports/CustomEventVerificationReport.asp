<!--#include virtual="GlobalInclude.asp"-->
<!--#include virtual="dbOpenInclude.asp"-->
<%

'=================================
'Custom Event Verification Report
'Lists ticket type and ticket price for each selected event

Page = "ManagementReport"
ReportFileName = "CustomEventVerificationReport.asp"
ReportTitle = "Custom Event Verification Report"
ReportOrgName = "Downtown Theater"

'REE 4/12/6 - Added Script Timeout
Server.ScriptTimeout = 1200

If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then Response.Redirect("/Management/Default.asp")

If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then Response.Redirect("/Management/Default.asp")

If Request("btnSubmit") = "Submit" Then
    Call ReportOutput
Else
    Call ReportCriteria
End If 


'=================================

Sub ReportCriteria

%>

<html>

<head>

<title>Tix - Event Verification Detail Report</title>

<link href="/CSS/Report.css" rel="stylesheet" type="text/css" />

</head>

<body BGCOLOR="#FFFFFF">

<center>

<%
If Excel <> "Y" Then
%>
	<!--#include virtual="TopNavInclude.asp" -->
<%
End If
%>

<BR>
<BR>
<FONT FACE=verdana,arial,helvetica COLOR=#008400 size="3"><B><%=ReportOrgName%></B></FONT><br />
<FONT FACE=verdana,arial,helvetica COLOR=#008400 size="3"><B><%=ReportTitle%></B></FONT>

<%
If Excel <> "Y" Then
%>

<FONT FACE=verdana,arial,helvetica SIZE=2>
<FORM ACTION="" METHOD="post" id=form1 name=Report >
	
<%
EventListDaysDefault = 30
%>
<fieldset style="width: 600px;" class="reportCriteriaField">
    <legend class="reportCriteriaFieldTitle">Event Selection</legend>

    <!--#INCLUDE VIRTUAL="/Include/EventListDayInclude.asp" -->

    <!--#INCLUDE VIRTUAL="/Include/EventSelectionInclude.asp" -->
    
</fieldset><br /><br />	
<INPUT TYPE="checkbox" NAME="ExcelOutput" VALUE="Y">&nbsp;&nbsp;<FONT FACE=verdana,arial,helvetica SIZE=2>Output To Excel</FONT><br />
<br />
<INPUT TYPE=submit name=btnSubmit VALUE=Submit></FORM>

<%
End If
%>

<!--#include virtual="FooterInclude.asp"-->

</body>
</html>

<%

End Sub

'==============================================

Sub ReportOutput

Response.Buffer = False

Excel = Clean(Request("ExcelOutput"))

If Excel = "Y" Then
	Response.ContentType = "application/vnd.ms-excel"
End If

%>
<html>
<head>
<title><%=ReportTitle%></title>
<%

If Excel <> "Y" Then
    Response.Write "<LINK REL=""stylesheet"" TYPE=""text/css"" HREF=""/CSS/Report.css"">" & vbCrLf    
End If

%>

<head>

<body>

<%
If Excel <> "Y" Then
%>
<!--#INCLUDE VIRTUAL="TopNavInclude.asp" -->
<%
End If
%>

<FONT FACE=verdana,arial,helvetica COLOR=#008400 size="3"><B><%=ReportOrgName%></B></FONT><br />
<FONT FACE=verdana,arial,helvetica COLOR=#008400 size="3"><B><%=ReportTitle%></B></FONT>

<%
EventCodes = Clean(Replace(Request("EventCode")," ",""))
EventCodeList = Split(EventCodes,",")

For i = LBound(EventCodeList) To UBound(EventCodeList)

	SQLSeat = "SELECT EventCode FROM Event WHERE Event.EventCode = " & CleanNumeric(EventCodeList(i)) & ""
	Set rsSeat = OBJdbConnection.Execute(SQLSeat)
	
	If Not rsSeat.EOF Then
	
	    Do Until rsSeat.EOF			
	
        If Not IsNull(rsSeat("EventCode")) Then
        
		    SQLEvent = "SELECT Act, Venue, EventDate, OrganizationVenue.OrganizationNumber FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) on Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) on Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = Act.ActCode AND OrganizationVenue.OrganizationNumber = OrganizationAct.OrganizationNumber WHERE Event.EventCode = " & rsSeat("EventCode") & " AND OrganizationVenue.Owner <> 0"
		    Set rsEvent = OBJdbConnection.Execute(SQLEvent)
    		
		    %>
		    
		    <br />
		    </center>
    		<table cellpadding="5" border="0" id="tix-table">
    		    <tbody>
                    <tr>
	                    <td>
	                    <b><%= rsEvent("Act") %></b><br />
                        <%= FormatDateTime(rsEvent("EventDate"), vbShortDate) %> at <%= Left(FormatDateTime(rsEvent("EventDate"), vbLongTime), Len(FormatDateTime(rsEvent("EventDate"), vbLongTime))-6) & " " & Right(FormatDateTime(rsEvent("EventDate"),vbLongTime), 2) %><br />
                        </td>
		           </tr>
                </tbody>
   		    </table>
   		    </center>
		    <%
    		
		    EventOrganizationNumber = rsEvent("OrganizationNumber")		
		    rsEvent.Close
		    Set rsEvent = nothing
		
		    Call DBOpen(OBJdbConnection2)		
		
		    %>	
		    
    		<table cellpadding="2" border="0" id="tix-table">
    		<! -- Table Body Begin -- >
            <thead>
		    <tr BGCOLOR=#008400>
		        <th>&nbsp;Section&nbsp;</th>
                <th>&nbsp;Seat Type&nbsp;</th> 
                <th>&nbsp;Price&nbsp;</th> 
                <th>&nbsp;Online Service Fee&nbsp;</th> 
                <th>&nbsp;Phone Order Service Fee&nbsp;</th> 
                <th>&nbsp;Fax Order Service Fee&nbsp;</th> 
                <th>&nbsp;Mail Order Service Fee&nbsp;</th> 
                <th>&nbsp;Box Office Service Fee&nbsp;</th> 
		    </tr>
    		
		    <%
		
	        SQLPrice = "SELECT DISTINCT Section, SeatType, Price.SeatTypeCode, Price, Surcharge, PhoneOrderSurcharge, MailOrderSurcharge, FaxOrderSurcharge, BoxOfficeSurcharge, OnlinePriceFlag, OfflinePriceFlag, StartDate, EndDate FROM Price (NOLOCK) INNER JOIN SeatType (NOLOCK) ON Price.SeatTypeCode = SeatType.SeatTypeCode INNER JOIN Section (NOLOCK) ON Price.SectionCode = Section.SectionCode AND Price.EventCode = Section.EventCode WHERE Price.EventCode = " & rsSeat("EventCode") & " ORDER BY Section, SeatType, Price"
	        Set rsPrice = OBJdbConnection.Execute(SQLPrice)
		
		        If Not rsPrice.EOF Then
				
                    Do Until rsPrice.EOF
		
		            %>
        		
			         <tr BGCOLOR=#DDDDDD>
		                <td><%=rsPrice("Section")%></td>
                        <td><%=rsPrice("SeatType")%></td> 
                        <td><%=FormatCurrency(rsPrice("Price"),2)%></td> 
                        <td><%=FormatCurrency(rsPrice("Surcharge"),2)%></td> 
                        <td><%=FormatCurrency(rsPrice("PhoneOrderSurcharge"),2)%></td> 
                        <td><%=FormatCurrency(rsPrice("FaxOrderSurcharge"),2)%></td> 
                        <td><%=FormatCurrency(rsPrice("MailOrderSurcharge"),2)%></td> 
                        <td><%=FormatCurrency(rsPrice("BoxOfficeSurcharge"),2)%></td> 
	                </tr>
        		        
		            <%
		    
		            rsPrice.MoveNext
		        
		            Loop
		
                End If
		
	        rsPrice.Close
	        Set rsPrice = nothing						
			
		End If

		rsSeat.MoveNext
		
		Loop	
		
		Call DBClose(OBJdbConnection2)
		
        %>
		</tbody>
		</table>
		<%

	End If
	
	rsSeat.Close
	Set rsSeat = nothing
	
Next

%>

</FONT>
</CENTER>

<%
If Excel <> "Y" Then
%>
	<!--#include virtual="FooterInclude.asp"-->
<%
End If
%>

</BODY>
</HTML>

<%
End Sub
%>
