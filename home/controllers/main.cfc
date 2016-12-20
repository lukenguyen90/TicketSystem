component output="false" displayname=""  {

	public function init(required any fw){
		variables.fw =fw;
		return this;
	}
	public function default(struct rc){		
		if(structKeyExists(URL,"search")){
			if(URL.search neq ""){
				var searchString=replace(URL.search,"+"," ","all");
				var queryString="t.code ='"&searchString&"' "  ;
				var query= QUERYEXECUTE("SELECT t.code
											FROM tickets t
											WHERE "&queryString);
				if(query.recordcount eq 1){
					GetPageContext().getResponse().sendRedirect("/index.cfm/ticket?id="&query.code );		
				}else{
					if(SESSION.userType eq 3){
						query= QUERYEXECUTE("SELECT projectID
										FROM projects p 
										WHERE p.shortName='"&searchString&"' OR p.code = '"&searchString&"' OR p.projectName = '"&searchString&"'");
					}else{
						query= QUERYEXECUTE("SELECT projectID
										FROM projects p 
										LEFT JOIN projectUsers pu 
										ON p.projectID = pu.projects_projectID
										WHERE p.projectStatusID != 6 AND pu.users_userID = '#SESSION.userID#' AND (p.shortName='"&searchString&"' OR p.code = '"&searchString&"' OR p.projectName = '"&searchString&"')");
					}
					if(query.recordcount eq 1){
						GetPageContext().getResponse().sendRedirect("/index.cfm/project/?pid="&query.projectID );		
					}
				}
			}
		}
		switch(SESSION.userType){
			case 1:
				rc.listProject=QUERYEXECUTE("SELECT projectID,code,projectName 
										FROM projectUsers pu 
										LEFT JOIN projects p 
										ON pu.projects_projectID = p.projectID
										WHERE p.active = 1 AND users_userID = "&SESSION.userID&" AND p.projectStatusID != 6 ORDER BY p.projectName");
				rc.listReporter=QUERYEXECUTE("SELECT userID,
													firstname,
													lastname 
												FROM users 
												WHERE userID="&SESSION.userID&"
												ORDER BY firstname, lastname asc");
			break;
			case 2:
				rc.listProject=QUERYEXECUTE("SELECT projectID,code,projectName 
										FROM projectUsers pu 
										LEFT JOIN projects p 
										ON pu.projects_projectID = p.projectID
										WHERE p.active = 1 
											AND users_userID = "&SESSION.userID&" 
											AND p.projectStatusID != 6 
										ORDER BY p.projectName");
				rc.listReporter=QUERYEXECUTE("SELECT userID,
													firstname,
													lastname 
											FROM users 
											WHERE active = 1
											ORDER BY firstname, lastname asc");
			break;
			default:
				rc.listProject=QUERYEXECUTE("SELECT projectID,code,projectName FROM projects WHERE active = 1 AND projectStatusID != 6 ORDER BY projectName");
				rc.listReporter=QUERYEXECUTE("SELECT userID,
													firstname,
													lastname 
												FROM users 
												WHERE active = 1
												ORDER BY firstname, lastname asc");
			break;
		}
		rc.listStatus=QUERYEXECUTE("SELECT statusID,statusName FROM status ");
		rc.listAssignee=QUERYEXECUTE("SELECT userID,
											firstname,
											lastname 
										FROM users u 
										LEFT JOIN usertype ut 
										ON u.userTypeID = ut.userTypeID
										WHERE ut.userType='Admin' OR ut.userType='Programmer' 
										ORDER BY firstname, lastname asc");
	}

	function loadTicketInfo(string code) {
		ticketinfo = QueryExecute("SELECT tic.*, pro.projectLeadID AS leadProject,pro.code AS pCode, pri.priorityName, 
			pri.color AS pri_color, sta.statusName, sta.color sta_color,
			ty.typeName,CONCAT(ver.versionName,' ',ver.versionNumber) AS versionTicket, 
			CONCAT(reus.firstname,' ',reus.lastname) AS refullname, 
			CONCAT(tester.firstname,' ',tester.lastname) AS testerfullname, 
			CONCAT(assign.firstname,' ',assign.lastname) AS assignfullname,projectName,
			mo.moduleName, so.solutionName, so.color AS so_color,
			e.*
			FROM tickets tic
			LEFT JOIN tickettypes ty ON ty.ticketTypeID=tic.ticketTypeID
			LEFT JOIN versions ver ON ver.versionID=tic.versionID
			LEFT JOIN users reus ON reus.userID = tic.reportedByUserID
			LEFT JOIN users assign ON assign.userID = tic.assignedUserID
			LEFT JOIN users tester ON tester.userID = tic.testerUserID
			LEFT JOIN projects pro ON tic.projectID=pro.projectID
			LEFT JOIN priority pri ON tic.priorityID=pri.priorityID
			LEFT JOIN `status` sta ON tic.statusID = sta.statusID
			LEFT JOIN modules mo ON tic.moduleID=mo.moduleID
			LEFT JOIN resolution so on tic.solutionID=so.solutionID
			LEFT JOIN epic e on tic.epicID = e.epicID
			WHERE tic.code = '"& code&"'");
		return ticketinfo;
	}
	public function todo(struct rc){
		if(SESSION.userType eq 3){
			rc.listProject=QUERYEXECUTE("SELECT projectID,shortName,projectName,color,(SELECT count(ticketID)
															FROM tickets WHERE projectID = p.projectID AND assignedUserID = "&SESSION.userID&" AND (statusID = 1 OR statusID = 2 OR statusID = 4) ) AS tickets 
										FROM projects p WHERE p.projectStatusID != 6 AND active = 1
										GROUP BY p.projectID 
										ORDER BY tickets DESC, p.projectName");
		}else{
			rc.listProject=QUERYEXECUTE("SELECT projectID,shortName,projectName,color,(SELECT count(ticketID) 
				FROM tickets WHERE projectID = p.projectID AND assignedUserID = "&SESSION.userID&" AND (statusID = 1 OR statusID = 2 OR statusID = 4) ) AS tickets 
										FROM projects p 
										LEFT JOIN projectUsers pu 
										ON pu.projects_projectID = p.projectID
										WHERE p.projectStatusID != 6 AND p.active = 1 AND users_userID = "&SESSION.userID&" GROUP BY p.projectID ORDER BY tickets DESC, p.projectName");
		}
	}
	function loadTodoTicket(struct rc){
		if(structKeyExists(rc,'pId')){
			if(rc.pId neq 0){
				rc.listTicket = QueryExecute(sql:"
					SELECT DISTINCT t.ticketID,t.title,t.code,t.statusID,t.isLogStart,t.statusID, t.assignedUserID,
						p.color, p.projectID,
						solu.solutionName,
						solu.solutionID,
						(SELECT SUM(hours)*60+SUM(minute) as minute FROM timeentries te WHERE te.ticketID = t.ticketID) AS logged,
						t.isInDay 
					FROM tickets t
					LEFT JOIN projects p ON t.projectID = p.projectID
					LEFT JOIN resolution solu on t.solutionID = solu.solutionID
					WHERE t.projectID = :pId AND t.assignedUserID = :uId AND (t.statusID = 4 OR t.statusID = 2 OR t.statusID = 1)
					ORDER BY t.statusID DESC ",
					params:{
						pId:{ value = rc.pId ,CFSQLType = 'NUMERIC' },
						uId:{ value = SESSION.userID 	,CFSQLType = 'NUMERIC' }
				});
				rc.listTicketResolved = QueryExecute(sql:"
					SELECT DISTINCT t.ticketID,t.title,t.code,t.statusID,t.isLogStart,t.statusID, t.assignedUserID,
						p.color, p.projectID,
						solu.solutionName,
						solu.solutionID,
						(SELECT SUM(hours)*60+SUM(minute) as minute FROM timeentries te WHERE te.ticketID = t.ticketID) AS logged 
					FROM tickets t
					LEFT JOIN projects p ON t.projectID = p.projectID
					LEFT JOIN resolution solu on t.solutionID = solu.solutionID
					WHERE t.assignedUserID = :uId AND t.statusID = 5  AND DATE_FORMAT(t.resovldDate,'%Y-%m-%d') =  DATE_FORMAT(now(),'%Y-%m-%d')
					ORDER BY t.statusID DESC ",
					params:{
						pId:{ value = rc.pId ,CFSQLType = 'NUMERIC' },
						uId:{ value = SESSION.userID 	,CFSQLType = 'NUMERIC' }
				});
				
				if(rc.listTicket.recordcount eq 0){
					rc.message = "No ticket to show!";
				}
			}else{
				rc.message = "No ticket to show!";
			}

			rc.listProjectUsers = QueryExecute("SELECT DISTINCT us.userID,CONCAT(us.firstname,' ',us.lastname) AS fullname,avatar 
											from projectUsers pro 
											left join users us 
											on pro.users_userID = us.userID
											where us.active = 1 and pro.projects_projectID = "&rc.pId&" and us.userID <> "&SESSION.userID);
		
		}

	}

	function getListUsersByName (struct rc) {
		if(rc.strName != "") {
			rc.listProjectUsers = QueryExecute("SELECT DISTINCT us.userID,CONCAT(us.firstname,' ',us.lastname) AS fullname,avatar 
											from projectUsers pro 
											left join users us 
											on pro.users_userID = us.userID
											where us.active = 1 and pro.projects_projectID = "&rc.pId&" and us.firstname like '" & rc.strName & "%'");
		}
		else {
			rc.listProjectUsers = QueryExecute("SELECT DISTINCT us.userID,CONCAT(us.firstname,' ',us.lastname) AS fullname,avatar 
											from projectUsers pro 
											left join users us 
											on pro.users_userID = us.userID
											where us.active = 1 and pro.projects_projectID = "&rc.pId);
		}
		variables.fw.renderData('json', rc.listProjectUsers);
	}
	function activeTracker(struct rc){
		if(structKeyExists(rc,'tId')){
			try{
				var tracker = entityLoad("logworktracker",{user:entityLoadByPk("users",SESSION.userID),isFinish:false},true);
				var message = "";
				if(not isNull(tracker) ){
					var oldTicket = tracker.getTicket();
					var sleep = dateDiff("n", datetimeformat(tracker.getupdateTime(),'yyyy-mm-dd HH:nn'), datetimeformat(now(),'yyyy-mm-dd HH:nn') );
					tracker.setUpdateTime(now());
					if(tracker.isPause){
						var totalPause = tracker.getTotalPause() + sleep ;
						tracker.setTotalPause(totalPause);
					}else{
						var totalWorked = tracker.getTotalWorked() + sleep ;
						tracker.setTotalWorked(totalWorked);
					}
					if(oldTicket.getTicketID() eq rc.tId ){
						tracker.setIsPause(false);
						tracker.setAcceptTime(now());
						return variables.fw.renderData("json",{
								'success':true,
								'ticket':{'title':oldTicket.title,'code':oldTicket.code},
								'trackID':tracker.trackerID,
								'hou':int(tracker.getTotalWorked()/60),
								'min':(tracker.getTotalWorked() mod 60),
								'startTime':datetimeFormat(tracker.startTime,"yyyy-mm-dd HH:nn")
							});
					}else{
						// finish last tracker
						tracker.setFinishTime(now());
						tracker.setIsFinish(true);
						entitySave(tracker);
						// reset tracker time 
						var whour = tracker.GetTotalWorked() gt 240 ? 240 : tracker.GetTotalWorked() ;
						// add new time entry
						var entry = entityNew("timeEntries");
					    entry.setDateEntered(now());
					    entry.setEntryDate(dateFormat(tracker.getStartTime(),"yyyy-mm-dd"));
					    entry.setHours(int(whour / 60));
					    entry.setMinute(int(whour mod 60));
					    entry.setDescription(tracker.getDescription());
					    entry.setTicket(oldTicket);
					   	entry.setUser(entityLoadbyPK("users",SESSION.userID));
					    entry.setWorkType(entityLoadbyPK("workType",1));
					    entry.setType(entityLoadbyPK("typeTimeEntries",2));
					    entry.setLogTracker(tracker);
			   			entitySave(entry);
			   			// un active isLogStart 
			   			oldTicket.setIsLogStart(false);
			   			entitySave(oldTicket);
					}
				}
				// add new tracker 
				var ticket = entityLoadbyPK("tickets",LSParseNumber(rc.tId));
				ticket.setIsLogStart(true);
				entitySave(ticket);
				var newTracker = entityNew("logWorkTracker",{
					startTime : now(),
					updateTime: now(),
					acceptTime: now(),
					isPause : false ,
					isFinish: false ,
					totalPause:0,
					totalWorked:0,
					ticket : ticket,
					user : entityLoadbyPK("users",SESSION.userID)
				});
				entitySave(newTracker);
				return variables.fw.renderData("json",{
						'success':true,
						'ticket':{'title':ticket.title,'code':ticket.code},
						'trackID':newTracker.trackerID,
						'hou':0,
						'min':0,
						'startTime':datetimeFormat(newTracker.startTime,"yyyy-mm-dd HH:nn")
					});
			}catch(any e){
				return variables.fw.renderData("json",{
					'success':false,
					'error':'unknow',
					'message':e.message
					});
			}
		}else{
			return variables.fw.renderData("json",{
				'success':false,
				'error':'missing_ticket'
				});
		}
	}

	function updateTrackerAuto(struct rc){
		var gettracker = entityLoad('logWorkTracker',{isFinish : false });
		for(tracker in gettracker){
			var newWorkedTime = 0 ;
			var newPausedTime = 0 ;
			var iTime = dateDiff("n", datetimeformat(tracker.updateTime,'yyyy-mm-dd HH:nn'), datetimeformat(now(),'yyyy-mm-dd HH:nn'));
			tracker.setUpdateTime(now());
			if(tracker.getIsPause()){
				newPausedTime = tracker.totalPause + iTime ;
				tracker.setTotalPause(newPausedTime);
			}else{
				newWorkedTime = tracker.totalWorked + iTime ;
				tracker.setTotalWorked(newWorkedTime);
			}
			var sleepTime = dateDiff("n", datetimeformat(tracker.acceptTime,'yyyy-mm-dd HH:nn'), datetimeformat(now(),'yyyy-mm-dd HH:nn'));
			if(sleepTime gte 60){
				// pause last tracker
				tracker.setIsPause(true);
			}
			if( datetimeformat(tracker.startTime,'yyyy-mm-dd') neq datetimeformat(now(),'yyyy-mm-dd') ){
				tracker.setFinishTime(now());
				tracker.setIsFinish(true);
				var ticket = tracker.getTicket();
				ticket.setIsLogStart(false);
				entitySave(ticket);
				// reset tracker time 
				var whour = tracker.getTotalWorked() gt 240 ? 240 : tracker.getTotalWorked() ;
				var entry = entityNew("timeEntries");
				entry.setDateEntered(tracker.startTime);
				entry.setEntryDate(tracker.startTime);
				entry.setHours( int(whour / 60) );
				entry.setMinute( int(whour mod 60) );
				entry.setDescription(tracker.description);
				entry.setTicket(ticket);
			   	entry.setUser(tracker.getUser());
				entry.setWorkType(entityLoadbyPK("workType",1));
				entry.setType(entityLoadbyPK("typeTimeEntries",2));
				entry.setLogTracker(tracker);
				entitySave(entry);
			}
			entitySave(tracker);
			ORMflush();
		}
		// abort;
		return;
	}
	function updateTracker(struct rc){
		var notification = '' ;
		var gettracker = entityLoad('logWorkTracker',{user : entityLoadByPk('users',SESSION.userID),isFinish : false });
		if(arrayLen(gettracker) eq 1){
			var tracker = gettracker[1];
			var trackerID = tracker.trackerID;
			var ticket = tracker.getTicket();
			var iSleep = dateDiff("n", datetimeformat(tracker.updateTime,'yyyy-mm-dd HH:nn'), datetimeformat(now(),'yyyy-mm-dd HH:nn'));
			if(tracker.isPause){
				var newPauseTime = tracker.totalPause + iSleep ;
				tracker.setTotalPause(newPauseTime);
				var spautime = (newPauseTime mod 60) & "'";
				if(newPauseTime gt 60){
					spautime = int(newPauseTime / 60) & "h "&spautime;
				}
				notification = "You had one paused ticket ( #spautime# )";
			}else{
				var newWorkedTime = tracker.totalWorked + iSleep ;
				tracker.setTotalWorked(newWorkedTime);
			}
			
			tracker.setUpdateTime(now());
			entitySave(tracker);
			// ORMflush();
			var tmpworked={'hours':int(tracker.totalWorked/60),'minute':int(tracker.totalWorked mod 60)};
			var h = tmpworked.hours lt 10 ? '0'&tmpworked.hours : tmpworked.hours;
			var n = tmpworked.minute lt 10 ? '0'&tmpworked.minute : tmpworked.minute;
			var tmppaused={'hours':int(tracker.totalPause/60),'minute':int(tracker.totalPause mod 60)};
			var h1 = tmppaused.hours lt 10 ? '0'&tmppaused.hours : tmppaused.hours;
			var n1 = tmppaused.minute lt 10 ? '0'&tmppaused.minute : tmppaused.minute;
			var result = {
				'success':true,
				'ticket': {'title':ticket.title,'code':ticket.code},
				'trackID':trackerID,
				'worked':h&':'&n,
				'paused':h1&':'&n1,
				'h':h,
				'n':n,
				'isPause':tracker.isPause?1:0,
				'updateTime':datetimeformat(tracker.updateTime,'yyyy-mm-dd HH:nn'),
				'notification':notification
			};
			return variables.fw.renderData("json",result);
		}else{
			notification = 'What are you doing?';
			return variables.fw.renderData("json",{'success':true,'trackID':'','notification':notification});
		}
	}
	function stopTracker(rc){
		try{
			var tracker = entityLoadByPk('logWorkTracker',rc.trackID);
			// tracker.setDescription(rc.log);
			tracker.setDescription('');
			var iDiffMinute = dateDiff("n", datetimeformat(tracker.updateTime,'yyyy-mm-dd HH:nn'), datetimeformat(now(),'yyyy-mm-dd HH:nn'));
			if(iDiffMinute lt 0){
				return variables.fw.renderData('json',{'success':false,'message':'Something wrong '&datetimeformat(tracker.updateTime,'yyyy-mm-dd HH:nn')&', '&datetimeformat(now(),'yyyy-mm-dd HH:nn')&' : '&iDiffMinute});
			}else{
				if(tracker.isPause){
					var newPauseTime = tracker.totalPause + iDiffMinute;
					tracker.setTotalPause(newPauseTime);
				}else{
					var newWorkedTime = tracker.totalWorked + iDiffMinute;
					tracker.setTotalWorked(newWorkedTime);
				}
				// add new time entry
				if(tracker.totalWorked gte 0 and not tracker.isFinish){
					tracker.setFinishTime(now());
					tracker.setIsFinish(true);
					var ticket = tracker.getTicket();
					ticket.setIsLogStart(false);
					entitySave(ticket);
					// reset tracker time 
					var whour = tracker.totalWorked gt 240 ? 240 : tracker.totalWorked;
					var entry = entityNew("timeEntries");
					entry.setDateEntered(now());
					entry.setEntryDate(tracker.startTime);
					entry.setHours(int(whour / 60));
					entry.setMinute(int(whour mod 60));
					entry.setDescription(tracker.description);
					entry.setTicket(ticket);
				   	entry.setUser(tracker.getUser());
					entry.setWorkType(entityLoadbyPK("workType",1));
					entry.setType(entityLoadbyPK("typeTimeEntries",2));
					entry.setLogTracker(tracker);
					entitySave(entry);
					// if(tracker.totalWorked gt 240 )
						// return variables.fw.renderData('json',{'success':false,'message':'Log time auto down to 4 hours!'});
					// else 
						return variables.fw.renderData('json',{'success':true});
				}else{
					return variables.fw.renderData('json',{'success':false,'message':'Something went wrong,#tracker.isFinish?"log tracker has been done!":"entry time = "&tracker.totalWorked&"  less than 0!"# '});
				}
			}
				
			
		}catch(any e){
			return variables.fw.renderData('json',{'success':false,'message':e.message});
		}
	}
	// end tracker function
	function load(struct rc){
		var queryString="";
		if(structKeyExists(URL,"search")){
			var searchString=replace(URL.search,"+"," ","all");
			queryString&=" (t.title LIKE '%"&searchString&"%' OR t.code LIKE '%"&searchString&"%' OR pj.projectName LIKE '%"&searchString&"%') "  ;
		}
		if(structKeyExists(URL,"epic")){
			var epicString=replace(URL.epic,"+"," ","all");
			queryString&=" e.epicName LIKE '%"&epicString&"%' "  ;
		}
		if(structKeyExists(URL, "pId")){
			var prj = replace(URL.pId,",","','","all");
			queryString&=queryString eq "" ? " pj.projectID in ('"&prj&"')" : " AND pj.projectID in ('"&prj&"')";
		}
		if(structKeyExists(URL, "rpd")){
			queryString&=queryString eq "" ? " date_format(t.reportDate,'%Y-%m-%d') = '"&URL.rpd&"'" : " AND date_format(t.reportDate,'%Y-%m-%d') = '"&URL.rpd&"'";
		}
		if(structKeyExists(URL, "dd")){
			queryString&=queryString eq "" ? " date_format(t.dueDate,'%Y-%m-%d') = '"&URL.dd&"'" : " AND date_format(t.reportDate,'%Y-%m-%d') = '"&URL.dd&"'";
		}
		if(structKeyExists(URL, "st")){
			queryString&=queryString eq "" ? "t.statusID in ("&URL.st&")" : " AND t.statusID in ("&URL.st&")";
		}
		if(structKeyExists(URL, "rp")){
			queryString&=queryString eq "" ? "t.reportedByUserID in ("&URL.rp&")" : " AND t.reportedByUserID in ("&URL.rp&")";
		}
		if(structKeyExists(URL, "as")){
			queryString&=queryString eq "" ? "t.assignedUserID in ("&URL.as&")" : " AND t.assignedUserID in ("&URL.as&")";
		}
		if(queryString neq ""){
			tFrom=URL.page*20;
			if(SESSION.userType eq 3){
				var permission = {join:'',where:''};
			}else{
				var permission = {join:' LEFT JOIN projectUsers pu ON t.projectID = pu.projects_projectID ',where:' AND pu.users_userID = #SESSION.userID #'};
			}
			var tickets= QUERYEXECUTE("
						SELECT DISTINCT(t.ticketID),t.code,pj.color AS pjColor,pj.code as pCode,
						t.priorityID,t.title,date_format(t.dueDate,'%Y-%m-%d') AS date,u1.firstname AS assignee,
						u2.firstname AS reporter,p.color AS pColor,p.priorityName AS priority,s.color AS sColor,
						s.statusName AS status, datediff(now(),t.dueDate) as over, t.statusID, 
						date_format(t.reportDate,'%Y-%m-%d') as rdate,tp.ticketTypeID as typeID, tp.typeName AS type, rs.solutionName AS solution,
						 e.epicName, e.epicColor
						FROM tickets t
						LEFT JOIN users u1
							ON t.assignedUserID=u1.userID
						LEFT JOIN users u2
							ON t.reportedByUserID=u2.userID
						LEFT JOIN priority p
							ON t.priorityID=p.priorityID
						LEFT JOIN status s
							ON t.statusID=s.statusID
						LEFT JOIN projects pj
							ON t.projectID = pj.projectID
						LEFT JOIN resolution rs 
							ON t.solutionID = rs.solutionID
						LEFT JOIN tickettypes tp 
							ON t.ticketTypeID = tp.ticketTypeID
						LEFT JOIN epic e
							ON t.epicID = e.epicID
						#permission.join#
						WHERE "&queryString&" #permission.where#
						ORDER BY  t.statusID ASC, 
							e.epicPriority DESC , 
							date_format(t.reportDate,'%Y-%m-%d') DESC, 
							t.priorityID ASC, t.ticketID DESC, 
							t.resovldDate DESC, 
							t.startDate DESC
						Limit "&tFrom&",21");
			if(tickets.recordcount neq 0){
				local.HTMLString = "";
				for(item in tickets) {
					// insert type flag 
					switch(item.typeID){
						case 1:
							local.typeFlag = '<i class="fa fa-bug red" title="Bug"></i>';
						break;
						case 2:
							local.typeFlag = '<i class="fa fa-level-up green" title="Improvement"></i>';
						break;
						case 3:
							local.typeFlag = '<i class="fa fa-plus-square blue" title="New feature"></i>';
						break;
						case 4:
							local.typeFlag = '<i class="fa fa-search yellow" title="Internal Issue"></i>';
						break;
					
						default:
							local.typeFlag = '<i class="fa fa-at"None></i>';
						break;
					}
					// epic 
						var epicString = item.epicName eq '' ?'': '<span class="pull-right epic epic-'&item.epicColor&'">'&item.epicName&'</span>';
					// over 
					if( item.over gt 0 and (item.statusID eq 1 or item.statusID eq 2 or item.statusID eq 4) and item.priorityID neq 4)
						var overString = '<span style="margin-left: 10px" class="over" title="Over #item.over# days">#item.over#d</span>';
					else 
						var overString = '';
					// end type plag
				   	local.HTMLString &= '<tr>
						<td>
						#local.typeFlag#
						<a href="/index.cfm/ticket?id=#item.code#">
						<span class="#item.pjColor#">#item.code#</span> &nbsp;#item.title#
						#overString#
						</a> #epicString#</td>
						<td>#item.rdate#</td>
						<td>#item.date#</td>
						<td>#item.assignee#</td>
						<td>#item.reporter#</td>
						<td style="color:#item.pColor#">#item.priority#</td>';
					if(item.status eq "Resolved" AND item.solution neq ""){
						local.HTMLString &= '<td><span class="label label-#item.sColor#"> <cfoutput>#getLabel("#item.solution#", #SESSION.languageId#)#</cfoutput></span></td></tr>';
					}else{
						local.HTMLString &= '<td><span class="label label-#item.sColor#"> <cfoutput>#getLabel("#item.status#", #SESSION.languageId#)#</cfoutput></span></td></tr>';
					}
				}
				return variables.fw.renderData("json",{ 'success' : true , 'HTMLString' : local.HTMLString , 'len' : tickets.recordcount});
			}
		}
		return variables.fw.renderData("json",{success:false});
	}
	function newProject(struct rc){
		if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn){
			var query=QueryExecute("SELECT projectID FROM projects WHERE projectName='"&rc.pName&"'");
			if(query.recordcount eq 0){
			var project=entityNew("projects",{				
				projectName	:rc.pName,
				code		:Left(hash(createUUID()&rc.pName), 8),
				shortName	:rc.sName,
				Description	:rc.pDes,
				color		:rc.pColor,
				dueDate		:rc.dDate,
				projectURL	:rc.pUrl,
				budget		:rc.pBudget,
				totalEstimate:rc.pEstimate,
				active		:rc.pActive,
				leader		:entityLoadbyPK("users",LSParseNumber(rc.pLeader)),
			});
			entitySave(project);
			var query = QueryExecute("INSERT INTO versions (`versionName`, `versionNumber`, `versionDate`, `projectID`) 
													VALUES ('Demo', '1.0', '"&DateFormat(now(),"yyyy-mm-dd")&"', "&project.projectID&")");
			var query = QueryExecute("
				INSERT INTO modules 
						(`moduleName`, `description`,`estimate`,`projectID`,`moduleLeadID`,`isPrivate`) 
				VALUES 	( 'default', 'Sprint 1',0,"&project.projectID&","&rc.pLeader&",0 )");
			var query = QueryExecute("
				INSERT INTO projectUsers 
						(`users_userID`, `projects_projectID`) 
				VALUES 	( "&rc.pLeader&", "&project.projectID&" )");
			if(SESSION.userID neq rc.pLeader)
			var query = QueryExecute("
				INSERT INTO projectUsers 
						(`users_userID`, `projects_projectID`) 
				VALUES 	( "&SESSION.userID&", "&project.projectID&" )");
			return variables.fw.renderData("json",project.projectID);
			}
		}
		return variables.fw.renderData("json",false);
	}
	function viewMore(struct rc){
		var abegin=rc.page*5;
		rc.tickets= QUERYEXECUTE("
						SELECT t.ticketID,t.code,pj.code AS pCode,t.title,t.dueDate,u.firstname AS assigner,p.color AS pColor,p.priorityName AS priority,s.color AS sColor,s.statusName AS status
						FROM tickets t
						LEFT JOIN users u
							ON t.assignedUserID=u.userID
						LEFT JOIN priority p
							ON t.priorityID=p.priorityID
						LEFT JOIN status s
							ON t.statusID=s.statusID
						LEFT JOIN projects pj
							ON t.projectID=pj.projectID
						WHERE (userTypeID= 2 OR userTypeID= 3) AND t.projectID= :id 
						ORDER BY t.priorityID ASC , t.statusID ASC , dueDate ASC
						LIMIT "&abegin&",5 ",{id:LSParseNumber(rc.projectID)});
		result=arrayNew(1);
		for(item in rc.tickets) {
		   project={
		   			id:item.ticketID,
		   			code:item.code,
		   			pCode:item.pCode,
		   			title:item.title,
		   			dueDate:dateFormat(item.dueDate,"yyyy-mm-dd"),
		   			assigner:item.assigner,
		   			pColor:item.pColor,
		   			priority:item.priority,
		   			sColor:item.sColor,
		   			status:item.status
		   		};
		   	arrayAppend(result, project)
		}
		return variables.fw.renderData("json",result);
	}
	function unNewAction(struct rc){
		if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn){
			var whereString="";
			for(item in rc.actionID) {
				if(whereString eq ""){
					whereString&="WHERE actionID="&item;
				}else{
					whereString&=" OR actionID="&item;
				}
			}
			try{
				var query=QueryExecute("UPDATE actions SET isNew=b'0' "&whereString);
			}catch(any e){
				return variables.fw.RENDERDATA("json",false);
			}
			return variables.fw.RENDERDATA("json",true);
		}
		return variables.fw.RENDERDATA("json",false);
	}

	function queryToArray(required query inQuery) {
	  	result=arrayNew(1);
	   		for(row in inQuery) {
				item ={};
	    		for(col in querycolumnarray(inQuery)) {
	     			item[col] = row[col];
	    		} 
	       	arrayAppend(result, item);
	   		}
	  	return  result;
	}

	function getTag(struct rc)
	{
		var tags = QueryExecute("SELECT * FROM tags WHERE tagName like '%"&rc.data&"%'");
		var rs = arrayNew(1);
		for (item in tags)
		{
			var d = structNew();
			d.NAME = item.tagName;
			d.tagID = item.tagId;
			arrayAppend(rs, d);
		}
		return variables.fw.renderData("json",rs);
	}


	
	
	function countTime(string idTicket) {
		totalTime = QueryExecute("select sum(ti.hours)*60+sum(ti.minute) AS logtime from timeentries ti where ti.ticketID="&idTicket);
		return (totalTime.logtime > 0)?totalTime.logtime:0;
	}
	

	function loadTicketTypes() {
		listTicketTypes = QueryExecute("select ticketTypeID, typeName from tickettypes");
		return listTicketTypes;
	}
	
	function loadTicketPriority() {
		listTicketPriorities = QueryExecute("select priorityID, priorityName from priority");
		return listTicketPriorities;
	}

	function loadTicketResolution(struct rc) {
		listTicketResolution = QueryExecute("select solutionID as resolutionID, solutionName as resolutionName, color from resolution");
		return listTicketResolution;		
	}

	function loadTicketStatus(string id) {
		listTicketStatuses = QueryExecute("select st.statusID, st.statusName, st.color from `status` st left join statusUserType stu 
											on st.statusID = stu.status_statusID
											where stu.userType_userTypeID="&SESSION.userType);
		return listTicketStatuses;
	}
	
	// function loadProjectUsers(string idProject, string idUser=0) {
	// 	listProjectUsers = QueryExecute("select us.userID,CONCAT(us.firstname,' ',us.lastname) AS fullname,avatar 
	// 										from projectUsers pro 
	// 										left join users us 
	// 										on pro.users_userID = us.userID
	// 										where us.active = 1 and pro.projects_projectID ="& idProject & " and us.userID <>" & idUser);
	// 	return listProjectUsers;
	// }


	function loadTicketFiles(string ticketID) {
		return listTicketFiles = QueryExecute("select fi.fileID, fi.fileLocation, fi.description, fi.group 
			from files fi left join  ticketFiles ticf on ticf.files_fileID=fi.fileID
			WHERE ticf.tickets_ticketID = "&ticketID);
	}
	
	function addEntry(struct rc){

		if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn AND SESSION.isLoggedIn){	
			var dq = rc.description.split(" ");
			var keyWord = entityLoad("typeTimeEntries");
			var type = 4;
			var flag = 0;
			for (var i=1; i<=arrayLen(dq); i++)
			{
				if (flag == 1)
					break;
				for (key in keyWord)
				{
					if (lCase(key.typeName) == lCase(dq[i]))
					{
						flag = 1;
						if (key.parent != 0)
							type = key.parent;
						else type = key.typeTimeEntriesID;
					}
					if (flag == 1)
						break;	
				}
			}
			var user=entityLoadbyPK("users",LsParseNumber(rc.user));
			var entry = entityNew("timeEntries");
		    entry.setDateEntered(now());
		    entry.setEntryDate(rc.entryDate);
		    entry.setHours(rc.hours);
		    entry.setMinute(rc.minute);
		    entry.setDescription(rc.description);
		    entry.setTicket(entityLoadbyPK("tickets",LsParseNumber(rc.ticket)));
		   	entry.setUser(user);
		    entry.setWorkType(entityLoadbyPK("workType",1));
		    entry.setType(entityLoadbyPK("typeTimeEntries",type));
   			entitySave(entry);
   			var totalTime = countTime(rc.ticket);
   			result={
   				id:entry.timeEntryID,
   				userID:rc.user,
   				entryDate:DateFormat(entry.entryDate,"yyyy-mm-dd"),
   				user:user.firstname&" "&user.lastname,
   				hours:entry.hours,
   				minute:entry.minute,
   				description:entry.description,
   				'logtime':totalTime
   			};
			return variables.fw.renderData("json",result);	
		}
	}
	function addFile(){
		if(structKeyExists(rc,"listFile") and structKeyExists(rc,"ticketID")){
			insertFile(rc.ticketID,rc.listFile);
			return variables.fw.renderData("json",true);
		}
		return variables.fw.renderData("json",false);
	}
	function insertFile(ticket,listFile){
		var listFiles= listToArray( listFile,",");
		for(item in listFiles) {
			var tArray=listToArray(item,".");
		   	var type=tArray[arrayLen(tArray)];
			var group="Other";
			group=Find(UCase(type),"JPG|IMG|PNG|JPEG|GIF|TIFF|BMP") neq 0 ?"Image":group;
			group=Find(UCase(type),"PDF") neq 0 ?"Pdf":group;
			group=Find(UCase(type),"DOC|DOCX|") neq 0 ?"Document":group;
			group=Find(UCase(type),"XLS|XLSX|") neq 0 ?"Excel":group;
			group=Find(UCase(type),"PPT|PPTX|") neq 0 ?"Powerpoint":group;
			group=Find(UCase(type),"CSS|HTML|TXT|CFC|CFM|XML") neq 0 ?"Text":group;
		   	file=entityNew("files",{
		   		fileLocation:item,
		   		description:"",
		   		group:group
		   	});
		    entitySave(file);
		   	var query=QueryExecute("INSERT INTO ticketFiles (`files_fileID`, `tickets_ticketID`) VALUES ("&file.fileID&", "&ticket&")");
		}
	}
	function changeTicketStatus(struct rc) {
		// numeric ticketID,numeric oldStatusID, numeric newStatusID,string oldResolutionName,numeric newResolutionID,boolean internal
		var ticketapi = new api.ticket();
		var result = ticketapi.changeStatus(LsParseNumber(rc.ticketID),
											rc.oldStatusID, 
											rc.newStatusID, 
											rc.oldResolutionName, 
											rc.newResolutionID);
		// writeDump(result);
		return variables.fw.renderData('json',result);

	}
	
 	
	function changeTicketAssignee(struct rc) {
		var ticketapi = new api.ticket();
		var result = ticketapi.changeAssignee( LsParseNumber(rc.ticketID) ,LsParseNumber(rc.userID) );
		return variables.fw.renderData('json',result);
	}
	
public void function createNotification(numeric user, numeric activity, string comment){
		var newAction=QueryExecute(sql:"INSERT INTO actions (actionDate,comments,isNew,userID,activityID)
															VALUES(:date,:comments,b'1',:user,:activity)",
			params:{
				date:{value=DateFormat(now(),"yyyy-mm-dd"),CFSQLType='string'},
				comments:{value=comment,CFSQLType='string'},
				user:{value=user,CFSQLType='NUMERIC'},
				activity:{value=activity,CFSQLType='NUMERIC'}
				});
		return;
	}	
	function create(struct rc){
			rc.flag=false;
			if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn){
				if(rc.project neq ''){
					var sProject = entityLoadbyPK('projects',LSParseNumber(rc.project));				
					if(rc.title eq ""){
						rc.flag = true ;
						rc.message ="Missing ticket title !";
					}else{
						try{
							var numtickets= QueryExecute(sql:"
											SELECT COUNT(ticketID) AS count 
											FROM tickets
											WHERE projectID = :id",
											params:{
												id:{value=rc.project,CFSQLType='NUMERIC'}
											});
							var code = sProject.shortName&"-"&(numTickets.count+1);
							var newTicket = entityNew('tickets',{
									title 	: rc.title,
									code 	: code,
									project : sProject
								});
							// newTicket.setPaid( ( rc.selectType eq 2 OR rc.selectType eq 3 ) ? 1 : 0 );
							newTicket.setPaid(0);
							//  description
							var rc.description= "";
							//  point
							var rc.point = 3;						
							newTicket.setPoint(rc.point);
							newTicket.setEstimate(rc.point);
							//  reportDate startDate dueDate
							var reportDate 	=	dateFormat(now(),"yyyy-mm-dd");
							var dd = INT(rc.point) + 1 ;						
							var dueDate = dateAdd( 'd', dd, reportDate );
							while(dayOfWeek(dueDate) eq 1 OR dayOfWeek(dueDate) eq 7){
								dueDate = dateAdd( 'd', 1, dueDate );
							}												
							dueDate = dateFormat(dueDate,"yyyy-mm-dd");
							newTicket.setReportDate(reportDate);
							newTicket.setDueDate(reportDate);
							newTicket.setDueDate(dueDate);
							// priority
							var lpriority = entityLoad('priority',{ priorityName : 'Normal' },true);
							newTicket.setPriority(lpriority);
							//  reporter
							var lreporter = entityLoadbyPK('users',SESSION.userID);
							newTicket.setreportedUser(lreporter);
							// project leader 
							var pLeader = sProject.getleader() ;
							//  assignee
							if(assignUserID neq '') {
								var lassignee = entityLoadbyPK('users',LsParseNumber(assignUserID));
								newTicket.setAssignedUser(lassignee);
							}
							else {
								var lassignee = entityLoadbyPK('users',LsParseNumber(SESSION.userID));
								newTicket.setAssignedUser(lassignee);
							}
							newTicket.setisInDay(doNow);

							// sprint	
							// isprivate = true, name = backlog
							var lsprint = entityLoad('modules', {project : sProject, isPrivate: true, moduleName: 'Backlog'}, true);
							newTicket.setModule(lsprint);
							// type 1 = Bug							
							var oType= entityLoadbyPK('ticketTypes',1);
							newTicket.setTicketType(oType);
							// default version
							var lversion = entityLoad('versions', { project : sProject } , "versionNumber DESC, versionDate DESC ",{maxresults : 1} );
							newTicket.setVersion(lversion[1]);
							// status 
							var lstatus = entityLoad('status' , {statusName : 'Open' }, true );
							newTicket.setStatus(lstatus);												
							// save ticket
							entitySave(newTicket);							
							// mail send for Assignee and leader of project
							var link 	= "http://"&CGI.http_host&"/index.cfm/ticket?id="&code;
							var projectLink 	="http://"&CGI.http_host&"/index.cfm/project/?id="&sProject.projectID;
							var email 		= createObject("component", "home.controllers.email");
							var emailTemplate 	=email.getTemplate("new");
							var emailSub 	= ReplaceAtt(email.getSubject("new") ,link, " ", newTicket.code, newTicket.title, " ", sProject.projectName, " ", " ", " " );
								emailSub 	= replace(emailSub, "$createdUser$",  lreporter.firstname & ' ' & lreporter.lastname, 'All' );
							var mailBody 	= ReplaceAtt(email.getTemplate("new") ,link, emailSub, newTicket.code, newTicket.title, projectLink, sProject.projectName, " ", " ", " ");
							var listTo 		=QueryExecute(sql:"
									SELECT DISTINCT email 
									FROM users u 
									LEFT JOIN usertype t
									ON u.userTypeID=t.userTypeID
									LEFT JOIN notification n 
									ON u.notificationID=n.notificationID
									WHERE 	n.levelNumber>1 
										AND (	userID= :ld 
											OR 	userID= :as 
											OR 	userID= :rp 
											OR (n.levelNumber=3 AND u.userID in (SELECT users_userID FROM projectUsers WHERE projects_projectID=:pID ) )
											OR 	n.levelNumber=4
											)
									Group By email",
								params:{
									ld:{value = pLeader.userID,CFSQLType='NUMERIC'},
									as:{value = lassignee.userID,CFSQLType='NUMERIC'},
									rp:{value = lreporter.userID,CFSQLType='NUMERIC'},
									pID:{value= sProject.projectID,CFSQLType='NUMERIC'}
								});
							var toUser="";
							for(item in listTo) {
							   toUser=toUser&item.email&";";
							}
							sendEmail(toUser,emailSub,mailBody);    
							// new activity
							var getActivities=QueryExecute("SELECT activityID FROM activities WHERE activityName='Assigned'");
							var cmt='<a href="'&link&'"> '&code&' Assigned </a>';
							createNotification(lassignee.userID,getActivities.activityID, cmt);
							// link to ticket detail
							// if( rc.dcontinue eq "off" ){
								// GetPageContext().getResponse().sendRedirect("/index.cfm/ticket?id="&code );			
							// }
						}catch(any e){
							rc.flag=true;
							rc.message = e.message ;
						}
					}
				}else{
					rc.flag = true ;
					rc.message = "Missing project !";
				}
			}
		
		}

	string function ReplaceAtt(string textRoot,string ticketLink,string title,string ticketCode,string ticketTitle,string projectLink,string projectName,string ticketEstimate,string totalEstimate,string changeComment){
		var inputString=textRoot;
		inputString=replace(inputString,"$ticketLink$"		,ticketLink 	,"all");
		inputString=replace(inputString,"$title$"			,title 			,"all");
		inputString=replace(inputString,"$ticketCode$"		,ticketCode 	,"all");
		inputString=replace(inputString,"$ticketTitle$"		,ticketTitle 	,"all");
		inputString=replace(inputString,"$projectLink$"		,projectLink 	,"all");
		inputString=replace(inputString,"$projectName$"		,projectName 	,"all");
		inputString=replace(inputString,"$ticketEstimate$"	,ticketEstimate ,"all");
		inputString=replace(inputString,"$totalEstimate$"	,totalEstimate 	,"all");
		inputString=replace(inputString,"$changeComment$"	,changeComment 	,"all");
		return inputString;
	}

	function sendEmail(userto,emailsubject,mailbody){		
		if(userto neq "" AND emailsubject neq "" AND mailbody neq ""){
			mailerService = new mail();
			mailerService.setTo(userto); 
	        mailerService.setFrom("tickets@rasia.info"); 
	        mailerService.setSubject(emailsubject); 
	        mailerService.setType("html"); 
	        mailerService.setBody(mailbody); 
	    	mailerService.send(body=mailbody);
	    }
	}
}