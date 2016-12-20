<!--- <cfdump eval = rc.dtag abort> --->

<style type="text/css">
.chosen-container {
	width: 100% !important;
}
.hide {
	display: none;
}
.wysiwyg-editor{
	overflow: auto;
}
</style>
<script src="/ACEAdmin/assets/js/date-time/bootstrap-datepicker.min.js"></script>
<cfoutput>
<div class="row clearfix">
	<div class="col-md-12" style="border-bottom:2px ##428bca solid;">
		<h1 class="blue">#getLabel("Create Ticket", #SESSION.languageId#)#</h1>
	</div>
</div>
<cfif rc.flag EQ true>
	<span class="row col-md-12 alert alert-block alert-danger">An Error !, Can't Not create ticket!<br>#rc.message#
	<button type="button" class="close" data-dismiss="alert">
		<i class="ace-icon fa fa-times"></i>
	</button>
	</span>
	<cfset rc.flag = false>
</cfif>
<div class="row clearfix" style="margin-top:20px;">
	<div class="col-md-12">		
			<div class="row clearfix">
				<form class="form-horizontal" role="form" method="post" enctype="multipart/form-data" id='myform'>
				<div class="col-md-8">
					<div class="form-group">
						<label class="col-md-2 col-xs-4 control-label no-padding-right" for="form-field-1"> #getLabel("Project", #SESSION.languageId#)# </label>
						<div class="col-md-4 col-xs-8">
							<select class="col-xs-12 chosen-select" id="selectProject" name="project" onChange='projectChange()'>
								<cfloop query=#rc.projects#>
									<cfif structKeyExists(SESSION,"focuspj")>
										<cfif SESSION.focuspj eq rc.projects.projectID>
											<option value="#rc.projects.projectID#" selected >#rc.projects.projectName#</option>
										<cfelse>
											<option value="#rc.projects.projectID#" >#rc.projects.projectName#</option>
										</cfif>
									<cfelse>
										<option value="#rc.projects.projectID#" >#rc.projects.projectName#</option>
									</cfif>
								</cfloop>
							</select>
						</div>
						<label class="col-md-1 col-xs-2 control-label no-padding-right" for="form-field-1"> #getLabel("Type", #SESSION.languageId#)# </label>
						<div class="col-md-2 col-xs-4">
							<select name="selectType" class="col-xs-12 chosen-select" id="selectType" >
								<cfloop query=#rc.types#>
									<cfif rc.types.ticketTypeID eq 4>
										<cfif  SESSION.userType eq 1>
											
										<cfelse>
											<option value=#rc.types.ticketTypeID# >#rc.types.typeName#</option>
										</cfif>	
									<cfelse>
										<option value=#rc.types.ticketTypeID# >#rc.types.typeName#</option>	
									</cfif>
								</cfloop>
							</select>
						</div>
						<label class="col-md-2 col-xs-4 control-label no-padding-right" for="form-field-1"> #getLabel("Estimate Point", #SESSION.languageId#)# </label>
						<div class="col-md-1 col-xs-2">
							<input name="point" type="text" class="col-md-12 selectbox" id="point" value="3" />
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 col-xs-4 control-label no-padding-right" for="form-field-1"> #getLabel("Sprint", #SESSION.languageId#)# </label>
						<div class="col-md-4 col-xs-8">
							<select class="col-xs-12 chosen-select" id="selectSprint" name="sprint">
							</select>
						</div>
						<label class="col-md-2 col-xs-4 control-label no-padding-right" for="form-field-1"> #getLabel("Epic", #SESSION.languageId#)# </label>
						<div class="col-md-4 col-xs-8">
							<div class="input-group">
								<select class="col-xs-10 chosen-select" id="selectEpic" name="epic">
									<option value=0 >Select Epic...</option>
								</select>
								<span class="input-group-btn">
									<button type="button" id="btnAddEpic" class="btn btn-sm btn-success" style="height:30px;"><i class="ace-icon fa fa-plus"></i></button>
								</span>
							</div>
						</div>
					</div>
					<div class="form-group" id='groupTitle'>
						<label class="col-md-2 col-xs-4 control-label no-padding-right" for="form-field-1"> #getLabel("Title", #SESSION.languageId#)# </label>

						<div class="col-md-10 col-xs-8">
							<input type="text" name="title" id="title" class="col-xs-12 col-md-12" onBlur='validateTitle()'  />
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 col-xs-4 control-label no-padding-right" for="form-field-1"> #getLabel("Description", #SESSION.languageId#)# </label>

						<div class="col-md-10 col-xs-8">
							<div id="editor" class="wysiwyg-editor"><cfif structKeyExists(rc,"ticketinfo")>#rc.ticketinfo.description#</cfif></div>
							<input type="hidden" name="description" id='description' value=""/>
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 col-xs-4 control-label no-padding-right" for="form-field-1"> #getLabel("Assignee", #SESSION.languageId#)# </label>
						<div class="col-md-4 col-xs-8">
							<select class="col-xs-12 chosen-select" id="selectAssignee" name="selectAssignee">
							</select>
						</div>
						<div class="col-md-4 col-xs-6" style="height: 35px;padding: 5px;">
							<input id="assigntome" class="ace ace-switch ace-switch-5" type="checkbox"  name="assigntome">
							<span class="lbl middle">&nbsp;&nbsp;#getLabel("Assign to me", #SESSION.languageId#)#</span>
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 col-xs-4 control-label no-padding-right" for="form-field-1"> #getLabel("Due Date", #SESSION.languageId#)# </label>
						<div class="col-md-4 col-xs-8">
							<input class="date-picker col-md-12 col-xs-8" id="ticketDueDate" name="ticketDueDate" type="text" data-date-format="yyyy-mm-dd" value="#DateFormat(now(),"yyyy-mm-dd")#" />
						</div>
					</div>
					<cfif arrayLen(rc.createdTickets) gt 0>
						<div class="form-group">
							<label class="col-md-2 col-xs-4 control-label no-padding-right" for="form-field-1"> #getLabel("Created tickets", #SESSION.languageId#)# </label>
							<div class="col-md-4 col-xs-8">
								<ul>
									<cfloop array=#rc.createdTickets# index="created">
										<li>
											<a href="#created#" target="_blank">#created#</a>
											<input type="hidden" name="created[]" value="#created#"/>
										</li>
									</cfloop>
								</ul>
							</div>
						</div>
					</cfif>
						<input id="ListFileUpload" type="hidden" name="ListFileUpload" value="">
						<input id="dcontinue1" name="dcontinue"  type="hidden" value="on">
				</div>
				</form>
				<div class="col-md-4 col-xs-12">
					<form class="form-horizontal" name="fileupload" id="fileupload" enctype="multipart/form-data" method="post" action="/upload/up.cfc?method=uploadFile&RequestTimeout=3600">
						<div class="row fileupload-buttonbar">
							<div class="span7">
								<span class="btn btn-success fileinput-button">
								<i class="icon-plus icon-white"></i>
								<span>#getLabel("Add files", #SESSION.languageId#)#</span>
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
						<table id="tblimg" role="presentation" class="table col-md-12">
							<tbody class="files" data-toggle="modal-gallery" data-target="##modal-gallery"></tbody>
						</table>
					</form>
				</div>
			</div>
			<div class="row clearfix">
				<div class="col-xs-12">
					<div class="clearfix form-actions">
						<div class=" col-xs-12">
							<label class="col-md-1 col-xs-2 control-label no-padding-right" for="form-field-1"> #getLabel("Add another", #SESSION.languageId#)# </label>
							<div class="col-md-1 col-xs-2">
								<input id="dcontinue" name="dcontinue" class="ace ace-switch ace-switch-5" type="checkbox" checked>
								<span class="lbl middle"></span>
							</div>
							&nbsp; &nbsp; &nbsp;
							<button class="btn btn-info" type="submit" id='btn-submit'>
								<i class="ace-icon fa fa-check bigger-110"></i>
								#getLabel("Submit", #SESSION.languageId#)#
							</button>

							&nbsp; &nbsp; &nbsp;
							<button class="btn" type="reset">
								<i class="ace-icon fa fa-undo bigger-110"></i>
								#getLabel("Reset", #SESSION.languageId#)#
							</button>
						</div>
					</div>
				</div>
			</div>
	</div>
</div>
<!--- modal add epic --->
<div class="modal fade" id="modalNewEpic" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  	<div class="modal-dialog">
	    <div class="modal-content alert-info">
	      	<div class="modal-header alert-info">
	        	<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">#getLabel("Close", #SESSION.languageId#)#</span></button>
	        	<h3 class="modal-title" id="modal-title-new">#getLabel("New Epic", #SESSION.languageId#)#</h3>
	        	<h3 class="modal-title hide" id="modal-title-edit">#getLabel("Edit Epic", #SESSION.languageId#)#</h3>
	      	</div>
	      	<div class="modal-body">
	      		<div class="alert alert-warning" id="errorMessage">
	      		</div>
				<div class="row form-group ">
					<label class="col-md-3 control-label">#getLabel("Epic Name", #SESSION.languageId#)#</label>
					<div class="col-md-9">
						<input id='epicname' name='epicname' placeholder='Epic Name' class="form-control"/>
					</div>
				</div>
				<div class="row form-group">
					<label class="col-md-3 control-label">#getLabel("Description", #SESSION.languageId#)#</label>
					<div class="col-md-9">
						<textarea id="epicDescription" name="epicDescription" class="form-control" placeholder="Epic description!" rows="4"></textarea>
					</div>
				</div>
				<div class="row form-group">
					<label class="col-md-3 control-label">#getLabel("Priority", #SESSION.languageId#)#</label>
					<div class="col-md-9">
						<input id="epicPriority"type="text" placeholder="Epic priority">
						<p style="color: red">Please input number greater than zero, large number will be high priority!</p>
					</div>
				</div>
	      	</div>
	      	<div class="modal-footer">
	        	<button type="button" class="btn btn-default" data-dismiss="modal">#getLabel("Close", #SESSION.languageId#)#</button>
	        	<button id="btnNewEpic" type="button" class="btn btn-info">#getLabel("Save changes", #SESSION.languageId#)#</button>
	      	</div>
	    </div>
  	</div>
</div>
</cfoutput>
<cfinclude template="upfile.cfm"/>
<script src="/ACEAdmin/assets/js/bootstrap-wysiwyg.min.js"></script>
<script type="text/javascript">
jQuery(function($) {
	$('.chosen-select').chosen();
	//resize the chosen on window resize
	$(window).on('resize.chosen', function() {
		var w = $('.chosen-select').parent().width();
		$('.chosen-select').next().css({'width':w});
	}).trigger('resize.chosen');

	$('#epicPriority').on("keydown", function(event){
	    var keyCode = event.which;	    
	    if(!((keyCode > 48 && keyCode < 58) ||  (keyCode > 96 && keyCode < 106) ||  keyCode == 08 || (keyCode == 96 && +$('#epicPriority').val()>0)|| (keyCode == 48 && +$('#epicPriority').val()>0) || ((keyCode == 16) || (keyCode == 36) || (keyCode == 37) || (keyCode == 39) || (keyCode == 35)|| (keyCode == 46)|| (keyCode == 9)|| (keyCode == 16)|| (keyCode == 13))
	    	)){
	        event.preventDefault();
	    }
	});
	$('#editor').ace_wysiwyg({
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
		
	}).prev().addClass('wysiwyg-style2');

});
$(document).ready(function(){
	$("#ticketDueDate").datepicker({
					autoclose: true,
					todayHighlight: true
				});
	// $("#ticketDueDate").val('DateFormat(rc.ticketinfo.dueDate,"yyyy-mm-dd")#');
	$('#errorMessage').addClass('hide');
	$("#title").focus();
	$('#myform').on('reset', function() {
		$('#editor').empty();
	});

	$("#dcontinue").on("change",function(){
		if($(this).is(":checked")){
			$("#dcontinue1").val("on");
		}else{
			$("#dcontinue1").val("off");
		}
	});
	$("#assigntome").on("change",function(){
		if($(this).is(":checked")){
			$("#selectAssignee").prop("disabled",true);
		}else{
			$("#selectAssignee").prop("disabled",false);
		}
	});
	projectChange();
	$("#btnAddEpic").on("click",function(){
		$("#epicname").val('');
		$('#epicDescription').val('');
		$("#modalNewEpic").modal("show");
	});
	$("#btnNewEpic").on("click",function(){
		$('#errorMessage').addClass('hide');
		var epicName = $("#epicname").val();
		var epicDescription = $('#epicDescription').val();
		var epicPriority = $('#epicPriority').val();
		if($.trim(epicName) !== ''){
			$.ajax({
	            type: "POST",
	            url: "/index.cfm/home:project.editEpic",
	            data: {
	            	isNew : true,
	            	epicName: epicName,
	            	epicDescription: epicDescription,
	            	curProject: $("#selectProject").val(),
	            	epicPriority: epicPriority
	            },
	            success: function( data ) {
	            	if(data.success){
	            		$("#selectEpic").append('<option value="'+data.eid+'">'+epicName+'</option>');
	            		$("#modalNewEpic").modal("hide");
	            	}else{
	            		$('#errorMessage').text(data.message).removeClass('hide');
	            	}
	            }
			})
		}else{
			$('#errorMessage').text('Missing epic name!').removeClass('hide');
		}
	});
})
	validateTitle();
	$("#btn-submit").on("click",function(){
		if($('#title').val() != ""){
			$('#description').val($('#editor').html());	
			$('#myform').submit();
		}else{
			alert('Please Insert title for ticket!');
			return false;
		}
	});
	function validateTitle(){
		if($('#title').val() == ""){
			$('#groupTitle').addClass('has-error');
			document.getElementById("btn-submit").disabled=true;
		}else{
			$('#groupTitle').removeClass('has-error');
			document.getElementById("btn-submit").disabled=false;
		}		
	}
	function projectChange(){
		var id=$("#selectProject").val();
		$.ajax({
	        url: '/index.cfm/ticket.getSprintOfProject',
	        method:'POST',
	        dataType: 'json',
	        data: {
	        	project: id
	        },
	        success: 	function(data) {
	        	$("#selectAssignee").find("option").remove().end();
	        	$("#selectAssignee").html('<option value=0 >Default select</option>');
	        	$("#selectSprint").find("option").remove().end();  	
	        	$("#selectEpic").html('<option value=0 >Select Epic...</option>');
				
				for (var i = 0;i< data.SPRINTS.length ; i++) {
				if(data.DONE !== '1')
					if(data.STATUS == 1){
						$("#selectSprint").append($('<option></option>')
       					.attr('value', data.SPRINTS[i].moduleID)
       					.attr('checked','checked')
       					.text(data.SPRINTS[i].moduleName));
					}else{
						$("#selectSprint").append($('<option></option>')
       					.attr('value', data.SPRINTS[i].moduleID)
       					.text(data.SPRINTS[i].moduleName));
					}
				};
				for(var j = 0;j< data.EPIC.length ; j++){
					$("#selectEpic").append($('<option></option>')
   					.attr('value', data.EPIC[j].epicID)
   					.text(data.EPIC[j].epicName));
				}
				for(var k = 0;k< data.USERS.length ; k++){
					$("#selectAssignee").append($('<option></option>')
   					.attr('value', data.USERS[k].userID)
   					.text(data.USERS[k].fullname));
				}
				$('.chosen-select').trigger("chosen:updated");
	        }
	    });
	}
</script>

