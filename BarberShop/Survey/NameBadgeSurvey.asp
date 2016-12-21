<%

'CHANGE LOG

'SSR 6/30/2011 - Updated act codes

'RAS 8.24.11 commented out errorlog messaging

'SSR 6/22/2012 - Updated survey description/notes

'SSR 6/25/2012 - Updated survey colors.
'TTT 1/15/13 - Added SurveyNumber to OrderLineDetail
%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->

<%

'==================================================

Page = "Survey"
SurveyNumber = 600
SurveyName = "NameBadgeSurvey.asp"

'==================================================

'Barbershop Harmony Society
'Namebadge Survey 

'This survey captures the attendee information
'All fields are required

'QuestionList:
'(1) First Name
'(2) Last Name
'(3) Answer3
'(4) Answer4

'After this survey is finished, it hands off to the VIP Survey

'===============================================

If Session("UserNumber")<> "" Then
    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "#FFFFFF"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "#000000"
    TableDataBGColor = "#E9E9E9"
End If


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

'===============================================


Select Case Request("FormName")
	Case "UpdateSurveyAnswer"
		Call UpdateSurveyAnswer		 
	Case "UpdateVIPSurveyAnswer"
		Call UpdateVIPSurveyAnswer	
	Case Else
		Call SurveyForm
End Select


OBJdbConnection.Close
Set OBJdbConnection = nothing

'===============================================

Sub SurveyForm

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

<%

Response.Write "</HEAD>" & vbCrLf
Response.Write strBody & vbCrLf

%>

<!--#INCLUDE virtual="/TopNavInclude.asp"-->

<BR>
<BR>
<CENTER>
<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3>Name Badge Information</H3></FONT>
<TABLE CELLPADDING="0" CELLSPACING="5" BORDER="0"><TR><TD ALIGN="center" COLSPAN="4"><FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">Please enter the information below for each attendee.<BR><FONT FACE="<%= FontFace %>" COLOR="#FF1909" SIZE="1">An answer is required for all the questions below.<br /><BR></TD></TR>

<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey" onsubmit="return validate();">
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

	Response.Write "<TR><TD ALIGN=""center"" COLSPAN=""4""><FONT FACE=""" & FontFace & """ COLOR=""" & FontColor & """ SIZE=""2""><B>" & rsEvent("Act") & " for " & FormatDateTime(rsEvent("EventDate"), vbLongDate) & "</B></TD></TR>" & vbCrLf
	
	Response.Write "<TR BGCOLOR=""" & TableCategoryBGColor & """><TD ALIGN=""center""><FONT FACE=""" & FontFace & """ COLOR=""" & TableCategoryFontColor & """ SIZE=""2""><B>First<BR>Name</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""" & FontFace & """ COLOR=""" & TableCategoryFontColor & """ SIZE=""2""><B>Last<BR>Name</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""" & FontFace & """ COLOR=""" & TableCategoryFontColor & """ SIZE=""2""><B>City</B></FONT></TD><TD ALIGN=""center""><FONT FACE=""" & FontFace & """ COLOR=""" & TableCategoryFontColor & """ SIZE=""2""><B>State/Province</B></FONT></TD></TR>" & vbCrLf

	SQLOrderLine = "SELECT OrderLine.LineNumber FROM OrderLine WITH (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Seat.EventCode = " & rsEvent("EventCode") & " ORDER BY OrderLine.LineNumber"
	Set rsOrderLine = OBJdbConnection2.Execute(SQLOrderLine)
    TotalLines = 0
	Do Until rsOrderLine.EOF
    
    'Capture First Name Information

		FieldName = "Answer1"
		FieldLabel = "First Name"
			
		'Get existing OrderLineDetail values for this order if there are any.
		SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLine("LineNumber") & " AND FieldName = '" & FieldName & "'"
		Set rsOrderLineDetail = OBJdbConnection3.Execute(SQLOrderLineDetail)
			
		If Not rsOrderLineDetail.EOF Then
			Answer1 = rsOrderLineDetail("FieldValue")
		Else
			Answer1 = ""
		End If
			
		rsOrderLineDetail.Close
		Set rsOrderLineDetail = nothing

		Response.Write "<TR><TD ALIGN=""left""><INPUT TYPE=""text"" NAME=""Answer1" & TotalLines+1 & """ VALUE=""" & Answer1 & """ SIZE=""22""></TD>" & vbCrLf

    'Capture Last Name Information

		FieldName = "Answer2"
		FieldLabel = "Last Name"
			
		'Get existing OrderLineDetail values for this order if there are any.
		SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLine("LineNumber") & " AND FieldName = '" & FieldName & "'"
		Set rsOrderLineDetail = OBJdbConnection4.Execute(SQLOrderLineDetail)
			
		If Not rsOrderLineDetail.EOF Then
			Answer2 = rsOrderLineDetail("FieldValue")
		Else
			Answer2 = ""
		End If
			
		rsOrderLineDetail.Close
		Set rsOrderLineDetail = nothing

		Response.Write "<TD ALIGN=""left""><INPUT TYPE=""text"" NAME=""Answer2" & TotalLines+1 & """ VALUE=""" & Answer2 & """ SIZE=""22""></TD>" & vbCrLf
		
		
		'Capture Answer3

		FieldName = "Answer3"
		FieldLabel = "City"
			
		'Get existing OrderLineDetail values for this order if there are any.
		SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLine("LineNumber") & " AND FieldName = '" & FieldName & "'"
		Set rsOrderLineDetail = OBJdbConnection5.Execute(SQLOrderLineDetail)
			
		If Not rsOrderLineDetail.EOF Then
			Answer3 = rsOrderLineDetail("FieldValue")
		Else
			Answer3 = ""
		End If
			
		rsOrderLineDetail.Close
		Set rsOrderLineDetail = nothing

		Response.Write "<TD ALIGN=""left""><INPUT TYPE=""text"" NAME=""Answer3" & TotalLines+1 & """ VALUE=""" & Answer3 & """ SIZE=""12"" ></TD>" & vbCrLf

    
    'Capture Answer4 Information

		FieldName = "Answer4"
		FieldLabel = "Answer4"
			
		'Get existing OrderLineDetail values for this order if there are any.
		SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLine("LineNumber") & " AND FieldName = '" & FieldName & "'"
		Set rsOrderLineDetail = OBJdbConnection6.Execute(SQLOrderLineDetail)
			
		If Not rsOrderLineDetail.EOF Then
			Answer4 = rsOrderLineDetail("FieldValue")
		Else
			Answer4 = ""
		End If
			
		rsOrderLineDetail.Close
		Set rsOrderLineDetail = nothing

		Response.Write "<TD ALIGN=""left"">" & vbCrLf
		Response.Write "<SELECT NAME=""Answer4" & TotalLines+1 & """>" & vbCrLf
		%> 
		    <option value=""> -- Select An Option --</option>
		    <option value=""> -- US Answer4s --</option>
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
			<option value=""> -- Provinces of Canada --</option>
			<option value="AB">Alberta</option>
			<option value="BC">British Columbia</option>
			<option value="MB">Manitoba</option>
			<option value="NB">New Brunswick</option>
			<option value="NL">Newfoundland and Labrador</option>
			<option value="NT">Northwest Territories</option>
			<option value="NS">Nova Scotia</option>			
			<option value="NU">Nunavut</option> 
			<option value="ON">Ontario</option>
			<option value="PE">Prince Edward Island</option>
			<option value="QC">Quebec / Québec</option>
			<option value="SK">Saskatchewan</option>
			<option value="YT">Yukon</option>
			<option value=""> -- Other --</option>		
			<option value="IT">International</option> 
	<%
	Response.Write "</SELECT>" & vbCrLf
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

Response.Write "</TABLE>" & vbCrLf
Response.Write "<input type=""hidden"" name=""TotalLines"" value=""" & TotalLines & """>"
%>  
<BR><BR>
<INPUT TYPE="submit" VALUE="Continue"></FORM>
</CENTER>

<!--#INCLUDE virtual="/FooterInclude.asp"-->

</BODY>
</HTML>

<%
End Sub ' SurveyForm

'================================

Sub UpdateSurveyAnswer

If Session("OrderNumber") <> "" Then

	For i = 1 To Request("TotalLines")
        LineNumber = i
        
		'Delete existing Answer1 record for this line number.
		SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & LineNumber & " AND FieldName = 'Answer1'"
		Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)

		'Insert Answer1 record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, SurveyNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & "," & SurveyNumber & ", 'Answer1', '" & Clean(Request("Answer1" & i)) & "')"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)

		'Delete existing Answer2 record for this line number.
		SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & LineNumber & " AND FieldName = 'Answer2'"
		Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)
		
		'Insert Answer2 record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, SurveyNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & "," & SurveyNumber & ", 'Answer2', '" & Clean(Request("Answer2" & i)) & "')"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)
		
		'Delete existing Answer3 record for this line number.
		SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & LineNumber & " AND FieldName = 'Answer3'"
		Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)
		
		'Insert Answer3 record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, SurveyNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & "," & SurveyNumber & ", 'Answer3', '" & Clean(Request("Answer3" & i)) & "')"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)
		
		'Delete existing Answer4 record for this line number.
		SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & LineNumber & " AND FieldName = 'Answer4'"
		Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)
		
		'Insert Answer4 record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, SurveyNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & "," & SurveyNumber & ", 'Answer4', '" & Clean(Request("Answer4" & i)) & "')"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)
		

	Next	
		

End If

Call Continue


End Sub 'Update SurveyAnswer

'======================================


Sub Continue

Response.Redirect("VIPSurvey.asp")
Exit Sub

End Sub




'======================================

%>


