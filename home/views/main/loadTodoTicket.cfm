<cfoutput>
	<cfset request.layout = false />

<li>	
	<div class="addTask">
		<a class="addTask-icon"><i class="fa fa-plus"></i></a>
		<input type="text" id="ticketTitle" placeholder="Ticket title" class="col-sm-10 col-xs-9 col-md-10 addTask-input" />
		<a id="mark-doNow" donow="0" class="addTask-icon-right "><i class="bigger-120 ace-icon fa fa-star-o"></i></a>
		<a id="mark-assign" assigned-user="" class="addTask-icon-right btn-openaddTask"><i class="normal-icon ace-icon fa fa-bars blue bigger-130"></i></a>
	</div>	
</li>
<cfif structKeyExists(rc,'message')>
	<div class="alert alert-warning">#rc.message#</div>
<cfelse>
	<cfloop query=#rc.listTicket#>
		<cfset haveLog = false >
		<cfif (rc.listTicket.statusID eq 1 OR rc.listTicket.statusID eq 2)>
			<cfset status = 'status-open'>
		<cfelse>
			<cfset status = 'status-progress'>
		</cfif>
		<!--- get stracker info  --->
		<cfif rc.listTicket.isLogStart eq 1>
			<cfquery name="getTracker" >
				SELECT * FROM logworktracker
				WHERE ticketID = #rc.listTicket.ticketID# AND isFinish != 1
				LIMIT 1
			</cfquery>
			<cfif getTracker.recordCount eq 0>
				<cfquery name="updateTicket" >
					Update tickets SET isLogStart = 0
					WHERE ticketID = #rc.listTicket.ticketID# 
				</cfquery>
			<cfelse>
				<cfset haveLog = true >
			</cfif>
			<cfset worked = {
				hours : getTracker.totalWorked gt 0 ? int(getTracker.totalWorked / 60) : 0,
				minute: getTracker.totalWorked gt 0 ? int(getTracker.totalWorked mod 60) : 0
			}>
			<cfset paused = {
				hours : getTracker.totalPause gt 0 ? int(getTracker.totalPause / 60) : 0,
				minute: getTracker.totalPause gt 0 ? int(getTracker.totalPause mod 60) : 0
			}>
			<cfset sWorked = (worked.hours lt 10 ? '0'&worked.hours:worked.hours)&':'&(worked.minute lt 10 ? '0'&worked.minute:worked.minute) >
			<cfset sPaused = (paused.hours lt 10 ? '0'&paused.hours:paused.hours)&':'&(paused.minute lt 10 ? '0'&paused.minute:paused.minute) >
		</cfif>

		<li class="dd-item dd2-item #status# ticket-row" data-id="#rc.listTicket.ticketID#">
			<div class="dd-handle dd2-handle" data-toggle="dropdown" title="More action...">
				<i class="normal-icon ace-icon fa fa-bars blue bigger-130"></i>

				<i class="drag-icon ace-icon fa fa-arrows bigger-125"></i>
			</div>
			<div class="dd2-content">
				<a href="/index.cfm/ticket/?id=#rc.listTicket.code#">
					<span class="#rc.listTicket.color#"> #rc.listTicket.code# </span>
					<span> #rc.listTicket.title# </span>
				</a>
				<cfset active = haveLog ? 'active': ''>
				<div class="loadingIcon pull-right hide">
					<i class="ace-icon fa fa-spinner fa-spin orange bigger-125"></i>
				</div>
				<cfif rc.listTicket.logged gt 0>
					<label style="margin: 0px;">(logged : #int(rc.listTicket.logged/60)#h #rc.listTicket.logged mod 60#')</label>
				</cfif>
				<cfscript>
						var ticketapi = new api.ticket();		
						rc.getLabelChangeStatus = ticketapi.getLabelChangeStatus(rc.listTicket.ticketID);
				</cfscript>
				<div class="pull-right action-buttons #active#">
					<cfif (rc.listTicket.statusID eq 1 OR rc.listTicket.statusID eq 2)>
							<cfset local.lblStatus = rc.getLabelChangeStatus[1] >
							<a data-rel="tooltip" data-placement="left" title="Change Status to In Progress" class="pink tooltip-info change-status btn-action" data-id='#rc.listTicket.ticketID#' data-old-status-id='#rc.listTicket.statusID#' data-new-status-id='#local.lblStatus.id#' data-old-resolution-name='#rc.listTicket.solutionName#' data-new-resolution-id='#local.lblStatus.resolutionID#' data-isStart="true" >
								<i class="bigger-120 ace-icon fa fa-forward"></i>
							</a>
					<cfelseif rc.listTicket.statusID eq 4>
						<cfif haveLog >
							<cfif getTracker.isPause eq 1 >
								<a data-rel="tooltip" class="blue tooltip-info btn-action" onClick="startTrack('#rc.listTicket.ticketID#')"  title="Restart Working...">
									<span class="realTime">#sWorked#</span> <i class="ace-icon fa fa-play bigger-130"></i>
								</a>
							<cfelse>
								<a data-rel="tooltip" class="green tooltip-info btn-action" onClick="stopTracker('#getTracker.trackerID#')" title="Stop and insert time entry">
									<span class="realTime">#sWorked#</span> <i class="ace-icon fa fa-pause bigger-130"></i>
								</a>
							</cfif>
						<cfelse>
							<a data-rel="tooltip" class="blue tooltip-info btn-action" onClick="startTrack('#rc.listTicket.ticketID#')"  title="Start Working...">
								<i class="ace-icon fa fa-play bigger-130"></i>
							</a>
							<cfset local.lblStatus = rc.getLabelChangeStatus[1] >
							<a data-rel="tooltip"  data-placement="right" title="Stop tracker and change Status to Resolved" class="red tooltip-info change-status btn-action" data-id='#rc.listTicket.ticketID#' data-old-status-id='#rc.listTicket.statusID#' data-new-status-id='#local.lblStatus.id#' data-old-resolution-name='#rc.listTicket.solutionName#' data-new-resolution-id='#local.lblStatus.resolutionID#' >
								<i class="ace-icon fa fa-check bigger-130"></i>
							</a>
						</cfif>
					</cfif>
				</div>
				<div class="pull-right ticket-donow">
					<cfif rc.listTicket.isInDay eq true>
						<i class="bigger-120 ace-icon fa fa-star red"></i>
					<cfelse>
						<i class="bigger-120 ace-icon fa fa-star-o"></i>
					</cfif>
				</div>
			</div>
			<cfif not haveLog >

			<ul class="user-menu dropdown-menu dropdown-success">

				<li class="dropdown-hover">
					<a  tabindex="-1" class="clearfix">
						<i class="ace-icon glyphicon glyphicon-refresh"></i>
						Change status
						<i class="ace-icon fa fa-caret-right pull-right"></i>
					</a>
					<ul class="dropdown-menu dropdown-success dropdown-menu-left">
						<cfloop array=#rc.getLabelChangeStatus# index="istatus">
							<li>
								<a  class="change-status" data-id='#rc.listTicket.ticketID#' data-old-status-id='#rc.listTicket.statusID#' data-new-status-id='#istatus.id#' data-old-resolution-name='#rc.listTicket.solutionName#' data-new-resolution-id='#istatus.resolutionID#'>#istatus.lbl#</a>
							</li>
						</cfloop>
					</ul>
				</li>
				<li class="dropdown-hover">
					<a  tabindex="-1" class="clearfix">
						<i class="ace-icon fa fa-user"></i>
						Change assignee
						<i class="ace-icon fa fa-caret-right pull-right"></i>
					</a>					
					<ul class="dropdown-menu dropdown-success dropdown-menu-left">
						<cfloop query="rc.listProjectUsers">
							<cfif rc.listProjectUsers.userID neq rc.listTicket.assignedUserID>
							
							<li >
								<a  class="change-assignee" data-id='#rc.listTicket.ticketID#' data-new-user-id='#rc.listProjectUsers.userID#' >
									<img style="width:32px; height:32px;" class="img-circle" src="/fileupload/avatars/#rc.listProjectUsers.avatar#"/>
									#rc.listProjectUsers.fullname#
								</a>
							</li>							
							</cfif>
						</cfloop>
					</ul>
				</li>
			</ul>				
			</cfif>
		</li>
	</cfloop>
	
</cfif>

	<!--- if have ticket resolved today --->
<cfif rc.listTicketResolved.recordCount neq 0>
	<div class="space"></div>
	<div class="space"></div>
	<div class="space"></div>
	<div class="space"></div>
	<div class="space"></div>

	<!--- Show all ticket resolved in the day --->
		<div class="dd2-content lighter green">
			<!--- Open dd2 content --->
			<span><strong>Ticket resolved:</strong></span>
			
			<div class="space"></div>
		<cfloop query="rc.listTicketResolved" >
			<li class="dd-item dd2-item status-resolved " data-id="#rc.listTicketResolved.ticketID#">
				<div class="dd-handle dd2-handle" data-toggle="dropdown" title="More action...">
					<i class="normal-icon ace-icon fa fa-bars blue bigger-130"></i>

					<i class="drag-icon ace-icon fa fa-arrows bigger-125"></i>
				</div>
				<div class="dd2-content">
					<a href="/index.cfm/ticket/?id=#rc.listTicketResolved.code#">
						<span class="#rc.listTicketResolved.color#"> #rc.listTicketResolved.code# </span>
						<span> #rc.listTicketResolved.title# </span>
					</a>
					<div class="loadingIcon pull-right hide">
						<i class="ace-icon fa fa-spinner fa-spin orange bigger-125"></i>
					</div>
					<cfif rc.listTicketResolved.logged gt 0>
						<label style="margin: 0px;">(logged : #int(rc.listTicketResolved.logged/60)#h #rc.listTicketResolved.logged mod 60#')</label>
					</cfif>
					<cfscript>
							var ticketapi = new api.ticket();		
							rc.getLabelChangeStatus = ticketapi.getLabelChangeStatus(rc.listTicketResolved.ticketID);
					</cfscript>
					<div class="pull-right action-buttons active">
						<a data-rel="tooltip" class="green tooltip-info"  title="Ticket has been Resolved.">
							<i class="ace-icon fa fa-check bigger-130"></i>
						</a>
					</div>
				</div>
				<ul class="user-menu dropdown-menu dropdown-success">
					<li class="dropdown-hover">
						<a  tabindex="-1" class="clearfix">
							<i class="ace-icon glyphicon glyphicon-refresh"></i>
							Change status
							<i class="ace-icon fa fa-caret-right pull-right"></i>
						</a>
						<ul class="dropdown-menu dropdown-success dropdown-menu-left">
							<cfloop array=#rc.getLabelChangeStatus# index="istatus">
								<li>
									<a  class="change-status" data-id='#rc.listTicketResolved.ticketID#' data-old-status-id='#rc.listTicketResolved.statusID#' data-new-status-id='#istatus.id#' data-old-resolution-name='#rc.listTicketResolved.solutionName#' data-new-resolution-id='#istatus.resolutionID#'>#istatus.lbl#</a>
								</li>
							</cfloop>
						</ul>
					</li>
					<li class="dropdown-hover">
						<a  tabindex="-1" class="clearfix">
							<i class="ace-icon fa fa-user"></i>
							Change assignee
							<i class="ace-icon fa fa-caret-right pull-right"></i>
						</a>					
						<ul class="dropdown-menu dropdown-success dropdown-menu-left">
							<cfloop query="rc.listProjectUsers">
								<cfif rc.listProjectUsers.userID neq rc.listTicketResolved.assignedUserID>
								
								<li >
									<a  class="change-assignee" data-id='#rc.listTicketResolved.ticketID#' data-new-user-id='#rc.listProjectUsers.userID#' >
										<img style="width:32px; height:32px;" class="img-circle" src="/fileupload/avatars/#rc.listProjectUsers.avatar#"/>
										#rc.listProjectUsers.fullname#
									</a>
								</li>							
								</cfif>
							</cfloop>
						</ul>
					</li>
				</ul>
			</li>
		</cfloop>

		</div>
		<!--- Close div content dd2 --->
</cfif>	
<div>
</div>
<div id="addTask-popover" class="addTask-popover">
	<div class="arrow" style="left: 113px; margin-left: 48px;"></div>
	<div>
		<div class="assign-to-user"> 
			<div class="popover-header">
				<text rel="label_assign_to">Assign to</text>
			</div> 
				<ul class="popover-lstUsers">
					<cfloop query="rc.listProjectUsers">
						<cfif rc.listProjectUsers.userID neq rc.listTicket.assignedUserID>
							<li >
								<a  class="mark-assignee" data-id='#rc.listTicket.ticketID#' data-new-user-id='#rc.listProjectUsers.userID#' >
									<img style="width:32px; height:32px; margin-right:10px;margin-left:10px;" class="img-circle" src="http://www.ticket.rasia.systems/fileupload/avatars/#rc.listProjectUsers.avatar#"/>
									#rc.listProjectUsers.fullname#
								</a>
							</li>							
						</cfif>
					</cfloop>
				</ul>
			</div>
		</div>
	</div>
</div>
<div id="addTask-popover-229" class="addTask-popover">
	<div class="arrow" style="left: -40px; margin-left: 48px;"></div>
	<div>
		<div class="assign-to-user"> 
			<div class="popover-header">
				<text rel="label_assign_to">Assign to</text>
			</div> 
				<ul id="list-user-229" class="popover-lstUsers">
					<cfloop query="rc.listProjectUsers">
						<cfif rc.listProjectUsers.userID neq rc.listTicket.assignedUserID>
							<li>
								<a  class="mark-assignee-229" data-id='#rc.listTicket.ticketID#' data-new-user-id='#rc.listProjectUsers.userID#' >
									<img style="width:32px; height:32px; margin-right:10px;margin-left:10px;" class="img-circle" src="http://www.ticket.rasia.systems/fileupload/avatars/#rc.listProjectUsers.avatar#"/>
									#rc.listProjectUsers.fullname#
								</a>
							</li>							
						</cfif>
					</cfloop>
				</ul>
			</div>
		</div>
	</div>
</div>
</cfoutput>
