<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->

<%

'========================================
Page = "Survey"
SurveyNumber = 895
SurveyName = "AudienceSurvey.asp"

Dim Question(2)
NumQuestions = 1

Question(1) = "How did you hear about this concert?"

'========================================

'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If


'Check to see if this is a Phone (2), Fax (3), Mail (4), Comp (5), Box Office (7) Order. If so, bypass the restriction.
If Session("OrderTypeNumber") = 2 Or Session("OrderTypeNumber") = 3 Or Session("OrderTypeNumber") = 4 Or Session("OrderTypeNumber") = 5 Or Session("OrderTypeNumber") = 7 Then
	Call Continue
End If


Select Case Request("FormName")
	Case "SurveyUpdate"
		Call SurveyUpdate
	Case "Continue"
		Call Continue
	Case Else
		Call SurveyForm
End Select


OBJdbConnection.Close
Set OBJdbConnection = nothing

'========================================

Sub SurveyForm

If DocType <> "" Then
    Response.Write(DocType)
Else
    Response.Write("<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">")
End If

%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<html>
<head>

<title>=<%= Title %></title>

<style type="text/css">
<!--
#tix-table
{
	font-family: Verdana, Geneva, Arial, Helvetica, sans-serif; 
	font-size: 12px;
	border-collapse: collapse;
	background: #f1f1f1;
	line-height: 50%;
}
#tix-table th
{
	font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;  
	font-size: 16px;
	font-weight: 900;
	padding: 20px;
	/* table catagory row color */
	background: #383839;
	/* table catagory top row trim color */
	border-top: 2px solid #c7c7c7;
	/* table catagory font color */
	color: #ffffff;
}
#tix-table td 
{
 background-color: #f1f1f1;  
 margin-right: 0px;    
 padding: 1px;     
 font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;  
 font-size: 13px;  
 color: #000000;   
 line-height: 150%;  
} 
.heading td
}
font-weight: 900;
padding: 10px;
line-height: 150%;  
}
-->
</style>

<script type="text/javascript" src="/javascript/usableforms.js"></script> 

</head>

<%=strBody %>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<form action="<%= SurveyFileName %>" name="Survey" method="post">
<input type="hidden" name="FormName" value="SurveyUpdate">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">

<! -- Table Begin -- >
<table id="tix-table" summary="surveypage" width="500" border="0">
<! -- Table Column Headings -- >
    <thead>
        <tr>
	        <th colspan="2" scope="col">Audience Survey</th>
        </tr>
    </thead>
<! -- Table Footer -- >
        <tfoot>
    	<tr>
        	<td colspan="2">&nbsp;</td>
        </tr>
    </tfoot>
<! -- Table Body -- >
    <tbody>
            <tr>
                <td align="left"  colspan="2" style="padding: 10px; font-weight: 900;"><B>How did you hear about this concert?</B></td>
            </tr>
            <tr>
                <td align="center"><INPUT TYPE="checkbox" NAME="Answer1"/></td>
                <td align="left">Already a subscriber</td>
            </tr>
            <tr>
                <td  align="center"><INPUT TYPE="checkbox" NAME="Answer1"/></td>
                <td align="left">Friend</td>
            </tr>
            <tr>
                <td  align="center"><INPUT TYPE="checkbox" NAME="Answer1"/></td>
                <td align="left">Family</td>
            </tr>
            <tr>
                <td  align="center"><INPUT TYPE="checkbox" NAME="Answer1"/></td>
                <td align="left">Brochure</td>
            </tr>
            <tr>
                <td  align="center"><INPUT TYPE="checkbox" rel="radio" NAME="Answer1"/></td>
                <td align="left">Radio</td>
            </tr>
            <tr rel="radio">
                <td align="left" colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;which radio station?&nbsp;<input type="text" name="Answer1" size = "24" /></td>
            </tr>
            <tr>
                <td  align="center"><INPUT TYPE="checkbox" NAME="Answer1"/></td>
                <td align="left">TV</td>
            </tr>
            <tr>
                <td  align="center"><INPUT TYPE="checkbox" rel="newspaper" NAME="Answer1"/></td>
                <td align="left">Newspaper</td>
            </tr>
            <tr rel="newspaper">
                <td align="left" colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;which newspaper?&nbsp;<input type="text" name="Answer1" size = "24" /></td>
            </tr>
            <tr>
                <td  align="center"><INPUT TYPE="checkbox" rel="other" NAME="Answer1"/></td>
                <td align="left">Other</td>
            </tr>
            <tr rel="other">
                <td align="left" colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;please specify:&nbsp;<input type="text" name="Answer1" size = "24" /></td>
            </tr>
<! -- Table Headline -- >
        </tbody>
 </table>
<br /> 
<INPUT TYPE="submit" VALUE="Continue"></FORM>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%

End Sub ' SurveyForm

'===========================

Sub SurveyUpdate

If Session("OrderNumber") <> "" Then

	For AnswerNumber = 1 To NumQuestions
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

'===========================

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

End Sub

'===========================

%>


