<%

'CHANGE LOG

%>

<!--#include virtual="GlobalInclude.asp"-->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="/include/managementinclude.asp"-->

<%

Page = "ManagementReport"
SecurityFunction = ""
ReportFileName = "CustomSubscriptionReport.asp"
ExcelOutputFileName = ""
ReportTitle = "Customer List By Subscription"

If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then Response.Redirect("/Management/Default.asp")

If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then Response.Redirect("/Management/Default.asp")

If SecurityCheck(SecurityFunction) = False Then Response.Redirect("/Management/Default.asp")


'============================================================

'Request the form name and process requested action

If Clean(Request("FormName")) = "ReportCriteria" Then
	Call DisplayReport(CleanNumeric(Request("ReportEventCode")))

ElseIf Clean(Request("FormName")) = "Continue" Then
    Call Continue

Else
    Call SurveyForm
End If


'==========================================================
		
Sub SurveyForm

%>

<!DOCTYPE html>

<html>

<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

<TITLE><%=Title%></TITLE>

<!--#INCLUDE VIRTUAL="TopNavInclude.asp"-->
<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<!-- Microsoft clear type rendering -->
<meta http-equiv="cleartype" content="on">

<!-- Webfonts -->
<link href='http://fonts.googleapis.com/css?family=Open+Sans:300' rel='stylesheet' type='text/css'>
<link href='https://fonts.googleapis.com/css?family=Droid+Sans:400,700' rel='stylesheet' type='text/css'>

<style>

.settings { background: url('./admin_img/settings.png') no-repeat scroll 0% 0% transparent; }
.g_12, .g_10, .g_9, .g_8, .g_6, .g_4, .g_3, .g_2 { float: left; border: 10px solid transparent; -moz-box-sizing: border-box; position: relative; }
.g_12 { width: 100%; }


.header 
{ 
background: -moz-linear-gradient(center top , rgb(233, 234, 236) 0%, rgb(212, 212, 214) 100%) repeat scroll 0% 0% transparent; 
background-color: rgb(233, 234, 236); 
height: 38px; 
line-height: 38px; 
border-width: 1px 1px 0px; border-style: solid; 
border-color: rgb(201, 201, 201); 
-moz-border-top-colors: none; 
-moz-border-right-colors: none; 
-moz-border-bottom-colors: none; 
-moz-border-left-colors: none; 
-moz-border-image: none; 
border-radius: 5px 5px 0px 0px; 
box-shadow: 0px 1px 0px rgb(255, 255, 255) inset; 
padding: 0px 15px; 
}

.wwOptions 
{ padding-right: 0px; }

.header_title
{ 
margin: 0px; 
padding-top: 0px;
color: #3D3949; 
font-size: 20px; 
text-shadow: 0pt 1px 0px rgb(255, 255, 255); 
font-weight: strong; 
}

.header_title 
{ float: left; }

.contents.noPadding 
{ padding: 0px; overflow: hidden; }

.w_Options:hover, 
{ background-color: rgba(255, 255, 255, 0.6); cursor: pointer; }

.contents
{ background-color: rgb(253, 253, 253); border: 1px solid rgb(201, 201, 201); border-radius: 0px 0px 3px 3px; box-shadow: 0px 1px 0px rgb(255, 255, 255) inset; padding: 15px; }

.tables 
{ width: 100%; border-collapse: collapse; border-spacing: 0px; }

.tables th, 
.tables td 
{ border: 1px solid rgb(224, 224, 224); padding: 4px 15px; }

.tables thead tr 
{ box-shadow: 0px 1px 3px rgb(230, 230, 230); }

.tables thead th 
{ border-top: 0px none; }

.tables th 
{font-size: 13px; color: #3D3949; text-shadow: 0px 1px 0px rgb(255, 255, 255); font-weight: strong; line-height: 25px; background: -moz-linear-gradient(center top , rgb(254, 254, 254) 0%, rgb(242, 242, 242) 100%) repeat scroll 0% 0% transparent; box-shadow: 0px 1px 0px rgb(255, 255, 255) inset; border-bottom-color: rgb(218, 218, 218); }

.tables th.sorting 
{ cursor: pointer; background: url('./admin_img/sorting.png') no-repeat scroll right center, -moz-linear-gradient(center top , rgb(254, 254, 254) 0%, rgb(242, 242, 242) 100%) repeat scroll 0% 0% transparent; }

.tables th.sorting_asc 
{ cursor: pointer; background: url('./admin_img/sorting_asc.png') no-repeat scroll right center, -moz-linear-gradient(center top , rgb(254, 254, 254) 0%, rgb(242, 242, 242) 100%) repeat scroll 0% 0% transparent; }

.tables th.sorting_desc 
{ cursor: pointer; background: url('./admin_img/sorting_desc.png') no-repeat scroll right center, -moz-linear-gradient(center top , rgb(254, 254, 254) 0%, rgb(242, 242, 242) 100%) repeat scroll 0% 0% transparent; }


.tables td 
{ padding: 5px 10px; white-space: nowrap ! important; border-top: 1px solid rgb(254, 254, 254); border-bottom: 1px solid rgb(224, 224, 224); }

.tables th:first-child, 
.tables td:first-child 
{ border-left-width: 0px; }

.tables th:last-child, 
.tables td:last-child 
{ border-right-width: 0px; }

.tables tbody tr:last-child td 
{ border-bottom-width: 0px; }

.tables tbody tr:nth-child(2n) 
{ background-color: rgb(237, 237, 238); }

.tables tbody tr:hover td
{background: #d0dafd; color: #339;}

</style>

<style>

.dtShowPer, 
.dtFilter, 
.dtInfo, 
.dtPagination 
{color: rgb(143, 143, 143); font-size: 13px; text-shadow: 0px 1px 0px rgb(255, 255, 255); }

.dtTop 
{ padding: 0px 15px; height: 60px; line-height: 60px; border-bottom: 1px solid rgb(201, 201, 201); background: -moz-linear-gradient(center top , rgb(253, 253, 253) 0%, rgb(248, 248, 248) 100%) repeat scroll 0% 0% transparent; box-shadow: 0px 1px 0px rgb(255, 255, 255) inset; }

.dtBottom, 
.ui-dialog-buttonpane 
{ padding: 0px 15px; height: 50px; line-height: 50px; border-top: 1px solid rgb(201, 201, 201); background: -moz-linear-gradient(center top , rgb(253, 253, 253) 0%, rgb(244, 244, 244) 100%) repeat scroll 0% 0% transparent; box-shadow: 0px 1px 0px rgb(255, 255, 255) inset, 0px -2px 3px rgb(230, 230, 230); }

.dtTables 
{ clear: both; overflow: auto; }

.dtShowPer 
{ float: right; }

.dtFilter 
{ float: left; }

.dtInfo 
{ float: left; }

.dtBottom 
.dtPagination 
{ float: right; }

.dtPagination a 
{ padding: 0px 10px; margin: 12px 4px 0px; cursor: pointer; }

.dtPagination a:hover 
{ background: -moz-linear-gradient(center top , rgb(255, 255, 255) 0%, rgb(251, 251, 251) 100%) repeat scroll 0% 0% transparent; }

.dtPagination a.paginate_active 
{ background: none repeat scroll 0px 0px rgb(239, 239, 239); }

.simple_buttons, 
.selector, 
.dtPagination a, 
.ui-button 
{ display: inline-block; background: -moz-linear-gradient(center top , rgb(255, 0, 0) 0%, rgb(242, 242, 242) 100%) repeat scroll 0% 0% transparent; border: 1px solid rgb(203, 203, 203); border-radius: 3px 3px 3px 3px; height: 26px; line-height: 26px; color: rgb(143, 143, 143); font-size: 12px; text-shadow: 0px 1px 0px rgb(255, 255, 255); box-shadow: 0px 2px 3px rgb(234, 234, 234); cursor: pointer; }

</style>

<script src="http://ajax.aspnetcdn.com/ajax/jquery.dataTables/1.8.2/jquery.dataTables.min.js" type="text/javascript" charset="utf8" ></script>

</head>

<body>

<section style="margin-top: 40px;">

<form action="<%= SurveyFileName %>" method="post" name="Survey">
<input type="hidden" name="FormName" value="ReportCriteria">
							
<%

SQLSurveyList = "SELECT Event.EventDate, Event.EventCode, Act.Act FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode WHERE Event.EventCode IN (584896,589274,678679)"
Set rsSurveyList = OBJdbConnection.Execute(SQLSurveyList)

If Not rsSurveyList.EOF Then

			%>
											
			<div class="g_12">
				<div class="header">
					<h4 class="header_title">Subscription Report</h4>
					<div>

					</div>
				</div>
				<div class="contents noPadding">
				<table id="report" class="datatable tables">
					<thead>
						<tr>
							<th>&nbsp;</th>
							<th>Date/Time</th>
							<th>Production</th>
						</tr>
					</thead>
					<tbody>
				<%

				Do Until rsSurveyList.EOF

				%>
				<tr>
					<td><INPUT TYPE="radio" NAME="ReportEventCode" VALUE=<%=rsSurveyList("EventCode")%> /></td>
					<td><%=DateAndTimeFormat(rsSurveyList("EventDate"))%></td>
					<td ><%=rsSurveyList("Act")%></td>
				</tr>

				<% 
				rsSurveyList.MoveNext
				Loop
				%>
				</tbody>
			</table>
				<%
	
End If 

rsSurveyList.Close
Set rsSurveyList = Nothing

%>
										
		</div>


<INPUT TYPE="checkbox" NAME="ExcelOutput" VALUE="Y">&nbsp;&nbsp;<FONT FACE=verdana,arial,helvetica SIZE=2>Output To Excel</FONT>
<br /><br />
<INPUT TYPE="submit" VALUE="Continue"></FORM>

</div>

</section>

<script type="text/javascript">
$(document).ready(function () {
var oTable;
 
/* Formating function for row details */
function fnFormatDetails ( nTr )
{
    var aData = oTable.fnGetData( nTr );
    var sOut = '<table cellpadding="5" cellspacing="0" border="0" style="padding-left:50px;">';
    sOut += '<tr><td>Rendering engine:</td><td>'+aData[2]+' '+aData[5]+'</td></tr>';
    sOut += '<tr><td>Link to source:</td><td>Could provide a link here</td></tr>';
    sOut += '<tr><td>Extra info:</td><td>And any further details here (images etc)</td></tr>';
    sOut += '</table>';
     
    return sOut;
}
 
$(document).ready(function() {
    oTable = $('#report').dataTable( {
        "bProcessing": true,
        "bServerSide": true,
        "sAjaxSource": "scripts/details_col.php",
        "aoColumns": [
            { "sClass": "center", "bSortable": false },
            null,
            null,
            null,
            { "sClass": "center" },
            { "sClass": "center" }
        ],
        "aaSorting": [[1, 'asc']]
    } );
     
    $('#report tbody td img').live( 'click', function () {
        var nTr = $(this).parents('tr')[0];
        if ( oTable.fnIsOpen(nTr) )
        {
            /* This row is already open - close it */
            this.src = "http://datatables.net/release-datatables/examples/examples_support/details_open.png";
            oTable.fnClose( nTr );
        }
        else
        {
            /* Open this row */
            this.src = "http://datatables.net/release-datatables/examples/examples_support/details_close.png";
            oTable.fnOpen( nTr, fnFormatDetails(nTr), 'details' );
        }
    } );
} );

});
</script>


</body>
</html>

<%	

End Sub


'==========================================================

Sub DisplayReport(ReportEventCode)

Dim StandardQuestion(9)
StandardQuestion(1) = "Customer Name"
StandardQuestion(2) = "Day Phone"
StandardQuestion(3) = "Evening Phone"
StandardQuestion(4) = "Email Address"
StandardQuestion(5) = "Subscriptions"
StandardQuestion(6) = "Series Count"
StandardQuestion(7) = "Ticket Count"
StandardQuestion(8) = "Redeemed Tickets"
StandardQuestion(9) = "Remaining Tickets"

ActArray = Split(CustomQuestion,",")

ColNbr =  (uBound(StandardQuestion))

MemberEventCode = ReportEventCode

FullSeriesEndDate = ""

TotalPackageCount = 0

AppliedCount = 0

RemainingDiscounts = 0

Select Case MemberEventCode
	Case 589274
		ThisDiscountNumber = 81714
	Case 678679
		ThisDiscountNumber = 98384
End Select



Dim SeriesSeatType(3)
SeriesSeatType(1) = 8049 'Adult Package (six shows) 
SeriesSeatType(2) = 8120 'Adult - Package
SeriesSeatType(3) = 8121 'Senior - Package


Dim SeriesCount(1)
SeriesCount(1) = 6

Dim SeriesName(1)
SeriesName(1) = "Season Subscription"


ReportTitle = GetAct(MemberEventCode)




'Determine the survey number attached to the event
SQLSurveyNum = "SELECT SurveyNumber FROM Event (NOLOCK) WHERE Event.EventCode = " & ReportEventCode & ""
Set rsSurveyNum = OBJdbConnection.Execute(SQLSurveyNum)
ThisSurveyNum = rsSurveyNum ("SurveyNumber")
rsSurveyNum.Close
Set rsSurveyNum = Nothing



'Determine the discount code attached to the event
'SQLDiscNum = "SELECT DiscountTypeNumber FROM DiscountEvents (NOLOCK) WHERE DiscountEvents.EventCode = " & ReportEventCode & ""
'Set rsDiscNum = OBJdbConnection.Execute(SQLDiscNum)
'ThisDiscountNumber = rsDiscNum ("DiscountTypeNumber")
'rsDiscNum.Close
'Set rsDiscNum = Nothing

'ErrorLog("DiscountCode: " & ThisDiscountNumber & "")
	
'Determine the number of custom questions associated with the survey
SQLQuestionCheck= "SELECT DISTINCT Act.ActCode as Question FROM Act WITH (NOLOCK) INNER JOIN Event WITH (NOLOCK) ON Act.ActCode = Event.ActCode INNER JOIN Seat WITH (NOLOCK) ON Event.EventCode = Seat.EventCode INNER JOIN OrderLine WITH (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber WHERE OrderLine.DiscountTypeNumber = " & ThisDiscountNumber & ""
Set rsQuestionCheck = OBJdbConnection.Execute(SQLQuestionCheck)
Do Until rsQuestionCheck.EOF
	CustomQuestion = CustomQuestion & "," & rsQuestionCheck("Question")
rsQuestionCheck.MoveNext	
Loop   		 
rsQuestionCheck.Close
Set rsQuestionCheck= nothing 

'Determine the event information (used for the report header)
SQLEvent = "SELECT Act, Venue, EventDate, OrganizationVenue.OrganizationNumber FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) on Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) on Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = Act.ActCode AND OrganizationVenue.OrganizationNumber = OrganizationAct.OrganizationNumber WHERE Event.EventCode = " & ReportEventCode & " AND OrganizationVenue.Owner <> 0"
Set rsEvent = OBJdbConnection.Execute(SQLEvent)
	ReportTitle2 = "" & rsEvent("Act") & " at " & rsEvent("Venue") & " on " & FormatDateTime(rsEvent("EventDate"), vbShortDate) & " at " & Left(FormatDateTime(rsEvent("EventDate"), vbLongTime), Len(FormatDateTime(rsEvent("EventDate"), vbLongTime))-6) & " " & Right(FormatDateTime(rsEvent("EventDate"),vbLongTime), 2) & ""
rsEvent.Close
Set rsEvent = nothing	

%>

<!DOCTYPE html>

<head>

<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="shortcut icon" type="image/ico" href="/images/favicon.ico">

<title>Tix</title>

<style type="text/css">
@import "http://twitter.github.com/bootstrap/assets/css/bootstrap.css";
@import "http://datatables.github.com/Plugins/integration/bootstrap/dataTables.bootstrap.css";
</style>

<style>
.TixManagementContent {padding-top: 20px !important; margin-top: -13px !important;}
.white ul.mega-menu, .white ul.mega-menu, .white ul.mega-menu li { line-height: 16px; }
</style>

<style>
.table_wrapper {padding: 0px}
.header { background: -moz-linear-gradient(center top , rgb(233, 234, 236) 0%, rgb(212, 212, 214) 100%) repeat scroll 0% 0% transparent; background-color: rgb(233, 234, 236); height: 38px; line-height: 38px; border-width: 1px 1px 0px; border-style: solid; border-color: rgb(201, 201, 201); -moz-border-top-colors: none; -moz-border-right-colors: none; -moz-border-bottom-colors: none; -moz-border-left-colors: none; -moz-border-image: none; border-radius: 5px 5px 0px 0px; box-shadow: 0px 1px 0px rgb(255, 255, 255) inset; padding: 0px 15px; }
.header { border-bottom: 1px solid  #999;}
.header_title { margin: 0px; padding-top: 10px; color: #3D3949; font-size: 20px; text-shadow: 0pt 1px 0px rgb(255, 255, 255); font-weight: strong; float: left;  }
.table thead th {background-color: #EBF2F6 !important;}
.table-bordered thead:first-child tr:first-child th:first-child, .table-bordered tbody:first-child tr:first-child td:first-child { border-top-left-radius: 0; }
.table-bordered {border-collapse: collapse;}
.dtTop { display: none; background-color: red;}
</style>

<!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
<!--[if lt IE 9]>
<script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
<![endif]-->

</head>
	
<body BGCOLOR="#FFFFFF">
	
<!--#INCLUDE VIRTUAL="TopNavInclude.asp" -->

<form action="<%= SurveyFileName %>" method="post" name="Survey">
<input type="hidden" name="FormName" value="ReportCriteria">

	<div class="header">
		<h4 class="header_title"><%= ReportTitle %></h4>
		<div>

		</div>
	</div>
	
	<table cellpadding="3" cellspacing="0" border="1"  id="example">
		<thead>
			<tr>
			
<%			
		'Standard Column Headings
		'----------------
        For j = 1 to ubound(StandardQuestion)
%>		
            <th><%= StandardQuestion(j) %></th>
<%			
        Next
%>        

			</tr>
		</thead>
		<tbody>

<%
		
	SQLSeat = "SELECT DISTINCT(OrderHeader.CustomerNumber) FROM Seat (NOLOCK) INNER JOIN Section (NOLOCK) ON Seat.SectionCode = Section.SectionCode AND Seat.EventCode = Section.EventCode INNER JOIN SeatStatus (NOLOCK) ON Seat.StatusCode = SeatStatus.StatusCode LEFT JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent', 'SubSeat') INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode AND OrganizationVenue.OrganizationNumber = OrganizationAct.OrganizationNumber LEFT JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber LEFT JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode LEFT JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber WHERE Seat.EventCode = " & ReportEventCode & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND Seat.StatusCode = 'S' ORDER BY OrderHeader.CustomerNumber"
	Set rsSeat = OBJdbConnection.Execute(SQLSeat)

		If Not rsSeat.EOF Then  

			Do Until rsSeat.EOF
						
		'Customer Info
        '-------------
		
                SQLCustomerInfo = "SELECT FirstName, MiddleInitial, LastName, Address1, Address2, City, State, PostalCode, Country, DayPhone, NightPhone, EMailAddress, OptIn FROM Customer (NOLOCK) WHERE CustomerNumber = " & rsSeat("CustomerNumber") & ""
                Set rsCustomerInfo = OBJdbConnection.Execute(SQLCustomerInfo)
%>
                    <tr>
                    <td><%= ProperCase(rsCustomerInfo("LastName")) %>, <%= ProperCase(rsCustomerInfo("FirstName")) %></td>
                    <td><%= MkPhoneNum(rsCustomerInfo("DayPhone")) %></td>
		            <td><%= MkPhoneNum(rsCustomerInfo("NightPhone")) %></td>
		            <td><%= LCASE(rsCustomerInfo("EMailAddress")) %></td>
<%
                rsCustomerInfo.Close
                Set rsCustomerInfo = nothing
				
		'Determine the number of full season packages purchased
		'------------------------------------------------------
		
			Count = 0
				
			'Determine the total number of discounted tickets orginally due to the paton
			SQLFreeTickets = "SELECT Count(OrderLine.SeatTypeCode) as TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderHeader.CustomerNumber = " & rsSeat("CustomerNumber") & " AND Seat.EventCode = "&MemberEventCode&" " 
			Set rsFreeTickets = OBJdbConnection.Execute(SQLFreeTickets)

				If Not rsFreeTickets.EOF Then					 
					TicketCount = rsFreeTickets("TicketCount")
				End If

			rsFreeTickets.Close
			Set rsFreeTickets = Nothing  
			
						
%>
			 <td><%=TicketCount%></td>

<%		
			'Determine the number of discounted tickets per season padckage
			'------------------------------------------------------
%>
			<td><%=SeriesCount(1)%></td>
<%			
			
			'Total number of allowed discounted tickets
			'------------------------------------------------------
			TotalPackageCount = ( TicketCount * SeriesCount(1))
%>
			
			<td><%=TotalPackageCount%></td>
<%			
			
			'Act List 
			'-----------------
			
			AppliedCount = 0
			
			ActArray = Split(CustomQuestion,",")
			
			For k = 1 to ubound(ActArray)
			
			Errorlog ("ActArray "&ActArray(k)&"")
			
			If ActArray(k) <> 94013 Then

				SQLDiscCheck = "SELECT Count(OrderLine.LineNumber) as TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE CustomerNumber = " & rsSeat("CustomerNumber") & " AND ActCode = " & ActArray(k) & " AND OrderLine.StatusCode = 'S' AND OrderLine.DiscountTypeNumber = " & ThisDiscountNumber  & ""
				Set rsDiscCheck = OBJdbConnection.Execute(SQLDiscCheck)
				
						If IsNull(rsDiscCheck("Ticketcount")) Then
							'Response.Write "<td> 0 </td>" & vbCrLf
							AppliedCount = AppliedCount +  0
						Else
							ErrorLog("ActCount " & rsDiscCheck("Ticketcount") & "")
							AppliedCount = AppliedCount +  rsDiscCheck("Ticketcount")
							ErrorLog("AppliedCount " & AppliedCount & "")
						End If 

				rsDiscCheck.Close
				Set rsDiscCheck = Nothing 


			End If

			Next
			
			'Total number of applied tickets
			'------------------------------------------------------
%>			
			<td class="center"><%=  AppliedCount %></td>
<% 
			
			
			'Total number of tickets remaining
			'------------------------------------------------------
			RemainingDiscounts =  (TotalPackageCount - AppliedCount)
%>						
			<td class="center"><%=  RemainingDiscounts  %></td>
<% 
 
		rsSeat.MoveNext
		Loop
%>
	</table>
<%
	
End If 

rsSeat.Close
Set rsSeat = Nothing

%>

</FORM>
	


<!--#INCLUDE VIRTUAL="FooterInclude.asp"-->

<!-- jQuery -->
<script src="//ajax.aspnetcdn.com/ajax/jQuery/jquery-1.8.2.js" type="text/javascript"></script>


<!-- JQuery dataTables -->
<script src="http://ajax.aspnetcdn.com/ajax/jquery.dataTables/1.9.4/jquery.dataTables.js"></script>


<!-- Bootstrap dataTables integration -->
<script type="text/javascript" charset="utf-8" src="http://datatables.github.com/Plugins/integration/bootstrap/dataTables.bootstrap.js"></script>
			
<script type="text/javascript">
$(document).ready(function () {
	$("#report").dataTable({
		"sDom": "<'dtTop'<'dtShowPer'l><'dtFilter'f>><'dtTables't><'dtBottom'<'dtInfo'i><'dtPagination'p>>",
		"oLanguage": 
		{
			"sLengthMenu": "Show entries _MENU_",
		},
		"sPaginationType": "full_numbers",
		"fnInitComplete4": function()
		{
			$(".dtShowPer select").uniform();
			$(".dtFilter input").addClass("simple_field").css(
			{
				"width": "auto",
				"margin-left": "15px",
			});
		},
		"iDisplayLength": 3, 
		"aLengthMenu": [[3, 10, 15, -1], [3, 10, 15, "Show All"]]
	});
});
</script>

</body>

</html>

<%

End Sub

'==========================================================

Function ProperCase(X)
 'return a string with the first letter of the word capitalised

 If IsNull(X) Then
 Exit Function
 Else
 lowercaseSTR = CStr(LCase(X))
 OldC = " "
 MyArray = Split(lowercaseSTR," ")
 For IntI = LBound(MyArray) To UBound(MyArray)
 For I = 1 To Len(MyArray(IntI))
 If Len(MyArray(IntI)) = 1 Then
 newString = newString & UCase(MyArray(IntI)) & " "
 ElseIf I=1 OR capNext = 1 Then
 newString = newString & UCase(Mid(MyArray(IntI), I, 1))
 capNext = 0
 ElseIf I = 2 AND Mid(MyArray(IntI), I, 1) = "i" AND Mid(MyArray(IntI), I-1, 1) = "i" Then
 newString = newString & UCase(Mid(MyArray(IntI), I, 1))
 ElseIf I = 3 AND Mid(MyArray(IntI), I, 1) = "i" AND Mid(MyArray(IntI), I-1, 1) = "i" Then
 newString = newString & UCase(Mid(MyArray(IntI), I, 1))
 ElseIf I = Len(MyArray(IntI)) Then
 newString = newString & Mid(MyArray(IntI), I, 1) & " "
 Else
 If Mid(MyArray(IntI), I, 1) = "-" OR Mid(MyArray(IntI), I, 1) = "'" Then
 capNext = 1
 End If
 If I = 2 AND Mid(MyArray(IntI), I, 1) = "c" AND Mid(MyArray(IntI), I-1, 1) = "m" Then
 capNext = 1
 End If
 newString = newString & Mid(MyArray(IntI), I, 1)
 End If
 Next
 Next 'IntI
 ProperCase = Trim(newString)
 End If
 End Function

 '=====================================

Private Function MkPhoneNum(byVal number)
	Dim tmp
	number = CStr( number )
	number = Trim( number )
	number = Replace( number, " ", "" )	
	number = Replace( number, "-", "" )
	number = Replace( number, "(", "" )
	number = Replace( number, ")", "" )
	Select Case Len( number )
		Case 7
			tmp = tmp & Mid( number, 1, 3 ) & "-"
			tmp = tmp & Mid( number, 4, 4 )
		Case 10
			tmp = tmp & "(" & Mid( number, 1, 3 ) & ") "
			tmp = tmp & Mid( number, 4, 3 ) & "-"
			tmp = tmp & Mid( number, 7, 4 )
		Case 11
			tmp = tmp & Mid( number, 1, 1 ) & " "
			tmp = tmp & "(" & Mid( number, 2, 3 ) & ") "
			tmp = tmp & Mid( number, 5, 3 ) & "-"
			tmp = tmp & Mid( number, 8, 4 )
		Case Else
			MkPhoneNum = number
			Exit Function
	End Select
	MkPhoneNum = tmp
End Function

 '=====================================


FUNCTION GetAct(Eventcode)

		SQLActLookUp = "SELECT Act.Act, Event.ActCode FROM Event (NOLOCK) INNER JOIN ACT ON Event.ActCode = Act.ActCode WHERE EventCode = " & EventCode & ""
		Set rsActLookUp = OBJdbConnection.Execute(SQLActLookUp)			
			ThisAct = rsActLookUp("Act")
		rsActLookUp.Close
		Set rsActLookUp = nothing
	
		GetAct = ThisAct
	
END FUNCTION

 '=====================================


%>


