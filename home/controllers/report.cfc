component output="false" displayname=""  {
 
	public function init(required any fw){
		variables.fw =fw;
		return this;
	}
	function default(struct rc){
		//choose something

		rc.thisdate 	= now();
		var astartDay 	= DateFormat(rc.thisdate-DayofWeek(rc.thisdate)+2,"yyyy/mm/dd");
		var aendDay 	= DateFormat(rc.thisdate-DayofWeek(rc.thisdate)+6,"yyyy/mm/dd");

		if(!structKeyExists(URL, "start")){
			URL.start = astartDay;
			URL.end = aendDay;
		}
		else if (!structKeyExists(URL, "end"))
		{
			URL.end = aendDay;
		}
		rc.ticketType = QueryExecute("SELECT * FROM tickettypes");
		if(SESSION.userType EQ 3)
		{
			rc.users = QueryExecute("SELECT * 
									FROM users 
									ORDER BY firstname,lastname ASC");

			rc.prj = QueryExecute("SELECT DISTINCT projects.projectName, 
										projects.projectID
									FROM projects 
									LEFT JOIN projectUsers 
										ON projectUsers.projects_projectID = projects.projectID 
									ORDER BY projects.projectName");
		}
		else{
			rc.users = QueryExecute("SELECT * 
									FROM users 
									WHERE users.active = 1
									ORDER BY firstname,lastname ASC");	

			rc.prj = QueryExecute("SELECT DISTINCT projects.projectName, 
													projects.projectID
									FROM projects LEFT JOIN projectUsers 
										ON projectUsers.projects_projectID = projects.projectID
									WHERE projectUsers.users_userID = " &SESSION.userID& " 
									ORDER BY projects.projectName");
		}
		
		if(rc.prj.recordCount != 0){
			rc.data = QueryExecute("SELECT timeentries.timeEntryID, 
											timeentries.entryDate, 
											timeentries.description, 
											timeentries.hours, 
											timeentries.minute, 
											users.firstname, 
											users.lastname, 
											tickets.ticketTypeID, 
											tickets.code, 
											tickets.title, 
											projects.code as pcode,
											projects.projectName
						FROM timeentries 
							LEFT JOIN users 
								ON timeentries.userID = users.userID
							LEFT JOIN tickets 
								ON timeentries.ticketID = tickets.ticketID 
							LEFT JOIN projects 
								ON tickets.projectID = projects.projectID
						WHERE date_format(timeentries.entryDate,'%Y/%m/%d') BETWEEN '"&dateFormat(URL.start,"yyyy/mm/dd")&"' 
							AND '"&dateFormat(URL.end,"yyyy/mm/dd")&"'
						ORDER BY timeentries.entryDate DESC
						");

			var sumHour = 0;
			for(item in rc.data)
			{
				sumHour = sumHour + rc.data.hours*60 + (rc.data.minute eq ''?0:rc.data.minute);
			}
			rc.sum = sumHour;

			// Show time with every user in project;
			rc.listTimeTicketUser = QueryExecute("
									SELECT (sum(te.hours) * 60 + sum(te.minute) ) AS minutes, 
											u.userID, 
											CONCAT(u.firstname,' ',u.lastname)AS username
									FROM timeentries te 
										LEFT JOIN users u 
											ON te.userID = u.userID
									WHERE date_format(te.entryDate,'%Y/%m/%d') BETWEEN '"&dateFormat(URL.start,"yyyy/mm/dd")&"' 
										AND '"&dateFormat(URL.end,"yyyy/mm/dd")&"'
									GROUP BY u.userID
									ORDER BY minutes DESC");
			// Total time all users worked
			var totalTimeOfUser = 0;
			for(item in rc.listTimeTicketUser){
				totalTimeOfUser += rc.listTimeTicketUser.minutes ;
			}
			rc.totalTime = totalTimeOfUser;

			/* Show total time in project for every users taking part in */
			rc.totalTimeProject = QueryExecute("
									SELECT (sum(te.hours)*60+sum(te.minute)) as minutes,
											te.userID, 
											p.projectID, 
											p.projectName
									FROM timeentries te 
										LEFT JOIN tickets t
											ON te.ticketID = t.ticketID
										LEFT JOIN projects p 
											ON t.projectID = p.projectID
										LEFT JOIN users u 
											ON te.userID = u.userID
									WHERE date_format(te.entryDate,'%Y/%m/%d') BETWEEN '"&dateFormat(URL.start,"yyyy/mm/dd")&"' 
										AND '"&dateFormat(URL.end,"yyyy/mm/dd")&"'
									GROUP BY p.projectID
									ORDER BY 
										minutes desc");
		}
		// close if countRecord neq 0;
	}

	function loadDefault(struct rc) {
		rc.thisdate=now();
		var astartDay= DateFormat(rc.thisdate-DayofWeek(rc.thisdate)+2,"yyyy/mm/dd");
		var aendDay= DateFormat(rc.thisdate-DayofWeek(rc.thisdate)+7,"yyyy/mm/dd");
		if(!structKeyExists(URL, "start"))
		{
			URL.start = astartDay;
			URL.end = aendDay;
		}
		else if (!structKeyExists(URL, "end"))
		{
			URL.end = aendDay;
		}
		rc.ticketType = QueryExecute("SELECT * FROM tickettypes");
		if(SESSION.userType EQ 3)
		{
			rc.users = QueryExecute("SELECT * FROM users");
			rc.prj = QueryExecute("SELECT DISTINCT projects.projectName, 
										projects.projectID
									FROM projects 
									LEFT JOIN projectUsers 
										ON projectUsers.projects_projectID = projects.projectID 
									ORDER BY projects.projectName");
		}
		else{
			rc.users = QueryExecute("SELECT * FROM users WHERE users.active = 1");	

			rc.prj = QueryExecute("SELECT DISTINCT projects.projectName, 
													projects.projectID
									FROM projects LEFT JOIN projectUsers 
										ON projectUsers.projects_projectID = projects.projectID
									WHERE projectUsers.users_userID = " &SESSION.userID& " 
									ORDER BY projects.projectName");
		}
		
		if(rc.prj.recordCount != 0){
			
			// Show time with every user in project;
			rc.listTimeTicketUser = QueryExecute("
									SELECT (sum(te.hours) * 60 + sum(te.minute) ) AS minutes, 
											u.userID, 
											CONCAT(u.firstname,' ',u.lastname)AS username
									FROM timeentries te 
										LEFT JOIN users u 
											ON te.userID = u.userID
									WHERE date_format(te.entryDate,'%Y/%m/%d') BETWEEN '"&dateFormat(URL.start,"yyyy/mm/dd")&"' 
										AND '"&dateFormat(URL.end,"yyyy/mm/dd")&"'
									GROUP BY u.userID
									ORDER BY minutes DESC");
			// Total time all users worked
			var totalTimeOfUser = 0;
			for(item in rc.listTimeTicketUser){
				totalTimeOfUser += rc.listTimeTicketUser.minutes ;
			}
			rc.totalTime = totalTimeOfUser;

			/* Show total time in project for every users taking part in */
			rc.totalTimeProject = QueryExecute("
									SELECT (sum(te.hours)*60+sum(te.minute)) as minutes,
											te.userID, 
											p.projectID, 
											p.projectName
									FROM timeentries te 
										LEFT JOIN tickets t
											ON te.ticketID = t.ticketID
										LEFT JOIN projects p 
											ON t.projectID = p.projectID
										LEFT JOIN users u 
											ON te.userID = u.userID
									WHERE date_format(te.entryDate,'%Y/%m/%d') BETWEEN '"&dateFormat(URL.start,"yyyy/mm/dd")&"' 
										AND '"&dateFormat(URL.end,"yyyy/mm/dd")&"'
									GROUP BY p.projectID
									ORDER BY 
										minutes desc");
		}	
	
	}
	
	/* 
	function load(struct rc)
	{
		rc.thisdate=now();
		var astartDay= DateFormat(rc.thisdate-DayofWeek(rc.thisdate)+2,"yyyy/mm/dd");
		var aendDay= DateFormat(rc.thisdate-DayofWeek(rc.thisdate)+7,"yyyy/mm/dd");
		if(!structKeyExists(URL, "start"))
		{
			URL.start = astartDay;
			URL.end = aendDay;
		}
		else if (!structKeyExists(URL, "end"))
		{
			URL.end = aendDay;
		}
	
		var queryString="";
		queryString&=queryString eq "" ? " date_format(timeentries.entryDate,'%Y/%m/%d') BETWEEN '"&dateFormat(URL.start,"yyyy/mm/dd")&"' AND '"&dateFormat(URL.end,"yyyy/mm/dd")&"'" : " AND date_format(timeentries.entryDate,'%Y/%m/%d') BETWEEN '"&dateFormat(URL.start,"yyyy/mm/dd")&"' AND '"&dateFormat(URL.end,"yyyy/mm/dd")&"'";

		if(structKeyExists(URL, "pid")){
			queryString&=queryString eq "" ? " tickets.projectID IN ("&URL.pid&")" : " AND tickets.projectID IN ("&URL.pid&")";
		}
		if(structKeyExists(URL, "uid")){
			queryString&=queryString eq "" ? "timeentries.userID IN ("&URL.uid&")" : " AND timeentries.userID IN ("&URL.uid&")";
		}
		if(structKeyExists(URL, "tid")){
			queryString&=queryString eq "" ? "tickets.ticketTypeID IN ("&URL.tid&")" : " AND tickets.ticketTypeID IN ("&URL.tid&")";
		}
		
		// if(rc.prj.recordCount != 0)
		// {
			rc.data = QueryExecute("SELECT timeentries.timeEntryID, timeentries.entryDate, users.firstname, users.lastname, timeentries.description, timeentries.hours, tickets.ticketTypeID, tickets.code, projects.code as pcode, tickets.title
						FROM timeentries LEFT JOIN users ON timeentries.userID = users.userID
						LEFT JOIN tickets ON timeentries.ticketID = tickets.ticketID 
						LEFT JOIN projects ON tickets.projectID = projects.projectID
						WHERE "&queryString&"
						ORDER BY timeentries.entryDate DESC");
				
			var sumHour = 0;
			var htmlRe = "";
			for(item in rc.data)
			{
				sumHour = sumHour + rc.data.hours;
				switch(item.ticketTypeID){
					case 1:
						var dicon = '<i class="fa fa-bug red" title="Bug"></i>';
					break;
					case 2:
						var dicon = '<i class="fa fa-level-up green" title="Improvement"></i>';
					break;
					case 3:
						var dicon = '<i class="fa fa-plus-square blue" title="New feature"></i>';
					break;
					case 4:
						var dicon = '<i class="fa fa-search yellow" title="Internal Issue"></i>';
					break;				
					default:
						var dicon = '<i class="fa fa-at"></i>';
					break;
				}
				htmlRe &= '<tr>
								<th style="font-weight:normal;">#dateFormat(item.entryDate,"yyyy-mm-dd")#</th>
								<th style="font-weight:normal;">#item.firstname# #item.lastname#</th>
								<th style="font-weight:normal;">#dicon# <a class="green" href="/index.cfm/ticket?project=#item.pcode#&id=#item.code#" title="#item.title#">#item.code#</a> #item.description#</th>
								<th style="font-weight:normal;">#item.hours#</th>
							</tr>'
			}
			rc.sum = sumHour;
		// }
		return variables.fw.renderData("json",{'success':true, 'te' : htmlRe, 'dcount' : rc.data.recordCount, 'sumHour' : rc.sum});
	} */

	function timeline(struct rc)
	{
		if(SESSION.userType eq 3){
			rc.projects=QueryExecute("SELECT projectID,code,projectName FROM projects ORDER BY projectName");
		}else{
			rc.projects=QueryExecute("SELECT projectID,code,projectName FROM projects p 
									LEFT JOIN projectUsers pu 
									ON p.projectID=pu.projects_projectID
									WHERE pu.users_userID="&SESSION.userID&" ORDER BY p.projectName");
		}
		if(rc.projects.recordCount != 0){
			var whereString1="";
			if(structKeyExists(URL,"pj")){
				for(item in rc.projects) {
				   if(item.code eq URL.pj){
				   		whereString1&="WHERE projectID="&item.projectID;
				   		rc.projectName=item.projectName;
				   }
				}
			}
			if(structKeyExists(URL,"as")){
				whereString1&=whereString1 eq ""? " WHERE assignedUserID="&URL.as : " AND assignedUserID="&URL.as;
			}
			if(SESSION.userType eq 3){
				rc.users=QueryExecute("SELECT userID,firstname,lastname
										FROM users
										WHERE userTypeID=2 OR userTypeID=3");
				rc.listTickets=QueryExecute("SELECT ticketID,code,title,firstname,reportDate,dueDate,estimate,t.assignedUserID as user,s.color
								FROM tickets t
								LEFT JOIN users u 
								ON t.assignedUserID = u.userID
								LEFT JOIN status s
								ON t.statusID=s.statusID
								"&whereString1&"
								ORDER BY dueDate ASC");
			}else{
				var whereString="";
				if(rc.projects.recordCount eq 1){
					whereString=" pu.projects_projectID="&rc.projects.projectID;
					whereString1= whereString1==""?" projectID="&rc.projects.projectID:whereString1;
				}else{
					
					if(whereString1 == ""){
						for(item in rc.projects) {
						   whereString&=whereString eq "" ? " pu.projects_projectID="&item.projectID : " OR pu.projects_projectID="&item.projectID;
						   whereString1&=whereString1 eq "" ? "WHERE projectID="&item.projectID : " OR projectID="&item.projectID;
						}
					}else{
						for(item in rc.projects) {
						   whereString&=whereString eq "" ? " pu.projects_projectID="&item.projectID : " OR pu.projects_projectID="&item.projectID;
						}
					}
				}
				
				if(whereString neq ""){
					rc.users=QueryExecute("SELECT userID,firstname,lastname
										FROM users u
										LEFT JOIN projectUsers pu 
										ON u.userID=pu.users_userID
										WHERE u.active = 1 and (userTypeID=2 OR userTypeID=3)
											AND ("&whereString&")
										GROUP BY userID");
				}
				if(whereString1 neq ""){
					rc.listTickets=QueryExecute("SELECT ticketID,code,title,firstname,reportDate,dueDate,estimate,t.assignedUserID as user,s.color
								FROM tickets t
								LEFT JOIN users u 
								ON t.assignedUserID = u.userID
								LEFT JOIN status s
								ON t.statusID=s.statusID
								"&whereString1&"
								ORDER BY dueDate ASC");
				}
			}
		}	
	}
	function monthly(struct rc){
		if(!structKeyExists(URL, "date"))
		{
			URL.date = dateFormat(now(), "yyyy-mm-dd");
		}
		rc.cYear = year(URL.date);
		rc.cMonth = month(URL.date);
	}
	function loadMonthly(struct rc){
		var astartDay 	= URL.date&'-01';
		var aendDay 	= URL.date&'-'&DaysInMonth(URL.date);
		
		rc.listTimeTicketUser = QueryExecute("
									SELECT ( sum(te.hours) * 60 + sum(te.minute) ) AS minutes, sum(te.hours),sum( te.minute ),
											u.userID, 
											CONCAT(u.firstname,' ',u.lastname)AS username
									FROM timeentries te 
										LEFT JOIN users u 
											ON te.userID = u.userID
									WHERE date_format(te.entryDate,'%Y-%m-%d') BETWEEN '"&dateFormat(astartDay, "yyyy-mm-dd")&"' 
										AND '"&dateFormat(aendDay, "yyyy-mm-dd")&"'
									GROUP BY u.userID
									ORDER BY minutes DESC");
			rc.totalTimeProject = QueryExecute("
									SELECT (sum(te.hours) * 60 + sum(te.minute) ) AS minutes, 
											p.projectID, 
											p.projectName,
											p.code as pcode
									FROM timeentries te 
										LEFT JOIN tickets t
											ON te.ticketID = t.ticketID
										LEFT JOIN projects p 
											ON t.projectID = p.projectID
									WHERE date_format(te.entryDate,'%Y-%m-%d') BETWEEN '"&dateFormat(astartDay, "yyyy-mm-dd")&"' 
										AND '"&dateFormat(aendDay, "yyyy-mm-dd")&"'
										
									GROUP BY p.projectID
									ORDER BY minutes DESC");
	}
	function weekly(struct rc)
	{
		if(SESSION.userType EQ 3){
			rc.users = QueryExecute("SELECT CONCAT(u.firstname,' ',u.lastname) AS fullName,
											u.userID
									FROM users u
									ORDER BY fullName asc");

			rc.projects = QueryExecute("SELECT projects.projectID, 
												projects.projectName, 
												projects.code, 
												projects.shortName,
												projects.projectURL
										FROM projects 
										WHERE projects.projectStatusID != 6 
										ORDER BY projects.projectName");
		}
		else{
			rc.users = QueryExecute("SELECT CONCAT(u.firstname,' ',u.lastname) AS fullName,
											u.userID
									FROM users u
									WHERE u.active=1
									ORDER BY fullName asc");

			rc.projects = QueryExecute("SELECT DISTINCT 
											projects.projectID, 
											projects.projectName, 
											projects.code, 
											projects.shortName, 
											projects.projectURL
										FROM projects 
											INNER JOIN projectUsers 
												ON projects.projectID = projectUsers.projects_projectID
										WHERE projects.projectStatusID != 6 
											AND projectUsers.users_userID = "&SESSION.userID&" 
										ORDER BY projects.projectName");
		}
			// new code;
		rc.thisdate 	= now();
		var astartDay 	= DateFormat(rc.thisdate-DayofWeek(rc.thisdate)+2,"yyyy/mm/dd");
		var aendDay 	= DateFormat(rc.thisdate-DayofWeek(rc.thisdate)+6,"yyyy/mm/dd");

		if(!structKeyExists(URL, "start")){
			URL.start = astartDay;
			URL.end = aendDay;
		}
		else if (!structKeyExists(URL, "end"))
		{
			URL.end = aendDay;
		}

		if(rc.projects.recordCount != 0)
		{

			rc.weekrp 	= arrayNew(1);
			rc.users 	= entityLoad("users",{},"firstname, lastname ASC");
			rc.thisdate = now();
			rc.thisid 	= 0;
			rc.thisUid 	= 0;
			
			var astartDay 	= DateFormat(rc.thisdate-DayofWeek(rc.thisdate)+2,"yyyy-mm-dd");
			var aendDay 	= DateFormat(rc.thisdate-DayofWeek(rc.thisdate)+6,"yyyy-mm-dd");

			if(rc.thisUid == 0)
			{
				var dusers = entityLoad("users");
			}
			else{
				var dusers = entityLoad("users", {userID : rc.thisUid});
			}
			var dpid = "";
			if(rc.projects.recordCount == 1)
			{
				dpid = dpid & rc.projects.projectID;
			}
			else{
				for (var i=1; i<=rc.projects.recordCount; i++)
				{
					dpid = dpid & rc.projects.projectID[i];
					if(i != rc.projects.recordCount)
						dpid = dpid & ",";
				}
			}
			for(user in dusers)
			{
				if(SESSION.userType == 3)
				{
					if(rc.thisid == 0)
					{
						var weekwork = QueryExecute("select u.firstname, 
														u.lastname, 
														p.projectName, 
														p.code as pcode,  
														tm.hours, 
														tm.minute, 
														tm.entryDate, 
														status.statusName, 
														status.color, 
														t.title, 
														tm.description,
														t.code
														from (select ticketID, userID,entryDate, GROUP_CONCAT(tm.description SEPARATOR '<br />') as description, sum(hours) as hours ,sum(minute) as minute
										FROM timeentries tm 
										group by ticketID, userID, entryDate) tm
										inner join users u on tm.userID = u.userID
										inner join tickets t on tm.ticketID = t.ticketID
										inner join status on t.statusID = status.statusID
										inner join projects p on p.projectID  = t.projectID
									where date_format(tm.entryDate, '%Y-%m-%d') BETWEEN :startDay AND :endDay and u.userID =:id
									order by p.projectID, u.firstname, u.lastname", 
									{id:user.userID, startDay:astartDay, endDay:aendDay});
					}
					else{
						var weekwork = QueryExecute("select u.firstname, u.lastname, p.projectName, p.code as pcode,  tm.hours, tm.minute, tm.entryDate, status.statusName, status.color, t.title, tm.description,t.code
								from (select ticketID, userID,entryDate, GROUP_CONCAT(tm.description SEPARATOR '<br />') as description, sum(hours) as hours, sum(minute) as minute
								FROM timeentries tm 
								group by ticketID, userID, entryDate) tm
								inner join users u on tm.userID = u.userID
								inner join tickets t on tm.ticketID = t.ticketID
								inner join status on t.statusID = status.statusID
								inner join projects p on p.projectID  = t.projectID
								where date_format(tm.entryDate, '%Y-%m-%d') BETWEEN :startDay AND :endDay and u.userID =:id and p.projectID =:pid
								order by p.projectID, u.firstname, u.lastname", 
							{pid:rc.thisid, id:user.userID, startDay:astartDay, endDay:aendDay});
					}
				}
				else{
					if(rc.thisid == 0)
					{
						var weekwork = QueryExecute("select u.firstname, u.lastname, p.projectName, p.code as pcode,  tm.hours, tm.minute, tm.entryDate, status.statusName, status.color, t.title, tm.description,t.code
										from (select ticketID, userID,entryDate, GROUP_CONCAT(tm.description SEPARATOR '<br />') as description, sum(hours) as hours, sum(minute) as minute
										FROM timeentries tm 
										group by ticketID, userID, entryDate) tm
										inner join users u on tm.userID = u.userID
										inner join tickets t on tm.ticketID = t.ticketID
										inner join status on t.statusID = status.statusID
										inner join projects p on p.projectID  = t.projectID
									where t.projectID IN ("&dpid&")
									AND date_format(tm.entryDate, '%Y-%m-%d') BETWEEN :startDay AND :endDay and u.userID =:id
									order by p.projectID, u.firstname, u.lastname", 
							{id:user.userID, startDay:astartDay, endDay:aendDay});
					}
					else{
						var weekwork = QueryExecute("select u.firstname, u.lastname, p.projectName, p.code as pcode,  tm.hours, tm.minute, tm.entryDate, status.statusName, status.color, t.title, tm.description,t.code
								from (select ticketID, userID,entryDate, GROUP_CONCAT(tm.description SEPARATOR '<br />') as description, sum(hours) as hours, sum(minute) as minute
								FROM timeentries tm 
								group by ticketID, userID, entryDate) tm
								inner join users u on tm.userID = u.userID
								inner join tickets t on tm.ticketID = t.ticketID
								inner join status on t.statusID = status.statusID
								inner join projects p on p.projectID  = t.projectID
								where date_format(tm.entryDate, '%Y-%m-%d') BETWEEN :startDay AND :endDay and u.userID =:id and p.projectID =:pid
								order by p.projectID, u.firstname, u.lastname", 
							{pid:rc.thisid, id:user.userID, startDay:astartDay, endDay:aendDay});
					}
				}

				arr=arrayNew(1);
				arr[2]=arrayNew(1); arr[2][1]=0;
				arr[3]=arrayNew(1);	arr[3][1]=0;
				arr[4]=arrayNew(1);	arr[4][1]=0;
				arr[5]=arrayNew(1);	arr[5][1]=0;
				arr[6]=arrayNew(1);	arr[6][1]=0;
				arr[7]=arrayNew(1);	arr[7][1]=0;
				arr[8]=arrayNew(1);	arr[8][1]=0;
				var log={};
				for(work in weekwork)
				{
					log={
						project:work.projectname,
						ticket: work.code & ' ' & work.title ,
						status: work.statusName,
						color: work.color,
						ticketcode: work.code,
						projectcode: work.pcode,
						des: work.description,
						hours: work.hours,
						minute: work.minute eq ''?0:work.minute
					};
					arr[DayofWeek(work.entryDate)][1] += (work.hours*60+(work.minute eq ''?0:work.minute));
					arr[DayofWeek(work.entryDate)][arrayLen(arr[DayofWeek(work.entryDate)])+1]=log;
				} 
				rc.weekrp[arrayLen(rc.weekrp)+1]={
					name:user.firstname,
					logs:arr
				}
			}
			// close for;
			rc.totalWeek = QueryExecute("
									SELECT (sum(te.hours)*60+sum(te.minute)) AS minutes, 
											te.userID, 
											u.firstname, 
											u.lastname, 
											u.userID,
											p.projectID, 
											p.projectName
									FROM timeentries te 
										LEFT JOIN tickets t
											ON te.ticketID = t.ticketID
										LEFT JOIN projects p 
											ON t.projectID = p.projectID
										LEFT JOIN users u 
											ON te.userID = u.userID
									WHERE date_format(te.entryDate,'%Y-%m-%d') BETWEEN '"&dateFormat(URL.start,"yyyy-mm-dd")&"' 
										AND '"&dateFormat(URL.end,"yyyy-mm-dd")&"'
									GROUP BY u.userID
									ORDER BY 
									minutes desc");
			
			rc.totalTimeProject = QueryExecute("
									SELECT (sum(te.hours) * 60 + sum(te.minute) ) AS minutes, 
											p.projectID, 
											p.projectName,
											p.code as pcode
									FROM timeentries te 
										LEFT JOIN tickets t
											ON te.ticketID = t.ticketID
										LEFT JOIN projects p 
											ON t.projectID = p.projectID
									WHERE date_format(te.entryDate,'%Y-%m-%d') BETWEEN '"&dateFormat(astartDay, "yyyy-mm-dd")&"' 
										AND '"&dateFormat(aendDay, "yyyy-mm-dd")&"'
									GROUP BY p.projectID
									ORDER BY minutes DESC");
			// Get total time in a week user worked;
		}
		// close if project.countRecord !=0;
	}
	// load weekly report

	function daily(struct rc)
	{
		if(SESSION.userType EQ 3){
			rc.prj = QueryExecute("SELECT projects.projectID, 
										projects.projectName, 
										projects.code, 
										projects.shortName, 
										projects.projectURL
									FROM projects 
										WHERE projects.projectStatusID != 6 
									AND projects.active = 1  
									ORDER BY projects.projectName");
		}
		else{
			rc.prj = QueryExecute("SELECT DISTINCT projects.projectID, 
											projects.projectName,
											 projects.code, 
											 projects.shortName, 
											 projects.projectURL
									FROM projects 
										INNER JOIN projectUsers 
											ON projects.projectID = projectUsers.projects_projectID
									WHERE projects.projectStatusID != 6 
										AND projectUsers.users_userID = "&SESSION.userID&" 
										AND projects.active = 1 ORDER BY projects.projectName");
		}
		
		if(!structKeyExists(rc, "date"))
		{
			rc.date = dateFormat(now(), "yyyy-mm-dd");
		}
		if(rc.prj.recordCount != 0){
			rc.dailyChart = QueryExecute("
									SELECT 	IFNULL( (SELECT (sum(te.hours)*60 +sum(te.minute)) 
												FROM  timeentries te
												WHERE date_format(te.entryDate,'%Y-%m-%d') = '"&rc.date&"'
													AND te.userID = u.userID),0
												)AS minutes,
											IFNULL( (SELECT tr.totalWorked 
												FROM logworktracker tr 
												WHERE tr.userID = u.userID
													AND tr.isFinish != 1
													AND date_format(tr.startTime,'%Y-%m-%d') = '"&rc.date&"'),0
												) As track,
											u.userID, 
											u.firstname, 
											u.lastname
									FROM users u 
									WHERE (u.userTypeID = 2 OR u.userTypeID = 4 )
										AND u.active = 1
									ORDER BY (minutes+track) DESC");
		}		
		rc.data = arrayNew(1);
		for (project in rc.prj){
			// writeDump("d");
			var tmp = structNew();
			tmp.projectID = project.projectID;
			tmp.projectName = project.projectName;
			tmp.projectURL = project.projectURL;
			tmp.code = project.code;
			tmp.shortName = project.shortName;
			tmp.entry = arrayNew(1);
			var entries = QueryExecute("SELECT users.userID, 
											users.firstname, 
											users.lastname, 
											tickets.ticketID, 
											tickets.title, 
											tickets.code, 
											tickets.description as tdes, 
											status.statusName, 
											status.color, 
											timeentries.hours, 
											timeentries.minute, 
											timeentries.description, 
											timeentries.dateEntered
										FROM timeentries 
											INNER JOIN tickets 
												ON timeentries.ticketID = tickets.ticketID
											INNER JOIN users 
												ON users.userID = timeentries.userID
											INNER JOIN status 
												ON tickets.statusID = status.statusID
										WHERE tickets.projectID = "&project.projectID&"
											AND date_format(timeentries.entryDate,'%Y-%m-%d') = '"&rc.date&"'
										ORDER BY userID ASC, tickets.ticketID ASC");
			// writeDump(entries);
			var flag = 0;
			var flag1 = 0;
			var dhour = 0;
			var dminute = 0;
			for (var i=1; i<=entries.recordCount; i++){
				// if(entries.userID[i] == 2)
				// 	writeDump("var")
				// writeDump(entries.hours[i]);
				if(entries.userID[i] NEQ flag)
				{
					var tk = arrayNew(1);
					var tpl = structNew();
					tpl.userID = entries.userID[i];
					tpl.userName = entries.firstname[i] & " " & entries.lastname[i];
					tpl.hour = entries.hours[i];
					tpl.minute = entries.minute[i] eq ''?0:entries.minute[i];
					tpl.dayEnter = entries.dateEntered[i];
					dhour = dhour + entries.hours[i];
					dminute = dminute + (entries.minute[i] eq ''?0:entries.minute[i]);

					var subTk = structNew();
					subTk.ticketName = entries.title[i];
					subTk.status = entries.statusName[i];
					subTK.color = entries.color[i];
					subTk.des = entries.tdes[i];
					subTk.code = entries.code[i];
					subTk.hour = entries.hours[i];
					subTk.minute = entries.minute[i] eq ''?0:entries.minute[i];
					subTk.logs = "- "&entries.description[i]&" <br>";
					flag1 = entries.ticketID[i];
					flag = entries.userID[i];
				}
				else{
					
					if (flag1 NEQ entries.ticketID[i])
					{
						var subTk = structNew();
						subTk.ticketName = entries.title[i];
						subTk.status = entries.statusName[i];
						subTK.color = entries.color[i];
						subTk.des = entries.tdes[i];
						subTk.code = entries.code[i];						
						subTk.hour = entries.hours[i];
						subTk.minute = entries.minute[i] eq ''?0:entries.minute[i];
						subTk.logs = "- "&entries.description[i]&" <br>";
						flag1 = entries.ticketID[i];
					}
					else{
						subTk.logs = subTk.logs&"- "&entries.description[i]&"<br>";
						subTk.hour = subTk.hour + entries.hours[i];
						subTk.minute = subTk.minute + (entries.minute[i] eq ''?0:entries.minute[i]);
					}
					tpl.hour = tpl.hour + entries.hours[i];
					dhour = dhour + entries.hours[i];
					tpl.minute = tpl.minute +( entries.minute[i] eq ''?0:entries.minute[i]);
					dminute = dminute + (entries.minute[i] eq ''?0:entries.minute[i]);
				}
				if(entries.ticketID[i] NEQ entries.ticketID[i+1] || i EQ entries.recordCount || entries.userID[i] NEQ entries.userID[i+1])
				{
					arrayAppend(tk, subTk);
				}
				if(entries.userID[i] NEQ entries.userID[i+1] OR i EQ entries.recordCount)
				{
					// tpl.hours = dhour;
					tpl.dlogs=tk;
					arrayAppend(tmp.entry, tpl);
					
				}
			}
			tmp.hours = dhour;	
			tmp.minute = dminute;	
			arrayAppend(rc.data, tmp);
		}
	}
	function sendDailyReport(struct rc)
	{
		var today = dateFormat(now(),"yyyy-mm-dd");
		rc.data = arrayNew(1);
		var listEntries = QueryExecute("
			SELECT sum(te.hours*60 + te.minute) AS time, te.description AS entryDescription, te.userID, u.firstname, u.lastname, te.ticketID, t.title, p.projectID, p.projectName
			FROM timeentries te 
			LEFT JOIN tickets t ON te.ticketID = t.ticketID
			LEFT JOIN projects p ON t.projectID = p.projectID
			LEFT JOIN users u ON te.userID = u.userID
			WHERE te.entryDate = '#today#'
			GROUP BY te.ticketID
			ORDER BY 
				u.userID,
				p.projectID,
				t.ticketID
			");
		rc.userTime = QueryExecute("
			SELECT sum(te.hours*60 + te.minute) AS time, te.userID, u.firstname, u.lastname
			FROM timeentries te 
			LEFT JOIN tickets t ON te.ticketID = t.ticketID
			LEFT JOIN users u ON t.assignedUserID = u.userID
			WHERE te.entryDate = '#today#'
			GROUP BY te.ticketID
			ORDER BY 
				time desc;
			");
		rc.notWorkingUser = QueryExecute("
			SELECT CONCAT(u.firstname,' ',u.lastname) AS name,u.email
			FROM users u
			WHERE u.userID NOT IN (SELECT te.userID FROM timeentries te
						WHERE te.entryDate = '#today#'
						GROUP BY u.userID)
				AND (u.userTypeID = 2 OR u.userTypeID = 4) 
				AND u.active = 1
			ORDER BY u.firstname 
			");
		rc.projectTime = QueryExecute("
			SELECT sum(te.hours*60 + te.minute) AS time, p.projectID, p.projectName
			FROM timeentries te 
			LEFT JOIN tickets t ON te.ticketID = t.ticketID
			LEFT JOIN projects p ON t.projectID = p.projectID			
			WHERE te.entryDate = '#today#'
			GROUP BY p.projectName
			ORDER BY 
				time desc,
				p.projectID
			")
		if(listEntries.recordCount neq 0){
			rc.hasEntry = true ;
			var curUserID 	= 0 ;
			var curProjectID= 0 ;
			var curTicketID	= 0 ;
			var userIndex	= 0 ;
			var projectIndex= 0 ;
			var ticketIndex = 0 ;
			var countP 		= 0 ;
			var countT 		= 0 ;
			var countL 		= 0 ;
			var totalTime 	= 0 ;
			for(entry in listEntries) {
				// test userID
				if( entry.userID neq curUserID ){
					userIndex++ ;
					rc.data[userIndex] = structNew();
					curUserID = entry.userID ;
					rc.data[userIndex].username = entry.firstname & ' ' & entry.lastname ;
					rc.data[userIndex].projects = [] ;
					rc.data[userIndex].row = 0 ;
					curProjectID= 0 ;
					projectIndex = 0 ;
					curTicketID	= 0 ;
					ticketIndex = 0 ;
					totalTime = 0;
				}
				// test projectID
				if( entry.projectID neq curProjectID ){
					projectIndex ++ ;
					rc.data[userIndex].projects[projectIndex].projectname = entry.projectName ;
					rc.data[userIndex].projects[projectIndex].tickets = [] ;
					rc.data[userIndex].projects[projectIndex].row = 0 ;
					curProjectID = entry.projectID;
					curTicketID	= 0 ;
					ticketIndex = 0 ;
				}
				// test ticketID
				if( entry.ticketID neq  curTicketID ){
					ticketIndex ++ ;
					rc.data[userIndex].projects[projectIndex].tickets[ticketIndex].ticketname = entry.title ;
					rc.data[userIndex].projects[projectIndex].tickets[ticketIndex].entries = [] ;
					rc.data[userIndex].projects[projectIndex].tickets[ticketIndex].row = 0;
					curTicketID = entry.ticketID;
				}
				logtime = entry.time;
				rc.data[userIndex].projects[projectIndex].tickets[ticketIndex].logtime = logtime;
				totalTime = totalTime + logtime;
				rc.data[userIndex].totalTime = totalTime;
				// add entry 
				// var item = {} ;
				// 	item.logTime = (entry.hours*60 + (entry.minute eq ''?0:entry.minute));
				// 	item.logDescription = entry.entryDescription ;
				rc.data[userIndex].row += 1;
				rc.data[userIndex].projects[projectIndex].row += 1;
				rc.data[userIndex].projects[projectIndex].tickets[ticketIndex].row += 1;

				// arrayAppend(rc.data[userIndex].projects[projectIndex].tickets[ticketIndex].entries, item);
			}
			var listAdmin = QueryExecute("SELECT email FROM users WHERE userTypeID = 3 ");
			rc.cc = "";
			for(ad in listAdmin) {
			   rc.cc &= rc.cc neq "" ? (","&ad.email) : ad.email ;
			}
		}else{
			rc.hasEntry = false ;
		}
	}
	function sendWeeklyReport(struct rc)
	{
		// var today = dateFormat(now(),"yyyy-mm-dd");
		rc.today = dateFormat(now(),"yyyy-mm-dd");
		rc.FirstWeekDay= DateFormat(rc.today-DayofWeek(rc.today)+2,"yyyy-mm-dd");
		rc.LastWeekDay= DateFormat(rc.today-DayofWeek(rc.today)+6,"yyyy-mm-dd");
		rc.data = arrayNew(1);
		rc.data_usertime = arrayNew(1);
		rc.listTicket = QueryExecute("
			SELECT te.hours , te.minute , te.userID, u.firstname, u.lastname, te.ticketID, t.title AS ticketName, p.projectID, p.projectName,te.entryDate
			FROM tickets t 
			LEFT JOIN timeentries te ON te.ticketID = t.ticketID
			LEFT JOIN projects p ON t.projectID = p.projectID
			LEFT JOIN users u ON te.userID = u.userID
			WHERE te.entryDate >= '#rc.FirstWeekDay#' AND te.entryDate <= '#rc.LastWeekDay#'
			ORDER BY 
				u.userID,
				p.projectID,
				te.entryDate,
				t.ticketID
			");
		rc.userTime = QueryExecute("
			SELECT sum(te.hours*60 + te.minute) AS time, te.userID, u.firstname, u.lastname
			FROM timeentries te 
			LEFT JOIN tickets t ON te.ticketID = t.ticketID
			LEFT JOIN users u ON t.assignedUserID = u.userID
			WHERE te.entryDate >= '#rc.FirstWeekDay#' AND te.entryDate <= '#rc.LastWeekDay#'
			GROUP BY u.userID
			ORDER BY 
				time desc;
			");
		rc.notWorkingUser = QueryExecute("
			SELECT CONCAT(u.firstname,' ',u.lastname) AS name
			FROM users u
			WHERE u.userID NOT IN (SELECT te.userID FROM timeentries te
						WHERE te.entryDate >= '#rc.FirstWeekDay#' AND te.entryDate <= '#rc.LastWeekDay#'
						GROUP BY u.userID)
				AND (u.userTypeID = 2 OR u.userTypeID = 4) 
				AND u.active = 1
			ORDER BY u.firstname 
			");
		rc.projectTime = QueryExecute("
			SELECT sum(te.hours*60 + te.minute) AS time, p.projectID, p.projectName
			FROM timeentries te 
			LEFT JOIN tickets t ON te.ticketID = t.ticketID
			LEFT JOIN projects p ON t.projectID = p.projectID			
			WHERE te.entryDate >= '#rc.FirstWeekDay#' AND te.entryDate <= '#rc.LastWeekDay#'
			GROUP BY p.projectName
			ORDER BY 
				time desc
			")
		if(rc.listTicket.recordCount neq 0){
			rc.hasEntry = true ;

			var curUserID 	= 0 ;
			var curProjectID= 0 ;
			var curTicketID = 0 ;
			var curWeekDay  = 0 ;

			var userIndex	= 0 ;
			var projectIndex= 0 ;

			for(entry in rc.listTicket) {
				// test userID
				if( entry.userID neq curUserID ){
					userIndex++ ;
					rc.data[userIndex] = structNew();
					curUserID = entry.userID ;
					rc.data[userIndex].username = entry.firstname & ' ' & entry.lastname ;
					rc.data[userIndex].logtime = 0;
					rc.data[userIndex].projects = [] ;
					rc.data[userIndex].row = 0 ;
					
					curProjectID= 0 ;
					projectIndex = 0 ;

					curTicketID = 0 ;
					curWeekDay  = 0 ;
					// user time data
					rc.data_usertime[userIndex].username = entry.firstname & ' ' & entry.lastname ;
					rc.data_usertime[userIndex].logtime = 0;
					rc.data_usertime[userIndex].tickets = [] ;
					rc.data_usertime[userIndex].tickets[1] = 0 ;
					rc.data_usertime[userIndex].tickets[2] = 0 ;
					rc.data_usertime[userIndex].tickets[3] = 0 ;
					rc.data_usertime[userIndex].tickets[4] = 0 ;
					rc.data_usertime[userIndex].tickets[5] = 0 ;
				}
				// test projectID
				var dif = dateDiff("d", rc.FirstWeekDay, entry.entryDate)+1;

				if( entry.projectID neq curProjectID ){
					projectIndex ++ ;
					rc.data[userIndex].projects[projectIndex].projectname = entry.projectName ;
					rc.data[userIndex].projects[projectIndex].row = 0 ;
					rc.data[userIndex].projects[projectIndex].tickets = [] ;
					rc.data[userIndex].projects[projectIndex].tickets[1] = [] ;
					rc.data[userIndex].projects[projectIndex].tickets[2] = [] ;
					rc.data[userIndex].projects[projectIndex].tickets[3] = [] ;
					rc.data[userIndex].projects[projectIndex].tickets[4] = [] ;
					rc.data[userIndex].projects[projectIndex].tickets[5] = [] ;
					curProjectID = entry.projectID;

					curTicketID = 0 ;
					curWeekDay  = 0 ;
				}
				// test ticket 
				var worktime = (LSParseNumber(entry.hours)*60 + (entry.minute eq ''?0:entry.minute))  ;
				if( dif neq curWeekDay OR entry.ticketID neq curTicketID ){
					curTicketID = entry.ticketID;
					curWeekDay = dif ;
					// add entry 
					var item = {} ;
						item.logtime = worktime ;
						item.name = entry.ticketName ;
					arrayAppend(rc.data[userIndex].projects[projectIndex].tickets[dif],item);
					var nlen = arrayLen(rc.data[userIndex].projects[projectIndex].tickets[dif]);
					rc.data[userIndex].projects[projectIndex].row = nlen gt rc.data[userIndex].projects[projectIndex].row ? nlen : rc.data[userIndex].projects[projectIndex].row;
					var tlen = 0 ;
					for(p in rc.data[userIndex].projects) {
					   tlen += p.row ;
					}
					rc.data[userIndex].row = tlen gt rc.data[userIndex].row ? tlen : rc.data[userIndex].row;
				}else{
					rc.data[userIndex].projects[projectIndex].tickets[dif][arrayLen(rc.data[userIndex].projects[projectIndex].tickets[dif])].logtime += worktime ;
					
				}
				// add hours to user 
				rc.data[userIndex].logtime += LSParseNumber(entry.hours)*60 + (entry.minute eq ''?0:entry.minute);
				// insert user time data 
				rc.data_usertime[userIndex].logtime += worktime;
				rc.data_usertime[userIndex].tickets[dif] +=  worktime;
			}
			var listAdmin = QueryExecute("SELECT email FROM users WHERE userTypeID = 3 ");
			rc.cc = "";
			for(ad in listAdmin) {
			   rc.cc &= rc.cc neq "" ? (","&ad.email) : ad.email ;
			}
		}else{
			rc.hasEntry = false ;
		}
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
	function survey(struct rc) {

			param name="URL.date" default = #dateFormat(now(),'yyyy-mm')#;
			var startDay = URL.date&'-01';
			var endDay 	 = URL.date&'-'& daysInMonth(URL.date);

			// show userType =2 || userType =4 (programmer, tester);
			rc.userList = queryExecute("SELECT 
										CONCAT(u.firstname,' ',u.lastname)AS username, 
										ut.userType, 
										u.userID
										FROM users u 
											LEFT JOIN usertype ut 
												ON u.userTypeID = ut.userTypeID
										WHERE  (u.userTypeID = 2 OR u.userTypeID =4) AND u.active=1
										ORDER BY username
									");
			rc.filterVoteMonthly = QueryExecute("SELECT count(sv.userID) as totalVoted,
														sv.surveyDate as dateVote
												FROM survey sv 
												INNER JOIN users u 
													ON sv.userID = u.userID
												WHERE 
													sv.userID = "&SESSION.userID&"
													AND date_format(sv.surveyDate,'%Y-%m-%d') 
														BETWEEN '"&dateFormat(startDay,"yyyy-mm-dd")&"' 
															AND '"&dateFormat(endDay, "yyyy-mm-dd")&"'
												ORDER BY totalVoted desc
													 ");
	}
	
	function addCheckBox(struct rc){

		param name="URL.date" default = #dateFormat(now(),'yyyy-mm')#;
		param name 	= "rc.cbSurvey" default = 0;

		var startDay = URL.date&'-01';
		var endDay 	 = URL.date&'-'& daysInMonth(URL.date);
		var voter 	= EntityLoadByPK("users", SESSION.userID);

		rc.filterVoteMonthly = QueryExecute("SELECT count(sv.userID) as totalVoted,
														sv.surveyDate as dateVote
												FROM survey sv 
												INNER JOIN users u 
													ON sv.userID = u.userID
												WHERE 
													sv.userID = "&SESSION.userID&"
													AND date_format(sv.surveyDate,'%Y-%m-%d') 
														BETWEEN '"&dateFormat(startDay,"yyyy-mm-dd")&"' 
															AND '"&dateFormat(endDay, "yyyy-mm-dd")&"'
												ORDER BY totalVoted desc
													 ");

		if(rc.cbSurvey neq 0){

			for(VoteID in listtoarray(rc.cbSurvey,',')){
				// Every voter only vote survey enough once in a month, data only accept enough once.
				if(rc.filterVoteMonthly.totalVoted lt 1){
					var addUser = EntityNew("survey");
					addUser.setVoteID(VoteID);
					addUser.setUsers(voter);
					addUser.setSurveyDate(#DateFormat(now(),"yyyy-mm-dd")#);
					EntitySave(addUser);
				}
			}
			variables.fw.redirect('report.resultVote');
		}
	}
	function resultVote(struct rc){
		
		if(!structKeyExists(URL,"date")){
			URL.date = dateFormat(now(),"yyyy-mm-dd");
		}
		rc.cMonth 	 = month(URL.date);
		rc.cYear 	 = year(URL.date);
	}
	function loadVoteMonthly(struct rc){
		var startDay = URL.date&'-01';
		var endDay 	 = URL.date&'-'& daysInMonth(URL.date);
		rc.resultVote = QueryExecute("SELECT CONCAT(u.firstname,' ',u.lastname) AS username,
											count(sv.voteID) as totalVote,
											sv.surveyDate
										FROM survey sv 
											LEFT JOIN users u
												ON sv.voteID = u.userID
										WHERE date_format(sv.surveyDate,'%Y-%m-%d') 
											BETWEEN '"&dateFormat(startDay,"yyyy-mm-dd")&"' 
												AND '"&dateFormat(endDay, "yyyy-mm-dd")&"'
										GROUP BY sv.voteID
										ORDER BY totalVote desc
									");
	}
 }