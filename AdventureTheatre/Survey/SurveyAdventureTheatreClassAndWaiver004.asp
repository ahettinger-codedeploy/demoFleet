<%

'CHANGE LOG - Inception
'SSR 3/29/2011
'Attendee Survey. 

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->

<%

'========================================

Page = "Survey"
SurveyNumber = 676
SurveyName = "RegistrationSurvey.asp"
BoxOfficeByPass = False

'========================================

'Pratham USA 
'Registration Survey

'Silvia’s Client
'Our friends at Pratham need a survey ASAP.
'If the number of tickets = 1 then the questions are:
'	Is there a team of people you prefer to play with? (Text box)

'	Pick your approximate golf handicap: (Radio button)
'	0-10
'	11-20
'	20-32
'	Beginner

'If the number of tickets > 1 then the questions are:
'	Team Member Name (Text box)
'	Team Member Golf Handicap:
'	0-10
'	11-20
'	20-32
'	Beginner

'Online and offline


'========================================

'Survey Variables

NumQuestions = 4

Dim Question(5)
Question(1) = "Prefered Team?"
Question(2) = "Individual Handicap"

Question(3) = "Team Member Name"
Question(4) = "Team Member Golf Handicap"

'===============================================

'Survey Variables

If Session("UserNumber") <> "" Then
    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "#FFFFFF"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "#000000"
    TableDataBGColor = "#E9E9E9"
End If

'===============================================

'Check to see if Order Number exists.  If not, redirect to Home Page.

If Session("OrderNumber") = "" Then

	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
    Else
		Response.Redirect("/Management/Default.asp")
	End If
	
Else

	If Session("UserNumber") = "" Then
        Page = "Survey"
	Else
	    Page = "Management"
	End If
	
End If

'===============================================

'Survey Start. Request Form name and process requested action

If Clean(Request("FormName")) = "SurveyUpdate" Then
    Call SurveyUpdate
Else
    Call SurveyForm
End If

OBJdbConnection.Close
Set OBJdbConnection = nothing

'===============================================

Sub SurveyForm

'Determine total tickets on order
SQLTotalTickets = "SELECT COUNT(LineNumber) AS TotalTickets FROM OrderLine (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber")
Set rsTotalTickets = OBJdbConnection.Execute(SQLTotalTickets)
TotalTix = CInt(rsTotalTickets("TotalTickets"))
rsTotalTickets.Close
Set rsTotalTickets = Nothing

If TotalTix > 1 Then
    Question1 = "Team Member Name"
    Question2 = "Team Member Golf Handicap"
    
ElseIf TotalTix = 1 Then
    Question1 = "Is there a team of people you prefer to play with?"
    Question2 = "Pick your approximate golf handicap"
End If

Call DisplaySurvey(Question1,Question2)

End Sub

'===============================================

Sub DisplaySurvey(Question1,Question2)

%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>

<title>Attendee Information</title>

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
	width: 400px;
	text-align: left;
	border-collapse: collapse;
}
#rounded-corner thead th.category
{

	color: <%=TableCategoryFontColor%>;
	background: <%=TableCategoryBGColor%>;
}
#rounded-corner thead th.category-left
{
	background: <%=TableCategoryBGColor%> url('/Clients/<%=ClientFolder%>/Survey/Images/nw.gif') left -1px no-repeat;
	text-align: right;
}
#rounded-corner thead th.category-right
{
	background: <%=TableCategoryBGColor%> url('/Clients/<%=ClientFolder%>/Survey/Images/ne.gif') right -1px no-repeat;
    text-align: left;
}
#rounded-corner td.category
{
	padding-top: 5px;
    padding-left: 15px;
	font-size: 15px;
	font-weight: 600;
	color: <%=TableCategoryFontColor%>;
	background: <%=TableCategoryBGColor%>;
}
#rounded-corner td.footer
{
	background: <%=TableDataBGColor%>;
	border-collapse:collapse;
}
#rounded-corner td.footer-left
{
	background: <%=TableDataBGColor%> url('/Clients/<%=ClientFolder%>/Survey/Images/sw.gif') left bottom no-repeat;
	border-collapse:collapse;
}
#rounded-corner td.footer-right
{
	background: <%=TableDataBGColor%> url('/Clients/<%=ClientFolder%>/Survey/Images/se.gif') right bottom no-repeat;
	border-collapse:collapse;
}
#rounded-corner td.data
{
	padding-left: 10px;
	padding-top: 11px;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
	border-collapse:collapse;
}
#rounded-corner td.data-left
{
	padding-top: 15px;
	padding-bottom: 15px;
	padding-right: 10px;
	padding-left: 10px;
	text-align: left;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
	border-collapse:collapse;
}		
#rounded-corner td.data-right
{	
	padding-top: 15px;
	padding-bottom: 15px;
	padding-right: 10px;
	padding-left: 10px;
	text-align: right;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
	border-collapse:collapse;
}


</style>

</head>


<%=strBody %>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<form action="<%= SurveyFileName %>" method="post" name="Survey" >
<input type="hidden" name="FormName" value="SurveyUpdate">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">
<br />
<%

OptionCount = 1

SQLOrderLine = "SELECT OrderLine.LineNumber FROM OrderLine WITH (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " ORDER BY OrderLine.LineNumber"
Set rsOrderLine = OBJdbConnection.Execute(SQLOrderLine)
Do Until rsOrderLine.EOF

%>
    <table id="rounded-corner" summary="surveypage">
    <thead>
	    <tr>
    	    <th scope="col" class="category" colspan="4">&nbsp;</th>
        </tr>        
    </thead>
        <tbody>
	    <tr>
    	    <td class="category" colspan="4">
    	        <b>EVENT REGISTRATION</b><br />
    	        Attendee&nbsp;<%=OptionCount%><br /><br />
    	    </td>
        </tr>
        <tr>
        <tr>
            <td class="data-right" colspan="2" width="60%">
                <%=Question1%>
            </td>
            <td class="data-left" colspan="2">
                <INPUT TYPE="text" NAME="Answer1_<%=OptionCount%>" SIZE="24">
            </td>
        </tr>
        <tr>
    	    <td class="footer" colspan="4">&nbsp;</td>
    	</tr>
        </tbody>
    </table>
 <br />
 <br />
 <br />
<%

OptionCount = OptionCount + 1

rsOrderLine.MoveNext
	
Loop

rsOrderLine.Close
Set rsOrderLine = nothing


%>

<INPUT TYPE="submit" VALUE="Continue"></FORM>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%

End Sub ' SurveyForm

'======================================

Sub SurveyUpdate

If Session("OrderNumber") <> "" Then

    SQLRequiredTicketCount = "SELECT COUNT(OrderLine.ItemNumber) AS Count FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.ItemType = 'Seat'"' GROUP BY Seat.EventCode ORDER BY Seat.EventCode"
    Set rsRequiredTicketCount = OBJdbConnection.Execute(SQLRequiredTicketCount)
        
        If Not rsRequiredTicketCount.EOF Then
            AvailOfferCount = rsRequiredTicketCount("Count")
	    End If
    	
    rsRequiredTicketCount.Close
    Set rsRequiredTicketCount = nothing  
    
    If AvailOfferCount  > 1 Then
        FieldName1 = "TeamMemberName"
        FieldName2 = "TeamMemberGolfHandicap"
        
    ElseIf AvailOfferCount  = 1 Then
        FieldName1 = "PreferedTeamName"
        FieldName2 = "GolfHandicap"
    End If
    

	For i = 1 To AvailOfferCount 
	
        LineNumber = i
               
		'Delete existing Team Member Name record for this line number.
		SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & LineNumber & " AND FieldName = '" & FieldName1 & "'"
		Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)

		'Insert Team Member Name record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", '" & FieldName1 & "', '" & Clean(Request("Answer1_"&i)) & "'  )"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)

		'Delete existing Team Member Golf Handicap record for this line number.
		SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & LineNumber & " AND FieldName = '" & FieldName2 & "'"
		Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)
		
		'Insert Team Member Golf Handicap record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", '" & FieldName2 & "', '" & Clean(Request("Answer2_"&i)) & "'  )"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)
		
    Next

End If	

Call Continue

End Sub 'SurveyUpdate

'======================================

Sub Continue


    Session("SurveyComplete") = Session("OrderNumber")
    If Session("UserNumber") = "" Then
	    Response.Redirect("/Ship.asp")
    Else
	    Response.Redirect("/Management/AdvanceShip.asp")
    End If
    
    
End Sub 'Continue


'======================================

%>