<!--- <cfdump eval = rc abort> --->
<style type="text/css">
    .mousechange:hover {
        cursor:pointer;
    }
</style>
<cfoutput>
<!--- <div class="page-content">
	<div class="page-content-area"> --->
		<div class="page-header">
			<h1>
				#getLabel("Company", #SESSION.languageId#)#
				<small>
					<i class="ace-icon fa fa-angle-double-right"></i>
					#getLabel("overview", #SESSION.languageId#)# &amp; #getLabel("stats", #SESSION.languageId#)#
				</small>
				<cfif SESSION.userType EQ 3>
                    <button class="btn btn-sm btn-info pull-right" onclick="add();" >
						<span id="aLang" style="font-family: 'Open Sans';">#getLabel("Add new company", #SESSION.languageId#)#</span></i>
					</button>
                </cfif>
			</h1>
		</div>
		<!--- <div id="wrapper"> --->
	       
	        <div class="row">
	            <div class="row col-lg-12">
	                <div class="wrapper wrapper-content animated fadeInUp">
	                    <div class="row ibox col-md-12">
	                        <div class="ibox-content">
	                            <div class="project-list">
	                                <table id="po" class="table table-hover datatable table-bordered">
	                                	<thead>
											<tr>
							                    <th style="width:300px;">&nbsp;#getLabel("Company", #SESSION.languageId#)#</th>
							                    <th>&nbsp;#getLabel("Project", #SESSION.languageId#)#</th>
							                    <th style="width:100px;">&nbsp;#getLabel("Tickets", #SESSION.languageId#)#</th>
							                    <th style="width:100px;">&nbsp;#getLabel("Hours", #SESSION.languageId#)#</th>
							                    <th style="width:200px;">&nbsp;#getLabel("Users", #SESSION.languageId#)#</th>
							                </tr>
							            </thead>
	                                    <tbody>
	                                    	<cfloop array=#rc.rs# index="item">
			                                    <tr>
			                                        <!--- <td class="project-status">
			                                        	<cfif item.active EQ 1>
			                                        		<span class="label label-primary">Active</span>
			                                        	<cfelse>
			                                        		<span class="label label-default">Unactive</span>
			                                        	</cfif>
			                                        </td> --->
			                                        <td>
			                                        	<a href="/index.cfm/company/detail?id=#item.companyID#&year=#dateFormat(now(),"yyyy")#">#item.companyName#</a>
			                                        	<br>
			                                            <small>- Address: #item.address#</small>
			                                            <br>
			                                            <small>- Phone number: #item.phone#</small><br>
			                                            <small>- Email: #item.email#</small><br>
			                                            <small>- Description: #item.description#</small>
			                                        </td>
			                                        <td class="project-title">
			                                        	<cfloop array=#item.project# index="prj">
			                                        		<a href="/index.cfm/project/?id=#prj.projectID#">#prj.shortName# - #prj.projectName#</a>
			                                            <cfif SESSION.userType eq 3>
                            								<a class="green" href="/index.cfm/project/form?code=#prj.code#"><abbr title="Click to edit project"></abbr> <i class="ace-icon fa fa-pencil-square-o  bigger-110 icon-on-right"></i></a>
														</cfif>
			                                            <br>
			                                        	</cfloop> 
			                                        </td>
			                                        
			                                        <td >
			                                        	<cfif item.ticket NEQ 0>
			                                        		<span class="label label-purple mousechange" style="width:80px;" title="Sum tickets of all projects">#item.ticket#</span>
			                                        	</cfif>	
			                                        </td>
			                                        <td >
			                                        	<cfif item.hour NEQ 0>
			                                        		<span class="label label-info mousechange" style="width:80px;" title="Sum hours have entered in all projects">#numberFormat(item.hour / 60,'.0')#</span>
			                                        	</cfif>
			                                        </td>
			                                       
			                                        <td class="project-people">	     	
			                                        	<cfloop array=#item.users# index="user">
			                                            	<a href="/index.cfm/user?id=#user.userID#"><img style="width:32px; height:32px;" alt="image" title="#user.name#" class="img-circle" <cfif user.avatar EQ "">src="/fileupload/avatars/full-logo.jpg"<cfelse>src="/fileupload/avatars/#user.avatar#"></cfif></a>
			                                        	</cfloop>
			                                        </td>			                                        
			                                    </tr>
			                                </cfloop>
	                                    </tbody>
	                                </table>
	                            </div>
	                        </div>
	                    </div>
	                </div>
	            </div>
	        </div>
	    <!--- </div> --->
		
	<!--- </div>
</div> --->
	<div class="modal fade" id="addNew" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	  	<div class="modal-dialog">
		    <div class="modal-content alert-info">
		      	<div class="modal-header alert-info">
		        	<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">#getLabel("Close", #SESSION.languageId#)#</span></button>
		        	<h3 class="modal-title" id="myModalLabel">#getLabel("Add new company", #SESSION.languageId#)#</h3>
		      	</div>
		      	<form id="myform">
		      	<div class="modal-body">					
					<div class="row">
			            <label class="col-md-3 control-label" for="name">#getLabel("Name", #SESSION.languageId#)#</label>
			            <div class="col-md-9">
			                <input id="name" type="text" class="col-md-11">
			            </div>
		            </div>
		            <div class="row margin-top-20" id="rowResolution">
			            <label class="col-md-3 control-label" for="soSelect">#getLabel("Address", #SESSION.languageId#)#</label>
			            <div class="col-md-9">
			                <input id="address" type="text" class="col-md-11">
			            </div>
		            </div>
		            <div class="row margin-top-20" id="rowResolution">
			            <label class="col-md-3 control-label" for="soSelect">#getLabel("Phone", #SESSION.languageId#)#</label>
			            <div class="col-md-9">
			                <input id="phone" type="text" class="col-md-11">
			            </div>
		            </div>
		            <div class="row margin-top-20" id="rowResolution">
			            <label class="col-md-3 control-label" for="soSelect">#getLabel("Email", #SESSION.languageId#)#</label>
			            <div class="col-md-9">
			                <input id="email" type="text" class="col-md-11" >
			            </div>
		            </div>	
		            <div class="row margin-top-20" id="rowResolution">
			            <label class="col-md-3 control-label" for="soSelect">#getLabel("Description", #SESSION.languageId#)#</label>
			            <div class="col-md-9">
			                <textarea id="description" name="description" class="form-control" placeholder="Description!" rows="4"></textarea>
			            </div>
		            </div>												
		      	</div>
		      	
		      	<div class="modal-footer">
		        	<button type="button" class="btn btn-default" data-dismiss="modal">#getLabel("Close", #SESSION.languageId#)#</button>
		        	<button id="btnSave" type="button" class="btn btn-info" onclick="addCompany();">#getLabel("Save changes", #SESSION.languageId#)#</button>
		      	</div>
		      	</form>
		    </div>
	  	</div>
	</div>
</cfoutput>

<script type="text/javascript">
	jQuery(function($){
		 $('#phone').on("keydown", function(event){
	    var keyCode = event.which;	 	    
	    if(!((keyCode > 47 && keyCode < 58) ||  (keyCode > 95 && keyCode < 106) ||  keyCode == 08 || ((keyCode == 16) || (keyCode == 36) || (keyCode == 37) || (keyCode == 39) || (keyCode == 35)|| (keyCode == 46)|| (keyCode == 9)|| (keyCode == 16)|| (keyCode == 13) || (keyCode == 32)|| (keyCode == 13)|| (keyCode == 110)|| (keyCode == 190))
	    	)){
		        event.preventDefault();
		    }
		});
	});
	$(document).ready(function(){
        $('#po').dataTable({
        	'iDisplayLength': 25
        });  

        
		
     //    $('#email').click(function(){
	    //     var sEmail = $('#email').val();
	    //     if ($.trim(sEmail).length == 0) {
	    //         alert('Please enter valid email address');
	    //         e.preventDefault();
	    //     }
	    //     if (validateEmail(sEmail)) {
	    //         alert('Email is valid');
	    //     }
	    //     else {
	    //         alert('Invalid Email Address');
	    //         e.preventDefault();
	    //     }
	    // });

    });

    function add()
	{
		$('#addNew').modal({show:true});
	}

	function addCompany()
	{
		$.ajax({
	        url: '/index.cfm/company.addCompany',
	        method:'POST',
	        dataType: 'json',
	        data: {
	        	cname : $('#name').val(),
	        	caddress : $('#address').val(),
	        	cphone : $('#phone').val(),
	        	cemail: $('#email').val(),
	        	cdescription: $('#description').val()
	        },
	        success: 	function(data) {
        		location.reload();
        	}
		});
	}
	

</script>

