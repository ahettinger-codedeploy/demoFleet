<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->

<%

'=========================================

Page = "Survey"
SurveyNumber = 862
SurveyFileName = "Transitions2011.asp"

RequiredEvent = 303183

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

Dim FieldName(11)
NumFields = 10
FieldName(1) = "Title"
FieldName(2) = "FirstName"
FieldName(3) = "LastName"
FieldName(4) = "StreetAddress"
FieldName(5) = "City"
FieldName(6) = "State"
FieldName(7) = "ZipCode"
FieldName(8) = "School_Organization"
FieldName(9) = "E-mail_Address"
FieldName(10) = "Attended_2010"


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
    Call DataArray(AvailOfferCount)
Else
    Call Continue
End If 
  

End Sub

'=======================================

Sub DataArray(AvailOfferCount)

Call DBOpen(OBJdbConnection2)
Call DBOpen(OBJdbConnection3)
Call DBOpen(OBJdbConnection4)
Call DBOpen(OBJdbConnection5)


SQLEvent = "SELECT Event.EventCode, Event.EventDate, Act.Act, Venue.Venue FROM OrderLine WITH (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event WITH (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act WITH (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue WITH (ROWLOCK) ON Event.VenueCode = Venue.VenueCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Event.SurveyNumber = " & SurveyNumber & " GROUP BY Event.EventCode, Event.EventDate, Act.Act, Venue.Venue ORDER BY Event.EventDate, Act.Act, Venue.Venue"
Set rsEvent = OBJdbConnection.Execute(SQLEvent)

Do Until rsEvent.EOF
	
	SQLOrderLine = "SELECT OrderLine.LineNumber FROM OrderLine WITH (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Seat.EventCode = " & rsEvent("EventCode") & " ORDER BY OrderLine.LineNumber"
	Set rsOrderLine = OBJdbConnection2.Execute(SQLOrderLine)
    
    TotalLines = 0
    
	Do Until rsOrderLine.EOF
    
    'Capture First Name Information

		FieldName = "FirstName"
		FieldLabel = "First Name"
			
		'Get existing OrderLineDetail values for this order if there are any.
		SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLine("LineNumber") & " AND FieldName = '" & FieldName & "'"
		Set rsOrderLineDetail = OBJdbConnection3.Execute(SQLOrderLineDetail)
			
		If Not rsOrderLineDetail.EOF Then
			FirstName & LineNumber = rsOrderLineDetail("FieldValue")
		Else
			FirstName = ""
		End If
			
		rsOrderLineDetail.Close
		Set rsOrderLineDetail = nothing


    'Capture Last Name Information

		FieldName = "LastName"
		FieldLabel = "Last Name"
			
		'Get existing OrderLineDetail values for this order if there are any.
		SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLine("LineNumber") & " AND FieldName = '" & FieldName & "'"
		Set rsOrderLineDetail = OBJdbConnection4.Execute(SQLOrderLineDetail)
			
		If Not rsOrderLineDetail.EOF Then
			LastName & LineNumber = rsOrderLineDetail("FieldValue")
		Else
			LastName = ""
		End If
			
		rsOrderLineDetail.Close
		Set rsOrderLineDetail = nothing
	
   
    'Capture Catagory Information

		FieldName = "Catagory"
		FieldLabel = "Catagory"
			
		'Get existing OrderLineDetail values for this order if there are any.
		SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLine("LineNumber") & " AND FieldName = '" & FieldName & "'"
		Set rsOrderLineDetail = OBJdbConnection5.Execute(SQLOrderLineDetail)
			
		If Not rsOrderLineDetail.EOF Then
			Catagory & LineNumber = rsOrderLineDetail("FieldValue")
		Else
			Catagory = ""
		End If
			
		rsOrderLineDetail.Close
		Set rsOrderLineDetail = nothing
	
rsEvent.MoveNext
	
Loop


rsEvent.Close
Set rsEvent = nothing

Call DBClose(OBJdbConnection2)
Call DBClose(OBJdbConnection3)
Call DBClose(OBJdbConnection4)
Call DBClose(OBJdbConnection5)


End Sub
'=======================================

Sub RegistrationOne(AvailOfferCount)

AvailOfferCount = Request("AvailOfferCount")

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
                <td class="labelcell"><%=Question(1)%></td>                
                <td class="fieldcell">
                <select name="Answer1_<%=OptionCount%>">
                	<option value="0"> -- Select Option -- </option>
		            <option value="Educational Consultant">Educational Consultant</option>
	                <option value="Guidance Counselor">Guidance Counselor</option>   
		            <option value="Headmaster">Headmaster</option>
		            <option value="High school student">High school student</option>    
		            <option value="Parent">Parent</option>                         
		            <option value="Principal">Principal</option> 
		            <option value="Psychologist">Psychologist</option>                       
	                <option value="Special Education Teacher">Special Education Teacher</option>                    
		            <option value="Other">Other Title</option>  
		        </select>
                </td>
             </tr>
             <tr>
                <td class="labelcell"><%=Question(2)%></td>
                <td class="fieldcell">&nbsp;<INPUT TYPE="text" VALUE="FieldName2_<%=OptionCount%>" NAME="Answer2_<%=OptionCount%>" VALUE="FieldName2_<%=OptionCount%>" SIZE="23" /></td>
            </tr>
            <tr>
                <td class="labelcell"><%=Question(3)%></td>
                <td class="fieldcell">&nbsp;<INPUT TYPE="text" NAME="Answer3_<%=OptionCount%>" SIZE="23" /></td>
             </tr>
             <tr>
                <td class="labelcell"><%=Question(4)%></td>
                <td class="fieldcell">&nbsp;<INPUT TYPE="text" NAME="Answer4_<%=OptionCount%>" SIZE="23" /></td>
            </tr>
            <tr>
                <td class="labelcell"><%=Question(5)%></td>
                <td class="fieldcell">&nbsp;<INPUT TYPE="text" NAME="Answer5_<%=OptionCount%>" SIZE="23" /></td>
             </tr>
             <tr>
                <td class="labelcell"><%=Question(6)%></td>
                <td class="fieldcell">&nbsp;<INPUT TYPE="text" NAME="Answer6_<%=OptionCount%>" SIZE="23" /></td>
            </tr>
            <tr>
                <td class="labelcell"><%=Question(7)%></td>
                <td class="fieldcell">&nbsp;<INPUT TYPE="text" NAME="Answer7_<%=OptionCount%>" SIZE="23" /></td>
            </tr>
            <tr>
                <td class="labelcell"><%=Question(8)%></td>
                <td class="fieldcell">&nbsp;<INPUT TYPE="text" NAME="Answer8_<%=OptionCount%>" SIZE="23" /></td>
            </tr>
            <tr>
                <td class="labelcell"><%=Question()%></td>
                <td class="fieldcell">&nbsp;<INPUT TYPE="text" NAME="Answer9_<%=OptionCount%>" SIZE="23" /></td>
            </tr>
            <tr>
                <td class="labelcell"><%=Question(10)%></td>
                <td class="fieldcell">
                
                
                
                <INPUT TYPE="radio" NAME="Answer10_<%=OptionCount%>" id="Answer10_y<%=OptionCount%>" VALUE="Yes" />&nbsp;&nbsp;Yes&nbsp;&nbsp;&nbsp;&nbsp;
                <INPUT TYPE="radio" NAME="Answer10_<%=OptionCount%>" id="Answer10_n<%=OptionCount%>" VALUE="No">&nbsp;&nbsp;No</td>
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
        
		'Delete existing Catagory record for this line number.
		SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & LineNumber & " AND FieldName = 'Catagory'"
		Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)
		
		'Insert Catagory record for this line number.
        SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", 'Catagory', '" & Clean(Request("Answer1_"&i)) & "'  )"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)
        
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
	
		'Delete existing Address1 record for this line number.
		SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & LineNumber & " AND FieldName = 'Address1'"
		Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)
		
		'Insert Address1 record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", 'Address1', '" & Clean(Request("Answer4_"&i)) & "'  )"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)
		
		'Delete existing City record for this line number.
		SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & LineNumber & " AND FieldName = 'City'"
		Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)
		
		'Insert City record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", 'City','" & Clean(Request("Answer5_"&i)) & "'  )"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)		

		'Delete existing State record for this line number.
		SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & LineNumber & " AND FieldName = 'State'"
		Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)
		
		'Insert State record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", 'State', '" & Clean(Request("Answer6_"&i)) & "'  )"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)
		
		'Delete existing ZipCode record for this line number.
		SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & LineNumber & " AND FieldName = 'ZipCode'"
		Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)
		
		'Insert ZipCode record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", 'ZipCode', '" & Clean(Request("Answer7_"&i)) & "'  )"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)
		
		'Delete existing School record for this line number.
		SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & LineNumber & " AND FieldName = 'School'"
		Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)
		
		'Insert School record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", 'School', '" & Clean(Request("Answer8_"&i)) & "'  )"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)
		
		'Delete existing EMailAddress record for this line number.
		SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & LineNumber & " AND FieldName = 'EMailAddress'"
		Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)
		
		'Insert EMailAddress record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", 'EMailAddress', '" & Clean(Request("Answer9_"&i)) & "'  )"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)
				
		'Delete existing Last Year record for this line number.
		SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & LineNumber & " AND FieldName = 'LastYear'"
		Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)
		
		'Insert Last Year record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", 'LastYear', '" & Clean(Request("Answer10_"&i)) & "'  )"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)
		
Next

End If	

Call EventList

End Sub 'SurveyUpdate


'================================

Sub EventList

Dim SurveyFields(20,2)

SurveyFields(2,0) = "It’s So Much Work to Be Your Friend: Helping the Child With Learning Disabilities Find Social Success"
SurveyFields(2,1) = "Rick Lavoie"

SurveyFields(3,0) =  "Intentionality, Planning and Mentoring: Essentials for Student Success"
SurveyFields(3,1) =  "Peter Lake"

SurveyFields(4,0) =  "Academic Study Strategies for College-Bound Students with Learning Disorders: The Pressured Millennials"
SurveyFields(4,1) = "Marsha Glines"

SurveyFields(5,0) = "Transitioning from High School to College"
SurveyFields(5,1) =  "Ketty Patiño González"

SurveyFields(6,0) =  "Many Colleges, Many Services"
SurveyFields(6,1) =  "Marybeth Kravets"

SurveyFields(7,0) =  "Helping Our Children Before They Go to College"
SurveyFields(7,1) =  "Imy F. Wax"

SurveyFields(8,0) = "Facilitating Meaningful Self-Advocacy Skills for Young Adults with Disabilities"
SurveyFields(8,1) =  "Ari Ne’eman"  

SurveyFields(9,0) = "The Motivation Breakthrough: 6 Secrets to Turning on the Tuned-Out Child Event (Part 1)"
SurveyFields(9,1) =  "Rick Lavoie"

SurveyFields(10,0) = "Re-Engaging Parents in the College Experience"
SurveyFields(10,1) =  "Peter Lake"

SurveyFields(11,0)  = "Millennials: Through the Gates and into the Workplace"
SurveyFields(11,1) =  "Kathryn Jarvis"

SurveyFields(12,0)  = "Interviewing at Colleges and Scared Stiff: Prep Me Now!"
SurveyFields(12,1) = "Marybeth Kravets"

SurveyFields(13,0)  = "Make It Simple: How to Know Which Support Program Works Best From the Student's Perspective"
SurveyFields(13,1) =  "Imy F. Wax"

SurveyFields(14,0) = "Supporting-College Bound Students with Asperger Syndrome Event (Part 1)"
SurveyFields(14,1) =  "Robin Lurie-Meyerkopf"

SurveyFields(15,0) = "The Motivation Breakthrough: 6 Secrets to Turning on the Tuned-Out Child Event (Part 2)"
SurveyFields(15,1) = "Rick Lavoie"

SurveyFields(16,0)  = "Understanding the Brain and Learning"
SurveyFields(16,1) = "Marsha Glines"

SurveyFields(17,0)  = "Hiring an Educational Consultant: Everything You Need and Want to Know and What to Ask"
SurveyFields(17,1) = "Marybeth Kravets and Imy F. Wax"

SurveyFields(18,0) = "Supporting-College Bound Students with Asperger Syndrome Event (Part 2)"
SurveyFields(18,1) = "Robin Lurie-Meyerkopf"

SurveyFields(19,0)  = "Self-Advocacy and What It Means To You!"
SurveyFields(19,1) = "Ari Ne’eman"

SurveyFields(20,0) =  "Testing and Documenting the Need for Accommodations in College."
SurveyFields(20,1) = "Theodore Wasserman"


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
        
        For FieldNum = 9 To 14        
	        Response.Write "<TR align=""left"" ><TD align=""left"" valign=""top""><INPUT TYPE=""radio"" NAME=""SessionTwo" & TotalLines+1 & """ VALUE=""" & SurveyFields(FieldNum, 0) & """></td><td><FONT FACE=""" & FontFace & """ COLOR=""" & HeadingColor & """   SIZE=""1""><B>" & SurveyFields(FieldNum, 0) & "</b><BR><FONT FACE=""" & FontFace & """ COLOR=""1C1C1C""  SIZE=""1""><b>Presenter: </b>" & SurveyFields(FieldNum, 1) & "</font><Br><br></td></tr>" & vbCrLf
        Next
        
        '3:00 PM Breakout Sessions
        Response.Write "<TR align=""left"" BGCOLOR=""" & TableColumnHeadingBGColor & """><TD>&nbsp;&nbsp;</td><td><FONT FACE=""" & FontFace & """ COLOR=""" & TableColumnHeadingFontColor & """  SIZE=""3"" Style=""line-height: 1.5em;""><b>3:00 p.m. Breakout Sessions</b><BR><FONT FACE=""" & FontFace & """ COLOR=""" & TableColumnHeadingFontColor & """  SIZE=""1""><i>Select one session from the list below</i></td></tr>" & vbCrLf
        Response.Write "<tr><td>&nbsp;</td></tr>" & vbCrLf
        
        For FieldNum = 15 To 20     
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
