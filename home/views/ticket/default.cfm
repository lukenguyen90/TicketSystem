<style type="text/css">
.del-ticket{
	position: absolute;
	top: 0;
	right: 0px;
	cursor: pointer;
	display: none;
}
.entry-row{
	position: relative;
}
.entry-row:hover .del-ticket{
	display: block;
}
</style>
<cfif not rc.flag>
<div class="nTicket">
	<cfif rc.useNotTicketCss >
	<div class="content-container text-align-center">
		<h1>Woof Woof ....!</h1>
		<h2 class="small-quote">Permission error</h2>
		<h3>Sorry, our dog doesn't allow you view this ticket !!!</h3>
		<cfoutput>
			<img class="e-logo" src="http://#CGI.HTTP_HOST#/images/gallery/small-logo.png">
		</cfoutput>
	</div>
	<cfelse>
		<div class="content-container text-align-center">
			<h1>404 Error</h1>
			<h2 class="small-quote">Ticket not found</h2>
			<h3>Sorry, the dog ate the ticket, so it doesn't exist anymore !!!</h3>
			<cfoutput>
				<img class="logo" src="http://#CGI.HTTP_HOST#/images/gallery/small-logo.png">
			</cfoutput>
		</div>
	</cfif>
</div>
<cfelse>
<cfoutput>
	<cfset localTicketInfo = rc.ticketinfo>
	<cfset listProjectUsers = rc.listProjectUsers>
	<cfset totalTime = rc.totalTime>
	<cfset arrayTicketFiles = rc.listTicketFiles>
	<cfset listTicketStatuses = rc.listTicketStatuses>
	<cfset listResolution = rc.listResolution >
	<cfset arrayPriorityColor = [1]>
	<cfset listResolution = rc.listResolution>
	<cfset point = localTicketInfo.point eq '' ? 0 : localTicketInfo.point >
	<cfset estimate = point/2>
	<!--- Value accept insert time entry --->
	<cfset value1 = 4>  <!--- ID status : "In progress" --->
	<cfset value2 = 5>  <!--- ID status : "Resolve" ---> 
	<!--- Value accept insert resolution --->
	<cfset accept1 = 5>  <!--- ID status : "Resolve" --->
	<cfset accept2 = 6>  <!--- ID status : "Closed" --->
	<cfscript>
		switch(localTicketInfo.statusID){
			case 1 :
			case 2 :
				local.lblStatus = [
					{
						lbl : 'In progress',
						name : 'In progress',
						id : 4,
						resolutionName: 'Unresolved',
						resolutionID: 0,
						comment:'Start to work!'
					},
					{
						lbl : 'Resolved-Will not fix',
						name : 'Resolved',
						id : 5,
						resolutionName: 'Will not fix',
						resolutionID: 2,
						comment:'Will not fix!'
					},
					{
						lbl : 'Resolved-Duplicate',
						name : 'Resolved',
						id : 5,
						resolutionName: 'Duplicate',
						resolutionID: 3,
						comment:'This ticket is Duplicate !'
					},
					{
						lbl : 'Resolved-Cannot Reproduce',
						name : 'Resolved',
						id : 5,
						resolutionName: 'Cannot Reproduce',
						resolutionID: 5,
						comment:'I can`t do it'
					}
				];
			break;
			case 4:
				local.lblStatus = [
					{
						lbl : 'Resolved-Fixed',
						name : 'Resolved',
						id : 5,
						resolutionName: 'Fixed',
						resolutionID: 1,
						comment:'Wait for test!'
					},
					{
						lbl : 'Resolved-Will not fix',
						name : 'Resolved',
						id : 5,
						resolutionName: 'Will not fix',
						resolutionID: 2,
						comment:'Will not fix!'
					},
					{
						lbl : 'Resolved-Duplicate',
						name : 'Resolved',
						id : 5,
						resolutionName: 'Duplicate',
						resolutionID: 3,
						comment:'This ticket is Duplicate !'
					},
					{
						lbl : 'Resolved-Incomplete',
						name : 'Resolved',
						id : 5,
						resolutionName: 'Incomplete',
						resolutionID: 4,
						comment:'will do it later!'
					},
					{
						lbl : 'Resolved-Cannot Reproduce',
						name : 'Resolved',
						id : 5,
						resolutionName: 'Cannot Reproduce',
						resolutionID: 5,
						comment:'I can`t do it'
					}
				];
			break;
			case 5:
				local.lblStatus = [
					{
						lbl : 'Reopened',
						name : 'Reopened',
						id : 2,
						resolutionName: 'Unresolved',
						resolutionID: 0,
						comment:'I want to do it again!'
					}
				];
				if( (localTicketInfo.testerUserID eq ""?0:localTicketInfo.testerUserID) eq SESSION.userID OR SESSION.userType eq 3  OR localTicketInfo.reportedByUserID eq SESSION.userID){
					arrayAppend(local.lblStatus, {
						lbl : 'Closed',
						name : 'Closed',
						id : 6,
						resolutionName: localTicketInfo.solutionName,
						resolutionID: localTicketInfo.solutionID,
						comment:'Done!'
					});
				}
			break;
		}
	</cfscript>
	<cfparam name="localTicketInfo.solutionName" default="Unresolved!">
	<script type="text/javascript">
		var ticketID = #localTicketInfo.ticketID#;
		var oldAssigneeID = #localTicketInfo.assignedUserID#;
		var reporterID = #localTicketInfo.reportedByUserID# ;
		var testerID = #localTicketInfo.testerUserID eq ""?0:localTicketInfo.testerUserID#;
		projectLeaderID = #localTicketInfo.leadProject# ;
		var oldAssigneeName = "#localTicketInfo.assignfullname#";
		var userIDSS = #SESSION.userID#;
		var typeUser = #SESSION.userType#;
		<cfif len(localTicketInfo.solutionID) gt 0>
			var oldResolutionID = #localTicketInfo.solutionID#;
			var oldResolutionName = "#localTicketInfo.solutionName#";
		<cfelse>
			var oldResolutionID = 0;
			var oldResolutionName="#localTicketInfo.solutionName#";
		</cfif>
		var resolutionID = oldResolutionID;
		var resolutionName = oldResolutionName;
		var oldStatusID = #localTicketInfo.statusID#;
		var oldStatusName = "#localTicketInfo.statusName#";
		// set default data for change status
		var newStatusName = '';
		var newStatusID = 0;
		var newResolutionName = '';
		var newResolutionID = 0;
		var newInternal = 1 ;
		var newCmt = '';
		// set default data for change assignee
		var newAssigneeID = 0;
		var newAssigneeName = '';
		// end
		var oldStatusColor = "#localTicketInfo.sta_color#";
		var idAccept1 = "5";
		var idAccept2 = "6";
		var estimate = #estimate# ;
	</script>
	<style type="text/css">
		.dl-horizontal dt{
			width: 100px;
		}
		.dl-horizontal dd{
			margin-left: 110px !important;
		}
		abbr{
			border-bottom: .2em dotted ##99F !important;
		}
		.image-name{
			overflow: hidden;
		}
	</style>
	<div class="row">
		<div class="col-md-12">
			<div class="row clearfix">
				<div class="col-md-12" >
					<em class="bigger-150 lighter">
						<a href="/index.cfm/project/?pId=#localTicketInfo.projectID#">
							#localTicketInfo.projectName#
						</a>
					</em> 
					<span class="bigger-150">/</span> 
					<span class="widget-title bigger-200 blue lighter">
						<span class="green">
							#localTicketInfo.code#
						</span> 
						&nbsp;
							<span class="green">	#localTicketInfo.title#</span>
					</span> 
				</div>
			</div>
			<div class="hr hr2 dotted light-blue"></div>
			<div class="row clearfix">
				<div class='col-md-12'>
					<div class="btn-group">
						<a class="btn btn-xs" href="/index.cfm/ticket/edit?id=#localTicketInfo.code#" title="Click to edit ticket">
							<i class="ace-icon fa fa-pencil-square-o  bigger-110 icon-on-right"></i> Edit
						</a>
					</div>
					<div class="btn-group">
						<a class="btn btn-xs" href="##myModalUploadFiles" title="Click to Upload files" data-toggle="modal" data-target='##myModalUploadFiles' id="btnUploadFile">
							<i class="ace-icon fa fa-cloud-upload bigger-110 icon-on-right"></i> Upload
							<cfinclude template="upload.cfm"/>
							<input id="ListFileUpload" type="hidden" name="ListFileUpload" value="">
						</a>
					</div>
					<cfif SESSION.userType gt 1 OR (SESSION.userType eq 1 AND localTicketInfo.statusID eq 5) >
						<cfif localTicketInfo.isLogStart eq 1>
							<span>Log tracker running .....</span>
						<cfelse>
							<cfif isDefined('local.lblStatus')>
								<div class="btn-group">
									<a class="btn btn-xs dropdown-toggle" data-toggle="dropdown" title="Click to change status">
										<i class="ace-icon fa fa-flash  bigger-110"></i> Change Status
									</a>
									<ul class="dropdown-menu dropdown-success dropdown-menu-left">
										<cfloop array=#local.lblStatus# index="istatus">
											<li>
												<a class="change-status" data-new-status-id='#istatus.id#' data-new-status-name='#istatus.name#' data-resolution-id='#istatus.resolutionID#' data-resolution-name='#istatus.resolutionName#' data-cmt='#istatus.comment#'>#istatus.lbl#</a>
											</li>
										</cfloop>
									</ul>
								</div>
							</cfif>
							<cfif localTicketInfo.statusName neq "Closed">
								<div class="btn-group">
									<a class="btn btn-xs dropdown-toggle" data-toggle="dropdown" title="Click to change Assignee">
										<i class="ace-icon fa fa-user-plus  bigger-110"></i> Assignee
									</a>
									<ul class="dropdown-menu dropdown-success dropdown-menu-left">
										<cfloop query="listProjectUsers">
											<cfif listProjectUsers.userID neq localTicketInfo.assignedUserID>
											<li>
												<a class="change-assignee" data-new-user-id='#listProjectUsers.userID#' data-new-user-name='#listProjectUsers.fullname#'>
													<img style="width:32px; height:32px;" class="img-circle" src="/fileupload/avatars/#listProjectUsers.avatar#"/>
													#listProjectUsers.fullname#
												</a>
											</li>
											</cfif>
										</cfloop>
									</ul>
								</div>
								<!--- <div class="btn-group">
									<a class="btn btn-xs" title="Click to change Tester">
										Tester
									</a>
								</div> --->
							</cfif>
						</cfif>
					<cfelseif SESSION.userType eq 1 AND (localTicketInfo.statusID eq 1 OR localTicketInfo.statusID eq 1) AND localTicketInfo.reportedByUserID eq SESSION.userID>
						<div class="btn-group">
							<a class="btn btn-xs dropdown-toggle" data-toggle="dropdown" title="Click to change status">
								<i class="ace-icon fa fa-flash  bigger-110"></i> Change Status
							</a>
							<ul class="dropdown-menu dropdown-success dropdown-menu-left">
								<li>
									<a class="change-status" data-new-status-id='6' data-new-status-name='Closed' data-resolution-id='2' data-resolution-name='Will not fix' data-cmt='Not needed'>Closed</a>
								</li>
							</ul>
						</div>
					</cfif>
				</div>
			</div>
			<div class="hr hr2 dotted light-blue"></div>
			<div class="row  margin-top-20">
				<div class="col-md-7">
					<div class="row">
						<div class ="grouptitle"><span class="bigger-150 grouptext"><i class="ace-icon fa fa-th"></i><strong> #getLabel("Detail", #SESSION.languageId#)#&nbsp;</strong></span></div>
					</div>

					<div class="row margin-top-20">
						<div class="col-md-4">
							<dl class="dl-horizontal">
								<dt>#getLabel("Ticket Type", #SESSION.languageId#)#:</dt><dd>#localTicketInfo.typeName#</dd>
		    					<dt>#getLabel("Version", #SESSION.languageId#)#:</dt><dd>#localTicketInfo.versionTicket#</dd>
		    					<dt>#getLabel("Point", #SESSION.languageId#)#:</dt>
								<dd>#point neq 0?point:'Unestimated'#</dd>
							</dl>
						</div>
						
						<div class="col-md-4">
							<dl class="dl-horizontal">
								<dt>#getLabel("Priority", #SESSION.languageId#)#:</dt><dd style="color:#localTicketInfo.pri_color#" class="bigger-110">#localTicketInfo.priorityName#</dd>
								<dt>#getLabel("Module", #SESSION.languageId#)#:</dt><dd>#localTicketInfo.moduleName#</dd>
								<dt>#getLabel("Epic", #SESSION.languageId#)#:</dt><dd><span class="epic epic-#localTicketInfo.epicColor#">#localTicketInfo.epicName eq ''?'none':localTicketInfo.epicName#</span></dd>
							</dl>
						</div>
						<div class="col-md-4">
							<dl class="dl-horizontal">
		    					<dt>#getLabel("Status", #SESSION.languageId#)#:</dt>
		    					<dd id="dd_status">
		    						<span class=" btn-xs btn-round btn-#localTicketInfo.sta_color#" >#getLabel("#localTicketInfo.statusName#", #SESSION.languageId#)#</span>
								</dd>
		    					
	    						<dt>#getLabel("Resolution", #SESSION.languageId#)#:</dt>
	    						<dd>
	    							<span id="lb_solution">#getLabel("#localTicketInfo.solutionName#", #SESSION.languageId#)#</span>
	    						</dd>
		    						    					
							</dl>
						</div>
					</div>

					<div class="row margin-top-20">
						<div class ="grouptitle"><span class="bigger-150 grouptext"><i class="ace-icon fa fa-lightbulb-o"></i><strong> #getLabel("Description", #SESSION.languageId#)#&nbsp;</strong></span></div>
					</div>
						
					<div class="row margin-top-20">
						#localTicketInfo.description#
					</div>
					

					<div class="row margin-top-20">
						<div class ="grouptitle">
							<span class="bigger-150 grouptext"><i class="ace-icon fa fa-cloud-download"></i><strong> #getLabel("Attachments", #SESSION.languageId#)#&nbsp;</strong></span>
						</div>
					</div>
					<div class="col-md-12 margin-top-20">
						<div class="row showattachment"> 
						<cfloop query=#arrayTicketFiles#>
							<cfscript>
								var fileNameSplit=listToArray(arrayTicketFiles.fileLocation, '/');
								var name = fileNameSplit[arrayLen(fileNameSplit)];
							</cfscript>
							<cfif #arrayTicketFiles.group# EQ 'Text'>
								<a href="#arrayTicketFiles.fileLocation#" target="_blank" >
								<div class="col-md-3 row file-attachment">
									<div class="col-md-12 icon-attachment thumbnail">
										<img src="/images/icon/text.png" alt="#name#" class="image-attachment" title="#name#">
									</div>
									<div class="col-md-12 image-name" title="#name#">
										#name#
									</div>
								</div> 
								</a>
							<cfelseif #arrayTicketFiles.group# EQ 'Pdf'>
								<a href="#arrayTicketFiles.fileLocation#" target="_blank" >
								<div class="col-md-3 row file-attachment">
									<div class="col-md-12 icon-attachment thumbnail">
										<img src="/images/icon/pdf.png" alt="#name#" class="image-attachment" title="#name#">
									</div>
									<div class="col-md-12 image-name" title="#name#">
										#name#
									</div>
								</div> 
								</a>
							<cfelseif #arrayTicketFiles.group# EQ 'Excel'>
								<a href="#arrayTicketFiles.fileLocation#" target="_blank" >
								<div class="col-md-3 row file-attachment">
									<div class="col-md-12 icon-attachment thumbnail">
										<img src="/images/icon/excel.png" alt="#name#" class="image-attachment" title="#name#">
									</div>
									<div class="col-md-12 image-name" title="#name#">
										#name#
									</div>
								</div> 
								</a>
							<cfelseif #arrayTicketFiles.group# EQ 'Document'>
								<a href="#arrayTicketFiles.fileLocation#" target="_blank" >
								<div class="col-md-3 row file-attachment">
									<div class="col-md-12 icon-attachment thumbnail">
										<img src="/images/icon/word.png" alt="#name#" class="image-attachment" title="#name#">
									</div>
									<div class="col-md-12 image-name" title="#name#">
										#name#
									</div>
								</div> 
								</a>
							<cfelseif #arrayTicketFiles.group# EQ 'Powerpoint'>
								<a href="#arrayTicketFiles.fileLocation#" target="_blank" >
								<div class="col-md-3 row file-attachment">
									<div class="col-md-12 icon-attachment thumbnail">
										<img src="/images/icon/powerpoint.png" alt="#name#" class="image-attachment" title="#name#">
									</div>
									<div class="col-md-12 image-name" title="#name#">
										#name#
									</div>
								</div> 
								</a>
							<cfelseif #arrayTicketFiles.group# EQ 'Other'>
								<a href="#arrayTicketFiles.fileLocation#" target="_blank" >
								<div class="col-md-3 row file-attachment">
									<div class="col-md-12 icon-attachment thumbnail">
										<img src="/images/icon/other.png" alt="#name#" class="image-attachment" title="#name#">
									</div>
									<div class="col-md-12 image-name" title="#name#">
										#name#
									</div>
								</div> 
								</a>
							<cfelseif #arrayTicketFiles.group# EQ 'Image'>
								<script type="text/javascript">
									$(document).ready(function(){
										var fileLocation = '#arrayTicketFiles.fileLocation#';
										var thumb_name = fileLocation.slice(fileLocation.lastIndexOf('/'));
										var thumb_direction = fileLocation.substring(fileLocation.indexOf('/'), fileLocation.lastIndexOf('/'))
										$('.showattachment').append('<a href="'+fileLocation+'" target="_blank" ><div class="col-md-3 row file-attachment"><div class="col-md-12 icon-attachment thumbnail"><img src="'+thumb_direction+"/thumbnails"+thumb_name+'" class="image-attachment" title="#name#"/></div><div class="col-md-12 image-name" title="#name#">#name#</div></div></a>');
									})
								</script>
							</cfif>
						</cfloop>
						</div>
					</div>

					<div class="row margin-top-20">
						<div class ="grouptitle">
							<span class="bigger-150 grouptext"><i class="ace-icon fa fa-cutlery"></i><strong> #getLabel("Actions", #SESSION.languageId#)#&nbsp;</strong></span>
							<span class="grouptext pull-right">#getLabel("Total Time", #SESSION.languageId#)#:  <label id="lbtotalTime">#int(totalTime/60)#h&nbsp;#int(totalTime mod 60)#'</label></span>
						</div>
					</div>
					
					<div class="row margin-top-20">
						<div class="tabbable">
							<ul class="nav nav-tabs" id="myTab">
								<li id="dTimeEntries">
									<a data-toggle="tab" href="##ticketTimeEntries"><i class="green ace-icon fa fa-clock-o  bigger-120"></i> #getLabel("Time Entries", #SESSION.languageId#)#</a>
								</li>
								<li id="dComment" class="active">
									<a data-toggle="tab" href="##ticketComments"><i class="ace-icon fa fa-comments bigger-110"></i> #getLabel("Comments", #SESSION.languageId#)#</a>
								</li>
							</ul>
							<div class="tab-content" style="max-height:500px; overflow: auto;">
								<div id="ticketTimeEntries" class="tab-pane" >

									<div class="row col-md-12 center">
										<p class="col-md-2">#getLabel("Date", #SESSION.languageId#)#</p><p class="col-md-2">#getLabel("User", #SESSION.languageId#)# </p><p class="col-md-1">#getLabel("Hours", #SESSION.languageId#)#</p><p class="col-md-1">#getLabel("Minute", #SESSION.languageId#)#</p><p class="col-md-6">#getLabel("Description", #SESSION.languageId#)#</p><!--- <p class="col-md-1"></p> --->
									</div>
									<!--- SESSION.userType eq 3 and --->
									<cfif (localTicketInfo.statusID eq value1 or localTicketInfo.statusID eq value2) and localTicketInfo.statusName neq "Closed" >
									<div class="row col-sm-12" id="timeEntry" style="clear:both;">

										<input name="fentryDate" id="fentryDate" class="col-sm-2" type="text" onkeypress="enter(event)" data-date-format="yyyy-mm-dd" value="#DateTimeFormat(Now(),"yyyy-mm-dd")#" style="height:30px;">

										<select name="fuser" id="fuser" onkeypress="enter(event)" class="col-sm-2" style="height:30px;">
											<cfloop query="listProjectUsers">
												<cfif SESSION.userType eq 3>
												<option value="#listProjectUsers.userID#" id="fuser#listProjectUsers.userID#" <cfif listProjectUsers.userID eq SESSION.userID>selected</cfif> >#listProjectUsers.fullname#</option>
												<cfelse>
													<cfif listProjectUsers.userID eq SESSION.userID>
														<option value="#listProjectUsers.userID#" id="fuser#listProjectUsers.userID#" selected >#listProjectUsers.fullname#</option>
													</cfif>
												</cfif>
											</cfloop>												
										</select>

										<input class="text-right col-sm-1" type="number" name="fHours" id="fHours" min="1" autofocus value="0" onkeypress="enter(event)" style="height:30px;">
										<input class="text-right col-sm-1" type="number" name="fMinute" id="fMinute" min="0" max="59" autofocus value="0" onkeypress="enter(event)" style="height:30px;">
										<input class="col-sm-6" type="text" name="fDescription" id="fDescription" onkeypress="enter(event)" placeholder="Do something..." style="height:30px;">

									</div>
									</cfif>
																				
									<div id="contentTicketTimeEntries" class="row col-sm-12"></div>
									<div class="row col-xs-12">
										<a style="cursor:pointer" id='aLoadMoreTE'>#getLabel("Load more", #SESSION.languageId#)#</a>
									</div>
									
									<div style="clear:left;"></div>
								</div>
								<div id="ticketComments" class="tab-pane fade in active"  >
									<div class="row">
										<div class="col-md-12">
											<!--- <div id="formComment"></div> --->
											<div id="editor" class="wysiwyg-editor" style="height:70px;" onKeypress='enterComment(event)'></div>
											<input type="hidden" name="formComment" id='formComment'value=" "/>		
											<cfif SESSION.userType NEQ 1>
												<label class="middle">
													<input class="ace" type="checkbox" checked id="internal" name="internal">
													<span class="lbl"> Internal</span>
												</label>
											</cfif>
											<span class="pull-right"><i>Click <span class="green">#getLabel("Post comment", #SESSION.languageId#)#</span> button or <span class="red">ctrl</span>+<span class="red">enter</span> to Post comment</i></span>
											
										</div>
										<div class="col-md-2">
											<button class="btn btn-sm btn-info" id="btn-add-cmt">#getLabel("Post comment", #SESSION.languageId#)#</button></div>
										</div>
									<div id="vTicketComments" class="margin-top-10"></div>
									<div class="row col-xs-12">
										<a style="cursor:pointer" id='aLoadMoreCMT'>#getLabel("Load more", #SESSION.languageId#)#</a>
									</div>				
								</div>
							</div>
						</div>
					</div>

				</div>
				<div class="col-md-4 col-md-offset-1">
					<div class="row">
						<div class ="grouptitle">
							<span class="bigger-150 grouptext"><i class="ace-icon fa fa-users"></i><strong> #getLabel("People", #SESSION.languageId#)#&nbsp;</strong></span>
						</div>
					</div>

					<div class="row margin-top-20">
						<dl class="dl-horizontal">
							<dt>#getLabel("Assignee", #SESSION.languageId#)#:</dt><dd>
							<label style="border:none" id="lb_Assignee">
    								#localTicketInfo.assignfullname#
    						</label>&nbsp;
    						
    						</dd>
    						<dd> <!--- <cfif (#localTicketInfo.assignedUserID# NEQ #SESSION.userID#) AND (#localTicketInfo.statusID# EQ 1 OR #localTicketInfo.statusID# EQ 2) AND (#SESSION.userType# NEQ 1)> --->
    						<cfif (#localTicketInfo.assignedUserID# NEQ #SESSION.userID#) AND (#localTicketInfo.statusID# NEQ 6 ) AND (#SESSION.userType# NEQ 1) and localTicketInfo.isLogStart eq 1>
    							<label class=" blue" style="cursor:pointer" onclick="assignToMe()" >#getLabel("Assign to me!", #SESSION.languageId#)#</label>
    						</cfif></dd>
    						<dt>#getLabel("Tester", #SESSION.languageId#)#:</dt><dd>
							<label style="border:none" id="lb_Assignee">
    							<!--- <cfif #SESSION.userType# gt 1 and localTicketInfo.statusName neq "Closed">
    								<label class="btn btn-white btn-info btn-xs btn-round" id="lb_changeTester" data-toggle="modal" >
		    							<span id="lb_tester">#localTicketInfo.testerfullname eq ""? "No tester":localTicketInfo.testerfullname#</span>
		    							<i class="ace-icon fa fa-pencil-square-o  bigger-110 icon-on-right"></i>
		    						</label>
    							<cfelse> --->
    								#localTicketInfo.testerfullname eq ""? "No tester":localTicketInfo.testerfullname#
    							<!--- </cfif> --->
    						</label>&nbsp;
    						
    						</dd>
    						
	    					<dt>#getLabel("Reporter", #SESSION.languageId#)#:</dt><dd>#localTicketInfo.refullname#</dd>
	    					<dt><i class="fa fa-envelope"></i>#getLabel("Cc", #SESSION.languageId#)#:</dt><dd>#localTicketInfo.cc#</dd>
						</dl>
					</div>

					<div class="row margin-top-20">
						<div class ="grouptitle">
							<span class="bigger-150 grouptext"><i class="ace-icon fa fa-bullhorn"></i><strong> #getLabel("Date", #SESSION.languageId#)#&nbsp;</strong></span>
						</div>
					</div>

					<div class="row margin-top-20">
						<dl class="dl-horizontal">
							<dt>#getLabel("Due Date", #SESSION.languageId#)#:</dt><dd>#DateFormat(localTicketInfo.dueDate,"yyyy-mm-dd")#</dd>
	    					<dt>#getLabel("Reported Date", #SESSION.languageId#)#:</dt><dd>#DateFormat(localTicketInfo.reportDate,"yyyy-mm-dd")#</dd>
						</dl>
					</div>
					
					<div class="row margin-top-20">
						<div class ="grouptitle"><span class="bigger-150 grouptext"><i class="ace-icon fa fa-clock-o"></i><strong> #getLabel("Time Tracking", #SESSION.languageId#)#&nbsp;</strong></span></div>
					</div>

					<div class="row margin-top-20">
						<div class="col-md-3 ">
							<i class="ace-icon fa fa-caret-right "></i> #getLabel("Estimate", #SESSION.languageId#)#:
						</div>

						<div class="col-md-6 ">
							<div class="progress progress-small progress-striped active">
								<div class="progress-bar progress-bar-info" style="width: #point neq 0?'100':'0'#%"></div>
							</div>
						</div>

						<div class="col-md-3 ">
							<cfif estimate neq 0>
								#int(estimate)#h#int((estimate*60) mod 60)#'
							<cfelse>
								Unestimated	
							</cfif>
						</div>
					</div>

					<div class="row">
						<div class="col-md-3 ">
							<i class="ace-icon fa fa-caret-right "></i> #getLabel("Remaining", #SESSION.languageId#)#:
						</div>
							<cfset LOCAL.remainPercent = point neq 0 ? (100 - (totalTime/(estimate*60))*100) : 0 >
						<div class="col-md-6">
							<div class="progress progress-small progress-striped active">
								<div id="proRemainTime" class="progress-bar progress-bar-success" style="width: #remainPercent#%"></div>
							</div>
						</div>

						<div class="col-md-3">
							<cfif point neq 0>
							<label id="lbProRemainTime">#int((estimate*60 - totalTime)/60)#h#int((estimate*60 - totalTime) mod 60)#'</label>
							</cfif>
						</div>
					</div>
					
					<div class="row">
						<div class="col-md-3">
							<i class="ace-icon fa fa-caret-right "></i> #getLabel("Logged", #SESSION.languageId#)#:
						</div>

						<div class="col-md-6 ">
							<div class="progress progress-small progress-striped active">
								<div id="proLogTime" class="progress-bar progress-bar-purple" style="width: #point neq 0?(totalTime*100/(estimate*60)):'100'#%"></div>
							</div>
						</div>

						<div class="col-md-3 ">
							<label id="lbProLogTime">#int(totalTime/60)#h#int(totalTime mod 60)#'</label>
						</div>
					</div>		
				</div>
			</div>
		</div>
	</div>
	<cfif isDefined("local.lblStatus")>
<!--- 	<div class="modal fade" id="modalChangeStatusNew" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	  	<div class="modal-dialog" style='margin-top: 50px;'>
		    <div class="modal-content alert-info">
		      	<div class="modal-header alert-info">
		        	<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">#getLabel("Close", #SESSION.languageId#)#</span></button>
		        	<h3 class="modal-title">#getLabel("Change Status", #SESSION.languageId#)#</h3>
		      	</div>
		      	<div class="modal-body">					
					<div class="row" id='changeStatusText'>
		            </div>								
					<div class="row margin-top-20">
						<label class="col-md-3 control-label">#getLabel("Comment", #SESSION.languageId#)#</label>
						<div class="col-md-9">
							<textarea id="staCommentNew" name="staComment" class="form-control" placeholder="Your comment!" rows="4"></textarea>
						</div>
					</div>					
		      	</div>
		      	<div class="modal-footer">
		        	<button type="button" class="btn btn-default" data-dismiss="modal">#getLabel("Close", #SESSION.languageId#)#</button>
		        	<button id="btnChangeStatusNew" type="button" class="btn btn-info">#getLabel("Save changes", #SESSION.languageId#)#</button>
		      	</div>
		    </div>
	  	</div>
	</div> --->
	</cfif>
	<!--- <div class="modal fade" id="myModalChangeAssigneeNew" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	  	<div class="modal-dialog">
		    <div class="modal-content alert-info">
		      	<div class="modal-header alert-info">
		        	<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">#getLabel("Close", #SESSION.languageId#)#</span></button>
		        	<h3 class="modal-title" id="myModalLabel">#getLabel("Change Assignee", #SESSION.languageId#)#</h3>
		      	</div>
		      	<div class="modal-body">					
					<div class="row">
			            <label id="changeAssigneeText" class="col-md-12"></label>
		            </div>									
				<!--- 	<div class="row margin-top-20">
						<label class="col-md-3 control-label">#getLabel("Comment", #SESSION.languageId#)#</label>
						<div class="col-md-9">
							<textarea id="assCommentNew" name="assCommentNew" class="form-control" placeholder="Your comment!" rows="4"></textarea>
						</div>
					</div>		 --->			
		      	</div>
		     <!---  	<div class="modal-footer">
		        	<button type="button" class="btn btn-default" data-dismiss="modal">#getLabel("Close", #SESSION.languageId#)#</button>
		        	<button id="btnChangeAssigneeNew" type="button" class="btn btn-info">#getLabel("Save changes", #SESSION.languageId#)#</button>
		      	</div> --->
		    </div>
	  	</div>
	</div> --->
	<!--- modal input file --->
	<div class="modal fade" id="myModalUploadFiles" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">#getLabel("Close", #SESSION.languageId#)#</span></button>
					<h4 class="modal-title" id="myModalLabel">#getLabel("Upload Files", #SESSION.languageId#)#</h4>
				</div>
				<div class="modal-body">
					  <form class="form-horizontal" name="fileupload" id="fileupload" enctype="multipart/form-data" method="post" action="/upload/up.cfc?method=uploadFile&RequestTimeout=3600">
						<div class="row fileupload-buttonbar">
							<div class="span7">
								<span class="btn btn-success fileinput-button">
								<i class="icon-plus icon-white"></i>
								<span>#getLabel("Add files", #SESSION.languageId#)#...</span>
								<input type="file" name="files"  <!--- accept="image/*,text/*,application/pdf,application/msword" ---> multiple>
								</span>
								<button type="submit" class="btn btn-primary start" disabled>
								<i class="icon-upload icon-white"></i>
								<span>#getLabel("Start upload", #SESSION.languageId#)#</span>
								</button>
								<button type="reset" class="btn btn-warning cancel" disabled>
								<i class="icon-ban-circle icon-white"></i>
								<span>#getLabel("Cancel upload", #SESSION.languageId#)#</span>
								</button>
							</div>
						</div>
						<div class="fileupload-loading"></div>
						<br>
						<table id="tblimg" role="presentation" class="table table-striped">
							<tbody class="files" data-toggle="modal-gallery" data-target="##modal-gallery"></tbody>
						</table>
				</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal" onClick='saveFile()'>#getLabel("Save changes", #SESSION.languageId#)#</button>
				</div>
			</div>
		</div>
	</div>
<!--- end modal input file --->

</cfoutput>
<script src="/ACEAdmin/assets/js/bootstrap-wysiwyg.min.js"></script>
<script type="text/javascript">
	var number=0;
	var page=0;
	var firstLoadCmt = true ;
$(document).ready(function(){
		$('#editor').ace_wysiwyg({
			height: 150,
			toolbar:
			[
				
				{
					name:'fontSize',
					title:'Custom tooltip',
					values:{1 : 'Size#1 Text' , 2 : 'Size#1 Text' , 3 : 'Size#3 Text' , 4 : 'Size#4 Text' , 5 : 'Size#5 Text'} 
				},
				null,
				{name:'bold', title:'Custom tooltip'},
				{name:'italic', title:'Custom tooltip'},
				{name:'strikethrough', title:'Custom tooltip'},
				{name:'underline', title:'Custom tooltip'},
				null,
				'insertunorderedlist',
				'insertorderedlist',
				'outdent',
				'indent',
				null,
				
				{
					name:'createLink',
					placeholder:'Custom PlaceHolder Text',
					button_class:'btn-purple',
					button_text:'Custom TEXT'
				},
				{name:'unlink'},
				
				{name:'undo'},
				{name:'redo'},
				null,
				'viewSource'
			],
			//speech_button:false,//hide speech button on chrome
			
			'wysiwyg': {
				hotKeys : {} //disable hotkeys
			}
			
		})
		.prev().addClass('wysiwyg-style2');

	<cfif isDefined("local.lblStatus")>
		$('.change-status').on('click',function(){
			newStatusID = $(this).attr('data-new-status-id');
			newResolutionID = $(this).attr('data-resolution-id');
			// newInternal = $(this).attr('data-internal') ;
			var resolutiontext = newStatusID == 5 ? newResolutionName : '';
		
				// $("#waiting").removeClass('hide');
				$.ajax({
					type: "POST",
					url: "/index.cfm/home:ticket.changeStatus",
					data:{
						idTicket: ticketID,
						oldStatusID:oldStatusID,					
						newStatusID: newStatusID,
						newResolutionID: newResolutionID,
						oldResolutionName: oldResolutionName
					},
					success: function( data ) {
		            	if(data.success){
		            		location.reload();
		            	}else{
							// $("#waiting").addClass('hide');
		            		if(confirm("An Error '"+data.message+"' when update Data! do you want reload this page ?")){
		            			location.reload();
		            		}
		            	}
		            }	
				})
			
		});
		// change assignee
		$('.change-assignee').click(function(){
			newAssigneeID = $(this).attr('data-new-user-id');
			// $("#waiting").removeClass('hide');
			$.ajax({
				type: "POST",
				url: "/index.cfm/home:ticket.changeAssignee",
				data:{
					idTicket: ticketID,
					assigneeID: newAssigneeID
				},
	            success: function( data ) {
	            	if(data.success){
	            				location.reload();
	            	}else{
						// $("#waiting").addClass('hide');
	            		if(confirm("An Error '"+data.message+"' when update Data! do you want reload this page ?")){
	            				location.reload();
	            		}
	            	}
	            }
			});
	    });
	</cfif>
	<cfif localTicketInfo.statusName neq "Closed">
		$('#fentryDate').datepicker({dateFormat:"yy-mm-dd"});
	    $(window).on('resize.chosen', function() {
	        var w = $('.chosen-select').parent().width();
	        $('.chosen-select').next().css({'width':w});
	    }).trigger('resize.chosen');

		$('#lb_changeStatus').click(function(){
			$('#staSelect').find('option[value="' + oldStatusID + '"]').prop('selected', true);
			if(($('#staSelect option:selected').val() == idAccept1)){
				$("#rowResolution").show();
			}else{
				$( "#rowResolution" ).hide();
			}
			$('#myModalChangeStatus').modal({show:true});
		});
		$('#staSelect').on('change',function(e){
			if($('#staSelect option:selected').val() == idAccept1){
				$("#rowResolution").show();
			}else{
				$( "#rowResolution" ).hide();
				resolutionName='Unresolved!';
				resolutionID=0;
			}
		});

		$('#soSelect').on('change',function (e) {
			resolutionID = $('#soSelect option:selected').val();
			resolutionName = $('#soSelect option:selected').text();
		})

	    $('#lb_changeAssignee').click(function(){
			$('#myModalChangeAssignee').modal({show:true});
		});

	    $('#btnChangeAssignee').on('click',function (e){
	    	if ( $('#assSelect option:selected').val() != oldAssigneeID )  		
				if( $.trim($('#assComment').val()) !== "" ){
					var idAssignee = $('#assSelect option:selected').val();
					var newAssigneeName = $('#assSelect option:selected').text();
					$("#waiting").removeClass('hide');
					$.ajax({
						type: "POST",
						url: "/index.cfm/home:ticket.changeAssignee",
						data:{
							idTicket: ticketID,
							assigneeID: idAssignee,
							oldAssigneeName: oldAssigneeName,
							newAssigneeName: newAssigneeName,
							assComment: $('#assComment').val()
						},
			            success: function( data ) {
							$("#waiting").addClass('hide');
			            	if(data.success){
			            			location.reload();
			            	}else{
			            		if(confirm("An Error '"+data.message+"' when update Data! do you want reload this page ?")){
			            			location.reload();
			            		}
			            	}
			            }
					});
				}
				else{
					alert("Please type comment the reason you change ticket's assignee!");
				}
			else{
				alert("The ticket's assignee isn't change!");
			}
	    });
	</cfif>
	loadTimeEntry();
	if(firstLoadCmt){
			firstLoadCmt = false ;
			loadMoreCmt();
		}
	$('#dComment a').on('click',function(){
		if(firstLoadCmt){
			firstLoadCmt = false ;
			loadMoreCmt();
		}
	})
	$('#aLoadMoreTE').on('click',loadTimeEntry);
	$('#btn-add-cmt').on('click',addComment);
	$('#aLoadMoreCMT').on('click',loadMoreCmt);
})

	function saveFile(){
		if($('#ListFileUpload').val() !=""){
			$.ajax({
		        type: "POST",
		        url: "/index.cfm/ticket/addFile",
		        data: {
		        	ticketID : ticketID,
		        	listFile: $('#ListFileUpload').val()
		        },
		        success: function( data ) {
		        	if(data)
		        		location.reload();
		        	else 
		        		alert('an error when save files in server! please try again!');
	        	}
	    	});
		}
	}

<cfif SESSION.userType neq 1>
	function delTicket(id){
		if(confirm("Your reality want to delete this Time Entry ?")){
			$.ajax({
	            type: "POST",
	            url: "/index.cfm/home:ticket.delete",
	            data: {
	            	id : id
	            },
	            success: function( data ) {
	            	if(data){
	            		$("#rowticket"+id).remove();
	            	}else{
	            		alert("can't delete this Time Entry!");
	            	}
	            }
	        });
		}
	};
</cfif>

<cfif localTicketInfo.statusName neq "Closed">	
	function enter(e){
		if(e.keyCode == 13){			
			if($('#fentryDate').val()=="" || $('#fDescription').val()=="" || $('#fHours').val()==""){
				alert("please insert requite field!");
			}else{
				var userIDSS = $('#fuser option:selected').val();
				$.ajax({
		            type: "POST",
		            url: "/index.cfm/home:ticket.addEntry",
		            data: {
		            	entryDate : $('#fentryDate').val(),
		            	hours : $('#fHours').val(),
		            	minute : $('#fMinute').val(),
		            	description: $('#fDescription').val(),
		            	ticket: ticketID,
		            	user: userIDSS
		            },
		            success: function( data ) {
		            		console.log(data);
							var timeentryRow = '\
		            		<div class="row entry-row" id="rowticket'+data.ID+'">\
		            		<div class="col-md-2"><i class="ace-icon fa fa-caret-right blue"></i>'+data.ENTRYDATE+'</div><div class="col-md-2">'+data.USER+'</div><div class="col-md-1 center">'+data.HOURS+'</div><div class="col-md-1 center">'+data.MINUTE+'</div><div class="col-md-6">'+data.DESCRIPTION+
		            				'</div><a class="red del-ticket" onClick="delTicket('+data.ID+')">\
										<i class="ace-icon fa fa-trash bigger-120"></i>\
									</a>\
							</div>';
							$('#contentTicketTimeEntries').prepend(timeentryRow);
							var disPlayLogTime = parseInt(data.logtime/60)+'h'+parseInt(data.logtime % 60) + "'";
							$('#lbtotalTime').text(disPlayLogTime);
							$('#lbProLogTime').text(disPlayLogTime);
							if(estimate > 0){
								var remainPercent = 100 - (data.logtime/(estimate*60))*100;
								var remainPercentText = estimate*60 - data.logtime ;
								var logPercent = data.logtime*100/(estimate*60) ;
							}
							else{
								var remainPercent = 0 ;
								var remainPercentText = 0 ;
								var logPercent = 100 ;
							}
								
							$('#proRemainTime').width(remainPercent+'%');
							$('#lbProRemainTime').text(parseInt(remainPercentText/60)+"h"+(remainPercentText%60)+"'");
							$('#proLogTime').width(logPercent +'%');
							
							// $('#fDescription').val($('#fDescription').attr('placeholder'));

							$('#fDescription').val("");

		            }
		        });
			}			
		}			
	}
	</cfif>
	function loadTimeEntry(){
		$('#aLoadMoreTE').addClass('hide');
		if(number >= 0){
			var $loading = $('#aLoadMoreTE').parent();
			$.ajax({
				type: 'post',
				url: '/index.cfm/home:ticket.loadMoreTE',
				data:{
		            	id : ticketID,
		            	page:number
		        },
				dataType : 'json',
				beforeSend: function() {
					if ($loading.find(".loadingline").length === 0) {
						$loading.prepend("<div class='loadingline'></div>")
						$loading.find('.loadingline').addClass("waiting").append($("<dt/><dd/>"));
						$loading.find('.loadingline').width((50 + Math.random() * 30) + "%");
					}
				}
			}).always(function() {
				$loading.find('.loadingline').width("101%").delay(200).fadeOut(400, function() {
					$(this).remove();
					$('#aLoadMoreTE').removeClass('hide');
				});
			}).done(function(data) {
            	if(data.success){
	            	if(data.arr.length == 0){
	            		number=-1;
	            		$("#aLoadMoreTE").remove();
	            	}else{
	            		if(data.arr.length < 5 ){
		            		number=-1;
		            		$("#aLoadMoreTE").remove();
	            		}else{number++;}
	            		if(data.arr.length <= 5)
	            		for (var i = 0;i<data.arr.length; i++) {
		            		<cfif localTicketInfo.statusName neq "Closed" and SESSION.userType neq 1>
		            			if (data.arr[i].userID == userIDSS || typeUser == 3) {
		            				var timeentryRow = '\
					            		<div class="row entry-row" id="rowticket'+data.arr[i].timeEntryID+'">\
					            		<div class="col-sm-2"><i class="ace-icon fa fa-caret-right blue"></i>'+data.arr[i].date+'</div><div class="col-sm-2">'+data.arr[i].assignName+'</div><div class="col-sm-1 center">'+data.arr[i].hours+'h</div><div class="col-sm-1 center">'+data.arr[i].minute+'\'</div><div class="col-sm-6">'+data.arr[i].description+
					            				'</div><a class="red del-ticket" onClick="delTicket('+data.arr[i].timeEntryID+')">\
													<i class="ace-icon fa fa-trash bigger-120"></i>\
												</a>\
										</div>';
		            			}else{
			            			var timeentryRow = '\
					            		<div class="row entry-row" id="rowticket'+data.arr[i].timeEntryID+'">\
					            		<div class="col-sm-2"><i class="ace-icon fa fa-caret-right blue"></i>'+data.arr[i].date+'</div><div class="col-sm-2">'+data.arr[i].assignName+'</div><div class="col-sm-1 center">'+data.arr[i].hours+'h</div><div class="col-sm-1 center">'+data.arr[i].minute+'\'</div><div class="col-sm-6">'+data.arr[i].description+
					            				'</div></div>';
								}
							<cfelse>
								var timeentryRow = '\
				            		<div class="row" id="rowticket'+data.arr[i].timeEntryID+'">\
				            		<p class="col-md-2"><i class="ace-icon fa fa-caret-right blue"></i>'+data.arr[i].date+'</p><p class="col-md-2">'+data.arr[i].assignName+'</p><p class="col-md-6">'+data.arr[i].description+
									'</div>';
		            		</cfif>
							$('#contentTicketTimeEntries').append(timeentryRow);
						};
	            	}
            	}else{
            		alert(data.message);
            	}
			});
		}
	}
	function enterComment(e){
		if(e.keyCode == 13 && e.ctrlKey){
			addComment ();
		}			
	}
	function addComment () {
		if($.trim($('#formComment').val($('#editor').html()))==""){
			alert("please insert requite field!");
		}else{
			$loading = $("#btn-add-cmt").parent().parent();
			$("#btn-add-cmt").prop('disabled',true);
			if(typeUser == 1)
				dinternal = 0;
			else dinternal = $("#internal").prop("checked");
			$.ajax({
	            type: "POST",
	            url: "/index.cfm/home:ticket.addComment",
	            data: {
	            	comment : $('#formComment').val(),
	            	ticket: ticketID,
	            	user: userIDSS,
	            	internal: dinternal
	            },
				beforeSend: function() {
					if ($loading.find(".loadingline").length === 0) {
						$loading.prepend("<div class='loadingline'></div>")
						$loading.find('.loadingline').addClass("waiting").append($("<dt/><dd/>"));
						$loading.find('.loadingline').width((50 + Math.random() * 30) + "%");
					}
				}
			}).always(function() {
				$loading.find('.loadingline').width("101%").delay(200).fadeOut(400, function() {
					$(this).remove();
					$("#btn-add-cmt").prop('disabled',false);
				});
			}).done(function(data) {
				$('#editor').html('');
            	$('#formComment').val("");		            	
            	if(isNaN(data.id)){
					$('#vTicketComments').prepend('\
						<div class="panel panel-default">\
							<div class="panel-heading">\
								<a class="accordion-toggle">\
									<i class="ace-icon fa fa-user bigger-130"></i>\
									&nbsp;'+data[0].userName+'&nbsp;&nbsp;'+data[0].date+'\
								</a>\
							</div>\
							<div class="panel-collapse collapse in">\
								<div class="panel-body">\
									<div class="panel-main">\
										'+data[0].comment+'\
									</div>\
								</div>\
							</div>\
						</div>');
				}else{
					alert("an error for add comment");
				}
			});
		}
	}
	function loadMoreCmt(){
		$loading = $("#aLoadMoreCMT").parent();
		$("#aLoadMoreCMT").addClass("hide");
		$.ajax({
	        type: "POST",
	        url: "/index.cfm/home:ticket.loadComment",
	        data: {
	        	page : page,
	        	ticket: ticketID
	        },
			beforeSend: function() {
				if ($loading.find(".loadingline").length === 0) {
					$loading.prepend("<div class='loadingline'></div>")
					$loading.find('.loadingline').addClass("waiting").append($("<dt/><dd/>"));
					$loading.find('.loadingline').width((50 + Math.random() * 30) + "%");
				}
			}
		}).always(function() {
			$loading.find('.loadingline').width("101%").delay(200).fadeOut(400, function() {
				$(this).remove();
				$("#aLoadMoreCMT").removeClass('hide');
			});
		}).done(function(data) {
        	if(data.length ==0){
        		page=-1;
        		$("#aLoadMoreCMT").remove();
        	}else{
        		for(var i=0;i<data.length ;i++){
				$('#vTicketComments').append('\
					<div class="panel panel-default">\
						<div class="panel-heading">\
							<a class="accordion-toggle">\
								<i class="ace-icon fa fa-user bigger-130"></i>\
								&nbsp;'+data[i].userName+'&nbsp;&nbsp;'+data[i].date+'\
							</a>\
						</div>\
						<div class="panel-collapse collapse in">\
							<div class="panel-body">\
								<div class="panel-main">\
									'+data[i].comment+'\
								</div>\
							</div>\
						</div>\
					</div>');
				};
				if(data.length < 5){
	        		page=-1;
	        		$("#aLoadMoreCMT").remove();
				}else{page++;}
			}
	    });
	}
</script>
<script type="text/javascript">
	function assignToMe()
	{
		$.ajax({
			type: "POST",
			url: "/index.cfm/home:ticket.assignToMe",
			data:{
				idTicket: ticketID,
			},
			success: function( data ) {
            	location.reload();
            }	
		});
	}
</script>
</cfif>

