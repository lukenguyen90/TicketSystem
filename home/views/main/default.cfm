<style type="text/css">
.danger{color:#D15B47;border-bottom: 1px solid #D15B47;}
.warning{color:#FFB752;border-bottom: 1px solid #FFB752;}
.success{color:#87B87F;border-bottom: 1px solid #87B87F;}
.info{color:#6FB3E0;border-bottom: 1px solid #6FB3E0;}
.primary{color:#428BCA;border-bottom: 1px solid #428BCA;}
.purple{color:#9585BF;border-bottom: 1px solid #9585BF;}
.grey{color:#A0A0A0;border-bottom: 1px solid #A0A0A0;}
.yellow{color:#FEE188;border-bottom: 1px solid #FEE188;}
.mainInput{height: 30px}
.over{
  background-color: red;
  color: white;
}
.ms-parent{
	width: 100% !important;
}
.input-label{
	text-align: right;
}
@media(max-width:991px) {
	.input-label{
		text-align: left;
	}
}
</style>
<cfoutput>
<cfset page = 1>
<div class="row clearfix">
		<div class="col-md-6 col-xs-12">
		<h3 >#getLabel("Tickets", #SESSION.languageId#)#</h3>
		</div>
		
		<div class="pull-right col-md-6 col-xs-12" >
			<label class="hidden-xs col-md-12">#getLabel("Select Assignee", #SESSION.languageId#)#</label>
				<div class="col-md-10">
				<select multiple="" class="chosen-select tag-input-style chosen-header" id="as" name="as" onchange='selectChange()' data-placeholder="#getLabel("Select Assignee", #SESSION.languageId#)#">
					<!--- <option value="" disabled>#getLabel("Select Assignee", #SESSION.languageId#)#</option> --->

					<cfloop query=#rc.listAssignee# >
						<option value="#rc.listAssignee.userID#" >#rc.listAssignee.firstname# #rc.listAssignee.lastname#</option>
					</cfloop>
				</select>
			</div>
			<div class="btn btn-xs btn-warning " id="btn_advanced_filter">
				<i class="ace-icon fa fa-cog bigger-150"></i>
			</div>
		</div>
		
</div>
<div class="row claerfix" id="advance_filter" style="display:none">
	<div class="col-md-12">
		<div class="widget-box">
			<div class="widget-header">
				<h4 class="widget-title">Advanced Filter</h4>
			</div>

			<div class="widget-body">
				<div class="widget-main">
					<div class="row">
						<div class="col-md-6 col-xs-12" >
							<div class="row">
								<div class="col-md-4 col-xs-12 input-label">
									<label>#getLabel("Search", #SESSION.languageId#)#</label>
								</div>
								<div class="col-md-8 col-xs-12">
									<input type="text"  placeholder="#getLabel("Search", #SESSION.languageId#)#" class="col-xs-12 input-sm mainInput"  id="inputsearch" name="inputsearch" onchange='selectChange()' >
								</div>
							</div>
						</div>
						<hr>
						<div class="col-md-6 col-xs-12" >
							<div class="row">
								<div class="col-md-4 col-xs-12 input-label">
									<label>#getLabel("Project", #SESSION.languageId#)#</label>
								</div>
								<div class="col-md-8 col-xs-12">
									<select multiple="" class="chosen-select tag-input-style chosen-advanced" data-placeholder="#getLabel("Select Project", #SESSION.languageId#)#..." id="pj" name="pj" onchange='selectChange()'>
										<cfloop query=#rc.listProject# >
											<option value='#rc.listProject.projectID#' >#rc.listProject.projectName#</option>
										</cfloop>
									</select>
								</div>
							</div>
						</div>
						<div class="col-md-6 col-xs-12" >
							<div class="row">
								<div class="col-md-4 col-xs-12 input-label">
									<span class="bigger-110">#getLabel("Epic", #SESSION.languageId#)#</span>
								</div>
								<div class="col-md-8 col-xs-12">
									<input type="text"  placeholder="#getLabel("Epic", #SESSION.languageId#)#" class="col-xs-12 input-sm mainInput"  id="inputepic" name="inputepic" onchange='selectChange()' >
								</div>
							</div>
						</div>
						<div class="col-md-12 hidden-xs" style="height:10px;"></div>
						<div class="col-md-6 col-xs-12" >
							<div class="row">
								<div class="col-md-4 col-xs-12 input-label">
									<span class="bigger-110">#getLabel("Reporter", #SESSION.languageId#)#</span>
								</div>
								<div class="col-md-8 col-xs-12">
									<select multiple="multiple" class="chosen-select tag-input-style chosen-advanced" id="rp" name="rp"  onchange='selectChange()' data-placeholder="#getLabel("Select Reporter", #SESSION.languageId#)#..." >
										<cfloop query=#rc.listReporter# >
											<option value="#rc.listReporter.userID#" >#rc.listReporter.firstname# #rc.listReporter.lastname#</option>
										</cfloop>
									</select>
								</div>
							</div>
						</div>
						<div class="col-md-6 col-xs-12" >
							<div class="row">
								<div class="col-md-4 col-xs-12 input-label">
									<span class="bigger-110">#getLabel("Select Status", #SESSION.languageId#)#</span>
								</div>
								<div class="col-md-8 col-xs-12">
									<select multiple="multiple" class="chosen-select tag-input-style chosen-advanced" id="st" name="st"  onchange='selectChange()' data-placeholder="#getLabel("Select Status", #SESSION.languageId#)# ..." >
										<cfloop query=#rc.listStatus# >
											<option value="#rc.listStatus.statusID#" >#getLabel("#rc.listStatus.statusName#", #SESSION.languageId#)#</option>
										</cfloop>
									</select>
								</div>
							</div>
						</div>
						<div class="col-md-12 hidden-xs" style="height:10px;"></div>
						<div class="col-md-6 col-xs-12" >
							<div class="row">
								<div class="col-md-4 col-xs-12 input-label">
									<span class="bigger-110">#getLabel("Due date", #SESSION.languageId#)#</span>
								</div>
								<div class="col-md-8 col-xs-12">
									<input class="date-picker" id="dueDate" name="dueDate" type="text" data-date-format="yyyy-mm-dd" value="" onchange='selectChange()' style="width: 100%;" />
								</div>
							</div>
						</div>
						<div class="col-md-6 col-xs-12" >
							<div class="row">
								<div class="col-md-4 col-xs-12 input-label">
									<span class="bigger-110">#getLabel("Report date", #SESSION.languageId#)#</span>
								</div>
								<div class="col-md-8 col-xs-12">
									<input class="date-picker" id="reportDate" name="reportDate" type="text" data-date-format="yyyy-mm-dd" value=""  onchange='selectChange()' style="width: 100%;" />
								</div>
							</div>
						</div>
					</div>
					<!-- /section:plugins/input.chosen -->
				</div>
			</div>
		</div>
	</div>
</div>
<br>
<div class="row clearfix">
	<div id="tks" >
		<div class="col-md-12">
			<table class="table table-striped table-bordered table-hover hide" id="haveticket">
				<thead>
					<th>#getLabel("Title", #SESSION.languageId#)#</th>
					<th>#getLabel("Report Date", #SESSION.languageId#)#</th>
					<th>#getLabel("Due Date", #SESSION.languageId#)#</th>
					<th>#getLabel("Assignee", #SESSION.languageId#)#</th>
					<th>#getLabel("Reporter", #SESSION.languageId#)#</th>
					<th>#getLabel("Priority", #SESSION.languageId#)#</th>
					<th>#getLabel("Status", #SESSION.languageId#)#</th>
				</thead>
				<tbody id="content">
				</tbody>
			</table>
		</div>
		<div class="col-md-12">
			<span id="noticket" class="col-md-12 alert alert-warning hide">#getLabel('There are no ticket to show', #SESSION.languageId#)#</span>
		</div>
		<div id="waiting" class="hide col-md-12">
	      <div class="alert alert-info">
	        <strong><i class="ace-icon fa fa-spinner fa-spin orange bigger-250"></i>  #getLabel("Loading", #SESSION.languageId#)#..</strong>

	        #getLabel("Please wait for a few seconds.", #SESSION.languageId#)#
	        <br>
	      </div>
		</div>
	</div>
	<br>
	<div class="col-md-12">
		<span id="loadmore" style="cursor:pointer" class="btn btn-sm btn-success hide">#getLabel("Load More", #SESSION.languageId#)#</span>
	</div>
</div>
<cfif structKeyExists(URL,"pId")>
	<cfset lProject = listToArray(URL.pId,",")>
	<cfloop array = #lProject# index="lp">
		<script type="text/javascript">
			$("##pj").find("option[value='#lp#']").attr("selected","selected");
		</script>
	</cfloop>
</cfif>
<cfif structKeyExists(URL,"st")>
	<cfset lStatus = listToArray(URL.st,",")>
	<cfloop array = #lStatus# index="ls">
		<script type="text/javascript">
			$("##st").find("option[value='#ls#']").attr("selected","selected");
		</script>
	</cfloop>
</cfif>
<cfif structKeyExists(URL,"rp")>
	<cfset lReported = listToArray(URL.rp,",")>
	<cfloop array = #lReported# index="lr">
		<script type="text/javascript">
			$("##rp").find("option[value='#lr#']").attr("selected","selected");
		</script>
	</cfloop>
</cfif>
<cfif structKeyExists(URL,"as")>
	<cfset lAssigned = listToArray(URL.as,",")>
	<cfloop array = #lAssigned# index="la">
		<script type="text/javascript">
			$("##as").find("option[value='#la#']").attr("selected","selected");
		</script>
	</cfloop>
</cfif>
<cfif structKeyExists(URL,"search")>
	<script type="text/javascript">
		var str='#URL.search#';
		$("##inputsearch").val(str.replace(/\+/g, " "));
	</script>
</cfif>
<cfif structKeyExists(URL,"epic")>
	<script type="text/javascript">
		var str='#URL.epic#';
		$("##inputepic").val(str.replace(/\+/g, " "));
	</script>
</cfif>
<cfif structKeyExists(URL,"rpd")>
	<script type="text/javascript">
		$("##reportDate").val('#URL.rpd#');
	</script>
</cfif>
<cfif structKeyExists(URL,"dd")>
	<script type="text/javascript">
		$("##dueDate").val('#URL.dd#');
	</script>
</cfif>
</cfoutput>
<script type="text/javascript"> 
	var url="";
	var page= 0 ;
	var  isFirstOpen = true ;
	$(document).ready(function(){
		$('.chosen-select').chosen({allow_single_deselect:true}); 
		//resize the chosen on window resize
		$(window).on('resize.chosen', function() {
			var w = $('.chosen-header').parent().width();
			$('.chosen-header').next().css({'width':w});
		}).trigger('resize.chosen');
		$(window).on('resize.chosen', function() {
			var w = $('.chosen-advanced').parent().width();
			$('.chosen-advanced').next().css({'width':w});
		}).trigger('resize.chosen');
	    // $("select").multipleSelect();
		$("#dueDate").datepicker({
						autoclose: true,
						todayHighlight: true,
						dateFormat: 'yy-mm-dd'
					});
		$("#reportDate").datepicker({
						autoclose: true,
						todayHighlight: true,
						dateFormat: 'yy-mm-dd'
					});
		selectChange();
		$("#loadmore").on("click",function (){
			page++;
			getData();
		});

		$("#btn_advanced_filter").on("click",function(){
			$("#advance_filter").toggle("slow",function(){
				if(isFirstOpen){
					var w = $('#pj').parent().width();
					$('.chosen-advanced').next().css({'width':w});
					isFirstOpen = false ;
					console.log(w);
				}

			});
		})
	});
	function getData()
	{
		if(page == 0){
			// displayStatus("loading");
			$("#content").find('tr').remove();
		}else{
			displayStatus("loadingmore");
		}
		$.ajax({
	        url: '/index.cfm/main.load'+url,
	        method:'GET',
	        data: {
            	page : page
            },
            dataType: 'json',
	        success: 	function(data) {
	        	if(data.success)
	        	{
	        		if(data.len == 0){
	            		displayStatus("noticket");
	            	}else{
	            		$("#content").append(data.HTMLString);
	            		if(data.len <= 20)
	            		{
	            			displayStatus("havelitle");
	            		}
	            		else{
	            			displayStatus("havemuch");
	            		}
		        	}
	        	}else{
	        		displayStatus("noticket");
	        	}
	        }
	    });
	}
	function displayStatus(action){
		switch(action){
			case "loading":
    			$("#loadmore").addClass("hide");
    			$("#haveticket").addClass("hide");
				$("#noticket").addClass("hide");
				$("#waiting").removeClass("hide");
				break;
			case "loadingmore":
				$("#loadmore").addClass("hide");
    			$("#haveticket").removeClass("hide");
				$("#noticket").addClass("hide");
				$("#waiting").removeClass("hide");
				break;
			case "havemuch":
				$("#loadmore").removeClass("hide");
    			$("#haveticket").removeClass("hide");
				$("#noticket").addClass("hide");
				$("#waiting").addClass("hide");
				break;
			case "havelitle":
				$("#loadmore").addClass("hide");
    			$("#haveticket").removeClass("hide");
				$("#noticket").addClass("hide");
				$("#waiting").addClass("hide");
				break;
			case "noticket":
				$("#loadmore").addClass("hide");
    			$("#haveticket").addClass("hide");
				$("#noticket").removeClass("hide");
				$("#waiting").addClass("hide");
				break;
		}
	}
	function selectChange(){
		url="";
		if( $("#inputsearch").val()!=""){
			var sstr=$("#inputsearch").val();
			url += "?search="+sstr.replace(/ /g, "+"); 
		}
		if( $("#inputepic").val()!=""){
			var estr=$("#inputepic").val();
			url += url==""?'?':'&';
			url += "epic="+estr.replace(/ /g, "+"); 
		}
		url+=$("#pj").val() == null ? "": (url==""? '?pId='+$("#pj").val() : '&pId='+$("#pj").val() );
		url+=$("#reportDate").val() == ""? "": (url=="" ? '?rpd='+$("#reportDate").val() : '&rpd='+$("#reportDate").val() );
		url+=$("#dueDate").val() == ""? "": (url=="" ? '?dd='+$("#dueDate").val() : '&dd='+$("#dueDate").val() );
		url+=$("#st").val() == null ? "": (url==""? '?st='+$("#st").val() : '&st='+$("#st").val() );
		url+=$("#rp").val() == null ? "": (url==""? '?rp='+$("#rp").val() : '&rp='+$("#rp").val() );
		url+=$("#as").val() == null ? "": (url==""? '?as='+$("#as").val() : '&as='+$("#as").val() );
		window.history.pushState('Filter', 'Filter', '/index.cfm/'+url );
		page=0;
        getData();
		
	}
</script>
