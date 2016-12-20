<cfif structKeyExists(rc,'ticketinfo')>
<!--- <cfdump eval = rc.dtag abort> --->
<style type="text/css">
.height100{
	height:100%;
}
.hide {
	display: none;
}
</style>
<script type="text/javascript">
$(function(){
$("#showmore").on("click", function(){
	var that = $(this);
	var text = that.text();
	$("#moreinfo").toggle("slow");
	that.text(text == "Hide" ? "<cfoutput>#getLabel("More info", #SESSION.languageId#)#</cfoutput>" : "<cfoutput>#getLabel("Hide", #SESSION.languageId#)#</cfoutput>");
	return false;
});
$("#hide").click(function(){
	$("#moreinfo").addClass('hide');
	$("#showmore").removeClass('hide');
	return false;
})


});
</script>
<!--- modal input file --->
<cfoutput>
<cfset	local.oChar = new api.character()>
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only"> #getLabel("Close", #SESSION.languageId#)# </span></button>
				<h4 class="modal-title" id="myModalLabel">#getLabel("Attach files", #SESSION.languageId#)#</h4>
			</div>
			<div class="modal-body">
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
					<table id="tblimg" role="presentation" class="table table-striped">
						<tbody class="files" data-toggle="modal-gallery" data-target="##modal-gallery"></tbody>
					</table>
			</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">#getLabel("Close", #SESSION.languageId#)#</button>
				<button type="button" class="btn btn-primary" data-dismiss="modal">#getLabel("Save changes", #SESSION.languageId#)#</button>
			</div>
		</div>
	</div>
</div>
<!--- end modal input file --->

<div class="row clearfix">
	<div class="col-md-12" style="border-bottom:2px ##428bca solid;">
		<cfif structKeyExists(rc,"ticketinfo") >
			<h1 class="blue">#getLabel("Edit Ticket", #SESSION.languageId#)#</h1>
		<cfelse>
			<h1 class="blue">#getLabel("Create Ticket", #SESSION.languageId#)#</h1>
		</cfif>
	</div>
</div>
<cfif rc.flag EQ true>
	<span class="row col-md-12 alert alert-block alert-danger">An Error !, Can't Not edit ticket!<br>#rc.message#
	<button type="button" class="close" data-dismiss="alert">
		<i class="ace-icon fa fa-times"></i>
	</button>
	</span>
	<cfset rc.flag = false>
</cfif>
<cfif structKeyExists(rc,'errorMessage')>
	<div class='row alert alert-danger'>
		#rc.errorMessage#
	</div>
</cfif>
<cfif structKeyExists(rc,'ticketinfo')>
<div class="row clearfix" style="margin-top:20px;">
	<div class="col-md-12">		
		<form class="form-horizontal" role="form" method="post" enctype="multipart/form-data" id='myform'>
			<div class="row clearfix">
				<div class="col-md-8">	
					<div class="form-group">
						<label class="col-md-2 control-label no-padding-right" for="id-date-picker-1">#getLabel("Upload Files", #SESSION.languageId#)#</label>
						<div class="col-md-8">
							<div class="control-group">
								<button type="button" class="btn btn-info btn-md" data-toggle="modal" data-target="##myModal">
									#getLabel("Choose File", #SESSION.languageId#)#
								</button>
								<cfinclude template="upload.cfm"/>
								<input id="ListFileUpload" type="hidden" name="ListFileUpload" value="">
							</div>						
						</div>

						<div class="col-md-2 text-right">
							<button type="button" class="btn btn-purple btn-md btn-round" id ="showmore">
								#getLabel("Hide", #SESSION.languageId#)#
							</button>
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label no-padding-right" for="form-field-1"> #getLabel("Project", #SESSION.languageId#)# </label>
						<div class="col-md-5">
							<select class="col-md-12 height100" id="selectProject" name="project">
								<cfloop query=#rc.URLproject#>
									<option value="#rc.URLproject.projectID#" selected >#rc.URLproject.projectName#</option>
								</cfloop>
							</select>
						</div>
						<label class="col-md-2 control-label no-padding-right" for="form-field-1"> #getLabel("Type", #SESSION.languageId#)# </label>
						<div class="col-md-3">
							<select name="selectType" class="col-md-12 height100" id="selectType" onchange="changePaid();">
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
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label no-padding-right" for="form-field-1"> #getLabel("Cc", #SESSION.languageId#)# </label>
						<div class="col-md-5">
							<input type="text" name="cc" id="cc" class="col-xs-12 col-md-12" <cfif structKeyExists(rc,"ticketinfo")>value='#replace(rc.ticketinfo.cc,"'","\'","all")#' </cfif> />
						</div>
						<label class="col-md-2 control-label no-padding-right" for="form-field-1"> #getLabel("Priority", #SESSION.languageId#)# </label>
						<div class="col-md-3">
							<select name="selectPriority" id="priority" class="col-md-12 height100">
								<cfloop query=#rc.priority#>
									<option value=#rc.priority.priorityID# style="background:#rc.priority.color#" <cfif #rc.priority.priorityName# EQ "Normal">selected</cfif>>#rc.priority.priorityName#</option>
								</cfloop>
							</select>
						</div>
					</div>
					<div class="form-group" id='groupTitle'>
						<label class="col-md-2 control-label no-padding-right" for="form-field-1"> #getLabel("Title", #SESSION.languageId#)# </label>

						<div class="col-md-10">
							<input type="text" name="title" id="title" class="col-xs-12 col-md-12" onBlur='validateTitle()' <cfif structKeyExists(rc,"ticketinfo")>value="#local.oChar.replaceSpecialCharacter(rc.ticketinfo.title)#" </cfif>  />
						</div>
					</div>
					<div class="form-group">
						<label class="col-md-2 control-label no-padding-right" for="form-field-1"> #getLabel("Description", #SESSION.languageId#)# </label>

						<div class="col-md-10">
							<div id="editor" class="wysiwyg-editor"><cfif structKeyExists(rc,"ticketinfo")>#rc.ticketinfo.description#</cfif></div>
							<input type="hidden" name="description" id='description' value=""/>
						</div>
					</div>	
					<div class="form-group" >
						<label class="col-md-2 control-label no-padding-right" for="form-field-1"> #getLabel("Tags", #SESSION.languageId#)# </label>

						<div class="col-xs-10" >
							<div class="col-xs-12" style="border: solid 1px ##d5d5d5;">
								<div id="tagcon" class="tags" style="border: none; width:90%;">
									<cfif structKeyExists(rc, "dtag")>
									<cfloop query="rc.dtag">
										<span id="tag#rc.dtag.tagId#" class="tag">#rc.dtag.tagName#<button type="button" class="close" onclick='removeTag(#rc.dtag.tagId#,#rc.ticketinfo.ticketID#)'>x</button></span>
									</cfloop>
									</cfif>
								</div>
								<input type="hidden" name="dtags" id="dtags" value=""/>
								<input type="text" name="tag" id="tag" class="typeahead" placeholder="Enter a tag" style="border: none;"/>
							</div>
						</div>
					</div>
					<!--- <div class="form-group">
						<label class="col-sm-2 control-label no-padding-right" for="form-field-tags">Tag input</label>
						<div class="col-sm-10">
							<div class="inline">
								<input type="text" name="tags" id="form-field-tags" value="#rc.tagtest#" placeholder="Enter tags ..." />
							</div>
						</div>
					</div> --->
				</div>
				<div class="col-md-4">
					<div class="row clearfix" id="moreinfo" >
						<div class="col-md-12">
							<div class="form-group">
								<label class="col-md-3 control-label no-padding-right" for="form-field-1"> #getLabel("Sprint", #SESSION.languageId#)# </label>
								<div class="col-md-9">
									<select name="sprint" class="col-md-8 height100" id="selectSprint" >
									</select>
								</div>
							</div>
							<div class="form-group">
								<label class="col-md-3 control-label no-padding-right" for="form-field-1"> #getLabel("Epic", #SESSION.languageId#)# </label>
								<div class="col-md-9">
									<select name="epic" class="col-md-8 height100" id="selectEpic" >
										<option value=0 >Select Epic...</option>
									</select>
									<button type="button" id="btnAddEpic" class="btn btn-sm btn-success"><i class="ace-icon fa fa-plus"></i></button>
								</div>
							</div>
							<div class="form-group">
								<label class="col-md-3 control-label no-padding-right" for="form-field-1"> #getLabel("Estimate Point", #SESSION.languageId#)# </label>
								<div class="col-md-9">
									<input type="text" name="point" id="point" class="col-md-8" placeholder="#getLabel("Point", #SESSION.languageId#)#" value="#rc.ticketinfo.point neq ''?rc.ticketinfo.point:'3'#" <cfif SESSION.userType NEQ 3 AND SESSION.userID neq rc.URLproject.projectLeadID AND rc.ticketinfo.reportedByUserID neq SESSION.userID >disabled</cfif> />
								</div>
							</div>
						</div>
						<div class="col-md-12">

							<div class="form-group">
								<label class="col-md-3 control-label no-padding-right" for="form-field-1"> #getLabel("Assignee", #SESSION.languageId#)# </label>

								<div class="col-md-9">
									<select class="col-md-8 height100" name="assignee" id="selectAssignee">
									</select>
								</div>
							</div>
							<div class="form-group">
								<label class="col-md-3 control-label no-padding-right" for="form-field-1"> #getLabel("Tester", #SESSION.languageId#)# </label>

								<div class="col-md-9">
									<select class="col-md-8 height100" name="tester" id="selectTester">
										<option value="0">Choose tester</option>
									</select>
								</div>
							</div>
							<div class="form-group">
								<label class="col-md-3 control-label no-padding-right" for="form-field-1"> #getLabel("Due Date", #SESSION.languageId#)# </label>
								<div class="col-md-9">
									<input class=" date-picker col-md-8" id="dueDate" name="dueDate" type="text" data-date-format="yyyy-mm-dd" value="#DateFormat(now(),"yyyy-mm-dd")#" />
								</div>
							</div>
							<div class="form-group">
								<label class="col-md-3 control-label no-padding-right" for="form-field-1"> #getLabel("Reporter", #SESSION.languageId#)# </label>
								<div class="col-md-9">
									<select class="col-md-8 height100" name="reporter"id="selectReporter" #SESSION.userType neq 3?'disabled':''#>
									</select>
								</div>
							</div>
							<div class="form-group">
								<label class="col-md-3 control-label no-padding-right" for="form-field-1"> #getLabel("Report Date", #SESSION.languageId#)# </label>
								<div class="col-md-9">
									<input class=" date-picker col-md-8" id="reportDate" name="reportDate" type="text" data-date-format="yyyy-mm-dd"value="#DateFormat(now(),"yyyy-mm-dd")#" #SESSION.userType neq 3?'disabled':''#  />
								</div>
							</div>
							<div class="form-group">
								<label class="col-md-3 control-label no-padding-right" for="form-field-1"> #getLabel("Version", #SESSION.languageId#)#</label>
								<div class="col-md-9">
									<select class="col-md-8 height100" id="selectVersion" name="version">
									</select>
								</div>
							</div>
							<div class="form-group">
								<label class="col-md-3 control-label no-padding-right" for="form-field-1"> #getLabel("Paid", #SESSION.languageId#)# </label>
								<div class="col-md-1">
									<input id="paid" name="paid" class="ace ace-switch ace-switch-5" type="checkbox">
									<span class="lbl middle"></span>
								</div>
								<!--- <label class="col-md-3 control-label no-padding-right" for="form-field-2"> Internal: </label>
								<div class="col-md-1">
									<input id="id-payment" checked="checked" class="ace ace-switch ace-switch-5" type="checkbox">
									<span class="lbl middle"></span>
								</div> --->
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="row clearfix">
				<div class="col-md-12">
					<div class="clearfix form-actions">
						<div class=" col-md-12" align="center">
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
		</form>
	</div>
</div>
</cfif>
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
<script src="/ACEAdmin/assets/js/date-time/bootstrap-datepicker.min.js"></script>
<script src="/ACEAdmin/assets/js/bootstrap-wysiwyg.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	
	$("##dueDate").datepicker({
					autoclose: true,
					todayHighlight: true
				});
	$("##reportDate").datepicker({
					autoclose: true,
					todayHighlight: true
				});
	$("##selectProject").change(function(){projectChange();});
	<cfif structKeyExists(rc,"ticketinfo") >
	// select project and disable it
		$("##selectProject").attr("disabled","disabled")
			.find("option[value=#rc.ticketinfo.projectID#]").attr("selected","selected");
			$.when(projectChange()).done(function(){
			// select info another
				$("##selectVersion")
					.find("option[value=#rc.ticketinfo.versionID#]").attr("selected","selected");
				$("##priority")
					.find("option[value=#rc.ticketinfo.priorityID#]").attr("selected","selected");
				$("##selectType")
					.find("option[value=#rc.ticketinfo.ticketTypeID#]").attr("selected","selected");
				$("##selectSprint")
					.find("option[value=#rc.ticketinfo.moduleID#]").attr("selected","selected");
				$("##selectEpic")
					.find("option[value=#rc.ticketinfo.epicID#]").attr("selected","selected");
			});
		// projectChange();
	// insert another info
		// $("##estimate").val('#rc.ticketinfo.estimate#');
		// $("##point").val('#rc.ticketinfo.point#');
		$("##reportDate").val('#DateFormat(rc.ticketinfo.reportDate,"yyyy-mm-dd")#');
		$("##dueDate").val('#DateFormat(rc.ticketinfo.dueDate,"yyyy-mm-dd")#');
		<cfif rc.ticketinfo.paid EQ 1>	
			document.getElementById('paid').checked = true;
			// $("##paid").attr({
			// 	'checked':'checked'
			// })
		<cfelse>
			document.getElementById('paid').checked = false;	
		</cfif>
		// document.getElementById('dcontinue').checked = false;
	<cfelse>
		projectChange();
	</cfif>
});
	function projectChange(){
		var id=$("##selectProject").val();
		$.ajax({
	        url: '/index.cfm/ticket.getDataOfProject',
	        method:'POST',
	        dataType: 'json',
	        data: {
	        	project: id
	        },
	        success: 	function(data) {			   
	        			$("##selectVersion").find("option").remove().end();  
	        			$("##selectReporter").find("option").remove().end();
	        			$("##selectAssignee").find("option").remove().end();
	        			$("##selectSprint").find("option").remove().end();
	        			$("##selectEpic").html("<option value=0>Select Epic...</option>");
	        			$("##selectTester").find("option[value!=0]").remove().end();
	        			$("##inputCode").val("");   				
	        				if(data!=false){
								for(var j = 0;j< data.EPIC.length ; j++){
									$("##selectEpic").append($('<option></option>')
				   					.attr('value', data.EPIC[j].epicID)
				   					.text(data.EPIC[j].epicName));
								}
	        					for (var i = 0;i< data.VERSIONS.length ; i++) {
	        						$("##selectVersion").append($('<option></option>')
                       					.attr('value', data.VERSIONS[i].versionID)
                       					.text(data.VERSIONS[i].versionName+"-"+data.VERSIONS[i].versionNumber));
	        					};
	        					for ( var i = 0 ; i<data.MODULES.length ; i++) {
	        						$("##selectSprint").append($('<option></option>')
                       					.attr('value', data.MODULES[i].moduleID)
                       					.text(data.MODULES[i].moduleName));
	        					}
	        					$("##inputCode").val(data.CODE[0].shortName);
    							for (var i = 0;i< data.USERS.length ; i++) {
    								<cfif SESSION.userType eq 3>
    									$("##selectReporter").append($('<option></option>')
                       					.attr('value', data.USERS[i].userID)
                       					.text(data.USERS[i].firstname));
                       				<cfelse>
	    								if(data.USERS[i].userID==#SESSION.userID#){
		        							$("##selectReporter").append($('<option></option>')
	                       					.attr('value', data.USERS[i].userID)
	                       					.text(data.USERS[i].firstname));
	                       				}
    								</cfif>
    								<cfif SESSION.userType neq 1>
    									if(data.USERS[i].userTypeID!=4){
		        							$("##selectAssignee").append($('<option></option>')
	                       					.attr('value', data.USERS[i].userID)
	                       					.text(data.USERS[i].firstname));
		        						}
		        					<cfelse>
	                       				if(data.USERS[i].userID==data.CODE[0].projectLeadID){
		        							$("##selectAssignee").append($('<option></option>')
	                       					.attr('value', data.USERS[i].userID)
	                       					.attr('selected', 'selected')
	                       					.text(data.USERS[i].firstname));
	                       				}
    								</cfif>
                       				if(data.USERS[i].userTypeID==4){
	        							$("##selectTester").append($('<option></option>')
                       					.attr('value', data.USERS[i].userID)
                       					.text(data.USERS[i].firstname));
                       				}
	        					};
	        					
                   				<cfif structKeyExists(rc,"ticketinfo")>
                   					$("##selectAssignee").find('option[value=#rc.ticketinfo.assignedUserID#]').attr("selected","selected");
                   					$("##selectReporter").find('option[value=#rc.ticketinfo.reportedByUserID#]').attr("selected","selected");
                   					$("##selectTester").find('option[value=#rc.ticketinfo.testerUserID#]').attr("selected","selected");
                   					$("##selectEpic").find('option[value=#rc.ticketinfo.epicID#]').attr("selected","selected");
                   					$("##selectSprint").find('option[value=#rc.ticketinfo.moduleID#]').attr("selected","selected");
                   				<cfelse>
                   					$("##selectAssignee").find('option[value='+data.CODE[0].projectLeadID+']').attr("selected","selected");
                   					$("##selectReporter").find('option[value=#SESSION.userID#]').attr("selected","selected");
                   				</cfif>
	        				}
	                	}
	    });
	}
	$("##title").focus();
	function changePaid()
	{
		var id = $("##selectType").val();
		if(id == 1 || id == 4)
		{
			document.getElementById('paid').checked = false;
			// $("##paid").removeAttr("checked");
		}
		else if(id == 2 || id == 3)
		{
			document.getElementById('paid').checked = true;

			// $("##paid").removeAttr("checked");
			// $("##paid").attr({
			// 	'checked':'checked'
			// })
		}
	}

	// function changeEstimate()
	// {
	// 	// Day la day fibonaci
	// 	var p = $("##estimate").val()*2;
	// 	var a = 1;
	// 	var b = 1;
	// 	for (var i = 1; i < 8; i++)
	// 	{
	// 		var n = a + b;
	// 		a = b;
	// 		b = n;
	// 		if (p > a && p < b)
	// 			if (p - a < b - p)
	// 				p = a;
	// 			else p = b;
	// 	}
	// 	if (p > 55)
	// 		p = 55;
	// 	$("##point").val(p);
	// }
</script>
</cfoutput>
<script type="text/javascript">
	$('#epicPriority').on("keydown", function(event){
	    var keyCode = event.which;	    
	    if(!((keyCode > 48 && keyCode < 58) ||  (keyCode > 96 && keyCode < 106) ||  keyCode == 08 || (keyCode == 96 && +$('#epicPriority').val()>0)|| (keyCode == 48 && +$('#epicPriority').val()>0) || ((keyCode == 16) || (keyCode == 36) || (keyCode == 37) || (keyCode == 39) || (keyCode == 35)|| (keyCode == 46)|| (keyCode == 9)|| (keyCode == 16)|| (keyCode == 13))
	    	)){
	        event.preventDefault();
	    }
	});
	
	jQuery(function($) {
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
		$('#myform').on('submit', function() {
			if($('#title').val() != ""){
				$('#description').val($('#editor').html());	
				$(this).submit();
			}else{
				alert('Please Insert title for ticket!');
				return false;
			}
		});
		$('#myform').on('reset', function() {
			$('#editor').empty();
		});		
	});
$(document).ready(function(){
	$('#errorMessage').addClass('hide');
	$('#myform').on('submit', function() {
		if($('#title').val() != ""){
			$('#description').val($('#editor').html());	
			$(this).submit();
		}else{
			alert('Please Insert title for ticket!');
			return false;
		}
	});
	$('#myform').on('reset', function() {
		$('#editor').empty();
	});	

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
	validateTitle();
})
	function validateTitle(){
		if($('#title').val() == ""){
			$('#groupTitle').addClass('has-error');
			document.getElementById("btn-submit").disabled=true;
		}else{
			$('#groupTitle').removeClass('has-error');
			document.getElementById("btn-submit").disabled=false;
		}		
	}

	$("#tag").typeahead(
	{
		hint: true,
		highlight: true,
		minLength: 2
	}, 
	{
		name: 'Suggestion_Search',
		displayKey: 'NAME',
		source: function (query, process) {
		return $.getJSON('/index.cfm/ticket.getTag', {data: query}, 
		function (data) {
		process(data);
		});
	}
	}).on('keypress', function (e) {
		if (e.which === 13) {
			// var name = $("#tag").val();			
	 	// 	$.ajax({
	 	// 	        type: "post",
	 	// 	        url: "/index.cfm/ticket.createTag",
	 	// 	        data: {
	 	// 	        	tagName : name
	 	// 	        },
	 	// 	        success: function( data ) {
	 	// 	        	<cfif structKeyExists(rc,"ticketinfo") >
	 	// 					var id = <cfoutput>#rc.ticketinfo.ticketID#</cfoutput>
	 	// 				</cfif>
		 //            	$.ajax({
		 //            	        type: "post",
		 //            	        url: "/index.cfm/ticket.addTag",
		 //            	        data: {
		 //            	        	ticketID : id,
		 //        						tagID : data.TAGID
		 //            	        },
		 //            	        success: function (data1) {
		 //            	        	<cfif structKeyExists(rc,"ticketinfo") >
			// 			            	$("#tagcon").append('<span id="tag'+data.TAGID+'" class="tag">'+name+'<button type="button" class="close" onclick="removeTag('+data.TAGID+','+id+')">x</button></span>');
			// 			            <cfelse>
			// 					 		$("#tagcon").append('<span id="tag'+data.TAGID+'" class="tag">'+name+'<button type="button" class="close" onclick="removeTag1('+data.TAGID+')">x</button></span>');
			// 					 		$("#dtags").val($("#dtags").val()+","+data.TAGID);
			// 					 	</cfif>	
		 //            	        }
		 //            	});		
		 //            }
	 	// 	});
		 // 	$("#tag").val("");			 	
		}
	}).on('typeahead:selected',function(e,s,d){
	 // $("#description").val(s.DESCRIPTION);
	 // $("#longdescription").val(s.LONGDESCRIPTION);
	 	<cfif structKeyExists(rc,"ticketinfo") >
	 	var id = <cfoutput>#rc.ticketinfo.ticketID#</cfoutput>
	 		$.ajax({
	 		        type: "post",
	 		        url: "/index.cfm/ticket.addTag",
	 		        data: {
	 		        	ticketID : id,
	 		        	tagID : s.TAGID
	 		        },
	 		        success: function( data ) {
		            	
		            }
	 		});
	 		$("#tagcon").append('<span id="tag'+s.TAGID+'" class="tag">'+s.NAME+'<button type="button" class="close" onclick="removeTag('+s.TAGID+','+id+')">x</button></span>');
	 	<cfelse>
	 		$("#tagcon").append('<span id="tag'+s.TAGID+'" class="tag">'+s.NAME+'<button type="button" class="close" onclick="removeTag1('+s.TAGID+')">x</button></span>');
	 		$("#dtags").val($("#dtags").val()+","+s.TAGID);
	 	</cfif>		
		$("#tag").val("");
		
	});
	
	function removeTag(tid, id)
	{
		$.ajax({
		        type: "post",
		        url: "/index.cfm/ticket.removeTag",
		        data: {
		        	tagID : tid,
		        	ticketID : id
		        },
		        success: function (data) {
		        	$("#tag"+tid).remove();
		        	$("#tag").val("");
		        }
		});
	}

	function removeTag1(tid)
	{
		$("#tag"+tid).remove();
		$("#dtags").val($("#dtags").val().replace(","+tid,""));
		$("#tag").val("");
	}
</script>
<cfelse>
	<div align='center'>
		<h1 class="red">Error !</h1>
		<h3>Missing Ticket or Ticket not Found! </h3>
	</div>
</cfif>

