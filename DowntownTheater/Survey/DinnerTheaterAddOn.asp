<%

'CHANGE LOG 
'SSR - 4/19/2013 - Event Add On Survey
'SSR - 6/14/2013 - Updated to include Box Seats

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->

<%

'===============================================

Page = "Survey"
SurveyNumber = 1471
SurveyName = "DinnerTheaterAddOn.asp"

'===============================================

'Survey Variables

If Session("UserNumber")<> "" Then
    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "#FFFFFF"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "#000000"
    TableDataBGColor = "#E9E9E9"
    ClientFolder= "Tix"
Else
    ClientFolder = "HenryStraterTheatre"
End If

'===============================================

'New Strater Corp
'Dinner Event Add On

'If patron selects a ticket from this list of valid ticket types:

'Adult (1)	
'Senior (60 and over) (23)	
'Student (w/ ID) (1119)
'Child (under 12) (1575)	
'Military (with Military ID) (223)	
'Group (10+) (157)	
'Group (30 +) (1742)	
'Box Seat (5644)

'Each ticket will be offered 4 possible dinner options:

'The Henry Strater Theatre Special             	$19.95
'The Mahogany Grille Special    				$27.00
'The Child Meal                 				$12.95
'No Dinner                         				n/a

'EXCEPT

'If the ticket is a "Child (under 12)" ticket, only 2 options offered:

'The Child Meal                 $12.95
'None                           n/a


'When the patron selects a dinner option, the order will be updated
'the ticket type will be changed to reflect the new meal selection.
'the price will be updated to include the cost of the dinner
'No change to the service fees

'Example:  "Adult Ticket" priced at $23.00 with "The Mahogany Grille Special" becomes "Adult Ticket with $27.00 Mahogany Grille" priced at $50.00


'===============================================

'Survey Variables



SeatTypeList = "1,23,1119,1575,223,157,1742,5644"  'Adult, Individual, Student, Group etc...

ChildTicketType = "1575"

MealName1 = "The Mahogany Grille Special"
MealPrice1 = "$27.00"

MealName2 = "The Henry Strater Theatre Special"
MealPrice2 = "$19.95"

MealName3 = "The Child Meal (12 & under)"
MealPrice3 = "$12.95"

'===============================================

'Check to see if Order Number exists.  If not, redirect to Home Page.


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

'Survey Start. Request Form name and process requested action

Select Case Request("FormName")
	Case "ApplyAddOn"
		Call ApplyAddOn
	Case "Continue"
		Call Continue
	Case Else
		Call TicketOffer(Message)
End Select

'===============================================

Sub TicketOffer(Message)

%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>

<title>Survey Page</title>

<style type="text/css">
body
{
line-height: 1 em;
}
#rounded-corner
{
	font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
	font-size: 12px;
	font-weight: 400;
	width: 550px;
	text-align: left;
	border-collapse: collapse;
}
#rounded-corner thead th.category
{

	color: <%=TableCategoryFontColor%>;
	background: <%=TableCategoryBGColor%>;
}
#rounded-corner thead th.category-left
{
	background: <%=TableCategoryBGColor%> url('/Clients/<%=ClientFolder%>/Survey/Images/nw.gif') left -1px no-repeat;
	text-align: right;
}
#rounded-corner thead th.category-right
{
	background: <%=TableCategoryBGColor%> url('/Clients/<%=ClientFolder%>/Survey/Images/ne.gif') right -1px no-repeat;
    text-align: left;
}
#rounded-corner td.category
{
	padding-top: 5px;
	padding-left: 20px;
	padding-right: 20px;
	padding-bottom: 5px;
	font-size: 15px;
	font-weight: 600;
	color: <%=TableCategoryFontColor%>;
	background: <%=TableCategoryBGColor%>;
}
#rounded-corner td.footer
{
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.footer-left
{
	background: <%=TableDataBGColor%> url('/Clients/<%=ClientFolder%>/Survey/Images/sw.gif') left bottom no-repeat;
}
#rounded-corner td.footer-right
{
	background: <%=TableDataBGColor%> url('/Clients/<%=ClientFolder%>/Survey/Images/se.gif') right bottom no-repeat;
}
#rounded-corner td.data
{
	padding-top: 5px;
	padding-left: 20px;
	padding-right: 20px;
	padding-bottom: 5px;
	font-weight: normal;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-option
{
	line-height: 3em;
    padding-top: 5px;
	padding-left: 20px;
	padding-right: 20px;
	padding-bottom: 5px;
	font-weight: normal;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}		
</style>

</head>

<%

If Message = "" Then
    Response.Write "<BODY BGCOLOR=" & BGColor & " LINK="& LinkColor & " ALINK=" & ALinkColor & " VLINK=" & VLinkColor & " leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0 " & BodyParameters & ">" & vbCrLf
Else
    Response.Write "<BODY BGCOLOR=" & BGColor & " LINK="& LinkColor & " ALINK=" & ALinkColor & " VLINK=" & VLinkColor & " onLoad=""alert('" & Message & "');"" leftmargin=0 rightmargin=0 topmargin=0 marginheight=0 marginwidth=0 " & BodyParameters & ">" & vbCrLf
End If
Response.Write "<CENTER>"	

%>							

<!--#INCLUDE virtual="TopNavInclude.asp"-->
<br />
<table id="rounded-corner" summary="surveypage">
<thead>
    <tr>
	    <th scope="col" class="category-left"></th>
	    <th scope="col" class="category" colspan="2">&nbsp;</th>
	    <th scope="col" class="category-right"></th>
    </tr>        
</thead>
    <tbody>
    <tr>
	    <td class="category" colspan="4">
	        <b>DINNER OPTIONS</b>
	    </td>
	</tr>
    <tr>
         <td class="data" colspan="4">
            <br />
            <B>Would you like to add a meal to your order?</B><br />
            <br />
            Please select from the menu options below if you would like to add a dinner to your order.<BR>
            <BR>
            Reservations are required.<br />
            <br />
            Please call the Box Office to confirm a time at 970 375 7160.<br />
            <br />
            Price includes tax, but not gratuity.<BR>
        </td>
    </tr>
    <tr>
        <td class="footer-left">&nbsp;</td>
        <td class="footer" colspan="2">&nbsp;</td>
        <td class="footer-right">&nbsp;</td>
    </tr>
 </table>
 <br />
 <br />
 
<%
	
	'Prevent applying add-on dinners
    SQLSeatTypeCode = "SELECT LineNumber FROM OrderLine (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " AND SeatTypeCode NOT IN (" & SeatTypeList & ")"
    Set rsSeatTypeCode = OBJdbConnection.Execute(SQLSeatTypeCode)
    If Not rsSeatTypeCode.EOF Then
        Call Continue
    End If    
    rsSeatTypeCode.Close
    Set rsSeatTypeCode = Nothing
%>

<form action="<%= SurveyName %>" name="Survey" method="post">
<input type="hidden" name="FormName" value="ApplyAddOn">
<input type="hidden" name="SurveyNumber" value="<%= SurveyNumber %>">

<%
    
SQLDinnerOptions = "SELECT OrderLine.LineNumber, OrderLine.SeatTypeCode, SeatType FROM OrderLine (NOLOCK) INNER JOIN SeatType (NOLOCK) ON OrderLine.SeatTypeCode = SeatType.SeatTypeCode WHERE OrderNumber = " & Session("OrderNumber") & " ORDER BY OrderLine.LineNumber"
Set rsDinnerOptions = OBJdbConnection.Execute(SQLDinnerOptions)   
 
Do While Not rsDinnerOptions.EOF

%>

<table id="rounded-corner" summary="surveypage">
<thead>
    <tr>
	    <th scope="col" class="category-left"></th>
	    <th scope="col" class="category" colspan="2">&nbsp;</th>
	    <th scope="col" class="category-right"></th>
    </tr>        
</thead>
    <tbody>
    <tr>
        <td class="category" colspan="4">
        PATRON <%= rsDinnerOptions("LineNumber") %> - <%= rsDinnerOptions("SeatType") %>
        </td>
    </tr>  
    
    <%
    
    If rsDinnerOptions("SeatTypeCode") <> ChildTicketType Then 
    
    %>
         
    <tr>
        <td class="data-option" colspan="4">
        Please select a meal option:<br />
        <INPUT TYPE="radio" NAME="SeatTypeCode<%= rsDinnerOptions("LineNumber") %>" VALUE="27">&nbsp;<%= MealPrice1 %>&nbsp;-&nbsp;<%= MealName1 %><br />
        <INPUT TYPE="radio" NAME="SeatTypeCode<%= rsDinnerOptions("LineNumber") %>" VALUE="19.95">&nbsp;<%= MealPrice2 %>&nbsp;-&nbsp;<%= MealName2 %><br />
        <INPUT TYPE="radio" NAME="SeatTypeCode<%= rsDinnerOptions("LineNumber") %>" VALUE="12.95">&nbsp;<%= MealPrice3 %>&nbsp;-&nbsp;<%= MealName3 %><br />
        <INPUT TYPE="radio" NAME="SeatTypeCode<%= rsDinnerOptions("LineNumber") %>" VALUE="0" CHECKED="CHECKED">None<br />
        </td>
    </tr>
    
    <%
    
    Else
    
    %>
    
    <tr>
        <td class="data-option" colspan="4">
        Please select a meal option:<br />
        <INPUT TYPE="radio" NAME="SeatTypeCode<%= rsDinnerOptions("LineNumber") %>" VALUE="12.95">&nbsp;<%= MealPrice3 %>&nbsp;-&nbsp;<%= MealName3 %><br />
        <INPUT TYPE="radio" NAME="SeatTypeCode<%= rsDinnerOptions("LineNumber") %>" VALUE="0" CHECKED="CHECKED">None<br />
        </td>
    </tr>
    
    <%
    
    End If
    
    %>
    
    <tr>
        <td class="footer-left">&nbsp;</td>
        <td class="footer" colspan="2">&nbsp;</td>
        <td class="footer-right">&nbsp;</td>
    </tr>
    </tbody>
 </table>
<br />
<br />
<%
    
rsDinnerOptions.Movenext    
Loop

rsDinnerOptions.Close
Set rsDinnerOptions = nothing

%>

<INPUT TYPE="SUBMIT" VALUE="Submit">
</FORM>

	
<!--#INCLUDE virtual="FooterInclude.asp"-->

</body>
</html>
<%



End Sub 'TicketOffer

'==============================

Sub ApplyAddOn
    SQLOrderLines = "SELECT LineNumber, SeatTypeCode FROM OrderLine (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber") & " ORDER BY LineNumber"
    Set rsOrderLines = OBJdbConnection.Execute(SQLOrderLines)
    Do While Not rsOrderLines.EOF
        If Request("SeatTypeCode" & rsOrderLines("LineNumber")) <> "0" Then 



            Select Case rsOrderLines("SeatTypeCode") 
            
                Case "1" 'Adult Ticket
                    If Request("SeatTypeCode" & rsOrderLines("LineNumber")) <> "12.95"  Then                    
                        If Request("SeatTypeCode" & rsOrderLines("LineNumber")) = 19.95 Then
                            NewTicketType = 8019  'Adult Ticket with $19.95 The Henry Strater Theatre Special                        
                        Else                         
                            NewTicketType = 4516 'Adult Ticket with $27.00 Mahogany Grille 
                        End If                            
                    Else
                        NewTicketType = 4696 'Adult Ticket with $12.95 Child Meal                                
                    End If 
                    
                Case "23" 'Senior Ticket
                    If Request("SeatTypeCode" & rsOrderLines("LineNumber")) <> "12.95"  Then                    
                        If Request("SeatTypeCode" & rsOrderLines("LineNumber")) = 19.95 Then
                            NewTicketType = 8022  'Senior Ticket $19.95 Henry Strater Theatre Special                        
                        Else                         
                            NewTicketType = 5263 'Senior Ticket with $27.00 Mahogany Grille 
                        End If                            
                    Else
                        NewTicketType = 5264 'Adult Ticket with $12.95 Child Meal                                
                    End If 
                    
                    
                Case "1575" 'Child Ticket
                    If Request("SeatTypeCode" & rsOrderLines("LineNumber")) = "12.95" Then
                        NewTicketType = 4357 'Child Ticket with $12.95 Dinner Menu
                    End If    
                          
                                                      
                Case "1119" 'Student Ticket
                   If Request("SeatTypeCode" & rsOrderLines("LineNumber")) <> "12.95"  Then                    
                        If Request("SeatTypeCode" & rsOrderLines("LineNumber")) = 19.95 Then
                            NewTicketType = 8024   'Student Ticket $19.95 Henry Strater Theatre Special                     
                        Else                         
                            NewTicketType = 4352 'Student Ticket with $27.00 Mahogany Grille  
                        End If                            
                   Else
                        NewTicketType = 4702 'Student Ticket with $12.95 Child Meal                                
                   End If
                   
                   
                Case "223" 'Military Ticket
                   If Request("SeatTypeCode" & rsOrderLines("LineNumber")) <> "12.95"  Then                    
                        If Request("SeatTypeCode" & rsOrderLines("LineNumber")) = 19.95 Then
                            NewTicketType = 8025   'Military $19.95 Henry Strater Theatre Special                        
                        Else                         
                            NewTicketType = 5266 'Military Ticket with $27.00 Mahogany Grille   
                        End If                            
                   Else
                        NewTicketType = 5267 'Military Ticket with $12.95 Child Meal                               
                   End If
                    
                                                        
                Case "157" 'Group Rate (10+)
                   If Request("SeatTypeCode" & rsOrderLines("LineNumber")) <> "12.95"  Then                    
                        If Request("SeatTypeCode" & rsOrderLines("LineNumber")) = 19.95 Then
                            NewTicketType = 8026    'Group(10+) $19.95 Henry Strater Theatre Special                       
                        Else                         
                            NewTicketType = 4700 'Group Rate (10+) with $27.00 Mahogany Grille    
                        End If                            
                   Else
                        NewTicketType = 4701 'Group Rate (10+) with $12.95 Child Meal                                
                   End If 
                   
                   
                Case "1742" 'Group Rate (30+)
                   If Request("SeatTypeCode" & rsOrderLines("LineNumber")) <> "12.95"  Then                    
                        If Request("SeatTypeCode" & rsOrderLines("LineNumber")) = 19.95 Then
                            NewTicketType = 8027    'Group(30+) $19.95 Henry Strater Theatre Special                    
                        Else                         
                            NewTicketType = 5269 'Group Rate (30+) with $27.00 Mahogany Grille    
                        End If                            
                   Else
                        NewTicketType = 5270 'Group Rate (30+) with $12.95 Child Meal                                 
                   End If 
				   
				Case "5644" 'Box Seat
                    If Request("SeatTypeCode" & rsOrderLines("LineNumber")) <> "12.95"  Then                    
                        If Request("SeatTypeCode" & rsOrderLines("LineNumber")) = 19.95 Then
                            NewTicketType = 8028  'Box Seat $19.95 Henry Strater Theatre Special                       
                        Else                         
                            NewTicketType = 8029 'Box Seat with $27.00 Mahogany Grille 
                        End If                            
                    Else
                        NewTicketType = 8030 'Box Seat with $12.95 Child Meal                                
                    End If  
                  
                                                          
                Case Else  
                    Call Continue
            End Select
            
            'Update OrderLine with new SeatTypeCode and new Price
            SQLUpdateSeatType = "UPDATE OrderLine WITH (ROWLOCK) SET SeatTypeCode = " & CleanNumeric(NewTicketType) & ", Price = Price + " & Clean(Request("SeatTypeCode" & rsOrderLines("LineNumber"))) & " WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLines("LineNumber")
	        Set rsUpdateSeatType = OBJdbConnection.Execute(SQLUpdateSeatType)
            
        End If
        rsOrderLines.Movenext
    Loop
    rsOrderLines.Close
    Set rsOrderLines = Nothing
    
    Call Continue
End Sub

'==============================

Sub Continue

If Session("UserNumber") = "" Then
	Session("SurveyComplete") = Session("OrderNumber") 
	Response.Redirect("/Ship.asp")
Else
	Session("SurveyComplete") = Session("OrderNumber")
	Response.Redirect("/Management/AdvanceShip.asp")
End If

End Sub 'Continue

'==============================


%>


