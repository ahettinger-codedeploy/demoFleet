

<%



%>

<!DOCTYPE html>

<html lang="en">

<head>

<meta http-equiv="X-UA-Compatible" content="IE=edge">

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<link rel="shortcut icon" type="image/ico" href="/images/favicon.ico">

<title><%=PageTitle%></title>

<!-- Le styles -->

<link href="http://twitter.github.com/bootstrap/assets/css/bootstrap-responsive.css" rel="stylesheet">

<link href="http://twitter.github.com/bootstrap/assets/css/bootstrap.css" rel="stylesheet">

<link href="http://www.testtix.com//Utilities/Support/lib/bootstrap/2.1.1/css/bootstrap-tix-fix.css" rel="stylesheet">

<style>
.nav-list {font-size: 14px;}
.breadcrumb a:link {color:#1AAEFF;}      /* unvisited link */
.breadcrumb a:visited {color:#1AAEFF;}  /* visited link */
.breadcrumb a:hover {color:#FF00FF;}  /* mouse over link */
.breadcrumb a:active {color:#1AAEFF;}  /* selected link */ 
.page-header { border-bottom: 1px solid #333333; margin: 20px 0 30px; padding-bottom: 9px; }
.page-header { color: #3A87AD; }
.page-header  {border: 1px solid #BCE8F1 ; border-radius: 4px 4px 4px 4px;  margin-bottom: 10px; padding: 0px 0px 0px 14px;  text-shadow: 0 1px 0 rgba(255, 255, 255, 0.5); }
</style>

<!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
<!--[if lt IE 9]>
<script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
<![endif]-->

</head>

<body BGCOLOR="#FFFFFF">


<div class="container">

<%


   ' declare variables
   Dim objFSO, objFolder
   Dim objCollection, objItem

   Dim strPhysicalPath, strTitle, strServerName
   Dim strPath, strTemp
   Dim strName, strFile, strExt, strAttr
   Dim intSizeB, intSizeK, intAttr, dtmDate

   ' declare constants
   Const vbReadOnly = 1
   Const vbHidden = 2
   Const vbSystem = 4
   Const vbVolume = 8
   Const vbDirectory = 16
   Const vbArchive = 32
   Const vbAlias = 64
   Const vbCompressed = 128

   ' don't cache the page
   Response.AddHeader "Pragma", "No-Cache"
   Response.CacheControl = "Private"

   ' get the current folder URL path
   strTemp = Mid(Request.ServerVariables("URL"),2)
   strPath = ""

   Do While Instr(strTemp,"/")
      strPath = strPath & Left(strTemp,Instr(strTemp,"/"))
      strTemp = Mid(strTemp,Instr(strTemp,"/")+1)      
   Loop

   strPath = "/" & strPath

   ' build the page title
   strServerName = LCase(Request.ServerVariables("SERVER_NAME"))
   strTitle = ""& strPath &""

   ' create the file system objects
   strPhysicalPath = Server.MapPath(strPath)
   Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
   Set objFolder = objFSO.GetFolder(strPhysicalPath)
   
   
%>

	<ul class="breadcrumb">
		<li> 
<% 

		set FileSysObj = CreateObject("Scripting.FileSystemObject")

		FileAndPath = Request.Servervariables("SCRIPT_NAME")

		Dim oKeyWord, oKeyWordText
		Dim myString  

		myString = FileAndPath

		Dim myArray  
		myArray = Split(myString,"/")  
		
		response.write "<a href=""" & strServerName & """ style=""text-decoration:none"">" & strServerName & "</a>"

		For m = 1 To UBound(myArray) 
			
		response.write " > <a href=""" & LCase(myArray(m)) & """ style=""text-decoration:none"">" & LCase(myArray(m)) & "</a>"
			
		Next  
		
		PageTitle = UCase(myArray(UBound(myArray)-1)) 

%>
		</li>
	</ul>

	<div class='alert alert-info fade in' data-alert='alert'>
	  <h2>
		<%=PageTitle%>
	  </h2>
	</div>

	<div class="page-header">
	<h3>Directory Listing</h3>
	</div>

	
	<div class="row-fluid">


<table class="table table-striped table-condensed table-hover table-bordered" id="example">
<tr>
   <th align="left">Name</th>
   <th align="left">Type</th>
   <th align="left">Date</th>
   <th align="left">Time</th>
</tr>

<%
   ''''''''''''''''''''''''''''''''''''''''
   ' output the folder list
   ''''''''''''''''''''''''''''''''''''''''

   Set objCollection = objFolder.SubFolders

   For Each objItem in objCollection
      strName = objItem.Name
      strAttr = MakeAttr(objItem.Attributes)      
      dtmDate = CDate(objItem.DateLastModified)
%>

<tr>
   <td align="left"><b><a href="<%=strName%>"><%=strName%></a></b></td>
   <td align="left">Directory</td>
   <td align="left"><%=FormatDateTime(dtmDate,vbShortDate)%></td>
   <td align="left"><%=FormatDateTime(dtmDate,vbLongTime)%></td>
</tr>

<% Next %>

</table>
</center>
</div>


<div class="page-header">
<h3>File Listing</h3>
</div>

<div class="row-fluid">

	<table class="table table-striped table-condensed table-hover table-bordered" id="example">
	<tr>   
	<th align="left">Name </th>	
	<th align="left">Bytes</th> 	
	<th align="left">KB </th>	
	<th align="left">Attributes </th>	
	<th align="left">Ext </th>	
	<th align="left">Type </th>	
	<th align="left">Date </th>	
	<th align="left">Time</th>
	</tr>

	<%
	   ''''''''''''''''''''''''''''''''''''''''
	   ' output the file list
	   ''''''''''''''''''''''''''''''''''''''''

	   Set objCollection = objFolder.Files

	   For Each objItem in objCollection
	   
		  strName = objItem.Name
		  strFile = Server.HTMLEncode(Lcase(strName))

		  intSizeB = objItem.Size
		  intSizeK = Int((intSizeB/1024) + .5)
		  If intSizeK = 0 Then intSizeK = 1

		  strAttr = MakeAttr(objItem.Attributes)
		  strName = Ucase(objItem.ShortName)
		  If Instr(strName,".") Then strExt = Right(strName,Len(strName)-Instr(strName,".")) Else strExt = ""
		  dtmDate = CDate(objItem.DateLastModified)
		  
		  If Left(strFile, 5) <> "index" then
	%>
		<tr>
		   <td align="left"><a href="<%=strFile%>"><%=strFile%></a></td>
		   <td align="right"><%=FormatNumber(intSizeB,0)%></td>
		   <td align="right"><%=intSizeK%>K</td>
		   <td align="left"><tt><%=strAttr%></tt></td>
		   <td align="left"><%=strExt%></td>
		   <td align="left"><%=objItem.Type%></td>
		   <td align="left"><%=FormatDateTime(dtmDate,vbShortDate)%></td>
		   <td align="left"><%=FormatDateTime(dtmDate,vbLongTime)%></td>
		</tr>
		
	<% 

		End If

		Next 

	%>

	</table>

</div>

<!-- Placed at the end of the document so the pages load faster -->

<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js"></script>

</body>

</html>

<%
   Set objFSO = Nothing
   Set objFolder = Nothing

   ' this adds the IIf() function to VBScript
   Function IIf(i,j,k)
      If i Then IIf = j Else IIf = k
   End Function

   ' this function creates a string from the file atttributes
   Function MakeAttr(intAttr)
      MakeAttr = MakeAttr & IIf(intAttr And vbArchive,"A","-")
      MakeAttr = MakeAttr & IIf(intAttr And vbSystem,"S","-")
      MakeAttr = MakeAttr & IIf(intAttr And vbHidden,"H","-")
      MakeAttr = MakeAttr & IIf(intAttr And vbReadOnly,"R","-")
   End Function
%>
