<%
'CHANGE LOG
'SSR 3/22/2011
'changed the style sheet to rounded corners
'changed from 4 submit buttons to just 1 submit button
'added look up by organization number

%>

<!--#INCLUDE VIRTUAL=GlobalInclude.asp -->
<!--#INCLUDE VIRTUAL=DBOpenInclude.asp -->

<%

'===============================================

Page = "Management"
SecurityFunction = "CustomDashboard"
ReportFileName = "CustomDashboard.asp"
ReportTitle = "Custom Dashboard"

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

<!---- Document Begin ---------------------->


<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
	<head>
		
        <title>
			Benevolent Dictator Admin Theme
		</title>

		<link rel="stylesheet" href="http://cdn.cloudfiles.mosso.com/c29152/BlueprintScreen.css" type="text/css" />

		<link rel="stylesheet" href="http://cdn.cloudfiles.mosso.com/c29152/BlueprintIE.css" type="text/css" />

		<link rel="stylesheet" href="BenevolentDictator.css" type="text/css" />

		<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script>

		<script type="text/javascript">
		    var currentMenuItem = "";
		    $(document).ready(function () {
		        $("a.MenuTab").click(function () {
		            var contentId = "#" + $(this).attr('id').replace("MenuItem", "MenuContent");
		            var menuContent = $(contentId).html();
		            if (menuContent == null) {
		                currentMenuItem = contentId;
		                $("#MenuContentContainer").slideUp();
		                $("#MenuContentContainer").html(menuContent);
		                location.href = $(this).attr("href");
		            } else {
		                $("#MenuContentContainer").html(menuContent);
		                if (currentMenuItem != contentId) {
		                    currentMenuItem = contentId;
		                    $("#MenuContentContainer").slideDown();
		                } else {
		                    $("#MenuContentContainer").slideUp();
		                }
		            }
		        });
		    });
		</script>

		<style>
			.MenuContent {
				display:none;
				
			}
			
			#MenuContentContainer {
				display:none;
				background-color: #333333;
				color: white;
				padding: 15px;
				
				font-size: 14px;
				font-weight: bold;
				-moz-border-radius: 5px;
				-webkit-border-radius: 5px;
				-webkit-box-shadow: 0 1px 3px rgba(0,0,0, .4);
				-moz-box-shadow: 0 1px 3px rgba(0,0,0, .4);
				border: 1px solid #333333;
				background-image: -moz-linear-gradient(100% 100% 90deg, #333333, #444444);
				background-image: -webkit-gradient(linear, 0% 0%, 0% 100%, from(#444444), to(#333333));
				padding: 10px;	
				margin-top: -5px;
				
			}
			#MenuContentContainer a {
				color: #ffffff;
				border-bottom: none;
			
			}
		</style>

        <style>
        body {
		font-size: 14px;
		background-color: #ffffff;
		
	}
	button, input[type='submit'] {
			color: white;
			font-size: 1.1em;
			border: solid 1px #385b7b;
			background-color: #385b7b;
			background-image: -moz-linear-gradient(100% 100% 90deg, #385b7b,#48739c);
			background-image: -webkit-gradient(linear, 0% 0%, 0% 100%, from(#48739c), to(#385b7b));
			-moz-border-radius: 5px;
			-webkit-border-radius: 5px;
			-webkit-box-shadow: 0 1px 3px rgba(0,0,0, .4);
			-moz-box-shadow: 0 1px 3px rgba(0,0,0, .4);
			
	}
	button:hover, input[type='submit']:hover {
		-webkit-transform: scale(1.1);
		-moz-transform: scale(1.1);
		-webkit-box-shadow: 0 2px 5px rgba(0,0,0, .5);
		-moz-box-shadow: 0 2px 5px rgba(0,0,0, .5);
	}
	dt label {
		margin-left: 18px;
	}
	dd {
		margin-bottom: 10px;
	}
	input[type='text'] {
		font-size: 1.2em;
		width: 80%;
	}
	input[type='password']
    {
		font-size: 1.2em;
		width: 80%;
	}
	select {
		font-size: 1.1em;
		width: 80%;
	}
	a {
		color: #385b7b;
		text-decoration: none;
		border-bottom: solid 1px #385b7b;
	}
	#Header {
		background-color: #333333;
		color: #FFFFFF;
		font-size: 20px;
		font-weight: bold;
		-moz-border-radius: 5px;
		-webkit-border-radius: 5px;
		-webkit-box-shadow: 0 1px 3px rgba(0,0,0, .4);
		-moz-box-shadow: 0 1px 3px rgba(0,0,0, .4);
		border: 1px solid #333333;
		background-image: -moz-linear-gradient(100% 100% 90deg, #333333, #444444);
		background-image: -webkit-gradient(linear, 0% 0%, 0% 100%, from(#444444), to(#333333));
		padding: 10px;	
		margin-top: 10px;
	}
	#HeaderUserMenu {
		font-size: 10px;
		float:right;
	}
	#HeaderUserMenu a {
		text-decoration: none;
		color: #333333;
	}
	
	#MainMenu {
		background-color: #666666;
		color: #FFFFFF;
		font-size: 14px;
		font-weight: bold;
		-moz-border-radius: 5px;
		-webkit-border-radius: 5px;
		-webkit-box-shadow: 0 1px 3px rgba(0,0,0, .4);
		-moz-box-shadow: 0 1px 3px rgba(0,0,0, .4);
		border: 1px solid #555555;
		background-image: -moz-linear-gradient(100% 100% 90deg, #555555, #666666);
		background-image: -webkit-gradient(linear, 0% 0%, 0% 100%, from(#666666), to(#555555));
		padding: 10px;	
		margin-top: 10px;
	}
	#MainMenu ul {
		padding:0;
		margin:0;
	}
	#MainMenu li {
		display: inline;
		list-style: none;
		padding-right: 10px;
		margin: 0;
	}
	#MainMenu a {
		color: #ffffff;
		text-decoration: none;
		padding: 5px;
		border-bottom: none;
	}
	#MainMenu a:hover {
		color: white;
		background-image: -moz-linear-gradient(100% 100% 90deg, #385b7b,#48739c);
		background-image: -webkit-gradient(linear, 0% 0%, 0% 100%, from(#48739c), to(#385b7b));
		-moz-border-radius: 5px;
		-webkit-border-radius: 5px;
		-webkit-transform: scale(1.1);
		-moz-transform: scale(1.1);
		-webkit-box-shadow: 0 2px 5px rgba(0,0,0, .5);
		-moz-box-shadow: 0 2px 5px rgba(0,0,0, .5);
	}
	.Section {
		background-color: #ffffff;
		-moz-border-radius: 5px;
		-webkit-border-radius: 5px;
		-webkit-box-shadow: 0 1px 3px rgba(0,0,0, .4);
		-moz-box-shadow: 0 1px 3px rgba(0,0,0, .4);
		border: 1px solid #cccccc;
		padding: 5px;
		margin-top: 10px;
		margin-bottom: 10px;
	}
	.SectionHeading {
		background-color: #eeeeee;
		font-size: 16px;
		font-weight: bold;
		-moz-border-radius: 5px;
		-webkit-border-radius: 5px;
		-webkit-box-shadow: 0 1px 3px rgba(0,0,0, .4);
		-moz-box-shadow: 0 1px 3px rgba(0,0,0, .4);
		border-bottom: 1px solid #cccccc;
		background-image: -moz-linear-gradient(100% 100% 90deg, #eeeeee, #ffffff);
		background-image: -webkit-gradient(linear, 0% 0%, 0% 100%, from(#ffffff), to(#eeeeee));
		padding: 10px;
	}
	.SectionHeadingMenu {
		font-size: 12px;
		float:right;
	}
	.SectionHeadingMenu a {
		text-decoration: none;
		border: none;
		padding: 5px;
		color: #333333;
	}
	.SectionHeadingMenu a:hover {
		color: white;
		background-color: #385b7b;
		background-image: -moz-linear-gradient(100% 100% 90deg, #385b7b,#48739c);
		background-image: -webkit-gradient(linear, 0% 0%, 0% 100%, from(#48739c), to(#385b7b));
		-moz-border-radius: 5px;
		-webkit-border-radius: 5px;
		-webkit-box-shadow: 0 1px 3px rgba(0,0,0, .4);
		-moz-box-shadow: 0 1px 3px rgba(0,0,0, .4);
	}
	
	.SectionContent {
		margin-top: 10px;
		margin-bottom: 10px;
	}
	.SectionContent p {
		padding-left: 5px;
		padding-right: 5px;
	}
	
	.DataTable {
		padding-top: 10px;
		padding-bottom: 15px;
		border-collapse: collapse;
		
	}
	.DataTable th {
		background-color: #dddddd;
		color: #333333 !important;
		border-top: solid 1px #cccccc;
		border-bottom: solid 1px #cccccc;
	}
	
	.DataTable td {
		border-bottom: solid 1px #eeeeee;
		
	}
	.DataTable tr:hover {
		color:#ffffff;
		background-color: #385b7b;
		background-image: -moz-linear-gradient(100% 100% 90deg, #385b7b,#48739c);
		background-image: -webkit-gradient(linear, 0% 0%, 0% 100%, from(#48739c), to(#385b7b));
		-webkit-box-shadow: 0 1px 3px rgba(0,0,0, .4);
		-moz-box-shadow: 0 1px 3px rgba(0,0,0, .4);
	}
					
	.DataTable tr:hover a {
		color: #ffffff;
		border-bottom: solid 1px #ffffff;
	}
	.PaginationWidget {
		text-align:center;
	}
	.PaginationWidget ul {
		
	}
	.PaginationWidget ul li {
		display: inline;
		list-style: none;
		padding-right: 5px;
		margin: 0;
	}
	.PaginationWidget ul li img {
		margin-bottom: -2px;
	}
	.PaginationWidget ul li a {
		padding-left:8px;
		padding-right:8px;
		padding-top:5px;
		padding-bottom: 5px;
		border: solid #999999 1px;
		text-decoration: none;
	
		color:black;
		background-color: #cccccc;
		
		background-image: -moz-linear-gradient(100% 100% 90deg, #999999,#cccccc);
		background-image: -webkit-gradient(linear, 0% 0%, 0% 100%, from(#cccccc), to(#999999));
		
		-moz-border-radius: 5px;
		-webkit-border-radius: 5px;
		-webkit-box-shadow: 0 2px 3px rgba(0,0,0, .4);
		-moz-box-shadow: 0 2px 3px rgba(0,0,0, .4);
		
	}
	.PaginationWidget ul li a:hover {
		color:white;
		background-color: #385b7b;
		background-image: -moz-linear-gradient(100% 100% 90deg, #385b7b,#48739c);
		background-image: -webkit-gradient(linear, 0% 0%, 0% 100%, from(#48739c), to(#385b7b));
	}
	.PaginationWidget ul li a.selected {
		background-color: #eeeeee;
		color: black;
		
		background-image: -moz-linear-gradient(100% 100% 90deg, #eeeeee, #ffffff);
		background-image: -webkit-gradient(linear, 0% 0%, 0% 100%, from(#ffffff), to(#eeeeee));
	}
	
	.ErrorMessage {
		color: #ffffff;
		font-size: 14px;
		font-weight: bold;
		-moz-border-radius: 5px;
		-webkit-border-radius: 5px;
		-webkit-box-shadow: 0 1px 3px rgba(0,0,0, .4);
		-moz-box-shadow: 0 1px 3px rgba(0,0,0, .4);
		border-bottom: 1px solid #cccccc;
		background-color: #a70f0f;
		background-image: -moz-linear-gradient(100% 100% 90deg, #a70f0f, #c01313);
		background-image: -webkit-gradient(linear, 0% 0%, 0% 100%, from(#c01313), to(#a70f0f));
		padding: 10px;
		margin-top: 5px;
		margin-bottom: 5px;
		margin-left: 10px;
		margin-right: 10px
	}
	.SuccessMessage {
		color: #ffffff;
		font-size: 14px;
		font-weight: bold;
		-moz-border-radius: 5px;
		-webkit-border-radius: 5px;
		-webkit-box-shadow: 0 1px 3px rgba(0,0,0, .4);
		-moz-box-shadow: 0 1px 3px rgba(0,0,0, .4);
		border-bottom: 1px solid #cccccc;
		background-color: #4f8d0d;
		background-image: -moz-linear-gradient(100% 100% 90deg, #4f8d0d, #5ba210);
		background-image: -webkit-gradient(linear, 0% 0%, 0% 100%, from(#5ba210), to(#4f8d0d));
		padding: 10px;
		margin-top: 5px;
		margin-bottom: 5px;
		margin-left: 10px;
		margin-right: 10px;
		
	}
	#Footer {
		font-size: 10px;
		padding-top: 5px;
		border-top: solid 1px #dddddd;
	}
	#CopyrightStatement {
		text-align: right;
	}
	/*
	 The approach to layout for the "NumericMetricBox" stuff leaves much to be desired. However
	 I'm not the world's greatest CSS expert, so I keep running stuck. Any suggestions, improvements
	 for this kind of thing are greatly appreciated. j@wynia.org
	*/
	
	.NumericMetricBox{
		float: left;
		height: 100px;
		width: 130px;
		margin: 20px;
		
		background-color: #ffffff;
		-moz-border-radius: 5px;
		-webkit-border-radius: 5px;
		-webkit-box-shadow: 0 1px 3px rgba(0,0,0, .4);
		-moz-box-shadow: 0 1px 3px rgba(0,0,0, .4);
		background-image: -moz-linear-gradient(100% 100% 90deg, #eeeeee, #ffffff);
		background-image: -webkit-gradient(linear, 0% 0%, 0% 100%, from(#ffffff), to(#eeeeee));
		border: 1px solid #cccccc;
		padding: 5px;
		text-align: right;
		
	}
	.NumericMetricNumber{
		font-size: 2.5em;
		font-weight: bold;
	}
	.NumericMetricDesc{
		border-top: solid 1px #cccccc;
		padding-top: 3px;
	}
	.NumericMetricHealthy{
		background-color: #4f8d0d;
		background-image: -moz-linear-gradient(100% 100% 90deg, #4f8d0d, #5ba210);
		background-image: -webkit-gradient(linear, 0% 0%, 0% 100%, from(#5ba210), to(#4f8d0d));
		color: white;
	}
	.NumericMetricWarning{
		background-color: #ffad1d;
		background-image: -moz-linear-gradient(100% 100% 90deg, #e59b19, #ffad1d);
		background-image: -webkit-gradient(linear, 0% 0%, 0% 100%, from(#ffad1d), to(#e59b19));
		color: white;
	}
	.NumericMetricCritical{
		background-color: #a70f0f;
		background-image: -moz-linear-gradient(100% 100% 90deg, #a70f0f, #c01313);
		background-image: -webkit-gradient(linear, 0% 0%, 0% 100%, from(#c01313), to(#a70f0f));
		color: white;
	}
	</style>
	
</head>

<body>

<!--#INCLUDE VIRTUAL="TopNavInclude.asp"-->


		<div class="container" id="BodyContainer">
			<div  class="span-24 last" id="HeaderContainer">
					<div id="Header">
						Benevolent Dictator Administration
						<div id="HeaderUserMenu">
							Logged in as: Linus Torvalds<br>
						</div>
					</div>
			</div>
			<div class="span-24 last" id="MenuContainer">
				<div id="MainMenu">
					<ul id="MainMenuList">
						<li><a href="http://google.com" class="MenuTab" id="HomeMenuItem">Home</a></li>
						<li><a href="#" class="MenuTab" id="OrdersMenuItem">Orders</a></li>
						<li><a href="#" class="MenuTab" id="UsersMenuItem">Users</a></li>
						<li><a href="#" class="MenuTab" id="MessagesMenuItem">Messages</a></li>
					</ul>
				</div>
				<!-- 
					This is a section if divs that hold the content for each menu item as well as the container where
					we swap them in and out. MenuContentContainer has its content replaced and then it's display toggled.
				-->
				<div id="MenuContentContainer">
				  PLACEHOLDER
				</div>
				</div>
				
				<div id="OrderItemsContainer">
				<!-- 
					Create one XYZMenuContent for each XYZMenuItem in the MainMenuList. The plumbing for the menu relies on the XYZ 
					part being the same for both.
				-->	
				  <div id="OrdersMenuContent" class="MenuContent">
						<ul>
							<li><a href="#">Find Orders</a></li>
							<li>Create New Order</li>
							<li>Recent Orders</li>
						</ul>
						<p>
							You can put any HTML content you want for your menu: tables, grids of links, headings, etc. This entire div just displays below the menu when requested.
						</p>
					</div>
				  <div id="UsersMenuContent" class="MenuContent">
						<div style="float:right; margin: 15px;">
							All of the mega menu functionality is convention based for naming.
						</div>
						<ul>
							<li>Find User</li>
							<li>Create New User</li>
							<li>Browse Users By Role</li>
						</ul>
					</div>
					<div id="MessagesMenuContent" class="MenuContent">
						<ul>
							<li>Find Message</li>
							<li>Create New Message</li>
							<li>Browse All Pending Messages</li>
						</ul>
					</div>
				</div>
			
				
			
		
			<div class="span-24 last" id="MainContentContainer">
				<div id="MainContent">
					<div class="span-24 last">
						<!-- I'd really like to see a better approach to how to lay out the widgets for this "dashboard"
							  feature. Most everything I try sucks. j@wynia.org-->
						<div class="Section">
							<div class="SectionHeading">
								Dashboard
							</div>
							<div class="SectionContent" style="height: 150px;text-align: center">
							  
							  <div class="NumericMetricBox NumericMetricWarning">
									<div class="NumericMetricNumber">
									   0
									</div>
									<div class="NumericMetricDesc">
									   Sold Tickets
									</div>
								</div>
								
								<div class="NumericMetricBox">
									<div class="NumericMetricNumber">
									   45
									</div>
									<div class="NumericMetricDesc">
									   Sites
									</div>
								</div>
								
								<div class="NumericMetricBox NumericMetricCritical">
									<div class="NumericMetricNumber">
									   3
									</div>
									<div class="NumericMetricDesc">
									   Failing Tests
									</div>
								</div>
								
								<div class="NumericMetricBox NumericMetricHealthy">
									<div class="NumericMetricNumber">
									   35198
									</div>
									<div class="NumericMetricDesc">
									   Users Today
									</div>
								</div>
								
								<div class="NumericMetricBox NumericMetricHealthy">
									<div class="NumericMetricNumber">
									   26
									</div>
									<div class="NumericMetricDesc">
									   Checkouts Today
									</div>
								</div>
								
							</div>
						</div>
					</div>
					<div class="span-24 last">
						<div class="span-12">
							<div class="Section">
								<div class="SectionHeading">
									About This Theme
								
								</div>
								<div class="SectionContent">
									<p>
										This theme was created to give me a starting point for the "line of business" applications that 
										I build for clients. Most of these apps never see the light of day outside of the firewall and,
										as a result, no one puts much effort into making them look nice.
									</p>
									<p>
										However, people's perception of applications always includes how it looks. So, I created this
										so I have something that I can start with with no cost (time or money) to my project. 
									</p>
									<p>
										My primary aim is a theme that can be used for a variety of basic business apps and is suited
										for embedding into server-side application frameworks. I bought several admin themes from online
										"theme stores" only to be seriously frustrated when trying to integrate them into an app.
									</p>
									<p>
										That's because when you try to slice up things like the sections/boxes on this page, you discover that 
										you can't easily move those bits of HTML into controls, partial views or whatever your framework
										calls sub-snippets of HTML that sub-components of your application use to display their information.
										This theme is explicitly trying to fix that problem.
									</p>
									
								</div>
							</div>
						</div>
						<div class="span-12 last">
							<div class="Section">
							<div class="SectionHeading">
								License
							</div>
							<div class="SectionContent">
								<p>
									This theme is licensed under the terms of the Creative Commons Attribution license. If you merely <em>use</em>
									the theme on a site or application, no link or credit is necessary. Just use it and enjoy. I only want
									credit if you decide to distribute it as a theme from, for example, a CSS theme site.
								</p>
								<p>
									So, what it boils down to is, use it however you want, but don't slap your name on it and claim you made it
									all on your own. Honest people will never run afoul of the intended use. There is NO restriction on commercial
									use. I absolutely want you to use this theme on your commercial project for your client, internal project or
									website.
								</p>
							</div>
						</div>
					</div>
				
					
					<div class="span-24 last">
						<div class="Section">
							<div class="SectionHeading">
								Pending Orders
								<div class="SectionHeadingMenu">
									<a href="">New Order</a> | <a href="">Find an Order</a>
								</div>
							</div>
							<div class="SectionContent">
								<table class="DataTable">
									<tr>
										<th>Order Num.</th>
										<th>Customer</th>
										<th>Location</th>
										<th>Date</th>
										<th>Total</th>
									</th>
									<tr>
										<td>1234</td>
										<td>Wilson Plumbing</td>
										<td>Minneapolis, MN</td>
										<td>2010-04-30</td>
										<td>$425.86</td>
									</tr>
									<tr>
										<td>6578</td>
										<td>Smith Electric</td>
										<td>St. Paul, MN</td>
										<td>2010-04-20</td>
										<td>$741.29</td>
									</tr>
									<tr>
										<td>1234</td>
										<td>Wilson Plumbing</td>
										<td>Minneapolis, MN</td>
										<td>2010-04-30</td>
										<td>$425.86</td>
									</tr>
									<tr>
										<td>6578</td>
										<td>Smith Electric</td>
										<td>St. Paul, MN</td>
										<td>2010-04-20</td>
										<td>$741.29</td>
									</tr>
								</table>
									<div class="PaginationWidget">
										<ul>
											<li><a href="#">&lt;&lt;</a></li>
											<li><a href="#">1</a></li>
											<li><a href="#">2</a></li>
											<li><a href="#" class="selected">3</a></li>
											<li><a href="#">4</a></li>
											<li><a href="#">5</a></li>
											<li><a href="#">6</a></li>
											<li><a href="#">&gt;&gt;</a></li>
										</ul>
									</div>
				  			</div>
						</div>
						
					</div>
				
					<div class="span-12">
						<div class="Section">
							<div class="SectionHeading">
								Users
								<div class="SectionHeadingMenu">
									<a href="">Add New User</a> | <a href="">Search</a>
								</div>
							</div>
							<div class="SectionContent">
								<table class="DataTable">
									<tr>
										<th>UserID</th>
										<th>Full Name</th>
										<th>Location</th>
										<th>Status</th>
									</tr>
									<tr>
										<td><a href="">173920</a></td>
										<td>Joe User</td>
										<td>Minneapolis, MN</td>
										<td>Active</td>
									</tr>
									<tr>
										<td><a href="">138293</a></td>
										<td>Joe User</td>
										<td>Minneapolis, MN</td>
										<td>Active</td>
									</tr>
									<tr>
										<td><a href="">58390</a></td>
										<td>Joe User</td>
										<td>Minneapolis, MN</td>
										<td>Active</td>
									</tr>
									<tr>
										<td><a href="">173812</a></td>
										<td>Frank Stein</td>
										<td>St. Paul, MN</td>
										<td>Inactive</td>
									</tr>
									<tr>
										<td><a href="">13920</a></td>
										<td>Joe User</td>
										<td>Minneapolis, MN</td>
										<td>Active</td>
									</tr>
									<tr>
										<td><a href="">287391</a></td>
										<td>Nonna Urbixness</td>
										<td>Minneapolis, MN</td>
										<td>Inactive</td>
									</tr>
								</table>
							</div>
						</div>
					
						
						
					</div>
					<div class="span-12 last">
						<div class="Section">
						<div class="SectionHeading">
							Submit Ticket
						</div>
						<div class="SectionContent">
							<div class="ErrorMessage">
								Unable to submit ticket. Please enter a description.
							</div>
							<div class="SuccessMessage">
								Ticket submitted. Someone will contact you shortly.
							</div>
							<dl>
								<dt>
									<label>
										Title
									</label>
								</dt>
									<dd>
										<input type="text" value="Production web server is down.">
									</dd>
								<dt>
									<label>
										Description
									</label>
								</dt>
										<dd>
											<textarea>
											</textarea>
										</dd>
								<dt>
									<label>
										Severity
									</label>
								</dt>
									<dd>
										<select>
											<option>Below Normal</option>
											<option>Normal</option>
											<option>Critical</option>
										</select>
									</dd>
								<dt>
								</dt>
									<dd>
										<button>Submit</button>
									</dd>
							</dl>
						</div>
					</div>
					</div>
				</div>
			</div>
			
			
			<div class="span-24 last" id="PageFooterContainer">
					<div id="Footer">
						<div class="span-12">				
						 	Benevolent Dictator is an open source "admin" web theme.
						</div>
						<div class="span-12 last" id="CopyrightStatement">
							&copy 2010 Pragmapool, Inc. Very Few Rights Reserved.
						</div>
					</div>
			</div>
		</div>


        

	</body>
</html>

<!---------------Document End -------------->

<%

End Sub

%>