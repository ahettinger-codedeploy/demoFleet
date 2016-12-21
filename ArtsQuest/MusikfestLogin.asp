<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%
Page = "Login"

If Request("ReturnToPage") <> "" Then 
	Session("ReturnToPage") = Request("ReturnToPage")
End If

If Request("UserID") = "" And Request("Password") = "" Then
	Call Login(MessageType)
Else
	Call Verify
End If

OBJdbConnection.Close
Set OBJdbConnection = nothing

Sub Login(MessageType)

Response.Write "<HTML>" & vbCrLf
Response.Write "<HEAD>" & vbCrLf
Response.Write "<TITLE>" & Title & "</TITLE>" & vbCrLf
%>

<SCRIPT LANGUAGE="JavaScript">    

<!-- Hide code from non-js browsers

function validateForm() {
   formObj = document.LoginForm;
   if (formObj.UserID.value == "") {
       alert("Please enter your E-Mail Address.");
       formObj.UserID.focus();
       return false;
       } 
   else if (formObj.Password.value == "") {
       alert("Please enter your Password.");
       formObj.Password.focus();
       return false;
       }
  }

function focusEMailAddressMessage(Message) {
	formObj = document.LoginForm;
	<%
	Response.Write "alert(Message);" & vbCrLf
	%>
	formObj.UserID.select();
    }    

function focusPasswordMessage(Message) {
	formObj = document.LoginForm;
	<%
	Response.Write "alert(Message);" & vbCrLf
	%>
	formObj.Password.value = '';
	formObj.Password.select();
    }    

// end hiding -->
</SCRIPT>
</HEAD>

<%
Select Case MessageType
	Case ""
		Response.Write "<BODY BGCOLOR=" & BGColor & " LINK="& LinkColor & " ALINK=" & ALinkColor & " VLINK=" & VLinkColor & " onLoad=""document.LoginForm.UserID.focus();"" leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0 " & BodyParameters & ">" & vbCrLf
	Case "InvalidEMailAddress"
		'REE 4/25/2 - Modified the error message.
		Message = "The E-Mail Address entered is not on file. Please try again or Sign Up if you have not already done so."
		Response.Write "<BODY BGCOLOR=" & BGColor & " LINK="& LinkColor & " ALINK=" & ALinkColor & " VLINK=" & VLinkColor & " onLoad=""focusEMailAddressMessage('" & Message & "');"" leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0 " & BodyParameters & ">" & vbCrLf
	Case "InvalidPassword"
		'REE 4/25/2 - Modified the error message.
		Message = "The password entered does not correspond to the e-mail address entered.  Please try again."
		Response.Write "<BODY BGCOLOR=" & BGColor & " LINK="& LinkColor & " ALINK=" & ALinkColor & " VLINK=" & VLinkColor & " onLoad=""focusPasswordMessage('" & Message & "');"" leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0 " & BodyParameters & ">" & vbCrLf
End Select

Message = ""
%>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<%
'Response.Write "<BR><BR><FONT FACE=" & FontFace & " COLOR=" &  HeadingFontColor & " SIZE=2><H3>Log In</H3></FONT>" & vbCrLf
Response.Write "<BR><BR><FONT FACE=" & FontFace & " COLOR=" &  HeadingFontColor & " SIZE=2><H3>New Customers</H3></FONT>" & vbCrLf
'REE 4/25/2 - Modified to include specific text for Bethlehem Musikfest
If iVenueCode = 22 Or iVenueCode = 23 Then 'It's Bethlehem
	Response.Write "<FONT FACE=" & FontFace & " COLOR=" &  FontColor & " SIZE=2>If this is your first Musikfest ticket order for THIS YEAR, click on the Sign Up button below.<BR>" & vbCrLf
End If
Response.Write "<FORM ACTION=""Registration.asp"" METHOD=""post""><INPUT TYPE=submit VALUE='Sign Up'></FORM><BR>" & vbCrLf
Response.Write "<TABLE WIDTH=""80%""><TR><TD><HR></TD></TR></TABLE>" & vbCrLf
Response.Write "<FORM ACTION=Login.asp METHOD=post id=form1 NAME=""LoginForm"" onsubmit=""return validateForm()"">" & vbCrLf
Response.Write "<FONT FACE=" & FontFace & " COLOR=" &  HeadingFontColor & " SIZE=2><H3>Existing Customers</H3></FONT>" & vbCrLf
Response.Write "<TABLE WIDTH=""500"">" & vbCrLf
'REE 4/25/2 - Modified to include specific text for Bethlehem Musikfest
If iVenueCode = 22 Or iVenueCode = 23 Then 'It's Bethlehem
	Response.Write "<TR><TD COLSPAN=""2"" ALIGN=""center""><FONT FACE=" & FontFace & " COLOR=" &  FontColor & " SIZE=2>If you have purchased Musikfest tickets THIS YEAR, please fill in your e-mail address and personal password used for that order.<BR>(This is NOT the Club Musikfest or Sponsor employee password).<BR><BR></TD></TR>" & vbCrLf
End If
'REE 4/25/2 - Modified prompts
If Request("UserID") = "" Then
	Response.Write "<TR><TD ALIGN=right><FONT FACE=" & FontFace & " COLOR=" &  FontColor & " SIZE=2><B>Your E-Mail Address:</B></FONT></TD><TD><INPUT TYPE=text NAME=UserID SIZE=30></TD></TR>" & vbCrLf
Else
	Response.Write "<TR><TD ALIGN=right><FONT FACE=" & FontFace & " COLOR=" &  FontColor & " SIZE=2><B>Your E-Mail Address:</B></FONT></TD><TD><INPUT TYPE=text NAME=UserID VALUE='" & Request("UserID") & "' SIZE=30></TD></TR>" & vbCrLf
End If
If Request("Password") = "" Then
	Response.Write "<TR><TD ALIGN=right><FONT FACE=" & FontFace & " COLOR=" &  FontColor & " SIZE=2><B>Your Personal Password:</B></FONT></TD><TD><INPUT TYPE=password NAME=Password SIZE=30 MAXLENGTH=10></TD></TR>" & vbCrLf
Else
	Response.Write "<TR><TD ALIGN=right><FONT FACE=" & FontFace & " COLOR=" &  FontColor & " SIZE=2><B>Your Personal Password:</B></FONT></TD><TD><INPUT TYPE=password NAME=Password VALUE='" & Request("Password") & "' SIZE=30></TD></TR>" & vbCrLf
End If
Response.Write "</TABLE>" & vbCrLf
'Response.Write "<FONT FACE=" & FontFace & " COLOR=" &  FontColor & " SIZE=2>If you are a new customer <A HREF=Registration.asp>click here</A> to register.<BR>" & vbCrLf
'REE 4/25/2 - Modified the message.
Response.Write "<FONT FACE=" & FontFace & " COLOR=" &  FontColor & " SIZE=1>If you do not have your personal password or you've forgotten it, <A HREF=PasswordReset.asp>click here</A>.<BR>A password reset link will be sent to your e-mail address.</FONT><BR><BR>" & vbCrLf
Response.Write "<INPUT TYPE=hidden NAME=CustomerAction VALUE=Verify>" & vbCrLf
Response.Write "<INPUT TYPE=submit VALUE='Log In' id=submit1 name=submit1></FORM><BR>" & vbCrLf

End Sub

Sub Verify

%>
<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<%
SQLCustomer = "SELECT Password, CustomerNumber FROM Customer WHERE UPPER(UserID) = '" & UCase(Request("UserID")) & "'"
Set rsCustomer = OBJdbConnection.Execute(SQLCustomer)
If rsCustomer.EOF Then
	MessageType = "InvalidEMailAddress"
	Call Login(MessageType)
Else
	If UCase(rsCustomer("Password")) <> UCase(Request("Password")) Then 
	MessageType = "InvalidPassword"
	Call Login(MessageType)
	Else
'		Session("UserID") = Request("UserID")
		Session("CustomerNumber") = rsCustomer("CustomerNumber")
		If Session("ReturnToPage") <> "" Then
			OBJdbConnection.Close
			Set OBJdbConnection = nothing
			Response.Redirect(Session("ReturnToPage"))
		Else
			OBJdbConnection.Close
			Set OBJdbConnection = nothing
			Response.Redirect("Default.asp")
		End If
	End If
End If
rsCustomer.Close
Set rsCustomer = nothing


End Sub
%>

</CENTER>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>
