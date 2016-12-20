<cfoutput>
	<cfset pass = LEFT(createUUID(),6)>
	<div class="row clearfix">
		<div class="col-md-12" style="border-bottom:2px ##428bca solid;">
			<h1 class="blue">#getLabel("User", #SESSION.languageId#)#:<small>#getLabel("New Member", #SESSION.languageId#)#</small></h1>
		</div>
	</div>
	<cfif structKeyExists(rc,"message")>
		<div class="row">
			<div class="alert alert-danger">
				#rc.message#
			</div>
		</div>
	</cfif>
	<div class="row clearfix" style="margin-top:20px;">
		<div class="row">
			<div class="col-xs-12">
				<form class="form-horizontal" id="validation-form" method="post"enctype="multipart/form-data">
					
					<div class="form-group">
						<label class="col-xs-3 control-label no-padding-right" for="username"> #getLabel("User Name", #SESSION.languageId#)# </label>
						<div class="col-sm-4 col-xs-9">
							<input type="text"  name="username" id="username" placeholder="Username" class="col-xs-12" required>
						</div>
					</div>
					<div class="space-4"></div>

					<div class="form-group">
						<label class="col-sm-3 control-label no-padding-right" for="password"> #getLabel("Password", #SESSION.languageId#)# </label>

						<div class="col-sm-4 col-xs-9">
							<input type="text" name="password" id="password" placeholder="Password" class="col-xs-12" value="#pass#" required>
							<input type="hidden" name="hpassword" id="hpassword" >
						</div>
					</div>
					<div class="space-4"></div>

					<div class="form-group">
						<label class="col-sm-3 control-label no-padding-right" for="firstname"> #getLabel("First Name", #SESSION.languageId#)# </label>

						<div class="col-sm-4 col-xs-9">
							<input type="text"  name="firstname" id="firstname" placeholder="First Name" class="col-xs-12" required>
						</div>
					</div>
					<div class="space-4"></div>
					<div class="form-group">
						<label class="col-sm-3 control-label no-padding-right" for="lastname"> #getLabel("Last Name", #SESSION.languageId#)# </label>

						<div class="col-sm-4 col-xs-9">
							<input type="text"  name="lastname" id="lastname" placeholder="Username" class="col-xs-12" >
						</div>
					</div>
					<div class="space-4"></div>

					<div class="form-group">
						<label class="col-sm-3 control-label no-padding-right" for="email"> #getLabel("Email", #SESSION.languageId#)# </label>

						<div class="col-sm-4 col-xs-9">
							<input type="text"  name="email" id="email" placeholder="Email" class="col-xs-12" required>
						</div>
					</div>

					<div class="space-4"></div>

					<div class="form-group">
						<label class="col-sm-3 control-label no-padding-right" for="type"> #getLabel("User Type", #SESSION.languageId#)# </label>

						<div class="col-sm-4 col-xs-9">
							<select type="text"  name="type" id="type" class="col-xs-12" >
								<option value="1" selected >Custommer</option>
								<option value="2">Programmer</option>
								<option value="3">Admin</option>
							</select>
						</div>
					</div>

					<div class="space-4"></div>

					<div class="form-group">
						<label class="col-sm-3 control-label no-padding-right" for="project"> #getLabel("Project", #SESSION.languageId#)# </label>

						<div class="col-sm-4 col-xs-9">
							<select type="text"  name="project" id="project"  class="col-xs-12" >
								<option value="0">Select Project</option>
								<cfloop query=#rc.listProject# >
									<option value="#rc.listProject.projectID#">#rc.listProject.projectName#</option>
								</cfloop>
							</select>
						</div>
					</div>

					<div class="space-4"></div>
					<div class="clearfix form-actions">
						<div class="col-md-offset-3 col-md-9">
							<button class="btn btn-info" type="submit">
								<i class="ace-icon fa fa-check bigger-110"></i>
								#getLabel("Submit", #SESSION.languageId#)#
							</button>

							&nbsp; &nbsp; &nbsp;
							<a href="/index.cfm/user">
							<button class="btn" type="button">
								<i class="ace-icon fa fa-undo bigger-110"></i>
								#getLabel("Return User Profile", #SESSION.languageId#)#
							</button>
							</a>
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>
</cfoutput>
<script type="text/javascript">
	jQuery(function($) {	
		$('#validation-form').validate({
			errorElement: 'div',
			errorClass: 'help-block',
			focusInvalid: false,
			rules: {
				username: {
					required: true,
					minlength: 5
				},
				password: {
					required: true,
					minlength: 5						
				},
				firstname: {
					required: true
				},
				lastname: {
					required: true
				},
				email: {
					required: true,
					email: true
				}
			},
	
			messages: {
				email: {
					required: "Please provide a valid email.",
					email: "Please provide a valid email."
				},
				password: {
					required: "Please specify a password.",
					minlength: "Please specify a secure password."
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
				if(element.is(':checkbox') || element.is(':radio')) {
					var controls = element.closest('div[class*="col-"]');
					if(controls.find(':checkbox,:radio').length > 1) controls.append(error);
					else error.insertAfter(element.nextAll('.lbl:eq(0)').eq(0));
				}
				else if(element.is('.select2')) {
					error.insertAfter(element.siblings('[class*="select2-container"]:eq(0)'));
				}
				else if(element.is('.chosen-select')) {
					error.insertAfter(element.siblings('[class*="chosen-container"]:eq(0)'));
				}
				else error.insertAfter(element.parent());
			},
			invalidHandler: function (form) {
			}
		});
	});
	$('#validation-form').on('submit',function(){
		if($('#validation-form').valid()){
			var oldPass=$('#password').val();
			var hPass=CryptoJS.MD5(oldPass).toString();
			$('#hpassword').val(hPass);
			return true;
		}else{
			return false;
		}
	});
</script>
