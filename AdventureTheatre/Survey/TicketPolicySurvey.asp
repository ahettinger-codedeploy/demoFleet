<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<!--#INCLUDE VIRTUAL="CalcCustomerFeeInclude.asp"-->
<%
Page = "Survey"

'Adventure Theatre - 7/19/2010
'This survey counts the number of times a discount code has been used by the patron. 
'Discount code "Garden10" - Max: 2 tickets


'Initialize Parameters
Page = "Survey"
SurveyNumber = 799
SurveyName = "TicketPolicySurvey.asp"

DiscountNumberList = "48575" 'Valid discount codes
DiscountAmount = 1.0

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

'Check to see if this is a Comp Order. If so, bypass this survey.
If Session("OrderTypeNumber") = 5 Then
	Call Continue
End if


If Clean(Request("FormName")) = "SurveyForm" Then
	Call SurveyForm
ElseIf Clean(Request("FormName")) = "UpdateSurveyAnswer" Then
	Call UpdateSurveyAnswer
Else
	Call CheckCurrentOrder
End If


OBJdbConnection.Close
Set OBJdbConnection = nothing

'==============================
Sub CheckCurrentOrder

'Check if there is a discount code to the current order
SQLCurrentDiscount = "SELECT OrderLine.DiscountTypeNumber FROM OrderLine (NOLOCK) WHERE OrderLine.DiscountTypeNumber IN (" & DiscountNumberList & ") AND OrderLine.OrderNumber = " & CleanNumeric(Session("OrderNumber"))
Set rsCurrentDiscount = OBJdbConnection.Execute(SQLCurrentDiscount)

If Not rsCurrentDiscount.EOF Then 
		CurrentDiscountFound = True
		CurrentDiscountTypeNumber = rsCurrentDiscount("DiscountTypeNumber")
End If

rsCurrentDiscount.Close
Set rsCurrentDiscount = nothing


'If discount found on order proceed to check past order
'otherwise bypass restriction 
If CurrentDiscountFound Then 
	Call CheckPastOrders(CurrentDiscountTypeNumber)
Else
	Call SurveyForm
End If



End Sub 'CheckCurrentOrder

'==============================
Sub CheckPastOrders(CurrentDiscountTypeNumber)

'Check if customer has used this discount code before
SQLPastDiscount = "SELECT OrderLine.DiscountTypeNumber FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE CustomerNumber = " & CleanNumeric(Session("CustomerNumber")) & " AND OrderLine.DiscountTypeNumber = " & CurrentDiscountTypeNumber & " AND OrderHeader.OrderNumber <> " & CleanNumeric(Session("OrderNumber")) & " ORDER BY OrderLine.DiscountTypeNumber"
Set rsPastDiscount = OBJdbConnection.Execute(SQLPastDiscount)

If Not rsPastDiscount.EOF Then
    PastDiscountFound = True
End If

rsPastDiscount.Close
Set rsPastDiscount = nothing

'If discount found on past orders proceed to apply discount
'otherwise bypass restriction
If PastDiscountFound Then 
	Call ApplyDiscount(CurrentDiscountTypeNumber)
Else
	Call SurveyForm
End If


End Sub 'CheckPastOrders

'==============================

Sub ApplyDiscount(CurrentDiscountTypeNumber)

CurrentDiscountTypeNumber =  48575 
DiscountCode ="GARDEN10"
TotalFreeTickets = 2

AppliedCount = 0
NumberFreeTickets = 0


SQLRemove = "UPDATE OrderLine WITH (ROWLOCK) SET DiscountTypeNumber = 0, Discount = 0 WHERE OrderNumber = " & Session("OrderNumber") & " AND DiscountTypeNumber = " & CurrentDiscountTypeNumber & " "
Set rsRemove = OBJdbConnection.Execute(SQLRemove)

'Determine the number of tickets for which this customer has already received a discount
SQLApplied = "SELECT COUNT(OrderLine.LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON OrderLine.OrderNumber = OrderHeader.OrderNumber WHERE OrderHeader.CustomerNumber = " & Session("CustomerNumber") & " AND OrderLine.DiscountTypeNumber = " & CurrentDiscountTypeNumber & " AND OrderLine.StatusCode = 'S'"
Set rsApplied = OBJdbConnection.Execute(SQLApplied)
AppliedCount = rsApplied("TicketCount")
rsApplied.Close
Set rsApplied = nothing

NumberFreeTickets = (TotalFreeTickets - AppliedCount)
    
If CInt(NumberFreeTickets) > 0 Then 'It is ok to give further discounts

				DiscountApplied = "N"

				SQLLineNo = "SELECT TOP(" & NumberFreeTickets & ") LineNumber FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " ORDER BY LineNumber"
				Set rsLineNo = OBJdbConnection.Execute(SQLLineNo)

				If Not rsLineNo.EOF Then
							Do While Not rsLineNo.EOF
									SQLApplyDiscount = "UPDATE OrderLine WITH (ROWLOCK) SET Discount = 5, Price = (Price - 5), DiscountTypeNumber = " & CurrentDiscountTypeNumber & " WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsLineNo("LineNumber")& ""
									Set rsApplyDiscount = OBJdbConnection.Execute(SQLApplyDiscount)
									DiscountApplied = "Y"
									rsLineNo.movenext
							Loop
				End If

				rsLineNo.Close
				Set rsLineNo = Nothing
				        
				If DiscountApplied = "Y" Then
					Call CongratulationsPage(NumberFreeTickets)
				Else
					Call WarningPage(DiscountCode,TotalFreeTickets)
				End If


Else
        Call WarningPage(DiscountCode,TotalFreeTickets)
End If

End Sub 'ApplyDiscount	

'==============================

Sub WarningPage(DiscountCode,TotalFreeTickets)

%>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<%

Session("SurveyComplete") = Session("OrderNumber")

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & Title & "</TITLE>" & vbCrLf
Response.Write "</HEAD>" & vbCrLf
Response.Write "<BODY BGCOLOR=" & BGColor & " LINK="& LinkColor & " ALINK=" & ALinkColor & " VLINK=" & VLinkColor & " leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0 " & BodyParameters & ">" & vbCrLf
Response.Write "<H3>SORRY</H3>" & vbCrLf
Response.Write "<CENTER><TABLE><TR><TD ALIGN=""center""><FONT FACE=" & FontFace & " COLOR=" & FontColor & " SIZE=""2"">The discount code <B>" & DiscountCode & "</B> is no longer valid.<BR>" & vbCrLf
Response.Write "<FONT FACE=" & FontFace & " COLOR=" & FontColor & " SIZE=""2"">The maximum usage of " & TotalFreeTickets & " tickets has already been reached.<BR><BR>" & vbCrLf

If Session("UserNumber") = "" Then
%>
<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey">
<INPUT TYPE="hidden" NAME="FormName" VALUE="SurveyForm">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">
<%
Else
%>
<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey">
<INPUT TYPE="hidden" NAME="FormName" VALUE="SurveyForm">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">
<%
End If

style="width: 5em"
Response.Write "<INPUT TYPE=""submit"" VALUE=""OK"" STYLE=""width: 5em"" id=1 name=1></FORM></CENTER></TD></TR></TABLE></CENTER><BR><BR>" & vbCrLf
Response.Write "</BODY>" & vbCrLf
Response.Write "</HTML>" & vbCrLf

%>

<!--#INCLUDE virtual="FooterInclude.asp"-->

<%			

End Sub 'WarningPage

'==============================
Sub SurveyForm

%>

<html>
<head>
<title>Ticketing Policies</title>

<style type="text/css"> 
body, td {font-family: Verdana, Arial, Helvetica, sans-serif; font-style:normal; font-weight: normal; font-size:11px;}

ol.steps {
	margin: 20px 0;
	/*--Bg of the order numbers--*/
	background: url(/images/tangerine.gif) repeat-y; 
	/*--Distance between the order numbers--*/
	padding: 0 0 0 35px; 
	
}
ol.steps li {
	margin: 0;
	padding: 10px 10px;
	
	/*--number font color-*/
	color: #000000;
	font-size: 1.0em;
	font-weight: normal;
	
   /*--The bevel look is styled with various colors in the border properties below--*/
	border-top: 1px solid #fff8ab;
	border-bottom: 1px solid #b67d06;
	border-right: 1px solid #ffffda;
	border-left: 1px solid #977629;
	/*--background text color-*/
	background: #FBDA8D;
}

ol.steps li h2 {
	font-size: 1.0em;
	padding: 5px 0;
	margin-bottom: 10px;
	border-bottom: 1px dashed #333;
	color: #ffffff;
}
ol.steps li p {
	color: #000000;
	font-size: .8em;
	font-weight: normal;
	line-height: 1.5em;
}






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
<INPUT TYPE="hidden" NAME="FormName" VALUE="UpdateSurveyAnswer">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">


<TABLE CELLPADDING="4" CELLSPACING="2" BORDER="0" WIDTH="80%">
<TR>
<TD COLSPAN="2"><IMG SRC="/Clients/AdventureTheatre/Survey/Images/TicketingPolicy.png" width="600"></TD>
</TR>
     <TR>
	    <TD>
	    <br />
	    Thank you for your interest in an upcoming Adventure Theatre show! In an ongoing effort to ensure the safety, security and convenience of Adventure Theatre’s patrons, performance artists and parents, we ask you take a moment to review our ticketing and performance policies. Our ticketing policies have changed. Please take a moment to review our policies in full.<br />
	    <br />		
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

'============================

Sub Continue
				
Session("SurveyComplete") = Session("OrderNumber")
If Session("UserNumber") = "" Then
	Response.Redirect("/Ship.asp")
Else
	Response.Redirect("/Management/AdvanceShip.asp")
End If		

End Sub 'Continue

'==============================




%>