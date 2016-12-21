<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%
Page = "Survey"

'Adventure Theatre (6/14/2010)
'=============================
'Ticket Policy Survey

'Survey to have ticket buyer acknowledge that they've read the terms and conditions listed

SurveyNumber = 799
SurveyName = "TicketPolicySurvey.asp"
NumQuestions = 1
Dim Question(2)

Question(1) = "I have read the ticket policy."


'=================================

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

'=================================

Sub SurveyForm

%>

<html>
<head>
<title>Ticketing Policies</title>

<style type="text/css"> 
body, td {font-family: Verdana, Arial, Helvetica, sans-serif; font-style:normal; font-weight: normal; font-size:11px;}

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

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<BR>
<BR>

<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey" onSubmit='return validateForm()'>
<INPUT TYPE="hidden" NAME="FormName" VALUE="SurveyForm">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">

<TABLE WIDTH="70%">
  <TR>
	<TD>
		<p class ="header"><font size="4" color="#8e68ad"><B>Our ticketing policies have changed. Please take a moment to review our policies in full.</font></b></p>
		<br />
		Thank you for your interest in an upcoming Adventure Theatre show! In an ongoing effort to ensure the safety, security and convenience of Adventure Theatre’s patrons, performance artists and parents, we ask you take a moment to review our ticketing and performance policies.<br />
		<br />		
        <ol class="steps">
	        <li>
		        <!--<h2>Please Arrive Early</h2>-->
		        <p>Doors open for performances 10 minutes before the show begins. Seating is general admission, so please arrive early or on time to ensure your best view of the stage. If you are bringing a group of five or more to the theatre, please arrive early so that the House Management Staff can do their best to seat your group together. Please note that Adventure Theatre booked birthday parties have reserved seating in the center section of the theatre.<br /></p>
	        </li>
	        <li>
		        <!--<h2>Recording devices</h2>-->
		        <p>The operation of cameras, video equipment, phones and other recording devices is strictly prohibited at Adventure Theatre during all performances.</p>
	        </li>
	        <li>
		        <!--<h2>Late Arrivals</h2>-->
		        <p>Latecomers will be seated during appropriate pauses in the performance as a courtesy to other audience members and to ensure the safety of our performers. We do not repeat announcements or birthday party greetings to those who arrive late.</p>
	        </li>
	        <li>
		        <!--<h2>No Strollers</h2>-->
		        <p>Children under the age of 1 are admitted free of charge, but must sit in a family member’s lap. Strollers and car seats are not permitted in the theatre.</p>
	        </li>
	        <li>
		        <!--<h2>Children must be accompanied</h2>-->
		        <p>All children under the age of 16 must be accompanied by a parent or guardian to enter the theatre.</p>
	        </li>
	        <li>
		        <!--<h2>No Feed or Beverage</h2>-->
		        <p>Adventure Theatre does not permit food or beverage inside the theatre, even for our Pajama Parties or Special Events. All food must be confined to the lobby or in our party rooms.</p>
	        </li>
	        <li>
		        <!--<h2>Ticket Exchange</h2>-->
		        <p>Tickets may be exchanged for another performance of the same title up to 24 hours prior to the performance you are scheduled to attend. Adventure Theatre does not offer credits for missed performances. Please visit our Contact Us page for Box Office hours. All exchanges are subject to availability. There are no refunds.</p>
	        </li>
	        <li>
		        <!--<h2>Canceled Performances</h2>-->
		        <p>If performances are canceled due to inclement weather, Adventure Theatre will exchange your tickets for another performance date.</p>
	        </li>
	       <li>
		        <!--<h2>ASL/Sensory/Autism Friendly performances</h2>-->
		        <p>During our ASL Interpreted performances and our Sensory/Autism Friendly performances, we allow patrons to express themselves aloud. During all other performances, please be courteous to others. If your children become upset, please exit the theatre quietly into our lobby until they can calmly reenter. If you feel as though your children are too upset to finish watching the performance and you choose to leave early, our refund policy still applies.</p>
	        </li>
	    </ol>
	</TD>
  </TR>
  <TR ALIGN="center">
    <TD><INPUT TYPE="checkbox" NAME="Answer1" VALUE="Yes">&nbsp;I have read the terms and conditions listed above</FONT></TD>
  </TR>
</TABLE>
<BR>
<BR>
<INPUT TYPE="submit" VALUE="Continue"></FORM>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%
End Sub ' SurveyForm

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

