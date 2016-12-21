<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->

<%

'========================================
Page = "Survey"
SurveyNumber = 887
SurveyName = "CarRegistrationOne.asp"
    
RequiredEvent = 310389  'Concours d’Elegance Exhibitor Ticket  

Dim Question(16)
NumQuestions = 15

Question(1) = "Make"
Question(2) = "Model/Series"
Question(3) = "Year"
Question(4) = "Body Style"
Question(5) = "Coachbuilder"
Question(6) = "VIN/Mfg#"
Question(7) = "Color"
Question(8) = "Judge Car"
Question(9) = "Restored"'"Trailered"
Question(10) = "Restored When"'"Trailer Size"
Question(11) = "Restore Work"'"Restored"
Question(12) = "Show History Awards"'"Restored When"
Question(13) = "Trailered to Show"'"Restore Work"
Question(14) = "Trailer Size"'"Show History Awards"
Question(15) = "Vehicle History"

'========================================

'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If


If Clean(Request("FormName")) = "SurveyUpdate" Then
    Call SurveyUpdate
Else
    Call SurveyForm
End If

OBJdbConnection.Close
Set OBJdbConnection = nothing

'========================================

Sub SurveyForm

'Determine if required event is in the shopping cart  

AvailOfferCount = 0
 
SQLRequiredTicketCount = "SELECT COUNT(OrderLine.ItemNumber) AS Count FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Seat.EventCode IN (310389) AND OrderLine.ItemType = 'Seat'"' GROUP BY Seat.EventCode ORDER BY Seat.EventCode"
Set rsRequiredTicketCount = OBJdbConnection.Execute(SQLRequiredTicketCount)
    
    If Not rsRequiredTicketCount.EOF Then
        AvailOfferCount = rsRequiredTicketCount("Count")
	End If
	
rsRequiredTicketCount.Close
Set rsRequiredTicketCount = nothing  

If AvailOfferCount  => 1 Then
    Call CarRegistrationOne(AvailOfferCount) 
Else
    Call CarRegistrationTwo
    Exit Sub  
End If 
  

End Sub

'=======================================

Sub CarRegistrationOne(AvailOfferCount) 

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
@import url('/Clients/DesertConcours/Survey/Images/style.css');
-->
</style>

<script type="text/javascript" src="/Clients/DesertConcours/Survey/Images/usableforms.js"></script> 

<script language="javascript">
var answer_name = new Array ('Answer1','Answer2','Answer3','Answer4','Answer5','Answer6','Answer7','Answer8','Answer9','Answer10','Answer11','Answer12','Answer13','Answer14','Answer15');
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
        if(document.getElementById('Answer11_'+i) != null)
            if(document.getElementById('Answer11_'+i).value.length<1)
                isAnswered = false
        if(document.getElementById('Answer12_'+i).value.length<1)
            isAnswered = false
        if(document.getElementById('Answer15_'+i).value.length<1)
            isAnswered = false
        if(document.getElementById('Answer8_y'+i).checked==false&&document.getElementById('Answer8_n'+i).checked==false)
            isAnswered = false
        if(document.getElementById('Answer9_y'+i).checked==false&&document.getElementById('Answer9_n'+i).checked==false)
            isAnswered = false
        if(document.getElementById('Answer13_y'+i).checked==false&&document.getElementById('Answer13_n'+i).checked==false)
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
function RestoreCheck(obj, num) {
    if(obj.id.indexOf("_n") != -1) {
        document.getElementById('Answer10_'+num).value = "N/A"
        document.getElementById('Answer11_'+num).select()
        insertAtCursor(document.getElementById('Answer11_'+num), "N/A")
    } else {
        document.getElementById('Answer10_'+num).value = ""
        document.getElementById('Answer11_'+num).select()
        insertAtCursor(document.getElementById('Answer11_'+num), "")
    }
}
function TrailerCheck(obj, num) {
    if(obj.id.indexOf("_n") != -1) {
        document.getElementById('Answer14_'+num).value = "N/A"
    } else {
        document.getElementById('Answer14_'+num).value = ""
    }
}
//Source: http://snippets.dzone.com/posts/show/4973
//modified version of http://www.webmasterworld.com/forum91/4686.htm
//myField accepts an object reference, myValue accepts the text string to add
function insertAtCursor(myField, myValue) {
    //IE support
    if (document.selection) {
        myField.focus();

        //in effect we are creating a text range with zero
        //length at the cursor location and replacing it
        //with myValue
        sel = document.selection.createRange();
        sel.text = myValue;

    //Mozilla/Firefox/Netscape 7+ support
    } else if (myField.selectionStart || myField.selectionStart == '0') {

        myField.focus();
        //Here we get the start and end points of the
        //selection. Then we create substrings up to the
        //start of the selection and from the end point
        //of the selection to the end of the field value.
        //Then we concatenate the first substring, myValue,
        //and the second substring to get the new value.
        var startPos = myField.selectionStart;
        var endPos = myField.selectionEnd;
        myField.value = myField.value.substring(0, startPos) + myValue + myField.value.substring(endPos, myField.value.length);
        myField.setSelectionRange(endPos+myValue.length, endPos+myValue.length);
    } else {
        myField.value += myValue;
    }
}
</script>

</head>

<%=strBody %>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<form action="<%= SurveyFileName %>" name="Survey" method="post" onsubmit="return validateForm();">
<input type="hidden" name="FormName" value="SurveyUpdate">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">
<INPUT TYPE="hidden" NAME="TotalTix" VALUE="<%= AvailOfferCount %>">

<%

For OptionCount = 1 To AvailOfferCount

%>

<! -- Table Begin -- >
<table id="tix-table" summary="surveypage" width="500">
<! -- Table Column Headings -- >
    <thead>
        <tr>
	        <th colspan="4" scope="col">EXHIBITOR APPLICATION FORM&nbsp;&nbsp;<%=OptionCount%></th>
        </tr>
    </thead>
<! -- Table Body -- >
        <tbody>
            <tr>
	            <td class="headingcell">Vehicle Information</td><td>&nbsp;</td>
            </tr>
            <tr>
                <td class="labelcell">Make</td>
                <td class="fieldcell"><INPUT TYPE="text" NAME="Answer1" SIZE="24" /></td>
             </tr>
             <tr>
                <td class="labelcell">Model/Series</td>
                <td class="fieldcell"><INPUT TYPE="text" NAME="Answer2" SIZE="24" /></td>
            </tr>
            <tr>
                <td class="labelcell">Year</td>
                <td class="fieldcell"><INPUT TYPE="text" NAME="Answer3" SIZE="24" /></td>
             </tr>
             <tr>
                <td class="labelcell">Body Style</td>
                <td class="fieldcell"><INPUT TYPE="text" NAME="Answer4" SIZE="24" /></td>
            </tr>
            <tr>
                <td class="labelcell">Coachbuilder</td>
                <td class="fieldcell"><INPUT TYPE="text" NAME="Answer5" SIZE="24" /></td>
             </tr>
             <tr>
                <td class="labelcell">VIN & Mfg#</td>
                <td class="fieldcell"><INPUT TYPE="text" NAME="Answer6" SIZE="24" /></td>
            </tr>
            <tr>
                <td class="labelcell">Color</td>
                <td class="fieldcell"><INPUT TYPE="text" NAME="Answer7" SIZE="24" /></td>
            </tr>
            <tr>
                <td class="labelcell">Do you wish your car to be judged?</td>
                <td class="fieldcellradio"><INPUT TYPE="radio" NAME="Answer8_<%=OptionCount%>" id="Answer8_y<%=OptionCount%>" VALUE="Yes" />&nbsp;&nbsp;Yes&nbsp;&nbsp;&nbsp;&nbsp;<INPUT TYPE="radio" NAME="Answer8_<%=OptionCount%>" id="Answer8_n<%=OptionCount%>" VALUE="No">&nbsp;&nbsp;No</td>
            </tr>
            <tr>
                <td class="labelcell">Restored?</td>                
                <td class="fieldcellradio"><input type="radio" name="Answer9_<%=OptionCount%>" id="Answer9_y<%=OptionCount%>" value="Yes" onclick="RestoreCheck(this,<%=OptionCount%>)">&nbsp;&nbsp;Yes&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" name="Answer9_<%=OptionCount%>" id="Answer9_n<%=OptionCount%>" value="No" onclick="RestoreCheck(this,<%=OptionCount%>)">&nbsp;&nbsp;No</td>
             </tr>
             <tr>     
                <td class="labelcell">When Restored</td>
                <td class="fieldcell"><INPUT TYPE="text" NAME="Answer10" id="Answer10_<%=OptionCount%>" SIZE="24" /></td>
            </tr>
            <tr> 
               <td class="labelcell">Briefly describe the work</td>
               <td class="fieldcell"><TEXTAREA NAME="Answer11" id="Answer11_<%=OptionCount%>" COLS="23" ROWS="3"></TEXTAREA></td>
            </tr>
            <tr>
                <td class="labelcell">Show or Race History and Awards Received</td>
                <td class="fieldcell" colspan="3"><TEXTAREA NAME="Answer12" id="Answer12_<%=OptionCount%>" COLS="23" ROWS="3"></TEXTAREA></td>
            </tr>
            <tr>
                <td class="labelcell">Vehicle History</td>
                <td class="fieldcell" colspan="3"><TEXTAREA NAME="Answer15" id="Answer15_<%=OptionCount%>" COLS="23" ROWS="3"></TEXTAREA></td>
            </tr>
            <tr>
                <td class="labelcell">Trailered to Show</td>
                <td class="fieldcellradio"><input type="radio" name="Answer13_<%=OptionCount%>" id="Answer13_y<%=OptionCount%>" value="Yes" onclick="TrailerCheck(this,<%=OptionCount%>)">&nbsp;&nbsp;Yes&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" name="Answer13_<%=OptionCount%>" id="Answer13_n<%=OptionCount%>" value="No" onclick="TrailerCheck(this,<%=OptionCount%>)">&nbsp;&nbsp;No</td>
            </tr>
            <tr>      
                <td class="labelcell">Trailer Size (ft:)</td>
                <td class="fieldcell"><INPUT TYPE="text" NAME="Answer14" id="Answer14_<%=OptionCount%>" SIZE="24"></td>
           </tr>
<! -- Table Headline -- >
        </tbody>
 </table>
<br /> 
<br />
<%

Next

%>

<INPUT TYPE="submit" VALUE="Continue"></FORM>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%

End Sub ' SurveyForm

'===========================

Sub SurveyUpdate

If Session("OrderNumber") <> "" Then

	For AnswerNumber = 1 To NumQuestions
		If Clean(Request("Answer" & AnswerNumber)) <> "" Then
				For Each Item IN Request("Answer" & AnswerNumber)
					If Item <> "" Then
						SQLUpdateSurvey = "INSERT SurveyAnswers(SurveyNumber, OrderNumber, CustomerNumber, SurveyDate, AnswerNumber, Answer, Question) VALUES(" & Clean(Request("SurveyNumber")) & ", " & Session("OrderNumber") & ", " & Session("CustomerNumber") & ", '" & Now() & "', " & AnswerNumber & ", '" & Clean(Item) & "', '" & Question(AnswerNumber) & "')"
						Set rsUpdateSurvey = OBJdbConnection.Execute(SQLUpdateSurvey)
					End If
				Next
		End If
	Next
	
	For AnswerNumber = 1 To Request("TotalTix")
	    If Clean(Request("Answer8_"&AnswerNumber)) <> "" Then
	        SQLUpdateSurvey = "INSERT SurveyAnswers(SurveyNumber, OrderNumber, CustomerNumber, SurveyDate, AnswerNumber, Answer, Question) VALUES(" & Clean(Request("SurveyNumber")) & ", " & Session("OrderNumber") & ", " & Session("CustomerNumber") & ", '" & Now() & "', 8, '" & Clean(Request("Answer8_"&AnswerNumber)) & "', '" & Question(8) & "')"
			Set rsUpdateSurvey = OBJdbConnection.Execute(SQLUpdateSurvey)
	    End If
		If Clean(Request("Answer9_"&AnswerNumber)) <> "" Then
	        SQLUpdateSurvey = "INSERT SurveyAnswers(SurveyNumber, OrderNumber, CustomerNumber, SurveyDate, AnswerNumber, Answer, Question) VALUES(" & Clean(Request("SurveyNumber")) & ", " & Session("OrderNumber") & ", " & Session("CustomerNumber") & ", '" & Now() & "', 9, '" & Clean(Request("Answer9_"&AnswerNumber)) & "', '" & Question(9) & "')"
			Set rsUpdateSurvey = OBJdbConnection.Execute(SQLUpdateSurvey)
	    End If
	    If Clean(Request("Answer13_"&AnswerNumber)) <> "" Then
	        SQLUpdateSurvey = "INSERT SurveyAnswers(SurveyNumber, OrderNumber, CustomerNumber, SurveyDate, AnswerNumber, Answer, Question) VALUES(" & Clean(Request("SurveyNumber")) & ", " & Session("OrderNumber") & ", " & Session("CustomerNumber") & ", '" & Now() & "', 13, '" & Clean(Request("Answer13_"&AnswerNumber)) & "', '" & Question(13) & "')"
			Set rsUpdateSurvey = OBJdbConnection.Execute(SQLUpdateSurvey)
	    End If
	Next
		
End If

Call CarRegistrationTwo

End Sub 'Update SurveyAnswer

'===========================

Sub CarRegistrationTwo

Response.Redirect("CarRegistrationTwo.asp")
Exit Sub


End Sub

'====================

Sub Continue

If Session("OrderNumber") <> "" Then
		
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

End Sub

'===========================

%>


