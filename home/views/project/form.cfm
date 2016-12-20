<cfoutput>
<div class="row clearfix">
	<div class="col-md-12" style="border-bottom:2px ##428bca solid;">
		<h1 class="blue">#getLabel("Project", #SESSION.languageId#)#:<small><cfif structKeyExists(URL,"code")>
			#getLabel("edit", #SESSION.languageId#)#
		<cfelse>
			#getLabel("create", #SESSION.languageId#)#
		</cfif></small></h1>
	</div>
</div>
<div class="row clearfix" style="margin-top:20px;">
	<div class="col-md-12">
<cfif rc.checkStatus>
	<div class="alert alert-info">
		<button type="button" class="close" data-dismiss="alert">
			<i class="ace-icon fa fa-times"></i>
		</button>
		<strong>#getLabel("Heads up!", #SESSION.languageId#)#</strong>
		<cfif structKeyExists(URL,"pId")>
			#getLabel("Project is Edit success!", #SESSION.languageId#)#
		<cfelse>
			#getLabel("Project is added success!", #SESSION.languageId#)#
		</cfif>
		<br>
	</div>
	<cfset rc.checkStatus=false>
</cfif>
<cfif structKeyExists(rc,"message")>
	<div class="alert alert-warning">
		#rc.message#
	</div>
</cfif>
		<form class="form-horizontal" role="form" method="post" enctype="multipart/form-data"  id="myform">
			<div class="form-group">
                <label class="col-xs-1 control-label no-padding-right" >Color</label>
                <div class="col-xs-12 col-md-8 inline">
                    <label class=" btn btn-danger">
                        <input name="projectColor" id="danger" value="danger" type="radio" class="ace ">
                        <span class="lbl"></span>
                    </label>
                    <label class=" btn btn-pink">
                        <input name="projectColor" id="pink" value="pink" type="radio" class="ace ">
                        <span class="lbl"></span>
                    </label>
                    <label class=" btn btn-yellow">
                        <input name="projectColor" id="yellow" value="yellow" type="radio" class="ace ">
                        <span class="lbl"></span>
                    </label>
                    <label class=" btn btn-warning">
                        <input name="projectColor" id="warning" value="warning" type="radio" class="ace ">
                        <span class="lbl"></span>
                    </label>
                    <label class=" btn btn-success">
                        <input name="projectColor" id="success" value="success" type="radio" class="ace " checked>
                        <span class="lbl"></span>
                    </label>
                    <label class=" btn btn-info">
                        <input name="projectColor" id="info" value="info" type="radio" class="ace ">
                        <span class="lbl"></span>
                    </label>
                    <label class=" btn btn-primary">
                        <input name="projectColor" id="primary" value="primary" type="radio" class="ace ">
                        <span class="lbl"></span>
                    </label>
                    <label class=" btn btn-purple">
                        <input name="projectColor" id="purple" value="purple" type="radio" class="ace ">
                        <span class="lbl"></span>
                    </label>
                    <label class=" btn btn-grey">
                        <input name="projectColor" id="grey" value="grey" type="radio" class="ace ">
                        <span class="lbl"></span>
                    </label>
                </div>
            </div>

			<div class="row">
				<div class="col-xs-12">
					<!-- PAGE CONTENT BEGINS -->
					<div class="space-6"></div>

					<div class="row">
						<div class="col-xs-12">
							<!-- ##section:pages/invoice -->
							<div class="widget-box transparent">
								<div class="widget-body">
									<div class="widget-main padding-24">
										<div class="row">
											<div class="col-xs-12 col-md-6">
												<div class="form-group">
													<div class="row">
														<div class="col-xs-11 label label-lg label-info arrowed-in arrowed-right">
															<b>Project Info</b>
														</div>
													</div>

													<div class="row">
														<div class="col-xs-12">
															<ul class="list-unstyled spaced">
																<li class="row form-group">
																	<label class="control-label col-xs-4 col-md-2"> #getLabel("Name", #SESSION.languageId#)#</label>
																	<div class="col-xs-8 col-md-8">
																		<input class="col-xs-12" type="text" id="projectName" name="projectName"placeholder="Project Name"/>
																	</div>
																</li>

																<div class="space"></div>

																<li class="row form-group">
																	<label class="control-label col-xs-4 col-md-2"> #getLabel("Short Name", #SESSION.languageId#)#</label>
																	<div class="col-xs-8 col-md-8">
																		<input class="col-xs-12" type="text" id="projectShortName" name="projectShortName" placeholder="Short Name"/>
																	</div>
																</li>

																<div class="space"></div>

																<li class="row form-group">
																	<label class="control-label col-xs-4 col-md-2">#getLabel("Project Type", #SESSION.languageId#)#</label>
																	<div class="col-xs-8 col-md-8">
																		<select class="col-xs-12" id="projectType" name="projectType" data-placeholder="Choose project type">
																			<cfloop query=#rc.prjType# >
																			<option value="#rc.prjType.projectTypeID#" id='type#rc.prjType.projectTypeID#'>#rc.prjType.typeName#</option>
																			</cfloop>
																		</select>
																	</div>
																</li>

																<div class="space"></div>

																<li class="row form-group">
																	<label class="control-label col-xs-4 col-md-2">#getLabel("Project Status", #SESSION.languageId#)#</label>
																	<div class="col-xs-8 col-md-8">
																		<select class=" col-xs-12" id="projectStatus" name="projectStatus" data-placeholder="Choose project status">
																			<cfloop query=#rc.prjStatus# >
																			<option value="#rc.prjStatus.projectStatusID#" id='status#rc.prjStatus.projectStatusID#'>#rc.prjStatus.statusName#</option>
																			</cfloop>
																		</select>
																	</div>
																</li>

																<div class="space"></div>

																<li class="row form-group">
																	<label class="control-label col-xs-4 col-md-2">#getLabel("URL", #SESSION.languageId#)#</label>
																	<div class="col-xs-8 col-md-8">
																		<input type="text" id="projectUrl" name="projectUrl"placeholder="Project Url" class="col-xs-12" />
																	</div>
																</li>

																<div class="space"></div>

																<li class="row form-group">
																	<label class="control-label col-xs-4 col-md-2">#getLabel("Due Date", #SESSION.languageId#)#</label>
																	<div class="col-xs-8 col-md-8">
																		<input type="text" id="projectDueDate" name="projectDueDate" class="col-xs-12"  placeholder="yyyy-mm-dd" value="#DateFormat(now(),"yyyy-mm-dd")#"/>
																	</div>
																</li>

																<div class="space"></div>

																<li class="row form-group">
																	<label class="control-label col-xs-4 col-md-2">#getLabel("Hours", #SESSION.languageId#)#</label>
																	<div class="col-xs-8 col-md-8">
																		<input type="text" id="projectEstimate" name="projectEstimate" class="col-xs-12"  placeholder="Hours" value=1 />
																	</div>
																</li>

																<div class="space"></div>

																<li class="row form-group">
																	<label class="control-label col-xs-4 col-md-2"> #getLabel("Budget", #SESSION.languageId#)#</label>
																	<div class="col-xs-8 col-md-8">
																		<input type="text" id="projectBudget" name="projectBudget" class="col-xs-12" placeholder="Budget" value=1 />
																	</div>
																</li>
																<div class="space"></div>

																<li class="row form-group">
																	<label class="control-label col-xs-4 col-md-2">#getLabel("Short Description", #SESSION.languageId#)#</label>
																	<div class="col-xs-8 col-md-8">
																		<input class="col-xs-12" type="text" id="projectShortDescription" name="projectShortDescription" placeholder="Short Description"/>
																	</div>
																</li>

																<div class="space"></div>

																<li class="row form-group">
																	<label class="control-label col-xs-4 col-md-2"> #getLabel("Description", #SESSION.languageId#)#</label>
																	<div class="col-xs-8 col-md-8">
																		<div id="editor" class="wysiwyg-editor"></div>
																		<input type="hidden" name="description" id='description'/>
																	</div>
																</li>
																<div class="space"></div>

																<li class="row form-group">
																	<label class="control-label col-xs-4 col-md-2"> #getLabel("Active", #SESSION.languageId#)#</label>
																	<div class="col-xs-8 col-md-8">
																		<input name="projectActive" id="projectActive" class="ace ace-switch" type="checkbox" checked>
																		<span class="lbl"></span>
																	</div>
																</li>
																<li class="divider"></li>
															</ul>
														</div>
													</div>
												</div>
											</div><!-- /.col -->

											<div class="col-xs-12 col-md-6">
												<div  class="form-group">
													<div class="row">
														<div class="col-xs-11 label label-lg label-success arrowed-in arrowed-right">
															<b>Company</b>
														</div>
													</div>

													<div>
														<div class="col-xs-12">
															<ul class="list-unstyled  spaced">
																<li class="row form-group" id="selectCompany">
																	<label class="control-label col-xs-3">#getLabel("Company Name", #SESSION.languageId#)#</label>
																	<div class="col-xs-7">
																		<div class="input-group">
																			<span class="input-group-addon">
																				<i class="ace-icon fa fa-hand-o-right"></i>
																			</span>
																			<select class=" col-xs-12" id="cbcompanyName" name="companyId" data-placeholder="Choose company name">
																			      <cfloop query= rc.company >
																			      <option value="#rc.company.companyID#" id='company#rc.company.companyID#'>#rc.company.companyName#</option>      
																			      </cfloop>
																		    </select>
																		    <input type="hidden" name="checkAddNewCompany" id="checkAddNewCompany" value="0">
																	    </div>
																	</div>
																	<span class="btn btn-xs btn-success col-xs-1" id="addCompany">
																		<i class="ace-icon glyphicon glyphicon-plus"></i>
																	</span>
																</li>

																<div id="frmAddCompany" class="hidden">	
																	 <li class="row form-group">
																		<label class="control-label col-xs-3">#getLabel("Company Name", #SESSION.languageId#)#</label>
																		<div class="col-xs-7">
																			<div class="input-group">
																				<span class="input-group-addon">
																					<i class="ace-icon fa fa-hand-o-right"></i>
																				</span>
																				<input type="text" id="companyNew" name="companyName" class="col-xs-12" placeholder="Company Name" />
																			</div>
																		</div>
																		<span class="btn btn-xs btn-success col-xs-1 hidden" id="undoAddCompany">
																			<i class="ace-icon fa fa-undo"></i>
																		</span>
																	</li>
																	<div id="frmAddCompany2">	
																		<li class="row form-group">
																			<label class="control-label col-xs-3">#getLabel("Address", #SESSION.languageId#)#</label>
																			<div class="col-xs-7">
																				<div class="input-group">
																					<span class="input-group-addon">
																						<i class="ace-icon fa fa-list-alt"></i>
																					</span>
																					<input type="text" id="companyAddress" name="companyAddress" class="col-xs-12" placeholder="Address"/>
																				</div>
																			</div>
																		</li>

																		<li class="row form-group">
																			<label class="control-label col-xs-3">#getLabel("Phone", #SESSION.languageId#)#</label>
																			<div class="col-xs-7">
																				<div class="input-group">
																					<span class="input-group-addon">
																						<i class="ace-icon fa fa-phone"></i>
																					</span>
																					<input type="text" id="companyPhone" name="companyPhone" class="col-xs-8 col-xs-8 col-md-8" placeholder="Phone" maxlength="20"/>
																				</div>
																			</div>
																		</li>

																		<li class="row form-group">
																			<label class="control-label col-xs-3">#getLabel("Description", #SESSION.languageId#)#</label>
																			<div class="col-xs-7">
																				<div class="input-group">
																					<span class="input-group-addon">
																						<i class="ace-icon fa fa-hand-o-right"></i>
																					</span>
																					<textarea id="companyDescription" name="companyDescription" class="col-xs-12" placeholder="Description"></textarea>
																				</div>
																			</div>
																		</li>

																		<li class="row form-group">
																			<label class="control-label col-xs-3">#getLabel("Email", #SESSION.languageId#)#</label>
																			<div class="col-xs-7">
																				<div class="input-group">
																					<span class="input-group-addon">
																						<i class="ace-icon fa fa-envelope "></i>
																					</span>
																					<input type="text" id="companyEmail" name="companyEmail" class="col-xs-12" placeholder="Email" required="true">
																				</div>
																			</div>
																		</li>
																		<li class="row form-group">
																			<div class="col-xs-12 col-md-7 col-md-offset-4">
																				<span class="btn btn-sm btn-success" id="addNewCompany">
																					<i class="ace-icon fa fa-floppy-o"></i>
																				</span>
																				<span class="btn btn-sm btn-success" id="undoAddNewCompany">
																					<i class="ace-icon fa fa-refresh "></i>
																				</span>
																			</div>
																		</li>
																	</div>
																</div>

																<li class="divider"></li>
															</ul>
														</div>
													</div>
												</div>
												<div class="space"></div>
												<div class="form-group">
													<div class="row">
														<div class="col-xs-11 label label-lg label-warning arrowed-in arrowed-right">
															<b>Customer</b>
														</div>
													</div>

													<div>
														<div class="col-xs-12">
															<ul class="list-unstyled  spaced">
																<li class="row form-group">
																	<label class="control-label col-xs-3">#getLabel("Customer Name", #SESSION.languageId#)#</label>
																	<div class="col-xs-7">
																		<div class="input-group">
																			<span class="input-group-addon">
																				<i class="ace-icon fa fa-search"></i>
																			</span>
																		    <input id="searchCustomer" type="text" class="form-control" />
																		</div>
																	</div>
																	<span class="btn btn-xs btn-warning col-xs-1" id="addCustomer">
																		<i class="ace-icon glyphicon glyphicon-plus"></i>
																	</span>
																	<span class="btn btn-xs btn-warning col-xs-1 hidden" id="undoAddCustomer">
																		<i class="ace-icon fa fa-undo"></i>
																	</span>
																</li>
																<li class="space-6"></li>
																<li class="row form-group">
																	<ol class="col-xs-5" id="listAddCustomer">
																	</ol>
																</li>

																<div id="frmAddCustomer" class="hidden">	
																	<li class="row form-group">
																		<label class="control-label col-xs-3">#getLabel("User Name", #SESSION.languageId#)#</label>
																		<div class="col-xs-7">
																			<div class="input-group">
																				<input type="text" id="customerUsername" name="customerUsername" class="col-xs-12" placeholder="UserName"/>
																			</div>
																		</div>
																	</li>

																	<li class="row form-group">
																		<label class="control-label col-xs-3">#getLabel("Email", #SESSION.languageId#)#</label>
																		<div class="col-xs-7">
																			<div class="input-group">
																				<input type="text" id="customerEmail" name="customerEmail" class="col-xs-12" placeholder="Email"/>
																			</div>
																		</div>
																	</li>

																	<li class="row form-group">
																		<label class="control-label col-xs-3">#getLabel("First Name", #SESSION.languageId#)#</label>
																		<div class="col-xs-7">
																			<div class="input-group">
																				<input type="text" id="customerFirstname" name="customerFirstname" class="col-xs-12" placeholder="First Name"/>
																			</div>
																		</div>
																	</li>

																	<li class="row form-group">
																		<label class="control-label col-xs-3">#getLabel("Last Name", #SESSION.languageId#)#</label>
																		<div class="col-xs-7">
																			<div class="input-group">
																				<input type="text" id="customerLastname" name="customerLastname" class="col-xs-12" placeholder="Last Name"/>
																			</div>
																		</div>
																	</li>
																	<li class="row form-group">
																		<div class="col-xs-12 col-md-7 col-md-offset-4">
																			<span class="btn btn-sm btn-warning" id="addNewCustomer">
																				<i class="ace-icon fa fa-floppy-o"></i>
																			</span>
																			<span class="btn btn-sm btn-warning" id="undoAddCompany">
																				<i class="ace-icon fa fa-refresh "></i>
																			</span>
																		</div>
																	</li>
																</div>

																<li class="divider"></li>
															</ul>
														</div>
													</div>
												</div>
												<div class="form-group">
													<div class="row">
														<div class="col-xs-11 label label-lg label-danger arrowed-in arrowed-right">
															<b>Developer</b>
														</div>
													</div>

													<div>
														<div class="col-xs-10 col-xs-offset">
															<ul class="list-unstyled  spaced">
																<li class="row form-group">
																	<label class="control-label col-xs-4">#getLabel("Developer Name", #SESSION.languageId#)#</label>
																	<div class="input-group col-xs-8">
																		<span class="input-group-addon">
																			<i class="ace-icon fa fa-search"></i>
																		</span>
																		<input id="searchDeveloper" type="text" class="form-control" />
																	</div>
																</li>
																<li class="space-6"></li>
																<li class="row form-group">
																	<ol class="col-xs-12 col-md-7" id="listAddDeveloper">
																	</ol>
																</li>
																<li class="divider"></li>
															</ul>
														</div>
													</div>
												</div>
												
											</div><!-- /.col -->
										</div><!-- /.row -->

										<div class="space"></div>

										<div class="hr hr8 hr-double hr-dotted"></div>

										<div class="space-6"></div>
									</div>
								</div>
							</div>

							<!-- /section:pages/invoice -->
						</div>
					</div>

					<!-- PAGE CONTENT ENDS -->
				</div><!-- /.col -->
			</div><!-- /.row -->
			<div class="clearfix form-actions">
				<div class="col-md-offset-4 col-md-6">
					<button class="btn btn-info" onclick='submitform()' type="button">
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
		</form>


		<!--- // $("##user#rc.loadProject.projectLeadID#").attr("selected","selected"); --->
		<!--- // $("##type#rc.loadProject.projectTypeID#").attr("selected","selected"); --->
		<!--- // $("##status#rc.loadProject.projectStatusID#").attr("selected","selected"); --->
	</div>
</div>
<script type="text/javascript">
var availableSearchCustomer = <cfoutput>#rc.arrayNameCustomer#</cfoutput>;
var availableSearchDeveloper = <cfoutput>#rc.arrayNameDeveloper#</cfoutput>;
var isfirst = true ;
<cfif structKeyExists(rc,"loadProject")>
		$("###rc.loadProject.color#").attr('checked','checked');
		$("##projectName").val("#rc.loadProject.projectName#");
		$("##projectShortName").val("#rc.loadProject.shortName#");
		$("##projectUrl").val("#rc.loadProject.projectUrl#");
		$("##projectDueDate").val('#DateFormat(rc.loadProject.dueDate,"yyyy-mm-dd")#');
		$("##projectEstimate").val("#rc.loadProject.totalEstimate#");
		$("##projectBudget").val("#rc.loadProject.budget#");
		$("##editor").html("#replace(rc.loadProject.Description,'"','&##34;','all')#");
		$("##projectShortDescription").val('#rc.loadProject.shortdes#');
		$("##type#rc.loadProject.getType().getProjectTypeID()#").attr("selected","selected");
		<cfif not isNull(rc.loadProject.getCompany())>
			$("##company#rc.loadProject.getCompany().getCompanyID()#").attr("selected","selected");
		</cfif>
		$("##status#rc.loadProject.getStatus().getProjectStatusID()#").attr("selected","selected");
		if(#rc.loadProject.active#)
			$("##projectActive").attr("checked","checked");
		else 
			$("##projectActive").attr("checked","");

		<cfloop array="#rc.loadProject.getUsers()#" item="user">
			<cfif user.getType().getUserTypeID() eq 1>
				$('##listAddCustomer').append('\
				<li class="nameAddCustomer">\
					#user.firstname&" "&user.lastname#\
					<input type="hidden" name="idCus[]" value="#user.getUserID()#">\
					<input type="hidden" name="userNameCus[]" value="">\
					<input type="hidden" name="firstnameCus[]" value="">\
					<input type="hidden" name="lastnameCus[]" value="">\
					<input type="hidden" name="emailCus[]" value="">\
					<div data-action="delete" class="action-buttons pull-right">\
						<a><i class="small ui-icon ace-icon fa fa-trash-o red" style="cursor: pointer;"></i></a>\
					</div>\
				</li>').find('div[data-action=delete]').on('click', function(e){
							$(this).parent().hide(300, function(){$(this).remove();});
							if($.inArray("#user.firstname&" "&user.lastname#",availableSearchCustomer)== -1)
								availableSearchCustomer.push("#user.firstname&" "&user.lastname#");
						});
				availableSearchCustomer = jQuery.grep(availableSearchCustomer, function(value) {
								        return value.id != "#user.getUserID()#";});

			<cfelseif user.getType().getUserTypeID() neq 1>
				var leader = "";
				<cfif user.getUserID() eq rc.loadProject.getLeader().getUserID()>
					leader="checked";
					isfirst=false;
				</cfif>
				$('##listAddDeveloper').append('\
					<li>\
						#user.firstname&" "&user.lastname#\
						<input type="hidden" name=idDev[] value="#user.getUserID()#">\
						<div data-action="delete" class="action-buttons pull-right">\
							<a><i class="small ui-icon ace-icon fa fa-trash-o red" style="cursor: pointer;"></i></a>\
						</div>\
						<div class="action-buttons">\
							<input name="isLeader" value="#user.getUserID()#" '+leader+' type="radio"  class="ace">\
							<span class="lbl" > is Leader</span>\
						</div>\
					</li>').find('div[data-action=delete]').on('click', function(e){
								if($(this).next().find('input[name=isLeader]').is(':checked')){
										if($(this).parent().next().length >0)
											$(this).parent().next().find('input[name=isLeader]').prop('checked',true);
										else if($(this).parent().prev().length>0)
											$(this).parent().prev().find('input[name=isLeader]').prop('checked',true);
										else
											isfirst=true;
									}
								//the button that removes the newly inserted file input
								
								$(this).parent().hide(300, function(){$(this).remove();});
								if($.inArray("#user.firstname&" "&user.lastname#",availableSearchDeveloper)== -1)
									availableSearchDeveloper.push("#user.firstname&" "&user.lastname#");
							});
					availableSearchDeveloper = jQuery.grep(availableSearchDeveloper, function(value) {
									        return value.id != "#user.getUserID()#";
									      });
			</cfif>
			
		</cfloop>
</cfif>
</script>
</cfoutput>



<script type="text/javascript">
/*=================Define Array Autocomplete=========================*/
 var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
 var flagU = false;
 var flagE = false;
 var flagSN = false;
 var checkOutFocusShortName = false;
/*================End Define Array Autocomplete===================== */
$(function() {
	$('#listAddCustomer').find('div[data-action=delete]').each(function(){
		$(this).on('click',function(){
			$( "#searchCustomer" ).autocomplete('option', 'source', availableSearchCustomer);
		});
	});

	$('#listAddDeveloper').find('div[data-action=delete]').each(function(){
		$(this).on('click',function(){
			$( "#searchDeveloper" ).autocomplete('option', 'source', availableSearchDeveloper);
		});
	});

    $( "#projectDueDate" ).datepicker({
        changeMonth: true,
        changeYear: true,
        dateFormat: "yy-mm-dd"
    }).val();
/* ==================Box Company==============================*/
    $('#addCompany').on('click',function() {
    	$("#checkAddNewCompany").val("1");
    	$(this).addClass('hidden');
    	$(this).closest('.form-group').addClass('hidden');
    	$('#undoAddCompany').removeClass('hidden');
    	$('#frmAddCompany').removeClass('hidden');
    	$('#frmAddCompany2').removeClass('hidden');
    	$('#selectCompany').addClass('hidden');
    });
    $('#undoAddCompany').on('click',function(){
    	$("#checkAddNewCompany").val("0");
    	$('#addCompany').removeClass('hidden');
    	$(this).addClass('hidden');
    	$('#frmAddCompany').addClass('hidden');
    	$('#selectCompany').removeClass('hidden');
    	$(this).closest('.form-group').removeClass('hidden');
    });
    $('#addNewCompany').on('click',function(){
    	var companyNew = $('#companyNew').val().trim();
    	var companyAddress = $('#companyAddress').val().trim();
    	var companyPhone = $('#companyPhone').val().trim();
    	var companyDescription = $('#companyDescription').val().trim();
    	var companyEmail = $('#companyEmail').val().trim();
    	$('#frmAddCompany').find('.help-block').remove();
    	$('#frmAddCompany').find('.has-error').removeClass('has-error');

    	if(companyNew == "" || companyAddress=="" || companyPhone=="" || companyDescription=="" || companyEmail=="")
    	{
    		if(companyNew == ""){
    			$('#companyNew').closest('.form-group').addClass('has-error');
    			$("#companyNew").parent().parent().append('<div for="companyNew" class="help-block">Please provide Company Name</div>');
    		}
    		if(companyAddress==""){
    			$('#companyAddress').closest('.form-group').addClass('has-error');
    			$("#companyAddress").parent().parent().append('<div for="companyAddress" class="help-block">Please provide Address</div>');
    		}
    		if(companyPhone==""){
    			$('#companyPhone').closest('.form-group').addClass('has-error');
    			$("#companyPhone").parent().parent().append('<div for="companyPhone" class="help-block">Please provide Phone</div>');
    		}
    		if(companyDescription==""){
    			$('#companyDescription').closest('.form-group').addClass('has-error');
    			$("#companyDescription").parent().parent().append('<div for="companyDescription" class="help-block">Please provide Description</div>');
    		}
    		if(companyEmail==""){
    			$('#companyEmail').closest('.form-group').addClass('has-error');
    			$("#companyEmail").parent().parent().append('<div for="companyEmail" class="help-block">Please provide Email</div>');
    		}	
    	}
    	else if($.isNumeric(companyPhone) == false || regex.test(companyEmail)== false)
    	{
    		if($.isNumeric(companyPhone) == false)
    		{
    			$('#companyPhone').closest('.form-group').addClass('has-error');
    			$("#companyPhone").parent().parent().append('<div for="companyPhone" class="help-block">Phone not valid</div>');
    		}
    		else
    		{
    			$('#companyEmail').closest('.form-group').addClass('has-error');
    			$("#companyEmail").parent().parent().append('<div for="companyPhone" class="help-block">Email not valid</div>');
    		}
    		
    	}
    	else
    	{
    		$("#checkAddNewCompany").val("1");
			$('#frmAddCompany2').addClass('hidden');
    	}
    });

/* ==================Box Customer==============================*/
    $("#addCustomer").on('click',function(){
    	$("#searchCustomer").attr('disabled',true);
    	$(this).addClass('hidden');
    	$('#undoAddCustomer').removeClass('hidden');
    	$('#listAddCustomer').addClass('hidden');
    	$('#frmAddCustomer').removeClass('hidden');

    });
    $('#undoAddCustomer').on('click',function(){
    	$("#searchCustomer").removeAttr('disabled');
    	 $('#listAddCustomer').removeClass('hidden');
    	$(this).addClass('hidden');
    	$('#frmAddCustomer').addClass('hidden');
    	$("#addCustomer").removeClass('hidden');
    });
   	$( "#searchCustomer" ).autocomplete({
		source:availableSearchCustomer,
		minLength : 3,
		select:function(event,ui){
			$('#listAddCustomer').append('\
				<li class="nameAddCustomer">\
					'+ui.item.label +'\
					<input type="hidden" name="idCus[]" value="'+ui.item.id+'">\
					<input type="hidden" name="userNameCus[]" value="">\
					<input type="hidden" name="firstnameCus[]" value="">\
					<input type="hidden" name="lastnameCus[]" value="">\
					<input type="hidden" name="emailCus[]" value="">\
					<div data-action="delete" class="action-buttons pull-right">\
						<a><i class="small ui-icon ace-icon fa fa-trash-o red" style="cursor: pointer;"></i></a>\
					</div>\
				</li>').find('div[data-action=delete]').on('click', function(e){
							//the button that removes the newly inserted file input
							$(this).parent().hide(300, function(){$(this).remove();});
							if($.inArray(ui.item.label,availableSearchCustomer)== -1)
								availableSearchCustomer.push(ui.item.label);
							 $( "#searchCustomer" ).autocomplete('option', 'source', availableSearchCustomer);
						});
				availableSearchCustomer = jQuery.grep(availableSearchCustomer, function(value) {
								        return value.id != ui.item.id;
								      });
				 $( "#searchCustomer" ).autocomplete('option', 'source', availableSearchCustomer);
			
		}
	}).on('focus', function(event) {
	    $(this).autocomplete("search", "");
	});
	$("#addNewCustomer").on('click',function(){
		var customerUsername = $('#customerUsername').val().trim();
    	var customerEmail = $('#customerEmail').val().trim();
    	var customerFirstname = $('#customerFirstname').val().trim();
    	var customerLastname = $('#customerLastname').val().trim();
    	$('#frmAddCustomer').find('.help-block').remove();
    	$('#frmAddCustomer').find('.has-error').removeClass('has-error');

		if(customerUsername == "" || customerEmail=="" || customerFirstname=="" || customerLastname=="" ||flagU==false ||flagE==false)
		{
    		if(customerUsername == "" || flagU==false)
    		{
    			$('#customerUsername').closest('.form-group').addClass('has-error');
    			$("#customerUsername").parent().parent().append('<div for="customerUsername" class="help-block">Please check UserName</div>');
    		}
    		if(customerEmail=="" || flagE==false)
    		{
    			$('#customerEmail').closest('.form-group').addClass('has-error');
    			$("#customerEmail").parent().parent().append('<div for="customerEmail" class="help-block">Please check your Email</div>');
    		}
    		if(customerFirstname==""){
    			$('#customerFirstname').closest('.form-group').addClass('has-error');
    			$("#customerFirstname").parent().parent().append('<div for="customerFirstname" class="help-block">Please provide Firstname</div>');
    		}
    		if(customerLastname==""){
    			$('#customerLastname').closest('.form-group').addClass('has-error');
    			$("#customerLastname").parent().parent().append('<div for="customerLastname" class="help-block">Please provide Lastname</div>');
    		}
    		
		}
		else if(flagU==true && flagE==true)
		{
			$('#listAddCustomer').append('\
				<li class="nameAddCustomer">\
					'+$("#customerFirstname").val()+" "+$("#customerLastname").val()+' <span class="label label-info arrowed arrowed-in-right">New</span>\
					<input type="hidden" name="idCus[]" value="">\
					<input type="hidden" name="userNameCus[]" value="'+$("#customerUsername").val()+'">\
					<input type="hidden" name="firstnameCus[]" value="'+$("#customerFirstname").val()+'">\
					<input type="hidden" name="lastnameCus[]" value="'+$("#customerLastname").val()+'">\
					<input type="hidden" name="emailCus[]" value="'+$("#customerEmail").val()+'">\
					<div data-action="delete" class="action-buttons pull-right">\
						<a><i class="small ui-icon ace-icon fa fa-trash-o red" style="cursor: pointer;"></i></a>\
					</div>\
				</li>').find('div[data-action=delete]').on('click', function(e){
						$(this).parent().hide(300, function(){$(this).remove();});
					});

			$('#frmAddCustomer').addClass('hidden');
			$('#addCustomer').removeClass('hidden');
			$('#undoAddCustomer').addClass('hidden');
			$("#customerFirstname").val('');
			$("#customerLastname").val('');
			$("#customerUsername").val('');
			$("#searchCustomer").attr('disabled',false);
			$("#listAddCustomer").removeClass('hidden');
			}
		
	});
	
	$("#customerUsername").focusout(function() {
		var controls = $(this).closest('div[class*="col-"]');
		controls.find('.help-block').remove();
		if($(this).val().trim() == "")
		{
			flagU = false;
    		$("#customerUsername").closest('.form-group').removeClass('has-success');
    		$("#customerUsername").closest('.form-group').addClass('has-error');
    		$("#customerUsername").parent().parent().append('<div for="customerUsername" class="help-block">Username exists or not valid</div>');
		}
		else
		{
			$.ajax({
	            type: "POST",
	            url: "/index.cfm/home:project.checkUsernameExist",
	            data: {
	            	username: $(this).val().trim()
	            },
	            success: function( data ) {
	            	if(data.success == true){
	            		flagU = true;
	            		$("#customerUsername").closest('.form-group').removeClass('has-error');
	            		$("#customerUsername").closest('.form-group').addClass('has-success');
	            	}
	            	else{
	            		flagU = false;
	            		$("#customerUsername").closest('.form-group').removeClass('has-success');
	            		$("#customerUsername").closest('.form-group').addClass('has-error');
	            		$("#customerUsername").parent().parent().append('<div for="customerUsername" class="help-block">Username exists</div>');
	            	}
	            }

	        });
		}
		
	});

	$("#customerEmail").focusout(function() {
		var controls = $(this).closest('div[class*="col-"]');
		controls.find('.help-block').remove();
		if($(this).val().trim() == "" || regex.test($(this).val().trim() )== false)
		{
			flagE = false;
			$("#customerEmail").closest('.form-group').removeClass('has-success');
    		$("#customerEmail").closest('.form-group').addClass('has-error');
    		$("#customerEmail").parent().parent().append('<div for="customerEmail" class="help-block">Email not valid</div>');
		}
		else
		{
			$.ajax({
	            type: "POST",
	            url: "/index.cfm/home:project.checkEmailExist",
	            data: {
	            	email: $(this).val().trim()
	            },
	            success: function( data ) {
	            	if(data.success == true){
	            		flagE = true;
	            		$("#customerEmail").closest('.form-group').removeClass('has-error');
	            		$("#customerEmail").closest('.form-group').addClass('has-success');
	            	}
	            	else{
	            		flagE = false;
	            		$("#customerEmail").closest('.form-group').removeClass('has-success');
	            		$("#customerEmail").closest('.form-group').addClass('has-error');
	            		$("#customerEmail").parent().parent().append('<div for="customerEmail" class="help-block">Email exists or not valid</div>');
	            	}
	            }

	        });
		}
		
	});

	$("#projectShortName").focusout(function() {
		var flagcheckEdit = false;
		checkOutFocusShortName = true;
		var ShortName = "";
		<cfif structKeyExists(rc,"loadProject")>
			<cfoutput>
				ShortName = "#rc.loadProject.shortName#"
			</cfoutput>
		</cfif>
		if(ShortName == $(this).val().trim() && ShortName != "")
		{
			flagcheckEdit=true;
		}
		var controls = $(this).closest('div[class*="col-"]');
		controls.find('.help-block').remove();
			if($(this).val().trim() == "")
			{
				flagSN = false;
				$("#projectShortName").closest('.form-group').removeClass('has-success');
	    		$("#projectShortName").closest('.form-group').addClass('has-error');
	    		$("#projectShortName").closest('div[class*="col-"]').append('<div for="projectShortName" class="help-block">Short Name not valid</div>');
			}
			else if($(this).val().trim().length >=2 && $(this).val().trim().length<=10)
			{
				$.ajax({
		            type: "POST",
		            url: "/index.cfm/home:project.checkShortNameExist",
		            data: {
		            	shortname: $(this).val().trim()
		            },
		            success: function( data ) {
		            	if(data.success == true || flagcheckEdit){
		            		flagSN = true;
		            		$("#projectShortName").closest('.form-group').removeClass('has-error');
		            		$("#projectShortName").closest('.form-group').addClass('has-success');
		            	}
		            	else{
		            		flagSN = false;
		            		$("#projectShortName").closest('.form-group').removeClass('has-success');
		            		$("#projectShortName").closest('.form-group').addClass('has-error');
		            		$("#projectShortName").closest('div[class*="col-"]').append('<div for="projectShortName" class="help-block">Short Name exists or not valid</div>');
		            	}
		            }

		        });
			}
			
		});

	

	
/* ==================Box Developer==============================*/
	$("#searchDeveloper").autocomplete({
		source:availableSearchDeveloper,
		minLength : 3,
		select:function(event,ui){
			var checked = isfirst ? "checked":"";
			isfirst = false ;
			$('#listAddDeveloper').append('\
				<li>\
					'+ui.item.label +'\
					<input type="hidden" name=idDev[] value="'+ui.item.id+'">\
					<div data-action="delete" class="action-buttons pull-right">\
						<a><i class="small ui-icon ace-icon fa fa-trash-o red" style="cursor: pointer;"></i></a>\
					</div>\
					<div class="action-buttons">\
						<input name="isLeader" value="'+ui.item.id+'" '+checked+' type="radio"  class="ace">\
						<span class="lbl" > is Leader</span>\
					</div>\
				</li>').find('div[data-action=delete]').on('click', function(e){
							//the button that removes the newly inserted file input
							if($(this).next().find('input[name=isLeader]').is(':checked')){
								if($(this).parent().next().length >0)
									$(this).parent().next().find('input[name=isLeader]').prop('checked',true);
								else if($(this).parent().prev().length>0)
									$(this).parent().prev().find('input[name=isLeader]').prop('checked',true);
								else
									isfirst=true;
							}
							$(this).parent().hide(300, function(){$(this).remove();});
							if($.inArray(ui.item.label,availableSearchDeveloper)== -1)
								availableSearchDeveloper.push(ui.item.label);
							 $( "#searchDeveloper" ).autocomplete('option', 'source', availableSearchDeveloper);
						});
				availableSearchDeveloper = jQuery.grep(availableSearchDeveloper, function(value) {
								        return value.id != ui.item.id;
								      });
				 $( "#searchDeveloper" ).autocomplete('option', 'source', availableSearchDeveloper);
			
		}
	}); 
});

jQuery(function($) {			
	$('#myform').validate({
		errorElement: 'div',
		errorClass: 'help-block',
		focusInvalid: false,
		rules: {
			projectName: {
				required: true,
				minlength: 5
			},
			projectShortName: {
				required: true,
				minlength: 2,
				maxlength: 10
			},
			projectUrl: {
				required: true
			},
			projectDueDate: {
				required: true
			},
			projectLead: {
				required: true
			},
			projectBudget: {
				required: true
			}
		},

		messages: {
			projectName: {
				required: "Please provide a valid Project Name.",
				minlength: "Name is Min length 5 character"
			},
			projectShortName: {
				required: "Please specify a ShortName.",
				minlength: "ShortName is Min length 2 character",
				maxlength: "ShortName is Max length 10 character"
			}
		},


		highlight: function (e) {
			$(e).closest('.form-group').removeClass('has-info').addClass('has-error');
		},

		success: function (e) {
			$(e).closest('.form-group').removeClass('has-error');//.addClass('has-info');
			$(e).remove();
		},

		errorPlacement: function (error, element) {
			var controls = element.closest('div[class*="col-"]');
			controls.append(error);
		},

		submitHandler: function (form) {
		},
		invalidHandler: function (form) {
		}
	});
})
function addnewproject(){
	if($('#newProjectForm').valid()){
        $('#pmodal').modal('hide');
		for (var i=0; i < document.newProjectForm.projectColor.length; i++)
		   {
			   if (document.newProjectForm.projectColor[i].checked)
			      {
			      var pCl = document.newProjectForm.projectColor[i].value;
			      }
			}
		$.ajax({
            type: "POST",
            url: "/index.cfm/home:main.newProject",
            data: {
            	pName : $('#projectName').val(),
            	sName : $('#projectShortName').val(),
            	dDate : $('#projectDueDate').val(),
            	pUrl  : $('#projectUrl').val(),
            	pDes  : $('#projectDescription').val(),
            	pColor: pCl,
            	pLeader: $('#projectLead').val(),
            	pBudget: $('#projectBudget').val(),
            	pEstimate: $('#projectEstimate').val(),
            	pActive: $('#projectActive').val() == "on",
            },
            success: function( data ) {
            	if(data != false){
            		window.location="/index.cfm/project?id="+data ;
            	}else{
            		$('#message').prepend('<div class="alert alert-danger">add project fail!</div>');
            	}
            }
        });
	}
}
</script>
<script type="text/javascript">
	jQuery(function($) {
		$('#editor').ace_wysiwyg({
			toolbar:
			[
				
				{
					name:'fontSize',
					title:'Custom tooltip',
					values:{1 : 'Size#1 Text' , 2 : 'Size#1 Text' , 3 : 'Size#3 Text' , 4 : 'Size#4 Text' , 5 : 'Size#5 Text'} 
				},
				{name:'bold', title:'Custom tooltip'},
				{name:'italic', title:'Custom tooltip'},
				{name:'strikethrough', title:'Custom tooltip'},
				{name:'underline', title:'Custom tooltip'},
				'insertunorderedlist',
				'insertorderedlist',
				'outdent',
				'indent',
				{
					name:'createLink',
					placeholder:'Custom PlaceHolder Text',
					button_class:'btn-purple',
					button_text:'Custom TEXT'
				},
				{name:'unlink'},
				'viewSource'
			],
			//speech_button:false,//hide speech button on chrome
			
			'wysiwyg': {
				hotKeys : {} //disable hotkeys
			}
			
		}).prev().addClass('wysiwyg-style2');
		$('#myform').on('reset', function() {
			$('#editor').empty();
		});
		
	});
	function submitform(){
		$('#description').val($('#editor').html());

		if($('input[name=isLeader]').length <1 )
		{
			alert('Please provide Developer');
			return;
		}

		if(flagSN==false && checkOutFocusShortName==false)
		{
			var flagSubmit = false;
			var ShortName = "";
			<cfif structKeyExists(rc,"loadProject")>
				<cfoutput>
					ShortName = "#rc.loadProject.shortName#"
				</cfoutput>
			</cfif>
			if(ShortName == $('#projectShortName').val().trim() && ShortName != "")
			{
				flagSubmit=true;
			}
			$.ajax({
		            type: "POST",
		            url: "/index.cfm/home:project.checkShortNameExist",
		            data: {
		            	shortname: $('#projectShortName').val().trim()
		            },
		            success: function( data ) {
		            	if(data.success == true || flagSubmit){
		            		if($('#myform').valid()){
								document.getElementById("myform").submit();
							}
		            	}
		            	else{
		            		$("#projectShortName").closest('.form-group').removeClass('has-success');
		            		$("#projectShortName").closest('.form-group').addClass('has-error');
		            		$("#projectShortName").closest('div[class*="col-"]').append('<div for="projectShortName" class="help-block">Short Name exists or not valid</div>');
		            		return;
		            	}
		            }

		        });
		}
		else if(flagSN==false)
		{
			$('#projectShortName').closest('div[class*="col-"]').find('.help-block').remove();
			$("#projectShortName").closest('.form-group').removeClass('has-success');
    		$("#projectShortName").closest('.form-group').addClass('has-error');
    		$("#projectShortName").closest('div[class*="col-"]').append('<div for="projectShortName" class="help-block">Short Name exists or not valid</div>');
    		return;
		}
		else
		{
			if($('#myform').valid()){
				document.getElementById("myform").submit();
			}
		}
	}
</script>