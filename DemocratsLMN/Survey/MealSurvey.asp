<%

'CHANGE LOG - Update
'SSR (9/6/2011)
'Updated with Answer1, Answer2 for field names to make this a more flexible template

'CHANGE LOG - Update
'SSR (7/6/2011)
'Made all answers required

'CHANGE LOG - Inception
'SSR 4/1/2011
'Meal Selection Survey. 


%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'===============================================

Page = "Survey"
SurveyNumber = 997
SurveyFileName = "MealSurvey.asp"


'===============================================

'Democratic Committee of Lower Merion & Narberth
'Simple, simple

'One question:
'What is the meal preference for all of those attending?"

'Answers:
'- Chicken
'- Fish
'- Vegetarian

'Radio buttons - answer required

'1-for-1

'The custom survey report is already in place.

FormName = "Attendee Information"
FormHeader = "Please complete the following information for each attendee"
DinnerLabel = "please select your meal options:"
Message = ""

DinnerSubCount = "False" 'True dinners are numbered per ticket / False dinners are numbered per order

Dim Question(2)
NumQuestions = 1
Question(1) = "Meal"

DIM SurveyField(1,3)
SurveyField(1,0) = "Please Select An Option"
SurveyField(1,1) = "Chicken"
SurveyField(1,2) = "Fish"
SurveyField(1,3) = "Vegetarian"

PatronCount = 0 'Number of tickets on this order
OrderTotal = 0 'Total number of dinners on this order


'===============================================

'CSS Survey Variables

If Session("UserNumber")<> "" Then
    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "#FFFFFF"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "#000000"
    TableDataBGColor = "#E9E9E9"
End If

'LastHex = box color
'FirstHex = background color

If Session("UserNumber")<> "" Then
    NECorner="/clients/tix/images/image.asp?FirstHex=efebe3&LastHex=008400&Src=TopLeftCorner16.txt"
    NWCorner="/clients/tix/images/image.asp?FirstHex=efebe3&LastHex=008400&Src=TopRightCorner16.txt"
    SWCorner="/clients/tix/images/image.asp?FirstHex=f3f1ed&LastHex=E9E9E9&Src=BottomLeftCorner16.txt"
    SECorner="/clients/tix/images/image.asp?FirstHex=f3f1ed&LastHex=E9E9E9&Src=BottomRightCorner16.txt"
Else
    NECorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=000000&Src=TopLeftCorner16.txt"
    NWCorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=000000&Src=TopRightCorner16.txt"
    SWCorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=f1f1f1&Src=BottomLeftCorner16.txt"
    SECorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=f1f1f1&Src=BottomRightCorner16.txt"
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


'Request the form name and process requested action

 Select Case Clean(Request("FormName"))
    Case "SurveyUpdate"
        Call SurveyUpdate
    Case Else
        Call SurveyDisplay(Message)  
 End Select

'==========================================================

Sub SurveyDisplay(Message)  

If DocType <> "" Then
    Response.Write(DocType)
Else
    Response.Write("<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">")
End If

%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<html>
<head>

<title>Survey Page</title>

<style type="text/css">
body
{
line-height: 1 em;
}
#rounded-corner
{
	font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
	font-size: 14px;
	font-weight: 400;
	width: 550px;
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
	padding-left: 20px;
	padding-right: 20px;
	padding-bottom: 5px;
	font-size: 15px;
	font-weight: 600;
	color: <%=TableCategoryFontColor%>;
	background: <%=TableCategoryBGColor%>;
}
#rounded-corner td.footer
{
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.footer-left
{
	background: <%=TableDataBGColor%> url('/Clients/<%=ClientFolder%>/Survey/Images/sw.gif') left bottom no-repeat;
}
#rounded-corner td.footer-right
{
	background: <%=TableDataBGColor%> url('/Clients/<%=ClientFolder%>/Survey/Images/se.gif') right bottom no-repeat;
}

#rounded-corner td.data-option
{
	line-height: 3em;
    padding-top: 0px;
	padding-left: 20px;
	padding-right: 20px;
	padding-bottom: 0px;
	font-weight: normal;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}	

label.error 
{ 
float: none; color: red; padding-left: .5em; vertical-align: top; 
}	
</style>

<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.1/jquery.js"></script>	
	
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.0/jquery-ui.min.js"></script>

<script type="text/javascript" src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.9/jquery.validate.js"></script>

<script type="text/javascript">
    $(document).ready(function () {
        $("#SurveyForm").validate();
    });
</script>

</head>

<% If Message = "" Then %>
    <body>
<% Else %>
	<body onLoad="alert('<%= Message %>');" <%= BodyParameters %>>
<% End If %>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<form action="<%= SurveyFileName %>" name="Survey" id="SurveyForm" method="post">
<input type="hidden" name="FormName" value="SurveyUpdate">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">

<%
    
SQLDinnerOptions = "SELECT OrderLine.LineNumber, OrderLine.SeatTypeCode, SeatType FROM OrderLine (NOLOCK) INNER JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode WHERE OrderNumber = " & Session("OrderNumber") & " ORDER BY OrderLine.LineNumber"
Set rsDinnerOptions = OBJdbConnection.Execute(SQLDinnerOptions)   
 
Do While Not rsDinnerOptions.EOF

PatronCount = PatronCount + 1

Select Case rsDinnerOptions("SeatTypeCode")
    Case 219 'Dinner for one
        DinnerTotal = 1
        DinnerLabel = "Please select your meal option:"
    Case 6578 'Dinner for two
        DinnerTotal = 2
        DinnerLabel = "Please select your two meal options:"
    Case 6579 'Dinner for two
        DinnerTotal = 2
        DinnerLabel = "Please select your two meal options:"
    Case 6580 'Dinner for eight
        DinnerTotal = 8
        DinnerLabel = "Please select your eight meal options:"
End Select

OrderTotal = OrderTotal + DinnerTotal


%>

<table id="rounded-corner" summary="surveypage">
<thead>
    <tr>
        <td class="category" colspan="4">
        PATRON <%= PatronCount %> - <%= rsDinnerOptions("SeatType") %>
        </td>
    </tr>     
</thead>
    <tbody>
        <tr>
            <td class="data-option" colspan="4">
                <i><%= DinnerLabel %></i>
            </td>
        </tr>
    
    <%

        If DinnerSubCount Then
            DinnerCount = 0
        End if

        For i = 1 to DinnerTotal
        DinnerCount = DinnerCount + 1
        %>
        <tr>
            <td class="data-option" colspan="4">
                 MEAL <%= DinnerCount %>:&nbsp;
                    <select id="Answer<%= DinnerCount %>" name="Answer<%= DinnerCount %>" class="required">
                    <OPTION VALUE="">&nbsp;<%= SurveyField(1, 0) %></OPTION><BR>
	                <OPTION VALUE="<%= SurveyField(1, 1) %>">&nbsp;<%= SurveyField(1, 1) %></OPTION><BR>
	                <OPTION VALUE="<%= SurveyField(1, 2) %>">&nbsp;<%= SurveyField(1, 2) %></OPTION><BR>
	                <OPTION VALUE="<%= SurveyField(1, 3) %>">&nbsp;<%= SurveyField(1, 3) %></OPTION><BR>
	             </SELECT>
            </td>
        </tr>
    
        <%

        Next

    %>
    
    </tbody>
 </table>
<br />
<br />
<%
    
rsDinnerOptions.Movenext    
Loop

rsDinnerOptions.Close
Set rsDinnerOptions = nothing

%>

<input type="hidden" VALUE = <%= DinnerCount %> />
<INPUT TYPE="SUBMIT" VALUE="Submit">
</FORM>

	
<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>
</html>
<%



End Sub 'TicketOffer

'==========================================================

Sub SurveyUpdate

If Session("OrderNumber") <> "" Then

'Determine the number of possible answers
'------------------------------------------
SQLDinnerOptions = "SELECT OrderLine.LineNumber, OrderLine.SeatTypeCode, SeatType FROM OrderLine (NOLOCK) INNER JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode WHERE OrderNumber = " & Session("OrderNumber") & " ORDER BY OrderLine.LineNumber"
Set rsDinnerOptions = OBJdbConnection.Execute(SQLDinnerOptions)   
 
Do While Not rsDinnerOptions.EOF

    Select Case rsDinnerOptions("SeatTypeCode")
        Case 219 'Dinner for one
            DinnerTotal = 1
        Case 6578 'Dinner for two
            DinnerTotal = 2
        Case 6579 'Dinner for two
            DinnerTotal = 2
        Case 6580 'Dinner for eight
            DinnerTotal = 8
    End Select

    OrderTotal = OrderTotal + DinnerTotal

rsDinnerOptions.Movenext    
Loop

rsDinnerOptions.Close
Set rsDinnerOptions = nothing

ErrorLog("OrderTotal " & OrderTotal & "")

For AnswerNumber = 1 To  OrderTotal

'Remove other survey answers from this order
SQLClearSurvey = "DELETE FROM SurveyAnswers WHERE SurveyNumber = " & Clean(Request("SurveyNumber")) & " AND OrderNumber = " & Session("OrderNumber") & " AND CustomerNumber = " & Session("CustomerNumber") & " AND AnswerNumber = " & AnswerNumber &""
Set rsClearSurvey = OBJdbConnection.Execute(SQLClearSurvey )

Next
   

    
For AnswerNumber = 1 To OrderTotal

	If Clean(Request("Answer" & AnswerNumber)) <> "" Then
			    
            For Each Item IN Request("Answer" & AnswerNumber)
				If Item <> "" Then    
                                        
                    'Update New Survey Answers      
					SQLUpdateSurvey = "INSERT SurveyAnswers(SurveyNumber, OrderNumber, CustomerNumber, SurveyDate, AnswerNumber, Answer, Question) VALUES(" & Clean(Request("SurveyNumber")) & ", " & Session("OrderNumber") & ", " & Session("CustomerNumber") & ", '" & Now() & "', " & AnswerNumber & ", '" & Clean(Item) & "', 'Meal')"
					Set rsUpdateSurvey = OBJdbConnection.Execute(SQLUpdateSurvey)

				End If
			Next
	End If

Next
		
End If

Call SurveyValidate

End Sub 'SurveyUpdate

'==========================================================

Sub SurveyValidate

FormComplete = False

OrderTotal = 0

'Determine the number of possible answers
'------------------------------------------
SQLDinnerOptions = "SELECT OrderLine.LineNumber, OrderLine.SeatTypeCode, SeatType FROM OrderLine (NOLOCK) INNER JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode WHERE OrderNumber = " & Session("OrderNumber") & " ORDER BY OrderLine.LineNumber"
Set rsDinnerOptions = OBJdbConnection.Execute(SQLDinnerOptions)   
 
Do While Not rsDinnerOptions.EOF

    Select Case rsDinnerOptions("SeatTypeCode")
        Case 219 'Dinner for one
            DinnerTotal = 1
        Case 6578 'Dinner for two
            DinnerTotal = 2
        Case 6579 'Dinner for two
            DinnerTotal = 2
        Case 6580 'Dinner for eight
            DinnerTotal = 8
    End Select

    OrderTotal = OrderTotal + DinnerTotal

rsDinnerOptions.Movenext    
Loop

rsDinnerOptions.Close
Set rsDinnerOptions = nothing
   
'Determine the number of actual answers
'------------------------------------------
SQLAnswer = "SELECT Count(Answer) as Count FROM SurveyAnswers WITH (nolock)  WHERE SurveyNumber = " & Clean(Request("SurveyNumber")) & " AND OrderNumber = " & Session("OrderNumber") & " AND CustomerNumber = " & Session("CustomerNumber") & ""
Set rsAnswer = OBJdbConnection.Execute(SQLAnswer)   
AnswerTotal = rsAnswer("Count")
rsAnswer.Close
Set rsAnswer = nothing

If AnswerTotal >= OrderTotal Then
FormComplete = True
End If

If FormComplete Then
    Message = ""
    Call Continue
Else
    Message = "Please select a meal option for each member in your party"
    Call SurveyDisplay(Message)   
End If


End Sub  'SurveyValidate

'========================================================== 
 
Sub Continue

    Session("SurveyComplete") = Session("OrderNumber")

    If Session("UserNumber") = "" Then
	    Response.Redirect("/Ship.asp")
    Else
	    Response.Redirect("/Management/AdvanceShip.asp")
    End If

        
End Sub 'Continue

'==========================================================


%>


