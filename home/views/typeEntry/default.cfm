<cfoutput>
	<!--- <div class="row clearfix"> --->
	<div class="page-header">
		<!--- <div class="col-md-12" style="border-bottom:2px ##428bca solid;"> --->
		<h1 class="blue">#getLabel("Type Time Entries", #SESSION.languageId#)#
			<button class="btn btn-sm btn-success pull-right" onclick="add();">
				<span id="aLang" style="font-family: 'Open Sans';">Add new keyword</span>
			</button>
		</h1>			
		<!--- </div> --->
	</div>
		<small class="">(<strong class="red">*</strong>) #getLabel("Detail have", #SESSION.languageId#)# <abbr>#getLabel("underline", #SESSION.languageId#)#</abbr> #getLabel("can be changed by click on it", #SESSION.languageId#)#.</small>
	<!--- </div> --->
	<div class="row clearfix">
		<div class="row col-md-12">
            <table id="typeEntries" class="datatable table-bordered col-md-12">
	            <thead>
					<tr>
	                    <th>&nbsp;#getLabel("type name", #SESSION.languageId#)#</th>
	                    <th>&nbsp;#getLabel("root", #SESSION.languageId#)#</th>
	                    <th>&nbsp;#getLabel("action", #SESSION.languageId#)#</th>
	                </tr>
	            </thead>
	            <tbody id="tbLabel">
	                <cfloop query=#rc.list# >
						<tr id="tr#rc.list.typeTimeEntriesID#">
	                        <td id="keyword#rc.list.typeTimeEntriesID#"> <abbr id="spankeyword#rc.list.typeTimeEntriesID#"  onClick='changekeyword("#rc.list.typeTimeEntriesID#")' title="Click to change key word">&nbsp;#rc.list.typeName#</abbr><i class="ace-icon fa fa-pencil-square-o  bigger-110 icon-on-right" onClick='changekeyword("#rc.list.typeTimeEntriesID#")'></i>&nbsp;</td>
	                        
	                        <td class="col-md-2">
	                        	<select id="s#rc.list.typeTimeEntriesID#" onchange="changerootid(#rc.list.typeTimeEntriesID#)">
	                        			<option value="0" <cfif rc.listR.typeTimeEntriesID EQ rc.list.parent>SELECTED</cfif>>Root</option>

	                        		<cfloop query=#rc.listR#>
	                        			<option value="#rc.listR.typeTimeEntriesID#" <cfif rc.listR.typeTimeEntriesID EQ rc.list.parent>SELECTED</cfif>>#rc.listR.typeName#</option>
	                        			
	                        		</cfloop>
	                        	</select>
	                        </td>
	                        <td class="col-md-1">
	                        	<div class="ui-pg-div col-md-1"><span class="ui-icon ace-icon fa fa-trash-o red" onclick="del(#rc.list.typeTimeEntriesID#)"></span></div>
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
		        	<h3 class="modal-title" id="myModalLabel">#getLabel("Add new keyword", #SESSION.languageId#)#</h3>
		      	</div>
		      	<div class="modal-body">					
					<div class="row">
			            <label class="col-md-2 control-label" for="name">#getLabel("Key word", #SESSION.languageId#)#</label>
			            <div class="col-md-10">
			                <input id="newkey" type="text" class="col-md-11">
			            </div>
		            </div>									
					<div class="row margin-top-20">
						<label class="col-md-2 control-label">#getLabel("Root", #SESSION.languageId#)#</label>
						<div class="col-md-10">
							<select id="newrootid">
								<option value="0">Root</option>
	                        		<cfloop query=#rc.listR#>
	                        			<option value="#rc.listR.typeTimeEntriesID#">#rc.listR.typeName#</option>
	                        		</cfloop>
	                        	</select>
						</div>
					</div>					
		      	</div>
		      	<div class="modal-footer">
		        	<button type="button" class="btn btn-default" onclick="dclose();">#getLabel("Close", #SESSION.languageId#)#</button>
		        	<button type="button" class="btn btn-info" onclick="addLabel();">#getLabel("Save changes", #SESSION.languageId#)#</button>
		      	</div>
		    </div>
	  	</div>
	</div>
</cfoutput>
<script type="text/javascript">
    $(document).ready(function(){
        $('#typeEntries').dataTable();
    });

    function del(id)
    {
    	if(confirm("Are you want to delete this keyword?"))
    	{
	    	$.ajax({
		        url: '/index.cfm/typeEntry.deletelabel',
		        method:'POST',
		        dataType: 'json',
		        data: {
		        	labelId : id
		        },
		        success: 	function(data) {
	        		if(data)
        			{
        				$("#tr"+id).remove();
        			}
	        	}	
			});
    	}
    }

    function addBig()
	{
		$("#aLang").text(" <cfoutput>#getLabel('Add Keyword', #SESSION.languageId#)#</cfoutput>");
	}
	function addNormal()
	{
		$("#aLang").text("");
	}

    function add()
    {
    	$('#addNew').modal({show:true});
    }
    function changerootid(id)
    {
    	var rootId = $("#s"+id).val();
    	$.ajax({
		        url: '/index.cfm/typeEntry.changerootid',
		        method:'POST',
		        dataType: 'json',
		        data: {
		        	id: id,
		        	root:rootId
		        }	
		    });
    }

    function addLabel()
    {
    	var newKey = $("#newkey").val();
    	var rootId = $("#newrootid").val();
    	$.ajax({
	        url: '/index.cfm/typeEntry.addnewlabel',
	        method:'POST',
	        dataType: 'json',
	        data: {
	        	keyword : newKey,
	        	root : rootId
	        },
	        success: 	function(data) {
	        		if(data.SUCCESS)
        			{
        				$("#tbLabel").append('\
        					<tr id="tr'+data.LABELID+'">\
        						<td id="keyword'+data.LABELID+'"> <abbr id="spankeyword'+data.LABELID+'" onClick="changekeyword('+data.LABELID+')" title="Click to change key word">&nbsp;'+newKey+'</abbr><i class="ace-icon fa fa-pencil-square-o  bigger-110 icon-on-right" onClick="changekeyword('+data.LABELID+')"></i>&nbsp;</td>\
        						<td class="col-md-2">\
		                        	<select id="s'+data.LABELID+'" onchange="changerootid('+data.LABELID+')">\
		                        		<option value="0">Root</option>\
		                        	</select>\
		                        </td>\
		                        <td class="col-md-2">\
		                        	<div class="ui-pg-div col-md-1"><span class="ui-icon ace-icon fa fa-trash-o red" onClick="del('+data.LABELID+')"></span></div>\
		                        </td>\
        					');
							$("#newkey").val("");
        			}
	        	}	
	        });
    }
    
    function dclose()
    {
    	window.location = "/index.cfm/typeEntry";
    }
	function closeInput1(id)
	{
		var keyword = $("#input"+id).val();
		if($("#spankeyword"+id).text() != keyword){
			$("#spankeyword"+id)
				.text(keyword);
			$.ajax({
		        url: '/index.cfm/typeEntry.changekeyword',
		        method:'POST',
		        dataType: 'json',
		        data: {
		        	id: id,
		        	key:keyword
		        },
		        success: 	function(data) {
		        		if(data)
		        			$("#spankeyword"+id).addClass("green");
		        	}	
		        });
		    window.setTimeout(function(){$("#spankeyword"+id).removeClass("green")},2000);
		}
		$("#spankeyword"+id).removeClass("hide");
		var element = document.getElementById("input"+id);
		element.parentNode.removeChild(element);
	}

	function changekeyword(id){
		var stringId = $("#spankeyword"+id).text();
		$("#spankeyword"+id).addClass("hide");
		$("#keyword"+id).prepend('<input id="input'+id+'" type="text" style="width:90%" onBlur="closeInput1('+id+')">');
		$("#input"+id)
			.attr('value',$("#keyword"+id).text().trim() )
			.focus();
	}
</script>
