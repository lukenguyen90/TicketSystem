<link rel="stylesheet" href="/ACEAdmin/assets/css/ace.min.css" />
<style type="text/css">
	.thcenter th{
		text-align: center !important;
	}
	.smart-form footer .btn{
		height:36px;
	}
</style>
<cfoutput>
	<div class="well">
		<div class="row">
			<div class="col-md-3">
                <div class="ibox-content text-center">
                    <h1>#rc.user[1].name#</h1>
                    <div class="m-b-sm center">
	        				<cfset avatar = "">
			        		<cfif rc.user[1].avatar EQ "">
								<cfset avatar = "/fileupload/avatars/default.jpg">
							<cfelse>
								<cfif FileExists(expandPath("/fileupload/avatars/")&rc.user[1].avatar)>
									<cfset avatar ="/fileupload/avatars/# rc.user[1].avatar#">
								<cfelse>
									<cfset avatar ="/fileupload/avatars/default.jpg">
								</cfif>
								
							</cfif>
                            <img alt="image" width="100" class="img-circle" src="#avatar#">
                    </div>
                </div>
            </div>
            <div class="col-md-9">
            	<div class="center" style="margin-top:4em">
					<span class="btn btn-app btn-sm btn-success no-hover" data-toggle="modal" href="##myModal">
						<span class="line-height-1 bigger-170"> #rc.user[1].alOffTotal - rc.user[1].alOff#</span>

						<br />
						<span class="line-height-1 smaller-90"> A/L Total </span>
					</span>

					<span class="btn btn-app btn-sm btn-success no-hover">
						<span class="line-height-1 bigger-170"> #rc.user[1].alOff# </span>

						<br />
						<span class="line-height-1 smaller-90"> A/L Off </span>
					</span>

					<span class="btn btn-app btn-sm btn-warning no-hover">
						<span class="line-height-1 bigger-170"> #rc.user[1].sloffTotal - rc.user[1].sloff# </span>

						<br />
						<span class="line-height-1 smaller-90"> S/L Total </span>
					</span>

					<span class="btn btn-app btn-sm btn-warning no-hover">
						<span class="line-height-1 bigger-170"> #rc.user[1].sloff# </span>

						<br />
						<span class="line-height-1 smaller-90"> S/L Off </span>
					</span>
					<cfif rc.user[1].overtimes gt 0>
					<span class="btn btn-app btn-sm btn-info no-hover" data-toggle="modal" href="##paidOvertime">
					<cfelse>
					<span class="btn btn-app btn-sm btn-info no-hover" >
					</cfif>
						<span class="line-height-1 bigger-170"> #rc.user[1].overtimes#</span>

						<br />
						<span class="line-height-1 smaller-90"> Over Time </span>
					</span>

					<span class="btn btn-app btn-sm btn-danger no-hover" >
						<span class="line-height-1 bigger-170"> #rc.countLate# </span>

						<br />
						<span class="line-height-1 smaller-90"> Late </span>
					</span>
				</div>
            </div>
		</div>
		<hr>
		<div class="input-group">
			<select class="form-control" id="selectType">
				<option value="1">Annual Leave</option>
				<option value="2">Urgent Case Off</option>
				<option value="3">Over Time</option>
			</select>
		</div>
	</div>
	<article class="col-sm-12 col-md-12 col-lg-12" id="annualeave">
		<div class="jarviswidget jarviswidget-color-greenDark" id="wid-id-2" data-widget-editbutton="false">
			<header>
				<span class="widget-icon"> <i class="fa fa-table"></i> </span>
				<h2>ANNUAL LEAVE</h2>

			</header>
			<div>
				<div class="jarviswidget-editbox">
				</div>
				<div class="widget-body no-padding">
					<div class="table-responsive">
							
						<table id="aTable" class="table table-striped table-bordered table-hover dt_basic center thcenter" width="100%">
							<thead>
								<tr>
									<th>##</th>
									<th>Date</th>
									<th>Times</th>
									<th>Type</th>
									<th>Reason</th>
								</tr>
							</thead>
							<tbody>
								<cfset i = 1>
								<cfloop array="#rc.annualLeave#" index="annual">
									<cfset tyleTime = annual.typeId==1?' days':' hours'>
									<tr>
										<td>#i#</td>
										<td>
											<cfif annual.isMoreday == true>
												#LSDATEFORMAT(annual.startTime,'dd/mm/yyyy')# - #LSDATEFORMAT(annual.endTime,'dd/mm/yyyy')#
											<cfelse>
												#LSDATEFORMAT(annual.startTime,'dd/mm/yyyy')#
											</cfif>
										</td>
										<td>
											#annual.numberDay# #tyleTime# 
											<cfif annual.timeOff neq "" && annual.timeOff neq "all">
												(#annual.timeOff#)
											</cfif>
										</td>
										<td>
											#entityLoadByPK('dayofftype',annual.typeId).statusName#
										</td>
										<td>#annual.reason#</td>
									</tr>
								<cfset i +=1>
								</cfloop>
							</tbody>
						</table>
						
					</div>
				</div>

			</div>
		</div>
	</article>

	<article class="col-sm-12 col-md-12 col-lg-12 hide" id="sicknessLeave">
		<div class="jarviswidget jarviswidget-color-greenDark" id="wid-id-2" data-widget-editbutton="false">
			<header>
				<span class="widget-icon"> <i class="fa fa-table"></i> </span>
				<h2>URGENT CASE OFF</h2>

			</header>
			<div>
				<div class="jarviswidget-editbox">
				</div>
				<div class="widget-body no-padding">
					<div class="table-responsive">
							
						<table id="sTable" class="table table-striped table-bordered table-hover dt_basic center thcenter" width="100%">
							<thead>
								<tr>
									<th rowspan="2">##</th>
									<th rowspan="2">Date</th>
									<th colspan="2">Times</th>
									<th rowspan="2">Reason</th>
								</tr>
								<tr>
									<th>A/L</th>
									<th>S/L</th>
								</tr>
							</thead>
							<tbody>
								<cfset i = 1>
								<cfloop array="#rc.sicknessLeave#" index="sicknees">
									<tr>
										<td>#i#</td>
										<td>
											<cfif sicknees.isMoreday == true>
												#LSDATEFORMAT(sicknees.startDate,'dd/mm/yyyy')# - #LSDATEFORMAT(sicknees.endDate,'dd/mm/yyyy')#
											<cfelse>
												#LSDATEFORMAT(sicknees.startDate,'dd/mm/yyyy')#
											</cfif>
										</td>
										<td>
											#sicknees.annualDay#
										</td>
										<td>
											#sicknees.sicknessDay#
										</td>
										<td>#sicknees.dueToSickness#</td>
									</tr>
									<cfset i +=1>
								</cfloop>
							</tbody>
						</table>
						
					</div>
				</div>

			</div>
		</div>
	</article>

	<article class="col-sm-12 col-md-12 col-lg-12 hide" id="overTime">
		<div class="jarviswidget jarviswidget-color-greenDark" id="wid-id-2" data-widget-editbutton="false">
			<header>
				<span class="widget-icon"> <i class="fa fa-table"></i> </span>
				<h2>Over Time</h2>

			</header>
			<div>
				<div class="jarviswidget-editbox">
				</div>
				<div class="widget-body no-padding">
					<div class="table-responsive">
							
						<table id="oTable" class="table table-striped table-bordered table-hover center thcenter" width="100%">
							<thead>
								<tr>
									<th>##</th>
									<th>Date</th>
									<th>From</th>
									<th>To</th>
									<th>Hours</th>
								</tr>
							</thead>
							<tbody>
								<cfset i = 1>
								<cfloop array="#rc.overTime#" index="ot"> 
									<tr>
										<td>#i#</td>
										<td>#LSDATEFORMAT(ot.requestTime,'dd/mm/yyyy')#</td>
										<td>#ot.from#</td>
										<td>#ot.to#</td>
										<td>#ot.hours#</td>
									</tr>
									<cfset i += 1 >
								</cfloop>
								<cfloop array="#rc.annualLeave#" index="annual">
									<cfif annual.typeId==2>
										<tr>
											<td>#i#</td>
											<td>
												<cfif annual.isMoreday == true>
													#LSDATEFORMAT(annual.startTime,'dd/mm/yyyy')# - #LSDATEFORMAT(annual.endTime,'dd/mm/yyyy')#
												<cfelse>
													#LSDATEFORMAT(annual.startTime,'dd/mm/yyyy')#
												</cfif>
											</td>
											<td>
												<cfif annual.timeOff eq "all" OR annual.endTime == "">
													all day
												<cfelse>
												#dateTimeFormat(annual.startTime,'HH:nn')#
												</cfif>
											</td>
											<td>
												#dateTimeFormat(annual.endTime,'HH:nn')#
											</td>
											<td>
												-#annual.numberDay# 
											</td>
										</tr>
									</cfif>
									<cfset i += 1 >
								</cfloop>
							</tbody>
						</table>
						
					</div>
				</div>

			</div>
		</div>
	</article>
	<!-- Modal -->
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">
						&times;
					</button>
					<h4 class="modal-title">
						Paid For Annual Leave
					</h4>
				</div>
				<div class="modal-body no-padding">
					<cfif !ArrayIsEmpty(rc.annual_LeaveYear)>
						<form id="login-form" class="smart-form" method="POST">
								<fieldset>
									<section>
										<div class="row">
											<label class="col col-2"></label>
											<label class="col col-2">#rc.annual_LeaveYear[1].year#</label>
											<label class="col col-4">Annual leave exist: </label>
											<label class="col col-2">#rc.annual_LeaveYear[1].alOffTotal - rc.annual_LeaveYear[1].alOff -rc.annual_LeaveYear[1].numberPaid#</label>
											<label class="col col-2"></label>
										</div>
									</section>

									<section>
										<div class="row">
											<label class="col col-4">Annual leave have paid</label>
											<div class="col col-4">
												<label class="input"> <i class="icon-append fa fa-money"></i>
													<input type="number" name="annual_LeavePaid" step="0.5" min="0.5" max="#rc.annual_LeaveYear[1].alOffTotal - rc.annual_LeaveYear[1].alOff -rc.annual_LeaveYear[1].numberPaid#">
													<input type="hidden" value="#URL.u#" name="userId">
												</label>
											</div>
										</div>
									</section>
									<cfif arrayLen(rc.logAnnual) gt 0>
										<section>
											<div class="row">
												<label class="col col-5"><strong>List Paid</strong></label>
											</div>
											<cfloop array=#rc.logAnnual# index="lAnnual">
											<div class="row">
												<label class="col col-4">#dateFormat(lAnnual.createTime,'dd/mm/yyyy')#</label>
												<label class="col col-8">#lAnnual.action#</label>
											</div>
											</cfloop>
										</section>
									</cfif>

								</fieldset>
								
								<footer>
									<button type="submit" class="btn btn-primary">
										Ok
									</button>
									<button type="button" class="btn btn-default" data-dismiss="modal">
										Cancel
									</button>

								</footer>
							</form>	
					<cfelse>
						<h5 class="modal-title" style="text-align: center;margin-bottom: 20px;margin-top: 20px;">
							This is new Member
						</h5>
					</cfif>
				</div>

			</div><!-- /.modal-content -->
		</div><!-- /.modal-dialog -->
	</div>
	<!-- /.modal -->
	<!-- Modal paid overtime -->
	<div class="modal fade" id="paidOvertime" tabindex="-1" role="dialog">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">
						&times;
					</button>
					<h4 class="modal-title">
						Paid For Overtime
					</h4>
				</div>
				<div class="modal-body no-padding">
					<form class="smart-form" action="/index.cfm/manager/paid_overtime" method="POST">
						<fieldset>
							<section>
								<div class="row">
									<label class="col col-6">Overtime exist:</label>
									<label class="col col-6">#rc.user[1].overtimes#</label>
								</div>
							</section>

							<section>
								<div class="row">
									<label class="col col-6">Overtime have paid</label>
									<div class="col col-6">
										<cfif rc.user[1].overtimes gt 0 >
											<label class="input"> <i class="icon-append fa fa-clock-o"></i>
												<input type="number" name="paidnumber" step="0.5" min="0.5" max="#rc.user[1].overtimes#">
												<input type="hidden" value="#URL.u#" name="uId">
											</label>
										<cfelse>
											<label>None.</label>
										</cfif>
									</div>
								</div>
							</section>

							<cfif arrayLen(rc.logPaidOvertime) gt 0>
								<section>
									<div class="row">
										<label class="col col-5"><strong>List Paid</strong></label>
									</div>
									<cfloop array=#rc.logPaidOvertime# index="paidOvertime">
									<div class="row">
										<label class="col col-4">#dateFormat(paidOvertime.createTime,'dd/mm/yyyy')#</label>
										<label class="col col-8">#paidOvertime.action#</label>
									</div>
									</cfloop>
								</section>
							</cfif>

						</fieldset>
						
						<footer>
							<cfif rc.user[1].overtimes gt 0 >
							<button type="submit" class="btn btn-primary">
								Ok
							</button>
							</cfif>
							<button type="button" class="btn btn-default" data-dismiss="modal">
								Cancel
							</button>

						</footer>
					</form>	
				</div>

			</div><!-- /.modal-content -->
		</div><!-- /.modal-dialog -->
	</div>
	<!-- /.modal -->

	<!-- Modal late -->
	<!--- <div class="modal fade" id="lateModal" tabindex="-1" role="dialog">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">
						&times;
					</button>
					<h4 class="modal-title">
						Paid For Late
					</h4>
				</div>
				<div class="modal-body no-padding">
					<cfif arrayLen(rc.lateInfo) gt 0>
						<form id="login-form" class="smart-form" method="POST" action="/index.cfm/manager.payLate">
							<fieldset>
								<section>
									<cfset totalMoney = 0>
									<cfloop collection="#rc.lateInfo#" item="month">
										<cfset totalMoney = totalMoney + 10000 * 2^(arrayLen(rc.lateInfo[month])-1)>
										<div class="row">
											<label class="col col-2"></label>
											<label class="col col-2">#MonthAsString(month)# </label>
											<label class="col col-2">#arrayLen(rc.lateInfo[month])#</label>
											<label class="col col-6">#NumberFormat(10000 * 2^(arrayLen(rc.lateInfo[month])-1),",")# VND</label>
										</div>
									</cfloop>
									<br>
									<hr>
									<br>
									<div class="row">
										<label class="col col-2"></label>
										<label class="col col-2">Total: </label>
										<label class="col col-2"></label>
										<label class="col col-6">#NumberFormat(totalMoney,",")# VND</label>
									</div>
								</section>
							</fieldset>
							<input type="hidden" value="#URL.u#" name="uId">
							<input type="hidden" value="#totalMoney#" name="totalMoney">
							<footer>
								<button type="submit" class="btn btn-primary">
									Pay
								</button>
								<button type="button" class="btn btn-default" data-dismiss="modal">
									Cancel
								</button>
							</footer>
						</form>
					<cfelse>
						<h5 class="modal-title" style="text-align: center;margin-bottom: 20px;margin-top: 20px;">
						 Good staff no late.
						</h5>
					</cfif>
					
				</div>

			</div><!-- /.modal-content -->
		</div><!-- /.modal-dialog -->
	</div> --->
	<!-- /.modal -->
</cfoutput>

<script type="text/javascript">
		
		$(document).ready(function() {
			<cfoutput>
				<cfif CGI.REQUEST_METHOD eq "POST">
					<cfif structKeyExists(rc,'stt')>
							$.smallBox({
								title : "Notification",
								content : "<i class='fa fa-clock-o'></i> <i>#rc.stt#.</i>",
								color : "##659265",
								iconSmall : "fa fa-check fa-2x fadeInRight animated",
								timeout : 4000
							});
					<cfelse>
							$.smallBox({
								title : "Notification",
								content : "<i class='fa fa-clock-o'></i> <i>OOP! Something wrong, Please Try again.</i>",
								color : "##C46A69",
								iconSmall : "fa fa-check fa-2x fadeInRight animated",
								timeout : 4000
							});
					</cfif>
				</cfif>
			</cfoutput>
			var responsiveHelper_aTable  = undefined;
			var responsiveHelper_sTable  = undefined;
			var responsiveHelper_oTable = undefined;
			var breakpointDefinition = {
					tablet : 1024,
					phone : 480
				};
			 $('#aTable').dataTable({
					"sDom": "<'dt-toolbar'<'col-xs-12 col-sm-6'f><'col-sm-6 col-xs-12 hidden-xs'l>r>"+
						"t"+
						"<'dt-toolbar-footer'<'col-sm-6 col-xs-12 hidden-xs'i><'col-xs-12 col-sm-6'p>>",
					"autoWidth" : true,
					"preDrawCallback" : function() {
						// Initialize the responsive datatables helper once.
						if (!responsiveHelper_aTable) {
							responsiveHelper_aTable = new ResponsiveDatatablesHelper($('#aTable'), breakpointDefinition);
						}
					},
					"rowCallback" : function(nRow) {
						responsiveHelper_aTable.createExpandIcon(nRow);
					},
					"drawCallback" : function(oSettings) {
						responsiveHelper_aTable.respond();
					}
				})
			 ;
			 $('#sTable').dataTable({
					"sDom": "<'dt-toolbar'<'col-xs-12 col-sm-6'f><'col-sm-6 col-xs-12 hidden-xs'l>r>"+
						"t"+
						"<'dt-toolbar-footer'<'col-sm-6 col-xs-12 hidden-xs'i><'col-xs-12 col-sm-6'p>>",
					"autoWidth" : true,
					"preDrawCallback" : function() {
						// Initialize the responsive datatables helper once.
						if (!responsiveHelper_sTable) {
							responsiveHelper_sTable = new ResponsiveDatatablesHelper($('#sTable'), breakpointDefinition);
						}
					},
					"rowCallback" : function(nRow) {
						responsiveHelper_sTable.createExpandIcon(nRow);
					},
					"drawCallback" : function(oSettings) {
						responsiveHelper_sTable.respond();
					}
				});
			 $('#oTable').dataTable({
					"sDom": "<'dt-toolbar'<'col-xs-12 col-sm-6'f><'col-sm-6 col-xs-12 hidden-xs'l>r>"+
						"t"+
						"<'dt-toolbar-footer'<'col-sm-6 col-xs-12 hidden-xs'i><'col-xs-12 col-sm-6'p>>",
					"autoWidth" : true,
					"preDrawCallback" : function() {
						// Initialize the responsive datatables helper once.
						if (!responsiveHelper_oTable) {
							responsiveHelper_oTable = new ResponsiveDatatablesHelper($('#oTable'), breakpointDefinition);
						}
					},
					"rowCallback" : function(nRow) {
						responsiveHelper_oTable.createExpandIcon(nRow);
					},
					"drawCallback" : function(oSettings) {
						responsiveHelper_oTable.respond();
					}
				});

			 $('#selectType').change(function(event) {
			 	console.log($(this).val());
			 	if($(this).val()==1)
			 	{
			 		$('#annualeave').removeClass('hide');
			 		$('#sicknessLeave').addClass('hide');
			 		$('#overTime').addClass('hide');
			 	}else if($(this).val()==2)
			 	{
			 		$('#sicknessLeave').removeClass('hide');
			 		$('#annualeave').addClass('hide');
			 		$('#overTime').addClass('hide');
			 	}if($(this).val()==3)
			 	{
			 		$('#overTime').removeClass('hide');
			 		$('#sicknessLeave').addClass('hide');
			 		$('#annualeave').addClass('hide');
			 	}
			 });
		})

</script>