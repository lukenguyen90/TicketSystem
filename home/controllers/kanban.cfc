component output="false" displayname=""  {

	public function init(required any fw){
		variables.fw =fw;
		return this;
	}
	function default(struct rc){
		param name="URL.pId" default = 0 ;
		param name="URL.sprint" 	default = 0 ;
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
		URL.sprint = isNumeric(URL.sprint) ? URL.sprint : 0 ;
		// get list project
		if(SESSION.userType != 3){
			rc.listProject = QueryExecute("SELECT projects.projectID, 
													projects.projectName, 
													projects.code,
													projects.projectLeadID 
											FROM projects
												INNER JOIN projectUsers 
													ON projects.projectID = projectUsers.projects_projectID
											WHERE projectUsers.users_userID = :id 
												AND projects.active = 1 
												AND projects.projectStatusID != 6 
											ORDER BY projects.projectName",
											{id = SESSION.userID});
		}else{
			rc.listProject = QueryExecute("SELECT projects.projectID, projects.projectName, projects.code,projects.projectLeadID 
				FROM projects 
				WHERE projects.active = 1 AND projects.projectStatusID != 6
				ORDER BY projects.projectName");
		}
		// get current project
		rc.curProject = {
			id 	: 	URL.pId,
			lead: 	0,
			name: 	"",
			code: 	""
		}
		for(p in rc.listProject) {
		   if( p.projectID eq rc.curProject.id ){
		   		rc.curProject.lead = p.projectLeadID ;
		   		rc.curProject.name = p.projectName ;
		   		rc.curProject.code = p.code ;
		   }
		}
		if( rc.curProject.id eq 0 ){
			rc.curProject.id 	= rc.listProject.projectID[1]  ;
			rc.curProject.lead 	= rc.listProject.projectLeadID[1]  ;
			rc.curProject.name 	= rc.listProject.projectName[1];
			rc.curProject.code  = rc.listProject.code[1];
		}
		// get list sprint
		rc.listSprints = QueryExecute("SELECT * FROM modules WHERE projectID = "&rc.curProject.id);
		// get current sprint
		if( URL.sprint eq 0 ){
			rc.curSprint = QueryExecute("SELECT * FROM modules WHERE projectID = "&rc.curProject.id&" AND status = 1 LIMIT 1");
			if(rc.curSprint.recordCount eq 0 ){
				rc.curSprint = QueryExecute("SELECT * FROM modules WHERE projectID = "&rc.curProject.id&" AND isPrivate != 1 LIMIT 1");
			}
		}else{
			rc.curSprint = QueryExecute("SELECT * FROM modules WHERE moduleID = "&URL.sprint&" ");
		}
		// get list user of sprint
		rc.sprintID = rc.curSprint.recordCount eq 0 ? 0 : rc.curSprint.moduleID ;

		rc.listUser = QueryExecute("SELECT users.userID, 
											CONCAT(users.firstname,' ', users.lastname) AS name, 
											users.avatar
									FROM moduleUsers 
										LEFT JOIN users 
											ON moduleUsers.users_userID = users.userID 
									WHERE users.active = 1 
										AND moduleUsers.modules_moduleID = "&rc.sprintID);

		if(rc.curProject.lead eq SESSION.userID OR rc.curSprint.moduleLeadID eq SESSION.userID)
			rc.isLeader = true ;
		else rc.isLeader = false ;
		// get tickets of sprint 
		if(rc.sprintID neq 0){
			// load done ticket
			if(not structKeyExists(SESSION,"dayforclosed"))SESSION.dayforclosed = "7d";
			switch(SESSION.dayforclosed){
				case "7d":
					var lastday = dateFormat(dateAdd("d",-7,now()),"yyyy-mm-dd");
					break;
				case "15d":
					var lastday = dateFormat(dateAdd("d",-15,now()),"yyyy-mm-dd");
					break;
				case "1m":
					var lastday = dateFormat(now(),"yyyy-mm");
					break;
				case "all":
					var lastday = "2014-01-01"; 
					break;
				default :var lastday = dateFormat(dateAdd("d",-7,now()),"yyyy-mm-dd");
			}
			var listTicket = QueryExecute(sql:"
				SELECT t.ticketID, t.epicID, t.statusID, t.point, t.assignedUserID, t.title , t.code , t.isLogStart,
						u.avatar, u.firstname, u.lastname,
						e.epicColor,e.epicName,e.epicDescription,so.solutionName
				FROM tickets t 
					LEFT JOIN users u ON u.userID = t.assignedUserID
					LEFT JOIN epic e ON t.epicID = e.epicID
					LEFT JOIN resolution so on t.solutionID=so.solutionID
				WHERE t.moduleID = #rc.sprintID# AND ( (t.statusID = 6 AND t.closedDate >= '#lastday#') OR t.statusID !=6)
				ORDER BY e.epicPriority DESC , t.statusID, t.dorder
					");
			var curEpic={id:'',name:'none'};
			var epicIndex = 0 ;
			rc.listTicket = [];
			for(tic in listTicket) {
				var newEpicID = tic.epicID ;
			   	if(curEpic.id neq newEpicID OR epicIndex eq 0){
			   		var newEpicName = tic.epicName eq '' ? 'none' :tic.epicName ;
			   		var newRow = {
			   			epicID		: newEpicID eq ''?0:newEpicID,
			   			epicColor 	: tic.epicColor,
			   			epicName 	: newEpicName,
			   			epicDescription:tic.epicDescription,
			   			cols 		: [[],[],[],[]]
			   		}
			   		curEpic = {id:newEpicID,name:newEpicName};
			   		rc.listTicket[++epicIndex] = newRow;
			   	}
			   	var scol = 1 ;
			   	switch(tic.statusID){
			   		case 1:
			   		case 2:
			   			scol = 1 ;
			   		break;
			   		case 4:
			   			scol = 2 ;
			   		break;
			   		case 5:
			   			scol = 3 ;
			   		break;
			   		case 6:
			   			scol = 4 ;
			   		break;
			   	}
			   	var newTicket = {
			   		id : tic.ticketID,
			   		title:tic.title,
			   		point : tic.point,
			   		code : tic.code,
			   		isLogStart:tic.isLogStart,
			   		status : tic.statusID,
			   		solutionName: tic.solutionName,
			   		assignee: { 
			   			id : tic.assignedUserID,
			   			name : tic.firstname&' '&tic.lastname,
			   			avatar : tic.avatar,
			   		}
			   	}
			   	arrayAppend(rc.listTicket[epicIndex].cols[scol],newTicket);
			}
		}
		if(rc.curSprint.recordCount eq 0 OR rc.curProject.id eq 0){
			GetPageContext().getResponse().sendRedirect("/index.cfm/");
		}
	}

	function add2Sprint(struct rc)
	{
		var query = QueryExecute("INSERT INTO moduleUsers(users_userID, modules_moduleID) VALUES("&userID&","&sprintID&")")

		var info = QueryExecute("SELECT userID, CONCAT(firstname,' ',lastname) as name, avatar FROM users WHERE userID = "&userID);
		return variables.fw.renderData("json",{id : info.userID, name : info.name, avatar : info.avatar});
	}

		
	function getListUserNotInSprint(struct rc){		
	var listOutOfUserSprint = QueryExecute("
		SELECT userID, CONCAT(users.firstname,' ', users.lastname) AS name
		FROM users 
		WHERE users.active = 1 and users.userTypeID = '2' and users.userID NOT IN
								(
									SELECT users.userID 
									FROM moduleUsers 
									LEFT JOIN users ON moduleUsers.users_userID = users.userID
									WHERE moduleUsers.modules_moduleID = "&rc.sprintID&"
								) ");		
    return variables.fw.renderData("JSON",{'listuser': queryToArray(listOutOfUserSprint)});	
	}
	function getBurndownChartData(struct rc){
		rc.curSprint = QueryExecute("SELECT * FROM modules WHERE moduleID = "&rc.sprintID);

		var rdate = [];
		var rplan = [];
		var rreal = [];
		if(rc.curSprint.startDate neq '' ){
			var dStart = dateFormat(rc.curSprint.startDate,'yyyy-mm-dd') ;

			var sumPoint = QueryExecute("SELECT SUM(point) as point FROM tickets WHERE moduleID = "&rc.sprintID);
			var totalPoint = sumPoint.point;
			var rePoint = totalPoint;
			var pTicketBefore = QueryExecute(sql:"SELECT SUM(point) AS point FROM tickets WHERE moduleID = :moduleID AND resovldDate <= :start  ",
									params:{
										moduleID:{ value = rc.sprintID ,CFSQLType = 'NUMERIC' },
										start 	:{ value = dStart ,CFSQLType = 'string' }
										});
			rePoint -= 	pTicketBefore.point;
			arrayAppend(rdate ,dateFormat(dStart,'dd-mm-yyyy')) ;
			arrayAppend(rplan ,totalPoint) ;
			arrayAppend(rreal ,rePoint) ;
			var lrTickets = QueryExecute(sql:"SELECT resovldDate AS date ,point FROM tickets WHERE moduleID = :moduleID AND (statusID = 6 OR statusID = 5) AND resovldDate > :start ORDER BY resovldDate ",
									params:{
										moduleID:{ value = rc.sprintID ,CFSQLType = 'NUMERIC' },
										start 	:{ value = dStart ,CFSQLType = 'string' }
										});

			if( rc.curSprint.endDate eq ''){
				var hasEndDate = false ;
			}else{
				var hasEndDate = true ;
				var dEnd 	= rc.curSprint.endDate ;
				var totalDate = dateDiff( "d" , rc.curSprint.startDate, rc.curSprint.endDate );
			}
			for(rTicket in lrTickets) {
				var point = rTicket.point eq '' ? 0 : rTicket.point ;
				if( rTicket.date neq ''){
					var planPoint = totalPoint ;
					rePoint -= point;
					if( hasEndDate and totalPoint neq 0){
						var curDate = dateDiff("d", rc.curSprint.startDate, rTicket.date );
						planPoint -= INT( curDate/totalDate * totalPoint);
					}
					arrayAppend(rdate ,dateFormat(rTicket.date,'dd-mm-yyyy')) ;
					arrayAppend(rplan ,planPoint) ;
					arrayAppend(rreal ,rePoint) ;
				}else{
					rreal[arrayLen(rreal)] =  (rreal[arrayLen(rreal)] eq '' ? 0 : rreal[arrayLen(rreal)]) + rTicket.point ;
				}
			}
			return variables.fw.renderData("JSON",{'success':true,'date':rdate,'plan':rplan,'real':rreal});
		}else{
			return variables.fw.renderData("JSON",{'success':false});
		}
	}
	function changedayforclosed(struct rc){
		try{
			SESSION.dayforclosed = rc.newVal ;
		}catch(any e){
			return variables.fw.renderData("json",false);
		}
		return variables.fw.renderData("json",true);
	}
	function changeStatus(struct rc){
		var ticketapi = new api.ticket();
		var result = ticketapi.changeStatus(LsParseNumber(rc.ticketID),rc.oldStatusID, rc.newStatusID, rc.oldResolutionName, LsParseNumber(rc.newResolutionID));
		// writeDump(result);
		return variables.fw.renderData('json',result);
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
}






