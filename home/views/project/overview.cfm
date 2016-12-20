<!--- <cfdump eval = rc abort> --->
<style type="text/css">
    .mousechange:hover {
        cursor:pointer;
    }
</style>
<cfoutput>
<!--- <div class="page-content">
	<div class="page-content-area"> --->
		<div class="page-header">
			<h1>
				#getLabel("Dashboard", #SESSION.languageId#)#
				<small>
					<i class="ace-icon fa fa-angle-double-right"></i>
					#getLabel("overview", #SESSION.languageId#)# &amp; #getLabel("stats", #SESSION.languageId#)#
				</small>
				<cfif SESSION.userType EQ 3>
					<button class="btn btn-sm btn-info pull-right" onclick="add();" >
						<span id="aLang" style="font-family: 'Open Sans';">#getLabel("Create new project", #SESSION.languageId#)#</span></i>
					</button>
                </cfif>
			</h1>
		</div>
		<!--- <div id="wrapper"> --->
	       
	        <div class="row">
	            <div class="row col-lg-12">
	                <div class="wrapper wrapper-content animated fadeInUp">
	                    <div class="row ibox col-md-12">
	                        <div class="ibox-content">
	                            <div class="project-list">
	                                <table id="po" class="table table-hover datatable table-bordered">
	                                	<thead>
											<tr>
							                    <th style="width:120px;">&nbsp;#getLabel("Status", #SESSION.languageId#)#</th>
							                    <th>&nbsp;#getLabel("Project", #SESSION.languageId#)#</th>
							                    <th style="width:100px;">&nbsp;#getLabel("Type", #SESSION.languageId#)#</th>
							                    <th style="width:100px;">&nbsp;#getLabel("Tickets", #SESSION.languageId#)#</th>
							                    <th style="width:100px;">&nbsp;#getLabel("Hours", #SESSION.languageId#)#</th>
							                    <th style="width:105px;">&nbsp;#getLabel("This week", #SESSION.languageId#)#</th>
							                    <th style="width:200px;">&nbsp;#getLabel("Team", #SESSION.languageId#)#</th>
							                </tr>
							            </thead>
	                                    <tbody>
	                                    	<cfloop array=#rc.rs# index="item">
			                                    <tr>
			                                        <!--- <td class="project-status">
			                                        	<cfif item.active EQ 1>
			                                        		<span class="label label-primary">Active</span>
			                                        	<cfelse>
			                                        		<span class="label label-default">Unactive</span>
			                                        	</cfif>
			                                        </td> --->
			                                        <td>
			                                        	<span class="label label-#item.color#">#item.status#</span>
			                                            
			                                        </td>
			                                        <td class="project-title">
			                                            <a href="/index.cfm/project/?pId=#item.projectID#">#item.shortName# - #item.projectName#</a>
			                                            <cfif SESSION.userType eq 3>
                            								<a class="green" href="/index.cfm/project/form?pId=#item.projectID#"><abbr title="Click to edit project"></abbr> <i class="ace-icon fa fa-pencil-square-o  bigger-110 icon-on-right"></i></a>
														</cfif>
			                                            <br/>
			                                            <small>Leader: <a href="/index.cfm/user?id=#item.userID#">#item.teamLeader#</a></small>
			                                        </td>
			                                        <!--- <td class="project-completion">
			                                                <small>Completion with: 48%</small>
			                                                <div class="progress progress-mini">
			                                                    <div style="width: 48%;" class="progress-bar"></div>
			                                                </div>
			                                        </td> --->
			                                        
			                                        <td >
			                                            #item.type#
			                                        </td>
			                                        <td >
				                                                	<span class="label label-purple mousechange" style="width:30px;" title="Previous month">#item.ticketPrev#</span>
				                                                	<span class="label label-info mousechange" title="This month" style="width:30px;">#item.ticketNow#</span>

				                                                <!--- <div><small>Current</small> <span>: #item.ticketNow#</span></div>
				                                                <div><small>Last&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</small> <span>: #item.ticketPrev#</span></div> --->
			                                              
			                                        </td>
			                                        <td >
			                                                		<span class="label label-purple mousechange" title="Previous month" style="width:30px;">#item.timePrev#</span>
			                                                		<span class="label label-info mousechange" title="This month" style="width:30px;">#item.timeNow#</span>
			                                                	
			                                                	<!--- <dl class="dl-horizontal">
							
																	<dt>ss</dt><dd>ssss</dd>
																</dl> --->
			                                                	<!--- <div><small>Current</small> <span>: #item.timeNow#</span></div>
				                                                <div><small>Last&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</small> <span>: #item.timePrev#</span></div> --->
			                                                
			                                        </td>
			                                        <td>
	                                                		<span class="label label-danger mousechange" title="New tickets this week" style="width:30px;">#item.ticketNew#</span>
	                                                		<span class="label label-warning mousechange" title="Hours entry in this week" style="width:30px;">#item.timeNew#</span>
	                                                	
			                                        </td>
			                                        <td class="project-people">
			                                        	<!--- <a href="/index.cfm/user?id=#item.userID#"><img style="width:40px; height:40px;" alt="image" class="img-circle" <cfif item.avatar EQ "">src="/fileupload/avatars/full-logo.jpg"<cfelse>src="/fileupload/avatars/#item.avatar#"></cfif>></a> --->
			                                        	<cfset d = 1>
			                                        	<cfloop array=#item.users# index="user">
			                                            	<a href="/index.cfm/user?id=#user.userID#"><img style="width:32px; height:32px;" alt="image" title="#user.name#" class="img-circle" <cfif user.avatar EQ "">src="/fileupload/avatars/full-logo.jpg"<cfelse>src="/fileupload/avatars/#user.avatar#"></cfif></a>
			                                            	<cfset d = d + 1>
			                                            	<cfif d EQ 6>
			                                            		<!--- <div><i class="ace-icon glyphicon glyphicon-plus"></i> + </div> --->
			                                            		<cfbreak>
			                                            	</cfif>
			                                        	</cfloop>
			                                        </td>
			                                        
			                                    </tr>
			                                </cfloop>
	                                    </tbody>
	                                </table>
	                            </div>
	                        </div>
	                    </div>
	                </div>
	            </div>
	        </div>
	    <!--- </div> --->
		
	<!--- </div>
</div> --->
</cfoutput>
<script type="text/javascript">
	$(document).ready(function(){
        $('#po').dataTable({
        	'iDisplayLength': 25
        });
    });
    function add()
    {
    	<cfoutput>
    		var baseURL = "/index.cfm/project/form";
    	</cfoutput>
    	window.location = baseURL;
    }
</script>
