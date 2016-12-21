<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%
Page = "Survey"
SurveyNumber = 893
SurveyName = "TicketPolicy2011.asp"

'===============================================
'Desert Classic Concours d'Elegance 

'Survey to have ticket buyer acknowledge that they've read the terms and conditions listed

NumQuestions = 1
Dim Question(2)

Question(1) = "I have read the ticket policy."


'===============================================

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

'=======================================

Sub SurveyForm 

If DocType <> "" Then
    Response.Write(DocType)
Else
    Response.Write("<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">")
End If

%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<html>
<head>

<%

'Dynamic Page Title
If Request("OrganizationNumber")<> "" And Title = "" Then
    SQLOrg = "SELECT Organization FROM Organization (NOLOCK) WHERE OrganizationNumber = " & CleanNumeric(Request("OrganizationNumber"))
    Set rsOrg = OBJdbConnection.Execute(SQLOrg)    
    Title = rsOrg("Organization") & " Ticket Sales"    
    rsOrg.Close
    Set rsOrg = nothing
End If  
 
%>

<title>="<%= Title %>"</title>

<style type="text/css">
<!--
@import url('/Clients/DesertConcours/Survey/Images/style.css');
-->
</style>

 <SCRIPT LANGUAGE="JavaScript">    

 <!-- Hide code from non-js browsers

function validateForm() {
     formObj = document.Survey;
 	var yes = 0;
 	var no = 0;

    if (eval("formObj.Answer1.checked") != true){
 		alert("You must check the box acknowledging the terms before proceeding.");
 		return false;
 		}
 	}

 // end hiding -->
 </SCRIPT>
 
</head>

<%=strBody %>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey" onSubmit='return validateForm()'>
<INPUT TYPE="hidden" NAME="FormName" VALUE="SurveyForm">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">

<! -- Table Begin -- >
<table id="tix-table" summary="surveypage" width="500" cellpadding="20">
<! -- Table Column Headings -- >
    <thead>
        <tr>
	        <th scope="col">RELEASE OF LIABILITY<br />Desert Classic Concours d'Elegance</th>
        </tr>
    </thead>
<! -- Table Footer -- >
     <tfoot>
    	<tr>
        	<td>
        	<INPUT TYPE="checkbox" NAME="Answer1" VALUE="Accept">&nbsp;I have read the above and accept the terms and conditions
            <br /><br /><br />
            <INPUT TYPE="submit" VALUE="Continue"></FORM>
        </tr>
    </tfoot>
<! -- Table Body -- >
        <tbody>
            <tr>
	            <td>The undersigned hereby releases the Desert Classic Concours d'Elegance, La Quinta Resort and Club, The City of La Quinta, its volunteers, committee, staff, sponsors, employees, ownership and all other participants, from any and all loss, liability or damage caused to the undersigned, passengers or their personal property, including claims of negligence, arising from said events to be held February 25 - February 27, 2011. The undersigned further agrees to carry full insurance coverage for all registered automobiles in the event(s) and to give permission to the Dessert Classic Concours d'Elegance and the La Quinta Resort and Club for use of any and all photographs or other images taken during  said events without restriction or compensation.</td>
            </tr>
       </tbody>
 </table>


<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%

End Sub ' SurveyForm

'==============================

Sub UpdateSurveyAnswer

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

