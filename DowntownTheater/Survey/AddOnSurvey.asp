<!--#INCLUDE virtual=/PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=/GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=/DBOpenInclude.asp -->
<%

Page = "Survey"

SurveyNumber = 1069
SurveyFileName = "AddOnSurvey.asp"

NumQuestions = 2

Dim Question(3)

Question(1) = "Restaurant"
Question(2) = "Quantity"



'============================================================

'Please create the following survey and attach to EventCode 468746.
'Header should say: “Please tell us your restaurant and meal choices:”
'Choice #1
'The Trellis Restaurant 
'includes:
'Slow roasted beef brisket
'Russet Potatoes
'Braised Vegetables
'Mixed Greens with Pomegranate Vinaigrette
'Cobbler

'Choice #2
'Blue Talon Bistro
'includes:
'Rotisserie Chicken
'Potato Salad
'Vegetable Ratatouille
'Mixed Greens with Sherry Wine Vinaigrette
'Brownie

'Choice #3
'Berret’s Seafood Restaurant 
'includes:
'Chilled Agave-Glazed Salmon Fillet
'On DaySpring Farm Microgreens with
'Teardrop Tomatoes and Red Onion
'Quinoa & Roasted Vegetable Salad
'Toasted Baguette
'Linzer Torte Bar

'Each choice should be a radio button with a text field option.
'Contact
'Harry Burton
'Harry@williamsburgsymphonia.org

'Thanks!


'============================================================

'CSS Survey Variables

If Session("UserNumber")<> "" Then

    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "#ffffff"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "#000000"
    TableDataBGColor = "#E9E9E9"
    
    'LastHex = box color
    'FirstHex = background color
    NECorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=008400&Src=TopLeftCorner16.txt"
    NWCorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=008400&Src=TopRightCorner16.txt"
    SWCorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=E9E9E9&Src=BottomLeftCorner16.txt"
    SECorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=E9E9E9&Src=BottomRightCorner16.txt"
    
Else

    'LastHex = box color
    'FirstHex = background color
    NECorner="/clients/tix/images/image.asp?FirstHex=e0dab9&LastHex=f3b60d&Src=TopLeftCorner16.txt"
    NWCorner="/clients/tix/images/image.asp?FirstHex=e0dab9&LastHex=f3b60d&Src=TopRightCorner16.txt"
    SWCorner="/clients/tix/images/image.asp?FirstHex=e0dab9&LastHex=f1f1f1&Src=BottomLeftCorner16.txt"
    SECorner="/clients/tix/images/image.asp?FirstHex=e0dab9&LastHex=f1f1f1&Src=BottomRightCorner16.txt"
    
End If

'============================================================


'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If

If Clean(Request("FormName")) <> "SurveyForm" Then
	Call SurveyForm
Else
	Call UpdateSurveyAnswer
End If

OBJdbConnection.Close
Set OBJdbConnection = nothing

'===============================================

Sub SurveyForm

%>

<html>
<head>
<title>="<%= Title %>"</title>

<style type="text/css">
body
{
    font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
}
#rounded-corner
{

    font-weight: 400;
	text-align: left;
	border-collapse: collapse;
}
#rounded-corner thead th.category
{
	padding-top: 10px;
    padding-bottom: 0px;
    padding-left: 0px;
    padding-right: 0px;
    margin: 0px;
	font-weight: 600;
	text-align: center;
	color: <%=TableCategoryFontColor%>;
	background: <%=TableCategoryBGColor%>;
}
#rounded-corner thead th.category-left
{
	background: <%=TableCategoryBGColor%> url('<%=NECorner%>') left -1px no-repeat;
	text-align: right;
}
#rounded-corner thead th.category-right
{
	background: <%=TableCategoryBGColor%> url('<%=NWCorner%>') right -1px no-repeat;
    text-align: left;
}
#rounded-corner td.footer
{
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.footer-left
{
    background: <%=TableDataBGColor%> url('<%=SWCorner%>') left bottom no-repeat;
}
#rounded-corner td.footer-right
{
	background: <%=TableDataBGColor%> url('<%=SECorner%>') right bottom no-repeat;
}
#rounded-corner td
{
	padding-left: 10px;
	padding-right: 10px;
	padding-top: 10px;
	padding-bottom: 10px;
	text-align: center;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
	font-size: .9em;
}

#rounded-corner h2
{
font-size: 1.5em;
}
#rounded-corner h3
{
font-size: 2em;
color: <%=TableCategoryFontColor%>;
}

#rounded-corner label
{
float:left; 
clear:none; 
display:block; 
padding: 2px 1em 0 0; 
}


#rounded-corner input[type="radio"]:checked+span 
{ 
font-weight: bold;
}

</style>

</HEAD>

<!--#INCLUDE virtual="/TopNavInclude.asp"-->

<BR>
<BR>
<H3> Please tell us your restaurant and meal choices:</H3>
<BR>
<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey">
<INPUT TYPE="hidden" NAME="FormName" VALUE="SurveyForm">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">


<table border="0" cellpadding="5" cellspacing="10">
<tr>
<td align="top">

<table id="rounded-corner"width="200px" summary="surveypage" border="0">
<thead>
    <tr>
	    <th scope="col" class="category-left"></th>
	    <th scope="col" class="category" colspan="2"><h3>Choice 1</h3></th>
	    <th scope="col" class="category-right"></th>
    </tr>        
</thead>
    <tbody>   
    <tr>
        <td class="data" colspan="4">            
        <center>
        <h2>The Trellis Restaurant</h2> 
        includes:<br />
        Slow roasted beef brisket<br />
        Russet Potatoes<br />
        Braised Vegetables<br />
        Mixed Greens with <br />
        Pomegranate Vinaigrette<br />
        Cobbler<br />
        <br />
        <br />
        <input type="radio" class="radio" name="Answer1" value="Trellis" id="1"/><label for="1"><span>The Trellis Restaurant</span></label>
        <br />
        <br />
        </center>
        </td>  
    </tr>
    <tr>
        <td class="footer-left">&nbsp;</td>
        <td class="footer" colspan="2">&nbsp;</td>
        <td class="footer-right">&nbsp;</td>
    </tr>
</table>

</td>
<td align="top">

<table id="rounded-corner" width="200px" summary="surveypage" >
<thead>
    <tr>
	    <th scope="col" class="category-left"></th>
	    <th scope="col" class="category" colspan="2"><h3>Choice 2</h3></th>
	    <th scope="col" class="category-right"></th>
    </tr>        
</thead>
    <tbody>   
    <tr>
        <td class="data" colspan="4">            
        <center>
        <h2>Blue Talon Bistro</h2>
        includes:<br />
        Rotisserie Chicken<br />
        Potato Salad<br />
        Vegetable Ratatouille<br />
        Mixed Greens with<br />
        Sherry Wine Vinaigrette<br />
        Brownie<br />
        <br />
        <br />
        <input type="radio" name="Answer1" value="Blue Talo"/><label for="Blue Talon"><span>Blue Talon</span></label>
        <br />
        <br />
        </center>
        </td>  
    </tr>
    <tr>
        <td class="footer-left">&nbsp;</td>
        <td class="footer" colspan="2">&nbsp;</td>
        <td class="footer-right">&nbsp;</td>
    </tr>
</table>

</td>
<td align="top">

<table id="rounded-corner" width="200px" summary="surveypage" >
<thead>
    <tr>
	    <th scope="col" class="category-left"></th>
	    <th scope="col" class="category" colspan="2"><h3>Choice 3</h3></th>
	    <th scope="col" class="category-right"></th>
    </tr>        
</thead>
    <tbody>   
    <tr>
        <td class="data" colspan="4">            
        <center>
        <h2>Berrets Seafood Restaurant</h2>
        includes:<br />
        Chilled Agave-Glazed Salmon Fillet<br />
        On DaySpring Farm Microgreens<br />
        with Teardrop Tomatoes and Red<br />
        Onion Quinoa & Roasted Vegetable<br />
        Salad Toasted Baguette<br />
        Linzer Torte Bar<br />
        <br />
        <input type="radio" name="Answer1" value="Berrets"/><label for="Berrets Seafood Restaurant"><span>Berrets Seafood Restaurant</span></label>
        <br />
        <br />
        </center>
        </td>  
    </tr>
    <tr>
        <td class="footer-left">&nbsp;</td>
        <td class="footer" colspan="2">&nbsp;</td>
        <td class="footer-right">&nbsp;</td>
    </tr>
</table>

</td>
</tr>
<tr align="center">
    <td colspan=3 align="center">
            <SELECT NAME="Answer2">
            <OPTION VALUE="0">Select Quantity</OPTION>
            <OPTION VALUE="1">1</OPTION>                      
            <OPTION VALUE="2">2</OPTION>
            <OPTION VALUE="3">3</OPTION>                      
            <OPTION VALUE="4">4</OPTION>
            <OPTION VALUE="5">5</OPTION>                      
            <OPTION VALUE="6">6</OPTION>
            <OPTION VALUE="7">7</OPTION>                      
            <OPTION VALUE="8">8</OPTION>
            <OPTION VALUE="9">9</OPTION>                      
            <OPTION VALUE="10">10</OPTION>
        </SELECT>
        <br />
        <br />
        <br />
        <INPUT TYPE="submit" VALUE="Continue"></FORM>
    </td>
</tr>
</table>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%
    
End Sub 'DisplayOfferEvent

Sub UpdateSurveyAnswer

If Session("OrderNumber") <> "" Then
    For AnswerNumber = 1 To UBound(Question)
		If Clean(Request("Answer" & AnswerNumber)) <> "" Then
				For Each Item IN Request("Answer" & AnswerNumber)
					If Item <> "" Then
						SQLUpdateSurvey = "INSERT SurveyAnswers(SurveyNumber, OrderNumber, CustomerNumber, SurveyDate, AnswerNumber, Answer, Question) VALUES(" & Clean(Request("SurveyNumber")) & ", " & Session("OrderNumber") & ", " & Session("CustomerNumber") & ", '" & Now() & "', " & AnswerNumber & ", '" & Clean(Item) & "', '" & Question(AnswerNumber) & "')"
						Set rsUpdateSurvey = OBJdbConnection.Execute(SQLUpdateSurvey)
					End If
				Next
		End If
	Next
		
	If Session("UserNumber") = "" Then
		'REE 4/19/3 - Modified to use Session Variable for SurveyComplete
		Session("SurveyComplete") = Session("OrderNumber")
		Response.Redirect("/Ship.asp")
	Else
		'REE 4/19/3 - Modified to use Session Variable for SurveyComplete
		Session("SurveyComplete") = Session("OrderNumber")
		Response.Redirect("/Management/AdvanceShip.asp")
	End If
		
Else 'No Session Order Number
	
	If Session("UserNumber") = "" Then
		Session.Contents.Remove("OrderNumber") 
		OBJdbConnection.Close
		Set OBJdbConnection = nothing
		Response.Redirect("/Default.asp")
	Else
		Session.Contents.Remove("OrderNumber") 
		OBJdbConnection.Close
		Set OBJdbConnection = nothing
		Response.Redirect("http://" & Request.ServerVariables("SERVER_NAME") & "/Management/ClearOrderNumber.asp")
	End If

End If


End Sub 'Update SurveyAnswer

%>


