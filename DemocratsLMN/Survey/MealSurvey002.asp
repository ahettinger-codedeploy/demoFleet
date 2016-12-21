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

DIM Question(1)
Question(1) = "Dinner Selection"


DIM AnswerCount

PatronCount = 0


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
        Call SurveyForm
 End Select

'==========================================================

Sub SurveyForm

%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>

<title>Survey Page</title>

<style type="text/css">
    
body
{
line-height: 1 em;
font-size: 10px;
}

.content
{
	font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
	font-weight: 200;
	width: 550px;
	text-align: left;
	border-collapse: collapse;
    padding-left: 10px; 
    line-height: 1 em;
    font-size: 13px;    
}
 
.category
{

	color: <%=TableCategoryFontColor%>;
	background: <%=TableCategoryBGColor%>;
	padding: 5px;
	font-size: 14px;
	font-weight: 400;
}

.data
{
    background: <%=TableDataBGColor%>;
    padding: 5px;
    font-size: 14px;
    font-weight: 400;
    margin-bottom: 30px;
}
	
.buttonset
{
    font-size: 12px;
    line-height: 1px; 
}			
</style>

</head>

<%

If Message = "" Then
    Response.Write "<BODY BGCOLOR=" & BGColor & " LINK="& LinkColor & " ALINK=" & ALinkColor & " VLINK=" & VLinkColor & " leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0 " & BodyParameters & ">" & vbCrLf
Else
    Response.Write "<BODY BGCOLOR=" & BGColor & " LINK="& LinkColor & " ALINK=" & ALinkColor & " VLINK=" & VLinkColor & " onLoad=""alert('" & Message & "');"" leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0 " & BodyParameters & ">" & vbCrLf
End If
Response.Write "<CENTER>"	

%>							

<!--#INCLUDE virtual="TopNavInclude.asp"-->
<%

%>

<form action="<%= SurveyName %>" name="Survey" method="post">
<input type="hidden" name="FormName" value="SurveyUpdate">
<input type="hidden" name="SurveyNumber" value="<%= SurveyNumber %>">

<h1 class="content header">Attendee Information</h1>


<%

 SQLDinnerOptions = "SELECT OrderLine.LineNumber, OrderLine.SeatTypeCode, SeatType FROM OrderLine (NOLOCK) INNER JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode WHERE OrderNumber = " & Session("OrderNumber") & " ORDER BY OrderLine.LineNumber"
Set rsDinnerOptions = OBJdbConnection.Execute(SQLDinnerOptions)   
 
Do While Not rsDinnerOptions.EOF

PatronCount = PatronCount + 1
DinnerCount = 0
AnswerCount = 1

Select Case rsDinnerOptions("SeatTypeCode")
    Case 219 'Friend
        DinnerCount = 1
        DinnerLabel = "meal option:"
    Case 6578 'Dinner for two
        DinnerCount = 2
        DinnerLabel = "meal options:"
    Case 6579 'Dinner for two and program listing
        DinnerCount = 2
        DinnerLabel = "meal options:"
    Case 6580 'Table
        DinnerCount = 8
        DinnerLabel = "meal options:"
End Select

%>
    <div class ="content">
        <div class="content category">
            <b>PATRON <%= PatronCount %> - <%= rsDinnerOptions("SeatType") %></b>
        </div>
        <div class="content data">
            Please select <%=DinnerCount%>&nbsp;<%=DinnerLabel%>
        
           <% For i = 1 to DinnerCount %>

           <div class="content buttonset"> 
                 <b>Meal <%=i%></b>    
                <input type="radio" name="Answer<%= i %>" id="Chicken" value="Chicken" /><label for="Chicken">Chicken</label>
                <input type="radio" name="Answer<%= i %>" id="Fish" value="Fish" /><label for="Fish">Fish</label>
                <input type="radio" name="Answer<%= i %>" id="Vegetarian" value="Vegetarian" /><label for="Vegetarian">Vegetarian</label>
           </div>
            
           <%  
            
           Next  

           i = i + DinnerCount
            
           %>

        </div>
    </div>
<%
    
rsDinnerOptions.Movenext    
Loop

rsDinnerOptions.Close
Set rsDinnerOptions = nothing

%>

<br />
<br />

<INPUT TYPE="SUBMIT" VALUE="Submit">
</FORM>

	
<!--#INCLUDE virtual="FooterInclude.asp"-->
</body>
</html>
<%



End Sub 

'==============================

Sub SurveyUpdate


For i = 1 to 20

		If Clean(Request("Answer" & i)) <> "" Then
				For Each Item IN Request("Answer" & AnswerNumber)
					If Item <> "" Then
						SQLUpdateSurvey = "INSERT SurveyAnswers(SurveyNumber, OrderNumber, CustomerNumber, SurveyDate, AnswerNumber, Answer, Question) VALUES(" & Clean(Request("SurveyNumber")) & ", " & Session("OrderNumber") & ", " & Session("CustomerNumber") & ", '" & Now() & "', " & AnswerNumber & ", '" & Clean(Item) & "', '" & Question(1) & "')"
						Set rsUpdateSurvey = OBJdbConnection.Execute(SQLUpdateSurvey)
					End If
				Next
		End If
        
Next


Call Continue

End Sub 'Update SurveyAnswer


'==============================

Sub Continue

If Session("UserNumber") = "" Then
	Session("SurveyComplete") = Session("OrderNumber") 
	Response.Redirect("/Ship.asp")
Else
	Session("SurveyComplete") = Session("OrderNumber")
	Response.Redirect("/Management/AdvanceShip.asp")
End If

End Sub 'Continue

'==============================


%>


