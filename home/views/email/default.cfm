<style type="text/css">
.wysiwyg-editor{
	min-height:500px;
	overflow-x: scroll;
}
</style>
<cfif SESSION.userType eq 3>
<cfoutput>
	<div class="row clearfix">
		<div class="col-md-12" style="border-bottom:2px ##428bca solid;">
			<h1 class="blue">#getLabel("Email", #SESSION.languageId#)#:<small>#getLabel("Edit Templates", #SESSION.languageId#)#</small>
				<div class="col-md-4" style="float: right; margin-right:10px;">
					<div class="col-md-8 pull-right">	
						<select id="type" class="form-control"  style="height:34px; width: 200px;" onChange='changeOption()'>
							<cfloop query=#rc.listOption#>
								<option value="#rc.listOption.emailID#">#rc.listOption.emailKey#</option>
							</cfloop>
						</select>	
					</div>				
				</div>
			</h1>
		</div>
	</div>
	<div class="row clearfix" style="margin-top:20px;">
		<form method="POST" id="myform">
		<div class="col col-md-10">
			<div class="row"><span class="col-md-12"><b>#rc.type.description#</b></span></div>
			<div class="row">
				<h4 class="col-md-4">#getLabel("Subject Email", #SESSION.languageId#)#</h4>
				<input type="text" name="subject" class="col-md-8" value='#rc.type.subject#'>
			</div>
			<div id="editor" class="wysiwyg-editor" >#rc.type.container#</div>
			<input type="hidden" name="contain" id='contain'value=""/>
		</div>
		<div class="col col-md-2">
			<button class="btn btn-success" type="submit">#getLabel("Save", #SESSION.languageId#)#</button>
			<h3>#getLabel("Variables", #SESSION.languageId#)#</h3>
			<ol>
				<li><span class="blue">$ticketLink$</span>: #getLabel("link to ticket", #SESSION.languageId#)#</li>
				<li><span class="blue">$ticketCode$</span>: #getLabel("code of ticket", #SESSION.languageId#)#</li>
				<li><span class="blue">$ticketTitle$</span>: #getLabel("title of ticket", #SESSION.languageId#)#</li>
				<li><span class="blue">$projectLink$</span>: #getLabel("link to project", #SESSION.languageId#)#</li>
				<li><span class="blue">$projectName$</span>: #getLabel("name of project", #SESSION.languageId#)#</li>
				<li><span class="blue">$changeComment$</span>: #getLabel("comment of user when change", #SESSION.languageId#)# <span class="red">(not have in "new")</span></li>
				<li><span class="blue">$ticketEstimate$</span>: #getLabel("estimate of ticket", #SESSION.languageId#)# <span class="red">(not have in "new","change assignee")</span></li>
				<li><span class="blue">$totalEstimate$</span>: #getLabel("total hours user enter in ticket", #SESSION.languageId#)# <span class="red">(not have in "new","change assignee")</span></li>
				<cfif rc.type.emailKey eq 'new'>
				<li><span class="blue">$createdUser$</span>: #getLabel("is user created this ticket", #SESSION.languageId#)#</li>
				</cfif>
			</ol>
		</div>
		</form>
	</div>
	<cfif structKeyExists(URL,"t")>
		<script type="text/javascript">
			$("##type").find('option[value=#URL.t#]').attr('selected','selected');
		</script>
	</cfif>
</cfoutput>
<script type="text/javascript">
	function changeOption(){
		window.location="/index.cfm/email?t="+$("#type").val();
	}
	jQuery(function($) {
		$('#editor').ace_wysiwyg({
			toolbar:
			[
				
				{
					name:'fontSize',
					title:'Custom tooltip',
					values:{1 : 'Size#1 Text' , 2 : 'Size#1 Text' , 3 : 'Size#3 Text' , 4 : 'Size#4 Text' , 5 : 'Size#5 Text'} 
				},
				null,
				{name:'bold', title:'Custom tooltip'},
				{name:'italic', title:'Custom tooltip'},
				{name:'strikethrough', title:'Custom tooltip'},
				{name:'underline', title:'Custom tooltip'},
				null,
				'insertunorderedlist',
				'insertorderedlist',
				'outdent',
				'indent',
				null,
				
				{
					name:'createLink',
					placeholder:'Custom PlaceHolder Text',
					button_class:'btn-purple',
					button_text:'Custom TEXT'
				},
				{name:'unlink'},
				
				{name:'undo'},
				{name:'redo'},
				null,
				'viewSource'
			],
			//speech_button:false,//hide speech button on chrome
			
			'wysiwyg': {
				hotKeys : {} //disable hotkeys
			}
			
		}).prev().addClass('wysiwyg-style2');
		$('#myform').on('submit', function() {
			$('#contain').val($('#editor').html());	
			$(this).submit();
		});	
	});
</script>
<cfelse>
<div class="alert alert-warning">
	#getLabel("Page not found!", #SESSION.languageId#)#
</div>
</cfif>
