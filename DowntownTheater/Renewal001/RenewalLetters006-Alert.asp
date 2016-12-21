
<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->

<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->

<%

'-----------------------------------------------

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



Session("Timeout") = 120
Server.ScriptTimeout = 60 * 20 '20 Minutes

'-----------------------------------------------




'-----------------------------------------------



Call PrintMenu

'-----------------------------------------------

Sub PrintMenu

%>


<!DOCTYPE html>

	<html lang="en">

		<title>Support Dashboard</title>
		
		<!-- Force IE to turn off past version compatibility mode and use current version mode -->
		<meta http-equiv="X-UA-Compatible" content="IE=edge;chrome=1">
		
		<!-- Get the width of the users display-->
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		
		<!-- Text encoded as UTF-8 -->
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		
 
		<link rel="stylesheet" type="text/css" href="https://netdna.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css" >
		<link rel="stylesheet" type="text/css" href="https://netdna.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
		
<style>

.container
{
background-color: #fcfcfc;
border-left: 1px solid #e0e0e0;
border-right: 1px solid #e0e0e0;
border-top: 1px solid red;
border-bottom: 1px solid #fcfcfc;
left: -250px;
width: 990px;
margin-left: -15px;
margin-right: -15px;
margin-top: -15px;
margin-bottom: -12px;
min-height: 400px;
}

</style>


<style>

/* links: outlines and underscores */  
a.btn,     		
a.btn:active,	
a.btn:focus, 

button.btn:active, 
button.btn:focus,   
button.btn:active, 
button.btn:focus, 

.dropdown-menu li a,
.dropdown-menu li a:active,
.dropdown-menu li a:focus,
.dropdown-menu li a:hover,

ul.dropdown-menu li a,
ul.dropdown-menu li a:active,
ul.dropdown-menu li a:focus,
ul.dropdown-menu li a:hover,

.nav-tabs li a,
.nav-tabs li a:active,
.nav-tabs li a:focus { outline:0px !important; -webkit-appearance:none;  text-decoration:none; color: #666666;}  

</style>

<style>
 


/*--------------------------------------*/

#trigger-list
{
text-align: center;
margin: 100px 0;
padding: 0;
}

#trigger-list li
{
display: inline-block;
*display: inline;
zoom: 1;
}
 

/*--------------------------------------*/

</style>

 
<style>

/* buttons */ 

.btn-default.btn-outline:active,
.btn-default.btn-outline:focus, 
.btn-default.btn-outline 		{ color: #676767; border-color: #676767; background-color: transparent; border-width: 2px; -webkit-transition: all 0.25s; -moz-transition: all 0.25s; transition: all 0.25s;} 	
.btn-default.btn-outline:hover 	{ color: #000000; border-color: #000000; background-color: transparent; border-width: 2px; -webkit-transition: all 0.75s; -moz-transition: all 0.75s; transition: all 0.75s; } 

.btn-outline.btn-highlight	{ color: #676767; border-color: #676767; background-color: transparent; border-width: 2px;}

</style>

<style>

/* message box */

#box
{
width: 100%;

border: 0px;
padding: 15px;
position: fixed;

z-index: 10;
top: -200px;
}

.default
{
background-color: #FAFAFA;
border-color: #222222;
color: #000000;
}

.success
{
background-color: #61b832;
border-color: #55a12c;
}

</style>
 
	</head>

		<body class="bootstrap">
 
		<!--#INCLUDE VIRTUAL="TopNavInclude.asp" -->
 
			<section class="container">
 
				<div class="row">
		
					<div class="col-md-12"> 
 
						<ul id="trigger-list">
							<li><a id="example" class="btn btn-outline btn-default" href="#">Click Me</a></li>
						</ul>
 
					</div>
						
				</div>
				
			</section>
			
			<footer>
			
				<!--#INCLUDE VIRTUAL="FooterInclude.asp" -->
				
				<div id="box" class="label label-success">
					<h3>Message Title</h3>
					<p>Message body text.</p>
				</div>
				
				<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script>

				<script type="text/javascript" language="javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery-easing/1.3/jquery.easing.min.js"></script>
 
				<script type="text/javascript" language="javascript">

					$(document).ready(function()
					{
					
						/* The plugin extends the jQuery Core with four methods */
						
						/* Converting an element into a message box: */
						$.fn.messageBox = function(){
							
							/*
								Applying some CSS rules that center the
								element in the middle of the page and
								move it above the view area of the browser.
							*/
							
							this.css({
								top			: -this.outerHeight(),
								position	: 'absolute'
							});
							
							return this;
						}
						
						/* The boxShow method */
						$.fn.messageBoxShow = function()
						{
							
							/* Starting a downward animation */
							
							this
							.animate
							(
 
								{ top: 0 }, 	// what we are animating
								{
									duration	: 'slow', // how fast we are animating
									easing		: 'easeOutBounce', // the type of easing
									complete	: function() 
									{ 	// the callback
										// alert('done');
									}
								}
							
							);
  
							this.data('boxShown',true);
							return this;
						}
						
						/* The boxHide method */
						$.fn.messageBoxHide = function(){
							
							/* Starting an upward animation */
							
							this.stop().animate({top:-this.outerHeight()});
							this.data('boxShown',false);
							return this;
						}
						
						/* And the boxToggle method */
						$.fn.messageBoxToggle = function(){
						
						/* 
							Show or hide the messageBox depending
							on the 'boxShown' data variable
						*/
						
						if(this.data('boxShown'))
							this.messageBoxHide();
						else
							this.messageBoxShow();
						
						return this;
					}
 
						/* Converting the #box div into a messageBox: */
						$('#message-box').messageBox();

						/* Listening for the click event and toggling the box: */
						$('#example').click(function(e){

							$('#box').messageBoxToggle();
							e.preventDefault();
						});
						
						/* When the box is clicked, hide it: */
						$('#box').click(function(){
							$('#box').messageBoxHide();
						});
					});

				</script>

				
				
				
			</footer>

	</body>
		
	</html>
	
	<%

End Sub


	%>
