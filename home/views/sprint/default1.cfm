<!--- <cfdump eval=rc abort> --->
<style type="text/css">
.layout_cont{
 	width: 100%;
 	overflow: auto;
 }

.tpreview{
 	/*background-color: #f4f4f4;*/
    border-bottom: 1px solid #ddd;
    border-top: 1px solid #fff;
    cursor: pointer;
    padding: 5px;
 }

.estimate label{
 	border-bottom: 1px solid #333;
    min-width: 12px;
    text-indent: -9999px;
    color: #3f79a5;
    cursor: pointer;
    float: left;
    font-weight: bold;
    height: 16px;
    line-height: 1;
    margin-left: 4px;
    padding-bottom: 2px;
 }

.estimate label.estimate_1, span.estimate_1{
 	background-image: url("/images/icon/bar-sprite.png");
    background-position: -2px top;
    background-repeat: repeat-y;
    content: "";
    float: left;
    height: 16px;
    width: 12px;
 }
.estimate label.estimate_2, span.estimate_2{
 	background-image: url("/images/icon/bar-sprite.png");
    background-position: -18px top;
    background-repeat: repeat-y;
    content: "";
    float: left;
    height: 16px;
    width: 12px;
 }
.estimate label.estimate_3, span.estimate_3{
 	background-image: url("/images/icon/bar-sprite.png");
    background-position: -34px top;
    background-repeat: repeat-y;
    content: "";
    float: left;
    height: 16px;
    width: 12px;
 }
.estimate label.estimate_5, span.estimate_5{
 	background-image: url("/images/icon/bar-sprite.png");
    background-position: -66px top;
    background-repeat: repeat-y;
    content: "";
    float: left;
    height: 16px;
    width: 12px;
 }
textarea.editor {
    min-height: 23px;
    margin-bottom: 3px;
    font-size: 13px;
    color: black;
    line-height: 18px;
    margin: 0;
    overflow-x: hidden;
    padding: 2px 4px 1px;
    width: 100%;
    word-wrap: break-word;
 }

.ticket_info{
	padding-left: 20px;
	padding-right: 10px;
 }
.row_1{
	background-color: #fcfcfc;
	border: 1px solid #ccc;
	height: 30px;
	line-height: 27px;
 }
.mousechange:hover {
        cursor:pointer;
    }
.ticket-drag{
	cursor: move;
}
 .tpreview>.row{
 	margin-left: 0px;
 	margin-right: 0px;
 }
 .tpreview>.row>.col-xs-12{
 	padding-left: 0px;
 	padding-right: 0px;
 }
 .sprint-col{
 	width: 100%;
 }
 .ticket-info{
 	width: 25%;
 	display: none;
 }
 .sprint-table{
 	display: table;
 	min-width: 400px;
 }
 .sprint-table.active .ticket-info{
 	display: table;
 }
 .sprint-table.active .sprint-col{
 	width:75%;
 }
</style>
<cfoutput>
<script type="text/javascript">
		var sprint = #rc.modInfo.sprintID#;
		var backlog = #rc.modInfo.backlogID#;
		var icebox = #rc.modInfo.iceboxID#;
		var userID = #SESSION.userID#;
		var role = #SESSION.userType#;
		var dprojectID = #rc.projectID#;
		var sd = "#rc.info.startDate#";
		var ed = "#rc.info.endDate#";
</script>
</cfoutput>
<cfoutput>
<cfparam name="URL.id" default="0">
<cfparam name="URL.sp" default="0">
<div class="page-header">
	<div class="row">
		<h1 class="col-xs-12 col-md-12">
		<small><span class="cold-md-2 action" title="Sprint detail..." onClick="fmoreSprint()"><i class="normal-icon ace-icon fa fa-bars blue bigger-130"></i></span></small>
		#getLabel("Sprint :", #SESSION.languageId#)#
		<i>
			<!--- change project --->
			<div class="btn-group">
				<a  data-toggle="dropdown" class="dropdown-toggle green" title="Click to change Project!" >
					#rc.curProject.name#
				</a>
				<ul class="dropdown-menu dropdown-yellow dropdown-caret" style="top:35px !important;">
			   	<cfloop query="rc.prj">
					<cfif rc.curProject.id NEQ rc.prj.projectID>
					<li>
	            		<a href="/index.cfm/sprint/?pId=#rc.prj.projectID#">
	          				#rc.prj.projectName#
	            		</a>
	            	</li>
					</cfif>
				</cfloop>
	        	</ul>
        	</div>
			<!--- end change project --->
			<div class="btn-group">
				<small>					
					<a  data-toggle="dropdown" class="dropdown-toggle green">
						#rc.modInfo.sprintName#
					</a>
					<ul class="dropdown-menu dropdown-yellow dropdown-caret" style="top:35px !important;">
		            	<cfloop query="rc.moduleInfo">
							<cfif not rc.moduleInfo.isPrivate AND rc.modInfo.sprintID NEQ rc.moduleInfo.moduleID>
							<li>
			            		<a  onClick="changeSprint('#rc.moduleInfo.moduleID#')">
			          				#rc.moduleInfo.moduleName#
			            		</a>
			            	</li>
							</cfif>
						</cfloop>
		        	</ul>
				</small>
			</div>
			<cfif rc.info.startDate NEQ 0 and SESSION.userType EQ 3>
					<!--- <cfif rc.info.endDate NEQ 0 >
					<cfelse> --->
						<span id="startstop" class="btn btn-xs btn-success" title="Start sprint" class="mousechange" onClick="stopSprint(#rc.projectID#,#rc.modInfo.sprintID#)"><i class="ace-icon glyphicon glyphicon-stop"></i>Stop</span>

					<!--- </cfif> --->
				<cfelse>
					<cfif SESSION.userType EQ 3>
						<span id="startstop" class="btn btn-xs btn-danger" title="Start sprint" class="mousechange" onClick="preStart(#rc.projectID#,#rc.modInfo.sprintID#)"><i class="ace-icon glyphicon glyphicon-play"></i>Start</span>
						<span id="grSS" class="inline hidden"><input class="date-picker" id="dueDate" name="dueDate" type="text" data-date-format="yyyy-mm-dd" value="estimate end date" style="height:26px; border: 1px solid ##a1a1a1;"/><span id="startstop" class="btn btn-xs btn-danger" title="Start sprint" class="mousechange" onClick="startSprint(#rc.projectID#,#rc.modInfo.sprintID#)"><i class="ace-icon glyphicon glyphicon-play"></i>Start</span><span id ="cancelStart" class="btn btn-xs btn-warning" title="Cancel" onClick="fCancelStart()">Cancel</span></span>	
					</cfif> 	
			</cfif>

		</i> 				
		<div class="pull-right" style="float:right;">
			<button class="btn btn-sm btn-info" onclick="goKanban()">
				<i class="menu-icon fa fa-heart-o"><span style="font-family: 'Open Sans';"> #getLabel("Kanban", #SESSION.languageId#)#</span></i>
			</button>
		</div>
		<!--- change sprint --->
		<div class="pull-right hidden" style="float:right;">
			<form action="">
				<select id="sprint" class="form-control" onchange="changeSprint();" style="height:34px; width: 200px;">
					<cfloop query="rc.moduleInfo">
						<cfif not rc.moduleInfo.isPrivate >
						<option value="#rc.moduleInfo.moduleID#" <cfif rc.modInfo.sprintID EQ rc.moduleInfo.moduleID>selected="SELECTED"
						</cfif>>#rc.moduleInfo.moduleName#</option>						
						</cfif>
					</cfloop>
				</select>	
			</form>	
		</div>
		<!--- end change sprint --->	
		</h1>
	</div>	
</div><!-- /.page-header -->
<div class="row" style="display:none" id="moreSprint">
	<div class="col-xs-12 col-md-12">		
		<div class="row">
			<!--- description --->
			<div class="col-xs-12 col-sm-4 col-md-6" style="max-height:150px; overflow: hidden;">
				<h4 class="green">Description</h4>
				<p class="text-justify" style="max-height:150px; overflow: auto;">#rc.info.description#</p>
			</div>
			<!--- end description --->
			<!--- ticket info --->
			<div class="col-xs-6 col-sm-4 col-md-3" style="max-height:150px; overflow: hidden;">
				<h4 class="green">Sprint Info</h4>
				<div class="col-md-12" style="margin-top: 0px; bottom: 0px;">
					<cfif rc.info.startDate GT 0>
						<span class="info">Status: working...</span></br>
						<span class="danger">Start date: <cfif rc.info.startDate EQ 0>#dateFormat(now(),"yyyy mmmm, dd")#<cfelse>#rc.info.startDate#</cfif></span></br>
						<span class="danger">End date: <cfif rc.info.endDateEtm EQ 0>#dateFormat(now(),"yyyy mmmm, dd")#<cfelse>#rc.info.endDateEtm#</cfif></span></br>
					<cfelse>
						<span class="info">Status: sprint sleeping...</span></br>
					</cfif>	
					<span class="purple">Points: <cfif rc.info.point NEQ "">#rc.info.point#<cfelse>0</cfif></span></br>
					<span class="pink">Tickets: #rc.info.ticket#</span></br>
				</div>
			</div>
			<!--- end ticket info --->
			<!--- add developer --->
			<div class="col-xs-6 col-sm-4 col-md-3" id="addAssignee">
				<h4 class="green">Developer</h4>
				<cfif SESSION.userType eq 3>
					<cfif rc.userOutSprint.recordCount GT 0>
					-<a style="cursor:pointer; color:##999;" onclick="addUser()"><small>Add</small></a>
					<cfelse>
						<small>no user</small>
					</cfif>
				</cfif>
				<cfif SESSION.userType eq 3 and rc.userOutSprint.recordCount GT 0 >
					<!--- list dev to add to sprint --->
				<div class="form-group hidden" id="dAddUser">
					<select id="assignee" class="col-md-8 col-xs-12" style="height: 35px;">
						<cfloop query="rc.userOutSprint" >	
						<!--- 	<cfif SESSION.userType eq 2> --->
							<option value="#rc.userOutSprint.userID#" id="o#rc.userOutSprint.userID#">
								#rc.userOutSprint.name#
							</option>
							<!--- </cfif> --->
						</cfloop>
					</select>									
					<button id="dau" class="btn btn-sm btn-info col-md-2 col-xs-4" onclick="dAdd();">#getLabel("Add", #SESSION.languageId#)#</button>									
					<button class="btn btn-sm col-md-2 col-xs-4" onClick="bCloseAdd()">#getLabel("Close", #SESSION.languageId#)#</button>
				</div>
					<!--- end dev user to add to sprint --->
				</cfif>
				<div id="dUser" style="width:100%;max-height:125px; overflow: auto;">
					<ol>
						<cfloop query="rc.userInSprint">
							<li class="dev-row" id="s#rc.userInSprint.userID#">
								#rc.userInSprint.name#
								<cfif SESSION.userType eq 3>
								<div class="action-buttons pull-right">
									<a><i class="small fa fa-trash-o red" style="cursor: pointer;" onclick="removeUser(#rc.userInSprint.userID#,'#rc.userInSprint.firstname#')"></i>
									</a>
								</div>
								</cfif>
							</li>
						</cfloop>	
					</ol>														
				</div>
			</div>
			<!--- end add developer --->	
		</div>	
		<hr>
	</div>
</div>
<div class="row" >
	<div class="col-xs-12 sprint-table" style="margin-top: 0px; bottom: 0px;" id="sprint-table">
		<div class="sprint-col">
			<div class="col-md-4">
				<div class="col-xs-12 label label-lg label-success arrowed-in-right arrowed"><p>Sprint</p></div>
				<div class="col-xs-12 widget-box" style="margin-left:6px; margin-top:0px;">
					<div class="layout_cont sprint_col" id="s_#rc.modInfo.sprintID#">
						<cfloop query="rc.sprint">							
							<div id="#rc.sprint.ticketID#" class="tpreview" style="height:auto ! important;">
								<div class="row">
										<input type="hidden" class="dorder" id="#rc.sprint.ticketID#_#rc.sprint.dorder#" value="#rc.sprint.dorder#" />
									<div style="width: 5% !important; float:left; padding-right:5px;">
										<!--- <div style="float:left;"><i class="normal-icon ace-icon fa fa-bars warning"  title="Click to view ticket detail"></i></div> --->
									<!--- 	<div style="float:left; margin-left:7px;"><span>#dicon#</span></div> --->
										<div style="float:right;" id="p_#rc.sprint.ticketID#">
											<cfif rc.sprint.point NEQ "">
												<span title="#rc.sprint.point# point"></span>
											</cfif>
										</div>
									</div>								
									<div class="ticket-drag" style="width: 100% !important; float:left;" onclick="expandTicket(#rc.sprint.ticketID#);" title="Click to view ticket detail">#rc.sprint.title#
										<cfset uavatar = rc.sprint.avatar eq '' ? 'unknow.jpg': rc.sprint.avatar >
										<cfset avatartitle = rc.sprint.assignedUserID eq '' ? 'UnAssigned' : 'Assignee: #rc.sprint.firstname# #rc.sprint.lastname#'>
										<img style="width:32px; height:32px;" alt="#rc.sprint.firstname#" title="#avatartitle#" class="img-circle pull-right" src="/fileupload/avatars/#uavatar#"/>										
									</div>
								</div>
							</div>
						</cfloop>
					</div>	
				</div>
			</div>
			<div class="col-md-4">
				<div class="col-xs-12 label label-lg label-info arrowed-in-right arrowed"><p>Product Backlog</p></div>
					<div class="col-xs-12 widget-box" style="margin-left:6px; margin-top:0px;">			
						<div class="layout_cont sprint_col" id="s_#rc.modInfo.backlogID#">
						<cfloop query="rc.backlog">							
							<div id="#rc.backlog.ticketID#" class="tpreview" style="height:auto ! important;width:100% ! important; padding: 5px;">
								<div class="row">
										<input type="hidden" class="dorder" id="#rc.backlog.ticketID#_#rc.backlog.dorder#" value="#rc.backlog.dorder#" />
									<div style="width: 5% !important; float:left; padding-right:5px;">
										<!--- <div style="float:left;"><i class="normal-icon ace-icon fa fa-bars warning" onclick="expandTicket(#rc.backlog.ticketID#);" title="Click to view ticket detail"></i></div> --->
									<!--- 	<div style="float:left; margin-left:7px;"><span>#dicon#</span></div> --->
										<div style="float:right;" id="p_#rc.backlog.ticketID#">
											<cfif rc.backlog.point NEQ "">
												<span title="#rc.backlog.point# point"></span>
											</cfif>
										</div>
									</div>								
									<div class="ticket-drag" style="width: 100% !important; float:left;" onclick="expandTicket(#rc.backlog.ticketID#);" title="Click to view ticket detail">#rc.backlog.title#
										<input type="hidden" id="ticket_ID" value="#rc.backlog.ticketID#">
										<cfset uavatar = rc.backlog.avatar eq '' ? 'unknow.jpg': rc.backlog.avatar >
										<cfset avatartitle = rc.backlog.assignedUserID eq '' ? 'UnAssigned' : 'Assignee: #rc.backlog.firstname# #rc.backlog.lastname#'>
										<img style="width:32px; height:32px;" alt="#rc.backlog.firstname#" title="#avatartitle#" class="img-circle pull-right" src="/fileupload/avatars/#uavatar#"/>										
									</div>
								</div>
							</div>
						</cfloop>
					</div>	
				</div>
			</div> <!--- https://www.pivotaltracker.com/n/projects/1246750 --->
			<div class="col-md-4">
				<div class="col-xs-12 label label-lg label-warning arrowed-in-right arrowed"><p>Icebox</p></div>			
				<div class="col-xs-12 widget-box" style="margin-left:6px; margin-top:0px;">	
					<div class="layout_cont sprint_col" id="s_#rc.modInfo.iceboxID#">
						<cfloop query="rc.icebox">							
							<div id="#rc.icebox.ticketID#" class="tpreview" style="height:auto ! important;width:100% ! important; padding: 5px;">
								<div class="row">
											<input type="hidden" class="dorder" id="#rc.icebox.ticketID#_#rc.icebox.dorder#" value="#rc.icebox.dorder#" />
									<div style="width: 5% !important; float:left; padding-right:5px;">
										<!--- <div style="float:left;"><i class="normal-icon ace-icon fa fa-bars warning" onclick="expandTicket(#rc.icebox.ticketID#);" title="Click to view ticket detail"></i></div> --->
									<!--- 	<div style="float:left; margin-left:7px;"><span>#dicon#</span></div> --->
										<div style="float:right;" id="p_#rc.icebox.ticketID#">
											<cfif rc.icebox.point NEQ "">
												<span title="#rc.icebox.point# point"></span>
											</cfif>
										</div>
									</div>								
									<div class="ticket-drag" style="width: 100% !important; float:left;" onclick="expandTicket(#rc.icebox.ticketID#);" title="Click to view ticket detail">#rc.icebox.title#
										<input type="hidden" id="ticket_ID" value="#rc.icebox.ticketID#">
										<cfset uavatar = rc.icebox.avatar eq '' ? 'unknow.jpg': rc.icebox.avatar >
										<cfset avatartitle = rc.icebox.assignedUserID eq '' ? 'UnAssigned' : 'Assignee: #rc.icebox.firstname# #rc.icebox.lastname#'>
										<img style="width:32px; height:32px;" alt="#rc.icebox.firstname#" title="#avatartitle#" class="img-circle pull-right" src="/fileupload/avatars/#uavatar#"/>										
									</div>
								</div>
							</div>
						</cfloop>
					</div>
				</div>
			</div>
		</div>
			
		<div class="ticket-info col-md-4" id="ticket-info">
			<div class="col-xs-12 label label-lg label-pink arrowed-in-right arrowed ">
				<!--- <p> --->
				Ticket Info
				<div class="action-buttons pull-right" style="position: absolute;right: 10px;top: 2px;">
					<a class="white" >
						<i class="ace-icon fa fa-times bigger-130"id="closeTicketInfo" style="margin-left: 75px;"title="Close view ticket detail" onClick="fCloseTicketInfo()"></i>
					</a>
				</div>
			</div>
			<div class="col-xs-12 widget-box" style="margin-left:6px; margin-top:0px;">
				<div class="layout_cont" id="content-ticket-info" style="overflow-x: hidden;overflow-y: auto;">
				</div>
			</div>
		</div>
	</div>
</div>
</cfoutput>
<script src="../../ACEAdmin/assets/js/jquery-ui.custom.min.js"></script>
<link rel="stylesheet" href="//code.jquery.com/ui/1.11.2/themes/smoothness/jquery-ui.css">
<script type="text/javascript">
jQuery(function($) {
		$(window).on('resize', function(){		   
		    $('.layout_cont').css('height', $(this).height() - 215); 
    	}).resize();
		var prid = "";
		var sprid = "";
		// if(ed != 0)
			// $('.layout_cont').sortable("disable");
		// if(sd == 0 )
			$(".sprint_col").sortable({
				connectWith: ".layout_cont",
				handle: ".ticket-drag",
				cursor: "move",
				start: function (event, ui) {
					prid =  ui.item.parent().prop("id");
				},
				stop : function (event, ui) {
					sprid =  ui.item.parent().prop("id");
					var dm = sprid.split("_");
					var sticketID = ui.item.prop("id");
					var om = prid.split("_");
					var sourceID = om[1];
					var targetID = dm[1];
					var dnextID = ui.item.next().find("input").val();
					if (sourceID != targetID)
					{
						$.ajax({
					        type: "post",
					        url: "/index.cfm/sprint.moveTicket",
					        data: {
					        	moduleID : targetID,
					        	ticketID : sticketID
					        }
					    });
					}
					else
					{
						$.ajax({
					        type: "post",
					        url: "index.cfm/sprint.moveVertical",
					        data: {
					        	nextID : dnextID,
					        	ticketID : sticketID
					        }
					    });
					}
				}
			}).disableSelection();	
	});
//-----------------------------------------------------

	function addUser()
	{
		$("#dAddUser").removeClass("hidden");
	}
	function bCloseAdd()
	{		
		$("#dAddUser").addClass("hidden");
	}
	function fmoreSprint(){
		$('#moreSprint').slideToggle('slow');
	}
	function fCancelStart(){		
		$('#dueDate').addClass('hidden');
		$('#cancelStart').addClass('hidden');
	}

	function addMember()
	{
		if (role == 3){
			$('#divUser').removeClass('hide');
			$('#btnau').addClass('hide');
		}else alert("Just admin can add member");
	}
	function enterComment(e){
		if(e.keyCode == 13 && e.ctrlKey){
			addComment();
		}			
	}
	
	function addComment(){
		$("#ticketCmt").prop('disabled',true);
		var comment = $("#ticketCmt").val();
		var ticketID = $("#ticketCmt").attr('data-id');	
		$.ajax({
			type: "POST",
			url: "/index.cfm/sprint.addComment",
			data: { 
				comment: comment,
				ticketID: ticketID
			},
			success: function(data){
				if(data.success){			
					$('#ticket_comment').prepend('\
						<li>\
		 					<span class="green">'+data.userName+'</span>&nbsp;&nbsp;\
		 					<span class="info">'+data.date+'</span><br>\
		 					'+data.comment+'\
		 				</li>\
					');
				}			
				$("#ticketCmt").val("");
				$("#ticketCmt").prop('disabled',false);
			}
		});
	}
	<cfif SESSION.userType eq 3>
	function dAdd()
	{
		var userID = $("#assignee").val();
		var name = $("#o"+userID.toString()).text();
		$("#dau").attr({
			'disabled':'disabled'
		})
		$.ajax({
            type: "POST",
            url: "/index.cfm/sprint.addMember",
            data: {
            	moduleID : $("#sprint").val(),
            	userID : userID
            },
            success: function( data ) {
            	// remove option in select box, select add user 
				$("#o"+userID.toString()).remove();

				var t = $('<li\/>').attr({
					// 'class': 'tag',
					'id': + userID,
				}).html('<small>'+name+'</small>').append('<div class="action-buttons pull-right">\
											<a><i class="small fa fa-trash-o red" style="cursor: pointer;" onclick="removeUser('+userID+',\''+name+'\')"></i></a>\
										</div>');
				$("#dUser ol").append(t);
				// show add btn
				$("#dau").removeAttr("disabled");
            }
        });
	}

		function removeUser(uid,name)
	{
		$.ajax({
            type: "POST",
            url: "/index.cfm/sprint.removeUser",
            data: {
            	moduleID : $("#sprint").val(),
            	userID : uid
            },
            success: function( data ) {
            	
				$("#s"+uid.toString()).remove();
				$("#assignee").append('<option id="o'+uid+'" value="'+uid+'">'+name.toString()+'</option>');
            }
        });
	}
	
	</cfif>

	function changeSprint()
	{
		projectID = $("#prj").val();
		sprint = $("#sprint").val();
		go();
	}

	function goKanban()
	{
		<cfoutput>
		var baseURL = "#getContextRoot()#/index.cfm/kanban?pId=" + dprojectID + "&sprint=" + sprint ;
		</cfoutput>
		window.location = baseURL;
	}

	function preStart(pid, id)
	{
		<cfif SESSION.userType eq 3 OR rc.isLeader >
			$.ajax({
			        type: "post",
			        url: "/index.cfm/sprint.checkSprint",
			        data: {
			        	moduleID : id,
			        	projectID : pid
			        },
			        success: function (data) {
			        	if (data.FLAG == true)
			        	{
				        	$('#startstop').addClass('hidden');
							$('#grSS').removeClass('hidden');
				        }
				        else alert("The sprint named '" + data.NAME + "' is working. Stop that sprint");
			        }
			});
		<cfelse> 
		alert("Just admin can start sprint");
		</cfif>
	}

	function startSprint(pid, id)
	{
		<cfif SESSION.userType eq 3 OR rc.isLeader >
			$.ajax({
			        type: "post",
			        url: "/index.cfm/sprint.startSprint",
			        data: {
			        	moduleID : id,
			        	projectID : pid,
			        	endDate : $('#dueDate').val()
			        },
			        success: function (data) {
			        	if (data.FLAG == true)
			        	{
				        	location.reload();
				        }
				        else alert("The sprint named '" + data.NAME + "' is working. Stop that sprint");
			        }
			});
		<cfelse>
		alert("Just admin can start sprint");
		</cfif>
	}

	function stopSprint(pid, id)
	{
		<cfif SESSION.userType eq 3 OR rc.isLeader >
			$.ajax({
			        type: "post",
			        url: "/index.cfm/sprint.stopSprint",
			        data: {
			        	moduleID : id,
			        	projectID : pid
			        },
			        success: function (data) {
			        	
			        	location.reload();
			        }
			});
		<cfelse>
		alert("Just admin can stop sprint");
		</cfif>
	}

	function fCloseTicketInfo(){
	$('#content-ticket-info').empty();
	$('#sprint-table').removeClass('active');
	}

	function expandTicket(tid)
	{
		
		$('#sprint-table').addClass('active');		
		$.ajax({
		        type: "post",
		        url: "/index.cfm/sprint.loadTicket",
		        data: {
		        	ticketID : tid,
		        	projectID : dprojectID,
		        	userID : userID
		        },
		        datatype : "html",
		        success: function (data) {
		        	$('#content-ticket-info').html(data);
		        	}
		});
	}
	function fcDes(tid)
	{
		$('#des_'+tid).focus();
	}

	function noti()
	{
		alert("Can't change ticket's status in edit form. Close this to change!")
	}
</script>