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
<html lang="en">

	<head>

	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta name="description" content="">
	<meta name="author" content="">
	
	<title>Datatables</title>
				
    <!-- Loading Bootstrap -->
	<link href='http://fonts.googleapis.com/css?family=Open+Sans:400,300,300italic,400italic,600,600italic,700,700italic,800,800italic' rel='stylesheet' type='text/css'>
	<link href="http://netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.no-icons.min.css" rel="stylesheet" type="text/css"/>
	<link href="http://netdna.bootstrapcdn.com/font-awesome/3.2.1/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
	
	<style>
	div.dataTables_length label 
	{
	float: left;
	text-align: left;
	}

	div.dataTables_length select 
	{
		width: 75px;
	}

	div.dataTables_filter label 
	{
		float: right;
	}

	div.dataTables_info 
	{
		padding-top: 26px;
	}

	div.dataTables_paginate 
	{
		float: right;
		margin: 0;
	}

	table.table 
	{
		clear: both;
		margin-bottom: 6px !important;
		max-width: none !important;
	}

	table.table thead .sorting,
	table.table thead .sorting_asc,
	table.table thead .sorting_desc,
	table.table thead .sorting_asc_disabled,
	table.table thead .sorting_desc_disabled 
	{
		cursor: pointer;
		*cursor: hand;
	}

	table.table thead .sorting { background: url('../images/sort_both.png') no-repeat center right; }
	table.table thead .sorting_asc { background: url('../images/sort_asc.png') no-repeat center right; }
	table.table thead .sorting_desc { background: url('../images/sort_desc.png') no-repeat center right; }

	table.table thead .sorting_asc_disabled { background: url('../images/sort_asc_disabled.png') no-repeat center right; }
	table.table thead .sorting_desc_disabled { background: url('../images/sort_desc_disabled.png') no-repeat center right; }

	table.dataTable th:active 
	{
		outline: none;
	}

	/* Scrolling */
	div.dataTables_scrollHead table 
	{
		margin-bottom: 0 !important;
		border-bottom-left-radius: 0;
		border-bottom-right-radius: 0;
	}

	div.dataTables_scrollHead table thead tr:last-child th:first-child,
	div.dataTables_scrollHead table thead tr:last-child td:first-child {
		border-bottom-left-radius: 0 !important;
		border-bottom-right-radius: 0 !important;
	}

	div.dataTables_scrollBody table 
	{
		border-top: none;
		margin-bottom: 0 !important;
	}

	div.dataTables_scrollBody tbody tr:first-child th,
	div.dataTables_scrollBody tbody tr:first-child td {
		border-top: none;
	}

	div.dataTables_scrollFoot table 
	{
		border-top: none;
	}




	/*
	 * TableTools styles
	 */
	.table tbody tr.active td,
	.table tbody tr.active th 
	{
		background-color: #08C;
		color: white;
	}

	.table tbody tr.active:hover td,
	.table tbody tr.active:hover th 
	{
		background-color: #0075b0 !important;
	}

	.table-striped tbody tr.active:nth-child(odd) td,
	.table-striped tbody tr.active:nth-child(odd) th 
	{
		background-color: #017ebc;
	}

	table.DTTT_selectable tbody tr 
	{
		cursor: pointer;
		*cursor: hand;
	}

	div.DTTT .btn {
		color: #333 !important;
		font-size: 12px;
	}

	div.DTTT .btn:hover 
	{
		text-decoration: none !important;
	}


	ul.DTTT_dropdown.dropdown-menu a 
	{
		color: #333 !important; /* needed only when demo_page.css is included */
	}

	ul.DTTT_dropdown.dropdown-menu li:hover a 
	{
		background-color: #0088cc;
		color: white !important;
	}

	/* TableTools information display */
	div.DTTT_print_info.modal 
	{
		height: 150px;
		margin-top: -75px;
		text-align: center;
	}

	div.DTTT_print_info h6 
	{
		font-weight: normal;
		font-size: 28px;
		line-height: 28px;
		margin: 1em;
	}

	div.DTTT_print_info p 
	{
		font-size: 14px;
		line-height: 20px;
	}



	/*
	 * FixedColumns styles
	 */
	div.DTFC_LeftHeadWrapper table,
	div.DTFC_LeftFootWrapper table,
	table.DTFC_Cloned tr.even 
	{
		background-color: white;
	}

	div.DTFC_LeftHeadWrapper table 
	{
		margin-bottom: 0 !important;
		border-top-right-radius: 0 !important;
		border-bottom-left-radius: 0 !important;
		border-bottom-right-radius: 0 !important;
	}

	div.DTFC_LeftHeadWrapper table thead tr:last-child th:first-child,
	div.DTFC_LeftHeadWrapper table thead tr:last-child td:first-child 
	{
		border-bottom-left-radius: 0 !important;
		border-bottom-right-radius: 0 !important;
	}

	div.DTFC_LeftBodyWrapper table 
	{
		border-top: none;
		margin-bottom: 0 !important;
	}

	div.DTFC_LeftBodyWrapper tbody tr:first-child th,
	div.DTFC_LeftBodyWrapper tbody tr:first-child td 
	{
		border-top: none;
	}

	div.DTFC_LeftFootWrapper table 
	{
		border-top: none;
	}
	</style>
	
	<style>
	div.dataTables_length label { float: left; text-align: left; }  div.dataTables_length select { width: 75px; }  div.dataTables_filter label { float: right; }  div.dataTables_info { padding-top: 26px; }  div.dataTables_paginate { float: right; margin: 0; }  table.table { clear: both; margin-bottom: 6px !important; max-width: none !important; }  table.table thead .sorting, table.table thead .sorting_asc, table.table thead .sorting_desc, table.table thead .sorting_asc_disabled, table.table thead .sorting_desc_disabled { cursor: pointer; *cursor: hand; }  table.table thead .sorting { background: url('http://datatables.net/media/blog/bootstrap_2/images/sort_both.png') no-repeat center right; } table.table thead .sorting_asc { background: url('http://datatables.net/media/blog/bootstrap_2/images/sort_asc.png') no-repeat center right; } table.table thead .sorting_desc { background: url('http://datatables.net/media/blog/bootstrap_2/images/sort_desc.png') no-repeat center right; }  table.table thead .sorting_asc_disabled { background: url('http://datatables.net/media/blog/bootstrap_2/images/sort_asc_disabled.png') no-repeat center right; } table.table thead .sorting_desc_disabled { background: url('http://datatables.net/media/blog/bootstrap_2/images/sort_desc_disabled.png') no-repeat center right; }  table.dataTable th:active { outline: none; }  /* Scrolling */ div.dataTables_scrollHead table { margin-bottom: 0 !important; border-bottom-left-radius: 0; border-bottom-right-radius: 0; }  div.dataTables_scrollHead table thead tr:last-child th:first-child, div.dataTables_scrollHead table thead tr:last-child td:first-child { border-bottom-left-radius: 0 !important; border-bottom-right-radius: 0 !important; }  div.dataTables_scrollBody table { border-top: none; margin-bottom: 0 !important; }  div.dataTables_scrollBody tbody tr:first-child th, div.dataTables_scrollBody tbody tr:first-child td { border-top: none; }  div.dataTables_scrollFoot table { border-top: none; }     /* * TableTools styles */ .table tbody tr.active td, .table tbody tr.active th { background-color: #08C; color: white; }  .table tbody tr.active:hover td, .table tbody tr.active:hover th { background-color: #0075b0 !important; }  .table-striped tbody tr.active:nth-child(odd) td, .table-striped tbody tr.active:nth-child(odd) th { background-color: #017ebc; }  table.DTTT_selectable tbody tr { cursor: pointer; *cursor: hand; }  div.DTTT .btn { color: #333 !important; font-size: 12px; }  div.DTTT .btn:hover { text-decoration: none !important; }   ul.DTTT_dropdown.dropdown-menu a { color: #333 !important; /* needed only when demo_page.css is included */ }  ul.DTTT_dropdown.dropdown-menu li:hover a { background-color: #0088cc; color: white !important; }  /* TableTools information display */ div.DTTT_print_info.modal { height: 150px; margin-top: -75px; text-align: center; }  div.DTTT_print_info h6 { font-weight: normal; font-size: 28px; line-height: 28px; margin: 1em; }  div.DTTT_print_info p { font-size: 14px; line-height: 20px; }    /* * FixedColumns styles */ div.DTFC_LeftHeadWrapper table, div.DTFC_LeftFootWrapper table, table.DTFC_Cloned tr.even { background-color: white; }  div.DTFC_LeftHeadWrapper table { margin-bottom: 0 !important; border-top-right-radius: 0 !important; border-bottom-left-radius: 0 !important; border-bottom-right-radius: 0 !important; }  div.DTFC_LeftHeadWrapper table thead tr:last-child th:first-child, div.DTFC_LeftHeadWrapper table thead tr:last-child td:first-child { border-bottom-left-radius: 0 !important; border-bottom-right-radius: 0 !important; }  div.DTFC_LeftBodyWrapper table { border-top: none; margin-bottom: 0 !important; }  div.DTFC_LeftBodyWrapper tbody tr:first-child th, div.DTFC_LeftBodyWrapper tbody tr:first-child td { border-top: none; }  div.DTFC_LeftFootWrapper table { border-top: none; }
	</style>
	
	<style>
	 body {font-family: "Segoe UI","Open Sans","Helvetica Neue",Helvetica,Arial,sans-serif; font-weight: 400; font-size:15px; line-height:1.428571429; color:#2c3e50;background-color:#fff}
	.main { margin-top:50px; }
	.container, section, div.container, div.section { width: 970px; text-align: left; }
	.container a { text-decoration: none;}
	h1, h2, h3, h4, h5, h6, .h1, .h2, .h3, .h4, .h5, .h6 {font-family: "Segoe UI","Open Sans","Helvetica Neue",Helvetica,Arial,sans-serif; font-weight: 400;}
	</style>

	<style>
	body .dataTables_wrapper { background: none repeat scroll 0% 0% rgb(238, 238, 238); }
	body .dataTables_wrapper .dataTables_length { float: left; margin: 15px 20px 10px; }
	body .dataTables_wrapper .dataTables_length select { margin: 0px; }
	body .dataTables_wrapper .dataTables_filter { float: right; margin: 15px 20px 10px; }
	body .dataTables_wrapper .dataTables_filter label input[type="text"] { box-shadow: none; padding: 5px 10px; font-family: 'Roboto',Helvetica,sans-serif; font-weight: 300; margin: 0px; }
	body .dataTables_wrapper .dataTables_filter label input[type="text"]:focus { border-color: rgb(51, 51, 51); }
	body .dataTables_wrapper table.dataTable { background: none repeat scroll 0% 0% rgb(255, 255, 255); margin: 0px; clear: both; }
	body .dataTables_wrapper table.dataTable thead th { background: none repeat scroll 0% 0% rgb(51, 51, 51); color: rgb(204, 204, 204); border: 0; }
	body .dataTables_wrapper table.dataTable thead th.sorting { cursor: pointer; }
	body .dataTables_wrapper table.dataTable thead th.sorting_desc, body .dataTables_wrapper table.dataTable thead th.sorting_asc { background: none repeat scroll 0% 0% rgb(0, 132, 0); cursor: pointer; color: rgb(255, 255, 255); }
    body .dataTables_wrapper table.dataTable tbody tr td  {border-top: 1px solid #DDDDDD; border-left:0; border-right: 0; line-height: 20px; padding: 8px; text-align: left;  vertical-align: top;}
	body .dataTables_wrapper .dataTables_info { float: left; margin: 10px 20px; }
	body .dataTables_wrapper .dataTables_paginate { float: right; margin: 10px 20px; }
	body .dataTables_wrapper .dataTables_paginate .paginate_disabled_previous, body .dataTables_wrapper .dataTables_paginate .paginate_disabled_next { padding: 5px 10px; background: none repeat scroll 0% 0% rgb(51, 51, 51); color: rgb(255, 255, 255); display: inline-block; }
	body .dataTables_wrapper .dataTables_paginate .paginate_disabled_previous:hover, body .dataTables_wrapper .dataTables_paginate .paginate_disabled_next:hover { text-decoration: none; }
	body .dataTables_wrapper .dataTables_paginate .paginate_enabled_previous, body .dataTables_wrapper .dataTables_paginate .paginate_enabled_next { padding: 5px 10px; background: none repeat scroll 0% 0% rgb(0, 132, 0); color: rgb(255, 255, 255); display: inline-block; cursor: pointer; }
	body .dataTables_wrapper .dataTables_paginate .paginate_enabled_previous:hover, body .dataTables_wrapper .dataTables_paginate .paginate_enabled_next:hover { text-decoration: none; }
	body .dataTables_wrapper:after { content: "."; display: block; clear: both; visibility: hidden; line-height: 0; height: 0px; }

	
	.pagination > .active > a, .pagination > .active > span, .pagination > .active > a:hover, .pagination > .active > span:hover, .pagination > .active > a:focus, .pagination > .active > span:focus 
	{
		background-color: rgb(51, 51, 51);
		border-color: #428BCA;
		color: #FFFFFF;
		cursor: default;
		z-index: 2;
	}
	
	.pagination > li > a, .pagination > li > span 
	{
		background-color: #FFFFFF;
		border: 1px solid rgb(51, 51, 51);
		float: left;
		line-height: 1.42857;
		margin-left: -1px;
		padding: 6px 12px;
		position: relative;
		text-decoration: none;
	}
	</style>

	<script src="http://ajax.aspnetcdn.com/ajax/jquery.dataTables/1.8.2/jquery.dataTables.min.js" type="text/javascript" charset="utf8" ></script>

</head>

<body>

					<div class="panel panel-default">
					
						<div class="panel-heading">
					   
							<span class="panel-title">
							TICKET SALES
							</span>

						</div>
						
						<div class="panel-edit" id="panel-edit">
												
							<div id="panel-content">
					
								
			 
							</div>
						
						</div>
						
						<div class="panel-body">

							<form action="<%= SurveyFileName %>" method="post" name="Survey">

							<input type="hidden" name="FormName" value="ReportCriteria">
							
<%

SQLSurveyList = "SELECT Event.EventDate, Event.EventCode, Act.Act FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode WHERE Event.EventCode IN (584896,589274,678679,743505,743506)"
Set rsSurveyList = OBJdbConnection.Execute(SQLSurveyList)

If Not rsSurveyList.EOF Then

			%>
															
			<table cellpadding="0" cellspacing="0" border="0" class="datatable table table-striped table-bordered table-hover">
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
				
			</div>
			

<INPUT TYPE="checkbox" NAME="ExcelOutput" VALUE="Y">&nbsp;&nbsp;<FONT FACE=verdana,arial,helvetica SIZE=2>Output To Excel</FONT>

<br />
<br />

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
	Case 743505 
		ThisDiscountNumber = 109010
		SeriesCount = 6
		SeriesName = "Flex Subscription"
	Case 743506
		ThisDiscountNumber = 109010
		SeriesCount = 4
		SeriesName = "Season Subscription"
End Select

Dim SeriesSeatType(1)
SeriesSeatType(1) = 16 'Individual


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
<html lang="en">

	<head>

	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta name="description" content="">
	<meta name="author" content="">
	
	<title>Datatables</title>
				
    <!-- Loading Bootstrap -->
	<link href='http://fonts.googleapis.com/css?family=Open+Sans:400,300,300italic,400italic,600,600italic,700,700italic,800,800italic' rel='stylesheet' type='text/css'>
	<link href="http://netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.no-icons.min.css" rel="stylesheet" type="text/css"/>
	<link href="http://netdna.bootstrapcdn.com/font-awesome/3.2.1/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
	
	<style>
	div.dataTables_length label 
	{
	float: left;
	text-align: left;
	}

	div.dataTables_length select 
	{
		width: 75px;
	}

	div.dataTables_filter label 
	{
		float: right;
	}

	div.dataTables_info 
	{
		padding-top: 26px;
	}

	div.dataTables_paginate 
	{
		float: right;
		margin: 0;
	}

	table.table 
	{
		clear: both;
		margin-bottom: 6px !important;
		max-width: none !important;
	}

	table.table thead .sorting,
	table.table thead .sorting_asc,
	table.table thead .sorting_desc,
	table.table thead .sorting_asc_disabled,
	table.table thead .sorting_desc_disabled 
	{
		cursor: pointer;
		*cursor: hand;
	}

	table.table thead .sorting { background: url('../images/sort_both.png') no-repeat center right; }
	table.table thead .sorting_asc { background: url('../images/sort_asc.png') no-repeat center right; }
	table.table thead .sorting_desc { background: url('../images/sort_desc.png') no-repeat center right; }

	table.table thead .sorting_asc_disabled { background: url('../images/sort_asc_disabled.png') no-repeat center right; }
	table.table thead .sorting_desc_disabled { background: url('../images/sort_desc_disabled.png') no-repeat center right; }

	table.dataTable th:active 
	{
		outline: none;
	}

	/* Scrolling */
	div.dataTables_scrollHead table 
	{
		margin-bottom: 0 !important;
		border-bottom-left-radius: 0;
		border-bottom-right-radius: 0;
	}

	div.dataTables_scrollHead table thead tr:last-child th:first-child,
	div.dataTables_scrollHead table thead tr:last-child td:first-child {
		border-bottom-left-radius: 0 !important;
		border-bottom-right-radius: 0 !important;
	}

	div.dataTables_scrollBody table 
	{
		border-top: none;
		margin-bottom: 0 !important;
	}

	div.dataTables_scrollBody tbody tr:first-child th,
	div.dataTables_scrollBody tbody tr:first-child td {
		border-top: none;
	}

	div.dataTables_scrollFoot table 
	{
		border-top: none;
	}




	/*
	 * TableTools styles
	 */
	.table tbody tr.active td,
	.table tbody tr.active th 
	{
		background-color: #08C;
		color: white;
	}

	.table tbody tr.active:hover td,
	.table tbody tr.active:hover th 
	{
		background-color: #0075b0 !important;
	}

	.table-striped tbody tr.active:nth-child(odd) td,
	.table-striped tbody tr.active:nth-child(odd) th 
	{
		background-color: #017ebc;
	}

	table.DTTT_selectable tbody tr 
	{
		cursor: pointer;
		*cursor: hand;
	}

	div.DTTT .btn {
		color: #333 !important;
		font-size: 12px;
	}

	div.DTTT .btn:hover 
	{
		text-decoration: none !important;
	}


	ul.DTTT_dropdown.dropdown-menu a 
	{
		color: #333 !important; /* needed only when demo_page.css is included */
	}

	ul.DTTT_dropdown.dropdown-menu li:hover a 
	{
		background-color: #0088cc;
		color: white !important;
	}

	/* TableTools information display */
	div.DTTT_print_info.modal 
	{
		height: 150px;
		margin-top: -75px;
		text-align: center;
	}

	div.DTTT_print_info h6 
	{
		font-weight: normal;
		font-size: 28px;
		line-height: 28px;
		margin: 1em;
	}

	div.DTTT_print_info p 
	{
		font-size: 14px;
		line-height: 20px;
	}



	/*
	 * FixedColumns styles
	 */
	div.DTFC_LeftHeadWrapper table,
	div.DTFC_LeftFootWrapper table,
	table.DTFC_Cloned tr.even 
	{
		background-color: white;
	}

	div.DTFC_LeftHeadWrapper table 
	{
		margin-bottom: 0 !important;
		border-top-right-radius: 0 !important;
		border-bottom-left-radius: 0 !important;
		border-bottom-right-radius: 0 !important;
	}

	div.DTFC_LeftHeadWrapper table thead tr:last-child th:first-child,
	div.DTFC_LeftHeadWrapper table thead tr:last-child td:first-child 
	{
		border-bottom-left-radius: 0 !important;
		border-bottom-right-radius: 0 !important;
	}

	div.DTFC_LeftBodyWrapper table 
	{
		border-top: none;
		margin-bottom: 0 !important;
	}

	div.DTFC_LeftBodyWrapper tbody tr:first-child th,
	div.DTFC_LeftBodyWrapper tbody tr:first-child td 
	{
		border-top: none;
	}

	div.DTFC_LeftFootWrapper table 
	{
		border-top: none;
	}
	</style>
	
	<style>
	div.dataTables_length label { float: left; text-align: left; }  div.dataTables_length select { width: 75px; }  div.dataTables_filter label { float: right; }  div.dataTables_info { padding-top: 26px; }  div.dataTables_paginate { float: right; margin: 0; }  table.table { clear: both; margin-bottom: 6px !important; max-width: none !important; }  table.table thead .sorting, table.table thead .sorting_asc, table.table thead .sorting_desc, table.table thead .sorting_asc_disabled, table.table thead .sorting_desc_disabled { cursor: pointer; *cursor: hand; }  table.table thead .sorting { background: url('http://datatables.net/media/blog/bootstrap_2/images/sort_both.png') no-repeat center right; } table.table thead .sorting_asc { background: url('http://datatables.net/media/blog/bootstrap_2/images/sort_asc.png') no-repeat center right; } table.table thead .sorting_desc { background: url('http://datatables.net/media/blog/bootstrap_2/images/sort_desc.png') no-repeat center right; }  table.table thead .sorting_asc_disabled { background: url('http://datatables.net/media/blog/bootstrap_2/images/sort_asc_disabled.png') no-repeat center right; } table.table thead .sorting_desc_disabled { background: url('http://datatables.net/media/blog/bootstrap_2/images/sort_desc_disabled.png') no-repeat center right; }  table.dataTable th:active { outline: none; }  /* Scrolling */ div.dataTables_scrollHead table { margin-bottom: 0 !important; border-bottom-left-radius: 0; border-bottom-right-radius: 0; }  div.dataTables_scrollHead table thead tr:last-child th:first-child, div.dataTables_scrollHead table thead tr:last-child td:first-child { border-bottom-left-radius: 0 !important; border-bottom-right-radius: 0 !important; }  div.dataTables_scrollBody table { border-top: none; margin-bottom: 0 !important; }  div.dataTables_scrollBody tbody tr:first-child th, div.dataTables_scrollBody tbody tr:first-child td { border-top: none; }  div.dataTables_scrollFoot table { border-top: none; }     /* * TableTools styles */ .table tbody tr.active td, .table tbody tr.active th { background-color: #08C; color: white; }  .table tbody tr.active:hover td, .table tbody tr.active:hover th { background-color: #0075b0 !important; }  .table-striped tbody tr.active:nth-child(odd) td, .table-striped tbody tr.active:nth-child(odd) th { background-color: #017ebc; }  table.DTTT_selectable tbody tr { cursor: pointer; *cursor: hand; }  div.DTTT .btn { color: #333 !important; font-size: 12px; }  div.DTTT .btn:hover { text-decoration: none !important; }   ul.DTTT_dropdown.dropdown-menu a { color: #333 !important; /* needed only when demo_page.css is included */ }  ul.DTTT_dropdown.dropdown-menu li:hover a { background-color: #0088cc; color: white !important; }  /* TableTools information display */ div.DTTT_print_info.modal { height: 150px; margin-top: -75px; text-align: center; }  div.DTTT_print_info h6 { font-weight: normal; font-size: 28px; line-height: 28px; margin: 1em; }  div.DTTT_print_info p { font-size: 14px; line-height: 20px; }    /* * FixedColumns styles */ div.DTFC_LeftHeadWrapper table, div.DTFC_LeftFootWrapper table, table.DTFC_Cloned tr.even { background-color: white; }  div.DTFC_LeftHeadWrapper table { margin-bottom: 0 !important; border-top-right-radius: 0 !important; border-bottom-left-radius: 0 !important; border-bottom-right-radius: 0 !important; }  div.DTFC_LeftHeadWrapper table thead tr:last-child th:first-child, div.DTFC_LeftHeadWrapper table thead tr:last-child td:first-child { border-bottom-left-radius: 0 !important; border-bottom-right-radius: 0 !important; }  div.DTFC_LeftBodyWrapper table { border-top: none; margin-bottom: 0 !important; }  div.DTFC_LeftBodyWrapper tbody tr:first-child th, div.DTFC_LeftBodyWrapper tbody tr:first-child td { border-top: none; }  div.DTFC_LeftFootWrapper table { border-top: none; }
	</style>
	
	<style>
	 body {font-family: "Segoe UI","Open Sans","Helvetica Neue",Helvetica,Arial,sans-serif; font-weight: 400; font-size:15px; line-height:1.428571429; color:#2c3e50;background-color:#fff}
	.main { margin-top:50px; }
	.container, section, div.container, div.section { width: 970px; text-align: left; }
	.container a { text-decoration: none;}
	h1, h2, h3, h4, h5, h6, .h1, .h2, .h3, .h4, .h5, .h6 {font-family: "Segoe UI","Open Sans","Helvetica Neue",Helvetica,Arial,sans-serif; font-weight: 400;}
	</style>

	<style>
	body .dataTables_wrapper { background: none repeat scroll 0% 0% rgb(238, 238, 238); }
	body .dataTables_wrapper .dataTables_length { float: left; margin: 15px 20px 10px; }
	body .dataTables_wrapper .dataTables_length select { margin: 0px; }
	body .dataTables_wrapper .dataTables_filter { float: right; margin: 15px 20px 10px; }
	body .dataTables_wrapper .dataTables_filter label input[type="text"] { box-shadow: none; padding: 5px 10px; font-family: 'Roboto',Helvetica,sans-serif; font-weight: 300; margin: 0px; }
	body .dataTables_wrapper .dataTables_filter label input[type="text"]:focus { border-color: rgb(51, 51, 51); }
	body .dataTables_wrapper table.dataTable { background: none repeat scroll 0% 0% rgb(255, 255, 255); margin: 0px; clear: both; }
	body .dataTables_wrapper table.dataTable thead th { background: none repeat scroll 0% 0% rgb(51, 51, 51); color: rgb(204, 204, 204); border: 0; }
	body .dataTables_wrapper table.dataTable thead th.sorting { cursor: pointer; }
	body .dataTables_wrapper table.dataTable thead th.sorting_desc, body .dataTables_wrapper table.dataTable thead th.sorting_asc { background: none repeat scroll 0% 0% rgb(0, 132, 0); cursor: pointer; color: rgb(255, 255, 255); }
    body .dataTables_wrapper table.dataTable tbody tr td  {border-top: 1px solid #DDDDDD; border-left:0; border-right: 0; line-height: 20px; padding: 8px; text-align: left;  vertical-align: top;}
	body .dataTables_wrapper .dataTables_info { float: left; margin: 10px 20px; }
	body .dataTables_wrapper .dataTables_paginate { float: right; margin: 10px 20px; }
	body .dataTables_wrapper .dataTables_paginate .paginate_disabled_previous, body .dataTables_wrapper .dataTables_paginate .paginate_disabled_next { padding: 5px 10px; background: none repeat scroll 0% 0% rgb(51, 51, 51); color: rgb(255, 255, 255); display: inline-block; }
	body .dataTables_wrapper .dataTables_paginate .paginate_disabled_previous:hover, body .dataTables_wrapper .dataTables_paginate .paginate_disabled_next:hover { text-decoration: none; }
	body .dataTables_wrapper .dataTables_paginate .paginate_enabled_previous, body .dataTables_wrapper .dataTables_paginate .paginate_enabled_next { padding: 5px 10px; background: none repeat scroll 0% 0% rgb(0, 132, 0); color: rgb(255, 255, 255); display: inline-block; cursor: pointer; }
	body .dataTables_wrapper .dataTables_paginate .paginate_enabled_previous:hover, body .dataTables_wrapper .dataTables_paginate .paginate_enabled_next:hover { text-decoration: none; }
	body .dataTables_wrapper:after { content: "."; display: block; clear: both; visibility: hidden; line-height: 0; height: 0px; }

	
	.pagination > .active > a, .pagination > .active > span, .pagination > .active > a:hover, .pagination > .active > span:hover, .pagination > .active > a:focus, .pagination > .active > span:focus 
	{
		background-color: rgb(51, 51, 51);
		border-color: #428BCA;
		color: #FFFFFF;
		cursor: default;
		z-index: 2;
	}
	
	.pagination > li > a, .pagination > li > span 
	{
		background-color: #FFFFFF;
		border: 1px solid rgb(51, 51, 51);
		float: left;
		line-height: 1.42857;
		margin-left: -1px;
		padding: 6px 12px;
		position: relative;
		text-decoration: none;
	}
	</style>

	<script src="http://ajax.aspnetcdn.com/ajax/jquery.dataTables/1.8.2/jquery.dataTables.min.js" type="text/javascript" charset="utf8" ></script>

</head>
	
<body BGCOLOR="#FFFFFF">
	
<!--#INCLUDE VIRTUAL="TopNavInclude.asp" -->

	<div class="panel panel-default">
	
		<div class="panel-heading">
	   
			<span class="panel-title">
			<%= ReportTitle %>
			</span>

		</div>
		
		<div class="panel-edit" id="panel-edit">
								
			<div id="panel-content">
	
				

			</div>
		
		</div>
		
		<div class="panel-body">
		
			<form action="<%= SurveyFileName %>" method="post" name="Survey">

			<input type="hidden" name="FormName" value="ReportCriteria">
		
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
			<td><%=SeriesCount%></td>
<%			
			
			'Total number of allowed discounted tickets
			'------------------------------------------------------
			TotalPackageCount = ( TicketCount * SeriesCount)
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

</div>

</div>
	


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


