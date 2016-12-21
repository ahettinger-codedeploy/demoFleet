<%

'CHANGE LOG
'SSR (9/23/2011)
'Updated report format "dark corner" style

'CHANGE LOG
'SSR (9/23/2011)
'Seperated out the Address Column into Address, City, State and Zip Code


'CHANGE LOG - Inception
'SSR Wednesday, July 06, 2011
'Custom Code 
%>

<!--#include virtual="GlobalInclude.asp"-->
<!--#include virtual="dbOpenInclude.asp"-->

<%

'========================================

Page = "ManagementReport"
ReportFileName = "CustomSurveyReport.asp"
ReportTitle = "Custom Survey Report"

'========================================

'Check to see if Order Number exists.
'Display management tabs for box office orders

If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then 
    Response.Redirect("/Management/Default.asp")
End If

If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then 
    Response.Redirect("/Management/Default.asp")
End If

'========================================

'Request the form name and process requested action

Select Case Clean(Request("FormName"))
    Case "Transitions2012Report"
        Call Transitions2012Report
    Case "Transitions2011Report"
        Call Transitions2011Report
    Case "ParentsWeekend2011Report"
        Call ParentsWeekend2011Report
    Case Else
        Call SurveyForm
 End Select

'========================================

Sub SurveyForm

%>
<HTML>
<HEAD>
<TITLE>Tix - Custom Survey Report</TITLE>

<style type="text/css">
<!--
a.sort:link  {color: #FFFFFF; font-weight: bold; text-decoration: underline;}
a.sort:visited  {color: #FFFFFF; font-weight: bold; text-decoration: underline;}
a.sort:active  {color: #FFFFFF; font-weight: bold; text-decoration: underline;}
a.sort:hover  {color: #FFFFFF; font-weight: bold; text-decoration: underline;}
-->
</style>
    <link href="/CSS/Report.css" rel="stylesheet" type="text/css" />
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

<FONT FACE=verdana,arial,helvetica COLOR=#008400><H3>Custom Survey Report</H3></FONT>

<FONT FACE=verdana,arial,helvetica SIZE=2>

<form action="<%= SurveyFileName %>" name="Report" method="post">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">
	

<fieldset style="width: 600px;" class="reportCriteriaField">
    <legend class="reportCriteriaFieldTitle">Event Selection</legend>
<br />
<TABLE BORDER="1" CELLPADDING="3" WIDTH="600">
<TR BGCOLOR="#008400" ALIGN="center">
    <TD><FONT FACE="verdana,arial,helvetica" COLOR="#FFFFFF" SIZE="2">&nbsp;</TD>
    <TD><FONT FACE="verdana,arial,helvetica" COLOR="#FFFFFF" SIZE="2"><B>Date/Time</B></FONT></TD>
    <TD><FONT FACE="verdana,arial,helvetica" COLOR="#FFFFFF" SIZE="2"><B>Production</B></FONT></TD>
</TR>
<TR BGCOLOR="#DEDFDE" ALIGN="center">
    <TD>
        <FONT FACE="verdana,arial,helvetica" COLOR="#000000" SIZE="2">
        <INPUT TYPE="radio" NAME="FormName" VALUE="Transitions2012Report">
        </FONT>
    </TD>
    <TD>
        <FONT FACE="verdana,arial,helvetica" COLOR="#000000" SIZE=2>
        Friday 1/27/2012 7:30 AM 
        </FONT>
    </TD>
    <TD>
        <FONT FACE="verdana,arial,helvetica" COLOR="#000000" SIZE="2">
        Transitions 2012 Conference: High School to Higher Education, Options for Students with Learning Differences 
        </FONT>
    </TD>
</TR>
<TR BGCOLOR="#DEDFDE" ALIGN="center">
    <TD>
        <FONT FACE="verdana,arial,helvetica" COLOR="#000000" SIZE="2">
        <INPUT TYPE="radio" NAME="FormName" VALUE="ParentsWeekend2011Report">
        </FONT>
    </TD>
    <TD>
        <FONT FACE="verdana,arial,helvetica" COLOR="#000000" SIZE=2>
        Friday 10/21/2011 8:00 AM
        </FONT>
    </TD>
    <TD>
        <FONT FACE="verdana,arial,helvetica" COLOR="#000000" SIZE="2">
        Parents and Families Weekend 2011 Registration
        </FONT>
    </TD>
</TR>
<TR BGCOLOR="#DEDFDE" ALIGN="center">
    <TD>
        <FONT FACE="verdana,arial,helvetica" COLOR="#000000" SIZE="2">
        <INPUT TYPE="radio" NAME="FormName" VALUE="Transitions2011Report">
        </FONT>
    </TD>
    <TD>
        <FONT FACE="verdana,arial,helvetica" COLOR="#000000" SIZE=2>
        Friday 1/28/2011 7:30 AM
        </FONT>
    </TD>
    <TD>
        <FONT FACE="verdana,arial,helvetica" COLOR="#000000" SIZE="2">
        Transitions 2011 Conference: High School to Higher Education, Options for Students with Learning Differences
        </FONT>
    </TD>
</TR>
</TABLE>

</fieldset>
<br />
<br />	
<INPUT TYPE="checkbox" NAME="ExcelOutput" VALUE="Y">&nbsp;&nbsp;<FONT FACE=verdana,arial,helvetica SIZE=2>Output To Excel</FONT>
<br />
<br />
<INPUT TYPE=submit name=btnSubmit VALUE=Submit></FORM>



<!--#include virtual="FooterInclude.asp"-->


</body>

</html>

<%

End Sub

'=================================================================================
'=================================================================================

Sub Transitions2012Report

ReportEventCode = 397647

DIM ReportColumnTitle (16)
ReportColumnTitle(1)="Order Number"
ReportColumnTitle(2)="Order Date"
ReportColumnTitle(3)="Price"
ReportColumnTitle(4)="Order Status"
ReportColumnTitle(5)="Order Type"
ReportColumnTitle(6)="Bill To"
ReportColumnTitle(7)="Attendee Name"
ReportColumnTitle(8)="Street Address"
ReportColumnTitle(9)="City"
ReportColumnTitle(10)="State"
ReportColumnTitle(11)="Z1ip Code"
ReportColumnTitle(12)="Email"
ReportColumnTitle(13)="Telephone Number"
ReportColumnTitle(14)="School Name"
ReportColumnTitle(15)="Category"

If DocType <> "" Then
	Response.Write DocType
Else
	Response.Write "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
End If
%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<html>

<head>

<title>TIX.com</title>

<style type="text/css">
    
body
{
    font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
    line-height: 1 em;
}
#dark-corner
{
	font-size: 11px;
    font-weight: 400;
	text-align: left;
	border-collapse: collapse;
	width: 70%;
	top: 10px;
	line-height: 22px;
	margin-top:  10px;
}
#dark-corner thead th.category
{
	padding-top: 10px;
    padding-bottom: 10px;
    padding-left: 0px;
    padding-right: 1px;
	font-size: 15px;
	font-weight: 600;
	text-align: center;
	color: <%=TableCategoryFontColor%>;
	background: <%=TableCategoryBGColor%>;
}
#dark-corner thead th.category-left
{
	background: <%=TableCategoryBGColor%> url('/clients/tix/images/image.gif') left -1px no-repeat;
	text-align: right;
}
#dark-corner thead th.category-right
{
	background: <%=TableCategoryBGColor%> url('<%=NWCorner%>') right -1px no-repeat;
    text-align: left;
}
#dark-corner td.footer
{
	background: <%=TableDataBGColor%>;
}
#dark-corner td.footer-left
{
    background: <%=TableDataBGColor%> url('<%=SWCorner%>') left bottom no-repeat;
}
#dark-corner td.footer-right
{
	background: <%=TableDataBGColor%> url('<%=SECorner%>') right bottom no-repeat;
}
#dark-corner td.data
{
	padding-left: 10px;
	padding-right: 10px;
	padding-top: 10px;
	padding-bottom: 10px;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#dark-corner td.data-left
{
	padding-left: 10px;
	padding-right: 10px;
	padding-top: 10px;
	padding-bottom: 10px;
	text-align: left;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#dark-corner td.data-right
{
	padding-left: 10px;
	padding-right: 10px;
	padding-top: 10px;
	padding-bottom: 10px;
    text-align: right;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
</style>

<%

If Excel <> "Y" Then
    Response.Write "<LINK REL=""stylesheet"" TYPE=""text/css"" HREF=""/CSS/Report.css"">" & vbCrLf    
End If

%>

</head>

<body>

<%

If Excel <> "Y" Then
%>
<!--#INCLUDE VIRTUAL="TopNavInclude.asp" -->
<%
 End If

SQLSeat = "SELECT DISTINCT Seat.EventCode, Seat.ItemNumber, Section, Seat.Row, Seat.Seat,  OrderLine.OrderNumber, OrderLine.LineNumber, Seat.ItemNumber, Section, Row, Seat, SeatStatus.Status, OrderType, OrderLine.SeatTypeCode, SeatType, Price, OrderLine.Discount, OrderDate, OrderHeader.CustomerNumber, Customer.FirstName AS FirstName, Customer.LastName AS LastName,OrganizationCustomerClass.Class,"
SQLSeat = SQLSeat & "(SELECT SeatStatus.Status) as OrderStatus," 
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'Answer1') as AttendeeFirstName,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'Answer2') as AttendeeLastName,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'Answer3') as Address,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'Answer4') as City,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'Answer5') as State,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'Answer6') as ZipCode,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'Answer7') as EmailAddress,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'Answer8') as PhoneNumber,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'Answer9') as School,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'Answer10') as Catagory "
SQLSeat = SQLSeat & "FROM Seat (NOLOCK) INNER JOIN Section (NOLOCK) ON Seat.SectionCode = Section.SectionCode AND Seat.EventCode = Section.EventCode INNER JOIN SeatStatus (NOLOCK) ON Seat.StatusCode = SeatStatus.StatusCode LEFT JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode AND OrganizationVenue.OrganizationNumber = OrganizationAct.OrganizationNumber LEFT JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber LEFT JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode LEFT JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber LEFT JOIN CustomerClass (NOLOCK) ON OrderHeader.CustomerNumber = CustomerClass.CustomerNumber LEFT JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber LEFT JOIN OrganizationCustomerClass (NOLOCK) ON CustomerClass.ClassNumber = OrganizationCustomerClass.ClassNumber AND OrganizationVenue.OrganizationNumber = OrganizationCustomerClass.OrganizationNumber LEFT JOIN OrderLineDetail (NOLOCK) ON OrderHeader.OrderNumber  = OrderLineDetail.OrderNumber WHERE Seat.EventCode = " & ReportEventCode & " AND OrganizationVenue.OrganizationNumber = 1641 AND OrganizationAct.OrganizationNumber = 1641 AND SeatStatus.Status IN ('Sold','Reserved') ORDER BY OrderDate"
Set rsSeat = OBJdbConnection.Execute(SQLSeat)

If Not rsSeat.EOF Then

%>

<table id="rounded-corner" summary="surveypage">
<thead>
    <tr>
	    <th scope="col" class="category-left"></th>
	    <th scope="col" class="category"><%=ReportColumnHeading%></th>
	    <th scope="col" class="category-right"></th>
    </tr>        
</thead>
<tbody>

<%
			



Call DBOpen(OBJdbConnection2)

'set your counter to 0
i = 0
		
Do Until rsSeat.EOF

 i = i + 1
 
'set background color to nothing 
vBGColor = "#ffffff"

If i mod 2 = 1 then vBGColor = "#f2fff2"

    Response.Write "<TR bgcolor="&vBGColor&">" & vbCrLf
    'Order Number
    Response.Write "<TD align=""left""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsSeat("OrderNumber") & "</FONT></TD>" & vbCrLf
    
    'Order Date
    Response.Write "<TD align=""left""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & FormatDateTime(rsSeat("OrderDate"),vbShortDate) & "</FONT></TD>" & vbCrLf
    
    'Price
    Response.Write "<TD align=""left""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & FormatCurrency(rsSeat("Price"),2) & "</FONT></TD>" & vbCrLf
    
    'Order Status
    Response.Write "<TD align=""left""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsSeat("OrderStatus") & "</FONT></TD>" & vbCrLf
    
    'Order Type
    Response.Write "<TD align=""left""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsSeat("OrderType") & "</FONT></TD>" & vbCrLf
    
    'Bill To Name
    Response.Write "<TD align=""left"" NOWRAP><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsSeat("FirstName") & " " & rsSeat("LastName") & "</FONT></TD>" & vbCrLf
    
   '----------------------------------------------------
   'Attendee Name
    If rsSeat("AttendeeFirstName") <> "" Or rsSeat("AttendeeFirstName") <> "NULL" Then
        AttendeeFirstName = rsSeat("AttendeeFirstName")& "&nbsp;"
    Else
        AttendeeFirstName = "&nbsp;"
    End If
    
    If rsSeat("AttendeeLastName") <> "" Or rsSeat("AttendeeLastName") <> "NULL" Then
        AttendeeLastName = rsSeat("AttendeeLastName")
    Else
        AttendeeLastName = "&nbsp;"
    End If
    
    Response.Write "<TD align=""left"" NOWRAP><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & AttendeeFirstName & "" & AttendeeLastName & "</FONT></TD>" & vbCrLf 

    '---------------------------------------------------- 
    'Address
    
    If rsSeat("Address") <> "" Or rsSeat("Address") <> "NULL" Then
        Address= rsSeat("Address")& "&nbsp;"
    Else
       Address = "&nbsp;"
    End If
    
    Response.Write "<TD align=""left"" NOWRAP><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & Address & "</FONT></TD>" & vbCrLf
    
    '----------------------------------------------------   
    
    'Ciy
    
    If rsSeat("City") <> "" Or rsSeat("City") <> "NULL" Then
        City = rsSeat("City")& "&nbsp;"
    Else
       City = "&nbsp;"
    End If
    
    Response.Write "<TD align=""left"" NOWRAP><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & City & "</FONT></TD>" & vbCrLf
    
    '----------------------------------------------------  
    
     'State
    
    If rsSeat("State") <> "" Or rsSeat("State") <> "NULL" Then
        State = rsSeat("State")& "&nbsp;"
    Else
       State = "&nbsp;"
    End If
    
    Response.Write "<TD align=""left""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & State & "</FONT></TD>" & vbCrLf
    
      '----------------------------------------------------  
    
    'ZipCode
    
    If rsSeat("ZipCode") <> "" Or rsSeat("ZipCode") <> "NULL" Then
        ZipCode = rsSeat("ZipCode")& "&nbsp;"
    Else
       ZipCode = "&nbsp;"
    End If
    
    Response.Write "<TD align=""left""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & ZipCode & "</FONT></TD>" & vbCrLf
    
    '----------------------------------------------------  
    
    'Email
    
    If rsSeat("EmailAddress") <> "" Or rsSeat("EmailAddress") <> "NULL" Then
        EmailAddress= rsSeat("EmailAddress")& "&nbsp;"
    Else
        EmailAddress = "&nbsp;"
    End If
    
    Response.Write "<TD align=""left""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & EmailAddress & "</FONT></TD>" & vbCrLf
    
    '----------------------------------------------------   

    'TelephoneNumber
    
    If rsSeat("PhoneNumber") <> "" Or rsSeat("PhoneNumber") <> "NULL" Then
        PhoneNumber= rsSeat("PhoneNumber")& "&nbsp;"
    Else
        PhoneNumber = "&nbsp;"
    End If
    
    Response.Write "<TD align=""left""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & PhoneNumber & "</FONT></TD>" & vbCrLf
    
    '----------------------------------------------------  
    'School Name
    
    If rsSeat("School") <> "" Or rsSeat("School") <> "NULL" Then
        School = rsSeat("School")& "&nbsp;"
    Else
        School = "&nbsp;"
    End If
    
    Response.Write "<TD align=""left"" NOWRAP><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & School & "</FONT></TD>" & vbCrLf         
    
    
    '----------------------------------------------------       
    'Catagory
    
    If rsSeat("Catagory") <> "" Or rsSeat("Catagory") <> "NULL" Then
        Catagory = rsSeat("Catagory")& "&nbsp;"
    Else
        Catagory = "&nbsp;"
    End If
    
    Response.Write "<TD align=""left"" NOWRAP><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsSeat("Catagory") & "</FONT></TD>" & vbCrLf
    
    '----------------------------------------------------  
  
    Response.Write "</TR>" & vbCrLf

rsSeat.MoveNext

Loop
    Response.Write "</TR>" & vbCrLf
    Response.Write "</TABLE>" & vbCrLf
Else
    Response.Write "No Seats Found.<BR>" & vbCrLf
End If

rsSeat.Close
Set rsSeat = nothing

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


'===================================================================================================

Sub ParentsWeekend2011Report

RequiredOrg = 1641
RequiredEvent = 385001
SurveyAnswers = 7

DIM SurveyAnswer(8)

'Day01Header ="Friday, October 21, 2011"
SurveyAnswer(1) = "Life at Lynn as a College Student (For Parents Only)"
SurveyAnswer(2) = "Innovative Classroom Technology"
SurveyAnswer(3) = "Financial Aid"

'Day02Header ="Saturday, October 22, 2011"
SurveyAnswer(4) = "Coffee with the President"
SurveyAnswer(5) = "Reception with College Deans and Faculty"
SurveyAnswer(6) = "Lynn Family Barbecue"
SurveyAnswer(7) = "Movie on the Lawn"


DIM SurveyTotal(8)
SurveyTotal(1) = 0
SurveyTotal(2) = 0
SurveyTotal(3) = 0
SurveyTotal(4) = 0
SurveyTotal(5) = 0
SurveyTotal(6) = 0
SurveyTotal(7) = 0


Response.Buffer = False
Excel = Clean(Request("ExcelOutput"))

If Excel = "Y" Then

	Response.ContentType = "application/vnd.ms-excel"

End If

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & ReportTitle & "</TITLE>" & vbCrLf

If Excel <> "Y" Then

    Response.Write "<LINK REL=""stylesheet"" TYPE=""text/css"" HREF=""/CSS/Report.css"">" & vbCrLf
    
End If

Response.Write "</HEAD>" & vbCrLf
Response.Write "<BODY>" & vbCrLf

If Excel <> "Y" Then
%>
<!--#INCLUDE VIRTUAL="TopNavInclude.asp" -->
<%
 End If

SQLSeat = "SELECT DISTINCT Seat.EventCode, Seat.ItemNumber, Section, Seat.Row, Seat.Seat,  OrderLine.OrderNumber, OrderLine.LineNumber, Seat.ItemNumber, Section, Row, Seat, SeatStatus.Status, OrderType, OrderLine.SeatTypeCode, SeatType, Price, OrderLine.Discount, OrderDate, OrderHeader.CustomerNumber, Customer.FirstName AS FirstName, Customer.LastName AS LastName,OrganizationCustomerClass.Class,"
SQLSeat = SQLSeat & "(SELECT SeatStatus.Status) as OrderStatus," 
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'FirstName') as AttendeeFirstName,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'LastName') as AttendeeLastName,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'Session1') as Session1,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'Session2') as Session2,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'Session3') as Session3,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'Session4') as Session4,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'Session5') as Session5,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'Session6') as Session6,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'Session7') as Session7,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'Address1') as Address1,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'City') as City,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'State') as State,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'Zipcode') as ZipCode,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'EmailAddress') as EmailAddress,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'School') as School,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'Catagory') as Catagory "
SQLSeat = SQLSeat & "FROM Seat (NOLOCK) INNER JOIN Section (NOLOCK) ON Seat.SectionCode = Section.SectionCode AND Seat.EventCode = Section.EventCode INNER JOIN SeatStatus (NOLOCK) ON Seat.StatusCode = SeatStatus.StatusCode LEFT JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode AND OrganizationVenue.OrganizationNumber = OrganizationAct.OrganizationNumber LEFT JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber LEFT JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode LEFT JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber LEFT JOIN CustomerClass (NOLOCK) ON OrderHeader.CustomerNumber = CustomerClass.CustomerNumber LEFT JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber LEFT JOIN OrganizationCustomerClass (NOLOCK) ON CustomerClass.ClassNumber = OrganizationCustomerClass.ClassNumber AND OrganizationVenue.OrganizationNumber = OrganizationCustomerClass.OrganizationNumber LEFT JOIN OrderLineDetail (NOLOCK) ON OrderHeader.OrderNumber  = OrderLineDetail.OrderNumber WHERE Seat.EventCode = " & RequiredEvent & " AND OrganizationVenue.OrganizationNumber = " & RequiredOrg & " AND OrganizationAct.OrganizationNumber = 1641 AND SeatStatus.Status IN ('Sold','Reserved') ORDER BY OrderDate"
Set rsSeat = OBJdbConnection.Execute(SQLSeat)

If Not rsSeat.EOF Then

Response.Write "<TABLE BORDER=""0"" CELLPADDING=""5"" CELLSPACING=""0"" WIDTH=""100%"">" & vbCrLf
Response.Write "<TR BGCOLOR=""#ffffff"">" & vbCrLf
'Report Title
Response.Write "<TD align=""Left"" COLSPAN=""16""><H3>Parents and Families Weekend 2011 Registration</H3></TD>" & vbCrLf
Response.Write "</TR>" & vbCrLf
Response.Write "<TR BGCOLOR=""#008400"">" & vbCrLf
'Order Information
Response.Write "<TD align=""left"" COLSPAN=""6""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B></B></FONT></TD>" & vbCrLf
'Attendee Information
Response.Write "<TD align=""left"" COLSPAN=""3""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B></B></FONT></TD>" & vbCrLf
'Session One
Response.Write "<TD align=""left"" COLSPAN=""3""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B></B></FONT></TD>" & vbCrLf
'Session Two
Response.Write "<TD align=""left"" COLSPAN=""4""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B></B></FONT></TD>" & vbCrLf
Response.Write "</TR>" & vbCrLf
'New Row
Response.Write "<TR BGCOLOR=""#848284"" ALIGN=""left"">" & vbCrLf
Response.Write "<TD align=""left""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B>Order Number</B></FONT></TD>" & vbCrLf
Response.Write "<TD align=""left""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B>Order Date</B></FONT></TD>" & vbCrLf
Response.Write "<TD align=""left""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B>Price</B></FONT></TD>" & vbCrLf
Response.Write "<TD align=""left""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B>Order Status</B></FONT></TD>" & vbCrLf
Response.Write "<TD align=""left""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B>Order Type</B></FONT></TD>" & vbCrLf
Response.Write "<TD align=""left""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B>Bill To</B></FONT></TD>" & vbCrLf
Response.Write "<TD align=""left""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B>Attendee Name</B></FONT></TD>" & vbCrLf	

For OptionCount = 1  to SurveyAnswers 	
    Response.Write "<td align=""left"" style=""white-space: nowrap;""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B>" & SurveyAnswer(OptionCount) & "&nbsp;|&nbsp;</B></FONT></TD>" & vbCrLf	
Next 

Response.Write "</TR>" & vbCrLf


Call DBOpen(OBJdbConnection2)

'set your counter to 0
i = 0
		
Do Until rsSeat.EOF

 i = i + 1
 
'set background color to nothing 
vBGColor = "#ffffff"

If i mod 2 = 1 then vBGColor = "#f2fff2"

    Response.Write "<TR bgcolor="&vBGColor&">" & vbCrLf
    
    'Order Number
    Response.Write "<TD align=""left""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsSeat("OrderNumber") & "</FONT></TD>" & vbCrLf
    
    'Order Date
    Response.Write "<TD align=""left""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & FormatDateTime(rsSeat("OrderDate"),vbShortDate) & "</FONT></TD>" & vbCrLf
    
    'Price
    Response.Write "<TD align=""left""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">$" & rsSeat("Price") & "</FONT></TD>" & vbCrLf
    
    'Order Status
    Response.Write "<TD align=""left""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsSeat("OrderStatus") & "</FONT></TD>" & vbCrLf
    
    'Order Type
    Response.Write "<TD align=""left""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsSeat("OrderType") & "</FONT></TD>" & vbCrLf
    
    'Bill To Name
    Response.Write "<TD align=""left"" NOWRAP><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsSeat("FirstName") & " " & rsSeat("LastName") & "</FONT></TD>" & vbCrLf
    
   
   'Attendee Name
    If rsSeat("AttendeeFirstName") <> "" Or rsSeat("AttendeeFirstName") <> "NULL" Then
        AttendeeFirstName = rsSeat("AttendeeFirstName")& "&nbsp;"
    Else
        AttendeeFirstName = "&nbsp;"
    End If
    
    If rsSeat("AttendeeLastName") <> "" Or rsSeat("AttendeeLastName") <> "NULL" Then
        AttendeeLastName = rsSeat("AttendeeLastName")
    Else
        AttendeeLastName = "&nbsp;"
    End If
    
    Response.Write "<TD align=""left"" NOWRAP><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & AttendeeFirstName & "" & AttendeeLastName & "</FONT></TD>" & vbCrLf 
    
    
    For OptionCount = 1  to SurveyAnswers 
       
    'Tabulate Survey Responses
    If rsSeat("Session"&OptionCount) = SurveyAnswer(OptionCount) Then
        Response.Write "<TD ALIGN=""center"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>X</FONT></TD>" & vbCrL
        SurveyTotal(OptionCount) = SurveyTotal(OptionCount) + 1
    Else
        Response.Write "<TD ALIGN=""center"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>&nbsp;</FONT></TD>" & vbCrL
    End If
    
    Next 
    
    Response.Write "</TR>" & vbCrLf

rsSeat.MoveNext

Loop
    'Headcount totals
    Response.Write "<TD ALIGN=""right"" COLSPAN=""7""><FONT FACE=""verdana,arial,helvetica"" SIZE=2>TOTALS</FONT></TD>" & vbCrLf
    
    For OptionCount = 1  to SurveyAnswers 
        Response.Write "<TD ALIGN=""center"" ><FONT FACE=""verdana,arial,helvetica"" SIZE=2>" & SurveyTotal(OptionCount) & "</FONT></TD>" & vbCrLf
    Next
    
    Response.Write "</TR>" & vbCrLf
    Response.Write "</TABLE>" & vbCrLf
Else
    Response.Write "No Seats Found.<BR>" & vbCrLf
End If

rsSeat.Close
Set rsSeat = nothing

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

'================================================================================

'================================================================================

Sub Transitions2011Report

DIM SurveyFields(20)

'Session One - 7 Events  11:00 AM (1 to 7)
SurveyFields(1) = "It’s So Much Work to Be Your Friend: Helping the Child With Learning Disabilities Find Social Success"
SurveyFields(2) =  "Intentionality, Planning and Mentoring: Essentials for Student Success"
SurveyFields(3) =  "Academic Study Strategies for College-Bound Students with Learning Disorders: The Pressured Millennials"
SurveyFields(4) = "Transitioning from High School to College"
SurveyFields(5) =  "Many Colleges, Many Services"
SurveyFields(6) =  "Helping Our Children Before They Go to College"
SurveyFields(7) = "TBA"

'Session Two - 8 Events 1:45 AM (8 to 14)
SurveyFields(8) = "The Motivation Breakthrough: 6 Secrets to Turning on the Tuned-Out Child Event (Part 1)"
SurveyFields(9) = "Re-Engaging Parents in the College Experience"
SurveyFields(10)  = "Millennials: Through the Gates and into the Workplace"
SurveyFields(11)  = "Interviewing at Colleges and Scared Stiff: Prep Me Now!"
SurveyFields(12)  = "Make It Simple: How to Know Which Support Program Works Best From the Student's Perspective"
SurveyFields(13) = "Supporting-College Bound Students with Asperger Syndrome Event (Part 1)"
SurveyFields(14) = "Preparing for SAT® Testing Accommodations and Transitioning to College"

'Session Three - 6 Events 3:00 PM (15 to 20)
SurveyFields(15) = "The Motivation Breakthrough: 6 Secrets to Turning on the Tuned-Out Child Event (Part 2)"
SurveyFields(16)  = "Understanding the Brain and Learning"
SurveyFields(17)  = "Hiring an Educational Consultant: Everything You Need and Want to Know and What to Ask"
SurveyFields(18) = "Supporting-College Bound Students with Asperger Syndrome Event (Part 2)"
SurveyFields(19)  = "TBA"
SurveyFields(20) =  "Testing and Documenting the Need for Accommodations in College."


Response.Buffer = False
Excel = Clean(Request("ExcelOutput"))

If Excel = "Y" Then

	Response.ContentType = "application/vnd.ms-excel"

End If

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & ReportTitle & "</TITLE>" & vbCrLf

If Excel <> "Y" Then

    Response.Write "<LINK REL=""stylesheet"" TYPE=""text/css"" HREF=""/CSS/Report.css"">" & vbCrLf
    
End If

Response.Write "</HEAD>" & vbCrLf
Response.Write "<BODY>" & vbCrLf

If Excel <> "Y" Then
%>
<!--#INCLUDE VIRTUAL="TopNavInclude.asp" -->
<%
 End If

SQLSeat = "SELECT DISTINCT Seat.EventCode, Seat.ItemNumber, Section, Seat.Row, Seat.Seat,  OrderLine.OrderNumber, OrderLine.LineNumber, Seat.ItemNumber, Section, Row, Seat, SeatStatus.Status, OrderType, OrderLine.SeatTypeCode, SeatType, Price, OrderLine.Discount, OrderDate, OrderHeader.CustomerNumber, Customer.FirstName AS FirstName, Customer.LastName AS LastName,OrganizationCustomerClass.Class,"
SQLSeat = SQLSeat & "(SELECT SeatStatus.Status) as OrderStatus," 
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'FirstName') as AttendeeFirstName,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'LastName') as AttendeeLastName,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'SessionThree') as SessionThree,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'SessionTwo') as SessionTwo,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'SessionOne') as SessionOne,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'Address1') as Address1,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'City') as City,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'State') as State,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'Zipcode') as ZipCode,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'EmailAddress') as EmailAddress,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'School') as School,"
SQLSeat = SQLSeat & "(SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.OrderNumber = OrderLine.OrderNumber AND OrderLine.LineNumber = OrderLineDetail.LineNumber AND OrderLineDetail.FieldName = 'Catagory') as Catagory "
SQLSeat = SQLSeat & "FROM Seat (NOLOCK) INNER JOIN Section (NOLOCK) ON Seat.SectionCode = Section.SectionCode AND Seat.EventCode = Section.EventCode INNER JOIN SeatStatus (NOLOCK) ON Seat.StatusCode = SeatStatus.StatusCode LEFT JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode AND OrganizationVenue.OrganizationNumber = OrganizationAct.OrganizationNumber LEFT JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber LEFT JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode LEFT JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber LEFT JOIN CustomerClass (NOLOCK) ON OrderHeader.CustomerNumber = CustomerClass.CustomerNumber LEFT JOIN Customer (NOLOCK) ON OrderHeader.CustomerNumber = Customer.CustomerNumber LEFT JOIN OrganizationCustomerClass (NOLOCK) ON CustomerClass.ClassNumber = OrganizationCustomerClass.ClassNumber AND OrganizationVenue.OrganizationNumber = OrganizationCustomerClass.OrganizationNumber LEFT JOIN OrderLineDetail (NOLOCK) ON OrderHeader.OrderNumber  = OrderLineDetail.OrderNumber WHERE Seat.EventCode = 295799 AND OrganizationVenue.OrganizationNumber = 1641 AND OrganizationAct.OrganizationNumber = 1641 AND SeatStatus.Status IN ('Sold','Reserved') ORDER BY OrderDate"
Set rsSeat = OBJdbConnection.Execute(SQLSeat)

If Not rsSeat.EOF Then

Response.Write "<TABLE BORDER=""0"" CELLPADDING=""5"" CELLSPACING=""0"" WIDTH=""100%"">" & vbCrLf
Response.Write "<TR BGCOLOR=""#ffffff"">" & vbCrLf
'Report Title
Response.Write "<TD align=""Left"" COLSPAN=""37""><H3> Transitions 2011 Conference: High School to Higher Education, Options for Students with Learning Differences</TD>" & vbCrLf
Response.Write "</TR>" & vbCrLf
Response.Write "<TR BGCOLOR=""#008400"">" & vbCrLf
'Order Information
Response.Write "<TD align=""left"" COLSPAN=""6""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B>Order Information</B></FONT></TD>" & vbCrLf
'Attendee Information
Response.Write "<TD align=""left"" COLSPAN=""5""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B>Attendee Information</B></FONT></TD>" & vbCrLf
'Session One
Response.Write "<TD align=""left"" COLSPAN=""7""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B>Session One</B></FONT></TD>" & vbCrLf
'Session Two
Response.Write "<TD align=""left"" COLSPAN=""7""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B>Session Two</B></FONT></TD>" & vbCrLf
'Session Three
Response.Write "<TD align=""left"" COLSPAN=""6""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B>Session Three</B></FONT></TD>" & vbCrLf
Response.Write "</TR>" & vbCrLf
'New Row
Response.Write "<TR BGCOLOR=""#848284"" ALIGN=""left"">" & vbCrLf
Response.Write "<TD align=""left""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B>Order Number</B></FONT></TD>" & vbCrLf
Response.Write "<TD align=""left""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B>Order Date</B></FONT></TD>" & vbCrLf
Response.Write "<TD align=""left""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B>Price</B></FONT></TD>" & vbCrLf
Response.Write "<TD align=""left""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B>Order Status</B></FONT></TD>" & vbCrLf
Response.Write "<TD align=""left""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B>Order Type</B></FONT></TD>" & vbCrLf
Response.Write "<TD align=""left""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B>Bill To</B></FONT></TD>" & vbCrLf
Response.Write "<TD align=""left""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B>Attendee Name</B></FONT></TD>" & vbCrLf	
Response.Write "<TD align=""left""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B>Category</B></FONT></TD>" & vbCrLf
Response.Write "<TD align=""left""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B>Address</B></FONT></TD>" & vbCrLf	
Response.Write "<TD align=""left""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B>Email</B></FONT></TD>" & vbCrLf
Response.Write "<TD align=""left""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B>School</B></FONT></TD>" & vbCrLf			
Response.Write "<td align=""left"" style=""white-space: nowrap;""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B>&nbsp;|&nbsp;" & SurveyFields(1) & "&nbsp;|&nbsp;</B></FONT></TD>" & vbCrLf	
Response.Write "<td align=""left"" style=""white-space: nowrap;""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B>&nbsp;|&nbsp;" & SurveyFields(2) & "&nbsp;|&nbsp;</B></FONT></TD>" & vbCrLf
Response.Write "<td align=""left"" style=""white-space: nowrap;""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B>&nbsp;|&nbsp;" & SurveyFields(3) & "&nbsp;|&nbsp;</B></FONT></TD>" & vbCrLf
Response.Write "<td align=""left"" style=""white-space: nowrap;""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B>&nbsp;|&nbsp;" & SurveyFields(4) & "&nbsp;|&nbsp;</B></FONT></TD>" & vbCrLf
Response.Write "<td align=""left"" style=""white-space: nowrap;""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B>&nbsp;|&nbsp;" & SurveyFields(5) & "&nbsp;|&nbsp;</B></FONT></TD>" & vbCrLf
Response.Write "<td align=""left"" style=""white-space: nowrap;""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B>&nbsp;|&nbsp;" & SurveyFields(6) & "&nbsp;|&nbsp;</B></FONT></TD>" & vbCrLf
Response.Write "<td align=""left"" style=""white-space: nowrap;""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B>&nbsp;|&nbsp;" & SurveyFields(7) & "&nbsp;|&nbsp;</B></FONT></TD>" & vbCrLf
Response.Write "<td align=""left"" style=""white-space: nowrap;""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B>&nbsp;|&nbsp;" & SurveyFields(8) & "&nbsp;|&nbsp;</B></FONT></TD>" & vbCrLf	
Response.Write "<td align=""left"" style=""white-space: nowrap;""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B>&nbsp;|&nbsp;" & SurveyFields(9) & "&nbsp;|&nbsp;</B></FONT></TD>" & vbCrLf
Response.Write "<td align=""left"" style=""white-space: nowrap;""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B>&nbsp;|&nbsp;" & SurveyFields(10) & "&nbsp;|&nbsp;</B></FONT></TD>" & vbCrLf
Response.Write "<td align=""left"" style=""white-space: nowrap;""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B>&nbsp;|&nbsp;" & SurveyFields(11) & "&nbsp;|&nbsp;</B></FONT></TD>" & vbCrLf
Response.Write "<td align=""left"" style=""white-space: nowrap;""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B>&nbsp;|&nbsp;" & SurveyFields(12) & "&nbsp;|&nbsp;</B></FONT></TD>" & vbCrLf
Response.Write "<td align=""left"" style=""white-space: nowrap;""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B>&nbsp;|&nbsp;" & SurveyFields(13) & "&nbsp;|&nbsp;</B></FONT></TD>" & vbCrLf
Response.Write "<td align=""left"" style=""white-space: nowrap;""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B>&nbsp;|&nbsp;" & SurveyFields(14) & "&nbsp;|&nbsp;</B></FONT></TD>" & vbCrLf	
Response.Write "<td align=""left"" style=""white-space: nowrap;""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B>&nbsp;|&nbsp;" & SurveyFields(15) & "&nbsp;|&nbsp;</B></FONT></TD>" & vbCrLf
Response.Write "<td align=""left"" style=""white-space: nowrap;""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B>&nbsp;|&nbsp;" & SurveyFields(16) & "&nbsp;|&nbsp;</B></FONT></TD>" & vbCrLf
Response.Write "<td align=""left"" style=""white-space: nowrap;""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B>&nbsp;|&nbsp;" & SurveyFields(17) & "&nbsp;|&nbsp;</B></FONT></TD>" & vbCrLf
Response.Write "<td align=""left"" style=""white-space: nowrap;""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B>&nbsp;|&nbsp;" & SurveyFields(18) & "&nbsp;|&nbsp;</B></FONT></TD>" & vbCrLf
Response.Write "<td align=""left"" style=""white-space: nowrap;""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B>&nbsp;|&nbsp;" & SurveyFields(19) & "&nbsp;|&nbsp;</B></FONT></TD>" & vbCrLf
Response.Write "<td align=""left"" style=""white-space: nowrap;""><FONT FACE=""verdana,arial,helvetica"" COLOR=""#FFFFFF"" SIZE=2><B>&nbsp;|&nbsp;" & SurveyFields(20) & "&nbsp;|&nbsp;</B></FONT></TD>" & vbCrLf
Response.Write "</TR>" & vbCrLf


Call DBOpen(OBJdbConnection2)

'set your counter to 0
i = 0
		
Do Until rsSeat.EOF

 i = i + 1
 
'set background color to nothing 
vBGColor = "#ffffff"

If i mod 2 = 1 then vBGColor = "#f2fff2"

    Response.Write "<TR bgcolor="&vBGColor&">" & vbCrLf
    'Order Number
    Response.Write "<TD align=""left""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsSeat("OrderNumber") & "</FONT></TD>" & vbCrLf
    
    'Order Date
    Response.Write "<TD align=""left""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & FormatDateTime(rsSeat("OrderDate"),vbShortDate) & "</FONT></TD>" & vbCrLf
    
    'Price
    Response.Write "<TD align=""left""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">$" & rsSeat("Price") & "</FONT></TD>" & vbCrLf
    
    'Order Status
    Response.Write "<TD align=""left""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsSeat("OrderStatus") & "</FONT></TD>" & vbCrLf
    
    'Order Type
    Response.Write "<TD align=""left""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsSeat("OrderType") & "</FONT></TD>" & vbCrLf
    
    'Bill To Name
    Response.Write "<TD align=""left"" NOWRAP><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsSeat("FirstName") & " " & rsSeat("LastName") & "</FONT></TD>" & vbCrLf
    
   
   'Attendee Name
    If rsSeat("AttendeeFirstName") <> "" Or rsSeat("AttendeeFirstName") <> "NULL" Then
        AttendeeFirstName = rsSeat("AttendeeFirstName")& "&nbsp;"
    Else
        AttendeeFirstName = "&nbsp;"
    End If
    
    If rsSeat("AttendeeLastName") <> "" Or rsSeat("AttendeeLastName") <> "NULL" Then
        AttendeeLastName = rsSeat("AttendeeLastName")
    Else
        AttendeeLastName = "&nbsp;"
    End If
    
    Response.Write "<TD align=""left"" NOWRAP><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & AttendeeFirstName & "" & AttendeeLastName & "</FONT></TD>" & vbCrLf 
    
    'Catagory
    
    If rsSeat("Catagory") <> "" Or rsSeat("Catagory") <> "NULL" Then
        Catagory = rsSeat("Catagory")& "&nbsp;"
    Else
        Catagory = "&nbsp;"
    End If
    
    Response.Write "<TD align=""left"" NOWRAP><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & rsSeat("Catagory") & "</FONT></TD>" & vbCrLf
    
    'Address
    If rsSeat("Address1") <> "" Or rsSeat("Address1") <> "NULL" Then
        Address1 = rsSeat("Address1")& ","
    Else
        Address1 = "&nbsp;"
    End If
    
    If rsSeat("City") <> "" Or rsSeat("City") <> "NULL" Then
        City = rsSeat("City")& ","
    Else
        City = "&nbsp;"
    End If
    
    If rsSeat("State") <> "" Or rsSeat("State") <> "NULL" Then
        State = rsSeat("State")& ","
    Else
        State = "&nbsp;"
    End If
    
    If rsSeat("ZipCode") <> "" Or rsSeat("ZipCode") <> "NULL" Then
        ZipCode = rsSeat("ZipCode")
    Else
        ZipCode = "&nbsp;"
    End If
    
    Response.Write "<TD align=""left"" NOWRAP><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & Address1 & " " & City & " " & State & " " & ZipCode & "</FONT></TD>" & vbCrLf
    
    If rsSeat("EmailAddress") <> "" Or rsSeat("EmailAddress") <> "NULL" Then
        EmailAddress= rsSeat("EmailAddress")& "&nbsp;"
    Else
        EmailAddress = "&nbsp;"
    End If
    
    Response.Write "<TD align=""left""><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & EmailAddress & "</FONT></TD>" & vbCrLf
    
    
    If rsSeat("School") <> "" Or rsSeat("School") <> "NULL" Then
        School = rsSeat("School")& "&nbsp;"
    Else
        School = "&nbsp;"
    End If
    
    Response.Write "<TD align=""left"" NOWRAP><FONT FACE=""verdana,arial,helvetica"" SIZE=""2"">" & School & "</FONT></TD>" & vbCrLf    
     
    'Event 01
    If (rsSeat("SessionOne") = "It’s So Much Work to Be Your Friend: Helping the Child With Learning Disabilities Find Social Success") Then
        Response.Write "<TD ALIGN=""left"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>X</FONT></TD>" & vbCrL
    Else
        Response.Write "<TD ALIGN=""left"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>&nbsp;</FONT></TD>" & vbCrL
    End If
  
  
    'Event 02
    If (rsSeat("SessionOne") = "Intentionality, Planning and Mentoring: Essentials for Student Success") Then
        Response.Write "<TD ALIGN=""left"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>X</FONT></TD>" & vbCrL
    Else
        Response.Write "<TD ALIGN=""left"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>&nbsp;</FONT></TD>" & vbCrL
    End If
    
    
    'Event 03
    If (rsSeat("SessionOne") = "Academic Study Strategies for College-Bound Students with Learning Disorders: The Pressured Millennials") Then
        Response.Write "<TD ALIGN=""left"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>X</FONT></TD>" & vbCrL
    Else
        Response.Write "<TD ALIGN=""left"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>&nbsp;</FONT></TD>" & vbCrL
    End If
    
    'Event 04
    If (rsSeat("SessionOne") = "Transitioning from High School to College") Then
        Response.Write "<TD ALIGN=""left"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>X</FONT></TD>" & vbCrL
    Else
        Response.Write "<TD ALIGN=""left"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>&nbsp;</FONT></TD>" & vbCrL
    End If
    
    'Event 05
    If (rsSeat("SessionOne") = "Many Colleges, Many Services") Then
        Response.Write "<TD ALIGN=""left"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>X</FONT></TD>" & vbCrL
    Else
        Response.Write "<TD ALIGN=""left"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>&nbsp;</FONT></TD>" & vbCrL
    End If
    
    'Event 06
    If (rsSeat("SessionOne") =  "Helping Our Children Before They Go to College") Then
        Response.Write "<TD ALIGN=""left"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>X</FONT></TD>" & vbCrL
    Else
        Response.Write "<TD ALIGN=""left"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>&nbsp;</FONT></TD>" & vbCrL
    End If
    
    'Event 07
    If (rsSeat("SessionOne") = "TBA") Then
        Response.Write "<TD ALIGN=""left"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>X</FONT></TD>" & vbCrL
    Else
        Response.Write "<TD ALIGN=""left"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>&nbsp;</FONT></TD>" & vbCrL
    End If
    
    'Event 08
    If (rsSeat("SessionTwo") = "The Motivation Breakthrough: 6 Secrets to Turning on the Tuned-Out Child Event (Part 1)") Then
        Response.Write "<TD ALIGN=""left"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>X</FONT></TD>" & vbCrL
    Else
        Response.Write "<TD ALIGN=""left"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>&nbsp;</FONT></TD>" & vbCrL
    End If
        
    'Event 09
    If (rsSeat("SessionTwo") = "Re-Engaging Parents in the College Experience") Then
        Response.Write "<TD ALIGN=""left"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>X</FONT></TD>" & vbCrL
    Else
        Response.Write "<TD ALIGN=""left"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>&nbsp;</FONT></TD>" & vbCrL
    End If
        
    'Event 10
    If (rsSeat("SessionTwo") = "Millennials: Through the Gates and into the Workplace") Then
        Response.Write "<TD ALIGN=""left"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>X</FONT></TD>" & vbCrL
    Else
        Response.Write "<TD ALIGN=""left"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>&nbsp;</FONT></TD>" & vbCrL
    End If
        
    'Event 11
    If (rsSeat("SessionTwo") = "Interviewing at Colleges and Scared Stiff: Prep Me Now!") Then
        Response.Write "<TD ALIGN=""left"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>X</FONT></TD>" & vbCrL
    Else
        Response.Write "<TD ALIGN=""left"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>&nbsp;</FONT></TD>" & vbCrL
    End If
        
    'Event 12
    If (rsSeat("SessionTwo") = "Make It Simple: How to Know Which Support Program Works Best From the Student's Perspective") Then
        Response.Write "<TD ALIGN=""left"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>X</FONT></TD>" & vbCrL
    Else
        Response.Write "<TD ALIGN=""left"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>&nbsp;</FONT></TD>" & vbCrL
    End If
        
    'Event 13
    If (rsSeat("SessionTwo") = "Supporting-College Bound Students with Asperger Syndrome Event (Part 1)") Then
        Response.Write "<TD ALIGN=""left"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>X</FONT></TD>" & vbCrL
    Else
        Response.Write "<TD ALIGN=""left"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>&nbsp;</FONT></TD>" & vbCrL
    End If
    
    'Event 14
    If (rsSeat("SessionThree") = "Preparing for SAT Testing Accommodations and Transitioning to College)") Then
        Response.Write "<TD ALIGN=""left"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>X</FONT></TD>" & vbCrL
    Else
        Response.Write "<TD ALIGN=""left"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>&nbsp;</FONT></TD>" & vbCrL
    End If
    
    'Event 15
    If (rsSeat("SessionThree") = "The Motivation Breakthrough: 6 Secrets to Turning on the Tuned-Out Child Event (Part 2)") Then
        Response.Write "<TD ALIGN=""left"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>X</FONT></TD>" & vbCrL
    Else
        Response.Write "<TD ALIGN=""left"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>&nbsp;</FONT></TD>" & vbCrL
    End If
    
    'Event 16
    If (rsSeat("SessionThree") = "Understanding the Brain and Learning") Then
        Response.Write "<TD ALIGN=""left"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>X</FONT></TD>" & vbCrL
    Else
        Response.Write "<TD ALIGN=""left"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>&nbsp;</FONT></TD>" & vbCrL
    End If
    
    'Event 17    
    If (rsSeat("SessionThree") = "Hiring an Educational Consultant: Everything You Need and Want to Know and What to Ask") Then
        Response.Write "<TD ALIGN=""left"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>X</FONT></TD>" & vbCrL
    Else
        Response.Write "<TD ALIGN=""left"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>&nbsp;</FONT></TD>" & vbCrL
    End If
    
    'Event 18
    If (rsSeat("SessionThree") = "Supporting-College Bound Students with Asperger Syndrome Event (Part 2)") Then
        Response.Write "<TD ALIGN=""left"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>X</FONT></TD>" & vbCrL
    Else
        Response.Write "<TD ALIGN=""left"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>&nbsp;</FONT></TD>" & vbCrL
    End If
    
    'Event 19
    If (rsSeat("SessionThree") = "TBA") Then
        Response.Write "<TD ALIGN=""left"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>X</FONT></TD>" & vbCrL
    Else
        Response.Write "<TD ALIGN=""left"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>&nbsp;</FONT></TD>" & vbCrL
    End If
    
    'Event 20
    If (rsSeat("SessionThree") = "Testing and Documenting the Need for Accommodations in College.") Then
        Response.Write "<TD ALIGN=""left"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>X</FONT></TD>" & vbCrL
    Else
        Response.Write "<TD ALIGN=""left"" NOWRAP><FONT FACE='verdana,arial,helvetica' SIZE=2>&nbsp;</FONT></TD>" & vbCrL
    End If
        
  
    Response.Write "</TR>" & vbCrLf

rsSeat.MoveNext

Loop
    'Headcount totals
    Response.Write "<TD ALIGN=""right"" COLSPAN=""30""><FONT FACE=""verdana,arial,helvetica"" SIZE=2>&nbsp;</FONT></TD>" & vbCrLf
    Response.Write "</TR>" & vbCrLf
    Response.Write "</TABLE>" & vbCrLf
Else
    Response.Write "No Seats Found.<BR>" & vbCrLf
End If

rsSeat.Close
Set rsSeat = nothing

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
