<cfoutput>
	<script type="text/javascript">
		$(document).ready(function(){

            jQuery(function() {
                jQuery('ul.nav-list li').each(function() {
	                  var href = jQuery(this).find('a').attr('href');
	                  var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
	                  if (href === window.location.pathname+"?"+hashes) {
	                  	jQuery(this).parent().parent().addClass('active open');
	                    jQuery(this).addClass('active');
	                  }
	                  if (href === window.location.pathname) {
	                  	jQuery(this).parent().parent().addClass('active open');
	                  	jQuery(this).parent().addClass('active open');
	                    jQuery(this).addClass('active');
	                  }
	            }); 
        	});
        });

		try{ace.settings.check('main-container' , 'fixed')}catch(e){};
	</script>
	<cfset focusProject1 = structKeyExists(SESSION,'focuspj')?(SESSION.focuspj neq 0 ? '?pId='&SESSION.focuspj:''):''>
	<cfset focusProject2 = structKeyExists(SESSION,'focuspj')?(SESSION.focuspj neq 0 ? '&pId='&SESSION.focuspj:''):''>
	<div id="sidebar" class="sidebar responsive sidebar-fixed menu-min">
		<script type="text/javascript">
					try{ace.settings.check('sidebar' , 'fixed')}catch(e){}
				</script>

				<ul class="nav nav-list">
					<!--- <li class="">
						<a href="/index.cfm">
							<i class="menu-icon fa fa-tachometer"></i>
							<span class="menu-text"> Dashboard </span>
						</a>
					</li> --->
					<li class="">
						<a href="/index.cfm/project/" class="dropdown-toggle" >
							<i class="menu-icon fa fa-suitcase"></i>
								<span class="menu-text" >#getLabel("Projects", #SESSION.languageId#)# </span>

							<b class="arrow fa fa-angle-down"></b>
						</a>

						<b class="arrow"></b>
						<ul class="submenu">
							<li class="">
								<a href="/index.cfm/project/overview" >
									<i class="ace-icon fa fa-suitcase"></i>
									<span class="menu-text">#getLabel("List projects", #SESSION.languageId#)#</span>
								</a>

								<b class="arrow"></b>
							</li>
							<li class="">
								<a href="/index.cfm/project/#focusProject1#" >
									<i class="ace-icon fa fa-sun-o"></i>
									<span class="menu-text">#getLabel("Project Dashboard", #SESSION.languageId#)#</span>
								</a>

								<b class="arrow"></b>
							</li>
							<li class="">
								<a href="/index.cfm/project/epic/#focusProject1#" >
									<i class="ace-icon fa fa-calendar"></i>
									<span class="menu-text">#getLabel("Epic", #SESSION.languageId#)#</span>
								</a>

								<b class="arrow"></b>
							</li>
							<li class="">
								<a href="/index.cfm/project/versions/#focusProject1#" >
									<i class="ace-icon fa fa-calendar"></i>
									<span class="menu-text">#getLabel("Versions", #SESSION.languageId#)#</span>
								</a>

								<b class="arrow"></b>
							</li>
							<cfif SESSION.userType eq 3>
								<li class="">
									<a href="/index.cfm/project/form">
										<i class="ace-icon fa fa-plus"></i>
										<span class="menu-text">#getLabel("New Project", #SESSION.languageId#)#</span>
									</a>
									<b class="arrow"></b>
								</li>
							</cfif>
							<li class="">
								<a href="/index.cfm/project/ticket_listing/#focusProject1#" >
									<i class="ace-icon fa fa-ticket"></i>
									<span class="menu-text">#getLabel("Ticket Listing", #SESSION.languageId#)#</span>
								</a>

								<b class="arrow"></b>
							</li>
							<cfif SESSION.userType eq 3>
								<li class="">
									<a href="/index.cfm/project/ticketManager" >
										<i class="ace-icon fa fa-edit"></i>
										<span class="menu-text">Ticket Manager</span>
									</a>

									<b class="arrow"></b>
								</li>
							</cfif>								
						</ul>
					</li>	
					<cfif SESSION.userType eq 1>
					<li class="">
						<a href="/index.cfm?rp=#SESSION.userID##focusProject2#">
							<i class="menu-icon fa fa-tags"></i>
							<span class="menu-text">#getLabel("Tickets", #SESSION.languageId#)# </span>
						</a>
					</li>
					<cfelse>
						<li class="">
							<a href="/index.cfm/main/todo">
								<i class="menu-icon fa fa-tags"></i>
								<span class="menu-text">#getLabel("To do list ", #SESSION.languageId#)# </span>
							</a>
						</li>
					</cfif>				
					<cfif SESSION.userType eq 2>
					<li class="">
						<a href="/index.cfm?as=#SESSION.userID##focusProject2#">
							<i class="menu-icon fa fa-tags"></i>
							<span class="menu-text">#getLabel("Tickets", #SESSION.languageId#)# </span>
						</a>
					</li>	
					</cfif>			
					<cfif SESSION.userType eq 3>
					<li class="">
						<a href="/index.cfm?st=1#focusProject1#">
							<i class="menu-icon fa fa-tags"></i>
							<span class="menu-text">#getLabel("Tickets", #SESSION.languageId#)# </span>
						</a>
					</li>	
					</cfif>
					<li class="">
						<a href="/index.cfm/ticket.create">
							<i class="menu-icon fa fa-plus-square"></i>
							<span class="menu-text"> #getLabel("Create a ticket", #SESSION.languageId#)# </span>
						</a>
					</li>
					<li class="">
						<a href="/index.cfm/report" class="dropdown-toggle">
							<i class="menu-icon fa fa-area-chart"></i>
							<span class="menu-text">#getLabel("Reports", #SESSION.languageId#)#</span>

							<b class="arrow fa fa-angle-down"></b>
						</a>

						<b class="arrow"></b>
						<ul class="submenu">
							<li class="">
								<a href="/index.cfm/report/" >
									<i class="ace-icon fa fa-clock-o"></i>
									<span class="menu-text">#getLabel("Time Entry Reports", #SESSION.languageId#)#</span>
								</a>

								<b class="arrow"></b>
							</li>
							<li class="">
								<a href="/index.cfm/report/daily/" >
									<i class="ace-icon fa fa-sun-o"></i>
									<span class="menu-text">#getLabel("Daily Reports", #SESSION.languageId#)#</span>
								</a>

								<b class="arrow"></b>
							</li>
							<li class="">
								<a href="/index.cfm/report/weekly/" >
									<i class="ace-icon fa fa-calendar"></i>
									<span class="menu-text">#getLabel("Weekly Reports", #SESSION.languageId#)#</span>
								</a>

								<b class="arrow"></b>
							</li>
							<li class="">
								<a href="/index.cfm/report/monthly/" >
									<i class="ace-icon fa fa-calendar"></i>
									<span class="menu-text">#getLabel("Monthly Reports", #SESSION.languageId#)#</span>
								</a>

								<b class="arrow"></b>
							</li>
							<li class="">
								<a href="/index.cfm/report/survey/" >
									<i class="ace-icon fa fa-calendar"></i>
									<span class="menu-text">#getLabel("Vote Survey", #SESSION.languageId#)#</span>
								</a>

								<b class="arrow"></b>
							</li>
							<li class="">
								<a href="/index.cfm/report/resultVote/" >
									<i class="ace-icon fa fa-calendar"></i>
									<span class="menu-text">#getLabel("Vote Monthly Reports", #SESSION.languageId#)#</span>
								</a>

								<b class="arrow"></b>
							</li>
						</ul>
					</li>	
					<!--- <li class="">
						<a href="/index.cfm/report/timeline" >
							<i class="menu-icon fa fa-calendar"></i>
								<span class="menu-text" >Timeline
								<span class="badge badge-transparent tooltip-error" title="" data-original-title="New Feature">
									<i class="ace-icon fa fa-asterisk red bigger-130"></i>
								</span>
							</span>
						</a>
					</li> --->
					<cfif SESSION.userType eq 3>
					<li class="">
						<a href="" class="dropdown-toggle">
							<i class="menu-icon fa fa-gears"></i>
							<span class="menu-text">#getLabel("Management", #SESSION.languageId#)#</span>

							<b class="arrow fa fa-angle-down"></b>
						</a>
						<b class="arrow"></b>
						<ul class="submenu">
							<li class="">
								<a href="/index.cfm/company" >
									<i class="ace-icon fa fa-home"></i>
									<span class="menu-text">#getLabel("Company", #SESSION.languageId#)#</span>
								</a>
								<b class="arrow"></b>
							</li>
							<li class="">
								<a href="/index.cfm/user" >
									<i class="ace-icon fa fa-group"></i>
										<span class="menu-text">#getLabel("Users", #SESSION.languageId#)#</span>
								</a>
								<b class="arrow"></b>
							</li>
							
							<li class="">
								<a href="/index.cfm/language" >
									<i class="ace-icon fa fa-language"></i>
									<span class="menu-text">#getLabel("Language", #SESSION.languageId#)#</span>
								</a>
								<b class="arrow"></b>
							</li>
							
							<li class="">
								<a href="/index.cfm/typeEntry" >
									<i class="ace-icon fa fa-edit"></i>
									<span class="menu-text">#getLabel("Type Entries", #SESSION.languageId#)#</span>
								</a>
								<b class="arrow"></b>
							</li>
						</ul>
					</li>
					<cfelse>
						<li class="">
							<a href="/index.cfm/user">
								<i class="menu-icon fa fa-user"></i>
								<span class="menu-text">#getLabel("User", #SESSION.languageId#)# </span>
							</a>
						</li>	
					</cfif>					
				<cfif SESSION.userType neq 1>
					<li class="">
						<cfif SESSION.userType eq 2>
						<a href="/index.cfm/plan/?user=#SESSION.userID##focusProject2#">
						<cfelse>
						<a href="/index.cfm/plan#focusProject1#">
						</cfif>
							<i class="menu-icon fa fa-tasks"></i>
							<span class="menu-text"> #getLabel("Plan", #SESSION.languageId#)# </span>
						</a>
					</li>	
					<li class="">
						<a href="/index.cfm/sprint#focusProject1#">
							<i class="menu-icon fa fa-credit-card"></i>
							<span class="menu-text"> #getLabel("Sprint", #SESSION.languageId#)# </span>
						</a>
					</li>
				</cfif>	
					<li class="">
						<a href="/index.cfm/kanban/#focusProject1#">
							<i class="menu-icon fa fa-heart-o"></i>
							<span class="menu-text"> #getLabel("Kanban table", #SESSION.languageId#)# </span>
						</a>
					</li>	
				<cfif SESSION.userType eq 3>
					<li class="">
						<a href="/index.cfm/email" >
							<i class="menu-icon fa fa-envelope-square"></i>
							<span class="menu-text">#getLabel("Config Email", #SESSION.languageId#)#</span>
						</a>
					</li>
				</cfif>
				<li class="">
					<a href="/index.cfm/calendar" >
						<i class="menu-icon fa fa-calendar"></i>
						<span class="menu-text">#getLabel("Calendar", #SESSION.languageId#)#</span>
					</a>
				</li>
				<cfif SESSION.userType eq 3 || SESSION.userId eq 37>
					<li class="">
						<a href="/index.cfm/manager" >
							<i class="menu-icon fa fa-users"></i>
							<span class="menu-text">#getLabel("Manager", #SESSION.languageId#)#</span>
						</a>
					</li>
				</cfif>
				<cfif SESSION.isOfficial>
					<li class="">
						<a href="/index.cfm/annual_leave" >
							<i class="menu-icon fa fa-pencil-square-o"></i>
							<span class="menu-text">#getLabel("Submit Day Off", #SESSION.languageId#)#</span>
						</a>
					</li>
				</cfif>

				<li class="">
					<a href="/index.cfm/annual_leave/uploadFile" >
						<i class="menu-icon fa fa-file"></i>
						<span class="menu-text">#getLabel("Upload File", #SESSION.languageId#)#</span>
					</a>
				</li>
				<!--- <cfif SESSION.userType neq 1>
					<li class="">
						<a href="" class="dropdown-toggle">
							<i class="menu-icon fa fa-eye"></i>
							<span class="menu-text">#getLabel("Check in", #SESSION.languageId#)#</span>

							<b class="arrow fa fa-angle-down"></b>
						</a>
						<b class="arrow"></b>
						<ul class="submenu">
							<li class="">
								<cfif SESSION.userType eq 3>
									
								
								<a href="/index.cfm/checkin" >
									<i class="ace-icon fa fa-upload"></i>
									<span class="menu-text">#getLabel("Import data", #SESSION.languageId#)#</span>
								</a>
								</cfif>
								<b class="arrow"></b>
							</li>
							<li class="">
								<a href="/index.cfm/checkin/weekly" >
									<i class="ace-icon fa fa-calendar"></i>
										<span class="menu-text">#getLabel("Weekly Report", #SESSION.languageId#)#</span>
								</a>
								<b class="arrow"></b>
							</li>							
						</ul>
					</li>
				</cfif> --->
				</ul><!-- /.nav-list -->

				<!-- section:basics/sidebar.layout.minimize -->
				<div class="sidebar-toggle sidebar-collapse" id="sidebar-collapse">
					<i class="ace-icon fa fa-angle-double-right" data-icon1="ace-icon fa fa-angle-double-left" data-icon2="ace-icon fa fa-angle-double-right"></i>
				</div>

				<!-- /section:basics/sidebar.layout.minimize -->
				<script type="text/javascript">
					try{ace.settings.check('sidebar' , 'collapsed')}catch(e){}
				</script>
	</div>
</cfoutput>