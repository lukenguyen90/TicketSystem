<cfoutput>
	<div class="container" style="margin-bottom:20px">
		<div class="row">
			<!-- col -->
			<div class="col-xs-5">
				<div class="row">
					<div class="col-xs-7">
						<select class="select2" id="typeId">
							<option value="">Choose</option>
							<option value="1">Paid annual leave</option>
							<option value="2">Add annual leave</option>
							<option value="3">Add Overtime</option>
							<option value="4">Paid Overtime</option>
							
						</select>
					</div>
					<div class="col-xs-2">
						<a href="javascript:void(0)" onclick="getInfor()" class="btn btn-primary">Find</a>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<table id="aTable" class="table table-striped table-bordered table-hover dt_basic center thcenter" width="100%">
		<thead>
			<tr>
				<th>##</th>
				<th>Date</th>
				<th>Action</th>
				<th>User</th>
				<th>Reason</th>
			</tr>
		</thead>
		<tbody>
			<cfset i = 1>
			<cfloop array="#rc.logAnnual#" index="annual">
				<tr>
					<td>#i#</td>
					<td>
						#dateTimeFormat(annual.createTime,'dd/mm/yyyy HH:MM:ss')#
					</td>
					<td>
						<cfswitch expression="#annual.type#"> 
							<cfcase value="1">
								Paid annual leave
							</cfcase>
							<cfcase value="2">
								Add annual leave
							</cfcase>
							<cfcase value="3">
								Add Overtime
							</cfcase>
							<cfcase value="4">
								Paid Late
							</cfcase>
						</cfswitch>
					</td>
					<td>
						<cfset User = entityloadbyPk('users',annual.userPaid)>
						#User.firstname&" "&User.lastname#
					</td>
					<td>#annual.action#</td>
				</tr>
			</cfloop>
			<cfset i +=1>
		</tbody>
	</table>
<script type="text/javascript">
	$(document).ready(function() {
		$('##typeId').val('#structKeyExists(URL,"t")?URL.t:""#');
	})
	function getInfor()
	{
		window.location.href = "/index.cfm/manager.log/?t="+$('##typeId').val();

	}
</script>
</cfoutput>