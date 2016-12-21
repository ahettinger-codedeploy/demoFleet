
<% 

'CHANGE LOG


%>

<!--#INCLUDE VIRTUAL="dbOpenInclude.asp"-->
<!--#INCLUDE VIRTUAL="GlobalInclude.asp"-->

<!--#INCLUDE VIRTUAL="clients\downtowntheater\renewal\include_functions.asp" -->
<!--#INCLUDE VIRTUAL="clients\downtowntheater\renewal\include_printLetters.asp" -->
<!--#INCLUDE VIRTUAL="clients\downtowntheater\renewal\include_emailLetters.asp" -->

<%

'-----------------------------------

strTitle = "Page Template"

ServerName = Request.ServerVariables ("SERVER_NAME") 

If ServerName <> "localhost" Then

	'REE 4/15/2 - Increased Session Timeout to 30 minutes to reduce Print validation timeout issues.
	Session.Timeout = 60
	Server.ScriptTimeout = 3600

	Page = "Management"

	'Verify OrganizationNumber
	If Session("OrganizationNumber") = "" Or IsNull(Session("OrganizationNumber")) Then 
		OBJdbConnection.Close
		Set OBJdbConnection = nothing
		Response.Redirect("/Management/Default.asp")
	End If


	'Verify User
	If Session("UserNumber") = "" Or IsNull(Session("UserNumber")) Then 
		OBJdbConnection.Close
		Set OBJdbConnection = nothing
		Response.Redirect("/Management/Default.asp")
	End If

	
End If

If ServerName = "localhost" Then

	Session("OrganizationNumber") = "2266"
	Session("UserNumber") = "1212"
	Session("OrgName") = "Downtown Theater"
	Session("CheckTixUser") = TRUE

End If

'-----------------------------------------------
 
'Decide which subroutine
 
Call AppSetings
Call ErrorCheck
Call CheckStatus

Select Case Request("FormName")
	Case "PrintLetters"
		Call PrintLetters
	Case "SendEmails"
		Call SendEmails
End Select

Call Display

'-----------------------------------------------

Sub Display

%>

<!DOCTYPE html>

	<html lang="en">
	
	<head>
 
	<title>TIX Support is <%=strTitle%></title>

<!-- Force IE to turn off past version compatibility mode and use current version mode -->
<meta http-equiv="X-UA-Compatible" content="IE=edge;chrome=1">

<!-- Get the width of the users display-->
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- Text encoded as UTF-8 -->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<link rel="stylesheet" type="text/css" href="https://fonts.googleapis.com/css?family=Roboto:400,100,300,500,700,900" >

<link rel="stylesheet" type="text/css" href="https://oss.maxcdn.com/icheck/1.0.2/skins/all.min.css" >

<!-- icons -->
<link rel="stylesheet" type="text/css" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css" >

<!-- theme -->
<link type="text/css" rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">

<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/bootstrap-table/1.7.0/bootstrap-table.min.css">

<link type="text/css" rel="stylesheet" href="css/basic.css">	

<link type="text/css" rel="stylesheet" href="css/panel.css">	

<link type="text/css" rel="stylesheet" href="css/table.css">

	</head>

		<body>
		
		<header>
			<!--#INCLUDE VIRTUAL="TopNavInclude.asp" -->
		</header>
 
			<section>
					<div class="panel panel-default">
					
						<DIV class="panel-heading">			   
							<DIV class="panel-title">
								<NAV class="navbar" role="navigation">
									<DIV class="navbar-header">
										<SPAN class="navbar-brand"><%=fnOrgName%></SPAN>
									</DIV>
									<DIV class="pull-left">
										<ul class="nav nav-tabs">
										<%
											response.write letterTab
											response.write emailTab
											response.write logTab
										%>
										</ul>
									</div>
									
									<DIV class="nav-btn pull-right">
									  <BUTTON class="btn btn-large btn-default" id="btn-options" type="button" data-placement="top" title="Options">
									  <span class="glyphicon glyphicon-cog"></span>
									  <SPAN class="icon-label">Options</SPAN>
									  </BUTTON>
									</DIV>
									
								</NAV>
							</DIV>
						</DIV>
						
						<!-- panel edit -->
	  
						<DIV class="panel-body" id="panel-options-outer">
							<DIV class="container-fluid effect1" id="panel-options-inner"> 
							 

												<ul class="nav nav-pills nav-stacked col-sm-3" style="margin-top: 15px;" style="outline:1px solid red; padding: 15px;">
													<li><a href="#tab1" data-toggle="tab">Option 1</a></li>
													<li><a href="#tab2" data-toggle="tab">Option 2</a></li>
													<li><a href="#tab3" data-toggle="tab">Option 3</a></li>
													<li class="active"><a href="#tab4" data-toggle="tab">Option 4</a></li>
												</ul>
												
												<div class="tab-content col-sm-9">
														
													<div class="tab-pane" id="tab1" style="border:1px solid rgb(222, 223, 225); border-radius:4px; padding: 5px; min-height: 250px;">
														<h3>Option 1</h3>	
													</div>

													<div class="tab-pane" id="tab2" style="border:1px solid rgb(222, 223, 225); border-radius:4px; padding: 5px; min-height: 250px;">
														<h3>Option 2</h3>	
													</div>
													
													<div class="tab-pane" id="tab3" style="border:1px solid rgb(222, 223, 225); border-radius:4px; padding: 5px; min-height: 250px;">
														<h3>Option 3</h3>
													</div>
													
													<div class="tab-pane active" id="tab4" style="border:1px solid rgb(222, 223, 225); border-radius:4px; padding: 5px; min-height: 250px;">
														<h3>Option 4</h3>
													</div>

												</div>
							 
							</DIV>
						</div>
 
						<div class="panel-body">
						
							<h3 class="page-header"> <%=strTitle%> </h3>
							
							<%
							
							If strError  <> "" Then
							
								Response.Write "" & strMessage  & "<BR>"
								
							Else
										
								Select Case strMode
									Case "letters"
										Call DisplayLetters
									Case "emails"
										Call DisplayEmails
									Case "loglist"
										Call DisplayLogList		
									Case "logs"
										Call DisplayLogDetail
									Case Else
										Call DisplayLetters
								End Select
								
							End If
						
							%>
						

						</div>
						
					</div>
			</section>
			
			<footer>
			<!--#INCLUDE VIRTUAL="FooterInclude.asp" -->
			<script type="text/javascript" language="javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
			<script type="text/javascript" language="javascript" src="http://cdn.jsdelivr.net/icheck/1.0.2/icheck.min.js"></script>	
			<script type="text/javascript" language="javascript" src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/js/bootstrap.min.js"></script>
			<script src="//cdnjs.cloudflare.com/ajax/libs/bootstrap-table/1.7.0/bootstrap-table.min.js"></script>
			<script src="//cdnjs.cloudflare.com/ajax/libs/bootstrap-table/1.7.0/locale/bootstrap-table-zh-CN.min.js"></script>


			<script type="text/javascript" language="javascript">

				function icheck() 
				{
				
					$("input[type=radio]").iCheck(
					{
						radioClass: 'iradio_square-grey',
						increaseArea: '30%'
					});
					
					// toggle active class whenever checkbox state changes
					$("input[type=radio]").on('ifToggled', function(event)
					{
						$(this).closest("tr").toggleClass("active")
					});
					
					$("input[type=checkbox]").iCheck(
					{
						checkboxClass: 'icheckbox_square-grey',
						increaseArea: '30%'
					});

					// make row active for pre-checked boxes
					$("input[type=checkbox]:checked").each(function() 
					{
						$(this).closest("tr").addClass("active");
					});

					// toggle active class whenever checkbox state changes
					$("input[type=checkbox]").on('ifToggled', function(event)
					{
						$(this).closest("tr").toggleClass("active")
					});
				 
				}
				
				icheck(); 

				function tableFade() 
				{				
					$(".table-fade")
					.delay(15)
					.animate({"opacity": "1"}, 800);
				}
				
				tableFade();

			</script>
			
<SCRIPT type="text/javascript" language="javascript">

jQuery.fn.blindToggle = function(speed, easing, callback) 
{
var h = (this.height() + parseInt(this.css('paddingTop')) + parseInt(this.css('paddingBottom')) + 9);
return this.animate({marginTop: parseInt(this.css('marginTop')) < 0 ? 0 : -h}, speed, easing, callback);  
};



jQuery.fn.slideFadeToggle = function(speed, easing, callback) 
{
return this.animate({opacity: 'toggle', height: 'toggle'}, speed, easing, callback);  
};



$(function() 
{
	$('#btn-options').click(function() 
	{
		$('#panel-options-inner').blindToggle(1000, 'easeInOutQuart');
	});    
});

</SCRIPT> 
				 

 																																																																																					   
			</footer>

	</body>
		
	</html>

<%

End Sub

%>
