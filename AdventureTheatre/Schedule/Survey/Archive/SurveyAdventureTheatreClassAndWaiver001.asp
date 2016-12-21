<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%
Page = "Survey"

SurveyNumber = 676
SurveyName = "SurveyAdventureTheatreClassAndWaiver.asp"

'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If

Dim SurveyFields(11,2)

SurveyFields(0,0) = "StudentFirstName"
SurveyFields(0,1) = "Student First Name"
SurveyFields(0,2) = "30"
SurveyFields(1,0) = "StudentLastName"
SurveyFields(1,1) = "Student Last Name"
SurveyFields(1,2) = "30"
SurveyFields(2,0) = "Gender"
SurveyFields(2,1) = "Gender"
SurveyFields(2,2) = "1"
SurveyFields(3,0) = "Age"
SurveyFields(3,1) = "Age"
SurveyFields(3,2) = "3"
SurveyFields(4,0) = "DateOfBirth"
SurveyFields(4,1) = "Date of Birth"
SurveyFields(4,2) = "10"
SurveyFields(5,0) = "Grade"
SurveyFields(5,1) = "Grade"
SurveyFields(5,2) = "5"
SurveyFields(6,0) = "School"
SurveyFields(6,1) = "School"
SurveyFields(6,2) = "30"
SurveyFields(7,0) = "ParentGuardianName"
SurveyFields(7,1) = "Parent/Guardian Name"
SurveyFields(7,2) = "30"
SurveyFields(8,0) = "EmergencyContactName"
SurveyFields(8,1) = "Emergency Contact Name"
SurveyFields(8,2) = "30"
SurveyFields(9,0) = "EmergencyPhoneNumber"
SurveyFields(9,1) = "Emergency Contact Phone Number"
SurveyFields(9,2) = "15"
SurveyFields(10,0) = "Waiver"
SurveyFields(10,1) = "Waiver"
SurveyFields(10,2) = "1"

WaiverText = "By checking the YES box, I hereby grant to Adventure Theatre (“Photographer”) the absolute right and permission to take, use, reuse, publish and republish photographic portraits, pictures or video of the minor or in which they may be included for promotional purposes only. All photos will be properly protected and monitored by Adventure Theatre for inappropriate and/or unauthorized public use.  I hereby waive the right that I or the minor might have to inspect or approve the finished product or products or the advertising copy or printed matter that may be used in connection therewith or the use to which it may be applied.<BR><BR>I hereby release, discharge and agree to save harmless and defend Photographer, his/her legal representatives or assigns, and all persons acting under his/her permission or authority or those whom he/she is acting, from any liability by virtue of any blurring, distortion, alteration, optical illusion, or use in composite form, whether intentional or otherwise, that may occur of be produced in the taking of said picture or video or in any subsequent processing thereof, as well as any publication thereof, including without limitation and claims for libel or violation of any right of publicity or privacy.<BR><BR>I hereby warrant that I am of full age and have every right to contract the minor in the above regard. I state further that by checking the YES box, that I have read the above authorization, release and agreement prior to its execution, and that I am fully familiar with the contents thereof. This release shall be binding upon the minor and me, and our respective heirs, legal representatives and assigns."



If Clean(Request("FormName")) <> "SurveyForm" Then
	Call SurveyForm
Else
	Call UpdateSurveyAnswer
End If

OBJdbConnection.Close
Set OBJdbConnection = nothing

Sub SurveyForm

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & Title & "</TITLE>" & vbCrLf
%>
<SCRIPT LANGUAGE="JavaScript">    

<!-- Hide code from non-js browsers
	
function validateForm() {

	formObj = document.Survey;

	if (formObj.FirstName.length) {
		for (var i=0;i<formObj.FirstName.length; i++) {
			if (eval("formObj.FirstName[i].value") == ""){	        
		        alert("Please enter the Student's First Name.");
		        formObj.FirstName[i].focus();
		        return false;
		        } 
			if (eval("formObj.LastName[i].value") == ""){	        
		        alert("Please enter the Student's Last Name.");
		        formObj.LastName[i].focus();
		        return false;
		        }
			if (eval("formObj.BirthDate[i].value") == ""){	        
		        alert("Please enter the Student's Birth Date.");
		        formObj.BirthDate[i].focus();
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
		if (formObj.BirthDate.value == ""){	        
		    alert("Please enter the Student's Birth Date.");
		    formObj.BirthDate.focus();
		    return false;
		    }
		} 
	}        

// end hiding -->
</SCRIPT>

<%
Response.Write "</HEAD>" & vbCrLf
Response.Write strBody & vbCrLf
%>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<BR>
<BR>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3>Class Registration</H3></FONT>
<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">Please enter student's information below:<BR><BR>

<FORM ACTION="<%= SurveyName %>" METHOD="post" NAME="Survey" onSubmit="return validateForm()">

<INPUT TYPE="hidden" NAME="FormName" VALUE="SurveyForm">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">

<%

Call DBOpen(OBJdbConnection2)
Call DBOpen(OBJdbConnection3)

For FieldNum = 0 To 5

    HeadingLine1 = HeadingLine1 & "<TD ALIGN=""center"" VALIGN=""bottom""><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=""2""><B>" & SurveyFields(FieldNum, 1) & "</B></FONT></TD>" & vbCrLf
    
Next

For FieldNum = 6 To 9

    HeadingLine2 = HeadingLine2 & "<TD ALIGN=""center"" VALIGN=""bottom""><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=""2""><B>" & SurveyFields(FieldNum, 1) & "</B></FONT></TD>" & vbCrLf
    
Next

    HeadingLine3 = HeadingLine3 & "<TD ALIGN=""left"" VALIGN=""bottom""><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=""1""><BR><I>" & WaiverText & "</I></FONT><BR><BR></TD>" & vbCrLf




SQLEvent = "SELECT Event.EventCode, Event.EventDate, Act.Act, Venue.Venue FROM OrderLine WITH (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event WITH (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act WITH (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue WITH (ROWLOCK) ON Event.VenueCode = Venue.VenueCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Event.SurveyNumber = " & SurveyNumber & " GROUP BY Event.EventCode, Event.EventDate, Act.Act, Venue.Venue ORDER BY Event.EventDate, Act.Act, Venue.Venue"
Set rsEvent = OBJdbConnection.Execute(SQLEvent)

Do Until rsEvent.EOF

	Response.Write "<BR><HR><BR><TABLE><TR><TD><FONT FACE=""" & FontFace & """ COLOR=""" & HeadingFontColor & """ SIZE=""2""><B>" & rsEvent("Act") & " at " & rsEvent("Venue") & " on " & FormatDateTime(rsEvent("EventDate"), vbShortDate) & " at " & DateAndTimeFormat(rsEvent("EventDate")) & "</B></TD></TR></TABLE>" & vbCrLf

	SQLOrderLine = "SELECT OrderLine.LineNumber FROM OrderLine WITH (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Seat.EventCode = " & rsEvent("EventCode") & " ORDER BY OrderLine.LineNumber"
	Set rsOrderLine = OBJdbConnection2.Execute(SQLOrderLine)

	Do Until rsOrderLine.EOF
	
	    Response.Write "<INPUT TYPE=""hidden"" NAME=""LineNumber"" VALUE=""" & rsOrderLine("LineNumber") & """>" & vbCrLf
	
	    Response.Write "<TABLE WIDTH=""90%""><TR>" & HeadingLine1 & "</TR>" & vbCrLf
	    
	    Response.Write "<TR>" & vbCrLf
	    
	    For FieldNum = 0 To 10
	    
		    If FieldNum = 6 Then
		        Response.Write "</TR></TABLE>" & vbCrLf
        	    Response.Write "<TABLE WIDTH=""90%""><TR>" & HeadingLine2 & "<BR><BR></TR><TR>" & vbCrLf
		    End If
		    
		   If FieldNum = 10 Then
		        Response.Write "</TR></TABLE>" & vbCrLf
        	    Response.Write "<TABLE WIDTH=""90%""><TR>" & HeadingLine3 & "</TR><TR>" & vbCrLf
		    End If
		    

		    'Get existing OrderLineDetail values for this order if there are any.
		    SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLine("LineNumber") & " AND FieldName = '" & SurveyFields(FieldNum,0) & "'"
		    Set rsOrderLineDetail = OBJdbConnection3.Execute(SQLOrderLineDetail)
    			
		    If Not rsOrderLineDetail.EOF Then
			    FieldValue = rsOrderLineDetail("FieldValue")
		    Else
			    FieldValue = ""
		    End If
    			
		    rsOrderLineDetail.Close
		    Set rsOrderLineDetail = nothing
		    
		    If SurveyFields(FieldNum, 0) = "Gender" Then

		        MaleChecked = ""
		        FemaleChecked = ""
		        
		        Select Case FieldValue
		            Case "Male"
				        MaleChecked = " SELECTED"
				    Case "Female"
    				    FemaleChecked = " SELECTED"
    		    End Select
			
        		Response.Write "<TD ALIGN=""left""><INPUT TYPE=""hidden"" NAME=""FieldName"" VALUE=""" & SurveyFields(FieldNum, 0) & """><SELECT NAME=""" & SurveyFields(FieldNum, 0) & """><OPTION VALUE=""Female""" & FemaleChecked & ">Female<OPTION VALUE=""Male""" & MaleChecked & ">Male</SELECT></TD>" & vbCrLf

            ElseIf SurveyFields(FieldNum, 0) = "Waiver" Then

		        YesChecked = ""
		        NoChecked = ""
		        
		        Select Case FieldValue
		            Case "Yes"
				        YesChecked = " SELECTED"
				    Case "No"
    				    NoChecked = " SELECTED"
    		    End Select
			
        		Response.Write "<TD ALIGN=""left""><INPUT TYPE=""hidden"" NAME=""FieldName"" VALUE=""" & SurveyFields(FieldNum, 0) & """><SELECT NAME=""" & SurveyFields(FieldNum, 0) & """><OPTION VALUE=""No""" & NoChecked & ">No<OPTION VALUE=""Yes""" & YesChecked & ">Yes</SELECT></TD>" & vbCrLf

            Else
            
            Response.Write "<TD ALIGN=""left""><INPUT TYPE=""hidden"" NAME=""FieldName"" VALUE=""" & SurveyFields(FieldNum, 0) & """><INPUT TYPE=""text"" NAME=""" & SurveyFields(FieldNum, 0) & """ VALUE=""" & FieldValue & """ SIZE=""" & SurveyFields(FieldNum,2) & """ MAXLENGTH=""50""></TD>" & vbCrLf
		               
            End If		        
	        
	    Next
	    
	    Response.Write "</TR></TABLE>" & vbCrLf

		rsOrderLine.MoveNext
			
	Loop
	
	Response.Write "<BR><HR><BR>" & vbCrLf

	rsOrderLine.Close
	Set rsOrderLine = nothing
	
	rsEvent.MoveNext
	
Loop

rsEvent.Close
Set rsEvent = nothing

Call DBClose(OBJdbConnection2)
Call DBClose(OBJdbConnection3)

%>  

<INPUT TYPE="submit" VALUE="Continue"></FORM>
</CENTER>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%
End Sub ' SurveyForm

Sub UpdateSurveyAnswer

'Response.Write Request("LineNumber") & "<BR>"

If Session("OrderNumber") <> "" Then

	For Each LineNumber In Request("LineNumber")

		i = i + 1
		
		For FieldNum = 0 To 10

		    'Delete existing record for this line number and field.
		    SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & LineNumber & " AND FieldName = '" & SurveyFields(FieldNum, 0) & "'"
		    Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)

		    'Insert record for this line number and field.
		    SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", '" & SurveyFields(FieldNum, 0) & "', '" & Clean(Request(SurveyFields(FieldNum, 0))(i)) & "')"
		    Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)

        Next
        
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


