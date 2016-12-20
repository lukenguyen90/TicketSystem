<style type="text/css">
.userimg{
	width: 40px;
}
.epic-title{
	cursor: pointer;
	color: #fff;
}
.epic-title.epic-title-purple{
	background-color: #9585BF ;
}
.epic-title.epic-title-danger{
	background-color: #D15B47 ;
}
.epic-title.epic-title-inverse{
	background-color: #555 ;
}
.epic-title.epic-title-pink{
	background-color: #D6487E ;
}
.epic-title.epic-title-purple{
	background-color: #9585BF ;
}
.epic-title.epic-title-yellow{
	color: #963;
	background-color: #FEE188 ;
}
.epic-title.epic-title-grey{
	background-color: #A0A0A0 ;
}
.epic-title.epic-title-warning{
	background-color: #FFB752 ;
}
.epic-title.epic-title-success{
	background-color: #87B87F ;
}
.epic-title.epic-title-info{
	background-color: #6FB3E0 ;
}
.epic-title.epic-title-primary{
	background-color: #428BCA ;
}
.kanban-container{
	overflow: auto;
}
</style>
<cfoutput>
<cfset color = 1>
<div class="page-header">
	<div class="row">
	<h1 class="col-xs-12 col-md-6">
		#getLabel("Kanban :", #SESSION.languageId#)#
		<i>
			<!--- project end change project --->
			<a  data-toggle="dropdown" class="dropdown-toggle green" title="Click to change Project!" >
				#rc.curProject.name#
			</a>
			<ul class="dropdown-menu dropdown-yellow dropdown-caret " style="top:35px !important; left: 110px !important;">
		   	<cfloop query="rc.listProject">
					<cfif rc.curProject.id NEQ rc.listProject.projectID>
					<li>
	            		<a href="/index.cfm/kanban/?pId=#rc.listProject.projectID#">
	          				#rc.listProject.projectName#
	            		</a>
	            	</li>
					</cfif>
				</cfloop>
        	</ul>
			<!--- end change project --->
			<small>
				<!--- Sprint and change Sprint --->
				<a  data-toggle="dropdown" class="dropdown-toggle red" title="Click to change Sprint!" id="labelSprint">
					#rc.curSprint.moduleName#
				</a>
				<ul id="listSprint" class="dropdown-menu dropdown-yellow dropdown-caret " style="top:35px !important; ">
	            	<cfloop query="rc.listSprints">
						<cfif rc.sprintID NEQ rc.listSprints.moduleID>
						<li>
		            		<a href="/index.cfm/kanban/?pId=#URL.pId#&sprint=#rc.listSprints.moduleID#">
		          				#rc.listSprints.moduleName#
		            		</a>
		            	</li>
						</cfif>
					</cfloop>
	        	</ul>
	        	<!--- end change sprint --->
			</small>
		</i>
		<!--- show status --->
		<small>
		<cfif rc.curSprint.status eq "1">
			<span class="inline">
				<span style="color: ##2679B5 !important;">Started 
					<cfif rc.curSprint.startDate EQ "">
						unknow
					<cfelse>
						#dateFormat(#rc.curSprint.startDate#,"dd/mm/yyyy")#
					</cfif>
					-
					<cfif rc.curSprint.endDate EQ "">
						unknow
					<cfelse>
						#dateFormat(#rc.curSprint.endDate#,"dd/mm/yyyy")#
					</cfif>
				</span>
			</span>
			<!--- <span class="label label-lg label-purple arrowed arrowed-right"><cfif rc.info.point NEQ "">#rc.info.point#<cfelse>0</cfif> points</span> --->
		<cfelse>
			<cfif rc.curSprint.done eq "1">
				<span class="inline">
					<span style="color: ##82AF6F !important;">Stopped 
						<cfif rc.curSprint.endDateEtm EQ "">
							unknow
						<cfelse>
							#dateFormat(#rc.curSprint.endDateEtm#,"dd/mm/yyyy")#
						</cfif>
					</span>
				</span>
			<cfelse>
				<span class="inline">
					<span style="color: ##F89406 !important;">Sleeping </span>
				</span>
			</cfif>
		</cfif>
		</small>
	</h1>
	<div class="col-xs-12 col-md-5 pull-right">
		<!--- Get avatar --->	
		<span class="project-people pull-right" id="listuserinsprint">
			<cfif rc.isLeader OR SESSION.userType eq 3>
	        	<span style="cursor:pointer;" title="Add User to this Sprint">
	        		<i class="ace-icon fa fa-user-plus" onclick="showaddUserToSprint()"></i>
	        	</span>
			</cfif>

            <!--- <cfloop query=#rc.listUser# >
            	<cfset useravatar = rc.listUser.avatar EQ "" ? "unknow.jpg" : rc.listUser.avatar>
            	<img style="width:32px; height:32px;" alt="image" title="#rc.listUser.name#" class="img-circle" src="/fileupload/avatars/#useravatar#"/>
        	</cfloop> --->
        	<cfloop query=#rc.listUser# >
            	<!--- <cfset useravatar = rc.listUser.avatar EQ "" ? "unknow.jpg" : rc.listUser.avatar> --->
            	<img style="width:32px; height:32px;" alt="image" title="#rc.listUser.name#" class="img-circle" <cfif rc.listUser.avatar eq "">
            		src="/fileupload/avatars/default.jpg"
            		<cfelse> src="/fileupload/avatars/#rc.listUser.avatar#"
            	</cfif>/>
        	</cfloop>
        </span>
        <!--- <cfif rc.user.avatar EQ "">src="/fileupload/avatars/default.jpg"<cfelse>src="/fileupload/avatars/#rc.user.avatar#"</cfif> --->
        <!--- <button id="closeAddUser" class="btn btn-xs hide pull-right" onClick='closeAddUser()'>close</button> --->
        <!--- Add user to sprint --->

		<span class="hide" id="closeAddUser" >
			<button id="btn-cancel" type="button" class="btn btn-warning btn-xs inline pull-right"  onClick='CancelUserToSprint()'>Cancel</button>					
			<button id="btn-a" type="button" class="btn btn-info btn-xs inline pull-right"  onClick='AddUserToSprint()'>Add</button>	 											
			<select class="ms-choice pull-right" id="selectAddUser"  name="selectAddUser" style="width: 150px;">
			</select>	
		</span>
	</div>
	</div>
</div><!-- /.page-header -->
<!--- kanban table --->
<div class="row kanban" id="kanban">
	<div class="kanban-header col-xs-12">
		<div class="col-xs-3 ">
			To do
		</div>
		<div class="col-xs-3 ">
			In progress
		</div>
		<div class="col-xs-3 ">
			In Review
		</div>
		<div class="col-xs-3 ">
			<cfif not structKeyExists(SESSION,'dayforclosed')>
				<cfset SESSION.dayforclosed = '7d'>
			</cfif>
			<select class="pull-right selectDayforClosed" id="selectDayforClosed">
				<option value="all" #SESSION.dayforclosed eq "all"?'selected':''#>All</option>
				<option value="7d" #SESSION.dayforclosed eq "7d"?'selected':''#>within 7 days</option>
				<option value="15d" #SESSION.dayforclosed eq "15d"?'selected':''#>within 15 days</option>
				<option value="1m" #SESSION.dayforclosed eq "1m"?'selected':''#>This month</option>
			</select>
			Done
		</div>
	</div>
	<cfif structKeyExists(rc,'listTicket')>
		<div class="kanban-container col-xs-12">
			<cfloop array=#rc.listTicket# index="epic">
				<div class="row" id="epic-#epic.epicID#" style="margin-bottom:10px;">
					<div class="col col-xs-12 epic-title epic-title-#epic.epicColor#" id='title-#epic.epicID#' data-id="#epic.epicID#">
						<span class="epic epic-#epic.epicColor# epic-style">#epic.epicName#</span>
						<span class="epic-description">#epic.epicDescription#</span>
					</div>
					<div class="col col-xs-12 epic-content" id="content-#epic.epicID#">
						<cfset colIndex=1>
						<cfloop array=#epic.cols# index="col">
							<div class="col-xs-3" id="epicCol-#epic.epicID#-#colIndex++#">
								<cfloop array=#col# index="ticket">
									<div id="ticket-#ticket.id#" class="tpreview" style="height:auto ! important;">
										<div class="row">
											<div class="col-xs-12 workspace-switcher-item-icon">
												<!--- avatar --->
												<cfif ticket.assignee.avatar neq "" >
													<img alt="#ticket.assignee.name#" title="Assignee : #ticket.assignee.name#" class="userimg img-circle pull-left" src="/fileupload/avatars/#ticket.assignee.avatar#">
												</cfif>
												<!--- end avatar --->
												<a href="/index.cfm/ticket?id=#ticket.code#" id="ticket-title-#ticket.id#" class="#ticket.status eq 6 ?'finished':''#">#ticket.title#</a>
												<br>
												<cfif epic.epicID neq 0>
													<span class="epic epic-#epic.epicColor#">#epic.epicName#</span>
												</cfif>
												
												<span class="spoint" title="Ticket's point">

													<cfif ticket.point neq "">
														#ticket.point#
														#ticket.point EQ 1?'point':'points'#
													<cfelse>
														Unestimate
													</cfif>
												</span>
												<cfif ticket.assignee.avatar eq "" >
													<span class="sassignee" id="as_#ticket.id#" title="Assignee : #ticket.assignee.name#">#ticket.assignee.name#</span>
												</cfif>
												<!--- action btn --->
												<cfif ticket.isLogstart NEQ 1>
													<cfswitch expression="#ticket.status#">
														<cfcase value="1">
															<cfif ticket.assignee.id EQ SESSION.userID OR SESSION.userType EQ 3>
																<span id="grBtn_#ticket.id#" class="pull-right">
																	<span class="label label-warning pull-right action change-status" data-id="#ticket.id#" data-oldStatusID="#ticket.status#" data-newStatusId="4" data-epicId="#epic.epicID#" data-old-resolutionName="#ticket.solutionName#" data-new-resolutionID="0" data-closeTicket="0" id="btn_#ticket.id#">
																		Start
																	</span>
																</span>
															</cfif>
														</cfcase>
														<cfcase value="2">
															<cfif ticket.assignee.id EQ SESSION.userID OR SESSION.userType EQ 3>
																<span id="grBtn_#ticket.id#" class="pull-right" >
																	<span class="label label-warning pull-right action change-status" data-id="#ticket.id#" data-oldStatusID="#ticket.status#" data-newStatusId="4" data-epicId="#epic.epicID#" data-old-resolutionName="#ticket.solutionName#"data-new-resolutionID="0"data-closeTicket="0" id="btn_#ticket.id#">
																		Restart
																	</span>
																</span>
															</cfif>
														</cfcase>
														<cfcase value="4">
															<cfif ticket.assignee.id EQ SESSION.userID OR SESSION.userType EQ 3>
																<span id="grBtn_#ticket.id#" class="pull-right">
																	<span class="label label-info pull-right action change-status" data-id="#ticket.id#" data-oldStatusID="#ticket.status#" data-newStatusId="5" data-epicId="#epic.epicID#" data-old-resolutionName="#ticket.solutionName#"data-new-resolutionID="1"data-closeTicket="0" id="btn_#ticket.id#">
																		Finish
																	</span>
																</span>
															</cfif>
														</cfcase>
														<cfcase value="5">
															<cfif SESSION.userType EQ 3 OR rc.curSprint.moduleLeadID eq SESSION.userID OR rc.curProject.lead eq SESSION.userID>
																<span id="grBtn_#ticket.id#" class="pull-right">
																	<span class="label label-danger pull-right action change-status" data-id="#ticket.id#" data-oldStatusID="#ticket.status#" data-newStatusId="2" data-epicId="#epic.epicID#" data-old-resolutionName="#ticket.solutionName#"data-new-resolutionID="0" data-closeTicket="0" id="btnR_#ticket.id#">
																		Reject
																	</span>
																	<span class="label label-success pull-right action change-status" style="margin-right: 3px;" data-id="#ticket.id#" data-oldStatusID="#ticket.status#" data-newStatusId="6" data-epicId="#epic.epicID#" data-old-resolutionName="#ticket.solutionName#" data-new-resolutionID="0"data-closeTicket="1" id="btnC_#ticket.id#">
																		Accept
																	</span>
																</span>
															</cfif>
														</cfcase>
													</cfswitch>
												<cfelse>
													<i class="pull-right">Tracking...</i>
												</cfif>	
												<!--- end action btn --->
											</div>
										</div>
									</div>
								</cfloop>
							</div>
						</cfloop>
					</div>
				</div>
			</cfloop>
		</div>
	<cfelse>
		<div class="alert alert-danger">Missing list ticket!</div>
	</cfif>
</div>
<!--- end kanban table --->
<script type="text/javascript">
var role = #SESSION.userType#;
var userID = #SESSION.userID# ;
var root = "http://#CGI.http_host#";

var sprintID = #rc.curSprint.moduleID#;
var projectID = #rc.curProject.id#;
var sprintName = '#rc.curSprint.moduleName#';
</script>
<!--- end variables --->
</cfoutput>

<script type="text/javascript">
$(document).ready(function(){
	// show list sprint
	var lblSprintPosition = $("#labelSprint").position();
	$("#listSprint").css("left",lblSprintPosition.left+"px");
	// change height when change size
	$(window).on('resize', function(){
		var newHeight = $(this).height() - 265;
		newHeight = newHeight < 300 ? 300 : newHeight ;
	    $('.kanban-container').css('height', newHeight); 
	    $('.kanban').css('height', newHeight+30); 
	}).resize();
	// config day for show closed ticket
	$("#selectDayforClosed").on("change",function(){
		$.ajax({
			type: "post",
			url: "/index.cfm/kanban.changedayforclosed",
			data: {
				newVal : $(this).val()
			},
			success: function (data) {
				if(data)location.reload();
			} 
		});	
	});
	$('.epic-title').on('click',function(){
		var eid = $(this).data('id');
		$('#content-'+eid).slideToggle('slow');
	})
})
$(document).on('click','.change-status',function(){
	// alert('asdsadsa');
		eid = $(this).attr('data-epicId');
		tid = $(this).attr('data-id');		
		sid = $(this).attr('data-oldStatusID');
		closeTicket = $(this).attr('data-closeTicket');
		newStatusID = $(this).attr('data-newStatusId');
		newResolutionID = $(this).attr('data-new-resolutionID');
		oldResolutionName = $(this).attr('data-old-resolutionName');
		$.ajax({
			type: "post",
			url: "/index.cfm/kanban.changeStatus",
			data: {
				ticketID: tid,
				oldStatusID:sid,					
				newStatusID: newStatusID,
				newResolutionID: newResolutionID,
				oldResolutionName: oldResolutionName				
					},
			success: function (data) {
				
				if(data.success == false)
				{

					alert(data.message);
				}
				else{
					//change status
					if(sid == 1 || sid == 2)
					{
						$('#grBtn_'+tid).html('<span class="label label-info pull-right action change-status" data-id="'+tid+'" data-oldStatusID="'+newStatusID+'" data-newStatusId="5" data-epicId="'+eid+'" data-old-resolutionName="'+oldResolutionName+'"data-new-resolutionID="1" data-closeTicket="0" id="btn_'+tid+'">Finish</span>');
						// .text("Finish")
						if(sid == 1)
							$('#as_'+tid).text(data.NAME);
						var text = $('#ticket-'+tid).clone();
						$('#ticket-'+tid).remove();
						$('#epicCol-'+eid+'-2').append(text);
						$('#ticket-'+tid).append(text);
					}
					else if (sid == 4)
					{
						// <cfif SESSION.userType EQ 3 OR rc.curSprint.moduleLeadID eq SESSION.userID OR rc.curProject.lead eq SESSION.userID>
							$('#grBtn_'+tid).html('<span class="label label-danger pull-right action change-status" data-id="'+tid+'" data-oldStatusID="'+newStatusID+'" data-newStatusId="2" data-epicId="'+eid+'" data-old-resolutionName="'+oldResolutionName+'"data-new-resolutionID="0" data-closeTicket="0" id="btnR_'+tid+'">Reject</span><span class="label label-success pull-right action change-status" data-id="'+tid+'" data-oldStatusID="'+newStatusID+'" data-newStatusId="6" data-epicId="'+eid+'" data-old-resolutionName="'+oldResolutionName+'" data-new-resolutionID="0"data-closeTicket="1" style="margin-right: 3px;" id="btnC_'+tid+'">Accept</span>');
							var text = $('#ticket-'+tid).clone();
							$('#ticket-'+tid).remove();
							$('#epicCol-'+eid+'-3').append(text);
							$('#ticket-'+tid).append(text);
						// <cfelse>
						// 	$('#grBtn_'+tid).html('<span></span>');
						// 	var text = $('#ticket-'+tid).clone();
						// 	$('#ticket-'+tid).remove();
						// 	$('#epicCol-'+eid+'-3').append(text);
						// 	$('#ticket-'+tid).append(text);
						// </cfif>
					}					
				}
					//end change status
				<cfif SESSION.userType EQ 3 OR rc.curSprint.moduleLeadID eq SESSION.userID OR rc.curProject.lead eq SESSION.userID>
					if(sid == 5)
					{
						//reopen ticket
						$('#grBtn_'+tid).html('<span class="label label-warning pull-right action change-status" data-id="'+tid+'" data-oldStatusID="'+newStatusID+'" data-newStatusId="4" data-epicId="'+eid+'" data-old-resolutionName="'+oldResolutionName+'"data-new-resolutionID="0" data-closeTicket="0" id="btn_'+tid+'">Restart</span>');	
						var text = $('#ticket-'+tid).clone();
						$('#ticket-'+tid).remove();
						$('#epicCol-'+eid+'-1').append(text);
						//close ticket
						if(closeTicket == 1){
							$('#grBtn_'+tid).empty();
							$('#ticket-title-'+tid).addClass('finished');
							var text = $('#ticket-'+tid).clone();
							$('#ticket-'+tid).remove();
							$('#epicCol-'+eid+'-4').append(text);
						}
					}
				</cfif>
			} 
		});
});

function showaddUserToSprint(){
	if (role == 3){
		getListUser();
		// getValueSelectSprint();
		$("#listuserinsprint").addClass("hide");
		$("#closeAddUser").removeClass("hide");
	}else alert("Just admin can add member");
}

function AddUserToSprint(){
	<cfif SESSION.userType eq 3 OR rc.isLeader >

			$.ajax({
		        type: "post",
		        url: "/index.cfm/kanban.add2Sprint",
		        data: {
		        	sprintID:   sprintID,
		        	userID: 	$('#selectAddUser').val()
		        },
		        success: function (data) {
		        	if (data.AVATAR == "")
		        		var avt = "/fileupload/avatars/unknow.jpg";
		        	else var avt = "/fileupload/avatars/" + data.AVATAR;
		        	$('#listuserinsprint').append('<img style="width:32px; height:32px;" alt="image" title="'+data.NAME+'" class="img-circle" src="'+avt+'"/>');		        	
		        	$("#listuserinsprint").removeClass("hide");
		        	$("#closeAddUser").addClass("hide");	      	    	
		        }
			});
	<cfelse> 
	alert("Just admin or leader can add member");
	</cfif>	
}

function CancelUserToSprint(){
	
    $("#listuserinsprint").removeClass("hide");
	$("#closeAddUser").addClass("hide");
}

function getListUser(){
    $("#selectAddUser").empty();
	$.ajax({
        type: "post",
        url: "/index.cfm/kanban.getListUserNotInSprint",
        data: {
        	sprintID : sprintID
        },
        success: function (data) {
        	for (var i = 0 ; i < data.listuser.length ; i++) {
        		$("#selectAddUser").append('<option value="'+data.listuser[i].userID+'">'+data.listuser[i].name+'</option>');
        	}
        	
        }
    });
}
</script>
