<cfoutput>
<article class="col-sm-12 col-md-12 col-lg-12">

	<div class="jarviswidget" id="wid-id-4" data-widget-editbutton="false" data-widget-custombutton="false">
		<header>
			<span class="widget-icon"> <i class="fa fa-edit"></i> </span>
			<h2>Add Holiday</h2>				
			
		</header>
		<div>
			<div class="jarviswidget-editbox">
				
			</div>
			<div class="widget-body no-padding">
				
				<form id="smart-form-register" class="smart-form" method="POST">
					<input type="hidden" value="0" name="userId" id="userId">
					<fieldset>
						<div class="row">
							<section class="col col-6">
								<label class="input"> <i class="icon-append fa fa-user"></i>
									<input type="text" name="title" id="title" placeholder="Title">
									<b class="tooltip tooltip-bottom-right">Needed to enter the website</b> </label>
							</section>
						</div>

						<section>
							<label>More days:</label>
							<span class="onoffswitch col-col-2">
								<input type="checkbox" name="onoffswitch" class="onoffswitch-checkbox" id="show-tabs" checked="checked">
								<label class="onoffswitch-label" for="show-tabs"> 
									<span class="onoffswitch-inner" data-swchon-text="Yes" data-swchoff-text="No"></span> 
									<span class="onoffswitch-switch"></span> 
								</label> 
							</span>
						</section>
						
						<div id="oneDay" class="row hide">
							<section class="col col-6">
								<label class="input"> <i class="icon-append fa fa-calendar"></i>
									<input type="text" name="mydate" placeholder="Select a date" class="form-control datepicker" data-dateformat="dd/mm/yy">
									<b class="tooltip tooltip-bottom-right">Needed to enter the website</b> </label>
							</section>
						</div>

						<div id="moreDay" class="row">
							<section class="col col-6">
								<label class="input"> <i class="icon-append fa fa-calendar"></i>
									<input class="form-control" type="text" name="daterangepicker" id="id-date-range-picker-1" placeholder="Select date range"/>
									<b class="tooltip tooltip-bottom-right">Needed to enter the website</b> </label>
							</section>
						</div>

					</fieldset>

					<footer>
						<button type="submit" class="btn btn-primary">
							Submit
						</button>
					</footer>
				</form>						
				
			</div>
			<!-- end widget content -->
			
		</div>
		<!-- end widget div -->
		
	</div>
	<!-- end widget -->						


</article>
<script type="text/javascript">
	$(document).ready(function(){	
		// Notification
		
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

		// datePicker Define
		
		$('input[name=daterangepicker]').daterangepicker({
			'applyClass' : 'btn-sm btn-success',
			'cancelClass' : 'btn-sm btn-default',
			format: 'DD/MM/YYYY',
			locale: {
				applyLabel: 'Apply',
				cancelLabel: 'Cancel',
			}
		})


		$('##show-tabs').click(function() {
			$this = $(this);
			if($this.prop('checked')){
				$("##oneDay").addClass("hide");
				$("##moreDay").removeClass("hide");
			} else {
				$("##oneDay").removeClass("hide");
				$("##moreDay").addClass("hide");
			}
		});

		var $registerForm = $("##smart-form-register").validate({
	
				// Rules for form validation
				rules : {
					title : {
						required : true
					}
				},
	
				// Messages for form validation
				messages : {
					name : {
						required : 'Please select name of employer'
					}
				},
				// Do not change code below
				errorPlacement : function(error, element) {
					error.insertAfter(element.parent());
				}
			});
	})
</script>
</cfoutput>