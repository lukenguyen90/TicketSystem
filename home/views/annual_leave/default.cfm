<style type="text/css">
.daterangepicker .ranges, .daterangepicker .calendar {
    float: right;
}
.po th {
	text-align: center !important; 
}
.datepicker{
	z-index: 1100 !important;
}
.check_required{
	cursor: pointer;
}
</style>
<cfoutput>
	<div class="well">
		<div class="row">
			<div class="col-md-3">
                <div class="ibox-content text-center">
                	<cfset avatar = "">
	        		<cfif rc.user.avatar EQ "">
						<cfset avatar = "/fileupload/avatars/default.jpg">
					<cfelse>
						<cfif FileExists(expandPath("/fileupload/avatars/")&rc.user.avatar)>
							<cfset avatar ="/fileupload/avatars/# rc.user.avatar#">
						<cfelse>
							<cfset avatar ="/fileupload/avatars/default.jpg">
						</cfif>
					</cfif>
                    <h1>#rc.user.firstname# #rc.user.lastname#</h1>
                    <div class="m-b-sm center">
                            <img alt="image" width="100" class="img-circle" src="#avatar#">
                    </div>
                </div>
            </div>
            <div class="col-md-9">
            	<div class="center" style="margin-top:4em">
					<span class="btn btn-app btn-sm btn-success no-hover">
						<span class="line-height-1 bigger-170 "> #rc.annual_leave.alOffTotal - rc.annual_leave.alOff#</span>

						<br />
						<span class="line-height-1 smaller-90"> A/L Total </span>
					</span>

					<span class="btn btn-app btn-sm btn-success no-hover">
						<span class="line-height-1 bigger-170"> #rc.annual_leave.alOff# </span>

						<br />
						<span class="line-height-1 smaller-90"> A/L Off </span>
					</span>

					<span class="btn btn-app btn-sm btn-warning no-hover">
						<span class="line-height-1 bigger-170"> #rc.annual_leave.sloffTotal - rc.annual_leave.sloff# </span>

						<br />
						<span class="line-height-1 smaller-90"> S/L Total </span>
					</span>

					<span class="btn btn-app btn-sm btn-warning no-hover">
						<span class="line-height-1 bigger-170"> #rc.annual_leave.sloff# </span>

						<br />
						<span class="line-height-1 smaller-90"> S/L Off </span>
					</span>

					<span class="btn btn-app btn-sm btn-info no-hover">
						<span class="line-height-1 bigger-170"> #rc.annual_leave.overtimes#</span>

						<br />
						<span class="line-height-1 smaller-90"> Over Time </span>
					</span>

					<span class="btn btn-app btn-sm btn-danger no-hover">
						<span class="line-height-1 bigger-170"> 0 </span>

						<br />
						<span class="line-height-1 smaller-90"> Late </span>
					</span>
				</div>
            </div>
		</div>
		<hr>
		<div class="row">
			<div class="col-md-3">
				 <div class="ibox-content text-center">
				 	<button class="btn btn-sm btn-primary"  data-toggle="modal" data-target="##absentModal">#getLabel("Absent",#SESSION.languageId#)# </button>
					<button class="btn btn-sm btn-info"  data-toggle="modal" data-target="##overtimeModal">#getLabel("Add overtime",#SESSION.languageId#)# </button>
				 </div>
			</div>
			<div class="col-md-2 col-md-offset-5">
				<select  id="selectTab">
					<option value="lRequest">List Request</option>
					<option value="lRequired">List Required</option>
					<option value="doReport">Days Off Report</option>
				</select>
			</div>
		</div>
		
	</div>

	<div class="row tabss" id="lRequest">
		<div class="col-xs-11">
			<div class="widget-box widget-color-blue">
				<div class="widget-header">
					<h4 class="widget-title lighter">List Request<h4>
				</div>
				<div class="widget-body">
					<div class="widget-main no-padding">
						<table class="table table-hover datatable table-bordered po center">
							<thead>
								<tr>
									<th>Type</th>
									<th>Date</th>
									<th>Reason</th>
									<th>Approve</th>
									<th>Reject</th>
									<th>Status</th>
								</tr>
							</thead>
							<tbody>
								<cfloop array="#rc.requests#" index="action">
									<cfset status = "Waiting">
									<cfset color = "success">
									<cfswitch expression="#action.status#">
										<cfcase value="1"> 
											<cfset status = "Approve">
											<cfset color = "success">
										</cfcase>

										<cfcase value="-1">
											<cfset status = "Reject">
											<cfset color = "danger">
										</cfcase>

										<cfcase value="0">
											<cfset status = "Waiting">
											<cfset color = "default">
										</cfcase>
									</cfswitch>
									<tr>
										<td>
											#action.type#
										</td>

										<td>
											#action.date#
										</td>

										<td>
											#action.reason#
										</td>

										<td>
											<cfset approver = "">
											<cfset splitSymbol = "">
											<cfset qApprover = QueryExecute("select concat(firstname,' ',lastname) as name from users left join checkRequired on users.userID = checkRequired.user where checkRequired.requireType = #action.requestType# and checkRequired.required = #action.id# and checkType = 1")>
											<cfloop query="#qApprover#">
												<cfset approver &= splitSymbol&qApprover.name>
												<cfset splitSymbol = " , ">
											</cfloop>
											#approver#
										</td>

										<td>
											<cfset reject = "">
											<cfset splitSymbol = "">
											<cfset qReject = QueryExecute("select concat(firstname,' ',lastname) as name from users left join checkRequired on users.userID = checkRequired.user where checkRequired.requireType = #action.requestType# and checkRequired.required = #action.id# and checkType = -1")>
											<cfloop query="#qReject#">
												<cfset reject &= splitSymbol&qReject.name>
												<cfset splitSymbol = " , ">
											</cfloop>
											#reject#
										</td>

										<td>
											<span class="label label-#color#">#status#</span>
										</td>
										
									</tr>
								</cfloop>
							</tbody>

						</table>
					</div>
				</div>
			</div>
		</div>
	</div>	
	<div class="row hide tabss" id="lRequired">
		<div class="col-xs-11">
			<div class="widget-box widget-color-blue">
				<div class="widget-header">
					<h4 class="widget-title lighter">List Required<h4>
				</div>
				<div class="widget-body">
					<div class="widget-main no-padding">
						<table class="table table-hover datatable table-bordered po center">
							<thead>
								<tr>
									<th>Name</th>
									<th>Type</th>
									<th>Date</th>
									<th>Reason</th>
									<th>Status</th>
									<th>Action</th>
								</tr>
							</thead>
							<tbody>
								<cfloop array="#rc.requireds#" index="action">
									<cfset status = "Waiting">
									<cfset color = "success">
									<cfswitch expression="#action.status#">
										<cfcase value="1"> 
											<cfset status = "Approve">
											<cfset color = "success">
										</cfcase>

										<cfcase value="-1">
											<cfset status = "Reject">
											<cfset color = "danger">
										</cfcase>

										<cfcase value="0">
											<cfset status = "Waiting">
											<cfset color = "default">
										</cfcase>
									</cfswitch>
									<tr>
										<td>
											#action.name#
										</td>
										<td>
											#action.type#
										</td>

										<td>
											#action.date#
										</td>

										<td>
											#action.reason#
										</td>

										<td>
											<span class="label label-#color#">#status#</span>
										</td>

										<td class="action_buttons">
											<cfif action.status eq 0>
												<div class="hidden-sm hidden-xs action-buttons" data-id="#action.id#">
													<a class="blue check_required" data-type="1">
														<i class="ace-icon fa fa-check bigger-130"></i>
													</a>

													<a class="red check_required" data-type="-1">
														<i class="ace-icon fa fa-close bigger-130"></i>
													</a>
												</div>
											</cfif>
										</td>
										
									</tr>
								</cfloop>
							</tbody>

						</table>
					</div>
				</div>
			</div>
		</div>
	</div>	

	<div class="row hide tabss" id="doReport">
		<div class="col-xs-11">
			<div class="widget-box widget-color-blue">
				<div class="widget-header">
					<h4 class="widget-title lighter">Days Off Report<h4>
				</div>
				<div class="widget-body">
					<div class="widget-main no-padding">
						<table class="table table-hover center datatable table-bordered po">
							<thead>
								<tr>
									<th rowspan="2">Type</th>
									<th rowspan="2">Date</th>
									<th rowspan="2">Reason</th>
									<th colspan="3">Times</th>
								</tr>
								<tr>
									<th>A\L</th>
									<th>S\L</th>
									<th>OT</th>
								</tr>
							</thead>
							<tbody>
								<cfloop array="#rc.reportDayOff#" index="report">
									<cfset type = ''>
									<cfset al = 0>
									<cfset sl = 0>
									<cfset ot = 0>
									<cfswitch expression="#report.typeId#">
										<cfcase value="1">
											<cfset type = 'Annual leave'>
											<cfset al = report.numberDay>
										</cfcase>

										<cfcase value="2">
											<cfset type = 'Use overtime'>
											<cfset ot = report.numberDay>
										</cfcase>

										<cfcase value="3">
											<cfset type = 'Urgent case off'>
											<cfset al = report.annualDay>
											<cfset sl = report.sicknessDay>
										</cfcase>

										<cfcase value="4">
											<cfset type = 'Paid Overtime'>
											<cfset al = report.numberDay>
										</cfcase>

										<cfcase value="5">
											<cfset type = 'Paid Annual leave'>
											<cfset ot = report.numberDay>
										</cfcase>
									</cfswitch>
									<tr>
										<td>#type#</td>
										<td>
											<cfif report.isMoreday eq 1>
						        				#LSDATEFORMAT(report.startTime,'yyyy-mm-dd')# - #LSDATEFORMAT(report.endTime,'yyyy-mm-dd')#
						        			<cfelse>
						        				#LSDATEFORMAT(report.startTime,'yyyy-mm-dd')#
						        			</cfif>
										</td>
										<td>#report.reason#</td>
										<td>#al#</td>
										<td>#sl#</td>
										<td>#ot#</td>
									</tr>
								</cfloop>
							</tbody>

						</table>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<!-- Model Absent -->
	<div class="modal fade" id="absentModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog" role="document">
			<form class="form-horizontal" id="annual_leaveFrm" role="form" action="/index.cfm/annual_leave" method="post">
			    <div class="modal-content">
			      <div class="modal-header">
			        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
			        <h4 class="modal-title" id="myModalLabel">Schedule take day off</h4>
			      </div>
			      <div class="modal-body">
			      		<div class="alert alert-danger hide" id="alert-danger">

							<strong>
								<i class="ace-icon fa fa-times"></i>
								Oh snap!
							</strong>
								<span id="content_notice">You must to announce the day off before 2 days count on the day has been successfully submitted.</span>
							<br>
						</div>
			      		<div class="form-group">
							<label for="ot_day" class="col-sm-4">Choose Type:</label>
							<select name="typeoff" id="typeoff" class="col-sm-6">
								 <option value="1">Annual leave</option>
								 <cfif rc.annual_leave.overtimes gte 0>
								 	<option value="2">Use OverTime</option>
								 </cfif>
							</select>
						</div>

			      		<div class="form-group" id="switchMoreday">
							<label for="ot_day" class="col-sm-4">More days:</label>
							<label>
								<input name="onoffswitch" id="onoffswitch" class="ace ace-switch ace-switch-4 btn-empty" type="checkbox">
								<span class="lbl"></span>
							</label>
						</div>
						<div id="oneday">
							<div class="form-group">
								<label class="col-sm-4">Choose date</label>
								<div class="input-group">
									<input class="form-control date-picker ot_day" type="text" id="oneDatePick" name="oneDatePick" value="#dateFormat(now(),'dd/mm/yyyy')#" required />
									<span class="input-group-addon">
										<i class="fa fa-calendar bigger-110"></i>
									</span>
								</div>							</div>
							<div class="form-group" id="alOneday">
								<label for="ot_day" class="col-sm-4">Time:</label>
								<select name="timeOff" id="timeOff" class="col-sm-6">
									<option value="am">9h - 12h</option>
									<option value="pm">13h - 18h30</option>
									<option value="all">All Day</option>
								</select>
							</div>
							<div id="otOneday" class="hide">
								<div class="form-group">
									<label for="ot_project" class="col-sm-4">From:</label>
									<div class="input-group bootstrap-timepicker col-sm-4">
										<input name="startTime" type="text" class="form-control timepicker" />
										<span class="input-group-addon">
											<i class="fa fa-clock-o bigger-110"></i>
										</span>
									</div>
								</div>
								<div class="form-group">
									<label for="ot_project" class="col-sm-4">To:</label>
									<div class="input-group bootstrap-timepicker col-sm-4">
										<input name="endTime" type="text" class="form-control timepicker" />
										<span class="input-group-addon">
											<i class="fa fa-clock-o bigger-110"></i>
										</span>
									</div>
								</div>
							</div>
						</div>
						<div id="moreday" class="hide">
							<div class="form-group">
								<label for="ot_day" class="col-sm-4">Choose date:</label>
								<div class="input-group">
									<input class="form-control" type="text" name="daterangepicker" id="id-date-range-picker-1" />
									<span class="input-group-addon">
										<i class="fa fa-calendar bigger-110"></i>
									</span>
								</div>
							</div>
						</div>

						<div class="form-group">
							<label for="isNumber" id="textTotal" class="col-sm-4">Total hours:</label>
							<input class="col-sm-6" type="text" name="totalDayOff" id="isNumber" required>  
						</div>
						<cfif SESSION.userType neq 3>
			      		<div class="form-group">
							<label for="ot_day" class="col-sm-4">Confirm to:</label>
							<select name="confirm_to" id="typeoff" class="col-sm-6">
								<cfloop array=#rc.requiredList# index="cr">
									<option value="#cr.id#">#cr.name#</option>
								</cfloop>
							</select>
						</div>
						</cfif>

						<label for="inforReason">Due to:</label>
						<div class="row">
							<div class="col-xs-8 col-sm-11">
									<textarea class="form-control" id="inforReason" name="inforReason" placeholder="Default Text"></textarea>
							</div>
						</div>
			      </div>
			      <div class="modal-footer">
			        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
			        <button type="submit" class="btn btn-primary">Save changes</button>
			      </div>
			    </div>
		    </form>
	  </div>
	</div>
	<!-- Model add overtime -->
	<div class="modal fade" id="overtimeModal" tabindex="-1" role="dialog" aria-labelledby="myModalAddOvertime" aria-hidden="true">
		<div class="modal-dialog" role="document">
			<form class="form-horizontal" id="ot_add_form" role="form" action="/index.cfm/annual_leave/overtime_request" method="post">
			    <div class="modal-content">
			      <div class="modal-header">
			        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
			        <h4 class="modal-title" id="myModalAddOvertime">Add Overtime</h4>
			      </div>
			      <div class="modal-body">
			      		<div class="alert alert-danger hide" id="alert-dangerOt">
							<strong>
								<i class="ace-icon fa fa-times"></i>
								Oh snap!
							</strong>
								<span id="content_notice">You must to announce the day off before 2 days count on the day has been successfully submitted.</span>
							<br>
						</div>

						<div class="form-group">
							<label for="ot_day" class="col-sm-4">Choose day overtime:</label>
							<div class="input-group" class="col-sm-8">
								<span class="input-group-addon">
									<i class="fa fa-calendar bigger-110"></i>
								</span>
								<input class="form-control date-picker ot_day" type="text" id="ot_day" name="ot_day" value="#dateFormat(now(),'dd/mm/yyyy')#" required />
							</div>
						</div>

						<div class="form-group">
							<label for="ot_project" class="col-sm-4">Project working on:</label>
							<select name="ot_project" id="ot_project" class="col-sm-8" >
								<option value="0">Choose Project.</option>
								<cfloop query="rc.projects">
									<option value="#rc.projects.projectID#">#rc.projects.projectName#</option>
								</cfloop>
							</select>
						</div>

						<div class="form-group">
							<label for="ot_project" class="col-sm-4">Choose your task</label>
							<select multiple="" class="chosen-select-events" id="listevent" name="tasks" data-placeholder="#getLabel('Choose an event')#...">
							</select>
						</div>
						
						<div class="form-group">
							<label for="ot_project" class="col-sm-4">From:</label>
							<div class="input-group bootstrap-timepicker col-sm-4">
								<input name="fromOvertime" type="text" class="form-control timepicker" />
								<span class="input-group-addon">
									<i class="fa fa-clock-o bigger-110"></i>
								</span>
							</div>
						</div>

						<div class="form-group">
							<label for="ot_project" class="col-sm-4">To:</label>
							<div class="input-group bootstrap-timepicker col-sm-4">
								<input name="toOvertime" type="text" class="form-control timepicker" />
								<span class="input-group-addon">
									<i class="fa fa-clock-o bigger-110"></i>
								</span>
							</div>
						</div>

						<div class="form-group">
							<label class="col-sm-4" for="ot_hours">Hours:</label>
							<input class="col-sm-8" type="number" min="0" max="10" step="0.5" name="ot_hours" id="ot_hours" required> 
						</div>

						<div class="form-group">
							<label for="ot_cmt" class="col-sm-12">Comment:</label>
							<div class="col-sm-12">
								<textarea class="form-control" id="ot_cmt" name="ot_cmt" placeholder="Default Text" required></textarea>
							</div>
						</div>
			      </div>
			      <div class="modal-footer">
			        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
			        <button type="submit" class="btn btn-primary">Save changes</button>
			      </div>
			    </div>
		    </form>
	  </div>
	</div>
	<!-- Model check required -->
	<div class="modal fade" id="check_required_modal" tabindex="-1" role="dialog" aria-labelledby="myModalCheckRequired" aria-hidden="true">
		<div class="modal-dialog" role="document">
			<form class="form-horizontal" role="form" action="/index.cfm/annual_leave/checking_required" method="post">
			    <div class="modal-content">
			      <div class="modal-header">
			        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
			        <h4 class="modal-title">Checking required</h4>
			      </div>
			      <div class="modal-body">
		      		<div class="alert alert-danger">
						<strong>
							<i class="ace-icon fa fa-times"></i>
							Note!
						</strong>
							<span id="check_required_message"></span>
							<p>
							Remember, you can't recheck this request any more.
							</p>
						<br>
					</div>
					<input id="check_required_id" name="rid" value="" type="hidden">
					<input id="check_required_type" name="rtype" value="" type="hidden">

			      </div>
			      <div class="modal-footer">
			        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
			        <button type="submit" class="btn btn-primary">Save changes</button>
			      </div>
			    </div>
		    </form>
	  </div>
	</div>


<script type="text/javascript">
	$(document).ready(function(){
		$('.chosen-select-events').chosen({allow_single_deselect:true});
		$('.chosen-select-events').next().css({'width':300});

        $('.po').dataTable({
        	'iDisplayLength': 25
        });

        $('.ot_day').datepicker({ 
        	  format: 'dd/mm/yyyy'
        });
        

        $('.timepicker').timepicker({
			minuteStep: 1,
			showSeconds: false,
			showMeridian: false
		}).next().on(ace.click_event, function(){
			$(this).prev().focus();
		});

        $('input[name=daterangepicker]').daterangepicker({
		    format: 'DD/MM/YYYY',
			'applyClass' : 'btn-sm btn-success',
			'cancelClass' : 'btn-sm btn-default',
			locale: {
				applyLabel: 'Apply',
				cancelLabel: 'Cancel',
			}
		})
		.prev().on(ace.click_event, function(){
			$(this).next().focus();
			
		});
		$('input[name=daterangepicker]').on('apply.daterangepicker',function(ev, picker){
			$.ajax({
	            type: "POST",
	            url: "/index.cfm/annual_leave/getDayDiff",
	            data: {
	            	startDate:picker.startDate.format('YYYY-MM-DD'),
	            	endDate: picker.endDate.format('YYYY-MM-DD')          	
	            },
	            success: function( data ) {	
	            	if($('##typeoff').val()==2)
	            		$('##isNumber').val(data.numberday *8.5);
	            	else
	            		$('##isNumber').val(data.numberday);
	            }
	     	});
		});
		$('##timeOff').change(function() {
			if($(this).val()=='all')
			{
				$('##isNumber').val(8);
			}else
			{
				$('##isNumber').val(4);
			}
		});

		$('##typeoff').change(function(event) {
			if($(this).val()==1)
			{
				$('##isNumber').val('');
				$('##textTotal').html('Total days:');
				$('##alOneday').removeClass('hide');
				$('##otOneday').addClass('hide');
				if($('##onoffswitch').prop('checked'))
				{
					$('##oneday').addClass('hide');
					$('##moreday').removeClass('hide');
					$('##textTotal').html('Total days:');
				}else{
					$('##oneday').removeClass('hide');
					$('##moreday').addClass('hide');
					$('##textTotal').html('Total hours:');
				}
			}else
			{
				$('##isNumber').val('');
				$('##textTotal').html('Total hours:');
				if($('##onoffswitch').prop('checked'))
				{
					$('##alOneday').removeClass('hide');
					$('##otOneday').addClass('hide');
					$('##oneday').addClass('hide');
					$('##moreday').removeClass('hide');
				}else{
					$('##alOneday').addClass('hide');
					$('##otOneday').removeClass('hide');
					$('##oneday').removeClass('hide');
					$('##moreday').addClass('hide');
				}
			}
		});

		$('##selectTab').change(function(event) {
			var tab = $(this).val();
			$('.tabss').addClass('hide');
			$('##'+tab).removeClass('hide');
		});

		$('##onoffswitch').click(function(event) {
			$this = $(this);
			if($this.prop('checked')){
				$('##oneday').addClass('hide');
				$('##moreday').removeClass('hide');
				if($('##typeoff').val()==2)
				{
					$('##textTotal').html('Total hours:');
					$('##alOneday').addClass('hide');
					$('##otOneday').removeClass('hide');
				}else{
					$('##textTotal').html('Total days:');
					$('##alOneday').removeClass('hide');
					$('##otOneday').addClass('hide');
				}
			}else{
				$('##oneday').removeClass('hide');
				$('##moreday').addClass('hide');
				$('##textTotal').html('Total hours:');
				if($('##typeoff').val()==2)
				{
					$('##alOneday').addClass('hide');
					$('##otOneday').removeClass('hide');
				}else{
					$('##alOneday').removeClass('hide');
					$('##otOneday').addClass('hide');
				}
			}
		});

		$('##ot_project').change(function(event) {
			console.log($(this).val());
			$.ajax({
	            type: "POST",
	            url: "/index.cfm/annual_leave/getListTask",
	            data: {
	            	pid:$(this).val()      	
	            },
	            success: function( data ) {	
	            		console.log(data);
	            		var option = '<select multiple="" class="chosen-select-events" style="width:300px" id="listevent" name="tasks" data-placeholder="#getLabel('Choose an event')#...">';
	            		// var option = "";
	            		for(var i = 0;i<data.length;i++)
	            		{
	            			option +="<option value='"+data[i].ticketID+"'>"+data[i].code+"</option>"
	            		}
	            		option += "</select>";
	            		$parent = $('##listevent').parent();
					    $('##listevent').find("option").remove().end();
					    $("##listevent_chosen").remove();
					    $('##listevent').remove();
					    $parent.append(option);
					    // $('.chosen-select-events').next().css({'width':300});
					    $('##listevent').chosen({allow_single_deselect:true});
	            }
	     	});
		});
		
		// $('##overtimeModal').submit(function(event) {
		// 	console.log($('##ot_day').val());
		// 	var data = $('##ot_day').val();
		// 	var newDate = data.split('/');
		// 	var date = new Date(newDate[1]+'/'+ newDate[0]+'/'+newDate[2]);
		// 	console.log(date);
		// 	var currentTime = new Date();
		// 	console.log(currentTime);
		// 	var oneDay = 24*60*60*1000;
		// 	var diffDays = Math.round(Math.abs((date.getTime() - currentTime.getTime())/(oneDay))) + 1;
		// 	console.log(diffDays);
		// 	if(diffDays < 0)
		// 		return false;
		// 	else if(diffDays == 0)
		// 	{
		// 		var timeOt = $('input[name=fromOvertime]').val();
		// 		var hours = currentTime.getMinutes();
		// 		console.log(hours);
		// 	}
		// 	return false;
		// });

		$('##annual_leaveFrm').submit(function(event) {
			var multiday = $('##onoffswitch').prop('checked');
			var typeoff = $('##typeoff').val();
			var status = false;
			if(typeoff == 2)
			{
				var numberdayOff = $('input[name=totalDayOff]').val();
				if(numberdayOff > #rc.annual_leave.overtimes#)
				{
					$('##alert-danger').removeClass('hide');
					$('##content_notice').html("Total hours left don't enough !");
					return false;
				}
				if(multiday == false)
				{
					var data = $('##oneDatePick').datepicker('getDate');
					var currentTime = new Date();
					var oneDay = 24*60*60*1000;
					var diffDays = Math.floor(((data- currentTime)/(oneDay))+1);
					if(diffDays == 0)
					{
						var hournow = currentTime.getHours() * 60 + currentTime.getMinutes();
						var fromTime = $('input[name=startTime]').val();
						var fromTime = fromTime.split(':');
						var hourSubmit = fromTime[0] * 60 + fromTime[1]*1
						var timediff = Math.round((hourSubmit - hournow)/60);
						if(timediff<3)
						{
							$('##alert-danger').removeClass('hide');
							$('##content_notice').html('Submit before 3 hours, Please');
							return false;
						}
					}
					if(diffDays <0)
					{
						$('##alert-danger').removeClass('hide');
						$('##content_notice').html('Can not submit in the past.!');
						return false;
					}
					status = true;
				}	
			} 

			if(multiday)
			{
				var data = $('input[name=daterangepicker]').val();
				var arrDate = data.split('-');
				var currentTime = new Date();
				var newDate = arrDate[1].split('/');
				var date = new Date(newDate[1]+'/'+ newDate[0]+'/'+newDate[2]);
				var oneDay = 24*60*60*1000;
				var diffDays = Math.round(Math.abs((date.getTime() - currentTime.getTime())/(oneDay))) + 1;
				var nRelaxDay = 0;
				for (var i = 0; i < diffDays+1; i++) {
					var now = moment();
					var dateLoop =  new Date(now.add('days',i).toString());
					var getDay = dateLoop.getDay();
					if(getDay == 0 || getDay == 6)
						nRelaxDay ++;
				};
				diffDays = diffDays - nRelaxDay;
				if(diffDays <2)
				{
					$('##alert-danger').removeClass('hide');
					$('##content_notice').html('You must to announce the day off before 2 days count on the day has been successfully submitted.');
					return false;
				}
			}
			else
			{
				if(!status)
				{
					var data = $('##oneDatePick').datepicker('getDate');
					var currentTime = new Date();
					var oneDay = 24*60*60*1000;
					var diffDays = Math.floor(((data- currentTime)/(oneDay))+1);
					var nRelaxDay = 0;
					for (var i = 0; i < diffDays+1; i++) {
						var now = moment();
						var dateLoop =  new Date(now.add('days',i).toString());
						var getDay = dateLoop.getDay();
						if(getDay == 0 || getDay == 6)
							nRelaxDay ++;
					};
					diffDays = diffDays - nRelaxDay;
					if(diffDays <2)
					{
						$('##alert-danger').removeClass('hide');
						$('##content_notice').html('You must to announce the day off before 2 days count on the day has been successfully submitted.');
						return false;
					}
				}
				
			}

			
		});

		// check required 
		$(".check_required").on("click",function(event){
			event.stopPropagation();
			var requesID = $(this).parent().attr("data-id");
			var checkType = $(this).attr("data-type");
			if( checkType == "1" ){
				var message = "Are you sure to Approve this request ?";
			}else{
				var message = "Are you sure to Reject this request ?";
			}
			$("##check_required_id").val(requesID);
			$("##check_required_type").val(checkType);
			$("##check_required_message").html(message);
			$("##check_required_modal").modal("show");
		});
    });
</script>
</cfoutput>