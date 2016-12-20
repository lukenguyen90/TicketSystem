component output="false" displayname=""{
	public function init(){
		return this;
	}
	public any function weekly(struct rc) {
		thisDate = now() ;
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
				var beginlunch = dateFormat(it.login, 'yyyy-mm-dd')&' '&'12:00';
				var endlunch = dateFormat(it.login, 'yyyy-mm-dd')&' '&'13:00';
				var haveLunch = 0;
				if( dateDiff('h',it.login,beginlunch) gt 0 AND dateDiff('h',endlunch,it.logout) gt 0)
					haveLunch = 60;
				rc.listweekcheck[userindex].wDate[dIndex] = {
					dDate = dateFormat(it.login, 'yyyy-mm-dd'),
					login = dateTimeFormat(it.login, 'HH:nn'),
					logout = dateTimeFormat(it.logout, 'HH:nn'),
					logTime = dateDiff("n", it.login, it.logout)-haveLunch
				}	
			}
			dtWeekStart = (now() - DayOfWeek( now() ) + 2);
		}
		// if(rc.timekeeper.recordCount != 0)
		// {					
			
		// 	rc.thisid = 0;
		// 	if(CGI.REQUEST_METHOD EQ "GET")
		// 	{
		// 		if(structKeyExists(rc, "date"))
		// 			thisDate = rc.date;
		// 			rc.starDay = dateFormat(dateAdd("d",- dayOfWeek(thisDate) + 2, thisDate),"yyyy-mm-dd");
		// 			rc.endDay = dateFormat(dateAdd("d",- dayOfWeek(thisDate) + 6, thisDate),"yyyy-mm-dd");
		// 	}			
		// 	if(CGI.REQUEST_METHOD EQ "GET")
		// 	{
		// 		if(structKeyExists(rc, "id"))
		// 			rc.thisid = rc.id;				
		// 	}
		// 	rc.weekCheck = QueryExecute("
		// 		SELECT users.userID, CONCAT(users.firstname,' ', users.lastname) AS name, timekeeper.login, timekeeper.logout, timekeeper.import_date
		// 		FROM timekeeper, users
		// 		WHERE date_format(timekeeper.login, '%Y-%m-%d') between '#rc.starDay#' and '#rc.endDay#' and users.userId in (#rc.thisid#) and timekeeper.userid_ticket = users.userID
		// 		ORDER by users.userId");						
		// 	var userindex = 0;
		// 	var curUser = 0 ;
		// 	var dIndex = 0;
		// 	rc.listweekcheck = [];
		// 	for(it in rc.weekCheck)
		// 	{
		// 		if(it.userid neq curUser){
		// 			userindex ++ ;
		// 			var newUser = {};
		// 			newUser.name = it.name ;
		// 			newUser.wDate = [] ;
		// 			rc.listweekcheck[userindex] = newUser ;
		// 			curUser = it.userid ;
		// 			dIndex = 0;
		// 		}
		// 		dIndex ++ ;
		// 		var beginlunch = dateFormat(it.login, 'yyyy-mm-dd')&' '&'12:00';
		// 		var endlunch = dateFormat(it.login, 'yyyy-mm-dd')&' '&'13:00';
		// 		var haveLunch = 0;
		// 		if( dateDiff('h',it.login,beginlunch) gt 0 AND dateDiff('h',endlunch,it.logout) gt 0)
		// 			haveLunch = 60;
		// 		rc.listweekcheck[userindex].wDate[dIndex] = {
		// 			dDate = dateFormat(it.login, 'yyyy-mm-dd'),
		// 			login = dateTimeFormat(it.login, 'HH:nn'),
		// 			logout = dateTimeFormat(it.logout, 'HH:nn'),
		// 			logTime = dateDiff("n", it.login, it.logout)-haveLunch
		// 		}				
		// 	}			
		// }	
	}
	public any function default(struct rc) {
		rc.listUser = entityLoad('users',{isOfficial:true});

	}
	
	
	
	
}