component accessors="true" {


	variables.repeatType = {
		'none'		: 	0,
	    'eDay'		: 	1,
		'eWeek'		: 	2,
		'eMonth'	: 	3,
		'eYear'		: 	4
	};

	variables.warningType = {
		'none':0,
		'before_15m': 1,
		'before_30m':2,
		'before_1h':3
	};
	variables.timeZone = 5;

	public function init(){
		return this;
	}

	public any function default(struct rc) {

		rc.teams = entityLoad('projects');

		var dayoffs = entityload('managetime',{'status':1});
		var urgentOff = entityLoad('urgent_caseoff',{'isTrash':false});
		var events = entityLoad('event');
		var listUsers = entityload('users');
		rc.data=[];
		/*Load Calendar DayOff*/
		for(item in dayoffs)
		{
			local.eventTitle = item.getUser().getLastname()&" "&item.getUser().getFirstname() & ' off';

			if(!item.isMoreday)
			{
				if(item.timeOff == 'am')
				{
					local.event = {
						'title'	:local.eventTitle & "(8h -> 12h)",
						'start'	: item.startTime,
						'allDay': true,
						'className': 'label-important disabled'
					};
				}else if(item.timeOff == 'pm'){
					local.event = {
						'title'	:local.eventTitle & "(13h -> 18h)",
						'start'	: item.startTime,
						'allDay': true,
						'className': 'label-important disabled'
					};
				}else{
					local.event = {
						'title'	:local.eventTitle & "(All day)",
						'start'	: item.startTime,
						'allDay': true,
						'className': 'label-important disabled'
					};
				}
				arrayAppend(rc.data,local.event);
			}else{
				var nextDay = item.startTime;
				for(var i = 1 ; i<= item.numberDay;i++)
				{
					while(DayOfWeek(nextDay)== 1 || DayOfWeek(nextDay) == 7){
						nextDay = Dateadd('d',1,nextDay);
					};
					local.event = {
						'title'	: local.eventTitle,
						'start'	: nextDay,
						'allDay': true,
						'className': 'label-important disabled'
					};
					arrayAppend(rc.data,local.event);
					nextDay = Dateadd('d',1,nextDay);
					if(DateCompare(item.endTime,nextDay)== -1)
						break;
				}
			}	
		}
		for(item in urgentOff)
		{
			var userOff = entityload('users',{userId:item.user},true);
			if(!isNull(userOff))
			{
				local.eventTitle = userOff.getLastname()&" "&userOff.getFirstname() & ' off';
				if(!item.isMoreday)
				{
					if(item.timeOff == 'am')
					{
						local.event = {
							'title'	:local.eventTitle & "(8h -> 12h)",
							'start'	: item.startDate,
							'allDay': true,
							'className': 'label-important disabled'
						};
					}else if(item.timeOff == 'pm'){
						local.event = {
							'title'	:local.eventTitle & "(13h -> 18h)",
							'start'	: item.startDate,
							'allDay': true,
							'className': 'label-important disabled'
						};
					}else{
						local.event = {
							'title'	:local.eventTitle & "(All day)",
							'start'	: item.startDate,
							'allDay': true,
							'className': 'label-important disabled'
						};
					}
					arrayAppend(rc.data,local.event);
				}else{
					var nextDay = item.startDate;
					for(var i = 1 ; i<= (item.annualDay + item.sicknessDay);i++)
					{
						while(DayOfWeek(nextDay)== 1 || DayOfWeek(nextDay) == 7){
							nextDay = Dateadd('d',1,nextDay);
						};
						local.event = {
							'title'	: local.eventTitle,
							'start'	: nextDay,
							'allDay': true,
							'className': 'label-important disabled'
						};
						arrayAppend(rc.data,local.event);
						nextDay = Dateadd('d',1,nextDay);
						if(DateCompare(item.endDate,nextDay)== -1)
							break;
					}
				}	
			}
			
		}

		/*Load Calendar event*/
		for(item in events)
		{
			if(item.repeatEvent != variables.repeatType.none)
			{
				var maxRepeat = item.endRepeat;
					
				if(dateCompare(maxRepeat, item.start) != -1)
				{
						switch(item.repeatEvent){
							case variables.repeatType.eDay:
								loopEndTime = item.end;
								for(loop=item.start;loop<=maxRepeat; loop=Dateadd('d',1,loop))
								{
									local.event = {
										'title'	:item.title,
										'start'	:loop,
										'end'	:loopEndTime,
										'allDay': item.allDay,
										'className':'label-#item.colorEvent#'
									};
									arrayAppend(rc.data,local.event);
									loopEndTime=Dateadd('d',1,loopEndTime);
								}
							break;

							case variables.repeatType.eWeek:
								loopEndTime = item.end;
								for(loop=item.start;loop<=maxRepeat; loop=Dateadd('d',7,loop))
								{
									local.event = {
										'title'	:item.title,
										'start'	:loop,
										'end'	:loopEndTime,
										'allDay': item.allDay,
										'className':'label-#item.colorEvent#'
									};
									arrayAppend(rc.data,local.event);
									loopEndTime=Dateadd('d',7,loopEndTime);
								}
							break;

							case variables.repeatType.eMonth:
								loopEndTime = item.end;
								for(loop=item.start;loop<=maxRepeat; loop=Dateadd('m',1,loop))
								{
									local.event = {
										'title'	:item.title,
										'start'	:loop,
										'end'	:loopEndTime,
										'allDay': item.allDay,
										'className':'label-#item.colorEvent#'
									};
									arrayAppend(rc.data,local.event);
									loopEndTime=Dateadd('m',1,loopEndTime);
								}
							break;

							case variables.repeatType.eYear:
								loopEndTime = item.end;
								for(loop=item.start;loop<=maxRepeat; loop=Dateadd('yyyy',1,loop))
								{
									local.event = {
										'title'	:item.title,
										'start'	:loop,
										'end'	:loopEndTime,
										'allDay': item.allDay,
										'className':'label-#item.colorEvent#'
									};
									arrayAppend(rc.data,local.event);
									loopEndTime=Dateadd('yyyy',1,loopEndTime);
								}
							break;
						
							default:
							break;
						}
					}
				
			}else{
				local.event = {
					'title'	:item.title,
					'start'	:item.start,
					'end'	:item.end,
					'allDay': item.allDay,
					'className':'label-#item.colorEvent#'
				};
				arrayAppend(rc.data,local.event);
			}
		}

		/*Load birthday of users*/
		for(user in listUsers)
		{
			local.birtdayTitle = "Happy Birthday " & user.firstName & " " & user.lastName;
			maxRepeat = dateAdd("yyyy", 5, Now());
			if(!isNull(user.birthday))
			{
				for(loop=user.birthday;loop<=maxRepeat; loop=Dateadd('yyyy',1,loop))
				{
					local.event = {
						'title'	:birtdayTitle,
						'start'	:loop,
						'allDay': true,
						'className': 'birthday'
					};
					arrayAppend(rc.data,local.event);
				}
			}		
		}

		rc.sdata = serializeJSON(rc.data);
	}

	public any function saveEvent(struct rc) {
		local.event = entityNew('event');
		event.setTitle(rc.title);
		event.setStart(rc.start);
		event.setEnd(rc.end);
		event.setAllDay(rc.allDay);
		event.setrepeatEvent(rc.repeatType);
		event.setWarningType(rc.warningType);
		event.setTeamId(rc.teamId);
		event.setColorEvent(rc.projectColor);
		event.setEndRepeat(rc.endRepeat != 0?rc.dateEndRepeat: DateAdd('yyyy',5,rc.start));
		event.setUserCreated(entityloadByPk('users',SESSION.userId));
		entitySave(event);
		location('/index.cfm/calendar',false);
	}


	public any function scheluled_caledar() {
			/*Reset Notice new day*/
			QueryExecute('Update event set isNotice=0 where repeatEvent<>0 and endRepeat>:now',{now=DateFormat(Now(),"yyyy-mm-dd")});
			/*End reset*/
			local.eventToday = queryToArray(QueryExecute("Select * from event where allDay=1 and ((repeatEvent=:repeatType0 and start=:now) 
				or (repeatEvent=:repeatType1 and endRepeat>:now and start<=:now)
				or (repeatEvent=:repeatType2 and endRepeat>:now and start<=:now and DAYOFWEEK(start) = DAYOFWEEK(:now))
				or (repeatEvent=:repeatType3 and endRepeat>:now and start<=:now and DAY(start) = DAY(:now))
				or (repeatEvent=:repeatType4 and endRepeat>:now and start<=:now and MONTH(start) = MONTH(:now)))",
				{now=DateFormat(Now(),"yyyy-mm-dd"),repeatType0:variables.repeatType.none,
				repeatType1:variables.repeatType.eDay,
				repeatType2:variables.repeatType.eWeek,
				repeatType3:variables.repeatType.eMonth,
				repeatType4:variables.repeatType.eYear,
				}));
			for(item in eventToday) {
					local.projectTeam ="";
					if(item.teamId == 0)
						projectTeam = "general";
					else 
			   			local.projectTeam = QueryExecute("select projecySlackChanel,projectName from projects where projectID=:Id",{Id:item.teamId}).projecySlackChanel;
					if(projectTeam != "")
					{
						var attachments = [{
		   		 			"color": item.colorEvent,
		   		 			 "title": item.title,
		           			 "title_link": "http://ticket.com/index.cfm/calendar",
		           			 "text": "*Time*: "&DateFormat(item.start,"dd-mm-yyyy"),
		           			 "mrkdwn_in": ["text", "pretext"]
	   		 			}];

	   		 			sendSlackMsg(projectTeam, serializeJSON(attachments));
					}
			}

			local.userBirtday = queryToArray(QueryExecute("select firstName,lastName,birthday from users where DAY(birthday)=DAY(:now) and MONTH(birthday)=MONTH(:now)",{now=DateFormat(Now(),"yyyy-mm-dd")}));
			for(user in userBirtday) {
				if(!isNull(user.birthday))
				{
					var attachments = [{
						"color": 'blue',
	   		 			 "title":"Happy Birthday " & user.firstName & " " & user.lastName,
	           			 "title_link": "http://ticket.com/index.cfm/calendar",
	           			 "text": "*Time*: "&DateFormat(user.birthday,"dd-mm-yyyy"),
	           			 "mrkdwn_in": ["text", "pretext"]
			 			}];

						sendSlackMsg('general', serializeJSON(attachments));
				}
			}
			abort;

	}
	
	public any function scheluled_caledar_TimeSpecific() {
		local.nextEvent = queryToArray(QueryExecute("Select * from event where isNotice=0 and allDay=0 and ((repeatEvent=:repeatType0 and start>:now) 
				or (repeatEvent=:repeatType1 and endRepeat>:now and start>:now)
				or (repeatEvent=:repeatType2 and endRepeat>:now and start>:now and DAYOFWEEK(start) = DAYOFWEEK(:now))
				or (repeatEvent=:repeatType3 and endRepeat>:now and start>:now and DAY(start) = DAY(:now))
				or (repeatEvent=:repeatType4 and endRepeat>:now and start>:now and MONTH(start) = MONTH(:now)))",
				{now=dateAdd('h',variables.timeZone,DateTimeFormat(Now(),"yyyy-mm-dd HH:nn:ss")),repeatType0:variables.repeatType.none,
				repeatType1:variables.repeatType.eDay,
				repeatType2:variables.repeatType.eWeek,
				repeatType3:variables.repeatType.eMonth,
				repeatType4:variables.repeatType.eYear,
				}));
		writeDump(local.nextEvent);abort;
		for(event in nextEvent)
		{
			if(event.warningType != variables.warningType.none && !isNull(event.warningType))
			{
				local.projectTeam ="";
				if(event.teamId == 0)
						projectTeam = "general";
				else 
		   			local.projectTeam = QueryExecute("select projecySlackChanel,projectName from projects where projectID=:Id",{Id:event.teamId}).projecySlackChanel;

				local.dateDiff = DateDiff('n',dateAdd('h',variables.timeZone,DateTimeFormat(Now(),"yyyy-mm-dd HH:nn:ss")), ParseDateTime(event.start));
				writeDump(dateDiff);
				switch(event.warningType){
					case variables.warningType.before_15m:
						if(dateDiff <= 15)
						{
							var attachments = [{
			   		 			"color": event.colorEvent,
			   		 			 "title": event.title,
			           			 "title_link": "http://ticket.com/index.cfm/calendar",
			           			 "text": "*Time*: "& DateTimeFormat(item.start,"dd-mm-yyyy HH:nn:ss") & "\n*Notice*:You have "&dateDiff&" minute to prepare" ,
			           			 "mrkdwn_in": ["text", "pretext"]
		   		 			}];
		   		 			sendSlackMsg(projectTeam, serializeJSON(attachments));
		   		 			QueryExecute('Update event set isNotice=1 where Id=:id',{id=event.Id});
						}
					break;

					case variables.warningType.before_30m:
						if(dateDiff <= 30)
						{
							var attachments = [{
			   		 			"color": event.colorEvent,
			   		 			 "title": event.title,
			           			 "title_link": "http://ticket.com/index.cfm/calendar",
			           			 "text": "*Time*: "& DateTimeFormat(item.start,"dd-mm-yyyy HH:nn:ss")& "\n*Notice*:You have "&dateDiff&" minute to prepare",
			           			 "mrkdwn_in": ["text", "pretext"]
		   		 			}];
		   		 			sendSlackMsg(projectTeam, serializeJSON(attachments));
		   		 			QueryExecute('Update event set isNotice=1 where Id=:id',{id=event.Id});
						}
					break;

					case variables.warningType.before_1h:
						if(dateDiff <= 60)
						{
							var attachments = [{
			   		 			"color": event.colorEvent,
			   		 			 "title": event.title,
			           			 "title_link": "http://ticket.com/index.cfm/calendar",
			           			 "text": "*Time*: "& DateTimeFormat(item.start,"dd-mm-yyyy HH:nn:ss")& "\n*Notice*:You have "&dateDiff&" minute to prepare",
			           			 "mrkdwn_in": ["text", "pretext"]
		   		 			}];
		   		 			sendSlackMsg(projectTeam, serializeJSON(attachments));
		   		 			QueryExecute('Update event set isNotice=1 where Id=:id',{id=event.Id});
						}
					break;
				
					default:
					break;
				}
			}
		}
		abort;
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

	function sendSlackMsg(required string channelName, required string attachments) {
		attachments = replace(attachments, "\\n", "\n", 'all');
		var slackUrl = "https://hooks.slack.com/services/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";
		var httpService = new http();
		 httpService.setMethod("POST"); 
   		 httpService.setCharset("utf-8");
   		 httpService.setUrl(slackUrl);  
   		 httpService.addParam(type="formfield",name="payload",value='{
   		 	"attachments": '&attachments&',
   		 	"username":"Event",
   		 	"icon_emoji":":rasia:",
   		 	"channel":"##'&channelName&'"
 		}'); 
   		 httpService.send().getPrefix();
	}
}
