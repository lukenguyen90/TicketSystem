<cfoutput>
	<div class="page-header">
		<div class="row">
				<h1>#getLabel("Annual Report", #SESSION.languageId#)#</h1>
		</div>
	</div>

	<div class="row">
		<div class="col-xs-11">
			<div class="widget-box widget-color-blue">
				<div class="widget-header">
					<h4 class="widget-title lighter">#dateformat(rc.startDate,"MMMM yyyy")# => #dateformat(rc.endDate,"MMMM yyyy")#<h4>
				</div>
				<div class="widget-body">
					<div class="widget-main no-padding">
						<table id="po3" class="table table-hover datatable table-bordered">
							<thead>
								<tr>
        							<th rowspan="2">STT</th>
        							<th rowspan="2">Name</th>
        							<th rowspan="2">Start</th>
        							<th rowspan="2">A/L</th>
        							<th rowspan="2">S/L</th>
        							<cfloop array=#rc.months# index="monthAsString">
							        <th colspan="2">#monthAsString#</th>
        							</cfloop>
							        <!--- <th colspan="2">February</th>
									<th colspan="2">March</th>
									<th colspan="2">April</th>
									<th colspan="2">May</th>
									<th colspan="2">June</th>
									<th colspan="2">July</th>
									<th colspan="2">August</th> --->
									<th rowspan="2">A/L Off</th>
									<th rowspan="2">S/L Off</th>
									<th rowspan="2">A/l exist</th>
									<th rowspan="2">S/L exist</th>
							    </tr>
							    <tr>
							        <th>A/L</th>
							        <th>S/L</th>
							        <th>A/L</th>
							        <th>S/L</th>
							        <th>A/L</th>
							        <th>S/L</th>	
							        <th>A/L</th>
							        <th>S/L</th>
							        <th>A/L</th>
							        <th>S/L</th>
							        <th>A/L</th>
							        <th>S/L</th>
							        <th>A/L</th>
							        <th>S/L</th>
									<th>A/L</th>
							        <th>S/L</th>
							    </tr>	
							</thead>
							<tbody>
									<cfif structKeyExists(rc, "report")>
										<cfset stt = 1>
										<cfloop array="#rc.report#" index="rep">
											<tr>
												<td>#stt#</td>
												<td>#rep.firstname# #rep.lastname#</td>
												<td>#rep.startTime#</td>
												<td>#rep.alOffTotal#</td>
												<td>#rep.sloffTotal#</td>
												<cfloop from="1" to="8" index="i">
													<td>#rep["al"&i]+rep["aba"&i]#</td>
													<td>#rep["sba"&i]#</td>
												</cfloop>
												<!--- <td>0</td>
												<td>0</td>
												<td>0</td>
												<td>0</td>
												<td>0</td>
												<td>0</td>
												<td>0</td>
												<td>0</td>
												<td>0</td>
												<td>0</td>
												<td>0</td>
												<td>0</td>
												<td>0</td>
												<td>0</td>
												<td>0</td>
												<td>0</td> --->
												<td>#rep.alOff#</td>
												<td>#rep.sloff#</td>
												<td>#rep.alOffTotal - rep.alOff#</td>
												<td>#rep.sloffTotal - rep.sloff#</td>
											</tr>
											<cfset stt = stt+1>
										</cfloop>
									</cfif>
								</tr>
							</tbody>
		                    </tfoot>
						</table>

					</div>
				</div>
			</div>
		</div>
	</div>
</cfoutput>