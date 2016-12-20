<cfscript>
	var user=QueryExecute("SELECT *
						FROM users u
						WHERE u.userId="&SESSION.userID);
</cfscript>
<script type="text/javascript">
 
	$(document).ready(function(){

	    jQuery('ul li').each(function() {
		    var href = jQuery(this).find('a').attr('href');

		    var iurl=(window.location.pathname+window.location.search);

		    if (href === iurl) {
		        jQuery(this).addClass('active');
		    }

		    if(iurl === "/index.cfm/" || iurl === "index.cfm" || iurl === "/"){
		    	$('#liDashboard').parent().addClass('active');
		    }
	    });
 	});  
</script>

<aside id="left-panel">

	<!-- User info -->
	<div class="login-info">
		<span> <!-- User image size is adjusted inside CSS, it should stay as it --> 
			<cfoutput>
				<cfset avatar="">
				<cfif user.avatar EQ "">
					<cfset avatar = "/fileupload/avatars/default.jpg">
				<cfelse>
					<cfif FileExists(expandPath("/fileupload/avatars/")&user.avatar)>
						<cfset avatar ="/fileupload/avatars/#user.avatar#">
					<cfelse>
						<cfset avatar ="/fileupload/avatars/default.jpg">
					</cfif>
					
				</cfif>
				<a href="javascript:void(0);" id="show-shortcut" data-action="toggleShortcut">
					<img src="#avatar#" alt="me" class="online" /> 
					<span>
						#user.firstname# #user.lastname#
					</span>
				</a> 
			</cfoutput>
			
		</span>
	</div>
	<!-- end user info -->

	<!-- NAVIGATION : This navigation is also responsive-->
	<nav>
		<ul>
			<li class="">
				<a href="/index.cfm/manager" title="Dashboard"><i class="fa fa-lg fa-fw fa-home"></i> <span class="menu-item-parent">Dashboard</span></a>
			</li>
			<li class="">
				<a href="/index.cfm/manager.editEmployer" title="Dashboard"><i class="fa fa-lg fa-fw fa-group"></i> <span class="menu-item-parent">Add employer</span></a>
			</li>
			<li class="">
				<a href="/index.cfm/manager.addAnnualleave" title="Dashboard"><i class="fa fa-lg fa-fw fa-group"></i> <span class="menu-item-parent">Add Annual Leave</span></a>
			</li>
			<li class="">
				<a href="/index.cfm/manager.addOt" title="Dashboard"><i class="fa fa-lg fa-fw fa-group"></i> <span class="menu-item-parent">Add Overtime</span></a>
			</li>
			<li>
				<a><i class="fa fa-lg fa-fw fa-bar-chart-o"></i> <span class="menu-item-parent">Requirement</span></a>
				<ul>
					<li>
						<a href="/index.cfm/manager.annual_Leave">Annual Leave</a>
					</li>
					<li>
						<a href="/index.cfm/manager.overtime">Over Time</a>
					</li>
					<li>
						<a href="/index.cfm/manager.urgent">Urgent Case Off</a>
					</li>
				</ul>
			</li>
			<!--- <li class="">
				<a  title="Check in"><i class="fa fa-lg fa-fw fa-bar-chart-o"></i> <span class="menu-item-parent">Check In</span></a>
				<ul>
					<li>
						<a href="/index.cfm/manager.checkin_monthly">Monthly report</a>
					</li>
					<li>
						<a href="/index.cfm/manager.checkin_monthly">Print PDF</a>
					</li>
					<li>
						<a href="/index.cfm/manager.holiday">Holiday</a>
					</li>
				</ul>
			</li> --->
			<li class="">
				<a href="/index.cfm/manager.log" title="Dashboard"><i class="fa fa-lg fa-fw fa-group"></i> <span class="menu-item-parent">Log</span></a>
			</li>
		</ul>
	</nav>
	<div class="div_minifyme">
		<span class="minifyme" data-action="minifyMenu"> 
			<i class="fa fa-arrow-circle-left hit"></i> 
		</span>
	</div>
	

</aside>
<!-- END NAVIGATION -->