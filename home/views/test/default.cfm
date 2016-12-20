<style type="text/css">
	.modal-body .form-horizontal .col-md-2,
	.modal-body .form-horizontal .col-md-10 {
	    width: 100%
	}
	.invalid{
		background: red;
	}
	.modal-body .form-horizontal .control-label {
	    text-align: center;

	}
	.modal-body .form-horizontal .col-md-offset-2 {
	    margin-right: 0px;
	}
	.modal-dayoff {
    width: 760px;
    top: 8%;
    position: absolute;
    margin-top: 0px;
    margin-left: 270px;
	}
	.btn-circle-lg {
    width: 70px;
    height: 70px;
    text-align: center;
    padding: 8px 0px;
    font-size: 30px;
    line-height: 2;
    border-radius: 70px;
	}
	.btn-primary {
    color: #FFF;
    background-color: #428BCA;
    border-color: #357EBD;

}
	.select-typeoff{
		height: 33.77px;
		width: 150px;
	}
</style>
<!--- begin modal --->
<!-- Button trigger modal -->
<button class="btn btn-circle-lg btn-primary" data-toggle="modal" data-target="#myModalHorizontal"  title="Request for day off">
   <span class="glyphicon glyphicon-plus"></span>
</button>

<!-- Modal -->
<div class="modal fade" id="myModalHorizontal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dayoff">
        <div class="modal-content">
            <!-- Modal Header -->
            <div class="modal-header">
                <button type="button" class="close" 
                   data-dismiss="modal">
                       <span aria-hidden="true">&times;</span>
                       <span class="sr-only">Close</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">
                   Request for day off
                </h4>
            </div>
            
            <!-- Modal Body -->
            <div class="modal-body">
                
                <form class="form-horizontal" role="form" action="/index.cfm/test/addDayOff" method="post">
                    	<div class="row">
							<div class="col-md-2">
								<cfoutput>
									<!--- <cfloop query="#rc.userInfo#"> --->
										<img style="width:140px; height:140px;" class="img-circle" title="#rc.userInfo.username[1]#"
										<cfif rc.userInfo.avatar EQ "">
											src="/fileupload/avatars/default.jpg"
											<cfelse>
												src="/fileupload/avatars/#rc.userInfo.avatar[1]#"
										</cfif> />
									<!--- </cfloop> --->
								</cfoutput>
								<br>
							</div>
							<div class="col-md-10">
								<h3 class="text-primary text-center">
									Schedule take day off
								</h3>
								<hr />
							</div>
						</div>
						<div class="row">
							<div class="col-md-10 pull-right">
									 <label><span><strong>Choose to take day off:</strong>*</span></label><BR>
									 <input type="text" name="daterange" value="#URL.date#- #URL.date#" size="60" required><BR><BR>
									 <cfoutput>
										 <label><span><strong>Total day off/Type:</strong>*</span></label> &nbsp &nbsp
										 <input type="text" name="totalDayOff" size="2" id="isNumber" value="0.5" required> 
										 <select name="typeoff" class="select-typeoff">
										 	<cfloop array="#rc.listType#" item="type">
										 		<option value="#type.getId()#">#type.getStatusName()#</option>
										 	</cfloop>
										 </select><BR><BR>

									 </cfoutput>
									 <label><span><strong>Due to:</strong>*</span></label><BR><BR>
										<textarea name="noteDayOff" rows="8" cols="58" placeholder="Due to you take day off, please!" required></textarea><br><BR>
									 <!--- <hr /> --->
									 <button type="submit" class="btn btn-danger">
										Send to
									</button>
									 <button type="button" class="btn btn-default" data-dismiss="modal">
			                            Close
			                		</button>
							</div>
							<div class="col-md-2"></div>
						</div>
						<!--- Close row --->
                </form>
            </div>
            <!--- close modal-body --->
        </div>
        <!--- close modal-conten --->
    </div>
    <!--- close modal dayoff --->
</div>

<!--- end modal --->
                               
<cfoutput>
<cfparam name="URL.date" default="#dateFormat(now(), 'yyyy-mm-dd')#">
<div class="space"></div>
<div class="row clearfix">
    <div class="col-xs-12 col-lg-12" style="border-bottom:1px ##428bca solid;">
<!---         <h1 class="blue" >#getLabel("", #SESSION.languageId#)#
        	<small class="month-name">#dateFormat(URL.date,'yyyy, MMMM, dd')#</small>
	        <div class="pull-right" style="margin-top: -5px;">
				<button class="label label-lg label-purple arrowed" onClick='changeMonth("prev")'>Prev</button>
				<button id="btn-current-month" class="label label-lg label-info" onClick='changeMonth("current")'>#getLabel("Current Month", #SESSION.languageId#)#</button>
				<button id="btn-next-month" class="label label-lg label-success arrowed-right" onClick='changeMonth("next")'>#getLabel("Next", #SESSION.languageId#)#</button>
	        </div>
        </h1> --->
    </div>
</div>
<div class="space"></div>
<!--- <div class="row">
	<div class="col-md-12">

	</div>
</div> --->
	<div class="row" >
	<cfif rc.userDayOffisAccept.countRecord NEQ 0 AND SESSION.userType EQ 3>
	    <div class="col-md-6" style="border: 1.5px solid red">
	    	<cfloop query="rc.userDayOffisAccept">
	    		<ul>
		      <form role="form" action="/index.cfm/test/updateStatus" method="POST">
		      		<label>User name:</label> &nbsp #rc.userDayOffisAccept.username# <BR>
		      		<label>Total day off:</label> &nbsp #rc.userDayOffisAccept.totalDayOff# <BR> 
		      		<label>Type:</label> &nbsp #rc.userDayOffisAccept.statusName# <BR>
		      		<label>Due to:</label> &nbsp #rc.userDayOffisAccept.description# <BR>
		      		<!--- <input type="radio" name="accept" value="1" checked> Agree &nbsp <input type="radio" name="accept" value="0" > Reject --->
		      		<BR>
		      		<button type="submit" name="accept" value="1">Accept</button> &nbsp <button type="submit" name="accept" value="2">Decline</button>
		      </form>
	    		</ul>
	    	</cfloop>
	    </div>
		<cfelse>
			<div class="col-md-12"></div>
	</cfif>
	</div>
		

<div class="space"></div>
<div class="container-fluid">
	<div class="row">
		<div class="col-md-5">
			<strong style="font-size: 20px;">Follow year</strong><BR><hr /><BR>
			<cfset MaxDayOff = (rc.statisticYear.totalDayInYear[1] gt 20 ?rc.statisticYear.totalDayInYear[1]:20)>
			<cfloop query="rc.statisticYear">
				<cfset totalOff = rc.statisticYear.totalDayInYear EQ ""?0:rc.statisticYear.totalDayInYear>
				<b> 
		           <strong style="font-size: 15px;">#totalOff# days- </strong>
		        </b>
	        	#rc.statisticYear.username# 

		        <div id="divbar" class="progress progress-mini" title="Day off: #totalOff#">
		            <div style="width: #totalOff/MaxDayOff*100#%;" class="progress-bar progress-bar-green"></div>
		        </div>
		        <!--- END CHART --->
				<h4 class="header smaller green dayoff-head" style="margin-left:20px;cursor:pointer" data-id='#rc.statisticYear.userID#'>
	                 <i class="fa fa-caret-right" id='ico-#rc.statisticYear.userID#' title="Log for 2 months">logs</i>
	                <span class="badge badge-warning pull-right" style="margin-right:20px"></span>
	            </h4>
		            <div class="dd2-content lighter green user-dayoff-#rc.statisticYear.userID#" style="display:none; margin-left:20px;">
		            	<cfloop query="rc.logsMonthly">
		            		<cfset detailLog = rc.logsMonthly.countLogs eq ""?0:rc.logsMonthly.countLogs>
		            		<cfset totalFollow = rc.logsMonthly.totalDayOff eq "" ?0:rc.logsMonthly.totalDayOff>
					        <b> 
					            <span id="TotalDayOff">
					               <strong style="font-size: 20px;">#detailLog#</strong>
					            </span>
					        </b>
				        	#rc.logsMonthly.statusName# <span class="pull-right" style="font-size: 15px;">#totalFollow# days</span>
					        <div id="divbar" class="progress progress-mini" title="Day off: #detailLog#">
					            <div style="width: #detailLog/12*100#%;" class="progress-bar progress-blue"></div>
					        </div>
		            		 <!--- #rc.logsMonthly.countLogs# --->
		            	</cfloop>
		            	<BR>
		            </div>
			</cfloop>
			<BR>
		</div>
		<!--- close first col-md-6 --->
		<div class="col-md-7">
			<strong style="font-size: 20px;" class="">Annual leave for 12 months</strong><BR><hr /><BR>
			<!--- <cfset maxDayInYear = rc.statisticYear.totalDayInYear[1] gt 30?rc.statisticYear.totalDayInYear[1]:30>
			<!--- <cfloop query="rc.statisticYear"> --->
				<cfset dayoffInYear = rc.statisticYear.totalDayInYear EQ ""?0:rc.statisticYear.totalDayInYear>
				<b>
					<strong style="font-size: 15px;">#rc.statisticYear.username#</strong>
				</b>
					<strong class="pull-right" style="font-size: 15px;">#dayoffInYear# days</strong> --->
				 	<cfloop query="rc.statisticAnnual">
				 		<b>
				 			<strong>#rc.statisticAnnual.username#</strong>
				 		</b>
				 <div class="progress ">
				 	<!--- a year, there are 12 day about annual leave --->
				 		<cfset offMaxAnnual = rc.statisticAnnual.dayOffAnnualLeave[1] gt 12?rc.statisticAnnual.dayOffAnnualLeave[1]:12>
				 		<cfset offAnnualInYear = rc.statisticAnnual.dayOffAnnualLeave eq ""?0:rc.statisticAnnual.dayOffAnnualLeave>
						 <div class="progress-bar progress-bar-danger progress-bar-striped" role="progressbar" style="width:#offAnnualInYear/offMaxAnnual*100#%" title="You take day off:#offAnnualInYear#">
						    #offAnnualInYear# days
						 </div>
						 <cfset yetAnnual = rc.statisticAnnual.YetAnnualLeave eq ""?0:rc.statisticAnnual.YetAnnualLeave>
						 <div class="progress-bar progress-bar-info progress-bar-striped" role="progressbar" style="width:#yetAnnual/offMaxAnnual*100#%" title="You have: #yetAnnual# days">
						    #yetAnnual# days
						 </div>
				</div><hr />
				 	</cfloop>
				
			<!--- </cfloop> --->
		</div>
	<!--- close row --->
</div>
</cfoutput>
<!--- Note range date picker --->
<script type="text/javascript">
	$(document).on('click','.dayoff-head',function(){
        var userID = $(this).attr('data-id');
        var $icon = $('#ico-'+userID);
        if($icon.hasClass('fa-caret-right')){
            $icon.removeClass('fa-caret-right').addClass('fa-caret-down');
        }else{
            $icon.removeClass('fa-caret-down').addClass('fa-caret-right');
        }
        $('.user-dayoff-'+userID).slideToggle( "slow" );
    })

	function isNumberKey(evt){
		var charCode = (evt.which)?evt.which:event.keyCode;
		if(charCode > 31 && (charCode<48 ||charCode>57)){
			return false;
		}
		return true;
	}
	/*$(function() {
	    $('input[name="daterange"]').daterangepicker({
	        timePicker: true,
	        timePickerIncrement: 30,
	        locale: {
	            format: 'MM/DD/YYYY h:mm A'
	        }
	    });
	});*/
	$(function() {
    $('input[name="daterange"]').daterangepicker();
});
	// $('#myModal').modal()
</script>