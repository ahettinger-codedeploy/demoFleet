<!--#INCLUDE virtual=/PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=/GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=/DBOpenInclude.asp -->
<%
Page = "Survey"

SurveyNumber = 600
SurveyName = "NameBadgeSurvey.asp"

NumQuestions = 2

Dim Question(3)

Question(1) = "VIP status"
Question(2) = "Any Special Seating Requests? ?"

'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If

'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	OBJdbConnection.Close
	Set OBJdbConnection = nothing
	Response.Redirect("/Default.asp")
End If

Select Case Request("FormName")
	Case "VIPSurveyForm"
		Call VIPSurveyForm
	Case "Continue"
		Call Continue	
	Case "UpdateSurveyAnswer"
		Call UpdateSurveyAnswer		 
	Case Else
		Call NameBadgeSurveyForm
End Select



'==================================================
Sub NameBadgeSurveyForm

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
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3>Name Badge Information</H3></FONT>
<TABLE CELLPADDING="0" CELLSPACING="5" BORDER="0"><TR><TD ALIGN="center" COLSPAN="4"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">Please enter the information below for each attendee.<BR><BR></TD></TR>

<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey" onSubmit="return validateForm()">
<INPUT TYPE="hidden" NAME="FormName" VALUE="UpdateSurveyAnswer">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">

<%

Call DBOpen(OBJdbConnection2)
Call DBOpen(OBJdbConnection3)
Call DBOpen(OBJdbConnection4)
Call DBOpen(OBJdbConnection5)
Call DBOpen(OBJdbConnection6)

SQLEvent = "SELECT Event.EventCode, Event.EventDate, Act.Act, Venue.Venue FROM OrderLine WITH (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event WITH (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act WITH (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue WITH (ROWLOCK) ON Event.VenueCode = Venue.VenueCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Event.SurveyNumber = " & SurveyNumber & " GROUP BY Event.EventCode, Event.EventDate, Act.Act, Venue.Venue ORDER BY Event.EventDate, Act.Act, Venue.Venue"
Set rsEvent = OBJdbConnection.Execute(SQLEvent)

Do Until rsEvent.EOF

	Response.Write "<TR><TD ALIGN=""center"" COLSPAN=""4""><BR><BR><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=""2""><B>" & rsEvent("Act") & " for " & FormatDateTime(rsEvent("EventDate"), vbLongDate) & "</B></TD></TR>" & vbCrLf

	Response.Write "<TR BGCOLOR=""" & HeadingFontColor & """><TD ALIGN=""center""><FONT FACE=""" & FontFace & """ COLOR=""" & BGColor & """ SIZE=""2""><B>First<BR>Name</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""" & FontFace & """ COLOR=""" & BGColor & """ SIZE=""2""><B>Last<BR>Name</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""" & FontFace & """ COLOR=""" & BGColor & """ SIZE=""2""><B>City</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""" & FontFace & """ COLOR=""" & BGColor & """ SIZE=""2""><B>State/Province</B></FONT></TD></TR>" & vbCrLf

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
		Set rsOrderLineDetail = OBJdbConnection4.Execute(SQLOrderLineDetail)
			
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
		Set rsOrderLineDetail = OBJdbConnection5.Execute(SQLOrderLineDetail)
			
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
		Set rsOrderLineDetail = OBJdbConnection6.Execute(SQLOrderLineDetail)
			
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
			<option value="AL">Alabama</option>
			<option value="AK">Alaska</option>                          
			<option value="AZ">Arizona</option>                         
			<option value="AR">Arkansas</option>                        
			<option value="CA">California</option>                      
			<option value="CO">Colorado</option>                        
			<option value="CT">Connecticut</option>                     
			<option value="DE">Delaware</option>                        
			<option value="DC">District Of Columbia</option>            
			<option value="FL">Florida</option>                         
			<option value="GA">Georgia</option>                         
			<option value="HI">Hawaii</option>                         
			<option value="ID">Idaho</option>                           
			<option value="IL">Illinois</option>                        
			<option value="IN">Indiana</option>                         
			<option value="IA">Iowa</option>                            
			<option value="KS">Kansas</option>                          
			<option value="KY">Kentucky</option>                        
			<option value="LA">Louisiana</option>                       
			<option value="ME">Maine</option>                          
			<option value="MD">Maryland</option>                        
			<option value="MA">Massachusetts</option>                   
			<option value="MI">Michigan</option>                        
			<option value="MN">Minnesota</option>                       
			<option value="MS">Mississippi</option>                     
			<option value="MO">Missouri</option>                        
			<option value="MT">Montana</option>                       
			<option value="NE">Nebraska</option>                        
			<option value="NV">Nevada</option>                         
			<option value="NH">New Hampshire</option>                   
			<option value="NJ">New Jersey</option>                      
			<option value="NM">New Mexico</option>                      
			<option value="NY">New York</option>                        
			<option value="NC">North Carolina</option>                  
			<option value="ND">North Dakota</option>                            
			<option value="OH">Ohio</option>                           
			<option value="OK">Oklahoma</option>                        
			<option value="OR">Oregon</option>                          
			<option value="PA">Pennsylvania</option>                    
			<option value="RI">Rhode Island</option>                    
			<option value="SC">South Carolina</option>                  
			<option value="SD">South Dakota</option>                    
			<option value="TN">Tennessee</option>                       
			<option value="TX">Texas</option>                           
			<option value="UT">Utah</option>                            
			<option value="VT">Vermont</option>                                         
			<option value="VA">Virginia</option>                        
			<option value="WA">Washington </option>                      
			<option value="WV">West Virginia</option>                   
			<option value="WI">Wisconsin</option>                      
			<option value="WY">Wyoming</option>
			<option value="--">---</option>
			<option value="NS">Nova Scotia</option>
			<option value="NT">Northwest Territories</option>
			<option value="NU">Nunavut</option> 
			<option value="ON">Ontario</option>
			<option value="PE">Prince Edward Island</option>
			<option value="QC">Quebec Québec</option>
			<option value="SK">Saskatchewan</option>
			<option value="YT">Yukon</option>
			<option value="IT">International</option>
 
	<%
	Response.Write "</SELECT>" & vbCrLf
	Response.Write "</TD></TR>" & vbCrLf
	TotalLines = TotalLines + 1
	rsOrderLine.MoveNext
			
	Loop
	

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
Call DBClose(OBJdbConnection6)

%>  

</TABLE>

<INPUT TYPE="hidden" NAME="TotalLines" VALUE="<%= TotalLines %>">
<INPUT TYPE="submit" VALUE="Continue" ID="submit1" NAME="submit1"></FORM>
</CENTER>

<!--#INCLUDE virtual="/FooterInclude.asp"-->

</BODY>
</HTML>

<%
End Sub ' NameBadgeSurveyForm

'==================================================

Sub VIPSurveyForm


Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & Title & "</TITLE>" & vbCrLf
Response.Write "</HEAD>" & vbCrLf
Response.Write strBody & vbCrLf
%>

<!--#INCLUDE virtual="/TopNavInclude.asp"-->
<HTML>
<HEAD>
<TITLE>"<%= Title %>"</TITLE>
</HEAD>
<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey" onSubmit="return validateForm()">
<INPUT TYPE="hidden" NAME="FormName" VALUE="UpdateSurveyAnswer">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">
<BR>
<BR>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3>Additional Membership Information</H3></FONT>
<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2"><FONT face="Geneva, Arial, Helvetica, san-serif">Because you are a valued VIP member, please take a minute to answer the following questions so that we may serve you better<BR><BR>.</FONT><BR>
<BR>
<CENTER>
<TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0">
  <TR>
		<TD VALIGN="top" ALIGN="right">
		<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">
		<B>Please select your VIP seating status:</B>
		</FONT>
		</TD>
		<TD VALIGN="top" ALIGN="left">
		<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">
		&nbsp;&nbsp;<INPUT TYPE="radio" NAME="Answer1" VALUE="VIP">&nbsp;VIP&nbsp;&nbsp;<INPUT TYPE="radio" NAME="Answer1" VALUE="AIC">&nbsp;AIC&nbsp;&nbsp;<INPUT TYPE="radio" NAME="Answer1" VALUE="Presidents Council">&nbsp;Presidents Council
		</FONT>
		</TD>
  </TR>
    <TR>
		<TD VALIGN="top" ALIGN="right">
		<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">
		<B>Any Special Seating Requests?</B>
		</FONT>
		</TD>
		<TD VALIGN="top" ALIGN="left">
		<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">
		&nbsp;&nbsp;<INPUT TYPE="text" NAME="Answer2" SIZE=50>
		</FONT>
		</TD>
  </TR>
  </TABLE>
  <BR><BR>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3>Thank You for your time!</H3></FONT><BR><BR><BR>

<INPUT TYPE="submit" VALUE="Continue" id=submit2 name=submit2></FORM>
</CENTER>

<!--#INCLUDE virtual="/FooterInclude.asp"-->

</BODY>
</HTML>

<%

End Sub ' VIPSurveyForm

'==============================

Sub Continue

If Session("UserNumber") = "" Then
	Session("SurveyComplete") = Session("OrderNumber") 
	Response.Redirect("/Ship.asp")
Else
	Session("SurveyComplete") = Session("OrderNumber")
	Response.Redirect("/Management/AdvanceShip.asp")
End If

End Sub 'Continue

'==============================

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
		
End If


End Sub 'Update SurveyAnswer

'==============================
%>


