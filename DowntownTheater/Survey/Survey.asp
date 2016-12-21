<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<!--#INCLUDE VIRTUAL="CalcCustomerFeeInclude.asp"-->
<%

Page = "Survey"
SurveyNumber = 857
SurveyName = "Survey.asp"

'========================================

'The Town of Genoa & The Crown Valley Arts Council  (12/13/2010)
'Acknowledgment & Waiver Survey

NumQuestions = 1
Dim Question(2)
Question(1) = "I have read the ticket policy."


'========================================

'Check to see if Order Number exists.  If not, redirect to Home Page.
If Session("OrderNumber") = "" Then
	If Session("UserNumber") = "" Then
		Response.Redirect("/Default.asp")
	Else
		Response.Redirect("/Management/Default.asp")
	End If
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

<style type="text/css">
body
{
font-family: "Myriad Web",Verdana,Helvetica,Arial,sans-serif;
}
div
{
width: 640px;
{
.category 
{ 	
padding-top:15px; 
padding-bottom:15px; 
padding-left:10px; 
padding-right:0px; 
background-color:<%= TableCategoryBGColor %>;

text-align: center;
font-size: medium;
font-weight: 700;
color: <%= TableCategoryFontColor %>;

border-width:1px;
border-style:solid;
border-color:<%= BGColor %>;
border-collapse:collapse;
}
.column
{ 
padding-top:0px; 
padding-bottom:0px; 
padding-left:5px; 
padding-right:5px; 
background-color: <%= TableColumnHeadingBGColor %>;

text-align:center;
font-size: x-small;
font-weight: 400;
color: <%= TableColumnHeadingFontColor %>;

border-width:1px;
border-style:solid;
border-color:<%= BGColor %>;
border-collapse:collapse;
}
.data
{ 
width:635px;	
padding-top:10px; 
padding-bottom:10px; 
padding-left:10px; 
padding-right:0px; 
background-color: <%= TableDataBGColor %>;

text-align: left;
font-size: x-small;
font-weight: 400;
color: <%= TableDataFontColor %>;

border-width:1px;
border-style:solid;
border-color:<%= BGColor %>;
border-collapse:collapse;
}
.schedule
{
padding-top:5px; 
padding-bottom:0px; 
padding-left:5px; 
padding-right:5px;
background-color: <%= BGColor %>;
	
text-align: left;
font-size: x-small;
font-weight: 400;
color: <%= FontColor %>;

border-width:1px;
border-style:solid;
border-color:<%= BGColor %>;
border-collapse:collapse;
}
.header
{
padding-top:20px; 
padding-bottom:5px; 
padding-left:0px; 
padding-right:0px;
background-color: <%= BGColor %>;

text-align: center;
font-size: small;
font-weight: 600;
color: <%= FontColor %>;
}
</style>

</head>

<body>

<!--#include virtual="TopNavInclude.asp"-->

<FORM ACTION="<%= SurveyFileName %>" METHOD="post" NAME="Survey" onSubmit='return validateForm()'>
<INPUT TYPE="hidden" NAME="FormName" VALUE="SurveyUpdate">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">

    <div class="category">
    Release of Liability and Indemnity Agreement
    </div>

    <div class="header">
    Please ready this very carefully.
    </div>

    <div class="column">1</div>
    <div class="data">
    I am aware, understand and acknowledge the hazardous nature of equine activities, including pleasure
    riding, that it is an athletic sport that carries with it the potential risk of serious injury or death for its
    participants and their equines and that the equine I will be using or myself may be injured or die as a
    result of my negligence, the negligence of others or through no fault of my own or anyone else because
    of the nature of the equine activities.
    </div>   


    <div class="column">2</div>
    <div class="data">
    I am aware, understand and acknowledge that certain skills, capabilities and physical and mental health
    and fitness are required in order to reduce the dangers involved in the activities contemplated by this
    Release; I have these. Despite any instruction or training I may receive, I understand that any such
    instruction or training is no guarantee against loss, damage, injury or death and that it will not negate or
    limit the protections granted to the parties released hereunder.
    </div>


    <div class="column">3</div>
    <div class="data">
    I am aware and acknowledge that equines, even the most well trained, are often unpredictable and
    difficult to control and that there are inherent risks in equine activities, including, but not limited to: (i)
    the propensity for equines to behave in dangerous ways that may result in injury to myself and others;
    (ii) the inability to predict an equine’s reaction to sound, movement, objects (natural and man-made),
    persons or animals (wild and domestic), vehicles, weather conditions, stress and other hazards; and (iii)
    that hazards of surface or subsurface (varment holes, hills, rocks, water, etc.) conditions may exist.
    </div>


    <div class="column">4</div>
    <div class="data">
    I am aware, understand and acknowledge that all necessary precautions should be taken for safety,
    including, but not limited to, wearing long pants, an approved riding helmet and appropriate footgear,
    with heels. However, I am aware, understand and acknowledge that if I wish to participate without
    exercising these safety precautions, I do so at my own risk.
    </div>


    <div class="column">5</div>
    <div class="data">
    I represent that the equine I will be using is in good condition and fit to undertake the distance I have
    elected to go, and that I have reasonable control of the equine so as to avoid risk of injury to myself,
    others and property.
    </div>


    <div class="schedule" colspan="2">
    I understand and expressly waive any and all rights or benefits of every kind and nature, whether known,
    unknown, suspected or unsuspected, I may have under Nevada law. I agree that the rights and duties under the
    Release will be construed in accordance with and governed by Nevada law and that proper and exclusive venue
    for any and all disputes arising out of or relating to the Release will be adjudicated by the Ninth Judicial District
    Court, Douglas County, Nevada.
    </div>


    <div class="schedule" colspan="2">
    I understand that I am forfeiting important legal rights and incurring important legal responsibilities.
    This Release shall remain in full force and effect unless expressly revoked, in writing, with receipt of such
    revocation acknowledged by the Carson Valley Arts Counsel.
    </div>


    <div class="schedule" ><INPUT TYPE="checkbox" NAME="Answer1" VALUE="Yes"></div>
    <div class="schedule" >I acknowledge that I have read and agree to the terms and conditions as set forth above.</div>

</table>
<BR>
<BR>
<INPUT TYPE="submit" VALUE="Continue"></FORM>

<!--#INCLUDE virtual="FooterInclude.asp"-->

<HEAD>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
</HEAD>


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
