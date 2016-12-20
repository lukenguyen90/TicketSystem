<style type="text/css">
	.midTable{
		vertical-align: middle !important;
    	text-align: center;
    	font-weight: bold;
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
					<div class="col-xs-12 col-sm-7 col-md-7 col-lg-4">
						<h1 class="page-title txt-color-blueDark">
							
							<!-- PAGE HEADER -->
							<i class="fa-fw fa fa-puzzle-piece"></i> 
								Requirement
							<span>>  
								Annual leave
							</span>
						</h1>
					</div>
				</div>
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
							<cfif structKeyExists(rc, "listweekcheck")>
								<table id="example" class="display projects-table table table-striped table-bordered table-hover" cellspacing="0" width="100%">
							        <thead>
							            <tr>
							                <th><i class="fa fa-fw fa-user text-muted hidden-md hidden-sm hidden-xs"></i> Name</th>
							                <th><i class="fa fa-fw fa-calendar text-muted hidden-md hidden-sm hidden-xs"></i> Mo #dateFormat(#rc.startDate#,"dd-mm-yyyy")#</th>
							                <th><i class="fa fa-fw fa-calendar text-muted hidden-md hidden-sm hidden-xs"></i> Tu #dateFormat(dateAdd("d",1, #rc.startDate#),"dd-mm-yyyy")#</th>
							                <th><i class="fa fa-fw fa-calendar text-muted hidden-md hidden-sm hidden-xs"></i> We #dateFormat(dateAdd("d",2, #rc.startDate#),"dd-mm-yyyy")#</th>
							                <th><i class="fa fa-fw fa-calendar text-muted hidden-md hidden-sm hidden-xs"></i> Th #dateFormat(dateAdd("d",3, #rc.startDate#),"dd-mm-yyyy")#</th>
							                <th><i class="fa fa-fw fa-calendar text-muted hidden-md hidden-sm hidden-xs"></i> Fr #dateFormat(dateAdd("d",4, #rc.startDate#),"dd-mm-yyyy")#</th>
							                <th><i class="fa fa-fw fa-calendar text-muted hidden-md hidden-sm hidden-xs"></i> Sa #dateFormat(dateAdd("d",5, #rc.startDate#),"dd-mm-yyyy")#</th>
							                <th><i class="fa fa-fw fa-calendar text-muted hidden-md hidden-sm hidden-xs"></i> Su #dateFormat(dateAdd("d",6, #rc.startDate#),"dd-mm-yyyy")#</th>
							            </tr>
							        </thead>
							        <tbody>
							        	<cfloop array=#rc.listweekcheck# index="user">
							        		<cfset curDate = dateAdd( "d",-1,rc.startDate)>
											<tr>
								        		<td class="midTable">#user.NAME#</td>
								        		<cfloop array=#user.wDate# index="dDate">
						                            <cfset lcolor = dDate.logtime lt 510 ? 'danger' : dDate.logtime gt 510?'success':''> 
						                             <cfset logtime = #DateTimeFormat("#int(dDate.logtime/60)#:#int(dDate.logtime mod 60)#", 'HH:nn')#>
						                             <td class="#lcolor#">
									        			<p class="text-center">#LSDATETIMEFORMAT(dDate.LOGIN,'HH:nn')# => #LSDATETIMEFORMAT(dDate.LOGOUT,'HH:nn')#<p><hr>
									        			<div class='progress progress-xs' data-progressbar-value='#dDate.percent#'><div class='progress-bar'></div></div><br>
									        			<p class="text-center">(#logtime#)</p>
									        		</td>
									        		 <cfset curDate = dDate.DDATE>
								        		</cfloop>
								        		<cfset dif2 = dateDiff("d", curDate , rc.endDate) + 1>
						                        <cfif dif2 gt 0 >
						                            <cfloop from=1 to=#dif2# index="j">
						                                <td></td>
						                            </cfloop>                            
						                        </cfif>
								        	</tr>
							        	</cfloop>
							        </tbody>
							    </table>
							</cfif>
						</div>
						<!-- end widget content -->
						
					</div>
					<!-- end widget div -->
					
				</div>
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
</cfoutput>
<script type="text/javascript">
	$(document).ready(function() {

		$('#example').DataTable( {
			        "bDestroy": true,
			        "iDisplayLength": 10,
			        "order": [[1, 'asc']],
			        "fnDrawCallback": function( oSettings ) {
				       runAllCharts()
				    }
		} );
	})
	
</script>