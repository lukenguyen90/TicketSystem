<cfoutput>
<div class="row clearfix">
	<div class="col-md-12" style="border-bottom:2px ##428bca solid;">
		<div class="row">
			<h1 class="blue col-md-8">
			<a href="/index.cfm/project?pId=#rc.thisProject.projectID#" data-toggle="dropdown" class="dropdown-toggle green" title="Click to change Project!" >
				#rc.thisProject.projectName# <small><i class="fa fa-sort-desc"></i></small>
			</a>
			<ul class="dropdown-menu dropdown-yellow dropdown-caret " >
		   		<cfloop query="rc.projects">
					<cfif rc.thisProject.projectID NEQ rc.projects.projectID>
					<li>
	            		<a href="/index.cfm/project/versions/?pId=#rc.projects.projectID#" onClick="changeProject('#rc.projects.projectID#')">
	          				#rc.projects.projectName#
	            		</a>
	            	</li>
					</cfif>
				</cfloop>
        	</ul>
        	<small>#getLabel("versions", #SESSION.languageId#)#</small></h1>
			<cfif SESSION.userType eq 3 OR rc.thisProject.projectLeadID eq SESSION.userID>
			<button class="btn btn-sm btn-success pull-right" style="margin-top:24px" id="btn-show" onClick="toggleForm()">#getLabel("Version", #SESSION.languageId#)#Up </button>
			</cfif>
		</div>
	</div>
</div>
<div class="row clearfix" style="margin-top:20px;border-bottom:2px ##428bca solid;display:none" id="formUpVer">
	<div class="col col-md-12">
		<form class="form-horizontal" role="form" method="post" enctype="multipart/form-data" id='myform'>
		<div class="form-group">
			<div class="col-md-3"> 
				<div class="form-group">
					<label class="col-xs-12 col-md-12">#getLabel("Name of Version", #SESSION.languageId#)#</label>
					<input type="text" name="name" id="name" class="col-xs-12 col-md-12" value="#rc.oldVersion.versionName#" />
				</div>
				<div class="form-group">
					<label class="col-xs-12 col-md-12">#getLabel("Number of Version", #SESSION.languageId#)#</label>
					<input type="text" name="number" id="number" class="col-xs-12 col-md-12" />
				</div>
				<div class="form-group">
					<label>Current version: #rc.oldVersion.versionName# #rc.oldVersion.versionNumber# : date update #rc.oldVersion.date#</label>
				</div>
				<div class="form-group">
					<button class="btn btn-success pull-right">#getLabel("Up Version", #SESSION.languageId#)#</button>
				</div>
			</div>
			<div class="col-md-9">
				<label>#getLabel("Detail Version", #SESSION.languageId#)#</label>
				<div id="editor" class="wysiwyg-editor" ></div>
				<input type="hidden" name="detail" id='detail'value=" "/>
			</div>
		</div>	
		</form>
	</div>
</div>
<div class="rơ clearfix" id="contain-list-versions">
	<div class="col col-md-12">
		<h3>#getLabel("Current Version", #SESSION.languageId#)# <span class="blue">#rc.oldVersion.versionName# #rc.oldVersion.versionNumber#</span>: <small>#rc.oldVersion.date#</small></h3>
	</div>
	<div class="col-md-12">
		<div class="row">
			<div class="col-md-2">
			</div>
			<div class="col-md-9">
			#rc.oldVersion.detail#
			</div>
		</div>
		<div class="hr dotted"></div>
	</div>
</div>
<a style='cursor:pointer' onClick='loadMore()' id='moreVersion'>#getLabel("View more old version", #SESSION.languageId#)# </a>
<cfif structKeyExists(rc, "thisProject")>
	<script type="text/javascript">
		$("##selectProject").find('option[value=#rc.thisProject.projectID#]').attr('selected','selected');
	</script>
</cfif>
<script type="text/javascript">
	var projectID=#rc.thisProject.projectID#;
</script>
</cfoutput>
<script type="text/javascript">
	var number=1;
	function loadMore(){
		if(number == -1){
			$('#moreVersion').addClass('hide');
		}else{
			$.ajax({
				url: '/index.cfm/project.getMoreVersion',
				method:'POST',
				dataType: 'json',
				data: {
					project: projectID,
					number:number
				},
				success: 	function(data) {
					if(data==true){
						number=-1;
						$('#moreVersion').addClass('hide');
					}else{
						$('#contain-list-versions').append('\
							<div class="col col-md-12">\
								<h3>Old Version \
									<span class="blue">\
										'+data.NAME+' '+data.NUMBER+'\
									</span>:\
									<small>'+data.DATE+'\
									</small>\
								</h3>\
							</div>\
							<div class="col-md-12">\
								<div class="row">\
									<div class="col-md-2">\
									</div>\
									<div class="col-md-9">\
									'+data.DETAIL+'\
									</div>\
								</div>\
								<div class="hr dotted"></div>\
							</div>');
						number++;
					}
				}
			});
		}
	}
	function toggleForm(){
		$("#formUpVer").toggle("slow");
		$("#btn-show").toggleClass("btn-success").toggleClass("btn-gray");
		$("#btn-show").text($("#btn-show").text()=="Up Version" ? "Hide Form" : "Up Version");
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
			$('#detail').val($('#editor').html());	
			$(this).submit();
		});
		$('#myform').on('reset', function() {
			$('#editor').empty();
		});		
	});
</script>