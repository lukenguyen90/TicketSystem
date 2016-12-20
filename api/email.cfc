/**
*
* @file  /E/Work/RDT-DA01/server/railo-ex/webapps/ticket/api/email.cfc
* @author  
* @description
*
*/

component output="false" displayname=""  {

	public function init(){
		return this;
	}
	
	param ticketapi = new api.ticket();
	public string function getTemplate(string type){
		var query=QueryExecute("SELECT container FROM email WHERE emailKey='"&type&"'");
		return query.container;
	}
	public string function getSubject(string type){
		var query=QueryExecute("SELECT subject FROM email WHERE emailKey='"&type&"'");
		return query.subject;
	}
	function sendEmailFromOpenToInprogress(struct ticket, struct project, string listTo){
		var mailBody 	="";
		var totalEntriesTime=QueryExecute("SELECT SUM(hours) AS hours FROM timeentries WHERE ticketID="&ticket.getTicketID());
		var estimate 	= isNull(ticket.getEstimate())?(isNull(ticket.getPoint())?0:(ticket.getPoint()*2)):ticket.getEstimate();
		var link 		= "http://"&CGI.http_host&"/index.cfm/ticket?id="&ticket.getCode();
        var projectLink = "http://"&CGI.http_host&"/index.cfm/project/?id="&project.getProjectID();
		var mailBody 	= getTemplate("Open-In Progress");
	    var mailSub 	= getSubject("Open-In Progress");
	    mailSub 		= ticketapi.ReplaceAtt(mailSub,link," ",ticket.getCode(),ticket.getTitle(),projectLink,project.getProjectName(),estimate,totalEntriesTime.hours," ");
	    mailBody 		= ticketapi.ReplaceAtt(mailBody,link,mailSub,ticket.getCode(),ticket.getTitle(),projectLink,project.getProjectName(),estimate,totalEntriesTime.hours," ");
	    listTo 			= ticketapi.getListToSendEmailByStatusProgress(ticket, project);
	    sendEmail(listTo, mailSub, mailBody);	  
	}

	function sendEmailFromAnotherToResolved(struct ticket, struct project, string listTo){
		var mailBody 	="";
		var totalEntriesTime=QueryExecute("SELECT SUM(hours) AS hours FROM timeentries WHERE ticketID="&ticket.getTicketID());
		var estimate 	= isNull(ticket.getEstimate())?(isNull(ticket.getPoint())?0:(ticket.getPoint()*2)):ticket.getEstimate();

		var link 		= "http://"&CGI.http_host&"/index.cfm/ticket?id="&ticket.getCode();
        var projectLink ="http://"&CGI.http_host&"/index.cfm/project/?id="&project.getProjectID();
        var mailBody 	=getTemplate("In Progress-Resolved");
        var mailSub 	=getSubject("In Progress-Resolved");
        mailSub 		=ticketapi.ReplaceAtt(mailSub,link," ",ticket.getCode(),ticket.getTitle(),projectLink,project.getProjectName(),estimate,totalEntriesTime.hours," ");
	    mailBody 		=ticketapi.ReplaceAtt(mailBody,link,mailSub,ticket.getCode(),ticket.getTitle(),projectLink,project.getProjectName(),estimate,totalEntriesTime.hours," ");       
        var cmt 		='<a href="'&link&'">'&ticket.getCode()&' Resolved</a>';
        var activity 	= entityLoad('activities',{activityName = 'Resolved'},true);
        ticketapi.createNotification(ticket.getReportedUser(), activity, cmt);
        listTo 			= ticketapi.getListToSendEmailByStatusResolved(ticket, project);
	    sendEmail(listTo, mailSub, mailBody);	
	}

	function sendEmailFromResolvedToClosed(struct ticket, struct project, string listTo){
		var mailBody 	="";
		var totalEntriesTime=QueryExecute("SELECT SUM(hours) AS hours FROM timeentries WHERE ticketID="&ticket.getTicketID());
		var estimate 	= isNull(ticket.getEstimate())?(isNull(ticket.getPoint())?0:(ticket.getPoint()*2)):ticket.getEstimate();

		var link 		= "http://"&CGI.http_host&"/index.cfm/ticket?id="&ticket.getCode();
        var projectLink = "http://"&CGI.http_host&"/index.cfm/project/?id="&project.getProjectID();
      	var mailBody 	= getTemplate("Resolved-Closed");
	    var mailSub 	= getSubject("Resolved-Closed");
        mailSub 		= ticketapi.ReplaceAtt(mailSub,link," ",ticket.getCode(),ticket.getTitle(),projectLink,project.getProjectName(),estimate,totalEntriesTime.hours," ");
	    mailBody 		= ticketapi.ReplaceAtt(mailBody,link,mailSub,ticket.getCode(),ticket.getTitle(),projectLink,project.getProjectName(),estimate,totalEntriesTime.hours," ");               
        listTo 			= ticketapi.getListToSendEmailByStatusClosed(ticket, project);
	    sendEmail(listTo, mailSub, mailBody);	
	}

	function sendEmailFromResolvedToReopend(struct ticket, struct project, string listTo){
		var mailBody 	="";
		var totalEntriesTime=QueryExecute("SELECT SUM(hours) AS hours FROM timeentries WHERE ticketID="&ticket.getTicketID());
		var estimate 	= isNull(ticket.getEstimate())?(isNull(ticket.getPoint())?0:(ticket.getPoint()*2)):ticket.getEstimate();

		var link 		= "http://"&CGI.http_host&"/index.cfm/ticket?id="&ticket.getCode();
        var projectLink = "http://"&CGI.http_host&"/index.cfm/project/?id="&project.getProjectID();
      	var mailBody 	= getTemplate("Resolved-Reopened");
	  	var mailSub 	= getSubject("Resolved-Reopened");
        mailSub 	= ticketapi.ReplaceAtt(mailSub,link," ",ticket.getCode(),ticket.getTitle(),projectLink,project.getProjectName(),estimate,totalEntriesTime.hours," ");
	    mailBody 	= ticketapi.ReplaceAtt(mailBody,link,mailSub,ticket.getCode(),ticket.getTitle(),projectLink,project.getProjectName(),estimate,totalEntriesTime.hours," ");               
        var cmt 	='<a href="'&link&'"> '&ticket.getCode()&' Reopened</a>';
        var activity 	= entityLoad('activities',{activityName = 'Reopened'},true);
    	ticketapi.createNotification(ticket.getReportedUser(), activity, cmt);
        listTo 		= ticketapi.getListToSendEmailByStatusReopened(ticket, project);
	    sendEmail(listTo, mailSub, mailBody);	
	}

	function sendEmail(string listto, string emailsubject, string emailbody){	
		if(listto neq "" AND emailsubject neq "" AND emailbody neq ""){
			mailerService = new mail();
			mailerService.setTo(listto); 
	        mailerService.setFrom("tickets@rasia.info"); 
	        mailerService.setSubject(emailsubject); 
	        mailerService.setType("html"); 
	        mailerService.setBody(emailbody); 
	    	mailerService.send(body=emailbody);
	    }
	}
}