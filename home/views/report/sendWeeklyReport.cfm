<cfoutput>
	<cfset request.layout = false>
<cfif rc.hasEntry>
	<cfset sub = "Weekly Report #dateFormat(rc.FirstWeekDay,'dd-mm-yyyy')# - #dateFormat(rc.LastWeekDay,'dd-mm-yyyy')#">
	<cfmail from="ticket@rasia.info" to="#rc.cc#" subject="#sub#" type="html" >
		<!--- mail content --->
	<!DOCTYPE html>
	<html lang="en">
	<head>
		<title>Ticket System #sub#</title>
	</head>
	<body>
	<style type="text/css">
	/* ---- Some Resets ---- */
	table, caption, td, tr, th {
		margin:0;
		padding:0;
		font-weight:normal;
		}	
	/* ---- Table ---- */
	table {
		border-collapse:collapse;
		margin-bottom:15px;
		width:90%;
		}
		
		caption {
			text-align:left;
			font-size:15px;
			padding-bottom:10px;
			}
		
		table td,
		table th {
			text-align: center;
			padding:5px;
			border:1px solid ##fff;
			border-width:0 1px 1px 0;
			}
			
		thead th {
			background:##91c5d4;
			}
				
			thead th[colspan],
			thead th[rowspan] {
				background:##66a9bd;
				}
			
		tbody th,
		tfoot th {
			text-align:left;
			background:##91c5d4;
			}
			
		tbody td,
		tfoot td {
			text-align:center;
			background:##d5eaf0;
			}
			
		tfoot th {
			background:##b0cc7f;
			}
			
		tfoot td {
			background:##d7e1c5;
			font-weight:bold;
			}
				
		tbody tr.odd td { 
			background:##bcd9e1;
			}
		.time{
			color: red;
		}
		.ticket{
			text-align: left;
		}
	.myprogressbar {
		width:90%;
      	background-color: ##D3DFE3;
      	border-radius: 13px; /* (height of inner div) / 2 + padding */
      	padding: 0px;
    }
    
    .myprogressbar > .myprogressbar2 {
       	background-color: ##66a9bd;
       	height: 10px;
       	border-radius: 10px;
    }
    .total-time .myprogressbar2{
    	background-color: ##149AF0;
    }
    .marginleft {
    	margin-left: 10px;
    }
    .not-working{
    	color: ##FC938F;
    	cursor: pointer;
    }
	</style>
	<h2 style="text-align:center">#sub#</h2>

	<h2>Project Time</h2>
	<div class="marginleft">
		<cfloop query="#rc.projectTime#">
			<b>#rc.projectTime.projectName#</b> - #int(rc.projectTime.time/60)#h#(rc.projectTime.time mod 60)#
			<div class="myprogressbar">
				<div class="myprogressbar2" style="width:#rc.projectTime.time/12000*100#%"></div>
			</div>
		</cfloop>
	</div>

	<h2>User Time</h2>
	<div class="marginleft">
		<!--- <cfloop query=#rc.userTime#>
			<b>#rc.userTime.firstname# #rc.userTime.lastname#</b> - #int(rc.userTime.time/60)#h#(rc.userTime.time mod 60)#
			<div class="myprogressbar">
				<div class="myprogressbar2" style="width:#rc.userTime.time/3000*100#%"></div>
			</div>
		</cfloop> --->
		<table>
			<thead>
				<tr>
					<th>User</th>
					<th>Total</th>
					<th>Monday #dateFormat(rc.FirstWeekDay,'dd-mm')#</th>
					<th>Tuesday #dateFormat(dateAdd('d',1,rc.FirstWeekDay),'dd-mm')#</th>
					<th>Wednesday #dateFormat(dateAdd('d',2,rc.FirstWeekDay),'dd-mm')#</th>
					<th>Thursday #dateFormat(dateAdd('d',3,rc.FirstWeekDay),'dd-mm')#</th>
					<th>Friday #dateFormat(dateAdd('d',4,rc.FirstWeekDay),'dd-mm')#</th>
				</tr>
			</thead>
			<tbody>
				<cfset odd = false >
				<cfloop array=#rc.data_usertime# index="user">
					<cfif odd>
						<cfset oddString = 'class="odd"'><cfset odd = false >
					<cfelse>
						<cfset oddString = ''><cfset odd = true >
					</cfif>
					<tr #oddString#>
						<td >#user.username# </td>
						<td class="total-time"style="width : 15% ;">
							<cfset titleTime = user.logtime gt 0 ? ('Logs : '&int(user.logtime/60)&"h"&(user.logtime mod 60) & "'" ): 'Not working .'>
							<div class="myprogressbar" title="#titleTime#">
								<div class="myprogressbar2 " style="width:#user.logtime/600*100#%"></div>
							</div>
						</td>
						<cfloop array=#user.tickets# index="working">
							<td style="width : 12% ;">
								<cfset titleTime = working gt 0 ? ('Logs : '&int(working/60)&"h"&(working mod 60) &"'" ): 'Not working .'>
								<div class="myprogressbar" title="#titleTime#">
									<div class="myprogressbar2" style="width:#working/600*100#%"></div>
								</div>
							</td>
						</cfloop>
					</tr>
				</cfloop>
				<cfloop query="rc.notWorkingUser" >
						<cfif odd>
							<cfset oddString = 'class="odd"'><cfset odd = false >
						<cfelse>
							<cfset oddString = ''><cfset odd = true >
						</cfif>
					<tr #oddString#>
						<td >#rc.notWorkingUser.name# </td>
						<td class="not-working">Not working</td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
				</cfloop>
			</tbody>
		</table>
	</div>

	<h2>Tasks Worked On</h2>
	<table class="marginleft">
		<thead>
			<tr>
				<th>User</th>
				<th>Project</th>
				<th>Monday #dateFormat(rc.FirstWeekDay,'dd-mm')#</th>
				<th>Tuesday #dateFormat(dateAdd('d',1,rc.FirstWeekDay),'dd-mm')#</th>
				<th>Wednesday #dateFormat(dateAdd('d',2,rc.FirstWeekDay),'dd-mm')#</th>
				<th>Thursday #dateFormat(dateAdd('d',3,rc.FirstWeekDay),'dd-mm')#</th>
				<th>Friday #dateFormat(dateAdd('d',4,rc.FirstWeekDay),'dd-mm')#</th>
			</tr>
		</thead>
		<tbody>
			<cfset odd = false >
			<cfloop array=#rc.data# index="user">
				<cfif odd>
					<cfset oddString = 'class="odd"'><cfset odd = false >
				<cfelse>
					<cfset oddString = ''><cfset odd = true >
				</cfif>
				<cfset fustring = '<td rowspan="'&user.row&'">'&user.username&' <h6 class="time">Log: <i>#int(user.logtime/60)#h#(user.logtime mod 60)#''</i></h6></td>'>
				<cfloop array=#user.projects# index="project">
					<cfset fpstring = '<td rowspan="'&project.row&'">'&project.projectname&'</td>'>
					
					<cfloop from="1" to="#project.row#" index="ticket">
					<tr #oddString#>
						#fustring# <cfset fustring = "">
						#fpstring# <cfset fpstring = "">
						<cfloop from="1" to="5" index="weekday">
							<cfif ArrayIsDefined(project.tickets[weekday],ticket)>
								<td class="ticket"><span class="time">Log:<i>#int(project.tickets[weekday][ticket].logtime/60)#h#(project.tickets[weekday][ticket].logtime mod 60)#'</i></span> #project.tickets[weekday][ticket].name#</td>
							<cfelse>
								<td></td>
							</cfif>
						</cfloop>
					</tr>
					</cfloop>
				</cfloop>
			</cfloop>
		</tbody>
	</table>
		<!--- end mail content --->
	</cfmail>
</cfif>
</cfoutput>