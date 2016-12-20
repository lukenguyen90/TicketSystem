<cfscript>
	var listAction=QueryExecute("SELECT actionID,comments,activityName 
						FROM actions a1 
						LEFT JOIN activities a2 
						ON a1.activityID=a2.activityID
						WHERE isNew=1 AND userID="&SESSION.userID);
</cfscript>
<style type="text/css">
/*.user-info .user-avatar{
	display: none;
}*/
.header-ticket{
	margin-right: 10px;
}
.input-icon > .ace-icon{
	height: 28px;
	top:10px;
}
.ace-nav > li {
    border-left: none;
}
@media(max-width:767px){
	/*.nav-btn .btn-text{
		display: none;
	}
	.nav-btn:hover .btn-text{
		display: inline-block;
	}
	.user-info .user-text,.user-info .user-name{
		display: none;
	}
	.user-info .user-avatar{
		display: inline-block;
	}*/
	.input-icon > .ace-icon{
		top: 10px;
		height: 26px;
	}
}
</style>
<cfoutput>
	<script type="text/javascript">
	var listActionID=new Array();
	<cfloop query=#listAction#>
		listActionID[listActionID.length]=#listAction.actionID#;
	</cfloop>
	var clickFirst=true;
	function unNewAction(){
		if(clickFirst){
			$("##numNotification").text("0");
			$.ajax({
				url: '/index.cfm/main.unNewAction',
				method:'POST',
				dataType: 'json',
				data: {
					actionID:listActionID
				},
				success: 	function(data) {
					if(data){
						clickFirst=false;
					}
				}
			});
		}
	}
	</script>
	<div id="navbar" class="navbar navbar-default nav-header">
		<script type="text/javascript">
			try{ace.settings.check('navbar' , 'fixed')}catch(e){}
		</script>

		<div class="navbar-container" id="navbar-container">
			<!-- section:basics/sidebar.mobile.toggle -->
			<button type="button" class="navbar-toggle menu-toggler pull-left" id="menu-toggler">
				<span class="sr-only">Toggle sidebar</span>

				<span class="icon-bar"></span>

				<span class="icon-bar"></span>

				<span class="icon-bar"></span>
			</button>
		    <div class="navbar-header pull-left">
		      <a href="#buildUrl('home:main')#" class="navbar-brand" style="
    padding: 0px;">
		        <small>
		          <img src="#getContextRoot()#/images/gallery/logoRasia.png" class="logo">
		        </small>
		      </a>
		      <div class="log-header" style="display: inline-block; height: 45px; vertical-align: middle; padding-left: 10px; padding-top: 10px;">
		    		<span id="tracker-header" class="header-ticket"></span>
		    		<span id="tracker-header-timing" class="header-logtime"></span>
		    	</div>
		    </div>
		    <div class="navbar-buttons navbar-header pull-right" role="navigation">
				<ul class="nav ace-nav">	
					<li class="nav-search" id="nav-search">
						<!--- <div > --->
							<span class="input-icon">
								<input type="text" placeholder="#getLabel('Search', #SESSION.languageId#)# ..." class="nav-search-input inputSearch" id="search" autocomplete="off" onkeypress="searchEnter(event)" >
								<i class="ace-icon fa fa-search nav-search-icon"></i>
							</span>
						<!--- </div> --->
					</li>
					<li class="green nav-btn">
						<a href="/index.cfm/ticket.create">
							<i class="ace-icon glyphicon glyphicon-plus icon-on-right"></i>
							<span class="btn-text">#getLabel("Create a ticket", #SESSION.languageId#)#</span>	
						</a>
					</li>
				<cfif listAction.recordCount neq 0>
					<li class="purple">
						<a data-toggle="dropdown" class="dropdown-toggle" href="" onClick='unNewAction()'>
							<i class="ace-icon fa fa-bell icon-animated-bell"></i>
							<span class="badge badge-important" id="numNotification">#listAction.recordCount#</span>
						</a>

						<ul class="dropdown-menu-right dropdown-navbar navbar-pink dropdown-menu dropdown-caret dropdown-close" style="max-height:400px;overflow:scroll;">
							<li class="dropdown-header">
								<i class="ace-icon fa fa-exclamation-triangle"></i>
								#listAction.recordCount# Notifications
							</li>
						<cfloop query=#listAction#>
							<cfif(listAction.activityName eq "Registered")>
							<li>
								<a >
									<div class="clearfix">
										<span class="pull-left">
											<i class="btn btn-xs btn-primary fa fa-user"></i>
											#listAction.comments#
										</span>
									</div>
								</a>
							</li>
							<cfelse>
							<li>
								<a >
									<div class="clearfix">
										<span class="pull-left">
											<i class="btn btn-xs no-hover btn-pink fa fa-comment"></i>
											#listAction.comments#
										</span>
									</div>
								</a>
							</li>
							</cfif>
						</cfloop>
							<!--- <li>
								<a href="">
									<i class="btn btn-xs btn-primary fa fa-user"></i>
									Bob just signed up as an editor ...
								</a>
							</li>

							<li>
								<a href="">
									<div class="clearfix">
										<span class="pull-left">
											<i class="btn btn-xs no-hover btn-success fa fa-shopping-cart"></i>
											New Orders
										</span>
										<span class="pull-right badge badge-success">+8</span>
									</div>
								</a>
							</li>

							<li>
								<a href="">
									<div class="clearfix">
										<span class="pull-left">
											<i class="btn btn-xs no-hover btn-info fa fa-twitter"></i>
											Followers
										</span>
										<span class="pull-right badge badge-info">+11</span>
									</div>
								</a>
							</li>

							<li class="dropdown-footer">
								<a href="">
									See all notifications
									<i class="ace-icon fa fa-arrow-right"></i>
								</a>
							</li> --->
						</ul>
					</li>
				</cfif>
					<li class="light-blue pull-right">
					<cfif SESSION.isLoggedIn eq true>
			              <a  data-toggle="dropdown" class="dropdown-toggle">
			                <span class="user-info">
			                  <small>
			                  	<cfif structKeyExists(SESSION,'avatar')>
			                  	<cfif SESSION.avatar neq "">
			                  		<img style="width:32px; height:32px;" alt="#SESSION.name#" title="#SESSION.name#" class="img-circle user-avatar" src="/fileupload/avatars/#SESSION.avatar#"/>
			                  	<cfelse>
			                  		<div style="font-size: 16px; height: 33px; padding-top: 8px;display: inline-block;">#SESSION.name#</div>
			                  	</cfif>
			                  	</cfif>
			                  	<!--- <span class="user-text">#getLabel("Welcome", #SESSION.languageId#)#</span> <span class="user-name">#SESSION.name#</span> --->
			                  	<i class="ace-icon fa fa-caret-down"></i>
			                  </small>
			                </span>
			              </a>

			              <ul class="user-menu dropdown-menu-right dropdown-menu dropdown-yellow dropdown-caret dropdown-close">
			                <li>
			                  <a href="/index.cfm/user/edit">
			                    <i class="ace-icon glyphicon glyphicon-refresh"></i>
			              		#getLabel("Edit profile", #SESSION.languageId#)#
			                  </a>
			                </li>
			                <li>
			                  <a href="#buildUrl('home:logout')#">
			                    <i class="ace-icon fa fa-power-off"></i>
			                    #getLabel("Logout", #SESSION.languageId#)#
			                  </a>
			                </li>
			              </ul>
			         </cfif>
				    </li>
					<script type="text/javascript">
						function searchEnter(event){
							if(event.keyCode == 13 ){
								var stri=$("##search").val();
								var resp = stri.replace(/ /g, "+"); 
								window.location='/index.cfm?search='+resp;
							}
						}							
					</script>
				</ul>
		    </div>
		</div>
    </div>
</cfoutput>