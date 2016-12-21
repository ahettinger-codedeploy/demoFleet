<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->

<%

'1201/5400 Corporation (8/9/2010)
'=================================
' Survey Update
' If order passes the table check validation
' display a second page asking for referral information


'1201/ 5400 Corporation (8/3/2010)
'=================================
' Table Check Survey

' Patron is required to buy a minimum of 8 seats per table
' All 8 seats must be at the same table


'===================================================

'Survey Variables
Page = "Survey"
SurveyNumber = 822
SurveyName = "TableCheckSurvey.asp"

Dim Question(1)
NumQuestions = 1
Question(1) = "Please indicate which organization referred you to purchase tickets"

Dim SurveyFields(1,6)
NumQuestions = 1
SurveyFields(1,1) = "Forsyth Central High School"
SurveyFields(1,2) = "Lambert High School"
SurveyFields(1,3) = "North Forsyth High School"
SurveyFields(1,4) = "South Forsyth High School"
SurveyFields(1,5) = "West Forsyth High School"
SurveyFields(1,6) = "Other"


'===================================================

'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
End If

'Check to see if this is a Comp Order. If so, skip survey.
If Session("OrderTypeNumber") = 5 Then
	Call Continue
End If


If Clean(Request("FormName")) = "SurveyForm" Then
	Call SurveyForm
ElseIf Clean(Request("FormName")) = "UpdateSurveyAnswer" Then
	Call UpdateSurveyAnswer
Else
    Call TableCheck
End If


'===================================================

Sub TableCheck

SQLOrderSeats = "SELECT Seat.EventCode, Section.Section, Seat.SectionCode, COUNT(OrderLine.ItemNumber) AS OrderSeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber")	& " AND Section.Color = '2Green' AND OrderLine.ItemType IN ('SubFixedEvent', 'SubSeat', 'Seat') GROUP BY Seat.EventCode, Seat.SectionCode, Section.Section"
Set rsOrderSeats = OBJdbConnection.Execute(SQLOrderSeats)

Do Until rsOrderSeats.EOF

	SQLSectionSeats = "SELECT COUNT(ItemNumber) AS SectionSeatCount FROM Seat (NOLOCK) WHERE EventCode = " & rsOrderSeats("EventCode") & " AND SectionCode = '" & rsOrderSeats("SectionCode") & "'"
	Set rsSectionSeats = OBJdbConnection.Execute(SQLSectionSeats)
	
	    OrderSection = rsOrderSeats("Section")
	    OrderSectionCode = rsOrderSeats("SectionCode")
	    OrderEventCode = rsOrderSeats("EventCode")	
	    OrderSeatCount = rsOrderSeats("OrderSeatCount")
	    SectionSeatCount = rsSectionSeats("SectionSeatCount")


	    If OrderSeatCount < 8 Then 'Not all seats were selected.  Go to warning page	
		    rsSectionSeats.Close
		    Set rsSectionSeats = nothing		
		    Call WarningPage(OrderSeatCount, SectionSeatCount, OrderSection, OrderEventCode, OrderSectionCode)		
		    Exit Sub
		Else
		    Call SurveyForm					
	    End If
				
	rsSectionSeats.Close
	Set rsSectionSeats = nothing
	
	rsOrderSeats.MoveNext

Loop
		
rsOrderSeats.Close
Set rsOrderSeats = nothing

OBJdbConnection.Close
Set OBJdbConnection = nothing

Call SurveyForm	

End Sub	
				
'=================================

Sub WarningPage(OrderSeatCount, SectionSeatCount, OrderSection, OrderEventCode, OrderSectionCode)

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

<FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2"><H3>SORRY</H3></FONT>
<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">Tables require a minimum purchase of 8 tickets.<BR /><br />
<FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">You have only selected <%= OrderSeatCount %> seats at <b> <%= OrderSection %> </b>.<BR><br />

<%
If Session("UserNumber") = "" Then  'online order
	Response.Write "<CENTER><br><FORM ACTION=""/ShoppingCart.asp"" METHOD=""POST"" id=form1 name=form1><INPUT TYPE=""submit"" VALUE=""View Shopping Cart"" id=1 name=1></FORM><br><br></CENTER>" & vbCrLf
	Response.Write "<CENTER><FORM ACTION=""/Section.asp?Event=" &OrderEventCode& "&Section=" & OrderSectionCode & "&Details=NO"" METHOD=""POST"" id=form1 name=form1><INPUT TYPE=""submit"" VALUE=""Add Additional Seats"" id=1 name=1></FORM></CENTER><Br>" & vbCrLf
Else  'box office order
    Response.Write "<CENTER><bR><FORM ACTION=""/Management/SectionRowSelect.asp?Event=" &OrderEventCode& "&Section=" & OrderSectionCode & "&Details=NO"" METHOD=""POST"" id=form1 name=form1><INPUT TYPE=""submit"" VALUE=""Add Additional Seats"" id=1 name=1></FORM><br><br></CENTER>" & vbCrLf
	Response.Write "<CENTER><FORM ACTION=""/Management/ShoppingCart.asp"" METHOD=""POST"" id=form1 name=form1><INPUT TYPE=""submit"" VALUE=""View Shopping Cart"" id=1 name=1></FORM></CENTER><bR>" & vbCrLf
    
End If
%>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%			
End Sub 'Warning Page

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

<SCRIPT LANGUAGE="JavaScript"'> 

<!-- Hide code from non-js browsers

function validateForm(){
if(document.Survey.Answer1.selectedIndex==0)
{
alert("Please indicate which organization referred you to purchase tickets .");
document.Survey.Answer1.focus();
return false;
}
return true;
}
// end hiding -->
</SCRIPT> 

</head>

<%= strBody %>

<!--#include virtual="TopNavInclude.asp"-->

<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey" onSubmit="return validateForm()">
<INPUT TYPE="hidden" NAME="FormName" VALUE="UpdateSurveyAnswer">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">

<table width="600" border="0" cellpadding="0" cellspacing="0">
<tr bgcolor="<%=TableCategoryBGColor%>">
    <td colspan="4" align="center">
    <FONT FACE="<%= FontFace %>" COLOR="<%=TableCategoryFontColor%>" SIZE="2">
    <B>Audience Survey</B></FONT>
    </td>
</tr>
<tr>
    <td colspan="4">&nbsp;</td>
</tr>
<tr>
    <td rowspan=2 width="5%" valign="middle" align="center">
        <FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2">
        <!--Line Number -->
        <h3></h3>
    </td>
    </tr>
    <tr>
	    <td align="right">
	        <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">
	        <b>Please indicate which organization<BR />referred you to purchase tickets</B>
	        </FONT>
	    </td>
	    <td>&nbsp;&nbsp;&nbsp;</td>
	    <td align="right">	   
	            <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">     
			    <SELECT NAME="Answer1">
			    <OPTION VALUE="0">Please select.....</OPTION><BR>
	            <OPTION VALUE="<%= SurveyFields(1, 1) %>">&nbsp;<%= SurveyFields(1, 1) %></OPTION><BR>
	            <OPTION VALUE="<%= SurveyFields(1, 2) %>">&nbsp;<%= SurveyFields(1, 2) %></OPTION><BR>
	            <OPTION VALUE="<%= SurveyFields(1, 3) %>">&nbsp;<%= SurveyFields(1, 3) %></OPTION><BR>
	            <OPTION VALUE="<%= SurveyFields(1, 4) %>">&nbsp;<%= SurveyFields(1, 4) %></OPTION><BR>
	            <OPTION VALUE="<%= SurveyFields(1, 5) %>">&nbsp;<%= SurveyFields(1, 5) %></OPTION><BR>
	            <OPTION VALUE="<%= SurveyFields(1, 6) %>">&nbsp;<%= SurveyFields(1, 6) %></OPTION><BR>
	            </SELECT>
	            </FONT>
	    </td>
	</tr>
	<tr>
	    <td  colspan="4">
        <HR />
        </td>
    </tr> 
</table>
<br />
<input type="submit" value="Continue"></FORM>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>
</html>

<%
End Sub ' SurveyForm



'===========================

Sub UpdateSurveyAnswer

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

Sub Continue

Session("SurveyComplete") = Session("OrderNumber")

If Session("OrderTypeNumber") = 1 Then
	Response.Redirect("/Ship.asp")
Else
	Response.Redirect("/Management/AdvanceShip.asp")
End If

End Sub 'Continue

'=================================

%>



