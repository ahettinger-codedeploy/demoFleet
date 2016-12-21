						<!----start dash nav ---------->
						<nav class="navbar card-2" id="navbar-main">
							<div class="container-fluid">
 		
								<div class="col-md-12">
														
									<div class=" navbar-btn navbar-left btn-group" style="margin-right:5px;">
										<BUTTON id="btn-options" type="button" class="btn btn-large btn-navbar btn-default" data-placement="top" title="Options">
												<i class="fa fa-bars"></i>
												<span class="nav-label">&nbsp;&nbsp;Menu</span>
										</BUTTON>			
									</div>
									
									<div class="navbar-btn pull-right btn-group" style="margin-left:5px;">	
										<BUTTON id="btn-dashboard" type="button" class="btn btn-large btn-navbar btn-default" data-placement="top" title="dashboard home">
											<i class="fa fa-dashboard"></i>
											<span class="nav-label">&nbsp;&nbsp;Dashboard</span>
										</BUTTON>			
									</div>
									
									<FORM ACTION="/<%=fnRootFolder%>/support/tixDashboard/user_lookup/index.asp" METHOD="post" NAME="SearchForm" class="navbar-form">
										<div class="input-group" style="display:table;">            
											<span class="input-group-btn" style="width:1%;">   
												<button id="btn-search" class="btn btn-navbar btn-default" type="button">
													<i class="fa fa-user"></i>
													<span class="nav-label">&nbsp;&nbsp;User</span>
												</button> 
											</span>  
											<input type="search" name="SearchString" class="form-control input-navbar" id="input-search" autocomplete="off" placeholder="Search by User Name" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Enter First or Last Name'">  									
										</div>
									</form>

								</div>
							
							</div>	
						</nav>
						<!----end dash nav ---------->