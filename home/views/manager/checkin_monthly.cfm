<style type="text/css">
	.midTable{
		vertical-align: middle !important;
    	text-align: center;
    	font-weight: bold;
	}
	.gray{
		background-color: rgb(240,240,240) ;
	}
	#example td{
	  height:160px;
	  width:160px;
	}
	.well h1 {
	    font-size: 32px;
	    font-weight: normal;
	    font-family: "Open Sans","Helvetica Neue",Helvetica,Arial,sans-serif;
	}
</style>
<cfoutput>
	<section id="widget-grid" class="">
		<!-- row -->
		<div class="row">
			
			<!-- NEW WIDGET START -->
			<article class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
				
				<div class="row">
					<!-- col -->
					<div class="col-xs-5">
						<h1 class="page-title txt-color-blueDark">
							
							<!-- PAGE HEADER -->
							<i class="fa-fw fa fa-puzzle-piece"></i> 
								Requirement
							<span>>  
							Annual Leave
							</span>
						</h1>
					</div>
					<div class="col-xs-7">
						<div class="row">
							<div class="col-xs-7">
								<select class="select2" id="userId">
									<option value="0">Choose</option>
									<cfloop array="#rc.userIsoffical#" index="user">
										<option value="#user.userID#">#user.value#</option>
									</cfloop>
								</select>
							</div>
							<div class="col-xs-3">
								<select class="select2" id="monthId">
									<option value="0">Choose</option>
									<option value="1"> January </option>
									<option value="2"> February </option>
									<option value="3"> March </option>
									<option value="4"> April </option>
									<option value="5"> May </option>
									<option value="6"> June </option>
									<option value="7"> July </option>
									<option value="8"> August </option>
									<option value="9"> September </option>
									<option value="10"> October </option>
									<option value="11"> November </option>
									<option value="12"> December </option>
								</select>
							</div>
							<div class="col-xs-2">
								<a href="javascript:void(0)" onclick="getInfor()" class="btn btn-primary">Find</a>
							</div>
						</div>
					</div>
				</div>
				<cfif structKeyExists(URL, "id") && structKeyExists(URL,'month')>
					<div class="well">
						<div class="row">
							<div class="col-md-3">
				                <div class="ibox-content text-center">
				                    <h1>#rc.userInfor.name#</h1>
				                    <div class="m-b-sm center">
					        				<cfset avatar = "">
							        		<cfif rc.userInfor.avatar EQ "">
												<cfset avatar = "/fileupload/avatars/default.jpg">
											<cfelse>
												<cfif FileExists(expandPath("/fileupload/avatars/")&rc.userInfor.avatar)>
													<cfset avatar ="/fileupload/avatars/# rc.userInfor.avatar#">
												<cfelse>
													<cfset avatar ="/fileupload/avatars/default.jpg">
												</cfif>
												
											</cfif>
				                            <img alt="image" width="100" class="img-circle" src="#avatar#">
				                    </div>
				                </div>
				            </div>
				            <div class="col-md-9">
				            	<div class="center" style="margin-top:4em">
									<div>
										<div style="width: 40%; float:left">
										   Left
										</div>

										<div style="width: 60%; float:right">
										   Right
										</div>
									</div>
								</div>
				            </div>
						</div>
					</div>
				</cfif>
				<cfif structKeyExists(URL, "id") && structKeyExists(URL,'month')>
					<div class="jarviswidget well" id="wid-id-0">
						<header>
							<span class="widget-icon"> <i class="fa fa-comments"></i> </span>
							<h2>Widget Title</h2>
						</header>
						<div>
							
							<!-- widget edit box -->
							<div class="jarviswidget-editbox">
								<!-- This area used as dropdown edit box -->
								<input class="form-control" type="text">	
							</div>
							<!-- end widget edit box -->
							
							<!-- widget content -->
								<div class="widget-body no-padding">
									<table id="example" class="display projects-table table table-striped table-bordered table-hover" cellspacing="0" width="100%">
								        <thead>
								            <tr>
								                <th class="text-center"><i class="fa fa-fw fa-calendar text-muted hidden-md hidden-sm hidden-xs"></i> Sunday </th>
								                <th class="text-center"><i class="fa fa-fw fa-calendar text-muted hidden-md hidden-sm hidden-xs"></i> Monday </th>
								                <th class="text-center"><i class="fa fa-fw fa-calendar text-muted hidden-md hidden-sm hidden-xs"></i> Tuesday </th>
								                <th class="text-center"><i class="fa fa-fw fa-calendar text-muted hidden-md hidden-sm hidden-xs"></i> Webnesday </th>
								                <th class="text-center"><i class="fa fa-fw fa-calendar text-muted hidden-md hidden-sm hidden-xs"></i> Thursday </th>
								                <th class="text-center"><i class="fa fa-fw fa-calendar text-muted hidden-md hidden-sm hidden-xs"></i> Friday </th>
								                <th class="text-center"><i class="fa fa-fw fa-calendar text-muted hidden-md hidden-sm hidden-xs"></i> Saturday </th>
								            </tr>
								        </thead>
								        <tbody>
								        	<cfset startDay = DayOfWeek(LSDateFormat(Year(now())&"/"&URL.month&"/1",'yyyy-mm-dd'))>
								        	<cfset daysInMonth = day(dateAdd("d",-1,dateAdd("m",1,LSDateFormat(Year(now())&"/"&URL.month&"/1",'yyyy-mm-dd'))))>
								        	<cfset endDay = DayOfWeek(LSDateFormat(Year(now())&"/"&URL.month&"/"&daysInMonth,'yyyy-mm-dd'))>
								        	<cfset count = 0>
								        	<cfloop index="i" from="1" to ="6">
								        		<cfset countTr =0 >
								        		<cfif count gt  daysInMonth>
								        			<cfbreak>
								        		</cfif>
								        		<tr>
								        			<cfloop index="j" from="1" to ="7">
								        				<cfif i eq 1 and j lt startDay>
								        					<td class="gray"></td>
								        				<cfelse>
								        					<cfset count +=1>
								        					<cfset countTr +=1>
															<cfif count gt  daysInMonth>
																<cfset restCount = 7- countTr>
																<cfif restCount neq 0>
																	<cfloop from = "0" to ="#restCount#" index="c">
																		<td class="gray"></td>
																	</cfloop>
																</cfif>
											        			<cfbreak>
											        		</cfif>
											        		<cfif structKeyExists(rc,'results')>
											        			<cfif rc.results[count].stt>
											        				<cfset logtime = #DateTimeFormat("#int(rc.results[count].logTime/60)#:#int(rc.results[count].logTime mod 60)#", 'HH:nn')#>
											        				<cfset loginTime = LSDATETIMEFORMAT(rc.results[count].login,'HH:nn')>
											        				<cfset color =''>
											        				<cfif loginTime gt "09:00" and loginTime lt "10:00" > 	<cfset color = 'red'>
											        				</cfif>
												        			<td>
													        			<strong class="text-left">#count#</strong>
													        			<p class="text-center"><span style="color:#color#">#loginTime#</span> => #LSDATETIMEFORMAT(rc.results[count].logout,'HH:nn')#<p><hr>
													        			<div class='progress progress-xs' data-progressbar-value='#rc.results[count].percent#'><div class='progress-bar'></div></div><br>
													        			<p class="text-center">(#logtime#)</p>
													        		</td>
												        		<cfelse>
																		<cfif rc.annalList[count].stt>
																			<td>
																				<strong class="text-left">#count#</strong>
																				<p class="text-center" style="margin-top:10px"><strong>Submit on ticket</strong><p> <br>
																				<p class="text-center">#rc.annalList[count].reason#<p>
																			</td>
																		<cfelseif rc.sickList[count].stt >
																			<td>
																				<strong class="text-left">#count#</strong>
																				<p class="text-center" style="margin-top:10px"><strong>Submit on ticket</strong><p> <br>
																				<p class="text-center">#rc.sickList[count].reason#<p>
																			</td>
																		<cfelse>
																			<cfset currDay = DayOfWeek(LSDateFormat(Year(now())&"/"&URL.month&"/"&count,'yyyy-mm-dd'))>
																			<cfif currDay != 1 && currDay !=7>
																				<td class="danger">
																					<strong class="text-left">#count#</strong>
																					<p class="text-center" style="margin-top:10px"><strong>No reason</strong><p>
																				</td>
																			<cfelse>
																				<td><strong class="text-left">#count#</strong></td>
																			</cfif>
																			
																		</cfif>
																	</td>
												        		</cfif>
												        	<cfelse>
												        		<td>
												        			<strong class="text-left">#count#</strong>
												        		</td>
											        		</cfif>
											        		

								        				</cfif>
								        				
								        			</cfloop>
								        		</tr>
								        	</cfloop>
								        </tbody>
								    </table>
							</div>
							<!-- end widget content -->
							
						</div>
						<!-- end widget div -->
					</div>
				</cfif>
				<!-- end widget -->

			</article>
			<!-- WIDGET END -->
			
		</div>

		<!-- end row -->

		<!-- row -->

		<div class="row">

			<!-- a blank row to get started -->
			<div class="col-sm-12">
				<!-- your contents here -->
			</div>
				
		</div>

		<!-- end row -->

	</section>

<script type="text/javascript">
	$(document).ready(function() {
		$('##userId').val('#structKeyExists(URL,"id")?URL.id:0#');
		$('##monthId').val('#structKeyExists(URL,"month")?URL.month:0#');
	})

	function getInfor()
	{
		window.location.href = "/index.cfm/manager.checkin_monthly/?id="+$('##userId').val()+"&month="+$('##monthId').val();

	}
	
</script>
</cfoutput>