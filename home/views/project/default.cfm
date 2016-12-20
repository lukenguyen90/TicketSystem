<style type="text/css">
.over{
  background-color: red;
  color: white;
}
ol >li{
	word-wrap: break-word;
}

.center, .align-center {
	width: 504px;
}
.widget-box.fullscreen {
    margin-top: 45px;
}
.panel-main{
	word-wrap: break-word;
}
.widget-box{
	margin-top: 20px;
}
.wysiwyg-toolbar {
	width: 100%;
}
#addMeetingContain{
	padding-bottom:20px;
}
.panel-heading{
	height: 35px;
}
.action-buttons{
	margin-top: 3px;
}
.action-buttons>a{
	display: none;
}
.dev-row:hover{
	background-color: #EEE;
}
.dev-row:hover .action-buttons>a{
	display: block;
}
.footer input{
	border: 0;
}
/*.footer button{
	padding-top: 13px;
}*/
</style>
<cfoutput>
	<!--- js variables --->
<script type="text/javascript">
var root = "http://#CGI.http_host#";
var userIDSS = #SESSION.userID#;
var projectID = #SESSION.focuspj#;
var id=#rc.pId#;
var pagem = 0;
var page = 0;
var golbaltext ={cancel : "#getLabel("Cancel",#SESSION.languageId#)#",save:"#getLabel("Save", #SESSION.languageId#)#"};

</script>
<cfparam name="URL.pId" default="0">
<cfset page = 1>

<cfif isDefined("rc.data")>
	<!--- <div class="page-content-area"> --->
		<div class="page-header">
			<h1>
				#getLabel("Dashboard", #SESSION.languageId#)#
				
				<small>
					<i class="ace-icon fa fa-angle-double-right"></i>
					<a href="/index.cfm/project/overview">#getLabel("overview", #SESSION.languageId#)# &amp; #getLabel("stats", #SESSION.languageId#)#</a>
					<i class="ace-icon fa fa-angle-double-right"></i>
					#getLabel("details", #SESSION.languageId#)#
				</small>
				
				<div class="col-md-4" style="float: right; margin-right:10px;">
					<cfif SESSION.userType eq 3>
						<div class="col-md-4 pull-right">
							<a class="btn btn-sm btn-#rc.data.color#" href="/index.cfm/project/form">
								<i class="menu-icon fa fa-list-alt"><span id="aProject" style="font-family: 'Open Sans';"> #getLabel("New Project", #SESSION.languageId#)#</span></i>
							</a>
						</div>	
					</cfif>
					<div class="col-md-8 pull-right">	
						<form action="">
							<select id="prj" class="chosen-select" onchange="changePrj();" style="height:34px; width: 200px; margin-left: 43px;">
								<cfloop query="rc.prj">
									<option value="#rc.prj.projectID#" <cfif rc.pId EQ rc.prj.projectID>selected="SELECTED"</cfif>>#rc.prj.projectName#</option>
								</cfloop>
							</select>	
						</form>	
					</div>
										
				</div>
			</h1>
		</div><!-- /.page-header -->
	<!--- </div> --->

	<div class="row">
		<div class="row col-xs-12 col-md-12">
			<div class="row">
				<div class="col-xs-12">
					<h4 class="smaller lighter green">
						<!--- <i class="ace-icon fa fa-list"></i> --->
						<cfif SESSION.userType eq 3>
	                    	<a class="green" href="/index.cfm/project/form?pId=#rc.data.projectID#"><abbr title="Click to edit project">#rc.data.projectName#</abbr> <i class="ace-icon fa fa-pencil-square-o  bigger-110 icon-on-right"></i></a>
							- Due Date: <span style="color: red">#dateTimeFormat('#rc.projects.dueDate#',"yyyy-mm-dd")#</span>
						<cfelse>
							#rc.data.projectName#
						</cfif>
						 - <a href="#rc.data.projectURL#">#rc.data.projectURL#</a>
						 <cfif rc.oldVersion.recordCount EQ 0 >
						 	- None version
						 <cfelse>
						 	- <a href="/index.cfm/project/versions?id=#rc.pId#">#rc.oldVersion.versionName# #rc.oldVersion.versionNumber#</a>	
						 </cfif>
					</h4>
				</div>
			</div>
			<div class="row">				
					<div class="lighter" >
						<cfif rc.projects.recordCount eq 1 AND rc.projects.shortdes nEQ "">
							<div class="col-xs-12 col-sm-4 col-md-6" style="max-height:150px; overflow: hidden;">
								<h4 class="green">Description</h4>
								<p class="text-justify" style="max-height:150px; overflow: auto;">#rc.projects.shortdes#</p>
							</div>	
						</cfif>					
							
							<div class="col-xs-6 col-sm-4 col-md-3" >								
								<h4 class="green">Customer
									<cfif rc.users.recordCount GT 0>
										-<a style="cursor:pointer; color:##999;" onclick="addUserCustomer()"><small>Add</small></a>
									<cfelse>
										<small>no customer</small>
									</cfif>
								</h4>
								<cfif rc.users.recordCount GT 0>
									<div class="form-group hidden" id="dAddCustomer">
										<div class="col-md-8 col-xs-12 ">
											<select id="customer" class="chosen-select">
												<cfloop query="rc.users" >	
													<cfif rc.users.userTypeID eq 1>
													<option value="#rc.users.userID#" id="oc#rc.users.userID#" data-email="#rc.users.email#">
														#rc.users.firstname# #rc.users.lastname#
													</option>
													</cfif>
												</cfloop>
											</select>	
										</div>								
										<button id="dac" class="btn btn-sm btn-info col-md-2 col-xs-4" onclick="dAddCustomer();">#getLabel("Add", #SESSION.languageId#)#</button>									
										<button class="btn btn-sm col-md-2 col-xs-4" onClick="bCloseAddCustomer()">#getLabel("Close", #SESSION.languageId#)#</button>
									</div>
								</cfif>	
								<div style="width:100%;max-height:125px; overflow: auto;" id="dUserCustomer">
									<ol>
										<cfloop query="rc.customer">
											<li>#rc.customer.firstname# - <a href="mailto: #rc.customer.email#"target="_top">#rc.customer.email#</a></li>
										</cfloop>	
									</ol>
								</div>								
							</div>						
									
						<div class="col-xs-6 col-sm-4 col-md-3" id="addAssignee" >
							<h4 class="green">Developer
								<cfif rc.users.recordCount GT 0>
								-<a style="cursor:pointer; color:##999;" onclick="addUser()"><small>Add</small></a>
								<cfelse>
									<small>no user</small>
								</cfif>
							</h4>
							<cfif rc.users.recordCount GT 0 >
							<div class="form-group hidden" id="dAddUser">
								<div class="col-md-8 col-xs-12 ">
									<select id="assignee" class="chosen-select" style="height: 35px;">
										<cfloop query="rc.users" >	
											<cfif rc.users.userTypeID eq 2 OR rc.users.userTypeID eq 4>
											<option value="#rc.users.userID#" id="o#rc.users.userID#">
												#rc.users.firstname# #rc.users.lastname#
											</option>
											</cfif>
										</cfloop>

									</select>
								</div>									
								<button id="dau" class="btn btn-sm btn-info col-md-2 col-xs-4" onclick="dAdd();">#getLabel("Add", #SESSION.languageId#)#</button>									
								<button class="btn btn-sm col-md-2 col-xs-4" onClick="bCloseAdd()">#getLabel("Close", #SESSION.languageId#)#</button>
							</div>
							</cfif>
							<div id="dUser" style="width:100%;">
								<ol>
									<cfloop query="rc.userPrj">
										<li class="dev-row" id="s#rc.userPrj.userID#">
											#rc.userPrj.firstname#
											<cfif SESSION.userType eq 3>
											<div class="action-buttons pull-right">
												<a><i class="small ui-icon ace-icon fa fa-trash-o red" style="cursor: pointer;" onclick="removeUser(#rc.userPrj.userID#,'#rc.userPrj.firstname#')"></i></a>
											</div>
											</cfif>
										</li>
									</cfloop>	
								</ol>														
							</div>
							
						</div>
					</div>
			</div>
		</div>
		<hr>		
		<div class="row col-md-12">
			<div class="row col-xs-12 col-sm-7 col-md-7">				
				<div id="ticket-table-2_wrapper" class="dataTables_wrapper form-inline no-footer">
				</br>
					<table class="table table-striped table-bordered table-hover dataTable no-footer" id="ticket-table-2" role="grid" aria-describedby="ticket-table-2_info">
						<thead>
							<tr role="row">
								<th>#getLabel("Title", #SESSION.languageId#)#</th>
								<th style="width:100px;">#getLabel("Due Date", #SESSION.languageId#)#</th>
								<th>#getLabel("Assignee", #SESSION.languageId#)#</th>
								<th>#getLabel("Reporter", #SESSION.languageId#)#</th>
								<th>#getLabel("Priority", #SESSION.languageId#)#</th>
								<th>#getLabel("Status", #SESSION.languageId#)#</th>
							</tr>
						</thead>

						<tbody id="body">
						</tbody>
						<tfoot id="footer" class="footer">
							<td  colspan="5">
								<input type="text" id="ticketTitle" placeholder="Ticket title" class="col-md-12">
							</td>
							<td style="padding-top: 12.5px;">
								<button disabled type="button" id="btn-create-ticket" class="btn btn-minier btn-info"  onclick="createTicket()"><i class="ace-icon glyphicon glyphicon-plus icon-on-right" ></i>Create ticket</button>
							</td>
						</tfoot>
					</table>
				</div>
				<br>
				<div class="col-md-12">
					<span id="loadmore" style="cursor:pointer" class="btn btn-sm btn-success">#getLabel("Load More", #SESSION.languageId#)#</span>
					<span class="btn btn-sm btn-info" style="cursor:pointer" onClick="goTicketListing();">#getLabel("Go Ticket Listing", #SESSION.languageId#)#</span>
				</div>
			</br>
			</br>			
			</div>
			<div class="col-xs-12 col-sm-5 col-md-5">

			    
				<div class="widget-box">
					<div class="widget-header widget-header-small">
						<h6 class="widget-title">
							Meeting minutes
						</h6>

						<div class="widget-toolbar">

							<a  data-action="reload">
								<i class="ace-icon fa fa-refresh"></i>
							</a>

							<a  data-action="fullscreen" class="orange2">
								<i class="ace-icon fa fa-expand"></i>
							</a>

							<a  title="Add new ">
								<i class="ace-icon fa fa-plus" data-icon-show="fa-plus" data-icon-hide="fa-minus" onClick="addMeeting()"></i>
							</a>

						</div>
					</div>

					<div class="widget-body">
						<div class="widget-main">
							<div id="addMeetingContain" class="hide">
								<div class="row">
									<div class="col-xs-12">
										<div id="formMeetingContent" class="wysiwyg-editor"  style="height: 150px; width: 100%"></div>
									</div>
									<div class="col-xs-12">
										<button class="btn btn-sm btn-warning pull-right" onClick="addMeeting()">#getLabel("Close",#SESSION.languageId#)#</button>
										<button class="btn btn-sm btn-info pull-right" onClick="saveNewMeeting()">#getLabel("Post", #SESSION.languageId#)#</button>
									</div>
								</div>
							</div>
							<div class="row">
								<div id="vMeetingContent" class="col-xs-12">
								</div>
								<a onClick='loadMoreMT()'style="cursor:pointer" id='aLoadMoreMT'>#getLabel("Load more", #SESSION.languageId#)#</a>
							</div>
						</div>
					</div>
				</div>    
			    		  
			</div>
		</div><!-- /.col -->
	</div><!-- /.row -->
	<hr>
	<!--- <div id="piechart"></div> --->
	<div class="row">
		<div class="col-xs-12">
			<div class="col-xs-12 col-md-6">
				<cfif rc.timeEntries.r NEQ 0>
				    <div id="pieChart">
				    </div>
				    <div style="z-index=10;">
				    	<span style="color=black"><b>#getLabel("Estimate time", #SESSION.languageId#)#:</b> <b style="color:##2f7ed8">#rc.estimateTime.e# #getLabel("hours", #SESSION.languageId#)#</b></span>
				   	 	</br>
				    	<span style="color=black"><b>#getLabel("Total entries time", #SESSION.languageId#)#:</b> <b style="color:##2f7ed8">#rc.timeEntries.r# #getLabel("hours", #SESSION.languageId#)#</b></span>
				    </div>	
				</cfif>
			</div>
			<cfif rc.lastmodule.recordCount gt 0>
				<div class="col-xs-12 col-md-6" id="splinechart"></div>
			</cfif>
		</div>
	</div>
	<hr>
	<cfif rc.timeEntries.r NEQ 0 or true>
		<div class="space-12"></div>
		<cfif arraylen(rc.monthlyCate)>
			<div class="row">
				<div class="col-xs-12" id="lineChart">
				</div>
			</div>

		</cfif>		
		<cfif arrayLen(rc.cateStatus)>
			<hr>
			<div class="row">
				<div class="col-xs-12  col-md-6" id="columnChart">
				</div>
				<div class="col-xs-12 col-md-6" id="hoursChart">
				</div>						
			</div>
		</cfif>
		<cfif arrayLen(rc.typeTicket) gt 0>
			<div class="row">
				<div class="col-xs-12" id="stackColumChart">
				</div>			
			</div>	
		</cfif>		
	</cfif>
<cfelse>
	#getLabel("You have no project to show", #SESSION.languageId#)#
</cfif>
</cfoutput>
<script type="text/javascript">	
	$(document).ready(function() {
		$("#prj").chosen({allow_single_deselect:true})
		.next().find("a.chosen-single").css("height",34); 
		load();
		pieChart();
		$("#loadmore").on("click",load);
		$('.wysiwyg-editor').ace_wysiwyg({
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
	});
	$(document).ready(function(){
		$("#customer").chosen({allow_single_deselect:true});
		$("#assignee").chosen({allow_single_deselect:true});
	})
	function dAdd()
	{
		var userID = $("#assignee").val();
		var name = $("#o"+userID.toString()).text();
		$("#dau").attr({
			'disabled':'disabled'
		})
		$.ajax({
            type: "POST",
            url: "/index.cfm/project.addUser",
            data: {
            	projectID : id,
            	userID : userID
            },
            success: function( data ) {
            	// remove option in select box, select add user 
				$("#o"+userID.toString()).remove();
				$('#assignee').trigger("chosen:updated");
				var t = $('<li\/>').attr({
					// 'class': 'tag',
					'id': + userID,
				}).html('<small>'+name+'</small>').append('<div class="action-buttons pull-right">\
											<a><i class="small ui-icon ace-icon fa fa-trash-o red" style="cursor: pointer;" onclick="removeUser('+userID+',\''+name+'\')"></i></a>\
										</div>');

				// alert(t);
				$("#dUser ol").append(t);

				
				// show add btn
				$("#dau").removeAttr("disabled");
            }
        });
	}

	function dAddCustomer()
	{
		var userID = $("#customer").val();
		var name = $("#oc"+userID.toString()).text();
		var email = $("#oc"+userID.toString()).attr('data-email');
		// console.log(email);
		// alert(userID);
		// alert(name);
		$("#dac").attr({
			'disabled':'disabled'
		})
		$.ajax({
	            type: "POST",
	            url: "/index.cfm/project.addUser",
	            data: {
	            	projectID : id,
	            	userID : userID
	            },
	            success: function( data ) {
	            	// remove option in select box, select add user 
					$("#oc"+userID.toString()).remove();
					$('#customer').trigger("chosen:updated");

					var t = $('<li\/>').attr({
						// 'class': 'tag',
						'id': + userID,
					}).html(name +'-'+'&nbsp;'+'<a href="mailto: '+email+' "target="_top">'+email+'</a>');

					// alert(t);
					$("#dUserCustomer ol").append(t);

					
					// show add btn

					$("##dac").removeAttr("disabled");
					 location.reload();
	            }
	        });
	}
	function removeUser(uid,name)
	{
		$.ajax({
            type: "POST",
            url: "/index.cfm/project.removeUser",
            data: {
            	projectID : id,
            	userID : uid
            },
            success: function( data ) {
            	
				$("#s"+uid.toString()).remove();
				$("#assignee").append('<option id="o'+uid+'" value="'+uid+'">'+name.toString()+'</option>')
								.trigger("chosen:updated");
            }
        });
	}
	
	function goTicketListing(){	
		var projectID = $("#prj").val();
		var baseURL = root+"/index.cfm/project/ticket_listing/?pId=" + projectID;
		window.location = baseURL;
	}
	function pieChart(){
		$.ajax({
            type: "POST",
            url: "/index.cfm/project.pieChart",
            datatype: "html",
             data: {
            	pID : projectID
            },
           
            success: function( data ) {
            	// console.log(data.result);
            	$('#pieChart').html(data);
            }
	    }).done(function(data){
	        	splineChart();
	        });
	}

	function splineChart(){
		$.ajax({
            type: "POST",
            url: "/index.cfm/project.splineChart",
            datatype: "html",
             data: {
            	pID : projectID
            },
           
            success: function( data ) {
            	// console.log(data.result);
            	$('#splinechart').html(data);
            }
	    }).done(function(data){
	        	lineChart();
	        });
	}

	function lineChart(){
		$.ajax({
            type: "POST",
            url: "/index.cfm/project.lineChart",
            datatype: "html",
             data: {
            	pID : projectID
            },
            success: function( data ) {
            	// console.log(data);
            	$('#lineChart').html(data);
            }
	    }).done(function(data){
	        	columnChart();
	        });
	}
	function columnChart(){
		$.ajax({
	            type: "POST",
	            url: "/index.cfm/project.columnChart",
	            datatype: "html",
	             data: {
	            	pID : projectID
	            },
	            success: function( data ) {
	            	// console.log(data);
	            	$('#columnChart').html(data);
	            }
	    }).done(function(data){
	        	hoursChart();
	        });
	}

	function hoursChart(){
		$.ajax({
	            type: "POST",
	            url: "/index.cfm/project.hoursChart",
	            datatype: "html",
	             data: {
	            	pID : projectID
	            },
	            success: function( data ) {
	            	// console.log(data);
	            	$('#hoursChart').html(data);
	            }
	    }).done(function(data){
	        	stackColumChart();
	        });
	}

	function stackColumChart(){
			$.ajax({
	            type: "POST",
	            url: "/index.cfm/project.stackColumChart",
	            datatype: "html",
	             data: {
	            	pID : projectID
	            },
	            success: function( data ) {
	            	// console.log(data);
	            	$('#stackColumChart').html(data);
	            }
	    })
	}
	function changePrj()
	{
		var projectID = $("#prj").val();
		var baseURL = root+"/index.cfm/project/?pId=" + projectID;
		window.location = baseURL;
	}
	var uf = true ;
	function addUser()
	{
		$("#dAddUser").removeClass("hidden",function(){
			if(uf){
				var w = $("#assignee").parent().width();
				$("#assignee").next().css("width",w);
				$("#assignee").next().find("a.chosen-single").css("height","34px");
				uf = false ;
			}
		});
	}
	var cf = true ;
	function addUserCustomer()
	{
		$("#dAddCustomer").removeClass("hidden",function(){
			if(cf){
				var w = $("#customer").parent().width();
				$("#customer").next().css("width",w);
				$("#customer").next().find("a.chosen-single").css("height","34px");
				cf = false ;
			}
		});
	}

	function bCloseAdd()
	{		
		$("#dAddUser").addClass("hidden");
	}
	function bCloseAddCustomer()
	{		
		$("#dAddCustomer").addClass("hidden");
	}
	function dMeetingClose(){
		$("#MtContent").addClass("hidden");
	}	
	function addMeeting(){
		$("#addMeetingContain").toggleClass('hide');
	}
	function load(){
		if(page ==-1){
			$("#loadmore").addClass("hide");
		}else{
			$.ajax({
	            type: "POST",
	            url: "/index.cfm/project.loadmore",
	            data: {
	            	projectID : id,
	            	page : page
	            },
	            success: function( data ) {
	            	if(data.length==0){
	            		$("#loadmore").addClass("hide");
	            		if(page==0){
	            			$("#ticket-table-2").html("No ticket to show!");
	            		}
						page =-1;
					}else{
						var length=data.length<11?data.length:10;
						for (var i = 0; i <length; i++) {
							if( data[i].over > 0 && (data[i].statusID == 1 || data[i].statusID == 2 || data[i].statusID == 4) && data[i].priorityID != 4)
							{
								$("#body").append('\
									<tr>\
										<td><a href="/index.cfm/ticket?id='+data[i].code+'"><span class="green">'+data[i].code+'</span> &nbsp;'+data[i].title+'<span class="over">'+data[i].over+'d </span></a><span class="pull-right epic epic-'+data[i].epicColor+'">'+(data[i].epicName==''?'none':data[i].epicName)+'</span></td>\
										<td>'+data[i].dueDate+'</td>\
										<td>'+data[i].assignee+'</td>\
										<td>'+data[i].reporter+'</td>\
										<td style="color:'+data[i].pColor+'">'+data[i].priority+'</td>\
										<td><span class="label label-'+data[i].sColor+'"><cfoutput>#getLabel("'+data[i].status+'", #SESSION.languageId#)#</cfoutput></span></td>\
									</tr>');
							}else{
								$("#body").append('\
									<tr>\
										<td><a href="/index.cfm/ticket?id='+data[i].code+'"><span class="green">'+data[i].code+'</span> &nbsp;'+data[i].title+'</a><span class="pull-right epic epic-'+data[i].epicColor+'">'+(data[i].epicName==''?'none':data[i].epicName)+'</span></td>\
										<td>'+data[i].dueDate+ '</td>\
										<td>'+data[i].assignee+'</td>\
										<td>'+data[i].reporter+'</td>\
										<td style="color:'+data[i].pColor+'">'+data[i].priority+'</td>\
										<td><span class="label label-'+data[i].sColor+'"><cfoutput>#getLabel("'+data[i].status+'", #SESSION.languageId#)#</cfoutput></span></td>\
									</tr>');
							}
	            		};
						page =page+1;
						if(data.length<=10){
							$("#loadmore").addClass("hide");
						}
	            	}
	            }
	        }).done(function(data){
	        	loadMoreMT();
	        });
		}
	}

	function deleteMeetingByClick(meetingID){
		$.ajax({
            type: "POST",
            url: "/index.cfm/project.deleteMeeting",
            data: {
            	meetingID: meetingID		            	
            },
            success: function( data ) {	
            	if(data.success){
					$("#metting_"+meetingID+"").remove();
				}else{
					console.log(data);
					alert("an error for add comment");
				}
            }
        });
	}

	function showEditMeeting(meetingID)
	{
		var valueMetting = $('#metting_'+meetingID+' .panel-main').html();
		$('#metting_'+meetingID+' .panel-main').addClass("hide");
		$('#metting_'+meetingID+' .panel-body').append('\
			<div class="panel-edit">\
				<div class="row" style="margin-top:-10px">\
					<div class="col-xs-12" style="padding : 0px">\
						<div class="wysiwyg-editor"  style="height: 150px; width: 100%">'+valueMetting+'</div>\
					</div>\
					<div class="col-xs-12">\
						<button class="btn btn-sm btn-warning pull-right" onClick="closeEditMeeting('+meetingID+')">'+golbaltext.cancel+'</button>\
						<button class="btn btn-sm btn-info pull-right" onClick="editMeeting('+meetingID+')">'+golbaltext.save+'</button>\
					</div>\
				</div>\
			</div>').find('.wysiwyg-editor').ace_wysiwyg({
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
	}

	function editMeeting (meetingID)
	{
		var newMeetingContent = $('#metting_'+meetingID+' .wysiwyg-editor').html() ;
		if($.trim(newMeetingContent) !== ''){
			$.ajax({
	            type: "POST",
	            url: "/index.cfm/project.editMeeting",
	            data: {
	            	meetingID: meetingID,
	            	comment : $('#metting_'+meetingID+' .wysiwyg-editor').html(),			            	
	            },
	            success: function( data ) {	
	            	if(data.success){
	            		$('#metting_'+meetingID+' .panel-main').html(newMeetingContent);
						closeEditMeeting(meetingID);
					}else{
						alert("an error for add comment");
					}
	            }
	        });
	    }else{
	    	alert('Missing meeting content!');
	    }
	}

	function closeEditMeeting(meetingID)
	{
		$('#metting_'+meetingID+' .panel-edit').remove();
		$('#metting_'+meetingID+' .panel-main').removeClass("hide");
	}


	function saveNewMeeting() {		
		if($.trim($('#formMeetingContent').html())==""){
			alert("please insert requite field!");
		}else{				
			$.ajax({
	            type: "POST",
	            url: "/index.cfm/project.addWeeklyMeeting",
	            data: {
	            	comment : $('#formMeetingContent').html(),		            	
	            	user: userIDSS,
	            	projectID: projectID		            	
	            },
	            success: function( data ) {		            	
	            	$('#editor').html('');
	            	$('#formMeetingContent').html("");
	            	if(data.success){
						$('#vMeetingContent').prepend('\
							<div class="panel panel-default" id="metting_'+data.meetingID+'">\
								<div class="panel-heading">\
									<a class="accordion-toggle pull-left">\
										<i class="ace-icon fa fa-user bigger-130"></i>\
										&nbsp;'+data.userName+'&nbsp;&nbsp;'+data.date+'\
									</a>\
									<span class="ui-icon ace-icon fa fa-pencil pull-right" style="cursor: pointer;" onClick="showEditMeeting('+data.meetingID+')"></span>\
									<span class="ui-icon ace-icon fa fa-trash-o red pull-right" style="cursor: pointer;" onclick="deleteMeetingByClick('+data.meetingID+')"></span>\
								</div>\
								<div class="panel-collapse collapse in">\
									<div class="panel-body">\
										<div class="panel-main">\
											<p style="word-wrap: break-word;">\
											'+data.comment+'\
											</p>\
										</div>\
									</div>\
								</div>\
							</div>');
					}else{
						alert("an error for add comment");
					}
	            }
	        });
		}
	}

	function loadMoreMT(){
		if(pagem >= 0)
		$.ajax({
	        type: "POST",
	        url: "/index.cfm/project.loadMeeting",
	        data: {
	        	page : pagem	        	
	        },
	        success: function( data ) {
	        	if(data.length ==0){
	        		pagem=-1;
	        		$("#aLoadMoreMT").remove();
	        	}else{
	        		for(var i=0;i<data.length ;i++){
					$('#vMeetingContent').append('\
						<div class="panel panel-default" id="metting_'+data[i].meetingID+'">\
							<div class="panel-heading">\
								<a class="accordion-toggle pull-left">\
									<i class="ace-icon fa fa-user bigger-130"></i>\
									&nbsp;'+data[i].firstname+'&nbsp;&nbsp;'+data[i].date+'\
								</a>\
								<span class="ui-icon ace-icon fa fa-pencil pull-right" style="cursor: pointer;" onClick="showEditMeeting('+data[i].meetingID+')"></span>\
								<span class="ui-icon ace-icon fa fa-trash-o red pull-right" style="cursor: pointer;" onclick="deleteMeetingByClick('+data[i].meetingID+')"></span>\
							</div>\
							<div class="panel-collapse collapse in">\
								<div class="panel-body">\
									<div class="panel-main">\
										'+data[i].meetingContent+'\
									</div>\
								</div>\
							</div>\
						</div>');
					};
					if(data.length < 5){
		        		pagem=-1;
		        		$("#aLoadMoreMT").remove();
					}else{pagem++;}
				}
	        }
	        
	    }).done(function(data){
	        	splineChart();
	        });
	}
	//quickly create ticket
	$(document).on('keyup','#ticketTitle',function(){
		var sTicketTitle = $(this).val();
		var strimTitle = $.trim(sTicketTitle).split("");		
		if( strimTitle == ''){
			$('#btn-create-ticket').prop('disabled',true);
		}else{
			$('#btn-create-ticket').prop('disabled',false);
		}
	});
	function createTicket(){
	var title = $('#ticketTitle').val();
	$.ajax({
		type: 'POST',
		url: '/index.cfm/project.create',
		data: {
			title: title
		},
	success: function (data) {				
				if(data)
				{
					alert("Ticket has been created !");	
					jQuery("#ticketTitle").focus( function()
						{ 
						  $(this).val("");
						});				
				}
				else{
					alert(data.message);
				}
			}
	});
}
</script>
