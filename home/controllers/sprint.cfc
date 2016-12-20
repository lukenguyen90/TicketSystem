component output="false" displayname=""  {
 
	public function init(required any fw){
		variables.fw =fw;
		return this;
	}
	function default_default(struct rc)
	{
		if(SESSION.userType != 3){
			rc.prj = QueryExecute("SELECT projects.projectID, projects.projectName FROM projects
						INNER JOIN projectUsers ON projects.projectID = projectUsers.projects_projectID
						WHERE projectUsers.users_userID = :id AND projects.active = 1
						ORDER BY projects.projectName
						",
						{id = SESSION.userID});
		}else{
			rc.prj = QueryExecute("SELECT projects.projectID, projects.projectName FROM projects WHERE projects.active = 1 ORDER BY projects.projectName");
		}
		if (structKeyExists(URL, "id"))
			rc.projectID = URL.id;
		else{
			rc.projectID = rc.prj.projectID[1];
		}
		var leader = QueryExecute("SELECT projectLeadID AS id FROM projects WHERE projectID = "&rc.projectID);
		rc.isLeader = leader.id eq SESSION.userID ? true : false ;
		rc.moduleInfo = QueryExecute("SELECT * FROM modules WHERE projectID = "&rc.projectID);
		rc.modInfo = structNew();
		for (item in rc.moduleInfo)
		{
			if (item.moduleName == 'Icebox' AND item.isPrivate eq '1' )
				rc.modInfo.iceboxID = item.moduleID;
			if (item.moduleName == 'Backlog' AND item.isPrivate eq '1' )
				rc.modInfo.backlogID = item.moduleID;
		}
		if (structKeyExists(URL, "sp")){
			rc.modInfo.sprintID = URL.sp;
			for (item in rc.moduleInfo)
			{
				if (item.moduleID == rc.modInfo.sprintID)
					rc.modInfo.sprintName = item.moduleName;
			}
		}
		else{
			for (item in rc.moduleInfo)
			{
				if(item.status != ""){
					rc.modInfo.sprintID = item.moduleID;
					rc.modInfo.sprintName = item.moduleName;
				}
				if (item.status == 1){
					rc.modInfo.sprintID = item.moduleID;
					rc.modInfo.sprintName = item.moduleName;
					break;
				}
			}
		}
		rc.icebox = QueryExecute("SELECT * FROM tickets LEFT JOIN status ON tickets.statusID = status.statusID LEFT JOIN users ON tickets.assignedUserID = users.userID WHERE projectID = "&rc.projectID&" AND moduleID = "&rc.modInfo.iceboxID&" ORDER BY dorder ASC");
		rc.backlog = QueryExecute("SELECT * FROM tickets LEFT JOIN status ON tickets.statusID = status.statusID LEFT JOIN users ON tickets.assignedUserID = users.userID WHERE projectID = "&rc.projectID&" AND moduleID = "&rc.modInfo.backlogID&" ORDER BY dorder ASC");

		rc.sprint = QueryExecute("SELECT * FROM tickets LEFT JOIN status ON tickets.statusID = status.statusID LEFT JOIN users ON tickets.assignedUserID = users.userID WHERE projectID = "&rc.projectID&" AND moduleID = "&rc.modInfo.sprintID&" ORDER BY dorder ASC");
		writedump(rc.sprint);
		var mif = QueryExecute("SELECT * FROM modules WHERE moduleID = "&rc.modInfo.sprintID);
		var sumPoint = QueryExecute("SELECT SUM(point) as point FROM tickets WHERE projectID = "&rc.projectID&" AND moduleID = "&rc.modInfo.sprintID);
		var sumTicket = QueryExecute("SELECT COUNT(ticketID) as ticket FROM tickets WHERE projectID = "&rc.projectID&" AND moduleID = "&rc.modInfo.sprintID);
		var dusers = QueryExecute("SELECT users.userID, CONCAT(users.firstname,' ', users.lastname) AS name, users.avatar
							FROM moduleUsers 
							LEFT JOIN users ON moduleUsers.users_userID = users.userID 
							WHERE moduleUsers.modules_moduleID = "&rc.modInfo.sprintID);
		rc.info = structNew();
		rc.info.startDate = (mif.startDate == "")?0:dateFormat(mif.startdate,"yyyy mmmm, dd");
		rc.info.endDate = (mif.endDate == "")?0:dateFormat(mif.endDate,"yyyy mmmm, dd");
		rc.info.endDateEtm = (mif.endDateEtm == "")?0:dateFormat(mif.endDateEtm,"yyyy mmmm, dd");
		rc.info.point = sumPoint.point;
		rc.info.ticket = sumTicket.ticket;
		rc.info.users = arrayNew(1);
		var uid = "";
		for(user in dusers)
		{
			var duser = structNew();
			duser.name = user.name;
			duser.userID = user.userID;
			duser.avatar = user.avatar;
			arrayAppend(rc.info.users, duser);
			uid = uid & user.userID & ",";
		}
		rc.user = QueryExecute("SELECT userID, CONCAT(firstname,' ',lastname) as name, avatar FROM users
				LEFT JOIN projectUsers ON users.userID = projectUsers.users_userID
				WHERE projectUsers.projects_projectID = "&rc.projectID&" AND userID NOT IN ("&uid&"0)");
	}
	
	function default(struct rc)
	{
		param name="URL.pId" default = 0 ;
		// fix input
		URL.pId = isNumeric(URL.pId) ? URL.pId : 0 ;
		if(URL.pId neq 0){
			SESSION.focuspj = structKeyExists(SESSION, "focuspj") ? SESSION.focuspj : 0 ;
			if(SESSION.focuspj	neq URL.pId){
				SESSION.focuspj	= URL.pId ;
				QueryExecute("UPDATE users SET focusProject = :project WHERE  userID = :id",
											{ project : SESSION.focuspj , id : SESSION.userID });
			}
		}

		if(SESSION.userType != 3){
			rc.prj = QueryExecute("SELECT projects.projectID, projects.projectName, projects.projectLeadID, projects.code FROM projects
						INNER JOIN projectUsers ON projects.projectID = projectUsers.projects_projectID
						WHERE projectUsers.users_userID = :id AND projects.active = 1
						ORDER BY projects.projectName
						",
						{id = SESSION.userID});
		}else{
			rc.prj = QueryExecute("SELECT projects.projectID, projects.projectName, projects.projectLeadID, projects.code FROM projects WHERE projects.active = 1 ORDER BY projects.projectName");
		}
		if (URL.pId neq 0)
			rc.projectID = URL.pId;
		else{
			rc.projectID = rc.prj.projectID[1];
		}
		var leader = QueryExecute("SELECT projectLeadID AS id FROM projects WHERE projectID = "&rc.projectID);
		rc.isLeader = leader.id eq SESSION.userID ? true : false ;
		rc.moduleInfo = QueryExecute("SELECT * FROM modules WHERE projectID = "&rc.projectID);
		rc.modInfo = structNew();
		for (item in rc.moduleInfo)
		{
			if (item.moduleName == 'Icebox' AND item.isPrivate eq '1' )
				rc.modInfo.iceboxID = item.moduleID;
			if (item.moduleName == 'Backlog' AND item.isPrivate eq '1' )
				rc.modInfo.backlogID = item.moduleID;
		}
		if (structKeyExists(URL, "sp")){
			rc.modInfo.sprintID = URL.sp;
			for (item in rc.moduleInfo)
			{
				if (item.moduleID == rc.modInfo.sprintID)
					rc.modInfo.sprintName = item.moduleName;
			}
		}
		else{
			for (item in rc.moduleInfo)
			{
				// if(item.status != ""){
					rc.modInfo.sprintID = item.moduleID;
					rc.modInfo.sprintName = item.moduleName;
				// }
				if (item.status == 1){
					rc.modInfo.sprintID = item.moduleID;
					rc.modInfo.sprintName = item.moduleName;
					break;
				}
			}
		}
		rc.icebox = QueryExecute("SELECT * FROM tickets 
									LEFT JOIN status ON tickets.statusID = status.statusID 
									LEFT JOIN users ON tickets.assignedUserID = users.userID 
									WHERE projectID = "&rc.projectID&" AND moduleID = "&rc.modInfo.iceboxID&" 
									ORDER BY dorder DESC, tickets.statusID");

		

		rc.backlog = QueryExecute("SELECT * FROM tickets 
									LEFT JOIN status ON tickets.statusID = status.statusID 
									LEFT JOIN users ON tickets.assignedUserID = users.userID 
									WHERE projectID = "&rc.projectID&" AND moduleID = "&rc.modInfo.backlogID&" 
									ORDER BY dorder DESC, tickets.statusID");
		rc.sprint = QueryExecute("SELECT * FROM tickets 
										LEFT JOIN status ON tickets.statusID = status.statusID 
										LEFT JOIN users ON tickets.assignedUserID = users.userID 
										WHERE projectID = "&rc.projectID&" AND 
											moduleID = "&rc.modInfo.sprintID&" 
										ORDER BY dorder DESC, tickets.statusID");
		//set dorder
		// QueryExecute("update tickets set dorder = '' where ticketID = 1053 ");
		var p.projectID = URL.pId;
		var checkDorder = QueryExecute("select dorder from tickets where projectID ="&p.projectID);
		for (t in checkDorder){
			if(t.dorder eq ""){
				var mid = QueryExecute("select moduleID from modules where projectID = "&p.projectID);
				for (m in mid)
				{
					var ticket = QueryExecute("select ticketID from tickets where moduleID = "&m.moduleID);
					
					for (var i = 1; i<= ticket.recordCount; i++)
					{
						
							QueryExecute("update tickets set dorder = "&i&" where ticketID = "&ticket.ticketID[i]);
					
					}

				}
				break;
			}
		}
		
		// end set dorder
		
		
		var mif = QueryExecute("SELECT * FROM modules WHERE moduleID = "&rc.modInfo.sprintID);
		var sumPoint = QueryExecute("SELECT SUM(point) as point FROM tickets WHERE projectID = "&rc.projectID&" AND moduleID = "&rc.modInfo.sprintID);
		var sumTicket = QueryExecute("SELECT COUNT(ticketID) as ticket FROM tickets WHERE projectID = "&rc.projectID&" AND moduleID = "&rc.modInfo.sprintID);
		var dusers = QueryExecute("SELECT users.userID, CONCAT(users.firstname,' ', users.lastname) AS name, users.avatar
							FROM moduleUsers 
							LEFT JOIN users ON moduleUsers.users_userID = users.userID 
							WHERE moduleUsers.modules_moduleID = "&rc.modInfo.sprintID);
		rc.info = structNew();
		rc.info.startDate = (mif.startDate == "")?0:dateFormat(mif.startdate,"yyyy mmmm, dd");
		rc.info.endDate = (mif.endDate == "")?0:dateFormat(mif.endDate,"yyyy mmmm, dd");
		rc.info.endDateEtm = (mif.endDateEtm == "")?0:dateFormat(mif.endDateEtm,"yyyy mmmm, dd");
		rc.info.point = sumPoint.point;
		rc.info.ticket = sumTicket.ticket;
		rc.info.description = mif.description;
		rc.info.status = mif.status;
		rc.info.users = arrayNew(1);
		var uid = "";
		for(user in dusers)
		{
			var duser = structNew();
			duser.name = user.name;
			duser.userID = user.userID;
			duser.avatar = user.avatar;
			arrayAppend(rc.info.users, duser);
			uid = uid & user.userID & ",";
		}
		rc.userOutSprint = QueryExecute("SELECT userID, CONCAT(firstname,' ',lastname) as name, avatar, firstname FROM users
				LEFT JOIN projectUsers ON users.userID = projectUsers.users_userID
				WHERE projectUsers.projects_projectID = "&rc.projectID&" AND userID NOT IN ("&uid&"0)
										");
		rc.userInSprint = QueryExecute("SELECT userID, CONCAT(firstname,' ',lastname) as name, firstname, avatar FROM users
				LEFT JOIN projectUsers ON users.userID = projectUsers.users_userID
				WHERE projectUsers.projects_projectID = "&rc.projectID&" AND userID IN ("&uid&"0)");
		rc.curProject = {
			id 	: 	URL.pId,
			lead: 	0,
			name: 	"",
			code: 	""
		}

		for(p in rc.prj) {
		   if( p.projectID eq rc.curProject.id ){
		   		rc.curProject.lead = p.projectLeadID ;
		   		rc.curProject.name = p.projectName ;
		   		rc.curProject.code = p.code ;
		   }
		}
		if( rc.curProject.id eq 0 ){
			rc.curProject.id 	= rc.prj.projectID[1]  ;
			rc.curProject.lead 	= rc.prj.projectLeadID[1]  ;
			rc.curProject.name 	= rc.prj.projectName[1];
			rc.curProject.code  = rc.prj.code[1];
		}
	}

	function add(struct rc){
		if( CGI.REQUEST_METHOD == "post" ){
			var sprintName = rc.name?:"";
			var sprintDes = rc.description?:"";
			var sprintEstimate = rc.estimate?:0;
			var pid = rc.pid?:0;
			var sDate = listToArray((rc.seDate ?:""),"-");
			var dStart = "";
			var dEnd = "";
			if( arrayLen(sDate) eq 2 ){
				dStart 	= getTrueDate( sDate[1] );
				dEnd 	= getTrueDate( sDate[2] );
			}
			if( sprintName != "" AND sprintDes != "" AND pid != 0 AND dStart != "" AND dEnd != "" ){
				queryService = new query();
				result = queryService.execute(sql="
					INSERT INTO modules 
							(`moduleName`, `description`,`estimate`,`projectID`,`startDate`,`endDate`,`isPrivate`) 
					VALUES 	( '"&sprintName&"', '"&sprintDes&"',"&sprintEstimate&","&pid&",'"&dStart&"','"&dEnd&"', 0 )"); 
				sprintKey = result.getPrefix().generatedkey; 
				location("/index.cfm/sprint?pId=#pid#&sp=#sprintKey#",false);
			}
		}
		location("/index.cfm/sprint",false);
	}

	function startSprint(struct rc) 
	{
		var info = QueryExecute("SELECT * FROM modules WHERE status = 1 AND projectID = "&rc.projectID);
		var endDate = getTrueDate(rc.endDate?:dateFormat(now(),"dd/mm/yyyy"));
		if (info.recordCount > 0)
		{
			if (info.moduleID == rc.moduleID)
			{
				var module = QueryExecute("UPDATE modules SET startDate = now(), endDateEtm = '"&endDate&"' WHERE moduleID = "&rc.moduleID);
				return variables.fw.renderData("json",{flag : true});
			}
			else{
				if (info.endDate == "" && info.startDate != ""){
					return variables.fw.renderData("json",{flag : false, name : info.moduleName});	
				}
				else{
					var module = QueryExecute("UPDATE modules SET status = 0 WHERE status = 1 AND projectID = "&rc.projectID);
					var module = QueryExecute("UPDATE modules SET status = 1, startDate = now(), endDateEtm = '"&endDate&"' WHERE moduleID = "&rc.moduleID);
					return variables.fw.renderData("json",{flag : true});
				}
			}
		}else{	
			var module = QueryExecute("UPDATE modules SET status = 1, startDate = now(), endDateEtm = '"&endDate&"' WHERE moduleID = "&rc.moduleID);
			return variables.fw.renderData("json",{flag : true});
		}		
	}
	
	function stopSprint(struct rc) 
	{
		var module = QueryExecute("UPDATE modules SET status=0, endDate = now(), endDateEtm = now() WHERE moduleID = "&rc.moduleID);
		return variables.fw.renderData("text",true);
	}

	function checkSprint(struct rc)
	{
		var info = QueryExecute("SELECT * FROM modules WHERE status = 1 AND projectID = "&rc.projectID);
		if (info.recordCount > 0)
		{
			if (info.moduleID == rc.moduleID)
			{
				return variables.fw.renderData("json",{flag : true});
			}
			else{
				if (info.endDate == "" && info.startDate != "")
					return variables.fw.renderData("json",{flag : false, name : info.moduleName});	
				else{
					return variables.fw.renderData("json",{flag : true});
				}
			}
		}else{	
			return variables.fw.renderData("json",{flag : true});
		}		
	}

	function addMember(struct rc)
	{
		var query = QueryExecute("INSERT INTO moduleUsers(users_userID, modules_moduleID) VALUES("&rc.userID&","&rc.moduleID&")");
		var info = QueryExecute("SELECT userID, CONCAT(firstname,' ',lastname) as name, avatar FROM users WHERE userID = "&rc.userID);
		return variables.fw.renderData("json",{id : info.userID, name : info.name, avatar : info.avatar});
	}

	function removeUser(struct rc){
		try {
			var query = QueryExecute("DELETE FROM moduleUsers WHERE users_userID = "&rc.userID&" AND modules_moduleID = "&rc.moduleID&" ");
			return variables.fw.renderData("json",{"success":true});
		}
		catch(any e) {
			return variables.fw.renderData("json",{"success":false});
		}		
	}

	function moveTicket(struct rc)
	{
		try{
			var oldModule = QueryExecute("SELECT moduleName FROM tickets
					LEFT JOIN modules ON tickets.moduleID = modules.moduleID
					WHERE tickets.ticketID = "&rc.ticketID);
		var newModule = QueryExecute("SELECT moduleName FROM modules WHERE moduleID = "&rc.moduleID);
		var ticket = QueryExecute("UPDATE tickets SET moduleID = "&rc.moduleID&" WHERE ticketID = "&rc.ticketID);
		// var textComment = "<span class='light-blue'> Ticket has moved from <span class='orange'>" & oldModule.moduleName & "</span> to <span class='orange'>" & newModule.moduleName & "</span></span>" ;
		// 	var comment = entityNew("ticketComments",{
		// 		    comment 	= textComment,
		// 			commentDate = now(),
		// 		    ticket	 	= entityLoadbyPK("tickets",LsParseNumber(rc.ticketID)),
		// 		   	user        = entityLoadbyPK("users",LsParseNumber(SESSION.userID)),
		// 		   	internal	= 1
		// 		});
		// 		entitySave(comment);
		var info = QueryExecute("SELECT point FROM tickets WHERE ticketID = "&rc.ticketID);
		return variables.fw.renderData("json",{flag : true, point : info.point});
		}
		catch(any e){
			writedump(e);
			return variables.fw.renderData("json",{flag : false});
		}
		
	}
	public function moveVertical(struct rc)
	{	
		try{
			var ticket = QueryExecute("UPDATE tickets SET dorder = "&rc.currentID&" WHERE ticketID = :id",{id = rc.moveToSticketID});
	        var ticket = QueryExecute("UPDATE tickets SET dorder = "&rc.nextID&" WHERE ticketID = :id",{id = rc.currentTicketID});
	        variables.fw.renderData("json",true);
	    }catch(any e){
	    	writedump(e);
	    	variables.fw.renderData("json",false);
	    }
		
	}

	// function upOrder (struct rc)
	// {
	// 	// var pid = QueryExecute("select projectID from projects");
	// 	// for(p in pid)
	// 	// {
	// 		var tid = arraynew(1);
	// 		var p.projectID = URL.pId;
	// 		var mid = QueryExecute("select moduleID from modules where projectID = "&p.projectID);
	// 		for (m in mid)
	// 		{
	// 			var ticket = QueryExecute("select ticketID from tickets where moduleID = "&m.moduleID);
				
	// 			for (var i = 1; i<= ticket.recordCount; i++)
	// 			{
					
	// 					var update1 = QueryExecute("update tickets set dorder = "&i&" where ticketID = "&ticket.ticketID[i]);
					
	// 			}
	// 		}
	// 	// }
	// 	return variables.fw.renderData("text",true);
	// }

	function estimatePoint(struct rc)
	{
		if(rc.point <= 5)
		{
			var ticket = QueryExecute("UPDATE tickets SET point = "&rc.point&", statusID = 1 WHERE ticketID = "&rc.ticketID);
			var textComment = "<span class='light-blue'> Ticket has estimated <span class='orange'>" & rc.point & " point(s)</span></span>" ;
			var comment = entityNew("ticketComments",{
				    comment 	= textComment,
					commentDate = now(),
				    ticket	 	= entityLoadbyPK("tickets",LsParseNumber(rc.ticketID)),
				   	user        = entityLoadbyPK("users",LsParseNumber(SESSION.userID)),
				   	internal	= 1
				});
				entitySave(comment);
			return variables.fw.renderData("text",true);
		}
		else return variables.fw.renderData("text",false);		
	}

	function changeAssignee(struct rc)
	{
		if (CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn)
 		{
 			var user = QueryExecute("SELECT userID, CONCAT(firstname,' ',lastname) AS name FROM users 
			LEFT JOIN projectUsers ON users.userID = projectUsers.users_userID
			WHERE users.active=1 and projectUsers.projects_projectID = "&rc.projectID);	
			var asnUser = arrayNew(1);
			for (item in user)
			{
				var us = structNew();
				us.userID = item.userID;
				us.userName = item.name;
				arrayAppend(asnUser, us);
			}
 			var oldAsn = QueryExecute("SELECT assignedUserID FROM tickets WHERE ticketID = "&rc.ticketID);
 			var oldAsnName = QueryExecute("SELECT CONCAT(firstname,' ',lastname) as name FROM users WHERE userID = "&oldAsn.assignedUserID[1]);
 			var me = QueryExecute("SELECT CONCAT(firstname,' ',lastname) as name FROM users WHERE userID = "&rc.userID);
 			var updateAsn = QueryExecute("UPDATE tickets SET assignedUserID = "&rc.userID&" WHERE ticketID = "&rc.ticketID);
			var textComment = "<span class='light-blue'> Ticket's asssignee has changed from <span class='orange'>" & oldAsnName.name[1] & "</span> to <span class='orange'>" & me.name & "</span></span>" ;
			var comment = entityNew("ticketComments",{
				    comment 	= textComment,
					commentDate = now(),
				    ticket	 	= entityLoadbyPK("tickets",LsParseNumber(rc.ticketID)),
				   	user        = entityLoadbyPK("users",LsParseNumber(rc.userID)),
				   	internal	= 1
				});
				entitySave(comment);
 		}
 		return variables.fw.renderData("json",{'name':me.name, 'user' : asnUser});
	}

	function changePoint(struct rc)
	{
		if(rc.point <= 5)
		{
			var oldPoint = QueryExecute("SELECT point FROM tickets WHERE ticketID = "&rc.ticketID);
			var ticket = QueryExecute("UPDATE tickets SET point = "&rc.point&" WHERE ticketID = "&rc.ticketID);
			var textComment = "<span class='light-blue'> Ticket's point has changed from <span class='orange'>" & oldPoint.point & " point(s)</span> to <span class='orange'>" & rc.point & " point(s)</span></span>" ;
			var comment = entityNew("ticketComments",{
				    comment 	= textComment,
					commentDate = now(),
				    ticket	 	= entityLoadbyPK("tickets",LsParseNumber(rc.ticketID)),
				   	user        = entityLoadbyPK("users",LsParseNumber(SESSION.userID)),
				   	internal	= 1
				});
				entitySave(comment);
			return variables.fw.renderData("text",true);
		}
		else return variables.fw.renderData("text",false);		
	}

	function changeType(struct rc)
	{
		if (CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn)
 		{
 			var type = QueryExecute("SELECT * FROM tickettypes");
			var ticketType = arrayNew(1);
			for (item in type)
			{
				var tt = structNew();
				tt.typeID = item.ticketTypeID;
				tt.typeName = item.typeName;
				arrayAppend(ticketType, tt);
			}
			
 			var oldTypeName = QueryExecute("SELECT typeName FROM tickets 
 								LEFT JOIN tickettypes ON tickettypes.ticketTypeID = tickets.ticketTypeID
 			    				WHERE tickets.ticketID = "&rc.ticketID);
 			var newType = QueryExecute("SELECT typeName FROM tickettypes WHERE ticketTypeID = "&rc.typeID);
 			var updateTicket = QueryExecute("UPDATE tickets SET ticketTypeID = "&rc.typeID&" WHERE ticketID = "&rc.ticketID);
			var textComment = "<span class='light-blue'> Ticket's type has changed from <span class='orange'>" & oldTypeName.typeName & "</span> to <span class='orange'>" & newType.typeName & "</span></span>" ;
			var comment = entityNew("ticketComments",{
				    comment 	= textComment,
					commentDate = now(),
				    ticket	 	= entityLoadbyPK("tickets",LsParseNumber(rc.ticketID)),
				   	user        = entityLoadbyPK("users",LsParseNumber(SESSION.userID)),
				   	internal	= 1
				});
				entitySave(comment);
 		}
 		return variables.fw.renderData("json",{'name':newType.typeName});
	}

	function test(struct rc)
	{
		var dq = QueryExecute("select projectID from projects");
		for (item in dq)
		{
			var query = QueryExecute("insert into modules(moduleName, projectID) values('Icebox', "&item.projectID&")");
			var query = QueryExecute("insert into modules(moduleName, projectID) values('Backlog', "&item.projectID&")");
		}
		return variables.fw.renderData("json",true);
	}
	function changeStatus(struct rc)
	{
		var ticketID = rc.ticketID;
		var statusID = rc.statusID;
		var userID = rc.userID;
		if (rc.statusID == 1 || rc.statusID == 2)
			statusID = 4;
		else if (rc.statusID == 4)
			statusID = 5;
		else if (rc.statusID == 5)
		{
			if (structKeyExists(rc, "reject"))
				statusID = 2;
			if (structKeyExists(rc, "accept"))
				statusID = 6;
		}
		
		rc.staComment = "";
		var oldStatus = QueryExecute("SELECT statusName FROM status WHERE statusID = "&rc.statusID);
		var newStatus = QueryExecute("SELECT statusName FROM status WHERE statusID = "&statusID);
		var status=entityLoadbyPK("status",LSParseNumber(statusID));
		var ticket=entityLoadbyPK("tickets",LSParseNumber(ticketID));
		var user=entityLoadbyPK("users",LsParseNumber(userID));
		if (rc.statusID == 1)
		{
			ticket.setAssignedUser(user);
		}
		if (ticket.getAssignedUser().userID == userID OR SESSION.userType == 3){
			var userName = QueryExecute("SELECT CONCAT(firstname,' ', lastname) as name FROM users WHERE userID = "&ticket.getAssignedUser().userID);
			if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn){
				ticket.setStatus(status);
				entitySave(ticket);
				var textComment = "<span class='light-blue'> Ticket's status has changed from <span class='orange'>" & oldStatus.statusName & "</span> to <span class='orange'>" & newStatus.statusName & "</span></span>" ;
				var comment = entityNew("ticketComments",{
					    comment 	= textComment,
						commentDate = now(),
					    ticket	 	= ticket,
					   	user        = user,
					   	internal 	= 1
					});
	   				entitySave(comment);
	   			// send email  			
	   			var email = createObject("component", "home.controllers.email");
	   			var ticketInfo= QueryExecute("SELECT p.code AS pCode,cc,p.projectName,p.projectLeadID,t.projectID,t.code AS code, t.title ,t.estimate,t.reportedByUserID,t.assignedUserID
	   											FROM tickets t 
	   											LEFT JOIN projects p 
	   											ON t.projectID=p.projectID
	   											WHERE ticketID="&ticketID);
	   			var link = "http://"&CGI.http_host&"/index.cfm/ticket?project="&ticketInfo.pCode&"&id="&ticketInfo.code;
	   			var projectLink="http://"&CGI.http_host&"/index.cfm/project/?id="&ticketInfo.projectID;
		        var mailBody="";
		        var totalEntriesTime=QueryExecute("SELECT SUM(hours) AS hours FROM timeentries WHERE ticketID="&ticketID);
		        switch(oldStatus.statusName&"-"&newStatus.statusName){
		        	case "Open-In Progress":
		        	ticket.setStartDate(now());
		        	var newEndDate = dateAdd('d',Ceiling(ticket.getPoint()/16),now());
		        	ticket.setDueDate(newEndDate);
					entitySave(ticket);
		        	var mailBody=email.getTemplate("Open-In Progress");
					var mailSub=email.getSubject("Open-In Progress");
					mailSub=ReplaceAtt(mailSub,link," ",ticketInfo.code,ticketInfo.title,projectLink,ticketInfo.projectName,ticketInfo.estimate,totalEntriesTime.hours,rc.staComment);
					mailBody=ReplaceAtt(mailBody,link,mailSub,ticketInfo.code,ticketInfo.title,projectLink,ticketInfo.projectName,ticketInfo.estimate,totalEntriesTime.hours,rc.staComment);
		        		listTo=QueryExecute("SELECT DISTINCT email 
											FROM users u 
											LEFT JOIN usertype t
											ON u.userTypeID=t.userTypeID
											LEFT JOIN notification n 
											ON u.notificationID=n.notificationID
											WHERE u.active = 1 and n.levelNumber>1 
												AND	(userID="&ticketInfo.projectLeadID&" 
													OR 	userID="&ticketInfo.reportedByUserID&"
													OR (n.levelNumber=3 AND u.userID in (SELECT users_userID FROM projectUsers WHERE projects_projectID="&ticketInfo.projectID&") )
													OR 	n.levelNumber=4
													)
		        							Group By email");
		        	break;
		        	case "Reopened-In Progress":
		        	ticket.setStartDate(now());
		        	var newEndDate = dateAdd('d',Ceiling(ticket.getPoint()/16),now());
		        	ticket.setDueDate(newEndDate);
					entitySave(ticket);
		        	var mailBody=email.getTemplate("Reopened-In Progress");
					var mailSub=email.getSubject("Reopened-In Progress");
					mailSub=ReplaceAtt(mailSub,link," ",ticketInfo.code,ticketInfo.title,projectLink,ticketInfo.projectName,ticketInfo.estimate,totalEntriesTime.hours,rc.staComment);
					mailBody=ReplaceAtt(mailBody,link,mailSub,ticketInfo.code,ticketInfo.title,projectLink,ticketInfo.projectName,ticketInfo.estimate,totalEntriesTime.hours,rc.staComment);
		        		listTo=QueryExecute("SELECT DISTINCT email 
											FROM users u 
											LEFT JOIN usertype t
											ON u.userTypeID=t.userTypeID
											LEFT JOIN notification n 
											ON u.notificationID=n.notificationID
											WHERE u.active = 1 and n.levelNumber>1 
												AND	(	userID="&ticketInfo.projectLeadID&" 
													OR 	userID="&ticketInfo.reportedByUserID&"
													OR (n.levelNumber=3 AND u.userID in (SELECT users_userID FROM projectUsers WHERE projects_projectID="&ticketInfo.projectID&") )
													OR 	n.levelNumber=4
													)
		        							Group By email");
		        	break;
		        	case "In Progress-Resolved":
		        	ticket.setResovldDate(now());
					entitySave(ticket);
		        	var mailBody=email.getTemplate("In Progress-Resolved");
					var mailSub=email.getSubject("In Progress-Resolved");
					mailSub=ReplaceAtt(mailSub,link," ",ticketInfo.code,ticketInfo.title,projectLink,ticketInfo.projectName,ticketInfo.estimate,totalEntriesTime.hours,rc.staComment);
					mailBody=ReplaceAtt(mailBody,link,mailSub,ticketInfo.code,ticketInfo.title,projectLink,ticketInfo.projectName,ticketInfo.estimate,totalEntriesTime.hours,rc.staComment);
	        			listTo=QueryExecute("SELECT DISTINCT email 
											FROM users u 
											LEFT JOIN usertype t
											ON u.userTypeID=t.userTypeID
											LEFT JOIN notification n 
											ON u.notificationID=n.notificationID
											WHERE u.active = 1 and n.levelNumber>1 
											AND		(	userID="&ticketInfo.projectLeadID&" 
													OR 	userID="&ticketInfo.reportedByUserID&"
													OR (n.levelNumber=3 AND u.userID in (SELECT users_userID FROM projectUsers WHERE projects_projectID="&ticketInfo.projectID&") )
													OR 	n.levelNumber=4
													)
		        							Group By email");
	        			var getActivities=QueryExecute("SELECT activityID FROM activities WHERE activityName='Resolved'");
	        			var cmt='<a href="'&link&'">'&ticketInfo.code&' Resolved</a>';
	        			createNotification(ticketInfo.reportedByUserID, getActivities.activityID, cmt);
		        	break;
		        	case "Resolved-Closed":
		        	ticket.setClosedDate(now());
					entitySave(ticket);
		        	var mailBody=email.getTemplate("Resolved-Closed");
					var mailSub=email.getSubject("Resolved-Closed");
					mailSub=ReplaceAtt(mailSub,link," ",ticketInfo.code,ticketInfo.title,projectLink,ticketInfo.projectName,ticketInfo.estimate,totalEntriesTime.hours,rc.staComment);
					mailBody=ReplaceAtt(mailBody,link,mailSub,ticketInfo.code,ticketInfo.title,projectLink,ticketInfo.projectName,ticketInfo.estimate,totalEntriesTime.hours,rc.staComment);
	        			listTo=QueryExecute("SELECT DISTINCT email 
											FROM users u 
											LEFT JOIN usertype t
											ON u.userTypeID=t.userTypeID
											LEFT JOIN notification n 
											ON u.notificationID=n.notificationID
											WHERE u.active = 1 and n.levelNumber>1 
												AND	(userID="&ticketInfo.projectLeadID&" 
												OR 	userID="&ticketInfo.assignedUserID&" 
												OR 	userID="&ticketInfo.reportedByUserID&" 
												OR (n.levelNumber=3 AND u.userID in (SELECT users_userID FROM projectUsers WHERE projects_projectID="&ticketInfo.projectID&") )
												OR 	n.levelNumber=4
												)
		    							Group By email");
		        	break;
		        	case "Resolved-Reopened":
		        	var mailBody=email.getTemplate("Resolved-Reopened");
		        	var mailSub=email.getSubject("Resolved-Reopened");
					mailSub=ReplaceAtt(mailSub,link," ",ticketInfo.code,ticketInfo.title,projectLink,ticketInfo.projectName,ticketInfo.estimate,totalEntriesTime.hours,rc.staComment);
					mailBody=ReplaceAtt(mailBody,link,mailSub,ticketInfo.code,ticketInfo.title,projectLink,ticketInfo.projectName,ticketInfo.estimate,totalEntriesTime.hours,rc.staComment);
	        			listTo=QueryExecute("SELECT DISTINCT email 
										FROM users u 
										LEFT JOIN usertype t
										ON u.userTypeID=t.userTypeID
										LEFT JOIN notification n 
										ON u.notificationID=n.notificationID
										WHERE u.active = 1 and n.levelNumber>1 
											AND	(	userID="&ticketInfo.projectLeadID&" 
												OR 	userID="&ticketInfo.assignedUserID&" 
												OR (n.levelNumber=3 AND u.userID in (SELECT users_userID FROM projectUsers WHERE projects_projectID="&ticketInfo.projectID&") )
												OR 	n.levelNumber=4
												)
		        							Group By email");
	        			// new action
	        			var getActivities=QueryExecute("SELECT activityID FROM activities WHERE activityName='Reopened'");
	        			var cmt='<a href="'&link&'"> '&ticketInfo.code&' Reopened</a>';
	        			createNotification(ticketInfo.assignedUserID, getActivities.activityID, cmt);
		        	break;
		        
		        	default:
		        		mailBody="";
		        	break;
		        }
		        if(mailBody neq "" ){
		        	if(listTo.recordcount neq 0){
						var toUser="";
						for(item in listTo) {
						   toUser=toUser&item.email&";";
						}
						toUser=toUser&ticketInfo.cc;
						sendEmail(toUser,mailSub,mailBody);
		        	}
		        }
	   			// end send email
				
			}
			return variables.fw.renderData("json",{flag : true, name: userName.name });
		}
		else {
			return variables.fw.renderData("json",{flag : false});
		}
	}

	function updateTicket(struct rc)
	{
		var update = QueryExecute(sql:"UPDATE tickets SET title = :title, description = :des 
									WHERE ticketID = :id",params : {title = rc.title, des = rc.description, id = rc.ticketID});
		var ticket = QueryExecute("SELECT * FROM tickets 
						LEFT JOIN status ON tickets.statusID = status.statusID 
						LEFT JOIN users ON tickets.assignedUserID = users.userID
						LEFT JOIN tickettypes ON tickets.ticketTypeID = tickettypes.ticketTypeID
						WHERE tickets.ticketID = :id",{id = rc.ticketID});
		var ticketInfo = structNew();
		ticketInfo.ticketID = ticket.ticketID;
		ticketInfo.code = ticket.code;
		ticketInfo.color = ticket.color;
		ticketInfo.title = ticket.title;
		ticketInfo.description = ticket.description;
		ticketInfo.point = ticket.point;
		ticketInfo.ticketTypeID = ticket.ticketTypeID;
		ticketInfo.typeName = ticket.typeName;
		ticketInfo.statusID = ticket.statusID;
		ticketInfo.statusName = ticket.statusName;
		ticketInfo.moduleID = ticket.moduleID;
		ticketInfo.dorder = ticket.dorder;
		ticketInfo.firstname = ticket.firstname;
		ticketInfo.lastname = ticket.lastname;
		ticketInfo.avatar = ticket.avatar;
		ticketInfo.assid = ticket.assignedUserID;
		return variables.fw.renderData("json",{'info': ticketInfo});
	}

	function loadTicket(struct rc)
	{
		rc.oTicket = entityLoadbypk('tickets',rc.ticketID);
		// rc.oComment = entityLoad('ticketComments',rc.ticketID);
		// rc.oFiles = entityLoad('files',rc.ticketID);
		// dump(rc.oFiles);
		// writedump(rc.oTicket);
		// dump(rc.oComment);
		// abort;
	}

		function addComment(struct rc){
		if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn){
			// writeDump(rc);
			var user=entityLoadbyPK("users",LsParseNumber(SESSION.userID));
			var comment = entityNew("ticketComments",{
				    comment 	= rc.comment,
					commentDate =now(),
				    ticket	 	= entityLoadbyPK("tickets",LsParseNumber(rc.ticketID)),
				   	user        = user
				});
   				entitySave(comment);
   			var result=QueryExecute("SELECT comment,date_format(commentDate, '%Y-%M-%d') AS date,CONCAT(u.firstname,' ',u.lastname) as userName
							FROM ticketcomments tc
							LEFT JOIN users u
							ON tc.userID = u.userID
							WHERE ticketCommentID= "&comment.ticketCommentID);
			return variables.fw.renderData("json",{'success': true, 'date': dateFormat(result.date, "yyyy-mm-dd"), 'comment': result.comment, 'userName': result.userName});	
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
	public string function getTrueDate( string sDate){
		var dob = arguments.sDate ?:"01-01-1996";
		if( findNoCase("-", dob ) ){
			aDob = listToArray(dob, "-");
		}else if( findNoCase("/", dob ) ){
			aDob = listToArray(dob, "/");
		}else if( findNoCase(".", dob ) ){
			aDob = listToArray(dob, ".");
		}else{
			aDob = listToArray(dob);
		}
		if( arrayLen(aDob) < 3 ){
			return "1990-01-01";
		}
		return trim(aDob[3]) &"-"& trim(aDob[2]) &"-"& trim(aDob[1]);
	}

}