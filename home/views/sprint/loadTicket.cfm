<style type="text/css">
.tk-info{
	text-decoration:underline;
	font-weight: bold;	
}
.tk-content{
	margin-left: 15px;
}
.p{
	margin: 0px 0px 0px;
}
</style>
<cfset request.layout = false />
<cfoutput>
	<div class="row">
		<div class="col-md-12">
			<div class="row"style="margin-left: 5px; margin-bottom: 10px; margin-right: 10px;">
					<div>
			 			<a href="/index.cfm/ticket?id=#rc.oTicket.getcode()#" title="Click to view ticket detail..."><span class="green" style="width: 100%">[#rc.oTicket.getcode()#] #rc.oTicket.gettitle()#</span></a>
			 			<a class="label label-sm" href="/index.cfm/ticket/edit?id=#rc.oTicket.getCode()#" title="Click to edit ticket">
							<i class="ace-icon fa fa-pencil-square-o  bigger-110 icon-on-right"></i> Edit
						</a>
		 			</div>
		 			<div>
		 				<span class="tk-info">Type:</span>
		 				<span>#rc.oTicket.getTicketType().getTypeName()#</span><br>
		 			</div>
		 			<div>
		 				<span class="tk-info">Points:</span>
		 				<span>#rc.oTicket.getPoint()#</span><br>
		 			</div>
		 			<div>
		 				<cfset log = rc.oTicket.Point/2>
		 				<cfset estimate = rc.oTicket.Estimate/2>
		 				<span class="tk-info">Log/Estimate:</span>
		 				<span>#log#/#estimate#</span><br>
		 			</div>
		 			<div>
		 				<span class="tk-info">Assignee:</span>
		 				<span>#rc.oTicket.getAssignedUser().getFirstname()# #rc.oTicket.getAssignedUser().getLastname()#</span><br>
		 			</div>
		 			<div>
		 				<span class="tk-info">Status:</span>
		 				<span>#rc.oTicket.getStatus().getStatusName()#</span><br>
		 			</div>
		 			<div>
		 				<span class="tk-info">Description:</span><br>
		 				<p class="tk-content"style="text-align: justify">#rc.oTicket.getdescription()#</p>
		 			</div>
		 									<!--- attach files --->
		 			<div>
			 			<span class="tk-info">Attach files:</span><br>
			 			<cfset ticketFiles = rc.oTicket.getFiles()>
			 			<cfset var countFile = arrayLen(ticketFiles)>
			 			<cfif countFile LE 0>
			 				<span class="tk-content">None</span><br>
			 			<cfelse>
			 				<ul>
							<cfloop array=#ticketFiles# index="files">
			 					<cfscript>
									var fileNameSplit=listToArray(files.getFileLocation(), '/');
									var name = fileNameSplit[arrayLen(fileNameSplit)];
								</cfscript>
								<li>
				 					<a href="#files.getFileLocation()#" target="_blank" >#name#</a>
								</li>
			 				</cfloop>
			 				</ul>
			 			</cfif>
			 		</div>
		 				<!--- Time entries --->
		 			<div>
			 			<span class="tk-info">Time entry:</span><br>
			 				<cfset ticketEntry = entityLoad("timeEntries",{ticket: rc.oTicket},"entryDate DESC")>
			 				<cfset checkTicketEntry = arrayLen(ticketEntry)>
			 				<cfif checkTicketEntry LE 0>
			 					<span class="tk-content">None</span><br>
			 				<cfelse>
			 					<ul>
			 					<cfloop array=#ticketEntry# index="entry">
				 					<cfset entryUser = entry.getUser()>
				 					<cfset minutes = entry.getMinute() EQ "" ? "00" : entry.getMinute()>
				 					<!--- set ticket value --->
				 					<cfset ticketDate = DateFormat(entry.getEntryDate(), "yyyy-mm-dd")>
				 					<cfset ticketFullname = entryUser.getFirstname()&" "&entryUser.getLastname()>
				 					<cfset ticketHours = entry.getHours()&"h:"&#minutes#&"m">			 					
				 					<cfset ticketDescription = entry.getDescription()>
				 					<li>
		 								<span>
		 									<span class="info">#ticketDate#</span>
		 									<span class="green">#TicketFullname#</span>
		 									<span class="red">log time (#TicketHours#)</span>
		 								</span>
		 								#ticketDescription#
		 							</li>
			 					</cfloop>
			 					<ul>
			 				</cfif>
		 			</div>
							<!--- ticket comment --->
					<div>							
		 				<span class="tk-info">Comments:</span><br>
		 					<!--- Post comment --->
		 				<div>
							<input data-id="#rc.oTicket.getTicketID()#" type="text" placeholder="ctrl + enter to post comment" id="ticketCmt" onKeypress='enterComment(event)' style="width: 243px;margin-top: 10px;margin-bottom: 10px;"/>
		 				</div>
		 				<!--- Load comment --->
						<cfset ticketCmts = entityLoad("ticketcomments",{ticket: rc.oTicket}, "commentDate DESC")>
						<ul id="ticket_comment">
							<cfloop array=#ticketCmts# index="cmt">
								<cfset cmtUser = cmt.getUser()>
				 				<li>
				 					<span class="green">#cmtUser.getFirstname()# #cmtUser.getLastname()#</span>&nbsp;&nbsp;
				 					<span class="info">#DateFormat(#cmt.getCommentDate()#, "yyyy-mm-dd")#</span><br>
				 					#cmt.getComment()#
				 				</li>			
							</cfloop>							
			 			</ul>
		 			</div>

			</div>
		</div>
	</div>
</cfoutput>

