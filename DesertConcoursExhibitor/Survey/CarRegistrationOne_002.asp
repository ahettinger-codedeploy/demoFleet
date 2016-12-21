<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->

<%

'========================================
Page = "Survey"
SurveyNumber = 887
SurveyName = "CarRegistrationOne.asp"
    
RequiredEvent = 310389  'Concours d’Elegance Exhibitor Ticket  

Dim Question(16)
NumQuestions = 15

Question(1) = "Make"
Question(2) = "Model/Series"
Question(3) = "Year"
Question(4) = "Body Style"
Question(5) = "Coachbuilder"
Question(6) = "VIN/Mfg#"
Question(7) = "Color"
Question(8) = "Judge Car"
Question(9) = "Trailered"
Question(10) = "Trailer Size"
Question(11) = "Restored"
Question(12) = "Restored When"
Question(13) = "Restore Work"
Question(14) = "Show History Awards"
Question(15) = "Vehicle History"

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
TableFontFace = "Arial"
TableCategoryBGColor = "008400"
TableCategoryFontColor = "FFFFFF"
TableColumnHeadingBGColor = "99CC99"
TableColumnHeadingFontColor = "000000"
TableDataFontColor = "000000"
TableDataBGColor = "E9E9E9"
End If


If Clean(Request("FormName")) = "SurveyUpdate" Then
    Call SurveyUpdate
Else
    Call SurveyForm
End If


OBJdbConnection.Close
Set OBJdbConnection = nothing

'========================================

Sub SurveyForm

'Determine if required event is in the shopping cart  

AvailOfferCount = 0
 
SQLRequiredTicketCount = "SELECT COUNT(OrderLine.ItemNumber) AS Count FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND Seat.EventCode IN (310389) AND OrderLine.ItemType = 'Seat' GROUP BY Seat.EventCode ORDER BY Seat.EventCode"
Set rsRequiredTicketCount = OBJdbConnection.Execute(SQLRequiredTicketCount)
    
    If Not rsRequiredTicketCount.EOF Then
        AvailOfferCount = rsRequiredTicketCount("Count")
	End If
	
rsRequiredTicketCount.Close
Set rsRequiredTicketCount = nothing  

If AvailOfferCount  => 1 Then
    Call CarRegistrationOne 
Else
    Call CarRegistrationTwo
    Exit Sub  
End If 
  

End Sub

'=======================================

Sub CarRegistrationOne 

    If DocType <> "" Then
        Response.Write(DocType)
    Else
        Response.Write("<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">")
    End If

%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<html>
<head>

<%

'Dynamic Page Title
If Request("OrganizationNumber")<> "" And Title = "" Then
    SQLOrg = "SELECT Organization FROM Organization (NOLOCK) WHERE OrganizationNumber = " & CleanNumeric(Request("OrganizationNumber"))
    Set rsOrg = OBJdbConnection.Execute(SQLOrg)    
    Title = rsOrg("Organization") & " Ticket Sales"    
    rsOrg.Close
    Set rsOrg = nothing
End If  
 
%>

<title>="<%= Title %>"</title>

<style type="text/css">
<!--
@import url('/Clients/DesertConcours/Survey/Images/style.css');
-->
</style>

<script type="text/javascript" src="/Clients/DesertConcours/Survey/Images/usableforms.js"></script> 


</head>

<%=strBody %>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<form action="<%= SurveyFileName %>" name="Survey" method="post">
<input type="hidden" name="FormName" value="SurveyUpdate">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">

<! -- Table Begin -- >
<table id="tix-table" summary="surveypage" width="500">
<! -- Table Column Headings -- >
    <thead>
        <tr>
	        <th colspan="4" scope="col">EXHIBITOR APPLICATION FORM<br />Concours d’Elegance</th>
        </tr>
    </thead>
<! -- Table Body -- >
        <tbody>
            <tr>
	            <td class="headingcell">Vehicle Information</td><td>&nbsp;</td>
            </tr>
            <tr>
                <td class="labelcell">Make</td>
                <td class="fieldcell"><INPUT TYPE="text" NAME="Answer1" SIZE="24" /></td>
             </tr>
             <tr>
                <td class="labelcell">Model/Series</td>
                <td class="fieldcell"><INPUT TYPE="text" NAME="Answer2" SIZE="24" /></td>
            </tr>
            <tr>
                <td class="labelcell">Year</td>
                <td class="fieldcell"><INPUT TYPE="text" NAME="Answer3" SIZE="24" /></td>
             </tr>
             <tr>
                <td class="labelcell">Body Style</td>
                <td class="fieldcell"><INPUT TYPE="text" NAME="Answer4" SIZE="24" /></td>
            </tr>
            <tr>
                <td class="labelcell">Coachbuilder</td>
                <td class="fieldcell"><INPUT TYPE="text" NAME="Answer5" SIZE="24" /></td>
             </tr>
             <tr>
                <td class="labelcell">VIN & Mfg#</td>
                <td class="fieldcell"><INPUT TYPE="text" NAME="Answer6" SIZE="24" /></td>
            </tr>
            <tr>
                <td class="labelcell">Color</td>
                <td class="fieldcell"><INPUT TYPE="text" NAME="Answer7" SIZE="24" /></td>
            </tr>
            <tr>
                <td class="labelcell">Do you wish your car to be judged?</td>
                <td class="fieldcellradio"><INPUT TYPE="radio" NAME="Answer8" VALUE="Yes" />&nbsp;&nbsp;Yes&nbsp;&nbsp;&nbsp;&nbsp;<INPUT TYPE="radio" NAME="Answer8" VALUE="No">&nbsp;&nbsp;No</td>
            </tr>
            <tr>
                <td class="labelcell">Restored?</td>                
                <td class="fieldcellradio"><input type="radio" rel="restore" name="Answer9" value="Yes">&nbsp;&nbsp;Yes&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" rel="none" name="Answer9" value="No">&nbsp;&nbsp;No</td>
             </tr>
             <tr rel="restore">     
                <td class="labelcell">When Restored</td>
                <td class="fieldcell"><INPUT TYPE="text" NAME="Answer10" SIZE="24" /></td>
            </tr>
            <tr rel="restore"> 
               <td class="labelcell">Briefly describe the work</td>
               <td class="fieldcell"><TEXTAREA NAME="Answer11" COLS="23" ROWS="3"></TEXTAREA></td>
            </tr>
            <tr>
                <td class="labelcell">Show or Race History and Awards Received</td>
                <td class="fieldcell" colspan="3"><TEXTAREA NAME="Answer12" COLS="23" ROWS="3"></TEXTAREA></td>
            </tr>
            <tr>
                <td class="labelcell">Vehicle History</td>
                <td class="fieldcell" colspan="3"><TEXTAREA NAME="Answer15" COLS="23" ROWS="3"></TEXTAREA></td>
            </tr>
            <tr>
                <td class="labelcell">Trailered to Show</td>
                <td class="fieldcellradio"><input type="radio" rel="trailer" name="Answer13" value="Yes">&nbsp;&nbsp;Yes&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" rel="none" name="Answer13" value="No">&nbsp;&nbsp;No</td>
            </tr>
            <tr rel="trailer">      
                <td class="labelcell">Trailer Size (ft:)</td>
                <td class="fieldcell"><INPUT TYPE="text" NAME="Answer14" SIZE="24"></td>
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

Call CarRegistrationTwo

End Sub 'Update SurveyAnswer

'===========================

Sub CarRegistrationTwo

Response.Redirect("CarRegistrationTwo.asp")
Exit Sub


End Sub

'====================

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


