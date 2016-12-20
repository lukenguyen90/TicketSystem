		<cfset SESSION.userType		 = 0>
		<cfset Session.isLoggedIn    = false>
		<cfset Session.name          = "">
		<cflocation url="#getContextRoot()#/index.cfm/login:" addtoken="false">
		