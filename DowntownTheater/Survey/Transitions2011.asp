<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->

<%

'=========================================

Page = "Survey"
SurveyNumber = 859
SurveyFileName = "Transitions2011.asp"

RequiredEvent = 295799

FormName = "Transitions 2011 Conference"

Dim Question(11)
NumQuestions = 10

Question(1) = "Title"
Question(2) = "First Name"
Question(3) = "Last Name"
Question(4) = "Street Address"
Question(5) = "City"
Question(6) = "State"
Question(7) = "Zip Code"
Question(8) = "School/Organization"
Question(9) = "E-mail Address"
Question(10) = "Did you attend the Transitions 2010 conference?"

'=========================================

'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If

If Session("UserNumber")<> "" Then
TableCategoryBGColor = "#008400"
TableCategoryFontColor = "FFFFFF"
TableColumnHeadingBGColor = "99CC99"
TableColumnHeadingFontColor = "000000"
TableDataBGColor = "E9E9E9"
End If

If Clean(Request("FormName")) = "SurveyAnswerUpdate" Then
    Call SurveyAnswerUpdate	
ElseIf Clean(Request("FormName")) = "EventListUpdate" Then
    Call EventListUpdate
Else
	Call SurveyForm
End If

OBJdbConnection.Close
Set OBJdbConnection = nothing

'=========================================

Sub SurveyForm

'Determine if required event is in the shopping cart

AvailOfferCount = 0
 
SQLRequiredTicketCount = "SELECT COUNT(OrderLine.ItemNumber) AS Count FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Seat.EventCode = " & RequiredEvent & " AND OrderLine.ItemType = 'Seat'"' GROUP BY Seat.EventCode ORDER BY Seat.EventCode"
Set rsRequiredTicketCount = OBJdbConnection.Execute(SQLRequiredTicketCount)
    
If Not rsRequiredTicketCount.EOF Then
    AvailOfferCount = rsRequiredTicketCount("Count")
End If
	
rsRequiredTicketCount.Close
Set rsRequiredTicketCount = nothing  

If AvailOfferCount  => 1 Then
    Call RegistrationOne(AvailOfferCount) 
Else
    Call Continue
End If 
  

End Sub

'=======================================

Sub RegistrationOne(AvailOfferCount) 

If DocType <> "" Then
    Response.Write(DocType)
Else
    Response.Write("<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">")
End If

%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<html>

<head>

<title>="<%= Title %>"</title>

<style type="text/css">
<!--
#tix-table
{
	font-family: Verdana, Geneva, Arial, Helvetica, sans-serif; 
	font-size: 12px;
	/* table width */
	border-collapse: collapse;
	background: #f1f1f1;
}
#tix-table th
{
	font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;  
	font-size: 16px;
	font-weight: 900;
	padding: 8px;
	/* table catagory row color */
	background: #000000;
	/* table catagory top row trim color */
	border-top: 2px solid #c7c7c7;
	/* table catagory font color */
	color: #33ccff;
}
#tix-table a
{
	/* table link color */
	color: #912147;
	font-weight:900
}
#tix-table caption
{
	font-size: 13px;
	padding: 8px;
	/* table catagory font color */
	color: #f6d8e3;
	/* table caption font weight 400 normal 900 strong */	
	font-weight:900
}
.headingcell 
{
 background-color: #f1f1f1;     
 padding: 10px;      
 font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;  
 font-size: 14px; 
 font-weight: 900; 
 color: #000000;   
 text-align: right;      
}
.labelcell 
{
 width: 200px;
 background-color: #f1f1f1;  
 margin-right: 0px;    
 padding: 10px;     
 font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;  
 font-size: 13px;  
 color: #000000;   
 text-align: right;      
} 
.fieldcell   
{
 background-color: #f1f1f1;   
 margin-right: 0px;    
 padding-right: 10px;   
 padding-top: 5px;  
 padding-bottom: 5px;     
 font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;   
 font-size: 13px;  
 color: #000000;    
 text-align: left;  
}    
.fieldcell input {    
 font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;    
 font-size: 13px;     
 background-color: #ffffff;    
 color: #000000;   
 border: 1px solid #000000;    
 margin-right: 0px;    
} 
.fieldcell select {    
 font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;    
 font-size: 12px;     
 background-color: #ffffff;    
 color: #000000;   
 border: 1px solid #000000;    
 margin-right: 0px;
}

-->
</style>

<script language="javascript">
var answer_name = new Array ('Answer1','Answer2','Answer3','Answer4','Answer5','Answer6','Answer7','Answer8','Answer9','Answer10');
var answer_type = new Array ('checkbox','radio','select','text');
var total_ques = <%=AvailOfferCount%>

function validateForm() {
    isAnswered = true
    form = document.Survey;
	for (var i = 0; i < form.elements.length; i++) {
    	element = form.elements[i];
        if(element.type=='text')
            if(element.value=="")
                isAnswered = false
        //if(element.type=='radio')
            //if(getCheckedValue(element)=="")
                //isAnswered = false            
    }
    for (var i = 1; i <= total_ques; i++) {
        //check textareas
        if(document.getElementById('Answer10_y'+i).checked==false&&document.getElementById('Answer10_n'+i).checked==false)
            isAnswered = false  
    }
    if( isAnswered == false ) {
        alert("You are required to complete this survey");
	    return false;
    }
}
function getCheckedValue(radioObj) {
    if(!radioObj)
	    return "";
    var radioLength = radioObj.length;
    if(radioLength == undefined)
	    if(radioObj.checked)
		    return radioObj.value;
	    else
		    return "";
    for(var i = 0; i < radioLength; i++) {
	    if(radioObj[i].checked) {
		    return radioObj[i].value;
	    }
    }
    return "";
}
</script>

</head>

<%=strBody %>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<form action="<%= SurveyFileName %>" name="Survey" method="post" onsubmit="return validateForm();">
<input type="hidden" name="FormName" value="SurveyAnswerUpdate">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">
<INPUT TYPE="hidden" NAME="TotalTix" VALUE="<%= AvailOfferCount %>">

<! -- Table Begin -- >
<br />
<table id="tix-table" summary="surveypage" width="600" cellpadding="10" cellspacing="0" border="0">
<tbody>
    <tr align="left" bgcolor="<%=TableCategoryBGColor%>">
        <td>
	        <FONT FACE="<%= FontFace %>" COLOR="<%=TableCategoryFontColor%>" SIZE="4">
            <b><%= FormName %></b></FONT>
        </td>
    </tr>
    <tr bgcolor="white">
        <td>
        <br />
        <FONT FACE="<%= FontFace %>" SIZE="2"><i>Please complete the following information for each guest attending the event</i></FONT><br />
        <br />
        <%
            For OptionCount = 1 To AvailOfferCount
        %>
        <table id="Table1" summary="surveypage" width="100%" cellpadding="10" cellspacing="0" border="0">
        <tbody>
            <tr>
	            <td class="headingcell">Guest <%=OptionCount%></td><td class="fieldcell">&nbsp;</td><td class="headingcell" rowspan="11">&nbsp;</td>
            </tr>
             <tr>
                <td class="labelcell"><%=Question(2)%></td>
                <td class="fieldcell">&nbsp;<INPUT TYPE="text" NAME="Answer2_<%=OptionCount%>" SIZE="23" /></td>
            </tr>
            <tr>
                <td class="labelcell"><%=Question(3)%></td>
                <td class="fieldcell">&nbsp;<INPUT TYPE="text" NAME="Answer3_<%=OptionCount%>" SIZE="23" /></td>
             </tr>            
        </tbody>
        </table>
        <br />
        <br />
        <%
            Next
        %>
        </td>    
    </tr>
</tbody>
</table>

<INPUT TYPE="submit" VALUE="Continue"></FORM>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%

End Sub ' SurveyForm

'=======================================

Sub SurveyAnswerUpdate

If Session("OrderNumber") <> "" Then

    SQLRequiredTicketCount = "SELECT COUNT(OrderLine.ItemNumber) AS Count FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Seat.EventCode = " & RequiredEvent & " AND OrderLine.ItemType = 'Seat'"' GROUP BY Seat.EventCode ORDER BY Seat.EventCode"
    Set rsRequiredTicketCount = OBJdbConnection.Execute(SQLRequiredTicketCount)
        
        If Not rsRequiredTicketCount.EOF Then
            AvailOfferCount = rsRequiredTicketCount("Count")
	    End If
    	
    rsRequiredTicketCount.Close
    Set rsRequiredTicketCount = nothing  

	For i = 1 To AvailOfferCount 
	
        LineNumber = i
        
		 
		'Delete existing First Name record for this line number.
		SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & LineNumber & " AND FieldName = 'FirstName'"
		Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)

		'Insert First Name record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", 'FirstName', '" & Clean(Request("Answer2_"&i)) & "'  )"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)

		'Delete existing Last Name record for this line number.
		SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & LineNumber & " AND FieldName = 'LastName'"
		Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)
		
		'Insert Last Name record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", 'LastName', '" & Clean(Request("Answer3_"&i)) & "'  )"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)		
	
		
Next

End If	

Call EventList

End Sub 'SurveyUpdate


'================================

Sub EventList

Dim SurveyFields(7,3)

Day01Header = "Friday, October 21, 2011"

SurveyFields(1,0) = "Life at Lynn as a College Student (For Parents Only)"
SurveyFields(1,1) = "1:30 pm-2:30 pm"
SurveyFields(1,2) = "de Hoernle International Center"

SurveyFields(2,0) =  "Innovative Classroom Technology"
SurveyFields(2,1) = "2:30 pm-3:30 pm"
SurveyFields(2,2) = "de Hoernle International Center"

SurveyFields(3,0) =  "Financial Aid"
SurveyFields(3,1) = "3:30 pm-4:30 pm"
SurveyFields(3,2) = "de Hoernle International Center"

Day02Header = "Saturday, October 22, 2011"

SurveyFields(4,0) = "Coffee with the President"
SurveyFields(4,1) = "10:00 am-10:30 am"
SurveyFields(4,2) = "Keith C. and Elaine Johnson Wold Performing Arts Center"

SurveyFields(5,0) = "Reception with College Deans and Faculty"
SurveyFields(5,1) =  "10:30 am-11:30 am"
SurveyFields(5,2) = "Keith C. and Elaine Johnson Wold Performing Arts Center"

SurveyFields(6,0) = "Lynn Family Barbecue"
SurveyFields(6,1) =  "12:30 pm-2:00 pm"
SurveyFields(6,2) =  "Frieburger Residence Hall Lawn"

SurveyFields(7,0) = "Movie on the Lawn"
SurveyFields(7,1) = "8:00 pm"
SurveyFields(7,2) = "Frieburger Residence Hall Lawn"



If DocType <> "" Then
	Response.Write DocType
Else
	Response.Write "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
End If

%>

<html>
<head>
<title>=<%= Title %></title>
<body>

<script language="JavaScript">
<!--
function radio_button_checker()
{
// set var radio_choice to false
var radio_choice = false;

// Loop from zero to the one minus the number of radio button selections
for (counter = 0; counter < survey.SessionOne[i].length; counter++)
{
// If a radio button has been selected it will return true
// (If not it will return false)
if (survey.SessionOne[counter].checked)
radio_choice = true; 
}

if (!radio_choice)
{
// If there were no selections made display an alert box 
alert("Please select a letter.")
return (false);
}
return (true);
}

-->
</script>


</head>

<%=strBody %>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey" onsubmit="return radio_button_checker()">
<INPUT TYPE="hidden" NAME="FormName" VALUE="EventListUpdate">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">

<%

Call DBOpen(OBJdbConnection2)
Call DBOpen(OBJdbConnection3)
Call DBOpen(OBJdbConnection4)

%>	

<table bgcolor="<%=TableDataBGColor%>" cellpadding="0" cellspacing="0" border="0">
<tr align="left" bgcolor="<%=TableCategoryBGColor%>">
    <td colspan="2" Style="line-height: 4em;">
        <FONT FACE="<%= FontFace %>" COLOR="<%=TableCategoryFontColor%>" SIZE="4">
        <b>Transitions 2011 Conference</b></FONT><br />
        <FONT FACE="<%= FontFace %>" COLOR=<%=TableCategoryFontColor%> SIZE="2"><i>To accommodate attendees appropriately, please select a breakout session from each time period for all guests.</i></FONT>
    </td>
</tr>
<%

SQLEvent = "SELECT Event.EventCode, Event.EventDate, Act.Act, Venue.Venue FROM OrderLine WITH (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event WITH (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act WITH (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue WITH (ROWLOCK) ON Event.VenueCode = Venue.VenueCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Event.SurveyNumber = " & SurveyNumber & " GROUP BY Event.EventCode, Event.EventDate, Act.Act, Venue.Venue ORDER BY Event.EventDate, Act.Act, Venue.Venue"
Set rsEvent = OBJdbConnection.Execute(SQLEvent)

Do Until rsEvent.EOF	

	SQLOrderLine = "SELECT OrderLine.LineNumber FROM OrderLine WITH (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Seat.EventCode = " & rsEvent("EventCode") & " ORDER BY OrderLine.LineNumber"
	Set rsOrderLine = OBJdbConnection2.Execute(SQLOrderLine)
    TotalLines = 0
	Do Until rsOrderLine.EOF 
	   
    'Capture Session One Information

		FieldName = "SessionOne"
		FieldLabel = "Session One"
			
		'Get existing OrderLineDetail values for this order if there are any.
		SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLine("LineNumber") & " AND FieldName = '" & FieldName & "'"
		Set rsOrderLineDetail = OBJdbConnection3.Execute(SQLOrderLineDetail)
		
		If Not rsOrderLineDetail.EOF Then
    		SessionOne = rsOrderLineDetail("FieldValue")
        Else
            SessionOne = ""
        End If
			
	    rsOrderLineDetail.Close
		Set rsOrderLineDetail = nothing	

        ErrorLog("SessionOne: " & SessionOne & "")
    
    'Capture Session Two Information

		FieldName = "SessionTwo"
		FieldLabel = "Session Two"
			
		'Get existing OrderLineDetail values for this order if there are any.
		SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLine("LineNumber") & " AND FieldName = '" & FieldName & "'"
		Set rsOrderLineDetail = OBJdbConnection3.Execute(SQLOrderLineDetail)
			
		If Not rsOrderLineDetail.EOF Then
			SessionTwo = rsOrderLineDetail("FieldValue")
		Else
			SessionTwo = ""
		End If
			
		rsOrderLineDetail.Close
		Set rsOrderLineDetail = nothing

        
    'Capture Session Three Information

		FieldName = "SessionThree"
		FieldLabel = "Session Three"
			
		'Get existing OrderLineDetail values for this order if there are any.
		SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLine("LineNumber") & " AND FieldName = '" & FieldName & "'"
		Set rsOrderLineDetail = OBJdbConnection4.Execute(SQLOrderLineDetail)
			
		If Not rsOrderLineDetail.EOF Then
			SessionThree = rsOrderLineDetail("FieldValue")
		Else
			SessionThree = ""
		End If
			
		rsOrderLineDetail.Close
		Set rsOrderLineDetail = nothing	
		
		
	    SQLFirstName = "Select (SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.FieldName = 'FirstName' and OrderNumber = " & Session("OrderNumber")& " and LineNumber= " & rsOrderLine("LineNumber") & ") as FirstName"
        Set rsFirstName = OBJdbConnection.Execute(SQLFirstName)
        FirstName = rsFirstName("FirstName")
        rsFirstName.Close
	    Set rsFirstName = nothing

        SQLLastName = "Select (SELECT OrderLineDetail.FieldValue FROM OrderLineDetail WHERE OrderLineDetail.FieldName = 'LastName' and OrderNumber = " & Session("OrderNumber")& " and LineNumber= " & rsOrderLine("LineNumber") & ") as LastName"
        Set rsLastName = OBJdbConnection.Execute(SQLLastName)
        LastName = rsLastName("LastName")	
        rsLastName.Close
	    Set rsLastName = nothing      

	    'Guest # - Ticket Type - Name
        Response.Write "<TR bgcolor=""#ffffff"" align=""left""><TD>&nbsp;&nbsp;</td><td><FONT FACE=""" & FontFace & """ COLOR=""" & HeadingColor & """  SIZE=""4"" Style=""line-height: 3em;""><B>" & FirstName & "&nbsp;" & LastName & "</b></td></tr>" & vbCrLf
        
        '11:00 AM Breakout Sessions
        Response.Write "<TR align=""left"" BGCOLOR=""" & TableColumnHeadingBGColor & """><TD>&nbsp;&nbsp;</td><td><FONT FACE=""" & FontFace & """ COLOR=""" & TableColumnHeadingFontColor & """  SIZE=""2"" Style=""line-height: 1.5em;""><B>11:00 a.m. Breakout Sessions</b><BR><FONT FACE=""" & FontFace & """ COLOR=""" & TableColumnHeadingFontColor & """  SIZE=""1""><i>Select one session from the list below</i></td></tr>" & vbCrLf
        Response.Write "<tr><td colspan=""2"">&nbsp;</td></tr>" & vbCrLf 
         
        For FieldNum = 2 To 8         
            Response.Write "<TR align=""left""><TD align=""left"" valign=""top""><INPUT TYPE=""radio"" NAME=""SessionOne" & TotalLines+1 & """ VALUE=""" & SurveyFields(FieldNum, 0) & """></td><td><FONT FACE=""" & FontFace & """ COLOR=""" & HeadingColor & """   SIZE=""1""><B>" & SurveyFields(FieldNum, 0) & "</b><BR><FONT FACE=""" & FontFace & """ COLOR=""1C1C1C""  SIZE=""1""><b>Presenter: </b>" & SurveyFields(FieldNum, 1) & "</font><Br><br></td></tr>" & vbCrLf              
        Next
        
        '1:45 PM Breakout Sessions
        Response.Write "<TR align=""left"" BGCOLOR=""" & TableColumnHeadingBGColor & """><TD>&nbsp;&nbsp;</td><td><FONT FACE=""" & FontFace & """ COLOR=""" & TableColumnHeadingFontColor & """  SIZE=""3"" Style=""line-height: 1.5em;""><b>1:45 p.m. Breakout Sessions</b><BR><FONT FACE=""" & FontFace & """ COLOR=""" & TableColumnHeadingFontColor & """  SIZE=""1""><i>Select one session from the list below</i></td></tr>" & vbCrLf
        Response.Write "<tr><td>&nbsp;</td></tr>" & vbCrLf
        
        For FieldNum = 9 To 15        
	        Response.Write "<TR align=""left"" ><TD align=""left"" valign=""top""><INPUT TYPE=""radio"" NAME=""SessionTwo" & TotalLines+1 & """ VALUE=""" & SurveyFields(FieldNum, 0) & """></td><td><FONT FACE=""" & FontFace & """ COLOR=""" & HeadingColor & """   SIZE=""1""><B>" & SurveyFields(FieldNum, 0) & "</b><BR><FONT FACE=""" & FontFace & """ COLOR=""1C1C1C""  SIZE=""1""><b>Presenter: </b>" & SurveyFields(FieldNum, 1) & "</font><Br><br></td></tr>" & vbCrLf
        Next
        
        '3:00 PM Breakout Sessions
        Response.Write "<TR align=""left"" BGCOLOR=""" & TableColumnHeadingBGColor & """><TD>&nbsp;&nbsp;</td><td><FONT FACE=""" & FontFace & """ COLOR=""" & TableColumnHeadingFontColor & """  SIZE=""3"" Style=""line-height: 1.5em;""><b>3:00 p.m. Breakout Sessions</b><BR><FONT FACE=""" & FontFace & """ COLOR=""" & TableColumnHeadingFontColor & """  SIZE=""1""><i>Select one session from the list below</i></td></tr>" & vbCrLf
        Response.Write "<tr><td>&nbsp;</td></tr>" & vbCrLf
        
        For FieldNum = 16 To 21     
	        Response.Write "<TR align=""left""><TD align=""left"" valign=""top""><INPUT TYPE=""radio"" NAME=""SessionThree" & TotalLines+1 & """ VALUE=""" & SurveyFields(FieldNum, 0) & """></td><td><FONT FACE=""" & FontFace & """ COLOR=""" & HeadingColor & """   SIZE=""1""><B>" & SurveyFields(FieldNum, 0) & "</b><BR><FONT FACE=""" & FontFace & """ COLOR=""1C1C1C""  SIZE=""1""><b>Presenter: </b>" & SurveyFields(FieldNum, 1) & "</font><Br><br></td></tr>" & vbCrLf
        Next

	TotalLines = TotalLines + 1
	rsOrderLine.MoveNext
	
	Loop
	
	rsOrderLine.Close
	Set rsOrderLine = nothing
	
	rsEvent.MoveNext

	
Loop


rsEvent.Close
Set rsEvent = nothing

Call DBClose(OBJdbConnection2)
Call DBClose(OBJdbConnection3)
Call DBClose(OBJdbConnection4)
Response.Write "</TABLE>" & vbCrLf
Response.Write "<input type=""hidden"" name=""TotalLines"" value=""" & TotalLines & """>" & vbCrLf

%>  

<BR><BR>
<INPUT TYPE="submit" VALUE="Continue"></FORM>
</CENTER>

<!--#INCLUDE virtual="/FooterInclude.asp"-->

</BODY>
</HTML>

<%

End Sub 'EventList

'================================

Sub EventListUpdate

If Session("OrderNumber") <> "" Then

	For i = 1 To Request("TotalLines")
        LineNumber = i
        
		'Delete existing Session One record for this line number.
		SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & LineNumber & " AND FieldName = 'SessionOne'"
		Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)

		'Insert Session One record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", 'SessionOne', '" & Clean(Request("SessionOne" & i)) & "')"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)

		'Delete existing Session Two record for this line number.
		SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & LineNumber & " AND FieldName = 'SessionTwo'"
		Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)
		
		'Insert Session Two record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", 'SessionTwo', '" & Clean(Request("SessionTwo" & i)) & "')"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)		
		
		'Delete existing Session Three record for this line number.
		SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & LineNumber & " AND FieldName = 'SessionThree'"
		Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)
		
		'Insert Session Three record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", 'SessionThree', '" & Clean(Request("SessionThree" & i)) & "')"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)	

	Next	

	Call Continue
		
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

'================================

    Function PCase(ByVal strInput)' As String
        Dim I 'As Integer
        Dim CurrentChar, PrevChar 'As Char
        Dim strOutput 'As String

        PrevChar = ""
        strOutput = ""

        For I = 1 To Len(strInput)
            CurrentChar = Mid(strInput, I, 1)

            Select Case PrevChar
                Case "", " ", ".", "-", ",", """", "'"
                    strOutput = strOutput & UCase(CurrentChar)
                Case Else
                    strOutput = strOutput & LCase(CurrentChar)
            End Select

            PrevChar = CurrentChar
        Next 'I

        PCase = strOutput
    End Function 
    
'================================

Sub Continue
    If Session("UserNumber") = "" Then
		'REE 4/19/3 - Modified to use Session Variable for SurveyComplete
		Session("SurveyComplete") = Session("OrderNumber")
		Response.Redirect("/Ship.asp")
	Else
		'REE 4/19/3 - Modified to use Session Variable for SurveyComplete
		Session("SurveyComplete") = Session("OrderNumber")
		Response.Redirect("/Management/AdvanceShip.asp")
	End If
	
End Sub 'Continue

'================================

%>
