component output="false" displayname=""  {

	public function init(required any fw){
		variables.fw =fw;
		return this;
	}


	public any function default(struct rc) {
		
		if(CGI.REQUEST_METHOD eq "POST")
		{
			var managerTime = queryToArray(QueryExecute('select count(Id) as checked from manageTime where userID =:id',{id= rc.userId}))
			if(managerTime[1].checked == 0){
				QueryExecute('UPDATE dayoff
							SET startTime=:st,alOffTotal=:alo,sloffTotal=:slo,overtimes=:ot
							WHERE id=:id',
							{st:sdateFormat(rc.mydate),alo=rc.annualDay,slo=rc.sicknessDay,ot=rc.overtimes,id=rc.dayoffid});
				rc.stt=true;
			}else{
				rc.stt=false;
			}
		}
		rc.users = queryToArray(queryExecute("SELECT u.userID,u.avatar,concat(u.firstname,' ',u.lastname) as name,d.id,d.startTime,d.alOffTotal,d.sloffTotal,d.alOff,d.sloff,d.overtimes 
											FROM users u
											INNER JOIN dayoff d ON d.userId = u.userID
											WHERE u.isOfficial = true AND u.active =1
											ORder by d.startTime"));
	}
	
	public any function annual_Leave(struct rc) {
		rc.managertime  = queryToArray(QueryExecute('select *,(select checkType from checkRequired cr where cr.user = :userId and cr.required = mt.Id and requireType = 1 ) AS action, CONCAT(u1.firstname," ",u1.lastname) as checkUser
													from manageTime mt 
													inner join dayoff do on mt.userID = do.userId
													left join users u1 on mt.firstCheckUser = u1.userID 
													WHERE mt.firstCheck = 1
													Order by createTime DESC',{userId:SESSION.userId}));
	}
// report zone
	public any function export_annual_leave(struct rc ){
		rc.exportYear = URL.year?:year(now());
		if( rc.exportYear == year(now()) ){
			write_log_annualleave_year();
		}
		var userList = QueryExecute('select lay.*, CONCAT(u1.lastname," ",u1.firstname) as name
													from log_annualleave_year lay
													left join users u1
														on lay.userid = u1.userID
													Order by name');
		var offList  = QueryExecute('select mt.*,dt.statusName as type, CONCAT(u1.lastname," ",u1.firstname) as username 
												from manageTime mt
												left join dayofftype dt on dt.Id = mt.typeId
												left join users u1 on mt.userID = u1.userID 
													WHERE mt.status = 1 
													AND YEAR(mt.startTime) = :year 
													Order by mt.startTime',{year:rc.exportYear});
		var sicknessLeave = QueryExecute('select us.* , CONCAT(u1.lastname," ",u1.firstname) as username 
			from urgent_caseoff us
			left join users u1 on u1.userID = us.user
			where YEAR(startDate)=:year AND isTrash = 0
			ORDER BY startDate ',{year:rc.exportYear});
		rc.oData = {};
		for(u in userList) {
			var newUserItem = {
				'id' = u.userid,
				'name' = u.name,
				'remain' = {
					  al = u.al_remain
					, sl = u.sl_remain
					, ot = u.ot_remain
					, date = dateFormat(u.updated,"dd/mm/yyyy")
				},
				'data' = []
			}
			rc.oData[u.userid] = newUserItem;
		}

		for(o in offList) {
			if(o.userID > 0){
				if( not structKeyExists(rc.oData, o.userID)){
					var newUserItem = {
						'id' = o.userID,
						'name' = o.username,
						'remain' = {
							  al = 0
							, sl = 0
							, ot = 0
							, date = dateFormat(now(),"dd/mm/yyyy")
						},
						'data' = []
					}
					rc.oData[o.userID] = newUserItem;

				}
				var newOffItem = {
					'date' 	= dateFormat( o.startTime,"dd/mm/yyyy"),
					'idate'		= dateFormat( o.startTime,"yyyy-mm-dd"),
					'type' 		= o.type,
					'reason' 	= o.reason,
					'al' 		= 0,
					'ot' 		= 0,
					'sl' 		= 0
				}
				if( o.typeID == 1 ){
					newOffItem['al'] = NumberFormat(o.numberDay,".0");
				}else{
					newOffItem['ot'] = NumberFormat(o.numberDay,".0");
				}
				arrayAppend( rc.oData[o.userID]['data'], newOffItem);

			}
		}
		for(sl in sicknessLeave) {
			if(sl.user > 0){
				if( not structKeyExists(rc.oData, sl.user)){
					var newUserItem = {
						'id' = sl.user,
						'name' = sl.username,
						'remain' = {
							  al = 0
							, sl = 0
							, ot = 0
							, date = dateFormat(now(),"dd/mm/yyyy")
						},
						'data' = []
					}
					rc.oData[sl.user] = newUserItem;

				}
				var newOffItem = {
					'date' 	= dateFormat( sl.startDate,"dd/mm/yyyy"),
					'idate'		= dateFormat( sl.startDate,"yyyy-mm-dd"),
					'type' 		= "Urgent case",
					'reason' 	= sl.dueToSickness,
					'al' 		= NumberFormat(sl.annualDay,".0"),
					'ot' 		= 0,
					'sl' 		= NumberFormat(sl.sicknessDay,".0")
				}
				arrayAppend( rc.oData[sl.user]['data'], newOffItem);

			}
		}
	}

	public void function write_log_annualleave_year(){
		var curYear = year(now());
		var user_al_info = QueryExecute("SELECT dayoff.*
			,(SELECT id FROM log_annualleave_year WHERE log_annualleave_year.userid = users.userID AND year = #curYear#) as oldLogID
			FROM dayoff left join users on users.userID = dayoff.userId Where users.active = 1");
		for(uinfo in user_al_info) {
			var uRemain = {
				 al = (uinfo.alOffTotal - uinfo.alOff)
				,sl = (uinfo.slOffTotal - uinfo.slOff)
				,ot = uinfo.overtimes
			}
			if( uinfo.oldLogID == "" ){
				QueryExecute("Insert into log_annualleave_year (`al_remain`,`sl_remain`,`ot_remain`,`userid`,`year`,`updated`) 
					Values (?,?,?,?,?,?)",[uRemain.al,uRemain.sl,uRemain.ot,parseNumber(uinfo.userId),year(now()),dateTimeFormat(now(),"yyyy-mm-dd HH:nn:ss")]);
			}else{
				QueryExecute("Update log_annualleave_year Set
					al_remain 	= ?
					,sl_remain 	= ?
					,ot_remain 	= ?
					,updated 	= ?
					Where id = ?",[
					uRemain.al
					,uRemain.sl
					,uRemain.ot
					,dateTimeFormat(now(),"yyyy-mm-dd HH:nn:ss")
					,parseNumber(uinfo.oldLogID)]);
			}
		}
	}

	public void function setAlForNextYear(struct rc){
		write_log_annualleave_year();
		var user_al_info = QueryExecute("SELECT dayoff.*
			FROM dayoff left join users on users.userID = dayoff.userId Where users.active = 1");
		for(uinfo in user_al_info) {
			var uRemain = {
				 al = (uinfo.alOffTotal - uinfo.alOff)
				,sl = (uinfo.slOffTotal - uinfo.slOff)
				,ot = uinfo.overtimes
			}

			QueryExecute("Insert into annualleave_year 
				(`alOffTotal`,`sloffTotal`,`alOff`,`sloff`,`overtimes`,`numberPaid`,`userid`,`year`) 
				Values (?,?,?,?,?,?,?,?)"
				,[uinfo.alOffTotal
				,uinfo.slOffTotal
				,uinfo.alOff
				,uinfo.slOff
				,uinfo.overtimes
				,0
				,parseNumber(uinfo.userId)
				,year(now())
				]);
			QueryExecute("Update dayoff Set
				 alOffTotal = ?
				,sloffTotal = ?
				,alOff 		= ?
				,sloff 		= ?
				Where id = ?",[
				(uinfo.alOffTotal+12)
				,(uinfo.slOffTotal+6)
				,0
				,0
				,parseNumber(user_al_info.id)]);
		}
		abort;
	}








// end report zone
	public any function overTime(struct rc) {
		rc.overTime  = queryToArray(QueryExecute('
			select mt.*,
				(select checkType 
					from checkRequired cr 
					where cr.user = :userId and cr.required = mt.id and requireType = 2 ) AS action,concat(p.shortName,"-",p.projectName) as pName,
				concat(u.firstname," ",u.lastname) as leader
			from overtime_request mt 
			left join projects p on mt.projectId = p.projectID
			left join users u on u.userID = p.projectLeadID
			Order by createTime DESC',{userId:SESSION.userId}));
	}

	public any function urgent(struct rc) {
		rc.usersOffical=[];
		local.userIsoffical = queryToArray(QueryExecute("select Concat(firstname,' ',lastname) as value,userID from users where isOfficial = true"));
		for (item in userIsoffical)
		{
			var struct = {'id':item.userID,'value':item.value};
			ArrayAppend(rc.usersOffical,struct);
		}
		rc.usersOffical = serialize(rc.usersOffical);

		if(CGI.REQUEST_METHOD eq "POST")
		{
			var dateApply = 0
			local.newSickness = entityNew('urgent_caseoff');
			if(structKeyExists(rc, "onoffswitch"))
			{
				dateApply = rc.daterangepicker;
				local.date = listToArray( rc.daterangepicker,'-');
				newSickness.setStartDate( getTrueDate(date[1]) );
				newSickness.setEndDate( getTrueDate(date[2]) );
			}else{
				dateApply = rc.mydate
				newSickness.setStartDate(getTrueDate(rc.mydate));
				newSickness.setTimeOff(rc.timeOff);
			}
			
			newSickness.setSicknessDay(rc.sicknessDay);
			newSickness.setAnnualDay(rc.annualDay);
			newSickness.setdueToSickness(rc.dueToSickness);
			newSickness.setuser(rc.userId);
			newSickness.setIsMoreday(structKeyExists(rc,'onoffswitch'));
			entitySave(newSickness);

			local.dayoff = entityLoad('dayoff',{userId=rc.userId},true);
			dayoff.setAlOff(dayoff.alOff+LSParseNumber(rc.annualDay));
			dayoff.setSloff(dayoff.sloff+LSPARSENUMBER(rc.sicknessDay));
			entitySave(dayoff);
			rc.stt="Your changes have been saved successfully";

			//send slack
			var userRequest = entityLoadByPk('users',rc.userId);
			var msgSlack = "";
			if(rc.sicknessDay + rc.annualDay == 0.5)
			{
				msgSlack = userRequest.Firstname & " " &  userRequest.Lastname & " have off half day on the date : "&dateApply
			}else{
				msgSlack = userRequest.Firstname & " " &  userRequest.Lastname & " have off on the date: "&dateApply
			}
			// var attachments = [{
	 	// 		 "color": "##36a64f",
	 	// 		 "title": msgSlack,
	  //  			 "title_link": "http://ticket.rasia.systems/index.cfm/manager.annual_Leave",
	  //  			 "text": "*Reason*: "&newSickness.dueToSickness&" \n*Type*: Urgent case off",
	  //  			 "mrkdwn_in": ["text", "pretext"]
	 	// 	}];
			// sendSlackMsg('days-off',serializeJSON(attachments));

			var slack = createObject("component","api.slack");
			var msgBody = "*Reason*: "&newSickness.dueToSickness&" \n*Type*: Urgent case off" ;
			
			var channel = "##days-off";
				slack.postMessage(channel = channel,title = msgSlack,text = msgBody);

		}
	}
	public function testPostMessage(struct rc){
		var msgSlack = "Test";
		var slack = createObject("component","api.slack");
		var msgBody = "*Reason*: test \n*Type*: Urgent case off" ;
		var channel = "##namnnh123";
		var sendMessage = slack.postMessage(channel = channel,title = msgSlack,text = msgBody);
		writeDump(sendMessage);
		abort;
	}

	public any function editEmployer(struct rc) {
		rc.usersOffical=[];
		local.userIsoffical = queryToArray(QueryExecute("select Concat(firstname,' ',lastname) as value,userID from users where isOfficial is NULL or isOfficial = false"));
		for (item in userIsoffical)
		{
			var struct = {'id':item.userID,'value':item.value};
			ArrayAppend(rc.usersOffical,struct);
		}
		rc.usersOffical = serialize(rc.usersOffical);
		if(CGI.REQUEST_METHOD eq "POST")
		{
			QueryExecute('UPDATE users
						SET isOfficial=1
						WHERE userID=:userId',{userId:rc.userId});
			QueryExecute('INSERT INTO dayoff(startTime,alOffTotal,sloffTotal,userId,overtimes,alOff,sloff)
						VALUES (:mydate,:annualDay,:sicknessDay,:userId,:overtimes,0,0)',{mydate=sdateFormat(rc.mydate),annualDay=rc.annualDay,sicknessDay=rc.sicknessDay,userId=rc.userId,overtimes=rc.overtimes});
			rc.stt="Your changes have been saved successfully";
		}
	}

	public any function addAnnualleave(struct rc) {
		rc.usersOffical=[];
		local.userIsoffical = queryToArray(QueryExecute("select Concat(firstname,' ',lastname) as value,userID from users where isOfficial = true"));
		for (item in userIsoffical)
		{
			var struct = {'id':item.userID,'value':item.value};
			ArrayAppend(rc.usersOffical,struct);
		}
		rc.usersOffical = serialize(rc.usersOffical);
		if(CGI.REQUEST_METHOD eq "POST")
		{
			var userPaid = entityLoadByPk('users',rc.userId);
			QueryExecute('UPDATE dayoff SET alOffTotal = alOffTotal + :annualDay where userId=:userId',{annualDay=rc.annualDay,userId=rc.userId});
			var newLog = entityNew('logAnnualLeave',{
						createTime = Now(),
						userCreate = SESSION.userID,
						userPaid = rc.userId,
						numberDay=rc.annualDay,
						action = rc.reason,
						type = 2,
						isSuccess = true
					});
			entitySave(newLog);
			ORMFlush();
			rc.stt="Your changes have been saved successfully";
		}
	}

	public any function log(struct rc) {
		var logType = URL.t ?: "";
		var logDateLimit = dateAdd("m", -4, dateFormat(now(),"yyyy-mm")&"-01");
		if(logType != "")
			rc.logAnnual = ormExecuteQuery("FROM logAnnualLeave WHERE type = #logType# AND createTime > '#dateFormat(logDateLimit,'yyyy-mm-dd')#'") ;
		else 
			rc.logAnnual = ormExecuteQuery("FROM logAnnualLeave WHERE createTime > '#dateFormat(logDateLimit,'yyyy-mm-dd')#'") ;
	}
	
	public any function addOt(struct rc) {
		rc.usersOffical=[];
		local.userIsoffical = queryToArray(QueryExecute("select Concat(firstname,' ',lastname) as value,userID from users where isOfficial = true"));
		for (item in userIsoffical)
		{
			var struct = {'id':item.userID,'value':item.value};
			ArrayAppend(rc.usersOffical,struct);
		}
		rc.usersOffical = serialize(rc.usersOffical);
		if(CGI.REQUEST_METHOD eq "POST")
		{
			var sReason = {
				'reason':rc.reason,
				'from':rc.clockpickerF,
				'to':rc.clockpickerT
			};
			var userPaid = entityLoadByPk('users',rc.userId);
			QueryExecute('UPDATE dayoff SET overtimes = overtimes + :overtimes where userId=:userId',{overtimes=rc.overtimes,userId=rc.userId});
			var newLog = entityNew('logAnnualLeave',{
						createTime = Now(),
						userCreate = SESSION.userID,
						userPaid = rc.userId,
						numberDay=rc.overtimes,
						action = serialize(sReason),
						type = 3,
						isSuccess = true
					});
			entitySave(newLog);
			ORMFlush();
			rc.stt="Your changes have been saved successfully";
		}
	}
	
	public any function userDetail(struct rc) {
		if(structKeyExists(URL, "u"))
		{
			if(CGI.REQUEST_METHOD eq "POST")
			{
				var userPaid = entityLoadByPk('users',rc.userId);
				var newLog = entityNew('logAnnualLeave',{
						createTime = Now(),
						userCreate = SESSION.userID,
						userPaid = rc.userId,
						numberDay=rc.annual_LeavePaid,
						action = "Paid "& rc.annual_LeavePaid & " days for "& userPaid.firstname &" "& userPaid.lastname,
						type = 1
					});
				var dayoff = entityLoad('dayoff',{userId = rc.userId},true);
				dayoff.setAlOffTotal(dayoff.alOffTotal - rc.annual_LeavePaid);
				newLog.setIsSuccess(true); 
				entitySave(dayoff);
				entitySave(newLog);
				QueryExecute('UPDATE annualLeave_Year SET numberPaid =numberPaid + :number,datePaid=:now,isMinus=1 where userId = :userPaid',{number=rc.annual_LeavePaid,now=dateTimeFormat(Now(),'yyyy.MM.dd HH:nn:ss'),userPaid=rc.userId});
				rc.stt = "Your changes have saved successfully!";
				ORMFlush();
			}
			rc.user = queryToArray(QueryExecute("select concat(u.firstname,' ',u.lastname)as name, u.avatar,d.alOffTotal,d.sloffTotal,d.alOff,d.sloff,d.overtimes,count(ot.id) as ot 
												from users u
												Inner join dayoff d on u.userID = d.userId
												Left join overtime_request ot on ot.userId = u.userID and ot.`status` = 1
												where u.userID =:uId",{uId:URL.u}));	
			rc.annualLeave = queryToArray(queryExecute('select * from manageTime where userID=:id and status=1  ORDER BY startTime DESC',{id=URL.u}));
			rc.sicknessLeave = queryToArray(QueryExecute('select * from urgent_caseoff where user=:id ORDER BY startDate DESC',{id=URL.u}));
			rc.overTime = queryToArray(queryExecute('select * from overtime_request where userId=:id and status=1 ORDER BY requestTime DESC',{id=URL.u}));
			rc.annual_LeaveYear = queryToArray(QueryExecute('select * from annualLeave_Year where userId=:id and year=:year',{id=URL.u,year=year(now()) - 1 }));
			rc.logAnnual = entityLoad('logAnnualLeave',{userPaid:URL.u,type:1});
			rc.logPaidOvertime = entityLoad('logAnnualLeave',{userPaid:URL.u,type:4});
			/*get late*/
			var userInfo = entityLoad('dayoff',{userId:URL.u},true);

			rc.lateInfo = DeserializeJSON(isNull(userInfo.getLate())?"[]":userInfo.getLate());

			rc.countLate = 0;
			if(!isNull(userInfo.getLate()))
			{
				for(late in rc.lateInfo) {
				   if(late !="pay")
				   {
				   		rc.countLate = rc.countLate + arrayLen(rc.lateInfo[late]);
				   }
				}
			}
		}else{
			location('/index.cfm/manager',false);
		}
	}
	public any function paid_overtime(struct rc){
		var userID = rc.uId?:"";
		if( userID == ""){
			location('/index.cfm/manager',false);
		}

		if(CGI.REQUEST_METHOD eq "POST")
		{
			var userPaid = entityLoadByPk('users',userID);
			var userInfo = entityLoad('dayoff',{userId:userID},true);
			var paidOvertime = rc.paidnumber?:0;
			if( paidOvertime > 0 AND !isNull(userInfo) ){
				var totalOvertime = userInfo.getOvertimes();
				var remainOvertime = totalOvertime - paidOvertime;
				if( remainOvertime >= 0 ){
					userInfo.setOvertimes(remainOvertime);
					entitySave(userInfo);
					var actionText = paidOvertime > 1 ? "#paidOvertime# hours":"#paidOvertime# hour";
					var newLog = entityNew('logAnnualLeave',{
							createTime = Now(),
							userCreate = SESSION.userID,
							userPaid = userID,
							isSuccess = 1,
							numberDay = paidOvertime,
							action = "Paid #actionText# for #userPaid.firstname# .",
							type = 4
						});
					entitySave(newLog);
				}
			}
			location(CGI.HTTP_REFERER,false);
		}else{
			location('/index.cfm/manager',false);
		}
	}

	public any function holiday(param) {
		if(CGI.REQUEST_METHOD eq "POST")
		{
			var event = entityNew('event',{
				'title' : rc.title,
				'allDay': true,
				'repeatEvent' : 0,
				'warningType' : 0,
				'teamId'      : 0,
				'colorEvent'  : 'success',
				'isNotice'    : true,
				'typeEvent'   : 1
			});
			if(structKeyExists(rc, "onoffswitch"))
			{
				local.date = listToArray(rc.daterangepicker,'-');
				event.setstart(getTrueDate(date[1]));
				event.setend(getTrueDate(date[2]));
			}else{
				event.setstart(getTrueDate(rc.mydate));
			}

			entitySave(event);
			rc.stt="Your changes have been saved successfully";
		}
	}
	
	public any function getAvaiOff(struct rc) {
		var dayoff = entityLoad('dayoff',{userId:rc.id},true);
		return variables.fw.renderData("json",{'avaiAnnual':dayoff.alOffTotal-dayoff.alOff,'avaiSick': dayoff.sloffTotal-dayoff.sloff});
	}

	public any function getInformation(struct rc) {
		var required ="manageTime";
		var type = 1;
		if(rc.type == 2){
			required = "overtime_request";
			type = 2;
		}

		var required = entityLoadByPk(required,rc.id);
		var checkRequired = entityLoad('checkRequired',{required:required.getId(),requireType:type});
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
			'sApprove'	:	sApprove!=""?"#left(sApprove,len(sApprove)-1)#": "",
			'sReject'	: 	sReject!=""?"#left(sReject,len(sReject)-1)#": "",
			'createTime':	LSDATETIMEFORMAT(required.createTime,'dd/mm/yyyy HH:nn')
		};
		return variables.fw.renderData("json",result);
	}
	
	public any function aproveRequest(struct rc){
		var checkPermission = queryToArray(QueryExecute('select count(id) as count from permissionmanager where userId = :uId and isActive = 1',{uId=SESSION.userId}));
		if(checkPermission[1].count neq 0)
		{
			try {
				var slack = createObject("component","api.slack");
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
				// var cStatus = (aproveNumber >= 2 ? 1 : ( rejectNumber >= 2 ? -1 : 0 ) ) ;
				var cStatus = (rejectNumber >= 1? -1 :(aproveNumber >= 2 ? 1:0));
				var dateApply = "";
				if( rc.rtype == 1 ){
					var objName = "manageTime" ;
					var curRequest = entityLoadByPk(objName,rc.id);
					if( curRequest.getStatus() == 0 ){
						var userRequest = curRequest.getUser();
						var curUserID = userRequest.getUserID() ;
						var plusType = "" ;
						var plusNumber = curRequest.getnumberDay();
						if( curRequest.getofftype().getID() == 1 ){
							if( curRequest.getStatus() == 1 AND cStatus != 1 ){
								plusType = "divDay" ;
							}else if(curRequest.getStatus() != 1 AND cStatus == 1){
								plusType = "plusDay" ;
								if(curRequest.isNotice == false)
								{
									if(curRequest.isMoreday)
										dateApply = dateFormat(curRequest.startTime,'dd/mm/yyyy')& " - " &dateFormat(curRequest.endTime, 'dd/mm/yyyy');
									else
										dateApply = dateFormat(curRequest.startTime,'dd/mm/yyyy');

									var msgSlack = "";
									if(plusNumber == 0.5)
									{
										msgSlack = userRequest.Firstname & " " &  userRequest.Lastname & " have off half day on the date : "&dateApply
									}else{
										msgSlack = userRequest.Firstname & " " &  userRequest.Lastname & " have off on the date: "&dateApply
									}

									var msgBody = "*Reason*: "&curRequest.reason&" \n*Type*: Annual Leave" ;
									
									var channel = "##days-off";
										slack.postMessage(channel = channel,title = msgSlack,text = msgBody);
									// var attachments = [{
									// 		"color": "##36a64f",
						   // 		 			 "title": msgSlack,
									// 		 "title_link": "http://ticket.rasia.systems/index.cfm/manager.annual_Leave",
						   //         			 "text": "*Reason*: "&curRequest.reason&" \n*Type*: Annual Leave",
						   //         			 "mrkdwn_in": ["text", "pretext"]
						   // 		 		}];
									// sendSlackMsg('days-off',serializeJSON(attachments));
									curRequest.setIsNotice(true);
								}
							}

						}else{
							if( curRequest.getStatus() == 1 AND cStatus != 1 ){
								plusType = "plusOvertime" ;
							}else if(curRequest.getStatus() != 1 AND cStatus == 1){
								if(curRequest.isNotice == false)
								{
									var dateApply = "";
									if(curRequest.isMoreday){
										dateApply = dateFormat(curRequest.startTime,'dd/mm/yyyy')& " - " &dateFormat(curRequest.endTime, 'dd/mm/yyyy');
									}else{
										dateApply = dateFormat(curRequest.startTime,'dd/mm/yyyy') & " (#curRequest.startHour# : #curRequest.endHour#)";
									}

									var msgSlack = "";
									if(plusNumber == 0.5)
									{
										msgSlack = userRequest.Firstname & " " &  userRequest.Lastname & " have off half day on the date : "&dateApply;
									}else{
										msgSlack = userRequest.Firstname & " " &  userRequest.Lastname & " have off on the date: "&dateApply;
									}

									var msgBody = "*Reason*: "&curRequest.reason&" \n*Type*: Use Overtimes" ;
									
									var channel = "##days-off";
										slack.postMessage(channel = channel,title = msgSlack,text = msgBody);

									curRequest.setIsNotice(true);
								}
								plusType = "divOvertime" ;
							}
						}
					}else{
						return variables.fw.renderData("json",{'msg':false,'stt':'OOP! This request is locked.'});
					}
				}else{
					var objName = "overtime_request" ;
					var curRequest = entityLoadByPk(objName,rc.id);
					dateApply = dateFormat(curRequest.getrequestTime(),"dd/mm/yyyy");
					if( curRequest.getStatus() == 0 ){
						var curUserID = curRequest.getUserID() ;
						var plusType = "" ;
						var plusNumber = curRequest.getHours();
						if( curRequest.getStatus() == 1 AND cStatus != 1){
							plusType = "divOvertime" ;
						}else if(curRequest.getStatus() != 1 AND cStatus == 1){
							plusType = "plusOvertime" ;
						}
					}else{
						return variables.fw.renderData("json",{'msg':false,'stt':'OOP! This request is locked.'});
					}
				}
				var curDayoffUser = entityLoad("dayoff",{userId : curUserID } , true );
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
				if( curRequest.getStatus() == 0 AND cStatus != 0){
					getUser = entityLoadByPk("users",curUserID);
					var channel = getUser.slack;
					if( channel != ""){
						switch(cStatus){
							case 1:
								var msgTitle = "Approve by Manager.";
								var msgBody = "Request on #dateApply# is approved." ;
									slack.postMessage(channel = channel,title = msgTitle,text = msgBody,link = "/index.cfm/annual_Leave");
							break;
							case -1:
								var msgTitle = "Reject by Manager.";
								var msgBody = "Request on #dateApply# is rejected." ;
									slack.postMessage(channel = channel,title = msgTitle,text = msgBody,link = "/index.cfm/annual_Leave",color="danger");
							break;
						}
					}
				}
				curRequest.setStatus( cStatus );
				entitySave( curRequest ) ;
				entitySave( curDayoffUser ) ;
				// end
				return variables.fw.renderData("json",{'msg':true,'stt':cStatus});
			}
			catch(any e) {
				return variables.fw.renderData("json",{'msg':false,'stt':'OOP! Something wrong, Please Try again.'});
			} 
			}else{
				return variables.fw.renderData("json",{'msg':false,'stt':"You don't have permission.!"});
			}
		
	}

	public any function checkin_weekly(struct rc) {
		thisDate = LSDateFormat(now(),'yyyy-mm-dd') ;
		rc.startDate = dateAdd("d", -DayOfWeek(thisDate)+2, thisDate );
		rc.endDate = dateAdd("d", 6, rc.startDate );
		var firstDayOfWeek = dateFormat(rc.startDate , "yyyy-mm-dd");
		var lastDayOfWeek = dateFormat(rc.endDate , "yyyy-mm-dd");
		local.timekeeper = QueryExecute("
									SELECT users.userID, CONCAT(users.firstname,' ', users.lastname) AS name, timekeeper.login, timekeeper.logout, timekeeper.import_date
									FROM timekeeper, users,timekeeper_userid
									WHERE  timekeeper_userid.userid_timekeeper =  timekeeper.userid 
											and timekeeper_userid.userid_ticket =  users.userID 
											and login BETWEEN '#firstDayOfWeek#' AND '#lastDayOfWeek#' 
											and isOfficial =1
									ORDER by users.firstname,timekeeper.login ASC
									");	
		if(timekeeper.recordCount != 0 )
		{
			var userindex = 0;
			var curUser = 0 ;
			var dIndex = 0;
			rc.listweekcheck = [];
			for(it in timekeeper)
			{
				if(it.userid neq curUser){
					userindex ++ ;
					var newUser = {};
					newUser.name = it.name ;
					newUser.wDate = [] ;
					rc.listweekcheck[userindex] = newUser ;
					curUser = it.userid ;
					dIndex = 0;
				}
				dIndex ++ ;
				var beginlunch = dateFormat(it.login, 'dd-mm-yyyy')&' '&'12:00';
				var endlunch = dateFormat(it.login, 'dd-mm-yyyy')&' '&'13:00';
				var haveLunch = 0;
				if( dateDiff('h',it.login,beginlunch) gt 0 AND dateDiff('h',endlunch,it.logout) gt 0)
					haveLunch = 60;
				rc.listweekcheck[userindex].wDate[dIndex] = {
					dDate = it.login,
					login = it.login,
					logout = it.logout,
					logTime = dateDiff("n", it.login, it.logout)-haveLunch,
					percent = round((dateDiff("n", it.login, it.logout)-haveLunch)*100/510,0)>100?100:round((dateDiff("n", it.login, it.logout)-haveLunch)*100/510,0)
				}	
			}
			dtWeekStart = (now() - DayOfWeek( now() ) + 2);
		}
	}

	public any function checkin_monthly(struct rc) {
		rc.userIsoffical = queryToArray(QueryExecute("select Concat(firstname,' ',lastname) as value,userID from users where isOfficial = true and active=true"));
		if(structKeyExists(URL, "id") && structKeyExists(URL, "month"))
		{
			rc.userInfor = QueryExecute("select userID,avatar,CONCAT(firstname,' ',lastname) AS name
													from users Where userID=:userId",{userId=URL.id});
			local.timekeeper = QueryExecute("
									SELECT users.userID, CONCAT(users.firstname,' ', users.lastname) AS name, timekeeper.login, timekeeper.logout, timekeeper.import_date
									FROM timekeeper, users,timekeeper_users
									WHERE  timekeeper_users.userid =  timekeeper.userid 
											and timekeeper_users.userid =  users.userID 
											and year(login) = :year and month(login)=:month  and
											active = 1 and users.userID=:userId
									ORDER by users.firstname,timekeeper.login ASC
									",{year=year(now()),month=URL.month,userId:URL.id});
			if(timekeeper.recordCount != 0 )
			{
				rc.annualLeave = (QueryExecute("select m.isMoreday, m.reason, m.startTime, m.endTime, m.numberDay from manageTime m where m.`status` = 1 and m.userID=:userid and m.typeId = 1
															and month(m.startTime)=:month and Year(m.startTime)=:year",{userid:URL.id,month=URL.month,year=year(now())}));
				rc.sickLeave = (QueryExecute("select m.isMoreday,m.startDate,m.endDate, m.sicknessDay,m.annualDay,m.dueToSickness from urgent_caseoff m where m.user=:userid
															and month(m.startDate)=:month and Year(m.startDate)=:year",{userid:URL.id,month=URL.month,year=year(now())}));
				rc.holiday = QueryExecute("select * from event where month(m.start)=:month and Year(m.start)=:year",{month=URL.month,year=year(now())})
				
				//get event annual leave
				rc.annalList = arrayNew(1);
				ArraySet(rc.annalList,1,31,{'stt':false});
				if(rc.annualLeave.recordCount != 0)
				{
					for(an in rc.annualLeave)
					{
						if(!an.isMoreday)
						{
							var dayAnnual = datePart("d", an.startTime);
							var anR = {
								stt:true,
								startTime:an.startTime,
								reason:an.reason
							}
							rc.annalList[dayAnnual] = anR;
						}
						else
						{
							var nextDay = an.startTime;
							for(var i = 1 ; i<= an.numberDay;i++)
							{
								while(DayOfWeek(nextDay)== 1 || DayOfWeek(nextDay) == 7){
									nextDay = Dateadd('d',1,nextDay);
								};

								var dayAnnual = datePart("d", nextDay);
								var anR = {
									stt:true,
									startTime: nextDay,
									reason:an.reason
								}
								rc.annalList[dayAnnual] = anR;

								nextDay = Dateadd('d',1,nextDay);
								if(DateCompare(an.endTime,nextDay)== -1)
									break;
							}
						}
					}
				}

				//get event sickness Day
				rc.sickList = arrayNew(1);
				ArraySet(rc.sickList,1,31,{'stt':false});
				if(rc.sickLeave.recordCount != 0)
				{
					for(si in rc.sickLeave)
					{
						if(!si.isMoreday)
						{
							var daysick = datePart("d", si.startDate);
							var anR = {
								stt:true,
								startTime:si.startDate,
								reason:si.dueToSickness
							}
							rc.sickList[daysick] = anR;
						}
						else
						{
							var nextDay = si.startDate;
							for(var i = 1 ; i<= (si.annualDay+ si.sicknessDay);i++)
							{
								while(DayOfWeek(nextDay)== 1 || DayOfWeek(nextDay) == 7){
									nextDay = Dateadd('d',1,nextDay);
								};

								var daysick = datePart("d", nextDay);
								var anR = {
									stt:true,
									startTime: nextDay,
									reason:si.dueToSickness
								}
								rc.sickList[daysick] = anR;

								nextDay = Dateadd('d',1,nextDay);
								if(DateCompare(si.endDate,nextDay)== -1)
									break;
							}
						}
					}
				}
				//get event holiday
				// rc.holiday = arrayNew(1);
				// ArraySet(rc.holiday,1,31,{'stt':false});
				// if(rc.holiday.recordCount != 0)
				// {
				// 	for(ho in rc.holiday)
				// 	{
				// 		if(!an.isMoreday)
				// 		{
				// 			var dayAnnual = datePart("d", an.startTime);
				// 			var anR = {
				// 				stt:true,
				// 				startTime:an.startTime,
				// 				reason:an.reason
				// 			}
				// 			rc.holiday[dayAnnual] = anR;
				// 		}
				// 		else
				// 		{
				// 			var nextDay = an.startTime;
				// 			for(var i = 1 ; i<= an.numberDay;i++)
				// 			{
				// 				while(DayOfWeek(nextDay)== 1 || DayOfWeek(nextDay) == 7){
				// 					nextDay = Dateadd('d',1,nextDay);
				// 				};

				// 				var dayAnnual = datePart("d", nextDay);
				// 				var anR = {
				// 					stt:true,
				// 					startTime: nextDay,
				// 					reason:an.reason
				// 				}
				// 				rc.holiday[dayAnnual] = anR;

				// 				nextDay = Dateadd('d',1,nextDay);
				// 				if(DateCompare(an.endTime,nextDay)== -1)
				// 					break;
				// 			}
				// 		}
				// 	}
				// }


				rc.results = ArrayNew(1);
				ArraySet(rc.results,1,31,{'stt':false});
				for(it in timekeeper)
				{
					var beginlunch = CreateDateTime(Year(it.login),Month(it.login),Day(it.login),12,00,00);
					var endlunch = CreateDateTime(Year(it.login),Month(it.login),Day(it.login),13,00,00);
					var haveLunch = 0;
					if( dateDiff('h',it.login,beginlunch) gt 0 AND dateDiff('h',endlunch,it.logout) gt 0)
						haveLunch = 60;
					var dayMonth = DatePart('d',it.login);
					var result= {
						stt:true,
						dDate = it.login,
 						login = it.login,
						logout = it.logout,
						logTime = dateDiff("n", it.login, it.logout)-haveLunch,
						percent = round((dateDiff("n", it.login, it.logout)-haveLunch)*100/510,0)>100?100:round((dateDiff("n", it.login, it.logout)-haveLunch)*100/510,0)
					}
					// ArrayInsertAt(rc.results,dayMonth, result);
					rc.results[dayMonth] = result;
				}
			}
		}
	}
	// scheduler functions
	public function reNotifyRequest(struct rc){
		var requests = entityLoad("manageTime",{status = 0});
		var slack = createObject("component","api.slack");
		for(oRequest in requests) {
			var offType 	= oRequest.getofftype();
			var offTypeName	= offType.getStatusName();
			var user 		= oRequest.getUser();
			var nameUser 	= user.firstname &" "& user.lastname;
			var msgTitle 	= offTypeName&" request from "&nameUser ;
			var dateApply 	= dateFormat(oRequest.getStartTime(),"dddd dd/mm/yyyy");
			var msgBody 	= "*Reason*: "&oRequest.getReason()&" \n*Date apply*: "&dateApply;
			if(oRequest.firstCheck == 0){
				var msgLink = "/index.cfm/annual_Leave##required";
				var leader  = entityLoadByPk("users",oRequest.getFirstCheckUser() );
				var slackID = leader.slack == "" ? leader.slack:"##request";
					writeDump(slackID);
				slack.postMessage(channel = slackID,title = msgTitle,text = msgBody,link=msgLink);
			}else{
				var msgLink = "/index.cfm/manager.annual_Leave";
				var slackList = listToArray(valueList(queryExecute("SELECT slack FROM users WHERE userID in (SELECT userId FROM permissionmanager) AND userID not in (SELECT user FROM checkRequired WHERE required = #oRequest.getID()#) GROUP BY slack").slack ));
				var channel = "##request";
				arrayAppend(slackList,channel);
				for(slackID in slackList) {
					// writeDump(slackID);
					slack.postMessage(channel = slackID,title = msgTitle,text = msgBody,link=msgLink);
				}
			}
		}
   		abort;
	}

	// internal functions
	public string function getTrueDate( string sDate){
		var theDate = arguments.sDate?reReplace(arguments.sDate, "[[:space:]]", "", "ALL"):dateFormat(now(),"dd-mm-yyyy");
		if( findNoCase("-", theDate ) ){
			aDate = listToArray(theDate, "-");
		}else if( findNoCase("/", theDate ) ){
			aDate = listToArray(theDate, "/");
		}else if( findNoCase(".", theDate ) ){
			aDate = listToArray(theDate, ".");
		}else{
			aDate = listToArray(theDate);
		}
		if( arrayLen(aDate) < 3 ){
			return dateFormat(now(),"yyyy-mm-dd");
		}
		if( len(aDate[3]) < 4 ){
			return theDate;
		}
		return aDate[3] &"-"& aDate[2] &"-"& aDate[1];
	}
							
	public function queryToArray(required query inQuery) {
		result = arrayNew(1);
		for(row in inQuery) {
			item = {};
			for(col in queryColumnArray(inQuery)) {
				item[col] = row[col];
			} 
			arrayAppend(result, item);
		}
		return result;
    }

	public any function sdateFormat(required string sDate) {
		var dy=listGetAt(sDate,1,"/");
		var mo=listGetAt(sDate,2,"/");
		var yr=listGetAt(sDate,3,"/");
		return LSDATEFORMAT(createDate(yr,mo,dy),'yyyy-mm-dd');
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
   		var result = httpService.send().getPrefix();
   		return result;
	}
	
	
}