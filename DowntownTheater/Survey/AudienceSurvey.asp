<%

'CHANGE LOG - Inception
'SSR (8/30/2011)
'Custom Survey

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<!--#include virtual="/Discounts/DiscountScriptInclude.asp"-->

<%

'============================================================

Page = "Survey"
SurveyNumber = 850
SurveyName = "AudienceSurvey.asp"
BoxOfficeByPass = False

'============================================================

SurveyTitle = "SurveyTitle"
SurveyHeader = "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?"

'============================================================
 
'Verify that Order Number exists - if not bounce back to default page
'Verify that User Number exists - if so display management tabs

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

'============================================================

'Bypass this survey on all Comp Orders
'Bypass this survey for Box Office Users

If Session("OrderTypeNumber") = 5 Then
	Call Continue
End If

If Session("OrderTypeNumber") <> 1 Then
    If BoxOfficeByPass Then
	    Call Continue
    End If
End If

'============================================================

'Request the form name and process requested action

Select Case Clean(Request("FormName"))
    Case "Continue"
        Call Continue
    Case Else
        Call SurveyForm
 End Select   

'==========================================================
	
Sub SurveyForm

If DocType <> "" Then
	Response.Write DocType
Else
	Response.Write "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
End If

%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<html>
<head>

<title>TIX.com</title>

</head>

<body>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<form action="<%= SurveyFileName %>" method="post" name="Survey">
<input type="hidden" name="FormName" value="SurveyUpdate">
<INPUT TYPE="hidden" NAME="SurveyNumber" VALUE="<%= SurveyNumber %>">


<table id="rounded-corner" summary="surveypage">
<thead>
    <tr>
	    <th scope="col" class="category-left"></th>
	    <th scope="col" class="category" colspan="2"><%=SurveyTitle%></th>
	    <th scope="col" class="category-right"></th>
    </tr>        
</thead>
<tbody>
    <tr>
        <td class="data-right">&nbsp;</td>
        <td class="data-left" colspan="2"><%=SurveyHeader%></td>
        <td class="data-right">&nbsp;</td>
    </tr>
     
        SQLTicketCount = "SELECT OrderLine.LineNumber, OrderLine.SeatTypeCode, SeatType FROM OrderLine (NOLOCK) INNER JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode WHERE OrderNumber = " & Session("OrderNumber") & " ORDER BY OrderLine.LineNumber"
        Set rsTicketCount = OBJdbConnection.Execute(SQLTicketCount)   
         
        Do While Not rsTicketCount.EOF 
        
        'Attendee Count
        i = rsTicketCount("LineNumber")
            
                SQLEvent = "SELECT Event.EventCode, Event.EventDate, Act.Act, Venue.Venue FROM OrderLine WITH (NOLOCK) INNER JOIN Seat WITH (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event WITH (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN Act WITH (NOLOCK) ON Event.ActCode = Act.ActCode INNER JOIN Venue WITH (ROWLOCK) ON Event.VenueCode = Venue.VenueCode WHERE OrderLine.OrderNumber = " & Session("OrderNumber") & " AND OrderLine.LineNumber = " & rsTicketCount("LineNumber") & " GROUP BY Event.EventCode, Event.EventDate, Act.Act, Venue.Venue ORDER BY Event.EventDate, Act.Act, Venue.Venue"
                Set rsEvent = OBJdbConnection.Execute(SQLEvent)   
                    
                %>
                    
                <br />
                <table id="Table1" summary="surveypage">
                <thead>
	                <tr>
    	                <th scope="col" class="category-left"></th>
    	                <th scope="col" class="category" colspan="2"><b><%=rsEvent("Act")%>&nbsp;-&nbsp;<%=FormatDateTime(rsEvent("EventDate"), vbLongDate)%><br /><b>Attendee <%=i%></b></th>
    	                <th scope="col" class="category-right"></th>
                    </tr>        
               </thead>
                <tbody>
                        <%
                        
                        'Question Count
                        For j = 1 to UBound(Questions)
                        
                            SQLOrderLineDetail = "SELECT FieldValue FROM OrderLineDetail WITH (ROWLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & i & " AND FieldName = 'Answer" & j & "'"
		                    Set rsOrderLineDetail = OBJdbConnection.Execute(SQLOrderLineDetail)  
        		            
                            If Not rsOrderLineDetail.EOF Then
                                FieldValue = rsOrderLineDetail("FieldValue")
                            Else
                                FieldValue = ""
                            End If
                            
                            rsOrderLineDetail.Close
                            Set rsOrderLineDetail = nothing
        		                     
                            %>
                            <tr>
                                <td class="data-left" colspan="2"><%=Question(j)%></td>
                                <td class="data-right" colspan="2"><INPUT TYPE="text" ID = "<%=Question(j)%>" NAME="Answer<%=j%>_<%=i%>" VALUE="<%=FieldValue%>" SIZE="24" /></td>
                            </tr> 
                            <%                
                        Next
                        %>                
                        <tr>
    	                    <td class="footer-left">&nbsp;</td>
    	                    <td class="footer" colspan="2">&nbsp;</td>
    	                    <td class="footer-right">&nbsp;</td>
    	                </tr>
                        </tbody>
                        </table>
                        <br />
                    
                    <%
                    
                    rsEvent.Close
                    Set rsEvent = nothing
                
            rsTicketCount.Movenext    
            Loop

            rsTicketCount.Close
            Set rsTicketCount = nothing

            %>

        </td>    
    </tr>
</tbody>
</table>
<input type="submit" name="theButton" value="Continue"></form>

<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%

End Sub ' SurveyForm
    
      
    <tr>
        <td class="footer-left">&nbsp;</td>
        <td class="footer" colspan="2">&nbsp;</td>
        <td class="footer-right">&nbsp;</td>
    </tr>
    <tr>
        <td >&nbsp;</td>
        <td align="center" colspan="2"><br /><INPUT TYPE="submit" VALUE="Continue"></form></td>
        <td >&nbsp;</td>
    </tr>
</tbody>
</table>

<!--#INCLUDE virtual="FooterInclude.asp"-->
</body>
</htmlL>

<%

End Sub ' SurveyForm

'==========================================================

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
	
Else

   Call Continue

End If

End Sub

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