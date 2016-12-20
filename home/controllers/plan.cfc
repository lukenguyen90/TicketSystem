component output="false" displayname=""  {

	public function init(required any fw){
		variables.fw =fw;
		return this;
	}
	function default(struct rc){
		if(SESSION.userType eq 3){
			rc.projects=QueryExecute("SELECT projectID,projectName FROM projects WHERE projectStatusID != 6 ORDER BY projectName");
			rc.users=QueryExecute("SELECT userID,firstname,lastname FROM users WHERE active=1 AND userTypeID = 2");
		}else{
			if(SESSION.userType eq 2){
				rc.projects=QueryExecute("SELECT projectID,projectName FROM projects LEFT JOIN projectUsers ON projectID=projects_projectID WHERE  projectStatusID != 6 AND projectLeadID="&SESSION.userID&" AND users_userID="&SESSION.userID&" ORDER BY projects.projectName");	
				rc.users=QueryExecute("SELECT DISTINCT userID,lastname,firstname FROM users LEFT JOIN projectUsers ON userID=users_userID WHERE users.active = 1 and userTypeID = 2 AND projects_projectID IN (SELECT DISTINCT projects_projectID FROM projectUsers WHERE users_userID = "&SESSION.userID&")");
			}else{
				GetPageContext().getResponse().sendRedirect("/index.cfm/" );		
			}
		}
		
	}
	void function calculator(struct rc){
		rc.query=QueryExecute("SELECT ticketID,date_format(reportDate,'%Y-%m-%d')AS reportDate,date_format(dueDate,'%Y-%m-%d')AS dueDate,estimate FROM tickets WHERE startDate is null");
		for(item in rc.query) {
			var reportDate=item.reportDate;
			var dueDate=item.dueDate;
			if(item.dueDate eq ''){
				dueDate= DateFormat(DateAdd('d',1,reportDate),'yyyy-mm-dd');
			}
			var estimate=item.estimate eq ''?0:item.estimate;
			var uDate=Ceiling(estimate/8);
			var lrd=listToArray(reportDate, "-");
			var reportDate= CreateDate(lrd[1],lrd[2],lrd[3]);
			var led=listToArray(dueDate, "-");
			var dueDate= CreateDate(led[1],led[2],led[3]);
			var nDate=DayOfYear(dueDate)-DayOfYear(reportDate);
			if(nDate-uDate gt 0){
				var startDate=getTrueDate(year(dueDate),month(dueDate),day(dueDate)-uDate);
			}else{
				var startDate=getTrueDate(lrd[1],lrd[2],lrd[3]);
			}
			var start=CreateDate(startDate.year,startDate.month,startDate.day);
			var newStartDate=getTrueDate(year(start),month(start),day(start));
			while(dayOfWeek(start) eq 1 OR dayOfWeek(start) eq 7){
				newStartDate=getTrueDate(year(start),month(start),day(start)-1);
				start=CreateDate(newStartDate.year,newStartDate.month,newStartDate.day);
			}
			if(DayOfYear(start)<DayOfYear(reportDate)){
				start=CreateDate(startDate.year,startDate.month,startDate.day);
				while(dayOfWeek(start) eq 1 OR dayOfWeek(start) eq 7){
					newStartDate=getTrueDate(year(start),month(start),day(start)+1);
					start=CreateDate(newStartDate.year,newStartDate.month,newStartDate.day);
				}
			}
			var temp=getTrueDate(year(start),month(start),day(start)+uDate);
			var endDate=CreateDate(temp.year,temp.month,temp.day);
			if(DayOfYear(endDate)>DayOfYear(dueDate)){
				dueDate= endDate;
			}
			var haveSatSun=false;
			newStartDate=getTrueDate(year(start), month(start),day(start));
			for(var i=DayOfYear(start);i<DayOfYear(dueDate);i++){
				newStartDate=getTrueDate(newStartDate.year, newStartDate.month,newStartDate.day+1);
				var temp=CreateDate(newStartDate.year, newStartDate.month,newStartDate.day);
				if(dayOfWeek(temp) eq 1 OR dayOfWeek(temp) eq 7){
					estimate+=8;
					haveSatSun=true;
				}
			}
			if(haveSatSun){
				uDate=Ceiling(estimate/8);
				var temp=getTrueDate(year(start),month(start),day(start)+uDate);
				dueDate=CreateDate(temp.year,temp.month,temp.day);
			}
			var query=QueryExecute("UPDATE tickets SET 
								dueDate='"&DateFormat(dueDate,"yyyy-mm-dd")&"', 
								startDate='"&DateFormat(start,"yyyy-mm-dd")&"'
								WHERE ticketID="&item.ticketID);
		}
	}
	function getTrueDate(numeric year,numeric month,numeric day){
		var y=year;
		var m=month;
		var d=day;
		numDays=DaysInMonth(CreateDate(y,m,1));
		while(d gt numDays){
			d-=numDays;
			m++;
			while(m gt 12){
				m-=12;
				y++;
			}
			numDays=daysInMonth(CreateDate(y,m,1));
		}
		while(d lt 1){
			m--;
			while(m lt 1){
				m=12+m;
				y--;
			}
			numDays=daysInMonth(CreateDate(y,m,1));
			d=numDays+d;			
		} 
		return {year:y,month:m,day:d};
	}
	function getData(struct rc){
		calculator();
		if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn){
			var whereString="";
			if(structKeyExists(URL,"pId")){
				whereString&=" AND t.projectID="&URL.pId ;
			}
			var result=arrayNew(1);
			var begin1=rc.fYear&"-"&(rc.fMonth>9?rc.fMonth:("0"&rc.fMonth))&"-"&(rc.fDay>9?rc.fDay:("0"&rc.fDay));
			var begin2=rc.fYear&"-"&(rc.fMonth>9?rc.fMonth:("0"&rc.fMonth))&"-"&((rc.fDay+1)>9?(rc.fDay+1):("0"&(rc.fDay+1)));
			var end=rc.tYear&"-"&(rc.tMonth>9?rc.tMonth:("0"&rc.tMonth))&"-"&(rc.tDay>9?rc.tDay:("0"&rc.tDay));

			if(structKeyExists(URL,"user")){
				var users=QueryExecute("SELECT userID,lastname,firstname FROM users WHERE userID = "&URL.user);
			}else{
				if(structKeyExists(URL,"pId")){
					var users=QueryExecute("SELECT DISTINCT userID,lastname,firstname FROM users LEFT JOIN projectUsers ON userID=users_userID WHERE users.active =1 and userTypeID = 2 AND projects_projectID="&URL.pId&" ORDER BY userTypeID ASC");
				}else{
					var users=QueryExecute("SELECT DISTINCT userID,lastname,firstname FROM users LEFT JOIN projectUsers ON userID=users_userID WHERE users.active =1 and userTypeID = 2 AND projects_projectID IN (SELECT DISTINCT projects_projectID FROM projectUsers WHERE users_userID = "&SESSION.userID&") ORDER BY userTypeID ASC");
				}
			}
			// get ticket have duedate < now 
				dbg=createDate(rc.fYear, rc.fMonth, rc.fDay);
				ded=createDate(rc.tYear, rc.tMonth, rc.tDay);
				var whereOverString='';
				if(dayOfYear(now())>=dayOfYear(dbg) AND dayOfYear(now())<=dayOfYear(ded)){
					whereOverString&=" OR (	t.dueDate < '"&begin1&"' AND priorityID != 4 AND (s.statusName = 'Open' OR s.statusName = 'Reopened' OR s.statusName = 'In Progress'  ))" ;
				}
			// end
			for(item in users) {
				var itemUser={id:item.userID,fullname:item.firstname&" "&item.lastname};
				var query=QueryExecute("SELECT ticketID,priorityID,t.code as code,title,p.code as pcode,date_format(startDate,'%Y-%m-%d') AS date,date_format(t.dueDate,'%Y-%m-%d') AS dueDate,estimate,s.color,s.statusName AS status
									FROM tickets t 
									LEFT JOIN status s ON t.statusID=s.statusID 
									LEFT JOIN projects p ON p.projectID = t.projectID
									WHERE assignedUserID="&item.userID&"
										AND ((date_format(startDate,'%Y-%m-%d') 
											BETWEEN '"&begin1&"' 
											AND '"&end&"')
											OR (date_format(t.dueDate,'%Y-%m-%d') 
											BETWEEN '"&begin2&"' 
											AND '"&end&"') 
											OR (startDate < '"&begin2&"'
											AND  t.dueDate >'"&end&"') 
											"&whereOverString&")
										"&whereString&"
									ORDER BY startDate ASC, estimate DESC");
				var itemTickets=arrayNew(1);
				for(ticket in query) {
					if(ticket.date != '' AND ticket.dueDate != ''){
						var startDate=ticket.date;
						var est=ticket.estimate eq ''?0:ticket.estimate;
						var lsd=listToArray(startDate, "-");
						var lbd=listToArray(begin1, "-");
						var ldd=listToArray(ticket.dueDate, "-");
						var start= CreateDate(lsd[1],lsd[2],lsd[3]);
						var begin= CreateDate(lbd[1],lbd[2],lbd[3]);
						var dueDate=CreateDate(ldd[1],ldd[2],ldd[3]);
						if(dayOfYear(start)<dayOfYear(begin)){
							var thisDate=getTrueDate(lsd[1],lsd[2],lsd[3]-1);
							for(var i=dayOfYear(start);i<dayOfYear(begin);i++){
								thisDate=getTrueDate(thisDate.year, thisDate.month,thisDate.day+1);
								var temp=CreateDate(thisDate.year, thisDate.month,thisDate.day);
								if(dayOfWeek(temp) neq 1 AND dayOfWeek(temp) neq 7){
									est-=8;
								}
							}
							startDate=begin1;
						}
						var dateOver = 0;
						if(dayOfYear(dueDate)<=dayOfYear(now()) AND (ticket.status eq  'Open' OR ticket.status eq  'Reopened' OR ticket.status eq  'In Progress')){
							if( ticket.priorityID!=4 AND dayOfYear(now())>=dayOfYear(dbg) AND dayOfYear(now())<=dayOfYear(ded)){
								startDate=dateFormat(now(), 'yyyy-mm-dd');
							}
							dateOver= dayOfYear(now()) - dayOfYear(dueDate);
						}
					   	var itemTicket={id:ticket.ticketID,code:ticket.code, pcode:ticket.pcode, title:ticket.title,date:startDate,estimate:est,status:ticket.color,over:dateOver};
					   	arrayAppend(itemTickets, itemTicket);
					}
						
				}
				var row={user:itemUser,tickets:itemTickets};
				arrayAppend(result, row);
			}
			return variables.fw.renderData("json",result);
		}
		return variables.fw.renderData("json",false);
	}
	function getDetailTicket(struct rc){
		if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn){
			var query=QueryExecute("SELECT code,title,description,projectID,assignedUserID,firstname,lastname,date_format(startDate,'%Y-%m-%d') AS sDate,date_format(dueDate,'%Y-%m-%d') AS dDate,date_format(reportDate,'%Y-%m-%d') AS rDate
									FROM tickets
									LEFT JOIN users 
									ON assignedUserID = userID
									WHERE ticketID="&rc.ticketID);
			var listUsers=QueryExecute("SELECT DISTINCT userID,firstname,lastname 
									FROM projectUsers 
									LEFT JOIN users 
									ON users_userID=userID
									WHERE users.active=1 and projects_projectID="&query.projectID&" AND userID != "&query.assignedUserID)
			var lus=arrayNew(1);
			for(item in listUsers) {
			   	var row={id:item.userID,name:item.firstname&" "&item.lastname};
			   	arrayAppend(lus, row);
			}
			return variables.fw.renderData("json",{
								title:query.code&" "&query.title,
								user:query.firstname&" "&query.lastname,
								lus:lus,
								rd:query.rDate, 
								sd:query.sDate, 
								dd:query.dDate,
								des:query.description});
		}
		return variables.fw.renderData("json",false);
	}
	function changeStartDate(struct rc){
		if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn){
			if(rc.newAssignee neq 0){
				var query=QueryExecute("UPDATE tickets SET 
								assignedUserID="&rc.newAssignee&"
								WHERE ticketID="&rc.ticketID);
			}
			var query=QueryExecute("SELECT estimate,date_format(reportDate,'%Y-%m-%d') AS rDate
									FROM tickets WHERE ticketID="&rc.ticketID);
			var uDate=Ceiling(query.estimate/8);
			lrd=listToArray(query.rDate, "-");
			var reportDate= createDate(lrd[1], lrd[2], lrd[3]);
			lnsd=listToArray(rc.newDate, "-");
			var newStartDate= createDate(lnsd[1], lnsd[2], lnsd[3]);
			if(dayOfYear(newStartDate) lt dayOfYear(reportDate)){
				return variables.fw.renderData("json",false);
			}else{
				var arDueDate=getTrueDate(lnsd[1], lnsd[2], lnsd[3]+uDate);
				var newDueDate=createDate(arDueDate.year, arDueDate.month, arDueDate.day);
				var haveSatSun=false;
				for(var i=DayOfYear(newStartDate);i<DayOfYear(newDueDate);i++){
					arDueDate=getTrueDate(arDueDate.year, arDueDate.month,arDueDate.day+1);
					var temp=CreateDate(arDueDate.year, arDueDate.month,arDueDate.day);
					if(dayOfWeek(temp) eq 1 OR dayOfWeek(temp) eq 7){
						uDate+=1;
						haveSatSun=true;
					}
				}
				if(haveSatSun){
					arDueDate=getTrueDate(lnsd[1], lnsd[2], lnsd[3]+uDate);
					newDueDate=createDate(arDueDate.year, arDueDate.month, arDueDate.day);
				}
				var query=QueryExecute("UPDATE tickets SET 
								dueDate='"&DateFormat(newDueDate,"yyyy-mm-dd")&"', 
								startDate='"&DateFormat(newStartDate,"yyyy-mm-dd")&"'
								WHERE ticketID="&rc.ticketID);
				return variables.fw.renderData("json",true);
			}
		}
		return variables.fw.renderData("json",false);
	}
	public void function stTicketOverSendEmail(struct rc){
		var email = createObject("component", "home.controllers.email");
        var mailBody=email.getTemplate("Over");
		var mailSub=email.getSubject("Over");

		var listOver=QueryExecute("SELECT ticketID,assignedUserID,t.code as code,title,p.code as pcode,t.projectID,p.projectName,email,priorityName,estimate
									FROM tickets t 
									LEFT JOIN projects p ON p.projectID = t.projectID
									LEFT JOIN users u ON t.assignedUserID=u.userID
									LEFT JOIN priority pi ON t.priorityID=pi.priorityID
									WHERE t.priorityID != 4 AND t.dueDate <'"&DateFormat(now(),"yyyy-mm-dd")&"'");
		for(item in listOver) {
		   // send email  			
   			var link = "http://"&CGI.http_host&"/index.cfm/ticket?project="&item.pCode&"&id="&item.code;
   			var projectLink="http://"&CGI.http_host&"/index.cfm/project/?id="&item.projectID;
				mailSub=ReplaceAtt(mailSub,link," ",item.code,item.title,projectLink,item.projectName,item.estimate,item.estimate,"Over ticket");
				mailBody=ReplaceAtt(mailBody,link,mailSub,item.code,item.title,projectLink,item.projectName,item.estimate,item.estimate,"Over ticket");
			sendEmail(item.email,mailSub,mailBody);
			// breate notification
			var getActivities=QueryExecute("SELECT activityID FROM activities WHERE activityName='Over'");
			var cmt='<a href="'&link&'">'&item.code&' Over</a>';
			createNotification(item.assignedUserID, getActivities.activityID, cmt);
		}
		abort;
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
	public void function createNotification(string userID, string activity, string comment){
		if(userID neq "" AND comment neq "")
		var newAction = QueryExecute(sql:"INSERT INTO actions (actionDate,comments,isNew,userID,activityID)
															VALUES(:date,:comments,b'1',#userID#,#activity#)",
			params: {
				date: 		{value = DateFormat(now(),"yyyy-mm-dd") ,CFSQLType='string'},
				comments: 	{value = comment 						,CFSQLType='string'}
				});
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
}