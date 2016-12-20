<cfoutput>
	<div class="row clearfix">
		<div class="col-md-12" style="border-bottom:2px ##428bca solid;">
			<h1 class="blue">#getLabel("User", #SESSION.languageId#)#:<small>#getLabel("Edit Profile", #SESSION.languageId#)#</small></h1>
		</div>
	</div>
	<div class="row clearfix" style="margin-top:20px;">
		<cfif structKeyExists(rc,"message")>
			<div class="alert alert-danger">
				#rc.message#
			</div>
		<cfelse>
		<cfif structKeyExists(rc,"Smessage")>
			<div class="alert alert-success">
				#rc.Smessage#
			</div>
		</cfif>
			<cfif rc.messagePost neq "">
				<div class="row alert alert-danger">#rc.messagePost#</div>
			</cfif>
			<div class="row">
				<div class="col-xs-12">
					<form class="form-horizontal" id="validation-form" method="post"enctype="multipart/form-data">
						
						<div class="form-group">
							<label class="col-sm-3 control-label no-padding-right" for="username"> #getLabel("User Name", #SESSION.languageId#)# </label>

							<div class="col-sm-9">
								<input type="text"  name="username" id="username" placeholder="Username" class="col-xs-10 col-sm-5" value='#rc.user.username#'>
								<span class="help-inline col-xs-12 col-sm-7">
									<span class="middle"></span>
								</span>
							</div>
						</div>
						<div class="space-4"></div>
						<div class="form-group">
							<label class="col-sm-3 control-label no-padding-right" for="firstname"> #getLabel("First Name", #SESSION.languageId#)# </label>

							<div class="col-sm-9">
								<input type="text"  name="firstname" id="firstname" placeholder="First Name" class="col-xs-10 col-sm-5" value='#rc.user.firstname#'>
								<span class="help-inline col-xs-12 col-sm-7">
									<span class="middle"></span>
								</span>
							</div>
						</div>
						<div class="space-4"></div>
						<div class="form-group">
							<label class="col-sm-3 control-label no-padding-right" for="lastname"> #getLabel("Last Name", #SESSION.languageId#)# </label>

							<div class="col-sm-9">
								<input type="text"  name="lastname" id="lastname" placeholder="Username" class="col-xs-10 col-sm-5" value='#rc.user.lastname#'>
								<span class="help-inline col-xs-12 col-sm-7">
									<span class="middle"></span>
								</span>
							</div>
						</div>
						<div class="space-4"></div>

						<div class="form-group">
							<label class="col-sm-3 control-label no-padding-right" for="slack"> Slack </label>

							<div class="col-sm-9">
								<input type="text"  name="slack" id="slack" placeholder="slack" class="col-xs-10 col-sm-5" value='#rc.user.slack#'>
								<span class="help-inline col-xs-12 col-sm-7">
									<span class="middle"></span>
								</span>
							</div>
						</div>						<div class="space-4"></div>
						<div class="form-group">
							<label class="col-sm-3 control-label no-padding-right" for="email"> #getLabel("Email", #SESSION.languageId#)# </label>

							<div class="col-sm-9">
								<input type="text"  name="email" id="email" placeholder="Email" class="col-xs-10 col-sm-5" value='#rc.user.email#' disabled="disabled">
								<span class="help-inline col-xs-12 col-sm-7">
									<span class="middle"></span>
								</span>
							</div>
						</div>
						<div class="space-4"></div>
						<div class="form-group">
							<label class="col-sm-3 control-label no-padding-right" for="language"> #getLabel("Language", #SESSION.languageId#)# </label>

							<div class="col-sm-9">
								<select name='language' class="col-xs-10 col-sm-5">
									<cfloop array=#application.ListLanguage# index="lang">
										<option value='#lang.languageId#' #lang.languageId eq SESSION.languageId ? 'selected': ''#>#lang.language#</option>
									</cfloop>
								</select>
							</div>
						</div>
						<div class="space-4 change-password hide"></div>

						<div class="form-group change-password hide">
							<label class="col-sm-3 control-label no-padding-right" for="OldPassword"> #getLabel("Old Password", #SESSION.languageId#)# </label>

							<div class="col-sm-9">
								<input type="password" name="OldPassword" id="OldPassword" placeholder="Old Password" class="col-xs-10 col-sm-5">
								<span class="help-inline col-xs-12 col-sm-7">
									<span class="middle">#getLabel("Required", #SESSION.languageId#)#</span>
								</span>
							</div>
						</div>
						<div class="space-4 change-password hide"></div>

						<div class="form-group change-password hide">
							<label class="col-sm-3 control-label no-padding-right" for="newPassword"> #getLabel("New Password", #SESSION.languageId#)# </label>

							<div class="col-sm-9">
								<input type="password" name="newPassword" id="newPassword" placeholder="New Password" class="col-xs-10 col-sm-5">
								<span class="help-inline col-xs-12 col-sm-7">
									<span class="middle">#getLabel("Insert if you want change password", #SESSION.languageId#)#</span>
								</span>
							</div>
						</div>
						<div class="space-4 change-password hide"></div>

						<div class="form-group change-password hide">
							<label class="col-sm-3 control-label no-padding-right" for="reNewPassword"> #getLabel("RePassword", #SESSION.languageId#)# </label>

							<div class="col-sm-9">
								<input type="password" name="reNewPassword" id="reNewPassword" placeholder="RePassword" class="col-xs-10 col-sm-5">
								<span class="help-inline col-xs-12 col-sm-7">
									<span class="middle">#getLabel("Insert if you want change password", #SESSION.languageId#)#</span>
								</span>
							</div>
						</div>
						<div class="space-4 change-password"></div>

						<div class="form-group change-password-btn">
							<label class="col-sm-3 control-label no-padding-right" for="change"> #getLabel("Change password", #SESSION.languageId#)# </label>

							<div class="col-sm-9">
								<label>
									<input name="changepass" id="changepass" class="ace ace-switch ace-switch-4" type="checkbox">
									<span class="lbl"></span>
								</label>
							</div>
						</div>
						<div class="space-4"></div>
						<div class="form-group">
							<label class="col-sm-3 control-label no-padding-right" for="avatar"> #getLabel("Avatar", #SESSION.languageId#)# </label>

							<div class="col-sm-9">
								<input type="file" name="avatar" id="avatar" class="col-xs-10 col-sm-5 btn-sm">
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
		</cfif>
	</div>
<script type="text/javascript">
$(document).ready(function(){
	var isChange = false ;
	$("##changepass").on('click',function(){
		isChange = $(this).is(':checked');
		if(isChange){
			$(".change-password").removeClass('hide');
		}else{
			$(".change-password").addClass('hide');
		}
	})
	$('##validation-form').on('submit',function(){
		var oldPass=$('##OldPassword').val();
		var newPass=$('##newPassword').val();
		var rePass=$('##reNewPassword').val();

		if(newPass!="" && isChange){
			var hPass=CryptoJS.MD5(oldPass).toString();
			$('##OldPassword').val(hPass);
			if(newPass != rePass){
				$('##OldPassword').val("");
				$('##newPassword').val("");
				$('##reNewPassword').val("");
				alert("RePassword wrong!");
				return false;
			}else{
				var hnPass=CryptoJS.MD5(newPass).toString();
				$('##newPassword').val(hnPass);

				var hrPass=CryptoJS.MD5(rePass).toString();
				$('##reNewPassword').val(hrPass);
				return true;
			}
			return true;
		}else{
			$('##OldPassword').val('');
			$('##newPassword').val('');
			$('##reNewPassword').val('');
			return true;
		}
	});

})
</script>
</cfoutput>
