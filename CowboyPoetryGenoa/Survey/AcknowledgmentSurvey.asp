<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<!--#INCLUDE VIRTUAL="CalcCustomerFeeInclude.asp"-->
<%

Page = "Survey"
SurveyNumber = 917
SurveyName = "AcknowledgmentSurvey.asp"

'========================================
'The Town of Genoa & The Crown Valley Arts Council  (12/13/2010)
'Acknowledgment & Waiver Survey

NumQuestions = 2
Dim Question(3)
Question(1) = "Equine Owner"
Question(2) = "I have read the ticket policy."


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

<SCRIPT LANGUAGE="JavaScript">  
 <!-- Hide code from non-js browsers

function validateForm() {
     formObj = document.Survey;
 	var yes = 0;
 	var no = 0;

    if (eval("formObj.Answer2.checked") != true){
 		alert("You must check the box acknowledging the terms before proceeding.");
 		return false;
 		}
 	}

 // end hiding -->
 </SCRIPT>


</head>

<%= strBody %>

<!--#include virtual="TopNavInclude.asp"-->

<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey" onSubmit='return validateForm()'>
<INPUT TYPE="hidden" NAME="FormName" VALUE="SurveyUpdate">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">

<table width="90%" cellpadding="10" cellspacing="3">
<tr bgcolor="<%=TableCategoryBGColor%>">
    <td align="center" colspan="2">
        <FONT COLOR="<%=TableCategoryFontColor%>" SIZE="4">
        <b>WAIVER AND RELEASE OF LIABILITY<br />AND INDEMNITY AGREEMENT</b></FONT>
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
    <td align="center" colspan="2">
    <FONT SIZE="2">
    <B>PLEASE READ THE FOLLOWING VERY CAREFULLY.<BR />
    IT IS A BINDING CONTRACT THAT RELEASES<br />VARIOUS PARTIES FROM ANY LIABILITY TO YOU.</B>
    </FONT>
    </td>
</tr>
<tr>
    <td align="center" colspan="2">
    <FONT SIZE="2">
    By signing this Waiver and Release of Liability and Indemnity Agreement (hereinafter referred to as the “Release”), I agree to the following:
    </FONT>
    </td>
</tr>
<tr>
    <td bgcolor="<%=TableColumnHeadingBGColor%>"><FONT SIZE="2">1</FONT></td>
    <td bgcolor="<%=TableDataBGColor%>">
    <FONT SIZE="1">
    I am aware, understand and acknowledge the hazardous nature of equine activities, including pleasure
    riding, that it is an athletic sport that carries with it the potential risk of serious injury or death for its
    participants and their equines and that the equine I will be using or myself may be injured or die as a
    result of my negligence, the negligence of others or through no fault of my own or anyone else because
    of the nature of the equine activities.
    </FONT>
    </td>    
</tr>
<tr>
    <td bgcolor="<%=TableColumnHeadingBGColor%>"><FONT SIZE="2">2</FONT></td>
    <td bgcolor="<%=TableDataBGColor%>">
    <FONT SIZE="1">
    I am aware, understand and acknowledge that certain skills, capabilities and physical and mental health
    and fitness are required in order to reduce the dangers involved in the activities contemplated by this
    Release; I have these. Despite any instruction or training I may receive, I understand that any such
    instruction or training is no guarantee against loss, damage, injury or death and that it will not negate or
    limit the protections granted to the parties released hereunder.
    </FONT>
    </td>
</tr>
<tr>
    <td bgcolor="<%=TableColumnHeadingBGColor%>"><FONT SIZE="2">3</FONT></td>
    <td bgcolor="<%=TableDataBGColor%>">
    <FONT SIZE="1">
    I am aware and acknowledge that equines, even the most well trained, are often unpredictable and
    difficult to control and that there are inherent risks in equine activities, including, but not limited to: (i)
    the propensity for equines to behave in dangerous ways that may result in injury to myself and others;
    (ii) the inability to predict an equine’s reaction to sound, movement, objects (natural and man-made),
    persons or animals (wild and domestic), vehicles, weather conditions, stress and other hazards; and (iii)
    that hazards of surface or subsurface (varment holes, hills, rocks, water, etc.) conditions may exist.
    </FONT>
    </td>
</tr>
<tr>
    <td bgcolor="<%=TableColumnHeadingBGColor%>"><FONT SIZE="2">4</FONT></td>
    <td bgcolor="<%=TableDataBGColor%>">
    <FONT SIZE="1">
    I am aware, understand and acknowledge that all necessary precautions should be taken for safety,
    including, but not limited to, wearing long pants, an approved riding helmet and appropriate footgear,
    with heels. However, I am aware, understand and acknowledge that if I wish to participate without
    exercising these safety precautions, I do so at my own risk.
    </FONT>
    </td>
</tr>
<tr>
    <td bgcolor="<%=TableColumnHeadingBGColor%>"><FONT SIZE="2">5</FONT></td>
    <td bgcolor="<%=TableDataBGColor%>">
    <FONT SIZE="1">
    I represent that the equine I will be using is in good condition and fit to undertake the distance I have
    elected to go, and that I have reasonable control of the equine so as to avoid risk of injury to myself,
    others and property.
    </FONT>
    </td>
</tr>
<tr>
    <td colspan="2">
    <FONT SIZE="1">
    With knowledge of the foregoing, and as an inducement for the Genoa Cowboy Poetry & Music Festival, its
    officers, directors, members, agents, employees, staff, supervisory personnel, volunteers and guests, as well as
    all landowners involved, including, but not limited to, Douglas County, Nevada Parks and Open Spaces
    (hereinafter collectively referred to as the “Event Coordinator”), to allow me to participate in the 2011 Genoa
    Cowboy Poetry & Music Festival Pleasure Trail Ride (hereinafter referred to as “the Ride”), I agree to waive and
    release any and all rights I or my executors, heirs and assigns may have to make a claim or demand or to bring
    a cause of action or suit against the Event Coordinator as a result of any damage, injury or death I or any equine
    I am using may sustain or as a result of any damage to property from my participation in the Ride.
    </FONT>
    </td>
</tr>
<tr>
    <td colspan="2">
    <FONT SIZE="1">
    With knowledge of the foregoing, and as an inducement for the Event Coordinator to allow me to participate
    in the Ride, I agree to defend, indemnify and hold harmless the Event Coordinator from any and all claims,
    demands, causes of action, legal actions and suits, including, but not limited to, attorneys’ fees and costs incurred,
    that I might make or bring or that might be made or brought on my behalf by others, arising from my
    participation in the Ride, including, but not limited to any claims for injury or death, or loss of or damage to any
    property that may occur during the Ride. I further agree to defend, indemnify and hold harmless the Event
    Coordinator from all claims, demands, causes of action, legal actions and suits for injury, death or property
    damage arising from my conduct or the conduct of the equine I will be using. These indemnities apply even if
    the Event Coordinator is negligent or otherwise at fault.
    </FONT>
    </td>
</tr>
<tr>
    <td colspan="2">
    <FONT SIZE="1">
    I understand and expressly waive any and all rights or benefits of every kind and nature, whether known,
    unknown, suspected or unsuspected, I may have under Nevada law. I agree that the rights and duties under the
    Release will be construed in accordance with and governed by Nevada law and that proper and exclusive venue
    for any and all disputes arising out of or relating to the Release will be adjudicated by the Ninth Judicial District
    Court, Douglas County, Nevada.
    </FONT>
    </td>
</tr>
<tr>
    <td colspan="2">
    <FONT SIZE="1">
    I understand that I am forfeiting important legal rights and incurring important legal responsibilities.
    This Release shall remain in full force and effect unless expressly revoked, in writing, with receipt of such
    revocation acknowledged by the Carson Valley Arts Counsel.
    </FONT>
    </td>
</tr>
<tr>
    <td colspan="2">
    <FONT SIZE="1">
    THIS RELEASE CONTAINS THE ENTIRE AGREEMENT BETWEEN
    THE PARTIES. ITS TERMS ARE CONTRACTUAL AND NOT A MERE
    RECITAL. I DECLARE I HAVE CAREFULLY READ THIS RELEASE, I
    FULLY KNOW AND UNDERSTAND ITS CONTENTS, I HAVE SIGNED
    IT FREELY AND VOLUNTARILY AND THAT MY EXPRESS INTENT IS
    TO WAIVE, RELEASE, INDEMNIFY AND DISCHARGE ALL CLAIMS OF
    ANY CHARACTER AND TO BE FULLY AND LEGALLY BOUND BY THIS
    RELEASE.
    </FONT>
    </td>
</tr>
<tr>
    <td colspan="2">
        <table cellpadding="0" cellspacing="0">
        <tr>
            <td align="right"><FONT SIZE="2">Equine Owner:&nbsp;&nbsp;<br /><FONT SIZE="1"><i>(If Different than Participant)</i>&nbsp;&nbsp;</FONT></td>
            <td><FONT SIZE="2"><INPUT TYPE="text" NAME="Answer1" SIZE="24"></font></td>    
        </tr>
        </table>    
    </td>
</tr>
<tr>
    <td><FONT SIZE="2"><INPUT TYPE="checkbox" NAME="Answer2" VALUE="Yes"></FONT></td>
    <td><FONT SIZE="2">I acknowledge that I have read and agree to the terms and conditions as set forth above.</FONT></td>
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

End Sub 'SurveyUpdate
		
	
'========================================

Sub Continue

Response.Redirect("MinorWaiverSurvey.asp")
Exit Sub


End Sub

'========================================	


%> 
