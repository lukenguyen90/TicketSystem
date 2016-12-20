<style type="text/css">
.daterangepicker .ranges, .daterangepicker .calendar {
    float: right;
}
</style>
<cfoutput>
	<div class="page-header">
		<div class="row">
				<h1>#getLabel("Annual Dashboard", #SESSION.languageId#)#</h1>
		</div>
	</div>

	<div class="row">
		<div class="col-xs-12">
			<!-- PAGE CONTENT BEGINS -->
			<div class="row">
				<div class="col-xs-12">
					<div class="tabbable">
						<ul id="inbox-tabs" class="inbox-tabs nav nav-tabs padding-16 tab-size-bigger tab-space-1">

							<li class="li-new-mail pull-right">
								<a data-toggle="tab" href="##newEmployer" data-target="newEmployer" class="btn-new-mail">
									<span class="btn btn-purple no-border">
										<span class="bigger-110">Add new employer</span>
									</span>
								</a>
							</li><!-- /.li-new-mail -->

							<li class="li-new-mail pull-right">
								<a data-toggle="tab" href="##write" data-target="write" class="btn-new-mail">
									<span class="btn btn-purple no-border">
										<span class="bigger-110">Add sickness leave</span>
									</span>
								</a>
							</li><!-- /.li-new-mail -->

							<!-- /section:pages/inbox.compose-btn -->
							<li class="active">
								<a data-toggle="tab" href="##inbox" data-target="inbox">
									<span class="bigger-110">Annual leave</span>
									<span class="badge badge-danger">5</span>
								</a>
							</li>

							<li>
								<a data-toggle="tab" href="##ot" data-target="ot">
									<span class="bigger-110">Over time</span>
									<span class="badge badge-danger">5</span>
								</a>
							</li>
						</ul>

						<div class="tab-content no-border no-padding">
							<div id="inbox" class="tab-pane in active">
								<div class="message-container">
									<!-- ##section:pages/inbox.navbar -->
									<div id="id-message-list-navbar" class="message-navbar clearfix">
										<div class="message-bar">
											<div class="message-infobar" id="id-message-infobar">
												<span class="blue bigger-150">Inbox</span>
												<span class="grey bigger-110">(2 unread messages)</span>
											</div>
										</div>

										<div>
											<div class="messagebar-item-left">
												<label class="inline middle">
													<input type="checkbox" id="id-toggle-all" class="ace" />
													<span class="lbl"></span>
												</label>

												&nbsp;
												<div class="inline position-relative">
													<a  data-toggle="dropdown" class="dropdown-toggle">
														<i class="ace-icon fa fa-caret-down bigger-125 middle"></i>
													</a>

													<ul class="dropdown-menu dropdown-lighter dropdown-100">
														<li>
															<a id="id-select-message-all" >All</a>
														</li>

														<li>
															<a id="id-select-message-none" >None</a>
														</li>

														<li class="divider"></li>

														<li>
															<a id="id-select-message-unread" >Unread</a>
														</li>

														<li>
															<a id="id-select-message-read" >Read</a>
														</li>
													</ul>
												</div>
											</div>

											<div class="messagebar-item-right">
												<div class="inline position-relative">
													<a  data-toggle="dropdown" class="dropdown-toggle">
														Sort &nbsp;
														<i class="ace-icon fa fa-caret-down bigger-125"></i>
													</a>

													<ul class="dropdown-menu dropdown-lighter dropdown-menu-right dropdown-100">
														<li>
															<a >
																<i class="ace-icon fa fa-check green"></i>
																Date
															</a>
														</li>

														<li>
															<a >
																<i class="ace-icon fa fa-check invisible"></i>
																From
															</a>
														</li>

														<li>
															<a >
																<i class="ace-icon fa fa-check invisible"></i>
																Subject
															</a>
														</li>
													</ul>
												</div>
											</div>

											<!-- ##section:pages/inbox.navbar-search -->
											<div class="nav-search minimized">
												<form class="form-search">
													<span class="input-icon">
														<input type="text" id="searchName" class="input-small nav-search-input" placeholder="Search name ..." />
														<i class="ace-icon fa fa-search nav-search-icon"></i>
													</span>
												</form>
											</div>

											<!-- /section:pages/inbox.navbar-search -->
										</div>
									</div>

									<div id="id-ot-list-navbar" class="hide message-navbar clearfix">
										<div class="message-bar">
											<div class="message-infobar" id="id-ot-infobar">
												<span class="blue bigger-150">Over Time</span>
												<span class="grey bigger-110">(2 unread messages)</span>
											</div>
										</div>

										<div>
											<div class="messagebar-item-left">
												<label class="inline middle">
													<input type="checkbox" id="id-toggle-all" class="ace" />
													<span class="lbl"></span>
												</label>

												&nbsp;
												<div class="inline position-relative">
													<a  data-toggle="dropdown" class="dropdown-toggle">
														<i class="ace-icon fa fa-caret-down bigger-125 middle"></i>
													</a>

													<ul class="dropdown-menu dropdown-lighter dropdown-100">
														<li>
															<a id="id-select-message-all" >All</a>
														</li>

														<li>
															<a id="id-select-message-none" >None</a>
														</li>

														<li class="divider"></li>

														<li>
															<a id="id-select-message-unread" >Unread</a>
														</li>

														<li>
															<a id="id-select-message-read" >Read</a>
														</li>
													</ul>
												</div>
											</div>

											<div class="messagebar-item-right">
												<div class="inline position-relative">
													<a  data-toggle="dropdown" class="dropdown-toggle">
														Sort &nbsp;
														<i class="ace-icon fa fa-caret-down bigger-125"></i>
													</a>

													<ul class="dropdown-menu dropdown-lighter dropdown-menu-right dropdown-100">
														<li>
															<a >
																<i class="ace-icon fa fa-check green"></i>
																Date
															</a>
														</li>

														<li>
															<a >
																<i class="ace-icon fa fa-check invisible"></i>
																From
															</a>
														</li>

														<li>
															<a >
																<i class="ace-icon fa fa-check invisible"></i>
																Subject
															</a>
														</li>
													</ul>
												</div>
											</div>

											<!-- ##section:pages/inbox.navbar-search -->
											<div class="nav-search minimized">
												<form class="form-search">
													<span class="input-icon">
														<input type="text" id="searchName" class="input-small nav-search-input" placeholder="Search name ..." />
														<i class="ace-icon fa fa-search nav-search-icon"></i>
													</span>
												</form>
											</div>

											<!-- /section:pages/inbox.navbar-search -->
										</div>
									</div>

									<div id="id-message-item-navbar" class="hide message-navbar clearfix">
										<div class="message-bar">
											<div class="message-toolbar">
												<button type="button" class="btn btn-xs btn-primary btn-primary" id="aproveMessage">
													<i class="ace-icon fa fa-check bigger-110"></i>
													<span class="bigger-110">Aprove</span>
												</button>

												<button type="button" class="btn btn-xs btn-danger btn-primary" id="rejectMessage">
													<i class="ace-icon fa fa-times bigger-110"></i>
													<span class="bigger-110">Reject</span>
												</button>
											</div>
										</div>

										<div>
											<div class="messagebar-item-left">
												<a  class="btn-back-message-list">
													<i class="ace-icon fa fa-arrow-left blue bigger-110 middle"></i>
													<b class="bigger-110 middle">Back</b>
												</a>
											</div>

											<div class="messagebar-item-right">
												<i class="ace-icon fa fa-clock-o bigger-110 orange"></i>
												<span id="mangerTime" class="grey">Today, 7:15 pm</span>
											</div>
										</div>
									</div>

									<div id="id-ot-item-navbar" class="hide message-navbar clearfix">
										<div class="message-bar">
											<div class="message-toolbar">
												<button type="button" class="btn btn-xs btn-primary btn-primary" id="aproveOvertime">
													<i class="ace-icon fa fa-check bigger-110"></i>
													<span class="bigger-110">Aprove</span>
												</button>

												<button type="button" class="btn btn-xs btn-danger btn-primary" id="rejectOvertime">
													<i class="ace-icon fa fa-times bigger-110"></i>
													<span class="bigger-110">Reject</span>
												</button>
											</div>
										</div>

										<div>
											<div class="messagebar-item-left">
												<a  class="btn-back-message-list">
													<i class="ace-icon fa fa-arrow-left blue bigger-110 middle"></i>
													<b class="bigger-110 middle">Back</b>
												</a>
											</div>

											<div class="messagebar-item-right">
												<i class="ace-icon fa fa-clock-o bigger-110 orange"></i>
												<span id="otTime" class="grey">Today, 7:15 pm</span>
											</div>
										</div>
									</div>

									<div id="id-message-new-navbar" class="hide message-navbar clearfix">
										<div class="message-bar">
										</div>

										<div>
											<div class="messagebar-item-left">
												<a  class="btn-back-message-list">
													<i class="ace-icon fa fa-arrow-left bigger-110 middle blue"></i>
													<b class="middle bigger-110">Back</b>
												</a>
											</div>

											<div class="messagebar-item-right">
												<span class="inline btn-send-message">
													<button type="button" onclick="saveSickness()" class="btn btn-sm btn-primary no-border btn-white btn-round">
														<span class="bigger-110">Submit</span>

														<i class="ace-icon fa fa-arrow-right icon-on-right"></i>
													</button>
												</span>
											</div>
										</div>
									</div>

									<div id="id-employer-new-navbar" class="hide message-navbar clearfix">
										<div class="message-bar">
										</div>

										<div>
											<div class="messagebar-item-left">
												<a  class="btn-back-message-list">
													<i class="ace-icon fa fa-arrow-left bigger-110 middle blue"></i>
													<b class="middle bigger-110">Back</b>
												</a>
											</div>

											<div class="messagebar-item-right">
												<span class="inline btn-send-message">
													<button type="button" onclick="newEmoloyer()" class="btn btn-sm btn-primary no-border btn-white btn-round">
														<span class="bigger-110">Save</span>
														<i class="ace-icon fa fa-arrow-right icon-on-right"></i>
													</button>
												</span>
											</div>
										</div>
									</div>

									<!-- /section:pages/inbox.navbar -->
									<div class="message-list-container">
										<!-- ##section:pages/inbox.message-list -->
										<div class="message-list" id="message-list">

											<cfloop array="#rc.managertime#" index="action">
												<cfset unread = "">
												<cfset user = entityLoadbyPK('users',action.userId)>
												<cfset typeoff = entityLoadbyPK('dayofftype',action.typeId)>
												<cfif action.action == "">
													<cfset unread = "message-unread">
												</cfif>
												<div class="message-item #unread#">
													<span class="hide" id="imangerAvar-#action.Id#">
														<cfif user.avatar EQ "">
															/fileupload/avatars/default.jpg
														<cfelse>
															<cfif FileExists("/fileupload/avatars/#user.avatar#")>
																/fileupload/avatars/#user.avatar#
															<cfelse>
																/fileupload/avatars/default.jpg
															</cfif>
															
														</cfif>
													</span>
													<span class="hide" id="imangerRs-#action.Id#">#action.reason#</span>
													<label class="inline">
														<input type="checkbox" class="ace" />
														<span class="lbl"></span>
													</label>

													<i class="message-star ace-icon fa fa-star orange2"></i>
													<span class="sender" id="mangerName-#action.Id#" title="#user.getFirstname() & user.getLastname()#">#user.getFirstname() & user.getLastname()# </span>
													<span class="time" style="min-width: 70px" id="mangerTime-#action.Id#">#DateFormat(action.createTime)#</span>

													<span class="summary">
														<span class="text" id="mangerdateTime-#action.Id#">
															(#typeoff.statusName#) #dateFormat(action.startTime,'yyyy-mm-dd')# - #dateFormat(action.endTime,'yyyy-mm-dd')#
														</span>
													</span>
												</div>
											</cfloop>

											<!-- /section:pages/inbox.message-list.item -->
										</div>

										<div class="hide ot-list" id="ot-list">

											<cfloop array="#rc.overTime#" index="action">
												<cfset unread = "">
												<cfset user = entityLoadbyPK('users',action.userId)>
												<cfset projectName = entityLoadbyPK('projects',action.projectId)>
												<cfif action.action == "">
													<cfset unread = "message-unread">
												</cfif>
												<div class="message-item ot-item #unread#">
													<span class="hide" id="otAvar-#action.id#">
														<cfif user.avatar EQ "">
															/fileupload/avatars/default.jpg
														<cfelse>
															<cfif FileExists("/fileupload/avatars/#user.avatar#")>
																/fileupload/avatars/#user.avatar#
															<cfelse>
																/fileupload/avatars/default.jpg
															</cfif>
															
														</cfif>
													</span>
													<span class="hide" id="otCm-#action.Id#">#action.comment#</span>
													<label class="inline">
														<input type="checkbox" class="ace" />
														<span class="lbl"></span>
													</label>

													<i class="message-star ace-icon fa fa-star orange2"></i>
													<span class="sender" id="otName-#action.id#" title="#user.getFirstname() & user.getLastname()#">#user.getFirstname() & user.getLastname()# </span>
													<span class="time" style="min-width:135px" id="otTime-#action.id#">#DateTimeFormat(action.createTime)#</span>

													<span class="summary">
														<span class="text" id="otdateTime-#action.id#">
															(#action.hours# hours - #projectName.projectName#) #DateFormat(action.requestTime)#
														</span>
													</span>
												</div>
											</cfloop>

											<!-- /section:pages/inbox.message-list.item -->
										</div>

										<!-- /section:pages/inbox.message-list -->
									</div>

									<!-- ##section:pages/inbox.message-footer -->
									<div class="message-footer clearfix">
										<div class="pull-left"> #arraylen(rc.managertime)# messages total </div>

										<div class="pull-right">
											<div class="inline middle"> page 1 of 16 </div>

											&nbsp; &nbsp;
											<ul class="pagination middle">
												<li class="disabled">
													<span>
														<i class="ace-icon fa fa-step-backward middle"></i>
													</span>
												</li>

												<li class="disabled">
													<span>
														<i class="ace-icon fa fa-caret-left bigger-140 middle"></i>
													</span>
												</li>

												<li>
													<span>
														<input value="1" maxlength="3" type="text" />
													</span>
												</li>

												<li>
													<a >
														<i class="ace-icon fa fa-caret-right bigger-140 middle"></i>
													</a>
												</li>

												<li>
													<a >
														<i class="ace-icon fa fa-step-forward middle"></i>
													</a>
												</li>
											</ul>
										</div>
									</div>

									<!-- /section:pages/inbox.message-footer -->
								</div>
							</div>

						</div><!-- /.tab-content -->
					</div><!-- /.tabbable -->

					<!-- /section:pages/inbox -->
				</div><!-- /.col -->
			</div><!-- /.row -->

			<form id="id-message-form" class="hide form-horizontal message-form col-xs-12">
				<!-- ##section:pages/inbox.compose -->
					<div>
						<div class="form-group">
							<div class="alert alert-danger col-sm-5 col-sm-offset-2 hide" id="noticeAddSickneesDanger">
								<button type="button" class="close">
									<i class="ace-icon fa fa-times"></i>
								</button>

								<strong>
									<i class="ace-icon fa fa-times"></i>
									Oh snap!
								</strong>

								Change a few things up and try submitting again.
								<br>
							</div>

							<div class="alert alert-success col-sm-5 col-sm-offset-2 hide" id="noticeAddSickneesSuccess">
								<button type="button" class="close">
									<i class="ace-icon fa fa-check"></i>
								</button>

								<strong>
									<i class="ace-icon fa fa-times"></i>
									Ok!
								</strong>

								Your change have success.
								<br>
							</div>
						</div>
					<input type="hidden" id="userId">
					<div class="form-group">
						<label class="col-sm-3 control-label no-padding-right" for="form-field-recipient">Name:</label>

						<div class="col-sm-3">
							<span class="input-icon">
								<input id="nameUser" type="email" name="nameUser" id="form-field-recipient" placeholder="Name" />
								<i class="ace-icon fa fa-user"></i>
							</span>
						</div>
						<label class="col-sm-2 no-padding-left" for="form-field-recipient"><strong>Annual leave exist:</strong> <span id="avaiAnnual">0<span></label>
						<label class="col-sm-2 no-padding-left" for="form-field-recipient"><strong>Sickness exist:</strong> <span id="avaiSick">0</span></label>
					</div>

					<div class="hr hr-18 dotted"></div>

					<div class="form-group">
						<label class="col-sm-3 control-label no-padding-right" for="form-field-subject">Choose day/number day:</label>
						<div class="col-sm-5 col-xs-10">
							<div class="input-group">
								<span class="input-group-addon">
									<i class="fa fa-calendar bigger-110"></i>
								</span>

								<input class="form-control" type="text" name="daterangepicker" id="id-date-range-picker-1" />
							</div>
						</div>
					</div>

					<div class="hr hr-18 dotted"></div>

					<div class="form-group">
						<label class="col-sm-3 control-label no-padding-right" for="form-field-subject">Sickness</label>
						<div class="col-sm-1 col-xs-1">
							<input class="form-control" type="text" name="sicknessDay"  value="0" > 
						</div>
						<label class="col-sm-1 control-label no-padding-right" for="form-field-subject">Annual leave</label>
						<div class="col-sm-1 col-xs-1">
							<input class="form-control" type="text" name="annualDay" value="0" > 
						</div>
					</div>

					<div class="hr hr-18 dotted"></div>

					<div class="form-group">
						<label class="col-sm-3 control-label no-padding-right">
							<span class="inline space-24 hidden-480"></span>
							Due to:
						</label>

						<!-- ##section:plugins/editor.wysiwyg -->
						<div class="col-sm-9">
							<textarea id="dueToSickness" style="min-height:100px;min-width:600px"></textarea>
						</div>

						<!-- /section:plugins/editor.wysiwyg -->
					</div>

					<div class="space"></div>
				</div>

				<!-- /section:pages/inbox.compose -->
			</form>

			<form id="id-employer-form" class="hide form-horizontal employer-form col-xs-12">
				<!-- ##section:pages/inbox.compose -->
				<div>
					<div class="form-group">
						<div class="alert alert-danger col-sm-5 col-sm-offset-2 hide" id="noticeAddemployerDanger">
							<button type="button" class="close">
								<i class="ace-icon fa fa-times"></i>
							</button>

							<strong>
								<i class="ace-icon fa fa-times"></i>
								Oh snap!
							</strong>

							Change a few things up and try submitting again.
							<br>
						</div>

						<div class="alert alert-success col-sm-5 col-sm-offset-2 hide" id="noticeAddemployerSuccess">
							<button type="button" class="close">
								<i class="ace-icon fa fa-check"></i>
							</button>

							<strong>
								<i class="ace-icon fa fa-times"></i>
								Ok!
							</strong>

							Your change have success.
							<br>
						</div>
					</div>
					<input type="hidden" id="newUserId">
					<div class="form-group">
						<label class="col-sm-3 control-label no-padding-right" for="form-field-recipient">Choose User:</label>

						<div class="col-sm-7">
							<span class="input-icon">
								<input id="newUser" type="email" name="newUser" id="form-field-recipient" placeholder="Name" style="min-width:300px" />
								<i class="ace-icon fa fa-user"></i>
							</span>
						</div>
					</div>

					<div class="hr hr-18 dotted"></div>

					<div class="form-group">
						<label class="col-sm-3 control-label no-padding-right" for="form-field-subject">Start Time</label>
						<div class="col-sm-2 col-xs-2">
							<div class="input-group">
								<span class="input-group-addon">
									<i class="fa fa-calendar bigger-110"></i>
								</span>
								<input class="form-control date-picker" id="startTime" type="text" data-date-format="dd-mm-yyyy" />
							</div>
						</div>
					</div>

					<div class="hr hr-18 dotted"></div>

					<div class="form-group">
						<label class="col-sm-3 control-label no-padding-right" for="form-field-subject">Annual leave</label>
						<div class="col-sm-1 col-xs-1">
							<input class="form-control" type="text" name="annualDayAdd" value="0" > 
						</div>
						<label class="col-sm-1 control-label no-padding-right" for="form-field-subject">Sickness</label>
						<div class="col-sm-1 col-xs-1">
							<input class="form-control" type="text" name="sicknessDayAdd"  value="0" > 
						</div>
					</div>

					<div class="space"></div>
				</div>

				<!-- /section:pages/inbox.compose -->
			</form>

			<div class="hide message-content" id="id-message-content">
				<!-- ##section:pages/inbox.message-header -->
				<div class="message-header clearfix">
					<div class="pull-left">
						<span id="mangerdateTime" class="blue bigger-125"></span>

						<div class="space-4"></div>

						<i class="ace-icon fa fa-star orange2"></i>

						&nbsp;
						<img class="middle" id="imangerAvar" alt="John's Avatar" src="" width="32" />
						&nbsp;
						<a  id="mangerName" class="sender"></a>

					</div>
				</div>

				<!-- /section:pages/inbox.message-header -->
				<div class="hr hr-double"></div>

				<!-- ##section:pages/inbox.message-body -->
				<div class="message-body" id="imangerRs" style="min-height:150px">
					
				</div>
				<div class="hr"></div>
				<div class="message-attachment clearfix">
					<div id="listAction">
						<label id="rApprove" class="success"></label>
						<div>
							<label id="rReject" class="danger"></label>
						</div>
					</div>
				</div>
			</div><!-- /.message-content -->

			<!-- Over time content -->
			<div class="hide ot-content" id="id-ot-content">
				<!-- ##section:pages/inbox.message-header -->
				<div class="message-header clearfix">
					<div class="pull-left">
						<span id="otdateTime" class="blue bigger-125"></span>

						<div class="space-4"></div>

						<i class="ace-icon fa fa-star orange2"></i>

						&nbsp;
						<img class="middle" id="otAvar" alt="John's Avatar" src="" width="32" />
						&nbsp;
						<a  id="otName" class="sender"></a>

					</div>
				</div>

				<!-- /section:pages/inbox.message-header -->
				<div class="hr hr-double"></div>

				<!-- ##section:pages/inbox.message-body -->
				<div class="ot-body" id="otCm" style="min-height:150px">
					
				</div>
				<div class="hr"></div>
				<div class="message-attachment clearfix">
					<div id="listOtAction">
						<label class="success"></label>
						<label class="danger"></label>
					</div>
				</div>
			</div><!-- /.overTime-content -->



			<!-- PAGE CONTENT ENDS -->
		</div><!-- /.col -->
	</div><!-- /.row -->

<script type="text/javascript">
var currentMessageId = 0 ;
var arrayNameCustomer =  #rc.arrayNameCustomer#
var arrayNewCustomer = #rc.arrayNewCustomer#
	$(document).ready(function(){
		$("##searchName").autocomplete({
				source:arrayNameCustomer,
				selectFirst: true,
				autoFocus: true,
				minLength : 0,
				select:function(event,ui){
					// $.ajax({
			  //           type: "POST",
			  //           url: "/index.cfm/annual_leave/getAvaiOff",
			  //           data: {
			  //           	id:ui.item.id        	
			  //           },
			  //           success: function( data ) {	
			  //           	$('##avaiAnnual').html(data.avaiAnnual);
			  //           	$('##avaiSick').html(data.avaiSick);
			  //           }
			  //    	});
			  //    	$('##userId').val(ui.item.id );
				}
		});
		$("##newUser").autocomplete({
				source:arrayNewCustomer,
				selectFirst: true,
				autoFocus: true,
				minLength : 0,
				select:function(event,ui){
			     	$('##newUserId').val(ui.item.id );
				}
		});
		$("##nameUser").autocomplete({
				source:arrayNameCustomer,
				selectFirst: true,
				autoFocus: true,
				minLength : 0,
				select:function(event,ui){
					$.ajax({
			            type: "POST",
			            url: "/index.cfm/annual_leave/getAvaiOff",
			            data: {
			            	id:ui.item.id        	
			            },
			            success: function( data ) {	
			            	$('##avaiAnnual').html(data.avaiAnnual);
			            	$('##avaiSick').html(data.avaiSick);
			            }
			     	});
			     	$('##userId').val(ui.item.id );
				}
		});

        $('input[name=daterangepicker]').daterangepicker({
			'applyClass' : 'btn-sm btn-success',
			'cancelClass' : 'btn-sm btn-default',
			locale: {
				applyLabel: 'Apply',
				cancelLabel: 'Cancel',
			}
		})

		$('##startTime').datepicker({
			autoclose: true,
			todayHighlight: true,
			format: "M-yyyy",
		    startView: "months", 
		    minViewMode: "months"
		})


		.prev().on(ace.click_event, function(){
			$(this).next().focus();
		});

		<cfif structKeyExists(URL, 'slug')>
			currentMessageId = #URL.slug# ;
			viewRequired("#URL.slug#");
		</cfif>

		$('.close').click(function(event) {
			$(this).parent().addClass('hide');
		});
		$('##inbox-tabs a[data-toggle="tab"]').on('show.bs.tab', function (e) {
			var currentTab = $(e.target).data('target');
			if(currentTab == 'write') {
				Inbox.show_form();
			}
			else if(currentTab == 'inbox') {
				Inbox.show_list();
			}
			else if(currentTab=='newEmployer')
			{
				Inbox.show_form_employer();
			}
			else if(currentTab == 'ot')
			{
				Inbox.show_ot();
			}
		})

		//display first message in a new area
			$('.message-list .message-item .text').on('click', function() {
				//show the loading icon
				currentMessageId = $(this).attr('id').split("-")[1];
				viewRequired(currentMessageId);
				$('##imangerRs').html($('##imangerRs-'+currentMessageId).html());
				$('##mangerName').html($('##mangerName-'+currentMessageId).html());
				$('##imangerAvar').attr('src',$('##imangerAvar-'+currentMessageId).html());
				$('##mangerdateTime').html($('##mangerdateTime-'+currentMessageId).html());
				$('##mangerTime').html($('##mangerTime-'+currentMessageId).html());
				
				$('.message-container').append('<div class="message-loading-overlay"><i class="fa-spin ace-icon fa fa-spinner orange2 bigger-160"></i></div>');
				
				$('.message-inline-open').removeClass('message-inline-open').find('.message-content').remove();
		
				var message_list = $(this).closest('.message-list');
		
				$('##inbox-tabs a[href="##inbox"]').parent().removeClass('active');
				//some waiting
				setTimeout(function() {
		
					//hide everything that is after .message-list (which is either .message-content or .message-form)
					message_list.next().addClass('hide');
					$('.message-container').find('.message-loading-overlay').remove();
		
					//close and remove the inline opened message if any!
		
					//hide all navbars
					$('.message-navbar').addClass('hide');
					//now show the navbar for single message item
					$('##id-message-item-navbar').removeClass('hide');
		
					//hide all footers
					$('.message-footer').addClass('hide');
					//now show the alternative footer
					$('.message-footer-style2').removeClass('hide');
					
					
					//move .message-content next to .message-list and hide .message-list
					$('.message-content').removeClass('hide').insertAfter(message_list.addClass('hide'));
		
					//add scrollbars to .message-body
					$('.message-content .message-body').ace_scroll({
						size: 150,
						mouseWheelLock: true,
						styleClass: 'scroll-visible'
					});
		
				}, 500 + parseInt(Math.random() * 500));
			});
			// display first ot in a new area
			$('.ot-list .ot-item .text').on('click', function() {
				//show the loading icon
				currentMessageId = $(this).attr('id').split("-")[1];
				$('##otCm').html($('##otCm-'+currentMessageId).html());
				$('##otName').html($('##otName-'+currentMessageId).html());
				$('##otAvar').attr('src',$('##otAvar-'+currentMessageId).html());
				$('##otdateTime').html($('##otdateTime-'+currentMessageId).html());
				$('##otTime').html($('##otTime-'+currentMessageId).html());
				viewRequiredOt(currentMessageId);
				$('.message-container').append('<div class="message-loading-overlay"><i class="fa-spin ace-icon fa fa-spinner orange2 bigger-160"></i></div>');
				
				$('.message-inline-open').removeClass('message-inline-open').find('.message-content').remove();
		
				var message_list = $(this).closest('.message-list');
		
				$('##inbox-tabs a[href="##inbox"]').parent().removeClass('active');
				//some waiting
				setTimeout(function() {
		
					//hide everything that is after .message-list (which is either .message-content or .message-form)
					message_list.next().addClass('hide');
					$('.message-container').find('.message-loading-overlay').remove();
		
					//close and remove the inline opened message if any!
		
					//hide all navbars
					$('.message-navbar').addClass('hide');
					//now show the navbar for single message item
					$('##id-message-item-navbar').addClass('hide');
					$('##id-ot-item-navbar').removeClass('hide');
		
					//hide all footers
					//now show the alternative footer
					$('.message-footer').addClass('hide');
					$('.message-footer-style2').removeClass('hide').insertAfter(message_list.addClass('hide'));
					
					
					//move .message-content next to .message-list and hide .message-list
					$('##ot-list').addClass('hide');
					$('.ot-content').removeClass('hide');
		
					//add scrollbars to .message-body
					$('.ot-content .ot-body').ace_scroll({
						size: 150,
						mouseWheelLock: true,
						styleClass: 'scroll-visible'
					});
		
				}, 500 + parseInt(Math.random() * 500));
			});

		//back to message list
		$('.btn-back-message-list').on('click', function(e) {
			
			e.preventDefault();
			$('##inbox-tabs a[href="##inbox"]').tab('show');
		});

		var Inbox = {
			//displays a toolbar according to the number of selected messages
			display_bar : function (count) {
				if(count == 0) {
					$('##d-toggle-all').removeAttr('checked');
					$('##d-message-list-navbar .message-toolbar').addClass('hide');
					$('##d-message-list-navbar .message-infobar').removeClass('hide');
				}
				else {
					$('##d-message-list-navbar .message-infobar').addClass('hide');
					$('##d-message-list-navbar .message-toolbar').removeClass('hide');
				}
			}
			,
			select_all : function() {
				var count = 0;
				$('.message-item input[type=checkbox]').each(function(){
					this.checked = true;
					$(this).closest('.message-item').addClass('selected');
					count++;
				});
				
				$('##d-toggle-all').get(0).checked = true;
				
				Inbox.display_bar(count);
			}
			,
			select_none : function() {
				$('.message-item input[type=checkbox]').removeAttr('checked').closest('.message-item').removeClass('selected');
				$('##d-toggle-all').get(0).checked = false;
				
				Inbox.display_bar(0);
			}
			,
			select_read : function() {
				$('.message-unread input[type=checkbox]').removeAttr('checked').closest('.message-item').removeClass('selected');
				
				var count = 0;
				$('.message-item:not(.message-unread) input[type=checkbox]').each(function(){
					this.checked = true;
					$(this).closest('.message-item').addClass('selected');
					count++;
				});
				Inbox.display_bar(count);
			}
			,
			select_unread : function() {
				$('.message-item:not(.message-unread) input[type=checkbox]').removeAttr('checked').closest('.message-item').removeClass('selected');
				
				var count = 0;
				$('.message-unread input[type=checkbox]').each(function(){
					this.checked = true;
					$(this).closest('.message-item').addClass('selected');
					count++;
				});
				
				Inbox.display_bar(count);
			}
		}

		Inbox.show_list = function() {
			$('.message-navbar').addClass('hide');
			$('##id-message-list-navbar').removeClass('hide');
			$('.message-footer:not(.message-footer-style2)').removeClass('hide');
			$('.ot-list').addClass('hide');
			$('.ot-content').addClass('hide');
			$('.message-list').removeClass('hide').next().addClass('hide');
			//hide the message item / new message window and go back to list
		}

		Inbox.show_ot = function(){
			$('.message-navbar').addClass('hide');
			$('##id-message-list-navbar').addClass('hide');
			$('##id-ot-list-navbar').removeClass('hide');
			$('.message-footer:not(.message-footer-style2)').removeClass('hide');
			$('.message-list').addClass('hide').next().addClass('hide');
			$('.ot-list').removeClass('hide');
		}

		//show write mail form
			Inbox.show_form = function() {
				if($('.message-form').is(':visible')) return;
				if(!form_initialized) {
					initialize_form();
				}
				
				
				var message = $('.message-list');
				$('.message-container').append('<div class="message-loading-overlay"><i class="fa-spin ace-icon fa fa-spinner orange2 bigger-160"></i></div>');
				
				setTimeout(function() {
					message.next().addClass('hide');
					
					$('.message-container').find('.message-loading-overlay').remove();
					
					$('.message-list').addClass('hide');
					$('.ot-content').addClass('hide');
					$('.ot-list').addClass('hide');
					$('##noticeAddSickneesDanger').addClass('hide');
            		$('##noticeAddSickneesSuccess').addClass('hide');
					$('.employer-form').addClass('hide');
					$('.message-footer').addClass('hide');
					$('.message-form').removeClass('hide').insertAfter('.message-list');
					
					$('.message-navbar').addClass('hide');
					$('##id-employer-new-navbar').addClass('hide');
					$('##id-message-new-navbar').removeClass('hide');
					
					
					//reset form??
					
					$('.message-form').get(0).reset();
					
				}, 300 + parseInt(Math.random() * 300));
			}

			Inbox.show_form_employer = function() {
				if($('.employer-form').is(':visible')) return;
				
				var message = $('.message-list');
				$('.message-container').append('<div class="message-loading-overlay"><i class="fa-spin ace-icon fa fa-spinner orange2 bigger-160"></i></div>');
				
				setTimeout(function() {
					message.next().addClass('hide');
					
					$('.message-container').find('.message-loading-overlay').remove();
					
					$('.message-list').addClass('hide');
					$('.ot-content').addClass('hide');
					$('.ot-list').addClass('hide');
					$('##noticeAddemployerDanger').addClass('hide');
            		$('##noticeAddemployerSuccess').addClass('hide');
					$('.message-form').addClass('hide');
					$('.message-footer').addClass('hide');
					$('.employer-form').removeClass('hide').insertAfter('.message-list');
					
					$('.message-navbar').addClass('hide');
					$('##id-message-new-navbar').addClass('hide');
					$('##id-employer-new-navbar').removeClass('hide');					
					
					//reset form??
					
					$('.employer-form').get(0).reset();
					
				}, 300 + parseInt(Math.random() * 300));
			}
			

    });
    $('##rejectRequired').on('click',function() {
    	 $('##typeSubmit').val(-1);
    	 $('##approveForm').submit();
    });

    $('##approveRequired').on('click',function() {
    	 $('##typeSubmit').val(1);
    	 $('##approveForm').submit();
    });

    function viewRequired(id)
    {
    	$.ajax({
	            type: "POST",
	            url: "/index.cfm/annual_leave/getInformation",
	            data: {
	            	id:id		            	
	            },
	            success: function( data ) {	
	            	if(data.sApprove == "" && data.sReject == "")
	            		$('##listAction').html("<p style='text-align:center;font-weight:bold'>(No action)</p>");
	            	else{
	            		// $('##rApprove').html(data.sApprove);
	            		// $('##rReject').html(data.sReject);
		            	$('##listAction').html('<label id="rApprove" class="success">'+data.sApprove+'</label><br>'+
												'<label id="rReject" class="danger">'+data.sReject+'</label>');
	            	}
	            }
	     });
    }
    function viewRequiredOt(id)
    {
    	$.ajax({
	            type: "POST",
	            url: "/index.cfm/annual_leave/getInformationOt",
	            data: {
	            	id:id		            	
	            },
	            success: function( data ) {	
	            	if(data.sApprove == "" && data.sReject == "")
	            		$('##listOtAction').html("<p style='text-align:center;font-weight:bold'>(No action)</p>");
	            	else{
	            		// $('##rApprove').html(data.sApprove);
	            		// $('##rReject').html(data.sReject);
		            	$('##listOtAction').html('<label id="rApprove" class="success">'+data.sApprove+'</label><br>'+
												'<label id="rReject" class="danger">'+data.sReject+'</label>');
	            	}
	            }
	     });
    }

    function saveSickness()
    {

    	$.ajax({
            type: "POST",
            url: "/index.cfm/annual_leave/submitSickness",
            data: {
            	id: $('##userId').val(),
            	dateTime: $('input[name="daterangepicker"]').val(),
            	sicknessDay:$('input[name="sicknessDay"]').val(),
            	annualDay:$('input[name="annualDay"]').val(),
            	dueToSickness:$('##dueToSickness').val()
            },
            success: function( data ) {	
            	if(data.stt==true)
            	{
            		$('##id-message-form').get(0).reset();
            		$('##noticeAddSickneesSuccess').removeClass('hide');
            		$('##noticeAddSickneesDanger').addClass('hide');
            	}else{
            		$('##noticeAddSickneesDanger').removeClass('hide');
            		$('##noticeAddSickneesSuccess').addClass('hide');
            	}
            }
     	});

    }

    function newEmoloyer()
    {
    	$.ajax({
            type: "POST",
            url: "/index.cfm/annual_leave/newEmoloyer",
            data: {
            	id: $('##newUserId').val(),
            	startTime: $('##startTime').val(),
            	sicknessDay:$('input[name="sicknessDayAdd"]').val(),
            	annualDay:$('input[name="annualDayAdd"]').val()            	
            },
            success: function( data ) {	
            	if(data.stt==true)
            	{
            		$('##noticeAddemployerSuccess').removeClass('hide');
            		$('##noticeAddemployerDanger').addClass('hide');
            		var nUser = {id:$('##newUserId').val(),value:$('##newUser').val()};
	            	arrayNameCustomer.push(nUser);
	            	$( "##nameUser" ).autocomplete('option', 'source', arrayNameCustomer);
	            	$( "##searchName" ).autocomplete('option', 'source', arrayNameCustomer);
	            	arrayNewCustomer = jQuery.grep(arrayNewCustomer, function(value) {
								        return value.id != nUser.id;
								      });
	            	$( "##newUser" ).autocomplete('option', 'source', arrayNewCustomer);
	            	$('.employer-form').get(0).reset();

            	}else{
            		$('##noticeAddemployerDanger').removeClass('hide');
            		$('##noticeAddemployerSuccess').addClass('hide');
            	}
            }
     	});
    }


    var form_initialized = false;
	function initialize_form() {
		if(form_initialized) return;
		form_initialized = true;
		
		//intialize wysiwyg editor
		$('.message-form .wysiwyg-editor').ace_wysiwyg({
			toolbar:
			[
				'bold',
				'italic',
				'strikethrough',
				'underline',
				null,
				'justifyleft',
				'justifycenter',
				'justifyright',
				null,
				'createLink',
				'unlink',
				null,
				'undo',
				'redo'
			]
		}).prev().addClass('wysiwyg-style1');
	}//initialize_form
	// aprove message
	$("##aproveMessage").on("click", function (){
		aproveMessage( 1 , 1);
	});
	$("##rejectMessage").on("click", function(){
		aproveMessage( -1 , 1);
	});
	// aprove overtime
	$("##aproveOvertime").on("click", function (){
		aproveMessage( 1 , 2);
	});
	$("##rejectOvertime").on("click", function(){
		aproveMessage( -1 , 2);
	});
	function aproveMessage( isaprove , rtype){
    	$.ajax({
            type: "POST",
            url: "/index.cfm/annual_leave/aproveRequest",
            data: {
            	id: currentMessageId,
            	isaprove: isaprove,
            	rtype : 1
            },
            success: function( data ) {	
            	if( rtype == 1){
            		$("##imangerAvar-"+currentMessageId).parent().removeClass('message-unread');
					viewRequired(currentMessageId);
            	}else{
					viewRequiredOt(currentMessageId);
            		$("##otAvar-"+currentMessageId).parent().removeClass('message-unread');
            	}
				$('.message-container').append('<div class="message-loading-overlay"><i class="fa-spin ace-icon fa fa-spinner orange2 bigger-160"></i></div>');
				setTimeout(function() {
					countUnreadMessage();
					$('.message-container').find('.message-loading-overlay').remove();
				}, 1000 );
				
            },
            error: function(){
            	location.reload();
            }
     	});

	}
	
	// checking read or unread
	countUnreadMessage();
	function countUnreadMessage(){
		var unread1 = $("##message-list .message-unread").length ;
		if( unread1 > 0 ){
			$('a[data-target="inbox"] .badge').text(unread1).show();
			$('##id-message-infobar').html('<span class="blue bigger-150">Inbox</span><span class="grey bigger-110">('+unread1+' unread messages)</span>');
		}else{
			$('##id-message-infobar').html('<span class="blue bigger-150">Inbox</span>');
			$('a[data-target="inbox"] .badge').hide();
		}
		var unread2 = $("##ot-list .message-unread").length ;
		if( unread2 > 0 ){
			$('a[data-target="ot"] .badge').text(unread2).show();
			$('##id-ot-infobar').html('<span class="blue bigger-150">Overtime</span><span class="grey bigger-110">('+unread2+' unread messages)</span>');
		}else{
			$('##id-ot-infobar').html('<span class="blue bigger-150">Overtime</span>');
			$('a[data-target="ot"] .badge').hide();
		}
	}
</script>
</cfoutput>