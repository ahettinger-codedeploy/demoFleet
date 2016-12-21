<%

'CHANGE LOG

'SSR 6/30/2011 - Updated act codes

'RAS 8.24.11 commented out errorlog messaging

'SSR 6/22/2012 - Updated act codes

'SSR 6/26/2014 - Replaced by generic survey

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->

<%

'==================================================

Page = "Survey"
SurveyNumber = 598
SurveyName = "VIPSurvey.asp"

'==================================================

'Barbershop Harmony Society 
'VIP Survey 

'This survey captures the VIP attendee information
'All fields are required

'Questions:
'(1) = "VIP status"
'(2) = "Any Special Seating Requests?"

'===============================================

ActCodeList = "105895,105897"

Dim Question(2)
Question(1) = "VIP status"
Question(2) = "Any Special Seating Requests? ?"

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

'==================================================

If Clean(Request("FormName")) <> "SurveyForm" Then
	Call SurveyForm
Else
	Call UpdateSurveyAnswer
End If

OBJdbConnection.Close
Set OBJdbConnection = nothing

'==================================================

Sub SurveyForm

'Determine if required event is in shopping cart   
  
    SQLRequiredTicketCount = "SELECT Count(LineNumber) AS TicketCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Event.ActCode IN (" & ActCodeList & ")"
    Set rsRequiredTicketCount = OBJdbConnection.Execute(SQLRequiredTicketCount)
    RequiredTicketCount = rsRequiredTicketCount("TicketCount")
    rsRequiredTicketCount.Close
    Set rsRequiredTicketCount = nothing  

    If RequiredTicketCount = 0 Then
        Call Continue 
        Exit Sub   
    Else
        Call SurveyDisplay
    End If
    
  

End Sub

'=======================================

Sub SurveyDisplay

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & Title & "</TITLE>" & vbCrLf

%>

<script language="javascript">
function validate() {
    form = document.Survey;
	for (var i = 0; i < form.elements.length; i++) {
    	element = form.elements[i];
    	if( element.value == '' ) {
    	    alert('Please fill out all the required fields');
    	    return false;
    	}
    }
}
</script>

<script language="JavaScript" src="/clients/NorthTexasGolfExpo/Survey/images/gen_validatorv4.js" type="text/javascript" xml:space="preserve"></script>

<%

Response.Write "</HEAD>" & vbCrLf
Response.Write strBody & vbCrLf

%>

<!--#INCLUDE virtual="/TopNavInclude.asp"-->

<BR>
<BR>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3>Help Us Serve You Better...</H3></FONT>
<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><FONT face="Geneva, Arial, Helvetica, san-serif">Please take a minute to answer the following questions:</FONT><BR><FONT FACE="<%= FontFace %>" COLOR="#FF1909" SIZE="1">An answer is required for all the questions below.<br /><br />
<BR>
<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey" onsubmit="return validate();">
<INPUT TYPE="hidden" NAME="FormName" VALUE="SurveyForm">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">
<TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0" WIDTH="100%">
  <TR>
		<TD VALIGN="top" ALIGN="left" WIDTH="40%">
		<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">
		Please select your VIP seating status:
		</FONT>
		</TD>
		<TD VALIGN="top" ALIGN="left">
		<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">
		<select name="Answer1">
	        <option value="000"> -- Select An Answer -- </option>
            <option value="VIP">VIP</option>
            <option value="AIC">AIC</option>   
            <option value="Presidents Council">Presidents Council</option>  
		</select>
		</FONT>
		</TD>
  </TR>
    <TR>
		<TD VALIGN="top" ALIGN="left">
		<br />
		<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">
		Any Special Seating Requests?
		</FONT>
		</TD>
		<TD VALIGN="top" ALIGN="left">
		<br />
		<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">
		<INPUT TYPE="text" NAME="Answer2" SIZE=50>
		</FONT>
		</TD>
  </TR>
  </TABLE>
  <br />
  <br />
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2">Thank You for your time!</FONT><BR><BR><BR>

<INPUT TYPE="submit" VALUE="Continue"></FORM>

<script language="JavaScript" type="text/javascript"
    xml:space="preserve">//<![CDATA[
//You should create the validator only after the definition of the HTML form
  var frmvalidator  = new Validator("Survey");
    frmvalidator.addValidation("Answer1","dontselect=000","Please select a VIP Status");
    frmvalidator.addValidation("Answer2","req","Please fill out all the required fields");
//]]></script>

</CENTER>

<!--#INCLUDE virtual="/FooterInclude.asp"-->

</BODY>
</HTML>

<%
End Sub ' SurveyForm

'==================================================

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
		

End If

Call Continue

End Sub 'Update SurveyAnswer

'==================================================

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

End Sub 'Continue

'==================================================


%>


