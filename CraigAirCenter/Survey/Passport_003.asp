<!--#INCLUDE virtual=/PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=/GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=/DBOpenInclude.asp -->
<%
Page = "Survey"

SurveyNumber = 421
SurveyName = "PassengerList.asp"

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

Sub SurveyForm

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & Title & "</TITLE>" & vbCrLf
%>
<SCRIPT LANGUAGE="JavaScript">    

<!-- Hide code from non-js browsers
function validateForm() {

	formObj = document.Survey;
	
//	alert("Form Validation");
	if (formObj.FirstName.length) {
		for (var i=0;i<formObj.FirstName.length; i++) {
			if (eval("formObj.FirstName[i].value") == ""){	        
		        alert("Please enter the passenger's first name.");
		        formObj.FirstName[i].focus();
		        return false;
		        } 
			if (eval("formObj.LastName[i].value") == ""){	        
		        alert("Please enter the passenger's last name.");
		        formObj.LastName[i].focus();
		        return false;
		        }
		    } 
		 }
	else {
		if (formObj.FirstName.value == "") {
		    alert("Please enter the passenger's first name.");
		    formObj.FirstName.focus();
		    return false;
		    } 
		if (formObj.LastName.value == ""){	        
		    alert("Please enter the passenger's last name.");
		    formObj.LastName.focus();
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

<!--#INCLUDE virtual="/TopNavInclude.asp"-->

<BR>
<BR>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3>Passenger Information</H3></FONT>
<TABLE WIDTH="600"><TR><TD ALIGN="center"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">Please enter the passenger's name(s) below.<BR><BR></TD></TR></TABLE>

<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey" onSubmit="return validateForm()">
<INPUT TYPE="hidden" NAME="FormName" VALUE="SurveyForm">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">

<%

Call DBOpen(OBJdbConnection2)
Call DBOpen(OBJdbConnection3)

SQLEvent = "SELECT Event.EventCode, Event.EventDate, Act.Act, Venue.Venue FROM OrderLine WITH (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event WITH (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act WITH (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue WITH (ROWLOCK) ON Event.VenueCode = Venue.VenueCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Event.SurveyNumber = " & SurveyNumber & " GROUP BY Event.EventCode, Event.EventDate, Act.Act, Venue.Venue ORDER BY Event.EventDate, Act.Act, Venue.Venue"
Set rsEvent = OBJdbConnection.Execute(SQLEvent)

Do Until rsEvent.EOF

	Response.Write "<TABLE><TR><TD><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=""2"">" & rsEvent("Act") & " for " & FormatDateTime(rsEvent("EventDate"), vbLongDate) & "</TD></TR>" & vbCrLf
	Response.Write "<TR><TD ALIGN=""center""><TABLE><TR BGCOLOR=""" & HeadingFontColor & """><TD ALIGN=""center""><FONT FACE=""" & FontFace & """ COLOR=""" & BGColor & """ SIZE=""2""><B>First Name</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""" & FontFace & """ COLOR=""" & BGColor & """ SIZE=""2""><B>Last Name</B></FONT></TD></TR>" & vbCrLf

	SQLOrderLine = "SELECT OrderLine.LineNumber FROM OrderLine WITH (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Seat.EventCode = " & rsEvent("EventCode") & " ORDER BY OrderLine.LineNumber"
	Set rsOrderLine = OBJdbConnection2.Execute(SQLOrderLine)

	Do Until rsOrderLine.EOF

		FieldName = "FirstName"
		FieldLabel = "First Name"
			
		'Get existing OrderLineDetail values for this order if there are any.
		SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLine("LineNumber") & " AND FieldName = '" & FieldName & "'"
		Set rsOrderLineDetail = OBJdbConnection3.Execute(SQLOrderLineDetail)
			
		If Not rsOrderLineDetail.EOF Then
			FirstName = rsOrderLineDetail("FieldValue")
		Else
			FirstName = ""
		End If
			
		rsOrderLineDetail.Close
		Set rsOrderLineDetail = nothing

		Response.Write "<TR><TD ALIGN=""left""><INPUT TYPE=""hidden"" NAME=""LineNumber"" VALUE=""" & rsOrderLine("LineNumber") & """><INPUT TYPE=""hidden"" NAME=""FieldName"" VALUE=""" & FieldName & """><INPUT TYPE=""text"" NAME=""" & FieldName & """ VALUE=""" & FirstName & """ SIZE=""20"" MAXLENGTH=""50""></TD>" & vbCrLf

		FieldName = "LastName"
		FieldLabel = "Last Name"
			
		'Get existing OrderLineDetail values for this order if there are any.
		SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLine("LineNumber") & " AND FieldName = '" & FieldName & "'"
		Set rsOrderLineDetail = OBJdbConnection3.Execute(SQLOrderLineDetail)
			
		If Not rsOrderLineDetail.EOF Then
			FirstName = rsOrderLineDetail("FieldValue")
		Else
			FirstName = ""
		End If
			
		rsOrderLineDetail.Close
		Set rsOrderLineDetail = nothing

	'	Response.Write "<TD ALIGN=""right""><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=""2""><B>" & FieldLabel & ":</B></FONT></TD>" & vbCrLf
		Response.Write "<TD ALIGN=""left""><INPUT TYPE=""hidden"" NAME=""FieldName"" VALUE=""" & FieldName & """><INPUT TYPE=""text"" NAME=""" & FieldName & """ VALUE=""" & FirstName & """ SIZE=""20"" MAXLENGTH=""50""></TD></TR>" & vbCrLf

		rsOrderLine.MoveNext
			
	Loop
	
	Response.Write "</TABLE></TD></TR></TABLE>" & vbCrLf

	rsOrderLine.Close
	Set rsOrderLine = nothing
	
	rsEvent.MoveNext
	
Loop


rsEvent.Close
Set rsEvent = nothing

Call DBClose(OBJdbConnection2)
Call DBClose(OBJdbConnection3)


Response.Write "</TABLE>" & vbCrLf

%>  

<INPUT TYPE="submit" VALUE="Continue"></FORM>
</CENTER>

<!--#INCLUDE virtual="/FooterInclude.asp"-->

</BODY>
</HTML>

<%
End Sub ' SurveyForm

Sub UpdateSurveyAnswer

'Response.Write Request("LineNumber") & "<BR>"

If Session("OrderNumber") <> "" Then

	For Each LineNumber In Request("LineNumber")

		i = i + 1

		'Delete existing First Name record for this line number.
		SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & LineNumber & " AND FieldName = 'FirstName'"
		Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)

		'Insert First Name record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", 'FirstName', '" & Clean(Request("FirstName")(i)) & "')"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)

		'Delete existing Last Name record for this line number.
		SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & LineNumber & " AND FieldName = 'LastName'"
		Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)
		
		'Insert Last Name record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", 'LastName', '" & Clean(Request("LastName")(i)) & "')"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)

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


