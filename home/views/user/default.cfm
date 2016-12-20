<cfif structKeyExists(rc,"user")>
	<cfset thisUserNotification=rc.user.levelNotification eq ""?1:rc.user.levelNotification>
<cfoutput>
	<div class="page-header">			
		<h1>#getLabel("User", #SESSION.languageId#)#
			<small>
				<i class="ace-icon fa fa-angle-double-right"></i>
				#getLabel("Profile", #SESSION.languageId#)#
				
			</small>
			<cfif structKeyExists(rc,"users")>
				<div class="col-md-4" style="float: right;">
					<div class="col-md-2 pull-right">
						<a href="/index.cfm/user" class="btn btn-sm pull-right">
							<i class="menu-icon fa fa-list"></i>
						</a>
						<!--- <button class="btn btn-sm btn-info" onclick="addCompany();">
							<i class="menu-icon fa fa-home"><span id="aProject" style="font-family: 'Open Sans';"> #getLabel("New company", #SESSION.languageId#)#</span></i>
						</button> --->
					</div>	
					<div class="col-md-8 pull-right">	
						<form action="">
							<select id="selectUser" class="form-control pull-right" onchange='selectProgrammerChange()'>
		              			<option value=0 >#getLabel("Select User", #SESSION.languageId#)#</option>
		              			<cfloop query=#rc.users#>
		              				<cfif rc.users.type eq "Programmer">
		                				<option value=#rc.users.userID# <cfif URL.id eq rc.users.userID>selected</cfif> >#rc.users.firstname# #rc.users.lastname#</option>
		                			</cfif>
		              			</cfloop>
		            		</select>
						</form>	
					</div>										
				</div> 
			</cfif>
		</h1>
	</div>
	<div class="row clearfix" style="margin-top:20px;">
		<div class="row">
		<div class="col-xs-12">
			<div>
				<div id="user-profile-1" class="user-profile row">
					<div class="col-xs-12 col-sm-3 center">
						<div>
							<!--- <span class="profile-picture img-circle" style="width:250px; height:250px;"> --->
								<img id="avatar" style="width:200px; height:200px; left:0; right:0; margin:auto;" class="editable img-responsive img-circle" alt="#rc.user.firstname#'s Avatar" <cfif rc.user.avatar EQ "">src="/fileupload/avatars/default.jpg"<cfelse>src="/fileupload/avatars/#rc.user.avatar#"</cfif>/>
							<!--- </span> --->
							
							<div class="space-4"></div>

							<div class="width-80 label label-info label-xlg arrowed-in arrowed-in-right">
								<div class="inline position-relative">
									<a href="" class="user-title-label dropdown-toggle" data-toggle="dropdown">
										<i class="ace-icon fa fa-circle light-green"></i>
										&nbsp;
										<span class="white">#rc.user.firstname# #rc.user.lastname#</span>
									</a>
								</div>
							</div>
						</div>

						<div class="space-6"></div>
						<div class="profile-contact-info">
							<div class="profile-contact-links align-left">
								<a href="" class="btn btn-link">
									<i class="ace-icon fa fa-plus-circle bigger-120 green"></i>
									#rc.user.type#
								</a>

								<a href="" class="btn btn-link">
									<i class="ace-icon fa fa-envelope bigger-120 pink"></i>
									#rc.user.email#
								</a>

								<a href="" class="btn btn-link">
									<i class="ace-icon fa fa-globe bigger-125 blue"></i>
									www.rasia.info
								</a>
							</div>

							<div class="space-6"></div>

							<div class="profile-social-links align-center">
								<a href="" class="tooltip-info" title="" data-original-title="Visit my Facebook">
									<i class="middle ace-icon fa fa-facebook-square fa-2x blue"></i>
								</a>

								<a href="" class="tooltip-info" title="" data-original-title="Visit my Twitter">
									<i class="middle ace-icon fa fa-twitter-square fa-2x light-blue"></i>
								</a>

								<a href="" class="tooltip-error" title="" data-original-title="Visit my Pinterest">
									<i class="middle ace-icon fa fa-pinterest-square fa-2x red"></i>
								</a>
							</div>
						</div>

						<div class="hr hr16 dotted"></div>
					</div>

					<div class="col-xs-12 col-sm-9">
						<div class="center">
							<span class="btn btn-app btn-sm btn-success no-hover" onClick='changePage("profile")'>
								<span class="line-height-1 bigger-170">#getLabel("User", #SESSION.languageId#)#</span>
								<br />
								<span class="line-height-1 smaller-90"> #getLabel("Profile", #SESSION.languageId#)# </span>
							</span>
							<span class="btn btn-app btn-sm btn-light no-hover" onClick="changePage('projects')">
								<span class="line-height-1 bigger-170 blue"> #rc.user.projects# </span>
								<br />
								<span class="line-height-1 smaller-90"> #getLabel("Projects", #SESSION.languageId#)#</span>
							</span>
							<span class="btn btn-app btn-sm btn-yellow no-hover" onClick="changePage('assigned')">
								<span class="line-height-1 bigger-170"> #rc.user.assigned# </span>
								<br />
								<span class="line-height-1 smaller-90"> #getLabel("Assigned", #SESSION.languageId#)# </span>
							</span>
							<span class="btn btn-app btn-sm btn-pink no-hover" onClick="changePage('reported')">
								<span class="line-height-1 bigger-170"> #rc.user.reported# </span>
								<br />
								<span class="line-height-1 smaller-90"> #getLabel("Reported", #SESSION.languageId#)# </span>
							</span>
							<span class="btn btn-app btn-sm btn-grey no-hover" onClick="changePage('comments')">
								<span class="line-height-1 bigger-170"> #rc.user.comments# </span>
								<br />
								<span class="line-height-1 smaller-90"> #getLabel("Comments", #SESSION.languageId#)# </span>
							</span>
							<span class="btn btn-app btn-sm btn-primary no-hover" onClick="changePage('hours')">
								<span class="line-height-1 bigger-170"><cfif rc.user.hours eq "">0</cfif> #rc.user.hours# </span>
								<br />
								<span class="line-height-1 smaller-90"> #getLabel("Hours", #SESSION.languageId#)# </span>
							</span>
						</div>
						<div class="space-12"></div>
						<div class="widget-header widget-header-small">
							<h4 class="widget-title blue smaller">
								<i class="ace-icon fa fa-rss orange"></i>
								<span id='listTitle'>#getLabel("#rc.title#", #SESSION.languageId#)#</span>
							</h4>
						</div>
						<div class="profile-user-info profile-user-info-striped hide" id="lists"></div>
					<div id="profile">
						<div class="profile-user-info profile-user-info-striped">
							<div class="profile-info-row">
								<div class="profile-info-name"> #getLabel("Fullname", #SESSION.languageId#)# </div>

								<div class="profile-info-value">
									<span class="editable" id="username">
										#rc.user.firstname#&nbsp;#rc.user.lastname#
									</span>
								</div>
							</div>
							<div class="profile-info-row">
								<div class="profile-info-name"> #getLabel("username", #SESSION.languageId#)# </div>

								<div class="profile-info-value">
									<span class="editable" id="username">
										#rc.user.username#
									</span>
								</div>
							</div>
							<div class="profile-info-row">
								<div class="profile-info-name"> #getLabel("Email", #SESSION.languageId#)# </div>

								<div class="profile-info-value">
									<span class="editable" id="email">
										#rc.user.email#
									</span>
								</div>
							</div>
							<div class="profile-info-row">
								<div class="profile-info-name"> #getLabel("Language", #SESSION.languageId#)# </div>
								<div class="profile-info-value">
									
										<select id="lang" onchange="changeLanguage(#rc.user.userID#)">
											<cfloop query=#rc.language#>
												<option value="#rc.language.languageId#" <cfif rc.language.languageId EQ rc.user.languageId>SELECTED</cfif>>#rc.language.language#</option>
											</cfloop>
										</select>
									
								</div>
							</div>
							<div class="profile-info-row">
								<div class="profile-info-name">#getLabel("Notification", #SESSION.languageId#)#</div>
								<div class="profile-info-value">
									<div class="form-group">
										<cfloop query=#rc.notifications# >
											<cfif rc.notifications.levelNumber neq 4 OR rc.user.type eq "Admin">
											<div class="radio">
												<label>
													<input class="ace" #thisUserNotification eq rc.notifications.levelNumber?"checked":""# type="radio" name="notification" value="#rc.notifications.levelNumber#" id="lv#rc.notifications.levelNumber#" >
													<span  class="lbl"><b class="blue">#rc.notifications.levelString# :</b>#rc.notifications.description#</span>
												</label>
											</div>
											</cfif>
										</cfloop>
									</div>
								</div>
							</div>
							<div class="profile-info-row">
								<div class="profile-info-name"></div>

								<div class="profile-info-value">
									<span class="editable" id="username">
										<a href="/index.cfm/user/edit?id=#rc.user.userID#">#getLabel("Edit Profile", #SESSION.languageId#)#</a>
									</span>
								</div>
							</div>
						</div>
				<cfif rc.user.type eq "Programmer">
						<div class="space-12"></div>
						<div class="widget-header widget-header-small">
							<h4 class="widget-title blue smaller">
								<i class="ace-icon fa fa-rss orange"></i>
								<span>#getLabel("Personal Chart of", #SESSION.languageId#)# #rc.charTitle#</span>
							</h4>
					        <div class="pull-right" style="margin-top:7px">
								<button class="label label-lg label-purple arrowed" onClick='changeMonth("prev")'>Prev</button>
								<button id="btn-current-month" class="label label-lg label-info" onClick='changeMonth("current")'>#getLabel("Current Month", #SESSION.languageId#)#</button>
								<button id="btn-next-month" class="label label-lg label-success arrowed-right" onClick='changeMonth("next")'>#getLabel("Next", #SESSION.languageId#)#</button>
					        </div>
						</div>
						<!--- Chart --->
						<div class="profile-user-info profile-user-info-striped">
							<div id="basicColumnChart" class='col-md-12 row'></div>					
							<div id="pieChart" class='col-md-12 row'></div>					
						</div>
				</cfif>
					</div>
						<a class="pull-right" onClick="loadmore()" id="aLoad" style="cursor:pointer">#getLabel("Load more", #SESSION.languageId#)#</a>
						<!-- /section:pages/profile.info -->
						<div class="space-20"></div>
					</div>
				</div>
			</div>
		</div><!-- /.col -->
	</div>
</div>
<cfscript>
	if(structKeyExists(URL,"page"))
		var page=URL.page;
	else 
		var page="profile";
	nID=rc.user.notificationID eq ''?0:rc.user.notificationID;
</cfscript>
<script type="text/javascript">
	var num=0;
	var userID="#rc.user.userID#";
	var page="#page#";
	var currentYear=#Year(now())#;
	var currentMonth=#Month(now())#;
	var cYear=#rc.cYear#;
	var cMonth=#rc.cMonth#;
	// notification 
	var defaultNotification=#thisUserNotification#;
	var newNotification=#thisUserNotification#;
	if(currentYear==cYear && currentMonth==cMonth){
		$("##btn-current-month").attr('disabled','disabled');
		$("##btn-next-month").attr('disabled','disabled');
	}
	$(document).ready(function(){
		$("input[name=notification]").on("click",function(){
			newNotification=$(this).val();
			if(newNotification!=defaultNotification){
				$.ajax({
			        url: '/index.cfm/user.changeNotification',
			        method:'POST',
			        dataType: 'json',
			        data: {
			        	id: userID,
			        	newNotification:newNotification
			        },
			        success: function( data ) {
			        	if(!data){
			        		alert("An error when change Notification, please try again later!");
			        	}else{
			        		defaultNotification=newNotification;
			        	}
			        }
			    });
			}
		});
		basicColumnChart();
	});
	function changeMonth(action){
		switch(action){
			case "current":
				cMonth=currentMonth;
				cYear=currentYear;
			break;
			case "prev":
				cMonth--;
			break;
			case "next":
				cMonth++;
			break;
		}
		if(cMonth>12){
			cMonth=1;
			cYear++;
		}else{
			if(cMonth<1){
				cMonth=12;
				cYear--;
			}
		}
		window.location.href="/index.cfm/user?id="+userID+"&cm="+cYear+"-"+cMonth;
	}
	function basicColumnChart(){
		$.ajax({
            type: "POST",
            url: "/index.cfm/user.basicColumnChart?cm="+cYear+"-"+cMonth,
            datatype: "html",
             data: {
            	thisUserID : userID
            },
           
            success: function( data ) {
            	$('##basicColumnChart').html(data);
            }
	    })
	    .done(function(data){
	        pieChart();
	        });
	}
	function pieChart(){
		$.ajax({
            type: "POST",
            url: "/index.cfm/user.pieChart?cm="+cYear+"-"+cMonth,
            datatype: "html",
             data: {
            	thisUserID : userID
            },           
            success: function( data ) {
            	$('##pieChart').html(data);
            }
	    });
	}
	changePage(page);
	function changePage(string){
		window.history.pushState(string,string, '/index.cfm/user?id='+userID+"&cm="+cYear+"-"+cMonth+"&page="+string );
		num=0;
		page=string;
		if(page == "profile"){
			$("##listTitle").text("Profile");
			$("##lists").addClass("hide");
			$("##aLoad").addClass("hide");
			$("##profile").removeClass("hide");
		}else{
			$("##listTitle").text("List "+page);
			$("##lists").html("");
			$("##lists").removeClass("hide");
			$("##aLoad").removeClass("hide");
			$("##profile").addClass("hide");
			loadmore();
		}	
	}
	function loadmore(){
		$.ajax({
	        url: '/index.cfm/user.load',
	        method:'POST',
	        dataType: 'json',
	        data: {
	        	id: userID,
	        	page:page,
	        	num:num,
	        },
            success: function( data ) {
            	for (var i = 0;i<data.length ; i++) {
	            	$("##lists").append('\
		            	<div class="profile-info-row">\
							<div class="profile-info-name"><a '+data[i].URL+'> '+data[i].TITLE+'</a> </div>\
							<div class="profile-info-value">\
								<span class="editable" >\
									 '+data[i].DESCRIPTION+' \
								</span>\
							</div>\
						</div>');
            	};
            	num++;
            	if(data.length < 5){
	        		num=-1;
	        		$("##aLoad").addClass("hide");
        		}
            }
	    });
	}
	// end notification
	function changeLanguage(id){
    	var langId = $("##lang").val();
    	// alert(langId);
    	$.ajax({
	        url: '/index.cfm/user.changeLanguages',
	        method:'POST',
	        dataType: 'json',
	        data: {
	        	id: userID,
	        	languageId:langId
	        },
	        success: function( data ) {
	        	if(!data){
	        		alert("an error when change Language, please try again later!");
	        	}
	        	location.reload();
	        }
	    });
    }
    function selectProgrammerChange(){
    	userID=$("##selectUser").val();
    	window.location.href= '/index.cfm/user?id='+userID+"&cm="+cYear+"-"+cMonth+"&page="+page ;
    }
</script>
</cfoutput>
</cfif>
<cfif SESSION.userType eq 3 AND !structKeyExists(rc,'user')>
<script type="text/javascript">
    $(document).ready(function(){
        $('#projects').dataTable();
    });
    
</script>
<cfoutput>
	<div class="row clearfix">
		<div class="page-header">
			<h1>
				#getLabel("User", #SESSION.languageId#)#
				<small>
					<i class="ace-icon fa fa-angle-double-right"></i>
					#getLabel("Manager", #SESSION.languageId#)#
				</small>

				<a class="btn btn-sm btn-info pull-right" href="/index.cfm/user/newmember">
					<i class="menu-icon fa fa-user-plus">
					<span style="font-family: 'Open Sans';"> #getLabel("New Menber", #SESSION.languageId#)#</span>
					</i>
				</a>	
			</h1>			
		</div>
		<small class="">(<strong class="red">*</strong>) #getLabel("Detail have", #SESSION.languageId#)# <abbr>#getLabel("underline", #SESSION.languageId#)#</abbr> #getLabel("can be changed by click on it", #SESSION.languageId#)#.</small>
	</div>
	<div class="row clearfix" style="margin-top:20px;">
		<div class="row col-md-12">
            <table id="projects" class="datatable table-bordered col-md-12">
	            <thead>
					<tr>
	                    <th>#getLabel("Full Name", #SESSION.languageId#)#</th>
	                    <th>#getLabel("Username", #SESSION.languageId#)#</th>
	                    <th>#getLabel("Email", #SESSION.languageId#)#</th>
	                    <th>#getLabel("Number Projects", #SESSION.languageId#)#</th>
	                    <th>#getLabel("Hours", #SESSION.languageId#)#</th>
	                    <th>#getLabel("Type", #SESSION.languageId#)#</th>
	                    <th>#getLabel("End Date", #SESSION.languageId#)#</th>
	                    <th>#getLabel("Active", #SESSION.languageId#)#</th>
	                </tr>
	            </thead>
	            <tbody>
	                <cfloop query=#rc.users# >
						<tr>
	                        <td><a href="/index.cfm/user?id=#rc.users.userID#">#rc.users.firstname# #rc.users.lastname#</a></td>
	                        <td>#rc.users.username#</td>
	                        <td>#rc.users.email#</td>
	                        <td>#rc.users.nProjects#</td>
	                        <td class="center">#rc.users.hours#</td>
	                        <td id="typeOfUser#rc.users.userID#"><abbr id="spanTypeOfUser#rc.users.userID#"  onClick='changeType("#rc.users.userID#")' title="Click to change Type">#rc.users.type#</abbr><i class="ace-icon fa fa-pencil-square-o  bigger-110 icon-on-right"></i>&nbsp;</td>
	                        <td id="endDateOfUser#rc.users.userID#"><abbr id="spanEndDateOfUser#rc.users.userID#"  onClick='changeEndDate("#rc.users.userID#")' title="Click to change End Date">#DateFormat(rc.users.endDate,"mm-dd-yyyy")#</abbr><i class="ace-icon fa fa-pencil-square-o  bigger-110 icon-on-right"></i></td>
	                        <td>
	                        	<label>
									<input name="switch-field-1" class="ace ace-switch ace-switch-6" type="checkbox" <cfif rc.users.active eq 1>checked</cfif> onChange='changeActive(#rc.users.userID#)' id="cBox#rc.users.userID#" >
									<span class="lbl"></span>
								</label>
	                    	</td>
	                        
	                    </tr>
	                </cfloop>
	            </tbody>
	        </table>
	    </div>
	</div>
</cfoutput>
<script type="text/javascript">
	function changeEndDate(id){
		$("#spanEndDateOfUser"+id).addClass("hide");
		$("#endDateOfUser"+id).prepend('<input id="input'+id+'" onBlur="closeInput('+id+')" class=" date-picker" data-date-format="mm-dd-yyyy" style="width:100%" >');
		$("#input"+id)
			.attr('value',$("#spanEndDateOfUser"+id).text() )
			.focus();
	}
	function closeInput(id){
		var newDate=$("#input"+id).val().replace(' ', '');
		if($("#spanEndDateOfUser"+id).text().replace(' ', '') != newDate){
			$("#spanEndDateOfUser"+id)
				.text(newDate);
			$.ajax({
		        url: '/index.cfm/user.changeEndDate',
		        method:'POST',
		        dataType: 'json',
		        data: {
		        	id: id,
		        	endDate:newDate
		        },
		        success: 	function(data) {
		        		if(data)
		        			$("#spanEndDateOfUser"+id).addClass("green");
		        	}
		        });
		    window.setTimeout(function(){$("#spanEndDateOfUser"+id).removeClass("green")},2000);
		}
		$("#spanEndDateOfUser"+id).removeClass("hide");
		var element = document.getElementById("input"+id);
		element.parentNode.removeChild(element);		
	}
	function changeActive(id){
		$.ajax({
	        url: '/index.cfm/user.changeActive',
	        method:'POST',
	        dataType: 'json',
	        data: {
	        	id: id,
	        	active:$("#cBox"+id).is(':checked') ? 1 : 0
	        }
	    });
	}
	function changeType(id){
		var stringId=$("#spanTypeOfUser"+id).text();
		$("#spanTypeOfUser"+id).addClass("hide");
		$("#typeOfUser"+id).prepend('<select id="selectType'+id+'" onBlur="closeSelect('+id+')"style="width:100%" >\
										<option value="Admin" id="sAdmin">Admin</option>\
										<option value="Programmer" id="sProgrammer">Programmer</option>\
										<option value="Tester" id="sTester">Tester</option>\
										<option value="Customer" id="sCustomer">Customer</option>\
									</select>');
		$("#selectType"+id).focus();
		document.getElementById("s"+stringId).selected="true";
	}
	function closeSelect(id){
		var newType=$("#selectType"+id).val();
		$("#spanTypeOfUser"+id).removeClass("hide");
		var element = document.getElementById("selectType"+id);
		element.parentNode.removeChild(element);
		if($("#spanTypeOfUser"+id).text() != newType){
			$("#spanTypeOfUser"+id).text(newType);
			$.ajax({
		        url: '/index.cfm/user.changeType',
		        method:'POST',
		        dataType: 'json',
		        data: {
		        	id: id,
		        	type:newType
		        },
		        success: 	function(data) {
		        		if(data)
		        			$("#spanTypeOfUser"+id).addClass("green");
		        	}
		        });
		    window.setTimeout(function(){$("#spanTypeOfUser"+id).removeClass("green")},2000);
		}		
	}
</script>
</cfif>
