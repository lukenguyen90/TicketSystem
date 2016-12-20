<cfoutput>
	<cfset request.layout = false>
<cfif rc.hasEntry>
	<cfset sub = "Daily Report #dateFormat(now(),"dd-mm-yyyy")#">
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
			.ticket{
			text-align: left;
		}
	.myprogressbar {
		width:90%;
      	background-color: ##d5eaf0;
      	border-radius: 13px; /* (height of inner div) / 2 + padding */
      	padding: 0px;
    }
    
    .myprogressbar > .myprogressbar2 {
       	background-color: ##66a9bd;
       	height: 10px;
       	border-radius: 10px;
    }
    .marginleft {
    	margin-left: 10px;
    }
    .not-working{
    	text-decoration: none;
    }
    .not-working:hover{
    	color: red;
    }
	</style>
	<h2 style="text-align:center">#sub#</h2>
	<h2>Project Time</h2>
	<div class="marginleft">
		<cfloop query="#rc.projectTime#">
			<b>#rc.projectTime.projectName#</b> - #int(rc.projectTime.time/60)#h#(rc.projectTime.time mod 60)#
			<div class="myprogressbar">
				<div class="myprogressbar2" style="width:#rc.projectTime.time/1156*100#%"></div>
			</div>
		</cfloop>
	</div>
	<h2>User Time</h2>
	<div class="marginleft">
		<cfloop query=#rc.userTime#>
			<b>#rc.userTime.firstname# #rc.userTime.lastname#</b> - #int(rc.userTime.time/60)#h#(rc.userTime.time mod 60)#
			<div class="myprogressbar">
				<div class="myprogressbar2" style="width:#rc.userTime.time/600*100#%"></div>
			</div>
		</cfloop>
		<b>Not working today :</b>
		<br><cfset isFirst = ''>
		<cfloop query="rc.notWorkingUser" >
			#isFirst#<a href="mailto:#rc.notWorkingUser.email#" class="not-working">#rc.notWorkingUser.name# </a><cfset isFirst = ', '>
		</cfloop>
	</div>
	<h2>Tasks Worked On</h2>
	<table>
		<thead>
			<tr>
				<th>User</th>
				<th>Project</th>
				<th>Ticket</th>
				<th>Log time</th>
				<th>Total Time</th>
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
				<cfset fustring = '<td rowspan="'&user.row&'">'&user.username&'</td>'>
				<cfset ttstring = '<td rowspan="'&user.row&'">'&int(user.totalTime/60)&'h'&(user.totalTime mod 60)&'</td>'>
				<cfloop array=#user.projects# index="project">
					<cfset fpstring = '<td rowspan="'&project.row&'">'&project.projectname&'</td>'>
					<cfloop array=#project.tickets# index="ticket">
						<cfset ftstring = '<td rowspan="'&ticket.row&'" class="ticket">'&ticket.ticketname&'</td>'>
						<cfset tistring = '<td rowspan="'&ticket.row&'">'&int(ticket.logtime/60)&'h'&(ticket.logTime mod 60)&'</td>'>						
							<tr #oddString#>
								#fustring# <cfset fustring = "">
								#fpstring# <cfset fpstring = "">
								#ftstring# <cfset ftstring = "">
								#tistring# <cfset tistring = "">
								#ttstring# <cfset ttstring = "">
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