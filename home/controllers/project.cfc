component output="false" displayname=""  {
 
	public function init(required any fw){
		variables.fw =fw;
		return this;
	}
	function ticket_listing(struct rc){
		if(SESSION.userType != 3){
			rc.prj = QueryExecute("SELECT DISTINCT projects.projectID, projects.projectName, projectLeadID FROM projects
						INNER JOIN projectUsers ON projects.projectID = projectUsers.projects_projectID
						WHERE projects.projectStatusID != 6 AND projectUsers.users_userID = :id AND projects.active = 1 ORDER BY projects.projectName
						",
						{id = SESSION.userID});
		}else{
			rc.prj = QueryExecute("SELECT DISTINCT projects.projectID, projects.projectName FROM projects WHERE projects.projectStatusID != 6 AND projects.active = 1 ORDER BY projects.projectName");
		}
		if(!structKeyExists(rc, "pId"))
		{
			rc.pId = rc.prj.projectID;
		}else{
			var hasProject = false ;
			for(p in rc.prj) {
				if( p.projectID eq rc.pId )
			   		hasProject =  true  ;
			}
			if(not hasProject)rc.pId = rc.prj.projectID;
		}

		if(rc.pId neq '')
		{
			SESSION.focuspj = structKeyExists(SESSION, "focuspj") ? SESSION.focuspj : 0 ;
			if(SESSION.focuspj neq rc.pId){
				SESSION.focuspj=rc.pId;
				QueryExecute("UPDATE users SET focusProject = :project WHERE  userID = :id",
											{id : SESSION.userID , project : SESSION.focuspj});
			}
		}
		if(structKeyExists(URL, "pid"))
		{
				rc.data= QUERYEXECUTE("
						SELECT t.ticketID,t.code,pj.code as pCode,t.title,t.priorityID,date_format(t.dueDate,'%Y-%m-%d') AS dueDate,
						u1.firstname AS assignee,u2.firstname AS reporter,p.color AS pColor,
						p.priorityName AS priority,s.color AS sColor,s.statusName AS status, datediff(now(),t.dueDate) as over,
						t.statusID, epic.epicName, epic.epicColor,
						SUBSTRING_INDEX(SUBSTRING_INDEX(t.code, '-', -1), ' ', -1) AS splitFromCode
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
						lEFT JOIN epic
							ON t.epicID = epic.epicID
						WHERE t.projectID= "&URL.pID&"
						ORDER BY t.ticketID DESC	
						LIMIT 500		
						",
						{id = SESSION.userID});
		}
	}
	public function default(struct rc)
	{		
		if(SESSION.userType != 3){
			rc.prj = QueryExecute("SELECT DISTINCT projects.projectID, projects.projectName, projectLeadID FROM projects
						INNER JOIN projectUsers ON projects.projectID = projectUsers.projects_projectID
						WHERE projects.projectStatusID != 6 AND projectUsers.users_userID = :id AND projects.active = 1 ORDER BY projects.projectName
						",
						{id = SESSION.userID});
		}else{
			rc.prj = QueryExecute("SELECT DISTINCT projects.projectID, projects.projectName FROM projects WHERE projects.projectStatusID != 6 AND projects.active = 1 ORDER BY projects.projectName");
		}
		if(!structKeyExists(URL, "pId"))
		{
			rc.pId = rc.prj.projectID;
		}else{
			rc.pId = URL.pId ;
			var hasProject = false ;
			for(p in rc.prj) {
				if( p.projectID eq rc.pId )
			   		hasProject =  true  ;
			}
			if(not hasProject and SESSION.userType != 3)rc.pId = rc.prj.projectID;
		}
		if(rc.pId neq '')
		{
			SESSION.focuspj = structKeyExists(SESSION, "focuspj") ? SESSION.focuspj : 0 ;
			if(SESSION.focuspj neq rc.pId){
				SESSION.focuspj=rc.pId;
				QueryExecute("UPDATE users SET focusProject = :project WHERE  userID = :id",
											{id : SESSION.userID , project : SESSION.focuspj});
			}
			rc.prjLead = QueryExecute("SELECT DISTINCT projectLeadID AS lid FROM projects WHERE projects.projectID = "&rc.pId&"");
			rc.lead = QueryExecute("SELECT userID, firstname, lastname FROM users WHERE active = 1");
			rc.users = QueryExecute("SELECT userID, firstname, lastname,userTypeID, email FROM users
							WHERE userTypeID != 3 AND active =1 and userID NOT IN (SELECT DISTINCT users_userID FROM projectUsers 
												WHERE projects_projectID = "&rc.pId&")");
			rc.data = QueryExecute("SELECT * FROM projects WHERE projectID = "&rc.pId&"");
			rc.customer = QueryExecute("SELECT DISTINCT CONCAT(u.firstname,' ',u.lastname) as firstname, u.email
										FROM users u
										LEFT JOIN projectUsers ON projectUsers.users_userID = u.userID 
										WHERE projectUsers.projects_projectID = "&rc.pId&" AND u.userTypeID = 1");
			rc.projects = QueryExecute("SELECT projectID, shortdes, dueDate, projectURL
											FROM projects
											WHERE projectID = "&rc.pId&" ");
			rc.module = QueryExecute("SELECT * FROM modules WHERE modules.projectID = "&rc.pId&" AND status is not null");

			rc.estimateTime = QueryExecute("SELECT CASE WHEN ISNULL(e) THEN 0 ELSE e END AS e FROM
									(SELECT SUM(estimate) AS e FROM tickets WHERE tickets.projectID = "&rc.pId&") AS d");
			rc.timeEntries = QueryExecute("SELECT CASE WHEN ISNULL(r) THEN 0 ELSE r END AS r FROM
									(SELECT SUM(hours) AS r FROM timeentries LEFT JOIN tickets 
									ON timeentries.ticketID = tickets.ticketID
									WHERE tickets.projectID = "&rc.pId&") AS d");
			rc.userPrj = 	QueryExecute("SELECT DISTINCT userID, CONCAT(firstname, ' ', lastname) as firstname FROM users
							WHERE active = 1 and userTypeID = 2 and userID IN (SELECT DISTINCT users_userID FROM projectUsers WHERE projects_projectID = "&rc.pId&")");
			rc.oldVersion = QueryExecute("SELECT versionName,versionNumber,date_format(versionDate,'%Y-%m-%d') AS date,detail
										FROM versions
										WHERE projectID="&rc.pId&"
										ORDER BY versionDate DESC,versionNumber DESC,versionName ASC
										LIMIT 1");
			// rc.statusNames = QueryExecute("SELECT status.statusName FROM status");
			var monthly = QueryExecute("SELECT SUM(hours) as total, timeentries.entrydate FROM timeentries
							INNER JOIN tickets ON timeentries.ticketID = tickets.ticketID
							WHERE entryDate BETWEEN DATE_SUB(NOW(), INTERVAL 30 DAY) AND NOW()
							AND tickets.projectID = "&rc.pId&"
							GROUP BY timeentries.entrydate");
			var grTicket = QueryExecute("SELECT tickettypes.ticketTypeID, tickettypes.typeName, COUNT(*) AS total
								FROM tickets INNER JOIN tickettypes 
								ON tickets.ticketTypeID = tickettypes.ticketTypeID
								WHERE tickets.projectID = "&rc.pId&"
								GROUP BY tickets.ticketTypeID");
			var grTicketStatus = QueryExecute("SELECT status.statusID, status.statusName, COUNT(*) AS total
								FROM tickets LEFT JOIN status ON tickets.statusID = status.statusID
								WHERE tickets.projectID = "&rc.pId&"
								GROUP BY tickets.statusID");
			var user = QueryExecute("SELECT users.firstname, users.lastname, SUM(timeentries.hours) AS hours
							FROM timeentries 
							inner JOIN tickets	ON timeentries.ticketID = tickets.ticketID
							INNER JOIN users ON timeentries.userID = users.userID WHERE users.active = 1 and tickets.projectID = "&rc.pId&"
							GROUP BY timeentries.userID");
			rc.lastModule = QueryExecute("SELECT * FROM modules WHERE projectID = "&rc.pId&"
							AND status is not null
							ORDER BY moduleID DESC LIMIT 0,3");
			var cat = arrayNew(1);
			rc.dataD = arrayNew(1);
			var open = structNew();
			var reopened = structNew();
			var inprog = structNew();
			var resolved = structNew();
			var close = structNew();
			open.name = 'Open';
			reopened.name = 'Reopened';
			inprog.name = 'In Progress';
			resolved.name = 'Resolved';
			close.name = 'Closed';
			open.data = arrayNew(1);
			reopened.data = arrayNew(1);
			inprog.data = arrayNew(1);
			resolved.data = arrayNew(1);
			close.data = arrayNew(1);
			rc.typeTicket = arrayNew(1);
			for(item in grTicket)
			{
				arrayAppend(rc.typeTicket, item.typeName);
				var dGRT = QueryExecute("SELECT status.statusName, total FROM status LEFT OUTER JOIN (SELECT COUNT(tickets.ticketID) AS total, status.statusName 
						FROM tickets INNER JOIN status ON tickets.statusID = status.statusID
						WHERE tickets.projectID = "&rc.pId&" AND tickets.ticketTypeID = "&item.ticketTypeID&"
						GROUP BY tickets.statusID) AS a ON status.statusName = a.statusName");
				for(ditem in dGRT)
				{
					if(ditem.statusName == 'Open')
					{
						if(ditem.total == "")
						{
							arrayAppend(open.data, 0);
						}
						else
						{
							arrayAppend(open.data, ditem.total);
						}
					}
					if(ditem.statusName == 'Reopened')
					{
						if(ditem.total == "")
						{
							arrayAppend(reopened.data, 0);
						}
						else
						{
							arrayAppend(reopened.data, ditem.total);
						}
					}
					if(ditem.statusName == 'In Progress')
					{
						if(ditem.total == "")
						{
							arrayAppend(inprog.data, 0);
						}
						else
						{
							arrayAppend(inprog.data, ditem.total);
						}
					}
					if(ditem.statusName == 'Resolved')
					{
						if(ditem.total == "")
						{
							arrayAppend(resolved.data, 0);
						}
						else
						{
							arrayAppend(resolved.data, ditem.total);
						}
					}
					if(ditem.statusName == 'Closed')
					{
						if(ditem.total == "")
						{
							arrayAppend(close.data, 0);
						}
						else
						{
							arrayAppend(close.data, ditem.total);
						}
					}
				}

			}
			arrayAppend(rc.dataD, open);
			arrayAppend(rc.dataD, reopened);
			arrayAppend(rc.dataD, inprog);
			arrayAppend(rc.dataD, resolved);
			arrayAppend(rc.dataD, close);

			var cat1 = arrayNew(1);
			for(item in grTicketStatus)
			{
				arrayAppend(cat1, item.statusName);
				
			}
			rc.cateStatus = cat1;
			var userCate = arrayNew(1);
			var userData = arrayNew(1);
			
			for(item in user)
			{
				arrayAppend(userCate, item.firstname & " " & item.lastname);
				var tmp = structNew();
				tmp.y = item.hours;
				tmp.color = "##1aadce";
				arrayAppend(userData, tmp);
			}
			rc.uCate = userCate;
			rc.uData = userData;
			
			var daysCate = arrayNew(1);
			var daysData = arrayNew(1);

			for(item in monthly)
			{
				arrayAppend(daysCate, dateFormat(item.entryDate,"D"));
				arrayAppend(daysData, item.total);
			}
			rc.monthlyCate = daysCate;
			rc.monthlyData = daysData;
		}
	}
	function lineChart(struct rc){
		rc.data = QueryExecute("SELECT * FROM projects WHERE projectID = "&rc.pId&"");
		var monthly = QueryExecute("SELECT SUM(hours) as total, timeentries.entrydate FROM timeentries
							INNER JOIN tickets ON timeentries.ticketID = tickets.ticketID
							WHERE entryDate BETWEEN DATE_SUB(NOW(), INTERVAL 30 DAY) AND NOW()
							AND tickets.projectID = "&rc.pId&"
							GROUP BY timeentries.entrydate");
		var daysCate = arrayNew(1);
		var daysData = arrayNew(1);

		for(item in monthly)
		{
			arrayAppend(daysCate, dateFormat(item.entryDate,"D"));
			arrayAppend(daysData, item.total);
		}
		rc.monthlyCate = daysCate;
		rc.monthlyData = daysData;
		// rc.monthlyCate = [1,2,3,4,5,6,7,8,10];
		// rc.monthlyData = [3,5,1,4,1,5,2,4,32];
	}
	function columnChart(struct rc){
		rc.projects = QueryExecute("SELECT projectName FROM projects WHERE projectID = "&rc.pId&"");
		var grTicketStatus = QueryExecute("SELECT status.statusID, status.statusName, COUNT(*) AS total
								FROM tickets LEFT JOIN status ON tickets.statusID = status.statusID
								WHERE tickets.projectID = "&rc.pId&"
								GROUP BY tickets.statusID");
		rc.data = arrayNew();
			rc.data[1].name = "Open";
			rc.data[1].val = 0;
			rc.data[2].name = "Reopened";
			rc.data[2].val = 0;
			rc.data[4].name = "In Progress";
			rc.data[4].val = 0;
			rc.data[5].name = "Resolved";
			rc.data[5].val = 0;
			rc.data[6].name = "Closed";
			rc.data[6].val = 0;
		for(item in grTicketStatus)			
		{	
			rc.data[item.statusID].val =  item.total;
		}
	}

	function pieChart(struct rc){
		rc.data = QueryExecute("SELECT projectName FROM projects WHERE projectID = "&rc.pId&"");
		rc.estimateTime = QueryExecute("SELECT CASE WHEN ISNULL(e) THEN 0 ELSE e END AS e FROM
									(SELECT SUM(estimate) AS e FROM tickets WHERE tickets.projectID = "&rc.pId&") AS d");

		rc.timeEntries = QueryExecute("SELECT CASE WHEN ISNULL(r) THEN 0 ELSE r END AS r FROM
								(SELECT SUM(hours) AS r FROM timeentries LEFT JOIN tickets 
								ON timeentries.ticketID = tickets.ticketID
								WHERE tickets.projectID = "&rc.pId&") AS d");
	}

	function hoursChart(struct rc){
		rc.projects = QueryExecute("SELECT projectName FROM projects WHERE projectID = "&rc.pId&"");
		var user = QueryExecute("SELECT users.firstname, users.lastname, SUM(timeentries.hours) AS hours
							FROM timeentries 
							lEFT JOIN tickets	ON timeentries.ticketID = tickets.ticketID
							lEFT JOIN users ON timeentries.userID = users.userID WHERE tickets.projectID = "&rc.pId&"
							GROUP BY timeentries.userID");
		rc.data = arrayNew();
		for(item in user)
		{
			var uItem = {'name': item.firstname & " " & item.lastname , 'y': item.hours , 'drilldown': ''};
			arrayAppend(rc.data,uItem);
		}
	}
	function stackColumChart(struct rc){
		rc.dataD = arrayNew(1);
		var open = structNew();
		var reopened = structNew();
		var inprog = structNew();
		var resolved = structNew();
		var close = structNew();
		open.name = 'Open';
		reopened.name = 'Reopened';
		inprog.name = 'In Progress';
		resolved.name = 'Resolved';
		close.name = 'Closed';
		open.data = arrayNew(1);
		reopened.data = arrayNew(1);
		inprog.data = arrayNew(1);
		resolved.data = arrayNew(1);
		close.data = arrayNew(1);
		rc.typeTicket = arrayNew(1);
		rc.projects = QueryExecute("SELECT projectName FROM projects WHERE projectID = "&rc.pId&"");
		var grTicket = QueryExecute("SELECT tickettypes.ticketTypeID, tickettypes.typeName, COUNT(*) AS total
								FROM tickets INNER JOIN tickettypes 
								ON tickets.ticketTypeID = tickettypes.ticketTypeID
								WHERE tickets.projectID = "&rc.pId&"
								GROUP BY tickets.ticketTypeID");
		rc.typeTicket = arrayNew(1);
			for(item in grTicket)
			{
				arrayAppend(rc.typeTicket, item.typeName);
				var dGRT = QueryExecute("SELECT status.statusName, total FROM status LEFT OUTER JOIN (SELECT COUNT(tickets.ticketID) AS total, status.statusName 
						FROM tickets INNER JOIN status ON tickets.statusID = status.statusID
						WHERE tickets.projectID = "&rc.pId&" AND tickets.ticketTypeID = "&item.ticketTypeID&"
						GROUP BY tickets.statusID) AS a ON status.statusName = a.statusName");
				for(ditem in dGRT)
				{
					if(ditem.statusName == 'Open')
					{
						if(ditem.total == "")
						{
							arrayAppend(open.data, 0);
						}
						else
						{
							arrayAppend(open.data, ditem.total);
						}
					}
					if(ditem.statusName == 'Reopened')
					{
						if(ditem.total == "")
						{
							arrayAppend(reopened.data, 0);
						}
						else
						{
							arrayAppend(reopened.data, ditem.total);
						}
					}
					if(ditem.statusName == 'In Progress')
					{
						if(ditem.total == "")
						{
							arrayAppend(inprog.data, 0);
						}
						else
						{
							arrayAppend(inprog.data, ditem.total);
						}
					}
					if(ditem.statusName == 'Resolved')
					{
						if(ditem.total == "")
						{
							arrayAppend(resolved.data, 0);
						}
						else
						{
							arrayAppend(resolved.data, ditem.total);
						}
					}
					if(ditem.statusName == 'Closed')
					{
						if(ditem.total == "")
						{
							arrayAppend(close.data, 0);
						}
						else
						{
							arrayAppend(close.data, ditem.total);
						}
					}
				}

			}
			arrayAppend(rc.dataD, open);
			arrayAppend(rc.dataD, reopened);
			arrayAppend(rc.dataD, inprog);
			arrayAppend(rc.dataD, resolved);
			arrayAppend(rc.dataD, close);
			rc.data = arrayNew();
				for(item in rc.dataD)
				{
					var uItem = {'name': item.name , 'data': item.data};
					arrayAppend(rc.data,uItem);
				}
	}
	function splineChart(struct rc){
		rc.lastModule = QueryExecute("SELECT * FROM modules WHERE projectID = "&rc.pId&"
							AND status is not null
							ORDER BY moduleID DESC LIMIT 0,3");
		// dump(rc.lastModule);
		rc.sprint = arrayNew(1);
		rc.rsprint = arrayNew(1);
		var i = 1;
		for (module in rc.lastModule)
		{
			rc.sprint[i] = arrayNew(1);
			rc.rsprint[i] = arrayNew(1);
			var sumP = QueryExecute("SELECT SUM(point) as sp FROM tickets WHERE moduleID = "&module.moduleID);
			// dump(sumP);
			var pdetail = QueryExecute("SELECT date_format(dueDate,'%Y-%m-%d') as date, SUM(point) as spoint FROM tickets WHERE moduleID = "&module.moduleID&" GROUP BY date_format(dueDate,'%Y-%m-%d')");
			var rdetail = QueryExecute("SELECT date_format(resovldDate,'%Y-%m-%d') as date, SUM(point) as spoint FROM tickets WHERE moduleID = "&module.moduleID&" AND statusID = 5 GROUP BY date_format(resovldDate,'%Y-%m-%d')");
			var sp = sumP.sp neq ''? sumP.sp : 0 ;
			var ds = 0;
			for (item in pdetail)
			{
				if(item.date neq ''){
				var dq = arrayNew(1);
				var yy = dateFormat(item.date, 'yyyy');
				var mm = dateFormat(item.date, 'mm');
				var dd = dateFormat(item.date, 'dd');
				var d = "Date.UTC("&yy&", "&mm - 1&", "&dd&")";
				var v = item.spoint;
				if (v == "")
					v = 0;
				ds = ds + v;
				arrayAppend(dq, d);
				arrayAppend(dq, sp - ds);
				arrayAppend(rc.sprint[i], dq);
				}
			}
			ds = 0;
			for (item in rdetail)
			{
				var dq = arrayNew(1);
				var yy = dateFormat(item.date, 'yyyy');
				var mm = dateFormat(item.date, 'mm');
				var dd = dateFormat(item.date, 'dd');
				var d = "Date.UTC("&yy&", "&mm - 1&", "&dd&")";
				var v = item.spoint;
				if (v == "")
					v = 0;
				ds = ds + v;
				arrayAppend(dq, d);
				arrayAppend(dq, sp - ds);
				arrayAppend(rc.rsprint[i], dq);
			}
			i = i + 1;
		}
	}
	function sprintChart(struct rc){
		rc.lastModule = QueryExecute("SELECT * FROM modules WHERE projectID = "&rc.pId&" and moduleID = "&rc.spId&"
							ORDER BY moduleID DESC LIMIT 0,3");
		// dump(rc.lastModule);
		rc.sprint = arrayNew(1);
		rc.rsprint = arrayNew(1);
		var i = 1;
		for (module in rc.lastModule)
		{
			rc.sprint[i] = arrayNew(1);
			rc.rsprint[i] = arrayNew(1);
			var sumP = QueryExecute("SELECT SUM(point) as sp FROM tickets WHERE moduleID = "&module.moduleID);
			// dump(sumP);
			var pdetail = QueryExecute("SELECT date_format(dueDate,'%Y-%m-%d') as date, SUM(point) as spoint FROM tickets WHERE moduleID = "&module.moduleID&" GROUP BY date_format(dueDate,'%Y-%m-%d')");
			var rdetail = QueryExecute("SELECT date_format(resovldDate,'%Y-%m-%d') as date, SUM(point) as spoint FROM tickets WHERE moduleID = "&module.moduleID&" AND statusID = 5 GROUP BY date_format(resovldDate,'%Y-%m-%d')");
			var sp = sumP.sp neq ''? sumP.sp : 0 ;
			var ds = 0;
			for (item in pdetail)
			{
				if(item.date neq ''){
				var dq = arrayNew(1);
				var yy = dateFormat(item.date, 'yyyy');
				var mm = dateFormat(item.date, 'mm');
				var dd = dateFormat(item.date, 'dd');
				var d = "Date.UTC("&yy&", "&mm - 1&", "&dd&")";
				var v = item.spoint;
				if (v == "")
					v = 0;
				ds = ds + v;
				arrayAppend(dq, d);
				arrayAppend(dq, sp - ds);
				arrayAppend(rc.sprint[i], dq);
				}
			}
			ds = 0;
			for (item in rdetail)
			{
				var dq = arrayNew(1);
				var yy = dateFormat(item.date, 'yyyy');
				var mm = dateFormat(item.date, 'mm');
				var dd = dateFormat(item.date, 'dd');
				var d = "Date.UTC("&yy&", "&mm - 1&", "&dd&")";
				var v = item.spoint;
				if (v == "")
					v = 0;
				ds = ds + v;
				arrayAppend(dq, d);
				arrayAppend(dq, sp - ds);
				arrayAppend(rc.rsprint[i], dq);
			}
			i = i + 1;
		}
	}
	function form(struct rc){
		rc.flag=true;
		rc.checkStatus = false;
		rc.company = QueryExecute("SELECT * FROM company");
		var listCustomer = queryToArray(QueryExecute("SELECT userID,lastname,firstname FROM users Where userTypeID = 1 and active = 1 order by firstname"));
		var listDeveloper = queryToArray(QueryExecute("SELECT userID,lastname,firstname FROM users Where userTypeID <> 1 and active = 1 order by firstname"));
		rc.arrayNameCustomer = [];
		rc.arrayNameDeveloper = [];
		for (item in listCustomer)
		{
			var struct = {'id':item.userID,'value':item.firstname& " " & item.lastname};
			ArrayAppend(rc.arrayNameCustomer,struct);
		}
		rc.arrayNameCustomer = serialize(rc.arrayNameCustomer);


		for (item in listDeveloper)
		{
			var struct = {'id':item.userID,'value':item.firstname& " " & item.lastname};
			ArrayAppend(rc.arrayNameDeveloper,struct);
		}
		rc.arrayNameDeveloper = serialize(rc.arrayNameDeveloper);

		if(structKeyExists(URL,"pId")){
			var project = entityLoadbyPK('projects',URL.pId);
			if(isNull(project)){
					rc.flag=false;
					rc.message="Project not found!";
			}
			else{
				rc.loadProject = project;
			}
		}

		if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn){

			// EDIT BY NAMNNH 2/6/2015
			var project = "";
			var active=structKeyExists(rc,"projectActive") ? 1 : 0;

			if(structKeyExists(URL,"pId")){
				var project = entityLoadbyPK('projects',URL.pId);
				if(isNull(project)){
					rc.flag=false;
					rc.message="Project not found!";
				}
				else if(!isNull(entityLoad("projects",{shortName:rc.projectShortName},true)) and project.shortName neq rc.projectShortName)
				{
					rc.flag=false;
					rc.message="The Short name of project is duplicate!";
				}
				else{
					if(project.shortName neq rc.projectShortName){
						var changeCodeTickets=QueryExecute("UPDATE tickets
												SET `code` = REPLACE(code,'"&project.shortName&"','"&rc.projectShortName&"') 
												WHERE projectID="&project.projectID);
					}

					project.setProjectName( rc.projectName );
					project.setShortName( rc.projectShortName );
					project.setDescription( rc.description );
					project.setColor( rc.projectColor );
					project.setDueDate( rc.projectDueDate );
					project.setBudget( rc.projectBudget );
					project.setTotalEstimate( rc.projectEstimate );
					project.setProjectURL( rc.projectUrl );
					project.setActive( active );
					project.setShortdes( rc.projectShortDescription );
					project.setLeader(entityLoadbyPK("users",LSParseNumber( rc.isLeader )));
					project.setType( entityLoadbyPK("projectTypes",LSParseNumber( rc.projectType )));
					project.setStatus( entityLoadbyPK("projectStatus",LSParseNumber( rc.projectStatus )));
				}
			}	
			else{
					if(!isNull(entityLoad("projects",{projectName:rc.projectName},true)))
					{
						rc.flag=false;
						rc.message="The name of project is duplicate!";
					}
					else if(!isNull(entityLoad("projects",{shortName:rc.projectShortName},true)))
					{
						rc.flag=false;
						rc.message="The Short name of project is duplicate!";
					}
					else 
					{
							/*=====New Vesion=====*/
						var versions 		= 	entityNew('versions',{
							versionName		: 	'Demo',
							versionNumber	:	'1.0',
							versionDate		:	DateFormat(now(),"yyyy-mm-dd")
						});
						/*=====New modules=====*/
						var modulesIcebox	=	entityNew('modules',{
							moduleName		:	'Icebox',
							isPrivate		:  	1
						});
						var modulesBacklog 	=	entityNew('modules',{
							moduleName		:	'Backlog',
							isPrivate		:  	1
						});
						var modulesSprint 	=	entityNew('modules',{
							moduleName		:	'Sprint 1',
							isPrivate		:  	0
						});

					    project	=	entityNew("projects",{				
							projectName		:	rc.projectName,
							code			:	Left(hash(createUUID()&rc.projectName), 8),
							shortName		:	rc.projectShortName,
							shortdes 		:	rc.projectShortDescription,
							Description		:	rc.description,
							color			:	rc.projectColor,
							dueDate			:	rc.projectDueDate,
							projectURL		:	rc.projectUrl,
							budget			:	rc.projectBudget,
							totalEstimate 	:	rc.projectEstimate,
							active			:	active,
							leader			:	entityLoadbyPK("users",LSParseNumber(rc.isLeader)),
							type			:	entityLoadbyPK("projectTypes",LSParseNumber(rc.projectType)),
							status			:	entityLoadbyPK("projectStatus",LSParseNumber(rc.projectStatus))
						});
					    project.addModules(modulesIcebox);
					    project.addModules(modulesBacklog);
					    project.addModules(modulesSprint);
					    project.addVersion(versions);
					}
					
			}
			if(rc.flag)
			{
				transaction action="begin"{
					try {
						/*================== Create New Project=======================*/
						entitySave(project);
						if(!structKeyExists(URL,"pId")){
							entitySave(versions);
							entitySave(modulesIcebox);
							entitySave(modulesBacklog);
							entitySave(modulesSprint);
						}
						

						/*================== Create New Company====================== */
						var company = "";
						if(rc.checkAddNewCompany eq "1"){
							company = entityNew("company",{
								companyName : rc.companyName,
								address		: rc.companyAddress,
								phone 		: rc.companyPhone,
								description : rc.companyDescription,
								email 		: rc.companyEmail
							});
							entitySave(company);
						}
						else{
							company = entityLoadbyPK("company",LSParseNumber(rc.companyId));
						}
						/*=================== Create New User=========================*/
						var arrDev = [];
						for(dev in rc.idDev)
						{
							ArrayAppend(arrDev,LSParseNumber(dev));
						}
						if(structKeyExists(rc, "idCus"))
						{
							for(var i=1 ; i<= arrayLen(rc.idCus); i++)
							{
								if(rc.idCus[i] eq "")
								{
									if(isNull(entityLoad("users",{username:rc.userNameCus[i]},true))){
										if(isNull(entityLoad("users",{email:rc.emailCus[i]},true))){
											var pass =  LEFT(createUUID(),6);
											var type=entityLoadbyPK("userType",1);
							   				var endDate=CreateDate(9999, 1, 1);
							   				var saltpass = hash(createUUID());   

										   	var user = entityNew("users",{
											    firstname	= rc.firstnameCus[i],
											    lastname 	= rc.lastnameCus[i],    
											    username 	= rc.userNameCus[i],
											    password 	= hash(pass&saltpass),
											    email    	= rc.emailCus[i],
											    endDate	 	= endDate,
											   	salt        = saltpass,
											    active 		= true,
											    isSubscribe = true,
											    language	= entityLoadbyPK("language",application.languageId ),
											    notification= entityLoadbyPK("notification",3 ),
											    type 		= type,
											});
							   				entitySave(user);
									   		
									   		ArrayAppend(arrDev,user.userID);
											
							   				// send email for member
											var emailsubject = "Your account has just created on Ticket System!";
											var mailbody = "<h1>Your Account already created !</h1><h2>Hi #user.firstname# #user.lastname#</h2><ul><li>username : #user.username#</li><li>Password : #pass#</li></ul><p>Link : <a href='http://#CGI.HTTP_HOST#/index.cfm/user/edit'>http://#CGI.HTTP_HOST#/</a></p>";
							   				mailerService = new mail();
											mailerService.setTo(user.email);
									        mailerService.setFrom("tickets@rasia.info"); 
									        mailerService.setSubject(emailsubject); 
									        mailerService.setType("html"); 
									        mailerService.setBody(mailbody); 
									    	mailerService.send(body=mailbody);
										}
										else{
											rc.flag=false;
											rc.message="Email exists";
										}
									}
									else{
										rc.flag=false;
										rc.message="Username exists";
									}
									

								}else{
									ArrayAppend(arrDev,LSParseNumber(rc.idCus[i]));
								}
							}
						}
						
						var arrDevString = REPLACE(REPLACE(serialize(arrDev),'[','(','all'),']',')','all');
						project.setCompany(company);
						project.setUsers( ormExecuteQuery( "FROM users WHERE userID IN #arrDevString# " ));
						entitySave(project);
						transaction action="commit";
						rc.checkStatus=true;
					}
					catch(any e) {
						transaction action="rollback";
						rc.message="Save Project have Problem";
						rc.flag=false;
					} 
					
				}
			}
			if(rc.flag)
				location("/index.cfm/project?pId="&project.projectID,false);
			// END EDIT
		}
		rc.users= QUERYEXECUTE("SELECT userID,firstname,lastname FROM users WHERE userTypeID= 2 OR userTypeID= 3");
		rc.prjType = QueryExecute("SELECT * FROM projectTypes");
		rc.prjStatus = QueryExecute("SELECT * FROM projectStatus");
	}


	function overview(struct rc)
	{
		if(SESSION.userType != 3){
			rc.dprj = QueryExecute("SELECT projects.projectID, projects.projectName, projectLeadID FROM projects
						INNER JOIN projectUsers ON projects.projectID = projectUsers.projects_projectID
						WHERE projectUsers.users_userID = :id AND projects.active = 1 ORDER BY projects.projectName
						",
						{id = SESSION.userID});
		}else{
			rc.dprj = QueryExecute("SELECT projects.projectID, projects.projectName FROM projects WHERE projects.active = 1 ORDER BY projects.projectName");
		}
		rc.pid = "";
		rc.astartDay= DateFormat(now()-DayofWeek(now())+2,"yyyy-mm-dd");
		rc.aendDay= DateFormat(now()-DayofWeek(now())+7,"yyyy-mm-dd");
		for(var i = 1; i <= rc.dprj.recordCount; i++)
		{
			rc.pid = rc.pid & rc.dprj.projectID[i];
			if(i < rc.dprj.recordCount)
				rc.pid = rc.pid & ","
		}
		if(rc.pid != "")
		{
			rc.ov = QueryExecute("SELECT projects.projectID, projects.active, projectStatus.color, projects.code, projects.dueDate, projects.projectName, projects.shortname, projectTypes.typeName, 
								users.firstname, users.lastname, users.userID, users.avatar, projectStatus.statusName
								FROM projects
								LEFT JOIN projectTypes ON projects.projectTypeID = projectTypes.projectTypeID
								LEFT JOIN users ON projects.projectLeadID = users.userID
								LEFT JOIN projectStatus ON projects.projectStatusID = projectStatus.projectStatusID
								WHERE projects.projectID IN ("&rc.pid&") AND projects.active = 1
								ORDER BY projects.active DESC, projects.projectID ASC");
			rc.lastprj = QueryExecute("SELECT projects.projectID,  COUNT( DISTINCT tickets.ticketID) as ticket, ROUND(SUM(timeentries.hours)) as hours
								FROM projects
								LEFT JOIN projectTypes ON projects.projectTypeID = projectTypes.projectTypeID
								LEFT JOIN users ON projects.projectLeadID = users.userID
								LEFT JOIN projectStatus ON projects.projectStatusID = projectStatus.projectStatusID
								LEFT JOIN tickets ON projects.projectID = tickets.projectID
								LEFT JOIN timeentries ON tickets.ticketID = timeentries.ticketID
								WHERE projects.projectID IN ("&rc.pid&") AND projects.active = 1
								AND month(tickets.reportDate) = month(now() - INTERVAL 1 MONTH)
								GROUP BY projects.projectID
								ORDER BY projects.active DESC, projects.projectID ASC");
			rc.prj = QueryExecute("SELECT projects.projectID, COUNT( DISTINCT tickets.ticketID) as ticket, ROUND(SUM(timeentries.hours)) as hours
								FROM projects
								LEFT JOIN projectTypes ON projects.projectTypeID = projectTypes.projectTypeID
								LEFT JOIN users ON projects.projectLeadID = users.userID
								LEFT JOIN projectStatus ON projects.projectStatusID = projectStatus.projectStatusID
								LEFT JOIN tickets ON projects.projectID = tickets.projectID
								LEFT JOIN timeentries ON tickets.ticketID = timeentries.ticketID
								WHERE projects.projectID IN ("&rc.pid&") AND projects.active = 1
								AND month(tickets.reportDate) = month(now())
								GROUP BY projects.projectID
								ORDER BY projects.active DESC, projects.projectID ASC");
			rc.dhnew = QueryExecute("SELECT projects.projectID, ROUND(SUM(timeentries.hours)) as hours
								FROM projects
								LEFT JOIN tickets ON projects.projectID = tickets.projectID
								LEFT JOIN timeentries ON tickets.ticketID = timeentries.ticketID
								WHERE projects.projectID IN ("&rc.pid&") AND projects.active = 1
								AND date_format(timeentries.entryDate, '%Y-%m-%d') BETWEEN '"&rc.astartDay&"' AND '"&rc.aendDay&"'
								GROUP BY projects.projectID
								ORDER BY projects.active DESC, projects.projectID ASC");
			rc.dtnew = QueryExecute("SELECT projects.projectID, COUNT( DISTINCT tickets.ticketID) as ticket
								FROM projects
								LEFT JOIN tickets ON projects.projectID = tickets.projectID
								LEFT JOIN timeentries ON tickets.ticketID = timeentries.ticketID
								WHERE projects.projectID IN ("&rc.pid&") AND projects.active = 1
								AND date_format(tickets.reportDate, '%Y-%m-%d') BETWEEN '"&rc.astartDay&"' AND '"&rc.aendDay&"'
								GROUP BY projects.projectID
								ORDER BY projects.active DESC, projects.projectID ASC");
			rc.rs = arrayNew(1);
			for(item in rc.ov)
			{
				var dprjd = structNew();
				dprjd.projectID = item.projectID;
				dprjd.active = item.active;
				dprjd.deadline = item.dueDate;
				dprjd.color = item.color;
				dprjd.code = item.code;
				dprjd.shortName = item.shortname;
				dprjd.projectName = item.projectName;
				dprjd.teamLeader = item.firstname & " " & item.lastname;
				dprjd.userID = item.userID;
				dprjd.avatar = item.avatar;
				dprjd.status = item.statusName;
				dprjd.type = item.typeName;
				dprjd.timePrev = 0;
				dprjd.ticketPrev = 0;
				dprjd.timeNow = 0;
				dprjd.ticketNow = 0;
				dprjd.ticketNew = 0;
				dprjd.timeNew = 0;
				var dusers = QueryExecute("SELECT users.userID, users.firstname, users.lastname, users.avatar, SUM(timeentries.hours) AS hours
								FROM timeentries 
								inner JOIN tickets	ON timeentries.ticketID = tickets.ticketID
								INNER JOIN users ON timeentries.userID = users.userID WHERE tickets.projectID = "&item.projectID&"
								GROUP BY timeentries.userID
								ORDER BY hours DESC");
				dprjd.users = arrayNew(1);
				for(user in dusers)
				{
					var duser = structNew();
					duser.name = user.firstname & " " & user.lastname;
					duser.userID = user.userID;
					duser.avatar = user.avatar;
					arrayAppend(dprjd.users, duser);
				}
				arrayAppend(rc.rs, dprjd);
			}
			var j=1;
			for(var i = 1; i <= arrayLen(rc.rs); i++)
			{
				if(j > rc.prj.recordCount)
					break;
				if(rc.rs[i].projectID == rc.prj.projectID[j])
				{
					rc.rs[i].timeNow = rc.prj.hours[j];
					rc.rs[i].ticketNow = rc.prj.ticket[j];
					j = j + 1;
				}
			}
			var j=1;
			for(var i = 1; i <= arrayLen(rc.rs); i++)
			{
				if(j > rc.lastprj.recordCount)
					break;
				if(rc.rs[i].projectID == rc.lastprj.projectID[j])
				{
					rc.rs[i].timePrev = rc.lastprj.hours[j];
					rc.rs[i].ticketPrev = rc.lastprj.ticket[j];
					j = j + 1;
				}
			}	
			var j=1;
			for(var i = 1; i <= arrayLen(rc.rs); i++)
			{
				if(j > rc.dhnew.recordCount)
					break;
				if(rc.rs[i].projectID == rc.dhnew.projectID[j])
				{
					rc.rs[i].timeNew = rc.dhnew.hours[j];
					j = j + 1;
				}
			}	
			var j=1;
			for(var i = 1; i <= arrayLen(rc.rs); i++)
			{
				if(j > rc.dtnew.recordCount)
					break;
				if(rc.rs[i].projectID == rc.dtnew.projectID[j])
				{
					rc.rs[i].ticketNew = rc.dtnew.ticket[j];
					j = j + 1;
				}
			}	
		}else{
			rc.rs={};
		}
	}

	function versions(struct rc){
		if(SESSION.userType eq 3){
			rc.projects=QueryExecute("
				SELECT projectID,code,projectName,projectLeadID
				FROM projects ORDER BY projectName");
		}else{
			rc.projects=QueryExecute("
				SELECT projectID,code,projectName,projectLeadID
				FROM projects p
				lEFT JOIN projectUsers pu
				ON p.projectID = pu.projects_projectID
				WHERE pu.users_userID="&SESSION.userID&" ORDER BY p.projectName");
		}
		if(rc.projects.recordcount neq 0)
		{
			if(structKeyExists(URL,"pId")){
				for(item in rc.projects) {
					if(item.projectID eq URL.pId){
						rc.thisProject=item;
					}
				}
			}else{
				for(item in rc.projects) {
					rc.thisProject=item;
					break;
				}
			}
			if(structKeyExists(rc,"thisProject")){
				if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn){
					if(rc.name neq "" and rc.number neq ""){
						try{
						var query=QueryExecute(sql:"INSERT INTO versions(versionName,versionNumber,versionDate,detail,projectID)
												VALUEs(:name,:number,:date,:detail,:project)",
												params:{
													name:{value=rc.name,CFSQLType='string'},
													number:{value=rc.number,CFSQLType='string'},
													detail:{value=rc.detail,CFSQLType='string'},
													project:{value=rc.thisProject.projectID,CFSQLType='NUMERIC'},
													date:{value=now(),CFSQLType='DATE'}});
						}catch(any e){
							writeDump(e);
						}
					}
				}
				rc.oldVersion=QueryExecute("SELECT versionName,versionNumber,date_format(versionDate,'%Y-%m-%d') AS date,detail
												FROM versions
												WHERE projectID="&rc.thisProject.projectID&"
												ORDER BY versionDate DESC,versionNumber DESC,versionName ASC
												LIMIT 1");
			}
		}
	}
	function epic(struct rc){
		if(SESSION.userType != 3){
			rc.listProject = QueryExecute("SELECT projects.projectID, projects.projectName, projectLeadID FROM projects
						INNER JOIN projectUsers ON projects.projectID = projectUsers.projects_projectID
						WHERE projectUsers.users_userID = :id AND projects.active = 1 ORDER BY projects.projectName
						",
						{id = SESSION.userID});
		}else{
			rc.listProject = QueryExecute("SELECT projects.projectID, projects.projectName FROM projects WHERE projects.active = 1 ORDER BY projects.projectName");
		}
		if(!structKeyExists(rc, "pId"))
		{
			rc.pId = rc.listProject.projectID;
		}
		if(rc.pId neq "" and isNumeric(rc.pId)){
			rc.curProject = QueryExecute("SELECT * FROM projects WHERE projectID = :id",{id = rc.pId});
			rc.epic = QueryExecute("SELECT * 
								FROM epic
								WHERE projectID = "&rc.pId&" 
								AND epicActive = 1
								ORDER BY epicPriority DESC ");
		}
		rc.listColor = getListColor();
	}
	function editEpic(struct rc){
		if (CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn)
        {
        	try{
        		if(rc.isNew){
        			var listColor = getListColor();
        			var countEpic = QueryExecute(sql:"SELECT count(epicID) AS num FROM epic WHERE projectID = :project",
        				params:{
        						project:	{value = rc.curProject, 		CFSQLType = 'NUMERIC'}
        					});
        			var thisPriority = countEpic.num + 1 ;        		
        			var thisColor = listColor[(thisPriority mod arrayLen(listColor))+1] ;
        			var insertEpic = QueryExecute(sql:"
        				INSERT INTO epic(epicName,epicDescription,epicColor,epicPriority,epicActive,projectID)
        				VALUES(:name,:description,:color,:priority,1,:project)
        				",params:{
								name:		{value = rc.epicName, 			CFSQLType = 'String'},
								description:{value = rc.epicDescription, 	CFSQLType = 'String'},
								color:		{value = thisColor, 			CFSQLType = 'String'},
								priority:	{value = rc.epicPriority, 			CFSQLType = 'NUMERIC'},
								project:	{value = rc.curProject, 		CFSQLType = 'NUMERIC'},
							},options: {
								result:'qResult'
						    });
					return VARIABLES.fw.renderData("json",{'success':true,'eid':qResult.generatedKey,'ecolor':thisColor});
				}else{
					var updateEpic = QueryExecute(sql:"
						UPDATE epic SET epicPriority = :priority, epicName = :name, epicDescription = :description WHERE epicID = :id",
						params :{
								name:		{value = rc.epicName, 			CFSQLType = 'String'},
								description:{value = rc.epicDescription, 	CFSQLType = 'String'},
								id: 		{value = rc.curEpic, 			CFSQLType = 'NUMERIC'},
								priority:	{value = rc.epicPriority,		CFSQLType = 'NUMERIC'}
							});
					return VARIABLES.fw.renderData("json",{'success':true});
				}
			}catch(any e){
				return VARIABLES.fw.renderData("json",{'success':false,'message':e.message});
			}
		}
		return VARIABLES.fw.renderData("json",{'success':false,'message':'Please login before!'});
	}

		function removeEpic(struct rc){
			if(CGI.REQUEST_METHOD eq "POST" and SESSION.isLoggedIn)
			{
				try{				
					var rEpic = QueryExecute(sql:"
						UPDATE epic SET epicActive = 0 WHERE epicID = :id",
						params:{
							id: {value = rc.epicID, CFSQLType = 'NUMERIC'}
							});
					return VARIABLES.fw.renderData("json",{'success':true});
				}catch(any e){
					return  VARIABLES.fw.renderData("json",{'success':false, 'message':e.message});
				}
			}
			return VARIABLES.fw.renderData("json",{'success':false,'message':'Please login before!'});
			return VARIABLES.fw.renderData("json",{'success':false,'message':'Please login'});
		}

		function updateListEpic(struct rc){
		if (CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn)
		{
			try{
				rc.listEpic = deserializeJSON(rc.listEpic);
				var i = 1 ;
				var thisProject = entityLoadbyPK('projects',rc.pId);
				var listEpic = entityLoad('epic',{project : thisProject},'epicPriority DESC');
				var oldEpic = {};
				var newEpic = [];
				for(e in listepic) {
					if(not structKeyExists(oldEpic,'#e.epicID#')) oldEpic['#e.epicID#'] = e.epicPriority ;
					if(e.epicID neq rc.listEpic[i]){
						var temp = entityLoadbyPK('epic',rc.listEpic[i]);
						if(not structKeyExists(oldEpic,'#temp.epicID#')) oldEpic['#temp.epicID#'] = temp.epicPriority ;
						if(structKeyExists(oldEpic,'#e.epicID#')){
							temp.setEpicPriority(oldEpic['#e.epicID#']);
						}else{
							temp.setEpicPriority(e.epicPriority);
						}
						arrayAppend(newEpic,{'id':temp.epicID,'priority':temp.epicPriority});
					}
					i++ ;
				}
				ormflush();
				return VARIABLES.fw.renderData("json",{'success':true,'lEpic':newEpic});
    		}catch(any e){
    			return VARIABLES.fw.renderData("json",{'success':false,'message':e.message});
    		}
    	}
    	return VARIABLES.fw.renderData("json",{'success':false,'message':'Please login before!'});
    	return VARIABLES.fw.renderData("json",{'success':false, 'message':'Please login'});
	}
	function getListColor(){
		var listColor = [
			'primary','info','success','warning','danger','inverse','pink','purple','yellow','grey','light','orange'
		];
		return listColor ;
	}
	function getMoreVersion(struct rc){
		var result=true;
		if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn){
			var query=QueryExecute("SELECT versionName,versionNumber,date_format(versionDate,'%Y-%m-%d') AS date,detail
									FROM versions
									WHERE projectID="&rc.project&"
									ORDER BY versionDate DESC,versionNumber DESC,versionName ASC
									LIMIT "&rc.number&",1");
			if(query.recordcount neq 0){
				result={name:query.versionName,number:query.versionNumber,date:query.date,detail:query.detail};
			}
			return variables.fw.renderData("json",result);
		}
		return variables.fw.renderData("json",result);
	}
	function editModule(struct rc)
    {
		if (CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn)
		{
			if (rc.iscurrent == 1)
			{
				var uncheck = QueryExecute("UPDATE modules SET status = 0 WHERE status = 1");
			}
		   var edit = QUERYEXECUTE("UPDATE modules SET moduleName = '"&rc.name&"', status = '"&rc.iscurrent&"' WHERE moduleID = "&LSParseNumber(rc.moduleID)&"");
        }
        return VARIABLES.fw.renderData("json",true);
    }

	function addUser(struct rc)
	{
		if (CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn)
		{
			// new action
			try{
			var getProject=QueryExecute("SELECT projectName FROM projects WHERE projectID="&rc.projectID);
			var getListUser=QueryExecute("SELECT users_userID FROM projectUsers WHERE projects_projectID="&rc.projectID);
			var getUser=QueryExecute("SELECT firstname FROM users WHERE active = 1 and userID="&rc.userID);
			var link="http://"&CGI.HTTP_HOST&"/index.cfm/project?id="&rc.projectID;
			var getActivities=QueryExecute("SELECT activityID FROM activities WHERE activityName='Joins in Project'");
			var cmt='<a href="'&link&'">'&getUser.firstname&' joins '&getProject.projectName&'</a>';
			for(item in getListUser) {
				createNotification(item.users_userID, getActivities.activityID, cmt);
			}
			var prjUser = QUERYEXECUTE("INSERT INTO projectUsers(users_userID, projects_projectID)
								VALUES(" & rc.userID & "," & rc.projectID & ")");

			}catch(any e){
				writeDump(e);
				abort;	
			}
			
		}
		return VARIABLES.fw.renderData("json",true);
	}

	function addModules(struct rc)
	{
		var leader=QUERYEXECUTE("SELECT projectLeadID AS leader FROM projects WHERE projectID = "&rc.projectID);

		// var module = QUERYEXECUTE("INSERT INTO modules(moduleName, projectID, moduleLeadID)
		// 						VALUES('" & rc.moduleName & "'," & rc.projectID & "," & leader.leader & ")");
		
		var module = entityNew("modules",{
				moduleName = rc.moduleName,
				isPrivate = false,
				project = entityLoadbyPK("projects",LSParseNumber(rc.projectID) ),
				leader = entityLoadbyPK("users",leader.leader)
			});
		entitySave(module);
		if (rc.iscurrent == 1)
		{
			var uncheck = QueryExecute("UPDATE modules SET status = 0 WHERE status = 1");
			var check = QueryExecute("UPDATE modules SET status = 1 WHERE moduleID = "&module.moduleID );
		}
		var result = {moduleID = module.moduleID};
		return VARIABLES.fw.renderData("json",result);
	}

	function removeUser(struct rc)
	{
		if (CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn)
		{
			var prjUser = QUERYEXECUTE("DELETE FROM projectUsers WHERE users_userID = " & rc.userID & " AND projects_projectID = " & rc.projectID & "");
			// new action
			var getProject=QueryExecute("SELECT projectName FROM projects WHERE projectID="&rc.projectID);
			var getListUser=QueryExecute("SELECT users_userID FROM projectUsers WHERE active = 1 and projects_projectID="&rc.projectID);
			var getUser=QueryExecute("SELECT firstname FROM users WHERE userID="&rc.userID);
			var link="http://"&CGI.HTTP_HOST&"/index.cfm/project?id="&rc.projectID;
			var getActivities=QueryExecute("SELECT activityID FROM activities WHERE activityName='Out of Project'");
			var cmt='<a href="'&link&'">'&getUser.firstname&' out '&getProject.projectName&'</a>';
			for(item in getListUser) {
				createNotification(item.users_userID, getActivities.activityID, cmt);
			}
		}
		return VARIABLES.fw.renderData("json",true);
	}

	function loadmore(struct rc){
		tFrom=rc.page*10;
		var data= QUERYEXECUTE("
						SELECT t.ticketID,t.code,pj.code as pCode,t.title,t.priorityID,date_format(t.dueDate,'%Y-%m-%d') AS dueDate,u1.firstname AS assignee,u2.firstname AS reporter,p.color AS pColor,p.priorityName AS priority,s.color AS sColor,s.statusName AS status, datediff(now(),t.dueDate) as over, t.statusID, epic.epicName, epic.epicColor
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
						lEFT JOIN epic
							ON t.epicID = epic.epicID
						WHERE t.projectID= "&rc.projectID&"
						ORDER BY t.statusID ASC, epic.epicPriority DESC,t.priorityID ASC, t.dueDate ASC
						LIMIT "&tFrom&",11
						",
						{id = SESSION.userID});
		return variables.fw.renderData("json",queryToArray(data));
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
	function editinfo(struct rc){
		if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn){
			var project=entityLoadbyPK("project",rc.id);
				project.setproject_code(rc.code);
				project.setproject_name(rc.name);
				project.setdate_create(rc.date);
				project.setdescription(rc.description);
				project.setactive(rc.status eq "Active");
		}
		return variables.fw.renderData("json",true);
	}

	function addajax(struct rc){
		if(rc.name != ""){
			rc.project=entityNew("project",{
				project_code="",
				project_name=rc.name,
				date_create=rc.date,
				description=rc.description,
				active=true
				});
			entitySave(rc.project);
			variables.fw.renderData("text","add success");
		}
	}

	function addajaxmodule(struct rc){
		if(rc.name != ""){
			rc.module=entityNew("module",{
				name=rc.name,
				description=rc.description,
				project=entityLoadbyPK("project",LSParseNumber(rc.project))
				});
			entitySave(rc.module);
			variables.fw.renderData("text","add success");
		}
	}



	function addModule(struct rc){
		rc.flag=false;
		rc.projects=entityLoad("project");
		if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn){
			rc.module=entityNew("module",{
				name=rc.name,
				project=entityLoadbyPK("project",LSParseNumber(rc.project)),
				description=rc.description
				});
			entitySave(rc.module);
			rc.flag=true;
		}
	}
	function chart(struct rc){
		if(!isNull(URL.id)){
			id=LSParseNumber(URL.id);
			rc.project=entityLoadbyPK("project",id);
			rc.noHour=0;
			rc.noLog=0;
			rc.noModule=0;
			rc.noBug=0;
			rc.noChange=0;
			if(rc.project.hasLog()){
				rc.noLog=arrayLen(rc.project.getLogs());
				for(log in rc.project.getLogs()) {
				   rc.noHour+=log.hour;
				}
			}
			if(rc.project.hasModule()){
				rc.noModule=arrayLen(rc.project.getModules())
			}
		}
	}
	function saveModule(struct rc){
		if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn){
			var module=entityLoadbyPK("module",LSParseNumber(rc.id));
			module.setName(rc.name);
			module.setDescription(rc.description);
		}
		return variables.fw.renderData("json",true);
	}
	function deleteModule(struct rc){
		if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn){
			var module=entityLoadbyPK("module",LSParseNumber(rc.id));
			entityDelete(module);
		}
		return variables.fw.renderData("json",true);
	}
	public void function createNotification(numeric user, numeric activity, string comment){
		var newAction = entityNew('actions',{
				actionDate : now(),
				comments : comment,
				isNew: true,
				user:entityLoadbyPK('users',user),
				activity:entityLoadbyPK('activities',activity)
			});
		entitySave(newAction);
		return;
	}
	function document(struct rc){
		if(SESSION.userType eq 3){
			rc.projects =QueryExecute("SELECT projectID,projectName FROM projects WHERE active = 1 AND projectStatusID != 6");
		}else{
		rc.projects=QueryExecute("
			SELECT projectID,projectName 
			FROM projects p
			lEFT JOIN projectUsers pu
			ON p.projectID = pu.projects_projectID
			WHERE p.active = 1 AND p.projectStatusID != 6 AND pu.users_userID="&SESSION.userID&"
			ORDER BY projectName");
		}
		rc.types=QueryExecute("
			SELECT ticketTypeID,typeName
			FROM tickettypes");
	}

	function addWeeklyMeeting(struct rc){
		if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn){			
			var user = entityLoadbyPK("users",LsParseNumber(rc.user));
			var pid = entityLoadbyPK("projects",LSParseNumber(rc.projectID))			
			var meeting = entityNew("meetingminutes",{
				    meetingContent 	: rc.comment,
					meetingDate : dateTimeFormat(now(), "yyyy-mm-dd HH:nn:ss"),				    
				   	user        : user,
				   	project :	pid
			});			
				entitySave(meeting);              
			var result = {
				'success':true,
				'meetingID':meeting.meetingID,
				'avatar':user.avatar,
				'userName':user.firstname,
				'comment':meeting.meetingContent,
				'date': meeting.meetingDate

			}
			return variables.fw.renderData("json",result);
		}
		return variables.fw.renderData('json',{'success':false});
	}

	function deleteMeeting(struct rc){
		if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn){
			var oMeeting = entityLoadbyPK("meetingminutes",LsParseNumber(rc.meetingID));
			if(oMeeting.getUser().getUserID() eq SESSION.userID or SESSION.userType eq 3)
				entityDelete(oMeeting);
			else 
				return variables.fw.renderData('json',{'success':false,'message':'permission denied'});
			return variables.fw.renderData('json',{'success':true});
		}
		return variables.fw.renderData('json',{'success':false,'message':'Login before'});
	}

	function editMeeting(struct rc){
		if(CGI.REQUEST_METHOD EQ "POST" AND SESSION.isLoggedIn){
			var oMeeting = entityLoadbyPK("meetingminutes",LSParseNumber(rc.meetingID));
			if(oMeeting.getUser().getUserID() eq SESSION.userID or SESSION.userType eq 3){
				oMeeting.setMeetingContent(rc.comment);
				entitySave(oMeeting);
			}else return variables.fw.renderData('json',{'success':false,'message':'permission denied'});
			return variables.fw.renderData('json',{'success':true});			
		}
		return variables.fw.renderData('json',{'success':false,'message':'Login before'});
	}

	function checkUsernameExist (string username)
	{
		try {
			if(isNull(entityLoad("users",{username:username},true)))
				return variables.fw.renderData('json',{'success':true});
			else
				return variables.fw.renderData('json',{'success':false});
		}
		catch(e) {
			return variables.fw.renderData('json',{'success':false,'message':e});
		} 
	}

	function checkEmailExist (string email)
	{
		try {
			if(isNull(entityLoad("users",{email:email},true)))
				return variables.fw.renderData('json',{'success':true});
			else
				return variables.fw.renderData('json',{'success':false});
		}
		catch(e) {
			return variables.fw.renderData('json',{'success':false,'message':e});
		} 
	}

	function checkShortNameExist (string shortname)
	{
		try {
			if(isNull(entityLoad("projects",{shortName:shortname},true)))
				return variables.fw.renderData('json',{'success':true});
			else
				return variables.fw.renderData('json',{'success':false});
		}
		catch(e) {
			return variables.fw.renderData('json',{'success':false,'message':e});
		} 
	}

	function checkEmailExist (string email)
	{
		try {
			if(isNull(entityLoad("users",{email:email},true)))
				return variables.fw.renderData('json',{'success':true});
			else
				return variables.fw.renderData('json',{'success':false});
		}
		catch(e) {
			return variables.fw.renderData('json',{'success':false,'message':e});
		} 
	}

	function loadMeeting(struct rc){		
		var from = rc.page*5;
		var to = from+5;		
		if(CGI.REQUEST_METHOD EQ "POST" AND SESSION.isLoggedIn){			
			
				var content = QueryExecute("SELECT m.meetingID, m.meetingContent, date_format(m.meetingDate, '%M,%d %Y %r') AS date, m.projectID, m.userID, u.avatar, CONCAT(u.firstname,' ',u.lastname) as firstname
							FROM meetingminutes m
							LEFT JOIN tickets t ON m.projectID = t.projectID
							LEFT JOIN users u on m.userID = u.userID
							WHERE m.projectID = :pId
							GROUP BY m.meetingID
							ORDER BY date DESC
							LIMIT "&from&","&to&" ",{pId = SESSION.focuspj});
			return variables.fw.renderData("json", queryToArray(content));

		}
		return variables.fw.renderData('json',{'success':false});		
	}
	// var updateEpic = QueryExecute(sql:"
	// 					UPDATE epic SET epicPriority = :priority  WHERE epicID = :id",
	// 					params :{
	// 							priority:	{value = i++, 		CFSQLType = 'NUMERIC'},
	// 							id: 		{value = epic, 	CFSQLType = 'NUMERIC'}
	// 						});
	function loadInfoCompany(struct rc){
		if(CGI.REQUEST_METHOD EQ "POST" AND SESSION.isLoggedIn){
			var infoCompany = QueryExecute(sql: "SELECT * FROM company WHERE companyID = :id", 
				params: {id: {value = rc.companyID, CFSQLType = 'NUMERIC'}
				});
			return VARIABLES.fw.renderData('json',queryToArray(infoCompany));
		}
		return variables.fw.renderData('json',{'success':false});	
	}

		function create(struct rc){
			rc.flag=false;
			rc.project = SESSION.focuspj;
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
							var rc.point = 0;						
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
							var lassignee = entityLoadbyPK('users',LsParseNumber(SESSION.userID));
							newTicket.setAssignedUser(lassignee);
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
							writeDump(e);
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
	function createTicketManager(struct rc){
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
						if(rc.description neq ""){
							newTicket.setDescription(rc.description);
						}
						//  point
						var rc.point = 0;						
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
						var lassignee = entityLoadbyPK('users',LsParseNumber(rc.assignee));
						newTicket.setAssignedUser(lassignee);
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
						ticketM = entityNew("ticketManage");
						ticketToAdd = entityLoad("tickets", {code=code}, false);
						ticketM.addTicket(ticketToAdd[1]);
						entitySave(ticketM);
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
	function removeTicketManager(struct rc){
		if(CGI.REQUEST_METHOD eq "POST" and SESSION.isLoggedIn)
		{
			try{
				var rTicketM = QueryExecute(sql:"
					DELETE FROM ticketmanagetable WHERE ticketManage_ticketManageID = :id",
					params:{
						id: {value = rc.ticketID, CFSQLType = 'NUMERIC'}
						});
				var	rTicketM2 = QueryExecute(sql:"
					DELETE FROM ticketmanage WHERE ticketManageID = :id",
					params:{
						id: {value = rc.ticketID, CFSQLType = 'NUMERIC'}
						});
				return VARIABLES.fw.renderData("json",{'success':true});
			}catch(any e){
				return  VARIABLES.fw.renderData("json",{'success':false, 'message':e.message});
			}
		}
		return VARIABLES.fw.renderData("json",{'success':false,'message':'Please login first!'});
	}

	function ticketManager(struct rc) {
        param name = "rc.project" default = "0";
        if (rc.project==0) {
			rc.ticketsM = QueryExecute("SELECT t.ticketID, tm.ticketManageID, t.code, t.title, t.description, CONCAT(us.firstname, ' ', us.lastname) AS Assignee, st.statusName 
											FROM tickets t
											LEFT JOIN ticketmanagetable tmt 
												ON t.ticketID = tmt.tickets_ticketID
											LEFT JOIN ticketmanage tm 
												ON tmt.ticketManage_ticketManageID = tm.ticketManageID
											LEFT JOIN status st
												ON t.statusID = st.statusID
											LEFT JOIN users us
												ON t.assignedUserID = us.userID
											WHERE tmt.ticketManage_ticketManageID = tm.ticketManageID");
			rc.listAssignee=QUERYEXECUTE("SELECT userID,firstname,lastname 
                                        FROM users u 
                                        LEFT JOIN usertype ut 
                                        	ON u.userTypeID = ut.userTypeID
                                        WHERE ut.userType='Admin' OR ut.userType='Programmer' 
                                        ORDER BY firstname");
			rc.listTicket = QueryExecute("SELECT t.ticketID, t.title, t.code
											FROM tickets t
											LEFT JOIN ticketmanagetable tm
												ON t.ticketID = tm.tickets_ticketID
											WHERE (t.statusID = 1 OR t.statusID = 2) AND tm.tickets_ticketID IS NULL
											ORDER BY t.ticketID desc");
        } else {
			rc.ticketsM = QueryExecute(sql:"SELECT t.ticketID, tm.ticketManageID, t.code, t.title, t.description, CONCAT(us.firstname, ' ', us.lastname) AS Assignee, st.statusName FROM tickets t
											LEFT JOIN ticketmanagetable tmt 
												ON t.ticketID = tmt.tickets_ticketID
											LEFT JOIN ticketmanage tm 
												ON tmt.ticketManage_ticketManageID = tm.ticketManageID
											LEFT JOIN status st
												ON t.statusID = st.statusID
											LEFT JOIN users us
												ON t.assignedUserID = us.userID
											WHERE tmt.ticketManage_ticketManageID = tm.ticketManageID
												AND t.projectID = :pid",
											params: {
												pid: {value=rc.project, CFSQLType = 'NUMERIC'}
												});
			rc.listAssignee=QUERYEXECUTE(sql: "SELECT userID,firstname,lastname 
                                        FROM users u 
                                        LEFT JOIN usertype ut 
                                        	ON u.userTypeID = ut.userTypeID
                                        LEFT JOIN projectusers pu
											ON u.userID = pu.users_userID
                                        WHERE (ut.userType='Admin' OR ut.userType='Programmer') 
                                        	AND pu.projects_projectID = :pid
										GROUP BY u.userID
								        ORDER BY firstname",
								        params: {
								        	pid: {value=rc.project, CFSQLType = 'NUMERIC'}
								        	});
			rc.listTicket = QueryExecute(sql: "SELECT t.ticketID, t.title, t.code
												FROM tickets t
												LEFT JOIN ticketmanagetable tm
													ON t.ticketID = tm.tickets_ticketID
												WHERE (t.statusID = 1 OR t.statusID = 2) AND t.projectID = :pid AND tm.tickets_ticketID IS NULL
												ORDER BY t.ticketID desc",
											params: {
								        	pid: {value=rc.project, CFSQLType = 'NUMERIC'}
								        	});
        }
         
        
        rc.listStatus=QUERYEXECUTE("SELECT statusID,statusName FROM status ");
        rc.listProject=QUERYEXECUTE("SELECT projectID,code,projectName FROM projects WHERE active = 1 AND projectStatusID != 6 ORDER BY projectName");
    }

    function addTicketManager(struct rc){
		if(CGI.REQUEST_METHOD eq "POST" and SESSION.isLoggedIn)
		{
			try{
				QueryExecute("INSERT INTO ticketmanage () VALUES ()");
				var ticketM = QueryExecute("SELECT * FROM ticketmanage
											ORDER BY ticketManageID DESC
											LIMIT 1");
				QueryExecute(sql: "INSERT INTO ticketmanagetable (tickets_ticketID, ticketManage_ticketManageID)
									VALUES (:tid, :tmid)",
											params: {
								        	tid: {value=rc.ticketID, CFSQLType = 'NUMERIC'},
								        	tmid: {value=ticketM.ticketManageID, CFSQLType = 'NUMERIC'}
								        	});
				return VARIABLES.fw.renderData("json",{'success':true});
			}catch(any e){
				// return  VARIABLES.fw.renderData("json",{'success':false, 'message':e.message});
			}
		}
		return VARIABLES.fw.renderData("json",{'success':false,'message':'Please login first!'});
	}
 }