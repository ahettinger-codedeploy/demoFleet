<!--#INCLUDE virtual=/PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=/GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=/DBOpenInclude.asp -->
<%
Page = "Survey"

SurveyNumber = 600
SurveyName = "NameBadgeSurvey.asp"

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
Response.Write "</HEAD>" & vbCrLf
Response.Write strBody & vbCrLf
%>

<!--#INCLUDE virtual="/TopNavInclude.asp"-->

<BR>
<BR>
<CENTER>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3>Attendee Information</H3></FONT>
<TABLE CELLPADDING="0" CELLSPACING="5" BORDER="0"><TR><TD ALIGN="center" COLSPAN="4"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">Please enter the information below for each attendee.<BR><BR></TD></TR>

<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey" onSubmit="return validateForm()">
<INPUT TYPE="hidden" NAME="FormName" VALUE="SurveyForm">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">

<%

Call DBOpen(OBJdbConnection2)
Call DBOpen(OBJdbConnection3)
Call DBOpen(OBJdbConnection4)
Call DBOpen(OBJdbConnection5)
Call DBOpen(OBJdbConnection6)
Call DBOpen(OBJdbConnection7)

SQLEvent = "SELECT Event.EventCode, Event.EventDate, Act.Act, Venue.Venue FROM OrderLine WITH (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event WITH (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act WITH (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue WITH (ROWLOCK) ON Event.VenueCode = Venue.VenueCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Event.SurveyNumber = " & SurveyNumber & " GROUP BY Event.EventCode, Event.EventDate, Act.Act, Venue.Venue ORDER BY Event.EventDate, Act.Act, Venue.Venue"
Set rsEvent = OBJdbConnection.Execute(SQLEvent)

Do Until rsEvent.EOF

	Response.Write "<TR><TD ALIGN=""center"" COLSPAN=""4""><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=""2""><B>" & rsEvent("Act") & " for " & FormatDateTime(rsEvent("EventDate"), vbLongDate) & "</B></TD></TR>" & vbCrLf
	
	Response.Write "<TR BGCOLOR=""" & HeadingFontColor & """><TD ALIGN=""center""><FONT FACE=""" & FontFace & """ COLOR=""" & BGColor & """ SIZE=""2""><B>First<BR>Name</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""" & FontFace & """ COLOR=""" & BGColor & """ SIZE=""2""><B>Last<BR>Name</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""" & FontFace & """ COLOR=""" & BGColor & """ SIZE=""2""><B>City</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""" & FontFace & """ COLOR=""" & BGColor & """ SIZE=""2""><B>State</B></FONT></TD></TR>" & vbCrLf

	SQLOrderLine = "SELECT OrderLine.LineNumber FROM OrderLine WITH (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Seat.EventCode = " & rsEvent("EventCode") & " ORDER BY OrderLine.LineNumber"
	Set rsOrderLine = OBJdbConnection2.Execute(SQLOrderLine)
    TotalLines = 0
	Do Until rsOrderLine.EOF
    
    'Capture First Name Information

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

		Response.Write "<TR><TD ALIGN=""left""><INPUT TYPE=""text"" NAME=""FirstName" & TotalLines+1 & """ VALUE=""" & FirstName & """ SIZE=""22""></TD>" & vbCrLf

    'Capture Last Name Information

		FieldName = "LastName"
		FieldLabel = "Last Name"
			
		'Get existing OrderLineDetail values for this order if there are any.
		SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLine("LineNumber") & " AND FieldName = '" & FieldName & "'"
		Set rsOrderLineDetail = OBJdbConnection3.Execute(SQLOrderLineDetail)
			
		If Not rsOrderLineDetail.EOF Then
			LastName = rsOrderLineDetail("FieldValue")
		Else
			LastName = ""
		End If
			
		rsOrderLineDetail.Close
		Set rsOrderLineDetail = nothing

		Response.Write "<TD ALIGN=""left""><INPUT TYPE=""text"" NAME=""LastName" & TotalLines+1 & """ VALUE=""" & LastName & """ SIZE=""22""></TD>" & vbCrLf
		
		
		'Capture City

		FieldName = "City"
		FieldLabel = "City"
			
		'Get existing OrderLineDetail values for this order if there are any.
		SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLine("LineNumber") & " AND FieldName = '" & FieldName & "'"
		Set rsOrderLineDetail = OBJdbConnection4.Execute(SQLOrderLineDetail)
			
		If Not rsOrderLineDetail.EOF Then
			City = rsOrderLineDetail("FieldValue")
		Else
			City = ""
		End If
			
		rsOrderLineDetail.Close
		Set rsOrderLineDetail = nothing

		Response.Write "<TD ALIGN=""left""><INPUT TYPE=""text"" NAME=""City" & TotalLines+1 & """ VALUE=""" & City & """ SIZE=""12"" ></TD>" & vbCrLf

    
    'Capture State Information

		FieldName = "State"
		FieldLabel = "State"
			
		'Get existing OrderLineDetail values for this order if there are any.
		SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLine("LineNumber") & " AND FieldName = '" & FieldName & "'"
		Set rsOrderLineDetail = OBJdbConnection5.Execute(SQLOrderLineDetail)
			
		If Not rsOrderLineDetail.EOF Then
			State = rsOrderLineDetail("FieldValue")
		Else
			State = ""
		End If
			
		rsOrderLineDetail.Close
		Set rsOrderLineDetail = nothing

		Response.Write "<TD ALIGN=""left"">" & vbCrLf
		Response.Write "<SELECT NAME=""State" & TotalLines+1 & """>" & vbCrLf
		%> 
			<option value="AL">ALABAMA</option>
			<option value="AK">ALASKA</option>                          
			<option value="AZ">ARIZONA</option>                         
			<option value="AR">ARKANSAS</option>                        
			<option value="CA">CALIFORNIA</option>                      
			<option value="CO">COLORADO</option>                        
			<option value="CT">CONNECTICUT</option>                     
			<option value="DE">DELAWARE</option>                        
			<option value="DC">DISTRICT OF COLUMBIA</option>            
			<option value="FL">FLORIDA</option>                         
			<option value="GA">GEORGIA</option>                         
			<option value="HI">HAWAII</option>                         
			<option value="ID">IDAHO</option>                           
			<option value="IL">ILLINOIS</option>                        
			<option value="IN">INDIANA</option>                         
			<option value="IA">IOWA</option>                            
			<option value="KS">KANSAS</option>                          
			<option value="KY">KENTUCKY</option>                        
			<option value="LA">LOUISIANA</option>                       
			<option value="ME">MAINE</option>                          
			<option value="MD">MARYLAND</option>                        
			<option value="MA">MASSACHUSETTS</option>                   
			<option value="MI">MICHIGAN</option>                        
			<option value="MN">MINNESOTA</option>                       
			<option value="MS">MISSISSIPPI</option>                     
			<option value="MO">MISSOURI</option>                        
			<option value="MT">MONTANA</option>                       
			<option value="NE">NEBRASKA</option>                        
			<option value="NV">NEVADA</option>                         
			<option value="NH">NEW HAMPSHIRE</option>                   
			<option value="NJ">NEW JERSEY</option>                      
			<option value="NM">NEW MEXICO</option>                      
			<option value="NY">NEW YORK</option>                        
			<option value="NC">NORTH CAROLINA</option>                  
			<option value="ND">NORTH DAKOTA</option>                            
			<option value="OH">OHIO</option>                           
			<option value="OK">OKLAHOMA</option>                        
			<option value="OR">OREGON</option>                          
			<option value="PA">PENNSYLVANIA</option>                    
			<option value="RI">RHODE ISLAND</option>                    
			<option value="SC">SOUTH CAROLINA</option>                  
			<option value="SD">SOUTH DAKOTA</option>                    
			<option value="TN">TENNESSEE</option>                       
			<option value="TX">TEXAS</option>                           
			<option value="UT">UTAH</option>                            
			<option value="VT">VERMONT</option>                                         
			<option value="VA">VIRGINIA</option>                        
			<option value="WA">WASHINGTON</option>                      
			<option value="WV">WEST VIRGINIA</option>                   
			<option value="WI">WISCONSIN</option>                      
			<option value="WY">WYOMING</option>
 
	<%
	Response.Write "</SELECT>" & vbCrLf
	TotalLines = TotalLines + 1
	rsOrderLine.MoveNext
			
	Loop
	
	Response.Write "</TABLE>" & vbCrLf

	rsOrderLine.Close
	Set rsOrderLine = nothing
	
	rsEvent.MoveNext
	
Loop


rsEvent.Close
Set rsEvent = nothing

Call DBClose(OBJdbConnection2)
Call DBClose(OBJdbConnection3)
Call DBClose(OBJdbConnection4)
Call DBClose(OBJdbConnection5)

Response.Write "</TABLE>" & vbCrLf
Response.Write "<input type=""hidden"" name=""TotalLines"" value=""" & TotalLines & """>"
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

	For i = 1 To Request("TotalLines")
        LineNumber = i
        
		'Delete existing First Name record for this line number.
		SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & LineNumber & " AND FieldName = 'FirstName'"
		Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)

		'Insert First Name record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", 'FirstName', '" & Clean(Request("FirstName" & i)) & "')"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)

		'Delete existing Last Name record for this line number.
		SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & LineNumber & " AND FieldName = 'LastName'"
		Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)
		
		'Insert Last Name record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", 'LastName', '" & Clean(Request("LastName" & i)) & "')"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)
		
		'Delete existing City record for this line number.
		SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & LineNumber & " AND FieldName = 'City'"
		Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)
		
		'Insert City record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", 'City', '" & Clean(Request("City" & i)) & "')"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)
		
		'Delete existing State record for this line number.
		SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & LineNumber & " AND FieldName = 'State'"
		Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)
		
		'Insert State record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", 'State', '" & Clean(Request("State" & i)) & "')"
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


