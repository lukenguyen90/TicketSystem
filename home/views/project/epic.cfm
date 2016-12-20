<cfif structKeyExists(rc,"curProject")>
<cfoutput>
<style type="text/css">
.dd-item{
	border-left-width: 2px !important;
}
li.item-primary {
    border-left-color: ##428bca;
}
li.item-info {
    border-left-color: ##6fb3e0;
}
li.item-success {
    border-left-color: ##87b87f;
}
li.item-warning {
    border-left-color: ##ffb752;
}
li.item-danger {
    border-left-color: ##d15b47;
}
li.item-inverse {
    border-left-color: ##555;
}
li.item-yellow {
    border-left-color: ##fee188;
}
</style>
<input type="hidden" id="curProjectID" value="#rc.curProject.projectID#"/>
<div class="page-header">
	<div class="row">
	<h1 class="col-xs-12">
		#getLabel("Epic :", #SESSION.languageId#)#
		<i class="btn-group" style="vertical-align: bottom;">
			<!--- project end change project --->
			<a  data-toggle="dropdown" class="dropdown-toggle green" title="Click to change Project!" >
				#rc.curProject.projectName# <small><i class="fa fa-sort-desc"></i></small>
			</a>
			<ul class="dropdown-menu dropdown-yellow dropdown-caret " >
		   		<cfloop query="rc.listProject">
					<cfif rc.curProject.projectID NEQ rc.listProject.projectID>
					<li>
	            		<a href="/index.cfm/project/epic/?pId=#rc.listProject.projectID#" onClick="changeProject('#rc.listProject.projectID#')">
	          				#rc.listProject.projectName#
	            		</a>
	            	</li>
					</cfif>
				</cfloop>
        	</ul>
		</i>
		<!--- show status --->
		<button class="btn btn-sm btn-success pull-right" id="btn-new" onClick="newepic()">
			#getLabel("New Epic", #SESSION.languageId#)#
		</button>
	</h1>
	</div>
</div>
<div class="row">
	<div class="col-xs-12">
		<cfif rc.epic.recordCount eq 0>
			<div class="alert alert-warning">
				Missing epic in this Project!
			</div>
		<cfelse>
		<div class="dd" id="nestable">
			<ol class="dd-list" id="listepic">
				<cfloop query=#rc.epic#>
					<li class="dd-item item-#rc.epic.epicColor#" id="epic#rc.epic.epicID#" data-id="#rc.epic.epicID#" data-name="#rc.epic.epicName#" data-priority="#rc.epic.epicPriority#" data-des="#rc.epic.epicDescription#">
						<div class="dd-handle"> 
							<!--- <span id="epicname#rc.epic.epicID#" value="#rc.epic.epicPriority#">#rc.epic.epicName# Priority #rc.epic.epicPriority#</span> --->
							<span id="priority#rc.epic.epicID#" value="#rc.epic.epicPriority#" style="color: red">#rc.epic.epicPriority#.</span>
							<span id="epicname#rc.epic.epicID#" value="#rc.epic.epicPriority#">#rc.epic.epicName#</span>
							<div class="pull-right action-buttons">
								<a class="blue" href="##edit" onClick="edit('#rc.epic.epicID#')">
									<i class="ace-icon fa fa-pencil bigger-130"></i>
								</a>

								<a class="red" href="##remove" onClick="removeEpic('#rc.epic.epicID#')" >
									<i class="ace-icon fa fa-trash-o bigger-130"></i>
								</a>
							</div>
							<span class="lighter grey">
								&nbsp; <span id="epicdes#rc.epic.epicID#">#rc.epic.epicDescription#</span>
							</span>
						</div>
					</li>
				</cfloop>				
			</ol>
		</div>
		</cfif>
	</div>
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
							<input id="idEpicPriority" type="text" placeholder="Epic Priority Number!">
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
</div>
<script type="text/javascript">
var pId = #rc.pId#;
</script>
</cfoutput>
<script src="/ACEAdmin/assets/js/jquery.nestable.min.js"></script>
<script type="text/javascript">
	var isNew = true ;
	var curEpic = 0 ;
	jQuery(function($){
	
		$('.dd').nestable({
			maxDepth : 1
		});
		$('#idEpicPriority').on("keydown", function(event){
	    var keyCode = event.which;	    
	    if(!((keyCode > 48 && keyCode < 58) ||  (keyCode > 96 && keyCode < 106) ||  keyCode == 08 || (keyCode == 96 && +$('#idEpicPriority').val()>0)|| (keyCode == 48 && +$('#idEpicPriority').val()>0) || ((keyCode == 16) || (keyCode == 36) || (keyCode == 37) || (keyCode == 39) || (keyCode == 35)|| (keyCode == 46)|| (keyCode == 9)|| (keyCode == 16)|| (keyCode == 13))
	    	)){
		        event.preventDefault();
		    }
		});
	
		$('.dd-handle a').on('mousedown', function(e){
			e.stopPropagation();
		});
		
		$('[data-rel="tooltip"]').tooltip();
	
	});
	$(document).ready(function(){
		$('#errorMessage').addClass('hide');
		$("#btnNewEpic").on("click",function(){
			$('#errorMessage').addClass('hide');
			var epicName = $("#epicname").val();
			var epicDescription = $('#epicDescription').val();
			var epicPriority = $('#idEpicPriority').val();
							
			if($.trim(epicName) !== ''){
				$("#waiting").removeClass('hide');
				$.when(
					$.ajax({
			            type: "POST",
			            url: "/index.cfm/home:project.editEpic",
			            data: {
			            	isNew : isNew,
			            	curEpic : curEpic,
			            	epicName: epicName,
			            	epicDescription: epicDescription,
			            	epicPriority: epicPriority,
			            	curProject: $("#curProjectID").val()


			            },
			            success: function( data ) {
			            	if(data.success){
			            		if(isNew){
			            			$("#listepic").append(
											'<li class="dd-item item-'+data.ecolor+'" id="epic'+data.eid+'" data-id="'+data.eid+'" data-name="'+epicName+'" data-des="'+epicDescription+'">'+
												'<div class="dd-handle"> '+
													'<span id="epicname'+data.eid+'">'+epicName+'</span>'+
													'<div class="pull-right action-buttons">'+
														'<a class="blue" href="#edit" onClick="edit('+"'"+data.eid+"'"+')" >'+
															'<i class="ace-icon fa fa-pencil bigger-130"></i>'+
														'</a>'+
														'<a class="red" href="#delete">'+
															'<i class="ace-icon fa fa-trash-o bigger-130"></i>'+
														'</a>'+
													'</div>'+
													'<span class="lighter grey">'+
														'&nbsp; '+'<span id="epicdes'+data.eid+'">'+epicDescription+'</span>'+
													'</span>'+
												'</div>'+
											'</li>'
											);
			            			location.reload();
			            		}else{
									var $curEpic = $("#epic"+curEpic);
									$curEpic.attr("data-name",epicName);
									$curEpic.attr("data-des",epicDescription);
									$curEpic.attr("data-des", epicPriority);


									$("#epicname"+curEpic).text(epicName);
									$("#epicdes"+curEpic).text(epicDescription);
									$('#idEpicPriority').text(epicPriority);
									location.reload();
			            		}
			            		$("#modalNewEpic").modal("hide");

			            	}else{
			            		$('#errorMessage').text(data.message).removeClass('hide');
			            	}
			            }
					})
				).done(function(){
					$("#waiting").addClass('hide');
				});
			}else{
				$('#errorMessage').text('Missing epic name!').removeClass('hide');
			}
		});
		$('.dd').on('change', function() {
			var listid = '[';
			var isFirst = true ;
			$.each($("#listepic").children(),function(){
				listid += (isFirst ? '':',') + $(this).attr("data-id");
				isFirst = false ;
			});
			listid += ']';
			$.ajax({
				type: "POST",
				url: "/index.cfm/home:project.updateListEpic",
				data: {
					listEpic: listid,
					pId : pId
				},
				success: function(data){
					if(data.success){
						for (var i = data.lEpic.length - 1; i >= 0; i--) {
							$('#priority'+data.lEpic[i].id).text(data.lEpic[i].priority);
							$('#epic'+data.lEpic[i].id).attr('data-priority',data.lEpic[i].priority);
						};
					}else{
						alert(data.message);
					}
				}
	    	});
		});
	});
	function newepic(){
		isNew = true ;
		curEpic = 0;
		$("#epicname").val('');
		$("#epicDescription").val('');
		$('#errorMessage').addClass('hide');
		$("#modalNewEpic").modal("show");
	}
	function edit(eid){
		isNew = false ;
		curEpic = eid ;
		var $curEpic = $("#epic"+eid);
		var epicName = $curEpic.attr("data-name");
		var epicDescription = $curEpic.attr("data-des");
		var epicPriority = $curEpic.attr("data-priority");

		$("#epicname").val(epicName);
		$('#epicDescription').val(epicDescription);
		$('#idEpicPriority').val(epicPriority);
		$("#modalNewEpic").modal("show");
	}
	function removeEpic(eid){	
		var r = confirm("Are you sure remove this epic?");
		if(r){
			$.ajax({
				type: "POST",
				url: "/index.cfm/home:project.removeEpic",
				data: {
					epicID: eid
				},
				success: function(data){
					if(!data){
						alert(data.message);
					}
				}
			});
			location.reload();
		}
	}
</script>
<cfelse>
	<cflocation url="/index.cfm/" addtoken="false" >
</cfif>
