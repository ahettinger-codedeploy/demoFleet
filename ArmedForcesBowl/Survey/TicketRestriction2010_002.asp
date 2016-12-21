<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->
<%

' SSR 8/31/2011 - Updated survey. Removed Event Add On.

' RAS 8.24.11 - Commented out errorlog messaging

'=========================================
'Armed Forces Bowl (11/9/2010)

'This survey limits the number of a specific seat type which can be purchased.

Page = "Survey"
SurveyNumber = 897
SurveyFileName = "TicketRestriction2010.asp"

RestrictedTicket = "1458" 'Veteran
RestrictedTicketName = "Veteran"
MaxTicketCount = 4

'=========================================

'Check to see if Order Number exists.
'Display management tabs for box office orders

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

'=========================================

'Bypass restriction for box office users. 
'If Session("OrderTypeNumber") <> 1 Then
'	Call Continue
'Else
'    Call TicketCheck
'End If


If Session("UserNumber")<> "" Then
TableFontFace = "Arial"
TableCategoryBGColor = "#008400"
TableCategoryFontColor = "FFFFFF"
TableColumnHeadingBGColor = "99CC99"
TableColumnHeadingFontColor = "000000"
TableDataBGColor = "E9E9E9"
End If

Call TicketCheck

'=========================================

Sub TicketCheck

SQLTicketCount = "SELECT COUNT(ItemNumber) AS TicketCount FROM OrderLine (NOLOCK) WHERE OrderNumber = " & Session("OrderNumber")& " AND OrderLine.SeatTypeCode IN (" & RestrictedTicket & ")"
Set rsTicketCount = OBJdbConnection.Execute(SQLTicketCount)
TicketCount = rsTicketCount("TicketCount")
rsTicketCount.Close
Set rsTicketCount = nothing

If TicketCount > MaxTicketCount Then
    Call WarningPage(TicketCount)
Else
    Call Continue
End If

End Sub 'TicketCheck

'=========================================

Sub WarningPage(TicketCount)

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
 
</head>

<%=strBody %>

<!--#INCLUDE virtual="TopNavInclude.asp"-->
<! -- Table Begin -- >
<table id="tix-table" summary="surveypage" width="500" cellspacing="10" cellpadding="15">
<! -- Table Body -- >
        <tbody>
           <tr bgcolor="<%=TableCategoryBGColor%>">
	            <td align="left"><FONT FACE="<%=FontFace%>" COLOR="<%=TableCategoryFontColor%>" SIZE="4"><B>SORRY</B></FONT></td>
           </tr>
           <tr align="left" bgcolor="<%=TableDataBGColor%>">
	            <td>
	            <FONT FACE="<%= FontFace %>" COLOR="<%= FontColor %>" SIZE="2">
	            No more than <%= MaxTicketCount %>&nbsp;<%= RestrictedTicketName %> tickets may be purchased.<br /><br />
	            You currently have <%= TicketCount %> tickets in your order.<br /><br />
	            Please click on the <i>Back to Shopping</i> button below and reduce the number of <%= RestrictedTicketName %> tickets in your order.
	            </FONT>	            
	            </td>
           </tr>
       </tbody>
 </table>
<br />
<br />
<% 
If Session("UserNumber") = "" Then
%>
<FORM ACTION="/ShoppingCart.asp" METHOD="POST" id=form1 name=form1>
<%
Else
%>
<FORM ACTION="/Management/ShoppingCart.asp" METHOD="POST" id=form1 name=form1>
<%
End If
%>

<INPUT TYPE="submit" VALUE="Back To Shopping" id=1 name=1></FORM>
<br />
<br />
<!--#INCLUDE virtual="FooterInclude.asp"-->

</BODY>
</HTML>

<%

End Sub 'Warning Page

'=========================================

Sub Continue

    Session("SurveyComplete") = Session("OrderNumber")
    If Session("UserNumber") = "" Then
	    Response.Redirect("/Ship.asp")
    Else
	    Response.Redirect("/Management/AdvanceShip.asp")
    End If
        
End Sub 'Continue

'=========================================

%>
