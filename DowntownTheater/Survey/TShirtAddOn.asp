<%

'CHANGE LOG - Inception
'SSR 3/17/2011
'Event Add On Survey. Parameters listed below 

%>

<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#include virtual="GlobalInclude.asp" -->
<!--#include virtual="dbOpenInclude.asp"-->

<%

'===============================================

Page = "Survey"
SurveyNumber = 850
SurveyName = "TshirtAddOn.asp"

'===============================================

'University of Alabama - Student Affairs

'T-Shirt Add On Survey

'If patron selects a ticket from this list of valid ticket types:

'SeatCode   SeatName
'1          Adult
'417        Child

'Child Tickets:
'The  survey page will display the T-Shirt options:
'Small, Medium, Large, XLarge, XXLarge

'Parent Tickets:
'The survey will ask if they wish to add a t-shirt.
'If yes, display the options and add $15.00 to the ticket

'If patron selects t-shirt option, the order will be updated
'the price and ticket type will be changed to match meal selection:

'SeatCode   Option Name
'6396	Student Ticket with Small T-Shirt
'6397	Student Ticket with Medium T-Shirt
'6398	Student Ticket with Large T-Shirt
'6399	Student Ticket with XLarge T-Shirt
'6405	Student Ticket with XXLarge T-Shirt

'6400	Parent Ticket with Small T-Shirt
'6401	Parent Ticket with Medium T-Shirt
'6402	Parent Ticket with Large T-Shirt
'6403	Parent Ticket with XLarge T-Shirt
'6406	Parent Ticket with XXLarge T-Shirt


'===============================================

'Survey Variables

SeatTypeList = "1,417" 

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

<script language="javascript" type="application/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script>

<script>
$(document).ready(function(){
  $("input[name$='type']").click(function(){
  var value = $(this).val();
  if(value=='Yes') {
    $("#Yes_box").slideDown();
     $("#No_box").slideUp();
  }
  else if(value=='No') {
   $("#No_box").slideDown();
    $("#Yes_box").slideUp();
   }
  });
  $("#No_box").show();
  $("#Yes_box").hide();
});
</script>

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

<script language="javascript" type="application/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script>

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

If Not rsDinnerOptions.EOF Then
    
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
        ATTENDEE <%= rsDinnerOptions("LineNumber") %> - <%= rsDinnerOptions("SeatType") %>
        </td>
    </tr>  
    
    <%
    
    Select Case rsDinnerOptions("SeatTypeCode") 

    Case "417" 'Student
    %>
    <tr>
        <td class="data-option" colspan="4">
        Please select your preferred T-Shirt size: <INPUT TYPE="radio" NAME="SeatTypeCode<%= rsDinnerOptions("LineNumber") %>" VALUE="Small">&nbsp;Small&nbsp;<INPUT TYPE="radio" NAME="SeatTypeCode<%= rsDinnerOptions("LineNumber") %>" VALUE="Medium">&nbsp;Medium&nbsp;<INPUT TYPE="radio" NAME="SeatTypeCode<%= rsDinnerOptions("LineNumber") %>" VALUE="Large">&nbsp;Large&nbsp;<INPUT TYPE="radio" NAME="SeatTypeCode<%= rsDinnerOptions("LineNumber") %>" VALUE="XLarge">&nbsp;XLarge&nbsp;<INPUT TYPE="radio" NAME="SeatTypeCode<%= rsDinnerOptions("LineNumber") %>" VALUE="XXLarge">&nbsp;XXLarge&nbsp;<INPUT TYPE="radio" NAME="SeatTypeCode<%= rsDinnerOptions("LineNumber") %>" VALUE="None" CHECKED>&nbsp;None&nbsp;<br />
        </td>
    </tr>
    <%
    Case "1" 'Adult     
    %>
    <tr>
        <td class="data-option" colspan="4">
        Would you like to add a T-Shirt to your order? ($15.00 Charge)<br />
        <label><input type="radio" name="type" value="Yes" id="type_0"  />Yes</label>
        <label><input type="radio" name="type" value="No" id="type_1" checked="checked"/>No</label>
        <div id="Yes_box">
        Please select your size: <INPUT TYPE="radio" NAME="SeatTypeCode<%= rsDinnerOptions("LineNumber") %>" VALUE="Small">&nbsp;Small&nbsp;<INPUT TYPE="radio" NAME="SeatTypeCode<%= rsDinnerOptions("LineNumber") %>" VALUE="Medium">&nbsp;Medium&nbsp;<INPUT TYPE="radio" NAME="SeatTypeCode<%= rsDinnerOptions("LineNumber") %>" VALUE="Large">&nbsp;Large&nbsp;<INPUT TYPE="radio" NAME="SeatTypeCode<%= rsDinnerOptions("LineNumber") %>" VALUE="XLarge">&nbsp;XLarge&nbsp;<INPUT TYPE="radio" NAME="SeatTypeCode<%= rsDinnerOptions("LineNumber") %>" VALUE="XXLarge">&nbsp;XXLarge&nbsp;<INPUT TYPE="radio" NAME="SeatTypeCode<%= rsDinnerOptions("LineNumber") %>" VALUE="None" CHECKED>&nbsp;None&nbsp;<br />
        </div>
        <div id="No_box">
        </div>
        </td>
    <%
    End Select     
    %>     
        
    </tr>
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
 
     
End If 
                   
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
    
        If Not rsOrderLines.EOF Then
        
        Do While Not rsOrderLines.EOF
        
        NewSeatType = Request("SeatTypeCode" & rsOrderLines("LineNumber"))
        
        ErrorLog("NewSeatType: " & NewSeatType & "")

            Select Case rsOrderLines("SeatTypeCode") 
            
                Case 417 'Student Ticket
                
                    Select Case NewSeatType                  
                       Case "Small" 
                            NewTicketType = 6396                    
                       Case "Medium" 
                            NewTicketType = 6397                       
                       Case "Large" 
                            NewTicketType = 6398                       
                       Case "XLarge" 
                            NewTicketType = 6399                       
                       Case "XXLarge"
                            NewTicketType = 6405 
                       Case Else
                            NewTicketType = 6            
                    End Select
                       
               Case 1 'Parent Ticket 
               
                    Select Case NewSeatType                  
                       Case "Small" 
                            NewTicketType = 6400                    
                       Case "Medium" 
                            NewTicketType = 6401                       
                       Case "Large" 
                            NewTicketType = 6402                       
                       Case "XLarge" 
                            NewTicketType = 6403                        
                       Case "XXLarge"
                            NewTicketType = 6406 
                       Case Else
                            NewTicketType = 660                  
                    End Select
                                
                Case Else 
                 
                    Call Continue
                   
            End Select
            
            'Update OrderLine with new SeatTypeCode and new Price
             SQLUpdateSeatType = "UPDATE OrderLine WITH (ROWLOCK) SET SeatTypeCode = " & CleanNumeric(NewTicketType) & " WHERE OrderNumber = " & Session("OrderNumber") & " AND LineNumber = " & rsOrderLines("LineNumber")& ""
	         Set rsUpdateSeatType = OBJdbConnection.Execute(SQLUpdateSeatType)
            
 
    rsOrderLines.Movenext
    Loop
    
    End If
    
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


