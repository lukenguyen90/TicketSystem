/**
*
* @file  /C/railo/webapps/ticket/home/controllers/annual_leave.cfc
* @author  
* @description
*
*/

component output="false" displayname=""  {

	public function init(required any fw){
		variables.fw =fw;
		return this;
	}
	
	public any function default(struct rc) {
		if(SESSION.isOfficial )
		{
			rc.user = entityLoadByPk('users',SESSION.userId);
			rc.actions = entityLoad('manageTime',{user:rc.user});
			local.dayoff = entityLoad('dayoff',{userId:SESSION.userId},true);
			rc.projects = QueryExecute("select projectID, projectName from projects p 
											left join projectUsers pu on pu.projects_projectID = p.projectID where pu.users_userID = #SESSION.userId# and projectStatusID < 6");
			rc.otrequest = QueryExecute("select o.*,p.projectName from overtime_request o left join projects p on p.projectID = o.projectId WHERE userId = #SESSION.userId# ") ;

		// get list confirm when make new annual leave 
			var leadUsers = QueryExecute("
				select u.userID, u.firstname, u.lastname 
				from projects p
					left join users u 			on p.projectLeadID = u.userID
					left join projectUsers pu 	on pu.projects_projectID = p.projectID 
				where 	pu.users_userID = #SESSION.userId# 
					and p.projectStatusID < 6
				group by u.userID");
			var isLeader = false ;
			rc.requiredList = [];
			var withoutUser = [];
			for(lead in leadUsers) {
				if( lead.userID == SESSION.userId ){
					isLeader = true ;
				}else{
					var newItem = {
						id = lead.userID,
						name = lead.firstname&" "&lead.lastname
					}
					arrayAppend(rc.requiredList, newItem );
					arrayAppend(withoutUser,lead.userID);
				}
			}
			if( isLeader OR arrayLen( rc.requiredList ) == 0){
				var withoutQuery = "";
				if( arrayLen(withoutUser) > 0){
					withoutQuery = " AND u.userID not in (#arraytolist(withoutUser)#) ";
				}
				var permissionManager = QueryExecute("
					select u.userID, u.firstname, u.lastname 
					from permissionmanager pm
						left join users u 			on pm.userId = u.userID
					where 	pm.isActive = 1 #withoutQuery#
					group by u.userID");
				for(pm in permissionManager) {
					if( pm.userID != SESSION.userId ){
						var newItem = {
							id = pm.userID,
							name = pm.firstname&" "&pm.lastname
						}
						arrayPrepend(rc.requiredList, newItem );
					}
				}

			}
		// end 
			if( !isNull(dayoff))
				rc.annual_leave = dayoff;

			rc.reportDayOff = [];
			rc.requests = [];
			rc.requireds = [];
			var manageTime = queryToArray(QueryExecute('select * from manageTime where userID = :uId',{uId=SESSION.userId}));
			for(item in manageTime) {
				if(item.status)
				{
					var report = {
			   		'startTime' 	: LSDATEFORMAT(item.startTime,'dd/mm/yyyy'),
			   		'endTime'		: LSDATEFORMAT(item.endTime,'dd/mm/yyyy'),
			   		'isMoreday'		: item.isMoreday,
			   		'timeOff'  		: item.timeOff,
			   		'reason'		: item.reason,
			   		'typeId'		: item.typeId,
			   		'numberDay'		: item.numberDay,
			   		'sicknessDay'	: 0,
			   		'annualDay'		: 0,
					}
					arrayAppend(rc.reportDayOff, report);
				}
			   var rq1 = {
			   		'startTime' = LSDATEFORMAT(item.startTime,'dd/mm/yyyy'),
			   		'date' = item.isMoreday? LSDATEFORMAT(item.startTime,'dd/mm/yyyy') &" - "& LSDATEFORMAT(item.endTime,'dd/mm/yyyy'):LSDATEFORMAT(item.startTime,'dd/mm/yyyy'),
			   		'type' = entityLoadbyPK('dayofftype',item.typeId).statusName,
			   		'reason'=item.reason,
			   		'requestType' = 1,
			   		'id' = item.Id,
			   		'status' = item.status
			   }
			   arrayAppend(rc.requests, rq1);
			}
			// list request from employee in team
			var manageTimeToYou = queryToArray(QueryExecute("
								select manageTime.*,u.firstname,u.lastname
								from manageTime 
								left join users u on u.userID = manageTime.userID
								where manageTime.firstCheckUser = :uId ORDER BY FIELD(manageTime.firstCheck,0,1,-1)",{uId=SESSION.userId}));
			for(mtu in manageTimeToYou) {
				var rqd = {
					'name' 			= mtu.firstname&" "&mtu.lastname,
					'startTime' 	= LSDATEFORMAT(mtu.startTime,'dd/mm/yyyy'),
					'date' 			= mtu.isMoreday? LSDATEFORMAT(mtu.startTime,'dd/mm/yyyy') &" - "& LSDATEFORMAT(mtu.endTime,'dd/mm/yyyy'):LSDATEFORMAT(mtu.startTime,'dd/mm/yyyy'),
					'type' 			= entityLoadbyPK('dayofftype',mtu.typeId).statusName,
					'reason'		= mtu.reason,
					'requestType' 	= 1,
					'id' 			= mtu.Id,
					'status'		= mtu.firstCheck
				}
				arrayAppend(rc.requireds, rqd);
			}

			var urgent_caseoff = queryToArray(QueryExecute('select * from urgent_caseoff where user = :uId',{uId=SESSION.userId}));
			for(item in urgent_caseoff) {
			   var report = {
			   		'startTime' 	: LSDATEFORMAT(item.startDate,'dd/mm/yyyy'),
			   		'endTime'		: LSDATEFORMAT(item.endDate,'dd/mm/yyyy'),
			   		'isMoreday'		: item.isMoreday,
			   		'timeOff'  		: item.timeOff,
			   		'reason'		: item.dueToSickness,
			   		'typeId'		: 3,
			   		'numberDay'		: 0,
			   		'sicknessDay'	: item.sicknessDay,
			   		'annualDay'		: item.annualDay,
			   }
			   arrayAppend(rc.reportDayOff, report);
			}
			var paid_Anual = queryToArray(QueryExecute('select * from logAnnualLeave where (type = 1 OR type = 4) AND userPaid = :uId',{uId=SESSION.userId}));
			for(item in paid_Anual) {
			   var report = {
			   		'startTime' 	: LSDATEFORMAT(item.createTime,'dd/mm/yyyy'),
			   		'endTime'		: '',
			   		'isMoreday'		: false,
			   		'timeOff'  		: '',
			   		'reason'		: item.action,
			   		'typeId'		: item.type == 4?4:5,
			   		'numberDay'		: item.numberDay,
			   		'sicknessDay'	: 0,
			   		'annualDay'		: 0,
			   }
			   arrayAppend(rc.reportDayOff, report);
			}

			var otRequest = queryToArray(QueryExecute('select * from overtime_request where userId = :uId',{uId=SESSION.userId}));
			for(rq in otRequest)
			{
				 var rq2 = {
			   		'startTime' = LSDATEFORMAT(rq.requestTime,'dd/mm/yyyy'),
			   		'date' = LSDATEFORMAT(rq.requestTime,'dd/mm/yyyy'),
			   		'type' = "OverTime",
			   		'reason'= rq.comment,
			   		'requestType' = 2,
			   		'id' = rq.id,
			   		'status' = rq.status
			   }
			   arrayAppend(rc.requests, rq2);
			}
			rc.reportDayOff=arrayOfStructsSort(rc.reportDayOff,'startTime');
			rc.requests = arrayOfStructsSort(rc.requests,'startTime');
			
			if(CGI.REQUEST_METHOD == "POST")
			{
				var getUser = entityloadByPk('users',SESSION.userId);
				var nameUser = getUser.firstname &" "& getUser.lastname;
				var offType = entityloadByPk('dayofftype',rc.typeoff);
				var ticket = EntityNew('manageTime');
				var dateApply = "";
				ticket.setSlug(CreateUUID());
				ticket.setIsMoreday(structKeyExists(rc, "onoffswitch"));
				if(structKeyExists(rc, "onoffswitch"))
				{
					var  arrDate = listToArray(rc.daterangepicker,' - ');
					ticket.setStartTime(getTrueDate(arrDate[1]));
					ticket.setEndTime(getTrueDate(arrDate[2]));
					dateApply = rc.daterangepicker;
					ticket.setNumberDay(rc.totalDayOff);
				}else{
					ticket.setTimeOff(rc.timeOff);
					ticket.setStartTime(getTrueDate(rc.oneDatePick));
					dateApply = getTrueDate(rc.oneDatePick);
					if(rc.typeoff==1)
					{
						ticket.setNumberDay(rc.totalDayOff<8?0.5:1);
					}
					else{
						ticket.setNumberDay(rc.totalDayOff);
						ticket.setStartHour(rc.startTime);
						ticket.setEndHour(rc.endTime);
						dateApply &= " (#rc.startTime# - #rc.endTime#)";
					}
				}
				ticket.setReason(rc.inforReason);
				ticket.setOfftype(offType);
				ticket.setStatus(0);
				ticket.setCreateTime(Now());
				ticket.setUser(getUser);
				var sendSlack = false ;
				var slack = createObject("component","api.slack");
				var msgTitle = "#offType.statusName# request from #nameUser#";
				var msgBody = "*Name*: "&nameUser&" \n*Reason*: "&rc.inforReason&" \n*Date apply*: "&dateApply ;
				if( SESSION.userType eq 3){
					ticket.setFirstCheck(1);
					ticket.setFirstCheckUser(SESSION.userId);
					sendSlack = true ;
				}else{
					var checkManagerPermis = QueryExecute('select pm.id 
					from permissionmanager pm where userID = :uId AND isActive = 1',{uId=rc.confirm_to});
					if( checkManagerPermis.recordCount == 0 ){
						ticket.setFirstCheck(0);
						ticket.setFirstCheckUser(rc.confirm_to);
						var confirmUser = entityLoadByPk("users", rc.confirm_to);
						var channel = confirmUser.slack;
						if( channel != "") slack.postMessage(channel = channel,title = msgTitle,text = msgBody,link = "/index.cfm/annual_Leave##lRequired");

					}else{
						ticket.setFirstCheck(1);
						ticket.setFirstCheckUser(SESSION.userId);
						sendSlack = true ;
					}
				}
				if( sendSlack ){
					
					var slackList = slack.getSlackListOfManager();
					var channel = "##request";
					arrayAppend(slackList,{id=0,slack=channel});
					for(slackTo in slackList) {
						slack.postMessage(channel = slackTo.slack,title = msgTitle,text = msgBody,link = "/index.cfm/manager.annual_Leave");
					}
				}
				entitySave(ticket);
				// var attachments = [{
	   // 		 			"color": "##36a64f",
	   // 		 			 "title": "You have new required on Ticket systems",
	   //         			 "title_link": "http://ticket.rasia.systems/index.cfm/manager.annual_Leave",
	   //         			 "text": "*Name*: "&nameUser&" \n*Type*: "&offType.statusName&" \n*Date apply*: "&dateApply,
	   //         			  "mrkdwn_in": ["text", "pretext"]
	   // 		 		}];
				// sendSlackMsg('namnnh123',serializeJSON(attachments));
				location('/index.cfm/annual_leave',false);
			}
		}else{
				location('/index.cfm',false);
			}
		
	}

	public any function getListTask(struct rc) {
		var result = queryToArray(QueryExecute('select t.ticketID,t.dueDate,t.code  from tickets t where t.projectID = :pid and t.assignedUserID = :uid',{pid=rc.pid,uid:SESSION.userId}));
		return variables.fw.renderData("json",result);
	}
	
	
	

	public any function manager(struct rc) {
		if(isinvalid())
		{
			rc.arrayNameCustomer=[];
			local.userIsoffical = queryToArray(QueryExecute("select Concat(firstname,' ',lastname) as value,userID from users where isOfficial = true"));
			for (item in userIsoffical)
			{
				var struct = {'id':item.userID,'value':item.value};
				ArrayAppend(rc.arrayNameCustomer,struct);
			}
			rc.arrayNameCustomer = serialize(rc.arrayNameCustomer);

			rc.arrayNewCustomer=[];
			local.newUser = queryToArray(QueryExecute("select Concat(firstname,' ',lastname) as value,userID from users where isOfficial is NULL or isOfficial = false"));
			for (item in newUser)
			{
				var struct = {'id':item.userID,'value':item.value};
				ArrayAppend(rc.arrayNewCustomer,struct);
			}
			rc.arrayNewCustomer = serialize(rc.arrayNewCustomer);

			rc.managertime  = queryToArray(QueryExecute('select *,(select checkType from checkRequired cr where cr.user = mt.userID and cr.required = mt.Id ) AS action from manageTime mt Order by createTime DESC'));

			rc.overTime  = queryToArray(QueryExecute('select *,(select checkType from checkRequired cr where cr.user = mt.userId and cr.required = mt.id ) AS action from overtime_request mt Order by createTime DESC'));

			if(CGI.REQUEST_METHOD == "POST")
			{
				var ticket = entityLoadByPk('manageTime',rc.idRequired);
				
				if(!isChecked(rc.idRequired))
				{	
					var checkRequired = entityNew('checkRequired');
					var userCheck = entityloadByPk('users',SESSION.userId);
					checkRequired.setCreateTime(Now());
					checkRequired.setCheckType(rc.typeSubmit);
					checkRequired.setUser(SESSION.userId);
					checkRequired.setRequired(ticket.getId());
					entitySave(checkRequired);

				}
				else{
					var timeCheck = entityLoad('checkRequired',{required:idRequired,user:SESSION.userId},true);
					timeCheck.setCheckType(rc.typeSubmit);
					timeCheck.setUpdateTime(Now());
					entitySave(timeCheck);
				}
				if(rc.typeSubmit == variables.status.reject)
				{
					ticket.setStatus(variables.status.reject);
					if(!ticket.IsNotice)
					{
						var attachments = [{
		   		 			"color": "danger",
		   		 			 "title": "Your required have rejected by "&userCheck.getLastname()&" "&userCheck.getFirstname(),
		   		 			 "title_link": "http://ticket.com/index.cfm/annual_leave",
		           			 "text": "*Slug*: "&ticket.slug&"\n*Date apply*: "&ticket.dateTime,
		           			  "mrkdwn_in": ["text", "pretext"]
		   		 		}];
		   		 		sendSlackMsg('request',serializeJSON(attachments));
						ticket.setisNotice(true);
					}
					entitySave(ticket);
				}else if(rc.typeSubmit == variables.status.approve){
					if(arrayLen(entityLoad('checkRequired',{required:rc.idRequired,checkType:variables.status.approve})) == 3)
					{
						ticket.setStatus(variables.status.reject);
						if(!ticket.IsNotice)
						{
							var attachments = [{
			   		 			"color": "good",
			   		 			 "title": "Your required have Approve",
			   		 			 "title_link": "http://ticket.com/index.cfm/annual_leave",
			           			 "text": "*Slug*: "&ticket.slug&"\n*Date apply*: "&ticket.dateTime,
			           			  "mrkdwn_in": ["text", "pretext"]
			   		 		}];
			   		 		sendSlackMsg('request',serializeJSON(attachments));
							ticket.setisNotice(true);
						}
						entitySave(ticket);
					}
				}
				location('/index.cfm/annual_leave/manager/?stt=1',false);
			}
		}else{
			location('/index.cfm/annual_leave');
		}
	}

	public any function report(struct rc) {
		// code report 
		var rpstring = "" ;
		rc.startDate =  dateAdd("m", -5, now()) ;
		rc.endDate =  dateAdd("m", 2, now()) ;
		rc.months = [] ;
		for(var i = 1; i <= 8 ; i ++ ) {
			var curDate = dateAdd("m", i-6, now()) ;
			var startDate = dateFormat(dateAdd("d", -day(curDate)+1, curDate ),"yyyy-mm-dd") ;
			var endDate = dateFormat(dateAdd("d", DaysInMonth(curDate)-1, startDate ),"yyyy-mm-dd") ;
			arrayAppend(rc.months, dateFormat(curDate , "MMM" ) ) ;
			rpstring &= " ,(select count(mt.numberDay) 
							from managetime mt Where mt.typeId = 1 AND (mt.startTime BETWEEN '#startDate#' AND '#endDate#') 
							AND mt.userID = users.userId) AS al#i# ";
			rpstring &= " ,(select count(sba.annualDay) 
							from sicknessbyadmin sba Where (sba.startDate BETWEEN '#startDate#' AND '#endDate#') 
							AND sba.user = users.userId) AS aba#i# ";
			rpstring &= " ,(select count(sba.sicknessDay) 
							from sicknessbyadmin sba Where (sba.startDate BETWEEN '#startDate#' AND '#endDate#') 
							AND sba.user = users.userId) AS sba#i# ";
		}
		// writeDump(rpstring);
		rc.report  = queryToArray(QueryExecute("select firstname,lastname,dayoff.*#rpstring# from dayoff inner join users on dayoff.userId = users.userId where users.isOfficial = true"));
		// writeDump(rc.report);
		// abort;
	}
	
	public any function overtime_request(struct rc){
		if( CGI.REQUEST_METHOD == "POST" ){

			var getUser = entityloadByPk('users',SESSION.userId);
			var nameUser = getUser.firstname &" "& getUser.lastname;

			var overtime_request = entityNew("overtime_request",{
					'createTime'	: now(),
					'requestTime'	: getTrueDate(rc.ot_day) ,
					'hours'			: rc.ot_hours ,
					'status'		: 0 ,
					'userId'		: SESSION.userId ,
					'projectId'		: rc.ot_project,
					'comment'		: rc.ot_cmt,
					'tasks'			: structKeyExists(rc,'tasks')?rc.tasks:"",
					'from'			: rc.fromOvertime,
					'to'			: rc.toOvertime
				});
			entitySave(overtime_request);
			var slack = createObject("component","api.slack");
			var msgTitle = "OverTime Request from #nameUser#";
			var msgBody = "*Name*: "&nameUser&" \n*Comment*: "&rc.ot_cmt&" \n*Type*: OverTime Request \n*Date apply*: "&rc.ot_day ;
			var slackList = slack.getSlackListOfManager();
			var channel = "##request";
			arrayAppend(slackList,{id=0,slack=channel});
			for(slackTo in slackList) {
				var result = slack.postMessage(channel = slackTo.slack,title = msgTitle,text = msgBody,link = "/index.cfm/manager.annual_Leave");
			}
			location("/index.cfm/annual_leave",false);
		}
	}
	

	function sendSlackMsg(required string channelName, required string attachments) {
		attachments = replace(attachments, "\\n", "\n", 'all');
		var slackUrl = "https://hooks.slack.com/services/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";
		var httpService = new http();
		 httpService.setMethod("POST"); 
   		 httpService.setCharset("utf-8");
   		 httpService.setUrl(slackUrl);  
   		 httpService.addParam(type="formfield",name="payload",value='{
   		 	"attachments": '&attachments&',
   		 	"username":"Notice",
   		 	"icon_emoji":":rasia:",
   		 	"channel":"##'&channelName&'"
 		}'); 
   		 httpService.send().getPrefix();
	}

	public boolean function isChecked(required numeric rId) {
		var checked = entityLoad('checkRequired',{required:rId,user:SESSION.userId});
		return  arrayLen(checked)!=0;
	}

	public boolean function isinvalid() {
		return true;
	}
	
	// public any function getInformation() {
	// 	var required = entityLoad('manageTime',{slug:rc.slug},true);
	// 	var userSubmit = required.getUser();
	// 	var checkRequired = entityLoad('checkRequired',{required:required.getId()});
	// 	var sApprove = "";
	// 	var sReject = "";
	// 	for(item in checkRequired)
	// 	{
	// 		local.user = entityLoadByPk('users',item.user);
	// 		if(item.checkType == variables.status.approve)
	// 			sApprove &="<b>#user.getFirstname()&' '&user.getLastname()#</b>,";
	// 		else if(item.checkType == variables.status.reject)
	// 		 	sReject &= " <b>#user.getFirstname()&' '&user.getLastname()#</b>,";
	// 	}

	// 	var result = {
	// 		'rid'		:	required.getId(),
	// 		'name' 		: 	"#userSubmit.getFirstname() &" "& userSubmit.getLastname()#(#userSubmit.getUsername()#)",
	// 		'Type'		:	required.getTypetime().getStatusname(),
	// 		'reason'	:	required.getOfftype().getStatusname(),
	// 		'date'		:	required.getDatetime(),
	// 		'msg'		:	required.getReason(),
	// 		'sApprove'	:	sApprove!=""?"#left(sApprove,len(sApprove)-1)# have Approved": "",
	// 		'sReject'	: 	sReject!=""?"Reject by #left(sReject,len(sReject)-1)#": "",
	// 		'days'		:	required.getnumberDay()
	// 	};
	// 	return variables.fw.renderData("json",result);
	// }

	public any function getInformation() {
		var required = entityLoadByPk('manageTime',rc.id);
		var checkRequired = entityLoad('checkRequired',{required:required.getId(), requireType : 1 });
		var sApprove = "";
		var sReject = "";
		for(item in checkRequired)
		{
			local.user = entityLoadByPk('users',item.user);
			if(item.checkType == 1)
				sApprove &="<b>#user.getFirstname()&' '&user.getLastname()#</b>,";
			else if(item.checkType == -1)
			 	sReject &= " <b>#user.getFirstname()&' '&user.getLastname()#</b>,";
		}

		var result = {
			'sApprove'	:	sApprove!=""?"#left(sApprove,len(sApprove)-1)# have Approved": "",
			'sReject'	: 	sReject!=""?"Reject by #left(sReject,len(sReject)-1)#": ""
		};
		return variables.fw.renderData("json",result);
	}
	public any function getInformationOt() {
		var required = entityLoadByPk('overtime_request',rc.id);
		var checkRequired = entityLoad('checkRequired',{required:required.getId(), requireType : 2});
		var sApprove = "";
		var sReject = "";
		for(item in checkRequired)
		{
			local.user = entityLoadByPk('users',item.user);
			if(item.checkType == 1)
				sApprove &="<b>#user.getFirstname()&' '&user.getLastname()#</b>,";
			else if(item.checkType == -1)
			 	sReject &= " <b>#user.getFirstname()&' '&user.getLastname()#</b>,";
		}

		var result = {
			'sApprove'	:	sApprove!=""?"#left(sApprove,len(sApprove)-1)# have Approved": "",
			'sReject'	: 	sReject!=""?"Reject by #left(sReject,len(sReject)-1)#": ""
		};
		return variables.fw.renderData("json",result);
	}

	public any function getDayDiff(struct rc) {
		var dayDiff = dateDiff("d", rc.startDate, rc.endDate) + 1;
		for(var i = 1 ; i<= dayDiff;i++)
		{
			if(DayOfWeek(rc.startDate)== 1 || DayOfWeek(rc.startDate) == 7)
				dayDiff--;
			rc.startDate = Dateadd('d',1,rc.startDate);
			if(DateCompare(rc.endDate,rc.startDate)== -1)
				break;
		}
		return variables.fw.renderData("json",{'numberday':dayDiff});
	}

	public any function getAvaiOff(struct rc) {
		var dayoff = entityLoad('dayoff',{userId:rc.id},true);
		return variables.fw.renderData("json",{'avaiAnnual':dayoff.alOffTotal-dayoff.alOff,'avaiSick': dayoff.sloffTotal-dayoff.sloff});
	}


	public any function submitSickness(struct rc) {
		local.newSickness = entityNew('sicknessbyadmin');
		local.date = listToArray(rc.dateTime,'-');
		newSickness.setStartDate(date[1]);
		newSickness.setEndDate(date[2]);
		newSickness.setSicknessDay(rc.sicknessDay);
		newSickness.setAnnualDay(rc.annualDay);
		newSickness.setdueToSickness(rc.dueToSickness);
		newSickness.setuser(rc.id)
		entitySave(newSickness);

		local.dayoff = entityLoad('dayoff',{userId=rc.id},true);
		dayoff.setAlOff(dayoff.alOff+LSParseNumber(rc.annualDay));
		dayoff.setSloff(dayoff.sloff+LSPARSENUMBER(rc.sicknessDay));
		entitySave(dayoff);
		return variables.fw.renderData("json",{'stt':true});
	}

	public any function aproveRequest(struct rc){
		var curMessage = entityLoad('checkRequired',{required : rc.id, user : SESSION.userID, requireType : rc.rtype }, true );
		if( isNull(curMessage) ){
			curMessage = entityNew('checkRequired',{ createTime : now(),required : rc.id, user : SESSION.userID, requireType : rc.rtype } );
		}
		curMessage.setUpdateTime(now());
		curMessage.setCheckType(rc.isaprove);
		entitySave(curMessage);
		// check aprove and change status managerTime 
		var allMessage = entityLoad('checkRequired',{required : rc.id, requireType : rc.rtype } );
		var aproveNumber = 0 ;
		var rejectNumber = 0 ;
		for(mes in allMessage) {
		   if( mes.getCheckType() == 1) aproveNumber ++ ;
		   else if ( mes.getCheckType() == -1 ) rejectNumber ++ ;
		}
		var cStatus = (aproveNumber >= 2 ? 1 : ( rejectNumber >= 2 ? -1 : 0 ) ) ;
		if( rc.rtype == 1 ){
			var objName = "manageTime" ;
			var curRequest = entityLoadByPk(objName,rc.id);
			var curUserID = curRequest.getUser().getUserID() ;
			var plusType = "" ;
			var plusNumber = curRequest.getnumberDay();
			if( curRequest.getofftype().getID() == 1 ){
				if( curRequest.getStatus() == 1 AND cStatus != 1 ){
					plusType = "divDay" ;
				}else if(curRequest.getStatus() != 1 AND cStatus == 1){
					plusType = "plusDay" ;
				}

			}else{
				if( curRequest.getStatus() == 1 AND cStatus != 1 ){
					plusType = "plusOvertime" ;
				}else if(curRequest.getStatus() != 1 AND cStatus == 1){
					plusType = "divOvertime" ;
				}
			}
		}else{
			var objName = "overtime_request" ;
			var curRequest = entityLoadByPk(objName,rc.id);
			var curUserID = curRequest.getUserID() ;
			var plusType = "" ;
			var plusNumber = curRequest.getHours();
			if( curRequest.getStatus() == 1 AND cStatus != 1){
				plusType = "divOvertime" ;
			}else if(curRequest.getStatus() != 1 AND cStatus == 1){
				plusType = "plusOvertime" ;
			}
		}
		curDayoffUser = entityLoad("dayoff",{userId : curUserID } , true );
		switch( plusType ){
			case 'plusDay':
				curDayoffUser.setalOff(curDayoffUser.getAlOff() + plusNumber ) ;
			break;
			case 'divDay':
				curDayoffUser.setalOff(curDayoffUser.getAlOff() - plusNumber ) ;
			break;
			case 'plusOvertime':
				curDayoffUser.setOvertimes(curDayoffUser.getOvertimes() + plusNumber ) ;
			break;
			case 'divOvertime':
				curDayoffUser.setOvertimes(curDayoffUser.getOvertimes() - plusNumber ) ;
			break;
		
		}
		curRequest.setStatus( cStatus );
		entitySave( curRequest ) ;
		entitySave( curDayoffUser ) ;
		// end
		return variables.fw.renderData("json",true);
	}

	public any function newEmoloyer(struct rc) {
		QueryExecute("Update users set isOfficial = 1 where userID=:id",{id=rc.id});
		local.newDayOff = entityNew('dayoff');
		newDayOff.setStartTime(rc.startTime);
		newDayOff.setAlOffTotal(rc.annualDay);
		newDayOff.setSloffTotal(rc.sicknessDay);
		newDayOff.setUserId(rc.id);
		entitySave(newDayOff);
		local.userIsoffical = queryToArray(QueryExecute("select Concat(firstname,' ',lastname) as value,userID from users where isOfficial = true"));
		return variables.fw.renderData("json",{'stt':true});
	}

	// checking request for employee 
	public any function checking_required(struct rc){
		var requestID = rc.rid ;
		var checkType = rc.rtype;
		var curRequest = entityLoadbyPK("manageTime",requestID);
		if( curRequest.getFirstCheck() == 0 ){
			curRequest.setFirstCheck(checkType);
			var slack = createObject("component","api.slack");
			var getUser 	= curRequest.getUser();
			var nameUser 	= getUser.firstname &" "& getUser.lastname;
			var offType 	= curRequest.getOfftype();
			var dateApply 	= dateFormat( curRequest.getStartTime(),"dd/mm/yyyy");
			var reason 		= curRequest.getReason();
			var approveUser = entityLoadbyPK("users",session.userid);
			var nameApproveUser 	= approveUser.firstname &" "& approveUser.lastname;

			if( checkType == -1 ){
				curRequest.setStatus(checkType);
				var channel = getUser.slack;
				if( channel != ""){
					var msgTitle = "Reject by leader.";
					var msgBody = "#nameApproveUser# reject your request on #dateApply#" ;
						slack.postMessage(channel = channel,title = msgTitle,text = msgBody,link = "/index.cfm/annual_Leave",color="danger");
				}
			}else{
				var msgTitle = "#offType.statusName# request from #nameUser#";
				var msgBody = "*Name*: "&nameUser&" \n*Comment*: "&reason&"\n*Date apply*: "&dateApply&"\n*Leader approved*: "&nameApproveUser ;

				var slackList = slack.getSlackListOfManager();
				var channel = "##request";
				arrayAppend(slackList,{id=0,slack=channel});
				for(slackTo in slackList) {
					slack.postMessage(channel = slackTo.slack,title = msgTitle,text = msgBody,link = "/index.cfm/manager.annual_Leave");
				}
			}
		}
		entitySave( curRequest );
		GetPageContext().getResponse().sendRedirect("/index.cfm/annual_leave/" );
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
		return aDob[3] &"-"& aDob[2] &"-"& aDob[1];
	}

	function arrayOfStructsSort(aOfS,key){
        //by default we'll use an ascending sort
        var sortOrder = "DESC";        
        //by default, we'll use a textnocase sort
        var sortType = "textnocase";
        //by default, use ascii character 30 as the delim
        var delim = ".";
        //make an array to hold the sort stuff
        var sortArray = arraynew(1);
        //make an array to return
        var returnArray = arraynew(1);
        //grab the number of elements in the array (used in the loops)
        var count = arrayLen(aOfS);
        //make a variable to use in the loop
        var ii = 1;
        //if there is a 3rd argument, set the sortOrder
        if(arraylen(arguments) GT 2)
            sortOrder = arguments[3];
        //if there is a 4th argument, set the sortType
        if(arraylen(arguments) GT 3)
            sortType = arguments[4];
        //if there is a 5th argument, set the delim
        if(arraylen(arguments) GT 4)
            delim = arguments[5];
        //loop over the array of structs, building the sortArray
        for(ii = 1; ii lte count; ii = ii + 1)
            sortArray[ii] = aOfS[ii][key] & delim & ii;
        //now sort the array
        arraySort(sortArray,sortType,sortOrder);
        //now build the return array
        for(ii = 1; ii lte count; ii = ii + 1)
            returnArray[ii] = aOfS[listLast(sortArray[ii],delim)];
        //return the array
        return returnArray;
    }
	
	
}