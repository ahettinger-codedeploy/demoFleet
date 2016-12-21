<%

'SSR - 6/20/2012 - Updated report for use with UA HRC

'Update Number 13 - 1/20/2012
'SSR 1/20/2012 - Added the patron's email address to the report - SSR

'CHANGE LOG - Inception
'SSR (8/30/2011)
'Custom Survey

%>

<!--#include virtual="GlobalInclude.asp"-->
<!--#include virtual="dbOpenInclude.asp"-->
<!--#include virtual="/include/managementinclude.asp"-->

<%

'============================================================

Page = "Management"
ReportFileName = "SurveyReport.asp"
SurveyReportNumber = 600
ReportTitle = "Survey Report"

'============================================================

'Saugatuck Center for the Arts

'CSS Survey Variables

    TableCategoryBGColor = "#e5c43d"
    TableCategoryFontColor = "#000000"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "#000000"
    TableDataBGColor = "#ffffff"

'============================================================

'Request the form name and process requested action

If Clean(Request("FormName")) = "ReportCriteria" Then
	Call DisplayReport(Request("ReportEventCode"))

ElseIf Clean(Request("FormName")) = "Continue" Then
    Call Continue

Else
    Call SurveyForm
End If


'==========================================================
	
Sub SurveyForm

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

<link href='https://fonts.googleapis.com/css?family=Droid+Sans:400,700' rel='stylesheet' type='text/css'>

<style>
	
html
{
font-family: 'Droid Sans', sans-serif; 
font-size:14px;
color: #555;
line-height:21px;
}

#report
{
margin: auto;
margin-top: 30px;
margin-bottom:20px;
width: 40%;
text-align: center;
border: 1px solid #cbcbcb;
background-color: #fafafa;
-webkit-box-shadow: 0 1px 3px 1px rgba(0,0,0,.05);
box-shadow: 0 1px 3px 1px rgba(0,0,0,.05);
-webkit-border-radius: 5px;
border-radius: 5px;
}
		
#report thead th 
{
padding-left: 10px;
padding-right: 10px;
padding-top: 12px;
padding-bottom: 12px;
white-space: nowrap;
line-height: 27px;
font-size: 15px;
text-align: left;
text-shadow: 0 1px 1px #fff;
	
/* non-css3 browsers */
background: #dddddf;

/* IE */
filter:  progid:DXImageTransform.Microsoft.gradient(startColorstr='#e9eaec', endColorstr='#d4d4d6') !important;

/* Safari, Chrome */
background: -webkit-linear-gradient(top, #e9eaec 0%,#d4d4d6 100%);
-webkit-box-shadow: 0 1px 3px rgba(0, 0, 0, .4);
-webkit-border-top-left-radius:5px;

/* firefox */
background: -moz-linear-gradient(top, #e9eaec 0%,#d4d4d6 100%);
-moz-box-shadow: 0 1px 3px rgba(0, 0, 0, .4);
-moz-border-top-left-radius:5px;
}

#report thead td
{
font-size: 12px;
font-weight: 600;
text-align: left;
padding-left: 10px;
padding-right: 10px;
padding-top: 5px;
padding-bottom: 5px;
border-bottom:  1px solid #e0e0e0;
}

#report tbody tr 
{
white-space: nowrap;
font-size: 12px;
text-align: left;
}

#report tbody tr:nth-child(odd) 
{
background-color: #ededee;
}

#report tbody tr:hover
{
background-color: #EAEEFF;
}

#report tbody td
{
padding-left: 10px;
padding-right: 10px;
padding-top: 5px;
padding-bottom: 5px;
margin: 0;
border-top: 1px solid #fefefe;
border-bottom: 1px solid #e0e0e0;
}
</style>

</head>

<body>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<form action="<%= SurveyFileName %>" method="post" name="Survey">
<input type="hidden" name="FormName" value="ReportCriteria">
	
<% EventListDaysDefault = 30 %>

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


<table border="0" cellpadding="0" cellspacing="0" id="report" width="80%">
	<thead>
		<th colspan="4"><%=ReportTitle%></th>
		<tr>
			<td>&nbsp;</td>
			<td>Date/Time</td>
			<td>Production</td>
			<td>Ticket Count</td>
		</tr>
	</thead>
	<tbody>
<%

SQLEvents = "SELECT Event.EventCode, Act, Venue, EventDate, SurveyNumber FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) ON Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode WHERE EventDate > GETDATE()-" & ArchiveDays & " AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND Event.SurveyNumber = " & SurveyReportNumber & " ORDER BY EventDate, Act"
Set rsEvents = OBJdbConnection.Execute(SQLEvents)

Do Until rsEvents.EOF

    SQLTicketsSold = "SELECT Count(OrderLine.LineNumber) as Count FROM Seat (NOLOCK) INNER JOIN Section (NOLOCK) ON Seat.SectionCode = Section.SectionCode AND Seat.EventCode = Section.EventCode INNER JOIN SeatStatus (NOLOCK) ON Seat.StatusCode = SeatStatus.StatusCode LEFT JOIN OrderLine (NOLOCK) ON Seat.ItemNumber = OrderLine.ItemNumber AND OrderLine.ItemType IN ('Seat', 'SubFixedEvent', 'SubSeat') INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode AND OrganizationVenue.OrganizationNumber = OrganizationAct.OrganizationNumber LEFT JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber LEFT JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode LEFT JOIN OrderType (NOLOCK) ON OrderHeader.OrderTypeNumber = OrderType.OrderTypeNumber WHERE Seat.EventCode = " & rsEvents("EventCode") & "  AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " AND Seat.StatusCode = 'S' "
    Set rsTicketsSold = OBJdbConnection.Execute(SQLTicketsSold)

%>
	<tr>
		<td><INPUT TYPE="radio" NAME="ReportEventCode" VALUE=<%=rsEvents("EventCode")%>></td>
		<td><%=DateAndTimeFormat(rsEvents("EventDate"))%></td>
		<td><%=rsEvents("Act")%></td>
		<td><%=rsTicketsSold("Count")%></td>
	</tr>
<%	

    rsTicketsSold.Close
    Set rsTicketsSold = nothing

rsEvents.MoveNext	
Loop

rsEvents.Close
Set rsEvents = nothing

%>
   
<tr style="background-color: #ffffff;">
    <td align="center" colspan="4">
    <br /><br />
    <INPUT TYPE="checkbox" NAME="ExcelOutput" VALUE="Y">&nbsp;&nbsp;<FONT FACE=verdana,arial,helvetica SIZE=2>Output To Excel</FONT>
    <br /><br />
    <INPUT TYPE="submit" VALUE="Continue"></FORM></td>
</tr>
</tfoot>
</tbody>
</table>

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

Response.Buffer = False
Excel = Clean(Request("ExcelOutput"))

If Excel = "Y" Then

	Response.ContentType = "application/vnd.ms-excel"

End If

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & ReportTitle & "</TITLE>" & vbCrLf

%>


<style>
	
html
{
font-family: 'Droid Sans', sans-serif; 
font-size:14px;
color: #555;
line-height:21px;
}

#report
{
margin: auto;
margin-top: 30px;
margin-bottom:20px;
width: 40%;
text-align: center;
border: 1px solid #cbcbcb;
background-color: #fafafa;
-webkit-box-shadow: 0 1px 3px 1px rgba(0,0,0,.05);
box-shadow: 0 1px 3px 1px rgba(0,0,0,.05);
-webkit-border-radius: 5px;
border-radius: 5px;
}
		
#report thead th 
{
padding-left: 10px;
padding-right: 10px;
padding-top: 12px;
padding-bottom: 12px;
white-space: nowrap;
line-height: 27px;
color: #333;
font-size: 15px;
text-align: left;
text-shadow: 0 1px 1px #fff;
	
/* non-css3 browsers */
background: #dddddf;

/* IE */
filter:  progid:DXImageTransform.Microsoft.gradient(startColorstr='#e9eaec', endColorstr='#d4d4d6') !important;

/* Safari, Chrome */
background: -webkit-linear-gradient(top, #e9eaec 0%,#d4d4d6 100%);
-webkit-box-shadow: 0 1px 3px rgba(0, 0, 0, .4);
-webkit-border-top-left-radius:5px;

/* firefox */
background: -moz-linear-gradient(top, #e9eaec 0%,#d4d4d6 100%);
-moz-box-shadow: 0 1px 3px rgba(0, 0, 0, .4);
-moz-border-top-left-radius:5px;
}

#report thead td
{
color: #000;
font-size: 12px;
font-weight: 400;
text-align: left;
padding-left: 10px;
padding-right: 10px;
padding-top: 5px;
padding-bottom: 5px;
border-bottom:  1px solid #e0e0e0;
}

#report tbody tr 
{
white-space: nowrap;
font-size: 12px;
color: #444;
text-align: left;
}

#report tbody tr:nth-child(odd) 
{
background-color: #ededee;
}

#report tbody tr:hover
{
background-color: #EAEEFF;
}

#report tbody td
{
padding-left: 10px;
padding-right: 10px;
padding-top: 5px;
padding-bottom: 5px;
margin: 0;
border-top: 1px solid #fefefe;
border-bottom: 1px solid #e0e0e0;
}
</style>




<%

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
 
 		 'Survey Number
        SQLSurveyNum = "SELECT SurveyNumber FROM Event (NOLOCK) WHERE Event.EventCode = " & ReportEventCode & ""
        Set rsSurveyNum = OBJdbConnection.Execute(SQLSurveyNum)
            ThisSurveyNum = rsSurveyNum ("SurveyNumber")
        rsSurveyNum.Close
		Set rsSurveyNum = Nothing
		
		'Number of Questions
		SQLMaxQuestions = "SELECT MAX(QuestionNumber) AS Count FROM SurveyQuestion(NOLOCK) WHERE SurveyNumber = " & ThisSurveyNum & ""
        Set rsMaxQuestions = OBJdbConnection.Execute(SQLMaxQuestions)
			ColNbr = rsMaxQuestions("Count") + 10
		    MaxQuestions = rsMaxQuestions("Count")
		rsMaxQuestions.Close
		Set rsMaxQuestions = Nothing
		
		SQLEvent = "SELECT Act, Venue, EventDate, OrganizationVenue.OrganizationNumber FROM Event (NOLOCK) INNER JOIN Act (NOLOCK) on Event.ActCode = Act.ActCode INNER JOIN Venue (NOLOCK) on Event.VenueCode = Venue.VenueCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = Act.ActCode AND OrganizationVenue.OrganizationNumber = OrganizationAct.OrganizationNumber WHERE Event.EventCode = " & ReportEventCode & " AND OrganizationVenue.Owner <> 0"
		Set rsEvent = OBJdbConnection.Execute(SQLEvent)
				ReportTitle2 = "" & rsEvent("Act") & " at " & rsEvent("Venue") & " on " & FormatDateTime(rsEvent("EventDate"), vbShortDate) & " at " & Left(FormatDateTime(rsEvent("EventDate"), vbLongTime), Len(FormatDateTime(rsEvent("EventDate"), vbLongTime))-6) & " " & Right(FormatDateTime(rsEvent("EventDate"),vbLongTime), 2) & ""
		rsEvent.Close
		Set rsEvent = nothing	
		
		'Report Title
		'---------------------
		
		Response.Write "<table border=""0"" cellpadding=""0"" cellspacing=""0"" id=""report"">" & vbCrLf
		Response.Write "<thead>" & vbCrLf
		Response.Write "<tr>" & vbCrLf
		Response.Write "<th colspan=" & ColNbr & ">" & ReportTitle2 & "</th>" & vbCrLf
		Response.Write "</tr>" & vbCrLf
		Response.Write "<tr>" & vbCrLf
				
		'Column Headings
		'----------------
		
        'Standard 
        For j = 1 to UBound(StandardQuestion)
            Response.Write "<td>" & StandardQuestion(j) & "</td>" & vbCrLf
        Next
        
		'Custom
        For k = 1 to MaxQuestions

           SQLSurveyQuestion = "SELECT QuestionText FROM SurveyQuestion(NOLOCK) WHERE SurveyNumber = " & ThisSurveyNum & " AND  SurveyQuestion.QuestionNumber = " & k & ""
           Set rsSurveyQuestion = OBJdbConnection.Execute(SQLSurveyQuestion)
           Response.Write "<td>" & rsSurveyQuestion("QuestionText") & "</td>" & vbCrLf
           rsSurveyQuestion.Close
           Set rsSurveyQuestion = Nothing

        Next
        
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

                SQLMaxQuestions = "SELECT MAX(QuestionNumber) AS Count FROM SurveyQuestion(NOLOCK) WHERE SurveyNumber = " & ThisSurveyNum & ""
                Set rsMaxQuestions = OBJdbConnection.Execute(SQLMaxQuestions)
                MaxQuestions = rsMaxQuestions("Count")
                rsMaxQuestions.Close
                Set rsMaxQuestions = Nothing
                
                For k = 1 to MaxQuestions

                    SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & rsSeat("OrderNumber") & " AND LineNumber = " & rsSeat("LineNumber") & " AND FieldName = 'Answer" & k & "'"
                    Set rsOrderLineDetail = OBJdbConnection.Execute(SQLOrderLineDetail) 
                    
                    If NOT rsOrderLineDetail.EOF Then   
                        
                        If rsOrderLineDetail("FieldValue") = "" OR rsOrderLineDetail("FieldValue") = "0" Then                
                            Response.Write "<td>&nbsp;</td>" & vbCrLf                 
                        Else                
                            Response.Write "<td>" & (rsOrderLineDetail("FieldValue")) & "&nbsp;&nbsp;&nbsp;</td>" & vbCrLf                        
                        End If 
                               
                    Else   
                    
                        Response.Write "<td>&nbsp;</td>" & vbCrLf   
                        
                    End If   
                    
                    rsOrderLineDetail.Close
                    Set rsOrderLineDetail = nothing

                Next
                
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

</BODY>
</HTML>

<%

End Sub

'=====================================

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

%>