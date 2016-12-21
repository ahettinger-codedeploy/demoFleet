<!--#INCLUDE virtual=/PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=/GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=/DBOpenInclude.asp -->
<%
Page = "Survey"

SurveyNumber = 762
SurveyName = "SurveySummerMusicalTheatre.asp"

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
	Call SurveyAnswerUpdate
End If


OBJdbConnection.Close
Set OBJdbConnection = nothing

'============================

Sub SurveyForm

%>

<HTML>
<HEAD>
<TITLE>Adventure Theatre - Registration Page</TITLE>

 <SCRIPT LANGUAGE="JavaScript">    

 <!-- Hide code from non-js browsers

function validateForm() {
     formObj = document.SurveyForm;
 	var yes = 0;
 	var no = 0;
		
    if (eval("formObj.Waiver.checked") != true){
 		alert("You must check the box acknowledging the terms before proceeding.");
 		return false;
 		} 		
 		
 	if (formObj.FirstName.length) {
		for (var i=0;i<formObj.FirstName.length; i++) {
			if (eval("formObj.StudentFirstName[i].value") == ""){	        
		        alert("Please enter the Student's First Name.");
		        formObj.FirstName[i].focus();
		        return false;
		        } 
			if (eval("formObj.StudentLastName[i].value") == ""){	        
		        alert("Please enter the Student's Last Name.");
		        formObj.LastName[i].focus();
		        return false;
		        }

		    }
		} 
	else {
		if (formObj.FirstName.value == ""){	        
		    alert("Please enter the Student's First Name.");
		    formObj.FirstName.focus();
		    return false;
		    } 
		if (formObj.LastName.value == ""){	        
		    alert("Please enter the Student's Last Name.");
		    formObj.LastName.focus();
		    return false;
		    }

		} 	
 		
 	}

 // end hiding -->
 </SCRIPT>


</HEAD>

<!--#INCLUDE virtual="/TopNavInclude.asp"-->

<FORM ACTION="<%= SurveyName %>" METHOD="post" NAME="SurveyForm" onSubmit='return validateForm()'>
<INPUT TYPE="hidden" NAME="FormName" VALUE="SurveyForm">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">


<%

'Header Image
'===============
Response.Write "<TABLE CELLPADDING=""4"" CELLSPACING=""2"" BORDER=""0"" WIDTH=""80%"">" & vbCrLf
Response.Write "<TR>" & vbCrLf
Response.Write "<TD COLSPAN=""2""><IMG SRC=""/Clients/AdventureTheatre/Survey/Images/RegistrationHeader.png"" width=""600""></TD>" & vbCrLf
Response.Write "</TR>" & vbCrLf
Response.Write "</TR>" & vbCrLf
Response.Write "</TABLE>" & vbCrLf


'Survey Question
'=================
FieldName = "Referral"
FieldLabel = "Referral"
	
'Get existing OrderLineDetail values for this order if there are any.
SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND FieldName = '" & FieldName & "'"
Set rsOrderLineDetail = OBJdbConnection.Execute(SQLOrderLineDetail)
	
If Not rsOrderLineDetail.EOF Then
	Referral = rsOrderLineDetail("FieldValue")
Else
	Referral = ""
End If
	
rsOrderLineDetail.Close
Set rsOrderLineDetail = nothing

Response.Write "<BR>" & vbCrLf
Response.Write "<TABLE CELLPADDING=""4"" CELLSPACING=""2"" BORDER=""0"" WIDTH=""80%"">" & vbCrLf
Response.Write "<TR ALIGN=""center"" BGCOLOR=""#3777BF"">" & vbCrLf
Response.Write "<TD COLSPAN=""2""><FONT FACE=""" & FontFace & """ COLOR=""#ffffff"" SIZE=""2""><B>Survey Question</B></TD>" & vbCrLf
Response.Write "</TR>" & vbCrLf

Response.Write "<TR ALIGN=""center"">" & vbCrLf
Response.Write "<TD BGCOLOR=""#68C8C7""><FONT FACE=""" & FontFace & """ SIZE=""2"" ><B>How Did You Hear About Us?</B></FONT></TD>" & vbCrLf
Response.Write "<TD BGCOLOR=""#68C8C7""><INPUT TYPE=""text"" SIZE=""40"" NAME=""Referral"" VALUE=""" & Referral & """></TD>" & vbCrLf
Response.Write "</TR>" & vbCrLf

Response.Write "<TR>" & vbCrLf
Response.Write "<TD COLSPAN=""2"">&nbsp;</TD>" & vbCrLf
Response.Write "</TR>" & vbCrLf


'Student Name
'==========================	

SQLEvent = "SELECT Event.EventCode, Event.EventDate, Act.Act, Venue.Venue FROM OrderLine WITH (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event WITH (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act WITH (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue WITH (ROWLOCK) ON Event.VenueCode = Venue.VenueCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Event.SurveyNumber = " & SurveyNumber & " GROUP BY Event.EventCode, Event.EventDate, Act.Act, Venue.Venue ORDER BY Event.EventDate, Act.Act, Venue.Venue"
Set rsEvent = OBJdbConnection.Execute(SQLEvent)

Do Until rsEvent.EOF

	SQLOrderLineChild = "SELECT OrderLine.LineNumber, SeatType.SeatType FROM OrderLine WITH (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Seat.EventCode = " & rsEvent("EventCode") & " ORDER BY OrderLine.LineNumber"
	Set rsOrderLineChild = OBJdbConnection.Execute(SQLOrderLineChild)
	
	TotalLines = 0
	    
	Do Until rsOrderLineChild.EOF	    

	Response.Write "<TR ALIGN=""center"" BGCOLOR=""#6156A5"">" & vbCrLf
	Response.Write "<TD COLSPAN=""2""><FONT FACE=""" & FontFace & """ COLOR=""#ffffff"" SIZE=""2""><B>Student Information</B></TD>" & vbCrLf
	Response.Write "</TR>" & vbCrLf
   
        'First Name
        '==========================	
		FieldName = "StudentFirstName"
		FieldLabel = "StudentFirstName"
			
		'Get existing OrderLineDetail values for this order if there are any.
		SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLineChild("LineNumber") & " AND FieldName = '" & FieldName & "'"
		Set rsOrderLineDetail = OBJdbConnection.Execute(SQLOrderLineDetail)
			
		If Not rsOrderLineDetail.EOF Then
			StudentFirstName = rsOrderLineDetail("FieldValue")
		Else
			StudentFirstName = ""
		End If
			
		rsOrderLineDetail.Close
		Set rsOrderLineDetail = nothing
		
		Response.Write "<TR ALIGN=""center"">" & vbCrLf
        Response.Write "<TD BGCOLOR=""#BAB6D9""><FONT FACE=""" & FontFace & """ SIZE=""2"" ><B>Student First Name</B></FONT></TD>" & vbCrLf
		Response.Write "<TD BGCOLOR=""#BAB6D9""><INPUT TYPE=""text"" SIZE=""40"" NAME=""StudentFirstName" & TotalLines+1 & """ VALUE=""" & StudentFirstName & """></TD>" & vbCrLf
        Response.Write "</TR>" & vbCrLf
        
        'Last Name
        '==========================	
		FieldName = "StudentLastName"
		FieldLabel = "StudentLastName"
			
		'Get existing OrderLineDetail values for this order if there are any.
		SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLineChild("LineNumber") & " AND FieldName = '" & FieldName & "'"
		Set rsOrderLineDetail = OBJdbConnection.Execute(SQLOrderLineDetail)
			
		If Not rsOrderLineDetail.EOF Then
			StudentLastName = rsOrderLineDetail("FieldValue")
		Else
			StudentLastName = ""
		End If
		
		
		rsOrderLineDetail.Close
		Set rsOrderLineDetail = nothing
		
		Response.Write "<TR ALIGN=""center"">" & vbCrLf
		Response.Write "<TD BGCOLOR=""#BAB6D9""><FONT FACE=""" & FontFace & """ SIZE=""2""><B>Student Last Name</B></FONT></TD>" & vbCrLf
		Response.Write "<TD BGCOLOR=""#BAB6D9""><INPUT TYPE=""text"" SIZE=""40"" NAME=""StudentLastName" & TotalLines+1 & """ VALUE=""" & StudentLastName & """></TD>" & vbCrLf
	    Response.Write "</TR>" & vbCrLf 
	    Response.Write "<TR>" & vbCrLf
        Response.Write "<TD COLSPAN=""2"">&nbsp;</TD>" & vbCrLf
        Response.Write "</TR>" & vbCrLf
	    
	    TotalLines = TotalLines + 1
	    
	    rsOrderLineChild.MoveNext
			
	Loop

	rsOrderLineChild.Close
	Set rsOrderLineChild = nothing
	
	
	rsEvent.MoveNext
	
Loop

rsEvent.Close
Set rsEvent = nothing

Response.Write "<input type=""hidden"" name=""TotalLines"" value=""" & TotalLines & """>"


'Waiver
'=======

FieldName = "Waiver"
FieldLabel = "Waiver"
	
'Get existing OrderLineDetail values for this order if there are any.
SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND FieldName = '" & FieldName & "'"
Set rsOrderLineDetail = OBJdbConnection.Execute(SQLOrderLineDetail)
	
If Not rsOrderLineDetail.EOF Then
	Waiver = rsOrderLineDetail("FieldValue")
Else
	Waiver = ""
End If
	
rsOrderLineDetail.Close
Set rsOrderLineDetail = nothing

Response.Write "<TR ALIGN=""center"" BGCOLOR=""#F8951E"">" & vbCrLf
Response.Write "<TD COLSPAN=""2""><FONT FACE=""" & FontFace & """ COLOR=""#ffffff"" SIZE=""2""><B>Liability/Photography Waiver</B></TD>" & vbCrLf
Response.Write "</TR>" & vbCrLf

Response.Write "<TR ALIGN=""left"">" & vbCrLf
Response.Write "<TD COLSPAN=""2""BGCOLOR=""#FBDA8D"">" & vbCrLf
Response.Write "<FONT FACE=""" & FontFace & """ SIZE=""1"" ><BR><BR>By checking the YES box, I hereby grant to Adventure Theatre (“Photographer”) the absolute right and permission to take, use, reuse, publish and republish photographic portraits, pictures or video of the minor or in which they may be included for promotional purposes only. All photos will be properly protected and monitored by Adventure Theatre for inappropriate and/or unauthorized public use. I hereby waive the right that I or the minor might have to inspect or approve the finished product or products or the advertising copy or printed matter that may be used in connection therewith or the use to which it may be applied." & vbCrLf
Response.Write "<FONT FACE=""" & FontFace & """ SIZE=""1"" ><BR><BR>I hereby release, discharge and agree to save harmless and defend Photographer, his/her legal representatives or assigns, and all persons acting under his/her permission or authority or those whom he/she is acting, from any liability by virtue of any blurring, distortion, alteration, optical illusion, or use in composite form, whether intentional or otherwise, that may occur of be produced in the taking of said picture or video or in any subsequent processing thereof, as well as any publication thereof, including without limitation and claims for libel or violation of any right of publicity or privacy." & vbCrLf
Response.Write "<FONT FACE=""" & FontFace & """ SIZE=""1"" ><br><br>I hereby warrant that I am of full age and have every right to contract the minor in the above regard. I state further that by checking the YES box, that I have read the above authorization, release and agreement prior to its execution, and that I am fully familiar with the contents thereof. This release shall be binding upon the minor and me, and our respective heirs, legal representatives and assigns.</FONT><BR><BR><BR>" & vbCrLf

			
Response.Write "I have read and agree to the terms and conditions listed above&nbsp;&nbsp;&nbsp;<INPUT TYPE=""checkbox"" NAME=""Waiver"" VALUE=""Accept"">" & vbCrLf

Response.Write "</TD>" & vbCrLf
Response.Write "</TR>" & vbCrLf


'Footer
'=======

Response.Write "<TR ALIGN=""center"">" & vbCrLf
Response.Write "<TD COLSPAN=""2""><FONT FACE=""" & FontFace & """ COLOR=""" & BGColor & """ SIZE=""2""><B>Dont Forget</B></TD>" & vbCrLf
Response.Write "</TR>" & vbCrLf

Response.Write "<TR ALIGN=""center"">" & vbCrLf
Response.Write "<TD COLSPAN=""2"">" & vbCrLf
Response.Write "<FONT FACE=""" & FontFace & """ SIZE=""2"" ><BR><BR><B>Thank you for completing your registration<BR>" & vbCrLf
Response.Write "<FONT FACE=""" & FontFace & """ SIZE=""2"" >for our Summer musical Theatre Camp 2010!</B><BR><BR>" & vbCrLf
Response.Write "</TD>" & vbCrLf
Response.Write "</TR>" & vbCrLf

Response.Write "<TR>" & vbCrLf
Response.Write "<TD COLSPAN=""2"">" & vbCrLf
Response.Write "<FONT FACE=""" & FontFace & """ SIZE=""1"" >DONT FORGET TO:<BR>" & vbCrLf
Response.Write "<FONT FACE=""" & FontFace & """ SIZE=""1"" >1.&nbsp;Register your child for Before and After Care! More information<BR><BR>" & vbCrLf
Response.Write "<FONT FACE=""" & FontFace & """ SIZE=""1"" >2.&nbsp;Submit your child’s medical form<BR>" & vbCrLf 
Response.Write "<FONT FACE=""" & FontFace & """ SIZE=""1"" >&nbsp;&nbsp;&nbsp;&nbsp;This can be completed online at our website or at the following direct link:<BR>" & vbCrLf 
Response.Write "<FONT FACE=""" & FontFace & """ SIZE=""1"" >&nbsp;&nbsp;&nbsp;&nbsp;http://www.adventuretheatre.org/ATeducation2mail.html<BR></TD>" & vbCrLf
Response.Write "</TR>" & vbCrLf

Response.Write "<TR>" & vbCrLf
Response.Write "<TD COLSPAN=""2"">&nbsp;</TD>" & vbCrLf
Response.Write "</TR>" & vbCrLf

Response.Write "</TABLE>" & vbCrLf


%>  
<BR><BR>
<INPUT TYPE="submit" VALUE="Continue"></FORM>

</CENTER>

<!--#INCLUDE virtual="/FooterInclude.asp"-->

</BODY>
</HTML>

<%
End Sub ' SurveyForm

'===========================

Sub SurveyAnswerUpdate

If Session("OrderNumber") <> "" Then

For i = 1 To Request("TotalLines")

    LineNumber = i
    
    'Survey Question - Delete
    SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & LineNumber & " AND FieldName = 'Referral'"
    Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)

    'Survey Question - Insert
    SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & "," & LineNumber & ", 'Referral', '" & Clean(Request("Referral")) & "')"
    Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)

    'Waiver - Delete
    SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & LineNumber & " AND FieldName = 'Waiver'"
    Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)

    'Waiver - Insert
    SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & "," & LineNumber & ", 'Waiver', '" & Clean(Request("Waiver")) & "')"
    Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)
            
	'Delete existing record for Student First Name
	SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & LineNumber & " AND FieldName = 'StudentFirstName'"
	Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)

	'Insert First Name record for Student First Name
	SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", 'StudentFirstName', '" & Clean(Request("StudentFirstName" & i)) & "')"
	Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)

	'Delete existing Last Name record for Student Last Name
	SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & LineNumber & " AND FieldName = 'StudentLastName'"
	Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)
	
	'Insert Last Name record for Student Last Name
	SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", 'StudentLastName', '" & Clean(Request("StudentLastName" & i)) & "')"
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

End Sub 'SurveyAnswer Update


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
