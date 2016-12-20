component output="false" displayname=""  {

	public function init(required any fw){
		variables.fw =fw;
		return this;
	}

	function default(struct rc) {
		if(structKeyExists(URL,"cm")){
			arrMonth=listToArray(URL.cm, "-");
			rc.currentDate=createDate(arrMonth[1], arrMonth[2], 15);
		}else{
			rc.currentDate=now();
		}
		rc.cYear=year(rc.currentDate);
		rc.cMonth=month(rc.currentDate);
		rc.language = QueryExecute("SELECT * FROM language");
		
		if(structKeyExists(URL,"page")){
			switch(URL.page){
				case "assigned":
					rc.title="List Assigned"
				break;
				case "reported":
					rc.title="List Reported"
				break;
				case "comments":
					rc.title="List Comments"
				break;
				case "actions":
					rc.title="List Actions"
				break;
				case "hours":
					rc.title="List Entry"
				break;
			
				default:
					rc.title="List Projects"
				break;
			}
		}else{
			rc.title="List Projects";
		}
		if(SESSION.userType eq 3){
		rc.users=QueryExecute("
			SELECT userID,username,firstname,lastname,email,ut.userType AS type,endDate,active,isSubscribe, languageId, avatar, languageId,
				(SELECT Count(projects_projectID) FROM projectUsers WHERE users_userID = u.userID ) AS nProjects,
				(SELECT SUM(hours) FROM timeentries t WHERE t.userID = u.userID) AS hours
			FROM users u
			LEFT JOIN usertype ut
			ON u.userTypeID = ut.userTypeID
			");
			if(structKeyExists(URL,"id")){
				rc.thisUserID=URL.id;
			}
		}else{
			rc.thisUserID=SESSION.userID;
		}
		if(structKeyExists(rc,"thisUserID")){
			rc.user=QueryExecute("
				SELECT userID,username,u.notificationID,firstname,lastname,email,ut.userType AS type,endDate,active,isSubscribe, avatar, languageId,
					(SELECT Count(projects_projectID) FROM projectUsers WHERE users_userID = u.userID ) AS projects,
					(SELECT Count(ticketID) FROM tickets WHERE assignedUserID = u.userID ) AS assigned,
					(SELECT Count(ticketID) FROM tickets WHERE reportedByUserID = u.userID ) AS reported,
					(SELECT Count(ticketCommentID) FROM ticketcomments tc WHERE tc.userID = u.userID ) AS comments,
					(SELECT Count(actionID) FROM actions a WHERE a.userID = u.userID ) AS actions,
					(SELECT SUM(hours) FROM timeentries t WHERE t.userID = u.userID) AS hours,
					n.levelNumber AS levelNotification
				FROM users u
				LEFT JOIN usertype ut
				ON u.userTypeID = ut.userTypeID
				LEFT JOIN notification n 
				ON u.notificationID=n.notificationID
				WHERE u.userID="&rc.thisUserID&"
				");
			rc.notifications=getNotifications();
			if(structKeyExists(URL,"cm")){
			arrMonth=listToArray(URL.cm, "-");
				rc.currentDate=createDate(arrMonth[1], arrMonth[2], 15);
			}else{
				rc.currentDate=now();
			}
			rc.cYear=year(rc.currentDate);
			rc.cMonth=month(rc.currentDate);

			rc.charTitle=MonthAsString(Month(rc.currentDate))&" "&year(rc.currentDate);
		// set value for resovldDate
			query=QueryExecute("UPDATE tickets SET resovldDate=dueDate WHERE resovldDate IS NULL AND statusID=5");
		}
		return;
	}
	// get data for Char 2
	function pieChart(struct rc){
		if(structKeyExists(URL,"cm")){
		arrMonth=listToArray(URL.cm, "-");
			rc.currentDate=createDate(arrMonth[1], arrMonth[2], 15);
		}else{
			rc.currentDate=now();
		}
		rc.cYear=year(rc.currentDate);
		rc.cMonth=month(rc.currentDate);

		rc.charTitle=MonthAsString(Month(rc.currentDate))&" "&year(rc.currentDate);
		qCurrentMonth=DateFormat(rc.currentDate,"yyyy-mm");
		queryGetGDData=QueryExecute("SELECT SUM(Bug) AS Bug,SUM(Improvement) AS Improvement,SUM(Newfeature) AS Newfeature,SUM(InternalIssue) AS InternalIssue
										FROM (SELECT case when tt.typeName = 'Bug' then te.hours else 0 end as Bug,
													case when tt.typeName = 'Improvement ' then te.hours else 0 end as Improvement ,
													case when tt.typeName = 'New feature' then te.hours else 0 end as Newfeature,
													case when tt.typeName = 'Internal Issue' then te.hours else 0 end as InternalIssue
												FROM timeentries te
												LEFT JOIN tickets t
												ON te.ticketID=t.ticketID
												LEFT JOIN tickettypes tt 
												ON t.ticketTypeID=tt.ticketTypeID
												WHERE 	userID="&rc.thisUserID&"
												AND 	date_format(entryDate,'%Y-%m') = '"&qCurrentMonth&"'
											) AS te ");
		if(queryGetGDData.recordCount neq 0){
			rc.gdData={Bug:queryGetGDData.Bug,Improvement:queryGetGDData.Improvement,Newfeature:queryGetGDData.Newfeature,InternalIssue:queryGetGDData.InternalIssue};
		}
	}
		// get data for Char Monthly 1
	function basicColumnChart(struct rc){
		if(structKeyExists(URL,"cm")){
			arrMonth=listToArray(URL.cm, "-");
			rc.currentDate=createDate(arrMonth[1], arrMonth[2], 15);
		}else{
			rc.currentDate=now();
		}
		rc.cYear=year(rc.currentDate);
		rc.cMonth=month(rc.currentDate);

		rc.charTitle=MonthAsString(Month(rc.currentDate))&" "&year(rc.currentDate);
		qCurrentMonth=DateFormat(rc.currentDate,"yyyy-mm");
		queryGetGMData=QueryExecute("SELECT date_format(entryDate,'%d') AS date,SUM(hours) AS hours
													FROM (SELECT entryDate AS entryDate,hours
															FROM timeentries 
															WHERE 	userID="&rc.thisUserID&"
															AND 	date_format(entryDate,'%Y-%m') = '"&qCurrentMonth&"'
														) AS resu
													GROUP BY date 
													ORDER BY date ASC");
		queryGetGSData=QueryExecute("SELECT date_format(resovldDate,'%d') AS date,COUNT( DISTINCT ticketID) AS sovld
													FROM (SELECT resovldDate,ticketID
															FROM tickets
															WHERE assignedUserID="&rc.thisUserID&"
															AND 	date_format(resovldDate,'%Y-%m') = '"&qCurrentMonth&"'
														) AS resu 
													GROUP BY date 
													ORDER BY date ASC");
		if(queryGetGMData.recordCount neq 0 OR queryGetGSData.recordCount neq 0){
			var tempArr=arrayNew(1);
				for(var i=1;i<=31;i++){
					row={hours:0,sovld:0};
					tempArr[i]=row;
				}
			for(item in queryGetGMData) {
			   tempArr[item.date].hours=item.hours;
			}
			for(item1 in queryGetGSData) {
			   tempArr[item1.date].sovld=item1.sovld;
			}
			rc.gmData={date:arrayNew(1),hours:arrayNew(1),resovld:arrayNew(1)};
				for(var j=1;j<=31;j++){
					if(tempArr[j].hours neq 0 OR tempArr[j].sovld neq 0){
						arrayAppend(rc.gmData.date, j);
						arrayAppend(rc.gmData.hours, tempArr[j].hours);
						arrayAppend(rc.gmData.resovld, tempArr[j].sovld);
					}
				}
		}		
	}
	function edit(struct rc){
		var id=SESSION.userID;
		if(SESSION.userType eq 3 AND structKeyExists(URL,"id")){
			id=URL.id;
		}
		rc.user=QueryExecute("SELECT * FROM users WHERE userID="&id);
		if(rc.user.recordCount eq 0){
			rc.message="User Not Found!";
		}
		rc.messagePost="";
		if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn){
			if(form.avatar != ""){

				// ImageScaleToFit(form.avatar,150,150);
			    // upload1 = FileUpload(expandpath("/fileupload/avatars/"),form.avatar,"image/jpg","MakeUnique");
				
				UploadAndScaleImg(expandpath("/fileupload/avatars/"),form.avatar,250,250);    
			}
			var query=QueryExecute(sql:'UPDATE users 
				SET username	=:username,
					firstname	=:firstname,
					lastname	=:lastname,
					slack		=:slack,
					languageId 	=:lang
				WHERE  userID =:id',
				params:{
					id :{value= id,CFSQLType='NUMERIC'},
					username :{value= rc.username,CFSQLType='string'},
					firstname :{value= rc.firstname,CFSQLType='string'},
					lastname :{value= rc.lastname,CFSQLType='string'},
					slack :{value= rc.slack,CFSQLType='string'},
					lang :{value = rc.language , CFSQLType='NUMERIC'}
					});
			SESSION.languageId = rc.language ;
			if(rc.newPassword neq ""){
				if(rc.user.password eq hash(rc.OldPassword&rc.user.salt) OR SESSION.userType eq 3){
					var query=QueryExecute(sql:"UPDATE users 
					SET `password`= :password
					WHERE  `userID`= :id",
					params:{
						id :{value= id,CFSQLType='NUMERIC'},
						password :{value= hash(rc.newPassword&rc.user.salt),CFSQLType='string'}
						});
					rc.Smessage="Edit success!";
				}else{
					rc.messagePost&="Password Wrong!";
				}
			}else{
				rc.Smessage="Edit success!";
			}
			rc.user=QueryExecute("SELECT * FROM users WHERE userID="&id);
		}
	}
	function newmember(struct rc){
		if(SESSION.userType eq 3 ){
			if( CGI.REQUEST_METHOD eq "POST" ){
	   			if(isNull(entityLoad("users",{username:rc.username},true))){
	   				if(isNull(entityLoad("users",{email:rc.email},true))){
		   				try{
			   				var type=entityLoadbyPK("userType",LSParseNumber(rc.type) );
			   				var endDate=CreateDate(9999, 1, 1);
			   				var saltpass = hash(createUUID());  				
						   	rc.user = entityNew("users",{
							    firstname	= rc.firstname,
							    lastname 	= rc.lastname,    
							    username 	= rc.username,
							    password 	= hash(rc.hpassword&saltpass),
							    email    	= rc.email,
							    endDate	 	= endDate,
							   	salt        = saltpass,
							    active 		= true,
							    isSubscribe = true,
							    language	= entityLoadbyPK("language",application.languageId ),
							    notification= entityLoadbyPK("notification",3 ),
							    type 		= type,
							});
			   				entitySave(rc.user);
			   				// add user to project 
			   				if ( rc.project neq 0 )
			   				var query = QueryExecute(sql:"INSERT INTO projectUsers (users_userID,projects_projectID) VALUES(:uid,:pid)",
			   							params:{
			   									uid:{value = rc.user.userID , CFSQLType = "NUMERIC" },
			   									pid:{value = rc.project 	, CFSQLType = "NUMERIC" }
			   								});
			   				// create action
			   				var getListUsers=QueryExecute("SELECT userID FROM users u 
			   												LEFT JOIN usertype ut ON u.userTypeID=ut.userTypeID
			   												WHERE ut.userType='Admin'");
			   				var link="http://"&CGI.http_host&"/index.cfm/user?id="&rc.user.getUserID();
			   				var getActivities=QueryExecute("SELECT activityID FROM activities WHERE activityName='Registered'");
							var cmt='<a href="'&link&'"> '&rc.user.getUsername()&' Registered</a>';
							for(item in getListUsers) {
							   var newAction=QueryExecute(sql:"INSERT INTO actions (actionDate,comments,isNew,userID,activityID)
			        															VALUES(:date,:comments,b'1',:user,:activity)",
														params:{
															date:{value=DateFormat(now(),"yyyy-mm-dd"),CFSQLType='string'},
															comments:{value=cmt,CFSQLType='string'},
															user:{value=item.userID,CFSQLType='NUMERIC'},
															activity:{value=getActivities.activityID,CFSQLType='NUMERIC'}
			        									});
							}
							// send email for member
							var emailsubject = "Your account has just created on Ticket System!";
							var mailbody = "<h1>Your Account already created !</h1><h2>Hi #rc.user.firstname# #rc.user.lastname#</h2><ul><li>username : #rc.user.username#</li><li>Password : #rc.password#</li></ul><p>Link : <a href='http://#CGI.HTTP_HOST#/index.cfm/user/edit'>http://#CGI.HTTP_HOST#/</a></p>";
			   				mailerService = new mail();
							mailerService.setTo(rc.user.email);
					        mailerService.setFrom("tickets@rasia.info"); 
					        mailerService.setSubject(emailsubject); 
					        mailerService.setType("html"); 
					        mailerService.setBody(mailbody); 
					    	mailerService.send(body=mailbody);
					    }catch(any e){
					    	rc.message = e.message ;
					    }
		   			}else{
		   				rc.message="Email already have a people to use!";
		   			}
	   			}else{
	    			rc.message="username already have a people to use!";
	   			}
			}
			rc.listProject= QueryExecute("SELECT projectID,projectName FROM projects ORDER BY projectName");
			}else{
				GetPageContext().getResponse().sendRedirect("/index.cfm/user");
			}
	}
	public any function getNotifications(){
		query=QueryExecute('SELECT * FROM notification ORDER BY levelNumber ASC');
		if(query.recordCount eq 0){
			query=setDefaultNotification();
		}
		return query;
	}

	function upload(struct rc){
		//upload1 = FileUpload("/upload/",rc.avatar,"image/jpg","MakeUnique");
		return variables.fw.renderData("json",rc.avatar);
	}

	public any function setDefaultNotification(){
		itemNotification1=entityNew('notification',{
			levelNumber:	1,
			levelString:	'None',
			description:	'No send email'
			});
		itemNotification2=entityNew('notification',{
			levelNumber:	2,
			levelString:	'Min',
			description:	'My related ticket messages'
			});
		itemNotification3=entityNew('notification',{
			levelNumber:	3,
			levelString:	'Normal',
			description:	'All my Project messages'
			});
		itemNotification4=entityNew('notification',{
			levelNumber:	4,
			levelString:	'Max',
			description:	'All Project messages'
			});
		entitySave(itemNotification1);
		entitySave(itemNotification2);
		entitySave(itemNotification3);
		entitySave(itemNotification4);
		ORMFlush();
		query=QueryExecute('SELECT * FROM notification ORDER BY levelNumber ASC');
		return query;
	}

	public any function UploadAndScaleImg(required string filepath,required string field,required numeric fitWidth,required numeric fitHeight ) {
        var id=SESSION.userID;
		if(SESSION.userType eq 3 AND structKeyExists(URL,"id")){
			id=URL.id;
		}
        var result = fileUpload(arguments.filepath,arguments.field, "image/*", "makeUnique");
        if(result.fileWasSaved) {
            var theFile = result.serverdirectory & "/" & result.serverFile;
            if(!isImageFile(thefile)) {
                fileDelete(theFile);
               return false;
            } else {
                var img = imageRead(thefile);
                imageScaleToFit(img, arguments.fitWidth, arguments.fitHeight);
                imageWrite(name:img, destination:theFile, overwrite:true);
                var query=QueryExecute(sql:'UPDATE users 
					SET avatar = :avt
					WHERE  userID =:id',
					params:{
						id :{value= id,CFSQLType='NUMERIC'},
						avt :{value= result.serverfile,CFSQLType='string'}
					});
            }
        } 
    }

	function changeEndDate(struct rc){
		if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn){
			var query=QueryExecute("UPDATE users 
									SET `endDate`='"&DateFormat(rc.endDate,"yyyy-mm-dd")&"' 
									WHERE  `userID`="&id);
			return variables.fw.RENDERDATA("json",true);
		}
		return variables.fw.RENDERDATA("json",false);
	}

	function changeActive(struct rc){
		if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn){
			var query=QueryExecute("UPDATE users 
									SET `active`=b'"&rc.active&"' 
									WHERE  `userID`="&id);
			return variables.fw.RENDERDATA("json",true);
		}
		return variables.fw.RENDERDATA("json",false);
	}

	function changeType(struct rc){
		if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn){
			var query=QueryExecute("UPDATE users 
									SET `userTypeID`= (SELECT userTypeID FROM usertype WHERE userType = '"&rc.type&"')
									WHERE  `userID`="&id);
			return variables.fw.RENDERDATA("json",true);
		}
		return variables.fw.RENDERDATA("json",false);
	}

	function changeSubscribe(struct rc){
		if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn){
			var query=QueryExecute("UPDATE users 
									SET `isSubscribe`= b'"&rc.isSubscribe&"'
									WHERE  `userID`="&id);
			return variables.fw.RENDERDATA("json",true);
		}
		return variables.fw.RENDERDATA("json",false);
	}

	function changeNotification(struct rc){
		if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn){
			var query=QueryExecute("UPDATE users 
									SET `notificationID`= (SELECT notificationID FROM notification WHERE levelNumber= "&rc.newNotification&")
									WHERE  `userID`="&id);
			return variables.fw.RENDERDATA("json",true);
		}
		return variables.fw.RENDERDATA("json",false);
	}
	function load(struct rc){
		var abegin=rc.num*5;
		result=arrayNew(1);
		switch(rc.page){
			case "assigned":
				var tickets=QUERYEXECUTE("
						SELECT ticketID,title,t.description,s.color,statusName,t.code,pj.code AS pCode, pj.projectID as pID
						FROM tickets t
						LEFT JOIN projects pj 
							ON t.projectID=pj.projectID
						LEFT JOIN status s
						ON t.statusID=s.statusID
						WHERE assignedUserID= "&rc.id&"
						ORDER BY t.statusID ASC,priorityID ASC
						LIMIT "&abegin&",5 ");
				for(item in tickets) {
				   row={
				   			url:'href="/index.cfm/ticket?pID='&item.pId&'&id='&item.code&'"',
				   			title:item.title,
				   			description:'<span class="label label-'&item.color&'">'&item.statusName&'</span>'&item.description
				   		};
				   	arrayAppend(result, row);
				}
			break;
			case "reported":
				var tickets=QUERYEXECUTE("
						SELECT ticketID,title,t.description,s.color,statusName,t.code,pj.code AS pCode, pj.projectID as pID
						FROM tickets t
						LEFT JOIN projects pj 
							ON t.projectID=pj.projectID
						LEFT JOIN status s
						ON t.statusID=s.statusID
						WHERE reportedByUserID= "&rc.id&"
						ORDER BY t.statusID ASC,priorityID ASC
						LIMIT "&abegin&",5 ");
				for(item in tickets) {
				   row={
				   			url:'href="/index.cfm/ticket?pID='&item.pID&'&id='&item.code&'"',
				   			title:item.title,
				   			description:'<span class="label label-'&item.color&'">'&item.statusName&'</span>'&item.description
				   		};
				   	arrayAppend(result, row);
				}
			break;
			case "comments":
				var tickets=QUERYEXECUTE("
						SELECT comment,commentDate,t.code,pj.code AS pCode,title, pj.projectID as pid
						FROM ticketcomments tm
						LEFT JOIN tickets t
						 	ON tm.ticketID=t.ticketID
						LEFT JOIN projects pj 
							ON t.projectID=pj.projectID
						WHERE userID= "&rc.id&"
						ORDER BY commentDate DESC
						LIMIT "&abegin&",5 ");
				for(item in tickets) {
				   row={
				   			url:'href="/index.cfm/ticket?pid='&item.pid&'&id='&item.code&'"',
				   			title:item.title,
				   			description:dateFormat(item.commentDate,"yyyy-mm-dd")&" "&item.comment
				   		};
				   	arrayAppend(result, row);
				}
			break;
			// case "actions":
			// 	var tickets=QUERYEXECUTE("
			// 			SELECT actionDate,comments
			// 			FROM actions 
			// 			WHERE userID= "&rc.id&"
			// 			ORDER BY actionDate DESC
			// 			LIMIT "&abegin&",5 ");
			// 	for(item in tickets) {
			// 	   row={
			// 	   			url:" ",
			// 	   			title:monthAsString(Month(item.actionDate))&"-"&DateFormat(item.actionDate,"dd-yyyy"),
			// 	   			description:item.comments
			// 	   		};
			// 	   	arrayAppend(result, row);
			// 	}
			// break;
			case "hours":
				var tickets=QUERYEXECUTE("
						SELECT entryDate,hours,te.description,t.code,pj.code AS pCode,t.title, pj.projectID as pid
						FROM timeentries te 
						LEFT JOIN tickets t
							ON te.ticketID=t.ticketID
						LEFT JOIN projects pj 
							ON t.projectID=pj.projectID
						WHERE userID= "&rc.id&"
						ORDER BY entryDate DESC
						LIMIT "&abegin&",5 ");
				for(item in tickets) {
				   row={
				   			url:'href="/index.cfm/ticket?pid='&item.pid&'&id='&item.code&'"',
				   			title:monthAsString(Month(item.entryDate))&"-"&DateFormat(item.entryDate,"dd-yyyy"),
				   			description:'<span class="blue">'&item.title&':</span> enter '&item.hours&' hours "'&item.description&'"'
				   		};
				   	arrayAppend(result, row);
				}
			break;
		
			default:
				var projects=QUERYEXECUTE("
						SELECT p.projectID,p.projectName,p.Description
						FROM projectUsers pu
						LEFT JOIN projects p
						ON pu.projects_projectID=p.projectID
						WHERE users_userID= "&rc.id&"
						ORDER BY p.dueDate DESC
						LIMIT "&abegin&",5 ");
				for(item in projects) {
				   row={
				   			url:'href="/index.cfm/project?pId='&item.projectID&'"',
				   			title:item.projectName,
				   			description:item.Description
				   		};
				   	arrayAppend(result, row);
				}
			break;
		}
		return variables.fw.renderData("json",result);
	}

	function changeLanguages(struct rc)
	{
		if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn){
			var query=QueryExecute("UPDATE users 
									SET languageId = '"&rc.languageId&"' 
									WHERE  userID = "&rc.id);
			if(rc.id == SESSION.userID)
				SESSION.languageId = rc.languageId;
			variables.fw.renderData("text",true);
		}
		else variables.fw.renderData("text",false);
	}
	
}