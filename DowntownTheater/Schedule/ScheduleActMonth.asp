<%

'CHANGE LOG - Inception
'SSR 6/23/2011
'Custom Schedule Page

%>

<!--#INCLUDE virtual="PrivateLabelInclude.asp" -->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp" -->
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->

<%

'============================================================

Page = "Schedule"
TooltipIncludeFlag = "Y"

'============================================================

ActSelectionTitle = "Act Selection"
ActSelectionSubTitle = "2011-2012 Seasons" 
ActSelectionOnSale = "N"

'============================================================

'CSS Style Sheet Variables

If Session("UserNumber")<> "" Then
    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "FFFFFF"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "000000"
    TableDataBGColor = "E9E9E9"
    ClientFolder= "Tix"
Else
    ClientFolder = "MySECT"
End If

'============================================================

%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<TITLE><%= Title %></TITLE>

<%= strBody %>

<style type="text/css">
body
{
    font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
    line-height: 1 em;
}
#rounded-corner
{
	font-size: 11px;
    font-weight: 400;
	width: 600px;
	text-align: left;
	border-collapse: collapse;
}
/* upper between corners */
#rounded-corner thead th.category
{
	padding-top: 10px;
    padding-bottom: 10px;
    padding-left: 0px;
    padding-right: 1px;
	font-size: 15px;
	font-weight: 670;
	text-align: left;
	color: <%=TableCategoryFontColor%>;
	background: <%=TableCategoryBGColor%>;
}
/* upper left corner */
#rounded-corner thead th.category-left
{
	background: <%=TableCategoryBGColor%> url('/Clients/<%=ClientFolder%>/Schedule/Images/nw.gif') left -1px no-repeat;
	text-align: right;
}
/* upper right corner */
#rounded-corner thead th.category-right
{
	background: <%=TableCategoryBGColor%> url('/Clients/<%=ClientFolder%>/Schedule/Images/ne.gif') right -1px no-repeat;
    text-align: left;
}
/* lower between corners */
#rounded-corner td.footer
{
	background: <%=TableDataBGColor%>;
}
/* lower left corner */
#rounded-corner td.footer-left
{
	background: <%=TableDataBGColor%> url('/Clients/<%=ClientFolder%>/Schedule/Images/sw.gif') left bottom no-repeat;
}
/* lower right corner */
#rounded-corner td.footer-right
{
	background: <%=TableDataBGColor%> url('/Clients/<%=ClientFolder%>/Schedule/Images/se.gif') right bottom no-repeat;
}
/* main body */
#rounded-corner td.data
{
	padding-top: 4px;
    padding-bottom: 2px;
    padding-left: 2px;
    padding-right: 2px;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
	text-align: center;
}
#rounded-corner td.data-left
{
	padding-top: 2px;
    padding-bottom: 2px;
    padding-left: 2px;
    padding-right: 2px;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
	text-align: left;
}
/* horizontal rule */
#rounded-corner hr 
{
    height:1px;
    width: 100%;
    background:#<%=TableCategoryBGColor%>;
    margin: 0px 0px 0px 0px;  
}
/* unvisited link */
#rounded-corner a:link 
{
text-decoration: none;
color: #<%=TableCategoryBGColor%>;
font-size: 11px;
font-weight: 400;
} 
 /* visited link */
#rounded-corner a:visited
{
text-decoration: none;
color: #<%=TableCategoryBGColor%>;
font-size: 11px;
font-weight: 400;
} 
/* mouse over link */
#rounded-corner a:hover
{
text-decoration: none;
color:#<%=TableCategoryBGColor%>;
font-size: 11px;
font-weight: 400;
} 
/* selected link */
#rounded-corner a:active
{
text-decoration: none;
color: #<%=TableCategoryBGColor%>;
font-size: 11px;
font-weight: 400;
} 
/* submitt button*/
.formbutton
{
cursor: pointer;
border: outset 1px #ccc;
background: #e1e1e1;
color: #666;
font-weight: bold;
padding: 1px 10px;
}
</style>

</head>

<%= strBody %>

<!--#INCLUDE virtual="TopNavInclude.asp" -->

<%

'============================================================
     

'============================================================

'EVENTS BY ACT - Determine if any other events can be listed

SpecialActs = ""

ActEventsOnSale = "N" 

SQLWhere = "WHERE Event.EventDate >= '" & FormatDateTime(Now(), vbShortDate) & "'"

If IsDate(Clean(Request("StartDate"))) Then
	SQLWhere = SQLWhere & " AND Event.EventDate >= '" & CDate(Clean(Request("StartDate"))) & "'"
End If

If IsDate(Clean(Request("EndDate"))) Then
	SQLWhere = SQLWhere & " AND Event.EventDate < '" & CDate(Clean(Request("EndDate"))) + 1 & "'"
End If

If Request("OrganizationNumber") <> "" Then SQLWhere = SQLWhere & " AND OrganizationAct.OrganizationNumber IN (" & Clean(Request("OrganizationNumber")) & ") AND OrganizationVenue.OrganizationNumber IN (" & Clean(Request("OrganizationNumber")) & ")"
If Request("ActCode") <> "" Then SQLWhere = SQLWhere & " AND Event.ActCode = " & Clean(Request("ActCode"))
If Request("VenueCode") <> "" Then SQLWhere = SQLWhere & " AND Venue.VenueCode = " & Clean(Request("VenueCode"))
If Request("EventCode") <> "" Then SQLWhere = SQLWhere & " AND Event.EventCode = " & Clean(Request("EventCode"))

SQLEvents = "SELECT DATENAME(yyyy,EventDate) AS YearName, DATENAME ( mm,EventDate ) AS MonthName, MONTH(Event.EventDate) as MonthNumber, Act.ActCode, Act.Act,  Event.EventCode FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode " & SQLWhere & " AND Event.OnSale = 1 AND Event.SaleStartDate <= '" & Now() &  "' ORDER BY YEAR(Event.EventDate), MONTH(Event.EventDate), Act.Act"
Set rsEvents = OBJdbConnection.Execute(SQLEvents)

Response.Write "<TABLE CELLSPACING=0 CELLPADDING=0 WIDTH=""95%"" BORDER=0>" & vbCrLf   
Response.Write "<TR ><TD ALIGN=CENTER COLSPAN=7></TD></TR>"
Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=7 HEIGHT=2><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf    	
Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=7 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf

IF not rsEvents.EOF Then

    Do While Not rsEvents.EOF   

		If LastMonth <> rsEvents("MonthNumber") Then
		    Response.Write "<TR ><TD ALIGN=CENTER COLSPAN=7><BR></TD></TR>"
	        Response.Write "<TR ><TD ALIGN=CENTER COLSPAN=7><BR><FONT FACE=" & FontFace & " COLOR=#000000 SIZE=3>" & rsEvents("MonthName") &" "& rsEvents("YearName")&  "<FONT FACE=" & FontFace & " COLOR=#000000 SIZE=3><BR></TD></TR>" & vbCrLf
	        Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>Event</B></FONT></TD><TD>&nbsp;&nbsp;</TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=CENTER><FONT FACE=" & FontFace & " COLOR=" & TableCategoryFontColor & " SIZE=2><B>Tickets</B></FONT></TD></TR>" & vbCrLf
	        Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
	        Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=7 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
	            
	        LastMonth = rsEvents("MonthNumber")
	        LastActCode = 0
	        
    End IF
            
        If  LastActCode <> rsEvents("ActCode") Then
		            
					Link = "SchedulebyMonth.asp?ActCode=" & rsEvents("ActCode")&"&MonthName="& rsEvents("MonthName")
					                
					Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
					Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD>&nbsp;&nbsp;</TD><TD ALIGN=left><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=" & Link & ">" & rsEvents("Act") & "</A></FONT></TD><TD>&nbsp;&nbsp;</TD><TD>&nbsp;&nbsp;</TD><TD ALIGN=CENTER><FONT FACE=" & FontFace & " COLOR=" & TableDataFontColor & " SIZE=1><A HREF=" & Link & ">View<BR>Schedule</A></FONT></TD></TR>" & vbCrLf
    			Response.Write "<TR BGCOLOR=" & TableDataBGColor & "><TD COLSPAN=7 HEIGHT=6><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
					Response.Write "<TR BGCOLOR=" & TableCategoryBGColor & "><TD COLSPAN=7 HEIGHT=1><IMG HEIGHT=1 SRC=""/images/clear.gif""></TD></TR>" & vbCrLf
					               
					LastActCode = rsEvents("ActCode")   
				
			  End If
			  
			rsEvents.MoveNext
		
	Loop 

Else

      Response.Write "<FONT FACE=" & FontFace & " COLOR=" & FontColor & " SIZE=2><BR>There are no events on sale at this time.  Please check back again.</FONT>"

End If

Response.Write "</TABLE>"
rsEvents.Close
Set rsEvents = nothing

OBJdbConnection.Close
Set OBJdbConnection = nothing

Response.Write "<BR><BR>" & vbCrLf

%>

</CENTER>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

