component output="false" displayname=""  {

	public function init(required any fw){
		variables.fw =fw;
		return this;
	}

	function default(struct rc)
	{
		rc.rs = arrayNew(1);
		var company = QueryExecute("SELECT * FROM company");
		for (item in company)
		{
			var info = structNew();
			info.companyID = item.companyID;
			info.companyName = item.companyName;
			info.address = item.address;
			info.phone = item.phone;
			info.email = item.email;
			info.description = item.description;
			info.project = arrayNew(1);
			info.users = arrayNew(1);
			var projects = QueryExecute("SELECT * FROM projects WHERE companyID = "&item.companyID&" ORDER BY projectName");
			for (prj in projects)
			{
				var dprj = structNew();
				dprj.projectID = prj.projectID;
				dprj.code = prj.code;
				dprj.projectName = prj.projectName;
				dprj.shortName = prj.shortName;
				arrayAppend(info.project, dprj);
			}
			var pj = "";
			for (var i = 1; i <= projects.recordCount; i++)
			{
				pj = pj & projects.projectID[i];
				if (i < projects.recordCount)
					pj = pj & ",";
			}

			var users = QueryExecute("SELECT * FROM users WHERE companyID = "&item.companyID);
			for (us in users)
			{
				var user = structNew();
				user.userID = us.userID;
				user.name = us.firstname &" "& us.lastname;
				user.avatar = us.avatar;
				arrayAppend(info.users, user);
			}
			if (pj != "")
			{
				var dhours = QueryExecute("SELECT ROUND(SUM( IFNULL(timeentries.hours,0)*60+IFNULL(timeentries.minute,0) ) ) as hours
								FROM company
								LEFT JOIN projects ON projects.companyID = company.companyID
								LEFT JOIN tickets ON projects.projectID = tickets.projectID
								LEFT JOIN timeentries ON tickets.ticketID = timeentries.ticketID
								WHERE projects.projectID IN ("&pj&") AND projects.active = 1
								GROUP BY company.companyID");
				if (LSParseNumber(dhours.hours) > 0)
					info.hour = dhours.hours;
				else info.hour = 0;

				var dticket = QueryExecute("SELECT COUNT(tickets.ticketID) as ticket
								FROM company
								LEFT JOIN projects ON projects.companyID = company.companyID
								LEFT JOIN tickets ON projects.projectID = tickets.projectID
								WHERE projects.projectID IN ("&pj&") AND projects.active = 1
								GROUP BY  company.companyID");
				if (LSParseNumber(dticket.ticket) > 0)
					info.ticket = dticket.ticket;
				else info.ticket = 0;
			}
			else
			{
				info.hour = 0;
				info.ticket = 0;
			}	
			arrayAppend(rc.rs, info);
		}
	}

	function addCompany(struct rc)
	{
		if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn){
			var query = QueryExecute("INSERT INTO company(companyName, address, phone, email, description) 
									VALUES('"&rc.cname&"','"&rc.caddress&"','"&rc.cphone&"', '"&rc.cemail&"', '"&rc.cdescription&"')");
			variables.fw.renderData("text",true);
		}
		else variables.fw.renderData("text",false);
	}

	function detail(struct rc)
	{
		rc.company = QueryExecute("SELECT * FROM company");
		rc.project = QueryExecute("SELECT * FROM projects WHERE companyID = 0 OR companyID is null OR companyID = "&rc.id&" ORDER BY projectName");
		rc.dyears = QueryExecute("SELECT DISTINCT year(tickets.reportDate) AS y FROM tickets
						LEFT JOIN projects ON tickets.projectID = projects.projectID
						WHERE projects.companyID = "&rc.id&"")
		rc.user = QueryExecute("SELECT * FROM users");
		rc.type = QueryExecute("SELECT * FROM tickettypes");
		var companyinfo = QueryExecute("SELECT * FROM company WHERE companyID = "&rc.id);
		rc.data = structNew();
		rc.data.companyID = companyinfo.companyID;
		rc.data.companyName = companyinfo.companyName;
		rc.rs = arrayNew(1);
		if(!structKeyExists(rc, "year"))
			rc.year = dateFormat(now(), 'yyyy')
		var companyPrj = QueryExecute("SELECT * FROM projects WHERE companyID = "&rc.id);
		var overview = QueryExecute("SELECT month(tickets.reportDate) as dindex, date_format(tickets.reportDate, '%M %Y') as dmonth, COUNT(tickets.ticketID) as ticket
						FROM tickets
						LEFT JOIN projects ON tickets.projectID = projects.projectID
						WHERE projects.companyID = "&rc.id&" AND year(tickets.reportDate) = "&rc.year&"
						GROUP BY dmonth");
		var hourOv = QueryExecute("SELECT month(tickets.reportDate) as dindex, date_format(tickets.reportDate, '%M %Y') as dmonth, SUM(timeentries.hours) as hour
						FROM tickets
						LEFT JOIN projects ON tickets.projectID = projects.projectID
						LEFT JOIN timeentries ON timeentries.ticketID = tickets.ticketID
						WHERE projects.companyID = "&rc.id&" AND year(tickets.reportDate) = "&rc.year&"
						GROUP BY dmonth");
		for (item in overview)
		{
			var dq = structNew();
			dq.ticket = structNew();
			dq.hours = structNew();
			dq.paid = arrayNew(1);
			dq.index = item.dindex;
			dq.month = item.dmonth;
			dq.ticket.sum = item.ticket;
			dq.ticket.detail = arrayNew(1);
			dq.hours.sum = 0;
			dq.hours.detail = arrayNew(1);

			var ticketDetail = QueryExecute("SELECT COUNT(tickets.ticketID) as ticket, tickets.projectID, projects.projectName, projects.code
							FROM tickets
							LEFT JOIN projects ON tickets.projectID = projects.projectID
							WHERE projects.companyID = "&rc.id&" AND month(tickets.reportDate) = "&item.dindex&" AND year(tickets.reportDate) = "&rc.year&"
							GROUP BY projects.projectID");
			var hourDetail = QueryExecute("SELECT SUM(timeentries.hours) as hour, tickets.projectID, projects.projectName, projects.code
							FROM tickets
							LEFT JOIN projects ON tickets.projectID = projects.projectID
							LEFT JOIN timeentries ON timeentries.ticketID = tickets.ticketID
							WHERE projects.companyID = "&rc.id&" AND month(tickets.reportDate) = "&item.dindex&" AND year(tickets.reportDate) = "&rc.year&"
							GROUP BY projects.projectID");
			var dpaid = QueryExecute("SELECT month(paidDate) as dindex, paid.projectID, projects.projectName, projects.code
							FROM paid 
							LEFT JOIN projects ON projects.projectID = paid.projectID
							WHERE paid.companyID = "&rc.id&" AND month(paidDate) = "&item.dindex&" AND year(paidDate) = "&rc.year);
			for (tk in ticketDetail)
			{
				var tktmp = structNew();
				tktmp.projectID = tk.projectID;
				tktmp.code = tk.code;
				tktmp.projectName = tk.projectName;
				tktmp.ticket = tk.ticket;
				arrayAppend(dq.ticket.detail, tktmp);
			}

			for (tk in hourDetail)
			{
				var tktmp = structNew();
				tktmp.projectID = tk.projectID;
				tktmp.code = tk.code;
				tktmp.projectName = tk.projectName;
				tktmp.hour = tk.hour;
				arrayAppend(dq.hours.detail, tktmp);
			}

			for(dpd in dpaid)
			{
				var ptmp = structNew();
				ptmp.projectID = dpd.projectID;
				ptmp.projectName = dpd.projectName;
				ptmp.monthPaid = dpd.dindex;
				arrayAppend(dq.paid, ptmp);
			}

			arrayAppend(rc.rs, dq);
		}

		for (var i = 1; i <= overview.recordCount; i++)
		{
			if (rc.rs[i].index == hourOv.dindex[i])
				if (hourOv.hour[i] > 0)
					rc.rs[i].hours.sum = hourOv.hour[i];
		}
	}

	function load(struct rc)
	{
		rc.rs = arrayNew(1);
		if(!structKeyExists(URL, "year"))
			URL.year = dateFormat(now(), "yyyy");
		if(!structKeyExists(URL, "type"))
			URL.type = 0;
		var companyPrj = QueryExecute("SELECT * FROM projects WHERE companyID = "&URL.id);
		var overview = QueryExecute("SELECT month(tickets.reportDate) as dindex, date_format(tickets.reportDate, '%M %Y') as dmonth, COUNT(tickets.ticketID) as ticket
						FROM tickets
						LEFT JOIN projects ON tickets.projectID = projects.projectID
						WHERE projects.companyID = "&URL.id&" AND tickets.ticketTypeID IN ("&URL.type&") AND year(tickets.reportDate) IN ("&URL.year&")
						GROUP BY dmonth");
		var hourOv = QueryExecute("SELECT month(tickets.reportDate) as dindex, date_format(tickets.reportDate, '%M %Y') as dmonth, SUM(timeentries.hours) as hour
						FROM tickets
						LEFT JOIN projects ON tickets.projectID = projects.projectID
						LEFT JOIN timeentries ON timeentries.ticketID = tickets.ticketID
						WHERE projects.companyID = "&URL.id&" AND tickets.ticketTypeID IN ("&URL.type&") AND year(tickets.reportDate) IN ("&URL.year&")
						GROUP BY dmonth");
		for (item in overview)
		{
			var dq = structNew();
			dq.ticket = structNew();
			dq.hours = structNew();
			dq.paid = arrayNew(1);
			dq.index = item.dindex;
			dq.month = item.dmonth;
			dq.ticket.sum = item.ticket;
			dq.ticket.detail = arrayNew(1);
			dq.hours.sum = 0;
			dq.hours.detail = arrayNew(1);

			var ticketDetail = QueryExecute("SELECT COUNT(tickets.ticketID) as ticket, tickets.projectID, projects.projectName, projects.code
							FROM tickets
							LEFT JOIN projects ON tickets.projectID = projects.projectID
							WHERE projects.companyID = "&URL.id&" AND tickets.ticketTypeID IN ("&URL.type&") AND month(tickets.reportDate) = "&item.dindex&" AND year(tickets.reportDate) IN ("&URL.year&")
							GROUP BY projects.projectID");
			var hourDetail = QueryExecute("SELECT SUM(timeentries.hours) as hour, tickets.projectID, projects.projectName, projects.code
							FROM tickets
							LEFT JOIN projects ON tickets.projectID = projects.projectID
							LEFT JOIN timeentries ON timeentries.ticketID = tickets.ticketID
							WHERE projects.companyID = "&URL.id&" AND tickets.ticketTypeID IN ("&URL.type&") AND month(tickets.reportDate) = "&item.dindex&" AND year(tickets.reportDate) IN ("&URL.year&")
							GROUP BY projects.projectID");
			var dpaid = QueryExecute("SELECT month(paidDate) as dindex, paid.projectID, projects.projectName, projects.code
							FROM paid 
							LEFT JOIN projects ON projects.projectID = paid.projectID
							WHERE paid.companyID = "&URL.id&" AND month(paidDate) = "&item.dindex&" AND year(paidDate) IN ("&URL.year&")");
			for (tk in ticketDetail)
			{
				var tktmp = structNew();
				tktmp.projectID = tk.projectID;
				tktmp.code = tk.code;
				tktmp.projectName = tk.projectName;
				tktmp.ticket = tk.ticket;
				arrayAppend(dq.ticket.detail, tktmp);
			}

			for (tk in hourDetail)
			{
				var tktmp = structNew();
				tktmp.projectID = tk.projectID;
				tktmp.code = tk.code;
				tktmp.projectName = tk.projectName;
				tktmp.hour = tk.hour;
				arrayAppend(dq.hours.detail, tktmp);
			}

			for(dpd in dpaid)
			{
				var ptmp = structNew();
				ptmp.projectID = dpd.projectID;
				ptmp.projectName = dpd.projectName;
				ptmp.monthPaid = dpd.dindex;
				arrayAppend(dq.paid, ptmp);
			}

			arrayAppend(rc.rs, dq);
		}

		for (var i = 1; i <= overview.recordCount; i++)
		{
			if (rc.rs[i].index == hourOv.dindex[i])
				if (hourOv.hour[i] > 0)
					rc.rs[i].hours.sum = hourOv.hour[i];
		}

		var shtml = "";
		for (item in rc.rs)
		{
			shtml &= '<tr><td>#item.month#</td>';
			var tmp = '<td>';
			for (subticket in item.ticket.detail)
			{
				tmp &= '<a href="/index.cfm/project/?id=#subticket.projectID#">#subticket.projectName#</a><div class="pull-right">#subticket.ticket#</div><br>'
			}
			tmp &= '<div style="border-bottom: 1px solid ##6fb3e0 "></div><div style="color:##d15b47">Sum tickets <div class="pull-right">#item.ticket.sum#</div></div></td>'
			shtml &= tmp;
			tmp = '<td>';
			for (subhour in item.hours.detail)
			{
				tmp &= '<a href="/index.cfm/project/?id=#subhour.projectID#">#subhour.projectName#</a>';
				if (subhour.hour > 0)
					tmp &= '<div class="pull-right">#subhour.hour#</div><br>';
				else tmp &= '<div class="pull-right">0</div><br>';
			}
			tmp &= '<div style="border-bottom: 1px solid ##6fb3e0 "></div><div style="color:##d15b47">Sum hours <div class="pull-right">#item.hours.sum#</div></div></td>';
			shtml &= tmp;
			shtml &= '<td id="'&dateFormat(item.month,"m")&''&dateFormat(item.month,"yyyy")&'">';
			var dpid = "";
			var dqpid = "";
			for (subticket in item.ticket.detail)
			{
				tmp = "";
				var dpaid = 0;
				dpid = dpid&subticket.projectID&",";
				tmp &= '<a href="/index.cfm/project/?id=#subticket.projectID#">#subticket.projectName#</a> &nbsp;';
				shtml &= tmp;
				for (subpaid in item.paid)
				{
					if (subpaid.projectID == subticket.projectID)
					{
						dpaid = 1;
						break;
					}
					else dqpid = dqpid&subticket.projectID&",";
				}
				shtml &= '<span id="dq#subticket.projectID#'&dateFormat(item.month,"m")&''&dateFormat(item.month,"yyyy")&'">';
				if (dpaid == 1)
					shtml &= '<a class="green"><i class="ace-icon fa fa-check bigger-110 icon-on-right"></i></a></span></br>';
				else{
					shtml &= '<a class="danger mousechange" title="Click to pay" onclick="paidProject(#subticket.projectID#, '&dateFormat(#item.month#,'m')&', '&dateFormat(#item.month#,'yyyy')&')"><i class="ace-icon fa fa-shopping-cart  bigger-110 icon-on-right"></i></a></span></br>';
				}				
			}
			if (dqpid != "")
				dpid = dqpid&"0";
			else
				dpid = dpid&"0";
			if (arrayLen(item.ticket.detail) == arrayLen(item.paid))
				shtml &= '<span id="b'&dateFormat(item.month,"m")&''&dateFormat(item.month,"yyyy")&'" class="label label-success">Paid</span></td></tr>';
			else
				shtml &= '<span id="b'&dateFormat(item.month,"m")&''&dateFormat(item.month,"yyyy")&'" class="label label-primary mousechange" onclick="paidMonth("'&dpid&'", '&dateFormat(item.month,"m")&', '&dateFormat(item.month,"yyyy")&')">Pay for month</span></td></tr>';	
		}
		return VARIABLES.fw.renderData("json",{'htmlstring' : shtml, 'rs' : rc.rs, 'ov' : overview});
	}

	function addProject(struct rc)
	{
		if (CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn)
		{
			var add = QueryExecute("UPDATE projects SET companyID = "&rc.companyID&" WHERE projectID = "&rc.projectID);
		}
		return VARIABLES.fw.renderData("json",true);
	}

	function removePrj(struct rc)
	{
		if (CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn)
		{
			var remove = QueryExecute("UPDATE projects SET companyID = null WHERE projectID = "&rc.projectID);
		}
		return VARIABLES.fw.renderData("json",true);
	}

	function addUser(struct rc)
	{
		if (CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn)
		{
			var add = QueryExecute("UPDATE users SET companyID = "&rc.companyID&" WHERE userID = "&rc.userID);
		}
		return VARIABLES.fw.renderData("json",true);
	}

	function removeUser(struct rc)
	{
		if (CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn)
		{
			var remove = QueryExecute("UPDATE users SET companyID = null WHERE userID = "&rc.userID);
		}
		return VARIABLES.fw.renderData("json",true);
	}

	function paidProject(struct rc)
	{
		var date = dateFormat(createDate(rc.pyear, rc.pmonth, 1),"yyyy-mm-dd");
		if (CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn)
		{
			var paid = QueryExecute("INSERT INTO paid(companyID, projectID, paidDate) 
				VALUES("&rc.companyID&","&rc.projectID&",'"&date&"')");
		}
		return VARIABLES.fw.renderData("json",true);
	}

	function paidMonth(struct rc)
	{		
		if (CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn)
		{
			var dpid = rc.pid.split(",");
			var date = dateFormat(createDate(rc.pyear, rc.pmonth, 1),"yyyy-mm-dd");
			for (item in dpid)
			{
				if(item != 0)
				{
					var paid = QueryExecute("INSERT INTO paid(companyID, projectID, paidDate) 
									VALUES("&rc.companyID&","&item&",'"&date&"')");
				}
			}
		}
		return VARIABLES.fw.renderData("json",true);
	}
}