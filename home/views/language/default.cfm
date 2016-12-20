<cfoutput>
	<div class="page-header">
		<!--- <div class="col-md-12" style="border-bottom:2px ##428bca solid;"> --->
		<h1 class="blue">#getLabel("Language", #SESSION.languageId#)#
			<button class="btn btn-sm btn-success pull-right" onclick="add();" >
				<span id="aLang" style="font-family: 'Open Sans';">#getLabel("Add new language", #SESSION.languageId#)#</span></i>
			</button>
		</h1>
		<!--- </div> --->
	</div>
	<div class="row clearfix" style="margin-top:20px;">
		<div class="row col-md-12">
            <table id="language" class="datatable table-bordered col-md-12">
	            <thead>
					<tr>
	                    <th>&nbsp;#getLabel("Short name", #SESSION.languageId#)#</th>
	                    <th>&nbsp;#getLabel("Language", #SESSION.languageId#)#</th>
	                    <th>&nbsp;#getLabel("Default", #SESSION.languageId#)#</th>
	                    <th>&nbsp;#getLabel("Action", #SESSION.languageId#)#</th>
	                </tr>
	            </thead>
	            <tbody id="tbLang">
	                <cfloop query=#rc.list# >
						<tr >
							<td>&nbsp;#rc.list.shortlanguage#</td>
							<td><a href="/index.cfm/language/label?id=#rc.list.languageId#">&nbsp;#rc.list.language#</a></td>
							<td>&nbsp;#rc.list.defaultlanguage#</td>
							<td class="col-md-1">
								<button class="btn btn-sm" onclick="missingKey(#rc.list.languageId#)">
	                        		Auto fill
	                        	</button>
	                        </td>
						</tr>
	                </cfloop>
	            </tbody>
	        </table>
	    </div>
	</div>
	<div class="modal fade" id="addNew" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	  	<div class="modal-dialog">
		    <div class="modal-content alert-info">
		      	<div class="modal-header alert-info">
		        	<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">#getLabel("Close", #SESSION.languageId#)#</span></button>
		        	<h3 class="modal-title" id="myModalLabel">#getLabel("Add new language", #SESSION.languageId#)#</h3>
		      	</div>
		      	<div class="modal-body">					
					<div class="row">
			            <label class="col-md-3 control-label" for="name">#getLabel("Short name", #SESSION.languageId#)#</label>
			            <div class="col-md-9">
			                <input id="shortname" type="text" class="col-md-11">
			            </div>
		            </div>
		            <div class="row margin-top-20" id="rowResolution">
			            <label class="col-md-3 control-label" for="soSelect">#getLabel("Language", #SESSION.languageId#)#</label>
			            <div class="col-md-9">
			                <input id="languageq" type="text" class="col-md-11">
			            </div>
		            </div>														
		      	</div>
		      	<div class="modal-footer">
		        	<button type="button" class="btn btn-default" data-dismiss="modal">#getLabel("Close", #SESSION.languageId#)#</button>
		        	<button type="button" class="btn btn-info" onclick="addlanguage();">#getLabel("Save changes", #SESSION.languageId#)#</button>
		      	</div>
		    </div>
	  	</div>
	</div>
</cfoutput>
<script type="text/javascript">
	$(document).ready(function(){
        $('#language').dataTable();
    });

	function add()
	{
		$('#addNew').modal({show:true});
	}

	function addlanguage()
	{
		$.ajax({
	        url: '/index.cfm/language.addLanguage',
	        method:'POST',
	        dataType: 'json',
	        data: {
	        	shortname : $('#shortname').val(),
	        	languagename : $('#languageq').val()
	        },
	        success: 	function(data) {
        		location.reload();
        	}
		});
	}

	function missingKey(id)
	{
    	if(confirm("Do you want to auto create all label for this language?"))
    	{
	    	$.ajax({
		        url: '/index.cfm/language.autofill',
		        method:'POST',
		        dataType: 'json',
		        data: {
		        	language : id
		        },
		        success: 	function(data) {
	        		window.location = '/index.cfm/language/label?id='+id;
	        	}	
			});
    	}
	}
</script>