<%

'CHANGE LOG - Inception
'SSR (9/6/2011) - WORKING SURVEY (NO RADIO BUTTONS / NO CHECK BOXES)

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'===============================================

Page = "Survey"
SurveyNumber = 676
SurveyName = "RegistrationSurvey.asp"

'===============================================

'Adventure Theater (9/6/2011)
'Registration Class/Worshop Survey

SurveyTitle = "Class Registration"
SurveyHeader = "Please enter each student's information below:"

Dim Question(17)
NumQuestions = 16

Question(1) = "First Name"	
Question(2) = "Last Name"	
Question(3) = "Gender"	
Question(4) = "Date of Birth"	
Question(5) = "Age"	
Question(6) = "Grade"
Question(7) = "School"	
Question(8) = "Parent/Guardian Name"	
Question(9) = "Emergency Contact Name"	
Question(10) = "Emergency Contact Phone Number"
Question(11) = "Who where you referred by?"
Question(12) = "Physician Name"
Question(13) = "Physician Phone"
Question(14) = "Date of last Tetanus Shot"
Question(15) = "AddMedical"
Question(16) = "By checking the box below, I hereby grant to Adventure Theatre (“Photographer”) the absolute right and permission to take, use, reuse, publish and republish photographic portraits, pictures or video of the minor or in which they may be included for promotional purposes only. All photos will be properly protected and monitored by Adventure Theatre for inappropriate and/or unauthorized public use.  I hereby waive the right that I or the minor might have to inspect or approve the finished product or products or the advertising copy or printed matter that may be used in connection therewith or the use to which it may be applied.<BR><BR>I hereby release, discharge and agree to save harmless and defend Photographer, his/her legal representatives or assigns, and all persons acting under his/her permission or authority or those whom he/she is acting, from any liability by virtue of any blurring, distortion, alteration, optical illusion, or use in composite form, whether intentional or otherwise, that may occur of be produced in the taking of said picture or video or in any subsequent processing thereof, as well as any publication thereof, including without limitation and claims for libel or violation of any right of publicity or privacy.<BR><BR>I hereby warrant that I am of full age and have every right to contract the minor in the above regard. I state further that by checking the YES box, that I have read the above authorization, release and agreement prior to its execution, and that I am fully familiar with the contents thereof. This release shall be binding upon the minor and me, and our respective heirs, legal representatives and assigns."


Dim Grade(12)
NumGrades = 12
Grade(0) = "Kindergarden"
Grade(1) = "1st Grade"
Grade(2) = "2nd Grade"
Grade(3) = "3rd Grade"
Grade(4) = "4th Grade"
Grade(5) = "5th Grade"
Grade(6) = "6th Grade"
Grade(7) = "7th Grade"
Grade(8) = "8th Grade"
Grade(9) = "9th Grade"
Grade(10) = "10th Grade"
Grade(11) = "11th Grade"
Grade(12) = "12th Grade"


'================================================

'Check to see if Order Number exists.  
'If not, redirect to Home Page.

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

'CSS Survey Variables

If Session("UserNumber")<> "" Then
    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "FFFFFF"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "000000"
    TableDataBGColor = "E9E9E9"
End If

'LastHex = box color
'FirstHex = background color

If Session("UserNumber")<> "" Then
    NECorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=008400&Src=TopLeftCorner16.txt"
    NWCorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=008400&Src=TopRightCorner16.txt"
    SWCorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=E9E9E9&Src=BottomLeftCorner16.txt"
    SECorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=E9E9E9&Src=BottomRightCorner16.txt"
Else
    NECorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=000000&Src=TopLeftCorner16.txt"
    NWCorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=000000&Src=TopRightCorner16.txt"
    SWCorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=f1f1f1&Src=BottomLeftCorner16.txt"
    SECorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=f1f1f1&Src=BottomRightCorner16.txt"
End If


'===============================================

Select Case Clean(Request("FormName"))

    Case "SurveyUpdate"
        Call SurveyUpdate
    Case "Continue"
        Call Continue
    Case Else
        Call SurveyForm
End Select

'===============================================

Sub SurveyForm

'Determine if required event is in the shopping cart

AvailOfferCount = 0
 
SQLRequiredTicketCount = "SELECT COUNT(OrderLine.ItemNumber) AS Count FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.ItemType = 'Seat'"' GROUP BY Seat.EventCode ORDER BY Seat.EventCode"
Set rsRequiredTicketCount = OBJdbConnection.Execute(SQLRequiredTicketCount)
    
If Not rsRequiredTicketCount.EOF Then
    AvailOfferCount = rsRequiredTicketCount("Count")
End If
	
rsRequiredTicketCount.Close
Set rsRequiredTicketCount = nothing  

If AvailOfferCount  => 1 Then
    Call DisplaySurvey(Message)
Else
    Call Continue
End If 
  

End Sub

'=======================================

Sub DisplaySurvey(Message)   

If DocType <> "" Then
    Response.Write(DocType)
Else
    Response.Write("<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">")
End If

%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<html>

<head>

<title>="<%= Title %>"</title>

<style type="text/css">    
body
{
    font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
    line-height: 1 em;
}
#rounded-corner
{
	font-size: 11px;
    font-weight: 400;
	text-align: left;
	border-collapse: collapse;
}
#rounded-corner thead th.category
{
	padding-top: 10px;
    padding-bottom: 10px;
    padding-left: 0px;
    padding-right: 1px;
	font-size: 15px;
	font-weight: 600;
	text-align: center;
	color: <%=TableCategoryFontColor%>;
	background: <%=TableCategoryBGColor%>;
}
#rounded-corner thead th.category-left
{
	background: <%=TableCategoryBGColor%> url('<%=NECorner%>') left -1px no-repeat;
	text-align: right;
}
#rounded-corner thead th.category-right
{
	background: <%=TableCategoryBGColor%> url('<%=NWCorner%>') right -1px no-repeat;
    text-align: left;
}
#rounded-corner td.footer
{
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.footer-left
{
    background: <%=TableDataBGColor%> url('<%=SWCorner%>') left bottom no-repeat;
}
#rounded-corner td.footer-right
{
	background: <%=TableDataBGColor%> url('<%=SECorner%>') right bottom no-repeat;
}
#rounded-corner td.data
{
	padding-left: 10px;
	padding-right: 10px;
	padding-top: 10px;
	padding-bottom: 10px;
	text-align: center;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-left
{
	padding-left: 0px;
	padding-right: 10px;
	padding-top: 10px;
	padding-bottom: 10px;
	text-align: right;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-right
{
	padding-left: 0px;
	padding-right: 0px;
	padding-top: 10px;
	padding-bottom: 10px;
    text-align: left;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
</style>


</head>

<% If Message = "" Then %>
    <body>
<% Else %>
	<body onLoad="alert('<%= Message %>');" <%= BodyParameters %>>
<% End If %>

<!--#INCLUDE virtual="TopNavInclude.asp"-->


<form action="<%= SurveyFileName %>" name="Survey" method="post">
<input type="hidden" name="FormName" value="SurveyUpdate">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">

<br />
<table id="tix-table" summary="surveypage" width="450" cellpadding="0" cellspacing="0" border="0">
<tbody>
    <tr>
        <td align="left">
	        <FONT FACE="<%= FontFace %>" SIZE="4">
            <b><%= FormName %></b></FONT>
        </td>
    </tr>
    <tr>
        <td >
        <FONT FACE="<%= FontFace %>" SIZE="2"><i><%= FormHeader %></i></FONT><br />
        <br />
        
        <%
        
        AvailOfferCount = 0

        SQLRequiredTicketCount = "SELECT COUNT(OrderLine.ItemNumber) AS Count FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.ItemType = 'Seat'"' GROUP BY Seat.EventCode ORDER BY Seat.EventCode"
        Set rsRequiredTicketCount = OBJdbConnection.Execute(SQLRequiredTicketCount)

        If Not rsRequiredTicketCount.EOF Then
        AvailOfferCount = rsRequiredTicketCount("Count")
        End If

        rsRequiredTicketCount.Close
        Set rsRequiredTicketCount = nothing  
        
        For i = 1 To AvailOfferCount
            
        SQLEvent = "SELECT Event.EventCode, Event.EventDate, Act.Act, Venue.Venue FROM OrderLine WITH (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event WITH (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act WITH (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue WITH (ROWLOCK) ON Event.VenueCode = Venue.VenueCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.LineNumber = " & i & " GROUP BY Event.EventCode, Event.EventDate, Act.Act, Venue.Venue ORDER BY Event.EventDate, Act.Act, Venue.Venue"
        Set rsEvent = OBJdbConnection.Execute(SQLEvent)   
            
        %>
        
        <table id="rounded-corner" summary="surveypage">
        <thead>
	        <tr>
    	        <th scope="col" class="category-left"></th>
    	        <th scope="col" class="category" colspan="2"><b><%=rsEvent("Act")%><br /><%=FormatDateTime(rsEvent("EventDate"), vbLongDate)%></th>
    	        <th scope="col" class="category-right"></th>
            </tr>        
       </thead>
        <tbody>
        
        <%

        'Question Count
        For j = 1 to NumQuestions 

            SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & i & " AND FieldName = 'Answer" & j & "'"
            Set rsOrderLineDetail = OBJdbConnection.Execute(SQLOrderLineDetail)  
            
            If Not rsOrderLineDetail.EOF Then
                FieldValue = rsOrderLineDetail("FieldValue")
            Else
                FieldValue = ""
            End If
            
            rsOrderLineDetail.Close
            Set rsOrderLineDetail = nothing
                 
       
            Select Case j
            
            %>

            
            <% Case 3 %>

            <tr>
                <td class="data-left" colspan="2"><%=Question(j)%></td>
                <td class="data-right" colspan="2">
                    <% 
                    FieldValue_Y = ""
                    FieldValue_N = ""
                    If FieldValue = "Male" Then FieldValue_Y = "CHECKED" End If
                    If FieldValue = "Female" Then FieldValue_N = "CHECKED" End If
                    %>
                    <INPUT TYPE="radio" NAME="Answer<%=j%>_<%=i%>"  id="<%=Question(j)%>" VALUE="Male" <%=FieldValue_Y%>/>&nbsp;&nbsp;Male
                    <INPUT TYPE="radio" NAME="Answer<%=j%>_<%=i%>"  id="<%=Question(j)%>" VALUE="Female" <%=FieldValue_N%>>&nbsp;&nbsp;Female
                </td>
            </tr>

            <% Case 4,14 %> 

            <tr>
                <td class="data-left" colspan="2"><%=Question(j)%></td>                
                <td class="data-right" colspan="2">
                
                <% 
                
                If (ISDate(FieldValue)) Then
                    ChildDay = DatePart("d", FieldValue)
                    ChildMonth = DatePart("m", FieldValue)
                    ChildYear = DatePart("yyyy", FieldValue)
                Else
                    ChildDay = 0
                    ChildMonth = 0
                    ChildYear = 0
                End If                

                %>  
                                 
                    <select NAME="Answer<%=j%>_<%=i%>">
                    <option value="0">-Month-</option>
                    <%  
                    For m = 1 to 12 
                        If m = ChildMonth Then
                            FieldValue = "Selected"
                        Else
                            FieldValue = ""
                        End If
                    %>
                        <option value="<%=m%>" <%=FieldValue%>><%=m%></option>       
                    <% Next %>
                    </select>
                    
                    <select NAME="Answer<%=j%>_<%=i%>">
                    <option value="0">-Day-</option>
                    <%  
                    For d = 1 to 31 
                        If d = ChildDay Then
                            FieldValue = "Selected"
                        Else
                            FieldValue = ""
                        End If
                    %>
                        <option value="<%=d%>" <%=FieldValue%>><%=d%></option>       
                    <% Next %>
                    </select>
                    
                   <select NAME="Answer<%=j%>_<%=i%>">
                    <option value="0">-Year-</option>
                    <%  
                    For y = 2000 to 2011 
                        If y = ChildYear Then
                            FieldValue = "Selected"
                        Else
                            FieldValue = ""
                        End If
                    %>
                        <option value="<%=y%>" <%=FieldValue%>><%=y%></option>       
                    <% Next %>
                    </select>
                         
                </td>
            </tr>
            
            
           <% Case 5 %> 
           
            <!--Place Holder for the Age Field" I took it out, but I may put it back. Not sure yet.-->
            
           <% Case 6 %> 
           
            <tr>
                <td class="data-left" colspan="2"><%=Question(j)%></td>                
                <td class="data-right" colspan="2">
                
                <% 
                
                If FieldValue <> "" Then
                    ChildGrade = FieldValue
                Else
                    ChildGrade = 0
                End If                

                %>  
                                 
                <select NAME="Answer<%=j%>_<%=i%>">
                    <option value="0">-Grade-</option>
                    <%  
                    For x = 1 to 12 
                        If Grade(x) = ChildGrade Then
                            FieldOption = "Selected"
                        Else
                            FieldOption = ""
                        End If
                        %>
                        <option value="<%=Grade(x)%>" <%=FieldOption%>><%=Grade(x)%></option>       
                    <% Next %>
                    </select>
            
                
           <% Case 16 %>
            
            <tr>
                <td class="data">&nbsp;</td>
                
                <td class="data-right" colspan="2">
                    <font color = gray size = 1><I><%=Question(j)%></I></font>
                    <br />
                    <br />
                    <input type="checkbox" NAME="Answer<%=j%>_<%=i%>" value="Waiver Accepted">&nbsp;<b>I agree to the Terms and Conditions</b>
                </td>
                
                <td class="data">&nbsp;</td>
            </tr>
            
           <% Case Else %>  
                         
                 <tr>
                    <td class="data-left" colspan="2" NOWRAP><%=Question(j)%></td>
                    <td class="data-right" colspan="2"><INPUT TYPE="text" NAME="Answer<%=j%>_<%=i%>" id="<%=Question(j)%>" VALUE="<%=FieldValue%>" SIZE="24" /></td>
                </tr>   
            
          <%  End Select %> 
          
          <%  Next %>  
          
            <tr>
    	        <td class="footer-left">&nbsp;</td>
    	        <td class="footer" colspan="2">&nbsp;</td>
    	        <td class="footer-right">&nbsp;</td>
    	    </tr>
            </tbody>
            </table>
            
            <%
            
            rsEvent.Close
            Set rsEvent = nothing
            
            %>
            
        <br />
        <br />
        
        <%
            Next
        %>
        </td>    
    </tr>
</tbody>
</table>

<INPUT TYPE="submit" VALUE="Submit" name="sub">

</FORM>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%

End Sub ' SurveyForm

'===============================================
Sub SurveyUpdate


If Session("OrderNumber") <> "" Then

    SQLRequiredTicketCount = "SELECT COUNT(OrderLine.ItemNumber) AS Count FROM OrderLine (NOLOCK) INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.ItemType = 'Seat'"' GROUP BY Seat.EventCode ORDER BY Seat.EventCode"
    Set rsRequiredTicketCount = OBJdbConnection.Execute(SQLRequiredTicketCount)        
        If Not rsRequiredTicketCount.EOF Then
            AvailOfferCount = rsRequiredTicketCount("Count")
        End If    	
    rsRequiredTicketCount.Close
    Set rsRequiredTicketCount = nothing  

    For i = 1 To AvailOfferCount 

            For j = 1 to NumQuestions             
            
            Select Case j
            
             Case 4, 14
                 
                 'Format Answer into a Proper Date
                 
                 ProperDate = Replace(Clean(Request("Answer"&j&"_"&i)),", ","/")  
                 
                 If IsDate(ProperDate) Then
                    ProperDate = CDate(ProperDate)
                 Else
                    ProperDate = 0
                 End If                             
                
                'Delete existing Answer record for this line number.
                SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & i & " AND FieldName = 'Answer" & j & "'"
                Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)

                'Insert Answer record for this line number.          
                SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & i & ", 'Answer" & j & "', '" & ProperDate & "'  )"            
                Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)
                
             Case 5   
             
                 'Calculate AGE based on the ProperDate          
                 
                 If IsDate(ProperDate) Then
                    DOB = CDate(ProperDate)
                 Else
                    DOB = 0
                 End If
                       
                 If DOB = 0 Then
                    ChildAge = 0
                 Else  
                    TodaysDate = Date()
                    intAge = DateDiff("yyyy", DOB, TodaysDate)
                    If TodaysDate < DateSerial(Year(TodaysDate), Month(DOB), Day(DOB)) Then
                        intAge = intAge - 1
                    End If
                    ChildAge = intAge                
                End If  
                                
                'Delete existing Answer record for this line number.
                SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & i & " AND FieldName = 'Answer" & j & "'"
                Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)

                'Insert Answer record for this line number.          
                SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & i & ", 'Answer" & j & "', '" & ChildAge & "'  )"            
                Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail) 
             
             Case Else

                'Delete existing Answer record for this line number.
                SQLDeleteDetail = "DELETE OrderLineDetail WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & i & " AND FieldName = 'Answer" & j & "'"
                Set rsDetail = OBJdbConnection.Execute(SQLDeleteDetail)

                'Insert Answer record for this line number.          
                SQLInsertDetail = "INSERT OrderLineDetail (OrderNumber, LineNumber, FieldName, FieldValue) VALUES(" & Session("OrderNumber") & ", " & i & ", 'Answer" & j & "', '" & Clean(Request("Answer"&j&"_"&i)) & "'  )"            
                Set rsInsertDetail = OBJdbConnection.Execute(SQLInsertDetail)
            
            End Select
            
            Next

    Next	
	
End If	

Call FormValidate

End Sub 'SurveyUpdate

'==========================================================

Sub FormValidate

Validated_Form = true
Message = "Form Error"

FieldValue1 = ""
FieldValue3 = ""
FieldValue5 = ""
FieldValue7 = ""
FieldValue8 = ""

Form_Answer1 = Trim(Request.Form("Answer1"))
Form_Answer2 = Trim(Request.Form("Answer2"))
Form_Answer3 = Trim(Request.Form("Answer3"))
Form_Answer4 = Trim(Request.Form("Answer4"))
Form_Answer5 = Trim(Request.Form("Answer5"))
Form_Answer6 = Trim(Request.Form("Answer6"))
Form_Answer7 = Trim(Request.Form("Answer7"))
Form_Answer8 = Trim(Request.Form("Answer8"))
Form_Answer9 = Trim(Request.Form("Answer9"))
Form_Answer10 = Trim(Request.Form("Answer10"))
Form_Answer11 = Trim(Request.Form("Answer11"))
Form_Answer12 = Trim(Request.Form("Answer12"))
Form_Answer13 = Trim(Request.Form("Answer13"))
Form_Answer14 = Trim(Request.Form("Answer14"))
Form_Answer15 = Trim(Request.Form("Answer15"))
Form_Answer16 = Trim(Request.Form("Answer16"))
Form_Answer17 = Trim(Request.Form("Answer17"))

IF len(Form_Answer1)<1 AND len(Form_Answer3)<1 AND len(Form_Answer5)<1 AND len(Form_Answer7)<1 AND len(Form_Answer8)<1 THEN
   Validated_Form = false
   Message = "Please select at least one answer"
END IF

IF len(Form_Answer1)< 1 OR len(Form_Answer2)< 1 THEN
   Validated_Form = false
   Message = "Please provide the full name"
END IF

IF NOT Validated_Form THEN
    Call  DisplaySurvey(Message) 
Else
    Call ValidateForm
End If


End Sub 'Validateform


'========================================================== 
 
Sub Continue

   Session("SurveyComplete") = Session("OrderNumber")
    If Session("UserNumber") = "" Then
	    Response.Redirect("/Ship.asp")
    Else
	    Response.Redirect("/Management/AdvanceShip.asp")
    End If
        
End Sub 'Continue

'==========================================================

%>