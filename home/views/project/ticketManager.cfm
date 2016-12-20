<cfoutput>
	<div class="row clearfix">
		<h3 >Ticket Manager</h3>
		<div class="col-xs-6">
	        <select class="col-xs-11" id="select_project" name="project" onChange="getProject()">
	            <option value = 0>#getLabel("Select all projects", #SESSION.languageId#)#</option>
	            <cfoutput>
	                <cfloop query="rc.listProject">
	                	<cfif #rc.project# eq #rc.listProject.projectID#>
	                		<option value="#rc.listProject.projectID#" selected>#rc.listProject.projectName#</option>
	                	<cfelse>
	                		<option value="#rc.listProject.projectID#">#rc.listProject.projectName#</option>
	                	</cfif>
	                </cfloop>
	            </cfoutput>
	        </select>
		</div>
		
		<div class="col-xs-6">
			<select class="col-xs-9" id="select_ticket" name="project">
			    <cfoutput>
			        <cfloop query="rc.listTicket">
			        		<option value="#rc.listTicket.ticketID#">#rc.listTicket.code# #rc.listTicket.title#</option>
			        </cfloop>
			    </cfoutput>
			</select>
			&nbsp;<button class="btn btn-sm btn-primary" onClick="addTicket()">Add</button>
		</div>

	</div>
	<br>
	<div class="row clearfix">
		<!--- <div class="row col-md-12"> --->
			<table id="dynamic-table" class="table table-striped table-bordered table-hover">
			<!--- <table id="dynamic-table" class="datatable-display"> --->
				<thead>
					<tr>
						<th>Code</th>
						<th>#getLabel("Title", #SESSION.languageId#)#</th>
						<th>#getLabel("Description", #SESSION.languageId#)#</th>
						<th>#getLabel("Assignee", #SESSION.languageId#)#</th>
						<th>#getLabel("Status", #SESSION.languageId#)#</th>
						<th></th>
					</tr>
				</thead>
				<tfoot>
					<tr>
						<td>
							<button disabled type="button" id="btn-create-ticket"class="btn btn-sm btn-info " onclick="createTicket()"><i class="ace-icon glyphicon glyphicon-plus icon-on-right" ></i>Create ticket</button>
						</td>
						<td>
							<input type="text" id="ticketTitle" placeholder="Ticket title" name = "title" class="col-sm-10 col-xs-9 col-md-10" />
						</td>
						<td>
							<input type="text" id="ticketDes" placeholder="Description" name = "description" class="col-sm-10 col-xs-9 col-md-10" />
						</td>
						<td>
							<select id="ticketAs">
								<cfloop query="rc.listAssignee">
				                	<option value="#rc.listAssignee.userID#">#rc.listAssignee.firstname# #rc.listAssignee.lastname#</option>
				                </cfloop>
			               </select>
						</td>
						<td>
							</td>
					</tr>
				</tfoot>
				<tbody>
					<cfloop query="#rc.ticketsM#">
						<tr>
							<td><a href="/index.cfm/ticket?id=#rc.ticketsM.Code#">#rc.ticketsM.Code#</a></td>
							<td>#rc.ticketsM.Title#</td>
							<td>#rc.ticketsM.Description#</td>
							<td>#rc.ticketsM.Assignee#</td>
							<td>#rc.ticketsM.statusName#</td>
							<td>
								<a class="red" href="##remove" onClick="removeTicket(#rc.ticketsM.ticketManageID#)" >
									<i class="ace-icon fa fa-trash-o bigger-130"></i>
								</a>
							</td>
						</tr>
					</cfloop>
				</tbody>
			</table>
		<!--- </div> --->
	</div>
</cfoutput>

<script type="text/javascript">
$(document).ready(function(){
	$("#select_project").chosen({allow_single_deselect:true});
	$("#select_ticket").chosen({allow_single_deselect:true});
	$("#ticketAs").chosen({allow_single_deselect:true});
})
$(document).on('keyup','#ticketTitle',function(event){
	if( checkValidCreateTicket() ){
		$('#btn-create-ticket').prop('disabled',false);	
		if(event.keyCode == 13){
			createTicket();
		}
	}else{
		$('#btn-create-ticket').prop('disabled',true);
	}
});

function checkValidCreateTicket(){
	var sTicketTitle = $('#ticketTitle').val();
	var strimTitle = $.trim(sTicketTitle).split("");
	if(strimTitle == '')
		return false ;
	else 
		return true ;
}

function getProject()
{
    var project = $("#select_project").val();
	window.location = "ticketManager?project=" + project;
}

function createTicket(){
	var project = $('#select_project').val();
	if (project == 0) {
		alert('Please choose a project for ticket!');
	} else {
		var title = $('#ticketTitle').val();
		var description = $('#ticketDes').val();
		var assignee = $("#ticketAs").val();
		$.ajax({
			type: 'POST',
			url: '/index.cfm/project/createTicketManager',
			data: {
				title: title,
				project: project,
				description: description,
				assignee: assignee
			},
			success: function (data) {				
				if(data)
				{
					window.location.reload();
				}
				else{
					writeDump(data.message);
					request.abort();
					alert('Fail'+data.message);
				}
			}
		});
	}	
}

function removeTicket(tid){	
	// var r = confirm("Are you sure you want to remove this ticket?");
	// if(r){
		$.ajax({
			type: "POST",
			url: "/index.cfm/project/removeTicketManager",
			data: {
				ticketID: tid
			},
			success: function(data){
				if(!data){
					alert(data.message);
				}
		location.reload();
			}
		});
	// }
}

function addTicket(){
	var tid = $("#select_ticket").val();
	$.ajax({
		type: "POST",
		url: "/index.cfm/project/addTicketManager",
		data: {
			ticketID: tid
		},
		success: function(data){
			if(!data){
				alert(data.message);
			}
			location.reload();
		}
	});
}

// $(document).ready( function () {
//     $('#dynamic-table').DataTable();
// } );

</script>
