<!--#include virtual="GlobalInclude.asp"-->
<!--#include virtual="dbOpenInclude.asp"-->
<%

Page = "ManagementReport"
ReportFileName = "ByerschoolSurveyReport.asp"
ReportTitle = "Byerschool Survey Report"

'REE 4/12/6 - Added Script Timeout
Server.ScriptTimeout = 1200

If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then Response.Redirect("/Management/Default.asp")

If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then Response.Redirect("/Management/Default.asp")


'===============================================

'CSS Survey Variables

If Session("UserNumber")<> "" Then
    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "FFFFFF"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "000000"
    TableDataBGColor = "E9E9E9"
    'LastHex = box color
    'FirstHex = background color
    NECorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=008400&Src=TopLeftCorner16.txt"
    NWCorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=008400&Src=TopRightCorner16.txt"
    SWCorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=E9E9E9&Src=BottomLeftCorner16.txt"
    SECorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=E9E9E9&Src=BottomRightCorner16.txt"
Else
    'LastHex = box color
    'FirstHex = background color
    NECorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=565f68&Src=TopLeftCorner16.txt"
    NWCorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=565f68&Src=TopRightCorner16.txt"
    SWCorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=ded6c8&Src=BottomLeftCorner16.txt"
    SECorner="/clients/tix/images/image.asp?FirstHex=ffffff&LastHex=ded6c8&Src=BottomRightCorner16.txt"
End If

'============================================================

'Survey Start. Request Form name and process requested action

If Clean(Request("FormName")) = "DisplayReport" Then
	Call DisplayReport(SurveyNumber)

ElseIf Clean(Request("FormName")) = "Continue" Then
    Call Continue

Else
    Call ReportCriteria
End If


'===============================================

Sub ReportCriteria

SQLOrganization = "SELECT Organization FROM Organization (NOLOCK) WHERE OrganizationNumber = " & Session("OrganizationNumber")
Set rsOrganization = OBJdbConnection.Execute(SQLOrganization)

%>

<HTML>
<HEAD>
<TITLE>Tix - Custom Survey Report</TITLE>

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
	width: 500px;
	text-align: left;
	border-collapse: collapse;
}
#rounded-corner thead th.category
{
	padding-top: 5px;
    padding-bottom: 5px;
    padding-left: 0px;
    padding-right: 0px;
	font-size: 14px;
	font-weight: 450;
	text-align: left;
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
	padding-left: 0px;
	padding-right: 0px;
	padding-top: 5px;
	padding-bottom: 5px;
	font-size: 10px;
	font-weight: 400;
	text-align: center;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-left
{
	padding-left: 0px;
	padding-right: 0px;
	padding-top: 0px;
	padding-bottom: 0px;
	text-align: left;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-right
{
	padding-left: 0px;
	padding-right: 0px;
	padding-top: 0px;
	padding-bottom: 0px;
    text-align: right;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
</style>

</HEAD>
<BODY BGCOLOR="#FFFFFF">
<CENTER>

<%
If Excel <> "Y" Then
%>
	<!--#include virtual="TopNavInclude.asp" -->
<%
End If
%>

<BR>
<BR>
<FONT FACE=verdana,arial,helvetica COLOR=#008400 SIZE=2><B><%= rsOrganization("Organization") %></B></FONT><BR>
<FONT FACE=verdana,arial,helvetica COLOR=#008400 SIZE=2><B>Custom Survey Report</B></FONT><br /><br />
<FONT FACE=verdana,arial,helvetica SIZE=2>

<form action="<%= ReportFileName  %>" name="Survey" method="post">
<input type="hidden" name="FormName" value="DisplayReport">


 <table id="rounded-corner" summary="surveypage" border="0">
    <thead>
	    <tr>
    	    <th scope="col" width="%5" class="category-left">&nbsp;</th>
    	    <th scope="col" width="%5" class="category">&nbsp;</th>
    	    <th scope="col" width="%40" class="category">Survey Number</th>
    	    <th scope="col" width="%40" class="category">Survey Name</th>
    	    <th scope="col" width="%5" class="category-right">&nbsp;</th>
        </tr>        
   </thead>
        <tbody>       
        
<%

SQLSurveyList = "SELECT SurveyNumber, SurveyFileName, OrganizationNumber, SurveyTitle, SurveyDescription FROM Survey (NOLOCK) WHERE OrganizationNumber =  " & Session("OrganizationNumber")& " AND  SurveyFileName <> '/GenericSurvey.asp' "
Set rsSurveyList = OBJdbConnection.Execute(SQLSurveyList)

        If Not rsSurveyList.EOF Then
            Do While Not rsSurveyList.EOF
%> 

        <tr>
            <td class="data-left">&nbsp;</td>
            <td class="data" align="center"><INPUT TYPE="radio" NAME="SurveyNumber" VALUE="<%=rsSurveyList("SurveyNumber")%>"></td>
            <td class="data-left"><%=rsSurveyList("SurveyNumber")%></td>
            <td class="data-left"><%=rsSurveyList("SurveyTitle")%></td>
            <td class="data-right">&nbsp;</td>
        </tr>
<%

            rsSurveyList.MoveNext
            Loop
        End If
        
rsSurveyList.Close
Set rsSurveyList = Nothing 

%>        

        <tr>
    	    <td class="footer-left">&nbsp;</td>
    	    <td class="footer">&nbsp;</td>
    	    <td class="footer">&nbsp;</td>
    	    <td class="footer">&nbsp;</td>
    	    <td class="footer-right">&nbsp;</td>
    	</tr>
        </tbody>
 </table>

<br />
<br />	
<INPUT TYPE="checkbox" NAME="ExcelOutput" VALUE="Y">&nbsp;&nbsp;<FONT FACE=verdana,arial,helvetica SIZE=2>Output To Excel</FONT>
<br />
<br />
<INPUT type="submit" value="Submit" /></form>


<!--#include virtual="FooterInclude.asp"-->


</body>

</html>

<%

End Sub

'===========================

Sub DisplayReport(SurveyNumber)


%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>

<TITLE>Tix - Custom Survey Report</TITLE>

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
	width: 600px;
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
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-left
{
	padding-left: 10px;
	padding-right: 10px;
	padding-top: 10px;
	padding-bottom: 10px;
	text-align: left;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-right
{
	padding-left: 10px;
	padding-right: 10px;
	padding-top: 10px;
	padding-bottom: 10px;
    text-align: right;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
</style>
 
</HEAD>

<BODY BGCOLOR="#FFFFFF">

<!--#include virtual="TopNavInclude.asp" -->

<%

SQLOrganization = "SELECT Organization FROM Organization (NOLOCK) WHERE OrganizationNumber = " & Session("OrganizationNumber")
Set rsOrganization = OBJdbConnection.Execute(SQLOrganization)

SurveyNumber = 1089

%>

<FONT FACE=verdana,arial,helvetica COLOR=#008400 SIZE=2><B><%= rsOrganization("Organization") %></B></FONT><BR>
<FONT FACE=verdana,arial,helvetica COLOR=#008400 SIZE=2><B>Custom Survey Report</B></FONT><br /><br />

<%


If Session("OrganizationNumber") = 1 Then 'It's Tix.  Show all Organizations.
	SQLSurveyAnswers = "SELECT DISTINCT SurveyAnswers.OrderNumber, OrderDate, Customer.CustomerNumber, Customer.FirstName, Customer.LastName, SurveyAnswers.Question, SurveyAnswers.Answer FROM SurveyAnswers (NOLOCK) INNER JOIN Customer (NOLOCK) ON SurveyAnswers.CustomerNumber = Customer.CustomerNumber INNER JOIN Survey (NOLOCK) ON SurveyAnswers.SurveyNumber = Survey.SurveyNumber INNER JOIN OrderHeader (NOLOCK) ON SurveyAnswers.OrderNumber = OrderHeader.OrderNumber WHERE SurveyAnswers.SurveyNumber = " & SurveyNumber & " AND OrderHeader.StatusCode = 'S' ORDER BY SurveyAnswers.OrderNumber"
Else
	SQLSurveyAnswers = "SELECT DISTINCT SurveyAnswers.OrderNumber, OrderDate, Customer.CustomerNumber, Customer.FirstName, Customer.LastName FROM SurveyAnswers (NOLOCK) INNER JOIN Customer (NOLOCK) ON SurveyAnswers.CustomerNumber = Customer.CustomerNumber INNER JOIN OrderHeader (NOLOCK) ON SurveyAnswers.OrderNumber = OrderHeader.OrderNumber INNER JOIN OrderLine (Nolock) ON OrderHeader.OrderNumber = OrderLine.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " WHERE SurveyAnswers.SurveyNumber = " & SurveyNumber & " AND OrderHeader.StatusCode = 'S' ORDER BY SurveyAnswers.OrderNumber"
End If
	
	Set rsSurveyAnswers = OBJdbConnection.Execute(SQLSurveyAnswers)
	
	If Not rsSurveyAnswers.EOF Then
		
	    Call DBOpen(OBJdbConnection2)
	    
		'get the maximum number of questions on all surveys belong to this Organization
		SQLMaxQues = "SELECT MAX(AnswerNumber) AS MaxQues FROM SurveyAnswers (NOLOCK) WHERE SurveyNumber = 1089 GROUP BY SurveyNumber ORDER BY MaxQues DESC"
		SQLMaxQues = "SELECT MAX(AnswerNumber) AS MaxQues FROM SurveyAnswers (NOLOCK) INNER JOIN OrderHeader (NOLOCK) ON SurveyAnswers.OrderNumber = OrderHeader.OrderNumber INNER JOIN OrderLine (Nolock) ON OrderHeader.OrderNumber = OrderLine.OrderNumber INNER JOIN Seat (NOLOCK) ON OrderLine.ItemNumber = Seat.ItemNumber INNER JOIN Event (NOLOCK) ON Seat.EventCode = Event.EventCode INNER JOIN OrganizationVenue (NOLOCK) ON Event.VenueCode = OrganizationVenue.VenueCode AND OrganizationVenue.OrganizationNumber = " & Session("OrganizationNumber") & " INNER JOIN OrganizationAct (NOLOCK) ON Event.ActCode = OrganizationAct.ActCode AND OrganizationAct.OrganizationNumber = " & Session("OrganizationNumber") & " WHERE SurveyAnswers.SurveyNumber = 1089 AND OrderHeader.StatusCode = 'S'"
		Set rsMaxQues = OBJdbConnection2.Execute(SQLMaxQues)
		MaxQuestions = rsMaxQues("MaxQues")
		rsMaxQues.Close
		Set rsMaxQues = Nothing
		
		Response.Write "<TABLE CELLPADDING=5>" & vbCrLf
		
		'write out the row heading
		Response.Write "<TR BGCOLOR=#008400><TD ALIGN=center nowrap><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><B>Order Number</B></FONT></TD><TD ALIGN=center nowrap><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><B>Order Date</B></FONT></TD><TD ALIGN=center nowrap><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><B>Customer Name</B></FONT></TD>"
                
        SQLSurveyQues = "SELECT QuestionNumber, QuestionText FROM  SurveyQuestion (NOLOCK) WHERE SurveyNumber = " & SurveyNumber & " ORDER BY QuestionNumber"
        Set rsSurveyQues = OBJdbConnection.Execute(SQLSurveyQues)
        
        If Not rsSurveyQues.EOF Then        
            Do While Not rsSurveyQues.EOF
            
                Response.Write "<TD ALIGN=center nowrap><FONT FACE='verdana,arial,helvetica' COLOR=#FFFFFF SIZE=2><B>" & rsSurveyQues("QuestionText") & "</B></FONT></TD>"
            
            rsSurveyQues.movenext   
            Loop
      
        End If
      
      rsSurveyQues.Close
      Set rsSurveyQues = Nothing 
      
      Response.Write "</TR>" & vbCrLf
        
        'use array to store answers
        Dim AnswerArray(16)		
		
		Do Until rsSurveyAnswers.EOF
		
		    'get answers and store them - use this looping approach or else we couldn't get multiple answers for each question
		    For i = 1 to MaxQuestions
		        SQLSurveyInfo = "SELECT isnull(Answer,'') AS Answer FROM SurveyAnswers (NOLOCK) WHERE AnswerNumber = " & i & " AND OrderNumber = " & rsSurveyAnswers("OrderNumber")
		        Set rsSurveyInfo = OBJdbConnection2.Execute(SQLSurveyInfo)
		        If Not rsSurveyInfo.EOF Then
		            Do While Not rsSurveyInfo.EOF
	'	                AnswerArray(i) = rsSurveyInfo("Answer")
'		                If Not rsSurveyInfo.EOF Then 'if more answers, put in next line
		                    AnswerArray(i) = AnswerArray(i) & "<BR>" & rsSurveyInfo("Answer")
'		                End If
		                rsSurveyInfo.movenext
		            Loop
		        Else 'no answer found
		            AnswerArray(i) = ""
		        End If
		        rsSurveyInfo.Close
		        Set rsSurveyInfo = Nothing    
		    Next

			'REE 3/16/7 - Added Output to Excel option
			If Excel <> "Y" Then
				Response.Write "<TR BGCOLOR=#DDDDDD ALIGN=""center"" VALIGN=""middle""><TD><FONT FACE='verdana,arial,helvetica' SIZE=2><A HREF=""/Reports/OrderDetails.asp?OrderNumber=" & rsSurveyAnswers("OrderNumber") & """>" & rsSurveyAnswers("OrderNumber") & "</A></FONT></TD><TD ALIGN=""center""><FONT FACE='verdana,arial,helvetica' SIZE=2>" & FormatDateTime(rsSurveyAnswers("OrderDate"),vbShortDate) & "</FONT></TD><TD ALIGN=""left"" NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2><A HREF=""/Reports/CustomerDetails.asp?CustomerNumber=" & rsSurveyAnswers("CustomerNumber") & """>" & rsSurveyAnswers("FirstName") & " " & rsSurveyAnswers("LastName") & "</A></FONT></TD>"
			Else
				Response.Write "<TR BGCOLOR=#DDDDDD ALIGN=""center"" VALIGN=""middle""><TD><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsSurveyAnswers("OrderNumber") & "</FONT></TD><TD ALIGN=""center""><FONT FACE='verdana,arial,helvetica' SIZE=2>" & rsSurveyAnswers("OrderDate") & "</FONT></TD><TD ALIGN=""left"" NOWRAP><FONT FACE=verdana,arial,helvetica SIZE=2>" & rsSurveyAnswers("FirstName") & " " & rsSurveyAnswers("LastName") & "</FONT></TD>"
			End If
			
			'display answers in array
			
			AnswerList = Split(ProductionFreeList,",")
			For i = 1 to MaxQuestions
			    Response.Write "<TD><FONT FACE='verdana,arial,helvetica' SIZE=2>" & AnswerArray(i) & "</FONT></TD>"
			Next
			
			Response.Write "</TR>" & vbCrLf
			
			'clear array after displaying answers for each order
			Erase AnswerArray
			
			'REE 2/23/9 - Added Response Flush to prevent Response Buffer overflow.
            RecordCount = RecordCount + 1
		    PageBuffer = PageBuffer + 1
    		
		    If PageBuffer >=100 Then	
			    Response.Flush
			    PageBuffer = 0
		    End If
    		
		    rsSurveyAnswers.MoveNext
			
		Loop

		Response.Write "</TABLE>" & vbCrLf
		
		Call DBClose(OBJdbConnection2)
	Else
		Response.Write "There are no survey responses for this date range."
	End If	
	
	rsSurveyAnswers.Close
	Set rsSurveyAnswers = nothing
							

%>


<!--#include virtual="FooterInclude.asp"-->


</body>

</html>

<%
End Sub
'===========================
%>
