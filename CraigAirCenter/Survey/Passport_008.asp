<%

'CHANGE LOG - Update
'SSR Wednesday, July 06, 2011
'Added Question 7 & 8
'Made all answers required

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'========================================

Page = "Survey"
SurveyNumber = 421
SurveyName = "PassengerList.asp"

'========================================

'Craig Air Center (7/6/2011)
'Passenger Registration Survey

FormName = "Passenger Information"
Dim Question(9)
NumQuestions = 8

Question(1) = "First Name"
Question(2) = "Last Name"
Question(3) = "Date of Birth"
Question(4) = "Citizenship"
Question(5) = "Passport Number"
Question(6) = "Expiration Date"
Question(7) = "Gender"
Question(8) = "Residency"

'=========================================

'Check to see if Order Number exists.  
'If not, redirect to Home Page.

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

'Survey Variables

If Session("UserNumber")<> "" Then
    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "FFFFFF"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "000000"
    TableDataBGColor = "E9E9E9"
    ClientFolder= "Tix"
Else
    ClientFolder = "CraigAirCenter"
End If

'===============================================

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
 
SQLRequiredTicketCount = "SELECT COUNT(OrderLine.ItemNumber) AS Count FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.ItemType = 'Seat'"' GROUP BY Seat.EventCode ORDER BY Seat.EventCode"
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
body
{
    font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
    line-height: 1 em;
}
#rounded-corner
{
	font-size: 11px;
    font-weight: 400;
	width: 80%;
	text-align: center;
	border-collapse: collapse;
}
#rounded-corner thead th.category
{
	padding-top: 10px;
    padding-bottom: 10px;
    padding-left: 0px;
    padding-right: 1px;
	font-size: 11px;
	font-weight: 400;
	text-align: center;
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
#rounded-corner td.data
{
	padding-left: 5px;
	padding-right: 5px;
	padding-top: 5px;
	padding-bottom: 5px;
	text-align: center;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-right
{
	padding-left: 5px;
	padding-right: 5px;
	padding-top: 5px;
	padding-bottom: 5px;
	text-align: left;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-left
{
	padding-left: 5px;
	padding-right: 5px;
	padding-top: 5px;
	padding-bottom: 5px;
	text-align: right;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
</style>


<script language="javascript">
var answer_name = new Array ('Answer1','Answer2','Answer3','Answer4','Answer5','Answer6','Answer7','Answer8');
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
        if(document.getElementById('Answer7_y'+i).checked==false&&document.getElementById('Answer7_n'+i).checked==false)
            isAnswered = false  
    }
    if( isAnswered == false ) {
        alert("You are required to fill out all the questions on this form");
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

<br />
<table id="tix-table" summary="surveypage" width="600" cellpadding="10" cellspacing="0" border="0">
<tbody>
    <tr>
        <td align="left">
	        <FONT FACE="<%= FontFace %>" SIZE="4">
            <b><%= FormName %></b></FONT>
        </td>
    </tr>
    <tr>
        <td >
        <FONT FACE="<%= FontFace %>" SIZE="2"><i>Please complete the following information for each passenger</i></FONT><br />
        <br />
        <%
        For OptionCount = 1 To AvailOfferCount
            
        SQLEvent = "SELECT Event.EventCode, Event.EventDate, Act.Act, Venue.Venue FROM OrderLine WITH (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event WITH (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act WITH (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue WITH (ROWLOCK) ON Event.VenueCode = Venue.VenueCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.LineNumber = " & OptionCount & " GROUP BY Event.EventCode, Event.EventDate, Act.Act, Venue.Venue ORDER BY Event.EventDate, Act.Act, Venue.Venue"
        Set rsEvent = OBJdbConnection.Execute(SQLEvent)   
            
        %>
        
        <table id="rounded-corner" summary="surveypage">
        <thead>
	        <tr>
    	        <th scope="col" class="category-left"></th>
    	        <th scope="col" class="category" colspan="2"><b><%=rsEvent("Act")%><br /><%=FormatDateTime(rsEvent("EventDate"), vbLongDate)%></th>
    	        <th scope="col" class="category-right"></th>
            </tr>        
       </thead>
        <tbody>
             <tr>
                <td class="data-left" colspan="2"><br /><%=Question(1)%></td>
                <td class="data-right" colspan="2"><br />&nbsp;<INPUT TYPE="text" NAME="Answer1_<%=OptionCount%>" SIZE="23" /></td>
            </tr>
             <tr>
                <td class="data-left" colspan="2"><%=Question(2)%></td>
                <td class="data-right" colspan="2">&nbsp;<INPUT TYPE="text" NAME="Answer2_<%=OptionCount%>" SIZE="23" /></td>
            </tr>
            <tr>
                <td class="data-left" colspan="2"><%=Question(3)%></td>
                <td class="data-right" colspan="2">&nbsp;<INPUT TYPE="text" NAME="Answer3_<%=OptionCount%>" SIZE="23" /></td>
             </tr>
             <tr>
                <td class="data-left" colspan="2"><%=Question(4)%></td>
                <td class="data-right" colspan="2">&nbsp;<INPUT TYPE="text" NAME="Answer4_<%=OptionCount%>" SIZE="23" /></td>
            </tr>
            <tr>
                <td class="data-left" colspan="2"><%=Question(5)%></td>
                <td class="data-right" colspan="2">&nbsp;<INPUT TYPE="text" NAME="Answer5_<%=OptionCount%>" SIZE="23" /></td>
             </tr>
             <tr>
                <td class="data-left" colspan="2"><%=Question(6)%></td>
                <td class="data-right" colspan="2">&nbsp;<INPUT TYPE="text" NAME="Answer6_<%=OptionCount%>" SIZE="23" /></td>
            </tr>
            <tr>
                <td class="data-left" colspan="2"><%=Question(7)%></td>
                <td class="data-right" colspan="2">
                    <INPUT TYPE="radio" NAME="Answer7_<%=OptionCount%>" id="Answer7_y<%=OptionCount%>" VALUE="Male" />&nbsp;&nbsp;Male&nbsp;&nbsp;&nbsp;&nbsp;
                    <INPUT TYPE="radio" NAME="Answer7_<%=OptionCount%>" id="Answer7_n<%=OptionCount%>" VALUE="Female">&nbsp;&nbsp;Female
                </td>
            </tr>
            <tr>
                <td class="data-left" colspan="2"><%=Question(8)%></td>
                <td class="data-right" colspan="2">&nbsp;<INPUT TYPE="text" NAME="Answer8_<%=OptionCount%>" SIZE="23" /></td>
            </tr>

            <tr>
    	        <td class="footer-left">&nbsp;</td>
    	        <td class="footer" colspan="2">&nbsp;</td>
    	        <td class="footer-right">&nbsp;</td>
    	    </tr>
            </tbody>
            </table>
            <%
            
            rsEvent.Close
            Set rsEvent = nothing
            
            %>
            
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

    SQLRequiredTicketCount = "SELECT COUNT(OrderLine.ItemNumber) AS Count FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.ItemType = 'Seat'"' GROUP BY Seat.EventCode ORDER BY Seat.EventCode"
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
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", 'FirstName', '" & Clean(Request("Answer1_"&i)) & "'  )"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)

		'Delete existing Last Name record for this line number.
		SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & LineNumber & " AND FieldName = 'LastName'"
		Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)
		
		'Insert Last Name record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", 'LastName', '" & Clean(Request("Answer2_"&i)) & "'  )"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)
		
		'Delete existing Date of Birth record for this line number.
		SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & LineNumber & " AND FieldName = 'DOB'"
		Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)
		
		'Insert Date of Birth record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", 'DOB', '" & Clean(Request("Answer3_"&i)) & "'  )"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)
		
		'Delete existing Citizenship record for this line number.
		SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & LineNumber & " AND FieldName = 'Citizenship'"
		Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)
		
		'Insert Date of Citizenship record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", 'Citizenship', '" & Clean(Request("Answer4_"&i)) & "'  )"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)		
		
		'Delete existing Passport Number record for this line number.
		SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & LineNumber & " AND FieldName = 'PassportNumber'"
		Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)
		
		'Insert Passport Number record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", 'PassportNumber', '" & Clean(Request("Answer5_"&i)) & "'  )"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)
		
		'Delete existing Passport Expiration Date record for this line number.
		SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & LineNumber & " AND FieldName = 'PassExp'"
		Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)
		
		'Insert Passport Expiration Date record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", 'PassExp','" & Clean(Request("Answer6_"&i)) & "'  )"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)
		
		'Delete existing Gender record for this line number.
		SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & LineNumber & " AND FieldName = 'Gender'"
		Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)
		
		'Insert Date of Gender record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", 'Gender', '" & Clean(Request("Answer7_"&i)) & "'  )"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)	
				
		'Delete existing Residency record for this line number.
		SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & LineNumber & " AND FieldName = 'Residency'"
		Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)
		
		'Insert Date of Residency record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", 'Residency', '" & Clean(Request("Answer8_"&i)) & "'  )"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)
		


	Next	
	
End If	

Call Continue

End Sub 'SurveyUpdate

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