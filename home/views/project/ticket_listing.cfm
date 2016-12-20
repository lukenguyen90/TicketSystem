<style type="text/css">
.over{
  background-color: red;
  color: white;
}
.done{
	text-decoration: line-through;
}
</style>
<cfoutput>
	<div class="page-header col-xs-12 col-md-12">
		<h1>
			<div class="row">
				#getLabel("Ticket Listing", #SESSION.languageId#)#
				<div class="col-md-3 pull-right">	
				<form action="">
						<select id="prj" class="chosen-select" onchange="changePrj()" style="height:34px; width: 200px; margin-left: 43px;">
							<cfloop query="rc.prj">
								<option value="#rc.prj.projectID#" <cfif rc.pId EQ rc.prj.projectID>selected="SELECTED"</cfif>>#rc.prj.projectName#</option>
							</cfloop>					
						</select>	
				</form>	
				</div>
			</div>
		</h1>
	</div>
	<div class="col-xs-12 col-md-12">		
		<div class="row">
			<table class="table table-striped table-bordered table-hover dataTable no-footer " id="ticket-table-2" role="grid" aria-describedby="ticket-table-2_info" style="margin-top: 20px;">
						<thead>
							<tr role="row">
								<th style="width: 80px;text-align: center">#getLabel("No.", #SESSION.languageId#)#</th>
								<th style="width:100px;text-align: center">#getLabel("Code", #SESSION.languageId#)#</th>
								<th style="width: auto; text-align: center">#getLabel("Title", #SESSION.languageId#)#</th>
								<th style="width: auto; text-align: center">#getLabel("Epic", #SESSION.languageId#)#</th>
								<th style="width:100px;text-align: center">#getLabel("Due Date", #SESSION.languageId#)#</th>
								<th style="width:100px;text-align: center">#getLabel("Assignee", #SESSION.languageId#)#</th>
								<th style="width:100px;text-align: center">#getLabel("Reporter", #SESSION.languageId#)#</th>
								<th style="width:100px;text-align: center">#getLabel("Priority", #SESSION.languageId#)#</th>
								<th style="width:100px;text-align: center">#getLabel("Status", #SESSION.languageId#)#</th>
							</tr>
						</thead>
						<tbody id="body">
							<cfif structKeyExists(rc, "data")>
								<cfloop query="#rc.data#">						
									<tr>
									<td>#rc.data.splitFromCode#</td>
									<td><span>#rc.data.code#</span></td>
									<td>
										<cfif rc.data.statusID eq 5 OR rc.data.statusID eq 6 >
											<span>&nbsp;<a href="/index.cfm/ticket?id=#rc.data.code#" title="Click to view ticket detail..."><span class="blue done">#rc.data.title#</span></a></span>
											<cfif rc.data.over GT 0 and (rc.data.statusID EQ 1 or rc.data.statusID EQ 2 or rc.data.statusID EQ 4) && rc.data.priorityID neq 4>
												<span class="over">#rc.data.over#d </span>
											</cfif>
										<cfelse>
											<span>&nbsp;<a href="/index.cfm/ticket?id=#rc.data.code#" title="Click to view ticket detail..."><span class="blue">#rc.data.title#</span></a></span><span class="over">#rc.data.over#d </span>
										</cfif>
									</td>
									<td><span class="pull-right epic epic-'+data[i].epicColor+'">#(#rc.data.epicName#==''?'none':#rc.data.epicName#)#</span></td>
									<td>#rc.data.dueDate#</td>
									<td>#rc.data.assignee#</td>
									<td>#rc.data.reporter#</td>
									<td style="color: #rc.data.pColor#">#rc.data.priority#</td>
									<td><span class="label label-#rc.data.sColor#"><cfoutput>#getLabel("#rc.data.status#", #SESSION.languageId#)#</cfoutput></span></td>
									</tr>
								</cfloop>
							</cfif>
						</tbody>
					</table>
		</div>
	</div>
<script type="text/javascript">
	var root = "http://#CGI.http_host#";
	var projectID = #SESSION.focuspj#;
	var page = 0;
</script>

</cfoutput>
<script type="text/javascript">	
	$(document).ready(function() {
		$("#prj").chosen({allow_single_deselect:true});
		var oTable = $('#ticket-table-2').dataTable({
        	'iDisplayLength': 50
        });
		
	});

	function changePrj(){
		var projectID = $("#prj").val();
		var baseURL = root+"/index.cfm/project/ticket_listing/?pId=" + projectID;
		window.location = baseURL;
	}
</script>