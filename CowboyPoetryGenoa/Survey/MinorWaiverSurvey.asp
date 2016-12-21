<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<!--#INCLUDE VIRTUAL="CalcCustomerFeeInclude.asp"-->
<%

Page = "Survey"
SurveyNumber = 918
SurveyName = "MinorWaiverSurvey.asp"

'========================================
'The Town of Genoa & The Crown Valley Arts Council  (12/13/2010)
'Minor Waiver Survey

NumQuestions = 5
Dim Question(6)
Question(3) = "Minors Birthdate"
Question(4) = "Minors Name"
Question(5) = "Release on behalf of Minor."

'========================================

'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If

If Session("UserNumber")<> "" Then
TableCategoryBGColor = "#008400"
TableCategoryFontColor = "FFFFFF"
TableColumnHeadingBGColor = "99CC99"
TableColumnHeadingFontColor = "000000"
TableDataBGColor = "E9E9E9"
End If

If Clean(Request("FormName")) = "SurveyUpdate" Then
    Call SurveyUpdate
Else
    Call SurveyForm
End If

'========================================

Sub SurveyForm

If DocType <> "" Then
	Response.Write DocType
Else
	Response.Write "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
End If

%>

<html>
<head>
<title><%= title %></title>

<head>


</head>

<%= strBody %>

<!--#include virtual="TopNavInclude.asp"-->

<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey">
<INPUT TYPE="hidden" NAME="FormName" VALUE="SurveyUpdate">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">

<table width="90%" cellpadding="10" cellspacing="3">
<tr bgcolor="<%=TableCategoryBGColor%>">
    <td align="center" colspan="2">
        <FONT COLOR="<%=TableCategoryFontColor%>" SIZE="4">
        <b>PARENT/LEGAL GUARDIAN WAIVER AND<BR />RELEASE OF LIABILITY AND INDEMNITY AGREEMENT</b>
        </FONT>
    </td>
</tr> 
<tr>
    <td align="center" colspan="2">
    <FONT SIZE="2">
    2011 GENOA COWBOY POETRY & MUSIC FESTIVAL<br />
    2ND ANNUAL PLEASURE TRAIL RIDE - CHUCK WAGON DINNER AND<br />
    DAVE STAMEY AND OLD WEST TRIO CONCERT
    </FONT>
    </td>
</tr>
<tr>
    <td bgcolor="<%=TableColumnHeadingBGColor%>"><FONT SIZE="2">1</FONT></td>
    <td bgcolor="<%=TableDataBGColor%>">
    <FONT SIZE="1">
    I am the parent/legal guardian of a minor (hereinafter referred to as the
    “Minor”), and on the Minor’s behalf, my behalf and on behalf of all other parents/legal guardians of the Minor,
    I accept the Release as set forth above on page 1 of the Release.
    </FONT>
    </td>    
</tr>
<tr>
    <td bgcolor="<%=TableColumnHeadingBGColor%>"><FONT SIZE="2">2</FONT></td>
    <td bgcolor="<%=TableDataBGColor%>">
    <FONT SIZE="1">
    Riders under the age of 18 years of age must have the permission of a parent/legal guardian to participate in the
    Ride, and they must wear long pants, an approved riding helmet and appropriate footgear, with heels. Riders
    under the age of 18 years of age must be accompanied by an adult at all times.
    </FONT>
    </td>
</tr>
<tr>
    <td bgcolor="<%=TableColumnHeadingBGColor%>"><FONT SIZE="2">3</FONT></td>
    <td bgcolor="<%=TableDataBGColor%>">
    <FONT SIZE="1">
    On the Minor’s behalf, my behalf and on behalf of all other parents/legal guardians of the Minor, I consent to
    and authorize any emergency medical care or treatment that may become necessary for the Minor and do agree
    to indemnify and hold harmless the Event Coordinator.
    </FONT>
    </td>
</tr>
<tr>
    <td colspan="2">
        <table cellpadding="0" cellspacing="0">
        <tr>
            <td align="right"><FONT SIZE="2">Minor’s Birth Date:&nbsp;&nbsp;</FONT></td>
            <td><FONT SIZE="2"><INPUT TYPE="text" NAME="Answer3" SIZE="24"></font></td>    
        </tr>
        <tr>
            <td align="right"><FONT SIZE="2">Minor’s Name:&nbsp;&nbsp;</FONT></td>
            <td><FONT SIZE="2"><INPUT TYPE="text" NAME="Answer4" SIZE="24"></font></td>    
        </tr>
        </table>    
    </td>
</tr>
<tr>
    <td><FONT SIZE="2"><INPUT TYPE="checkbox" NAME="Answer5" VALUE="Yes"></FONT></td>
    <td><FONT SIZE="2">I represent and warrant that I have the authority to give this Release on behalf of the Minor.</FONT></td>
</tr>
</table>
<BR>
<BR>
<INPUT TYPE="submit" VALUE="Continue"></FORM>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>
</html>

<%		
	
End Sub 'SurveyForm

'========================================

Sub SurveyUpdate

If Session("OrderNumber") <> "" Then

	For AnswerNumber = 3 To NumQuestions
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

End Sub 'SurveyUpdate
		
	
'========================================

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

'========================================


%> 
