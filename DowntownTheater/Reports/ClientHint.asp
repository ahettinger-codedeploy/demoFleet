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

 <%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
 
<html>

<head>
 
 <title>Venue Inquiry</title>

<SCRIPT LANGUAGE="JavaScript">  

<!-- Hide code from non-js browsers

 var xmlHttp

function showHint(str)
{
if (str.length==0)
  { 
  document.getElementById("txtHint").innerHTML="";
  return;
  }
xmlHttp=GetXmlHttpObject()
if (xmlHttp==null)
  {
  alert ("Your browser does not support AJAX!");
  return;
  } 
var url="gethint.asp";
url=url+"?q="+str;
url=url+"&sid="+Math.random();
xmlHttp.onreadystatechange=stateChanged;
xmlHttp.open("GET",url,true);
xmlHttp.send(null);
} 

function stateChanged() 
{ 
if (xmlHttp.readyState==4)
{ 
document.getElementById("txtHint").innerHTML=xmlHttp.responseText;
}
}

function GetXmlHttpObject()
{
var xmlHttp=null;
try
  {
  // Firefox, Opera 8.0+, Safari
  xmlHttp=new XMLHttpRequest();
  }
catch (e)
  {
  // Internet Explorer
  try
    {
    xmlHttp=new ActiveXObject("Msxml2.XMLHTTP");
    }
  catch (e)
    {
    xmlHttp=new ActiveXObject("Microsoft.XMLHTTP");
    }
  }
return xmlHttp;
}
 
// end hiding -->
 </script> 

</head>

<body>

<!--#INCLUDE virtual="TopNavInclude.asp"-->

<form> 
Enter Word:
<input type="text" id="txt1" onkeyup="showHint(this.value)">
</form>

<p>Suggestions: <span id="txtHint"></span></p> 

</body>
</html>
 
 
<%

<!--#INCLUDE VIRTUAL="FooterInclude.asp" -->

</body>
</html>

End Sub

%>
