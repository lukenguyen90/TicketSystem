
component output="false" displayname=""  {

	public function init(required any fw){
		variables.fw =fw;
		variables.globalText = new home.controllers.apiGlobalText().init();
		return this;
	}
	
	function default(struct rc) {
		rc.flag=false;
		if(structKeyExists(URL,"id")){
			rc.ticketinfo = loadTicketInfo(URL.id);
			var ticketapi = new api.ticket();		
			rc.getLabelChangeStatus = ticketapi.getLabelChangeStatus(rc.ticketinfo.ticketId);
			if(rc.ticketinfo.recordcount neq 0){
				rc.project=QueryExecute("SELECT projectID,shortName,projectName FROM projects WHERE projectID='"&rc.ticketinfo.projectID&"'");
				SESSION.focuspj = structKeyExists(SESSION, "focuspj") ? SESSION.focuspj : 0 ;
				if(SESSION.focuspj	neq  rc.project.projectID){
					SESSION.focuspj	= rc.project.projectID ;
					QueryExecute("UPDATE users SET focusProject = :project WHERE  userID = :id",
												{ project : SESSION.focuspj , id : SESSION.userID});
				}
				var projectuser=QueryExecute("SELECT projects_projectID FROM projectUsers  WHERE projects_projectID="&rc.ticketinfo.projectID&" AND users_userID="&SESSION.userID);
				if( projectuser.recordcount neq 0 OR SESSION.userType eq 3){
					rc.flag=true;
					rc.listTicketTypes 		= loadTicketTypes();
					rc.listTicketStatuses 	= loadTicketStatus();
					rc.listTicketPriorities = loadTicketPriority();
					rc.listProjectUsers 	= loadProjectUsers(rc.ticketinfo.projectID);
					rc.listTicketFiles		= loadTicketFiles(rc.ticketinfo.ticketID);
					rc.totalTime 			= countTime(rc.ticketinfo.ticketID);
					rc.listResolution 		= loadTicketResolution();
				}
			}
		}
		if(!rc.flag){
			if(rc.ticketinfo.recordcount eq 0){
				rc.useNotTicketCss = false;
			}else{
				rc.useNotTicketCss = true;
			}
		}
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
	
	function loadProjectUsers(string idProject, string idUser=0) {
		listProjectUsers = QueryExecute("select us.userID,CONCAT(us.firstname,' ',us.lastname) AS fullname,avatar 
											from projectUsers pro 
											left join users us 
											on pro.users_userID = us.userID
											where us.active = 1 and pro.projects_projectID ="& idProject & " and us.userID <>" & idUser);
		return listProjectUsers;
	}


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
			var totalTime = rc.hours * 60 + rc.minute ;
			var hours = int(totalTime / 60);
			var minute = totalTime mod 60 ;
			var user=entityLoadbyPK("users",LsParseNumber(rc.user));
			var entry = entityNew("timeEntries");
		    entry.setDateEntered(now());
		    entry.setEntryDate(rc.entryDate);
		    entry.setHours(hours);
		    entry.setMinute(minute);
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
	// function getLabelChangeStatus(struct rc)
	// {
	// 	var ticketapi = new api.ticket();
	// 	var result = ticketapi.getLabelChangeStatus(rc.idTicket)

	// }
	function changeStatus(struct rc) {
		if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn){
			try{
   				var ticketapi = new api.ticket();
   				var result = ticketapi.changeStatus(rc.idTicket,rc.oldStatusID,rc.newStatusID,rc.oldResolutionName,rc.newResolutionID);
   				return variables.fw.renderData('json',result);
			}catch(any e){
				return variables.fw.renderData('json',{'success':false,'message':e.message});
			}
		}
		return variables.fw.renderData('json',{'success':false});
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
	function loadTicketResolution(struct rc) {
	  listTicketResolution = QueryExecute("select solutionID as resolutionID, solutionName as resolutionName, color from resolution");
	  return listTicketResolution;  
 	}
 	function assignToMe(struct rc)
 	{
 		if (CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn)
 		{
 			var oldAsn = QueryExecute("SELECT assignedUserID FROM tickets WHERE ticketID = "&rc.idTicket);
 			// return variables.fw.renderData("json",queryToArray(oldAsn));
 			// var array1 = queryToArray(oldAsn);
 			// writeDump(array1);
 			var oldAsnName = QueryExecute("SELECT firstname FROM users WHERE userID = "&oldAsn.assignedUserID[1]);
 			// var array2 = queryToArray(oldAsnName);
 			var me = QueryExecute("SELECT * FROM users WHERE userID = "&SESSION.userID);
 			var updateAsn = QueryExecute("UPDATE tickets SET assignedUserID = "&SESSION.userID&" WHERE ticketID = "&rc.idTicket);
			var textComment = "<span class='light-blue'> Ticket's asssignee is changed from <span class='orange'>" & oldAsnName.firstname[1] & "</span> to <span class='orange'>" & me.firstname & "</span></span>" ;
			var comment = entityNew("ticketComments",{
				    comment 	= textComment,
					commentDate = now(),
				    ticket	 	= entityLoadbyPK("tickets",LsParseNumber(rc.idTicket)),
				   	user        = entityLoadbyPK("users",LsParseNumber(SESSION.userID))
				});
				entitySave(comment);
 		}
 		return variables.fw.renderData("json",true);
 	}
	function changeAssignee(struct rc) {
		if(CGI.REQUEST_METHOD eq "POST"){
			try{
				var ticketapi = new api.ticket();
				var result = ticketapi.changeAssignee(rc.idTicket,rc.assigneeID);
				return variables.fw.renderData("json",result);
			}catch(any e){
				return variables.fw.renderData("json",{'success':false,'message':e.message});				
			}
		}
	}
	function addComment(struct rc){
		if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn){
			// writeDump(rc);
			var user=entityLoadbyPK("users",LsParseNumber(rc.user));
			var comment = entityNew("ticketComments",{
				    comment 	= rc.comment,
					commentDate =now(),
				    ticket	 	= entityLoadbyPK("tickets",LsParseNumber(rc.ticket)),
				   	user        = user,
				   	internal	= rc.internal
				});
   				entitySave(comment);
   			var result=QueryExecute("SELECT comment,date_format(commentDate, '%M,%d %Y %r') AS date,CONCAT(u.firstname,' ',u.lastname) as userName
							FROM ticketcomments tc
							LEFT JOIN users u
							ON tc.userID = u.userID
							WHERE ticketCommentID= "&comment.ticketCommentID);
			return variables.fw.renderData("json",queryToArray(result) );	
		}
	}
	function loadComment(struct rc){
		if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn){
			from=rc.page*5;
			to=from+5;
			if(SESSION.userType == 1)
			{
				var comments=QueryExecute("SELECT comment,date_format(commentDate, '%M,%d %Y %r') AS date,CONCAT(u.firstname,' ',u.lastname) as userName
							FROM ticketcomments tc
							LEFT JOIN users u
							ON tc.userID = u.userID
							WHERE ticketID= "&rc.ticket&" AND tc.internal = 0
							ORDER BY commentDate DESC
							LIMIT "&from&","&to&" ");
			}else{
				var comments=QueryExecute("SELECT comment,date_format(commentDate, '%M,%d %Y %r') AS date,CONCAT(u.firstname,' ',u.lastname) as userName
							FROM ticketcomments tc
							LEFT JOIN users u
							ON tc.userID = u.userID
							WHERE ticketID= "&rc.ticket&"
							ORDER BY commentDate DESC
							LIMIT "&from&","&to&" ");
			}			
			return variables.fw.renderData("json",queryToArray(comments) );	
		}
		return variables.fw.renderData("json",true);	
	}
	function smartCopy(struct rc)
	{
		var ticket = entityLoad("tickets",{code:  rc.code},true);
		var newTicket = entityNew("tickets");
		var title = ticket.getTitle().split(" ");
		//writeDump(ticket);
		var newTitle = "";
		for(var i=1; i<=arrayLen(title); i++)
		{
			if(i != arrayLen(title) - 2)
				newTitle = newTitle & title[i] & " ";
			else{
				newTitle = newTitle & "(" & dateFormat(now(), "mmm dd, yyyy") & ")";
				break;
			}
		}
		// writeDump(newTicket);
		var numtickets= QueryExecute(sql:"
									SELECT COUNT(ticketID) AS count 
									FROM tickets
									WHERE projectID = :id",
									params:{
										id:{value = ticket.getProject().getProjectID(),CFSQLType='NUMERIC'}
									});
		// writeDump(numtickets);
		var projectInfo=QueryExecute(sql:"
									SELECT projectID,projectName,code,shortName,u.firstname,u.userID as leadID,u.email as leadMail
									FROM projects p  
									LEFT JOIN users u
									ON p.projectLeadID = u.userID
									WHERE projectID = :id",
									params:{
										id:{value = ticket.getProject().getProjectID(),CFSQLType='NUMERIC'}
									});
		var code = projectInfo.shortName&"-"&(numTickets.count+1);
		newTicket.setTitle(newTitle);
		newTicket.setCode(code);
		newTicket.setDescription(ticket.getDescription());
		newTicket.setDueDate(now());
		newTicket.setReportDate(now());
		newTicket.setEstimate(ticket.getEstimate());
		newTicket.setTicketType(ticket.getTicketType());
		newTicket.setPriority(ticket.getPriority());
		newTicket.setStatus(entityLoadbyPK("status",1));
		newTicket.setVersion(ticket.getVersion());
		newTicket.setAssignedUser(entityLoadbyPK("users",15));
		newTicket.setreportedUser(entityLoadbyPK("users",15));
		newTicket.setModule(ticket.getModule());
		newTicket.setProject(ticket.getProject());
		newTicket.setPaid(ticket.getPaid());
		newTicket.setStartDate(now());
		entitySave(newTicket);
		return variables.fw.renderData("text",true);
	}

	function create(struct rc){
		rc.flag=false;
		rc.createdTickets = [];

		if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn AND structKeyExists(rc,"project")){
			if(rc.project neq ''){
				var sProject = entityLoadbyPK('projects',LSParseNumber(rc.project));
				// focus project
				SESSION.focuspj = structKeyExists(SESSION, "focuspj") ? SESSION.focuspj : 0 ;
				if(SESSION.focuspj	neq  rc.project){
					SESSION.focuspj	= rc.project ;
					QueryExecute("UPDATE users SET focusProject = :project WHERE  userID = :id",
												{ project : SESSION.focuspj , id : SESSION.userID});
				}
				// set default for variable
				//  title
				if(rc.title eq ""){
					rc.flag = true ;
					rc.message ="Missing ticket title !";
				}else{
					try{
						rc.createdTickets = rc.created?:[];
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
						newTicket.setPaid( ( rc.selectType eq 2 OR rc.selectType eq 3 ) ? 1 : 0 );
						//  description
						if(rc.description neq ""){
							newTicket.setDescription(rc.description);
						}
						//  point
						if(rc.point neq "" and not isNumeric(rc.point)){
							rc.point = 0 ;
						}

						newTicket.setPoint(rc.point);
						newTicket.setEstimate(rc.point/2);
						//  reportDate startDate dueDate
						var reportDate 	=	dateFormat(now(),"yyyy-mm-dd");
						var dd = INT(rc.point/16) + 1 ;
						var dueDateSelected = dateDiff("d", dateFormat(now(),"yyyy-mm-dd"), rc.ticketDueDate);
						if(rc.ticketDueDate != "" AND dueDateSelected GT 0){
							var dueDate = rc.ticketDueDate;
						}else{
							var dueDate = dateAdd( 'd', dd, reportDate );
							while(dayOfWeek(dueDate) eq 1 OR dayOfWeek(dueDate) eq 7){
								dueDate = dateAdd( 'd', 1, dueDate );
							}
						}						
						dueDate = dateFormat(dueDate,"yyyy-mm-dd");
						newTicket.setReportDate(reportDate);
						newTicket.setDueDate(reportDate);
						newTicket.setDueDate(dueDate);
						// priority
						var lpriority = entityLoad('priority',{ priorityName : variables.globalText.normal },true);
						newTicket.setPriority(lpriority);
						//  reporter
						var lreporter = entityLoadbyPK('users',SESSION.userID);
						newTicket.setreportedUser(lreporter);
						// project leader 
						var pLeader = sProject.getleader() ;
						//  assignee
						if(structKeyExists(rc,'assigntome')){
							var lassignee = lreporter ;
						}else{
							if(structKeyExists(rc,'selectAssignee')){
								if(rc.selectAssignee eq 0 ){
									var lassignee = pLeader ;
								}else{
									var lassignee = entityLoadbyPK('users',LsParseNumber(rc.selectAssignee));
								}
							}
						}
						newTicket.setAssignedUser( lassignee );
						// sprint
						if(structKeyExists(rc, "sprint")){
							var lsprint = entityLoadByPK('modules',rc.sprint);
						}else{
							// default
							if( rc.selectType eq 1 OR  rc.selectType eq 3){
								var qModuleString 	= 	variables.globalText.backlog ;
							}else{
								var qModuleString 	= 	variables.globalText.icebox ;
							}
							var lsprint = entityLoad('modules',{project : sProject , moduleName : qModuleString},true);
						}
						newTicket.setModule(lsprint);
						// type 
						var oType= entityLoadbyPK('ticketTypes',rc.selectType);
						newTicket.setTicketType(oType);

						// default version
						var lversion = entityLoad('versions', { project : sProject } , "versionNumber DESC, versionDate DESC ",{maxresults : 1} );
						newTicket.setVersion(lversion[1]);
						// status 
						var lstatus = entityLoad('status' , {statusName : 'Open' }, true );
						newTicket.setStatus(lstatus);
						if(structKeyExists(rc,"epic")){
							var lepic = entityLoadByPK('epic',LSParseNumber(rc.epic));
							if(not isNull(lepic))
								newTicket.setEpic(lepic);
						}
						// save ticket
						entitySave(newTicket);
						// set file for this ticket
						if(rc.ListFileUpload neq ""){
							insertFile(newTicket.ticketID,rc.ListFileUpload);
						}
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
						arrayPrepend(rc.createdTickets,link);
						if( rc.dcontinue eq "off" ){
							GetPageContext().getResponse().sendRedirect("/index.cfm/ticket?id="&code );			
						}
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
		if(SESSION.userType eq 3){
			rc.projects =QueryExecute("SELECT projectID,projectName FROM projects WHERE active = 1 AND projectStatusID != 6 ORDER BY projectName ASC");
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
	
	function edit(struct rc){
		rc.tags = QueryExecute("SELECT * FROM tags");		
		rc.flag=false;
		if(structKeyExists(URL,'id') ){
			rc.ticketinfo = QueryExecute(sql:"SELECT * FROM tickets WHERE  `code`=:id",params:{id:{value=URL.id,CFSQLType='string'}});
			if(rc.ticketinfo.recordcount neq 1){
				rc.errorMessage = "Could not find ticket with code = "&URL.id ;
			}else{
				rc.URLproject=QueryExecute("SELECT projectID,shortName,projectName,projectLeadID FROM projects WHERE projectID = '"&rc.ticketinfo.projectID&"'");

				if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn AND rc.URLproject.recordcount eq 1){
					var requite=true;
					// param rc.point = 2 ;
					param name="rc.point" default=3 type="NUMERIC";
					rc.message="";
					// set default for variable
					if(structKeyExists(rc,"paid")){
						rc.paid=1;
						}else{
						rc.paid=0;
					}

					if(structKeyExists(rc,"dcontinue")){
						rc.dcontinue=1;
						}else{
						rc.dcontinue=0;
					}
					// writeDump(rc.dcontinue);
					// test title
					if(structKeyExists(rc,"title")){
						if(rc.title eq ""){
							requite=false;rc.message&="title,";
						}
						}else{
						requite=false;rc.message&="title,";
					}
					// test description
					if(structKeyExists(rc,"description")){
						if(rc.description eq ""){
							rc.description="...";
						}
					}else{
						rc.description="...";
					}
					
					// test dueDate
					if(structKeyExists(rc,"dueDate")){
						if( REFind("^\d{4}[-]\d{2}[-]\d{2}$",rc.dueDate) eq 0){
							rc.dueDate=dateFormat(now()+1,"yyyy-mm-dd");
						}
					}else{
						rc.dueDate=dateFormat(now()+1,"yyyy-mm-dd");
					}
					// test reportDate
					if(structKeyExists(rc,"reportDate")){
						if( REFind("^\d{4}[-]\d{2}[-]\d{2}$",rc.reportDate) eq 0){
							rc.reportDate=dateFormat(now(),"yyyy-mm-dd");
						}
					}else{
						rc.reportDate=dateFormat(now(),"yyyy-mm-dd");
					}
					// test Type
					if(!structKeyExists(rc,"selectType")){
						requite=false;rc.message&="type,";
					}
					// test Priority
					if(!structKeyExists(rc,"selectPriority")){
						requite=false;rc.message&="priority,";
					}
					// test assignee
					if(structKeyExists(rc,"assignee")){
						if(rc.assignee eq ""){
							rc.assignee= SESSION.userID;
						}
					}else{
						rc.assignee= SESSION.userID;
					}
					// test reporter
					if(structKeyExists(rc,"reporter")){
						if(rc.reporter eq ""){
							rc.reporter= SESSION.userID;
						}
					}else{
						rc.reporter=SESSION.userID;
					}
					// choose between edit and create
					if(requite){
						var testerQS="null";
						var ccQS="null";
						if(rc.tester neq 0){
							testerQS=rc.tester;
						}
						if(rc.cc neq ""){
							ccQS="'"&rc.cc&"'";
						}
						var query = QueryExecute(sql:"UPDATE tickets SET 
								`title`			= :title,
								`description`	= :description,
								`dueDate`		= '"&rc.dueDate&"', 
								`estimate`		= :estimate, 
								`point`			= :point,
								`ticketTypeID`	= :type, 
								`priorityID`	= :priority, 
								`assignedUserID`= :assignee , 
								`paid` 			= b'"&rc.paid&"',
								`testerUserID`	= #testerQS#,
								`cc`			= #ccQS#,
								`moduleID`		= :module
								WHERE `code`	= :code",
								params:{
									title 		:{value=rc.title 		,CFSQLType='string'},
									code 		:{value=URL.id 			,CFSQLType='string'},
									description :{value=rc.description 	,CFSQLType='string'},
									priority 	:{value=rc.selectPriority,CFSQLType='NUMERIC'},
									type 		:{value=rc.selectType 	,CFSQLType='NUMERIC'},
									assignee 	:{value=rc.assignee 	,CFSQLType='NUMERIC'},
									estimate 	:{value=rc.point/2 	,CFSQLType='NUMERIC'},
									point 		:{value=rc.point 	,CFSQLType='NUMERIC'},
									module 		:{value=rc.sprint 	,CFSQLType='NUMERIC'}
								});
						if(structKeyExists(rc,"epic")){
							if(rc.epic neq 0)
							var query = QueryExecute(sql:"UPDATE tickets SET epicID = :epic WHERE code = :code",
								params:{
										epic:{		value = rc.epic ,		CFSQLType='NUMERIC' },
										code:{		value = URL.id ,		CFSQLType='string' }
									});
						}
						if(rc.ListFileUpload neq ""){
							insertFile(rc.ticketinfo.ticketID,rc.ListFileUpload);
						}
						GetPageContext().getResponse().sendRedirect("/index.cfm/ticket?id="&URL.id&"");	
					}else{
						rc.flag=true;
						rc.message="Missing a require field :"&rc.message;
					}
				}
				rc.priority=QueryExecute("
					SELECT priorityID,priorityName,color 
					FROM priority");
				rc.types=QueryExecute("
					SELECT ticketTypeID,typeName
					FROM tickettypes");
				rc.dtag = QueryExecute("SELECT * 
						FROM tags 
						WHERE tagId 
							IN (SELECT tags_tagId 
								FROM ticketTags 
								WHERE tickets_ticketID = "&rc.ticketinfo.ticketId&")");
			}
		}else{
			location('/index.cfm/ticket/create',false);
		}
	}

	function addTag(struct rc)
	{
		var tags = QueryExecute("INSERT INTO ticketTags(tickets_ticketID, tags_tagId) 
										VALUES(:id, :tid)",
										{
											id 	:rc.ticketID,
											tid :rc.tagID
										});
		return variables.fw.renderData("json",true);
	}

	function createTag(struct rc)
	{
		var check = QueryExecute("SELECT * FROM tags WHERE tagName = '"&rc.tagName&"'");
		if(check.recordcount == 0)
		{
			var tag = entityNew("tags");
			tag.setTagName(rc.tagName);
			entitySave(tag);
			return variables.fw.renderData("json",tag.getTagId);
		}
		else return variables.fw.renderData("json",check.getTagId);
		
	}

	function removeTag(struct rc)
	{
		var tags = QueryExecute("DELETE FROM ticketTags WHERE tickets_ticketID = "&rc.ticketID&" AND tags_tagId = "&rc.tagID);
		return variables.fw.renderData("json",true);
	}
	function delete(struct rc){
		if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn AND structKeyExists(rc,"id") ){
			try{
			var query=QueryExecute("DELETE FROM timeentries WHERE  `timeEntryID`="&rc.id);
			}catch(any e){
				writeDump(e);
				return variables.fw.renderData("json",false);
			}
			return variables.fw.renderData("json",true);
		}
		return variables.fw.renderData("json",false);
	}
	function loadMoreTE(struct rc){
		if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn){
			try{
				var from=rc.page*5;
				var to=5;
				var result=QueryExecute("SELECT timeEntryID,t.userID,t.hours,IFNULL(t.minute,0) AS minute,date_format(entryDate, '%Y-%m-%d') AS date,description,CONCAT(u.firstname,' ',u.lastname) as assignName
								FROM timeentries t
								LEFT JOIN users u
								ON t.userID = u.userID
								WHERE ticketID= "&rc.id&"
								ORDER BY dateEntered DESC,entryDate DESC
								LIMIT "&from&","&to&" ");
				if(result.recordcount neq 0)
					return variables.fw.renderData("json",{'success':true,'arr': queryToArray(result)});
				else 
					return variables.fw.renderData("json",{'success':true,'arr':arrayNew(1)});	
				
			}catch(any e){
				return variables.fw.renderData("json",{'success':false,'message':e.message});	
			}
		}
	}
	function getDataOfProject(struct rc){
		var modules=QueryExecute("SELECT moduleID,moduleName 
					FROM modules 
					WHERE projectID="&rc.project&"
					ORDER BY status DESC, isPrivate ASC , moduleName");
		var epic=QueryExecute("SELECT epicID,epicName
					FROM epic 
					WHERE projectID="&rc.project&"
					ORDER BY epicPriority");
		var code=QueryExecute("SELECT shortName,projectLeadID
					FROM projects 
					WHERE projectID="&rc.project);
		var versions=QueryExecute("SELECT versionID,versionName,versionNumber 
					FROM versions 
					WHERE projectID="&rc.project&"
					ORDER BY versionDate DESC");
		var users=QueryExecute("SELECT userID,CONCAT(u.firstname,' ',u.lastname) as firstname,userTypeID 
					FROM users u
					LEFT JOIN projectUsers pu
					ON u.userID = pu.users_userID
					WHERE u.active = 1 and (pu.projects_projectID="&rc.project&" OR u.userID="&SESSION.userID&") 
					GROUP BY userID
					ORDER BY firstname ASC");
		return variables.fw.renderData("json",{
						modules:queryToArray(modules),
						code:queryToArray(code),
						versions:queryToArray(versions),
						users:queryToArray(users),
						epic:queryToArray(epic)});
	}
	function getSprintOfProject(struct rc){
		var users=QueryExecute("SELECT userID,CONCAT(u.firstname,' ',u.lastname) as fullname,userTypeID 
					FROM users u
					LEFT JOIN projectUsers pu
					ON u.userID = pu.users_userID
					WHERE u.active = 1 and (pu.projects_projectID="&rc.project&" OR u.userID="&SESSION.userID&") AND userTypeID <> 1
					GROUP BY userID
					ORDER BY fullname ASC");
		var modules=QueryExecute("SELECT moduleID,moduleName,status,done
					FROM modules 
					WHERE projectID="&rc.project&"
					ORDER BY status DESC, isPrivate ASC , moduleName");
		var epic=QueryExecute("SELECT epicID,epicName
					FROM epic 
					WHERE projectID="&rc.project&"
					ORDER BY epicPriority");
		return variables.fw.renderData("json",{sprints:queryToArray(modules),epic : queryToArray(epic),users:queryToArray(users)});
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
}
