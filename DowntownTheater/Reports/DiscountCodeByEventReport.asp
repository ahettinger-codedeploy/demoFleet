<!--#include virtual="GlobalInclude.asp"-->
<!--#include virtual="dbOpenInclude.asp"-->
<%

Page = "ManagementReport"
ReportFileName = "DiscountCodeByEventReport.asp"
ReportTitle = "Discount Code By Event Report"

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

<title>Tix - Discount Code By Event Report</title>

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

<FONT FACE=verdana,arial,helvetica COLOR=#008400><H3>Discount Code By Event Report</H3></FONT>

<%
If Excel <> "Y" Then
%>

	<FONT FACE=verdana,arial,helvetica SIZE=2>
	<FORM ACTION="DiscountCodeByEventReport.asp" METHOD="post" id=form1 name=Report >
	
<%
EventListDaysDefault = 30
%>
<fieldset style="width: 600px;" class="reportCriteriaField">
    <legend class="reportCriteriaFieldTitle">Event Selection</legend>

    <!--#INCLUDE VIRTUAL="/Include/EventListDayInclude.asp" -->

    <!--#INCLUDE VIRTUAL="/Include/EventSelectionInclude.asp" -->
</fieldset><br /><br />	
<%

	Response.Write "<INPUT TYPE=submit name=btnSubmit VALUE=Submit></FORM>" & vbCrLf

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

<FONT FACE=verdana,arial,helvetica COLOR=#008400><H3>Discount Code By Event</H3></FONT>

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
		    <!-- Act Name, Event Date & Time -->
    		<table cellpadding="3" width="100%" border="0" id="tix-table">
    		    <tbody>
                    <tr>
	                    <td>
	                    <b><%= rsEvent("Act") %></b><br />
                        <%= FormatDateTime(rsEvent("EventDate"), vbShortDate) %> at <%= Left(FormatDateTime(rsEvent("EventDate"), vbLongTime), Len(FormatDateTime(rsEvent("EventDate"), vbLongTime))-6) & " " & Right(FormatDateTime(rsEvent("EventDate"),vbLongTime), 2) %><br />
                        </td>
		           </tr>
                </tbody>
   		    </table>
		    <%
    		
		    EventOrganizationNumber = rsEvent("OrganizationNumber")		
		    rsEvent.Close
		    Set rsEvent = nothing
		
		    Call DBOpen(OBJdbConnection2)		
		
		    %>	 
		    <!-- Report Column Heading -->
    		<table cellpadding="3" width="100%"border="0" id="tix-table">
    		<! -- Table Body Begin -- >
            <thead>
		    <tr BGCOLOR=#008400>
		        <th>&nbsp;Discount Number&nbsp;</th>
                <th>&nbsp;Discount Code&nbsp;</th> 
                <th>&nbsp;Discount Description&nbsp;</th> 
                <th>&nbsp;Discount Type&nbsp;</th>  
		    </tr>
    		
		    <%
		    'Data Query
		    SQLQuery = "SELECT Event.EventCode, DiscountEvents.DiscountTypeNumber, UPPER(DiscountType.DiscountCode) as DiscountCode, DiscountType.DiscountDescription, DiscountEvents.Hidden FROM Event (NOLOCK) INNER JOIN DiscountEvents (NOLOCK) ON DiscountEvents.EventCode = Event.EventCode INNER JOIN DiscountType (NOLOCK) ON DiscountEvents.DiscountTypeNumber = DiscountType.DiscountTypeNumber WHERE Event.EventCode = " & rsSeat("EventCode") & "" 
            Set rsQuery = OBJdbConnection.Execute(SQLQuery)
            		
		        If Not rsQuery.EOF Then
				
                    Do Until rsQuery.EOF
                    
                    If IsNumeric(rsQuery("Hidden")) = 0 Then
                        DiscountType = "Automatic"
                    Else
                        DiscountType = "Code Required"
                    End If
		
		            %>
		            <!-- Report Data -->
			         <tr BGCOLOR=#DDDDDD>
			            <td><%=rsQuery("DiscountTypeNumber")%></td> 
                        <td><%=rsQuery("DiscountCode")%></td> 
                        <td><%=rsQuery("DiscountDescription")%></td> 
                        <td><%=DiscountType%></td> 
	                </tr>        		        
		            <%
		    
		            rsQuery.MoveNext
		        
		            Loop
		
                Else
                
                	%>
		            <!-- No Data -->
			         <tr BGCOLOR=#F8F8F8>
			            <td colspan="4">There are no discounts attached to this event</td> 
	                </tr>        		        
		            <%        
                
                
                End If
		
	        rsQuery.Close
	        Set rsQuery = nothing						
			
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
