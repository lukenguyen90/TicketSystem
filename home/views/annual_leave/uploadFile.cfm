<cfoutput>
	<cfif structKeyExists(rc,"uploadFile")>
		<cffile action="upload" fileField="uploadFile"  destination="#expandpath("/data_Finger")#" nameconflict="overwrite" accept="text/plain, application/vnd.ms-excel" result="fileCheckin">

		<cffile action="read" file="#expandpath("/data_Finger/")##fileCheckin.serverfile#" variable="csvfile">
			<!--- set timekeeper database --->
			<cfquery name = "qGettimekeeper">
				SELECT *
				FROM timekeeper
			</cfquery>

			<cfset rc.listExist = {}>
			<cfset rc.listLate = {}>
			<cfloop query="qGetTimekeeper">
				<cfif not structKeyExists( rc.listExist, qGetTimekeeper.userid )>
					<cfset rc.listExist[qGetTimekeeper.userid] = {}>
				</cfif>

				<cfset rc.listExist[qGetTimekeeper.userid][dateFormat(qGettimekeeper.import_date,"yyyy-mm-dd")] = qGettimekeeper.import_date>
			</cfloop>
			<!--- get userid by badgenumber --->
			<cfquery name = "qGetUserByBadgeNumber">
				SELECT * 
				FROM timekeeper_users
			</cfquery>
			<cfset rc.timekeeper_users = {} >
			<cfloop query="qGetUserByBadgeNumber">
				<cfset rc.timekeeper_users[qGetUserByBadgeNumber.badgeNumber] = qGetUserByBadgeNumber.userid >
			</cfloop>
			<!--- get content of file --->
			<cfset rc.listTemp = {} >
			<cfset FileLines = listtoarray(csvfile,"#chr(13)##chr(10)#")>
			<cfloop from="2" to="#arrayLen(FileLines)#" index="i">
				<cfset badgeNumber = listgetat(FileLines[i],2) >
				<cfset userName = listgetat(FileLines[i],3) >
				<cfset login = dateTimeFormat( listgetat(FileLines[i],4),"yyyy-mm-dd HH:nn:ss" )>
				<cfset logout = dateTimeFormat( listgetat(FileLines[i],5),"yyyy-mm-dd HH:nn:ss" )>
				<cfset impDate = dateFormat( listgetat(FileLines[i],6),"yyyy-mm-dd" )>
				<cftry>
				<cfset userID = rc.timekeeper_users[badgeNumber] >
				<cfcatch type="any" name="e">
					<cfcontinue />
				</cfcatch>
				</cftry>

				<cfif not structKeyExists(rc.listExist,userID)>
					<cfset rc.listExist[userID] = {}>
				</cfif>

				<cfif not structKeyExists( rc.listExist[userID] , impDate )>
					<cfset rc.listTemp[userID&"-"&impDate] = {
						'userid' : userID,
						'badgenumber':badgeNumber,
						'name' : userName,
						'login' : login,
						'logout' : logout,
						'import_date': impDate
					}>

					<cfscript>
						var logTime = LSDATETIMEFORMAT(login,'HH:nn');
						if(logTime > "09:00" and logTime < "10:00")
						{
							if(not structKeyExists(rc.listLate,userID))
							{
									rc.listLate[userID] = {};
									rc.listLate[userID][month(login)] = [];
									arrayAppend(rc.listLate[userID][month(login)], day(login));
							}
							else
							{
								if(isNull(rc.listLate[userID][month(login)]))
								{
									rc.listLate[userID][month(login)] = [];
									arrayAppend(rc.listLate[userID][month(login)], day(login));
								}
								else
								{
									arrayAppend(rc.listLate[userID][month(login)], day(login));
								}
							}
						}
					</cfscript>		
				</cfif>
				
			</cfloop>
			<cfloop collection="#rc.listLate#" item="uID">
				<cfscript>
					var userInfo = entityLoad('dayoff',{userId:uID},true);
					var lateInfo = userInfo.getLate();
					if(isNull(lateInfo))
					{
						for(l in rc.listLate[uID]) {
							var lateNew = {};
							lateNew[l] = rc.listLate[uID][l];
						}
						userInfo.setLate(SerializeJSON(lateNew));
						entitySave(userInfo);
					}
					else
					{
						lateInfo = DeserializeJSON(lateInfo);
						for(l in rc.listLate[uID]) {
							if(structKeyExists(lateInfo, l))
								arrayAppend(lateInfo[l], rc.listLate[uID][l],true);
							else
								lateInfo[l] = rc.listLate[uID][l];

							userInfo.setLate(SerializeJSON(lateInfo));
							entitySave(userInfo);
						}
					}
				</cfscript>
			</cfloop>

			<cfloop collection=#rc.listTemp# item="data">
				<cfquery name="insertomain">
					INSERT INTO timekeeper(userid, badgenumber, name, login, logout, import_date)
					VALUES ( '#rc.listTemp[data].userid#', '#rc.listTemp[data].badgeNumber#', '#rc.listTemp[data].name#', '#rc.listTemp[data].login#', '#rc.listTemp[data].logout#', '#rc.listTemp[data].import_date#')
				</cfquery>
			</cfloop>
	</cfif>
	<div class="page-header">
		<div class="row">
		<h1 class="col-xs-12 col-md-6">
			#getLabel("Upload file", #SESSION.languageId#)#
		</h1>
		</div>
	</div>
	<div class="row">
		<div class="col-xs-12 col-md-6">
			<form enctype="multipart/form-data" method="post" class="form-inline">
				<div class="form-group">
					<div class="col-xs-12">
						<input type="file" id="id-input-file-2" name="uploadFile"  accept=".txt" />
					</div>
				</div>
				<button type="submit" class="btn btn-info"/> <span class="glyphicon glyphicon-upload"></span>  Upload</button>
			</form>
		</div>
	</div>
</cfoutput>
<script type="text/javascript">
</script>