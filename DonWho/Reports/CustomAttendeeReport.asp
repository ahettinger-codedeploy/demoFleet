<%

'CHANGE LOG

'SSR - 12/04/2012 - Created new custom report for the attendee survey



%>

<!--#include virtual="GlobalInclude.asp"-->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="/include/managementinclude.asp"-->

<%

'============================================================

Page = "Management"
ReportFileName = "CustomAttendeeSurveyReport.asp"

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
<!-- IE compatibility mode - turns it off and displays in standard view -->
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />

<!--#INCLUDE VIRTUAL="TopNavInclude.asp"-->

<TITLE>Tix - Survey Report</TITLE>

<link href='http://fonts.googleapis.com/css?family=Droid+Sans:400,700' rel='stylesheet' type='text/css'>

<style>

/* Table  */
.tables { width: 100%; border-collapse: collapse; border-spacing: 0px; }
.tables th, .tables td { border: 1px solid rgb(224, 224, 224); padding: 4px 15px; }
.tables thead tr { box-shadow: 0px 1px 3px rgb(230, 230, 230); }
.tables thead th { border-top: 0px none; }
.tables th {font-size: 13px; color: #3D3949; text-shadow: 0px 1px 0px rgb(255, 255, 255); font-weight: strong; line-height: 25px; background: -moz-linear-gradient(center top , rgb(254, 254, 254) 0%, rgb(242, 242, 242) 100%) repeat scroll 0% 0% transparent; box-shadow: 0px 1px 0px rgb(255, 255, 255) inset; border-bottom-color: rgb(218, 218, 218); }
.tables td { padding: 5px 10px; white-space: nowrap ! important; border-top: 1px solid rgb(254, 254, 254); border-bottom: 1px solid rgb(224, 224, 224); }


.tables tbody tr:hover td {background: #d0dafd; color: #339;}

/* Table Rows Columns  */
.tables tr.odd { background-color: #eee; }
.tables tr.odd td.sorting_1 { background-color: #e6e6e6; }
.tables tr.even { background-color: #fff; }
.tables tr.even td.sorting_1 { background-color: #f6f6f6; }
.tables tr.odd td.sorting_2 { background-color: white; }
.tables tr.odd td.sorting_3 { background-color: green; }
.tables tr.even td.sorting_2 { background-color: pink; }
.tables tr.even td.sorting_3 { background-color: black; }
.tables th:first-child { border-left-width: 0px; }
.tables th:last-child { border-right-width: 0px; }
.tables td:first-child { border-left-width: 0px; }
.tables td:last-child { border-right-width: 0px; }
.tables tr:last-child td { border-bottom-width: 0px; }
.tables tr:first-child td { border-bottom-width: 0px; }
.tables tr:nth-child(2n) { background-color: #ffffff; }

/* Sorting  */
.tables thead th.sorting { cursor: pointer; background: url('http://ajax.aspnetcdn.com/ajax/jquery.dataTables/1.9.3/images/sort_both.png') no-repeat scroll right center, -moz-linear-gradient(center top , rgb(254, 254, 254) 0%, rgb(242, 242, 242) 100%) repeat scroll 0% 0% transparent; }
.tables thead th.sorting_desc { cursor: pointer; background: url('http://ajax.aspnetcdn.com/ajax/jquery.dataTables/1.9.3/images/sort_desc.png') no-repeat scroll right center, -moz-linear-gradient(center top , rgb(254, 254, 254) 0%, rgb(242, 242, 242) 100%) repeat scroll 0% 0% transparent; }
.tables thead th.sorting_asc { cursor: pointer; background: url('http://ajax.aspnetcdn.com/ajax/jquery.dataTables/1.9.3/images/sort_asc.png') no-repeat scroll right center, -moz-linear-gradient(center top , rgb(254, 254, 254) 0%, rgb(242, 242, 242) 100%) repeat scroll 0% 0% transparent; }
.tables thead th.sorting_asc_disabled { background: url('http://ajax.aspnetcdn.com/ajax/jquery.dataTables/1.9.3/images/sort_asc_disabled.png') no-repeat center right; }
.tables thead th.sorting_desc_disabled { background: url('http://ajax.aspnetcdn.com/ajax/jquery.dataTables/1.9.3/images/sort_desc_disabled.png') no-repeat center right; }

/* Header  */
.header { background: -moz-linear-gradient(center top , rgb(233, 234, 236) 0%, rgb(212, 212, 214) 100%) repeat scroll 0% 0% transparent; background-color: rgb(233, 234, 236); height: 38px; line-height: 38px; border-width: 1px 1px 0px; border-style: solid; border-color: rgb(201, 201, 201); -moz-border-top-colors: none; -moz-border-right-colors: none; -moz-border-bottom-colors: none; -moz-border-left-colors: none; -moz-border-image: none; border-radius: 5px 5px 0px 0px; box-shadow: 0px 1px 0px rgb(255, 255, 255) inset; padding: 0px 15px; }
.header_title { margin: 0px; padding-top: 10px; color: #3D3949; font-size: 20px; text-shadow: 0pt 1px 0px rgb(255, 255, 255); font-weight: strong; float: left;  }
h4 { font-size: 16px;  line-height: 19px;  margin-top: 25px;  margin-right: 0pt;  margin-bottom: 15px;  margin-left: 0pt; }


/* Sections  */
.dtShowPer, .dtFilter, .dtInfo, .dtPagination {color: rgb(143, 143, 143); font-size: 13px; text-shadow: 0px 1px 0px rgb(255, 255, 255); }
.dtTop {padding: 0px 15px; height: 60px; line-height: 60px; border-bottom: 1px solid rgb(201, 201, 201); background: -moz-linear-gradient(center top , rgb(253, 253, 253) 0%, rgb(248, 248, 248) 100%) repeat scroll 0% 0% transparent; box-shadow: 0px 1px 0px rgb(255, 255, 255) inset; }
.dtBottom,  { padding: 0px 15px; height: 50px; line-height: 50px; border-top: 1px solid rgb(201, 201, 201); background: -moz-linear-gradient(center top , rgb(253, 253, 253) 0%, rgb(244, 244, 244) 100%) repeat scroll 0% 0% transparent; box-shadow: 0px 1px 0px rgb(255, 255, 255) inset, 0px -2px 3px rgb(230, 230, 230); }
.dtTables { clear: both; overflow: auto; }
.dtShowPer { float: right; }
.dtFilter { float: left; }
.dtInfo { float: left; }
.dtBottom .dtPagination { float: right; }
.contents.noPadding { padding: 0px; overflow: hidden; }
.contents { background-color: rgb(253, 253, 253); border: 1px solid rgb(201, 201, 201); border-radius: 0px 0px 3px 3px; box-shadow: 0px 1px 0px rgb(255, 255, 255) inset; padding: 15px; }


/* Pages  */
.dtPagination a { padding: 0px 10px; margin: 12px 4px 0px; cursor: pointer; }
.dtPagination a:hover { background: -moz-linear-gradient(center top , rgb(255, 255, 255) 0%, rgb(251, 251, 251) 100%) repeat scroll 0% 0% transparent; }
.dtPagination a.paginate_active { background: none repeat scroll 0px 0px rgb(239, 239, 239); }
.dtPagination a, { display: inline-block; background: -moz-linear-gradient(center top , rgb(255, 0, 0) 0%, rgb(242, 242, 242) 100%) repeat scroll 0% 0% transparent; border: 1px solid rgb(203, 203, 203); border-radius: 3px 3px 3px 3px; height: 26px; line-height: 26px; color: rgb(143, 143, 143); font-size: 12px; text-shadow: 0px 1px 0px rgb(255, 255, 255); box-shadow: 0px 2px 3px rgb(234, 234, 234); cursor: pointer; }

</style>

<script src="http://ajax.aspnetcdn.com/ajax/jquery.dataTables/1.8.2/jquery.dataTables.min.js" type="text/javascript" charset="utf8" ></script>


<script>
$(document).ready( function () {

	$("#eventlist").dataTable(
		{
		"sDom"		: "<'dtTop'<'dtShowPer'l><'dtFilter'f>><'dtTables't><'dtBottom'<'dtInfo'i><'dtPagination'p>>",
		"oLanguage"	: 
			{
			"sZeroRecords"	: "Sorry. There are no items to display.",
			"sLengthMenu"	: "Display _MENU_ items per page",
			"sInfo"			: "Displaying _START_ to _END_ of _TOTAL_ items",
			"sInfoEmpty"	: "Showing 0 to 0 of 0 items",
			"sInfoFiltered"	: "(filtered from _MAX_ total )"
			}, 
		"aaSorting"   	: [[1, 'asc']],
		"bStateSave"  	: true,
		"aoColumns"   	: [ { "bSortable": false }, null, null, null, null, null],
		});
});	
</script>

</head>

<body>

<form action="<%= SurveyFileName %>" method="post" name="Survey">
<input type="hidden" name="FormName" value="ReportCriteria">

<% EventListDaysDefault = 360 %>

<%
   
'Get all events for Organization

'REE 6/30/3 - Added OrganizationOption ReportArchiveDays
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

%>

<section>
<div class="with-padding">
<div class="columns">
<div class="twelve-columns">

<%

SQLSurveyList = "SELECT Event.EventDate, Event.EventCode, Survey.SurveyNumber, Survey.SurveyDescription, Act.Act FROM Survey (NOLOCK) INNER JOIN Event (NOLOCK) ON Survey.SurveyNumber = Event.SurveyNumber INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode WHERE Survey.OrganizationNumber = " & Session("OrganizationNumber") & " ORDER BY Event.EventDate, Act.Act"
Set rsSurveyList = OBJdbConnection.Execute(SQLSurveyList)

If Not rsSurveyList.EOF Then 

%>
	<div class="header">
		<h4 class="header_title">Survey Report</h4>
		<div>

		</div>
	</div>
	<div class="contents noPadding">
	<table id="eventlist" class="datatable tables">
		<thead>
			<tr>
				<th>&nbsp;</th>
				<th>Date/Time</th>
				<th>EventCode</th>
				<th>Production</th>
				<th>Survey</th>
				<th>Ticket Count</th>
			</tr>
		</thead>
		<tbody>

<%

		Do Until rsSurveyList.EOF
		
			SQLMaxQuestions = "SELECT MAX(QuestionNumber) AS Count FROM SurveyQuestion(NOLOCK) WHERE SurveyNumber = " & rsSurveyList("SurveyNumber") & ""
			Set rsMaxQuestions = OBJdbConnection.Execute(SQLMaxQuestions)
			MaxQuestions = rsMaxQuestions("Count")
			rsMaxQuestions.Close
			Set rsMaxQuestions = Nothing
			
			If LEN(MaxQuestions) > 0 Then
			
			SQLTicketsSold = "SELECT Count(OrderLine.LineNumber) as Count FROM Seat (NOLOCK) INNER JOIN Section (NOLOCK) ON Seat.SectionCode = Section.SectionCode AND Seat.EventCode = Section.EventCode INNER JOIN SeatStatus (NOLOCK) ON Seat.StatusCode = SeatStatus.StatusCode LEFT JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent', 'SubSeat') INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode AND OrganizationVenue.OrganizationNumber = OrganizationAct.OrganizationNumber LEFT JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber LEFT JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode LEFT JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber WHERE Seat.EventCode = " & rsSurveyList("EventCode") & "  AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND Seat.StatusCode = 'S' "
			Set rsTicketsSold = OBJdbConnection.Execute(SQLTicketsSold)

		%>
		
		<tr>
			<td><INPUT TYPE="radio" NAME="ReportEventCode" VALUE=<%=rsSurveyList("EventCode")%> /></td>
			<td><%=DateAndTimeFormat(rsSurveyList("EventDate"))%></td>
			<td ><%=rsSurveyList("EventCode")%></td>
			<td ><%=rsSurveyList("Act")%></td>
			<td><%=rsSurveyList("SurveyDescription")%>&nbsp;(#<%=rsSurveyList("SurveyNumber")%>)</td>
			<td><%=rsTicketsSold("Count")%></td>
		</tr>
		
		<% 
		
		End If
		
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
<br /><br />
<INPUT TYPE="checkbox" NAME="ExcelOutput" VALUE="Y">&nbsp;&nbsp;<FONT FACE=verdana,arial,helvetica SIZE=2>Output To Excel</FONT>
<br /><br />
<INPUT TYPE="submit" VALUE="Continue"></FORM>
		

</div>
</div>
</div>
</section>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>
</html>

<%

End Sub

'======================================

Sub DisplayReport(ReportEventCode)


Dim StandardQuestion(10)
StandardQuestion(1) = "Order Number"
StandardQuestion(2) = "Order Date/Time"
StandardQuestion(3) = "Customer Name"
StandardQuestion(4) = "Day Phone"
StandardQuestion(5) = "Evening Phone"
StandardQuestion(6) = "Email Address"
StandardQuestion(7) = "Status"
StandardQuestion(8) = "Ticket Type"
StandardQuestion(9) = "Net Price"
StandardQuestion(10) = "Order Type"



'Survey Number
SQLSurveyNum = "SELECT SurveyNumber FROM Event (NOLOCK) WHERE Event.EventCode = " & ReportEventCode & ""
Set rsSurveyNum = OBJdbConnection.Execute(SQLSurveyNum)
	ThisSurveyNum = rsSurveyNum ("SurveyNumber")
rsSurveyNum.Close
Set rsSurveyNum = Nothing

'Number of Questions
SQLMaxQuestions = "SELECT MAX(QuestionNumber) AS Count FROM SurveyQuestion(NOLOCK) WHERE SurveyNumber = " & ThisSurveyNum & ""
Set rsMaxQuestions = OBJdbConnection.Execute(SQLMaxQuestions)
	MaxQuestions = rsMaxQuestions("Count")
rsMaxQuestions.Close
Set rsMaxQuestions = Nothing

SQLMaxAnswers = "SELECT Count(Answer) AS Count FROM SurveyAnswers(NOLOCK) WHERE SurveyNumber = " & ThisSurveyNum & ""
Set rsMaxAnswers = OBJdbConnection.Execute(SQLMaxAnswers)	
	If  rsMaxAnswers("Count") = 0 Then
		SurveyAnswers = False
	Else
		SurveyAnswers = True
	End If
rsMaxAnswers.Close
Set rsMaxAnswers = Nothing

SQLMaxRecords = "SELECT Count(OrderLine.LineNumber) as Count FROM Seat (NOLOCK) INNER JOIN Section (NOLOCK) ON Seat.SectionCode = Section.SectionCode AND Seat.EventCode = Section.EventCode INNER JOIN SeatStatus (NOLOCK) ON Seat.StatusCode = SeatStatus.StatusCode LEFT JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent', 'SubSeat') INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode AND OrganizationVenue.OrganizationNumber = OrganizationAct.OrganizationNumber LEFT JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber LEFT JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode LEFT JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber WHERE Seat.EventCode = " & ReportEventCode & "  AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND Seat.StatusCode = 'S' "
Set rsMaxRecords = OBJdbConnection.Execute(SQLMaxRecords)
MaxRecords = rsMaxRecords("Count")
rsMaxRecords.Close
Set rsMaxRecords = Nothing

If MaxRecords > 20 Then 
	PageCount1 =  Round(MaxRecords / 4)
	PageCount2 = (PageCount1 * 2)
	PageCount3 = (PageCount1 * 3)
End If

Response.Buffer = False

Excel = Clean(Request("ExcelOutput"))

If Excel = "Y" Then

	Response.ContentType = "application/vnd.ms-excel"

End If

%>

<!DOCTYPE html> 

<html>

<head>
<!-- IE compatibility mode - turns it off and displays in standard view -->
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />

<!--#INCLUDE VIRTUAL="TopNavInclude.asp"-->

<TITLE>Tix - Survey Report</TITLE>


<link href='http://fonts.googleapis.com/css?family=Droid+Sans:400,700' rel='stylesheet' type='text/css'>

<style>

/* Table  */
.tables { width: 100%; border-collapse: collapse; border-spacing: 0px; }
.tables th, .tables td { border: 1px solid rgb(224, 224, 224); padding: 4px 15px; }
.tables thead tr { box-shadow: 0px 1px 3px rgb(230, 230, 230); }
.tables thead th { border-top: 0px none; }
.tables th {font-size: 13px; color: #3D3949; text-shadow: 0px 1px 0px rgb(255, 255, 255); font-weight: strong; line-height: 25px; background: -moz-linear-gradient(center top , rgb(254, 254, 254) 0%, rgb(242, 242, 242) 100%) repeat scroll 0% 0% transparent; box-shadow: 0px 1px 0px rgb(255, 255, 255) inset; border-bottom-color: rgb(218, 218, 218); }
.tables td { padding: 5px 10px; white-space: nowrap ! important; border-top: 1px solid rgb(254, 254, 254); border-bottom: 1px solid rgb(224, 224, 224); }


.tables tbody tr:hover td {background: #d0dafd; color: #339;}

/* Table Rows Columns  */
.tables tr.odd { background-color: #eee; }
.tables tr.odd td.sorting_1 { background-color: #e6e6e6; }
.tables tr.even { background-color: #fff; }
.tables tr.even td.sorting_1 { background-color: #f6f6f6; }
.tables tr.odd td.sorting_2 { background-color: white; }
.tables tr.odd td.sorting_3 { background-color: green; }
.tables tr.even td.sorting_2 { background-color: pink; }
.tables tr.even td.sorting_3 { background-color: black; }
.tables th { white-space: nowrap;}
.tables th:first-child { border-left-width: 0px; }
.tables th:last-child { border-right-width: 0px; }
.tables td:first-child { border-left-width: 0px; }
.tables td:last-child { border-right-width: 0px; }
.tables tr:last-child td { border-bottom-width: 0px; }
.tables tr:first-child td { border-bottom-width: 0px; }
.tables tr:nth-child(2n) { background-color: #ffffff; }

/* Sorting  */
.tables thead th.sorting { cursor: pointer; background: url('http://ajax.aspnetcdn.com/ajax/jquery.dataTables/1.9.3/images/sort_both.png') no-repeat scroll right center, -moz-linear-gradient(center top , rgb(254, 254, 254) 0%, rgb(242, 242, 242) 100%) repeat scroll 0% 0% transparent; }
.tables thead th.sorting_desc { cursor: pointer; background: url('http://ajax.aspnetcdn.com/ajax/jquery.dataTables/1.9.3/images/sort_desc.png') no-repeat scroll right center, -moz-linear-gradient(center top , rgb(254, 254, 254) 0%, rgb(242, 242, 242) 100%) repeat scroll 0% 0% transparent; }
.tables thead th.sorting_asc { cursor: pointer; background: url('http://ajax.aspnetcdn.com/ajax/jquery.dataTables/1.9.3/images/sort_asc.png') no-repeat scroll right center, -moz-linear-gradient(center top , rgb(254, 254, 254) 0%, rgb(242, 242, 242) 100%) repeat scroll 0% 0% transparent; }
.tables thead th.sorting_asc_disabled { background: url('http://ajax.aspnetcdn.com/ajax/jquery.dataTables/1.9.3/images/sort_asc_disabled.png') no-repeat center right; }
.tables thead th.sorting_desc_disabled { background: url('http://ajax.aspnetcdn.com/ajax/jquery.dataTables/1.9.3/images/sort_desc_disabled.png') no-repeat center right; }

/* Header  */
.header { background: -moz-linear-gradient(center top , rgb(233, 234, 236) 0%, rgb(212, 212, 214) 100%) repeat scroll 0% 0% transparent; background-color: rgb(233, 234, 236); height: 38px; line-height: 38px; border-width: 1px 1px 0px; border-style: solid; border-color: rgb(201, 201, 201); -moz-border-top-colors: none; -moz-border-right-colors: none; -moz-border-bottom-colors: none; -moz-border-left-colors: none; -moz-border-image: none; border-radius: 5px 5px 0px 0px; box-shadow: 0px 1px 0px rgb(255, 255, 255) inset; padding: 0px 15px; }
.header_title { margin: 0px; padding-top: 10px; color: #3D3949; font-size: 20px; text-shadow: 0pt 1px 0px rgb(255, 255, 255); font-weight: strong; float: left;  }
h4 { font-size: 16px;  line-height: 19px;  margin-top: 25px;  margin-right: 0pt;  margin-bottom: 15px;  margin-left: 0pt; }


/* Sections  */
.dtShowPer, .dtFilter, .dtInfo, .dtPagination {color: rgb(143, 143, 143); font-size: 13px; text-shadow: 0px 1px 0px rgb(255, 255, 255); }
.dtTop {padding: 0px 15px; height: 60px; line-height: 60px; border-bottom: 1px solid rgb(201, 201, 201); background: -moz-linear-gradient(center top , rgb(253, 253, 253) 0%, rgb(248, 248, 248) 100%) repeat scroll 0% 0% transparent; box-shadow: 0px 1px 0px rgb(255, 255, 255) inset; }
.dtBottom,  { padding: 0px 15px; height: 50px; line-height: 50px; border-top: 1px solid rgb(201, 201, 201); background: -moz-linear-gradient(center top , rgb(253, 253, 253) 0%, rgb(244, 244, 244) 100%) repeat scroll 0% 0% transparent; box-shadow: 0px 1px 0px rgb(255, 255, 255) inset, 0px -2px 3px rgb(230, 230, 230); }
.dtTables { clear: both; overflow: auto; }
.dtShowPer { float: right; }
.dtFilter { float: left; }
.dtInfo { float: left; }
.dtBottom .dtPagination { float: right; }
.contents.noPadding { padding: 0px; overflow: hidden; }
.contents { background-color: rgb(253, 253, 253); border: 1px solid rgb(201, 201, 201); border-radius: 0px 0px 3px 3px; box-shadow: 0px 1px 0px rgb(255, 255, 255) inset; padding: 15px; }


/* Pages  */
.dtPagination a { padding: 0px 10px; margin: 12px 4px 0px; cursor: pointer; }
.dtPagination a:hover { background: -moz-linear-gradient(center top , rgb(255, 255, 255) 0%, rgb(251, 251, 251) 100%) repeat scroll 0% 0% transparent; }
.dtPagination a.paginate_active { background: none repeat scroll 0px 0px rgb(239, 239, 239); }
.dtPagination a, { display: inline-block; background: -moz-linear-gradient(center top , rgb(255, 0, 0) 0%, rgb(242, 242, 242) 100%) repeat scroll 0% 0% transparent; border: 1px solid rgb(203, 203, 203); border-radius: 3px 3px 3px 3px; height: 26px; line-height: 26px; color: rgb(143, 143, 143); font-size: 12px; text-shadow: 0px 1px 0px rgb(255, 255, 255); box-shadow: 0px 2px 3px rgb(234, 234, 234); cursor: pointer; }

</style>


<script src="http://ajax.aspnetcdn.com/ajax/jquery.dataTables/1.8.2/jquery.dataTables.min.js" type="text/javascript" charset="utf8" ></script>

<script type="text/javascript">
$(document).ready(function () {
	$("#report").dataTable({
		"sDom": "<'dtTop'<'dtShowPer'l><'dtFilter'f>><'dtTables't><'dtBottom'<'dtInfo'i><'dtPagination'p>>",
        "oLanguage": 
		{
            "sZeroRecords": "Sorry. There are no orders to display.",
            "sLengthMenu": "Display _MENU_ records per page",
            "sInfo": "Displaying _START_ to _END_ of _TOTAL_ records",
            "sInfoEmpty": "Showing 0 to 0 of 0 records",
            "sInfoFiltered": "(filtered from _MAX_ total records)"
        }, 
		"sPaginationType": "full_numbers",
		"iDisplayLength": -1, 
		"aLengthMenu": [[<%=PageCount1%>, <%=PageCount2%>, <%=PageCount3%>, -1], [<%=PageCount1%>, <%=PageCount2%>, <%=PageCount3%>, "All"]]
	});
});
</script>

<%

Response.Write "</head>" & vbCrLf

Response.Write "<body>" & vbCrLf
 
SQLEvent = "SELECT Act, Venue, EventDate, OrganizationVenue.OrganizationNumber FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) on Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) on Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = Act.ActCode AND OrganizationVenue.OrganizationNumber = OrganizationAct.OrganizationNumber WHERE Event.EventCode = " & ReportEventCode & " AND OrganizationVenue.Owner <> 0"
Set rsEvent = OBJdbConnection.Execute(SQLEvent)
		ReportTitle2 = "" & rsEvent("Act") & " at " & rsEvent("Venue") & " on " & FormatDateTime(rsEvent("EventDate"), vbShortDate) & " at " & Left(FormatDateTime(rsEvent("EventDate"), vbLongTime), Len(FormatDateTime(rsEvent("EventDate"), vbLongTime))-6) & " " & Right(FormatDateTime(rsEvent("EventDate"),vbLongTime), 2) & ""
rsEvent.Close
Set rsEvent = nothing

'Report Title
'---------------------	
Response.Write "<h4>" & ReportTitle2 & "</h4>" & vbCrLf
Response.Write "<div class=""header"">" & vbCrLf
Response.Write "<h4 class=""header_title"">Attendee Survey Report</h4>" & vbCrLf
Response.Write "<div></div>" & vbCrLf
Response.Write "</div>" & vbCrLf
Response.Write "<div class=""contents noPadding"">" & vbCrLf

Response.Write "<table id=""report"" class=""datatable tables"">" & vbCrLf
Response.Write "<thead>" & vbCrLf
Response.Write "<tr>" & vbCrLf
					
		'Column Headings
		'----------------
		
        'Standard 
        For j = 1 to UBound(StandardQuestion)
            Response.Write "<th>" & StandardQuestion(j) & "</th>" & vbCrLf
        Next
        
		'Custom

           Response.Write "<th>Dinner Choice</th>" & vbCrLf
        
        Response.Write "</tr>" & vbCrLf     
		Response.Write "</thead>" & vbCrLf  
		Response.Write "</tbody>" & vbCrLf  		       
        
        'Report Body
        '--------------   
        
        SQLSeat = "SELECT Seat.EventCode, OrderLine.OrderNumber, OrderLine.LineNumber, Seat.ItemNumber, Seat.SectionCode, Section.Section, Section.SectionType, Seat.Row, Seat.Seat, SeatStatus.Status, Seat.HoldType, OrderType, OrderLine.SeatTypeCode, SeatType, Price, OrderLine.Discount, OrderDate, OrderHeader.CustomerNumber, ShipFirstName AS FirstName, ShipLastName AS LastName FROM Seat (NOLOCK) INNER JOIN Section (NOLOCK) ON Seat.SectionCode = Section.SectionCode AND Seat.EventCode = Section.EventCode INNER JOIN SeatStatus (NOLOCK) ON Seat.StatusCode = SeatStatus.StatusCode LEFT JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent', 'SubSeat') INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode AND OrganizationVenue.OrganizationNumber = OrganizationAct.OrganizationNumber LEFT JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber LEFT JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode LEFT JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber WHERE Seat.EventCode = " & ReportEventCode & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND Seat.StatusCode = 'S' ORDER BY Seat.SectionCode, Seat.RowSort, Seat.SeatSort DESC"
        Set rsSeat = OBJdbConnection.Execute(SQLSeat)
	
	    If Not rsSeat.EOF Then  
		
		Do Until rsSeat.EOF
		
        'Standard Data
        '-------------
		
                SQLCustomerInfo = "SELECT FirstName, MiddleInitial, LastName, Address1, Address2, City, State, PostalCode, Country, DayPhone, NightPhone, EMailAddress, OptIn FROM Customer (NOLOCK) WHERE CustomerNumber = " & rsSeat("CustomerNumber") & ""
                Set rsCustomerInfo = OBJdbConnection.Execute(SQLCustomerInfo)

                    Response.Write "<tr>" & vbCrLf
		            Response.Write "<td>" & rsSeat("OrderNumber") & "</td>" & vbCrLf
		            Response.Write "<td>" & DateAndTimeFormat(rsSeat("OrderDate")) & "</td>" & vbCrLf
                    Response.Write "<td>" & ProperCase(rsCustomerInfo("LastName")) & ", " & ProperCase(rsCustomerInfo("FirstName")) & "</td>" & vbCrLf
                    Response.Write "<td>" & MkPhoneNum(rsCustomerInfo("DayPhone")) & "</td>" & vbCrLf
		            Response.Write "<td>" & MkPhoneNum(rsCustomerInfo("NightPhone")) & "</td>" & vbCrLf
		            Response.Write "<td>" & LCASE(rsCustomerInfo("EMailAddress")) & "</td>" & vbCrLf
		            Response.Write "<td>" & rsSeat("Status") & "</td>" & vbCrLf

		        
                rsCustomerInfo.Close
                Set rsCustomerInfo = nothing
		        
		        
		        If IsNull(rsSeat("SeatTypeCode")) Then
					SeatType = ""
					Price = 0
				Else
					SeatType = rsSeat("SeatType")
					Price = rsSeat("Price") - rsSeat("Discount")
				End If       
		        
		        Response.Write "<td>" & SeatType & "</td>" & vbCrLf
		        Response.Write "<td>" & FormatCurrency(Price,2)  & "</td>" & vbCrLf
		        Response.Write "<td>" & rsSeat("OrderType") & "</td>" & vbCrLf


        'Custom Data Fields  
        '-----------------
                				
					SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & rsSeat("OrderNumber") & " AND LineNumber = " & rsSeat("LineNumber") & " AND FieldName = 'Please select your dinner choice:'"
					Set rsOrderLineDetail = OBJdbConnection.Execute(SQLOrderLineDetail) 

						If NOT rsOrderLineDetail.EOF Then   'pull answer for this order line

							If rsOrderLineDetail("FieldValue") = "" OR rsOrderLineDetail("FieldValue") = "0" Then                
								Response.Write "<td>&nbsp;</td>" & vbCrLf                 
							Else                
								Response.Write "<td>" & (rsOrderLineDetail("FieldValue")) & "</td>" & vbCrLf                        
							End If 
						   
						Else   'no answer found

							Response.Write "<td>&nbsp;</td>" & vbCrLf   

						End If   

					rsOrderLineDetail.Close
					Set rsOrderLineDetail = nothing
				

                
                Response.Write "</tr>" & vbCrLf
                
        rsSeat.MoveNext
        Loop
        
        End If
       
       Response.Write "</table>" & vbCrLf
	
%>


<%
If Excel <> "Y" Then
%>
	<!--#include virtual="FooterInclude.asp"-->
<%
End If
%>

</body>

</html>

<%

End Sub

'=====================================

Function ProperCase(X)
 'Process patron names - take original and output it with first letter of each name capitalised

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
 'Process patron phone numbers - take original and output it in standard phone number format
 
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

%>