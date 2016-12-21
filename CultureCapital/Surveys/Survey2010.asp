<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%

'Cultural Alliance of Greater Washington (3/29/10)
'How Did You Hear About Us Survey


Page = "Survey"
SurveyNumber = 746
SurveyName = "Survey2010.asp"
NumQuestions = 17

SurveyTitle = "Culture Capital – 2010 Survey"
SurveyHeader = "TICKETPLACE is looking to our patrons to assist us in enhancing our services by completing this survey.  We thank you for participating in this survey and for patronizing TICKETPLACE!"
SurveyFooter = "Thank you for taking the time to complete the survey.  TICKETPLACE.org is a program of the Cultural Alliance of Greater Washington a nonprofit serving the region for over 30 years."

Dim Question(18)

Question(1) = "1. How long have you been a TICKETPLACE customer?"
Question(2) = "2. Since TICKETPLACE launched its new ticketing system on Jan. 1, 2010, how many times have you purchased tickets through TICKETPLACE? (please select one answer)"
Question(3) = "3. In the year prior to TICKETPLACEs new ticketing system, how many times did you purchase tickets through TICKETPLACE? (please select one answer)"
Question(4) = "4. When you purchase from TICKETPLACE, who are you typically buying for?"
Question(5) = "5. What day/s are you most likely to review the TICKETPLACE offerings? (please select all that apply)"
Question(6) = "6. How far in advance do you typically purchase TICKETPLACE tickets? (please select one answer)"
Question(7) = "7. Please select the top three statements that best reflect how you review TICKETPLACE offerings before you purchase"
Question(8) = "8. How do you typically access TICKETPLACE? (please select one answer)"
Question(9) = "9. TICKETPLACE inventory changes daily.  How would you like to be notified of new ticket availability? (please select all that apply)"
Question(10) = "10. Please indicate the ways that you purchase tickets to cultural events in a typical year.  (please select all that apply)"
Question(11) = "11. Beyond TICKETPLACE, what other ticket outlets do you use for half-price or discounted tickets?"
Question(12) = "12. What ticket outlets do you use for full-price tickets?"
Question(13) = "13. What is keeping you from purchasing more often from TICKETPLACE? (please rank in order of importance, with 1 being most important)"
Question(14) = "14. What types of ticketed arts/culture events do you attend more than once per year? (check all that apply)"
Question(15) = "15. What is your age?"
Question(16) = "16. How could TICKETPLACE become more useful to you?"
Question(17) = "17. If you would like to be entered in drawings for one of two $50 American Express gift certificates, please enter your e-mail address."



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

'=============================

Sub SurveyForm

%>
<HTML>
<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<TITLE>" & Title & "</TITLE>" & vbCrLf

<style type="text/css">
body, td {font-family: Arial, Arial, Helvetica, sans-serif; font-style:normal; font-weight: normal; font-size:12px;}
.title {text-align: center; font-size:18px; font-weight: bold}
.header {text-align: center}
.footer {text-align: center}
.question {font-weight: bold}
</style> 

<HEAD>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<HEAD>

</HEAD>

<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey">
<INPUT TYPE="hidden" NAME="FormName" VALUE="SurveyForm">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">
<TABLE WIDTH="100%">
  <TR>
     <TD><p class = title><%= SurveyTitle %></p><br /></TD>
  </TR>
  <TR>
  <TD><p class = header><%= SurveyHeader %></p><br /></TD>
  <TR>
    <TD>
    <p class = question><%= Question(1) %></p>
    <INPUT TYPE="text" NAME="Answer1" SIZE=25><BR>
    <br />
    <p class = question><%= Question(2) %></p>
    <INPUT TYPE="radio" NAME="Answer2" VALUE="0">&nbsp;0<BR>
    <INPUT TYPE="radio" NAME="Answer2" VALUE="1">&nbsp;1<BR>
    <INPUT TYPE="radio" NAME="Answer2" VALUE="2">&nbsp;2<BR>
    <INPUT TYPE="radio" NAME="Answer2" VALUE="3">&nbsp;3<BR>
    <INPUT TYPE="radio" NAME="Answer2" VALUE="4-6">&nbsp;4-6<BR>
    <INPUT TYPE="radio" NAME="Answer2" VALUE="7-9">&nbsp;7-9<BR>
    <INPUT TYPE="radio" NAME="Answer2" VALUE="10 or more">&nbsp;10 or more<BR>
    <br />
   <p class = question><%= Question(3) %></p>
    <INPUT TYPE="radio" NAME="Answer3" VALUE="0">&nbsp;0<BR>
    <INPUT TYPE="radio" NAME="Answer3" VALUE="1">&nbsp;1<BR>
    <INPUT TYPE="radio" NAME="Answer3" VALUE="2">&nbsp;2<BR>
    <INPUT TYPE="radio" NAME="Answer3" VALUE="3">&nbsp;3<BR>
    <INPUT TYPE="radio" NAME="Answer3" VALUE="4-6">&nbsp;4-6<BR>
    <INPUT TYPE="radio" NAME="Answer3" VALUE="7-9">&nbsp;7-9<BR>
    <INPUT TYPE="radio" NAME="Answer3" VALUE="10 or more">&nbsp;10 or more<BR>
    <br />
    <p class = question><%= Question(4) %></p>
    <INPUT TYPE="checkbox" NAME="Answer4" VALUE="Yourself">&nbsp;Yourself<BR>		
    <INPUT TYPE="checkbox" NAME="Answer4" VALUE="You and a guest">&nbsp;You and a guest<BR>		
    <INPUT TYPE="checkbox" NAME="Answer4" VALUE="You plus two or more people">&nbsp;You plus two or more people<BR>		
    <INPUT TYPE="checkbox" NAME="Answer4" VALUE="N/A – Have not purchased from TICKETPLACE">&nbsp;N/A – Have not purchased from TICKETPLACE<BR>	
    <INPUT TYPE="checkbox" NAME="Answer4" VALUE="Other">&nbsp;Other (please specify) <INPUT TYPE="text" NAME="Answer4" SIZE=25><BR>	
    <br />
    <p class = question><%= Question(5) %></p>
    <INPUT TYPE="checkbox" NAME="Answer5" VALUE="Monday">&nbsp;Monday<BR>
    <INPUT TYPE="checkbox" NAME="Answer5" VALUE="Tuesday">&nbsp;Tuesday<BR>
    <INPUT TYPE="checkbox" NAME="Answer5" VALUE="Wednesday">&nbsp;Wednesday<BR>
    <INPUT TYPE="checkbox" NAME="Answer5" VALUE="Thursday">&nbsp;Thursday<BR>
    <INPUT TYPE="checkbox" NAME="Answer5" VALUE="Friday">&nbsp;Friday<BR>
    <INPUT TYPE="checkbox" NAME="Answer5" VALUE="Saturday">&nbsp;Saturday<BR>
    <INPUT TYPE="checkbox" NAME="Answer5" VALUE="Sunday">&nbsp;Sunday<BR>
    <br />
    <p class = question><%= Question(6) %></p>
    <INPUT TYPE="radio" NAME="Answer6" VALUE="Day-of-show">&nbsp; Day-of-show<BR>
    <INPUT TYPE="radio" NAME="Answer6" VALUE="One day before the show">&nbsp;One day before the show<BR>
    <INPUT TYPE="radio" NAME="Answer6" VALUE="Two to seven days before the show">&nbsp;Two to seven days before the show<BR>
    <INPUT TYPE="radio" NAME="Answer6" VALUE="A week or longer before the show">&nbsp;A week or longer before the show<BR>
    <INPUT TYPE="radio" NAME="Answer6" VALUE="N/A – Have not purchased from TICKETPLACE">&nbsp;N/A – Have not purchased from TICKETPLACE<BR>
    <br />
    <p class = question><%= Question(7) %></p>
    <INPUT TYPE="checkbox" NAME="Answer7" VALUE="Specific performances on specific dates">&nbsp;Specific performances on specific dates<BR>
    <INPUT TYPE="checkbox" NAME="Answer7" VALUE="A variety of performances on specific dates">&nbsp;A variety of performances on specific dates<BR>
    <INPUT TYPE="checkbox" NAME="Answer7" VALUE="Specific performances with a variety of dates">&nbsp;Specific performances with a variety of dates<BR> 
    <INPUT TYPE="checkbox" NAME="Answer7" VALUE="I am very flexible and will purchase tickets for whatever catches my eye">&nbsp;I am very flexible and will purchase tickets for whatever catches my eye<BR>
    <INPUT TYPE="checkbox" NAME="Answer7" VALUE="Performances anywhere throughout Metro DC">&nbsp;Performances anywhere throughout Metro DC<BR>
    <INPUT TYPE="checkbox" NAME="Answer7" VALUE="Performances in DC only">&nbsp;Performances in DC only<BR>
    <INPUT TYPE="checkbox" NAME="Answer7" VALUE="Performances in Virginia only">&nbsp;Performances in Virginia only<BR>  
    <INPUT TYPE="checkbox" NAME="Answer7" VALUE="Performances in Maryland only">&nbsp;Performances in Maryland only<BR> 
    <br />
    <p class = question><%= Question(8) %></p>
    <INPUT TYPE="radio" NAME="Answer8" VALUE="Bookmarked on my computer">&nbsp;Bookmarked on my computer<BR>
    <INPUT TYPE="radio" NAME="Answer8" VALUE="Typing TICKETPLACE.org into my web browser">&nbsp;Typing TICKETPLACE.org into my web browser<BR>
    <INPUT TYPE="radio" NAME="Answer8" VALUE="Opening the TICKETPLACE e-mail alert">&nbsp;Opening the TICKETPLACE e-mail alert<BR>
    <INPUT TYPE="radio" NAME="Answer8" VALUE="Following TICKETPLACEDC on Twitter">&nbsp;Following TICKETPLACEDC on Twitter<BR>
    <INPUT TYPE="radio" NAME="Answer8" VALUE="Through a search engine">&nbsp;Through a search engine<BR>
    <INPUT TYPE="radio" NAME="Answer8" VALUE="Visiting the retail outlet in downtown DC">&nbsp;Visiting the retail outlet in downtown DC<BR>
    <INPUT TYPE="radio" NAME="Answer8" VALUE="Other">&nbsp;Other (please specify) <INPUT TYPE="text" NAME="Answer8" SIZE=25><BR>	
    <br />
    <p class = question><%= Question(9) %></p>
    <INPUT TYPE="checkbox" NAME="Answer9" VALUE="E-mail from TICKETPLACE notifying me when new performances are added">&nbsp;E-mail from TICKETPLACE notifying me when new performances are added<BR>
    <INPUT TYPE="checkbox" NAME="Answer9" VALUE="TICKETPLACEDC on Twitter">&nbsp;TICKETPLACEDC on Twitter<BR>
    <INPUT TYPE="checkbox" NAME="Answer9" VALUE="Not necessary to be notified">&nbsp;Not necessary to be notified<BR>
    <INPUT TYPE="checkbox" NAME="Answer9" VALUE="Other">&nbsp;Other (please specify) <INPUT TYPE="text" NAME="Answer9" SIZE=25><BR>	
    <br />
    <p class = question><%= Question(10) %></p>
    <INPUT TYPE="checkbox" NAME="Answer10" VALUE="Half-price tickets from TICKETPLACE">&nbsp;Half-price tickets from TICKETPLACE<BR>
    <INPUT TYPE="checkbox" NAME="Answer10" VALUE="Half-price tickets from another source">&nbsp;Half-price tickets from another source<BR>
    <INPUT TYPE="checkbox" NAME="Answer10" VALUE="Discounted tickets from the presenter">&nbsp;Discounted tickets from the presenter<BR>
    <INPUT TYPE="checkbox" NAME="Answer10" VALUE="Discounted (other than half-price) tickets from another source">&nbsp;Discounted (other than half-price) tickets from another source<BR>
    <INPUT TYPE="checkbox" NAME="Answer10" VALUE="Full-price, individual-show tickets from presenter">&nbsp;Full-price, individual-show tickets from presenter<BR>
    <INPUT TYPE="checkbox" NAME="Answer10" VALUE="Subscriber tickets">&nbsp;Subscriber tickets<BR>
    <br />    
    <p class = question><%= Question(11) %></p>
    <INPUT TYPE="text" NAME="Answer11" SIZE=25><BR>
    <br />
   <p class = question><%= Question(12) %></p>
     <INPUT TYPE="text" NAME="Answer12" SIZE=25><BR>
    <br />
    <p class = question><%= Question(13) %></p>    

    Not a wide enough selection of events<br />
    <INPUT TYPE="radio" NAME="Answer13A" VALUE="1">1<INPUT TYPE="radio" NAME="Answer13A" VALUE="2">2<INPUT TYPE="radio" NAME="Answer13A" VALUE="3">3<INPUT TYPE="radio" NAME="Answer13A" VALUE="4">4<INPUT TYPE="radio" NAME="Answer13A" VALUE="5">5<INPUT TYPE="radio" NAME="Answer13A" VALUE="6">6<br />
    <br />
    Not enough advance-purchase tickets<br />
    <INPUT TYPE="radio" NAME="Answer13B" VALUE="1">1<INPUT TYPE="radio" NAME="Answer13B" VALUE="2">2<INPUT TYPE="radio" NAME="Answer13B" VALUE="3">3<INPUT TYPE="radio" NAME="Answer13B" VALUE="4">4<INPUT TYPE="radio" NAME="Answer13B" VALUE="5">5<INPUT TYPE="radio" NAME="Answer13B" VALUE="6">6<br />
    <br />
    Website or ordering is difficult to use<br />
    <INPUT TYPE="radio" NAME="Answer13C" VALUE="1">1<INPUT TYPE="radio" NAME="Answer13C" VALUE="2">2<INPUT TYPE="radio" NAME="Answer13C" VALUE="3">3<INPUT TYPE="radio" NAME="Answer13C" VALUE="4">4<INPUT TYPE="radio" NAME="Answer13C" VALUE="5">5<INPUT TYPE="radio" NAME="Answer13C" VALUE="6">6<br />
    <br />   
    Even at half-price, tickets are too expensive<br />
    <INPUT TYPE="radio" NAME="Answer13D" VALUE="1">1<INPUT TYPE="radio" NAME="Answer13D" VALUE="2">2<INPUT TYPE="radio" NAME="Answer13D" VALUE="3">3<INPUT TYPE="radio" NAME="Answer13D" VALUE="4">4<INPUT TYPE="radio" NAME="Answer13D" VALUE="5">5<INPUT TYPE="radio" NAME="Answer13D" VALUE="6">6<br />
    <br />
    Ticket service fees are too high<br />
    <INPUT TYPE="radio" NAME="Answer13E" VALUE="1">1<INPUT TYPE="radio" NAME="Answer13E" VALUE="2">2<INPUT TYPE="radio" NAME="Answer13D" VALUE="3">3<INPUT TYPE="radio" NAME="Answer13E" VALUE="4">4<INPUT TYPE="radio" NAME="Answer13E" VALUE="5">5<INPUT TYPE="radio" NAME="Answer13E" VALUE="6">6<br />
    <br />
   Other (please specify) <INPUT TYPE="text" NAME="Answer8" SIZE=25><BR>
    <INPUT TYPE="radio" NAME="Answer13E" VALUE="1">1<INPUT TYPE="radio" NAME="Answer13E" VALUE="2">2<INPUT TYPE="radio" NAME="Answer13D" VALUE="3">3<INPUT TYPE="radio" NAME="Answer13E" VALUE="4">4<INPUT TYPE="radio" NAME="Answer13E" VALUE="5">5<INPUT TYPE="radio" NAME="Answer13F" VALUE="6">6<br />
    <p class = question><%= Question(14) %></p>
    <INPUT TYPE="checkbox" NAME="Answer14" VALUE="Theatre">&nbsp;Theatre<BR>
    <INPUT TYPE="checkbox" NAME="Answer14" VALUE="Dance">&nbsp;Dance<BR> 
    <INPUT TYPE="checkbox" NAME="Answer14" VALUE="Music Opera">&nbsp;Music Opera<BR>
    <INPUT TYPE="checkbox" NAME="Answer14" VALUE="Music Symphony">&nbsp;Music Symphony<BR>
    <INPUT TYPE="checkbox" NAME="Answer14" VALUE="Music Concerts">&nbsp;Music Concerts<BR> 
    <INPUT TYPE="checkbox" NAME="Answer14" VALUE="Film">&nbsp;Film<BR>
    <INPUT TYPE="checkbox" NAME="Answer14" VALUE="Classes">&nbsp;Classes<BR>
    <INPUT TYPE="checkbox" NAME="Answer14" VALUE="Lectures">&nbsp;Lectures<BR>
    <INPUT TYPE="checkbox" NAME="Answer14" VALUE="Other">&nbsp;Other (please specify) <INPUT TYPE="text" NAME="Answer14" SIZE=25><BR>	
    <br />
    <p class = question><%= Question(15) %></p>
    <INPUT TYPE="checkbox" NAME="Answer15" VALUE="Under 18">&nbsp;Under 18<BR> 
    <INPUT TYPE="checkbox" NAME="Answer15" VALUE="18-34">&nbsp;18-34<BR>
    <INPUT TYPE="checkbox" NAME="Answer15" VALUE="35-44">&nbsp;35-44<BR>
    <INPUT TYPE="checkbox" NAME="Answer15" VALUE="45-54">&nbsp;45-54<BR>
    <INPUT TYPE="checkbox" NAME="Answer15" VALUE="55-64">&nbsp;55-64<BR>
    <INPUT TYPE="checkbox" NAME="Answer15" VALUE="65 and over">&nbsp;65 and over<BR>
    <br />
    <p class = question><%= Question(16) %></p>
    <textarea name="Answer17" cols="40" rows="5"></textarea>
    <BR />  
    <p class = question><%= Question(17) %></p>
    <INPUT TYPE="text" NAME="Answer17" SIZE=25><BR>
    <br />  
  </TR>
  <TR>
     <TD><%= SurveyFooter %><br /><br /><INPUT TYPE="submit" VALUE="Continue"></FORM></TD>
  </TR>
</TABLE>

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


