<cfoutput>
	<div class="main-content">
		<div class="row">
			<div class="col-sm-10 col-sm-offset-1">
				<div class="login-container">
					<div class="center">
						<img src="/images/gallery/logo.png" width="400">
						<h4 class="blue" id="id-company-text"></h4>
					</div>

					<div class="space-6"></div>

					<div class="position-relative">
						<div id="login-box" class="login-box visible widget-box no-border">
							<div class="widget-body">
								
								<div class="widget-main">
									<h4 class="header blue lighter bigger">
										<i class="ace-icon glyphicon glyphicon-user blue"></i>
																				
									</h4>
									<cfif structKeyExists(rc,"mess")>
										<div class="alert alert-danger" id="message">#rc.mess#
										</div>
									</cfif>
									<form class="form-horizontal" id="validation-form" method="post"enctype="multipart/form-data">
										<fieldset>
										<div class="form-group">
											<label class="block clearfix">
												<span class="block input-icon input-icon-right">
													<input type="text" class="form-control" placeholder="User Name or Email" name="username" id="username"/>
													<i class="ace-icon fa fa-user"></i>
												</span>
											</label>
										</div>
										<div class="form-group">
											<label class="block clearfix">
												<span class="block input-icon input-icon-right">
													<input type="password" class="form-control" placeholder="password" name="password" id="password"/>
													<i class="ace-icon fa fa-lock"></i>
												</span>
											</label>
										</div>

											<div class="space"></div>

											<div class="clearfix">
												<a href="/index.cfm/login:main.register">Register</a>
												<button type="" class="width-35 pull-right btn btn-sm btn-primary" id="submit">
													<i class="ace-icon fa fa-key"></i>Login
													<span class="bigger-110"></span>
												</button>
											</div>
											<div class="space-4"></div>
										</fieldset>
									</form>

								</div>
							</div>
						</div>
					</div>

					<div class="navbar-fixed-top align-right">
						<br />
						&nbsp;
						<a id="btn-login-dark" href="##">Dark</a>
						&nbsp;
						<span class="blue">/</span>
						&nbsp;
						<a id="btn-login-blur" href="##">Blur</a>
						&nbsp;
						<span class="blue">/</span>
						&nbsp;
						<a id="btn-login-light" href="##">Light</a>
						&nbsp; &nbsp; &nbsp;
					</div>
				</div>
			</div>
		</div>
	</div>
		<!--[if !IE]> -->
		<script type="text/javascript">
			window.jQuery || document.write("<script src='/ACEAdmin/assets/js/jquery.min.js'>"+"<"+"/script>");
		</script>
		<script src="/ACEAdmin/assets/js/jquery.validate.min.js"></script>
		<script src="/ACEAdmin/assets/js/additional-methods.min.js"></script>
		<script src="/ACEAdmin/assets/js/bootbox.min.js"></script>
		<script src="/ACEAdmin/assets/js/jquery.maskedinput.min.js"></script>
		<script src="/ACEAdmin/assets/js/select2.min.js"></script>

		<!-- ace scripts -->
		<script src="/ACEAdmin/assets/js/ace-elements.min.js"></script>
		<script src="/ACEAdmin/assets/js/ace.min.js"></script>

		<!-- inline scripts related to this page -->
		<script type="text/javascript">
			jQuery(function($) {	
			
				$('##validation-form').validate({
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
							
						}
					},
			
					messages: {
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
			$('##validation-form').on('submit',function(){
				if($('##validation-form').valid()){
					var oldPass=$('##password').val();
					var hPass=CryptoJS.MD5(oldPass).toString();
					$('##password').val(hPass);
					return true;
				}else{
					return false;
				}
			});
		</script>
		<link rel="stylesheet" href="/ACEAdmin/assets/css/ace.onpage-help.css" />
		<link rel="stylesheet" href="/ACEAdmin/docs/assets/js/themes/sunburst.css" />

		<script type="text/javascript"> ace.vars['base'] = '..'; </script>
		<script src="/ACEAdmin/assets/js/ace/ace.onpage-help.js"></script>
		<script src="/ACEAdmin/docs/assets/js/rainbow.js"></script>
		<script src="/ACEAdmin/docs/assets/js/language/generic.js"></script>
		<script src="/ACEAdmin/docs/assets/js/language/html.js"></script>
		<script src="/ACEAdmin/docs/assets/js/language/css.js"></script>
		<script src="/ACEAdmin/docs/assets/js/language/javascript.js"></script>

</cfoutput>