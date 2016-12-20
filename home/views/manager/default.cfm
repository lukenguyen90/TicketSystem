<style type="text/css">
	.darkGreen{
		background-color: #98c698 !important;
	}
	.darkPrink{
		background-color:  #f7baba  !important;
	}
</style>
<cfoutput>
	<div class="tab-pane fade in active" id="s2">
		<h1 class="page-title txt-color-blueDark"><i class="fa-fw fa fa-home"></i> Dashboard <span>&gt; My Dashboard</span></h1>
		<br>
		<div class="table-responsive">
			
			<table id="resultTable" class="table table-striped table-bordered table-hover">
				<thead>
					<tr>
						<th>##</th>
						<th style="width:30px">Pic</th>
						<th>Name</th>
						<th>Start working</th>
						<th class="success">A/L Total</th>
						<th class="success">A/L Off</th>
						<th class="darkGreen">A/L Exist</th>
						<th class="danger">S/L Total</th>
						<th class="danger">S/L Off</th>
						<th class="darkPrink">S/L Exist</th>
						<th class="info">Over Time Hours</th>
						<th></th>
					</tr>
				</thead>
				<tbody>
					<cfset i = 1>
					<cfloop array="#rc.users#" index="user">
						<cfset avatar="">
						<cfif user.avatar EQ "">
							<cfset avatar = "/fileupload/avatars/default.jpg">
						<cfelse>
							<cfif FileExists(expandPath("/fileupload/avatars/")&user.avatar)>
								<cfset avatar ="/fileupload/avatars/#user.avatar#">
							<cfelse>
								<cfset avatar ="/fileupload/avatars/default.jpg">
							</cfif>
							
						</cfif>
						<tr id="user_#user.id#">
							<td>#i#</td>
							<td><img src="#avatar#" alt="" width="30"></td>
							<td>#user.name# </td>
							<td>#LSDATEFORMAT(user.startTime,'dd/mm/yyyy')#</td>
							<td class="success">#user.alOffTotal#</td>
							<td class="success">#user.alOff#</td>
							<td class="darkGreen">#user.alOffTotal - user.alOff#</td>
							<td class="danger">#user.sloffTotal#</td>
							<td class="danger">#user.sloff#</td>
							<td class="darkPrink">#user.sloffTotal - user.sloff#</td>
							<td class="info">#user.overtimes#</td>
							<td style="text-align:center">
								<a href="/index.cfm/manager.userDetail/?u=#user.userID#">
									<i class="fa fa-eye"></i>
								</a>
								<a class="green"  onclick="editUser(#user.id#,#user.userID#)">
									<i class="ace-icon fa fa-pencil bigger-130"></i>
								</a>
							</td>
						</tr>
						<cfset i = i + 1>
					</cfloop>
				
				</tbody>
			</table>

		</div>
	</div>
	<div class="modal fade" id="modalWarn" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">
						&times;
					</button>
					<h4 class="modal-title" id="myModalLabel">Edit Information User</h4>
				</div>
				<div class="modal-body text-center">
					<form id="smart-form-register" role="form" class="smart-form" method="POST">
						<input type="hidden" value="0" name="dayoffid" id="dayoffid">
						<input type="hidden" value="0" name="userId" id="userId">
						<fieldset>
							<div class="row">
								<section class="col col-2">
										<label class="label">Name:</label>
								</section>
								<section class="col col-10">
										<label id="nameUser" class="label"></label>
								</section>
							</div>

							<div class="row">
								<section class="col col-8">
									<label class="input"> <i class="icon-append fa fa-calendar"></i>
										<input type="text" name="mydate" placeholder="Select a date start working" class="form-control datepicker" data-dateformat="dd/mm/yy">
										<b class="tooltip tooltip-bottom-right">Needed to enter the website</b> </label>
								</section>
							</div>

							<div class="row">
								<section class="col col-4">
									<label>Annual Leave</label>
									<label class="input">
										<input type="text" name="annualDay" placeholder="Annual Leave" value="0">
									</label>
								</section>
								<section class="col col-4">
									<label>Sickness Leave</label>
									<label class="input">
										<input type="text" name="sicknessDay" placeholder="Sickness Leave" value="0">
									</label>
								</section>
								<section class="col col-4">
									<label>Over Times</label>
									<label class="input">
										<input type="text" name="overtimes" placeholder="Overtimes" value="0">
									</label>
								</section>
							</div>

						</fieldset>	
				</div>
				<div class="modal-footer">
					<button type="submit" class="btn btn-primary">
									Submit
								</button>
				</div>
				</form>
			</div><!-- /.modal-content -->
		</div><!-- /.modal-dialog -->
	</div>
</cfoutput>
<script type="text/javascript">
	$(document).ready(function(){	
		<cfif CGI.REQUEST_METHOD eq "POST">
			<cfif rc.stt>
					$.smallBox({
						title : "Notification",
						content : "<i class='fa fa-clock-o'></i> <i>Your changes have been saved successfully.</i>",
						color : "##659265",
						iconSmall : "fa fa-check fa-2x fadeInRight animated",
						timeout : 4000
					});
			<cfelse>
					$.smallBox({
						title : "Notification",
						content : "<i class='fa fa-clock-o'></i> <i>You CAN'T change information this user</i>",
						color : "##C46A69",
						iconSmall : "fa fa-check fa-2x fadeInRight animated",
						timeout : 4000
					});
			</cfif>
		</cfif>
		$('#resultTable').DataTable( {
	        "bDestroy": true,
	        "fixedHeader": true,
	        "iDisplayLength": 10,
	        "order": [[1, 'asc']],
	        "fnDrawCallback": function( oSettings ) {
		       runAllCharts()
		    }
	    } );
	})
	function editUser(did,uid)
	{
		var name = $('#user_'+did).children('td').eq(2).html();
		var startTime = $('#user_'+did).children('td').eq(3).html();
		var altotal = $('#user_'+did).children('td').eq(4).html();
		var sltotal = $('#user_'+did).children('td').eq(7).html();
		var ot = $('#user_'+did).children('td').eq(10).html();
		$('#nameUser').html(" "+name);
		$('input[name=annualDay]').val(altotal);
		$('input[name=sicknessDay]').val(sltotal);
		$('input[name=overtimes]').val(ot);
		$('input[name=mydate]').val(startTime);
		$('input[name=dayoffid]').val(did);
		$('input[name=userId]').val(uid);
		$('#modalWarn').modal('show');
	}
</script>