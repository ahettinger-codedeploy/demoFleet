<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->

<%

'1201/5400 Corporation (8/23/2010)
'=================================
' Table Check Survey - Update

' Tables in the patron table section require a minimum purchase of 8 tickets.
' Added wording to the survey so when an order has less than 8 tickes
' It is suggested that the customer buy at Sponsor Tables instead. 


'1201/5400 Corporation (8/9/2010)
'=================================
' Table Check Survey - Update

' If order passes the table check validation
' display a second page asking for referral information


'1201/ 5400 Corporation (8/3/2010)
'=================================
' Table Check Survey

' Patron is required to buy a minimum of 8 seats per table
' All 8 seats must be at the same table


Page = "Survey"
SurveyNumber = 822
SurveyName = "TableCheckSurvey.asp"

'Table Check
'-------------
ColorList = "2Green" 'Section colors with required minimum purchase of tickets
RequiredCount = 8 'Minimum number of required tickets to buy in each color section

'Survey
'-------------
Dim Question(1)
NumQuestions = 1
Question(1) = "Please indicate which organization referred you to purchase tickets"

Dim SurveyFields(1,9)
NumQuestions = 1
SurveyFields(1,1) = "Forsyth Central High School"
SurveyFields(1,2) = "Lambert High School"
SurveyFields(1,3) = "North Forsyth High School"
SurveyFields(1,4) = "South Forsyth High School"
SurveyFields(1,5) = "West Forsyth High School"
SurveyFields(1,6) = "Piney Grove Middle Band"
SurveyFields(1,7) = "West Forsyth High School Culinary"
SurveyFields(1,8) = "Lambert High Photography Club"
SurveyFields(1,9) = "Other"


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

SQLOrderSeats = "SELECT Seat.EventCode, Section.Section, Seat.SectionCode, COUNT(OrderLine.ItemNumber) AS OrderSeatCount FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Section (NOLOCK) ON Seat.EventCode = Section.EventCode AND Seat.SectionCode = Section.SectionCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber")	& " AND Section.Color = '" & ColorList & "' AND OrderLine.ItemType IN ('SubFixedEvent', 'SubSeat', 'Seat') GROUP BY Seat.EventCode, Seat.SectionCode, Section.Section"
Set rsOrderSeats = OBJdbConnection.Execute(SQLOrderSeats)

Do Until rsOrderSeats.EOF

	SQLSectionSeats = "SELECT COUNT(ItemNumber) AS SectionSeatCount FROM Seat (NOLOCK) WHERE EventCode = " & rsOrderSeats("EventCode") & " AND SectionCode = '" & rsOrderSeats("SectionCode") & "'"
	Set rsSectionSeats = OBJdbConnection.Execute(SQLSectionSeats)
	
	    OrderSection = rsOrderSeats("Section")
	    OrderSectionCode = rsOrderSeats("SectionCode")
	    OrderEventCode = rsOrderSeats("EventCode")	
	    OrderSeatCount = rsOrderSeats("OrderSeatCount")
	    SectionSeatCount = rsSectionSeats("SectionSeatCount")


	    If OrderSeatCount < RequiredCount Then 'Not all seats were selected.  Go to warning page	
		    rsSectionSeats.Close
		    Set rsSectionSeats = nothing		
		    Call WarningPage(OrderSeatCount, SectionSeatCount, OrderSection, OrderEventCode, OrderSectionCode)		
		    Exit Sub
		Else
		    Call SurveyForm		
		    Exit Sub		
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

AdditionalProductions = (SeriesCount - ActCount)

If OrderSeatCount = 1 Then
	 s = ""
Else
	 s = "s"
End If

%>

<html>
<head>
<title><%= title %></title>
<head>

</head>

<%= strBody %>

<!--#include virtual="TopNavInclude.asp"-->

<table width="90%" cellpadding="5" cellspacing="0" border="0">
<tr bgcolor="<%=TableCategoryBGColor%>">
    <td align="center">
        <FONT FACE="<%= FontFace %>" COLOR="<%=TableCategoryFontColor%>" SIZE="4">
        <b>SORRY</b></FONT>
    </td>
</tr>
<tr>
    <td><HR /></td>
</tr>
<tr>
    <td align="center">
    <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">
    Tables in this section require a minimum purchase of 8 seats.</FONT><BR>
    <br />
    <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">
    You have only selected <%= OrderSeatCount %> seat<%=s%> at <b> <%= OrderSection %> </b>.</FONT><BR>
    <br />
    <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">
    Please select a seat from SPONSOR TABLES 27-36 for purchases less than 8 seats.</FONT><br />
<%
If Session("UserNumber") = "" Then 'Internet order
%> 
    <CENTER>
  <FORM ACTION="/Section.asp?Event=<%= OrderEventCode %>&Section=<%= OrderSectionCode %>&Details=NO" METHOD="POST" id="form2" name="form2" style="width:15em;" />
    <INPUT TYPE="submit" VALUE="Add Additional Seats" id="Submit2" name="form2"></FORM>    
    <FORM ACTION="/ShoppingCart.asp" METHOD="POST" id="form1" name="form1">
    <INPUT TYPE="submit" VALUE="View Shopping Cart" id="Submit1" name="form1" style="width:15em;" />
    </FORM>
    </CENTER>
<%
Else 'Box Office Order
%> 
    <CENTER>
    <FORM ACTION="/Management/SectionRowSelect.asp?Event=<%= OrderEventCode %>&Section=<%= OrderSectionCode %>&Details=NO" METHOD="POST" id="form3" name="form1" style="width:15em;" />
    <INPUT TYPE="submit" VALUE="Add Additional Seats" id="Submit3" name="form1"></FORM>
    <FORM ACTION="/Management/ShoppingCart.asp" METHOD="POST" id="form4" name="form2">
    <INPUT TYPE="submit" VALUE="View Shopping Cart" id="Submit4" name="form2" style="width:15em;" />
    </FORM>
    </CENTER>   
<%
End If
%> 
    </td>
</tr>
<tr>
    <td><HR /></td>
</tr> 
</table>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>
</html>

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



<table width="90%" cellpadding="5" cellspacing="0" border="0">
<tr bgcolor="<%=TableCategoryBGColor%>">
    <td colspan="4" align="center">
        <FONT FACE="<%= FontFace %>" COLOR="<%=TableCategoryFontColor%>" SIZE="4">
        <b>Audience Survey</b></FONT>
        <BR>
        <FONT FACE="<%= FontFace %>" COLOR="<%=TableCategoryFontColor%>" SIZE="2">&nbsp;<br /></FONT>
    </td>
</tr>
<tr>
    <td colspan="4"><HR /></td>
</tr>
    <td rowspan=2 width="5%" valign="middle" align="center">
        <FONT FACE="<%= FontFace %>" COLOR="<%= HeadingFontColor %>" SIZE="2">
        <h3><!-- Question 1 --></h3>
    </td>
</tr>
<tr>
    <td align="right">
        <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">
        <b>Please indicate which organization<BR />referred you to purchase tickets</B>
        </FONT>
    </td>
	<td>&nbsp;&nbsp;&nbsp;</td>
	<td align="left">	   
	            <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">     
			    <SELECT NAME="Answer1">
			    <OPTION VALUE="0">Please select.....</OPTION><BR>
	            <OPTION VALUE="<%= SurveyFields(1, 1) %>">&nbsp;<%= SurveyFields(1, 1) %></OPTION><BR>
	            <OPTION VALUE="<%= SurveyFields(1, 2) %>">&nbsp;<%= SurveyFields(1, 2) %></OPTION><BR>
	            <OPTION VALUE="<%= SurveyFields(1, 3) %>">&nbsp;<%= SurveyFields(1, 3) %></OPTION><BR>
	            <OPTION VALUE="<%= SurveyFields(1, 4) %>">&nbsp;<%= SurveyFields(1, 4) %></OPTION><BR>
	            <OPTION VALUE="<%= SurveyFields(1, 5) %>">&nbsp;<%= SurveyFields(1, 5) %></OPTION><BR>
	            <OPTION VALUE="<%= SurveyFields(1, 6) %>">&nbsp;<%= SurveyFields(1, 6) %></OPTION><BR>
	            <OPTION VALUE="<%= SurveyFields(1, 7) %>">&nbsp;<%= SurveyFields(1, 7) %></OPTION><BR>
	            <OPTION VALUE="<%= SurveyFields(1, 8) %>">&nbsp;<%= SurveyFields(1, 8) %></OPTION><BR>
	            <OPTION VALUE="<%= SurveyFields(1, 9) %>">&nbsp;<%= SurveyFields(1, 9) %></OPTION><BR>
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



