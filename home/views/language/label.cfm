<cfoutput>
	<div class="page-header">
	<!--- <div class="row clearfix"> --->
		<!--- <div class="col-md-12" style="border-bottom:2px ##428bca solid;"> --->
			<h1 class="blue"><a href="/index.cfm/language/">#getLabel("Language", #SESSION.languageId#)#</a>
				<small>
					<i class="ace-icon fa fa-angle-double-right"></i>
					#rc.list.language# #getLabel("label management", #SESSION.languageId#)#
				</small>
				<button class="btn btn-sm btn-success pull-right" onclick="add();">
				<i class="menu-icon glyphicon glyphicon-bookmark"><span id="aLang" style="font-family: 'Open Sans';">#getLabel("Add new label", #SESSION.languageId#)#</span></i>
			</button>
			</h1>
	</div>		
		<!--- </div> --->
		<small class="">(<strong class="red">*</strong>) #getLabel("Detail have", #SESSION.languageId#)# <abbr>#getLabel("underline", #SESSION.languageId#)#</abbr> #getLabel("can be changed by click on it", #SESSION.languageId#)#.</small>
	<!--- </div> --->
	<div class="row clearfix">
		<div class="row col-md-12">
            <table id="language" class="datatable table-bordered col-md-12">
	            <thead>
					<tr>
	                    <th>&nbsp;#getLabel("Key word", #SESSION.languageId#)#</th>
	                    <th>&nbsp;#getLabel("Value", #SESSION.languageId#)#</th>
	                    <!--- <th>&nbsp;#getLabel("Language", #SESSION.languageId#)#</th> --->
	                    <th>&nbsp;#getLabel("Tags", #SESSION.languageId#)#</th>
	                    <th>&nbsp;#getLabel("Actions", #SESSION.languageId#)#</th>
	                </tr>
	            </thead>
	            <tbody id="tbLabel">
	                <cfloop query=#rc.lang# >
						<tr id="tr#rc.lang.labelId#">
	                        <td id="keyword#rc.lang.labelId#"> <abbr id="spankeyword#rc.lang.labelId#"  onClick='changekeyword("#rc.lang.labelId#")' title="Click to change key word">&nbsp;#rc.lang.keyword#</abbr><i class="ace-icon fa fa-pencil-square-o  bigger-110 icon-on-right" onClick='changekeyword("#rc.lang.labelId#")'></i>&nbsp;</td>
	                        <td id="value#rc.lang.labelId#"> <abbr id="spanvalue#rc.lang.labelId#"  onClick='changevalue("#rc.lang.labelId#")' title="Click to change value">&nbsp;#rc.lang.value#</abbr><i class="ace-icon fa fa-pencil-square-o  bigger-110 icon-on-right" onClick='changevalue("#rc.lang.labelId#")'></i>&nbsp;</td>
	                        <!--- <td class="col-md-2">
	                        	<select id="s#rc.lang.labelId#" onchange="changelanguageid(#rc.lang.labelId#)">
	                        		<cfloop query=#rc.list#>
	                        			<option value="#rc.list.languageId#" <cfif rc.list.languageId EQ rc.lang.languageId>SELECTED</cfif>>#rc.list.language#</option>
	                        			
	                        		</cfloop>
	                        	</select>
	                        </td> --->
	                        <td id="tag#rc.lang.labelId#"> <abbr id="spantag#rc.lang.labelId#"  onClick='changetag("#rc.lang.labelId#")' title="Click to change tags">&nbsp;#rc.lang.tag#</abbr><i class="ace-icon fa fa-pencil-square-o  bigger-110 icon-on-right" onClick='changetag("#rc.lang.labelId#")'></i>&nbsp;</td>
	                        <td class="col-md-1">
	                        	<div class="ui-pg-div col-md-1"><span class="ui-icon ace-icon fa fa-trash-o red" onclick="del(#rc.lang.labelId#)"></span></div>
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
		        	<h3 class="modal-title" id="myModalLabel">#getLabel("Add new label", #SESSION.languageId#)#</h3>
		      	</div>
		      	<div class="modal-body">					
					<div class="row">
			            <label class="col-md-2 control-label" for="name">#getLabel("Key word", #SESSION.languageId#)#</label>
			            <div class="col-md-10">
			                <input id="newkey" type="text" class="col-md-11">
			            </div>
		            </div>
		            <div class="row margin-top-20" id="rowResolution">
			            <label class="col-md-2 control-label" for="soSelect">#getLabel("Value", #SESSION.languageId#)#</label>
			            <div class="col-md-10">
			                <input id="newvalue" type="text" class="col-md-11">
			            </div>
		            </div>									
					<div class="row margin-top-20">
						<label class="col-md-2 control-label">#getLabel("Language", #SESSION.languageId#)#</label>
						<div class="col-md-10">
							<select id="newlangid">
	                        		<cfloop query=#rc.list#>
	                        			<option value="#rc.list.languageId#">#rc.list.language#</option>
	                        		</cfloop>
	                        	</select>
						</div>
					</div>					
		      	</div>
		      	<div class="modal-footer">
		        	<button type="button" class="btn btn-default" data-dismiss="modal">#getLabel("Close", #SESSION.languageId#)#</button>
		        	<button type="button" class="btn btn-info" onclick="addLabel();">#getLabel("Save changes", #SESSION.languageId#)#</button>
		      	</div>
		    </div>
	  	</div>
	</div>
</cfoutput>
<script type="text/javascript">
    $(document).ready(function(){
        $('#language').dataTable();
    });

    function del(id)
    {
    	if(confirm("Are you want to delete this label?"))
    	{
	    	$.ajax({
		        url: '/index.cfm/language.deletelabel',
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
		$("#aLang").text(" <cfoutput>#getLabel('Add Label', #SESSION.languageId#)#</cfoutput>");
	}
	function addNormal()
	{
		$("#aLang").text("");
	}

    function add()
    {
    	$('#addNew').modal({show:true});
    }
    function changelanguageid(id)
    {
    	var langId = $("#s"+id).val();
    	$.ajax({
		        url: '/index.cfm/language.changelanguageid',
		        method:'POST',
		        dataType: 'json',
		        data: {
		        	id: id,
		        	languageId:langId
		        }	
		    });
    }

    function addLabel()
    {
    	var newKey = $("#newkey").val();
    	var newVal = $("#newvalue").val();
    	var langId = $("#newlangid").val();
    	$.ajax({
		        url: '/index.cfm/language.addnewlabel',
		        method:'POST',
		        dataType: 'json',
		        data: {
		        	keyword : newKey,
		        	value : newVal,
		        	languageId : langId
		        },
		        success: 	function(data) {
		        		if(data.SUCCESS)
	        			{
	        				$("#tbLabel").append('\
	        					<tr id="tr'+data.LABELID+'">\
	        						<td id="keyword'+data.LABELID+'"> <abbr id="spankeyword'+data.LABELID+'" onClick="changekeyword('+data.LABELID+')" title="Click to change key word">&nbsp;'+newKey+'</abbr><i class="ace-icon fa fa-pencil-square-o  bigger-110 icon-on-right" onClick="changekeyword('+data.LABELID+')"></i>&nbsp;</td>\
	        						<td id="value'+data.LABELID+'"> <abbr id="spanvalue'+data.LABELID+'"  onClick="changevalue('+data.LABELID+')" title="Click to change value">&nbsp;'+newVal+'</abbr><i class="ace-icon fa fa-pencil-square-o  bigger-110 icon-on-right" onClick="changevalue('+data.LABELID+')"></i>&nbsp;</td>\
			                        <td id="tag'+data.labelId+'"> <abbr id="spantag'+data.labelId+'" onClick="changetag('+data.labelId+')" title="Click to change tags"> Tag here</abbr><i class="ace-icon fa fa-pencil-square-o  bigger-110 icon-on-right" onClick="changetag('+data.labelId+')"></i>&nbsp;</td>\
			                        <td class="col-md-2">\
			                        	<div class="ui-pg-div col-md-1"><span class="ui-icon ace-icon fa fa-trash-o red" onClick="del('+data.LABELID+')"></span></div>\
			                        </td>\
	        					');
								$("#newkey").val("");
								$("#newvalue").val("");
	        			}
		        	}	
		        });
    }
    

	function closeInput1(id)
	{
		var keyword = $("#input"+id).val();
		if($("#spankeyword"+id).text() != keyword){
			$("#spankeyword"+id)
				.text(keyword);
			$.ajax({
		        url: '/index.cfm/language.changekeyword',
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

	function closeInput2(id)
	{
		var value = $("#input"+id).val();
		if($("#spanvalue"+id).text() != value){
			$("#spanvalue"+id)
				.text(value);
			$.ajax({
		        url: '/index.cfm/language.changevalue',
		        method:'POST',
		        dataType: 'json',
		        data: {
		        	id: id,
		        	key:value
		        },
		        success: 	function(data) {
		        		if(data)
		        			$("#spanvalue"+id).addClass("green");
		        	}	
		        });
		    window.setTimeout(function(){$("#spanvalue"+id).removeClass("green")},2000);
		}
		$("#spanvalue"+id).removeClass("hide");
		var element = document.getElementById("input"+id);
		element.parentNode.removeChild(element);
	}

	function changevalue(id){
		var stringId = $("#spanvalue"+id).text();
		$("#spanvalue"+id).addClass("hide");
		$("#value"+id).prepend('<input id="input'+id+'" type="text" style="width:90%" onBlur="closeInput2('+id+')">');
		$("#input"+id)
			.attr('value',$("#value"+id).text().trim() )
			.focus();
	}

	function changetag(id){
		var stringId = $("#spantag"+id).text();
		$("#spantag"+id).addClass("hide");
		$("#tag"+id).prepend('<input id="input'+id+'" type="text" style="width:90%" onBlur="closeInput3('+id+')">');
		$("#input"+id)
			.attr('value',$("#tag"+id).text().trim() )
			.focus();
	}
	function closeInput3(id)
	{
		var value = $("#input"+id).val();
		if($("#spantag"+id).text() != value){
			$("#spantag"+id)
				.text(value);
			$.ajax({
		        url: '/index.cfm/language.changetag',
		        method:'POST',
		        dataType: 'json',
		        data: {
		        	id: id,
		        	key:value
		        },
		        success: 	function(data) {
		        		if(data)
		        			$("#spantag"+id).addClass("green");
		        	}	
		        });
		    window.setTimeout(function(){$("#spanvalue"+id).removeClass("green")},2000);
		}
		$("#spantag"+id).removeClass("hide");
		var element = document.getElementById("input"+id);
		element.parentNode.removeChild(element);
	}
</script>
