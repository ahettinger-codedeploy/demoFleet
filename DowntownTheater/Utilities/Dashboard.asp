<%
'CHANGE LOG
'SSR 3/22/2011
'changed the style sheet to rounded corners
'changed from 4 submit buttons to just 1 submit button
'added look up by organization number

%>


<!--#INCLUDE virtual=PrivateLabelInclude.asp -->
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->

<%

'===============================================

Page = "Management"
SecurityFunction = "VenueInquiry"
ReportFileName = "VenueInquiry.asp"
ReportTitle = "Venue Inquiry"

'===============================================

Server.ScriptTimeout = 1200

If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then Response.Redirect("/Management/Default.asp")

If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then Response.Redirect("/Management/Default.asp")

If SecurityCheck(SecurityFunction) = False Then Response.Redirect("/Management/Default.asp")


'===============================================

'Report Variables

If Session("UserNumber")<> "" Then

    TableCategoryBGColor = "#008400"
    TableCategoryFontColor = "FFFFFF"
    TableColumnHeadingBGColor = "#99cc99"
    TableColumnHeadingFontColor = "000000"
    TableDataBGColor = "E9E9E9"
    ClientFolder= "Tix"
    
End If

'===============================================

Select Case Request("FormName")
Case "VenueName"
	Call SearchResults
Case Else
	Call Inquiry(Message)
End Select

'===============================================

Sub Inquiry(Message)

%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>

<title>Venue Inquiry</title>

<style type="text/css">
body
{
line-height: 1 em;
}
#rounded-corner
{
	font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
	font-size: 12px;
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
#rounded-corner td
{
	padding-top: 20px;
	padding-bottom: 20px;
	padding-right: 20px;
	padding-left: 20px;
}
#rounded-corner td.category
{
	padding-top: 5px;
    padding-left: 15px;
	font-size: 20px;
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
	padding-top: 2px;
	padding-bottom: 2px;
	font-weight: normal;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.data-left
{
	padding-top: 2px;
	padding-bottom: 2px;
	text-align: left;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}		
#rounded-corner td.data-right
{	
	padding-top: 2px;
	padding-bottom: 2px;
	padding-right: 15px;
	text-align: right;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.column
{
	text-align: left;
	color: <%=TableColumnHeadingFontColor%>;
	background: <%=TableColumnHeadingBGColor%>;
	border-top: 1px solid;
	border-bottom: 2px solid;
	border-color: #ffffff;
}
</style>

</head>

<%=strBody %>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

 <FORM ACTION="VenueInquiry.asp" METHOD="post" NAME="SearchForm">
  
  <br />
  <br />
  <table id="rounded-corner">
    <thead>
	    <tr>
    	    <th scope="col" class="category-left"></th>
    	    <th scope="col" class="category">&nbsp;</th>
    	    <th scope="col" class="category-right"></th>
        </tr>        
   </thead>
        <tbody>
	    <tr>
    	    <td class="category" colspan="3">
    	        <b>Venue Inquiry</b>
    	    </td>
        </tr>
        <tr>
            <td class="data" colspan="3">
            &nbsp;
            </td>
        </tr>
        <tr>
            <td class="data-left">
               Search Term
            </td>
            <td class="data-left">
               Search Type
            </td>
            <td class="data-left">
            &nbsp;
            </td>
        </tr>
        <tr>
            <td class="data-left">
                <INPUT TYPE="text" NAME="SearchString" SIZE="25"  MAXLENGTH="30">
            </td>
            <td class="data-left">
                <select name="FormName">
	                <option value="VenueName">Venue Name</option>
                 </select>
            </td>
            <td class="data-left">
                <INPUT TYPE="submit" VALUE="Submit Search">
                </FORM>
            </td>
        </tr>
        <tr>
    	    <td class="footer-left">&nbsp;</td>
    	    <td class="footer">&nbsp;</td>
    	    <td class="footer-right">&nbsp;</td>
    	</tr>
        </tbody>
 </table>

<%

End Sub

'===============================

Sub SearchResults

OBJdbConnection.CommandTimeout = 180 '3 Minutes

Response.Write "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"

Select Case Request("FormName")

Case "VenueName"
	QuerySearchString = "Venue.Venue LIKE '%" & Clean(Request("SearchString")) & "%'"
	OrderByString = "Venue.Venue"
End Select

Response.Write "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"



%>

<!--#INCLUDE VIRTUAL="PageTopInclude.asp" -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>

<title>Client Inquiry</title>

<style type="text/css">
body
{
line-height: 1 em;
}
#rounded-corner
{
	font-family: "Lucida Sans Unicode", "Lucida Grande", Sans-Serif;
	font-size: 12px;
	width: 600px;
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
#rounded-corner td
{
	padding-top: 2px;
	padding-bottom: 2px;
	padding-right: 2px;
	padding-left: 2px;
}
#rounded-corner td.category
{
	padding-top: 5px;
	padding-bottom: 10px;
    padding-left: 15px;
	font-size: 20px;
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
	padding-top: 2px;
	padding-bottom: 2px;
	padding-right: 2px;
	font-size: 10px;
	font-weight: strong;
	color: <%=TableDataFontColor%>;
	white-space: nowrap;
}
#rounded-corner td.data-left
{
	padding-top: 4px;
	padding-bottom: 4px;
	padding-right: 4px;
	font-size: 10px;
	text-align: left;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}		
#rounded-corner td.data-right
{	
	padding-top: 4px;
	padding-bottom: 4px;
	padding-right: 4px;
	font-size: 10px;
	text-align: right;
	color: <%=TableDataFontColor%>;
	background: <%=TableDataBGColor%>;
}
#rounded-corner td.column
{
	padding-top: 10px;
	padding-bottom: 10px;
	padding-left: 10px;
	font-size: 12px;
	text-align: left;
	color: <%=TableColumnHeadingFontColor%>;
	background: <%=TableColumnHeadingBGColor%>;
}
</style>

</head>

<%=strBody %>

<!--#INCLUDE virtual="TopNavInclude.asp" -->
 
 <%  
 
SQLVenue = "SELECT DISTINCT  Venue FROM  Venue WHERE " & QuerySearchString & " ORDER BY " & OrderByString & " "
Set rsVenue = OBJdbConnection.Execute(SQLVenue)

If Not rsVenue.EOF Then 
  
%>       
        <br />
        <br />
        <table id="rounded-corner">
        <thead>
            <tr>
	            <th scope="col" colspan="2" class="category-left"></th>
	            <th scope="col"  class="category">&nbsp;</th>
	            <th scope="col" colspan="2" class="category-right"></th>
            </tr>        
        </thead>
        <tbody>
            <tr>
	            <td class="category" colspan="5">
	                <b>Venue Inquiry</b>
	            </td>
            </tr>
            <tr>
                <td class="column" colspan=5>Matches for . . . "<%=Clean(Request("SearchString"))%>"</td>
            </td>
            </tr>
            <tr class="data">
                <td class="data">&nbsp;</font></TD>
                <td class="data"><b>Venue Name</TD>
<%
                'Match Found!
                '==================  
                 
                'Alternating row colors   
                'Set row counter to 0
                i = 0    
                
                Do Until rsVenue.EOF
                
                 i = i + 1
                 
                'Set even row background color to light gray
                vBGColor = "#e9e9e9"
                
                'Set odd row backbround color to dark gray
                If i mod 2 = 1 then vBGColor =  "#c9c9c9"
        	    
	            %>
	            <tr bgcolor=<%=vBGColor%>>
	            <%
	    
	            'DISPLAY REPORT RESULTS        
                 
                'Venue Name
                '-------------
                %>
                <td class="data"><%=rsVenue("VenueName")%></td>
                </tr>         	
	            <%
    		
rsVenue.MoveNext 
Loop	    	
    	
    %>  
    <tr>
	    <td colspan="2" class="footer-left">&nbsp;</td>
	    <td colspan="2" class="footer">&nbsp;</td>
	    <td colspan="2" class="footer-right">&nbsp;</td>
	</tr>
    </tbody>
 </table>
 
<%

Else 
        'No Match Found!
        '==================  
%>   
        <br />
        <br />
        <table id="rounded-corner">
        <thead>
            <tr>
	            <th scope="col" colspan="2" class="category-left"></th>
	            <th scope="col" colspan="2" class="category">&nbsp;</th>
	            <th scope="col" colspan="2" class="category-right"></th>
            </tr>        
        </thead>
            <tbody>
            <tr>
	            <td class="category" colspan="6">
	                <b>Venue Inquiry</b>
	            </td>
            </tr>
            <tr>
                <td class="column" colspan=6>Matches for . . . "<%=Clean(Request("SearchString"))%>"</td>
            </td>
            </tr>
            <tr>
                <td class="data"><font color="white">_</font></TD>
                <td><b>Venue Name</b></TD>
            </tr>
            <tr bgcolor="#e9e9e9">
                <td colspan=6>Sorry! No match found.</td>
            </tr>
            <tr>
	            <td colspan="2" class="footer-left">&nbsp;</td>
	            <td colspan="2" class="footer">&nbsp;</td>
	            <td colspan="2" class="footer-right">&nbsp;</td>
	        </tr>
	        <tr>
                <td colspan=6>&nbsp;</td>
            </tr> 
            <tr>
                <td colspan=6 align="center" valign="top">
                <br />
                <FORM ACTION="VenueInquiry.asp" METHOD="post" NAME="NewSearch">
                <INPUT TYPE="submit" STYLE="width: 10em" VALUE="Perform New Search">
                </FORM>
                </td>
            </tr>
            </table>
<%
End If

rsVenue.Close
Set rsVenue = nothing

End Sub

%>