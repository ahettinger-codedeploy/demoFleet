<!--#INCLUDE virtual=/PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=/GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=/DBOpenInclude.asp -->
<%
Page = "Survey"

SurveyNumber = 752
SurveyName = "SurveyBannockburnElementarySchool.asp"
AdultSeatList = "4201" 'Adult Coordinator
ChildSeatList = "4202,4203" 'Child Registration Only, 'Child Registration with DVD


'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If


If Clean(Request("FormName")) = "SurveyForm" Then
    Call SurveyAnswerUpdate	
ElseIf Clean(Request("FormName")) = "EventList" Then
    Call EventListUpdate
Else
	Call SurveyForm
End If

OBJdbConnection.Close
Set OBJdbConnection = nothing

'============================

Sub SurveyForm

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & Title & "</TITLE>" & vbCrLf

%>


<%

Response.Write "</HEAD>" & vbCrLf
Response.Write strBody & vbCrLf

%>
<!--#INCLUDE virtual="/TopNavInclude.asp"-->
<FORM ACTION="<%= SurveyName %>" METHOD="post" NAME="Survey" onSubmit="return validateForm()">
<INPUT TYPE="hidden" NAME="FormName" VALUE="SurveyForm">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">
<%
Call DBOpen(OBJdbConnection2)
Call DBOpen(OBJdbConnection3)
Call DBOpen(OBJdbConnection4)
Call DBOpen(OBJdbConnection5)
Call DBOpen(OBJdbConnection6)
Call DBOpen(OBJdbConnection7)
Call DBOpen(OBJdbConnection8)
Call DBOpen(OBJdbConnection9)
Call DBOpen(OBJdbConnection10)
Call DBOpen(OBJdbConnection11)
Call DBOpen(OBJdbConnection12)


'Begin Workshop Registration Form
Response.Write "<TABLE CELLPADDING=""4"" CELLSPACING=""2"" BORDER=""0"" WIDTH=""300"">" & vbCrLf

'Header Image
Response.Write "<TR>" & vbCrLf
Response.Write "<TD COLSPAN=""4""><IMG SRC=""/Clients/AdventureTheatre/Survey/Images/Surveyheader.jpg""></TD>" & vbCrLf
Response.Write "</TR>" & vbCrLf


SQLEvent = "SELECT Event.EventCode, Event.EventDate, Act.Act, Venue.Venue FROM OrderLine WITH (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event WITH (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act WITH (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue WITH (ROWLOCK) ON Event.VenueCode = Venue.VenueCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Event.SurveyNumber = " & SurveyNumber & " GROUP BY Event.EventCode, Event.EventDate, Act.Act, Venue.Venue ORDER BY Event.EventDate, Act.Act, Venue.Venue"
Set rsEvent = OBJdbConnection.Execute(SQLEvent)

TotalLines = 0

Do Until rsEvent.EOF

	'Capture Adult Information
	'==========================	
	SQLOrderLineAdult = "SELECT OrderLine.LineNumber, SeatType.SeatType FROM OrderLine WITH (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " And OrderLine.SeatTypeCode IN (" & AdultSeatList & ") AND Seat.EventCode = " & rsEvent("EventCode") & " ORDER BY OrderLine.LineNumber"
	Set rsOrderLineAdult = OBJdbConnection2.Execute(SQLOrderLineAdult)
	    

	Do Until rsOrderLineAdult.EOF	    

	Response.Write "<TR ALIGN=""center"" BGCOLOR=""#EB2637"">" & vbCrLf
	Response.Write "<TD COLSPAN=""4""><FONT FACE=""" & FontFace & """ COLOR=""" & BGColor & """ SIZE=""2""><B>" & rsOrderLineAdult("SeatType") & "</TD>" & vbCrLf
	Response.Write "</TR>" & vbCrLf
	
	'First Row
	Response.Write "<TR ALIGN=""center"">" & vbCrLf
	Response.Write "<TD BGCOLOR=""#F9C8CD""><FONT FACE=""" & FontFace & """ SIZE=""2"" ><B>Act</B></FONT></TD>" & vbCrLf
	Response.Write "<TD BGCOLOR=""#F9C8CD""><FONT FACE=""" & FontFace & """ SIZE=""2""><B>First Name</B></FONT></TD>" & vbCrLf
    Response.Write "<TD BGCOLOR=""#F9C8CD""><FONT FACE=""" & FontFace & """ SIZE=""2""><B>Last Name</B></FONT></TD>" & vbCrLf
	Response.Write "</TR>" & vbCrLf
    
   
   
        'Act Name
        '==========================	
		FieldName = "ActName"
		FieldLabel = "ActName"
			
		'Get existing OrderLineDetail values for this order if there are any.
		SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLineAdult("LineNumber") & " AND FieldName = '" & FieldName & "'"
		Set rsOrderLineDetail = OBJdbConnection2.Execute(SQLOrderLineDetail)
			
		If Not rsOrderLineDetail.EOF Then
			ActName = rsOrderLineDetail("FieldValue")
		Else
			ActName = ""
		End If
			
		rsOrderLineDetail.Close
		Set rsOrderLineDetail = nothing

        Response.Write "<TR ALIGN=""center"">" & vbCrLf
		Response.Write "<TD><INPUT TYPE=""text"" NAME=""ActName" & TotalLines+1 & """ VALUE=""" & ActName & """></TD>" & vbCrLf
   
   
        'Adult First Name
        '==========================	
		FieldName = "AdultFirstName"
		FieldLabel = "AdultFirstName"
			
		'Get existing OrderLineDetail values for this order if there are any.
		SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLineAdult("LineNumber") & " AND FieldName = '" & FieldName & "'"
		Set rsOrderLineDetail = OBJdbConnection3.Execute(SQLOrderLineDetail)
			
		If Not rsOrderLineDetail.EOF Then
			AdultFirstName = rsOrderLineDetail("FieldValue")
		Else
			AdultFirstName = ""
		End If
			
		rsOrderLineDetail.Close
		Set rsOrderLineDetail = nothing

		Response.Write "<TD><INPUT TYPE=""text"" NAME=""AdultFirstName" & TotalLines+1 & """ VALUE=""" & AdultFirstName & """></TD>" & vbCrLf

        
        'Adult Last Name
        '==========================	
		FieldName = "AdultLastName"
		FieldLabel = "AdultLastName"
			
		'Get existing OrderLineDetail values for this order if there are any.
		SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLineAdult("LineNumber") & " AND FieldName = '" & FieldName & "'"
		Set rsOrderLineDetail = OBJdbConnection4.Execute(SQLOrderLineDetail)
			
		If Not rsOrderLineDetail.EOF Then
			AdultLastName = rsOrderLineDetail("FieldValue")
		Else
			AdultLastName = ""
		End If
		
		
		rsOrderLineDetail.Close
		Set rsOrderLineDetail = nothing

		Response.Write "<TD><INPUT TYPE=""text"" NAME=""AdultLastName" & TotalLines+1 & """ VALUE=""" & AdultLastName & """></TD>" & vbCrLf
       
	    Response.Write "</TR>" & vbCrLf   
	    
	    
	    'Second Row
	    '==========================	
	    '==========================	
	    Response.Write "<TR ALIGN=""center"">" & vbCrLf
	    Response.Write "<TD BGCOLOR=""#F9C8CD""><FONT FACE=""" & FontFace & """ SIZE=""2""><B>Email</B></FONT></TD>" & vbCrLf
	    Response.Write "<TD BGCOLOR=""#F9C8CD""><FONT FACE=""" & FontFace & """ SIZE=""2""><B>Phone Number</B></FONT></TD>" & vbCrLf
	    Response.Write "<TD><FONT FACE=""" & FontFace & """ SIZE=""2""><B>&nbsp;</B></FONT></TD>" & vbCrLf
	    Response.Write "</TR>" & vbCrLf    


	    'Email
        '==========================	
		FieldName = "AdultEmail"
		FieldLabel = "AdultEmail"
			
		'Get existing OrderLineDetail values for this order if there are any.
		SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLineAdult("LineNumber") & " AND FieldName = '" & FieldName & "'"
		Set rsOrderLineDetail = OBJdbConnection5.Execute(SQLOrderLineDetail)
			
		If Not rsOrderLineDetail.EOF Then
			AdultEmail = rsOrderLineDetail("FieldValue")
		Else
			AdultEmail = ""
		End If
			
		rsOrderLineDetail.Close
		Set rsOrderLineDetail = nothing
		
		Response.Write "<TR ALIGN=""center"">" & vbCrLf
		Response.Write "<TD><INPUT TYPE=""text"" NAME=""AdultEmail" & TotalLines+1 & """ VALUE=""" & AdultEmail & """></TD>" & vbCrLf
		
	    'Phone
	    '==========================	
		FieldName = "AdultPhone"
		FieldLabel = "AdultPhone"
			
		'Get existing OrderLineDetail values for this order if there are any.
		SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLineAdult("LineNumber") & " AND FieldName = '" & FieldName & "'"
		Set rsOrderLineDetail = OBJdbConnection6.Execute(SQLOrderLineDetail)
			
		If Not rsOrderLineDetail.EOF Then
			AdultPhone = rsOrderLineDetail("FieldValue")
		Else
			AdultPhone = ""
		End If
			
		rsOrderLineDetail.Close
		Set rsOrderLineDetail = nothing

		Response.Write "<TD><INPUT TYPE=""text"" NAME=""AdultPhone" & TotalLines+1 & """ VALUE=""" & AdultPhone & """></TD>" & vbCrLf
		
		'Blank Cell
		'==========================	
		Response.Write "<TD><FONT FACE=""" & FontFace & """ SIZE=""2""><B>&nbsp;</B></FONT></TD>" & vbCrLf
		
	    TotalLines = TotalLines + 1
	    rsOrderLineAdult.MoveNext
			
	Loop
	
	Response.Write "</TR>" & vbCrLf

	rsOrderLineAdult.Close
	Set rsOrderLineAdult = nothing
	
	
	'Capture Child Information
	'==========================	
	SQLOrderLineChild = "SELECT OrderLine.LineNumber, SeatType.SeatType FROM OrderLine WITH (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " And OrderLine.SeatTypeCode IN (" & ChildSeatList & ") AND Seat.EventCode = " & rsEvent("EventCode") & " ORDER BY OrderLine.LineNumber"
	Set rsOrderLineChild = OBJdbConnection2.Execute(SQLOrderLineChild)
	    
	Do Until rsOrderLineChild.EOF	    

	Response.Write "<TR ALIGN=""center"" BGCOLOR=""#6156A5"">" & vbCrLf
	Response.Write "<TD COLSPAN=""4""><FONT FACE=""" & FontFace & """ COLOR=""" & BGColor & """ SIZE=""2""><B>" & rsOrderLineChild("SeatType") & "</TD>" & vbCrLf
	Response.Write "</TR>" & vbCrLf
	
	'First Row
	'==========================	
	'==========================	
	Response.Write "<TR ALIGN=""center"">" & vbCrLf
	Response.Write "<TD BGCOLOR=""#BAB6D9""><FONT FACE=""" & FontFace & """ SIZE=""2"" ><B>First Name</B></FONT></TD>" & vbCrLf
	Response.Write "<TD BGCOLOR=""#BAB6D9""><FONT FACE=""" & FontFace & """ SIZE=""2""><B>Last Name</B></FONT></TD>" & vbCrLf
    Response.Write "<TD BGCOLOR=""#BAB6D9""><FONT FACE=""" & FontFace & """ SIZE=""2""><B>Age</B></FONT></TD>" & vbCrLf
	Response.Write "</TR>" & vbCrLf
      
   
        'Child First Name
        '==========================	
		FieldName = "ChildFirstName"
		FieldLabel = "ChildFirstName"
			
		'Get existing OrderLineDetail values for this order if there are any.
		SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLineChild("LineNumber") & " AND FieldName = '" & FieldName & "'"
		Set rsOrderLineDetail = OBJdbConnection3.Execute(SQLOrderLineDetail)
			
		If Not rsOrderLineDetail.EOF Then
			ChildFirstName = rsOrderLineDetail("FieldValue")
		Else
			ChildFirstName = ""
		End If
			
		rsOrderLineDetail.Close
		Set rsOrderLineDetail = nothing
		
		Response.Write "<TR ALIGN=""center"">" & vbCrLf

		Response.Write "<TD><INPUT TYPE=""text"" NAME=""ChildFirstName" & TotalLines+1 & """ VALUE=""" & ChildFirstName & """></TD>" & vbCrLf

        
        'Child Last Name
        '==========================	
		FieldName = "ChildLastName"
		FieldLabel = "ChildLastName"
			
		'Get existing OrderLineDetail values for this order if there are any.
		SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLineChild("LineNumber") & " AND FieldName = '" & FieldName & "'"
		Set rsOrderLineDetail = OBJdbConnection4.Execute(SQLOrderLineDetail)
			
		If Not rsOrderLineDetail.EOF Then
			ChildLastName = rsOrderLineDetail("FieldValue")
		Else
			ChildLastName = ""
		End If
		
		
		rsOrderLineDetail.Close
		Set rsOrderLineDetail = nothing

		Response.Write "<TD><INPUT TYPE=""text"" NAME=""ChildLastName" & TotalLines+1 & """ VALUE=""" & ChildLastName & """></TD>" & vbCrLf
       
	        
	    'ChildAge
        '==========================	
		FieldName = "ChildAge"
		FieldLabel = "ChildAge"
			
		'Get existing OrderLineDetail values for this order if there are any.
		SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLineChild("LineNumber") & " AND FieldName = '" & FieldName & "'"
		Set rsOrderLineDetail = OBJdbConnection2.Execute(SQLOrderLineDetail)
			
		If Not rsOrderLineDetail.EOF Then
			ChildAge = rsOrderLineDetail("FieldValue")
		Else
			ChildAge = ""
		End If
			
		rsOrderLineDetail.Close
		Set rsOrderLineDetail = nothing

       
		Response.Write "<TD><INPUT TYPE=""text"" NAME=""ChildAge" & TotalLines+1 & """ VALUE=""" & ChildAge & """></TD>" & vbCrLf 
	    
	    Response.Write "</TR>" & vbCrLf  
	    
	    
	    'Second Row
	    '==========================	
	    '==========================	
	    Response.Write "<TR ALIGN=""center"">" & vbCrLf
	    Response.Write "<TD BGCOLOR=""#BAB6D9""><FONT FACE=""" & FontFace & """ SIZE=""2"" ><B>Teacher First Name</B></FONT></TD>" & vbCrLf
	    Response.Write "<TD BGCOLOR=""#BAB6D9""><FONT FACE=""" & FontFace & """ SIZE=""2""><B>Teacher Last Name</B></FONT></TD>" & vbCrLf
        Response.Write "<TD BGCOLOR=""#BAB6D9""><FONT FACE=""" & FontFace & """ SIZE=""2""><B>Grade</B></FONT></TD>" & vbCrLf
	    Response.Write "</TR>" & vbCrLf
      
   
        'Teacher First Name
        '==========================
		FieldName = "TeacherFirstName"
		FieldLabel = "TeacherFirstName"
			
		'Get existing OrderLineDetail values for this order if there are any.
		SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLineChild("LineNumber") & " AND FieldName = '" & FieldName & "'"
		Set rsOrderLineDetail = OBJdbConnection3.Execute(SQLOrderLineDetail)
			
		If Not rsOrderLineDetail.EOF Then
			TeacherFirstName = rsOrderLineDetail("FieldValue")
		Else
			TeacherFirstName = ""
		End If
			
		rsOrderLineDetail.Close
		Set rsOrderLineDetail = nothing
		
		Response.Write "<TR ALIGN=""center"">" & vbCrLf

		Response.Write "<TD><INPUT TYPE=""text"" NAME=""TeacherFirstName" & TotalLines+1 & """ VALUE=""" & TeacherFirstName & """></TD>" & vbCrLf

        
        'Teacher Last Name
        '==========================
		FieldName = "TeacherLastName"
		FieldLabel = "TeacherLastName"
			
		'Get existing OrderLineDetail values for this order if there are any.
		SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLineChild("LineNumber") & " AND FieldName = '" & FieldName & "'"
		Set rsOrderLineDetail = OBJdbConnection4.Execute(SQLOrderLineDetail)
			
		If Not rsOrderLineDetail.EOF Then
			TeacherLastName = rsOrderLineDetail("FieldValue")
		Else
			TeacherLastName = ""
		End If
		
		
		rsOrderLineDetail.Close
		Set rsOrderLineDetail = nothing

		Response.Write "<TD><INPUT TYPE=""text"" NAME=""TeacherLastName" & TotalLines+1 & """ VALUE=""" & TeacherLastName & """></TD>" & vbCrLf
       
	        
	    'ChildGrade
        '==========================
		FieldName = "ChildGrade"
		FieldLabel = "ChildGrade"
			
		'Get existing OrderLineDetail values for this order if there are any.
		SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLineChild("LineNumber") & " AND FieldName = '" & FieldName & "'"
		Set rsOrderLineDetail = OBJdbConnection2.Execute(SQLOrderLineDetail)
			
		If Not rsOrderLineDetail.EOF Then
			ChildGrade = rsOrderLineDetail("FieldValue")
		Else
			ChildGrade = ""
		End If
			
		rsOrderLineDetail.Close
		Set rsOrderLineDetail = nothing

       
		Response.Write "<TD><INPUT TYPE=""text"" NAME=""ChildGrade" & TotalLines+1 & """ VALUE=""" & ChildGrade & """></TD>" & vbCrLf 
	    
	    Response.Write "</TR>" & vbCrLf  
	    
	    
	    'Third Row
	    '==========================
	    '==========================	    
	    Response.Write "<TR ALIGN=""center"">" & vbCrLf
	    Response.Write "<TD BGCOLOR=""#BAB6D9""><FONT FACE=""" & FontFace & """ SIZE=""2""><B>Parent Address</FONT></TD>" & vbCrLf
	    Response.Write "<TD BGCOLOR=""#BAB6D9""><FONT FACE=""" & FontFace & """ SIZE=""2""><B>Parent Email</B></FONT></TD>" & vbCrLf
	    Response.Write "<TD BGCOLOR=""#BAB6D9""><FONT FACE=""" & FontFace & """ SIZE=""2""><B>Parent Phone</B></FONT></TD>" & vbCrLf
	    Response.Write "</TR>" & vbCrLf    


	    'Parent Address
        '==========================
		FieldName = "ParentAddress"
		FieldLabel = "ParentAddress"
			
		'Get existing OrderLineDetail values for this order if there are any.
		SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLineChild("LineNumber") & " AND FieldName = '" & FieldName & "'"
		Set rsOrderLineDetail = OBJdbConnection6.Execute(SQLOrderLineDetail)
			
		If Not rsOrderLineDetail.EOF Then
			ParentAddress = rsOrderLineDetail("FieldValue")
		Else
			ParentAddress = ""
		End If
			
		rsOrderLineDetail.Close
		Set rsOrderLineDetail = nothing
		
		Response.Write "<TR ALIGN=""center"">" & vbCrLf

		Response.Write "<TD><INPUT TYPE=""text"" NAME=""ParentAddress" & TotalLines+1 & """ VALUE=""" & ParentAddress & """></TD>" & vbCrLf


	    'Parent Email
        '==========================
		FieldName = "ParentEmail"
		FieldLabel = "ParentEmail"
			
		'Get existing OrderLineDetail values for this order if there are any.
		SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLineChild("LineNumber") & " AND FieldName = '" & FieldName & "'"
		Set rsOrderLineDetail = OBJdbConnection5.Execute(SQLOrderLineDetail)
			
		If Not rsOrderLineDetail.EOF Then
			ParentEmail = rsOrderLineDetail("FieldValue")
		Else
			ParentEmail = ""
		End If
			
		rsOrderLineDetail.Close
		Set rsOrderLineDetail = nothing
		
		Response.Write "<TD><INPUT TYPE=""text"" NAME=""ParentEmail" & TotalLines+1 & """ VALUE=""" & ParentEmail & """></TD>" & vbCrLf
		
		
	    'Parent Phone
        '==========================
		FieldName = "ParentPhone"
		FieldLabel = "ParentPhone"
			
		'Get existing OrderLineDetail values for this order if there are any.
		SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLineChild("LineNumber") & " AND FieldName = '" & FieldName & "'"
		Set rsOrderLineDetail = OBJdbConnection6.Execute(SQLOrderLineDetail)
			
		If Not rsOrderLineDetail.EOF Then
			ParentPhone = rsOrderLineDetail("FieldValue")
		Else
			ParentPhone = ""
		End If
			
		rsOrderLineDetail.Close
		Set rsOrderLineDetail = nothing

		Response.Write "<TD><INPUT TYPE=""text"" NAME=""ParentPhone" & TotalLines+1 & """ VALUE=""" & ParentPhone & """></TD>" & vbCrLf

        Response.Write "</TR>" & vbCrLf 
        
        
        'Fourth Row
	    '==========================	
	    '==========================	
	    Response.Write "<TR ALIGN=""center"">" & vbCrLf
	    Response.Write "<TD BGCOLOR=""#BAB6D9""><FONT FACE=""" & FontFace & """ SIZE=""2"" ><B>Emergency First Name</B></FONT></TD>" & vbCrLf
	    Response.Write "<TD BGCOLOR=""#BAB6D9""><FONT FACE=""" & FontFace & """ SIZE=""2""><B>Emergency Last Name</B></FONT></TD>" & vbCrLf
        Response.Write "<TD BGCOLOR=""#BAB6D9""><FONT FACE=""" & FontFace & """ SIZE=""2""><B>Emergency Phone</B></FONT></TD>" & vbCrLf
	    Response.Write "</TR>" & vbCrLf
      
   
        'Emergency First Name
        '==========================
		FieldName = "EmergencyFirstName"
		FieldLabel = "EmergencyFirstName"
			
		'Get existing OrderLineDetail values for this order if there are any.
		SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLineChild("LineNumber") & " AND FieldName = '" & FieldName & "'"
		Set rsOrderLineDetail = OBJdbConnection3.Execute(SQLOrderLineDetail)
			
		If Not rsOrderLineDetail.EOF Then
			EmergencyFirstName = rsOrderLineDetail("FieldValue")
		Else
			EmergencyFirstName = ""
		End If
			
		rsOrderLineDetail.Close
		Set rsOrderLineDetail = nothing
		
		Response.Write "<TR ALIGN=""center"">" & vbCrLf

		Response.Write "<TD><INPUT TYPE=""text"" NAME=""EmergencyFirstName" & TotalLines+1 & """ VALUE=""" & EmergencyFirstName & """></TD>" & vbCrLf

        
        'Emergency Last Name
        '==========================
		FieldName = "EmergencyLastName"
		FieldLabel = "EmergencyLastName"
			
		'Get existing OrderLineDetail values for this order if there are any.
		SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLineChild("LineNumber") & " AND FieldName = '" & FieldName & "'"
		Set rsOrderLineDetail = OBJdbConnection4.Execute(SQLOrderLineDetail)
			
		If Not rsOrderLineDetail.EOF Then
			EmergencyLastName = rsOrderLineDetail("FieldValue")
		Else
			EmergencyLastName = ""
		End If
		
		
		rsOrderLineDetail.Close
		Set rsOrderLineDetail = nothing

		Response.Write "<TD><INPUT TYPE=""text"" NAME=""EmergencyLastName" & TotalLines+1 & """ VALUE=""" & EmergencyLastName & """></TD>" & vbCrLf
       
	        
	    'EmergencyPhone
        '==========================
		FieldName = "EmergencyPhone"
		FieldLabel = "EmergencyPhone"
			
		'Get existing OrderLineDetail values for this order if there are any.
		SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLineChild("LineNumber") & " AND FieldName = '" & FieldName & "'"
		Set rsOrderLineDetail = OBJdbConnection2.Execute(SQLOrderLineDetail)
			
		If Not rsOrderLineDetail.EOF Then
			EmergencyPhone = rsOrderLineDetail("FieldValue")
		Else
			EmergencyPhone = ""
		End If
			
		rsOrderLineDetail.Close
		Set rsOrderLineDetail = nothing

       
		Response.Write "<TD><INPUT TYPE=""text"" NAME=""EmergencyPhone" & TotalLines+1 & """ VALUE=""" & EmergencyPhone & """></TD>" & vbCrLf 
	    
	    Response.Write "</TR>" & vbCrLf  
        
				
	    TotalLines = TotalLines + 1
	    
	    rsOrderLineChild.MoveNext
			
	Loop
	
	Response.Write "</TR>" & vbCrLf
    Response.Write "</TABLE>" & vbCrLf

	rsOrderLineChild.Close
	Set rsOrderLineChild = nothing
	
	
	
	
	rsEvent.MoveNext
	
Loop

rsEvent.Close
Set rsEvent = nothing

Call DBClose(OBJdbConnection2)
Call DBClose(OBJdbConnection3)
Call DBClose(OBJdbConnection4)
Call DBClose(OBJdbConnection5)
Call DBClose(OBJdbConnection6)
Call DBClose(OBJdbConnection7)
Call DBClose(OBJdbConnection8)
Call DBClose(OBJdbConnection9)
Call DBClose(OBJdbConnection10)
Call DBClose(OBJdbConnection11)
Call DBClose(OBJdbConnection12)

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

Sub SurveyAnswerUpdate

If Session("OrderNumber") <> "" Then

	For i = 1 To Request("TotalLines")
        LineNumber = i
                
		'Delete existing First Name record for this line number.
		SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & LineNumber & " AND FieldName = 'AdultFirstName'"
		Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)

		'Insert First Name record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", 'AdultFirstName', '" & Clean(Request("AdultFirstName" & i)) & "')"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)

		'Delete existing Last Name record for this line number.
		SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & LineNumber & " AND FieldName = 'AdultLastName'"
		Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)
		
		'Insert Last Name record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", 'AdultLastName', '" & Clean(Request("AdultLastName" & i)) & "')"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)	
		
		'Delete existing Act  record for this line number.
		SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & LineNumber & " AND FieldName = 'ActName'"
		Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)
		
		'Insert Act record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", 'ActName', '" & Clean(Request("ActName" & i)) & "')"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)	
	
		'Delete existing AdultEmail record for this line number.
		SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & LineNumber & " AND FieldName = 'AdultEmail'"
		Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)

		'Insert AdultEmail record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", 'AdultEmail', '" & Clean(Request("AdultEmail" & i)) & "')"
		Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)
		
		'Delete existing Adult Phone record for this line number.
		SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & LineNumber & " AND FieldName = 'AdultPhone'"
		Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)

		'Insert Adult Phone record for this line number.
		SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & LineNumber & ", 'AdultPhone', '" & Clean(Request("AdultPhone" & i)) & "')"
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
